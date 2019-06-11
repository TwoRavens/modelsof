/* This do-file creates the results in Table 5 of Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 

***Preamble***

capture log close
*Set log
log using "${log_dir}tab5.log", replace

*Reset output variables
scalar drop _all

***Prepare data***
*Create crosswalk data-file
import excel using "${gbd_nih_xwalk}gbd_descriptions_filled.xlsx", firstrow clear
drop name
save "${intersavedir}gbd_nih_crosswalk.dta", replace

*get NIH subsidies per ic code
use "${nih}extract_ist.dta"
*only keep latest year
drop if year != 45
*sum
collapse (sum) totdol_ist, by(ic)

tempfile temp1
save `temp1'

*Load regression data
use "${finalsavedir}clean_rect_sales_sq_gdppc_final.dta"

*merge NIH ic codes into main data
merge m:1 gbd_code using "${intersavedir}gbd_nih_crosswalk.dta"
drop _m

preserve
*aggregate disease burden to NIH disease level for destination countries
drop if dest_ctry == "USA"
collapse (sum) sales_mnf_usd daly_p_dest, by(ic dest_country)
gen lndaly_p_dest = log(daly_p_dest)

tempfile temp2
save `temp2'

restore
preserve
*aggregate disease burden for the US
drop if sales_ctry != "USA"
collapse (sum) daly_p_sales, by(ic sales_country)
gen lndaly_p_sales = log(daly_p_sales)

tempfile temp3
save `temp3'

*go back to regression data
restore

*drop if US is not origin
drop if sales_ctry != "USA"

*drop if destination is US
drop if dest_ctry == "USA"

*aggregate sales to NIH disease level for destination countries
collapse (sum) sales_mnf_usd, by(ic dest_country)
gen lnsales = log(sales_mnf_usd)

*merge predicted disease burdens back in
merge m:1 ic using `temp3'
drop _m
merge m:1 dest_country ic using `temp2'
drop _m

*merge subsidy data
merge m:1 ic using `temp1'
*drop unmatched
drop if _m != 3
drop _m

*get numeric ic codes for regression
rename ic ic_code
encode ic_code, gen(ic)

***Regressions***

*Column (2) - main, but only within US
reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(dest_country) vce(cluster dest_country)
scalar TabVColIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVColIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVColIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVColIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVColIIRsq = round(e(r2_a), 0.001)
scalar TabVColIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVColIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
di (ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales])))
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVColIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)
di (ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse))))

*Drop unneeded scalars
scalar drop betaxm betaxmse




*Column (3) - within US, and with NIH subsidy Control
********************************************************************************
*Prepare data
*rescale subsidies to proper scale and log
gen lnsubsidy = log(totdol_ist)

reghdfe lnsales lndaly_p_dest lndaly_p_sales lnsubsidy, absorb(dest_country) vce(cluster dest_country)
scalar TabVColIIIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVColIIIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVColIIIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVColIIIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVColIIISubVal = round(_b[lnsubsidy], 0.001)
scalar TabVColIIISubSE = round(_se[lnsubsidy], 0.001)
scalar TabVColIIIRsq = round(e(r2_a), 0.001)
scalar TabVColIIIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVColIIIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
di (ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales])))
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value 
scalar TabVColIIIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)
di (ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse))))

*Drop unneeded scalars
scalar drop betaxm betaxmse




*Column (1) - baseline
********************************************************************************
*Prepare data
clear
use "${finalsavedir}main_final_dataset.dta"
preserve

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry


reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVColIPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVColIPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVColIPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVColIPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVColIRsq = round(e(r2_a), 0.001)
scalar TabVColIObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVColIPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)

*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVColIPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



*Column (4) - only generic drugs
********************************************************************************

reghdfe lnsales_generic lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVColIVPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVColIVPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVColIVPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVColIVPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVColIVRsq = round(e(r2_a), 0.001)
scalar TabVColIVObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVColIVPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value 
scalar TabVColIVPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse





*Column (5) - drop richest 1/3 of origin countries
********************************************************************************

*Prepare data
restore
preserve

*Reduce to square dataset
drop if square_dataset != 1

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry

*Drop 1/3 richest origins by p.c. GDP
quietly{
gen minusgdppc_sales = -gdppc_sales
sort minusgdppc_sales
gen origin_top = 0
replace origin_top = 1 if _n ==1
local counter = 1
forval i = 2/`=_N' {
if minusgdppc_sales[`i'] != minusgdppc_sales[`i'-1]{
local counter = `counter' + 1
}
replace origin_top = `counter' if _n == `i'
}

distinct sales_ctry
local numorigin = r(ndistinct)

drop if origin_top < `numorigin'/3
}


reghdfe lnsales lndaly_p_dest lndaly_p_sales, absorb(sales_country#dest_country gbd) vce(cluster sales_country dest_country)
*Save variables as scalars
scalar TabVColVPDBDVal = round(_b[lndaly_p_dest], 0.001)
scalar TabVColVPDBDSE = round(_se[lndaly_p_dest], 0.001)
scalar TabVColVPDBOVal = round(_b[lndaly_p_sales], 0.001)
scalar TabVColVPDBOSE = round(_se[lndaly_p_sales], 0.001)
scalar TabVColVRsq = round(e(r2_a), 0.001)
scalar TabVColVObs = e(N)

*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVColVPweak = round((ttail(e(df_r), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/_se[lndaly_p_sales]))), 0.001)
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
matrix cov = get(VCE)
*Get Beta_XM SE
scalar betaxmse = sqrt(cov[2,2] + cov[1,1] - 2*cov[2,1])
*Get F-test p-value
scalar TabVColVPstrong = round((ttail(e(df_r), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)

*Drop unneeded scalars
scalar drop betaxm betaxmse



scalar list

log close
