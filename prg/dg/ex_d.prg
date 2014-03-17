Procedure ex_d
select icd_10
set order to code
select kompkat
set order to compl
set filter to valid
select ex_d
set filter to not deleted()
set order to kompcat
goto top
set console off
set printer to ..\ex_d.txt
set printer on
do while not eof()
  select ex_d
  select kompkat
  seek SUBSTR(ex_d.kompcat,1,2)+SUBSTR(ex_d.kompcat,4,2)+SUBSTR(ex_d.kompcat,3,1)
  lc_kompcat=ex_d.kompcat
  ? '------------------------------------'
  ? ex_d.kompcat + kompkat.english
  seek trim(ex_d.code+ex_d.d_code)
  do while lc_kompcat=ex_d.kompcat
    ?
    if ex_d.muutos='+' 
      ? 'Added diagnoses:'
    else
      ? 'Deleted diagnoses:'
    endif
    lc_muutos=ex_d.muutos
    do while lc_muutos=ex_d.muutos and lc_kompcat=ex_d.kompcat
      select icd_10
      seek trim(ex_d.code+ex_d.d_code)
      ? ex_d.code+' '+ex_d.d_code+' '+icd_10.text
      select ex_d
      skip
    enddo
  enddo
  ? 'Comments: '
  ?
enddo
set printer to
set printer off
return