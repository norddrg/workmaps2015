Procedure siir
lc_alias=alias()
lc_omin=space(6)
if alias()='DRGTPT'
  lc_omin=varval
endif
if alias()='DGOMIN'  or substr(lc_omin,3,1)='X'
  do siir_dg
  return
endif
if lc_alias<>'TPOMIN'
  select tpomin
  if lc_alias='DRGTPT' and substr(lc_omin,3,1)<>'X' and substr(lc_omin, 3,1)<>' '
    seek trim(lc_omin)
  endif
  wait window 'Check the procedureproperty! Continue = [Ctrl][W], Cancel = [Esc]' nowait
  browse window tpomin fields procprop:R, english:R, finish:R save
  if lastkey()=27
    browse window tpomin fields procprop:R, english:R, finish:R nowait save
    return
  endif
endif
p_procpr=tpomin.procprop
select csp
lc_order=order()
if order()<>'CODE'
  set order to code
endif
lc_order=order()
select drgtpt
set relation to
if lc_alias='NCSP_SUB'
  lc_ryh=trim(code)
  select csp
  set order to ncsp
  if ncsp<>lc_ryh
    seek lc_ryh
    BROWSE WINDOW koodit FIELDS csp.code:7:R, csp.text:50:R, csp.code_nc:7:R, csp.english: 50:R, drgtpt.procprop:6, drgtpt.compl:3, drgtpt.or:2, drgtpt.dgprop, csp.finish:20 SAVE nowait
  endif
else
  select csp
  lc_ryh=code
  select drgtpt
  seek csp.code+'PROCPR '+substr(p_procpr,1,2) 
  if found() and p_procpr<>drgtpt.varval
    wait window 'The procedure has coded earlier to '+drgtpt.varval+ '. Cancel=[Space], continue =[Enter]'
    if lastkey()<>13 
      return
    else
      exit
    endif
  endif
endif
select csp
seek (lc_ryh)
do while not eof() and (csp.code=lc_ryh )
  lc_ncsp=csp.ncsp
  lc_code=csp.code
  lc_found=.f.
  select drgtpt
  seek csp.code
  do while drgtpt.code=lc_code and not eof()
    if p_procpr=drgtpt.varval
      lc_found=.t.
      exit
    endif
    select drgtpt
    skip
  enddo  
  if not lc_found
    insert into drgtpt (code, code_nc)values (lc_code,lc_ncsp)
    replace drgtpt.chdate with date()
  endif
  select drgtpt
  replace drgtpt.valid with .t.
  replace drgtpt.vartype with 'PROCPR'
  replace drgtpt.varval with p_procpr
  select csp
  lc_koodi=code
  if p_kieli='Com'
    select language
    goto top
    do while not eof()
      if language.lan<>'Com'
        select csp_oth
        use ('..\..\ncsp\'+trim(language.lan)+'\csp') alias csp_oth
        set order to ncsp
        set filter to not released
        seek trim(lc_ncsp)
        do while trim(csp_oth.ncsp)=trim(lc_ncsp)
          lc_code=code
          set order to code
          select drgt_oth
          use ('..\..\tabl_def\'+trim(language.lan)+'\drgtpt') alias drgt_oth
          set order to code
          seek (lc_code+drgtpt.vartype+drgtpt.varval)
          if found() 
            do while not valid and not eof()              
              skip
            enddo
            if code=lc_code and vartype=drgtpt.vartype and varval=drgtpt.varval
              if valid
                select csp_oth
                set order to ncsp
                skip
                loop
              endif
            endif
            seek (lc_code+drgtpt.vartype+drgtpt.varval)
          endif
          if not found() or not valid
            wait window lc_code+' '+trim(csp_oth.text)+' - '+drgtpt.vartype+'-'+drgtpt.varval+;
            ' will be added to '+language.lan+'-file. Y(es)/N(o)'
            if lastkey()=121 or lastkey()=89
              if not found()
                 select drgt_oth
                 append blank
              endif
              replace code with lc_code, code_nc with lc_ncsp, chdate with date(), valid with .t., vartype with 'PROCPR', varval with p_procpr
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
  if not eof()
    skip
    do while lc_koodi=code
      skip
    enddo
  endif
enddo
set filter to not deleted()
seek lc_ryh
select csp
set order to (lc_order)
do case
  case len(lc_ryh)=1
    select ncsp_cha
  case len(lc_ryh)=2
    select ncsp_gro
  case len(lc_ryh)=3
    select ncsp_sub
  otherwise
    select csp
endcase
select csp
do cspnaytto
return
