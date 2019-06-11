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


foreach var in kiswahili kiingereza hisabati{
	foreach time in 7 8{
		sum Z_`var'_T`time'
		gen Min`var'_T`time'=(Z_`var'_T`time'==r(min))*100 if !missing(Z_`var'_T`time')
		gen Max`var'_T`time'=(Z_`var'_T`time'==r(max))*100 if !missing(Z_`var'_T`time')
	}
}


label var Minkiswahili_T7 "Kiswahili low-stakes: Bottom-coded"
label var Minkiswahili_T8 "Kiswahili high-stakes: Bottom-coded"
label var Maxkiswahili_T7 "Kiswahili low-stakes: Top-coded"
label var Maxkiswahili_T8 "Kiswahili high-stakes: Top-coded"

label var Minkiingereza_T7 "English low-stakes: Bottom-coded"
label var Minkiingereza_T8 "English high-stakes: Bottom-coded"
label var Maxkiingereza_T7 "English low-stakes: Top-coded"
label var Maxkiingereza_T8 "English high-stakes: Top-coded"

label var Minhisabati_T7 "Math low-stakes: Bottom-coded"
label var Minhisabati_T8 "Math high-stakes: Bottom-coded"
label var Maxhisabati_T7 "Math low-stakes: Top-coded"
label var Maxhisabati_T8 "Math high-stakes: Top-coded"


eststo clear
estpost summarize  Minkiswahili_T7 Minkiswahili_T8 Maxkiswahili_T7 Maxkiswahili_T8 Minkiingereza_T7 Minkiingereza_T8 Maxkiingereza_T7 Maxkiingereza_T8 Minhisabati_T7 Minhisabati_T8 Maxhisabati_T7 Maxhisabati_T8
esttab using "$latexcodesfinals/TopBottomCoding.tex", cells("mean(fmt(%9.2fc))") nonumber fragment  replace  label    




