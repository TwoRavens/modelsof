*Open data file that combines state electoral integrity data (EIP & Pew) with 2016 American National Election Studies individual survey data and adds state-level control variables
*Original source for data files listed in codebook and text of the paper
*All files merged together using state abbreviation identifier (stateabbr)

use "Flavin_Shufeldt_SPPQ_replication_data_2_of_2.dta", clear

/*Syntax below describes how we coded the ANES survey variables and state-level control variables used in the analysis

*Public officials don't care much what people like me think
*1=Agree strongly, 2=Agree somewhat, 3=Neither agree nor disagree, 4=Disagree somewhat, 5=Disagree strongly
gen care=.
replace care=1 if V162215==1
replace care=2 if V162215==2
replace care=3 if V162215==3
replace care=4 if V162215==4
replace care=5 if V162215==5
tab care

*People like me don't have any say about what the government does
*1=Agree strongly, 2=Agree somewhat, 3=Neither agree nor disagree, 4=Disagree somewhat, 5=Disagree strongly
gen say=.
replace say=1 if V162216==1
replace say=2 if V162216==2
replace say=3 if V162216==3
replace say=4 if V162216==4
replace say=5 if V162216==5
tab say

*In your view, how often do the following things occur in this country's elections? Votes are counted fairly
*1=Never, 2=Some of the time, 3=About half of the time, 4=Most of the time, 5=All of the time
gen fairly=.
replace fairly=1 if V162219==5
replace fairly=2 if V162219==4
replace fairly=3 if V162219==3
replace fairly=4 if V162219==2
replace fairly=5 if V162219==1
tab fairly

*Most politicians are trustworthy
*1=Disagree strongly, 2=Disagree somewhat, 3=Neither agree nor disagree, 4=Agree somewhat, 5=Agree strongly
gen trustworthy=.
replace trustworthy=1 if V162261==5
replace trustworthy=2 if V162261==4
replace trustworthy=3 if V162261==3
replace trustworthy=4 if V162261==2
replace trustworthy=5 if V162261==1
tab trustworthy

*How often can you trust the federal government in Washington to do what is right?
*1=Never, 2=Some of the time, 3=About half of the time, 4=Most of the time, 5=Always
gen trust=.
replace trust=1 if V161215==5
replace trust=2 if V161215==4
replace trust=3 if V161215==3
replace trust=4 if V161215==2
replace trust=5 if V161215==1
tab trust

*Age
rename V161267 age
recode age -8 -9 =.

*Education (1-16, more education coded higher)
rename V161270 education
recode education -9 -8 90 95=.

*Income (1-28)
rename V161361x income
recode income -9 -5 =.

*Female (1=Yes, 0=No)
gen female=0
replace female=1 if V161342==2

*Partisan strength (1=Independent, 2=Leaning Democrat/Republican, 3=Not very strong Democrat/Republican, 4=Strong Democrat/Republican)
gen partisan_strength=.
replace partisan_strength=4 if V161158x==1
replace partisan_strength=3 if V161158x==2
replace partisan_strength=2 if V161158x==3
replace partisan_strength=1 if V161158x==4
replace partisan_strength=2 if V161158x==5
replace partisan_strength=3 if V161158x==6
replace partisan_strength=4 if V161158x==7

*How often does respondent pay attention to politics and elections
*1=Never, 2=Some of the time, 3=About half the time, 4=Most of the time, 5=Always
gen payattention=.
replace payattention=1 if V161003==5
replace payattention=2 if V161003==4
replace payattention=3 if V161003==3
replace payattention=4 if V161003==2
replace payattention=5 if V161003==1

*Racial category dummy variables (white is reference category)
gen black=0
replace black=1 if V161310x==2
gen hispanic=0
replace hispanic=1 if V161310x==5

*Create % of state residents non-white variable
gen nonwhite=(1-(white_num/population))*100

*2016 competitiveness of presidential election variable, higher value means CLOSER margin between Clinton and Trump
gen closeness=-1*(abs(clinton-trump))

*/


*TABLE 3: The Relationship between Principal Components and Citizens’ Attitudes About Votes Being Counted Fairly
reg fairly norris_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_factor3 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_factor4 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_factor5 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_factor6 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)


*TABLE 4: The Relationship between Individual Indicators and Citizens’ Attitudes About Votes Being Counted Fairly
reg fairly norris_lawsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_proceduresi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_boundariesi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_voteregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_partyregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_mediai partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_financei partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_votingi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_counti partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_resultsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly norris_EMBsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_website_reg_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_website_precinct_ballot partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_website_absentee_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_website_provisiol_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_reg_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_prov_partic partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_prov_rej_all partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_abs_rej_all_ballots partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_abs_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_uocava_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_uocava_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_eavs_completeness partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_post_election_audit partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_nonvoter_illness_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_nonvoter_reg_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_online_reg partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_wait partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_pct_reg_of_vep_vrs partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg fairly pew_vep_turnout partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)



**ONLINE APPENDIX**


*TABLE 1A: Politicians are trustworthy
reg trustworthy norris_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_factor3 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_factor4 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_factor5 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_factor6 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)

*TABLE 1B: Politicians are trustworthy
reg trustworthy norris_lawsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_proceduresi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_boundariesi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_voteregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_partyregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_mediai partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_financei partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_votingi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_counti partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_resultsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy norris_EMBsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_website_reg_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_website_precinct_ballot partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_website_absentee_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_website_provisiol_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_reg_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_prov_partic partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_prov_rej_all partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_abs_rej_all_ballots partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_abs_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_uocava_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_uocava_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_eavs_completeness partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_post_election_audit partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_nonvoter_illness_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_nonvoter_reg_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_online_reg partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_wait partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_pct_reg_of_vep_vrs partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trustworthy pew_vep_turnout partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)


*TABLE 2A: Trust in federal government
reg trust norris_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_factor3 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_factor4 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_factor5 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_factor6 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)

*TABLE 2B: Trust in federal government
reg trust norris_lawsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_proceduresi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_boundariesi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_voteregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_partyregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_mediai partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_financei partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_votingi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_counti partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_resultsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust norris_EMBsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_website_reg_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_website_precinct_ballot partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_website_absentee_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_website_provisiol_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_reg_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_prov_partic partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_prov_rej_all partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_abs_rej_all_ballots partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_abs_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_uocava_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_uocava_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_eavs_completeness partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_post_election_audit partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_nonvoter_illness_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_nonvoter_reg_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_online_reg partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_wait partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_pct_reg_of_vep_vrs partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg trust pew_vep_turnout partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)


*TABLE 3A: Public officials care what people like me think
reg care norris_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_factor3 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_factor4 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_factor5 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_factor6 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)

*TABLE 3B: Public officials care what people like me think
reg care norris_lawsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_proceduresi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_boundariesi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_voteregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_partyregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_mediai partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_financei partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_votingi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_counti partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_resultsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care norris_EMBsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_website_reg_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_website_precinct_ballot partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_website_absentee_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_website_provisiol_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_reg_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_prov_partic partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_prov_rej_all partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_abs_rej_all_ballots partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_abs_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_uocava_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_uocava_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_eavs_completeness partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_post_election_audit partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_nonvoter_illness_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_nonvoter_reg_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_online_reg partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_wait partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_pct_reg_of_vep_vrs partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg care pew_vep_turnout partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)


*TABLE 4A: People like me have a say about what the government does
reg say norris_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_factor1 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_factor2 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_factor3 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_factor4 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_factor5 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_factor6 partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)

*TABLE 4B: People like me have a say about what the government does
reg say norris_lawsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_proceduresi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_boundariesi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_voteregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_partyregi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_mediai partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_financei partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_votingi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_counti partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_resultsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say norris_EMBsi partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_website_reg_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_website_precinct_ballot partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_website_absentee_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_website_provisiol_status partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_reg_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_prov_partic partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_prov_rej_all partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_abs_rej_all_ballots partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_abs_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_uocava_rej partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_uocava_nonret partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_eavs_completeness partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_post_election_audit partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_nonvoter_illness_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_nonvoter_reg_offyear_pct partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_online_reg partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_wait partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_pct_reg_of_vep_vrs partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
reg say pew_vep_turnout partisan_strength payattention education income female age black hispanic nonwhite foreign_born closeness, cluster(stateabbr)
