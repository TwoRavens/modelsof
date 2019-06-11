use "$basein/Student_School_House_Teacher_Char.dta", clear
pca Z_kiswahili_T8  Z_kiingere~T8 Z_hisabati_T8
predict Z_ScoreFocal_T8,score

forvalues val=1/4{
	foreach var of varlist  Z_ScoreFocal_T8{
		qui sum `var' if GradeID_T7==`val' & treatarm==4
		qui replace `var'=(`var'-r(mean))/r(sd) if GradeID_T7==`val'
	}
}


gen TreatmentCOD2=TreatmentCOD
gen TreatmentBoth2=TreatmentBoth

label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"




*************************************************************
**************low-stakes**********************
*************************************************************

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
		eststo est_`var'_`time':   reg `var'_`time' ${treatmentlist}  i.DistID $studentcontrol $schoolcontrol $HHcontrol, vce(cluster SchoolID) 
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
esttab  using "$latexcodesfinals/RegTestScores.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber /// 
star(* 0.10 ** 0.05 *** 0.01) ///
replace  nomtitles nolines ///
keep(TreatmentCG TreatmentCOD TreatmentBoth) stats(N suma p suma2 p2, fmt(%9.0fc %9.2fc %9.2fc %9.2fc %9.2fc %9.2fc) labels("N. of obs." "\$\alpha_4:=\alpha_3-\alpha_2-\alpha_1\$" "p-value (\$\alpha_4=0\$)" "\$\alpha_5:=\alpha_3-\alpha_2\$" "p-value (\$\alpha_5=0\$)")) ///
nonotes substitute(\_ _)


*************************************************************
**************high-stakes**********************
*************************************************************

label var Z_kiswahili_T4 Kiswahili
label var Z_kiswahili_T8 Kiswahili
label var Z_kiingereza_T4 English
label var Z_kiingereza_T8 English
label var Z_hisabati_T4 Math
label var Z_hisabati_T8 Math
label var Z_ScoreFocal_T4 "Combined (PCA)"
label var Z_ScoreFocal_T8 "Combined (PCA)"

preserve

eststo clear
foreach time in  T4{
	foreach var in $AggregateDep_Karthik{
		eststo est_`var'_`time':   reg `var'_`time'  i.GradeID_`time'  i.DistID  $schoolcontrol , vce(cluster SchoolID) 
		estadd scalar p=.
		estadd scalar suma=.
		estadd scalar N=., replace
		sum `var'_`time' if treatment=="Control" | treatment=="COD"
		estadd scalar N2=.
		
	}
}

foreach time in  T8{
	foreach var in $AggregateDep_Karthik{
		eststo est_`var'_`time':   reg `var'_`time' ${treatmentlist_int} i.GradeID_`time'  i.DistID  $schoolcontrol , vce(cluster SchoolID) 
		estadd ysumm
		test (_b[TreatmentBoth] - _b[TreatmentCOD]=0)
		estadd scalar p=r(p)
		estadd scalar suma=_b[TreatmentBoth] - _b[TreatmentCOD]
		sum `var'_`time' if TreatmentCOD==1 & TreatmentBoth!=1
		estadd scalar N2=r(N)
		
		test (_b[TreatmentBoth] -3.45*_b[TreatmentCOD]=0)
		estadd scalar p5=r(p)
	}
}
restore
label var TreatmentCOD "Incentives (\$\beta_2\$)"
label var TreatmentCG "Grants (\$\beta_1\$)"
label var TreatmentBoth "Combination (\$\beta_3\$)"

esttab  using "$latexcodesfinals/RegTestScores_highstakes.tex", fragment se ar2 booktabs label b(%9.2fc)se(%9.2fc)nocon nonumber nolines /// 
cells (b(star fmt (%9.2fc) vacant(".")) se(par fmt(%9.2fc)) ) ///
star(* 0.10 ** 0.05 *** 0.01) collabels(none)  ///
replace  nomtitles ///
keep(TreatmentCOD TreatmentBoth) stats(N suma p, fmt(%9.0fc %9.2fc %9.2fc) labels("N. of obs." "\$\beta_5:=\beta_3-\beta_2\$" "p-value (\$\beta_5=0\$)" "")) ///
nonotes substitute(\_ _)


*************************************************************
**************Diff between high-and-low**********************
*************************************************************



eststo clear
foreach var in $AggregateDep_Karthik{
		capture drop resid_T3
		reg `var'_T3  i.DistID $studentcontrol $schoolcontrol $HHcontrol, vce(cluster SchoolID)
		predict resid_T3,resid
				
		preserve
		tempfile file1
		drop if e(sample)==0
		gen time=0
		rename resid_T3 resid
		keep resid SchoolID  $treatmentlist time
		save `file1'
		restore
		
		capture drop resid_T4
		reg `var'_T4  i.GradeID_T4  i.DistID  $schoolcontrol , vce(cluster SchoolID) 
		predict resid_T4,resid
		
		preserve
		tempfile file2
		drop if e(sample)==0
		gen time=1
		rename resid_T4 resid
		keep resid SchoolID  $treatmentlist_int time
		save `file2'
		restore
		
		preserve
		clear
		use `file1'
		append using `file2'
		replace TreatmentCG=0 if TreatmentCG==.
		rename TreatmentCG TreatmentCG2
		rename TreatmentCOD TreatmentCOD2
		rename TreatmentBoth TreatmentBoth2
		
		eststo `var'_yr1:  reg resid time, vce(cluster SchoolID)
		
		estadd scalar std_err1=.
		estadd scalar suma1=.
		
		
		estadd scalar std_err2=.
		estadd scalar suma2=.
		
		
		estadd scalar std_err3=.
		estadd scalar suma3=.
		restore
		
}



foreach var in $AggregateDep_Karthik{
		capture drop resid_T7
		reg `var'_T7  i.DistID $studentcontrol $schoolcontrol $HHcontrol, vce(cluster SchoolID)
		predict resid_T7,resid
		reg resid_T7	$treatmentlist		
		preserve
		tempfile file1
		drop if e(sample)==0
		gen time=0
		rename resid_T7 resid
		keep resid SchoolID  $treatmentlist time
		save `file1'
		restore
		reg `var'_T8 $treatmentlist_int i.GradeID_T8  i.DistID  $schoolcontrol , vce(cluster SchoolID) 
		capture drop resid_T8
		reg `var'_T8 i.GradeID_T8  i.DistID  $schoolcontrol , vce(cluster SchoolID) 
		predict resid_T8,resid
		
		preserve
		tempfile file2
		drop if e(sample)==0
		gen time=1
		rename resid_T8 resid
		keep resid SchoolID  $treatmentlist_int time
		save `file2'
		restore
		
		preserve
		clear
		use `file1'
		append using `file2'
		replace TreatmentCG=0 if TreatmentCG==.
		rename TreatmentCG TreatmentCG2
		rename TreatmentCOD TreatmentCOD2
		rename TreatmentBoth TreatmentBoth2
		
		eststo `var'_yr2:  reg resid c.(TreatmentCG2 TreatmentCOD2 TreatmentBoth2)##c.time, vce(cluster SchoolID)
		test (_b[c.TreatmentBoth2#c.time]=0)
		estadd scalar std_err1=r(p)
		estadd scalar suma1=(_b[c.TreatmentBoth2#c.time])
		
		test (_b[c.TreatmentCOD2#c.time]=0)
		estadd scalar std_err2=r(p)
		estadd scalar suma2=(_b[c.TreatmentCOD2#c.time])
		
		test (_b[TreatmentCG2]+_b[c.TreatmentBoth2#c.time]- _b[c.TreatmentCOD2#c.time]=0)
		estadd scalar std_err3=r(p)
		estadd scalar suma3=-(_b[TreatmentCG2]-_b[c.TreatmentBoth2#c.time]+ _b[c.TreatmentCOD2#c.time])
		
		test (_b[c.TreatmentBoth2#c.time]- _b[c.TreatmentCOD2#c.time]=0)
		estadd scalar std_err4=r(p)
		estadd scalar suma4=(_b[c.TreatmentBoth2#c.time]- _b[c.TreatmentCOD2#c.time])
		restore
		
}
label var TreatmentCOD "Incentives (\$\alpha_2\$)"
label var TreatmentCG "Grants (\$\alpha_1\$)"
label var TreatmentBoth "Combination (\$\alpha_3\$)"

esttab *_yr1 *_yr2 using "$latexcodesfinals/RegTestScores_Difference.tex", se ar2 label nonumb /// 
replace  b(%9.2fc)se(%9.2fc)nocon fragment nolines nogaps  nomtitles ///
star(* 0.10 ** 0.05 *** 0.01) ///
rename(c.TreatmentCOD2#c.time TreatmentCOD  c.TreatmentBoth2#c.time TreatmentBoth) keep( )  ///
coeflabel(treatmentCOD "Incentives \$(\beta_2-\alpha_2\$)"  TreatmentBoth "Combination \$(\beta_3-\alpha_3\$)") ///
stats( suma2 std_err2 suma1 std_err1  suma4 std_err4, fmt(%9.2fc %9.2fc %9.2fc %9.2fc %9.2fc %9.2fc %9.2fc %9.2fc) labels("\$\beta_2-\alpha_2\$" "p-value(\$\beta_2-\alpha_2=0 \$)" "\$\beta_3-\alpha_3\$" "p-value(\$\beta_3-\alpha_3=0\$)" "\$\beta_5-\alpha_5\$" "p-value(\$\beta_5-\alpha_5=0 \$)")) ///
nonotes substitute(\_ _)
