;;  vim:syn=winbatch:fileencoding=cp1252:
;;
;;  English.nsh
;;
;;  English language strings for the Windows GECOS NSIS installer.
;;  Windows Code page: 1252
;;
;;  Author: Abraham Macias <amacias@gruposolutia.com>
;;
 
!define DIFFERENT_CHEF_VERSION_MESSAGE				"A different version of Opscode Chef is installed. $\n$\nClick `OK` to remove this version or `Cancel` to cancel this installation."


; NetworkInterefacesShow
!define GECOS_CHECK_NETWORK_INTERFACES_HEADER			"Network interfaces"
!define GECOS_CHECK_NETWORK_INTERFACES_SUBHEADER		"Check internet connection."

!define GECOS_CHECKING_NETWORK_INTERFACES			"Checking network interfaces..."
!define GECOS_NETWORK_ADAPTERS						"NETWORK ADAPTERS$\r$\n---------------"
!define GECOS_NETWORK_ADAPTER_DESCRIPTION			"Description.....:"
!define GECOS_NETWORK_ADAPTER_PHYSICAL_ADDRESS		"Physical Address:"
!define GECOS_NETWORK_ADAPTER_IP_ADDRESS			"IP Address......:"

!define GECOS_NO_NETWORK_ERROR_MESSAGE				"You need to be connected to internet to install and use GECOS. The installation will stop here! Please connect to internet to install GECOS."
!define GECOS_NO_NETWORK_INTERFACES_FOUND			"No network interfaces found!"

 
; LoadGECOSCCSetupData
!define GECOS_CC_CONNECTION_DATA_HEADER			"GECOS Control Center connection data"
!define GECOS_CC_CONNECTION_DATA_SUBHEADER		"Please enter the data to connect to the GECOS Control Center."

!define PLEASE_ENTER_DATA_TO_CONNECT_TO_GECOS	"Please enter the data to connect to the GECOS Control Center."
!define GECOS_CC_CONNECTION_DATA				"GECOS Control Center connection data:"


!define URL				"URL:"
!define USER			"User:"
!define PASSWORD		"Password:"

!define EMPTY_URL		"URL field is empty!"
!define BAD_URL			"Bad URL in URL field!"
!define EMPTY_USER		"User field is empty!"
!define EMPTY_PASSWORD	"Password field is empty!"

!define GECOS_CC_CONNECTION_ERROR_MESSAGE		"Can't connect to GECOS Control Center! Please double-check the URL, user and password, and your internet connection."

!define GECOS_CC_LOCAL_DISCONNECTION			"Local disconnection"

; LoadGECOSCCSetupDataShow
!define GECOS_CC_AUTOSETUP_DATA_HEADER			"GECOS Control Center autosetup data"
!define GECOS_CC_AUTOSETUP_DATA_SUBHEADER		"Please check the autosetup data received from GECOS Control Center."

!define GECOS_CC_AUTOSETUP_DATA					"Data obtained from GECOS Control Center:"
!define GECOS_CC_AUTOSETUP_DATA_VERSION			"Version"
!define GECOS_CC_AUTOSETUP_DATA_ORGANIZATION	"Organization"
!define GECOS_CC_AUTOSETUP_DATA_NOTES			"Notes"

; LoadWorkstationData  
!define GECOS_CC_WORKSTATION_DATA_HEADER		"Workstation data"
!define GECOS_CC_WORKSTATION_DATA_SUBHEADER		"Please fill the workstation data."

!define GECOS_CC_WORKSTATION_DATA_LABEL			"Please enter the workstation data for the GECOS Control Center."
!define GECOS_CC_WORKSTATION_NAME				"Workstation name:"
!define GECOS_CC_WORKSTATION_OU_NAME			"OU name:"
!define GECOS_CC_WORKSTATION_SEARCH_BUTTON		"Search"
!define GECOS_CC_WORKSTATION_SELECTED_OU		"Selected OU:"
!define GECOS_CC_WORKSTATION_CLICK_SEARCH		"Clic the search button"

!define GECOS_CC_WORKSTATION_NAME_EMPTY			"The workstation name field is empty!"
!define GECOS_CC_WORKSTATION_NAME_IN_USE		"This workstation name is in use, please change it!"

!define GECOS_CC_WORKSTATION_OU_ERROR			"Please select one OU!"

!define GECOS_CC_WORKSTATION_NODE_NAME			"Node name:"

; un.UnlinkGECOSCCShow
!define GECOS_CC_UNLINK_HEADER					"Unlink from GECOS Control Center"
!define GECOS_CC_UNLINK_SUBHEADER				"Please wait while your PC is disconnected from GECOS Control Center."
!define GECOS_CC_UNLINK_LOCAL_SUBHEADER			"Please wait while GECOS connection data is deleted from your PC."

!define GECOS_CC_UNLINK_DISCONNECTING			"Disconnecting from GECOS Control Center."
!define GECOS_CC_UNLINK_DISCONNECTION_PROCESS	"Disconnection process..."
!define GECOS_CC_UNLINK_DISCONNECTING_ERROR		"Error unlinking from GECOS!"
!define GECOS_CC_UNLINK_DISCONNECTING_SUCCESS	"Unlink from GECOS CC sucessful!"

!define GECOS_CC_UNLINK_UNINSTAL_CHEF			"Uninstalling Opscode Chef..."
!define GECOS_CC_UNLINK_UNINSTAL_CHEF_SUCCESS	"Opscode Chef uninstaled!"









