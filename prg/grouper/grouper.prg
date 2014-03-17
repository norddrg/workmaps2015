Procedure grouper
SET STATUS OFF
public p_logluku
p_logluku=.f.
select drgdistr
set order to drg
replace all n_cas with 0, n_case with 0, dur_mean with 0, exp_mean with 0
goto top
if nam_sho<>'Total'
  append blank
endif
replace drg with ' ', nam_sho with 'Total', valid with .t., drg with p_kieli, ;
mdc with substr (p_logic, at('_',p_logic)+1, at('.',p_logic)-at('_',p_logic)-1)
p_grp=.t.

lc_exp=0
lc_dur=0
lc_ncas=0
lc_ncase=0
lc_loop=.t.
lc_all=.f.

t_alku=val(sys(2))
lc_n_anal=0
select anal
lc_recno=recno()
do grpohje
wait window 'DRG assignment of all cases (A) or starting from current record -' +str(lc_recno,7,0)+'- (C)'
if lastkey()=65 or lastkey()=97
  GOTO top
  lc_all=.t.
  lc_file=0
  IF ds_parts
    SELECT anal
    USE SUBSTR(ds_datase2,1, RAT('_',ds_datase2)-1)+'_'+STR(lc_file,1) ALIAS Anal
    GOTO top
  ENDIF 
ELSE 
  goto (lc_recno) 
endif
do while lc_loop
  IF EOF()
     IF lc_all 
       IF ds_parts
         ON ERROR exit
         lc_file=lc_file+1
         SELECT anal
         USE SUBSTR(ds_datase2,1,RAT('_',ds_datase2)-1)+'_'+STR(lc_file,1) ALIAS Anal
         GOTO top
         ON ERROR
       else
         exit
       endif
     ELSE
       EXIT
     endif
  ENDIF
  lc_n_anal=lc_n_anal+1
  if 1000*int((lc_n_anal-1)/1000)=lc_n_anal-1 
     wait window str(lc_n_anal,10,0)+' cases, '+str(val(sys(2))-t_alku,10,0)+' seconds, ';
     + str(lc_n_anal/(val(sys(2))-t_alku),4,0) +'/s, current record '+str(recno(),7,0) nowait
  endif
  if oir1=' ' and syy1<>' '
    replace oir1 with syy1
    replace syy1 with ' '
  endif
  if oir1<>' '
    if oir1<>dg_korj(oir1)
      replace oir1 with dg_korj(oir1)
    endif
  endif
  if oir2=' ' and syy2<>' '
    replace oir2 with syy2
    replace syy2 with ' '
  endif
  if oir2<>' '
    if oir2<>dg_korj(oir2)
      replace oir2 with dg_korj(oir2)
    endif
  endif
  if oir3=' ' and syy3<>' '
    replace oir3 with syy3
    replace syy3 with ' '
  endif
  if oir3<>' '
    if oir3<>dg_korj(oir3)
      replace oir3 with dg_korj(oir3)
    endif
  endif
  if oir4=' ' and syy4<>' '
    replace oir4 with syy4
    replace syy4 with ' '
  endif
  if oir4<>' '
    if oir4<>dg_korj(oir4)
      replace oir4 with dg_korj(oir4)
    endif
  endif
  if oir5=' ' and syy5<>' '
    replace oir5 with syy5
    replace syy5 with ' '
  endif
  if oir5<>' '
    if oir5<>dg_korj(oir5)
      replace oir5 with dg_korj(oir5)
    endif
  endif
  if oir6=' ' and syy6<>' '
    replace oir6 with syy6
    replace syy6 with ' '
  endif
  if oir6<>' '
    if oir6<>dg_korj(oir6)
      replace oir6 with dg_korj(oir6)
    endif
  endif
  if oir7=' ' and syy7<>' '
    replace oir7 with syy7
    replace syy7 with ' '
  endif
  if oir7<>' '
    if oir7<>dg_korj(oir7)
      replace oir7 with dg_korj(oir7)
    endif
  endif
  if oir8=' ' and syy8<>' '
    replace oir8 with syy8
    replace syy8 with ' '
  endif
  if oir8<>' '
    if oir8<>dg_korj(oir8)
      replace oir8 with dg_korj(oir8)
    endif
  endif
  if oir9=' ' and syy9<>' '
    replace oir9 with syy9
    replace syy9 with ' '
  endif
  if oir9<>' '
    if oir9<>dg_korj(oir9)
      replace oir9 with dg_korj(oir9)
    endif
  endif
  if syy1<>' '
    if syy1<>dg_korj(syy1)
      replace syy1 with dg_korj(syy1)
    endif
  endif
  if syy2<>' '
    if syy2<>dg_korj(syy2)
      replace syy2 with dg_korj(syy2)
    endif
  endif
  if syy3<>' '
    if syy3<>dg_korj(syy3)
      replace syy3 with dg_korj(syy3)
    endif
  endif
  if syy4<>' '
    if syy4<>dg_korj(syy4)
      replace syy4 with dg_korj(syy4)
    endif
  endif
   if syy5<>' '
    if syy5<>dg_korj(syy5)
      replace syy5 with dg_korj(syy5)
    endif
  endif
  if syy6<>' '
    if syy6<>dg_korj(syy6)
      replace syy6 with dg_korj(syy6)
    endif
  endif
  if syy7<>' '
    if syy7<>dg_korj(syy7)
      replace syy7 with dg_korj(syy7)
    endif
  endif
  if syy8<>' '
    if syy8<>dg_korj(syy8)
      replace syy8 with dg_korj(syy8)
    endif
  endif
  if syy9<>' '
    if syy9<>dg_korj(syy9)
      replace syy9 with dg_korj(syy9)
    endif
  endif
  if p_ika='Y'
    replace ika with 365*age
  endif
  do ..\anal\luokitus
  select anal
  skip
enddo

set safety on
t_loppu=val(sys(2))
do grpohje

wait window nowait "DRG assignment performed"

activate window anal
browse in window anal save nowait
p_grp=.f.
do grpohje
RETURN
*: EOF: DGDRG.PRG

function dg_korj
parameter dgdg
if len(trim(dgdg))>3 and at ('.',dgdg)<>4 and substr(dgdg,4,1)<'A'
  dgdg=substr(dgdg,1,3)+'.'+substr(dgdg,4,2)
endif
return dgdg
endfunc