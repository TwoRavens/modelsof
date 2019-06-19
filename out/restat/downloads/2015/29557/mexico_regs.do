clear all
set mem 800m
set matsize 1000
use mexico2000


***** define variables *****

recode hrswrk1 (998 999=.)

replace incearn=. if incearn==0 | incearn==99999998 | incearn==99999999
replace incearn=incearn*0.10581
gen incwage=incearn*12
gen ln_incwage=ln(incwage)

gen hrwage=incearn/(4.5*hrswrk1)
count if hrwage!=0 & hrwage!=.
count if hrwage>=.05 & hrwage<=20
replace hrwage=. if !(hrwage>=.05 & hrwage<=20)
gen ln_hrwage=ln(hrwage)

gen int educ_cat=yrschl
gen int age_cat=age
gen int educ=yrschl if yrschl!=98 & yrschl!=99
recode educ_cat (0/3=0) (4/6=1) (7/9=2) (10/12=3) (13/18=4) (98 99=.)
recode age_cat (21/25=0) (26/35=1) (36/45=2) (46/55=3) (56/65=4)

gen byte married=(marst==2) if marst!=.
recode urban (1=0) (2=1)
gen byte rural=1-urban
gen byte male=(sex==1)
gen byte female=(sex==2)

***** restrict data *****
keep if age>=21 & age<=65
keep if male

drop if educ_cat==.

*keep if hrswrk1>=10 & hrswrk1<=80
*keep if hrwage>=.05 & hrwage<=20

keep ln_incwage ln_hrwage educ_cat age_cat married statemx urban
compress
save mex2000_short, replace


*********************************************
***** state*urban*age*education returns *****
*********************************************

clear all
set mem 3000m
set matsize 2000
use mex2000_short, clear

drop ln_hrwage
keep if statemx==3 | statemx==5 | statemx==9 | statemx==10 | statemx==11 | statemx==14 | statemx==15 | statemx==16 | statemx==17 | statemx==19 | statemx==20 |  statemx==21 |  statemx==25 |  statemx==26 |  statemx==30 |  statemx==31
gen int educXage=(educ_cat*100)+(age_cat*10)+married
gen int stateXurban=(statemx*10)+urban

***** regressions *****

xi: reg ln_incwage i.educXage*i.stateXurban
predict ln_incwage_state_urban_hat

collapse ln_incwage_state_urban_hat, by(educ_cat age_cat married statemx urban)
save temp, replace
use temp, clear

gen ln_incwage_state_urban_=ln_incwage_state_urban_hat if educ_cat==0 & age_cat==0 & married==0 & urban==0 & statemx==31
egen ln_incwage_state_urban_base=max(ln_incwage_state_urban_)
drop ln_incwage_state_urban_ 
gen return_incwage_state_urban=ln_incwage_state_urban_hat-ln_incwage_state_urban_base
gen level_incwage_state_urban=exp(ln_incwage_state_urban_hat)
drop ln_incwage_state_urban_base 

rename statemx state
sort educ_cat age_cat married
save mex_pwages_urban_state, replace

