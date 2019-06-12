**************************************************************************************************
*        Title: 1_SummaryIAT.do
*                       Input: "$data/4_teacher_questionnaire.dta"
*            			Output: 
*       
*                                                           User: Michela Carlana
*                                                            Created: 5/04/2017
*                                                           Modified: 12/02/2019
*
* Description:
*************************************************************************************************** 

use "$data/survey_Carlana2019_QJE.dta",clear

*********************************************************************************
* Figure 1
***************************************************************************************************

twoway (kdensity d_score_gender if mate==1 & women==1, color(red))(kdensity d_score_gender if mate==1 & women==0,color(blue)), title("Math Teacher") legend(order(1 "Female" 2 "Male")) ytitle("kdensity d-score Gender IAT") xtitle("") yscale(range(0 1.1)) ylabel(0(0.2)1.1) note("Female 430 obs, Male 104 obs.")
graph copy mate, replace
twoway (kdensity d_score_gender if mate==0 & women==1, color(red))(kdensity d_score_gender if mate==0 & women==0,color(blue)), title("Literature Teacher") legend(order(1 "Female" 2 "Male")) ytitle("kdensity d-score Gender IAT") xtitle("") yscale(range(0 1.1)) ylabel(0(0.2)1.1) note("Female 745 obs, Male 99 obs.")
graph copy ita, replace
graph combine mate ita, cols(2)  ysize(3) xsize(4) title("Teachers' Gender Stereotypes by subject and gender")
graph export "$output/Summary_IAT/dscore_sub_gen.pdf", replace

*********************************************************************************
* Figure A.1
***************************************************************************************************

bys final_sample mate: sum d_score_gender 

ksmirnov d_score_gender if mate==1, by(final_sample) exact
ksmirnov d_score_gender if mate==0, by(final_sample) exact

twoway (kdensity d_score_gender if mate==1 & final_sample==1, color(red))(kdensity d_score_gender if mate==1 & final_sample==0,color(blue)), title("Math") legend(order(1 "Final sample" 2 "Not matched")) ytitle("kdensity Gender IAT") xtitle("") yscale(range(0 1.1)) ylabel(0(0.2)1.1) note("Matched 454 obs, Not matched 80 obs.""Exact p-value of Kolmogorov-Smirnov:0.590")
graph copy mate, replace
twoway (kdensity d_score_gender if mate==0 & final_sample==1, color(red))(kdensity d_score_gender if mate==0 & final_sample==0,color(blue)), title("Literature") legend(order(1 "Final sample" 2 "Not matched")) ytitle("kdensity Gender IAT") xtitle("") yscale(range(0 1.1)) ylabel(0(0.2)1.1) note("Matched 615 obs, Not matched 229 obs.""Exact p-value of Kolmogorov-Smirnov:0.466")
graph copy ita, replace

graph combine mate ita, cols(2)  ysize(3) xsize(4) title("Teachers' Gender Stereotypes by subject")
graph export "$output/Summary_IAT/dscore_match.pdf", replace


*********************************************************************************
* Table 1
***************************************************************************************************

preserve
keep if final_sample==1
estpost tabstat women t_N t_age figli D26_a D26_c mate_mate lode olympics low_edu_mother med_edu_mother high_edu_mother full_contract t_exp refresher d_score_gender explicit  wvs  if mate==1 & final_sample==1, statistics (count mean sd min max) columns (statistics)
esttab using "$output/Summary_IAT/Summary_stats_teachers_mat.tex", c("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") nonumber label title (Summary Statistics from Math Teachers' Questionnaire) addnotes ("First-hand data.")replace

estpost tabstat women t_N t_age figli D26_a D26_c low_edu_mother med_edu_mother high_edu_mother full_contract t_exp refresher d_score_gender explicit  wvs   if mate==0 & final_sample==1, statistics (count mean sd min max) columns (statistics)
esttab using "$output/Summary_IAT/Summary_stats_teachers_ita.tex", c("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") nonumber label title (Summary Statistics from Italian Teachers' Questionnaire) addnotes ("First-hand data.")replace
restore


*********************************************************************************
* Table A.II
***************************************************************************************************

balancetable final_sample women t_N t_age figli D26_a D26_c mate_mate lode olympics low_edu_mother med_edu_mother high_edu_mother full_contract t_exp refresher d_score_gender explicit  wvs if mate==1 using $output/Summary_IAT/balance_table_math.tex,   varlabels stddiff replace  booktabs  ctitles( "Not in Final Sample" "Final Sample" "Diff." "Normalized Diff.")
balancetable final_sample women t_N t_age figli D26_a D26_c low_edu_mother med_edu_mother high_edu_mother full_contract t_exp refresher d_score_gender explicit  wvs  if mate==0 using $output/Summary_IAT/balance_table_ita.tex,   varlabels stddiff replace  booktabs  ctitles( "Not in Final Sample" "Final Sample" "Diff." "Normalized Diff.")

*********************************************************************************
* Table C.I
***************************************************************************************************

reg d_score_gender order1_gender mate, robust cluster(school)
est store uno0
reg d_score_gender prima_quest_poi_iat mate, robust cluster(school)
est store due0
reg d_score_gender ordercompatiblegender mate, robust cluster(school)
est store tre0
reg d_score_gender order1_gender prima_quest_poi_iat ordercompatiblegender mate, robust cluster(school)
est store quattro0
areg d_score_gender order1_gender prima_quest_poi_iat ordercompatiblegender mate, robust cluster(school) absorb(school)
est store cinque0


esttab uno0 due0 tre0 quattro0 cinque0  using "$output/Summary_IAT/IATorder2.tex", /*
*/ label title (Correlation between order of IAT a IAT d-score for Math teachers \label{d1}) replace booktabs /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3))

*************************************************************************************************** 
******* Generate other variables ************************************************************************
gen right_job2=-right_job+2
gen figli_miss=(D26_a==.)

* experience *
gen t_exp_miss=(t_exp==.)
gen low_t_exp=(t_exp<6 & t_exp!=.)
gen med_t_exp=(t_exp<16 & t_exp>5& t_exp!=.)
gen high_t_exp=(t_exp>15 & t_exp!=.)
gen t_age2= t_age^2

foreach var in t_age {
gen `var'_miss=(`var'==.)
replace `var'=0 if `var'==.
}

foreach var in t_N wvs explicit mate_mate lode full_contract olympics t_age2{
replace `var'=0 if `var'==.
}


replace tasso_attivita_fem2016= tasso_attivita_fem2016/100
gen medhigh_edu_mother=med_edu_mother+high_edu_mother
gen t_edu_mother_miss=(medhigh_edu_mother==.)
replace medhigh_edu_mother=0 if medhigh_edu_mother==.
gen daughters=(D26_c>1 & D26_c!=.)
replace daughters= D26_c>0

lab var daughters "Daughters"

*************************************************************************************************** 
* TABLE 3
*************************************************************************************************** 
*Panel A
preserve
keep if final_sample==1
count
forvalues i=1(1)1{
reg d_score_gender women women_miss  $order_iat  if mate==`i', robust cluster(school_id) 
est store gender1`i'
reg d_score_gender t_age t_age2 t_age_miss $order_iat  if mate==`i', robust cluster(school_id) 
est store gender4`i'
reg d_score_gender medhigh_edu_mother t_edu_mother_miss $order_iat  if mate==`i', robust cluster(school_id) 
est store gender5`i'
reg d_score_gender figli figli_miss  $order_iat  if mate==`i', robust cluster(school_id)
est store gender6`i'
reg d_score_gender daughter figli_miss  $order_iat  if mate==`i', robust cluster(school_id) 
est store gender7`i'

esttab  gender1`i'  gender4`i' gender5`i' gender6`i' gender7`i' using "$output/Summary_IAT/Characteristics_backgroundfe`i'.tex", /*
*/ wide label title (Correlation between teachers' characteristics and Gender IAT Score \label{Characteristics}) replace booktabs /*
*/ indicate(Missing categories = $order_iat   t_edu_mother_miss women_miss  t_age_miss figli_miss) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at school level in parentheses.")
}
restore


*Panel B

preserve
keep if final_sample==1
count
forvalues i=1(1)1{
reg d_score_gender t_N t_N_miss  $order_iat  if mate==`i', robust cluster(school_id) 
est store gender0`i'
reg d_score_gender tasso_attivita_fem2016 $order_iat  if mate==`i', robust cluster(school_id) 
est store gender1`i'
reg d_score_gender right_job2 $order_iat  if mate==`i', robust cluster(school_id) 
est store gender2`i'
reg d_score_gender wvs wvs_miss $order_iat  if mate==`i', robust cluster(school_id) 
est store gender3`i'
reg d_score_gender explicit explicit_miss $order_iat  if mate==`i', robust cluster(school_id) 
est store gender4`i'
esttab  gender0`i' gender1`i' gender2`i' gender3`i' gender4`i'  using "$output/Summary_IAT/Characteristics_wvsfe`i'.tex", /*
*/ wide label title (Correlation between teachers' characteristics and Gender IAT Score \label{Characteristics}) replace booktabs /*
*/ indicate(Missing categories = $order_iat wvs_miss  explicit_miss  ) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at school level in parentheses.")
}
restore

*Panel C

preserve
keep if final_sample==1 
count
forvalues i=1(1)1{
reg d_score_gender mate_mate mate_mate_miss  $order_iat  if mate==`i', robust cluster(school_id) 
est store gender1`i'
reg d_score_gender lode lode_miss  $order_iat  if mate==`i', robust cluster(school_id) 
est store gender2`i'
reg d_score_gender full_contract full_contract_miss $order_iat  if mate==`i', robust cluster(school_id) 
est store gender3`i'
reg d_score_gender olympics olympics_miss  if mate==`i', robust cluster(school_id) absorb(school_id) 
est store gender4`i'
reg d_score_gender high_t_exp med_t_exp t_exp_miss $order_iat  if mate==`i', robust cluster(school_id) 
est store gender5`i'

esttab  gender1`i' gender2`i' gender3`i' gender4`i' gender5`i'  using "$output/Summary_IAT/Characteristics_schoolfe`i'.tex", /*
*/ wide label title (Correlation between teachers' characteristics and Gender IAT Score \label{Characteristics}) replace booktabs /*
*/ indicate(Missing categories = $order_iat  mate_mate_miss lode_miss full_contract_miss  olympics_miss t_exp_miss) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at school level in parentheses.")
}
restore

**************************************************************************************
* TABLE A.IV
**************************************************************************************
forvalues i=0(1)1{

reg d_score_gender  women women_miss t_N t_N_miss t_age t_age2 t_age_miss medhigh_edu_mother t_edu_mother_miss figli daughters mate_mate mate_mate_miss lode lode_miss full_contract full_contract_miss olympics olympics_miss  high_t_exp med_t_exp t_exp_miss wvs wvs_miss  explicit explicit_miss  $order_iat  if mate==`i' & final_sample==1, robust cluster(school_id) 
est store gender1`i'

reg d_score_gender  women women_miss t_N t_N_miss t_age t_age2 t_age_miss medhigh_edu_mother t_edu_mother_miss figli daughters mate_mate mate_mate_miss lode lode_miss full_contract full_contract_miss olympics olympics_miss  high_t_exp med_t_exp t_exp_miss   wvs wvs_miss  explicit explicit_miss  $order_iat  if mate==`i', robust cluster(school_id) 
est store gender3`i'

}
esttab gender11  gender31  gender10  gender30  using "$output/Summary_IAT/Characteristics_all.tex", /*
*/ wide label title (Correlation between teachers' characteristics and Gender IAT Score \label{Characteristics`i'all}) replace booktabs /*
*/ indicate(Missing categories = $order_iat  t_edu_mother_miss women_miss t_N_miss  t_age_miss mate_mate_miss lode_miss full_contract_miss  olympics_miss  wvs_miss explicit_miss) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at school level in parentheses.")

