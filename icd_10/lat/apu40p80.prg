PROCEDURE apu40P80
SELECT icd_10
GOTO top
DO WHILE NOT EOF()
  SELECT a
  SEEK icd_10.code_w
  IF FOUND()
    SELECT drgdg
    SEEK icd_10.code+SPACE(6)+'PDGPROP '+'40P80'
    IF NOT FOUND()
      APPEND BLANK
      replace chdate WITH DATE(), code WITH icd_10.code, vartype WITH 'PDGPRO', varval WITH '40P80', valid WITH .t.
    ENDIF 
  ENDIF 
  SELECT icd_10
  SKIP 
ENDDO 
RETURN 