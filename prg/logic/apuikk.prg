PROCEDURE apuikk
PARAMETER lc_logi
set filter to
ON KEY LABEL alt+f
ON KEY LABEL alt+f11
on key label alt+b do apuikk3
on key label ctrl+B do apuikk2
lc_apuik=.t.
do while lc_apuik
  DEFINE WINDOW apuikk FROM max_y/5+6,1 TO max_y, max_x FONT  max_foty,  max_fosi Title alias()+ ': [CTRL][B] - change current record, [Ctrl][W] - return to basic window'
  ACTIVATE WINDOW apuikk
*  wait window '[CTRL][B] - change current record, [Ctrl][W] - return to basic window' nowait
  BROWSE noedit nodelete 
  if lastkey()=23 or lastkey()=133
    lc_apuik=.f.
  endif
enddo
release window apuikk
DO lognaytto
ON KEY LABEL f11 DO lognaytto
on key label alt+f do ..\logic\etsi
on key label alt+b DO logiappe
on key label ctrl+B do apuikk
RETURN
*: EOF: APUIKK.PRG
