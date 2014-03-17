Procedure paivitys
clear all
set date to YMD
use icd_10
set order to code
replace all valid with .f.
select 0
use icd_10_2010.dbf alias uusi
goto top
skip
do while not eof()
*  wait window nowait uusi.code
  select icd_10
  seek TRIM(uusi.c1)
  if found()
    if (trim(uusi.c2)<>trim(text) OR TRIM(text)<>TRIM(uusi.c2))
      clear
      ? 'Uusi:  '+ uusi.c2
      ? 'Vanha: '+ text
     wait window 'Saako vanhan korvata uudella? K/E'
kkkkkk     if upper(chr(lastkey()))='K'
        replace text with uusi.c2
     endif
    endif
    replace valid with .t.
  else
    append blank
    replace code with uusi.c1, change with ctod('2010/01/01'), text with uusi.c2, prim with .t., headline with .f., valid with .t., who with .f.
  endif
  select uusi
  skip
enddo
return