******* NOTE: AS NOTED IN THE PAPER, THE ACT DATA ARE PRORPRIETARY AND CANNOT BE SHARED. BELOW IS THE CODE THE PRODUCED OUR RESULTS. 

****** 2016 ANALYSIS

cd "" // File Pathway Here

insheet using "nextgen.csv",  clear

foreach var in q8 q9 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_11_text q10_12 q12 q13 q14 q15 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 q18 q19 q20 q21 q25 q22_1 q22_2 q22_3 q22_4 q22_5 q22_6 q22_7 q22_8 q22_9 q22_10 q22_11 q22_12 q22_12_text q24 q23 {
capture replace `var' = . if `var'==-99
}

*First Stage (should be 1: it is)
rdrobust voter count, c(0) all vce(cluster count)

*Precise Manipulation (in this application there is no statistical evidence of systematic manipulation of the running variable)
rddensity count, plot all //  
*hist count

keep if abs(count)<=365

egen sum=sum(1), by(count)
egen pop=sum(1)

gen share=(sum/pop)*100
drop sum pop
egen tag_grid=tag(count)
keep if tag_grid==1
gen D=(count>0)
gen count_2=count^2
gen count_3=count^3
gen count_4=count^4
gen Dcount=D*count
gen Dcount_2=D*count_2
gen Dcount_3=D*count_3
gen Dcount_4=D*count_4
tab share, m

regress share D count count_2 count_3 count_4 Dcount Dcount_2 Dcount_3 Dcount_4, hc3

 keep if  abs(count)<=120

 regress share D count count_2 count_3 count_4 Dcount Dcount_2 Dcount_3 Dcount_4, hc3
 
 rddensity count, plot all // 
 
 rdrobust share count, all
 
twoway (lpolyci share count  if count<0, bwidth(7) fintensity(inten10)  clcolor(black) )  ///
(lpolyci share count if  count>=0, bwidth(7) fintensity(inten10)  clcolor(black)) ///
(scatter share count if count<0, mcolor(black)  msymbol(circle))  ///
(scatter share count if count>=0, mcolor(black) mfcolor(none)  msymbol(circle)  xline(0, lpat(dash) lcol(red))) ///
, legend(off) graphregion(color(white)) ytitle("Density") xtitle("Age in days at election date (relative to 18 complete years)") ///
 xlabel(-120(20)120, grid) ylabel(0(0.1)1, grid) 

graph save "mccrary_ct_voluntary.gph", replace
  
***********************  
  
cd "" // File pathway

insheet using "nextgen.csv",  clear

foreach var in q8 q9 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_11_text q10_12 q12 q13 q14 q15 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 q18 q19 q20 q21 q25 q22_1 q22_2 q22_3 q22_4 q22_5 q22_6 q22_7 q22_8 q22_9 q22_10 q22_11 q22_12 q22_12_text q24 q23 {
capture replace `var' = . if `var'==-99
}

*Survey Taking 
gen white=1 if bg_race_ethnic==3
replace white=0 if bg_race_ethnic==1 | bg_race_ethnic==2 | bg_race_ethnic==4 | bg_race_ethnic==5 | bg_race_ethnic==6 | bg_race_ethnic==7 | bg_race_ethnic==8

gen female=1 if gender=="FEMALE"
replace female=0 if gender=="MALE"

replace hs_grad_year=2020 if hs_grad_year>=2021 & hs_grad_year~=.
replace hs_grad_year=2013 if hs_grad_year<=2013

foreach var in cgis_tp_ushistory cgis_tp_worldhistory cgis_tp_otherhistory cgis_tp_amgovernment cgis_tp_geography {
gen t_`var'=1 if `var'==1
replace t_`var'=0 if `var'==2 | `var'==3
}

gen took_adv_socs=hs_adv_socstd
replace took_adv_socs=0 if took_adv_socs==2
replace took_adv_socs=0 if took_adv_socs==.

replace hs_yrs_socstd=. if hs_yrs_socstd==9

gen overall_gpa_0_4=cgis_avg_ov23/100

gen public_school=1 if hs_pubpriv_ind==1
replace public_school=0 if hs_pubpriv_ind==2

egen num_missing=rowmiss(q8 q9 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q12 q13 q14 q15 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 q18 q19 q20 q21 q25 q22_1 q22_2 q22_3 q22_4 q22_5 q22_6 q22_7 q22_8 q22_9 q22_10 q22_11 q22_12 q24 q23)
gen prop_missing=num_missing/44

gen surveyed=1 if num_missing<=43 
replace surveyed=0 if surveyed==.

rdrobust surveyed count, c(0) all vce(cluster count) // survey taking
rdrobust prop_missing count, c(0) all vce(cluster count) // survey taking

*Summary Statistics
sum prop_missing white bg_mother_educ_lvl bg_father_educ_lvl family_income  female grade_classification ///
hs_grad_year hs_gpa  hs_rank  t_cgis_tp_ushistory t_cgis_tp_worldhistory t_cgis_tp_otherhistory ///
t_cgis_tp_amgovernment t_cgis_tp_geography cgis_ge_ushistory  cgis_ge_worldhistory cgis_ge_otherhistory ///
cgis_ge_amgovernment cgis_ge_geography  hs_enroll_size took_adv_socs hs_yrs_socstd overall_gpa_0_4 ///
public_school rptd_stdscn_c rptd_stdscn_e rptd_stdscn_m rptd_stdscn_r if surveyed==1

*Covariate Balance
rdrobust prop_missing count, c(0) all vce(cluster count) // survey taking
rdrobust white count, c(0) all vce(cluster count) // 
rdrobust bg_mother_educ_lvl count, c(0) all vce(cluster count) // 
rdrobust bg_father_educ_lvl count, c(0) all vce(cluster count) // 
rdrobust family_income count, c(0) all vce(cluster count) // 
rdrobust female count, c(0) all vce(cluster count) // 
rdrobust grade_classification count, c(0) all vce(cluster count) // current grade when taking the ACT
rdrobust hs_grad_year count, c(0) all vce(cluster count) // 
rdrobust hs_gpa count, c(0) all vce(cluster count) // 
rdrobust hs_rank count, c(0) all vce(cluster count) // looks like subjective evaluation of rank in high school
rdrobust t_cgis_tp_ushistory count, c(0) all vce(cluster count) // took these courses
rdrobust t_cgis_tp_worldhistory count, c(0) all vce(cluster count) // 
rdrobust t_cgis_tp_otherhistory count, c(0) all vce(cluster count) // 
rdrobust t_cgis_tp_amgovernment count, c(0) all vce(cluster count) // 
rdrobust t_cgis_tp_geography count, c(0) all vce(cluster count) // 
rdrobust cgis_ge_ushistory count, c(0) all vce(cluster count) // grades in these courses
rdrobust cgis_ge_worldhistory count, c(0) all vce(cluster count) // 
rdrobust cgis_ge_otherhistory count, c(0) all vce(cluster count) // 
rdrobust cgis_ge_amgovernment count, c(0) all vce(cluster count) // 
rdrobust cgis_ge_geography count, c(0) all vce(cluster count) // 
rdrobust hs_enroll_size count, c(0) all vce(cluster count) // 
rdrobust took_adv_socs count, c(0) all vce(cluster count) // took advanced social studies
rdrobust hs_yrs_socstd count, c(0) all vce(cluster count) // number of semesters taking social studies
 rdrobust overall_gpa_0_4 count, c(0) all vce(cluster count) // overall high school gpa
 rdrobust public_school count, c(0) all vce(cluster count) // high school currently enrolled is public
 rdrobust rptd_stdscn_c count, c(0) all vce(cluster count) // ACT score composite
 rdrobust rptd_stdscn_e count, c(0) all vce(cluster count) // ACT score english
 rdrobust rptd_stdscn_m count, c(0) all vce(cluster count) // ACT score math
 rdrobust rptd_stdscn_r count, c(0) all vce(cluster count) // ACT score reading

 *Joint Significance 
 gen D=(count>0)
gen count_2=count^2
gen count_3=count^3
gen count_4=count^4
gen Dcount=D*count
gen Dcount_2=D*count_2
gen Dcount_3=D*count_3
gen Dcount_4=D*count_4

regress  D count count_2 count_3 count_4 Dcount Dcount_2 Dcount_3 Dcount_4 /// 
prop_missing white bg_mother_educ_lvl bg_father_educ_lvl family_income  female grade_classification ///
hs_grad_year hs_gpa  hs_rank  t_cgis_tp_ushistory t_cgis_tp_worldhistory t_cgis_tp_otherhistory ///
t_cgis_tp_amgovernment t_cgis_tp_geography cgis_ge_ushistory  cgis_ge_worldhistory cgis_ge_otherhistory ///
cgis_ge_amgovernment cgis_ge_geography  hs_enroll_size took_adv_socs hs_yrs_socstd overall_gpa_0_4 ///
public_school rptd_stdscn_c rptd_stdscn_e rptd_stdscn_m rptd_stdscn_r, hc3

 
 test prop_missing white bg_mother_educ_lvl bg_father_educ_lvl family_income  female grade_classification ///
hs_grad_year hs_gpa  hs_rank  t_cgis_tp_ushistory t_cgis_tp_worldhistory t_cgis_tp_otherhistory ///
t_cgis_tp_amgovernment t_cgis_tp_geography cgis_ge_ushistory  cgis_ge_worldhistory cgis_ge_otherhistory ///
cgis_ge_amgovernment cgis_ge_geography  hs_enroll_size took_adv_socs hs_yrs_socstd overall_gpa_0_4 ///
public_school rptd_stdscn_c rptd_stdscn_e rptd_stdscn_m rptd_stdscn_r
 
 foreach var in prop_missing white bg_mother_educ_lvl bg_father_educ_lvl family_income  female grade_classification ///
hs_grad_year hs_gpa  hs_rank  t_cgis_tp_ushistory t_cgis_tp_worldhistory t_cgis_tp_otherhistory ///
t_cgis_tp_amgovernment t_cgis_tp_geography cgis_ge_ushistory  cgis_ge_worldhistory cgis_ge_otherhistory ///
cgis_ge_amgovernment cgis_ge_geography  hs_enroll_size took_adv_socs hs_yrs_socstd overall_gpa_0_4 ///
public_school rptd_stdscn_c rptd_stdscn_e rptd_stdscn_m rptd_stdscn_r {
 rdrobust `var' count, c(0) p(4) q(5) all vce(cluster count) 
}
 
 
 
*Individual Outcome Items 

foreach var in q8 q13 q19 q20 q21 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 {
 egen s__`var'=std(`var'), mean(0) std(1)
}

foreach var in q8 q13 q19 q20 q21 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 {
rdrobust s__`var' count, c(0) all vce(cluster count) // followed the news
	mat b =e(b)
	scalar r_`var'=b[1,3]
	scalar p_`var'=e(pv_rb)
	scalar se_`var'=e(se_tau_rb)	
	scalar cih_`var'=e(ci_r_rb)
	scalar cil_`var'=e(ci_l_rb)
}

foreach var in q8 q13 q19 q20 q21 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 { 
	scalar list r_`var'
	}

foreach var in q8 q13 q19 q20 q21 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 { 
	scalar list se_`var'
	}
	
foreach var in q8 q13 q19 q20 q21 q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12 q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7 {	
	scalar list p_`var'
	}		

rdrobust q8 count, c(0) all vce(cluster count) // followed the news
rdrobust q13 count, c(0) all vce(cluster count) // Leading up to the presidential election, how much thought did you give to it?
rdrobust q19 count, c(0) all vce(cluster count) //  How often did you discuss the election at home with family?
rdrobust q20 count, c(0) all vce(cluster count) // How often did you discuss the election in class at school?
rdrobust q21 count, c(0) all vce(cluster count) // How often did you discuss the election at school with friends?

rdrobust q10_1 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-National Newspapers (e.g., New York Times, Washington Post)
rdrobust q10_2 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Local Newspapers
rdrobust q10_3 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Network News (e.g., ABC, CBS, NBC)
rdrobust q10_4 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Cable News (e.g., CNN, FOX, MSNBC)
rdrobust q10_5 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Local TV News
rdrobust q10_6 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Radio
rdrobust q10_7 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-News Magazines (e.g., TIME, Newsweek, The Atlantic)
rdrobust q10_8 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Social Media (e.g., Facebook, Twitter)
rdrobust q10_9 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Discussion Boards (e.g., Reddit)
rdrobust q10_10 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Fact Check websites (e.g., FactCheck.org, PolitiFact)
rdrobust q10_11 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Other (please describe)
rdrobust q10_12 count, c(0) all vce(cluster count) // Which of the following sources did you use to find out information about the presidential candida...-Did not use any source

rdrobust q17_1 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Traditional
rdrobust q17_2 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Honor and duty are my core values
rdrobust q17_3 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Think of myself as a typical American
rdrobust q17_4 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Able to have a respectful discussion
rdrobust q17_5 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Open-minded
rdrobust q17_6 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Compassionate towards others
rdrobust q17_7 count, c(0) all vce(cluster count)  // Which of the following words or phrases describes you well? Choose all that apply.-Interested in visiting other countries

*Scale Diagnostics, Creation, and Analyses

*Political Knowledge
alpha q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q12
factor q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q12 
egen political_knowledge_mean= rowmean(q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q10_12) // q12 missing because on different scale

factor q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7 q10_8 q10_9 q10_10 q10_11 q12, factor(1)
predict political_knowledge
egen political_knowledge_std=std(political_knowledge), mean(0) std(1)

rdrobust political_knowledge count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge_mean count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge_std count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

sum political_knowledge if count>-115.926 & count<0

// non parametric
rd political_knowledge count, bw(115.926) mbw(100)

rdplot political_knowledge count, ci(95)  graph_options(xtitle("Proximity to Eligibility to Vote (Days)") ytitle("Political Knowledge") title("") xline(0, lcol("red") lpat("dash")))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy

graph save "political_knowledge.gph", replace
graph export "political_knowledge.pdf", replace

*Political Interest
alpha 	q8  q13 q19 q20 q21
factor q8  q13 q19 q20 q21
predict political_interest
egen political_interest_std=std(political_interest), mean(0) std(1)

egen political_interest_mean_1 = rowmean(q19 q20 q21) // discuss politics
egen political_interest_mean_2 = rowmean(q8  q13 ) // followed news, gave thought to the election in the lead up 

rdrobust political_interest count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest_mean_1 count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest_mean_2 count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest_std count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

sum political_interest if count>-115.926 & count<0

// non parametric
rd political_interest count, bw(115.926) mbw(100)


rdplot political_interest count, ci(95)  graph_options(xtitle("Proximity to Eligibility to Vote (Days)") ytitle("Political Interest") title("") xline(0, lcol("red") lpat("dash")))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy

graph save "political_interest.gph", replace
graph export "political_interest.pdf", replace


*Social Awareness
alpha q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7
factor q17_1 q17_2 q17_3 q17_4 q17_5 q17_6 q17_7

alpha q17_4 q17_5 q17_6 q17_7
factor q17_4 q17_5 q17_6 q17_7
predict social_awareness
egen social_awareness_std=std(social_awareness), mean(0) std(1)

egen social_awareness_mean=rowmean(q17_4 q17_5 q17_6 q17_7)

rdrobust social_awareness count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness_mean count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness_std count, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

sum social_awareness if count>-115.926 & count<0

// non parametric
rd social_awareness count, bw(115.926) mbw(100)


rdplot social_awareness count, ci(95)  graph_options(xtitle("Proximity to Eligibility to Vote (Days)") ytitle("Social Awareness") title("") xline(0, lcol("red") lpat("dash")))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy

graph save "social_awareness.gph", replace
graph export "social_awareness.pdf", replace

save "nextgen.dta", replace 

*** Bandwidths (linear)

use "nextgen.dta", clear

foreach var in political_knowledge political_interest social_awareness {
forvalues i=20(20)360 {
rdrobust `var' count, c(0) p(1) q(2)  h(`i')  vce(cluster count) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  political_knowledge { 
forvalues i=20(20)360 {	
scalar list r_`var'_`i'	
}
}

foreach var in  political_knowledge { 
forvalues i=20(20)360 {	
scalar list se_`var'_`i'	
}
}

foreach var in  political_knowledge { 
forvalues i=20(20)360 {	
scalar list p_`var'_`i'	
}
}

foreach var in  political_interest { 
forvalues i=20(20)360 {	
scalar list r_`var'_`i'	
}
}

foreach var in  political_interest { 
forvalues i=20(20)360 {	
scalar list se_`var'_`i'	
}
}

foreach var in  political_interest { 
forvalues i=20(20)360 {	
scalar list p_`var'_`i'	
}
}

foreach var in  social_awareness { 
forvalues i=20(20)360 {	
scalar list r_`var'_`i'	
}
}

foreach var in  social_awareness { 
forvalues i=20(20)360 {	
scalar list se_`var'_`i'	
}
}

foreach var in  social_awareness { 
forvalues i=20(20)360 {	
scalar list p_`var'_`i'	
}
}


*** Bandwidths (quartic)

use "nextgen.dta", clear

foreach var in political_knowledge political_interest social_awareness {
forvalues i=20(20)360 {
rdrobust `var' count, c(0) p(1) q(2)  h(`i')  vce(cluster count) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}


foreach var in  political_knowledge { 
forvalues i=20(20)360 {	
scalar list r_`var'_`i'	
}
}

foreach var in  political_knowledge { 
forvalues i=20(20)360 {	
scalar list se_`var'_`i'	
}
}

foreach var in  political_knowledge { 
forvalues i=20(20)360 {	
scalar list p_`var'_`i'	
}
}

foreach var in  political_interest { 
forvalues i=20(20)360 {	
scalar list r_`var'_`i'	
}
}

foreach var in  political_interest { 
forvalues i=20(20)360 {	
scalar list se_`var'_`i'	
}
}

foreach var in  political_interest { 
forvalues i=20(20)360 {	
scalar list p_`var'_`i'	
}
}

foreach var in  social_awareness { 
forvalues i=20(20)360 {	
scalar list r_`var'_`i'	
}
}

foreach var in  social_awareness { 
forvalues i=20(20)360 {	
scalar list se_`var'_`i'	
}
}

foreach var in  social_awareness { 
forvalues i=20(20)360 {	
scalar list p_`var'_`i'	
}
}


****************************** Nonparametric (for tables) *******************************

*CCT Optimal Bandwidths
use "nextgen.dta", clear 

rd political_knowledge  count, bw(49.41)  
rd political_interest  count, bw(32.42)  
rd social_awareness  count, bw(36.42)  


*Power Analysis
use "nextgen.dta", clear 

rdpower political_knowledge count // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8

rdpower political_interest count

rdpower social_awareness count

*Power Plots
rdpower political_knowledge count, plot 
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Political Knowledge
	gr_edit .note.text = {}
	graph save "power_political_knowledge_usa.gph", replace
	graph export "power_political_knowledge_usa.pdf", replace
	
rdpower political_interest count, plot
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Political Interest
	gr_edit .note.text = {}
	graph save "power_political_interest_usa.gph", replace
	graph export "power_political_interest_usa.pdf", replace
	
rdpower social_awareness count, plot
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Social Awareness
	gr_edit .note.text = {}
	graph save "power_social_awareness_usa.gph", replace
	graph export "power_social_awareness_usa.pdf", replace

graph combine power_political_knowledge_usa.gph power_political_interest_usa.gph power_social_awareness_usa.gph 
	graph save "power_usa_all.gph", replace
	graph export "power_usa_all.pdf", replace

	
// standardized
use "nextgen.dta", clear 

foreach var in political_knowledge political_interest social_awareness {
egen s_`var'=std(`var'), mean(0) std(1)
}

foreach var in political_knowledge political_interest social_awareness {
	rdrobust s_`var' count , c(0) p(1) q(2) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
}	
	
*Heterogeneities 
use "nextgen.dta", clear 

*SES
sum bg_mother_educ_lvl, d
rdrobust political_knowledge count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge count if bg_mother_educ_lvl<   6  , c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust political_interest count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest count if bg_mother_educ_lvl<   6 , c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust social_awareness count if bg_mother_educ_lvl>=  6  & bg_mother_educ_lvl~=., c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness count if bg_mother_educ_lvl<   6 , c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

*Race
rdrobust political_knowledge count if white==   1  , c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge count if white==   0  , c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust political_interest count if white==   1, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest count if white==   0, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust social_awareness count if white==   1, c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness count if white==   0 , c(0) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.



// standardized

foreach var in political_knowledge political_interest social_awareness {
egen s_`var'=std(`var'), mean(0) std(1)
}

*SES
foreach var in political_knowledge political_interest social_awareness {
	rdrobust s_`var' count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0) p(1) q(2) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
	mat b=e(b)
	scalar r_`var'_col=b[1,3]
	rdrobust s_`var' count if bg_mother_educ_lvl<   6  , c(0)  p(1) q(2) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
	mat b=e(b)
	scalar r_`var'_nocol=b[1,3]
	rdrobust s_`var' count if white==   1  , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
	mat b = e(b)
	scalar r_`var'_white=b[1,3]
	rdrobust s_`var' count if white==   1  , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
	mat b = e(b)
	scalar r_`var'_nowhite=b[1,3]
	}

foreach var in political_knowledge political_interest social_awareness {
	scalar list r_`var'_col		
	scalar list r_`var'_nocol		
	scalar list r_`var'_white		
	scalar list r_`var'_nowhite
	}

// quartic polynomial 

*SES
sum bg_mother_educ_lvl, d
rdrobust political_knowledge count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0) p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge count if bg_mother_educ_lvl<   6  , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust political_interest count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest count if bg_mother_educ_lvl<   6 , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust social_awareness count if bg_mother_educ_lvl>=  6  & bg_mother_educ_lvl~=., c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness count if bg_mother_educ_lvl<   6 , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

*Race
rdrobust political_knowledge count if white==   1  , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge count if white==   0  , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust political_interest count if white==   1, c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest count if white==   0, c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust social_awareness count if white==   1, c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness count if white==   0 , c(0)  p(4) q(5) all vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.


// wider bandwidth 

*SES
sum bg_mother_educ_lvl, d
rdrobust political_knowledge count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge count if bg_mother_educ_lvl<   6  , c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust political_interest count if bg_mother_educ_lvl>=   6  & bg_mother_educ_lvl~=., c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest count if bg_mother_educ_lvl<   6 , c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust social_awareness count if bg_mother_educ_lvl>=  6  & bg_mother_educ_lvl~=., c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness count if bg_mother_educ_lvl<   6 , c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

*Race
rdrobust political_knowledge count if white==   1  , c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_knowledge count if white==   0  , c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust political_interest count if white==   1, c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust political_interest count if white==   0, c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.

rdrobust social_awareness count if white==   1, c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.
rdrobust social_awareness count if white==   0 , c(0) all h(365) vce(cluster count)  // For each of the following topics listed below, do you have more concern, less concern, or about t...-Other countries’ perceptions of the U.S.




