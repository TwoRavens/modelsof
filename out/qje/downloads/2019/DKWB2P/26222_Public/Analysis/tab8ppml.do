/* This do-file replicates the results in Table 8 (column 2) of Costinot, Donaldson, Kyle and Williams (QJE, 2019)
This specification employs a PPML estimator that can be slow to run.
*/ 

***Preamble***

set matsize 4000
capture log close
*Set log
log using "${log_dir}tab8ppml.log", replace

*Reset output variables
scalar drop _all

*Load Data
import delimited using "${finalsavedir}data_for_zeros_check.csv", clear

***Prepare data***

*Drop Sales of countries to itself
drop if sales_ctry == dest_ctry


*generate dummies
qui tab sales_and_dest, gen(sddummy)
qui tab gbd, gen(gdummy)

****** Column (2) - PPML estimator (with two-way clustered SEs computed following procedure in Cameron, Gelbach and Miller (NBER twp, 2006)

ppml sales_mnf_usd lndaly_p_dest lndaly_p_sales sddummy* gdummy*, cluster(dest_country) showstep
scalar TabVIIIColIIPDBDVal1 = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIIColIIPDBDSE1 = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIIColIIPDBOVal1 = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIIColIIPDBOSE1 = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIIColIIRsq1 = round(((e(r2))*(e(N)-1))/(e(N)-e(k)-1), 0.001)
scalar TabVIIIColIIObs1 = e(N)

matrix cov = get(VCE)
*Get Beta_XM SE
scalar cov221 = cov[2,2]
scalar cov111 = cov[1,1]
scalar cov211 = cov[2,1]


ppml sales_mnf_usd lndaly_p_dest lndaly_p_sales sddummy* gdummy*, cluster(sales_country) showstep
scalar TabVIIIColIIPDBDVal2 = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIIColIIPDBDSE2 = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIIColIIPDBOVal2 = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIIColIIPDBOSE2 = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIIColIIRsq2 = round(((e(r2))*(e(N)-1))/(e(N)-e(k)-1), 0.001)
scalar TabVIIIColIIObs2 = e(N)

matrix cov = get(VCE)
*Get Beta_XM SE
scalar cov222 = cov[2,2]
scalar cov112 = cov[1,1]
scalar cov212 = cov[2,1]


ppml sales_mnf_usd lndaly_p_dest lndaly_p_sales sddummy* gdummy*, cluster(sales_and_dest) showstep
scalar TabVIIIColIIPDBDVal3 = round(_b[lndaly_p_dest], 0.001)
scalar TabVIIIColIIPDBDSE3 = round(_se[lndaly_p_dest], 0.001)
scalar TabVIIIColIIPDBOVal3 = round(_b[lndaly_p_sales], 0.001)
scalar TabVIIIColIIPDBOSE3 = round(_se[lndaly_p_sales], 0.001)
scalar TabVIIIColIIRsq3 = round(((e(r2))*(e(N)-1))/(e(N)-e(k)-1), 0.001)
scalar TabVIIIColIIObs3 = e(N)

matrix cov = get(VCE)
*Get Beta_XM SE
scalar cov223 = cov[2,2]
scalar cov113 = cov[1,1]
scalar cov213 = cov[2,1]

scalar salesV = scalar(cov221) + scalar(cov222) - scalar(cov223)
scalar destV = scalar(cov111) + scalar(cov112) - scalar(cov113)
scalar salesdestV = scalar(cov211) + scalar(cov212) - scalar(cov213)
scalar salesSE = round(sqrt(scalar(cov221) + scalar(cov222) - scalar(cov223)),0.001)
di sqrt(scalar(cov221) + scalar(cov222) - scalar(cov223))
scalar destSE = round(sqrt(scalar(cov111) + scalar(cov112) - scalar(cov113)),0.001)
di sqrt(scalar(cov111) + scalar(cov112) - scalar(cov113))



*Get Weak HME P-Value
*Calculate one-sided t-test for beta_X <= 0
scalar TabVIIIColIIPweak = round((ttail(e(df), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/sqrt(salesV)))), 0.001)
di (ttail(e(df), sign(_b[lndaly_p_sales])*abs(_b[lndaly_p_sales]/sqrt(salesV))))
*Get Strong HME P-Value
*Calculate one-sided F-test for beta_X - beta_M <= 0
*Get Beta_XM mean
scalar betaxm = _b[lndaly_p_sales]-_b[lndaly_p_dest]
*Get Beta_XM SE
scalar betaxmse = sqrt(salesV + destV - 2*salesdestV)
*Get F-test p-value
scalar TabVIIIColIIPstrong = round((ttail(e(df), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse)))), 0.001)
di (ttail(e(df), sign(scalar(betaxm))*abs(scalar(betaxm)/scalar(betaxmse))))

scalar TabVIIIColIIObs = scalar(TabVIIIColIIObs1)
scalar TabVIIIColIIRsq = scalar(TabVIIIColIIRsq1)
scalar TabVIIIColIIPDBOVal = scalar(TabVIIIColIIPDBOVal1)
scalar TabVIIIColIIPDBDVal = scalar(TabVIIIColIIPDBDVal1)

*Drop unneeded scalars
scalar drop betaxm betaxmse cov111 cov112 cov113 cov211 cov212 cov213 cov221 cov222 cov223
scalar drop TabVIIIColIIRsq1 TabVIIIColIIRsq2 TabVIIIColIIRsq3
scalar drop TabVIIIColIIPDBOVal1 TabVIIIColIIPDBOVal2 TabVIIIColIIPDBOVal3 TabVIIIColIIPDBDVal1 TabVIIIColIIPDBDVal2 TabVIIIColIIPDBDVal3
scalar drop TabVIIIColIIPDBDSE1 TabVIIIColIIPDBOSE1 TabVIIIColIIPDBDSE2 TabVIIIColIIPDBOSE2 TabVIIIColIIPDBDSE3 TabVIIIColIIPDBOSE3
scalar drop salesV destV salesdestV

 
scalar list

log close
