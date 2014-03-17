Procedure comptype
parameter om_kieli
SELECT komplex 
om_wn=0
om_ln=0
SEEK lc_icdo+lc_icde
do while code+d_code= lc_icdo+lc_icde
  if valid
    do ominval with 'l', compl
  endif
  select komplex
  skip
enddo
SEEK lc_icdo+SPACE(6)
do while code+d_code= lc_icdo+SPACE(6)
  if valid
    do ominval with 'l', compl
  endif
  select komplex
  skip
enddo
SEEK lc_icde+SPACE(6)
do while code+d_code= lc_icde+SPACE(6)
  if valid
    do ominval with 'l', compl
  endif
  select komplex
  skip
enddo
if om_kieli<>'Com'
  select komplex_oth
  SEEK lc_wicdo+lc_wicde
  do while code+d_code= lc_wicdo+lc_wicde
    if valid
      do ominval with 'w', compl
    endif
    select komplex_oth
    skip
  enddo
  SEEK lc_wicdo+SPACE(6)
  do while code+d_code = lc_wicdo+SPACE(6)
    if valid
      do ominval with 'w', compl
    endif
    select komplex_oth
    skip
  enddo
  SEEK lc_wicde+SPACE(6)
  do while code+d_code = lc_wicde+SPACE(6)
    if valid
      do ominval with 'w', compl
    endif
    select komplex_oth
    skip
  enddo
endif
return
