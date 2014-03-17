proc imp_transp
select icd_10
delete all
select 0
lc_transp='..\..\transp\'+p_kieli
use (lc_transp+'\icd.dbf')
goto top
do while not eof()
  select icd_10
  seek icd.code+icd.d_code
  if found()
    replace code with icd.code, d_code with icd.d_code, code_w with icd.code_w, d_code_w with icd.d_code_w, ast with icd.ast, text with icd.text, valid with .t.
    recall
  else
    append blank
    replace code with icd.code, d_code with icd.d_code, code_w with icd.code_w, d_code_w with icd.d_code_w, ast with icd.ast, text with icd.text, valid with .t.
    replace change with date()
  endif
  select icd
  skip
enddo
pack
return

select 0
use ('..\..\tabl_def\'+p_kieli+'\csp.dbf')
set order to code
delete all
select 0
use (lc_transp+'\csp.dbf') alias csp_s
goto top
do while not eof()
  select csp
  seek csp_s.code
  if found()
    replace code with csp_s.code, text with csp_s.text, ncsp with csp_s.ncsp
    recall
  else
    append blank
    replace code with csp_s.code, text with csp_s.text, ncsp with csp_s.ncsp
    replace usedate with date()
  endif
  select csp_s
  skip
enddo