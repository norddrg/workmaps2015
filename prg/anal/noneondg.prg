Procedure noneondg
select dg
set order to icd_10_o
lc_o=space(5)
goto top
lc_14=.t.
lc_e=space(5)
lc_kompl=space(5)
lc_tpomin=space(5)
lc_dgkat=space(5)
lc_pdgomin=' '
do while not eof()
   if icd_10_e<>' '
     skip
     loop
   endif
   if substr(icd_10_o,1,1)='V' or substr(icd_10_o,1,1)='W' or substr(icd_10_o,1,1)='Y' or substr(icd_10_o,1,1)='X';
   or substr(icd_10_o,1,1)='O' or substr(icd_10_o,1,1)='F'
       skip
       loop
   endif
   if icd_10_o<>lc_o 
     if not lc_14 
       lc_2=icd_10_o
       seek lc_o
       do while icd_10_o=lc_o
           if dgomin=' '
              exit
            endif
            skip
            loop
       enddo
       if dgomin<>' '
          append blank
          replace icd_10_o with lc_o,  dgkat with lc_dgkat, pdgomin with lc_pdgomin, dgomin with '15X90', ;
          kompl with lc_kompl, tpomin with lc_tpomin
       else
           replace dgomin with '15X90'
       endif
       seek lc_2
     endif
     lc_14=.f.
     lc_o=icd_10_o
     lc_dgkat=dgkat
     lc_pdgomin=pdgomin
     lc_kompl=kompl
     lc_tpomin = tpomin
   endif
   if substr(dgomin,1,3)='15X'
     lc_14=.t.
   endif
   select dg
   skip
enddo