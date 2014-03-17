Procedure logiikka
push key clear
p_nayt=.t.
do luokitus
wait window '(F11) - select a case for current rule in anal-file' nowait
DEFINE WINDOW drgname FROM 0,3 TO min_y, max_x FONT  max_foty,  max_fosi
select drglogic
on key label f10 
on key label f11 do ordseek
select drglogic
set order to ord
set filter to inuse
seek anal.ord
select drgnames
seek drglogic.drg
activate window drgname
select drgnames
set filter to valid
browse fields mdc, drg, drgname:100, loc_drg nowait save in window drgname noedit
select drglogic
set filter to inuse 
activate window anal
browse fields ord, drg, drgnames.drgname:30, icd, mdc, pdgprop,or, procpro1, procpro2, procpro3, dgcat1, dgcat2, agelim:4, compl:2, sex:2, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, dur, icu, rtc, chdate, inuse noedit
release window drgname
do analohje
do luokitus
do analnayt
on key label f10 do logiikka
return

