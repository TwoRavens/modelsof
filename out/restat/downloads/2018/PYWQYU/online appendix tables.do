log using "log", text

****************************************  Tables A, B, C and D1 **************************************************
local ages "16_17 18 19_20 26plus"

foreach a of local ages {

use "fars-by-age.dta", clear

*Replace counts of 0 with 0.1

local list "mean_DUI_age_`a' weekend_`a' weekday_`a' nighttime_`a' daytime_`a' accident_`a' mean_nonDUI_age_`a'"
foreach i of local list {
replace `i'=0.1 if `i'==0
}

*Transform variables
gen lnmwdef=ln(mwdef)
gen probit=invnormal(mean_DUI_age_`a'/pop`a')
gen lnorate`a'=ln(mean_nonDUI_age_`a'/pop`a')
gen lnDUI_`a'=ln(mean_DUI_age_`a'/pop`a')
gen probitaccident=invnormal(accident_`a'/pop`a')
gen lnaccident=ln(accident_`a'/pop`a')
gen probitnight=invnormal(nighttime_`a'/pop`a')
gen lnnight=ln(nighttime_`a'/pop`a')
gen lnday=ln(daytime_`a'/pop`a')
gen probitday=invnormal(weekday_`a'/pop`a')
gen probitweekend=invnormal(weekend_`a'/pop`a')
gen lnweekend=ln(weekend_`a'/pop`a')
gen lnweekday=ln(weekday_`a'/pop`a')
gen probitweekday=invnormal(weekday_`a'/pop`a')



*Panel I, Column 1
xi: reg probit mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel I, Column 2
xi: reg probit mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt`a'=(pop`a'*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probit-estxb1)^2
	ge wgt`a'i=1/wgt`a'
	quietly reg rssq9 wgt`a'i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probit mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt`a' xbmn1 rssq9 wgt`a'i iawgt9 awgt9

*Panel I, Column 3
xi: reg lnDUI_`a' lnmwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=pop`a'], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)

	


*Panel II, Column 1
xi: reg probitaccident mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel II, Column 2
xi: reg probitaccident mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt`a'=(pop`a'*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitaccident-estxb1)^2
	ge wgt`a'i=1/wgt`a'
	quietly reg rssq9 wgt`a'i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitaccident mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt`a' xbmn1 rssq9 wgt`a'i iawgt9 awgt9
	
*Panel II, Column 3
xi: reg lnaccident lnmwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=pop`a'], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)


	
	
*Panel III, Column 1
xi: reg probitnight mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel III, Column 2
xi: reg probitnight mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt`a'=(pop`a'*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitnight-estxb1)^2
	ge wgt`a'i=1/wgt`a'
	quietly reg rssq9 wgt`a'i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitnight mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt`a' xbmn1 rssq9 wgt`a'i iawgt9 awgt9
	
*Panel III, Column 3
xi: reg lnnight lnmwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=pop`a'], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)




*Panel IV, Column 1
xi: reg probitday mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel IV, Column 2
xi: reg probitday mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt`a'=(pop`a'*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitday-estxb1)^2
	ge wgt`a'i=1/wgt`a'
	quietly reg rssq9 wgt`a'i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitday mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt`a' xbmn1 rssq9 wgt`a'i iawgt9 awgt9

*Panel IV, Column 3
xi: reg lnday lnmwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=pop`a'], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)

	

	
*Panel V, Column 1
xi: reg probitweekend mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel V, Column 2
xi: reg probitweekend mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt`a'=(pop`a'*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekend-estxb1)^2
	ge wgt`a'i=1/wgt`a'
	quietly reg rssq9 wgt`a'i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekend mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt`a' xbmn1 rssq9 wgt`a'i iawgt9 awgt9

*Panel V, Column 3
xi: reg lnweekend lnmwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=pop`a'], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)




*Panel VI, Column 1
xi: reg probitweekday mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel VI, Column 2
xi: reg probitweekday mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt`a'=(pop`a'*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekday-estxb1)^2
	ge wgt`a'i=1/wgt`a'
	quietly reg rssq9 wgt`a'i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekday mwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt`a' xbmn1 rssq9 wgt`a'i iawgt9 awgt9

*Panel VI, Column 3
xi: reg lnweekday lnmwdef lnorate`a' lpop realbeertax bac lpc_perinc ur`a'_r i.year i.state [aw=pop`a'], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)
}




****************************************  Table D2  **************************************************
use "fars-by-age.dta", clear

*Replace counts of 0 with 0.1

local list "accident_16_20 accident_26plus mean_DUI_age_16_20 weekend_16_20 weekday_16_20 nighttime_16_20 daytime_16_20 accident_16_20 mean_nonDUI_age_16_20"
foreach i of local list {
replace `i'=0.1 if `i'==0
}

*Transform variables
gen lnmwdef=ln(mwdef)

ge probit1620=invnormal(mean_DUI_age_16_20/pop1620)
ge probitnight=invnormal(nighttime_16_20/pop1620)
gen lnnight=ln(nighttime_16_20/pop1620)
ge lnday=ln(daytime_16_20/pop1620)
ge probitday=invnormal(daytime_16_20/pop1620)
ge lnweekday=ln(weekday_16_20/pop1620)
ge probitweekday=invnormal(weekday_16_20/pop1620)
ge lnweekend=ln(weekend_16_20/pop1620)
ge probitweekend=invnormal(weekend_16_20/pop1620)

ge lnnight26p = ln(nighttime_26plus/pop26plus)
ge lnday26p = ln(daytime_26plus/pop26plus)
ge lnweekend26p = ln(weekend_26plus/pop26plus)
ge lnweekday26p = ln(weekday_26plus/pop26plus)
ge lnall26p = ln(accident_26plus/pop26plus)



*Panel I, Column 1
xi: reg probitnight mwdef lnnight26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel I, Column 2
xi: reg probitnight mwdef lnnight26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitnight-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitnight mwdef lnnight26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

*Panel I, Column 3
xi: reg lnnight lnmwdef lnnight26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)


	
	

*Panel II, Column 1
xi: reg probitday mwdef lnday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel II, Column 2
xi: reg probitday mwdef lnday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitday-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitday mwdef lnday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

*Panel II, Column 3
xi: reg lnday lnmwdef lnday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)

	

*Panel III, Column 1
xi: reg probitweekend mwdef lnweekend26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel III, Column 2
xi: reg probitweekend mwdef lnweekend26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekend-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekend mwdef lnweekend26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

*Panel III, Column 3
xi: reg lnweekend lnmwdef lnweekend26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)




*Panel IV, Column 1
xi: reg probitweekday mwdef lnweekday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

*Panel IV, Column 2
xi: reg probitweekday mwdef lnweekday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekday-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekday mwdef lnweekday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9
*Panel IV, Column 3
xi: reg lnweekday lnmwdef lnweekday26p lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)




****************************************  Table E  **************************************************
use "fars.dta", clear
*Replace counts of 0 with 0.1
local list "DUI_1620 tot_acc_nt tot_acc_dt tot_acc_we tot_acc_wd tot_acc_all nonDUI_1620"
foreach i of local list {
replace `i'=0.1 if `i'==0
}

*Transform variables
ge lpci=log(pc_perinc)
ge probit1620=invnormal(DUI_1620/pop1620)
ge lnorate1620 = ln(nonDUI_1620/pop1620)

gen lnDUI_1620=ln(DUI_1620/pop1620)
gen lnmwdef=ln(mwdef)
gen probitnight=invnormal(tot_acc_nt/pop1620)
gen lnnight=ln(tot_acc_nt/pop1620)
gen probitday=invnormal(tot_acc_dt/pop1620)
gen lnday=ln(tot_acc_dt/pop1620)
gen probitweekend=invnormal(tot_acc_we/pop1620)
gen lnweekend=ln(tot_acc_we/pop1620)
gen probitweekday=invnormal(tot_acc_wd/pop1620)
gen lnweekday=ln(tot_acc_wd/pop1620)
gen probitall=invnormal(tot_acc_all/pop1620)
gen lnall=ln(tot_acc_all/pop1620)



*Panel I
xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probit1620-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnDUI_1620 lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)



*Panel II
xi: reg probitall mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitall mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitall-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitall mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnall lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)



*Panel III
xi: reg probitnight mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitnight mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitnight-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitnight mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnnight lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)
	
	

*Panel IV
xi: reg probitday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitday-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnday lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)


	

*Panel V
xi: reg probitweekend mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitweekend mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekend-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekend mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnweekend lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=pop1620], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)



*Panel VI
xi: reg probitweekday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitweekday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekday-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnweekday lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state*year [aw=pop1620], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)




****************************************  Table F  **************************************************
******* Table F - YRBS - Column 1 ********
use "mw-drinking-yrbs",clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq black hispanic other_race i.grade male nat_indicator i.year"
keep if inrange(age,16,18)

*Panel I, column 1
xi: dprobit anyalcohol $X i.fips*year [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, column 1
xi: dprobit bingedrinks $X i.fips*year [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, column 1
xi: dprobit freqbinge $X i.fips*year [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, column 1
xi: dprobit drunkdrive $X i.fips*year [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)



******* Table F - BRFSS - Columns 2-4 ********
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.race male i.educ i.year"

*Panel I, columns 2-4
xi: dprobit anyalcohol $X i.state*year if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state*year if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state*year if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, columns 2-4
xi: dprobit bingedrinks $X i.state*year if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state*year if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state*year if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, columns 2-4
xi: dprobit freqbinge $X i.state*year if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state*year if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state*year if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, columns 2-4
xi: dprobit drunkdrive $X i.state*year if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state*year if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state*year if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)




****************************************  Table G  **************************************************
use "mw-drive-controls-org9113-clean", replace

set more off
set matsize 10000
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.wbho i.educ male i.year"

*Panel I
*Hourly Earings|Employment
xi: reg cwage $X i.state*year [pweight=earnwt] if inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state*year [pweight=earnwt] if inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state*year [pweight=earnwt] if inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II
*Usual Weekly Earnings
xi: reg wkearn $X i.state*year [pweight=earnwt] if inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state*year [pweight=earnwt] if inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state*year [pweight=earnwt] if inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III
*Employment
xi: dprobit empl $X i.state*year [pweight=weight] if inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state*year [pweight=weight] if inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state*year [pweight=weight] if inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)


*Panel IV
*Usual Weekly Uhours|Employment
xi: reg cuhours $X i.state*year [pweight=weight] if inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state*year [pweight=weight] if inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state*year [pweight=weight] if inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)




****************************************  Table H  **************************************************
******* YRBS - Column 1 ********
use "mw-drinking-yrbs",clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc age age_sq black hispanic other_race i.grade male nat_indicator i.year"
keep if inrange(age,16,18)

*Panel I, column 1
xi: dprobit anyalcohol $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, column 1
xi: dprobit bingedrinks $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, column 1
xi: dprobit freqbinge $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, column 1
xi: dprobit drunkdrive $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)



****************************************  Table I  **************************************************
use "mw-drive-controls-org9113-clean", replace

set more off
set matsize 10000
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc age age_sq i.wbho i.educ male i.year"

*Panel I
*Hourly Earings|Employment
xi: reg cwage $X i.state [pweight=earnwt] if inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II
*Usual Weekly Earnings
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III
*Employment
xi: dprobit empl $X i.state [pweight=weight] if inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)


*Panel IV
*Usual Weekly Uhours|Employment
xi: reg cuhours $X i.state [pweight=weight] if inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)




*********************************************************************************************************************
******* BRFSS - Columns 2-4 ********
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc age age_sq i.race male i.educ i.year"

*Panel I, columns 2-4
xi: dprobit anyalcohol $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, columns 2-4
xi: dprobit bingedrinks $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, columns 2-4
xi: dprobit freqbinge $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, columns 2-4
xi: dprobit drunkdrive $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)



****************************************  Table J  **************************************************
******* YRBS - Column 1 ********
use "mw-drinking-yrbs",clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq black hispanic other_race i.grade male nat_indicator i.year"
keep if inrange(age,16,18)

*Panel I, column 1
xi: dprobit anyalcohol $X i.fips if inrange(year,1998,2006) [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, column 1
xi: dprobit bingedrinks $X i.fips if inrange(year,1998,2006) [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, column 1
xi: dprobit freqbinge $X i.fips if inrange(year,1998,2006) [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, column 1
xi: dprobit drunkdrive $X i.fips if inrange(year,1998,2006) [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)



*********************************************************************************************************************
******* BRFSS - Columns 2-4 ********
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.race male i.educ i.year"

*Panel I, columns 2-4
xi: dprobit anyalcohol $X i.state if inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==1 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==0 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, columns 2-4
xi: dprobit bingedrinks $X i.state if inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==1 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==0 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, columns 2-4
xi: dprobit freqbinge $X i.state if inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==1 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==0 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, columns 2-4
xi: dprobit drunkdrive $X i.state if inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==1 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==0 & inrange(year,1998,2006) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)





****************************************  Table K  **************************************************
use "mw-drive-controls-org9113-clean", replace

set more off
set matsize 10000
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.wbho i.educ male i.year"

*Panel I
*Hourly Earings|Employment
xi: reg cwage $X i.state [pweight=earnwt] if inrange(year,1998,2006) & inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if inrange(year,1998,2006) & inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if inrange(year,1998,2006) & inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II
*Usual Weekly Earnings
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(year,1998,2006) & inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(year,1998,2006) & inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(year,1998,2006) & inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III
*Employment
xi: dprobit empl $X i.state [pweight=weight] if inrange(year,1998,2006) & inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if inrange(year,1998,2006) & inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if inrange(year,1998,2006) & inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)


*Panel IV
*Usual Weekly Uhours|Employment
xi: reg cuhours $X i.state [pweight=weight] if inrange(year,1998,2006) & inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if inrange(year,1998,2006) & inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if inrange(year,1998,2006) & inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)




****************************************  Table L  **************************************************
******* YRBS - Column 1 ********
use "mw-drinking-yrbs",clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq black hispanic other_race i.grade male nat_indicator i.year"
keep if inrange(age,16,18)

*Panel I
sum alcohol_days if anyalcohol==1
xi: nbreg alcohol_days $X i.fips [pweight= state_pops] if anyalcohol==1, cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II
sum bingedrinks_days if bingedrinks==1
xi: nbreg bingedrinks_days $X i.fips [pweight= state_pops] if bingedrinks, cl(fips)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III
sum drunkdrive_fre if drunkdrive==1
xi: reg drunkdrive_fre $X i.fips [pweight= state_pops] if drunkdrive==1, cl(fips)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)



******* BRFSS - Columns 2-4 ********
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.race male i.educ i.year"

*Panel I
sum drinkmo if drinkmo>=1
xi: reg drinkmo $X i.state if drinkmo>=1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg drinkmo $X i.state if drinkmo>=1 & employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg drinkmo $X i.state if drinkmo>=1 & employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg using "Table 3-BRFSS-No of drinks", se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II
sum bingedrinks_days if bingedrinks==1
xi: nbreg bingedrinks_days $X i.state if bingedrinks==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: nbreg bingedrinks_days $X i.state if bingedrinks==1 & employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: nbreg bingedrinks_days $X i.state if bingedrinks==1 & employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg using "Table 3-BRFSS-Binge drink days", se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III
sum drunkdrive_fre if drunkdrive==1
xi: reg drunkdrive_fre $X i.state if drunkdrive==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg drunkdrive_fre $X i.state if drunkdrive==1 & employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg drunkdrive_fre $X i.state if drunkdrive==1 & employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg using "Table 3-BRFSS-Drink drive freq", se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)




****************************************  Table M  **************************************************
******* YRBS - Column 1 ********
use "mw-drinking-yrbs",clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq black hispanic other_race i.grade male nat_indicator i.year"
keep if inrange(age,16,18)

* male==0:female and male==1: male
foreach i in 0 1 {
*Panel I, column 1
xi: dprobit anyalcohol $X i.fips if male==`i' [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, column 1
xi: dprobit bingedrinks $X i.fips if male==`i' [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, column 1
xi: dprobit freqbinge $X i.fips if male==`i' [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, column 1
xi: dprobit drunkdrive $X i.fips if male==`i' [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
}


******* BRFSS - Columns 2-4 ********
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.race male i.educ i.year"

* male==0:female and male==1: male
foreach i in 0 1 {
*Panel I, columns 2-4
xi: dprobit anyalcohol $X i.state if male==`i' & inrange(year ,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, columns 2-4
xi: dprobit bingedrinks $X i.state if male==`i' & inrange(year ,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, columns 2-4
xi: dprobit freqbinge $X i.state if male==`i' & inrange(year ,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, columns 2-4
xi: dprobit drunkdrive $X i.state if male==`i' & inrange(year ,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
}



****************************************  Table N  **************************************************
use "mw-drive-controls-org9113-clean", replace

set more off
set matsize 10000
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.wbho i.educ male i.year"

* male==0:female and male==1: male
foreach i in 0 1 {
*Panel I
*Hourly Earings|Employment
xi: reg cwage $X i.state [pweight=earnwt] if male==`i' & inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if male==`i' & inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if male==`i' & inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II
*Usual Weekly Earnings
xi: reg wkearn $X i.state [pweight=earnwt] if male==`i' & inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if male==`i' & inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if male==`i' & inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III
*Employment
xi: dprobit empl $X i.state [pweight=weight] if male==`i' & inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if male==`i' & inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if male==`i' & inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)


*Panel IV
*Usual Weekly Uhours|Employment
xi: reg cuhours $X i.state [pweight=weight] if male==`i' & inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if male==`i' & inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if male==`i' & inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
}



****************************************  Table O  **************************************************
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc age age_sq i.race male i.educ i.year"
keep if educ==1
*Panel I, columns 1-3
xi: dprobit anyalcohol $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel II, columns 1-3
xi: dprobit bingedrinks $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel III, columns 1-3
xi: dprobit freqbinge $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Panel IV, columns 1-3
xi: dprobit drunkdrive $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

log close
