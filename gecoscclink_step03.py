import nsis
import traceback
import sys
import os
import logging
import json
import base64
import binascii
import subprocess


def remove_file(filename):
    try:
        if os.path.isfile(filename):
            os.remove(filename)
    except:
        logging.error("Error removing %s file"%(filename))
        logging.error(str(traceback.format_exc()))
        return False    
    
    return True

def clean_connection_files_on_error():
    logging.info("_clean_connection_files_on_error DISABLED FOR DEBUG")
    return

    logging.info("_clean_connection_files_on_error")
    remove_file('C:\\chef\\client.pem')
    remove_file('C:\\chef\\client.rb')
    remove_file('C:\\chef\\knife.rb')
    remove_file('C:\\etc\\chef.control')
    remove_file('C:\\etc\\gcc.control')

    
# This script links the computer to the GECOS CC server
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
    logging.info('========== GECOS CC link - Step 03 ==============')
    
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
    
    workstationDataDao = WorkstationDataDAO()
    workstationData = workstationDataDao.load()

    conf = json.loads(os.environ["AUTOCFGJSON"])
    
    
    # Register into GECOS Control Center
    logging.info('- register into GECOS CC ')
    ou = gecoscc.search_ou_by_text(gecosAccessData, workstationData.get_ou())
    
    if not gecoscc.register_computer(gecosAccessData, 
            workstationData.get_node_name(), ou[0][0]):
        logging.error("Can't register the computer in GECOS CC")
        clean_connection_files_on_error()
        sys.exit()
      
    

    if not accessDataDao.save(gecosAccessData):
        logging.error("Can't save c:\\etc\\gcc.control file")
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
