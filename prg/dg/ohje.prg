*:******************************************************************************
*:
*: Procedure File C:\DATA\NDMS\PRG\DG\OHJE.PRG
*:
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	
*:	Nordic Centre for Classification of Diseases
*:	
*:	Nordic Centre for Classification of Diseaes
*:	NordDRG Maintenance system
*:	
*:
*: Documented using Visual FoxPro Formatting wizard version  .05
*:******************************************************************************
*:   ohje
*!******************************************************************************
*!
*! Procedure OHJE
*!
*!******************************************************************************
procedure ohje
DEFINE WINDOW valikko FROM 1,1 to max_y-2, 2*min_x-2 FONT  max_foty,  max_fosi
Activate WINDOW valikko
CLEAR
@ 0,0 say 'NordDRG-definition programme for diagnoses'

@ 2,5 say '[F11] - show'

@ 4,5 say '[F12] - define properties of an ICD code'
@ 5,5 say '[Ctrl][F12] - define a new code pair'
@ 6,5 say '[Alt][X] - annulment of a definition'
@ 7,5 say '[F10] - toggle sorting order (code/d_code)'
@ 8,5 say '[Alt][F] - search for an ICD-10 code'
@ 9,5 say '[Ctrl][B] - open the current table in a larger window'
@10,5 say '[Alt][B] - insert a row to the current table'


@12,5 say '[Ctrl][T] - search for next undefined code'
@13,5 say '[Ctrl][K] - add a code to a CC exclusion group'

@15,5 say '[F5] - produce files for external use and reporting'
@16,5 say '[Alt][F5] - import the ICD-10 table from external file (C:\data)'

@18,5 say '[Ctrl][F] - open search window'
@19,5 say '[Ctrl][G] - repeat search'
@20,5 say '[Ctrl][C] - copy selected text'
@21,5 say '[Ctrl][V] - paste'

@23,5 say '[F4] - switch to procedure application'
@24,5 say '[F3] - switch to DRG-logic table application'
@25,5 say '[F2] - switch to test grouper application'

@27,5 say '[Ctrl][F1] - close current FoxPro application '
@28,5 say '[Alt][F1] - select logic and language version'


on KEY label f12 do MAARITYS
on KEY label ctrl+f12 do NEWDA
on KEY label Alt+X do peruutus

on KEY label f11 do paiv
on KEY label f10 do DGJARJ

on KEY label ctrl+T do tehdyt
on KEY label f5 do NDRGSIIR
on KEY label Alt+f5 do ICDUPDA
on KEY label f4 do ..\csp\ncsp
on KEY label f3 do ..\logic\drglogi
on KEY label f2 do ..\anal\drganal

on KEY label ctrl+B do EDIIKK
on KEY label Alt+B do APPEIKK

on KEY label ctrl+F1 do ..\common\LOPETUS
on KEY label Alt+F1 do _DGDRG


on KEY label ctrl+K do exclmaar
on KEY label ctrl+j do COMPLTARK
on KEY label Alt+F do KOODHAK
return
