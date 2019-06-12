*******************
*Do-file creating the tables in
*"A Field Experiment in Motivating Employee Ideas"
*by Michael Gibbs, Susanne Neckermann, and Christoph Siemroth, 2016
*******************

******************
**** Table 1: DESCRIPTIVE STATISTICS OF EXPLANATORY VARIABLES
*****************
use person-inactive-expost.dta, clear
eststo clear
drop if pilot==.
gen indx=1
replace indx=2 if pilot==0

bysort indx: egen authorsp1=count(empcode!=.) if phase==0 //count the number of authors
bysort indx: egen authorsp2=count(empcode!=.) if phase==1 //count the number of authors
bysort indx: egen authorsp3=count(empcode!=.) if phase==2 //count the number of authors


foreach var of varlist age tenure male salary creative {
gen `var'p1=.
replace `var'p1=`var' if phase==0
gen `var'p2=.
replace `var'p2=`var' if phase==1
gen `var'p3=.
replace `var'p3=`var' if phase==2
}

estpost3 ttest authorsp1 authorsp2 authorsp3 agep1 agep2 agep3 tenurep1 tenurep2 tenurep3 malep1 malep2 malep3 salaryp1 salaryp2 salaryp3 creativep1 creativep2 creativep3, by(pilot) cluster(custcode) //ttest with clustering

	#delimit ;
esttab using "$dir\tabs\1_balancetable2.tex", nomtitle nonumbers noobs  starlevels(* .10 ** 0.05 *** .01) 
varlabels(authorsp1 "Number of Employees Period 1" authorsp2 "Number of Employees Period 2" authorsp3 "Number of Employees Period 3" agep1 "Mean Age Period 1" agep2 "Mean Age Period 2" agep3 "Mean Age Period 3" 
tenurep1 "Mean Tenure Period 1" tenurep2 "Mean Tenure Period 2" tenurep3 "Mean Tenure Period 3" malep1 "Share of Men Period 1" malep2 "Share of Men Period 2" malep3 "Share of Men Period 3" 
salaryp1 "Mean Salary Group Period 1" salaryp2 "Mean Salary Group Period 2" salaryp3 "Mean Salary Group Period 3" 
creativep1 "Share of Prior Ideators in Period 1" creativep2 "Share of Prior Ideators in Period 2" creativep3 "Share of Prior Ideators in Period 3")collabels("Treatment Group" "Control Group" "Combined")
cells("mu_1(fmt(a2) star pvalue(p)) mu_2(fmt(a2)) mean(fmt(a2))" "sd_1(fmt(2)par) sd_2(fmt(2)par) sd(fmt(2)par)")
title(Descriptive statistics) booktabs gaps replace
postfoot("\bottomrule" "\end{tabular}" "\\ [2mm] \begin{minipage}{0.83\textwidth}" 
	"\footnotesize" "{\it Note:} 
	
	Standard deviations of the means are displayed in parentheses. In each line, the difference of group means is tested           with a t-test using standard errors that are clustered at client team level. ***Significant at the 1\% level; **significant at the 5\% level; *significant at the 10\% level.    \textit{Number of employees} in period 1 (pre-treatment) is based on employment roster 1; 
	\textit{Number of employees} in period 2 (treatment) is based on rosters 1 and 2; \textit{Number of employees} in period 3 (post-treatment) is based on roster 2. \textit{Age} and \textit{tenure} are measured          at the end of the respective period.         
	" "\end{minipage}" 
	"\end{table}")
;
#delimit cr


******************
**** Table 2: SUMMARY STATISTICS OF OUTCOME VARIABLES
*****************
use person-inactive.dta, clear
eststo clear
drop if pilot==.
gen index=1
replace index=2 if pilot==1&period2==1
replace index=3 if pilot==0&period2==0
replace index=4 if pilot==0&period2==1

bysort custcode period: gen num=_n
bysort index: egen sumofideas=sum(amountideas) //compute sum of ideas
pooledvar active, by1(custcode period2) by2(pilot period2) //compute mean of means and pooled standard deviation

eststo: estpost tabstat index, listwise statistics(mean) columns(statistics) casewise nototal by(index)
eststo: estpost tabstat sumofideas, listwise statistics(mean) columns(statistics) casewise nototal by(index)
eststo: estpost tabstat activemeanofmean if num==1, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //active, mean of means Ideator (=active employee)
eststo: estpost tabstat activepooledsd if num==1, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //active, pooled sd Ideator


use idealevel.dta, clear //each observation is an author-idea
duplicates drop ideaid, force //now each observation is one idea
gen index=1 //treatment period 1 (pre-treatment period)
replace index=2 if pilot==1&period2==1 //treatment period 2 (treatment period)
replace index=3 if pilot==0&period2==0 //control period 1
replace index=4 if pilot==0&period2==1 //control period 2

bysort custcode period finished: gen num=_n
gen implementedfin=implemented
replace implementedfin=. if finished==0
gen sharedfin=shared*finished
replace sharedfin=. if finished==0
pooledvar implementedfin, by1(custcode period2) by2(pilot period2) //compute mean of means and pooled standard deviation
pooledvar sharedfin, by1(custcode period2) by2(pilot period2) //compute mean of means and pooled standard deviation

eststo: estpost tabstat NumAuthors, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //Authors (number of authors per idea)
eststo: estpost tabstat finished, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //Finished (indicator whether idea is finished)
eststo: estpost tabstat implementedfinmeanofmean if num==1, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //mean of means Imp|Fin
eststo: estpost tabstat implementedfinpooledsd if num==1, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //pooled sd Imp|Fin
eststo: estpost tabstat sharedfinmeanofmean if num==1, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //mean of means Shared|Fin
eststo: estpost tabstat sharedfinpooledsd if num==1, listwise statistics(mean sd) columns(statistics) casewise nototal by(index) //pooled sd Shared|Fin
eststo: estpost tabstat lognetgain, listwise statistics(mean sd) columns(statistics) casewise nototal by(index)
*some manual editing is required to get these numbers into the table of the paper


*******************************
* TABLE 3: WHO IDEATES?
*******************************
use person-inactive.dta, clear
global a c.age##c.age c.tenure##c.tenure i.male i.salary01 i.salary2 i.salary3
global c age tenure male salary01 salary2 salary3

eststo clear
logit active $a  customer1-customer19 if period2==0, cluster(custcode)
eststo: estpost margins, dydx($c)
zinb amountideasnoweight $a   customer1-customer19 if period2==0, inflate($a customer1-customer19) cluster(custcode)
eststo: estpost margins, dydx($c)
xtpoisson amountideasnoweight $a  if period2==0, fe i(custcode) vce(robust) //quasi maximum likelihood poisson (robust sandwich estimator for SE)
eststo: estpost margins, dydx($c)



	#delimit ;
	esttab using "$dir\tabs\3_who-ideates.tex", 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f) )) starlevels(* .10 ** 0.05 *** .01) 
	stats(ll N_clust N, fmt(%9.2f %9.0f %9.0f) labels("Log Pseudo likelihood" Clusters Observations))
	keep(age  tenure  1.male  1.salary01 1.salary2 1.salary3) 
	order(NumAuthors age agesquare tenure tenuresquare 1.male 1.experience 1.salary01 1.salary2 1.salary3 period2)
	varlabels(age Age NumAuthors "Number of Authors" agesquare Age$^2$ tenure Tenure tenuresquare Tenure$^2$ 1.male Male logcost "Log(Cost)" logprojectedvalue "Log(Value)" 1.experience "Submitted Idea Previously"
	1.salary01 "Salary Groups 0 \& 1 pooled" 1.salary3 "Salary Group 3" 1.salary2 "Salary Group 2",
	elist(NumAuthors "[2mm]" age "[2mm]" agesquare "[2mm]" tenure "[2mm]" tenuresquare "[2mm]" 1.male "[2mm]" logprojectedvalue "[2mm]" logcost "[2mm]" 1.experience  "[2mm]" 1.salary01 "[2mm]" 1.salary2 "[2mm]" 1.salary3  "\midrule  
	 Client FE  &yes & yes &yes   \\ " )) 
	 nonumbers collabels(,none) mlabels("\specialcell{(1) Logit  AME \\}"  
	"\specialcell{(2)  ZINB AME \\}" "\specialcell{(3) QML Poisson AME \\}") 
	prehead("\begin{table}[h]%" "\small" "\caption{Who ideates? Influence of employee characteristics on ideation}%" 
	"\begin{center}%" "\begin{tabular}{lccc}" 
	"\toprule") posthead("[3mm] Dependent variable &  Ideator & Number of Ideas & Number of Ideas \\" "\midrule")  prefoot("") 
	postfoot("\bottomrule" "\end{tabular}" "\\ [2mm] \begin{minipage}{\textwidth}" 
	"\footnotesize" "{\it Note:} 
	
	The regressions use data from the pre-treatment period only, where both groups have identical incentives.   
	\textit{Ideator} is a dummy indicating whether an employee submitted at least one idea in the given period.      
	\textit{Number of Ideas} is the number of ideas submitted within the 13  pre-treatment months.       
	\textit{Salary group} is an indicator for an employee's position in the company          hierarchy.   
	The reference category is (upper) management, that is, salary groups 4 and above. The marginal effects          
	of \textit{Age} and \textit{Tenure} are based on linear and quadratic terms. Standard errors are clustered at the client          
	team level.          ***Significant at the 1\% level; **significant at the 5\% level; *significant at the 10\% level.                           
	
	" "\end{minipage}" 
	"\end{center}" "\end{table}") style(tex) replace
;
#delimit cr


********************************
**** Table 4: IDEA QUANTITY
*********************************
*Marginal effect of interaction is computed manually, because ZINB model is nonlinear, see
*Norton & Ai (2003): Interaction terms in logit and probit models, Economics Letters.

*1. average marginal effect logit: switch on and off both dummy of treatment and creativetreatmentper2 (effect on prior ideators)
use person-inactive.dta, clear
gen creativeperiod2=creative*period2
gen creativetreatment=creative*pilot
global b i.treatmentper2 i.creativetreatmentper2 creative period2 creativeperiod2 creativetreatment c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
drop if e(sample)!=1
transform
replace treatmentper2=1
replace creativetreatmentper2=1
predict double withtreat
predict double withtreatlin, xb
replace treatmentper2=0
replace creativetreatmentper2=0
predict double withouttreat
predict double withouttreatlin, xb
gen me=withtreat-withouttreat
sum me //average marginal effect; treatment effect on prior ideators
scalar numvar=(e(k)-1)/2
mat diff = J(numvar, 1, .)
local index=1
foreach varname of varlist treatmentper2 treatmentper2 creativetreatmentper2 creativetreatmentper2 creative period2 creativeperiod2 creativetreatment age agesquare tenure tenuresquare male male salary01 salary2 salary3 salary4plus salaryother customer1-customer18 {
if `index'==2|`index'==4 {
	//switch on and off
	gen differential`index'=1*exp(withtreatlin)/(1+exp(withtreatlin))^2-0*exp(withouttreatlin)/(1+exp(withouttreatlin))^2
}
else if `index'==1|`index'==3|`index'==13 {
	gen differential`index'=0
}
else {
	gen differential`index'=`varname'*exp(withtreatlin)/(1+exp(withtreatlin))^2-`varname'*exp(withouttreatlin)/(1+exp(withouttreatlin))^2
}
quietly sum differential`index'
mat diff[`index',1]=r(mean)
local index=`index'+1
}
mat AVAR=diff'*e(V)*diff
disp sqrt(AVAR[1,1]) //standard error of treatment effect (delta method)


*2. average marginal effect logit: switch on and off only treatment (effect on rest)
use person-inactive.dta, clear
gen creativeperiod2=creative*period2
gen creativetreatment=creative*pilot
global b i.treatmentper2 i.creativetreatmentper2 creative period2 creativeperiod2 creativetreatment c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
drop if e(sample)!=1
transform
replace treatmentper2=1
replace creativetreatmentper2=0
predict double withtreat
predict double withtreatlin, xb
replace treatmentper2=0
predict double withouttreat
predict double withouttreatlin, xb
gen me=withtreat-withouttreat
sum me //treatment effect on all but prior ideators
scalar numvar=(e(k)-1)/2
mat diff = J(numvar, 1, .)
local index=1
foreach varname of varlist treatmentper2 treatmentper2 creativetreatmentper2 creativetreatmentper2 creative period2 creativeperiod2 creativetreatment age agesquare tenure tenuresquare male male salary01 salary2 salary3 salary4plus salaryother customer1-customer18 {
if `index'==2 {
	//switch on and off
	gen differential`index'=1*exp(withtreatlin)/(1+exp(withtreatlin))^2-0*exp(withouttreatlin)/(1+exp(withouttreatlin))^2
}
else if `index'==1|`index'==3|`index'==13 {
	gen differential`index'=0
}
else {
	gen differential`index'=`varname'*exp(withtreatlin)/(1+exp(withtreatlin))^2-`varname'*exp(withouttreatlin)/(1+exp(withouttreatlin))^2
}
quietly sum differential`index'
mat diff[`index',1]=r(mean)
local index=`index'+1
}
mat AVAR=diff'*e(V)*diff
disp sqrt(AVAR[1,1]) //SE of treatment effect


*3. average marginal effect NB: switch on and off only treatment (effect on rest)
use person-inactive.dta, clear
gen creativeperiod2=creative*period2
gen creativetreatment=creative*pilot
global b i.treatmentper2 i.creativetreatmentper2 creative period2 creativeperiod2 creativetreatment c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
drop if e(sample)!=1
transform2
replace treatmentper2=1
replace creativetreatmentper2=0
predict double withtreat
predict double withtreatlin, xb
replace treatmentper2=0
predict double withouttreat
predict double withouttreatlin, xb
gen me=withtreat-withouttreat
sum me //treatment effect on all but prior ideators
scalar numvar=(e(k)-1)/2
mat diff = J(numvar, 1, .)
local index=1
foreach varname of varlist treatmentper2 treatmentper2 creativetreatmentper2 creativetreatmentper2 creative period2 creativeperiod2 creativetreatment age agesquare tenure tenuresquare male male salary01 salary2 salary3 salary4plus salaryother customer1-customer18 {
if `index'==2 {
	//switch on and off
	gen differential`index'=1*exp(withtreatlin)-0*exp(withouttreatlin)
}
else if `index'==1|`index'==3|`index'==13 {
	gen differential`index'=0
}
else {
	gen differential`index'=`varname'*exp(withtreatlin)-`varname'*exp(withouttreatlin)
}
quietly sum differential`index'
mat diff[`index',1]=r(mean)
local index=`index'+1
}
mat AVAR=diff'*e(V)*diff
disp sqrt(AVAR[1,1]) //SE


*4. average marginal effect NB: switch on and off both dummy of treatment and creativetreatmentper2 (effect on prior ideators)
use person-inactive.dta, clear
gen creativeperiod2=creative*period2
gen creativetreatment=creative*pilot
global b i.treatmentper2 i.creativetreatmentper2 creative period2 creativeperiod2 creativetreatment c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
drop if e(sample)!=1
transform2
replace treatmentper2=1
replace creativetreatmentper2=1
predict double withtreat
predict double withtreatlin, xb
replace treatmentper2=0
replace creativetreatmentper2=0
predict double withouttreat
predict double withouttreatlin, xb
gen me=withtreat-withouttreat
sum me //treatment effect
scalar numvar=(e(k)-1)/2
mat diff = J(numvar, 1, .)
local index=1
foreach varname of varlist treatmentper2 treatmentper2 creativetreatmentper2 creativetreatmentper2 creative period2 creativeperiod2 creativetreatment age agesquare tenure tenuresquare male male salary01 salary2 salary3 salary4plus salaryother customer1-customer18 {
if `index'==2|`index'==4 {
	//switch on and off
	gen differential`index'=1*exp(withtreatlin)-0*exp(withouttreatlin)
}
else if `index'==1|`index'==3|`index'==13 {
	gen differential`index'=0
}
else {
	gen differential`index'=`varname'*exp(withtreatlin)-`varname'*exp(withouttreatlin)
}
quietly sum differential`index'
mat diff[`index',1]=r(mean)
local index=`index'+1
}
mat AVAR=diff'*e(V)*diff
disp sqrt(AVAR[1,1]) //SE of treatment effect


*5. OVERALL ME/TREATMENT EFFECT (number of ideas)
use person-inactive.dta, clear
gen creativeperiod2=creative*period2
gen creativetreatment=creative*pilot
global b i.treatmentper2 i.creativetreatmentper2 creative period2 creativeperiod2 creativetreatment c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
drop if e(sample)!=1
replace treatmentper2=1
replace creativetreatmentper2=0
predict double withtreat
replace treatmentper2=0
predict double withouttreat
gen me=withtreat-withouttreat
sum me


use person-inactive.dta, clear
gen creativeperiod2=creative*period2
gen creativetreatment=creative*pilot
global b i.treatmentper2 i.creativetreatmentper2 creative period2 creativeperiod2 creativetreatment c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
global d treatmentper2 creativetreatmentper2 age tenure male
global a i.treatmentper2 period2 c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
global c treatmentper2 age tenure male

	eststo clear
zinb amountideasnoweight $a  customer1-customer18,  inflate($a  customer1-customer18, noconst) noconstant cluster(custcode)
transform
eststo: estpost margins, dydx($c)
zinb amountideasnoweight $a  customer1-customer18,  inflate($a  customer1-customer18, noconst) noconstant cluster(custcode)
transform2
eststo: estpost margins, dydx($c)
zinb amountideasnoweight $a  customer1-customer18,  inflate($a  customer1-customer18, noconst) noconstant cluster(custcode)
eststo: estpost margins, dydx($c)
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
transform
eststo: estpost margins, dydx($d)
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
transform2
eststo: estpost margins, dydx($d)
*Replace treatment effect estimates and SEs with estimates from 1.-4.
zinb amountideasnoweight $b  customer1-customer18,  inflate($b  customer1-customer18, noconst) noconstant cluster(custcode)
eststo: estpost margins, dydx($d)
*Replace treatment effect estimates and SEs with estimates from 1.-4.


**************************************
* TABLE 5: IDEA QUALITY
**************************************
use idealevel.dta, clear
global a i.treatmentper2 NumAuthors c.age2##c.age2 c.tenure2##c.tenure2 i.male salary01 salary2 salary3 salary4plus
global aa i.treatmentper2 NumAuthors  ideasubtype1-ideasubtype5 c.age2##c.age2 c.tenure2##c.tenure2 i.male salary01 salary2 salary3 salary4plus
global x i.treatmentper2  NumAuthors ideasubtype1-ideasubtype5 c.age2##c.age2 c.tenure2##c.tenure2 i.male salary01 salary2 salary3
global b i.treatmentper2 NumAuthors period2  ideasubtype1-ideasubtype5 age2 age2square tenure2 tenure2square i.male salary01 salary2 salary3 salary4plus
global bb i.treatmentper2 NumAuthors ideasubtype1-ideasubtype5 age2 age2square tenure2 tenure2square i.male salary01 salary2 salary3 salary4plus
global c treatmentper2  NumAuthors c.age2 c.tenure2 male

	eststo clear
eststo: reg shared $bb customer1-customer19 month1-month26 [pweight=1/NumAuthors] if finished==1, noconstant vce(cluster custcode)
logit shared $aa customer1-customer19 month1-month26 [pweight=1/NumAuthors] if finished==1, noconstant vce(cluster custcode)
eststo: estpost margins, dydx($c)
eststo: reg implemented $bb customer1-customer19 month1-month26 [pweight=1/NumAuthors] if finished==1, noconstant vce(cluster custcode)
logit implemented $x customer1-customer18 month1-month25 [pweight=1/NumAuthors] if finished==1, noconstant vce(cluster custcode)
eststo: estpost margins, dydx($c)
eststo: reg lognetgain $bb customer1-customer19 month1-month26 [pweight=1/NumAuthors], noconstant  vce(cluster custcode)


 	#delimit ;
	esttab using "$dir\tabs\5_Ideaquality.tex", 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f) )) starlevels(* .10 ** 0.05 *** .01) 
	stats(r2 ll N_clust N, fmt(%9.3f %9.2f %9.0f %9.0f) labels(R$^2$ Log Pseudo likelihood Clusters Observations))
	keep( 1.treatmentper2 NumAuthors  age2 tenure2 age2square tenure2square 1.male)
	order( 1.treatmentper2 NumAuthors  age2 age2square tenure2 tenure2square 1.male)
	varlabels(1.treatmentper2 "DID Treatment" NumAuthors "Number of Authors" age2 Age tenure2 Tenure age2square "Age$^2$" tenure2square "Tenure$^2$" 1.male Male, 
	elist(1.treatmentper2 "[2mm]" NumAuthors "[2mm]" age2 "[2mm]" age2square "[2mm]" tenure2 "[2mm]" tenure2square "[2mm]" 1.male 
	  "\midrule Controls salary groups  &yes& yes& yes& yes & yes\\ 
	 Controls project type  &yes& yes& yes& yes & yes \\ Client FE  &yes& yes& yes& yes& yes\\
	 Time FE & month & month & month & month & month  \\"
	)) 	nonumbers collabels(,none) mlabels("(1) OLS"  "(2) Logit AME" "(3) OLS" "(4) Logit AME" "(5) OLS") 
	prehead("\begin{table}[h]%"  "\small"  "\caption{\label{tab:quality}Treatment effects on various idea quality measures}%" 
	"\begin{center}%" "\begin{tabular}{lccccc}" 
	"\toprule") posthead("[3mm] Dependent variable & Shared & Shared &Implemented & Implemented & Log(Net Value) \\" "\midrule")  prefoot("") 
	postfoot("\bottomrule" "\end{tabular}" "\\ [2mm] \begin{minipage}{\textwidth}" 
	"\footnotesize" "{\it Note:} 
	
The table reports estimates of OLS and logistic regressions using as outcome variables  the probability that an idea is shared   
with the customer (columns 1 and 2), the probability that an idea is accepted for implementation (columns 3 and 4), and the 
logarithm of the projected net value (profit from the idea) (column 5). The treatment effect is the difference-in-differences 
estimator. The unit of observation is the author-idea. Each observation is weighted by 1/(\textit{Number of Authors}), where 
\textit{Number of Authors} represents the number of employees who submit the idea together. Only ideas with finished review 
process (either accepted or rejected) are included in the samples for columns (1) to (4). Marginal effects of \textit{Age} and 
\textit{Tenure} are based on linear and quadratic terms.          Standard errors are clustered at the client team level.          
 ***Significant at the 1\% level; **significant at the 5\% level; *significant at the 10\% level. 
	
	" "\end{minipage}" 
	"\end{center}" "\end{table}") style(tex) replace
;
#delimit cr


*************************************
* TABLE 6: POST TREATMENT EFFECTS
************************************
*ONE TABLE FOR POST EFFECTS FOR BOTH QUALITY AND QUANTITY
use person-inactive-expost.dta, clear
global a i.treatmentper2 i.treatmentper3 period2 period3 c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus salaryother
global c treatmentper2 treatmentper3 age tenure male

	eststo clear
zinb amountideasnoweight $a  customer1-customer18,  inflate($a  customer1-customer18, noconst) noconstant cluster(custcode)
transform
eststo: estpost margins, dydx($c)
zinb amountideasnoweight $a  customer1-customer18,  inflate($a  customer1-customer18, noconst) noconstant cluster(custcode)
transform2
eststo: estpost margins, dydx($c)
zinb amountideasnoweight $a  customer1-customer18,  inflate($a  customer1-customer18, noconst) noconstant cluster(custcode)
eststo: estpost margins, dydx($c)

use idealevel-expost.dta, clear
gen shared=(sharewithcustomer=="YES")
drop age tenure
rename age2 age
rename tenure2 tenure
global b i.treatmentper2 i.treatmentper3  ideasubtype1-ideasubtype5 c.age##c.age c.tenure##c.tenure i.male salary01 salary2 salary3 salary4plus
global d treatmentper2 treatmentper3  c.age c.tenure male
logit shared $b customer1-customer19 month1-month39 [pweight=1/NumAuthors] if finished==1, noconstant vce(cluster custcode)
eststo: estpost margins, dydx($d)


	#delimit ;
	esttab using "$dir\tabs\6_Post-treatment-effects.tex", 
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f) )) starlevels(* .10 ** 0.05 *** .01) 
	stats(ll N_clust N, fmt(%9.2f %9.0f %9.0f) labels(Log Pseudo likelihood Clusters Observations))
	keep( 1.treatmentper2 1.treatmentper3 age tenure 1.male) 
	order(1.treatmentper2 1.treatmentper3 age tenure 1.male)
	varlabels(1.treatmentper2 "DID Treatment" 1.treatmentper3 "DID Post Treatment" age Age tenure Tenure 1.male Male NumAuthors "Number of Authors", 
	elist(1.treatmentper2 "[2mm]" 1.treatmentper3 "[2mm]" age "[2mm]" tenure "[2mm]" 1.male 
	 "\midrule  Controls salary groups  &yes & yes & yes &yes   \\ 
	 Client FE  &yes & yes & yes &yes   \\ Time FE  &period & period & period &month   \\ " )) 
	 nonumbers collabels(,none) mlabels("\specialcell{(1) Zero Inflated NB\\ Logit AME}"  
	"\specialcell{(2) Zero Inflated NB\\ Negative Binomial AME}" "\specialcell{(3) Quantity effect\\ ZINB AME}" "\specialcell{(4) Quality\\ Logit AME}") 
	prehead("\begin{table}[h]%" "\small" "\caption{\label{tab:quantall-inflated-expost}Idea quantity and quality, treatment and post treatment effects}%" 
	"\begin{center}%" "\begin{tabular}{lcccc}" 
	"\toprule") posthead("[3mm] Dependent variable &  Pr(Participation) & NumIdeas$|$Participation & NumIdeas & Shared \\" "\midrule")  prefoot("") 
	postfoot("\bottomrule" "\end{tabular}" "\\ [2mm] \begin{minipage}{\textwidth}" 
	"\footnotesize" "{\it Note:} 
	
	The table reports marginal effects for a zero inflated negative binomial model          
	explaining the number of ideas per author and period, and for a Logit model explaining the 
	probability of sharing an idea with the client.          Marginal effects of \textit{Age} and 
\textit{Tenure} are based on linear and quadratic terms. Standard errors are clustered at the client team level. ***Significant at the 1\% level; **significant at the 5\% level; *significant at the 10\% level.         
	
	" "\end{minipage}" 
	"\end{center}" "\end{table}") style(tex) replace
;
#delimit cr
