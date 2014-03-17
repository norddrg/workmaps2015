procedure tark
parameter lc_type
lc_loop=.t.
do while lc_loop
  if p_tarkier=1
    do ..\csp\tuplat
    if p_tarkier=3
      p_tarkier=0
      return
    endif
    goto top
  endif
  do ..\csp\puuttark
  if p_tarkier=0
    exit
  endif
  if p_tarkier>2
    exit
  endif
enddo
if lc_type <>'S'
  lc_apuc=csp.code
endif
if p_kieli='Com'
  lc_ncsp=code
  select language
  goto top
  do while not eof()
    if language.lan<>'Com'
      select csp_oth
      use ('..\..\ncsp\'+trim(language.lan)+'\csp') alias csp_oth
      set order to ncsp
      seek trim(lc_ncsp)
      do while trim(lc_ncsp)=trim(csp_oth.ncsp) and not eof()
        lc_code=code
        select drgt_oth
        use ('..\..\tabl_def\'+trim(language.lan)+'\drgtpt') alias drgt_oth
        set order to code
        seek (lc_code+'OR')
        do case
        case not found() 
          wait window lc_code+' '+trim(csp_oth.text)+' will be turned to '+ iif (drgtpt.varval='1', 'OR-', 'non-OR-')+'procedure in '+language.lan+'-file. [Y]es/[N]o'
          if lastkey()=121 or lastkey()=89
            if not found()
              append blank
            endif
            replace code with lc_code, code_nc with lc_ncsp, chdate with drgtpt.chdate, valid with .t., vartype with 'OR', varval with drgtpt.varval
          endif
        case found()
          lc_check=.f.
          if not (drgt_oth.valid and drgt_oth.varval=drgtpt.varval)
            wait window lc_code+' '+trim(csp_oth.text)+' will be turned to ';
            +iif (drgtpt.varval='1', 'OR-',iif(drgtpt.varval='2','day-surg-', 'non-OR-'))+'procedure in '+language.lan+'-file. [Y]es/[N]o'
            lc_check=.t.
          endif
          if not drgt_oth.valid
            replace drgt_oth.valid with .t.
          endif
          if lastkey()=121 or lastkey()=89 or lc_check
            replace chdate with drgtpt.chdate, varval with drgtpt.varval
          endif
        endcase
        select csp_oth
        set order to ncsp
        if not eof()
          skip
        endif
      enddo
    endif
    select language
    skip
  enddo
endif
if p_tarkier>2
  wait window 'End' nowait
endif
if lc_type <>'S'
  p_tarkier=0
  SELECT csp
  USE
  use ('../../ncsp/'+p_kieli+'/csp')
  set filter to not released
  set order to code
  SEEK lc_apuc
  do ..\csp\csppaiv
endif
return