PROCEDURE ventncsp
DO monistus
CLEAR ALL
clear
SET TALK OFF
USE ..\tulostus
SET ORDER TO TAG koodi O
SELECT 0
USE ..\luv_10.dbf EXCLUSIVE
SET ORDER TO TAG alaraja 
SELECT 0
USE ..\ryh_10.dbf EXCLUSIVE
SET ORDER TO TAG alaraja 
SET CONSOLE OFF
SELECT luv_10
GOTO TOP
luv_yla= SPACE(3)
SELECT ryh_10
GOTO TOP
ryh_yla= SPACE(3)
SELECT tulostus
SET MEMOWIDTH TO 256
GOTO TOP
prkoodi=space(12)
DO WHILE NOT EOF()
   IF SUBSTR(koodi,1,3)>luv_yla
      SELECT luv_10
      SET PRINTER OFF
      @ 1,5 say suomi
      lc_print='\data\icd_10\'+TRIM(luku)+'.ans'
      SET PRINTER TO (lc_print)
      SET PRINTER ON
      luv_yla=ylaraja
      ?? '@PARAFILTR ON ='
      ?
      ? '@LUVUT = LUKU '
      ?? luku
      ?
      ? '@SUOMI_L = '
      ?? TRIM(UPPER(suomi))
      ? 
      ? '@RUOTSI_L = '
      ?? TRIM(UPPER(ruotsi))
      IF latina<>SPACE(200) AND SUBSTR(latina,1,1)<>'-'
         ?
         ? '@LATINA_L = '
         ?? TRIM(latina)
      ENDIF
      ?
      ? '@LUOKOOD = '
      lc_koodi=alaraja
      IF ylaraja<>alaraja
         lc_koodi=lc_koodi+' - '+ylaraja
      ENDIF
      ?? lc_koodi
      IF LEN(TRIM(NOTE_s))>0
         DO noexin WITH 'n','s','l'
      ENDIF
      IF LEN(TRIM(NOTE_r))>0
         ?
         ? '@LUVVII = '
         DO noexin WITH 'n','r','l'
      ENDIF
      IF LEN (TRIM(incl_s))>0
         ?
         ? '@INCL = Sisältää:'
         DO noexin WITH 'i','s','l'
      ENDIF
      IF LEN (TRIM(incl_r))>0
         ?
         ? '@INCL = Innefattar:'
         DO noexin WITH 'i','r','l'
      ENDIF
      IF LEN(TRIM(EXCL_s))>0
         ?
         ? '@EXCL = Ei sisällä:'
         DO noexin WITH 'e','s','l'
      ENDIF
      IF LEN(TRIM(EXCL_s))>0
         ?
         ? '@EXCL = Excluderar:'
         DO noexin WITH 'e','r','l'
      ENDIF
      ?
      ? '@LUV_SIS = Tämä luku sisältää seuraavat ryhmät:'
      ?
      ? '@LUV_SIS = Detta kapitel innefattar följande grupper:'
      select ryh_10
      seek (luv_10.alaraja)
      do while alaraja<luv_10.ylaraja and not eof()
         ?
         if valitaso
           ? '@VALIRYH= '
         else
           ? '@LUV_RYH = '
         endif
         lc_koodi= alaraja
         IF ylaraja<>alaraja
            lc_koodi=lc_koodi+' - '+ylaraja
         ENDIF
         ?? lc_koodi
         ?
         ? '@SUO_LUV = '
         ?? UPPER(SUBSTR(Suomi,1,1))+trim(lower(substr(suomi,2,100)))
         ?
         ? '@RUO_LUV = '
         ?? UPPER(SUBSTR(ruotsi,1,1))+trim(lower(substr(ruotsi,2,100)))
         skip
      enddo
      seek (luv_10.alaraja)
      select luv_10
      IF NOT EOF()
         SKIP
      ENDIF
   ENDIF
   SELECT tulostus
   IF SUBSTR(koodi,1,3)>ryh_yla
      SELECT ryh_10
      lc_val=.T.
      DO WHILE lc_val
         lc_val=.F.
         IF valitaso
            lc_val=.T.
         ENDIF
         ryh_yla=ylaraja
         ?
         ? '@RYHMAT= '
         lc_koodi= alaraja
         IF ylaraja<>alaraja
            lc_koodi=lc_koodi+' - '+ylaraja
         ENDIF
         ?? lc_koodi
         ?
         ? '@SUOMI_R = '
         ?? TRIM(UPPER(suomi))
         ?
         ? '@RUOTSI_R = '
         ?? TRIM(UPPER(ruotsi))
         IF latina<>SPACE(200) AND SUBSTR(latina,1,1)<>'-'
            ?
            ? '@LATINA_R = '
            ?? TRIM(latina)
         ENDIF
         IF LEN(TRIM(NOTE_s))>0
            DO noexin WITH 'n','s','r'
            ?
            ? '@RYHVII = '
         ENDIF
         IF LEN(TRIM(NOTE_r))>0
            DO noexin WITH 'n','r','r'
         ENDIF
         IF LEN (TRIM(incl_s))>0
            ?
            ? '@INCL = Sisältää:'
            DO noexin WITH 'i','s','r'
         ENDIF
         IF LEN (TRIM(incl_r))>0
            ?
            ? '@INCL = Innefattar:'
            DO noexin WITH 'i','r','r'
         ENDIF
         IF LEN(TRIM(EXCL_s))>0
            ?
            ? '@EXCL = Ei sisällä:'
            DO noexin WITH 'e','s','r'
         ENDIF
         IF LEN(TRIM(EXCL_r))>0
            ?
            ? '@EXCL = Excluderar:'
            DO noexin WITH 'e','r','r'
         ENDIF
         IF NOT EOF()
            SKIP
         ELSE
            EXIT
         ENDIF
      ENDDO
   ENDIF
   SELECT tulostus
   IF PRIM
      prkoodi=koodi+koodi_2
      IF LEN(TRIM(koodi))=3 AND koodi_2=space(6)
         ?
         ? '@KOODI_3 = '
         ?? koodi + ast
      ELSE
        ots4=.f.
        if len(trim(koodi))=5
          lc_code=koodi
          do while koodi = lc_code and not eof()
            skip
          enddo
          if substr(koodi,1,5)=substr(prkoodi,1,5) and len(trim(koodi))=6
             ots4=.t.
          endif
          seek prkoodi
        endif
        if ots4
          ?
          ? '@KOODI4 = '
          ?? koodi+ast
        else 
          if koodi_2=space(6)      
            ?
            ? '@KOODI = '
            ?? trim(koodi)+ast
          else
            if ast='+'
              ?
              ? '@KOODI = '
              ?? trim(koodi_2) +' * '
              ?
              ? '@KOODI2 = '
              ?? koodi
            else
              ?
              ? '@KOODI = '
              ?? trim(koodi) + ast
              ?
              ? '@KOODI2 = '
              ?? koodi_2
            endif
          endif
        endif
      ENDIF
      if at(';', suomi)>0
       if koodi_2 = space(6)
         ?
         ? '@SUOMI_AL = '
         ? substr(suomi,1,at(';',suomi))
         ?
         ? '@SUOMI_LO = '
         ? ltrim(rtrim(substr(suomi,at(';',suomi)+2,100)))
       else
         ?
         ? '@SUODA_AL= '
         ? substr(suomi,1,at(';',suomi))
         ?
         ? '@SUODA_LO = '
         ? ltrim(rtrim(substr(suomi,at(';',suomi)+2,100)))
       endif
     else
       ?
       ? '@SUOMI_1 = '
       ?? TRIM(suomi)
      endif
      ?
      ? '@RUOTSI_1 = '
      ?? TRIM(ruotsi)
      IF latina<>SPACE(200) AND SUBSTR(ltrim(rtrim(latina)),1,1)<>'-'
         ?
         ? '@LATINA_1 = '
         ?? TRIM(latina)
      ENDIF
      seek prkoodi
      skip
      do while koodi+koodi_2=prkoodi and not eof()
       IF suomi<>SPACE(200)
         ?
         ? '@SUOMI_2 = '
         ?? TRIM(suomi)
       endif
       skip
      enddo
      seek prkoodi
      skip
      do while koodi+koodi_2=prkoodi and not eof()
       if ruotsi<>space(200)
         ?
         ? '@RUOTSI_2 = '
         ?? TRIM(ruotsi)
       endif
       skip
      enddo
      seek prkoodi
      skip
      do while koodi+koodi_2=prkoodi and not eof()
       if latina<>space(200) AND SUBSTR(ltrim(rtrim(latina)),1,1)<>'-'
         ?
         ? '@LATINA_2 = '
         ?? TRIM(latina)
       ENDIF
       skip
      enddo
      seek prkoodi
      IF LEN(TRIM(NOTE_s))>0
         ?
         ? '@ICDVII = '
         DO noexin WITH 'n','s','i'
      ENDIF
      IF LEN(TRIM(NOTE_r))>0
         ?
         ? '@ICDVII = '
         DO noexin WITH 'n','r','i'
      ENDIF
      IF LEN (TRIM(incl_s))>0
         ?
         ? '@INCL = Sisältää:'
         DO noexin WITH 'i','s','i'
      ENDIF
      IF LEN (TRIM(incl_r))>0
         ?
         ? '@INCL = Innefattar:'
         DO noexin WITH 'i','r','i'
      ENDIF
      IF LEN(TRIM(EXCL_s))>0
         ?
         ? '@EXCL = Ei sisällä:'
         DO noexin WITH 'e','s','i'
      ENDIF
      IF LEN(TRIM(EXCL_r))>0
         ?
         ? '@EXCL = Excluderar:'
         DO noexin WITH 'e','r','i'
      ENDIF
   ENDIF
   SELECT tulostus
   skip
   do while koodi+koodi_2=prkoodi and not eof()
     SKIP
   enddo
ENDDO
do koltul
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
SET TALK ON
SET MEMOWIDTH TO 50
do ascmuun
do dbasver
DO icdnayt
RETURN

*!*****************************************************************************
*!
*!      Procedure: NOEXIN
*!
*!      Called by: VENTTUL            (procedure in VENTTUL.PRG)
*!
*!*****************************************************************************
PROCEDURE noexin
PARAMETER nei_type, nei_kie, nei_lri
nei_loop =.T.
nei_n=0
DO WHILE nei_loop
   nei_n=nei_n+1
   do case
   case nei_lri='l'
     nei_text='@LUKUTEXT = '
   case nei_lri='r'
     nei_text= '@RYHTEXT = '
   case nei_lri='i'
     nei_text= '@ICDTEXT = '
   endcase
   DO CASE
   CASE nei_type='n'
      IF nei_n=1
         nei_a=1
      ELSE
         if nei_kie='s'
           nei_a=AT(CHR(13),NOTE_s,nei_n-1)+1
         else
           nei_a=AT(CHR(13),NOTE_r,nei_n-1)+1
         endif
      ENDIF
      if nei_kie='s'
        nei_l=AT(CHR(13),NOTE_S,nei_n)
      else
        nei_l=AT(CHR(13),NOTE_r,nei_n)
      endif
      IF nei_l=0
         nei_l=10000
      ENDIF
      if nei_kie='s'
         nei_text=nei_text+SUBSTR(NOTE_s,nei_a,nei_l-nei_a)
      else
         nei_text=nei_text+SUBSTR(NOTE_r,nei_a,nei_l-nei_a)
      endif
   CASE nei_type='e'
      IF nei_n=1
         nei_a=1
      ELSE
         if nei_kie='s'
           nei_a=AT(CHR(13),EXCL_s,nei_n-1)+1
         else
           nei_a=AT(CHR(13),EXCL_r,nei_n-1)+1
         endif
      ENDIF
      if nei_kie='s'
        nei_l=AT(CHR(13),EXCL_s,nei_n)
      else
        nei_l=AT(CHR(13),EXCL_r,nei_n)
      endif
      IF nei_l=0
         nei_l=10000
      ENDIF
      if nei_kie='s'
        nei_apu = SUBSTR(trim(EXCL_s),nei_a,nei_l-nei_a)
      else 
        nei_apu = SUBSTR(trim(EXCL_r),nei_a,nei_l-nei_a)
      endif
      nei_apu=ltrim(nei_apu)
      do while (asc(nei_apu)<33 or asc(nei_apu)=45) and len(nei_apu)>0
        nei_apu=substr(nei_apu,2,len(nei_apu))
      enddo
      if len(nei_apu)=0
        if nei_l=10000
          exit
        else
         loop
        endif
      endif
      nei_apu=upper(substr(nei_apu,1,1))+substr(nei_apu,2,len(nei_apu))
      if asc(nei_apu)=40 or asc(nei_apu)=91
        nei_apu=upper(substr(nei_apu,1,2))+substr(nei_apu,3,len(nei_apu))
      endif
      nei_text=nei_text+nei_apu
   CASE nei_type='i'
      IF nei_n=1
         nei_a=1
      ELSE
         if nei_kie='s'
           nei_a=AT(CHR(13),incl_s,nei_n-1)+1
         else
           nei_a=AT(CHR(13),incl_r,nei_n-1)+1
         endif
      ENDIF
      if nei_kie='s'
        nei_l=AT(CHR(13),incl_s,nei_n)
      else
        nei_l=AT(CHR(13),incl_r,nei_n)
      endif
      IF nei_l=0
         nei_l=10000
      ENDIF
      if nei_kie='s'
        nei_apu=SUBSTR(incl_s,nei_a,nei_l-nei_a)
      else
        nei_apu=SUBSTR(incl_r,nei_a,nei_l-nei_a)
      endif
      nei_apu=ltrim(nei_apu)
      do while asc(nei_apu)<33 and len(nei_apu)>0
        nei_apu=substr(nei_apu,2,len(nei_apu))
      enddo
      if len(nei_apu)=0
        if nei_l=10000
          exit
        else
         loop
        endif
      endif
      if asc(nei_apu)=40 or asc(nei_apu)=91
        nei_apu=upper(substr(nei_apu,1,2))+substr(nei_apu,3,len(nei_apu))
      endif
      nei_apu = upper(substr(nei_apu,1,1))+substr(nei_apu,2,len(nei_apu))
      nei_text = nei_text+nei_apu
   ENDCASE
   ?
   ? TRIM(nei_text)
   IF nei_l=10000
      EXIT
   ENDIF
ENDDO
RETURN
*: EOF: VENTTUL.PRG
