Procedure apu
goto top
do while not eof()
  if ((oir2>='Y58' and oir2<='Y69') or oir2='Y83' or oir2='Y84' or oir2='Y88' or oir2='Y95.0');
  or ((oir3>='Y58' and oir3<='Y69') or oir3='Y83' or oir3='Y84' or oir3='Y88' or oir3='Y95.0');
  or ((oir4>='Y58' and oir4<='Y69') or oir4='Y83' or oir4='Y84' or oir4='Y88' or oir4='Y95.0');
  or ((oir5>='Y58' and oir5<='Y69') or oir5='Y83' or oir5='Y84' or oir5='Y88' or oir5='Y95.0');
  or ((oir6>='Y58' and oir6<='Y69') or oir6='Y83' or oir6='Y84' or oir6='Y88' or oir6='Y95.0');
  or ((oir7>='Y58' and oir7<='Y69') or oir7='Y83' or oir7='Y84' or oir7='Y88' or oir7='Y95.0');
  or ((oir8>='Y58' and oir8<='Y69') or oir8='Y83' or oir8='Y84' or oir8='Y88' or oir8='Y95.0');
  or ((oir9>='Y58' and oir9<='Y69') or oir9='Y83' or oir9='Y84' or oir9='Y88' or oir9='Y95.0')
    replace drg_ext4 with 'COMPL'
  endif
  skip  
enddo
return