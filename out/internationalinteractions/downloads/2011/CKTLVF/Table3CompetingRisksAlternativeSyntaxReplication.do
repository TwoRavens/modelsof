
***Competing Risks Model with alternative intervening variables
********************************

**censored if no success (Success Model)
tab outcome if majorint==1
gen event1=1 if outcome==1 & majorint==1
replace event1=0 if (outcome==0) & majorint==1
todate startdate, gen(startdate1)  pattern(yyyymmdd)
todate enddate, gen(enddate1)  pattern(yyyymmdd)
gen duration= enddate1- startdate1
tab outcome
sum duration
gen event2=0 if event1==1
replace event2=1 if event1==0

**Success- Model
stset duration if majorint==1 & multilat==1 & type>=4, failure(event1)
stdes
stcox direct1 domestic1 bruteforce  dem7coalitionr numbpartisum  coalitionstrength average_milex_percap_dum defectiondum if majorint==1 & type>=4 & multilat==1& interventid~=103 & year<=2001,   efron robust   

***Failure-Model
stset duration if majorint==1 & multilat==1 & type>=4, failure(event2)
stdes
stcox direct1 domestic1 bruteforce  dem7coalitionr numbpartisum  coalitionstrength average_milex_percap_dum defectiondum if majorint==1 & type>=4 & multilat==1& interventid~=103 & year<=2001,   efron robust    


