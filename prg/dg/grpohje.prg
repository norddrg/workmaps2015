PROCEDURE grpohje
select drgdistr
activate window anal
browse in window anal save nowait

DEFINE WINDOW valikko FROM 1,1 TO max_y, 2*min_x FONT  max_foty,  max_fosi
ACTIVATE WINDOW valikko
CLEAR

set fullpath off
@ 0,5 SAY 'NORD-DRG - testgrouper'

@ 2,5 say 'File         : '+dbf()
@ 3,5 SAY 'Language     : '+p_kieli
@ 4,5 say 'Logic version: '+p_logic
set fullpath on
@ 6,5 SAY 'Original file: '+ds_datasel
@ 7,5 SAY 'Output file  : '+ds_datase2
select anal
cur_rec=recno()
if eof()
  cur_rec=cur_rec-1
endif
lc_order=order()
set order to
goto bottom
@ 8,5 say 'Current record '+str(cur_rec,10,0)+'/'+str(recno(),10,0)
select anal
set order to (lc_order)
goto (cur_rec)

@ 17,5 say '[F12] - Start grouping'
@ 18,5 say '[F11] - Calculate means of expences and durations'
@ 19,5 say '[F10] - Add calculated weights to original data'
@ 21,5 say '[F8]        - Browse the analyzed file'
@ 22,5 say '[Alt][F8]   - Create indexed searchable database and start using it'
@ 23,5 say '[Ctrl][F8]  - Create ;-limited textfile from the output'
@ 24,5 say '[F7]  - Create DRG specific files from testdata'

@ 25,5 say '[F6]  - Switch version nationality'
@ 26,5 say '[F5]  - Swithc logic-file'

@ 28,5 say '[F4]  - Switch to procedure application'
@ 29,5 say '[F3]  - Switch to diagnosis application'
@ 30,5 say '[F2]  - Switch to DRG-logic table application'
@ 31,5 say '[Alt][F1]  - restart the programme'
@ 32,5 say '[Ctrl][F1] - return to FoxPro'
@ 33,5 say '[F1] - Help'

on key label f12 do grouper
on key label f11 do exp_msd
on key label f10 do insweigh

on key label f8 do analbrow
on key label alt+F8 do analcrea
on key label ctrl+f8 do txtcrea
on key label alt+f1 do ..\anal\_drganal
on key label ctrl+f1 do lopetus
on key label f7 do drgkir0

on key label f6 do ..\common\langsel
on key label f5 do logic
on key label f4 do ..\csp\_ncsp
on key label f3 do ..\dg\_dgdrg
on key label f2 do ..\logic\_drglogi
on key label f1 do grpohje
RETURN
*: EOF: grp.PRG
