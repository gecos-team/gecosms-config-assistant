import nsis
import traceback
import sys
import os
import logging
import json
import base64
import binascii
import subprocess

debug_mode = False

def remove_file(filename):
    try:
        if os.path.isfile(filename):
            os.remove(filename)
    except:
        logging.error("Error removing %s file"%(filename))
        logging.error(str(traceback.format_exc()))
        return False    
    
    return True

def save_file(filename, filecontent):
    # Check directory
    if not os.path.exists(os.path.dirname(filename)):
        os.makedirs(os.path.dirname(filename))

    # Write the content
    fd = open(filename, 'w')
    fd.write(filecontent)
    fd.close()
    
    return True
    
def clean_connection_files_on_error():
    if debug_mode:
        logging.info("_clean_connection_files_on_error DISABLED FOR DEBUG")
        return
    logging.info("_clean_connection_files_on_error")
    remove_file('C:\\chef\\client.pem')
    remove_file('C:\\chef\\client.rb')
    remove_file('C:\\chef\\knife.rb')
    remove_file('C:\\etc\\chef.control')
    remove_file('C:\\etc\\gcc.control')

    
def execute_command(cmd, my_env={}):
    try:
        p = subprocess.Popen(cmd, shell=True, 
                             stdout=subprocess.PIPE, 
                             stderr=subprocess.STDOUT,
                             env=my_env)
        for line in p.stdout.readlines():
            logging.debug(line)
                
        retval = p.wait()
        if retval != 0:
            logging.error('Error running command: %s'%(cmd))
            return False     
        
    except:
        logging.error('Error running command: %s'%(cmd))
        logging.error(str(traceback.format_exc()))
        return False        
    
    
    return True       
    
# This script links the computer to the Chef server
#
# IN parameters:
#  $0 = GECOS CC URL
#  $1 = User
#  $2 = Password
#  $3 = Selected OU
#  $4 = Workstation name
#  $5 = Node name
#
# OUT parameters:
#  $6 = true if success
#

try:
    logging.basicConfig(filename=os.environ["PYLOGFILE"],level=logging.DEBUG)
    logging.info('========== GECOS CC link - Step 02 ==============')
    
    from gecosws_config_assistant.util.GecosCC import GecosCC
    from gecosws_config_assistant.util.SSLUtil import SSLUtil
    from gecosws_config_assistant.util.GemUtil import GemUtil
    from gecosws_config_assistant.util.Template import Template
    from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
    from gecosws_config_assistant.dto.WorkstationData import WorkstationData
    from gecosws_config_assistant.dao.WorkstationDataDAO import WorkstationDataDAO
    from gecosws_config_assistant.firstboot_lib.firstbootconfig import get_data_file

     # List of GEMS required to run GECOS
    necessary_gems = ['json', 'rest-client', 'activesupport', 'netaddr']
    nsis.setvar('6', "false")
    gecosAccessData = GecosAccessData()
    gecosAccessData.set_url(nsis.getvar('$0'))
    gecosAccessData.set_login(nsis.getvar('$1'))
    gecosAccessData.set_password(nsis.getvar('$2'))
    gecoscc = GecosCC()
    
    workstationDataDao = WorkstationDataDAO()
    workstationData = workstationDataDao.load()

    conf = json.loads(os.environ["AUTOCFGJSON"])
    
    
    
    # Get client.pem from server
    logging.info("Get client.pem from server")
    gecosCC = GecosCC()

    rekey = False
    if (
        gecosCC.is_registered_chef_node(
            gecosAccessData,
            workstationData.get_node_name()
        )
    ):
        # re-register
        rekey = True
        client_pem = gecosCC.reregister_chef_node(
            gecosAccessData,
            workstationData.get_node_name())
    else:
        # register
        client_pem = gecosCC.register_chef_node(
            gecosAccessData,
            workstationData.get_node_name())

    # Check the client_pem data
    if client_pem is False:
        logging.error('There was an error while getting the client certificate')
        if not debug_mode:
            gecosCC.unregister_chef_node(
                gecosAccessData,
                workstationData.get_node_name())
        clean_connection_files_on_error()
        sys.exit()

    # Save Chef client certificate in a PEM file
    if not save_file('c:\\chef\\client.pem', client_pem):
        logging.error("There was an error while saving the client certificate")
        if not debug_mode:
            gecosCC.unregister_chef_node(
                gecosAccessData,
                workstationData.get_node_name())
        clean_connection_files_on_error()
        sys.exit()
    
    
    logging.info("- Create c:\\chef/client.rb")
    
    chef_admin_name = gecosAccessData.get_login()
    
    chef_url = gecosAccessData.get_url()
    chef_url = chef_url.split('//')[1].split(':')[0]
    chef_url = "https://" + chef_url + '/'        

    if (conf is not None
        and conf.has_key("chef")
        and conf["chef"].has_key("chef_server_uri")
        and not 'localhost' in conf["chef"]["chef_server_uri"]):
        chef_url = conf["chef"]["chef_server_uri"]
        logging.debug("chef_url retrieved from GECOS auto conf")

    if (conf is not None
        and conf.has_key("chef")
        and conf["chef"].has_key("chef_admin_name")):
        chef_admin_name = conf["chef"]["chef_admin_name"]
        logging.debug("chef_admin_name retrieved from GECOS auto conf")

    # Check Chef HTTPS certificate
    if chef_url.startswith('https://'):
        # Check server certificate
        sslUtil = SSLUtil()
        if not sslUtil.isServerCertificateTrusted(chef_url):
            if (
                sslUtil.getUntrustedCertificateErrorCode(chef_url) == \
                SSL_R_CERTIFICATE_VERIFY_FAILED
            ):
                # Error code SSL_R_CERTIFICATE_VERIFY_FAILED
                # means that the certificate is not trusted

                sslUtil.getUntrustedCertificateErrorCode(chef_url)
                certificate = sslUtil.getServerCertificate(chef_url)
                info = sslUtil.getCertificateInfo(certificate)

                # TODO: Disable certificate validation without asking
                SSLUtil.disableSSLCertificatesVerification()

            else:
                # Any other error code must be shown
                errormsg = sslUtil.getUntrustedCertificateCause(chef_url)
                logging.debug(
                    "Error connecting to HTTPS server: %s", errormsg)
                if not debug_mode:
                    gecosCC.unregister_chef_node(
                        gecosAccessData,
                        workstationData.get_node_name())
                clean_connection_files_on_error()
                sys.exit()

    template = Template()
    template.source = get_data_file('templates/client.rb')
    template.destination = 'c:\\chef\\client.rb'
    template.owner = 'root'
    template.group = 'root'
    template.mode = 00644
    template.variables = { 'chef_url':  chef_url,
                          'chef_admin_name':  chef_admin_name,
                          'chef_node_name':  workstationData.get_node_name(),
                          'INSTDIR': os.environ["INSTDIR"].replace('\\','/')}
    
    if not template.save():
        logging.error('Error saving c:\\chef\\client.rb')
        clean_connection_files_on_error()
        sys.exit()

    gemUtil = GemUtil()
    # Check installed GEMs
    for gem_name in necessary_gems:
        if not gemUtil.is_gem_intalled(gem_name):
            if not gemUtil.install_gem(gem_name):
                # Error installing a GEM
                logging.error("There was an error while installing a " +
                      "required GEM: " + gem_name)
                clean_connection_files_on_error()
                sys.exit()

    logging.info('- Linking to the chef server ')
    home = ''
    if 'HOME' in os.environ:
        home = os.environ['HOME']
    elif 'USERPROFILE' in os.environ:
        home = os.environ['USERPROFILE']
    
    env = {'LANG': 'es_ES.UTF-8', 'LC_ALL': 'es_ES.UTF-8', 'HOME': home}
    
    if 'USERPROFILE' in os.environ:
        env['USERPROFILE'] = os.environ['USERPROFILE']
        
    if 'HOMEDRIVE' in os.environ:
        env['HOMEDRIVE'] = os.environ['HOMEDRIVE']

    if 'HOMEPATH' in os.environ:
        env['HOMEPATH'] = os.environ['HOMEPATH']

    if 'SystemDrive' in os.environ:
        env['SystemDrive'] = os.environ['SystemDrive']

    if 'SystemRoot' in os.environ:
        env['SystemRoot'] = os.environ['SystemRoot']
        
    if 'USERNAME' in os.environ:
        env['USERNAME'] = os.environ['USERNAME']

    if not execute_command('C:\\opscode\\chef\\bin\\chef-client.bat -j "%s\\base.json"'%(os.path.join(os.environ['INSTDIR'], 'data')), env):
        logging.error("Can't link to chef server")
        clean_connection_files_on_error()
        sys.exit()


    #loggingdebug('- Start chef client service ')
    #execute_command('service chef-client start')
    
    logging.debug('- Create a control file ')
    template = Template()
    template.source = get_data_file('templates/chef.control')
    template.destination = 'C:\\etc\\chef.control'
    template.owner = 'root'
    template.group = 'root'
    template.mode = 00755
    template.variables = { 'chef_url':  chef_url,
                          'chef_admin_name':  chef_admin_name,
                          'chef_node_name':  workstationData.get_node_name()}
    
    if not template.save():
        logging.error("Can't create/modify /etc/chef.control file")
        clean_connection_files_on_error()
        sys.exit()
    
        
    nsis.setvar('6', "true")
except SystemExit:
    nsis.setvar('6', "false")
    
except:
    nsis.setvar('4', str(sys.exc_info()[0]))
    nsis.setvar('5', str(traceback.format_exc()))
    logging.error(str(sys.exc_info()[0]))
    logging.error(str(traceback.format_exc()))
    raise
