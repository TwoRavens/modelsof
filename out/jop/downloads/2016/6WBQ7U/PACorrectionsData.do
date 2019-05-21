clear all
* Set root path of replication archieve here 
local path = "~/Box Sync/Shared_EffectofIncarceration_Pennslyvania/Replication Data/"

cd "`path'/PA Corrections"
cap log close
log using "PACorrectionsData.log", replace

clear all 
set more off

***********************************************************************
*
* Table 2: Registration and Turnout among Pop. First Incarcerated Post-2008 and Eligible in 2012
*
***********************************************************************

use "PAcorrectionsvfreplication.dta", clear

gen delta_reg=reg_12-reg_08
gen delta_vote=vote_12final-vote_08final

label var reg_12 "Registered 2012 (1=yes)"
label var reg_08 "Registered 2008 (1=yes)"

label var vote_12final "Voted 2012 (1=yes)"
label var vote_08final "Voted 2008 (1=yes)"

label var delta_reg "Change in Registration 2012-2008"
label var delta_vote "Change in Voting 2012-2008"

foreach var of varlist reg_12 vote_12final reg_08 vote_08final delta_reg delta_vote {
 gen temp=`var'
 local templabel : var label `var' 
 if "`var'"=="reg_12" {
  outsum temp using "Table02_PAIncarcerationPanel.out", replace bracket ctitle("`templabel'")
 }
 else {
  outsum temp using "Table02_PAIncarcerationPanel.out", append bracket ctitle("`templabel'")
 }
 drop temp
}

* Restricts to sample of people convicted in 2010 and discharged by 2011
keep if (substr(first_movement, 1, 4) == "2010" | substr(first_movement, 1, 4) == "2011") & /*
*/ (substr(last_movement_pre2012, 1, 4) == "2010" | substr(last_movement_pre2012, 1, 4) == "2011")

foreach var of varlist reg_12 vote_12final reg_08 vote_08final delta_reg delta_vote {
 gen temp=`var'
 local templabel : var label `var' 
 if "`var'"=="reg_12" {
  outsum temp using "Table02_PAIncarcerationPanelRestricted.out", /*
  */ replace bracket ctitle("`templabel'")
 }
 else {
  outsum temp using "Table02_PAIncarcerationPanelRestricted.out", /*
  */ append bracket ctitle("`templabel'")
 }
 drop temp
}

***********************************************************************
*
* Table 3: Compares 2012 turnout of 2008 registrants who first went to prison to the general population 
* Note that first column is presented last in final paper; it is done first here just for reasons of better labeling.
*
***********************************************************************

use "PAvfcorrectionsreplication.dta", clear

* Drops if missing covariates
drop if missing(dob)
replace zipcode = substr(zipcode, 1, 5)
destring zipcode, force replace
drop if missing(zipcode)

gen gender_male = (gender == "M")
gen gender_unknown = (gender == "U") | missing(gender)
gen pty_democrat = (party_id == "D")
gen pty_republican = (party_id == "R")
drop gender party_id first_movement last_movement_pre2012 

* Runs matched pair first (for labeling reasons)
preserve
keep if prison==0
save "temp_noprisonformerge.dta", replace
restore
keep if prison==1
rename dob dob_toprison
rename id id_toprison 
rename vote_12final vote_12final_toprison
count
joinby gender_male gender_unknown pty_democrat pty_republican zipcode vote_08final using "temp_noprisonformerge.dta", unmatched(master)
!erase "temp_noprisonformerge.dta"
tab _merge
drop if _merge~=3
drop _merge

gen age = ((mdy(11, 6, 2012) - dob) / 365.25) 
gen age_toprison = ((mdy(11, 6, 2012) - dob_toprison) / 365.25) 

* Now score the age matches
gen agediff=abs(age-age_toprison)
* Require age to be withing 2.5 years on either side (5 year window)
drop if agediff >2.5

gsort id_toprison agediff id
drop if id_toprison==id_toprison[_n-1]
count

keep id id_toprison vote_12final vote_12final_toprison vote_08final age age_toprison

rename vote_12final X_GEN_2012_11_1
rename vote_12final_toprison X_GEN_2012_11_2
rename age age_1
rename age_toprison age_2
gen unique_person_id_sent_1 = id
rename id_toprison unique_person_id_sent_2 
gen upis = _n

reshape long X_GEN_2012_11_ age_ unique_person_id_sent_, i(upis vote_08final) j(treat) 
replace treat=treat-1

rename X_GEN_2012_11_ X_GEN_2012_11
rename treat prison
rename age_ age
rename unique_person_id_sent_ unique_person_id_sent

areg X_GEN_2012_11 prison age, absorb(upis) cluster(unique_person_id_sent)
qui summ prison if e(sample)
local numfelons=r(N)*r(mean)
outreg2 using "Table03_PAVoterFilePanel.out", replace se bracket label /*
*/ dec(3) symbol(***, **, *)  /*
*/ addnote("Note: Cell entries are OLS estimates with robust standard errors in brackets. *p<.1; **p<.05; ***p<.01.") /*
*/ addstat("Number treated to prison", `numfelons')

* Runs regressions using full dataset
use "PAvfcorrectionsreplication.dta", clear

* Drops if Missing Covariates
drop if missing(dob)
replace zipcode = substr(zipcode, 1, 5)
destring zipcode, force replace
drop if missing(zipcode)

label var vote_12final "Voted 2012 (1=yes)"

label var prison "Formerly Incarcerated (1=admitted to state prison after November 5, 2008 and released by September 30, 2016)"

label var vote_08final "Voted 2008 (1=yes)"


gen age = ((mdy(11, 6, 2012) - dob) / 365.25) 
gen age2 = ((mdy(11, 6, 2012) - dob) / 365.25)^2 / 100
label var age "Age in years (2012)"
label var age2 "Age squared / 100"

gen pty_democrat = (party_id == "D")
gen pty_republican = (party_id == "R")
label var pty_democrat "Registered Democrat (1=yes)"
label var pty_republican "Registered Republican (1=yes)"

gen gender_male = (gender == "M")
gen gender_unknown = (gender == "U") | missing(gender)
label var gender_male "Gender=Male"
label var gender_unknown "Gender=Unknown"

count if prison==1
local numfelons=r(N)

tab vote_12final prison, col
tab vote_08final prison, col

regress vote_12final prison, robust
outreg2 using "Table03_PAVoterFilePanel.out", bracket label /*
*/  dec(3) symbol(***, **, *) se addstat("Number treated to prison", `numfelons') append

areg vote_12final prison, robust absorb(zipcode) 
local numzipfe = e(df_a)+ 1
outreg2 using "Table03_PAVoterFilePanel.out", bracket label /*
*/ dec(3) symbol(***, **, *) se addstat("Number treated to prison", `numfelons', "Zip code fixed effects", `numzipfe') append

areg vote_12final prison age age2 pty_democrat pty_republican gender_male gender_unknown, robust absorb(zipcode) 
local numzipfe = e(df_a)+ 1
outreg2 using "Table03_PAVoterFilePanel.out", bracket label /*
*/ dec(3) symbol(***, **, *) se addstat("Number treated to prison", `numfelons', "Zip code fixed effects", `numzipfe') append

areg vote_12final prison vote_08final age age2 pty_democrat pty_republican gender_male gender_unknown, robust absorb(zipcode) 
local numzipfe = e(df_a)+ 1
outreg2 using "Table03_PAVoterFilePanel.out", bracket label /*
*/ dec(3) symbol(***, **, *) se addstat("Number treated to prison", `numfelons', "Zip code fixed effects", `numzipfe') append

log close
