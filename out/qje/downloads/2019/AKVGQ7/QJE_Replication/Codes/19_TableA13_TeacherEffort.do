use "$basein/R_EL_schools_noPII.dta", clear
keep SchoolID treatment treatarm DistID
merge 1:m SchoolID using "$basein/Teacher.dta"
drop _merge
merge m:1 SchoolID using "$basein/School.dta"
drop _merge
drop if upid==""
merge 1:1 upid using "$basein/TAttendace.dta"
drop if _merge!=3
drop _merge
rename atttch_T2 atttch_T3
rename atttch_T6 atttch_T7
keep if consnt_T3==1 &  tcnsnt_T7==1

*keep if FGS_T7==1 & FGS_T3==1

replace atttch_T3=0 if atttch_T3==. & FGS_T3==1
replace atttch_T7=0 if atttch_T7==. & FGS_T7==1
rename attcls_T6 attcls_T7
replace attcls_T7=0 if attcls_T7==. & FGS_T7==1
gen attcls_T3=.

gen TreatmentCG=0 
replace TreatmentCG=1 if treatment=="CG"
label var TreatmentCG "Grants"
gen TreatmentCOD=0 
replace TreatmentCOD=1 if treatment=="COD"
label var TreatmentCOD "Incentives"
gen TreatmentBoth=0 
replace TreatmentBoth=1 if treatment=="Both"
label var TreatmentBoth "Combination"
label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"

global depvarsFinales atttch attcls  test_F_sub_F_yrs   tutoring_F_sub_F_yrs remedial_F_sub_F_yrs    
global depvarsFinales2  t271  t275 t276 t277 TimeAtSchool

foreach var in $depvarsFinales{
	replace `var'_T3=. if FGS_T3!=1
	replace `var'_T7=. if FGS_T7!=1
}

eststo clear
foreach var in $depvarsFinales{
	preserve
	keep `var'* $treatmentlist $schoolcontrol $teachercontrol DistID SchoolID upid
	reshape long `var'_T@, i(upid) j(T) string
	drop if T!="3" & T!="7"
	encode T, gen(T2)
	recode `var'_T (-99=.) (-98=.) (99=.) (98=.) 
	sum `var'_T,d
	replace `var'_T=r(p99) if `var'_T>r(p99) & !missing(`var'_T)
	replace `var'_T=r(p1) if `var'_T<r(p1) & !missing(`var'_T)
	eststo m_`var': reg `var'_T $treatmentlist  $schoolcontrol ( i.DistID)##T2, vce(cluster SchoolID)
	estadd ysumm
	test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
	estadd scalar p=r(p)
	estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	restore
}
esttab using "$latexcodesfinals/RegTeacher.tex", se ar2 booktabs label fragment nolines nogaps nomtitles ///
replace  stats(N ymean suma p, fmt(%9.0fc a2  a2 a2) labels ("N. of obs." "Mean of dep. var." "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "") star(p)) ///
star(* 0.10 ** 0.05 *** 0.01)   b(%9.2fc)se(%9.2fc)nocon  keep(TreatmentCG TreatmentCOD TreatmentBoth) nonumbers  ///
nonotes addnotes("/specialcell{Clustered standard errors, by school, in parenthesis//  /sym{*} /(p<0.10/), /sym{**} /(p<0.05/), /sym{***} /(p<0.01/) }") substitute(/_ _)

