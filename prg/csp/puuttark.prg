Procedure puuttark
select csp
use
use ('../../ncsp/'+p_kieli+'/csp')
set filter to not released
set order to code
replace all tehty with .f. 
goto top
select drgtpt
use
use ('../../tabl_def/'+p_kieli+'/drgtpt')
set filter to valid
set order to code
goto top
lc_apu=' '
public lc_no
lc_no=.f.
lc_or0=.t.
do while not eof()
  if drgtpt.code<>lc_apu
    if not lc_or0
      if p_kieli<>'Com'
        insert into drgtpt (chdate, code, valid, code_nc, vartype, varval);
        values (date(), csp.code, .t., csp.ncsp, 'OR', '0')
      else
        insert into drgtpt (chdate, code, valid, vartype, varval);
        values (date(), csp.code, .t., 'OR', '0')
      endif
    endif
    if code<>substr(lc_apu,1,1) or (p_kieli='Dan' and code<>substr(lc_apu,1,2))
      wait window nowait drgtpt.code
    endif
    lc_apu=drgtpt.code
    lc_or0=.f.
  endif
  if vartype='OR'
    lc_or0=.t.
  endif
  do case
  case drgtpt.code<csp.code
    select drgtpt
    do while drgtpt.code<csp.code 
      replace drgtpt.valid with .f.
      if eof()
        exit
      endif
      if not valid
        skip
      endif
    enddo
    loop
  case drgtpt.code>csp.code
    if not csp.tehty
      if p_kieli<>'Com'
        select drgt_en
        seek csp.ncsp
        if found() and csp.ncsp<>' '
          do while drgt_en.code=csp.ncsp and not eof()
            insert into drgtpt (chdate, code, valid, code_nc, vartype, varval);
            values (date(), csp.code, .t., csp.ncsp, drgt_en.vartype, drgt_en.varval)
            select drgt_en
            skip
          enddo
          wait window csp.code + trim (csp.text) + ' - Automatic definition, check!' 
          lc_apuc=csp.code
          * atc lisäys - exit jää 
          if csp.code>'9'
            exit
          endif
        ELSE
          insert into drgtpt (chdate, code, valid, code_nc, vartype, varval);
          values (date(), csp.code, .t., csp.ncsp, 'OR', '0')
        endif
      else
        insert into drgtpt (chdate, code, valid, code_nc, vartype, varval);
        values (date(), csp.code, .t., csp.code, 'OR', '0')
      endif
      p_tarkier=0
      * atc lisäys - sisennnys jää
      if csp.code>'9'
        wait window csp.code+' '+trim(csp.text)+' - has no properties!'
        lc_no=.t.
        exit
      endif
    else
      select csp
      lc_ede=code
      lc_eof_csp=.f.
      skip
      do while code=lc_ede and not eof()
         skip
      ENDDO
      IF csp.code<>drgtpt.code
         lc_ede=csp.code
         SELECT csp
         SEEK drgtpt.code
         IF NOT FOUND()
           replace drgtpt.valid WITH .f.
           WAIT WINDOW drgtpt.code+'- does not exist in CSP, removed from drgtpt- check!'
         ENDIF
         SELECT csp
         SEEK lc_ede
      endif
      select drgtpt
      loop
    endif
  case drgtpt.code=csp.code
    if not csp.tehty
      replace csp.tehty with .t.
    endif
    select drgtpt
    skip
    loop
  endcase
enddo

if eof()
  p_tarkier=p_tarkier+1
endif
select csp
set relation to code into drgtpt
set skip to drgtpt
if lc_no
  select drgtpt
endif
return