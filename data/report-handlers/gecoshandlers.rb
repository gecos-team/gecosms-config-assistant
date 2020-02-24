require 'json'
require 'rest_client'
require 'chef/log'
require "resolv"
require 'socket'
require 'timeout'

def is_port_open?(ip, port)
  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
end


module GECOSReports
  class StatusHandler < Chef::Handler

    def report
      gcc_control = {}
      
      # TODO! There is no gecosws-chef-snitch-client yet!
      # `gecosws-chef-snitch-client --set-active false`
      
      if File.file?('/etc/gcc.control')
        File.open('/etc/gcc.control', 'r') do |f|
          gcc_control = JSON.load(f)
        end
        begin
          has_conection = false
          tries = 0
          dns_resolver = Resolv::DNS.new()
          domain_or_ip = gcc_control['uri_gcc'].split(':')[1].split('/')[2]
          if domain_or_ip =~ /[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
              # Check the connectivity by checking if the port is open
			  Chef::Log.warn("Ip detected!")
			  
			  # default port
			  port = 80
			  
              protocol = gcc_control['uri_gcc'].split(':')[0]
			  if protocol == 'http'
				Chef::Log.warn("HTTP protocol detected!")
				port = 80
			  end
			  if protocol == 'https'
				Chef::Log.warn("HTTPS protocol detected!")
				port = 443
			  end
				
			  if gcc_control['uri_gcc'].split(':').length == 3
				portStr = gcc_control['uri_gcc'].split(':')[2]
				if portStr.index(/[^0-9]/) > 0
					portStr = portStr[0..(portStr.index(/[^0-9]/)-1)]
				end
				Chef::Log.warn("Port detected: #{portStr}")
				port = portStr.to_i
			  end
			  
              while not has_conection and tries < 10
                if is_port_open?(domain_or_ip, port)
                    has_conection = true
                else
                    sleep(1)
                    tries=tries+1
                    Chef::Log.warn("Connection try #{tries}, failed to connect #{domain_or_ip} on port #{port}")
                end
              end
              
          else
              # Check the connectivity by resolving the IP of the domain name
			  Chef::Log.warn("Domain name detected!")
			  
              while not has_conection and tries < 10
                begin
                    dns_resolver.getaddress(domain_or_ip)
                    has_conection = true
                rescue Resolv::ResolvError => e
                    sleep(1)
                    tries=tries+1
                    Chef::Log.warn("Connection try #{tries}, failed to resolv #{domain_or_ip} with error: #{e.message} and trace #{e.backtrace.inspect}")
                end
              end
          end
          
          if has_conection
            Chef::Log.info(gcc_control)
            # SSL certificate validation (enable by default)
            verify_ssl = true
            if gcc_control.key?('ssl_verify')
                verify_ssl = gcc_control['ssl_verify']
            end

            resource = RestClient::Resource.new(
                gcc_control['uri_gcc'] + '/chef/status/',
                :verify_ssl => verify_ssl)
            response = resource.put :node_id => gcc_control['gcc_nodename'], :gcc_username => gcc_control['gcc_username']
            if not response.code.between?(200,299)
              Chef::Log.error('The GCC URI not response')
            else
              response_json = JSON.load(response.to_str)
              if not response_json['ok']
                Chef::Log.error(response_json['message'])
              end
            end
          else
            Chef::Log.error('there is no connectivity')
          end
        rescue Exception => e
          Chef::Log.error(e.message)
        end
      end
    end
  end
end

