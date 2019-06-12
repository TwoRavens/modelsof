set more off

*******************************************
*
* This .do file creates the analysis reported in "Disagreement and the Avoidance of Political Discussion: Aggregate Relationships and Differences across Personality Traits"
* American Journal of Political Science
* Alan Gerber, Gregory Huber, David Doherty, Conor Dowling
*
* This version: January 30, 2011
*
*******************************************

local localpath=""

use "`localpath'sourcedata\YaleCCAP2008_PeersPersonalityItems.dta", clear

****************************
*
* RECODE DEMOGRAPHIC VARIABLES
*
****************************

* State, drop if missing state--get rid of state 10 dominant category
* No missing values
quietly tab profile66, gen(stateC_)
drop stateC_10

* Female
* No missing values
recode profile54 (1=0) (2=1), gen(C_female)
label var C_female "Female = 1"
gen male=abs(C_female-1)
label var male "Male = 1"

* Race
* No missing values
gen race = profile55 
label var profile55 "Race"
gen r_white = 0
replace r_white = 1 if race==1
label var r_white "White = 1"
gen C_r_black = 0
replace C_r_black = 1 if race==2
label var C_r_black "Black = 1"
gen C_r_hispanic = 0
replace C_r_hispanic = 1 if race==3
label var C_r_hispanic "Hispanic = 1"
gen C_r_other = 0
replace C_r_other = 1 if race==4
replace C_r_other = 1 if race==5
replace C_r_other = 1 if race==6
replace C_r_other = 1 if race==7
label var C_r_other "Other (Native American,Asian,Mixed,Other) = 1"

* Age
* No missing values
gen birthyr=profile51
label var birthyr "birth year"
gen C_age=2008-birthyr 
label var C_age "Age (in years)"
gen C_age2=(C_age^2)/100
label var C_age2 "Age^2/100"

* Education, drop missing
* No missing values
gen educ=profile57 
label var educ "Education (1=No HS; 6=Post-grad)"
tab educ, gen(C_educC_)
*drop category 2
drop C_educC_2
label var C_educC_1 "Educ<HS"
label var C_educC_3 "Educ=Some college"
label var C_educC_4 "Educ=2 year college"
label var C_educC_5 "Educ=College"
label var C_educC_6 "Educ=Post-grad"

* Family Income
* RF set to missing, plus indicator for missing
gen income=profile59
label var income "Income (1=<10k; 14=>150k; 15=RF)"
gen incomemis = (income==15)
label var incomemis "Income Refused (1=Yes)"

****************************
*
* Construct Big Five (TIPI) Items
*
* (All are 7 point scales, missing/skipped set to missing)
*
****************************

#delimit ;

recode
profile40 profile41 profile42 profile43 profile44 profile45 profile46 profile47 profile48 profile49 (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (*=.), 
gen(b_p_extraverted b_p_critical b_p_dependable b_p_anxious b_p_open b_p_reserved 
    b_p_sympathetic b_p_disorganized b_p_calm b_p_conventional);

*generate reversed values of items that need to be reverse scored;

recode
b_p_disorganized b_p_conventional b_p_critical b_p_anxious b_p_reserved
(7=1) (6=2) (5=3) (4=4) (3=5) (2=6) (1=7) (*=.),
gen(b_p_disorganized_R b_p_conventional_R b_p_critical_R b_p_anxious_R b_p_reserved_R);

#delimit cr

*Items range from 0 to 1 -- higher values indicate more of the trait

*Big Five - extraversion
gen BF_extraversion = (((b_p_extraverted + b_p_reserved_R)/2)-1)/6
label var BF_extraversion "Emotional Stability (0-1)"

*Big Five - agreeableness
gen BF_agreeableness = (((b_p_sympathetic + b_p_critical_R)/2)-1)/6
label var BF_agreeableness "Agreeableness (0-1)"

*Big Five - conscientiousness
gen BF_conscientiousness = (((b_p_dependable + b_p_disorganized_R)/2)-1)/6
label var BF_conscientiousness "Conscientiousness (0-1)"

*Big Five - emotional stability
gen BF_stability = (((b_p_calm + b_p_anxious_R)/2)-1)/6
label var BF_stability "Stability (0-1)"

*Big Five - openness to experiences
gen BF_openness = (((b_p_open + b_p_conventional_R)/2)-1)/6
label var BF_openness "Openness (0-1)"

****************************
*
* Recode PEER BATTERY - SENSITVE TOPICS (yal031 thru yal072)
*
****************************

* Not asked(14 cases)/Skipped(15)/Missing(364)=Missing
recode oct_yal031 (1=1) (2=0) (3=-1) (*=.), gen(p_sentopcomf)
label var p_sentopcomf "Prefer Agreement on Sens. Topics (-1=enjoy when DA;0=enjoy when A & DA; 1=enjoy when A)"
tab p_sentopcomf, gen(p_sentopcomfC_)
drop p_sentopcomfC_1

* Not asked(14 cases)/Skipped(15)/Missing(364)=Missing
recode oct_yal032 (1=3) (2=2) (3=1) (4=0) (*=.), gen(p_sentoptalk)
label var p_sentoptalk "Sensitive topics, prefer to avoid (3=avoid;0=glad even if DA)"
tab p_sentoptalk, gen(p_sentoptalkC_)
drop p_sentoptalkC_1

*****************************************************
*
* Recode PEER BATTERY, FAMILY items
*
*****************************************************

* Frequency of discussion
recode oct_yal033 (1=3) (2=2) (3=1) (4=0) (*=.), gen(p_famfreqtalk)
label var p_famfreqtalk "Freq. talk family member (0=once month;1=once week;2=few times week;3=daily)"
tab p_famfreqtalk, gen(p_famfreqtalkC_)
drop p_famfreqtalkC_1
label var p_famfreqtalkC_2 "Talk once a week"
label var p_famfreqtalkC_3 "Talk a few times a week"
label var p_famfreqtalkC_4 "Talk daily"

* Frequency of discussion by topic
foreach i in oct_yal034 oct_yal035 oct_yal036 oct_yal037 oct_yal038 oct_yal039 oct_yal040 {
 recode `i' (1=0) (2=1) (3=2) (4=3) (*=.), gen(p_famfreqtop_`i')
}
rename p_famfreqtop_oct_yal034 p_famfreqtalk_family
rename p_famfreqtop_oct_yal035 p_famfreqtalk_work
rename p_famfreqtop_oct_yal036 p_famfreqtalk_god
rename p_famfreqtop_oct_yal037 p_famfreqtalk_sports
rename p_famfreqtop_oct_yal038 p_famfreqtalk_food
rename p_famfreqtop_oct_yal039 p_famfreqtalk_politics
rename p_famfreqtop_oct_yal040 p_famfreqtalk_entertainment

* Level of Agreement by Topic
foreach i in oct_yal041 oct_yal042 oct_yal043 oct_yal044 oct_yal045 oct_yal046 oct_yal047 {
 recode `i' (1=1) (2=0) (3=-1) (4=0) (*=.), gen(p_famagreetop_`i')
}
rename p_famagreetop_oct_yal041 p_famagree_family
rename p_famagreetop_oct_yal042 p_famagree_work
rename p_famagreetop_oct_yal043 p_famagree_god
rename p_famagreetop_oct_yal044 p_famagree_sports
rename p_famagreetop_oct_yal045 p_famagree_food
rename p_famagreetop_oct_yal046 p_famagree_politics
rename p_famagreetop_oct_yal047 p_famagree_entertainment

* Level of Agreement by Topic, DK=.
foreach i in oct_yal041 oct_yal042 oct_yal043 oct_yal044 oct_yal045 oct_yal046 oct_yal047 {
 recode `i' (1=1) (2=0) (3=-1) (*=.), gen(p_famagreetop_`i')
}
rename p_famagreetop_oct_yal041 p_famaltagree_family
rename p_famagreetop_oct_yal042 p_famaltagree_work
rename p_famagreetop_oct_yal043 p_famaltagree_god
rename p_famagreetop_oct_yal044 p_famaltagree_sports
rename p_famagreetop_oct_yal045 p_famaltagree_food
rename p_famagreetop_oct_yal046 p_famaltagree_politics
rename p_famagreetop_oct_yal047 p_famaltagree_entertainment

* Disagreement by Topic
foreach i in oct_yal041 oct_yal042 oct_yal043 oct_yal044 oct_yal045 oct_yal046 oct_yal047 {
 recode `i' (1=0) (2=0) (3=1) (4=0) (*=.), gen(p_famagreetop_`i')
}
rename p_famagreetop_oct_yal041 p_famda_family
rename p_famagreetop_oct_yal042 p_famda_work
rename p_famagreetop_oct_yal043 p_famda_god
rename p_famagreetop_oct_yal044 p_famda_sports
rename p_famagreetop_oct_yal045 p_famda_food
rename p_famagreetop_oct_yal046 p_famda_politics
rename p_famagreetop_oct_yal047 p_famda_entertainment

*Interactions and label variables
foreach i in family work god sports food politics entertainment {
 gen p_famnetdatalk_`i' = -1*p_famagree_`i'*p_famfreqtalk_`i'
 label var p_famnetdatalk_`i' "Talk x Net Disagree (1,-1) on `i' with fam"
 label var p_famfreqtalk_`i' "Freq. discuss `i' with family (0=Never;3=Often)"
 label var p_famagree_`i' "Agreement on issue with family (-1=DA;0=A & DA,DK;1=A)"
 label var p_famaltagree_`i' "Agreement on issue with family (-1=DA;0=A & DA;1=A)"
 label var p_famda_`i' "Disagree on issue with family (1=yes)"
}

* Sum of all discussion items (talk)
egen p_famfreqtalksum = rowtotal(p_famfreqtalk_*)
label var p_famfreqtalksum "Sum of discussion items with family member (0-21)"

* Sum of all discussion items (agreement)
egen p_famagreesum = rowtotal(p_famagree_*)
egen p_famaltagreesum = rowtotal(p_famaltagree_*)
egen p_famaltagree_n = rownonmiss(p_famaltagree_*)
label var p_famagreesum "Sum of Agreement with family member (-7-+7)"
label var p_famaltagreesum "Sum of Alt. Agreement with family member"

*Relative frequency of discussion and agreement
foreach i in family work god sports food politics entertainment {
 gen p_talk_rel_fammean_`i' = p_famfreqtalk_`i' - ((p_famfreqtalksum - p_famfreqtalk_`i')/6)
 gen p_agg_rel_fammean_`i' = p_famagree_`i' - ((p_famagreesum - p_famagree_`i')/6)
 label var p_talk_rel_fammean_`i' "Freq. discuss `i' with family, relative to mean"
 label var p_agg_rel_fammean_`i' "Agreement on issue with family, relative to mean"
 gen p_aagg_rel_fammean_`i' = p_famagree_`i' - ((p_famaltagreesum - p_famaltagree_`i')/(p_famaltagree_n-1))
 label var p_aagg_rel_fammean_`i' "Alt. Agreement on issue with family, relative to mean"
}

*Comfort with disagreement x Agreement by issue
foreach i in family work god sports food politics entertainment {
 gen p_comf_aggfam_`i' = p_famagree_`i'*p_sentopcomf
 label var p_comf_aggfam_`i' "Prefer Agreement x Agree with fam. on issue"
 gen p_comf_aggfammean_`i' = p_agg_rel_fammean_`i'*p_sentopcomf
 label var p_comf_aggfammean_`i' "Prefer Agreement x Agree with fam. rel mean on issue"
 gen p_comf_aaggfammean_`i' = p_aagg_rel_fammean_`i'*p_sentopcomf
 label var p_comf_aaggfammean_`i' "Prefer Agreement x Alt. Agree with fam. rel mean on issue"
 gen p_st_aggfammean_`i' = p_agg_rel_fammean_`i'*p_sentoptalk
 label var p_st_aggfammean_`i' "Avoid Sent. Topics x Agree with fam. rel mean on issue"
}

*Who did family member vote for?
recode oct_yal048 (1=1) (2=-1) (3=0) (4=.) (9=0) (*=.), gen(p_famvote08)
label var p_famvote08 "Who did your family member vote for? (-1=R;0=other/DK;1=D)"

recode oct_yal048 (1=1) (2=1) (3=1) (4=1) (9=0) (*=.), gen(p_knowfamvote08)
label var p_knowfamvote08 "Know family member's vote"

*Would you be comfortable asking?
recode oct_yal049 (1=-1) (2=0) (3=1) (*=.), gen(p_famvotecomfortask)
label var p_famvotecomfortask "Comfortable asking fam. member about vote (-1 to 1)"

*Match, own and other vote
recode pcap600 (1=1) (2=-1) (3=0) (*=.), gen(post_presvote08)
label var post_presvote08 "Presidential vote (-1=R;0=other;1=D)"

gen p_famvoteagree = post_presvote08==p_famvote08 if post_presvote08~=.
label var p_famvoteagree "Vote agreement between resp. and family member (1=Yes)"

*****************************************************
*
* Recode PEER BATTERY, Non-FAMILY items
*
*****************************************************

* Frequency of discussion
recode oct_yal051 (1=3) (2=2) (3=1) (4=0) (*=.), gen(p_othfreqtalk)
label var p_othfreqtalk "Freq. talk non-family person (0=once month;1=once week;2=few times week;3=daily)"
tab p_othfreqtalk, gen(p_othfreqtalkC_)
drop p_othfreqtalkC_1
label var p_othfreqtalkC_2 "Talk once a week"
label var p_othfreqtalkC_3 "Talk a few times a week"
label var p_othfreqtalkC_4 "Talk daily"

* Frequency of discussion by topic
foreach i in oct_yal052 oct_yal053 oct_yal054 oct_yal055 oct_yal056 oct_yal057 oct_yal058 {
 recode `i' (1=0) (2=1) (3=2) (4=3) (*=.), gen(p_othfreqtop_`i')
}
rename p_othfreqtop_oct_yal052 p_othfreqtalk_family
rename p_othfreqtop_oct_yal053 p_othfreqtalk_work
rename p_othfreqtop_oct_yal054 p_othfreqtalk_god
rename p_othfreqtop_oct_yal055 p_othfreqtalk_sports
rename p_othfreqtop_oct_yal056 p_othfreqtalk_food
rename p_othfreqtop_oct_yal057 p_othfreqtalk_politics
rename p_othfreqtop_oct_yal058 p_othfreqtalk_entertainment

* Level of Agreement by Topic
foreach i in oct_yal059 oct_yal060 oct_yal061 oct_yal062 oct_yal063 oct_yal064 oct_yal065 {
 recode `i' (1=1) (2=0) (3=-1) (4=0) (*=.), gen(p_othagreetop_`i')
}
rename p_othagreetop_oct_yal059 p_othagree_family
rename p_othagreetop_oct_yal060 p_othagree_work
rename p_othagreetop_oct_yal061 p_othagree_god
rename p_othagreetop_oct_yal062 p_othagree_sports
rename p_othagreetop_oct_yal063 p_othagree_food
rename p_othagreetop_oct_yal064 p_othagree_politics
rename p_othagreetop_oct_yal065 p_othagree_entertainment

* Level of Agreement by Topic, DK=.
foreach i in oct_yal059 oct_yal060 oct_yal061 oct_yal062 oct_yal063 oct_yal064 oct_yal065 {
 recode `i' (1=1) (2=0) (3=-1) (*=.), gen(p_othagreetop_`i')
}
rename p_othagreetop_oct_yal059 p_othaltagree_family
rename p_othagreetop_oct_yal060 p_othaltagree_work
rename p_othagreetop_oct_yal061 p_othaltagree_god
rename p_othagreetop_oct_yal062 p_othaltagree_sports
rename p_othagreetop_oct_yal063 p_othaltagree_food
rename p_othagreetop_oct_yal064 p_othaltagree_politics
rename p_othagreetop_oct_yal065 p_othaltagree_entertainment

* Level of Agreement by Topic, binary 1 = disagree
foreach i in oct_yal059 oct_yal060 oct_yal061 oct_yal062 oct_yal063 oct_yal064 oct_yal065 {
 recode `i' (1=0) (2=0) (3=1) (4=0) (*=.), gen(p_othagreetop_`i')
}
rename p_othagreetop_oct_yal059 p_othda_family
rename p_othagreetop_oct_yal060 p_othda_work
rename p_othagreetop_oct_yal061 p_othda_god
rename p_othagreetop_oct_yal062 p_othda_sports
rename p_othagreetop_oct_yal063 p_othda_food
rename p_othagreetop_oct_yal064 p_othda_politics
rename p_othagreetop_oct_yal065 p_othda_entertainment

*Interactions and label variables
foreach i in family work god sports food politics entertainment {
 gen p_othnetdatalk_`i' = -1*p_othagree_`i'*p_othfreqtalk_`i'
 label var p_othnetdatalk_`i' "Talk x Net Disagree (1,-1) on `i' with non-family"
 label var p_othfreqtalk_`i' "Freq. discuss `i' with non-family (0=Never;3=Often)"
 label var p_othagree_`i' "Agreement on issue with non-family (-1=DA;0=A & DA,DK;1=A)"
 label var p_othaltagree_`i' "Agreement on issue with non-family (-1=DA;0=A & DA;1=A)"
 label var p_othda_`i' "Disagree on issue with non-family (1=yes)"
}

* Sum of all discussion items (talk)
egen p_othfreqtalksum = rowtotal(p_othfreqtalk_*)
label var p_othfreqtalksum "Sum of discussion items with non-family member (0-21)"

* Sum of all discussion items (agreement)
egen p_othagreesum = rowtotal(p_othagree_*)
egen p_othaltagreesum = rowtotal(p_othaltagree_*)
egen p_othaltagree_n = rownonmiss(p_othaltagree_*)
label var p_othagreesum "Sum of Agreement with non-family member (-7-+7)"
label var p_othaltagreesum "Sum of Alt. Agreement with non-family member"

*Relative frequency of discussion and agreement
foreach i in family work god sports food politics entertainment {
 gen p_talk_rel_othmean_`i' = p_othfreqtalk_`i' - ((p_othfreqtalksum - p_othfreqtalk_`i')/6)
 gen p_agg_rel_othmean_`i' = p_othagree_`i' - ((p_othagreesum - p_othagree_`i')/6)
 label var p_talk_rel_othmean_`i' "Freq. discuss `i' with non-family, relative to mean"
 label var p_agg_rel_othmean_`i' "Agreement on issue with non-family, relative to mean"
 gen p_aagg_rel_othmean_`i' = p_othagree_`i' - ((p_othaltagreesum - p_othaltagree_`i')/(p_othaltagree_n-1))
 label var p_aagg_rel_othmean_`i' "Alt. Agreement on issue with non-family, relative to mean"
}

*Comfort with disagreement x Agreement by issue
foreach i in family work god sports food politics entertainment {
 gen p_comf_aggothmean_`i' = p_agg_rel_othmean_`i'*p_sentopcomf
 label var p_comf_aggothmean_`i' "Prefer Agreement x Agree with oth. rel mean on issue"
 gen p_comf_aggoth_`i' = p_othagree_`i'*p_sentopcomf
 label var p_comf_aggoth_`i' "Prefer Agreement x Agree with oth. on issue"
 gen p_comf_aaggothmean_`i' = p_aagg_rel_othmean_`i'*p_sentopcomf
 label var p_comf_aaggothmean_`i' "Prefer Agreement x Alt. Agree with oth. rel mean on issue"
 gen p_st_aggothmean_`i' = p_agg_rel_othmean_`i'*p_sentoptalk
 label var p_st_aggothmean_`i' "Avoid Sent. Topics x Agree with oth. rel mean on issue"

}

*Who did non-family person vote for?
recode oct_yal066 (1=1) (2=-1) (3=0) (4=.) (9=0) (*=.), gen(p_othvote08)
label var p_othvote08 "Who did your non-family person vote for? (-1=R;0=other/DK;1=D)"

recode oct_yal066 (1=1) (2=1) (3=1) (4=1) (9=0) (*=.), gen(p_knowothvote08)
label var p_knowothvote08 "Know non-family person's vote"

*Would you be comfortable asking?
recode oct_yal067 (1=-1) (2=0) (3=1) (*=.), gen(p_othvotecomfortask)
label var p_othvotecomfortask "Comfortable asking oth. member about vote (-1 to 1)"

*Match, own and non-family vote
gen p_othvoteagree = post_presvote08==p_othvote08 if post_presvote08~=.
label var p_othvoteagree "Vote agreement between resp. and non-family person (1=Yes)"

*****************************************************
*
* Recode PEER BATTERY, other person not in family/non-family battery
*
*****************************************************

*Discuss politics with else person
recode oct_yal069 (1=0) (2=1) (3=2) (4=3) (*=.), gen(p_elsefreqtalk_politics)
label var p_elsefreqtalk_politics "Freq. discuss Politics with else (0=Never;3=Often)"

*Agreement with else person
recode oct_yal070 (1=1) (2=0) (3=-1) (4=0) (*=.), gen(p_elseagree_politics)
label var p_elseagree_politics "Agreement on issue with else (-1=DA;0=A & DA,DK;1=A)"

*Who did "else" person vote for?
recode oct_yal071 (1=1) (2=-1) (3=0) (4=.) (9=0) (*=.), gen(p_elsevote08)
label var p_elsevote08 "Who did your else person vote for? (-1=R;0=other/DK;1=D)"

*Would you be comfortable asking?
recode oct_yal072 (1=-1) (2=0) (3=1) (*=.), gen(p_elsevotecomfortask)
label var p_elsevotecomfortask "Comfortable asking else about vote (-1 to 1)"

*****************************************************
*
* Recode, ID Person who talk most about politics with
*
*****************************************************

gen discussmostpolfreq=.
gen discussmostvote=.
gen discussmostagree=.

*Family
replace discussmostpolfreq=p_famfreqtalk_politics if oct_yal068==1
replace discussmostvote=p_famvote08 if oct_yal068==1
replace discussmostagree=p_famagree_politics if oct_yal068==1

*Other
replace discussmostpolfreq=p_othfreqtalk_politics if oct_yal068==2
replace discussmostvote=p_othagree_politics if oct_yal068==2
replace discussmostagree=p_othagree_politics if oct_yal068==2

*Else
replace discussmostpolfreq=p_elsefreqtalk_politics if oct_yal068==3
replace discussmostvote=p_elsevote08 if oct_yal068==3
replace discussmostagree=p_elseagree_politics if oct_yal068==3

****************************************************************************
*
* Perform sample restrictions--those reporting conversation and Big 5 items 
*
****************************************************************************

qui regress p_famfreqtalk_* p_famagree_* p_othfreqtalk_* p_othagree_* p_famfreqtalkC_* p_othfreqtalkC_* BF_*
keep if e(sample)

tab oct_yal068
/* MENTIONED IN THE TEXT
 tab oct_yal068
 talk most about politics |      Freq.     Percent        Cum.
--------------------------+-----------------------------------
family person named above |        459       67.50       67.50
  persons you named above |        183       26.91       94.41
             someone else |         38        5.59      100.00
--------------------------+-----------------------------------
                    Total |        680      100.00
*/

*******************************************************************************
*
* Standardize Big 5 (mean 0)
*
*******************************************************************************

foreach i of varlist BF_* {
sum `i'
egen std_`i'=std(`i')
}

*******************************************************************************
*
* Construct personality agreement interactions
*
*******************************************************************************

*Personality interactions with agreement (family)
foreach i in family work god sports food politics entertainment {
 gen BFexXp_famrelagree_`i'=std_BF_extraversion*p_agg_rel_fammean_`i'
 label var BFexXp_famrelagree_`i' "Extraversion x Agree rel. mean on issue"
 gen BFagXp_famrelagree_`i'=std_BF_agreeableness*p_agg_rel_fammean_`i'
 label var BFagXp_famrelagree_`i' "Agreeableness x Agree rel. mean on issue"
 gen BFcoXp_famrelagree_`i'=std_BF_conscientiousness*p_agg_rel_fammean_`i'
 label var BFcoXp_famrelagree_`i' "Conscientiousness x Agree rel. mean on issue"
 gen BFstXp_famrelagree_`i'=std_BF_stability*p_agg_rel_fammean_`i'
 label var BFstXp_famrelagree_`i' "Stability x Agree rel. mean on issue"
 gen BFopXp_famrelagree_`i'=std_BF_openness*p_agg_rel_fammean_`i'
 label var BFopXp_famrelagree_`i' "Openness x Agree rel. mean on issue"

 gen BFexZp_famagree_`i'=std_BF_extraversion*p_famagree_`i'
 label var BFexZp_famagree_`i' "Extraversion x Agree on issue"
 gen BFagZp_famagree_`i'=std_BF_agreeableness*p_famagree_`i'
 label var BFagZp_famagree_`i' "Agreeableness x Agree on issue"
 gen BFcoZp_famagree_`i'=std_BF_conscientiousness*p_famagree_`i'
 label var BFcoZp_famagree_`i' "Conscientiousness x Agree on issue"
 gen BFstZp_famagree_`i'=std_BF_stability*p_famagree_`i'
 label var BFstZp_famagree_`i' "Stability x Agree on issue"
 gen BFopZp_famagree_`i'=std_BF_openness*p_famagree_`i'
 label var BFopZp_famagree_`i' "Openness x Agree on issue"

}

*Personality interactions with agreement (other)
foreach i in family work god sports food politics entertainment {
 gen BFexOp_othrelagree_`i'=std_BF_extraversion*p_agg_rel_othmean_`i'
 label var BFexOp_othrelagree_`i' "Extraversion x Agree rel. mean on issue"
 gen BFagOp_othrelagree_`i'=std_BF_agreeableness*p_agg_rel_othmean_`i'
 label var BFagOp_othrelagree_`i' "Agreeableness x Agree rel. mean on issue"
 gen BFcoOp_othrelagree_`i'=std_BF_conscientiousness*p_agg_rel_othmean_`i'
 label var BFcoOp_othrelagree_`i' "Conscientiousness x Agree rel. mean on issue"
 gen BFstOp_othrelagree_`i'=std_BF_stability*p_agg_rel_othmean_`i'
 label var BFstOp_othrelagree_`i' "Stability x Agree rel. mean on issue"
 gen BFopOp_othrelagree_`i'=std_BF_openness*p_agg_rel_othmean_`i'
 label var BFopOp_othrelagree_`i' "Openness x Agree rel. mean on issue"

 gen BFexWp_othagree_`i'=std_BF_extraversion*p_othagree_`i'
 label var BFexWp_othagree_`i' "Extraversion x Agree on issue"
 gen BFagWp_othagree_`i'=std_BF_agreeableness*p_othagree_`i'
 label var BFagWp_othagree_`i' "Agreeableness x Agree on issue"
 gen BFcoWp_othagree_`i'=std_BF_conscientiousness*p_othagree_`i'
 label var BFcoWp_othagree_`i' "Conscientiousness x Agree on issue"
 gen BFstWp_othagree_`i'=std_BF_stability*p_othagree_`i'
 label var BFstWp_othagree_`i' "Stability x Agree on issue"
 gen BFopWp_othagree_`i'=std_BF_openness*p_othagree_`i'
 label var BFopWp_othagree_`i' "Openness x Agree on issue"

}

/*
foreach i in family work god sports food politics entertainment {
sum p_famfreqtalk_`i' if  p_famagree_`i' <=0
sum p_famfreqtalk_`i' if  p_famagree_`i' > 0
}
foreach i in family work god sports food politics entertainment {
sum p_othfreqtalk_`i' if  p_othagree_`i' <=0
sum p_othfreqtalk_`i' if  p_othagree_`i' > 0
}
*/

****************
*
* ANALYSIS 
*
****************

****************************************************************
*
* Figure 1 and Table A (Supporting Information), Descriptive Statistics
*
****************************************************************

gen temp1=.
label var temp1 "Freq. discuss with family (0=Never;3=Often)"
gen temp1a=.
label var temp1a "Freq. discuss with family rel. mean"
gen temp2=.
label var temp2 "Freq. discuss with non-family (0=Never;3=Often)"
gen temp2a=.
label var temp2a "Freq. discuss with non-family rel. mean"

quietly foreach i in family work god sports food entertainment politics {
 replace temp1=p_famfreqtalk_`i'
 replace temp1a=p_talk_rel_fammean_`i'
 replace temp2=p_othfreqtalk_`i'
 replace temp2a=p_talk_rel_othmean_`i'

 if "`i'"=="family" {
  cap outsum temp1 temp1a p_famagree_`i' p_famda_`i' p_agg_rel_fammean_`i' temp2 temp2a p_othagree_`i' p_othda_`i' p_agg_rel_othmean_`i' p_sentopcomf p_sentoptalk [aweight=psweight] using "`localpath'logs\SI_TableA_Summstats", bracket ctitle("`i'") replace
 }
 else {
  cap outsum temp1 temp1a p_famagree_`i' p_famda_`i' p_agg_rel_fammean_`i' temp2 temp2a p_othagree_`i' p_othda_`i' p_agg_rel_othmean_`i' [aweight=psweight] using "`localpath'logs\SI_TableA_Summstats", bracket ctitle("`i'") append
 }
}
quietly drop temp1 temp1a temp2 temp2a

*****************************************************
*
* Frequency and Agreement Differences for Figure 1 discussion
*
*****************************************************

svyset [pweight=psweight]
foreach i in family work god sports food entertainment politics{
qui svy: mean p_othfreqtalk_politics p_othfreqtalk_`i'
qui test p_othfreqtalk_politics=p_othfreqtalk_`i'
if r(p)>.05{
disp "`i'"
disp r(p)
svy: mean p_othfreqtalk_politics p_othfreqtalk_`i'
}
qui svy: mean p_famfreqtalk_politics p_famfreqtalk_`i'
qui test p_famfreqtalk_politics=p_famfreqtalk_`i'
if r(p)>.05{
disp "`i'"
disp r(p)
svy: mean p_famfreqtalk_politics p_famfreqtalk_`i'
}

qui svy: mean p_famfreqtalk_`i' p_othfreqtalk_`i'
qui test p_famfreqtalk_`i'=p_othfreqtalk_`i'
if r(p)>.05{
disp "`i'"
disp r(p)
svy: mean p_famfreqtalk_politics p_famfreqtalk_`i'
}

qui svy: mean p_othagree_politics p_othagree_`i'
qui test p_othagree_politics=p_othagree_`i'
if r(p)>.05{
disp "`i'"
disp r(p)
svy: mean p_othagree_politics p_othagree_`i'
}
qui svy: mean p_famagree_politics p_famagree_`i'
qui test p_famagree_politics=p_famagree_`i'
if r(p)>.05{
disp "`i'"
disp r(p)
svy: mean p_famagree_politics p_famagree_`i'
}
}
svyset, clear

*****************
* Table 1a, Freq discusss politics, family
*****************
foreach i in family work god sports food entertainment politics {

 *Relative Frequency of Discussion and Relative Agreement
 regress p_talk_rel_fammean_`i' p_agg_rel_fammean_`i' p_famfreqtalkC_* C_* [aweight=psweight], robust
 if "`i'"=="family" {
  outreg using "`localpath'logs\Table01A_family.out", se bracket rdec(3) 3aster replace
 }
 else {
  outreg using "`localpath'logs\Table01A_family.out", se bracket rdec(3) 3aster append
 }

}
regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01A_family.out", se bracket rdec(3) 3aster append
regress p_talk_rel_fammean_politics p_famagree_politics p_famfreqtalkC_* C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01A_family.out", se bracket rdec(3) 3aster append
regress p_famfreqtalk_politics p_famagree_politics p_famfreqtalkC_* C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01A_family.out", se bracket rdec(3) 3aster append
oprob p_famfreqtalk_politics p_famagree_politics p_famfreqtalkC_* C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01A_family.out", se bracket rdec(3) 3aster append

*****************
* Table 1b, Freq discusss politics, non-family
*****************

foreach i in family work god sports food entertainment politics {

 *Relative Frequency of Discussion and Relative Agreement
 regress p_talk_rel_othmean_`i' p_agg_rel_othmean_`i' p_othfreqtalkC_* C_* [aweight=psweight], robust
 if "`i'"=="family" {
  outreg using "`localpath'logs\Table01B_other.out", se bracket rdec(3) 3aster replace
 }
 else {
  outreg using "`localpath'logs\Table01B_other.out", se bracket rdec(3) 3aster append
 }

}
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01B_other.out", se bracket rdec(3) 3aster append
regress p_talk_rel_othmean_politics p_othagree_politics p_othfreqtalkC_* C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01B_other.out", se bracket rdec(3) 3aster append
regress p_othfreqtalk_politics p_othagree_politics p_othfreqtalkC_* C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01B_other.out", se bracket rdec(3) 3aster append
oprob p_othfreqtalk_politics p_othagree_politics p_othfreqtalkC_* C_* [aweight=psweight], robust
outreg using "`localpath'logs\Table01B_other.out", se bracket rdec(3) 3aster append

*****************
* Table 2 personality effects on frequency of discussion of politics for family and non-family
*****************

regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics p_famfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) replace
regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
regress p_talk_rel_fammean_politics p_famagree_politics p_famfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
regress p_famfreqtalk_politics p_famagree_politics p_famfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
oprob p_famfreqtalk_politics p_famagree_politics p_famfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(chi2), "Prob > F", r(p)) append

regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics p_othfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
regress p_talk_rel_othmean_politics p_othagree_politics p_othfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
regress p_othfreqtalk_politics p_othagree_politics p_othfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
oprob p_othfreqtalk_politics p_othagree_politics p_othfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
outreg using "`localpath'logs\Table02.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(chi2), "Prob > F", r(p)) append

*****************
* Table 3 personality x agreement effects on frequency of discussion of politics for family and non-family
*****************

regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics p_famfreqtalkC_* C_* std_BF_* BF*X*politics [aweight=psweight], robust
test BFexXp_famrelagree_politics BFagXp_famrelagree_politics BFcoXp_famrelagree_politics BFstXp_famrelagree_politics BFopXp_famrelagree_politics
outreg using "`localpath'logs\Table03.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) replace
regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics C_* std_BF_* BF*X*politics [aweight=psweight], robust
test BFexXp_famrelagree_politics BFagXp_famrelagree_politics BFcoXp_famrelagree_politics BFstXp_famrelagree_politics BFopXp_famrelagree_politics
outreg using "`localpath'logs\Table03.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append

regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics p_othfreqtalkC_* C_* std_BF_* BF*O*politics [aweight=psweight], robust
test BFexOp_othrelagree_politics BFagOp_othrelagree_politics BFcoOp_othrelagree_politics BFstOp_othrelagree_politics BFopOp_othrelagree_politics
outreg using "`localpath'logs\Table03.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* std_BF_* BF*O*politics [aweight=psweight], robust
test BFexOp_othrelagree_politics BFagOp_othrelagree_politics BFcoOp_othrelagree_politics BFstOp_othrelagree_politics BFopOp_othrelagree_politics
outreg using "`localpath'logs\Table03.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append

***Marginal effects for column (1)
regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics p_famfreqtalkC_* C_* std_BF_* BF*X*politics [aweight=psweight], robust
sum p_talk_rel_fammean_politics [aw=psweight]
local disagree2SD=2*r(sd)
foreach j in ex ag co st op {
lincom `disagree2SD'*(p_agg_rel_fammean_politics-BF`j'Xp_famrelagree_politics)
matrix `j'_est=r(estimate)
matrix `j'_ci=r(se)*1.9635871
lincom `disagree2SD'*(p_agg_rel_fammean_politics+BF`j'Xp_famrelagree_politics)
matrix `j'_est=`j'_est,r(estimate)
matrix `j'_ci=`j'_ci,r(se)*1.9635871
}
matrix full=ex_est,ex_ci
matrix full=full\ag_est,ag_ci
matrix full=full\co_est,co_ci
matrix full=full\st_est,st_ci
matrix full=full\op_est,op_ci
matrix list full

***Marginal effects for column (3)
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics p_othfreqtalkC_* C_* std_BF_* BF*O*politics [aweight=psweight], robust
sum p_talk_rel_othmean_politics [aw=psweight]
local disagree2SD=2*r(sd)
foreach j in ex ag co st op {
lincom `disagree2SD'*(p_agg_rel_othmean_politics-BF`j'Op_othrelagree_politics)
matrix `j'_est=r(estimate)
matrix `j'_ci=r(se)*1.9635871
lincom `disagree2SD'*(p_agg_rel_othmean_politics+BF`j'Op_othrelagree_politics)
matrix `j'_est=`j'_est,r(estimate)
matrix `j'_ci=`j'_ci,r(se)*1.9635871
}
matrix full=ex_est,ex_ci
matrix full=full\ag_est,ag_ci
matrix full=full\co_est,co_ci
matrix full=full\st_est,st_ci
matrix full=full\op_est,op_ci
matrix list full


*****************
* Table B (Supporting Information), Correlation of Big Five Items
*****************

corr std_BF_* [aweight=psweight]
count

*****************
* Table C (Supporting Information), non-political items for family and non-family
*****************

foreach i in family work god sports food entertainment {
 regress p_talk_rel_fammean_`i' p_agg_rel_fammean_`i' p_famfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
 test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
 if "`i'"=="family" {
  outreg using "`localpath'logs\SI_TableC.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) replace
 }
 else {
  outreg using "`localpath'logs\SI_TableC.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
 }

}

foreach i in family work god sports food entertainment {
 regress p_talk_rel_othmean_`i' p_agg_rel_othmean_`i' p_othfreqtalkC_* C_* std_BF_* [aweight=psweight], robust
 test std_BF_extraversion std_BF_agreeableness std_BF_conscientiousness std_BF_stability std_BF_openness
 outreg using "`localpath'logs\SI_TableC.out", se bracket rdec(3) 3aster addstat("F test: Joint Significance of Big Five", r(F), "Prob > F", r(p)) append
 }

*****************
* Table D (Supporting Information), Same as Table 3, but using absolute agreement, family and non-family
*****************

regress p_talk_rel_fammean_politics p_famagree_politics p_famfreqtalkC_* C_* std_BF_* BF*Z*politics [aweight=psweight], robust
test BFexZp_famagree_politics BFagZp_famagree_politics BFcoZp_famagree_politics BFstZp_famagree_politics BFopZp_famagree_politics
outreg using "`localpath'logs\SI_TableD.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) replace
regress p_famfreqtalk_politics p_famagree_politics p_famfreqtalkC_* C_* std_BF_* BF*Z*politics [aweight=psweight], robust
test BFexZp_famagree_politics BFagZp_famagree_politics BFcoZp_famagree_politics BFstZp_famagree_politics BFopZp_famagree_politics
outreg using "`localpath'logs\SI_TableD.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append
oprob p_famfreqtalk_politics p_famagree_politics p_famfreqtalkC_* C_* std_BF_* BF*Z*politics [aweight=psweight], robust
test BFexZp_famagree_politics BFagZp_famagree_politics BFcoZp_famagree_politics BFstZp_famagree_politics BFopZp_famagree_politics
outreg using "`localpath'logs\SI_TableD.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(chi2), "Prob > F", r(p)) append

regress p_talk_rel_othmean_politics p_othagree_politics p_othfreqtalkC_* C_* std_BF_* BF*W*politics [aweight=psweight], robust
test BFexWp_othagree_politics BFagWp_othagree_politics BFcoWp_othagree_politics BFstWp_othagree_politics BFopWp_othagree_politics
outreg using "`localpath'logs\SI_TableD.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append
regress p_othfreqtalk_politics p_othagree_politics p_othfreqtalkC_* C_* std_BF_* BF*W*politics [aweight=psweight], robust
test BFexWp_othagree_politics BFagWp_othagree_politics BFcoWp_othagree_politics BFstWp_othagree_politics BFopWp_othagree_politics
outreg using "`localpath'logs\SI_TableD.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append
oprob p_othfreqtalk_politics p_othagree_politics p_othfreqtalkC_* C_* std_BF_* BF*W*politics [aweight=psweight], robust
test BFexWp_othagree_politics BFagWp_othagree_politics BFcoWp_othagree_politics BFstWp_othagree_politics BFopWp_othagree_politics
outreg using "`localpath'logs\SI_TableD.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(chi2), "Prob > F", r(p)) append

*****************
* Table E (Supporting Information), Specification 3', allowing more interactions, family and non-family
*****************

* Interacting all controls with personality
foreach i of varlist C*_* {
foreach tp of varlist std_BF_* {
local t=subinstr("`tp'","std_BF_","",.)
gen t_`i'X`t'=`i'*`tp'
local ilabel : variable label `i'
local tlabel : variable label `tp'
label var t_`i'X`t' "`ilabel' x `tlabel'"
}
}

preserve
* Interacting all controls with relative family agreement on politics
foreach i of varlist C*_* {
gen t_`i'Xaggrelpol=`i'*p_agg_rel_fammean_politics 
}

regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics p_famfreqtalkC_* C_* std_BF_* BF*X*politics t_C_*X* [aweight=psweight], robust
test BFexXp_famrelagree_politics BFagXp_famrelagree_politics BFcoXp_famrelagree_politics BFstXp_famrelagree_politics BFopXp_famrelagree_politics
outreg using "`localpath'logs\SI_TableE.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) replace
regress p_talk_rel_fammean_politics p_agg_rel_fammean_politics C_* std_BF_* BF*X*politics t_C_*X* [aweight=psweight], robust
test BFexXp_famrelagree_politics BFagXp_famrelagree_politics BFcoXp_famrelagree_politics BFstXp_famrelagree_politics BFopXp_famrelagree_politics
outreg using "`localpath'logs\SI_TableE.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append
restore

preserve
* Interacting all controls with relative non-family agreement on politics
foreach i of varlist C*_* {
gen t_`i'Xaggrelpol=`i'*p_agg_rel_othmean_politics 
}

*Table E (Supporting Information), specification 3'
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics p_othfreqtalkC_* C_* std_BF_* BF*O*politics t_C_*X* [aweight=psweight], robust
test BFexOp_othrelagree_politics BFagOp_othrelagree_politics BFcoOp_othrelagree_politics BFstOp_othrelagree_politics BFopOp_othrelagree_politics
outreg using "`localpath'logs\SI_TableE.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* std_BF_* BF*O*politics t_C_*X* [aweight=psweight], robust
test BFexOp_othrelagree_politics BFagOp_othrelagree_politics BFcoOp_othrelagree_politics BFstOp_othrelagree_politics BFopOp_othrelagree_politics
outreg using "`localpath'logs\SI_TableE.out", se bracket rdec(3) 3aster addstat("F test: Interactions", r(F), "Prob > F", r(p)) append

restore  
 
****************************************************************
*
* Table F (Supporting Information), Avoid Sensitive Topics ***
*
****************************************************************

tobit p_sentopcomf C_* [aweight=psweight], robust ll(-1) ul(1)
outreg using "`localpath'logs\SI_TableF.out", se bracket rdec(3) 3aster replace
tobit p_sentopcomf C_* std_BF_* [aweight=psweight], robust ll(-1) ul(1)
outreg using "`localpath'logs\SI_TableF.out", se bracket rdec(3) 3aster append
tobit p_sentoptalk C_* [aweight=psweight], robust ll(0) ul(3)
outreg using "`localpath'logs\SI_TableF.out", se bracket rdec(3) 3aster append
tobit p_sentoptalk C_* std_BF_* [aweight=psweight], robust ll(0) ul(3)
outreg using "`localpath'logs\SI_TableF.out", se bracket rdec(3) 3aster append

******************************************************************
*
* Tables J and K (Supporting Information), Predict Agreement
*
******************************************************************

foreach i in family work god sports food entertainment politics {
gen p_fam_freqXagree_`i'=p_famagree_`i'*p_famfreqtalk_`i'
gen p_oth_freqXagree_`i'=p_othagree_`i'*p_othfreqtalk_`i'
}

foreach i in family work god sports food entertainment politics {
regress p_agg_rel_fammean_`i' C_* std_BF_* [aweight=psweight], robust
if "`i'"=="family"{
outreg std_BF_* using "`localpath'logs\SI_TableJ_pred_agree_fam.out", se bracket rdec(3) 3aster replace ctitle(`i')
}
else{
outreg std_BF_* using "`localpath'logs\SI_TableJ_pred_agree_fam.out", se bracket rdec(3) 3aster append ctitle(`i')
}
}

foreach i in family work god sports food entertainment politics {
regress p_agg_rel_othmean_`i' C_* std_BF_* [aweight=psweight], robust
if "`i'"=="family"{
outreg std_BF_* using "`localpath'logs\SI_TableK_pred_agree_oth.out", se bracket rdec(3) 3aster replace ctitle(`i')
}
else{
outreg std_BF_* using "`localpath'logs\SI_TableK_pred_agree_oth.out", se bracket rdec(3) 3aster append ctitle(`i')
}
}
*/

**************************************************************************
*** ADDITIONAL ANALYSIS WITH NEW DATA - FEBRUARY 2011 FOLLOW-UP SURVEY ***
**************************************************************************
clear
include "`localpath'02_Sub_ConductReplicationAnalysisFollowup.do"
