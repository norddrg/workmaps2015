procedure aputark
DEFINE WINDOW ncspen FROM 0,luv_x TO ala_y, max_x  FONT  max_foty, max_fosi 
on key label alt+G do aputark
on key label alt+V do apuvaiht

select ncsp_koo
set order to koodi
set filter to

on error do ncsp_ava
select ncsp_en
on error
select ncsp_en
set order to code

do while not eof()
  select ncsp_en
  if headline or not ncsp
    skip
    loop
  endif
  select ncsp_koo
  seek ncsp_en.code
  if found()
    recal next 1
  else
     append blank
     replace muutos with date(), Koodi with ncsp_en.code, nimike with ncsp_en.english
     do analnayt
     select ncsp_en
     BROWSE WINDOW ncspen FIELDS code:R, english:R:50 NOWAIT SAVE
     return   
  endif
  select ncsp_en
  skip
enddo
return

procedure ncsp_ava
select 0
use ncsp_en
set order to code
goto top
select ncsp_koo
delete all
return