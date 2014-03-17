Procedure shortman
select 0
use sm_stru alias logi_apu
select drgtpt
set relation to code into csp
select drglogic
set order to ord
goto top
lc_ord='00'
lc_mdc='00'
do while not eof()
  if ord='00' or ord='99' or drg='470' or drg='468' or drg='477'
    skip
    loop
  endif
  if drglogic.ord<>lc_mdc
   select logi_apu
   goto top
   if lc_ord<>'00'
     copy to (language.lan+'\sm_mdc'+lc_ord+'.xls') type xl5
   endif
   delete all
   pack
   lc_mdc=substr(drglogic.ord,1,2)
   select dgkat
   seek lc_mdc
   insert into logi_apu (drg, drgtext) values (dgkat.dgcat, dgkat.english)
   if drglogic.dgcat1<>' '
    select dgkat
    seek drglogic.dgcat1
    insert into logi_apu (code, name) values (drglogic.dgcat, dgkat.english)
    insert into logi_apu (code, code_2, name) values ('ICD', 'ICD +', 'text')
    lc_n=0
    select dg
    set order to varval
    seek 'DGCAT   '+substr(lc_kat,1,2)
    do while dg.varval=lc_mdc and not eof()
      select logi_apu
      do case
      case p_kieli='Fin'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_f, dg.d_code_f, icd_10.text)
      case p_kieli='Dan'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_d, dg.d_code_d, icd_10.text)
      case p_kieli='Swe'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_s, dg.d_code_s, icd_10.text)
      case p_kieli='Nor'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_n, dg.d_code_n, icd_10.text)
      case p_kieli='Eng'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
      endcase
      select dg
      skip
    enddo
    if substr(lc_kat,1,2)='12' or substr(lc_kat,1,2)='13'
      lc_apumdc='98'
      seek 'DGCAT   '+lc_apumdc
      do while dg.varval=lc_apumdc and not eof()
        select logi_apu
        do case
        case p_kieli='Fin'
          seek dg.code_f+dg.d_code_f
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_f, dg.d_code_f, icd_10.text)
          endif
        case p_kieli='Dan'
          seek dg.code_d+dg.d_code_d
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_d, dg.d_code_d, icd_10.text)
          endif
        case p_kieli='Swe'
          seek dg.code_s+dg.d_code_s
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_s, dg.d_code_s, icd_10.text)
          endif
        case p_kieli='Nor'
          seek dg.code_n
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_n, dg.d_code_n, icd_10.text)
          endif
        case p_kieli='Eng'
          seek dg.code+dg.d_code
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
          endif
        endcase
        select dg
        skip
      enddo
    endif
   endif
  endif
  if drglogic.ord<>lc_ord
    select logi_apu
    append blank
    insert into logi_apu (drg, drgtext) values (drgnames.drg, drgnames.english)
    lc_ord=drglogic.ord
  endif
  select drglogic
  if drglogic.pdgprop<>' '
    select pdgomin
    seek drglogic.pdgprop
    insert into logi_apu (code, name) values (drglogic.pdgprop, pdgomin.english)
    select icd_10
    set order to code
    select dg
    set order to varval
    seek 'PDGPRO  '+ SUBSTR(drglogic.pdgprop,1,2)+SUBSTR(drglogic.pdgprop,4,2)+SUBSTR(drglogic.pdgprop,3,1)
    lc_n=0
    do while varval=drglogic.pdgprop and not eof()
      select logi_apu
      do case
      case p_kieli='F'
        seek dg.code_f+dg.d_code_f
        if not found()
          lc_n=lc_n+1
          insert into logi_apu (code, code_2, name) values (dg.code_f, dg.d_code_f, icd_10.text)
        endif
      case p_kieli='D'
        seek dg.code_d+dg.d_code_d
        if not found()
          lc_n=lc_n+1
          insert into logi_apu (code, code_2, name) values (dg.code_d, dg.d_code_d, icd_10.text)
        endif
      case p_kieli='S'
        seek dg.code_s+dg.d_code_s
        if not found()
          lc_n=lc_n+1
          insert into logi_apu (code, code_2, name) values (dg.code_s, dg.d_code_s, icd_10.text)
        endif
      case p_kieli='N'
        seek dg.code_n
        if not found()
          lc_n=lc_n+1
          insert into logi_apu (code, code_2, name) values (dg.code_n, dg.d_code_n, icd_10.text)
        endif
      otherwise
        seek dg.code_w+dg.d_code_w
        if not found()
          lc_n=lc_n+1
          insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
        endif
        endcase  
      select dg
      skip
    enddo
  endif

  if drglogic.procpro1<>' '
    select tpomin
    seek drglogic.procpro1
    select logi_apu
    append blank
    insert into logi_apu (code, name) values (drglogic.procpro1, tpomin.english)
    insert into logi_apu (code_2, name) values ('NCSP', 'text')
    lc_n=0
    select drgtpt
    set order to varval
    seek 'PROCPR  '+drglogic.procpro1
    do while drglogic.procpro1=drgtpt.varval and not eof()
      insert into logi_apu (code_2, name) values (drgtpt.code, csp.english)
      select logi_apu
      if p_kieli<>'E'
        replace name with csp.text
      endif
      lc_n=lc_n+1
      select drgtpt
      skip
    enddo
    insert into logi_apu (code, code_2, name) values ('ICD', 'ICD +','text')
    select dg
    set order to varval
    seek 'PROCPR  '+substr(drglogic.procpro1,1,2)+SUBSTR(drglogic.procpro1,4,2)+SUBSTR(drglogic.procpro1,3,1)
    do while drglogic.procpro1=dg.varval and not eof()
      select logi_apu
      seek dg.code+dg.d_code
      if not found()
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code,icd_10.text)
      endif
      select dg
      skip
    enddo
  endif

  if drglogic.dgcat1<>' '
    select dgkat
    seek drglogic.dgcat1
    select logi_apu
    append blank
    insert into logi_apu (code, name) values (drglogic.dgcat1, dgkat.english)
    insert into logi_apu (code, code_2, name) values ('ICD', 'ICD +', 'text')
    lc_n=0
    select dg
    set order to varval
    lc_kat=trim(drglogic.dgcat1)
    seek 'DGCAT   '+substr(lc_kat,1,2)+substr(lc_kat,4,2)
    do while dg.varval=lc_kat and not eof()
      select logi_apu
      do case
      case p_kieli='Fin'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_f, dg.d_code_f, icd_10.text)
      case p_kieli='Dan'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_d, dg.d_code_d, icd_10.text)
      case p_kieli='Swe'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_s, dg.d_code_s, icd_10.text)
      case p_kieli='Nor'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_n, dg.d_code_n, icd_10.text)
      case p_kieli='Eng'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
      endcase
      select dg
      skip
    enddo
    if substr(lc_kat,1,2)='12' or substr(lc_kat,1,2)='13'
      lc_kat='98'+substr(lc_kat,3,3)
      seek 'DGCAT   '+substr(lc_kat,1,2)+substr(lc_kat,4,2)
      do while dg.varval=lc_kat and not eof()
        select logi_apu
        do case
        case p_kieli='Fin'
          seek dg.code_f+dg.d_code_f
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_f, dg.d_code_f, icd_10.text)
          endif
        case p_kieli='Dan'
          seek dg.code_d+dg.d_code_d
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_d, dg.d_code_d, icd_10.text)
          endif
        case p_kieli='Swe'
          seek dg.code_s+dg.d_code_s
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_s, dg.d_code_s, icd_10.text)
          endif
        case p_kieli='Nor'
          seek dg.code_n
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code_n, dg.d_code_n, icd_10.text)
          endif
        case p_kieli='Eng'
          seek dg.code+dg.d_code
          if not found()
            lc_n=lc_n+1
            insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
          endif
        endcase
        select dg
        skip
      enddo
    endif
  endif

  if drglogic.dgprop1<>' '
    do dgprosm with drglogic.dgprop1
  endif
  if drglogic.dgprop2<>' '
    do dgprosm with drglogic.dgprop2
  endif
  if drglogic.dgprop3<>' '
    do dgprosm with drglogic.dgprop3
  endif
  if drglogic.dgprop4<>' '
    do dgprosm with drglogic.dgprop4
  endif

  select drglogic
  skip
enddo
return

procedure dgprosm
parameter lc_dgprop
    select dgomin
    set order to dgprop
    if lc_dgprop='-'
      seek SUBSTR(lc_dgprop,2,2)+SUBSTR(lc_dgprop,5,2)+SUBSTR(lc_dgprop,4,1)
      insert into logi_apu (code, code_2, name) values ('NOT', dgomin.dgprop1, dgomin.english)
    else
      seek SUBSTR(lc_dgprop,1,2)+SUBSTR(lc_dgprop,4,2)+SUBSTR(lc_dgprop,3,1)
      insert into logi_apu (code, name) values (lc_dgprop, dgomin.english)
    endif
    select dg
    set order to varval
    set filter to valid
    lc_n=0
    if lc_dgprop='-'
      lc_dgomin= substr(lc_dgprop,2,5)
    else
      lc_dgomin=trim(lc_dgprop)
    endif
    seek 'DGPROP  '+SUBSTR(lc_dgomin,1,2)+SUBSTR(lc_dgomin,4,2)+SUBSTR(lc_dgomin,3,1) 
    do while dg.varval=lc_dgomin
      select logi_apu
      do case
      case p_kieli='F'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_f, dg.d_code_f, icd_10.text)
      case p_kieli='D'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_d, dg.d_code_d, icd_10.text)
      case p_kieli='S'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_s, dg.d_code_s, icd_10.text)
      case p_kieli='N'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code_n, dg.d_code_n, icd_10.text)
      case p_kieli='E'
        lc_n=lc_n+1
        insert into logi_apu (code, code_2, name) values (dg.code, dg.d_code, icd_10.text)
      endcase
      select dg
      skip
    enddo
    select drgtpt
    set order to varval
    seek 'DGPROP  '+lc_dgomin
    do while drgtpt.varval=lc_dgomin
      select logi_apu
      lc_n=lc_n+1
      if p_kieli='Eng'
        insert into logi_apu (code_2,name) values (drgtpt.code, csp.english)
      else
        insert into logi_apu (code_2,name) values (drgtpt.code, csp.text)
      endif
      select drgtpt
      skip
    enddo
return