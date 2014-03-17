procedure apu
select dglink
set order to code
goto top
do while not eof()
  if code_w=' '
    lc_w=' '
    lc_dw=' '
    lc_code=code
    lc_dcode=d_code
    skip
    do while code=trim(lc_code) and d_code=trim(lc_dcode) and not eof() and substr(code,4,1)='.'
      lc_w=code
      lc_dw=d_code
      skip
    enddo
    seek lc_code+lc_dcode
    replace code_w with lc_w, d_code_w with lc_dw
  endif  
  skip
enddo
return