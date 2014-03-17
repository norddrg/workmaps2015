Procedure CSP_EDIT
select csp
set relation to
on key label alt+f10 do csp_lis
wait window nowait '[Alt][F10] - Lis‰‰ rivi'
edit
on key label alt+f10 do csp_edit
replace code with rtrim(code)
select drgtpt
set relation to
select csp
set filter to not released
set order to code
set relation to code into drgtpt
set skip to drgtpt
if p_kieli<>'Com'
  set relation to ncsp into csp_en additive
endif
do csppaiv
return

procedure csp_lis
append blank
replace change with date()
replace headline with .f.
replace released with .f.
replace valid with .t.
return