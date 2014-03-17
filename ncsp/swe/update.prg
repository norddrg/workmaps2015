procedure update
select csp
replace all released with .t.
select apu
goto top
do while not eof()
  select csp
  seek trim(apu.code)
  if found()
    replace text with apu.text
    replace released with .f.
  else
    append blank
    replace usedate with ctod('01/01/2000')
    replace code with apu.code
    replace text with apu.text
    replace chadate with usedate
    replace released with .f.
  endif
  select apu
  skip
enddo