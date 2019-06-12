


**************************** Table 1 *************************************
*Panel I (FARS)
use "fars.dta", clear
sum DUI_1620 tot_acc_all tot_acc_nt tot_acc_dt tot_acc_we tot_acc_wd


*Panel II (YRBS)
use "mw-drinking-yrbs.dta", clear
reg mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq black hispanic other_race i.grade male nat_indicator i.year
keep if e(sample)
sum anyalcohol bingedrinks freqbinge drunkdrive [aw=state_pops] if inrange(age,16,18)

 
*Panel III (BRFSS)
use "BRFSS Clean Coded Dropped.dta", clear
reg mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.race male i.educ i.year
keep if e(sample)
sum anyalcohol bingedrinks freqbinge drunkdrive [aw=_finalwt] if inrange(age,18,20)

*Panel IV (CPS)
use "mw-drive-controls-org9113-clean", replace
reg mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.wbho i.educ male i.year
keep if e(sample)
sum w_no_no [aweight= earnwt] if earnings_ind==1 & inrange(age,16,20)
sum wkearn [aweight= earnwt] if empl_ind==1 & inrange(age,16,20)
sum empl [aweight=weight] if empl_ind==1 & inrange(age,16,20)
sum cuhours [aweight=weight] if earnings_ind==1 & inrange(age,16,20)


*********************************************************************************************************************
***** Table 2 *****
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



*********************************************************************************************************************
*Table 2, Panel I
xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probit1620-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probit1620 mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnDUI_1620 lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)

*********************************************************************************************************************
*Table 2, Panel II
xi: reg probitall mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitall mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitall-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitall mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9


xi: reg lnall lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)


*********************************************************************************************************************
*Table 2, Panel III
xi: reg probitnight mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitnight mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitnight-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitnight mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnnight lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)
	
	
********************************************************************************************************************
*Table 2, Panel IV
xi: reg probitday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)


xi: reg probitday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitday-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnday lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
	outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)


	
*********************************************************************************************************************
*Table 2, Panel V
xi: reg probitweekend mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitweekend mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekend-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekend mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9

xi: reg lnweekend lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)


*********************************************************************************************************************
*Table 2, Panel VI
xi: reg probitweekday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	outreg, replace se keep(mwdef) starlevel(10 5 1)  starloc(1)

xi: reg probitweekday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state, cluster(state)
	predict estxb1, xb
	ge wgt1620=(pop1620*normalden(estxb1)^2)/(normal(estxb1)*(1-normal(estxb1)))
	egen xbmn1=mean(estxb1)
	ge rssq9=(probitweekday-estxb1)^2
	ge wgt1620i=1/wgt1620
	quietly reg rssq9 wgt1620i
	predict iawgt9
	ge awgt9=1/iawgt9
xi: reg probitweekday mwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=awgt9], cluster(state)
	outreg, merge se keep(mwdef) starlevel(10 5 1)  starloc(1)
	drop estxb1 wgt1620 xbmn1 rssq9 wgt1620i iawgt9 awgt9


xi: reg lnweekday lnmwdef lnorate1620 lpop realbeertax bac lpc_perinc ur1620_r i.year i.state [aw=pop1620], cluster(state)
outreg, merge se keep(lnmwdef) starlevel(10 5 1)  starloc(1)





*********************************************************************************************************************
******* Table 3 ********
use "mw-drive-controls-org9113-clean", replace

set more off
set matsize 10000
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.wbho i.educ male i.year"

*Table 3, Panel I
*Hourly Earnings|Employment
xi: reg cwage $X i.state [pweight=earnwt] if inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cwage $X i.state [pweight=earnwt] if inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 3, Panel II
*Usual Weekly Earnings
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg wkearn $X i.state [pweight=earnwt] if inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 3, Panel III
*Employment
xi: dprobit empl $X i.state [pweight=weight] if inrange(age,16,20) & empl_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if inrange(age,16,18) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit empl $X i.state [pweight=weight] if inrange(age,18,20) & empl_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)


*Table 3, Panel IV
*Usual Weekly Uhours|Employment
xi: reg cuhours $X i.state [pweight=weight] if inrange(age,16,20) & earnings_ind==1, cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if inrange(age,16,18) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: reg cuhours $X i.state [pweight=weight] if inrange(age,18,20) & earnings_ind==1, cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)


*********************************************************************************************************************
******* Table 4 - YRBS - Column 1 ********
use "mw-drinking-yrbs",clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq black hispanic other_race i.grade male nat_indicator i.year"
keep if inrange(age,16,18)

*Table 4, Panel I, column 1
xi: dprobit anyalcohol $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 4, Panel II, column 1
xi: dprobit bingedrinks $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 4, Panel III, column 1
xi: dprobit freqbinge $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 4, Panel IV, column 1
xi: dprobit drunkdrive $X i.fips [pweight= state_pops], cl(fips)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)



*********************************************************************************************************************
******* Table 4 - BRFSS - Columns 2-4 ********
use "BRFSS Clean Coded Dropped.dta", clear
global X "mwdef lpop lnorate1620 realbeertax bac lpc_perinc ur1620_r age age_sq i.race male i.educ i.year"

*Table 4, Panel I, columns 2-4
xi: dprobit anyalcohol $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit anyalcohol $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 4, Panel II, columns 2-4
xi: dprobit bingedrinks $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit bingedrinks $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 4, Panel III, columns 2-4
xi: dprobit freqbinge $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit freqbinge $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

*Table 4, Panel IV, columns 2-4
xi: dprobit drunkdrive $X i.state if inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se replace starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==1 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)
xi: dprobit drunkdrive $X i.state if employed==0 & inrange(year,1991,2013) [pweight= _finalwt], cl(state)
outreg, se merge starlevels(10 5 1) keep(mwdef) starloc(1) summstat(N)

