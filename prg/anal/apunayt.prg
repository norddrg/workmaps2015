Procedure apunayt
on key label alt+x do seur_ero
activate window anal
clear
select anal
set filter to not deleted()
@ 0,1 say oir1
@ 0,8 say syy1
do dgnim with oir1, syy1, lc_dg1, 0
@ 1,1 say oir2
@ 1,8 say syy2
do dgnim with oir2, syy2, lc_dg2, 1
@ 2,1 say oir3
@ 2,8 say syy3
do dgnim with oir3, syy3, lc_dg3, 2
@ 3,1 say oir4
@ 3,8 say syy4
do dgnim with oir4, syy4, lc_dg4, 3
@ 4,1 say oir5
@ 4,8 say syy5
do dgnim with oir5, syy5, lc_dg5, 4
@ 5,1 say oir6
@ 5,8 say syy6
do dgnim with oir6, syy6, lc_dg6, 5
@ 6,1 say oir7
@ 6,8 say syy7
do dgnim with oir7, syy7, lc_dg7, 6
@ 7,1 say oir8
@ 7,8 say syy8
do dgnim with oir8, syy8, lc_dg8, 7
@ 8,1 say oir9
@ 8,8 say syy9
do dgnim with oir9, syy9, lc_dg9, 8
@ 0,70 say tp1
do tpnim with tp1, lc_tpn1, 0
@ 1,70 say tp2
do tpnim with tp2, lc_tpn2, 1
@ 2,70 say tp3
do tpnim with tp3, lc_tpn3, 2
@ 3,70 say tp4
do tpnim with tp4, lc_tpn4, 3
@ 4,70 say tp5
do tpnim with tp5, lc_tpn5, 4
@ 5,70 say tp6
do tpnim with tp6, lc_tpn6, 5
@ 6,70 say tp7
do tpnim with tp7, lc_tpn7, 6
@ 7,70 say tp8
do tpnim with tp8, lc_tpn8, 7
@ 8,70 say tp9
do tpnim with tp9, lc_tpn9, 8

@9,0 say mdc
select mdc
seek anal.mdc
if found()
  do case
  case p_kieli='F'
    @ 9,10 say substr(finish,1,50)
  otherwise
    @ 9,10 say substr(english,1,50)
  endcase
else
  @9,0 say 'No MDC'
endif

select anal
@9, 70 say dgkat
select dgkat
seek SUBSTR(anal.dgkat,1,2)+SUBSTR(anal.dgkat,4,2)
if found()
  do case
  case p_kieli='F'
    @ 9,80 say substr(finish,1,50)
  otherwise
    @ 9,80 say substr(english,1,50)
  endcase
else
  @9,80 say 'No diagnostic category'
endif

select pdgomin
seek anal.pdgomin
select anal
@10,0 say 'Properties of principal dg: '+ pdgomin +' - '+ pdgomin.english

@11,0 say 'Dg properties: '+dgomin
@11,70 say 'Proc properties: '+tpomin

@12,0 say 'Komplication categories: '+kompkat
if kompl
  @13,40 say 'Complicated'
else
  @13,40 say 'Uncomplicated'
endif
if or
  @ 14,0 say 'Operation room procedures'
else
  @ 14,0 say 'No OR procedures'
endif

if ika>2*365
  @ 15,0 say 'Age :'+str(ika/365,3)+ ' yrs'
else
  @ 15,0 say 'Age :'+str(ika,3)+ ' days'
endif

do case
case sex='F' or sex='2'
  @ 16,0 say 'Female'
case sex='M' or sex='1'
  @ 16,0 say 'Male'
otherwise
  @ 16,0 say 'Unknown sex'
endcase
if death 
  @ 17,0 say 'Death during this period'
endif
if lama
  @ 17,0 say 'Left against medical advice'
endif
if rem
  @ 17,0 say 'Remitted to other hospital'
endif
if not death and not lama and not rem
  @ 17,0 say 'Discharged normally'
endif
do case
case icu='N'
  @ 18,0 say 'Treated in NICU'
case icu='B'
  @ 18,0 say 'Treated in ICU for burns'
otherwise 
  @ 18,0 say 'No ICU treatment'
endcase 

@19,0 say 'Duration of treatment :'+str(dur,3)

select icd_10 
SET ORDER TO code
set filter to not deleted()
seek anal.oir1+anal.syy1
if not found()
   seek anal.oir1
endif
if found()
  select icd9cm_d
  seek icd10to9.icd9_cm
  @ 20,0 say 'ICD-9-CM code for main dg: '+icd10to9.icd9_cm+ ' '+ icd10to9.icd9_cm2 + ' - '+ icd9cm_d.nimi_cm
else
  @ 20,0 say 'ICD-9-CM code for main dg not found'
endif
@ 21,0 say 'F5 - Check translation table'

@ 22,0 say 'ICD-9-CSP : '
if anal.tp1<>' '
  select drgtpt
  seek anal.tp1
  select link
  set order to ncsp
  seek drgtpt.code
  if found()
    select icd9cm_o
    set order to icd9_tp
    seek link.icd9cm_o
    @ 22,30 say link.icd9cm_o+' '+icd9cm_o.nimi_cm
  endif
else
  @ 22,30 say '---'
endif
@ 23,0 say 'CTRL+F5 - check proc. translation table'
select anal
@ 24,0 say 'DRG-group: '+drg
select drgnames
seek anal.drg
if found()
  do case
  case p_kieli='F'
    @ 24,30 say finish
  otherwise 
    @ 24,30 say english
  endcase
endif
select anal
@ 25,0 say 'External DRG-group: '+drg_ext
select drgnames
seek anal.drg_ext
if found()
  do case
  case p_kieli='F'
    @ 25,40 say finish
  otherwise 
    @ 25,40 say english
  endcase
endif
select anal
@ 26,0 say 'Second external DRG-group: '+drg_ext2
select drgnames
seek anal.drg_ext2
if found()
  do case
  case p_kieli='F'
    @ 26,40 say finish
  otherwise 
    @ 26,40 say english
  endcase
endif

@ 27,0 say 'Grouping information:'
select rtc
seek drglogic.rtc
do case
case p_kieli='Fin'
  @27,30 say rtc.fin
case p_kieli='Dan'
  @27,30 say rtc.dan
case p_kieli='Swe'
  @27,30 say rtc.swe
case p_kieli='Nor'
  @27,30 say rtc.nor
otherwise
  @27,30 say rtc.eng
endcase
if anal.DRG<>'470'
 select drglogic
 @28,0 say 'Grouping used: '
 if dgprop1=' '
  @28,30 say 'No dg property'
 else
  @28,30 say 'DgProp 1 '+dgprop1
 endif
 if dgprop2<>' '
  @28,40 say '2 '+dgprop2
 endif
 if dgprop3<>' '
  @28,48 say '2 '+dgprop3
 endif
 if dgprop4<>' '
  @28,56 say '4 '+dgprop4
 endif
 if max_y>30
   @29,0 say 'Grouping used:'
   if procpro1=' '
     @29,30 say 'No procedure property'
   else
     @29,30 say 'ProcProp 1 '+procpro1
     lc_n=1
     do while apuarr(lc_n,1)<>procpro1 and lc_n<apu_n
     lc_n=lc_n+1
     enddo
     @29,48 say apuarr(lc_n,2)
   endif
   if procpro2<>' '
     @29,54 say '2 '+procpro2
     do while apuarr(lc_n,1)<>procpro2 and lc_n<apu_n
       lc_n=lc_n+1
     enddo
     @29,60 say apuarr(lc_n,2)
   endif
   if procpro3<>' '
     @29,66 say '3 '+procpro3
     do while apuarr(lc_n,1)<>procpro3 and lc_n<apu_n
       lc_n=lc_n+1
     enddo
     @29,72 say apuarr(lc_n,2)
   endif
   if secproc1<>' '
     @30,0 say 'and'
     @30,30 say '3 '+secproc1
     do while apuarr(lc_n,1)<>secproc1 and lc_n<apu_n
       lc_n=lc_n+1
     enddo
     @30,26 say apuarr(lc_n,2)
   endif
  endif
endif

activate window comm
select anal
modify memo comment window comm nowait save
if len(pb_comment)>70
  wait window nowait substr(pb_comment,1,70)
else
  wait window nowait pb_comment
endif
return

procedure dgnim
parameters dgn_oir, dgn_syy, dgn_nimi, dgn_rivi
if dgn_oir=space(6)
  @ dgn_rivi,15 say '-'
  return
endif
select icd_10
seek dgn_oir
if found()
  dgn_nimi=text
else
  do case
  case len(trim(dgn_oir))=3
    seek trim(dgn_oir)+'.9'
  case len(trim(dgn_oir))=5
    seek trim(dgn_oir)+'9'
  case len(trim(dgn_oir))=6
    seek substr(dgn_oir,1,5)
  endcase
  if found
    dgn_oir=icd_10.code
  endif
  dgn_nimi='???'
endif
if ast='*'
  @ dgn_rivi,7 say '*'
  if dgn_syy=' '
    dgn_nimi=substr(dgn_nimi,1,30)+'; ???'
  else
   seek dgn_oir+dgn_syy
   if found()
     dgn_nimi=text
   else
     seek dgn_syy
     if found()
        dgn_nimi=substr(dgn_nimi,1,30)+'; '+text
     else
        dgn_nimi=substr(dgn_nimi,1,30)+'; ???'
     endif
   endif
  endif
endif
@ dgn_rivi,15 say substr(dgn_nimi,1,50)
select anal
return

procedure tpnim
parameters tpn_tp, tpn_nimi, tpn_rivi
if tpn_tp=space(5)
  @ tpn_rivi,80 say '-'
  return
endif
select ncsp_en
*set order to simple
seek trim(tpn_tp)
if found()
  if p_kieli='E'
     tpn_nimi=english
  else
    tpn_nimi=text
  endif
else
  tpn_nimi='???'
endif
@ tpn_rivi, 80 say substr(tpn_nimi,1,50)
select anal
return
