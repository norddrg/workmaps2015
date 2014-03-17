Procedure husapu
select anal
do while not eof()
  do case
  case jh_hi='11'
    replace discstat with 'R'
  case hoitois='8'
    replace discstat with 'E'
  endcase
  if oir1=' '
    replace oir1 with syy1
    replace syy1 with ' '
  endif
  if oir2=' '
    replace oir2 with syy2
    replace syy2 with ' '
  endif
  if oir3=' '
    replace oir3 with syy3
    replace syy3 with ' '
  endif
  if oir4=' '
    replace oir4 with syy4
    replace syy4 with ' '
  endif
  if oir5=' '
    replace oir5 with syy5
    replace syy5 with ' '
  endif
  select anal
  skip
enddo
return