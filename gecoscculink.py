import nsis
import traceback
import sys
import os
import logging
import json
import base64
import binascii
import subprocess
import shutil


def remove_file(filename):
    try:
        if os.path.isfile(filename):
            os.remove(filename)
    except:
        logging.error("Error removing %s file"%(filename))
        logging.error(str(traceback.format_exc()))
        sys.exit()   
    
    return True

def clean_disconnection_files_on_error():
    logging.info("clean_disconnection_files_on_error")
    remove_file('C:\\chef\\validation.pem')

    
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
            sys.exit()    
        
    except:
        logging.error('Error running command: %s'%(cmd))
        logging.error(str(traceback.format_exc()))
        sys.exit()       
    
    
    return True  

# This script unlinks from GECOS CC
#
# IN parameters:
#  $0 = GECOS CC URL
#  $1 = User
#  $2 = Password
#  $3 = Workstation name
#  $4 = Node name
#
# OUT parameters:
#  $6 = true if success
#

try:
    logging.basicConfig(filename=os.environ["PYLOGFILE"],level=logging.DEBUG)
    logging.info('========== GECOS CC unlink ==============')
    
    from gecosws_config_assistant.util.GecosCC import GecosCC
    from gecosws_config_assistant.util.Template import Template
    from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
    from gecosws_config_assistant.dto.WorkstationData import WorkstationData
    from gecosws_config_assistant.dao.WorkstationDataDAO import WorkstationDataDAO
    from gecosws_config_assistant.dao.GecosAccessDataDAO import GecosAccessDataDAO
    from gecosws_config_assistant.firstboot_lib.firstbootconfig import get_data_file

    nsis.setvar('6', "false")
    gecosAccessData = GecosAccessData()
    gecosAccessData.set_url(nsis.getvar('$0'))
    gecosAccessData.set_login(nsis.getvar('$1'))
    gecosAccessData.set_password(nsis.getvar('$2'))
    gecoscc = GecosCC()
    accessDataDao = GecosAccessDataDAO()
    
    workstationData = WorkstationData()
    workstationData.set_name(nsis.getvar('$3'))
    workstationData.set_node_name( nsis.getvar('$4') )

    logging.info('Saving "validation.pem"')
    # Save validation.pem
    if not os.path.isdir(os.path.join('C:\\', 'chef')):
        os.mkdir(os.path.join('C:\\', 'chef'))

    conf = json.loads(os.environ["AUTOCFGJSON"])
    chef_validation_pem = base64.decodestring(conf["chef"]["chef_validation"])

    # Create empty file
    filename = os.path.join('C:\\', 'chef', 'validation.pem')
    fd = open(filename, 'w')
    fd.truncate()
    fd.close()

    # Write the content
    fd = open(filename, 'w')
    fd.write(chef_validation_pem)
    fd.close()

    # Unregister from GECOS Control Center
    logging.info("Unregister computer")
    if not gecoscc.unregister_computer(gecosAccessData, 
            workstationData.get_node_name()):
        logging.info("Can't unregister the computer from GECOS CC")
        clean_disconnection_files_on_error()
        sys.exit()         

        
    # Unlink from Chef
    logging.info("Unlink from Chef")
    
    logging.info("- Set c:\\chef\\client.rb with default values")
    template = Template()
    template.source = get_data_file('templates/client.rb')
    template.destination = 'c:\\chef\\client.rb'
    template.owner = 'root'
    template.group = 'root'
    template.mode = 00644
    template.variables = { 'chef_url':  'CHEF_URL',
                          'chef_admin_name':  'ADMIN_NAME',
                          'chef_node_name':  'NODE_NAME',
                          'INSTDIR': 'INSTALLATION_DIR'}         
                  
    
    if not template.save():
        logging.info("Can't create/modify c:\\chef\\client.rb file")
        clean_disconnection_files_on_error()
        sys.exit()           
        
    logging.info("- Prepare c:\\chef\\knife.rb")
    chef_admin_name = gecosAccessData.get_login()
    chef_url = gecosAccessData.get_url()
    chef_url = chef_url.split('//')[1].split(':')[0]
    chef_url = "https://" + chef_url + '/'        
        
        
    if (conf is not None 
        and conf.has_key("chef")
        and conf["chef"].has_key("chef_url")):
        chef_url = conf["chef"]["chef_server_uri"]
        logging.info("chef_url retrieved from GECOS auto conf")        

    if (conf is not None 
        and conf.has_key("chef")
        and conf["chef"].has_key("chef_admin_name")):
        chef_admin_name = conf["chef"]["chef_admin_name"]
        logging.info("chef_admin_name retrieved from GECOS auto conf")        

    
    template = Template()
    template.source = get_data_file('templates/knife.rb')
    template.destination = 'c:\\chef\\knife.rb'
    template.owner = 'root'
    template.group = 'root'
    template.mode = 00644
    template.variables = { 'chef_url':  chef_url,
                          'chef_admin_name':  chef_admin_name}                

    if not template.save():
        logging.info("Can't create/modify c:\\chef\\knife.rb file")
        clean_disconnection_files_on_error()
        sys.exit()

    logging.info("- Remove control file")
    if not remove_file('c:\\etc\chef.control'):
        logging.info("Can't remove c:\\etc\\chef.control file")
        clean_disconnection_files_on_error()
        sys.exit()

    logging.info("- Remove client.pem")
    if not remove_file('c:\\chef\\client.pem'):
        logging.info("Can't remove c:\\chef\\client.pem file")
        clean_disconnection_files_on_error()
        sys.exit()

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

    # SystemDrive and SystemRoot are required to use sockets
    if 'SystemDrive' in os.environ:
        env['SystemDrive'] = os.environ['SystemDrive']

    if 'SystemRoot' in os.environ:
        env['SystemRoot'] = os.environ['SystemRoot']
        
    if 'USERNAME' in os.environ:
        env['USERNAME'] = os.environ['USERNAME']        

    logging.info('- Deleting node ' + workstationData.get_node_name())
    if not execute_command('C:\\opscode\\chef\\bin\\knife.bat node delete "' + workstationData.get_node_name() + '" -c C:\\chef\\knife.rb -y', env):
        logging.info("Can't delete Chef node")
        clean_disconnection_files_on_error()
        sys.exit()
    
    logging.info('- Deleting client ' + workstationData.get_node_name())
    if not execute_command('C:\\opscode\\chef\\bin\\knife.bat client delete "' + workstationData.get_node_name() + '" -c C:\\chef\\knife.rb -y', env):
        logging.info("Can't delete Chef client")
        clean_disconnection_files_on_error()
        sys.exit()

    # logging.info('- Stop chef client service ')
    # execute_command('service chef-client stop')
    
    
    if not accessDataDao.delete(gecosAccessData):
        logging.info("Can't remove /etc/gcc.control file")
        clean_disconnection_files_on_error()
        sys.exit()   
    
   
    # Clean setup files
    remove_file('C:\\chef\\validation.pem')
    remove_file('C:\\chef\\knife.rb')
    remove_file('C:\\chef\\client.rb')
    remove_file('C:\\etc\\pclabel')
    
    if os.path.isdir('C:\\etc\\chef\\ohai_plugins'):
        shutil.rmtree('C:\\etc\\chef\\ohai_plugins')

    nsis.setvar('6', "true")
    
except SystemExit:
    nsis.setvar('6', "false")
    
except:
    nsis.setvar('4', str(sys.exc_info()[0]))
    nsis.setvar('5', str(traceback.format_exc()))
    logging.error(str(sys.exc_info()[0]))
    logging.error(str(traceback.format_exc()))
    raise
