set more off
cd "...\tables"
***USE FILE
insheet using "..\mturk_replication.csv", clear 
//creates indicator for the replication study
gen replication=1
//append data from study 1
append using "..\mturk_data.dta"
replace replication=0 if replication==.
label var replication "Study 2 (1=yes)"
egen pid=rmean(pid_dstr pid_rstr pid_lean)
label var pid "Party ID (-3=S. Dem; 3=S. Rep)"
replace pid =. if pid<0 & pid>-1


*** TURNOUT EXPERIMENT VARIABLES
*** THIS CODE ACCOUNTS FOR THE FACT THAT WE RANDOMIZED WHICH PAIR OF EXPERIMENTS EACH RESPONDENT COMPLETED, AS WELL AS THE ORDER OF THOSE
*** EXPERIMENTS. OUTCOME AND TREATMENT MEASURES FOR EACH EXPERIMENT WERE RECORDED IN VARIABLES WITHOUT REGARD FOR WHICH EXPERIMENT WAS PRESENTED FIRST.
*** THE CODE BELOW ALIGNS VARIABLES WITH THE APPROPRIATE EXPERIMENTAL PROTOCOL (E.G., THE BATTLEGROUND EXPERIMENT). 
* NOTE: the A in "1A" indicates the first time an item from a given class of voting behaviors (e.g. within battleground conditions) was presented; 
* the Numbers index the two classes of voting behavior. E.g., 2A is the beginning of survey occurance of the first class of behaviors
** FIRST- Generate string variables that contain the text of the treatment presented within each class of behaviors.
** These values will be missing for respondents not assigned to a given class of behaviors (e.g., if the respondent was not assigned to 
** read about battleground-related voting behavior, exp_battleground_treat_1 and exp_battleground_treat_2 will be missing)
** Note that here the numbers index the treatments for the first and second times the vignette with that class of behaviors was presented.

**NEW NOTE (7/21/16): Respondents were randomly assigned to two vignettes with two different voting behavior treatments (votingbehavior1_treat=1 is peer influence; 
**votingbehavior2_treat==0 is battleground status; votingbehavior2_treat==1 is competitiveness. The order in which the pair was presented was randomized 
**(vignette_order=0 means peer presented first [if at all]; vignette_order=1 means peer presented second and competitiveness/BG presented first)
gen exp_social_treat_1=votingbehavior1a if vignette_order==0 &  votingbehavior1_treat==1
replace exp_social_treat_1=votingbehavior2a if vignette_order==1 &  votingbehavior1_treat==1
replace exp_social_treat_1="don't vote when most of the people they know are not going to vote" if exp_social_treat_1=="don't   vote when most of the people they know are not going to vote"

gen exp_battleground_treat_1=votingbehavior1a if vignette_order==1 &  votingbehavior2_treat==0
replace exp_battleground_treat_1=votingbehavior2a if vignette_order==0 &  votingbehavior2_treat==0
replace exp_battleground_treat_1="don't vote in presidential elections, even when the outcome in their state is likely to determine the national election outcome" if exp_battleground_treat_1=="don't vote   in presidential elections, even when the outcome in their state is likely to determine the national election outcome"
replace exp_battleground_treat_1="don't vote in presidential elections when the outcome in their state is unlikely to determine the national election outcome" if exp_battleground_treat_1=="don't vote in presidential elections when the outcome in their   state is unlikely to determine the national election outcome"
replace exp_battleground_treat_1="vote in presidential elections, even when the outcome in their state is unlikely to determine the national election outcome" if exp_battleground_treat_1=="vote in presidential elections, even   when the outcome in their state is unlikely to determine the national election outcome"

gen exp_competitive_treat_1=votingbehavior1a if vignette_order==1 &  votingbehavior2_treat==1
replace exp_competitive_treat_1=votingbehavior2a if vignette_order==0 &  votingbehavior2_treat==1
replace exp_competitive_treat_1="vote when an election is expected to be close, but don't vote when an election is not expected to be close" if exp_competitive_treat_1=="vote when an election is expected   to be close, but don't vote when an election is not expected to be close"
replace exp_competitive_treat_1="don't vote both when an election is expected to be close or when an election is not expected to be close" if exp_competitive_treat_1=="don't vote both when an election is expected to be close or when an election is   not expected to be close"


** SECOND- Generate non-voting behavior strings. These variables are indexed in the order presented (e.g., othbehavior1 and othbehavior2 are the  
** behaviors associated with the first vignette presented; 3 and 4 were presented along with the second vignette--"vignette_order=1"). The same behaviors 
** were repeated in the second occurance of each behavior type vignette.
gen exp_social_other_1=othbehavior1 if vignette_order==0 & votingbehavior1_treat==1
gen exp_social_other_2=othbehavior2 if vignette_order==0 & votingbehavior1_treat==1
replace exp_social_other_1=othbehavior3 if vignette_order==1 & votingbehavior1_treat==1
replace exp_social_other_2=othbehavior4 if vignette_order==1 & votingbehavior1_treat==1

gen exp_battleground_other_1=othbehavior1 if vignette_order==1 & votingbehavior2_treat==0
gen exp_battleground_other_2=othbehavior2 if vignette_order==1 & votingbehavior2_treat==0
replace exp_battleground_other_1=othbehavior3 if vignette_order==0 & votingbehavior2_treat==0
replace exp_battleground_other_2=othbehavior4 if vignette_order==0 & votingbehavior2_treat==0

gen exp_competitive_other_1=othbehavior1 if vignette_order==1 & votingbehavior2_treat==1
gen exp_competitive_other_2=othbehavior2 if vignette_order==1 & votingbehavior2_treat==1
replace exp_competitive_other_1=othbehavior3 if vignette_order==0 & votingbehavior2_treat==1
replace exp_competitive_other_2=othbehavior4 if vignette_order==0 & votingbehavior2_treat==1


** THIRD- Convert ratings associated with the vignettes from strings to numeric
** THIRD- Convert ratings associated with the vignettes from strings to numeric
forvalues i=1/2{
forvalues t=1/4{
gen eval_`i'_`t'=.
replace eval_`i'_`t'=-3 if vign`i'_rate`t'=="Strongly disagree"
replace eval_`i'_`t'=-2 if vign`i'_rate`t'=="Disagree"
replace eval_`i'_`t'=-1 if vign`i'_rate`t'=="Somewhat disagree"
replace eval_`i'_`t'=0 if vign`i'_rate`t'=="Neither agree nor disagree"
replace eval_`i'_`t'=1 if vign`i'_rate`t'=="Somewhat agree"
replace eval_`i'_`t'=2 if vign`i'_rate`t'=="Agree"
replace eval_`i'_`t'=3 if vign`i'_rate`t'=="Strongly agree"
}
* Generate mean rating scales
egen eval_`i'=rmean(eval_`i'_1 eval_`i'_2 eval_`i'_3)
}


* Match ratings with vignette types
gen eval_social=eval_1 if vignette_order==0 &  votingbehavior1_treat==1
replace eval_social=eval_2 if vignette_order==1 &  votingbehavior1_treat==1
gen eval_social_citizen=eval_1_4 if vignette_order==0 &  votingbehavior1_treat==1
replace eval_social_citizen=eval_2_4 if vignette_order==1 &  votingbehavior1_treat==1

gen eval_battleground=eval_1 if vignette_order==1 &  votingbehavior2_treat==0
replace eval_battleground=eval_2 if vignette_order==0 &  votingbehavior2_treat==0
gen eval_battleground_citizen=eval_1_4 if vignette_order==1 &  votingbehavior2_treat==0
replace eval_battleground_citizen=eval_2_4 if vignette_order==0 &  votingbehavior2_treat==0

gen eval_competitive=eval_1 if vignette_order==1 &  votingbehavior2_treat==1
replace eval_competitive=eval_2 if vignette_order==0 &  votingbehavior2_treat==1
gen eval_competitive_citizen=eval_1_4 if vignette_order==1 &  votingbehavior2_treat==1
replace eval_competitive_citizen=eval_2_4 if vignette_order==0 &  votingbehavior2_treat==1


** FOURTH- Tab string variables and create indicators for all treatments
foreach i in battleground competitive social{
tab exp_`i'_treat_1, gen(`i'_1_D)
tab exp_`i'_other_1, gen(`i'_oth1_D)
tab exp_`i'_other_2, gen(`i'_oth2_D)
forvalues c=1/16{
gen `i'_oth_D`c'=`i'_oth1_D`c'+`i'_oth2_D`c'
local other_label : variable label `i'_oth1_D`c'
local other_label =proper(subinstr("`other_label'","exp_`i'_other_1==","",.))
label var `i'_oth_D`c' "`other_label'"
}
* drop "Recycles"
drop `i'_oth_D16
}

** Label voting behavior treatments
label var battleground_1_D1 "Don't Vote, When State Unlikely to Determine Outcome"
label var battleground_1_D2 "Don't Vote, Even When State Likely to Determine Outcome"
label var battleground_1_D3 "Vote, When State Likely to Determine Outcome"
label var battleground_1_D4 "Vote, Even When State Unlikely to Determine Outcome"
label var competitive_1_D1 "Don't Vote Whether Expected to be Close or Not"
label var competitive_1_D2 "Vote Regardless of Whether Close or Not Close"
label var competitive_1_D3 "Only Vote When Expected to be Close"
label var social_1_D1 "Don't Vote Even When Most of the People they Know are Going To Vote"
label var social_1_D2 "Don't Vote When Most of the People they Know are Not Going To Vote"
label var social_1_D3 "Vote Even When Most of the People They Know are Not Going To Vote"
label var social_1_D4 "Vote When Most of the People they Know are Going to Vote"

**KEEP ONLY VARIABLES NEEDED FOR ANALYSIS
keep replication vignette_order pid yob educ r_* female polinterest battleground* competitive* social* eval_* votingbehavior*
save "..\replication_Conditional_Norms_JOP.dta", replace
