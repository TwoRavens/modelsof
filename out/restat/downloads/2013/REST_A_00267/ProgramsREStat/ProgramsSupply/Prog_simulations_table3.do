/***Program to implement simulations of Table 3: Percentage of
Retail Price change with 10 Percent Increase of Total marginal
cost ***/



/*Linear pricing*/ 
do bdv_simul_LP.do 
do bdv_simul_LP_cost10.do

/*Non linear pricing & Resale price maintenance with uniform pricing*/
do bdv_simulRPM_unif_cost10.do

/*Non linear pricing & Resale price maintenance*/
do bdv_simulRPM.do
do bdv_simulRPM_cost10.do

/*Non linear pricing  with uniform pricing*/
do bdv_simulWRPM_unif.do
do bdv_simulWRPM_unif_cost10.do

/*Non linear pricing*/
do bdv_simulWRPM.do
do bdv_simulWRPM_cost10.do



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


use c:\Celine\Recherche\bdv\Data\simulRPM_unif_cost.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_unif_cost10
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace

use c:\Celine\Recherche\bdv\Data\simulRPM_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceRPM_cost10
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace

use c:\Celine\Recherche\bdv\Data\simulRPM_LP_cost10.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceLP_cost10
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace


use c:\Celine\Recherche\bdv\Data\simulRPM_WRPM_cost.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_cost10
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace


use c:\Celine\Recherche\bdv\Data\simulRPM_WRPM_unif_cost.dta,clear
keep trend productid price_sim retailer brand
sort trend productid 
rename price_sim priceWRPM_unif_cost10
merge trend productid using c:\Celine\Recherche\bdv\Data\simuls10.dta
capture drop _merge
sort trend productid 
save c:\Celine\Recherche\bdv\Data\simuls10.dta,replace




gen diff10LP=-(priceLP-priceLP_cost10)/priceLP
gen diff10RPM_unif=-(price-priceRPM_unif_cost10)/price
gen diff10RPM=-(priceRPM-priceRPM_cost10)/priceRPM
gen diff10WRPM_unif=-(priceWRPM_unif-priceWRPM_unif_cost10)/priceWRPM_unif
gen diff10WRPM=-(priceWRPM-priceWRPM_cost10)/priceWRPM


sum diff* if diff10LP!=. & diff10RPM_unif!=. & diff10RPM!=. & diff10WRPM_unif!=. & diff10WRPM!=. & diff10LP<1 & diff10RPM_unif<1 & diff10RPM<1 & diff10WRPM_unif<1 & diff10WRPM<1
tab brand,sum(diff10LP)
tab brand,sum(diff10RPM_unif)
tab brand,sum(diff10RPM)
tab brand,sum(diff10WRPM_unif)
tab brand,sum(diff10WRPM)

tab retailer,sum(diff10LP)
tab retailer,sum(diff10RPM_unif)
tab retailer,sum(diff10RPM)
tab retailer,sum(diff10WRPM_unif)
tab retailer,sum(diff10WRPM)
