Procedure ord_corr
select anal
set order to id
goto bottom
lc_count=val(substr(id,5,6))
lc_id=space (15)
goto top
do while not eof()
  if id=lc_id
    lc_id=id
    lc_count=lc_count+1
    replace id with 'TEST'+str(lc_count,6)
    seek (lc_id)
  endif
  lc_id=id
  select anal
  skip
enddo
return