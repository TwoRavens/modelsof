
use "`localpath'sourcedata\YaleFeb2011Survey_PeersPersonalityItems.dta", clear

**********************************
*
* Recode DEMOGRAPHICS 
*
**********************************

* State, drop if missing state--get rid of state 10 dominant category
* No missing values
quietly tab inputstate, gen(stateC_)
drop stateC_10

* Female
* No missing values
recode gender (1=0) (2=1), gen(C_female)
label var C_female "Female = 1"
gen male=abs(C_female-1)
label var male "Male = 1"

* Race
* No missing values
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
gen C_age=2008-birthyr 
label var C_age "Age (in years)"
gen C_age2=(C_age^2)/100
label var C_age2 "Age^2/100"

* Education, drop missing
* No missing values
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
gen incomemis = (income==15)
label var incomemis "Income Refused (1=Yes)"

*************
*
* Recode PEERS items
*
*************

tab yal065_insert, gen(treat_politics)
drop treat_politics2
rename treat_politics1 treat_CE_politics

gen food_agree=(insert_yal110_1==insert_yal110_4)
gen parenting_agree=(insert_yal110_2==insert_yal110_5)
gen politics_agree=(insert_yal110_3==insert_yal110_6)
label var food_agree "Agree about Food and Dining = 1"
label var parenting_agree "Agree about Parenting = 1"
label var politics_agree "Agree about Politics = 1"

recode yal110 yal111 yal112 yal113 (1=1) (2=2) (3=3) (4=4) (*=.)
label var yal110 "Politics"
label var yal111 "Cooking and Dining"
label var yal112 "Parenting"
label var yal113 "the Weather"

gen entered_disc=0
replace entered_disc=1 if yal050a=="Entered" | yal050b=="Entered" | yal050c=="Entered" 

gen specific_freq=0
replace specific_freq=1 if yal060a==9 
* Frequency of discussion by topic
foreach i in yal060 yal061 yal062 yal063 yal064 yal065 yal066 {
recode `i'a (1=0) (2=1) (3=2) (4=3) (*=.)
recode `i'b (1=3) (2=2) (3=1) (4=0) (*=.)

gen p_othfreqtop_`i'=`i'a
replace p_othfreqtop_`i'=`i'b if `i'a==.
}

rename p_othfreqtop_yal060 p_othfreqtalk_family
rename p_othfreqtop_yal061 p_othfreqtalk_work
rename p_othfreqtop_yal062 p_othfreqtalk_god
rename p_othfreqtop_yal063 p_othfreqtalk_sports
rename p_othfreqtop_yal064 p_othfreqtalk_food
rename p_othfreqtop_yal065 p_othfreqtalk_politics
rename p_othfreqtop_yal066 p_othfreqtalk_entertainment

* Level of Agreement by Topic
foreach i in yal070 yal071 yal072 yal073 yal074 yal075 yal076 {
 recode `i' (1=1) (2=0) (3=-1) (4=0) (*=.), gen(p_othagreetop_`i')
}
rename p_othagreetop_yal070 p_othagree_family
rename p_othagreetop_yal071 p_othagree_work
rename p_othagreetop_yal072 p_othagree_god
rename p_othagreetop_yal073 p_othagree_sports
rename p_othagreetop_yal074 p_othagree_food
rename p_othagreetop_yal075 p_othagree_politics
rename p_othagreetop_yal076 p_othagree_entertainment

* Level of Agreement by Topic, DK=.
foreach i in yal070 yal071 yal072 yal073 yal074 yal075 yal076{
 recode `i' (1=1) (2=0) (3=-1) (*=.), gen(p_othagreetop_`i')
}
rename p_othagreetop_yal070 p_othaltagree_family
rename p_othagreetop_yal071 p_othaltagree_work
rename p_othagreetop_yal072 p_othaltagree_god
rename p_othagreetop_yal073 p_othaltagree_sports
rename p_othagreetop_yal074 p_othaltagree_food
rename p_othagreetop_yal075 p_othaltagree_politics
rename p_othagreetop_yal076 p_othaltagree_entertainment

* Level of Agreement by Topic, binary 1 = disagree
foreach i in yal070 yal071 yal072 yal073 yal074 yal075 yal076{
 recode `i' (1=0) (2=0) (3=1) (4=0) (*=.), gen(p_othagreetop_`i')
}
rename p_othagreetop_yal070 p_othda_family
rename p_othagreetop_yal071 p_othda_work
rename p_othagreetop_yal072 p_othda_god
rename p_othagreetop_yal073 p_othda_sports
rename p_othagreetop_yal074 p_othda_food
rename p_othagreetop_yal075 p_othda_politics
rename p_othagreetop_yal076 p_othda_entertainment

*Interactions and label variables
foreach i in family work god sports food politics entertainment {
 gen p_othnetdatalk_`i' = -1*p_othagree_`i'*p_othfreqtalk_`i'
 label var p_othnetdatalk_`i' "Talk x Net Disagree (1,-1) on `i' with non-family"
 label var p_othfreqtalk_`i' "Freq. discuss `i' with non-family (0=Never;3=Often)"
 label var p_othagree_`i' "Agreement on issue with non-family (-1=DA;0=A & DA,DK;1=A)"
 label var p_othaltagree_`i' "Agreement on issue with non-family (-1=DA;0=A & DA;1=A)"
 label var p_othda_`i' "Disagree on issue with non-family (1=yes)"
}

gen relationship=.
replace relationship=yal051a if yal060_insert=="Person_A"
replace relationship=yal051b if yal060_insert=="Person_B"
replace relationship=yal051c if yal060_insert=="Person_C"
recode relationship (1=1) (2=2) (3=3) (4=4) (*=.)
tab relationship, gen(relation_)
drop relation_1 
rename relation_2 relation_coworker
rename relation_3 relation_friend
rename relation_4 relation_neighbor
label var relation_coworker "Co-worker Discussant"
label var relation_friend "Friend Discussant"
label var relation_neighbor "Neighbor Discussant"

* Sum of all discussion items (agreement)
egen p_othagreesum = rowtotal(p_othagree_*)
egen p_othaltagreesum = rowtotal(p_othaltagree_*)
egen p_othaltagree_n = rownonmiss(p_othaltagree_*)
label var p_othagreesum "Sum of Agreement with non-family member (-7-+7)"
label var p_othaltagreesum "Sum of Alt. Agreement with non-family member"

*Relative frequency of discussion and agreement
foreach i in family work god sports food politics entertainment {
 gen p_agg_rel_othmean_`i' = p_othagree_`i' - ((p_othagreesum - p_othagree_`i')/6)
 label var p_agg_rel_othmean_`i' "Agreement on issue with non-family, relative to mean"
 gen p_aagg_rel_othmean_`i' = p_othagree_`i' - ((p_othaltagreesum - p_othaltagree_`i')/(p_othaltagree_n-1))
 label var p_aagg_rel_othmean_`i' "Alt. Agreement on issue with non-family, relative to mean"
}

******************
*
* SET constant SAMPLE
*
******************
qui reg p_othfreqtalk_* p_othagree_* yal110-yal113 C_* relationship if entered_disc==1
keep if e(sample)

tab relationship [aw=weight]

************************************
*** FREQUENCY T-TESTS **************
************************************
svyset [pweight=weight]
foreach i in family work god sports food entertainment {
disp "`i'"
svy: mean p_othfreqtalk_politics p_othfreqtalk_`i'
test p_othfreqtalk_politics=p_othfreqtalk_`i'
}
svyset, clear

*************************************
* Figure A (Supporting Information), Frequency of discussion by vague or specific identifiers
*************************************

sum p_othfreqtalk_family p_othfreqtalk_work p_othfreqtalk_god p_othfreqtalk_sports p_othfreqtalk_food p_othfreqtalk_entertainment [aw=weight] if specific==0, sep(0)
sum p_othfreqtalk_family p_othfreqtalk_work p_othfreqtalk_god p_othfreqtalk_sports p_othfreqtalk_food p_othfreqtalk_entertainment [aw=weight] if specific==1, sep(0)

sum p_othfreqtalk_politics [aw=weight] if specific==0 & treat_CE_politics==0
sum p_othfreqtalk_politics [aw=weight] if specific==1 & treat_CE_politics==0

sum p_othfreqtalk_politics [aw=weight] if specific==0 & treat_CE_politics==1
sum p_othfreqtalk_politics [aw=weight] if specific==1 & treat_CE_politics==1

sum p_othagree_family p_othagree_work p_othagree_god p_othagree_sports p_othagree_food p_othagree_entertainment [aw=weight], sep(0)
sum p_othagree_politics [aw=weight] if treat_CE_politics==0
sum p_othagree_politics [aw=weight] if treat_CE_politics==1

** Effect of CURRENT EVENTS/POLITICS TREATMENT AFFECT FREQ DISCUSSION AND/OR AGREEMENT
file open myfile using "`localpath'logs\SI_FigureA_StatTests.csv", write replace 
file write myfile ",Estimate, p-value" _n

reg p_othagree_politics treat_CE_politics [aw=weight], r
lincom treat_CE_politics 
local estim=r(estimate)
test treat_CE_politics 
file write myfile "Absolute Agreement,`estim', `r(p)'" _n

reg p_agg_rel_othmean_politics treat_CE_politics [aw=weight], r
lincom treat_CE_politics 
local estim=r(estimate)
test treat_CE_politics 
file write myfile "Relative Agreement,`estim', `r(p)'" _n

reg p_othfreqtalk_politics treat_CE_politics [aw=weight] if specific==0, r
lincom treat_CE_politics 
local estim=r(estimate)
test treat_CE_politics 
file write myfile "Absolute Frequency Talk (Vague),`estim', `r(p)'" _n
reg p_othfreqtalk_politics treat_CE_politics [aw=weight] if specific==1, r
lincom treat_CE_politics 
local estim=r(estimate)
test treat_CE_politics 
file write myfile "Absolute Frequency Talk (Specific),`estim', `r(p)'" _n

*Close file
file close myfile

*************************************
* Table G (Supporting Information), EXPERIMENT
*************************************

forvalues i=110/113{
regress yal`i' food_agree parenting_agree politics_agree [aw=weight], robust
if `i'==110{
outreg using "`localpath'logs\SI_TableG.out", se bracket rdec(3) 3aster replace
}
else{
outreg using "`localpath'logs\SI_TableG.out", se bracket rdec(3) 3aster append
}
}

*************************************
* Tables H and I (Supporting Information), Table 1B REPLICATIONS - FIRST SPECIFIC, THEN VAGUE OUTCOME LABELS
*************************************

preserve

drop if specific_freq==0

* Sum of all discussion items (talk)
egen p_othfreqtalksum = rowtotal(p_othfreqtalk_*)
label var p_othfreqtalksum "Sum of discussion items with non-family member (0-21)"

*Relative frequency of discussion and agreement
foreach i in family work god sports food politics entertainment {
 gen p_talk_rel_othmean_`i' = p_othfreqtalk_`i' - ((p_othfreqtalksum - p_othfreqtalk_`i')/6)
 label var p_talk_rel_othmean_`i' "Freq. discuss `i' with non-family, relative to mean"
}

foreach i in family work god sports food entertainment politics {
gen coworkerXagg_rel_`i'=p_agg_rel_othmean_`i'*relation_coworker
gen friendXagg_rel_`i'=p_agg_rel_othmean_`i'*relation_friend
gen neighborXagg_rel_`i'=p_agg_rel_othmean_`i'*relation_neighbor
label var coworkerXagg_rel_`i' "Co-worker x Agreement on issue, relative to mean"
label var friendXagg_rel_`i' "Friend x Agreement on issue, relative to mean"
label var neighborXagg_rel_`i' "Neighbor x Agreement on issue, relative to mean"
}
gen coworkerXagg_politics=p_othagree_politics*relation_coworker
gen friendXagg_politics=p_othagree_politics*relation_friend
gen neighborXagg_politics=p_othagree_politics*relation_neighbor
label var coworkerXagg_politics "Co-worker x Agreement on issue, (-1=DA;0=A & DA,DK;1=A)"
label var friendXagg_politics "Friend x Agreement on issue, (-1=DA;0=A & DA,DK;1=A)"
label var neighborXagg_politics "Neighbor x Agreement on issue, (-1=DA;0=A & DA,DK;1=A)"

foreach i in family work god sports food entertainment politics {
 *Relative Frequency of Discussion and Relative Agreement
 regress p_talk_rel_othmean_`i' p_agg_rel_othmean_`i' C_* [aweight=weight], robust
 if "`i'"=="family" {
  outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster replace
 }
 else {
  outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append
 }

}
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family, relative to mean")
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family, relative to mean")

regress p_talk_rel_othmean_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family, relative to mean")
regress p_talk_rel_othmean_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family, relative to mean")

regress p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family (0=Never;3=Often)")
regress p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family (0=Never;3=Often)")

oprob p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family (0=Never;3=Often)")
oprob p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableH_Specific.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family (0=Never;3=Often)")

*******
* Supporting Information (Section 4) discussion of whether relationship with discussant affects results (The table does not appear in the Supporting Information Document)
*******

foreach i in family work god sports food entertainment politics {
 *Relative Frequency of Discussion and Relative Agreement
 regress p_talk_rel_othmean_`i' p_agg_rel_othmean_`i' *Xagg_rel_`i' relation_* C_* [aweight=weight], robust
 test coworkerXagg_rel_`i' friendXagg_rel_`i' neighborXagg_rel_`i' 
 if "`i'"=="family" {
  outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Specific.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster replace
 }
 else {
  outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Specific.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append
 }

}
regress p_talk_rel_othmean_politics p_othagree_politics *Xagg_politics relation_* C_* [aweight=weight], robust
 test coworkerXagg_politics friendXagg_politics neighborXagg_politics
outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Specific.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append
regress p_othfreqtalk_politics p_othagree_politics *Xagg_politics relation_* C_* [aweight=weight], robust
 test coworkerXagg_politics friendXagg_politics neighborXagg_politics
outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Specific.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append
oprob p_othfreqtalk_politics p_othagree_politics *Xagg_politics relation_* C_* [aweight=weight], robust
 test coworkerXagg_politics friendXagg_politics neighborXagg_politics
outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Specific.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append

restore

preserve

*******************************************************
* VAGUE FREQUENCY *************************************
*******************************************************

drop if specific_freq==1

* Sum of all discussion items (talk)
egen p_othfreqtalksum = rowtotal(p_othfreqtalk_*)
label var p_othfreqtalksum "Sum of discussion items with non-family member (0-21)"

*Relative frequency of discussion and agreement
foreach i in family work god sports food politics entertainment {
 gen p_talk_rel_othmean_`i' = p_othfreqtalk_`i' - ((p_othfreqtalksum - p_othfreqtalk_`i')/6)
 label var p_talk_rel_othmean_`i' "Freq. discuss `i' with non-family, relative to mean"
}

foreach i in family work god sports food entertainment politics {
gen coworkerXagg_rel_`i'=p_agg_rel_othmean_`i'*relation_coworker
gen friendXagg_rel_`i'=p_agg_rel_othmean_`i'*relation_friend
gen neighborXagg_rel_`i'=p_agg_rel_othmean_`i'*relation_neighbor
label var coworkerXagg_rel_`i' "Co-worker x Agreement on issue, relative to mean"
label var friendXagg_rel_`i' "Friend x Agreement on issue, relative to mean"
label var neighborXagg_rel_`i' "Neighbor x Agreement on issue, relative to mean"
}
gen coworkerXagg_politics=p_othagree_politics*relation_coworker
gen friendXagg_politics=p_othagree_politics*relation_friend
gen neighborXagg_politics=p_othagree_politics*relation_neighbor
label var coworkerXagg_politics "Co-worker x Agreement on issue, (-1=DA;0=A & DA,DK;1=A)"
label var friendXagg_politics "Friend x Agreement on issue, (-1=DA;0=A & DA,DK;1=A)"
label var neighborXagg_politics "Neighbor x Agreement on issue, (-1=DA;0=A & DA,DK;1=A)"


foreach i in family work god sports food entertainment politics {
 *Relative Frequency of Discussion and Relative Agreement
 regress p_talk_rel_othmean_`i' p_agg_rel_othmean_`i' C_* [aweight=weight], robust
 if "`i'"=="family" {
  outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster replace
 }
 else {
  outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append
 }

}
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family, relative to mean")
regress p_talk_rel_othmean_politics p_agg_rel_othmean_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family, relative to mean")

regress p_talk_rel_othmean_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family, relative to mean")
regress p_talk_rel_othmean_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family, relative to mean")

regress p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family (0=Never;3=Often)")
regress p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family (0=Never;3=Often)")

oprob p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==0, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss politics with non-family (0=Never;3=Often)")
oprob p_othfreqtalk_politics p_othagree_politics C_* [aweight=weight] if treat_CE_politics==1, robust
outreg using "`localpath'logs\SI_TableI_Vague.out", se bracket rdec(3) 3aster append ctitle("Freq. discuss current events/politics with non-family (0=Never;3=Often)")

*******
* Supporting Information (Section 4) discussion of whether relationship with discussant affects results (The table does not appear in the Supporting Information Document)
*******

foreach i in family work god sports food entertainment politics {
 *Relative Frequency of Discussion and Relative Agreement
 regress p_talk_rel_othmean_`i' p_agg_rel_othmean_`i' *Xagg_rel_`i' relation_* C_* [aweight=weight], robust
 test coworkerXagg_rel_`i' friendXagg_rel_`i' neighborXagg_rel_`i' 
 if "`i'"=="family" {
  outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Vague.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster replace
 }
 else {
  outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Vague.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append
 }

}
regress p_talk_rel_othmean_politics p_othagree_politics *Xagg_politics relation_* C_* [aweight=weight], robust
 test coworkerXagg_politics friendXagg_politics neighborXagg_politics
outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Vague.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append
regress p_othfreqtalk_politics p_othagree_politics *Xagg_politics relation_* C_* [aweight=weight], robust
 test coworkerXagg_politics friendXagg_politics neighborXagg_politics
outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Vague.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append
oprob p_othfreqtalk_politics p_othagree_politics *Xagg_politics relation_* C_* [aweight=weight], robust
 test coworkerXagg_politics friendXagg_politics neighborXagg_politics
outreg using "`localpath'logs\SI_NoTable_TypeofRelationshipEffect_Vague.out", se bracket rdec(3) adec(3) addstat("F test: Joint Significance of Discussant Interactions",r(p)) 3aster append

restore

**********************************
*
* Supporting Information (Section 4) discussion of whether ordering affects results(The table does not appear in the Supporting Information Document)
*
**********************************

gen randomization=yal060a_grid
replace randomization=yal060b_grid if randomization=="__NA__"
foreach i in r a n d o m i z e ( [ ] ){
replace randomization=subinstr(randomization,"`i'","",.)
}
split randomization, p(",")
drop randomization randomization1 
forvalues i=2/8{
destring randomization`i', replace
local reindex=`i'-1
rename randomization`i' randomization`reindex'
}

local labels="family; work; god; sports; food; politics; entertainment"
forvalues i=0/6{
 gettoken tag labels : labels, parse(";") 
 gen order_`tag'=.
forvalues c=1/7{
 replace order_`tag'=`c' if randomization`c'==`i'
}
 gettoken tag labels : labels, parse(";") 
}

foreach i in family work god sports food entertainment politics {
tab order_`i', gen(D_order)
forvalues a=2/7{
label var D_order`a' "Position in Grid = `a'"
}
drop D_order1
reg p_othfreqtalk_`i' D_order* [aweight=weight], robust
test D_order2 D_order3 D_order4 D_order5 D_order6 D_order7
if "`i'"=="family"{
outreg using "`localpath'logs\SI_NoTable_OrderEffectsFreq.out", se bracket rdec(3) 3aster replace addstat("Joint Significance", r(p)) adec(3) ctitle("Frequency: `i'")
}
else {
outreg using "`localpath'logs\SI_NoTable_OrderEffectsFreq.out", se bracket rdec(3) 3aster append addstat("Joint Significance", r(p)) adec(3) ctitle("Frequency: `i'")
}

reg p_othagree_`i' D_order* [aweight=weight], robust
test D_order2 D_order3 D_order4 D_order5 D_order6 D_order7
if "`i'"=="family"{
outreg using "`localpath'logs\SI_NoTable_OrderEffectsAgree.out", se bracket rdec(3) 3aster replace addstat("Joint Significance", r(p)) adec(3) ctitle("Agree: `i'")
}
else {
outreg using "`localpath'logs\SI_NoTable_OrderEffectsAgree.out", se bracket rdec(3) 3aster append addstat("Joint Significance", r(p)) adec(3) ctitle("Agree: `i'")
}
drop D_order*
}
