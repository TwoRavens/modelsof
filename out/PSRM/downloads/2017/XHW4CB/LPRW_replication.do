*
* PSRM Replication for Lipsmeyer et al. "Comparing Dynamic Pies: A Strategy
* for Modeling Compositional Variables in Time and Space".
* 9/06/17
* 
* ------------------------------------------------
* verify burd is on here for nice-looking graphs. NOTE: If you do not have 
* internet access, skip this step (graphs will look slightly different due to
* the not having the `burd` scheme)

qui foreach package in scheme-burd {
		capture which `package'
		if _rc==111 ssc install `package'
 	}
set scheme burd
set more off


* Load in spmat data for SAR analysis below SAR-X analysis
use "massive_W.dta", clear
set matsize 8000
spmat dta massive_W w*, id(Wid) replace


use "US_budget_data_v2.dta",clear 
set seed 2095029


* save the dependent variables as a global:
global dvs "edu_ss pubserv_ss lm_ss oth_ss"


* These are needed to create the plots:
global spikeopts "lpattern(solid) lwidth(thin) lcolor(gs3)"
global graphmakerleft "twoway rspike var1_pie_ll_ var1_pie_ul_ time, $spikeopts ||rspike var2_pie_ll_ var2_pie_ul_ time, $spikeopts || rspike var3_pie_ll_ var3_pie_ul_ time, $spikeopts || rspike var4_pie_ll_ var4_pie_ul_ time, $spikeopts || rspike var5_pie_ll_ var5_pie_ul_ time, $spikeopts || scatter mid1 time, msymbol(smcircle_hollow) mcolor(black) || scatter mid2 time, msymbol(smtriangle_hollow) mcolor(black) || scatter mid3 time, msymbol(lgx) mcolor(black) || scatter mid4 time, msymbol(smdiamond_hollow) mcolor(black) || scatter mid5 time, msymbol(smsquare_hollow) mcolor(black) graphregion(color(white)) legend( region(lcolor(white)) order(6 "Education" 7 "Public Services" 8 "Labor Market Policy") rows(1)  keygap(0.8) size(medsmall) ) xtitle("Year") ytitle("Expected Proportion of State Expenditures") ylabel(0(.1).5, angle(0)) title("Democratic Governor")  xtick(#5,tlength(tiny) tlcolor(black) ) plotregion(style(none)) " 

global graphmakerright "twoway rspike var1_pie_ll_ var1_pie_ul_ time, $spikeopts ||rspike var2_pie_ll_ var2_pie_ul_ time, $spikeopts || rspike var3_pie_ll_ var3_pie_ul_ time, $spikeopts || rspike var4_pie_ll_ var4_pie_ul_ time, $spikeopts || rspike var5_pie_ll_ var5_pie_ul_ time, $spikeopts || scatter mid1 time, msymbol(smcircle_hollow) mcolor(black) || scatter mid2 time, msymbol(smtriangle_hollow) mcolor(black) || scatter mid3 time, msymbol(lgx) mcolor(black) || scatter mid4 time, msymbol(smdiamond_hollow) mcolor(black) || scatter mid5 time, msymbol(smsquare_hollow) mcolor(black) graphregion(color(white)) legend( region(lcolor(white)) order(10 "Social Services" 9 "Other") rows(1)  keygap(0.8) size(medsmall) ) xtitle("Year") ytitle("Expected Proportion of State Expenditures") ylabel(0(.1).5,  angle(0)) title("Republican Governor")  xtick(#5,tlength(tiny) tlcolor(black) ) plotregion(style(none)) " 

* Load in the various dynsimpie programs:
do "paneldynsimpieinter.ado"
do "orderplot.ado" 
do "dynsimladderplot.ado"

* xtset the data: 
xtset fips year

 

* Figure 1 ----------------

* --------------------------------------------------------------------------
* 1 sd drop in personal income

* 1 sd drop in personal income (under Dem gov)
preserve
paneldynsimpieinter unemployment Wed_unemployment 	///
, dvs($dvs) range(90) time(74) shockvar(real_pincome_pc) shock(-7.465)	///
 sig(95) interaction(demgov) intype(on) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 70
drop time 
gen time = _n
$graphmakerleft
graph save g1.gph, replace
restore
* 1 sd drop in personal income (under GOP gov)
preserve
paneldynsimpieinter unemployment Wed_unemployment 	///
, dvs($dvs) range(90) time(74) shockvar(real_pincome_pc) shock(-7.465)	///
 sig(95) interaction(demgov) intype(off) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 70
drop time 
gen time = _n
$graphmakerright
graph save g2.gph, replace
restore

graph combine g1.gph g2.gph, rows(1) xsize(5)
graph export Fig1_psrm.pdf, as(pdf) replace
* --------------------------------------------------------------------------


* Figure 2 ----------------
* 1 sd increase in unemployment

* 1 sd rise in own unemployment (under Dem gov)
preserve
paneldynsimpieinter real_pincome_pc Wed_unemployment 	///
, dvs($dvs) range(90) time(74) shockvar(unemployment) shock(1.974)	///
 sig(95) interaction(demgov) intype(on) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 70
drop time 
gen time = _n
$graphmakerleft
graph save g1.gph, replace
restore
* 1 sd rise in own unemployment (under GOP gov)
preserve
paneldynsimpieinter real_pincome_pc Wed_unemployment 	///
, dvs($dvs) range(90) time(74) shockvar(unemployment) shock(1.974)	///
 sig(95) interaction(demgov) intype(off) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 70
drop time 
gen time = _n
$graphmakerright
graph save g2.gph, replace
restore

graph combine g1.gph g2.gph, rows(1) xsize(5)
graph export Fig2_psrm.pdf, as(pdf) replace
* --------------------------------------------------------------------------



* Figure 3 ----------------
* 1 sd rise in surrounding states' unemployment

* 1 sd rise in surrounding unemployment (under Dem gov)
preserve
paneldynsimpieinter real_pincome_pc unemployment  	///
, dvs($dvs) range(90) time(74) shockvar(Wed_unemployment) shock(9.105)	///
 sig(95) interaction(demgov) intype(on) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 70
drop time 
gen time = _n
$graphmakerleft
graph save g1.gph, replace
restore
* 1 sd rise in surrounding unemployment (under GOP gov)
preserve
paneldynsimpieinter real_pincome_pc unemployment  	///
, dvs($dvs) range(90) time(74) shockvar(Wed_unemployment) shock(9.105)	///
 sig(95) interaction(demgov) intype(off) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 70
drop time 
gen time = _n
$graphmakerright
graph save g2.gph, replace
restore

graph combine g1.gph g2.gph, rows(1) xsize(5)
graph export Fig3_psrm.pdf, as(pdf) replace

* --------------------------------------------------------------------------


* Figure 4 ----------------
* Slope plot of 1 sd decrease in average personal income

* 1 sd drop in personal income (under Dem gov) 
preserve
paneldynsimpieinter unemployment Wed_unemployment 	///
, dvs($dvs) range(200) time(110) shockvar(real_pincome_pc) shock(-7.465)	///
 sig(95) interaction(demgov) intype(on) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 100
drop time 
gen time = _n
save dynsim_temp.dta, replace
orderplot, file(dynsim_temp) basetime(1) shocktime(10) endtime(100) cat1( Education) cat2(Public Services) cat3(Labor Market Policy) cat4(Other) cat5(Social Services) goptions(ytitle("Expected Proportion of Expenditures") title("Democratic Governor")) legend
graph save g1_op.gph, replace
restore
* 1 sd drop in personal income (under GOP gov)
preserve
paneldynsimpieinter unemployment Wed_unemployment 	///
, dvs($dvs) range(200) time(110) shockvar(real_pincome_pc) shock(-7.465)	///
 sig(95) interaction(demgov) intype(off) saving(dynsim_res) id(fips)
restore
preserve
use "dynsim_res", clear
drop if time <= 100
drop time 
gen time = _n
save dynsim_temp.dta, replace
* create orderplot
orderplot, file(dynsim_temp) basetime(1) shocktime(10) endtime(100) cat1( Education) cat2(Public Services) cat3(Labor Market Policy) cat4(Other) cat5(Social Services) goptions(ytitle("Expected Proportion of Expenditures") title("Republican Governor")) legend
graph save g2_op.gph, replace
restore


graph combine g1_op.gph g2_op.gph, rows(1) xsize(5)
graph export Fig4_psrm.pdf, as(pdf) replace
* --------------------------------------------------------------------------



* Figure 5 ----------------
* 1 sd decrase in average personal income

* 1 sd decrease under Democrat
dynsimladderplot unemployment Wed_unemployment 	///
, dvs($dvs) range(200) time(150) shockvar(real_pincome_pc) shock(-7.465)	///
 sig(95) interaction(demgov) intype(on) saving(dynsim_res) id(fips)  basetime(100) endtime(200)
preserve
use "dynsim_res", clear
twoway rspike var_pie_ul_sr_ var_pie_ll_sr sort_sr, horizontal lcolor(black) || rspike var_pie_ul_lr_ var_pie_ll_lr_ sort_lr, horizontal lcolor(black) || scatter  sort_sr mid_sr, msymbol(T) mcolor(black) || scatter sort_lr mid_lr, msymbol(O) mcolor(black) xline(0, lcolor(black) lstyle(solid)) legend(order(3 "Short-Run" 4 "Long-Run") ) ylabel(1 "Education" 2 "Public Services" 3"Labor Market Policy" 4 "Other" 5 "Social Services") xtitle("Expected Change from Baseline") title("Democratic Governor") plotregion(style(none)) yscale(axis(1) noline) xlabel(, grid glcolor(gs15))
graph save g1.gph, replace
restore
* 1 sd decrease under Republican
dynsimladderplot unemployment Wed_unemployment 	///
, dvs($dvs) range(200) time(150) shockvar(real_pincome_pc) shock(-7.465)	///
 sig(95) interaction(demgov) intype(off) saving(dynsim_res) id(fips) basetime(100) endtime(200)
preserve
use "dynsim_res", clear
twoway rspike var_pie_ul_sr_ var_pie_ll_sr sort_sr, horizontal lcolor(black) || rspike var_pie_ul_lr_ var_pie_ll_lr_ sort_lr, horizontal lcolor(black) || scatter  sort_sr mid_sr, msymbol(T) mcolor(black) || scatter sort_lr mid_lr, msymbol(O) mcolor(black) xline(0, lcolor(black) lstyle(solid)) legend(order(3 "Short-Run" 4 "Long-Run") ) ylabel( 1 "Education" 2 "Public Services" 3"Labor Market Policy" 4 "Other" 5 "Social Services") xtitle("Expected Change from Baseline") title("Republican Governor") plotregion(style(none)) yscale(axis(1) noline) xlabel(, grid glcolor(gs15))
graph save g2.gph, replace
restore

graph combine g1.gph g2.gph , rows(2) xcommon ysize(5) 
graph export Fig5_psrm.pdf, as(pdf) replace
* --------------------------------------------------------------------------



* Appendix, Table 3 ---------------
* Grab table of results:

eststo clear
eststo: sureg (d.edu_ss l.edu_ss l.demgov_edu_ss d.unemployment l.unemployment d.Wed_unemploymen l.Wed_unemployment d.real_pincome_pc l.real_pincome_pc d.demgov_unemployment l.demgov_unemployment d.demgov_Wed_unemployment l.demgov_Wed_unemployment d.demgov_real_pincome_pc l.demgov_real_pincome_pc d.demgov l.demgov) ///
 (d.pubserv_ss l.pubserv_ss l.demgov_pubserv_ss d.unemployment l.unemployment d.Wed_unemploymen l.Wed_unemployment d.real_pincome_pc l.real_pincome_pc d.demgov_unemployment l.demgov_unemployment d.demgov_Wed_unemployment l.demgov_Wed_unemployment d.demgov_real_pincome_pc l.demgov_real_pincome_pc d.demgov l.demgov) ///
 (d.lm_ss l.lm_ss l.demgov_lm_ss d.unemployment l.unemployment d.Wed_unemploymen l.Wed_unemployment d.real_pincome_pc l.real_pincome_pc d.demgov_unemployment l.demgov_unemployment d.demgov_Wed_unemployment l.demgov_Wed_unemployment d.demgov_real_pincome_pc l.demgov_real_pincome_pc d.demgov l.demgov) ///
 (d.oth_ss l.oth_ss l.demgov_oth_ss d.unemployment l.unemployment d.Wed_unemploymen l.Wed_unemployment d.real_pincome_pc l.real_pincome_pc d.demgov_unemployment l.demgov_unemployment d.demgov_Wed_unemployment l.demgov_Wed_unemployment d.demgov_real_pincome_pc l.demgov_real_pincome_pc d.demgov l.demgov)

esttab using table3.tex, replace se(3) star(* 0.10 ** 0.05 *** 0.01) sca("N Obs." "N_g States" "R2" "chi2 $\chi^2$" "chi2_c Prob $ > \chi^2$" ) title(Results for the Budget Composition) addn(Regression with standard errors in parentheses. Two-tail tests) b(3) 




/* ---------------------------------------------------------------------------
	
			SAR MODEL SECTION
			
 -------------------------------------------------------------------------*/
sort year fips // do the same sort as the W matrix
drop if year == 1976 // these are "." due to the first difference, so can't have them appear in the dataset anymore for spreg to work
gen Wid = _n
order Wid


* Table 1 ----------------
* Models used throughout (estimate and saved reduced form predictions):
spreg gs2sls dedu_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het 
predict y0_edu_ss // calculate reduced-form prediction for counterfactual 2
spreg gs2sls dpubserv_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het 
predict y0_pubserv_ss
spreg gs2sls dlm_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het 
predict y0_lm_ss
spreg gs2sls doth_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het 
predict y0_oth_ss
* --------------------------------------------------------------------------


* ------------------------------------------------------------
* counterfactual 1: Single shock to DV of a single state in a single year ---
* ------------------------------------------------------------
/* 

In 2000 OH's change to education was -0.004 (about .5% of the budget). In that
 same year, NH increased education by 0.11 (11% of the budget). What would the
 effect be on other states if OH would have had the same increase as NH?

Assume this increase in education is accounted for by an evenly distributed 
decrease in the relative proportions of all other categories:  */
di 0.11/4  // -.0275 for all other categories in the budget
* we need the starting values in 1999 since we need to calculate
* first-differences. First get education:
su pct_educat if year == 1999 & STUSPS == "OH" // 0.2899
* and public services
su pct_pubserv if year == 1999 & STUSPS == "OH" // .1229424
* labor market
su pct_lm if year == 1999 & STUSPS == "OH" //  .1920491
* other 
su pct_oth if year == 1999 & STUSPS == "OH" //  .1182959
* and the baseline category:
su pct_ss if year == 1999 & STUSPS == "OH" // 0.2768125


* Logged ratio in 1999 (soc services always denominator):
 di ln(0.2899/0.2768125) // .04619565 for edu_ss
 di ln(0.1229424/0.2768125) // -.81162443 for pubserv_ss
 di ln(0.1920491/0.2768125) // -.36558931 for lm_ss
 di ln(0.1182959/0.2768125) // -.85015127 for oth_ss
 
 * incorporating the counterfactual changes (what 2000 would have been):
di ln((0.2899+0.11)/(0.2768125-0.0275)) // .47250739 for edu_ss
 di ln((0.1229424-0.0275)/(0.2768125-0.0275)) // -.96018421 for pubserv_ss
 di ln((0.1920491-0.0275)/(0.2768125-0.0275)) // -.41549812 for lm_ss
 di ln((0.1182959-0.0275)/(0.2768125-0.0275)) // -1.010093 for oth_ss

* change from 1999 to 2000 (i.e. amount to shock OH) is 
di ln((0.2899+0.11)/(0.2768125-0.0275)) - ln(0.2899/0.2768125) // .42631173 edu_ss
 di ln((0.1229424-0.0275)/(0.2768125-0.0275)) - ln(0.1229424/0.2768125) // -.14855978 for pubserv_ss
 di ln((0.1920491-0.0275)/(0.2768125-0.0275)) - ln(0.1920491/0.2768125) // -.04990881 for lm_ss
 di ln((0.1182959-0.0275)/(0.2768125-0.0275)) - ln(0.1182959/0.2768125) // -.15994173 for oth_ss
 
 
* Re-run the models, grabbing lambda:
spreg gs2sls dedu_ss dunemployment  dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
mat coefs = e(b)
mat lambda_edu_ss = coefs[1,7] // obtain lambda
mat list lambda_edu_ss
spreg gs2sls dpubserv_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W)  het
mat coefs = e(b)
mat lambda_pubserv_ss = coefs[1,7] // obtain lambda
mat list lambda_pubserv_ss
spreg gs2sls dlm_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
mat coefs = e(b)
mat lambda_lm_ss = coefs[1,7] // obtain lambda
mat list lambda_lm_ss
spreg gs2sls doth_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
mat coefs = e(b)
mat lambda_oth_ss = coefs[1,7] // obtain lambda
mat list lambda_oth_ss


* Our weights matrix has 48 states, from 1977 to 2008, which means we have a 
* 1536*1536 matrix. In 2000, OH is row 1137.
preserve
use "massive_W.dta", clear
mkmat w1-w1536, matrix(wmat)
gen shocks_edu_ss = 0
replace shocks_edu_ss = .42631173 in 1137 // insert OH shock for edu_ss
gen shocks_pubserv_ss = 0
replace shocks_pubserv_ss = -.14855978 in 1137 // insert OH shock for pubserv_ss
gen shocks_lm_ss = 0
replace shocks_lm_ss = -.04990881 in 1137 // insert OH shock for lm_ss
gen shocks_oth_ss = 0
replace shocks_oth_ss = -.15994173 in 1137 // insert OH shock for oth_ss
* turn these into matrices:
mkmat shocks_edu_ss, matrix(shocks_edu_ss)
mkmat shocks_pubserv_ss, matrix(shocks_pubserv_ss)
mkmat shocks_lm_ss, matrix(shocks_lm_ss)
mkmat shocks_oth_ss, matrix(shocks_oth_ss)

mat effect_edu_ss = wmat*shocks_edu_ss // multiply W by shock vector
mat effect_pubserv_ss = wmat*shocks_pubserv_ss // multiply W by shock vector
mat effect_lm_ss = wmat*shocks_lm_ss // multiply W by shock vector
mat effect_oth_ss = wmat*shocks_oth_ss // multiply W by shock vector

* and multiply each of these effects by their respective lambdas:
mat effect_edu_ss = effect_edu_ss*lambda_edu_ss
mat effect_pubserv_ss = effect_pubserv_ss*lambda_pubserv_ss
mat effect_lm_ss = effect_lm_ss*lambda_lm_ss
mat effect_oth_ss = effect_oth_ss*lambda_oth_ss
restore

* put the predicted changes back into dataset:
svmat effect_edu_ss, names(effect_edu_ss)
svmat effect_pubserv_ss, names(effect_pubserv_ss)
svmat effect_lm_ss, names(effect_lm_ss)
svmat effect_oth_ss, names(effect_oth_ss)

* for each composition, bring in the 1999 value and place it in 2000, and
* create a new change variable equal to 1999 value + change
xtset
foreach var of varlist edu_ss pubserv_ss lm_ss oth_ss {
	gen pred_`var'_OH = l.`var' + effect_`var' // bring ln(var1/var5) from 1999 to 2000 and add in predicted change
	replace pred_`var'_OH = 0 if year != 2000 // change only is for 2000
	replace pred_`var'_OH = 0 if STUSPS == "OH"
}
* Now generate predicted values:  
foreach i in edu pubserv lm oth	{
	gen pred_OH_`i' = exp(pred_`i'_ss_OH)/(1+ exp(pred_edu_ss_OH) + exp(pred_pubserv_ss_OH) + exp(pred_lm_ss_OH) + exp(pred_oth_ss_OH))
}
	gen pred_OH_ss = 1/(1+ exp(pred_edu_ss_OH) + exp(pred_pubserv_ss_OH) + exp(pred_lm_ss_OH) + exp(pred_oth_ss_OH))

* to get predicted change need to subtract lagged values (in 1999)
foreach i in edu pubserv lm oth ss {
	replace pred_OH_`i' = (pred_OH_`i' - l.pct_`i')*100
	replace pred_OH_`i' = . if year != 2000
	replace pred_OH_`i' = 0 if STUSPS == "OH" & year == 2000
}

sort year fips


* Figure 6 ----------------------------
spmap effect_edu_ss if year == 2000 using "uscoord.dta", id(id) clmethod(custom) clbreaks(0 0.004 0.008 0.012 0.016 0.020) fcolor(Greens2) legtitle("Change in Logged Ratio") title("Predicted Change in Logged Ratio")
graph save g1.gph, replace
su pred_OH_edu if year == 2000
spmap pred_OH_edu if year == 2000 using "uscoord.dta", id(id) clmethod(custom) clbreaks(0 0.08 0.16 0.24 0.32 0.40) fcolor(Blues) legtitle("Percentage Point Change") title("Predicted Change in Education Expenditures")
graph save g2.gph, replace
graph combine g1.gph g2.gph, rows(2)
graph export "Fig6_psrm.pdf", as(pdf) replace


* Table 2 --------------------------------
preserve
keep if year == 2000
keep effect_edu_ss pred_OH_edu STUSPS
gsort - pred_OH_edu
list STUSPS effect_edu_ss pred_OH_edu
restore








* ------------------------------------------------------------
* counterfactual 2: ATI ---------------------------------------------------
* ------------------------------------------------------------
/*
what if all states in 2000 experience a change of (2000 change) + 1....aka a
$1000 in all states simultaneously in 2000
*/

* grab reduced form predictions from Table 1 models:
foreach i in edu pubserv lm oth	{
	gen pred_rform_`i' = exp(y0_`i'_ss)/(1 + exp(y0_edu_ss) + exp(y0_pubserv_ss) + exp(y0_lm_ss) + exp(y0_oth_ss))	
}
gen pred_rform_ss = 1/(1 + exp(y0_edu_ss) + exp(y0_pubserv_ss) + exp(y0_lm_ss) + exp(y0_oth_ss))


* now change values:
replace dreal_pincome_pc = dreal_pincome_pc + 1 if year == 2000
replace dincome_demgov = dincome_demgov + 1 if year == 2000 & demgov == 1

* repredict post-counterfactual
spreg gs2sls dedu_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
predict y1_edu_ss // calculate reduced-form prediction based on model
spreg gs2sls dpubserv_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
predict y1_pubserv_ss
spreg gs2sls dlm_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
predict y1_lm_ss
spreg gs2sls doth_ss dunemployment dreal_pincome_pc dunemp_demgov dincome_demgov demgov, id(Wid) dlmat(massive_W) het
predict y1_oth_ss

xtset 
foreach var of varlist edu_ss pubserv_ss lm_ss oth_ss	{
	gen `var'_y0 = l.`var' + y0_`var' // baseline prediction (no ATI)
	gen `var'_y1 = l.`var' + y1_`var' // +1 income (w/ spatial)
}


foreach i in edu pubserv lm oth	{
	gen pred_naiive_`i' = exp(`i'_ss_y0)/(1+ exp(edu_ss_y0) + exp(pubserv_ss_y0) + exp(lm_ss_y0) + exp(oth_ss_y0))
	gen pred_ati_`i' = exp(`i'_ss_y1)/(1+ exp(edu_ss_y1) + exp(pubserv_ss_y1) + exp(lm_ss_y1) + exp(oth_ss_y1))
}
gen pred_naiive_ss = 1/(1+ exp(edu_ss_y0) + exp(pubserv_ss_y0) + exp(lm_ss_y0) + exp(oth_ss_y0))
gen pred_ati_ss = 1/(1+ exp(edu_ss_y1) + exp(pubserv_ss_y1) + exp(lm_ss_y1) + exp(oth_ss_y1))

keep if year == 2000

foreach i in edu pubserv lm oth ss	{
	* Get difference between baseline prediction and ati, expressed as percentage point:
	gen diff_ati_naiive_`i' = (pred_ati_`i' - pred_naiive_`i')*100
}

* Figure 7 --------------------------------------
spmap diff_ati_naiive_edu using  "uscoord.dta", id(id)  clmethod(custom) clbreaks(-0.50 -0.40 -0.30 -0.20 -0.10 0.0)  fcolor(BuPu) legtitle("Percentage Point Change")
graph export "Fig7b_psrm.pdf", as(pdf) replace
spmap diff_ati_naiive_ss using  "uscoord.dta", id(id)  clmethod(custom) clbreaks(-0.50 -0.40 -0.30 -0.20 -0.10 0.0 0.10)  fcolor(BuPu) legtitle("Percentage Point Change")
graph export "Fig7a_psrm.pdf", as(pdf) replace

* NOTE: Fig 7 plots are graph combined in LaTeX.

* calculate Average Total Impact (ATI) for each category:
su diff_ati_naiive_edu diff_ati_naiive_lm diff_ati_naiive_pubserv diff_ati_naiive_ss diff_ati_naiive_oth

* --------------------------------------------------------------------------

