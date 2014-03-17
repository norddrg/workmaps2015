Procedure casesel
parameter lc_haku, lc_kier, lc_suun
select anal
lc_ldg=trim(p_ldg)
lc_lproc=trim(p_lproc)
if lc_kier='F'
  if (drg=p_ldrg or p_ldrg='   ') and;
  (oir1=p_ldg or oir2=p_ldg or oir3=p_ldg or oir4=p_ldg or oir5=p_ldg or oir5=p_ldg or oir6=p_ldg or oir7=p_ldg or oir8=p_ldg or p_ldg=' ');
  and (tp1=p_lproc or tp2=p_lproc or tp3=p_lproc or tp4=p_lproc or tp5=p_lproc or tp6=p_lproc or tp7=p_lproc or tp8=p_lproc or p_lproc=' ')
    skip
  else
    seek lc_haku
  endif
else
  if lc_suun='N'
    skip
  else
    skip -1
  endif
endif
lc_n=0
lc_loop=.t.
do while lc_loop
  lc_sel=2
  if p_ldrg='   ' and p_ldg=' '
    lc_sel=1
  endif
  if p_ldrg='   ' and p_lproc=' '
    lc_sel=1
  endif
  if p_ldg=' ' and p_lproc=' '
    lc_sel=1
  endif
  if drg=p_ldrg and not p_ldrg='   '
    lc_sel=lc_sel-1
  endif
  if (oir1=lc_ldg or oir2=lc_ldg or oir3=lc_ldg or oir4=lc_ldg or oir5=lc_ldg or oir5=lc_ldg or oir6=lc_ldg or oir7=lc_ldg or oir8=lc_ldg) and not p_ldg=' '
    lc_sel=lc_sel-1
  endif
  if (tp1=lc_lproc or tp2=lc_lproc or tp3=lc_lproc or tp4=lc_lproc or tp5=lc_lproc or tp6=lc_lproc or tp7=lc_lproc or tp8=lc_lproc) and not p_lproc=' '
    lc_sel=lc_sel-1
  endif
  if lc_sel<1
    exit
  endif
  if  eof() or bof()
    wait window 'Case not found! Continue with [Enter]!' 
    if lc_suun='N'
      skip (-(lc_n+1))
    else
      skip (lc_n)
    endif
    exit
  endif
  lc_n=lc_n+1
  select anal
  if lc_suun='N'
    skip
  else
    skip -1
  endif
enddo
if bof()
  skip
endif
if eof()
  skip -1
endif
return
