procedure analetsi
push key clear
select anal
define window ae_apu from 10,15 to 22,60 Font 'Arial' 8 
activate window ae_apu
@ 1,1 say 'Order: '+order()
@ 2,1 say 'Give the codes to be searched for!'
do case
case order()='DRG'
  @ 3,1 say 'DRG'
  et_kood=p_ldrg
  @ 4,1 get et_kood picture '999!'
  @ 6,1 say 'Diagnosis'
  @ 6,8 get p_ldg picture '!99!99'
  @ 8,1 say 'Procedure'
  @ 9,8 get p_lproc picture '!!!!!!'
  read
  et_kood=str(val(et_kood),3)
  p_ldrg=et_kood
  if len(trim(p_ldg))>3
    if substr(p_ldg,4,1)<>'.'
      p_ldg=substr(p_ldg,1,3)+'.'+substr(p_ldg,4,2)
    endif
  endif
case order()='OIR1'
  et_kood=p_ldg
  @ 3,1 say 'Main diagnosis'
  @ 4,1 get et_kood picture '!99!99'
  @ 5,1 say 'Diagnosis'
  @ 6,8 get p_ldg picture '!99!99'
  @ 7,1 say 'Procedure'
  @ 8,8 get p_lproc picture '!!!!!!'
  @ 9,1 say 'DRG'
  @ 10,8 get p_ldrg picture '999!'
  read
  if len(trim(et_kood))>3
    if substr(et_kood,4,1)<>'.'
      et_kood=substr(et_kood,1,3)+'.'+substr(et_kood,4,2)
    endif
  endif
  et_kood=trim(et_kood)
  if p_ldg=' '
    p_ldg=et_kood
    @ 6,8 say p_ldg picture '!99.99'
  else
    if len(trim(p_ldg))>3
      if substr(p_ldg,4,1)<>'.'
        p_ldg=substr(p_ldg,1,3)+'.'+substr(p_ldg,4,2)
      endif
    endif
  endif
case order()='TP1'
  et_kood=p_lproc
  @ 3,1 say 'First procedure'
  @ 4,1 get et_kood picture '!!!!!'
  @ 5,1 say 'Diagnosis'
  @ 6,8 get p_ldg picture '!99!99'
  @ 7,1 say 'Procedure'
  @ 8,8 get p_lproc picture '!!!!!'
  @ 9,1 say 'DRG'
  @ 10,8 get p_ldrg picture '999!'
  read
  et_kood=trim(et_kood)
  if len(trim(p_ldg))>3
    if substr(p_ldg,4,1)<>'.'
      p_ldg=substr(p_ldg,1,3)+'.'+substr(p_ldg,4,2)
    endif
  endif
  if p_lproc=' '
    p_lproc=et_kood
    @ 8,8 say p_lproc picture '!!!!!'
  endif
otherwise
  wait window 'Search is possible only in diagnosis, procedure or DRG order' nowait
  release window ae_apu
  pop key
  return
endcase
if lastkey()=27
  release window ae_apu
  pop key
  return
endif
pop key
do casesel with et_kood, 'F','N'
lc_loop=.t.
do while lc_loop
  do luokitus
  do analnayt
  activate window ae_apu
  wait window at 15,22 '(P)revious,(N)ext,(S)top? ' 
  do case
  case lastkey()=112 or lastkey()=80
    do casesel with et_kood, 'S', 'P'
  case lastkey()=110 or lastkey()=78
    do casesel with et_kood, 'S', 'N'
  case lastkey()=115 or lastkey()=83
    exit
  otherwise
    loop
  endcase
enddo
release window ae_apu
select anal
do analohje
do analnayt
return
