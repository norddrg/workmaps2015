procedure drgyks

do inuse
select dg
lc_order=order()
select language
seek trim(p_kieli)
on key label ctrl+p do tulostus
public dy_title
dy_title=' '
do drgsis
wait window 'Paper hardcopy - [P]. Continue - [Enter]'
if lastkey()=80 or lastkey()=112
  set printer to
  set printer on
  do drgsis
  set printer off
  set printer to
endif
set message to 'Paper hardcopy of the list - [Ctrl][P]'
select drgtpt
set relation to code into csp

select icd_10
set filter to not deleted()
set order to code
select dg
set filter to valid
set relation to upper(code+d_code) into icd_10
if drglogic.mdc<>' ' and drglogic.dgcat1= ' '
*lc_mdcfi=language.lan+'\mdc_'+drglogic.mdc
select 0
use ..\logi_mdc2 alias logi_apu
set order to code
goto top
if name<>drglogic.mdc or code_2<>p_kieli
 delete all
 pack
 append blank
 replace name with drglogic.mdc, code_2 with p_kieli
 select dg 
 set order to varval
 seek 'DGCAT   '+(drglogic.mdc)
 lc_n=0
 do while substr(varval,1,2)=drglogic.mdc and not eof() 
  select logi_apu
  seek upper(dg.code+dg.d_code)
  if not found()
    lc_n=lc_n+1
    insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
  endif
  select dg
  skip
 enddo
 if drglogic.mdc='12' or drglogic.mdc='13'
  seek 'DGCAT   98'
  do while substr(varval,1,2)='98' 
    select logi_apu
    seek upper(dg.code+dg.d_code)
    if not found()
      lc_n=lc_n+1
      insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
    endif
    select dg
    skip
  enddo
 endif
else
  lc_n=val (code)
endif
seek drglogic.mdc
dy_title = 'Dg큦 of MDC '+drglogic.mdc+' - '+trim(dgkat.english)
DEFINE WINDOW mdcsis FROM max_y/5,max_x/4 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
activate window mdcsis
select logi_apu
goto top
replace code with str(lc_n,5,0)
wait window nowait 'Number of codes ' +str (lc_n,5,0)
browse fields code, code_2, name:80 Noedit nodelete
use
release window mdcsis
endif

if drglogic.pdgprop<>' '
select 0
use ..\logi_apu2 alias logi_apu
set order to code
delete all
pack
select icd_10
set order to code
select dg
set order to varval
seek 'PDGPRO  '+ SUBSTR(drglogic.pdgprop,1,2)+SUBSTR(drglogic.pdgprop,4,2)+SUBSTR(drglogic.pdgprop,3,1)
lc_n=0
do while varval=drglogic.pdgprop and not eof()
  select logi_apu
  seek upper(dg.code+dg.d_code)
  if not found()
    lc_n=lc_n+1
    insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
  endif
  select dg
  skip
enddo
select pdgomin
seek drglogic.pdgprop
dy_title = 'Dg큦 of PDGPROP '+drglogic.pdgprop+' - '+trim(pdgomin.english)
DEFINE WINDOW mdcsis FROM max_y/5,max_x/3 to max_y,max_x ;
TITLE (dy_title);
FONT max_foty,  max_fosi double
activate window mdcsis
select logi_apu
goto top
wait window nowait 'Number of codes ' +str (lc_n,5,0)
browse fields code, code_2, name:80 Noedit nodelete
use
release window mdcsis
endif

if drglogic.procpro1<>' '
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  lc_n=0
  select drgtpt
  set order to varval
  lc_prpro=drglogic.procpro1
  do case
  case drglogic.procpro1='99S90'
*    wait window 'All procedures with procprop with property "extens"'
    goto top
    do while not eof()
      if vartype='PROCPR'
        select tpomin
        seek drgtpt.varval
        if tpomin.extens='1'
          insert into logi_apu (code_2, name) values (drgtpt.code, csp.text)
          select logi_apu
          lc_n=lc_n+1
        endif
      endif
      select drgtpt
      skip
    enddo
  case drglogic.procpro1='99O98'
    seek 'PROCPR  '
    do while not eof()
      if substr(varval,3,1)='E' or varval='99O'
        insert into logi_apu (code_2, name) values (drgtpt.code, csp.text)
        select logi_apu
        lc_n=lc_n+1
      endif
      select drgtpt
      skip
    enddo
  otherwise
    seek 'PROCPR  '+drglogic.procpro1
    if drglogic.procpro1='99O99'
      lc_prpro='99O'
      seek 'PROCPR  '+'99O'
    endif
    do while drgtpt.varval=lc_prpro and not eof()
      insert into logi_apu (code_2, name) values (drgtpt.code, csp.text)
      select logi_apu
      lc_n=lc_n+1
      select drgtpt
      skip
    enddo
    select dg
    set order to varval
    seek 'PROCPR  '+substr(drglogic.procpro1,1,2)+SUBSTR(drglogic.procpro1,4,2)+SUBSTR(drglogic.procpro1,3,1)
    do while drglogic.procpro1=dg.varval and not eof()
      select logi_apu
      seek upper(dg.code+dg.d_code)
      if not found()
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code,icd_10.text)
      endif
      select dg
      skip
    enddo
  endcase
  select tpomin
  set order to procprop
  seek drglogic.procpro1
  dy_title = 'Proc. and dg큦 with proc. prob. '+drglogic.procpro1+' - ' + trim(tpomin.english)
  DEFINE WINDOW tpsis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
  activate window tpsis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  select logi_apu
  use
endif

if drglogic.dgcat1<>' '
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  lc_n=0
  select dg
  set order to varval
  lc_kat=trim(drglogic.dgcat1)
  seek 'DGCAT   '+substr(lc_kat,1,2)+substr(lc_kat,4,2)
  do while dg.varval=lc_kat and not eof()
  select logi_apu
  seek upper(dg.code+dg.d_code)
  if not found()
    lc_n=lc_n+1
    insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
  endif
  select dg
  skip
  enddo
  if substr(lc_kat,1,2)='12' or substr(lc_kat,1,2)='13'
    lc_kat='98'+substr(lc_kat,3,3)
    seek 'DGCAT   '+substr(lc_kat,1,2)+substr(lc_kat,4,2)
    do while dg.varval=lc_kat and not eof()
  select logi_apu
  seek upper(dg.code+dg.d_code)
  if not found()
    lc_n=lc_n+1
    insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
  endif
  select dg
  skip
    enddo
  endif
  select dgkat
  seek SUBSTR(drglogic.dgcat1,1,2)+SUBSTR(drglogic.dgcat1,4,2)
  dy_title = 'Dg큦 in the dg-category '+drglogic.dgcat1+' - ' + trim(dgkat.english)
  DEFINE WINDOW mdcsis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title)  FONT max_foty,  max_fosi double
  activate windows mdcsis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  use
endif

if drglogic.dgprop1<>' '
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  select dg
  set order to varval
  set filter to valid
  lc_n=0
   if drglogic.dgprop1='-'
    lc_dgomin= substr(drglogic.dgprop1,2,5)
  else
    lc_dgomin=trim(drglogic.dgprop1)
  endif
  if substr(drglogic.dgprop1,3,3)='X99'
    lc_dgomin=substr(drglogic.dgprop1,1,2)
    seek 'DGCAT   '+lc_dgomin
  else
    seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
  endif
  do while dg.varval=lc_dgomin
    select logi_apu
    seek upper(dg.code+dg.d_code)
    if not found()
      lc_n=lc_n+1
      insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
    endif
    select dg
    skip
  enddo
  select drgtpt
  set order to varval
  seek 'DGPROP  '+lc_dgomin
  do while drgtpt.varval=lc_dgomin
    select logi_apu
    lc_n=lc_n+1
    if p_kieli='Eng'
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.text)
    else
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.text)
    endif
    select drgtpt
    skip
  enddo
  select dgomin
  set order to dgprop
  if drglogic.dgprop1='-'
    seek SUBSTR(drglogic.dgprop1,2,2)+SUBSTR(drglogic.dgprop1,5,2)+SUBSTR(drglogic.dgprop1,4,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop1+' - '+trim(dgomin.english)
    dy_title = dy_title + ' - NOT allowed in this DRG'
  else
    seek SUBSTR(drglogic.dgprop1,1,2)+SUBSTR(drglogic.dgprop1,4,2)+SUBSTR(drglogic.dgprop1,3,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop1+' - '+trim(dgomin.english)
  endif
  DEFINE WINDOW dgosis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
  activate window dgosis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  use
  release window dgosis
endif

if drglogic.dgprop2<>' '
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  select dg
  set order to varval
  set filter to valid
  lc_n=0
  if drglogic.dgprop2='-'
    lc_dgomin= substr(drglogic.dgprop2,2,5)
  else
    lc_dgomin=trim(drglogic.dgprop2)
  endif
  seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
  do while dg.varval=lc_dgomin
    select logi_apu
    seek upper(dg.code)
    if not found()
      lc_n=lc_n+1
      insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
    endif
    select dg
    set order to varval
    skip
  enddo
  select drgtpt
  set order to varval
  seek 'DGPROP  '+lc_dgomin
  do while drgtpt.varval=lc_dgomin
    select logi_apu
    lc_n=lc_n+1
    if p_kieli='Eng'
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.english)
    else
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.text)
    endif
    select drgtpt
    skip
  enddo
  select dgomin
  set order to dgprop
  if drglogic.dgprop2='-'
    seek SUBSTR(drglogic.dgprop2,2,2)+SUBSTR(drglogic.dgprop2,5,2)+SUBSTR(drglogic.dgprop2,4,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop2+' - '+trim(dgomin.english)
    dy_title = dy_title + ' - NOT allowed in this DRG'
  else
    seek SUBSTR(drglogic.dgprop2,1,2)+SUBSTR(drglogic.dgprop2,4,2)+SUBSTR(drglogic.dgprop2,3,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop2+' - '+trim(dgomin.english)
  endif
  DEFINE WINDOW dgosis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
  activate window dgosis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  use
  release window dgosis
endif

if drglogic.dgprop3<>' '
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  select dg
  set filter to valid
  set order to varval
  lc_n=0
  if drglogic.dgprop3='-'
    lc_dgomin= substr(drglogic.dgprop3,2,5)
  else
    lc_dgomin=trim(drglogic.dgprop3)
  endif
  seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
  do while dg.varval=lc_dgomin
  select logi_apu
  seek upper(dg.code)
  if not found()
    lc_n=lc_n+1
    insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
  endif
  select dg
  skip
  enddo
  select drgtpt
  set order to varval
  seek 'DGPROP  '+lc_dgomin
  do while drgtpt.varval=lc_dgomin
    select logi_apu
    lc_n=lc_n+1
    if p_kieli='ENG'
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.english)
    else
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.text)
    endif
    select drgtpt
    skip
  enddo
  select dgomin
  set order to dgprop
  if drglogic.dgprop3='-'
    seek SUBSTR(drglogic.dgprop3,2,2)+SUBSTR(drglogic.dgprop3,5,2)+SUBSTR(drglogic.dgprop3,4,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop3+' - '+trim(dgomin.english)
    dy_title = dy_title + ' - NOT allowed in this DRG'
  else
    seek SUBSTR(drglogic.dgprop3,1,2)+SUBSTR(drglogic.dgprop3,4,2)+SUBSTR(drglogic.dgprop3,3,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop3+' - '+trim(dgomin.english)
  endif
  DEFINE WINDOW dgosis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
  activate window dgosis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  use
  release window dgosis
endif

if drglogic.dgprop4<>' '
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  select dg
  set order to varval
  set filter to valid
  lc_n=0
  if drglogic.dgprop4='-'
    lc_dgomin= substr(drglogic.dgprop4,2,5)
  else
    lc_dgomin=trim(drglogic.dgprop4)
  endif
  seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
  do while dg.varval=lc_dgomin
  select logi_apu
  seek upper(dg.code)
  if not found()
    lc_n=lc_n+1
    insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
  endif
  select dg
  skip
  enddo
  select drgtpt
  set order to varval
  seek 'DGPROP  '+lc_dgomin
  do while drgtpt.varval=lc_dgomin
    select logi_apu
    lc_n=lc_n+1
    if p_kieli='ENG'
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.english)
    else
      insert into logi_apu (code_2,name) values (drgtpt.code, csp.text)
    endif
    select drgtpt
    skip
  enddo
  select dgomin
  set order to dgprop
  if drglogic.dgprop4='-'
    seek SUBSTR(drglogic.dgprop4,2,2)+SUBSTR(drglogic.dgprop4,5,2)+SUBSTR(drglogic.dgprop4,4,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop4+' - '+trim(dgomin.english)
    dy_title = dy_title + ' - NOT allowed in this DRG'
  else
    seek SUBSTR(drglogic.dgprop4,1,2)+SUBSTR(drglogic.dgprop4,4,2)+SUBSTR(drglogic.dgprop4,3,1)
    dy_title = 'Proc. and Dg큦 with Dg-property '+drglogic.dgprop4+' - '+trim(dgomin.english)
  endif
  DEFINE WINDOW dgosis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
  activate window dgosis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  use
  release window dgosis
endif

if len(trim(drglogic.secproc1))>1
  select 0
  use ..\logi_apu2 alias logi_apu
  set order to code
  delete all
  pack
  select drgtpt
  set order to varval
  if drglogic.secproc1='-'
    lc_tpomin = substr(drglogic.secproc1,2,5)
  else
    lc_tpomin = trim(drglogic.secproc1) 
  endif
  seek 'PROCPR  '+lc_tpomin
  lc_n=0
  do while drgtpt.varval=lc_tpomin
    if p_kieli='Eng'
      insert into logi_apu (code,name) values (drgtpt.code, csp.text)
    else
      insert into logi_apu (code,name) values (drgtpt.code, csp.text)
    endif
    select logi_apu
    lc_n=lc_n+1
    select drgtpt
    skip
  enddo
  select dg
  set order to varval
  seek 'PROCPR  '+substr(lc_tpomin,1,2)+substr(lc_tpomin,4,2)+substr(lc_tpomin,3,1)
  do while lc_tpomin=dg.varval and not eof()
    select logi_apu
    seek upper(dg.code+dg.d_code)
    if not found()
      lc_n=lc_n+1
      insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
    endif
    select dg
    skip
  enddo
  select tpomin
  set order to procprop
  seek lc_tpomin
  dy_title = 'Proc. and dg큦 with the proc. prob. '+ lc_tpomin+' - ' + trim(tpomin.english)
  DEFINE WINDOW tpsis FROM max_y/5,max_x/3 to max_y,max_x TITLE (dy_title) FONT max_foty,  max_fosi double
  activate window tpsis
  select logi_apu
  goto top
  wait window nowait 'Number of codes ' +str (lc_n,5,0)
  browse fields code, code_2, name:80 Noedit nodelete
  use
  release window tpsis
endif
on key label ctrl+p
set message to
release window tpsis
release window mdcsis
select dg
set order to (lc_order)
return

Procedure tulostus
set printer to
set printer on
set console off
? p_kieli
? dy_title style 'B' 
?
? 'code'
?? 'code_2' at 8
?? 'name' at 20
goto top
do while not eof()
  ? code
  ?? code_2 at 8
  ?? trim(name) at 20
  skip
enddo
set printer off
set printer to
set console on
return
