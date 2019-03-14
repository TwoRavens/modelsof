

****TABLE 1:
clear

*use "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\CountryYearMerged2b.dta", clear
use "C:\Users\torewig_adm\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\FINAL SUBMISSION JOP\Replication materials\Replicationdata_countryyear.dta", clear 

*defining panel structure
xtset country_id year

*dropping observations outside of the NAVCO data
drop if year >2006

*****RECODING SOME VARIABLES 

*logging population
gen e_mipopulaln = .
replace  e_mipopulaln = log(e_mipopula)

*generating a ``no campaign" variable
gen No_campaign = .
replace No_campaign = 1 if campaign == 0 
replace No_campaign = 0 if campaign == 1 

**generating ``urban or workers dominate"
gen midclass_workers_dominate = .
replace midclass_workers_dominate = 1 if indwork_dominate==1 | urban_dominate==1
replace midclass_workers_dominate = 0 if indwork_dominate==0 & urban_dominate==0

**generating indices
gen midclass_index = .
replace midclass_index = 0
replace midclass_index = atleast_urban + originate_urban + urban_dominate

gen worker_index = .
replace worker_index = 0
replace worker_index = atleast_indwork + originate_indwork + indwork_dominate

gen urban_index = .
replace urban_index = 0 if midclass_index ==0 & worker_index==0
replace urban_index = 1 if midclass_index ==1 | worker_index==1
replace urban_index = 2 if midclass_index ==2 | worker_index==2
replace urban_index = 3 if midclass_index ==3 | worker_index==3
summarize urban_index midclass_index worker_index, detail

***Labeling
label variable midclass_workers_dominate "Middle class OR ind. workers dominated"
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
label variable campaign "Other campaign"
label variable e_migdppcln "Ln GDP p.c."
label variable e_mipopulaln "Ln Population"
label variable e_miurbani "Urbanization"
label variable worker_index "Industrial worker index"
label variable midclass_index "Middle class index"
label variable urbreg_mean "Middle class dominated campaigns in neighborhood"
label variable indreg_mean "Ind. worker dominated campaigns in neighborhood"
label variable campaigns_mean "Campaigns in neighborhood"
label variable v2x_polyarchy_n_mean "Democracy score in neighborhood"

**CREATE NEW SOCIAL GROUP VARIABLES WITH NEW OBSERVATIONS (FROM THE SECOND CODER THAT FILLED IN SOME MISSING VALUES FROM THE FIRST CODING, RESULTS DO NOT HINGE ON THIS)
gen indwork_dominate2 = indwork_dominate
replace indwork_dominate2 = indwork_dominateSM if indwork_dominate==.

gen urban_dominate2 = urban_dominate
replace urban_dominate2 = urban_dominateSM if urban_dominate==.

capture drop urbcamp2
gen urbcamp2 = .
replace urbcamp2 = 1 if urban_dominate2==1 | indwork_dominate2==1
replace urbcamp2 = 1 if urban_dominate2 ==1 & indwork_dominate2==1
replace urbcamp2 = 0 if urban_dominate2==0 & indwork_dominate2==0

gen midclass_workers_dominate2 = .
replace midclass_workers_dominate2 = 1 if indwork_dominate2==1 | urban_dominate2==1
replace midclass_workers_dominate2 = 0 if indwork_dominate2==0 & urban_dominate2==0

capture drop indwork_dominate3
gen indwork_dominate3 = indwork_dominate
replace indwork_dominate3 = indwork_dominateSM if indwork_dominateSM!=.

gen urban_dominate3 = urban_dominate
replace urban_dominate3 = urban_dominateSM if urban_dominateSM!=.

capture drop urbcamp3
gen urbcamp3 = .
replace urbcamp3 = 1 if urban_dominate3==1 | indwork_dominate3==1
replace urbcamp3 = 1 if urban_dominate3 ==1 & indwork_dominate3==1
replace urbcamp3 = 0 if urban_dominate3==0 & indwork_dominate3==0

gen midclass_workers_dominate3 = .
replace midclass_workers_dominate3 = 1 if indwork_dominate3==1 | urban_dominate3==1
replace midclass_workers_dominate3 = 0 if indwork_dominate3==0 & urban_dominate3==0

gen indwork_dominate4 = indwork_dominate
replace indwork_dominate4 = indwork_dominateSM if indwork_dominateSM!=.
replace indwork_dominate4 = indwork_dominateS if indwork_dominateS!=.

gen urban_dominate4 = urban_dominate
replace urban_dominate4 = urban_dominateSM if urban_dominateSM!=.
replace urban_dominate4 = urban_dominateS if urban_dominateS!=.

gen midclass_workers_dominate4 = .
replace midclass_workers_dominate4 = 1 if indwork_dominate4==1 | urban_dominate4==1
replace midclass_workers_dominate4 = 0 if indwork_dominate4==0 & urban_dominate4==0

*Labeling
label variable urban_dominate2 "Middle class dominated"
label variable urban_dominate3 "Middle class dominated"
label variable urban_dominate4 "Middle class dominated"
label variable midclass_workers_dominate2 "Middle class OR ind. workers dominated"
label variable midclass_workers_dominate3 "Middle class OR ind. workers dominated"
label variable midclass_workers_dominate4 "Middle class OR ind. workers dominated"
label variable indwork_dominate2 "Industrial workers dominated"
label variable indwork_dominate3 "Industrial workers dominated"
label variable indwork_dominate4 "Industrial workers dominated"

*generating "democratization" variable
capture drop demchange_bmr
gen demchange_bmr = D.e_boix_regime

capture drop demcz_bmr
gen demcz_bmr = .
replace demcz_bmr = 0 if demchange_bmr == 0
replace demcz_bmr = . if demchange_bmr == .
replace demcz_bmr = 1 if demchange_bmr==1 
replace demcz_bmr = 0 if demchange_bmr == -1

*generating variable to omit democracies from the democratization models
capture drop omitdems
gen omitdems = .
replace omitdems = 0 if e_boix_regime == 0
replace omitdems = 1 if demcz_bmr==0 & e_boix_regime==1

*generating variable to omit democracies and democratizers from the democratization models (In robustness tests later)
capture drop omitdems
gen omitdems_democratizers = .
replace omitdems_democratizers = 0 if e_boix_regime == 0
replace omitdems_democratizers = 1 if demcz_bmr==1 | e_boix_regime==1

*generating variable to omit all dictatorships
capture drop omitdicts
gen omitdicts = .
replace omitdicts = 0 if e_boix_regime == 0
replace omitdicts = 1 if demcz_bmr==1 | e_boix_regime==1


*generating variable to omit all dictatorships
capture drop omitdicts_democratizers
gen omitdicts_democratizers = .
replace omitdicts_democratizers = 0 if e_boix_regime == 0
replace omitdicts_democratizers = 1 if demcz_bmr==0 & e_boix_regime==1

*generating class coalitions
gen classcoalitions = .
replace classcoalitions = atleast_urban + atleast_indwork + atleast_peasant + atleast_pubemp + atleast_relethnic

***creating extended dominate variable for urban middle class by countring public employees
generate urbanext_dominate = 0 if urban_dominate !=.
replace urbanext_dominate =1 if urban_dominate==1
replace urbanext_dominate =1 if pubemp_dominate==1
summarize urban_dominate pubemp_dominate urbanext_dominate, detail

***CREATING polyarchy change variable
sort country_id year
by country_id: generate Polychange = v2x_polyarchy-v2x_polyarchy[_n-1]
generate Polychange_plus = Polychange
replace Polychange_plus = 0 if Polychange <0 &Polychange != .
generate Polychange_minus = Polychange
replace Polychange_minus = 0 if Polychange >0 &Polychange != .
summarize Polychange Polychange_plus Polychange_minus

********************************************************************************************************
**************     TABLE1:   WITH MAX OBSERVATIONS AND CORRECT TIME SERIES ***********************
********************************************************************************************************

set more off
eststo clear
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
lincom midclass_workers_dominate2 - campaign
estimates store a
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b1
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b2
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
xtlogit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year ,  fe, if omitdems==0 & year<2007
estimates store c 
gen pseudor2 = (e(ll_0)-e(ll))/e(ll_0)
summarize pseudor2
lincom midclass_workers_dominate2 - campaign
logit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year , cluster(country_id), if omitdems==0 & year<2007
estimates store d 
lincom midclass_workers_dominate2 - campaign

logit F.demcz_bmr urban_dominate2 indwork_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0 & year<2007
estimates store e 
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
estout  a b b1 b2 c d e, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)




*************************************************
***********     TABLE A7   **********************
*************************************************

set more off
eststo clear
xtreg F.v2x_polyarchy midclass_workers_dominate4 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store a
xtreg F.v2x_polyarchy urban_dominate4 indwork_dominate4 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b
xtreg F.Polychange urban_dominate4 indwork_dominate4 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b1
xtreg F.Polychange_plus urban_dominate4 indwork_dominate4 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b2
xtlogit F.demcz_bmr midclass_workers_dominate4 campaign e_migdppcln e_mipopulaln e_miurbani i.year ,  fe, if omitdems==0 & year<2007
estimates store c 
logit F.demcz_bmr midclass_workers_dominate4 campaign e_migdppcln e_mipopulaln e_miurbani i.year , cluster(country_id), if omitdems==0 & year<2007
estimates store d 
logit F.demcz_bmr urban_dominate4 indwork_dominate4 campaign e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0 & year<2007
estimates store e 
estout  a b b1 b2 c d e, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)





**************************************************
*************   TABLE A10   **********************
**************************************************
*baseline
set more off
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
summarize urban_dominate2 if _est_b==1
summarize pubemp_dominate if _est_b==1
summarize security2, detail, if _est_b==1 & security2==0


lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

*Alternative lag
xtreg F2.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store f

lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

*No clustering
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe
estimates store b1

lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

*reduced model
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy  i.year, fe cluster(country_id)
estimates store g

lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2


*post-treatment controls
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year lmembers regviol, fe cluster(country_id)
estimates store h

lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

*including public employees
xtreg F.v2x_polyarchy urbanext_dominate indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b2

lincom indwork_dominate2 - campaign
lincom urbanext_dominate - campaign
lincom indwork_dominate2 - urbanext_dominate

*controlling nr cases
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year classcoalitions, fe cluster(country_id)
estimates store i

lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

*dropping uncertain cases
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if security2!=0
estimates store j

lincom indwork_dominate2 - campaign
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

*originate
xtreg F.v2x_polyarchy originate_urban originate_indwork campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe cluster(country_id)
estimates store k
***Testing lexical
xtreg F.v2x_polyarchy worker_index midclass_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe cluster(country_id)
estimates store l
estout  f b1 g h b2 i j k l, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


***********************************************************
*******************      A11   ****************************
***********************************************************

*C15 - Errors in variables regression
gen v2x_polyarchy_t1 = .
replace v2x_polyarchy_t1 = F.v2x_polyarchy

gen Polychange_t1 = .
replace Polychange_t1 = F.Polychange

gen Polychange_plus_t1 = .
replace Polychange_plus_t1 = F.Polychange_plus


gen demcz_bmr_t1 = .
replace demcz_bmr_t1 = F.demcz_bmr_t1

**eiv models with .80 reliability
set more off
eststo clear
eivreg v2x_polyarchy_t1 midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id , r(midclass_workers_dominate2 .80 ) 
estimates store a
eivreg v2x_polyarchy_t1 indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id , r(indwork_dominate2 .80 urban_dominate2 .80 ) 
estimates store b
eivreg  Polychange_t1 midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.country_id i.year , r(midclass_workers_dominate2 .80 )  
estimates store c
eivreg  Polychange_t1 urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.country_id i.year , r(indwork_dominate2 .80 urban_dominate2 .80  )  
estimates store d
eivreg  Polychange_plus_t1 midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id i.year ,  r(midclass_workers_dominate2 .80 )  
estimates store e
eivreg  Polychange_plus_t1 urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id i.year ,  r(indwork_dominate2 .80 urban_dominate2 .80 )  
estimates store f

estout  a b c d e f , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


***********************************
********    A12   *****************
***********************************


**eiv models with .60 reliability
set more off
eststo clear
eivreg v2x_polyarchy_t1 midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id , r(midclass_workers_dominate2 .60 ) 
estimates store a
eivreg v2x_polyarchy_t1 indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id , r(indwork_dominate2 .60 urban_dominate2 .60 ) 
estimates store b
eivreg  Polychange_t1 midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.country_id i.year , r(midclass_workers_dominate2 .60 )  
estimates store c
eivreg  Polychange_t1 urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.country_id i.year , r(indwork_dominate2 .60 urban_dominate2 .60  )  
estimates store d
eivreg  Polychange_plus_t1 midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id i.year ,  r(midclass_workers_dominate2 .60 )  
estimates store e
eivreg  Polychange_plus_t1 urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year i.country_id i.year ,  r(indwork_dominate2 .60 urban_dominate2 .60 )  
estimates store f

estout  a b c d e f , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


***********************************
********    A13   *****************
***********************************

set more off
xi: xtivreg2 F.v2x_polyarchy campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean i.year (urban_index = urbreg_mean indreg_mean) , fe cluster(country_id)
estimates store a 


xi: xtreg urban_index urbreg_mean indreg_mean campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean i.year v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store b 

set more off
xi: xtivreg2 F.v2x_polyarchy worker_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean i.year v2x_polyarchy_n_mean (midclass_index = urbreg_mean) , fe cluster(country_id)
estimates store c 


xi: xtreg midclass_index urbreg_mean worker_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean i.year  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store d 

xi: xtivreg2 F.v2x_polyarchy midclass_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean i.year v2x_polyarchy_n_mean (worker_index = indreg_mean) , fe cluster(country_id)
estimates store e 

xi: xtreg worker_index indreg_mean midclass_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean i.year v2x_polyarchy_n_mean, fe cluster(country_id)
estimates store f 

estout e f c d a b, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


************************************
*******    A14   *******************
************************************


***CONTROLLING FOR CIVIL WAR
set more off
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 e_Civil_War campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b
xtreg F.Polychange urban_dominate2 indwork_dominate2 e_Civil_War campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b1
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 e_Civil_War campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b2

estout  a b b1 b2, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)

***CONTROLLING FOR NON VIOLENT TACTICS
set more off
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 nonviol campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store c
xtreg F.Polychange urban_dominate2 indwork_dominate2 nonviol campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store c1
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 nonviol campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store c2

estout  b b1 b2 c c1 c2, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)




**************************************
**********   A15   *******************
**************************************
use "C:\Users\torewig_adm\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\countryyear_v4.dta"

*disaggregating the middle class category
*cant find the data


replace students_dominate=. if students_dominate==99
replace graduates_dominate = 0 if graduates_dominate==.
replace graduates_dominate =. if urban_dominate2==.

capture drop urban_rest
gen urban_rest = 0
replace urban_rest = . if urban_dominate2==.
replace urban_rest = 1 if graduates_dominate ==0 & urban_dominate2==1
replace urban_rest = 1 if students_dominate==0 & urban_dominate2==1 

set more off
eststo clear
xtreg F.v2x_polyarchy urban_rest graduates_dominate students_dominate pubemp_dominate indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b
xtreg F.Polychange urban_rest graduates_dominate students_dominate pubemp_dominate indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b1
xtreg F.Polychange_plus urban_rest graduates_dominate students_dominate pubemp_dominate indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b2
logit F.demcz_bmr urban_rest graduates_dominate students_dominate pubemp_dominate campaign indwork_dominate2 e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0 & year<2007
estimates store e 
estout   b b1 b2 e, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)



**************************************
**********   A16   *******************
**************************************
gen othergoals = .
replace othergoals=0
replace othergoals = 1 if country_name=="Guatemala" & (year>1965&year<1973)
replace othergoals = 1 if country_name=="Argentina" & (year==1986)
replace othergoals = 1 if country_name=="France" & (year>1957&year<1963)
replace othergoals = 1 if country_name=="Romania" & (year==1907)
replace othergoals = 1 if country_name=="Russia" & (year>1929&year<1936)
replace othergoals = 1 if country_name=="South Africa" & (year>1951&year<1962)
replace othergoals = 1 if country_name=="South Africa" & (year>1983&year<1995)
replace othergoals = 1 if country_name=="Sudan" & (year>2002&year<2006)
replace othergoals = 1 if country_name=="Jordan" & (year==1970)
replace othergoals = 1 if country_name=="China" & (year>1966&year<1969)


*baseline table
set more off
eststo clear
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007 & othergoals==0, fe cluster(country_id)
estimates store a
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007  & othergoals==0, fe cluster(country_id)
estimates store b
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007  & othergoals==0, fe cluster(country_id)
estimates store b1
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007  & othergoals==0, fe cluster(country_id)
estimates store b2
xtlogit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year ,  fe, if omitdems==0 & year<2007  & othergoals==0
estimates store c 
estout  a b b1 b2 c , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)



****************************************
********    A19   **********************
****************************************

sort country_id year
by country_id: generate Polychange = v2x_polyarchy-v2x_polyarchy[_n-1]
generate Polychange_plus = Polychange
replace Polychange_plus = 0 if Polychange <0 &Polychange != .
generate Polychange_minus = Polychange
replace Polychange_minus = 0 if Polychange >0 &Polychange != .
summarize Polychange Polychange_plus Polychange_minus


set more off
xtreg F.Polychange midclass_workers_dominate2 campaign  e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store a
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign  e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
xtreg F.Polychange midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store c
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store d
estout  a b c d , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2) drop(1* 2*) style (tex)

********************************************
*********      A20     *********************
********************************************



set more off
xtreg F.Polychange_plus midclass_workers_dominate2 campaign  e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store a
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign  e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
xtreg F.Polychange_plus midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store c
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store d
estout  a b c d , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2) drop(1* 2*) style (tex)


*******************************************
***********   A21   ***********************
*******************************************

set more off
xtreg F.Polychange_minus midclass_workers_dominate2 campaign  e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store a
xtreg F.Polychange_minus urban_dominate2 indwork_dominate2 campaign  e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
xtreg F.Polychange_minus midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store c
xtreg F.Polychange_minus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store d
estout  a b c d , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2) drop(1* 2*) style (tex)

*******************************************
***********   A22   ***********************
*******************************************

set more off
regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy  ,  cluster(country_id) , if omitdems_democratizers==0
estimates store m1


regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems_democratizers==0
estimates store m2 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe , if omitdems_democratizers==0
estimates store m3 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe , if omitdems_democratizers==0
estimates store m4 

xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe , if omitdems_democratizers==0
estimates store m5 


esttab m1 m2 m3 m4 m5 using "C:\Users\torwig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\baselines_x_democracies_democratization.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)


*******************************************
***********   A23   ***********************
*******************************************
set more off
regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy  ,  cluster(country_id) , if omitdems==0
estimates store m1


regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0
estimates store m2 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe , if  omitdems==0
estimates store m3 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe , if omitdems==0
estimates store m4 

xtreg F.v2x_polyarchy  urban_dominate2 indwork_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe , if omitdems==0
estimates store m4 

esttab m1 m2 m3 m4 m5 using "C:\Users\torwig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\baselines_x_democracies.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)

*******************************************
***********   A24   ***********************
*******************************************
set more off
regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy  ,  cluster(country_id) , if omitdicts==1
estimates store m1


regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdicts==1
estimates store m2 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe ,  if omitdicts==1
estimates store m3 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe ,  if omitdicts==1
estimates store m4 

xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe ,  if omitdicts==1
estimates store m5


esttab m1 m2 m3 m4 m5 using "C:\Users\torwig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\baselines_x_dictatorships_democratization.tex", replace style(tex) nogaps compress mtitles label stats(N )
*******************************************
***********   A25    ***********************
*******************************************
set more off
regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy  ,  cluster(country_id) , if omitdicts_democratizers==1
estimates store m1


regress F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdicts_democratizers==1
estimates store m2 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe ,  if omitdicts_democratizers==1
estimates store m3 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe ,  if omitdicts_democratizers==1
estimates store m4 


xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe ,  if omitdicts_democratizers==1
estimates store m5

esttab m1 m2 m3 m4 m5 using "C:\Users\torwig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\baselines_x_dictatorships_x_democratizers.tex", replace style(tex) nogaps compress mtitles label stats(N)


*******************************************
***********   A26    ***********************
*******************************************

*baseline
set more off
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
*Alternative lag
xtreg F2.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store f
*No clustering
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe
estimates store b1
*reduced model
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy  i.year, fe cluster(country_id)
estimates store g
*post-treatment controls
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year lmembers regviol, fe cluster(country_id)
estimates store h
*controlling nr cases
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year classcoalitions, fe cluster(country_id)
estimates store i
*dropping uncertain cases
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if security2!=0
estimates store j
estout  f b1 g h i j, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2) drop(1* 2*) style (tex)


*******************************************
***********   A27    ***********************
*******************************************
*robustness tests with positive changes
*baseline
set more off
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
*Alternative lag
xtreg F2.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store f
*No clustering
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe
estimates store b1
*reduced model
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy  i.year, fe cluster(country_id)
estimates store g
*post-treatment controls
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year lmembers regviol, fe cluster(country_id)
estimates store h
*including public employees
xtreg F.Polychange_plus urbanext_dominate indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b2
*controlling nr cases
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year classcoalitions, fe cluster(country_id)
estimates store i
*dropping uncertain cases
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if security2!=0
estimates store j
*originate
xtreg F.Polychange_plus originate_urban originate_indwork campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe cluster(country_id)
estimates store k
***Testing lexical
xtreg F.Polychange_plus worker_index midclass_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe cluster(country_id)
estimates store l
estout  f b1 g h b2 i j k l, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)  drop(1* 2*) style (tex)

*******************************************
***********   A28   ***********************
*******************************************
*further nuancing "other campaigns"
set more off
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store a
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b1
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b2
xtlogit F.demcz_bmr midclass_workers_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate e_migdppcln e_mipopulaln e_miurbani i.year ,  fe, if omitdems==0
estimates store c 
logit F.demcz_bmr midclass_workers_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate e_migdppcln e_mipopulaln e_miurbani i.year , cluster(country_id), if omitdems==0
estimates store d 
logit F.demcz_bmr urban_dominate2 indwork_dominate2 campaign pubemp_dominate relethnic_dominate peasant_dominate e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0
estimates store e 
estout  a b b1 b2, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2) drop(1* 2*) style (tex)


*******************************************
***********   A29   ***********************
*******************************************
*IV second stage wit dominate rather than index

*2SLS - midclass
set more off
xi: xtivreg2 F.v2x_polyarchy indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean indreg_mean  v2x_polyarchy_n_mean i.year (urban_dominate2 = urbreg_mean) , fe cluster(country_id)
estimates store a 

*2.3 2SLS - workers
xi: xtivreg2 F.v2x_polyarchy urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean i.year (indwork_dominate2 = indreg_mean) , fe cluster(country_id)
estimates store e 

*2SLS - allurban
set more off
xi: xtivreg2 F.v2x_polyarchy  campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani  campaigns_mean  v2x_polyarchy_n_mean i.year (midclass_workers_dominate2 = urbreg_mean indreg_mean) , fe cluster(country_id)
estimates store c 
estout e a c, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)  style (tex)



*******************************************
***********   A30   ***********************
*******************************************
generate region =.
**WE+NA
replace region = 1 if e_regiongeo==1
replace region = 1 if e_regiongeo==2
replace region = 1 if e_regiongeo==3
replace region = 1 if e_regiongeo==16
**EE
replace region = 2 if e_regiongeo==4
**SS Africa
replace region = 3 if e_regiongeo==6
replace region = 3 if e_regiongeo==7
replace region = 3 if e_regiongeo==8
replace region = 3 if e_regiongeo==9
**MENA
replace region = 4 if e_regiongeo==10
replace region = 4 if e_regiongeo==5
**Asia-Pacific
replace region =  5 if e_regiongeo==11
replace region = 5 if e_regiongeo==12
replace region = 5 if e_regiongeo==13
replace region = 5 if e_regiongeo==14
replace region = 5 if e_regiongeo==15
**LAT_AM
replace region = 6 if e_regiongeo==17
replace region = 6 if e_regiongeo==18
replace region = 6 if e_regiongeo==19

sort country_id year
by country_id: carryforward region, gen(region2) 
generate yearinv= 8000 - year
sort country_id yearinv
by country_id:carryforward region2, replace
sort country_id year
browse country_id year region2

generate iagroupurban = midclass_workers_dominate*e_miurbani
generate iacampurban = campaign*e_miurbani
generate iamidurban = e_miurbani*urban_dominate 
generate iaiwurban = indwork_dominate*e_miurbani


set more off
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if year <1956
estimates store a
summarize midclass_workers_dominate if _est_a==1
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if year >1955
estimates store b
**wo West
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=1
estimates store c
**wo ee
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=2
estimates store d
**wo ssa
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=3
estimates store e
**wo mena
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=4
estimates store f
**wo asia-pac
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=5
estimates store g
**lat am
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=6
estimates store h

xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store ba
summarize e_miurbani if _est_ba==1,detail
**median urb is .4119735

xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if e_miurbani<0.4119735
estimates store i
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if e_miurbani>0.4119734
estimates store j 


xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign iagroupurban iacampurban v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store k
xtreg F.v2x_polyarchy urban_dominate indwork_dominate2 campaign iamidurban iaiwurban iacampurban v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store l
estout  a b c d e f g h i j k l, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


*******************************************
***********   A31   ***********************
*******************************************
*sensitivity and scope separating between indwork and urban
set more off
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if year <1956
estimates store a
summarize indwork_dominate urban_dominate if _est_a==1
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if year >1955
estimates store b
**wo West
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=1
estimates store c
**wo ee
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=2
estimates store d
**wo ssa
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=3
estimates store e
**wo mena
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=4
estimates store f
**wo asia-pac
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=5
estimates store g
**lat am
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if region2!=6
estimates store h

xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store ba
summarize e_miurbani if _est_ba==1,detail
**median urb is .4119735

xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if e_miurbani<0.4119735
estimates store i
xtreg F.v2x_polyarchy indwork_dominate2 urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id), if e_miurbani>0.4119734
estimates store j 

xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign iamidurban iaiwurban iacampurban v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store l
estout  a b c d e f g h i j l, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2) drop(1* 2*) style(tex)


















































clear

use "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\Campaigndata_v2.dta", clear

**************************************************************************************
************************          SIMPLE CROSS SECTIONAL MODELS     ******************
**************************************************************************************

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
label variable e_miurbani "Urbanization"
label variable worker_index "Industrial worker index"
label variable midclass_index "Middle class index"
label variable urbreg_mean "Middle class dominated campaigns in neighborhood"
label variable indreg_mean "Ind. worker dominated campaigns in neighborhood"
label variable campaigns_mean "Campaigns in neighborhood"
label variable v2x_polyarchy_n_mean "Democracy score in neighborhood"


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

*******************************************************
********** CAMPAIGN-LEVEL ANALYSES ********************
*******************************************************

***MAIN

**********TABLE 2*******************

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

********** TABLE 2 WITH NEW OBSERVATIONS FROM SOLVEIG******************* cHK: THIS ONE SEEMS TO BE USED IN APPX E
regress bmr_demzn urbcamp2  if bmr_byear==0
estimate store a
regress bmr_demzn urbcamp2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
regress v2x_polyarchy_t1 urbcamp2 v2x_polyarchy_byear
estimate store c
regress v2x_polyarchy_t1 urbcamp2 lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store d
regress bmr_demzn urban_dominate2 indwork_dominate2  if bmr_byear==0
lincom indwork_dominate2 - urban_dominate2

estimate store e
regress bmr_demzn urban_dominate2 indwork_dominate2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
lincom indwork_dominate2 - urban_dominate2

estimate store f
regress v2x_polyarchy_t1 urban_dominate2 indwork_dominate2 v2x_polyarchy_byear
lincom indwork_dominate2 - urban_dominate2

estimate store g
regress v2x_polyarchy_t1 urban_dominate2 indwork_dominate2 lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
lincom indwork_dominate2 - urban_dominate2

estimate store h
estout  a b c d e f g h, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demzn if _est_a==1



******************************************
*****************APPENDIX*****************
******************************************

*C1
regress bmr_demznlt urbcamp2  if bmr_byear==0
estimate store a
regress bmr_demznlt urbcamp2  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
regress bmr_demznlt urban_dominate2 indwork_dominate if bmr_byear==0
estimate store c
regress bmr_demznlt urban_dominate2 indwork_dominate  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
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



*******************************************************************
*****************APPENDIX: MISSINGNESS CORRELATES *****************
*******************************************************************

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




****JUNK

*Rob.test for appx logit 

regress v2x_polyarchy_t1 urbcamp v2x_polyarchy_byear
estimate store c
regress v2x_polyarchy_t1 urbcamp lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store d
logit bmr_demzn urban_dominate indwork_dominate  if bmr_byear==0
estimate store e
logit bmr_demzn urban_dominate indwork_dominate lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store f
regress v2x_polyarchy_t1 urban_dominate indwork_dominate v2x_polyarchy_byear
estimate store g
regress v2x_polyarchy_t1 urban_dominate indwork_dominate lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store h
estout  a b c d e f g h, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)

regress v2x_polyarchy_t1 urbcamp v2x_polyarchy_byear
estimate store c
regress v2x_polyarchy_t1 urbcamp lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store d

regress v2x_polyarchy_t1 urban_dominate indwork_dominate v2x_polyarchy_byear
estimate store g
regress v2x_polyarchy_t1 urban_dominate indwork_dominate lmembers urbanization lpop_byear lgdp_byear  v2x_polyarchy_byear
estimate store h
estout  a b c d e f g h, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)



****************************************************************************************
***************************      COUNTRY YEAR MODELS              **********************
****************************************************************************************


********USE NEW DATASET
clear

*use "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\CountryYearMerged2b.dta", clear
 
use "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\countryyear_v3.dta", clear 
merge 1:1 country_id year using "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Data\Country_Year_V-Dem_other_STATA_v6.1\V-Dem-DS-CY+Others-v6.1.dta"
*use "C:\Users\carlhk\Dropbox\CHK, TW og SD\Opposition movements\Data\CountryYearMerged.dta", clear
*defining panel structure
xtset country_id year
drop if year >2006

*recoding variables

*logging population
gen e_mipopulaln = .
replace  e_mipopulaln = log(e_mipopula)

*generating ``no campaign" variable
gen No_campaign = .
replace No_campaign = 1 if campaign == 0 
replace No_campaign = 0 if campaign == 1 


**generating ``urban or workers dominate"
gen midclass_workers_dominate = .
replace midclass_workers_dominate = 1 if indwork_dominate==1 | urban_dominate==1
replace midclass_workers_dominate = 0 if indwork_dominate==0 & urban_dominate==0


**generating indices
gen midclass_index = .
replace midclass_index = 0
replace midclass_index = atleast_urban + originate_urban + urban_dominate

gen worker_index = .
replace worker_index = 0
replace worker_index = atleast_indwork + originate_indwork + indwork_dominate

gen urban_index = .
replace urban_index = 0 if midclass_index ==0 & worker_index==0
replace urban_index = 1 if midclass_index ==1 | worker_index==1
replace urban_index = 2 if midclass_index ==2 | worker_index==2
replace urban_index = 3 if midclass_index ==3 | worker_index==3
summarize urban_index midclass_index worker_index, detail

***Labeling
label variable midclass_workers_dominate "Middle class OR ind. workers dominated"
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
label variable campaign "Other campaign"
label variable e_migdppcln "Ln GDP p.c."
label variable e_mipopulaln "Ln Population"
label variable e_miurbani "Urbanization"
label variable worker_index "Industrial worker index"
label variable midclass_index "Middle class index"
label variable urbreg_mean "Middle class dominated campaigns in neighborhood"
label variable indreg_mean "Ind. worker dominated campaigns in neighborhood"
label variable campaigns_mean "Campaigns in neighborhood"
label variable v2x_polyarchy_n_mean "Democracy score in neighborhood"


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

gen midclass_workers_dominate2 = .
replace midclass_workers_dominate2 = 1 if indwork_dominate2==1 | urban_dominate2==1
replace midclass_workers_dominate2 = 0 if indwork_dominate2==0 & urban_dominate2==0

capture drop indwork_dominate3
gen indwork_dominate3 = indwork_dominate
replace indwork_dominate3 = indwork_dominateSM if indwork_dominateSM!=.

gen urban_dominate3 = urban_dominate
replace urban_dominate3 = urban_dominateSM if urban_dominateSM!=.

capture drop urbcamp3
gen urbcamp3 = .
replace urbcamp3 = 1 if urban_dominate3==1 | indwork_dominate3==1
replace urbcamp3 = 1 if urban_dominate3 ==1 & indwork_dominate3==1
replace urbcamp3 = 0 if urban_dominate3==0 & indwork_dominate3==0

gen midclass_workers_dominate3 = .
replace midclass_workers_dominate3 = 1 if indwork_dominate3==1 | urban_dominate3==1
replace midclass_workers_dominate3 = 0 if indwork_dominate3==0 & urban_dominate3==0



gen indwork_dominate4 = indwork_dominate
replace indwork_dominate4 = indwork_dominateSM if indwork_dominateSM!=.
replace indwork_dominate4 = indwork_dominateS if indwork_dominateS!=.


gen urban_dominate4 = urban_dominate
replace urban_dominate4 = urban_dominateSM if urban_dominateSM!=.
replace urban_dominate4 = urban_dominateS if urban_dominateS!=.


gen midclass_workers_dominate4 = .
replace midclass_workers_dominate4 = 1 if indwork_dominate4==1 | urban_dominate4==1
replace midclass_workers_dominate4 = 0 if indwork_dominate4==0 & urban_dominate4==0


label variable urban_dominate2 "Middle class dominated"
label variable urban_dominate3 "Middle class dominated"
label variable urban_dominate4 "Middle class dominated"
label variable midclass_workers_dominate2 "Middle class OR ind. workers dominated"
label variable midclass_workers_dominate3 "Middle class OR ind. workers dominated"
label variable midclass_workers_dominate4 "Middle class OR ind. workers dominated"
label variable indwork_dominate2 "Industrial workers dominated"
label variable indwork_dominate3 "Industrial workers dominated"
label variable indwork_dominate4 "Industrial workers dominated"







*generating "democratization" variable
capture drop demchange_bmr
gen demchange_bmr = D.e_boix_regime

capture drop demcz_bmr
gen demcz_bmr = .
replace demcz_bmr = 0 if demchange_bmr == 0
replace demcz_bmr = . if demchange_bmr == .
replace demcz_bmr = 1 if demchange_bmr==1 
replace demcz_bmr = 0 if demchange_bmr == -1

*generating variable to omit democracies from the democratization models
capture drop omitdems
gen omitdems = .
replace omitdems = 0 if e_boix_regime == 0
replace omitdems = 1 if demcz_bmr==0 & e_boix_regime==1

*generating variable to omit democracies and democratizers from the democratization models
capture drop omitdems
gen omitdems_democratizers = .
replace omitdems_democratizers = 0 if e_boix_regime == 0
replace omitdems_democratizers = 1 if demcz_bmr==1 | e_boix_regime==1


*generating variable to omit all dictatorships
capture drop omitdicts
gen omitdicts = .
replace omitdicts = 0 if e_boix_regime == 0
replace omitdicts = 1 if demcz_bmr==1 | e_boix_regime==1


*generating variable to omit all dictatorships
capture drop omitdicts_democratizers
gen omitdicts_democratizers = .
replace omitdicts_democratizers = 0 if e_boix_regime == 0
replace omitdicts_democratizers = 1 if demcz_bmr==0 & e_boix_regime==1

*generating class coalitions
gen classcoalitions = .
replace classcoalitions = atleast_urban + atleast_indwork + atleast_peasant + atleast_pubemp + atleast_relethnic

***creating extended dominate variable for urban middle class by countring public employees
generate urbanext_dominate = 0 if urban_dominate !=.
replace urbanext_dominate =1 if urban_dominate==1
replace urbanext_dominate =1 if pubemp_dominate==1
summarize urban_dominate pubemp_dominate urbanext_dominate, detail

sort country_id year
by country_id: generate Polychange = v2x_polyarchy-v2x_polyarchy[_n-1]
generate Polychange_plus = Polychange
replace Polychange_plus = 0 if Polychange <0 &Polychange != .
generate Polychange_minus = Polychange
replace Polychange_minus = 0 if Polychange >0 &Polychange != .
summarize Polychange Polychange_plus Polychange_minus

*plots to presentation
xtreg F.Polychange midclass_workers_dominate campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani, fe cluster(country_id)
coefplot, drop(_cons) xline(0)

xtreg F.Polychange_plus urban_dominate indwork_dominate campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani, fe cluster(country_id)
coefplot, drop(_cons) xline(0)


xtivreg2 F.Polychange campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean (urban_index = urbreg_mean indreg_mean) , fe cluster(country_id)
coefplot, drop(_cons) xline(0)

********************************************************************************************************
**************     TABLE3:   WITH NEW OBSERVATIONS AND CORRECT TIME SERIES ***********************
********************************************************************************************************
set more off
eststo clear
xtreg F.v2x_polyarchy midclass_workers_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
lincom midclass_workers_dominate2 - campaign
estimates store a
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b1
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b2
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2

xtlogit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year ,  fe, if omitdems==0 & year<2007
estimates store c 
gen pseudor2 = (e(ll_0)-e(ll))/e(ll_0)
summarize pseudor2
lincom midclass_workers_dominate2 - campaign



logit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year , cluster(country_id), if omitdems==0 & year<2007
estimates store d 
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
logit F.demcz_bmr urban_dominate2 indwork_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0 & year<2007
estimates store e 
lincom urban_dominate2 - campaign
lincom indwork_dominate2 - campaign
lincom indwork_dominate2 - urban_dominate2
estout  a b b1 b2 c d e, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)







********************************************************************************************************
**************       Distginguishing between urban middle class                                             ***********************
********************************************************************************************************



set more off
eststo clear
xtreg F.v2x_polyarchy urban_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store a
xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b
xtreg F.Polychange urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b1
xtreg F.Polychange_plus urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year if year<2007, fe cluster(country_id)
estimates store b2


xtlogit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year ,  fe, if omitdems==0 & year<2007
estimates store c 
gen pseudor2 = (e(ll_0)-e(ll))/e(ll_0)
summarize pseudor2



logit F.demcz_bmr midclass_workers_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani i.year , cluster(country_id), if omitdems==0 & year<2007
estimates store d 
logit F.demcz_bmr urban_dominate2 indwork_dominate2 campaign e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0 & year<2007
estimates store e 
estout  a b b1 b2 c d e, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)




********************************************************************************************************
***************       NEW (CHK) Split-sample TABLE  ************************
********************************************************************************************************

**Sensitivity splits sample for combined variable




*********************************************************************************
******************************     VALIDATION c4-c5 **************************************


*******************************************
***********FOR APPX*********************
*******************************************


********************************************
***********     DESCRIPTIVES TABLE *********
********************************************


xtreg F.v2x_polyarchy urban_dominate2 indwork_dominate2 campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store b


estpost summarize v2x_polyarchy e_boix_regime midclass_workers_dominate2 urban_dominate2 indwork_dominate2 originate_urban originate_indwork atleast_urban atleast_indwork pubemp_dominate relethnic_dominate peasant_dominate originate_pubemp originate_relethnic originate_peasant atleast_peasant atleast_pubemp atleast_relethnic campaign lmembers regviol e_migdppcln e_mipopulaln e_miurbani worker_index midclass_index urbreg_mean indreg_mean campaigns_mean v2x_polyarchy_n_mean if _est_b==1
esttab, cells("count  mean sd min max") tex replace style(tex) label




********************************************
***********    DISAGGREGATING URBAN MIDDLE CLASS  *********
********************************************





********************************************************************************************************
**************       More robustness                                             ***********************
********************************************************************************************************


**C10 - tests using combined dummy

**************************************************
**********        IV MODELS **********************
**************************************************

*C13



****subsetting dataset for CDE estimation
keep year country_id urban_dominate2 indwork_dominate2 regviol defect v2x_polyarchy  e_migdppcln v2x_polyarchy_t1 e_mipopulaln e_miurbani nonviol regaid  lgovcap viol 










Russia 1930 1935
Russia 1990 1991
South Africa 1952 1961
South Africa 1984 1994
Sudan 2003 2006
Jordan 1970 1970 
China 1967 1968




























































*Rob test lt
regress bmr_demznlt urbcamp  if bmr_byear==0
estimate store a
regress bmr_demznlt urbcamp  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
regress bmr_demznlt urban_dominate indwork_dominate  if bmr_byear==0
estimate store e
regress bmr_demznlt urban_dominate indwork_dominate  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store f
estout  a b e f, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
summarize bmr_demzn if _est_a==1






*Rob.test for appx logit long term
*Rob.test for appx logit 
logit bmr_demzn urbcamp  if bmr_byear==0
estimate store a
logit bmr_demzn urbcamp  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store b
logit bmr_demzn urban_dominate indwork_dominate  if bmr_byear==0
estimate store e
logit bmr_demzn urban_dominate indwork_dominate lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store f
estout  a b e f, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)
logit bmr_demznlt urbcamp  if bmr_byear==0
estimate store aa
logit bmr_demznlt urbcamp lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store bb
logit bmr_demznlt urban_dominate indwork_dominate  if bmr_byear==0
estimate store ee
logit bmr_demznlt urban_dominate indwork_dominate  lmembers urbanization lpop_byear lgdp_byear if bmr_byear==0
estimate store ff
estout  a b e f aa bb ee ff, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)

























**just quickly probing participate, need other table than this
xtreg F.Polychange atleast_urban atleast_indwork campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store c
xtreg F.v2x_polyarchy  atleast_urban atleast_indwork v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year, fe cluster(country_id)
estimates store d 














*********************************
**OLD CHK Endog table, wrong lag polyarchy AND no year dummies***********
********************************

*2SLS - allurban
*set more off
xtivreg2 F.v2x_polyarchy campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean (urban_index = urbreg_mean indreg_mean) , fe cluster(country_id)
estimates store a 


*First stage - midclass
xtreg urban_index urbreg_mean indreg_mean campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store b 

*2SLS - midclass
set more off
xtivreg2 F.v2x_polyarchy worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean (midclass_index = urbreg_mean) , fe cluster(country_id)
estimates store c 


*First stage - midclass
xtreg midclass_index urbreg_mean worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store d 

*2.3 2SLS - workers
xtivreg2 F.v2x_polyarchy midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean (worker_index = indreg_mean) , fe cluster(country_id)
estimates store e 

*First stage - workers
xtreg worker_index indreg_mean midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean, fe cluster(country_id)
estimates store f 
estout e f c d a b, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


*********************************
**NEW CHK Endog table***********
********************************

*2SLS - allurban
*set more off
xtivreg2 F.v2x_polyarchy campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean (urban_index = urbreg_mean indreg_mean) , fe cluster(country_id)
estimates store a 


*First stage - midclass
xtreg urban_index urbreg_mean indreg_mean campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store b 

*2SLS - midclass
set more off
xtivreg2 F.v2x_polyarchy worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean (midclass_index = urbreg_mean) , fe cluster(country_id)
estimates store c 


*First stage - midclass
xtreg midclass_index urbreg_mean worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store d 

*2.3 2SLS - workers
xtivreg2 F.v2x_polyarchy midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean (worker_index = indreg_mean) , fe cluster(country_id)
estimates store e 

*First stage - workers
xtreg worker_index indreg_mean midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean, fe cluster(country_id)
estimates store f 
estout e f c d a b, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


************Rob test on dominate
*2SLS - midclass
*set more off
xi: xtivreg2 F.v2x_polyarchy campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean i.year (urban_dominate = urbreg_mean indreg_mean) , fe cluster(country_id)
estimates store a 

*2.3 2SLS - workers
xi: xtivreg2 F.v2x_polyarchy midclass_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean i.year (indwork_dominate = indreg_mean) , fe cluster(country_id)
estimates store e 


*2SLS - allurban
set more off
xi: xtivreg2 F.v2x_polyarchy worker_index campaign v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean i.year (midclass_workers_dominate = urbreg_mean) , fe cluster(country_id)
estimates store c 
estout e a c, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.10 ** 0.05 *** 0.01) stats (N r2)style (tex)


xtreg F.v2x_polyarchy urban_index urbreg_mean indreg_mean campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store b 
*First stage - workers
xtreg F.v2x_polyarchy worker_index indreg_mean midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean, fe cluster(country_id)
estimates store f 














********************************************************************************************************
**************       DOMINATED BY MIDDLE CLASS AND WORKERS  ***********************
********************************************************************************************************


***BMR 
eststo clear
*2.1 DOMINATE - Pooled with only lags
set more off
logit demcz_bmr midclass_workers_dominate campaign L1.v2x_polyarchy  ,  cluster(country_id) , if omitdems==0
estimates store m1 

*2.2 DOMINATE - Pooled with lags, gdp, urbanization and population
logit demcz_bmr midclass_workers_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0
estimates store m2 

*2.3 DOMINATE - Pooled with lags, gdp, urbanization and population, region dummies
xtlogit demcz_ midclass_workers_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe,  if omitdems==0
estimates store m3 


*2.4 DOMINATE - YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtlogit demcz_bmr midclass_workers_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe , if omitdems==0
estimates store m4 

*2.1 DOMINATE - Pooled with only lags
set more off
regress F.v2x_polyarchy midclass_workers_dominate campaign L1.v2x_polyarchy  ,  cluster(country_id)
estimates store m5

*2.2 DOMINATE - Pooled with lags, gdp, urbanization and population
regress F.v2x_polyarchy midclass_workers_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id)
estimates store m6 

*2.3 DOMINATE - Pooled with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy midclass_workers_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe cluster(country_id)
estimates store m7 


*1.4 DOMINATE - YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy midclass_workers_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe
estimates store m8 


esttab m1 m2 m3 m4 m5 m6 m7 m8   using "C:\Users\siriad\Dropbox\CHK, TW og SD\Opposition movements\Tables\tab1A.tex", replace style(tex) nogaps compress mtitles label star(+ 0.10 * 0.05 ** 0.01 *** 0.001) stats(N countryfixed regionfixed yearfixed)




*********************************************************************************************************
**************                   DOMINATED BY MIDDLE CLASS OR WORKERS    ***********************
*********************************************************************************************************


**TAB 3 - DOMINATE
eststo clear
**3.1 DOMINATE - Pooled with only lags
set more off
logit demcz_bmr urban_dominate indwork_dominate campaign L1.v2x_polyarchy  ,  cluster(country_id) , if omitdems==0
estimates store m1 

*3.2 DOMINATE - Pooled with lags, gdp, urbanization and population
logit demcz_bmr urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id) , if omitdems==0
estimates store m2 

*3.3 DOMINATE - Pooled with lags, gdp, urbanization and population, region dummies
xtlogit demcz_  urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe,  if omitdems==0
estimates store m3 


*3.4 DOMINATE - YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtlogit demcz_bmr urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani  i.year , fe , if omitdems==0
estimates store m4 

*3.1 DOMINATE - Pooled with only lags
set more off
regress F.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy  ,  cluster(country_id)
estimates store m5

*3.2 DOMINATE - Pooled with lags, gdp, urbanization and population
regress F.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id)
estimates store m6 

*3.3 DOMINATE - Pooled with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani , fe 
estimates store m7 


*3.4 DOMINATE - YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.year , fe
estimates store m8 

esttab m1 m2 m3 m4 m5 m6 m7 m8  using "C:\Users\siriad\Dropbox\CHK, TW og SD\Opposition movements\Tables\tab1.tex", replace style(tex) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)



*********************************************************************************************************
**************                   ROBUSTNESS TABLE                                 ***********************
*********************************************************************************************************


*TAB 4 - Robustness


*Polyarchy t+5
set more off
xtreg F5.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store r1 

*Polyarchy t+2
xtreg F2.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store r2

*post-treatment controls
xtreg F.v2x_polyarchy urban_dominate indwork_dominate lmembers regviol campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store r3

*originate
xtreg F.v2x_polyarchy originate_urban originate_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store r4

*dropping uncertain cases
xtreg F.v2x_polyarchy urban_dominate indwork_dominate lmembers regviol campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe , if security2!=0
estimates store r5

*split sample post-pre 1960
xtreg F.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe , if year>1960
estimates store r6

xtreg F.v2x_polyarchy urban_dominate indwork_dominate campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe , if year<1960
estimates store r7

*controlling for group number
xtreg F.v2x_polyarchy urban_dominate indwork_dominate classcoalitions campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store r8


esttab r1 r2 r3 r4 r5 r6 r7 r8  using "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\tab2robustness.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)



*********************************************************************************************************
**************                   ENDOGENEITY                                      ***********************
*********************************************************************************************************

*2SLS - allurban
set more off
xtivreg2 F.v2x_polyarchy urban_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean (urban_index = urbreg_mean indreg_mean) , fe cluster(country_id)
estimates store m1e 


*First stage - midclass
xtreg urbreg_mean indreg_mean campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store m2e 

*2SLS - midclass
set more off
xtivreg2 F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean (midclass_index = urbreg_mean) , fe cluster(country_id)
estimates store m1e 


*First stage - midclass
xtreg midclass_index urbreg_mean worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani indreg_mean campaigns_mean  v2x_polyarchy_n_mean , fe cluster(country_id)
estimates store m2e 

*2.3 2SLS - workers
xtivreg2 F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean (worker_index = indreg_mean) , fe cluster(country_id)
estimates store m3e 

*First stage - workers
xtreg worker_index indreg_mean midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani urbreg_mean campaigns_mean  v2x_polyarchy_n_mean, fe cluster(country_id)
estimates store m4e 



esttab m1e m2e m3e m4e using "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\IVtab.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)








































**TAB 2 - ORIGINATE

*1.1 Pooled with only lags
set more off
regress F.v2x_polyarchy originate_urban originate_indwork campaign L1.v2x_polyarchy  ,  cluster(country_id)
estimates store m1b 

*1.2  Pooled with lags, gdp, urbanization and population
regress F.v2x_polyarchy originate_urban originate_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id)
estimates store m2b 

*1.3 Pooled with lags, gdp, urbanization and population, region dummies
regress F.v2x_polyarchy originate_urban originate_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 , cluster(country_id)
estimates store m3b 

*1.4 COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy originate_urban originate_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 , fe
estimates store m4b 

*1.5 YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy originate_urban originate_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store m5b 


esttab m1b m2b m3b m4b m5b  using "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\tab2.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)



**TAB 3 - PARTICIPATE

*1.1 Pooled with only lags
set more off
regress F.v2x_polyarchy atleast_urban atleast_indwork campaign L1.v2x_polyarchy  ,  cluster(country_id)
estimates store m1c 

*1.2  Pooled with lags, gdp, urbanization and population
regress F.v2x_polyarchy atleast_urban atleast_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id)
estimates store m2c 

*1.3 Pooled with lags, gdp, urbanization and population, region dummies
regress F.v2x_polyarchy atleast_urban atleast_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 , cluster(country_id)
estimates store m3c 

*1.4 COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy atleast_urban atleast_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 , fe
estimates store m4c 

*1.5 YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy atleast_urban atleast_indwork campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store m5c 


esttab m1c m2c m3c m4c m5c  using "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\tab3.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)



**TAB 4 - Indices

*1.1 Pooled with only lags
set more off
regress F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy  ,  cluster(country_id)
estimates store m1d 

*1.2  Pooled with lags, gdp, urbanization and population
regress F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani ,  cluster(country_id)
estimates store m2d 

*1.3 Pooled with lags, gdp, urbanization and population, region dummies
regress F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 , cluster(country_id)
estimates store m3d 

*1.4 COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 , fe
estimates store m4d 

*1.5 YEAR+COUNTRY-FE with lags, gdp, urbanization and population, region dummies
xtreg F.v2x_polyarchy midclass_index worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani i.e_region_world_2 i.year , fe
estimates store m5d 


esttab m1d m2d m3d m4d m5d  using "C:\Users\torewig\Dropbox\Samarbeid\CHK, TW og SD\Opposition movements\Tables\tab4.tex", replace style(tex) nogaps compress mtitles label stats(N countryfixed regionfixed yearfixed)




*********************************************************************
*************     WHAT DETERMINES SOCIAL COMPOSITION      ***********
*********************************************************************

regress worker_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani year , cluster(country_id)

regress midclass_index campaign L1.v2x_polyarchy e_migdppcln e_mipopulaln e_miurbani year , cluster(country_id)


*****************************************************************
**************       POLYARCHY MODELS     ***********************
*****************************************************************
