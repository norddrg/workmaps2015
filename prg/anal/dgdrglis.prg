Procedure dgdrglis
select dg
goto top
do while not eof()
  if vartype<>'DGKAT'
    skip
    loop
  endif
  lc_dgtext=' '
  select ICD_10
  seek dg.code+d_code
  if found()
    lc_dgtext=trim(text)
  else
    seek dg.code
    if found()
      lc_dgtext=trim(text)
      seek dg.d_code
      if found()
        lc_dgtext=lc_dgtext+'; '+trim(text)
      endif
    endif
  endif
  insert into 
  select drglogic
  goto top
  do while not eof()
    if trim(dg.varval)=trim(dgcat1)
      
    endif
    select drglogic
    skip
  enddo
  select dg
  skip
enddo