procedure natocom
select apu
goto top
lc_ncsp=' '
do while not eof()
  if tp1<>' '
    do haku with tp1
    select apu
    replace tp1 with lc_ncsp
  endif
  if tp2<>' '
    do haku with tp2
    select apu
    replace tp2 with lc_ncsp
  endif
  if tp3<>' '
    do haku with tp3
    select apu
    replace tp3 with lc_ncsp
  endif
  if tp4<>' '
    do haku with tp4
    select apu
    replace tp4 with lc_ncsp
  endif
  if tp5<>' '
    do haku with tp5
    select apu
    replace tp5 with lc_ncsp
  endif
    if tp6<>' '
    do haku with tp6
    select apu
    replace tp6 with lc_ncsp
  endif
  if tp7<>' '
    do haku with tp7
    select apu
    replace tp7 with lc_ncsp
  endif
  if tp8<>' '
    do haku with tp8
    select apu
    replace tp8 with lc_ncsp
  endif
  if tp9<>' '
    do haku with tp9
    select apu
    replace tp9 with lc_ncsp
  endif
  select apu
  skip
enddo
return

procedure haku
parameter lc_code
select ncsp_koo
set order to code
seek lc_code
if found()
  lc_ncsp=lc_code
  return
endif
set order to code_eng
seek lc_code
if code_eng=lc_code and lc_code=code_eng
  lc_ncsp=code
else
  set order to code_fin
  seek lc_code
  if code_fin=lc_code and lc_code=code_fin
  lc_ncsp=code
  else
    set order to code_swe
    seek lc_code
    if code_swe=lc_code and lc_code=code_swe
      lc_ncsp=code
    else
      set order to code_den
      seek lc_code
      if lc_code=code_den and code_den=lc_code
        lc_ncsp=code
      else
        set order to code_nor
        seek lc_code
        if lc_code=code_nor and code_nor=lc_code
          lc_ncsp=code
        else
          lc_ncsp=lc_code
        endif
      endif
    endif
  endif
endif
return