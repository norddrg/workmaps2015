Procedure drgsis

do inuse
DEFINE WINDOW drgsis FROM 0,max_x/4 to max_y,max_x TITLE 'Content of DRG group' FONT max_foty,  max_fosi double
activate window drgsis
clear

* MDC näytölle
?? 'MDC (Major diagnosis catecory): ' STYLE 'B' at 2
if drgnames.mdc<>' '
  select dgkat
  set order to dgcat
  seek trim(drgnames.mdc)
  ? drgnames.mdc at 2
  ?? ' '
  do case
  case p_kieli='Fin'
    ?? dgkat.finish at 10
  otherwise
    ?? dgkat.english at 10
  endcase
else
  ? '---' at 2
endif

* DRGn nimi näytölle
select drgnames
? 'DRG:' STYLE 'B'at 2
? drglogic.drg at 2
?? drgnames.drgname at 10
?

? 'Definition of the group:' at 2
? 'Necessary MDC (can be different from above):' at 2
? drglogic.mdc at 2
if drglogic.mdc=' '
   ?? '---' at 10
else
  select dgkat
  seek trim(drglogic.mdc)
  do case
  case p_kieli='F'
    ?? dgkat.finish at 10
  otherwise
    ?? dgkat.english at 10
  endcase
endif

* PDGOMIN näytölle
if drglogic.pdgprop<>' '
  select pdgomin
  seek drglogic.pdgprop
  ? 'Principal diagnosis property:' at 2
  ? drglogic.pdgprop at 2
  do case
  case p_kieli='F'
     ?? pdgomin.finish at 10
  otherwise
     ?? pdgomin.english at 10
  endcase
endif

*OR näytölle
? 'Operation room procedure:' at 2
? drglogic.or at 2
do case
case drglogic.or='S' 
  ?? 'Operation room procedure necessary' at 10
case drglogic.or='N'
  ?? 'No operation room procedure allowed' at 10
case drglogic.or='P'
  ?? 'At least policlinical operation necessary' at 10
case drglogic.or='Z'
  ?? 'No signficant procedure allowed' at 10
otherwise
  ?? '---'  at 10
endcase

* TP:t näytölle
? 'Procedure properities:' at 2
if drglogic.procpro1<>' '
   select tpomin
   set order to procprop
   seek drglogic.procpro1
   ? tpomin.procprop at 2
   do case
   case p_kieli='F'
     ?? tpomin.finish at 10
   otherwise
     ?? tpomin.english at 10
   endcase
   else 
   ? '---' at 10
endif

* DGKAT näytölle

? 'Diagnosis category:' at 2
select dgkat
if drglogic.dgcat1<>' '
  seek SUBSTR(drglogic.dgcat1,1,2)+SUBSTR(drglogic.dgcat1,4,2)
  ? dgkat.dgcat at 2
   do case
   case p_kieli='F'
     ?? dgkat.finish at 10
   otherwise
     ?? dgkat.english at 10
   endcase
else
  ? '---' at 10
endif

* ikaraja näytölle
if drglogic.agelim<>' '
  ? 'Age of the patient' at 2
  ? drglogic.agelim at 2
  if drglogic.agelim='<'
     if abs(val(substr(drglogic.agelim,2,5)))>365
       ?? 'Less than '+str(int(100*val(trim(substr(drglogic.agelim,2,5)))/365.24)/100,6,2)+ ' yrs ' at 10
     else
       ?? 'Less than '+trim(substr(drglogic.agelim,2,5))+ ' days' at 10
     endif
  else
     if abs(val(substr(drglogic.agelim,2,5)))>365
       ?? 'More than ' + str(int(100*val(trim(substr(drglogic.agelim,2,5)))/365.24)/100,6,2)+ ' yrs' at 10
     else
       ?? 'More than ' + trim(substr(drglogic.agelim,2,5))+ ' days' at 10
     endif
  endif
endif

*hoidon kesto

if drglogic.dur<>' '
  ? 'Duration of therapy' at 2
  ? drglogic.dur at 2
  if drglogic.dur='<'
     ?? 'Less than ' + trim(substr(drglogic.dur,2,5))+ ' days ' at 10
  else
     ?? 'More than ' + trim(substr(drglogic.dur,2,5))+ ' days ' at 10
  endif
endif

* CC näytölle
? 'CC (Complication or Comorbidity):' at 2
? drglogic.compl at 2
do case
case drglogic.compl='1'
  ?? 'CC present' at 10
case drglogic.compl='0'
  ?? 'No CC allowed' at 10
CASE drglogic.compl='2'
  ?? 'Major CC present' at 10
otherwise
  ?? '---' at 10
endcase

* sukupuoli näytölle
? 'Gender of the patient:' at 2
? drglogic.sex at 2
do case
case drglogic.sex ='F'
  ?? 'Female' at 10
case drglogic.sex = 'M'
  ?? 'Male' at 10
otherwise
  ?? '---' at 10
endcase

* DGOMIN näytölle

? 'Diagnosis properties (all have to be present!):' at 2
if drglogic.dgprop1<>' '
  select dgomin
  set order to dgprop
  if drglogic.dgprop1='-'
    seek SUBSTR(drglogic.dgprop1,2,2)+SUBSTR(drglogic.dgprop1,5,2)+SUBSTR(drglogic.dgprop1,4,1)
  else
    seek SUBSTR(drglogic.dgprop1,1,2)+SUBSTR(drglogic.dgprop1,4,2)+SUBSTR(drglogic.dgprop1,3,1)
  endif
  if drglogic.dgprop1='-'
    ? 'NOT' at 2
  endif
  ? dgomin.dgprop at 2
  do case
  case p_kieli='F'
    ?? dgomin.finish at 10
  otherwise
    ?? dgomin.english at 10
  endcase
else
  ? '---' at 10
endif

if drglogic.dgprop2<>' '
  if drglogic.dgprop2='-'
    seek SUBSTR(drglogic.dgprop2,2,2)+SUBSTR(drglogic.dgprop2,5,2)+SUBSTR(drglogic.dgprop2,4,1)
  else
    seek SUBSTR(drglogic.dgprop2,1,2)+SUBSTR(drglogic.dgprop2,4,2)+SUBSTR(drglogic.dgprop2,3,1)
  endif
  if drglogic.dgprop2='-'
    ? 'and NOT' at 2
  else
    ? 'and' at 2
  endif
  ? dgomin.dgprop at 2
  do case
  case p_kieli='F'
    ?? dgomin.finish at 10
  otherwise
    ?? dgomin.english at 10
  endcase
endif

if drglogic.dgprop3<>' '
  if drglogic.dgprop3='-'
    seek SUBSTR(drglogic.dgprop3,2,2)+SUBSTR(drglogic.dgprop3,5,2)+SUBSTR(drglogic.dgprop3,4,1)
  else
    seek SUBSTR(drglogic.dgprop3,1,2)+SUBSTR(drglogic.dgprop3,4,2)+SUBSTR(drglogic.dgprop3,3,1)
  endif
  if drglogic.dgprop3='-'
    ? 'and NOT' at 2
  else
    ? 'and' at 2
  endif
  ? dgomin.dgprop at 2
  do case
  case p_kieli='F'
    ?? dgomin.finish at 10
  otherwise
    ?? dgomin.english at 10
  endcase
endif

if drglogic.dgprop4<>' '
  if drglogic.dgprop4='-'
    seek SUBSTR(drglogic.dgprop4,2,2)+SUBSTR(drglogic.dgprop4,5,2)+SUBSTR(drglogic.dgprop4,4,1)
  else
    seek SUBSTR(drglogic.dgprop4,1,2)+SUBSTR(drglogic.dgprop4,4,2)+SUBSTR(drglogic.dgprop4,3,1)
  endif
  if drglogic.dgprop4='-'
    ? 'and NOT' at 2
  else
    ? 'and' at 2
  endif
  ? dgomin.dgprop at 2
  do case
  case p_kieli='F'
    ?? dgomin.finish at 10
  otherwise
    ?? dgomin.english at 10
  endcase
endif

if drglogic.secproc1<>' '
  if len(trim(drglogic.secproc1))>1
    select tpomin
    if drglogic.secproc1 = '-'
      seek substr(drglogic.secproc1,2,5)
    else
      seek trim(drglogic.secproc1)
    endif
  endif
  ?
  if drglogic.secproc1='-' and len(trim(drglogic.secproc1))>1
     ? 'If more than one OR procedure, following proc.property is NOT allowed' at 2
  endif
  ? drglogic.secproc1 at 2
  do case
  case drglogic.secproc1='- '
     ?? 'No other OR procedures allowed' at 10
  case drglogic.secproc1='+'
     ?? 'At least 2 OR procedures necessary' at 10
  case drglogic.secproc1=' '
     ?? '---' at 10
  otherwise
     do case
     case p_kieli='Fin'
       ?? tpomin.finish at 10
     otherwise
       ?? tpomin.english at 10
     endcase
     ? 'In addition to previously mentioned operation' at 10
  endcase
endif


? 'Discharge: ' at 2
do case
case drglogic.disch='E'
  ? 'Death' at 10
case drglogic.disch='R'
  ? 'Remitted' at 10
case drglogic.disch='L'
  ? 'Left against medica advice' at 10
case drglogic.disch='N'
  ? 'No death' at 10
otherwise
  ?? '---'
endcase

return
