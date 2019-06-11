import nsis
import traceback
import json

# This script extract some data from autonf JSON
#
# IN parameters:
#  NONE
#
# OUT parameters:
#  $1 = version
#  $2 = organization
#  $3 = notes

try:
    conf = json.loads(os.environ["AUTOCFGJSON"])
    
    if ('version' in conf) and (conf['version'] is not None):
        nsis.setvar('1', str(conf['version']))
    else:
        nsis.setvar('1', '')
    
    if ('organization' in conf) and (conf['organization'] is not None):
        nsis.setvar('2', conf['organization'].encode('iso-8859-1'))
    else:
        nsis.setvar('2', '')
        
    if ('notes' in conf) and (conf['notes'] is not None):
        nsis.setvar('3', conf['notes'].encode('iso-8859-1'))
    else:
        nsis.setvar('3', '')

except:
    nsis.setvar('1', str(sys.exc_info()[0]))
    nsis.setvar('2', str(traceback.format_exc()))
    logging.error(str(sys.exc_info()[0]))
    logging.error(str(traceback.format_exc()))    
    raise
