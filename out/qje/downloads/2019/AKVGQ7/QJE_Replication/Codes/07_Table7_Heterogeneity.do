eststo clear
**********************
**************Student
***********************
use "$basein/Student_School_House_Teacher_Char.dta", clear
/*Drop a few cases with problematic IDs*/
drop if upid==""
drop if upid=="R1STU09272102" & SchoolID!=927
drop if upid=="R1STU10072102" & SchoolID!=1007
drop if upid=="R1STU10072110" & SchoolID!=1007
bys upid: gen  N=_N
drop if Z_ScoreFocal_T3==. & N>1



tabulate LagGrade, gen(GRD)
tabulate Lagmale, gen(sex)



foreach var in ScoreFocal{

	foreach cov in Lagmale LagAge LagZ_`var' {
		preserve
		keep  Z_`var'_* $treatmentlist  HHSize MissingHHSize IndexPoverty MissingIndexPoverty IndexEngagement MissingIndexEngagement LagExpenditure MissingLagExpenditure LagseenUwezoTests LagpreSchoolYN Lagmale LagAge LagGrade LagZ_kiswahili LagZ_hisabati LagZ_kiingereza  $schoolcontrol `cov'  DistID WeekIntvTest_T* LagGrade upid SchoolID
		drop if upid==""
		capture drop Z_`var'_T1
		capture drop Z_`var'_T5
		capture drop Z_`var'_T4
		capture drop Z_`var'_T8
		capture drop Z_`var'_T*_*
		reshape long Z_`var'_T@ WeekIntvTest_T@, i(upid) j(T) string
		gen Covar=`cov'
		sum `cov'
		replace `cov'=`cov'-r(mean) if !missing(`cov')
		capture gen TCG`cov'=TreatmentCG*`cov' 
		capture gen TCOD`cov'=TreatmentCOD*`cov'  
		capture gen TBoth`cov'=TreatmentBoth*`cov' 
		eststo:  reg Z_`var'_T  $treatmentlist  TCG`cov'  TCOD`cov' TBoth`cov' Covar $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade  ,vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar pval1=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TBoth`cov'] - _b[TCOD`cov']-_b[TCG`cov']=0)
		estadd scalar pval2=r(p)
		estadd scalar suma2=_b[TBoth`cov'] - _b[TCOD`cov']-_b[TCG`cov']	  
		restore
	}

}




**********************
**************TEACHER
************************

use "$basein/Student_School_House_Teacher_Char.dta", clear
/*Drop a few cases with problematic IDs*/
drop if upid==""
drop if upid=="R1STU09272102" & SchoolID!=927
drop if upid=="R1STU10072102" & SchoolID!=1007
drop if upid=="R1STU10072110" & SchoolID!=1007
bys upid: gen  N=_N
drop if Z_ScoreFocal_T3==. & N>1

foreach var in ScoreFocal{
	foreach cov in maleAverage t23Average t66 {
		preserve
		keep  Z_ScoreFocal_* $treatmentlist  HHSize MissingHHSize IndexPoverty MissingIndexPoverty IndexEngagement MissingIndexEngagement LagExpenditure MissingLagExpenditure LagseenUwezoTests LagpreSchoolYN Lagmale LagAge LagGrade LagZ_kiswahili LagZ_hisabati LagZ_kiingereza  $schoolcontrol `cov'  DistID WeekIntvTest_T* LagGrade upid SchoolID
		drop if upid==""
		capture drop Z_ScoreFocal_T1
		capture drop Z_ScoreFocal_T5
		capture drop Z_ScoreFocal_T4
		capture drop Z_ScoreFocal_T8
		capture drop Z_ScoreFocal_T*_*
		reshape long Z_ScoreFocal_T@ WeekIntvTest_T@, i(upid) j(T) string
		gen Covar=`cov'
		sum Covar,d
		if("`cov'"!="TeacherIndexRecall") replace Covar=Covar-r(mean) if !missing(Covar)
		if("`cov'"=="TeacherIndexRecall") replace Covar=(Covar>r(p50)) if !missing(Covar)
		capture drop TCGCOV
		capture drop TCODCOV
		capture drop TBothCOV
		
		capture gen TCGCOV=TreatmentCG*Covar
		label var TCGCOV "CG * Cov"
		capture gen TCODCOV=TreatmentCOD*Covar 
		label var TCGCOV "COD * Cov"
		capture gen TBothCOV=TreatmentBoth*Covar
		label var TCGCOV "Both * Cov"
		eststo:  reg Z_`var'_T  $treatmentlist  TCGCOV  TCODCOV TBothCOV Covar $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade  ,vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar pval1=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TBothCOV] - _b[TCODCOV]-_b[TCGCOV]=0)
		estadd scalar pval2=r(p)
		estadd scalar suma2=_b[TBothCOV] - _b[TCODCOV]-_b[TCGCOV]	  
		restore
	}

}


**********************
**************SCHOOL
************************


use "$basein/Student_School_House_Teacher_Char.dta", clear
/*Drop a few cases with problematic IDs*/
drop if upid==""
drop if upid=="R1STU09272102" & SchoolID!=927
drop if upid=="R1STU10072102" & SchoolID!=1007
drop if upid=="R1STU10072110" & SchoolID!=1007
bys upid: gen  N=_N
drop if Z_ScoreFocal_T3==. & N>1

foreach var in ScoreFocal{

	foreach cov in IndexFacilities_T1 StudentsTotal_T1 IndexManagerial_T1 {
		preserve
		keep  Z_`var'_* $treatmentlist  HHSize MissingHHSize IndexPoverty MissingIndexPoverty IndexEngagement MissingIndexEngagement LagExpenditure MissingLagExpenditure LagseenUwezoTests LagpreSchoolYN Lagmale LagAge LagGrade LagZ_kiswahili LagZ_hisabati LagZ_kiingereza  $schoolcontrol `cov'  DistID WeekIntvTest_T* LagGrade upid SchoolID
		drop if upid==""
		capture drop Z_`var'_T1
		capture drop Z_`var'_T5
		capture drop Z_`var'_T4
		capture drop Z_`var'_T8
		capture drop Z_`var'_T*_*
		reshape long Z_`var'_T@ WeekIntvTest_T@, i(upid) j(T) string
		gen Covar=`cov'
		sum Covar,d
		if("`cov'"=="PTR_T1") replace Covar=Covar-r(mean) if !missing(Covar)
		if("`cov'"!="PTR_T1") replace Covar=(Covar>r(p50)) if !missing(Covar)
		capture drop TCGCOV
		capture drop TCODCOV
		capture drop TBothCOV
		
		capture gen TCGCOV=TreatmentCG*Covar
		label var TCGCOV "CG * Cov"
		capture gen TCODCOV=TreatmentCOD*Covar 
		label var TCGCOV "COD * Cov"
		capture gen TBothCOV=TreatmentBoth*Covar
		label var TCGCOV "Both * Cov"
		eststo:  reg Z_`var'_T  $treatmentlist  TCGCOV  TCODCOV TBothCOV Covar $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade  ,vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar pval1=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TBothCOV] - _b[TCODCOV]-_b[TCGCOV]=0)
		estadd scalar pval2=r(p)
		estadd scalar suma2=_b[TBothCOV] - _b[TCODCOV]-_b[TCGCOV]	  
		restore
	}

}


esttab using "$latexcodesfinals/Heter_focal.tex", se ar2 booktabs nolines label fragment ///
replace  b(%9.2fc)se(%9.2fc)nocon nonum  ///
keep(Grants*Covariate Incentives*Covariate Combination*Covariate ) ///
star(* 0.10 ** 0.05 *** 0.01)  stats(N , fmt(%9.0fc) labels ("N. of obs.")) ///
varlabels(Covar Covariate  ) ///
rename( ///
 TCGLagmale Grants*Covariate TCODLagmale Incentives*Covariate TBothLagmale Combination*Covariate  ///
 TCGLagAge Grants*Covariate TCODLagAge Incentives*Covariate TBothLagAge Combination*Covariate ///
 TCGLagZ_hisabati Grants*Covariate TCODLagZ_hisabati Incentives*Covariate TBothLagZ_hisabati Combination*Covariate ///
 TCGLagZ_kiswahili Grants*Covariate TCODLagZ_kiswahili Incentives*Covariate TBothLagZ_kiswahili Combination*Covariate ///
 TCGLagZ_kiingereza Grants*Covariate TCODLagZ_kiingereza Incentives*Covariate TBothLagZ_kiingereza Combination*Covariate ///
 TCGLagZ_ScoreFocal Grants*Covariate TCODLagZ_ScoreFocal Incentives*Covariate TBothLagZ_ScoreFocal Combination*Covariate ///
 TCGCOV Grants*Covariate TCODCOV Incentives*Covariate TBothCOV Combination*Covariate) /// 
 mgroups("Student" "Teacher" "School", pattern(1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))  ///
mtitles("Male" "Age" "Lagged score" "Male" "Salary" "Motivation" "Facilities" "Enrollment" "Management") title("Heterogeneity by student characteristics for `name'") ///
nonotes addnotes("\specialcell{Clustered standard errors, by school, in parenthesis\\  \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\) }" "\tiny The independent variable is the standardized test score. Each regression has a different covariate interacted with the treatment dummies. The column title indicates the covariate interacted. Baseline score is the standardized test score at the beginning of the first year; Grade $k$ is equal to one, if the student is in grade $k$; Male is a equal to one if the student is male; Age is the age in years of the student. ")
