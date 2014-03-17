procedure cspohje

pop key all
ACTIVATE WINDOW valikko
clear
@ 0,2 SAY 'DRG-definitions for procedure codes - '+p_kieli+'-version'

@ 2,5 SAY '[F11] - show'

@ 4,5 SAY '[F12] - define a new procedure property'
@ 5,5 say '[F10] - define a new diagnosis property'
@ 6,5 say '[Ctrl][F12] - annulment of a definition'
@ 7,5 say '[F8] - redefine CC-property'
@ 8,5 say '[F7] - redefine OR-property'

@10,5 say '[Alt][B] - insert a row to the current table'
@11,5 say '[Ctrl][B] - open the current table in a large window'

@13,5 say '[Alt][F] - search for NCSP code'
@14,5 say '[Ctrl][T] - search for undefined codes'
@15,5 say '[Alt][T] - compare local version definitions with NordDRG common version'

@17,5 say '[F6] - import the CSP table from external file (C:\data)'
@18,5 say '[Alt][F6] - edit CSP table' 
@19,5 say '[Ctrl][F6] find next non-OR procedure'


@21,5 say '[F4] - switch to DRG-logic table application'
@22,5 say '[F3] - switch to diagnosis application'
@23,5 say '[F2] - switch to test grouper application'

@ 25,5 SAY '[Ctrl][F1] - close current FoxPro application '
@ 26,5 SAY '[Alt][F1] - select logic and language version'

if max_y>28
  @ 28,5 Say '[Ctrl][F] - open search window '
  @ 29,5 say '[Ctrl][G] - repeat search'
  @ 30,5 say '[Ctrl][C] - copy selected text'
  @ 31,5 say '[Ctrl][V] - paste'
endif

*@ 6,5 say '[F9] - change order ncsp/icd-9-csp'
*@ 7,5 say '[Ctrl][F9] - all/undeleted records'
*@14,5 say '[Alt][R] - search for ICD-9-CSP code'
*@15,5 say '[Ctrl][R] - show ICD-9-CSP name'
*@18,5 say '[F5] - change to ICD-9-CSP definition'


ON KEY LABEL f12 DO ..\csp\siir
ON KEY LABEL ctrl+f12 DO ..\csp\peruutus
on key label f10 do ..\csp\siir_dg
*on key label alt+f10 do ..\csp\siir_dgp
ON KEY LABEL f11 DO ..\csp\csppaiv 
*on key label f9 do ..\csp\jarjesty
*on key label ctrl+f9 do ..\csp\filteri
*on key label alt+f10 do ..\csp\ncsppaiv

on key label  F7 do ..\csp\non_or
on key label  F8 do ..\csp\kompl

on key label f6 do ..\csp\csp_upda
on key label ctrl+f6 do ..\csp\ei_or
on key label alt+f6 do ..\csp\csp_edit
*on key label f5 do ncsp_csp\icd9vno

*on key label f5 do puut
on key label f4 do ..\logic\drglogi
on key label f3 do ..\dg\dgdrg
on key label f2 do ..\anal\drganal

on key label ctrl+t do ..\csp\tark with 'X'
on key label alt+t do ..\csp\diftark

on key label alt+f do ..\csp\koodets
*on key label alt+r do ..\csp\haku
*on key labe ctrl+r do ..\csp\cspname

on key label alt+b do ..\csp\lisays
on key label ctrl+b do ..\csp\isonay

on key label alt+f1 do ..\csp\_ncsp
on key label ctrl+f1 do ..\common\lopetus

return
