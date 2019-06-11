** Does political sophistication minimize value conflict? Evidence from climate change
** 6/6/2016
** Paul Kellstedt, Mark D. Ramirez, Arnold Vedlizt, and Sammy Zahran
** Estimation of HGIRT

set more off, permanently

** increase memory
set mem 10g** load data log using "/Users/markramirez/Public/Dropbox/NOAA STUDY KRVZ/Data/BJPS Replication Files/BJPS_logfile.smcl", append
use "/Users/markramirez/Public/Dropbox/NOAA STUDY KRVZ/Data/BJPS Replication Files/noaasammy.dta"
********************************************************///* DEMOGRAPHIC VARIABLES AND POLITICAL ORIENTATION*///********************************************************
** generate id variable 
gen id = _n
/*RACE*//*white = 1 non-white = 0 *//*Lose 37 cases */rename q119fin1 racerecode race 1=0 2=1 3=0 4=0 5=0 100=0 101=0 102=0 103=0
label drop q119fin1
label define q119fin1 0 "non-white" 1 "white"
tab race/*EDUCATION*//*Less than high school = 0 Post-Graduate = 1*/rename q116 educationrecode education 3=2 4=3 5=4 6=5
label drop q116label define q116 1 "some high school"2 "high school/vocational" 3 "some college"  4 "college" 5 "post-graduate" 
codebook education /*INCOME*//*Lose 244 cases*/rename q122 income/*AGE*//*Ranges from 18 to 90*//*Lose 32 cases*/rename q117 age/*RELIGIOUS ATTENDANCE*//* Attendend = 1 Not attend = 0*//* lose 16 cases*/rename q124 attendancerecode attendance 2=0/*IDEOLOGY*//* Lose 134 cases*/rename q118 ideo/*PARTISANSHIP*//* Lose 46 cases*/rename q114 pid

** recode democrat = 1 republican = -1
recode pid 2 = 0 3 = 1 1 = 2 8 = 1 9 = 1 
label drop q114
label define q114 0 "republican" 1 "independent/else" 2 "democrat"  
codebook pid 
/*EFFICACY*//*Higher values are associated with lower efficacy*//*Lose 102 cases*/cor q71 q73 q74factor q71 q73 q74alpha q71 q73 q74, detail gen (efficacy)
/*RISK PERCEPTIONS*//*Higher values are associated with higher risk perception */ recode q101 4 = 1 3 = .67 2 = .33 1 = 0recode q102 4 = 1 3 = .67 2 = .33 1 = 0recode q103 4 = 1 3 = .67 2 = .33 1 = 0factor q101 q102 q103 alpha q101 q102 q103, detail gen (risk)  /*NETWORK INTEREST*//*Higher values associated with greater network interest*/recode q81 4 = 1 3 = .67 2 = .33 1 = 0recode q82 4 = 1 3 = .67 2 = .33 1 = 0factor q81 q82 q83 q85alpha q81 q82 q83 q85, detail gen (network)


** create ideological strength 
gen strength_ideo = 0 
recode strength_ideo 0 = 3 if ideo == 1
recode strength_ideo 0 = 3 if ideo == 7
recode strength_ideo 0 = 2 if ideo == 6
recode strength_ideo 0 = 2 if ideo == 2
recode strength_ideo 0 = 1 if ideo == 3
recode strength_ideo 0 = 1 if ideo == 5


************************************///* INDICATORS OF INFORMATION *///************************************/* SCIENTIFIC INFORMATION 1 *//* 1 correct, 0 wrong *//* Lose 13 cases */cor q12 q13 q14 q15factor q12 q13 q14 q15 alpha q12 q13 q14 q15, detail gen (sci_obknowledge)

/* Domain-Specific Knowldge of GW "causes" */
cor q62 q63 q66 q67factor q62 q63 q66 q67  alpha q62 q63 q66 q67,detail gen (gw_know)

/* Domain-specific by partisans and ideology */ 
alpha q62 q63 q66 q67 if pid==0, detail
alpha q62 q63 q66 q67 if pid==2, detailalpha q62 q63 q66 q67 if ideo==1, detailalpha q62 q63 q66 q67 if ideo==7, detail
** Descriptive analysis  
** Correlation between pid ideo and gw_know education 
spearman gw_know education
spearman gw_know ideo
spearman gw_know pid
spearman ideo pid
spearman gw_know sci_obknowledge

*********************************************///* 1 - |NEP - HEP| CORE VALUE CONFLICT *///*********************************************/*Recode HEP and NEP components to 0 to 1 scale with higher values indicating pro-enviornmental/human paradigm*/recode q20 4 = 1 3 = .67 2 = .33 1 = 0 recode q21 4 = 1 3 = .67 2 = .33 1 = 0 recode q22 4 = 1 3 = .67 2 = .33 1 = 0recode q23 4 = 1 3 = .67 2 = .33 1 = 0recode q24 4 = 1 3 = .67 2 = .33 1 = 0recode q25 4 = 1 3 = .67 2 = .33 1 = 0recode q26 4 = 0 3 = .33 2 = .67recode q27 4 = 1 3 = .67 2 = .33 1 = 0recode q28 4 = 1 3 = .67 2 = .33 1 = 0recode q29 4 = 1 3 = .67 2 = .33 1 = 0recode q30 4 = 1 3 = .67 2 = .33 1 = 0recode q31 4 = 1 3 = .67 2 = .33 1 = 0recode q32 4 = 1 3 = .67 2 = .33 1 = 0recode q33 4 = 1 3 = .67 2 = .33 1 = 0/*NEP*//* Range 1 (high environmental concern) to 0 (environmental concern) */alpha q20 q22 q24 q29 q31 q33, detail gen (nep)********************************************************///* 1 - |NEP - ECONOMIC PRIORITIES| VALUE CONFLICT *///********************************************************/* Higher values indicate greater support for economy*/recode q7 4=1 3=.67 2=.33 1=0recode q9 4=0 3=.33 2=.67 alpha q7 q9, detail gen(economy)gen nepvecon = 1 - abs(nep - economy)


** Pluralism and interactions
** create value pluralism 
gen pluralism = ((nep + economy)/2) - abs(nep - economy)

** create interaction of education and value pluralism
gen educ_plural = education * pluralism 

** create interaction of global warming knowledge and value pluralism 
gen  gwknow_plural = gw_know * pluralism 

** create interaction of partisanship and value pluralism 
gen pid_plural = pid * pluralism 

** create interaction of partisanship and value pluralism 
gen pid_gw_pluralism = pid * gwknow_plural
***************************************************///* CLIMATE CHANGE POLICY DEPENDENT VARIABLES *///***************************************************/* In this area we create the dependent variables.  These are based upon policy preferences  *//* with regard to solving CC problems.  They are on a four-point scale *//* First, combine q93_v1 and q93_v2, as they are conceptually the same, but differently worded.  This will *//* allow us to have a variable comparable in number of observations to the others */recode q93_v1 .=0recode q93_v2 .=0gen q93 = q93_v1 + q93_v2/* Recode 0 in q93 to missing value so that it is not included */recode q93 0=./* Second, rename the variables of policy preferences */rename q89 emissionrename q90 tax_industryrename q91 tax_individualsrename q92 educatepublicrename q93 setpricerename q94 kyotorename q95 lawrename q96 renewablerename q97 methanerename q98 seawallsrename q99 vehiclerename q100 gas

** correlation of items with partisanship 
spearman pid emission
spearman pid tax_industry
spearman pid tax_individuals
spearman pid educatepublic
spearman pid setprice
spearman pid kyoto
spearman pid law
spearman pid renewable
spearman pid methane
spearman pid seawalls
spearman pid vehicle
spearman pid gas**********************
** FACTOR ANALYSIS 
***********************
** Outcome
polychoric emission tax_industry tax_individuals educatepublic setprice kyoto law renewable methane seawalls vehicle gas
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)

** economy
polychoric q7 q9
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)

** nep
polychoric q20 q22 q24 q29 q31 q33
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)

** domain specific knowledge
polychoric q62 q63 q66 q67
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)** network interestpolychoric q81 q82 q83 q85
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)

** risk 
polychoric q101 q102 q103
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)
/****************
    GLLAMM 
****************/
** rename response/outcome variables
rename emission item_1
rename tax_industry item_2
rename tax_individuals item_3
rename educatepublic item_4
rename kyoto item_5
rename law item_6 
rename renewable item_7
rename methane item_8
rename seawalls item_9
rename vehicle item_10
rename gas item_11
rename setprice item_12

** change data into long form 
reshape long item_, i(id) j(item)
rename item_ y
qui tab item, gen(d)


*******************
**ESTIMATION 
********************
** model specification 
eq load: d1-d12
eq thr: d2-d12
eq f1: race gender education ideo pid risk nep economy network  

** estimate structural model (no het) 
gllamm y, i(id) l(oprob) f(binom) thres(thr) eqs(load) geqs(f1) adapt 
matrix a=e(b)
matrix list e(b)

** MODEL 1 (Baseline het model)
** specification of het  
eq het: education gw_know pluralism 

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(a) adapt 
matrix b = e(b)
matrix list e(b)

** MODEL 2 (domain-specific * pluralism) 
** specification of het  
eq het: education gw_know pluralism gwknow_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(b) adapt 
matrix c = e(b)
matrix list e(b)

** MODEL 3 (education * pluralism) 
** specification of het  
eq het: education gw_know pluralism educ_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(b) adapt 
matrix d = e(b)
matrix list e(b)

** MODEL 4 (value trade-off) 
** specification of het  
eq het: education gw_know pluralism educ_plural economy nep

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix e = e(b)
matrix list e(b)

** MODEL 5 (ideological strength) 
** specification of het  
eq het: education gw_know pluralism educ_plural strength_ideo 

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix f = e(b)
matrix list e(b)

**********************
** PARTISANSHIP MODELS
**********************
** MODEL 6 (partisan conditioning) 
** specification of het  
eq het: education gw_know pluralism educ_plural pid pid_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix f = e(b)
matrix list e(b)


** Generate dummy variables for partisanship 
tab pid 

gen democrat = 0 
recode democrat 0=1 if pid==2

gen republican = 0 
recode republican 0=1 if pid==0

tab pid democrat
tab pid republican

** generate interactions 
gen dem_educ_plural = educ_plural * democrat
gen rep_educ_plural = educ_plural * republican


** MODEL 7 (democrat partisan conditioning) 
** specification of het  
eq het: education gw_know pluralism educ_plural democrat republican dem_educ_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix f = e(b)
matrix list e(b)

** MODEL 8 (repubican partisan conditioning) 
** specification of het  
eq het: education gw_know pluralism educ_plural democrat republican rep_educ_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix g = e(b)
matrix list e(b)

log close

************************
** BINARY GLLAAM MODELS
*************************
log using "/Users/markramirez/Public/Dropbox/NOAA STUDY KRVZ/Data/BJPS Replication Files/BJPSlogfileBinary.smcl"

**RECODE INTO BINARY ITEMS AND ESTIMATE IRT 
** 1 support 0 oppose 
recode emission 1 = 0 2 = 0 3 = 1 4 = 1
recode tax_industry 1 = 0 2 = 0 3 = 1 4 = 1
recode tax_individuals 1 = 0 2 = 0 3 = 1 4 = 1
recode educatepublic 1 = 0 2 = 0 3 = 1 4 = 1
recode kyoto 1 = 0 2 = 0 3 = 1 4 = 1
recode law 1 = 0 2 = 0 3 = 1 4 = 1
recode renewable 1 = 0 2 = 0 3 = 1 4 = 1
recode methane 1 = 0 2 = 0 3 = 1 4 = 1
recode seawalls 1 = 0 2 = 0 3 = 1 4 = 1
recode vehicle 1 = 0 2 = 0 3 = 1 4 = 1
recode gas 1 = 0 2 = 0 3 = 1 4 = 1
recode setprice 1 = 0 2 = 0 3 = 1 4 = 1


** rename response/outcome variables
rename emission item_1
rename tax_industry item_2
rename tax_individuals item_3
rename educatepublic item_4
rename kyoto item_5
rename law item_6 
rename renewable item_7
rename methane item_8
rename seawalls item_9
rename vehicle item_10
rename gas item_11
rename setprice item_12

** change data into long form 
reshape long item_, i(id) j(item)
rename item_ y
qui tab item, gen(d)



*******************
**ESTIMATION 
********************
** model specification 
eq load: d1-d12
eq thr: d2-d12
eq f1: race gender education ideo pid risk nep economy network  

** estimate structural model (no het) 
gllamm y, i(id) l(oprob) f(binom) thres(thr) eqs(load) geqs(f1) adapt 
matrix a=e(b)
matrix list e(b)

** MODEL 1 (Baseline het model)
** specification of het  
eq het: education gw_know pluralism 

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(a) adapt 
matrix b = e(b)
matrix list e(b)

** MODEL 2 (domain-specific * pluralism) 
** specification of het  
eq het: education gw_know pluralism gwknow_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(b) adapt 
matrix c = e(b)
matrix list e(b)

** MODEL 3 (education * pluralism) 
** specification of het  
eq het: education gw_know pluralism educ_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(b) adapt 
matrix d = e(b)
matrix list e(b)

** MODEL 4 (value trade-off) 
** specification of het  
eq het: education gw_know pluralism educ_plural economy nep

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix e = e(b)
matrix list e(b)

** MODEL 5 (ideological strength) 
** specification of het  
eq het: education gw_know pluralism educ_plural strength_ideo 

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix f = e(b)
matrix list e(b)

**********************
** PARTISANSHIP MODELS
**********************
** MODEL 6 (partisan conditioning) 
** specification of het  
eq het: education gw_know pluralism educ_plural pid pid_plural

** estimate structural and variance equation 
gllamm y, i(id) l(soprob) f(binom) thres(thr) eqs(load) geqs(f1) s(het) from(d) adapt 
matrix f = e(b)
matrix list e(b)


log close



/****************
    GLLAMM (two items that represent economy-environment compatibility
****************/

polychoric renewable vehicle
display r(sum_w)
global N=r(sum_w)
matrix r=r(R)
factormat r, n($N) factors(2)

predict dim1

reg dim economy nep if pid == 0 
est store pid0

reg dim economy nep if pid == 2 
est store pid2

suest pid0 pid2

test [pid0_mean]economy - [pid2_mean]economy = 0 
test [pid0_mean]nep - [pid2_mean]nep = 0 


