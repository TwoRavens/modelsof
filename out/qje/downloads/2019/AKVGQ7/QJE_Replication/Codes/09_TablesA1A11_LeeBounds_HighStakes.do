**First, figure out number of test takers

use "$basein/R4Grade_noPII.dta", clear
egen Denom_Survey=rowtotal( s184 s185), missing
rename R4GradeID GradeID_T8
keep GradeID_T8 SchoolID Denom_Survey
tempfile temp_enroll2
save `temp_enroll2', replace

*Second, lets figure out how much to cut
use "$basein/Student_School_House_Teacher_Char.dta", clear

collapse (count)  TestTakes=Z_hisabati_T8, by(GradeID_T8 SchoolID)
merge m:1 SchoolID using "$basein/R_EL_schools_noPII.dta", keepus(  treatment treatarm DistID)
drop if _merge!=3
drop _merge
gen TreatmentCG=0 
replace TreatmentCG=1 if treatment=="CG" 
label var TreatmentCG "Inputs"
gen TreatmentCOD=0 
replace TreatmentCOD=1 if treatment=="COD"
label var TreatmentCOD "Incentives"
gen TreatmentBoth=0 
replace TreatmentBoth=1 if treatment=="Both" 
label var TreatmentBoth "Combination"

drop if TestTakes==0
merge 1:1 GradeID_T8 SchoolID using `temp_enroll2'
drop if _merge!=3
drop _merge
gen TestTakes_prop2=TestTakes/Denom_Survey
replace TestTakes_prop2=1 if TestTakes_prop2>1 & TestTakes_prop2!=.


eststo clear
eststo test_takers: reg TestTakes_prop2 TreatmentCOD TreatmentBoth i.GradeID_T8 i.DistID
estadd ysumm
sum TestTakes_prop2 if TreatmentCOD==0 & TreatmentBoth==0
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
		

matrix M=e(b)
local cutCOD=M[1,1]
local cutBoth=M[1,2]
label var TreatmentCOD "Incentives (\$\beta_2\$)"
label var TreatmentCG "Inputs (\$\beta_1\$)"
label var TreatmentBoth "Combination (\$\beta_3\$)"

********** TABLE A3 ***********
esttab  using "$latexcodesfinals/RegTestScores_highstakes_TestTakers_prop.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber nolines /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles ///
keep(TreatmentCOD TreatmentBoth) stats(N ymean2 suma p, fmt(%9.0fc %9.2fc a2 a2) labels("N. of obs." "Mean control group" "\$\beta_3 = \beta_2-\beta_1\$" "p-value(\$\beta_3=0\$)" "") star(suma)) ///
nonotes substitute(\_ _)


use "$basein/Student_School_House_Teacher_Char.dta", clear
drop if Z_hisabati_T8==.
pca Z_kiswahili_T8  Z_kiingere~T8 Z_hisabati_T8
predict Z_ScoreFocal_T8,score

forvalues val=1/4{
	foreach var of varlist  Z_ScoreFocal_T8{
		qui sum `var' if GradeID_T7==`val' & treatarm==4
		qui replace `var'=(`var'-r(mean))/r(sd) if GradeID_T7==`val'
	}
}



eststo clear
foreach var in $AggregateDep_Karthik{
	eststo m_`var': reg `var'_T8 ${treatmentlist_int} i.GradeID_T8  i.DistID  $schoolcontrol , vce(cluster SchoolID) 
	estadd ysumm
	test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
	preserve
		gsort SchoolID GradeID_T8 -`var'_T8
		by SchoolID GradeID_T8: gen conteo=_n
		drop if conteo<=`cutCOD' & treatment=="COD"
		drop if conteo<=`cutBoth' & treatment=="Both"
		reg `var'_T8 ${treatmentlist_int} i.GradeID_T8  i.DistID  $schoolcontrol , vce(cluster SchoolID)
		lincom _b[TreatmentCOD]
		scalar CI_COD_1=r(estimate)+1.96*r(se)
		scalar CI_COD_2=r(estimate)-1.96*r(se)
		lincom _b[TreatmentBoth]
		scalar CI_Both_1=r(estimate)+1.96*r(se)
		scalar CI_Both_2=r(estimate)-1.96*r(se)
		lincom (_b[TreatmentBoth]-_b[TreatmentCOD] )
		scalar CI_Interact_1=r(estimate)+1.96*r(se)
		scalar CI_Interact_2=r(estimate)-1.96*r(se)
		
	restore
	preserve
		gsort SchoolID GradeID_T8 `var'_T8
		by SchoolID GradeID_T8: gen conteo=_n
		drop if conteo<=`cutCOD' & treatment=="COD"
		drop if conteo<=`cutBoth' & treatment=="Both"
		reg `var'_T8 ${treatmentlist_int} i.GradeID_T8  i.DistID  $schoolcontrol , vce(cluster SchoolID)
		lincom _b[TreatmentCOD]
		scalar CI_COD_3=r(estimate)+1.96*r(se)
		scalar CI_COD_4=r(estimate)-1.96*r(se)
		lincom _b[TreatmentBoth]
		scalar CI_Both_3=r(estimate)+1.96*r(se)
		scalar CI_Both_4=r(estimate)-1.96*r(se)
		lincom (_b[TreatmentBoth]-_b[TreatmentCOD] )
		scalar CI_Interact_3=r(estimate)+1.96*r(se)
		scalar CI_Interact_4=r(estimate)-1.96*r(se)
	restore
	estadd scalar Lee_COD_1=min(`=scalar(CI_COD_1)',`=scalar(CI_COD_2)',`=scalar(CI_COD_3)',`=scalar(CI_COD_4)'): m_`var'
	estadd scalar Lee_COD_2=max(`=scalar(CI_COD_1)',`=scalar(CI_COD_2)',`=scalar(CI_COD_3)',`=scalar(CI_COD_4)'): m_`var'
	estadd scalar Lee_Both_1=min(`=scalar(CI_Both_1)',`=scalar(CI_Both_2)',`=scalar(CI_Both_3)',`=scalar(CI_Both_4)'): m_`var'
	estadd scalar Lee_Both_2=max(`=scalar(CI_Both_1)',`=scalar(CI_Both_2)',`=scalar(CI_Both_3)',`=scalar(CI_Both_4)'): m_`var'
	estadd scalar Lee_Interact_1=min(`=scalar(CI_Interact_1)',`=scalar(CI_Interact_2)',`=scalar(CI_Interact_3)',`=scalar(CI_Interact_4)'): m_`var'
	estadd scalar Lee_Interact_2=max(`=scalar(CI_Interact_1)',`=scalar(CI_Interact_2)',`=scalar(CI_Interact_3)',`=scalar(CI_Interact_4)'): m_`var'
}
label var TreatmentCOD "Incentives (\$\beta_2\$)"
label var TreatmentCG "Inputs (\$\beta_1\$)"
label var TreatmentBoth "Combo (\$\beta_3\$)"

esttab  using "$latexcodesfinals/RegTestScores_highstakes_Lee.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber nolines /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles ///
keep(TreatmentCOD TreatmentBoth) stats(N suma p, fmt(%9.0fc a2 a2) labels("N. of obs." "\$\beta_5 = \beta_3-\beta_2\$" "p-value (\$H_0:\beta_5=0\$)" "") star(suma)) ///
nonotes substitute(\_ _)

esttab  using "$latexcodesfinals/RegTestScores_highstakes_Lee_two.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber nolines nogaps /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles ///
drop(*) stats(Lee_COD_1 Lee_COD_2, fmt(a2 a2) labels("Lower 95\% CI (\$\beta_2\$)" "Higher 95\% CI (\$\beta_2\$)" )) ///
nonotes substitute(\_ _)

esttab  using "$latexcodesfinals/RegTestScores_highstakes_Lee_three.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber nolines nogaps /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles ///
drop(*) stats(Lee_Both_1 Lee_Both_2, fmt(a2 a2) labels("Lower 95\% CI (\$\beta_3\$)" "Higher 95\% CI (\$\beta_3\$)" )) ///
nonotes substitute(\_ _)

esttab  using "$latexcodesfinals/RegTestScores_highstakes_Lee_four.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber nolines nogaps /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles ///
drop(*) stats(Lee_Interact_1 Lee_Interact_2, fmt(a2 a2) labels("Lower 95\% CI (\$\beta_5\$)" "Higher 95\% CI (\$\beta_5\$)" )) ///
nonotes substitute(\_ _)

