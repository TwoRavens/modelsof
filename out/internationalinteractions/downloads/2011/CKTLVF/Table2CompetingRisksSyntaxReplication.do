
*Duration Analysis settings
*****************************************************
**censored if no success (Success Model)
tab outcome if majorint==1
gen event1=1 if outcome==1 & majorint==1
replace event1=0 if (outcome==0) & majorint==1
todate startdate, gen(startdate1)  pattern(yyyymmdd)
todate enddate, gen(enddate1)  pattern(yyyymmdd)
gen duration= enddate1- startdate1
tab outcome
sum duration

***censored if success (Failure Model)
gen event2=0 if event1==1
replace event2=1 if event1==0


*Main Model
******************************************************************************************************************************
*Success Model (event1)
stset duration if majorint==1 & multilat==1 & type>=4, failure(event1)
stdes
stcox direct1 domestic1 bruteforce  dem7coalitionr numbpartisum  coalitionstrength  if majorint==1 & type>=4 & multilat==1& interventid~=103 & year<=2001,   efron robust    


**********************
**Failure Model (event2)
stset duration if majorint==1 & multilat==1 & type>=4, failure(event2)
stdes
stcox direct1 domestic1 bruteforce  dem7coalitionr numbpartisum  coalitionstrength  if majorint==1 & type>=4 & multilat==1& interventid~=103 & year<=2001,   efron robust  


