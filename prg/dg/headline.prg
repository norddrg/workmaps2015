Procedure headline
selec icd10
goto top
do while not eof()
   replace icd_10.headline with .f.
   if len(trim(icd_10_1))=3
     lc_koodi=icd_10_1
     skip
     if substr(icd_10_1,1,3)=substr(lc_koodi,1,1) and len(trim(icd_10_1))>3
        skip -1
        replace icd_10.headline with .t., tehty with .t.
     else 
       loop
     endif
   endif
   skip
enddo
return