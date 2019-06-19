
*======================================================================================================
* Tables shown in main text in "Marital matching, economies of scale and intrahousehold allocations" by
* Laurens Cherchye, Bram De Rock, Khushboo Surana and Frederic Vermeulen
*======================================================================================================

clear all
set maxvar 32000
use psid_results_onlycouples

*=============
* Label values
*=============

label define kidc  1 "No child" 2 "One child" 3 "Two children" 4 "More than two children"
label values kidcategory kidc

label define gradec 1 "Has degree" 0 "No degree"
label values gradehusband gradec
label values gradewife gradec

label define regionc 1 "Northeast" 2 "North Central" 3 "South" 4 "West"
label values region regionc

label define agec  1 "<= 30" 2 "31-40" 3 "41-50" 4 "51-60" 5 ">= 61"
label values agecategory agec

*=====================
* Generating variables
*=====================

gen wageratio = wagef/wagem
gen logratio = log(wageratio)
gen avgscale = minscale*0.5 + maxscale*0.5
gen avgscalef = minscalef*0.5 + maxscalef*0.5
gen avgscalem = minscalem*0.5 + maxscalem*0.5
gen avgahworkf = min_ahworkf*0.5 + max_ahworkf*0.5
gen avgahworkm = min_ahworkm*0.5 + max_ahworkm*0.5
gen avgaq = min_aq*0.5 + max_aq*0.5
gen totalincome = (wagem+wagef)*112 + nonlabor
gen logincome = log(totalincome)
gen avg_wage = (wagem+wagef)*0.5
gen abs_wage = abs(wagem-wagef)
gen avg_age = (agem+agef)*0.5
gen abs_age = abs(agem-agef)
gen abs_degree = abs(gradehusband - gradewife)
gen agediff = agem-agef
gen gradediff = gradehusband - gradewife
gen dcmale = (1-stabm)*100
gen dcfemale = (1-stabf)*100 
gen nbpmax = (1-nbp_min)*100
gen nbpmean = (1-nbp_avg)*100
gen diff = maxscale - minscale

* Counting number of stable couples and consistent marriage market 
gen stable = 1 if dcmale == 0 & dcfemale == 0 & nbpmax == 0 
replace stable = 0 if stable == .
*stable = 1 if the couple is stable

sort id
by id: gen n = _n
by id: gen N = _N
by id: egen consistent = min(stable)
count if consistent == 1 & n == 1
*consistent = 1 if the couple is in stable marriage market

* Naive bounds
gen naiveminscale = (wagem*leisurem + wagef*leisuref + q + wagem*hworkm + wagef*hworkf)/( wagem*112 + wagef*112+ nonlabor)
gen naivemaxscale = (wagem*leisurem + wagef*leisuref + 2*q + 2*wagem*hworkm + 2*wagef*hworkf)/( wagem*112 + wagef*112+ nonlabor)
gen naivediffscale = naivemaxscale - naiveminscale

gen naiveminscalem = (wagem*leisurem)/( wagem*112 + wagef*112+ nonlabor)
gen naivemaxscalem = (wagem*leisurem + q + wagem*hworkm + wagef*hworkf)/( wagem*112 + wagef*112+ nonlabor)
gen naivediffscalem = naivemaxscalem - naiveminscalem

gen naiveminscalef = (wagef*leisuref)/( wagem*112 + wagef*112+ nonlabor )
gen naivemaxscalef = (wagef*leisuref + q + wagem*hworkm + wagef*hworkf)/( wagem*112 + wagef*112+ nonlabor)
gen naivediffscalef = naivemaxscalef - naiveminscalef

*===================================
* Table 1: Sample summary statistics
*===================================
 sum wagem wagef workhm workhf hworkm hworkf leisurem leisuref agem agef kids q
 
*===================================================================
* Table 2: Divorce costs as a fraction of post-divorce income (in %)
*===================================================================
count if dcmale <= 0 
di r(N)/1322
count if dcfemale <= 0 
di r(N)/1322
count if nbpmean <= 0 
di r(N)/1322
count if nbpmax <= 0 
di r(N)/1322
sum dcmale dcfemale nbpmean nbpmax,de

*============================
* Table 3: Economies of scale
*============================
sum minscale maxscale diffscale naiveminscale naivemaxscale naivediffscale, de

*==============================
* Table 4: Degree of publicness
*==============================
sum min_ahworkf max_ahworkf avgahworkf min_ahworkm max_ahworkm avgahworkm min_aq max_aq avgaq, de

*==========================================================
* Table 5: Economies of scale and household characteristics
*==========================================================
intreg minscale maxscale logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
reg avgscale logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)

*=====================================
* Table 6: RICEBs of males and females
*===================================== 
sum minscalef maxscalef diffscalef minscalem maxscalem diffscalem naiveminscalef naivemaxscalef naivediffscalef naiveminscalem naivemaxscalem naivediffscalem, de

*==============================
* Table 7: Poverty rates (in %)
*==============================

gen minsharefemale = minscalef*totalincome
gen maxsharefemale = maxscalef*totalincome
gen minsharemale = minscalem*totalincome
gen maxsharemale = maxscalem*totalincome
gen minscaledincome = minscale*totalincome
gen maxscaledincome = maxscale*totalincome

sum minscaledincome, de
scalar define povertylineminscale = 0.6*r(p50)
sum maxscaledincome, de
scalar define povertylinemaxscale = 0.6*r(p50)
sum totalincome, de
scalar define povertyline = 0.6*r(p50)

count if totalincome < povertyline 
di r(N)/1322
count if minscaledincome < povertyline 
di r(N)/1322
count if maxscaledincome < povertyline 
di r(N)/1322
count if minsharemale < povertyline/2
di r(N)/1322
count if maxsharemale < povertyline/2
di r(N)/1322
count if minsharefemale < povertyline/2
di r(N)/1322
count if maxsharefemale < povertyline/2
di r(N)/1322

*==========================================================
* Table 8: Individual RICEBs and household characteristics
*==========================================================

*** Male RICEB ***
intreg minscalem maxscalem logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
reg avgscalem logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)

** Female RICEB **
intreg minscalef maxscalef logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
reg avgscalef logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro  i.region agediff gradediff, vce(robust)

*====================================================================
* Table 9: Male RICEBs as consumption-preserving income compensations
*====================================================================

/* -0.206*logratio + 0.00104*logincome - 0.251*has degree + 0.0235*onechild + 0.0202*twochild + 0.0260*morethan2child +
   -0.00932*lessthan31 - 0.00334*31to40 + 0.00352*51to60 + 0.0135*morethan60 + 0.0014*cohabitating -0.0014*homeowner -0.00803*metro 
   -0.0156*northcentral - 0.0209*south - 0.0126*west + 0.000349*agediff - 0.00139*gradediff + 0.567
*/

* Northeast
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*1 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*1 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*1 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567

* North Central
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*1 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*1 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*1 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*1 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*1 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*1 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*1 - 0.0209*0 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567

* South
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*1 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*1 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*1 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*1 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*1 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*1 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*1 - 0.0126*0 + 0.000349*0 - 0.00139*0 + 0.567

* West
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*1 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*1 + 0.0202*0 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*1 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*1 + 0.026*0 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*1 + 0.000349*0 - 0.00139*0 + 0.567
di -0.206*-0.2381 + 0.00104*8.406378 - 0.251*0 + 0.0235*0 + 0.0202*0 + 0.026*1 -0.00932*0 - 0.00334*0 + 0.00352*0 + 0.0135*0 + 0.0014*0 -0.0014*0 -0.00803*1 -0.0156*0 - 0.0209*0 - 0.0126*1 + 0.000349*0 - 0.00139*0 + 0.567


*=======================================================================
* Table 10: Female RICEBs as consumption-preserving income compensations
*=======================================================================

/* -0.207*logratio - 0.0389*logincome + 0.0175*has degree + 0.0299*onechild + 0.0381*twochild + 0.0379*morethan2child +
   +0.00188*lessthan31 + 0.000404*31to40 + 0.0134*51to60 - 0.014935*morethan60 - 0.0052*cohabitating + 0.00451*homeowner +0.0072*metro 
   +0.00399*northcentral + 0.004629*south + 0.00626*west - 0.00111*agediff - 0.0023*gradediff + 0.853
*/

* Northeast
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*1+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*1 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*1 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853

* North Central
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*1 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*1+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*1 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*1 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*1 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*1 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*1 + 0.004629*0 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853

* South
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*1 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*1+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*1 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*1 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*1 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*1 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*1 + 0.00626*0 - 0.00111*0 - 0.0023*0 + 0.853

* West
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*1 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*1+ 0.0381*0 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*1 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*1 + 0.0379*0 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*1 - 0.00111*0 - 0.0023*0 + 0.853
di 0.207*-0.2381 - 0.0389*8.406378 + 0.0175*0 + 0.0299*0+ 0.0381*0 + 0.0379*1 + 0.00188*0 + 0.000404*0 + 0.0134*0 - 0.014935*0 - 0.0052*0 + 0.00451*0 +0.0072*1 +0.00399*0 + 0.004629*0 + 0.00626*1 - 0.00111*0 - 0.0023*0 + 0.853

*===========================================
*===========================================
* Appendix C: Supplementary data information
*===========================================
*=========================================== 

*===========================================
* C.2: Tables 11-14 Size of marriage markets
*===========================================

tab agecategory kidcategory if gradehusband == 0 & region == 1
tab agecategory kidcategory if gradehusband == 1 & region == 1
tab agecategory kidcategory if gradehusband == 0 & region == 2
tab agecategory kidcategory if gradehusband == 1 & region == 2
tab agecategory kidcategory if gradehusband == 0 & region == 3
tab agecategory kidcategory if gradehusband == 1 & region == 3
tab agecategory kidcategory if gradehusband == 0 & region == 4
tab agecategory kidcategory if gradehusband == 1 & region == 4

*=======================================
* C.3: Tables 15-16 Assortative matching
*======================================= 

gen agecatf = 1 if agef <= 30
replace agecatf = 2 if agef >= 31 & agef <= 40
replace agecatf = 3 if agef >= 41 & agef <= 50
replace agecatf = 4 if agef >= 51 & agef <= 60
replace agecatf = 5 if agef >= 61 

tab gradehusband gradewife, cell
tab agecategory  agecatf , cell

*================================
* C.4: Tables 17-20 Budget shares
*================================ 

gen budgetsharefleisure = 100*(wagef*leisuref)/totalincome
gen budgetsharemleisure = 100*(wagem*leisurem)/totalincome
gen budgetsharefhwork = 100*(wagef*hworkf)/totalincome
gen budgetsharemhwork = 100*(wagem*hworkm)/totalincome
gen budgetshareq = 100*(q)/totalincome

tabstat budgetsharefleisure budgetsharemleisure budgetsharefhwork budgetsharemhwork budgetshareq, by(kidcategory)
tabstat budgetsharefleisure budgetsharemleisure budgetsharefhwork budgetsharemhwork budgetshareq, by(gradehusband)
tabstat budgetsharefleisure budgetsharemleisure budgetsharefhwork budgetsharemhwork budgetshareq, by(region)
tabstat budgetsharefleisure budgetsharemleisure budgetsharefhwork budgetsharemhwork budgetshareq, by(agecategory)

*=====================================================================
* D.1 Figures 1-2 Empirical distribution of scale economies and RICEBs
*===================================================================== 

cumul minscale, generate(cumminscale)
cumul maxscale, generate(cummaxscale)
twoway (line cumminscale minscale, sort) (line cummaxscale maxscale, sort lpattern(dash)),ytitle("cumulative density")/*
*/ legend(label(1 "lower bound economies of scale") label(2 "upper bound economies of scale") size(vsmall))
graph save Graph_cdf_economiesofscale.gph, replace 

cumul minscalem, generate(cumminscalem)
cumul maxscalem, generate(cummaxscalem)
cumul minscalef, generate(cumminscalef)
cumul maxscalef, generate(cummaxscalef)
twoway (line cumminscalem minscalem, sort lcolor(navy) lpattern(solid)) /*
*/     (line cummaxscalem maxscalem, sort lcolor(maroon) lpattern(solid)) /*
*/     (line cumminscalef minscalef, sort lcolor(navy) lpattern(dash)) /*
*/     (line cummaxscalef maxscalef, sort lcolor(maroon) lpattern(dash)), ytitle("cumulative density")/*
*/ legend(label(1 "lower bound male RICEB") label(2 "upper bound male RICEB") label(3 "lower bound female RICEB") label(4 "upper bound female RICEB") size(small))
graph save Graph_cdf_ricebs.gph, replace 

*================================================================================================
* D.2 Table 21 Match quality (measured as post-divorce income loss) and household characteristics
*================================================================================================ 

xi: reg nbpmax avg_wage abs_wage avg_age abs_age totalincome kids abs_degree N i.cohabitating i.homeowner i.metro, robust
xi: reg nbpmean avg_wage abs_wage avg_age abs_age totalincome kids abs_degree N i.cohabitating i.homeowner i.metro, robust


*==============================================================================================
* D.3 Table 22 Household characteristics and publicness of domestic work and market consumption
*============================================================================================== 

reg avgahworkf logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if hworkf != 0, vce(robust)
reg avgahworkm logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if hworkm != 0, vce(robust)
reg avgaq logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)

*========================================================
* D.4 Tables 23-24 Private and public components of RICEB
*======================================================== 

sum min_privatef min_publicf max_privatef max_publicf min_privatem min_publicm max_privatem max_publicm,de

*without leisure
gen min_privatef_wl = min_privatef - (wagef*leisuref/totalincome)
gen max_privatef_wl = max_privatef - (wagef*leisuref/totalincome)
gen min_privatem_wl = min_privatem - (wagem*leisurem/totalincome)
gen max_privatem_wl = max_privatem - (wagem*leisurem/totalincome)
sum min_privatef_wl max_privatef_wl min_privatem_wl max_privatem_wl,de 

*============================================================
* D.5 Tables 25-26 Poverty rates for specific household types
*============================================================

*Poverty rates by household composition
tabstat totalincome, by(kidcategory) stat(median, N)
scalar define povline0 = 0.6*4308.032
scalar define povline1 = 0.6*4300.996
scalar define povline2 = 0.6*4633.394
scalar define povline3 = 0.6*4340.972

count if totalincome < povline0 & kidcategory == 1
di r(N)/561
count if totalincome < povline1 & kidcategory == 2
di r(N)/258
count if totalincome < povline2 & kidcategory == 3
di r(N)/327
count if totalincome < povline3 & kidcategory == 4
di r(N)/176

count if minscaledincome < povline0 & kidcategory == 1
di r(N)/561
count if minscaledincome < povline1 & kidcategory == 2
di r(N)/258
count if minscaledincome < povline2 & kidcategory == 3
di r(N)/327
count if minscaledincome < povline3 & kidcategory == 4
di r(N)/176

count if maxscaledincome < povline0 & kidcategory == 1
di r(N)/561
count if maxscaledincome < povline1 & kidcategory == 2
di r(N)/258
count if maxscaledincome < povline2 & kidcategory == 3
di r(N)/327
count if maxscaledincome < povline3 & kidcategory == 4
di r(N)/176

count if minsharemale < povline0/2 & kidcategory == 1
di r(N)/561
count if minsharemale < povline1/2 & kidcategory == 2
di r(N)/258
count if minsharemale < povline2/2 & kidcategory == 3
di r(N)/327
count if minsharemale < povline3/2 & kidcategory == 4
di r(N)/176

count if maxsharemale < povline0/2 & kidcategory == 1
di r(N)/561
count if maxsharemale < povline1/2 & kidcategory == 2
di r(N)/258
count if maxsharemale < povline2/2 & kidcategory == 3
di r(N)/327
count if maxsharemale < povline3/2 & kidcategory == 4
di r(N)/176

count if minsharefemale < povline0/2 & kidcategory == 1
di r(N)/561
count if minsharefemale < povline1/2 & kidcategory == 2
di r(N)/258
count if minsharefemale < povline2/2 & kidcategory == 3
di r(N)/327
count if minsharefemale < povline3/2 & kidcategory == 4
di r(N)/176

count if maxsharefemale < povline0/2 & kidcategory == 1
di r(N)/561
count if maxsharefemale < povline1/2 & kidcategory == 2
di r(N)/258
count if maxsharefemale < povline2/2 & kidcategory == 3
di r(N)/327
count if maxsharefemale < povline3/2 & kidcategory == 4
di r(N)/176

*Poverty rates by region of residence
tabstat totalincome, by(region) stat(median, N)
scalar define povline0 = 0.6*5189.563
scalar define povline1 = 0.6*4246.316
scalar define povline2 = 0.6*4254.507
scalar define povline3 = 0.6*4443.635

count if totalincome < povline0 & region == 1
di r(N)/213
count if totalincome < povline1 & region == 2
di r(N)/352
count if totalincome < povline2 & region == 3
di r(N)/500
count if totalincome < povline3 & region == 4
di r(N)/257

count if minscaledincome < povline0 & region == 1
di r(N)/213
count if minscaledincome < povline1 & region == 2
di r(N)/352
count if minscaledincome < povline2 & region == 3
di r(N)/500
count if minscaledincome < povline3 & region == 4
di r(N)/257

count if maxscaledincome < povline0 & region == 1
di r(N)/213
count if maxscaledincome < povline1 & region == 2
di r(N)/352
count if maxscaledincome < povline2 & region == 3
di r(N)/500
count if maxscaledincome < povline3 & region == 4
di r(N)/257

count if minsharemale < povline0/2  & region == 1
di r(N)/213
count if minsharemale < povline1/2  & region == 2
di r(N)/352
count if minsharemale < povline2/2  & region == 3
di r(N)/500
count if minsharemale < povline3/2  & region == 4
di r(N)/257


count if maxsharemale < povline0/2  & region == 1
di r(N)/213
count if maxsharemale < povline1/2  & region == 2
di r(N)/352
count if maxsharemale < povline2/2  & region == 3
di r(N)/500
count if maxsharemale < povline3/2  & region == 4
di r(N)/257

count if minsharefemale < povline0/2  & region == 1
di r(N)/213
count if minsharefemale < povline1/2  & region == 2
di r(N)/352
count if minsharefemale < povline2/2  & region == 3
di r(N)/500
count if minsharefemale < povline3/2  & region == 4
di r(N)/257

count if maxsharefemale < povline0/2  & region == 1
di r(N)/213
count if maxsharefemale < povline1/2  & region == 2
di r(N)/352
count if maxsharefemale < povline2/2  & region == 3
di r(N)/500
count if maxsharefemale < povline3/2  & region == 4
di r(N)/257

*========================================
* F.2 Tables 29-31 Exactly stable couples 
*========================================

sum minscale maxscale diffscale naiveminscale naivemaxscale naivediffscale if stable == 1, de
sum minscalef maxscalef diffscalef minscalem maxscalem diffscalem naiveminscalef naivemaxscalef naivediffscalef naiveminscalem naivemaxscalem naivediffscalem if stable == 1, de

intreg minscale maxscale logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if stable == 1, vce(robust)
reg avgscale logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if stable == 1, vce(robust)
intreg minscalem maxscalem logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if stable == 1, vce(robust)
reg avgscalem logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if stable == 1, vce(robust)
intreg minscalef maxscalef logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff if stable == 1, vce(robust)
reg avgscalef logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro  i.region agediff gradediff if stable == 1, vce(robust)
