Procedure linklis
select ncsp_koo
set relation to
goto top
do while not eof()
  select link
  seek ncsp_koo.koodi
  if not found()
    insert into link (ncsp, icd9cm_o) values (ncsp_koo.koodi, '?')
  endif
  select ncsp_koo
  skip
enddo
do ncsp
return