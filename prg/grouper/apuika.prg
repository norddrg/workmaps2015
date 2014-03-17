Procedure apuika
select anal
goto top
do while not eof()
  if substr(syntaika,7,1)='A'
    lc_spv=ctod('20'+substr(syntaika,5,2)+'/'+substr(syntaika,3,2)+'/'+substr(syntaika,1,2))
  else
    lc_spv=ctod('19'+substr(syntaika,5,2)+'/'+substr(syntaika,3,2)+'/'+substr(syntaika,1,2))
  endif
  replace ika with pvalku-lc_spv
  replace ikavuo with ika/365.25
  select anal
  skip
enddo
return