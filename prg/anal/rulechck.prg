procedure rulechck
select drglogic
select drglogic
set order to ord
set filter to inuse
goto top
do while not eof()
  select anal
  lc_found=.t.
  set order to ord
  set near on
  seek drglogic.ord
  if not found()
    lc_found=.f.
    do analohje
    do analnayt
    if not lc_found
      wait window nowait 'No case with ord-code '+drglogic.ord+' found'
      ? chr(7)+chr(7)
      ? chr(7)
    endif
    exit
  endif
  select drglogic
  skip
enddo
return