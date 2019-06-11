/* 
****************
**********	

Title: est_msflood.do
By: Brenton Peterson
Date: May 22, 2016
Last Revised: May 31, 2016

Summary: Estimates models of Hoover vote share in 1928 as a function of the MS flood

**********
****************
*/



*Change working directory
cd "\MSFlood\MSFloodRep_Nov2016"


*Load + prep
use "reg_data.dta", clear
set more off
set scheme s1mono


*Define program for extracting results
do "reg_extract.ado"


*drop counties in which prot1 is too high to be reasonable
drop if prot1>140 & prot1!=.


*Difference outcome
gen r_diff = r_2party - vote_l1


*Correlation between relief and severity
corr pop_aff_pct aid_pct if treat==1


*Graph of correlation
twoway scatter pop_aff_pct aid_pct if treat==1, msymbol(Oh) ytitle("Population Affected by Flood, Pct", height(8)) xtitle("Population Receiving Aid, Pct", height(8)) legend(off) text(10 80 "Pearson's {it:r} = 0.93", size(medlarge)) ylabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%" 120 "120%", ang(horizontal)) xlabel(0 "0%" 20 "20%" 40 "40%" 60 "60%" 80 "80%" 100 "100%") yscale(range(0 120)) || lfit pop_aff_pct aid_pct if treat==1, yscale(range(0 120))

graph export "Figures\Fig2.png", replace width(3900)


*Establish cutpoints for flooding severity
	*South-only sample
	*Full sample version in est_SuppApp.do
keep if south==1
egen rank_severity = rank(pop_aff_pct) if treat==1, track

	*Our preferred approach
	*0 to 5%; 5-20%; 20-50%; 50%+
gen hjp1 = 0
gen hjp2 = 0
gen hjp3 = 0
gen hjp4 = 0
replace hjp1 = 1 if pop_aff_pct>0 & pop_aff_pct<5
replace hjp2 = 1 if pop_aff_pct>5 & pop_aff_pct<20
replace hjp3 = 1 if pop_aff_pct>20 & pop_aff_pct<50
replace hjp4 = 1 if pop_aff_pct>50 & pop_aff_pct<150
 
	*3 Quantiles
gen cut3_1 = 0
gen cut3_2 = 0
gen cut3_3 = 0
replace cut3_1 = 1 if rank_severity>0 & rank_severity<34
replace cut3_2 = 1 if rank_severity>33 & rank_severity<66
replace cut3_3 = 1 if rank_severity>65 & rank_severity<99

	*5 Quantiles
gen cut5_1 = 0
gen cut5_2 = 0
gen cut5_3 = 0
gen cut5_4 = 0
gen cut5_5 = 0
replace cut5_1 = 1 if rank_severity>0 & rank_severity<21
replace cut5_2 = 1 if rank_severity>20 & rank_severity<40
replace cut5_3 = 1 if rank_severity>39 & rank_severity<60
replace cut5_4 = 1 if rank_severity>59 & rank_severity<79
replace cut5_5 = 1 if rank_severity>78 & rank_severity<99


*Estimate models
	*Extract results
	*Tables are generated in est_SuppApp.do
	*Prep for Figure 3
	
	*Binary treatment category
reg r_diff treat black_1920 prot1
reg_extract 1 
rename b_ex bbin
rename se_ex sebin
	
	*Our preferred approach
reg r_diff hjp1 hjp2 hjp3 hjp4 black_1920 prot1
reg_extract 1 2 3 4
rename b_ex bhjp
rename se_ex sehjp

	*3 Quantiles
reg r_diff cut3_1 cut3_2 cut3_3  black_1920 prot1
reg_extract 1 2 3
rename b_ex b3
rename se_ex se3

	*5 Quantiles
reg r_diff cut5_1 cut5_2 cut5_3 cut5_4 cut5_5 black_1920 prot1
reg_extract 1 2 3 4 5 5
rename b_ex b5
rename se_ex se5


*calculate 95% CIs
foreach i in bin 3 5 hjp{
	gen ub`i' = b`i' + (1.96 * se`i')
	gen lb`i' = b`i' - (1.96 * se`i')
}


*Figure 3
gen id0 = 20 - _n in 1
gen id1 = 17 - _n in 1/4
gen id2 = 11 - _n in 1/3
gen id3 = 6 - _n in 1/5


twoway scatter id0 bbin in 1, msymbol(Oh) mcolor(gs2) || rcap lbbin ubbin id0 in 1, horizontal lcolor(gs8) || scatter id1 bhjp in 1/4, msymbol(Oh) mcolor(gs2) || rcap lbhjp ubhjp id1 in 1/4, horizontal lcolor(gs8) || scatter id2 b3 in 1/3, msymbol(Oh) mcolor(gs2) || rcap lb3 ub3 id2 in 1/3, horizontal lcolor(gs8) || scatter id3 b5 in 1/5, msymbol(Oh) mcolor(gs2) || rcap lb5 ub5 id3 in 1/5, horizontal lcolor(gs8) legend(off) xlabel(-20 "-20%" -10 "-10%" 0 "0%" 10 "10%", labsize(small)) ymlabel(1 "5" 2 "4" 3 "3" 4 "2" 5 "1" 8 "3" 9 "2" 10 "1" 13 "High" 14 "Med-High" 15 "Med-Low" 16 "Low" 19 "Binary Treatment", ang(horizontal) labsize(vsmall)) ylabel(3 "5 Quantiles" 9 "3 Quantiles" 14.5 `" "Subjective" "Cutpoints" "', ang(horizontal) labsize(small) labgap(12) noticks) xline(0) ytitle("Treatment Dummies") 

graph export "Figures\Fig3.png", replace width(3900)


*Cleanup
drop hjp* cut* bhjp sehjp b3 b5 se3 se5 bbin sebin ub* lb* rank_severity id1 id2 id3






/*
	*Synthetic Control Models

*Focus on southern counties
*Control group = non-flooded, non-contiguous (first- and second-order) counties - top 100 matched on percent black and percent protestant
*Report results of full (northern + southern) sample and other control group choices in appendix

*/

use "synth_data.dta", clear
set more off
set matsize 10000
set scheme s1mono


*Limit to south
keep if south==1
replace treat_id_s = . if year!=1928


*Variables to hold synth results
foreach i of numlist 1/1{
	gen rmspe`i' = .
	gen black_treat`i' = .
	gen black_synth`i' = .
	gen prot_treat`i' = .
	gen prot_synth`i' = .
	gen black_weight`i' = .
	gen prot_weight`i' = .

	foreach j of numlist 1896(4)1936{
		gen out_treat`i'_`j' = .
		gen out_synth`i'_`j' = .
	}
}



*Synthetic control model #1
	*Southern treated cases (n = 95)
	*Southern, non-contiguous counties as controls
	*Donor pool trimming by pre-treatment vote share

sort treat_id_s
local v "1"
foreach i of numlist 1/95{
	timer on 1
	display `i'
	sort treat_id_s
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits1[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort treat_id_s
	replace rmspe`v' = b[1,1] in `i'
	replace black_weight`v' = c[1,1] in `i'
	replace prot_weight`v' = c[2,2] in `i'
	replace black_treat`v' = d[1,1] in `i'
	replace prot_treat`v' = d[2,1] in `i'
	replace black_synth`v' = d[1,2] in `i'
	replace prot_synth`v' = d[2,2] in `i'

	foreach j of numlist 1/11{
		local y = 1892 + (`j'*4)	
		replace out_synth`v'_`y' = f[`j',1] in `i'
		replace out_treat`v'_`y' = g[`j',1] in `i'
	}

	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}




save "res_synth.dta", replace


*Divide cases by severity
gen hjp = 1 if pop_aff_pct>0 & pop_aff_pct<5 & year==1928
replace hjp = 2 if pop_aff_pct>5 & pop_aff_pct<20 & year==1928
replace hjp = 3 if pop_aff_pct>20 & pop_aff_pct<50 & year==1928
replace hjp = 4 if pop_aff_pct>50 & pop_aff_pct<150 & year==1928


*Treatment effect
gen diff1 = out_treat1_1928 - out_synth1_1928
bysort hjp: sum diff1


*Prep for time-series graphs
collapse (mean) out_treat* out_synth*
gen id = 1
reshape long out_treat1_ out_synth1_, i(id) j(year)
gen diff1 = out_treat1 - out_synth1


*Graph results
	*"Gaps" plot
set scheme s1mono
twoway line diff1 year, xline(1928, lwidth(thin)) yline(0, lwidth(thin)) ylabel(0 "0%" -10 "-10%" -20 "-20%", ang(horizontal) labsize(small)) yscale(range(-22 5)) ytitle("Difference, Treatment and Synthetic Control Units", size(medsmall)) xtitle("") xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936", labsize(small)) title("Estimated Differences Over Time", size(medsmall))

graph export "Figures\Fig4panel2.png", replace width(3900)


	*Trends plot
twoway line out_treat1_ year, lpattern(solid) || line out_synth1_ year, lpattern(dash) xline(1928, lwidth(thin)) xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal) labsize(small)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936", labsize(small)) title("Republican Vote Share," "Treated and Synthetic Control Units", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties")) ytitle("Republican Two-Party Vote Share", size(medsmall))

graph export "Figures\Fig4panel1.png", replace width(3900)





*The End







