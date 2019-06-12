
eststo clear
use "$basein/Student_School_House_Teacher_Char.dta", clear
drop if upid=="R1STU09272102" & SchoolID!=927
drop if upid=="R1STU10072102" & SchoolID!=1007
drop if upid=="R1STU10072110" & SchoolID!=1007
bys upid: gen  N=_N
drop if Z_ScoreFocal_T3==. & N>1
gen IDDate_T4_format=date( IDDate_T4,"DMY",2050)
format IDDate_T4_format %td

bys SchoolID: egen DateEDI_T3=mode(date_T3), maxmode
bys SchoolID: egen DateTWA_T3=mode(IDDate_T4_format), maxmode

bys SchoolID: egen DateEDI_T7=mode(date_T7), maxmode
bys SchoolID: egen DateTWA_T7=mode(dateTWA_T8), maxmode

gen Difference_T3=DateTWA_T3-DateEDI_T3
gen Difference_T7=DateTWA_T7-DateEDI_T7


foreach var in $subjects{
	foreach cov in Difference {
		preserve
		keep  Z_`var'_* Difference_T* $treatmentlist  HHSize MissingHHSize IndexPoverty MissingIndexPoverty IndexEngagement MissingIndexEngagement LagExpenditure MissingLagExpenditure LagseenUwezoTests LagpreSchoolYN Lagmale LagAge LagGrade LagZ_kiswahili LagZ_hisabati LagZ_kiingereza  $schoolcontrol  DistID WeekIntvTest_T* LagGrade upid SchoolID
		drop if upid==""
		capture drop Z_`var'_T1
		capture drop Z_`var'_T5
		capture drop Z_`var'_T4
		capture drop Z_`var'_T8
		capture drop Z_`var'_T*_*
		
		
		
		reshape long Z_`var'_T@ Difference_T@ WeekIntvTest_T@, i(upid) j(T) string
		gen Covar=`cov'_T
		sum Covar,d
		capture drop TCGCOV
		capture drop TCODCOV
		capture drop TBothCOV
		encode T, gen(T2)
		capture gen TCGCOV=TreatmentCG*Covar
		label var TCGCOV "CG * Cov"
		capture gen TCODCOV=TreatmentCOD*Covar 
		label var TCGCOV "COD * Cov"
		capture gen TBothCOV=TreatmentBoth*Covar
		label var TCGCOV "Both * Cov"
		eststo:  reg Z_`var'_T  TreatmentCOD TreatmentBoth   TCODCOV TBothCOV Covar c.($studentcontrol )#i.T2  c.($schoolcontrol )#i.T2 c.($HHcontrol )#i.T2  i.DistID#i.T2 i.LagGrade#i.T2 i.T2 ,vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
		estadd scalar pval1=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
		test (_b[TBothCOV] - _b[TCODCOV]=0)
		estadd scalar pval2=r(p)
		estadd scalar suma2=_b[TBothCOV] - _b[TCODCOV]	  
		restore
	}
	
	

}


esttab using "$latexcodesfinals/Heter_Date2.tex", se ar2 booktabs nolines label fragment ///
replace  b(%9.3fc)se(%9.3fc)nocon nonum  ///
keep(TreatmentCOD TCODCOV TreatmentBoth TBothCOV) ///
star(* 0.10 ** 0.05 *** 0.01)  stats(N , fmt(%9.0fc) labels ("N. of obs.")) ///
varlabels(Covar Covariate  TCODCOV Incentives*Difference(Days) TBothCOV Combination*Difference(Days)) ///
nomtitle ///
nonotes 




foreach var in $subjects{

	foreach cov in Difference {
		preserve
		keep  Z_`var'_* Difference_T* $treatmentlist  HHSize MissingHHSize IndexPoverty MissingIndexPoverty IndexEngagement MissingIndexEngagement LagExpenditure MissingLagExpenditure LagseenUwezoTests LagpreSchoolYN Lagmale LagAge LagGrade LagZ_kiswahili LagZ_hisabati LagZ_kiingereza  $schoolcontrol  DistID WeekIntvTest_T* LagGrade upid SchoolID
		drop if upid==""
		capture drop Z_`var'_T1
		capture drop Z_`var'_T5
		capture drop Z_`var'_T4
		capture drop Z_`var'_T8
		capture drop Z_`var'_T*_*
		
		
		
		reshape long Z_`var'_T@ Difference_T@ WeekIntvTest_T@, i(upid) j(T) string
		gen Covar=`cov'_T
		sum Covar,d
		capture drop TCGCOV
		capture drop TCODCOV
		capture drop TBothCOV
		
		capture gen TCGCOV=TreatmentCG*Covar
		label var TCGCOV "CG * Cov"
		capture gen TCODCOV=TreatmentCOD*Covar 
		label var TCGCOV "COD * Cov"
		capture gen TBothCOV=TreatmentBoth*Covar
		label var TCGCOV "Both * Cov"
		eststo `var'_T3:  reg Z_`var'_T  TreatmentCOD TreatmentBoth   TCODCOV TBothCOV Covar $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade  if T=="3",vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
		estadd scalar pval1=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
		test (_b[TBothCOV] - _b[TCODCOV]=0)
		estadd scalar pval2=r(p)
		estadd scalar suma2=_b[TBothCOV] - _b[TCODCOV]	 
		
		eststo `var'_T7:  reg Z_`var'_T  TreatmentCOD TreatmentBoth   TCODCOV TBothCOV Covar $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade  if T=="7",vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
		estadd scalar pval1=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
		test (_b[TBothCOV] - _b[TCODCOV]=0)
		estadd scalar pval2=r(p)
		estadd scalar suma2=_b[TBothCOV] - _b[TCODCOV]	 
		restore
	}
	
	

}


esttab *T3 using "$latexcodesfinals/Heter_Date2_T3.tex", se ar2 booktabs nolines label fragment ///
replace  b(%9.3fc)se(%9.3fc)nocon nonum  ///
keep(TreatmentCOD TCODCOV TreatmentBoth TBothCOV) ///
star(* 0.10 ** 0.05 *** 0.01)  stats(N , fmt(%9.0fc) labels ("N. of obs.")) ///
varlabels(Covar Covariate  TCODCOV Incentives*Difference(Days) TBothCOV Combination*Difference(Days)) ///
nomtitle ///
nonotes addnotes("\specialcell{Clustered standard errors, by school, in parenthesis\\  \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\) }" "\tiny The independent variable is the standardized test score. Each regression has a different covariate interacted with the treatment dummies. The column title indicates the covariate interacted. Baseline score is the standardized test score at the beginning of the first year; Grade $k$ is equal to one, if the student is in grade $k$; Male is a equal to one if the student is male; Age is the age in years of the student. ")


esttab *T7 using "$latexcodesfinals/Heter_Date2_T7.tex", se ar2 booktabs nolines label fragment ///
replace  b(%9.3fc)se(%9.3fc)nocon nonum  ///
keep(TreatmentCOD TCODCOV TreatmentBoth TBothCOV) ///
star(* 0.10 ** 0.05 *** 0.01)  stats(N , fmt(%9.0fc) labels ("N. of obs.")) ///
varlabels(Covar Covariate  TCODCOV Incentives*Difference(Days) TBothCOV Combination*Difference(Days)) ///
nomtitle ///
nonotes addnotes("\specialcell{Clustered standard errors, by school, in parenthesis\\  \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\) }" "\tiny The independent variable is the standardized test score. Each regression has a different covariate interacted with the treatment dummies. The column title indicates the covariate interacted. Baseline score is the standardized test score at the beginning of the first year; Grade $k$ is equal to one, if the student is in grade $k$; Male is a equal to one if the student is male; Age is the age in years of the student. ")



***** APENDIX FIGURE WITH TEST DATE HISTOGRAMS


preserve
collapse (median) DateTWA_T3 DateEDI_T3 DateTWA_T7 DateEDI_T7 Difference_T3 Difference_T7, by(SchoolID treatment treatarm)
format %td DateTWA_T3 DateEDI_T3 DateTWA_T7 DateEDI_T7

twoway (histogram DateTWA_T3, fcolor(gs10) fintensity(50) lcolor(none)) (histogram DateEDI_T3, fcolor(none) fintensity(50) lcolor(none)), ///
legend(order(1 "High-stakes" 2 "Low-stakes")) graphregion(color(white))
graph export "$graphs/Dates_T3.pdf", replace


twoway (histogram DateTWA_T7, fcolor(gs10) fintensity(50) lcolor(none)) (histogram DateEDI_T7, fcolor(none) fintensity(50) lcolor(none)), ///
legend(order(1 "High-stakes" 2 "Low-stakes")) graphregion(color(white))
graph export "$graphs/Dates_T7.pdf", replace



gen DateT3=DateEDI_T3
replace DateT3=DateTWA_T3 if DateTWA_T3!=.
foreach tr in "COD" "Control" "Both"{

	sum DateT3
	twoway (histogram DateTWA_T3 if treatment=="`tr'", fcolor(gs10) fintensity(50) lcolor(none)) (histogram DateEDI_T3 if treatment=="`tr'", fcolor(none) fintensity(50) lcolor(none)), ///
	legend(order(1 "High-stakes" 2 "Low-stakes")) graphregion(color(white)) xscale(range(`r(min)' `r(max)'))
	graph export "$graphs/Dates_T3_`tr'.pdf", replace

	sum DateEDI_T7
	twoway (histogram DateTWA_T7 if treatment=="`tr'", fcolor(gs10) fintensity(50) lcolor(none)) (histogram DateEDI_T7 if treatment=="`tr'", fcolor(none) fintensity(50) lcolor(none)), ///
	legend(order(1 "High-stakes" 2 "Low-stakes")) graphregion(color(white)) xscale(range(`r(min)' `r(max)'))
	graph export "$graphs/Dates_T7_`tr'.pdf", replace

}

	sum DateT3
	twoway  (histogram DateEDI_T3 if treatment=="CG", fcolor(none) fintensity(50) lcolor(none)) (histogram DateTWA_T3 if treatment=="CG", fcolor(gs10) fintensity(50) lcolor(none)), ///
	legend(order(2 "High-stakes" 1 "Low-stakes")) graphregion(color(white)) xscale(range(`r(min)' `r(max)'))
	graph export "$graphs/Dates_T3_CG.pdf", replace

	sum DateEDI_T7
	twoway (histogram DateEDI_T7 if treatment=="CG", fcolor(none) fintensity(50) lcolor(none)) (histogram DateTWA_T7 if treatment=="CG", fcolor(gs10) fintensity(50) lcolor(none)) , ///
	legend(order(2 "High-stakes" 1 "Low-stakes")) graphregion(color(white)) xscale(range(`r(min)' `r(max)'))
	graph export "$graphs/Dates_T7_`tr'.pdf", replace


restore
