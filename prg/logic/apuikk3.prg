procedure apuikk3
if alias()='DRGLOGIC'
  do naytto
  do logiappe
  lc_apuik=.f.
  return
endif
lc_mdc=mdc
lc_drg=drg
append blank
replace mdc with lc_mdc, drg with lc_drg, valid with .t., chdate with date()
edit
if lastkey()=27
  replace valid with .f.
  delete
endif
release window apuikk
return