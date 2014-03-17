PROCEDURE ventncsp
SET TALK OFF
SET CONSOLE OFF
select ncsp_luv
set filter to
select ncsp_ryh
set filter to
select ncsp_ala
set filter to
SELECT ncsp_koo
SET MEMOWIDTH TO 256
set filter to
GOTO TOP
oldkoodi=space(5)
select 0
use englanti\ncsp_en
SET ORDER TO Koodi
DO WHILE NOT EOF()
   IF SUBSTR(koodi,1,1)>oldkoodi
      SELECT ncsp_luv
      seek substr(ncsp_koo.koodi,1,1)
      SET PRINTER OFF
      wait window nowait koodi+' '+trim(nimike)
      lc_print='\data\ncsp\'+TRIM(ncsp_luv.koodi)+'.ans'
      SET PRINTER TO (lc_print)
      SET PRINTER ON
      ?? '@PARAFILTR ON ='
      ?
      ? '@LUVUT = LUKU '
      ?? trim (koodi)
      ?
      ? '@SUOMI_L = '
      ?? TRIM(nimike)
      ? 
      select ncsp_en
      loy_e=.f.
      seek (ncsp_luv.koodi)
      if found()
         loy_e=.t.
         ? '@ENGL_L = '
         ?? TRIM(englanti)
         ?
      endif
      select ncsp_luv
      if len(trim(note))>0
        ? '@OHJE_LS = '
        ?? trim(note)
        ?
      endif
   ENDIF
   select ncsp_koo
   IF SUBSTR(koodi,1,2)>oldkoodi
      select ncsp_ryh 
      seek substr(ncsp_koo.koodi,1,2)
      if found()
        ? '@KOODI_R = '
        ?? trim(koodi)
        ?
        ? '@SUOMI_R = '
        ?? TRIM(nimike)
        ?
        select ncsp_en
        loy_e=.f.
        seek (ncsp_ryh.koodi)
        if found()
          loy_e=.t.
          ? '@ENGL_R = '
          ?? trim(englanti)
          ?
        endif
        select ncsp_ryh
        if len(trim(note))>0
           ? '@OHJE_RS = '
           ?? trim(note)
           ?
        endif
        select ncsp_en
      endif
   ENDIF
   SELECT ncsp_koo
   IF SUBSTR(koodi,1,3)>oldkoodi
      SELECT ncsp_ala
      seek substr(ncsp_koo.koodi,1,3)
      if found()
        ? '@KOODI_A = '
        ?? trim(koodi)
        ?
        ? '@SUOMI_A = '
        ?? TRIM(nimike)
        ?
        select ncsp_en
        loy_e=.f.
        seek (ncsp_ala.koodi)
        if found()
          loy_e=.t.
          ? '@ENGL_A = '
          ?? trim(englanti)
          ?
        endif
        select ncsp_ryh
        if len(trim(note))>0
           ? '@OHJE_AS = '
           ?? trim(note)
           ?
        endif
      endif
   ENDIF
   SELECT ncsp_koo
   ? '@KOODI = '
   ?? koodi
   ?? huom
   ?
   ? '@VANHA = '
   ?? vanha
   ?
   ? '@SUOMI = '
   ?? trim(nimike)
   ?
   if len(trim(note))>0
      ? '@OHJE_S = '
      ?? trim(note)
      ?
   endif
   oldkoodi=koodi
   SELECT ncsp_koo
   skip
ENDDO
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
SET TALK ON
SET MEMOWIDTH TO 50
select ncsp_en
use
select ncsp_koo
DO ncsp
RETURN


