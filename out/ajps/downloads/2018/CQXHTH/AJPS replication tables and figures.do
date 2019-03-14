
******** importing "ajps_replication_wide.csv" and "ajps_replication_long.csv" and saving them as stata data files. 

clear
import delimited "ajps_replication_wide.csv", encoding(ISO-8859-1)
save "ajps_replication_wide.dta", replace

clear
import delimited "ajps_replication_long.csv", encoding(ISO-8859-1)
save "ajps_replication_long.dta", replace



******************************************************************************
*********************************Table 1****************************************
******************************************************************************
clear
use "ajps_replication_wide.dta"

*** we recode "religion" to get more directly % of Sunni and Shia; yet for other analysis, we keep the original code. 
replace religion=religion-1

sum religion female age education income shia_salient sunni_salient understanding 



******************************************************************************
***************the mannipulation check of expert appeal after Table 2*****************
******************************************************************************
clear
use "ajps_replication_wide.dta"

**recongition comparison between expert appeal and discussion
generate recognition=encounter_sunni_exp1+encounter_shia_exp1+encounter_sunni_exp2+encounter_shia_exp2
tab recognition
** 8 means that the participant does not recognize any of four experts. 
** 44% recognized at least one expert
ttest recognition if survey_version>1, by(survey_version)

generate all_answered=0
replace all_answered=1 if unpersuasive_sunni_exp1>0 &unpersuasive_shia_exp1>0 & unpersuasive_sunni_exp2>0 &unpersuasive_shia_exp2>0 &unpersuasive_sunni_exp1<5 &unpersuasive_shia_exp1<5 & unpersuasive_sunni_exp2<5 &unpersuasive_shia_exp2<5 
tab all_answered
** 221 answered to all four questions
generate all_persuasiveness=0
replace all_persuasiveness=1 if unpersuasive_sunni_exp1<3 & unpersuasive_shia_exp1<3 & unpersuasive_sunni_exp2<3 & unpersuasive_shia_exp2<3 &unpersuasive_sunni_exp1>0& unpersuasive_shia_exp1>0 & unpersuasive_sunni_exp2>0 & unpersuasive_shia_exp2>0
tab all_persuasiveness
** 156 evaluated positively. 
display 156/221
*** 71% positively evaluated all four experts. 


******************************************************************************
*********************************Table 4 (task 1)****************************************
******************************************************************************

clear
use "ajps_replication_wide.dta"

*First panel
logit sectarian_voter appeal  if survey_version<3, cluster(table_id) 
margins, dydx(appeal) atmeans
logit sectarian_voter appeal clientelism if survey_version<3, cluster(table_id) 
logit sectarian_voter appeal clientelism table1 table2 table3  table4 if survey_version<3, cluster(table_id) 
logit sectarian_voter appeal clientelism table1 table2 table3  table4 religion  understanding female age education income  sunni_salient shia_salient if survey_version<3, cluster(table_id) 
margins, dydx(appeal) atmeans
**the two results from "margins" show that expert appeal reduces sectarian voting by 19-23%

*second panel
logit sectarian_voter discussion  if survey_version>1, cluster(table_id) 
margins, dydx(discussion) atmeans
logit sectarian_voter discussion clientelism if survey_version>1, cluster(table_id) 
logit sectarian_voter discussion clientelism table1 table2 table3  table4 if survey_version>1, cluster(table_id) 
logit sectarian_voter discussion clientelism table1 table2 table3  table4 religion  understanding female age education income  sunni_salient shia_salient if survey_version>1, cluster(table_id) 
margins, dydx(discussion) atmeans
**the two results from "margins" show that expert appeal reduces sectarian voting by 7-9%




******************************************************************************
*********************************Table 5 (task 2)****************************************
******************************************************************************
clear
use "ajps_replication_wide.dta"

*first panel
reg t2_ingroup_favoritism appeal  if survey_version<3, cluster(table_id) 
reg t2_ingroup_favoritism appeal clientelism if survey_version<3, cluster(table_id) 
reg t2_ingroup_favoritism appeal clientelism table1 table2 table3  table4 if survey_version<3, cluster(table_id) 
reg t2_ingroup_favoritism appeal clientelism table1 table2 table3  table4 religion  understanding female age education income  sunni_salient shia_salient if survey_version<3, cluster(table_id) 

*second panel
reg t2_ingroup_favoritism discussion  if survey_version>1, cluster(table_id) 
reg t2_ingroup_favoritism discussion clientelism if survey_version>1, cluster(table_id) 
reg t2_ingroup_favoritism discussion clientelism table1 table2 table3  table4 if survey_version>1, cluster(table_id) 
reg t2_ingroup_favoritism discussion clientelism table1 table2 table3  table4 religion  understanding female age education income  sunni_salient shia_salient if survey_version>1, cluster(table_id) 




******************************************************************************
*********************************Table 6 (task 3)****************************************
******************************************************************************
clear
use "ajps_replication_long.dta"

xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

*first panel
xtreg individual_contribution appeal lag_table_contribution if survey_version<3, cluster(table_id)
xtreg individual_contribution appeal clientelism lag_table_contribution if survey_version<3, cluster(table_id) 
xtreg individual_contribution appeal clientelism lag_table_contribution table1 table2 table3 table4  if survey_version<3, cluster(table_id) 
xtreg individual_contribution appeal clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient if survey_version<3, cluster(table_id) 

*second panel
xtreg individual_contribution discussion lag_table_contribution if survey_version>1, cluster(table_id)
xtreg individual_contribution discussion clientelism lag_table_contribution if survey_version>1, cluster(table_id) 
xtreg individual_contribution discussion clientelism lag_table_contribution table1 table2 table3 table4  if survey_version>1, cluster(table_id) 
xtreg individual_contribution discussion clientelism lag_table_contribution table1 table2 table3 table4  religion  understanding female age education income  sunni_salient shia_salient if survey_version>1, cluster(table_id) 


******************************************************************************
*********************************Table 7****************************************
******************************************************************************
clear
use "ajps_replication_wide.dta"

****the proportion of participants accepting clientelistic offer
tab accept_offer if clientelism==1
*24% declinced the offer.


generate clientelism_appeal=clientelism*appeal
generate clientelism_discussion=clientelism*discussion
generate accept_appeal=accept_offer*appeal
generate accept_discussion=accept_offer*discussion

*first panel
logit sectarian_voter appeal clientelism table1 table2 table3 table4 religion understanding female age education income sunni_salient shia_salient if survey_version<3, cluster(table_id)
margins, dydx(clientelism) atmeans
* the margins result shows that clientelism increases 21% of sectarian voting
logit sectarian_voter appeal clientelism clientelism_appeal table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version<3, cluster(table_id)
logit sectarian_voter appeal accept_offer table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version<3, cluster(table_id)
margins, dydx(accept_offer) atmeans
* the margins result shows that accepting the offer increases 34% of sectarian voting
logit sectarian_voter appeal accept_offer accept_appeal table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version<3, cluster(table_id)

*second panel 
logit sectarian_voter discussion clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version>1, cluster(table_id) 
margins, dydx(clientelism) atmeans
* the margins result shows that clientelism increases 21% of sectarian voting
logit sectarian_voter discussion clientelism clientelism_discussion table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version>1, cluster(table_id)
logit sectarian_voter discussion accept_offer table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version>1, cluster(table_id)
margins, dydx(accept_offer) atmeans
* the margins result shows that accepting the offer increases 34% of sectarian voting
logit sectarian_voter discussion accept_offer accept_discussion table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  if survey_version>1, cluster(table_id)
 


******************************************************************************
*********************************Table 8****************************************
******************************************************************************

**first and second panels
clear
use "ajps_replication_wide.dta"

**first panel
ologit abs_intersectarian_trust appeal clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version<3, cluster(table_id)
ologit abs_intersectarian_trust discussion clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version>1, cluster(table_id)

**second panel
ologit rel_intersectarian_trust appeal clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version<3, cluster(table_id)
ologit rel_intersectarian_trust discussion clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version>1, cluster(table_id)


**Third panel 
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

xtreg individual_contribution abs_intersectarian_trust clientelism lag_table_contribution table1 table2 table3  religion  table4 understanding female age education income  sunni_salient shia_salient, cluster(table_id) 
xtreg individual_contribution rel_intersectarian_trust clientelism lag_table_contribution table1 table2 table3  religion  table4 understanding female age education income  sunni_salient shia_salient, cluster(table_id) 




******************************************************************************
******************************* Table 9 ****************************************
******************************************************************************

****first and second panels
clear
use "ajps_replication_wide.dta"

****first panel
logit sectarian_voter table_discussion_depth female_participation youth_participation  clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)
logit sectarian_voter table_discussion_depth female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)
margins, dydx(table_discussion_depth) atmeans
** the margin result shows that one unit increase in table_discussion_depth reduce 2.93562% of sectarian voting; given the difference between the lowest and highest scores of table_discussion_depth is 26, the margins result means that a move from the shallowest to the deepest discussion is associated with a decrease in the probability of sectarian voting by 76% (-.0293562*26) in the election game. 
logit sectarian_voter own_discussion_depth other_discussion_depth female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)

****second panel
reg t2_ingroup_favoritism table_discussion_depth female_participation youth_participation  clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)
reg t2_ingroup_favoritism table_discussion_depth female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)
** the coefficient on table_discussion_depth means that a move from the shallowest to the deepest discussion is associated with allocation of 4.0 fewer tokens (-.1550588*26) to a co-sectarian in the other-other allocation game. 
reg t2_ingroup_favoritism own_discussion_depth other_discussion_depth female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)


**Third panel
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

xtreg individual_contribution table_discussion_depth female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id) 
xtreg individual_contribution table_discussion_depth female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 religion  understanding female age education income sunni_salient shia_salient   if survey_version==3, cluster(table_id) 
** the coefficient on table_discussion_depth means that a move from the shallowest to the deepest discussion is associated with an increase in the contribution in the public goods game of 2.9 tokens (.1113751 *26)
xtreg individual_contribution own_discussion_depth other_discussion_depth female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 religion  understanding female age education income sunni_salient shia_salient   if survey_version==3, cluster(table_id) 




******************************************************************************
******************************* Appendix A ****************************************
******************************************************************************

***Now afrobarometer wave 3 is used for comparison of household income
clear
use "arab_barometer_w3_lebanon.dta"
*** the arab_barometer_w3_lebanon.dta was constrcuted from the original data of the 3rd wave (uploaded at http://www.arabbarometer.org/instruments-and-data-files), using "country" variable (in stata commands: keep if country==10)
append using ajps_replication_wide.dta

generate wave3=.
replace wave3=1 if country==10
replace wave3=0 if session>0& session<13

*** to compare household income levels, we rescale q1015 in accordance with the measure we used in the experiment. 
*** q1015 is the variable of household income in the 3rd wave. 
** q1012 is the variable that indicating muslims. 1 means muslims 
generate comp_income=.
replace comp_income=0 if wave3==1 & q1015<=650
replace comp_income=1 if wave3==1 & q1015>650 &q1015<=2000
replace comp_income=2 if wave3==1 & q1015>2000 &q1015<=3000
replace comp_income=3 if wave3==1 & q1015>3000 &q1015<=4500
replace comp_income=4 if wave3==1 & q1015>4500 &q1015<=5500
replace comp_income=5 if wave3==1 & q1015>5500 &q1015<=7000
replace comp_income=6 if wave3==1 & q1015>7000
replace comp_income=income if wave3==0

generate beirut=.
replace beirut=1 if q1==4501 &wave3==1
replace beirut=0 if q1!=4501 &wave3==1

twoway kdensity comp_income if beirut==1 & q1012==1, bwidth(1) lcolor(gs0) || kdensity comp_income if wave3==1&q1012==1, bwidth(1) lcolor(gs0) clpattern(shortdash)  ||kdensity comp_income if wave3==0, bwidth(1)  clpattern(longdash) lcolor(gs0) ytitle("kdensity (income)", size(small)) ylab(, labsize(small)) xlab(0 "Under 1,000,000" 1 "1,000,001 - 3,000,000" 2 "3,000,001 - 5,000,000" 3 "5,000,001 - 7,000,000" 4 "7,000,001 - 9,000,000" 5 "9,000,001 - 11,000,000" 6 "Over 11,000,001", angle(45) labsize(small)) xtitle("Monthly household income (LBP)", size(small)) legend(col(3) label(1 "Beirut (80)") label(2 "Lebanon (730)") label(3 "Experiment (330)") size(small)) graphregion(color(white))
graph save Graph "AppendixA_income.gph", replace


***Now afrobarometer wave 4 is used for comparison of age and education
clear
use "arab_barometer_w4_lebanon.dta"
*** the arab_barometer_w4_lebanon.dta was constrcuted from the original data of the 4th wave (uploaded at http://www.arabbarometer.org/instruments-and-data-files), using "country" variable (in stata commands: keep if country==10 & sample==1)
append using ajps_replication_wide.dta

generate wave4=.
replace wave4=1 if country==10
replace wave4=0 if session>0& session<13

generate beirut=.
replace beirut=1 if q1==10001 & wave4==1
replace beirut=0 if q1!=10001 & wave4==1

**** age
** q1001 is the variable of age in the 4th wave. 
** q1012 is the variable that indicating muslims. 1 means muslims 
generate comp_age=.
replace comp_age=q1001 if wave4==1
replace comp_age=age if wave4==0
twoway kdensity comp_age if beirut==1 &q1012==1, bwidth(10) lcolor(gs0) || kdensity comp_age if wave4==1&q1012==1, bwidth(10) clpattern(shortdash) lcolor(gs0) ||kdensity comp_age if wave4==0, bwidth(10) clpattern(longdash) lcolor(gs0) ytitle("kdensity (age)", size(small)) ylab(, labsize(small)) xlab(20(20)100, labsize(small)) xtitle("Age (years)", size(small)) legend(col(3) label(1 "Beirut (80)") label(2 "Lebanon (615)") label(3 "Experiment (360)") size(small)) graphregion(color(white))
graph save Graph "AppendixA_age.gph", replace

*** education
generate comp_education=.
** t1003 is the variable of education in the 4th wave. 
replace comp_education=t1003 if wave4==1
*** for comparison, we have to combine "Mid~(category 5) with "Secondary (category4) in our experimental data
replace comp_education=education+1 if wave4==0 &education<4
replace comp_education=education if wave4==0 &education>=4

twoway kdensity comp_education if beirut==1& q1012==1, bwidth(1) lcolor(gs0)|| kdensity comp_education if wave4==1&q1012==1, bwidth(1) clpattern(shortdash) lcolor(gs0) ||kdensity comp_education if wave4==0, bwidth(1) clpattern(longdash) lcolor(gs0) ytitle("kdensity (education level)", size(small)) ylab(, labsize(small)) xlab(1 "Illiterate/No formal" 2 "Elementary" 3 "Preparatory/Basic" 4 "Secondary/Mid-level diploma" 5 "BA" 6 "MA or above", angle(45) labsize(small)) xtitle("Education level", size(small)) legend(col(3) label(1 "Beirut (80)") label(2 "Lebanon (615)") label(3 "Experiment (360)") size(small)) graphregion(color(white))
graph save Graph "AppendixA_education.gph", replace

graph combine AppendixA_income.gph AppendixA_age.gph AppendixA_education.gph, col(1) graphregion(color(white)) ysize(8) xsize(4)



****************************** Appendix C ****************************************
******************************************************************************
clear
use "ajps_replication_wide.dta"
tab unpersuasive_shia_exp1 religion
tab unpersuasive_shia_exp2 religion
tab unpersuasive_sunni_exp1 religion
tab unpersuasive_sunni_exp2 religion
tab unpersuasive_moderator religion
** for the above, religion 1 means Sunni, whereas religion 2 means Shia; 226~233 answered. 

clear
import delimited "expert_manipulation.csv", encoding(ISO-8859-1)
generate sum=freq1+freq2+freq3+freq4
generate prop_c1=freq1/sum
generate prop_c2=freq2/sum
generate prop_c3=freq3/sum
generate prop_c4=freq4/sum

*** we have to change values for religion in order to put Shia first. 
replace religion=2-religion
** Now religion 0 is shia and 1 is sunni.

*** also we generate 'expert' to place Shia experts first
generate expert=.
replace expert=1 if order==2
replace expert=2 if order==4
replace expert=3 if order==1
replace expert=4 if order==3
replace expert=5 if order==5

sort religion expert

graph bar prop_c1 prop_c2 prop_c3 prop_c4, over(expert, label(angle(45) labsize(small)) relabel(1 "Shia expert1" 2 "shia expert 2" 3 "Sunni expert 1" 4 "Sunni expert 2" 5 "Moderator")) over(religion, relabel(1 "Shia participants" 2 "Sunni participants") label(labsize(medium))) stack ytitle("Proportion of evaluated persuasiveness", size(medium)) ylab(, labsize(medium)) legend(col(4) label(1 "Very persuasive") label(2 "Quite persuasive") label(3 "Quite unpersuasive") label(4 "Very unpersuasive") size(medium) symxsize(5) ) graphregion(color(white)) ysize(3) xsize(6) bar(1, color(gs0)) bar(2, color(gs6)) bar(3, color(gs10)) bar(4, color(gs12)) 



******************************************************************************
******************************* Appendix L RANDOMIZATION CHECK****************************************
******************************************************************************

clear
use "ajps_replication_wide.dta"

***we generate a variable named "cond" indicating the experimental condition. 
generate cond=.
replace cond=1 if survey_version==1 & clientelism==0
replace cond=2 if survey_version==2 & clientelism==0
replace cond=3 if survey_version==3 & clientelism==0
replace cond=4 if survey_version==1 & clientelism==1
replace cond=5 if survey_version==2 & clientelism==1
replace cond=6 if survey_version==3 & clientelism==1

*understanding of the task
ttest understanding if cond==1|cond==2, by(cond)
ttest understanding if cond==1|cond==3, by(cond)
ttest understanding if cond==1|cond==4, by(cond)
ttest understanding if cond==1|cond==5, by(cond)
ttest understanding if cond==1|cond==6, by(cond)
ttest understanding if cond==2|cond==3, by(cond)
ttest understanding if cond==2|cond==4, by(cond)
ttest understanding if cond==2|cond==5, by(cond)
ttest understanding if cond==2|cond==6, by(cond)
ttest understanding if cond==3|cond==4, by(cond)
ttest understanding if cond==3|cond==5, by(cond)
ttest understanding if cond==3|cond==6, by(cond)
ttest understanding if cond==4|cond==5, by(cond)
ttest understanding if cond==4|cond==6, by(cond)
ttest understanding if cond==5|cond==6, by(cond)

*** age
ttest age if cond==1|cond==2, by(cond)
ttest age if cond==1|cond==3, by(cond)
ttest age if cond==1|cond==4, by(cond)
ttest age if cond==1|cond==5, by(cond)
ttest age if cond==1|cond==6, by(cond)
ttest age if cond==2|cond==3, by(cond)
ttest age if cond==2|cond==4, by(cond)
ttest age if cond==2|cond==5, by(cond)
ttest age if cond==2|cond==6, by(cond)
ttest age if cond==3|cond==4, by(cond)
ttest age if cond==3|cond==5, by(cond)
ttest age if cond==3|cond==6, by(cond)
ttest age if cond==4|cond==5, by(cond)
ttest age if cond==4|cond==6, by(cond)
ttest age if cond==5|cond==6, by(cond)

***education
ttest education if cond==1|cond==2, by(cond)
ttest education if cond==1|cond==3, by(cond)
ttest education if cond==1|cond==4, by(cond)
ttest education if cond==1|cond==5, by(cond)
ttest education if cond==1|cond==6, by(cond)
ttest education if cond==2|cond==3, by(cond)
ttest education if cond==2|cond==4, by(cond)
ttest education if cond==2|cond==5, by(cond)
ttest education if cond==2|cond==6, by(cond)
ttest education if cond==3|cond==4, by(cond)
ttest education if cond==3|cond==5, by(cond)
ttest education if cond==3|cond==6, by(cond)
ttest education if cond==4|cond==5, by(cond)
ttest education if cond==4|cond==6, by(cond)
ttest education if cond==5|cond==6, by(cond)

***income
ttest income if cond==1|cond==2, by(cond)
ttest income if cond==1|cond==3, by(cond)
ttest income if cond==1|cond==4, by(cond)
ttest income if cond==1|cond==5, by(cond)
ttest income if cond==1|cond==6, by(cond)
ttest income if cond==2|cond==3, by(cond)
ttest income if cond==2|cond==4, by(cond)
ttest income if cond==2|cond==5, by(cond)
ttest income if cond==2|cond==6, by(cond)
ttest income if cond==3|cond==4, by(cond)
ttest income if cond==3|cond==5, by(cond)
ttest income if cond==3|cond==6, by(cond)
ttest income if cond==4|cond==5, by(cond)
ttest income if cond==4|cond==6, by(cond)
ttest income if cond==5|cond==6, by(cond)

**Shia predominantly salient
ttest shia_salient if cond==1|cond==2, by(cond)
ttest shia_salient if cond==1|cond==3, by(cond)
ttest shia_salient if cond==1|cond==4, by(cond)
ttest shia_salient if cond==1|cond==5, by(cond)
ttest shia_salient if cond==1|cond==6, by(cond)
ttest shia_salient if cond==2|cond==3, by(cond)
ttest shia_salient if cond==2|cond==4, by(cond)
ttest shia_salient if cond==2|cond==5, by(cond)
ttest shia_salient if cond==2|cond==6, by(cond)
ttest shia_salient if cond==3|cond==4, by(cond)
ttest shia_salient if cond==3|cond==5, by(cond)
ttest shia_salient if cond==3|cond==6, by(cond)
ttest shia_salient if cond==4|cond==5, by(cond)
ttest shia_salient if cond==4|cond==6, by(cond)
ttest shia_salient if cond==5|cond==6, by(cond)

**Sunni predominantly salient
ttest sunni_salient if cond==1|cond==2, by(cond)
ttest sunni_salient if cond==1|cond==3, by(cond)
ttest sunni_salient if cond==1|cond==4, by(cond)
ttest sunni_salient if cond==1|cond==5, by(cond)
ttest sunni_salient if cond==1|cond==6, by(cond)
ttest sunni_salient if cond==2|cond==3, by(cond)
ttest sunni_salient if cond==2|cond==4, by(cond)
ttest sunni_salient if cond==2|cond==5, by(cond)
ttest sunni_salient if cond==2|cond==6, by(cond)
ttest sunni_salient if cond==3|cond==4, by(cond)
ttest sunni_salient if cond==3|cond==5, by(cond)
ttest sunni_salient if cond==3|cond==6, by(cond)
ttest sunni_salient if cond==4|cond==5, by(cond)
ttest sunni_salient if cond==4|cond==6, by(cond)
ttest sunni_salient if cond==5|cond==6, by(cond)



******************************************************************************
************ Appendix M RESULTS FROM MULTIVEL MODELING **********************
******************************************************************************

***** Table M1 -First panel 
clear
use "ajps_replication_wide.dta"
drop if survey_version==3
melogit sectarian_voter appeal clientelism religion  understanding female age education income  sunni_salient shia_salient ||session: ||table: 

clear
use "ajps_replication_wide.dta"
drop if survey_version==1
melogit sectarian_voter discussion clientelism religion  understanding female age education income  sunni_salient shia_salient ||session: ||table: 


**** Table M1 - Second panel
clear
use "ajps_replication_wide.dta"
drop if survey_version==3
mixed t2_ingroup_favoritism appeal clientelism religion  understanding female age education income  sunni_salient shia_salient ||session: ||table: 

clear
use "ajps_replication_wide.dta"
drop if survey_version==1
mixed t2_ingroup_favoritism discussion clientelism religion  understanding female age education income  sunni_salient shia_salient ||session: ||table: 

***** Table M1 - Third panel
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

xtmixed individual_contribution appeal clientelism lag_table_contribution religion  understanding female age education income  sunni_salient shia_salient ||session: ||table: if survey_version<3, mle covariance(unstructure)
xtmixed individual_contribution discussion clientelism lag_table_contribution religion  understanding female age education income  sunni_salient shia_salient ||session: ||table: if survey_version>1, mle covariance(unstructure)



****** Table M2 - Clientelism 

** First panel
clear
use "ajps_replication_wide.dta"

generate clientelism_appeal=clientelism*appeal
generate clientelism_discussion=clientelism*discussion
generate accept_appeal=accept_offer*appeal
generate accept_discussion=accept_offer*discussion

drop if survey_version==3
melogit sectarian_voter appeal clientelism table1 table2 table3 table4 religion understanding female age education income sunni_salient shia_salient ||session: ||table: 
melogit sectarian_voter appeal clientelism clientelism_appeal table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  ||session: ||table: 
melogit sectarian_voter appeal accept_offer table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 
melogit sectarian_voter appeal accept_offer accept_appeal table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  ||session: ||table: 

***Second panel
clear
use "ajps_replication_wide.dta"
generate clientelism_appeal=clientelism*appeal
generate clientelism_discussion=clientelism*discussion
generate accept_appeal=accept_offer*appeal
generate accept_discussion=accept_offer*discussion

drop if survey_version==1
melogit sectarian_voter discussion clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  ||session: ||table: 
melogit sectarian_voter discussion clientelism clientelism_discussion table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient   ||session: ||table: 
melogit sectarian_voter discussion accept_offer table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient  ||session: ||table: 
melogit sectarian_voter discussion accept_offer accept_discussion table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient   ||session: ||table: 



*******Table M3 - Treatment effects on cross-sectarian trust (models 1-4) and effect of trust on contributions in a public goods game (models 5-6) 
*** First panel: ABSOULTE CROSS-SECTARIAN
clear
use "ajps_replication_wide.dta"
drop if survey_version==3
meologit abs_intersectarian_trust appeal clientelism religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 

clear
use "ajps_replication_wide.dta"
drop if survey_version==1
meologit abs_intersectarian_trust discussion clientelism religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 

*** Second paenl: RELATIVE CROSS-SECTARIAN
clear
use "ajps_replication_wide.dta"
drop if survey_version==3
meologit rel_intersectarian_trust appeal clientelism religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 

clear
use "ajps_replication_wide.dta"
drop if survey_version==1
meologit rel_intersectarian_trust discussion clientelism religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 

*** Third panel: impacts of intersectarian trust on contribution
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

xtmixed individual_contribution abs_intersectarian_trust clientelism lag_table_contribution religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 
xtmixed individual_contribution rel_intersectarian_trust clientelism lag_table_contribution religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 



*********Table M4 -Discussion depth (Table 9) *******

*** First and second panels
clear
use "ajps_replication_wide.dta"

** First panel
melogit sectarian_voter table_discussion_depth female_participation youth_participation  clientelism  ||session: ||table: 
melogit sectarian_voter table_discussion_depth female_participation youth_participation  clientelism religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 

** Second panel
mixed t2_ingroup_favoritism table_discussion_depth female_participation youth_participation  clientelism ||session: ||table: 
mixed t2_ingroup_favoritism table_discussion_depth female_participation youth_participation  clientelism religion understanding female age education income  sunni_salient shia_salient ||session: ||table: 


*** Third panel
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

xtmixed individual_contribution table_discussion_depth female_participation youth_participation  lag_table_contribution clientelism ||session: ||table: , mle covariance(unstructure)

**we rescale youth_participation to avoid a failure of calculating the standard error of session random effect in the second model
replace youth_participation=youth_participation+1
xtmixed individual_contribution table_discussion_depth female_participation youth_participation  lag_table_contribution clientelism religion  understanding female age education income sunni_salient shia_salient ||session: ||table: , mle covariance(unstructure)



******************************************************************************
******************************* Appendix N ****************************************
******************************************************************************
clear
use "ajps_replication_wide.dta"

*Voting 1 means voting for a Sunni candidate; 2 means voting for a Shia candidate
*religion 1 indiates Sunni and religion 2 indicates Shia

*Total
tab religion t1_election1 
tab religion t1_election2 
tab religion t1_election3 
tab religion t1_election4 



******************************************************************************
******* Appendix O :VOTE CHOICE DISAGGREGATED BY SECT, ELECTION, AND TREATMENT********
******************************************************************************

**** The followings are to check whether or not vote choices between two experimental conditions are statistically different under the same election type.
**We use the results from pearson's chi-squared tests to make an asterisk on the Appendix O figure generated using R codes. 

clear
import delimited "election_switching.csv", encoding(ISO-8859-1)

*** sect_candidate 1 means that the shia candidate was sectarian, and 2 means that the sunni candidate was sectarian
generate sect_candidate=.
replace sect_candidate=1 if election==1 | election==3
replace sect_candidate=2 if election==2 | election==4


**** the upper left pannel in the Appendix O figure ****
** shia participants voting for shia candidate in elections 1 and 3: sectarian voting

* election 1: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==1 & religion==2 & survey_version==1& election==1
tab c_shia c_sunni if sect_candidate==1 & religion==2 & survey_version==2& election==1
tab c_shia c_sunni if sect_candidate==1 & religion==2 & survey_version==3& election==1
tabi 27 33\28 32, chi2
tabi 28 32\24 36, chi2
** both are insignificant

** election 3: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==1 & religion==2 & survey_version==1& election==3
tab c_shia c_sunni if sect_candidate==1 & religion==2 & survey_version==2& election==3
tab c_shia c_sunni if sect_candidate==1 & religion==2 & survey_version==3& election==3
tabi 33 27\27 32, chi2
tabi 27 32\29 31, chi2
** both are insignificant


**** the upper right pannel in the Appendix O figure ****
*** sunni participants voting for sunni candidate in elections 2 and 4: sectarian voting

* election 2: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==2 & religion==1 & survey_version==1& election==2
tab c_shia c_sunni if sect_candidate==2 & religion==1 & survey_version==2& election==2
tab c_shia c_sunni if sect_candidate==2 & religion==1 & survey_version==3& election==2
tabi 25 35\40 20, chi2
tabi 40 20\30 30, chi2
** Only the first one is signficiant at 5%

* election 4: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==2 & religion==1 & survey_version==1& election==4
tab c_shia c_sunni if sect_candidate==2 & religion==1 & survey_version==2& election==4
tab c_shia c_sunni if sect_candidate==2 & religion==1 & survey_version==3& election==4
tabi 25 35\36 24, chi2
tabi 36 24\32 28, chi2
** Only the first one is signficiant at 5%


**** the lower left pannel in the Appendix O figure ****
*** shia participants voting for shia candidate in elections 2 and 4: egalitarian voting

*election 2: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==2 & religion==2 & survey_version==1& election==2
tab c_shia c_sunni if sect_candidate==2 & religion==2 & survey_version==2& election==2
tab c_shia c_sunni if sect_candidate==2 & religion==2 & survey_version==3& election==2
tabi 56 4\50 10, chi2
tabi 50 10\55 5, chi2
** both are insignificant

* election 4: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==2 & religion==2 & survey_version==1& election==4
tab c_shia c_sunni if sect_candidate==2 & religion==2 & survey_version==2& election==4
tab c_shia c_sunni if sect_candidate==2 & religion==2 & survey_version==3& election==4
tabi 57 3 \51 9, chi2
tabi 51 9\ 55 5, chi2
** both are insignificant 


**** the lower right pannel in the Appendix O figure ****
**sunni participants voting for sunni candidate in elections 1 and 3: egalitarian voting

* election 1: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==1 & religion==1 & survey_version==1& election==1
tab c_shia c_sunni if sect_candidate==1 & religion==1 & survey_version==2& election==1
tab c_shia c_sunni if sect_candidate==1 & religion==1 & survey_version==3& election==1
tabi 4 56\2 58, chi2
tabi 2 58\9 51, chi2
** Only the second one is significant at 5%

** election 3: comparison between baseline and expert appeal and between expert appeal and discussion
tab c_shia c_sunni if sect_candidate==1 & religion==1 & survey_version==1& election==3
tab c_shia c_sunni if sect_candidate==1 & religion==1 & survey_version==2& election==3
tab c_shia c_sunni if sect_candidate==1 & religion==1 & survey_version==3& election==3
tabi 6 54\4 55, chi2
tabi 4 55\6 54, chi2
** both are insignificant

** Figure is made using R - see R code.





******************************************************************************
******************************* Appendix P ****************************************
******************************************************************************
** Figure is made using R - see R code.




******************************************************************************
********************* Appendix Q: celing effect ********************************
******************************************************************************
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

generate session_table_id=session*100+table
tabulate session_table_id, generate(g)

** First panel
xttobit individual_contribution appeal clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient if survey_version<3, ul(10) 
xttobit individual_contribution appeal clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient if survey_version<3, ul(10) ll(0)
xttobit individual_contribution appeal clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient g1-g60 if survey_version<3, ul(10) 
xttobit individual_contribution appeal clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient g1-g60 if survey_version<3, ul(10) ll(0)

** Second panel
xttobit individual_contribution discussion clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient if survey_version>1, ul(10)
xttobit individual_contribution discussion clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient if survey_version>1, ul(10) ll(0)
xttobit individual_contribution discussion clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient g1-g60 if survey_version>1, ul(10)
xttobit individual_contribution discussion clientelism lag_table_contribution table1 table2 table3  table4  religion  understanding female age education income  sunni_salient shia_salient g1-g60 if survey_version>1, ul(10) ll(0)



******************************************************************************
*** Appendix R:RELATIVE CROSS-SECTARIAN TRUST REGRESSION FROM TABLE 8 (OLS)  ********
******************************************************************************
clear
use "ajps_replication_wide.dta"

reg rel_intersectarian_trust appeal clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version<3, cluster(table_id)
reg rel_intersectarian_trust discussion clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version>1, cluster(table_id)



*****************************************************************************
******************************* Appendix T: Discussion tone ****************************************
******************************************************************************

****First and second panels
clear
use "ajps_replication_wide.dta"

** we construct table_sentiment that captures the degree of sentiment strength at the table level.
***It is rescaled between 0 and 1. 
generate table_sentiment=(table_positive_sentiment-table_negative_sentiment)
egen min_table_sentiment=min(table_sentiment)
egen max_table_sentiment=max(table_sentiment)
generate divider= max_table_sentiment- min_table_sentiment
replace table_sentiment=(table_sentiment- min_table_sentiment)/divider
tab table_sentiment

** first panel
logit sectarian_voter table_discussion_depth table_sentiment female_participation youth_participation  clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)
logit sectarian_voter table_discussion_depth table_sentiment female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)

*** second panel
reg t2_ingroup_favoritism table_discussion_depth table_sentiment female_participation youth_participation  clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)
reg t2_ingroup_favoritism table_discussion_depth table_sentiment female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)


*** third panel
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

** we construct table_sentiment that captures the degree of sentiment strength at the table level.
***It is rescaled between 0 and 1. 
generate table_sentiment=(table_positive_sentiment-table_negative_sentiment)
egen min_table_sentiment=min(table_sentiment)
egen max_table_sentiment=max(table_sentiment)
generate divider= max_table_sentiment- min_table_sentiment
replace table_sentiment=(table_sentiment- min_table_sentiment)/divider
tab table_sentiment

xtreg individual_contribution table_discussion_depth table_sentiment female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id) 
xtreg individual_contribution table_discussion_depth table_sentiment female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 religion  understanding female age education income sunni_salient shia_salient   if survey_version==3, cluster(table_id) 



******************************************************************************
*** Appendix U: EFFECT OF DISCUSSION DURATION AND LENGTH OF MODERATOR INTERVENTION **
******************************************************************************

****First and second panels
clear
use "ajps_replication_wide.dta"

*** First panel
logit sectarian_voter table_discussion_depth entire_duration moderator_duration female_participation youth_participation  clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)
logit sectarian_voter table_discussion_depth entire_duration moderator_duration female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)

*** Second panel
reg t2_ingroup_favoritism table_discussion_depth entire_duration moderator_duration female_participation youth_participation  clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)
reg t2_ingroup_favoritism table_discussion_depth entire_duration moderator_duration female_participation youth_participation  clientelism table1 table2 table3 table4 religion understanding female age education income  sunni_salient shia_salient if survey_version==3, cluster(table_id)


*** Third panel
clear
use "ajps_replication_long.dta"
xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

xtreg individual_contribution table_discussion_depth entire_duration moderator_duration female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id) 
xtreg individual_contribution table_discussion_depth entire_duration moderator_duration female_participation youth_participation  lag_table_contribution clientelism table1 table2 table3 table4 religion  understanding female age education income sunni_salient shia_salient   if survey_version==3, cluster(table_id) 




******************************************************************************
**** Appendix V: Table for determinants of individual participation*********
******************************************************************************
clear
use "ajps_replication_wide.dta"

reg own_discussion_depth religion understanding female age education income shia_salient  sunni_salient clientelism table1 table2 table3 table4 if survey_version==3, cluster(table_id)




******************************************************************************
********* Appendix W. DISTRIBUTION OF DISCUSSION SCORES AND PAIRWISE COMPARISONS OF INACTIVE AND ACTIVE PARTICIPANTS’ DISCUSSION SCORES*************************************************
******************************************************************************
****Tasks 1 and 2
clear
use "ajps_replication_wide.dta"
keep if survey_version==3

* For Appendix W-1 table: Distribution of one’s own discussion scores and other participants’ discussion scores
tab other_discussion_depth own_discussion_depth 

sum own_discussion_depth, detail
*median=4
sum other_discussion_depth, detail
*median=20

generate active_participant=.
replace active_participant=0 if own_discussion_depth<=4
replace active_participant=1 if own_discussion_depth>4
replace active_participant=. if session==6 &table ==1

generate active_other=.
replace active_other=0 if other_discussion_depth<=20
replace active_other=1 if other_discussion_depth>20
replace active_other=. if session==6 &table ==1

****the following is for the table in Appendix W
tab other_discussion_depth own_discussion_depth 

***task 1 figure
graph bar sectarian_voter, ascategory over(active_other, label(angle(45) labsize(medium)) relabel(1 "With inactive others" 2 "With active others")) over(active_participant, relabel(1 "Inactive participants" 2 "Active participants") label(labsize(medium))) bar(1, color(gs0)) ytitle("Proportion of sectarian voting", size(medium)) ylab(0(0.2)1, labsize(medium)) graphregion(color(white)) xsize(4) ysize(2.5) title("Task 1 (Sectarian voting)") caption(" " "Note: 39 inactive participants with inactive others; 29 inactive participants with active others;" "          19 active participants with inactive others; 27 active participants with active others")


***the following is pearson's chi square test for Task 1
tab sectarian_voter active_other if active_participant==0
tabi 16 23 \ 22 7, chi2

tab sectarian_voter active_other if active_participant==1
tabi 15 4 \ 21 6, chi2

tab sectarian_voter active_participant if active_other==0
tabi 16 23 \15 4, chi2

tab sectarian_voter active_participant if active_other==1
tabi 22 7\21 6, chi2




***task 2 figure
graph bar t2_ingroup_favoritism, ascategory over(active_other, label(angle(45) labsize(medium)) relabel(1 "With inactive others" 2 "With active others")) over(active_participant, relabel(1 "Inactive participants" 2 "Active participants") label(labsize(medium))) bar(1, color(gs0)) ytitle("Average amount of tokens to a co-sectarian", size(small)) ylab(0(2)10, labsize(medium)) graphregion(color(white)) xsize(4) ysize(2.5) title("Task 2 (Other-other allocation)") caption(" " "Note: 39 inactive participants with inactive others; 29 inactive participants with active others;" "          19 active participants with inactive others; 27 active participants with active others")

***the following is t-test for Task 2
ttest t2_ingroup_favoritism if active_participant==0, by (active_other)
ttest t2_ingroup_favoritism if active_participant==1, by (active_other)
ttest t2_ingroup_favoritism if active_other==0, by (active_participant)
ttest t2_ingroup_favoritism if active_other==1, by (active_participant)




*** Task3
clear
use "ajps_replication_long.dta"
keep if survey_version==3

xtset decision_sheet_id round
by decision_sheet_id: gen lag_table_contribution=table_contribution[_n-1]

sum own_discussion_depth, detail
sum other_discussion_depth, detail

generate active_participant=.
replace active_participant=0 if own_discussion_depth<=4
replace active_participant=1 if own_discussion_depth>4
replace active_participant=. if session==6 &table ==1

generate active_other=.
replace active_other=0 if other_discussion_depth<=20
replace active_other=1 if other_discussion_depth>20
replace active_other=. if session==6 &table ==1

***Task 3 figure
graph bar individual_contribution, ascategory over(active_other, label(angle(45) labsize(medium)) relabel(1 "With inactive others" 2 "With active others")) over(active_participant, relabel(1 "Inactive participants" 2 "Active participants") label(labsize(medium))) bar(1, color(gs0)) ytitle("Average amount of contribution", size(medium)) ylab(0(2)10, labsize(medium)) graphregion(color(white)) xsize(4) ysize(2.5) title("Task 3 (Public goods game)") caption(" " "Note: 39 inactive participants with inactive others; 29 inactive participants with active others;" "          19 active participants with inactive others; 27 active participants with active others;" "          5 observations from each participant")

**the following is t test for Task 3
ttest individual_contribution if active_participant==0, by (active_other)
ttest individual_contribution if active_participant==1, by (active_other)
ttest individual_contribution if active_other==0, by (active_participant)
ttest individual_contribution if active_other==1, by (active_participant)


