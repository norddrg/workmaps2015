Procedure codecorr
lc_dg=space(7)
select anal
set order to
goto top
do while not eof()
  do dgcorr with oir1
  if lc_dg<>oir1
    replace oir1 with lc_dg
  endif
  if syy1<>' '
    do dgcorr with syy1
    if lc_dg<>syy1
      replace syy1 with lc_dg
    endif
  endif
  if oir2<>' '
    do dgcorr with oir2
    if lc_dg<>oir2
      replace oir2 with lc_dg
    endif
    if syy2<>' '
      do dgcorr with syy2
      if lc_dg<>syy2
        replace syy2 with lc_dg
      endif
    endif
    if oir3<>' '
      do dgcorr with oir3
      if lc_dg<>oir3
        replace oir3 with lc_dg
      endif
      if syy3<>' '
        do dgcorr with syy3
        if lc_dg<>syy3
          replace syy3 with lc_dg
        endif
      endif
      if oir4<>' '
        do dgcorr with oir4
        if lc_dg<>oir4
          replace oir4 with lc_dg
        endif
        if syy4<>' '
          do dgcorr with syy4
          if lc_dg<>syy4
            replace syy4 with lc_dg
          endif
        endif
        if oir5<>' '
          do dgcorr with oir5
          if lc_dg<>oir5
            replace oir5 with lc_dg
          endif
          if syy5<>' '
            do dgcorr with syy5
            if lc_dg<>syy5
              replace syy5 with lc_dg
            endif
          endif
          if oir6<>' '
            do dgcorr with oir6
            if lc_dg<>oir6
              replace oir6 with lc_dg
            endif
            if syy6<>' '
              do dgcorr with syy6
              if lc_dg<>syy6
                replace syy6 with lc_dg
              endif
            endif
            if oir7<>' '
              do dgcorr with oir7
              if lc_dg<>oir7
                replace oir7 with lc_dg
              endif
              if syy7<>' '
                do dgcorr with syy7
                if lc_dg<>syy7
                  replace syy7 with lc_dg
                endif
              endif
              if oir8<>' '
                do dgcorr with oir8
                if lc_dg<>oir8
                  replace oir8 with lc_dg
                endif
                if syy8<>' '
                  do dgcorr with syy8
                  if lc_dg<>syy8
                    replace syy8 with lc_dg
                  endif
                endif
                if oir9<>' '
                  do dgcorr with oir9
                  if lc_dg<>oir9
                    replace oir9 with lc_dg
                  endif
                  if syy9<>' '
                    do dgcorr with syy9
                    if lc_dg<>syy9
                      replace syy9 with lc_dg
                    endif
                  endif
                endif
              endif
            endif
          endif
        endif
      endif
    endif
  endif
  
  select anal
  skip
enddo
return

procedure dgcorr
parameter dgc_dg
lc_dg=dgc_dg
select icd_10
seek dgc_dg
if not found()
  dgc_dg=substr(dgc_dg,1,5)
  seek dgc_dg
  if not found()
    seek (dgc_dg+'9')
    if found()
      dgc_dg=dgc_dg+'9'
    else
      dgc_dg=substr(dgc_dg,1,3)
      seek dgc_dg
        if not found()
          seek (dgc_dg+'.9')
          if found()
            dgc_dg=dgc_dg+'.9'
          else
            if substr(dgc_dg,1,1)>'9' and substr(dgc_dg,4,1)>'9'
              dgc_dg='T50.9'
            endif
          endif
        endif
    endif   
  endif
endif
lc_dg=dgc_dg
select anal
return