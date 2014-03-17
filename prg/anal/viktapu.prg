Procedure viktapu
goto top
do while not eof()
  lc_dg=space(5)
  if bviktbs>0
    do case
    case bviktbs<2500
      lc_dg='P07.12'
    case bviktbs<2000
      lc_dg='P07.11'
    case bviktbs<1500
      lc_dg='P07.10'
    case bviktbs<1000
      lc_dg='P07.02'
    case bviktbs<750
      lc_dg='P07.01'
    case bviktbs<500
      lc_dg='P07.00'
    endcase
    if oir1=' '
      replace oir1 with lc_dg
      replace oir2 with yors1
      replace oir3 with yors2
    else
      if oir2=' '
        replace oir2 with lc_dg
        replace oir3 with yors1
        replace oir4 with yors2
      else
         if oir3=' '
           replace oir3 with lc_dg
           replace oir4 with yors1
           replace oir5 with yors2
         else
           if oir4=' '
             replace oir4 with lc_dg 
             replace oir5 with yors1
             replace oir6 with yors2
           else
             if oir5=' '
               replace oir5 with lc_dg
               replace oir6 with yors1
               replace oir7 with yors2
             else
               if oir6=' '
                 replace oir6 with lc_dg
                 replace oir7 with yors1
                 replace oir8 with yors2
               else
                 if oir7 =' '
                   replace oir7 with lc_dg
                   replace oir8 with yors1
                   replace oir9 with yors2
                 else
                   if oir8= ' '
                     replace oir8 with lc_dg
                     replace oir9 with yors1
                   else
                     replace oir9 with lc_dg
                   endif
                 endif
               endif
             endif
           endif
         endif
       endif
    endif
  endif
  skip
enddo
return