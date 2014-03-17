PROCEDURE apu
SELECT apu
GOTO top
DO WHILE NOT EOF()
  SELECT dg
  SEEK UPPER(apu.code+apu.d_code)+apu.vartype+apu.varval
  IF NOT FOUND()
    APPEND BLANK
    replace chdate WITH apu.chdate, code WITH apu.code, d_code WITH apu.d_code, who WITH apu.who, valid WITH apu.valid, code_w WITH apu.code_w, d_code_w WITH apu.d_code_w, vartype WITH apu.vartype, varval WITH apu.varval
  ENDIF
  SELECT apu
  skip 
ENDDO
return