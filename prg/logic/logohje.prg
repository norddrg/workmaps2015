Procedure logohje

DEFINE WINDOW valikko FROM 1,1 TO max_y, 2*max_x/3 FONT  max_foty,  max_fosi
ACTIVATE WINDOW valikko
CLEAR
select drglogic
set fullpath off
if p_class
  lc_class='Classic version'
else
  lc_class='Full version'
endif
@ 0,0 SAY 'NordDRG - logic of the DRG assignment process - '+p_kieli+' - '+dbf()+' '+lc_class
set fullpath on
@ 2,5 SAY '[F11] - refresh screen'
@ 3,5 SAY '[F9] - toggle sorting order (logic/drg/mdc)'
@ 4,5 SAY '[Alt][F] - search for index column content'
@ 5,5 SAY '[Ctrl][F] - search for any value'

@ 7,5 say '[F12] - show intermediate variables of current DRG row'
@ 8,5 say '[F5] - show contents of the intermediate variables'

@10,5 SAY '[Alt][B] - insert a row (new rule) to the table'
@11,5 say '[Ctrl][B] - edit the current row'

@13,5 say '[F8] - edit RTC codes'
@14,5 say '[F7] - produce text files for the NordDRG-manual'

@16,5 say '[F4] - switch to procedure application'
@17,5 say '[F3] - switch to diagnosis application'
@18,5 say '[F2] - switch to test grouper application'

@20,5 SAY '[Ctrl][F1] - Close current FoxPro application '
@21,5 SAY '[Alt][F1] - select logic and language version'
@22,5 SAY '[F1] - help'

*@ 3,5 say '[Ctrl][F12] make file for Ventura'
*@ 7,5 say '[F6] look and change rtc-codes'

on key label f12 do ..\logic\drgsis
ON KEY LABEL f11 DO ..\logic\lognaytto
on key label f10
ON KEY LABEL f9 DO ..\logic\logijarj
ON KEY LABEL alt+B DO ..\logic\logiappe
ON KEY LABEL ctrl+B DO ..\logic\apuikk WITH .T.
on key label f6 do ..\logic\rtcedi
on key label ctrl+f12 do ..\logic\ventsis
on key label f5 do ..\logic\drgyks
on key label f8 do ..\logic\rtcedi
on key label f7 do ..\logic\listmuod
on key label alt+f do ..\logic\etsi

on key label f4 do ..\csp\ncsp
on key label f3 do ..\dg\_dgdrg
on key label f2 do ..\anal\drganal
on key label ctrl+f1 do ..\common\lopetus
on key label f1 do ..\logic\logohje

ON KEY LABEL alt+f1 DO ..\logic\_drglogi
return
