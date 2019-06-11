/* This do-file creates the results in Table 4 in Costinot, Donaldson, Kyle and Williams (QJE, 2019) */  

***Preamble***

capture log close
*Set log
log using "${log_dir}tab4.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}main_final_dataset.dta", clear
preserve

***Prepare data***

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry



******** MAKE TABLE 4 ********

* Column (1) 
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabIVColIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabIVColIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabIVColIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabIVColIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabIVColIRsq = round(e(r2_a), 0.001)
scalar TabIVColIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabIVColIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)

*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabIVColIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)


* Column (2)
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country c.gdppc_sales##gbd c.gdppc_dest##gbd) vce(cluster sales_country dest_country)
scalar TabIVColIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabIVColIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabIVColIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabIVColIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabIVColIIRsq = round(e(r2_a), 0.001)
scalar TabIVColIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabIVColIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabIVColIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse


* Column (3)
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country sales_country#daly_groups dest_country#daly_groups gbd) vce(cluster sales_country dest_country)
scalar TabIVColIIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabIVColIIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabIVColIIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabIVColIIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabIVColIIIRsq = round(e(r2_a), 0.001)
scalar TabIVColIIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabIVColIIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabIVColIIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse


scalar list

log close

