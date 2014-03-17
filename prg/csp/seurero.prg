Procedure seurero
if alias()='NCSP_EN'
  select ncsp_koo
endif
lc_alias=alias()
lc_koodi=koodi
select ncsp_luv
set filter to not deleted()
select ncsp_ryh
set filter to not deleted()
select ncsp_ala
set filter to not deleted()
select ncsp_koo
set filter to not deleted()
if lc_alias<>'NCSP_KOO'
   seek lc_koodi
endif
skip
do while not eof()
  lc_koodi=koodi
  select ncsp_en
  seek lc_koodi
  if not found()
    skip -1
    select ncsp_koo
    exit
  endif
  select ncsp_koo
  skip
  if substr(koodi,1,1)<>substr(lc_koodi,1,1)
    select ncsp_luv
    seek substr(ncsp_koo.koodi,1,1)
    select ncsp_en
    seek ncsp_luv.koodi
    if not found()
      select ncsp_luv
      exit
    endif
    select ncsp_koo
  endif
  if substr(koodi,1,2)<>substr(lc_koodi,1,2)  
    select ncsp_ryh
    seek substr(ncsp_koo.koodi,1,2)+space(3)
    if not found()
      select ncsp_en
      seek substr(ncsp_koo.koodi,1,2)
      if found()
        exit
      endif
    else
      select ncsp_en
      seek ncsp_ryh.koodi
      if not found()
        select ncsp_ryh
        exit
      endif
    endif
    select ncsp_koo
  endif
  if substr(koodi,1,3)<>substr(lc_koodi,1,3)  
    select ncsp_ala
    seek substr(ncsp_koo.koodi,1,3)
    if not found()
      select ncsp_en
      seek substr(ncsp_koo.koodi,1,3)+space(2)
      if found()
        exit
      endif
    else
      select ncsp_en
      seek ncsp_ryh.koodi
      if not found()
        select ncsp_ala
        exit
      endif
    endif
    select ncsp_koo
  endif
enddo
do nayt_en
return