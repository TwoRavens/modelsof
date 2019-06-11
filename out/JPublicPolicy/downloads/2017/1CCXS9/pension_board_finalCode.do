ssc install estout, replace
ssc install reghdfe
ssc install tuples
* set this following command to wherever you want the output to go
cd /Users/new/Dropbox/Dissertation/Data

* generates the mean investment return for each plan between 2001 and 2011

by planid: egen meaninv = mean(investmentreturn_1yr) if fy > 2000 & fy < 2012

* now generate a gap between this and discount rate

gen invgap = invreturnassump - meaninv if fy > 2000 & fy < 2012
gen invgap100 = 100 * invgap
gen invfrac = (meaninv/invreturnassump) * 100



*** geometric investment returns figuring out

mean(investmentreturn_1yr) if fy < 2012
gen geom_mean1 = (investmentreturn_1yr + 1) if fy > 2000 & fy < 2012
bysort planid: gen prod = sum(ln(geom_mean1))
by planid: replace prod = exp(prod[_N])
by planid: gen prod_root = prod ^ (1/11) if fy > 2000 & fy < 2012
gen geom_mean_final = (prod_root - 1) if fy > 2000 & fy < 2012
mean(geom_mean_final) if fy < 2012
	* down from .056 to .048


*** geometric discount rate figuring out

mean(invreturnassump) if fy < 2012
gen geom_mean1_disc = (invreturnassump + 1) if fy > 2000 & fy < 2012
bysort planid: gen prod_disc = sum(ln(geom_mean1_disc))
by planid: replace prod_disc = exp(prod_disc[_N])
by planid: gen prod_root_disc = prod_disc ^ (1/11) if fy > 2000 & fy < 2012
gen geom_mean_final_disc = (prod_root_disc - 1) if fy > 2000 & fy < 2012
mean(geom_mean_final_disc) if fy < 2012
	** negligible - down from .0795 to .0788 

	*** code to construct riskless funded ratio
	
	* code to merge in treasury rates

replace act_date = date(actvaldate_gasbassumptions, "MDY")
format act_date %td

	* the "MD20Y" is to account for the 2 digit years, while above handles 4 digit years
destring twentyyr, force replace
replace act_date = date(date, "MD20Y")
format act_date %td

* i need to merge this into the pensions database by act_date. however, there will be some mismatches
* like when the valuation date is jan 1. in this case, it would be best to use the previous date
* i can either do this manually or write code to handle it

merge m:1 act_date using "/Users/johnbrooks/Dropbox/Dissertation/Data/treasury_rates.dta"
sort planid fy

* if there is no merge available (_merge = 1) then convert act_date to the next available 
* and then merge it again

replace act_date = act_date - 2 if (_merge == 1) 
drop _merge

merge m:1 act_date using "/Users/johnbrooks/Dropbox/Dissertation/Data/treasury_rates.dta", update replace
sort planid fy

* one more time, cause jan 1st recodes will still have weekends involved
replace act_date = act_date - 2 if (_merge == 1) 
drop _merge

merge m:1 act_date using "/Users/johnbrooks/Dropbox/Dissertation/Data/treasury_rates.dta", update replace
sort planid fy

* now make the new liabilities and then funding ratios

replace twentyyr = twentyyr/100 

gen futureVal = actliabs * (1 + invreturnassump) ^ 20
replace risklessliabs = futureVal / ((1 + twentyyr)^20)

gen liabrev_r = risklessliabs/revenue

gen lnliabs_r = ln(risklessliabs)

gen funding_riskless = actassets/risklessliabs

su funding_riskless if fy <= 2011 



** descriptive stats

su $covars_descriptive

eststo clear

eststo: estpost su $covars_descriptive if fy > 2000 & fy < 2012

esttab using new_descriptive.tex, replace booktabs title(Descriptive Statistics) label cells("count mean sd min max sum")


**** SETTING UP MAIN PAPER REGRESSIONS

// these two are fot the non-IV models
global covars = "lag_funding_riskless divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_no_act = "lag_funding_riskless divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ"
global covarsnoLag = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_no_actnoLag = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ"



// these are for the first stage - i only actually use the no_act as an inst, the other is for show
global covars_first = "lag_logactives lag_divgovt lag_h_diffs lag_poldiv lag_repub_shareper lag_mds1 lunion lag_pcincome lag_econ"
global covars_first_full = "lag_logactives lag_divgovt lag_h_diffs lag_poldiv lag_repub_shareper lag_mds1 lunion lag_invreturnassump2 lag_assetvalcode lag_inv_return lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage  lag_ean lag_puc lag_ercont_percent lag_eecont_percent lag_pcincome lag_econ"

// this is for the second stahe in the IV
global covars_second = "lag_funding_riskless divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"
global covars_secondnoLag = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"


// generating the tables for the board regressions (aka the first stage)

	// the first stage, Table 1 in paper
	
	eststo clear
	
eststo: quietly reghdfe political $covars_first lag_political if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
predict polPredict
eststo: quietly reghdfe political $covars_first_full lag_political if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe active $covars_first lag_active if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
predict activePredict
eststo: quietly reghdfe active $covars_first_full lag_active if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe retired $covars_first lag_retired if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
predict retiredPredict
eststo: quietly reghdfe retired $covars_first_full lag_retired if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

esttab using "new_boardregs_full.tex", ar2 b(3) se(3) scalars(F) label replace booktabs  ///
title(Board Membership Regressions, All Plans\label{boardRegs_full}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	// no lag board composition robustness check
	
	eststo clear
	
eststo: quietly reghdfe political $covars_first if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
predict polPredictnoLag
eststo: quietly reghdfe political $covars_first_full if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe active $covars_first if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
predict activePredictnoLag
eststo: quietly reghdfe active $covars_first_full if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe retired $covars_first if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
predict retiredPredictnoLag
eststo: quietly reghdfe retired $covars_first_full if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

esttab using "new_boardregs_full_nolag.tex", ar2 b(3) se(3) scalars(F) label replace booktabs  ///
title(Board Membership Regressions, All Plans\label{boardRegs_fullnoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

// no FE board composition robustness check

	gen constant = 1 
	eststo clear
	
eststo: quietly reghdfe political $covars_first lag_political if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
predict polPredictnoFE
eststo: quietly reghdfe political $covars_first_full lag_political if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe active $covars_first lag_active if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
predict activePredictnoFE
eststo: quietly reghdfe active $covars_first_full lag_active if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe retired $covars_first lag_retired if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
predict retiredPredictnoFE
eststo: quietly reghdfe retired $covars_first_full lag_retired if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

esttab using "new_boardregs_full_noFE.tex", ar2 b(3) se(3) scalars(F) label replace booktabs  ///
title(Board Membership Regressions, All Plans\label{boardRegs_fullnoFE}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	
	// generating the tables for the discount rate regressions


global covars_disc_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_invreturnassump2"
global covars_disc = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_disc_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives ln_systemage lag_bonds lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"

global covars_disc_no_actnoLag = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ"
global covars_discnoLag = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_disc_instnoLag = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives ln_systemage lag_bonds lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"



	eststo clear


eststo: quietly reghdfe invreturnassump2 political active retired $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 political active retired $covars_disc if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 active retired $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 active retired $covars_disc if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 polPredict activePredict retiredPredict $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 polPredict activePredict retiredPredict $covars_disc_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 activePredict retiredPredict $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 activePredict retiredPredict $covars_disc_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_discrate_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Discount Rates\label{discountRate}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  eststo clear


eststo: quietly reghdfe invreturnassump2 political active retired $covars_disc_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 political active retired $covars_discnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 active retired $covars_disc_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 active retired $covars_discnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 polPredict activePredict retiredPredict $covars_disc_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 polPredict activePredict retiredPredict $covars_disc_instnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 activePredict retiredPredict $covars_disc_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 activePredict retiredPredict $covars_disc_instnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_discrate_regnoLag.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Discount Rates, No Lag Discount Rate\label{discountRatenoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  
  eststo clear


eststo: quietly reghdfe invreturnassump2 political active retired $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 political active retired $covars_disc if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 active retired $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 active retired $covars_disc if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 polPredict activePredict retiredPredict $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 polPredict activePredict retiredPredict $covars_disc_inst if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe invreturnassump2 activePredict retiredPredict $covars_disc_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe invreturnassump2 activePredict retiredPredict $covars_disc_inst if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

 esttab using new_discrate_regnoFE.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Discount Rates, No FE\label{discountRatenoFE}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
	
	// generating the tables for the funded ratio regressions
	
	// main paper
	eststo clear
xtset fy

eststo: quietly reghdfe funding_riskless political active retired $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless political active retired $covars if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless active retired $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless active retired $covars if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless polPredict activePredict retiredPredict $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless polPredict activePredict retiredPredict $covars_second if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless activePredict retiredPredict $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless activePredict retiredPredict $covars_second if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_funding_regs-MAIN.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Funded Ratios\label{funded_table}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	// appendix - no lag
	eststo clear
xtset fy

eststo: quietly reghdfe funding_riskless political active retired $covars_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless political active retired $covarsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless active retired $covars_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless active retired $covarsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless polPredict activePredict retiredPredict $covars_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless polPredict activePredict retiredPredict $covars_secondnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless activePredict retiredPredict $covars_no_actnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless activePredict retiredPredict $covars_secondnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_funding_regs-MAIN-noLag.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Funded Ratios, No Lagged Funded Ratio\label{funded_tablenoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
	// appendix - no FE
	eststo clear
xtset fy

eststo: quietly reghdfe funding_riskless political active retired $covars_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless political active retired $covars if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless active retired $covars_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless active retired $covars if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless polPredictnoFE activePredictnoFE retiredPredictnoFE $covars_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless polPredictnoFE activePredictnoFE retiredPredictnoFE $covars_second if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe funding_riskless activePredictnoFE retiredPredictnoFE $covars_no_act if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe funding_riskless activePredictnoFE retiredPredictnoFE $covars_second if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

esttab using new_funding_regs-MAIN-noFE.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Funded Ratios, No Fixed Effects\label{funded_tablenoFE}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


	
	// generating the tables for the log liabilities and log assets regressions

	global covars_both = "lag_lnliabs_r lag_lnassets divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_no_act_both = "lag_lnliabs_r lag_lnassets divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ"

global covars_liabsnoLag = "lag_lnassets divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_no_act_liabsnoLag = "lag_lnassets divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ"

global covars_assetsnoLag = "lag_lnliabs_r divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_no_act_assetsnoLag = "lag_lnliabs_r divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ"


// this is for the second stage in the IV
global covars_second_both = "lag_lnliabs_r lag_lnassets divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"
global covars_second_liabsnoLag = "lag_lnassets divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"
global covars_second_assetsnoLag = "lag_lnliabs_r divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"


	// main ones in paper
eststo clear
xtset fy

eststo: quietly reghdfe lnliabs_r political active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r political active retired $covars_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r active retired $covars_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r polPredict activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r polPredict activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_liabs_solo.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Log Riskless Liabilities\label{liabs_table}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


eststo clear
xtset fy

eststo: quietly reghdfe lnassets political active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets political active retired $covars_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets active retired $covars_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets polPredict activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets polPredict activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_assets_solo.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Log Assets\label{assets_table}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


	// version in appendix with no Lagged DVs as controls

eststo clear
xtset fy

eststo: quietly reghdfe lnliabs_r political active retired $covars_no_act_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r political active retired $covars_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r active retired $covars_no_act_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r active retired $covars_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r polPredict activePredict retiredPredict $covars_no_act_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r polPredict activePredict retiredPredict $covars_second_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r activePredict retiredPredict $covars_no_act_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r activePredict retiredPredict $covars_second_liabsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_liabs_solo-noLag.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Log Liabilities, No Lag Log Liabilities\label{liabs_tablenoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)



eststo clear
xtset fy

eststo: quietly reghdfe lnassets political active retired $covars_no_act_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets political active retired $covars_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets active retired $covars_no_act_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets active retired $covars_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets polPredict activePredict retiredPredict $covars_no_act_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets polPredict activePredict retiredPredict $covars_second_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets activePredict retiredPredict $covars_no_act_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets activePredict retiredPredict $covars_second_assetsnoLag if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_assets_solo-noLag.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Log Assets, No Lag Log Assets\label{assets_tablenoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	// version with no FE for the appendix
	
	eststo clear
xtset fy

eststo: quietly reghdfe lnliabs_r political active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r political active retired $covars_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r active retired $covars_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r polPredict activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r polPredict activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe lnliabs_r activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnliabs_r activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

esttab using new_liabs_solonoFE.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Log Riskless Liabilities, No Fixed Effects\label{liabs_tablenoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


eststo clear
xtset fy

eststo: quietly reghdfe lnassets political active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets political active retired $covars_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets active retired $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets active retired $covars_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets polPredict activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets polPredict activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

eststo: quietly reghdfe lnassets activePredict retiredPredict $covars_no_act_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)
eststo: quietly reghdfe lnassets activePredict retiredPredict $covars_second_both if fy < 2012 & fy > 2000, absorb(constant) vce(cluster stateid planid)

esttab using new_assets_solonoFE.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Log Assets, No Fixed Effects\label{assets_tablenoLag}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
	// other tables from the online appendix
	
		eststo clear
	
eststo: quietly reghdfe political $covars_first lag_political lag_funding_riskless if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
eststo: quietly reghdfe political $covars_first_full lag_political lag_funding_riskless if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe active $covars_first lag_active lag_funding_riskless if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
eststo: quietly reghdfe active $covars_first_full lag_active lag_funding_riskless if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe retired $covars_first lag_retired lag_funding_riskless if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)
eststo: quietly reghdfe retired $covars_first_full lag_retired lag_funding_riskless if fy < 2012 & fy > 2000, absorb(planid fy) vce(cluster stateid planid)

esttab using new_boardregs_full_funding.tex, ar2 b(3) se(3) scalars(F) label replace booktabs  ///
title(Board Membership Regressions, All Plans\label{boardRegs_full}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


by planid: gen lag_polPredict = polPredict[_n-1]
	by planid: gen lag_activePredict = activePredict[_n-1]
	by planid: gen lag_retiredPredict = retiredPredict[_n-1]
	
		// this one should go in the OA
	eststo clear
	
eststo: quietly reghdfe political $covars_first lag_political if fy < 2012 & fy > 2000 & politicalSD > 0, absorb(planid fy) vce(cluster stateid planid)
//predict polPredict
eststo: quietly reghdfe political $covars_first_full lag_political if fy < 2012 & fy > 2000 & politicalSD > 0, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe active $covars_first lag_active if fy < 2012 & fy > 2000 & activeSD > 0, absorb(planid fy) vce(cluster stateid planid)
//predict activePredict
eststo: quietly reghdfe active $covars_first_full lag_active if fy < 2012 & fy > 2000 & activeSD > 0, absorb(planid fy) vce(cluster stateid planid)

eststo: quietly reghdfe retired $covars_first lag_retired if fy < 2012 & fy > 2000 & retiredSD > 0, absorb(planid fy) vce(cluster stateid planid)
//predict retiredPredict
eststo: quietly reghdfe retired $covars_first_full lag_retired if fy < 2012 & fy > 2000 & retiredSD > 0, absorb(planid fy) vce(cluster stateid planid)

esttab using new_boardregs.tex, ar2 b(3) se(3) scalars(F)  label replace booktabs  ///
title(Board Membership Regressions, Boards that Vary\label{boardRegs}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	eststo clear
xtset fy

eststo: quietly reghdfe lead_funding political active retired $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lead_funding political active retired $covars if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lead_funding active retired $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lead_funding active retired $covars if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lead_funding polPredict activePredict retiredPredict $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lead_funding polPredict activePredict retiredPredict $covars_second if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe lead_funding activePredict retiredPredict $covars_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe lead_funding activePredict retiredPredict $covars_second if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

esttab using new_funding_regs-lead.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Next-Year's Plan Funded Ratios\label{fundingLead}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


by planid: replace political_pos_all = 1 if political - political[_n-1] > 0
by planid: replace active_pos_all = 1 if active - active[_n-1] > 0
by planid: replace retired_pos_all = 1 if retired - retired[_n-1] > 0
by planid: replace political_neg_all = 1 if political - political[_n-1] < 0
by planid: replace active_neg_all = 1 if active - active[_n-1] < 0
by planid: replace retired_neg_all = 1 if retired - retired[_n-1] < 0

by planid: replace political_pos = 1 if political - political[_n-1] >= .2
by planid: replace active_pos = 1 if active - active[_n-1] >= .2
by planid: replace retired_pos = 1 if retired - retired[_n-1] >= .2
by planid: replace political_neg = 1 if political - political[_n-1] <= -.2
by planid: replace active_neg = 1 if active - active[_n-1] <= -.2
by planid: replace retired_neg = 1 if retired - retired[_n-1] <= -.2

by planid: replace political_pos_small = 1 if (political - political[_n-1] <= .05) & (political - political[_n-1] > 0)
by planid: replace active_pos_small = 1 if (active - active[_n-1] <= .05) & (active - active[_n-1] > 0)
by planid: replace retired_pos_small = 1 if (retired - retired[_n-1] <= .05) & (retired - retired[_n-1] > 0) 
by planid: replace political_neg_small = 1 if (political - political[_n-1] >= -.05) & (political - political[_n-1] < 0)  
by planid: replace active_neg_small = 1 if (active - active[_n-1] >= -.05) & (active - active[_n-1] < 0)
by planid: replace retired_neg_small = 1 if (retired - retired[_n-1] >= -.05) & (retired - retired[_n-1] < 0)

by planid: replace political_same = 1 if political == political[_n-1]
by planid: replace active_same = 1 if active == active[_n-1]
by planid: replace retired_same = 1 if retired == retired[_n-1]
by planid: replace all_same = 1 if retired_same == 1 & active_same == 1 & political_same == 1



			eststo clear
xtset fy

eststo: quietly reghdfe Dfunding_riskless political_pos political_neg $Dcovars_no_act if (political_pos == 1 | political_neg == 1 | all_same == 1) & fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid system_id planid)
eststo: quietly reghdfe Dfunding_riskless political_pos political_neg $Dcovars if (political_pos == 1 |  political_neg == 1 | all_same == 1) & fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid system_id planid)

eststo: quietly reghdfe Dfunding_riskless active_pos active_neg $Dcovars_no_act if (active_pos == 1 | active_neg == 1 | all_same == 1) & fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid system_id planid)
eststo: quietly reghdfe Dfunding_riskless active_pos active_neg $Dcovars if (active_pos == 1 | active_neg == 1 | all_same == 1) & fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid system_id planid)

eststo: quietly reghdfe Dfunding_riskless retired_pos retired_neg $Dcovars_no_act if (retired_pos == 1 |  retired_neg == 1 | all_same == 1) & fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid system_id planid)
eststo: quietly reghdfe Dfunding_riskless retired_pos retired_neg $Dcovars if (retired_pos == 1 | retired_neg == 1 | all_same == 1) & fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid system_id planid)

esttab using new_funding_BIG-oneAtATime2.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Plan Funded Ratios, Big Changes\label{fundingBigChange}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
	
eststo clear


global covars_reqcont_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_reqemployer100"
global covars_reqcont = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_reqemployer100 lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_empcont100 lag_logactives lag_pcincome lag_econ"
global covars_reqcont_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_reqemployer100 lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives ln_systemage lag_bonds lag_ean lag_puc lag_empcont100 lag_pcincome lag_econ"


eststo: quietly reghdfe reqemployer100 political active retired $covars_reqcont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe reqemployer100 political active retired $covars_reqcont if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe reqemployer100 active retired $covars_reqcont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe reqemployer100 active retired $covars_reqcont if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe reqemployer100 polPredict activePredict retiredPredict $covars_reqcont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe reqemployer100 polPredict activePredict retiredPredict $covars_reqcont_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe reqemployer100 activePredict retiredPredict $covars_reqcont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe reqemployer100 activePredict retiredPredict $covars_reqcont_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_reqconts_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Required Employer Contributions\label{requiredregs}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  

   eststo clear

global covars_employercont_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_employercont100"
global covars_employercont = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_employercont100 lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_empcont100 lag_logactives lag_pcincome lag_econ"
global covars_employercont_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_employercont100 lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives ln_systemage lag_bonds lag_ean lag_puc lag_empcont100 lag_pcincome lag_econ"


eststo: quietly reghdfe employercont100 political active retired $covars_employercont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe employercont100 political active retired $covars_employercont if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe employercont100 active retired $covars_employercont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe employercont100 active retired $covars_employercont if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe employercont100 polPredict activePredict retiredPredict $covars_employercont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe employercont100 polPredict activePredict retiredPredict $covars_employercont_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe employercont100 activePredict retiredPredict $covars_employercont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe employercont100 activePredict retiredPredict $covars_employercont_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_employercont_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Actual Employer Contributions\label{employerContregs}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  
  eststo clear

global covars_employeecont_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_empcont100"
global covars_employeecont = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_empcont100 lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_employercont100 lag_logactives lag_pcincome lag_econ"
global covars_employeecont_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_empcont100 lag_invreturnassump2 lag_assetvalcode lag_investmentreturn_1yr lag_equities lag_realestate lag_alternatives ln_systemage lag_bonds lag_ean lag_puc lag_employercont100 lag_pcincome lag_econ"


eststo: quietly reghdfe empcont100 political active retired $covars_employeecont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe empcont100 political active retired $covars_employeecont if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe empcont100 active retired $covars_employeecont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe empcont100 active retired $covars_employeecont if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe empcont100 polPredict activePredict retiredPredict $covars_employeecont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe empcont100 polPredict activePredict retiredPredict $covars_employeecont_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe empcont100 activePredict retiredPredict $covars_employeecont_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe empcont100 activePredict retiredPredict $covars_employeecont_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_employeecont_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Employee Contributions\label{employeeContregs}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  
  *** investment returns

eststo clear

global covars_inv_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_invret100"
global covars_inv = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invret100 lag_assetvalcode lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_inv_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invret100 lag_assetvalcode lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"


eststo: quietly reghdfe invret100 political active retired $covars_inv_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invret100 political active retired $covars_inv if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invret100 active retired $covars_inv_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invret100 active retired $covars_inv if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invret100 polPredict activePredict retiredPredict $covars_inv_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invret100 polPredict activePredict retiredPredict $covars_inv_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invret100 activePredict retiredPredict $covars_inv_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invret100 activePredict retiredPredict $covars_inv_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_invreturns_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Investment Returns\label{invReturns}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  global covars_gap2_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_invgap100"
global covars_gap2 = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invgap100 lag_assetvalcode lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_gap2_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_invgap100 lag_assetvalcode lag_equities lag_realestate lag_alternatives lag_bonds ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"

  
  eststo: quietly reghdfe invgap100 political active retired $covars_gap2_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invgap100 political active retired $covars_gap2 if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invgap100 active retired $covars_gap2_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invgap100 active retired $covars_gap2 if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invgap100 polPredict activePredict retiredPredict $covars_gap2_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invgap100 polPredict activePredict retiredPredict $covars_gap2_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe invgap100 activePredict retiredPredict $covars_gap2_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe invgap100 activePredict retiredPredict $covars_gap2_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_investgap2_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Gap Between Discount Rate and Average Investment Returns\label{invReturnsGap}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  	** equities
	
	eststo clear
	
global covars_equities_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_equities"
global covars_equities = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_equities lag_assetvalcode  ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_equities_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_equities lag_assetvalcode ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"

  eststo: quietly reghdfe equities political active retired $covars_equities_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe equities political active retired $covars_equities if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe equities active retired $covars_equities_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe equities active retired $covars_equities if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe equities polPredict activePredict retiredPredict $covars_equities_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe equities polPredict activePredict retiredPredict $covars_equities_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe equities activePredict retiredPredict $covars_equities_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe equities activePredict retiredPredict $covars_equities_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_equities_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Investments in Equities\label{equities}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  
  	** alternatives
	
	eststo clear
	
	  global covars_alts_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_alternatives"
global covars_alts = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_alternatives lag_assetvalcode ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_alts_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_alternatives lag_assetvalcode  ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"

eststo: quietly reghdfe alternatives political active retired $covars_alts_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe alternatives political active retired $covars_alts if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe alternatives active retired $covars_alts_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe alternatives active retired $covars_alts if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe alternatives polPredict activePredict retiredPredict $covars_alts_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe alternatives polPredict activePredict retiredPredict $covars_alts_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe alternatives activePredict retiredPredict $covars_alts_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe alternatives activePredict retiredPredict $covars_alts_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_alternatives_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Investments in Alternatives\label{alternatives}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
  
  	** real estate
	
	eststo clear
	
	  global covars_re_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_realestate"
global covars_re = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_realestate lag_assetvalcode ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_re_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_realestate lag_assetvalcode ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"

eststo: quietly reghdfe realestate political active retired $covars_re_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe realestate political active retired $covars_re if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe realestate active retired $covars_re_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe realestate active retired $covars_re if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe realestate polPredict activePredict retiredPredict $covars_re_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe realestate polPredict activePredict retiredPredict $covars_re_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe realestate activePredict retiredPredict $covars_re_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe realestate activePredict retiredPredict $covars_re_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_realestate_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Investments in Real Estate\label{realestate}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
	eststo clear
	
	  global covars_bonds_no_act = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_pcincome lag_econ lag_bonds"
global covars_bonds = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_bonds lag_assetvalcode  ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_logactives lag_pcincome lag_econ"
global covars_bonds_inst = "divgovt h_diffs poldiv repub_shareper mds1 union sscov Gov_Balance_Con teachers policefire lag_bonds lag_assetvalcode ln_systemage lag_ean lag_puc lag_eecont_percent lag_ercont_percent lag_pcincome lag_econ"

  eststo: quietly reghdfe bonds political active retired $covars_bonds_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe bonds political active retired $covars_bonds if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe bonds active retired $covars_bonds_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe bonds active retired $covars_bonds if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe bonds polPredict activePredict retiredPredict $covars_bonds_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe bonds polPredict activePredict retiredPredict $covars_bonds_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

eststo: quietly reghdfe bonds activePredict retiredPredict $covars_bonds_no_act if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)
eststo: quietly reghdfe bonds activePredict retiredPredict $covars_bonds_inst if fy < 2012 & fy > 2000, absorb(stateid fy) vce(cluster stateid planid)

 esttab using new_bonds_reg.tex, ar2 b(3) se(3) label replace booktabs  ///
title(Board Membership and Investments in Bonds\label{bonds}) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
  
	
	
	
	******* making the maps in the appendix 

ssc install maptile
ssc install spmap
ssc install shp2dta 
ssc install mif2dta	 


maptile_install using "http://files.michaelstepner.com/geo_state.zip"


pctile funding_breaks=funding_riskless, nq(5)

shp2dta using s_04jn14, database(usdb2) coordinates(uscoord2) genid(stateid)
use usdb2, clear




eststo mean01: mean funding_riskless if fy == 2001, over(stateid)
eststo mean02: mean funding_riskless if fy == 2002, over(stateid)
eststo mean03: mean funding_riskless if fy == 2003, over(stateid)
eststo mean04: mean funding_riskless if fy == 2004, over(stateid)
eststo mean05: mean funding_riskless if fy == 2005, over(stateid)
eststo mean06: mean funding_riskless if fy == 2006, over(stateid)
eststo mean07: mean funding_riskless if fy == 2007, over(stateid)
eststo mean08: mean funding_riskless if fy == 2008, over(stateid)
eststo mean09: mean funding_riskless if fy == 2009, over(stateid)
eststo mean10: mean funding_riskless if fy == 2010, over(stateid)
eststo mean11: mean funding_riskless if fy == 2011, over(stateid)

estout mean01 mean02 mean03 mean04 mean05 mean06 mean07 mean08 mean09 mean10 mean11 using "riskless_state_means.csv"

import delimited "/Users/JohnBrooks/Dropbox/Dissertation/Data/riskless_state_means.csv", clear
save "/Users/JohnBrooks/Dropbox/Dissertation/Data/riskless_state_means.dta", replace
merge 1:1 stateid using usdb
drop _merge

gen above_2001 = (mean01 >= .5)
gen above_2002 = (mean02 >= .5)
gen above_2003 = (mean03 >= .5)
gen above_2004 = (mean04 >= .5)
gen above_2005 = (mean05 >= .5)
gen above_2006 = (mean06 >= .5)
gen above_2007 = (mean07 >= .5)
gen above_2008 = (mean08 >= .5)
gen above_2009 = (mean09 >= .5)
gen above_2010 = (mean10 >= .5)
gen above_2011 = (mean11 >= .5)

destring FIPS, replace

gen statefips = FIPS 
save "/Users/JohnBrooks/Dropbox/Dissertation/Data/riskless_state_means.dta", replace


maptile mean01, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2001.pdf", replace
maptile mean02, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2002.pdf", replace
maptile mean03, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2003.pdf"
maptile mean04, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2004.pdf"
maptile mean05, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2005.pdf"
maptile mean06, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2006.pdf"
maptile mean07, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2007.pdf"
maptile mean08, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2008.pdf"
maptile mean09, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2009.pdf"
maptile mean10, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2010.pdf"
maptile mean11, geo(state) geoid(statefips) cutp(funding_breaks)
graph export "/Users/JohnBrooks/Dropbox/Dissertation/Images/map2011.pdf"
