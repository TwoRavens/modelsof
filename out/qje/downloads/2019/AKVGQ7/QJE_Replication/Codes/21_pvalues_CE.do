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

reg Z_ScoreFocal_T3 ${treatmentlist}  i.DistID $studentcontrol $schoolcontrol $HHcontrol, vce(cluster SchoolID) 
reg Z_ScoreFocal_T7 ${treatmentlist}  i.DistID $studentcontrol $schoolcontrol $HHcontrol, vce(cluster SchoolID) 
test (_b[TreatmentBoth] -1.03*_b[TreatmentCG]=0)
test (_b[TreatmentBoth] -3.46*_b[TreatmentCOD]=0)
test (_b[TreatmentBoth] - 1.117*_b[TreatmentCOD]-_b[TreatmentCG]=0)
test (1.035*_b[TreatmentBoth] - _b[TreatmentCOD]-_b[TreatmentCG]=0)
