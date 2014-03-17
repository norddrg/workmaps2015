procedure apu

set filter to
lc_code=' '
lc_type=' '
lc_val=' '
do while not eof()
  if lc_code=drgtpt.code AND lc_type=drgtpt.vartype and lc_val=drgtpt.varval and valid
    exit
  endif
  if valid
    lc_code=drgtpt.code
    lc_type=drgtpt.vartype
    lc_val=drgtpt.varval
  endif
  skip
enddo
return