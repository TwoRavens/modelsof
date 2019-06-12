
**************************************************************************************
************************          CROSS SECTIONAL MODELS     ******************
**************************************************************************************

clear

use "C:\Users\torewig_adm\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\Campaigndata_v2.dta", clear

*label
label variable indwork_dominate "Industrial workers dominated"
label variable urban_dominate "Middle class dominated"
label variable atleast_urban "Middle class participated"
label variable atleast_indwork "Industrial workers participated"
label variable originate_urban "Middle class origin"
label variable originate_indwork "Industrial worker origin"
label variable atleast_relethnic "Religious or ethnic group participated"
label variable atleast_pubemp "Public sector workers participated"
label variable atleast_peasant "Peasants participated"
label variable originate_relethnic "Religious or ethnic group origin"
label variable originate_pubemp "Public sector workers origin"
label variable originate_peasant "Peasants origin"
label variable relethnic_dominate "Religious or ethnic group dominated"
label variable pubemp_dominate "Public sector workers dominated"
label variable peasant_dominate "Peasants dominated"
*label variable e_migdppcln "Ln GDP p.c."
*label variable e_mipopulaln "Ln Population"
*label variable e_miurbani "Urbanization"
*label variable worker_index "Industrial worker index"
*label variable midclass_index "Middle class index"
*label variable urbreg_mean "Middle class dominated campaigns in neighborhood"
*label variable indreg_mean "Ind. worker dominated campaigns in neighborhood"
*label variable campaigns_mean "Campaigns in neighborhood"
*label variable v2x_polyarchy_n_mean "Democracy score in neighborhood"


label variable bmr_t1 "Democracy (BMR) 1 year"
label variable bmr_t5 "Democracy (BMR) 5 years"
label variable urbans "UM index"
label variable workers "IW index"
label variable bmr_t1 "Democracy (BMR) t-1"
label variable lmembers "Ln participants"
label variable lurbanpop_byear "Ln urban population"
label variable lpop_byear "Ln population"
label variable lgdp_byear "Ln GDP per capita"

capture drop urbcamp
gen urbcamp = .
replace urbcamp = 1 if urban_dominate==1 | indwork_dominate==1
replace urbcamp = 1 if urban_dominate ==1 & indwork_dominate==1
replace urbcamp = 0 if urban_dominate==0 & indwork_dominate==0

label variable urbcamp "Middle class OR ind. workers dominated"

inspect urbcamp

generate bmr_demzn =0
replace bmr_demzn=1 if  bmr_byear==0 & bmr_t1==1
browse country_name byear outcome bmr_demzn
summarize bmr_demzn

generate bmr_demznlt =0
replace bmr_demznlt=1 if  bmr_byear==0 & bmr_t5==1
browse country_name byear outcome bmr_demzn bmr_demznlt
summarize bmr_demzn bmr_demznlt

generate urbanization = exp(lurbanpop_byear)/exp(lpop_byear)
summarize urbanization, detail

summarize lgdp_byear


**CREATE NEW SOCIAL GROUPS VARIABLES WITH NEW OBSERVATIONS

gen indwork_dominate2 = indwork_dominate
replace indwork_dominate2 = indwork_dominateSM if indwork_dominate==.

gen urban_dominate2 = urban_dominate
replace urban_dominate2 = urban_dominateSM if urban_dominate==.

capture drop urbcamp2
gen urbcamp2 = .
replace urbcamp2 = 1 if urban_dominate2==1 | indwork_dominate2==1
replace urbcamp2 = 1 if urban_dominate2 ==1 & indwork_dominate2==1
replace urbcamp2 = 0 if urban_dominate2==0 & indwork_dominate2==0


**for descriptive discussion: 
generate dpolyarchy = v2x_polyarchy_t1 - v2x_polyarchy_byear
sort dpolyarchy 
browse country_name byear dpolyarchy v2x_polyarchy_t1 v2x_polyarchy_byear


label variable urbcamp2 "Middle class OR ind. workers dominated"
label variable urban_dominate2 "Middle class dominate"
label variable indwork_dominate2 "Industrial workers dominate"


*******************************************
*******************************************
**********TABLE A6**************************
*******************************************

regress bmr_demzn urbcamp  if bmr_byear==0
estimate store a
regress bmr_demzn urbcamp  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
regress v2x_polyarchy_t1 urbcamp v2x_polyarchy_byear
estimate store c
regress v2x_polyarchy_t1 urbcamp lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store d
regress bmr_demzn urban_dominate indwork_dominate  if bmr_byear==0
estimate store e
regress bmr_demzn urban_dominate indwork_dominate  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store f
regress v2x_polyarchy_t1 urban_dominate indwork_dominate v2x_polyarchy_byear
estimate store g
regress v2x_polyarchy_t1 urban_dominate indwork_dominate lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store h
estout  a b c d e f g h, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demzn if _est_a==1


*******************************************
*******************************************
**********TABLE A10**************************
*******************************************

*URBAN
gen urban_dominate_mis = .
replace urban_dominate_mis=0
replace urban_dominate_mis = 1 if urban_dominate2==.
gen urban_originate_mis =.
replace urban_originate_mis=0
replace urban_originate_mis =1 if originate_urban==.
gen atleast_urban_mis=.
replace atleast_urban_mis =0
replace atleast_urban_mis=1 if atleast_urban==.
*workers
gen indwork_dominate_mis = .
replace indwork_dominate_mis=0
replace indwork_dominate_mis = 1 if indwork_dominate2==.
gen indwork_originate_mis =.
replace indwork_originate_mis=0
replace indwork_originate_mis =1 if originate_indwork==.
gen atleast_indwork_mis=.
replace atleast_indwork_mis =0
replace atleast_indwork_mis=1 if atleast_indwork==.

logit urban_dominate_mis lmembers nonviol urbanization lpop_byear lgdp_byear v2x_polyarchy_byear
estimates store mis1
logit urban_originate_mis lmembers nonviol urbanization lpop_byear lgdp_byear v2x_polyarchy_byear
estimates store mis2
logit atleast_urban_mis lmembers nonviol urbanization lpop_byear lgdp_byear v2x_polyarchy_byear
estimates store mis3
logit indwork_dominate_mis lmembers nonviol urbanization lpop_byear lgdp_byear v2x_polyarchy_byear
estimates store mis4
logit indwork_originate_mis lmembers nonviol urbanization lpop_byear lgdp_byear v2x_polyarchy_byear
estimates store mis5
logit atleast_indwork_mis lmembers nonviol urbanization lpop_byear lgdp_byear v2x_polyarchy_byear
estimates store mis6
estout  mis1 mis2 mis3 mis4 mis5 mis6, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)




*******************************************
*******************************************
**********TABLE A9**************************
*******************************************
regress bmr_demzn urbcamp2  if bmr_byear==0
estimate store a
regress bmr_demzn urbcamp2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
regress bmr_demzn urban_dominate2 indwork_dominate if bmr_byear==0
estimate store c
regress bmr_demzn urban_dominate2 indwork_dominate  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store d
estout  a b c d, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demzn if _est_a==1

*C2
logit bmr_demzn urbcamp2  if bmr_byear==0
estimate store a
logit bmr_demzn urbcamp2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
logit bmr_demzn urban_dominate2 indwork_dominate2  if bmr_byear==0
estimate store c
logit bmr_demzn urban_dominate2 indwork_dominate2 lmembers urbanization lpop_byear lgdp_byear  if bmr_byear==0
estimate store d
logit bmr_demzn urbcamp2  if bmr_byear==0
estimate store e
logit bmr_demzn urbcamp2 lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store f
logit bmr_demzn urban_dominate2 indwork_dominate2  if bmr_byear==0
estimate store g
logit bmr_demzn urban_dominate2 indwork_dominate2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store h
estout  a b c d e f g h , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demzn if _est_a==1





*******************************************
*******************************************
**********TABLE A17**************************
*******************************************
regress bmr_demznlt urbcamp2  if bmr_byear==0
estimate store a
regress bmr_demznlt urbcamp2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
regress bmr_demznlt urban_dominate2 indwork_dominate if bmr_byear==0
estimate store c
regress bmr_demznlt urban_dominate2 indwork_dominate  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store d
estout  a b c d, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demznlt if _est_a==1


*******************************************
*******************************************
**********TABLE A18**************************
*******************************************
*logit models

logit bmr_demzn urbcamp2  if bmr_byear==0
estimate store a
logit bmr_demzn urbcamp2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
logit bmr_demzn urban_dominate2 indwork_dominate2  if bmr_byear==0
estimate store c
logit bmr_demzn urban_dominate2 indwork_dominate2 lmembers urbanization lpop_byear lgdp_byear  if bmr_byear==0
estimate store d
logit bmr_demznlt urbcamp2  if bmr_byear==0
estimate store e
logit bmr_demznlt urbcamp2 lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store f
logit bmr_demznlt urban_dominate2 indwork_dominate2  if bmr_byear==0
estimate store g
logit bmr_demznlt urban_dominate2 indwork_dominate2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store h
estout  a b c d e f g h , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demzn if _est_a==1










