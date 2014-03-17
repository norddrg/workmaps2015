Procedure yhtnaytto
DEFINE WINDOW yhtveto FROM 5,6 TO max_y-5,max_x-5 title 'Summary of properties' FONT 'Courier New',8
activate window yhtveto
select csp
set filter to not released
clear
?? code at 1
if p_kieli='Com'
  ?? trim(text) at 27
else
  ?? p_kieli at 17
  ?? trim(text) at 27
  select csp_en
  ? csp.ncsp at 1
  ?? 'Com' at 10
  if csp.ncsp<>' '
    seek trim(csp.ncsp)
    if found()
      ?? csp_en.text at 27
    else
      ?? 'Not valid NCSP-EN code' at 27
    endif
  else
    ?? 'No mapping!' at 27
  endif
endif
select drgtpt
set filter to valid
if p_kieli<>'Com'
  select drgt_en
  set filter to valid
endif
? 'OR:' at 1
if p_kieli<>'Com'
  select drgt_en
  seek csp.ncsp+'OR'
  if found()
    ?? drgt_en.varval at 10
  endif
endif
select drgtpt
seek csp.code+'OR'
if found()
  ?? drgtpt.varval at 17
  do case
  case varval='1' 
    ?? 'OR-procedure' at 27
  case varval='2'
    ?? 'Significant procedure for outpatient' at 27
  otherwise
    ?? 'No OR' at 27
  endcase
else
  ?? 'No OR' at 27
endif
? 'CC:' at 1
if p_kieli<>'Com'
  select drgt_en
  seek csp.ncsp+'CC'
  if found()
    ?? drgt_en.varval at 10
  endif
endif
select drgtpt
seek csp.code+'CC'
if found()
  ?? drgtpt.varval at 17
  if varval='1' 
    ?? 'CC-procedure' at 27
  endif
else
  ?? 'No CC' at 27
endif
wait window 'To continue press any key'
? 'PROCPROP:' at 1
lc_n=0
select drgtpt
seek csp.code+'PROCPR'
if p_kieli<>'Com'
  select drgt_en
  seek csp.ncsp+'PROCPR'
endif
yh_loop=.t.
lh_en=.f.
lh_loc=.f.

do while yh_loop and not eof()
  ?
  if p_kieli<>'Com'
    lh_encode=drgt_en.varval
    lh_loccode=drgtpt.varval
    if drgt_en.code=csp.ncsp and drgt_en.vartype='PROCPR' ;
    and (lh_encode<=lh_loccode or drgtpt.vartype<>'PROCPR' or drgtpt.code<>csp.code)
      ?? drgt_en.varval at 10
      select tpomin
      seek trim(drgt_en.varval)
      select drgt_en
      if not eof()
        skip
      endif
    endif
    if drgtpt.code=csp.code and drgtpt.vartype='PROCPR' and (lh_loccode<=lh_encode or lh_en)
      ?? drgtpt.varval at 17
      lc_n=lc_n+1
      select tpomin
      seek trim(drgtpt.varval)
      select drgtpt
      if not eof()
        skip
      endif
    endif
  else
    lh_en=.t.
    if drgtpt.code=csp.code and drgtpt.vartype='PROCPR' and not eof()
      ?? drgtpt.varval at 17
      lc_n=lc_n+1
      select tpomin
      seek trim(drgtpt.varval)
      select drgtpt
      skip
    endif   
  endif
  select tpomin
  if found()  
    ?? trim(english) at 27
    ? trim(finish) at 27
  endif
  if p_kieli<>'Com'
    select drgt_en
    if drgt_en.code<>csp.ncsp or drgt_en.vartype<>'PROCPR' or eof()
      lh_en=.t.
    endif
  endif
  if drgtpt.code<>csp.code or drgtpt.vartype<>'PROCPR' or eof()
    lh_loc=.t.
  endif
  if lh_en and lh_loc
    exit
  endif
  if lc_n>(max_y-10)/3
    wait window 'To continue press any key'
    lc_n=1
    clear
  endif
enddo
if lc_n=0
  ? 'No procedure properties' at 27 
endif
? 'DGPROP:' at 1
lc_n=0
select drgtpt
seek csp.code+'DGPROP'
if p_kieli<>'Com'
  select drgt_en
  seek csp.ncsp+'DGPROP'
endif
yh_loop=.t.
lh_en=.f.
lh_loc=.f.
do while yh_loop and not eof()
  ?
  if p_kieli<>'Com'
    lh_encode=drgt_en.varval
    lh_loccode=drgtpt.varval
    if drgt_en.code=csp.ncsp and drgt_en.vartype='DGPROP' ;
    and (lh_encode<=lh_loccode or drgtpt.vartype<>'DGPROP' or drgtpt.code<>csp.code)
      ?? drgt_en.varval at 10
      select dgomin
      seek SUBSTR(drgt_en.varval,1,2)+SUBSTR(drgt_en.varval,4,2)+SUBSTR(drgt_en.varval,3,1)
      select drgt_en
      if not eof()
        skip
      endif
    endif
    if drgtpt.code=csp.code and drgtpt.vartype='DGPROP' and (lh_loccode<=lh_encode or lh_en)
      ?? drgtpt.varval at 17
      lc_n=lc_n+1
      select dgomin
      seek SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2)+SUBSTR(drgtpt.varval,3,1)
      select drgtpt
      if not eof()
        skip
      endif
    endif
  else
    lh_en=.t.
    if drgtpt.code=csp.code and drgtpt.vartype='DGPROP' and not eof()
      ?? drgtpt.varval at 17
      lc_n=lc_n+1
      select dgomin
      seek SUBSTR(drgtpt.varval,1,2)+SUBSTR(drgtpt.varval,4,2)+SUBSTR(drgtpt.varval,3,1)
      select drgtpt
      skip
    endif
  endif
  select dgomin
  if found()  
    ?? trim(english) at 27
    ? trim(finish) at 27
  endif
  if p_kieli<>'Com'
    select drgt_en
    if drgt_en.code<>csp.ncsp or drgt_en.vartype<>'DGPROP' or eof()
      lh_en=.t.
    endif
  endif
  if drgtpt.code<>csp.code or drgtpt.vartype<>'DGPROP' or eof()
    lh_loc=.t.
  endif
  if lh_en and lh_loc
    exit
  endif
  if lc_n>(max_y-10)/3
    lc_n=1
    wait window 'To continue press any key'
    clear
  endif
enddo
if lc_n=0
  ? 'No diagnosis properties' at 27
endif
wait window 'To continue, push any key!'
release window yhtveto
select drgtpt 
set filter to drgtpt.code=csp.code and valid
return

