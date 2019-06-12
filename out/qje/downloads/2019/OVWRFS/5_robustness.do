
*************************************************************************************************** 
* FIGURE A.V /PANEL A
*************************************************************************************************** 

use "$data/survey_Carlana2019_QJE.dta",clear 
keep teacher_id
forvalues i=1(1)1000{
gen stereotype`i'=rnormal(0,1)
}
keep teacher_id stereotype*
save "$trash/survey_permutation.dta", replace


use "$data/dataset_Carlana2019_QJE",clear
rename INS_MAT8 teacher_id
merge m:1 teacher_id using "$trash/survey_permutation.dta"
rename  teacher_id INS_MAT8

forvalues i=1(1)1000{
gen fem_stereotype`i'=female*stereotype`i'

areg stdinvalsi_mat8 female fem_stereotype`i' , absorb(classe8_final) robust cluster(INS_MAT8)


preserve
areg stdinvalsi_mat8 female fem_stereotype`i', absorb(classe8_final) robust cluster(INS_MAT8)
parmest, norestore  saving( "$output/permutation`i'.dta")
keep if parm=="fem_stereotype`i'"
save "$output/permutation`i'.dta", replace
restore
}

use "$output/permutation1.dta", clear
forvalues i=2(1)1000{
append using  "$output/permutation`i'.dta"
}


histogram estimate, frequency color(navy) lcolor(black) bin(20) xline(-0.032) title( Permutation Test) xtitle(Estimate: Fem*Stereotype Math Teacher)
graph save "$output/Robustness/permutation.gph",replace
graph export "$output/Robustness/permutation.pdf",replace

save "$output/permutation.dta", replace

forvalues i=1(1)1000{
erase "$output/permutation`i'.dta"
}


*************************************************************************************************** 
* FIGURE A.V /PANEL B
*************************************************************************************************** 

use "$data/survey_Carlana2019_QJE.dta",clear
keep teacher_id
forvalues i=1(1)1000{
gen stereotype`i'=rnormal(0,1)
}
keep teacher_id stereotype*

save "$trash/survey_permutation.dta", replace


use "$data/dataset_Carlana2019_QJE",clear
rename INS_ITA8 teacher_id
merge m:1 teacher_id using "$trash/survey_permutation.dta"
rename  teacher_id INS_ITA8

forvalues i=1(1)1000{
gen fem_stereotype`i'=female*stereotype`i'

areg stdinvalsi_ita8 female fem_stereotype`i' , absorb(classe8_final) robust cluster(INS_ITA8)


preserve
areg stdinvalsi_ita8 female fem_stereotype`i', absorb(classe8_final) robust cluster(INS_ITA8)
parmest, norestore  saving( "$output/permutation`i'.dta")
keep if parm=="fem_stereotype`i'"
save "$output/permutation`i'.dta", replace
restore
}

use "$output/permutation1.dta", clear
forvalues i=2(1)1000{
append using  "$output/permutation`i'.dta"
}


histogram estimate, frequency color(navy) lcolor(black) bin(20) xline(-0.012) title( Permutation Test) xtitle(Estimate: Fem*Stereotype Math Teacher)
graph save "$output/Robustness/permutation_literature.gph",replace
graph export "$output/Robustness/permutation_literature.pdf",replace

save "$output/permutation_literature.dta", replace

forvalues i=1(1)1000{
erase "$output/permutation`i'.dta"
}


*************************************************************************************************** 
* TABLE A.12
*************************************************************************************************** 
use "$data/dataset_Carlana2019_QJE",clear

keep if not_random_one==0 //This variable assumes value 1 for all school/cohorts for which at least one of the Pearson_chi_squared with all students characteristics by gender fail.

foreach var in  stdinvalsi_mat8   {
areg `var' female   if stereotype_mat!=. , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'1
areg `var' female fem_stereotype_mat , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'2
areg `var' female fem_stereotype_mat  $stud_controls0 , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'3
areg `var' female fem_stereotype_mat  $stud_controls , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'4
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'5

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/Robustness/`var'_robustness.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

}


foreach var in stdinvalsi_ita8 {
areg `var' female if stereotype_ita!=. , absorb(classe8_final) robust cluster(INS_ITA8)
est store `var'1
areg `var' female fem_stereotype_ita  , absorb(classe8_final) robust cluster(INS_ITA8)
est store `var'2
areg `var' female fem_stereotype_ita  $stud_controls0 , absorb(classe8_final) robust cluster(INS_ITA8)
est store `var'3
areg `var' female fem_stereotype_ita  $stud_controls , absorb(classe8_final) robust cluster(INS_ITA8)
est store `var'4
areg `var' female fem_stereotype_ita   $stud_controls $tech_controls_ita $teach_addcontrols_ita, absorb(classe8_final) robust cluster(INS_ITA8)
est store `var'5

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/Robustness/`var'_robustness.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}

