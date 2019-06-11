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


foreach time in T3 T7{
	capture matrix drop Coef
	capture matrix drop Error
	foreach var in $AggregateDep_Karthik{
		reg `var'_`time'  $treatmentlist i.DistID $studentcontrol  $schoolcontrol $HHcontrol  , vce(cluster SchoolID) 
		lincom _b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		scalar error2=r(se)
		scalar error2=error2^2
		mat B=e(b)
		mat E=vecdiag(e(V))
		mat Coef  = nullmat(Coef) \ [B[1,1..3],r(estimate)]
		mat Error  = nullmat(Error) \ [E[1,1..3], error2]
	}
	preserve
	clear
	svmat Coef
	export delimited using "$latexcodesfinals/Coef_`time'.csv", replace
	clear
	svmat Error
	export delimited using "$latexcodesfinals/Error_`time'.csv", replace
	clear
	restore
}



eststo clear
foreach time in T3 T7{
	foreach var in $AggregateDep_Karthik{
		eststo est_`var'_`time':   reg `var'_`time' ${treatmentlist}  i.DistID $studentcontrol $schoolcontrol $HHcontrol if LagGrade>=2 & LagGrade<=3, vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
	}  
}
 


esttab  using "$latexcodesfinals/RegTestScores_2yeareffect.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles nolines  ///
keep(TreatmentCG TreatmentCOD TreatmentBoth) stats(N suma p, fmt(%9.0fc a2 a2) labels("N. of obs." "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "") star(suma)) ///
nonotes substitute(\_ _)
