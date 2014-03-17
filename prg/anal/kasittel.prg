Procedure kasittel
push key clear
lc_loop=.t.
on key label f10
on key label pgdn
on key label pgup
gl_n=1
dg_tp=' '
do while lc_loop
 lc_correct=.t.
 do naytkirj
 if lastkey()=27
   deactivate window syotto
   exit
 endif
 activate window syotto
 clear
 do case
 case dg_tp=' '
   select anal
   lc_d_y='days'
   if lc_ika>365
     lc_ika=lc_ika/365.24
     lc_d_y='years'
   endif
   ka_loop=.t.
   do while ka_loop
     @0,0 say 'Basic information'
     @1,0 say 'Age, yrs / days ' get lc_ika picture '999'
     @1,22 get lc_d_y picture '@M days,years'
     @1,40 say 'Sex ' get lc_sex picture '@M F,M, '
     @2,0 say 'Death' get lc_death 
     @2,40 say 'Left AMA ' get lc_lama
     @3,0 say 'Remitted ' get lc_rem 
     @4,0 say 'ICU ' get lc_icu picture '@M N,B, '
     @4, 40 say 'Duration of treatment ' get lc_dur picture '999'
     read
     lc_disch=0
     if lc_death
       lc_disch=lc_disch+1
     endif
     if lc_rem
       lc_disch=lc_disch+1
     endif
     if lc_lama
       lc_disch=lc_disch+1
     endif
     if lc_disch>1
       wait window nowait 'Patient can only die, be remitted or leave against medical advice!'
        loop
     endif
     exit
   enddo
   if lc_d_y='y'
     lc_ika=365.25*lc_ika
   endif
   lc_sex=upper(lc_sex)
   if lastkey()=3
     dg_tp='D'
   endif
   if lastkey()=18
     deactivate window syotto
     do analohje
     return
   endif
   loop
 case dg_tp='D'
   @ 1,1 say gl_n picture '9'
   do case
   case gl_n=1
     lc_oir = lc_oir1
     lc_syy = lc_syy1
     do dgkirj 
     lc_oir1 = lc_oir
     lc_syy1 = lc_syy
   case gl_n=2
     lc_oir = lc_oir2
     lc_syy = lc_syy2
     do dgkirj 
     lc_oir2 = lc_oir
     lc_syy2 = lc_syy
   case gl_n=3
     lc_oir = lc_oir3
     lc_syy = lc_syy3
     do dgkirj 
     lc_oir3 = lc_oir
     lc_syy3 = lc_syy
   case gl_n=4
     lc_oir = lc_oir4
     lc_syy = lc_syy4
     do dgkirj 
     lc_oir4 = lc_oir
     lc_syy4 = lc_syy
   case gl_n=5
     lc_oir = lc_oir5
     lc_syy = lc_syy5
     do dgkirj 
     lc_oir5 = lc_oir
     lc_syy5 = lc_syy
   case gl_n=6
     lc_oir = lc_oir6
     lc_syy = lc_syy6
     do dgkirj 
     lc_oir6 = lc_oir
     lc_syy6 = lc_syy
   case gl_n=7
     lc_oir = lc_oir7
     lc_syy = lc_syy7
     do dgkirj 
     lc_oir7 = lc_oir
     lc_syy7 = lc_syy
   case gl_n=8
     lc_oir = lc_oir8
     lc_syy = lc_syy8
     do dgkirj 
     lc_oir8 = lc_oir
     lc_syy8 = lc_syy
   case gl_n=9
     lc_oir = lc_oir9
     lc_syy = lc_syy9
     do dgkirj 
     lc_oir9 = lc_oir
     lc_syy9 = lc_syy
   endcase
   if lc_oir=' '
     gl_apu=gl_n
     do while gl_n<10
       do case
       case gl_n=1
         lc_oir1 = lc_oir2
         lc_syy1 = lc_syy2
       case gl_n=2
         lc_oir2 = lc_oir3
         lc_syy2 = lc_syy3
       case gl_n=3
         lc_oir3 = lc_oir4
         lc_syy3 = lc_syy4
       case gl_n=4
         lc_oir4 = lc_oir5
         lc_syy4 = lc_syy5
       case gl_n=5
         lc_oir5 = lc_oir6
         lc_syy5 = lc_syy6
       case gl_n=6
         lc_oir6 = lc_oir7
         lc_syy6 = lc_syy7
       case gl_n=7
         lc_oir7 = lc_oir8
         lc_syy7 = lc_syy8
       case gl_n=8
         lc_oir8 = lc_oir9
         lc_syy8 = lc_syy9
       case gl_n=9
         lc_syy9 = ' '
       endcase
       gl_n=gl_n+1
     enddo
     gl_n=0
   endif
   if lastkey()=13 or lastkey()=121
     gl_n=gl_n+1
   endif
   if gl_n=10
     gl_n=1
   endif
   lc_corrdg=.t.
   do naytkirj
   if lastkey()=3 
     if not lc_corrdg
       wait window 'Error(s) in codes. Accept with [PageUp]/[PageDown]'
       if lastkey()<>3 and lastkey()<>18
         loop
       endif
     endif
     dg_tp='T'
     gl_n=1
   endif
   if lastkey()=18
     if not lc_corrdg
       wait window 'Error(s) in codes. Accept with [PageUp]/[PageDown]'
       if lastkey()<>3 and lastkey()<>18
         loop
       endif
     endif
     dg_tp=' '
     gl_n=1
   endif
   loop
 case dg_tp='T'
   @ 1,1 say gl_n picture '9'
   do case
   case gl_n=1
     do tpkirj with lc_tp1
     lc_tp=lc_tp1
   case gl_n=2
     do tpkirj with lc_tp2
     lc_tp=lc_tp2
   case gl_n=3
     do tpkirj with lc_tp3
     lc_tp=lc_tp3
   case gl_n=4
     do tpkirj with lc_tp4
     lc_tp=lc_tp4
   case gl_n=5
     do tpkirj with lc_tp5
     lc_tp=lc_tp5
   case gl_n=6
     do tpkirj with lc_tp6
     lc_tp=lc_tp6
   case gl_n=7
     do tpkirj with lc_tp7
     lc_tp=lc_tp7
   case gl_n=8
     do tpkirj with lc_tp8
     lc_tp=lc_tp8
   case gl_n=9
     do tpkirj with lc_tp9
     lc_tp=lc_tp9
   endcase
   if lc_tp=' '
     gl_apu=gl_n
     do while gl_n<10
       do case
       case gl_n=1
         lc_tp1 = lc_tp2
       case gl_n=2
         lc_tp2 = lc_tp3
       case gl_n=3
         lc_tp3 = lc_tp4
       case gl_n=4
         lc_tp4 = lc_tp5
       case gl_n=5
         lc_tp5 = lc_tp6
       case gl_n=6
         lc_tp6 = lc_tp7
       case gl_n=7
         lc_tp7 = lc_tp8
       case gl_n=8
         lc_tp8 = lc_tp9
       case gl_n=9
         lc_tp9 = space(6)
       endcase
       gl_n=gl_n+1
     enddo
     gl_n=0
   endif
   if lastkey()=13
     gl_n=gl_n+1
   endif
   lc_corrtp=.t.
   do naytkirj
   if lastkey()=3
     if not lc_corrtp
       wait window 'Error(s) in codes. Accept with [PageUp]/[PageDown]'
       if lastkey()<>3 and lastkey()<>18
         loop
       endif
     endif
     deactivate window syotto
     do analohje
     return
   endif
   if lastkey()=18 
     if not lc_correct
       wait window 'Error(s) in codes. Accept with [PageUp]/[PageDown]'
       if lastkey()<>3 and lastkey()<>18
         loop
       endif
     endif
     dg_tp='D'
     gl_n=1
   endif
 endcase
enddo
do analohje
return

procedure dgkirj
do while lc_loop
 lc_ast=' '
 old_oir=lc_oir
 old_syy=lc_syy
 select icd_10
 SET ORDER TO code
 if lc_oir<>' '
   seek upper(lc_oir)
   if not found() and p_allrules
     set order to code_w
     seek upper(lc_oir)
   endif
 else
   goto top
 endif
 if found()
   lc_dg=text
 else
   lc_dg='-'
 endif
 on key label alt+f do icdhaku 
 @ 0,0 say 'Give ICD-10 code'
 if ast='*' or ast='#'
   @ 1, 11 say ast
   @ 2, 4 get lc_syy
   lc_ast=ast
 else
   @ 2,4 say '-'
   lc_syy=space(6)
 endif
 @ 1, 4 get lc_oir
 if lc_oir<>' '
   @ 1, 16 say lc_dg
 else
   @ 1,16 say '---'
 endif
 if lc_syy<>space(6)
  seek lc_oir+lc_syy
  lc_dg=text
  if not found()
     seek lc_oir 
     lc_dg=text
     if not found()
        lc_dg='-'
     else
       seek lc_syy
       if not found()
         lc_dg=substr(lc_dg,1,30) + ' +???'
       else
         lc_dg=substr(lc_dg,1,30)+'; '+text
       endif
     endif
  endif
  lc_dg=substr(lc_dg,1,50)
 endif
 if lc_syy<>' '
   select icd_10
   seek lc_syy
   @ 2,16 say text
 endif
 read
 select icd_10
 seek upper(lc_oir)
 IF NOT FOUND()
   SET ORDER TO CODE_W   && UPPER(CODE_W+D_CODE_W)
   SEEK UPPER(lc_oir)
 endif
 seek upper(lc_syy)
 IF NOT FOUND()
   SET ORDER TO code_w
   SEEK UPPER(lc_syy)
 ENDIF 
 select icd_10
 if lc_oir=' '
   seek '-'
 else
   seek lc_oir
 endif
 if (ast='*' or ast='#') and lc_syy=' '
   wait window 'Do you want to creat a case without etiological dg, y/n?'
   if lastkey() = 121
     lc_dg= text
     exit
   endif
   loop
 endif
 if lastkey()=18 or lastkey()=3 or lastkey()=121
   exit
 endif
 if lastkey()=13 and old_syy=lc_syy and old_oir=lc_oir
   exit
 endif
enddo
on key label alt+f
on key label alt+y
return 

Procedure tpkirj
parameter tpk_tp
do while lc_loop
 old_tp=tpk_tp
 select csp
 lc_tpn='-'
 if tpk_tp<>' '
   seek trim(tpk_tp)
   if found()and tpk_tp<>' '
    lc_tpn = text
   endif
   if not found() and p_allrules 
     lc_found=.f.
     SELECT csp
     SET ORDER TO code
     SEEK tpk_tp
     IF NOT FOUND()
        SET ORDER TO ncsp
        SEEK tpk_tp
     ENDIF
     IF FOUND()
        lc_tpn=text
     endif
   endif
 endif
 on key label alt+f do tphaku
 @ 0,0 say 'Give NCSP-code (* = NCSP-plus code)'
 @ 1,4 get tpk_tp
 if tpk_tp<>' '
   @ 1,16 say lc_tpn
 else
   @ 1,16 say '---'
 endif
 read
 tpk_tp=upper(tpk_tp)
 if lastkey()=18 or lastkey()=3
   dgn_nimi=text
   exit
 endif
 if lastkey()=13 and old_tp=tpk_tp
   exit
 endif
enddo
if lc_tpn='-' 
  lc_tp=space(6)
endif
on key label alt+f
on key label alt+y
return lc_tpn

Procedure vaihto
clear read
if dg_tp='D'
  dg_tp='T'
else
  dg_tp='D'
endif
return

Procedure icdhaku
activate window anal
do while lc_loop
  select icd_10
  on key label alt+f do haku
  on key label alt+y do haku9
  set filter to  not deleted()
  browse fields code, ast, d_code, code_w, d_code_w, text
  IF LASTKEY()=23
    ic_code=code_w
    ic_dcode=d_code_w
  ELSE
    ic_code=code
    ic_dcode=d_code
  ENDIF 
  if lc_ast='*'
    if ast='*'
      lc_oir=ic_code
      if ic_dcode<>' '
        lc_syy=ic_dcode
      endif
    else
      lc_syy=ic_code  
    endif
  else
    lc_oir=ic_code
    if ast='*'
      lc_syy=ic_dcode
    endif
  endif
  if lastkey()=23 OR LASTKEY()=27
    exit
  endif
enddo
activate window syotto
clear read 
return

procedure haku
on key label alt+f
on key label alt+y
define window koodi from 5,5 to 15,30 FONT  max_foty,  max_fosi
activate window koodi
ke_koodi=space(6)
@ 2,1 say 'Give the diagnosis code to search for!'
@ 3,5 get ke_koodi
read
ke_koodi=upper(ke_koodi)
seek ke_koodi
if not found()
   set order to code
   seek ke_koodi
endif
release window koodi
on key label alt+f do haku
on key label alt+y do haku9
return

procedure haku9
on key label alt+f
on key label alt+y
define window koodi from 5,5 to 15,30 FONT  max_foty,  max_fosi
activate window koodi
ke_koodi=space(6)
@ 2,1 say 'Give the ICD-9-CM code to search for!'
@ 3,5 get ke_koodi
read
ke_koodi=upper(ke_koodi)
release window koodi
select icd9to10
seek ke_koodi
browse fields icd9_cm, icd9_cm2, icd_10_1, icd_10_2, text
select icd_10
if icd9to10.icd_10_2=' '
  seek icd9to10.icd_10_1
else
  seek icd9to10.icd_10_2+icd9to10.icd_10_1
endif
on key label alt+f do haku
on key label alt+y do haku9
return

Procedure tphaku
activate window anal
do while lc_loop
  select csp
  on key label alt+f do hakutp
  on key label alt+y do hakutpl
  set filter to code<>' ' and not deleted()
  if p_kieli<>'Com'
    wait window nowait 'Select national code [Esc], select NCSP+ code [Ctrl][W]'
    browse fields code, ncsp, text
    tpk_tp=ncsp
    if lastkey()=27
      tpk_tp=code
    endif
  else
    browse fields code, text
    tpk_tp=code
  endif
  if lastkey()=23 or lastkey()=27
    exit
  endif
enddo
activate window syotto
clear read
return 

Procedure hakutpl
on key label alt+f
on key label alt+y
define window koodi from 5,5 to 15,30 FONT  max_foty,  max_fosi
activate window koodi
ke_koodi=space(6)
@ 2,1 say 'Give the ICD-9-CSP code to search for!'
@ 3,5 get ke_koodi
read
ke_koodi=upper(ke_koodi)
release window koodi
select link
seek trim(ke_koodi)
browse fields icd9cm_o, ncsp
select ncsp_en
seek link.ncsp
on key label alt+f do hakutp
on key label alt+y do hakutpl
return

procedure hakutp
on key label alt+f
on key label alt+y
define window koodi from 5,5 to 15,30 FONT  max_foty,  max_fosi
activate window koodi
ke_koodi=space(6)
@ 2,1 say 'Give the (NCSP) code to searh for!'
@ 3,5 get ke_koodi
read
ke_koodi=upper(ke_koodi)
seek trim(ke_koodi)
release window koodi
on key label alt+f do hakutp
on key label alt+y do hakutpl
return

