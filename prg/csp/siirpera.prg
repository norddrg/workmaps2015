Procedure siirpera
lc_omin=tpomin.procprop
lc_alias=alias()
select csp
if code=lc_alku
  seek (lc_loppu)
else
  lc_alku = code
endif
wait window 'First code '+lc_alku+'. Choose the last code. Continue [Ctrl][W]. Cancel [Esc]' nowait
do case
case p_kieli='Fin'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40,csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.finish,iif(drgtpt.vartype='PROCPR',tpomin.finish,'***')):70,;
  SAVE 
case p_kieli='Com'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.english:R:40,;
  drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  SAVE 
otherwise
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40, csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  SAVE 
endcase
if lastkey()=27
  do cspnaytto
  return
endif
lc_loppu=csp.code
if lc_alku>lc_loppu
  wait window 'Reverse order! OK? [Esc]-Cancel [Enter]-Continue'
  if lastkey()=27
    do cspnaytto
    return
  endif
  lc_apu=lc_alku
  lc_alku=lc_loppu
  lc_loppu=lc_apu
endif
seek lc_alku
do case
case p_kieli='Fin'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40,csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.finish,iif(drgtpt.vartype='PROCPR',tpomin.finish,'***')):70,;
  SAVE NOWAIT
case p_kieli='Eng'
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.english:R:40,;
  drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  SAVE NOWAIT
otherwise
  BROWSE WINDOW koodit noedit nodelete FIELDS drgtpt.chdate:6, csp.code:7:R, csp.text:R:40, csp.ncsp:7:R,;
  csp_en.english:40:R, drgtpt.vartype:8, drgtpt.varval:7,; 
  vartext=iif(drgtpt.vartype='DGPROP', dgomin.english,iif(drgtpt.vartype='PROCPR',tpomin.english,'***')):70,;
  SAVE NOWAIT
endcase
if lc_alias<>'TPOMIN'
  select tpomin
  wait window 'Check procedure property! Continue [Ctrl][W] Cancel [Esc]' nowait
  if tpomin.procprop<>lc_omin
    seek lc_omin
  endif
  browse window tpomin fields procprop:R, english:R, finish:R save
  if lastkey()=27
    browse window tpomin fields procprop:R, english:R, finish:R nowait save
    return
  endif
  lc_omin=tpomin.procprop
endif
p_procpr=tpomin.procprop
select csp
seek (lc_alku)
do while not eof() and csp.code<=lc_loppu
*  select drgtpt
  if p_kieli='Com'
    lc_ncsp=csp.code
  else
    lc_ncsp=csp.ncsp
  endif
  lc_code=csp.code
  lc_found=.f.
  seek csp.code
  do while csp.code=lc_code
    if p_procpr=drgtpt.varval
      lc_found=.t.
      exit
    endif
    select csp
    skip
  enddo  
  if not lc_found
    insert into drgtpt (code, code_nc)values (lc_code,lc_ncsp)
    replace drgtpt.chdate with date()
    replace drgtpt.valid with .t.
    replace drgtpt.vartype with 'PROCPR'
    replace drgtpt.varval with p_procpr
  endif
  select csp
  seek lc_code
  if p_kieli='Com'
    select language
    goto top
    do while not eof()
      if language.lan<>'Com'
        select csp_oth
        use ('\data\ncsp\'+language.hakem+'\csp') alias csp_oth
        set order to ncsp
        set filter to not released
        seek lc_ncsp
        do while csp_oth.ncsp=lc_ncsp
          lc_code=code
          set order to code
          select drgt_oth
          use ('\data\ncsp\'+language.hakem+'\drgtpt') alias drgt_oth
          set order to code
          seek (lc_code+drgtpt.vartype+drgtpt.varval)
          if not found() or not valid
            wait window lc_code+' '+trim(csp_oth.text)+' - '+drgtpt.vartype+'-'+drgtpt.varval+;
            ' will be added to '+language.lan+'-file. Y(es)/N(o)'
            if lastkey()=121 or lastkey()=89
              if not found()
                 append blank
              endif
              replace code with lc_code, code_nc with lc_ncsp, chdate with date(),;
              valid with .t., vartype with 'PROCPR', varval with p_procpr
            endif
          endif
          select csp_oth
          set order to ncsp
          skip
        enddo
      endif
      select language
      skip
    enddo
  endif
  select csp
  if lc_alias='TPOMIN'
    exit
  endif
  do while lc_code=code
    skip
  enddo
enddo
set filter to not deleted()
seek lc_alku
select csp
select drgtpt
set relation to IIF(vartype='PROCPR',varval,' ') into tpomin 
set relation to IIF(vartype='DGPROP',SUBSTR(varval,1,2)+SUBSTR(varval,4,2)+SUBSTR(varval,3,1),' ') into dgomin additive
do cspnaytto
return