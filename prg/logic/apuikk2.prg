procedure apuikk2
lc_recno=recno()
set filter to recno()=lc_recno
edit
wait window 'Select N - no changes or Y - changes'
if not (lastkey()=110 or lastkey()=78)
  replace chdate with date()
endif
set filter to
release window apuikk
return

