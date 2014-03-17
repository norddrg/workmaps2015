procedure proctark
push key clear
on key label alt+f5 do cpstark
wait window 'ALT+F5 - look at ICD-9-CPS file' nowait
lc_nk=0
lc_kier=.t.
do while lc_kier
  select anal
  lc_nk=lc_nk+1
  do case
  case lc_nk=1
    lc_tp=tp1
  case lc_nk=2
    lc_tp=tp2
  case lc_nk=3
    lc_tp=tp3
  case lc_nk=4
    lc_tp=tp4
  case lc_nk=5
    lc_tp=tp5
  case lc_nk=6
    lc_tp=tp6
  case lc_nk=7
    lc_tp=tp7
  case lc_nk=8
    lc_tp=tp8
  case lc_nk=9
    lc_tp=tp9
  endcase
  if lc_tp=' '
    lc_nk=0
    loop
  endif
  select icd9cm_o
  set order to icd9_tp
  select link
  set relation to icd9cm_o into icd9cm_o
  seek lc_tp
  browse fields ncsp, icd9cm_o, icd9cm_o.nimi_cm
  if lastkey()=27
    exit
  endif
enddo
on key label alt+f5
select anal
do luokitus
pop key
return

proc cpstark
select icd9cm_o
seek link.icd9cm_o
browse
return