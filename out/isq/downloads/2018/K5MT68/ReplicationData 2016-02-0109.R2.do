*NOTE: The variable names below, including treatment groups, reflect the respective
*survey instruments. Both instruments are available in the replication data folder. 
* We renumbered and reordered the treatments in the published version of the paper.

*****************
** Experiment 1**
*****************
*Set Working Directory*
cd "R:\ForeignAidandPublicOpinion\Replication Data"

* Open Experiment 1 Data
use "Exp1Cleaned.dta", clear

* Generates Values in Figures 1-3 *
set level 90 //To generate 90% confidence intervals
reg dv i.treatment, r

* Generates Values in Column 2 of A10 *
sum age
sum sex
sum highschool
sum college
sum i.politic
sum i.income
sum i.religion
sum outside
sum i.group
sum poverty

* Generates Values in Tables A11 - A12 *
set level 90 //To generate 90% confidence intervals
ologit dv i.treatment, r

* Generates Values in Tables A13 - A14 *
reg dv i.treat age, r
reg dv i.treat sex age highschool i.politic i.income i.religion outside world poverty, r

* Generates Values in Table A19 - A20 *
oneway dv treatment, sidak

*****************
** Experiment 2**
*****************
* Set Working Directory
cd "R:\ForeignAidandPublicOpinion\Replication Data"

* Open Experiment 2 Data
use "Exp2Cleaned.dta", clear

* Generates Values in Figures 4-5, 8 *
set level 90 //To generate 90% confidence intervals
reg dv i.treatment, r

* Generates Values in Figures 6-7 *
set level 90 //To generate 90% confidence intervals
reg dvtb i.treatment, r

* Generates Values in Figures 9 *
tab dv if treatment==0 //Calculate control proportions.
forval i = 1/12{  // Then compare treatment proportions to control proportions with Chi-square goodness of fit test.
preserve
keep if treatment== `i'
csgof dv, expperc(67 18 15)
restore
}

* Generates Values in Column 3 of A10 *
sum age
sum sex
sum highschool
sum college
sum i.politic
sum i.income
sum i.religion
sum outside
sum i.group
sum poverty

* Generates Values in Table A15, A17
set level 90 //To generate 90% confidence intervals
ologit dv i.treatment, r

* Generates Values in Table A16, 18
reg dv i.treat age, r
reg dv i.treat sex age highschool i.politic i.income i.religion outside world poverty, r

* Generates Values in Table A21
oneway dv treatment, sidak





