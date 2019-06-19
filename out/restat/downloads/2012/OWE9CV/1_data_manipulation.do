set mem 20m
set more off
set rmsg on

******************data organization**************************
*****************get all experiments in one data file********


****************************************************
clear

*main experiment
insheet using main_experiment_raw_data.csv

*experiment 1 is the main experiment
gen experiment=1
label var experiment "Experiment identifier"

label var sexismale "Male dummy"

label var age "Age"

*define age groups
gen agegroup=2
replace agegroup=1 if age<41
replace agegroup=3 if age>60
label var agegroup "Age group"

*define education variables
label define education 1 "Less than 9th grade" 2 "Grades 9-12, no diploma" 3 "High school" 4 "Some college" 5 "Associate's degree" 6 "Bachelor's degree" 7 "Graduate or professional degree" 
label values education education
*these are not mutually exclusive education attainment variables
gen edhigh=(education>=1)
gen edsomecol=(education>3)
gen edcolgrad=(education>5)
gen edpost=(education==7)

*generate a total earnings variable
gen total_earned=paid1+paid2+paid3+paid4+paid5+paid6+paid7+paid8+paid9

order id experiment opt1 opt2 opt3 opt4 opt5 opt6 opt7 opt8 opt9 pay1 pay2 pay3 pay4 pay5 pay6 pay7 pay8 pay9 round_order1 round_order2 round_order3 round_order4 round_order5 round_order6 round_order7 round_order8 round_order9 time1 time2 time3 time4 time5 time6 time7 time8 time9 paid1 paid2 paid3 paid4 paid5 paid6 paid7 paid8 paid9 total_earned sexismale age agegroup education edhigh edsomecol edcolgrad edpost

**reshape into long format**
reshape long opt pay round_order time paid, i(id) j(round)
placevar round, after(experiment)

*add task characteristics for each round, the number of options and attributes 
gen noptions=0
replace noptions=2 if round==1
replace noptions=4 if round==2 | round==4 | round==6 | round==8
replace noptions=13 if round==3 | round==5 | round==7 | round==9
label var noptions "Number of options seen"

gen natt=0
replace natt=3 if round==1
replace natt=6 if round==2 | round==3 | round==4 | round==5
replace natt=10 if round==6 | round==7 | round==8 | round==9
label var natt "Total attributes seen"

placevar noptions natt, after(round_order)

*generate dummies for the number of each the number of options seen and the number of attributes seen
tab noptions, gen(nopt_dum)
label var nopt_dum1 "2 option dummy"
label var nopt_dum2 "4 option dummy"
label var nopt_dum3 "13 option dummy"

tab natt, gen(tb)
rename tb1 natt_dum2
rename tb2 natt_dum3
rename tb3 natt_dum4
label var natt_dum2 "3 attribute dummy"
label var natt_dum3 "6 attribute dummy"
label var natt_dum4 "10 attribute dummy"

placevar nopt_dum1 nopt_dum2 nopt_dum3 natt_dum2 natt_dum3 natt_dum4, after(natt)

*add best and worst payoff and average payoff for every round
gen best_opt=80 if round==1
replace best_opt=71 if round==2 | round==3 | round==4 | round==6 | round==7 | round==8
replace best_opt=96 if round==5 | round==9

gen worst_opt=50 if round==1 | round==2 | round==6
replace worst_opt=42 if round==3 | round==7
replace worst_opt=31 if round==4 | round==8
replace worst_opt=5 if round==5 | round==9

gen average_payoff=65 if round==1
replace average_payoff=62.25 if round==2 | round==6
replace average_payoff=58.61538 if round==3 | round==7
replace average_payoff=52 if round==4 | round==8
replace average_payoff=55.53846 if round==5 | round==9

*generate a dummy indicating optimal choice
gen optimal=(opt==1)

*generate a dummy indicating the nearly optimal choice, within 10% of the optimal option
gen temp=0.9*best_opt
gen optimalten=(pay>=temp)
drop temp

*adjust the id variable to allow additional experiments to be merged
replace id=id+1000

*generate a mutually exclusive education attainment variable, along with corresponding dummy variables
gen educ=0
replace educ=1 if education<=3
replace educ=2 if education==4 | education==5
replace educ=3 if education==6
replace educ=4 if education==7
placevar educ, after(education)
drop education edhigh edsomecol edcolgrad edpost
rename educ education
label drop education
label define education 1 "High school" 2 "Some college" 3 "College" 4 "Postgraduate"
label values education education
gen edhigh=(education==1)
gen edsomecol=(education==2)
gen edcolgrad=(education==3)
gen edpost=(education==4)
label var edhigh "High school and less dummy"
label var edsomecol "Some college (includes associate's) dummy"
label var edcolgrad "College graduate dummy"
label var edpost "Postgraduate dummy"
label var education "Education level"
placevar edhigh-edpost, after(education)

*generate a variable indicating whether the choice made in the practice round was optimal
bys id: gen practice=optimal if round==1
bys id: egen test=max(practice)
drop practice
rename test practice
bys id: gen tb=paid if round==1
bys id: egen earn_practice=max(tb)
drop tb
label var practice "Practice round dummy=1 if optimal chosen"
label var earn_practice "Earned payment in practice round"
placevar practice earn_practice, after(natt)

*generate a dummy for the different pdfs across the rounds/tasks
gen pdf=0
replace pdf=1 if round==2 | round==3 |round==6 | round==7
replace pdf=2 if round==4 | round==5 |round==8 | round==9
label var pdf "PDF identifier"

*define the extreme and even pdfs
gen pdf_extreme=(pdf==2)
gen pdf_even=(pdf==1)
label var pdf_extreme "Extreme pdf dummy"
label var pdf_even "Even pdf dummy"

label var opt "Option chosen"
label var optimal "Dummy (=1) if optimal option chosen"
label var optimalten "Dummy (=1) if chosen option within 10% of optimal"
label var pay "Chosen option's payoff probability"
label var round "Round"
label var round_order "Order in which each round is seen"
label var paid "Paid dummy=1 if paid"
label var time "Time taken"
label var total_earned "Total earnings"

save main, replace





****************************************************

clear
*high stakes experiment
insheet using high_stakes_experiment_raw_data.csv

gen experiment=2
label var experiment "Experiment identifier"

label var sexismale "Male dummy"

label var age "Age"

*define age groups
gen agegroup=2
replace agegroup=1 if age<41
replace agegroup=3 if age>60
label var agegroup "Age group"

label define education 1 "Less than 9th grade" 2 "Grades 9-12, no diploma" 3 "High school" 4 "Some college" 5 "Associate's degree" 6 "Bachelor's degree" 7 "Graduate or professional degree" 
label values education education
*these are not mutually exclusive education attainment variables
gen edhigh=(education>2)
gen edsomecol=(education>3)
gen edcolgrad=(education>5)
gen edpost=(education==7)

gen total_earned=paid2*10+paid5*10+paid7*10+paid8*10

order id experiment opt2 opt5 opt7 opt8 pay2 pay5 pay7 pay8 round_order2 round_order5 round_order7 round_order8 time2 time5 time7 time8 paid2 paid5 paid7 paid8 total_earned sexismale age agegroup education edhigh edsomecol edcolgrad edpost

**reshape into long format**

reshape long opt pay round_order time paid, i(id) j(round)
placevar round, after(experiment)

*add task characteristics for each round, the number of options and attributes 
gen noptions=0
replace noptions=4 if round==2 | round==8
replace noptions=13 if round==5 | round==7
label var noptions "Number of options seen"

gen natt=0
replace natt=6 if round==2 | round==5
replace natt=10 if round==7 | round==8
label var natt "Total attributes seen"

placevar noptions natt, after(round_order)

*generate dummies for the number of each the number of options seen and the number of attributes seen
gen nopt_dum2=(noptions==4)
gen nopt_dum3=(noptions==13)
label var nopt_dum2 "4 option dummy"
label var nopt_dum3 "13 option dummy"

gen natt_dum3=(natt==6)
gen natt_dum4=(natt==10)
label var natt_dum3 "6 attribute dummy"
label var natt_dum4 "10 attribute dummy"

placevar nopt_dum2 nopt_dum3 natt_dum3 natt_dum4, after(natt)

*add best and worst payoff and average payoff for every round
gen best_opt=71 if round==2 | round==7 | round==8
replace best_opt=96 if round==5

gen worst_opt=50 if round==2 
replace worst_opt=42 if round==7
replace worst_opt=31 if round==8
replace worst_opt=5 if round==5

gen average_payoff=62.25 if round==2 
replace average_payoff=58.61538 if round==7
replace average_payoff=52 if round==8
replace average_payoff=55.53846 if round==5

*generate a dummy indicating optimal choice
gen optimal=(opt==1)

*generate a dummy indicating the nearly optimal choice, within 10% of the optimal option
gen temp=0.9*best_opt
gen optimalten=(pay>=temp)
drop temp

replace id=id+2000

*generate a mutually exclusive education attainment variable, along with corresponding dummy variables
gen educ=0
replace educ=1 if education<=3
replace educ=2 if education==4 | education==5
replace educ=3 if education==6
replace educ=4 if education==7
placevar educ, after(education)
drop education edhigh edsomecol edcolgrad edpost
rename educ education
label drop education
label define education 1 "High school" 2 "Some college" 3 "College" 4 "Postgraduate"
label values education education
gen edhigh=(education==1)
gen edsomecol=(education==2)
gen edcolgrad=(education==3)
gen edpost=(education==4)
label var edhigh "High school and less dummy"
label var edsomecol "Some college (includes associate's) dummy"
label var edcolgrad "College graduate dummy"
label var edpost "Postgraduate dummy"
label var education "Education level"
placevar edhigh-edpost, after(education)

*generate a dummy for the different pdfs across the rounds/tasks
gen pdf=0
replace pdf=1 if round==2 | round==3 |round==6 | round==7
replace pdf=2 if round==4 | round==5 |round==8 | round==9
label var pdf "PDF identifier"

*define the extreme and even pdfs
gen pdf_extreme=(pdf==2)
gen pdf_even=(pdf==1)
label var pdf_extreme "Extreme pdf dummy"
label var pdf_even "Even pdf dummy"

label var opt "Option chosen"
label var optimal "Dummy (=1) if optimal option chosen"
label var optimalten "Dummy (=1) if chosen option within 10% of optimal"
label var pay "Chosen option's payoff probability"
label var round "Round"
label var round_order "Order in which each round is seen"
label var paid "Paid dummy=1 if paid"
label var time "Time taken"
label var total_earned "Total earnings"

save high, replace


use main, clear
append using high

placevar  pdf-pdf_even, after(natt_dum4)

*generate a dummy for the high stakes experiment
gen high_stakes=(experiment==2)

label define experiment 1 "Main" 2 "High stakes"
label values experiment experiment



save choice_experiments, replace




****************************************************************************
******************get into wide shape***************************************
***************used for sample mean test************************************
****************************************************************************

clear
insheet using main_experiment_raw_data.csv

gen experiment=1
label var experiment "Experiment identifier"

replace id=id+1000

*define age groups
gen agegroup=2
replace agegroup=1 if age<41
replace agegroup=3 if age>60
label var agegroup "Age group"

*define mutually exclusive education variables
gen educ=0
replace educ=1 if education<=3
replace educ=2 if education==4 | education==5
replace educ=3 if education==6
replace educ=4 if education==7
placevar educ, after(education)
drop education 
rename educ education
label define education 1 "High school" 2 "Some college" 3 "College" 4 "Postgraduate"
label values education education
gen edhigh=(education==1)
gen edsomecol=(education==2)
gen edcolgrad=(education==3)
gen edpost=(education==4)
label var edhigh "High school and less dummy"
label var edsomecol "Some college (includes associate's) dummy"
label var edcolgrad "College graduate dummy"
label var edpost "Postgraduate dummy"
label var education "Education level"
placevar edhigh-edpost, after(education)

save main_experiment_wide, replace


clear
insheet using high_stakes_experiment_raw_data.csv

gen experiment=2
label var experiment "Experiment identifier"

replace id=id+2000

*define age groups
gen agegroup=2
replace agegroup=1 if age<41
replace agegroup=3 if age>60
label var agegroup "Age group"

*define mutually exclusive education variables
gen educ=0
replace educ=1 if education<=3
replace educ=2 if education==4 | education==5
replace educ=3 if education==6
replace educ=4 if education==7
placevar educ, after(education)
drop education 
rename educ education
label define education 1 "High school" 2 "Some college" 3 "College" 4 "Postgraduate"
label values education education
gen edhigh=(education==1)
gen edsomecol=(education==2)
gen edcolgrad=(education==3)
gen edpost=(education==4)
label var edhigh "High school and less dummy"
label var edsomecol "Some college (includes associate's) dummy"
label var edcolgrad "College graduate dummy"
label var edpost "Postgraduate dummy"
label var education "Education level"
placevar edhigh-edpost, after(education)

save high_stakes_experiment_wide, replace

use main_experiment_wide, clear
append using high_stakes_experiment_wide

label define experiment 1 "Main" 2 "High stakes"
label values experiment experiment

save choice_experiments_wide, replace



