**************************************************************************************************
*** Replication data for: "The duration of government formation processes in Europe"           ***
*** Version: 11/9/2015																		   ***	
*** Authors: Alejandro Ecker (University of Vienna) and Thomas M. Meyer (University of Vienna) ***
*** Input-file: Data_The duration of government formation processes in Europe.dta  			   ***
*** Output: Tables 1, 1A, 2A, 3A, 4A, 5A; Figures: 1, 2, 3, 4, 5							   ***													   **
**************************************************************************************************

*** dependencies ***
capture ssc install estout

*** define directories for data, graphs and tables ***
global GETDIR  // your data directory
global WORKDIR // your working directory

*** load data set ***
use "$GETDIR\Data_The duration of government formation processes in Europe.dta", clear


***************************************************************************
*** Figure 1 - Bargaining duration across and within European countries ***
***************************************************************************

*** generate elements for modified box-plot ***
egen mean = mean(bargaining_duration), by(country_id)
egen upq = pctile(bargaining_duration), p(75) by(country_id)
egen loq = pctile(bargaining_duration), p(25) by(country_id)
egen iqr = iqr(bargaining_duration), by(country_id)
egen upper = max(min(bargaining_duration, upq + 1.5 * iqr)), by(country_id)
egen lower = min(max(bargaining_duration, loq - 1.5 * iqr)), by(country_id)
bysort mean: gen yorder = _n*-1 if _n == 1
replace yorder = sum(yorder)

*** generate value label for x-axis ***
levelsof country_id, local(countries)
foreach country of local countries {
	local i: label ctry_code `country'
	sum yorder if country_id == `country'
	local labels `labels' `r(mean)' "`i' "
}

*** draw Figure 1 ***
bysort east: sum bargaining_duration
twoway rbar mean mean yorder, pstyle(p1) blc(gs0) bfc(gs0) barw(0.5) ///
	|| rbar mean upq yorder, pstyle(p1) blc(none) bfc(none) barw(0.5) ///
	|| rbar mean loq yorder, pstyle(p1) blc(none) bfc(none) barw(0.5) ///
	|| rspike upq upper yorder, pstyle(p1) lcolor(gs0) ///
	|| rspike loq lower yorder, pstyle(p1) lcolor(gs0) ///
	|| rcap upper upper yorder, pstyle(p1) msize(*0.5) lcolor(gs0) ///
	|| rcap lower lower yorder, pstyle(p1) msize(*0.5) lcolor(gs0) ///
	|| scatter bargaining_duration yorder if !inrange(bargaining_duration, lower, upper), ms(o) mcolor(gs0) ///
	legend(off) xla(, noticks) yla(, ang(h)) ytitle("Bargaining duration (in days)" " ") xtitle("") ///
	graphregion(color(white) margin(zero)) xlabel(`labels', angle(45) labsize(small)) xscale(range(-27 -1)) ///
	ylabel(0(50)250,nogrid labsize(small)) yscale(range(0 250)) ///
	yline(29.3, lpattern(shortdash)) yline(27.5, lpattern(shortdash)) ///
	text(34.1 0 "CEE", size(small)) text(22.5 0 "WE", size(small)) ///
	aspectratio(0.66) xsize(6) legend(off)

*** drop help variables ***
drop mean upq loq iqr upper lower yorder
	
	
****************************************************************************************************
*** Figure 2 - Average bargaining duration for low and high levels of uncertainty and complexity ***
****************************************************************************************************

*** left panel: Unconditional effect of uncertainty ***
keep if coverage == 1
bysort east post_election: sum bargaining_duration
graph bar bargaining_duration, asyvars over(post_election, relabel(1 "inter-election" 2 "post-election") label(labsize(small))) over(east, relabel(1 `" " " " " " " "Western Europe" "' 2 `" " " " " " " "Central and Eastern Europe" "') label(labsize(small)))  bargap(10) ///
	graphregion(color(white) margin(zero)) ylabel(0(10)60,nogrid labsize(small)) ytitle("Bargaining duration (in days)" " ", size(medsmall)) ///
	bar(1, color(gs7)) bar(2, color(gs0)) blabel(bar, format(%9.0f)) xsize(3) legend(margin(medium) size(small) region(color(none))) subtitle("Inter-election vs. post-election (H1)" " ", size(small)) ///
	name(figure2a, replace)

*** right panel: unconditional effect of complexity (mean-split) ***
sum effno_parties
gen effno_parties_m = r(mean)
gen high_complexity = effno_parties >= effno_parties_m
graph bar bargaining_duration, asyvars over(high_complex, relabel(1 "low complexity" 2 "high complexity")) over(east, relabel(1 `" " " " " " " "Western Europe" "' 2 `" " " " " " " "Central and Eastern Europe" "') label(labsize(small))) bargap(10) ///	 
	graphregion(color(white) margin(zero)) ylabel(0(10)60,nogrid labsize(small)) ytitle("Bargaining duration (in days)" " ", size(medsmall)) ///
	bar(1, color(gs7)) bar(2, color(gs0)) legend(margin(medium) size(small) region(color(none))) blabel(bar, format(%9.0f)) xsize(3) subtitle("Low complexity vs. high complexity (H2)" " ", size(small)) ///
	name(figure2b, replace)

*** combine left and right panel ***
graph combine figure2a figure2b, xsize(6) graphregion(color(white) margin(zero)) ycommon

*** drop help variables ***
drop effno_parties_m


*******************************************************************************************************
*** Figure 3 - Conditional effects of uncertainty and complexity on the average bargaining duration ***
*******************************************************************************************************

bysort east post_election high_complexity: sum bargaining_duration

* draw figure *
graph bar bargaining_duration, over(post_election, relabel(1 "inter-election" 2 "post-election") label(labsize(small))) over(high_complexity, relabel(1 `" "low" "complexity" "' 2 `" "high" "complexity" "') label(labsize(small))) ///
	over(east, relabel(1 "Western Europe" 2 "Central and Eastern Europe") label(labsize(small)))  bargap(10) ///
	graphregion(color(white) margin(zero)) ylabel(0(10)60, nogrid labsize(small)) ytitle("Bargaining duration (in days)" " ", size(medsmall)) ///
	bar(1, color(gs7)) bar(2, color(gs0)) blabel(bar, format(%9.0f)) xsize(6) legend(margin(medium) size(small) region(color(none)))

*** drop help variables ***
drop high_complexity	
	

******************************************************
*** Table 1 - Determinants of bargaining duration  ***
******************************************************

*** stset data ***
stset bargaining_duration

*** define independent variables (Models 1 and 3) ***
global IVARS i.post_election c.effno_parties c.polarization i.majority_situation i.early_election

*** run models 1 and 3 ***
local i = 1
forval x = 0/1 {
	stcox $IVARS if east == `x'
	estat phtest, detail
	estadd scalar ph_pvalue = chi2tail(r(df), r(chi2))
	est store model`i'
	local i = `i' + 2
}

*** define independent variables (Models 2 and 4) ***
global IVARSCOND i.post_election##c.effno_parties i.post_election##c.polarization i.majority_situation i.early_election

*** run models 2 and 4 ***
local i = 2
forval x = 0/1 {
	stcox $IVARSCOND if east == `x'
	estat phtest, detail
	estadd scalar ph_pvalue = chi2tail(r(df), r(chi2))
	est store model`i'
	local i = `i' + 2
}

*** print output ***
cd "$WORKDIR"
esttab model1 model2 model3 model4 using Table1.rtf, replace ///
	star(* 0.05 ** 0.01 *** 0.001) label noomitted nobaselevels nonumbers ///
	scalars("risk Time at risk (in days)" "ll Log-likelihood" "ph_pvalue (Grambsch and Therneau 1994)") aic bic interaction(" x ") /// 
	mtitles("West (1)" "West (2)" "East (3)" "East (4)")


************************************************************************************************
*** Figures 4 and 5 - Marginal effects of uncertainty and complexity obtained via simulation ***
************************************************************************************************

*** As indicated in Endnote 8 all marginal effects are obtained using the  
*** code provided by "Licht, AA (2011) Change Comes with Time: Substantive 
*** Interpretation of Nonproportional Hazards in Event History Analysis. 
*** Political Analysis 19 (2): 227-243." See replication materials by 
*** Licht (2011).


************************************************************************************
*** Robustness - Table 1A: Alternative measure of complexity (Laver/Benoit 2015) ***
************************************************************************************

*** load data set ***
use "$GETDIR\Data_The duration of government formation processes in Europe.dta" if coverage == 1, clear

*** stset data ***
stset bargaining_duration

*** model 1 pooled ***
stcox i.post_election i.complexity i.early_election if east==0, nohr noshow
est store model1_lb
testparm i.complexity
	
*** model 2 pooled ***
stcox i.post_election i.complexity i.early_election if east==1, nohr noshow
est store model2_lb
testparm i.complexity

*** model 3, split sample ***
stcox i.complexity i.early_election if east==0 & post_elec == 0, nohr noshow
est store model3_lb_inter
testparm i.complexity

stcox i.complexity i.early_election if east==0 & post_elec == 1, nohr noshow
est store model3_lb_post
testparm i.complexity
		
*** model 4, split sample ***
stcox i.complexity i.early_election if east==1 & post_elec == 0, nohr noshow
est store model4_lb_inter
testparm i.complexity

stcox i.complexity i.early_election if east==1 & post_elec == 1, nohr noshow
est store model4_lb_post
testparm i.complexity

*** print output ***
esttab model?_l* using Table1A.rtf, replace ///
	star(* 0.05 ** 0.01 *** 0.001) label noomitted nobaselevels nonumbers ///
	scalars("risk Time at risk" "ll Log-likelihood") aic bic interaction(" x ") 

	
********************************************************************************************************
*** Robustness - Table 2A: Lower threshold for data on the ideological position of political parties ***
********************************************************************************************************

*** load data set ***
use "$GETDIR\Data_The duration of government formation processes in Europe.dta" if coverage_robust == 1, clear

*** stset data ***
stset bargaining_duration
	
*** define independent variables (Models 1 and 3) ***
global IVARS i.post_election c.effno_parties c.polarization i.majority_situation i.early_election

*** run models 1 and 3 ***
local i = 1
forval x = 0/1 {
	stcox $IVARS if east == `x'
	estat phtest, detail
	estadd scalar ph_pvalue = chi2tail(r(df), r(chi2))
	est store model`i'_rob
	local i = `i' + 2
}

*** define independent variables (Models 2 and 4) ***
global IVARSCOND i.post_election##c.effno_parties i.post_election##c.polarization i.majority_situation i.early_election

*** run models 2 and 4 ***
local i = 2
forval x = 0/1 {
	stcox $IVARSCOND if east == `x'
	estat phtest, detail
	estadd scalar ph_pvalue=chi2tail(r(df), r(chi2))
	est store model`i'_rob
	local i = `i' + 2
}

*** print output ***
esttab model1_rob model2_rob model3_rob model4_rob using Table2A.rtf, replace ///
	star(* 0.05 ** 0.01 *** 0.001) label noomitted nobaselevels nonumbers ///
	scalars("risk Time at risk (in days)" "ll Log-likelihood" "ph_pvalue (Grambsch and Therneau 1994)") aic bic interaction(" x ") /// 
	mtitles("WE unconditional effects (1)" "WE conditional effects (2)" "CEE unconditional effects (3)" "CEE conditional effects (4)")		

	
******************************************************************************************************************
*** Robustness - Table 3A: Effective number of parliamentary parties as only measure for bargaining complexity ***
******************************************************************************************************************

*** load data set ***
use "$GETDIR\Data_The duration of government formation processes in Europe.dta", clear

*** stset data ***
stset bargaining_duration
	
*** define independent variables (Models 1 and 3) ***
global IVARS i.post_election c.effno_parties i.majority_situation i.early_election

*** run models 1 and 3 ***
local i = 1
forval x = 0/1 {
	stcox $IVARS if east == `x'
	estat phtest, detail
	estadd scalar ph_pvalue=chi2tail(r(df), r(chi2))
	est store model`i'
	local i = `i' + 2
}

*** define independent variables (Models 2 and 4) ***
global IVARSCOND i.post_election##c.effno_parties i.majority_situation i.early_election

*** run models 2 and 4 ***
local i = 2
forval x = 0/1 {
	stcox $IVARSCOND if east == `x'
	estat phtest, detail
	estadd scalar ph_pvalue=chi2tail(r(df), r(chi2))
	est store model`i'
	local i = `i' + 2
}

*** print output ***
esttab model1 model2 model3 model4 using Table3A.rtf, replace ///
	star(* 0.05 ** 0.01 *** 0.001) label noomitted nobaselevels nonumbers ///
	scalars("risk Time at risk (in days)" "ll Log-likelihood") aic bic interaction(" x ") /// 
	mtitles("WE unconditional effects (1)" "WE conditional effects (2)" "CEE unconditional effects (3)" "CEE conditional effects (4)")		

	
*******************************************************************************************
*** Robustness - Table 4A: Accounting for unobserved heterogeneity via shared frailties ***
*******************************************************************************************

*** load data set ***
use "$GETDIR\Data_The duration of government formation processes in Europe.dta" if coverage == 1, clear

*** stset data ***
stset bargaining_duration

*** define independent variables (Models 1 and 3) ***
global IVARS i.post_election c.effno_parties c.polarization i.majority_situation i.early_election

* run models 1 and 3 ***
local i = 1
forval x = 0/1 {
	stcox $IVARS if east == `x', shared(country_id)
	estat phtest, detail
	estadd scalar ph_pvalue=chi2tail(r(df), r(chi2))
	est store model`i'_sf
	local i = `i' + 2
}

* define independent variables (Models 2 and 4) *
global IVARSCOND i.post_election##c.effno_parties i.post_election##c.polarization i.majority_situation i.early_election

*** run models 2 and 4 ***
local i = 2
forval x = 0/1 {
	stcox $IVARSCOND if east == `x', shared(country_id)
	estat phtest, detail
	estadd scalar ph_pvalue=chi2tail(r(df), r(chi2))
	est store model`i'_sf
	local i = `i' + 2
}

*** print output ***
esttab model1_sf model2_sf model3_sf model4_sf using Table4A.rtf, replace ///
	star(* 0.05 ** 0.01 *** 0.001) label noomitted nobaselevels nonumbers ///
	scalars("risk Time at risk (in days)" "ll Log-likelihood" "theta Theta" "se_theta Theta SE") aic bic interaction(" x ") /// 
	mtitles("WE unconditional effects (1)" "WE conditional effects (2)" "CEE unconditional effects (3)" "CEE conditional effects (4)")		

	
******************************************************************************************
*** Robustness - Table 5A: Accounting for violations of proportional hazard assumption ***
******************************************************************************************

*** load data set ***
use "$GETDIR\Data_The duration of government formation processes in Europe.dta" if coverage == 1, clear

*** stset data ***
stset bargaining_duration

*** models accounting for violation of proportional hazards assumption ***
stcox $IVARS if east==1, noshow nohr tvc(post_election)
est store model3_tvc
		
stcox $IVARSCOND if east==1, nohr noshow tvc(effno_parties)
est store model4_tvc

esttab model3_tvc model4_tvc using Table5A.rtf, replace ///
	star(* 0.05 ** 0.01 *** 0.001) label noomitted nobaselevels nonumbers ///
	scalars("risk Time at risk" "ll Log-likelihood") aic bic interaction(" x ") 
