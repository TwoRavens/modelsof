**Getting experimental data ready to use in Mplus

**Command to change default directory (change to folder containing data)
**cd ..........

**Open data 

use "Experiment, original data for ajps"

**Keeping only the variables necessary to do the CFA
** in final file, will not need the following command, all variables will be included **

keep evidence_pre evidence_post books_pre books_post freemind_pre freemind_post ///
goodlife_pre goodlife_post values_pre values_post relig_pre relig_post term_3_pre ///
term_3_post term_4_pre term_4_post secular_pre secular_post humanist_pre humanist_post ///
nonrel_pre2 nonrel_post2 CaseID

**Recoding secular belief items to range from 0 (strongly disagree) to 1 (strongly agree)

gen evidpre01=1-((evidence_pre-1)/4)
label define disag 0 "Strongly Disagree" 1 "Strongly Agree"
label values evidpre01 disag
label var evidpre01 "Factual evidence, pre, 0 to 1"
gen evidpost01=1-((evidence_post-1)/4)
label values evidpost01 disag
label var evidpost01 "Factual evidence, post, 0 to 1"

gen bookspre01=1-((books_pre-1)/4)
label values bookspre01 disag
label var bookspre01 "Great BOOKS, pre, 0 to 1"
gen bookspost01=1-((books_post-1)/4)
label values bookspost01 disag
label var bookspost01 "Great BOOKS, post, 0 to 1"

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
label values valuespost01 disag
label var valuespost01 "Values, post, 0 to 1"

**Creating dummies for people who are atheists or agnostics either in the IDs
**OR in the religious affiliation question (a la the panel data)

gen ath2_pre=0
replace ath2_pre=1 if relig_pre==21 | term_4_pre==1
label var ath2_pre "Atheist: either in IDs or relig affiliation"

gen agnos2_pre=0
replace agnos2_pre=1 if relig_pre==22 | term_3_pre==1
label var ath2_pre "Agnostic: either in IDs or relig affiliation"

gen ath2_post=0
replace ath2_post=1 if relig_post==21 | term_4_post==1
label var ath2_post "Atheist: either in IDs or relig affiliation"

gen agnos2_post=0
replace agnos2_post=1 if relig_post==22 | term_3_post==1
label var ath2_post "Agnostic: either in IDs or relig affiliation"

**Creating secular ID counts**

gen secid_count_pre=ath2_pre+agnos2_pre+secular_pre+humanist_pre
gen secid_count_post=ath2_post+agnos2_post+secular_post+humanist_post

**Truncating secular ID counts to 0-3, a la measurement paper (and only 1 obs
**with a count of 4 in pre, only 3 obs at 4 in post), and recoding to 0 to 1
replace secid_count_pre=3 if secid_count_pre==4
replace secid_count_pre=secid_count_pre/3

replace secid_count_post=3 if secid_count_post==4
replace secid_count_post=secid_count_post/3

**Creating non-religious guidance variables ranging from 0 to 1
gen nonrel01_pre=nonrel_pre2/3
gen nonrel01_post=nonrel_post2/3

**Drop variables not used in CFA
keep CaseID evidpre01-valuespost01 secid_count_pre-nonrel01_post

**Recoding all missing values to -99

mvencode _all, mv(-99)

**Save data **
save actsec1, replace
 
**Export data to a comma-separated delimited text file called "actsec1.csv" 
**(No variable names and numeric values only)
export delimited using "actsec1.csv", novarnames nolabel replace




   
 


