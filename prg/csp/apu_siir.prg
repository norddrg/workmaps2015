Procedure apu_siir
select drgtpt
goto top
do while not eof()
  if drgtpt.procprop<>' '
    select aputpt
    seek drgtpt.code
    do while drgtpt.code=code
      if not (drgtpt.code_nc=code_nc and drgtpt.code_f=code_f and drgtpt.code_d=code_d and drgtpt.code_s=code_s ;
      and drgtpt.code_n=code_n and vartype='PROCPR' and  varval=drgtpt.procprop)
        exit
      endif
      skip
    enddo
    if not (drgtpt.code_nc=code_nc and drgtpt.code_f=code_f and drgtpt.code_d=code_d and drgtpt.code_s=code_s;
    and drgtpt.code_n=code_n and vartype='PROCPR' and  varval=drgtpt.procprop)
      insert into aputpt (chdate, valid, language, code, code_nc, code_f, code_d, code_s, code_n, vartype, varval);
      values(drgtpt.chdate, drgtpt.valid, drgtpt.language, drgtpt.code, drgtpt.code_nc, drgtpt.code_f, drgtpt.code_d,; 
      drgtpt.code_s, drgtpt.code_n, 'PROCPR', drgtpt.procprop)
    endif
  endif
  if drgtpt.dgprop<>' '
    select aputpt
    seek drgtpt.code
    do while drgtpt.code=code
      if not (drgtpt.code_nc=code_nc and drgtpt.code_f=code_f and drgtpt.code_d=code_d and drgtpt.code_s=code_s;
      and drgtpt.code_n=code_n and vartype='DGPROP' and  varval=drgtpt.dgprop)
        exit
      endif
      skip
    enddo
    if not (drgtpt.code_nc=code_nc and drgtpt.code_f=code_f and drgtpt.code_d=code_d and drgtpt.code_s=code_s;
    and drgtpt.code_n=code_n and vartype='DGPROP' and  varval=drgtpt.dgprop)
      insert into aputpt (chdate, valid, language, code, code_nc, code_f, code_d, code_s, code_n, vartype, varval);
      values(drgtpt.chdate, drgtpt.valid, drgtpt.language, drgtpt.code, drgtpt.code_nc, drgtpt.code_f, drgtpt.code_d,; 
      drgtpt.code_s, drgtpt.code_n, 'DGPROP', drgtpt.dgprop)
    endif
  endif
  if drgtpt.or='1'
    select aputpt
    seek drgtpt.code+'OR'+space(6)+'1'
    if not found()
      insert into aputpt (chdate, valid, language, code, code_nc, code_f, code_d, code_s, code_n, vartype, varval);
      values(drgtpt.chdate, drgtpt.valid, drgtpt.language, drgtpt.code, drgtpt.code_nc, drgtpt.code_f, drgtpt.code_d,; 
      drgtpt.code_s, drgtpt.code_n, 'OR', drgtpt.or)
    endif
  endif
  if drgtpt.compl='1'
    select aputpt
    seek drgtpt.code+'CC'+space(6)+'1'
    if not found()
      insert into aputpt (chdate, valid, language, code, code_nc, code_f, code_d, code_s, code_n, vartype, varval);
      values(drgtpt.chdate, drgtpt.valid, drgtpt.language, drgtpt.code, drgtpt.code_nc, drgtpt.code_f, drgtpt.code_d,; 
      drgtpt.code_s, drgtpt.code_n, 'CC', drgtpt.or)
    endif
  endif
  select drgtpt
  skip
enddo
return