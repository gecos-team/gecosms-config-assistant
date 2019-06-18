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

;;
;;  GECOSSetupData.nsh
;;    : Dialogs to load the GECOS CC setup data

;--------------------------------
;Variables  

Var Label1
Var Label2
Var URLLabel
Var URLText
Var UserLabel
Var UserText
Var PasswordLabel
Var PasswordText
Var GecosCC_URL
Var GecosCC_User
Var GecosCC_Pass


Var WorkstationNameLabel
Var WorkstationNameText
Var OUSearchLabel
Var OUSearchText
Var OUSearchButton
Var OUSelectLabel
Var OUSelectComboBox
 
Var NodeNameLabel
Var NodeNameText 

Var LocalNameCheckbox
Var LocalDisconnection
 
Var WorkstationName 
Var SelectedOU
 
Var ProgressBar1
Var ProgressBar2

Var CmdUrl
Var CmdUsername  
Var CmdPassword
Var CmdOU
 
;--------------------------------
;Custom dialogs
!include nsDialogs.nsh
; Python files
!include pythonfiles.nsh
; Functions to process environment variables
!include ProcessEnvAppendPath.nsh



!macro PrepareGECOSPythonFiles un
	SetOutPath "$INSTDIR"
	Push "PATH"
	Call ${un}GetEnvironmentVariable
	
    Push "library.zip"
    Call ${un}StrContains	
    Pop $0
    StrCmp $0 "" notfound
      ; Python files must be ready!
      Goto done
	  
  notfound:
	; update PATH
	Push "$PLUGINSDIR\library.zip"
	Call ${un}ProcessEnvAppendPath
	
	; set PYTHONPATH = %PATH%
	Push "PYTHONPATH"
	Push "PATH"
	Call ${un}GetEnvironmentVariable
	Call ${un}SetEnvironmentVariable

	; set PLUGINSDIR
	Push "PLUGINSDIR"
	Push "$PLUGINSDIR"
	Call ${un}SetEnvironmentVariable

	; set INSTDIR
	Push "INSTDIR"
	Push "$INSTDIR"
	Call ${un}SetEnvironmentVariable

	
	; set PYLOGFILE
	Push "PYLOGFILE"
	Push "$INSTDIR\py${LOG_NAME}"
	Call ${un}SetEnvironmentVariable	


	; Copy python files to PLUGINSDIR
	File "/oname=$PLUGINSDIR\python27.dll" "python27.dll"
	File "/oname=$PLUGINSDIR\isurl.py" "isurl.py"
	File "/oname=$PLUGINSDIR\validate_gecos_credentials.py" "validate_gecos_credentials.py"
	File "/oname=$PLUGINSDIR\get_autoconf_data.py" "get_autoconf_data.py"
	File "/oname=$PLUGINSDIR\check_workstation_name.py" "check_workstation_name.py"
	File "/oname=$PLUGINSDIR\get_ou.py" "get_ou.py"
	File "/oname=$PLUGINSDIR\gecoscclink_step01.py" "gecoscclink_step01.py"
	File "/oname=$PLUGINSDIR\gecoscclink_step02.py" "gecoscclink_step02.py"
	File "/oname=$PLUGINSDIR\gecoscclink_step03.py" "gecoscclink_step03.py"
	File "/oname=$PLUGINSDIR\gecoscculink.py" "gecoscculink.py"
	File "/oname=$PLUGINSDIR\get_connection_data.py" "get_connection_data.py"



	CreateDirectory "$PLUGINSDIR\templates"
	File "/oname=$PLUGINSDIR\templates\chef.control" "templates\chef.control"
	File "/oname=$PLUGINSDIR\templates\client.rb" "templates\client.rb"
	File "/oname=$PLUGINSDIR\templates\gcc.control" "templates\gcc.control"
	File "/oname=$PLUGINSDIR\templates\knife.rb" "templates\knife.rb"

	!insertmacro PreparePythonFiles
	
  done:  	
	; Python files ready
!macroend

Function LoadGECOSCCSetupData
    ; Skip this step if C:\chef\client.pem exist
    IfFileExists C:\chef\client.pem 0 +2
	Abort

	SetOutPath "$INSTDIR"
	nsislog::log "$INSTDIR\${LOG_NAME}" "LoadGECOSCCSetupData init!"
	
	!insertmacro MUI_HEADER_TEXT $(GECOS_CC_CONNECTION_DATA_HEADER) $(GECOS_CC_CONNECTION_DATA_SUBHEADER)


	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		nsislog::log "$INSTDIR\${LOG_NAME}" "ERROR: can't create Load GECOS CC Setup data dialog"
		Abort
	${EndIf}
	
	${NSD_CreateLabel} 0 0 100% 12u $(PLEASE_ENTER_DATA_TO_CONNECT_TO_GECOS)
	Pop $Label1

	${NSD_CreateLabel} 0 24u 100% 12u $(GECOS_CC_CONNECTION_DATA)
	Pop $Label2
	
	${NSD_CreateLabel} 10u 40u 40u 12u $(URL)
	Pop $URLLabel

	${NSD_CreateText} 50u 37u 200u 12u "http://"
	Pop $URLText	

	${NSD_CreateLabel} 10u 60u 40u 12u $(USER)
	Pop $UserLabel

	${NSD_CreateText} 50u 57u 100u 12u ""
	Pop $UserText	

	${NSD_CreateLabel} 10u 80u 40u 12u $(PASSWORD)
	Pop $PasswordLabel

	${NSD_CreatePassword} 50u 77u 100u 12u ""
	Pop $PasswordText	

	${If} $CmdUrl != ""
		${NSD_SetText} $URLText $CmdUrl
	${EndIf}

	${If} $CmdUsername != ""
		${NSD_SetText} $UserText $CmdUsername
	${EndIf}

	${If} $CmdPassword != ""
		${NSD_SetText} $PasswordText $CmdPassword
	${EndIf}
	
	nsDialogs::Show
	

FunctionEnd
  
Function LoadGECOSCCSetupDataLeave
    ; Skip this step if C:\chef\client.pem exist
    IfFileExists C:\chef\client.pem 0 +2
	Abort

	SetOutPath "$INSTDIR"
	; Check the GECOS CC URL
	${NSD_GetText} $URLText $0
	
	${If} $0 == ""
		MessageBox MB_OK $(EMPTY_URL)
		Abort
	${EndIf}

	${If} $0 == "http://"
		MessageBox MB_OK|MB_ICONEXCLAMATION $(EMPTY_URL)
		Abort
	${EndIf}

	nsPython::execFile "$PLUGINSDIR\isurl.py"

    Pop $3	
	${If} $3 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "LoadGECOSCCSetupDataLeave: ERROR: bad python expression when validating GECOS CC URL! $4 ($5)"
		MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $4 ($5)"
		Abort
	${EndIf}
	
	${If} $4 == "false"
		MessageBox MB_OK|MB_ICONEXCLAMATION $(BAD_URL)
		Abort
	${EndIf}
	
	
	; Check the GECOS CC Username
	${NSD_GetText} $UserText $1	
	
	${If} $1 == ""
		MessageBox MB_OK|MB_ICONEXCLAMATION $(EMPTY_USER)
		Abort
	${EndIf}	
	
	; Check the GECOS CC Password
	${NSD_GetText} $PasswordText $2
	
	${If} $2 == ""
		MessageBox MB_OK|MB_ICONEXCLAMATION $(EMPTY_PASSWORD)
		Abort
	${EndIf}	
	
	; Validate credentials trying to connect to GECOS CC
	nsPython::execFile "$PLUGINSDIR\validate_gecos_credentials.py"
	
    Pop $3	
	${If} $3 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "LoadGECOSCCSetupDataLeave: ERROR: bad python expression when validating GECOS CC credentials! $4 ($5)"
		MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $4 ($5)"
		Abort
	${EndIf}
	
	${If} $4 == "false"
		MessageBox MB_OK|MB_ICONEXCLAMATION $(GECOS_CC_CONNECTION_ERROR_MESSAGE)
		Abort
	${EndIf}
	
	StrCpy $GecosCC_URL $0	
	StrCpy $GecosCC_User $1	
	StrCpy $GecosCC_Pass $2	
	
FunctionEnd  
  
  
Function LoadGECOSCCSetupDataShow
    ; Skip this step if C:\chef\client.pem exist
    IfFileExists C:\chef\client.pem 0 +2
	Abort
	
	!insertmacro MUI_HEADER_TEXT $(GECOS_CC_AUTOSETUP_DATA_HEADER) $(GECOS_CC_AUTOSETUP_DATA_SUBHEADER)
	
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		nsislog::log "$INSTDIR\${LOG_NAME}" "ERROR: can't create Load GECOS CC Setup data show dialog"
		Abort
	${EndIf}
	

	${NSD_CreateLabel} 0 0 100% 12u $(GECOS_CC_AUTOSETUP_DATA)
	Pop $Label

    nsPython::execFile "$PLUGINSDIR\get_autoconf_data.py"
	
    Pop $0
	${If} $0 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "LoadGECOSCCSetupDataShow: ERROR: bad python expression when getting JSON data! $1 ($2)"
		MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $1 ($2)"
		Abort
	${EndIf}
	
	nsDialogs::CreateControl /NOUNLOAD ${__NSD_Text_CLASS} ${DEFAULT_STYLES}|\
		${WS_TABSTOP}|${ES_AUTOHSCROLL}|${ES_MULTILINE}|${WS_VSCROLL}|${ES_READONLY} ${__NSD_Text_EXSTYLE} \
		0 13u 100% -23u "$(GECOS_CC_AUTOSETUP_DATA_VERSION): $1$\r$\n$(GECOS_CC_AUTOSETUP_DATA_ORGANIZATION): $2$\r$\n$(GECOS_CC_AUTOSETUP_DATA_NOTES): $3$\r$\n"
	
	Pop $Text
	
	
	nsDialogs::Show
	

FunctionEnd  
  
!macro DisableNextButton un
Function ${un}DisableNextButton
	#1 - Next, 2 - Cancel, 3 - Back
	GetDlgItem $0 $HWNDPARENT 1 #1 for 'Next' button
	EnableWindow $0 0
FunctionEnd
!macroend

!insertmacro DisableNextButton ""
!insertmacro DisableNextButton "un."

!macro EnableNextButton un
Function ${un}EnableNextButton
	#1 - Next, 2 - Cancel, 3 - Back
	GetDlgItem $0 $HWNDPARENT 1 #1 for 'Next' button
	EnableWindow $0 1
FunctionEnd  
!macroend

!insertmacro EnableNextButton ""
!insertmacro EnableNextButton "un."
  
!macro DisableCancelButton un
Function ${un}DisableCancelButton
	#1 - Next, 2 - Cancel, 3 - Back
	GetDlgItem $0 $HWNDPARENT 2 #2 for 'Cancel' button
	EnableWindow $0 0
FunctionEnd
!macroend

;!insertmacro DisableCancelButton ""
!insertmacro DisableCancelButton "un."

!macro EnableCancelButton un
Function ${un}EnableCancelButton
	#1 - Next, 2 - Cancel, 3 - Back
	GetDlgItem $0 $HWNDPARENT 2 #2 for 'Cancel' button
	EnableWindow $0 1
FunctionEnd  
!macroend

;!insertmacro EnableCancelButton ""
!insertmacro EnableCancelButton "un."  
  
!macro DisableBackButton un
Function ${un}DisableBackButton
	#1 - Next, 2 - Cancel, 3 - Back
	GetDlgItem $0 $HWNDPARENT 3 #3 for 'Back' button
	EnableWindow $0 0
FunctionEnd
!macroend

;!insertmacro DisableBackButton ""
!insertmacro DisableBackButton "un."

!macro EnableBackButton un
Function ${un}EnableBackButton
	#1 - Next, 2 - Cancel, 3 - Back
	GetDlgItem $0 $HWNDPARENT 3 #3 for 'Back' button
	EnableWindow $0 1
FunctionEnd  
!macroend

;!insertmacro EnableBackButton ""
!insertmacro EnableBackButton "un."  
  


  
; LoadWorkstationData  
Function LoadWorkstationData
    ; Skip this step if C:\chef\client.pem exist
    IfFileExists C:\chef\client.pem 0 +2
	Abort

	SetOutPath "$INSTDIR"
	
	; Get Windows workstation name
	ReadRegStr $0 HKLM "System\CurrentControlSet\Control\ComputerName\ActiveComputerName" "ComputerName"
 

	!insertmacro MUI_HEADER_TEXT $(GECOS_CC_WORKSTATION_DATA_HEADER) $(GECOS_CC_WORKSTATION_DATA_SUBHEADER)

	; Display dialog
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		nsislog::log "$INSTDIR\${LOG_NAME}" "ERROR: can't create workstation Setup data dialog"
		Abort
	${EndIf}
	
	${NSD_CreateLabel} 0 0 100% 12u $(GECOS_CC_WORKSTATION_DATA_LABEL)
	Pop $Label1

	${NSD_CreateLabel} 10u 40u 100u 12u $(GECOS_CC_WORKSTATION_NAME)
	Pop $WorkstationNameLabel

	${NSD_CreateText} 110u 40u 100u 12u $0
	Pop $WorkstationNameText	

	${NSD_CreateLabel} 10u 60u 100u 12u $(GECOS_CC_WORKSTATION_OU_NAME)
	Pop $OUSearchLabel

	${NSD_CreateText} 110u 60u 100u 12u ""
	Pop $OUSearchText	
	
	${If} $CmdOU != ""
		${NSD_SetText} $OUSearchText $CmdOU
	${EndIf}	


	${NSD_CreateButton} 220u 60u 50u 12u $(GECOS_CC_WORKSTATION_SEARCH_BUTTON)
	Pop $OUSearchButton

	${NSD_OnClick} $OUSearchButton LoadWorkstationData_search	

	${NSD_CreateLabel} 10u 80u 100u 12u $(GECOS_CC_WORKSTATION_SELECTED_OU)
	Pop $OUSelectLabel
	
	${NSD_CreateComboBox} 110u 80u 100u 12u
	Pop $OUSelectComboBox
	
	SendMessage $OUSelectComboBox ${CB_ADDSTRING} 1 "STR:$(GECOS_CC_WORKSTATION_CLICK_SEARCH)"
	
	Call DisableNextButton

	
	nsDialogs::Show
	

FunctionEnd


Function LoadWorkstationData_search
	# Check the workstation name
	StrCpy $0 $GecosCC_URL
	StrCpy $1 $GecosCC_User 	
	StrCpy $2 $GecosCC_Pass		
	${NSD_GetText} $WorkstationNameText $3	
	
	${If} $3 == ""
		MessageBox MB_OK $(GECOS_CC_WORKSTATION_NAME_EMPTY)
		Abort
	${EndIf}	
	
	StrCpy $4 ""
	StrCpy $5 ""
	StrCpy $6 ""

	
	nsPython::execFile "$PLUGINSDIR\check_workstation_name.py"

    Pop $6	
	${If} $6 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "LoadWorkstationData_search: ERROR: bad python expression when validating the workstation name! $4 ($5)"
		MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $4 ($5)"
		Abort
	${EndIf}
	
	${If} $4 == "true"
		MessageBox MB_OK|MB_ICONEXCLAMATION $(GECOS_CC_WORKSTATION_NAME_IN_USE)
		Abort
	${EndIf}	
	
	StrCpy $WorkstationName $3

	# Get the OU list
	SendMessage $OUSelectComboBox ${CB_RESETCONTENT} 0 0

	${NSD_GetText} $OUSearchText $3	
	
	StrCpy $4 ""

SearchLoop:
	nsPython::execFile "$PLUGINSDIR\get_ou.py"

    Pop $6	
	${If} $6 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "LoadWorkstationData_search: ERROR: bad python expression when getting OU names! $4 ($5)"
		MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $4 ($5)"
		Abort
	${EndIf}
	
	${If} $4 != ""
		SendMessage $OUSelectComboBox ${CB_ADDSTRING} 1 "STR:$4"
		Goto SearchLoop
	${EndIf}	
	
	Call EnableNextButton
	
FunctionEnd

; LoadWorkstationDataLeave
Function LoadWorkstationDataLeave
	SetOutPath "$INSTDIR"
	; Check the selected ou 
	${NSD_GetText} $OUSelectComboBox $0
	
	${If} $0 == ""
		MessageBox MB_OK $(GECOS_CC_WORKSTATION_OU_ERROR)
		Abort
	${EndIf}

	StrCpy $SelectedOU  $0

	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	nsislog::log "$INSTDIR\${LOG_NAME}" "GECOS CC connection data: "
	nsislog::log "$INSTDIR\${LOG_NAME}" "  URL: $GecosCC_URL"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  User: $GecosCC_User"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Workstation name: $WorkstationName"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Selected OU: $SelectedOU"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Node Name: $NodeName"
	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	
FunctionEnd




; un.UnlinkGECOSCC
Function un.UnlinkGECOSCC
	SetOutPath "$INSTDIR"
	
	nsislog::log "$INSTDIR\${LOG_NAME}" "Get data to disconnect from GECOS CC "
	
	nsPython::execFile "$PLUGINSDIR\get_connection_data.py"

    Pop $6	
	${If} $6 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "UnlinkGECOSCC: ERROR: bad python expression when getting GECOS CC connection data! $4 ($5)"
		MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $4 ($5)"
		Abort
	${EndIf}
	

	StrCpy $GecosCC_URL $0
	StrCpy $GecosCC_User $1
	StrCpy $WorkstationName $2
	StrCpy $NodeName $3
	

	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	nsislog::log "$INSTDIR\${LOG_NAME}" "GECOS CC connection data: "
	nsislog::log "$INSTDIR\${LOG_NAME}" "  URL: $GecosCC_URL"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  User: $GecosCC_User"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Workstation name: $WorkstationName"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Node Name: $NodeName"
	nsislog::log "$INSTDIR\${LOG_NAME}" " "	
	
	!insertmacro MUI_HEADER_TEXT $(GECOS_CC_CONNECTION_DATA_HEADER) $(GECOS_CC_CONNECTION_DATA_SUBHEADER)
	
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		nsislog::log "$INSTDIR\${LOG_NAME}" "ERROR: can't create Unlink GECOS CC dialog"
		Abort
	${EndIf}
	
	${NSD_CreateLabel} 0 0 100% 12u $(PLEASE_ENTER_DATA_TO_CONNECT_TO_GECOS)
	Pop $Label1

	${NSD_CreateLabel} 0 18u 100% 12u $(GECOS_CC_CONNECTION_DATA)
	Pop $Label2
	
	${NSD_CreateLabel} 10u 35u 40u 12u $(URL)
	Pop $URLLabel

	${NSD_CreateText} 50u 32u 200u 12u "$GecosCC_URL"
	Pop $URLText	
	
	SendMessage $URLText ${EM_SETREADONLY} 1 0

	${NSD_CreateLabel} 10u 55u 40u 12u $(USER)
	Pop $UserLabel

	${NSD_CreateText} 50u 52u 100u 12u "$GecosCC_User"
	Pop $UserText	

	SendMessage $UserText ${EM_SETREADONLY} 1 0
	
	${NSD_CreateLabel} 10u 75u 40u 12u $(PASSWORD)
	Pop $PasswordLabel

	${NSD_CreatePassword} 50u 72u 100u 12u ""
	Pop $PasswordText	

	${NSD_CreateLabel} 10u 95u 100u 12u $(GECOS_CC_WORKSTATION_NAME)
	Pop $WorkstationNameLabel

	${NSD_CreateText} 110u 92u 150u 12u "$WorkstationName"
	Pop $WorkstationNameText		
	
	SendMessage $WorkstationNameText ${EM_SETREADONLY} 1 0
	
	${NSD_CreateLabel} 10u 115u 100u 12u $(GECOS_CC_WORKSTATION_NODE_NAME)
	Pop $NodeNameLabel

	${NSD_CreateText} 110u 112u 150u 12u "$NodeName"
	Pop $NodeNameText		
	
	SendMessage $NodeNameText ${EM_SETREADONLY} 1 0

	${NSD_CreateCheckbox} 10u 128u 100u 12u $(GECOS_CC_LOCAL_DISCONNECTION)
	Pop $LocalNameCheckbox
	${NSD_OnClick} $LocalNameCheckbox un.DisablePasswordField	
	
	nsDialogs::Show
	

FunctionEnd
 
Function un.DisablePasswordField
	Pop $LocalNameCheckbox
	${NSD_GetState} $LocalNameCheckbox $0
	${If} $0 == 1
		SendMessage $PasswordText ${EM_SETREADONLY} 1 0
	${Else}
		SendMessage $PasswordText ${EM_SETREADONLY} 0 0
	${EndIf}
FunctionEnd 

Function un.UnlinkGECOSCCLeave
	SetOutPath "$INSTDIR"

	${NSD_GetState} $LocalNameCheckbox $LocalDisconnection
	${If} $LocalDisconnection == 0	
		; Check the GECOS CC Password
		${NSD_GetText} $PasswordText $2
		
		
		${If} $2 == ""

			MessageBox MB_OK|MB_ICONEXCLAMATION $(EMPTY_PASSWORD)
			Abort
		${EndIf}	
		
		
		StrCpy $0 $GecosCC_URL
		StrCpy $1 $GecosCC_User
		
		; Validate credentials trying to connect to GECOS CC
		nsPython::execFile "$PLUGINSDIR\validate_gecos_credentials.py"
		
		Pop $3	
		${If} $3 == "error"
			nsislog::log "$INSTDIR\${LOG_NAME}" "UnlinkGECOSCCLeave: ERROR: bad python expression when validating GECOS CC credentials! $4 ($5)"
			MessageBox MB_OK|MB_ICONSTOP "Error evaluating python expression! $4 ($5)"
			Abort
		${EndIf}
		
		${If} $4 == "false"
			MessageBox MB_OK|MB_ICONEXCLAMATION $(GECOS_CC_CONNECTION_ERROR_MESSAGE)
			Abort
		${EndIf}
		
		StrCpy $GecosCC_Pass $2	
		
	${EndIf}
	
FunctionEnd  
  
;un.UnlinkGECOSCCShow
Function un.UnlinkGECOSCCShow
	SetOutPath "$INSTDIR"
	
	${If} $LocalDisconnection == 1
		; Local disconnection --------------------------------
		nsislog::log "$INSTDIR\${LOG_NAME}" "Performing local disconnection!"
		
		!insertmacro MUI_HEADER_TEXT $(GECOS_CC_UNLINK_HEADER) $(GECOS_CC_UNLINK_LOCAL_SUBHEADER)
		
	${Else}
		; GCC disconnection ----------------------------------
		nsislog::log "$INSTDIR\${LOG_NAME}" "GECOS CC connection data validated. Now disconnect from GECOS CC!"
		
		!insertmacro MUI_HEADER_TEXT $(GECOS_CC_UNLINK_HEADER) $(GECOS_CC_UNLINK_SUBHEADER)
		
		
	${EndIf}		
	
	
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		nsislog::log "$INSTDIR\${LOG_NAME}" "ERROR: can't create Unlink from GECOS CC dialog (step 2)"
		Abort
	${EndIf}
	
	${NSD_CreateLabel} 0 0 100% 12u $(GECOS_CC_UNLINK_DISCONNECTING)
	Pop $Label1
	
    ${NSD_CreateProgressBar} 0 24u 100% 10% $(GECOS_CC_UNLINK_DISCONNECTION_PROCESS)
    Pop $ProgressBar1
 
 	${NSD_GetState} $LocalNameCheckbox $0
	${If} $LocalDisconnection == 1
		; Local disconnection --------------------------------
		${NSD_CreateTimer} un.LocalUnlinkGECOSCCS_Timer.Callback 1000
		
 	${Else}
		; GCC disconnection ----------------------------------
		${NSD_CreateTimer} un.UnlinkGECOSCCS_Timer.Callback 1000
		
	${EndIf}
     

	Call un.DisableNextButton
	Call un.DisableBackButton
	Call un.DisableCancelButton
	 
	nsDialogs::Show
	

FunctionEnd  


Function un.LocalUnlinkGECOSCCS_Timer.Callback
    ${NSD_KillTimer} un.LocalUnlinkGECOSCCS_Timer.Callback

    ; Delete local connection files
	nsislog::log "$INSTDIR\${LOG_NAME}"  "Local disconnecton"
	RMDir /r c:\chef
	RMDir /r c:\etc
	
	
	${NSD_SetText} $Label1 $(GECOS_CC_UNLINK_DISCONNECTING_SUCCESS)
	${NSD_SetText} $ProgressBar1 $(GECOS_CC_UNLINK_DISCONNECTING_SUCCESS)
	
	SendMessage $ProgressBar1 ${PBM_SETPOS} 100 0
	
	${NSD_CreateLabel} 0 60u 100% 12u $(GECOS_CC_UNLINK_UNINSTAL_CHEF)
	Pop $Label2
	${NSD_CreateProgressBar} 0 74u 100% 10% $(GECOS_CC_UNLINK_UNINSTAL_CHEF)
	Pop $ProgressBar2
	
	${NSD_CreateTimer} un.UninstallChef_Timer.Callback 1000
	
FunctionEnd


Function un.UnlinkGECOSCCS_Timer.Callback
    ${NSD_KillTimer} un.UnlinkGECOSCCS_Timer.Callback

    SendMessage $ProgressBar1 ${PBM_SETPOS} 25 0
	
	StrCpy $0 $GecosCC_URL
	StrCpy $1 $GecosCC_User
	StrCpy $2 $GecosCC_Pass	
	StrCpy $3 $WorkstationName
	StrCpy $4 $NodeName
	
	
	nsPython::execFile "$PLUGINSDIR\gecoscculink.py"

    Pop $3	
	${If} $3 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "UnlinkGECOSCCS_Timer: ERROR: bad python expression when unlinking from GECOS CC! $4 ($5)"
		${NSD_SetText} $Label1 $(GECOS_CC_UNLINK_DISCONNECTING_ERROR)
		${NSD_SetText} $ProgressBar1 $(GECOS_CC_UNLINK_DISCONNECTING_ERROR)
		Call un.EnableCancelButton
		
	${Else}
		${NSD_SetText} $Label1 $(GECOS_CC_UNLINK_DISCONNECTING_SUCCESS)
		${NSD_SetText} $ProgressBar1 $(GECOS_CC_UNLINK_DISCONNECTING_SUCCESS)
		
		SendMessage $ProgressBar1 ${PBM_SETPOS} 100 0
		
		${NSD_CreateLabel} 0 60u 100% 12u $(GECOS_CC_UNLINK_UNINSTAL_CHEF)
		Pop $Label2
		${NSD_CreateProgressBar} 0 74u 100% 10% $(GECOS_CC_UNLINK_UNINSTAL_CHEF)
		Pop $ProgressBar2
		
		${NSD_CreateTimer} un.UninstallChef_Timer.Callback 1000
		
	${EndIf}	
	
FunctionEnd

Function un.UninstallChef_Timer.Callback
    ${NSD_KillTimer} un.UninstallChef_Timer.Callback
	
	nsislog::log "$INSTDIR\${LOG_NAME}"  "Uninstalling Chef"
	ExecWait 'msiexec /q /x  "$INSTDIR\chef-client-12.22.5-1-x86.msi"'
	
	SendMessage $ProgressBar2 ${PBM_SETPOS} 100 0
	${NSD_SetText} $Label2 $(GECOS_CC_UNLINK_UNINSTAL_CHEF_SUCCESS)


	nsislog::log "$INSTDIR\${LOG_NAME}"  "Cleaning"
	RMDir /r c:\chef
	RMDir /r c:\etc
	RMDir /r c:\opscode
	
	
	Call un.EnableNextButton
	Call un.EnableBackButton
	Call un.EnableCancelButton

	
FunctionEnd
	