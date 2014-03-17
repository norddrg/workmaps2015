proc apu
select anal
set order to id
goto bottom
lc_newid= val(substr(id,5,10))+1
goto top
lc_oldid=-1
do while not eof()
  lc_nextid=val(substr(id,5,10))
  if lc_oldid=lc_nextid
    replace id with 'TEST'+str(lc_newid,6)
    lc_newid=lc_newid+1
    goto top
    loop
  endif
  lc_oldid=lc_nextid
  skip  
enddo
return