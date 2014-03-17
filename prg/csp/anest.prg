PROCEDURE anest 
SELECT drgtpt
SET ORDER TO code
SET FILTER TO valid
GOTO top
DO WHILE NOT EOF()
   IF varval='00X10'
     lc_code=code
     lc_vartype=vartype
     lc_varval=varval
     DO WHILE vartype<>'OR'
       skip
     ENDDO 
     IF code=lc_code
       replace varval WITH '0'
     ELSE 
       WAIT WINDOW 'Error, check and start again'
     ENDIF 
   ENDIF 
   SKIP 
ENDDO
return