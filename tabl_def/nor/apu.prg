procedure apu
select drgnames
set order to drg
replace all valid with .f.
select apu
goto top
do while not eof()
  select drgnames
  seek TRIM(apu.c1)
  if found()
    replace drgnames.drgname with apu.c3
    replace drgnames.nam_sho with apu.c4
    replace valid with  .t.
    select apu
    delete
  else
*    wait window 'error - '+drgnames_nor.drgname +' not found'
  endif
  select apu
  skip
enddo