Procedure dgdrglis
lc_genhtml=home()+'genhtml'
select 0
use ..\anal_apu alias anal
delete all
pack
append blank
select 0
use ..\..\icd_10\icd_cha
set order to alaraja
select 0
use ..\ddl_stru 
set safety off
copy next 0 to ..\dgdrglis 
copy next 0 to ..\atclis
use ..\dgdrglis
select 0
use ..\atclis
select drglogic
set order to drg
select icd_10
set filter to valid
select dg
set filter to valid
lc_codes=' '
goto top
select icd_10
goto top
lc_nn=0
lc_1=substr(code,1,1)
if p_kieli='Dan'
  lc_1=substr(code,2,1)
endif
lc_loop=.t.
lc_atc=.f.
pr_drg1='    '
pr_drg2='    '
pr_drg3='    '
pr_drg4='    '
pr_drg5='    '
pr_drg6='    '
pra_drg1='    '
pra_drg2='    '
pra_drg3='    '
pra_drg4='    '
pra_drg5='    '
pra_drg6='    '
pr_atc=.f.
public p_logluku
p_logluku=.f.
do while lc_loop
  select icd_10
  ddl_code=code+d_code
  lc_1=code
  if p_kieli='Dan'
    lc_1=substr(code,2,5)
  endif
  if UPPER(lc_1)>icd_cha.ylaraja or eof()
    pr_atc=lc_atc
    do kirj
    pr_drg1='    '
    pr_drg2='    '
    pr_drg3='    '
    pr_drg4='    '
    pr_drg5='    '
    pr_drg6='    '
    pra_drg1='    '
    pra_drg2='    '
    pra_drg3='    '
    pra_drg4='    '
    pra_drg5='    '
    pra_drg6='    '
    pr_atc=.f.
    lc_nn=0
    select dgdrglis
    copy to ('..\..\..\tabl_man\'+p_kieli+'\ddl_'+trim(icd_cha.luku)+'.txt') DELIMITED WITH '"' WITH CHAR ';'
    wait window nowait (icd_cha.luku)
    *do (lc_genhtml) with language.lan+'\manual\ddl_'+trim(icd_cha.luku)+'.htm', 'dgdrglis', .f., .f. , .f.
    select icd_cha
    if not eof()
      skip
    endif
    select dgdrglis
    use ..\ddl_stru
    copy next 0 to ..\dgdrglis 
    use ..\dgdrglis
    lc_luku=.f.
    select icd_10
    if eof()
      exit
    endif
  endif
  if icd_cha.luku='XX '
    skip
    loop
  endif
  if eof()
    exit
  endif
  if at('-',icd_10.d_code)>0
    select ICD_10
    skip
    loop
  endif
  lc_nn=lc_nn+1
  if int(lc_nn/10)*10=lc_nn
    ? icd_10.code  
  endif
  lc_dgtext=' '
  select ICD_10
  lc_dgtext=trim(text)
  lc_ast=ast
  lc_atc=.f.
  if len(trim(code))>4 and at('.',code)=0 and p_kieli<>'Dan'
    lc_atc=.t.
  endif

  select anal
  replace oir1 with icd_10.code, syy1 with icd_10.d_code, oir2 with ' ', syy2 with ' '
  replace ika with 12775, sex with 'F', dur with 5
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg1=drgnames.loc_drg

  select anal
  replace dur with 1
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg11=drgnames.loc_drg

  select anal
  replace sex with 'M', dur with 5
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg2=drgnames.loc_drg

  select anal
  replace dur with 1
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg12=drgnames.loc_drg

  select anal
  replace sex with 'F', dur with 5
  replace ika with 3000
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg3=drgnames.loc_drg

  select anal
  replace dur with 1
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg13=drgnames.loc_drg
 
  select anal
  replace sex with 'F'
  replace ika with 0, dur with 5
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg4=drgnames.loc_drg

  select anal
  replace sex with 'F'
  replace dur with 1
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg14=drgnames.loc_drg

  select anal
  replace oir2 with 'C45.2', dur with 5
  if p_kieli='Dan'
    replace oir2 with 'DC452'
  endif
  replace ika with 12775
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg5=drgnames.loc_drg

  select anal
  replace ika with 3000
  do ..\anal\luokitus
  select drgnames
  seek (anal.drg)
  lc_drg6=drgnames.loc_drg

  select icd_10
  seek UPPER(ddl_code)
  if lc_drg1='470' and lc_drg2='470' and lc_drg3='470' and lc_drg4='470' and lc_drg5='470' and lc_drg6='470'
    select icd_10
    if not eof()
      skip
    endif
    loop
  endif
  if lc_atc
    if not (lc_drg1=pra_drg1 and lc_drg2=pra_drg2 and lc_drg3=pra_drg3 and lc_drg4=pra_drg4 and lc_drg5=pra_drg5 and lc_drg6=pra_drg6)
      if pr_drg1<>'    '
        do kirj
      endif
    endif
    pra_drg1=lc_drg1
    pra_drg2=lc_drg2
    pra_drg3=lc_drg3
    pra_drg4=lc_drg4
    pra_drg5=lc_drg5
    pra_drg6=lc_drg6
    pra_drg11=lc_drg11
    pra_drg12=lc_drg12
    pra_drg13=lc_drg13
    pra_drg14=lc_drg14
    insert into atclis(code, text) values (icd_10.code, icd_10.text)
  else
    if not (lc_drg1=pr_drg1 and lc_drg2=pr_drg2 and lc_drg3=pr_drg3;
    and lc_drg4=pr_drg4 and lc_drg5=pr_drg5 and lc_drg6=pr_drg6;
    and lc_drg11=pr_drg11 and lc_drg12=pr_drg12 and lc_drg13=pr_drg13 and lc_drg14=pr_drg14)
      if pr_drg1<>'    '
        do kirj
      endif
    endif
    pr_drg1=lc_drg1
    pr_drg2=lc_drg2
    pr_drg3=lc_drg3
    pr_drg4=lc_drg4
    pr_drg5=lc_drg5
    pr_drg6=lc_drg6
    pr_drg11 = lc_drg11
    pr_drg12 = lc_drg12
    pr_drg13 = lc_drg13
    pr_drg14 = lc_drg14
    insert into dgdrglis (code, text) values (icd_10.code+icd_10.ast+icd_10.d_code, icd_10.text)
  endif
  pr_atc=lc_atc
  select icd_10
  seek UPPER(ddl_code)
  if not eof()
    skip
  endif
  loop
enddo
pr_atc=lc_atc
select dgdrglis
use
select atclis
*do (lc_genhtml) with language.lan+'\manual\ddl_atc.htm', 'atclis', .f., .f. , .f.
copy to ('..\..\..\tabl_man\'+p_kieli+'\ddl_atc.txt') DELIMITED WITH '"' WITH CHAR ';'
use
select anal
use
select icd_cha
use
set safety on
return

procedure kirj
      select drgnames
      seek trim(pr_drg1)
      if pr_atc
        insert into ..\atclis(mdc, drg, text) values (drgnames.mdc, pra_drg1, drgnames.drgname)
        select atclis
      else
        insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg1, drgnames.drgname)
        select dgdrglis
      endif
      if pr_atc 
        if pra_drg1<>pra_drg2
          replace code with '#Female'
          select drgnames
          seek trim(pra_drg2)
          insert into ..\atclis(mdc, drg, text) values (drgnames.mdc, pra_drg2, drgnames.drgname)
          select atclis
          replace code with '#Male'
        endif
        if pra_drg1<>pra_drg3
          select drgnames
          seek trim(pr_drg3)
          insert into ..\atclis(mdc, drg, text) values (drgnames.mdc, pra_drg3, drgnames.drgname)
          select atclis
          replace code with '#Child'
        endif
        if pra_drg1<>pra_drg4 and pra_drg3<>pra_drg4
          select drgnames
          seek trim(pr_drg4)
          insert into ..\atclis(mdc, drg, text) values (drgnames.mdc, pra_drg4, drgnames.drgname)
          select atclis
          replace code with '#Neon.'
        endif
        if pra_drg1<>pra_drg5 
          select drgnames
          seek trim(pr_drg5)
          insert into ..\atclis(mdc, drg, text) values (drgnames.mdc, pra_drg5, drgnames.drgname)
          select atclis
          replace code with '#CC'
        endif
        if not (pra_drg3=pra_drg6 or pra_drg5=pra_drg6)
          select drgnames
          seek trim(pr_drg6)
          insert into ..\atclis(mdc, drg, text) values (drgnames.mdc, pra_drg6, drgnames.drgname)
          select atclis
          replace code with '#Child & CC'
        endif
      else
        if pr_drg1<>pr_drg2
          replace code with '#Female'
          select drgnames
          seek trim(pr_drg2)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg2, drgnames.drgname)
          select dgdrglis
          replace code with '#Male'
        endif
        if pr_drg1<>pr_drg3
          select drgnames
          seek trim(pr_drg3)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg3, drgnames.drgname)
          select dgdrglis
          replace code with '#Child'
        endif
        if pr_drg1<>pr_drg4 and pr_drg3<>pr_drg4
          select drgnames
          seek trim(pr_drg4)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg4, drgnames.drgname)
          select dgdrglis
          replace code with '#Neon.'
        endif
        if pr_drg1<>pr_drg5 
          select drgnames
          seek trim(pr_drg5)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg5, drgnames.drgname)
          select dgdrglis
          replace code with '#CC'
        endif
        if not (pr_drg3=pr_drg6 or pr_drg5=pr_drg6)
          select drgnames
          seek trim(pr_drg6)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg6, drgnames.drgname)
          select dgdrglis
          replace code with '#Child & CC'
        endif
        if pr_drg1<>pr_drg11
          select drgnames
          seek trim(pr_drg11)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg11, drgnames.drgname)
          select dgdrglis
          replace code with '1 day'
        endif
        if pr_drg11<>pr_drg12
          replace code with '1 day F'
          select drgnames
          seek trim(pr_drg12)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg12, drgnames.drgname)
          select dgdrglis
          replace code with '1 day M'
        if pr_drg11<>pr_drg13
          select drgnames
          seek trim(pr_drg13)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg13, drgnames.drgname)
          select dgdrglis
          replace code with '1 day Child'
        endif
        if pr_drg11<>pr_drg14
          select drgnames
          seek trim(pr_drg14)
          insert into ..\dgdrglis (mdc, drg, text) values (drgnames.mdc, pr_drg14, drgnames.drgname)
          select dgdrglis
          replace code with '1 day Neon.'
        endif
        endif
      endif
return
