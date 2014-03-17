proc apu3
select anal

set order to id
goto top
lc_oldid=' '
do while not eof()
  if lc_oldid=id
    exit
  endif
  oldid=id
  skip  
enddo
return