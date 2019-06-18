import nsis
import traceback
import sys
import os
import logging
import json
import base64
import binascii


# This script prepares the setup files
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
    logging.info('========== GECOS CC link - Step 01 ==============')
    
    from gecosws_config_assistant.util.GecosCC import GecosCC
    from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
    from gecosws_config_assistant.dto.WorkstationData import WorkstationData
    from gecosws_config_assistant.dao.WorkstationDataDAO import WorkstationDataDAO

    nsis.setvar('6', "false")
    gecosAccessData = GecosAccessData()
    gecosAccessData.set_url(nsis.getvar('$0'))
    gecosAccessData.set_login(nsis.getvar('$1'))
    gecosAccessData.set_password(nsis.getvar('$2'))
    
    if not os.path.isdir(os.path.join('C:\\', 'etc')):
        os.mkdir(os.path.join('C:\\', 'etc'))
    
    workstationData = WorkstationData()
    workstationData.set_ou(nsis.getvar('$3').decode('iso-8859-1').encode('utf-8'))
    workstationData.set_name(nsis.getvar('$4'))
    workstationData.set_node_name( binascii.hexlify(base64.b64decode(nsis.getvar('$5'))) )
    workstationDataDao = WorkstationDataDAO()

    # Check if exists "C:\chef\client.pem"
    if os.path.isfile(os.path.join('C:\\', 'chef', 'client.pem')):
        logging.error("Already exists a C:\\chef\\client.pem file")
        nsis.setvar('3', "error")
        nsis.setvar('4', "Already exists a C:\\chef\\client.pem file")
        nsis.setvar('5', "")
        sys.exit()    
    
    # Save workstation data
    workstationDataDao.save(workstationData)

    # Check c:\chef directory
    if not os.path.isdir(os.path.join('C:\\', 'chef')):
        os.mkdir(os.path.join('C:\\', 'chef'))

    nsis.setvar('6', "true")
except SystemExit:
    nsis.setvar('6', "false")
    
except:
    nsis.setvar('4', str(sys.exc_info()[0]))
    nsis.setvar('5', str(traceback.format_exc()))
    logging.error(str(sys.exc_info()[0]))
    logging.error(str(traceback.format_exc()))
    raise
