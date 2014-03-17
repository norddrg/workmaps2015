Procedure apu2
select anal
set order to
goto top
lc_oir=space(5)
do while not eof()
  do atc with oir1, lc_oir
  if lc_oir<>oir1
    replace oir1 with lc_oir
  endif
  do atc with oir2, lc_oir
  if lc_oir<>oir2
    replace oir2 with lc_oir
  endif
  do atc with oir3, lc_oir
  if lc_oir<>oir3
    replace oir3 with lc_oir
  endif
  do atc with oir4, lc_oir
  if lc_oir<>oir4
    replace oir4 with lc_oir
  endif
  do atc with oir5, lc_oir
  if lc_oir<>oir5
    replace oir5 with lc_oir
  endif
  do atc with oir6, lc_oir
  if lc_oir<>oir6
    replace oir6 with lc_oir
  endif
  do atc with oir7, lc_oir
  if lc_oir<>oir7
    replace oir7 with lc_oir
  endif
  do atc with oir8, lc_oir
  if lc_oir<>oir8
    replace oir8 with lc_oir
  endif
  do atc with oir9, lc_oir
  if lc_oir<>oir9
    replace oir9 with lc_oir
  endif
  select anal
  skip
enddo
return

procedure atc
parameter oir, apu
apu=oir
if substr (oir,5,1)>'9'
  oir=substr(oir,1,3)+substr(oir,5,1)
  select icd_10
  seek oir
  apu=code
  select anal
endif
return