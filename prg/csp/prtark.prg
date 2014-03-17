procedure prtark
parameter lc_type
lc_loop=.t.
do while lc_loop
  if p_tarkier=1
    do ..\csp\tuplat
    if p_tarkier=3
      p_tarkier=0
      return
    endif
    goto top
  endif
  do ..\csp\puuttark
  if p_tarkier=0
    exit
  endif
  if p_tarkier>2
    exit
  endif
enddo
if p_tarkier>2
  wait window 'End' nowait
endif
if lc_type <>'S'
  p_tarkier=0
  do csppaiv
endif
return