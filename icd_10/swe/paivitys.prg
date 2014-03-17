Procedure paivitys
clear all
use icd_10
set order to code
select 0
use str_apu alias apu
delete all
pack
APPEND FROM ksh2001.ans TYPE SDF
Append from ekod2001.ans type sdf
replace all code with substr(code,1,3)+'.'+substr(code,4,2) for len(trim(code))>3
select icd_10
replace all valid with .f.
select apu
goto top
do while not eof()
  if code>'Z' or apu<>' ' or substr(code,2,1)>'9'
    lc_text=trim(code+apu+text)
    delete
    skip -1
    replace text with text+lc_text
    skip
  endif
  select apu
  skip
enddo
pack
goto top
do while not eof()
  select icd_10
  seek trim(apu.code)
  if found()
    replace valid with .t.
    replace text with apu.text
  else
    append blank
    replace valid with .t.
    replace code with apu.code
    replace text with apu.text
    replace change with date()
  endif
  select apu
  skip
enddo

select icd_10
goto top
do while not eof()
  if substr(code,4,1)>='A' and substr(code,4,1)<='Z'
    replace valid with .t.
  endif
  select icd_10
  skip
enddo