Procedure tpsaanto
if anal.tp1='   '
  wait window 'The case has no procedures'
  return
endif
push key clear
select csp
goto top
p_nayt=.t.
dg_n=1
dg_loop = .t.
lc_ryh=.f.
if lastkey()=101
  lc_ryh=.t.
endif
select drgtpt
lc_filt=filter()
set filter to valid
select csp
set relation to code into drgtpt
set filter to not released
select drgtpt
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin
set skip to tpomin
select dgomin
set order to dgprop
select drgtpt
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
set skip to dgomin
select csp
lc_order=order()
set skip to drgtpt
do while dg_loop
  if dg_n=0
    dg_n=9
  endif
  if dg_n>9
    dg_n=1
  endif
  if dg_n<>1
  endif
  wait window nowait 'Next procedure - [Ctrl][W], return to the testcase [Esc]'
  do case
  case dg_n=1
    wait window nowait 'This is first procedure of the case. Next procedure - [Ctrl][W], return to the testcase [Esc]'
    do tpetsi with anal.tp1
  case dg_n=2
    do tpetsi with anal.tp2
  case dg_n=3
    do tpetsi with anal.tp3
  case dg_n=4
    do tpetsi with anal.tp4
  case dg_n=5
    do tpetsi with anal.tp5
  case dg_n=6
    do tpetsi with anal.tp6
  case dg_n=7
    do tpetsi with anal.tp7
  case dg_n=8
   do tpetsi with anal.tp8
  case dg_n=9
    do tpetsi with anal.tp1
  endcase
  if dg_n>9
    loop
  endif
  select csp
  activate window anal
  if lc_ryh
    set order to tpomin
  endif
  do case
  case p_kieli='Com'
    browse fields drgtpt.chdate:9, csp.code:7 :R, csp.text:70, drgtpt.vartype, drgtpt.varval,;
    vartext=iif(drgtpt.vartype='DGPROP', dgomin.english, iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
    extproc=iif(drgtpt.vartype='PROCPR',tpomin.extens,'***'):8
  case p_kieli='Fin'
    browse fields drgtpt.chdate:9, csp.code:7 :R, csp.text:70, drgtpt.vartype, drgtpt.varval,;
    vartext=iif(drgtpt.vartype='DGPROP', dgomin.finish, iif(drgtpt.vartype='PROCPR',tpomin.finish,'***')):70,;
    extproc=iif(drgtpt.vartype='PROCPR',tpomin.extens,'***'):8 
  otherwise
    browse fields drgtpt.chdate:9, csp.code:7 :R, csp.text:70, drgtpt.vartype, drgtpt.varval,;
    vartext=iif(drgtpt.vartype='DGPROP', dgomin.english, iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
    extproc=iif(drgtpt.vartype='PROCPR',tpomin.extens,'***'):8 
  endcase
  set order to (lc_order)
  if lastkey()=27
    exit
  endif
  dg_n=dg_n+1
enddo
set filter to not deleted()
set relation to
select drgtpt
set relation to
*set filter to (lc_filt)
release window drgname
on key label ctrl+b
on key label alt+b
do analohje
do luokitus
do analnayt
return

procedure tplis
select drgtpt
lc_code=code
lc_language=language
lc_code_nc=code_nc
lc_code_d=code_d
lc_code_f=code_f
lc_code_s=code_s
lc_code_n=code_n
lc_or=or
lc_kompl=compl
append blank
replace change with date(), code with lc_code, language with lc_language,; 
code_nc with lc_code_nc, code_d with lc_code_d, code_f with lc_code_f,; 
code_s with lc_code_s, code_n with lc_code_n, or with lc_or, compl with lc_kompl
select csp
return

procedure tpetsi
parameter tpe_tp
select csp
set order to code
if tpe_tp=' '
   dg_n=10
   return
endif
seek tpe_tp
if not found() and p_allrules
  SET ORDER TO NCSP   && NCSP
  SEEK tpe_tp
ENDIF
tp_tp=code
*  tpe_loop=.t.
*  tp_tp=' '
*  select csp
*  seek tpe_tp
*  do while tpe_loop
*    if ord<>tpe_tp 
*      exit
*    endif
*    do case
*    case p_kieli='Dan' and code_den<>' '
*      tp_tp=code_den
*    case p_kieli='Eng' and code_eng<>' '
*      tp_tp=code_eng
*    case p_kieli='Fin' and code_fin<>' '
*      tp_tp=code_fin
*    case p_kieli='Est' and code_est<>' '
*      tp_tp=code_est
*    case p_kieli='Nor' and code_nor<>' '
*     tp_tp=code_nor
*    case p_kieli='Swe' and code_swe<>' '
*      tp_tp=code_swe
*    endcase
*    if tp_tp<>' '
*      exit
*    endif
*    if eof()
*      exit
*    endif
*    skip
*  enddo
*  select csp
*  seek tp_tp
if not found()
  wait window nowait tp_tp +' has now mapping in NCSP-'+p_kieli
endif
return 