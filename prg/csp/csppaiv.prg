PROCEDURE csppaiv
lc_link=.f.
lc_alias=ALIAS()
if alias()='TPOMIN' or alias()='DGOMIN'
  if alias()='TPOMIN'
    lc_omin=tpomin.procprop
  else
    lc_omin=dgomin.dgprop
  endif
  if p_order='N'
    select csp
    set skip to 
    set order to code
  endif
  select drgtpt
  set relation to
  set order to varval
  set relation to code into csp
  set skip to csp
  set filter to csp.code<>' '
  if lc_alias='TPOMIN'
    seek 'PROCPR  '+lc_omin
    select tpomin
  else
    seek 'DGPROP  '+lc_omin
    select dgomin
  endif
else
  select csp
  if alias()='DRGTPT'
    pa_code=drgtpt.code
  else
    pa_code=ncsp
  endif
  select drgtpt
  set order to code
endif
select (lc_alias)
DO ..\csp\cspnaytto
RETURN
*: EOF: csppaiv.PRG

Procedure dt_tark
if csp.ncsp=' '
  return
endif
select drgtpt
seek csp.code
if not found() or drgtpt.varval=' '  
  select drgt_en
  seek csp.ncsp
  do while drgt_en.code=csp.ncsp and not eof()
    insert into drgtpt (chdate, code, valid, code_nc, vartype, varval);
    values (date(), csp.code, .t., csp.ncsp, drgt_en.vartype, drgt_en.varval)
    select drgt_en
    skip 
  enddo
endif
select csp
return