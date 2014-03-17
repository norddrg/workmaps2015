procedure apu_drgname
select drgnames
set order to loc_drg
select new
goto top
do while not eof()
  select drgnames
  seek trim(new.loc_drg)
  if not FOUND()
    wait window 'error'
    exit
  endif
  if trim (new.drgname) <> trim(drgnames.drgname) or trim(drgnames.drgname) <> trim (new.drgname) 
    replace drgnames.drgname with new.drgname
    replace chdate with date()
  endif
  replace nam_sho with new.nam_sho
  select new
  skip
enddo
select new
browse
return