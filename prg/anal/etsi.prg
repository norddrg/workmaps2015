procedure etsi
select anal
define window kh_apu from 5,5 to 14,30 Font 'Arial' 8 
activate window kh_apu
@ 1,1 say 'Ordered by: '+order()
@ 2,1 say 'Give the code to be searched for!'
do case
case order()='DRG'
  @ 3,1 get lc_kood picture '999'
case order()='OIR1'
  @ 3,1 get lc_kood picture '!99.99'
case order()='TP1'
  @ 3,1 get lc_kood picture '!!!99'
otherwise
  @ 3,1 say 'Unordered state, search not possible'
endcase
read
if lastkey()=27
  release window kh_apu
  return
endif
select ncxp_en
seek lc_kood
return