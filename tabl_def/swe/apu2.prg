procedure apu2
select komplex
set order to code
goto top
do while not eof()
  if not who
    lc_code=code
    lc_dcode=d_code
    lc_compl=compl
    seek (substr(lc_code,1,5)+' '+substr(lc_dcode,1,5)+' '+SUBSTR(lc_compl,1,2)+SUBSTR(lc_compl,4,2))
    if not found()
      seek (lc_code+lc_dcode+SUBSTR(lc_compl,1,2)+SUBSTR(lc_compl,4,2))
      replace code_w with ' ', d_code_w with ' '
    endif
    seek (lc_code+lc_dcode+SUBSTR(lc_compl,1,2)+SUBSTR(lc_compl,4,2))
  endif
  select komplex
  skip
  do while code=lc_code and d_code=lc_dcode and compl=lc_compl
    delete
    replace valid with .f.
    skip
  enddo
enddo
return