procedure apu
select swe9822
goto top
do while not eof()
  select drgnames
  seek swe9822.drg
  if found()
    replace swe9822.mdc_drg with drgnames.mdc
  endif
  select swe9822
  skip
enddo
return