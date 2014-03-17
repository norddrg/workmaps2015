procedure vaihto
deactivate window comm
p_ldrg=anal.drg
p_ord=anal.ord
select anal
if not (oir1=p_ldg or oir2=p_ldg or oir3=p_ldg or oir4=p_ldg or oir5=p_ldg or oir5=p_ldg or oir6=p_ldg or oir7=p_ldg or oir8=p_ldg)
  p_ldg=anal.oir1
endif
if not (tp1=p_lproc or tp2=p_lproc or tp3=p_lproc or tp4=p_lproc or tp5=p_lproc or tp6=p_lproc or tp7=p_lproc or tp8=p_lproc)
  if anal.tp1<>' '
    p_lproc=anal.tp1
  endif
endif
do case
case lastkey()=-1
  do ..\logic\drglogi
case lastkey()=-2
  do ..\dg\_dgdrg
otherwise
  do ..\csp\ncsp
endcase
return