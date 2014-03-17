procedure pari
select drgtpt
lc_koodi='   '
do while not eof()
   if or<'1'
     select drgtpt
     skip
     loop
   endif
   if lc_koodi<>koodi
     lc_traum=.f.
     lc_koodi=koodi
   endif
   if tpomin='24S01' or tpomin='24S02'or tpomin='24S03' 
       lc_traum=.t.
   endif
   select drgtpt
   skip
   if koodi<>lc_koodi
     if not lc_traum
       skip -1
       exit
     endif
   endif
enddo
select ncsp_koo
seek drgtpt.koodi
do naytto
return