PROCEDURE apu_90X10
SELECT drgtpt
SET FILTER TO
GOTO top
DO WHILE NOT EOF()
  IF p_kieli='Fin'
    IF varval='90X10'
       lc_code=code
       DO WHILE code=lc_code
          SKIP -1
          IF vartype='CC' AND varval='1'
             replace varval WITH '0'
             DELETE
             EXIT
          ENDIF
        ENDDO 
        DO WHILE NOT EOF()
           SKIP
           IF lc_code<>code
              EXIT
            ENDIF
         ENDDO
      ENDIF 
  ELSE 
    IF varval='90X10'
      replace valid WITH .f.
      delete
     ENDIF 
   ENDIF 
   SKIP
ENDDO 
PACK 
return