procedure substco
select drgtpt
select 0
use c:\data\rel_com
do while not eof()
  if subst=code
    skip
    loop
  endif
  select drgtpt
  seek rel_com.code
  do while rel_com.code=drgtpt.code and not eof()
    if apu=' '
      replace apu with code
      replace code with rel_com.subst
      seek rel_com.code
      loop
    endif
    skip
    loop
  enddo
  select rel_com
  skip
enddo