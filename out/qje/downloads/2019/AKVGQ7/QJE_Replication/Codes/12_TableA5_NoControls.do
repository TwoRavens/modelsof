use "$basein/Student_School_House_Teacher_Char.dta", clear


gen TreatmentCOD2=TreatmentCOD
gen TreatmentBoth2=TreatmentBoth

label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"



label var Z_kiswahili_T3 Kiswahili
label var Z_kiswahili_T7 Kiswahili
label var Z_kiingereza_T3 English
label var Z_kiingereza_T7 English
label var Z_hisabati_T3 Math
label var Z_hisabati_T7 Math
label var Z_ScoreFocal_T3 "Combined (PCA)"
label var Z_ScoreFocal_T7 "Combined (PCA)"


eststo clear
foreach time in T3 T7{
	foreach var in $AggregateDep_Karthik{
		eststo est_`var'_`time':   reg `var'_`time' ${treatmentlist}  i.DistID $studentcontrol, vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	}  
}
 


esttab  using "$latexcodesfinals/RegTestScores_NoControls.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles  nolines ///
keep(TreatmentCG TreatmentCOD TreatmentBoth) stats(N suma p, fmt(%9.0fc a2 a2) labels("N. of obs." "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "") star(suma)) ///
nonotes substitute(\_ _)
