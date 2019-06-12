******
*Regressions
*
*Industry-specific regressions, storing the results
******

clear 





*Do not run this file if we are using the AMECO list for industry tradability
if $ameco_list == 0 {
**********************************************************
*1. Industry-specific regressions
**********************************************************
use "$datadir/Data/ICP_WB/ICP_master.dta", clear


*Use all available countries that are in the master file
*There will be some countries in the master file for which we have no ICP data, but that's okay
preserve
use "$datadir/Data/output/master.dta"
keep if year == 2011
keep ctyc
tempfile a
save `a', replace
restore

*Merge in final data set for same countries
merge m:1 ctyc using `a'
keep if _merge == 3
drop _merge

keep if tradable == 0

gen inp_share = theta_ind - theta_N
gen gdp_interact = inp_share*gdp_curr_logdifUS

*Use outreg2
capture install outreg2

*Get rid of housing
drop if sector_match==1

egen ctyc_num = group(ctyc)

* NO FE
outreg2 using "$datadir/Tables/reg_results.xls", replace excel: reg price_relUS gdp_curr_logdifUS, cl(ctyc_num)
outreg2 using "$datadir/Tables/reg_results.xls", append excel: reg price_relUS gdp_curr_logdifUS gdp_interact inp_share, cl(ctyc_num)

* Country FE
xtset ctyc_num
outreg2 using "$datadir/Tables/reg_results.xls", append excel: xi, noomit: reg price_relUS gdp_interact inp_share i.ctyc_num, vce(cluster ctyc_num,) 

* Industry FE
xtset sector_match_icp
outreg2 using "$datadir/Tables/reg_results.xls", append excel: xi, noomit: reg price_relUS gdp_curr_logdifUS gdp_interact inp_share i.sector_match_icp if theta_N>.538252 | theta_N<.5382518, vce(cluster ctyc_num) 



}

*Conclusion of file.
