/* This do-file creates the results in Table 6 of Costinot, Donaldson, Kyle and Williams (QJE, 2019)
*/ 

***Preamble***

capture log close
*Set log
log using "${log_dir}tab6.log", replace

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




************* Column (1) - baseline
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIColIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIColIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIColIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIColIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIColIRsq = round(e(r2_a), 0.001)
scalar TabVIColIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIColIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)

*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIColIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



************* Column (2) - pairs only beyond 1000 km
*Drop countries that are too close (1000 km)
drop if distw < 1000


reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIColIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIColIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIColIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIColIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIColIIRsq = round(e(r2_a), 0.001)
scalar TabVIColIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIColIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIColIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



************* Column (3) - pairs only beyond 2000 km

*Prepare data
restore
preserve

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

*Drop countries that are too close (2000 km)
drop if distw < 2000

reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIColIIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIColIIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIColIIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIColIIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIColIIIRsq = round(e(r2_a), 0.001)
scalar TabVIColIIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIColIIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIColIIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse




************* Column (4) - control for MA terms

*Prepare data
restore
preserve

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry
********************************************************************************
reghdfe lnsales lndaly_p_dest lndaly_p_sales lndaly_p_dest_neighbors lndaly_p_sales_neighbors, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIColIVPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIColIVPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIColIVPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIColIVPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIColIVPDBDNeighbourVal = round(_b[lndaly_p_dest_neighbors], 0.001)
scalar TabVIColIVPDBDNeighbourSE = round(_se[lndaly_p_dest_neighbors], 0.001)
scalar TabVIColIVPDBONeighbourVal = round(_b[lndaly_p_sales_neighbors], 0.001)
scalar TabVIColIVPDBONeighbourSE = round(_se[lndaly_p_sales_neighbors], 0.001)
scalar TabVIColIVRsq = round(e(r2_a), 0.001)
scalar TabVIColIVObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIColIVPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIColIVPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



scalar list


log close
