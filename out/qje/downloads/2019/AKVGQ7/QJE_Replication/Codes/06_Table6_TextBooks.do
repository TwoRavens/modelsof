********************************************************************
*********************** textbooks
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


foreach i in 3 7{
	egen ExpendText_T`i'=rowtotal(gdrctb1_T`i'-gdrctb7_T`i')
	replace ExpendText_T`i'=ExpendText_T`i'/TotalNumberStudents_T`i'
}

forvalue grade=1/7{
	label variable gdrctb`grade'PS_T3 "\\$ Textbooks/Student Grd `grade'"
	label variable gdrctb`grade'PS_T7 "\\$ Textbooks/Student Grd `grade'"
}

forvalue grade=1/7{
	gen gdrctbPS_T3`grade'= gdrctb`grade'PS_T3
	gen gdrctbPS_T7`grade'= gdrctb`grade'PS_T7
}

preserve
	keep gdrctbPS_T* SchoolID DistrictID $schoolcontrol $treatmentlist treatment
	reshape long gdrctbPS_T3 gdrctbPS_T7, i(SchoolID) j(Grade)
	reshape long gdrctbPS_T@ , i(SchoolID Grade) j(T)
	drop if T!=3 & T!=7
	gen FG=(Grade<=3)
	eststo books_0: reg gdrctbPS_T c.($treatmentlist) (c.($schoolcontrol)  i.DistrictID)##T if FG==0, vce(cluster SchoolID)
	test (_b[TreatmentBoth]- _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth]-_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	sum gdrctbPS_T if treatment=="Control" & FG==0
	estadd scalar ymean2=r(mean)

	eststo books_1: reg gdrctbPS_T c.($treatmentlist) (c.($schoolcontrol)  i.DistrictID)##T if FG==1, vce(cluster SchoolID)
	test (_b[TreatmentBoth]- _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	test (_b[TreatmentBoth]-_b[TreatmentCG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[TreatmentBoth]-_b[TreatmentCG]
	sum gdrctbPS_T if treatment=="Control" & FG==1
	estadd scalar ymean2=r(mean)

	rename TreatmentCG TreatmentCG2
	rename TreatmentCOD TreatmentCOD2
	rename TreatmentBoth TreatmentBoth2
	eststo books_2: reg gdrctbPS_T c.($treatmentlist)##c.FG c.FG##(c.($schoolcontrol)  i.DistrictID)##T, vce(cluster SchoolID)
	test (_b[c.TreatmentBoth2#c.FG]-_b[c.TreatmentCOD2#c.FG]-_b[c.TreatmentCG2#c.FG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[c.TreatmentBoth2#c.FG]-_b[c.TreatmentCOD2#c.FG]-_b[c.TreatmentCG2#c.FG]
	test (_b[c.TreatmentBoth2#c.FG]-_b[c.TreatmentCG2#c.FG]=0)
	estadd scalar p2=r(p)
	estadd scalar suma2=_b[c.TreatmentBoth2#c.FG]-_b[c.TreatmentCG2#c.FG]
	sum gdrctbPS_T if treatment=="Control" & FG==1
	scalar def mean1=r(mean)
	sum gdrctbPS_T if treatment=="Control" & FG==0
	scalar def mean2=r(mean)
	estadd scalar ymean2=scalar(mean1)-scalar(mean2)

	esttab books_0 books_1 books_2  using "$latexcodesfinals/School_textbook_extra2.tex", se booktabs label fragment nolines  nomtitles ///
	rename(c.TreatmentBoth2#c.FG TreatmentBoth c.TreatmentCOD2#c.FG TreatmentCOD c.TreatmentCG2#c.FG TreatmentCG) ///
	keep(TreatmentBoth TreatmentCOD TreatmentCG) star(* 0.10 ** 0.05 *** 0.01) replace ///
	b(%9.2fc)se(%9.2fc)nocon  nonumbers  ///
	coeflabels(TreatmentBoth "Combination (\$\alpha_3\$)" TreatmentCOD "Incentives (\$\alpha_2\$)" TreatmentCG "Grants (\$\alpha_1\$)") ///
	stats(N ymean2 suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc a2 %9.2fc a2)  labels ("N. of obs." "Mean control"   ///
	"\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "\$\alpha_3-\alpha_1\$" "p-value (\$\alpha_3-\alpha_1\$=0)")) substitute(/_ _)
restore


