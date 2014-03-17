procedure etsi
lc_kood=space(6)
define window kh_apu from 5,5 to 14,90 Font 'Arial' 8 
activate window kh_apu
select drglogic
et_loop=.t.
do while et_loop
  @ 1,1 say 'Order: '+order()
  @ 2,1 say 'Give the code for searching, accept'
  @ 3,1 say ' Toggle order - [TAB]'
  do case
  case order()= 'ORD'
    @ 5,1 get lc_kood picture '999D999999' 
  case order()= 'MDC'
    @ 5,1 get lc_kood picture '99!' 
  case order()= 'DRG'
    @ 5,1 get lc_kood picture '9!!!!'  
  endcase
  read
  if lastkey()=9
    do case
    case order()='ORD'
      set order to MDC
    case order()='MDC'
      set order to 'DRG'
    case order()='DRG'
      set order to ORD
    endcase
    loop
  endif
  if lastkey()=13
    exit
  endif
enddo
release window kh_apu
if lastkey()=27
  return
endif
select drglogic
set near on
seek trim(lc_kood)
if order()='DRG'
  if not found()and len(trim(lc_kood))<4
    seek (substr('0'+lc_kood,1,4))
    if not found() and len(trim(lc_kood))<3
      seek (substr('00'+lc_kood,1,4))
    endif
  endif
  if not found()
    wait window nowait 'No match with the string you searched!'
    ? chr(7)+ chr(7)+chr(7)
  endif
endif
do lognaytto
return