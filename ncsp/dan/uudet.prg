procedure uudet
clear all
use  csp
set order to code
goto top
replace all released with .t.
select 0
use opr alias csp_apu
goto top
do while not eof()
  select csp
  seek trim(csp_apu.code)
  if found()
    replace csp.text with csp_apu.text, released with .f.
  else
    append blank
    replace code with csp_apu.code, chadate with date(), text with csp_apu.text, released with .f.
  endif
  select csp_apu
  skip
enddo