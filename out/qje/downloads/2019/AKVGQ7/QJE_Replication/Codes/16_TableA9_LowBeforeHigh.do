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


*** LOW-STAKES*****


gen date_T4=date(IDDate_T4,"DMY")
gen dummy_T3=.
replace dummy_T3=1 if date_T3<date_T4 & !missing(date_T3) & !missing(date_T4)
replace dummy_T3=1 if missing(date_T4)

gen dummy_T7=.
replace dummy_T7=1 if date_T7<date_T8 & !missing(date_T7) & !missing(date_T8)
replace dummy_T7=1 if missing(date_T8)


eststo clear
foreach time in T3 T7{
	foreach var in $AggregateDep_Karthik{
		eststo est_`var'_`time':   reg `var'_`time' ${treatmentlist}  i.DistID $studentcontrol $schoolcontrol $HHcontrol if dummy_`time'==1, vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]
		
		test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
		estadd scalar p2=r(p)
		estadd scalar suma2=_b[TreatmentBoth] - _b[TreatmentCOD]
		
		test (_b[TreatmentBoth] - 1.117*_b[TreatmentCOD]-_b[TreatmentCG]=0)
		estadd scalar p3=r(p)
		test (_b[TreatmentBoth] -2.05*_b[TreatmentCG]=0)
		estadd scalar p4=r(p)
		test (_b[TreatmentBoth] -3.45*_b[TreatmentCOD]=0)
		estadd scalar p5=r(p)
		
		sum `var'_`time' if treatment=="Control" | treatment=="COD"
		estadd scalar N2=r(N)
	}
}
esttab  using "$latexcodesfinals/RegTestScores_LowBeforeHigh.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles nolines ///
keep(TreatmentCG TreatmentCOD TreatmentBoth) stats(N suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc %9.2fc %9.2fc %9.2fc) labels("N. of obs." "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "\$\alpha_5:=\alpha_3-\alpha_2\$" "p-value (\$\alpha_5=0\$)")) ///
nonotes substitute(\_ _)

