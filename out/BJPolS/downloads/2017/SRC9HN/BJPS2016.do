** Does political sophistication minimize value conflict? Evidence from climate change
** 6/6/2016
** Paul Kellstedt, Mark D. Ramirez, Arnold Vedlizt, and Sammy Zahran
** Estimation of HGIRT

set more off, permanently

** increase memory
set mem 10g


** generate id variable 
gen id = _n

label drop q119fin1
label define q119fin1 0 "non-white" 1 "white"
tab race
label drop q116
codebook education 

** recode democrat = 1 republican = -1
recode pid 2 = 0 3 = 1 1 = 2 8 = 1 9 = 1 
label drop q114
label define q114 0 "republican" 1 "independent/else" 2 "democrat"  
codebook pid 




** create ideological strength 
gen strength_ideo = 0 
recode strength_ideo 0 = 3 if ideo == 1
recode strength_ideo 0 = 3 if ideo == 7
recode strength_ideo 0 = 2 if ideo == 6
recode strength_ideo 0 = 2 if ideo == 2
recode strength_ideo 0 = 1 if ideo == 3
recode strength_ideo 0 = 1 if ideo == 5


************************************

/* Domain-Specific Knowldge of GW "causes" */
cor q62 q63 q66 q67

/* Domain-specific by partisans and ideology */ 
alpha q62 q63 q66 q67 if pid==0, detail
alpha q62 q63 q66 q67 if pid==2, detail
** Descriptive analysis  
** Correlation between pid ideo and gw_know education 
spearman gw_know education
spearman gw_know ideo
spearman gw_know pid
spearman ideo pid
spearman gw_know sci_obknowledge

*********************************************


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
spearman pid gas
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
factormat r, n($N) factors(2)
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

    GLLAMM 
****************/

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

