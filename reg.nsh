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

;;  reg.nsh
;;    : Windows registry manipulation macros

!macro IfKeyExists ROOT MAIN_KEY KEY
	push $R0
	push $R1
	 
	!define Index 'Line${__LINE__}'
	 
	StrCpy $R1 "0"
	 
	"${Index}-Loop:"
	; Check for Key
	EnumRegKey $R0 ${ROOT} "${MAIN_KEY}" "$R1"
	StrCmp $R0 "" "${Index}-False"
	  IntOp $R1 $R1 + 1
	  StrCmp $R0 "${KEY}" "${Index}-True" "${Index}-Loop"
	 
	"${Index}-True:"
	;Return 1 if found
	push "1"
	goto "${Index}-End"
	 
	"${Index}-False:"
	;Return 0 if not found
	push "0"
	goto "${Index}-End"
	 
	"${Index}-End:"
	!undef Index
	exch 2
	pop $R0
	pop $R1
!macroend


!macro IfAppInstalled AppDisplayName
	push $R0
	push $R1
	 
	!define Index 'Line${__LINE__}'
	 
	StrCpy $R1 "0"
	 
	"${Index}-Loop:"
	; Check for Key
	EnumRegKey $R0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" "$R1"
	StrCmp $R0 "" "${Index}-False"
	  IntOp $R1 $R1 + 1
	  
	  ReadRegStr $R2 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$R0" "DisplayName"
	  StrCmp $R2 "${AppDisplayName}" "${Index}-True" "${Index}-Loop"
	 
	"${Index}-True:"
	;Return 1 if found
	push "1"
	goto "${Index}-End"
	 
	"${Index}-False:"
	;Return 0 if not found
	push "0"
	goto "${Index}-End"
	 
	"${Index}-End:"
	!undef Index
	exch 2
	pop $R0
	pop $R1
!macroend
