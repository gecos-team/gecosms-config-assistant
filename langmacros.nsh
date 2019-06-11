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
;; GECOS NSIS installer language macros
;;
 
!macro GECOS_MACRO_DEFAULT_STRING LABEL VALUE
  !ifndef "${LABEL}"
    !define "${LABEL}" "${VALUE}"
    !ifdef INSERT_DEFAULT
      !warning "${LANG} lang file missing ${LABEL}, using default..."
    !endif
  !endif
!macroend
 
!macro GECOS_MACRO_LANGSTRING_INSERT LABEL LANG
  LangString "${LABEL}" "${LANG_${LANG}}" "${${LABEL}}"
  !undef "${LABEL}"
!macroend
 
!macro GECOS_MACRO_LANGUAGEFILE_BEGIN LANG
  !define CUR_LANG "${LANG}"
!macroend
 
!macro GECOS_MACRO_LANGUAGEFILE_END
  !define INSERT_DEFAULT
  !include "${GECOS_DEFAULT_LANGFILE}"
  !undef INSERT_DEFAULT
 
  ; String labels should match those from the default language file.
 
  
	; NetworkInterefacesShow
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_CHECK_NETWORK_INTERFACES_HEADER		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_CHECK_NETWORK_INTERFACES_SUBHEADER	${CUR_LANG}

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_CHECKING_NETWORK_INTERFACES			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_NETWORK_ADAPTERS					${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_NETWORK_ADAPTER_DESCRIPTION			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_NETWORK_ADAPTER_PHYSICAL_ADDRESS	${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_NETWORK_ADAPTER_IP_ADDRESS			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_NO_NETWORK_ERROR_MESSAGE			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT  GECOS_NO_NETWORK_INTERFACES_FOUND			${CUR_LANG}
 
  ; LoadGECOSCCSetupData
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_CONNECTION_DATA_HEADER			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_CONNECTION_DATA_SUBHEADER			${CUR_LANG}

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT PLEASE_ENTER_DATA_TO_CONNECT_TO_GECOS		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_CONNECTION_DATA					${CUR_LANG}
  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT URL		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT USER		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT PASSWORD	${CUR_LANG}
  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT EMPTY_URL		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT BAD_URL		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT EMPTY_USER		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT EMPTY_PASSWORD	${CUR_LANG}

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_CONNECTION_ERROR_MESSAGE	${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_LOCAL_DISCONNECTION	${CUR_LANG}

  ; LoadGECOSCCSetupDataShow
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_AUTOSETUP_DATA_HEADER		${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_AUTOSETUP_DATA_SUBHEADER	${CUR_LANG}

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_AUTOSETUP_DATA			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_AUTOSETUP_DATA_VERSION	${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_AUTOSETUP_DATA_ORGANIZATION	${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_AUTOSETUP_DATA_NOTES		${CUR_LANG}

  
  ; LoadWorkstationData  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_DATA_HEADER			${CUR_LANG}
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_DATA_SUBHEADER		${CUR_LANG}  

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_DATA_LABEL			${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_NAME					${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_OU_NAME				${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_SEARCH_BUTTON			${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_SELECTED_OU			${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_CLICK_SEARCH			${CUR_LANG}  
  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_NAME_EMPTY			${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_NAME_IN_USE			${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_OU_ERROR				${CUR_LANG}  

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_WORKSTATION_NODE_NAME				${CUR_LANG}  
  

  ; un.UnlinkGECOSCCShow
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_HEADER						${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_SUBHEADER					${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_LOCAL_SUBHEADER			${CUR_LANG}  

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_DISCONNECTING				${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_DISCONNECTION_PROCESS		${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_DISCONNECTING_ERROR		${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_DISCONNECTING_SUCCESS		${CUR_LANG}  

  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_UNINSTAL_CHEF				${CUR_LANG}  
  !insertmacro GECOS_MACRO_LANGSTRING_INSERT GECOS_CC_UNLINK_UNINSTAL_CHEF_SUCCESS		${CUR_LANG}  
  

  !undef CUR_LANG
!macroend
 
!macro GECOS_MACRO_INCLUDE_LANGFILE LANG FILE
  !insertmacro GECOS_MACRO_LANGUAGEFILE_BEGIN "${LANG}"
  !include "${FILE}"
  !insertmacro GECOS_MACRO_LANGUAGEFILE_END
!macroend