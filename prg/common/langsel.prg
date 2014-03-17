Procedure langsel
public p_kieli
lang_loop=.t.
ON ERROR do langfile
do while lang_loop
  select language
  set order to lan
  ON ERROR
  define popup lansel prompt field name
  on selection popup lansel do language with prompt()
  wait window nowait 'Choose the nationality!'
  activate popup lansel at 5,10
  release popup lansel
  if len(trim(p_kieli))>0
    exit
  endif
enddo
return

procedure language
parameter lc_lan
p_kieli=language.lan
deactivate popup lansel
return

PROCEDURE langfile
SELECT 0
USE ..\..\tabl_def\language
SET ORDER TO lan
return
