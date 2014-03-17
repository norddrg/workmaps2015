procedure ncsppaiv
wait window nowait 'Avaus'
clear all
use drgtpt
set order to code
select 0
wait window nowait 'Checking validity of each DRGTPT-record'
use ncsp_en
set order to code
set filter to not deleted() and not headline
select drgtpt
goto top
do while not eof()
  if deleted()
    skip
    loop
  endif
  if chdate=ctod(space(9))
     replace chdate with date()
  endif
  select ncsp_en
  seek drgtpt.code+drgtpt.language
  if not found()
    select drgtpt
    replace valid with .f.
  else
    select drgtpt
    replace valid with .t., SUR with ncsp_en.Sur, onk with ncsp_en.onk, oth with ncsp_en.oth, code_nc with ncsp_en.code_nc;
    code_f with ncsp_en.code_f, code_s with ncsp_en.code_s, code_d with ncsp_en.code_d, code_n with ncsp_en.code_n, language with ncsp_en.language
  endif
  select drgtpt
  skip
enddo
wait window nowait 'Checking presence of all NCSP-records in DRGTPT-file'
select ncsp_en
goto top
do while not eof()
  select drgtpt
  seek ncsp_en.code+ncsp_en.language
  if not found()
    insert into drgtpt (chdate, code, valid, language, sur, onk, oth, code_nc, code_f, code_d, code_s, code_n);
    values (date(), ncsp_en.code, .t., ncsp_en.language, ncsp_en.sur, ncsp_en.onk, ncsp_en.oth, ncsp_en.code_nc, ncsp_en.code_f, ncsp_en.code_d, ncsp_en.code_s, ncsp_en.code_n)
  endif
  select ncsp_en
  skip
enddo  
select 0

wait window nowait 'Adding missing properties to new DRGTPT-records'
use drg_apu
select drgtpt
set order to code
set filter to valid
goto top
do while not eof()
  select drgtpt
  if compl<>' ' and or<>' ' 
     skip
     if eof()
       exit
     endif
     loop
  else
    if procprop<>' '
      select ncsp_en
      seek lc_code
      browse last nowait save
      select drgtpt
      wait window 'Error, check the line' nowait
      browse last 
      loop
    endif
  endif
  if code_nc=' '
    replace compl with '0', or with '1'
    loop
  endif
  lc_chdate=chdate
  lc_code=code
  lc_language = language
  lc_sur=sur
  lc_onk=onk
  lc_oth=oth
  lc_code_nc=code_nc
  lc_code_f=code_f
  lc_code_d=code_d
  lc_code_s=code_s
  lc_code_n=code_n
  set order to code_nc
  seek lc_code_nc
  if language =' '
     wait window nowait 'Language not available!'
     select ncsp_en
     seek drgtpt.code
     browse
     replace drgtpt.language with ncsp_en.language
     loop
  endif
  if not found() or language<>'C'
     wait window 'Error, CODE_NC -code was not found!' nowait
     select ncsp_en
     seek drgtpt.code
     browse
     select drgtpt
     replace drgtpt.code_nc with ncsp_en.code_nc
     browse
     loop
  endif
  lc_tpomin=procprop
  lc_kompl=compl
  lc_or=or
  lc_dgomin=dgprop
  select drgtpt
  if lc_or=' '
    lc_or='0'
  endif
  if lc_kompl=' '
    lc_kompl='0'
  endif
  set order to code
  seek lc_code+lc_language
  replace procprop with lc_tpomin, compl with lc_kompl, or with lc_or, dgprop with lc_dgomin
  select drg_apu
  delete all
  select drg_apu
  pack
  apu_n=0
  select drgtpt
  set order to code_nc
  seek lc_code_nc
  skip
  do while lc_code_nc=code_nc and language='C'
      insert into drg_apu (chdate, code, valid, language, sur, onk, oth, code_nc, code_f, code_d, code_s, code_n, procprop, compl, or, dgprop);
      values (lc_chdate, lc_code, .t., lc_language, lc_sur, lc_onk, lc_oth, lc_code_nc, lc_code_f, lc_code_d, lc_code_s, lc_code_n, drgtpt.procprop, drgtpt.compl, drgtpt.or, drgtpt.dgprop)
      select drgtpt
      skip
      select drg_apu
      count to apu_n
      select drgtpt
  enddo
  if apu_n>0
    append from drg_apu
  endif
  set order to code
  seek lc_code+lc_language
enddo
select drg_apu
use
select ncsp_en
browse nowait save
select drgtpt
browse nowait save
on key label alt+f1 do _ncsp
wait window 'Restart the program by [Alt][F1]'
return