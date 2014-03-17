procedure etsi
lc_kood=space(6)
define window kh_apu from 5,5 to 14,30 Font 'Arial' 8 
activate window kh_apu
@ 1,1 say 'Order: '+order()
@ 2,1 say 'Give a code for searching'
@ 3,1 get lc_kood picture '!!!!!!'
read
if lastkey()=27
  release window kh_apu
  return
endif
*if len(trim(lc_kood))>3
*  if substr(lc_kood,3,1)>'.' and substr(lc_kood,3,1)<='9'
*    lc_kood=substr(lc_kood,1,3)+'.'+substr(lc_kood,3,2)
*  endif
*endif
select ncxp_en
seek lc_kood
do paivitys
return