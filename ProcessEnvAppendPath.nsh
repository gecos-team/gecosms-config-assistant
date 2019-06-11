; Code from http://stackoverflow.com/questions/32382784/nsi-script-to-equivalent-to-bat-script/32384667#32384667

!define ERROR_ENVVAR_NOT_FOUND 203

!if "${NSIS_PTR_SIZE}" <= 4
!include LogicLib.nsh

!macro ProcessEnvAppendPath un

Function ${un}ProcessEnvAppendPath ; IN:Path OUT:N/A
System::Store S
Pop $1
System::Call 'KERNEL32::GetEnvironmentVariable(t "PATH", t, i0)i.r0'
${If} $0 = 0
    System::Call 'KERNEL32::SetEnvironmentVariable(t "PATH", tr1)'
${Else}
    StrLen $2 $1
    System::Call '*(&t$0,&t1,&t$2)i.r9'
    System::Call 'KERNEL32::GetEnvironmentVariable(t "PATH", ir9, ir0)i.r0'
    StrCpy $2 0
    ${IfThen} $0 > 0 ${|} IntOp $2 $0 - 1 ${|} 
    System::Call '*$9(&t$2,&t1.r2)' ; Store the last character from %PATH% in $2
    StrCpy $3 ';'
    ${IfThen} $2 == ';' ${|} StrCpy $3 "" ${|}
    System::Call 'KERNEL32::lstrcat(ir9, tr3)' ; Append ";" or ""
    System::Call 'KERNEL32::lstrcat(ir9, tr1)'
    System::Call 'KERNEL32::SetEnvironmentVariable(t "PATH", ir9)'
    System::Free $9
${EndIf}
System::Store L
FunctionEnd


!macroend
 
!insertmacro ProcessEnvAppendPath ""
!insertmacro ProcessEnvAppendPath "un."


!endif


!macro SetEnvironmentVariable un

Function ${un}SetEnvironmentVariable ; IN:name, value OUT:N/A
	System::Store S
	Pop $2
	Pop $1
	System::Call 'KERNEL32::SetEnvironmentVariable(tr1, tr2)'
	System::Store L
FunctionEnd

!macroend

!insertmacro SetEnvironmentVariable ""
!insertmacro SetEnvironmentVariable "un."

!macro GetEnvironmentVariable un

Function ${un}GetEnvironmentVariable ; IN:name OUT:value
	System::Store S
	Pop $1
	System::Call 'KERNEL32::GetEnvironmentVariable(tr1, t, i0)i.r0'
	${If} $0 = 0
		Push ""
	${Else}
		System::Call '*(&t$0)i.r9'
		System::Call 'KERNEL32::GetEnvironmentVariable(tr1, ir9, ir0)i.r0'
		StrCpy $2 0
		System::Call '*$9(&t$2,&t$0.r2)' ; Store all the characters in $2
		Push $2
	${EndIf}	
		
	System::Store L
FunctionEnd

!macroend

!insertmacro GetEnvironmentVariable ""
!insertmacro GetEnvironmentVariable "un."
