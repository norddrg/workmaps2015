Procedure apu2
goto top
do while not eof()
  if at ('90I01',kompkat)>0
    replace drg_ext4 with 'COMPL'
  endif
  skip  
enddo
return