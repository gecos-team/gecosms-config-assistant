# gecosms-config-assistant

GECOS Workstation Config Assistant for Microsoft Windows

This tool help administrators to link Windows Worstations to GECOS Control Center.

## Software included
The following software is included:
* Opscode Chef client 12.22 (32 bits)

## Build process
To build this tool you will need the 32 bits versions of:
* Python 2.7 for Windows con los siguientes módulos: certifi
* Py2exe: http://www.py2exe.org (py2exe-X.X.X.win32-py2.7.exe)
* NSIS (Nullsoft Scriptable Install System): http://nsis.sourceforge.net/Main_Page
* NsPython plug-in for Python 2.7: http://nsis.sourceforge.net/NsPython_plug-in
* IpConfig plug-in: http://nsis.sourceforge.net/IpConfig_plugin
* NsisCrypt plug-in: http://nsis.sourceforge.net/NsisCrypt_plug-in
* NSISLog plug-in: http://nsis.sourceforge.net/NSISLog_plug-in
* AccessControl plug-in: http://nsis.sourceforge.net/AccessControl_plug-in

The building process is:
```
python autogen_python.py
makensis main.nsi
```

## Silent install
You must use the following parameters to install the software in silent mode:
* /S (Silent mode flag)
* /URL="[GECOS Control Center URL]"
* /USERNAME="[GECOS Control Center Username]"
* /PASSWORD="[GECOS Control Center Pasword]"
* /OU="[GECOS Control Center OU name]"

For example:
```
gecos.exe /PASSWORD="12345" /OU="MyDepartment" /S
```


## Silent uninstall
You must use the following parameters to uninstall the software in silent mode:
* /S (Silent mode flag)

For example:
```
c:\Program Files\Junta de Andalucia\GECOS\Uninstall.exe /S
```

NOTE: Silent uninstall does not perform unlink the node from the GECOS Control Center, it just delete the connection files.



