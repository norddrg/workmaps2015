procedure logluku
*set step on
public icd_arr 
public mdc_arr 
public pdgprop_arr 
public or_arr 
public procpro_arr 
public dgcat_arr
public agelim_arr
public dur_arr
public compl_arr 
public sex_arr 
public dgprop1_arr 
public dgprop2_arr 
public dgprop3_arr 
public dgprop4_arr 
public secproc_arr 
public disch_arr 
public drg_arr 
public ord_arr 
public rtc_arr 
public locdrg_arr
select drglogic
set filter to inuse
set order to ord
goto top
public n_log
n_log=0
count to n_log
dimension icd_arr (n_log,1)
dimension mdc_arr (n_log,1)
dimension pdgprop_arr (n_log,1)
dimension or_arr (n_log,1)
dimension procpro_arr (n_log,1)
dimension dgcat_arr (n_log,1)
dimension agelim_arr (n_log,1)
dimension dur_arr (n_log,1)
dimension compl_arr (n_log,1)
dimension sex_arr (n_log,1)
dimension dgprop1_arr (n_log,1)
dimension dgprop2_arr (n_log,1)
dimension dgprop3_arr (n_log,1)
dimension dgprop4_arr (n_log,1)
dimension secproc_arr (n_log,1)
dimension disch_arr (n_log,1)
dimension drg_arr (n_log,1)
dimension ord_arr (n_log,1)
dimension rtc_arr (n_log,1)
dimension locdrg_arr (n_log,1)

lcn_icd=0
lcn_mdc=0
lcn_pdgprop=0
lcn_or=0

public log_rivi
dimension log_rivi (300,99)
store 1 to log_rivi (1,11)
ch_mdc=1
ch_pdgprop=1
ch_or=1

public max_pdgprop, max_or
dimension max_pdgprop (300,1)
dimension max_or (300,9)
store 1 to max_pdgprop (1,1)
store 1 to max_or(1,1)

goto top
lcn_log=0
do while not eof()
  lcn_log=lcn_log+1

  store icd to icd_arr (lcn_log,1)

  store mdc to mdc_arr (lcn_log,1)
*  if lcn_log>1
*    if mdc<>mdc_arr(lcn_log-1,1) and mdc_arr(lcn_log-1,1)<>'  '
*      if pdgprop_arr(lcn_log-1,1) <> '  '
*        ch_pdgprop=ch_pdgprop+1
*        store ch_pdgprop to max_pdgprop (ch_mdc,1) 
*        store lcn_log to log_rivi (ch_mdc, 10*(ch_pdgprop)+ch_or)
*      endif
*      if or_arr(lcn_log-1,1) <> ' '
*        ch_or=ch_or+1
*        store ch_or to max_or(ch_mdc,ch_pdgprop)
*        store lcn_log to log_rivi (ch_mdc, 10*(ch_pdgprop)+ch_or)
*      endif
*      ch_pdgprop=1
*      ch_or=1
*      ch_mdc=ch_mdc+1
*      store ch_pdgprop to max_pdgprop (ch_mdc,1) 
*      store ch_or to max_or(ch_mdc,ch_pdgprop)
*      store lcn_log to log_rivi (ch_mdc, 10*(ch_pdgprop)+ch_or)
*    endif
*  endif

  store pdgprop to pdgprop_arr (lcn_log,1)
  if lcn_log>1 and lcn_log<>log_rivi(ch_mdc,10*ch_pdgprop+ch_or)
    if ((pdgprop<>pdgprop_arr(lcn_log-1,1) or (ch_pdgprop=1 and icd_arr(lcn_log-1,1)<>'-' and mdc_arr(lcn_log-1,1)<>mdc)) and pdgprop_arr(lcn_log-1,1)<>' ') or;
    (mdc <> mdc_arr(lcn_log-1,1) and mdc<>' ' and pdgprop<>' ')
      if or_arr(lcn_log-1,1) <> ' '
        ch_or=ch_or+1
        store ch_or to max_or(ch_mdc,ch_pdgprop)
        store lcn_log to log_rivi (ch_mdc, 10*(ch_pdgprop)+ch_or)
      endif
      ch_or=1
      ch_pdgprop=ch_pdgprop+1
      store ch_or to max_or(ch_mdc,ch_pdgprop)
      store ch_pdgprop to max_pdgprop (ch_mdc,1) 
      store lcn_log to log_rivi (ch_mdc, 10*(ch_pdgprop)+ch_or)
    endif
  endif
 
  store or to or_arr (lcn_log,1)
  if lcn_log>1 and lcn_log<>log_rivi(ch_mdc,10*ch_pdgprop+ch_or)
    if ((or<>or_arr(lcn_log-1,1) or (ch_or=1 and icd_arr(lcn_log-1,1)<>'-') and (pdgprop_arr(lcn_log-1,1)<>pdgprop or mdc_arr(lcn_log-1,1)<>mdc)) and (or_arr(lcn_log-1,1)<>' ' )) or;
    (pdgprop <> pdgprop_arr(lcn_log-1,1) and pdgprop<>' ' and or<>' ') or;
    (mdc <> mdc_arr(lcn_log-1,1) and mdc<>' ' and or<>' ')
      ch_or=ch_or+1
      store ch_or to max_or(ch_mdc,ch_pdgprop)
      store lcn_log to log_rivi (ch_mdc, 10*(ch_pdgprop)+ch_or)
    endif
  endif
  
  store procpro1 to procpro_arr (lcn_log,1)
  store dgcat1 to dgcat_arr (lcn_log,1)
  store agelim to agelim_arr (lcn_log,1)
  store dur to dur_arr (lcn_log,1)
  store compl to compl_arr (lcn_log,1)
  store sex to sex_arr (lcn_log,1)
  store dgprop1 to dgprop1_arr (lcn_log,1)
  store dgprop2 to dgprop2_arr (lcn_log,1)
  store dgprop3 to dgprop3_arr (lcn_log,1)
  store dgprop4 to dgprop4_arr (lcn_log,1)
  store secproc1 to secproc_arr (lcn_log,1)
  store disch to disch_arr (lcn_log,1)
  store drg to drg_arr (lcn_log,1)
  store ord to ord_arr (lcn_log,1)
  store rtc to rtc_arr (lcn_log,1)
  select drgnames
  seek drg_arr(lcn_log,1)
  if not found()
     set filter to 
     seek drg_arr(lcn_log,1)
     if not found()
        append blank
        replace drg with drg_arr(lcn_log,1)
        replace loc_drg with drg_arr(lcn_log,1)
     endif
     replace valid with .t.
     set filter to valid
  endif
  store drgnames.loc_drg to locdrg_arr(lcn_log,1)  
  select drglogic
  skip
  loop
enddo
p_logluku=.t.
return