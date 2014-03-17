procedure kielvaih
lc_alias=alias()
goto top
do while not eof()
   lc_koodi=koodi
   select ncsp_en
   seek lc_koodi
   if found()
      select (lc_alias)
      replace nimike with ncsp_en.englanti
      replace note with ncsp_en.note_d
   else
      select (lc_alias)
      replace huom with '+'
   endif
   select (lc_alias)
   skip
enddo
return