import nsis
import traceback
import sys
import os

# This script get the OU names
#
# IN parameters:
#  $0 = GECOS CC URL
#  $1 = User
#  $2 = Password
#  $3 = The OU search pattern
#  $4 = Last OU name returned
#
# OUT parameters:
#  $4 = OU name or "" if no more OUs left
#

try:
    import logging
    logging.basicConfig(filename=os.environ["PYLOGFILE"],level=logging.DEBUG)
    last_ou = nsis.getvar('$4')
    logging.info('========== Get OUs ("'+last_ou+'") ==============')
    
    from gecosws_config_assistant.util.GecosCC import GecosCC
    from gecosws_config_assistant.dto.GecosAccessData import GecosAccessData
    
    
    if last_ou == "":
        # Get OUs from the server and return the first OU name
        gecosAccessData = GecosAccessData()
        gecosAccessData.set_url(nsis.getvar('$0'))
        gecosAccessData.set_login(nsis.getvar('$1'))
        gecosAccessData.set_password(nsis.getvar('$2'))
        gecoscc = GecosCC()
        ou_names = gecoscc.search_ou_by_text(gecosAccessData, nsis.getvar('$3').decode('iso-8859-1').encode('utf-8'))
        if ou_names and (len(ou_names) > 0):
            os.environ["OUNAMES"] = ''
            os.environ["OUIDS"] = ''
            for ou in ou_names:
                # If a name appears twice use only the first one
                if not ou[1].encode('iso-8859-1') + '|' in os.environ["OUNAMES"]:
                    os.environ["OUIDS"] += ou[0] + '|';
                    os.environ["OUNAMES"] += ou[1].encode('iso-8859-1') + '|';
                
            nsis.setvar('4', ou_names[0][1].encode('iso-8859-1'))
        else:
            nsis.setvar('4', "")
            
    else:
        # Get OUs from environ and return the next OU name
        ou_names = os.environ["OUNAMES"].split('|')
        nsis.setvar('4', "")
        next_one = False
        for ou in ou_names:
            if next_one:
                nsis.setvar('4', ou)
                break
                
            if ou == last_ou:
                next_one = True
    
except:
    nsis.setvar('4', str(sys.exc_info()[0]))
    nsis.setvar('5', str(traceback.format_exc()))
    logging.error(str(sys.exc_info()[0]))
    logging.error(str(traceback.format_exc()))
    raise
