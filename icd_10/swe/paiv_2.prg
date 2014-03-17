Procedure paiv_2
clear all
use icd_10
set order to code
select 0
use ..\com\icd_10 alias a
set order to code
Select icd_10
goto top
do while not eof()
  replace icd_10.who with .f.
  select a
  seek icd_10.code_w
  if not found()
    seek substr(icd_10.code_w,1,3)
  else
    replace icd_10.who with .t.
  endif
  if not found()
    replace icd_10.code_w with ' '
  else
    replace icd_10.code_w with a.code
  endif
  if icd_10.d_code_w <> '  '
    replace icd_10.who with .f.
    select a
    seek icd_10.d_code_w
    if not found()
      select a
      seek substr(icd_10.d_code_w,1,3)
    else
      replace icd_10.who with .t.
    endif
    if not found()
       replace icd_10.d_code_w with ' '
    else
       replace icd_10.d_code_w with a.code
    endif
  endif
  select icd_10
  skip
enddo
return