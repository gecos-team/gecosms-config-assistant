;; Copyright (C) 2019, Junta de Andalucía <devmaster@guadalinex.org>
;; https://www.juntadeandalucia.es/
;; Author Abraham Macias <amacia@gruposolutia.com>
;;
;; This file is part of Guadalinex.
;;
;; This software is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This software is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this package; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
;;

;;  network_inteface.nsh
;;    : Dialogs to check the network interfaces


;Custom dialogs
!include nsDialogs.nsh

;--------------------------------
;Variables
Var NodeName


;--------------------------------
;Macros

!Macro ShowResult ItemString
	Pop $0 
	Pop $1
	${if} $0 == "ok"
		nsislog::log "$INSTDIR\${LOG_NAME}" "${ItemString} $1"
		StrCpy $R2 "$R2$\r$\n${ItemString} $1"
	${Else}
		nsislog::log "$INSTDIR\${LOG_NAME}" "${ItemString} ERROR: $1"
	${EndIf}
!MacroEnd

!Macro ShowMultiResult ItemString
	Pop $0 
	Pop $1
	${if} $0 != "ok"
		nsislog::log "$INSTDIR\${LOG_NAME}" "${ItemString} ERROR: $1"
	${EndIf}
!MacroEnd

;--------------------------------
;Functions


Function IPAddressesCallback
	Pop $5 
	${if} $R0 == 0
		nsislog::log "$INSTDIR\${LOG_NAME}"  "IP Address......: $5"
		StrCpy $9 $(GECOS_NETWORK_ADAPTER_IP_ADDRESS)
		StrCpy $R2 "$R2$\r$\n$9 $5"
		IntOp $R0 $R0 + 1
	${Else}
		nsislog::log "$INSTDIR\${LOG_NAME}"  "                  $5"
		StrCpy $R2 "$R2$\r$\n                  $5"
	${EndIf}
FunctionEnd

Function EnabledAdaptersCallback
	Pop $3 
	
	; Count the adapter
	IntOp $R1 $R1 + 1
	
	IpConfig::GetNetworkAdapterDescription $3
	!InsertMacro ShowResult $(GECOS_NETWORK_ADAPTER_DESCRIPTION)
	
	IpConfig::GetNetworkAdapterMACAddress $3
	!InsertMacro ShowResult $(GECOS_NETWORK_ADAPTER_PHYSICAL_ADDRESS)
	
	${If} $NodeName == ""
		NsisCrypt::Hash $3 "md5"
		Pop $NodeName
	${EndIf}
	
	StrCpy $R0 0
	GetFunctionAddress $4 IPAddressesCallback
	IpConfig::GetNetworkAdapterIPAddressesCB $3 $4
	!InsertMacro ShowMultiResult "     GetEnabledNetworkAdaptersIPAddresses:"	

	StrCpy $R2 "$R2$\r$\n"
FunctionEnd	


Function NetworkInterefacesShow
    ; Skip this step if C:\chef\client.pem exist
    IfFileExists C:\chef\client.pem 0 +2
	Abort
	
	SetOutPath "$INSTDIR"
	
	!insertmacro MUI_HEADER_TEXT $(GECOS_CHECK_NETWORK_INTERFACES_HEADER) $(GECOS_CHECK_NETWORK_INTERFACES_SUBHEADER)
	
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		nsislog::log "$INSTDIR\${LOG_NAME}" "ERROR: can't create network interfaces show dialog"
		Abort
	${EndIf}
	

	${NSD_CreateLabel} 0 0 100% 12u $(GECOS_CHECKING_NETWORK_INTERFACES)
	Pop $Label

	nsDialogs::CreateControl /NOUNLOAD ${__NSD_Text_CLASS} ${DEFAULT_STYLES}|\
		${WS_TABSTOP}|${ES_AUTOHSCROLL}|${ES_MULTILINE}|${WS_VSCROLL}|${ES_READONLY} ${__NSD_Text_EXSTYLE} \
		0 13u 100% -23u $(GECOS_NO_NETWORK_INTERFACES_FOUND)
	
	Pop $Text

	nsislog::log "$INSTDIR\${LOG_NAME}" "Checking internet adapters..."
	StrCpy $R2 $(GECOS_NETWORK_ADAPTERS)
	StrCpy $R1 0
	GetFunctionAddress $1 EnabledAdaptersCallback
	IpConfig::GetEnabledNetworkAdaptersIDsCB $1   
  
    CreateFont $1 "Courier" "9" "0"
    ${if} $R1 > 0
		${NSD_SetText} $Text $R2
	${EndIf}  	
	
  
	SendMessage $Text ${WM_SETFONT} $1 1

	
	
	nsDialogs::Show

FunctionEnd
  
Function NetworkInterefacesLeave
  ; There must be at least one internet connection enabled
  ${if} $R1 == 0
		nsislog::log "$INSTDIR\${LOG_NAME}"  "ERROR: No network adapters!"
		MessageBox MB_OK|MB_ICONSTOP $(GECOS_NO_NETWORK_ERROR_MESSAGE)
		Abort
  ${Else}
		nsislog::log "$INSTDIR\${LOG_NAME}"  "OK. There are $R1 network adapters"
  ${EndIf}  	
	
FunctionEnd  
