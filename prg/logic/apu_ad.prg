Procedure apu_ad
select drglogic
set filter to agelim='-'
replace all agelim with '<'+ltrim(str(val(substr(agelim,2,5))+1))
set filter to agelim<>' ' and agelim<> '<'
replace all agelim with '>'+agelim
set filter to dur='-'
replace all dur with '<'+ltrim(str(val(substr(dur,2,5))+1))
set filter to dur<>' ' and dur <>'<'
replace all dur with '>'+dur
set filter to
return
