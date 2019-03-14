**MASTER DO FILE FOR ANALYSIS OF THE CLERICAL CAMPAIGN EXPERIMENT**

**This do file uses the original data file "Experiment, original data for ajps.dta".  This data file 
**includes the original data provided to us by GfK for all of the variables used in 
**our analysis of the clerical campaign experiment in "Putting Politics First."

**The do file:
** (1) creates the variables necessary to replicate the analysis in the paper
** (2) runs the models using "none" as the dependent variable
** (3) creates the measure of passive secularism and runs models with passive secularism as the dependent variable
** (4) takes the steps necessary to create the measure of active secularism in MPlus (using confirmatory factor analysis
** (note that this means exporting the necessary variables to a comma-delimited data set
** (5) creates active secularism variables based on the MPlus results and runs models with active secularism as the dependent variable

**Change the default directory in Stata to the folder on your computer where the "original data **for ajps" data file is.
**Command to change default directory (change to folder containing data)
**cd "........." 

** Open data
use "Experiment, original data for ajps.dta" , clear
	

** creating the dependent variable: respondents who indicate that their religion is "nothing in particular." Refused coded as missing **
recode relig_pre -1=. 1/23=0 24=1 25=0, gen(none_pre)
recode relig_post -1=. 1/23=0 24=1 25=0, gen(none_post)
label var none_pre "No religion"
label var none_post "No religion"

** generating partyid7 **
gen partyid7_pre = PID1_pre
recode partyid7_pre 1=2 if PID1_pre==1 & PID2_pre==2
recode partyid7_pre 2=7 if PID1_pre==2 & PID2_pre==1
recode partyid7_pre 2=6 if PID1_pre==2 & PID2_pre==2
recode partyid7_pre 3=3 if PID1_pre==3 & PID3_pre==1
recode partyid7_pre 3=5 if PID1_pre==3 & PID3_pre==2
recode partyid7_pre 3=4 if PID1_pre==3 & PID3_pre==3
recode partyid7_pre 5=3 if PID1_pre==5 & PID3_pre==1
recode partyid7_pre 5=5 if PID1_pre==5 & PID3_pre==2
recode partyid7_pre 5=4 if PID1_pre==5 & PID3_pre==3
recode partyid7_pre -1=. 
replace partyid7_pre =. if PID2_pre==-1
label define partyid7 1 "Strong Rep" 2 "Weak Rep" 3 "Leaner Rep" 4 "Ind" 5 "Leaner Dem" 6 "Weak Dem" 7 "Strong Dem"
label value partyid7_pre partyid7
label var partyid7_pre "Party ID, 7 point"


** party ID into 3 categories **
recode partyid7_pre 1/3=1 4=2  5/7=3, gen(partyid3_pre)
label define partyid3 1 "Reps, with leaners" 2 "Inds, without leaners" 3 "Dems, with leaners"
label value partyid3_pre partyid3
label var partyid3_pre "Party ID, 3 point"

** models in Table 3 **

** All, column 1 **
logit none_post none_pre i.treatment 

** Democrats, column 2 **
logit none_post none_pre i.treatment if partyid3_pre==3

** Republicans, column 3 **
logit none_post none_pre i.treatment if partyid3_pre==1

** Independents, displayed in Table A6 of the Supporting Information **
logit none_post none_pre i.treatment if partyid3_pre==2

** calculating confidence intervals for experimental results, Figure A4 of Supporting Information**
** treatment variables are set to 0, none_pre is set to its mean **
tab treatment, gen(treatment_)

** All Respondents **
logit none_post none_pre treatment_2 treatment_3 treatment_4 treatment_5 treatment_6 treatment_7 treatment_8 treatment_9
margins, dydx(treatment_2) at(treatment_3=0 treatment_4=0 treatment_5=0 treatment_6=0 treatment_7=0 treatment_8=0 treatment_9=0 none_pre (mean)) 

** Democrats 
logit none_post none_pre treatment_2 treatment_3 treatment_4 treatment_5 treatment_6 treatment_7 treatment_8 treatment_9 if partyid3_pre==3
margins, dydx(treatment_2) at(treatment_3=0 treatment_4=0 treatment_5=0 treatment_6=0 treatment_7=0 treatment_8=0 treatment_9=0 none_pre (mean)) 

** Republicans **
logit none_post none_pre treatment_2 treatment_3 treatment_4 treatment_5 treatment_6 treatment_7 treatment_8 treatment_9 if partyid3_pre==1
margins, dydx(treatment_2) at(treatment_3=0 treatment_4=0 treatment_5=0 treatment_6=0 treatment_7=0 treatment_8=0 treatment_9=0 none_pre (mean)) 

** Table A7: Exploratory Factor Analyses of Passive Secularism **
factor blvgod_pre relimpall_pre relatend_pre, factors(1)
predict passivesec_pre
replace passivesec_pre = passivesec_pre * -1


factor blvgod_post relimpall_post relatend_post, factors(1)
predict passivesec_post
replace passivesec_post = passivesec_post * -1
label var passivesec_pre "higher = more secular" 
label var passivesec_post "higher = more secular"


** Table A9 **
** All Respondents**
drop treatment_*
regress passivesec_post passivesec_pre i.treatment

** Democrats **
regress passivesec_post passivesec_pre i.treatment if partyid3_pre==3

** Republicans **
regress passivesec_post passivesec_pre i.treatment if partyid3_pre==1

** Independents **
regress passivesec_post passivesec_pre i.treatment if partyid3_pre==2


** Table A8 **

**Creating active secularism variables based on CFA loadings **

** Getting data ready to use in MPlus for CFA **

**Recoding secular belief items to range from 0 (strongly disagree) to 1 (strongly agree)

gen evidpre01=1-((evidence_pre-1)/4)
label define disag 0 "Strongly Disagree"  1 "Strongly Agree"
label values evidpre01 disag
label var evidpre01 "Factual evidence, pre, 0 to 1"
gen evidpost01=1-((evidence_post-1)/4)
label values evidpost01 disag
label var evidpost01 "Factual evidence, post, 0 to 1"

gen bookspre01=1-((books_pre-1)/4)
label values bookspre01 disag
label var bookspre01 "Great books, pre, 0 to 1"
gen bookspost01=1-((books_post-1)/4)
label values bookspost01 disag
label var bookspost01 "Great books, post, 0 to 1"

gen goodlifepre01=1-((goodlife_pre-1)/4)
label values goodlifepre01 disag
label var goodlifepre01 "Good life....reason alone, pre, 0 to 1"
gen goodlifepost01=1-((goodlife_post-1)/4)
label values goodlifepost01 disag
label var goodlifepost01 "Good life....reason alone, post, 0 to 1"

gen freemindpre01=1-((freemind_pre-1)/4)
label values freemindpre01 disag
label var freemindpre01 "Free minds, pre, 0 to 1"
gen freemindpost01=1-((freemind_post-1)/4)
label values freemindpost01 disag
label var freemindpost01 "Free minds, post, 0 to 1"

gen valuespre01=1-((values_pre-1)/4)
label values valuespre01 disag
label var valuespre01 "Values, pre, 0 to 1"
gen valuespost01=1-((values_post-1)/4)
label values valuespost01 disatre
label var valuespost01 "Values, post, 0 to 1"

**Creating dummies for people who are atheists or agnostics either in the IDs
**OR in the religious affiliation question (a la the panel data)

gen ath2_pre=0
replace ath2_pre=1 if relig_pre==21 | term_4_pre==1
label var ath2_pre "Atheist: either in IDs or relig affiliation"
label value ath2_pre no_yes

gen agnos2_pre=0
replace agnos2_pre=1 if relig_pre==22 | term_3_pre==1
label var agnos2_pre "Agnostic: either in IDs or relig affiliation"
label value agnos2_pre no_yes

gen ath2_post=0
replace ath2_post=1 if relig_post==21 | term_4_post==1
label var ath2_post "Atheist: either in IDs or relig affiliation"
label value ath2_post no_yes

gen agnos2_post=0
replace agnos2_post=1 if relig_post==22 | term_3_post==1
label var agnos2_post "Agnostic: either in IDs or relig affiliation"
label value agnos2_post no_yes


**Creating secular ID counts**

gen secid_count_pre=ath2_pre+agnos2_pre+secular_pre+humanist_pre
gen secid_count_post=ath2_post+agnos2_post+secular_post+humanist_post
label var secid_count_pre "Number of Secular IDs"
label var secid_count_post "Number of Secular IDs"

**Truncating secular ID counts to 0-3, (only 1 obs
**with a count of 4 in pre, only 3 obs at 4 in post), and recoding to 0 to 1
replace secid_count_pre=3 if secid_count_pre==4
replace secid_count_pre=secid_count_pre/3

replace secid_count_post=3 if secid_count_post==4
replace secid_count_post=secid_count_post/3


**Creating non-religious guidance variables ranging from 0 to 1
gen nonrel01_pre=nonrel_pre2/3
gen nonrel01_post=nonrel_post2/3
label var nonrel01_pre "Nonreligious guidance, 0-1"
label var nonrel01_post "Nonreligious guidance, 0-1"

save "Experiment, final data for ajps.dta", replace

*** Go to "experiment 1_recodes_forcfa.do" 
** This do file creates a .csv data file for use in the Mplus input files "actsec_pre_nonrandom" and "actsec_post_nonrandom"
** This creates the factor loadings used for active secularism variables

**PART II: Creating factor scores based on CFA loadings (with non-random measurement error)

** opens data file, if necessary ** 
use "Experiment, final data for ajps.dta", clear

gen actsec_cfa_fac_pre=evidpre01+(1.06*bookspre01)+(-.64*goodlifepre01)+(.727*freemindpre01) ///
   +(-.621*valuespre01)+(.92*nonrel01_pre)+(.50*secid_count_pre)
   
gen actsec_cfa_fac_post=evidpost01+(1.09*bookspost01)+(-.695*goodlifepost01)+(.804*freemindpost01) ///
   +(-.779*valuespost01)+(1.05*nonrel01_post)+(.512*secid_count_post)

label var actsec_cfa_fac_pre "Active Secularism Index"
label var actsec_cfa_fac_post "Active Secularism Index"

** Table A10 **
** All Respondents ** 
regress actsec_cfa_fac_post actsec_cfa_fac_pre i.treatment

** Democrats **
regress actsec_cfa_fac_post actsec_cfa_fac_pre i.treatment if partyid3_pre==3

** Republicans **
regress actsec_cfa_fac_post actsec_cfa_fac_pre i.treatment if partyid3_pre==1

** Independents **
regress actsec_cfa_fac_post actsec_cfa_fac_pre i.treatment if partyid3_pre==2

save, replace 

