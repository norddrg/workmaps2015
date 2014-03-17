Procedure checkprop
select drglogic
if inuse
  select drgnames
  set filter to
  seek drglogic.drg
  if found()
    replace valid with .t.
  else
    wait window 'No name for this DRG! Push any key to continue'
  endif
  select drglogic
  if mdc<>' '
    select dgkat
    seek drglogic.mdc
    if not found()
       wait window nowait 'Not a valid MDC'
       do apuikk2
    endif
  endif
endif
return