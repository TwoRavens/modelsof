/* This do-file creates the results in Table 7 in Costinot, Donaldson, Kyle and Williams (QJE, 2019)
*/ 

***Preamble***

capture log close
*Set log
log using "${log_dir}tab7.log", replace

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


******** Column (1) - baseline


reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIColIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIColIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIColIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIColIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIColIRsq = round(e(r2_a), 0.001)
scalar TabVIIColIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIColIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)

*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIColIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse





******** Column (2) - EU destinations only

*Drop non-EU (ESM) destinations
drop if dest_EU == 0

reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIColIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIColIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIColIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIColIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIColIIRsq = round(e(r2_a), 0.001)
scalar TabVIIColIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIColIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIColIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



******** Column (3) - below median FDI share

*Prepare Data
restore
preserve

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

*Sum sales over origin-destination pairs
collapse (sum) sales_mnf_usd, by(sales_ctry dest_ctry)
rename sales_ctry exporter
rename dest_ctry importer

*Merge in import data
merge 1:m exporter importer using "${finalsavedir}final_bilateral_imports.dta"

*Drop unused stuff
drop if _m != 3
drop if industry != "Basic pharmaceutical products and pharmaceutical preparations"
drop if enduse != "Total trade in goods"

*Generate ratio
gen ratio = value/sales_mnf_usd
drop if mi(ratio)

*Testing commands
order exporter importer sales_mnf_usd value ratio
sort ratio
gen expimp = exporter + importer
distinct expimp

*Drop below median ratios
summarize ratio, detail
drop if ratio < r(p50)

*remerge main data
keep exporter importer ratio
rename exporter sales_ctry
rename importer dest_ctry
merge 1:m sales_ctry dest_ctry using "${finalsavedir}main_final_dataset.dta"
drop if _m != 3

reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIColIIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIColIIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIColIIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIColIIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIColIIIRsq = round(e(r2_a), 0.001)
scalar TabVIIColIIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIColIIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIColIIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse





***** Column  (4) - PDB from 1996 demographics

*Prepare Data
restore
preserve
*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry


reghdfe lnsales lndaly_p_dest_lagged lndaly_p_sales_lagged, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVIIColIVPDBDVal = round(_b[lndaly_p_dest_lagged], 0.001)
scalar TabVIIColIVPDBDSE = round(_se[lndaly_p_dest_lagged], 0.001)
scalar TabVIIColIVPDBOVal = round(_b[lndaly_p_sales_lagged], 0.001)
scalar TabVIIColIVPDBOSE = round(_se[lndaly_p_sales_lagged], 0.001)
scalar TabVIIColIVRsq = round(e(r2_a), 0.001)
scalar TabVIIColIVObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIColIVPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales_lagged])*abs(_b[lndaly_p_sales_lagged]/_se[lndaly_p_sales_lagged]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales_lagged]-_b[lndaly_p_dest_lagged]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIColIVPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse


******** Column (5) - include home sales observations

*Prepare data
restore
preserve

*Reduce to square dataset
drop if square_dataset != 1

reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)

*Save variables as scalars
scalar TabVIIColVPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIColVPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIColVPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIColVPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIColVRsq = round(e(r2_a), 0.001)
scalar TabVIIColVObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIColVPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVIIColVPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



scalar list

log close
