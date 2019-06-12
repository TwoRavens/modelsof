****
****
****	Replication file for analyses of GSS for:
****		
****	"The Two Income-Participation Gaps"
****
****	by Christopher Ojeda
****
****
****	Table of Contents
****
****	- Section 1: Data Prep
****
****	- Section 2: Analyses for Main Text
****
****	- Section 3: Graphing the Results
****
****	- Section 4: Analyses for Appendix
****
****
****	Analyses carried out using Stata/SE 14.2
****

use "GSS_data.dta", clear

********************************************************************************
****** Section 1: Data Prep

/* This section cleans and recodes the key variables in preparation for the analyses 
that are conducted in the following section. Where commands go beyond simple
recodes or renames, comments are used to describe what is occuring and why. */

**
** Vote
gen vote = .
replace vote = vote08 if year == 2010 | year == 2012
replace vote = vote04 if year == 2006 | year == 2008
replace vote = vote00 if year == 2002 | year == 2004
replace vote = vote96 if year == 1998 | year == 2000
replace vote = vote92 if year == 1994 | year == 1996
replace vote = vote88 if year == 1990 | year == 1992
replace vote = vote84 if year == 1986 | year == 1988
replace vote = vote80 if year == 1982 | year == 1984
replace vote = vote76 if year == 1978 | year == 1980
replace vote = vote72 if year == 1974 | year == 1976
replace vote = vote68 if year == 1970 | year == 1972
recode vote 2=0 3=. 4=.
replace vote = . if vote == . | vote == .d | vote == .n

**
** Current Economic Status

* This section of code identifies the family size and composition of respondents
rename hompop hh_total
gen fam_size = hh_total
replace fam_size = 9 if hh_total > 9
rename adults hh_adult
gen child_num = fam_size - hh_adult
replace child_num = 999 if child_num == .
gen senior = 0
replace senior = 1 if age > 64 & (fam_size == 1 | fam_size == 2)
replace senior = 999 if age == . & (fam_size == 1 | fam_size == 2)

* This section merges in povety needs and annual inflation data
merge m:1 year fam_size child_num senior using "poverty_needs.dta"
drop if _merge == 2
drop _merge
merge m:1 year using "CPI_1980_2013.dta" 
drop if _merge == 2
drop _merge

* This code recalculates income into year-appropriate dollars, rather than 2000 dollars
gen inflation2000 = 172.2/inflation
gen coninc_year = coninc/inflation2000

* This command generates the needs-adjusted income measure
gen inc_adj = coninc_year/pov_level

* This command logs the continuous measures of economic status; .001 is added so that
* needs-adjusted incomes of 0 are not dropped from the analyses
gen log_incadj = log(inc_adj + .001)

**
** Economic History
gen incom16_original = incom16
replace incom16 = . if incom16 == .a | incom16 == .b | incom16 == .i
*missing years for incom16: 1970, 1992, 1996, 1998, 2000

**
** Age
tab age, missing
replace age = . if age == .n

**
** Gender
tab sex
gen female = 0
replace female = 1 if sex == 2

**
** Race
tab race, missing
gen white = 0
gen black = 0
gen otherrace = 0
replace white = 1 if race == 1
replace black = 1 if race == 2
replace otherrace = 1 if race == 3

**
** Parental education
tab paeduc
replace paeduc = . if paeduc == .d | paeduc == .i | paeduc == .n

**
** South
gen south16 = 0
replace south16 = 1 if reg16 == 5 | reg16 == 6 | reg16 == 7
replace south = . if reg16 == .

**
** Education
sum educ
tab1 educ, missing
replace educ = . if educ == .n | educ == .d | educ == .c

**
** Church attendance
replace attend = . if attend == .d
gen attend_mo = attend
recode attend_mo 8=1 7=1 6=1 5=1 4=1 3=0 2=0 1=0

**
** Health
replace health = . if health == .i | health == .n | health == .d
recode health 4=0 3=1 2=2 1=3

**
** Mobility since the age of 16
tab mobile16
replace mobile16 = . if mobile16 == .d | mobile16 == .1 | mobile16 == .n
gen res_mobility = 0
replace res_mobility = 1 if mobile16 == 3
replace res_mobility = . if mobile16 == .

**
** Marital status
tab1 marital, missing
gen married = 0
replace married = 1 if marital == 1
replace married = . if marital == .n

**
** Political interest
replace news = . if news == .i | news == .n
recode news 1=5 2=4 3=3 4=2 5=1

**
** Patisan strength
tab partyid
replace partyid = . if partyid == .n
gen partyid_2 = partyid
replace partyid_2 = . if partyid == 7
gen party_strength = abs((partyid_2 - 3))

**
** Election dummies
gen elect_dum1 = 0
replace elect_dum1 = 1 if year == 1978 | year == 1980
gen elect_dum2 = 0
replace elect_dum2 = 1 if year == 1982 | year == 1984
gen elect_dum3 = 0
replace elect_dum3 = 1 if year == 1986 | year == 1988
gen elect_dum4 = 0
replace elect_dum4 = 1 if year == 1990 | year == 1992
gen elect_dum5 = 0
replace elect_dum5 = 1 if year == 1994 | year == 1996
gen elect_dum6 = 0
replace elect_dum6 = 1 if year == 2002 | year == 2004
gen elect_dum7 = 0
replace elect_dum7 = 1 if year == 2006 | year == 2008
gen elect_dum8 = 0
replace elect_dum8 = 1 if year == 2010 | year == 2012

**
** Odd years (Interview 2 or 4 years post election)
gen odd_year = 0
replace odd_year = 1 if year == 1980 | year == 1984 | year == 1988 | year == 1992 | year == 1996 | year == 2004 | year == 2008 | year == 2012

* Saving data for later use (multi_study_graphs_script.do)
save "GSS_clean.dta", replace


********************************************************************************
********** Section 2: Analyses for Main Text

* Specifying survey weight to be used in analyses
svyset [weight=wtssall]

**
** Final variables
*Standard variables: current economic status, election dummies
*Two Gaps variables: economic history
*Precursor variables: age, age squared, gender, race, parental education, south dummy, religious attendance, residential mobility, marital status
*Mediating variables: (current income economic status), education, health, partisan strength, political interest
*Missing: none


**
** Two Gaps (code for creating Table 2)

* Standard (Model I)
svy: logit vote log_incadj elect_dum2-elect_dum8 odd_year if incom16 != .

* Two Gaps (Model II)
svy: logit vote log_incadj incom16 elect_dum2-elect_dum8 odd_year

* Precursors (Model III)
svy: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married elect_dum2-elect_dum8 odd_year

* Precursors + Mediators (Model IV)
svy: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health news party_strength elect_dum2-elect_dum8 odd_year


**
** Age Interactions (code for creating Table 3)

* Two Gaps (Model V)
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age elect_dum2-elect_dum8 odd_year

* Precursors (Model VI)
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married elect_dum2-elect_dum8 odd_year

* Precursors + Mediators (Model VII)
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health news party_strength elect_dum2-elect_dum8 odd_year



********************************************************************************
********** Section 3: Graphing the Results

**
** Current Economic Status/Age Interaction Graph (code for creating Figure 4)
xtile inc_10tile = log_incadj, nq(10)
tab inc_10tile, sum(log_incadj)

* Precursors Only
svyset [weight=wtssall]
quietly: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married elect_dum2-elect_dum8 odd_year

margins, at(age=(18(1)85) log_incadj=(-1.1167332 2.322164)) vsquish
matrix b4cpre=r(table)
matrix marg_cpre = b4cpre'
svmat marg_cpre, names(output_cpre)	
egen age_mat_cpre = seq(), f(18) t(85) b(1)
replace age_mat_cpre = . if _n > 136

graph twoway (rspike output_cpre5 output_cpre6 age_mat_cpre if _n < 69, color(black)) ///
	(rspike output_cpre5 output_cpre6 age_mat_cpre if _n > 68 & _n < 137, color(black)) ///
	(scatter output_cpre1 age_mat_cpre if _n < 69, msize(small) msymbol(o) mcolor("217 95 2")) ///
	(scatter output_cpre1 age_mat_cpre if _n > 68 & _n < 137, msize(small) msymbol(o) mcolor("27 158 119")), ///
	legend(off) ///
	xtitle("Age", size(4)) ///
	xlabel(20 30 40 50 60 70 80, labsize(2.5)) ///
	ytitle("Probability of Voting", size(4)) ///
	ylabel(.2 .3 .4 .5 .6 .7 .8 .9 1, labsize(2.5) angle(horizontal)) ///
	title("Controlling for" "Precursors Only") ///
	yline(.2 .3 .4 .5 .6 .7 .8 .9 1, lcolor(white) lwidth(medthin)) ///
	xline(20 30 40 50 60 70 80, lcolor(white) lwidth(medthin)) ///
	xsca(titlegap(3)) ///
    ysca(titlegap(3)) ///
	scheme(s1mono) graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	text(.30 26 "{bf:Bottom Economic Decile}", color("217 95 2") place(e) size(medsmall)) ///
	text(.27 26 "{bf:in Past Year}", color("217 95 2") place(e) size(medsmall)) ///
	text(.95 18 "{bf:Top Economic Decile}", color("27 158 119") place(e) size(medsmall)) ///
	text(.92 18 "{bf:in Past Year}", color("27 158 119") place(e) size(medsmall)) ///
	name(current_pre, replace)

* Precurors and Mediators
svyset [weight=wtssall]
quietly: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health news party_strength elect_dum2-elect_dum8 odd_year

margins, at(age=(18(1)85) log_incadj=(-1.1167332 2.322164)) vsquish
matrix b4cmed=r(table)
matrix marg = b4cmed'
svmat marg, names(output_cmed)	
egen age_mat_cmed = seq(), f(18) t(85) b(1)
replace age_mat_cmed = . if _n > 136

graph twoway (rspike output_cmed5 output_cmed6 age_mat_cmed if _n < 69, color(black)) ///
	(rspike output_cmed5 output_cmed6 age_mat_cmed if _n > 68 & _n < 137, color(black)) ///
	(scatter output_cmed1 age_mat_cmed if _n < 69, msize(small) msymbol(o) mcolor("217 95 2")) ///
	(scatter output_cmed1 age_mat_cmed if _n > 68 & _n < 137, msize(small) msymbol(o) mcolor("27 158 119")), ///
	legend(off) ///
	xtitle("Age", size(4)) ///
	xlabel(20 30 40 50 60 70 80, labsize(2.5)) ///
	ytitle("Probability of Voting", size(4)) ///
	ylabel(.2 .3 .4 .5 .6 .7 .8 .9 1, labsize(2.5) angle(horizontal)) ///
	title("Controlling for" "Precursors and Mediators") ///
	yline(.2 .3 .4 .5 .6 .7 .8 .9 1.0, lcolor(white) lwidth(medthin)) ///
	xline(20 30 40 50 60 70 80, lcolor(white) lwidth(medthin)) ///
	xsca(titlegap(3)) ///
    ysca(titlegap(3)) ///
	scheme(s1mono) graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	name(current_med, replace)
	
*Combine
graph combine current_pre current_med, ///
		scheme(s2mono) ///
		graphregion(color(white)) ///
		plotregion(color(white))
	
	
**
** Economic History/Age Interaction Graph (code for creating Figure 5)

* Precurors Only
svyset [weight=wtssall]
quietly: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married elect_dum2-elect_dum8 odd_year

quietly: margins, at(age=(18(1)85) incom16=(1 5)) vsquish
matrix b4hpre=r(table)
matrix marg = b4hpre'
svmat marg, names(output_hpre)	
egen age_mat_hpre = seq(), f(18) t(85) b(2)
replace age_mat_hpre = . if _n > 136
egen seq_hpre = seq(), f(1) t(2)

graph twoway (rspike output_hpre5 output_hpre6 age_mat_hpre if seq_hpre==1, color(black)) ///
	(rspike output_hpre5 output_hpre6 age_mat_hpre if seq_hpre==2, color(black)) ///
	(scatter output_hpre1 age_mat_hpre if seq_hpre==1, msize(small) msymbol(o) mcolor("217 95 2")) ///
	(scatter output_hpre1 age_mat_hpre if seq_hpre==2, msize(small) msymbol(o) mcolor("27 158 119")), ///
	legend(off) ///
	xtitle("Age", size(4)) ///
	xlabel(20 30 40 50 60 70 80, labsize(2.5)) ///
	ytitle("Probability of Voting", size(4)) ///
	ylabel(.2 .3 .4 .5 .6 .7 .8 .9 1, labsize(2.5) angle(horizontal)) ///
	title("Controlling for" "Precursors Only") ///
	yline(.2 .3 .4 .5 .6 .7 .8 .9 1, lcolor(white) lwidth(medthin)) ///
	xline(20 30 40 50 60 70 80, lcolor(white) lwidth(medthin)) ///
	xsca(titlegap(3)) ///
    ysca(titlegap(3)) ///
	scheme(s1mono) graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	text(.38 26 "{bf:Far Below Average}", color("217 95 2") place(e) size(medsmall)) ///
	text(.35 26 "{bf:Income at Age 16}", color("217 95 2") place(e) size(medsmall)) ///
	text(.87 18 "{bf:Far Above Average}", color("27 158 119") place(e) size(medsmall)) ///
	text(.84 18 "{bf:Income at Age 16}", color("27 158 119") place(e) size(medsmall)) ///
	name(history_pre, replace)
	
* Precursors and Mediators
svyset [weight=wtssall]
quietly: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health news party_strength elect_dum2-elect_dum8 odd_year

quietly: margins, at(age=(18(1)85) incom16=(1 5)) vsquish
matrix b4hmed=r(table)
matrix marg = b4hmed'
svmat marg, names(output_hmed)	
egen age_mat_hmed = seq(), f(18) t(85) b(2)
replace age_mat_hmed = . if _n > 136
egen seq_hmed = seq(), f(1) t(2)

graph twoway (rspike output_hmed5 output_hmed6 age_mat_hmed if seq_hmed==1, color(black)) ///
	(rspike output_hmed5 output_hmed6 age_mat_hmed if seq_hmed==2, color(black)) ///
	(scatter output_hmed1 age_mat_hmed if seq_hmed==1, msize(small) msymbol(o) mcolor("217 95 2")) ///
	(scatter output_hmed1 age_mat_hmed if seq_hmed==2, msize(small) msymbol(o) mcolor("27 158 119")), ///
	legend(off) ///
	xtitle("Age", size(4)) ///
	xlabel(20 30 40 50 60 70 80, labsize(2.5)) ///
	ytitle("Probability of Voting", size(4)) ///
	ylabel(.2 .3 .4 .5 .6 .7 .8 .9 1, labsize(2.5) angle(horizontal)) ///
	title("Controlling for" "Precurors and Mediators") ///
	yline(.2 .3 .4 .5 .6 .7 .8 .9 1, lcolor(white) lwidth(medthin)) ///
	xline(20 30 40 50 60 70 80, lcolor(white) lwidth(medthin)) ///
	xsca(titlegap(3)) ///
    ysca(titlegap(3)) ///
	scheme(s1mono) graphregion(fcolor(white)) plotregion(fcolor(gs15)) ///
	name(history_med, replace)

*Combine
graph combine history_pre history_med, ///
		scheme(s2mono) ///
		graphregion(color(white)) ///
		plotregion(color(white))

		
	
********************************************************************************
********** Section 4: Analyses for Appendix

**
** Descriptive statistics of variables (code for creating Table A.1)
sum vote log_incadj incom16 age female black otherrace paeduc south16 educ attend_mo health res_mobility married news party_strength if log_incadj != . & incom16 != .

**
** Correlations of variables (code for creating Table A.7)
pwcorr vote log_incadj incom16 age female black otherrace paeduc south16 educ attend_mo health res_mobility married news party_strength if log_incadj != . & incom16 != .

**
** Testing for Mediator Variables (code for creating Table A.13)
tab year, gen(year_dum)
svyset [weight=wtssall]

* Precursor logged
svy: reg log_incadj incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: reg educ incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: ologit attend_mo incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: ologit health incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: logit res_mobility incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: logit married incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: ologit news incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29
svy: ologit party_strength incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29

* Precursor unlogged
svy: reg inc_adj incom16 c.age##c.age female black otherrace paeduc south16 year_dum2-year_dum29

* Multivariate logged
svy: reg log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married news party_strength year_dum2-year_dum29
svy: reg educ log_incadj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo health res_mobility married news party_strength year_dum2-year_dum29
svy: ologit attend_mo log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ health res_mobility married news party_strength year_dum2-year_dum29
svy: ologit health log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo res_mobility married news party_strength year_dum2-year_dum29
svy: logit res_mobility log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health married news party_strength year_dum2-year_dum29
svy: logit married log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility news party_strength year_dum2-year_dum29
svy: ologit news log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married party_strength year_dum2-year_dum29
svy: ologit party_strength log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married news year_dum2-year_dum29

* Multivariate unlogged
svy: reg inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married news party_strength year_dum2-year_dum29
svy: reg educ inc_adj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo health res_mobility married news party_strength year_dum2-year_dum29
svy: ologit attend_mo inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ health res_mobility married news party_strength year_dum2-year_dum29
svy: ologit health inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo res_mobility married news party_strength year_dum2-year_dum29
svy: logit res_mobility inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health married news party_strength year_dum2-year_dum29
svy: logit married inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility news party_strength year_dum2-year_dum29
svy: ologit news inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married party_strength year_dum2-year_dum29
svy: ologit party_strength inc_adj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married news year_dum2-year_dum29


**
** Robustness Checks (code for creating notes in Tables A.14 & A.15)

* Without health
svy: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ news party_strength elect_dum2-elect_dum8 odd_year
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ news party_strength elect_dum2-elect_dum8 odd_year

* Without political interest
svy: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health news party_strength elect_dum2-elect_dum8 odd_year
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health party_strength elect_dum2-elect_dum8 odd_year

* Without health or political interest
svy: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ party_strength elect_dum2-elect_dum8 odd_year
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ party_strength elect_dum2-elect_dum8 odd_year


**
** Size of overall gap (code for creating Table A.26)

* Determine 10th, 50th, and 90th percentiles
pctile inc_10tile = log_incadj, nq(101)
tab inc_10tile

* Precursors
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married elect_dum2-elect_dum8 odd_year
margins , at(log_incadj=(-1.0896675 .91741573 1.8261077) incom16=(1 3 5)) vsquish
			
* Precursors + Mediators
svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married educ health news party_strength elect_dum2-elect_dum8 odd_year
margins , at(log_incadj=(-1.0896675 .91741573 1.8261077) incom16=(1 3 5)) vsquish
	
	
**
** Economic Status Interactions (code for results reported in Section 8)
svy: logit vote c.log_incadj##c.incom16 elect_dum2-elect_dum8 odd_year
svy: logit vote c.log_incadj##c.incom16 c.age##c.age female black otherrace paeduc south16 attend_mo res_mobility married elect_dum2-elect_dum8 odd_year
svy: logit vote c.log_incadj##c.incom16 c.age##c.age female black otherrace paeduc south16 attend_mo health res_mobility married educ news party_strength elect_dum2-elect_dum8 odd_year


**
** Income Nonresponse (code for results reported in Section 9)
keep if year == 2010 | year == 2012 | ///
year == 2006 | year == 2008 | ///
year == 2002 | year == 2004 | ///
year == 1994 | year == 1990 | ///
year == 1986 | year == 1988 | ///
year == 1982 | year == 1984 | ///
year == 1980

sum wrkstat hrs1 wrkslf wrkgovt occ80 prestg80 indus80 marital divorce widowed ///
spwrksta sphrs1 spwrkslf spocc80 sppres80 spind80 paocc16 papres16 pawrkslf ///
paind16 paocc80 papres80 paind80 mapres80 mawrkslf maind80 maocc80 

foreach var of varlist wrkstat hrs1 wrkslf wrkgovt occ80 prestg80 indus80 marital divorce widowed spwrksta sphrs1 spwrkslf spocc80 sppres80 spind80 paocc16 papres16 pawrkslf paind16 paocc80 papres80 paind80 mapres80 mawrkslf maind80 maocc80 {
replace `var' = . if `var' == .n | `var' == .i | `var' == .d
}
*


mi set mlong

* Percentage of observations with nonresponse (code for creating table A.27)
mi misstable patterns log_incadj incom16

mi misstable summarize log_incadj incom16 age female black otherrace paeduc south16 educ ///
attend_mo health res_mobility married news party_strength elect_dum2 elect_dum3 ///
elect_dum4 elect_dum5 elect_dum6 elect_dum7 elect_dum8 odd_year ///
wrkstat hrs1 wrkslf wrkgovt occ80 prestg80 indus80 marital divorce widowed ///
spwrksta sphrs1 spwrkslf spocc80 sppres80 spind80 paocc16 papres16 pawrkslf ///
paind16 paocc80 papres80 paind80 mapres80 mawrkslf maind80 maocc80 

mi register imputed log_incadj incom16 age paeduc educ ///
attend_mo health res_mobility married news party_strength ///
wrkstat hrs1 occ80 prestg80 indus80 spocc80 sppres80 spind80 ///
paocc80 papres80 paind80 maocc80 mapres80 maind80

mi impute mvn log_incadj incom16 age paeduc educ ///
attend_mo health res_mobility married news party_strength ///
wrkstat hrs1 occ80 prestg80 indus80 spocc80 sppres80 spind80 ///
paocc80 papres80 paind80 maocc80 mapres80 maind80 = female black otherrace south16 wtssall, add(5) rseed (3899678)	


* Analysis
mi svyset [weight=wtssall]

* Two Gaps
mi estimate: svy: logit vote log_incadj elect_dum2-elect_dum8 odd_year
mi estimate: svy: logit vote log_incadj incom16 elect_dum2-elect_dum8 odd_year
mi estimate: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 elect_dum2-elect_dum8 odd_year
mi estimate: logit vote log_incadj incom16 c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married news party_strength elect_dum2-elect_dum8 odd_year

* Age Interactions
mi estimate: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age elect_dum2-elect_dum8 odd_year
mi estimate: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 elect_dum2-elect_dum8 odd_year
mi estimate: svy: logit vote c.log_incadj##c.age c.incom16##c.age c.age##c.age female black otherrace paeduc south16 educ attend_mo health res_mobility married news party_strength elect_dum2-elect_dum8 odd_year
