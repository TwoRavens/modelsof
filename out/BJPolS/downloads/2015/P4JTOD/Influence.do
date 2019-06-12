version 13.1

set more off

capture log close

log using Influence.log, replace

*   ***************************************************************** *;
*   ***************************************************************** *;
*   File-Name:   Influence.do            	                          *;
*   Date:        May 24, 2015   		                              *;
*   Authors:     Tallberg, Dellmuth, Agné, and Duit                   *;
*   Input File:  Influence.dta                                        *;
*   Output File: Influence.log     		                              *;
*   ****************************************************************  *;
*   ****************************************************************  *;

*   ****************************************************************  *;
*   This file replicates the empirical information in the paper "NGO  *;
*	Influence in International Organizations: Information, Access,    *;
*	and Exchange".				  									  *;
*   ****************************************************************  *;

*   ****************************************************************  *;
*   Code variable sample that is 1 for observations without missings  *;
*   ****************************************************************  *;

quietly reg infl str_infor str_reprviewsr access staff ///
int_cso int_cor str_newsmr str_socialr str_campaignr 

gen sample=0

replace sample=1 if e(sample)

tab sample

*   ****************************************************************  *;
*   View information about length of respondents' employment 		  *;
*   ****************************************************************  *;

tab employment if sample==1

*   ****************************************************************  *;
*   Replicate tables B1 and B2 in the appendix B		    		  *;
*   ****************************************************************  *;

*Table B1

tab staff if sample==1

*Table B2

table country if sample==1, c(freq)

*     ****************************************************************  *;
*     T-test of resource endowment										*;
*     ****************************************************************  *;

ttest staff if sample==1, by(frame)

*     ****************************************************************  *;
*     Correlation between indicators for resource endowment				*;
*     ****************************************************************  *;

corr budg staff if sample==1

*     ****************************************************************  *;
*     T-test of memberhip organizations and profit orientation			*;
*     ****************************************************************  *;

ttest infl if sample==1, by(mfees)

ttest infl if sample==1, by(profit)

*     ****************************************************************  *;
*     Operationalization	  							 		        *;
*     ****************************************************************  *;

gen infoprov = str_infor + str_reprviewsr

alpha str_infor str_reprviewsr if iogroup3==1
alpha str_infor str_reprviewsr if iogroup3==2
alpha str_infor str_reprviewsr if iogroup3==3

gen pom = str_newsmr +str_campaignr +str_socialr
tab pom

alpha str_newsmr str_campaignr str_socialr if iogroup3==1
alpha str_newsmr str_campaignr str_socialr if iogroup3==2
alpha str_newsmr str_campaignr str_socialr if iogroup3==3

*     ****************************************************************  *;
*     Replicate Appendix Tables C2 and C3								*;
*     ****************************************************************  *;

*Table C2

#delimit ; 
tabstat infl infoprov access staff int_cso int_cor pom formul 
dec impl mon com develop social hr envir health secur 
finance science if sample==1, stat(min mean max sd n) col(stat) format(%9.2f); 
#delimit cr

*Table C3

#delimit ;
logout, save(corr) word replace: 
corr infl infoprov access staff int_cso int_cor pom formul dec 
impl mon com develop social hr envir health secur finance science  
if sample==1; 
#delimit cr

*     ****************************************************************  *;
*     Replicate Table 2									 		        *;
*     ****************************************************************  *;

by iogroup3, sort: tab infl if sample==1
by iogroup3, sort: tab infoprov if sample==1
by iogroup3, sort: tab access if sample==1
by iogroup3, sort: tab staff if sample==1
by iogroup3, sort: tab int_cso if sample==1
by iogroup3, sort: tab int_cor if sample==1
by iogroup3, sort: tab pom if sample==1

*     ****************************************************************  *;
*     Replicate Table 3									 		        *;
*     ****************************************************************  *;

reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==4, robust
eststo m1

reg infl infoprov access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==4, robust
eststo m2

reg infl infoprov access staff int_cso int_cor pom com ///
develop social hr envir health secur finance science if sample==1&io==4, robust
eststo m3

#delimit ;
esttab m1 m2 m3 using table3.rtf, 
starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*     ****************************************************************  *;
*     Replicate Figure 1								 		        *;
*     ****************************************************************  *;

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom) if sample==1&io==4
estat ic

*     ****************************************************************  *;
*     Replicate Table 4									 		        *;
*     ****************************************************************  *;

reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==5, robust
eststo m4

reg infl infoprov access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==5, robust
eststo m5

reg infl infoprov access staff int_cso int_cor pom com ///
develop social hr health secur finance science if sample==1&io==5, robust
eststo m6

#delimit ;
esttab m4 m5 m6 using table4.rtf, 
starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*     ****************************************************************  *;
*     Replicate Figure 2								 		        *;
*     ****************************************************************  *;

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom) if sample==1&io==5
estat ic

*     ****************************************************************  *;
*     Replicate Table 5									 		        *;
*     ****************************************************************  *;

reg infl infoprov access staff int_cso int_cor pom i.io ///
if sample==1&iogroup3==3, robust
eststo m7

reg infl infoprov access staff int_cso int_cor pom formul ///
dec impl mon i.io if sample==1&iogroup3==3, robust
eststo m8

reg infl infoprov access staff int_cso int_cor pom com ///
develop social hr envir health secur finance science i.io ///
if sample==1&iogroup3==3, robust
eststo m9

#delimit ;
esttab m7 m8 m9 using table5.rtf, 
starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*     ****************************************************************  *;
*     Replicate Figure 3								 		        *;
*     ****************************************************************  *;

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom) ///
if sample==1&iogroup3==3

estat ic

*     ****************************************************************  *;
*     Interpret results substantively					 		        *;
*     ****************************************************************  *;

set more off
preserve
quietly estsimp reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==4, robust genname(un) 
simqi, fd(ev) changex(infoprov 0 6)
simqi, fd(ev) changex(access 0 3) 

set more off
preserve
quietly estsimp reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==5, robust genname(unep) 
simqi, fd(ev) changex(access 0 3)

set more off
preserve
quietly estsimp reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&iogroup3==3, robust genname(reg) 
simqi, fd(ev) changex(access 0 3)

*     ****************************************************************  *;
*     Replicate Appendix Table C4						 		        *;
*     ****************************************************************  *;

by iogroup3, sort: tab formul if sample==1
by iogroup3, sort: tab dec if sample==1
by iogroup3, sort: tab impl if sample==1
by iogroup3, sort: tab mon if sample==1
by iogroup3, sort: tab com if sample==1
by iogroup3, sort: tab develop if sample==1
by iogroup3, sort: tab social if sample==1
by iogroup3, sort: tab hr if sample==1
by iogroup3, sort: tab envir if sample==1
by iogroup3, sort: tab health if sample==1
by iogroup3, sort: tab secur if sample==1
by iogroup3, sort: tab finance if sample==1
by iogroup3, sort: tab science if sample==1

*     ****************************************************************  *;
*     Replicate Appendix D								 		        *;
*     ****************************************************************  *;

*Table D1
preserve
gen id=_n
svyset id [pw=dweight]
svy: reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==4
eststo m1w 

svy: reg infl infoprov access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==4
eststo m2w

svy: reg infl infoprov access staff int_cso int_cor pom   ///
com develop social hr envir health secur finance science ///
if sample==1&io==4
eststo m3w 

#delimit ;
esttab m1w m2w m3w using table-d1.rtf, 
starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D2
preserve
gen id=_n
svyset id [pw=dweight]
svy: reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==5
eststo m4w 

svy: reg infl infoprov access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==5
eststo m5w

svy: reg infl infoprov access staff int_cso int_cor pom   ///
com develop social hr health secur finance science ///
if sample==1&io==5
eststo m6w 

#delimit ;
esttab m4w m5w m6w using table-d2.rtf, 
starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D3
preserve
gen id=_n
svyset id [pw=dweight]
svy: reg infl infoprov access staff int_cso int_cor pom i.io ///
if sample==1&iogroup3==3
eststo m7w 

svy: reg infl infoprov access staff int_cso int_cor pom formul ///
dec impl mon i.io if sample==1&iogroup3==3
eststo m8w

svy: reg infl infoprov access staff int_cso int_cor pom   ///
com develop social hr health secur finance science i.io ///
if sample==1&iogroup3==3
eststo m9w 

#delimit ;
esttab m7w m8w m9w using table-d3.rtf, 
starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D4
reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
if sample==1&io==4, robust
eststo m1sep 

reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
formul dec impl mon if sample==1&io==4, robust
eststo m2sep

reg infl str_infor str_reprviewsr access staff int_cso int_cor pom   ///
com develop social hr envir health secur finance science ///
if sample==1&io==4, robust
eststo m3sep

reg infl str_infor access staff int_cso int_cor pom ///
if sample==1&io==4, robust
eststo m1sepa 

reg infl str_infor access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==4, robust
eststo m2sepa

reg infl str_infor access staff int_cso int_cor pom   ///
com develop social hr envir health secur finance science ///
if sample==1&io==4, robust
eststo m3sepa

reg infl str_reprviewsr access staff int_cso int_cor pom ///
if sample==1&io==4, robust
eststo m1sepb 

reg infl str_reprviewsr access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==4, robust
eststo m2sepb

reg infl str_reprviewsr access staff int_cso int_cor pom   ///
com develop social hr envir health secur finance science ///
if sample==1&io==4, robust
eststo m3sepb

#delimit ;
esttab m1sep m2sep m3sep m1sepa m2sepa m3sepa m1sepb m2sepb m3sepb using 
table-d4.rtf, starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D5
reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
if sample==1&io==5, robust
eststo m4sep

reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
formul dec impl mon if sample==1&io==5, robust
eststo m5sep

reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
com develop social hr health secur finance science ///
if sample==1&io==5, robust
eststo m6sep

reg infl str_infor access staff int_cso int_cor pom ///
if sample==1&io==5, robust
eststo m4sepa

reg infl str_infor access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==5, robust
eststo m5sepa

reg infl str_infor access staff int_cso int_cor pom   ///
com develop social hr health secur finance science ///
if sample==1&io==5, robust
eststo m6sepa

reg infl str_reprviewsr access staff int_cso int_cor pom ///
if sample==1&io==5, robust
eststo m4sepb

reg infl str_reprviewsr access staff int_cso int_cor pom formul ///
dec impl mon if sample==1&io==5, robust
eststo m5sepb

reg infl str_reprviewsr access staff int_cso int_cor pom ///
com develop social hr health secur finance science ///
if sample==1&io==5, robust
eststo m6sepb

#delimit ;
esttab m4sep m5sep m6sep m4sepa m5sepa m6sepa m4sepb m5sepb m6sepb using 
table-d5.rtf, starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D6
reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
i.io if sample==1&iogroup3==3, robust
eststo m7sep

reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
formul dec impl mon i.io if sample==1&iogroup3==3, robust
eststo m8sep

reg infl str_infor str_reprviewsr access staff int_cso int_cor pom ///
com develop social hr envir health secur finance science i.io ///
if sample==1&iogroup3==3, robust
eststo m9sep

reg infl str_infor access staff int_cso int_cor pom i.io ///
if sample==1&iogroup3==3, robust
eststo m7sepa

reg infl str_infor access staff int_cso int_cor pom formul ///
dec impl mon i.io if sample==1&iogroup3==3, robust
eststo m8sepa

reg infl str_infor access staff int_cso int_cor pom   ///
com develop social hr envir health secur finance science i.io ///
if sample==1&iogroup3==3, robust
eststo m9sepa

reg infl str_reprviewsr access staff int_cso int_cor pom i.io ///
if sample==1&iogroup3==3, robust
eststo m7sepb

reg infl str_reprviewsr access staff int_cso int_cor pom formul ///
dec impl mon i.io if sample==1&iogroup3==3, robust
eststo m8sepb

reg infl str_reprviewsr access staff int_cso int_cor pom   ///
com develop social hr envir health secur finance science i.io ///
if sample==1&iogroup3==3, robust
eststo m9sepb

#delimit ;
esttab m7sep m8sep m9sep m7sepa m8sepa m9sepa m7sepb m8sepb m9sepb using 
table-d6.rtf, starlevels(* .10 ** .05 *** .01) b(%9.2f)  r2(%9.2f)
se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D7

preserve
gen id=_n
mi set wide
mi register imputed infl infoprov int_cso int_cor pom com health ///
secur finance science
mi svyset id [pweight = dweight], strata(frame)
noisily mi impute chain (regress) infl  (regress)  infoprov  (regress) ///  
int_cso  (regress)  int_cor (regress) pom  (logit) com (logit) ///
health (logit) secur (logit)  finance (logit) science = access staff ///
formul dec impl mon develop social hr envir, ///
rseed(123456) add(5) force

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
if io==4, robust

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
formul dec impl mon if io==4, robust

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
com develop social hr envir health secur finance science ///
if io==4, robust

*Table D8

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
if io==5, robust

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
formul dec impl mon if io==5, robust

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
com develop social hr health secur finance science ///
if io==5, robust

*Table D9

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
if iogroup3==3, robust

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
formul dec impl mon if iogroup3==3, robust

mi estimate:reg infl infoprov access staff int_cso int_cor pom ///
com develop social hr envir health secur finance science ///
if iogroup3==3, robust

*D10

mark nomiss 
markout nomiss infl infoprov access staff int_cso int_cor pom ///
formul dec impl mon com develop social hr envir health ///
secur finance science
tab nomiss

*Detect percentage of missing values 
misschk infl infoprov access staff int_cso int_cor pom ///
formul dec impl mon com develop social hr envir health ///
secur finance science 

*Check MAR
logit nomiss infl infoprov int_cso int_cor pom ///
  com health secur finance science
eststo logit 
esttab logit using logit.rtf, starlevels(* .10 ** .05 *** .01) ///
b(%9.2f)  ar2(%9.2f) se(%9.2f) bic scalars(ll N) nodepvars  replace

*Table D11

gen infoprovxstaff=infoprov*staff
gen accessxstaff=access*staff
gen infoprovxaccess=infoprov*access

set more off
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff ///
if sample==1&io==4, robust
eststo model1
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff ///
formul dec impl mon if sample==1&io==4, robust
eststo model2
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff ///
com develop social hr envir health secur finance science ///
if sample==1&io==4, robust
eststo model3
reg infl infoprov access staff int_cso int_cor pom accessxstaff ///
if sample==1&io==4, robust
eststo model1a
reg infl infoprov access staff int_cso int_cor pom accessxstaff ///
formul dec impl mon if sample==1&io==4, robust
eststo model2a
reg infl infoprov access staff int_cso int_cor pom accessxstaff ///
com develop social hr envir health secur finance science ///
if sample==1&io==4, robust
eststo model3a
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess ///
if sample==1&io==4, robust
eststo model1b
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess ///
formul dec impl mon if sample==1&io==4, robust
eststo model2b
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess ///
com develop social hr envir health secur finance science ///
if sample==1&io==4, robust
eststo model3b

#delimit ;
esttab model1 model2 model3 model1a model2a model3a model1b model2b model3b ///
using d-11.rtf, starlevels(* .10 ** .05 *** .01) ///
b(%9.2f)  ar2(%9.2f) se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D12

set more off
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff ///
if sample==1&io==5, robust
eststo model1
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff ///
formul dec impl mon if sample==1&io==5, robust
eststo model2
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff ///
com develop social hr   health secur finance science ///
if sample==1&io==5, robust
eststo model3
reg infl infoprov access staff int_cso int_cor pom accessxstaff ///
if sample==1&io==5, robust
eststo model1a
reg infl infoprov access staff int_cso int_cor pom accessxstaff ///
formul dec impl mon if sample==1&io==5, robust
eststo model2a
reg infl infoprov access staff int_cso int_cor pom accessxstaff ///
com develop social hr   health secur finance science ///
if sample==1&io==5, robust
eststo model3a
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess ///
if sample==1&io==5, robust
eststo model1b
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess ///
formul dec impl mon if sample==1&io==5, robust
eststo model2b
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess ///
com develop social hr   health secur finance science ///
if sample==1&io==5, robust
eststo model3b

#delimit ;
esttab model1 model2 model3 model1a model2a model3a model1b model2b model3b ///
using d-12.rtf, starlevels(* .10 ** .05 *** .01) ///
b(%9.2f)  ar2(%9.2f) se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*Table D13

set more off
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff i.io ///
if sample==1&iogroup3==3, robust
eststo model1
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff i.io  ///
formul dec impl mon if sample==1&iogroup3==3, robust
eststo model2
reg infl infoprov access staff int_cso int_cor pom infoprovxstaff i.io  ///
com develop social hr envir  health secur finance science ///
if sample==1&iogroup3==3, robust
eststo model3
reg infl infoprov access staff int_cso int_cor pom accessxstaff  i.io ///
if sample==1&iogroup3==3, robust
eststo model1a
reg infl infoprov access staff int_cso int_cor pom accessxstaff  i.io ///
formul dec impl mon if sample==1&iogroup3==3, robust
eststo model2a
reg infl infoprov access staff int_cso int_cor pom accessxstaff  i.io ///
com develop social hr envir  health secur finance science ///
if sample==1&iogroup3==3, robust
eststo model3a
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess i.io  ///
if sample==1&iogroup3==3, robust
eststo model1b
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess i.io  ///
formul dec impl mon if sample==1&iogroup3==3, robust
eststo model2b
reg infl infoprov access staff int_cso int_cor pom infoprovxaccess i.io  ///
com develop social hr envir  health secur finance science ///
if sample==1&iogroup3==3, robust
eststo model3b

#delimit ;
esttab model1 model2 model3 model1a model2a model3a model1b model2b model3b ///
using d-13.rtf, starlevels(* .10 ** .05 *** .01) ///
b(%9.2f)  ar2(%9.2f) se(%9.2f) bic scalars(ll N) nodepvars  replace;
#delimit cr

*     ****************************************************************  *;
*     Replicate Appendix E								 		        *;
*     ****************************************************************  *;

*SEM UN

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom ///
formul dec impl mon) if sample==1&io==4
estat ic 

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom ///
com develop social hr envir health secur finance science) if sample==1&io==4
estat ic

*SEM UNEP

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom ///
formul dec impl mon) if sample==1&io==5
estat ic

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom ///
com develop social hr health secur finance science) if sample==1&io==5
estat ic

*SEM regional

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom ///
formul dec impl mon) if sample==1&iogroup3==3
estat ic

gsem (access <- infoprov staff, ologit) ///
(infl<-access infoprov staff int_cso int_cor pom ///
com develop social hr health secur finance science) if sample==1&iogroup3==3
estat ic

*     ****************************************************************  *;
*     Replicate Appendix F								 		        *;
*     ****************************************************************  *;

set more off
preserve
quietly estsimp reg infl infoprov access staff int_cso int_cor pom ///
if sample==1&io==4, robust genname(un)
*setx (staff) max  (opport_new) min
setx mean
plotfds,  discrete(access int_cor) continuous(infoprov pom)
*change in expected value of influence, caused by changes in infoprov and access
simqi, fd(ev) changex(infoprov 0 6)
simqi, fd(ev) changex(access 0 3)
simqi, fd(ev) changex(access 0 3)



capture log close
exit
