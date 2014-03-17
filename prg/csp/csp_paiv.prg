Procedure CSP_PAIV
lc_ok=.t.
on error do virhe
select 0
do case
case p_kieli='Eng'
  use c:\data\ncsp_en
case p_kieli='Dan'
  use c:\data\ncsp_da
case p_kieli='Fin'
  use c:\data\ncsp_fi
case p_kieli='SWE'
  use c:\data\ncsp_sw
case p_kieli='Nor'
  use c:\data\ncsp_no
endcase
use
on error
if lc_ok
  select csp
  set relation to
  delete all
  pack
  on error do virhe
  do case
  case p_kieli='Eng'
    append from c:\data\ncsp_en
  case p_kieli='Dan'
    append from c:\data\ncsp_da
  case p_kieli='Fin'
    append from c:\data\ncsp_fi
  case p_kieli='SWE'
    append from c:\data\ncsp_sw
  case p_kieli='Nor'
    append from c:\data\ncsp_no
  endcase
  on error
  do tarkast
endif
do _ncsp
return

procedure virhe
wait window 'File not found! You need to form the updated file without headings in C:/DATA'
lc_ok=.f.
return