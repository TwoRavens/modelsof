clear all
* Set root path of replication archieve here 
local path = "~/Box Sync/Shared_EffectofIncarceration_Pennslyvania/Replication Data/"

cd "`path'/Connecticut SA Tables 03 and 04"
cap log close
log using "CTCorrectionsData.log", replace

clear all 
set more off

***********************************************************************
*
* Table SA3: Registration and Turnout among Pop. First Incarcerated Post-2008 and Eligible in 2012
*
***********************************************************************

use "CTcorrectionsvfreplication.dta", clear

label var reg_08 "Registered 2008 (1=yes)"
label var vote_08final "Voted 2008  (1=yes)"
label var reg_12 "Registered 2012 (1=yes)"
label var vote_12final "Voted 2012 (1=yes)"
label var delta_reg "Change in Registration 2012-2008"
label var delta_vote "Change in Voting 2012-2008"

foreach var of varlist reg_12 vote_12final reg_08 vote_08final delta_reg delta_vote {
 gen temp=`var'
 local templabel : var label `var' 
 if "`var'"=="reg_12" {
  outsum temp using "SA_Table03_CTIncarcerationPanel.out", replace bracket ctitle("`templabel'")
 }
 else {
  outsum temp using "SA_Table03_CTIncarcerationPanel.out", append bracket ctitle("`templabel'")
 }
 drop temp
 
}

***********************************************************************
*
* Table SA4: Compares 2012 turnout of 2008 registrants who first went to prison to the general population 
*
***********************************************************************

use "CTvfcorrectionsreplication.dta", clear

* Drops if missing covariates
drop if missing(zip)
drop if missing(Age)

gen g_man=Gender=="male"
gen g_unknown=Gender=="unknown"
drop Gender

gen pid_d=PartyAffiliation=="DEM"
gen pid_r=PartyAffiliation=="REP"
drop PartyAffiliation

gen voted08=A2008G~=""
drop A2008G

* Runs matched pair first (for labeling reasons)
preserve
keep if former_felon==0
save "temp_noprisonformerge.dta", replace
restore
keep if former_felon==1
rename Age Age_toprison
rename ID ID_toprison 
rename v_pres_general_12 v_pres_general_12_toprison
count
joinby g_man g_unknown pid_d pid_r zip voted08 using "temp_noprisonformerge.dta", unmatched(master)
!erase "temp_noprisonformerge.dta"
tab _merge
drop if _merge~=3
drop _merge

* Now score the age matches
gen agediff=abs(Age-Age_toprison)
* Require age to be withing 2.5 years on either side (5 year window)
drop if agediff >2.5

gsort ID_toprison agediff ID
drop if ID_toprison==ID_toprison[_n-1]
count

keep ID ID_toprison v_pres_general_12 v_pres_general_12_toprison voted08 Age Age_toprison

rename v_pres_general_12 X_GEN_2012_11_1
rename v_pres_general_12_toprison X_GEN_2012_11_2
rename Age age_1
rename Age_toprison age_2
gen unique_person_id_sent_1 = ID
rename ID_toprison unique_person_id_sent_2 
gen upis = _n

reshape long X_GEN_2012_11_ age_ unique_person_id_sent_, i(upis voted08) j(treat) 
replace treat=treat-1

rename X_GEN_2012_11_ X_GEN_2012_11
rename treat former_felon
rename age_ Age
rename unique_person_id_sent_ unique_person_id_sent

areg X_GEN_2012_11 former_felon Age, absorb(upis) cluster(unique_person_id_sent)
qui summ former_felon if e(sample)
local numfelons=r(N)*r(mean)
outreg2 using "SA_Table04_CTVoterFilePanel.out", replace se bracket label /*
*/ dec(3) symbol(***, **, *) addstat("Number treated to prison", `numfelons') /*
*/ addnote("Note: Cell entries are OLS estimates with robust standard errors in brackets. *p<.1; **p<.05; ***p<.01.") 

* Runs regressions using full dataset
use "CTvfcorrectionsreplication.dta", clear

* Drops if missing covariates
drop if missing(zip)
drop if missing(Age)

label var v_pres_general_12 "Voted 2012 (1=yes)"

label var former_felon "Formerly Incarcerated (1=convicted after May 1, 2009 and released by September 30, 2012)"

gen voted08=A2008G~=""
drop A2008G
label var voted08 "Voted 2008 (1=yes)"

label var Age "Age (years)"
gen Age2=(Age^2)/100
label var Age2 "Age squared / 100"

gen g_man=Gender=="male"
gen g_unknown=Gender=="unknown"
drop Gender

label var g_man "Gender=Male"
label var g_unknown "Gender=Unknown"

gen pid_d=PartyAffiliation=="DEM"
gen pid_r=PartyAffiliation=="REP"
drop PartyAffiliation

label var pid_d "Registered Democrat (1=yes)"
label var pid_r "Registered Republican (1=yes)"

count if former_felon==1
local numfelons=r(N)

regress v_pres_general_12 former_felon, robust
outreg2 using "SA_Table04_CTVoterFilePanel.out", append se bracket label /*
*/ dec(3) symbol(***, **, *) addstat("Number treated to prison", `numfelons')

areg v_pres_general_12 former_felon, robust absorb(zip) 
local numzipfe = e(df_a)+ 1
outreg2 using "SA_Table04_CTVoterFilePanel.out", append se bracket label /*
*/ dec(3) symbol(***, **, *) addstat("Number treated to prison", `numfelons', "Zip code fixed effects", `numzipfe')

areg v_pres_general_12 former_felon Age Age2 pid_d pid_r g_man g_unknown, robust absorb(zip) 
local numzipfe = e(df_a)+ 1
outreg2 using "SA_Table04_CTVoterFilePanel.out", append se bracket label /*
*/ dec(3) symbol(***, **, *) addstat("Number treated to prison", `numfelons', "Zip code fixed effects", `numzipfe')

areg v_pres_general_12 former_felon voted08 Age Age2 pid_d pid_r g_man g_unknown, robust absorb(zip) 
local numzipfe = e(df_a)+ 1
outreg2 using "SA_Table04_CTVoterFilePanel.out", append se bracket label /*
*/ dec(3) symbol(***, **, *) addstat("Number treated to prison", `numfelons', "Zip code fixed effects", `numzipfe')

log close
