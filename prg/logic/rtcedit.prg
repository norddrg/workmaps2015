procedure rtcedit
select rtc
DEFINE WINDOW rtc FROM max_y/5,max_x/3 to 2*max_y/3,max_x TITLE 'Return codes' FONT max_foty,  max_fosi double
activate window rtc
browse noedit nodelete
release window rtc
return 