procedure listmuod
* Muodostaa manuaalin tarvitsemat listat
public dy_title
set safety off
dy_title=' '

p_allrules=.f.

ACTIVATE WINDOW valikko
CLEAR

? 'Cleaning old files'
erase ('..\..\..\tabl_man\'+p_kieli+'\*.txt')
erase ('..\..\..\tabl_man\'+p_kieli+'\*.dbf')
erase ('..\..\..\tabl_man\'+p_kieli+'\*.cdx')
erase ('..\..\..\tabl_man\'+p_kieli+'\manual\*.htm')
erase ('..\..\..\tabl_man\'+p_kieli+'\xls\*.xls')
*lc_genhtml=home()+'genhtml'

select icd_10
set filter to not deleted()
set order to code
select dg
set filter to valid 
set relation to code+d_code into icd_10
set order to code
lc_dgorder=order()

select 0
USE ..\logi_apu.dbf
select 0
use ..\rtc_apu
select drgtpt
set relation to code into csp
select 0
use ..\logi_excl.dbf
do ccdg
do dgcyhd
do dgcatego
do tpomtabl
do dgomtabl
do ortables
do drgnames
do pdgprtab
do propro
do prodg
do dgppro
do dgpdg
do ccpro
do komplist
do logiclis
do pro99S99
select logi_excl
use
select logi_apu
use
select rtc_apu
use
erase ('..\..\..\tabl_man\'+p_kieli+'\apu*.dbf')
erase ('..\..\..\tabl_man\'+p_kieli+'\apu*.cdx')
set safety on
select dg
set order to (lc_dgorder)
do dgdrglis
do tpdrglis
do _drglogi
return

procedure logiclis
select drglogic
set order to ord
goto top
do while not eof()
  do rivi
  select drglogic
  skip
enddo
return

procedure rivi
select dg
lc_dgord=order()
if drglogic.pdgprop<>' ' 
  lc_name='..\..\..\tabl_man\'+p_kieli+'\PD_'+trim(drglogic.pdgprop)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_pdgp with cdx
    select 0
    use ..\logi_pdgp
    set order to code
    append blank
    replace code with drglogic.pdgprop
    select dg
    set order to varval
    seek 'PDGPRO  '+ SUBSTR(drglogic.pdgprop,1,2)+SUBSTR(drglogic.pdgprop,4,2)+SUBSTR(drglogic.pdgprop,3,1)
    lc_n =0
    do while varval=drglogic.pdgprop and not eof()
      select logi_pdgp
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_pdgp(code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
    enddo
    select pdgomin
    seek trim(drglogic.pdgprop) 
    select logi_pdgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(pdgomin.english)+', n ='+str (lc_n,5,0)
    ? 'PDGP_'+drglogic.pdgprop+': number of codes ' +str (lc_n,5,0)
    select logi_pdgp
    copy to ('..\..\..\tabl_man\'+p_kieli+'\PD_' + trim(drglogic.pdgprop) + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*   do (lc_genhtml) with language.lan+'\manual\PD_'+trim(drglogic.pdgprop)+'.htm', 'logi_pdgp', .f., .f. , .f.
    use
  endif
endif

if drglogic.procpro1<>' ' 
  lc_name='..\..\..\tabl_man\'+p_kieli+'\PRO_'+trim(drglogic.procpro1)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_proc with cdx
    select 0
    use ..\logi_proc
    set order to code
    append blank
    replace code with drglogic.procpro1
    lc_n =0
    select drgtpt
    set order to varval
    seek 'PROCPR  '+drglogic.procpro1
    do while drglogic.procpro1=drgtpt.varval and not eof()
      insert into ..\logi_proc (code, name) values (drgtpt.code, csp.text)
      select logi_proc
      lc_n =lc_n+1
      select drgtpt
      skip
    enddo
    select dg
    goto top
	do while not eof()
	  if not vartype='PROCPR'
	    skip
	    loop
	  endif
	  if not drglogic.procpro1=dg.varval
	    skip
	    loop
	  endif
      select logi_proc
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_proc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
    enddo
    select tpomin
    seek trim(drglogic.procpro1) 
    select logi_proc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(tpomin.english)+', n ='+str (lc_n,5,0)
    ? 'PR_'+drglogic.procpro1+': Number of codes ' +str (lc_n,5,0)
    select logi_proc
    copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_' + trim(drglogic.procpro1) + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\PRO_'+trim(drglogic.procpro1)+'.htm', 'logi_proc', .f., .f. , .f.
    use
  endif
endif

if drglogic.procpro2<>' ' 
  lc_name='..\..\..\tabl_man\'+p_kieli+'\PRO_'+trim(drglogic.procpro2)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_proc with cdx
    select 0
    use ..\logi_proc
    set order to code
    append blank
    replace code with drglogic.procpro2
    lc_n =0
    select drgtpt
    set order to varval
    seek 'PROCPR  '+drglogic.procpro2
    do while drglogic.procpro2=drgtpt.varval and not eof()
      insert into ..\logi_proc (code, name) values (drgtpt.code, csp.text)
      lc_n =lc_n+1
      select drgtpt
      skip
    enddo
    select dg
	do while not eof()
	  if not vartype='PROCPR'
	    skip
	    loop
	  endif
	  if not drglogic.procpro2=dg.varval
	    skip
	    loop
	  endif
      select logi_proc
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_proc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
    enddo
    select tpomin
    seek trim(drglogic.procpro2) 
    select logi_proc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(tpomin.english)+', n ='+str (lc_n,5,0)
    ? 'PR_'+drglogic.procpro2+': Number of codes ' +str (lc_n,5,0)
    select logi_proc
    copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_' + trim(drglogic.procpro2) + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\PRO_'+trim(drglogic.procpro2)+'.htm', 'logi_proc', .f., .f. , .f.
    use
  endif
endif

if drglogic.procpro3<>' ' 
  lc_name='..\..\..\tabl_man\'+p_kieli+'\PRO_'+trim(drglogic.procpro3)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to logi_proc with cdx
    select 0
    use ..\logi_proc
    set order to code
    append blank
    replace code with drglogic.procpro3
    lc_n =0
    select drgtpt
    set order to varval
    seek 'PROCPR  '+drglogic.procpro3
    do while drglogic.procpro3=drgtpt.varval and not eof()
      insert into ..\logi_proc (code, name) values (drgtpt.code, csp.text)
      lc_n =lc_n+1
      select drgtpt
      skip
    enddo
    select dg
	do while not eof()
	  if not vartype='PROCPR'
	    skip
	    loop
	  endif
	  if not drglogic.procpro3=dg.varval
	    skip
	    loop
	  endif
      select logi_proc
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_proc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
    enddo
    select tpomin
    seek trim(drglogic.procpro3) 
    select logi_proc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(tpomin.english)+', n ='+str (lc_n,5,0)
    ? 'PR_'+drglogic.procpro3+': Number of codes ' +str (lc_n,5,0)
    select logi_proc
    copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_' + trim(drglogic.procpro3) + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\PRO_'+trim(drglogic.procpro3)+'.htm', 'logi_proc', .f., .f. , .f.
    use
  endif
endif

if drglogic.dgprop1<>' ' 
  if drglogic.dgprop1='-'
    lc_dgomin = substr(drglogic.dgprop1,2,5)
  else
    lc_dgomin =trim(drglogic.dgprop1)
  endif
  lc_name='..\..\..\tabl_man\'+p_kieli+'\DGP_'+trim(lc_dgomin)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_dgp with cdx
    select 0
    use ..\logi_dgp
    set order to code
    append blank
    replace code with lc_dgomin
    select dg
    set order to varval
    lc_n =0
    IF NOT SUBSTR(lc_dgomin,3,3)='X99'
     seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
     do while dg.varval=lc_dgomin
      select logi_dgp
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_dgp (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
     enddo
    ENDIF
    select drgtpt
    set order to varval
    seek 'DGPROP  '+lc_dgomin
    do while drgtpt.varval=lc_dgomin
      select logi_dgp
      lc_n =lc_n+1
      insert into ..\logi_dgp (code, name) values (drgtpt.code, csp.text)
      select drgtpt
      skip
    enddo
    select dgomin
    seek SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1)
    select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(dgomin.english)+', n ='+str (lc_n,5,0)
    ? 'DGP_'+drglogic.dgprop1+': Number of codes ' +str (lc_n,5,0)
    select logi_dgp
    copy to ('..\..\..\tabl_man\'+p_kieli+'\DGP_' + lc_dgomin + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\DGP_'+lc_dgomin+'.htm', 'logi_dgp', .f., .f. , .f.
    use
  endif
endif

if drglogic.dgprop2<>' ' 
  if drglogic.dgprop2='-'
    lc_dgomin = substr(drglogic.dgprop2,2,5)
  else
    lc_dgomin =trim(drglogic.dgprop2)
  endif
  lc_name='..\..\..\tabl_man\'+p_kieli+'\DGP_'+trim(lc_dgomin)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_dgp with cdx
    select 0
    use ..\logi_dgp
    set order to code
    append blank
    replace code with lc_dgomin
    select dg
    set order to varval
    lc_n =0
    IF NOT SUBSTR(lc_dgomin,3,3)='X99'
     seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
     do while dg.varval=lc_dgomin
      select logi_dgp
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_dgp (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
     enddo
    ENDIF
    select drgtpt
    set order to varval
    seek 'DGPROP  '+lc_dgomin
    do while drgtpt.varval=lc_dgomin
      select logi_dgp
      lc_n =lc_n+1
      insert into ..\logi_dgp (code, name) values (drgtpt.code, csp.text)
      select drgtpt
      skip
    enddo
    select dgomin
    seek SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1)
    select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(dgomin.english)+', n ='+str (lc_n,5,0)
    ? 'DGP_'+drglogic.dgprop2+': Number of codes ' +str (lc_n,5,0)
    select logi_dgp
    copy to ('..\..\..\tabl_man\'+p_kieli+'\DGP_' + lc_dgomin + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\DGP_'+lc_dgomin+'.htm', 'logi_dgp', .f., .f. , .f.
    use
  endif
endif

if drglogic.dgprop3<>' ' 
  if drglogic.dgprop3='-'
    lc_dgomin = substr(drglogic.dgprop3,2,5)
  else
    lc_dgomin =trim(drglogic.dgprop3)
  endif
  lc_name='..\..\..\tabl_man\'+p_kieli+'\DGP_'+trim(lc_dgomin)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_dgp with cdx
    select 0
    use ..\logi_dgp
    set order to code
    append blank
    replace code with lc_dgomin
    select dg
    set order to varval
    lc_n =0
    IF NOT SUBSTR(lc_dgomin,3,3)='X99'
     seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
     do while dg.varval=lc_dgomin
      select logi_dgp
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_dgp (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
     enddo
    ENDIF
    select drgtpt
    set order to varval
    seek 'DGPROP  '+lc_dgomin
    do while drgtpt.varval=lc_dgomin
      select logi_dgp
      lc_n =lc_n+1
      insert into ..\logi_dgp (code, name) values (drgtpt.code, csp.text)
      select drgtpt
      skip
    enddo
    select dgomin
    seek SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1)
    select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(dgomin.english)+', n ='+str (lc_n,5,0)
    ? 'DGP_'+drglogic.dgprop3+': Number of codes ' +str (lc_n,5,0)
    select logi_dgp
    copy to ('..\..\..\tabl_man\'+p_kieli+'\DGP_' + lc_dgomin + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\DGP_'+lc_dgomin+'.htm', 'logi_dgp', .f., .f. , .f.
    use
  endif
endif

if drglogic.dgprop4<>' ' 
  if drglogic.dgprop4='-'
    lc_dgomin = substr(drglogic.dgprop4,2,5)
  else
    lc_dgomin =trim(drglogic.dgprop4)
  endif
  lc_name='..\..\..\tabl_man\'+p_kieli+'\DGP_'+trim(lc_dgomin)
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_dgp with cdx
    select 0
    use ..\logi_dgp
    set order to code
    append blank
    replace code with lc_dgomin
    select dg
    set order to varval   
    lc_n =0
    IF NOT SUBSTR(lc_dgomin,3,3)='X99'
     seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
     do while dg.varval=lc_dgomin
      select logi_dgp
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_dgp (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
      endif
      select dg
      skip
     enddo
    ENDIF
    select drgtpt
    set order to varval
    seek 'DGPROP  '+lc_dgomin
    do while drgtpt.varval=lc_dgomin
      select logi_dgp
      lc_n =lc_n+1
      insert into ..\logi_dgp (code, name) values (drgtpt.code, csp.text)
      select drgtpt
      skip
    enddo
    select dgomin
    seek SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1)
    select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(dgomin.english)+', n ='+str (lc_n,5,0)
    ? 'DGP_'+drglogic.dgprop4+': Number of codes ' +str (lc_n,5,0)
    select logi_dgp
    copy to ('..\..\..\tabl_man\'+p_kieli+'\DGP_' + lc_dgomin + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\DGP_'+lc_dgomin+'.htm', 'logi_dgp', .f., .f. , .f.
    use
  endif
endif

if drglogic.secproc1<>' ' and drglogic.secproc1<>'+ '
  if drglogic.secproc1='-'
    lc_tpomin = substr(drglogic.secproc1,2,5)
  else
    lc_tpomin = trim(drglogic.secproc1) 
  endif
  lc_name='..\..\..\tabl_man\'+p_kieli+'\PRO_'+lc_tpomin
  if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_proc with cdx
    select 0
    use ..\logi_proc
    set order to code
    append blank
    replace code with lc_tpomin
    lc_n =0
    select drgtpt
    set order to varval
    seek 'PROCPR  '+lc_tpomin
    do while lc_tpomin =drgtpt.varval and not eof()
      insert into ..\logi_proc (code, name) values (drgtpt.code, csp.text)
      lc_n =lc_n+1
      select drgtpt
      skip
    enddo
    select dg
    set order to varval
    seek 'PROCPR  '+substr(lc_tpomin,1,2)+SUBSTR(lc_tpomin,4,2)+SUBSTR(lc_tpomin,3,1)
    do while lc_tpomin =dg.varval and not eof()
      select logi_proc
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        insert into ..\logi_proc (code, name) values (dg.code+icd_10.ast+dg.d_code,icd_10.text)
      endif
      select dg
      skip
    enddo
    select tpomin
    seek trim(lc_tpomin)
    select logi_proc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(tpomin.english)+', n ='+str (lc_n,5,0)
    ? 'PR_'+lc_tpomin+': Number of codes ' +str (lc_n,5,0)
    select logi_proc
    copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_' + lc_tpomin + '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\PRO_'+lc_tpomin+'.htm', 'logi_proc', .f., .f. , .f.
    use
  endif
endif

if drglogic.rtc<>'0'
  lc_name='..\..\..\tabl_man\'+p_kieli+'\RT_'+trim(drglogic.drg)+'_'+trim(drglogic.rtc)
  if not file(lc_name+'.txt')
    select rtc_apu
    delete all
    pack
    select drgnames
    seek drglogic.drg
    insert into ..\rtc_apu (drg, name) values (drglogic.drg, drgnames.drgname)
    select rtc_apu
    select rtc
    insert into ..\rtc_apu (rtc, name) values (rtc.code, rtc.eng)
    select rtc_apu
    copy to (lc_name+'.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\RT_'+trim(drglogic.drg)+'_'+trim(drglogic.rtc)+'.htm', 'rtc_apu', .f., .f. , .f.
  endif
endif
select dg
set order to (lc_dgord)
return

Procedure komplist
select kompkat
set order to compl
goto top
skip
do while not eof()
  select icd_10
  set filter to not deleted()
  set order to code
  select dg
  set relation to code+d_code into icd_10
  do complis
  if kompkat.inclprop<>' '
    do inprolis
  endif
  select komplex
  set filter to valid 
  set relation to code+d_code into icd_10
  do cexlis
  select kompkat
  skip
enddo
select dg
set relation to code+d_code into icd_10
return

procedure inprolis
lc_dgomin =trim(kompkat.inclprop)
lc_name='..\..\..\tabl_man\'+p_kieli+'\DGP_'+trim(lc_dgomin)
if not file(lc_name+'.txt')
  select logi_apu
  copy next 0 to ..\logi_dgp with cdx
  select 0
  use ..\logi_dgp
  set order to code
  append blank
  replace code with lc_dgomin
  lc_n =0
  select dg
  set order to varval
  lc_n =0
  seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
  do while dg.varval=lc_dgomin
    select logi_dgp
    seek dg.code+dg.d_code
    if not found()
      lc_n =lc_n+1
      insert into ..\logi_dgp (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
    endif
    select dg
    skip
  enddo
  select drgtpt
  set order to varval
  seek 'DGPROP  '+lc_dgomin
  do while drgtpt.varval=lc_dgomin
    select logi_dgp
    lc_n =lc_n+1
    insert into ..\logi_dgp (code, name) values (drgtpt.code, csp.text)
    select drgtpt
    skip
  enddo
  select dgomin
  seek SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1)
  select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
  goto top
  replace name with trim(dgomin.english)+', n ='+str (lc_n,5,0)
  ? 'DGP_'+drglogic.dgprop1+': Number of codes ' +str (lc_n,5,0)
  select logi_dgp
  copy to ('..\..\..\tabl_man\'+p_kieli+'\DGP_' + lc_dgomin +  '.txt') DELIMITED WITH '"' WITH CHAR ';'
*  do (lc_genhtml) with language.lan+'\manual\DGP_'+lc_dgomin+'.htm', 'logi_dgp', .f., .f. , .f.
  use
endif
return

procedure complis
lc_compl=trim(kompkat.compl)
lc_name='..\..\..\tabl_man\'+p_kieli+'\CC_'+trim(lc_compl)
if not file(lc_name+'.txt')
    select logi_apu
    copy next 0 to ..\logi_cc with cdx
    select 0
    use ..\logi_cc
    set order to code
    append blank
    replace code with lc_compl
    lc_n =0
    lc_code=' '
    select dg
    set order to varval
    seek 'COMPL   '+substr(lc_compl,1,2)+substr(lc_compl,4,2)
    do while substr(dg.varval,1,2)+substr(dg.varval,4,2)=substr(lc_compl,1,2)+substr(lc_compl,4,2) and not eof()
      lc_ast=.f.
      if substr(dg.varval,3,1)<>substr(lc_compl,3,1)
        if eof()
          exit
        endif
        skip
        loop
      endif
      select logi_cc
      seek dg.code+dg.d_code
      if not found()
        lc_n =lc_n+1
        select icd_10
        seek (dg.code+dg.d_code)
        if not found()
          select logi_cc
          seek dg.code
          if not found()
            select icd_10
            seek dg.code
            insert into ..\logi_cc (code, name) values (dg.code, trim(icd_10.text)+';---')
          endif
          seek dg.d_code
          lc_ast=.t.
        endif
        lc_code=dg.code
        if lc_ast
          insert into ..\logi_cc (code, name) values (dg.code+icd_10.ast+dg.d_code, '---; '+icd_10.text)
        else
          insert into ..\logi_cc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
        endif
      endif
      select dg
      skip
    enddo
    select logi_cc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
    goto top
    replace name with trim(kompkat.english)+', n ='+str (lc_n,5,0)
    ? 'CC_'+kompkat.compl+': Number of codes ' +str (lc_n,5,0)
    select logi_cc
    copy to ('..\..\..\tabl_man\'+p_kieli+'\CC_' + trim(kompkat.compl) +  '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\CC_'+trim(kompkat.compl)+'.htm', 'logi_cc', .f., .f. , .f.
    use
endif
return

procedure cexlis
lc_complis=trim(kompkat.compl)
if substr(lc_complis,3,1)='I'
   lc_complis=substr(lc_complis,1,2)+'C'+substr(lc_complis,4,2)
endif
lc_name='..\..\..\tabl_man\'+p_kieli+'\CEX_'+lc_complis+'.txt'
if not file(lc_name)
    select logi_apu
    copy next 0 to ..\logi_cex with cdx
    select 0
    use ..\logi_cex
    set order to code
    append blank
    replace code with kompkat.compl
    lc_n = 0
    lc_code=' '
    select komplex
    set order to compl
    lc_kat=substr(kompkat.compl,1,2)+substr(kompkat.compl,4,2)
    seek lc_kat
    do while substr(kompkat.compl,1,2)+substr(kompkat.compl,4,2)=lc_kat and not eof()
      lc_ast=.f.
      if lc_complis<>komplex.compl
        select komplex
        skip
        loop
      endif
      select logi_cex
      seek komplex.code+komplex.d_code
      if not found()
        lc_n =lc_n+1
        select icd_10
        seek (komplex.code+komplex.d_code)
        if not found()
          select logi_cex
          seek komplex.code
          if not found()
            select icd_10
            seek komplex.code
            insert into ..\logi_cex (code, name) values (komplex.code, trim(icd_10.text)+';---')
          endif
          seek komplex.d_code
          lc_ast=.t.
        endif
        lc_code=komplex.code
        if lc_ast
          insert into ..\logi_cex (code, name) values (komplex.code+icd_10.ast+komplex.d_code, '---; '+icd_10.text)
        else
          insert into ..\logi_cex (code, name) values (komplex.code+icd_10.ast+komplex.d_code, icd_10.text)
        endif
      endif
      select komplex
      skip
    enddo
    select logi_cex
     if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
   goto top
    replace name with 'Diagnosis not complicated by compl. cat. '+trim(kompkat.english)+', n ='+str (lc_n,5,0)
    ? 'CEX_'+lc_complis+': Number of codes ' +str (lc_n,5,0)
    select logi_cex
    copy to ('..\..\..\tabl_man\'+p_kieli+'\CEX_' + lc_complis +  '.txt') DELIMITED WITH '"' WITH CHAR ';'
*    do (lc_genhtml) with language.lan+'\manual\CEX_'+lc_complis+'.htm', 'logi_cex', .f., .f. , .f.
    use
endif
return

Procedure dgcatego
select dgkat
set order to dgcat
goto top
do while not eof()
  if dgcat=' '
    skip
    loop
  endif
  if dgcat='00 '
    skip
    loop
  endif
  if len(trim(dgcat))=2
    lc_name='..\..\..\tabl_man\'+p_kieli+'\MDC_'+trim(dgcat)
    if not file(lc_name+'.txt')
      select logi_apu
      copy next 0 to ..\logi_mdc with cdx
      select 0
      use ..\logi_mdc
      set order to code
      append blank
      replace code with dgkat.dgcat
      select dg 
      set order to varval
      seek 'DGCAT   '+trim((dgkat.dgcat))
      lc_n =0
      do while substr(varval,1,2)=trim(dgkat.dgcat) and not eof() 
      select logi_mdc
      lc_ast=.f.
        seek dg.code+dg.d_code
        if not found()
          lc_n =lc_n+1
          select icd_10
          seek (dg.code+dg.d_code)
          if not found()
            if lc_code<>dg.code
              seek dg.code
              insert into ..\logi_mdc (code, name) values (dg.code, trim(icd_10.text)+';---')
            endif
            seek dg.d_code
            lc_ast=.t.
          endif
          lc_code=dg.code
          if lc_ast
            insert into ..\logi_mdc (code, name) values (dg.code+icd_10.ast+dg.d_code, '---; '+icd_10.text)
          else
            insert into ..\logi_mdc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
          endif
        endif
        select dg
        skip
      enddo
      if dgkat.dgcat='12' or dgkat.dgcat='13'
        seek 'DGCAT   98'
        do while substr(varval,1,2)='98' 
          select logi_mdc
          lc_ast=.f.
          seek dg.code+dg.d_code
          if not found()
            lc_n =lc_n+1
            select icd_10
            seek (dg.code+dg.d_code)
            if not found()
              if lc_code<>code
                seek dg.code
                insert into ..\logi_mdc (code, name) values (dg.code, trim(icd_10.text)+';---')
              endif
              seek dg.d_code
              lc_ast=.t.
            endif
            lc_code=dg.code
            if lc_ast
              insert into ..\logi_mdc (code, name) values (dg.code+icd_10.ast+dg.d_code, '---; '+icd_10.text)
            else
              insert into ..\logi_mdc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
            endif
          endif
          select dg
          skip
        enddo
      endif
      select logi_mdc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
      goto top
      replace name with trim(dgkat.english)+', n ='+str (lc_n,5,0)
      ? 'MDC - '+dgkat.dgcat+': number of codes ' +str (lc_n,5,0)
      select logi_mdc
      copy to ('..\..\..\tabl_man\'+p_kieli+'\MDC_' + trim(dgkat.dgcat) +  '.txt') DELIMITED WITH '"' WITH CHAR ';'
      copy to ('..\..\..\tabl_man\'+p_kieli+'\DGP_' + trim(dgkat.dgcat) +  'X99.txt') DELIMITED WITH '"' WITH CHAR ';'
*      do (lc_genhtml) with language.lan+'\manual\MDC_'+trim(dgkat.dgcat)+'.htm', 'logi_mdc', .f., .f. , .f.
      use
    endif
  else
    lc_name='..\..\..\tabl_man\'+p_kieli+'\DGC_'+trim(dgcat)
    if not file(lc_name+'.txt')
      select logi_apu
      copy next 0 to ..\logi_dgc with cdx
      select 0
      use ..\logi_dgc
      set order to code
      append blank
      replace code with dgkat.dgcat
      lc_n =0
      select dg
      set order to varval
      lc_kat=trim(dgkat.dgcat)
      seek 'DGCAT   '+substr(lc_kat,1,2)+substr(lc_kat,4,2)
      do while dg.varval=lc_kat and not eof()
        select logi_dgc
        lc_ast=.f.
        seek dg.code+dg.d_code
        if not found()
          lc_n =lc_n+1
          select icd_10
          seek (dg.code+dg.d_code)
          if not found()
            if lc_code<>dg.code
              seek dg.code
              insert into ..\logi_dgc (code, name) values (dg.code, trim(icd_10.text)+';---')
            endif
            seek dg.d_code
            lc_ast=.t.
          endif
          lc_code=dg.code
          if lc_ast
            insert into ..\logi_dgc (code, name) values (dg.code+icd_10.ast+dg.d_code, '---; '+icd_10.text)
          else
            insert into ..\logi_dgc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
          endif
        endif
        select dg
        skip
      enddo
      if substr(lc_kat,1,2)='12' or substr(lc_kat,1,2)='13'
        lc_kat='98'+substr(lc_kat,3,3)
        seek 'DGCAT   '+substr(lc_kat,1,2)+substr(lc_kat,4,2)
        do while dg.varval=lc_kat and not eof()
          select logi_dgc
          lc_ast=.f.
          seek dg.code+dg.d_code
          if not found()
            lc_n =lc_n+1
            select icd_10
            seek (dg.code+dg.d_code)
            if not found()
              if lc_code<>dg.code
                seek code
                insert into ..\logi_dgc (code, name) values (dg.code, trim(icd_10.text)+';---')
              endif
              seek dg.d_code
              lc_ast=.t.
            endif
            lc_code=dg.code
            if lc_ast
              insert into ..\logi_dgc (code, name) values (dg.code+icd_10.ast+dg.d_code, '---; '+icd_10.text)
            else
              insert into ..\logi_dgc (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
            endif
          endif
          select dg
          skip
        enddo
      endif
      select logi_dgc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
      goto top
      replace name with trim(dgkat.english)+', n ='+str (lc_n,5,0)
      ? 'DGC_'+dgkat.dgcat+': Number of codes ' +str (lc_n,5,0)
      select logi_dgc
      copy to ('..\..\..\tabl_man\'+p_kieli+'\DGC_' + trim(dgkat.dgcat) +  '.txt') DELIMITED WITH '"' WITH CHAR ';'
*      do (lc_genhtml) with language.lan+'\manual\DGC_'+trim(dgkat.dgcat)+'.htm', 'logi_dgc', .f., .f. , .f.
      use
    endif
  endif
  
  select dgkat
  skip
enddo
return

procedure tpomtabl
lc_name='..\..\..\tabl_man\'+p_kieli+'\tpomin.txt'
select logi_apu
copy next 0 to ..\apu_tp fields code, name
select 0
use ..\apu_tp alias siiromin
goto top
do while not eof()
  select siiromin
  append blank
  replace code with tpomin.procprop
  replace name with tpomin.english
  select tpomin
  skip
enddo
select siiromin
copy to (lc_name)  DELIMITED WITH '"' WITH CHAR ';'
use
return

procedure dgomtabl
lc_name='..\..\..\tabl_man\'+p_kieli+'\dgomin.txt'
select logi_APU
copy next 0 to ..\apu_dg fields code, name
select 0
use ..\apu_dg alias siiromin
select dgomin
goto top
do while not eof()
  select siiromin
  append blank
  replace code with dgomin.dgprop
  replace name with dgomin.english
  select dgomin
  skip
enddo
select siiromin
copy to (lc_name) DELIMITED WITH '"' WITH CHAR ';'
use
return

Procedure ortables
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_OR_0'
select logi_apu
copy next 0 to (lc_name+'.dbf')fields code, name, prop
select 0
use (lc_name+'.dbf') alias log_or0
append blank
replace code with 'OR=0'
lc_or0=0

lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_OR_1'
select logi_apu
copy next 0 to (lc_name+'.dbf') fields code, name, prop
select 0
use (lc_name+'.dbf') alias log_or1
append blank
replace code with 'OR=1'
lc_or1=0

lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_OR_2'
select logi_apu
copy next 0 to (lc_name+'.dbf') fields code, name, prop
select 0
use (lc_name+'.dbf') alias log_or2
append blank
replace code with 'OR=2'
lc_or2=0

select drgtpt
set filter to valid
set order to code
goto top
lc_code=code
lc_or='0'
lc_proc=.f.
do while not eof()
  if vartype='OR' and varval='1'
    lc_or='1'
  endif
  if vartype='OR' and varval='2' and lc_or='0'
    lc_or='2'
  endif
  if vartype='PROCPR' and varval<>' '
    lc_proc=.t.
  endif
  select drgtpt
  skip
  if code<>lc_code
    do case
    case lc_or='0' 
      skip -1
      insert into log_or0 (code, name) values (drgtpt.code, csp.text)
      select log_or0
      if lc_proc 
      	replace prop with 'Y'
      else
        replace prop with 'N'
      endif
      lc_or0=lc_or0+1
      select drgtpt
      skip
    case lc_or='1'
      skip -1
      insert into log_or1 (code, name) values (drgtpt.code, csp.text)
      select log_or1
      if lc_proc 
      	replace prop with 'Y'
      else
        replace prop with 'N'
      endif
      lc_or1=lc_or1+1
      select drgtpt
      skip
    case lc_or='2' 
      skip -1
      insert into log_or2 (code, name) values ( drgtpt.code, csp.text)
      select log_or2
      if lc_proc 
      	replace prop with 'Y'
      else
        replace prop with 'N'
      endif
      lc_or2=lc_or2+1
      select drgtpt
      skip
    endcase
    lc_code=code
    lc_proc=.f.
    lc_or='0'
  endif
enddo

select log_or0
    if lc_or0=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Proc. without OR-property, n ='+str(lc_or0,5,0)
copy to ('..\..\..\tabl_man\'+p_kieli+'\OR_0.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\NoOR_PRO.htm', 'log_noor', .f., .f. , .f.
use

select log_or1
    if lc_or1=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Surgical and comprable procedures, n ='+str(lc_or1,5,0)
copy to ('..\..\..\tabl_man\'+p_kieli+'\OR_1.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\NoPR_PRO.htm', 'log_nopr', .f., .f. , .f.
use

select log_or2
    if lc_or2=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Proc. significant for short therapy DRG rules only, n ='+str(lc_or2,5,0)
copy to ('..\..\..\tabl_man\'+p_kieli+'\OR_2.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\NoNo_PRO.htm', 'log_nono', .f., .f. , .f.
use

lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_ORDG.dbf'
select logi_apu
copy next 0 to (lc_name) with cdx
select 0
use (lc_name) alias logi_or
set order to code
append blank
replace code with '1'
lc_n=0
select dg
set order to varval
seek 'OR'
do while dg.vartype='OR' and not eof()
  select logi_or 
  lc_ast=.f.
  seek dg.code+dg.d_code
  if not found()
    lc_n =lc_n+1
    select icd_10
    seek (dg.code+dg.d_code)
    if not found()
      if lc_code<>dg.code
        seek dg.code
        insert into logi_or (code, name); 
        values (dg.code, trim(icd_10.text)+';---')
      endif
      seek dg.d_code
      lc_ast=.t.
    endif
    lc_code=dg.code
    if lc_ast
      insert into logi_or (code, name) values (dg.code+icd_10.ast+dg.d_code, '---; '+icd_10.text)
    else
      insert into logi_or (code, name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text)
    endif
  endif
  select dg
  skip
enddo
select logi_or
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnoses with operation room procedure property, n ='+str(lc_n,5,0)
? 'OR_DG: Number of codes ' +str (lc_n,5,0)
select logi_or
copy to ('..\..\..\tabl_man\'+p_kieli+'\or_dg.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\OR_DG.htm', 'logi_or', .f., .f. , .f.
use
return

procedure drgnames
select 0
use ..\drg_str
delete all
pack
append blank
select drgnames
goto top
lc_str='  '
lc_name=' '
lc_drgn=0
? 'Producing single DRG-name files'
do while not eof()
  lc_drgn=lc_drgn+1
  if int(lc_drgn/10)*10=lc_drgn
    ? drgnames.loc_drg + ' '+drgnames.drgname
  endif
  select drg_str
  delete all
  pack
  insert into drg_str (drg, mdc, name) values (drgnames.loc_drg, drgnames.mdc, drgnames.drgname)
  append blank
  if p_kieli<>'Com'
    select nam_oth
    use ('..\..\tabl_def\com\drgnames') alias nam_oth
    set order to drg
    seek drgnames.drg
    if found()
      insert into drg_str (drg, name) values (nam_oth.loc_drg, nam_oth.drgname)
    endif
  endif
  select language
  goto top
  skip
  do while not eof()
    select nam_oth
    if language.lan<>p_kieli and language.lan<>'Eng'
       use ('..\..\tabl_def\'+language.lan+'\drgnames') alias nam_oth
       set order to drg
       seek drgnames.drg
       if found()
         insert into drg_str (drg, name) values (nam_oth.loc_drg, nam_oth.drgname)
       endif
    endif
    select language
    skip
  enddo
  lc_drg=ltrim(rtrim(drgnames.drg))
  if substr(lc_drg,4,1)='X'
    lc_drg=substr(lc_drg,1,3)+substr(lc_drg,5,2)
  endif
  select drg_str
  copy to ('..\..\..\tabl_man\'+p_kieli+'\DRG_'+lc_drg+'.txt') DELIMITED WITH '"' WITH CHAR ';'
*  do (lc_genhtml) with language.lan+'\manual\DRG_'+ltrim(rtrim(drgnames.drg))+'.htm', 'drg_str', .f., .f. , .f.
  select drgnames
  skip
enddo
*? 'Producing MDC-DRG lists'
*select drg_str
*set order to drg
*delete all
*pack
*append blank
*select drglogic
*goto top
*lc_str='  '
*lc_name=' '
*lc_loop=.t.
*do while lc_loop
*  if ord='00' or ord='90'
*    if ord<>lc_str
*      if lc_name<>' '
*        select drg_str
*        copy to ('..\..\..\tabl_man\'+p_kieli+'\DRG_'+lc_str+'.txt') DELIMITED WITH '"' WITH CHAR ';'
**        do (lc_genhtml) with language.lan+'\manual\DRG_'+lc_str+'.htm', 'drg_str', .f., .f. , .f.
*      endif
*      select drglogic
*      lc_str=substr(ord,1,5)
*      lc_name='..\..\..\tabl_man\'+p_kieli+'\DRG_'+lc_str+'.htm'
*      select drg_str
*      delete all
*      pack
*    endif
*  else
*    if ord<>lc_str
*      if lc_name<>' '
*        select drg_str
*        copy to ('..\..\..\tabl_man\'+p_kieli+'\DRG_'+lc_str+'.txt') DELIMITED WITH '"' WITH CHAR ';'
**        do (lc_genhtml) with language.lan+'\manual\DRG_'+lc_str+'.htm', 'drg_str', .f., .f. , .f.
*      endif
*      select drglogic
*      lc_str=substr(ord,1,3)
*      lc_name='..\..\tabl_man\'+p_kieli+'\manual\DRG_'+lc_str+'.htm'
*      select drg_str
*      delete all
*      pack
*    endif
*  endif
*  select drg_str
*  seek substr(drgnames.loc_drg,1,4)
*  if not found()
*    append blank
*    replace drg with drgnames.loc_drg, mdc with drgnames.mdc, name with drgnames.drgname 
*  endif
*  select drglogic
*  if eof()
*    exit
*  endif
*  skip
*enddo
return

procedure dgcyhd
? 'DGC_YHD'
select dgkat
set order to dgcat
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_DGCY.dbf'
select logi_excl
copy next 0 to ..\apu_excl with cdx
select 0
use ..\apu_excl alias logi_dgc
set order to code
lc_n=0
lc_code='    '
select dg
set relation to
goto top
do while not eof()
  if not trim(dg.vartype)='DGCAT'
    skip
    loop
  endif
  if varval='00'
    skip
    loop
  endif
  select logi_dgc
  seek dg.code+dg.d_code
  if not found()
    lc_n=lc_n+1
    select dgkat
    seek (SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2))
    select icd_10
    lc_ast=.f.
    seek (dg.code+dg.d_code)
    if not found()
      if lc_code<>dg.code
        seek code
        insert into logi_dgc (code, name) values (dg.code, trim(icd_10.text)+';---')
      endif
      seek dg.d_code
      lc_ast=.t.
    endif
    lc_code=dg.code
    if lc_ast
      insert into logi_dgc (code, name, property, pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code, '---; '+icd_10.text, dg.varval, dgkat.english)
      insert into logi_dgc (code, name, property, pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code, '---; '+icd_10.text, dg.varval, dgkat.english)
    else
      insert into logi_dgc (code, name, property,pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code,icd_10.text, dg.varval, dgkat.english)
    endif
    select logi_dgc
*    do case
*    case p_kieli='Fin'
*      replace pro_name with dgkat.finish
*    endcase
  endif
  select dg
  skip
enddo
select logi_dgc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
? 'DGC_YHD: Number of codes ' +str (lc_n,5,0)
select logi_dgc
copy next 0 to (lc_name) fields code, name
select 0
use (lc_name) alias apu
append blank
replace  name with 'Diagnoses with Diagnosis categories(DGCAT), n ='+str(lc_n,5,0)
select logi_dgc
lc_prop=' '
lc_n=0
goto top
do while not eof()
  if logi_dgc.property<>lc_prop or lc_n>9
    INSERT INTO apu (code, name) VALUES (logi_dgc.property, logi_dgc.pro_name)
    lc_n=0
  endif
  lc_prop=logi_dgc.property
  INSERT INTO apu (code, name) VALUES (logi_dgc.code, logi_dgc.name)
  lc_n=lc_n+1
  select logi_dgc
  skip
enddo
select apu
copy to ('..\..\..\tabl_man\'+p_kieli+'\dgc_yhd.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\DGC_YHD.htm', 'apu', .f., .f. , .f.
use
select logi_dgc
use
return

procedure pdgprtab
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_PDGP.dbf'
select logi_excl
copy next 0 to (lc_name) with cdx
select 0
use (lc_name) alias logi_pdg
set order to code
append blank
lc_n=0
select dg
set order to varval
seek 'PDGPRO'
do while trim(dg.vartype)='PDGPRO' and not eof()
  select logi_pdg
  lc_n=lc_n+1
  select pdgomin
  seek dg.varval
    select icd_10
    lc_ast=.f.
    seek (dg.code+dg.d_code)
    if not found()
      if lc_code<>dg.code
        seek code
        insert into logi_pdg (code, name) values (dg.code, trim(icd_10.text)+';---')
      endif
      seek dg.d_code
      lc_ast=.t.
    endif
    lc_code=dg.code
    if lc_ast
      insert into logi_pdg (code, name, property, pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code, '---; '+icd_10.text, dg.varval, pdgomin.english)
    else
      insert into logi_pdg (code, name, property,pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code,icd_10.text, dg.varval, pdgomin.english)
    endif
  insert into logi_pdg (code, name, property, pro_name); 
  values (dg.code+icd_10.ast+dg.d_code, icd_10.text, dg.varval, pdgomin.english)
*  if lc_n=200
*    exit
*  endif
  select dg
  skip
enddo
select logi_pdg
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnoses with principal diagnosis property, n ='+str(lc_n,5,0)
? 'PDGPRO: Number of codes ' +str (lc_n,5,0)
select logi_pdg
copy to ('..\..\..\tabl_man\'+p_kieli+'\pdgpro.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\PDGPRO.htm', 'logi_pdg', .f., .f. , .f.
use
return

procedure propro
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_PRPR.dbf'
select logi_excl
copy next 0 to (lc_name) fields code, property, name
select 0
use (lc_name) alias logi_pro
append blank
lc_n=0
select drgtpt
set order to code
set filter to valid
goto top
lc_code=' '
do while not eof()
  if trim(vartype) <> 'PROCPR'
    skip
    loop
  endif
  if drgtpt.code<>lc_code
    insert into logi_pro (code, name) values ( drgtpt.code, csp.text)
    lc_code=drgtpt.code
  endif
  select tpomin
  seek drgtpt.varval
  insert into logi_pro (property, name) values (drgtpt.varval,tpomin.english)
  select logi_pro
  lc_n=lc_n+1
*  if lc_n=200
*    exit
*  endif
  select drgtpt
  skip
enddo
select logi_pro
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Procedure codes with procedure properties, n ='+str(lc_n,5,0)
? 'PRO_PRO: Number of codes ' +str (lc_n,5,0)
select logi_pro
copy to ('..\..\..\tabl_man\'+p_kieli+'\pro_pro.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\PRO_PRO.htm', 'logi_pro', .f., .f. , .f.
use
return

procedure prodg
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_PRDG.dbf'
select logi_excl
copy next 0 to (lc_name) with cdx
select 0
use (lc_name) alias logi_pro
set order to code
append blank
lc_n=0
select dg
set order to varval
seek 'PROCPR'
do while dg.vartype='PROCPR' and not eof()
  select logi_pro 
  lc_ast=.f.
  seek dg.code+dg.d_code
  if not found()
    lc_n =lc_n+1
    select icd_10
    seek (dg.code+dg.d_code)
    if not found()
      if lc_code<>dg.code
        seek dg.code
        insert into logi_pro (code, name); 
        values (dg.code, trim(icd_10.text)+';---')
      endif
      seek dg.d_code
      lc_ast=.t.
    endif
    lc_code=dg.code
    select tpomin
    seek trim(dg.varval)
    if lc_ast
      insert into logi_pro (code, name, property, pro_name) values (dg.code+icd_10.ast+dg.d_code,'---;'+icd_10.text, dg.varval,tpomin.english)
    else
      insert into logi_pro (code, name, property, pro_name) values (dg.code+icd_10.ast+dg.d_code, icd_10.text, dg.varval,tpomin.english)
    endif
  endif
  select dg
  skip
enddo
select logi_pro
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnosis codes with procedure properties, n ='+str(lc_n,5,0)
? 'PRO_DG: Number of codes ' +str (lc_n,5,0)
select logi_pro
copy to ('..\..\..\tabl_man\'+p_kieli+'\pro_dg.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\PRO_DG.htm', 'logi_pro', .f., .f. , .f.
use
return

procedure dgppro
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_DGPR.dbf'
select logi_excl
copy next 0 to (lc_name) with cdx
select 0
use (lc_name) alias logi_dgp
set order to code
append blank
lc_n=0
select drgtpt
set order to varval
seek 'DGPRO'
do while trim(drgtpt.vartype)='DGPRO' and not eof()
  select dgomin
  seek (SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2))
  insert into logi_dgp (code, name, property, pro_name) values (drgtpt.code, csp.text, drgtpt.varval,dgomin.english)
  lc_n=lc_n+1
  select drgtpt
  skip
enddo
select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Procedure codes with diagnosis properties, n ='+str(lc_n,5,0)
? 'DGP_PRO: Number of codes ' +str (lc_n,5,0)
select logi_dgp
copy to ('..\..\..\tabl_man\'+p_kieli+'\dgp_pro.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\DGP_PRO.htm', 'logi_dgp', .f., .f. , .f.
use
return

procedure dgpdg
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_DGP.dbf'
select logi_excl
copy next 0 to (lc_name) with cdx
select 0
use (lc_name) alias logi_dgp
set order to code
append blank
lc_n=0
select dg
set order to varval
set relation to
seek 'DGPRO'
do while dg.vartype='DGPRO' and not eof()
  select logi_dgp
  seek dg.code+dg.d_code
  if not found()
    lc_n=lc_n+1
    select dgomin
    seek (SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2))
    select icd_10
    lc_ast=.f.
    seek (dg.code+dg.d_code)
    if not found()
      if lc_code<>dg.code
        seek code
        insert into logi_dgp (code, name); 
        values (dg.code, trim(icd_10.text)+';---')
      endif
      seek dg.d_code
      lc_ast=.t.
    endif
    lc_code=dg.code
    if lc_ast
      insert into logi_dgp (code, name, property, pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code, '---; '+icd_10.text, dg.varval, dgomin.english)
    else
      insert into logi_dgp (code, name, property,pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code,icd_10.text, dg.varval, dgomin.english)
    endif
  endif
*  if lc_n=200
*    exit
*  endif
  select dg
  skip
enddo
select logi_dgp
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnosis codes with diagnosis properties, n ='+str(lc_n,5,0)
? 'DGP_DG: Number of codes ' +str (lc_n,5,0)
select logi_dgp
copy to ('..\..\..\tabl_man\'+p_kieli+'\dgp_dg.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\DGP_DG.htm', 'logi_dgp', .f., .f. , .f.
use
return

procedure ccpro
? 'Procedures with CC-property'
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_CCPR.dbf'
select logi_excl
copy next 0 to ..\logi_cc fields code, name
select 0
use ..\logi_cc
append blank
lc_n=0
select drgtpt
goto top
do while not eof()
  if not ('1'=trim(drgtpt.varval) and drgtpt.vartype='CC')
    skip
    loop
  endif
  insert into ..\logi_cc (code,  name) values (drgtpt.code, csp.text)
  lc_n=lc_n+1
  select drgtpt
  skip
enddo
select logi_cc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Procedure codes belonging to CC-categories, n ='+str(lc_n,5,0)
? 'CC_PRO: Number of codes ' +str (lc_n,5,0)
select logi_cc
copy to ('..\..\..\tabl_man\'+p_kieli+'\cc_pro.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\CC_PRO.htm', 'logi_cc', .f., .f. , .f.
use
return

procedure ccdg
? 'Diagnosis with and without CC-category'
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_CC.dbf'
select logi_excl
copy next 0 to (lc_name) fields code, name
select 0
use (lc_name) alias logi_cc
append blank
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_CCA.dbf'
select logi_excl
copy next 0 to (lc_name)
select 0
use (lc_name) alias logi_cca
append blank
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_CCI.dbf'
select logi_excl
copy next 0 to (lc_name)
select 0
use (lc_name) alias logi_cci
append blank
lc_name='..\..\..\tabl_man\'+p_kieli+'\apu_NoCC.dbf'
select logi_excl
copy next 0 to (lc_name) fields code, name
select 0
use (lc_name) alias logi_nocc
append blank
lc_n=0
lc_na=0
lc_ni=0
lc_non=-1
lc_code=' '
no_code=' '
lc_no=.t.
select dg
goto top
do while not eof()
  if not dg.vartype='COMPL'
    if dg.code='V' or dg.code='W' or dg.code='X' or dg.code='Y'
      select dg
      skip
      loop
    endif
    select dg
    if not eof()
      skip
      lc_code=dg.code
    endif
    if no_code<>lc_code or eof()
      if no_code<>' ' and lc_no
        lc_non=lc_non+1
        select icd_10
        lc_ast=.f.
        seek (no_code)
        if not found()
          insert into logi_nocc (code, name); 
          values (no_code, 'No name available')
        else
          insert into logi_nocc (code, name); 
          values (no_code, trim(icd_10.text))
        endif
      endif
      lc_no=.t.
    endif
    no_code=lc_code
    loop
  endif
  lc_n=lc_n+1
  if substr(dg.varval,3,1)='C'
    lc_na=lc_na+1
  else
    lc_ni=lc_ni+1
  endif
  lc_no=.f.
  select kompkat
  seek SUBSTR(dg.varval,1,2)+SUBSTR(dg.varval,4,2)+SUBSTR(dg.varval,3,1)
  select icd_10
  lc_ast=.f.
  seek (dg.code+dg.d_code)
  if not found()
    if lc_code<>dg.code
      seek dg.code
      insert into logi_cc (code, name); 
      values (dg.code, trim(icd_10.text)+';---')
      if substr(dg.varval,3,1)='C'
        insert into logi_cca (code, name); 
        values (dg.code, trim(icd_10.text)+';---')
      else
        insert into logi_cci (code, name); 
        values (dg.code, trim(icd_10.text)+';---')
      endif
    endif
    seek dg.d_code
    lc_ast=.t.
  endif
  lc_code=dg.code
  if lc_ast
    insert into logi_cc (code, name); 
    values ('--- '+icd_10.d_code,'---; '+icd_10.text)
    if substr(dg.varval,3,1)='C'
      insert into logi_cca (code, name, property, pro_name); 
      values ('--- '+icd_10.d_code,'---; '+icd_10.text, dg.varval, kompkat.english)
    else
      insert into logi_cci (code, name, property, pro_name); 
      values ('--- '+icd_10.d_code,'---; '+icd_10.text, dg.varval, kompkat.english)
    endif
  else
    insert into logi_cc (code, name); 
    values (icd_10.code+icd_10.ast+icd_10.d_code,icd_10.text)
    if substr(dg.varval,3,1)='C'
      insert into logi_cca (code, name, property, pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code,icd_10.text, dg.varval, kompkat.english)
    else
      insert into logi_cci (code, name, property, pro_name); 
      values (icd_10.code+icd_10.ast+icd_10.d_code,icd_10.text, dg.varval, kompkat.english)
    endif
  endif
  select dg
  skip
enddo
? "CC_DG: Number of CC dg's " +str (lc_na,5,0)+"+"+str (lc_ni,5,0)+" and no-CC dg's "+str(lc_non,5,0)

select logi_cc
    if lc_n=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnosis codes belonging to any CC-category, n ='+str(lc_n,5,0)
select logi_cc
copy to ('..\..\..\tabl_man\'+p_kieli+'\cc_dg.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\CC_DG.htm', 'logi_cc', .f., .f. , .f.
use

select logi_cca
    if lc_na=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnosis codes belonging to active CC-categories, n ='+str(lc_na,5,0)
select logi_cca
copy to ('..\..\..\tabl_man\'+p_kieli+'\cca_dg.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\CC_DG.htm', 'logi_cc', .f., .f. , .f.
use

select logi_cci
    if lc_ni=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnosis codes belonging to inactive CC-categories, n ='+str(lc_ni,5,0)
select logi_cci
copy to ('..\..\..\tabl_man\'+p_kieli+'\cci_dg.txt') DELIMITED WITH '"' WITH CHAR ';'

use
select logi_nocc
    if lc_non=0
      append blank
      replace name with 'Property not available in NordDRG-'+p_kieli
    endif 
goto top
replace  name with 'Diagnosis codes not belonging to any CC-category, n ='+str(lc_non,5,0)
select logi_nocc
copy to ('..\..\..\tabl_man\'+p_kieli+'\nocc_dg.txt') DELIMITED WITH '"' WITH CHAR ';'
*do (lc_genhtml) with language.lan+'\manual\NoCC_DG.htm', 'logi_nocc', .f., .f. , .f.
use
return

procedure pro99S99
select logi_apu
copy next 0 to ..\logi_proc with cdx
copy next 0 to ..\logi_proc2 with cdx
copy next 0 to ..\logi_proc3 with cdx
select 0
use ..\logi_proc
set order to code
append blank
replace code with '99S99'
select 0
use ..\logi_proc2
set order to code
append blank
replace code with '99S90'
select 0
use ..\logi_proc3
set order to code
append blank
replace code with '99O99'
lc_n =0
lc_n2=0
lc_n3=0
select drgtpt
set order to code
set relation to
select csp
goto top
do while not eof()
  lc_nonext=.t.
  lc_outpat=.f.
  select drgtpt
  seek csp.code
  do while drgtpt.code=csp.code and not eof()
    select tpomin
    seek drgtpt.varval
    if found() and extens='1'
      lc_nonext=.f.
    endif
    if found() and substr(procprop,3,1)='O'
      lc_outpat=.t.
    endif 
    if not lc_nonext and lc_outpat
      exit
    endif
    select drgtpt
    skip
  enddo
  if lc_nonext
    insert into ..\logi_proc (code, name) values (csp.code, csp.text)
    lc_n =lc_n+1
  else
    insert into ..\logi_proc2 (code, name) values (csp.code, csp.text)
    lc_n2 =lc_n2+1
  endif
  if lc_outpat
    insert into ..\logi_proc3 (code, name) values (csp.code, csp.text)
    lc_n3 =lc_n3+1
  endif
  select csp
  skip
enddo
select logi_proc
goto top
replace name with 'Non-extended procedures, n ='+str (lc_n,5,0)
? 'PR_99S99: Number of codes ' +str (lc_n,5,0)
select logi_proc
copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_99S99.txt') DELIMITED WITH '"' WITH CHAR ';'      
select logi_proc2
goto top
replace name with 'Extended procedures, n ='+str (lc_n2,5,0)
? 'PR_99S90: Number of codes ' +str (lc_n,5,0)
select logi_proc2
copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_99S90.txt') DELIMITED WITH '"' WITH CHAR ';'      
use
select logi_proc3
goto top
replace name with 'Procedures only significant in outpatient setting, n ='+str (lc_n2,5,0)
? 'PR_99S90: Number of codes ' +str (lc_n,5,0)
select logi_proc3
copy to ('..\..\..\tabl_man\'+p_kieli+'\PRO_99O99.txt') DELIMITED WITH '"' WITH CHAR ';'      
return
