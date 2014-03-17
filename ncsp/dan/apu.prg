Procedure apu
select drgtpt
goto top
lc_code=' '
lc_type=' '
lc_val=' '
do while not eof()
  if code=lc_code and vartype=lc_type and varval=lc_val
    skip
    loop
  endif
  if not tehty
    select b
    seek drgtpt.code_nc+drgtpt.vartype+drgtpt.varval
    if found()
      replace drgtpt.valid with .t.
    endif
  endif
  select drgtpt
  lc_code=code
  lc_type=vartype
  lc_val=varval
  skip
enddo
return