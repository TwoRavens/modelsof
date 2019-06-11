******Georgia Pilot Analysis****

clear 
set more off 

***Loading int he data
cd "~/Dropbox/Research Projects/Caucausus Crime/Final Data Georgia Analysis"

use KupaZei_Final_NR.dta

capture log close

* Log file

log using KupaZei_GeorgiaForeignPolicy.log, replace

***Clearing out the observation of people who don't respond (i.e. missing)***
keep if q2!=.

***Setting up Treatments for Justice Experiment***
tabulate exp1 if exp1>0, gen(treatment)

rename treatment1 control
rename treatment2 general_imp
rename treatment3 elite_imp
rename treatment4 equality


***Generate Strata Dummies (for Tbilisi, Kutaisi, and Conflict-Affected Areas**
gen tbilisi=0
replace tbilisi=1 if stratum==1 | stratum==2

gen kutaisi=0
replace kutaisi=1 if stratum==3 | stratum==4

gen conflict_affected=0
replace conflict_affected=1 if stratum==5 | stratum==6


gen idp_status=.
replace idp_status=0 if q64==0
replace idp_status=1 if q64==1 
**Renaming the Variables and taking care of ***


*Crime safety
gen crime_increasing=q4 if q4>=0


****Creating the Psychological Scales****
**Creating Honor Scale drop 10_8 (**only relevant to male**) 

alpha q10_1 q10_2 q10_3 q10_4 q10_5 q10_6 q10_7  if q10_1 >0 & q10_2>0 & q10_3>0 & q10_4>0 & q10_5>0 & q10_6>0 & q10_7>0 , item gen(honor_index)

*rescaling to lie between 0 and 1

replace honor_index= (honor_index-1)/3
sum honor


**Creating Vengeance Scale ***Does not scale well***
alpha q7_1 q7_2 q7_3 if q7_1>0 & q7_2>0 & q7_3>0 , item gen(vengeance) 

***STAI
alpha q6_1 q6_2 q6_3 q6_4 q6_5 q6_6 if q6_1>0 & q6_2>0 & q6_3>0 & q6_4>0 & q6_5>0 & q6_6>0, item gen(stress_index)

*rescaling to lie between 0 and 1

replace stress_index= (stress_index+.6666667)/(.6666667+ 2.333333)

sum stress







***Scenarios (1= Go to the Police/Formal and 0 Handle Things Informally)***
gen carhit_scenario=1 if q18_1==.
replace carhit_scenario=1 if q18_1==1
replace carhit_scenario=0 if q18_1==2

gen localkid_scenario=1 if q18_2==.
replace localkid_scenario=1 if q18_2==1
replace localkid_scenario=0 if q18_2==2

gen husband_scenario=1 if q18_3==.
replace husband_scenario=1 if q18_3==1
replace husband_scenario=0 if q18_3==2

gen gangup_scenario=1 if q18_4==.
replace gangup_scenario=1 if q18_4==1
replace gangup_scenario=0 if q18_4==2

gen boss_scenario=1 if q18_5==.
replace boss_scenario=1 if q18_5==1
replace boss_scenario=0 if q18_5==2

gen bureau_scenario=1 if q18_6==.
replace bureau_scenario=1 if q18_6==1
replace bureau_scenario=0 if q18_6==2

gen femrel_scenario=1 if q18_7==.
replace femrel_scenario=1 if q18_7==1
replace femrel_scenario=0 if q18_7==2

gen cheat_scenario=1 if q18_8==.
replace cheat_scenario=1 if q18_8==1
replace cheat_scenario=0 if q18_8==2


rename q19 vote_politician
rename q20 hire_excon
rename q21 gov_workers_toomany_benefits
rename q22 thieves_respect
rename q23 glad_thieves_arrested
rename q24 thieves_moregood
rename q25 rich_nojail
rename q26 hassle_reportcrime
rename q27 satisf_justice
rename q28 never_rat

***Justice Scenarios***

rename q29_1 drug_punish
rename q29_2 policebeat_punish
rename q29_3 manrapes_punish
rename q29_4 beatdeath_punish
rename q29_5 carjack_punish



**Demographic Variables
gen hh_spending=q80 if q80>0
revrs hh_spending
replace hh_spending=revhh_spending

gen married=0
replace married=1 if q2==2

**Creating an asset index
alpha q81_1 q81_2 q81_3 q81_4 q81_5 q81_6 , item gen(asset_index)

**Creating unemployed
gen unemployed=0
replace unemployed=1 if q73==4

**Education

gen education=0
replace education= q79 if q79>0

*Male
tab sex
gen male=0
replace male=1 if sex==1



********Setting up Treatments for Foreign Policy Experiment*******

tabulate exp2 if exp2>0, gen(fp_experiment)

rename fp_experiment1 fp_control
rename fp_experiment2 info_treat
rename fp_experiment3 anger_treat
rename fp_experiment4 fear_treat


******Renaming Foreign Policy  variables*************************

*Main Variables
rename q39 russia_threat
rename q40 georgia_nato
rename q41 russia_angry

*Key NATO/Russia and South Ossetia Questions

rename q42_1 recog_abk
rename q42_2 recog_so


*What should Georgia do about Abkhazia
rename q43_1 send_econ_abk
rename q43_2 send_wep_abk
rename q43_3 donothing_abk
rename q43_4 normal_abk

*What Should Georgia do Abouth South Ossetia
rename q44_1 send_econ_so
rename q44_2 send_wep_so
rename q44_3 donothing_so
rename q44_4 normal_so

*Willingness to Sit Down and Forgive South Ossetian Abkhazia
rename q45_1 hear_abk
rename q45_2 forgive_abk
rename q46_1 hear_so
rename q46_2 forgive_so


*What Should Georgia do About Ukraine
rename q47_1 send_econ_ukr
rename q47_2 send_wep_ukr
rename q47_3 send_miladv_ukr
rename q47_4 donothing_ukr
rename q47_5 support_russep


*Blame for violence in Ukraine

rename q48_1 ukr_blameukr
rename q48_2 yan_blameukr
rename q48_3 russep_blameukr
rename q48_4 nato_blameukr
rename q48_5 russia_blameukr
rename q48_6 euromaid_blameukr
rename q48_7 usa_blameukr

*Sakashvili Ivanishvili/Conspiracy Questions
**Ideology
gen sakash_good=.
replace sakash_good=1 if q49==1
*Disagree (Bad Leader)
replace sakash_good=0 if q49==2
*Neither
replace  sakash_good=0 if q49==3

**Support Sakashvili Governor of Odessa

rename q50 sakash_govukr 

**Conspiracy Questions

rename q51 ivan_realpower
rename q52 west_hurtval
**A lot of don't know
rename q53 ivan_secret_russagent


******VICTIMIZATION


*****SOUTH OSSETIA ***********

**Displaced******

**In 1989
gen displaced_so1989=0
replace displaced_so1989=1 if q55_1_2_1==1


**In 2004
gen displaced_so2004=0
replace displaced_so2004=1 if q56_1_2_1==1

***Both
gen displaced_so=0
replace displaced_so=1 if displaced_so2004==1 |displaced_so1989==1 
replace displaced_so=. if q55_1_1<0 |  q56_1_1< 0

***Physically assaulted*****

**In 1989
gen assaulted_so1989=0
replace assaulted_so1989=1 if q55_3_2_1==1

**In 2004
gen assaulted_so2004=0
replace assaulted_so2004=1 if q56_3_2_1==1


**Both

gen assaulted_so=0
replace assaulted_so=1 if assaulted_so1989==1 | assaulted_so2004==1  
replace assaulted_so=. if q55_3_1<0 |  q56_3_1<0

**Witnessed Violence****

*In 1989
gen sawviolence_so1989=0
replace sawviolence_so1989=1 if q55_7_2_1==1

*In 2004
gen sawviolence_so2004=0
replace sawviolence_so2004=1 if q56_7_2_1==1


*Both 
gen sawviolence_so=0
replace sawviolence_so=1 if sawviolence_so2004==1 |sawviolence_so1989==1
replace sawviolence_so=. if q55_7_1<0 | q56_7_1<0

***House Confiscated

*In 1989
gen housetaken_so1989=0
replace housetaken_so1989=1 if q55_2_2_1==1

*In 2004
gen housetaken_so2004=0
replace housetaken_so2004=1 if q56_2_2_1==1

*Both
gen housetaken_so=0
replace housetaken_so=1 if  housetaken_so1989==1 | housetaken_so2004==1
replace housetaken_so=. if q55_2_1<0 | q56_2_1<0 

***Property Damage***

*In 1989
gen propertydamage_so1989=0
replace propertydamage_so1989=1 if q55_6_2_1==1

*In 2004
gen propertydamage_so2004=0
replace propertydamage_so2004=1 if q56_6_2_1==1

*Both
gen propertydamage_so=0
replace propertydamage_so=1 if propertydamage_so1989==1 | propertydamage_so2004==1
replace propertydamage_so=. if q55_6_1<0 | q56_6_1<0 


***Extorted for Money***

*In 1989
gen extort_so1989=0
replace extort_so1989=1 if  q55_5_2_1==1

*In 2014
gen extort_so2004=0
replace extort_so2004=1 if  q56_5_2_1==1

*Both
gen extort_so=0
replace extort_so=1 if extort_so1989==1 | extort_so2004==1
replace extort_so=. if q55_5_1<0 | q56_5_1<0 
tab extort_so

****Abkazia

**Displaced

*In 1989
gen displaced_abk1989=0
replace displaced_abk1989=1 if q57_1_2_1==1

*In 2004
gen displaced_abk2004=0
replace displaced_abk2004=1 if q58_1_2_1==1



*Both
gen displaced_abk=0
replace displaced_abk=1 if displaced_abk1989==1 | displaced_abk2004==1
replace displaced_abk=. if q57_1_1<0 | q58_1_1<0

**Physically Assaulted

*In 1989
gen assaulted_abk1989=0
replace assaulted_abk1989=1 if q57_3_2_1==1

*In 2004.....None were assaulted
gen assaulted_abk2004=0


*Both
gen assaulted_abk=0
replace assaulted_abk=1 if assaulted_abk1989==1 
replace assaulted_abk=. if q57_3_1<0

**Witnessed Violence

*In 1989
gen sawviolence_abk1989=0
replace sawviolence_abk1989=1 if q57_7_2_1==1

*In 2004
gen sawviolence_abk2004=0
replace sawviolence_abk2004=1 if q58_7_2_1==1

*Both
gen sawviolence_abk=0
replace sawviolence_abk=1 if sawviolence_abk2004==1 | sawviolence_abk1989==1
replace sawviolence_abk=. if q57_7_1<0 | q58_7_1<0

**House Confiscated

*In 1989
gen housetaken_abk1989=0
replace housetaken_abk1989=1 if q57_2_2_1==1

*In 2004
gen housetaken_abk2004=0
replace housetaken_abk2004=1 if q58_2_2_1==1

*Both
gen housetaken_abk=0
replace housetaken_abk=1 if housetaken_abk1989==1 | housetaken_abk2004==1
replace housetaken_abk=. if q57_2_1<0 | q58_2_1<0


**Property Damage

*In 1989
gen propertydamage_abk1989=0
replace propertydamage_abk1989=1 if q57_6_2_1==1

*In 2004
gen propertydamage_abk2004=0
replace propertydamage_abk2004=1 if q58_6_2_1==1


*Both
gen propertydamage_abk=0
replace propertydamage_abk=1 if propertydamage_abk1989==1 | propertydamage_abk2004==1
replace propertydamage_abk=. if q57_6_1<0 | q58_6_1<0

***Extorted for Money***

*In 1989
gen extort_abk1989=0
replace extort_abk1989=1 if  q57_5_2_1==1

*In 2014
gen extort_abk2004=0
replace extort_abk2004=1 if  q58_5_2_1==1

*Both
gen extort_abk=0
replace extort_abk=1 if extort_abk1989==1 | extort_abk2004==1
replace extort_abk=. if q57_5_1<0 | q58_5_1<0 
tab extort_abk




****Family or friends Murdered/Killed****

*South Ossetia 1989
gen murder_so1989=0
replace murder_so1989=1 if q55_4_1==1
replace murder_so1989=. if q55_4_1<0

*South Ossetia 2004
gen murder_so2004=0
replace murder_so2004=1 if q56_4_1==1
replace murder_so2004=. if q56_4_1<0

*Abkhazia 1989
gen murder_abk1989=0
replace murder_abk1989=1 if q57_4_1==1
replace murder_abk1989=. if q57_4_1<0

*Abkhazia 2004
gen murder_abk2004=0
replace murder_abk2004=1 if q58_4_1==1
replace murder_abk1989=. if q57_4_1<0

***Number of People who have known family or friends who died
gen known_murder=0
replace known_murder=1 if murder_so1989==1 | murder_so2004==1 | murder_abk1989==1 | murder_abk2004==1
replace known_murder=. if murder_so1989==. | murder_so2004==. | murder_abk1989==. | murder_abk2004==. & known_murder==0
tab known_murder 


***Additive Index********

***South Ossetia Factor Exposure

alpha sawviolence_so assaulted_so murder_so1989 murder_so2004 housetaken_so propertydamage_so displaced_so extort_so, item gen(exposure_so)

tab exposure_so

**Abkhazia Factor Exposure (Somewhat Weird that property damage is negatively related...)
alpha sawviolence_abk assaulted_abk murder_abk1989 murder_abk2004 housetaken_abk propertydamage_abk displaced_abk extort_abk, item gen(exposure_abk)

tab exposure_abk



**Combining the Two

gen total_exposure= exposure_so + exposure_abk

tab total_exposure

**Having Total Exposure lie between 0 to 1**
replace total_exposure= total_exposure/0.875

tab total_exposure

***Scale of Both 
corr known_murder total_exposure idp_status


***Updated Violence to Include Murder



****CRIME*************************************************

*crime 12 years
gen crime_12yrs=0
replace crime_12yrs=1 if q62_1_2_1==1 | q62_2_2_1==1 | q62_3_2_1 ==1| q62_4_2_1==1 | q62_5_2_1==1 | q62_6_2_1==1 | q62_7_2_1==1 | q62_9_2_1==1 | q62_11_2_1==1 | q62_12_2_1==1
tab crime_12yrs

*crime 12 months
gen crime_1yr=0
replace crime_1yr=1 if q61_1_2_1==1 | q61_2_2_1==1 | q61_3_2_1 ==1| q61_4_2_1==1 | q61_5_2_1==1 | q61_6_2_1==1 | q61_7_2_1==1 | q61_9_2_1==1 | q61_11_2_1==1 | q61_12_2_1==1
tab crime_1yr


**Both

gen crime_both=0
replace crime_both=1 if crime_1yr==1 | crime_12yrs==1
tab crime_both

**Any of the Treatments**

gen any_treat=0
replace any_treat=1 if info_treat==1 | fear_treat==1 | anger_treat==1

**Interactions with IDP

gen infoXidp=info_treat*idp_status
gen angerXidp= anger_treat*idp_status
gen fearXidp= fear_treat*idp_status

*Interactions with Conflict Affected

gen infoXconflict=info_treat*conflict_affect
gen angerXconflict= anger_treat*conflict_affect
gen fearXconflict= fear_treat*conflict_affect


la var russia_threat "Russia is a Threat"
la var georgia_nato "Georgia Join NATO"
la var russia_angry "Russia Angry"
la var recog_abk "Recognize Abkhazia"
la var recog_so"Recognize South Ossetia"
la var anger_treat "Anger Treatment"
la var info_treat "Pure Information Treatment"
la var fear_treat "Fear Treatment"
la var any_treat "Any Treatment"
la var idp_status "IDP"
la var kutaisi "Kutaisi"
la var conflict_affected "Conflict Affected Area"
la var sakash_good "Saakashvili Support"
la var stress_index "Stress"
la var honor_index "Honor"
la var asset_index "Asset Index"
la var education "Education"
la var hh_spending "Household Spending"
la var married "Married"
la var total_exposure "Total War Exposure"
la var exposure_abk "Abkhazia Exposure"
la var exposure_so "South Ossetia Exposure"
la var male "Male"
la var known_murder "Knew Someone Murdered"
la var age "Respondent's Age"







*******Data Analysis****************************************



****Randomization Check (Passes!!!)*****

tab male, nolabel
tab age, nolabel
tab hh_spending, nolabel
tab married, nolabel
tab education, nolabel
tab idp_status, nolabel
tab total_exposure, nolabel
tab known_murder, nolabel


*****Foreign Policy
 eststo: reg male  info_treat anger_treat fear_treat  
 eststo: reg age  info_treat anger_treat fear_treat  
 eststo: reg hh_spending info_treat anger_treat fear_treat  
 eststo: reg married info_treat anger_treat fear_treat 
 eststo: reg education info_treat anger_treat fear_treat  
 eststo: reg idp_status info_treat anger_treat fear_treat 
 eststo: reg total_exposure info_treat anger_treat fear_treat 
 eststo: reg known_murder info_treat anger_treat fear_treat 

esttab using "Foreign Policy Tables/random_checks.html", replace label nogap noconstant  se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
r2 scalars("F F-statistic" "p Prob>F")
 
eststo clear



***************	Foreign Policy Experiment Hypotheses (relative to control vs informational)******


********H4	 Anger and Fear will have distinct effects from each other and from the Control on foreign policy attitudes towards Russia
******1.	Anger will lead to favoring a harder-line policy with Russia--support for joining more pro-Western groups, and helping Ukraine relative to Control and Informational treatment.
******2.	Fear will have the opposite effect, leading respondents to be less willing to challenge Russian foreign policy, and seek more accommodation.  
******H5	Anger and Fear will have distinct effects from each other and distinct from the Control and Informational treatment on foreign policy attitudes towards Abkhazia and South Ossetia
******1.	Anger will lead to favoring a harder-line policy Abkazia and South Ossetia, and less in favor of reconciliation or normalization of relations
******2.	Fear will have the opposite effect, leading those to be more in favor of reconciliation or normalization of relations

******Observational/non Experimental Hypotheses
******OH1	Respondents who have been victims of crime will have lower tolerance for corruption and the thieves in law. 
******OH2	Respondents who have been victims/IDPs will favor a more muscular policy towards Abkhazia and South Ossetia relative to those that are not
******OH3	Controlling for IDP status, respondents living closer to Abkhazia/South Ossetia will be more cautious in their dealings with South Abkhazia/South Ossetia, since they have to bear the costs of any future conflict (i.e. O3 and O4 are not mutually exclusive)
******OH5	Those who score higher on the Honor Scale will support a tougher foreign policy towards Russia
******OH6	Those who score higher on the Honor Scale will support a tougher policy towards Abkhazia and South Ossetia
******OH8	Pro-Western/Sakashvili supporters will support a tougher foreign policy towards Russia

************************Research Questions/Conjectures (***Things we are less sure about)******************************


******RQ2	Subjects in different strata will respond to the foreign policy treatment differently. I.e. our strata (Kutaisi, Tbilisi, and conflict-affected areas) will moderate the foreign policy treatments
******RQ3	Criminal and/or war victimization change the way people respond to the impunity and foreign policy treatments (i.e. moderate them)
*******RQ4	Criminal victimization will have a distinct effect on attitudes towards rule of law relative to war victimization/IDP status
******RQ5	Criminal victimization will have a distinct effect on attitudes towards foreign policy law relative to war victimization/IDP status
******RQ6	The Elite Impunity treatment will have distinct effects from the General Impunity treatment
******RQ7	The Equality of Justice Treatment will have distinct effects from the General and Elite Treatment, as well as the control
*******RQ8	In the foreign policy treatment, the Information treatment will shift foreign policy attitudes relative to the Control 
******RQ9	The Honor Scale will have a distinct effect from the Stuckless and Goranson Vengeance Scale (1992) on attitudes towards justice and impunity
******RQ10	The Honor Scale will have a distinct effect from the Stuckless and Goranson Vengeance Scale (1992) on foreign policy attitudes



****Summary Statistics IVs****

estpost summarize idp_status kutaisi conflict_affected total_exposure exposure_so exposure_abk known_murder stress_index honor_index sakash_good education age male married hh_spending
esttab using "Foreign Policy Tables/summary_stats_IVs.html", label cells("min(fmt(0)) max mean(fmt(2)) sd(fmt(2)) count") noobs rtf replace 

eststo clear

***Summary Statisticss DV

*******Just for the purpose of creating summary stats table--
****creating new DVs that are the same as the old DVs with no missing values!!!!!!!***

gen ss_russia_threat=.
replace ss_russia_threat= russia_threat if russia_threat>0

gen ss_georgia_nato=.
replace ss_georgia_nato= georgia_nato if georgia_nato>0

gen ss_russia_angry=.
replace ss_russia_angry= russia_angry if russia_angry>0

gen ss_recog_abk=.
replace ss_recog_abk= recog_abk if recog_abk >0

gen ss_recog_so=.
replace ss_recog_so= recog_so if recog_so >0


la var ss_russia_threat "Russia is a Threat"
la var ss_georgia_nato "Georgia Join NATO"
la var ss_russia_angry "Russia Angry"
la var ss_recog_abk "Recognize Abkhazia"
la var ss_recog_so"Recognize South Ossetia"

estpost summarize ss_russia_threat ss_georgia_nato ss_russia_angry ss_recog_abk ss_recog_so 
esttab using "Foreign Policy Tables/summary_stats_DVs.html", label cells("min max mean(fmt(2)) sd(fmt(2)) count") noobs rtf replace 

eststo clear




**************FOREIGN POLICY EXPERIMENT******************************************


 




***Russia Threat****************************************

*How much of a threat, if |
*    at all, is Russia to |
*                Georgia? |      Freq.     Percent        Cum.
*-------------------------+-----------------------------------
*               Break off |          1        0.08        0.08
*       Interviewer error |          3        0.25        0.33
*        Refuse to answer |         16        1.31        1.64
*              Don't know |         74        6.05        7.69
*            Minor threat |         89        7.28       14.96
*         Moderate threat |         79        6.46       21.42
*          Serious threat |        260       21.26       42.68
*     Very serious threat |        400       32.71       75.39
*Extremely serious threat |        301       24.61      100.00
*-------------------------+-----------------------------------
*                   Total |      1,223      100.00




replace russia_threat= (russia_threat-1)/4 if russia_threat>0
tab russia_threat, nolabel
sum russia_threat if russia_threat>=0

eststo clear

****Treatment Only***

 eststo: reg russia_threat info_treat anger_treat fear_treat if russia_threat>=0, cluster(psu)

estadd local controls "No"
**Difference Between Treatments**

*Difference Between Information Treatment and Anger Treatment
lincom info_treat-anger_treat
*Difference Between Information Treatment and Fear Treatment
lincom info_treat-fear_treat
*Difference Between Anger Treatment and Fear Treatment
lincom anger_treat-fear_treat

***Strata Dummies + IDP Status*** 

 eststo: reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected idp_status  if russia_threat>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if russia_threat>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if russia_threat>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if russia_threat>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if russia_threat>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if russia_threat>=0, cluster(psu)

 estadd local controls "Yes"

esttab using "Foreign Policy Tables/russia_threat_all.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear

*****Combining all the Treatment***

****Treatment Only***

 eststo: reg russia_threat any_treat if russia_threat>=0, cluster(psu)
estadd local controls "No"



***Strata Dummies + IDP Status*** 

 eststo: reg russia_threat any_treat kutaisi conflict_affected idp_status  if russia_threat>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if russia_threat>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg russia_threat any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if russia_threat>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg russia_threat any_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if russia_threat>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg russia_threat any_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if russia_threat>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg russia_threat any_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if russia_threat>=0, cluster(psu)

 estadd local controls "Yes"


esttab using "Foreign Policy Tables/russia_threat_any.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear



**Georgia NATO****************************************
*Georgia should join NATO |
*  even if Russia threatens |
*             it militarily |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         18        1.47        1.55
*                Don't know |        249       20.36       21.91
*         Strongly disagree |         76        6.21       28.13
*         Disagree a little |        211       17.25       45.38
*Neither agree nor disagree |        251       20.52       65.90
*            Agree a little |        304       24.86       90.76
*            Strongly agree |        113        9.24      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00

replace georgia_nato= (georgia_nato-1)/4 if georgia_nato>0
tab georgia_nato, nolabel
sum georgia_nato if georgia_nato>=0

****Treatment Only***

eststo: reg georgia_nato info_treat anger_treat fear_treat if georgia_nato>=0, cluster(psu)
estadd local controls "No"

**Difference Between Treatments**

*Difference Between Information Treatment and Anger Treatment
lincom info_treat-anger_treat
*Difference Between Information Treatment and Fear Treatment
lincom info_treat-fear_treat
*Difference Between Anger Treatment and Fear Treatment
lincom anger_treat-fear_treat

***Strata Dummies + IDP Status*** 

 eststo: reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected idp_status  if georgia_nato>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if georgia_nato>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if georgia_nato>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if georgia_nato>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if georgia_nato>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if georgia_nato>=0, cluster(psu)

 estadd local controls "Yes"


esttab using "Foreign Policy Tables/georgia_nato_all.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear

*****Combining all the Treatment***

****Treatment Only***

 eststo: reg georgia_nato any_treat if georgia_nato>=0, cluster(psu)
estadd local controls "No"



***Strata Dummies + IDP Status*** 

 eststo: reg georgia_nato any_treat kutaisi conflict_affected idp_status  if georgia_nato>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg georgia_nato any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if georgia_nato>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg georgia_nato any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if georgia_nato>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg georgia_nato any_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if georgia_nato>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg georgia_nato any_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if georgia_nato>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg georgia_nato any_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if georgia_nato>=0, cluster(psu)

 estadd local controls "Yes"


esttab using "Foreign Policy Tables/georgia_nato_any.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear




**Russia Angry****************************************
*     How angry do |
* Russia's actions |
*    in the region |
*        make you? |      Freq.     Percent        Cum.
*------------------+-----------------------------------
*        Break off |          1        0.08        0.08
* Refuse to answer |         16        1.31        1.39
*       Don't know |         54        4.42        5.81
* Not angry at all |         59        4.82       10.63
*   A little angry |        143       11.69       22.32
*            Angry |        476       38.92       61.24
*      Very angry  |        273       22.32       83.57
*  Extremely angry |        201       16.43      100.00
*------------------+-----------------------------------
*            Total |      1,223      100.00



replace russia_angry= (russia_angry-1)/4 if russia_angry>0
tab russia_angry, nolabel
sum russia_angry if russia_angry>=0

****Treatment Only***

eststo: reg russia_angry info_treat anger_treat fear_treat if russia_angry>=0, cluster(psu)
estadd local controls "No"
**Difference Between Treatments**

*Difference Between Information Treatment and Anger Treatment
lincom info_treat-anger_treat
*Difference Between Information Treatment and Fear Treatment
lincom info_treat-fear_treat
*Difference Between Anger Treatment and Fear Treatment
lincom anger_treat-fear_treat

***Strata Dummies + IDP Status*** 

 eststo: reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected idp_status  if russia_angry>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if russia_angry>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if russia_angry>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if russia_angry>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if russia_angry>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if russia_angry>=0, cluster(psu)

 estadd local controls "Yes"

esttab using "Foreign Policy Tables/russia_angry_all.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear

*****Combining all the Treatment***

****Treatment Only***

eststo: reg russia_angry any_treat if russia_angry>=0, cluster(psu)
estadd local controls "No"

***Strata Dummies + IDP Status*** 

 eststo: reg russia_angry any_treat kutaisi conflict_affected idp_status  if russia_angry>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if russia_angry>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg russia_angry any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if russia_angry>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg russia_angry any_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if russia_angry>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg russia_angry any_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if russia_angry>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg russia_angry any_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if russia_angry>=0, cluster(psu)

 estadd local controls "Yes"
esttab using "Foreign Policy Tables/russia_angry_any.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear


*Recognize Abkhazia**********************************************************************
*  To reduce tensions with |
*    Russia, Georgia should |
*      recognize Abkhazia's |
*              independence |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*         Interviewer error |          1        0.08        0.16
*          Refuse to answer |         12        0.98        1.14
*                Don't know |         69        5.64        6.79
*         Strongly disagree |        594       48.57       55.36
*         Disagree a little |        406       33.20       88.55
*Neither agree nor disagree |         42        3.43       91.99
*            Agree a little |         74        6.05       98.04
*            Strongly agree |         24        1.96      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00



replace recog_abk= (recog_abk-1)/4 if recog_abk>0
tab recog_abk, nolabel
sum recog_abk if recog_abk>=0

****Treatment Only***

eststo: reg recog_abk info_treat anger_treat fear_treat if recog_abk>=0, cluster(psu)
estadd local controls "No"

**Difference Between Treatments**

*Difference Between Information Treatment and Anger Treatment
lincom info_treat-anger_treat
*Difference Between Information Treatment and Fear Treatment
lincom info_treat-fear_treat
*Difference Between Anger Treatment and Fear Treatment
lincom anger_treat-fear_treat

***Strata Dummies + IDP Status*** 

 eststo: reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected idp_status  if recog_abk>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if recog_abk>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if recog_abk>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if recog_abk>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if recog_abk>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if recog_abk>=0, cluster(psu)

 estadd local controls "Yes"

esttab using "Foreign Policy Tables/recog_abk_all.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear


*****Combining all the Treatment***

****Treatment Only***

eststo: reg recog_abk any_treat if recog_abk>=0, cluster(psu)
estadd local controls "No"

***Strata Dummies + IDP Status*** 

 eststo: reg recog_abk any_treat kutaisi conflict_affected idp_status  if recog_abk>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg recog_abk any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if recog_abk>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg recog_abk any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if recog_abk>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg recog_abk any_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if recog_abk>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg recog_abk any_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if recog_abk>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg recog_abk any_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if recog_abk>=0, cluster(psu)

esttab using "Foreign Policy Tables/recog_abk_any.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear

					 
*Recognize South Ossetia**********************************************************************

*   To reduce tensions with |
*    Russia, Georgia should |
*            recognize SO's |
*              independence |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*         Interviewer error |          2        0.16        0.25
*          Refuse to answer |         12        0.98        1.23
*                Don't know |         69        5.64        6.87
*         Strongly disagree |        597       48.81       55.68
*         Disagree a little |        410       33.52       89.21
*Neither agree nor disagree |         40        3.27       92.48
*            Agree a little |         75        6.13       98.61
*            Strongly agree |         17        1.39      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00


replace recog_so= (recog_so-1)/4 if recog_so>=0
tab recog_so, nolabel
sum recog_so if recog_so>=0

****Treatment Only***

eststo: reg recog_so info_treat anger_treat fear_treat if recog_so>=0, cluster(psu)
estadd local controls "No"

**Difference Between Treatments**

*Difference Between Information Treatment and Anger Treatment
lincom info_treat-anger_treat
*Difference Between Information Treatment and Fear Treatment
lincom info_treat-fear_treat
*Difference Between Anger Treatment and Fear Treatment
lincom anger_treat-fear_treat

***Strata Dummies + IDP Status*** 

 eststo: reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected idp_status  if recog_abk>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if recog_abk>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if recog_abk>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if recog_abk>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if recog_abk>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if recog_abk>=0, cluster(psu)

 estadd local controls "Yes"
esttab using "Foreign Policy Tables/recog_so_all.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear



*****Combining all the Treatment***

****Treatment Only***

eststo: reg recog_so any_treat if recog_so>=0, cluster(psu)
estadd local controls "No"

***Strata Dummies + IDP Status*** 

 eststo: reg recog_so any_treat kutaisi conflict_affected idp_status  if recog_so>=0, cluster(psu)

estadd local controls "No"
***Strata Dummies + Demographics +Political Orientation*** 

 eststo: reg recog_so any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending if recog_so>=0, cluster(psu)
estadd local controls "Yes"

***Strata Dummies + Demographics +Psych Variables*** 

 eststo: reg recog_so any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if recog_so>=0, cluster(psu)

estadd local controls "Yes"

***Strata Dummies + Demographics +Known_Murder*** 


 eststo: reg recog_so any_treat kutaisi conflict_affected sakash_good known_murder education age male married hh_spending  if recog_so>=0, cluster(psu)

estadd local controls "Yes"
***Strata Dummies + Demographics +Total Exposure*** 

 eststo: reg recog_so any_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending  if recog_so>=0, cluster(psu)

 estadd local controls "Yes"
 
 ***Strata Dummies + Demographics + Separate Abk + Separate South Ossetia Expsoure*** 

 eststo: reg recog_so any_treat kutaisi conflict_affected sakash_good exposure_so exposure_abk education age male married hh_spending  if recog_so>=0, cluster(psu)


esttab using "Foreign Policy Tables/recog_so_any.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear


*************COMBINING ANGER/THREAT AND RECOGNITION INTO ONE COMBINED VARIABLES*******

**Negative Affect Combining Threat+ Anger
alpha russia_threat russia_angry if russia_threat>=0 & russia_angry>=0, item gen(negative_affect)

la var negative_affect "Negative Affect (Anger + Threat)"

**Disaggregated Treatments
eststo: reg negative_affect info_treat anger_treat fear_treat kutaisi conflict_affected idp_status, cluster(psu)


**Any Treatments
eststo: reg negative_affect any_treat kutaisi conflict_affected idp_status, cluster(psu)



****Combinding Recog South Ossetia and Recog Abkhazia

alpha recog_so recog_abk if recog_so>=0 & recog_abk>=0, item gen(recog_regions)

la var recog_regions "Recognizing Regions (South Oss. + Abk.)"

**Disaggregated Treatments
eststo: reg recog_regions info_treat anger_treat fear_treat kutaisi conflict_affected idp_status, cluster(psu)


**Any Treatments
eststo: reg recog_regions any_treat kutaisi conflict_affected idp_status, cluster(psu)




esttab using "Foreign Policy Tables/combined_affect_recognition.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 r2 addnotes ("Note standard errors clustered at the voting precinct-level (PSU). ")
 


eststo clear

************CORRELATIONS BETWEEN EMOTIONS and POLICY*********************

***Correlations

*Exposure Measures
corr conflict_affected idp_status known_murder total_exposure exposure_so exposure_abk

**Across Our DVs
corr russia_threat russia_angry georgia_nato recog_abk recog_so if russia_threat>=0 & russia_angry >=0 & georgia_nato>=0 & recog_abk>=0 & recog_so>=0


**Correlation Between Emotions and Policy

eststo clear

****NATO****
eststo: reg georgia_nato russia_threat russia_angry if russia_threat>=0 & russia_angry>=0 & georgia_nato>=0, cluster(psu)
*With Controls
eststo: reg georgia_nato russia_threat russia_angry education age male married hh_spending if russia_threat>=0 & russia_angry>=0 & georgia_nato>=0, cluster(psu)
estadd local controls "Yes"
**Only In the Control Condition
eststo: reg georgia_nato russia_threat russia_angry if russia_threat>=0 & russia_angry>=0 & georgia_nato>=0 & any_treat==0, cluster(psu)
 
**Abkhazia***
eststo: reg recog_abk russia_threat russia_angry if russia_threat>=0 & russia_angry>=0 & recog_abk>=0, cluster(psu)
*With Controls
eststo: reg recog_abk russia_threat russia_angry  education age male married hh_spending if russia_threat>=0 & russia_angry>=0 & recog_abk>=0, cluster(psu)
estadd local controls "Yes"
**Only In the Control Condition
eststo: reg recog_abk russia_threat russia_angry if russia_threat>=0 & russia_angry>=0 & recog_abk>=0 & any_treat==0, cluster(psu)

***South Ossetia*** 
eststo: reg recog_so russia_threat russia_angry if russia_threat>=0 & russia_angry>=0 & recog_so>=0, cluster(psu)
*With Controls
eststo: reg recog_so russia_threat russia_angry education age male married hh_spending if russia_threat>=0 & russia_angry>=0 & recog_so>=0, cluster(psu)
estadd local controls "Yes"
**Only In the Control Condition
eststo: reg recog_so russia_threat russia_angry if russia_threat>=0 & russia_angry>=0 & recog_so>=0 & any_treat==0, cluster(psu)


esttab using "Foreign Policy Tables/corr_emotions_policies.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
 scalars("controls Controls") r2 drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")


eststo clear


**Making sure that the first treatment doesn't affect the results

**Russia Threat
reg russia_threat info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending general_imp elite_imp equality if russia_threat>=0, cluster(psu)

*Russia Angry
reg russia_angry info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending general_imp elite_imp equality if russia_angry>=0, cluster(psu)

**Join Nato
reg georgia_nato info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending general_imp elite_imp equality if georgia_nato>=0, cluster(psu)

**Recognize South Ossetia
reg recog_so info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending general_imp elite_imp equality if recog_so>=0, cluster(psu)


**Recognize Abkhazia
reg recog_abk info_treat anger_treat fear_treat kutaisi conflict_affected sakash_good total_exposure education age male married hh_spending general_imp elite_imp equality if recog_abk>=0, cluster(psu)


**MEDIATON STUFF....ARe the treatments effects mediated by Threat/Anger?***************************************************************

***Correlation Across Threat, Anger, Georgia Joining Nato, Recognizing Abkahzia, Recognizing South Ossetia
corr russia_threat russia_angry georgia_nato recog_abk recog_so if russia_threat>=0 & russia_angry>=0 & georgia_nato>=0 & recog_abk>=0 & recog_so>=0


**Quick Refresher...treatments don't have any effect on Threat, but IDP Status/Total Violence Exposure does 

**Threat**********************

**IDP Status***

regress russia_threat any_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending if russia_threat>=0, cluster(psu)


**Total Violence Exposure**

regress russia_threat any_treat total_exp kutaisi conflict_affected sakash_good education age male married hh_spending if russia_threat>=0, cluster(psu)


**Anger***********************

**IDP Status***

regress russia_angry any_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending if russia_angry>=0, cluster(psu)


**Total Violence Exposure**
regress russia_angry any_treat total_exp kutaisi conflict_affected sakash_good education age male married hh_spending if russia_angry>=0, cluster(psu)


***BREAK*******************************************************
***BREAK*******************************************************
***BREAK*******************************************************
***BREAK*******************************************************
***BREAK*******************************************************



***Georgia Joining NATO***********************************************************

**ATE (effect of receiving any treatment)
reg georgia_nato any_treat if georgia_nato>=0, cluster(psu)

**Effect of Being IDP**
reg georgia_nato idp_status if georgia_nato>=0, cluster(psu)

**Effect of Total Exposure**
reg georgia_nato total_exposure if georgia_nato>=0, cluster(psu)


** Effects of treatment + IDP Status (with Controls)
reg georgia_nato any_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending if georgia_nato>=0, cluster(psu)


**Effects of treatment + Total Exposure to violence (with Control)s 
reg georgia_nato any_treat total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending if georgia_nato>=0, cluster(psu)


***MEDIATION EFFECTS ******

*Mediation Effect of Treatment Through Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress georgia_nato russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_threat>=0 & georgia_nato>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(any_treat)

*Mediation Effect of Treatment Through Anger at Russia
medeff (regress russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress georgia_nato russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_angry>=0 & georgia_nato>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(any_treat)


****EXPOSURE TO VIOLENCE****

**Mediation Effect of being  an IDP via Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress georgia_nato russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_threat>=0 & georgia_nato>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(idp_status)


**Mediation Effect of being an IDP via Anger 
medeff (regress russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress georgia_nato russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_angry>=0 & georgia_nato>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(idp_status)


**Mediation Effect of Total Exposure via Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) (regress georgia_nato russia_threat any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) if russia_threat>=0 & georgia_nato>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(total_exposure)


**Mediation Effect of Total Exposure via Anger
 
medeff (regress russia_angry any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) (regress georgia_nato russia_angry any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) if russia_angry>=0 & georgia_nato>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(total_exposure)






***Recognize Abkhazia********************************************************************

**ATE (effect of receiving any treatment)
reg recog_abk any_treat if recog_abk>=0, cluster(psu)

**Effect of Being IDP**
reg recog_abk idp_status if recog_abk>=0, cluster(psu)

**Effect of Total Exposure**
reg recog_abk total_exposure if recog_abk>=0, cluster(psu)



** Effects of treatment + IDP Status (with Controls)
reg recog_abk any_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending if recog_abk>=0, cluster(psu)


**Effects of treatment + Total Exposure to violence (with Control)s 
reg recog_abk any_treat total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending if recog_abk>=0, cluster(psu)


***MEDIATION EFFECTS ******

*Mediation Effect of Treatment Through Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_abk russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_threat>=0 & recog_abk>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(any_treat)

*Mediation Effect of Treatment Through Anger at Russia
medeff (regress russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_abk russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_angry>=0 & recog_abk>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(any_treat)


****EXPOSURE TO VIOLENCE****

**Mediation Effect of being  an IDP via Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_abk russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_threat>=0 & recog_abk>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(idp_status)


**Mediation Effect of being an IDP via Anger 
medeff (regress russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_abk russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_angry>=0 & recog_abk>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(idp_status)


**Mediation Effect of Total Exposure via Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) (regress recog_abk russia_threat any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) if russia_threat>=0 & recog_abk>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(total_exposure)


**Mediation Effect of Total Exposure via Anger
 
medeff (regress russia_angry any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) (regress recog_abk russia_angry any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) if russia_angry>=0 & recog_abk>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(total_exposure)


****************Recognizing South Ossetia*********************************************

**ATE (effect of receiving any treatment)
reg recog_so any_treat if recog_so>=0, cluster(psu)

**Effect of Being IDP**
reg recog_so idp_status if recog_so>=0, cluster(psu)

**Effect of Total Exposure**
reg recog_so total_exposure if recog_so>=0, cluster(psu)

** Effects of treatment + IDP Status (with Controls)
reg recog_so any_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending if recog_so>=0, cluster(psu)


**Effects of treatment + Total Exposure to violence (with Control)s 
reg recog_so any_treat total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending if recog_so>=0, cluster(psu)


***MEDIATION EFFECTS ******

*Mediation Effect of Treatment Through Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_so russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_threat>=0 & recog_so>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(any_treat)

*Mediation Effect of Treatment Through Anger at Russia
medeff (regress russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_so russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_angry>=0 & recog_so>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(any_treat)


****EXPOSURE TO VIOLENCE****

**Mediation Effect of being  an IDP via Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_so russia_threat any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_threat>=0 & recog_so>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(idp_status)


**Mediation Effect of being an IDP via Anger 
medeff (regress russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) (regress recog_so russia_angry any_treat kutaisi conflict_affected idp_status sakash_good education age male married hh_spending) if russia_angry>=0 & recog_so>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(idp_status)


**Mediation Effect of Total Exposure via Threat
medeff (regress russia_threat any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) (regress recog_so russia_threat any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) if russia_threat>=0 & recog_so>=0 , vce(cluster psu) mediate(russia_threat) sims(1000) treat(total_exposure)


**Mediation Effect of Total Exposure via Anger
 
medeff (regress russia_angry any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) (regress recog_so russia_angry any_treat kutaisi conflict_affected total_exposure sakash_good education age male married hh_spending) if russia_angry>=0 & recog_so>=0 , vce(cluster psu) mediate(russia_angry) sims(1000) treat(total_exposure)


******Structural Equation Modeling Mediation Effects*************************************************

***Georgia Should Join Nato
/*
sem (idp_status any_treat kutaisi conflict_affected sakash_good education age male married hh_spending -> russia_angry, ) /// 
(idp_status any_treat kutaisi conflict_affected sakash_good education age male married hh_spending -> russia_threat, ) ///
(idp_status any_treat russia_angry russia_threat kutaisi conflict_affected sakash_good education age male married hh_spending -> georgia_nato, ) ///
if russia_threat>=0 & russia_angry>=0& georgia_nato>=0, vce(cluster psu) 


**Bootstrap Effects***

bootstrap ///
 ind_idp_anger= ([russia_angry]_b[idp_status]*[georgia_nato]_b[russia_angry]) ///
 ind_idp_threat = ([russia_threat]_b[idp_status]*[georgia_nato]_b[russia_threat]) ///
 ind_treat_anger = ([russia_angry]_b[any_treat]* [georgia_nato]_b[russia_angry]) ///
 ind_treat_threat = ([russia_threat]_b[any_treat]*[georgia_nato]_b[russia_threat]) ///
 dir_idp = ([georgia_nato]_b[idp_status]) ///
 dir_treat = ([georgia_nato]_b[any_treat]) ///
 proportion_indirect= (([russia_angry]_b[idp_status]*[georgia_nato]_b[russia_angry] ///
 + [russia_threat]_b[idp_status]*[georgia_nato]_b[russia_threat] ///
 + [russia_angry]_b[any_treat]*[georgia_nato]_b[russia_angry] ///
 + [russia_threat]_b[any_treat]*[georgia_nato]_b[russia_threat]) ///
 / ///
 ([russia_angry]_b[idp_status]*[georgia_nato]_b[russia_angry]+ ///
 [russia_threat]_b[idp_status]*[georgia_nato]_b[russia_threat] ///
 + [russia_angry]_b[any_treat]*[georgia_nato]_b[russia_angry] ///
 + [russia_threat]_b[any_treat]*[georgia_nato]_b[russia_threat] ///
 + [georgia_nato]_b[idp_status]+ [georgia_nato]_b[any_treat] )) ///
 , reps (500) seed(123): ///
 sem (idp_status any_treat kutaisi conflict_affected sakash_good education age ///
 male married hh_spending -> russia_angry, ) (idp_status any_treat kutaisi ///
 conflict_affected sakash_good education age male married hh_spending -> russia_threat, ) ///
 (idp_status any_treat russia_angry russia_threat kutaisi conflict_affected ///
 sakash_good education age male married hh_spending -> georgia_nato,) ///
 if russia_threat>=0 & russia_angry>=0 & georgia_nato>=0, vce(cluster psu)

***All the Bootstrapped Standard Errors**
estat bootstrap, all
*/

*****Recognizing Abkhazia
/*
sem (idp_status any_treat kutaisi conflict_affected sakash_good education age male married hh_spending -> russia_angry, ) /// 
(idp_status any_treat kutaisi conflict_affected sakash_good education age male married hh_spending -> russia_threat, ) ///
(idp_status any_treat russia_angry russia_threat kutaisi conflict_affected sakash_good education age male married hh_spending -> recog_abk, ) ///
if russia_threat>=0 & russia_angry>=0& recog_abk>=0, vce(cluster psu)

**Boostrap Effects
bootstrap ///
 ind_idp_anger= ([russia_angry]_b[idp_status]*[recog_abk]_b[russia_angry]) ///
 ind_idp_threat = ([russia_threat]_b[idp_status]*[recog_abk]_b[russia_threat]) ///
 ind_treat_anger = ([russia_angry]_b[any_treat]* [recog_abk]_b[russia_angry]) ///
 ind_treat_threat = ([russia_threat]_b[any_treat]*[recog_abk]_b[russia_threat]) ///
 dir_idp = ([recog_abk]_b[idp_status]) ///
 dir_treat = ([recog_abk]_b[any_treat]) ///
 proportion_indirect= (([russia_angry]_b[idp_status]*[recog_abk]_b[russia_angry] ///
 + [russia_threat]_b[idp_status]*[recog_abk]_b[russia_threat] ///
 + [russia_angry]_b[any_treat]*[recog_abk]_b[russia_angry] ///
 + [russia_threat]_b[any_treat]*[recog_abk]_b[russia_threat]) ///
 / ///
 ([russia_angry]_b[idp_status]*[recog_abk]_b[russia_angry]+ ///
 [russia_threat]_b[idp_status]*[recog_abk]_b[russia_threat] ///
 + [russia_angry]_b[any_treat]*[recog_abk]_b[russia_angry] ///
 + [russia_threat]_b[any_treat]*[recog_abk]_b[russia_threat] ///
 + [recog_abk]_b[idp_status]+ [recog_abk]_b[any_treat] )) ///
 , reps (500) seed(123): ///
 sem (idp_status any_treat kutaisi conflict_affected sakash_good education age ///
 male married hh_spending -> russia_angry, ) (idp_status any_treat kutaisi ///
 conflict_affected sakash_good education age male married hh_spending -> russia_threat, ) ///
 (idp_status any_treat russia_angry russia_threat kutaisi conflict_affected ///
 sakash_good education age male married hh_spending -> recog_abk,) ///
 if russia_threat>=0 & russia_angry>=0 & recog_abk>=0, vce(cluster psu)

***All the Bootstrapped Standard Errors**
estat bootstrap, all
*/

***********Recognizing South Ossetia******
/*
sem (idp_status any_treat kutaisi conflict_affected sakash_good education age male married hh_spending -> russia_angry, ) /// 
(idp_status any_treat kutaisi conflict_affected sakash_good education age male married hh_spending -> russia_threat, ) ///
(idp_status any_treat russia_angry russia_threat kutaisi conflict_affected sakash_good education age male married hh_spending -> recog_so, ) ///
if russia_threat>=0 & russia_angry>=0& recog_so>=0, vce(cluster psu)

**Boostrap Effects
bootstrap ///
 ind_idp_anger= ([russia_angry]_b[idp_status]*[recog_so]_b[russia_angry]) ///
 ind_idp_threat = ([russia_threat]_b[idp_status]*[recog_so]_b[russia_threat]) ///
 ind_treat_anger = ([russia_angry]_b[any_treat]* [recog_so]_b[russia_angry]) ///
 ind_treat_threat = ([russia_threat]_b[any_treat]*[recog_so]_b[russia_threat]) ///
 dir_idp = ([recog_so]_b[idp_status]) ///
 dir_treat = ([recog_so]_b[any_treat]) ///
 proportion_indirect= (([russia_angry]_b[idp_status]*[recog_so]_b[russia_angry] ///
 + [russia_threat]_b[idp_status]*[recog_so]_b[russia_threat] ///
 + [russia_angry]_b[any_treat]*[recog_so]_b[russia_angry] ///
 + [russia_threat]_b[any_treat]*[recog_so]_b[russia_threat]) ///
 / ///
 ([russia_angry]_b[idp_status]*[recog_so]_b[russia_angry]+ ///
 [russia_threat]_b[idp_status]*[recog_so]_b[russia_threat] ///
 + [russia_angry]_b[any_treat]*[recog_so]_b[russia_angry] ///
 + [russia_threat]_b[any_treat]*[recog_so]_b[russia_threat] ///
 + [recog_so]_b[idp_status]+ [recog_so]_b[any_treat] )) ///
 , reps (500) seed(123): ///
 sem (idp_status any_treat kutaisi conflict_affected sakash_good education age ///
 male married hh_spending -> russia_angry, ) (idp_status any_treat kutaisi ///
 conflict_affected sakash_good education age male married hh_spending -> russia_threat, ) ///
 (idp_status any_treat russia_angry russia_threat kutaisi conflict_affected ///
 sakash_good education age male married hh_spending -> recog_so,) ///
 if russia_threat>=0 & russia_angry>=0 & recog_so>=0, vce(cluster psu)

***All the Bootstrapped Standard Errors**
estat bootstrap, all
*/





***Comparing non-IDPs to IDPs

eststo clear
**Russia Threat************

***IDPs
 eststo: reg russia_threat info_treat anger_treat fear_treat if idp_status==1 & russia_threat>=0, cluster(psu)

**Non-IDPs
 eststo: reg russia_threat info_treat anger_treat fear_treat if idp_status==0 & russia_threat>=0, cluster(psu)

**Russia Angry************
***IDPs
 eststo: reg russia_angry info_treat anger_treat fear_treat if idp_status==1 & russia_angry>=0, cluster(psu)

**Non-IDPs
 eststo: reg russia_angry info_treat anger_treat fear_treat if idp_status==0 & russia_angry>=0 , cluster(psu)


**Georgia NATO************
***IDPs
 eststo: reg georgia_nato info_treat anger_treat fear_treat if idp_status==1 & georgia_nato>=0, cluster(psu)

**Non-IDPs
 eststo: reg georgia_nato info_treat anger_treat fear_treat if idp_status==0 &  georgia_nato>=0, cluster(psu)


*Recog South Ossetia************
***IDPs
 eststo: reg recog_so info_treat anger_treat fear_treat if idp_status==1 & recog_so>=0, cluster(psu)

**Non-IDPs
 eststo: reg recog_so info_treat anger_treat fear_treat if idp_status==0 & recog_so>=0, cluster(psu)

**Recog Abkhazia************
***IDPs
 eststo: reg recog_abk info_treat anger_treat fear_treat if idp_status==1 & recog_abk>=0, cluster(psu)

**Non-IDPs
 eststo: reg recog_abk info_treat anger_treat fear_treat if idp_status==0 &  recog_abk>=0, cluster(psu)

esttab using "Foreign Policy Tables/compare_idps_to_non_idps.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
scalars("controls Controls") r2 drop(_cons) addnotes ("Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear


****Any Treatment IDPs vs. Non-IDPs
**Russia Threat************

***IDPs
 eststo: reg russia_threat any_treat if idp_status==1 & russia_threat>=0, cluster(psu)

**Non-IDPs
 eststo: reg russia_threat any_treat if idp_status==0 & russia_threat>=0, cluster(psu)

**Russia Angry************
***IDPs
 eststo: reg russia_angry any_treat if idp_status==1 & russia_angry>=0, cluster(psu)

**Non-IDPs
 eststo: reg russia_angry any_treat if idp_status==0 & russia_angry>=0, cluster(psu)


**Georgia NATO************
***IDPs
 eststo: reg georgia_nato any_treat if idp_status==1 & georgia_nato>=0, cluster(psu)

**Non-IDPs
 eststo: reg georgia_nato any_treat if idp_status==0 & georgia_nato>=0, cluster(psu)


*Recog South Ossetia************
***IDPs
 eststo: reg recog_so any_treat if idp_status==1 & recog_so>=0, cluster(psu)

**Non-IDPs
 eststo: reg recog_so any_treat if idp_status==0 & recog_so>=0, cluster(psu)

**Recog Abkhazia************
***IDPs
 eststo: reg recog_abk any_treat if idp_status==1 & recog_abk>=0, cluster(psu)

**Non-IDPs
 eststo: reg recog_abk any_treat if idp_status==0 & recog_abk>=0, cluster(psu)

esttab using "Foreign Policy Tables/compare_idps_to_non_idps_anytreat.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
scalars("controls Controls") r2 drop(_cons) addnotes ("Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear
 
***Ordered Probit Check****

**Russia Threat**

eststo: oprobit russia_threat any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if russia_threat>=0, cluster(psu)
estadd local controls "Yes"

**Russia Angry
eststo: oprobit russia_angry any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if russia_angry>=0, cluster(psu)
estadd local controls "Yes"

**Russia Nato
eststo: oprobit georgia_nato any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if georgia_nato>=0, cluster(psu)
estadd local controls "Yes"

**Recognize Abkhazia**
eststo: oprobit recog_abk any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if recog_abk>=0, cluster(psu)
estadd local controls "Yes"

**Recognize South Ossetia
eststo: oprobit recog_so any_treat kutaisi conflict_affected idp_status sakash_good stress_index honor_index education age male married hh_spending  if recog_so>=0, cluster(psu)
estadd local controls "Yes"

esttab using "Foreign Policy Tables/oprobit_all.html", replace label nogap onecell se(%8.2f) b(%8.2f) star(* .10 ** .05 *** .01) ///
stats(N r2_p, fmt(%8.2f)) scalars("controls Controls")  drop(_cons education age male married hh_spending) addnotes ("Controls include age, sex, marital status, education, and monthly household spending. Note standard errors clustered at the voting precinct-level (PSU). ")
 
eststo clear
 

***Interaction Effect***

*Gen Total Exposure Interaction Effects
gen infoXexpo= info_treat*total_exposure
gen angerXexpo= anger_treat*total_exposure
gen fearXexpo= fear_treat*total_exposure


*Russia ThreaT*

*IDP Status
reg russia_threat info_treat anger_treat fear_treat infoXidp angerXidp fearXidp idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if russia_threat>=0, cluster(psu)

lincom info_treat+ infoXidp
lincom anger_treat+ angerXidp
lincom fear_treat+ fearXidp


*Conflict Exposure
reg russia_threat info_treat anger_treat fear_treat infoXexpo angerXexpo fearXexpo total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending  if russia_threat>=0, cluster(psu)

lincom info_treat+ infoXexpo
lincom anger_treat+ angerXexpo
lincom fear_treat+ fearXexpo


*Georgia Nato*

*IDP Status
reg georgia_nato info_treat anger_treat fear_treat infoXidp angerXidp fearXidp idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if georgia_nato>=0, cluster(psu)

lincom info_treat+ infoXidp
lincom anger_treat+ angerXidp
lincom fear_treat+ fearXidp


*Conflict Exposure
reg georgia_nato info_treat anger_treat fear_treat infoXexpo angerXexpo fearXexpo total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending  if georgia_nato>=0, cluster(psu)

lincom info_treat+ infoXexpo
lincom anger_treat+ angerXexpo
lincom fear_treat+ fearXexpo

**Russia Angry*

*IDP Status
reg russia_angry info_treat anger_treat fear_treat infoXidp angerXidp fearXidp idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if russia_angry>=0, cluster(psu)

lincom info_treat+ infoXidp
lincom anger_treat+ angerXidp
lincom fear_treat+ fearXidp


*Conflict Exposure
reg russia_angry info_treat anger_treat fear_treat infoXexpo angerXexpo fearXexpo total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending  if russia_angry>=0, cluster(psu)

lincom info_treat+ infoXexpo
lincom anger_treat+ angerXexpo
lincom fear_treat+ fearXexpo



*Recog Abkhazia*

*IDP Status
reg recog_abk info_treat anger_treat fear_treat infoXidp angerXidp fearXidp idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if recog_abk>=0, cluster(psu)

lincom info_treat+ infoXidp
lincom anger_treat+ angerXidp
lincom fear_treat+ fearXidp


*Conflict Exposure
reg recog_abk info_treat anger_treat fear_treat infoXexpo angerXexpo fearXexpo total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending  if recog_abk>=0, cluster(psu)

lincom info_treat+ infoXexpo
lincom anger_treat+ angerXexpo
lincom fear_treat+ fearXexpo

*Recog South Ossetia**

*IDP Status
reg recog_so info_treat anger_treat fear_treat infoXidp angerXidp fearXidp idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if recog_so>=0, cluster(psu)

lincom info_treat+ infoXidp
lincom anger_treat+ angerXidp
lincom fear_treat+ fearXidp


*Conflict Exposure
reg recog_so info_treat anger_treat fear_treat infoXexpo angerXexpo fearXexpo total_exposure kutaisi conflict_affected sakash_good education age male married hh_spending  if recog_so>=0, cluster(psu)

lincom info_treat+ infoXexpo
lincom anger_treat+ angerXexpo
lincom fear_treat+ fearXexpo






*What should Georgia do about Abkhazia************************************************************

***Send Economic Aid to Abkhazia***********************************************

*      Georgia's actions in |
*  Abkhazia - Send economic |
*    aid to Georgian living |
*                     there |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         16        1.31        1.39
*                Don't know |        123       10.06       11.45
*         Strongly disagree |         71        5.81       17.25
*         Disagree a little |         73        5.97       23.22
*Neither agree nor disagree |        110        8.99       32.22
*            Agree a little |        370       30.25       62.47
*            Strongly agree |        459       37.53      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00

replace send_econ_abk= (send_econ_abk-1)/4 if send_econ_abk>0
tab send_econ_abk, nolabel

reg send_econ_abk info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if send_econ_abk>=0, cluster(psu)



***Send Weapons to Abkhazia************************************************************
*      Georgia's actions in |
*Abkhazia - Send weapons to |
*     Georgian living there |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         20        1.64        1.72
*                Don't know |        114        9.32       11.04
*         Strongly disagree |        635       51.92       62.96
*         Disagree a little |        207       16.93       79.89
*Neither agree nor disagree |        102        8.34       88.23
*            Agree a little |         89        7.28       95.50
*            Strongly agree |         55        4.50      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00

replace send_wep_abk= (send_wep_abk-1)/4 if send_wep_abk>0
tab send_wep_abk, nolabel

reg send_wep_abk info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if send_wep_abk>=0, cluster(psu)



***Do Nothing in Abkhazia************************************************
*      Georgia's actions in |
*Abkhazia - Do nothing/stay |
*                       out |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         22        1.80        1.88
*                Don't know |        138       11.28       13.16
*         Strongly disagree |        520       42.52       55.68
*         Disagree a little |        304       24.86       80.54
*Neither agree nor disagree |        167       13.65       94.19
*            Agree a little |         34        2.78       96.97
*            Strongly agree |         37        3.03      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00

replace donothing_abk= (donothing_abk-1)/4 if donothing_abk>0
tab donothing_abk, nolabel

reg donothing_abk info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if donothing_abk>=0, cluster(psu)



****Normalize Relations Abkhazia**********************
*      Georgia's actions in |
*      Abkhazia - Normalize |
* relations with the Abkhaz |
*                government |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         19        1.55        1.64
*                Don't know |        115        9.40       11.04
*         Strongly disagree |         47        3.84       14.88
*         Disagree a little |         49        4.01       18.89
*Neither agree nor disagree |        156       12.76       31.64
*            Agree a little |        370       30.25       61.90
*            Strongly agree |        466       38.10      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00


replace normal_abk= (normal_abk-1)/4 if normal_abk>0
tab normal_abk, nolabel

reg normal_abk info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if normal_abk>=0, cluster(psu)



*What should Georgia do about South Ossetia************************************************************


***Send Economic Aid to South Ossetia ***********************************************
* Georgia's actions in SO - |
*      Send economic aid to |
*     Georgian living there |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         18        1.47        1.55
*                Don't know |        145       11.86       13.41
*         Strongly disagree |         77        6.30       19.71
*         Disagree a little |         59        4.82       24.53
*Neither agree nor disagree |         86        7.03       31.56
*            Agree a little |        372       30.42       61.98
*            Strongly agree |        465       38.02      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00


replace send_econ_so= (send_econ_so-1)/4 if send_econ_so>0
tab send_econ_so, nolabel

reg send_econ_so info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if send_econ_so>=0, cluster(psu)



***Send Weapons to South Ossetia************************************************************
* Georgia's actions in SO - |
*  Send weapons to Georgian |
*              living there |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         19        1.55        1.64
*                Don't know |        130       10.63       12.26
*         Strongly disagree |        653       53.39       65.66
*         Disagree a little |        209       17.09       82.75
*Neither agree nor disagree |         93        7.60       90.35
*            Agree a little |         67        5.48       95.83
*            Strongly agree |         51        4.17      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00


replace send_wep_so= (send_wep_so-1)/4 if send_wep_so>0
tab send_wep_so, nolabel

reg send_wep_so info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if send_wep_so>=0, cluster(psu)




***Do Nothing in South Ossetia************************************************
 *Georgia's actions in SO - |
*       Do nothing/stay out |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*         Interviewer error |          3        0.25        0.33
*          Refuse to answer |         21        1.72        2.04
*                Don't know |        162       13.25       15.29
*         Strongly disagree |        490       40.07       55.36
*         Disagree a little |        283       23.14       78.50
*Neither agree nor disagree |        150       12.26       90.76
*            Agree a little |         64        5.23       95.99
*            Strongly agree |         49        4.01      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00


replace donothing_so= (donothing_so-1)/4 if donothing_so>0
tab donothing_so, nolabel

reg donothing_so info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if donothing_so>=0, cluster(psu)




* Normalize Relations with South Ossetia****************************************
*Georgia's actions in SO - |
*  Normalize relations with |
*         the SO government |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*         Interviewer error |          1        0.08        0.16
*          Refuse to answer |         24        1.96        2.13
*                Don't know |        144       11.77       13.90
*         Strongly disagree |         43        3.52       17.42
*         Disagree a little |         43        3.52       20.93
*Neither agree nor disagree |        159       13.00       33.93
*            Agree a little |        339       27.72       61.65
*            Strongly agree |        469       38.35      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00

replace normal_so= (normal_so-1)/4 if normal_so>0
tab normal_so, nolabel

reg normal_so info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if normal_so>=0, cluster(psu)



******Willingness to Sit Down and Hear Abkhazia*******************************************
*  Willing to sit down with |
* an Abkhazian just to hear |
*                their side |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         10        0.82        0.90
*                Don't know |        101        8.26        9.16
*         Strongly disagree |         48        3.92       13.08
*         Disagree a little |         37        3.03       16.11
*Neither agree nor disagree |        156       12.76       28.86
*            Agree a little |        342       27.96       56.83
*            Strongly agree |        528       43.17      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00


replace hear_abk= (hear_abk-1)/4 if hear_abk>0
tab hear_abk, nolabel

reg hear_abk info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if hear_abk>=0, cluster(psu)



******Willingness to Forgive Abkhazia*******************************************
*  Willing to forgive those |
*  responsible for violence |
*      against Georgians in |
*                  Abkhazia |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*         Interviewer error |          1        0.08        0.16
*          Refuse to answer |         17        1.39        1.55
*                Don't know |        110        8.99       10.55
*         Strongly disagree |        418       34.18       44.73
*         Disagree a little |        139       11.37       56.09
*Neither agree nor disagree |        164       13.41       69.50
*            Agree a little |        203       16.60       86.10
*            Strongly agree |        170       13.90      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00

replace forgive_abk= (forgive_abk-1)/4 if forgive_abk>0
tab forgive_abk, nolabel

reg forgive_abk info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if forgive_abk>=0, cluster(psu)


					 
******Willingness to Sit Down and Hear South Ossetia*******************************************
*  Willing to sit down with |
*    an Ossetian from South |
*Ossetia just to hear their |
*                      side |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*          Refuse to answer |         18        1.47        1.55
*                Don't know |        142       11.61       13.16
*         Strongly disagree |         79        6.46       19.62
*         Disagree a little |         38        3.11       22.73
*Neither agree nor disagree |        162       13.25       35.98
*            Agree a little |        322       26.33       62.31
*            Strongly agree |        461       37.69      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00



replace hear_so= (hear_so-1)/4 if hear_so>0
tab hear_so, nolabel

reg hear_so info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if hear_so>=0, cluster(psu)



******Willingness to Forgive South Ossetia*******************************************

*  Willing to forgive those |
*  responsible for violence |
* against Georgians in 2008 |
*                       war |      Freq.     Percent        Cum.
*---------------------------+-----------------------------------
*                 Break off |          1        0.08        0.08
*         Interviewer error |          1        0.08        0.16
*          Refuse to answer |         23        1.88        2.04
*                Don't know |        158       12.92       14.96
*         Strongly disagree |        423       34.59       49.55
*         Disagree a little |        141       11.53       61.08
*Neither agree nor disagree |        164       13.41       74.49
*            Agree a little |        172       14.06       88.55
*            Strongly agree |        140       11.45      100.00
*---------------------------+-----------------------------------
*                     Total |      1,223      100.00




replace forgive_so= (forgive_so-1)/4 if forgive_so>0
tab forgive_so, nolabel

reg forgive_so info_treat anger_treat fear_treat idp_status kutaisi conflict_affected sakash_good education age male married hh_spending  if forgive_so>=0, cluster(psu)





log close 






