set mem 10m
set more off 
set rmsg on



************************************************
************Table 2*****************************
********Demographic characteristics*************
***********Main experiment**********************
************************************************

use choice_experiments_wide, clear

*calculate the required demographic summary statistics
bys experiment: egen average_age=mean(age)
bys experiment: egen stdev_age=sd(age)
bys experiment: egen percent_male=mean(sexismale)
bys experiment: egen percent_edhigh=mean(edhigh)
bys experiment: egen percent_edsomecol=mean(edsomecol)
bys experiment: egen percent_edcolgrad=mean(edcolgrad)
bys experiment: egen percent_edpost=mean(edpost)
bys experiment: egen nsubjects=count(id)

*by age groups
bys experiment agegroup: egen average_age_ag=mean(age)
bys experiment agegroup: egen stdev_age_ag=sd(age)
bys experiment agegroup: egen percent_male_ag=mean(sexismale)
bys experiment agegroup: egen percent_edhigh_ag=mean(edhigh)
bys experiment agegroup: egen percent_edsomecol_ag=mean(edsomecol)
bys experiment agegroup: egen percent_edcolgrad_ag=mean(edcolgrad)
bys experiment agegroup: egen percent_edpost_ag=mean(edpost)
bys experiment agegroup: egen nsubjects_ag=count(id)

*collapse the data to create a file containing only the table
*use only the main experiment data
preserve
keep if experiment==1
collapse average_age stdev_age percent_male percent_edhigh percent_edsomecol percent_edcolgrad percent_edpost nsubjects
gen agegroup=0
save temp1, replace
restore
keep if experiment==1
collapse average_age_ag stdev_age_ag percent_male_ag percent_edhigh_ag percent_edsomecol_ag percent_edcolgrad_ag percent_edpost_ag nsubjects_ag, by(agegroup)
local var "average_age stdev_age percent_male percent_edhigh percent_edsomecol percent_edcolgrad percent_edpost nsubjects"
foreach i of local var {
	rename `i'_ag `i'
}
save temp2, replace

use temp1, clear
append using temp2

sort agegroup
label define ag 0 "All ages" 1 "18 to 40" 2 "41 to 60" 3 "Over 60"
label values agegroup ag

save table2, replace


************************************************
************Table 3*****************************
****Frequency of (nearly) optimal choice********
***********Main experiment**********************
************************************************

use choice_experiments, clear

*use only the main experiment data
keep if experiment==1

*drop the practice round
drop if round==1

preserve
*overall frequencies
egen optimal_freq=mean(optimal)
egen nearly_optimal_freq=mean(optimalten)
egen observations=count(id)
gen type=1
collapse optimal_freq nearly_optimal_freq observations, by(type)
save temp1, replace
restore
preserve
*frequencies across the number of options
bys noptions: egen optimal_freq=mean(optimal)
bys noptions: egen nearly_optimal_freq=mean(optimalten)
bys noptions: egen observations=count(id)
gen type=2
collapse optimal_freq nearly_optimal_freq observations, by(type noptions)
gen str10 desc="4" if noptions==4
replace desc="13" if noptions==13
drop noptions
save temp2, replace
restore
preserve
*frequencies across the number of states
bys natt: egen optimal_freq=mean(optimal)
bys natt: egen nearly_optimal_freq=mean(optimalten)
bys natt: egen observations=count(id)
gen type=3
collapse optimal_freq nearly_optimal_freq observations, by(type natt)
gen str10 desc="6" if natt==6
replace desc="10" if natt==10
drop natt
save temp3, replace
restore
preserve
*frequencies across pdfs
bys pdf_even: egen optimal_freq=mean(optimal)
bys pdf_even: egen nearly_optimal_freq=mean(optimalten)
bys pdf_even: egen observations=count(id)
gen type=4
collapse optimal_freq nearly_optimal_freq observations, by(type pdf_even)
gen str10 desc="1 (even)" if pdf_even==1
replace desc="2(extreme)" if pdf_even==0
drop pdf_even
save temp4, replace
restore
preserve
*frequencies across age
bys agegroup: egen optimal_freq=mean(optimal)
bys agegroup: egen nearly_optimal_freq=mean(optimalten)
bys agegroup: egen observations=count(id)
gen type=5
collapse optimal_freq nearly_optimal_freq observations, by(type agegroup)
gen str10 desc="18-40" if agegroup==1
replace desc="41-60" if agegroup==2
replace desc="Over 60" if agegroup==3
drop agegroup
save temp5, replace
restore
*frequencies across gender
bys sexismale: egen optimal_freq=mean(optimal)
bys sexismale: egen nearly_optimal_freq=mean(optimalten)
bys sexismale: egen observations=count(id)
gen type=6
collapse optimal_freq nearly_optimal_freq observations, by(type sexismale)
gen str10 desc="Men" if sexismale==1
replace desc="Women" if sexismale==0
drop sexismale
save temp6, replace

clear

forval i=1/6 {
	append using temp`i'
}

label define type 1 "All" 2 "Options" 3 "States" 4 "PDF" 5 "Age" 6 "Sex"
label values type type

placevar desc, after(type)
sort type desc

save table3, replace


************************************************
************Table 4*****************************
*********Likelihood of optimal choice***********
***********Main experiment**********************
************************************************

use choice_experiments, clear

gen timesq=time*time
gen timesq1000=timesq/1000
gen older=(agegroup==3)
gen older_nopt_dum3=older*nopt_dum3

probit optimal nopt_dum3 natt_dum4 pdf_extreme if experiment==1 & round~=1, robust cluster(id)

probit optimal nopt_dum3 natt_dum4 pdf_extreme age sex edpost if experiment==1 & round~=1, robust cluster(id)

probit optimal nopt_dum3 natt_dum4 pdf_extreme age sex edpost older_nopt_dum3 if experiment==1 & round~=1, robust cluster(id)

probit optimal nopt_dum3 natt_dum4 pdf_extreme time timesq1000 age sex edpost older_nopt_dum3 if experiment==1 & round~=1, robust cluster(id)



************************************************
************Table 5*****************************
*********Average efficiency*********************
***********Main experiment**********************
************************************************

use choice_experiments, clear

*use only the main experiment data
keep if experiment==1

*drop the practice round
drop if round==1

bys id: egen temp1=total(pay)
bys id: egen temp2=total(best_opt)
bys id: egen temp3=total(average_payoff)

gen average_efficiency=temp1/temp2
gen average_normalized_efficiency=(temp1-temp3)/(temp2-temp3)
drop temp1 temp2 temp3

preserve
*average overall efficiency
egen observations=count(id)
gen type=1
collapse average_efficiency average_normalized_efficiency observations, by(type)
save temp1, replace
restore
preserve
*average efficiency across age
bys agegroup: egen observations=count(id)
gen type=2
collapse average_efficiency average_normalized_efficiency observations, by(type agegroup)
gen str10 desc="18-40" if agegroup==1
replace desc="41-60" if agegroup==2
replace desc="Over 60" if agegroup==3
drop agegroup
save temp2, replace
restore
*average efficiency across gender
bys sexismale: egen observations=count(id)
gen type=3
collapse average_efficiency average_normalized_efficiency observations, by(type sexismale)
gen str10 desc="Men" if sexismale==1
replace desc="Women" if sexismale==0
drop sexismale
save temp3, replace

clear

forval i=1/3 {
	append using temp`i'
}

label define type 1 "All" 2 "Age" 3 "Sex"
label values type type

placevar desc, after(type)
sort type desc

save table5, replace




************************************************
************Table 6*****************************
*********OLS estimates of Efficiency************
***********Main experiment**********************
************************************************

use choice_experiments, clear

*use only the main experiment data
keep if experiment==1

*drop the practice round
drop if round==1

bys id: egen temp1=total(pay)
bys id: egen temp2=total(best_opt)
bys id: egen temp3=total(average_payoff)

gen average_efficiency=temp1/temp2
gen average_normalized_efficiency=(temp1-temp3)/(temp2-temp3)
drop temp1 temp2 temp3

collapse (mean) average_efficiency (mean) average_normalized_efficiency (mean) optimality=optimal, by(id age education edhigh edsomecol edcolgrad edpost sexismale experiment agegroup)

replace average_efficiency=average_efficiency*100
replace average_normalized_efficiency=average_normalized_efficiency*100
replace optimality=optimality*100

*average efficiency
reg average_efficiency age sexismale edpost 

*average normalized efficiency
reg average_normalized_efficiency age sexismale edpost 

*average optimality frequency
reg optimal age sexismale edpost 




************************************************
************Table 7*****************************
****Optimal choice by age and education*********
***********Main experiment**********************
************************************************

use choice_experiments, clear

*use only the main experiment data
keep if experiment==1

*drop the practice round
drop if round==1

preserve
*frequencies across age and education
bys agegroup education: egen optimal_freq=mean(optimal)
collapse optimal, by(agegroup education)
gen str10 desc="18-40" if agegroup==1
replace desc="41-60" if agegroup==2
replace desc="Over 60" if agegroup==3
save temp1, replace
restore
*frequencies across age 
bys agegroup: egen optimal_freq=mean(optimal)
collapse optimal, by(agegroup)
gen str10 desc="18-40" if agegroup==1
replace desc="41-60" if agegroup==2
replace desc="Over 60" if agegroup==3
gen education=99
save temp2, replace

clear

forval i=1/2 {
	append using temp`i'
}

label define type 1 "High school" 2 "Some college" 3 "College" 4 "Postgraduate" 99 "All" 
label values education type

placevar desc education, first
sort desc education

save table7, replace



************************************************
************Table 8 ****************************
********Demographic characteristics*************
******Main and high stakes experiment***********
************************************************

use choice_experiments_wide, clear

drop if agegroup==2

bys experiment: egen average_age=mean(age)
bys experiment: egen stdev_age=sd(age)
bys experiment: egen percent_male=mean(sexismale)
bys experiment: egen percent_edhigh=mean(edhigh)
bys experiment: egen percent_edsomecol=mean(edsomecol)
bys experiment: egen percent_edcolgrad=mean(edcolgrad)
bys experiment: egen percent_edpost=mean(edpost)
bys experiment: egen nsubjects=count(id)


bys experiment agegroup: egen average_age_ag=mean(age)
bys experiment agegroup: egen stdev_age_ag=sd(age)
bys experiment agegroup: egen percent_male_ag=mean(sexismale)
bys experiment agegroup: egen percent_edhigh_ag=mean(edhigh)
bys experiment agegroup: egen percent_edsomecol_ag=mean(edsomecol)
bys experiment agegroup: egen percent_edcolgrad_ag=mean(edcolgrad)
bys experiment agegroup: egen percent_edpost_ag=mean(edpost)
bys experiment agegroup: egen nsubjects_ag=count(id)

preserve
collapse average_age stdev_age percent_male percent_edhigh percent_edsomecol percent_edcolgrad percent_edpost nsubjects, by(experiment)
gen agegroup=0
save temp1, replace
restore
collapse average_age_ag stdev_age_ag percent_male_ag percent_edhigh_ag percent_edsomecol_ag percent_edcolgrad_ag percent_edpost_ag nsubjects_ag, by(experiment agegroup)
local var "average_age stdev_age percent_male percent_edhigh percent_edsomecol percent_edcolgrad percent_edpost nsubjects"
foreach i of local var {
	rename `i'_ag `i'
}
save temp2, replace

use temp1, clear
append using temp2

sort experiment agegroup
label define ag 0 "All ages" 1 "18 to 40" 2 "41 to 60" 3 "Over 60"
label values agegroup ag

save table8, replace




************************************************
************Table 9*****************************
****(Nearly) Optimal choice and efficiency******
************by age and experiment***************
************************************************

use choice_experiments, clear

*use the same rounds used in both the main and high stakes experiments
keep if round==2 | round==5 | round==7 | round==8

*use the same agegroups in both experiments
drop if agegroup==2

*calculate average efficiency measures
bys id: egen temp1=total(pay)
bys id: egen temp2=total(best_opt)
bys id: egen temp3=total(average_payoff)

gen average_efficiency=temp1/temp2
gen average_normalized_efficiency=(temp1-temp3)/(temp2-temp3)
drop temp1 temp2 temp3

*frequencies across age and education
bys agegroup experiment: egen optimal_freq=mean(optimal)
bys agegroup experiment: egen nearly_optimal_freq=mean(optimalten)
bys agegroup experiment: egen subjects=count(id)
replace subjects=subjects/4
collapse (mean) optimal_freq (mean) nearly_optimal_freq (mean) average_efficiency (mean) average_normalized_efficiency (mean) subjects, by(agegroup experiment)
gen str10 desc="18-40" if agegroup==1
replace desc="41-60" if agegroup==2
replace desc="Over 60" if agegroup==3

sort experiment agegroup
placevar optimal_freq nearly_optimal_freq average_efficiency average_normalized_efficiency subjects, last

save table9, replace



************************************************
************Table 10****************************
*********Likelihood of optimal choice***********
*******Main and high stakes experiments*********
************************************************

use choice_experiments, clear

gen timesq=time*time
gen timesq1000=timesq/1000
gen older=(agegroup==3)
gen older_nopt_dum3=older*nopt_dum3

probit optimal nopt_dum3 natt_dum4 pdf_extreme age sex edpost high_stakes if experiment~=3 & (round==2 | round==5 | round==7 | round==8) & agegroup~=2, robust cluster(id)

probit optimal nopt_dum3 natt_dum4 pdf_extreme age sex edpost older_nopt_dum3 high_stakes if experiment~=3 & (round==2 | round==5 | round==7 | round==8) & agegroup~=2, robust cluster(id)

probit optimal nopt_dum3 natt_dum4 pdf_extreme age sex edpost older_nopt_dum3 high_stakes time timesq1000 if experiment~=3 & (round==2 | round==5 | round==7 | round==8) & agegroup~=2, robust cluster(id)





************************************************
************Table 11****************************
***********Heuristics***************************
************************************************

clear

insheet using heuristics_data.csv

gen csevar=subj*10+round

gen agegroup=2
replace agegroup=1 if age<41
replace agegroup=3 if age>60

*all decisions
clogit chosen pay tal lex undom, group(csevar)

*for each age group
clogit chosen pay tal lex undom if agegroup==1, group(csevar)

clogit chosen pay tal lex undom if agegroup==1, group(csevar)

clogit chosen pay tal lex undom if agegroup==1, group(csevar)




************************************************
************Table 12****************************
*******Selection frequency for each option******
*********by age groups**************************
***********Validation***************************
************************************************

clear

insheet using validation_experiment_data.csv

reshape long opt, i(id) j(round)

*drop the comprehension round
drop if round==1

gen task=1
replace task=4 if round==3 | round==7
replace task=3 if round==4 | round==8
replace task=2 if round==5 | round==9

gen agegroup=3
replace agegroup=1 if age<41

label define agegroup 1 "Younger" 3 "Older"
label values agegroup agegroup

forval i=1/6 {
	gen temp=(opt==`i')
	bys task agegroup: egen option`i'_freq=mean(temp)
	drop temp
}

collapse (mean) option1_freq (mean) option2_freq (mean) option3_freq (mean) option4_freq (mean) option5_freq (mean) option6_freq, by(task agegroup)

save table12, replace

