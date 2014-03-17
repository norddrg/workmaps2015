Procedure peruutus
if alias()<>'DRGTPT'
  wait window nowait 'Select a property'
  select drgtpt
  do cspnaytto
  return
endif
if vartype='OR'
  select csp
  seek drgtpt.code
  do non_or
  return
endif
if vartype='CC'
  select csp
  seek drgtpt.code
  do kompl
  return
endif
replace valid with .f.
select csp
   lc_koodi=code
   if p_kieli='Com'
     select language
     goto top
     do while not eof()
       if language.lan<>'Com'
         select csp_oth
         use ('..\..\ncsp\'+trim(language.lan)+'\csp') alias csp_oth
         set order to ncsp
         seek trim(lc_koodi)
         do while trim(csp_oth.ncsp)=trim(lc_koodi)
           lc_code=code
           select drgt_oth
           use ('..\..\tabl_def\'+trim(language.lan)+'\drgtpt') alias drgt_oth
           set filter to valid
           set order to code
           seek (lc_code+drgtpt.vartype+drgtpt.varval)
           if found()
             wait window lc_code+' '+trim(csp_oth.text)+' - '+trim(drgtpt.vartype)+' - '+;
             trim(drgtpt.varval)+' will be released from '+language.lan+'-file. Y(es)/N(o)'
             if lastkey()=121 or lastkey()=89
               replace valid with .f.
             endif
           endif
           select csp_oth
           skip
         enddo
       endif
       select language
       skip
     enddo
   endif
select csp
seek drgtpt.code
select drgtpt
skip -1
do cspnaytto
return