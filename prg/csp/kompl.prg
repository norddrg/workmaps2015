Procedure kompl
public cc_date
cc_date=date()
if alias()<>'CSP'
  select csp
  wait window 'Select the code' nowait
  browse last
endif
select drgtpt
set filter to
seek csp.code+'CC'
if not found()
  insert into drgtpt (code, vartype, varval, valid, chdate); 
  values (csp.code, 'CC', '1', .t., date())
  if p_kieli='Com'
    replace code_nc with csp.code
  else
    replace code_nc with csp.ncsp
  endif  
  replace chdate with date()
endif
recall
replace valid with .t.
skip
do while code=csp.code and vartype='CC'
  replace valid with .f.
  delete
  select drgtpt
  skip
enddo
seek csp.code+'CC'
lc_val=varval
wait window csp.code+' '+trim(csp.text)+' - 0=no CC-property, 1=CC procedure'
do case
case lastkey()=49
  replace varval with '1'
otherwise
  replace varval with '0'
  replace valid with .f.
endcase
if chdate=ctod(space(8))
  replace chdate with date()
else
  or_date=chdate
  if lc_val <>varval
    wait window 'CC-property - which date for last change? A=96/06/01, V='+dtoc(or_date)+', T='+dtoc(date())
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
  lc_ncsp=drgtpt.code
  select language
  goto top
  do while not eof()
    if language.lan<>'Com'
      select csp_oth
      use ('..\..\ncsp\'+language.lan+'\csp') alias csp_oth
      set order to ncsp
      set filter to not released
      seek trim(lc_ncsp)
      do while trim(csp_oth.ncsp)=trim(lc_ncsp)
        lc_code=code
        set order to code
        select drgt_oth
        use ('..\..\tabl_def\'+trim(language.lan)+'\drgtpt') alias drgt_oth
        set order to code
        set filter to
        seek (lc_code+drgtpt.vartype)
        if (drgtpt.varval='1' and not found()) or (found() and varval<>drgtpt.varval)
          if drgtpt.varval='1'
            wait window lc_code+' '+trim(csp_oth.text)+' - '+language.lan +' - will changed to CC procedure. Y(es)/N(o)'
          else
            wait window lc_code+' '+trim(csp_oth.text)+' - '+language.lan +' - will changed to non-CC procedure. Y(es)/N(o)'
          endif
          if lastkey()=121 or lastkey()=89
            if not found()
               append blank
            endif
            replace code with lc_code, code_nc with lc_ncsp, chdate with date(),; 
            valid with drgtpt.valid, vartype with 'CC', varval with drgtpt.varval
          endif
        endif
        select csp_oth
        set order to ncsp
        skip
      enddo
    endif
    select language
    skip
  enddo
endif
set filter to not deleted()
select drgtpt
set filter to valid
select csp
do csppaiv
return