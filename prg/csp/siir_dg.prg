Procedure siir_dg
lc_alias=alias()
if alias()='DRGTPT'
  lc_omin1=varval
endif
select drgtpt
set relation to
select dgomin
lc_omin=dgomin.dgprop
seek SUBSTR(p_dgomin,1,2)+SUBSTR(p_dgomin,4,2)+SUBSTR(p_dgomin,3,1)
if not found()
  goto top
endif
select csp
lc_order=order()
if order()<>'CODE'
  set order to code
endif
lc_order=order()
select (lc_alias)
select drgtpt
*set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin 
if alias()='NCSP_CHA' or alias()='NCSP_GRO' or alias()='NCSP_SUB'
  lc_ryh=trim(code)
  select csp
  if order()='ICD9CM'
     wait window 'The order will be changed according to NCSP-code!'
     set order to code
  endif
  if code<>lc_ryh
    seek lc_ryh
    BROWSE WINDOW koodit FIELDS csp.code:7:R, csp.text:50:R, csp.code_nc:7:R, csp.english: 50:R, drgtpt.procprop:6, drgtpt.compl:3, drgtpt.or:2, drgtpt.dgprop, csp.finish:20 SAVE nowait
  endif
else
  select csp
  lc_ryh=code
  seek lc_ryh
  do while code=lc_ryh
    if drgtpt.vartype='DGPROP' and substr(drgtpt.varval,1,2)=substr(lc_omin,1,2) and drgtpt.varval<>lc_omin
       wait window 'The procedure has coded earlier to '+drgtpt.varval+ '. Cancel=[Space], continue =[Enter]'
       if lastkey()<>13 
          return
       else
          exit
       endif
    endif
    skip
  enddo
endif
if lc_alias<>'DGOMIN'
  select dgomin
  if lc_alias='DRGTPT' and substr(lc_omin1,3,1)='X' 
    seek substr(lc_omin1,1,2)+substr(lc_omin1,4,2)
  endif
  wait window 'Check the diagnosisproperty! Continue = [Ctrl][W], Cancel = [Esc]' nowait
*  seek SUBSTR(p_omin,1,2)+SUBSTR(p_omin,4,2)+SUBSTR(p_omin,3,1)
  browse window tpomin fields dgprop:R, english:R, finish:R save
  if lastkey()=27
    browse window tpomin fields dgprop:R, english:R, finish:R nowait save
    return
  endif
  lc_omin=dgomin.dgprop
endif
select csp
seek (lc_ryh)
do while not eof() and (csp.code=lc_ryh)
   if order()='ICD9CM' and code<>substr(lc_ncsp,1,2)
     lc_ncsp=code
     if lc_alias<>'DGOMIN'
       select ncsp_gro
       set filter to 
       seek substr(lc_ncsp,1,2)
       select csp
       wait window; 
       'Shall I code: '+ncsp_gro.code+trim(ncsp_ryh.english)+'. Yes = [Enter], No = [Space]'
       lc_ncsp=code
       if lastkey()<>13
         do while code=substr(lc_ncsp,1,2) and not eof()
           skip
         enddo
         if eof()
           exit
         endif
         loop
       endif
     endif
   endif
   select drgtpt
   if p_kieli='Com'
     lc_ncsp=csp.code
   else
     lc_ncsp=csp.ncsp
   endif
   lc_code=csp.code
   lc_ncsp=csp.code
   lc_found=.t.
   seek csp.code
   if not found()
     lc_found=.f.
   endif
   do while csp.code=lc_ncsp and lc_found
     if lc_omin=drgtpt.varval
       exit
     endif
     select csp
     skip
   enddo  
    if not (csp.code=lc_code and drgtpt.varval=lc_omin) or not lc_found
     insert into drgtpt (code, code_nc)values (lc_code,lc_ncsp)
   endif
   replace drgtpt.chdate with date()
   replace drgtpt.valid with .t.
   replace drgtpt.vartype with 'DGPROP'
   replace drgtpt.varval with lc_omin
   p_dgomin=lc_omin
   select csp
   if p_kieli='Com'
*     lc_ncsp=code
     select language
     goto top
     do while not eof()
       if language.lan<>'Com'
         select csp_oth
         use ('..\..\ncsp\'+trim(language.lan)+'\csp') alias csp_oth
         set order to ncsp
         seek trim(lc_ncsp)
         if found()
           lc_code=code
           select drgt_oth
           use ('..\..\tabl_def\'+trim(language.lan)+'\drgtpt') alias drgt_oth
           set filter to valid
           set order to code
           seek (lc_code+drgtpt.vartype+drgtpt.varval)
           if not found()
             wait window lc_code+' '+trim(csp_oth.text)+' - '+drgtpt.vartype+'-'+drgtpt.varval+;
             ' will be added to '+language.lan+'-file. Y(es)/N(o)'
             if lastkey()=121 or lastkey()=89
               append blank
               replace code with lc_code, code_nc with lc_ncsp, chdate with date(), ;
               valid with .t., vartype with drgtpt.vartype, varval with drgtpt.varval
             endif
           endif
         endif
       endif
       select language
       skip
     enddo
   endif
   select csp
   lc_koodi=code
   if lc_alias='DGOMIN'
     exit
   endif
   skip
   do while lc_koodi=code
     skip
   enddo
enddo
set filter to not deleted()
seek lc_ryh
select csp
set order to (lc_order)
do case
  case len(lc_ryh)=1
    select ncsp_cha
  case len(lc_ryh)=2
    select ncsp_gro
  case len(lc_ryh)=3
    select ncsp_sub
  otherwise
    select csp
endcase
select drgtpt
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin 
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
if alias()='CSP' or lc_alias='DGOMIN'
  do cspnaytto
else 
  do csppaiv
endif
return