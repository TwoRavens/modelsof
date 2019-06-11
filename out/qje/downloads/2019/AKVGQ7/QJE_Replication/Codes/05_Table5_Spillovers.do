
use "$basein/Student_School_House_Teacher_Char.dta", clear


gen TreatmentCOD2=TreatmentCOD
gen TreatmentBoth2=TreatmentBoth


label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"


********************************************************************
*********************** OTHER SUBJECTS/GRADES
********************************************************************

************************************
************* PSLE 2013 *****************
************************************

use "$basein/Student_PSLE_2013.dta",clear
encode SX, gen(SX2)
sort SchoolID
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

label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"

gen Pass=(AVERAGE>=3)
label var Pass "Pass"
label var AVERAGE "Score"


eststo clear
eststo m1_2013: reg Pass  $treatmentlist $schoolcontrol i.DistrictID i.SX2 , vce(cluster SchoolID)
estadd ysumm
sum Pass if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]

eststo m2_2013: reg AVERAGE  $treatmentlist $schoolcontrol i.DistrictID i.SX2, vce(cluster SchoolID)
estadd ysumm
sum AVERAGE if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG] 
    
************************************
************* PSLE 2014 *****************
************************************

use "$basein/Student_PSLE_2014.dta",clear
encode SX, gen(SX2)
sort SchoolID
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


gen Pass=(AVERAGE>=3)
label var Pass "Pass"
label var AVERAGE "Average score"



eststo m1_2014: reg Pass  $treatmentlist $schoolcontrol i.DistrictID i.SX2 , vce(cluster SchoolID)
estadd ysumm
sum Pass if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]

eststo m2_2014: reg AVERAGE  $treatmentlist $schoolcontrol i.DistrictID i.SX2, vce(cluster SchoolID)
estadd ysumm
sum AVERAGE if treatment=="Control"
estadd scalar ymean2=r(mean)
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG] 
  


    	  

************************************
************* Science *****************
************************************

use "$basein/Student_School_House_Teacher_Char.dta", clear


gen TreatmentCOD2=TreatmentCOD
gen TreatmentBoth2=TreatmentBoth
label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"
*First lets create the tables Karthik Wants

label var Z_sayansi_T3 "Year 1"
label var Z_sayansi_T7 "Year 2"


foreach time in T3 T7{
foreach var in Z_sayansi{
eststo est_`var'_`time':  reg `var'_`time' $treatmentlist i.DistrictID $studentcontrol $schoolcontrol $HHcontrol , vce(cluster SchoolID) 
estadd ysumm
test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
estadd scalar p=r(p)
estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
}  

}



esttab est_Z_sayansi_T3 est_Z_sayansi_T7 m1_2013 m2_2013  m1_2014 m2_2014  using "$latexcodesfinals/RegOtherGradesSubjects_nonumber.tex", se ar2 fragment booktabs nolines label b(%9.2fc) se(%9.2fc)nocon nonumber /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  mgroups("Science" "Grade 7 PSLE 2013" "Grade 7 PSLE 2014", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))  ///
mlabel("Year 1" "Year 2"   "Pass" "Score"  "Pass" "Score") ///
keep(TreatmentCG TreatmentCOD TreatmentBoth) stats(N ymean2 suma p, fmt(%9.0fc a2 a2 a2)  labels("N. of obs." "Mean control group" "\$\alpha_4 =\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "") star(suma)) ///
nonotes substitute(\_ _)



