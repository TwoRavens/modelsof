/* This do-file creates the results in Columns 1, 3 and 4 of Table 8 in 
Costinot, Donaldson, Kyle and Williams (QJE, 2019)
*/ 

***Preamble***

capture log close
*Set log
log using "${log_dir}tab8.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${finalsavedir}clean_rect_sales_sq_gdppc_final.dta", clear

***Prepare data***

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry


********* Column (1) - baseline 

reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIIColIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIIColIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIIColIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIIColIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIIColIRsq = round(e(r2_a), 0.001)
scalar TabVIIIColIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIIColIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)

*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIIColIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse


********* Column (3) - positive sales dummy as dependent variable
reghdfe sales_dummy lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIIColIIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIIColIIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIIColIIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIIColIIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIIColIIIRsq = round(e(r2_a), 0.001)
scalar TabVIIIColIIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIIColIIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIIColIIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



********* Column (4) - positive sales dummy as dependent variable, and control for GDP-interactions

reghdfe sales_dummy lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country c.gdppc_sales##gbd c.gdppc_dest##gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIIColIVPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIIColIVPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIIColIVPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIIColIVPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIIColIVRsq = round(e(r2_a), 0.001)
scalar TabVIIIColIVObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIIColIVPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIIColIVPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse


scalar list

log close

