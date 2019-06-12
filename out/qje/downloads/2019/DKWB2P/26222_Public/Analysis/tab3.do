/* This do-file creates the results presented in Table 3 and Footnote 28 of 
Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 

***Preamble***

capture log close
*Set log
log using "${log_dir}tab3.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}main_final_dataset.dta", clear


***Prepare data***

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry


***Regressions for Table 3***

*Column (1)
reghdfe lnsales lndaly_p_dest, absorb(sales_country#dest_country sales_country#gbd gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabIIIColIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabIIIColIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabIIIColIRsq = round(e(r2_a), 0.001)
scalar TabIIIColIObs = e(N)



*Column (2)
reghdfe lnsales lndaly_p_sales, absorb(sales_country#dest_country dest_country#gbd gbd) vce(cluster sales_country dest_country)
scalar TabIIIColIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)


*Save variables as scalars
scalar TabIIIColIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabIIIColIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabIIIColIIRsq = round(e(r2_a), 0.001)
scalar TabIIIColIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabIIIColIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)



*Column (3)
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabIIIColIIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabIIIColIIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabIIIColIIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabIIIColIIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabIIIColIIIRsq = round(e(r2_a), 0.001)
scalar TabIIIColIIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabIIIColIIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)

*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabIIIColIIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



*Extra regression clustering at disease level (Footnote 28):
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country#dest_country gbd)
*Save variables as scalars, only number of observations as local
scalar TabIIIColIIIPDBDSE_FN28 = round(_se[lndaly_p_dest], 0.001)
scalar TabIIIColIIIPDBOSE_FN28 = round(_se[lndaly_p_sales], 0.001)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabIIIColIIIPweak_FN28 = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided t-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get t-test p-value
scalar TabIIIColIIIPstrong_FN28 = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse

scalar list

log close





