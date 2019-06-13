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



!define PRODUCT_NAME "GECOS"
!define PRODUCT_PUBLISHER "Junta de Andalucia"
!define PRODUCT_WEB_SITE "https://www.juntadeandalucia.es/"
!define PRODUCT_FULL_NAME "${PRODUCT_NAME} client"
!define PRODUCT_VERSION 2.3.0.0
!define OUT_DIR "."
!define SETUP_NAME gecos_v2.3
!define COPYRIGHT_YEAR 2019

!define BASENAME "${PRODUCT_FULL_NAME}"
!define LOG_NAME "install.log"
!define SHORTCUT "${PRODUCT_NAME}.lnk"
!define SHORTCUT_ICON "gecos.ico"

!define UNINSTALL_REGKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\gecos"

  !include "FileFunc.nsh"
  !include "WinMessages.nsh"
  !include "MUI.nsh"

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "media\header.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP  "media\header.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "media\startlogo.bmp"
  !define MUI_UNWELCOMEFINISHPAGE_BITMAP "media\startlogo.bmp"
  !define MUI_ICON "media\wizard.ico"
  !define MUI_UNICON ${MUI_ICON}

  !define MUI_ABORTWARNING
  !define MUI_UNABORTWARNING

;General

  ;Name and file
  Name "${PRODUCT_FULL_NAME}"
  OutFile "${OUT_DIR}\${SETUP_NAME}.exe"

  BrandingText "Copyright (C) ${COPYRIGHT_YEAR} Junta de Andalucia"
  ;Default installation folder
  InstallDir "$PROGRAMFILES\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKLM "Software\${PRODUCT_PUBLISHER}" "${PRODUCT_NAME}"

  VIAddVersionKey ProductName "${PRODUCT_NAME}"
  VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}"
  VIAddVersionKey ProductVersion "${PRODUCT_VERSION}"
  VIAddVersionKey FileVersion "${PRODUCT_VERSION}"
  VIAddVersionKey FileDescription "GECOS  (Guadalinex Edición COrporativa eStandar)"
  VIAddVersionKey LegalCopyright "Copyright (C) ${COPYRIGHT_YEAR} Junta de Andalucía"
  VIProductVersion "${PRODUCT_VERSION}"

;--------------------------------
;Generic variables
Var Dialog
Var Label
Var Text
  
  
;--------------------------------
;Interface Settings

;--------------------------------
;Pages


  ; Installer parameters and pages order
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_LICENSEPAGE_RADIOBUTTONS
  !define MUI_FINISHPAGE_LINK "Visit our web site"
  !define MUI_FINISHPAGE_LINK_LOCATION ${PRODUCT_WEB_SITE}
  !define MUI_FINISHPAGE_TEXT "${PRODUCT_FULL_NAME} has been installed on your computer.\n\nClick Finish to close this wizard.\n"
  !define MUI_FINISHPAGE_TEXT_LARGE
#  !define MUI_FINISHPAGE_RUN "$INSTDIR/${EXE_NAME}"
#  !define MUI_FINISHPAGE_RUN_NOTCHECKED
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "Show installation log"
  !define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
  !define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\${LOG_NAME}"  
  
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "media/LICENSE.txt"
  !insertmacro MUI_PAGE_DIRECTORY
 

  Page custom NetworkInterefacesShow NetworkInterefacesLeave
  Page custom LoadGECOSCCSetupData LoadGECOSCCSetupDataLeave
  Page custom LoadGECOSCCSetupDataShow
  Page custom LoadWorkstationData LoadWorkstationDataLeave
  
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_PAGE_FINISH

  ; Uninstaller Parameters and pages order
  !define MUI_WELCOMEPAGE_TITLE_3LINES
  !define MUI_FINISHPAGE_TITLE_3LINES
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  
  UninstPage  custom un.UnlinkGECOSCC un.UnlinkGECOSCCLeave
  UninstPage  custom un.UnlinkGECOSCCShow  
  
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "Spanish"

  
  !define GECOS_DEFAULT_LANGFILE "translations\Default.nsh"
 
  !include "langmacros.nsh"
 
  !insertmacro GECOS_MACRO_INCLUDE_LANGFILE "ENGLISH"	"translations\English.nsh" 
  !insertmacro GECOS_MACRO_INCLUDE_LANGFILE "SPANISH"	"translations\Spanish.nsh"
  
  
; Check network interfaces
  !include network_interface.nsh  

; Load GECOS CC setup data
  !include GECOSSetupData.nsh
  
; Load registry macros
  !include reg.nsh

; Load string macros
  !include strings.nsh
  
; Tools files
  !include toolsfiles.nsh

; X64 file system redirection
  !include x64.nsh
  
  
;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

  
ReserveFile "python27.dll"
ReserveFile "isurl.py"
ReserveFile "validate_gecos_credentials.py"
ReserveFile "get_autoconf_data.py"
ReserveFile "check_workstation_name.py"
ReserveFile "get_ou.py"
ReserveFile "gecoscclink_step01.py"
ReserveFile "gecoscclink_step02.py"
ReserveFile "gecoscclink_step03.py"
ReserveFile "templates\chef.control"
ReserveFile "templates\client.rb"
ReserveFile "templates\gcc.control"
ReserveFile "templates\knife.rb"

ReserveFile "gecoscculink.py"
ReserveFile "get_connection_data.py"

  
  !include reserved.nsh
  
Function .onInit
    ; to install for all user
    SetShellVarContext all
	
	!insertmacro MUI_LANGDLL_DISPLAY
	
  check_chef_version:	
    ; Check if any version of opscode chef is installed
    !insertmacro GetAppInstalledKey "Chef Client "
    Pop $R4
  
    ${if} $R4 != ""
	    ReadRegStr $R2 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$R4" "DisplayName"	
        StrCmp $R2 "Chef Client v12.22.5" sameversion 
	
		; There is a different version of opscode chef installed --> uninstall it!
		IfSilent uninst
  	    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
          $(DIFFERENT_CHEF_VERSION_MESSAGE) \
          IDOK uninst
        Abort
	
	uninst:
		ReadRegStr $R3 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\$R4" "UninstallString"
		${StrRep} '$R0' '$R3' '/I' '/X'
		
		IfSilent silent_chef_uninst
		ExecWait '$R0'
		Goto check_chef_version

    silent_chef_uninst:		
		ExecWait '$R0 /q'
		
		Goto check_chef_version
		
	sameversion:
	
    ${EndIf} 	
	
    ${GetParameters} $R0
    ClearErrors
    ${GetOptions} $R0 /URL= $CmdUrl	
    ${GetOptions} $R0 /USERNAME= $CmdUsername	
    ${GetOptions} $R0 /PASSWORD= $CmdPassword	
    ${GetOptions} $R0 /OU= $CmdOU	
	
	!insertmacro PrepareGECOSPythonFiles ""
	
	; Get Windows default workstation name
	ReadRegStr $WorkstationName HKLM "System\CurrentControlSet\Control\ComputerName\ActiveComputerName" "ComputerName"	
	
FunctionEnd

Function un.onInit
  ; to uninstall for all user
    SetShellVarContext all
	
	!insertmacro MUI_LANGDLL_DISPLAY
	
	!insertmacro PrepareGECOSPythonFiles "un."
	
FunctionEnd




Section "Main Section" SecMain
  SetOutPath "$INSTDIR"

  ;Store installation folder
  WriteRegStr HKLM "Software\${PRODUCT_PUBLISHER}" "${PRODUCT_NAME}" $INSTDIR
  
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "Comments"        "${PRODUCT_FULL_NAME}"
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "DisplayIcon"     "$INSTDIR\${SHORTCUT_ICON},0"
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "DisplayName"     "${PRODUCT_FULL_NAME} (${PRODUCT_VERSION})"
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "DisplayVersion"  "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "Publisher"       "${PRODUCT_PUBLISHER}"
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "UninstallString" '"$INSTDIR\Uninstall.exe"' 
  WriteRegStr HKLM "${UNINSTALL_REGKEY}" "URLInfoUbout"    "${PRODUCT_WEB_SITE}"
  WriteRegDWORD HKLM "${UNINSTALL_REGKEY}" "NoModify" "1"
  WriteRegDWORD HKLM "${UNINSTALL_REGKEY}" "NoRepair" "1"

;  SetOutPath "$APPDATA\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
;  SetOverwrite ifnewer
SectionEnd

Section "SecMedia" SecMedia
  SetOutPath "$INSTDIR\"
  SetOverwrite ifnewer

  File "media\gecos.ico"
SectionEnd

Section "un.SecMedia" SecUnMedia
  Delete "$INSTDIR\gecos.ico"
SectionEnd

Section "Shortcut Section" SecShortcut
  SetOutPath "$INSTDIR"
  CreateDirectory "$SMPROGRAMS\${PRODUCT_PUBLISHER}"
  WriteIniStr "$SMPROGRAMS\${PRODUCT_PUBLISHER}\Website.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"

  ;CreateShortCut "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${SHORTCUT}" "$INSTDIR\${EXE_NAME}"
SectionEnd

Section "un.Shortcut Section" SecUnShortcut
  Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\${SHORTCUT}"
  
  ;Delete "$SMPROGRAMS\${PRODUCT_PUBLISHER}\Website.url"
  ;RMDir  "$SMPROGRAMS\${PRODUCT_PUBLISHER}"
SectionEnd

Section "Uninstall"
  ; Check if opscode chef was deleted (if it was not deleted this is probably a silent uninstall)
  !insertmacro IfAppInstalled "Chef Client v12.22.5"
  Pop $R0
  
  ${if} $R0 != 0
	nsislog::log "$INSTDIR\${LOG_NAME}"  "Uninstall Opscode Chef"
	ExecWait 'msiexec /q /x  "$INSTDIR\chef-client-12.22.5-1-x86.msi"'

	RMDir /r c:\chef
	RMDir /r c:\etc
	RMDir /r c:\opscode  

  ${EndIf} 
  
  
  ExecWait '$INSTDIR\tools\gecosws-chef-snitch-client.exe --stop'
  Sleep 1000
  RMDir /r "$INSTDIR\tools"
  RMDir /r "$INSTDIR"
  RMDir /r "$APPDATA\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}"
  RMDir "$APPDATA\${PRODUCT_PUBLISHER}"
  
  Delete "$INSTDIR\Uninstall.exe"
  DeleteRegKey HKLM "${UNINSTALL_REGKEY}"

  ; Do no start notifier
  DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "GECOS notifier" 

  ; Do no start gecos-user-login script
  DeleteRegValue HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "GECOS user login"
  
  ; Delete gecos-first-login script shortcut from Startup programs
  Delete  "$SMSTARTUP\ gecos-first-login.lnk"
  
  ; Remove tools from PATH
  ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"

  ${StrRep} $0 "$1" ";$INSTDIR\tools" ""  
  ${StrRep} $1 "$0" "%SystemRoot%" "$WINDIR"
  ${StrRep} $0 "$1" "%SYSTEMROOT%" "$WINDIR" 
  WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$0"
  
  ; Remove scheduled task
  ExecWait 'schtasks /Delete /TN chef-client-wrapper /F'
  
  ; Delete %APPDATA%\gecos\firstart\firstart.conf
  ReadEnvStr $0 APPDATA
  Delete "$0\gecos\firstart\firstart.conf"  
  
  DeleteRegValue HKLM "Software\${PRODUCT_PUBLISHER}" "${PRODUCT_NAME}"
  DeleteRegKey /ifempty HKLM "Software\${PRODUCT_PUBLISHER}"
SectionEnd




; Opscode Chef 12 client installation ==============================================================================
Section "ChefClient"
  File "chef-client-12.22.5-1-x86.msi"
  !insertmacro IfAppInstalled "Chef Client v12.22.5"
  Pop $R0
  
  ${if} $R0 == 0
	nsislog::log "$INSTDIR\${LOG_NAME}"  "Chef not installed --> Install it!"
	ExecWait 'msiexec /qn /i "$INSTDIR\chef-client-12.22.5-1-x86.msi"'
  ${Else}
	nsislog::log "$INSTDIR\${LOG_NAME}"  "Chef already installed!"
  ${EndIf} 
  
SectionEnd

; Tools installation ==============================================================================
Section "ToolsInstalation"
  !insertmacro PrepareToolsFiles 
  
  ; Add registry entry to start the notifier
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "GECOS notifier" "$INSTDIR\tools\notifier.exe"

  ; Add registry entry to start the gecos-user-login script
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "GECOS user login" "$INSTDIR\tools\gecos-user-login.exe"
  
  ; Add gecos-first-login script shortcut to Startup programs
  CreateShortCut "$SMSTARTUP\gecos-first-login.lnk" "$INSTDIR\tools\gecos-first-login.exe"
  
  ; Add tools directory to PATH
  ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
  
  ; Add chef-client-wrapper as a scheduled task
  ; https://technet.microsoft.com/en-us/library/cc748993(v=ws.11).aspx
  ExecWait 'schtasks /Create /TN chef-client-wrapper /TR "\"$INSTDIR\tools\gecos-chef-client-wrapper.exe\"" /sc DAILY /st 07:00 /f /RI 30 /du 24:00  /RL HIGHEST /ru SYSTEM'

  ; Set permissions to the task folder
  ${If} ${RunningX64}
    ${DisableX64FSRedirection}
  ${EndIf}
	  
  AccessControl::GrantOnFile "$WINDIR\System32\Tasks" "(BU)" "GenericRead"
  Pop $0 ; get "ok" or "error"
  StrCmp $0 "ok" dirPermissionOk
  Pop $0 ; get error message
  nsislog::log "$INSTDIR\${LOG_NAME}"  "Error setting permissions to $WINDIR\System32\Tasks: $0"
  
dirPermissionOk:

  
  ; Set permissions to the task
  AccessControl::GrantOnFile "$WINDIR\System32\Tasks\chef-client-wrapper" "(BU)" "GenericRead + GenericExecute"
  Pop $0 ; get "ok" or error msg
  StrCmp $0 "ok" permissionOk
  Pop $0 ; get error message
  nsislog::log "$INSTDIR\${LOG_NAME}"  "Error setting permissions to $WINDIR\System32\Tasks\chef-client-wrapper: $0"
  
permissionOk:
  
  ${If} ${RunningX64}
    ${EnableX64FSRedirection}
  ${EndIf}	   
  
 
  ; Delete %APPDATA%\gecos\firstart\firstart.conf
  ReadEnvStr $0 APPDATA
  Delete "$0\gecos\firstart\firstart.conf"
  
  Push $1
  Push "$INSTDIR"
  Call StrContains
  Pop $0
  StrCmp $0 "" notfound
    nsislog::log "$INSTDIR\${LOG_NAME}"  "Tools already added in PATH!"
    Goto done
  notfound:
    nsislog::log "$INSTDIR\${LOG_NAME}"  "Add tools to PATH!"
    ${StrRep} $0 "$1" "%SystemRoot%" "$WINDIR"
	${StrRep} $1 "$0" "%SYSTEMROOT%" "$WINDIR" 
	
	WriteRegStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" "$1;$INSTDIR\tools"
  done:  
  
  
  SetRebootFlag true
  
SectionEnd


; Connect with GECOS CC (step 1) =============================================================================================
Section "CreateSetupFiles" CreateSetupFiles_ID
	SectionSetText  ${CreateSetupFiles_ID} "Creating setup files..."
	SetOutPath "$INSTDIR"
	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	nsislog::log "$INSTDIR\${LOG_NAME}" "Software installed. Now connect with GECOS CC... "
	DetailPrint "Software installed. Now connect with GECOS CC... "

	${If} $NodeName == ""
		GetFunctionAddress $1 EnabledAdaptersCallback
		IpConfig::GetEnabledNetworkAdaptersIDsCB $1
	${EndIf}	

	${If} $GecosCC_URL == ""
		StrCpy $GecosCC_URL $CmdUrl
	${EndIf}
	
	${If} $GecosCC_User == ""
		StrCpy $GecosCC_User $CmdUsername
	${EndIf}
	
	${If} $GecosCC_Pass == ""
		StrCpy $GecosCC_Pass $CmdPassword
		
		; Validate credentials trying to connect to GECOS CC
		StrCpy $0 $GecosCC_URL
		StrCpy $1 $GecosCC_User
		StrCpy $2 $GecosCC_Pass
		nsPython::execFile "$PLUGINSDIR\validate_gecos_credentials.py"
	${EndIf}
	
	${If} $SelectedOU == ""
		StrCpy $SelectedOU $CmdOU
	${EndIf}
	
	; Create setup files
	StrCpy $0 $GecosCC_URL
	StrCpy $1 $GecosCC_User 	
	StrCpy $2 $GecosCC_Pass		
	StrCpy $3 $SelectedOU		
	StrCpy $4 $WorkstationName		
	StrCpy $5 $NodeName		

	nsislog::log "$INSTDIR\${LOG_NAME}" "GECOS CC connection data: "
	nsislog::log "$INSTDIR\${LOG_NAME}" "  URL: $GecosCC_URL"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  User: $GecosCC_User"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Workstation name: $WorkstationName"
	nsislog::log "$INSTDIR\${LOG_NAME}" "  Node Name: $NodeName"

	
	nsPython::execFile "$PLUGINSDIR\gecoscclink_step01.py"

    Pop $7	
	${If} $7 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "ConnectWithGECOSCC: ERROR creating setup files! $4 ($5)"
		DetailPrint "ERROR creating setup files! $4 ($5)"
		Abort
	${EndIf}	

	${If} $6 == "false"
		DetailPrint "ERROR creating setup files!"
		Abort
	${EndIf}	
	
SectionEnd


; Connect with GECOS CC (step 2) =============================================================================================
Section "LinkToChef" LinkToChef_ID
	SectionSetText  ${LinkToChef_ID} "Preparing to link to Chef server..."
	SetOutPath "$INSTDIR"
	
	CreateDirectory "$INSTDIR\data"
	File "/oname=$INSTDIR\data\base.json" "data\base.json"	
	CreateDirectory "$INSTDIR\data\report-handlers"
	File "/oname=$INSTDIR\data\report-handlers\gecoshandlers.rb" "data\report-handlers\gecoshandlers.rb"
	File "/oname=$INSTDIR\LICENSE.txt" "LICENSE.txt"	

	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	nsislog::log "$INSTDIR\${LOG_NAME}" "Linking to Chef server... "
	DetailPrint "Linking to Chef server... "
	
	; Link to Chef
	StrCpy $0 $GecosCC_URL
	StrCpy $1 $GecosCC_User 	
	StrCpy $2 $GecosCC_Pass		
	StrCpy $3 $SelectedOU		
	StrCpy $4 $WorkstationName		
	StrCpy $5 $NodeName		
	
	nsPython::execFile "$PLUGINSDIR\gecoscclink_step02.py"

    Pop $7	
	${If} $7 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "ConnectWithGECOSCC: ERROR linking to Chef server! $4 ($5)"
		DetailPrint "ERROR linking to Chef server! $4 ($5)"
		Abort
	${EndIf}	

	${If} $6 == "false"
		DetailPrint "ERROR linking to Chef server!"
		Abort
	${EndIf}	
	
SectionEnd

; Connect with GECOS CC (step 3) =============================================================================================
Section "LinkToCC" LinkToCC_ID
	SectionSetText  ${LinkToCC_ID} "Linking to GECOS CC server..."
	SetOutPath "$INSTDIR"
	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	nsislog::log "$INSTDIR\${LOG_NAME}" "Linking to GECOS CC server... "
	DetailPrint "Linking to GECOS CC server... "
	

	; Link to GECOS CC
	StrCpy $0 $GecosCC_URL
	StrCpy $1 $GecosCC_User 	
	StrCpy $2 $GecosCC_Pass		
	StrCpy $3 $SelectedOU		
	StrCpy $4 $WorkstationName		
	StrCpy $5 $NodeName		
	
	nsPython::execFile "$PLUGINSDIR\gecoscclink_step03.py"

    Pop $7	
	${If} $7 == "error"
		nsislog::log "$INSTDIR\${LOG_NAME}" "ConnectWithGECOSCC: ERROR linking to GECOS CC server! $4 ($5)"
		DetailPrint "ERROR linking to GECOS CC server! $4 ($5)"
		Abort
	${EndIf}	

	${If} $6 == "false"
		DetailPrint "ERROR linking to GECOS CC server!"
		Abort
	${EndIf}	

	nsislog::log "$INSTDIR\${LOG_NAME}" " "
	nsislog::log "$INSTDIR\${LOG_NAME}" "Successfuly linked to GECOS CC server!"

	
SectionEnd
