procedure apukoe
t_alku=val(sys(2))
select anal
goto top
do while not eof()
  lc_drg=drg
  if drg=lc_drg
    replace drg with lc_drg
  endif
  skip
enddo
wait window str(val(sys(2))-t_alku,10,0)+' seconds' 
return
