Procedure puut
select ncsp_en
set relation to
do while not eof()
  select drgtpt
  seek ncsp_en.code
  if not found()
    wait window nowait 'Missing from DRGTPT?'
    exit
  endif
  if lastkey()=27
    exit
  endif
  select ncsp_en
  skip
enddo
select ncsp_en
set order to code
set relation to code into drgtpt
set skip to drgtpt
do cspnaytto
return