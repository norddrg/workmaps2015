PROCEDURE apu2
lc_code=SPACE(5)
GOTO top
DO WHILE NOT EOF()
  IF code=lc_code
     DELETE
  ELSE 
    lc_code=code
  ENDIF 
  skip
ENDDO
RETURN
