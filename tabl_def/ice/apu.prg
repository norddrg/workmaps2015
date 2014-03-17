Proc apu
select new
goto top
do while not eof()
  select drgnames
  seek trim(new.c1)
  if found()
    replace drgname with new.c3
  endif
  select new
  skip
enddo
return