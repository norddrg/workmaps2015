Procedure apu2
select est_ncsp
goto top
do while not eof()
  do propmove with code
  do propmove with code02
  do propmove with code03
  do propmove with code04
  do propmove with code05
  do propmove with code06
  do propmove with code07
  do propmove with code08
  do propmove with code09
  do propmove with code10
  do propmove with code11
  do propmove with code12
  do propmove with code13
  do propmove with code14
  do propmove with code15
  do propmove with code16
  do propmove with code17
  do propmove with code18
  do propmove with code19
  do propmove with code20
  do propmove with code21
  do propmove with code22
  do propmove with code23
  do propmove with code24
  do propmove with code25
  do propmove with code26
  do propmove with code27
  do propmove with code28
  do propmove with code29
  do propmove with code30
  do propmove with code31
  do propmove with code32
  do propmove with code33
  do propmove with code34
  do propmove with code35
  do propmove with code36
  do propmove with code37
  do propmove with code38
  do propmove with code39
  do propmove with code40
  do propmove with code41
  do propmove with code42
  do propmove with code43
  do propmove with code44
  do propmove with code45
  do propmove with code46
  do propmove with code47
  do propmove with code48
  do propmove with code49
  do propmove with code50
  do propmove with code51
  do propmove with code52
  do propmove with code53
  do propmove with code54
  do propmove with code55
  do propmove with code56
  do propmove with code57
  do propmove with code58
  do propmove with code59
  select est_ncsp
  skip
enddo

procedure propmove
parameter est_code
est_code=trim(est_code)
select drgtpt_eng
seek trim(est_code)
if est_code=' ' or not found()
  select est_ncsp
  return
endif
do while code=est_code
  select drgtpt
  seek (est_ncsp.code+drgtpt.vartype+drgtpt.varval)
  if not found()
    insert into drgtpt (code, valid, code_nc, vartype, varval, chadate);
    values (est_ncsp.code, .t., drgtpt_eng.code, drgtpt.vartype+drgtpt.varval, date())
  endif
  select drgtpt_eng
  skip
enddo
select exst_ncsp
return