procedure diftark
if p_kieli='Com'
  wait window 'Common version cannot be compared with common version. Select a national version to be checked'
  return
endif
lc_code=csp.code
define window koodi from 5,5 to 25,120 FONT  max_foty,  max_fosi
select drgt_en

select drgtpt
use
use ('../../tabl_def/'+p_kieli+'/drgtpt')
set filter to valid
set order to code

select csp
use
use ('../../ncsp/'+p_kieli+'/csp')
set filter to not released
set order to code
SEEK lc_code
do while not eof()
  select drgtpt
  seek csp.code
  do while drgtpt.code=csp.code and not eof()
    if varval='99S00' or varval='99S90'
      replace valid with .f.
      skip
      loop
    endif
    lc_drgtpt=drgtpt.vartype+drgtpt.varval
    select drgt_en
    seek csp.ncsp+lc_drgtpt
    IF NOT FOUND()
      SET FILTER TO code=csp.ncsp
      SEEK csp.ncsp+lc_drgtpt
    ENDIF 
    if not found() OR NOT valid
       activate window koodi
       clear
       @ 1,1 say 'Local NCSP code'
       @ 2,1 say csp.code +' '+csp.text
       select csp_en
       seek csp.ncsp
       @ 3,1 say 'Common NCSP code'
       if found()
         @ 4,1 say csp_en.code+' '+csp_en.text
       else 
         @ 4,1 say 'No mapping'
         wait window 'No mapping'
         release window koodi
         IF NOT (drgtpt.vartype='OR' AND drgtpt.varval='0')
           do cspnaytto
           RETURN
         ELSE
           define window koodi from 5,5 to 25,120 FONT  max_foty,  max_fosi
           SELECT drgtpt
           SKIP
           LOOP 
         ENDIF 
       endif
       select drgt_en
       @ 6,1 say 'Property of local version does not exist in common version NordDRG'
       lc_orcc=.f.
       do case
       case drgtpt.vartype='PROCPR' 
         select tpomin
         seek drgtpt.varval
         lc_text=tpomin.english
         @ 9,1 say 'Common vers. property: ---'
       case drgtpt.vartype='DGPROP'
         select dgomin
         seek (SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2)+SUBSTR(drgtpt.varval,3,1))
         lc_text=dgomin.english
         @ 9,1 say 'Common vers. property: ---'
       case drgtpt.vartype='CC'
         @ 9,1 say 'Common vers. property: No CC'
         lc_text=' '        
       otherwise
         seek csp.ncsp+drgtpt.vartype
         lc_text=' '
         lc_orcc=.t.
       IF drgt_en.vartype=drgtpt.vartype
         @ 9,1 say 'Common vers. property: '+drgt_en.vartype+' '+drgt_en.varval+' '+lc_text
       ELSE 
         @ 9,1 say 'Common vers. property: ---'         
       ENDIF 
       endcase
       select drgt_en
       @ 8,1 say 'Local vers. property:  '+drgtpt.vartype+' '+drgtpt.varval+' '+lc_text
       if lc_orcc
         @11,1 say '(L)ocal version adjustment'
       else
         @11,1 say '(D)elete the local property'
       endif
       @ 12,1 say '(A)ccept the difference'
       @ 13,1 say '(E)dit the files manually'
       @ 14,1 say '(U)pdate property to common version'
       wait window 'Select the option'
       do case
       case lastkey()=76 or lastkey()=108 and lc_orcc
         replace drgtpt.varval with drgt_en.varval
       case lastkey()=68 or lastkey()=100 and not lc_orcc
         select drgtpt
         seek csp.code+lc_drgtpt
         replace valid with .f.
       case lastkey()= 65 or lastkey()=97
         wait window nowait 'OK'
       CASE LASTKEY()=85 OR LASTKEY()=117
         SELECT drgt_en
         SEEK csp.ncsp+lc_drgtpt
         IF NOT FOUND()
           append blank
           replace chdate WITH DATE(), code WITH csp.ncsp, valid WITH .t., vartype WITH drgtpt.vartype, varval WITH drgtpt.varval
         ELSE 
           replace valid WITH .t.
         ENDIF 
         SET FILTER TO valid
       otherwise
         release window koodi
         select csp
         do cspnaytto
         return
       endcase
    endif
    select drgtpt
    skip
  enddo
  select drgt_en
  SET FILTER TO valid
  seek csp.ncsp
  do while code=csp.ncsp
    if varval='99S00' or varval='99S90'
      replace valid with .f.
      skip
      loop
    ENDIF
    select drgtpt
    seek csp.code+drgt_en.vartype+drgt_en.varval
    if not found()
       activate window koodi
       clear
       @ 1,1 say 'Local NCSP code'
       @ 2,1 say csp.code +' '+csp.text
       select csp_en
       seek csp.ncsp
       @ 3,1 say 'Common NCSP code'
       @ 4,1 say csp_en.code+' '+csp_en.text
       select drgtpt
       @ 6,1 say 'Property of common NordDRG does not exist in local version '
       lc_orcc=.f.
       do case
       case drgt_en.vartype='PROCPR' 
         select tpomin
         seek drgt_en.varval
         lc_text=tpomin.english
         @ 8,1 say 'Local vers. property:  ---'
       case drgt_en.vartype='DGPROP'
         select dgomin
         seek (SUBSTR(drgt_en.varval,1,2)+SUBSTR(drgt_en.varval,4,2)+SUBSTR(drgt_en.varval,3,1))
         lc_text=dgomin.english
         @ 8,1 say 'Local vers. property:  ---'
       case drgt_en.vartype='CC'
         lc_text=' '
         @ 8,1 say 'Local vers. property:   No CC'
       CASE drgt_en.vartype='OR'
         lc_text=' '
         *
       otherwise
         lc_orcc=.t.
       endcase
       if lc_orcc
         select drgt_en
         skip
         loop
       ENDIF
       @ 9,1 say 'Common vers. property: '+drgt_en.vartype+' '+drgt_en.varval+' '+lc_text
       
       @11,1 say '(I)nsert the property to local version'
       @12,1 say '(A)ccept the difference'
       @13,1 say '(E)dit the files manually'
       @14,1 say '(R)emove property from common version'
       *r=114 R=82
       wait window 'Select the option'
       do case
       case lastkey()=73 or lastkey()=105
         select drgtpt
         set filter to
         seek csp.code+drgt_en.vartype+drgt_en.varval
         if not found()
           insert into drgtpt (code, vartype, varval, chdate);
           values (csp.code, drgt_en.vartype, drgt_en.varval, date())
         endif
         replace valid with .t.
         select drgtpt
         set filter to valid
       case lastkey()= 65 or lastkey()=97
         wait window nowait 'OK'
       CASE LASTKEY()=82 OR LASTKEY()=114
         SELECT drgt_en
         replace drgt_en.valid WITH .f.
       otherwise
         release window koodi
         select csp
         do cspnaytto
         return
       endcase
    endif
    select drgt_en
    skip
  enddo
  select csp
  skip
enddo
goto top
do cspnaytto
do cspohje
release window koodi
wait window 'End' nowait
return