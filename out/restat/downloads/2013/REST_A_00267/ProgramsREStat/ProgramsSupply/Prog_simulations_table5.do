/***Program to implement simulations of Table 5:Percentage Change of Retail Price with Cost Increase of 10%***/
cd c:\Celine\Recherche\bdv\Data
/*
/**Pre-merger**/
/*Linear pricing*/
do bdv_simulRPM_LP_premerger.do
do bdv_simulRPM_LP_premerger_cost10.do

/*Non linear pricing with uniform pricing*/
do bdv_simulRPM_WRPM_unif_premerger.do
do bdv_simulRPM_WRPM_unif_premerger_cost10.do

/*Non linear pricing & Resale price maintenance with uniform pricing*/
do bdv_simulRPM_unif_premerger.do
do bdv_simulRPM_unif_premerger_cost10.do


/**Post merger & elast=-4*/
/*Linear pricing*/
do bdv_simulRPM_LP_alpha75.do
do bdv_simulRPM_LP_alpha75_cost10.do

/*Non linear pricing with uniform pricing*/
do bdv_simulRPM_unif_premerger_alpha75.do
do bdv_simulRPM_unif_premerger_alpha75_cost10.do

/*Non linear pricing & Resale price maintenance with uniform pricing*/
do bdv_simulRPM_WRPM_unif_alpha75.do
do bdv_simulRPM_WRPM_unif_alpha75_cost10.do


/**Post merger & elast=-3*/
/*Linear pricing*/
do bdv_simulRPM_LP_alpha50.do
do bdv_simulRPM_LP_alpha50_cost10.do

/*Non linear pricing with uniform pricing*/
do bdv_simulRPM_unif_premerger_alpha50.do
do bdv_simulRPM_unif_premerger_alpha50_cost10.do

/*Non linear pricing & Resale price maintenance with uniform pricing*/
do bdv_simulRPM_WRPM_unif_alpha50.do
do bdv_simulRPM_WRPM_unif_alpha50_cost10.do
*/


/*Merge of all files*/
use simulRPM_unif_alpha50.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_alpha50
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_unif_alpha75.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_alpha75
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_LP_alpha50.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_alpha50
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_LP_alpha75.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_alpha75
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace


use simulRPM_LP_premerger.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_premerger
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace


use simulRPM_unif_premerger.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_premerger
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace


use simulRPM_WRPM_unif_alpha50.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_alpha50
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_WRPM_unif_alpha75.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_alpha75
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_WRPM_unif_premerger.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_premerger
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_unif_alpha50_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_alpha50_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_unif_alpha75_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_alpha75_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_LP_alpha50_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_alpha50_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_LP_alpha75_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_alpha75_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_LP_premerger_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_premerger_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace


use simulRPM_unif_premerger_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_premerger_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace


use simulRPM_WRPM_unif_alpha50_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_alpha50_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_WRPM_unif_alpha75_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_alpha75_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

use simulRPM_WRPM_unif_premerger_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_premerger_cost10
merge trend productid using simuls10.dta
capture drop _merge
sort trend productid 
save simuls10.dta,replace

gen diff10RPM_LP_premerger=(priceRPM_LP_premerger-priceRPM_LP_premerger_cost10)/priceRPM_LP_premerger
gen diff10RPM_LP_alpha75=(priceRPM_LP_alpha75-priceRPM_LP_alpha75_cost10)/priceRPM_LP_alpha75
gen diff10RPM_LP_alpha50=(priceRPM_LP_alpha50-priceRPM_LP_alpha50_cost10)/priceRPM_LP_alpha50

gen diff10WRPM_premerger=(priceWRPM_unif_premerger-priceWRPM_unif_premerger_cost10)/priceWRPM_unif_premerger
gen diff10WRPM_alpha75=(priceWRPM_unif_alpha75-priceWRPM_unif_alpha75_cost10)/priceWRPM_unif_alpha75
gen diff10WRPM_alpha50=(priceWRPM_unif_alpha50-priceWRPM_unif_alpha50_cost10)/priceWRPM_unif_alpha50

gen diff10RPM_unif_premerger=(priceRPM_unif_premerger-priceRPM_unif_premerger_cost10)/priceRPM_unif_premerger
gen diff10RPM_unif_alpha75=(priceRPM_unif_alpha75-priceRPM_unif_alpha75_cost10)/priceRPM_unif_alpha75
gen diff10RPM_unif_alpha50=(priceRPM_unif_alpha50-priceRPM_unif_alpha50_cost10)/priceRPM_unif_alpha50

sum diff*
