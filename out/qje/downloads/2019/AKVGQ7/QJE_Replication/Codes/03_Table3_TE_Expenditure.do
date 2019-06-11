********************************************************************
*********************** TABLE 3 - EXPENDITURE, SUBSTITUTION, PARENT
********************************************************************




use "$basein/R_EL_schools_noPII.dta", clear
keep SchoolID treatment treatarm
merge m:1 SchoolID using "$basein/School.dta"
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
gen TreatmentControl=0 
replace TreatmentControl=1 if treatment=="Control"
label var TreatmentControl "Control"

label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"

foreach i in 3 7{
	egen ExpendText_T`i'=rowtotal(gdrctb1_T`i'-gdrctb7_T`i')
	replace ExpendText_T`i'=ExpendText_T`i'/TotalNumberStudents_T`i'
}

forvalue grade=1/7{
	label variable gdrctb`grade'PS_T3 "/\$ Textbooks/Student Grd `grade'"
	label variable gdrctb`grade'PS_T7 "/\$ Textbooks/Student Grd `grade'"
}


foreach i in 3 7{
	label variable ExpendText_T`i' "/\$ Textbooks/Student"  
	label variable administrative_expensesPS_T`i' "/\$ Admin./Student"
	label variable teaching_aid_expensesPS_T`i' "/\$ Teaching Aid/Student"
	label variable student_expensesPS_T`i' "/\$ Student/Student"
	label variable Teacher_expensesPS_T`i' "/\$ Teacher/Student"
	label variable Construction_expensesPS_T`i' "/\$ Construction/Student" 

	label variable administrative_twawezaPS_T`i' "/\$ Admin./Student"
	label variable teaching_aid_twawezaPS_T`i' "/\$ Teaching Aid/Student"
	label variable student_twawezaPS_T`i' "/\$ Student/Student"
	label variable Teacher_twawezaPS_T`i' "/\$ Teacher/Student"
	label variable Construction_twawezaPS_T`i' "/\$ Construction/Student" 

	label variable studentsTeacherRatio_T`i' "Teacher Ratio"
	label variable studentsVolunteerRatio_T`i' "Vol. Ratio"
	label variable strategicly_change_teachers_T`i' "HT changed teachers"
	label variable strategicly_change_teachers_T`i' "HT changed students"
	label variable administrative_expenses_T`i' "/\$ Admin."
	label variable student_expenses_T`i' "/\$ Student"  
	label variable Teacher_expenses_T`i' "/\$ Teacher"
}

label var TimesCommitteeMet2013_T3 "No. Committee meetings"
label var debtyn_T3 "Debts"
label var ifnbyn_Since_T1 "Notice Board"
label var ifscyn_Since_T1 "Committee Meetings"
label var ifpmyn_Since_T1 "Parents Meetings"
label var ifotyn_Since_T1 "Others"


egen TotalExpenditure_T3=rowtotal(administrative_expensesPS_T3 student_expensesPS_T3 teaching_aid_expensesPS_T3 Teacher_expensesPS_T3 Construction_expensesPS_T3 textbook_expensesPS_T3), missing
egen TotalExpenditure_T7=rowtotal(administrative_expensesPS_T7 student_expensesPS_T7 teaching_aid_expensesPS_T7 Teacher_expensesPS_T7 Construction_expensesPS_T7 textbook_expensesPS_T7), missing

label var TotalExpenditure_T3 Total
label var TotalExpenditure_T7 Total

egen TotalExpenditureTwa_T3=rowtotal(administrative_twawezaPS_T3 student_twawezaPS_T3 teaching_aid_twawezaPS_T3 Teacher_twawezaPS_T3 Construction_twawezaPS_T3 textbook_twawezaPS_T3), missing
egen TotalExpenditureTwa_T7=rowtotal(administrative_twawezaPS_T7 student_twawezaPS_T7 teaching_aid_twawezaPS_T7 Teacher_twawezaPS_T7 Construction_twawezaPS_T7 textbook_twawezaPS_T7), missing

label var TotalExpenditureTwa_T3 Total
label var TotalExpenditureTwa_T7 Total

egen  TotalSub_M_T3=rowtotal(GovermentCG_M_T3 GovermentOther_M_T3 LocalGoverment_M_T3 NGO_M_T3 Parents_M_T3 Other_M_T3), missing
egen  TotalSub_M_T7=rowtotal(GovermentCG_M_T7 GovermentOther_M_T7 LocalGoverment_M_T7 NGO_M_T7 Parents_M_T7 Other_M_T7), missing

egen  TotalSub_D_T1=rowtotal(GovermentCG_D_T1 GovermentOther_D_T1 LocalGoverment_D_T1 NGO_D_T1 Parents_D_T1 Other_D_T1), missing
egen  TotalSub_D_T3=rowtotal(GovermentCG_D_T3 GovermentOther_D_T3 LocalGoverment_D_T3 NGO_D_T3 Parents_D_T3 Other_D_T3), missing
egen  TotalSub_D_T7=rowtotal(GovermentCG_D_T7 GovermentOther_D_T7 LocalGoverment_D_T7 NGO_D_T7 Parents_D_T7 Other_D_T7), missing

replace TotalSub_D_T1=(TotalSub_D_T1>0) if !missing(TotalSub_D_T1)
replace TotalSub_D_T3=(TotalSub_D_T3>0) if !missing(TotalSub_D_T3)
replace TotalSub_D_T7=(TotalSub_D_T7>0) if !missing(TotalSub_D_T7)

label var TotalSub_M_T3 Total
label var TotalSub_M_T7 Total

label var TotalSub_D_T3 Any
label var TotalSub_D_T7 Any


rename administrative_expensesPS* admin_expPS*
rename administrative_twawezaPS* admin_exptwaPS*
rename teaching_aid_twawezaPS* teaching_aid_twaPS*
rename Construction_twawezaPS* Construction_twaPS*

** NOW IW WANT DEPVAR2 TO BE ON TOP OF TWA EXPENDITURE


gen TotalExpenditure_T_T3=TotalExpenditure_T3
gen admin_expPS_T_T3=admin_expPS_T3
gen student_expensesPS_T_T3=student_expensesPS_T3
gen teaching_aid_expensesPS_T_T3=teaching_aid_expensesPS_T3
gen Teacher_expensesPS_T_T3=Teacher_expensesPS_T3
gen Construction_expensesPS_T_T3=Construction_expensesPS_T3

gen TotalExpenditure_T_T7=TotalExpenditure_T7
gen admin_expPS_T_T7=admin_expPS_T7
gen student_expensesPS_T_T7=student_expensesPS_T7
gen teaching_aid_expensesPS_T_T7=teaching_aid_expensesPS_T7
gen Teacher_expensesPS_T_T7=Teacher_expensesPS_T7
gen Construction_expensesPS_T_T7=Construction_expensesPS_T7

replace TotalExpenditure_T3=TotalExpenditure_T3-TotalExpenditureTwa_T3
replace admin_expPS_T3=admin_expPS_T3-admin_exptwaPS_T3
replace student_expensesPS_T3=student_expensesPS_T3-student_twawezaPS_T3
replace teaching_aid_expensesPS_T3=teaching_aid_expensesPS_T3-teaching_aid_twaPS_T3
replace Teacher_expensesPS_T3=Teacher_expensesPS_T3-Teacher_twawezaPS_T3
replace Construction_expensesPS_T3=Construction_expensesPS_T3-Construction_twaPS_T3

replace TotalExpenditure_T7=TotalExpenditure_T7-TotalExpenditureTwa_T7
replace admin_expPS_T7=admin_expPS_T7-admin_exptwaPS_T7
replace student_expensesPS_T7=student_expensesPS_T7-student_twawezaPS_T7
replace teaching_aid_expensesPS_T7=teaching_aid_expensesPS_T7-teaching_aid_twaPS_T7
replace Teacher_expensesPS_T7=Teacher_expensesPS_T7-Teacher_twawezaPS_T7
replace Construction_expensesPS_T7=Construction_expensesPS_T7-Construction_twaPS_T7

rename teaching_aid_expenses* teaching_aid_exp*
rename Construction_expenses* Construction_exp*

global depvars1 TotalExpenditureTwa admin_exptwaPS student_twawezaPS teaching_aid_twaPS Teacher_twawezaPS Construction_twaPS 
global depvars2 TotalExpenditure admin_expPS student_expensesPS teaching_aid_expPS Teacher_expensesPS Construction_expPS
global depvars2_b TotalExpenditure_T admin_expPS_T student_expensesPS_T teaching_aid_expPS_T Teacher_expensesPS_T Construction_expPS_T       
global depvars3 TotalSub_M GovermentCG_M GovermentOther_M LocalGoverment_M NGO_M Parents_M Other_M

label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"

foreach var in $schoolcontrol{
	sum `var' if treatment=="Control"
	replace `var'=`var'-r(mean)
}

***** 1, TOTAL EXPENDITURE FROM THE GRANT
eststo clear
foreach var in $depvars1{
	preserve
	keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
	reshape long `var'_T@, i(SchoolID) j(T) string
	drop if T!="3" & T!="7"
	encode T, gen(T2)
	recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
	eststo twa_`var': reg `var'_T $treatmentlist $schoolcontrol  (i.DistrictID)##T2, vce(cluster SchoolID)
	sum `var'_T if treatment=="Control" | treatment=="CG"
	estadd scalar N2=r(N)
	estadd ysumm
	sum `var'_T`i' if treatment=="Control"
	estadd scalar ymean2=r(mean)
	test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	restore
}
esttab twa* using "$latexcodesfinals/School_ExpenditureTWA.tex", se ar2 label fragment nolines ///
star(* 0.10 ** 0.05 *** 0.01) replace  ///
stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
nonotes  


foreach time in 3 7{
	foreach var in $depvars1{
		preserve
		keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
		reshape long `var'_T@, i(SchoolID) j(T) string
		drop if T!="`time'"
		encode T, gen(T2)
		recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
		eststo twa_`var'_`time': reg `var'_T $treatmentlist $schoolcontrol (i.DistrictID)##T2, vce(cluster SchoolID)
		estadd ysumm
		sum `var'_T if treatment=="Control" | treatment=="CG"
		estadd scalar N2=r(N)
		sum `var'_T`i' if treatment=="Control"
		estadd scalar ymean2=r(mean)
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
		estadd scalar p2=r(p)
		estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
		restore
	}
	esttab twa*`time' using "$latexcodesfinals/School_ExpenditureTWA`time'.tex", se ar2 label fragment nolines  ///
	star(* 0.10 ** 0.05 *** 0.01) replace  ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
	b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
	nonotes  

}

 
***** 2, TOTAL EXPENDITURE (not grant)
foreach var in $depvars2{
	preserve
	keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
	reshape long `var'_T@, i(SchoolID) j(T) string
	drop if T!="3" & T!="7"
	encode T, gen(T2)
	recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
	eststo s_`var': reg `var'_T $treatmentlist $schoolcontrol  (i.DistrictID)##T2, vce(cluster SchoolID)
	sum `var'_T if treatment=="Control" | treatment=="CG"
	estadd scalar N2=r(N)
	estadd ysumm
	sum `var'_T`i' if treatment=="Control"
	estadd scalar ymean2=r(mean)
	test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	restore
}
esttab s* using "$latexcodesfinals/School_Expenditure.tex", se ar2 label fragment nolines nogaps ///
star(* 0.10 ** 0.05 *** 0.01) replace  ///
stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
nonotes  


foreach time in 3 7{
	foreach var in $depvars2{
		preserve
		keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
		reshape long `var'_T@, i(SchoolID) j(T) string
		drop if T!="`time'"
		encode T, gen(T2)
		recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
		eststo s_`var'_`time': reg `var'_T $treatmentlist $schoolcontrol  ( i.DistrictID)##T2, vce(cluster SchoolID)
		sum `var'_T if treatment=="Control" | treatment=="CG"
		estadd scalar N2=r(N)
		estadd ysumm
		sum `var'_T`i' if treatment=="Control"
		estadd scalar ymean2=r(mean)
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
		estadd scalar p2=r(p)
		estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
		restore
	}
	esttab s*`time' using "$latexcodesfinals/School_Expenditure_`time'.tex", se ar2 label fragment nolines nogaps ///
	star(* 0.10 ** 0.05 *** 0.01) replace  ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
	b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
	nonotes  


}
preserve
keep TotalExpenditure* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
tempfile temp SchoolExpenditure_HH
save `SchoolExpenditure_HH', replace
restore


***** 3, TOTAL EXPENDITURE (school_level)
foreach var in $depvars2_b{
	preserve
	keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
	reshape long `var'_T@, i(SchoolID) j(T) string
	drop if T!="3" & T!="7"
	encode T, gen(T2)
	recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
	eststo ts_`var': reg `var'_T $treatmentlist $schoolcontrol ( i.DistrictID)##T2, vce(cluster SchoolID)
	sum `var'_T if treatment=="Control" | treatment=="CG"
	estadd scalar N2=r(N)
	estadd ysumm
	sum `var'_T`i' if treatment=="Control"
	estadd scalar ymean2=r(mean)
	test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	restore
}
esttab ts* using "$latexcodesfinals/School_Expenditure_Total.tex", se ar2 label fragment nolines  ///
star(* 0.10 ** 0.05 *** 0.01) replace  ///
stats(N ymean2 suma p suma2 p2, fmt(%9.0fc a2 a2 a2 a2 a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
nonotes  


foreach time in 3 7{
	foreach var in $depvars2_b{
		preserve
		keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
		reshape long `var'_T@, i(SchoolID) j(T) string
		drop if T!="`time'"
		encode T, gen(T2)
		recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
		eststo ts_`var'_`time': reg `var'_T $treatmentlist $schoolcontrol ( i.DistrictID)##T2, vce(cluster SchoolID)
		sum `var'_T if treatment=="Control" | treatment=="CG"
		estadd scalar N2=r(N)
		estadd ysumm
		sum `var'_T`i' if treatment=="Control"
		estadd scalar ymean2=r(mean)
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
		estadd scalar p2=r(p)
		estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
		restore
	}
	esttab ts*`time' using "$latexcodesfinals/School_Expenditure_Total_`time'.tex", se ar2 label fragment nolines  ///
	star(* 0.10 ** 0.05 *** 0.01) replace  ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
	b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
	nonotes  

}


***** Not in main table, but, SUBSTITUTION


foreach var in $depvars3{
	preserve
	keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
	reshape long `var'_T@, i(SchoolID) j(T) string
	drop if T!="3" & T!="7"
	encode T, gen(T2)
	recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
	eststo sub_`var': reg `var'_T $treatmentlist $schoolcontrol ( i.DistrictID)##T2, vce(cluster SchoolID)
	sum `var'_T if treatment=="Control" | treatment=="CG"
	estadd scalar N2=r(N)
	estadd ysumm
	sum `var'_T`i' if treatment=="Control"
	estadd scalar ymean2=r(mean)
	test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	restore
}
esttab sub_* using "$latexcodesfinals/OtherFunding.tex", se ar2 label fragment nolines nogaps ///
star(* 0.10 ** 0.05 *** 0.01) replace  ///
stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
nonotes  


foreach time in 3 7{
	foreach var in $depvars3{
		preserve
		keep `var'* $treatmentlist $schoolcontrol DistrictID SchoolID  treatment
		reshape long `var'_T@, i(SchoolID) j(T) string
		drop if T!="`time'"
		encode T, gen(T2)
		recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
		eststo sub_`var'_`time': reg `var'_T $treatmentlist $schoolcontrol ( i.DistrictID)##T2, vce(cluster SchoolID)
		sum `var'_T if treatment=="Control" | treatment=="CG"
		estadd scalar N2=r(N)		
		estadd ysumm
		sum `var'_T`i' if treatment=="Control"
		estadd scalar ymean2=r(mean)
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
		estadd scalar p2=r(p)
		estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
		restore
	}
	esttab sub_*`time' using "$latexcodesfinals/OtherFunding_`time'.tex", se ar2 label fragment nolines nogaps ///
	star(* 0.10 ** 0.05 *** 0.01) replace  ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
	b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
	nonotes  

}
*** 4, PARENTAL


use "$basein/Household.dta", clear
drop if treatment==""
drop if DistID==.
gen TreatmentCG=0 
replace TreatmentCG=1 if treatment=="CG" 
label var TreatmentCG "Grants"
gen TreatmentCOD=0 
replace TreatmentCOD=1 if treatment=="COD"
label var TreatmentCOD "Incentives"
gen TreatmentBoth=0 
replace TreatmentBoth=1 if treatment=="Both"
label var TreatmentBoth "Combination"



global depvars   Expenditure_FC AdultAttendsSchoolsMeeting AdultMeetsTeacher AdultGivesSchool AdultAtHome FCTutoring breakfast MoreBooks


global treatmentlist TreatmentCG TreatmentCOD TreatmentBoth
global varcontrol  bnkacc prdyyn  ltcbyn workyn NumHHMembers wall_mud floor_mud roof_durable improveWater improveSanitation HHElectricty  asset_1 asset_2 asset_3 asset_4 asset_5 asset_6 asset_7 asset_8 


global depvars2  Expenditure_FC expn131 expn132 expn133 expn134 expn135 expn136 expn137 expn138 expn139
global depvars2b  Expenditure2_FC expn131 expn132 expn133 expn134 expn135 expn136 expn137 expn138 expn139

label var expn131_T3 "Fees"
label var expn131_T7 "Fees"

label var expn132_T3 "Textbooks"
label var expn132_T7 "Textbooks"

label var expn133_T3 "Other books"
label var expn133_T7 "Other books"

label var expn134_T3 "Supplies"
label var expn134_T7 "Supplies"

label var expn135_T3 "Uniforms"
label var expn135_T7 "Uniforms"

label var expn136_T3 "Tutoring"
label var expn136_T7 "Tutoring"

label var expn137_T3 "Transport"
label var expn137_T7 "Transport"

label var expn138_T3 "Food"
label var expn138_T7 "Food"

label var expn139_T3 "Others"
label var expn139_T7 "Others"

foreach time in T3 T7{
	gen Expenditure2_FC_`time'=Expenditure_FC_`time'-expn135_`time'-expn138_`time'
}

foreach var in $varcontrol{
	gen Lag`var'=.
	replace Lag`var'=`var'_T1 if !missing(`var'_T1)
	replace Lag`var'=`var'_T5 if !missing(`var'_T5) & missing(Lag`var')
}


foreach j in 3 7{
	label var MoreBooks_T`j' "More Books Provided"
	label var Expenditure_FC_T`j' "Total Expenditure"
	label var AdultAttendsSchoolsMeeting_T`j' "Attend Meetings"
	label var AdultMeetsTeacher_T`j' "Meet Teacher"
	label var AdultGivesSchool_T`j' "Donate"
	label var AdultAtHome_T`j' "Adult at home"
	label var FCTutoring_T`j' "Tutoring"
	label var breakfast_T`j' "Breakfast"
}

sum Expenditure_FC_T3, d
replace Expenditure_FC_T3=r(p95) if Expenditure_FC_T3>r(p95) & !missing(Expenditure_FC_T3)
sum Expenditure_FC_T7, d
replace Expenditure_FC_T7=r(p95) if Expenditure_FC_T7>r(p95) & !missing(Expenditure_FC_T7)

sum Expenditure2_FC_T3, d
replace Expenditure2_FC_T3=r(p95) if Expenditure2_FC_T3>r(p95) & !missing(Expenditure2_FC_T3)
sum Expenditure2_FC_T7, d
replace Expenditure2_FC_T7=r(p95) if Expenditure2_FC_T7>r(p95) & !missing(Expenditure2_FC_T7)
	
			
sum Expenditure_FC_2012_T1, d
replace Expenditure_FC_2012_T1=r(p95) if Expenditure_FC_2012_T1>r(p95) & !missing(Expenditure_FC_2012_T1)
sum Expenditure_FC_2013_T5, d
replace Expenditure_FC_2013_T5=r(p95) if Expenditure_FC_2013_T5>r(p95) & !missing(Expenditure_FC_2013_T5)
		
		
gen LagExpenditure=Expenditure_FC_2012_T1 
replace LagExpenditure=Expenditure_FC_2013_T5 if LagExpenditure==. & Expenditure_FC_2013_T5!=.

global varcontrol Lagbnkacc Lagprdyyn  Lagltcbyn Lagworkyn LagNumHHMembers Lagwall_mud Lagfloor_mud Lagroof_durable LagimproveWater LagimproveSanitation LagHHElectricty Lagasset_1 Lagasset_2 Lagasset_3 Lagasset_4 Lagasset_5 Lagasset_6 Lagasset_7 Lagasset_8 LagExpenditure
	
drop *T5
drop *T1	

/*collapse the data*/
keep Expenditure2_FC* Expenditure_FC* expn13* $treatmentlist $varcontrol DistID SchoolID treatment
collapse (mean) Expenditure2_FC* Expenditure_FC* expn13* $varcontrol $treatmentlist, by(SchoolID DistID treatment)
label var TreatmentCG "Grants"
label var TreatmentCOD "Incentives"
label var TreatmentBoth "Combination"
merge 1:1 SchoolID using `SchoolExpenditure_HH'

foreach var in $depvars2{
	preserve
	keep `var'* $treatmentlist $schoolcontrol DistID SchoolID treatment
	reshape long `var'_T@, i(SchoolID) j(T) string
	drop if T!="3" & T!="7"
	encode T, gen(T2)
	recode `var'_T (-792=.)
	eststo hh_`var': quietly  reg `var'_T $treatmentlist $schoolcontrol (i.DistID)##T2, vce(cluster SchoolID)
	sum `var'_T if treatment=="Control" | treatment=="CG"
	estadd scalar N2=r(N)		
	estadd ysumm
	sum `var'_T`i' if treatment=="Control"
	estadd scalar ymean2=r(mean)
	test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	restore
}
label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"
esttab hh* using "$latexcodesfinals/Household.tex", se ar2 booktabs label fragment nolines  ///
star(* 0.10 ** 0.05 *** 0.01) replace  ///
stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
nonotes  



foreach time in 3 7{
	foreach var in $depvars2{
		preserve
		keep `var'* $treatmentlist $schoolcontrol DistID SchoolID treatment
		reshape long `var'_T@, i(SchoolID) j(T) string
		drop if T!="`time'"
		encode T, gen(T2)
		recode `var'_T (-792=.)
		eststo hh_`var'_`time': quietly  reg `var'_T $treatmentlist $schoolcontrol (i.DistID)##T2, vce(cluster SchoolID)
		sum `var'_T if treatment=="Control" | treatment=="CG"
		estadd scalar N2=r(N)
		estadd ysumm
		sum `var'_T`i' if treatment=="Control"
		estadd scalar ymean2=r(mean)
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
		estadd scalar p2=r(p)
		estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
		restore
	}
	label var TreatmentCOD "Incentives (\$\alpha_2\$)"
	label var TreatmentCG "Grants (\$\alpha_1\$)"
	label var TreatmentBoth "Combination (\$\alpha_3\$)"
	esttab hh*_`time' using "$latexcodesfinals/Household_`time'.tex", se ar2 booktabs label fragment nolines  ///
	star(* 0.10 ** 0.05 *** 0.01) replace  ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc  %9.2fc %9.2fc a2 %9.2fc a2) labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
	b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
	nonotes  

}






gen PerChildExpenditure_T3=TotalExpenditure_T_T3+Expenditure_FC_T3
gen PerChildExpenditure_T7=TotalExpenditure_T_T7+Expenditure_FC_T7

gen PerChildExpenditure2_T3=TotalExpenditure_T_T3+Expenditure2_FC_T3
gen PerChildExpenditure2_T7=TotalExpenditure_T_T7+Expenditure2_FC_T7


eststo perchild_T3:  reg PerChildExpenditure_T3 $treatmentlist $schoolcontrol i.DistrictID, vce(cluster SchoolID)
estadd ysumm
sum PerChildExpenditure_T3 if treatment=="Control" | treatment=="CG"
estadd scalar N2=r(N)
sum PerChildExpenditure_T3 if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
estadd scalar p2=r(p)
estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]

eststo perchild_T7: reg PerChildExpenditure_T7 $treatmentlist $schoolcontrol i.DistrictID, vce(cluster SchoolID)
estadd ysumm
sum PerChildExpenditure_T7 if treatment=="Control" | treatment=="CG"
estadd scalar N2=r(N)
sum PerChildExpenditure_T7 if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
estadd scalar p2=r(p)
estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]

preserve
reshape long PerChildExpenditure_T@, i(SchoolID) j(T) string
encode T, gen(T2)

eststo perchild:  reg PerChildExpenditure_T $treatmentlist $schoolcontrol  i.DistrictID, vce(cluster SchoolID)
estadd ysumm
sum PerChildExpenditure_T if treatment=="Control" | treatment=="CG"
estadd scalar N2=r(N)
sum PerChildExpenditure_T if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
test (_b[TreatmentBoth] -_b[TreatmentCG]=0)
estadd scalar p2=r(p)
estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
restore




*********** COMBINE THE RESULTS **************
label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"


esttab twa_TotalExpenditureTwa  s_TotalExpenditure ts_TotalExpenditure_T hh_Expenditure_FC perchild  using "$latexcodesfinals/Subs.tex", se ar2 booktabs label fragment nolines  ///
star(* 0.10 ** 0.05 *** 0.01) replace  ///
stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2)  labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
nonotes  


foreach time in 3 7{
	esttab twa_TotalExpenditureTwa_`time'   s_TotalExpenditure_`time' ts_TotalExpenditure_T_`time' hh_Expenditure_FC_`time' perchild_T`time'  using "$latexcodesfinals/Subs_`time'.tex", se ar2 booktabs label fragment nolines  ///
	star(* 0.10 ** 0.05 *** 0.01) replace  ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2)  labels ("N. of obs." "Mean control" "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)""\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1=0\$)")) substitute(/_ _) ///
	b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers nomtitle ///
	nonotes  

}
