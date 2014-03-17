Procedure nass_upd
clear all
use icd_10
set order to code
SET FILTER TO code='UA' OR code='UP'
replace ALL valid WITH .f.
select 0
use "svenska nass-koder 2010.dbf"alias cha
goto top
do while not eof()
  select icd_10
  seek TRIM(cha.code)
  IF NOT FOUND()
     append blank
     replace code with cha.code, text with cha.text, code_w WITH cha.code_w, change with DATE(), valid with .t. , who with .f., prim with .t., headline with .f.
  else
     replace valid with .t.
     IF NOT (TRIM(text)=TRIM(cha.text) AND TRIM(cha.text)=TRIM(text))
       replace text WITH cha.text
       replace change WITH DATE()
    endif
  endif
  select cha
  skip
enddo
return