Procedure non_or
public or_date
or_date=date()
if alias()<>'CSP'
  select csp
  wait window 'Valitse koodi' nowait
  browse last
  return
endif
select drgtpt
set order to code
seek csp.code+'OR'
if not found()
  set filter to
  seek csp.code+'OR'
  if found()
    replace valid with .t.
  endif
  set filter to valid
  seek csp.code+'OR'
endif
if not found()
  insert into drgtpt (code, vartype, varval, valid, chdate); 
  values (csp.code, 'OR', '0', .t., date())
  if p_kieli='Com'
    replace code_nc with csp.code
  else
    replace code_nc with csp.ncsp
  endif
else
  skip
  do while code=csp.code and vartype='OR' and not eof()
    replace valid with .f.
    skip
  enddo
  seek csp.code+'OR'
endif
lc_or=varval
if chdate<>date() and chdate<>ctod(space(8))
  or_date=chdate
endif
wait window '0=not OR-procedure, 1=regular surgery, 2=outpatient procedure'
do case
case lastkey()=49
  replace varval with '1'
case lastkey()=50
  replace varval with '2'
otherwise
  replace varval with '0'
endcase
if chdate=ctod(space(8))
  replace chdate with date()
else
  if lc_or <>varval
    wait window 'OR-property - which date for last change? A=96/06/01, V='+dtoc(or_date)+', T='+dtoc(date())
    do case
    case lastkey()=97 or lastkey()=65
      replace chdate with ctod('96/06/01')
    case lastkey()=116 or lastkey()=84
      replace chdate with date()
    otherwise
      replace chdate with or_date
    endcase
  endif
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
select drgtpt
set filter to valid
select csp
do csppaiv
return