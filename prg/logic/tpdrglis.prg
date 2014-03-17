Procedure tpdrglis
lc_genhtml=home()+'genhtml'
select 0
use ..\ddl_stru 
set safety off
copy next 0 to ..\tpdrglis fields code, mdc, drg, text
*Helpfile for collecting codes and properties from a group of NCSP codes
copy next 0 to ..\apu_tpdlis fields code, mdc, drg, text with cdx
*Helpfile for collecting and ordering properties of one code
*Ordering is based on index
use ..\tpdrglis
select 0
use ..\apu_tpdlis alias apu
set order to code
select drglogic
set order to drg
select 0
select drgtpt
set order to code
set filter to valid
goto top
lc_loop=.t.
lc_1=substr(code,1,1)
if p_kieli='Dan'
  lc_1=substr(code,1,2)
endif
lc_code=' '
lc_n=1
lc_or='0'
lc_cc=.f.
lc_large=.f.
lc_first=.t.
lc_fipro=.t.
apu_tyh=.t.
apu_n=0
old_n=0
tp_code=' '
tp_text=' '
goto top
do while lc_loop
  lc_n=lc_n+1
  if lc_n=100*int(lc_n/100)
    ? drgtpt.code
  endif
  if drgtpt.code>lc_1
    if lc_or <>'0'
      select drgnames
      if lc_large
        seek '468X'
      else
        seek '477X'
      endif
      select apu
      seek ('4 '+space(12)+'  '+(drgnames.drg))
      if found()
        replace code with '41'
        apu_n=apu_n+1
      endif
      seek ('41'+space(12)+'  '+(drgnames.drg))
      if not found()
        if not apu_tyh
          do apu_siir
        endif
        if apu_tyh
          insert into apu(code, drg, text) values ('41', drgnames.loc_drg, drgnames.drgname )
          apu_n=apu_n+1
        endif
      endif
    endif
    insert into ..\tpdrglis (code, text) values (tp_code, tp_text)
    do apu_siir
    lc_fipro=.t.
    select apu
    delete all 
    pack
    apu_tyh=.t.
    apu_n=0
    old_n=0
    lc_first=.t.
    select tpdrglis
    copy to ('..\..\..\tabl_man\'+p_kieli+'\tdl_'+lc_1+'.txt') DELIMITED WITH '"' WITH CHAR ';'
    use ..\ddl_stru 
    copy next 0 to ..\tpdrglis fields code, mdc, drg, text
     use ..\tpdrglis
    lc_1=substr(drgtpt.code,1,1)
    if lc_1='N'
      lc_1=substr(drgtpt.code,1,2)
    endif
    if p_kieli='Dan'
      lc_1=substr(drgtpt.code,1,2)
      if lc_1='KN'
        lc_1=substr(drgtpt.code,1,3)
      endif
      if lc_1<>'K'
        lc_1=substr(drgtpt.code,1,1)
      endif
    endif
    wait window lc_1 nowait
  endif
  select drgtpt
  lc_tptext=' '
  select csp
  seek drgtpt.code
  if not found()
    select drgtpt
    if not eof()
      skip
      loop
    else
      code=' '
    endif
  endif
  select drgtpt
  if lc_code<>code
    if lc_or ='1'
      select drgnames
      if lc_large
        seek '468X'
      else
        seek '477X'
      endif
      select apu
      seek ('4 '+space(12)+'  '+(drgnames.loc_drg))
      if found()
        replace code with '41'
        apu_n=apu_n+1
      endif
      seek ('41'+space(12)+'  '+(drgnames.loc_drg))
      if not found()
        if not apu_tyh
          do apu_siir
        endif
        if apu_tyh
          insert into apu(code, drg, text) values ('41', drgnames.loc_drg, drgnames.drgname)
          apu_n=apu_n+1
        endif
      endif
    endif
    if old_n>apu_n and not apu_tyh
      do apu_siir
    endif
    if not lc_fipro
      insert into ..\tpdrglis (code, text) values (tp_code, tp_text)
      apu_tyh=.f.
      old_n=apu_n
      apu_n=0
      select apu
      goto top
    endif
    select drgtpt
    if eof()
      exit
    endif
    lc_fipro=.t.
    lc_first=.f.
    lc_code=code
    lc_or='0'
    lc_cc=.f.
    lc_large=.f.
  endif
  select drgtpt
  if not (vartype='PROCPR' or (vartype='OR' and varval<>'0') or (vartype='CC' and varval='1')) or varval='99S00'
    skip
    loop
  endif
  if lc_fipro
    tp_code=csp.code
    tp_text=csp.text
    select apu
    replace all code with substr(code,1,1)
    lc_fipro=.f.
  endif
  select drgtpt
  do case
  case vartype='OR' and varval<>'0'
    lc_or=varval
    select apu
    seek ('1 '+space(12)+'OR  '+trim(drgtpt.varval)+'  ')
    if found()
      replace code with '11'
    endif
    seek ('11'+space(12)+'OR  '+trim(drgtpt.varval)+'  ')    
    apu_n=apu_n+1
    if not found()
      if not apu_tyh
        do apu_siir
      endif
      if apu_tyh
        do case
        case p_kieli='Fin'
          insert into apu(code, mdc, drg, text) values ('11','OR','  '+drgtpt.varval,'OR-leikkaus')
          if drgtpt.varval='2'
            replace text with 'Merkittävä avohoitotoimenpide'
          endif
        case p_kieli='Swe'
          insert into apu(code, mdc, drg, text) values ('11','OR','  '+drgtpt.varval,'OR-åtgärd')
          if drgtpt.varval='2'
            replace text with 'Betydande åtgärd i öppenvård'
          endif
        otherwise
          insert into apu(code, mdc, drg, text) values ('11','OR','  '+drgtpt.varval,'OR-procedure')
          if drgtpt.varval='2'
            replace text with 'Signficant procedure for outpatient'
          endif
        endcase
      endif
    endif
  case vartype='CC' and varval='1'
    lc_cc=.t.
    select apu
    seek ('2 '+space(12)+'CC'+'  '+drgtpt.varval)
    if found()
      replace code with '21'
    endif
    seek ('21'+space(12)+'CC'+'  '+drgtpt.varval)
    apu_n=apu_n+1
    if not found()
      if not apu_tyh
        do apu_siir
      endif
      if apu_tyh
        do case
        case p_kieli='Fin'
          insert into apu(code, mdc, drg, text) values ('21','CC','  '+drgtpt.varval,'CC-leikkaus')
        case p_kieli='Swe'
          insert into apu(code, mdc, drg, text) values ('21','CC','  '+drgtpt.varval,'CC-åtgärd')
        otherwise
          insert into apu(code, mdc, drg, text) values ('21','CC','  '+drgtpt.varval,'CC-procedure')
        endcase
      endif
    endif
  otherwise
   select tpomin
   seek drgtpt.varval
   if extens='1'
     lc_large=.t.
   endif
   select drglogic
   set order to drg
   goto top
   lc_drg=' '
   do while not eof()
    select drglogic
    if drg<>'470X' and drg<>'468X' and drg<>'477X' and drg<>'468O' and drg<>'477O';
    and (drgtpt.varval=drglogic.procpro1 or drgtpt.varval=drglogic.secproc1)
      select drgnames
      seek drglogic.drg 
      select apu
      seek ('3 '+space(12)+trim(drgnames.mdc)+(drgnames.loc_drg))
      if found()
        replace code with '31'
        apu_n=apu_n+1
      endif
      seek ('31'+space(12)+trim(drgnames.mdc)+(drgnames.loc_drg))
      if not found()
        if not apu_tyh
          do apu_siir
        endif
        if apu_tyh
          insert into apu(code, mdc, drg, text) values ('31', drgnames.mdc, drgnames.loc_drg, drgnames.drgname)
          apu_n=apu_n+1
        endif
      endif
    endif
    select drglogic
    skip
   enddo
  endcase
  select drgtpt
  skip
enddo
select tpdrglis
copy to ('..\..\..\tabl_man\'+p_kieli+'\tdl_'+lc_1+'.txt') DELIMITED WITH '"' WITH CHAR ';'
use
set safety on
return

Procedure apu_siir
  select apu
  delete all for substr(code,2,1)=' '
  replace all code with substr(code,1,1)
  as_code=code
  as_mdc=mdc
  as_drg=drg
  goto top
  do while not eof()
    insert into ..\tpdrglis (mdc, drg, text) values (apu.mdc, apu.drg, apu.text)
    select apu
    skip
  enddo
  select apu
  pack
  apu_tyh=.t.
return
