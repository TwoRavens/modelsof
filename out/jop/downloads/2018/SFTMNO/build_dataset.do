cd "C:\Users\David\Dropbox\Chairs RR\Replication Materials"

clear all
set more off
*****************************************
******** CONTEXTUAL DATA PREPARATION ****
*****************************************
*****************NOTES ON SHARE OF COUNTIES WITH X+ MINORITIES - reported in text
***BASED ON ALL COUNTIES. DATA HERE NOT MERGED with CHAIRS DATA
use "public_data\county_demographics.dta", clear
count if perc_black_hh!=.
local n=r(N)
count if perc_black_hh>=10 & perc_black_hh!=.
disp "Percent Counties: 10%+ black HH"
disp r(N)/`n'
count if perc_black_hh>=34 & perc_black_hh!=.
disp "Percent Counties: 34%+ black HH"
disp r(N)/`n'
count if perc_black_hh>=50 & perc_black_hh!=.
disp "Percent Counties: 50%+ black HH"
disp r(N)/`n'

count if perc_hisp_hh>=16 & perc_hisp_hh!=.
disp "Percent Counties: 16%+ Hispanic HH"
disp r(N)/`n'
count if perc_black_hh>=20 & perc_hisp_hh!=.
disp "Percent Counties: 20%+ Hispanic  HH"
disp r(N)/`n'
count if perc_black_hh>=38 & perc_hisp_hh!=.
disp "Percent Counties: 38%+ Hispanic  HH"
disp r(N)/`n'
count if perc_black_hh>=50 & perc_hisp_hh!=.
disp "Percent Counties: 50%+ Hispanic  HH"
disp r(N)/`n'


*****STACK CCES DATA AND GENERATE RELEVANT VARIABLES / MERGE WITH COUNTY 

***CCES 2010 & 2012 data 
use "public_data\cces_common_cumulative_4.dta", clear
keep if year>2009
gen state=state_post
replace state=state_pre if state==.
replace county_fips_pre=county_fips_pre+(state_pre*1000) if county_fips_pre<1000
gen fips=county_fips_post
replace fips=county_fips_pre if fips==.
destring fips, replace
sort fips
recode immig_legal_status (1=1) (2=0) (*=.), gen(immig_1)
recode immig_border_patrol immig_police (1=0) (2=1) (*=.), gen(immig_2 immig_3)
egen immig=rmean(immig_1 immig_2 immig_3)

recode racial_resent_special_favors (1=5) (2=4) (3=3) (4=2) (5=1) (*=.), gen(rresent_favors)
gen rresent_slavery=racial_resent_slavery
corr rresent*
egen rresent=rmean(rresent*)
recode ideo7 (8=4), gen(ideology)
recode pid7 (8=4), gen(pid)
gen white=race==1
recode gender (2=1) (1=0), gen(female)
keep year state fips immig rresent white
save "scratch_datasets\cces10_12.dta", replace

***CCES 2014 data
use "public_data\CCES14_Common_OUTPUT_Feb2015.dta", clear
gen fips=countyfips
destring fips, replace
recode CC334A (8=4), gen(ideology)
sort fips
recode CC14_322_1 (1=1) (2=0) (*=.), gen(immig_1)
recode CC14_322_2 CC14_322_3 (1=0) (2=1) (*=.), gen(immig_2 immig_3)
egen immig=rmean(immig_1 immig_2 immig_3)
recode CC422a (1=5) (2=4) (3=3) (4=2) (5=1) (*=.), gen(rresent_favors)
gen rresent_slavery=CC422b
egen rresent=rmean(rresent*)
recode pid7 (8=4), gen(pid)
gen year=2014
gen white=race==1
keep year fips immig rresent white
save "scratch_datasets\cces14.dta", replace

***CCES 2011 data
use "public_data\CCES11_Common_OUTPUT.dta", clear
recode CC359 (1=5) (2=4) (3=3) (4=2) (5=1) (*=.), gen(rresent)
recode CC342A (8=4), gen(ideology)
recode V212d (8=4), gen(pid)
destring V302, replace

recode CC351_1 (1=1) (2=0) (*=.), gen(immig_1)
recode CC351_2 CC351_3 (1=0) (2=1) (*=.), gen(immig_2 immig_3)
egen immig=rmean(immig_1 immig_2 immig_3)

gen fips=V303+(1000*V302)
gen year=2011
gen white=V211==1
keep year fips immig rresent white
append using "scratch_datasets\cces10_12.dta"
append using "scratch_datasets\cces14.dta"
sort fips

//merge in FIPS 
//merge m:1 fips using "scratch_datasets\fips_master.dta", force
//drop _merge
rename rresent rresent_all
gen rresent=rresent_all if white
//generate variables with nonmissing to count # of obs in each county
gen immig_count=immig
gen rresent_count=rresent
collapse (count) year immig_count rresent_count (mean) immig rresent, by(fips)
rename year count
drop if fips==.
sort fips
//note: unmatched cases are cities (e.g., DC; Alexandria, VA) that have FIPS in CCES data, but are not listed in county Census dataset
merge 1:1 fips using "public_data\county_demographics.dta"
drop _merge
save "scratch_datasets\county_info.dta", replace

******************************
**** County Election Outcomes
******************************
clear all
insheet using "public_data\guardian_pres_2012.csv", double
rename lastname lastname_1
rename v28 lastname_2
rename v40 lastname_3
rename v52 lastname_4

rename fipscode fips
rename votes votes_1
rename v32 votes_2
rename v44 votes_3
rename v56 votes_4

gen obama_12=.
replace obama_12=votes_1 if lastname_1=="Obama"
replace obama_12=votes_2 if lastname_2=="Obama"
replace obama_12=votes_3 if lastname_3=="Obama"
replace obama_12=votes_4 if lastname_4=="Obama"

gen romney_12=.
replace romney_12=votes_1 if lastname_1=="Romney"
replace romney_12=votes_2 if lastname_2=="Romney"
replace romney_12=votes_3 if lastname_3=="Romney"
replace romney_12=votes_4 if lastname_4=="Romney"

drop if fips==0
sort fips
//collapse counties where 
collapse (sum) obama_12 romney_12, by(fips)
//drop if fips==fips[_n-1]
keep fips romney_12 obama_12
save "scratch_datasets\election_data.dta", replace
clear all


**********CODE CHAIRS DEMOGRAPHICS AND MERGE SURVEY DATA with SAMPLING FRAME ***************

use "private_data\elite_not_anon.dta", clear

***Coding Demographics of Party Chairs

egen tasks_completed=rownonmiss(choice_*)
drop if whatisyourgender==.
rename whichstatedoyoulivein state

** DEMOGRAPHICS
label var democrat "Democrat (1=yes)"
*Age
rename whatistheyearofyourbirth yob
gen age=2016-yob
label var age "Age (in years)"
drop if age<18

*Education
rename whatisthehighestlevelofeducation educ
label var educ "Education (1=No HS; 6=post-grad)"

*Income
rename whatwasyourtotalfamilyincomein20 income
label var income "Income (1=<$10k; 14=$150k+; 15=refused)"
gen incomemis=(income==15)
replace incomemis=1 if income==.
replace income=15 if income==.
label var incomemis "Income Refused (1=yes)"

*Race
foreach i in white black hispanic asian nativeamerican mixed other{
rename `i'whatracialorethnic r_`i'
 replace r_`i'=0 if r_`i'==.
 replace r_`i'=1 if r_`i'!=0
 label var r_`i' "`i' = 1"
}
replace r_other=r_asian+r_nativeam+r_mixed+r_other
replace r_other=1 if r_other>1
replace r_white=0 if (r_black==1)| (r_hispanic==1)| (r_other==1)
replace r_black=0 if (r_hispanic==1)|(r_other==1)
replace r_hispanic=0 if (r_other==1)
replace r_other=1 if (r_white!=1)&(r_black!=1)&(r_hispanic!=1)

label var r_other "Other race / Skipped (1=yes)"
label var r_white "White Chair (1=yes)"
label var r_black "Black Chair (1=yes)"
label var r_hispanic "Hispanic Chair (1=yes)"
drop r_asian r_nativeam r_mixed 

*Gender
rename whatisyourgender female
label var female "Female (1=yes)"


***MERGE IN CONTEXT DATA
sort respondentemail
//merge in county variables; first get FIPS from sampling frame
merge 1:1 respondentemail using "private_data\sample_frame_to_merge.dta"
drop if _merge==2
drop _merge respondentemail 
destring fips, replace
sort fips
merge m:1 fips using "scratch_datasets\county_info.dta"
keep if _merge==3 | _merge==1
drop _merge 
merge m:1 fips using "scratch_datasets\election_data.dta"
drop _merge 
gen dem_vshare_12= obama_12/( obama_12+romney_12)
label var dem_vshare_12 "Obama Share of 2-Party Vote (2012)"
gen closeness_12=abs(dem_vshare_12-.5)*100
label var closeness_12 "Deviation from 50/50 2-Party Split (2012 Pres.)"

//merge in legislator data
merge m:1 fips using "public_data\legislator_chars_to_merge.dta"
drop _merge 

*drop if didn't complete any conjoints tasks
egen tasks=rmiss(choice*)
replace tasks=10-tasks
drop if tasks==0

* generate indicator for county for anonymizing
gen iscounty=fips!=.
gen ln_pct_black=ln(perc_black_hh+1) 
gen ln_pct_hisp=ln(perc_hisp_hh+1) 
replace closeness=ln(closeness)

label var ln_pct_black "Percent Black Households (ln)"
label var ln_pct_hisp "Percent Hispanic Households (ln)"
label var closeness_12 "Deviation from 50/50 2-Party Split (2012 Pres.; logged)"

label var rresent "Mean County Racial Resentment (1-5)"
label var immig "Mean County Pro-Immigration Attitudes (0-1)"

*********************************************************************************
*********************************************************************************
****ANONYMIZE DATA 
*********************************************************************************
*********************************************************************************


sort fips democrat
*threshold used for robustness check is >=10; discarding more detailed information about number of respondents used to calculate means
recode immig_count rresent_count (0/9=0) (10/10000=10)


set seed XXX
**continuous variables
foreach i in immig rresent perc_black_hh perc_hisp_hh closeness_12 ln_pct_black ln_pct_hisp closeness {
qui sum `i'
//ADD 1/2 SD perturbation
generate perturb_`i'=(runiform()-.5)*r(sd)
replace `i' = `i'+perturb_`i'
}

***any minority/female state legislators
foreach i in l_female_any l_black_any l_hisp_any{
local seed = `seed'+1
set seed `seed'
gen random=runiform()
gsort -iscounty random
gen pert_`i' = `i'
//flip switch on random 10 percent of sample
replace `i' =abs(`i'-1) in 1/58
drop random
}

* anonymize fips code
set seed XXX
gen random = runiform()
sort random
gen fips_no = _n
//sort to ensure cases w/two chairs from county have same FIPS
sort fips
replace fips_no=fips_no[_n-1] if fips==fips[_n-1] & fips!=.
egen fips_group = group(fips)
replace fips=fips_group 
drop random 

*********************************************************************************
*********************************************************************************
*********************************************************************************

***********************************************************************************
***********CREATE TREATMENT INDICATORS AND RESHAPE DATA TO STACK CONJOINT TASKS ***
***********************************************************************************
gen responseid=_n
drop name_1_11-name_2_20 chara_1_11- chara_2_20 charb_1_11- charb_2_20 charc_1_11- charc_2_20 chard_1_11- chard_2_20
*reshape to stack TASKS
reshape long name_1_ name_2_ time_ chara_1_ chara_2_ charb_1_ charb_2_ charc_1_ charc_2_ chard_1_ chard_2_ choice_ scale_1_ scale_2_, i(responseid) j(task)

***Recoding conjoint characteristcs of analysis
//note: "..._1" refers to first candidate in conjoint (Candidate A)
//note: "..._2" refers to second candidate in conjoint (Candidate B)

*Code Gender Indicators
//note: 1=woman; 0=man
gen woman_1=.
gen woman_2=.
replace woman_1=1 if name_1_=="Abigail Smith"
replace woman_1=1 if name_1_=="Alaliyah Booker"
replace woman_1=1 if name_1_=="Alexus Banks"
replace woman_1=0 if name_1_=="Alfonso Gonzalez"
replace woman_1=1 if name_1_=="Allison Nelson"
replace woman_1=1 if name_1_=="Amy Mueller"
replace woman_1=1 if name_1_=="Anne Evans"
replace woman_1=1 if name_1_=="Beatriz Ibarra"
replace woman_1=1 if name_1_=="Beatriz Martinez"
replace woman_1=1 if name_1_=="Blanca Ramirez"
replace woman_1=0 if name_1_=="Bradley Schwartz"
replace woman_1=0 if name_1_=="Brett Clark"
replace woman_1=1 if name_1_=="Caitlin Schneider"
replace woman_1=1 if name_1_=="Carlita Torres"
replace woman_1=0 if name_1_=="Carlos Perez"
replace woman_1=0 if name_1_=="Carlos Torres"
replace woman_1=1 if name_1_=="Carly Smith"
replace woman_1=1 if name_1_=="Carmela Velazquez"
replace woman_1=1 if name_1_=="Carmen Barajas"
replace woman_1=1 if name_1_=="Carmen Lopez"
replace woman_1=1 if name_1_=="Carola Huerta"
replace woman_1=1 if name_1_=="Carola Ibarra"
replace woman_1=1 if name_1_=="Carrie King"
replace woman_1=1 if name_1_=="Catalina Hernandez"
replace woman_1=1 if name_1_=="Catalina Jaurez"
replace woman_1=0 if name_1_=="Cesar Vazquez"
replace woman_1=0 if name_1_=="Cesar Zavala"
replace woman_1=1 if name_1_=="Claire Schwartz"
replace woman_1=0 if name_1_=="Cody Anderson"
replace woman_1=0 if name_1_=="Cole Krueger"
replace woman_1=0 if name_1_=="Colin Smith"
replace woman_1=0 if name_1_=="Connor Schwartz"
replace woman_1=0 if name_1_=="Darius Joseph"
replace woman_1=0 if name_1_=="Darnell Banks"
replace woman_1=0 if name_1_=="DeAndre Jefferson"
replace woman_1=0 if name_1_=="DeShawn Korsey"
replace woman_1=1 if name_1_=="Deja Jefferson"
replace woman_1=1 if name_1_=="Deja Mosley"
replace woman_1=1 if name_1_=="Dolores Ramirez"
replace woman_1=1 if name_1_=="Dolores Sanchez"
replace woman_1=1 if name_1_=="Dominique Mosley"
replace woman_1=0 if name_1_=="Dustin Nelson"
replace woman_1=1 if name_1_=="Dylan Schwartz"
replace woman_1=1 if name_1_=="Ebony Mosley"
replace woman_1=1 if name_1_=="Ebony Washington"
replace woman_1=0 if name_1_=="Edgar Sanchez"
replace woman_1=0 if name_1_=="Edgar Zavala"
replace woman_1=0 if name_1_=="Eduardo Lopez"
replace woman_1=0 if name_1_=="Eduardo Torres"
replace woman_1=1 if name_1_=="Emily Schmidt"
replace woman_1=1 if name_1_=="Emma Clark"
replace woman_1=0 if name_1_=="Enrique Huerta"
replace woman_1=0 if name_1_=="Garrett Novak"
replace woman_1=0 if name_1_=="Geoffrey Martin"
replace woman_1=0 if name_1_=="Greg Adams"
replace woman_1=1 if name_1_=="Hannah Phillips"
replace woman_1=1 if name_1_=="Heather Martin"
replace woman_1=0 if name_1_=="Hernan Garcia"
replace woman_1=1 if name_1_=="Holly Schroeder"
replace woman_1=0 if name_1_=="Hunter Miller"
replace woman_1=0 if name_1_=="Jack Evans"
replace woman_1=1 if name_1_=="Jada Mosley"
replace woman_1=0 if name_1_=="Jake Clark"
replace woman_1=0 if name_1_=="Jamal Gaines"
replace woman_1=0 if name_1_=="Jamal Rivers"
replace woman_1=1 if name_1_=="Jasmin Jefferson"
replace woman_1=1 if name_1_=="Jasmine Joseph"
replace woman_1=0 if name_1_=="Javier Gonzalez"
replace woman_1=0 if name_1_=="Jay Allen"
replace woman_1=1 if name_1_=="Jazmine Jefferson"
replace woman_1=1 if name_1_=="Jenna Anderson"
replace woman_1=0 if name_1_=="Jermaine Gaines"
replace woman_1=1 if name_1_=="Jill Smith"
replace woman_1=0 if name_1_=="Jorge Cervantes"
replace woman_1=0 if name_1_=="Jose Martinez"
replace woman_1=0 if name_1_=="Jose Orozco"
replace woman_1=0 if name_1_=="Jose Sanchez"
replace woman_1=0 if name_1_=="Juan Barajas"
replace woman_1=0 if name_1_=="Juan Hernandez"
replace woman_1=1 if name_1_=="Katelyn Miller"
replace woman_1=1 if name_1_=="Katherine Adams"
replace woman_1=1 if name_1_=="Kathryn Evans"
replace woman_1=1 if name_1_=="Katie Novak"
replace woman_1=1 if name_1_=="Keisha Rivers"
replace woman_1=1 if name_1_=="Kiara Jackson"
replace woman_1=1 if name_1_=="Kristen Clark"
replace woman_1=0 if name_1_=="LaShawn Banks"
replace woman_1=0 if name_1_=="LaShawn Washington"
replace woman_1=1 if name_1_=="Latonya Rivers"
replace woman_1=1 if name_1_=="Latoya Rivers"
replace woman_1=0 if name_1_=="Logan Allen"
replace woman_1=0 if name_1_=="Luis Hernandez"
replace woman_1=0 if name_1_=="Luis Vazquez"
replace woman_1=0 if name_1_=="Luke Phillips"
replace woman_1=1 if name_1_=="Madeline Haas"
replace woman_1=1 if name_1_=="Magdalena Perez"
replace woman_1=1 if name_1_=="Margarita Garcia"
replace woman_1=1 if name_1_=="Margarita Velazquez"
replace woman_1=1 if name_1_=="Maria Ramirez"
replace woman_1=1 if name_1_=="Maria Rodriguez"
replace woman_1=0 if name_1_=="Matthew Anderson"
replace woman_1=0 if name_1_=="Maxwell Haas"
replace woman_1=1 if name_1_=="Molly Kruger"
replace woman_1=0 if name_1_=="Pedro Rodriguez"
replace woman_1=1 if name_1_=="Precious Washington"
replace woman_1=0 if name_1_=="Rasheed Gaines"
replace woman_1=1 if name_1_=="Raven Korsey"
replace woman_1=1 if name_1_=="Rosa Orozco"
replace woman_1=1 if name_1_=="Rosa Perez"
replace woman_1=1 if name_1_=="Sarah Miller"
replace woman_1=0 if name_1_=="Scott King"
replace woman_1=1 if name_1_=="Shanice Booker"
replace woman_1=0 if name_1_=="Tanner Smith"
replace woman_1=1 if name_1_=="Teresa Jaurez"
replace woman_1=0 if name_1_=="Terrance Booker"
replace woman_1=0 if name_1_=="Todd Mueller"
replace woman_1=0 if name_1_=="Tremayne Joseph"
replace woman_1=0 if name_1_=="Trevon Jackson"
replace woman_1=0 if name_1_=="Tyreke Washington"
replace woman_1=0 if name_1_=="Tyrone Booker"
replace woman_1=0 if name_1_=="Tyrone Joseph"
replace woman_1=0 if name_1_=="Wyatt Smith"
replace woman_1=0 if name_1_=="Xavier Jackson"
replace woman_2=1 if name_2_=="Abigail Smith"
replace woman_2=1 if name_2_=="Alaliyah Booker"
replace woman_2=1 if name_2_=="Alexus Banks"
replace woman_2=0 if name_2_=="Alfonso Gonzalez"
replace woman_2=1 if name_2_=="Allison Nelson"
replace woman_2=1 if name_2_=="Amy Mueller"
replace woman_2=1 if name_2_=="Anne Evans"
replace woman_2=1 if name_2_=="Beatriz Ibarra"
replace woman_2=1 if name_2_=="Beatriz Martinez"
replace woman_2=1 if name_2_=="Blanca Ramirez"
replace woman_2=0 if name_2_=="Bradley Schwartz"
replace woman_2=0 if name_2_=="Brett Clark"
replace woman_2=1 if name_2_=="Caitlin Schneider"
replace woman_2=1 if name_2_=="Carlita Torres"
replace woman_2=0 if name_2_=="Carlos Perez"
replace woman_2=0 if name_2_=="Carlos Torres"
replace woman_2=1 if name_2_=="Carly Smith"
replace woman_2=1 if name_2_=="Carmela Velazquez"
replace woman_2=1 if name_2_=="Carmen Barajas"
replace woman_2=1 if name_2_=="Carmen Lopez"
replace woman_2=1 if name_2_=="Carola Huerta"
replace woman_2=1 if name_2_=="Carola Ibarra"
replace woman_2=1 if name_2_=="Carrie King"
replace woman_2=1 if name_2_=="Catalina Hernandez"
replace woman_2=1 if name_2_=="Catalina Jaurez"
replace woman_2=0 if name_2_=="Cesar Vazquez"
replace woman_2=0 if name_2_=="Cesar Zavala"
replace woman_2=1 if name_2_=="Claire Schwartz"
replace woman_2=0 if name_2_=="Cody Anderson"
replace woman_2=0 if name_2_=="Cole Krueger"
replace woman_2=0 if name_2_=="Colin Smith"
replace woman_2=0 if name_2_=="Connor Schwartz"
replace woman_2=0 if name_2_=="Darius Joseph"
replace woman_2=0 if name_2_=="Darnell Banks"
replace woman_2=0 if name_2_=="DeAndre Jefferson"
replace woman_2=0 if name_2_=="DeShawn Korsey"
replace woman_2=1 if name_2_=="Deja Jefferson"
replace woman_2=1 if name_2_=="Deja Mosley"
replace woman_2=1 if name_2_=="Dolores Ramirez"
replace woman_2=1 if name_2_=="Dolores Sanchez"
replace woman_2=1 if name_2_=="Dominique Mosley"
replace woman_2=0 if name_2_=="Dustin Nelson"
replace woman_2=1 if name_2_=="Dylan Schwartz"
replace woman_2=1 if name_2_=="Ebony Mosley"
replace woman_2=1 if name_2_=="Ebony Washington"
replace woman_2=0 if name_2_=="Edgar Sanchez"
replace woman_2=0 if name_2_=="Edgar Zavala"
replace woman_2=0 if name_2_=="Eduardo Lopez"
replace woman_2=0 if name_2_=="Eduardo Torres"
replace woman_2=1 if name_2_=="Emily Schmidt"
replace woman_2=1 if name_2_=="Emma Clark"
replace woman_2=0 if name_2_=="Enrique Huerta"
replace woman_2=0 if name_2_=="Garrett Novak"
replace woman_2=0 if name_2_=="Geoffrey Martin"
replace woman_2=0 if name_2_=="Greg Adams"
replace woman_2=1 if name_2_=="Hannah Phillips"
replace woman_2=1 if name_2_=="Heather Martin"
replace woman_2=0 if name_2_=="Hernan Garcia"
replace woman_2=1 if name_2_=="Holly Schroeder"
replace woman_2=0 if name_2_=="Hunter Miller"
replace woman_2=0 if name_2_=="Jack Evans"
replace woman_2=1 if name_2_=="Jada Mosley"
replace woman_2=0 if name_2_=="Jake Clark"
replace woman_2=0 if name_2_=="Jamal Gaines"
replace woman_2=0 if name_2_=="Jamal Rivers"
replace woman_2=1 if name_2_=="Jasmin Jefferson"
replace woman_2=1 if name_2_=="Jasmine Joseph"
replace woman_2=0 if name_2_=="Javier Gonzalez"
replace woman_2=0 if name_2_=="Jay Allen"
replace woman_2=1 if name_2_=="Jazmine Jefferson"
replace woman_2=1 if name_2_=="Jenna Anderson"
replace woman_2=0 if name_2_=="Jermaine Gaines"
replace woman_2=1 if name_2_=="Jill Smith"
replace woman_2=0 if name_2_=="Jorge Cervantes"
replace woman_2=0 if name_2_=="Jose Martinez"
replace woman_2=0 if name_2_=="Jose Orozco"
replace woman_2=0 if name_2_=="Jose Sanchez"
replace woman_2=0 if name_2_=="Juan Barajas"
replace woman_2=0 if name_2_=="Juan Hernandez"
replace woman_2=1 if name_2_=="Katelyn Miller"
replace woman_2=1 if name_2_=="Katherine Adams"
replace woman_2=1 if name_2_=="Kathryn Evans"
replace woman_2=1 if name_2_=="Katie Novak"
replace woman_2=1 if name_2_=="Keisha Rivers"
replace woman_2=1 if name_2_=="Kiara Jackson"
replace woman_2=1 if name_2_=="Kristen Clark"
replace woman_2=0 if name_2_=="LaShawn Banks"
replace woman_2=0 if name_2_=="LaShawn Washington"
replace woman_2=1 if name_2_=="Latonya Rivers"
replace woman_2=1 if name_2_=="Latoya Rivers"
replace woman_2=0 if name_2_=="Logan Allen"
replace woman_2=0 if name_2_=="Luis Hernandez"
replace woman_2=0 if name_2_=="Luis Vazquez"
replace woman_2=0 if name_2_=="Luke Phillips"
replace woman_2=1 if name_2_=="Madeline Haas"
replace woman_2=1 if name_2_=="Magdalena Perez"
replace woman_2=1 if name_2_=="Margarita Garcia"
replace woman_2=1 if name_2_=="Margarita Velazquez"
replace woman_2=1 if name_2_=="Maria Ramirez"
replace woman_2=1 if name_2_=="Maria Rodriguez"
replace woman_2=0 if name_2_=="Matthew Anderson"
replace woman_2=0 if name_2_=="Maxwell Haas"
replace woman_2=1 if name_2_=="Molly Kruger"
replace woman_2=0 if name_2_=="Pedro Rodriguez"
replace woman_2=1 if name_2_=="Precious Washington"
replace woman_2=0 if name_2_=="Rasheed Gaines"
replace woman_2=1 if name_2_=="Raven Korsey"
replace woman_2=1 if name_2_=="Rosa Orozco"
replace woman_2=1 if name_2_=="Rosa Perez"
replace woman_2=1 if name_2_=="Sarah Miller"
replace woman_2=0 if name_2_=="Scott King"
replace woman_2=1 if name_2_=="Shanice Booker"
replace woman_2=0 if name_2_=="Tanner Smith"
replace woman_2=1 if name_2_=="Teresa Jaurez"
replace woman_2=0 if name_2_=="Terrance Booker"
replace woman_2=0 if name_2_=="Todd Mueller"
replace woman_2=0 if name_2_=="Tremayne Joseph"
replace woman_2=0 if name_2_=="Trevon Jackson"
replace woman_2=0 if name_2_=="Tyreke Washington"
replace woman_2=0 if name_2_=="Tyrone Booker"
replace woman_2=0 if name_2_=="Tyrone Joseph"
replace woman_2=0 if name_2_=="Wyatt Smith"
replace woman_2=0 if name_2_=="Xavier Jackson"
label variable woman_1 "Man 0 Woman 1"
label variable woman_2 "Man 0 Woman 1"

*Race
//note: 1=white; 2=black; 3=hispanic
gen race_1=.
gen race_2=.
replace race_1=1 if name_1_=="Abigail Smith"
replace race_1=2 if name_1_=="Alaliyah Booker"
replace race_1=1 if name_1_=="Alexus Banks"
replace race_1=3 if name_1_=="Alfonso Gonzalez"
replace race_1=1 if name_1_=="Allison Nelson"
replace race_1=1 if name_1_=="Amy Mueller"
replace race_1=1 if name_1_=="Anne Evans"
replace race_1=3 if name_1_=="Beatriz Ibarra"
replace race_1=3 if name_1_=="Beatriz Martinez"
replace race_1=3 if name_1_=="Blanca Ramirez"
replace race_1=1 if name_1_=="Bradley Schwartz"
replace race_1=1 if name_1_=="Brett Clark"
replace race_1=1 if name_1_=="Caitlin Schneider"
replace race_1=3 if name_1_=="Carlita Torres"
replace race_1=3 if name_1_=="Carlos Perez"
replace race_1=3 if name_1_=="Carlos Torres"
replace race_1=1 if name_1_=="Carly Smith"
replace race_1=3 if name_1_=="Carmela Velazquez"
replace race_1=3 if name_1_=="Carmen Barajas"
replace race_1=3 if name_1_=="Carmen Lopez"
replace race_1=3 if name_1_=="Carola Huerta"
replace race_1=3 if name_1_=="Carola Ibarra"
replace race_1=1 if name_1_=="Carrie King"
replace race_1=3 if name_1_=="Catalina Hernandez"
replace race_1=3 if name_1_=="Catalina Jaurez"
replace race_1=3 if name_1_=="Cesar Vazquez"
replace race_1=3 if name_1_=="Cesar Zavala"
replace race_1=1 if name_1_=="Claire Schwartz"
replace race_1=1 if name_1_=="Cody Anderson"
replace race_1=1 if name_1_=="Cole Krueger"
replace race_1=1 if name_1_=="Colin Smith"
replace race_1=1 if name_1_=="Connor Schwartz"
replace race_1=2 if name_1_=="Darius Joseph"
replace race_1=2 if name_1_=="Darnell Banks"
replace race_1=2 if name_1_=="DeAndre Jefferson"
replace race_1=2 if name_1_=="DeShawn Korsey"
replace race_1=2 if name_1_=="Deja Jefferson"
replace race_1=2 if name_1_=="Deja Mosley"
replace race_1=3 if name_1_=="Dolores Ramirez"
replace race_1=3 if name_1_=="Dolores Sanchez"
replace race_1=2 if name_1_=="Dominique Mosley"
replace race_1=1 if name_1_=="Dustin Nelson"
replace race_1=1 if name_1_=="Dylan Schwartz"
replace race_1=2 if name_1_=="Ebony Mosley"
replace race_1=2 if name_1_=="Ebony Washington"
replace race_1=3 if name_1_=="Edgar Sanchez"
replace race_1=3 if name_1_=="Edgar Zavala"
replace race_1=3 if name_1_=="Eduardo Lopez"
replace race_1=3 if name_1_=="Eduardo Torres"
replace race_1=1 if name_1_=="Emily Schmidt"
replace race_1=1 if name_1_=="Emma Clark"
replace race_1=3 if name_1_=="Enrique Huerta"
replace race_1=1 if name_1_=="Garrett Novak"
replace race_1=1 if name_1_=="Geoffrey Martin"
replace race_1=1 if name_1_=="Greg Adams"
replace race_1=1 if name_1_=="Hannah Phillips"
replace race_1=1 if name_1_=="Heather Martin"
replace race_1=3 if name_1_=="Hernan Garcia"
replace race_1=1 if name_1_=="Holly Schroeder"
replace race_1=1 if name_1_=="Hunter Miller"
replace race_1=1 if name_1_=="Jack Evans"
replace race_1=2 if name_1_=="Jada Mosley"
replace race_1=1 if name_1_=="Jake Clark"
replace race_1=2 if name_1_=="Jamal Gaines"
replace race_1=2 if name_1_=="Jamal Rivers"
replace race_1=2 if name_1_=="Jasmin Jefferson"
replace race_1=2 if name_1_=="Jasmine Joseph"
replace race_1=3 if name_1_=="Javier Gonzalez"
replace race_1=1 if name_1_=="Jay Allen"
replace race_1=2 if name_1_=="Jazmine Jefferson"
replace race_1=1 if name_1_=="Jenna Anderson"
replace race_1=2 if name_1_=="Jermaine Gaines"
replace race_1=1 if name_1_=="Jill Smith"
replace race_1=3 if name_1_=="Jorge Cervantes"
replace race_1=3 if name_1_=="Jose Martinez"
replace race_1=3 if name_1_=="Jose Orozco"
replace race_1=3 if name_1_=="Jose Sanchez"
replace race_1=3 if name_1_=="Juan Barajas"
replace race_1=3 if name_1_=="Juan Hernandez"
replace race_1=1 if name_1_=="Katelyn Miller"
replace race_1=1 if name_1_=="Katherine Adams"
replace race_1=1 if name_1_=="Kathryn Evans"
replace race_1=1 if name_1_=="Katie Novak"
replace race_1=2 if name_1_=="Keisha Rivers"
replace race_1=2 if name_1_=="Kiara Jackson"
replace race_1=1 if name_1_=="Kristen Clark"
replace race_1=2 if name_1_=="LaShawn Banks"
replace race_1=2 if name_1_=="LaShawn Washington"
replace race_1=2 if name_1_=="Latonya Rivers"
replace race_1=2 if name_1_=="Latoya Rivers"
replace race_1=1 if name_1_=="Logan Allen"
replace race_1=3 if name_1_=="Luis Hernandez"
replace race_1=3 if name_1_=="Luis Vazquez"
replace race_1=1 if name_1_=="Luke Phillips"
replace race_1=1 if name_1_=="Madeline Haas"
replace race_1=3 if name_1_=="Magdalena Perez"
replace race_1=3 if name_1_=="Margarita Garcia"
replace race_1=3 if name_1_=="Margarita Velazquez"
replace race_1=3 if name_1_=="Maria Ramirez"
replace race_1=3 if name_1_=="Maria Rodriguez"
replace race_1=1 if name_1_=="Matthew Anderson"
replace race_1=1 if name_1_=="Maxwell Haas"
replace race_1=1 if name_1_=="Molly Kruger"
replace race_1=3 if name_1_=="Pedro Rodriguez"
replace race_1=2 if name_1_=="Precious Washington"
replace race_1=2 if name_1_=="Rasheed Gaines"
replace race_1=2 if name_1_=="Raven Korsey"
replace race_1=3 if name_1_=="Rosa Orozco"
replace race_1=3 if name_1_=="Rosa Perez"
replace race_1=1 if name_1_=="Sarah Miller"
replace race_1=1 if name_1_=="Scott King"
replace race_1=2 if name_1_=="Shanice Booker"
replace race_1=1 if name_1_=="Tanner Smith"
replace race_1=3 if name_1_=="Teresa Jaurez"
replace race_1=2 if name_1_=="Terrance Booker"
replace race_1=1 if name_1_=="Todd Mueller"
replace race_1=2 if name_1_=="Tremayne Joseph"
replace race_1=2 if name_1_=="Trevon Jackson"
replace race_1=2 if name_1_=="Tyreke Washington"
replace race_1=2 if name_1_=="Tyrone Booker"
replace race_1=2 if name_1_=="Tyrone Joseph"
replace race_1=1 if name_1_=="Wyatt Smith"
replace race_1=2 if name_1_=="Xavier Jackson"
replace race_2=1 if name_2_=="Abigail Smith"
replace race_2=2 if name_2_=="Alaliyah Booker"
replace race_2=1 if name_2_=="Alexus Banks"
replace race_2=3 if name_2_=="Alfonso Gonzalez"
replace race_2=1 if name_2_=="Allison Nelson"
replace race_2=1 if name_2_=="Amy Mueller"
replace race_2=1 if name_2_=="Anne Evans"
replace race_2=3 if name_2_=="Beatriz Ibarra"
replace race_2=3 if name_2_=="Beatriz Martinez"
replace race_2=3 if name_2_=="Blanca Ramirez"
replace race_2=1 if name_2_=="Bradley Schwartz"
replace race_2=1 if name_2_=="Brett Clark"
replace race_2=1 if name_2_=="Caitlin Schneider"
replace race_2=3 if name_2_=="Carlita Torres"
replace race_2=3 if name_2_=="Carlos Perez"
replace race_2=3 if name_2_=="Carlos Torres"
replace race_2=1 if name_2_=="Carly Smith"
replace race_2=3 if name_2_=="Carmela Velazquez"
replace race_2=3 if name_2_=="Carmen Barajas"
replace race_2=3 if name_2_=="Carmen Lopez"
replace race_2=3 if name_2_=="Carola Huerta"
replace race_2=3 if name_2_=="Carola Ibarra"
replace race_2=1 if name_2_=="Carrie King"
replace race_2=3 if name_2_=="Catalina Hernandez"
replace race_2=3 if name_2_=="Catalina Jaurez"
replace race_2=3 if name_2_=="Cesar Vazquez"
replace race_2=3 if name_2_=="Cesar Zavala"
replace race_2=1 if name_2_=="Claire Schwartz"
replace race_2=1 if name_2_=="Cody Anderson"
replace race_2=1 if name_2_=="Cole Krueger"
replace race_2=1 if name_2_=="Colin Smith"
replace race_2=1 if name_2_=="Connor Schwartz"
replace race_2=2 if name_2_=="Darius Joseph"
replace race_2=2 if name_2_=="Darnell Banks"
replace race_2=2 if name_2_=="DeAndre Jefferson"
replace race_2=2 if name_2_=="DeShawn Korsey"
replace race_2=2 if name_2_=="Deja Jefferson"
replace race_2=2 if name_2_=="Deja Mosley"
replace race_2=3 if name_2_=="Dolores Ramirez"
replace race_2=3 if name_2_=="Dolores Sanchez"
replace race_2=2 if name_2_=="Dominique Mosley"
replace race_2=1 if name_2_=="Dustin Nelson"
replace race_2=1 if name_2_=="Dylan Schwartz"
replace race_2=2 if name_2_=="Ebony Mosley"
replace race_2=2 if name_2_=="Ebony Washington"
replace race_2=3 if name_2_=="Edgar Sanchez"
replace race_2=3 if name_2_=="Edgar Zavala"
replace race_2=3 if name_2_=="Eduardo Lopez"
replace race_2=3 if name_2_=="Eduardo Torres"
replace race_2=1 if name_2_=="Emily Schmidt"
replace race_2=1 if name_2_=="Emma Clark"
replace race_2=3 if name_2_=="Enrique Huerta"
replace race_2=1 if name_2_=="Garrett Novak"
replace race_2=1 if name_2_=="Geoffrey Martin"
replace race_2=1 if name_2_=="Greg Adams"
replace race_2=1 if name_2_=="Hannah Phillips"
replace race_2=1 if name_2_=="Heather Martin"
replace race_2=3 if name_2_=="Hernan Garcia"
replace race_2=1 if name_2_=="Holly Schroeder"
replace race_2=1 if name_2_=="Hunter Miller"
replace race_2=1 if name_2_=="Jack Evans"
replace race_2=2 if name_2_=="Jada Mosley"
replace race_2=1 if name_2_=="Jake Clark"
replace race_2=2 if name_2_=="Jamal Gaines"
replace race_2=2 if name_2_=="Jamal Rivers"
replace race_2=2 if name_2_=="Jasmin Jefferson"
replace race_2=2 if name_2_=="Jasmine Joseph"
replace race_2=3 if name_2_=="Javier Gonzalez"
replace race_2=1 if name_2_=="Jay Allen"
replace race_2=2 if name_2_=="Jazmine Jefferson"
replace race_2=1 if name_2_=="Jenna Anderson"
replace race_2=2 if name_2_=="Jermaine Gaines"
replace race_2=1 if name_2_=="Jill Smith"
replace race_2=3 if name_2_=="Jorge Cervantes"
replace race_2=3 if name_2_=="Jose Martinez"
replace race_2=3 if name_2_=="Jose Orozco"
replace race_2=3 if name_2_=="Jose Sanchez"
replace race_2=3 if name_2_=="Juan Barajas"
replace race_2=3 if name_2_=="Juan Hernandez"
replace race_2=1 if name_2_=="Katelyn Miller"
replace race_2=1 if name_2_=="Katherine Adams"
replace race_2=1 if name_2_=="Kathryn Evans"
replace race_2=1 if name_2_=="Katie Novak"
replace race_2=2 if name_2_=="Keisha Rivers"
replace race_2=2 if name_2_=="Kiara Jackson"
replace race_2=1 if name_2_=="Kristen Clark"
replace race_2=2 if name_2_=="LaShawn Banks"
replace race_2=2 if name_2_=="LaShawn Washington"
replace race_2=2 if name_2_=="Latonya Rivers"
replace race_2=2 if name_2_=="Latoya Rivers"
replace race_2=1 if name_2_=="Logan Allen"
replace race_2=3 if name_2_=="Luis Hernandez"
replace race_2=3 if name_2_=="Luis Vazquez"
replace race_2=1 if name_2_=="Luke Phillips"
replace race_2=1 if name_2_=="Madeline Haas"
replace race_2=3 if name_2_=="Magdalena Perez"
replace race_2=3 if name_2_=="Margarita Garcia"
replace race_2=3 if name_2_=="Margarita Velazquez"
replace race_2=3 if name_2_=="Maria Ramirez"
replace race_2=3 if name_2_=="Maria Rodriguez"
replace race_2=1 if name_2_=="Matthew Anderson"
replace race_2=1 if name_2_=="Maxwell Haas"
replace race_2=1 if name_2_=="Molly Kruger"
replace race_2=3 if name_2_=="Pedro Rodriguez"
replace race_2=2 if name_2_=="Precious Washington"
replace race_2=2 if name_2_=="Rasheed Gaines"
replace race_2=2 if name_2_=="Raven Korsey"
replace race_2=3 if name_2_=="Rosa Orozco"
replace race_2=3 if name_2_=="Rosa Perez"
replace race_2=1 if name_2_=="Sarah Miller"
replace race_2=1 if name_2_=="Scott King"
replace race_2=2 if name_2_=="Shanice Booker"
replace race_2=1 if name_2_=="Tanner Smith"
replace race_2=3 if name_2_=="Teresa Jaurez"
replace race_2=2 if name_2_=="Terrance Booker"
replace race_2=1 if name_2_=="Todd Mueller"
replace race_2=2 if name_2_=="Tremayne Joseph"
replace race_2=2 if name_2_=="Trevon Jackson"
replace race_2=2 if name_2_=="Tyreke Washington"
replace race_2=2 if name_2_=="Tyrone Booker"
replace race_2=2 if name_2_=="Tyrone Joseph"
replace race_2=1 if name_2_=="Wyatt Smith"
replace race_2=2 if name_2_=="Xavier Jackson"
label variable race_1 "White 1 Black 2 Hispanic 3"
label variable race_2 "White 1 Black 2 Hispanic 3"

*Make Numeric Variables for Compromise, Political Experience, Military Service, Issue Positions 
gen compromise_1=.
gen compromise_2=.
gen experience_1=.
gen experience_2=.

gen occupation_1=.
gen occupation_2=.
gen marital_1=.
gen marital_2=.
gen children_1=.
gen children_2=.
gen inarea_1=.
gen inarea_2=.

gen military_1=.
gen military_2=.
gen prolife_1=.
gen prolife_2=.
gen foodstamp_1=.
gen foodstamp_2=.
gen guns_1=.
gen guns_2=.
gen proleave_1=.
gen proleave_2=.
label variable compromise_1 "Rigid 0 Compromiser 1"
label variable compromise_2 "Rigid 0 Compromiser 1"
label variable experience_1 "None 0 Experience 1"
label variable experience_2 "None 0 Experience 1"
label variable occupation_1 "Occupation: Law 1; Education 2; Medical 3; Financial 4; Small business 5; Journalist 6; Farmer 7; Social Programs 8"
label variable occupation_2 "Occupation: Law 1; Education 2; Medical 3; Financial 4; Small business 5; Journalist 6; Farmer 7; Social Programs 8"
label variable marital_1 "Single 0; Married 1; Remarried 2; Divorced 3"
label variable marital_2 "Single 0; Married 1; Remarried 2; Divorced 3"
label variable children_1 "Number of Children" 
label variable children_2 "Number of Children" 
label variable inarea_1 "Number of Years in Area (25=whole life)" 
label variable inarea_2 "Number of Years in Area (25=whole life)" 
label variable military_1 "None 0 Experience 1"
label variable military_2 "None 0 Experience 1"
label variable prolife_1 "Pro-Choice 0 Pro-Life 1"
label variable prolife_2 "Pro-Choice 0 Pro-Life 1"
label variable proleave_1 "Opposes FL 0 Supports FL 1"
label variable proleave_2 "Opposes FL 0 Supports FL 1"
label variable foodstamp_1 "Decreased 0 Kept As-Is 1 Increased 2"
label variable foodstamp_2 "Decreased 0 Kept As-Is 1 Increased 2"
label variable guns_1 "Less Strict 0 Kept As-Is 1 More Strict 2"
label variable guns_2 "Less Strict 0 Kept As-Is 1 More Strict 2"

*Renaming the Characteristic Variables to Make the Loop Easier
rename chara_1_ char1_1
rename chara_2_ char1_2
rename charb_1_ char2_1
rename charb_2_ char2_2
rename charc_1_ char3_1
rename charc_2_ char3_2
rename chard_1_ char4_1
rename chard_2_ char4_2

forvalues i=1/4 {
	replace compromise_1=1 if inlist(char`i'_1,"a coalition-builder","one who seeks consensus","pragmatic","tolerant of other views","willing to compromise","willing to work with the other side")
	replace compromise_1=0 if inlist(char`i'_1,"a good party soldier","committed to their positions","ideologically pure","uncompromising","unswerving in their values","willing to fight for principles")
	replace compromise_2=1 if inlist(char`i'_2,"a coalition-builder","one who seeks consensus","pragmatic","tolerant of other views","willing to compromise","willing to work with the other side")
	replace compromise_2=0 if inlist(char`i'_2,"a good party soldier","committed to their positions","ideologically pure","uncompromising","unswerving in their values","willing to fight for principles")
	replace experience_1=0 if characteristic`i'=="Political Experience:" & inlist(char`i'_1,"None")
	replace experience_1=1 if characteristic`i'=="Political Experience:" & inlist(char`i'_1,"Mayor","Member of County Board","Member of School Board","Member of Town Council","Sheriff")
	replace experience_2=0 if characteristic`i'=="Political Experience:" & inlist(char`i'_2,"None")
	replace experience_2=1 if characteristic`i'=="Political Experience:" & inlist(char`i'_2,"Mayor","Member of County Board","Member of School Board","Member of Town Council","Sheriff")

	replace marital_1=0 if inlist(char`i'_1,"Single")
	replace marital_1=1 if inlist(char`i'_1,"Married")
	replace marital_1=2 if inlist(char`i'_1,"Remarried")
	replace marital_1=3 if inlist(char`i'_1,"Currently Divorced")
	replace marital_2=0 if inlist(char`i'_2,"Single")
	replace marital_2=1 if inlist(char`i'_2,"Married")
	replace marital_2=2 if inlist(char`i'_2,"Remarried")
	replace marital_2=3 if inlist(char`i'_2,"Currently Divorced")

	forvalues n=0/4{
    replace children_1=`n' if characteristic`i'=="Number of Children:" & char`i'_1=="`n'"
    replace children_2=`n' if characteristic`i'=="Number of Children:" & char`i'_2=="`n'"
	}
	forvalues n=5/20{
    replace inarea_1=`n' if characteristic`i'=="Number of Years Living in the Area:" & char`i'_1=="`n'"
    replace inarea_2=`n' if characteristic`i'=="Number of Years Living in the Area:" & char`i'_2=="`n'"
	}
//somewhat arbitrary decision to set to 25 if "Entire life"; could also use a separate indicator
    replace inarea_1=25 if characteristic`i'=="Number of Years Living in the Area:" & char`i'_1=="Entire life"
    replace inarea_2=25 if characteristic`i'=="Number of Years Living in the Area:" & char`i'_2=="Entire life"

	replace occupation_1=1 if inlist(char`i'_1,"General Practice Attorney","Real Estate Attorney","Family Law Attorney","Corporate Attorney","Employment Law Attorney","Criminal Defense Attorney","Public Defender")
	replace occupation_1=2 if inlist(char`i'_1,"High School Science Teacher","High School Math Teacher","High School English Teacher","High School Social Studies Teacher","Middle School Science Teacher","Middle School Math Teacher","Middle School English Teacher","Middle School Social Studies Teacher","Grade School Teacher")
	replace occupation_1=3 if inlist(char`i'_1,"General Practitioner Physician","General Surgeon","Cardiologist","Radiologist","Urologist","Anesthesiologist","Dentist","Pediatrician")
	replace occupation_1=4 if inlist(char`i'_1,"Tax Accountant","Corporate Accountant","Insurance Agent","Personal Banker","Loan Officer","Financial Advisor")
	replace occupation_1=5 if inlist(char`i'_1,"Owner and Operator of Local Bakery","Owner and Operator of Local Clothing Store","Owner and Operator of Local Hardware Store","Owner and Operator of Local Furniture Store","Owner and Operator of Local Car Dealership","Owner and Operator of Local Restaurant","Owner and Operator of Local Coffee Shop")
	replace occupation_1=6 if inlist(char`i'_1,"Television Reporter","Newspaper Reporter","Television News Anchor","Television Meteorologist","Newspaper Editor","Local Radio Personality")
	replace occupation_1=7 if inlist(char`i'_1,"Dairy Farmer","Farmer","Organic Farmer","Poultry Farmer","Pig Farmer")
	replace occupation_1=8 if inlist(char`i'_1,"Social Worker","Community Organizer")
	replace occupation_2=1 if inlist(char`i'_2,"General Practice Attorney","Real Estate Attorney","Family Law Attorney","Corporate Attorney","Employment Law Attorney","Criminal Defense Attorney","Public Defender")
	replace occupation_2=2 if inlist(char`i'_2,"High School Science Teacher","High School Math Teacher","High School English Teacher","High School Social Studies Teacher","Middle School Science Teacher","Middle School Math Teacher","Middle School English Teacher","Middle School Social Studies Teacher","Grade School Teacher")
	replace occupation_2=3 if inlist(char`i'_2,"General Practitioner Physician","General Surgeon","Cardiologist","Radiologist","Urologist","Anesthesiologist","Dentist","Pediatrician")
	replace occupation_2=4 if inlist(char`i'_2,"Tax Accountant","Corporate Accountant","Insurance Agent","Personal Banker","Loan Officer","Financial Advisor")
	replace occupation_2=5 if inlist(char`i'_2,"Owner and Operator of Local Bakery","Owner and Operator of Local Clothing Store","Owner and Operator of Local Hardware Store","Owner and Operator of Local Furniture Store","Owner and Operator of Local Car Dealership","Owner and Operator of Local Restaurant","Owner and Operator of Local Coffee Shop")
	replace occupation_2=6 if inlist(char`i'_2,"Television Reporter","Newspaper Reporter","Television News Anchor","Television Meteorologist","Newspaper Editor","Local Radio Personality")
	replace occupation_2=7 if inlist(char`i'_2,"Dairy Farmer","Farmer","Organic Farmer","Poultry Farmer","Pig Farmer")
	replace occupation_2=8 if inlist(char`i'_2,"Social Worker","Community Organizer")

	replace military_1=0 if characteristic`i'=="Military Service:" & inlist(char`i'_1,"None")
	replace military_1=1 if characteristic`i'=="Military Service:" & inlist(char`i'_1,"U.S. Air Force","U.S. Army","U.S. Coast Guard","U.S. Marine Corps","U.S. Navy")
	replace military_2=0 if characteristic`i'=="Military Service:" & inlist(char`i'_2,"None")
	replace military_2=1 if characteristic`i'=="Military Service:" & inlist(char`i'_2,"U.S. Air Force","U.S. Army","U.S. Coast Guard","U.S. Marine Corps","U.S. Navy")
	replace prolife_1=1 if char`i'_1=="Pro-life"
	replace prolife_1=0 if char`i'_1=="Pro-choice"
	replace prolife_2=1 if char`i'_2=="Pro-life"
	replace prolife_2=0 if char`i'_2=="Pro-choice"
	replace proleave_1=1 if characteristic`i'=="Position on requiring employers to offer paid leave to parents of new children:" & char`i'_1=="Supports"
	replace proleave_1=0 if characteristic`i'=="Position on requiring employers to offer paid leave to parents of new children:" & char`i'_1=="Opposes"
	replace proleave_2=1 if characteristic`i'=="Position on requiring employers to offer paid leave to parents of new children:" & char`i'_2=="Supports"
	replace proleave_2=0 if characteristic`i'=="Position on requiring employers to offer paid leave to parents of new children:" & char`i'_2=="Opposes"
	replace guns_1=0 if characteristic`i'=="Thinks laws covering the sale of guns should be:" & char`i'_1=="Less strict"
	replace guns_1=1 if characteristic`i'=="Thinks laws covering the sale of guns should be:" & char`i'_1=="Kept as they are"
	replace guns_1=2 if characteristic`i'=="Thinks laws covering the sale of guns should be:" & char`i'_1=="More strict"
	replace guns_2=0 if characteristic`i'=="Thinks laws covering the sale of guns should be:" & char`i'_2=="Less strict"
	replace guns_2=1 if characteristic`i'=="Thinks laws covering the sale of guns should be:" & char`i'_2=="Kept as they are"
	replace guns_2=2 if characteristic`i'=="Thinks laws covering the sale of guns should be:" & char`i'_2=="More strict"
	replace foodstamp_1=0 if characteristic`i'=="Thinks food stamp benefits should be:" & char`i'_1=="Decreased"
	replace foodstamp_1=1 if characteristic`i'=="Thinks food stamp benefits should be:" & char`i'_1=="Kept as they are"
	replace foodstamp_1=2 if characteristic`i'=="Thinks food stamp benefits should be:" & char`i'_1=="Increased"
	replace foodstamp_2=0 if characteristic`i'=="Thinks food stamp benefits should be:" & char`i'_2=="Decreased"
	replace foodstamp_2=1 if characteristic`i'=="Thinks food stamp benefits should be:" & char`i'_2=="Kept as they are"
	replace foodstamp_2=2 if characteristic`i'=="Thinks food stamp benefits should be:" & char`i'_2=="Increased"

	}

*flip abortion so consistent high numbers==liberal
recode prolife_1 prolife_2 (1=0) (0=1), gen(prochoice_1 prochoice_2)
drop prolife_1 prolife_2

*outcome (linear)
replace scale_2=scale_2*-1
egen rel_eval=rmean(scale_1 scale_2)
label var rel_eval "Scale Evaluations (100 Cand A: much better; -100 Cand B: much better)"
rename choice_ choice
recode choice (1=0) (0=1)
label var choice "Prefer Candidate A"

*Name Treatment indicators (note, still have data organized by conjoint task, not candidate)
gen black_1=0
gen black_2=0
replace black_1=1 if race_1==2
replace black_2=1 if race_2==2
gen hispanic_1=0
gen hispanic_2=0
replace hispanic_1=1 if race_1==3
replace hispanic_2=1 if race_2==3

**keep only variables needed for analysis
keep responseid fips name_1 name_2 democrat compromise_1- proleave_2 prochoice_1 prochoice_2 woman_1 woman_2 black_1 black_2 hispanic_1 hispanic_2 rel_eval choice age female r_white r_black r_hispanic r_other educ income incomemis task woman hispanic prob_hispanic immig_count rresent_count immig rresent perc_black_hh perc_hisp_hh closeness_12 ln_pct_black ln_pct_hisp closeness l_female_any -l_hisp_any youactivelyr youhelptoconnectcandidateswithdo candidatesforstateorlocalofficer candidatesforfederalofficereques youprovidestrategicadvicetocandi 
rename choice choice_1
recode choice_1 (1=0) (0=1), gen(choice_2)
rename rel_eval rel_eval_1
gen rel_eval_2=rel_eval_1*-1

**opponent demographics (only used for LOWESS; Figure 4)
foreach i in woman black hispanic{
gen opp_`i'_1=`i'_2
gen opp_`i'_2=`i'_1
}
rename name_1_ name_1
rename name_2_ name_2

**At this point, unit of analysis is conjoint TASK (10/chair); Now RESHAPE TO STACK CANDIDATES (20/chair)***
gen conjoint=_n
reshape long name_ woman_ black_ hispanic_ opp_woman_ opp_black_ opp_hispanic_ compromise_ experience_ occupation_ marital_ children_ inarea_ military_ prochoice_ foodstamp_ guns_ proleave_ choice_ rel_eval_, i(conjoint) j(candidate)
drop if choice_==.

//drop med_age

***RECREATE CHARACTERISTIC INDICATORS (now that candidates are stacked)
foreach i of varlist woman_ black_ hispanic_ compromise_ experience_ occupation_ marital_ children_ inarea_ military_ prochoice_ foodstamp_ guns_ proleave_ {
qui tab `i', mis gen(X_`i')
}

********Measure for Class/Occupation Masking
** OCCUPATION-->INCOME based on BLS data by occupation class
gen income_est=136380 if X_occupation_1 
replace income_est=60270  if X_occupation_2
replace income_est=202450 if X_occupation_3
replace income_est=75280 if X_occupation_4
replace income_est=68000 if X_occupation_5
replace income_est=50970 if X_occupation_6
replace income_est=69880 if X_occupation_7
replace income_est=46170 if X_occupation_8
//set to median in this sample (treatments) for those not presented with
replace income_est=69880 if X_occupation_9
replace income_est=income_est/10000
label var income_est "Estimated Income ($10,000s; if Occupation Presented)"

*drop first value indicator for each characteristics (used as reference category)
foreach i of varlist X*_1{
rename `i' condition_`i'
}

* drop gender/race related indicators; don't need for estimates of variability of FX
drop condition_X_woman_1 condition_X_black_1 condition_X_hispanic_1

*rename indicators that are indicators for a characteristic not being presented to a respondent
rename X_compromise_3 compromise_np
rename X_experience_3 experience_np
rename X_inarea_15 inarea_np
rename X_children_6 children_np
rename X_marital_5 marital_np
rename X_occupation_9 occupation_np
rename X_military_3 military_np
rename X_prochoice_3 prochoice_np
rename X_foodstamp_4 foodstamp_np
rename X_guns_4 guns_np
rename X_proleave_3 proleave_exclude

label var compromise_np "Compromise Not Presented" 
label var experience_np "Experience Not Presented"
label var inarea_np "Years In Area Not Presented"
label var children_np "Number of Children Not Presented"
label var marital_np "Marital Status Not Presented"
label var occupation_np "Occupation Not Presented"
label var military_np "Military Not Presented"
label var prochoice_np "Abortion Position Not Presented"
label var foodstamp_np "Food Stamps Position Not Presented"
label var guns_np "Guns Position Not Presented" 
label var proleave_exclude "Family Leave Position Not Presented"

**generate "no issues presented" indicators
gen no_issue=proleave_exclude & guns_np & prochoice_np & foodstamp_np
label var no_issue "No Issue Positions (1=yes)"

gen no_policy=no_issue+compromise_np
label var no_policy "No Policy Cues (1=yes)"

**label indicators for candidate race/gender
rename X_woman_ cand_female
rename X_black_ cand_black
rename X_hispanic_ cand_hispanic
label var cand_female "Female Candidate"
label var cand_black "Black Candidate"
label var cand_hispanic "Latinx Candidate"
rename opp_woman opp_female
generate opp_white=opp_black==0 & opp_hisp==0
label var opp_female "Opponent is Female"
label var opp_white "Opponent is White"
label var opp_black "Opponent is Black"
label var opp_hispanic "Opponent is Latinx"

**label indicators for other candidate descriptors
label var condition_X_compromise_1 "Not Compromiser"
label var X_compromise_2 "Compromiser"
label var condition_X_experience_1 "No Political Experience"
label var X_experience_2 "Has Political Experience"
label var condition_X_occupation_1 "Job - Law"
label var X_occupation_2 "Job - Education"
label var X_occupation_3 "Job - Medicine"
label var X_occupation_4 "Job - Financial"
label var X_occupation_5 "Job - Small Business"
label var X_occupation_6 "Job - Journalist"
label var X_occupation_7 "Job - Farmer"
label var X_occupation_8 "Job - Social Programs"
label var condition_X_marital_1 "Single"
label var X_marital_2 "Married"
label var X_marital_3 "Remarried"
label var X_marital_4 "Divorced" 
label var condition_X_children_1 "No Children" 
label var X_children_2 "1 Child" 
label var X_children_3 "2 Children" 
label var X_children_4 "3 Children"
label var X_children_5 "4 Children"
label var condition_X_inarea_1 "In Area 5 years"
label var X_inarea_2 "In Area 6 years"
label var X_inarea_3 "In Area 7 years"
label var X_inarea_4 "In Area 8 years"
label var X_inarea_5 "In Area 9 years"
label var X_inarea_6 "In Area 10 years"
label var X_inarea_7 "In Area 11 years"
label var X_inarea_8 "In Area 12 years"
label var X_inarea_9 "In Area 13 years"
label var X_inarea_10 "In Area 14 years"
label var X_inarea_11 "In Area 15 years"
label var X_inarea_12 "In Area 18 years"
label var X_inarea_13 "In Area 20 years"
label var X_inarea_14 "In Area Entire Life"
label var condition_X_military_1 "No Military Service"
label var X_military_2 "Military Service"
label var X_prochoice_2 "Pro-Choice" 
label var X_foodstamp_2 "Food Stamps - Same" 
label var X_foodstamp_3 "Food Stamps - Increased" 
label var X_guns_2 "Gun Laws - Same" 
label var X_guns_3 "Gun Laws - More strict" 
label var X_proleave_2 "Supports Family Leave"

**Generate indicator for "same race"
gen same_race=0
replace same_race=1 if opp_black & cand_black
replace same_race=1 if opp_hisp & cand_hisp
replace same_race=1 if opp_white& cand_hisp==0 &cand_black==0 
label var same_race "Candidates Same Race (1=yes)"

gen same_sex=0
replace same_sex=1 if (cand_female==0 & opp_female==0) |(cand_female==1 & opp_female==1) 
label var same_sex "Candidates Same Sex (1=yes)"


*generate party congruence (and incongruence) indicators for policy positioning treatments
foreach i in choice leave {
gen `i'_cong=X_pro`i'_2
recode `i'_cong (1=0) (0=1) if democrat==0
gen condition_`i'_incong=condition_X_pro`i'_1
recode condition_`i'_incong (1=0) (0=1) if democrat==1
}

foreach i in guns foodstamp {
gen `i'_cong=X_`i'_3
recode `i'_cong (1=0) (0=1) if democrat==0
gen condition_`i'_incong=condition_X_`i'_1
recode condition_`i'_incong (1=0) (0=1) if democrat==1
}

//renaming to allow me to use wildcards and not have choice* pick up the outcome indicator
rename choice_cong abortion_cong
replace abortion_cong=0 if prochoice_np==1
replace leave_cong=0 if proleave_exclude==1
replace guns_cong=0 if guns_np==1 | X_guns_2==1
replace foodstamp_cong=0 if foodstamp_np==1 | X_foodstamp_2==1

label var abortion_cong "Party Congruent: Abortion"
label var leave_cong "Party Congruent: Family Leave"
label var guns_cong "Party Congruent: Guns"
label var foodstamp_cong "Party Congruent: Food Stamps"
label var condition_choice_incong "Party Incongruent: Abortion"
label var condition_leave_incong "Party Incongruent: Family Leave"
label var condition_guns_incong "Party Incongruent: Guns"
label var condition_foodstamp_incong "Party Incongruent: Food Stamps"

*drop all but mid-point indicators for the two 3-point issues (e.g., gun laws the same); what's being dropped are indicators for positions that have been recoded to align with party
drop X_prochoice_2 X_foodstamp_3 X_guns_3 X_proleave_2
*drop raw conditions (not matched to party congruence); not needed for estimates of variance in FX
drop condition_X_foodstamp_1 condition_X_guns_1 condition_X_proleave_1 condition_X_prochoice_1


*****************SAVE DATASET FOR CORE ANALYSIS******************
compress
save "dataset_for_analysis\replication_data_anon.dta", replace

****RUN ANALYSIS
include analysis.do
