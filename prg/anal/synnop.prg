Procedure synnop
select drgtpt
set order to koodi
lc_koodi=space(5)
goto top
lc_14=.t.
lc_kompl='0'
lc_or='0'
do while not eof()
   if koodi<>lc_koodi
     if not lc_14 and lc_or='1'
       lc_2=koodi
       append blank
       replace koodi with lc_koodi, tpomin with '99S90', kompl with lc_kompl, or with lc_or
       seek lc_2
     endif
     lc_14=.f.
     lc_koodi=koodi
     lc_kompl=kompl
     lc_or=or
   endif
   if substr(tpomin,1,3)='99S'
     lc_14=.t.
   endif
   select drgtpt
   skip
enddo