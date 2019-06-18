import nsis
import traceback
import sys
import os
import logging
import json
import base64
import binascii


# This script get GECOS CC connection data from configuration files.
#
# IN parameters: None!
#
# OUT parameters:
#  $0 = GECOS CC URL
#  $1 = User
#  $2 = Workstation name
#  $3 = Node name
#

try:
    logging.basicConfig(filename=os.environ["PYLOGFILE"],level=logging.DEBUG)
    logging.info('========== GECOS CC Unlink - Load connection data from files ==============')
    
    from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
    from gecosws_config_assistant.dto.WorkstationData import WorkstationData
    from gecosws_config_assistant.dao.WorkstationDataDAO import WorkstationDataDAO
    from gecosws_config_assistant.dao.GecosAccessDataDAO import GecosAccessDataDAO

    accessDataDao = GecosAccessDataDAO()
    gecosAccessData = accessDataDao.load()
    if gecosAccessData is None:
        logging.error("Error reading c:\\etc\\gcc.control")
        nsis.setvar('4', "Error reading c:\\etc\\gcc.control")
        nsis.setvar('5', "")
        sys.exit()
    
    workstationDataDao = WorkstationDataDAO()
    workstationData = workstationDataDao.load()
    if workstationData is None:
        logging.error("Error reading c:\\etc\\gcc.control or C:\\etc\\pclabel")
        nsis.setvar('4', "Error reading c:\\etc\\gcc.control or C:\\etc\\pclabel")
        nsis.setvar('5', "")
        sys.exit()    
    
    nsis.setvar('0', gecosAccessData.get_url())
    nsis.setvar('1', gecosAccessData.get_login())
    nsis.setvar('2', workstationData.get_name())
    nsis.setvar('3', workstationData.get_node_name())
    
except SystemExit:
    nsis.setvar('6', "error")
    
except:
    nsis.setvar('4', str(sys.exc_info()[0]))
    nsis.setvar('5', str(traceback.format_exc()))
    logging.error(str(sys.exc_info()[0]))
    logging.error(str(traceback.format_exc()))
    raise
