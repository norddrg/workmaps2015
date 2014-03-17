Procedure tuplat
select csp
set relation to
select drgtpt
goto top
  lc_koodi=' '
  lc_varval=' '
  lc_vartype=' '
do while not eof()
  if code=lc_koodi and varval=lc_varval and vartype=lc_vartype 
    replace valid with .f.
    delete
    skip
    loop
  endif
  if code=lc_koodi and vartype='OR' and lc_vartype='OR'
    skip -1
    if varval='0'
      replace valid with .f.
      delete
      skip 2
      loop
    endif
    wait window 'Virhe OR:ssä'
    select csp
    seek drgtpt.code
    select csp
    do ../csp/csppaiv
    select csp
    p_tarkier=3
*    if p_kieli<>'Com'
*      set relation to ncsp into csp_en additive
*    endif
    return
  endif
  lc_koodi=code
  lc_varval=varval
  lc_vartype=vartype
  skip
enddo
*if p_kieli<>'Com'
*  set relation to code into csp_en additive
*endif
return