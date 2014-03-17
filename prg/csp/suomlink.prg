procedure suomlink
clear all
use ncsp_en
set order to simple
select 0
use drgtpt_f
set order to koodi
select 0
use drgtpt
set order to koodi
select ncsp_en
do while not eof()
  if code_f=' '
     skip
     loop
  endif
  if headline
     skip
     loop
  endif
  if ncsp_en.code_nc<>' '
    select drgtpt
    seek ncsp_en.code_nc
  endif
  select drgtpt_f
  seek ncsp_en.code_f
  if found()
  
  select ncsp_en
  skip
enddo
return