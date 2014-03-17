Procedure siir_dgp
lc_alias=alias()
select csp
if order()='ICD9CM'
  wait window 'The order will be changed according to NCSP-code!'
  set order to code
endif
if code=lc_alku
  seek (lc_loppu)
else
  lc_alku = code
endif
wait window 'First code '+lc_alku+'. Choose the last code. Continue [Ctrl][W]. Cancel [Esc]' nowait
do case
case p_kieli='Fin'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40,csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.finish,iif(drgtpt.vartype='PROCPR',tpomin.finish,'***')):70,;
  link.icd9cm_o, link.text, icd9cm_o.nimi_cm SAVE 
case p_kieli='Com'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.english:R:40,;
  drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  link.icd9cm_o, link.text, icd9cm_o.nimi_cm SAVE 
otherwise
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40, csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  link.icd9cm_o, link.text, icd9cm_o.nimi_cm SAVE 
endcase
if lastkey()=27
  do cspnaytto
  return
endif
lc_loppu=csp.code
if lc_alku>lc_loppu
  wait window 'Reverse order! OK? [Esc]-Cancel [Enter]-Continue'
  if lastkey()=27
    do cspnaytto
    return
  endif
  lc_apu=lc_alku
  lc_alku=lc_loppu
  lc_loppu=lc_apu
endif
seek lc_alku
do case
case p_kieli='Fin'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40,csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.finish,iif(drgtpt.vartype='PROCPR',tpomin.finish,'***')):70,;
  link.icd9cm_o, link.text, icd9cm_o.nimi_cm SAVE NOWAIT
case p_kieli='Eng'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.english:R:40,;
  drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  link.icd9cm_o, link.text, icd9cm_o.nimi_cm SAVE NOWAIT
otherwise
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40, csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  link.icd9cm_o, link.text, icd9cm_o.nimi_cm SAVE NOWAIT
endcase
select drgtpt
set relation to
select dgomin
seek SUBSTR(p_dgomin,1,2)+SUBSTR(p_dgomin,4,2)+SUBSTR(p_dgomin,3,1)
if not found()
  goto top
endif
lc_omin=dgomin.dgprop
select csp
lc_order=order()
if order()<>'CODE'
  set order to code
endif
lc_order=order()
select (lc_alias)
select drgtpt
*set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin 
if lc_alias<>'DGOMIN'
  select dgomin
  wait window 'Check the diagnosisproperty! Continue = [Ctrl][W], Cancel = [Esc]' nowait
  seek SUBSTR(p_omin,1,2)+SUBSTR(p_omin,4,2)+SUBSTR(p_omin,3,1)
  browse window tpomin fields dgprop:R, english:R, finish:R save
  if lastkey()=27
    browse window tpomin fields dgprop:R, english:R, finish:R nowait save
    return
  endif
  lc_omin=dgomin.dgprop
endif
select csp
seek (lc_alku)
do while not eof() and csp.code<=lc_loppu
*   select drgtpt
   if p_kieli='Com'
     lc_ncsp=csp.code
   else
     lc_ncsp=csp.ncsp
   endif
   lc_code=csp.code
   lc_found=.f.
   seek csp.code
   do while csp.code=lc_ncsp
     if lc_omin=drgtpt.varval
       lc_found=.t.
       exit
     endif
     select csp
     skip
   enddo  
   if not lc_found
     insert into drgtpt (code, code_nc)values (lc_code,lc_ncsp)
     replace drgtpt.chdate with date()
     replace drgtpt.valid with .t.
     replace drgtpt.vartype with 'DGPROP'
     replace drgtpt.varval with lc_omin
   endif
   select csp
   seek lc_code
   p_dgomin=lc_omin
   select csp
   if p_kieli='Com'
*     lc_ncsp=code
     select language
     goto top
     do while not eof()
       if language.lan<>'Com'
         select csp_oth
         use ('\data\ncsp\'+trim(language.hakem)+'\csp') alias csp_oth
         set order to ncsp
         seek lc_ncsp
         if found()
           lc_code=code
           select drgt_oth
           use ('\data\ncsp\'+language.hakem+'\drgtpt') alias drgt_oth
           set filter to valid
           set order to code
           seek (lc_code+drgtpt.vartype+drgtpt.varval)
           if not found()
             wait window lc_code+' '+trim(csp_oth.text)+' - '+drgtpt.vartype+'-'+drgtpt.varval+;
             ' will be added to '+language.lan+'-file. Y(es)/N(o)'
             if lastkey()=121 or lastkey()=89
               append blank
               replace code with lc_code, code_nc with lc_ncsp, chdate with date(), ;
               valid with .t., vartype with 'DGPROP', varval with lc_omin
             endif
           endif
         endif
       endif
       select language
       skip
     enddo
   endif
   select csp
   lc_code=code
   if lc_alias='DGOMIN'
     exit
   endif
   do while lc_code=code
     skip
   enddo
enddo
set filter to not deleted()
seek lc_alku
select csp
select drgtpt
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin 
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
do cspnaytto
return