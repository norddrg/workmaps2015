procedure ordseek
if not inuse
  wait window nowait drglogic.ord+' is not in use in this version of NordDRG'
  return
ENDIF
select anal
ors_found=.t.
set order to ord
set near on
seek drglogic.ord
if not found()
  ors_found=.f.
endif
do analohje
do analnayt
if not ors_found
  wait window 'No case with ord-code '+drglogic.ord+' found'
  ? chr(7)+chr(7)
  ? chr(7)
endif
on key label F11 do analkats
on key label f10 do logiikka
return