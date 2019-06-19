**********************************************************
******* This file conducts the various robustness analyses, 
*******	tables and figures included in the appendices to the main paper.
*******
clear 
set more off 
est clear
****  if $toggle==1 outsheet and estout
global toggle = 1  
global date = "210726"

****  supply toggles:  $supplytoggle==2 (corrects trapezoids) $supplytoggle==1 (shifts supply out) $supplytoggle==0 (no correction) 
global supplytoggle=2

**** quantile toggles: $numquant = number of quantiles of rfs gains - cat gains
global numquant=4

*global preamble = "C:\AllStephen\My Dropbox\Jon n Chris"
*global preamble = "/Users/knittel/Dropbox/Landuse"
global preamble = "/Users/Jon/Dropbox/Landuse"

global datadirectory = "$preamble/5 - Probits/Data"
global codedirectory = "$preamble/5 - Probits/Code"
global tabledirectory = "$preamble/Write-up/Tables"
global figuredirectory = "$preamble/Write-up/Figures"
global supplydirectory = "$preamble/1 - Supply Curves"

**global contribution_ver = "$datadirectory/LegislatorDollars_052609_072609_clean.dta"
**global ver = "3month"
global contribution_ver = "$datadirectory/LegislatorDollars_010109_123110_clean.dta"
global ver = "2year"

*** Appendix figure 1 
* Created in "create_supply_curves.do" file in 1 - Supply Curves directory

*** Appendix figure 2
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
reg lpscs_cat_percap lpscs_rfs_percap
predict lpscs_cat_predict
sort lpscs_cat_predict
#delimit;
twoway (scatter lpscs_cat_percap lpscs_rfs_percap, msymbol(oh))
(scatter lpscs_cat_predict lpscs_rfs_percap, connect(|) msymbol(i) lc(black))
, 
xlabel(, grid format(%9.0f)angle(horizontal))
scheme(s1mono)
xtitle("Net Gains from RFS (in logs)")
ytitle("Net Gains from CAT (in logs)")
legend(off);
#delimit cr
if $toggle==1{
graph export "$figuredirectory/scatter_rfs_cat_$date$supplytoggle.pdf", replace
}

*** Appendix figure 3
* Created in "create_endog_corn_supply.do" file in 1 - Supply Curves directory

*** Appendix figure 4
use "$datadirectory/cd_pscs&votes_CO2Price_1305162.dta", clear
keep st_abb district pscs_rfs_percap
rename pscs_rfs_percap pscs_rfsWM_percap
sort st_abb district
merge 1:1 st_abb district using "$datadirectory/cd_pscs&votes_$date$supplytoggle", nogen
#delimit;
twoway (scatter pscs_rfsWM_percap pscs_rfs_percap, msymbol(oh)), 
xlabel(, grid format(%9.0f)angle(horizontal))
scheme(s1mono)
xtitle("Net Gains from RFS")
ytitle("Net Gains from RFS + $25 CO2 Price")
legend(off);
#delimit cr
if $toggle==1{
graph export "$figuredirectory/ScatterRFS&RFSWM.pdf", replace
}

*** Appendix figure 5
* Make plots of margins for models with higher order terms of relative gains
* With quadratic term
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
qui: probit vote_d_cat i.dem_cat c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio
qui: margins, dydx(l_pscs_catrfs_ratio) at(l_pscs_catrfs_ratio=(-1.9(.2)2.7))
matrix b = r(b)'
matrix at = r(at)
matrix v = r(V)
matrix se=vecdiag(cholesky(diag(vecdiag(v))))'
matrix at=at[1...,"l_pscs_catrfs_ratio"]
matrix plotdata = at,b,se
svmat plotdata, names(plotdata)
generate ul = plotdata2 + 1.96*plotdata3
generate ll = plotdata2 - 1.96*plotdata3
#delimit;
twoway(line plotdata2 plotdata1, scheme(s1mono) 
ytitle("Marginal Effect of ln(CAT Gains) - ln(RFS Grains)") title("Model 4 Quadratic")
xtitle("ln(CAT Gains) - ln(RFS Grains)") yline(0, lwidth(vvthin)) legend(row(1) 
label(1 "Marginal Effect") label(2 "95% upper CI") label(3 "95% lower CI") ))
(line ul plotdata1, lpattern(dash))
(line ll plotdata1, lpattern(dash));
#delimit cr
graph export "$figuredirectory/Model4CATRFSRatio_quad_$date$supplytoggle.pdf", replace

*** Appendix figure 6
* Make plots of margins for models with higher order terms of relative gains
** With cubic term
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
qui: probit vote_d_cat i.dem_cat c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio
margins, dydx(l_pscs_catrfs_ratio) at(l_pscs_catrfs_ratio=(-1.9(.2)2.7))
matrix b = r(b)'
matrix at = r(at)
matrix v = r(V)
matrix se=vecdiag(cholesky(diag(vecdiag(v))))'
matrix at=at[1...,"l_pscs_catrfs_ratio"]
matrix plotdata = at,b,se
svmat plotdata, names(plotdata)
generate ul = plotdata2 + 1.96*plotdata3
generate ll = plotdata2 - 1.96*plotdata3
#delimit;
twoway(line plotdata2 plotdata1, scheme(s1mono) 
ytitle("Marginal Effect of ln(CAT Gains) - ln(RFS Grains)") title("Model 4 Cubic")
xtitle("ln(CAT Gains) - ln(RFS Grains)") yline(0, lwidth(vvthin)) legend(row(1) 
label(1 "Marginal Effect") label(2 "95% upper CI") label(3 "95% lower CI") ))
(line ul plotdata1, lpattern(dash))
(line ll plotdata1, lpattern(dash));
#delimit cr
graph export "$figuredirectory/Model4CATRFSRatio_cubic_$date$supplytoggle.pdf", replace

*** Appendix figure 7
* Distribution on county-level gains and losses
use "$datadirectory/county_pscs_percap_$date$supplytoggle.dta", clear
foreach p in rfs lcfs cat subs {
qui: kdensity pscs_`p'_percap , n(2000) bwidth(25) generate(`p'_x `p'_d)
}
#delimit;
twoway (line rfs_d rfs_x if rfs_x < 500, scheme(s2mono) xtitle("County-Level Gains ($/cap.)") 
legend(row(1) label(1 "RFS") label(2 "LCFS") label(3 "CAT") label(4 "SUBS") ) 
ytitle("Density") title("Distributions of County-Level Gains") xlabel(-100[100]500)
graphregion(color(white)))
(line lcfs_d lcfs_x if lcfs_x < 500) 
(line cat_d cat_x if cat_x < 500) 
(line subs_d subs_x if subs_x < 500);
graph export "$figuredirectory/dist_cnty_gains_bypol_$date$supplytoggle.pdf", replace; 
#delimit cr

*** Appendix figure 8
* Zoom in on right tail of county-level gains and losses
#delimit;
twoway (line rfs_d rfs_x if rfs_x > 100 & rfs_x < 1000, scheme(s2mono) xtitle("County-Level Gains ($/cap.)") 
legend(row(1) label(1 "RFS") label(2 "LCFS") label(3 "CAT") label(4 "SUBS") ) 
ytitle("Density") title("Distributions of County-Level Gains") xlabel(100[100]1000)
graphregion(color(white)))
(line lcfs_d lcfs_x if lcfs_x > 100 & lcfs_x < 1000) 
(line cat_d cat_x if cat_x > 100 & cat_x < 1000) 
(line subs_d subs_x if subs_x > 100 & subs_x < 1000);
graph export "$figuredirectory/dist_cnty_gains_bypol_ZOOM_$date$supplytoggle.pdf", replace; 
#delimit cr

*** Appendix tables 1-11
* Created in  \ Write-up \Tables Excel file "Appendix Tables.xlsx"

*** Appendix table 7 additional code
use "$datadirectory/county_pscs_percap_325_$date$supplytoggle.dta", clear
*** Table 3  (county level)
tabstat pscs_cat_percap pscs_lcfs_percap pscs_rfs_percap pscs_subs_percap, stat(mean min p25 med p75 p90 p95 max n)
tabstat pscs_cat_percap pscs_lcfs_percap pscs_rfs_percap pscs_subs_percap [aw=population ], stat(mean  n)
#delimit;	

	foreach k in subs lcfs rfs cat	{;
	gen count_`k'_percap = pscs_`k'_percap;
	replace count_`k'_percap=. if count_`k'_percap<=0;
	};

	collapse (mean) pscs_cat_percap pscs_lcfs_percap pscs_rfs_percap pscs_subs_percap 
	(count) count_cat_percap count_lcfs_percap count_rfs_percap count_subs_percap 
	(min) min_cat_percap=pscs_cat_percap min_lcfs_percap=pscs_lcfs_percap min_rfs_percap=pscs_rfs_percap min_subs_percap=pscs_subs_percap 
	(p25) p25_cat_percap=pscs_cat_percap p25_lcfs_percap=pscs_lcfs_percap p25_rfs_percap=pscs_rfs_percap p25_subs_percap=pscs_subs_percap 
	(p50)p50_cat_percap=pscs_cat_percap p50_lcfs_percap=pscs_lcfs_percap p50_rfs_percap=pscs_rfs_percap p50_subs_percap=pscs_subs_percap 
	(p75)p75_cat_percap=pscs_cat_percap p75_lcfs_percap=pscs_lcfs_percap p75_rfs_percap=pscs_rfs_percap p75_subs_percap=pscs_subs_percap
	(p90)p90_cat_percap=pscs_cat_percap p90_lcfs_percap=pscs_lcfs_percap p90_rfs_percap=pscs_rfs_percap p90_subs_percap=pscs_subs_percap  
	(p95)p95_cat_percap=pscs_cat_percap p95_lcfs_percap=pscs_lcfs_percap p95_rfs_percap=pscs_rfs_percap p95_subs_percap=pscs_subs_percap  
	(max)max_cat_percap=pscs_cat_percap max_lcfs_percap=pscs_lcfs_percap max_refs=pscs_rfs_percap max_subs_percap=pscs_subs_percap ;
#delimit cr 
if $toggle==1{
	outsheet using  "$tabledirectory/crosstabs_county_325_$date$supplytoggle.csv", delimiter(,) replace
	}

*** Appendix table 12
* Make a loop to prepare data for scenarios 1-11 ***
foreach S in highP lowP highiLUC WastePass OldCorn LessElastic MoreElastic CornElast GasElast1 GasElast2{

use "$datadirectory/county_csps_`S'_$supplytoggle.dta", clear

******* create county_pscs_percap
rename dcsps_RFS pscs_rfs
rename dcsps_CT pscs_cat
rename dcsps_LCFS pscs_lcfs
rename dcsps_SUBS pscs_subs

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}

if $toggle==1{
save "$datadirectory/county_pscs_percap_`S'_$date$supplytoggle.dta", replace
}

******* begin create cd_pscs_xxx
*use "$datadirectory/county_pscs_percap_$date$supplytoggle.dta", clear
count
sort state county
merge 1:1 state county using "$datadirectory/CountyCorn_2007_clean.dta"
drop if _merge==2
rename value corn2007
	
drop _merge
sort state county
merge 1:1 state county using "$datadirectory/CountyCorn_2002_clean.dta"
drop if _merge==2
rename value corn2002	
drop _merge

merge m:1 state using "$datadirectory/st_abb_fips.dta", nogen
merge 1:1 st_abb county using  "$datadirectory/joined_county_em_voteview_trun.dta"
drop if _merge==2
drop _merge

preserve
****** Create state level dataset
collapse (sum) pscs_subs pscs_lcfs pscs_rfs pscs_cat population corn* vulcan_milton (mean) plant_rate, by (state st_abb)
drop if st_abb=="DC"

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}
if $toggle==1{
save "$datadirectory/state_pscs_percap_`S'_$date$supplytoggle.dta", replace
}
restore
**************

merge 1:m state county using "$datadirectory/county_cd_cw.dta"
drop if _merge==2
drop _merge
rename cd110 district

keep state county population pscs_subs  pscs_lcfs pscs_cat pscs_rfs district county_count weight  corn* commercial industrial residential electricityprod onroad cement aircraft unknown nonroad co2tons 	vulcan_milton  totalmwh plgenacl plgenaol plgenags plgenanc plgenahy othermwh plant_rate cnty_rate vulcan_tonspercap eia_tonspercap eia_milton st_abb


foreach k in subs lcfs rfs cat	{
	gen maxpscs_`k'_percap = pscs_`k'/population
	}

xtile rfsquart = maxpscs_rfs_percap, nq(4)
xtile catquart = maxpscs_cat_percap, nq(4)
gen maxrfs_quart= rfsquart==4
gen maxcat_quart= catquart==4

*********** Collapse county data to district data
collapse (sum) pscs_subs pscs_lcfs pscs_rfs pscs_cat population corn* vulcan_milton (max) max* (mean) plant_rate [iw=weight], by(state st_abb district)


foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}
	
sum plant_rate, detail
gen lplant_rate = ln(plant_rate - r(min) + 1)

if $toggle==1{
save "$datadirectory/cd_pscs_percap_`S'_$date$supplytoggle.dta", replace
}

merge 1:1 st_abb district using "$datadirectory/vote on WM.dta"
drop if _merg==1
drop _merge

rename state statefip
drop if state==.
sort statefip district
merge 1:1 statefip district using "$datadirectory/voteview_forck_temp.dta"

drop _merge 
drop if st_abb=="."
drop if name_cat==""
merge 1:1 st_abb district using "$contribution_ver"

drop l_amt_supp l_amt_split l_amt_opp
gen l_amt_supp = ln(amt_supp )
gen l_amt_opp = ln(amt_opp )
gen l_amt_split = ln(amt_split )
replace  l_amt_supp = 0 if amt_supp <= 0
replace  l_amt_opp = 0 if amt_opp <= 0
replace  l_amt_split = 0 if amt_spli <= 0

replace amt_opp=amt_opp/1000
replace amt_supp=amt_supp/1000
replace amt_split=amt_split/1000

gen vote_d_cat = 1
replace vote_d_cat = 1 if vote_cat=="Aye"
replace vote_d_cat = 0 if vote_cat=="Nay"

replace vote_d_cat = . if vote_cat=="No Vote"
drop if district ==.

gen dem_cat = party_cat=="D"
replace dem_cat = 1 if name_cat=="Tauscher, Ellen"

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_DEM = pscs_`k'_percap*dem_cat
	}

foreach k in subs lcfs rfs cat	{
	egen min_pscs_`k'_percap = min(pscs_`k'_percap)
	}

**** Shift PSCS by $100/per cap for all policies, eq. to $100/cap carbon benefit
foreach k in subs lcfs rfs cat	{
	gen lpscs_`k'_percap = ln(pscs_`k'_percap + 100)
	}

gen rfs_larger = pscs_rfs_percap>pscs_cat_percap
gen cat_larger = pscs_rfs_percap<pscs_cat_percap
gen subs_larger = pscs_subs_percap>pscs_cat_percap

**** Difference in CAT/RFS gains in $1000's
gen pscs_rfscat_diff = (pscs_rfs_percap - pscs_cat_percap)/1000
gen pscs_catrfs_diff = (pscs_cat_percap - pscs_rfs_percap)/1000

**** Difference in CAT and RFS gains in logs
gen l_pscs_catrfs_ratio = ln((pscs_cat_percap+100)/(pscs_rfs_percap+100))

xtile pscs_rfscat_diff_quant = pscs_rfscat_diff, nq($numquant)
forvalues i = 1(1)$numquant {
        gen rfscat_diff_quant_`i' = pscs_rfscat_diff_quant==`i'         
	}

xtile pscs_rfs_quart = pscs_rfs_percap, nq(4)
xtile pscs_subs_quart = pscs_subs_percap, nq(4)
xtile pscs_cat_quart = pscs_cat_percap, nq(4)
xtile pscs_rfscat_quart = pscs_rfscat_diff, nq(4)

gen pscs_rfs_quart_1 = pscs_rfs_quart==1
gen pscs_rfs_quart_2 = pscs_rfs_quart==2
gen pscs_rfs_quart_3 = pscs_rfs_quart==3
gen pscs_rfs_quart_4 = pscs_rfs_quart==4

gen pscs_cat_quart_1 = pscs_cat_quart==1
gen pscs_cat_quart_2 = pscs_cat_quart==2
gen pscs_cat_quart_3 = pscs_cat_quart==3
gen pscs_cat_quart_4 = pscs_cat_quart==4

gen pscs_subs_quart_1 = pscs_subs_quart==1
gen pscs_subs_quart_2 = pscs_subs_quart==2
gen pscs_subs_quart_3 = pscs_subs_quart==3
gen pscs_subs_quart_4 = pscs_subs_quart==4

gen pscs_rfscat_quart_1 = pscs_rfscat_quart==1
gen pscs_rfscat_quart_2 = pscs_rfscat_quart==2
gen pscs_rfscat_quart_3 = pscs_rfscat_quart==3
gen pscs_rfscat_quart_4 = pscs_rfscat_quart==4

gen coal_top10=0
replace coal_top=1 if st_abb=="CO"|st_abb=="ND"|st_abb=="VA"|st_abb=="IL"|st_abb=="MT"|st_abb=="TX"|st_abb=="PA"|st_abb=="KY"|st_abb=="WV"|st_abb=="WY"
gen coal_top5=0
replace coal_top5=1 if st_abb=="TX"|st_abb=="PA"|st_abb=="KY"|st_abb=="WV"|st_abb=="WY"

gen l_vulcan = ln(vulcan_milton*1000/population )
gen l_corn_2007 = ln(corn2007+1)

if $toggle==1{
save "$datadirectory/cd_pscs&votes_`S'_$date$supplytoggle.dta", replace
}
drop if st_abb=="DC"

}

*** Loop over different scenarios (Gas Elast with ref cap allocation are Separate Below)
foreach S in highP lowP highiLUC WastePass OldCorn LessElastic MoreElastic CornElast GasElast1 GasElast2{

use "$datadirectory/cd_pscs&votes_`S'_$date$supplytoggle", clear

* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)

probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.coal_top10
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_robust1_`S'

}

*** Make Table
#delimit;
cd "$tabledirectory";

estout model_robust1_highP model_robust1_lowP model_robust1_highiLUC model_robust1_WastePass model_robust1_OldCorn model_robust1_LessElastic model_robust1_MoreElastic model_robust1_CornElast model_robust1_GasElast1 model_robust1_GasElast2 using "WMvotes_scenarios_$date.txt", 
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels( "highP" "lowP" "highiLUC" "WastePass" "OldCorn" "LessElastic" "MoreElastic" "CornElast" "GasElast1" "GasElast2") ;

#delimit cr

*** Appendix table 13
* Cleaner test assuming Peterson Dems vote nay
use "$datadirectory/cd_pscs&votes_$date$supplytoggle_PeteDems", clear
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
probit  vote_d_cat dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart1
****** Table 5 Model 2
probit  vote_d_cat dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart2
****** Table 5 Model 3
probit  vote_d_cat dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.state_gp
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart3
*** Make Table
#delimit;
cd "$tabledirectory";
estout model_quart* using "WMvotes_Robust_PeteDems_$date.txt", 
order( 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 1" "model 2" "model 3"  ) ;
#delimit cr

*** Appendix table 14
* Robustness checks for endogeneity of political affiliation, drop dem dummy
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
***** Table 5 Model 1
probit  vote_d_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 
estpost margins, dydx(*)
est store model_quart1
****** Table 5 Model 2
probit  vote_d_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart2
****** Table 5 Model 3
probit  vote_d_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.state_gp
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart3
*** Make Table
#delimit;
cd "$tabledirectory";
estout model_quart* using "WMvotes_Robust_DemDummy_$date.txt", 
order( 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 1" "model 2" "model 3"  ) ;
#delimit cr

*** Appendix table 15
* Regress Dem_cat dummy on gains variables
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
****** Table 5 Model 1
probit  dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4
estpost margins, dydx(*)
est store model_quart1
****** Table 5 Model 2
probit  dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4
estpost margins, dydx(*)
est store model_quart2
****** Table 5 Model 3
probit  dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.state_gp
estpost margins, dydx(*)
est store model_quart3
*** Make Table
#delimit;
cd "$tabledirectory";
estout model_quart* using "Party_on_gains_$date.txt", 
order( 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 1" "model 2" "model 3"  ) ;
#delimit cr

*** Appendix table 16
* Created in  \ Write-up \Tables Excel file "Appendix Tables.xlsx"

*** Appendix table 17
* Repeat analysis for constant elasticity gas assuming change in gas PS is allocated based on refining capacity
* Make a loop to prepare data for the scenarios ***
foreach S in GasElast1REFCAP GasElast2REFCAP{

use "$datadirectory/county_csps_`S'_$supplytoggle.dta", clear

******* create county_pscs_percap
rename dcsps_RFS pscs_rfs
rename dcsps_CT pscs_cat
rename dcsps_LCFS pscs_lcfs
rename dcsps_SUBS pscs_subs

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}

if $toggle==1{
save "$datadirectory/county_pscs_percap_`S'_$date$supplytoggle.dta", replace
}

******* begin create cd_pscs_xxx
*use "$datadirectory/county_pscs_percap_$date$supplytoggle.dta", clear
count
sort state county
merge 1:1 state county using "$datadirectory/CountyCorn_2007_clean.dta"
drop if _merge==2
rename value corn2007
	
drop _merge
sort state county
merge 1:1 state county using "$datadirectory/CountyCorn_2002_clean.dta"
drop if _merge==2
rename value corn2002	
drop _merge

merge m:1 state using "$datadirectory/st_abb_fips.dta", nogen
merge 1:1 st_abb county using  "$datadirectory/joined_county_em_voteview_trun.dta"
drop if _merge==2
drop _merge

preserve
****** Create state level dataset
collapse (sum) pscs_subs pscs_lcfs pscs_rfs pscs_cat population corn* vulcan_milton (mean) plant_rate, by (state st_abb)
drop if st_abb=="DC"

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}
if $toggle==1{
save "$datadirectory/state_pscs_percap_`S'_$date$supplytoggle.dta", replace
}
restore
**************

merge 1:m state county using "$datadirectory/county_cd_cw.dta"
drop if _merge==2
drop _merge
rename cd110 district

keep state county population pscs_subs  pscs_lcfs pscs_cat pscs_rfs district county_count weight  corn* commercial industrial residential electricityprod onroad cement aircraft unknown nonroad co2tons 	vulcan_milton  totalmwh plgenacl plgenaol plgenags plgenanc plgenahy othermwh plant_rate cnty_rate vulcan_tonspercap eia_tonspercap eia_milton st_abb


foreach k in subs lcfs rfs cat	{
	gen maxpscs_`k'_percap = pscs_`k'/population
	}

xtile rfsquart = maxpscs_rfs_percap, nq(4)
xtile catquart = maxpscs_cat_percap, nq(4)
gen maxrfs_quart= rfsquart==4
gen maxcat_quart= catquart==4

*********** Collapse county data to district data
collapse (sum) pscs_subs pscs_lcfs pscs_rfs pscs_cat population corn* vulcan_milton (max) max* (mean) plant_rate [iw=weight], by(state st_abb district)


foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}
	
sum plant_rate, detail
gen lplant_rate = ln(plant_rate - r(min) + 1)
	
if $toggle==1{
save "$datadirectory/cd_pscs_percap_`S'_$date$supplytoggle.dta", replace
}

*use "$datadirectory/cd_pscs_percap_$date$supplytoggle.dta", clear
	
merge 1:1 st_abb district using "$datadirectory/vote on WM.dta"
**** we drop two "districts" one is DC the other is CA 32
drop if _merg==1
drop _merge

rename state statefip
drop if state==.
sort statefip district
merge 1:1 statefip district using "$datadirectory/voteview_forck_temp.dta"

drop _merge 
drop if st_abb=="."
drop if name_cat==""
merge 1:1 st_abb district using "$contribution_ver"

drop l_amt_supp l_amt_split l_amt_opp
gen l_amt_supp = ln(amt_supp )
gen l_amt_opp = ln(amt_opp )
gen l_amt_split = ln(amt_split )
replace  l_amt_supp = 0 if amt_supp <= 0
replace  l_amt_opp = 0 if amt_opp <= 0
replace  l_amt_split = 0 if amt_spli <= 0

replace amt_opp=amt_opp/1000
replace amt_supp=amt_supp/1000
replace amt_split=amt_split/1000

gen vote_d_cat = 1
replace vote_d_cat = 1 if vote_cat=="Aye"
replace vote_d_cat = 0 if vote_cat=="Nay"

replace vote_d_cat = . if vote_cat=="No Vote"
drop if district ==.

gen dem_cat = party_cat=="D"
replace dem_cat = 1 if name_cat=="Tauscher, Ellen"

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_DEM = pscs_`k'_percap*dem_cat
	}


foreach k in subs lcfs rfs cat	{
	egen min_pscs_`k'_percap = min(pscs_`k'_percap)
	}

**** Shift PSCS by $100/per cap for all policies, eq. to $100/cap carbon benefit
foreach k in subs lcfs rfs cat	{
	gen lpscs_`k'_percap = ln(pscs_`k'_percap + 100)
	}

gen rfs_larger = pscs_rfs_percap>pscs_cat_percap
gen cat_larger = pscs_rfs_percap<pscs_cat_percap
gen subs_larger = pscs_subs_percap>pscs_cat_percap

**** Difference in CAT/RFS gains in $1000's
gen pscs_rfscat_diff = (pscs_rfs_percap - pscs_cat_percap)/1000
gen pscs_catrfs_diff = (pscs_cat_percap - pscs_rfs_percap)/1000

**** Difference in CAT and RFS gains in logs
gen l_pscs_catrfs_ratio = ln((pscs_cat_percap+100)/(pscs_rfs_percap+100))

xtile pscs_rfscat_diff_quant = pscs_rfscat_diff, nq($numquant)
forvalues i = 1(1)$numquant {
        gen rfscat_diff_quant_`i' = pscs_rfscat_diff_quant==`i'         
	}

xtile pscs_rfs_quart = pscs_rfs_percap, nq(4)
xtile pscs_subs_quart = pscs_subs_percap, nq(4)
xtile pscs_cat_quart = pscs_cat_percap, nq(4)
xtile pscs_rfscat_quart = pscs_rfscat_diff, nq(4)

gen pscs_rfs_quart_1 = pscs_rfs_quart==1
gen pscs_rfs_quart_2 = pscs_rfs_quart==2
gen pscs_rfs_quart_3 = pscs_rfs_quart==3
gen pscs_rfs_quart_4 = pscs_rfs_quart==4

gen pscs_cat_quart_1 = pscs_cat_quart==1
gen pscs_cat_quart_2 = pscs_cat_quart==2
gen pscs_cat_quart_3 = pscs_cat_quart==3
gen pscs_cat_quart_4 = pscs_cat_quart==4

gen pscs_subs_quart_1 = pscs_subs_quart==1
gen pscs_subs_quart_2 = pscs_subs_quart==2
gen pscs_subs_quart_3 = pscs_subs_quart==3
gen pscs_subs_quart_4 = pscs_subs_quart==4

gen pscs_rfscat_quart_1 = pscs_rfscat_quart==1
gen pscs_rfscat_quart_2 = pscs_rfscat_quart==2
gen pscs_rfscat_quart_3 = pscs_rfscat_quart==3
gen pscs_rfscat_quart_4 = pscs_rfscat_quart==4

gen coal_top10=0
replace coal_top=1 if st_abb=="CO"|st_abb=="ND"|st_abb=="VA"|st_abb=="IL"|st_abb=="MT"|st_abb=="TX"|st_abb=="PA"|st_abb=="KY"|st_abb=="WV"|st_abb=="WY"
gen coal_top5=0
replace coal_top5=1 if st_abb=="TX"|st_abb=="PA"|st_abb=="KY"|st_abb=="WV"|st_abb=="WY"

gen l_vulcan = ln(vulcan_milton*1000/population )
gen l_corn_2007 = ln(corn2007+1)

if $toggle==1{
save "$datadirectory/cd_pscs&votes_`S'_$date$supplytoggle.dta", replace
}
drop if st_abb=="DC"

}

* Clean up gasoline PS data
use "$datadirectory/Refin_cap_CD.dta", clear
* Make total capacity and weights
rename capacity_weight capacity
egen tot_cap = sum(capacity)
gen capacity_wgt = capacity/tot_cap
rename cd110 district
rename state statefip
keep statefip district capacity_wgt
* Save as new file
save "$datadirectory/RefinCapWeightsCD.dta", replace

*** Loop over different scenarios
foreach S in GasElast1 GasElast2{

use "$datadirectory/cd_pscs&votes_`S'REFCAP_130516$supplytoggle", clear
* Add in Gas PS
append using "$preamble\3 - Dist of Gains\dPSGas_`S'.dta"
foreach P in RFS LCFS CT SUBS {
egen temp_`P' = max(delPSgas`P')
replace delPSgas`P' = temp_`P'
}
drop temp_*
drop if state == .
* Merge in refinery cap weights
sort statefip district
merge 1:1 statefip district using "$datadirectory/RefinCapWeightsCD.dta", nogen
foreach P in RFS LCFS CT SUBS {
replace delPSgas`P' = delPSgas`P'*capacity_wgt/10^9
} 

* Indicator for large refinery PS loses
gen D_bigloss = delPSgasRFS <= -.5

#delimit ;
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 
i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 
delPSgasRFS
i.coal_top10;
#delimit cr 
estpost margins, dydx(*)
est store model_`S'

#delimit ;
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 
i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 
i.D_bigloss
i.coal_top10;
#delimit cr
estpost margins, dydx(*)
est store model_`S'_dummy

*** Make Table
#delimit;
cd "$tabledirectory";
estout model_`S' model_`S'_dummy using "WMvotes_`S'_PSGasRefCap_$date.txt", 
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("`S'_linear" "`S'_dummy "  ) ;
#delimit cr
}

*** Appendix table 18
* Ethanol supply curve scenarios
* Make a loop to prepare data for all the scenarios ***
foreach S in EtOH1 EtOH2 EtOH3 EtOH4 EtOH5{

use "$datadirectory/county_csps_`S'_$supplytoggle.dta", clear

******* create county_pscs_percap
rename dcsps_RFS pscs_rfs
rename dcsps_CT pscs_cat
rename dcsps_LCFS pscs_lcfs
rename dcsps_SUBS pscs_subs

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}

if $toggle==1{
save "$datadirectory/county_pscs_percap_`S'_$date$supplytoggle.dta", replace
}

******* begin create cd_pscs_xxx
count
sort state county
merge 1:1 state county using "$datadirectory/CountyCorn_2007_clean.dta"
drop if _merge==2
rename value corn2007
	
drop _merge
sort state county
merge 1:1 state county using "$datadirectory/CountyCorn_2002_clean.dta"
drop if _merge==2
rename value corn2002	
drop _merge

merge m:1 state using "$datadirectory/st_abb_fips.dta", nogen
merge 1:1 st_abb county using  "$datadirectory/joined_county_em_voteview_trun.dta"
drop if _merge==2
drop _merge

preserve
****** Create state level dataset
collapse (sum) pscs_subs pscs_lcfs pscs_rfs pscs_cat population corn* vulcan_milton (mean) plant_rate, by (state st_abb)
drop if st_abb=="DC"

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}
if $toggle==1{
save "$datadirectory/state_pscs_percap_`S'_$date$supplytoggle.dta", replace
}
restore
**************

merge 1:m state county using "$datadirectory/county_cd_cw.dta"
drop if _merge==2
drop _merge
rename cd110 district

keep state county population pscs_subs  pscs_lcfs pscs_cat pscs_rfs district county_count weight  corn* commercial industrial residential electricityprod onroad cement aircraft unknown nonroad co2tons 	vulcan_milton  totalmwh plgenacl plgenaol plgenags plgenanc plgenahy othermwh plant_rate cnty_rate vulcan_tonspercap eia_tonspercap eia_milton st_abb


foreach k in subs lcfs rfs cat	{
	gen maxpscs_`k'_percap = pscs_`k'/population
	}

xtile rfsquart = maxpscs_rfs_percap, nq(4)
xtile catquart = maxpscs_cat_percap, nq(4)
gen maxrfs_quart= rfsquart==4
gen maxcat_quart= catquart==4

*********** Collapse county data to district data
collapse (sum) pscs_subs pscs_lcfs pscs_rfs pscs_cat population corn* vulcan_milton (max) max* (mean) plant_rate [iw=weight], by(state st_abb district)


foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_percap = pscs_`k'/population
	}
	
sum plant_rate, detail
gen lplant_rate = ln(plant_rate - r(min) + 1)

if $toggle==1{
save "$datadirectory/cd_pscs_percap_`S'_$date$supplytoggle.dta", replace
}

*use "$datadirectory/cd_pscs_percap_$date$supplytoggle.dta", clear
	
merge 1:1 st_abb district using "$datadirectory/vote on WM.dta"
drop if _merg==1
drop _merge

rename state statefip
drop if state==.
sort statefip district
merge 1:1 statefip district using "$datadirectory/voteview_forck_temp.dta"

drop _merge 
drop if st_abb=="."
drop if name_cat==""
merge 1:1 st_abb district using "$contribution_ver"

drop l_amt_supp l_amt_split l_amt_opp
gen l_amt_supp = ln(amt_supp )
gen l_amt_opp = ln(amt_opp )
gen l_amt_split = ln(amt_split )
replace  l_amt_supp = 0 if amt_supp <= 0
replace  l_amt_opp = 0 if amt_opp <= 0
replace  l_amt_split = 0 if amt_spli <= 0

replace amt_opp=amt_opp/1000
replace amt_supp=amt_supp/1000
replace amt_split=amt_split/1000

gen vote_d_cat = 1
replace vote_d_cat = 1 if vote_cat=="Aye"
replace vote_d_cat = 0 if vote_cat=="Nay"

replace vote_d_cat = . if vote_cat=="No Vote"
drop if district ==.

gen dem_cat = party_cat=="D"
replace dem_cat = 1 if name_cat=="Tauscher, Ellen"

foreach k in subs lcfs rfs cat	{
	gen pscs_`k'_DEM = pscs_`k'_percap*dem_cat
	}


foreach k in subs lcfs rfs cat	{
	egen min_pscs_`k'_percap = min(pscs_`k'_percap)
	}

**** Shift PSCS by $100/per cap for all policies, eq. to $100/cap carbon benefit
foreach k in subs lcfs rfs cat	{
	gen lpscs_`k'_percap = ln(pscs_`k'_percap + 100)
	}

gen rfs_larger = pscs_rfs_percap>pscs_cat_percap
gen cat_larger = pscs_rfs_percap<pscs_cat_percap
gen subs_larger = pscs_subs_percap>pscs_cat_percap

**** Difference in CAT/RFS gains in $1000's
gen pscs_rfscat_diff = (pscs_rfs_percap - pscs_cat_percap)/1000
gen pscs_catrfs_diff = (pscs_cat_percap - pscs_rfs_percap)/1000

**** Difference in CAT and RFS gains in logs
gen l_pscs_catrfs_ratio = ln((pscs_cat_percap+100)/(pscs_rfs_percap+100))

xtile pscs_rfscat_diff_quant = pscs_rfscat_diff, nq($numquant)
forvalues i = 1(1)$numquant {
        gen rfscat_diff_quant_`i' = pscs_rfscat_diff_quant==`i'         
	}

xtile pscs_rfs_quart = pscs_rfs_percap, nq(4)
xtile pscs_subs_quart = pscs_subs_percap, nq(4)
xtile pscs_cat_quart = pscs_cat_percap, nq(4)
xtile pscs_rfscat_quart = pscs_rfscat_diff, nq(4)

gen pscs_rfs_quart_1 = pscs_rfs_quart==1
gen pscs_rfs_quart_2 = pscs_rfs_quart==2
gen pscs_rfs_quart_3 = pscs_rfs_quart==3
gen pscs_rfs_quart_4 = pscs_rfs_quart==4

gen pscs_cat_quart_1 = pscs_cat_quart==1
gen pscs_cat_quart_2 = pscs_cat_quart==2
gen pscs_cat_quart_3 = pscs_cat_quart==3
gen pscs_cat_quart_4 = pscs_cat_quart==4

gen pscs_subs_quart_1 = pscs_subs_quart==1
gen pscs_subs_quart_2 = pscs_subs_quart==2
gen pscs_subs_quart_3 = pscs_subs_quart==3
gen pscs_subs_quart_4 = pscs_subs_quart==4

gen pscs_rfscat_quart_1 = pscs_rfscat_quart==1
gen pscs_rfscat_quart_2 = pscs_rfscat_quart==2
gen pscs_rfscat_quart_3 = pscs_rfscat_quart==3
gen pscs_rfscat_quart_4 = pscs_rfscat_quart==4

gen coal_top10=0
replace coal_top=1 if st_abb=="CO"|st_abb=="ND"|st_abb=="VA"|st_abb=="IL"|st_abb=="MT"|st_abb=="TX"|st_abb=="PA"|st_abb=="KY"|st_abb=="WV"|st_abb=="WY"
gen coal_top5=0
replace coal_top5=1 if st_abb=="TX"|st_abb=="PA"|st_abb=="KY"|st_abb=="WV"|st_abb=="WY"

gen l_vulcan = ln(vulcan_milton*1000/population )
gen l_corn_2007 = ln(corn2007+1)

if $toggle==1{
save "$datadirectory/cd_pscs&votes_`S'_$date$supplytoggle.dta", replace
}
drop if st_abb=="DC"

}

**********************************************************
*******  Now reproduce the probit results used in the Senate Simulation for All Scenarios

*** Loop over different scenarios
foreach S in EtOH1 EtOH2 EtOH3 EtOH4 EtOH5{

use "$datadirectory/cd_pscs&votes_`S'_$date$supplytoggle", clear

* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)

probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.coal_top10
estpost margins, dydx(*)
est store model_rob_`S'

}

*** Make Table
#delimit;
cd "$tabledirectory";
estout model_rob_EtOH1 model_rob_EtOH2 model_rob_EtOH3 model_rob_EtOH4 model_rob_EtOH5 using "WMvotes_EtOH_scenarios_$date.txt", 
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("Cell+20%" "Cell-20%" "Corn+20%" "Corn-20%" "Cell-20Corn+20") ;
#delimit cr

*** Do regression correlating corn production predicted by our model with actual corn
* Corn price assumed to be $4.43
* Input supply data
use "/Users/Jon/Dropbox/LandUse/3 - Dist of Gains/county_supply_new_2.dta", clear
* Keep corn
keep if ethtype == "corn"
keep if run == "run21"
keep source_id ethtype price quant_tons
* Create county id's
gen str_fips = substr(source_id,2,7)
gen state=real(substr(source_id,2,2)) 
gen county=real(substr(source_id,4,3))
sort state county 
merge 1:1 state county using "$datadirectory/CountyCorn_2007_clean.dta", nogen
rename value CornBu2007
gen quant_bu = quant_tons*2000/56
reg CornBu2007 quant_bu

*** Appendix table 19
* Created in  \ Write-up \Tables Excel file "Appendix Tables.xlsx"

*** Appendix table 20
* Checks for "reduced form" relationships between ag suitability and voting
* Input hec and corn yield data
use "$supplydirectory/CornYields_clean.dta", clear
sort fips
merge m:1 fips using "$supplydirectory/HECYields_clean.dta", nogen
replace corn_yield = 0 if corn_yield == .
replace hec_yield = 0 if hec_yield == .
* Convert fips to state county
gen state=real(substr(fips,2,2))
gen county=real(substr(fips,4,3))
* Merge in state ab and other data
merge m:1 state using "$datadirectory/st_abb_fips.dta", nogen
* Merge in Congressional districts
merge 1:m state county using "$datadirectory/county_cd_cw.dta"
drop if _merge==2
drop _merge
rename cd110 district
sort st_abb district
* Collapse to districts
collapse (mean) corn_yield hec_yield [iw=weight], by(state st_abb district)
* Make quartile variables
xtile cornyield_quart = corn_yield, nq(4)
xtile hecyield_quart = hec_yield, nq(4)
gen cornyield_quart1 = cornyield_quart == 1
gen cornyield_quart2 = cornyield_quart == 2
gen cornyield_quart3 = cornyield_quart == 3
gen cornyield_quart4 = cornyield_quart == 4
gen hecyield_quart1 = hecyield_quart == 1
gen hecyield_quart2 = hecyield_quart == 2
gen hecyield_quart3 = hecyield_quart == 3
gen hecyield_quart4 = hecyield_quart == 4
save "$datadirectory/AgYields.dta", replace
* Open main data
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
* merge in yields
sort st_abb district
merge 1:m st_abb district using "$datadirectory/AgYields.dta", nogen
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
*** Probits for voting on ag variables
* Model 1
probit  vote_d_cat i.dem_cat hec_yield corn_yield 
estpost margins, dydx(*)
est store model1
* Model 2
# delimit;
probit  vote_d_cat i.dem_cat hecyield_quart2 hecyield_quart3 hecyield_quart4 
cornyield_quart2 cornyield_quart3 cornyield_quart4;
#delimit cr  
estpost margins, dydx(*)
est store model2
* Model 3
# delimit;
probit  vote_d_cat i.dem_cat hecyield_quart2 hecyield_quart3 hecyield_quart4 
cornyield_quart2 cornyield_quart3 cornyield_quart4 i.state_gp;
#delimit cr 
estpost margins, dydx(*)
est store model3
*** Make Table
#delimit;
cd "$tabledirectory";
estout model1 model2 model3 using "WM_vote_yields_$date.txt", 
order(1.dem_cat hec_yield corn_yield hecyield_quart* cornyield_quart* )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 1" "model 2" "model 3"  ) ;
#delimit cr

*** Appendix table 21
* Robustness to urban density, oil and auto interests
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
* Base model
#delimit ;
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 
i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 
i.coal_top10;
#delimit cr
estpost margins, dydx(*)
est sto model0
* Model 1
#delimit ;
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 
i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 
i.coal_top10 emp_ag_share emp_refin_share emp_auto_share;
#delimit cr
estpost margins, dydx(*)
est sto model1
* Model 2
#delimit ;
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 
i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 
i.coal_top10 emp_ag emp_refin emp_auto lpopdens_00;
#delimit cr
estpost margins, dydx(*)
est sto model2
*** Make Table
#delimit;
cd "$tabledirectory";
estout model0 model1 model2 using "WM_vote_Emp_$date.txt", 
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 
1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10
emp_ag_share emp_auto_share emp_refin_share lpopdens_00)
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 0" "model 1" "model 2"  ) ;
#delimit cr

*** Appendix table 22
* Investigating whether there are increasing returns to gains
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
*** Table 4 Model 4
probit  vote_d_cat  i.dem_cat l_pscs_catrfs_ratio
est sto RFSCATratio_4
estpost margins, dydx(*)
est sto RFSCATratio_avgmarg_4
** With quadratic term
probit vote_d_cat i.dem_cat c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio
est sto RFSCATratio_quad_4
estpost margins, dydx(*)
est sto RFSCATratio_quad_avgmarg_4
** With cubic term
probit vote_d_cat i.dem_cat c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio 
est sto RFSCATratio_cube_4
estpost margins, dydx(*)
est sto RFSCATratio_cube_avgmarg_4
*** Table 4 Model 5
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
probit  vote_d_cat  i.dem_cat  l_pscs_catrfs_ratio i.state_gp
est sto RFSCATratio_5
estpost margins, dydx(*)
est sto RFSCATratio_avgmarg_5
** With quadratic term
probit vote_d_cat i.dem_cat c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio i.state_gp
est sto RFSCATratio_quad_5
estpost margins, dydx(*)
est sto RFSCATratio_quad_avgmarg_5
** With cubic term
probit vote_d_cat i.dem_cat c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio##c.l_pscs_catrfs_ratio i.state_gp
est sto RFSCATratio_cube_5
estpost margins, dydx(*)
est sto RFSCATratio_cube_avgmarg_5
*** Make Table
#delimit;
cd "$tabledirectory";
estout RFSCATratio_4 RFSCATratio_quad_4 RFSCATratio_cube_4 RFSCATratio_5 RFSCATratio_quad_5 RFSCATratio_cube_5 using "RFSCATratio_$date.txt", 
order(1.dem_cat)
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 4" "model 4" "model 4" "model 5" "model 5" "model 5"  ) ;
#delimit cr
*** Make Table
#delimit;
cd "$tabledirectory";
estout RFSCATratio_avgmarg_4 RFSCATratio_quad_avgmarg_4 RFSCATratio_cube_avgmarg_4 RFSCATratio_avgmarg_5 RFSCATratio_quad_avgmarg_5 RFSCATratio_cube_avgmarg_5 using "RFSCATratio_avgmarg_$date.txt", 
order(1.dem_cat)
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 4" "model 4" "model 4" "model 5" "model 5" "model 5"  ) ;
#delimit cr

*** Using fixed interval bins for gains -- Referee appendix
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)
* CAT
gen pscs_cat_percap_n50_0 = pscs_cat_percap > -50 & pscs_cat_percap <= 0
gen pscs_cat_percap_0 = pscs_cat_percap > 0  
* RFS
gen pscs_rfs_percap_n100_n50 = pscs_rfs_percap > -100 & pscs_rfs_percap <=-50
gen pscs_rfs_percap_n50_0 = pscs_rfs_percap > -50 & pscs_rfs_percap <= 0
gen pscs_rfs_percap_0_50 = pscs_rfs_percap > 0 & pscs_rfs_percap<=50
gen pscs_rfs_percap_50_100 = pscs_rfs_percap > 50 & pscs_rfs_percap<=100
gen pscs_rfs_percap_100 = pscs_rfs_percap > 100 
* Fixed Intervals
#delimit;
probit  vote_d_cat i.dem_cat 
pscs_cat_percap_0 
pscs_rfs_percap_n50_0 pscs_rfs_percap_0_50 pscs_rfs_percap_50_100 
pscs_rfs_percap_100;
#delimit cr
estpost margins, dydx(*)
est sto model1
* Coal Dummy
#delimit;
probit  vote_d_cat i.dem_cat 
pscs_cat_percap_0 
pscs_rfs_percap_n50_0 pscs_rfs_percap_0_50 pscs_rfs_percap_50_100 
pscs_rfs_percap_100
i.coal_top10;
#delimit cr
estpost margins, dydx(*)
est sto model2
* State Effects
#delimit;
probit  vote_d_cat i.dem_cat 
pscs_cat_percap_0 
pscs_rfs_percap_n50_0 pscs_rfs_percap_0_50 pscs_rfs_percap_50_100 
pscs_rfs_percap_100
i.state_gp;
#delimit cr
estpost margins, dydx(*)
est sto model3
*** Make Table
#delimit;
cd "$tabledirectory";
estout model1 model2 model3 using "WM_vote_fixedbins_$date.txt", 
order(1.dem_cat pscs_cat_* pscs_rfs*  1.coal_top10
emp_ag emp_auto emp_refin lpopdens_00)
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("model 0" "model 1" "model 2"  ) ;
#delimit cr
*** Test coefficient est for gains > $100 in models 2 and 3
#delimit;
probit  vote_d_cat i.dem_cat 
pscs_cat_percap_0 
pscs_rfs_percap_n50_0 pscs_rfs_percap_0_50 pscs_rfs_percap_50_100 
pscs_rfs_percap_100
i.coal_top10;
#delimit cr
est sto model2
#delimit;
probit  vote_d_cat i.dem_cat 
pscs_cat_percap_0 
pscs_rfs_percap_n50_0 pscs_rfs_percap_0_50 pscs_rfs_percap_50_100 
pscs_rfs_percap_100
i.state_gp;
#delimit cr
est sto model3
suest model2 model3
test [model2_vote_d_cat]pscs_rfs_percap_100=[model3_vote_d_cat]pscs_rfs_percap_100


* END *
