

/* DO FILE FOR MAIN SURVEY EXPERIMENT */

replace q71_firstclick=999 if q71_firstclick==.
replace q72_firstclick=999 if q72_firstclick==.
replace q73_firstclick=999 if q73_firstclick==.


gen control = 999
recode control 999=0 if q71_firstclick==999
recode control 999=1 if q71_firstclick!=.
recode control 999=.

gen gains = 999
recode gains 999=0 if q72_firstclick==999
recode gains 999=1 if q72_firstclick!=.
recode gains 999=.

gen losses = 999
recode losses 999=0 if q73_firstclick==999
recode losses 999=1 if q73_firstclick!=.
recode losses 999=.


gen treatment=.
replace treatment=1 if control==1
replace treatment=2 if losses==1
replace treatment=3 if gains==1
lab def treatment 1 "control" 2"losses" 3"gains"
lab val treatment treatment
tab treatment


/* POOR HEALTH EXPERIENCES MODERATOR */

gen nohealthemergency = q604
recode nohealthemergency 1=0 2=1

gen nofamilyemergency = q605
recode nofamilyemergency 1=0 2=1

gen nohealthhardship = 999
recode nohealthhardship 999=1 if (nohealthemergency==1 & nofamilyemergency==1)
recode nohealthhardship 999=0 if (nohealthemergency==0 | nofamilyemergency==0)
recode nohealthhardship 999=.




/* BALANCE CHECK */
gen female = q591
recode female 1=1 2=0

drop if age<18

gen income = (q594-1)/24

gen education = q593
recode education 1=0 2=.16 3=.33 4=.5 5=.67 6=.84 7=1

gen partyid = 999
recode partyid 999=1 if q600==1
recode partyid 999=.84 if q600==2
recode partyid 999=.67 if q601==1
recode partyid 999=.5 if q601==3
recode partyid 999=.33 if q601==2
recode partyid 999=.16 if q599==2
recode partyid 999=0 if q599==1
recode partyid 999=.

gen parent = 999
recode parent 999=1 if (q596==1 | q597==1)
recode parent 999=0 if (q596==2 & q597==2)
recode parent 999=.

gen notworkingfulltime = q595
recode notworkingfulltime 1=0 2/8=1

gen nonwhite = q592
recode nonwhite 1/4=1 5=0 6=1


/* Table 2 in Appendix; no evidence of imbalance for any of these comparisons */
oneway female treatment if nohealthhardship!=., t
oneway age treatment if nohealthhardship!=., t
oneway education treatment if nohealthhardship!=., t
oneway income treatment if nohealthhardship!=., t
oneway partyid treatment if nohealthhardship!=., t
oneway nonwhite treatment if nohealthhardship!=., t
oneway notworkingfulltime treatment if nohealthhardship!=., t
oneway parent treatment if nohealthhardship!=., t
oneway nohealthhardship treatment if nohealthhardship!=., t

/* MODELS */

/* marginals*/
sort treatment
by treatment: sum action
by treatment: sum action if nohealthhardship==0
by treatment: sum action if nohealthhardship==1

/* Table 3 in Appendix */
probit action losses gains
probit action losses##nohealthhardship gains##nohealthhardship
margins, dydx(losses) at(nohealthhardship=(0,1))
margins, dydx(gains) at(nohealthhardship=(0,1))
probit action losses##nohealthhardship gains##nohealthhardship female age education partyid income nonwhite notworkingfulltime parent 





