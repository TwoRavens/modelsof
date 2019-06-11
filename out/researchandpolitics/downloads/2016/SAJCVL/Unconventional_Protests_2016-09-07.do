* Michael T. Heaney
* Unconventional Protests: Competing Motivations for Mobilization outside the Republican and Democratic National Conventions
* Stata Do File

* September 7, 2016

* Set Up Workspace

log using "C:\Users\mheaney\Documents\AY2015-2016\Research_&_Politics\Data_Analysis\Results.txt", replace
use "C:\Users\mheaney\Documents\AY2015-2016\Research_&_Politics\Data_Analysis\2008_Convention_Protest_Data.dta", clear

* Compute Variables

recode pid (1=1) (2=1) (3=1) (4=0) (5=0) (6=0) (7=0) (8=0), gen(republican)
recode pid (1=0) (2=0) (3=0) (4=0) (5=1) (6=1) (7=1) (8=0), gen(democrat)
recode pid (1=0) (2=0) (3=0) (4=1) (5=0) (6=0) (7=0) (8=1), gen(independent)
recode ideo (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=.), gen(r_ideo)
recode enth (1=5) (2=4) (3=3) (4=2) (5=1), gen(r_enth)
recode anx (1=5) (2=4) (3=3) (4=2) (5=1), gen(r_anx)
recode know (1=3) (2=2) (3=1), gen(r_know)
recode inc (1=7.5) (2=20) (3=37.5) (4=62.5) (5=87.5) (6=112.5) (7=137.5) (8=250) (9=450), gen(income)

gen proximateparty = (dnc * democrat) + (rnc * republican)
gen distantparty = (dnc * republican) + (rnc * democrat)

* Survey Set

svyset [pweight=weight], strata(rnc) 

* Imputation -- Main Analysis

impute proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age educ income, gen(i_proximateparty)
replace i_proximateparty = 0 if i_proximateparty < 0
replace i_proximateparty = 1 if i_proximateparty > 1

impute distantparty proximateparty r_enth r_ideo r_anx r_know localmnco sex race2 age educ income, gen(i_distantparty)
replace i_distantparty = 0 if i_distantparty < 0
replace i_distantparty = 1 if i_distantparty > 1

impute r_ideo distantparty proximateparty r_enth r_anx r_know localmnco sex race2 age educ income, gen(i_r_ideo)
replace i_r_ideo = 1 if i_r_ideo < 1
replace i_r_ideo = 9 if i_r_ideo > 9

impute r_enth proximateparty distantparty r_anx r_ideo r_know localmnco sex race2 age educ income, gen(i_r_enth)
replace i_r_enth = 1 if i_r_enth < 1
replace i_r_enth = 5 if i_r_enth > 5

impute r_anx proximateparty distantparty r_enth r_ideo r_know localmnco sex race2 age educ income, gen(i_r_anx)
replace i_r_anx = 1 if i_r_anx < 1
replace i_r_anx = 5 if i_r_anx > 5

impute r_know proximateparty distantparty r_ideo r_enth r_anx localmnco sex race2 age educ income, gen(i_r_know)
replace i_r_know = 1 if i_r_know < 1
replace i_r_know = 3 if i_r_know > 3

impute localmnco proximateparty distantparty r_ideo r_enth r_anx r_know sex race2 age educ income, gen(i_localmnco)
replace i_localmnco = 0 if i_localmnco < 0
replace i_localmnco = 1 if i_localmnco > 1

impute sex proximateparty distantparty r_ideo r_enth r_anx r_know localmnco race2 age educ income, gen(i_sex)
replace i_sex = 0 if i_sex < 0
replace i_sex = 1 if i_sex > 1

impute race2 proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex age educ income, gen(i_race2)
replace i_race2 = 0 if i_race2 < 0
replace i_race2 = 1 if i_race2 > 1

impute age proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 educ income, gen(i_age)
replace i_age = 14 if i_age < 14

impute educ proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age income, gen(i_educ)
replace i_educ = 1 if i_educ < 1
replace i_educ = 6 if i_educ > 6

impute income proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age educ, gen(i_income)
replace i_income = 0 if i_income < 0

* Descriptive Statistics

svy: tab pid if dnc==1
svy: tab pid if rnc==1

svy: mean reason10 reason7 anyissue if dnc==1
svy: mean reason10 reason7 anyissue if rnc==1

svy: mean reason10 if reason7==1
svy: mean reason10 if anyissue==1
svy: mean reason7 if reason10==1
svy: mean reason7 if anyissue==1
svy: mean anyissue if reason10==1
svy: mean anyissue if reason7==1

svy: mean reason10 reason7 anyissue if dnc==1&antiwarpeace == 0
svy: mean reason10 reason7 anyissue if rnc==1&antiwarpeace == 0

svy: mean reason1 reason2 reason3 reason4 reason5 reason6 reason7 reason8 reason9 reason10 reason11 reason12 reason13 
svy: mean reason1 reason2 reason3 reason4 reason5 reason6 reason7 reason8 reason9 reason10 reason11 reason12 reason13 if dnc == 1
svy: mean reason1 reason2 reason3 reason4 reason5 reason6 reason7 reason8 reason9 reason10 reason11 reason12 reason13 if rnc == 1

svy: mean anyissue antiwarpeace health education environment prochoice campaignselections grouprights leftantisystem civilliberties economy immigration _911truth constitution taxes prowar proreligion
svy: mean proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age educ income

svy: tab reason10 if independent==1

svy: tab reason7 if independent==1
svy: tab reason7 if proximateparty==1
svy: tab reason7 if distantparty==1

svy: tab anyissue if independent==1
svy: tab anyissue if proximateparty==1
svy: tab anyissue if distantparty==1

* Probit Models of Protest Motivation -- Main Analysis

svy: probit reason10 i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income
svy: probit  reason7 i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income
svy: probit anyissue i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income
svy: mean reason10 reason7 anyissue i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income

* Probit Models of Protest Motivation -- Robustness Analysis -- No Antiwar Protesters

impute proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age educ income if antiwarpeace == 0, gen(i_proximateparty2)
replace i_proximateparty2 = 0 if i_proximateparty2 < 0
replace i_proximateparty2 = 1 if i_proximateparty2 > 1

impute distantparty proximateparty r_enth r_ideo r_anx r_know localmnco sex race2 age educ income if antiwarpeace == 0 , gen(i_distantparty2)
replace i_distantparty2 = 0 if i_distantparty2 < 0
replace i_distantparty2 = 1 if i_distantparty2 > 1

impute r_ideo distantparty proximateparty r_enth r_anx r_know localmnco sex race2 age educ income if antiwarpeace == 0, gen(i_r_ideo2)
replace i_r_ideo2 = 1 if i_r_ideo2 < 1
replace i_r_ideo2 = 9 if i_r_ideo2 > 9

impute r_enth proximateparty distantparty r_anx r_ideo r_know localmnco sex race2 age educ income if antiwarpeace == 0, gen(i_r_enth2)
replace i_r_enth2 = 1 if i_r_enth2 < 1
replace i_r_enth2 = 5 if i_r_enth2 > 5

impute r_anx proximateparty distantparty r_enth r_ideo r_know localmnco sex race2 age educ income if antiwarpeace == 0, gen(i_r_anx2)
replace i_r_anx2 = 1 if i_r_anx2 < 1
replace i_r_anx2 = 5 if i_r_anx2 > 5

impute r_know proximateparty distantparty r_ideo r_enth r_anx localmnco sex race2 age educ income if antiwarpeace == 0, gen(i_r_know2)
replace i_r_know2 = 1 if i_r_know2 < 1
replace i_r_know2 = 3 if i_r_know2 > 3

impute localmnco proximateparty distantparty r_ideo r_enth r_anx r_know sex race2 age educ income if antiwarpeace == 0, gen(i_localmnco2)
replace i_localmnco2 = 0 if i_localmnco2 < 0
replace i_localmnco2 = 1 if i_localmnco2 > 1

impute sex proximateparty distantparty r_ideo r_enth r_anx r_know localmnco race2 age educ income if antiwarpeace == 0, gen(i_sex2)
replace i_sex2 = 0 if i_sex2 < 0
replace i_sex2 = 1 if i_sex2 > 1

impute race2 proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex age educ income if antiwarpeace == 0, gen(i_race22)
replace i_race22 = 0 if i_race22 < 0
replace i_race22 = 1 if i_race22 > 1

impute age proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 educ income if antiwarpeace == 0, gen(i_age2)
replace i_age2 = 14 if i_age2 < 14

impute educ proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age income if antiwarpeace == 0, gen(i_educ2)
replace i_educ2 = 1 if i_educ2 < 1
replace i_educ2 = 6 if i_educ2 > 6

impute income proximateparty distantparty r_ideo r_enth r_anx r_know localmnco sex race2 age educ if antiwarpeace == 0, gen(i_income2)
replace i_income2 = 0 if i_income2 < 0

svy: probit reason10 i_proximateparty2 i_distantparty2 i_r_ideo2 i_r_enth2 i_r_anx2 i_r_know2 i_localmnco2 i_sex2 i_race22 i_age2 i_educ2 i_income2 if antiwarpeace == 0
svy: probit  reason7 i_proximateparty2 i_distantparty2 i_r_ideo2 i_r_enth2 i_r_anx2 i_r_know2 i_localmnco2 i_sex2 i_race22 i_age2 i_educ2 i_income2 if antiwarpeace == 0
svy: probit anyissue i_proximateparty2 i_distantparty2 i_r_ideo2 i_r_enth2 i_r_anx2 i_r_know2 i_localmnco2 i_sex2 i_race22 i_age2 i_educ2 i_income2 if antiwarpeace == 0
svy: mean reason10 reason7 anyissue i_proximateparty2 i_distantparty2 i_r_ideo2 i_r_enth2 i_r_anx2 i_r_know2 i_localmnco2 i_sex2 i_race22 i_age2 i_educ2 i_income2 if antiwarpeace == 0

* Simultaneous Equation Models of Protest Motivation -- Robustness Analysis -- Correlated Errors Across Equations

svy: gsem (reason10 <- i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income, probit) (reason7  <- i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income, probit) (anyissue <- i_proximateparty i_distantparty i_r_ideo i_r_enth i_r_anx i_r_know i_localmnco i_sex i_race2 i_age i_educ i_income, probit), covstructure(e._endogenous , unstructured) nocapslatent

log close



     
     
 

