procedure logsiir
wait window 'DRG-logic' nowait
select 0
use \data\drg_n\rtc.dbf
set order to code
select drglogic
SET ORDER TO ord
SET FILTER TO valid 
COPY TO (lc_siirto+'\drglogic.dbf')TYPE FOXPLUS
SET RELATION TO drg INTO drgnames
set relation to rtc into rtc additive
if p_text='Y'
if p_kieli='F'
   COPY TO (lc_siirto+'\drglogic.xl2') TYPE XLS FIELDS drg, drgnames.finish, rtc, icd, mdc, pdgprop, OR, procpro1, dgcat1,;
   agelim, compl, sex,  dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur
else
   COPY TO (lc_siirto+'\drglogic.xl2') TYPE XLS FIELDS drg, drgnames.english, rtc, icd, mdc, pdgprop, OR, procpro1, procpro2, procpro3, dgcat1, dgcat2,;
   agelim, compl, sex,  dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur
endif
select 0
use (lc_siirto+'\old\drglogic') alias old
select 0
use log_str
copy next 0 to (lc_siirto+'\muutos\drglogic') with cdx
use (lc_siirto+'\muutos\drglogic') alias muutos
set order to drg
select drglogic
GOTO TOP
lc_1=substr(ord,1,2)
lc_print=lc_siirto+'\drglogic.txt'
SET PRINTER TO (lc_print)
SET PRINTER ON
?? '@PARAFILTR ON ='
?
? '@TAB_NAME = TABLE 1. Basic rules for assignment to each DRG'
?
lc_new = .T.
lc_drg='  0 '
lc_rtc=' '
lc_done=space(7)
DO WHILE NOT EOF()
   if not inuse
     skip
     loop
   endif
   if ord<>lc_1
     wait window drglogic.ord nowait
     lc_1=substr(ord,1,2)
   endif
   select old
   goto top
   do while not eof()
     select drglogic
     if (icd=old.icd and mdc=old.mdc and procpro1=old.procpro1 and dgcat1=old.dgcat1; 
     and agelim=old.agelim and compl=old.compl and sex=old.sex and dgprop1=old.dgprop1; 
     and dgprop2=old.dgprop2 and dgprop4=old.dgprop4 and secproc1=old.secproc1; 
     and disch=old.disch and icu=old.icu and dur=old.dur)
       exit
     endif
     select old
     skip
   enddo
   select drglogic
   if not (icd=old.icd and mdc=old.mdc and procpro1=old.procpro1 and dgcat1=old.dgcat1; 
   and agelim=old.agelim and compl=old.compl and sex=old.sex and dgprop1=old.dgprop1; 
   and dgprop2=old.dgprop2 and dgprop4=old.dgprop4 and secproc1=old.secproc1; 
   and disch=old.disch and icu=old.icu and dur=old.dur)
     insert into (lc_siirto+'\muutos\drglogic'); 
     (new, ord, drg, icd, mdc, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur, rtc, valid, chdate);
     values ('N', ord, drg, icd, mdc, procpro1, dgcat1,;
     agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1,;
     disch, icu, dur, rtc, valid, chdate)    
   else
     if old.ord<>drglogic.ord
       insert into (lc_siirto+'\muutos\drglogic'); 
       (new, ord, oldord, drg, icd, mdc, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur, rtc, valid, chdate);
       values ('O', drglogic.ord, old.ord, old.drg, old.icd, old.mdc, old.procpro1, old.dgcat1,;
       old.agelim, old.compl, old.sex, old.dgprop1, old.dgprop2, old.dgprop3, old.dgprop4, old.secproc1,;
       old.disch, old.icu, old.dur, old.rtc, old.valid, old.chdate)
     endif
   endif
   select drglogic
   skip
enddo     
select old
goto top
DO WHILE NOT EOF()
   if ord<>lc_1
     wait window drglogic.ord nowait
     lc_1=substr(ord,1,2)
   endif
   select drglogic
   goto top
   do while not eof()
     select drglogic
     if (icd=old.icd and mdc=old.mdc and procpro1=old.procpro1 and dgcat1=old.dgcat1; 
     and agelim=old.agelim and compl=old.compl and sex=old.sex and dgprop1=old.dgprop1; 
     and dgprop2=old.dgprop2 and dgprop4=old.dgprop4 and secproc1=old.secproc1; 
     and disch=old.disch and icu=old.icu and dur=old.dur)
       exit
     endif
     select old
     skip
   enddo
   select drglogic
   if not (icd=old.icd and mdc=old.mdc and procpro1=old.procpro1 and dgcat1=old.dgcat1; 
   and agelim=old.agelim and compl=old.compl and sex=old.sex and dgprop1=old.dgprop1; 
   and dgprop2=old.dgprop2 and dgprop4=old.dgprop4 and secproc1=old.secproc1; 
   and disch=old.disch and icu=old.icu and dur=old.dur)
     insert into (lc_siirto+'\muutos\drglogic'); 
     (new, ord, drg, icd, mdc, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur, rtc, valid, chdate);
     values ('N', ord, drg, icd, mdc, procpro1, dgcat1,;
     agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1,;
     disch, icu, dur, rtc, valid, chdate)    
   else
     if old.ord<>drglogic.ord
       insert into (lc_siirto+'\muutos\drglogic'); 
       (new, ord, oldord, drg, icd, mdc, procpro1, dgcat1, agelim, compl, sex, dgprop1, dgprop2, dgprop3, dgprop4, secproc1, disch, icu, dur, rtc, valid, chdate);
       values ('O', drglogic.ord, old.ord, old.drg, old.icd, old.mdc, old.procpro1, old.dgcat1,;
       old.agelim, old.compl, old.sex, old.dgprop1, old.dgprop2, old.dgprop3, old.dgprop4, old.secproc1,;
       old.disch, old.icu, old.dur, old.rtc, old.valid, old.chdate)
     endif
   endif
   select drglogic
   skip
enddo     

     endif
   else
     select old
     lc_done=old.ord
     skip
   endif
   select drglogic
   IF lc_new
      IF icd='-'
         ? '@L_MDC = No valid  ICD-10 diagnosis'
         ?
         ? '@L_DRG = '
         ?? drg
         ?
         ? '@L_NAMEDRG = '
         if p_kieli='F'
           ?? TRIM(drgnames.finish)
         else
           ?? TRIM(drgnames.english)
         endif
         ?
         ? '@L_RTC = RTC'
         ?
         ? '@L_RTC_2='
         ?? rtc
         ?
         ? '@L_RTC_3='
         ?? trim(rtc.eng)
         ?
         SKIP
         LOOP
      ENDIF
      ? '@L_MDC = mdc'
      ?
      ? '@L_PDGOM = pdgprop'
      ?
      ? '@L_OR = or'
      ?
      ? '@L_TP1 = procpro1'
      ?
      ? '@L_TP2 = procpro2'
      ?
      ? '@L_TP3 = procpro3'
      ?
      ? '@L_DGKAT1 = dgcat1'
      ?
      ? '@L_DGKAT2 = dgcat2'
      ?
      ? '@L_IKARAJA = agelim'
      ?
      ? '@L_KOMPL = compl'
      ?
      ? '@L_SEX = sex'
      ?
      ? '@L_DGOMIN1 = dgprop1'
      ?
      ? '@L_DGOMIN2 = dgprop2'
      ?
      ? '@L_DGOMIN3 = dgprop3'
      ?
      ? '@L_DGOMIN4 = dgprop4'
      ?
      ? '@L_STP1 = secproc1'
      ?
      ? '@L_EXITUS = other'
      ?
   ENDIF
   ? '@L_MDC = '
   IF mdc=' '
      ?? '~'
   ELSE
      ?? mdc
   ENDIF
   ?
   ? '@L_PDGOM = '
   IF pdgprop=' '
      ?? '~'
   ELSE
      ?? pdgprop
   ENDIF
   ?
   ? '@L_OR = '
   DO CASE
      CASE OR='+'
         ?? 'Y'
      CASE OR = '-'
         ?? 'N'
      OTHERWISE
         ?? '~'
   ENDCASE
   ?
   ? '@L_TP1 = '
   IF procpro1=' ' OR procpro1='+'
      ?? '~'
   ELSE
      ?? procpro1
   ENDIF
   ?
   ? '@L_TP2 = '
   IF procpro2=' '
      ?? '~'
   ELSE
      ?? procpro2
   ENDIF
   ?
   ? '@L_TP3 = '
   IF procpro3=' '
      ?? '~'
   ELSE
      ?? procpro3
   ENDIF
   ?
   ? '@L_DGKAT1 = '
   IF dgcat1=' '
      ?? '~'
   ELSE
      ?? dgcat1
   ENDIF
   ?
   ? '@L_DGKAT2 = '
   IF dgcat2=' '
      ?? '~'
   ELSE
      ?? dgcat2
   ENDIF
   ?
   ? '@L_IKARAJA = '
   IF agelim=' '
      ?? '~'
   ELSE
      ?? agelim
   ENDIF
   ?
   ? '@L_KOMPL = '
   DO CASE
      CASE compl = '1'
         ?? 'Y'
      CASE compl = '0'
         ?? 'N'
      CASE compl = ' '
         ?? '~'
   ENDCASE
   ?
   ? '@L_SEX = '
   IF sex=' '
      ?? '~'
   ELSE
      ?? sex
   ENDIF
   ?
   ? '@L_DGOMIN1 = '
   IF dgprop1=' '
      ?? '~'
   ELSE
      ?? dgprop1
   ENDIF
   ?
   ? '@L_DGOMIN2 = '
   IF dgprop2=' '
      ?? '~'
   ELSE
      ?? dgprop2
   ENDIF
   ?
   ? '@L_DGOMIN3 = '
   IF dgprop3=' '
      ?? '~'
   ELSE
      ?? dgprop3
   ENDIF
   ?
   ? '@L_DGOMIN4 = '
   IF dgprop4=' '
      ?? '~'
   ELSE
      ?? dgprop4
   ENDIF
   ?
   ? '@L_STP1 = '
   DO CASE
      CASE secproc1=' '
         ?? '~'
      CASE secproc1='+'
         ?? '>>1 OR'
      CASE secproc1='-'
         ?? secproc1
      OTHERWISE
         ?? secproc1
   ENDCASE
   ?
   ? '@L_exitus = '
   DO CASE
      CASE disch=' '
         ?? '~'
      CASE disch='E'
         ?? 'Death'
      CASE disch='R'
         ?? 'Rem.'
      CASE disch = 'P'
         ?? 'LAMA'
   ENDCASE
   ?
   ? '@L_ICU = '
   DO CASE
      CASE icu=' '
         ?? '~'
      CASE icu='0'
         ?? 'No ICU treatment'
      CASE ICU='N'
         ?? 'NICU'
      CASE disch = 'B'
         ?? 'ICU for burns'
   ENDCASE
   ?
   ? '@L_DUR= '
   ?? 'Duration: '
   val(dur)
   ?
   SKIP
   IF lc_drg<>drg or lc_rtc<>rtc
      SKIP -1
      ? '@L_DRG = '
      ?? drg
      ?
      ? '@L_NAMEDRG = '
      do case 
      case p_kieli = 'F'
        ?? trim(drgnames.finish)
      otherwise
        ?? trim(drgnames.english)
      endcase
      ?
      ? '@L_RTC = RTC'
      ?
      ? '@L_RTC_2='
      ?? rtc
      ?
      ? '@L_RTC_3='
      ?? trim(rtc.eng)
      ?
      SKIP
      lc_drg=drg
      lc_rtc=rtc
      lc_new = .T.
   ELSE
      lc_new = .F.
   ENDIF
ENDDO
endif
SET RELATION TO
select rtc
use
SET PRINTER OFF
SET PRINTER TO
if p_text='Y'
  select muutos
  COPY TO (lc_siirto+'\muutos\drglogic.xls') TYPE XL5
  use
  select old
  use
endif
return
