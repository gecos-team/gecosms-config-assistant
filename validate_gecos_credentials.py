import nsis
import traceback
import sys
import os

# This scripts check if GECOS CC credentials are valid
# Also stores the JSON in the AUTOCFGJSON environment variable.
#
# IN parameters:
#  $0 = GECOS CC URL
#  $1 = User
#  $2 = Password
#
# OUT parameters:
#  $4 = true if the credentials are valid or false otherwise

try:
	import logging
	logging.basicConfig(filename=os.environ["PYLOGFILE"],level=logging.DEBUG)
	logging.info('========== Validate GECOS credentials ==============')

	
	from gecosws_config_assistant.util.GecosCC import GecosCC
	from gecosws_config_assistant.util.SSLUtil import SSLUtil
	from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
	
	gecosAccessData = GecosAccessData()
	gecosAccessData.set_url(nsis.getvar('$0'))
	gecosAccessData.set_login(nsis.getvar('$1'))
	gecosAccessData.set_password(nsis.getvar('$2'))
	gecoscc = GecosCC()
	
	# TODO: Disable certificate validation without asking
	SSLUtil.disableSSLCertificatesVerification()
	
	isOk = gecoscc.validate_credentials(gecosAccessData)
	nsis.setvar('4', str(isOk))
	
	if gecoscc.last_request_content is not None:
		os.environ["AUTOCFGJSON"] = gecoscc.last_request_content

except:
	nsis.setvar('4', str(sys.exc_info()[0]))
	nsis.setvar('5', str(traceback.format_exc()))
	logging.error(str(sys.exc_info()[0]))
	logging.error(str(traceback.format_exc()))
	raise