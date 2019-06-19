/*This file computes the mean and the variance of subjective probability distributions of asset returns*/
/*Assuming a LOGISTIC DISTRIBUTION*/

drop _all
program drop _all
set more off
set mem 300000

/*Let's start with stock returns*/

u WE_Data0
keep nq probor* anno
drop if probors11==2		/*Positive return*/
drop if probors21==2		/*Return>0.1     */
drop probors11 probors21

drop if probors2>=probors1		/*If prob(r>0)=prob(r>10), I cannot compute mean and sd assuming normality*/

replace probors1=99.9 if probors1==100	/*ATTENZIONE*/
replace probors2=0.1 if probors2==0	/*ATTENZIONE*/

gen P1=ln((1-probors1/100)/probors1/100)
gen P2=ln((1-probors2/100)/probors2/100)

gen mu_R=(0-0.1)*P1/(P2-P1)+0

/*I have a sample of households who answer both questions and report a positive prob(r>0)*/
/*For those who report prob(r>0)=0, prob(r>10)=. and */
/*I cannot compute the mean/standard deviation, because I have no questions on losses*/
sort nq
keep nq mu_R anno
sort nq
save expstocklog, replace


drop _all
/*Now let's turn to the interest rate*/
u WE_Data0
keep nq probint* anno

drop if probint11==2			/*Returns higher than today*/
drop if probint21==2			/*Returns higher than today by 1 pp*/
drop if probint2>=probint1		/*If prob(rf>0)=prob(rf>1), I cannot compute mean and sd assuming normality*/
drop probint11 probint21

sort nq
*replace probint1=100 if probint1==99 & nquest==720139
replace probint2=0.1 if probint2==0			/*ATTENZIONE*/
replace probint1=99.9 if probint1==100		/*ATTENZIONE*/

gen P1=ln((1-probint1/100)/probint1/100)
gen P2=ln((1-probint2/100)/probint2/100)

gen mu_rbnd=(0.0440-0.0540)*P1/(P2-P1)+0.0440
gen mu_rf  =(0.0173-0.0273)*P1/(P2-P1)+0.0173

sort nq
keep nq mu_* anno
sort nq
merge nq using expstocklog
*tab _merge
drop _merge
sort nq anno
save  explog, replace

/*Last I do it for house prices, using Rotaz1 from the 2010 survey*/
/*Q1: prob that prices drop; Q2: prob that prices drop by 10% or more*/

drop _all
/*Now let's turn to the interest rate*/
u WE_Data0
keep nq pc* anno
drop if pcas11==2
drop if pcas21==2
drop pcas11 pcas21

drop if pcas2>=pcas1

replace pcas2=0.1 if pcas2==0		/*ATTENZIONE*/
replace pcas1=99.9 if pcas1==100	/*ATTENZIONE*/

gen P1=ln((1-pcas1/100)/pcas1/100)
gen P2=ln((1-pcas2/100)/pcas2/100)

gen mu_H  =(0-(-0.1))*P1/(P2-P1)+0

sort nq
keep nq mu_* anno
sort nq anno
merge nq anno using explog
tab _me
drop _me
save log_expect, replace
yup
drop _all
u WE_Data1


