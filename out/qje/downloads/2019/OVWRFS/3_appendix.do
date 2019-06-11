

**************************************************************************************************
*        				Title: 2_gender_gap_class.do
*                       Input: "$data/dataset_Carlana2019_QJE"
* 						Output: 
*       
*                                                           User: Michela Carlana
*                                                           Created: 11/02/2019
*                                                           Modified: 
*
***************************************************************************************************
* Only few students are born in the south of Italy and then moved 
*************************************************************************************************** 
global outcomes "stdinvalsi_mat8 stdinvalsi_ita8 choice_all scientifico prof consiglio_scientifico consiglio_prof  voto_mat8 voto_ita8 fail_medie_last capacita_allother capacita_mate2_si capacita_ita2_si"
global fe "classe8_final INS_MAT8 INS_ITA8 cohort anno_scuola8"
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
global heter "new_teacher invalsi_mat6 invalsi_ita6 explicit_ita explicit_mat explicit_ita_miss explicit_mat_miss"
*************************************************************************************************** 


use "$data/dataset_Carlana2019_QJE",clear

gen stdinvalsi_mat62=stdinvalsi_mat6^2
gen stdinvalsi_ita62=stdinvalsi_ita6^2
gen stdinvalsi_ita82=stdinvalsi_ita8^2
gen stdinvalsi_mat82=stdinvalsi_mat8^2


*************************************************************************************************** 
* FIGURE A.II
*************************************************************************************************** 

sort invalsi_mat8
twoway (line pi invalsi_mat8,  yaxis(2) yscale(range(0.5 1.6) axis(2)))(kdensity invalsi_mat8 if female==1, sort yaxis(1) yscale(range(0 0.02) axis(1)) color(red*0.7) bwidth(4))(kdensity invalsi_mat8 if female==0, sort yaxis(1) yscale(range(0 0.02) axis(1)) color(blue*0.7) bwidth(4)), title("Math ") legend(order(1 "a" 2 "Female" 3 "Male")) ytitle("kdensity ") xtitle("")
graph copy mate, replace

sort invalsi_ita8
twoway (line pi_ita invalsi_ita8, yaxis(2) yscale(range(0.5 1.6) axis(2)))(kdensity invalsi_ita8 if female==1, yaxis(1) yscale(range(0 0.02) axis(1))color(red*0.7) bwidth(4))(kdensity invalsi_ita8 if female==0, yaxis(1) yscale(range(0 0.02) axis(1))color(blue*0.7) bwidth(4)), title("Reading") legend(order(1 "a" 2 "Female" 3 "Male")) ytitle("kdensity ") xtitle("")
graph copy ita, replace

graph combine mate ita, cols(2)  ysize(3) xsize(4) title("Test Score by gender")

***************************************************************************************************
* FIGURE A.VI
*************************************************************************************************** 

preserve

count
gen obs=1
collapse (mean) stdinvalsi_mat8 (sd) sdstdinvalsi_mat8=stdinvalsi_mat8 (sum) obs, by(choice_all)

foreach var in  stdinvalsi_mat8 {
generate up$_var = $_var + invttail(obs-1,0.05)*(sd$_var / sqrt(obs))
generate down$_var = $_var - invttail(obs-1,0.05)*(sd$_var / sqrt(obs))

*

twoway 	(bar `var' choice_all if choice_all==1, color(dknavy) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==2, color(dknavy*0.5) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==3, color(orange*0.4) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==4, color(orange*0.8) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==5, color(orange) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==6, color(red*0.5) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==7, color(red) lcolor(black)) ///
		(bar `var' choice_all  if choice_all==8, color(green*0.9) lcolor(black)) ///
      	(rcap up`var' down`var' choice_all), ///
        xlabel( 1 "Scientific" 2 "Classic" 3 "Linguistic" 4 "Psychology" 5 "Other Academic" 6 "Economic" 7 "Technical" 8 "Vocational", noticks angle(45)) ///
        xtitle("") title("Average Math Test Score in Grade 8 By High-School Track") legend(off) yscale(range(-0.6 1)) ylabel(-0.6(0.2)1)

graph save "$output/Figure_choice_test_`var'.gph",replace
graph export "$output/Figure_choice_test_`var'.pdf", replace
}

restore

/***************************************************************************************************
* FIGURE A.VII
*************************************************************************************************** 

preserve
drop if voto_mat8==.
replace voto_mat8= voto_mat8+0.2 if female==1
replace voto_mat8= voto_mat8-0.2 if female==0
tab voto_mat8 female, freq
twoway (histogram voto_mat8 if female==1, percent color(red*0.9) lcolor(black)) (histogram voto_mat8 if female==0, percent color(blue*0.9) lcolor(black)), xtitle("") title("Math") legend(on) xscale(range(4 10)) xlabel(4(1)10) legend(order(1 "Female" 2 "Male" ))
graph copy mat, replace
restore

preserve
drop if voto_ita8==.
replace voto_ita8= voto_ita8+0.2 if female==1
replace voto_ita8= voto_ita8-0.2 if female==0
tab voto_ita8 female, freq
twoway (histogram voto_ita8 if female==1, percent color(red*0.9) lcolor(black)) (histogram voto_ita8 if female==0, percent color(blue*0.9) lcolor(black)), xtitle("") title("Literature") legend(on) xscale(range(4 10)) xlabel(4(1)10) legend(order(1 "Female" 2 "Male" ))
graph copy ita, replace
restore

graph combine mat ita, title("Grades given by teachers")
graph export "$output/MainResults/Grades_by_gender.pdf", replace


*/************************************************************************************************** 
* TABLE A.III
*************************************************************************************************** 

reg stdinvalsi_mat8 female teacher_female_mat fem_teacher_female_mat   if stereotype_mat!=., cluster(INS_MAT8) robust
est store a
reg stdinvalsi_mat8 female lode_mat fem_lode_mat lode_miss_mat fem_lode_miss_mat    if stereotype_mat!=., cluster(INS_MAT8) robust
est store b
reg stdinvalsi_mat8 female mate_mate fem_mate_mate fem_mate_mate_miss mate_mate_miss  if stereotype_mat!=., cluster(INS_MAT8) robust
est store c
reg stdinvalsi_mat8 female D18_b_mat  fem_D18_b_mat  D18_b_miss_mat fem_D18_b_miss_mat   if stereotype_mat!=., cluster(INS_MAT8) robust
est store d
reg stdinvalsi_mat8 female full_contract_mat full_contract_miss_mat  fem_full_contract_mat fem_full_contract_miss_mat  if stereotype_mat!=., cluster(INS_MAT8) robust
est store e
reg stdinvalsi_mat8 female  high_t_exp_mat med_t_exp_mat t_exp_mat_miss fem_high_t_exp_mat fem_med_t_exp_mat fem_t_exp_mat_miss if stereotype_mat!=., cluster(INS_MAT8) robust
est store f 

areg stdinvalsi_mat8 female teacher_female_mat fem_teacher_female_mat   $stud_controls  if stereotype_mat!=., cluster(INS_MAT8) robust absorb(scuola8)
est store a2
areg stdinvalsi_mat8 female lode_mat fem_lode_mat lode_miss_mat fem_lode_miss_mat $stud_controls   if stereotype_mat!=., cluster(INS_MAT8) robust absorb(scuola8)
est store b2
areg stdinvalsi_mat8 female mate_mate fem_mate_mate fem_mate_mate_miss mate_mate_miss $stud_controls  if stereotype_mat!=., cluster(INS_MAT8) robust absorb(scuola8)
est store c2
areg stdinvalsi_mat8 female D18_b_mat  fem_D18_b_mat  D18_b_miss_mat fem_D18_b_miss_mat  $stud_controls   if stereotype_mat!=., cluster(INS_MAT8) robust absorb(scuola8)
est store d2
areg stdinvalsi_mat8 female full_contract_mat full_contract_miss_mat fem_full_contract_mat fem_full_contract_miss_mat  $stud_controls if stereotype_mat!=., cluster(INS_MAT8) robust absorb(scuola8)
est store e2
areg stdinvalsi_mat8 female  high_t_exp_mat med_t_exp_mat t_exp_mat_miss fem_high_t_exp_mat fem_med_t_exp_mat fem_t_exp_mat_miss $stud_controls   if stereotype_mat!=., cluster(INS_MAT8) robust absorb(scuola8)
est store f2

esttab  a a2  b b2  c c2   using "$output/MainResults/Teacher_qualityA.tex", /*
*/ label title (The impact of teacher characteristics on students' improvement in performance) replace booktabs /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ indicate(Indiv. Controls =  $stud_controls  ) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3))

esttab  d d2  e e2  f f2 using "$output/MainResults/Teacher_qualityB.tex", /*
*/ label title (The impact of teacher characteristics on students' improvement in performance) replace booktabs /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ indicate(Indiv. Controls =  $stud_controls  ) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) 

reg stdinvalsi_ita8 female teacher_female_ita fem_teacher_female_ita   if stereotype_ita!=., cluster(INS_ITA8) robust 
est store a
reg stdinvalsi_ita8 female full_contract_ita full_contract_miss_ita fem_full_contract_ita fem_full_contract_miss_ita if stereotype_ita!=., cluster(INS_ITA8) robust 
est store b
reg stdinvalsi_ita8 female high_t_exp_ita med_t_exp_ita t_exp_ita_miss fem_high_t_exp_ita fem_med_t_exp_ita fem_t_exp_ita_miss if stereotype_ita!=., cluster(INS_ITA8) robust 
est store c

areg stdinvalsi_ita8 female teacher_female_ita fem_teacher_female_ita   $stud_controls  if stereotype_ita!=., cluster(INS_ITA8) robust absorb(scuola8)
est store a2
areg stdinvalsi_ita8 female full_contract_ita full_contract_miss_ita fem_full_contract_ita fem_full_contract_miss_ita  $stud_controls if stereotype_ita!=., cluster(INS_ITA8) robust absorb(scuola8)
est store b2
areg stdinvalsi_ita8 female high_t_exp_ita med_t_exp_ita t_exp_ita_miss fem_high_t_exp_ita fem_med_t_exp_ita fem_t_exp_ita_miss   $stud_controls  if stereotype_ita!=., cluster(INS_ITA8) robust absorb(scuola8)
est store c2

esttab  a a2  b b2 c c2 using "$output/MainResults/Teacher_qualityC.tex", /*
*/ label title (The impact of teacher characteristics on students' improvement in performance) replace booktabs /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ indicate(Indiv. Controls =  $stud_controls  ) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) 


*************************************************************************************************** 
* TABLE A.V
***************************************************************************************************

preserve
bys INS_MAT8: egen share_fem=mean(female)
gen school_id=substr(INS_MAT8,1,3)
egen group_school_id =group(school_id) 
count
drop if stereotype_mat==.
collapse (mean) $order_iat $tech_controls0 $teach_addcontrols0      share_fem   stereotype_mat high_edu_mother miss_edu_mother high_occ_father med_occ_father miss_occfather immigrant    stdinvalsi_mat8  group_school_id, by(INS_MAT8 female)
reshape wide   high_edu_mother miss_edu_mother high_occ_father med_occ_father miss_occfather  stdinvalsi_mat8 immigrant   , i(INS_MAT8) j(female)

foreach var in high_edu_mother miss_edu_mother high_occ_father med_occ_father miss_occfather immigrant  {
replace `var'1=0 if `var'1==.
}

foreach var in stereotype_mat{
areg `var' share_fem $order_iat, robust cluster(group_school_id) absorb(group_school_id)
est store a
areg `var' share_fem high_edu_mother*  miss_edu_mother*   $order_iat, robust cluster(group_school_id) absorb(group_school_id)
est store b
areg `var' share_fem  med_occ_father* high_occ_father*  miss_occfather*   $order_iat , robust cluster(group_school_id) absorb(group_school_id)
est store e
areg `var' share_fem  immigrant* $order_iat , robust cluster(group_school_id) absorb(group_school_id)
est store f
areg `var' share_fem med_occ_father* high_occ_father*  miss_occfather*   high_edu_mother*  miss_edu_mother* immigrant* $order_iat, robust cluster(group_school_id) absorb(group_school_id)
est store g


esttab a b e f g using "$output/MainResults/Exogeneity_mat_class.tex", /*
*/ label title (Exogeneity of assignment of students to teachers with different stereotypes) replace booktabs /*
*/ nonotes nomtitles mgroups( "Math Teachers", pattern(1 0 0 0 0 0 0)  prefix(\multicolumn{7}{c}{) suffix(}) span e(\cmidrule(lr){2-8})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Teacher controls= $order_iat)
}
restore


preserve
bys INS_ITA8: egen share_fem=mean(female)
gen school_id=substr(INS_ITA8,1,3)
egen group_school_id =group(school_id)

drop if stdinvalsi_ita8==.
drop if stereotype_ita==.
count
collapse (mean) $order_iat_ita    share_fem   stereotype_ita high_edu_mother miss_edu_mother high_occ_father med_occ_father miss_occfather immigrant    stdinvalsi_mat8  group_school_id, by(INS_ITA8 female)
reshape wide high_edu_mother miss_edu_mother high_occ_father med_occ_father miss_occfather  stdinvalsi_mat8 immigrant   , i(INS_ITA8) j(female)

foreach var in high_edu_mother miss_edu_mother high_occ_father med_occ_father miss_occfather immigrant  {
replace `var'1=0 if `var'1==.
}

foreach var in stereotype_ita{
areg `var' share_fem $order_iat_ita, robust cluster(group_school_id) absorb(group_school_id)
est store a
areg `var' share_fem high_edu_mother*  miss_edu_mother*   $order_iat_ita, robust cluster(group_school_id) absorb(group_school_id)
est store b
areg `var' share_fem  med_occ_father* high_occ_father*  miss_occfather*   $order_iat_ita , robust cluster(group_school_id) absorb(group_school_id)
est store e
areg `var' share_fem  immigrant* $order_iat_ita , robust cluster(group_school_id) absorb(group_school_id)
est store f
areg `var' share_fem med_occ_father* high_occ_father*  miss_occfather*   high_edu_mother*  miss_edu_mother* immigrant* $order_iat_ita, robust cluster(group_school_id) absorb(group_school_id)
est store g


esttab a b e f g using "$output/MainResults/Exogeneity_ita_class.tex", /*
*/ label title (Exogeneity of assignment of students to teachers with different stereotypes) replace booktabs /*
*/ nonotes nomtitles mgroups( "Math Teachers", pattern(1 0 0 0 0 0 0)  prefix(\multicolumn{7}{c}{) suffix(}) span e(\cmidrule(lr){2-8})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Teacher controls= $order_iat_ita)
}
restore



*************************************************************************************************** 
* TABLE A.VI
*************************************************************************************************** 
gen stereotype_teacher_female_mat=stereotype_mat*teacher_female_mat
gen fem_stereotype_teacfem_mat=stereotype_mat*teacher_female_mat*female

areg stdinvalsi_mat8 female fem_stereotype_mat  , absorb(classe8_f) robust cluster(INS_MAT8)
est store a
areg stdinvalsi_mat8 female fem_stereotype_mat   if teacher_female_mat==1, absorb(classe8_f) robust cluster(INS_MAT8)
est store b
areg stdinvalsi_mat8 female fem_stereotype_mat  if teacher_female_mat==0, absorb(classe8_f) robust cluster(INS_MAT8)
est store c
areg stdinvalsi_mat8 female fem_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols , absorb(classe8_f) robust cluster(INS_MAT8)
est store a2
areg stdinvalsi_mat8 female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols  if teacher_female_mat==1, absorb(classe8_f) robust cluster(INS_MAT8)
est store b2
areg stdinvalsi_mat8 female fem_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols  if teacher_female_mat==0, absorb(classe8_f) robust cluster(INS_MAT8)
est store c2

esttab a a2 b b2 c c2  using "$output/MainResults/Performance_gender_teacher_mat.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std reading 8th grade" , pattern(1 0 0 0 0 0 0 0 0) prefix(\multicolumn{9}{c}{) suffix(}) span e(\cmidrule(lr){2-10})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")


gen stereotype_teacher_female_ita=stereotype_ita*teacher_female_ita
gen fem_stereotype_teacfem_ita=stereotype_ita*teacher_female_ita*female

areg stdinvalsi_ita8 female fem_stereotype_ita  , absorb(classe8_f) robust cluster(INS_ITA8)
est store a
areg stdinvalsi_ita8 female fem_stereotype_ita   if teacher_female_ita==1, absorb(classe8_f) robust cluster(INS_ITA8)
est store b
areg stdinvalsi_ita8 female fem_stereotype_ita  if teacher_female_ita==0, absorb(classe8_f) robust cluster(INS_ITA8)
est store c
areg stdinvalsi_ita8 female fem_stereotype_ita   $stud_controls $tech_controls_ita $teach_addcontrols_ita , absorb(classe8_f) robust cluster(INS_ITA8)
est store a2
areg stdinvalsi_ita8 female fem_stereotype_ita  $stud_controls $tech_controls_ita $teach_addcontrols_ita  if teacher_female_ita==1, absorb(classe8_f) robust cluster(INS_ITA8)
est store b2
areg stdinvalsi_ita8 female fem_stereotype_ita   $stud_controls $tech_controls_ita $teach_addcontrols_ita  if teacher_female_ita==0, absorb(classe8_f) robust cluster(INS_ITA8)
est store c2

esttab a a2 b b2 c c2  using "$output/MainResults/Performance_gender_teacher_ita.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std reading 8th grade" , pattern(1 0 0 0 0 0 0 0 0) prefix(\multicolumn{9}{c}{) suffix(}) span e(\cmidrule(lr){2-10})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")


*************************************************************************************************** 
* TABLE A.VII
*************************************************************************************************** 

gen pro_girls=(d_score_gender_mat <-0.15)
gen no_bias=(d_score_gender_mat <0.15& d_score_gender_mat>-0.15)
gen pro_boys=(d_score_gender_mat>0.15)

gen proboys=(d_score_gender_mat>0 )

gen male=1-female
foreach var in pro_girls no_bias pro_boys proboys{
replace `var'=. if d_score_gender_mat ==.
gen fem_`var'=female*`var'
gen mal_`var'=male*`var'
}


foreach var in stdinvalsi_mat8  {
areg `var' female fem_no_bias fem_pro_boys  , absorb(classe8_f) robust cluster(INS_MAT8)
est store est0
areg `var' female fem_no_bias fem_pro_boys  $stud_controls, absorb(classe8_f) robust cluster(INS_MAT8)
est store est1
areg `var' female fem_no_bias fem_pro_boys   $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_f) robust cluster(INS_MAT8)
est store est2
areg `var' female fem_proboys  , absorb(classe8_f) robust cluster(INS_MAT8)
est store est3
areg `var' female fem_proboys   $stud_controls , absorb(classe8_f) robust cluster(INS_MAT8)
est store est4
areg `var' female fem_proboys   $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_f) robust cluster(INS_MAT8)
est store est5


esttab est3 est4 est5 est0 est1 est2  using "$output/MainResults/Performance_dummies_`var'.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0 0) prefix(\multicolumn{6}{c}{) suffix(}) span e(\cmidrule(lr){2-5})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls $tech_controls $teach_addcontrols) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

}


*************************************************************************************************** 
* TABLE A.VIII
*************************************************************************************************** 

foreach var in stdinvalsi_mat8  {
areg `var' female fem_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'0
areg `var' female fem_stereotype_mat fem_stereotype_mat_invalsimat6_3 fem_stereotype_mat_invalsimat6_2 fem_invalsimat6_3 fem_invalsimat6_2 stereotype_mat_invalsimat6_2 stereotype_mat_invalsimat6_3 invalsimat6_3 invalsimat6_2 $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'1
areg `var' female fem_stereotype_mat fem_highedu_stereotype_mat fem_missedu_stereotype_mat highedu_stereotype_mat missedu_stereotype_mat $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'2
areg `var' female fem_stereotype_mat fem_imm_stereotype_mat imm_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'3
areg `var' female fem_stereotype_mat fem_prolungato_stereotype_mat prolungato_stereotype_mat fem_prolungato prolungato $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'4
areg `var' female fem_stereotype_mat new_teacher fem_new fem_stereotype_mat_new stereotype_mat_new $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'5



esttab `var'0 `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/MainResults/Heterogeneous_`var'.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Individual Characteristics" "Interaction time with teacher" , pattern(1 0 0 0 1 0) prefix(\multicolumn{4}{c}{) suffix(}) span e(\cmidrule(lr){2-5}\cmidrule(lr){6-7})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Student Teacher Controls = $stud_controls $tech_controls $teach_addcontrols) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}


*************************************************************************************************** 
* TABLE A.IX
**************************************************************************************************
* Grade 6 - only for those students who had the same teacher in grade 6
preserve
drop if no6==1
foreach var in  stdinvalsi_mat6   {
areg `var' female fem_stereotype_mat stereotype_mat , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'2
areg `var' female fem_stereotype_mat  $stud_controls0 , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'3
areg `var' female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'5
}
restore


areg stdinvalsi_mat8 female fem_stereotype_mat  if new_teacher==1, absorb(classe8_final) robust cluster(INS_MAT8)
est store stdinvalsi_mat82
areg stdinvalsi_mat8 female fem_stereotype_mat $stud_controls0   if new_teacher==1, absorb(classe8_final) robust cluster(INS_MAT8)
est store stdinvalsi_mat83
areg stdinvalsi_mat8 female fem_stereotype_mat   $stud_controls $tech_controls $teach_addcontrols if new_teacher==1, absorb(classe8_final) robust cluster(INS_MAT8)
est store stdinvalsi_mat85

esttab stdinvalsi_mat62 stdinvalsi_mat63 stdinvalsi_mat65 stdinvalsi_mat82 stdinvalsi_mat83 stdinvalsi_mat85 using "$output/MainResults/stdinvalsi_6.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls $teach_addcontrols) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

*************************************************************************************************** 
* TABLE A.X
**************************************************************************************************

foreach var in  no_invalsi_mat8   {
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
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

}


foreach var in no_invalsi_ita8 {
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
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}


*************************************************************************************************** 
* TABLE A.XI
*************************************************************************************************** 

foreach var in stdinvalsi_mat8{
areg `var' female fem_stereotype_mat    $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store uno
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols if anno8=="_1617", absorb(classe8_final) robust cluster(INS_MAT8)
est store quattro
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols if anno8!="_1617", absorb(classe8_final) robust cluster(INS_MAT8)
est store sei
esttab uno sei quattro using "$output/MainResults/performancecohort.tex", label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "All" "First Cohort" "Second Cohort" "Third Cohort", pattern(1 1 1 1) prefix(\multicolumn{1}{c}{) suffix(}) span e(\cmidrule(lr){2})) cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls =  $stud_controls $tech_controls $teach_addcontrols) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}



*************************************************************************************************** 
* TABLE A.XIII
*************************************************************************************************** 
*Class FE- Italian teacher
foreach var in stdinvalsi_mat8 {
areg `var' female if stereotype_mat!=.  & stereotype_ita!=.  & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'0
areg `var' female fem_stereotype_ita   if stereotype_mat!=.  & stereotype_ita!=.  & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'2
areg `var' female fem_stereotype_ita fem_stereotype_mat    if stereotype_mat!=.  & stereotype_ita!=.  & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'3
areg `var' female fem_stereotype_ita fem_stereotype_mat    $stud_controls $tech_controls_ita $teach_addcontrols_ita if stereotype_mat!=.  & stereotype_ita!=. & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'4
}


*Class FE - Math teacher, Ita performance
foreach var in stdinvalsi_ita8 {
areg `var' female if stereotype_mat!=.  & stereotype_ita!=.  & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'0
areg `var' female fem_stereotype_mat if stereotype_mat!=.  & stereotype_ita!=.  & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'2
areg `var' female fem_stereotype_mat fem_stereotype_ita     if stereotype_mat!=.  & stereotype_ita!=. & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'3
areg `var' female fem_stereotype_mat fem_stereotype_ita     $stud_controls $tech_controls  $teach_addcontrols if stereotype_mat!=.  & stereotype_ita!=.  & stdinvalsi_mat8!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(classe8_f)
est store `var'4
}


esttab stdinvalsi_mat80 stdinvalsi_mat82 stdinvalsi_mat83 stdinvalsi_mat84 stdinvalsi_ita80  stdinvalsi_ita82 stdinvalsi_ita83  stdinvalsi_ita84 using "$output/MainResults/Performance_ita_mat.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std math 8th grade" "Std reading 8th grade" , pattern(1 0 0 1 0 0 ) prefix(\multicolumn{3}{c}{) suffix(}) span e(\cmidrule(lr){2-4}\cmidrule(lr){5-7})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls $tech_controls $tech_controls_ita ) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

*************************************************************************************************** 
* TABLE A.XIV
*************************************************************************************************** 
gen consiglio_prof_fem= consiglio_prof*female
gen consiglio_scientifico_fem=consiglio_scientifico*female

areg prof consiglio_prof consiglio_prof_fem female if stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store  a
areg prof consiglio_prof consiglio_prof_fem female stdinvalsi_mat8 stdinvalsi_mat82  , absorb(classe8_final) robust cluster(classe8_final)
est store  b
areg prof consiglio_prof consiglio_prof_fem female stdinvalsi_mat8 stdinvalsi_mat82 $stud_controls , absorb(classe8_final) robust cluster(classe8_final)
est store  b2
areg scientifico consiglio_scientifico consiglio_scientifico_fem female if stdinvalsi_mat8!=., absorb(classe8_final) robust cluster(classe8_final)
est store c
areg scientifico consiglio_scientifico consiglio_scientifico_fem female  stdinvalsi_mat8 stdinvalsi_mat82  , absorb(classe8_final) robust cluster(classe8_final)
est store d
areg scientifico consiglio_scientifico consiglio_scientifico_fem female  stdinvalsi_mat8 stdinvalsi_mat82 $stud_controls , absorb(classe8_final) robust cluster(classe8_final)
est store e


esttab a b b2 c d e  using "$output/MainResults/corr_racc_choice.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "`var'" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")


*************************************************************************************************** 
* TABLE A.XV and A.XVI
*************************************************************************************************** 


foreach var in   prof consiglio_prof scientifico    consiglio_scientifico     {
areg `var' female   if stereotype_mat!=. , absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'1
areg `var' female fem_stereotype_mat stereotype_mat  , absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'2
areg `var' female fem_stereotype_mat stereotype_mat  $stud_controls0 , absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'3
areg `var' female fem_stereotype_mat stereotype_mat  $stud_controls $tech_controls $teach_addcontrols, absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'4
areg `var' female fem_stereotype_mat stereotype_mat  $stud_controls $tech_controls $teach_addcontrols if stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'5
areg `var' female fem_stereotype_mat stereotype_mat  $stud_controls $tech_controls $teach_addcontrols stdinvalsi_mat8 stdinvalsi_mat82 if stdinvalsi_mat8!=., absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'6
areg `var' female fem_stereotype_mat stereotype_mat fem_stereotype_ita stereotype_ita  , absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'7
areg `var' female fem_stereotype_ita stereotype_ita  , absorb(anno_scuola8) robust cluster(classe8_final)
est store `var'8


esttab `var'1 `var'2 `var'3 `var'4 `var'5 `var'6 `var'7 `var'8 using "$output/MainResults/`var'_school.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}

*************************************************************************************************** 
* TABLE A.XVII
*************************************************************************************************** 
foreach var in explicit_mat explicit_ita explicit_mat_miss explicit_ita_miss {
gen fem_`var'=female*`var'
}
foreach var in explicit_mat  {
areg stdinvalsi_mat8 female fem_`var' fem_`var'_miss if stereotype_mat!=., absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'1
areg stdinvalsi_mat8 female fem_`var' fem_`var'_miss $stud_controls if stereotype_mat!=. , absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'2
areg stdinvalsi_mat8 female fem_`var' fem_`var'_miss  $stud_controls $tech_controls $teach_addcontrols if stereotype_mat!=. , absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'3
areg stdinvalsi_mat8 female fem_stereotype_mat  fem_`var' fem_`var'_miss  $stud_controls $tech_controls $teach_addcontrols , absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'4
}

foreach var in explicit_ita  {
areg stdinvalsi_ita8 female fem_`var' fem_`var'_miss if stereotype_ita!=., absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'1
areg stdinvalsi_ita8 female fem_`var' fem_`var'_miss $stud_controls if stereotype_ita!=., absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'2
areg stdinvalsi_ita8 female fem_`var' fem_`var'_miss  $stud_controls $tech_controls $teach_addcontrols if stereotype_ita!=., absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'3
areg stdinvalsi_ita8 female fem_stereotype_ita  fem_`var' fem_`var'_miss  $stud_controls $tech_controls_ita $teach_addcontrols_ita , absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'4
}

esttab explicit_mat1 explicit_mat2 explicit_mat3 explicit_mat4 explicit_ita1 explicit_ita2 explicit_ita3 explicit_ita4 using "$output/MainResults/explicit_bias.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0 0 0 0) prefix(\multicolumn{8}{c}{) suffix(}) span e(\cmidrule(lr){2-10})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls $tech_controls $teach_addcontrols) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")



/*************************************************************************************************** 
* TABLE A.XVIII
*************************************************************************************************** 
foreach var in voto_mat8 high_grade_mat{
areg `var' female stdinvalsi_mat8 stdinvalsi_mat82 if stereotype_mat!=. & stdinvalsi_mat8!=., absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'0
areg `var' female fem_stereotype_mat   $order_iat stdinvalsi_mat8 stdinvalsi_mat82 if stereotype_mat!=. & stdinvalsi_mat8!=. , absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'2
areg `var' female fem_stereotype_mat   $stud_controls $order_iat stdinvalsi_mat8 stdinvalsi_mat82 if stereotype_mat!=. & stdinvalsi_mat8!=. , absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'4
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols $order_iat stdinvalsi_mat8 stdinvalsi_mat82 if stereotype_mat!=.  & stdinvalsi_mat8!=., absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'5
areg `var' female fem_stereotype_mat  $stud_controls $tech_controls $teach_addcontrols $order_iat stdinvalsi_mat8 stdinvalsi_mat82 if stereotype_mat!=.  , absorb(classe8_f) robust cluster(INS_MAT8)
est store `var'6
}

esttab voto_mat80 voto_mat82  voto_mat85 voto_mat86 high_grade_mat0 high_grade_mat2  high_grade_mat5 high_grade_mat6 using "$output/MainResults/voto.tex", /*
*/ label title (Estimation of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0 0 0 0 0) prefix(\multicolumn{9}{c}{) suffix(}) span e(\cmidrule(lr){2-10})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

	
foreach var in voto_ita8 high_grade_ita{
areg `var' female stdinvalsi_ita8 stdinvalsi_ita82 if stereotype_ita!=. & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'0
areg `var' female fem_stereotype_ita stdinvalsi_ita8 stdinvalsi_ita82  $order_iat if stereotype_ita!=. & stdinvalsi_ita8!=. , absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'2
areg `var' female fem_stereotype_ita stdinvalsi_ita8 stdinvalsi_ita82  $stud_controls $order_iat if stereotype_ita!=. & stdinvalsi_ita8!=. , absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'4
areg `var' female fem_stereotype_ita stdinvalsi_ita8 stdinvalsi_ita82 $stud_controls $tech_controls_ita $teach_addcontrols_ita $order_iat if stereotype_ita!=.  & stdinvalsi_ita8!=., absorb(classe8_f) robust cluster(INS_ITA8)
est store `var'5

}

esttab voto_ita80 voto_ita82 voto_ita84 voto_ita85  high_grade_ita0 high_grade_ita2 high_grade_ita4 high_grade_ita5  using "$output/MainResults/voto_ita.tex", /*
*/ label title (Estiitaion of the effet of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std itah 8th grade" , pattern(1 0 0 0 0 0 0 0 0) prefix(\multicolumn{9}{c}{) suffix(}) span e(\cmidrule(lr){2-10})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

*/************************************************************************************************** 
* TABLE F.I
*************************************************************************************************** 
foreach var in  fail_medie_last   {
areg `var' female   if stereotype_mat!=. , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'1
areg `var' female fem_stereotype_mat, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'2
areg `var' female fem_stereotype_mat  $stud_controls0 , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'3
areg `var' female fem_stereotype_mat $stud_controls , absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'4
areg `var' female fem_stereotype_mat $stud_controls $tech_controls $teach_addcontrols, absorb(classe8_final) robust cluster(INS_MAT8)
est store `var'5

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/MainResults/`var'.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")

}

foreach var in fail_medie_last {
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

esttab `var'1 `var'2 `var'3 `var'4 `var'5 using "$output/MainResults/`var'_ita.tex", /*
*/ label title (Estimation of the effect of teachers' gender stereotypes \label{Table1}) replace booktabs /*
*/ nonotes nomtitles mgroups( "Std Math 8th grade" , pattern(1 0 0 0 0) prefix(\multicolumn{5}{c}{) suffix(}) span e(\cmidrule(lr){2-6})) /*
*/ cells(b(star label(Coef.) fmt(3)) se(label(SE) par fmt(3))) star(* 0.10 ** 0.05 *** 0.01) /*
*/ nogaps legend stats(N r2, labels (`"Obs."' `"\(R^{2}\)"') fmt(0 3)) /*
*/ indicate(Indiv. Controls = $stud_controls) /*
*/ addnotes("Robust Standard Errors clustered at teacher level in parentheses.")
}

