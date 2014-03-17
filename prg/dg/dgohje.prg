procedure dgohje
DEFINE WINDOW valikko FROM 1,1 to max_y-2, 2*min_x-2 FONT  max_foty,  max_fosi
Activate WINDOW valikko
CLEAR
@ 0,0 say 'NordDRG-definition programme for diagnoses'

@ 2,5 say '[F11] - show'

@ 4,5 say '[F12] - define properties of an ICD code'
@ 5,5 say '[Ctrl][F12] - define a new code pair'
@ 6,5 say '[Alt][X] - deletion of a definition'
@ 7,5 say '[F10] - toggle sorting order (code/d_code)'
@ 8,5 say '[Alt][F] - search for an ICD-10 code'
@ 9,5 say '[Ctrl][B] - open the current table in a larger window'
@10,5 say '[Alt][B] - insert a row to the current table'


@12,5 say '[Ctrl][T] - search for next undefined code'
@13,5 say '[Alt][T] - compare with NordDRG Common version defintions'
@14,5 say '[Ctrl][K] - add a code to a CC exclusion group'
@15,5 say '[F5] - produce files for external use and reporting'
@16,5 say '[Alt][F5] - import the ICD-10 table from external file (C:\data)'

@18,5 say '[Ctrl][F] - open search window'
@19,5 say '[Ctrl][G] - repeat search'
@20,5 say '[Ctrl][C] - copy selected text'
@21,5 say '[Ctrl][V] - paste'

@22,5 say '[F6] - ICD update from file placed in c:\data'
@23,5 say '[F4] - switch to procedure application'
@24,5 say '[F3] - switch to DRG-logic table application'
@25,5 say '[F2] - switch to test grouper application'

@27,5 say '[Ctrl][F1] - close current FoxPro application '
@28,5 say '[Alt][F1] - select logic and language version'


on KEY label f12 do ..\dg\MAARITYS
on KEY label ctrl+f12 do ..\dg\NEWDA
on KEY label Alt+X do ..\dg\peruutus

on KEY label f11 do ..\dg\dgpaiv
on KEY label f10 do ..\dg\DGJARJ

on KEY label ctrl+T do ..\dg\tehdyt
on key label alt+t do ..\dg\dgdtark
on key label F6 do ..\dg\icdupda
on KEY label f5 do ..\dg\NDRGSIIR
on KEY label Alt+f5 do ..\dg\ICDUPDA
on KEY label f4 do ..\csp\ncsp
on KEY label f3 do ..\logic\drglogi
on KEY label f2 do ..\anal\drganal

on KEY label ctrl+B do ..\dg\EDIIKK
on KEY label Alt+B do ..\dg\APPEIKK

on KEY label ctrl+F1 do ..\common\LOPETUS
on KEY label Alt+F1 do ..\dg\_DGDRG


on KEY label ctrl+K do ..\dg\exclmaar
on KEY label ctrl+j do ..\dg\COMPLTARK
on KEY label Alt+F do ..\dg\KOODHAK
return
