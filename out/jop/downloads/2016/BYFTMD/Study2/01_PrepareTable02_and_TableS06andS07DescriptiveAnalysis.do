set more off
set matsize 1000

**************************************
*
* Table S05: Study 2, subject demographics, by gender
*
**************************************

use data\profile_data_winnowed.dta
keep userid female ownage height_stdev_quintile rc_* educ_* religcat_*
compress
save temp.dta, replace
clear

*Now we code up questions
use data\questions_byuserid.dta 
keep userid q41-q47
sort userid
drop if userid==userid[_n-1]
foreach var of varlist q41-q47 {
	tab `var', gen(`var'_)
	drop `var'
}
joinby userid using temp.dta
drop userid
compress

preserve
keep if female==0
version 9.2: outsum * using tables\TableS06_Study2Demographics.out, replace bracket ctitle("Men")
restore
keep if female==1
version 9.2: outsum * using tables\TableS06_Study2Demographics, bracket append ctitle("Women")
clear

/*
Dyads
Men
Women
Outcome rate
*/

*Subsets is whether we are conditioning on profile questions, as well as depth of messaging.
local subsets "all domsg5 lflt lfltkids"
foreach subset of local subsets {

	noisily di "-->"
	noisily di "--> Working on this subset: `subset'"
	noisily di "-->"

	*First we code profile items for appropriate sample/subset
	use data\profile_data_winnowed.dta

	if "`subset'"=="lflt" {
	 keep if lookingfor_long_term_dating==1
	 }
	else if "`subset'"=="lfltkids" {
	 keep if lookingfor_long_term_dating==1 & kids_want==1
	}

	/*
	Match Height Quintile
	Match Age (5 year bins)
	Match Race
	Match Religion
	Match Education
	*/

	*Put everything into bins
	gen match_01heightcat=height_stdev_quintile

	gen match_02agecat=int((ownage-18)/5)-1

	gen match_03racecat=.
	replace match_03racecat=-1 if rc_asian==1
	replace match_03racecat=0 if rc_middleeastern==1
	replace match_03racecat=1 if rc_black==1
	replace match_03racecat=2 if rc_nativea==1
	replace match_03racecat=3 if rc_indian==1
	replace match_03racecat=4 if rc_pacific==1
	replace match_03racecat=5 if rc_hispanic==1
	replace match_03racecat=6 if rc_white==1
	replace match_03racecat=7 if rc_other==1
	replace match_03racecat=8 if rc_multiple==1
	replace match_03racecat=99 if rc_none==1

	gen match_04religioncat=.
	replace match_04religioncat=1 if religcat_1==1
	replace match_04religioncat=2 if religcat_2==1
	replace match_04religioncat=3 if religcat_3==1
	replace match_04religioncat=4 if religcat_4==1
	replace match_04religioncat=5 if religcat_5==1
	replace match_04religioncat=6 if religcat_6==1
	replace match_04religioncat=7 if religcat_7==1
	replace match_04religioncat=8 if religcat_8==1
	replace match_04religioncat=99 if religcat_9==1
	replace match_04religioncat=10 if religcat_10==1

	gen match_05educcat=.
	replace match_05educcat=1 if educ_hs==1
	replace match_05educcat=2 if educ_assoc==1
	replace match_05educcat=3 if educ_college==1
	replace match_05educcat=4 if educ_grad==1
	replace match_05educcat=99 if educ_null==1

	keep userid zip match_*

	compress
	save temp.dta, replace
	clear

	*Now we code up questions
	use data\questions_byuserid.dta 

	/*
	Match Ideology
	Match Partisanship
	Match Media Preferences
	Match Role of Church
	Match How Balance Budget
	Match Political Interest
	Match Duty to Vote
	*/

	keep userid q41-q47
	collapse (first) q*, by(userid)

	recode q41 (1=1) (2=2) (3=3) (*=99), gen(match_06ideology)
	recode q43 (1=1) (2=2) (3=3) (*=99), gen(match_07pid)
	recode q46 (1=1) (2=2) (3=3) (*=99), gen(match_08media)
	recode q45 (1=1) (2=2) (*=99), gen(match_09church)
	recode q47 (1=1) (2=2) (*=99), gen(match_10budget)
	recode q42 (1=1) (2=2) (3=3) (4=4) (*=99), gen(match_11interest)
	recode q44 (1=1) (2=2) (*=99), gen(match_12dutyvote)

	keep userid match_*

	*Merge to profile
	joinby userid using temp.dta, unmatched(both)

	keep if _merge~=1
	drop _merge

	qui foreach var of varlist match_* {
	 replace `var'=99 if `var'==.
}
order userid zipcode2digit match_*

save temp.dta, replace

clear
use data\men_useridbyzip.dta 
joinby userid using temp.dta
save temp_alldyadsmatchsummarymen_zip.dta, replace

clear
use data\women_useridbyzip.dta
joinby userid using temp.dta
save temp_alldyadsmatchsummarywoman_zip.dta, replace

/*************************************
* For each covariate, calculate # of dyads, overall and among nonmissing cases of covariate. This is for mansend and bothsend cases
*************************************/
cap erase temp_dyadcounts.dta

qui foreach cv of varlist match_* {
	use userid zipcode2digit `cv' using temp_alldyadsmatchsummarymen_zip.dta
	summ match_*
	gen allmen=1
	gen nonmissmen=`cv'~=99
	collapse (sum) allmen nonmissmen, by(zip)
	save temp.dta, replace

	use userid zipcode2digit `cv' using temp_alldyadsmatchsummarywoman_zip.dta
	gen allwomen=1
	gen nonmisswomen=`cv'~=99
	collapse (sum) allwomen nonmisswomen, by(zip)

	joinby zip using temp.dta

	gen n_dyads_all= allmen*allwomen
	gen n_dyads_nomiss= nonmissmen*nonmisswomen

	rename allmen n_men
	rename allwomen n_women

	collapse (sum) n_dyads_all n_dyads_nomiss n_men n_women
	format * %9.0f
	gen dv="`cv'"

	cap append using temp_dyadcounts.dta
	save temp_dyadcounts.dta, replace
	clear
}
 
/*************************************
* For each covariate, calculate # of matches, overall and among nonmissing cases of covariate
*************************************/
cap erase temp_dyadmatches.dta

*This dataset is loaded just to get list of match variables
use temp_alldyadsmatchsummarywoman_zip.dta

qui foreach cv of varlist match_* {

	use userid zipcode2digit `cv' using temp_alldyadsmatchsummarymen_zip.dta
	gen allmen=1
	gen nonmissmen=`cv'~=99
	collapse (sum) allmen nonmissmen, by(zip `cv')
	save temp.dta, replace

	use userid zipcode2digit `cv' using temp_alldyadsmatchsummarywoman_zip.dta
	gen allwomen=1
	gen nonmisswomen=`cv'~=99
	collapse (sum) allwomen nonmisswomen, by(zip `cv')

	joinby zip `cv' using temp.dta

	*gen n_matches_all= allmen*allwomen
	gen n_matches_nomiss= nonmissmen*nonmisswomen

	collapse (sum) n_matches_nomiss
	format * %9.0f
	gen dv="`cv'"

	cap append using temp_dyadmatches.dta
	save temp_dyadmatches.dta, replace
	clear

 } 

/*************************************
* For each covariate, calculate # of matches, overall and among nonmissing cases of covariate, given communication
*************************************/

***MANSEND
cap erase data\mansenddyadmatches.dta

clear
use data\msg_headers_processed_winnowed.dta

keep if msg_from_men >=1 & msg_firstbyman==1
if "`subset'"=="domsg5" {
 keep if msg_from_men >=5
}

keep m_userid f_userid
rename f_userid userid
joinby userid using temp_alldyadsmatchsummarywoman_zip.dta
rename userid f_userid
qui foreach var of varlist match_* {
 rename `var' f_`var'
}
rename m_userid userid
joinby userid zipcode2digit using temp_alldyadsmatchsummarymen_zip.dta

qui foreach cv of varlist match_* {
	preserve

	gen mansend_n_all=`cv'~=.
	gen mansend_n_nomiss=`cv'~=99 & f_`cv'~=99

	*gen mansend_matches_all = `cv'==f_`cv'
	gen mansend_matches_nomiss =`cv'==f_`cv'
	replace mansend_matches_nomiss=. if `cv'==99 | f_`cv'==99

	collapse (sum) mansend_n_all mansend_n_nomiss mansend_matches_nomiss
	format * %9.0f
	gen dv="`cv'"

	cap append using data\mansenddyadmatches.dta
	save data\mansenddyadmatches.dta, replace
	restore
}

clear

*Now put all the files together to get the data we need to calculate match rates/etc.
use temp_dyadcounts.dta
joinby dv using temp_dyadmatches.dta
joinby dv using data\mansenddyadmatches.dta

*gen mrate_all = n_matches_all/ n_dyads_all
gen mrate_nomiss = n_matches_nomiss/ n_dyads_nomiss
*gen mrate_mansend_all= mansend_matches_all/ mansend_n_all
gen mrate_mansend_nomiss= mansend_matches_nomiss/ mansend_n_nomiss

*gen pvalue_diff_all=.
gen pvalue_diff_nomiss=.
format pvalue_* %4.3f

count
qui forvalues ctr = 1(1)`r(N)' {
	local a=n_dyads_nomiss[`ctr']
	local b=n_matches_nomiss[`ctr']
	local c=mansend_n_nomiss[`ctr']
	local d=mansend_matches_nomiss[`ctr']
	prtesti  `a' `b' `c' `d', count
	local temp=2*(1-normal(abs(`r(z)')))
	replace pvalue_diff_nomiss=`temp' in `ctr'
}

gen mansendrate=mansend_n_all/n_dyads_all

gen subset="`subset'"
keep  dv subset n_men n_women mansendrate n_dyads_all n_dyads_nomiss mrate_nomiss mrate_mansend_nomiss pvalue_diff_nomiss
order dv subset n_men n_women mansendrate n_dyads_all n_dyads_nomiss mrate_nomiss mrate_mansend_nomiss pvalue_diff_nomiss

cap append using tables\Table2_mansenddyadmatches.dta
sort subset dv
save tables\Table2_mansenddyadmatches.dta, replace
 
***BOTHSEND

cap erase data\bothsenddyadmatches.dta

clear
use data\msg_headers_processed_winnowed.dta
keep if msg_from_men >=1 & msg_firstbyman==1 & msg_from_woman>=1
if "`subset'"=="domsg5" {
 keep if  msg_from_men >=5 & msg_from_woman>=5
}

keep m_userid f_userid
rename f_userid userid
joinby userid using temp_alldyadsmatchsummarywoman_zip.dta
rename userid f_userid
qui foreach var of varlist match_* {
 rename `var' f_`var'
}
rename m_userid userid
joinby userid zipcode2digit using temp_alldyadsmatchsummarymen_zip.dta

qui foreach cv of varlist match_* {
	preserve

	gen bothsend_n_all=`cv'~=.
	gen bothsend_n_nomiss=`cv'~=99 & f_`cv'~=99

	*gen bothsend_matches_all = `cv'==f_`cv'
	gen bothsend_matches_nomiss = `cv'==f_`cv'
	replace bothsend_matches_nomiss=. if `cv'==99 | f_`cv'==99

	collapse (sum) bothsend_n_all bothsend_n_nomiss bothsend_matches_nomiss
	format * %9.0f
	gen dv="`cv'"

	cap append using data\bothsenddyadmatches.dta
	save data\bothsenddyadmatches.dta, replace
	restore
}

clear

*Now put all the files together to get the data we need to calculate match rates/etc.
use temp_dyadcounts.dta
joinby dv using temp_dyadmatches.dta
joinby dv using data\bothsenddyadmatches.dta
   

*gen mrate_all = n_matches_all/ n_dyads_all
gen mrate_nomiss = n_matches_nomiss/ n_dyads_nomiss
*gen mrate_bothsend_all= bothsend_matches_all/ bothsend_n_all
gen mrate_bothsend_nomiss= bothsend_matches_nomiss/ bothsend_n_nomiss

*gen pvalue_diff_all=.
gen pvalue_diff_nomiss=.
format pvalue_* %4.3f

count
qui forvalues ctr = 1(1)`r(N)' {
	local a=n_dyads_nomiss[`ctr']
	local b=n_matches_nomiss[`ctr']
	local c=bothsend_n_nomiss[`ctr']
	local d=bothsend_matches_nomiss[`ctr']
	prtesti  `a' `b' `c' `d', count
	local temp=2*(1-normal(abs(`r(z)')))
	replace pvalue_diff_nomiss=`temp' in `ctr'
}

gen bothsendrate=bothsend_n_all/n_dyads_all

gen subset="`subset'"
keep  dv subset n_men n_women bothsendrate n_dyads_all n_dyads_nomiss mrate_nomiss mrate_bothsend_nomiss pvalue_diff_nomiss
order dv subset n_men n_women bothsendrate n_dyads_all n_dyads_nomiss mrate_nomiss mrate_bothsend_nomiss pvalue_diff_nomiss

cap append using tables\Table2_bothsenddyadmatches.dta
sort subset dv
save tables\Table2_bothsenddyadmatches.dta, replace

/*************************************
* *CONDL REPLY. Note this is different because here we have to calculate naive match rate to within the subset of cases where the man sends first, etc.
*************************************/

cap erase data\condlreplydyadmatches.dta

clear
use data\msg_headers_processed_winnowed.dta
keep if msg_from_men >=1 & msg_firstbyman==1 
gen womenreply=msg_from_woman>=1
if "`subset'"=="domsg5" {
 drop womenreply
 gen womenreply=msg_from_woman>=5
}

keep m_userid f_userid womenreply
rename f_userid userid
joinby userid using temp_alldyadsmatchsummarywoman_zip.dta
rename userid f_userid
qui foreach var of varlist match_* {
 rename `var' f_`var'
}
rename m_userid userid
joinby userid zipcode2digit using temp_alldyadsmatchsummarymen_zip.dta
rename userid m_userid

sort m_userid
count if m_userid~=m_userid[_n-1]
gen n_men=`r(N)'

sort f_userid
count if f_userid~=f_userid[_n-1]
gen n_women=`r(N)'

foreach cv of varlist match_* {
	preserve

	gen n_cr_dyads_all=1
	gen n_cr_dyads_nomiss=`cv'~=99 & f_`cv'~=99

	gen condlreply_n_all=womenreply
	gen condlreply_n_nomiss=condlreply_n_all
	replace condlreply_n_nomiss=. if `cv'==99 | f_`cv'==99

	*gen n_cr_matches_all = `cv'==f_`cv' 
	gen n_cr_matches_nomiss = `cv'==f_`cv' 
	replace n_cr_matches_nomiss=. if `cv'==99 | f_`cv'==99

	*gen condlreply_matches_all = `cv'==f_`cv' & womenreply
	gen condlreply_matches_nomiss = `cv'==f_`cv' & womenreply
	replace condlreply_matches_nomiss=. if `cv'==99 | f_`cv'==99

	collapse (max) n_men n_women (sum) n_cr_dyads_all n_cr_dyads_nomiss condlreply_n_all condlreply_n_nomiss n_cr_matches_nomiss condlreply_matches_nomiss
	format * %9.0f
	gen dv="`cv'"

	cap append using data\condlreplydyadmatches.dta
	save data\condlreplydyadmatches.dta, replace
	restore
}

clear
use data\condlreplydyadmatches.dta

*gen mrate_all = n_cr_matches_all/ n_cr_dyads_all
gen mrate_nomiss = n_cr_matches_nomiss/ n_cr_dyads_nomiss
*gen mrate_cr_all= condlreply_matches_all/ condlreply_n_all
gen mrate_cr_nomiss= condlreply_matches_nomiss/ condlreply_n_nomiss

*gen pvalue_diff_all=.
gen pvalue_diff_nomiss=.
format pvalue_* %4.3f

count
qui forvalues ctr = 1(1)`r(N)' {
	local a=n_cr_dyads_nomiss[`ctr']
	local b=n_cr_matches_nomiss[`ctr']
	local c=condlreply_n_nomiss[`ctr']
	local d=condlreply_matches_nomiss[`ctr']
	prtesti  `a' `b' `c' `d', count
	local temp=2*(1-normal(abs(`r(z)')))
	replace pvalue_diff_nomiss=`temp' in `ctr'
}
gen crrate=condlreply_n_all/n_cr_dyads_all

gen subset="`subset'"
keep  dv subset n_men n_women crrate n_cr_dyads_all n_cr_dyads_nomiss mrate_nomiss mrate_cr_nomiss pvalue_diff_nomiss
order dv subset n_men n_women crrate n_cr_dyads_all n_cr_dyads_nomiss mrate_nomiss mrate_cr_nomiss pvalue_diff_nomiss

cap append using tables\Table2_condlreplydyadmatches.dta
sort subset dv
save tables\Table2_condlreplydyadmatches.dta, replace

clear

}

!erase temp_alldyadsmatchsummarymen_zip.dta
!erase temp_alldyadsmatchsummarywoman_zip.dta
!erase temp_dyadcounts.dta
!erase temp.dta
!erase temp_dyadmatches.dta
!erase data\mansenddyadmatches.dta
!erase data\bothsenddyadmatches.dta
!erase data\condlreplydyadmatches.dta
