*use "Morgan_Kelly data.dta", clear
*all models estimated in Stata 14

set more off

******************Supplemental Table 1. Ethnic Marginalization and Trust in Parties
xtmixed b21 sociogen idiogen n9 presapproval cp7 cp8 quintall age edyears female chatt mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redis_polar_wt bgi_deci_fear_et_cen indigXbgi_deci_fear_et  || year: , cov(independent) || country_year: , cov(independent) var
estat vce, cov



**********************Supplemental Table 2. Traditional Political Economy Model
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid, i(countryyear year) dots family(binomial) link(logit)



********************Supplemental Table 3. Assessing Effects of BGI without Ethnic Fractionalization 
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen indigXbgi_deci_fear_et blackXbgi_deci_fear_et, i(countryyear year) dots family(binomial) link(logit)



********************Calculating mean support for redistribution
********************For creating scatterplots in Figures 2 & 3
#delimit ;


 local countrylist "
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 16
 17
 21
 ";
 
local yearlist "
2008
2010
 " ;
 
 #delimit cr
 foreach country of local countrylist {

display `country'
sum ros4_dich7 if pais==`country' & year==2008
sum ros4_dich7 if pais==`country' & year==2010

}

//

********************Supplemental Table 4. Ethnicity and National Identity
//Model 1
xtmixed b43 sociogen idiogen n9 presapproval quintall age edyears female chatt mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid bgi_deci_fear_et_cen indigXbgi_deci_fear_et || year: , cov(independent) || country_year: , cov(independent) var

//Model 2
xtmixed b43 sociogen idiogen n9 presapproval quintall age edyears female chatt mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid bgi_deci_fear_et_cen mestizoXbgi_deci_fear_et || year: , cov(independent) || country_year: , cov(independent) var



********************Supplemental Table 5. Adding Poverty as Predictor of Support for Redistribution
//Model 1
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen poverty_eclac, i(countryyear year) dots family(binomial) link(logit)

//Model 2
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen indigXbgi_deci_fear_et blackXbgi_deci_fear_et poverty_eclac, i(countryyear year) dots family(binomial) link(logit)

//Model 3
gllamm ros4_dich7 quintall sociogen idiogen chatt age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen poverty_eclac pov_eclacXpolar, i(countryyear year) dots family(binomial) link(logit)



********************Supplemental Table 6. Reduced Models 
//Model 1
gllamm ros4_dich7 quintall age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen, i(countryyear year) dots family(binomial) link(logit)

//Model 2
gllamm ros4_dich7 quintall age edyears female mestizo indig black mulatto otroethn gni_pc_1000 gini_gross_swid redistr_swid redis_polar_wt bgi_deci_fear_et_cen indigXbgi_deci_fear_et blackXbgi_deci_fear_et, i(countryyear year) dots family(binomial) link(logit)

//Model 3
gllamm ros4_dich7 quintall age edyears female mestizo indig black mulatto otroethn gni_pc_1000 bgi_deci_fear_et_cen lpb_cen redis_polar_wt_cen lpbXpolar_cen, i(countryyear year) dots family(binomial) link(logit)

********************Supplemental Tables 7-24. Analysis of Individual-level Effects by Country

#delimit ;


 local countrylist "
 1
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 16
 17
 21
 ";
#delimit cr
  
 foreach country of local countrylist {
 display `country'
 logit ros4_dich7 mestizo indig black mulatto otroethn quintall sociogen idiogen chatt age edyears female if pais==`country' & year==2008
   estimates store Model_`country'_08
 logit ros4_dich7 mestizo indig black mulatto otroethn quintall sociogen idiogen chatt age edyears female if pais==`country' & year==2010
   estimates store Model_`country'_10
 }
 *
**Separate analysis for Guatemala, where white is not a category
 logit ros4_dich7 indig black otroethn quintall sociogen idiogen chatt age edyears female if pais==2 & year==2008
 logit ros4_dich7 indig black otroethn quintall sociogen idiogen chatt age edyears female if pais==2 & year==2010











