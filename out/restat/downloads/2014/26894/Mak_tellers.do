/****************************************************
  MAKE TELLERS WERK (employment), GEEN WERK (unemployment) EN MIGRATION

tellers: numemi, numimmi, numwerk, numGwerk

SEC (=SES): SOCIAL ECONOMIC CLASS (=main source of income)
 1 "Employee"
 2 "Self-employed"
 3 "Disability benefit"
 4 "Unemployment benefit"
 5 "Social security benefit"
 6 "Other benefits"
 7 "Pension"
 8 "Student"
 9 "Other (including no income)" 
 
 eventMig : indicator of migration event
  0 "Censored"
  1 "Immigration"
  2 "Emigration"
  3 "Administrative removal"
   
*****************************************************/

*** Migration-tellers ***
by rin: gen byte numemi = sum((eventMig==2|eventMig==3))
by rin: gen byte numimmi = sum((eventMig==0|eventMig==1))

**** Werk-tellers *****
drop eventSEC
gen byte eventSEC=-9
by rin: replace eventSEC = 0 if eventMig==99
by rin: replace eventSEC = 1 if (eventMig==0|eventMig==1)
by rin: replace eventSEC = 2 if (eventMig==2|eventMig==3)
by rin: replace eventSEC = 3 if _n > 1 & SEC!=SEC[_n-1] &  ///
            eventSEC!=0 & eventSEC!=1 & eventSEC!=2 
label val eventSEC eventSEClab

by rin: gen byte eventWerk = -9 if SEC==1|SEC==2
by rin: replace eventWerk = 0 if eventSEC==0 & (SEC==1|SEC==2)
by rin: replace eventWerk = 1 if eventSEC==1 & (SEC==1|SEC==2)
by rin: replace eventWerk = 1 if eventSEC==3 & (SEC==1|SEC==2) ///
                           & SEC1!=1 & SEC1!=2 
by rin: replace eventWerk = 2 if eventSEC==2 & (SEC==1|SEC==2)
by rin: replace eventWerk = 3 if eventSEC==3 & (SEC1==1|SEC1==2) ///
                              & SEC!=1 & SEC!=2
label val eventWerk eventSEClab

by rin: gen byte numwerk = sum(eventWerk==1)

**** Geen werk tellers ***
by rin: gen byte eventGWerk = -9 if SEC!=1 & SEC!=2
by rin: replace eventGWerk = 0 if eventSEC==0 & SEC!=1 & SEC!=2
by rin: replace eventGWerk = 1 if eventSEC==1 & SEC!=1 & SEC!=2
by rin: replace eventGWerk = 1 if eventSEC==3 & SEC!=1 & SEC!=2 ///
                     & (SEC1==1|SEC1==2)  
by rin: replace eventGWerk = 2 if eventSEC==2 & SEC!=1 & SEC!=2
by rin: replace eventGWerk = 3 if eventSEC==3 & (SEC==1|SEC==2) & ///
                     SEC1!=1 & SEC1!=2
label val eventGWerk eventSEClab

by rin: gen byte numGwerk = sum(eventGWerk==1)

********************************************
/** indices repeated migration and (un)employment **/
gen byte repimmi = (numimmi > 1)
drop if repimmi /* ONLY first immigration */
gen byte repwerk = (numwerk > 1)
gen byte repGwerk = (numGwerk > 1)

