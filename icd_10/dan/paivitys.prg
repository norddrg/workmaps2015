Procedure paivitys
clear all
set date to YMD
use icd_10
set order to code
replace all valid with .f.
select 0
use icd_10_new alias uusi
set filter to len(trim(code))>3
goto top
do while not eof()
*  wait window nowait uusi.code
  select icd_10
  seek uusi.code
  if found() and uusi.code = code
    replace valid with .t., headline with .f., text with uusi.text
  else
    if len(trim(uusi.code))>4
      append blank
      replace code with uusi.code, change with ctod('2010/01/01'), text with uusi.text, prim with .t., headline with .f., valid with .t., who with .f.
    endif
  endif
  select uusi
  skip
enddo
return