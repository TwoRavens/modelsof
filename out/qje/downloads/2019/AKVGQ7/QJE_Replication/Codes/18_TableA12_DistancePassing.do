
*****THIS SAVES THE PASS RATE IN THE CONTROL GROUP IN THE HIGH-STAKES
tempfile pass2013
tempfile pass2014

use "$basein/TwaTestData2013.dta", clear
merge 1:1 SchoolID using "$basein/R_EL_schools_noPII.dta", keepus(treatment treatarm)
drop if _merge!=3
drop if treatarm!=4
collapse (sum) NrTests_1- Passed_3m
foreach name in "k" "e" "m"{
	forval i=1/3  {
		gen PR_`i'_`name'=Passed_`i'`name'/NrTests_`i'
		if "`name'"=="k" label var PR_`i'_`name' "K S`i'"
		if "`name'"=="e" label var PR_`i'_`name' "E S`i'"
		if "`name'"=="m" label var PR_`i'_`name' "M S`i'"
	}
}

keep  PR_1_k- PR_3_m
gen id=_N
reshape long PR_@_k PR_@_e PR_@_m, i(id) j(Grade)
drop id
rename PR__k Z_kiswahili_Pass_T3
rename PR__e Z_kiingereza_Pass_T3
rename PR__m Z_hisabati_Pass_T3
rename Grade GradeID_T3
save `pass2013', replace


use "$basein/TwaTestData2014", clear
drop if treatment!=4
collapse  (mean) Kis_Pass Eng_Pass Math_Pass, by(Grade )
rename Kis_Pass Z_kiswahili_Pass_T7
rename Eng_Pass Z_kiingereza_Pass_T7
rename Math_Pass Z_hisabati_Pass_T7
rename Grade GradeID_T7
save `pass2014', replace




use "$basein/Student_School_House_Teacher_Char.dta", clear
merge m:1 GradeID_T3 using `pass2013'
drop _merge
merge m:1 GradeID_T7 using `pass2014'
drop _merge
foreach var of varlist Z_kiswahili_Pass_T3- Z_hisabati_Pass_T7{
	replace `var'=100*(1-`var')
}

egen Percentile_Z_kiingereza_T = fastxtile(LagZ_kiingereza), by(LagGrade) nq(100)
egen Percentile_Z_hisabati_T = fastxtile(LagZ_hisabati), by(LagGrade) nq(100)
egen Percentile_Z_kiswahili_T = fastxtile(LagZ_kiswahili), by(LagGrade) nq(100)

label var TreatmentCOD "Incentives"
label var TreatmentCG "Grants"
label var TreatmentBoth "Combination"


eststo clear
foreach time in T3 T7{
	foreach var in hisabati kiswahili kiingereza{
		capture drop Distance
		gen Distance=abs(Percentile_Z_`var'_T-Z_`var'_Pass_`time')
		replace Distance=Distance/100
		eststo: reg Z_`var'_`time' c.(${treatmentlist})##c.Distance  $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade, vce(cluster SchoolID) 
		estadd ysumm
	}
}

esttab  using "$latexcodesfinals/Reg_DistnacePassingPercentile.tex", se ar2 booktabs nolines label fragment ///
replace  b(%9.3fc)se(%9.3fc)nocon nonum  ///
keep(*TreatmentCG* *TreatmentCOD* *TreatmentBoth* *Distance*) stats(N , fmt(%9.0fc) labels ("N. of obs.")) ///
drop(TreatmentBoth TreatmentCG TreatmentCOD Distance) ///
nomtitle 


eststo clear
foreach time in T3 T7{
	foreach var in hisabati kiswahili kiingereza{
		capture drop Distance
		gen Distance=abs(Percentile_Z_`var'_T-Z_`var'_Pass_`time')
		replace Distance=Distance/100
		replace Distance=Distance^2
		label var Distance "Distance\$^2\$"
		eststo: reg Z_`var'_`time' c.(${treatmentlist})##c.Distance  $studentcontrol  $schoolcontrol $HHcontrol  i.DistID i.LagGrade, vce(cluster SchoolID) 
		estadd ysumm
	}
}

esttab  using "$latexcodesfinals/Reg_DistnaceQuadPassingPercentile.tex", se ar2 booktabs nolines label fragment ///
replace  b(%9.3fc)se(%9.3fc)nocon nonum  ///
keep(*TreatmentCG* *TreatmentCOD* *TreatmentBoth* *Distance*) stats(N , fmt(%9.0fc) labels ("N. of obs.")) ///
drop(TreatmentBoth TreatmentCG TreatmentCOD Distance) ///
nomtitle 
