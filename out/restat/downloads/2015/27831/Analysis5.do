**********************************************************
*******  This file creates all figures and tables in the paper
*******  using:
*************   "$datadirectory/county_pscs_percap_$date$supplytoggle.dta", clear
*************   "$datadirectory/cd_pscs&votes_$date$supplytoggle.dta", 

clear 
set more off 
est clear
****  if $toggle==1 outsheet and estout
global toggle = 1  
global date = "210726"

****  supply toggles:  $supplytoggle==2 (corrects trapezoids) $supplytoggle==1 (shifts supply out) $supplytoggle==0 (no correction) 
global supplytoggle=2

*
*global preamble = "C:\AllStephen\My Dropbox\Jon n Chris"
*global preamble = "/Users/knittel/Dropbox/Landuse"
global preamble = "/Users/Jon/Dropbox/Landuse"
*
global datadirectory = "$preamble/5 - Probits/Data"
global codedirectory = "$preamble/5 - Probits/Code"
global tabledirectory = "$preamble/Write-up/Tables"
global figuredirectory = "$preamble/Write-up/Figures"



use "$datadirectory/county_pscs_percap_$date$supplytoggle.dta", clear
*** (Per Person Calc's)
#delimit;
collapse (sum) population pscs_rfs pscs_cat pscs_lcfs pscs_subs;
	foreach k in subs lcfs rfs cat	{;
	gen pscs_`k'_percap = pscs_`k'/population;
	};
	foreach k in subs lcfs rfs cat	{;
	sum pscs_`k';
	};
    foreach k in subs lcfs rfs cat	{;
	sum pscs_`k'_percap;
	};
#delimit cr

use "$datadirectory/county_pscs_percap_$date$supplytoggle.dta", clear
*** Table 2  (county level)
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
	outsheet using  "$tabledirectory/crosstabs_county_$date$supplytoggle.csv", delimiter(,) replace
	}

*** Table 2  (Congressional district level)
use "$datadirectory/cd_pscs&votes_$date_$date$supplytoggle.dta", clear
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

if $toggle==1{;
	outsheet using "$tabledirectory/crosstabs_districts_$date$supplytoggle.csv", delimiter(,) replace;
	};

#delimit cr

*** Table 3
use "$datadirectory/cd_pscs&votes_$date$supplytoggle.dta", clear
drop if vote_d_cat==.
gen column=1*(dem_cat==1 & vote_d_cat==1) + 2*(dem_cat==1 & vote_d_cat==0)+3*(dem_cat==0 & vote_d_cat==1)+4*(dem_cat==0 & vote_d_cat==0)
tabstat pscs_cat_percap pscs_rfs_percap, stat(mean med p75 p90 n) by( column) c(v)
tabstat amt_opp amt_supp , stat(mean med p75 p90 n) by( column) c(v) f(%5.2g)
** to get p-values, run these regs by dem_cat w/ dependent vars: pscs_cat_percap pscs_rfs_percap amt_opp amt_supp
reg pscs_cat_percap vote_d_cat if dem_cat==1
qreg pscs_cat_percap vote_d_cat if dem_cat==1
qreg pscs_cat_percap vote_d_cat if dem_cat==1,  quantile(.75)
qreg pscs_cat_percap vote_d_cat if dem_cat==1,  quantile(.9)
reg pscs_cat_percap vote_d_cat if dem_cat==0
qreg pscs_cat_percap vote_d_cat if dem_cat==0
qreg pscs_cat_percap vote_d_cat if dem_cat==0,  quantile(.75)
qreg pscs_cat_percap vote_d_cat if dem_cat==0,  quantile(.9)
*etc

*** Table 3 with relative gains 
use "$datadirectory/cd_pscs&votes_$date$supplytoggle.dta", clear
drop if vote_d_cat==.
* Convert relative gains from $1000s to $
replace pscs_rfscat_diff = pscs_rfscat_diff*1000
gen column=1*(dem_cat==1 & vote_d_cat==1) + 2*(dem_cat==1 & vote_d_cat==0)+3*(dem_cat==0 & vote_d_cat==1)+4*(dem_cat==0 & vote_d_cat==0)
tabstat pscs_rfscat_diff, stat(mean p50 p75 p90 n) by( column) c(v)
*tabstat amt_opp amt_supp , stat(mean med p75 p90 n) by( column) c(v) 
** to get p-values, run these regs by dem_cat w/ dependent vars: pscs_cat_percap pscs_rfs_percap amt_opp amt_supp
* Dems
reg pscs_rfscat_diff vote_d_cat if dem_cat==1
qreg pscs_rfscat_diff vote_d_cat if dem_cat==1
qreg pscs_rfscat_diff vote_d_cat if dem_cat==1,  quantile(.75)
qreg pscs_rfscat_diff vote_d_cat if dem_cat==1,  quantile(.9)
* Repubs
reg pscs_rfscat_diff vote_d_cat if dem_cat==0
qreg pscs_rfscat_diff vote_d_cat if dem_cat==0
qreg pscs_rfscat_diff vote_d_cat if dem_cat==0,  quantile(.75)
qreg pscs_rfscat_diff vote_d_cat if dem_cat==0,  quantile(.9)

*** Empirical Models
use "$datadirectory/cd_pscs&votes_$date$supplytoggle", clear
* Create state dummy variables
qui: tabulate st_abb, generate(st_abb_d)
gen state_gp = group(statefip)

*** Table 4: Linear specifications
*** Logs are all shifted by $100 per cap carbon benefit now...  
****** Table 4 Model 1
probit  vote_d_cat  i.dem_cat lpscs_cat_percap
*margin 
estpost margins, dydx(*)
est store model_base1
****** Table 4 Model 2
probit  vote_d_cat  i.dem_cat lpscs_cat_percap lpscs_rfs_percap
*margin 
estpost margins, dydx(*)
est store model_base2
****** Table 4 Model3
probit  vote_d_cat  i.dem_cat lpscs_cat_percap lpscs_rfs_percap i.state_gp
*margin 
estpost margins, dydx(*)
est store model_base3
****** Table 4 Model 4
probit  vote_d_cat  i.dem_cat  l_pscs_catrfs_ratio
*margin 
estpost margins, dydx(*)
est store model_base4
****** Table 4 Model 5
probit  vote_d_cat  i.dem_cat l_pscs_catrfs_ratio i.state_gp
*margin 
estpost margins, dydx(*)
est store model_base5


*** Table 5: Quartiles of benefits
****** Table 5 Model 1
probit  vote_d_cat  i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart1
****** Table 5 Model 2
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart2
****** Table 5 Model 3
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.state_gp
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_quart3

*** Table 6: Robustness Checks/Cragg Kahn variables
****** Table 6 Model 1
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.coal_top10
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_robust1
* Adding both ideology and per capita emissions to base model
****** Table 6 Model 2
probit  vote_d_cat  i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.coal_top10 dwnom1 l_vulcan lplant_rate 
estpost margins, dydx(*)
est store model_robust2
****** Table 6 Model 3
* Adding corn production and pop density
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 i.coal_top10 l_vulcan lplant_rate l_corn_2007 lpopdens_00
estpost margins, dydx(*)
est store model_robust3
****** Table 6 Model 4
* Adding state fe's
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 l_vulcan lplant_rate l_corn_2007 lpopdens_00 i.state_gp
estpost margins, dydx(*)
est store model_robust4

*** Table 7: Contributions
****** Table 7 Model 1-2
reg l_amt_opp i.dem_cat  i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 
est store model_cont1
areg l_amt_opp i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 , absorb(st_abb)
est store model_cont2

****** Table 7 Model 3-4
reg l_amt_supp i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4  
est store model_cont3
areg l_amt_supp i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 , absorb(st_abb)
est store model_cont4

*** Table 8: Vote with contributions
* Contributions
****** Table 8 Model 1
probit  vote_d_cat i.dem_cat l_amt_supp l_amt_split l_amt_opp
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_vcont1
****** Table 8 Model 2
probit  vote_d_cat i.dem_cat  i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 l_amt_supp l_amt_split l_amt_opp
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_vcont2
****** Table 8 Model 3
probit  vote_d_cat i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 l_amt_supp l_amt_split l_amt_opp i.state_gp
* margins, dydx(*) post 
estpost margins, dydx(*)
est store model_vcont3
****** Table 8 Model 4
* Adding both ideology, corn, and per capita emissions to base model and contributions
probit  vote_d_cat  i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 l_amt_supp l_amt_split l_amt_opp i.coal_top10 l_vulcan lplant_rate l_corn_2007 lpopdens_00 
estpost margins, dydx(*)
est store model_vcont4
****** Table 8 Model 5
* Adding both ideology, corn, and per capita emissions to base model and contributions AND State FE
probit  vote_d_cat  i.dem_cat i.pscs_cat_quart_2 i.pscs_cat_quart_3 i.pscs_cat_quart_4 i.pscs_rfs_quart_2 i.pscs_rfs_quart_3 i.pscs_rfs_quart_4 l_amt_supp l_amt_split l_amt_opp l_vulcan lplant_rate l_corn_2007 lpopdens_00 i.state_gp
estpost margins, dydx(*)
est store model_vcont5

if $toggle==1{
#delimit;
cd "$tabledirectory";
estout model_base* using "WMvotes_dprobit_$date.txt", order(1.dem_cat  lpscs_cat_percap lpscs_rfs_percap l_pscs_catrfs_ratio )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("Model 1" "Model 2" "Model 3" "Model 4" "Model 5") ;

estout model_quart*  using "WMvotes_quartiles_dprobit_$date.txt",
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace  collabels(, none)
mlabels("Model 1" "Model 2" "Model 3" "Model 4");

estout model_cont1 model_cont2 model_cont3 model_cont4 using "WMvotes_quartiles_ols_cont_$date.txt", 
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4)
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p r2, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2" R2)) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("Opposing" "Opposing" "Supporting" "Supporting") ;

estout model_robust* using "WMvotes_robustness_dprobit_$date.txt",
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 1.coal_top10  dwnom1 l_vulcan lplant_rate l_corn_2007)
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f)
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("Model 1" "Model 2" "Model 3" "Model 4") ;

estout model_vcont1 model_vcont2 model_vcont3 model_vcont4 model_vcont5 using "WMvotes_vote_cont_dprobit_$date.txt", 
order(1.dem_cat 1.pscs_cat_quart_2 1.pscs_cat_quart_3 1.pscs_cat_quart_4 1.pscs_rfs_quart_2 1.pscs_rfs_quart_3 1.pscs_rfs_quart_4 l_amt_supp l_amt_split l_amt_opp 1.coal_top10  dwnom1 l_vulcan lplant_rate l_corn_2007 lpopdens_00 )
cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) style(tab)  stats(N chi2 p ll r2_p, fmt(%8.0f %9.3f) 
labels(Observations Chi2 p-value Log-Likelihood "Pseudo-R2")) starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(_cons Constant) label replace collabels(, none)
mlabels("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" ) ;

#delimit cr

}




/* END */


