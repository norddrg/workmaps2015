procedure outcheck
select drgtpt
set filter to valid
goto top
ou_varval='99O'
do while not eof()
  if not (vartype='OR' and varval='2')
    skip
    loop
  endif
  ou_code=code
  seek ou_code+'PROCPR  '+'99O'
  if found()
    skip
    loop
  endif
  select csp
  seek ou_code
  select tpomin
  seek ou_varval
  select csp
  wait window ou_code + trim(csp.text) + ' - OR=2 procedure without 99O-procedure!'
  do siir
  wait window 'Continued search for OR=2 codes'
  select drgtpt
  set order to code
  set filter to valid
  seek ou_code+'PROCPR  '+'99O'
  ou_varval=varval
  skip
enddo