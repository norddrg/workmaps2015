Procedure inuse
select dg
select dg
lc_ord=order()
set order to varval
set filter to valid
select drgtpt
lc_ordtp=order()
set order to varval
select drglogic
replace inuse with .t.
  if pdgprop<>' '
    select dg
    seek 'PDGPRO  '+SUBSTR(drglogic.pdgprop,1,2)+SUBSTR(drglogic.pdgprop,4,2)+SUBSTR(drglogic.pdgprop,3,1)
    if not found()
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if procpro1<>' '
    pr_found=.f.
    select dg
    seek 'PROCPR  '+SUBSTR(drglogic.procpro1,1,2)+SUBSTR(drglogic.procpro1,4,2)+SUBSTR(drglogic.procpro1,3,1)
    if found()
      pr_found=.t.
    else
      if drglogic.procpro1='99S'
        pr_found=.t.
      endif
    endif
    if not pr_found
      select drgtpt
      seek 'PROCPR  '+drglogic.procpro1
      if found()
        pr_found=.t.
      endif
    endif
    if not pr_found
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if dgcat1<>' '
    select dg
    seek 'DGCAT   '+SUBSTR(drglogic.dgcat1,1,2)+SUBSTR(drglogic.dgcat1,4,2)+SUBSTR(drglogic.dgcat1,3,1)
    if not found() and substr(drglogic.dgcat1,1,2)='12' or substr(drglogic.dgcat1,1,2)='13'
      seek 'DGCAT   '+'98'+SUBSTR(drglogic.dgcat1,4,2)+SUBSTR(drglogic.dgcat1,3,1)
    endif
    if not found()      
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if dgprop1<>' '
    lc_dgprop=dgprop1
    if dgprop1='-'
      lc_dgprop=substr(dgprop1,2,5)
    endif
    select dg
    seek 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if not found() 
      select drgtpt
      seek 'DGPROP  '+trim(lc_dgprop)
    endif
    if not found() and substr(lc_dgprop,3,3)<>'X99'
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if dgprop2<>' '
    lc_dgprop=dgprop2
    if dgprop2='-'
      lc_dgprop=substr(dgprop2,2,5)
    endif
    select dg
    seek 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if not found()
      select drgtpt
      seek 'DGPROP  '+trim(lc_dgprop)
    endif
    if not found()
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if dgprop3<>' '
    lc_dgprop=dgprop3
    if dgprop3='-'
      lc_dgprop=substr(dgprop3,2,5)
    endif
    select dg
    seek 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if not found()
      select drgtpt
      seek 'DGPROP  '+trim(lc_dgprop)
    endif
    if not found()
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if dgprop4<>' '
    lc_dgprop=dgprop4
    if dgprop4='-'
      lc_dgprop=substr(dgprop4,2,5)
    endif
    select dg
    seek 'DGPROP  '+SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
    if not found()
      select drgtpt
      seek 'DGPROP  '+trim(lc_dgprop)
    endif
    if not found()
      replace drglogic.inuse with .f.
    endif
  endif
  select drglogic
  if secproc1<>' ' and secproc1<>'+' and secproc1<>'- '
    if secproc1<>'-'
      lc_secproc=trim(secproc1)
    else
      lc_secproc=substr(secproc1,2,5)
    endif
    select dg
    seek 'PROCPR  '+SUBSTR(lc_secproc,1,2)+SUBSTR(lc_secproc,4,2)+SUBSTR(lc_secproc,3,1)
    if not found()
      select drgtpt
      seek 'PROCPR  '+ lc_secproc
    endif
    if not found() and drglogic.secproc1<>'-'
      replace drglogic.inuse with .f.
    endif
  endif
select dg
set order to (lc_ord)
set filter to valid
select drgtpt
set order to (lc_ordtp)
select drglogic
return

