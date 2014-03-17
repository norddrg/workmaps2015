procedure drgkir1
select drgdistr
goto top
do while not eof()
  activate window anal
  browse in window anal save 
  do drgkir
  select drgdistr
  skip
enddo
return
