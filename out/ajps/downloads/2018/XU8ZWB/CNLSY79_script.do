****
****
****	Replication file for analyses of CNLSY79 for:
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
****	- Section 2: Graphing the Results
****
****	- Section 3: Analyses for Appendix
****
****
****	Analyses carried out using Stata/SE 14.2
****

use "CNLSY79_data.dta", clear


********************************************************************************
****** Section 1: Data Prep

/* This section cleans and recodes the key variables in preparation for the analyses 
that are conducted in the following section. Where commands go beyond simple
recodes or renames, comments are used to describe what is occuring and why. */


**
** Economic Status

* Merging in the poverty needs data in order to create poverty ratio for the CNLSY79 data
keep mom_id child_id household_num04 household_num06
reshape long household_num0, i(child_id) j(year)
rename household_num fam_size
gen child_num = 999
replace child_num = . if fam_size == .
gen senior = 999
replace senior = 0 if fam_size > 2
replace senior = . if fam_size == .
replace year = 2004 if year == 4
replace year = 2006 if year == 6 
merge m:1 year fam_size child_num senior using "poverty_needs.dta"
rename pov_level pov_now

keep child_id mom_id year pov_now
drop if child_id == . & mom_id == .
reshape wide pov_now, i(child_id mom_id) j(year)


* Remerging the original data with the poverty measures data
merge 1:1 child_id mom_id using "CNLSY79_data.dta"

* Poverty ratio (income/poverty needs)
/*Because of the structure of the survey data, the year on the income variable
denotes the income of the respondent in the preceding year; this is why each
income is paired with the povert level in the year prior to it since these variabes
were not provided in the survey from 1980-1985 and had to be added in manually*/
gen mpov_ratio96 = mincome96 / mpov_level96
gen mpov_ratio98 = mincome98 / mpov_level98
gen mpov_ratio00 = mincome00 / mpov_level00
gen mpov_ratio02 = mincome02 / mpov_level02
gen mpov_ratio04 = mincome04 / mpov_level04
gen mpov_ratio06 = mincome06 / mpov_level06

*Childhood economic status (up to the age of 18) based on NLSY79 measures
egen pov_child1 = rowmedian(mpov_ratio96) if age_ya96 >= 18
egen pov_child2 = rowmedian(mpov_ratio98 mpov_ratio96) if age_ya98 == 18
egen pov_child3 = rowmedian(mpov_ratio00 mpov_ratio98 mpov_ratio96) if age_ya00 == 18
egen pov_child4 = rowmedian(mpov_ratio02 mpov_ratio00 mpov_ratio98 mpov_ratio96) if age_ya02 == 18
egen pov_child5 = rowmedian(mpov_ratio04 mpov_ratio02 mpov_ratio00 mpov_ratio98 mpov_ratio96) if age_ya04 == 18
egen pov_child6 = rowmedian(mpov_ratio06 mpov_ratio04 mpov_ratio02 mpov_ratio00 mpov_ratio98 mpov_ratio96) if age_ya06 == 18

gen pov_child = .
forvalues i=1(1)6{
replace pov_child = pov_child`i' if pov_child == .
drop pov_child`i'
}
*

* Current economic status based on CNLSY79 measures
gen current_pov04 = income_total_top04/pov_now2004
gen current_pov06 = income_total_top06/pov_now2006

**
** Region
gen region18 = .
replace region18 = mgeo_region96 if age_ya96 >= 18
replace region18 = mgeo_region98 if age_ya98 == 18
replace region18 = mgeo_region00 if age_ya00 == 18
replace region18 = mgeo_region02 if age_ya02 == 18
replace region18 = mgeo_region04 if age_ya04 == 18
replace region18 = mgeo_region06 if age_ya06 == 18

gen south_dum18 = 0
replace south_dum18 = 1 if region18 == 3
replace south_dum18 = . if region18 == .

**
** Residential Mobility
foreach i in 04 06{
gen res_binary`i' = 0
replace res_binary`i' = 1 if res_mobility`i' >= 1
replace res_binary`i' = . if res_mobility`i' == -2 
}
*

**
** Marital Status
foreach i in 04 06{
gen married`i' = 0
replace married`i' = 1 if marital`i' == 0
replace married`i' = . if marital`i' == .
}
*

**
** Political Interest
rename pol_follow06 pol_follow04
recode pol_follow04 5=1 4=2 3=3 2=4 1=5
rename pol_follow08 pol_follow06
recode pol_follow06 5=1 4=2 3=3 2=4 1=5

**
** Partisan Strength
foreach i in 06 08{
gen pol_pid6_`i' = .
replace pol_pid6_`i' = 1 if pol_pid`i' == 2 & pol_strength`i' == 1
replace pol_pid6_`i' = 2 if pol_pid`i' == 2 & pol_strength`i' == 2
replace pol_pid6_`i' = 3 if pol_pid`i' == 3 & pol_lean`i' == 1
replace pol_pid6_`i' = 4 if (pol_pid`i' == 3 | pol_pid`i' == 4 | pol_pid`i' == 5) & (pol_lean`i' == 3 | pol_lean`i' == 4)
replace pol_pid6_`i' = 5 if pol_pid`i' == 3 & pol_lean`i' == 2
replace pol_pid6_`i' = 6 if pol_pid`i' == 1 & pol_strength`i' == 2
replace pol_pid6_`i' = 7 if pol_pid`i' == 1 & pol_strength`i' == 1 
}
*

foreach i in 06 08{
gen party_strength`i' = abs(pol_pid6_`i' - 4)
}
*

rename party_strength06 party_strength04
rename party_strength08 party_strength06

* Saving data for later use (multi_study_graphs_script.do)
save "CNLSY79_clean.dta", replace


**
** Data reshape
drop *96 *98 *00 *02 *08
reshape long    age_ya ///
				married ///
				educ_grade ///
				pol_vote ///
				meduc_may ///
				pol_follow ///
				party_strength ///
				health ///
				current_pov ///
				mpov_ratio ///
				res_binary, ///
				i(child_id) j(year, string)

				
**
** Integer year variable								
gen year2 = .
replace year2 = 2004 if year == "04"
replace year2 = 2006 if year == "06"
drop year
rename year2 year
sort child_id mom_id year
order child_id mom_id year, first

**
** Current economic status [combine data from NLSY79 and CNLSY79]
gen pov_ratio = current_pov
replace pov_ratio = mpov_ratio if pov_ratio == .

**
** Logging economic measures
gen pov_childl = log(pov_child + 0.01)
gen pov_ratiol = log(pov_ratio + 0.01)

**
** Midterm dummy
gen midterm = .
replace midterm = 0 if year == 2004
replace midterm = 1 if year == 2006



********************************************************************************
********** Section 2: Graphing the Results

/* This code creates matrices that stores output from the models which are then
then used to create Figure 3 in .do file "graphs_script.do" */

* Standard
quietly: xtmelogit pol_vote pov_ratiol midterm || mom_id: || child_id: 
quietly: lincom pov_ratiol
matrix current_cnlsy1 = J(1,2,.)
matrix coln current_cnlsy1 = estimate se
matrix rown current_cnlsy1 = "current_cnlsy1"
matrix current_cnlsy1[1,1] = r(estimate)
matrix current_cnlsy1[1,2] = r(se)

* Two Gaps
quietly: xtmelogit pol_vote pov_ratiol pov_childl midterm || mom_id: || child_id: 
quietly: lincom pov_ratiol
matrix current_cnlsy2 = J(1,2,.)
matrix coln current_cnlsy2 = estimate se
matrix rown current_cnlsy2 = "current_cnlsy2"
matrix current_cnlsy2[1,1] = r(estimate)
matrix current_cnlsy2[1,2] = r(se)

quietly: lincom pov_childl
matrix history_cnlsy2 = J(1,2,.)
matrix coln history_cnlsy2 = estimate se
matrix rown history_cnlsy2 = "history_cnlsy2"
matrix history_cnlsy2[1,1] = r(estimate)
matrix history_cnlsy2[1,2] = r(se)

* Precursors
quietly: xtmelogit pol_vote pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married midterm || mom_id: || child_id: 
quietly: lincom pov_ratiol
matrix current_cnlsy3 = J(1,2,.)
matrix coln current_cnlsy3 = estimate se
matrix rown current_cnlsy3 = "current_cnlsy3"
matrix current_cnlsy3[1,1] = r(estimate)
matrix current_cnlsy3[1,2] = r(se)

quietly: lincom pov_childl
matrix history_cnlsy3 = J(1,2,.)
matrix coln history_cnlsy3 = estimate se
matrix rown history_cnlsy3 = "history_cnlsy3"
matrix history_cnlsy3[1,1] = r(estimate)
matrix history_cnlsy3[1,2] = r(se)

* Precursors + Mediators
quietly: xtmelogit pol_vote pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married educ_grade health pol_follow party_strength midterm || mom_id: || child_id:
quietly: lincom pov_ratiol
matrix current_cnlsy4 = J(1,2,.)
matrix coln current_cnlsy4 = estimate se
matrix rown current_cnlsy4 = "current_cnlsy4"
matrix current_cnlsy4[1,1] = r(estimate)
matrix current_cnlsy4[1,2] = r(se)

quietly: lincom pov_childl
matrix history_cnlsy4 = J(1,2,.)
matrix coln history_cnlsy4 = estimate se
matrix rown history_cnlsy4 = "history_cnlsy4"
matrix history_cnlsy4[1,1] = r(estimate)
matrix history_cnlsy4[1,2] = r(se)



********************************************************************************
****** Section 3: Analyses for Appendix

** 
** Descriptive statistics (code for creating Table A.4)
sum pol_vote pov_ratiol pov_childl age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow party_strength

**
** Correlations between variables (code for creating Table A.10)
pwcorr pol_vote pov_ratiol pov_childl age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow party_strength


**
** Testing the Mediators (code for creating Table A.13)
egen panelid = group(mom_id child_id), label
xtset panelid

* Bivariate logged
xtreg pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtreg educ_grade pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtologit health pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm
xtlogit res_binary pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtlogit married pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtologit pol_follow pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm
xtologit party_strength pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm

* Bivariate unlogged
xtreg pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtreg educ_grade pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtologit health pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm
xtlogit res_binary pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtlogit married pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm, re
xtologit pol_follow pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm
xtologit party_strength pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 midterm

* Multivariate logged
xtreg pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow party_strength midterm, re
xtreg educ_grade pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 health res_binary married pol_follow party_strength midterm, re
xtologit health pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade res_binary married pol_follow party_strength midterm
xtlogit res_binary pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health married pol_follow party_strength midterm, re
xtlogit married pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary pol_follow party_strength midterm, re
xtologit pol_follow pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married party_strength midterm
xtologit party_strength pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow midterm

* Multivariate unlogged
xtreg pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow party_strength midterm, re
xtreg educ_grade pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 health res_binary married pol_follow party_strength midterm, re
xtologit health pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade res_binary married pol_follow party_strength midterm
xtlogit res_binary pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health married pol_follow party_strength midter, re
xtlogit married pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary pol_follow party_strength midterm, re
xtologit pol_follow pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married party_strength midterm
xtologit party_strength pov_ratio pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow midterm


**
** Two Gaps (code for creating Table A.20)

**
** Final Variables
*Standard variables: current economic status, midterm dummy
*Two Gaps variables: economic history
*Precursor variables: gender, race, age, parental education, region, residential mobility, marital status
*Mediating variables: (current economic status), education, health, political interest, partisan strength
*Missing: church attendance

* Standard (Model I)
xtmelogit pol_vote pov_ratiol midterm || mom_id: || child_id: 

* Two Gaps (Model II)
xtmelogit pol_vote pov_ratiol pov_childl midterm || mom_id: || child_id: 

* Precursor (Model III)
xtmelogit pol_vote pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married midterm || mom_id: || child_id: 

* Precursors + Mediators (Model IV)
xtmelogit pol_vote pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married educ_grade health pol_follow party_strength midterm || mom_id: || child_id:


**
** Age Interactions (code for creating Table A.21)

* Two Gaps
xtmelogit pol_vote c.pov_ratiol##c.age_ya c.pov_childl##c.age_ya c.age_ya##c.age_ya midterm || mom_id: || child_id:

* Precursors
xtmelogit pol_vote c.pov_ratiol##c.age_ya c.pov_childl##c.age_ya c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married midterm || mom_id: || child_id: 

* Precursors + Mediators
xtmelogit pol_vote c.pov_ratiol##c.age_ya c.pov_childl##c.age_ya c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married educ_grade health pol_follow party_strength midterm || mom_id: || child_id:


**
** Size of Overall Gap (code for creating Table A.26)

* Determine 10th, 50th, and 90th percentiles
pctile ratio_10tile = pov_ratiol, nq(101)
tab ratio_10tile

pctile child_10tile = pov_childl, nq(101)
tab child_10tile

* Precursors
xtmelogit pol_vote pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married midterm || mom_id: || child_id: 
margins , at(pov_ratiol=( -.846084 .9283603 1.860901) pov_childl=(-.6794525 .7683232 1.673667)) vsquish predict(mu fixed)
			
* Precursors + Mediators
xtmelogit pol_vote pov_ratiol pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married educ_grade health pol_follow party_strength midterm || mom_id: || child_id:
margins , at(pov_ratiol=( -.846084 .9283603 1.860901) pov_childl=(-.6794525 .7683232 1.673667)) vsquish predict(mu fixed)
	

**
** Economic Status Interactions (code for results reported in Section 8)
xtmelogit pol_vote c.pov_ratiol##c.pov_childl midterm || mom_id: || child_id:
xtmelogit pol_vote c.pov_ratiol##c.pov_child c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 res_binary married midterm || mom_id: || child_id: 
xtmelogit pol_vote c.pov_ratiol##c.pov_childl c.age_ya##c.age_ya female race_black race_hisp meduc_may south_dum18 educ_grade health res_binary married pol_follow party_strength midterm || mom_id: || child_id:


**
** Income Nonresponse (code for creating Table A.28)
keep if year == 2004 | year == 2006
mi set mlong
mi misstable patterns pov_ratiol pov_childl
