;;  vim:syn=winbatch:fileencoding=cp1252:
;;
;;  English.nsh
;;
;;  English language strings for the Windows GECOS NSIS installer.
;;  Windows Code page: 1252
;;
;;  Author: Abraham Macias <amacias@gruposolutia.com>
;;
 
!define DIFFERENT_CHEF_VERSION_MESSAGE				"Existe una versi�n distinta de Opscode Chef instalada. $\n$\nHaga clic en `Aceptar` para borrar esta versi�n o `Cancelar` para cancelar esta instalaci�n."

 
; NetworkInterefacesShow
!define GECOS_CHECK_NETWORK_INTERFACES_HEADER			"Interfaces de red"
!define GECOS_CHECK_NETWORK_INTERFACES_SUBHEADER		"Compruebe que tiene conexi�n a internet."

!define GECOS_CHECKING_NETWORK_INTERFACES			"Comprobando adaptadores de red..."
!define GECOS_NETWORK_ADAPTERS						"ADAPTADORES DE RED$\r$\n---------------"
!define GECOS_NETWORK_ADAPTER_DESCRIPTION			"Descripci�n.....:"
!define GECOS_NETWORK_ADAPTER_PHYSICAL_ADDRESS		"Direcci�n F�sica:"
!define GECOS_NETWORK_ADAPTER_IP_ADDRESS			"Direcci�n IP....:"

!define GECOS_NO_NETWORK_ERROR_MESSAGE				"Se necesita conexi�n a internet para instalar y usar GECOS. �La instalaci�n se detendr� aqu�! Por favor con�ctese a internet para instalar GECOS."
!define GECOS_NO_NETWORK_INTERFACES_FOUND			"�No se han encontrado interfaces de red!"


 
; LoadGECOSCCSetupData
!define GECOS_CC_CONNECTION_DATA_HEADER			"Datos de conexi�n al Centro de Control GECOS"
!define GECOS_CC_CONNECTION_DATA_SUBHEADER		"Por favor introduzca los datos para conectar con el Centro de Control GECOS."

!define PLEASE_ENTER_DATA_TO_CONNECT_TO_GECOS	"Por favor introduzca los datos para conectar con el Centro de Control GECOS."
!define GECOS_CC_CONNECTION_DATA				"Datos de conexi�n al Centro de Control GECOS:"

!define URL				"URL:"
!define USER			"Usuario:"
!define PASSWORD		"Contrase�a:"

!define EMPTY_URL		"�El campo URL est� vac�o!"
!define BAD_URL			"�URL mal formada en el campo URL!"
!define EMPTY_USER		"�El campo Usuario est� vac�o!"
!define EMPTY_PASSWORD	"�El campo Contrase�a est� vac�o!"

!define GECOS_CC_CONNECTION_ERROR_MESSAGE		"�No se puede conectar con el Centro de Control GECOS! Por favor revise la URL, el usuario, la contrase�a, y su conexi�n a internet."

!define GECOS_CC_LOCAL_DISCONNECTION			"Desconexi�n local"

; LoadGECOSCCSetupDataShow
!define GECOS_CC_AUTOSETUP_DATA_HEADER			"Autoconfiguraci�n del Centro de Control GECOS"
!define GECOS_CC_AUTOSETUP_DATA_SUBHEADER		"Por favor, compruebe los datos de autoconfiguraci�n del Centro de Control GECOS."

!define GECOS_CC_AUTOSETUP_DATA					"Datos obtenidos del Centro de Control GECOS:"
!define GECOS_CC_AUTOSETUP_DATA_VERSION			"Versi�n"
!define GECOS_CC_AUTOSETUP_DATA_ORGANIZATION	"Organizaci�n"
!define GECOS_CC_AUTOSETUP_DATA_NOTES			"Notas"


; LoadWorkstationData  
!define GECOS_CC_WORKSTATION_DATA_HEADER		"Datos de la estaci�n de trabajo"
!define GECOS_CC_WORKSTATION_DATA_SUBHEADER		"Por favor introduzca los datos del PC."

!define GECOS_CC_WORKSTATION_DATA_LABEL			"Por favor introduzca los datos del PC para el Centro de Control GECOS."
!define GECOS_CC_WORKSTATION_NAME				"Nombre del PC:"
!define GECOS_CC_WORKSTATION_OU_NAME			"Nombre de la OU:"
!define GECOS_CC_WORKSTATION_SEARCH_BUTTON		"Buscar"
!define GECOS_CC_WORKSTATION_SELECTED_OU		"OU elegida:"
!define GECOS_CC_WORKSTATION_CLICK_SEARCH		"Pulse el bot�n Buscar"

!define GECOS_CC_WORKSTATION_NAME_EMPTY			"�El nombre del PC est� vac�o!"
!define GECOS_CC_WORKSTATION_NAME_IN_USE		"Este nombre de PC ya se est� usando, por favor elija otro."

!define GECOS_CC_WORKSTATION_OU_ERROR			"�Por favor elija una OU!"

!define GECOS_CC_WORKSTATION_NODE_NAME			"Nombre del Nodo:"

; un.UnlinkGECOSCCShow
!define GECOS_CC_UNLINK_HEADER					"Desvincular del Centro de Control GECOS"
!define GECOS_CC_UNLINK_SUBHEADER				"Por favor espere mientras su PC se desconecta del Centro de Control GECOS."
!define GECOS_CC_UNLINK_LOCAL_SUBHEADER			"Por favor espere mientras los datos de conexi�n a GECOS son borrados de su PC."


!define GECOS_CC_UNLINK_DISCONNECTING			"Desconectando del Centro de Control GECOS..."
!define GECOS_CC_UNLINK_DISCONNECTION_PROCESS	"Proceso de desconexi�n..."
!define GECOS_CC_UNLINK_DISCONNECTING_ERROR		"�Error al desconectar del Centro de Control GECOS!"
!define GECOS_CC_UNLINK_DISCONNECTING_SUCCESS	"�Se ha desconectado correctamente del Centro de Control GECOS!"

!define GECOS_CC_UNLINK_UNINSTAL_CHEF			"Desinstalando Opscode Chef..."
!define GECOS_CC_UNLINK_UNINSTAL_CHEF_SUCCESS	"�Opscode Chef desinstalado!"
