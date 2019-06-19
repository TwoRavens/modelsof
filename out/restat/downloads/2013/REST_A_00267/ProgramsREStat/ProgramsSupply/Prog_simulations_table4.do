/***Program to implement simulations of Table 4:The Role of Non
Linear Pricing and Vertical Restraints on Pass- Through from a
raw coffee cost shock***/

cd c:\Celine\Recherche\bdv\Data


/*Linear pricing*/
do bdv_simul_LP_cost10_RC.do

/*Non linear pricing & Resale price maintenance with uniform pricing*/
do bdv_simulRPM_unif_cost10_RC.do

/*Non linear pricing & Resale price maintenance*/
do bdv_simulRPM_cost10_RC.do

/*Non linear pricing  with uniform
pricing*/
do bdv_simulWRPM_unif_cost10_RC.do

/*Non linear pricing*/
do bdv_simulWRPM_cost10_RC.do



/*Merge of all files*/
use c:\Celine\Recherche\bdv\Data\simulRPM_unif.dta
keep trend productid price retailer brand
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace


use c:\Celine\Recherche\bdv\Data\simulRPM.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace

use c:\Celine\Recherche\bdv\Data\simulRPM_LP.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceLP
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace

use c:\Celine\Recherche\bdv\Data\simulRPM_WRPM.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace

use c:\Celine\Recherche\bdv\Data\simulRPM_WRPM_unif.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace



use  simulRPM_cost10_RC.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_cost10_RC
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_unif_cost10_RC.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_cost10_RC
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_LP_cost10_RC.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_LP_cost10_RC
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_WRPM_cost_RC.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_WRPM_cost10_RC
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

use  simulRPM_WRPM_unif_cost10_RC.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_WRPM_unif_cost10_RC
merge trend productid using  simuls10.dta
capture drop _merge
sort trend productid 
save  simuls10.dta,replace

gen diff10RPM_LP_RC=-(priceLP-priceRPM_LP_cost10_RC)/priceLP
gen diff10RPM_unif_RC=-(price-priceRPM_unif_cost10_RC)/price
gen diff10RPM_RC=-(priceRPM-priceRPM_cost10_RC)/priceRPM
gen diff10RPM_WRPM_unif_RC=-(priceWRPM_unif-priceRPM_WRPM_unif_cost10_RC)/priceWRPM_unif
gen diff10RPM_WRPM_RC=-(priceWRPM-priceRPM_WRPM_cost10_RC)/priceWRPM



sum diff*
tab brand,sum(diff10RPM_LP_RC)
tab brand,sum(diff10RPM_unif_RC)
tab brand,sum(diff10RPM_RC)
tab brand,sum(diff10RPM_WRPM_unif_RC)
tab brand,sum(diff10RPM_WRPM_RC)

tab retailer,sum(diff10RPM_LP_RC)
tab retailer,sum(diff10RPM_unif_RC)
tab retailer,sum(diff10RPM_RC)
tab retailer,sum(diff10RPM_WRPM_unif_RC)
tab retailer,sum(diff10RPM_WRPM_RC)
