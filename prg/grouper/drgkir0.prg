procedure drgkir0
wait window 'Do you want to produce single DRG file (S) one MDC (M) or all MDC files (A)'
do case
case lastkey()=65 or lastkey()=97
  select 0
  use ..\..\tabl_def\dgkat
  set order to dgcat
  set filter to len(trim(dgcat))=2
    goto top
  skip
  do while not eof()
    do drgkir2 with dgcat
    select dgkat
    skip
  enddo
  select dgkat
  use
case lastkey()= 77 or lastkey()=109
  wait window nowait 'Select one row from the MDC you want to analyze, accept with [Ctrl][W]'
  select drgdistr
  activate window anal
  browse in window anal save 
  if not mdc<='99'
    wait window 'You have to select a valid DRG in DRGDISTR-file' nowait
    return
  endif
  do drgkir2 with mdc
otherwise
  wait window nowait 'Select the DRG you want to analyze, accept with [Ctrl][W]'
  select drgdistr
  activate window anal
  browse in window anal save 
  do drgkir
endcase
return
