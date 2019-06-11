;;  vim:syn=winbatch:fileencoding=cp1252:
;;
;;  English.nsh
;;
;;  English language strings for the Windows GECOS NSIS installer.
;;  Windows Code page: 1252
;;
;;  Author: Abraham Macias <amacias@gruposolutia.com>
;;
 
; NetworkInterefacesShow
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CHECK_NETWORK_INTERFACES_HEADER			"Network interfaces"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CHECK_NETWORK_INTERFACES_SUBHEADER		"Check internet connection."

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CHECKING_NETWORK_INTERFACES			"Checking network interfaces..."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_NETWORK_ADAPTERS						"NETWORK ADAPTERS$\r$\n---------------" 
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_NETWORK_ADAPTER_DESCRIPTION			"Description.....:"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_NETWORK_ADAPTER_PHYSICAL_ADDRESS		"Physical Address:"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_NETWORK_ADAPTER_IP_ADDRESS			"IP Address......:"

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_NO_NETWORK_ERROR_MESSAGE				"You need to be connected to internet to install and use GECOS. The installation will stop here! Please connect to internet to install GECOS."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_NO_NETWORK_INTERFACES_FOUND			"No network interfaces found!"


; LoadGECOSCCSetupData
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_CONNECTION_DATA_HEADER			"GECOS Control Center connection data"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_CONNECTION_DATA_SUBHEADER		"Please enter the data to connect to the GECOS Control Center."

!insertmacro GECOS_MACRO_DEFAULT_STRING PLEASE_ENTER_DATA_TO_CONNECT_TO_GECOS			"Please enter the data to connect to the GECOS Control Center."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_CONNECTION_DATA				"GECOS Control Center connection data:"

!insertmacro GECOS_MACRO_DEFAULT_STRING URL				"URL:"
!insertmacro GECOS_MACRO_DEFAULT_STRING USER			"User:"
!insertmacro GECOS_MACRO_DEFAULT_STRING PASSWORD		"Password:"

!insertmacro GECOS_MACRO_DEFAULT_STRING EMPTY_URL		"URL field is empty!"
!insertmacro GECOS_MACRO_DEFAULT_STRING BAD_URL			"Bad URL in URL field!"
!insertmacro GECOS_MACRO_DEFAULT_STRING EMPTY_USER		"User field is empty!"
!insertmacro GECOS_MACRO_DEFAULT_STRING EMPTY_PASSWORD	"Password field is empty!"

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_CONNECTION_ERROR_MESSAGE		"Can't connect to GECOS Control Center! Please double-check the URL, user and password, and your internet connection."

; LoadGECOSCCSetupDataShow
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_AUTOSETUP_DATA_HEADER			"GECOS Control Center autosetup data"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_AUTOSETUP_DATA_SUBHEADER		"Please check the autosetup data received from GECOS Control Center."

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_AUTOSETUP_DATA					"Data obtained from GECOS Control Center:"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_AUTOSETUP_DATA_VERSION			"Version"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_AUTOSETUP_DATA_ORGANIZATION	"Organization"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_AUTOSETUP_DATA_NOTES			"Notes"


; LoadWorkstationData  
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_DATA_HEADER		"Workstation data"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_DATA_SUBHEADER		"Please fill the workstation data."

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_DATA_LABEL			"Please enter the workstation data for the GECOS Control Center."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_NAME				"Workstation name:"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_OU_NAME			"OU name:"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_SEARCH_BUTTON		"Search"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_SELECTED_OU		"Selected OU:"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_CLICK_SEARCH		"Clic the search button"

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_NAME_EMPTY			"The workstation name field is empty!"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_NAME_IN_USE		"This workstation name is in use, please change it!"

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_OU_ERROR			"Please select one OU!"

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_WORKSTATION_NODE_NAME			"Node name:"

; un.UnlinkGECOSCCShow
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_HEADER					"Unlink from GECOS Control Center"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_SUBHEADER				"Please wait while your PC is disconnected from GECOS Control Center."

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_DISCONNECTING			"Disconnecting from GECOS Control Center."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_DISCONNECTION_PROCESS	"Disconnection process..."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_DISCONNECTING_ERROR		"Error unlinking from GECOS!"
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_DISCONNECTING_SUCCESS	"Unlink from GECOS CC sucessful!"

!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_UNINSTAL_CHEF			"Uninstalling Opscode Chef..."
!insertmacro GECOS_MACRO_DEFAULT_STRING GECOS_CC_UNLINK_UNINSTAL_CHEF_SUCCESS	"Opscode Chef uninstaled!"
