Procedure apuvaiht
select ncsp_koo
lc_koodi=koodi
wait window 'Valitse muunnettava koodi'
browse last
delete
va_koodi=koodi
select drgtpt
replace next 10 for koodi =va_koodi koodi with lc_koodi
select link
replace ncsp with lc_koodi
select drgtpt
*replace koodi with lc_koodi 
do cspnaytto
return