procedure apu
select icd_10
goto top
do while not eof()
  select a
  seek icd_10.code
  if found()
    replace icd_10.who with .t.
    replace icd_10.code_w with icd_10.code
  else 
    replace icd_10.who with .f.
    seek substr(icd_10.code,1,5)
    if found()
      replace icd_10.code_w with a.code
      else
      seek substr(icd_10.code,1,3)
      if found() and substr(icd_10.code,4,1)='.'
        replace icd_10.code_w with a.code
      endif
    endif
  endif
  select icd_10
  skip
enddo
return