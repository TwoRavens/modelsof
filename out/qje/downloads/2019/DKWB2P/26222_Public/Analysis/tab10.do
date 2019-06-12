/* This do-file replicates the results in Table 10 of Costinot, Donaldson, Kyle and Williams (QJE, 2019) */

***Preamble***

capture log close
*Set log
log using "${log_dir}tab10.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}main_final_dataset.dta", clear


***Prepare data***

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry



******** Column  (1) - first stage of IV

reghdfe lnsales_sales_gbd lndaly_p_sales, absorb(dest_country#sales_country dest_country#gbd gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabXColIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabXColIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabXColIRsq = round(e(r2_a), 0.001)
scalar TabXColIObs = e(N)
scalar TabXIVFStatistic = round(e(F), 0.1)


******** Column (2) - OLS
reghdfe lnsales lnsales_sales_gbd, absorb(dest_country#sales_country dest_country#gbd gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabXColIILnTotalSalesVal = round(_b[lnsales_sales_gbd], 0.001)
scalar TabXColIILnTotalSalesSE = round(_se[lnsales_sales_gbd], 0.001)
scalar TabXColIIRsq = round(e(r2_a), 0.001)
scalar TabXColIIObs = e(N)


******** Column (3) - IV
reghdfe lnsales (lnsales_sales_gbd=lndaly_p_sales), absorb(dest_country#sales_country dest_country#gbd gbd) vce(cluster sales_country dest_country) stages(first)
scalar TabXColIIILnTotalSalesVal = round(_b[lnsales_sales_gbd], 0.001)
scalar TabXColIIILnTotalSalesSE = round(_se[lnsales_sales_gbd], 0.001)
scalar TabXColIIIRsq = round(e(r2_a), 0.001)
scalar TabXColIIIObs = e(N)

*Get p-value for H0 that: log(total_sales) = 1 
test _b[lnsales_sales_gbd] = 1
scalar TabXColIIIPVal = round(r(p), 0.001)



scalar list

log close

