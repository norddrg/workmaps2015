Procedure dgsaanto
push key clear
p_nayt=.t.
lc_lastkey=lastkey()
dg_n=1
dg_loop = .t.
on key label pgdn
on key label pgup
on key label alt+k do komplex
select icd_10
SET ORDER TO code
select dg
set filter to valid
set relation to IIF(vartype='DGCAT' or vartype='MDC', SUBSTR(varval,1,2)+SUBSTR(varval,4,2),' ') into dgkat
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
set relation to IIF(vartype='PDGPRO',trim(varval),' ') into pdgomin additive
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin additive
set relation to IIF(vartype='COMPL',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into kompkat additive
set relation to trim(upper(code+d_code)) into icd_10 additive
DEFINE WINDOW drgname FROM 0,3 TO min_y, max_x FONT  max_foty,  max_fosi
dg_kier=1
do while dg_loop
  wait window '[Ctrl][W] - next diagnosis, [Esc] - return, [Alt][K] - complication exclusions' nowait
  select dg
  if dg_n=0
    dg_n=9
  endif
  if dg_n=10
    dg_n=1
  endif
  do case
  case dg_n=1
    wait window 'This is principal diagnosis!   [Ctrl][W] - next diagnosis, [Esc] - return, [Alt][K] - complication exclusions' nowait
    dgs_oir=anal.oir1
    dgs_syy=anal.syy1
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=2
    if anal.oir2=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir2
    dgs_syy=anal.syy2
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=3
    if anal.oir3=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir3
    dgs_syy=anal.syy3
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=4
    if anal.oir4=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir4
    dgs_syy=anal.syy4
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=5
    if anal.oir5=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir5
    dgs_syy=anal.syy5
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=6
    if anal.oir6=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir6
    dgs_syy=anal.syy6
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=7
    if anal.oir7=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir7
    dgs_syy=anal.syy7
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=8
    if anal.oir8=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir8
    dgs_syy=anal.syy8
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  case dg_n=9
    if anal.oir9=' ' 
      dg_n=1
      loop
    endif
    dgs_oir=anal.oir9
    dgs_syy=anal.syy9
    do dgmapp with dgs_oir
    do dgmapp with dgs_syy
  endcase
  select dg
  if dg_kier=1
    seek upper(dgs_oir+dgs_syy)
    if not found()
      seek upper(dgs_oir)
    endif
    if dgs_syy<>' '
      dg_kier=2
    endif
  else
    seek upper(dgs_syy)
    dg_kier=1
  endif
  select icd_10
  activate window drgname
  Browse fields  code:10, d_code:10, text:80, code_w:10, d_code_w:10, icd10to9.icd9_cm, icd10to9.icd9_cm2 nowait nodelete noedit save in window drgname
  select dg
  do case 
  case lc_lastkey=102
    set filter to valid and vartype='DGCAT'
  case lc_lastkey=112
     set filter to valid and vartype='DGPROP'
  case lc_lastkey=92
     set filter to valid and vartype='COMPL'
  otherwise
     set filter to valid 
  endcase
  activate window anal
  browse fields chdate:6, code, d_code, vartype, varval,;
  vartext=iif(vartype='DGCAT' or vartype='MDC', dgkat.english, iif(vartype='DGPROP', dgomin.english,;
  iif(vartype='PDGPRO',pdgomin.english, iif(vartype='PROCPR',tpomin.english,;
  iif(vartype='COMPL',kompkat.english,'***'))))):70 
  set order to code
  if lastkey()=27
    exit
  endif
  if dg_kier=1
    dg_n=dg_n+1
  endif
enddo
on key label alt+k 
on key label alt+B
on key label ctrl+B
release window drgname
release window drgkaan
select dg
set filter to valid
set relation to
do analohje
do luokitus
do analnayt
return

procedur lisays
select dg
lc_icd_o=code
lc_icd_e=d_code
lc_who=who
lc_valid=valid
lccodew=code_w
lcdcodew=d_code_w
lc_mdc=mdc
lc_dgkat=dgcat
lc_kompl=compl
lc_tpomin=procprop
append blank
replace code with lc_icd_o, d_code with lc_icd_e, who with lc_who, valid with lc_valid,;
code_w with lccodew, d_code_w with lcdcodew, mdc with lc_mdc, dgcat with lc_dgkat, compl with lc_kompl, procprop with lc_tpomin
return

procedure dgmapp
parameter dgm_dg
if p_allrules and dgm_dg<>' '
  select icd_10
  seek dgm_dg
  if not found()
    set order to code_w
    seek dgm_dg
    if found()
      dgm_dg=code
    endif
    set order to code
  endif
endif
select anal
return dgm_dg