**************************
**Prepare the country list
**************************
insheet using ".\data\simulation_country_list.csv", clear
ren v1 cnum
ren v2 ccode
gen matnum=_n
sort matnum
local new = _N + 1
set obs `new'
replace ccode="ROW" if ccode==""
replace matnum=matnum[_n-1]+1 if ccode=="ROW"
sort matnum
save ".\data\templist", replace

************************
**Read the border wedges
************************
clear
gen temp=.
save ".\data\inputtemp", replace
forvalues yr=1970/2008 {
local yr1=`yr'
local yr2=`yr'+1
insheet ematnum imatnum from to tauhat blank using "./simulation_output/input_border_wedges_`yr1'_`yr2'.txt", clear
drop blank
gen year=`yr2'
gen type="input"
append using ".\data\inputtemp"
save ".\data\inputtemp", replace
}

clear
gen temp=.
save ".\data\finaltemp", replace
forvalues yr=1970/2008 {
local yr1=`yr'
local yr2=`yr'+1
insheet ematnum imatnum to tauhat blank using "./simulation_output/final_border_wedges_`yr1'_`yr2'.txt", clear
drop blank
gen year=`yr2'
gen from=to
gen type="final"
append using ".\data\finaltemp"
save ".\data\finaltemp", replace
}

use ".\data\inputtemp", clear
append using ".\data\finaltemp"
drop temp
erase ".\data\inputtemp.dta"
erase ".\data\finaltemp.dta"

*****************
**Format the data
*****************

**Merge on names
ren ematnum matnum
sort matnum
merge matnum using ".\data\templist"
keep if _merge==3
drop _merge
ren matnum ematnum
ren ccode ecode
ren cnum enum
ren imatnum matnum
sort matnum
merge matnum using ".\data\templist"
keep if _merge==3
drop _merge
ren matnum imatnum
ren ccode icode
ren cnum inum

drop if ecode==icode
sort ecode icode from to

**Create 1970 observations for merging below
expand 2 if year==1971, generate(marker)
replace tauhat=1 if marker==1
replace year=1970 if marker==1
drop marker

**Cumulate the wedges to track levels over time -- i.e., ratio changes since 1970
egen id=group(ecode icode from to type)
egen yr=group(year)
tsset id yr
bys id (yr): gen cumtauhat=exp(sum(ln(tauhat)))
drop id yr

****************************************
**Define RTAs and Full Set of Agreements
****************************************
sort ecode icode year
merge ecode icode year using "./data/EIAdata.dta"
keep if _merge==3 /*37*36*6*40 observations*/
drop _merge

replace eia="0" if eia=="NoCty" /*These are wierd Thailand 1970-1974 pre-revolution observations*/
destring eia, replace
gen rta=eia>=3
gen pta=eia==1 | eia==2
gen fta=eia==3
gen cucmeu=eia==4 | eia==5 | eia==6

***********
**Save data
***********
save ".\data\wedges_with_eia", replace

**********************************
**Format Panel Data for Estimation
**********************************

keep if year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000 | year==2005 | year==2009
gen logcumtauhat=ln(cumtauhat)

**Identify panel
egen id=group(ecode icode from to type)
egen yr=group(year)
tsset id yr

**Define Phase In
gen temp=yr if rta==1 & L.rta==0
by id, sort: egen adoptionyear=median(temp)
gen yrsafterrta=yr-adoptionyear
replace yrsafterrta=-99 if yrsafterrta==.
gen zero=yrsafterrta==0
gen one=yrsafterrta==1
gen two=yrsafterrta==2
gen threemore=yrsafterrta>=3

**Form first differences
foreach var in logcumtauhat rta pta fta cucmeu zero one two threemore {
	gen `var'diff=`var'-L.`var'
}

save ".\data\wedges_with_eia_panel", replace

set matsize 11000
************************************************************
**Estimate Trade Costs using First Differences Specification
************************************************************

**For inputs
clear
gen temp=.
save ".\data\trade_costs_adjustment", replace

forvalues fromsector=1/2 {
	forvalues tosector=1/2 {
	
	use if from==`fromsector' & to==`tosector' & type=="input" using ".\data\wedges_with_eia_panel", clear
	egen pair=group(ecode icode)
	egen exp_year=group(ecode year)
	egen imp_year=group(icode year)
	
	**Run estimation for RTAs
	qui: xi: areg logcumtauhatdiff i.exp_year rtadiff, absorb(imp_year) vce(cluster pair)
	estimates store input_rta_`fromsector'_`tosector'
	mat rtabeta=e(b)
	local rtacoeffnum=colsof(rtabeta)-1
	mat rta=rtabeta[1,`rtacoeffnum']
	svmat rta
	egen rtacoeff=median(rta1)
	gen rtatemp=rta if year==1970
	by icode ecode, sort: egen rta1970=max(rtatemp)
	gen rta_adjustment=1/exp(rtacoeff*(rta-rta1970)) /*this multiplies by RTA_t-RTA_1970 -- this adjusts only for agreements signed post-1970*/
	
	**Run estimation with RTA phase in
	qui: xi: areg logcumtauhatdiff i.exp_year zerodiff onediff twodiff threemorediff, absorb(imp_year) vce(cluster pair)
	estimates store input_rtaphasein_`fromsector'_`tosector'
	mat phasebeta=e(b)
	local zero_coeff_num=colsof(phasebeta)-4
	local one_coeff_num=colsof(phasebeta)-3
	local two_coeff_num=colsof(phasebeta)-2
	local three_coeff_num=colsof(phasebeta)-1
	mat zero_temp=phasebeta[1,`zero_coeff_num']
	mat one_temp=phasebeta[1,`one_coeff_num']
	mat two_temp=phasebeta[1,`two_coeff_num']
	mat three_temp=phasebeta[1,`three_coeff_num']
	svmat zero_temp
	svmat one_temp
	svmat two_temp
	svmat three_temp
	egen zero_coeff=median(zero_temp1)
	egen one_coeff=median(one_temp1)
	egen two_coeff=median(two_temp1)
	egen three_coeff=median(three_temp1)
	gen adj_zero=1/exp(zero_coeff*(zero-rta1970))
	gen adj_one=1/exp(one_coeff*(one-rta1970))
	gen adj_two=1/exp(two_coeff*(two-rta1970))
	gen adj_three=1/exp(three_coeff*(threemore-rta1970))
	gen phaserta_adjustment=adj_zero*adj_one*adj_two*adj_three

	**Run estimation separating agreements
	qui: xi: areg logcumtauhatdiff i.exp_year ptadiff ftadiff cucmeudiff, absorb(imp_year) vce(cluster pair)
	estimates store input_fullset_`fromsector'_`tosector'
	mat fullbeta=e(b)
	local cucmeu_coeff_num=colsof(fullbeta)-1
	local fta_coeff_num=colsof(fullbeta)-2
	local pta_coeff_num=colsof(fullbeta)-3
	mat cucmeu_temp=fullbeta[1,`cucmeu_coeff_num']
	mat fta_temp=fullbeta[1,`fta_coeff_num']
	mat pta_temp=fullbeta[1,`pta_coeff_num']
	svmat cucmeu_temp
	svmat fta_temp
	svmat pta_temp
	egen cucmeu_coeff=median(cucmeu_temp1)
	egen fta_coeff=median(fta_temp1)
	egen pta_coeff=median(pta_temp1)
	gen ptatemp=pta if year==1970
	by icode ecode, sort: egen pta1970=max(ptatemp)
	gen ftatemp=fta if year==1970
	by icode ecode, sort: egen fta1970=max(ftatemp)
	gen cucmeutemp=cucmeu if year==1970
	by icode ecode, sort: egen cucmeu1970=max(cucmeutemp)
	gen adj_pta=1/exp(pta_coeff*(pta-pta1970))
	gen adj_fta=1/exp(fta_coeff*(fta-fta1970))
	gen adj_cucmeu=1/exp(cucmeu_coeff*(cucmeu-cucmeu1970))
	gen fullset_adjustment=adj_pta*adj_fta*adj_cucmeu
	*gen adj_cumtauhat_fullset=adj_pta*adj_fta*adj_cucmeu*cumtauhat
	
	**Prep and append data
	keep ematnum ecode imatnum icode from to year rta_adjustment phaserta_adjustment fullset_adjustment type
	order ematnum ecode imatnum icode from to year rta_adjustment phaserta_adjustment fullset_adjustment type
	ren year mergeyear
	append using ".\data\trade_costs_adjustment"
	save ".\data\trade_costs_adjustment", replace
}
}

**For final goods
forvalues sector=1/2 {
	use if from==`sector' & to==`sector' & type=="final" using ".\data\wedges_with_eia_panel", clear
	egen pair=group(ecode icode)
	egen exp_year=group(ecode year)
	egen imp_year=group(icode year)
	
	**Run estimation for RTAs
	qui: xi: areg logcumtauhatdiff i.exp_year rtadiff, absorb(imp_year) vce(cluster pair)
	estimates store final_rta_`sector'
	mat rtabeta=e(b)
	local rtacoeffnum=colsof(rtabeta)-1
	mat rta=rtabeta[1,`rtacoeffnum']
	svmat rta
	egen rtacoeff=median(rta1)
	gen rtatemp=rta if year==1970
	by icode ecode, sort: egen rta1970=max(rtatemp)
	gen rta_adjustment=1/exp(rtacoeff*(rta-rta1970)) /*this multiplies by RTA_t-RTA_1970 -- this adjusts only for agreements signed post-1970*/
	
	**Run estimation with RTA phase in
	qui: xi: areg logcumtauhatdiff i.exp_year zerodiff onediff twodiff threemorediff, absorb(imp_year) vce(cluster pair)
	estimates store final_rtaphasein_`sector'
	mat phasebeta=e(b)
	local zero_coeff_num=colsof(phasebeta)-4
	local one_coeff_num=colsof(phasebeta)-3
	local two_coeff_num=colsof(phasebeta)-2
	local three_coeff_num=colsof(phasebeta)-1
	mat zero_temp=phasebeta[1,`zero_coeff_num']
	mat one_temp=phasebeta[1,`one_coeff_num']
	mat two_temp=phasebeta[1,`two_coeff_num']
	mat three_temp=phasebeta[1,`three_coeff_num']
	svmat zero_temp
	svmat one_temp
	svmat two_temp
	svmat three_temp
	egen zero_coeff=median(zero_temp1)
	egen one_coeff=median(one_temp1)
	egen two_coeff=median(two_temp1)
	egen three_coeff=median(three_temp1)
	gen adj_zero=1/exp(zero_coeff*(zero-rta1970))
	gen adj_one=1/exp(one_coeff*(one-rta1970))
	gen adj_two=1/exp(two_coeff*(two-rta1970))
	gen adj_three=1/exp(three_coeff*(threemore-rta1970))
	gen phaserta_adjustment=adj_zero*adj_one*adj_two*adj_three

	**Run estimation separating agreements
	qui: xi: areg logcumtauhatdiff i.exp_year ptadiff ftadiff cucmeudiff, absorb(imp_year) vce(cluster pair)
	estimates store final_fullset_`sector'
	mat fullbeta=e(b)
	local cucmeu_coeff_num=colsof(fullbeta)-1
	local fta_coeff_num=colsof(fullbeta)-2
	local pta_coeff_num=colsof(fullbeta)-3
	mat cucmeu_temp=fullbeta[1,`cucmeu_coeff_num']
	mat fta_temp=fullbeta[1,`fta_coeff_num']
	mat pta_temp=fullbeta[1,`pta_coeff_num']
	svmat cucmeu_temp
	svmat fta_temp
	svmat pta_temp
	egen cucmeu_coeff=median(cucmeu_temp1)
	egen fta_coeff=median(fta_temp1)
	egen pta_coeff=median(pta_temp1)
	gen ptatemp=pta if year==1970
	by icode ecode, sort: egen pta1970=max(ptatemp)
	gen ftatemp=fta if year==1970
	by icode ecode, sort: egen fta1970=max(ftatemp)
	gen cucmeutemp=cucmeu if year==1970
	by icode ecode, sort: egen cucmeu1970=max(cucmeutemp)
	gen adj_pta=1/exp(pta_coeff*(pta-pta1970))
	gen adj_fta=1/exp(fta_coeff*(fta-fta1970))
	gen adj_cucmeu=1/exp(cucmeu_coeff*(cucmeu-cucmeu1970))
	gen fullset_adjustment=adj_pta*adj_fta*adj_cucmeu
	
	**Prep and append data
	keep ematnum ecode imatnum icode from to year rta_adjustment phaserta_adjustment fullset_adjustment type
	order ematnum ecode imatnum icode from to year rta_adjustment phaserta_adjustment fullset_adjustment type
	ren year mergeyear
	append using ".\data\trade_costs_adjustment"
	save ".\data\trade_costs_adjustment", replace
}	

**************************************
**Construct Counterfactual Trade Costs
**************************************
use ".\data\wedges_with_eia", clear
drop eia rta pta fta cucmeu
gen mergeyear=1970 if year<1975
replace mergeyear=1975 if year>=1975 & year<1980
replace mergeyear=1980 if year>=1980 & year<1985
replace mergeyear=1985 if year>=1985 & year<1990
replace mergeyear=1990 if year>=1990 & year<1995
replace mergeyear=1995 if year>=1995 & year<2000
replace mergeyear=2000 if year>=2000 & year<2005
replace mergeyear=2005 if year>=2005 & year<2009
replace mergeyear=2009 if year==2009

merge m:1 ematnum ecode imatnum icode from to mergeyear type using ".\data\trade_costs_adjustment", nogenerate keepusing(rta_adjustment phaserta_adjustment fullset_adjustment) 
gen adj_cumtauhat_rta=rta_adjustment*cumtauhat
gen adj_cumtauhat_phasein=phaserta_adjustment*cumtauhat
gen adj_cumtauhat_fullset=fullset_adjustment*cumtauhat

egen yr=group(year)
egen id=group(ecode icode from to type)
tsset id yr
foreach var in rta phasein fullset {
	gen tauhat_`var'=adj_cumtauhat_`var'/L.adj_cumtauhat_`var'
	}
save ".\simulation_output\counterfactual_trade_costs", replace

**************************
**Outsheet Data for Matlab
**************************

forvalues yr=1971/2009 {
	**Final goods
	use ".\simulation_output\counterfactual_trade_costs", clear
	keep if type=="final" & year==`yr'
	sort ematnum imatnum to year
	keep ematnum imatnum to year tauhat tauhat_rta tauhat_fullset tauhat_phasein
	order ematnum imatnum to year tauhat tauhat_rta tauhat_fullset tauhat_phasein
	outsheet using ".\simulation_output\counterfactual_trade_costs_final_`yr'.dat", nonames replace
	**Inputs
	use ".\simulation_output\counterfactual_trade_costs", clear
	keep if type=="input" & year==`yr'
	sort ematnum imatnum from to
	keep ematnum imatnum from to year tauhat tauhat_rta tauhat_fullset tauhat_phasein
	order ematnum imatnum from to year tauhat tauhat_rta tauhat_fullset tauhat_phasein
	outsheet using ".\simulation_output\counterfactual_trade_costs_input_`yr'.dat", nonames replace
	}

*************************************	
**Write Coefficient Estimates to File
*************************************
#d ;
estout input_rta_1_1 input_rta_1_2 input_rta_2_1 input_rta_2_2 
	input_rtaphasein_1_1 input_rtaphasein_1_2 input_rtaphasein_2_1 input_rtaphasein_2_2 
	input_fullset_1_1 input_fullset_1_2 input_fullset_2_1 input_fullset_2_2
	final_rta_1 final_rta_2 final_rtaphasein_1 final_rtaphasein_2 final_fullset_1 final_fullset_2 
	using ".\figures_and_tables\rta_wedge_regressions.txt",	
	keep(rtadiff zerodiff onediff twodiff threemorediff ptadiff ftadiff cucmeudiff)
	stats(r2 N,fmt(%9.2f %9.0f) labels(R-squared)) 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f %9.3f))) 
	varwidth(16) modelwidth(12) delimiter(",") collabels(, none)
	starlevels(* 0.10 ** 0.05 *** 0.01) replace;

#d cr
erase ".\data\templist.dta"
erase ".\data\wedges_with_eia.dta"
erase ".\data\wedges_with_eia_panel.dta"
erase ".\data\trade_costs_adjustment.dta"
erase ".\simulation_output\counterfactual_trade_costs.dta"	
	
