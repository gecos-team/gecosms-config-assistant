import nsis
import traceback
import sys
import os

# This scripts check if a workstation name is valid
#
# IN parameters:
#  $0 = GECOS CC URL
#  $1 = User
#  $2 = Password
#  $3 = Workstation name to check
#
# OUT parameters:
#  $4 = true if the URL is valid or false otherwise
#

try:
	import logging
	logging.basicConfig(filename=os.environ["PYLOGFILE"],level=logging.DEBUG)
	logging.info('========== Check workstation name ==============')	
	
	from gecosws_config_assistant.util.GecosCC import GecosCC
	from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
	
	gecosAccessData = GecosAccessData()
	gecosAccessData.set_url(nsis.getvar('$0'))
	gecosAccessData.set_login(nsis.getvar('$1'))
	gecosAccessData.set_password(nsis.getvar('$2'))
	gecoscc = GecosCC()
	computer_names = gecoscc.get_computer_names(gecosAccessData)
	is_in_computer_names = False
	for cn in computer_names:
		if cn['name'] == nsis.getvar('$3'):
			is_in_computer_names = True
			break
	
	nsis.setvar('4', str(is_in_computer_names))
	
except:
	nsis.setvar('4', str(sys.exc_info()[0]))
	nsis.setvar('5', str(traceback.format_exc()))
	logging.error(str(sys.exc_info()[0]))
	logging.error(str(traceback.format_exc()))	
	raise
