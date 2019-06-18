# Configuration File For Chef (chef-client)
#

log_level          :info

log_location       STDOUT

ssl_verify_mode    :verify_none

chef_server_url "${chef_url}"

file_cache_path    "${INSTDIR}/cache"

file_backup_path   "${INSTDIR}/backup"

pid_file           "${INSTDIR}/client.pid"

validation_client_name "${chef_admin_name}"

require "${INSTDIR}/data/report-handlers/gecoshandlers"
reporthandler = GECOSReports::StatusHandler.new
report_handlers << reporthandler
exception_handlers << reporthandler

cache_options({ :path => "${INSTDIR}/checksums", :skip_expires => true})
Ohai::Config[:disabled_plugins] =['applications','c','erlang','groovy','java','lua','network_listeners','php','ip_scopes','passwd']

node_name "${chef_node_name}"

