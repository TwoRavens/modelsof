
*======================================================================================================
* Tables shown in Appendix F3 in "Marital matching, economies of scale and intrahousehold allocations" by
* Laurens Cherchye, Bram De Rock, Khushboo Surana and Frederic Vermeulen
*======================================================================================================

clear all
set maxvar 32000
use psid_results_f3_onlycouples

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

gen avgscale5 = minscale5*0.5 + maxscale5*0.5
gen avgscalef5 = minscalef5*0.5 + maxscalef5*0.5
gen avgscalem5 = minscalem5*0.5 + maxscalem5*0.5

gen avgscale10 = minscale10*0.5 + maxscale10*0.5
gen avgscalef10 = minscalef10*0.5 + maxscalef10*0.5
gen avgscalem10 = minscalem10*0.5 + maxscalem10*0.5

gen avgscale15 = minscale15*0.5 + maxscale15*0.5
gen avgscalef15 = minscalef15*0.5 + maxscalef15*0.5
gen avgscalem15 = minscalem15*0.5 + maxscalem15*0.5

gen totalincome = (wagem+wagef)*112 + nonlabor
gen logincome = log(totalincome)
gen agediff = agem-agef
gen gradediff = gradehusband - gradewife

*===========================================================================================
* Table 32: Average scale economies and individual RICEBs with public consumption of leisure
*===========================================================================================
sum minscale5 maxscale5 diffscale5 minscalem5 maxscalem5 diffscalem5 minscalef5 maxscalef5 diffscalef5
sum minscale10 maxscale10 diffscale10 minscalem10 maxscalem10 diffscalem10 minscalef10 maxscalef10 diffscalef10
sum minscale15 maxscale15 diffscale15 minscalem15 maxscalem15 diffscalem15 minscalef15 maxscalef15 diffscalef15
 
*==================================================================================================================
* Table 33:  Economies of scale, individual RICEBs and household characteristics with public consumption of leisure 
*==================================================================================================================
intreg minscale5 maxscale5 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
intreg minscalem5 maxscalem5 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
intreg minscalef5 maxscalef5 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro  i.region agediff gradediff, vce(robust)

intreg minscale10 maxscale10 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
intreg minscalem10 maxscalem10 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
intreg minscalef10 maxscalef10 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro  i.region agediff gradediff, vce(robust)

intreg minscale15 maxscale15 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
intreg minscalem15 maxscalem15 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro i.region agediff gradediff, vce(robust)
intreg minscalef15 maxscalef15 logratio logincome i.gradehusband i.kidcategory i.agecategory i.cohabitating i.homeowner i.metro  i.region agediff gradediff, vce(robust)
