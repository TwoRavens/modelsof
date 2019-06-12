**********************************************************************************************************;
**** This code cleans the newly merged dataset (after running "Creating Analysis Dataset.sas in SAS) *****;
**** It also creates the tables in Dettling, Goodman, and Smith (2017).                              *****;    
**********************************************************************************************************;


clear

cd "\Info for Replication\Data\Processed Data\"

set more off


use cb_data_00_08


*** Creating and fixing some variables;

replace sat_taker = 0 if sat_taker ==.
replace psat_taker = 0 if psat_taker ==.

replace stud_sat =. if sat_taker == 0

*student PSAT;
gen stud_psat = psatvrcn + psatmrcn


*Parental education;
gen dad_educ = .
replace dad_educ = 1 if fatheduc >=1 & fatheduc <=2
replace dad_educ = 2 if fatheduc == 3
replace dad_educ = 3 if fatheduc >=4 & fatheduc <=6
replace dad_educ = 4 if fatheduc >=7 & fatheduc <=9

gen mom_educ = .
replace mom_educ = 1 if motheduc >=1 & motheduc <=2
replace mom_educ = 2 if motheduc == 3
replace mom_educ = 3 if motheduc >=4 & motheduc <=6
replace mom_educ = 4 if motheduc >=7 & motheduc <=9

gen parent_highest=dad_educ
replace parent_highest=mom_educ if mom_educ>dad_educ
replace parent_highest=mom_educ if dad_educ ==.
replace parent_highest = 0 if parent_highest==.
quietly tab parent_highest, gen(parent_educdum)

*Does parent have some college;
gen parent_college =.
replace parent_college = 0 if parent_highest ==1
replace parent_college = 0 if parent_highest ==2
replace parent_college = 1 if parent_highest ==3
replace parent_college = 1 if parent_highest ==4


*Continuous measure of high school GPA;
gen gpa_cont =.
replace gpa_cont = 4.33 if p_cgpa == 1
replace gpa_cont = 4 if p_cgpa == 2
replace gpa_cont = 3.67 if p_cgpa == 3
replace gpa_cont = 3.33 if p_cgpa == 4
replace gpa_cont = 3 if p_cgpa == 5
replace gpa_cont = 2.67 if p_cgpa == 6
replace gpa_cont = 2.33 if p_cgpa == 7
replace gpa_cont = 2 if p_cgpa == 8
replace gpa_cont = 1.67 if p_cgpa == 9
replace gpa_cont = 1.33 if p_cgpa == 10
replace gpa_cont = 1 if p_cgpa == 11
replace gpa_cont = 0 if p_cgpa == 12



*Race/ethnicity;
gen race = 4
replace race = 1 if p_ethnic == 7
replace race = 2 if p_ethnic == 3
replace race = 3 if p_ethnic >= 4 & p_ethnic <=6

quietly tab race, gen(racedum)

*Under-represented minority (black or Hispanic);
gen urm = 0
replace urm = 1 if race == 2
replace urm = 1 if race == 3

gen male = 0
replace male = 1 if p_sex == "M"
gen female = 0
replace female = 1 if p_sex == "F"

replace income = 0 if income==.


**Outcome variables;

*Applied to at least 5 colleges (the default);
gen apply5 = 0
replace apply5 = 1 if est_apps >=5

*Applied to at least one four-year
gen apply_4year = 0
replace apply_4year = 1 if four_year_apps >=1

*Applied ot of state;
gen outstate = est_apps - instate
gen apply_outstate = 0
replace apply_outstate = 1 if outstate>=1
replace apply_outstate =. if outstate==.

*Applied to at least one college with average SAT >= 1200;
gen apply1200 = 0
replace apply1200 = 1 if max_sat >=1200 
replace apply1200 = 0 if max_sat ==.

*Applied to at least one college with average SAT >= 1300;
gen apply1300 = 0
replace apply1300 = 1 if max_sat >=1300 
replace apply1300 = 0 if max_sat ==.

*Applied to at least one liberal arts college with average SAT >= 1200;
gen apply1200_lib_arts = 0
replace apply1200_lib_arts = 1 if count1200_lib_arts >= 1
replace apply1200_lib_arts = . if count1200_lib_arts ==.

*Applied to at least one liberal arts college with average SAT >= 1300;
gen apply1300_lib_arts = 0
replace apply1300_lib_arts = 1 if count1300_lib_arts >= 1
replace apply1300_lib_arts = . if count1300_lib_arts ==.

*Applied to a private college;
gen apply_private_ct = est_apps - public_apps
gen apply_private = 0
replace apply_private = 1 if apply_private_ct >= 1
replace apply_private = . if apply_private_ct ==.

replace instate_flag = 1 if instate_flag > 1 & instate_flag~=.



gen max_sat_diff = max_sat - stud_sat
gen min_sat_diff = min_sat - stud_sat
gen range_sat = max_sat - min_sat
gen avg_sat_diff = avg_sat - stud_sat
gen avg_sat_diff_middle = avg_sat_diff
replace avg_sat_diff_middle = (avg_sat_diff*ct_sat - max_sat_diff - min_sat_diff)/(ct_sat - 2) if ct_sat >= 3


gen avg_sat_middle = avg_sat
replace avg_sat_middle = (avg_sat*ct_sat - max_sat - min_sat)/(ct_sat - 2) if ct_sat >= 3




*** Creating dummy for SAT states (majority of college entrance exam takers are SAT, not ACT);
gen sat_state = 0
replace sat_state = 1 if statefip == 50
replace sat_state = 1 if statefip == 41
replace sat_state = 1 if statefip == 53
replace sat_state = 1 if statefip == 44
replace sat_state = 1 if statefip == 9
replace sat_state = 1 if statefip == 10
replace sat_state = 1 if statefip == 33
replace sat_state = 1 if statefip == 25
replace sat_state = 1 if statefip == 23
replace sat_state = 1 if statefip == 42
replace sat_state = 1 if statefip == 6
replace sat_state = 1 if statefip == 24
replace sat_state = 1 if statefip == 51
replace sat_state = 1 if statefip == 13
replace sat_state = 1 if statefip == 37
replace sat_state = 1 if statefip == 45
replace sat_state = 1 if statefip == 36
replace sat_state = 1 if statefip == 15
replace sat_state = 1 if statefip == 18
replace sat_state = 1 if statefip == 12
replace sat_state = 1 if statefip == 5
replace sat_state = 1 if statefip == 48



*Merging in many measures of broadband access (and lags);
sort zip year
merge zip year using zipcode_data_annual_updated
keep if _merge == 3
drop _merge

*Merging in county level unemployment rate and home prices;
sort zip year
merge zip year using county_hprice_urate_zips 
keep if _merge == 3
drop _merge

*create indicator for urbanicity
gen urban=(frac_urban>=0.5)

gen ct_temp = 1
bysort zip year: egen count_studs = sum(ct_temp)
gen log_count_studs = log(count_studs)
drop ct_temp count_studs


*Getting percentile of adjusted gross income of zip;
sort year
bysort year: egen agi_10pct = pctile(mean_agi), p(10)
bysort year: egen agi_20pct = pctile(mean_agi), p(20)
bysort year: egen agi_30pct = pctile(mean_agi), p(30)
bysort year: egen agi_40pct = pctile(mean_agi), p(40)
bysort year: egen agi_50pct = pctile(mean_agi), p(50)
bysort year: egen agi_60pct = pctile(mean_agi), p(60)
bysort year: egen agi_70pct = pctile(mean_agi), p(70)
bysort year: egen agi_80pct = pctile(mean_agi), p(80)
bysort year: egen agi_90pct = pctile(mean_agi), p(90)

bysort year: egen agi_25pct = pctile(mean_agi), p(25)
bysort year: egen agi_75pct = pctile(mean_agi), p(75)

bysort year: egen psat_25pct = pctile(stud_psat), p(25)
bysort year: egen psat_75pct = pctile(stud_psat), p(75)

bysort year: egen sat_25pct = pctile(stud_sat), p(25)
bysort year: egen sat_75pct = pctile(stud_sat), p(75)


*Creating dummies for which AGI;
gen income_d1 = 0
replace income_d1 = 1 if mean_agi <= agi_10pct
replace income_d1 = . if mean_agi ==.

gen income_d2 = 0
replace income_d2 = 1 if mean_agi > agi_10pct & mean_agi <= agi_20pct
replace income_d2 = . if mean_agi ==.

gen income_d3 = 0
replace income_d3 = 1 if mean_agi > agi_20pct & mean_agi <= agi_30pct
replace income_d3 = . if mean_agi ==.

gen income_d4 = 0
replace income_d4 = 1 if mean_agi > agi_30pct & mean_agi <= agi_40pct
replace income_d4 = . if mean_agi ==.

gen income_d5 = 0
replace income_d5 = 1 if mean_agi > agi_40pct & mean_agi <= agi_50pct
replace income_d5 = . if mean_agi ==.

gen income_d6 = 0
replace income_d6 = 1 if mean_agi > agi_50pct & mean_agi <= agi_60pct
replace income_d6 = . if mean_agi ==.

gen income_d7 = 0
replace income_d7 = 1 if mean_agi > agi_60pct & mean_agi <= agi_70pct
replace income_d7 = . if mean_agi ==.

gen income_d8 = 0
replace income_d8 = 1 if mean_agi > agi_70pct & mean_agi <= agi_80pct
replace income_d8 = . if mean_agi ==.

gen income_d9 = 0
replace income_d9 = 1 if mean_agi > agi_80pct & mean_agi <= agi_90pct
replace income_d9 = . if mean_agi ==.

gen income_d10 = 0
replace income_d10 = 1 if mean_agi > agi_90pct
replace income_d10 = . if mean_agi ==.

gen income_m50 = 0
replace income_m50 = 1 if mean_agi > agi_50pct
replace income_m50 = . if mean_agi ==.

gen income_q1 = 0
replace income_q1 = 1 if mean_agi <= agi_25pct
replace income_q1 = . if mean_agi ==.

gen income_q23 = 0
replace income_q23 = 1 if mean_agi > agi_25pct & mean_agi <= agi_75pct
replace income_q23 = . if mean_agi ==.

gen income_q4 = 0
replace income_q4 = 1 if mean_agi > agi_75pct
replace income_q4 = . if mean_agi ==.

gen stud_sat_q1 = 0
replace stud_sat_q1 = 1 if stud_sat <= sat_25pct
replace stud_sat_q1 =. if stud_sat ==.

gen stud_sat_q23 = 0
replace stud_sat_q23 = 1 if stud_sat > sat_25pct & stud_sat <= sat_75pct
replace stud_sat_q23 =. if stud_sat ==.

gen stud_sat_q4 = 0
replace stud_sat_q4 = 1 if stud_sat > sat_25pct
replace stud_sat_q4 =. if stud_sat ==.

gen stud_psat_q1 = 0
replace stud_psat_q1 = 1 if stud_psat <= psat_25pct
replace stud_psat_q1 =. if stud_psat ==.

gen stud_psat_q23 = 0
replace stud_psat_q23 = 1 if stud_psat > psat_25pct & stud_psat <= psat_75pct
replace stud_psat_q23 =. if stud_psat ==.

gen stud_psat_q4 = 0
replace stud_psat_q4 = 1 if stud_psat > psat_75pct
replace stud_psat_q4 =. if stud_psat ==.



*If psat and sat taker (main sample);
gen psat_sat_taker = 0
replace psat_sat_taker = 1 if psat_taker ==1 & sat_taker==1 

*For event history;
gen years_since_covered_jr=(years_since_covered-2)
tab years_since_covered_jr, m gen(year_dummy)






global indvar internet_zip_urban12_lag2
global xvars racedum2-racedum4 male female
global home_lag mean_agi_lag pop_density_lag unemp_rate12_lag med_homeprice12_lag 
global home_lag2 mean_agi_lag2 pop_density_lag2 unemp_rate12_lag2 med_homeprice12_lag2 





*** Table 1 - Summary stats;
sum racedum1 $xvars parent_college stud_psat stud_sat gpa_cont $home_lag2 internet_zip_urban12_lag2  ///
apply_4year apply5 apply1200 one_match apply1200_lib_arts instate_flag apply_outstate ///
if psat_sat_taker==1 & internet_zip_urban12_lag2~=. & apply_4year~=. & psatvrcn~=. & satvrecn~=. & pop_density_lag2~=. & male~=. & racedum2~=. & p_cgpa~=.




***** Table 2 - Baseline results;

***SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace


***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}





***** Table 3 - Test taking and selection into sample (columns 1 and 4 only)- student level; 

***PSAT to SAT probability;
xi: areg sat_taker $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***PSAT score;
xi: areg stud_psat $indvar $xvars $home_lag2 i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 


* Aggregate zip code level analysis (columns 2 and 3);
preserve 

collapse (sum) psat_taker sat_taker, by(zip year)

sort zip year

merge zip year using zipcode_population_census00
drop _merge

replace psat_taker = 0 if psat_taker ==.
replace sat_taker = 0 if sat_taker ==.


sort zip year
merge zip year using zipcode_data_annual_updated
drop if _merge == 1
drop _merge

sort zip year
merge zip year using county_hprice_urate_zips
keep if _merge == 3
drop _merge


sort zip year
merge zip year using zipcode_population_census00
drop if _merge == 1
drop _merge


gen psat_frac = psat_taker/psat_pop
gen sat_frac = sat_taker/sat_pop


xi: areg sat_frac internet_zip_urban12_lag2 mean_agi_lag2 unemp_rate12_lag2 med_homeprice12_lag2 i.year, absorb(zip) cluster(zip)
outreg2 internet_zip_urban12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel

xi: areg psat_frac internet_zip_urban12_lag2 mean_agi_lag2 unemp_rate12_lag2 med_homeprice12_lag2 i.year, absorb(zip) cluster(zip)
outreg2 internet_zip_urban12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

restore


* Aggregate zip code level analysis (columns 5 and 6);
gen temp = 1

preserve

collapse (mean) $indvar urm parent_college $home_lag2 (sum) temp if psat_sat_taker==1, by(zip year)

areg urm $indvar pop_density_lag2 unemp_rate12_lag2 med_homeprice12_lag2 i.year, a(zip) cluster(zip) 
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

areg parent_college $indvar pop_density_lag2 unemp_rate12_lag2 med_homeprice12_lag2 i.year, a(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

restore








***** Table 4 - Main variables by sub-group;

**Below median income zip code;
global sub income_m50
global value = 0
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}


**Above median income zip code;
global sub income_m50
global value = 1
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}


**Parental education - high school or less;
global sub parent_college
global value = 0
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}

**Parental education - some college or more;
global sub parent_college
global value = 1
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}


**Not black or Hispanic;
global sub urm
global value = 0
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}

**Black or Hispanic;
global sub urm
global value = 1
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}


**Rural;
global sub urban
global value = 0
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}

**Urban;
global sub urban
global value = 1
*SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel

foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{
xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & $sub==$value, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel
}

*** End of Table 4 ***;








***** Appendix Table 2 - Baseline results, omitting PSAT control;

***SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace


***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}





*****  Appendix Table 3 - Controlling for parental income and education;
***SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}





**** Appendix Table 4 - SAT States Only;

***SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & sat_state==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & sat_state==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}




***** Appendix Table 7 - Broadband access during senior year;

***SAT score;
xi: areg stud_sat internet_zip_urban12_lag $xvars $home_lag psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace


***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_urban12_lag $xvars $home_lag psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}





***** Appendix Table 8 - Results by PSAT quartile;

****First PSAT quartile;
***SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & psat_q1==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & psat_q1==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}


****PSAT quartiles 2-4;
***SAT score;
xi: areg stud_sat $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & psat_q1==0, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & psat_q1==0, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}




***** Appendix Table 9 - Alternative measures of broadband;

foreach xvar_rb of varlist internet_2000_10_urban12_lag2 internet_2500_10_urban12_lag2 internet_2700_10_urban12_lag2 internet_3000_10_urban12_lag2 internet_2000_12_urban12_lag2 internet_2500_12_urban12_lag2 internet_zip_urban12_lag2 internet_3000_12_urban12_lag2  internet_2000_15_urban12_lag2 internet_2500_15_urban12_lag2 internet_2700_15_urban12_lag2 internet_3000_15_urban12_lag2 prov12_pop_lag2 prov12_sqm_lag2{


***SAT score;
xi: areg stud_sat `xvar_rb' $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 `xvar_rb' using result, bd(5) sd(5) alpha(.01, .05, .1) excel


***Applications;
foreach outcome of varlist apply5 apply_4year one_match apply1200 apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' `xvar_rb' $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 `xvar_rb' using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}
}




***** Appendix Table 10 - Alternative measures of broadband - urban and rural sample;

xi: areg stud_sat internet_zip_urban12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 internet_zip_urban12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace


**** All students - population v1 (1 per 2700);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{


xi: areg `outcome' internet_zip_popt12_2700_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 internet_zip_popt12_2700_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}


**** All students - square miles v1 (1 per 12);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_sqmi12_12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 internet_zip_sqmi12_12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}

**** All students - square miles v2 (1 per 1);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_sqmi12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 internet_zip_sqmi12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}



**** Urban students - population v1 (1 per 2700);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match  apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_popt12_2700_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & urban==1, absorb(zip) cluster(zip)
outreg2 internet_zip_popt12_2700_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}


**** Urban students - square miles v1 (1 per 12);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match  apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_sqmi12_12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & urban==1, absorb(zip) cluster(zip)
outreg2 internet_zip_sqmi12_12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}

**** Urban students - square miles v2 (1 per 1);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_sqmi12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & urban==1, absorb(zip) cluster(zip)
outreg2 internet_zip_sqmi12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}

**** Rural students - population v1 (1 per 2700);
foreach outcome of varlist stud_satapply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_popt12_2700_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & urban==0, absorb(zip) cluster(zip)
outreg2 internet_zip_popt12_2700_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}


**** Rural students - square miles v1 (1 per 12);
foreach outcome of varlist stud_satapply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_sqmi12_12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & urban==0, absorb(zip) cluster(zip)
outreg2 internet_zip_sqmi12_12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}

**** Rural students - square miles v2 (1 per 1);
foreach outcome of varlist stud_sat apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' internet_zip_sqmi12_lag2 $xvars $home_lag2 psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & urban==0, absorb(zip) cluster(zip)
outreg2  internet_zip_sqmi12_lag2 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 
}








**** Appendix Table 11 - Controlling for SAT;
xi: areg apply5 $indvar $xvars $home_lag2 satvrecn satmrecn psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

foreach outcome of varlist apply1200 apply_4year apply1200_lib_arts instate_flag apply_100miles one_match apply_outstate{

xi: areg `outcome' $indvar $xvars $home_lag2 satvrecn satmrecn psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 $indvar using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}









***** Figure 3 - Event history coefficients to be plotted;

***SAT score;
xi: areg stud_sat year_dummy1-year_dummy7 year_dummy9-year_dummy17 $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 year_dummy1-year_dummy7 year_dummy9-year_dummy17 using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***Applications;
foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' year_dummy1-year_dummy7 year_dummy9-year_dummy17 $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1, absorb(zip) cluster(zip)
outreg2 year_dummy1-year_dummy7 year_dummy9-year_dummy17 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}

** Plot coefficients to create figure 3


***** Appendix Figure 3 - Event history coefficients to be plotted - by parental education;

***Parental education - high school or less;
***SAT score;
xi: areg stud_sat year_dummy1-year_dummy7 year_dummy9-year_dummy17 $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & parent_college==0, absorb(zip) cluster(zip)
outreg2 year_dummy1-year_dummy7 year_dummy9-year_dummy17 using result, bd(5) sd(5) alpha(.01, .05, .1) excel replace

***Applications;
foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' year_dummy1-year_dummy7 year_dummy9-year_dummy17 $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & parent_college==0, absorb(zip) cluster(zip)
outreg2 year_dummy1-year_dummy7 year_dummy9-year_dummy17 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}



***Parental education - some college or more;
***SAT score;
xi: areg stud_sat year_dummy1-year_dummy7 year_dummy9-year_dummy17 $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & parent_college==1, absorb(zip) cluster(zip)
outreg2 year_dummy1-year_dummy7 year_dummy9-year_dummy17 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

***Applications;
foreach outcome of varlist apply5 apply_4year apply1200 one_match apply1200_lib_arts instate_flag apply_outstate{

xi: areg `outcome' year_dummy1-year_dummy7 year_dummy9-year_dummy17 $xvars $home_lag2 i.income i.parent_highest psatvrcn psatmrcn i.p_cgpa i.year if psat_sat_taker==1 & parent_college==1, absorb(zip) cluster(zip)
outreg2 year_dummy1-year_dummy7 year_dummy9-year_dummy17 using result, bd(5) sd(5) alpha(.01, .05, .1) excel 

}

**Plot coefficients to create appendix figure 3


****Figure 1 -- internet access and usage trends --- 

clear
use zipcode_data_annual_updated.dta

gen providers_dum46=(providers6>=4 & providers6!=.)
gen providers_dum412=(providers12>=4 & providers12!=.)

collapse internet_zip_urban6 internet_zip_urban12 providers_dum6 providers_dum12  providers_dum46 providers_dum412 [aw=totalpop], by(year)
reshape long internet_zip_urban providers_dum providers_dum4, i(year) j(month)

gen year_qtr=year+0.417 if month==6
replace year_qtr=year+0.916 if month==12

append hsi_use_pew.dta

**Plot outcomes by year_qtr



**Figure 2 --1996 to 1998 Means of Outcomes***
**this uses older vintage college board data than our main data set but main variables are the same

**zip code level year first covered file
use zipcode_data_annual_updated, clear
keep year_firstcovered zip
by zip: gen n=_n
keep if n==1

tempfile zips9698
save `zips9698'

**open college board data for 1996-1998
use cb_96_98.dta, clear

**create main variables using code above, lines 17-135**

**merge in year first covered by broadband
merge m:1 zip using `zips9698'

**collapse by time period zip got access
gen adopt_cat=.
replace adopt_cat=1 if year_firstcovered<=2001
replace adopt_cat=2 if year_firstcovered>=2002 & year_firstcovered<=2004
replace adopt_cat=3 if year_firstcovered>=2005

collapse apply_4year apply5 apply1200 apply1300 apply1300_lib_arts one_match instate_flag apply_outstate  stud_sat  [fweight=freq], by(adopt_cat year)

**Plot means by year and adopt_cat to create figure 2


**Appendix table 1 -- teen usage and our measure of broadband access

use cps_teenusage.dta, clear

tab year, gen(yeardum)
tab race, gen(racedum)
tab mom_educ, gen(momeducdum)
tab dad_educ, gen(dadeducdum)
tab sex, gen (sexdum)

gen n=1 

collapse hsi_user hsi racedum* momeducdum* dadeducdum* sexdum* internet_zip_urban12 internet_zip_popt12 internet_zip_sqmi1 internet_zip_sqmi internet_zip_pop providers12 providers_dum12 ///
 pop_density mean_agi unemp_rate12 med_homeprice12 providers_pop providers_sqmi famincd (count) n [pw=pwsswgt], by(statefip year)

**controls to mimic our data
tab year, gen(yeardum)
rename n totalpop
global xvars  yeardum* racedum* sexdum* momeducdum* dadeducdum* mean_agi pop_density unemp_rate med_homeprice famincd

**re-scale number of providers
replace providers_pop=providers_pop*1000

set more off
areg hsi_user internet_zip_urban12 $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_1
areg hsi_user internet_zip_pop $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_2
areg hsi_user internet_zip_sqmi $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_3
areg hsi_user internet_zip_sqmi1 $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_4
areg hsi_user providers_dum12 $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_5
areg hsi_user providers12 $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_6
areg hsi_user providers_pop $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_7
areg hsi_user providers_sqmi $xvars [pw=totalpop], absorb(statefip) cluster(statefip)
eststo tab1_8



**Apppendix Figure 1 - teen computer and broadband usage by mom's education

use cps_teenusage.dta clear

collapse hsi_user ieduc homecomputer [pw=pwsswgt], by(mom_educ year)

*Plot means


**Appendix Figure 2 

use zipcode_data_annual_updated.dta, clear

keep if year==1999 | year==2007
keep zip internet_zip_urban12

*Graph intenert_zip_urban12 in 1999 and 2007 using map-making software like ARCGIS or stata's spmap






