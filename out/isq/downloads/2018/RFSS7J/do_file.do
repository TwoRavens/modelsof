// *--------+---------+---------+---------+---------+---------+---------+
// Do File for "Wage Bargaining, Inequality, and the Dutch Disease"
// Jonas Bunte
// *--------+---------+---------+---------+---------+---------+---------+

clear all
cd "~/Dropbox/Privat/UT Dallas/ Research/5 R&R/Severity of Dutch Disease/Writing/NTR v17 ISQ Final/ Submission/3 Replication Data"

capture log close
log using "log.log", replace

use "data.dta"



// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure 1
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

xtset A_id_number A_year
gen ntr_log = ln(BB_dunning3)
gen exports_diff = d.DB_manu1
replace exports_diff = . if exports_diff < -40
list A_id_name A_year ntr_log exports_diff if ntr_log > 5 & ntr_log < . & exports_diff > 3
list A_id_name A_year ntr_log exports_diff if ntr_log > 4 & ntr_log < . & exports_diff < -5

qui sum exports_diff
local exports_mean = 0

qui sum ntr_log
local ntr_mean = r(mean)
replace ntr_log = . if ntr_log < `ntr_mean'

twoway (scatter exports_diff ntr_log) , ///
yline(`exports_mean', lwidth(thin) lcolor(black) lpattern(solid)) ///
legend(off) ///
xtitle("Non-tax revenues as percentage of GDP (log)") ///
ytitle("Change in exports from previous year" "(% of GDP)")
capture noisily graph export "A_descriptive_exports.pdf", replace



// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure 2
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

xtset A_id_number A_year
gen wages_diff = d.DD_rate1

gen inflation_diff = d.DG_cpi3

qui sum inflation_diff
local wages_mean = r(mean)

twoway (scatter wages_diff ntr_log) , ///
yline(`wages_mean', lwidth(thin) lcolor(black) lpattern(solid)) ///
legend(off) ///
xtitle("Non-tax revenues as percentage of GDP (log)") ///
ytitle("Change in wages from previous year" "(% of GDP)")
capture noisily graph export "A_descriptive_wages.pdf", replace




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure 3 
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

capture drop reer_*
xtset A_id_number A_year
gen reer_diff = d.DG_reer1

qui sum reer_diff
local reer_mean = 0

twoway (scatter reer_diff ntr_log) , ///
yline(`reer_mean', lwidth(thin) lcolor(black) lpattern(solid)) ///
legend(off) ///
xtitle("Non-tax revenues as percentage of GDP (log)") ///
ytitle("Change in real exchange rate from previous year " "(% of GDP)")
capture noisily graph export "A_descriptive_reer.pdf", replace






// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure 6 & 7 / Table B
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

// set key IVs

global WC = "CA_cent"
global IN = "CC_gini3"
global NTR = "BB_dunning3"
global controls_exports "i.OB_01 c.DA_pc8 c.DC_total1 c.DD_overall2 c.DE_total c.DG_nominal1 country* "
global controls_wages "c.CA_golden3 c.DA_pc8 c.DC_total1 c.DE_total c.DG_cpi5 country* "
global controls_reer "c.BA_cbi2 c.DA_relprod c.DA_pc8 c.DG_cpi5 c.DG_nominal1 i.OB_01 country* "

sum $WC
global min1 = round(r(min),.1)
global max1 = round(r(max),.1)
global step1 = ($max1 - $min1)/10

sum $IN
global min2 = round(r(min),.1)
global max2 = round(r(max),.1)
global step2 = ($max2 - $min2)/10

sum $NTR
global min3 = round(r(min),10)
global max3 = round(r(max),10)
global step3 = ($max3 - $min3)/10


// *--------+---------+---------+---------+---------+---------+---------+
// Wage-coordination

global exports_wage_reg1 "xtpcse c.DB_exports_clean5 c.$WC##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports_wage_reg2 "xtpcse c.DB_exports_clean6 c.$WC##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports_wage_reg3 "xtpcse c.DB_manu1 c.$WC##c.$NTR $controls_exports  , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_wage_reg`x'}
	if _rc == 0 { 
		// marginal effects
		capture noisily margins , dydx($NTR) atmeans at($WC=($min1($step1)$max1)) noatlegend force
		capture noisily marginsplot	, recast(line) recastci(rarea) yline(0) title("") ytitle("Marginal effect of natural resources on exports") xtitle("Degree of Wage Coordination")
		capture noisily graph export "B_exports_wage_reg`x'_margins.pdf", replace
		// predict y-hats
		capture noisily margins, atmeans at((p20) $WC $NTR=($min3($step3)$max3)) saving(temp1, replace) noatlegend force
		capture noisily margins, atmeans at((p80) $WC $NTR=($min3($step3)$max3)) saving(temp2, replace) noatlegend force
		capture noisily combomarginsplot temp1 temp2 , labels("Low wage-coordination" "High wage-coordination" ) recast(line) recastci(rarea) ///
		file1opts(pstyle(p1)) file2opts(pstyle(p2)) plot1opts(lpattern("--")) ///
		 lplot1(mfcolor(white)) legend(colfirst) ///
		 title(" ") ytitle("Predicted exports") xtitle("Resource rents per capita")
		capture noisily graph export "B_exports_wage_reg`x'_yhat.pdf", replace
		}
	}


// *--------+---------+---------+---------+---------+---------+---------+
// Inequality

global exports_ineq_reg1 "xtpcse c.DB_exports_clean5 c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports_ineq_reg2 "xtpcse c.DB_exports_clean6 c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports_ineq_reg3 "xtpcse c.DB_manu1 c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_ineq_reg`x'}
	if _rc == 0 { 
		// marginal effects
		capture noisily margins , dydx($NTR) atmeans at($IN=($min2($step2)$max2)) noatlegend force
		capture noisily marginsplot	, recast(line) recastci(rarea) yline(0) title("") ytitle("Marginal effect of natural resources on exports") xtitle("Gini")
		capture noisily graph export "B_exports_ineq_reg`x'_margins.pdf", replace
		// predict y-hats
		capture noisily margins, atmeans at((p20) $IN $NTR=($min3($step3)$max3)) saving(temp1, replace) noatlegend force
		capture noisily margins, atmeans at((p80) $IN $NTR=($min3($step3)$max3)) saving(temp2, replace) noatlegend force
		capture noisily combomarginsplot temp1 temp2 , labels("Low inequality" "High inequality" ) recast(line) recastci(rarea) ///
		file1opts(pstyle(p1)) file2opts(pstyle(p2)) plot1opts(lpattern("--")) ///
		 lplot1(mfcolor(white)) legend(colfirst) ///
		 title(" ") ytitle("Predicted exports") xtitle("Resource rents per capita")
		capture noisily graph export "B_exports_ineq_reg`x'_yhat.pdf", replace
		}
	}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure 8 & 9 / Table C
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+


// *--------+---------+---------+---------+---------+---------+---------+
// Wage coordination

global wages_wage_reg1 "xtpcse c.DD_overall3 c.$WC##c.$NTR $controls_wages , pairwise correlation(ar1)"
global wages_wage_reg2 "xtpcse c.DD_rate1 c.$WC##c.$NTR $controls_wages , pairwise correlation(ar1)"
global wages_wage_reg3 "xtpcse c.DD_manu1 c.$WC##c.$NTR $controls_wages , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_wage_reg`x'}
	if _rc == 0 { 
		// marginal effects
		capture noisily margins , dydx($NTR) atmeans at($WC=($min1($step1)$max1)) noatlegend force
		capture noisily marginsplot	, recast(line) recastci(rarea) yline(0) title("") ytitle("Marginal effect of natural resources on wages") xtitle("Degree of Wage Coordination")
		capture noisily graph export "B_wages_wage_reg`x'_margins.pdf", replace
		// predict y-hats
		capture noisily margins, atmeans at((p20) $WC $NTR=($min3($step3)$max3)) saving(temp1, replace) noatlegend force
		capture noisily margins, atmeans at((p80) $WC $NTR=($min3($step3)$max3)) saving(temp2, replace) noatlegend force
		capture noisily combomarginsplot temp1 temp2 , labels("Low wage-coordination" "High wage-coordination" ) recast(line) recastci(rarea) ///
		file1opts(pstyle(p1)) file2opts(pstyle(p2)) plot1opts(lpattern("--")) ///
		 lplot1(mfcolor(white)) legend(colfirst) ///
		 title(" ") ytitle("Predicted wages") xtitle("Resource rents per capita")
		capture noisily graph export "B_wages_wage_reg`x'_yhat.pdf", replace
		}
	}


// *--------+---------+---------+---------+---------+---------+---------+
// Inequality

global wages_ineq_reg1 "xtpcse c.DD_overall3 c.$IN##c.$NTR $controls_wages , pairwise correlation(ar1)"
global wages_ineq_reg2 "xtpcse c.DD_rate1 c.$IN##c.$NTR $controls_wages , pairwise correlation(ar1)"
global wages_ineq_reg3 "xtpcse c.DD_manu1 c.$IN##c.$NTR $controls_wages , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_ineq_reg`x'}
	if _rc == 0 { 
		// marginal effects
		capture noisily margins , dydx($NTR) atmeans at($IN=($min2($step2)$max2)) noatlegend force
		capture noisily marginsplot	, recast(line) recastci(rarea) yline(0) title("") ytitle("Marginal effect of natural resources on wages") xtitle("Gini")
		capture noisily graph export "B_wages_ineq_reg`x'_margins.pdf", replace
		// predict y-hats
		capture noisily margins, atmeans at((p20) $IN $NTR=($min3($step3)$max3)) saving(temp1, replace) noatlegend force
		capture noisily margins, atmeans at((p80) $IN $NTR=($min3($step3)$max3)) saving(temp2, replace) noatlegend force
		capture noisily combomarginsplot temp1 temp2 , labels("Low inequality" "High inequality" ) recast(line) recastci(rarea) ///
		file1opts(pstyle(p1)) file2opts(pstyle(p2)) plot1opts(lpattern("--")) ///
		 lplot1(mfcolor(white)) legend(colfirst) ///
		 title(" ") ytitle("Predicted wages") xtitle("Resource rents per capita")
		capture noisily graph export "B_wages_ineq_reg`x'_yhat.pdf", replace
		}
	}



// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure 10 & 11 / Table D
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

// *--------+---------+---------+---------+---------+---------+---------+
// Wage coordination

global reer_wage_reg1 "xtpcse c.DG_reer2 c.$WC##c.$NTR $controls_reer , pairwise correlation(ar1)"
global reer_wage_reg2 "xtpcse c.DG_reer1 c.$WC##c.$NTR $controls_reer , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_wage_reg`x'}
	if _rc == 0 { 
		// marginal effects
		capture noisily margins , dydx($NTR) atmeans at($WC=($min1($step1)$max1)) noatlegend force
		capture noisily marginsplot	, recast(line) recastci(rarea) yline(0) title("") ytitle("Marginal effect of natural resources on exchange rate") xtitle("Degree of Wage Coordination")
		capture noisily graph export "B_reer_wage_reg`x'_margins.pdf", replace
		// predict y-hats
		capture noisily margins, atmeans at((p20) $WC $NTR=($min3($step3)$max3)) saving(temp1, replace) noatlegend force
		capture noisily margins, atmeans at((p80) $WC $NTR=($min3($step3)$max3)) saving(temp2, replace) noatlegend force
		capture noisily combomarginsplot temp1 temp2 , labels("Low wage-coordination" "High wage-coordination" ) recast(line) recastci(rarea) ///
		file1opts(pstyle(p1)) file2opts(pstyle(p2)) plot1opts(lpattern("--")) ///
		 lplot1(mfcolor(white)) legend(colfirst) ///
		 title(" ") ytitle("Predicted exchange rate") xtitle("Resource rents per capita")
		capture noisily graph export "B_reer_wage_reg`x'_yhat.pdf", replace
		}
	}


// *--------+---------+---------+---------+---------+---------+---------+
// Inequality

global reer_ineq_reg1 "xtpcse c.DG_reer2 c.$IN##c.$NTR $controls_reer , pairwise correlation(ar1)"
global reer_ineq_reg2 "xtpcse c.DG_reer1 c.$IN##c.$NTR $controls_reer , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_ineq_reg`x'}
	estimates store B_reer_ineq_reg`x'_est
	if _rc == 0 { 
		// marginal effects
		capture noisily margins , dydx($NTR) atmeans at($IN=($min2($step2)$max2)) noatlegend force
		capture noisily marginsplot	, recast(line) recastci(rarea) yline(0) title("") ytitle("Marginal effect of natural resources on exchange rate") xtitle("Gini")
		capture noisily graph export "B_reer_ineq_reg`x'_margins.pdf", replace
		// predict y-hats
		capture noisily margins, atmeans at((p20) $IN $NTR=($min3($step3)$max3)) saving(temp1, replace) noatlegend force
		capture noisily margins, atmeans at((p80) $IN $NTR=($min3($step3)$max3)) saving(temp2, replace) noatlegend force
		capture noisily combomarginsplot temp1 temp2 , labels("Low inequality" "High inequality" ) recast(line) recastci(rarea) ///
		file1opts(pstyle(p1)) file2opts(pstyle(p2)) plot1opts(lpattern("--")) ///
		 lplot1(mfcolor(white)) legend(colfirst) ///
		 title(" ") ytitle("Predicted exchange rate") xtitle("Resource rents per capita")
		capture noisily graph export "B_reer_ineq_reg`x'_yhat.pdf", replace
		}
	}






// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure A
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

graph hbox BB_wdi1, over(A_id_name, sort(1))  ytitle("Variation of NTR (as % of GDP) across countries") title(" ", span) subtitle(" ")  
capture noisily graph export "A_descriptive1.pdf", replace






// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Table E
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach NTR of varlist BB_dunning2 BB_oil2 BB_wdi6 OC_41 OC_42 {

sum `NTR'
local min3 = round(r(min),10)
local max3 = round(r(max),10)
local step3 = (`max3' - `min3')/10

global exports_wage_reg1 "xtpcse c.DB_exports_clean5 c.$WC##c.`NTR' $controls_exports  , pairwise correlation(ar1)"
global exports_wage_reg2 "xtpcse c.DB_exports_clean6 c.$WC##c.`NTR' $controls_exports  , pairwise correlation(ar1)"
global exports_wage_reg3 "xtpcse c.DB_manu1 c.$WC##c.`NTR' $controls_exports  , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_wage_reg`x'} 
	}
}



// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Table F
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach NTR of varlist BB_dunning2 BB_oil2 BB_wdi6 OC_41 OC_42 {

sum `NTR'
local min3 = round(r(min),10)
local max3 = round(r(max),10)
local step3 = (`max3' - `min3')/10

global exports_ineq_reg1 "xtpcse c.DB_exports_clean5 c.$IN##c.`NTR' $controls_exports   , pairwise correlation(ar1)"
global exports_ineq_reg2 "xtpcse c.DB_exports_clean6 c.$IN##c.`NTR' $controls_exports   , pairwise correlation(ar1)"
global exports_ineq_reg3 "xtpcse c.DB_manu1 c.$IN##c.`NTR' $controls_exports   , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_ineq_reg`x'} 
	}
}


// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Table G
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach NTR of varlist BB_dunning2 BB_oil2 BB_wdi6 OC_41 OC_42 {

sum `NTR'
local min3 = round(r(min),10)
local max3 = round(r(max),10)
local step3 = (`max3' - `min3')/10
global wages_wage_reg1 "xtpcse c.DD_overall3 c.$WC##c.`NTR' $controls_wages   , pairwise correlation(ar1)"
global wages_wage_reg2 "xtpcse c.DD_rate1 c.$WC##c.`NTR' $controls_wages   , pairwise correlation(ar1)"
global wages_wage_reg3 "xtpcse c.DD_manu1 c.$WC##c.`NTR' $controls_wages   , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_wage_reg`x'} 
	}
}


// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Table H
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach NTR of varlist BB_dunning2 BB_oil2 BB_wdi6 OC_41 OC_42 {

sum `NTR'
local min3 = round(r(min),10)
local max3 = round(r(max),10)
local step3 = (`max3' - `min3')/10

global wages_ineq_reg1 "xtpcse c.DD_overall3 c.$IN##c.`NTR' $controls_wages   , pairwise correlation(ar1)"
global wages_ineq_reg2 "xtpcse c.DD_rate1 c.$IN##c.`NTR' $controls_wages   , pairwise correlation(ar1)"
global wages_ineq_reg3 "xtpcse c.DD_manu1 c.$IN##c.`NTR' $controls_wages   , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_ineq_reg`x'} 
	}
}


// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Table I
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach NTR of varlist BB_dunning2 BB_oil2 BB_wdi6 OC_41 OC_42 {

sum `NTR'
local min3 = round(r(min),10)
local max3 = round(r(max),10)
local step3 = (`max3' - `min3')/10

global reer_wage_reg1 "xtpcse c.DG_reer2 c.$WC##c.`NTR' $controls_reer   , pairwise correlation(ar1)"
global reer_wage_reg2 "xtpcse c.DG_reer1 c.$WC##c.`NTR' $controls_reer   , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_wage_reg`x'} 
	estimates store D_reer_wage_reg`x'_`i'_est
	}
}

        
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Table J
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach NTR of varlist BB_dunning2 BB_oil2 BB_wdi6 OC_41 OC_42 {

sum `NTR'
local min3 = round(r(min),10)
local max3 = round(r(max),10)
local step3 = (`max3' - `min3')/10
global reer_ineq_reg1 "xtpcse c.DG_reer2 c.$IN##c.`NTR' $controls_reer   , pairwise correlation(ar1)"
global reer_ineq_reg2 "xtpcse c.DG_reer1 c.$IN##c.`NTR' $controls_reer   , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_ineq_reg`x'} 
	}
}















// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables K 
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach WC of varlist CA_cent BA_hall1 {

capture xtpcse c.DB_exports_clean5 c.`WC'##c.$NTR $controls_exports , pairwise correlation(ar1)
estimates store E_wages_A1_`WC'

capture xtpcse c.DB_exports_clean6 c.`WC'##c.$NTR $controls_exports , pairwise correlation(ar1)
estimates store E_wages_A2_`WC'

capture xtpcse c.DB_manu1 c.`WC'##c.$NTR $controls_exports , pairwise correlation(ar1)
estimates store E_wages_A3_`WC'

} 


foreach IN of varlist CC_gini3 CC_sidd1 {

capture xtpcse c.DB_exports_clean5 c.`IN'##c.$NTR $controls_exports , pairwise correlation(ar1)
estimates store E_ineq_A1_`IN'

capture xtpcse c.DB_exports_clean6 c.`IN'##c.$NTR $controls_exports , pairwise correlation(ar1)
estimates store E_ineq_A2_`IN'

capture xtpcse c.DB_manu1 c.`IN'##c.$NTR $controls_exports , pairwise correlation(ar1)
estimates store E_ineq_A3_`IN'

}





// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables L
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach WC of varlist CA_cent BA_hall1 {

capture xtpcse c.DD_overall3 c.`WC'##c.$NTR $controls_wages , pairwise correlation(ar1)
estimates store E_wages_B1_`WC'

capture xtpcse c.DD_rate1 c.`WC'##c.$NTR $controls_wages , pairwise correlation(ar1)
estimates store E_wages_B2_`WC'

capture xtpcse c.DD_manu1 c.`WC'##c.$NTR $controls_wages , pairwise correlation(ar1)
estimates store E_wages_B3_`WC'

}


foreach IN of varlist CC_gini3 CC_sidd1 {

capture xtpcse c.DD_overall3 c.`IN'##c.$NTR  $controls_wages  , pairwise correlation(ar1)
estimates store E_ineq_B1_`IN'

capture xtpcse c.DD_rate1 c.`IN'##c.$NTR  $controls_wages , pairwise correlation(ar1)
estimates store E_ineq_B2_`IN'

capture xtpcse c.DD_manu1 c.`IN'##c.$NTR  $controls_wages , pairwise correlation(ar1)
estimates store E_ineq_B3_`IN'

}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables M
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach WC of varlist CA_cent BA_hall1 {

capture xtpcse c.DG_reer2 c.`WC'##c.$NTR $controls_reer , pairwise correlation(ar1)
estimates store E_wages_C1_`WC'

capture xtpcse c.DG_reer1 c.`WC'##c.$NTR $controls_reer , pairwise correlation(ar1)
estimates store E_wages_C2_`WC'

}


foreach IN of varlist CC_gini3 CC_sidd1 {

capture xtpcse c.DG_reer2 c.`IN'##c.$NTR $controls_reer  , pairwise correlation(ar1)
estimates store E_ineq_C1_`IN'

capture xtpcse c.DG_reer1 c.`IN'##c.$NTR $controls_reer , pairwise correlation(ar1)
estimates store E_ineq_C2_`IN'

}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables N
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach social of varlist OA_01 OA_04 OA_11 OA_14 OA_21 OA_24 CB_voc8 {

global exports_wage_reg1 "xtpcse c.DB_exports_clean5 c.$WC##c.$NTR $controls_exports `social' , pairwise correlation(ar1)"
global exports_wage_reg2 "xtpcse c.DB_exports_clean6 c.$WC##c.$NTR $controls_exports `social' , pairwise correlation(ar1)"
global exports_wage_reg3 "xtpcse c.DB_manu1 c.$WC##c.$NTR $controls_exports `social' , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_wage_reg`x'} 
		}
	}
	
	
	
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables O
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach social of varlist OA_01 OA_04 OA_11 OA_14 OA_21 OA_24 CB_voc8 {

global exports_ineq_reg1 "xtpcse c.DB_exports_clean5 c.$IN##c.$NTR $controls_exports  `social' , pairwise correlation(ar1)"
global exports_ineq_reg2 "xtpcse c.DB_exports_clean6 c.$IN##c.$NTR $controls_exports  `social' , pairwise correlation(ar1)"
global exports_ineq_reg3 "xtpcse c.DB_manu1 c.$IN##c.$NTR $controls_exports  `social' , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_ineq_reg`x'} 
		}
	}
	

// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables P
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach social of varlist OA_01 OA_04 OA_11 OA_14 OA_21 OA_24 CB_voc8 {

global wages_wage_reg1 "xtpcse c.DD_overall3 c.$WC##c.$NTR $controls_wages  `social' , pairwise correlation(ar1)"
global wages_wage_reg2 "xtpcse c.DD_rate1 c.$WC##c.$NTR $controls_wages  `social' , pairwise correlation(ar1)"
global wages_wage_reg3 "xtpcse c.DD_manu1 c.$WC##c.$NTR $controls_wages  `social' , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_wage_reg`x'} 
		}
	}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables Q
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach social of varlist OA_01 OA_04 OA_11 OA_14 OA_21 OA_24 CB_voc8 {

global wages_ineq_reg1 "xtpcse c.DD_overall3 c.$IN##c.$NTR $controls_wages  `social' , pairwise correlation(ar1)"
global wages_ineq_reg2 "xtpcse c.DD_rate1 c.$IN##c.$NTR $controls_wages  `social' , pairwise correlation(ar1)"
global wages_ineq_reg3 "xtpcse c.DD_manu1 c.$IN##c.$NTR $controls_wages  `social' , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_ineq_reg`x'} 
		}
	}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables R
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach social of varlist OA_01 OA_04 OA_11 OA_14 OA_21 OA_24 CB_voc8 {

global reer_wage_reg1 "xtpcse c.DG_reer2 c.$WC##c.$NTR $controls_reer  `social' , pairwise correlation(ar1)"
global reer_wage_reg2 "xtpcse c.DG_reer1 c.$WC##c.$NTR $controls_reer  `social' , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_wage_reg`x'} 
		}
	}
	
	

// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables S
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

foreach social of varlist OA_01 OA_04 OA_11 OA_14 OA_21 OA_24 CB_voc8 {

global reer_ineq_reg1 "xtpcse c.DG_reer2 c.$IN##c.$NTR $controls_reer  `social' , pairwise correlation(ar1)"
global reer_ineq_reg2 "xtpcse c.DG_reer1 c.$IN##c.$NTR $controls_reer  `social' , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_ineq_reg`x'} 
	}
}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables T
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+

// *--------+---------+---------+---------+---------+---------+---------+
// Wage-coordination

global exports_wage_reg1 "xtpcse c.DB_exports_clean5 c.$WC##c.$NTR $controls_exports if A_id_number != 14 , pairwise correlation(ar1)"
global exports_wage_reg2 "xtpcse c.DB_exports_clean6 c.$WC##c.$NTR $controls_exports if A_id_number != 14 , pairwise correlation(ar1)"
global exports_wage_reg3 "xtpcse c.DB_manu1 c.$WC##c.$NTR $controls_exports if A_id_number != 14 , pairwise correlation(ar1)"

forvalues x=1/1 {
	capture noisily ${exports_wage_reg`x'} 
	}

// *--------+---------+---------+---------+---------+---------+---------+
// Inequality

global exports_ineq_reg1 "xtpcse c.DB_exports_clean5 c.$IN##c.$NTR $controls_exports if A_id_number != 14 , pairwise correlation(ar1)"
global exports_ineq_reg2 "xtpcse c.DB_exports_clean6 c.$IN##c.$NTR $controls_exports if A_id_number != 14 , pairwise correlation(ar1)"
global exports_ineq_reg3 "xtpcse c.DB_manu1 c.$IN##c.$NTR $controls_exports if A_id_number != 14 , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_ineq_reg`x'} 
	}




// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables U
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+


// *--------+---------+---------+---------+---------+---------+---------+
// Wage coordination

global wages_wage_reg1 "xtpcse c.DD_overall3 c.$WC##c.$NTR $controls_wages if A_id_number != 14 , pairwise correlation(ar1)"
global wages_wage_reg2 "xtpcse c.DD_rate1 c.$WC##c.$NTR $controls_wages if A_id_number != 14 , pairwise correlation(ar1)"
global wages_wage_reg3 "xtpcse c.DD_manu1 c.$WC##c.$NTR $controls_wages if A_id_number != 14 , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_wage_reg`x'} 
	}


// *--------+---------+---------+---------+---------+---------+---------+
// Inequality

global wages_ineq_reg1 "xtpcse c.DD_overall3 c.$IN##c.$NTR $controls_wages if A_id_number != 14 , pairwise correlation(ar1)"
global wages_ineq_reg2 "xtpcse c.DD_rate1 c.$IN##c.$NTR $controls_wages if A_id_number != 14 , pairwise correlation(ar1)"
global wages_ineq_reg3 "xtpcse c.DD_manu1 c.$IN##c.$NTR $controls_wages if A_id_number != 14 , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${wages_ineq_reg`x'} 
	}


// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables V
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+


// *--------+---------+---------+---------+---------+---------+---------+
// Wage coordination

global reer_wage_reg1 "xtpcse c.DG_reer2 c.$WC##c.$NTR $controls_reer if A_id_number != 14 , pairwise correlation(ar1)"
global reer_wage_reg2 "xtpcse c.DG_reer1 c.$WC##c.$NTR $controls_reer if A_id_number != 14 , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_wage_reg`x'} 
	}


// *--------+---------+---------+---------+---------+---------+---------+
// Inequality

global reer_ineq_reg1 "xtpcse c.DG_reer2 c.$IN##c.$NTR $controls_reer if A_id_number != 14 , pairwise correlation(ar1)"
global reer_ineq_reg2 "xtpcse c.DG_reer1 c.$IN##c.$NTR $controls_reer if A_id_number != 14 , pairwise correlation(ar1)"

forvalues x=1/2 {
	capture noisily ${reer_ineq_reg`x'}
	}







// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables W & Figure B
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+


global exports_both_reg1 "xtpcse c.DB_exports_clean5 c.$WC##c.$NTR c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports_both_reg2 "xtpcse c.DB_exports_clean6 c.$WC##c.$NTR c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports_both_reg3 "xtpcse c.DB_manu1 c.$WC##c.$NTR c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports_both_reg`x'}
	estimates store exports_both_reg`x'_est
	if _rc == 0 { 

		// SUMMARY - marginal effects with NTR at mean
		
			estimates restore exports_both_reg`x'_est
			capture noisily margins , dydx($NTR) atmeans ///
			at((p10) $IN (p90) $WC) /// 
			at((p10) $IN (p10) $WC) /// 
			at((p90) $IN (p90) $WC) ///
			at((p90) $IN (p10) $WC) post
			
			test _b[1._at] = _b[2._at]
			test _b[1._at] = _b[3._at]
			test _b[1._at] = _b[4._at]
			test _b[2._at] = _b[3._at]
			test _b[2._at] = _b[4._at]
			test _b[3._at] = _b[4._at]
			 
			estimates restore exports_both_reg`x'_est
			capture noisily margins , dydx($NTR) atmeans ///
			at((p10) $IN (p90) $WC) /// 
			at((p10) $IN (p10) $WC) /// 
			at((p90) $IN (p90) $WC) ///
			at((p90) $IN (p10) $WC) noatlegend force
			 
			matrix t = r(table)
			
			local dist1_mean = t[1,1]
			local dist1_se = t[2,1]
			local dist2_mean = t[1,2]
			local dist2_se = t[2,2]
			local dist3_mean = t[1,3]
			local dist3_se = t[2,3]
			local dist4_mean = t[1,4]
			local dist4_se = t[2,4]
			
			// range_high
			if `dist1_mean' >= `dist2_mean' & `dist1_mean' >= `dist3_mean' & `dist1_mean' >= `dist4_mean'{
				local range_high = `dist1_mean' + 5*abs(`dist1_se')
			}
			if `dist2_mean' >= `dist1_mean' & `dist2_mean' >= `dist3_mean' & `dist2_mean' >= `dist4_mean'{
				local range_high = `dist2_mean' + 5*abs(`dist2_se')
			}
			if `dist3_mean' >= `dist1_mean' & `dist3_mean' >= `dist2_mean' & `dist3_mean' >= `dist4_mean'{
				local range_high = `dist3_mean' + 5*abs(`dist3_se')
			}
			if `dist4_mean' >= `dist1_mean' & `dist4_mean' >= `dist2_mean' & `dist4_mean' >= `dist3_mean'{
				local range_high = `dist4_mean' + 5*abs(`dist4_se')
			}
			
			// range_low
			if `dist1_mean' <= `dist2_mean' & `dist1_mean' <= `dist3_mean' & `dist1_mean' <= `dist4_mean'{
				local range_low = `dist1_mean' - 5*abs(`dist1_se')
			}
			if `dist2_mean' <= `dist1_mean' & `dist2_mean' <= `dist3_mean' & `dist2_mean' <= `dist4_mean'{
				local range_low = `dist2_mean' - 5*abs(`dist2_se')
			}
			if `dist3_mean' <= `dist1_mean' & `dist3_mean' <= `dist2_mean' & `dist3_mean' <= `dist4_mean'{
				local range_low = `dist3_mean' - 5*abs(`dist3_se')
			}
			if `dist4_mean' <= `dist1_mean' & `dist4_mean' <= `dist2_mean' & `dist4_mean' <= `dist3_mean'{
				local range_low = `dist4_mean' - 5*abs(`dist4_se')
			}
			

			graph twoway ///
			(function y=normalden(x,`dist1_mean',`dist1_se'), range(`range_low' `range_high') lw(medthick)) ///
			(function y=normalden(x,`dist2_mean',`dist2_se'), range(`range_low' `range_high') lw(medthick)) ///
			(function y=normalden(x,`dist3_mean',`dist3_se'), range(`range_low' `range_high') lw(medthick)) ///
			(function y=normalden(x,`dist4_mean',`dist4_se'), range(`range_low' `range_high') lw(medthick)), ///
			legend(cols(1) label(1 "high wage coordination, low inequality") ///
			label(2 "low wage coordination, low inequality") ///
			label(3 "high wage coordination, high inequality") ///
			label(4 "low wage coordination, high inequality")) ///
			yline(0) xline(0) ytitle("") xtitle("Marginal effect of natural resources on exports") ///
			title("Effect of natural resources on exports" "for different combinations of wage coordination and inequality")
			capture noisily graph export "G_exports_both_reg`x'_marg.pdf", replace
		
		
		}
	}







// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables X & Figure C
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+



global exports2_both_reg1 "xtpcse c.DB_exports_clean5 c.$WC##c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports2_both_reg2 "xtpcse c.DB_exports_clean6 c.$WC##c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"
global exports2_both_reg3 "xtpcse c.DB_manu1 c.$WC##c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)"

forvalues x=1/3 {
	capture noisily ${exports2_both_reg`x'}
	estimates store exports2_both_reg`x'_est
	if _rc == 0 { 

		// SUMMARY - marginal effects with NTR at mean
		
			estimates restore exports2_both_reg`x'_est
			capture noisily margins , dydx($NTR) atmeans ///
			at((p10) $IN (p90) $WC) /// 
			at((p10) $IN (p10) $WC) /// 
			at((p90) $IN (p90) $WC) ///
			at((p90) $IN (p10) $WC) post
			
			test _b[1._at] = _b[2._at]
			test _b[1._at] = _b[3._at]
			test _b[1._at] = _b[4._at]
			test _b[2._at] = _b[3._at]
			test _b[2._at] = _b[4._at]
			test _b[3._at] = _b[4._at]
			 
			estimates restore exports2_both_reg`x'_est
			capture noisily margins , dydx($NTR) atmeans ///
			at((p10) $IN (p90) $WC) /// 
			at((p10) $IN (p10) $WC) /// 
			at((p90) $IN (p90) $WC) ///
			at((p90) $IN (p10) $WC) noatlegend force
			 
			matrix t = r(table)
			
			local dist1_mean = t[1,1]
			local dist1_se = t[2,1]
			local dist2_mean = t[1,2]
			local dist2_se = t[2,2]
			local dist3_mean = t[1,3]
			local dist3_se = t[2,3]
			local dist4_mean = t[1,4]
			local dist4_se = t[2,4]
			
			// range_high
			if `dist1_mean' >= `dist2_mean' & `dist1_mean' >= `dist3_mean' & `dist1_mean' >= `dist4_mean'{
				local range_high = `dist1_mean' + 5*abs(`dist1_se')
			}
			if `dist2_mean' >= `dist1_mean' & `dist2_mean' >= `dist3_mean' & `dist2_mean' >= `dist4_mean'{
				local range_high = `dist2_mean' + 5*abs(`dist2_se')
			}
			if `dist3_mean' >= `dist1_mean' & `dist3_mean' >= `dist2_mean' & `dist3_mean' >= `dist4_mean'{
				local range_high = `dist3_mean' + 5*abs(`dist3_se')
			}
			if `dist4_mean' >= `dist1_mean' & `dist4_mean' >= `dist2_mean' & `dist4_mean' >= `dist3_mean'{
				local range_high = `dist4_mean' + 5*abs(`dist4_se')
			}
			
			// range_low
			if `dist1_mean' <= `dist2_mean' & `dist1_mean' <= `dist3_mean' & `dist1_mean' <= `dist4_mean'{
				local range_low = `dist1_mean' - 5*abs(`dist1_se')
			}
			if `dist2_mean' <= `dist1_mean' & `dist2_mean' <= `dist3_mean' & `dist2_mean' <= `dist4_mean'{
				local range_low = `dist2_mean' - 5*abs(`dist2_se')
			}
			if `dist3_mean' <= `dist1_mean' & `dist3_mean' <= `dist2_mean' & `dist3_mean' <= `dist4_mean'{
				local range_low = `dist3_mean' - 5*abs(`dist3_se')
			}
			if `dist4_mean' <= `dist1_mean' & `dist4_mean' <= `dist2_mean' & `dist4_mean' <= `dist3_mean'{
				local range_low = `dist4_mean' - 5*abs(`dist4_se')
			}
			

			graph twoway ///
			(function y=normalden(x,`dist1_mean',`dist1_se'), range(`range_low' `range_high') lw(medthick)) ///
			(function y=normalden(x,`dist2_mean',`dist2_se'), range(`range_low' `range_high') lw(medthick)) ///
			(function y=normalden(x,`dist3_mean',`dist3_se'), range(`range_low' `range_high') lw(medthick)) ///
			(function y=normalden(x,`dist4_mean',`dist4_se'), range(`range_low' `range_high') lw(medthick)), ///
			legend(cols(1) label(1 "high wage coordination, low inequality") ///
			label(2 "low wage coordination, low inequality") ///
			label(3 "high wage coordination, high inequality") ///
			label(4 "low wage coordination, high inequality")) ///
			yline(0) xline(0) ytitle("") xtitle("Marginal effect of natural resources on exports") ///
			title("Effect of natural resources on exports" "for different combinations of wage coordination and inequality")
			capture noisily graph export "G_exports_triple_reg`x'_marg.pdf", replace
		
		
		}
	}



// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Tables Y & Figure D
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+


// new globals without time-series operators
global controls_exports "DA_pc8 DG_regime DG_nominal1 DC_total1 DD_overall2 DE_total "
global controls_wages "CA_golden3 DA_pc8 DC_total1 DE_total DG_cpi5 country* "
global controls_reer "BA_cbi2 DA_relprod DA_pc8 DG_cpi5 DG_nominal1 DG_regime country* "

// recode
recode SY_system (2=1)
label define SY_systeml 0 "Presidential"  1 "Parliamentary"
label values SY_system SY_systeml  

local x = 0
// without controls
foreach var of varlist DB_exports_clean5 DB_exports_clean6 DB_manu1 {
	local x = `x' + 1
	
	lars `var' $NTR ///
	$WC ///
	$IN ///
	SY_pr ///
	SY_system ///
	SY_mdms ///
	SY_checks ///
	SY_cl  ///
	, a(lasso) graph ///
	legend(cols(2) ///
	label(1 "Non-Tax Revenue") ///
	label(2 "Wage Coordination") ///
	label(3 "Gini") ///
	label(4 "PR vs. Majoritatian ") ///
	label(5 "Presidential vs. Parliamentary ") ///
	label(6 "Mean District Magnitude") ///
	label(7 "Checks and Balances") ///
	label(8 "Closed vs. Open List") ///
	label(9 "GDP per capita growth") ///
	label(10 "Exchange rate regime") ///
	label(11 "Nominal Exchange Rate") ///
	label(12 "Unemployment Rate") ///
	label(13 "Mean income of wage employees") ///
	label(14 "Labor Productivity Index")) ///
	ytitle("") xtitle("Sum mod(Beta) / Max sum mod (Beta)") ///
	title("")
	
	capture noisily graph export "F_exports_reg`x'_nocontrols.pdf", replace
	}

// with controls
local x = 0
foreach var of varlist DB_exports_clean5 DB_exports_clean6 DB_manu1 {
	local x = `x' + 1
	
	lars `var' $NTR ///
	$WC ///
	$IN ///
	SY_pr ///
	SY_system ///
	SY_mdms ///
	SY_checks ///
	SY_cl $controls_exports ///
	, a(lasso) 
	}


// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+
// Figure E
// *--------+---------+---------+---------+---------+---------+---------+
// *--------+---------+---------+---------+---------+---------+---------+



xtset A_id_number A_year

xtpcse c.DB_exports_clean5 c.$WC##c.$IN##c.$NTR $controls_exports  , pairwise correlation(ar1)

generate sample = e(sample)
tab sample
drop if A_year <= 1984
drop if A_year >=2001

gen id = A_id_number
gen year = A_year
xtset id year

helm $WC $IN $NTR

pvar2 $NTR $IN $WC, lag(4) gmm monte 100 "decomp 30" 
capture noisily graph export "pvar.pdf", replace

restore







