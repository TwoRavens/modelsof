



clear
clear all
clear matrix
set mem 200m
set more off, permanently
set maxvar 15000
set matsize 10000
set emptycells drop, permanently


//global dir "..." // set directory

global datadir2 "$dir/Data" 
global main "$datadir2/main"
global temp "$datadir2/temp"

global plots1 "$dir/Output/plots/plots1"
global tbls1 "$dir/Output/tables/tables1"
global plots2 "$dir/Output/plots/plots2"
global tbls2 "$dir/Output/tables/tables2"
global tbls3 "$dir/Output/tables/lrfu"



global Ado "$dir/Code/ado files"


capture program drop fanreg
do "$Ado/fanreg.ado"

cd "$datadir2/temp"

ssc install unique
ssc install ivreg2
ssc install ranktest 
 

findit cgmwildboot
findit geodist



***********************************
* Table of contents - 
***********************************

*Table L2
*Table 1, N1
*Table K1
*Table K4
*Table C1,C2,C3
*Table K3
*Table 7
*Figure 4 (PanelA)
*Table H1
*Table I1 
*Figure D1
*Figure D2
*Table L1
*Figure 7
*Figure 5
*Table J7
*Figure 4 (Panel B)
*Table 6,J1
*Figure 6
*Figure J4
*Figure J3
*Figure J8
*Table J6
*Table J3
*Figure J1
*Table G9
*Figure J5
*Table J2
*Table J4
*Figure J2
*Table G1
*Table G2
*Table G3
*Table G4
*Table G5
*Table G6
*Table G7 
*Table G8
*Table G10
*Table E10
*Table C4
*Table E5
*Table D2,D3,D4
*Table D5
*Table E2 
*Table K2
*Figure F1
*Table M2
*Table M3
*Table F10, F11, F12 
*Table F13
*Table F14
*Table F3, F4
*Table F5
*Table F6 
*Table F7 
*Table F8 
*Figure F2
*Table F1
*Table F2
*Figure M1
*Table E1,E3,E4,E12
*Table E6,E7,E8,E9 
*Table 2,3,4
*Table F9
*Table 5
*Table D1
*Table E11,13
*Table E14,E15
*Table J5



******************************************************
* List of Tables and Figures not created using Stata
******************************************************

*Figure 1 
*Figure 2
*Figure 3
*Figure A.1 
*Figure N1
*Figure N2
*Figure N3

****************
* Table L.2
****************

use "$main/MS1MS2_pooled.dta", clear 

drop if MS !=2
keep oafid treatMS1MS2
count
collapse treatMS1MS2, by(oafid)
count
rename treatMS1MS2 treat13
save "$temp/temp_treat.dta", replace


use "$main/baseline.dta", clear

replace delta = 1 - delta

keep oafid logtotcons_base logtotcons_base ///
	 male num_adults num_schoolchildren finished_primary finished_secondary cropland num_rooms ///
	schoolfees totcons_base logpercapcons_base total_cash_savings_base total_cash_savings_trimmed ///
	has_savings_acct  taken_bank_loan taken_informal_loan liquidWealth wagepay businessprofitmonth ///
	price_avg_diff_pct price_expect_diff_pct harvest2011 netrevenue2011 netseller2011 autarkic2011 maizelostpct2011 ///
	harvest2012  correct_interest digit_recall maizegiver delta	treatment
rename * *_base
rename oafid_base oafid
rename *base_base *base
rename treatment_base treatment2012

gen treat12 = (treatment2012=="T1" | treatment2012=="T2")
label variable treat12 "Treatment 2012"
replace treat12=. if treatment2012==""

merge 1:1 oafid using "$temp/temp_treat.dta", generate(merge_base) 

drop if merge_base ==2
gen in_sample_Y2 = (merge_base ==3)
gen newin13=(merge_base==2)
gen attrit13=(merge_base==1)

local vars treat12 male_base num_adults_base num_schoolchildren_base finished_primary_base finished_secondary_base cropland_base num_rooms_base ///
	schoolfees_base totcons_base logpercapcons_base total_cash_savings_base total_cash_savings_trimmed_base ///
	has_savings_acct_base  taken_bank_loan_base taken_informal_loan_base liquidWealth_base wagepay_base businessprofitmonth_base ///
	price_avg_diff_pct_base price_expect_diff_pct_base harvest2011_base netrevenue2011_base netseller2011_base autarkic2011_base maizelostpct2011_base ///
	harvest2012_base  correct_interest_base digit_recall_base maizegiver_base delta_base
	
label var num_schoolchildren_base "Children in school"
label var finished_primary_base "Finished primary school"
label var finished_secondary_base "Finished secondary school"
label var num_rooms_base "Number of rooms in household"
replace schoolfees_base = schoolfees_base*1000
label var  schoolfees_base "Total school fees"
label var totcons_base  "Average monthly consumption (Ksh)"
label var logpercapcons_base "Average monthly consumption/capita (log)”
label var liquidWealth_base "Liquid wealth (Ksh)"
label var netrevenue2011_base "Net revenue 2011 (Ksh)"
label var total_cash_savings_base "Total cash savings (Ksh)"

	
local numvars : word count `vars'
tokenize `vars'
forvalues i = 1/`numvars' {
	 ttest ``i'', by(in_sample_Y2) 
	mat b = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))
	if `i'==1 {
		mat d = b
		}
		else {
		mat d = d\b  
		}
	}
mat rownames d = `vars'
frmttable using "$tbls2/sample_selection_13", statmat(d) replace va tex fra ///
	ctitles("Baseline characteristic","Non-Returner","Returner","Obs","Non-Return - Return"\"","", "", "", "\ital{sd}", "\ital{p-val}") ///
	multicol(1,5,2) sdec(2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 	\ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2  \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 )
	




****************
* Table 1, N.1
****************

label var num_schoolchildren_base "Children in school"
label var finished_primary_base "Finished primary school"
label var finished_secondary_base "Finished secondary school"
label var num_rooms_base "Number of rooms in household"
replace schoolfees_base = schoolfees_base*1000
label var  schoolfees_base "Total school fees"
label var totcons_base  "Average monthly consumption (Ksh)"
label var logpercapcons_base "Average monthly consumption/capita (log)”
label var liquidWealth_base "Liquid wealth (Ksh)"
label var netrevenue2011_base "Net revenue 2011 (Ksh)"
label var total_cash_savings_base "Total cash savings (Ksh)"


local vars 	 male_base num_adults_base num_schoolchildren_base finished_primary_base finished_secondary_base cropland_base num_rooms_base ///
	schoolfees_base totcons_base logpercapcons_base total_cash_savings_base total_cash_savings_trimmed_base ///
	has_savings_acct_base  taken_bank_loan_base taken_informal_loan_base liquidWealth_base wagepay_base businessprofitmonth_base ///
	price_avg_diff_pct_base price_expect_diff_pct_base harvest2011_base netrevenue2011_base netseller2011_base autarkic2011_base maizelostpct2011_base ///
	harvest2012_base  correct_interest_base digit_recall_base maizegiver_base 	

preserve
drop if newin13==1

local numvars : word count `vars'
tokenize `vars'
forvalues i = 1/`numvars' {
	qui ttest ``i'', by(treat12) 
	mat b = (r(mu_2),r(mu_1),r(N_1)+r(N_2), (r(mu_2)-r(mu_1))/r(sd_1),r(p))
	if `i'==1 {
		mat d = b
		}
		else {
		mat d = d\b  
		}
	}
mat rownames d = `vars'
frmttable using "$tbls2/summstat_12", statmat(d) replace va tex fra ///
	ctitles("Baseline characteristic","Treat","Control","Obs","T - C"\"","", "", "", "\ital{std diff}", "\ital{p-val}") ///
	multicol(1,5,2) sdec(2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 	\ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2  \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 )


replace schoolfees_base = schoolfees_base/1000
	
restore

	
	

****************
* Table K.1
****************

use "$main/baseline", clear
label var price_expect_diff_pct "Expect $\%\Delta$ price Sep12-Jun13"
//merge n:1 site using "`tomerge'"
label var harvest2011 "2011 LR harvest (bags)"
label var num_schoolchildren "Children in school"
label var finished_primary "Finished primary school"
label var finished_secondary "Finished secondary school"
label var num_rooms "Number of rooms in household"
replace schoolfees = schoolfees*1000
label var  schoolfees "Total school fees"
label var totcons_base  "Average monthly consumption (Ksh)"
label var logpercapcons_base "Average monthly consumption/capita (log)"
label var liquidWealth "Liquid wealth (Ksh)"
label var netrevenue2011 "Net revenue 2011 (Ksh)"
label var total_cash_savings_base "Total cash savings (Ksh)"


local vars  male num_adults num_schoolchildren finished_primary finished_secondary cropland num_rooms ///
	schoolfees totcons_base logpercapcons_base total_cash_savings_base total_cash_savings_trimmed ///
	has_savings_acct  taken_bank_loan taken_informal_loan liquidWealth wagepay businessprofitmonth ///
	price_avg_diff_pct  harvest2011 netrevenue2011 netseller2011 autarkic2011 maizelostpct2011 ///
	harvest2012  correct_interest digit_recall maizegiver delta	
local numvars : word count `vars'
tokenize `vars'
forvalues i = 1/`numvars' {
	qui ttest ``i'', by(hi) 
	loc obs = r(N_1) + r(N_2)
	mat b1 = (r(mu_2),r(mu_1),`obs', (r(mu_2)-r(mu_1))/r(sd_1))
	reg ``i'' hi, cl(site)
	mat b2 = (2 * ttail(e(df_r), abs(_b[hi]/_se[hi])))
	mat b = (b1, b2)
	if `i'==1 {
		mat d = b
		}
		else {
		mat d = d\b  
		}
	}
mat rownames d = `vars'
frmttable using "$tbls1/summstat_treatintensity", statmat(d) replace va tex fra ///
	ctitles("","High","Low","Obs","Hi-Low","" \ "", "", "", "", "\ital{std diff}",  "\ital{p-val}") ///
	multicol(1,5,2) sdec(2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 	\ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2  \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 )

***************************
* Table K.4
***************************

use "$main/MS1MS2_pooled.dta", clear 
label var hi "High"

sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

label var treatMS1MS2hi "Treat*High"

gen cash_transfers = total_amt_loaned
replace cash_transfers = 0 if lentcash_hhold == 0 

foreach x in maizegive cash_transfers {

reg `x' treatMS1MS2 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(groupnum)
qui summ `x' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
est sto reg1_`x'

reg `x' treatMS1MS2 hi treatMS1MS2hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc) 
qui summ `x' if treatMS1MS2 ==0 & hi == 0
estadd sca mdv = r(mean)
est sto reg2_`x'

}

esttab reg* using "$tbls2/p_transfers.tex", keep(treatMS1MS2 hi treatMS1MS2hi) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	nomtitle mgroups("\multicolumn{2}{c}{Maize Given} & \multicolumn{2}{c}{Cash Given}   \\ \cline{2-3} \cline{4-5}  ", pattern(1 0 1 0))

est drop reg*




***************************
* Table C.1, C.2, C.3
***************************

foreach x in liquidWealth price_expect_diff_pct {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_t =. if qnt==1 | qnt == 200 
drop qnt
}

foreach x in num_schoolchildren {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_t =. if qnt == 100 
drop qnt
}

cap est drop reg*
loc vars delta_base num_schoolchildren_t liquidWealth_t  pctmaizesoldearly2011 price_expect_diff_pct_t
foreach var of loc vars {

	cap drop interact main
	qui summ `var'
	gen main = (`var' - `r(mean)')/r(sd)
	qui summ main, det
	loc r10 = r(p10)
	loc r90 = r(p90) 
	gen interact = treatMS1MS2*main

	areg takeup_loan main if MS==1 & treatMS1MS2 == 1 & round == 1,  a(strata_group) cl(groupnum)
	qui summ takeup_loan if  MS==1 & treatMS1MS2 == 1 & round == 1
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_1

	areg inventory_trim treatMS1MS2 main interact interviewdate round2 round3 if MS==1,  a(strata_group) cl(groupnum)
	qui summ inventory_trim if  treatMS1MS2 == 0
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_2
	qui lincom treatMS1MS2 + `r10'*interact
	estadd sca pct10 = r(estimate)
	estadd sca pct10se = r(se)
	qui lincom treatMS1MS2 + `r90'*interact
	estadd sca pct90 = r(estimate)
	estadd sca pct90se = r(se)

	areg netrevenue_trim treatMS1MS2 main interact interviewdate round2 round3 if MS==1,  a(strata_group) cl(groupnum)
	qui summ netrevenue_trim if  treatMS1MS2 == 0
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_3
	qui lincom treatMS1MS2 + `r10'*interact
	estadd sca pct10 = r(estimate)
	estadd sca pct10se = r(se)
	qui lincom treatMS1MS2 + `r90'*interact
	estadd sca pct90 = r(estimate)
	estadd sca pct90se = r(se)

	areg logtotcons_trim treatMS1MS2 main interact interviewdate round2 round3 if MS==1, a(strata_group)  cl(groupnum)
	qui summ logtotcons_trim if  treatMS1MS2 == 0
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_4
	qui lincom treatMS1MS2 + `r10'*interact
	estadd sca pct10 = r(estimate)
	estadd sca pct10se = r(se)
	qui lincom treatMS1MS2 + `r90'*interact
	estadd sca pct90 = r(estimate)
	estadd sca pct90se = r(se)

}


lab var treatMS1MS2 "Treat"
lab var main "Main"
lab var interact "Interact"

esttab rdelta_base_1 rdelta_base_2 rdelta_base_3 rdelta_base_4 rnum_schoolchildren_t_1 rnum_schoolchildren_t_2 rnum_schoolchildren_t_3 rnum_schoolchildren_t_4 ///
using "$tbls1/het_temp1.tex", drop(interviewdate round* _cons) ///
	replace b(%10.3f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared") ///
	order(treatMS1MS2 main interact) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Takeup" "Inv" "Rev"  "Cons" "Takeup" "Inv" "Rev" "Cons" ) ///
	mgroups("\multicolumn{4}{c}{Impatience} & \multicolumn{4}{c}{Children}  \\ \cline{2-5} \cline{6-9}", pattern(1 0 1 0))


esttab rliquidWealth_t_1 rliquidWealth_t_2 rliquidWealth_t_3 rliquidWealth_t_4  ///
rpctmaizesoldearly2011_1 rpctmaizesoldearly2011_2 rpctmaizesoldearly2011_3 rpctmaizesoldearly2011_4 ///
using "$tbls1/het_temp2.tex", drop(interviewdate round* _cons) ///
	replace b(%10.3f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared") ///
	order(treatMS1MS2 main interact) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Takeup" "Inv" "Rev"  "Cons" "Takeup" "Inv" "Rev" "Cons" ) ///
	mgroups("\multicolumn{4}{c}{Wealth} & \multicolumn{4}{c}{Early Sales} \\ \cline{2-5} \cline{6-9}  ", pattern(1 0 1 0))


esttab rprice_expect_diff_pct_t_1 rprice_expect_diff_pct_t_2 rprice_expect_diff_pct_t_3 rprice_expect_diff_pct_t_4 ///
using "$tbls1/het_temp3.tex", drop(interviewdate round* _cons) ///
	replace b(%10.3f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared") ///
	order(treatMS1MS2 main interact) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Takeup" "Inv" "Rev" "Cons"  ) ///
	mgroups("  \multicolumn{4}{c}{Price Expect} \\ \cline{2-5} ", pattern(1 0 1 0))

	
	
	
*******************************
*  Table K.3
*******************************

preserve
drop if treatMS1MS2 == .
gen id = oafid
replace id = fr_id if MS == 2
duplicates drop MS id, force

replace takeup_loan = 0 if loan_size==0 
replace takeup_loan = 1 if loan_size!=. & loan_size>0 

gen loan_size_con = loan_size
replace loan_size_con = . if loan_size == 0 & takeup_loan == 0 

gen loan_size_uncon = loan_size
replace loan_size_uncon = 0 if takeup_loan == 0

	qui ttest takeup_loan if treat12 == 1, by(hi) 
	mat b1 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))
	
	qui ttest loan_size_con if treat12 == 1, by(hi) 
	mat b2 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	qui ttest loan_size_uncon if treat12 == 1, by(hi) 
	mat b3 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	qui ttest takeup_loan if treat13 == 1, by(hi) 
	mat b4 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	qui ttest loan_size_con if treat13 == 1, by(hi) 
	mat b5 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	qui ttest loan_size_uncon if treat13 == 1, by(hi) 
	mat b6 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	qui ttest takeup_loan if treatMS1MS2==1, by(hi) 
	mat b7 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	qui ttest loan_size_con if treatMS1MS2==1, by(hi) 
	mat b8 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))	

	qui ttest loan_size_uncon if treatMS1MS2==1, by(hi) 
	mat b9 = (r(mu_1),r(mu_2),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1),r(p))

	mat d = (b1,b2,b3)\(b4,b5,b6)\(b7,b8,b9)
	mat d1 = (b1,b2)\(b4,b5)\(b7,b8)
	mat d2 = (b3)\(b6)\(b9)
	
mat rownames d = "Year 1" "Year 2" "Pooled"
frmttable using "$tbls2/intensity_takeup", statmat(d) replace va tex fra ///
	ctitles("" "\underline{\bf{Loan Take-up}}","","","","", "\underline{\bf{Loan Size (Cond)}}", "","","","", "\underline{\bf{Loan Size (Uncond)}}", "","","","",	\"","Low","High","N","Diff", "Diff","Low","High","N", "Diff", "Diff","Low","High","N", "Diff", "Diff" \ "", "Mean", "Mean" , "Obs", "SD","p-val","Mean", "Mean" , "Obs", "SD","p-val","Mean", "Mean" , "Obs", "SD","p-val") ///
	sdec(2, 2, 0, 2, 2, 2, 2, 0, 2, 2, 2, 2, 0, 2, 2) multicol(1,2,5; 1,7,5; 1,12,5) vlines(010000100001000000)

restore

*******************************
*  Table 7
*******************************

label var hi "High" 

gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}

foreach y in inventory_trim netsales_trim purchaseprice_trim salesprice_trim netrevenue_trim logtotcons_trim {
cap est drop reg*
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 ,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate  Y2round2 Y2round3,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

esttab reg*`y' using "$tbls2/p_intens_`y'.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" "pc p-val T+TH=0") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled")
}



cap drop z z_hi z_1 z_2 z_3 

est drop reg*

foreach y in inventory_trim netrevenue_trim logtotcons_trim {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

cgmwildboot `y' z hi z_hi  interviewdate Y1round2 Y1round3, cl(subloc) bootcluster(subloc)  reps(1000) seed(894561) // manually add p-vals below from this regression
reg `y' z hi z_hi interviewdate Y1round2 Y1round3 ,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
foreach j in z hi z_hi {
	local pval_`j' = (2 * ttail(e(df_r), abs(_b[`j']/_se[`j'])))
	estadd sca pval_`j' = `pval_`j''
	}
if "`y'"== "inventory_trim" {
	estadd sca pval_z_wb =  0.0
	estadd sca pval_hi_wb = 0.74
	estadd sca pval_z_hi_wb = 0.198
	}
if "`y'"== "netrevenue_trim" {
	estadd sca pval_z_wb =  0.062
	estadd sca pval_hi_wb = 0.336
	estadd sca pval_z_hi_wb = 0.074
	}
if "`y'"== "logtotcons_trim" {
	estadd sca pval_z_wb =  0.768
	estadd sca pval_hi_wb = 0.96
	estadd sca pval_z_hi_wb = 0.796
	}
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

cgmwildboot `y' z hi z_hi  interviewdate Y2round2 Y2round3, cl(subloc) bootcluster(subloc)  reps(1000) seed(894561) // manually add p-vals below from this regression
reg `y' z hi z_hi interviewdate  Y2round2 Y2round3,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
foreach j in z hi z_hi {
	local pval_`j' = (2 * ttail(e(df_r), abs(_b[`j']/_se[`j'])))
	estadd sca pval_`j' = `pval_`j''
	}
if "`y'"== "inventory_trim" {
	estadd sca pval_z_wb =  0.0
	estadd sca pval_hi_wb = 0.9
	estadd sca pval_z_hi_wb = 0.786
	}
if "`y'"== "netrevenue_trim" {
	estadd sca pval_z_wb =  0.12
	estadd sca pval_hi_wb = 0.818
	estadd sca pval_z_hi_wb = 0.508
	}
if "`y'"== "logtotcons_trim" {
	estadd sca pval_z_wb =  0.226
	estadd sca pval_hi_wb = 0.12
	estadd sca pval_z_hi_wb = 0.006
	}
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

cgmwildboot `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, cl(subloc) bootcluster(subloc)  reps(1000) seed(894561) // manually add p-vals below from this regression
reg `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
foreach j in z hi z_hi {
	local pval_`j' = (2 * ttail(e(df_r), abs(_b[`j']/_se[`j'])))
	estadd sca pval_`j' = `pval_`j''
	}
if "`y'"== "inventory_trim" {
	estadd sca pval_z_wb =  0.000
	estadd sca pval_hi_wb = 0.956
	estadd sca pval_z_hi_wb = 0.150
	}
if "`y'"== "netrevenue_trim" {
	estadd sca pval_z_wb =  0.062
	estadd sca pval_hi_wb = 0.706
	estadd sca pval_z_hi_wb = 0.142
	}
if "`y'"== "logtotcons_trim" {
	estadd sca pval_z_wb =  0.616
	estadd sca pval_hi_wb = 0.294
	estadd sca pval_z_hi_wb = 0.084
	}
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

}


esttab reg* using "$tbls2/p_intens_all_alt.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.3f %10.3f  %10.3f %10.3f %10.3f %10.3f %10.3f %3s)  ///
	scalars("mdv Mean DV" "sd SD DV"  "N Observations" "r2 R squared" "pc P-val T+TH=0" "pval_z P-val Treat" "pval_z_wb P-val Treat Boostrap" "pval_hi P-val High"  "pval_hi_wb P-val High Boostrap" "pval_z_hi P-val Treat*High"  "pval_z_hi_wb P-val Treat*High Boostrap") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" ) ///
	mgroups("\multicolumn{3}{c}{Inventory} & \multicolumn{3}{c}{Net Revenues} & \multicolumn{3}{c}{Consumption}  \\ \cline{2-4} \cline{5-7} \cline{8-10} ", pattern(1 0 1 0))

	
drop z z_hi z_1 z_2 z_3 
est drop reg*


	

	

*******************************
*  Figure 4	- Panel A
*******************************

use "$main/baseline", clear



reg pctmaizesoldearly2011 harvest2011 num_schoolchildren
reg pctmaizesoldearly2011 num_schoolchildren
scatter netsales2011 num_schoolchildren
reg netsales2011 num_schoolchildren harvest2011 
reg netsales2011 num_schoolchildren harvest2011 if netsales2011<100000
reg netsales2011 num_schoolchildren hhsize harvest2011 
reg netsales2011 num_schoolchildren hhsize harvest2011 if netsales2011<100000
reg netsales2011 taken_bank_loan 
reg netsales2011 taken_bank_loan harvest2011 if netsales2011<100000


rename price_avg_diff_pct sales
rename price_avg_purdiff_pct purchase
rename price_expect_diff_pct expect
graph box sales purchase expect, noout yline(0) ///
	title("% change in price, Sept --> Jun") legend(off) showyvars nolab ///
	box(1, col(black)) box(2, col(gs10))  box(3, col(red)) saving(g1, replace)
collapse (mean) s3_2_13_av_sell_* s3_2_13_av_purch* s3_2_13_av_??
forvalues n = 1/9 {
	rename s3_2_13_av_sell_0`n' s3_2_13_av_sell_`n'
	rename s3_2_13_av_purch0`n' s3_2_13_av_purch`n'
	rename s3_2_13_av_0`n' s3_2_13_av_`n'
	}
gen i = 1
reshape long s3_2_13_av_sell_ s3_2_13_av_purch s3_2_13_av_, i(i)
rename s3_2_13_av_sell_ sales

rename s3_2_13_av_purch purchase
rename s3_2_13_av_ expect
line sales purchase expect _j, lc(black black red) lp(solid dash solid) xtitle(month) ytitle("price (KSH/goro)") ///
	legend(rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) title(Farmer reported price change) ///
	xlabel(1 "Sep" 2 "Oct" 3 "Nov" 4 "Dec" 5 "Jan" 6 "Feb" 7 "Mar" 8 "Apr" 9 "May" 10 "Jun" 11 "Jul" 12 "Aug") ///
	saving(g2, replace)
graph export "$plots1/price_expect_baseline_overtime.pdf", as(pdf) replace
graph combine g2.gph g1.gph, xsize(10) ysize(5) iscale(*1.3)
graph export "$plots1/price_expect_baseline.pdf", as(pdf) replace


line sales purchase _j, lc(black black) lp(solid dash) xtitle(month) ytitle("price (KSH/goro)") ///
	legend(rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) title(Farmer reported avg. price change) ///
	xlabel(1 "Sep" 2 "Oct" 3 "Nov" 4 "Dec" 5 "Jan" 6 "Feb" 7 "Mar" 8 "Apr" 9 "May" 10 "Jun" 11 "Jul" 12 "Aug") scheme(s1mono) ///
	saving(p1, replace)
line purchase _j, lc(black) lp(solid) xtitle(month)  ytitle("price (KSH/goro)") ///
	legend(rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) xtitle("") ///
	xlabel(1 "Sep" 2 "Oct" 3 "Nov" 4 "Dec" 5 "Jan" 6 "Feb" 7 "Mar" 8 "Apr" 9 "May" 10 "Jun" 11 "Jul" 12 "Aug") scheme(s1mono)
graph export "$plots1/past_price_inc.pdf", as(pdf) replace



use "$main/cleanPriceData_Y1Y2", clear
collapse (mean) salesPrice, by(monthnum)
replace monthnum = monthnum + 2 //set Nov = 1.
tempfile mergeprice
save "`mergeprice'", replace

use "$main/baseline", clear



forvalues n = 1/9 {
	rename s3_2_13_av_0`n' s3_2_13_av_`n'
	}
collapse (mean) s3_2_13_av_? s3_2_13_av_??
gen i = 1
reshape long s3_2_13_av_, i(i)
rename _j monthnum  
merge 1:1 monthnum using "`mergeprice'"
rename s3_2_13_av_ expected
lab var salesPrice "actual"


preserve
replace monthnum = monthnum -1 
keep expected monthnum
save "$temp/expect.dta", replace
restore




************
*Table H.1
************

use "$main/MS1MS2_pooled.dta", clear
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

gen treat1 = treatMS1MS2
replace treat1 = 0 if tags == 1 & treatMS1MS2 == . & MS == 1 


forvalues i = 1/3 {
	gen tags_`i' = tags*(round==`i')
	}

cap est drop reg*
areg inventory_trim treat1 tags  interviewdate Y1round2 Y1round3 if MS==1, a(strata_group) cl(groupnum)
test treat1 = tags
estadd sca dp = r(p)
est sto reg1

areg inventory_trim T1 T2 tags  interviewdate Y1round2 Y1round3 if MS==1, a(strata_group) cl(groupnum)
test T1 = tags
estadd sca p1 = r(p)
test T2 = tags
estadd sca p2 = r(p)
est sto reg2

areg netrevenue_trim treat1 tags  interviewdate Y1round2 Y1round3 if MS==1,  a(strata_group) cl(groupnum)
test treat1 = tags
estadd sca dp = r(p)
est sto reg3

areg netrevenue_trim T1 T2 tags  interviewdate Y1round2 Y1round3 if MS==1, a(strata_group) cl(groupnum)
test T1 = tags
estadd sca p1 = r(p)
test T2 = tags
estadd sca p2 = r(p)
est sto reg4

areg logtotcons_trim treat1 tags  interviewdate Y1round2 Y1round3 if MS==1,  a(strata_group) cl(groupnum)
test treat1 = tags
estadd sca dp = r(p)
est sto reg5

areg logtotcons_trim T1 T2 tags  interviewdate Y1round2 Y1round3 if MS==1, a(strata_group)  cl(groupnum)
test T1 = tags
estadd sca p1 = r(p)
test T2 = tags
estadd sca p2 = r(p)
est sto reg6

lab var treat1 "Year 1 - Treat"
label var tags "Tags"
label var T1 "T1 (Oct Loan)"
label var T2 "T2 (Jan Loan)"
esttab reg* using "$tbls1/tags_effect_Y1.tex", drop( interviewdate Y1round*  _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "r2 R squared" "dp Year 1 Treat-tags p-val"  "p1 T1-tags p-val" "p2 T2-tags p-val" ) ///
	order(treat1 T1 T2 tags) star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Inventories" "Inventories" "Revenues" "Revenues" "Consumption" "Consumption") 

eststo clear


***********
*Table I.1
***********

eststo clear
use "$main/MS1MS2_pooled.dta", clear
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

gen lock_treat = lockbox*treatMS1MS2
label var lockbox "Lockbox"
label var lock_treat "Lockbox*Treat"

foreach x in inventory_trim netrevenue_trim logtotcons_trim {

areg `x' lockbox  interviewdate Y1round2 Y1round3 if MS==1 & treatMS1MS2!=., a(strata_group) cl(groupnum)
qui summ `x' if lockbox==0 & MS==1
eststo r1_`x'
estadd sca mdv = r(mean)


areg `x' lockbox treatMS1MS2 lock_treat interviewdate Y1round2 Y1round3 if MS==1 & treatMS1MS2!=., a(strata_group) cl(groupnum)
eststo r2_`x'
qui summ `x' if lockbox==0 & treatMS1MS2 == 0 & MS==1
estadd sca mdv = r(mean)

}


esttab r*inventory_trim r*netrevenue_trim r*logtotcons_trim using "$tbls1/lockbox_Y1.tex", keep(lockbox treatMS1MS2 lock_treat) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Inventories" "Inventories" "Revenues" "Revenues" "Consumption" "Consumption") 

eststo clear




use "$main/MS1MS2_pooled.dta", clear
drop if MS==2

*******************************
*  Figure D.1	
*******************************

cap drop x* y*
fanreg inventory_trim interviewdate1 if treat12==0, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(4)
fanreg inventory_trim interviewdate1 if T1==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(4)
fanreg inventory_trim interviewdate1 if T2==1, xgen(x3) ygen(y3) reps(1) graph(off) np(100) bw(4)
format x1 %td
twoway line y1 y2 y3 x1, lp(dash solid solid) lc(black blue red) lw(medium thick medium) ///
		title("Inventories") ytitle("Inventory (90kg bags)") xtitle("")	legend(label(1 "C") label(2 "Oct") label(3 "Jan") rows(1) pos(8) ring(0) region(ls(none)) bmargin(tiny)) ///
		tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) scheme(s1mono) saving(inventory.gph, replace)
cap drop x* y*
fanreg netrevenue_trim interviewdate1 if treat12==0, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(3)
fanreg netrevenue_trim interviewdate1 if T1==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(3)
fanreg netrevenue_trim interviewdate1 if T2==1, xgen(x3) ygen(y3) reps(1) graph(off) np(100) bw(3)
format x1 %td
twoway line y1 y2 y3 x1, lp(dash solid solid) lc(black blue red) lw(medium thick medium) ///
		title("Net revenues") ytitle("Net revenues (KSH)") xtitle("") yline(0)	legend(label(1 "C") label(2 "Oct") label(3 "Jan") rows(1) pos(8) ring(0) region(ls(none)) bmargin(tiny)) ///
		tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) scheme(s1mono) saving(revenue.gph, replace)
cap drop x* y*
fanreg logtotcons_trim  interviewdate1 if treat12==0, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(4)
fanreg logtotcons_trim  interviewdate1 if T1==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(4)
fanreg logtotcons_trim  interviewdate1 if T2==1, xgen(x3) ygen(y3) reps(1) graph(off) np(100) bw(4)
format x1 %td
twoway line y1 y2 y3 x1, lp(dash solid solid) lc(black blue red) lw(medium thick medium) ///
		title("Total HH consumption") ytitle("Total HH consumption (log Ksh)") xtitle("") legend(label(1 "C") label(2 "Oct") label(3 "Jan") rows(1) pos(8) ring(0) region(ls(none)) bmargin(tiny)) ///
		tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) scheme(s1mono) saving(cons.gph, replace)
graph combine inventory.gph revenue.gph cons.gph, xsize(13) ysize(5) iscale(*1.3) r(1) scheme(s1mono)
graph export "$plots1/split_inventory_revenue_cons_fanreg.pdf", as(pdf) replace 



*******************************
*  Figure D.2
*******************************

set seed 362436
use "$main/MS1MS2_pooled", clear
drop if MS==2
replace treat12=. if tags==1
keep if treat12<.
keep netrevenue_trim interviewdate treat12 T1 T2 groupnum
save "$temp/pooledBootstrap", replace

qui fanreg netrevenue_trim interviewdate if treat12==0, xgen(x1) ygen(y1) reps(1) bw(3) //run once to initialize x length
keep if x1<.
keep x1
gen obs = _n
save "$temp/bootresults_T1_rev", replace
forvalues i = 1/100 {
	use "$temp/pooledBootstrap", clear
	bsample, cluster(groupnum)  //draw clusters with replacement
	qui fanreg netrevenue_trim interviewdate if treat12==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg netrevenue_trim interviewdate if T1==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	qui fanreg netrevenue_trim interviewdate if T2==1, xgen(x3) ygen(y3) reps(1) graph(off) bw(3)
	qui gen diff`i'_T1C = y2 - y1
	qui gen diff`i'_T2C = y3 - y1
	qui gen diff`i'_T1T2 = y2 - y3
	qui gen obs = _n
	qui sort obs
	keep obs diff`i'*
	qui merge 1:1 obs using "$temp/bootresults_T1_rev", nogen
	qui	save "$temp/bootresults_T1_rev", replace
	di "`i'"
}
format x1 %td
loc vars T1C T2C T1T2
foreach var of loc vars {
cap drop est_mean est_sd lower upper lower_90 upper_90
	egen est_mean = rowmean(diff*_`var')
	egen est_sd = rowsd(diff*_`var')
	gen lower = est_mean - 1.96*est_sd
	gen upper = est_mean + 1.96*est_sd
	gen lower_90=est_mean-1.645*est_sd
	gen upper_90=est_mean+1.645*est_sd
if "`var'"== "T1C" {
	loc tit "T1 - C"
	}
if "`var'"== "T2C" {
	loc tit "T2 - C"
	}
if "`var'"== "T1T2" {
	loc tit "T1 - T2"
	}
twoway (rarea lower upper x1 if x1>1, col(gs13) yline(0) legend(off) xtitle("") ytitle("Net revenues, `tit'") title("Net revenues, `tit'"))  ///
	(rarea lower_90 upper_90 x1 if x1>1, col(gs10)) ///
	 (line est_mean x1 if x1>1, lc(black) scheme(s1mono) tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) ///
	yline(0, lc(grey)) saving(`var'.gph, replace)	)


}
graph combine T1C.gph T2C.gph T1T2.gph, xsize(13) ysize(5) iscale(*1.3) r(1) scheme(s1mono) ycomm //force common y axes
graph export "$plots1/split_inventory_revenue_cons_boot.pdf", as(pdf) replace

	
***********************************************
* Table L.1
***********************************************

use "$main/baseline", clear

sum cropland 
gen any_livestock = (livestock>0 & livestock!=.)
tab any_livestock 
gen any_maize =  (harvest2012>0 & harvest2012!=.)
tab any_maize
egen fert = rowtotal(OAFDAPacre2012 nonOAFDAPacre2012 OAFCANacre2012 nonOAFCANacre2012)
gen any_fert = (fert>0 & fert!=.)
tab any_fert 
sum moneygift_give if moneygift_give!=0 
sum maizesalesprice2011
gen maizegift_give_val = maizegift_give*r(mean)/40
sum maizegift_give_val if maizegift_give!=0 
sum finished_primary 
sum finished_secondary 
gen num_HH_members = num_children+num_adults
sum num_HH_members 

gen prct_earth_floor = 0
replace prct_earth_floor = 1 if s2_6_dwelling_floor == "1"
sum prct_earth_floor 

gen prct_iron_roof = 0
replace prct_iron_roof = 1 if s2_5_home_roof == "2"
sum prct_iron_roof 

gen prct_mudsticks = 0
replace prct_mudsticks = 1 if s2_4_homemadeof == "1"
sum prct_mudsticks 

di .134*1+.484*2+.211*3+.16*4.5+0.004*8+0.007*11
replace  num_rooms = 11 if  num_rooms>11 & num_rooms!=.  
sum num_rooms 

local vars 	 cropland any_livestock any_maize any_fert  finished_primary finished_secondary num_HH_members num_rooms ///
prct_earth_floor prct_iron_roof prct_mudsticks  	
local numvars : word count `vars'
tokenize `vars'
forvalues i = 1/`numvars' {
sum ``i''
mat b = (r(mean))
	if `i'==1 {
		mat d = b
		}
		else {
		mat d = d\b  
		}
	}

sum moneygift_give if moneygift_give!=0 
mat d = d\(r(mean))
sum maizegift_give_val if maizegift_give!=0 
mat d = d\(r(mean))

mat c = (2.5 \ 0.858 \ 0.975 \ 0.810 \ 0.856 \ 0.253 \ 6.4 \ 2.7 \ 0.809 \ 0.818 \ 0.795 \ 1405 \ 1649)

mat d = [d,c]

label var cropland "Landholding (acres)"
label var any_livestock "Any livestock"
label var any_maize  "Grow maize"
label var any_fert  "Any fertilizer"
label var finished_primary  "Finished primary"
label var finished_secondary  "Finished secondary"
label var num_HH_members  "HH members"
label var num_rooms  "Num rooms"
label var prct_earth_floor  "Earth floor"
label var prct_iron_roof  "Iron roof"
label var prct_mudsticks "Mud and sticks wall"
label var moneygift_give "Money given (if any)"
label var maizegift_give "Food given (if any)"

local vars cropland any_livestock any_maize any_fert  finished_primary finished_secondary num_HH_members num_rooms ///
prct_earth_floor prct_iron_roof prct_mudsticks  moneygift_give maizegift_give

mat rownames d = `vars'
frmttable using "$tbls2/rep_sample.tex", statmat(d) replace va tex fra ///
	ctitles("","Sample Mean","Bungoma Mean") sdec(2\2\2\2\2\2\2\2\2\2\2\0\0)


***********************************************
* Figure 7
***********************************************

use "$main/MS1MS2_pooled.dta", clear

preserve
//drop _m
merge m:1 sublocation MS using "$main/intensity_obs_short.dta"
drop if _m == 2 // no one in KULUMBENI B/MAKHUKHUNI in Y2

restore

preserve

gen month = month(interviewdate)
gen year = year(interviewdate)
tab month year
gen samp_inc = 1 if month == 12 | (month>= 1 & month<8) // only include overlap in months covered by Y1 and Y2
drop interviewdate1
gen interviewdate1 = interviewdate
replace interviewdate1 = interviewdate - 365 if MS == 2 // align Y1 and Y2

format interviewdate1 %td
//drop _merge

drop if samp_inc!=1
fanreg inventory_trim interviewdate1 if treatMS1MS2 ==1 & hi==1 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(3)
fanreg inventory_trim interviewdate1 if treatMS1MS2 ==1 & hi==0 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(3)
fanreg inventory_trim interviewdate1 if treatMS1MS2 ==0 & hi==1 & samp_inc ==1, xgen(x3) ygen(y3) reps(1) graph(off) np(100) bw(3)
fanreg inventory_trim interviewdate1 if treatMS1MS2 ==0 & hi==0 & samp_inc ==1, xgen(x4) ygen(y4) reps(1) graph(off) np(100) bw(3)
format x1 %td
twoway line y1 y2 y3 y4 x1 if samp_inc==1, lp(solid solid dash dash) lw(thick medium thick medium) lc(black orange black orange) scheme(s1mono) ///
		title("Inventories", size(large)) ytitle("Inventory (90kg bags)", height (7) size(large)) xtitle("")	legend(label(1 "T High") label(2 "T Low") label(3 "C High") label(4 "C Low") size(large) rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny) symxsize(5)) ///
		tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)) saving(p_inventory_byintens.gph, replace)

cap drop x1- y4_l
fanreg netrevenue_trim interviewdate1 if treatMS1MS2 ==1 & hi==1 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(3)
fanreg netrevenue_trim interviewdate1 if treatMS1MS2 ==1 & hi==0 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(3)
fanreg netrevenue_trim interviewdate1 if treatMS1MS2 ==0 & hi==1 & samp_inc ==1, xgen(x3) ygen(y3) reps(1) graph(off) np(100) bw(3)
fanreg netrevenue_trim interviewdate1 if treatMS1MS2 ==0 & hi==0 & samp_inc ==1, xgen(x4) ygen(y4) reps(1) graph(off) np(100) bw(3)
format x1 %td
twoway line y1 y2 y3 y4 x1 if samp_inc==1, lp(solid solid dash dash) lw(thick medium thick medium) lc(black orange black orange) scheme(s1mono) ///
		title("Net Revenues", size(large)) ytitle("Net Revenues (KSH)", height (7) size(large)) xtitle("")	legend(label(1 "T High") label(2 "T Low") label(3 "C High") label(4 "C Low") size(large) rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny) symxsize(5)) ///
		tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)) yline(0, lc(grey)) saving(p_revenue_byintens.gph, replace) 

cap drop x1- y4_l
fanreg logtotcons_trim  interviewdate1 if treat13==1 & hi==1 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(3)
fanreg logtotcons_trim  interviewdate1 if treat13==1 & hi==0 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(3)
fanreg logtotcons_trim  interviewdate1 if treat13==0 & hi==1 & samp_inc ==1, xgen(x3) ygen(y3) reps(1) graph(off) np(100) bw(3)
fanreg logtotcons_trim  interviewdate1 if treat13==0 & hi==0 & samp_inc ==1, xgen(x4) ygen(y4) reps(1) graph(off) np(100) bw(3)
format x1 %td
replace x1 = . if samp_inc!=1
twoway line y1 y2 y3 y4 x1, lp(solid solid dash dash) lw(thick medium thick medium) lc(black orange black orange) scheme(s1mono) ///
		title("Total HH consumption (log)", size(large)) ytitle("Total HH consumption (log)", height (7) size(large)) xtitle("")	legend(label(1 "T High") label(2 "T Low") label(3 "C High") label(4 "C Low") size(large) rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny) symxsize(5)) ///
		tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)) yline(0, lc(grey)) saving(p_cons_byintens.gph, replace)

graph combine p_inventory_byintens.gph p_revenue_byintens.gph p_cons_byintens.gph, xsize(6) ysize(15) iscale(*1) r(3) scheme(s1mono)
graph export "$plots2/p_treatintensity.pdf", as(pdf) replace

restore 

***********************************************
* Figure 5
***********************************************

*PLOT FIGURE OF TREATMENT EFFECTS


preserve

gen month = month(interviewdate)
gen year = year(interviewdate)
tab month year
gen samp_inc = 1 if  month == 12 | (month>= 1 & month<8)
drop interviewdate1
gen interviewdate1 = interviewdate
replace interviewdate1 = interviewdate - 365 if MS == 2 // align Y1 and Y2

format interviewdate1 %td

* PLOT INVENTORY TREATMENT EFFECTS OVER TIME
//drop _m

*using fanreg
cap drop x* y*
fanreg inventory_trim interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1 , xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(4)
fanreg inventory_trim interviewdate1 if treatMS1MS2 ==1  & samp_inc ==1 , xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(4)
format x1 %td
twoway line y1 y2 x1 if x1<date("01aug2013","DMY"), lp(dash solid)  ///
		title("Inventories", size(large)) ytitle("Inventory (90kg bags)", height (7) size(large)) xtitle("")	legend(label(1 "Control") label(2 "Treatment") size(large) rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny)) scheme(s1mono) ///
		tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) yline(0, lc(grey)) saving("$plots2/p_inventory.gph", replace)

cap drop y*

*PLOT REVENUES TREATMENT EFFECTS OVER TIME

	*using fanreg
	cap drop x* y*
	fanreg netrevenue_trim interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(4)
	fanreg netrevenue_trim interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(4)
	format x1 %td
	twoway line y1 y2 x1 if x1<date("01aug2013","DMY"), lp(dash solid) yline(0)  ///
			title("Net Revenues", size(large)) ytitle("Net Revenues (KSH)", height (7) size(large)) xtitle("")	legend(label(1 "Control") label(2 "Treatment")  size(large) rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny)) scheme(s1mono) ylabel(-3000(2000)3000) ///
			tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)) yline(0, lc(grey)) saving("$plots2/p_revenue.gph", replace)

	cap drop y*

*PLOT CONSUMPTION TREATMENT EFFECTS OVER TIME

	*using fanreg
	cap drop x* y*
	fanreg logtotcons_trim interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(4)
	fanreg logtotcons_trim interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(4)
	format x1 %td
	twoway line y1 y2 x1 if x1<date("01aug2013","DMY"), lp(dash solid)  ///
			title("Total HH consumption (log)", size(large)) ytitle("Total HH consumption (log)", height (7) size(large)) xtitle("")	legend(label(1 "Control") label(2 "Treatment")  size(large) rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny)) scheme(s1mono) ///
			tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)) yline(0, lc(grey)) saving("$plots2/p_consumption.gph", replace)


	cap drop y*

restore


* BOOTSTRAP 

preserve

gen month = month(interviewdate)
gen year = year(interviewdate)
tab month year
gen samp_inc = 1 if month == 12 | (month>= 1 & month<8)
drop interviewdate1
gen interviewdate1 = interviewdate
replace interviewdate1 = interviewdate - 365 if MS == 2 // align Y1 and Y2

format interviewdate1 %td

keep if treatMS1MS2 <.
keep inventory_trim netrevenue_trim logtotcons_trim interviewdate1 treatMS1MS2 groupnum round samp_inc
save "$temp/p_treatBootstrap", replace
set seed 7060116

foreach var of varlist inventory_trim netrevenue_trim logtotcons_trim { //add variables here
	use "$temp/p_treatBootstrap", replace
	qui fanreg `var' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) bw(3) 
	qui fanreg `var' interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) bw(3) 
	keep if x1<.
	gen obs=_n
	qui gen diff1=y2-y1
	keep obs x1 diff1
	save "$temp/p_bootresults_`var'", replace


	
	forvalues i=2/100{
		use "$temp/p_treatBootstrap", clear
		bsample 171, cluster(groupnum) //O: check that there are only 171 clusters
		qui fanreg `var' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) bw(3) 
		qui fanreg `var' interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) bw(3) 
		qui gen diff`i' = y2-y1
		qui gen obs=_n
		qui sort obs
		keep obs diff`i'
		qui merge 1:1 obs using "$temp/p_bootresults_`var'", nogen
		qui save "$temp/p_bootresults_`var'", replace
		di "`i'"
	}
	

	gen est_mean=diff1
	egen est_sd=rowsd(diff*)
	gen lower=est_mean-1.96*est_sd
	gen upper=est_mean+1.96*est_sd
	gen lower_90=est_mean-1.645*est_sd
	gen upper_90=est_mean+1.645*est_sd
	gen y_temp = 0
	if "`var'"== "inventory_trim" {
		loc tit "Inventories"
	}
	if "`var'"== "netrevenue_trim" {
		loc tit "Net Revenues"
	}
	if "`var'"== "logtotcons_trim" {
		loc tit "Total HH consumption (log)"
	}


	format x1 %td
	twoway (rarea lower upper x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs10) yline(0) legend(off) xtitle("") ytitle("`tit', T - C") title("`tit'"))  ///
	 (line est_mean x1 if x1>1 &  x1<date("01aug2013","DMY"), lc(black) ///
	tlabel(01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)) scheme(s1mono)  ///
	yline(0, lc(grey)) saving("$plots2/p_`var'_boot.gph", replace))

	twoway (rarea lower upper x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs13)  xtitle("") ytitle("`tit', T - C", height (9) size(large)) title("`tit'", size(large))   ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)))  ///
	(rarea lower_90 upper_90 x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs10)) ///
	(line est_mean x1 if x1>1 &  x1<date("01aug2013","DMY"), yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) size(large) rows(1) pos(6) ring(1) region(ls(none))))  ///
	(line y_temp x1 if x1<date("01aug2013","DMY"), saving("$plots2/p_`var'_boot_alt.gph", replace))

	if "`var'"== "logtotcons_trim" {
	twoway (rarea lower upper x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs13) ylab(-0.3(0.1)0.3) xtitle("") ytitle("`tit', T - C", height (9) size(large)) title("`tit'", size(large))   ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)))  ///
	(rarea lower_90 upper_90 x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs10)) ///
	(line est_mean x1 if x1>1 &  x1<date("01aug2013","DMY"), yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) size(large) rows(1) pos(6) ring(1) region(ls(none))))  ///
	(line y_temp x1 if x1<date("01aug2013","DMY"), saving("$plots2/p_`var'_boot_alt.gph", replace))

	}
}



graph combine "$plots2/p_inventory.gph" "$plots2/p_inventory_trim_boot_alt.gph" ///
"$plots2/p_revenue.gph"  "$plots2/p_netrevenue_trim_boot_alt.gph" ///
 "$plots2/p_consumption.gph"  "$plots2/p_logtotcons_trim_boot_alt.gph", ///
rows (3) xsize(8) ysize(12) scheme(s1mono) altshrink
graph export "$plots2/p_inventory_revenue_cons.pdf", as(pdf) replace




*******************
*Table J.7
*******************

use "$main/MS1MS2_pooled.dta", clear

forval i=1/3{
gen hi_`i' = hi*round`i'
label var hi_`i' "Hi - R`i'"
gen hi_treat_`i' = hi_`i'*treatMS1MS2
}

foreach x in sales purchase {

gen `x'price_goro_trim = `x'price_trim/40 // get into same units as market level price data

sum `x'price_goro_trim if round ==1 & hi==0 // normalize to be 100 in R1 control
local norm = 100/r(mean)
gen `x'price_goro_trim_norm = `x'price_goro_trim*`norm'


*Sale price
reg `x'price_goro_trim_norm hi_1 hi_2 hi_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc)
qui summ `x'price_goro_trim_norm if hi==0
estadd sca mdv = r(mean)
est sto reg_p_`x'

reg `x'price_goro_trim_norm hi_1 hi_2 hi_3 interviewdate Y1round2 Y1round3 if MS == 1,  cl(subloc)
qui summ `x'price_goro_trim_norm if hi==0 & MS == 1
estadd sca mdv = r(mean)
est sto reg_Y1_`x'

reg `x'price_goro_trim_norm hi_1 hi_2 hi_3 interviewdate  Y2round2 Y2round3 if MS == 2,  cl(subloc)
qui summ `x'price_goro_trim_norm if hi==0 & MS == 2
estadd sca mdv = r(mean)
est sto reg_Y2_`x'

}

esttab reg_Y1_sales reg_Y2_sales reg_p_sales reg_Y1_purchase reg_Y2_purchase reg_p_purchase using "$tbls2/farmgate_prices.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars( "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled") ///
	mgroups("\multicolumn{3}{c}{Sales Price} & \multicolumn{3}{c}{Purchase Price} \\ \cline{2-4} \cline{5-7}", pattern(1 0 1 0))

esttab reg_Y1_sales reg_Y2_sales reg_p_sales    using "$tbls2/farmgate_prices_sales.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled")


clear


*******************************
*  Figure 4	- Panel B
*******************************

use "$main/cleanPriceData_Y1Y2", clear

*season is sept-june
gen monthnum3 = monthnum + 2
replace monthnum3 = 0 if monthnum3 == 12
replace monthnum3 = 1 if monthnum3 == 13

*gen study year categorization 
gen study_year = 1213 if (year == 2012 & (monthnum3 > -1 & monthnum3 < 4)) | (year == 2013 & (monthnum3>3 & monthnum3 <12))
replace study_year = 1314 if (year == 2013 & (monthnum3 > -1 & monthnum3 < 4)) | (year == 2014 & (monthnum3>3 & monthnum3 <12))
replace study_year = 1415 if (year == 2014 & (monthnum3 > -1 & monthnum3 < 4)) | (year == 2015 & (monthnum3>3 & monthnum3 <12))
replace study_year = 1516 if (year == 2015 & (monthnum3 > -1 & monthnum3 < 4)) | (year == 2016 & (monthnum3>3 & monthnum3 <12))

*align dates
gen date2 = date
replace date2 = date2-(365*1) if study_year == 1314
replace date2 = date2-(365*2) if study_year == 1415
replace date2 = date2-(365*3) if study_year == 1516

keep salesPrice_trim monthnum monthnum3 date date2 study_year

*get average price per month
bysort monthnum3 study_year: egen mean_price = mean(salesPrice_trim)
bysort monthnum3 study_year: egen median_price = median(salesPrice_trim)
collapse mean_price median_price, by(monthnum3 study_year)
sort study_year monthnum3
list 

*bring in expected price 
preserve
use "$temp/expect.dta", clear
gen study_year = 9999
rename expected mean_price
rename monthnum monthnum3
save "$temp/expect_formerge.dta", replace
restore
append using "$temp/expect_formerge.dta"

*graph
twoway (line mean_price monthnum3 if study_year==1213, lp(solid) lw(medthick)) (line mean_price monthnum3 if study_year==1314, lp(longdash dot) lw(medthick)) ///
	(line mean_price monthnum3 if study_year==1415, lp(shortdash dot) lw(medthick)) ///
	,xtitle("") ytitle("Price (Ksh/goro)") xlabel(0 "Sep" 1 "Oct" 2 "Nov" 3 "Dec" 4 "Jan" 5 "Feb" 6 "Mar" 7 "Apr" 8 "May" 9 "Jun" 10 "Jul" 11 "Aug") ///
	legend(label(1 "2012-2013") label(2 "2013-2014") label(3 "2014-2015") rows(2) pos(10) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono) 
graph export "$plots2/price_over_years.pdf", as(pdf) replace


clear 

******************************************************************
* Table 6, J.1
******************************************************************
clear

use "$main/cleanPriceData_Y1Y2.dta", clear

gen hi = .
gen interact=.
gen interact_lean = .

foreach x in 1km_wt 3km_wt 5km_wt  {
preserve

sum salesPrice_trim if monthnum==0 & hi_`x'==0
local norm = 100/r(mean)
gen salesPrice_trim_norm = salesPrice_trim*`norm' // normalized so that mean prices in low intensity areas in November is 100

replace hi = hi_`x'
replace interact = monthnum*hi
replace interact_lean = lean*hi

*Y1
cgmwildboot salesPrice_trim_norm hi monthnum interact if in_sample == 1 & MS == 1, cl(subloc_`x'_grp) bootcluster(subloc_`x'_grp)  reps(1000) seed(65464654) // manually bring pvals from this into the table below
reg salesPrice_trim_norm hi monthnum interact if in_sample==1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 1  & in_sample == 1
estadd sca mdv = r(mean)
foreach z in hi monthnum interact {
	local pval_`z' = (2 * ttail(e(df_r), abs(_b[`z']/_se[`z'])))
	estadd sca pval_`z' = `pval_`z''
	}
if "`x'"== "3km_wt" {
	estadd sca pval_hi_wb =  0.096
	estadd sca pval_monthnum_wb = 0.040
	estadd sca pval_interact_wb = 0.176
	}
est sto reg_y1_`x'

reg salesPrice_trim_norm hi lean interact_lean if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if lean == 0 & hi == 0 & MS == 1
estadd sca mdv = r(mean)
est sto reg_binary_y1_`x'

reg log_salesPrice_trim hi monthnum interact if in_sample==1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if hi == 0 & MS == 1  & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_log_y1_`x'

reg log_salesPrice_trim hi lean interact_lean if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if lean == 0 & hi == 0 & MS == 1
estadd sca mdv = r(mean)
est sto reg_log_binary_y1_`x'

*Y2
cgmwildboot salesPrice_trim_norm hi monthnum interact if in_sample == 1 & MS == 2, cl(subloc_`x'_grp) bootcluster(subloc_`x'_grp)  reps(1000) seed(65464654)
reg salesPrice_trim_norm hi monthnum interact  if MS == 2 & in_sample==1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 2  & in_sample == 1
estadd sca mdv = r(mean)
foreach z in hi monthnum interact {
	local pval_`z' = (2 * ttail(e(df_r), abs(_b[`z']/_se[`z'])))
	estadd sca pval_`z' = `pval_`z''
	}
if "`x'"== "3km_wt" {
	estadd sca pval_hi_wb =  0.196
	estadd sca pval_monthnum_wb = 0.000
	estadd sca pval_interact_wb = 0.316
	}
est sto reg_y2_`x'

reg salesPrice_trim_norm hi lean interact_lean if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if lean == 0 & hi == 0 & MS == 2
estadd sca mdv = r(mean)
est sto reg_binary_y2_`x'

reg log_salesPrice_trim hi monthnum interact  if MS == 2 & in_sample==1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if hi == 0 & MS == 2  & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_log_y2_`x'

reg log_salesPrice_trim hi lean interact_lean if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ salesPrice_trim if lean == 0 & hi == 0 & MS == 2
estadd sca mdv = r(mean)
est sto reg_log_binary_y2_`x'

*Pooled
cgmwildboot salesPrice_trim_norm hi monthnum interact if in_sample == 1, cl(subloc_`x'_grp) bootcluster(subloc_`x'_grp)  reps(1000) seed(65464654) 
reg salesPrice_trim_norm hi monthnum interact if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & in_sample == 1
estadd sca mdv = r(mean)
foreach z in hi monthnum interact {
	local pval_`z' = (2 * ttail(e(df_r), abs(_b[`z']/_se[`z'])))
	estadd sca pval_`z' = `pval_`z''
	}
if "`x'"== "3km_wt" {
	estadd sca pval_hi_wb =  0.084
	estadd sca pval_monthnum_wb = 0.034
	estadd sca pval_interact_wb = 0.17
	}
if "`x'"== "1km_wt" {
	estadd sca pval_hi_wb =  0.152
	estadd sca pval_monthnum_wb = 0.022
	estadd sca pval_interact_wb = 0.218
	}
if "`x'"== "5km_wt" {
	estadd sca pval_hi_wb =  0.112
	estadd sca pval_monthnum_wb = 0.000
	estadd sca pval_interact_wb = 0.056
	}
est sto reg_p_`x'

reg salesPrice_trim_norm hi lean interact_lean if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if lean == 0 & hi == 0
estadd sca mdv = r(mean)
est sto reg_binary_p_`x'

reg log_salesPrice_trim hi monthnum interact if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if hi == 0 & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_log_p_`x'

reg log_salesPrice_trim hi lean interact_lean if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if lean == 0 & hi == 0
estadd sca mdv = r(mean)
est sto reg_log_binary_p_`x'


restore
}

lab var hi "High"
lab var	monthnum "Month"
lab var interact "High Intensity * Month"
lab var interact_lean "High Intensity * Lean"

esttab reg_y1_3km_wt reg_y2_3km_wt reg_p_3km_wt reg_p_1km_wt reg_p_5km_wt using "$tbls2/price_effects_main.tex", drop( _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f  %10.3f %10.3f %10.3f %10.3f %10.3f %10.3f) ///
	scalars("N Obs." "r2 R squared" "pval_hi P-val High"  "pval_hi_wb P-val High Bootstrap" "pval_monthnum P-val Month" "pval_monthnum_wb P-val Month Bootstrap" "pval_interact P-val High*Month"  "pval_interact_wb P-val High*Month Bootstrap") ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2"  "Pooled" "1km" "5km" "Binary, 3km") nonum ///
	mgroups("\multicolumn{3}{c}{Main Specification (3km)} & \multicolumn{2}{c}{Robustness (Pooled)}  \\ \cline{2-4} \cline{5-6}", pattern(1 0 1 0))


esttab reg_binary_y1_3km_wt reg_binary_y2_3km_wt reg_binary_p_3km_wt reg_binary_p_1km_wt reg_binary_p_5km_wt using "$tbls2/price_effects_main_binary.tex", drop( _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs." "r2 R squared" ) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2"  "Pooled" "1km" "5km" "Binary, 3km") nonum ///
	mgroups("\multicolumn{3}{c}{Main Specification (3km)} & \multicolumn{2}{c}{Robustness (Pooled)}  \\ \cline{2-4} \cline{5-6}", pattern(1 0 1 0))


eststo clear




*****************************************************************
* Figure 6
*****************************************************************


use "$main/cleanPriceData_Y1Y2.dta", clear

*bootstrap fanreg with log prices
foreach x in 1km_wt 3km_wt 5km_wt  {
preserve
keep if in_sample == 1 & MS == 1
keep log_salesPrice_trim monthnum date hi_`x' subloc_`x' salesPrice_trim
rename hi_`x' hi
rename subloc_`x' subloc
save "$temp/priceBootstrap_Y1_`x'.dta", replace
restore
}

foreach x in 1km_wt 3km_wt 5km_wt  {
preserve
keep if in_sample == 1 & MS == 2
replace date = date - 365 // align dates with Y1
keep log_salesPrice_trim monthnum date hi_`x' subloc_`x' salesPrice_trim
rename hi_`x' hi
rename subloc_`x' subloc
save "$temp/priceBootstrap_Y2_`x'.dta", replace
restore
}
  
foreach x in 1km_wt 3km_wt 5km_wt  {
preserve
keep if in_sample == 1
replace date = date - 365 if MS == 2 // align dates with Y1
keep log_salesPrice_trim monthnum date hi_`x' subloc_`x' salesPrice_trim
rename hi_`x' hi
rename subloc_`x' subloc
save "$temp/priceBootstrap_p_`x'.dta", replace
restore
}

* bootstrap the following fanreg. sample sublocations with replacement
foreach x in 1km_wt 3km_wt 5km_wt  {
foreach z in p {
use "$temp/priceBootstrap_`z'_`x'.dta", clear
sort date monthnum log_salesPrice_trim hi subloc
set seed 362436
qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) bw(3) //run once to initialize x length
keep if x1<.
keep x1
gen obs = _n
save "$temp/priceBootstrap_`z'_`x'_fan1.dta", replace
 
forvalues i = 1/1000 { 
	use "$temp/priceBootstrap_`z'_`x'", clear
	sort date monthnum log_salesPrice_trim hi subloc
	bsample, cluster(subloc)  //draw clusters with replacement
	capture {
	qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg log_salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen diff`i' = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs diff`i'
	qui merge 1:1 obs using "$temp/priceBootstrap_`z'_`x'_fan1", nogen
	qui	save "$temp/priceBootstrap_`z'_`x'_fan1", replace
	}
	di "`i'"
	
}

use "$temp/priceBootstrap_`z'_`x'", clear
	sort date monthnum log_salesPrice_trim hi subloc
	qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3) // get actual difference for black line
	qui fanreg log_salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen est_mean  = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs est_mean x1
	save "$temp/priceBootstrap_`z'_`x'_mainfig", replace
	keep obs est_mean 
	merge 1:1 obs using "$temp/priceBootstrap_`z'_`x'_fan1", nogen


egen est_sd = rowsd(diff*)
replace est_mean = est_mean*100  //put in easy to read percentages
replace est_sd = est_sd*100
gen lower = est_mean - 1.96*est_sd
gen upper = est_mean + 1.96*est_sd
gen lower_90 = est_mean - 1.645*est_sd
gen upper_90 = est_mean + 1.645*est_sd
gen y_temp = 0

format x1 %td

*standardize graphs
foreach y in upper upper_90 {
gen temp_`y' = `y'
replace temp_`y' = 7 if `y' > 7 & `y'!=.
}

foreach y in lower lower_90 {
gen temp_`y' = `y'
replace temp_`y' = -7 if `y' < -7 & `y'!=.
}

*graphs

twoway (rarea lower upper x1 if x1>1, col(gs13)  xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon))) ///
	(rarea lower_90 upper_90 x1 if x1>1, col(gs10)) ///
	 (line est_mean x1 if x1>1, yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1, saving(g1_`z'_`x'_modal, replace))

twoway (line lower lower_90 upper upper_90 est_mean x1 if x1>1, scheme(s1mono) lw(medium medium medium medium thick) lp(dash solid dash solid solid) lc(gs10 gs7 gs10 gs7 black) ////
 yline(0) legend(on order(5 "Pt Est" 1 "95% CI" 2 "90% CI") rows(1) pos(6) ring(0) region(ls(none))) xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) saving(g1_`z'_`x'_modal_alt, replace)) 

	twoway (rarea temp_lower temp_upper x1 if x1>1, col(gs13)  xtitle("") ylabel(-7(2)7) ytitle("Difference in price (%)", height (7) size(large))  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon))) ///
	(rarea temp_lower_90 temp_upper_90 x1 if x1>1, col(gs10)) ///
	 (line est_mean x1 if x1>1, yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) size(large) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1, saving(g1_`z'_`x'_modal_alt2, replace))

use "$temp/priceBootstrap_`z'_`x'", clear
	qui fanreg salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
format x1 %td
twoway line y1 y2 x1 if x1>1, xtitle("") ytitle("Price (Ksh/goro)", height (7) size(large)) lc(black black) lp(dash solid) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "Low") label(2 "High") size(large) rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono) saving(g2_`z'_`x'_modal, replace)

}
}


*Main Figure

foreach z in p {
use "$temp/priceBootstrap_`z'_3km_wt_mainfig", clear
rename est_mean est_mean_3km_wt
replace est_mean_3km_wt = est_mean_3km_wt*100
rename x1 x1_3km_wt
merge 1:1 obs using "$temp/priceBootstrap_`z'_1km_wt_mainfig", nogen
rename est_mean est_mean_1km_wt
replace est_mean_1km_wt = est_mean_1km_wt*100
rename x1 x1_1km_wt
merge 1:1 obs using "$temp/priceBootstrap_`z'_5km_wt_mainfig", nogen
rename est_mean est_mean_5km_wt
replace est_mean_5km_wt = est_mean_5km_wt*100
rename x1 x1_5km_wt
format x1_3km_wt %td
twoway line est_mean_1km_wt est_mean_3km_wt est_mean_5km_wt x1_3km_wt if x1_3km_wt>1, yline(0) xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)") lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono)  saving(g3_`z'_main_modal, replace)
	
twoway line est_mean_1km_wt est_mean_3km_wt est_mean_5km_wt x1_3km_wt if x1_3km_wt>1, yline(0) xtitle("") ylabel(-7(2)7) ytitle("Difference in price (%)", height (7) size(large)) lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") size(large) rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono)  saving(g3_`z'_main_modal_alt2, replace)

twoway line est_mean_1km_wt est_mean_3km_wt est_mean_5km_wt x1_3km_wt if x1_3km_wt>1, yline(0) xtitle("") ylabel(-5(2)5) ytitle("Difference in price (%)") lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono) 
graph export "$plots2/market_logprice_main_modal_radiirobus_`z'_forpres.pdf", as(pdf) replace

graph combine g2_`z'_3km_wt_modal.gph g1_`z'_3km_wt_modal_alt2.gph g3_`z'_main_modal_alt2.gph, xsize(6) ysize(16) scheme(s1mono) rows(3)
graph export "$plots2/market_logprice_main_modal_`z'_alt2.pdf", as(pdf) replace


}

**********************************
*Figure J.4
**********************************

use "$main/cleanPriceData_Y1Y2.dta", clear

keep if (MS == 1 | MS == 2) & in_sample ==1 

cap drop _m
qui fanreg log_salesPrice_trim monthnum if hi_3km_wt==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
qui fanreg log_salesPrice_trim monthnum if hi_3km_wt==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
gen basediff = y2 - y1
forvalues j=1/17 {
	cap drop x1 x2 y1* y2*
	qui fanreg log_salesPrice_trim monthnum if hi_3km_wt==0 & subloc_3km_wt_grp~=`j', xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg log_salesPrice_trim monthnum if hi_3km_wt==1 & subloc_3km_wt_grp~=`j', xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen diff`j' = y2 - y1
}

keep diff* x1 basediff
drop if _n>51
order diff* x1 basediff
replace basediff = basediff*100 // get into percents
forval k = 1/17 { 
replace diff`k'=diff`k'*100
}

forval k = 1/17 { 
local plotline  "`plotline' (line diff`k' x1 if x1<10, lc(gs10) lp(solid))" 
} 

twoway `plotline' (line basediff x1 if x1<10, lc(black) lp(solid) lw(thick)), legend(off)  yline(0, lcolor(gs5) lp(shortdash)) ///
 bgcolor(white) graphregion(color(white)) ytitle("% difference in price") ylabel(,nogrid) xla(0 "Nov" 1 "Dec" 2 "Jan" 3 "Feb" 4 "Mar" 5 "Apr" 6 "May" 7 "Jun" 8 "Jul" 9 "Aug") xtitle("")
graph export "$plots2/subloc_drop_p.pdf", replace 


***************************
*Figure J.3
***************************

* generate placebo treatment vector, and run fanreg under this placebo treatment
use "$main/cleanPriceData_Y1Y2.dta", clear

foreach x in 3 {

keep if (MS == 1 | MS == 2) & in_sample ==1 
keep log_salesPrice_trim monthnum subloc_`x'km_wt_grp hi_`x'km_wt

save "$temp/price_randominference_p_`x'km_wt", replace

set seed 8675309
//local bootnum = 18
local bootnum = 1000
//generate 1,000 placebo treatment assignments
clear
set obs 17
gen subloc_`x'km_wt_grp = _n
forvalues i = 1/`bootnum' {
qui gen rand = rnormal()
sort rand
gen treat`i' = _n<=9
drop rand
}
save "$temp/randassign_p_`x'km_wt", replace

use "$temp/price_randominference_p_`x'km_wt", clear
merge n:1 subloc_`x'km_wt_grp using "$temp/randassign_p_`x'km_wt", nogen
forvalues i = 1/`bootnum' {
	qui fanreg log_salesPrice_trim monthnum if treat`i'==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg log_salesPrice_trim monthnum if treat`i'==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	qui gen diff`i' = (y2 - y1)*100 // to get into easy to read percentages
	drop x* y*
di "`i'"
}

qui fanreg log_salesPrice_trim monthnum if hi_`x'km_wt==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
qui fanreg log_salesPrice_trim monthnum if hi_`x'km_wt==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
gen basediff = (y2 - y1)*100 // to get into easy to read percentages
keep diff* x1 basediff
drop if _n>51
order diff* x1 basediff

local legnum = `bootnum' + 2
forval i = 1/`bootnum' { 
local plotline  "`plotline' (line diff`i' x1 if x1<10, lc(gs10) lp(solid))" 
} 

gen linevar = 0
twoway `plotline' (line linevar  x1 if x1<10, lcolor(gs5) lp(shortdash)) (line basediff x1 if x1<10, lc(black) lp(solid) lw(thick)) , ///
legend(off)  bgcolor(white) graphregion(color(white)) ytitle("% difference in price") ///
ylabel(,nogrid) xla(0 "Nov" 1 "Dec" 2 "Jan" 3 "Feb" 4 "Mar" 5 "Apr" 6 "May" 7 "Jun" 8 "Jul" 9 "Aug") xtitle("") saving(g1_randinf_`x'km_wt, replace)
graph export "$plots2/rando_inference_results_p_`x'km_wt.pdf", replace 


gen basediff_abs=abs(basediff)
forval i = 1/`bootnum'{
gen diff_abs`i' = abs(diff`i')
gen diff_greater`i' = (diff`i'>basediff)
gen diff_lesser`i'=(diff`i'<basediff)
gen diff_anyabs`i'=(diff_abs`i'>basediff_abs)
}

egen diff_count_greater = rowtotal(diff_greater*)
egen diff_count_lesser  = rowtotal(diff_lesser*)
egen diff_count_abs  = rowtotal(diff_anyabs*)
gen p_val_greater = diff_count_greater/`bootnum'
gen p_val_lesser = diff_count_lesser/`bootnum'
gen p_val_abs = diff_count_abs/`bootnum'

label var p_val_greater "Ha: H > L"
label var p_val_lesser "Ha: H < L"
label var p_val_abs "Ha: H!=L"

twoway (line p_val_abs x1 if x1<10, lcolor(black)),  ///
 bgcolor(white) graphregion(color(white)) ytitle("p-value") ylab(0 (0.1) 1) ytick(0 (0.05) 1, grid) ///
 yscale(r(0 0.3) titlegap(5)) ylabel(,gstyle(dot)) xla(0 "Nov" 1 "Dec" 2 "Jan" 3 "Feb" 4 "Mar" 5 "Apr" 6 "May" 7 "Jun" 8 "Jul" 9 "Aug") xtitle("") saving(g2_pval_abs_`x'km_wt, replace)
graph export "$plots2/pval_abs_p_`x'km_wt.pdf", replace 
}





*****************************
* Table J.8
*****************************

use "$main/cleanPriceData_Y1Y2.dta", clear

replace num_traders = sec_brokerbroker if MS ==1  

tab num_traders 
keep if in_sample == 1 

keep num_traders monthnum date MS hi_3km_wt hi_1km_wt hi_5km_wt in_sample market subloc_3km_grp

*get average num traders per month
bysort monthnum MS market: egen mean_num_traders = mean(num_traders)
replace num_traders = mean_num_traders
drop mean_num_traders
duplicates drop monthnum MS market, force 
gen log_num_traders=log(num_traders)

cap est drop reg*
gen interact = monthnum*hi_3km_wt

lab var	monthnum "Month"
lab var interact "High Intensity * Month"

gen hi = hi_3km_wt
label var hi "High"

*Y1
reg num_traders hi if in_sample == 1 & MS == 1, cl(subloc_3km_grp)
qui summ num_traders if  hi_3km_wt == 0 & MS == 1
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_y1_1

reg log_num_traders hi if in_sample == 1 & MS == 1, cl(subloc_3km_grp)
qui summ log_num_traders if  hi_3km_wt == 0 & MS == 1
estadd sca mdv = r(mean)
estadd loc spec "Log"
est sto reg_y1_2

reg num_traders hi monthnum interact if in_sample == 1 & MS == 1, cl(subloc_3km_grp)
qui summ num_traders if hi_3km_wt == 0 & MS == 1
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_y1_3

reg log_num_traders hi monthnum interact if in_sample == 1 & MS == 1, cl(subloc_3km_grp)
qui summ log_num_traders if hi_3km_wt == 0 & MS == 1
estadd sca mdv = r(mean)
estadd loc spec "Log"
est sto reg_y1_4

*Y2
reg num_traders hi  if in_sample == 1 & MS == 2, cl(subloc_3km_grp)
qui summ num_traders if  hi_3km_wt == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_y2_1

reg log_num_traders hi  if in_sample == 1 & MS == 2, cl(subloc_3km_grp)
qui summ log_num_traders if  hi_3km_wt == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc spec "Log"
est sto reg_y2_2

reg num_traders hi monthnum interact if in_sample == 1 & MS == 2, cl(subloc_3km_grp)
qui summ num_traders if hi_3km_wt == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_y2_3

reg log_num_traders hi monthnum interact if in_sample == 1 & MS == 2, cl(subloc_3km_grp)
qui summ log_num_traders if hi_3km_wt == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc spec "Log"
est sto reg_y2_4

*Pooled
reg num_traders hi  if in_sample == 1, cl(subloc_3km_grp)
qui summ num_traders if hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_p_1

reg log_num_traders hi  if in_sample == 1, cl(subloc_3km_grp)
qui summ log_num_traders if hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Log"
est sto reg_p_2

reg num_traders hi monthnum interact if in_sample == 1, cl(subloc_3km_grp)
qui summ num_traders if   hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_p_3

reg log_num_traders hi monthnum interact if in_sample == 1, cl(subloc_3km_grp)
qui summ log_num_traders if   hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Log"
est sto reg_p_4

*Pooled at other radii
replace hi = hi_1km_wt
replace interact = monthnum*hi_1km_wt

reg num_traders hi  if in_sample == 1, cl(subloc_3km_grp)
qui summ num_traders if hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_p_1_1km

reg num_traders hi monthnum interact if in_sample == 1, cl(subloc_3km_grp)
qui summ num_traders if   hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_p_3_1km

replace hi = hi_5km_wt
replace interact = monthnum*hi_5km_wt

reg num_traders hi  if in_sample == 1, cl(subloc_3km_grp)
qui summ num_traders if hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_p_1_5km

reg num_traders hi monthnum interact if in_sample == 1, cl(subloc_3km_grp)
qui summ num_traders if   hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc spec "Raw"
est sto reg_p_3_5km

esttab reg_y1_1 reg_y1_3 reg_y2_1 reg_y2_3  reg_p_1 reg_p_3 using "$tbls2/p_tradernum_effects_forpres.tex", drop( _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs." "mdv Mean of Dep Var" "r2 R squared"   ) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	nomtitles nonum ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7} ", pattern(1 0 1 0))



eststo clear



*****************************************************************
*Table J.6
*****************************************************************

use "$main/cleanPriceData_Y1Y2.dta", clear

preserve
keep if (month == "Nov" | month == "Oct" | month == "Dec") & (year==2012 | year == 2013) 
bysort year market: egen salesPrice_Nov_avg = mean(salesPrice) 
keep year market MS salesPrice_Nov_avg
duplicates drop
save "$temp/nov_price_avg.dta", replace
restore

preserve
keep if ((month == "Dec" | month == "Nov") & (year==2012 | year == 2013)) | (month=="Jan" & (year == 2013 | year == 2014)) 
bysort MS market: egen salesPrice_Dec_avg = mean(salesPrice)
keep year market MS salesPrice_Dec_avg
duplicates drop market MS salesPrice_Dec_avg, force
save "$temp/dec_price_avg.dta", replace
restore

preserve
keep if (month == "Jun" | month == "May" | month == "Jul") & (year==2014 | year == 2013) 
bysort year market: egen salesPrice_Jun_avg = mean(salesPrice) 
keep year market MS salesPrice_Jun_avg
duplicates drop
save "$temp/jun_price_avg.dta", replace
restore

preserve
keep if (month == "Aug" | month == "Jul" | month == "Sep") & (year==2014 | year == 2013) 
bysort year market: egen salesPrice_Aug_avg = mean(salesPrice) 
keep year market MS salesPrice_Aug_avg
drop MS
gen MS = 1 if year == 2013 
replace MS = 2 if year == 2014
duplicates drop
save "$temp/aug_price_avg.dta", replace
restore

preserve
keep if (month == "Nov") & (year==2012 | year == 2013)  
rename salesPrice salesPrice_Nov
keep salesPrice_Nov  month year market MS  hi_3km_wt  subloc_3km_wt subloc_3km_wt_grp
duplicates drop
save "$temp/nov_price.dta", replace
restore

preserve
keep if (month == "Dec") & (year==2012 | year == 2013) 
rename salesPrice salesPrice_Dec
keep salesPrice_Dec  month year market MS hi_3km_wt  subloc_3km_wt subloc_3km_wt_grp
duplicates drop
save "$temp/dec_price.dta", replace
restore

preserve
keep if month == "Aug" & (year==2013 | year == 2014) 
rename salesPrice salesPrice_Aug
keep salesPrice_Aug  market MS 
duplicates drop
duplicates tag market MS, gen(dup)
list if dup !=0 
duplicates drop
collapse salesPrice_Aug, by(market MS)
save "$temp/aug_price.dta", replace
restore

keep if month == "Jun" & (year==2013 | year == 2014) 
keep salesPrice market MS 
rename salesPrice salesPrice_Jun
duplicates drop
duplicates tag market MS, gen(dup)
list if dup !=0 
collapse salesPrice_Jun, by(market MS)
merge 1:1 market MS using "$temp/nov_price.dta", nogen
merge 1:1 market MS using "$temp/dec_price.dta", nogen
merge 1:1 market MS using "$temp/aug_price.dta", nogen
merge 1:1 market MS using "$temp/nov_price_avg.dta", nogen
merge 1:1 market MS using "$temp/dec_price_avg.dta", nogen
merge 1:1 market MS using "$temp/jun_price_avg.dta", nogen
merge 1:1 market MS using "$temp/aug_price_avg.dta", nogen

foreach x in Nov Dec Jun Aug {
replace salesPrice_`x' = salesPrice_`x'_avg if salesPrice_`x' == .  

}

foreach x in Nov Dec Jun Aug {
di "`x'" 
list market MS salesPrice_`x' if salesPrice_`x' == . 
}

gen price_chg_NovJun = (salesPrice_Jun - salesPrice_Nov)/salesPrice_Nov
gen price_chg_NovAug = (salesPrice_Aug - salesPrice_Nov)/salesPrice_Nov
gen price_chg_DecJun = (salesPrice_Jun - salesPrice_Dec)/salesPrice_Dec
gen price_chg_DecAug = (salesPrice_Aug - salesPrice_Dec)/salesPrice_Dec

foreach x in NovJun NovAug DecJun DecAug {
tab price_chg_`x' 
}

*Price changes
foreach x in Nov Dec {
foreach y in Jun Aug {

reg price_chg_`x'`y' hi_3km_wt if MS==1, cl(subloc_3km_wt_grp) // Y1
qui summ price_chg_`x'`y' if hi_3km_wt == 0 & MS == 1
estadd sca mdv = r(mean)
estadd loc samp "MS1"
eststo r_`x'_`y'_pricegap_Y1

reg price_chg_`x'`y' hi_3km_wt if MS==2, cl(subloc_3km_wt_grp) // Y2 
qui summ price_chg_`x'`y' if hi_3km_wt == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc samp "MS2"
eststo r_`x'_`y'_pricegap_Y2

reg price_chg_`x'`y' hi_3km_wt, cl(subloc_3km_wt_grp) // pooled
qui summ price_chg_`x'`y' if hi_3km_wt == 0
estadd sca mdv = r(mean)
estadd loc samp "Pooled"
eststo r_`x'_`y'_pricegap_p
	
}
}

label var hi_3km_wt "High"

esttab r_Nov_Jun_pricegap_Y1 r_Nov_Jun_pricegap_Y2 r_Nov_Jun_pricegap_p  ///
using "$tbls2/pricegap_NovJun.tex", drop(_cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs" "mdv Mean DV" "r2 R squared") ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y1" "Pooled") 



eststo clear 





***********************************************************************
*Table J.3
***********************************************************************

use "$main/cleanPriceData_Y1Y2.dta", clear
 
foreach x in 1 3 5  {
gen ratio`x'km_wt = treatfarm`x'km/totfarm`x'km_wt 
replace ratio`x'km_wt = 0 if totfarm`x'km_wt == 0 
}

*ratio Miguel and Kremer
gen ratio = .
gen ratio_month = .
gen interact_lean = .
gen totfarm = .
gen totfarm_month = .

lab var ratio "Ratio"
lab var	monthnum "Month"
lab var ratio_month "Ratio * Month"
label var interact_lean "Ratio * Lean"

foreach x in 1km_wt 3km_wt 5km_wt  {
preserve

sum salesPrice_trim if monthnum==0 & hi_`x'==0
local norm = 100/r(mean)
gen salesPrice_trim_norm = salesPrice_trim*`norm' // normalized so that mean prices in low intensity areas in November is 100

replace ratio = ratio`x'
replace ratio_month = ratio`x'*monthnum
replace totfarm = totfarm`x'
replace totfarm_month = totfarm`x'*monthnum

replace interact_lean = lean*ratio

*Y1
reg salesPrice_trim_norm ratio monthnum ratio_month  if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if MS == 1 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if  MS == 1 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_y1_`x'

reg salesPrice_trim_norm ratio lean interact_lean   if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if MS == 1 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if  MS == 1 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_binary_y1_`x'

reg log_salesPrice_trim ratio monthnum ratio_month   if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ log_salesPrice_trim if MS == 1 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if  MS == 1 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_log_y1_`x'

reg log_salesPrice_trim ratio lean interact_lean   if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ log_salesPrice_trim if MS == 1 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if  MS == 1 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_binary_log_y1_`x'

*Y2
reg salesPrice_trim_norm ratio monthnum ratio_month   if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ salesPrice_trim if MS == 2 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if MS == 2 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_y2_`x'

reg salesPrice_trim_norm ratio lean interact_lean   if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ salesPrice_trim if MS == 2 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if MS == 2 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_binary_y2_`x'

reg log_salesPrice_trim ratio monthnum ratio_month   if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ log_salesPrice_trim if MS == 2 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if MS == 2 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_log_y2_`x'

reg log_salesPrice_trim ratio lean interact_lean   if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ log_salesPrice_trim if MS == 2 & in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if MS == 2 & in_sample == 1
estadd sca ratio =r(mean)
est sto reg_binary_log_y2_`x'

*Pooled
reg salesPrice_trim_norm ratio monthnum ratio_month   if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if  in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if in_sample == 1
estadd sca ratio =r(mean)
est sto reg_p_`x'

reg salesPrice_trim_norm ratio lean interact_lean   if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if  in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if in_sample == 1
estadd sca ratio =r(mean)
est sto reg_binary_p_`x'

reg log_salesPrice_trim ratio monthnum ratio_month    if in_sample == 1, cl(subloc_`x'_grp)
qui summ log_salesPrice_trim if  in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if in_sample == 1
estadd sca ratio =r(mean)
est sto reg_log_p_`x'

reg log_salesPrice_trim ratio lean interact_lean   if in_sample == 1, cl(subloc_`x'_grp)
qui summ log_salesPrice_trim if  in_sample == 1
estadd sca mdv = r(mean)
qui sum ratio if in_sample == 1
estadd sca ratio =r(mean)
est sto reg_binary_log_p_`x'

restore
}


esttab reg_y1_3km_wt reg_y2_3km_wt reg_p_3km_wt reg_p_1km_wt reg_p_5km_wt using "$tbls2/price_effects_MK.tex", drop( _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs." "r2 R squared" ) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2"  "Pooled" "1km" "5km" "Binary, 3km") nonum ///
	mgroups("\multicolumn{3}{c}{Main Specification (3km)} & \multicolumn{2}{c}{Robustness (Pooled)}  \\ \cline{2-4} \cline{5-6}", pattern(1 0 1 0))


eststo clear


**********************************************************************
* Figure J.1
**********************************************************************

use "$main/cleanPriceData_Y1Y2.dta", clear

foreach x in 1 3 5 {
gen treatfarm`x'km_wt = treatfarm`x'km
}
 
foreach x in 1km 3km 5km  1km_wt 3km_wt 5km_wt  {
gen ratio`x' = treatfarm`x'/totfarm`x'
replace ratio`x' = 0 if totfarm`x' == 0 
sum ratio`x', det
gen ratio`x'_abvmean = (ratio`x'>r(p50))
replace ratio`x'_abvmean = . if ratio`x'==.
gen ratio`x'_bin=1 if ratio`x'<=r(p25)
replace ratio`x'_bin=2 if ratio`x'>r(p25) & ratio`x'<=r(p50)
replace ratio`x'_bin=3 if ratio`x'>r(p50) & ratio`x'<=r(p75)
replace ratio`x'_bin=4 if ratio`x'>r(p75) & ratio`x'!=.
}

*bootstrap fanreg with log prices
foreach x in 1km 3km 5km  1km_wt 3km_wt 5km_wt  {
preserve
keep if in_sample == 1 & MS == 1
keep log_salesPrice_trim monthnum date ratio`x'_abvmean ratio`x'_bin subloc_`x' salesPrice_trim
rename ratio`x'_abvmean ratio_abvmean
rename ratio`x'_bin ratio_bin
rename subloc_`x' subloc
save "$temp/priceBootstrap_ratio_Y1_`x'.dta", replace
restore
}

foreach x in 1km 3km 5km  1km_wt 3km_wt 5km_wt  {
preserve
keep if in_sample == 1 & MS == 2
replace date = date - 365 // align dates with Y1
keep log_salesPrice_trim monthnum date ratio`x'_abvmean ratio`x'_bin subloc_`x' salesPrice_trim
rename ratio`x'_abvmean ratio_abvmean
rename ratio`x'_bin ratio_bin
rename subloc_`x' subloc
save "$temp/priceBootstrap_ratio_Y2_`x'.dta", replace
restore
}

foreach x in 1km 3km 5km  1km_wt 3km_wt 5km_wt  {
preserve
keep if in_sample == 1
replace date = date - 365 if MS == 2 // align dates with Y1
keep log_salesPrice_trim monthnum date ratio`x'_abvmean ratio`x'_bin subloc_`x' salesPrice_trim
rename ratio`x'_abvmean ratio_abvmean
rename ratio`x'_bin ratio_bin
rename subloc_`x' subloc
save "$temp/priceBootstrap_ratio_p_`x'.dta", replace
restore
}

**Above/Below Median**

foreach x in 1km_wt 3km_wt 5km_wt {
foreach z in p {
use "$temp/priceBootstrap_ratio_`z'_`x'.dta", clear
sort date monthnum log_salesPrice_trim ratio_abvmean subloc
set seed 362436
qui fanreg log_salesPrice_trim date if ratio_abvmean==0, xgen(x1) ygen(y1) reps(1) bw(3) //run once to initialize x length
keep if x1<.
keep x1
gen obs = _n
save "$temp/priceBootstrap_ratio_`z'_`x'_fan1.dta", replace

//forvalues i = 1/3 {
forvalues i = 1/1000 { 
	use "$temp/priceBootstrap_ratio_`z'_`x'", clear
	sort date monthnum log_salesPrice_trim ratio_abvmean subloc
	bsample, cluster(subloc)  //draw clusters with replacement
	capture {
	qui fanreg log_salesPrice_trim date if ratio_abvmean==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg log_salesPrice_trim date if ratio_abvmean==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen diff`i' = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs diff`i'
	qui merge 1:1 obs using "$temp/priceBootstrap_ratio_`z'_`x'_fan1", nogen
	qui	save "$temp/priceBootstrap_ratio_`z'_`x'_fan1", replace
	}
	di "`i'"
	
}

use "$temp/priceBootstrap_ratio_`z'_`x'", clear
	sort date monthnum log_salesPrice_trim ratio_abvmean subloc
	qui fanreg log_salesPrice_trim date if ratio_abvmean==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg log_salesPrice_trim date if ratio_abvmean==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen est_mean  = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs est_mean x1
	save "$temp/priceBootstrap_`z'_`x'_ratiofig", replace
	keep obs est_mean 
	merge 1:1 obs using "$temp/priceBootstrap_ratio_`z'_`x'_fan1", nogen

egen est_sd = rowsd(diff*)
replace est_mean = est_mean*100  //put in easy to read percentages
replace est_sd = est_sd*100
gen lower = est_mean - 1.96*est_sd
gen upper = est_mean + 1.96*est_sd
gen lower_90 = est_mean - 1.645*est_sd
gen upper_90 = est_mean + 1.645*est_sd
gen y_temp = 0


format x1 %td

twoway (rarea lower upper x1 if x1>1, col(gs13)  xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon))) ///
	(rarea lower_90 upper_90 x1 if x1>1, col(gs10)) ///
	 (line est_mean x1 if x1>1, yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1, saving(g1_`z'_`x'_ratio, replace))

twoway (line lower lower_90 upper upper_90 est_mean x1 if x1>1, scheme(s1mono) lw(medium medium medium medium thick) lp(dash solid dash solid solid) lc(gs10 gs7 gs10 gs7 black) ////
 yline(0) legend(on order(5 "Pt Est" 1 "95% CI" 2 "90% CI") rows(1) pos(6) ring(0) region(ls(none))) xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) saving(g1_`z'_`x'_ratio_alt, replace)) 
	
use "$temp/priceBootstrap_ratio_`z'_`x'", clear
	qui fanreg salesPrice_trim date if ratio_abvmean==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg salesPrice_trim date if ratio_abvmean==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
format x1 %td
twoway line y1 y2 x1 if x1>1, xtitle("") ytitle("Price (Ksh/goro)") lc(black black) lp(dash solid) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "Low") label(2 "High") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono) saving(g2_`z'_`x'_ratio, replace)

cap drop y_temp

}
}


foreach x in  3km_wt  {
foreach z in  p {
use "$temp/priceBootstrap_`z'_3km_wt_ratiofig", clear
rename est_mean est_mean_3km_wt
replace est_mean_3km_wt = est_mean_3km_wt*100
rename x1 x1_3km_wt
merge 1:1 obs using "$temp/priceBootstrap_`z'_1km_wt_ratiofig", nogen
rename est_mean est_mean_1km_wt
replace est_mean_1km_wt = est_mean_1km_wt*100
rename x1 x1_1km_wt
merge 1:1 obs using "$temp/priceBootstrap_`z'_5km_wt_ratiofig", nogen
rename est_mean est_mean_5km_wt
replace est_mean_5km_wt = est_mean_5km_wt*100
rename x1 x1_5km_wt
format x1_3km_wt %td
twoway line est_mean_1km_wt est_mean_3km_wt est_mean_5km_wt x1_3km_wt if x1_3km_wt>1, yline(0) xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)") lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono)  saving(g4_`z'_MK, replace)

}
}


*Main Figure
graph combine g2_p_3km_wt_ratio.gph g1_p_3km_wt_ratio.gph g4_p_MK.gph, xsize(18) ysize(6) scheme(s1mono) rows(1)
graph export "$plots2/market_logprice_main_MK_3km_wt.pdf", as(pdf) replace


clear



******************
*Table G.9
******************

use "$main/cleanPriceData_Y1Y2.dta", clear

gen hi = .
gen interact=.

foreach x in 1km_wt 3km_wt 5km_wt  {
preserve

sum salesPrice_trim if monthnum==0 & hi_`x'==0 & LRFU == 1
local norm = 100/r(mean)
gen salesPrice_trim_norm = salesPrice_trim*`norm' // normalized so that mean prices in low intensity areas in November is 100

replace hi = hi_`x'
replace interact = monthnum*hi

*LRFU
reg salesPrice_trim_norm hi monthnum interact if LRFU == 1, cl(subloc_`x'_grp)
 summ salesPrice_trim_norm if monthnum==0 & hi == 0 & LRFU == 1
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_lrfu_`x'


restore
}

lab var hi "High"
lab var	monthnum "Month"
lab var interact "High Intensity * Month"

esttab reg_lrfu_3km_wt reg_lrfu_1km_wt reg_lrfu_5km_wt using "$tbls2/p_price_effects_lrfu.tex", drop( _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs." "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("3km" "1km" "5km") nonum 



eststo clear

************************************
*Figure J.5
************************************

use "$main/cleanPriceData_Y1Y2.dta", clear

*Fan reg with different BW
set seed 362436
preserve
keep if in_sample == 1
replace date = date - 365 if MS == 2 // align dates with Y1
keep log_salesPrice_trim monthnum date hi_3km subloc_3km salesPrice_trim
rename hi_3km hi
rename subloc_3km subloc
save "$temp/priceBootstrap_p_3km_RTband.dta", replace
restore

local i = 0
foreach y in 2 1.33 1 0.67 0.5 { // in  fanreg.ado, Bandwidth h = (`xmax' - `xmin') / `bw', so 2x bw is half the bandwidth
local i = `i' + 1
local bw = `y'*3 // 3 is the original bandwidth used
use "$temp/priceBootstrap_p_3km_RTband", clear
	sort date monthnum log_salesPrice_trim hi subloc
	qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(`bw')
	qui fanreg log_salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(`bw')
	gen est_mean`i'  = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs est_mean x1
	save "$temp/priceBootstrap_p_3km_mainfig_RTband`i'", replace
}

*Main Figure

use "$temp/priceBootstrap_p_3km_mainfig_RTband1", clear
replace est_mean1  = est_mean1*100
rename x1 x1_1
forval i = 2/5{
merge 1:1 obs using "$temp/priceBootstrap_p_3km_mainfig_RTband`i'", nogen
replace est_mean`i'  = est_mean`i'*100
rename x1 x1_`i'
}
format x1_1  %td

twoway line est_mean* x1_1 if x1_1 >1, yline(0) xtitle("") ylabel(-7(2)7) ytitle("Difference in price (%)" , height(5)) ///
	lc(blue blue black red red) lp(shortdash longdash solid longdash shortdash) lw(t medium medium medium medium) scheme(s1mono)  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "0.5x BW") label(2 "0.75x BW") label(3 "BW") label(4 "1.5x BW") label(5 "2x BW") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny) size(small) symxsize(*0.75)) ///
	saving(g3_p_main_modal_RTband, replace)
graph export "$plots2/price_effects_robust_band.png", replace 




***********************************
*Table J.2
***********************************

use "$main/cleanPriceData_Y1Y2.dta", clear

gen round1 = 0 if in_sample==1
replace round1 = 1 if (monthnum >= 0 & monthnum<=1) & (year == 2012 | year == 2013) 
replace round1 = 1 if (monthnum >= 2 & monthnum<=3) & (year == 2013 | year == 2014)

gen round2 = 0 if in_sample==1
replace round2 = 1 if (monthnum >= 4 & monthnum<=6) & (year == 2013 | year == 2014) 

gen round3 = 0 if in_sample==1
replace round3 = 1 if (monthnum >= 7 & monthnum<=9) & (year == 2013 | year == 2014) 

gen hi = .
forval i = 1/3{
gen inter_r`i'=.
}

foreach x in 1km_wt 3km_wt 5km_wt {
preserve

sum salesPrice_trim if monthnum==0 & hi_`x'==0
local norm = 100/r(mean)
gen salesPrice_trim_norm = salesPrice_trim*`norm' // normalized so that mean prices in low intensity areas in November is 100

replace hi = hi_`x'
forval i = 1/3{
replace inter_r`i'= round`i'*hi
}

*Y1
reg salesPrice_trim_norm inter_r* round2 round3 if in_sample==1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 1  & in_sample == 1
estadd sca mdv = r(mean)
test inter_r1 = inter_r3
estadd sca pc = r(p)
est sto reg_y1_`x'


*Y2
reg salesPrice_trim_norm inter_r*  round2 round3 if MS == 2 & in_sample==1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 2  & in_sample == 1
estadd sca mdv = r(mean)
test inter_r1 = inter_r3
estadd sca pc = r(p)
est sto reg_y2_`x'

*Pooled
reg salesPrice_trim_norm inter_r* round2 round3 if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & in_sample == 1
estadd sca mdv = r(mean)
test inter_r1 = inter_r3 
estadd sca pc = r(p)
est sto reg_p_`x'

restore
}

lab var hi "High"

lab var	monthnum "Month"
forval i = 1/3{
label var round`i' "R`i'"
label var inter_r`i' "High - R`i'"
}

esttab reg_y1_3km_wt reg_y2_3km_wt reg_p_3km_wt reg_p_1km_wt reg_p_5km_wt using "$tbls2/price_effects_main_robustrounds1.tex", keep(inter_r*) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs." "r2 R squared" "pc P-Val High R1 = High R3") ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2"  "Pooled" "1km" "5km") nonum ///
	mgroups("\multicolumn{3}{c}{Main Specification (3km)} & \multicolumn{2}{c}{Robustness (Pooled)}  \\ \cline{2-4} \cline{5-6}", pattern(1 0 1 0))


	
eststo clear


*****************************
* Table J.4
*****************************

use "$main/cleanPriceData_Y1Y2.dta", clear

gen hi = .
gen interact=.
gen interact_lean = .


foreach x in 1km 3km 5km  {
preserve

sum salesPrice_trim if monthnum==0 & hi_`x'==0
local norm = 100/r(mean)
gen salesPrice_trim_norm = salesPrice_trim*`norm' // normalized so that mean prices in low intensity areas in November is 100

replace hi = hi_`x'
replace interact = monthnum*hi
replace interact_lean = lean*hi

*Y1
reg salesPrice_trim_norm hi monthnum interact if in_sample==1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 1  & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_y1_`x'

reg salesPrice_trim_norm hi lean interact_lean if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if lean == 0 & hi == 0 & MS == 1
estadd sca mdv = r(mean)
est sto reg_binary_y1_`x'

reg log_salesPrice_trim hi monthnum interact if in_sample==1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if hi == 0 & MS == 1  & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_log_y1_`x'

reg log_salesPrice_trim hi lean interact_lean if in_sample == 1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if lean == 0 & hi == 0 & MS == 1
estadd sca mdv = r(mean)
est sto reg_log_binary_y1_`x'

*Y2
reg salesPrice_trim_norm hi monthnum interact  if MS == 2 & in_sample==1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 2  & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_y2_`x'

reg salesPrice_trim_norm hi lean interact_lean if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if lean == 0 & hi == 0 & MS == 2
estadd sca mdv = r(mean)
est sto reg_binary_y2_`x'

reg log_salesPrice_trim hi monthnum interact  if MS == 2 & in_sample==1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if hi == 0 & MS == 2  & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_log_y2_`x'

reg log_salesPrice_trim hi lean interact_lean if in_sample == 1 & MS == 2, cl(subloc_`x'_grp)
qui summ salesPrice_trim if lean == 0 & hi == 0 & MS == 2
estadd sca mdv = r(mean)
est sto reg_log_binary_y2_`x'

*Pooled
reg salesPrice_trim_norm hi monthnum interact if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_p_`x'

reg salesPrice_trim_norm hi lean interact_lean if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if lean == 0 & hi == 0
estadd sca mdv = r(mean)
est sto reg_binary_p_`x'

reg log_salesPrice_trim hi monthnum interact if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if hi == 0 & in_sample == 1
estadd sca mdv = r(mean)
est sto reg_log_p_`x'

reg log_salesPrice_trim hi lean interact_lean if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim if lean == 0 & hi == 0
estadd sca mdv = r(mean)
est sto reg_log_binary_p_`x'


restore
}

lab var hi "High"
lab var	monthnum "Month"
lab var interact "High Intensity * Month"
lab var interact_lean "High Intensity * Lean"

esttab reg_y1_3km reg_y2_3km reg_p_3km reg_p_1km reg_p_5km using "$tbls2/price_effects_main_robusttemp.tex", drop( _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Obs." "r2 R squared" ) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2"  "Pooled" "1km" "5km" "Binary, 3km") nonum ///
	mgroups("\multicolumn{3}{c}{Main Specification (3km)} & \multicolumn{2}{c}{Robustness (Pooled)}  \\ \cline{2-4} \cline{5-6}", pattern(1 0 1 0))



eststo clear


*******************************
*  Figure J.2
*******************************


use "$main/cleanPriceData_Y1Y2.dta", clear

*bootstrap fanreg with log prices
foreach x in 1km 3km 5km  {
preserve
keep if in_sample == 1 & MS == 1
keep log_salesPrice_trim monthnum date hi_`x' subloc_`x' salesPrice_trim
rename hi_`x' hi
rename subloc_`x' subloc
save "$temp/priceBootstrap_Y1_`x'_RT.dta", replace
restore
}

foreach x in 1km 3km 5km  {
preserve
keep if in_sample == 1 & MS == 2
replace date = date - 365 // align dates with Y1
keep log_salesPrice_trim monthnum date hi_`x' subloc_`x' salesPrice_trim
rename hi_`x' hi
rename subloc_`x' subloc
save "$temp/priceBootstrap_Y2_`x'_RT.dta", replace
restore
}
  
foreach x in 1km 3km 5km  {
preserve
keep if in_sample == 1
replace date = date - 365 if MS == 2 // align dates with Y1
keep log_salesPrice_trim monthnum date hi_`x' subloc_`x' salesPrice_trim
rename hi_`x' hi
rename subloc_`x' subloc
save "$temp/priceBootstrap_p_`x'_RT.dta", replace
restore
}

foreach x in  1km 3km 5km {
foreach z in p {
use "$temp/priceBootstrap_`z'_`x'_RT.dta", clear
sort date monthnum log_salesPrice_trim hi subloc
set seed 362436
qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) bw(3) //run once to initialize x length
keep if x1<.
keep x1
gen obs = _n
save "$temp/priceBootstrap_`z'_`x'_fan1_RT.dta", replace

local k = 362436
//forvalues i = 1/3 { 
forvalues i = 1/1000 { 
	use "$temp/priceBootstrap_`z'_`x'_RT", clear
	local k = `k' + 1
	set seed `k'
	sort date monthnum log_salesPrice_trim hi subloc
	bsample, cluster(subloc)  //draw clusters with replacement
	capture {
	qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg log_salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen diff`i' = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs diff`i'
	qui merge 1:1 obs using "$temp/priceBootstrap_`z'_`x'_fan1_RT", nogen
	qui	save "$temp/priceBootstrap_`z'_`x'_fan1_RT", replace
	}
	di "`i'"
	
}


use "$temp/priceBootstrap_`z'_`x'_RT", clear
	sort date monthnum log_salesPrice_trim hi subloc
	qui fanreg log_salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3) 
	qui fanreg log_salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
	gen est_mean  = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs est_mean x1
	save "$temp/priceBootstrap_`z'_`x'_mainfig_RT", replace
	keep obs est_mean 
	merge 1:1 obs using "$temp/priceBootstrap_`z'_`x'_fan1_RT", nogen

egen est_sd = rowsd(diff*)
replace est_mean = est_mean*100  //put in easy to read percentages
replace est_sd = est_sd*100
gen lower = est_mean - 1.96*est_sd
gen upper = est_mean + 1.96*est_sd
gen lower_90 = est_mean - 1.645*est_sd
gen upper_90 = est_mean + 1.645*est_sd
gen y_temp = 0

format x1 %td

*standardize graphs 
foreach y in upper upper_90 {
gen temp_`y' = `y'
replace temp_`y' = 7 if `y' > 7 & `y'!=.
}

foreach y in lower lower_90 {
gen temp_`y' = `y'
replace temp_`y' = -7 if `y' < -7 & `y'!=.
}

*graphs

twoway (rarea lower upper x1 if x1>1, col(gs13)  xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon))) ///
	(rarea lower_90 upper_90 x1 if x1>1, col(gs10)) ///
	 (line est_mean x1 if x1>1, yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1, saving(g1_`z'_`x'_modal_RT, replace))

twoway (line lower lower_90 upper upper_90 est_mean x1 if x1>1, scheme(s1mono) lw(medium medium medium medium thick) lp(dash solid dash solid solid) lc(gs10 gs7 gs10 gs7 black) ////
 yline(0) legend(on order(5 "Pt Est" 1 "95% CI" 2 "90% CI") rows(1) pos(6) ring(0) region(ls(none))) xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) saving(g1_`z'_`x'_modal_alt_RT, replace)) 

	twoway (rarea temp_lower temp_upper x1 if x1>1, col(gs13)  xtitle("") ylabel(-7(2)7) ytitle("Difference in price (%)")  ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon))) ///
	(rarea temp_lower_90 temp_upper_90 x1 if x1>1, col(gs10)) ///
	 (line est_mean x1 if x1>1, yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1, saving(g1_`z'_`x'_modal_alt2_RT, replace))
	
use "$temp/priceBootstrap_`z'_`x'_RT", clear
	qui fanreg salesPrice_trim date if hi==0, xgen(x1) ygen(y1) reps(1) graph(off) bw(3)
	qui fanreg salesPrice_trim date if hi==1, xgen(x2) ygen(y2) reps(1) graph(off) bw(3)
format x1 %td
twoway line y1 y2 x1 if x1>1, xtitle("") ytitle("Price (Ksh/goro)") lc(black black) lp(dash solid) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "Lo") label(2 "Hi") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono) saving(g2_`z'_`x'_modal_RT, replace)

}
}

*Main Figure

foreach z in p {
use "$temp/priceBootstrap_`z'_3km_mainfig_RT", clear
rename est_mean est_mean_3km
replace est_mean_3km  = est_mean_3km*100
rename x1 x1_3km 
merge 1:1 obs using "$temp/priceBootstrap_`z'_1km_mainfig_RT", nogen
rename est_mean est_mean_1km 
replace est_mean_1km  = est_mean_1km *100
rename x1 x1_1km 
merge 1:1 obs using "$temp/priceBootstrap_`z'_5km_mainfig_RT", nogen
rename est_mean est_mean_5km 
replace est_mean_5km  = est_mean_5km *100
rename x1 x1_5km 
format x1_3km  %td
twoway line est_mean_1km  est_mean_3km  est_mean_5km  x1_3km  if x1_3km >1, yline(0) xtitle("") ylabel(-10(2)8) ytitle("Difference in price (%)") lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono)  saving(g3_`z'_main_modal_RT, replace)
	
twoway line est_mean_1km  est_mean_3km  est_mean_5km  x1_3km  if x1_3km >1, yline(0) xtitle("") ylabel(-7(2)7) ytitle("Difference in price (%)") lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono)  saving(g3_`z'_main_modal_alt2_RT, replace)
	
twoway line est_mean_1km  est_mean_3km  est_mean_5km  x1_3km  if x1_3km >1, yline(0) xtitle("") ylabel(-5(2)5) ytitle("Difference in price (%)") lc(black black black) lp(dash solid shortdash) lw(medium thick medium) ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 01sept2013, format(%tdMon)) ///
	legend(label(1 "1km") label(2 "3km") label(3 "5km") rows(1) pos(6) ring(0) region(ls(none)) bmargin(tiny)) scheme(s1mono) 
graph export "$plots2/market_logprice_main_modal_radiirobus_`z'_forpres_RT.pdf", as(pdf) replace


graph combine "$temp/g2_`z'_3km_modal_RT.gph" "$temp/g1_`z'_3km_modal_alt2_RT.gph" "$temp/g3_`z'_main_modal_alt2_RT.gph", xsize(6) ysize(16) scheme(s1mono) rows(3)
graph export "$plots2/market_logprice_main_modal_`z'_alt2_RT.pdf", as(pdf) replace


}






*********************
*  Table G.1
*********************
	
set seed 2039572039

*prep hi-lo treat intens
use "$main/MS1MS2_pooled.dta", clear
replace oafid = fr_id if MS == 2
drop if hi == .
drop if oafid == .
duplicates drop oafid hi, force
duplicates report oafid 
keep oafid hi subloc
rename oafid fid 
save "$temp/fid_hi.dta", replace

*bring in LFRU data
use "$main/LRFU_select_dataset.dta", clear

tab treatms1 treatms2, missing
tab sample treatms1, missing
tab sample treatms2, missing


gen treat_both = treatms1* treatms2

label var treatms1 "Treat Y1"
label var treatms2 "Treat Y2"
label var treat_both "Treat Y1*Y2"

rename date interviewdate

merge 1:1 fid using "$temp/fid_hi.dta"
drop if _m ==2 
drop _m

gen treatms1_hi = treatms1*hi
gen treatms2_hi = treatms2*hi

tab treatms1 treatms2, missing

gen ever_treated = (treatms1 == 1 | treatms2 == 1)
label var ever_treated "Ever Treated"
gen ever_treated_hi = ever_treated*hi
label var ever_treated_hi "Ever Treated*Hi"
gen y2_sample = (sample=="MS2only" | sample=="MS1&2")

*generate placebo Y2 treatment status for the Y1 to Y2 attriters
gen y1attrit = 1 if treatms1 != . & treatms2 == .

gen rand = uniform() if y1attrit == 1 
egen rank = rank(rand)  if y1attrit == 1
sum rank
gen temp_treatms2_rand = treatms2
replace temp_treatms2_rand = 0 if rank < `r(mean)' & y1attrit == 1
replace temp_treatms2_rand = 1 if rank >= `r(mean)' & y1attrit == 1
drop rand rank

gen temp_treatms2_t = treatms2
replace temp_treatms2_t = 1 if y1attrit == 1

gen temp_treatms2_c = treatms2
replace temp_treatms2_c = 0 if y1attrit == 1

gen temp_treatms2_act = treatms2
gen temp_treat_both_act = treat_both
gen temp_treat_both_rand = treatms1 * temp_treatms2_rand
gen temp_treat_both_t = treatms1 * temp_treatms2_t
gen temp_treat_both_c = treatms1 * temp_treatms2_c

drop y1attrit


rename netrevenueLR2014_plus_trim nrLR2014_plus_trim
gen prct_hi_sales = amt_sold_hi/(amt_sold_lo+amt_sold_hi)
gen prct_lo_purch = amt_purch_cons_lo/(amt_purch_cons_lo+amt_purch_cons_hi)
label var prct_hi_sales "Percent Sales Lean"
label var prct_lo_purch "Percent Purchases Harvest"

foreach var in amt_harvest2014LR_trim netsalesLR2014_trim prct_hi_sales prct_lo_purch nrLR2014_plus_trim {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}

}


esttab r*netsalesLR2014_trim r*prct_hi_sales r*prct_lo_purch r*nrLR2014_plus_trim using "$tbls3/main_LRFU.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("ymean Mean DV" "sd SD DV" "N Observations" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles  ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Net Sales} & \multicolumn{3}{c}{Percent Sold Lean} & \multicolumn{3}{c}{Percent Purchased Harvest}  & \multicolumn{3}{c}{Revenues} \\ \cline{2-4} \cline{5-7} \cline{8-10} \cline{11-13}", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0))


*******************************
*  Table G.2
*******************************

cap est drop r* p* 

foreach var in amt_sold2014LR_trim val_sold2014LR_trim amt_purch2014LR_trim val_purch2014LR_trim {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}

}

esttab r* using "$tbls3/sales_and_purch_LRFU.tex", drop(interviewdate _cons) ///
replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles  ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Amount Sold} & \multicolumn{3}{c}{Value Sold} & \multicolumn{3}{c}{Amount Purchased}  & \multicolumn{3}{c}{Value Purchased}  \\ \cline{2-4} \cline{5-7} \cline{8-10} \cline{11-13} ", ///
	pattern(1 0 0 1 0 0 1 0 0 1 0 0 ))

	


cap est drop r* p*

*******************************
*  Table G.3
*******************************

	
foreach var in amt_sold_lo_trim val_sold_lo_trim amt_sold_hi_trim val_sold_hi_trim {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}

}

esttab r*  using "$tbls3/sales_LRFU_by_season.tex", drop(interviewdate _cons) ///
replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles  ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Harvest Amount}  & \multicolumn{3}{c}{Harvest Value} & \multicolumn{3}{c}{Lean Amount}  & \multicolumn{3}{c}{Lean Value}  \\ \cline{2-4} \cline{5-7} \cline{8-10} \cline{11-13}  ", ///
	pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 ))



cap est drop r* p*

*******************************
*  Table G.4
*******************************

foreach var in  amt_purch_cons_lo_trim val_purch_lo_trim amt_purch_cons_hi_trim val_purch_hi_trim  {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}


}


esttab r* using "$tbls3/purch_LRFU_by_season.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles  ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Harvest Amount}  & \multicolumn{3}{c}{Harvest Value} & \multicolumn{3}{c}{Lean Amount}  & \multicolumn{3}{c}{Lean Value} \\ \cline{2-4} \cline{5-7} \cline{8-10} \cline{11-13} ", ///
	pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 ))


cap est drop r* p*


**********************************
* Table G.5
**********************************

rename total_input_cost_maize2015_trim input_trim
rename total_labor_days_maize2015_trim labor_trim

foreach var in labor_trim input_trim amt_harvested2015LR {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}

}


esttab r* using "$tbls3/LRFU_2015_havest_inputs.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Labor Person-Days}  & \multicolumn{3}{c}{Non-Labor Input Expenditure} & \multicolumn{3}{c}{2015 Harvest}  \\ \cline{2-4} \cline{5-7} \cline{8-10} ", ///
	pattern(1 0 0 1 0 0 1 0 0 ))




cap est drop r* p*

rename input_trim total_input_cost_maize2015_trim
rename labor_trim total_labor_days_maize2015_trim


********************************
* Table G.6
********************************

foreach var in maizeeatweek_trim foodexpend_trim logtotcons_trim happy  {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}


}

esttab r* using "$tbls3/LRFU_eat_foodexp_cons_happy.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Maize Eaten}  & \multicolumn{3}{c}{Food Expenditure} & \multicolumn{3}{c}{HH Consumption} & \multicolumn{3}{c}{Happy}  \\ \cline{2-4} \cline{5-7} \cline{8-10} \cline{11-13} ", ///
	pattern(1 0 0 1 0 0 1 0 0 ))


cap est drop r* p*

*******************************
*  Table G.7
*******************************

foreach var in total_edu_exp_trim educ_attendance_percent {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}


}

esttab r* using "$tbls3/LRFU_edu.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Educational Expenditure}  & \multicolumn{3}{c}{School Attendance}  \\ \cline{2-4} \cline{5-7}  ", ///
	pattern(1 0 0 1 0 0 ))


cap est drop r* p*

*******************************
*  Table G.8
*******************************

rename hours_worked_nonfarm_trim non_farm
rename hours_worked_salary_trim hours_worked

foreach var in non_farm profit_nonfarm_trim hours_worked avg_monthly_sal_trim {

reg `var' treatms1 interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 interviewdate,  cl(groupnum)
sum `var' if treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

reg `var' treatms1 treatms2 treat_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & treatms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1 \& Y2"
est sto r3_`var'

local i = 1
foreach x in act rand t c {
cap drop z_ms2 z_both
gen z_ms2 = temp_treatms2_`x'
label var z_ms2 "Treat Y2"
gen z_both = temp_treat_both_`x'
label var z_both "Treat Y1*Treat Y2"

reg `var' treatms1 z_ms2 z_both interviewdate,  cl(groupnum)
sum `var' if treatms1 == 0 & z_ms2 == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
est sto p`i'_`var'

local i = `i' + 1
}

}

esttab r* using "$tbls3/LRFU_onfarminc.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms2 treat_both) nomtitles ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{3}{c}{Hours Non-Farm}  & \multicolumn{3}{c}{Non-Farm Profit} & \multicolumn{3}{c}{Hours Salary} & \multicolumn{3}{c}{Average Wage}  \\ \cline{2-4} \cline{5-7} \cline{8-10} \cline{11-13} ", ///
	pattern(1 0 0 1 0 0 1 0 0 1 0 0 ))



rename non_farm hours_worked_nonfarm_trim
rename hours_worked hours_worked_salary_trim

cap est drop r* p*


*******************
* Table G.10
*******************

label var hi "High"
label var treatms1_hi "Treat Y1*High"
label var treatms2_hi "Treat Y2*High"

foreach var in amt_harvest2014LR_trim netsalesLR2014_trim prct_hi_sales prct_lo_purch nrLR2014_plus_trim {

reg `var' treatms1 hi treatms1_hi interviewdate,  cl(subloc)
sum `var' if treatms1 == 0 & hi == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y1"
est sto r1_`var'

reg `var' treatms2 hi treatms2_hi interviewdate,  cl(subloc)
sum `var' if treatms2 == 0 & hi == 0
estadd sca ymean = `r(mean)'
estadd sca sd = r(sd)
estadd loc sample "Y2"
est sto r2_`var'

}


esttab r*prct_hi_sales r*prct_lo_purch r*nrLR2014_plus_trim using "$tbls3/main_LRFU_hilo.tex", drop(interviewdate _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars( "N Observations" "ymean Mean DV" "sd SD DV" "r2 R squared" ) ///
	order (treatms1 treatms1_hi treatms2 treatms2_hi hi) nomtitles ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mgroups("\multicolumn{2}{c}{Percent Lean Sales} & \multicolumn{2}{c}{Percent Harvest Purchases}  & \multicolumn{2}{c}{Revenues} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0))



rename nrLR2014_plus_trim netrevenueLR2014_plus_trim

cap est drop r*


*********************
*Table E.10
*********************

*prep credit data
use "$main/MS1MS2_pooled.dta", clear

sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


egen all_credit_trim = rowtotal(bank_loan_amt_trim amt_skylocker_trim amt_friend_trim)
gen any_borrow = 0 if all_credit !=.
replace any_borrow = 1 if all_credit!=. & all_credit>0

foreach y in all_credit_trim bank_loan_amt_trim amt_skylocker_trim amt_friend_trim  {
gen lg_`y'=log(`y')
}

gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
 

foreach y in any_borrow all_credit_trim lg_all_credit_trim bank_loan_amt_trim lg_bank_loan_amt_trim lg_amt_skylocker_trim amt_skylocker_trim lg_amt_friend_trim amt_friend_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum )
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_`y'_byround.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	if "`y'"== "all_credit_trim" {

esttab reg*`y' using "$tbls2/p_`y'_byround.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.0f %10.0f %10.0f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))
	
	
	}
}


drop z z_1 z_2 z_3
cap est drop reg*


*******************************
*  Table C.4
*******************************

use "$main/MS1MS2_pooled.dta", clear

cap est drop reg*
loc vars any_loan_base
foreach var of loc vars {

	cap drop interact main
	qui summ `var'
	gen main = `var'
	qui summ main, det
	loc r10 = r(p10)
	loc r90 = r(p90) 
	gen interact = treatMS1MS2*main

	areg takeup_loan main if MS==1 & treatMS1MS2 == 1 & round == 1,  a(strata_group) cl(groupnum)
	qui summ takeup_loan if  MS==1 & treatMS1MS2 == 1 & round == 1
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_1a

	areg loan_size main if MS==1 & treatMS1MS2 == 1 & round == 1, a(strata_group) cl(groupnum)
	qui summ loan_size if MS==1 & treatMS1MS2 == 1 & round == 1
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_1b
	
	areg inventory_trim treatMS1MS2 main interact interviewdate round2 round3 if MS==1, a(strata_group) cl(groupnum)
	qui summ inventory_trim if  treatMS1MS2 == 0
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_2
	qui lincom treatMS1MS2 + `r10'*interact
	estadd sca pct10 = r(estimate)
	estadd sca pct10se = r(se)
	qui lincom treatMS1MS2 + `r90'*interact
	estadd sca pct90 = r(estimate)
	estadd sca pct90se = r(se)

	areg netrevenue_trim treatMS1MS2 main interact interviewdate round2 round3 if MS==1, a(strata_group) cl(groupnum)
	qui summ netrevenue_trim if  treatMS1MS2 == 0
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_3
	qui lincom treatMS1MS2 + `r10'*interact
	estadd sca pct10 = r(estimate)
	estadd sca pct10se = r(se)
	qui lincom treatMS1MS2 + `r90'*interact
	estadd sca pct90 = r(estimate)
	estadd sca pct90se = r(se)

	areg logtotcons_trim treatMS1MS2 main interact interviewdate round2 round3 if MS==1, a(strata_group) cl(groupnum)
	qui summ logtotcons_trim if treatMS1MS2 == 0
	estadd sca mdv = r(mean)
	estadd sca sd = r(sd)
	est sto r`var'_4
	qui lincom treatMS1MS2 + `r10'*interact
	estadd sca pct10 = r(estimate)
	estadd sca pct10se = r(se)
	qui lincom treatMS1MS2 + `r90'*interact
	estadd sca pct90 = r(estimate)
	estadd sca pct90se = r(se)

}


lab var treatMS1MS2 "Treat"
lab var main "Main"
lab var interact "Interact"

esttab rany_loan_base_1a rany_loan_base_2 rany_loan_base_3 rany_loan_base_4  ///
using "$tbls1/het_temp_ref1.tex", drop(interviewdate round* _cons) ///
	replace b(%10.3f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared") ///
	order(treatMS1MS2 main interact) ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Takeup"  "Inv" "Rev"  "Cons"  ) ///
	mgroups("\multicolumn{4}{c}{Baseline Credit Access}  \\ \cline{2-5}", pattern(1 0 1 0))
cap est drop reg*




***************
*Table E.5
***************

use "$main/MS1MS2_pooled.dta", clear


foreach x in inputs_all_trim labor_all_trim inputs_maize_trim labor_maize_trim inputs_maize_oaf_trim {
gen `x' = .
replace `x' = `x'12 if MS == 1
}

foreach x in inputs_maize_trim labor_maize_trim inputs_maize_oaf_trim {
replace `x' = `x'13 if MS == 2
}

foreach x in hybrid_kg  CAN_kg {
gen `x' = `x'12 if MS == 1
replace `x' = `x'13 if MS == 2

}

foreach x in hybrid_kg  CAN_kg  {
bysort MS: sum `x' , det
}

gen z = .
cap est drop reg*

foreach y in  labor_maize_trim inputs_maize_trim inputs_maize_oaf_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"


reg `y' z interviewdate if MS == 1 & round ==3,  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"

reg `y' z interviewdate if MS == 2 & round ==3,  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"

reg `y' z interviewdate MS, cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'


}
}


esttab reg*labor_maize_trim reg*inputs_maize_trim using "$tbls2/p_inputs_maize_trim.tex", drop(interviewdate MS _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled") /// 
	mgroups("\multicolumn{3}{c}{Labor Inputs} & \multicolumn{3}{c}{Non-Labor Inputs} \\ \cline{2-4} \cline{5-7}", pattern(1 0 1 0))


cap est drop reg*


**************************
* Table D.2, D.3, D.4
**************************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

drop if T2==1

drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}


gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in inventory_trim netrevenue_trim logtotcons_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_T1andY2.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))



if "`y'"== "netrevenue_trim" {

esttab reg*`y' using "$tbls2/p_indiv_`y'_T1andY2.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.0f %10.0f %10.0f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))


}
	
	
}


drop z z_1 z_2 z_3
cap est drop reg*


*************
*TABLE D.5
*************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

drop if T2==1

drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}


gen purchasequant2 = purchasequant
replace purchasequant2 = 0 if purchasequant==. & purchaseval==0
gen netsales2 = salesquant-purchasequant2
drop netsales netsales_trim
rename netsales2 netsales

foreach x in netsales {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}

*Effective price paid and net sales

foreach y in netsales_trim    {
areg `y' treatMS1MS2 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
est sto reg_a_`y'

areg `y' treatMS1MS2_1 treatMS1MS2_2 treatMS1MS2_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
est sto reg_b_`y'

}

preserve
gen id = oafid
replace id = fr_id if id == .
foreach x in salesquant_trim purchasequant_trim salesval_trim purchaseval_trim {
bysort id MS: egen tot_`x' = total(`x')
}

foreach x in purchase sales {
gen effective_`x'_price = tot_`x'val_trim/tot_`x'quant_trim
}

duplicates drop id MS, force
areg effective_purchase_price treatMS1MS2 MS, a(strata_group) cl(groupnum)
qui summ effective_purchase_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
est sto reg_eff_purchase_price

areg effective_sales_price treatMS1MS2 MS, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
est sto reg_eff_sales_price
restore


esttab reg* using "$tbls2/p_netsales_effective_price_T1andY2_2.tex", drop(interviewdate Y*round* _cons MS) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) nonum ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Purchase" "Sales" ) ///
	mgroups("\multicolumn{2}{c}{Net Sales} & \multicolumn{2}{c}{Effective Price}  \\ \cline{2-3} \cline{4-5} ", pattern(1 0 1 0))

cap est drop reg*


clear

**********************
* Table E.2
**********************

*prep consumption data
use "$main/MS1MS2_pooled.dta", clear

cap drop z z_*
gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
 

foreach y in totalcals_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

reg `y' z interviewdate Y1round2 Y1round3, cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

reg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

reg `y' z interviewdate Y2round2 Y2round3, cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

reg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3,  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

reg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

reg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(groupnum )
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_`y'.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

}

drop z z_1 z_2 z_3
cap est drop reg*


*********************
*Table K.2
*********************

*prep baseline harvest and log cons vars

use "$main/MS1MS2_pooled.dta", clear 
replace oafid = fr_id if MS == 2
drop fr_id

preserve
keep if MS ==1 
keep oafid correct_interest
drop if correct_interest == .
duplicates drop oafid, force
save "$temp/baseline_merge_robust_correct_interest.dta", replace
count
restore

preserve
keep if MS ==1 
keep oafid price_avg_diff_pct
drop if price_avg_diff_pct == .
duplicates drop oafid, force
save "$temp/baseline_merge_robust_price_avg_diff_pct.dta", replace
count
restore

drop price_avg_diff_pct correct_interest

merge m:1 oafid using "$temp/baseline_merge_robust_price_avg_diff_pct.dta", nogen
merge m:1 oafid using "$temp/baseline_merge_robust_correct_interest.dta", nogen

label var hi "High"

foreach y in inventory_trim netrevenue_trim logtotcons_trim {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}

foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

ivreg2 `y' z hi z_hi interviewdate Y1round2 Y1round3 , cl(subloc oafid) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
test z + z_hi = 0
estadd sca pc = r(p)
estadd loc cont "No"
est sto reg_a_`y'

ivreg2 `y' z hi z_hi interviewdate Y1round2 Y1round3 price_avg_diff_pct correct_interest, cl(subloc oafid) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
test z + z_hi = 0
estadd sca pc = r(p)
estadd loc cont "Yes"
est sto reg_b_`y'

}
}

esttab reg* using "$tbls2/p_intens_all_alt_price_avg_diff_pct.tex", keep(z hi z_hi) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations"   "r2 R squared" "pc p-val T+TH=0") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("No Controls" "Controls" "No Controls" "Controls" "No Controls" "Controls") ///
	mgroups("\multicolumn{2}{c}{Inventory} & \multicolumn{2}{c}{Net Revenues} & \multicolumn{2}{c}{Consumption} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))


	
drop z z_hi z_1 z_2 z_3 
est drop reg*


*******************************
*  Figure F.1
*******************************


use "$main/MS1MS2_pooled.dta", clear 

gen month = month(interviewdate)
gen year = year(interviewdate)
tab month year
gen samp_inc = 1 if  month == 12 | (month>= 1 & month<8)
drop interviewdate1
gen interviewdate1 = interviewdate
replace interviewdate1 = interviewdate - 365 if MS == 2 // align Y1 and Y2
format interviewdate1 %td
save "$temp/maineffects_RTband", replace

*Fan reg with different BW
set seed 362436
preserve

foreach x in inventory_trim netrevenue_trim logtotcons_trim {
local i = 0
foreach y in 2 1.33 1 0.67 0.5 { 
	use "$temp/maineffects_RTband", clear

	local i = `i' + 1
	local bw = `y'*3 // 3 is the original bandwidth used

	cap drop x* y* 
	cap drop _m
	fanreg `x' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1 , xgen(x1) ygen(y1) reps(1) graph(off) np(100) bw(`bw')
	fanreg `x' interviewdate1 if treatMS1MS2 ==1  & samp_inc ==1 , xgen(x2) ygen(y2) reps(1) graph(off) np(100) bw(`bw')

	gen est_mean`i'  = y2 - y1
	qui gen obs = _n
	qui sort obs
	keep obs est_mean x1
	save "$temp/maineffects_RTband`i'_`x'", replace
}


*Main Figure

use "$temp/maineffects_RTband1_`x'", clear
rename x1 x1_1
forval i = 2/5{
merge 1:1 obs using "$temp/maineffects_RTband`i'_`x'", nogen
rename x1 x1_`i'
}
format x1_1  %td
save "$temp/maineffects_RTband_`x'", replace

}

restore

use "$temp/maineffects_RTband_inventory_trim",  clear
twoway line est_mean* x1_1 if x1_1<date("01aug2013","DMY"), ylabel(-2(2)4) ///
		lc(blue blue black red red) lp(shortdash longdash solid longdash shortdash) lw(t medium medium medium medium) scheme(s1mono) ///
		title("Inventories") ytitle("Inventories T-C", height(7)) xtitle("")	///
		legend(label(1 "0.5x BW") label(2 "0.75x BW") label(3 "BW") label(4 "1.5x BW") label(5 "2x BW") rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny) size(small) symxsize(*0.75)) ///
		tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) ///
		yline(0, lc(grey)) saving("$plots2/p_inventory_trim_RTband.gph", replace)

use "$temp/maineffects_RTband_netrevenue_trim",  clear
twoway line est_mean* x1_1 if x1_1<date("01aug2013","DMY"), ylabel(-6000(2000)4000)  ///
		lc(blue blue black red red) lp(shortdash longdash solid longdash shortdash) lw(t medium medium medium medium) scheme(s1mono) ///
		title("Net Revenues") ytitle("Net Revenues T-C", height(7)) xtitle("")	///
		legend(label(1 "0.5x BW") label(2 "0.75x BW") label(3 "BW") label(4 "1.5x BW") label(5 "2x BW") rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny) size(small) symxsize(*0.75)) ///
		tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) ///
		yline(0, lc(grey)) saving("$plots2/p_netrevenue_trim_RTband.gph", replace)

use "$temp/maineffects_RTband_logtotcons_trim",  clear
twoway line est_mean* x1_1 if x1_1<date("01aug2013","DMY"), ylabel(-0.4(0.2)1)  ///
		lc(blue blue black red red) lp(shortdash longdash solid longdash shortdash) lw(t medium medium medium medium) scheme(s1mono) ///
		title("Total HH Consumption (log)") ytitle("Total HH Consumption (log) T-C", height(7)) xtitle("")	///
		legend(label(1 "0.5x BW") label(2 "0.75x BW") label(3 "BW") label(4 "1.5x BW") label(5 "2x BW") rows(1) pos(6) ring(1) region(ls(none)) bmargin(tiny) size(small) symxsize(*0.75)) ///
		tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013, format(%tdMon)) ///
		yline(0, lc(grey)) saving("$plots2/p_logtotcons_trim_RTband.gph", replace)

		
graph combine "$plots2/p_inventory_trim_RTband.gph" "$plots2/p_netrevenue_trim_RTband.gph" "$plots2/p_logtotcons_trim_RTband.gph", ///
rows (1) xsize(14) ysize(4) scheme(s1mono) altshrink
graph export "$plots2/p_inventory_revenue_cons_RTband.pdf", as(pdf) replace



****************
*Table M.2
****************

*prep inflation data
use "$main/BOK_inflation.dta", clear

replace inflation_rate_12mo = inflation_rate_12mo/100
gen order = _n
gen inflation_rate_monthly =  ((1 + inflation_rate_12mo)^(1/12)) - 1
gen multiplier =  1 if _n == 1  // multiplier to get back to oct 2012 prices

forval i = 2/26 {
local k = `i' - 1
replace multiplier = multiplier[`k'] * (1+inflation_rate_monthly[`k']) if _n==`i'
}

keep year month multiplier
replace multiplier = 1/multiplier
label var multiplier "multiplier to get back to oct 2012 prices"
gen day = 1
tostring day year, replace
gen date = day + month + year
gen date2 = date(date,"DMY")
drop month day
gen month = month(date2)
drop date* 
destring year, replace

save "$temp/BOK_inflation_formerge.dta", replace

*adjust revenue figures

use "$main/MS1MS2_pooled.dta", clear 

gen year = year(interviewdate)
gen month = month(interviewdate)

merge m:1 month year using "$temp/BOK_inflation_formerge.dta"

gen netrevenue_trim_oct12 = netrevenue_trim*multiplier

sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


replace oafid = fr_id if MS == 2

gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in  netrevenue_trim_oct12  {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}



esttab reg*`y' using "$tbls2/p_indiv_`y'_robustinflation.tex", keep(z z_1 z_2 z_3) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.0f %10.0f %10.0f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	

}

drop z z_1 z_2 z_3
cap est drop reg*


****************
*Table M.3
****************

label var hi "High"

foreach y in inventory_trim netrevenue_trim_oct12 logtotcons_trim {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3, cl(subloc) // if run areg, hi drops out becuase the strata are at the 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate  Y2round2 Y2round3,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

}


esttab reg* using "$tbls2/p_intens_all_alt_robustinflation.tex", keep(z hi z_hi) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars( "N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" "pc p-val T+TH=0") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" ) ///
	mgroups("\multicolumn{3}{c}{Inventory} & \multicolumn{3}{c}{Net Revenues} & \multicolumn{3}{c}{Consumption}  \\ \cline{2-4} \cline{5-7} \cline{8-10} ", pattern(1 0 1 0))


drop z z_hi z_1 z_2 z_3 
est drop reg*




************************
*Table F.10, F.11, F.12
*************************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


replace oafid = fr_id if MS == 2


drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}


gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in inventory_trim netrevenue_trim logtotcons_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

xi: ivreg2 `y' z interviewdate Y1round2 Y1round3 i.strata_group, cl(groupnum oafid)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

ivreg2 `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 i.strata_group, cl(groupnum oafid)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

ivreg2 `y' z interviewdate Y2round2 Y2round3 i.strata_group, cl(groupnum oafid)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

ivreg2 `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3 i.strata_group, cl(groupnum oafid)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

ivreg2 `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 i.strata_group, cl(groupnum oafid)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

ivreg2 `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 i.strata_group, cl(groupnum oafid)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_robusttwoway.tex", keep(z z_1 z_2 z_3) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

if "`y'"== "netrevenue_trim" {

esttab reg*`y' using "$tbls2/p_indiv_`y'_robusttwoway.tex", keep(z z_1 z_2 z_3) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.0f %10.0f %10.0f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	
}

}



drop z z_1 z_2 z_3
cap est drop reg*

**************
*Table F.13
**************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


replace oafid = fr_id if MS == 2

gen purchasequant2 = purchasequant
replace purchasequant2 = 0 if purchasequant==. & purchaseval==0
gen netsales2 = salesquant-purchasequant2
drop netsales netsales_trim
rename netsales2 netsales

foreach x in netsales {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}




drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100 
drop qnt
}

foreach y in netsales_trim    {
ivreg2 `y' treatMS1MS2 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3  i.strata_group,  cl(groupnum oafid)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_a_`y'

ivreg2 `y' treatMS1MS2_1 treatMS1MS2_2 treatMS1MS2_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3  i.strata_group,  cl(groupnum oafid)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_b_`y'

}

preserve
gen id = oafid
replace id = fr_id if id == .
foreach x in salesquant_trim purchasequant_trim salesval_trim purchaseval_trim {
bysort id MS: egen tot_`x' = total(`x')
}

foreach x in purchase sales {
gen effective_`x'_price = tot_`x'val_trim/tot_`x'quant_trim
}

duplicates drop id MS, force
ivreg2 effective_purchase_price treatMS1MS2 MS  i.strata_group,  cl(groupnum oafid)
qui summ effective_purchase_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_eff_purchase_price

ivreg2 effective_sales_price treatMS1MS2 MS i.strata_group, cl(groupnum oafid)
qui summ effective_sales_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_eff_sales_price
restore


esttab reg* using "$tbls2/p_netsales_effective_price_robusttwoway_2.tex", keep(treatMS1MS2*) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV""sd SD DV" "r2 R squared" ) nonum ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Purchase" "Sales" ) ///
	mgroups("\multicolumn{2}{c}{Net Sales} & \multicolumn{2}{c}{Effective Price}  \\ \cline{2-3} \cline{4-5} ", pattern(1 0 1 0))

cap est drop reg*


*********************
*Table F.14
*********************


label var hi "High"

foreach y in inventory_trim netrevenue_trim logtotcons_trim {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

ivreg2 `y' z hi z_hi interviewdate Y1round2 Y1round3, cl(subloc oafid) // if run areg, hi drops out becuase the strata are at the 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

ivreg2 `y' z hi z_hi interviewdate  Y2round2 Y2round3,  cl(subloc oafid) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

ivreg2 `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc oafid) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

}


esttab reg* using "$tbls2/p_intens_all_alt_robusttwoway.tex", keep(z hi z_hi) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars( "N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" "pc p-val T+TH=0") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" ) ///
	mgroups("\multicolumn{3}{c}{Inventory} & \multicolumn{3}{c}{Net Revenues} & \multicolumn{3}{c}{Consumption}  \\ \cline{2-4} \cline{5-7} \cline{8-10} ", pattern(1 0 1 0))



drop z z_hi z_1 z_2 z_3 
est drop reg*


*********************
*  Table F.3, F.4
*********************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

replace oafid = fr_id if MS == 2
drop fr_id

preserve
keep if MS ==1 
keep oafid harvest2012LR
drop if harvest2012LR == .
duplicates drop oafid, force
save "$temp/baseline_merge_robust_harvest.dta", replace
count
restore

preserve
keep if MS ==1 
keep oafid logtotcons_base
drop if logtotcons_base == .
duplicates drop oafid, force
save "$temp/baseline_merge_robust_cons.dta", replace
count
restore

drop harvest2012LR logtotcons_base

//drop _m
merge m:1 oafid using "$temp/baseline_merge_robust_harvest.dta", nogen
merge m:1 oafid using "$temp/baseline_merge_robust_cons.dta", nogen

drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}


gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in inventory_trim netrevenue_trim  {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_baserobust.tex", drop(interviewdate Y*round* _cons harvest2012LR) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	
if "`y'"== "netrevenue_trim" {

esttab reg*`y' using "$tbls2/p_indiv_`y'_baserobust.tex", drop(interviewdate Y*round* _cons harvest2012LR) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.0f %10.0f %10.0f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))


}
}


drop z z_1 z_2 z_3
cap est drop reg*


*******************************
*  Table F.5
*******************************

gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in logtotcons_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 logtotcons_base, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 logtotcons_base, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3 logtotcons_base, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3 logtotcons_base, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 logtotcons_base, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 logtotcons_base, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_baserobust.tex", drop(interviewdate Y*round* _cons logtotcons_base) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars( "N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

}


drop z z_1 z_2 z_3
cap est drop reg*


******************
* Table F.6
******************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

replace oafid = fr_id if MS == 2
drop fr_id

preserve
keep if MS ==1 
keep oafid harvest2012LR
drop if harvest2012LR == .
duplicates drop oafid, force
save "$temp/baseline_merge_robust_harvest.dta", replace
count
restore

preserve
keep if MS ==1 
keep oafid logtotcons_base
drop if logtotcons_base == .
duplicates drop oafid, force
save "$temp/baseline_merge_robust_cons.dta", replace
count
restore

drop harvest2012LR logtotcons_base

//drop _m
merge m:1 oafid using "$temp/baseline_merge_robust_harvest.dta", nogen
merge m:1 oafid using "$temp/baseline_merge_robust_cons.dta", nogen

drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}

gen purchasequant2 = purchasequant
replace purchasequant2 = 0 if purchasequant==. & purchaseval==0
gen netsales2 = salesquant-purchasequant2
drop netsales netsales_trim
rename netsales2 netsales

foreach x in netsales {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}

foreach y in netsales_trim    {
areg `y' treatMS1MS2 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_a_`y'

areg `y' treatMS1MS2_1 treatMS1MS2_2 treatMS1MS2_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 harvest2012LR, a(strata_group) cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_b_`y'

}

preserve
gen id = oafid
foreach x in salesquant_trim purchasequant_trim salesval_trim purchaseval_trim {
bysort id MS: egen tot_`x' = total(`x')
}

foreach x in purchase sales {
gen effective_`x'_price = tot_`x'val_trim/tot_`x'quant_trim
}

duplicates drop id MS, force
areg effective_purchase_price treatMS1MS2 MS harvest2012LR, a(strata_group) cl(groupnum)
qui summ effective_purchase_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_eff_purchase_price

areg effective_sales_price treatMS1MS2 MS harvest2012LR, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_eff_sales_price
restore


esttab reg* using "$tbls2/p_netsales_effective_price_baserobust_2.tex", drop(interviewdate Y*round* _cons MS harvest2012LR) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) nonum ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Purchase" "Sales" ) ///
	mgroups("\multicolumn{2}{c}{Net Sales} & \multicolumn{2}{c}{Effective Price}  \\ \cline{2-3} \cline{4-5} ", pattern(1 0 1 0))

cap est drop reg*

******************
* Table F.7
******************

label var hi "High"

foreach y in inventory_trim netrevenue_trim  {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 harvest2012LR,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate  Y2round2 Y2round3 harvest2012LR,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 harvest2012LR,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

}

foreach y in logtotcons_trim   {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 logtotcons_base,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate  Y2round2 Y2round3 logtotcons_base,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*High"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`i'"
}

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3 logtotcons_base,  cl(subloc) 
qui summ `y' if `x'==0 & hi == 0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'_`y'
test z + z_hi = 0
estadd sca pc = r(p)

local i = `i' + 1
}

}

esttab reg* using "$tbls2/p_intens_all_alt_baserobust.tex", drop(interviewdate Y*round* _cons logtotcons_base harvest2012LR) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV"  "r2 R squared" "pc p-val T+TH=0") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled" ) ///
	mgroups("\multicolumn{3}{c}{Inventory} & \multicolumn{3}{c}{Net Revenues} & \multicolumn{3}{c}{Consumption}  \\ \cline{2-4} \cline{5-7} \cline{8-10} ", pattern(1 0 1 0))



drop z z_hi z_1 z_2 z_3 
est drop reg*

*************
*Table F.8
*************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


drop purchaseval_trim salesval_trim

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}

gen purchasequant2 = purchasequant
replace purchasequant2 = 0 if purchasequant==. & purchaseval==0
gen netsales2 = salesquant-purchasequant2
drop netsales netsales_trim
rename netsales2 netsales

foreach x in netsales {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}


gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in netsales_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_2.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

}

drop z z_1 z_2 z_3
cap est drop reg*



**************
*Figure F.2
**************

use "$main/MS1MS2_pooled.dta", clear

gen month = month(interviewdate)
gen year = year(interviewdate)
tab month year
gen samp_inc = 1 if month == 12 | (month>= 1 & month<8)
drop interviewdate1
gen interviewdate1 = interviewdate
replace interviewdate1 = interviewdate - 365 if MS == 2 // align Y1 and Y2

format interviewdate1 %td

gen purchasequant2 = purchasequant
replace purchasequant2 = 0 if purchasequant==. & purchaseval==0
gen netsales2 = salesquant-purchasequant2
drop netsales netsales_trim
rename netsales2 netsales

foreach x in netsales {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}


preserve

keep if treatMS1MS2 <.
keep netsales_trim interviewdate1 treatMS1MS2 groupnum round samp_inc MS
save "$temp/p_treatBootstrap_Y_2", replace
set seed 7060116

foreach var of varlist netsales_trim { 
	use "$temp/p_treatBootstrap_Y_2", replace
	qui fanreg `var' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1 , xgen(x1) ygen(y1) reps(1) bw(3) 
	qui fanreg `var' interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1 , xgen(x2) ygen(y2) reps(1) bw(3) 
	keep if x1<.
	gen obs=_n
	qui gen diff1=y2-y1
	keep obs x1 diff1
	save "$temp/p_bootresults_`var'_Y_2", replace


	forvalues i=2/100{
	
		use "$temp/p_treatBootstrap_Y_2", clear
		bsample 171, cluster(groupnum) 
		qui fanreg `var' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1, xgen(x1) ygen(y1) reps(1) bw(3) 
		qui fanreg `var' interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1, xgen(x2) ygen(y2) reps(1) bw(3) 
		qui gen diff`i' = y2-y1
		qui gen obs=_n
		qui sort obs
		keep obs diff`i'
		qui merge 1:1 obs using "$temp/p_bootresults_`var'_Y_2", nogen
		qui save "$temp/p_bootresults_`var'_Y_2", replace
		di "`i'"
	}

	

	gen est_mean=diff1
	egen est_sd=rowsd(diff*)
	gen lower=est_mean-1.96*est_sd
	gen upper=est_mean+1.96*est_sd
	gen lower_90=est_mean-1.645*est_sd
	gen upper_90=est_mean+1.645*est_sd
	gen y_temp = 0
	if "`var'"== "netsales_trim" {
		loc tit "Net Sales Pooled"
	}	


	format x1 %td
	twoway (rarea lower upper x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs13)  xtitle("") ylabel(-2(1)3) ytitle("`tit', T - C") title("`tit'")   ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)))  ///
	(rarea lower_90 upper_90 x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs10)) ///
	(line est_mean x1 if x1>1 &  x1<date("01aug2013","DMY"), yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1 if x1<date("01aug2013","DMY"), saving("$plots2/p_`var'_boot_alt_2.gph", replace))


}

restore




forval k = 1/2{

preserve

keep if treatMS1MS2 <.
keep netsales_trim interviewdate1 treatMS1MS2 groupnum round samp_inc MS
save "$temp/p_treatBootstrap_Y`k'_2", replace
set seed 7060116

foreach var of varlist netsales_trim { 
	use "$temp/p_treatBootstrap_Y`k'_2", replace
	qui fanreg `var' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1 & MS ==`k', xgen(x1) ygen(y1) reps(1) bw(3) 
	qui fanreg `var' interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1 & MS ==`k', xgen(x2) ygen(y2) reps(1) bw(3) 
	keep if x1<.
	gen obs=_n
	qui gen diff1=y2-y1
	keep obs x1 diff1
	save "$temp/p_bootresults_`var'_Y`k'_2", replace


	forvalues i=2/100{
	
		use "$temp/p_treatBootstrap_Y`k'_2", clear
		bsample 171, cluster(groupnum) 
		qui fanreg `var' interviewdate1 if treatMS1MS2 ==0 & samp_inc ==1 & MS ==`k', xgen(x1) ygen(y1) reps(1) bw(3) 
		qui fanreg `var' interviewdate1 if treatMS1MS2 ==1 & samp_inc ==1 & MS ==`k', xgen(x2) ygen(y2) reps(1) bw(3) 
		qui gen diff`i' = y2-y1
		qui gen obs=_n
		qui sort obs
		keep obs diff`i'
		qui merge 1:1 obs using "$temp/p_bootresults_`var'_Y`k'_2", nogen
		qui save "$temp/p_bootresults_`var'_Y`k'_2", replace
		di "`i'"
	}

	

	gen est_mean=diff1
	egen est_sd=rowsd(diff*)
	gen lower=est_mean-1.96*est_sd
	gen upper=est_mean+1.96*est_sd
	gen lower_90=est_mean-1.645*est_sd
	gen upper_90=est_mean+1.645*est_sd
	gen y_temp = 0
	if "`var'"== "netsales_trim" {
		loc tit "Net Sales - Y`k'"
	}	


	format x1 %td
	twoway (rarea lower upper x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs13)  xtitle("") ylabel(-2(1)3) ytitle("`tit', T - C") title("`tit'")   ///
	tlabel(01nov2012 01dec2012 01jan2013 01feb2013 01mar2013 01apr2013 01may2013 01jun2013 01jul2013 01aug2013 , format(%tdMon)))  ///
	(rarea lower_90 upper_90 x1 if x1>1 &  x1<date("01aug2013","DMY"), col(gs10)) ///
	(line est_mean x1 if x1>1 &  x1<date("01aug2013","DMY"), yline(0) lc(black) lw(thick) scheme(s1mono) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" ) rows(1) pos(6) ring(0) region(ls(none))))  ///
	(line y_temp x1 if x1<date("01aug2013","DMY"), saving("$plots2/p_`var'_boot_alt_Y`k'_2.gph", replace))




}

restore

}



graph combine "$plots2/p_netsales_trim_boot_alt_Y1_2.gph" "$plots2/p_netsales_trim_boot_alt_Y2_2.gph"  "$plots2/p_netsales_trim_boot_alt_2.gph" , ///
rows (1) xsize(16) ysize(4) scheme(s1mono) altshrink
graph export "$plots2/netsales_robust_2.pdf", as(pdf) replace



******************
*Table F.1
******************

use "$main/MS1MS2_pooled.dta", clear 

drop if MS !=2
keep oafid treatMS1MS2
count
collapse treatMS1MS2, by(oafid)
count
rename treatMS1MS2 treat13
save "$temp/temp_treat.dta", replace


use "$main/baseline.dta", clear

replace delta = 1 - delta

keep oafid logtotcons_base logtotcons_base ///
	 male num_adults num_schoolchildren finished_primary finished_secondary cropland num_rooms ///
	schoolfees totcons_base logpercapcons_base total_cash_savings_base total_cash_savings_trimmed ///
	has_savings_acct  taken_bank_loan taken_informal_loan liquidWealth wagepay businessprofitmonth ///
	price_avg_diff_pct price_expect_diff_pct harvest2011 netrevenue2011 netseller2011 autarkic2011 maizelostpct2011 ///
	harvest2012  correct_interest digit_recall maizegiver delta	treatment groupnum_baseline
rename * *_base
rename oafid_base oafid
rename *base_base *base
rename treatment_base treatment2012

gen treat12 = (treatment2012=="T1" | treatment2012=="T2")
label variable treat12 "Treatment 2012"
replace treat12=. if treatment2012==""

merge 1:1 oafid using "$temp/temp_treat.dta", generate(merge_base) 

drop if merge_base ==2
gen in_sample_Y2 = (merge_base ==3)
gen newin13=(merge_base==2)
gen attrit13=(merge_base==1)


*balance in Y2 table

label var price_expect_diff_pct "Expect $\%\Delta$ price Sep12-Jun13"
label var num_schoolchildren_base "Children in school"
label var finished_primary_base "Finished primary school"
label var finished_secondary_base "Finished secondary school"
label var num_rooms_base "Number of rooms in household"
replace schoolfees_base = schoolfees_base*1000
label var  schoolfees_base "Total school fees"
label var totcons_base  "Average monthly consumption (Ksh)"
label var logpercapcons_base "Average monthly consumption/capita (log)”
label var liquidWealth_base "Liquid wealth (Ksh)"
label var netrevenue2011_base "Net revenue 2011 (Ksh)"
label var total_cash_savings_base "Total cash savings (Ksh)"

local vars 	 male_base num_adults_base num_schoolchildren_base finished_primary_base finished_secondary_base cropland_base num_rooms_base ///
	schoolfees_base totcons_base logpercapcons_base total_cash_savings_base total_cash_savings_trimmed_base ///
	has_savings_acct_base  taken_bank_loan_base taken_informal_loan_base liquidWealth_base wagepay_base businessprofitmonth_base ///
	price_avg_diff_pct_base  harvest2011_base netrevenue2011_base netseller2011_base autarkic2011_base maizelostpct2011_base ///
	harvest2012_base  correct_interest_base digit_recall_base maizegiver_base 	


local numvars : word count `vars'
tokenize `vars'
forvalues i = 1/`numvars' {
	qui ttest ``i'' if in_sample_Y2 == 1 , by(treat13) 
	mat b1 = (r(mu_2),r(mu_1),r(N_1)+r(N_2), (r(mu_1)-r(mu_2))/r(sd_1))
	reg ``i'' treat13, cl(groupnum_baseline)
	mat b2 = (2 * ttail(e(df_r), abs(_b[treat13]/_se[treat13])))
	mat b = (b1, b2)
	if `i'==1 {
		mat d = b
		}
		else {
		mat d = d\b  
		}
	}
mat rownames d = `vars'
frmttable using "$tbls2/summstat_13_robust", statmat(d) replace va tex fra ///
	ctitles("Baseline characteristic","Treat","Control","Obs","T-C"\"","", "", "", "\ital{sd}", "\ital{p-val}") ///
	multicol(1,5,2) sdec(2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 	\ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2  \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 0, 0, 0, 2, 2 \ 2, 2, 0, 2, 2 \ 2, 2, 0, 2, 2 )

	
replace schoolfees_base = schoolfees_base/1000

	
*******************************
*  Table F.2
*******************************

use "$main/MS1MS2_pooled.dta", clear

keep if MS == 2 & round == 1
keep fr_id harvest2013LR
drop if fr_id == .
duplicates drop fr_id, force
save "$temp/temp.dta", replace
use "$main/MS1MS2_pooled.dta", clear
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

drop harvest2013LR
//drop _m
merge m:1 fr_id using "$temp/temp.dta", nogen

areg harvest2013LR  treatMS1MS2 interviewdate Y2round2 Y2round3 if MS==2, a(strata_group) cl(groupnum) 
qui summ harvest2013LR if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "N/A"
est sto reg1

areg inventory_trim  treatMS1MS2 interviewdate Y2round2 Y2round3 if MS==2, a(strata_group)  cl(groupnum) 
qui summ inventory_trim if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "No"
est sto reg2

areg inventory_trim  treatMS1MS2 harvest2013LR interviewdate Y2round2 Y2round3 if MS==2, a(strata_group) cl(groupnum) 
qui summ inventory_trim if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "No"
est sto reg3

areg netrevenue_trim  treatMS1MS2 interviewdate Y2round2 Y2round3 if MS==2, a(strata_group) cl(groupnum) 
qui summ netrevenue_trim if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "No"
est sto reg4

areg netrevenue_trim  treatMS1MS2 harvest2013LR interviewdate Y2round2 Y2round3 if MS==2, a(strata_group) cl(groupnum) 
qui summ netrevenue_trim if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "Yes"
est sto reg5

areg logtotcons_trim  treatMS1MS2 interviewdate Y2round2 Y2round3 if MS==2, a(strata_group) cl(groupnum) 
qui summ netrevenue_trim if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "No"
est sto reg6

areg logtotcons_trim  treatMS1MS2 harvest2013LR interviewdate Y2round2 Y2round3 if MS==2, a(strata_group) cl(groupnum) 
qui summ netrevenue_trim if treatMS1MS2 == 0 & MS == 2
estadd sca mdv = r(mean)
estadd loc cont "Yes"
est sto reg7

esttab reg1 reg2 reg3 reg4 reg5 reg6 reg7 using "$tbls2/balance_harvest_Y2.tex", keep(treatMS1MS2 harvest2013LR) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f) ///
	scalars("N Observations" "mdv Mean of Dep Variable"  "r2 R squared") ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	nomtitles  /// 
	mgroups("\multicolumn{1}{c}{2013 LR Harvest} & \multicolumn{2}{c}{Inventory} & \multicolumn{2}{c}{Net Revenues} & \multicolumn{2}{c}{Consumption} \\ \cline{2-2} \cline{3-4} \cline{5-6} \cline{7-8}", pattern(1 0 1 0))
eststo clear


******************************
* Figure M.1
******************************

use "$main/MS1MS2_pooled.dta", clear 

foreach x in harvest2012  {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt<3 | qnt>98  
drop qnt
}

gen month = month(interviewdate)
gen year = year(interviewdate)
tab month year
gen samp_inc = 1 if month == 12 | (month>= 1 & month<8)
drop interviewdate1
gen interviewdate1 = interviewdate
replace interviewdate1 = interviewdate - 365 if MS == 2 // align Y1 and Y2

format interviewdate1 %td

keep if treatMS1MS2 <.
keep netrevenue_trim interviewdate1 harvest2012_trim treatMS1MS2 groupnum round samp_inc MS hi subloc
save "$temp/p_treatBootstrap_revC", replace
set seed 7060116

foreach var of varlist netrevenue_trim { 
	use "$temp/p_treatBootstrap_revC", replace
	qui fanreg `var' harvest2012_trim if treatMS1MS2 ==0 & hi == 0 & samp_inc ==1 & MS == 1, xgen(x1) ygen(y1) reps(1) bw(3) 
	qui fanreg `var' harvest2012_trim if treatMS1MS2 ==0 & hi == 1 & samp_inc ==1 & MS == 1 , xgen(x2) ygen(y2) reps(1) bw(3) 
	keep if x1<.
	gen obs=_n
	qui gen diff1=y2-y1
	keep obs x1 diff1
	save "$temp/p_bootresults_`var'_revC", replace
	
	forvalues i=2/100{
	
		use "$temp/p_treatBootstrap_revC", clear
		bsample, cluster(subloc) // cluster at sublocation level for density effects
		qui fanreg `var' harvest2012_trim if treatMS1MS2 ==0 & hi == 0 & samp_inc ==1 & MS == 1, xgen(x1) ygen(y1) reps(1) bw(3) 
		qui fanreg `var' harvest2012_trim if treatMS1MS2 ==0 & hi == 1 & samp_inc ==1 & MS == 1, xgen(x2) ygen(y2) reps(1) bw(3) 
		qui gen diff`i' = y2-y1
		qui gen obs=_n
		qui sort obs
		keep obs diff`i'
		qui merge 1:1 obs using "$temp/p_bootresults_`var'_revC", nogen
		qui save "$temp/p_bootresults_`var'_revC", replace
		di "`i'"
	}
	}
	

*distribution of baseline harvest level
preserve
keep if x1<.
keep x1
gen obs = _n
save "$temp/kdens_harvest2012.dta", replace 
restore


use "$main/MS1MS2_pooled.dta", clear 

foreach x in harvest2012  {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt<3 | qnt>98  
drop qnt
}

gen obs = _n
merge 1:1 obs using "$temp/kdens_harvest2012.dta", nogen


kdensity harvest2012_trim, at(x1) gen(x1_dup density) nograph
drop x1_dup 

keep x1 density
keep if x1!=.

save "$temp/kdens2_harvest2012.dta", replace 

*combine graphs

use  "$temp/p_bootresults_netrevenue_trim_revC", replace
drop if x1==.

merge 1:1 x1 using "$temp/kdens2_harvest2012.dta", nogen
			
gen est_mean=diff1
egen est_sd=rowsd(diff*)
gen lower=est_mean-1.96*est_sd
gen upper=est_mean+1.96*est_sd
gen lower_90=est_mean-1.645*est_sd
gen upper_90=est_mean+1.645*est_sd
gen y_temp = 0

*windorize CI for display on graph
foreach x in lower upper lower_90 upper_90 {
	replace `x' = 40000 if `x' > 40000 & `x'!=.
	replace `x' = -40000 if `x' < -40000 & `x'!=.	
}


twoway (rarea lower upper x1 if  x1<=., yaxis(1) col(gs13) xtitle("Baseline Harvest Level, Bags") ylabel(-40000(20000)40000) xlabel(0(10)30)  ytitle("Control Group, Net Revenues, H - L", height(7)) title("Spillover Effect by Baseline Harvest"))  ///
	(rarea lower_90 upper_90 x1 if  x1<=., yaxis(1) col(gs10)) ///
	(line est_mean x1 if x1<=., yaxis(1) yline(0) lc(black) lw(thick) scheme(s1mono)) ///
	(line density x1 if x1<=.,  ylabel(-0.1(0.05)0.1, axis(2)) yaxis(2) ytitle("Density", axis(2)) lc(red) lw(medium) ) ///
	(line y_temp x1 if x1<=., saving("$plots2/p_revn_control.gph", replace) legend(on order(3 "Pt Est" 1 "95% CI" 2 "90% CI" 5 "Density" ) rows(1) pos(6) ring(1) region(ls(none))))
	graph export "$plots2/p_revn_control.pdf", as(pdf) replace



*****************************************
* Table E.1, E.3, E.4, E.12
*****************************************

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

cap drop qnt
xtile qnt = foodexpend, n(100)
gen foodexpend_trim = foodexpend
replace foodexpend_trim=. if qnt==1 | qnt==100  
drop qnt
label var foodexpend_trim "Food Exp"

gen totcons_nonfood = totcons - foodexpend

gen monthly_maize_consum = maizeeatweek*30/7
gen totcons_nonmaize = totcons - monthly_maize_consum

foreach x in totcons_nonfood totcons_nonmaize  {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if qnt == 1 | qnt==200  
drop qnt
}

gen logtotcons_nonfood_trim = log(totcons_nonfood_trim)
gen logtotcons_nonmaize_trim=log(totcons_nonmaize_trim)
rename logtotcons_nonfood_trim log_nonfood_trim
rename logtotcons_nonmaize_trim log_nonmaize_trim


gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in  foodexpend_trim maizeeatweek_trim schoolfeesexpend_trim happy logtotcons_trim  log_nonmaize_trim log_nonfood_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3,  a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3,  a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3,  a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3,  a(strata_group)  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,   a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_byround.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars( "N Observations" "mdv Mean DV" "sd SD DV" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

}



drop z z_1 z_2 z_3
cap est drop reg*

*****************************************
* Table E.6, E.7, E.8, E.9
*****************************************

gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in  non_farm_profit_trim non_farm_hours_trim salaried_hours_trim avg_salary_trim {

local i = `i' + 1

foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate  if round == 3 & MS ==1,  a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

}


local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3,  a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3,   a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_byround.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("N Observations" "mdv Mean DV" "sd SD DV"  "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(9cm) ///
	mtitles("R3" "Overall" "By rd") 
	
	

}


drop z z_1 z_2 z_3
cap est drop reg*


*******************************
*  Table 2,3,4
*******************************

*collect naive p-vals
use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable

replace oafid = fr_id if MS == 2

drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100 
drop qnt
}

gen z = .
forval i = 1/3{
gen z_`i' = .
}

gen pval = .
gen var_name = ""

*inventory, net revenue, and consumption
foreach y in inventory_trim netrevenue_trim logtotcons_trim {

foreach x in treat12{

replace z = `x'
forval k = 1/3{
replace z_`k' = `x'_`k'
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
local pval_p = (2 * ttail(e(df_r), abs(_b[z]/_se[z])))

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
forval j = 1/3 {
local pval_r`j' = (2 * ttail(e(df_r), abs(_b[z_`j']/_se[z_`j'])))
}

preserve
clear
set obs 1
gen pval_p = `pval_p'
gen pval_r1 = `pval_r1'
gen pval_r2 = `pval_r2'
gen pval_r3 = `pval_r3'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_`y'_`x'.dta", replace
restore

}


foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
local pval_p = (2 * ttail(e(df_r), abs(_b[z]/_se[z])))

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group)  cl(groupnum)
forval j = 1/3 {
local pval_r`j' = (2 * ttail(e(df_r), abs(_b[z_`j']/_se[z_`j'])))
}

preserve
clear
set obs 1
gen pval_p = `pval_p'
gen pval_r1 = `pval_r1'
gen pval_r2 = `pval_r2'
gen pval_r3 = `pval_r3'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_`y'_`x'.dta", replace
restore

}


foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
local pval_p = (2 * ttail(e(df_r), abs(_b[z]/_se[z])))

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum)
forval j = 1/3 {
local pval_r`j' = (2 * ttail(e(df_r), abs(_b[z_`j']/_se[z_`j'])))
}

preserve
clear
set obs 1
gen pval_p = `pval_p'
gen pval_r1 = `pval_r1'
gen pval_r2 = `pval_r2'
gen pval_r3 = `pval_r3'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_`y'_`x'.dta", replace
restore


}
}


*effective price

gen id = oafid
replace id = fr_id if id == .
foreach x in salesquant_trim purchasequant_trim salesval_trim purchaseval_trim {
bysort id MS: egen tot_`x' = total(`x')
}

foreach x in purchase sales {
gen effective_`x'_price = tot_`x'val_trim/tot_`x'quant_trim
}

duplicates drop id MS, force

foreach y in effective_purchase_price effective_sales_price {

foreach x in treat12{

replace z = `x'

areg `y' z, a(strata_group) cl(groupnum)
local pval_p = (2 * ttail(e(df_r), abs(_b[z]/_se[z])))


preserve
clear
set obs 1
gen pval_p = `pval_p'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_`y'_`x'.dta", replace
restore

}


foreach x in treat13{

replace z = `x'
label var z "Treat"

areg `y' z, a(strata_group) cl(groupnum)
local pval_p = (2 * ttail(e(df_r), abs(_b[z]/_se[z])))

preserve
clear
set obs 1
gen pval_p = `pval_p'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_`y'_`x'.dta", replace
restore

}


foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"

areg `y' z MS, a(strata_group) cl(groupnum)
local pval_p = (2 * ttail(e(df_r), abs(_b[z]/_se[z])))

preserve
clear
set obs 1
gen pval_p = `pval_p'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_`y'_`x'.dta", replace
restore


}
}

drop z z_1 z_2 z_3 

*treatment intensity
use "$main/MS1MS2_pooled.dta", clear 

foreach y in inventory_trim netrevenue_trim logtotcons_trim {
cap drop z z_hi z_1 z_2 z_3 
gen z = .
gen z_hi = .
forval i = 1/3{
gen z_`i' = .
}
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*Hi"

reg `y' z hi z_hi interviewdate Y1round2 Y1round3, cl(subloc) // if run areg, hi drops out becuase the strata are at the 

foreach j in z hi z_hi {
local pval_`j' = (2 * ttail(e(df_r), abs(_b[`j']/_se[`j'])))
}

preserve
clear
set obs 1
gen pval_z = `pval_z'
gen pval_hi = `pval_hi'
gen pval_z_hi = `pval_z_hi'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_intens_`y'_`x'.dta", replace
restore

}

foreach x in treat13{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*Hi"

reg `y' z hi z_hi interviewdate  Y2round2 Y2round3,  cl(subloc) 

foreach j in z hi z_hi {
local pval_`j' = (2 * ttail(e(df_r), abs(_b[`j']/_se[`j'])))
}

preserve
clear
set obs 1
gen pval_z = `pval_z'
gen pval_hi = `pval_hi'
gen pval_z_hi = `pval_z_hi'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_intens_`y'_`x'.dta", replace
restore

}

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
replace z_hi = `x'hi
label var z_hi "Treat*Hi"

reg `y' z hi z_hi interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3,  cl(subloc) 

foreach j in z hi z_hi {
local pval_`j' = (2 * ttail(e(df_r), abs(_b[`j']/_se[`j'])))
}

preserve
clear
set obs 1
gen pval_z = `pval_z'
gen pval_hi = `pval_hi'
gen pval_z_hi = `pval_z_hi'
gen varname = "`y'"
gen year = "`x'"
save "$temp/fwer_intens_`y'_`x'.dta", replace
restore

}

}

drop z z_hi z_1 z_2 z_3 

***combine all p-vals***

clear
foreach y in inventory_trim netrevenue_trim logtotcons_trim effective_purchase_price effective_sales_price {
foreach x in treat12 treat13 treatMS1MS2{
append using "$temp/fwer_`y'_`x'.dta"
}
}

foreach y in inventory_trim netrevenue_trim logtotcons_trim  {
foreach x in treat12 treat13 treatMS1MS2{
append using "$temp/fwer_intens_`y'_`x'.dta"
}
}

forval i = 1/3{
preserve
gen round = "`i'" 
keep pval_r`i' varname year round
rename pval_r`i' pval
save "$temp/fwer_r`i'.dta", replace
restore
}

foreach x in z hi z_hi {
preserve
gen round = "Intensity - `x'"
keep pval_`x' varname year round
rename pval_`x' pval
save "$temp/fwer_intense_`x'.dta", replace
restore
}

gen round = "Pooled"
keep pval_p varname year round
rename pval_p pval
forval i = 1/3{
append using "$temp/fwer_r`i'.dta"
}
append using "$temp/fwer_intense_z.dta"
append using "$temp/fwer_intense_hi.dta"
append using "$temp/fwer_intense_z_hi.dta"

drop if pval == .

*generate groups of families to test FWER***

gen group = .
local i = 0
foreach x in treat12 treat13 treatMS1MS2 {
local i = `i' + 1
replace group = `i' if year== "`x'" &  round == "Pooled"
local i = `i' + 1
replace group = `i' if year== "`x'" & (round == "Intensity - z" | round == "Intensity - hi" | round == "Intensity - z_hi")
local i = `i' + 1
replace group = `i' if year== "`x'" &  (round == "1" | round == "2" | round == "3")
}

***the below is code modified from Anderson (2008)***

* Collect the total number of p-values tested

forval i = 1/9 {
preserve
keep if group == `i'
quietly sum pval
local totalpvals = r(N)

* Sort the p-values in ascending order and generate a variable that codes each p-value's rank

quietly gen int original_sorting_order = _n
quietly sort pval
quietly gen int rank = _n if pval~=.

* Set the initial counter to 1 

local qval = 1

* Generate the variable that will contain the BH (1995) q-values

gen bh95_qval = 1 if pval~=.

* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.

while `qval' > 0 {
	* Generate value qr/M
	quietly gen fdr_temp = `qval'*rank/`totalpvals'
	* Generate binary variable checking condition p(r) <= qr/M
	quietly gen reject_temp = (fdr_temp>=pval) if fdr_temp~=.
	* Generate variable containing p-value ranks for all p-values that meet above condition
	quietly gen reject_rank = reject_temp*rank
	* Record the rank of the largest p-value that meets above condition
	quietly egen total_rejected = max(reject_rank)
	* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
	replace bh95_qval = `qval' if rank <= total_rejected & rank~=.
	* Reduce q by 0.001 and repeat loop
	quietly drop fdr_temp reject_temp reject_rank total_rejected
	local qval = `qval' - .001
}
	
quietly sort original_sorting_order
drop original_sorting_order rank
rename bh95_qval bh95_qval_g`i'

save "$temp/fwer_g`i'.dta", replace
restore
}

forval i = 1/9{
merge 1:1 varname year round group using "$temp/fwer_g`i'.dta", nogen
}

gen bh95_qval = .
forval i = 1/9{
replace bh95_qval = bh95_qval_g`i' if group == `i'
}
drop bh95_qval_g* group
rename round round_name

save "$temp/fwer_pvals.dta", replace

***bring fwer pvals into main tables***

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


append using "$temp/fwer_pvals.dta" 

replace oafid = fr_id if MS == 2



drop purchaseval_trim salesval_trim // only trimmed this in Y2, so drop and retrim all

foreach x in purchaseval salesval purchasequant salesquant {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  //generate trimmed sales value, with top 1% trimmed
drop qnt
}


gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
foreach y in inventory_trim netrevenue_trim logtotcons_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "`y'" & year == "`x'" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "`y'" & year == "`x'" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
forval k = 1/3 {
qui sum pval if varname == "`y'" & year == "`x'" & round_name == "`k'"
estadd sca pval_naive`k' = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive`k' = "$<$0.01", replace
}
qui sum bh95_qval if varname == "`y'" & year == "`x'" & round_name == "`k'"
estadd sca bh95_qval`k' = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval`k' = "$<$0.01", replace
}
est sto reg`i'b_`y'
}

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "`y'" & year == "`x'" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "`y'" & year == "`x'" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
forval k = 1/3 {
qui sum pval if varname == "`y'" & year == "`x'" & round_name == "`k'"
estadd sca pval_naive`k' = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive`k' = "$<$0.01", replace
}
qui sum bh95_qval if varname == "`y'" & year == "`x'" & round_name == "`k'"
estadd sca bh95_qval`k' = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval`k' = "$<$0.01", replace
}
est sto reg`i'b_`y'
}

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "`y'" & year == "`x'" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "`y'" & year == "`x'" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
forval k = 1/3 {
qui sum pval if varname == "`y'" & year == "`x'" & round_name == "`k'"
estadd sca pval_naive`k' = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive`k' = "$<$0.01", replace
}
qui sum bh95_qval if varname == "`y'" & year == "`x'" & round_name == "`k'"
estadd sca bh95_qval`k' = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval`k' = "$<$0.01", replace
}
est sto reg`i'b_`y'
}

}

esttab reg*`y' using "$tbls2/p_indiv_`y'_robustfwer_refreport.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f %10.2f %10.2f %10.2f  %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" "pval_naive P-Val Treat" "pval_naive1 P-Val Treat - R1" "pval_naive2 P-Val Treat - R2" "pval_naive3 P-Val Treat - R3"  "bh95_qval P-Val Treat FWER" "bh95_qval1 P-Val Treat- R1 FWER" "bh95_qval2 P-Val Treat- R2 FWER" "bh95_qval3 P-Val Treat- R3 FWER") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	esttab reg*`y' using "$tbls2/p_indiv_`y'_robustfwer.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %10.2f  %10.2f %10.2f %10.2f %10.2f  %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" "pval_naive P-Val Treat" "bh95_qval P-Val Treat FWER" "pval_naive1 P-Val Treat - R1" "bh95_qval1 P-Val Treat - R1 FWER" "pval_naive2 P-Val Treat - R2" "bh95_qval2 P-Val Treat - R2 FWER" "pval_naive3 P-Val Treat - R3"  "bh95_qval3 P-Val Treat - R3 FWER") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

if "`y'"== "netrevenue_trim" {

esttab reg*`y' using "$tbls2/p_indiv_`y'_robustfwer_refreport.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.2f %10.2f %10.2f %10.2f  %10.2f %10.2f %10.2f %10.2f  %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" "pval_naive P-Val Treat" "pval_naive1 P-Val Treat - R1" "pval_naive2 P-Val Treat - R2" "pval_naive3 P-Val Treat - R3"  "bh95_qval P-Val Treat FWER" "bh95_qval1 P-Val Treat- R1 FWER" "bh95_qval2 P-Val Treat- R2 FWER" "bh95_qval3 P-Val Treat- R3 FWER") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	esttab reg*`y' using "$tbls2/p_indiv_`y'_robustfwer.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.0f %10.2f %10.2f %10.2f %10.2f  %10.2f %10.2f %10.2f %10.2f  %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" "pval_naive P-Val Treat" "bh95_qval P-Val Treat FWER" "pval_naive1 P-Val Treat - R1" "bh95_qval1 P-Val Treat - R1 FWER" "pval_naive2 P-Val Treat - R2" "bh95_qval2 P-Val Treat - R2 FWER" "pval_naive3 P-Val Treat - R3"  "bh95_qval3 P-Val Treat - R3 FWER") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))


}
	
}

drop z z_1 z_2 z_3
cap est drop reg*

***********
*TABLE F.9
***********

gen z = treatMS1MS2
label var z "Treat"
foreach y in netsales_trim    {
areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_a_`y'

areg `y' treatMS1MS2_1 treatMS1MS2_2 treatMS1MS2_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_b_`y'

}
drop z

preserve
gen id = oafid
replace id = fr_id if id == .
replace id = 2222222222 if varname == "effective_purchase_price" & year == "treat12" & round_name == "Pooled" // done to avoid dropping below
replace id = 3333333333 if varname == "effective_sales_price" & year == "treat12" & round_name == "Pooled" // done to avoid dropping below
replace id = 4444444444 if varname == "effective_purchase_price" & year == "treat13" & round_name == "Pooled" // done to avoid dropping below
replace id = 5555555555 if varname == "effective_sales_price" & year == "treat13" & round_name == "Pooled" // done to avoid dropping below
replace id = 9999999999 if varname == "effective_purchase_price" & year == "treatMS1MS2" & round_name == "Pooled" // done to avoid dropping below
replace id = 8888888888 if varname == "effective_sales_price" & year == "treatMS1MS2" & round_name == "Pooled" // done to avoid dropping below
foreach x in salesquant_trim purchasequant_trim salesval_trim purchaseval_trim {
bysort id MS: egen tot_`x' = total(`x')
}

foreach x in purchase sales {
gen effective_`x'_price = tot_`x'val_trim/tot_`x'quant_trim
}


gen z = treat12
label var z "Treat"

duplicates drop id MS, force
areg effective_purchase_price z if MS==1, a(strata_group)   cl(groupnum)
qui summ effective_purchase_price if z ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_purchase_price" & year == "treat12" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_purchase_price" & year == "treat12" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_purchase_price_Y1

drop z
gen z = treat13
label var z "Treat"

areg effective_purchase_price z if MS==2, a(strata_group)   cl(groupnum)
qui summ effective_purchase_price if treat13 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_purchase_price" & year == "treat13" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_purchase_price" & year == "treat13" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_purchase_price_Y2

drop z
gen z = treatMS1MS2
label var z "Treat"

areg effective_purchase_price z MS, a(strata_group)   cl(groupnum)
qui summ effective_purchase_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_purchase_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_purchase_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_purchase_price_p

drop z
gen z = treat12
label var z "Treat"

areg effective_sales_price z if MS==1, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treat12 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_sales_price" & year == "treat12" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_sales_price" & year == "treat12" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_sales_price_Y1

drop z
gen z = treat13
label var z "Treat"

areg effective_sales_price z if MS==2, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treat13 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_sales_price" & year == "treat13" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_sales_price" & year == "treat13" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_sales_price_Y2

drop z
gen z = treatMS1MS2
label var z "Treat"

areg effective_sales_price z MS, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_sales_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_sales_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_sales_price_p
drop z
restore

gen z= .
label var z "Treat"


esttab reg_eff_purchase_price_* reg_eff_sales_price_* using "$tbls2/p_effective_price_robustfwer.tex", drop( _cons MS) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" "pval_naive P-Val Treat" "bh95_qval P-Val Treat FWER") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) nonum ///
	mtitles("Y1" "Y2" "Pooled" "Y1" "Y2" "Pooled") ///
	mgroups("\multicolumn{3}{c}{Purchase} & \multicolumn{3}{c}{Sales} \\ \cline{2-4} \cline{5-7} ", pattern(1 0 1 0))


drop z
cap est drop reg*




***********
/*TABLE 5*/
***********

use "$main/MS1MS2_pooled.dta", clear 
sum strata_group // strata_group is the Y1 strata variable
local max = r(max) 
replace strata_group = groupstrata + `max' if MS == 2 // groupstrata is the Y2 strata variable


append using "$temp/fwer_pvals.dta" // manually bring in the fwer pvals

replace oafid = fr_id if MS == 2

sum salesval salesquant purchaseval purchasequant if  netrevenue!=. & netsales==. 
gen purchasequant2 = purchasequant
replace purchasequant2 = 0 if purchasequant==. & purchaseval==0
gen netsales2 = salesquant-purchasequant2
sum netsales2 netsales if purchasequant!=. 
drop netsales netsales_trim
rename netsales2 netsales

drop purchaseval_trim salesval_trim 

foreach x in purchaseval salesval purchasequant salesquant  {
cap drop qnt
xtile qnt = `x', n(100)
gen `x'_trim = `x'
replace `x'_trim =. if qnt==100  
drop qnt
}




foreach x in netsales {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}



gen z = treatMS1MS2
label var z "Treat"
foreach y in netsales_trim    {
areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)

est sto reg_a_`y'

areg `y' treatMS1MS2_1 treatMS1MS2_2 treatMS1MS2_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
est sto reg_b_`y'

}
drop z

preserve
gen id = oafid
replace id = fr_id if id == .
replace id = 2222222222 if varname == "effective_purchase_price" & year == "treat12" & round_name == "Pooled" // done to avoid dropping below
replace id = 3333333333 if varname == "effective_sales_price" & year == "treat12" & round_name == "Pooled" // done to avoid dropping below
replace id = 4444444444 if varname == "effective_purchase_price" & year == "treat13" & round_name == "Pooled" // done to avoid dropping below
replace id = 5555555555 if varname == "effective_sales_price" & year == "treat13" & round_name == "Pooled" // done to avoid dropping below
replace id = 9999999999 if varname == "effective_purchase_price" & year == "treatMS1MS2" & round_name == "Pooled" // done to avoid dropping below
replace id = 8888888888 if varname == "effective_sales_price" & year == "treatMS1MS2" & round_name == "Pooled" // done to avoid dropping below
foreach x in salesquant_trim purchasequant_trim salesval_trim purchaseval_trim {
bysort id MS: egen tot_`x' = total(`x')
}

foreach x in purchase sales {
gen effective_`x'_price = tot_`x'val_trim/tot_`x'quant_trim
}


gen z = treat12
label var z "Treat"

duplicates drop id MS, force
areg effective_purchase_price z if MS==1, a(strata_group)   cl(groupnum)
qui summ effective_purchase_price if z ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_purchase_price" & year == "treat12" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_purchase_price" & year == "treat12" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_purchase_price_Y1

drop z
gen z = treat13
label var z "Treat"

areg effective_purchase_price z if MS==2, a(strata_group)   cl(groupnum)
qui summ effective_purchase_price if treat13 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_purchase_price" & year == "treat13" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_purchase_price" & year == "treat13" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_purchase_price_Y2

drop z
gen z = treatMS1MS2
label var z "Treat"

areg effective_purchase_price z MS, a(strata_group)   cl(groupnum)
qui summ effective_purchase_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_purchase_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_purchase_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_purchase_price_p

drop z
gen z = treat12
label var z "Treat"

areg effective_sales_price z if MS==1, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treat12 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_sales_price" & year == "treat12" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_sales_price" & year == "treat12" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_sales_price_Y1

drop z
gen z = treat13
label var z "Treat"

areg effective_sales_price z if MS==2, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treat13 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_sales_price" & year == "treat13" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_sales_price" & year == "treat13" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_sales_price_Y2

drop z
gen z = treatMS1MS2
label var z "Treat"

areg effective_sales_price z MS, a(strata_group) cl(groupnum)
qui summ effective_sales_price if treatMS1MS2 ==0
estadd sca mdv = r(mean)
estadd sca sd = r(sd)
qui sum pval if varname == "effective_sales_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca pval_naive = r(mean)
if r(mean) <0.005 {
estadd loc pval_naive = "$<$0.01", replace
}
qui sum bh95_qval if varname == "effective_sales_price" & year == "treatMS1MS2" & round_name == "Pooled"
estadd sca bh95_qval = r(mean)
if r(mean) <0.005 {
estadd loc bh95_qval = "$<$0.01", replace
}
est sto reg_eff_sales_price_p
drop z
restore

gen z= .
label var z "Treat"


esttab reg_a_netsales_trim reg_b_netsales_trim reg_eff_purchase_price_p reg_eff_sales_price_p using "$tbls2/p_netsales_effective_price_robustfwer_refreport2.tex", drop(interviewdate Y*round* _cons MS) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "sd SD DV" "N Observations" "r2 R squared" "pval_naive P-Val Treat" "bh95_qval P-Val Treat FWER") ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) nonum ///
	mtitles("Overall" "By rd" "Purchase" "Sales" ) ///
	mgroups("\multicolumn{2}{c}{Net Sales} & \multicolumn{2}{c}{Effective Price}  \\ \cline{2-3} \cline{4-5} ", pattern(1 0 1 0))


drop z
cap est drop reg*








**********************************
* Table D.1
**********************************

use "$main/MS1MS2_pooled.dta", clear 
drop if MS==2

lab var hi "Hi intensity"
lab var treat12 "Treated"
lab var treat12hi "Treated*Hi"
lab var T1 "T1"
lab var T2 "T2"

gen takeup = 0
replace takeup=1 if loan_size > 0 & loan_size!=.
replace takeup = 0 if T1==0 & T2==0


bysort oafid: egen totalsalesval = total(salesval)
bysort oafid: egen totalsalesquant = total(salesquant)
bysort oafid: egen totalpurchval = total(purchaseval)
bysort oafid: egen totalpurchquant = total(purchasequant)
gen effective_sale_price = totalsalesval/totalsalesquant
gen effective_purch_price = totalpurchval/totalpurchquant

foreach x in effective_sale_price effective_purch_price {
cap drop qnt
xtile qnt = `x', n(200)
gen `x'_trim = `x'
replace `x'_trim =. if (qnt==1 | qnt==200) 
drop qnt
}



* T1 vs T2 - add in test for T1 = T2
cap est drop reg*
preserve // take up reg, only one obs per id
sort oafid round
duplicates drop oafid, force
areg takeup T1 T2 if tags==0, a(strata_group) cl(groupnum)
est sto reg0
estadd ysumm
estadd loc cont "No"
test T1 = T2
estadd sca pt = r(p)
restore

areg inventory_trim T1 T2 harvest interviewdate round2 round3 if tags==0, a(strata_group) cl(groupnum)
est sto reg1
estadd ysumm
estadd loc cont "Yes"
test T1 = T2
estadd sca pt = r(p)

areg inventory_trim T1_1 T1_2 T1_3 T2_1 T2_2 T2_3 round2 round3 harvest interviewdate if tags==0, a(strata_group) cl(groupnum)
est sto reg2
estadd ysumm
estadd loc cont "Yes"

preserve // price reg, only one obs per id
sort oafid round
duplicates drop oafid, force
areg effective_purch_price_trim T1 T2 harvest if tags==0, a(strata_group) cl(groupnum) 
est sto reg3
estadd ysumm
estadd loc cont "Yes"
test T1 = T2
estadd sca pt = r(p)
restore

preserve // price reg, only one obs per id
sort oafid round
duplicates drop oafid, force
areg effective_sale_price_trim T1 T2 harvest if tags==0, a(strata_group) cl(groupnum)  
est sto reg4
estadd ysumm
estadd loc cont "Yes"
restore

areg netrevenue_trim T1 T2 harvest interviewdate round2 round3 if tags==0, a(strata_group) cl(groupnum)
est sto reg5
estadd ysumm
estadd loc cont "Yes"
test T1 = T2
estadd sca pt = r(p)

areg netrevenue_trim T1_1 T1_2 T1_3 T2_1 T2_2 T2_3 round2 round3 harvest interviewdate if tags==0, a(strata_group) cl(groupnum)
est sto reg6
estadd ysumm
estadd loc cont "Yes"
lincom T1_1 + T1_2 + T1_3

areg logtotpercapcons_trim T1 T2 logpercapcons_base interviewdate round2 round3 if tags==0, a(strata_group) cl(groupnum)
est sto reg7
estadd ysumm
estadd loc cont "Yes"
test T1 = T2
estadd sca pt = r(p)

areg logtotpercapcons_trim T1_1 T1_2 T1_3 T2_1 T2_2 T2_3 round2 round3 logpercapcons_base interviewdate if tags==0, a(strata_group) cl(groupnum)
est sto reg8
estadd ysumm
estadd loc cont "Yes"
lincom T1_1 + T1_2 + T1_3


lab var T1_1 "T1 - Round 1"
lab var T1_2 "T1 - Round 2"
lab var T1_3 "T1 - Round 3"
lab var T2_1 "T2 - Round 1"
lab var T2_2 "T2 - Round 2"
lab var T2_3 "T2 - Round 3"
esttab reg* using "$tbls1/sub_treatments_main_2.tex", drop(harvest interviewdate round* logpercapcons_base _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("ymean Mean of Dep Variable" "ysd SD of Dep Variable" "N Observations" "r2 R squared" "pt T1 = T2 (pval)") ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Pooled" "Pooled" "By round" "Purchase price" "Sales prices" "Pooled" "By round" "Pooled" "By round") ///
	mgroups("\multicolumn{1}{c}{Take-up} & \multicolumn{2}{c}{Inventories} & \multicolumn{2}{c}{Prices} & \multicolumn{2}{c}{Revenues} & \multicolumn{2}{c}{Consumption} \\ \cline{2-2} \cline{3-4} \cline{5-6} \cline{7-8} \cline{9-10}", pattern(1 0 1 0))



*******************************
* Table E.11, E.13
*******************************

use "$main/MS1MS2_pooled.dta", clear

egen all_credit_trim = rowtotal(bank_loan_amt_trim amt_skylocker_trim amt_friend_trim)
gen any_borrow = 0 if all_credit !=.
replace any_borrow = 1 if all_credit!=. & all_credit>0

foreach y in all_credit_trim bank_loan_amt_trim amt_skylocker_trim amt_friend_trim  {
gen lg_`y'=log(`y')
}

gen z = .
forval i = 1/3{
gen z_`i' = .
}

cap est drop reg*
 

foreach y in any_borrow all_credit_trim lg_all_credit_trim bank_loan_amt_trim lg_bank_loan_amt_trim lg_amt_skylocker_trim amt_skylocker_trim lg_amt_friend_trim amt_friend_trim {
local i = 1
foreach x in treat12{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treat13{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y2round2 Y2round3, a(strata_group)  cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

local i = `i' + 1

foreach x in treatMS1MS2{

replace z = `x'
label var z "Treat"
forval k = 1/3{
replace z_`k' = `x'_`k'
label var z_`k' "Treat - R`k'"
}

areg `y' z interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group) cl(groupnum)
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'a_`y'

areg `y' z_1 z_2 z_3 interviewdate Y1round2 Y1round3 Y2round1 Y2round2 Y2round3, a(strata_group)  cl(groupnum )
qui summ `y' if `x'==0
estadd sca mdv = r(mean)
est sto reg`i'b_`y'

}

esttab reg*`y' using "$tbls2/p_`y'_byround_2.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))

	if "`y'"== "all_credit_trim" {

esttab reg*`y' using "$tbls2/p_`y'_byround_2.tex", drop(interviewdate Y*round* _cons) ///
	replace b(%10.0f %10.0f %10.0f %10.0f %10.0f) se l sfmt(%10.0f %10.0f %10.2f %10.0f %10.0f %10.0f %3s) ///
	scalars("mdv Mean DV" "N Observations" "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Overall" "By rd" "Overall" "By rd" "Overall" "By rd") ///
	mgroups("\multicolumn{2}{c}{Y1} & \multicolumn{2}{c}{Y2} & \multicolumn{2}{c}{Pooled} \\ \cline{2-3} \cline{4-5} \cline{6-7}", pattern(1 0 1 0))
	
	
	}
}

drop z z_1 z_2 z_3
cap est drop reg*

*******************************
* Table E.14, E.15
*******************************

preserve
use "$main/repayment_dataY1.dta" , clear
gen MS = 1
save "$temp/repayment_dataY1_MS.dta" , replace
restore

bysort oafid MS: egen all_credit_trim_total = total(all_credit_trim)
keep groupnum oafid treatMS1MS2 loan_size MS all_credit_trim_total
duplicates drop oafid MS, force // only want one obs per individual
merge 1:1 MS oafid using "$temp/repayment_dataY1_MS.dta" 
replace loan_size = 0 if loan_size==.
gen non_MS_loan_amt = totalcredit -  loan_size if MS == 1 
replace  non_MS_loan_amt = 0 if non_MS_loan_amt <0

egen total_credit_cash = rowtotal(all_credit_trim_total loan_size)
egen total_inkindandcash_credit = rowtotal(totalcredit all_credit_trim_total)

label var treatMS1MS2 "Treat"

reg total_inkindandcash_credit treatMS1MS2 if MS == 1, cl(groupnum)
qui summ totalcredit if treatMS1MS2==0
estadd sca mdv = r(mean)
est sto reg1

reg totalcredit treatMS1MS2 if MS == 1, cl(groupnum)
qui summ totalcredit if treatMS1MS2==0
estadd sca mdv = r(mean)
est sto reg2


esttab reg2 reg1 using "$tbls2/total_credit_oaf_2.tex", drop(  _cons) ///
	replace b(%10.0f %10.0f %10.2f %10.2f %10.2f) se l sfmt(%10.0f %10.0f %10.2f %10.2f %10.2f %10.2f %3s) ///
	scalars("mdv Mean DV" "N Observations"  "r2 R squared" ) ///	
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(14cm) nonum ///
	mtitles("Value of OAF Services" "Value of OAF Services + Credit")

eststo clear



*********************
* Table J.5
*********************

*prep baseline data
use "$main/baseline.dta", clear
keep price_avg_diff_pct site
replace site = upper(site)
rename site sublocation
replace sublocation = "KULUMBENI" if sublocation== "KULUMBENI A" 
replace sublocation = "MAKHUKHUNI" if sublocation== "KULUMBENI B" 
replace sublocation = "MARAKA" if sublocation== "MARAKA A"
replace sublocation = "MIHUU" if sublocation=="MIHUU LOWER"
replace sublocation = "SIPALA" if sublocation=="MIHUU UPPER"
replace sublocation = "NAMILIMO"  if sublocation=="BOKOLI B"

collapse (median) price_avg_diff_pct, by(sublocation)
foreach x in 1km_wt 3km_wt 5km_wt  {
preserve
rename sublocation subloc_`x'
rename price_avg_diff_pct price_avg_diff_pct_`x'
save "$temp/baseline_price_diff_formerge_`x'.dta", replace
restore
}

*merge into price data
use "$main/cleanPriceData_Y1Y2.dta", clear
foreach x in 1km_wt 3km_wt 5km_wt  {
merge m:1 subloc_`x' using "$temp/baseline_price_diff_formerge_`x'.dta"
drop if _m == 2
drop _m
}

gen hi = .
gen interact=.
gen interact_lean = .


foreach x in 1km_wt 3km_wt 5km_wt  {
preserve

sum salesPrice_trim if monthnum==0 & hi_`x'==0
local norm = 100/r(mean)
gen salesPrice_trim_norm = salesPrice_trim*`norm' // normalized so that mean prices in low intensity areas in November is 100

replace hi = hi_`x'
replace interact = monthnum*hi
replace interact_lean = lean*hi

*Y1
cgmwildboot salesPrice_trim_norm hi monthnum interact price_avg_diff_pct_`x' if in_sample == 1 & MS == 1, cl(subloc_`x'_grp) bootcluster(subloc_`x'_grp)  reps(1000) seed(65464654) // manually bring in these pvals into tables below
reg salesPrice_trim_norm hi monthnum interact price_avg_diff_pct_`x' if in_sample==1 & MS == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 1  & in_sample == 1
estadd sca mdv = r(mean)
foreach z in hi monthnum interact {
	local pval_`z' = (2 * ttail(e(df_r), abs(_b[`z']/_se[`z'])))
	estadd sca pval_`z' = `pval_`z''
	}
if "`x'"== "3km_wt" {
	estadd sca pval_hi_wb =  0.094
	estadd sca pval_monthnum_wb = 0.040
	estadd sca pval_interact_wb = 0.176
	}
est sto reg_y1_`x'


*Y2
cgmwildboot salesPrice_trim_norm hi monthnum interact price_avg_diff_pct_`x' if in_sample == 1 & MS == 2, cl(subloc_`x'_grp) bootcluster(subloc_`x'_grp)  reps(1000) seed(65464654) // manually bring in these pvals into tables below
reg salesPrice_trim_norm hi monthnum interact price_avg_diff_pct_`x' if MS == 2 & in_sample==1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & MS == 2  & in_sample == 1
estadd sca mdv = r(mean)
foreach z in hi monthnum interact {
	local pval_`z' = (2 * ttail(e(df_r), abs(_b[`z']/_se[`z'])))
	estadd sca pval_`z' = `pval_`z''
	}
if "`x'"== "3km_wt" {
	estadd sca pval_hi_wb =  0.228
	estadd sca pval_monthnum_wb = 0.000
	estadd sca pval_interact_wb = 0.284
	}
est sto reg_y2_`x'


*Pooled
cgmwildboot salesPrice_trim_norm hi monthnum interact price_avg_diff_pct_`x' if in_sample == 1, cl(subloc_`x'_grp) bootcluster(subloc_`x'_grp)  reps(1000) seed(65464654) // manually bring in these pvals into tables below
reg salesPrice_trim_norm hi monthnum interact price_avg_diff_pct_`x' if in_sample == 1, cl(subloc_`x'_grp)
qui summ salesPrice_trim_norm if hi == 0 & in_sample == 1
estadd sca mdv = r(mean)
foreach z in hi monthnum interact {
	local pval_`z' = (2 * ttail(e(df_r), abs(_b[`z']/_se[`z'])))
	estadd sca pval_`z' = `pval_`z''
	}
if "`x'"== "3km_wt" {
	estadd sca pval_hi_wb =  0.108
	estadd sca pval_monthnum_wb = 0.034
	estadd sca pval_interact_wb = 0.164
	}
if "`x'"== "1km_wt" {
	estadd sca pval_hi_wb =  0.188
	estadd sca pval_monthnum_wb = 0.022
	estadd sca pval_interact_wb = 0.208
	}
if "`x'"== "5km_wt" {
	estadd sca pval_hi_wb =  0.136
	estadd sca pval_monthnum_wb = 0.000
	estadd sca pval_interact_wb = 0.056
	}
est sto reg_p_`x'


restore
}

lab var hi "High"
lab var	monthnum "Month"
lab var interact "High Intensity * Month"
lab var interact_lean "High Intensity * Lean"

esttab reg_y1_3km_wt reg_y2_3km_wt reg_p_3km_wt reg_p_1km_wt reg_p_5km_wt using "$tbls2/price_effects_main_robust_to_control.tex", drop( _cons price_avg_diff_pct*) ///
	replace b(%10.2f %10.2f %10.2f %10.2f %10.2f) se l sfmt(%10.2f %10.2f  %10.3f %10.3f %10.3f %10.3f %10.3f %10.3f) ///
	scalars("N Obs." "r2 R squared" "pval_hi P-val High"  "pval_hi_wb P-val High Bootstrap" "pval_monthnum P-val Month" "pval_monthnum_wb P-val Month Bootstrap" "pval_interact P-val High*Month"  "pval_interact_wb P-val High*Month Bootstrap") ///
	star(* 0.10 ** 0.05 *** 0.01) compress nonotes width(\hsize) ///
	mtitles("Y1" "Y2"  "Pooled" "1km" "5km" "Binary, 3km") nonum ///
	mgroups("\multicolumn{3}{c}{Main Specification (3km)} & \multicolumn{2}{c}{Robustness (Pooled)}  \\ \cline{2-4} \cline{5-6}", pattern(1 0 1 0))

	
	eststo clear



