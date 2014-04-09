Procedure apu
select a
goto top
do while not eof()
  SELECT drgnames
  SEEK a.drg
  IF NOT FOUND()
    APPEND BLANK
    replace drg WITH a.drg, mdc WITH a.mdc, drgname WITH a.drgname, valid WITH a.valid, chdate WITH a.chdate, loc_drg WITH a.loc_drg, nam_sho WITH a.nam_sho
  endif
  SELECT a
  skip
enddo
return