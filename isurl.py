import nsis
import traceback
import sys
import os

# This scripts check if a URL is valid
#
# IN parameters:
#  $0 = URL to check
#
# OUT parameters:
#  $4 = true if the URL is valid or false otherwise
#

try:
    from gecosws_config_assistant.util.Validation import Validation
    isurl = Validation().isUrl(nsis.getvar('$0'))
    nsis.setvar('4', str(isurl))
except:
    nsis.setvar('4', str(sys.exc_info()[0]))
    nsis.setvar('5', str(traceback.format_exc()))
    raise
