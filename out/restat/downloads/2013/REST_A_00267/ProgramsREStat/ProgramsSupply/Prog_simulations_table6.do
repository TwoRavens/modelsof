/***Program to implement simulations of Table 5:Percentage Change of Retail Price with Cost Increase of 10% with
Varying Market Size***/
cd c:\Celine\Recherche\bdv\Data
/*
/**Change in market size**/
/*Linear pricing*/
do bdv_simulRPM_LP_MS.do
do bdv_simulRPM_LP_MS_cost10.do

/*Non linear pricing with uniform pricing*/
do bdv_simulRPM_WRPM_unif_MS.do
do bdv_simulRPM_WRPM_unif_MS_cost10.do

/*Non linear pricing & Resale price maintenance with uniform pricing*/
do bdv_simulRPM_unif_MS.do
do bdv_simulRPM_unif_MS_cost10.do
*/





/*Merge of all files*/
use  simulRPM_unif_MS.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_MS
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_unif_MS_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_MS_cost10
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_WRPM_unif_MS.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_WRPM_unif_MS
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_WRPM_unif_MS_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_WRPM_unif_MS_cost10
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_LP_MS.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_MS
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_LP_MS_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_MS_cost10
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

gen diff10RPM_LP_MS=(priceRPM_LP_MS-priceRPM_LP_MS_cost10)/priceRPM_LP_MS
gen diff10RPM_WRPM_MS=(priceRPM_WRPM_unif_MS-priceRPM_WRPM_unif_MS_cost10)/priceRPM_WRPM_unif_MS
gen diff10RPM_unif_MS=(priceRPM_unif_MS-priceRPM_unif_MS_cost10)/priceRPM_unif_MS

sum diff*
