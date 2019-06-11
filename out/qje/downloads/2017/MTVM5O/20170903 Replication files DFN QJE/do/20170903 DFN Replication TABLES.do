*JOPPE DE REE, SEPTEMBER 3 2017 (joppederee@gmail.com)
*version: Stata/MP 13.0 

clear
clear matrix
clear mata
set mem 1000m
set more off
set matsize 450

global FOLDER "C:\20170903 Replication files DFN QJE"

global IN2 "$FOLDER\dta\REPLICATION"
global OUTPUT "$FOLDER\output"

*************************************************************************
*TABLES
*************************************************************************

capt prog drop TABLE_TE1
program TABLE_TE1, eclass
	syntax varlist [if] [in], by(varname) clus_id(varname numeric) strat_id(varname numeric) [ * ] 

	marksample touse
	markout `touse' `by'
	tempname mu_1 mu_2 mu_3 mu_4 se_1 se_2 se_3 se_4 d_p d_p2
	capture drop TD*
	tab `by' , gen(TD)
	foreach var of local varlist {
		reg `var'  TD1 TD2   `if', nocons vce(cluster `clus_id')
		test (_b[TD1]- _b[TD2]== 0)
		mat `d_p'  = nullmat(`d_p'),r(p)
		matrix A=e(b)
		lincom (TD1-TD2)
		mat `mu_3' = nullmat(`mu_3'), A[1,2]-A[1,1]			
		mat list `mu_3'
		if e(rmse)==0{
			mat `se_3' = nullmat(`se_3'),.
			}
		if e(rmse)>0{
			mat `se_3' = nullmat(`se_3'), r(se)
			}
		sum `var' if TD2==1 & e(sample)==1
		mat `mu_1' = nullmat(`mu_1'), r(mean)
		mat `se_1' = nullmat(`se_1'), r(sd)
		sum `var' if TD1==1 & e(sample)==1
		mat `mu_2' = nullmat(`mu_2'),r(mean)
		mat `se_2' = nullmat(`se_2'), r(sd)
		 
		reg `var'  TD1 TD2  i.`strat_id' `if', nocons vce(cluster `clus_id')
		test (_b[TD1]- _b[TD2]== 0)
		mat `d_p2'  = nullmat(`d_p2'),r(p)
		matrix A=e(b)
		lincom (TD1-TD2)
		mat `mu_4' = nullmat(`mu_4'), A[1,2]-A[1,1]
		if e(rmse)==0{
			mat `se_4' = nullmat(`se_4'),.
			}
		if e(rmse)>0{
			mat `se_4' = nullmat(`se_4'), r(se)
			}
		}

	foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4 d_p d_p2 {
		mat coln ``mat'' = `varlist'				//columns get the names of the variables
		}
	local cmd "TABLE_TE1"
	foreach mat in mu_1 mu_2 mu_3 mu_4  se_1 se_2 se_3 se_4 d_p d_p2 {
		eret mat `mat' = ``mat''					//matrices with statistics are added to the "ereturn" memory, so that they can be used with esttab
		}
end


capt prog drop TABLE_TE2
program TABLE_TE2, eclass
	syntax varlist [if] [in], by(varname) clus_id(varname numeric) strat_id(varname numeric) [ * ] 

	marksample touse
	markout `touse' `by'
	tempname mu_1 mu_2 mu_3 mu_4 mu_5 se_1 se_2 se_3 se_4 se_5 d_p d_p2 d_p5
	capture drop TD*
	tab `by' , gen(TD)
	foreach var of local varlist {
		capture noisily reg `var'  TD1 TD2  `if', nocons vce(cluster `clus_id')
		capture noisily test (_b[TD1]- _b[TD2]== 0)
		capture noisily mat `d_p'  = nullmat(`d_p'),r(p)
		capture noisily matrix A=e(b)
		capture noisily lincom (TD1-TD2)
		capture noisily mat `mu_3' = nullmat(`mu_3'), A[1,2]-A[1,1]
		capture noisily mat `se_3' = nullmat(`se_3'), r(se)
		capture noisily sum `var' if TD2==1 & e(sample)==1
		capture noisily mat `mu_1' = nullmat(`mu_1'), r(mean)
		capture noisily mat `se_1' = nullmat(`se_1'), r(sd)
		capture noisily sum `var' if TD1==1 & e(sample)==1
		capture noisily mat `mu_2' = nullmat(`mu_2'),r(mean)
		capture noisily mat `se_2' = nullmat(`se_2'), r(sd)
		 
		capture noisily reg `var'  TD1 TD2  i.`strat_id' `if', nocons vce(cluster `clus_id')
		capture noisily test (_b[TD1]- _b[TD2]== 0)
		capture noisily mat `d_p2'  = nullmat(`d_p2'),r(p)
		capture noisily matrix A=e(b)
		capture noisily lincom (TD1-TD2)
		capture noisily mat `mu_4' = nullmat(`mu_4'), A[1,2]-A[1,1]
		capture noisily mat `se_4' = nullmat(`se_4'), r(se)
		
		*this is the extra specification (model that controls for baseline values)
		capture noisily gen blv_ = `var' if year==0

		capture noisily egen blv = max(blv_), by(teacher_id)
		capture noisily reg `var' TD1 TD2 blv i.`strat_id' `if', nocons vce(cluster `clus_id')
		capture noisily drop blv blv_
		if e(N)!=. {
			capture noisily capture noisily test (_b[TD1]- _b[TD2]== 0)
			capture noisily mat `d_p5'  = nullmat(`d_p5'),r(p)
			capture noisily matrix A=e(b)
			capture noisily lincom (TD1-TD2)
			capture noisily mat `mu_5' = nullmat(`mu_5'), A[1,2]-A[1,1]
			capture noisily mat `se_5' = nullmat(`se_5'), r(se)
			}
		if e(N)==. {
			capture noisily mat `d_p5'  = nullmat(`d_p5'),.
			capture noisily mat `mu_5' = nullmat(`mu_5'),99999
			capture noisily mat `se_5' = nullmat(`se_5'),.
			}

		}
	foreach mat in mu_1 mu_2 mu_3 mu_4 mu_5 se_1 se_2 se_3 se_4 se_5 d_p d_p2 d_p5 {
		capture noisily mat coln ``mat'' = `varlist'
		}
		capture noisily local cmd "TABLE_TE2"
	foreach mat in mu_1 mu_2 mu_3 mu_4 mu_5 se_1 se_2 se_3 se_4 se_5 d_p d_p2 d_p5 {
		capture noisily eret mat `mat' = ``mat''
		}
end



*************************************************************************
*TABLES
*************************************************************************


*Table 1A

use "$IN2\school_baseline.dta", clear

global variables_school "nrrombel nrstudents classsize nrteachers" 

eststo clear
xi: TABLE_TE1 $variables_school if (SD==0|SD==1), by(treatment) clus_id(school_id) strat_id(triplet_id)

esttab using "$OUTPUT/Table1A.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab using "$OUTPUT/Table1A.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

*Table 1B

use "$IN2/students_baseline.dta", clear

global variables_students= "MAT_score IPA_score BIN_score BIG_score assets" 

eststo clear
xi: TABLE_TE1 $variables_students if (SD==0|SD==1), by(treatment) clus_id(school_id) strat_id(triplet_id)

esttab using "$OUTPUT/Table1B.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab using "$OUTPUT/Table1B.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

*Table 2

use "$IN2/teachers_baseline.dta", clear

global variables_teacher "g_score TARGET ALREADYCERTIFIED NOTELIGIBLE S1 rank4 PAID base_pay additional_pay certification_pay secondjob secondjobhours quota"

eststo clear
eststo m1: xi: TABLE_TE1 $variables_teacher if (SD==0|SD==1), by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m2: xi: TABLE_TE1 $variables_teacher if (SD==0|SD==1) & TARGET==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)

esttab m1 m2 using "$OUTPUT/Table2.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab m1 m2 using "$OUTPUT/Table2.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

*Table 3

use "$IN2/teachers.dta", clear

eststo clear
eststo m1: xi: TABLE_TE1 quota certified PAID if year==0  , by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m2: xi: TABLE_TE1 quota certified PAID if year==2  , by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m3: xi: TABLE_TE1 quota certified PAID if year==3  , by(treatment) clus_id(school_id) strat_id(triplet_id)

esttab m1 m2 m3 using "$OUTPUT/Table3A.tex", label replace fragment nolines gaps wrap  ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab m1 m2 m3 using "$OUTPUT/Table3A.csv", label replace fragment nolines gaps wrap  ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

eststo clear
eststo m1: xi: TABLE_TE1 quota certified PAID if year==0 & TARGET==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m2: xi: TABLE_TE1 quota certified PAID if year==2 & TARGET==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m3: xi: TABLE_TE1 quota certified PAID if year==3 & TARGET==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)

esttab m1 m2 m3 using "$OUTPUT/Table3B.tex", label replace fragment nolines gaps wrap  ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab m1 m2 m3 using "$OUTPUT/Table3B.csv", label replace fragment nolines gaps wrap  ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

*Table A3

eststo clear
eststo m1: xi: TABLE_TE1 quota certified PAID if year==0 & NOTELIGIBLE==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m2: xi: TABLE_TE1 quota certified PAID if year==2 & NOTELIGIBLE==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)
eststo m3: xi: TABLE_TE1 quota certified PAID if year==3 & NOTELIGIBLE==1 , by(treatment) clus_id(school_id) strat_id(triplet_id)

esttab m1 m2 m3 using "$OUTPUT/TableA3.tex", label replace fragment nolines gaps wrap  ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab m1 m2 m3 using "$OUTPUT/TableA3.csv", label replace fragment nolines gaps wrap  ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 


*Table 4

keep if tested==1|interviewed==1			

global var_teacher_tab4 "ngscore S1 pursue secondjob secondjobhours base_pay additional_pay certification_pay totalpay problems happy absent "

eststo clear
eststo m1: xi: TABLE_TE2 $var_teacher_tab4 if year==2, by(treatment) clus_id(school_id) strat_id(triplet_id) 
eststo m2: xi: TABLE_TE2 $var_teacher_tab4 if year==3, by(treatment) clus_id(school_id) strat_id(triplet_id) 
eststo m3: xi: TABLE_TE2 $var_teacher_tab4 if year==2 & TARGET==1, by(treatment) clus_id(school_id) strat_id(triplet_id) 
eststo m4: xi: TABLE_TE2 $var_teacher_tab4 if year==3 & TARGET==1, by(treatment) clus_id(school_id) strat_id(triplet_id) 

esttab m1 m2 m3 m4 using "$OUTPUT/Table4.tex", label replace fragment nolines  gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Control mean" "Treatment effect 1" "Treatment effect 2")  ///
cells("mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2)) mu_5(fmt(2) star pvalue(d_p5))" "se_2(par([ ])) se_4(par) se_5(par)") 

esttab m1 m2 m3 m4 using "$OUTPUT/Table4.csv", label replace fragment nolines  gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Control mean" "Treatment effect 1" "Treatment effect 2")  ///
cells("mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2)) mu_5(fmt(2) star pvalue(d_p5))" "se_2(par([ ])) se_4(par) se_5(par)") 

*Table A.6

use "$IN2/students.dta", clear

global controls10 "ITT_score0 missing_ITT_score0 schoolscore0 missing_schoolscore0"
label var treatment "Treatment effect"

eststo clear
foreach X in MAT IPA BIN BIG{
	eststo :areg ITT_score treatment $controls10 if (SD==0 | SD==1) & subject=="`X'" & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
	estadd ysumm
}
eststo : areg ITT_score treatment $controls10 if (SD==0 | SD==1) & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

foreach X in MAT IPA BIN {
	eststo :areg ITT_score treatment $controls10 if (SD==1)& subject=="`X'" & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
	estadd ysumm
}
eststo : areg ITT_score treatment $controls10 if (SD==1) & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

foreach X in MAT IPA BIN BIG{
	eststo :areg ITT_score treatment $controls10 if (SD==0)& subject=="`X'" & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)	
	estadd ysumm
}
eststo : areg ITT_score treatment $controls10 if (SD==0) & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

esttab using "$OUTPUT/TableA6A.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "\$R^2\$") fmt(%12.0fc 2)) ///
keep(treatment) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none)

esttab using "$OUTPUT/TableA6A.csv", label replace fragment nolines gaps ///
nomtitle nonumbers nodep noobs star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "R^2") fmt(0 2)) ///
keep(treatment) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none)

eststo clear
foreach X in MAT IPA BIN BIG{
	eststo :areg ITT_score treatment $controls10 if (SD==0 | SD==1) & subject=="`X'" & year==3 [pweight=weight], cluster(school_id)	absorb(triplet_id)
	estadd ysumm
}
eststo : areg ITT_score treatment $controls10 if (SD==0 | SD==1) & year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

foreach X in MAT IPA BIN{
	eststo :areg ITT_score treatment $controls10 if (SD==1) & subject=="`X'" & year==3 [pweight=weight], cluster(school_id)	absorb(triplet_id)
	estadd ysumm
}
eststo : areg ITT_score treatment $controls10 if (SD==1) & year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

foreach X in MAT IPA BIN BIG{
	eststo :areg ITT_score treatment $controls10 if (SD==0)& subject=="`X'" & year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)	
	estadd ysumm
}
eststo : areg ITT_score treatment $controls10 if (SD==0) & year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

esttab using "$OUTPUT/TableA6B.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "\$R^2\$") fmt(%12.0fc 2)) ///
keep(treatment) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none)

esttab using "$OUTPUT/TableA6B.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "R^2") fmt(0 2)) ///
keep(treatment) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none)

*Table 5 

eststo clear
eststo : areg ITT_score treatment $controls10 if (SD==0 | SD==1) & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm
eststo : areg ITT_score treatment $controls10 if (SD==0 | SD==1) & year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)
estadd ysumm

esttab using "$OUTPUT/Table5.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "\$R^2\$") fmt(%12.0fc 2)) ///
keep(treatment) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none)

esttab using "$OUTPUT/Table5.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "R^2") fmt(0 2)) ///
keep(treatment) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none)

*Table A8

eststo clear
foreach X in int_mTARGET int_sTARGET int_assets int_N int_relativesize int_logN int_logrelativesize int_schoolscore0 teacherage{
	gen `X'_treatment=`X'*treatment
	gen Covariate=`X'
	eststo : areg ITT_score treatment Covariate `X'_treatment $controls10 if year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
	estadd ysumm
	drop Covariate
	drop `X'_treatment
	}
	
esttab using "$OUTPUT/TableA8A.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "\$R^2\$") fmt(%12.0fc 2)) ///
keep(treatment Covariate inter) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none) ///
rename(int_mTARGET_treatment inter  ///
int_sTARGET_treatment inter  ///
int_assets_treatment inter  ///
int_N_treatment inter  ///
int_relativesize_treatment inter  ///
int_logN_treatment inter  ///
int_logrelativesize_treatment inter  ///
int_schoolscore0_treatment inter ///
teacherage_treatment inter) ///
varl(treatment "Treatment" Covariate "Covariate" inter "Treatment*Covariate") 

esttab using "$OUTPUT/TableA8A.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "R^2") fmt(0 2)) ///
keep(treatment Covariate inter) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none) ///
rename(int_mTARGET_treatment inter  ///
int_sTARGET_treatment inter  ///
int_assets_treatment inter  ///
int_N_treatment inter  ///
int_relativesize_treatment inter  ///
int_logN_treatment inter  ///
int_logrelativesize_treatment inter  ///
int_schoolscore0_treatment inter ///
teacherage_treatment inter) ///
varl(treatment "Treatment" Covariate "Covariate" inter "Treatment*Covariate") 

eststo clear
foreach X in int_mTARGET int_sTARGET int_assets int_N int_relativesize int_logN int_logrelativesize int_schoolscore0 teacherage {
	gen Covariate=`X'
	gen `X'_treatment=`X'*treatment
	eststo : areg ITT_score treatment Covariate `X'_treatment $controls10 if year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)
	estadd ysumm
	drop Covariate
	drop `X'_treatment
	}

esttab using "$OUTPUT/TableA8B.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "\$R^2\$") fmt(%12.0fc 2)) ///
keep(treatment Covariate inter) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none) ///
rename(int_mTARGET_treatment inter  ///
int_sTARGET_treatment inter  ///
int_assets_treatment inter  ///
int_N_treatment inter  ///
int_relativesize_treatment inter  ///
int_logN_treatment inter  ///
int_logrelativesize_treatment inter  ///
int_schoolscore0_treatment inter ///
teacherage_treatment inter) ///
varl(treatment "Treatment" Covariate "Covariate" inter "Treatment*Covariate") 

esttab using "$OUTPUT/TableA8B.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N r2 , labels ("Observations" "R^2") fmt(0 2)) ///
keep(treatment Covariate inter) nonotes cells(b(star fmt(2)) se(par fmt(2))) mlabels(none) collabels(none) ///
rename(int_mTARGET_treatment inter  ///
int_sTARGET_treatment inter  ///
int_assets_treatment inter  ///
int_N_treatment inter  ///
int_relativesize_treatment inter  ///
int_logN_treatment inter  ///
int_logrelativesize_treatment inter  ///
int_schoolscore0_treatment inter ///
teacherage_treatment inter) ///
varl(treatment "Treatment" Covariate "Covariate" inter "Treatment*Covariate") 
		
*Table 6

gen T2T3 = T2*T3
gen T2NT3 = T2*NT3
gen NT2T3 = NT2*T3
gen NT2NT3 = NT2*NT3
gen M2M3 = 1-(1-M2)*(1-M3)

foreach X in T2 NT2 M2 T2T3 T2NT3 NT2T3 NT2NT3 M2M3{
	gen `X'_I=`X'*treatment
	}

eststo clear
eststo : areg ITT_score T2 NT2 M2 T2_I NT2_I M2_I $controls10 if (SD==0|SD==1) & year==2 [pweight=weight], cluster(school_id) absorb(triplet_id)
test (_b[T2_I] = _b[NT2_I])
estadd scalar p_two=r(p)
test (_b[T2_I] = _b[NT2_I] = 0)
estadd scalar p_zero=r(p)

sum M2 if e(sample)==1
estadd scalar NumMissing=r(sum)/e(N)

eststo : areg ITT_score T2T3 NT2T3 T2NT3 NT2NT3 M2M3 T2T3_I NT2T3_I T2NT3_I NT2NT3_I M2M3_I $controls10 if (SD==0|SD==1) & year==3 [pweight=weight], cluster(school_id) absorb(triplet_id)
test (_b[T2T3_I] = _b[NT2T3_I]=_b[T2NT3_I]=_b[NT2NT3_I])
estadd scalar p_two=r(p)
test (_b[T2T3_I] = _b[NT2T3_I]=_b[T2NT3_I]=_b[NT2NT3_I]=0)
estadd scalar p_zero=r(p)

sum  M2M3 if e(sample)==1
estadd scalar NumMissing=r(sum)/e(N)

esttab using "$OUTPUT/Table6.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  substitute(\_ _)  ///
keep(T2_I NT2_I M2_I T2T3_I T2NT3_I NT2T3_I NT2NT3_I M2M3_I) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) ///
varlab(T2_I "Target (Y2) * Treatment" NT2_I "Nontarget (Y2) * Treatment " M2_I "no match (Y2) * Treatment" T2T3_I "Target (Y2) * Target (Y3) * Treatment" T2NT3_I "Target (Y2) * Nontarget (Y3) * Treatment" NT2T3_I "Nontarget (Y2) * Target (Y3) * Treatment" NT2NT3_I "Nontarget (Y2) * Nontarget (Y3) * Treatment" M2M3_I "[no match (Y2) | no match (Y3)] * Treatment") ///
stats(p_two p_zero N, fmt(2 2 %12.0fc) labels ("p-value: test causal parameters are the same" "p-value: test causal parameters are the same and zero" "Observations"))

esttab using "$OUTPUT/Table6.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  substitute(\_ _)  ///
keep(T2_I NT2_I M2_I T2T3_I T2NT3_I NT2T3_I NT2NT3_I M2M3_I) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) ///
varlab(T2_I "Target (Y2) * Treatment" NT2_I "Nontarget (Y2) * Treatment " M2_I "no match (Y2) * Treatment" T2T3_I "Target (Y2) * Target (Y3) * Treatment" T2NT3_I "Target (Y2) * Nontarget (Y3) * Treatment" NT2T3_I "Nontarget (Y2) * Target (Y3) * Treatment" NT2NT3_I "Nontarget (Y2) * Nontarget (Y3) * Treatment" M2M3_I "[no match (Y2) | no match (Y3)] * Treatment") ///
stats(p_two p_zero N, fmt(2 2 0) labels ("p-value: test causal parameters are the same" "p-value: test causal parameters are the same and zero" "Observations"))

*Table 7

*first row of table 7
label var P2 "Full Y_2 sample"
eststo clear
eststo m1: xi: ivreg2 ITT_score treatment $controls10 i.triplet_id if year==2 & P2!=. [pweight=weight], cluster(school_id)
estadd ysumm
eststo m2: xi: ivreg2 ITT_score (P2 = treatment) $controls10 i.triplet_id if year==2 [pweight=weight], cluster(school_id)
estadd ysumm

esttab m1 m2 using "$OUTPUT/Table7_1.tex",  extracols(3 3 3 3) label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N , labels ("Observations") fmt(%12.0fc 2)) ///
keep(P2) rename(treatment P2) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) 

esttab m1 m2 using "$OUTPUT/Table7_1.csv",  extracols(3 3 3 3) label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N , labels ("Observations") fmt(0 2)) ///
keep(P2) rename(treatment P2) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) 

*second row of table 7
label var P2 "Target teacher in current year"
eststo clear
eststo m1: xi: ivreg2 ITT_score treatment $controls10 i.triplet_id if year==2 & P2!=. & T2==1 [pweight=weight], cluster(school_id)
estadd ysumm
eststo m2: xi: ivreg2 ITT_score (P2 = treatment) $controls10 i.triplet_id if year==2 & T2==1 [pweight=weight], cluster(school_id)
estadd ysumm

esttab m1 m2 using "$OUTPUT/Table7_2.tex",  extracols(3 3 3 3) label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N , labels ("Observations") fmt(%12.0fc 2)) ///
keep(P2) rename(treatment P2) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) 

esttab m1 m2 using "$OUTPUT/Table7_2.csv",  extracols(3 3 3 3) label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
stats(N , labels ("Observations") fmt(0 2)) ///
keep(P2) rename(treatment P2) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) 

gen P_IV00 = 0*P2 + P3		
gen P_IV05 = 0.5*P2+P3
gen P_IV10 = P2+P3

*third, fourth, fifth, sixth row of table 7
label var treatment "Full Y_3 sample"
	foreach X in "&1 3" "&T3==1 4" "&(T2==1|T3==1) 5" "&(T2==1&T3==1) 6"{
	tokenize `X'
		eststo clear
		eststo m1: xi: ivreg2 ITT_score treatment $controls10 i.triplet_id if year==3 & P_IV00!=. `1' [pweight=weight], cluster(school_id)
		estadd ysumm
		eststo m2: xi: ivreg2 ITT_score (P_IV00 = treatment) $controls10 i.triplet_id if year==3 `1' [pweight=weight], cluster(school_id)
		estadd ysumm
		eststo m3: xi: ivreg2 ITT_score (P_IV05 = treatment) $controls10 i.triplet_id if year==3 `1' [pweight=weight], cluster(school_id)
		estadd ysumm
		eststo m4: xi: ivreg2 ITT_score (P_IV10 = treatment) $controls10 i.triplet_id if year==3 `1' [pweight=weight], cluster(school_id)
		estadd ysumm

		esttab m1 m2 m3 m4 using "$OUTPUT/Table7_`2'.tex", extracols(1 1) label replace fragment nolines gaps ///
		booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
		stats(N , labels ("Observations") fmt(%12.0fc 2)) ///
		keep(treatment P_IV00 P_IV05 P_IV10) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) 

		esttab m1 m2 m3 m4 using "$OUTPUT/Table7_`2'.csv", extracols(1 1) label replace fragment nolines gaps ///
		nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)   ///
		stats(N , labels ("Observations") fmt(0 2)) ///
		keep(treatment P_IV00 P_IV05 P_IV10) nonotes cells(b(star fmt(3)) se(par fmt(3))) mlabels(none) collabels(none) 
		}


*Table A.7 A-C

egen median_assets=median(assets), by(year)
gen topassets = (assets>median_assets) if assets!=.

label var TARGET "Fraction of students with a target teacher"

foreach Y in "&topassets!=. A" "&topassets==1 B" "&topassets==0 C"{
tokenize `Y' 
	eststo clear
	foreach X in 2 3{
		eststo : xi: TABLE_TE1 TARGET if year==`X'`1' , by(treatment) clus_id(school_id) strat_id(triplet_id) 
		}

	esttab using "$OUTPUT/TableA7`2'.tex", label replace fragment nolines gaps ///
	booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
	cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

	esttab using "$OUTPUT/TableA7`2'.csv", label replace fragment nolines gaps ///
	nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
	cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 
	}

*Table A.7 D-E

use "$IN2\students_EXTRA.dta", clear

label var TARGET "Fraction of students with a target teacher"

foreach Y in "&llow==1 D" "&lhigh==1 E"{
tokenize `Y' 
	eststo clear
	foreach X in 2 3{
		eststo : xi: TABLE_TE1 TARGET if year==`X'`1' , by(treatment) clus_id(school_id) strat_id(triplet_id) 
		}

	esttab using "$OUTPUT/TableA7`2'.tex", label replace fragment nolines gaps ///
	booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
	cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

	esttab using "$OUTPUT/TableA7`2'.csv", label replace fragment nolines gaps ///
	nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
	cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 
	}

*Table A.4

label var EstimationSample "Fraction staying in the sample"
foreach X in "&1 A" "&high==1 B" "&low==1 C"{
tokenize `X'
	eststo clear
	foreach Y in 2 3{
		eststo : xi: TABLE_TE1 EstimationSample if tested_bl==1&year==`Y'`1' , by(treatment) clus_id(school_id) strat_id(triplet_id) 
		}
	
	esttab using "$OUTPUT/TableA4`2'.tex", label replace fragment nolines gaps ///
	booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control"  "Difference (F.E)")  ///
	cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 
	
	esttab using "$OUTPUT/TableA4`2'.csv", label replace fragment nolines gaps ///
	nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control"  "Difference (F.E)")  ///
	cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 
	}

*Table A.5

label var assets "Average student asset index of new cohorts"
eststo clear
foreach Y in 2 3{
	eststo : xi: TABLE_TE1 assets if EstimationSample==1&tested_bl!=1&year==`Y', by(treatment) clus_id(school_id) strat_id(triplet_id)
	}

esttab using "$OUTPUT/TableA5.tex", label replace fragment nolines gaps ///
booktabs nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 

esttab using "$OUTPUT/TableA5.csv", label replace fragment nolines gaps ///
nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01)  collabels("Treatment" "Control" "Difference (F.E)")  ///
cells("mu_1(fmt(2)) mu_2(fmt(2)) mu_4(fmt(2) star pvalue(d_p2))" "se_1(par([ ])) se_2(par([ ])) se_4(par)") 
