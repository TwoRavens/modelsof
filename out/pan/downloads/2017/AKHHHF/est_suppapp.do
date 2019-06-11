/* 
****************
**********	

Title: est_suppapp.do
By: Brenton Peterson
Date: May 28, 2016
Last Revised: May 29, 2016

Summary: Performs additional analysis on the MS flood and Hoover's success in 1928

**********
****************
*/



*Change working directory
cd "\MSFlood\MSFloodRep_Nov2016"


*Load + prep
use "reg_data.dta", clear
set more off
set scheme s1mono
do "reg_extract.ado"


*drop counties in which prot1 is too high to be reasonable
drop if prot1>140 & prot1!=.


*Difference outcome
gen r_diff = r_2party - vote_l1



*Appendix Section 3
	*Distribution of aid
	*Table A1
reg aid_pct pop_aff_pct if treat==1
eststo m1

reg aid_pct pop_aff_pct vote_l1 black_1920 if treat==1
eststo m2

reg aid_pct pop_aff_pct if south==1 & treat==1
eststo m3

reg aid_pct pop_aff_pct vote_l1 black_1920 if south==1 & treat==1
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA1.tex", style(tab) booktabs ar2 nogap stats(N r2) cells(b(star fmt(3)) se(par fmt(2))) mtitles("Model 1" "Model 2" "Model 3" "Model 4" "what" "happens" "now") numbers nostar noconstant replace
eststo clear



*Appendix Section 4
	*Regression models
	*Estimating binary treatment effect
	*Estimating "contiguity" effects
	*Various cutpoints and bins


*Estimate binary treatment and contiguity effects
	*Table A2
	
reg r_diff treat contig_1 contig_2 if south==1
eststo m1

reg r_diff treat black_1920 prot1 if south==1
eststo m2

reg r_diff treat contig_1 contig_2 black_1920 prot1 if south==1
eststo m3

reg r_diff treat contig_1 contig_2
eststo m4

reg r_diff treat black_1920 prot1
eststo m5

reg r_diff treat contig_1 contig_2 black_1920 prot1
eststo m6

esttab m1 m2 m3 m4 m5 m6 using "Figures\TableA2.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear

	
*Rank severity of flooding 
egen rank_severity = rank(pop_aff_pct) if treat==1, track
egen rank_severity_s = rank(pop_aff_pct) if treat==1 & south==1, track
	

*Establish cutpoints
	*Southern sample first
	*Our preferred approach
	*0 to 5%; 5-20%; 20-50%; 50%+
gen hjp_s1 = 0
gen hjp_s2 = 0
gen hjp_s3 = 0
gen hjp_s4 = 0
replace hjp_s1 = 1 if pop_aff_pct>0 & pop_aff_pct<5
replace hjp_s2 = 1 if pop_aff_pct>5 & pop_aff_pct<20
replace hjp_s3 = 1 if pop_aff_pct>20 & pop_aff_pct<50
replace hjp_s4 = 1 if pop_aff_pct>50 & pop_aff_pct<150
 
	*3 Quantiles
gen cut_s3_1 = 0
gen cut_s3_2 = 0
gen cut_s3_3 = 0
replace cut_s3_1 = 1 if rank_severity_s>0 & rank_severity_s<34
replace cut_s3_2 = 1 if rank_severity_s>33 & rank_severity_s<66
replace cut_s3_3 = 1 if rank_severity_s>65 & rank_severity_s<99

	*4 Quantiles
gen cut_s4_1 = 0
gen cut_s4_2 = 0
gen cut_s4_3 = 0
gen cut_s4_4 = 0
replace cut_s4_1 = 1 if rank_severity_s>0 & rank_severity_s<26
replace cut_s4_2 = 1 if rank_severity_s>25 & rank_severity_s<50
replace cut_s4_3 = 1 if rank_severity_s>49 & rank_severity_s<75
replace cut_s4_4 = 1 if rank_severity_s>74 & rank_severity_s<99

	*5 Quantiles
gen cut_s5_1 = 0
gen cut_s5_2 = 0
gen cut_s5_3 = 0
gen cut_s5_4 = 0
gen cut_s5_5 = 0
replace cut_s5_1 = 1 if rank_severity_s>0 & rank_severity_s<21
replace cut_s5_2 = 1 if rank_severity_s>20 & rank_severity_s<40
replace cut_s5_3 = 1 if rank_severity_s>39 & rank_severity_s<60
replace cut_s5_4 = 1 if rank_severity_s>59 & rank_severity_s<79
replace cut_s5_5 = 1 if rank_severity_s>78 & rank_severity_s<99

	*8 Quantiles
gen cut_s8_1 = 0
gen cut_s8_2 = 0
gen cut_s8_3 = 0
gen cut_s8_4 = 0
gen cut_s8_5 = 0
gen cut_s8_6 = 0
gen cut_s8_7 = 0
gen cut_s8_8 = 0
replace cut_s8_1 = 1 if rank_severity_s>0 & rank_severity_s<13
replace cut_s8_2 = 1 if rank_severity_s>12 & rank_severity_s<26
replace cut_s8_3 = 1 if rank_severity_s>25 & rank_severity_s<38
replace cut_s8_4 = 1 if rank_severity_s>37 & rank_severity_s<50
replace cut_s8_5 = 1 if rank_severity_s>49 & rank_severity_s<62
replace cut_s8_6 = 1 if rank_severity_s>61 & rank_severity_s<75
replace cut_s8_7 = 1 if rank_severity_s>74 & rank_severity_s<87
replace cut_s8_8 = 1 if rank_severity_s>86 & rank_severity_s<99


*Establish cutpoints
	*Full Sample
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
replace cut3_1 = 1 if rank_severity>0 & rank_severity<45
replace cut3_2 = 1 if rank_severity>44 & rank_severity<90
replace cut3_3 = 1 if rank_severity>89 & rank_severity<134

	*4 Quantiles
gen cut4_1 = 0
gen cut4_2 = 0
gen cut4_3 = 0
gen cut4_4 = 0
replace cut4_1 = 1 if rank_severity>0 & rank_severity<34
replace cut4_2 = 1 if rank_severity>33 & rank_severity<68
replace cut4_3 = 1 if rank_severity>67 & rank_severity<101
replace cut4_4 = 1 if rank_severity>100 & rank_severity<134

	*5 Quantiles
gen cut5_1 = 0
gen cut5_2 = 0
gen cut5_3 = 0
gen cut5_4 = 0
gen cut5_5 = 0
replace cut5_1 = 1 if rank_severity>0 & rank_severity<28
replace cut5_2 = 1 if rank_severity>27 & rank_severity<54
replace cut5_3 = 1 if rank_severity>53 & rank_severity<81
replace cut5_4 = 1 if rank_severity>80 & rank_severity<107
replace cut5_5 = 1 if rank_severity>106 & rank_severity<134

	*8 Quantiles
gen cut8_1 = 0
gen cut8_2 = 0
gen cut8_3 = 0
gen cut8_4 = 0
gen cut8_5 = 0
gen cut8_6 = 0
gen cut8_7 = 0
gen cut8_8 = 0
replace cut8_1 = 1 if rank_severity>0 & rank_severity<18
replace cut8_2 = 1 if rank_severity>17 & rank_severity<34
replace cut8_3 = 1 if rank_severity>33 & rank_severity<51
replace cut8_4 = 1 if rank_severity>50 & rank_severity<68
replace cut8_5 = 1 if rank_severity>67 & rank_severity<84
replace cut8_6 = 1 if rank_severity>83 & rank_severity<101
replace cut8_7 = 1 if rank_severity>100 & rank_severity<117
replace cut8_8 = 1 if rank_severity>116 & rank_severity<134


*Regression Models
*Tables A3-A5

reg r_diff hjp_s1 hjp_s2 hjp_s3 hjp_s4 black_1920 prot1 if south==1
eststo m1

reg r_diff hjp1 hjp2 hjp3 hjp4 black_1920 prot1
eststo m2

reg r_diff cut_s3_1 cut_s3_2 cut_s3_3 black_1920 prot1 if south==1
eststo m3

reg r_diff cut3_1 cut3_2 cut3_3 black_1920 prot1
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA3.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear


reg r_diff cut_s4_1 cut_s4_2 cut_s4_3 cut_s4_4 black_1920 prot1 if south==1
eststo m1

reg r_diff cut4_1 cut4_2 cut4_3 cut4_4 black_1920 prot1
eststo m2

reg r_diff cut_s5_1 cut_s5_2 cut_s5_3 cut_s5_4 cut_s5_5 black_1920 prot1 if south==1
eststo m3

reg r_diff cut5_1 cut5_2 cut5_3 cut5_4 cut5_5 black_1920 prot1
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA4.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear


reg r_diff cut_s8_1 cut_s8_2 cut_s8_3 cut_s8_4 cut_s8_5 cut_s8_6 cut_s8_7 cut_s8_8 black_1920 prot1 if south==1
eststo m1

reg r_diff cut8_1 cut8_2 cut8_3 cut8_4 cut8_5 cut8_6 cut8_7 cut8_8 black_1920 prot1
eststo m2

reg r_diff treat pop_aff_pct black_1920 prot1 if south==1
eststo m3

reg r_diff treat pop_aff_pct black_1920 prot1
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA5.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear


*Plot substantive effects for continuous models
gen cont_id = _n in 1/125
gen pred_s = -13.51964 + (.0899106 * cont_id)
gen pred = -3.147652 + (-.0926873 * cont_id)
gen pred_blank = . in 1/125


*Figure A1
twoway scatter pred cont_id, msize(0.3) msymbol(O) mcolor(dkorange) || scatter pred_s cont_id, msize(0.3) msymbol(O) mcolor(edkblue) || scatter pred_blank cont_id, msize(1) msymbol(O) mcolor(dkorange) || scatter pred_blank cont_id, msize(1) msymbol(O) mcolor(edkblue) legend(order(3 "Full Sample" 4 "Southern Sample")) yline(0, lwidth(thin)) ytitle(Estimated Treatment Effect) xtitle("Treatment Severity (Percent of Population Affected)", height(6)) ylabel(, ang(horizontal)) yscale(range(-15 5)) xscale(range(0 125)) xlabel(0 20 40 60 80 100 120) title(Continuous Treatment Variable Models)

graph export "Figures\FigA1.png", replace width(3900)




*Appendix Section 5
	*Alternative Specifications
	*G&R model with severity and aid
	*Severity * Aid interaction
	*Polynomial models

*Generate interaction term
gen interaction = pop_aff_pct * aid_pct


*Southern Sample
reg r_diff pop_aff_pct aid_pct black_1920 prot1 if south==1
eststo m1

reg r_diff treat pop_aff_pct aid_pct black_1920 prot1 if south==1
eststo m2

reg r_diff pop_aff_pct aid_pct interaction black_1920 prot1 if south==1
eststo m3

reg r_diff treat pop_aff_pct aid_pct interaction black_1920 prot1 if south==1
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA6.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear


*Full Sample
reg r_diff pop_aff_pct aid_pct black_1920 prot1 
eststo m1

reg r_diff treat pop_aff_pct aid_pct black_1920 prot1
eststo m2

reg r_diff pop_aff_pct aid_pct interaction black_1920 prot1
eststo m3

reg r_diff treat pop_aff_pct aid_pct interaction black_1920 prot1
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA7.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear



*Create polynomials
gen popaff_sq = pop_aff_pct^2
gen popaff_cu = pop_aff_pct^3
gen black_sq = black_1920^2
gen black_cu = black_1920^3
gen prot_sq = prot1^2
gen prot_cu = prot1^3


reg r_diff pop_aff_pct popaff_sq black_1920 prot1
eststo m1

reg r_diff pop_aff_pct popaff_sq popaff_cu black_1920 black_sq prot1 prot_sq
eststo m2

reg r_diff pop_aff_pct popaff_sq popaff_cu black_1920 black_sq black_cu prot1 prot_sq prot_cu
eststo m3

reg r_diff treat pop_aff_pct popaff_sq popaff_cu black_1920 black_sq black_cu prot1 prot_sq prot_cu
eststo m4

esttab m1 m2 m3 m4 using "Figures\TableA8.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear


*Plot effects for polynomial models
gen pred_m2 = (-0.5362546 * cont_id) + (0.00911 * (cont_id^2)) + (-.0000337 * (cont_id^3))
gen pred_m3 = (-.6907576 * cont_id) + (.0142795 * (cont_id^2)) + (-.0000801 * (cont_id^3))
gen pred_m4 = -3.522494 + (-.6907576 * cont_id) + (.0142795 * (cont_id^2)) + (-.0000801 * (cont_id^3))


*Figure PolynomialReg
gen pred_blank = . in 1/125
twoway scatter pred_m2 cont_id, msize(0.3) msymbol(O) mcolor(dkorange) || scatter pred_m3 cont_id, msize(0.3) msymbol(O) mcolor(edkblue) || scatter pred_m4 cont_id, msize(0.3) msymbol(O) mcolor(dkgreen) || scatter pred_blank cont_id, msize(1.2) msymbol(O) mcolor(dkorange) || scatter pred_blank cont_id, msize(1.2) msymbol(O) mcolor(edkblue) || scatter pred_blank cont_id, msize(1.2) msymbol(O) mcolor(dkgreen) legend(order(4 "Model 2" 5 "Model 3" 6 "Model 4") cols(3) region(lwidth(none))) yline(0, lwidth(thin)) ytitle(Estimated Treatment Effect) xtitle("Treatment Severity (Percent of Population Affected)", height(6)) ylabel(, ang(horizontal)) xscale(range(0 125)) xlabel(0 20 40 60 80 100 120) title(Polynomial Regression -- Predicted Values, size(medium))

graph export "Figures\FigA2.png", replace width(3900)




*Appendix Section 6
	*Synthetic Control Models
	*Varied donor pools
use "suppapp_data.dta", clear
set more off
set matsize 10000
set scheme s1mono

replace treat_id_n = . if year!=1928
replace treat_id_s = . if year!=1928
replace synth_id = . if year!=1928


*Variables to hold synth results
foreach i of numlist 1/6{
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
	*Donor pool trimming by pre-treatment vote share

sort synth_id
local v "1"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
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
	
	sort synth_id
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





*Synthetic control model #2
	*Donor pool trimming by pct. black and protestant

sort synth_id
local v "2"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits2[`i']

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
	
	sort synth_id
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





*Synthetic control model #3
	*Donor pool trimming by pre-treatment vote share
	*500 units in donor pool

sort synth_id
local v "3"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits3[`i']

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
	
	sort synth_id
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





*Synthetic control model #4
	*Donor pool trimming by pct. black and protestant
	*500 units in donor pool

sort synth_id
local v "4"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits4[`i']

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
	
	sort synth_id
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




*Synthetic control model #5
	*Donor pool = all contiguous counties

sort synth_id
local v "5"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits5[`i']

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
	
	sort synth_id
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




*Synthetic control model #6
	*Donor pool = all non-treated, non-contiguous counties in flooded states

sort synth_id
local v "6"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits6[`i']

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
	
	sort synth_id
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




*Calculate differences over time
foreach i of numlist 1/6{
	foreach j of numlist 1896(4)1936{
		gen diff`i'_`j' = out_treat`i'_`j' - out_synth`i'_`j'
	}
}



*Save data
save "res_synth_suppapp.dta", replace


*Prep time-series graphs for southern sample
collapse (mean) diff* out_treat* out_synth*, by(south)
keep if south==1
gen id = 1
reshape long diff1_ diff2_ diff3_ diff4_ diff5_ diff6_ out_synth1_ out_synth2_ out_synth3_ out_synth4_ out_synth5_ out_synth6_ out_treat1_ out_treat2_ out_treat3_ out_treat4_ out_treat5_ out_treat6_, i(id) j(year)


*Graphs - southern sample

	*Donor pool 1
	*Trimmed on pre-treatment vote share
	*Donors = 100
twoway line out_treat1_ year, lcolor(gs2) || line out_synth1_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 1, Southern Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA3Panel1.png", replace width(3900)

twoway line diff1_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA3Panel2.png", replace width(3900)


	*Donor pool 2
	*Trimmed on percent black and protestant
	*Donors = 100
twoway line out_treat2_ year, lcolor(gs2) || line out_synth2_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 2, Southern Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA4Panel1.png", replace width(3900)

twoway line diff2_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA4Panel2.png", replace width(3900)


	*Donor pool 3
	*Trimmed on pre-treatment vote share
	*Donors = 500
twoway line out_treat3_ year, lcolor(gs2) || line out_synth3_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 3, Southern Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA5Panel1.png", replace width(3900)

twoway line diff3_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA5Panel2.png", replace width(3900)


	*Donor pool 4
	*Trimmed on percent black and protestant
	*Donors = 500
twoway line out_treat4_ year, lcolor(gs2) || line out_synth4_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 4, Southern Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA6Panel1.png", replace width(3900)

twoway line diff4_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA6Panel2.png", replace width(3900)


	*Donor pool 5
	*All contiguous counties in same region (N/S)
	*57 control counties in North; 86 in South
twoway line out_treat5_ year, lcolor(gs2) || line out_synth5_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 5, Southern Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA7Panel1.png", replace width(3900)

twoway line diff5_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA7Panel2.png", replace width(3900)


	*Donor pool 6
	*All non-treated, non-contiguous counties in flooded states in same region (N/S)
	*250 control counties in North; 138 in South
twoway line out_treat6_ year, lcolor(gs2) || line out_synth6_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 6, Southern Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA8Panel1.png", replace width(3900)

twoway line diff6_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA8Panel2.png", replace width(3900)






*Prep time-series graphs for full sample
use "res_synth_suppapp.dta", clear
collapse (mean) diff* out_treat* out_synth*
gen id = 1
reshape long diff1_ diff2_ diff3_ diff4_ diff5_ diff6_ out_synth1_ out_synth2_ out_synth3_ out_synth4_ out_synth5_ out_synth6_ out_treat1_ out_treat2_ out_treat3_ out_treat4_ out_treat5_ out_treat6_, i(id) j(year)



*Graphs - full, nationwide sample

	*Donor pool 1
	*Trimmed on pre-treatment vote share
	*Donors = 100
twoway line out_treat1_ year, lcolor(gs2) || line out_synth1_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 1, All Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA9Panel1.png", replace width(3900)

twoway line diff1_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA9Panel2.png", replace width(3900)


	*Donor pool 2
	*Trimmed on percent black and protestant
	*Donors = 100
twoway line out_treat2_ year, lcolor(gs2) || line out_synth2_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 2, All Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA10Panel1.png", replace width(3900)

twoway line diff2_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA10Panel2.png", replace width(3900)


	*Donor pool 3
	*Trimmed on pre-treatment vote share
	*Donors = 500
twoway line out_treat3_ year, lcolor(gs2) || line out_synth3_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 3, All Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA11Panel1.png", replace width(3900)

twoway line diff3_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA11Panel2.png", replace width(3900)


	*Donor pool 4
	*Trimmed on percent black and protestant
	*Donors = 500
twoway line out_treat4_ year, lcolor(gs2) || line out_synth4_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 4, All Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA12Panel1.png", replace width(3900)

twoway line diff4_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA12Panel2.png", replace width(3900)


	*Donor pool 5
	*All contiguous counties in same region (N/S)
	*57 control counties in North; 86 in South
twoway line out_treat5_ year, lcolor(gs2) || line out_synth5_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 5, All Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA13Panel1.png", replace width(3900)

twoway line diff5_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA13Panel2.png", replace width(3900)


	*Donor pool 6
	*All non-treated, non-contiguous counties in flooded states in same region (N/S)
	*250 control counties in North; 138 in South
twoway line out_treat6_ year, lcolor(gs2) || line out_synth6_ year, lcolor(gs9) lpattern(dash) xline(1928, lwidth(medthin)) scheme(s1mono) ytitle("Republican Vote Share") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") title("Donor Pool 6, All Cases", size(large)) subtitle("Vote Share, Treated and Synthetic Control Counties", size(medsmall)) legend(order(1 "Treated Counties" 2 "Synthetic Control Counties") region(lwidth(none)))

graph export "Figures\FigA14Panel1.png", replace width(3900)

twoway line diff6_ year, xline(1928, lwidth(medthin)) yline(0, lwidth(medthin)) scheme(s1mono) ytitle("Difference, Treated and Synthetic Control Groups") xtitle("") ylabel(-25 "-25%" -20 "20%" -15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") subtitle("Difference in Vote Share, Treated and Synthetic Control Counties", size(medsmall))

graph export "Figures\FigA14Panel2.png", replace width(3900)






*Graphs - Heterogeneous Treatment Effects
use "ResultsData\res_synth_suppapp.dta", clear
	

twoway scatter diff1_1928 pop_aff_pct if south==1, msymbol(Oh) || lowess diff1_1928 pop_aff_pct if south==1, ytick(none) ymlabel(-60 "-60%" -40 "-40%" -20 "-20%" 0 "0%" 20 "20%", ang(horizontal)) title("Southern Sample") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(none)
graph save "Figures\FigA15Panel1.gph", replace

twoway scatter diff2_1928 pop_aff_pct if south==1, msymbol(Oh) || lowess diff2_1928 pop_aff_pct if south==1, ytick(none) ymlabel(-60 "-60%" -40 "-40%" -20 "-20%" 0 "0%" 20 "20%", ang(horizontal)) title("") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(none)
graph save "Figures\FigA15Panel3.gph", replace

twoway scatter diff3_1928 pop_aff_pct if south==1, msymbol(Oh) || lowess diff3_1928 pop_aff_pct if south==1, ytick(none) ymlabel(-60 "-60%" -40 "-40%" -20 "-20%" 0 "0%" 20 "20%", ang(horizontal)) title("") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(none)
graph save "Figures\FigA15Panel5.gph", replace

twoway scatter diff4_1928 pop_aff_pct if south==1, msymbol(Oh) || lowess diff4_1928 pop_aff_pct if south==1, ytick(none) ymlabel(-60 "-60%" -40 "-40%" -20 "-20%" 0 "0%" 20 "20%", ang(horizontal)) title("") xtitle("") yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(none) xlabel(0 "0%" 50 "50%" 100 "100%")
graph save "Figures\FigA15Panel7.gph", replace

twoway scatter diff1_1928 pop_aff_pct, msymbol(Oh) || lowess diff1_1928 pop_aff_pct, ytitle("") title("Full Sample") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(-20 "1", ang(horizontal) labgap(8) labsize(large) noticks) yscale(alt) 
graph save "Figures\FigA15Panel2.gph", replace

twoway scatter diff2_1928 pop_aff_pct, msymbol(Oh) || lowess diff2_1928 pop_aff_pct, ytitle("") title("") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(-20 "2", ang(horizontal) labgap(8) labsize(large) noticks) yscale(alt) 
graph save "Figures\FigA15Panel4.gph", replace	
	
twoway scatter diff3_1928 pop_aff_pct, msymbol(Oh) || lowess diff3_1928 pop_aff_pct, ytitle("") title("") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(-20 "3", ang(horizontal) labgap(8) labsize(large) noticks) yscale(alt) 
graph save "Figures\FigA15Panel6.gph", replace

twoway scatter diff4_1928 pop_aff_pct, msymbol(Oh) || lowess diff4_1928 pop_aff_pct, ytitle("") title("") xtitle("") xlabel(none) xtick(none) yline(0, lstyle(dot) lwidth(thin)) yscale(range(-65 22)) legend(off) ylabel(-20 "4", ang(horizontal) labgap(8) labsize(large) noticks) yscale(alt) xlabel(0 "0%" 50 "50%" 100 "100%")
graph save "Figures\FigA15Panel8.gph", replace


graph combine "Figures\FigA15Panel1.gph" "Figures\FigA15Panel2.gph" "Figures\FigA15Panel3.gph" "Figures\FigA15Panel4.gph" "Figures\FigA15Panel5.gph" "Figures\FigA15Panel6.gph" "Figures\FigA15Panel7.gph" "Figures\FigA15Panel8", cols(2) ysize(9) xsize(7) b1title("Flood Severity (Pct. Affected)") l1title("Unit-specific Treatment Effects") r1title("Donor Pools", orientation(rvertical)) 

graph export "Figures\FigA15.png", replace width(3900)











*Appendix Section 8
	*Turnout Effects
use "synth_data.dta", clear
set scheme s1mono


*Turnout in southern sample
keep if south == 1
collapse (mean) p_turnout, by(treat year)

	
twoway line p_turnout year if  treat == 1 || line p_turnout year if  treat == 0, xline(1928, lwidth(vthin)) lpattern(dash) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%" 60 "60%", ang(horizontal)) ytitle("Voter Turnout") legend(order(1 "Treated Counties" 2 "Control Counties") region(lwidth(none))) title("Southern Sample", size(medsmall))
	
graph export "Figures\FigA17Panel1.png", replace width(3900)


*Turnout in full sample
use "synth_data.dta", clear
collapse (mean) p_turnout, by(treat year)

	
twoway line p_turnout year if  treat == 1 || line p_turnout year if  treat == 0, xline(1928, lwidth(vthin)) lpattern(dash) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%" 60 "60%" 70 "70%" 80 "80%", ang(horizontal)) ytitle("Voter Turnout") legend(order(1 "Treated Counties" 2 "Control Counties") region(lwidth(none))) title("Full Sample", size(medsmall))
	
graph export "Figures\FigA17Panel2.png", replace width(3900)
	
	
	
	
	
*The End



