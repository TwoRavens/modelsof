*******************************************************************************
********************************UK replication files***************************
*******************************************************************************
******Article "It’s a group thing: How voters go to the polls together"********
*************Yosef Bhatti, Edward Fieldhouse and Kasper M. Hansen**************
*********************accepted in Political Behavior 2018***********************
*******************************************************************************
*****************************used Stata version 14.2***************************
*******************************************************************************

* use latest or any version of BES panel that includes waves 1-7 from http://www.britishelectionstudy.com/data-objects/panel-study-data/ 

* NOTE REPLICATION DATA ALREADY INCLUDES VARIABLES GENERERATED BT THE FOLLOWING COMMANDS. SKIP TO * model in appendix A4 TO REPLICATE ANALYSIS


************Below recoding is already included in replication file*************
* adults in houshold
recode profile_household_size profile_household_children (9999 9998 10 =.)
gen adultshh= profile_household_size- profile_household_children
recode adultshh (-5/-1=.)

* dependent variable // general UK election
gen votetog=.
replace votetog=0 if (genElecTurnoutRetroW6 ==0)
replace votetog=1 if (voteMethod_1W6==1)
replace votetog=2 if (voteMethod_2W6==1)
replace votetog=3 if (voteMethod_3W6==1) | (voteMethod_4W6==1)
replace votetog=1 if (voteMethod_5W6==1)
replace votetog=. if (voteMethod_99W6==1) | (genElecTurnoutRetroW6==9999)
label define votetog 0"abstain" 1"post or proxy" 2"alone" 3"together"
label values votetog votetog

generate int agesq = Age*Age
gen married= marital
recode married (1 2 7=1)(3 4 5 6=0)
label define married 1"married/cohab" 0"unmarried/widowed/divorced"
label values married married

recode profile_household_size (10 9999=.)

recode profile_gross_household (17 9999=.)

gen hhincomemp= profile_gross_household
recode hhincomemp (1=2.5)(2=7.5)(3=12.5)(4=17.5)(5=22.5)(6=27.5)(7=32.5)(8=37.5)(9=42.5)(10=47.5)(11=55)(12=65)(13=85)(14=125)(15=150)
label variable hhincomemp "household income thousands (midpoint)"


* wave 2 // EP UK election
gen votetogw2=.
replace votetogw2=0 if (euroTurnoutRetroW2 ==0)
replace votetogw2=1 if (voteMethodEurope_1W2==1)
replace votetogw2=2 if (voteMethodEurope_2W2==1)
replace votetogw2=3 if (voteMethodEurope_3W2==1) | (voteMethodEurope_4W2==1)
replace votetogw2=. if (euroTurnoutRetroW2==9999)
label values votetog votetogw2


recode efficacyEnjoyVoteW4 efficacyEnjoyVoteW6 (9999=.)
gen enjoyvotechangew4w6= efficacyEnjoyVoteW6- efficacyEnjoyVoteW4
recode efficacyVoteEffortW4 efficacyVoteEffortW6 (9999=.)
gen effortvotechangew4w6= efficacyVoteEffortW4 - efficacyTooMuchEffortW6

recode adultshh (0=.) (1=1)(2=2)(3=3)(4/8=4), generate(hhsizecat)

*************ABOVE recoding is already included in replication file************


*cd [add your own directory]

use "replicationUK.dta", clear


*Table 2 
*EP UK election
tab votetogw2 if votetogw2!=0 [aweight= wt_full_W2] 
tab votetogw2 if votetogw2!=0 & votetogw2!=1 [aweight= wt_full_W2] 
*UK general election
tab votetog if votetog!=0 [aweight= wt_full_W6] 
tab votetog if votetog!=0 & votetog!=1 [aweight= wt_full_W6] 



* model in appendix tabel A4
* EP UK election

mlogit votetogw2 i.hhsizecat i.married i.gender c.Age##c.Age##c.Age i.edlevel hhincomemp profile_household_children [aweight= wt_full_W2]if hhsizecat >= 2, baseoutcome (2)

* General UK election 
mlogit votetog i.hhsizecat i.married i.gender c.Age##c.Age##c.Age i.edlevel hhincomemp profile_household_children [aweight= wt_full_W6] if hhsizecat >= 2, baseoutcome (2)
