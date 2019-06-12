**************************************************************
************************ TABLE 2 - SUMMARY TWAWEZA EXPENDITURE
**************************************************************


capt prog drop my_ptest
program my_ptest, eclass
syntax varlist [if] [in], by(varname) clus_id(varname numeric) [ * ] 

marksample touse
markout `touse' `by'
tempname mu_1 mu_2 mu_3 se_1 se_2 se_3 d_p
capture drop TD*
tab `by', gen(TD)
foreach var of local varlist {
	 reg `var' TD1 TD2 , nocons vce(cluster `clus_id')
	 test (_b[TD1]- _b[TD2]== 0)
	 mat `d_p'  = nullmat(`d_p'),r(p)
	 lincom (TD1-TD2)
	 mat `se_3' = nullmat(`se_3'), r(se)
	 qui estpost tabstat `var' , by(`by') statistics(mean sem)
	 matrix A=e(mean)
	 matrix B=e(semean)
	 mat `mu_1' = nullmat(`mu_1'), A[1,1]
	 mat `mu_2' = nullmat(`mu_2'), A[1,2]
	 mat `mu_3' = nullmat(`mu_3'), A[1,1]-A[1,2]
	 mat `se_1' = nullmat(`se_1'), B[1,1]
	 mat `se_2' = nullmat(`se_2'), B[1,2]

}
foreach mat in mu_1 mu_2 mu_3  se_1 se_2 se_3 d_p {
	mat coln ``mat'' = `varlist'
}
eret local cmd "my_ptest"
foreach mat in mu_1 mu_2 mu_3  se_1 se_2 se_3  d_p {
	eret mat `mat' = ``mat''
}
end


capt prog drop my_ptest_diff
program my_ptest_diff, eclass
syntax varlist [if] [in], by(varname) clus_id(varname numeric) strataid(varname numeric) [ * ] /// clus_id(clus_var)  

marksample touse
markout `touse' `by'
tempname  mu_3 se_3 d_p
capture drop TD*
tab `by', gen(TD)
foreach var of local varlist {
	 reghdfe `var' TD1 TD2 ,  vce(cluster `clus_id') absorb(`strataid')
	 test (_b[TD1]- _b[TD2]== 0)
	 mat `d_p'  = nullmat(`d_p'),r(p)
	 lincom (TD1-TD2)
	 mat `mu_3' = nullmat(`mu_3'), r(estimate)
	 mat `se_3' = nullmat(`se_3'), r(se)	

}
foreach mat in mu_3   se_3 d_p {
	mat coln ``mat'' = `varlist'
}
eret local cmd "my_ptest_diff"
foreach mat in mu_3  se_3  d_p {
	eret mat `mat' = ``mat''
}
end


use "$basein/R_EL_schools_noPII.dta", clear
keep SchoolID treatment treatarm
merge m:1 SchoolID using "$basein/School.dta"


gen TreatmentCG=0 
replace TreatmentCG=1 if treatment=="CG"
label var TreatmentCG "Grants"
gen TreatmentCOD=0 
replace TreatmentCOD=1 if treatment=="COD"
label var TreatmentCOD "Incentives"
gen TreatmentBoth=0 
replace TreatmentBoth=1 if treatment=="Both"
label var TreatmentBoth "Combination"

foreach i in 3 7{
	egen ExpendText_T`i'=rowtotal(gdrctb1_T`i'-gdrctb7_T`i')
	replace ExpendText_T`i'=ExpendText_T`i'/TotalNumberStudents_T`i'
}

forvalue grade=1/7{
	label variable gdrctb`grade'PS_T3 "\\$ Textbooks/Student Grd `grade'"
	label variable gdrctb`grade'PS_T7 "\\$ Textbooks/Student Grd `grade'"
}


foreach i in 3 7{
	label variable ExpendText_T`i' "\\$ Textbooks/Student"  
	label variable administrative_expensesPS_T`i' "\\$ Admin./Student"
	label variable teaching_aid_expensesPS_T`i' "\\$ Teaching Aid/Student"
	label variable student_expensesPS_T`i' "\\$ Student/Student"
	label variable Teacher_expensesPS_T`i' "\\$ Teacher/Student"
	label variable Construction_expensesPS_T`i' "\\$ Construction/Student" 
	label variable textbook_expensesPS_T`i' "\\$ Textbooks/Student"
	
	label variable administrative_twawezaPS_T`i' "\\$ Admin./Student"
	label variable teaching_aid_twawezaPS_T`i' "\\$ Teaching Aid/Student"
	label variable student_twawezaPS_T`i' "\\$ Student/Student"
	label variable Teacher_twawezaPS_T`i' "\\$ Teacher/Student"
	label variable Construction_twawezaPS_T`i' "\\$ Construction/Student" 
	label variable textbook_twawezaPS_T`i' "\\$ Textbooks/Student"
	
	label variable studentsTeacherRatio_T`i' "Teacher Ratio"
	label variable studentsVolunteerRatio_T`i' "Vol. Ratio"
	label variable strategicly_change_teachers_T`i' "HT changed teachers"
	label variable strategicly_change_teachers_T`i' "HT changed students"
	label variable administrative_expenses_T`i' "\\$ Admin."
	label variable student_expenses_T`i' "\\$ Student"  
	label variable Teacher_expenses_T`i' "\\$ Teacher"
}

label var TimesCommitteeMet2013_T3 "No. Committee meetings"
label var debtyn_T3 "Debts"
label var ifnbyn_Since_T1 "Notice Board"
label var ifscyn_Since_T1 "Committee Meetings"
label var ifpmyn_Since_T1 "Parents Meetings"
label var ifotyn_Since_T1 "Others"


local treatmentlist TreatmentCG TreatmentCOD TreatmentBoth
local schoolcontrol s1451_T1 s1452_T1 s1453_T1 s1454_T1 s1455_T1 s1456_T1 s1431_T1 s1432_T1 s1433_T1 s1434_T1 s1435_T1 computersYN_T1 s120_T1 s118_T1 PipedWater_T1 NoWater_T1 SingleShift_T1 ToiletsStudents_T1 ClassRoomsStudents_T1 TeacherStudents_T1 s188_T1 s175_T1 s200_T1 s108_T1 SizeSchoolCommittee_T1 KeepRecords_T1 noticeboard_T1 PropCommitteeFemale_T1 PropCommitteeTeachers_T1 PropCommitteeParents_T1  StudentsTotal_T1


foreach var in administrative_twaweza student_twaweza teaching_aid_twaweza Teacher_twaweza Construction_twaweza Savings_twaweza{
	capture replace `var'_T3=. if treatarm>=3
	capture replace `var'_T7=. if treatarm>=3
	capture replace `var'PS_T3=. if treatarm>=3
	capture replace `var'PS_T7=. if treatarm>=3
}

egen TotalExpenditure_T3=rowtotal(administrative_expensesPS_T3 student_expensesPS_T3 teaching_aid_expensesPS_T3 Teacher_expensesPS_T3 Construction_expensesPS_T3 textbook_expensesPS_T3), missing
egen TotalExpenditure_T7=rowtotal(administrative_expensesPS_T7 student_expensesPS_T7 teaching_aid_expensesPS_T7 Teacher_expensesPS_T7 Construction_expensesPS_T7 textbook_expensesPS_T7), missing

label var TotalExpenditure_T3 Total
label var TotalExpenditure_T7 Total

egen TotalExpenditureTwa_T3=rowtotal(administrative_twawezaPS_T3 student_twawezaPS_T3 teaching_aid_twawezaPS_T3 Teacher_twawezaPS_T3 Construction_twawezaPS_T3 textbook_twawezaPS_T3), missing
egen TotalExpenditureTwa_T7=rowtotal(administrative_twawezaPS_T7 student_twawezaPS_T7 teaching_aid_twawezaPS_T7 Teacher_twawezaPS_T7 Construction_twawezaPS_T7 textbook_twawezaPS_T7), missing

label var TotalExpenditureTwa_T3 Total
label var TotalExpenditureTwa_T7 Total



gen Unaccounted_twawezaPS_T3=10000-TotalExpenditureTwa_T3
gen Unaccounted_twawezaPS_T7=10000-TotalExpenditureTwa_T7
foreach var in TotalExpenditureTwa administrative_twawezaPS student_twawezaPS teaching_aid_twawezaPS Teacher_twawezaPS Construction_twawezaPS textbook_twawezaPS Unaccounted_twawezaPS{
	gen `var'_TT=(`var'_T3+`var'_T7)/2
	_crcslbl `var'_TT `var'_T7 
}
label var Unaccounted_twawezaPS_T3 "Unspent/unaccounted funds"
label var Unaccounted_twawezaPS_T7 "Unspent/unaccounted funds"

keep textbook_twawezaPS_* TotalExpenditureTwa_* administrative_twawezaPS_* student_twawezaPS_* teaching_aid_twawezaPS_* Teacher_twawezaPS_* Construction_twawezaPS_* Unaccounted_twawezaPS_* treatarm SchoolID DistrictID

reshape long TotalExpenditureTwa_T@ administrative_twawezaPS_T@ textbook_twawezaPS_T@ student_twawezaPS_T@ teaching_aid_twawezaPS_T@ Teacher_twawezaPS_T@ Construction_twawezaPS_T@ Unaccounted_twawezaPS_T@ , i(SchoolID) j(time) string

label variable TotalExpenditureTwa_T "TZS Total/Student"  
label variable administrative_twawezaPS_T "TZS Admin./Student"
label variable teaching_aid_twawezaPS_T "TZS Teaching Aid/Student"
label variable student_twawezaPS_T "TZS Student/Student"
label variable Teacher_twawezaPS_T "TZS Teacher/Student"
label variable Construction_twawezaPS_T "TZS Construction/Student" 
label variable textbook_twawezaPS_T "TZS Textbooks/Student" 
label var Unaccounted_twawezaPS_T "TZS Unspent funds"

label variable TotalExpenditureTwa_T "Total"  
label variable administrative_twawezaPS_T "Admin."
label variable teaching_aid_twawezaPS_T "Teaching aids"
label variable student_twawezaPS_T "Students"
label variable Teacher_twawezaPS_T "Teachers"
label variable Construction_twawezaPS_T "Construction" 
label variable textbook_twawezaPS_T "Textbooks"
label var Unaccounted_twawezaPS_T "Unspent funds"



replace time = "9" if time=="T"
destring time, replace
label define year 3 "Year 1" 7 "Year 2" 9 "Average"
label values time year
 
gen tot=TotalExpenditureTwa_T +Unaccounted_twawezaPS_T

label var TotalExpenditureTwa_T "Total Expenditure"
label var tot "Total Value of CG"
eststo clear
estpost  tabstat  administrative_twawezaPS_T student_twawezaPS_T textbook_twawezaPS_T teaching_aid_twawezaPS_T Teacher_twawezaPS_T Construction_twawezaPS_T  ///
		  TotalExpenditureTwa_T Unaccounted_twawezaPS_T tot if treatarm==2, by(time) statistics(mean semean) columns(statistics) listwise nototal


esttab using "$latexcodesfinals/SummaryTwawezaExp_CG.tex", main(mean %9.2fc) aux(semean %9.2fc)  nostar unstack noobs nonote nonumber fragment   replace  label nomtitles nodepvars  


eststo clear
estpost  tabstat  administrative_twawezaPS_T student_twawezaPS_T textbook_twawezaPS_T teaching_aid_twawezaPS_T Teacher_twawezaPS_T Construction_twawezaPS_T  ///
		  TotalExpenditureTwa_T Unaccounted_twawezaPS_T tot if treatarm==1, by(time) statistics(mean semean) columns(statistics) listwise nototal


esttab using "$latexcodesfinals/SummaryTwawezaExp_Combo.tex", main(mean %9.2fc) aux(semean %9.2fc)  nostar unstack noobs nonote nonumber fragment collabels(none) replace  label nomtitles nodepvars  


my_ptest_diff administrative_twawezaPS_T student_twawezaPS_T textbook_twawezaPS_T teaching_aid_twawezaPS_T Teacher_twawezaPS_T Construction_twawezaPS_T  ///
		  TotalExpenditureTwa_T Unaccounted_twawezaPS_T tot if treatarm==1  | treatarm==2, by(treatarm) clus_id(SchoolID) strataid(DistrictID) statistics(mean semean) columns(statistics) listwise nototal
esttab using "$latexcodesfinals/SummaryTwawezaExp_Diff.tex", label replace  fragment nomtitle nonumbers noobs nodep star(* 0.10 ** 0.05 *** 0.01) ///
collabels(none)  ///
cells("mu_3(fmt(%9.2fc) star pvalue(d_p))" "se_3(par)") ///
nolines nomtitles gaps
