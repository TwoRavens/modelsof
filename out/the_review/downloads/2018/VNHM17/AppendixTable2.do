****************************************************************************************
* Replication Code: Appendix Table 2
* Bivariate Correlations between Staffer Estimates of Member Reelection Margin and 
* Absolute Staffer Mismatch by Issue and Party. Top value is correlation coeffcient, 
* bottom value in parentheses is standard error for the correlation coeffcient. Standard 
* errors clustered by office.
* This code created: 6/13/18
****************************************************************************************

*
* Load analysis file 
*

use "replicationdata.dta", clear

*
* Regression results  
*

tempname appendixtable2

postfile `appendixtable2' str40 policyissue coeff se str40 party using "appendixtable2.dta", replace

foreach party in democrat republican{
	foreach issue in gun aca co2 minwage infra{
		xi: reg abs_`issue'_mismatch marginreelect_r if `party'==1, cluster(office)
		post `appendixtable2' ("`issue'") (`=_b[marginreelect_r]') (`=_se[marginreelect_r]') ("`party'")
	}
}

postclose `appendixtable2'

use "appendixtable2.dta", clear
