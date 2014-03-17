PROCEDURE apu_ext
SELECT tpomin
SEEK '99S90'
replace or_1 WITH .t.
SELECT drgtpt
GOTO top
DO WHILE NOT EOF()
  IF vartype='OR' AND varval<>'1'
     lc_norcode=Code
  ENDIF 
  IF vartype='PROCPR' AND code=lc_norcode
    SELECT tpomin
    SEEK TRIM(drgtpt.varval)
    IF extens='1'
      SEEK '99S90'
      replace or_1 WITH .f.
      WAIT WINDOW drgtpt.code
    ENDIF
  ENDIF 
  SELECT drgtpt
  skip
ENDDO
RETURN 