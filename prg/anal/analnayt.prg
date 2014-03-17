Procedure analnayt
on key label alt+x do seur_ero
activate window anal
clear
select anal

lc_ika=ika
lc_sex=sex
lc_death=death
lc_dur=dur
lc_rem=rem
lc_lama=lama
lc_icu=icu
lc_oir1=oir1
do dgmapp with lc_oir1
lc_oir2=oir2
do dgmapp with lc_oir2
lc_oir3=oir3
do dgmapp with lc_oir3
lc_oir4=oir4
do dgmapp with lc_oir4
lc_oir5=oir5
do dgmapp with lc_oir5
lc_oir6=oir6
do dgmapp with lc_oir6
lc_oir7=oir7
do dgmapp with lc_oir7
lc_oir8=oir8
do dgmapp with lc_oir8
lc_oir9=oir9
do dgmapp with lc_oir9
lc_syy1=syy1
do dgmapp with lc_syy1
lc_syy2=syy2
do dgmapp with lc_syy2
lc_syy3=syy3
do dgmapp with lc_syy3
lc_syy4=syy4
do dgmapp with lc_syy4
lc_syy5=syy5
do dgmapp with lc_syy5
lc_syy6=syy6
do dgmapp with lc_syy6
lc_syy7=syy7
do dgmapp with lc_syy7
lc_syy8=syy8
do dgmapp with lc_syy8
lc_syy9=syy9
do dgmapp with lc_syy9
lc_tp1=anal.tp1
do tpmapp with lc_tp1
lc_tp2=anal.tp2
do tpmapp with lc_tp2
lc_tp3=anal.tp3
do tpmapp with lc_tp3
lc_tp4=anal.tp4
do tpmapp with lc_tp4
lc_tp5=anal.tp5
do tpmapp with lc_tp5
lc_tp6=anal.tp6
do tpmapp with lc_tp6
lc_tp7=anal.tp7
do tpmapp with lc_tp7
lc_tp8=anal.tp8
do tpmapp with lc_tp8
lc_tp9=anal.tp9
do tpmapp with lc_tp9
select anal
do naytkirj

@13,1 say mdc
select mdc
seek anal.mdc
if found()
  do case
  case p_kieli='F'
    @13,10 say substr(finish,1,50)
  otherwise
    @13,10 say substr(english,1,50)
  endcase
else
  @13,1 say 'No MDC'
endif

select anal
@13, 70 say dgkat
select dgkat
seek SUBSTR(anal.dgkat,1,2)+SUBSTR(anal.dgkat,4,2)
if found()
  do case
  case p_kieli='F'
    @ 13,80 say substr(finish,1,50)
  otherwise
    @ 13,80 say substr(english,1,50)
  endcase
else
  @13,80 say 'No diagnostic category'
endif

select pdgomin
select anal
@14,1 say 'Properties of principal dg: '+ pdgomin
if pdgomin='  '
  @14,40 say '-'
endif

@15,1 say 'Dg properties: '+dgomin
if dgomin='  '
  @15,40 say '-'
endif
@15,70 say 'Proc properties: '+tpomin
if tpomin='  '
  @15,100 say '-'
endif

@16,1 say 'CC-categories: '+kompkat
if kompkat='  '
  @16,40 say '-'
endif
DO case
case kompl='1'
  @17,1 say 'With CC'
case kompl='2'
  @17,1 say 'With MCC'
otherwise
  @17,1 say 'Without CC'
endcase
do case
case or='1'
  @ 18,1 say 'Operation room procedures'
case or='2'
  @ 18,1 say 'Outpatient procedures'
otherwise
  @ 18,1 say 'No significant procedures'
endcase

select icd_10 
SET ORDER TO code
set filter to valid
seek anal.oir1+anal.syy1
if not found()
   seek anal.oir1
endif
if found()
  select icd9cm_d
  seek icd10to9.icd9_cm
  @ 21,1 say 'ICD-9-CM code for main dg: '+icd10to9.icd9_cm+ ' '+ icd10to9.icd9_cm2 + ' - '+ icd9cm_d.nimi_cm
else
  @ 21,1 say 'ICD-9-CM code for main dg not found'
endif
@ 22,1 say 'F5 - Check translation table'

@ 23,1 say 'ICD-9-CSP : '
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
    @ 23,30 say link.icd9cm_o+' '+icd9cm_o.nimi_cm
  endif
else
  @ 23,30 say '---'
endif
@ 24,1 say 'CTRL+F5 - check proc. translation table'
select anal
@ 25,1 say ' DRG: '+ drg +' ('+trim(ord)+')'
select drgnames
set filter to valid
set order to loc_drg
seek TRIM(anal.drg)
if found()
  @ 25,30 say drgname
else
  @ 25,30 say "Cannot find DRGNAME"
endif
set order to drg
select anal
@ 26,1 say 'External DRG-group: '+drg_ext
select drgnames
seek anal.drg_ext
if found()
  @ 26,40 say drgname
endif
select anal
@ 27,1 say 'Second external DRG-group: '+drg_ext2
select drgnames
seek anal.drg_ext2
if found()
  @ 27,40 say drgname
endif

@ 28,1 say 'Grouping information:'
select rtc
seek drglogic.rtc
do case
case p_kieli='Fin'
  @28,30 say rtc.fin
case p_kieli='Den'
  @28,30 say rtc.dan
case p_kieli='Swe'
  @28,30 say rtc.swe
case p_kieli='Nor'
  @28,30 say rtc.nor
otherwise
  @28,30 say rtc.eng
endcase
if anal.DRG<>'470'
 select drglogic
 @29,1 say 'Grouping used: '
 if dgprop1=' '
  @30,30 say 'No dg property'
 else
  @30,30 say 'DgProp 1: '+dgprop1
 endif
 if dgprop2<>' '
  @30,50 say '2: '+dgprop2
 endif
 if dgprop3<>' '
  @30,60 say '3: '+dgprop3
 endif
 if dgprop4<>' '
  @30,70 say '4: '+dgprop4
 endif
 if max_y>40
   if procpro1=' '
     @31,30 say 'No procedure property'
     lc_n=0
   else
     @31,30 say 'ProcProp 1: '+procpro1
     lc_n=1
     do while apuarr(lc_n,1)<>procpro1 and lc_n<apu_n and lc_n>0
       lc_n=lc_n+1
     enddo
*     @29,48 say apuarr(lc_n,2)
   endif
   if procpro2<>' '
     @31,54 say '2: '+procpro2
     if lc_n>0
       do while apuarr(lc_n,1)<>procpro2 and lc_n<apu_n and lc_n>0
         lc_n=lc_n+1
       enddo
       @31,60 say apuarr(lc_n,2)
     endif
   endif
   if procpro3<>' '
     @32,66 say '3 '+procpro3
     if lc_n>0
       do while apuarr(lc_n,1)<>procpro3 and lc_n<apu_n
         lc_n=lc_n+1
       enddo
       @32,72 say apuarr(lc_n,2)
     endif
   endif
   if secproc1<>' '
     @33,1 say 'and'
     @33,30 say '3 '+secproc1
     if lc_n>0
       do while apuarr(lc_n,1)<>secproc1 and lc_n<apu_n
         lc_n=lc_n+1
       enddo
       @33,26 say apuarr(lc_n,2)
     endif
   endif
  endif
endif
activate window comm
clear
@0,5 say  anal.comment 
select anal
p_ldg=oir1
p_lproc=tp1
p_ldrg=drg
p_ord=ord
return

Procedure tpmapp
parameter tp_tp
if tp_tp =' '
  return
ENDIF
*SET STEP ON
if p_allrules and tp_tp<>' '
  lc_found=.f.
  SELECT csp
  SET ORDER TO code
  SEEK tp_tp
  IF NOT FOUND()
    SET ORDER TO ncsp
    SEEK tp_tp
  ENDIF
  IF FOUND()
    tp_tp=code
  endif
endif
return tp_tp

procedure dgmapp
parameter dgm_dg
if p_allrules and dgm_dg<>' '
  select icd_10
  set filter to valid
  seek UPPER(dgm_dg)
  if not found()
    set order to code_w
    seek UPPER(dgm_dg)
    if found()
      dgm_dg=code
    endif
    set order to code
  endif
endif
select anal
return dgm_dg