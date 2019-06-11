
**************************************************************************************************
*        				Title: 2_gender_gap_class.do
*                       Input: "$definitivo/all_Miur_Invalsi_stud_teacher"
* 						Output: 
*       
*                                                           User: Michela Carlana
*                                                           Created: 20/03/2017
*                                                           Modified: 
*
* Description: create variables
* STUDENTS: female, immigrant, second_gen_imm,year_birth month_birth, codicealunnosidi complete_info_miur
* MAIN OUTPUT VARIABLES: scientifico, scientificoapp, consiglio_scientifico, invalsi_mat8, invalsi_ita8, voto_mat8, voto_ita8
* MAIN DEPENDENT VARIABLE:iat_gender_mat, iat_gender_ita,
* HETEROGENEOUS EFFECTS TEACHERS: teachers_years_mat, teachers_years_ita, teacher_female_mat, teacher_female_ita, t_exp_mat, t_exp_ita, t_N_mat, t_N_ita
* INDIVIDUAL CONTROLS:  invalsi_mat6, invalsi_ita6, voto_mat6, voto_ita6, voto_comp_8, voto_comp_6, voto_media6, voto_media8
* FE: scuola8, sezione8, anno8, classe8, scuola6, sezione6, anno6, classe6, INS_MAT6, INS_MAT8, INS_ITA6, INS_ITA8 cohort
* AGGREGATE CONTROLS: class_size8, class_size6, share_imm8, share_imm6, share_f6, share_f8, school_size8, school_size6
* OUTPUT VARIABLES FROM QUESTIONNAIRE TO STUDENTS IN 2014: f2_u f3_c f4_alt f3_m f2_lavorare f2_apprendistato f2_diploma f2_universita f3_capacita f3_motivazioni f3_famiglia f3_altre_persone f3_stato_italiano f4_disponibilita_economiche f4_idee_della_famiglia f4_pregiudizi_non_italiano f4_progetti_familiari f4_non_sentirsi_all_altezza
* HETEROGENEOUS EFFECTS STUDENTS: educmotherI educmotherII educmotherIII educfatherI educfatherII educfatherIII
***************************************************************************************************
* Only few students are born in the south of Italy and then moved 
*************************************************************************************************** 
*global students "female immigrant second_gen_imm year_birth month_birth codicealunnosidi complete_info_miur educmotherI educmotherII educmotherIII educfatherI educfatherII educfatherIII"
global outcomes "stdinvalsi_mat8 stdinvalsi_ita8 choice_all scientifico prof consiglio_scientifico consiglio_prof  voto_mat8 voto_ita8 fail_medie_last confidence_other confidence_mat confidence_ita"
*global teachers "iat_gender_mat iat_gender_ita teachers_years_mat teachers_years_ita teacher_female_mat teacher_female_ita t_exp_mat t_exp_ita t_N_mat t_N_ita"
*global stud_controls "invalsi_mat6 invalsi_ita6 voto_mat6 voto_ita6 voto_comp8 voto_comp6 voto_media6 voto_media8 "
global fe "classe8_final INS_MAT8 INS_ITA8 cohort anno_scuola8"
*global class_controls "class_size8 class_size6 share_imm8 share_imm6 share_f6 share_f8 school_size8 school_size6"
*global quest_students "f2_lavorare f2_apprendistato f2_diploma f2_universita f3_capacita f3_motivazioni f3_famiglia f3_altre_persone f3_stato_italiano f4_disponibilita_economiche f4_idee_della_famiglia f4_pregiudizi_non_italiano f4_progetti_familiari f4_non_sentirsi_all_altezza"

global order_iat "ordercompatiblegender_mat order1_gender_mat  prima_quest_poi_iat_mat"
global tech_controls "teacher_female_mat fem_teacher_female_mat t_N_mat fem_t_N_mat mate_mate fem_mate_mate mate_mate_miss fem_mate_mate_miss t_N_mat_miss fem_t_N_mat_miss D18_b_mat fem_D18_b_mat  D18_b_miss_mat fem_D18_b_miss_mat figli_mat daughters_mat fem_figli_mat fem_daughters_mat figli_miss_mat fem_figli_miss_mat"
global teach_addcontrols "D17_1_mat D17_miss_mat fem_D17_mat fem_D17_miss_mat t_age_mat fem_t_age_mat t_age_miss_mat fem_t_age_miss_mat lode_mat fem_lode_mat lode_miss_mat fem_lode_miss_mat full_contract_mat fem_full_contract_mat full_contract_miss_mat fem_full_contract_miss_mat t_med_edum_mat t_high_edum_mat  fem_t_med_edum_mat fem_t_high_edum_mat t_edum_miss_mat fem_t_edum_miss_mat "
global tech_controls0 "teacher_female_mat t_N_mat mate_mate mate_mate_miss t_N_mat_miss D18_b_mat  D18_b_miss_mat figli_mat daughters_mat figli_miss_mat "
global teach_addcontrols0 "D17_1_mat D17_miss_mat t_age_mat t_age_miss_mat lode_mat lode_miss_mat full_contract_mat full_contract_miss_mat t_med_edum_mat t_high_edum_mat  t_edum_miss_mat "
global stud_controls "immigrant fem_immigrant second_gen_imm fem_second_gen_imm high_edu_mother fem_high_edu_mother miss_edu_mother fem_miss_edu_mother  fem_miss_occfather  med_occ_father fem_med_occ_father fem_high_occ_father miss_occfather high_occ_father"
global stud_controls0 "immigrant second_gen_imm high_edu_mother miss_edu_mother high_occ_father  med_occ_father miss_occfather" 

global order_iat_ita "ordercompatiblegender_ita order1_gender_ita  prima_quest_poi_iat_ita"
global tech_controls_ita "teacher_female_ita fem_teacher_female_ita t_N_ita fem_t_N_ita t_N_ita_miss fem_t_N_ita_miss figli_ita daughters_ita fem_figli_ita fem_daughters_ita figli_miss_ita fem_figli_miss_ita"
global teach_addcontrols_ita "D17_1_ita D17_miss_ita fem_D17_ita fem_D17_miss_ita t_age_ita fem_t_age_ita t_age_miss_ita fem_t_age_miss_ita lode_ita fem_lode_ita lode_miss_ita fem_lode_miss_ita full_contract_ita fem_full_contract_ita full_contract_miss_ita fem_full_contract_miss_ita t_med_edum_ita t_high_edum_ita  fem_t_med_edum_ita fem_t_high_edum_ita t_edum_miss_ita fem_t_edum_miss_ita "
global tech_controls0_ita "teacher_female_ita  t_N_ita  t_N_ita_miss  figli_ita daughters_ita   figli_miss_ita "
global teach_addcontrols0_ita "D17_1_ita D17_miss_ita   t_age_ita  t_age_miss_ita  lode_ita  lode_miss_ita  full_contract_ita  full_contract_miss_ita  t_med_edum_ita t_high_edum_ita    t_edum_miss_ita  "

global representativeness "pi_G pi_B pi pi_G_ita pi_B_ita pi_ita"
global dependent "female stereotype_mat stereotype_ita  fem_stereotype_mat fem_stereotype_ita "
global heter "new_teacher invalsi_mat6 invalsi_ita6 D7bis_ita D7bis D7bis_ita_miss D7bis_miss"
*************************************************************************************************** 


use "$data/dataset_Carlana2019_QJE",clear


*************************************************************************************************** 
* FIGURE III
***************************************************************************************************
areg stdinvalsi_mat8   $stud_controls $tech_controls $teach_addcontrols, absorb(anno_scuola8) robust cluster(INS_MAT8)
predict test_hat, res

twoway  (lpolyci test_hat d_score_gender_mat) ,  by(female)  yline(0) title("Females") xtitle("Teacher Gender Bias (IAT)") ytitle("Math Test Score") yscale(range(-0.1 0.15)) ylabel(-0.1(0.05)0.15) legend(off)
graph export "$output/MainResults/Figure_distribution.pdf", replace

twoway  (lpolyci test_hat d_score_gender_mat)  ,  by(female)  scheme(s2mono) yline(0) title("Females") xtitle("Teacher Gender Bias (IAT)") ytitle("Math Test Score") yscale(range(-0.1 0.15)) ylabel(-0.1(0.05)0.15) legend(off)
graph export "$output/MainResults/Figure_distribution.eps", replace



*************************************************************************************************** 
* TABLE II
*************************************************************************************************** 
balancetable female stdinvalsi_mat8 stdinvalsi_ita8 scientifico classico altrilicei tecnologico economico prof consiglio_scientifico consiglio_prof confidence_all confidence_mat confidence_ita stdinvalsi_mat6 stdinvalsi_ita6 $stud_controls0 using $output/MainResults/balance_table_students.tex if stereotype_mat!=. & stdinvalsi_mat8!=.,   varlabels stddiff replace  booktabs vce(cluster INS_MAT8) ctitles( "Males" "Females" "Diff." "Norm. Diff.")


*************************************************************************************************** 
* TABLE IV
*************************************************************************************************** 
*Panel A
foreach var in stereotype_mat{
areg `var' female $order_iat  if stereotype_mat!=.  & stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'0

areg `var' female high_edu_mother fem_high_edu_mother miss_edu_mother fem_miss_edu_mother  $order_iat if stereotype_mat!=. & stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'1

areg `var' female  med_occ_father fem_med_occ_father high_occ_father fem_high_occ_father miss_occfather fem_miss_occfather  $order_iat  if stereotype_mat!=. & stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'2

areg `var' female fem_immigrant immigrant $order_iat if stereotype_mat!=. & stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'3

areg `var' female med_occ_father fem_med_occ_father high_occ_father fem_high_occ_father miss_occfather fem_miss_occfather high_edu_mother fem_high_edu_mother miss_edu_mother fem_miss_edu_mother   fem_immigrant immigrant $order_iat if stereotype_mat!=. & stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'4
test (female=0) (med_occ_father=0) (fem_med_occ_father=0) (high_occ_father=0) (fem_high_occ_father=0) (miss_occfather=0) (fem_miss_occfather=0) (high_edu_mother=0) (fem_high_edu_mother=0) (miss_edu_mother=0) (fem_miss_edu_mother=0) (fem_immigrant=0) (immigrant=0)


}
esttab  stereotype_mat0  stereotype_mat1   stereotype_mat2 stereotype_mat3 stereotype_mat4     using "$output/MainResults/Exogeneity_mat.tex", /*
*/ label title (Exogeneity of assignment of students to teachers with different stereotypes) replace booktabs /*
*/ nonotes nomtitles mgroups( "Math Teachers", pattern(1 0 0 0 0 0 0)  prefix(\multicolumn{7}{c}{) suffix(}) span e(\cmidrule(lr){2-8})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Teacher controls= $order_iat miss_edu_mother fem_miss_edu_mother miss_occfather fem_miss_occfather)


*Panel B
foreach var in stereotype_ita{
areg `var' female $order_iat_ita  if stereotype_ita!=.  & stdinvalsi_ita8!=., absorb(anno_scuola8) robust cluster(INS_ITA8)
est store `var'0
areg `var' female high_edu_mother fem_high_edu_mother miss_edu_mother fem_miss_edu_mother  $order_iat_ita if stereotype_ita!=. & stdinvalsi_ita8!=., absorb(anno_scuola8) robust cluster(INS_ITA8)
est store `var'1
areg `var' female  med_occ_father fem_med_occ_father high_occ_father fem_high_occ_father miss_occfather fem_miss_occfather  $order_iat_ita  if stereotype_ita!=. & stdinvalsi_ita8!=., absorb(anno_scuola8) robust cluster(INS_ITA8)
est store `var'2
areg `var' female fem_immigrant immigrant $order_iat_ita if stereotype_ita!=. & stdinvalsi_ita8!=., absorb(anno_scuola8) robust cluster(INS_ITA8)
est store `var'3
areg `var' female med_occ_father fem_med_occ_father high_occ_father fem_high_occ_father miss_occfather fem_miss_occfather high_edu_mother fem_high_edu_mother miss_edu_mother fem_miss_edu_mother   fem_immigrant immigrant $order_iat_ita if stereotype_ita!=. & stdinvalsi_ita8!=., absorb(anno_scuola8) robust cluster(INS_ITA8)
est store `var'4

test (female=0) (med_occ_father=0) (fem_med_occ_father=0) (high_occ_father=0) (fem_high_occ_father=0)  (high_edu_mother=0) (fem_high_edu_mother=0) (miss_edu_mother=0) (fem_miss_edu_mother=0) (fem_immigrant=0) (immigrant=0)

}

esttab stereotype_ita0 stereotype_ita1  stereotype_ita2  stereotype_ita3 stereotype_ita4   using "$output/MainResults/Exogeneity_ita.tex", /*
*/ label title (Exogeneity of assignment of students to teachers with different stereotypes) replace booktabs /*
*/ nonotes nomtitles mgroups( "Italian Teachers", pattern(1 0 0 0 0 0 0)  prefix(\multicolumn{7}{c}{) suffix(}) span e(\cmidrule(lr){2-8})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Teacher controls= $order_iat_ita miss_edu_mother fem_miss_edu_mother miss_occfather fem_miss_occfather)



*************************************************************************************************** 
* TABLE V
**************************************************************************************************

*Panel A
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

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/MainResults/`var'.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls $teach_addcontrols) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

}

*Panel B
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

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/MainResults/`var'.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls $teach_addcontrols_ita) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}

*************************************************************************************************** 
* TABLE VI
**************************************************************************************************
*Panel A

foreach var in  stdinvalsi_mat8   {
areg `var' female   if stereotype_mat!=. , absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'1
areg `var' female fem_stereotype_mat stereotype_mat  , absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'2
areg `var' female fem_stereotype_mat stereotype_mat  $stud_controls0 , absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'3
areg `var' female fem_stereotype_mat stereotype_mat  $stud_controls , absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'4
areg `var' female fem_stereotype_mat stereotype_mat   $stud_controls $tech_controls $teach_addcontrols, absorb(anno_scuola8) robust cluster(INS_MAT8)
est store `var'5

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/MainResults/`var'_school.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}

*************************************************************************************************** 
* TABLE VII // need to run feologit_buc2 program before! 
*************************************************************************************************** 

gen stdinvalsi_mat62=stdinvalsi_mat6^2
gen stdinvalsi_ita62=stdinvalsi_ita6^2
gen stdinvalsi_ita82=stdinvalsi_ita8^2
gen stdinvalsi_mat82=stdinvalsi_mat8^2



feologit_buc2 classe8_f choice female if stereotype_mat!=.

feologit_buc2 classe8_f choice female fem_stereotype_mat

*est sto c3
feologit_buc2 classe8_f choice female fem_stereotype_mat $stud_controls0
*est sto c5
feologit_buc2 classe8_f choice female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols
*est sto c6
feologit_buc2 classe8_f choice female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols if stdinvalsi_mat8!=.
*
feologit_buc2 classe8_f choice female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols stdinvalsi_mat8 stdinvalsi_mat82
*
feologit_buc2 classe8_f choice female fem_stereotype_mat fem_stereotype_ita
*est sto c3
feologit_buc2 classe8_f choice female fem_stereotype_ita



* How to include fixed effects and adjust the standard errors
feologit_buc2 classe8_f reccomandation female if stereotype_mat!=.

feologit_buc2 classe8_f reccomandation female fem_stereotype_mat
*est sto c3
feologit_buc2 classe8_f reccomandation female fem_stereotype_mat $stud_controls0
*est sto c5
feologit_buc2 classe8_f reccomandation female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols
*est sto c6
feologit_buc2 classe8_f reccomandation female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols if stdinvalsi_mat8!=.
*
feologit_buc2 classe8_f reccomandation female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols stdinvalsi_mat8 stdinvalsi_mat82
*
feologit_buc2 classe8_f reccomandation female fem_stereotype_mat fem_stereotype_ita
*est sto c3
feologit_buc2 classe8_f reccomandation female fem_stereotype_ita


*************************************************************************************************** 
* TABLE VIII and IX
**************************************************************************************************
foreach var in  scientifico consiglio_scientifico consiglio_prof prof  {
areg `var' female   if stereotype_mat!=. , absorb(classe8_final) robust cluster(classe8_final)
est store `var'0
areg `var' female fem_stereotype_ita  , absorb(classe8_final) robust cluster(classe8_final)
est store `var'1
areg `var' female fem_stereotype_ita fem_stereotype_mat , absorb(classe8_final) robust cluster(classe8_final)
est store `var'2
areg `var' female fem_stereotype_mat  , absorb(classe8_final) robust cluster(classe8_final)
est store `var'3
areg `var' female fem_stereotype_mat   $stud_controls0 , absorb(classe8_final) robust cluster(classe8_final)
est store `var'4
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(classe8_final)
est store `var'5
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols if stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'6
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols stdinvalsi_mat8 stdinvalsi_mat82, absorb(classe8_final) robust cluster(classe8_final)
est store `var'7

esttab `var'0 `var'3 `var'4 `var'5 `var'6 `var'7 `var'2 `var'1  using "$output/MainResults/`var'.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "`var'" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}

*************************************************************************************************** 
* TABLE VIII and X
**************************************************************************************************


foreach var in      confidence_other confidence_mat{
areg `var' female   if stereotype_mat!=. & stdinvalsi_mat6!=. & stdinvalsi_mat8!=. , absorb(classe8_final) robust cluster(classe8_final)
est store `var'1
areg `var' female fem_stereotype_mat stdinvalsi_mat6 stdinvalsi_mat62 if stdinvalsi_mat6!=. & stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'2
areg `var' female fem_stereotype_mat  $stud_controls0 stdinvalsi_mat6 stdinvalsi_mat62 if stdinvalsi_mat6!=. & stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'3 
areg `var' female fem_stereotype_mat  $stud_controls stdinvalsi_mat6 stdinvalsi_mat62 if stdinvalsi_mat6!=. & stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'4
areg `var' female fem_stereotype_mat  $stud_controls stdinvalsi_mat6 stdinvalsi_mat62 stdinvalsi_mat8 stdinvalsi_mat82, absorb(classe8_final) robust cluster(classe8_final)
est store `var'5
areg `var' female fem_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols stdinvalsi_mat6 stdinvalsi_mat62 stdinvalsi_mat8 stdinvalsi_mat82, absorb(classe8_final) robust cluster(classe8_final)
est store `var'6
areg `var' female fem_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols stdinvalsi_mat6 stdinvalsi_mat62 stdinvalsi_mat8 stdinvalsi_mat82, absorb(classe8_final) robust cluster(classe8_final)
est store `var'6
areg `var' female fem_stereotype_mat fem_stereotype_ita  stdinvalsi_mat6 stdinvalsi_mat62  if stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'7
areg `var' female fem_stereotype_ita   stdinvalsi_mat6 stdinvalsi_mat62  if stdinvalsi_mat8!=. , absorb(classe8_final) robust cluster(classe8_final)
est store `var'8
esttab `var'1 `var'2 `var'3 `var'4 `var'5 `var'6 `var'7 `var'8 using "$output/MainResults/`var'.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}


foreach var in    confidence_ita  {
areg `var' female  if stdinvalsi_ita6!=. & stdinvalsi_ita8!=. & fem_stereotype_mat!=. , absorb(classe8_final) robust cluster(classe8_final)
est store `var'1
areg `var' female fem_stereotype_mat stdinvalsi_ita6 stdinvalsi_ita62 if stdinvalsi_ita6!=. & stdinvalsi_ita8!=. , absorb(classe8_final) robust cluster(classe8_final)
est store `var'2
areg `var' female fem_stereotype_mat  $stud_controls0 stdinvalsi_ita6 stdinvalsi_ita62  if stdinvalsi_ita6!=. & stdinvalsi_ita8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'3
areg `var' female fem_stereotype_mat  $stud_controls stdinvalsi_ita6 stdinvalsi_ita62 if stdinvalsi_ita6!=. & stdinvalsi_ita8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'4
areg `var' female fem_stereotype_mat  $stud_controls stdinvalsi_ita6 stdinvalsi_ita62 stdinvalsi_ita8 stdinvalsi_ita82 , absorb(classe8_final) robust cluster(classe8_final)
est store `var'5
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls_ita $teach_addcontrols_ita stdinvalsi_ita6  stdinvalsi_ita62 stdinvalsi_ita8 stdinvalsi_ita82, absorb(classe8_final) robust cluster(classe8_final)
est store `var'6
areg `var' female fem_stereotype_mat fem_stereotype_ita  stdinvalsi_ita6  stdinvalsi_ita62  if stdinvalsi_ita8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'7
areg `var' female fem_stereotype_ita  stdinvalsi_ita6  stdinvalsi_ita62   if stdinvalsi_ita8!=., absorb(classe8_final) robust cluster(classe8_final)
est store `var'8

esttab `var'1 `var'2 `var'3 `var'4 `var'5 `var'6 `var'7 `var'8 using "$output/MainResults/`var'.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Literature 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}


