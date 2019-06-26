*Estimations for Table 2;  Bayer - Peaceful Transitions  and Democracy; Journal of Peace Research

clear 
set mem 50m
use "Bayer_JPR_peaceful_democracy.dta"


*Table 2 Model Frozen Peace to Cold Peace

keep if changefromfrozenpeace~=. 
stset  frozenpeaceend, failure( changefromfrozenpeace==1) enter(time frozenpeacestart)  exit(time .)
 stdes

gen timposed = imposed * ln(_t)
gen tinterest1= interest1 * ln(_t)
gen tabschangepower = abschangepower * ln(_t)
gen tdistance = distance * ln(_t)
gen tIISbd_1= IISbd_1 * ln(_t)
gen tsumIISBD_other =  sumIISBD_other * ln(_t)
gen tonedemoc= onedemoc * ln(_t)
gen tdemocdyad=democdyad *ln(_t)


stcox   imposed  interest1 abschangepower  sumIISBD_other  distance   onedemoc democdyad IISbd_1,  robust nolog cluster(dyad) nohr schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sca* sch*
stcox   imposed  interest1 abschangepower sumIISBD_other   distance onedemoc democdyad IISbd_1 tdistance tinterest1 timposed   tsumIISBD_other ,  robust nolog cluster(dyad) nohr


*****

clear 
set mem 50m
use "Bayer_JPR_peaceful_democracy.dta"

*Table 2 Model Cold Peace to Warm Peace

 keep if changefromcoldpeace~=.
 stset  coldpeaceend, failure( changefromcoldpeace==1) enter(time  coldpeacestart)  exit(time .)
 stdes

gen timposed = imposed * ln(_t)
gen tinterest1= interest1 * ln(_t)
gen tabschangepower = abschangepower * ln(_t)
gen tdistance = distance * ln(_t)
gen tIISbd_1= IISbd_1 * ln(_t)
gen tsumIISBD_other =  sumIISBD_other * ln(_t)
gen tonedemoc= onedemoc * ln(_t)
gen tdemocdyad=democdyad *ln(_t)

stcox   imposed  interest1 abschangepower  sumIISBD_other  distance   onedemoc democdyad IISbd_1,  robust nolog cluster(dyad) nohr schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sca* sch*
stcox   imposed  interest1 abschangepower  sumIISBD_other  distance onedemoc democdyad IISbd_1  tinterest1 timposed  tIISbd_1 tabschangepower  ,  robust nolog cluster(dyad) nohr


****

clear 
set mem 50m
use "Bayer_JPR_peaceful_democracy.dta"

*Table 2 Model Frozen Peace to War

keep if changefromfrozenpeace~=.
stset  frozenpeaceend, failure(war==1) enter(time frozenpeacestart)  exit(time .)
stdes

gen timposed = imposed * ln(_t)
gen tinterest1= interest1 * ln(_t)
gen tabschangepower = abschangepower * ln(_t)
gen tdistance = distance * ln(_t)
gen tIISbd_1= IISbd_1 * ln(_t)
gen tsumIISBD_other =  sumIISBD_other * ln(_t)
gen tonedemoc= onedemoc * ln(_t)
gen tdemocdyad=democdyad *ln(_t)

stcox    imposed IISbd_1  interest1 abschangepower  sumIISBD_other  distance  onedemoc ,  robust nolog cluster(dyad) nohr schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sca* sch*
stcox   imposed  IISbd_1 interest1 abschangepower sumIISBD_other   distance onedemoc tdistance tinterest1  tabschangepower  tsumIISBD_other  ,  robust nolog cluster(dyad) nohr

****

clear 
set mem 50m
use "Bayer_JPR_peaceful_democracy.dta"

*Table 2 Model Cold Peace to War


keep if changefromcoldpeace~=.
stset  coldpeaceend, failure(war==1) enter(time  coldpeacestart)  exit(time .)
stdes

gen timposed = imposed * ln(_t)
gen tinterest1= interest1 * ln(_t)
gen tabschangepower = abschangepower * ln(_t)
gen tdistance = distance * ln(_t)
gen tIISbd_1= IISbd_1 * ln(_t)
gen tsumIISBD_other =  sumIISBD_other * ln(_t)
gen tonedemoc= onedemoc * ln(_t)
gen tdemocdyad=democdyad *ln(_t)

stcox IISbd_1    imposed  interest1 abschangepower sumIISBD_other   distance  onedemoc ,  robust nolog cluster(dyad) nohr schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sca* sch*
stcox IISbd_1   imposed  interest1 abschangepower  sumIISBD_other  distance onedemoc  tIISbd_1 tsumIISBD_other,  robust nolog cluster(dyad) nohr


