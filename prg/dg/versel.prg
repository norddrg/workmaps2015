procedure versel
select language
goto top
do while not eof()
  if language.lan<>'Com'
    select icd_oth
    use ('..\..\icd_10\'+trim(language.lan)+'\icd_10') alias icd_oth
    set order to code_w
    set filter to valid
    select dg_oth
    use ('..\..\tabl_def\'+trim(language.lan)+'\drgdg') alias dg_oth
    set filter to valid
    set order to code
    select komplex_oth
    use ('..\..\tabl_def\'+trim(language.lan)+'\komplex') alias komplex_oth
    set filter to valid
    set order to code
    do othverup
    do othcexup
  endif
  select language
  skip
enddo
return