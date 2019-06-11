/* This do-file creates the results presented in Appendix Table B1 of Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 


***Preamble***

capture log close
*Set log
log using "${log_dir}tabB1.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}main_final_dataset.dta", clear
preserve

*******  Column (1)  ******* 

*Prepare data
*Square Dataset
drop if square_dataset != 1

*Drop observations without >0 sales
drop if sales_mnf_usd == 0
drop if mi(sales_mnf_usd)

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

*Get distinct destination country-disease pairs
gen destgbd = dest_ctry + gbd_code

distinct destgbd

duplicates drop destgbd, force

reghdfe lndaly_dest lndaly_p_dest, absorb(dest_country gbd) vce(cluster dest_country gbd)
scalar TabBIColIPDBVal = round(_b[lndaly_p_dest], 0.001)
scalar TabBIColIPDBSE = round(_se[lndaly_p_dest], 0.001)
scalar TabBIColIRsq = round(e(r2_a), 0.001)
scalar TabBIColIObs = e(N)




*******  Column (2)  ******* 

*Prepare data
restore
preserve
*Square Dataset
drop if square_dataset != 1

*Drop observations without sales
drop if sales_mnf_usd == 0
drop if mi(sales_mnf_usd)

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

*Get distinct destination country-disease pairs
gen salesgbd = sales_ctry + gbd_code
distinct salesgbd

duplicates drop salesgbd, force

reghdfe lndaly_sales lndaly_p_sales, absorb(sales_country gbd) vce(cluster sales_country gbd)
scalar TabBIColIIPDBVal = round(_b[lndaly_p_sales], 0.001)
scalar TabBIColIIPDBSE = round(_se[lndaly_p_sales], 0.001)
scalar TabBIColIIRsq = round(e(r2_a), 0.001)
scalar TabBIColIIObs = e(N)


scalar list

log close
