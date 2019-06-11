use "$basein/TwaTestData2013.dta", clear



foreach name in "k" "e" "m"{
	forval i=1/3  {
		gen PR_`i'_`name'=Passed_`i'`name'/NrTests_`i'
		if "`name'"=="k" label var PR_`i'_`name' "K S`i'"
		if "`name'"=="e" label var PR_`i'_`name' "E S`i'"
		if "`name'"=="m" label var PR_`i'_`name' "M S`i'"
	}
}

keep SchoolID  PR_1_k- PR_3_m
reshape long PR_@_k PR_@_e PR_@_m, i(SchoolID) j(Grade)
rename PR__k Kis_Pass_T4
rename PR__e Eng_Pass_T4
rename PR__m Math_Pass_T4

tempfile temp1
save `temp1'


use "$basein/TwaTestData2014", clear
collapse  (mean) Kis_Pass Eng_Pass Math_Pass, by( SchoolID Grade )
rename Kis_Pass Kis_Pass_T8
rename Eng_Pass Eng_Pass_T8
rename Math_Pass Math_Pass_T8

merge 1:1 SchoolID Grade  using `temp1'
drop  if _merge!=3
drop _merge

merge m:1  SchoolID using "$basein/R_EL_schools_noPII.dta", keepus( SchoolID treatment treatarm DistID)
drop if _merge!=3
drop _merge

gen TreatmentCG=0 
replace TreatmentCG=1 if treatment=="CG" 
label var TreatmentCG "Grants"
gen TreatmentCOD=0 
replace TreatmentCOD=1 if treatment=="COD" 
label var TreatmentCOD "Incentives"
gen TreatmentBoth=0 
replace TreatmentBoth=1 if treatment=="Both" 
label var TreatmentBoth "Combination"
label var TreatmentCOD "Incentives (\$\beta_2\$)"
label var TreatmentBoth "Combination (\$\beta_3\$)"
reg Eng_Pass_T8 ${treatmentlist}  i.DistID i.Grade, vce(cluster SchoolID) 
gen empty_T4=0
gen empty_T8=0
replace empty_T4=. if  e(sample)==0
replace empty_T8=. if  e(sample)==0
replace empty_T4=. if TreatmentCG==1 | TreatmentCOD==1 | TreatmentBoth==1
replace empty_T8=. if TreatmentCG==1 | TreatmentCOD==1 | TreatmentBoth==1
eststo clear
foreach time in T4 T8{
	foreach var in Math_Pass Kis_Pass Eng_Pass empty {
		replace `var'_`time'=100*`var'_`time'
		eststo est_`var'_`time':   reg `var'_`time' ${treatmentlist}  i.DistID i.Grade, vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
		sum `var'_`time' if TreatmentCG==0 & TreatmentCOD==0 & TreatmentBoth==0 & e(sample)==1
		estadd scalar ymean2=r(mean)
		sum `var'_`time' if treatment=="Control" | treatment=="COD" 
		estadd scalar N2=r(N)
		if("`var'"=="empty") estadd scalar ymean2=., replace
		if("`var'"=="empty") estadd scalar N2=., replace
		if("`var'"=="empty") estadd scalar suma=., replace
	}  
}
 

label var TreatmentCOD "Incentives (\$\gamma_2\$)"
label var TreatmentCG "Grants"
label var TreatmentBoth "Combination (\$\gamma_3\$)"
esttab  using "$latexcodesfinals/RegPassTest_HighStakes.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber /// 
star(* 0.10 ** 0.05 *** 0.01) noomitted  ///
replace  nomtitles  nolines  ///
keep(TreatmentCOD TreatmentBoth) stats(N2 ymean2 suma p, fmt(%9.0fc %9.2fc %9.2gc %9.2gc) labels("N. of obs." "Control mean" " \$\gamma_3-\gamma_2\$" "p-value (\$\gamma_3-\gamma_2=0\$)" "") star(suma)) ///
nonotes substitute(\_ _)
