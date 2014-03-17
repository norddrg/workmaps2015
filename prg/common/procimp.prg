PROCEDURE Procimp
*SELECT 0
*USE g:\data\ndms\transp\com\proc1.dbf SHARED

SELECT drgtpt
SET FILTER TO
replace ALL valid WITH .f.

SELECT proc1
GOTO top
skip
DO WHILE NOT EOF()
  SELECT drgtpt
  SEEK proc1.code+proc1.vartype+proc1.varval
  IF FOUND()
    replace valid WITH .t.
  ELSE 
    IF proc1.varval<>'99S90'
      APPEND BLANK
      replace chdate WITH DATE(), code WITH proc1.code, valid WITH .t., vartype WITH proc1.vartype, varval WITH proc1.varval
    ENDIF 
  ENDIF 
  SELECT proc1
  skip
ENDDO
return