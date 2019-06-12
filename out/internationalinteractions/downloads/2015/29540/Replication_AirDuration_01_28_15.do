//Replication materials for "Air Campaign Duration and the Interaction of Air
//and Ground Forces"
//Carla Martinez Machain
//January 28, 2015

//Main document
//Unless stated otherwise, all tables and figures are formed using the file named "ReplicationAirDurationData1"

//Table 1
**See main document (not a STATA table)

//Table 2
la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950" 
la var powerratio "Power ratio"
la var pastcampaign "Past campaigns against target"

stset duration
streg ground percenmod modairgrcont post1950 demand powerratio pastcampaign, distribution(weibull) time

eststo

#delimit;
esttab using weibulltable.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles sca(p)
title("Weibull Duration Analysis: Duration of Aerial Campaigns, Accelerated failure-time form")  replace;

//Table 3

la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950"
la var pastcampaign "Past campaigns against target"
la var cinca "Capabilities" 
la var powerratio "Power ratio"
la var airpower "Use of Air Power"
la var revstata "Revisionist State"

dursel duration ground percenmod modairgrcont post1950 demand powerratio pastcampaign, select (airpower= revstata cinca powerratio post1950) dist(weibull) time


eststo

#delimit;
esttab using durseltable.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles aic bic
title("Table 4: Duration Selection Model")  replace;

//Figure 1
drop if powerratio==.
drop if percenmod==.
#delimit;
histogram duration, percent bin(40) color(gs7) 
	title("Distribution of Campaign Durations");

//Figure 2
drop if powerratio==. //this gets rid of the non-state cases
#delimit;
histogram percenmod, percent bin(40) color(gs7) 
	xtitle ("Selective Air Power Level")
	ytitle ("Percent of Cases")
	title("Distribution of Aerial Strategy Coding");

//Figure 3
	estsimp weibull duration ground percenmod modairgrcont post1950 demand powerratio pastcampaign 
	setx post1950 median demand median powerratio median pastcampaign median 

set more off

generate plo0=.
generate phi0=.
generate plo1=.
generate phi1=.
generate m0=.
generate m1=.
gen modaxis= 0 in 1/80
gen modaxis2= 0 in 1/80
egen count = seq(), from(20) to(90)
replace count = .01*count
replace modaxis = count
replace modaxis2=count + .005


 
local a = .2
local b = 1
while `a' <= .9 {
 display "Simulating for percenmod = `a'"
 setx ground 0 percenmod `a' modairgrcont 0
 simqi, genev(ground0)
 _pctile ground0, p(5.0,95.0)
 replace plo0 = r(r1) in `b'
 replace phi0 = r(r2) in `b'
 replace m0= (plo0 + phi0)/2
 setx ground 1 modairgrcont `a' percenmod `a'
 simqi, genev(ground1)
 _pctile ground1, p(5.0, 95.0)
 replace plo1 = r(r1) in `b'
 replace phi1 = r(r2) in `b'
 replace plo1 = plo1
 replace phi1 = phi1
 replace m1 = (plo1+phi1)/2
 drop ground0 ground1
 local b = `b' + 1
 local a= `a' + .01
}
 
sort modaxis
set textsize 130

#delimit;
graph twoway (rspike plo0 phi0 modaxis,color(gs10)) (rspike plo1 phi1 modaxis2,color(gs2)) (scatter m0 modaxis, mcolor(red) msize(tiny)) (scatter m1 modaxis2, mcolor(red) msize(tiny)),
 title(Campaign Duration and Selective Air Power)
 subtitle("by ground troop presence")
 legend(label(1 "No Ground Troops") label(2 "Ground Troops") label(3 "") label(4 ""))
 ytitle("Campaign Duration, months")
 ylabel(,grid glwidth(medium)glpattern(solid))
 plotregion(fcolor(white)) graphregion(fcolor(white))
 yscale(range(0 100))
 xtitle(Selective Air Power)
 xscale(range(.2 .8)) xlabel(.2(.1).9) ;

 //Figure 4
	estsimp weibull duration ground percenmod modairgrcont post1950 demand powerratio pastcampaign 
	setx post1950 median demand median powerratio median pastcampaign median 

set more off

generate plo0=.
generate phi0=.
generate plo1=.
generate phi1=.
generate plom=.
generate phim=.
generate m0=.
generate m1=.
generate difference=.
gen modaxis= 0 in 1/80
gen modaxis2= 0 in 1/80
egen count = seq(), from(20) to(90)
replace count = .01*count
replace modaxis = count
replace modaxis2=count + .005


 
local a = .2
local b = 1
while `a' <= .9 {
 display "Simulating for percenmod = `a'"
 setx ground 0 percenmod `a' modairgrcont 0
 simqi, genev(ground0)
 _pctile ground0, p(5.0,95.0)
 replace plo0 = r(r1) in `b'
 replace phi0 = r(r2) in `b'
 replace m0= (plo0 + phi0)/2
 setx ground 1 modairgrcont `a' percenmod `a'
 simqi, genev(ground1)
 _pctile ground1, p(5.0, 95.0)
 replace plo1 = r(r1) in `b'
 replace phi1 = r(r2) in `b'
 replace plo1 = plo1
 replace phi1 = phi1
 replace m1 = (plo1+phi1)/2
 replace difference=m1-m0
 replace plom=plo1-plo0
 replace phim=phi1-phi0
 drop ground0 ground1
 local b = `b' + 1
 local a= `a' + .01
}
 
sort modaxis
set textsize 130

gen yline=0

#delimit;
graph twoway (rspike phim plom modaxis,color(gs10))  (scatter difference modaxis, mcolor(red) msize(tiny))(line yline modaxis,clwidth(thin) clcolor(black) clpattern(solid)),
 title(Difference Between Scenarios)
 subtitle("The Effect of Including Ground Troops")
 ytitle("Difference in Estimated Duration")
 ylabel(,grid glwidth(medium)glpattern(solid))
 plotregion(fcolor(white)) graphregion(fcolor(white))
 yscale(range(0 100))
 xtitle(Selective Air Power)
 xscale(range(.2 .8)) xlabel(.2(.1).9)
 legend(off);
 
 //Appendix
 
//Table 1 is formed using the file named "ReplicationAirDurationData2". All other tables are formed using the file named "ReplicationAirDurationData1"
 
 //Table A1
la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950" 
la var powerratio "Power ratio"
la var attalliances "Attacker Alliances"
la var taralliances "Target Alliances"

stset duration
streg ground percenmod modairgrcont post1950 demand powerratio taralliances attalliances, distribution(weibull) time

eststo

#delimit;
esttab using alliancetable.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles sca(p)
title("Weibull Duration Analysis: Duration of Aerial Campaigns, Accelerated failure-time form (including alliances)")  replace;

 //Table A2

la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950"
la var post1970 "Post-1970"
la var cinca "Capabilities" 
la var powerratio "Power ratio"
la var airpower "Use of Air Power"
la var revstata "Revisionist State"
la var pastcampaign "Past Aerial Campaign"
stset duration
streg ground percenmod modairgrcont post1950 post1970 demand powerratio pastcampaign, distribution(weibull) time


eststo

#delimit;
esttab using weibullpost1970.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles aic bic
title("Weibull Model, with post-1970 variable")  replace;
 
 //Table A3

la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950"
la var post1970 "Post-1970"
la var cinca "Capabilities" 
la var powerratio "Power ratio"
la var airpower "Use of Air Power"
la var revstata "Revisionist State"
la var pastcampaign "Past Aerial Campaign"
dursel duration ground percenmod modairgrcont post1950 post1970 demand powerratio pastcampaign, select (airpower= revstata cinca powerratio post1950) dist(weibull) time


eststo

#delimit;
esttab using durseltable1970.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles aic bic
title("Duration Selection Model, with Post-1970 variable")  replace;
 
 //Table A4
 la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950" 
la var powerratio "Power ratio"
la var pastcampaign "Past campaigns against target"
la var pastcampaignwin "Past successful campaigns against target"

stset duration
streg ground percenmod modairgrcont post1950 demand powerratio pastcampaign pastcampaignwin, distribution(weibull) time

eststo

#delimit;
esttab using weibulltable2.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles sca(p)
title("Weibull Duration Analysis: Duration of Aerial Campaigns, Accelerated failure-time form")  replace;

//Table A5
correlate ground percenmod post1950 demand powerratio pastcampaign 

//Table A6
la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950" 
la var powerratio "Power ratio"
la var pastcampaign "Past campaigns against target"

stset duration
stcox ground percenmod modairgrcont post1950 demand powerratio pastcampaign

eststo

#delimit;
esttab using coxtable.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles sca(p)
title("Cox Duration Analysis: Duration of Aerial Campaigns")  replace;

//Table A7
	//Success Model
	stset duration, failure(outcome==1)
	streg ground percenmod modairgrcont post1950 demand powerratio, distribution(weibull) time
	//Wald test
	test ground percenmod modairgrcont post1950 demand powerratio
	//Failure Model
	stset duration, failure(foutcome==1)
	streg ground percenmod modairgrcont post1950 demand powerratio, distribution(weibull) time
	//Wald test
	test ground percenmod modairgrcont post1950 demand powerratio

//Table A8
**see Appendix (not a STATA table)

//Table A9
la var duration "Duration"
la var ground "Ground Forces Present"
la var percenmod "Selective Air Power"
la var modairgrcont "Interaction of Selective Air Power and Ground Forces Present"
la var demand "Large Demand"
la var post1950 "Post-1950" 
la var powerratio "Power ratio"
la var cinca "Attacker Capabilities"
la var pastcampaign "Past campaigns against target"

stset duration
streg ground percenmod modairgrcont post1950 demand powerratio pastcampaign cinca, distribution(weibull) time
eststo

#delimit;
esttab using alliancetable.rtf, se starlevels(* .10 ** .05 *** .01) label nodepvars nomtitles sca(p)
title("Weibull Duration Analysis: Duration of Aerial Campaigns, Accelerated failure-time form (including Attacker Capabilities)")  replace;

