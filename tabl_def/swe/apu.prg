procedure apu
SELECT uusi
replace ALL apu WITH 'F'
SELECT drgnames
GOTO top
DO WHILE NOT EOF()
  SELECT uusi
  SEEK drgnames.drg
  IF NOT FOUND()
    SEEK drgnames.loc_drg
  ENDIF 
  IF FOUND()
    replace apu WITH 'T'
    SELECT drgnames
    replace loc_drg WITH uusi.loc_drg, drgname WITH uusi.drgname, nam_sho WITH uusi.namn_sho, apu WITH 'T'
  ELSE
    SELECT drgnames
    replace apu WITH 'F'
  endif
  SELECT drgnames
  skip
enddo
return