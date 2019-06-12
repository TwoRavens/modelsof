****************************************************************************************
* Replication Code: Appendix Table 3
* Bivariate Correlations between Staffer Tenure and Absolute Staffer Mismatch by Issue and 
* Party. Top value is correlation coeffcient, bottom value in parentheses is standard error 
* for the correlation coeffcient. Standard errors clustered by offce.
* This code created: 6/13/18
****************************************************************************************

*
* Load analysis file 
*

use "replicationdata.dta", clear

*
* Regression results  
*

tempname appendixtable3

postfile `appendixtable3' str40 policyissue coeff se str40 yearvariable str40 party using "appendixtable3.dta", replace

foreach party in democrat republican{
	foreach issue in gun aca co2 minwage infra{
		foreach yr in yearsonhill yearsinoff{
			xi: reg abs_`issue'_mismatch `yr' if `party'==1, cluster(office)
			post `appendixtable3' ("`issue'") (`=_b[`yr']') (`=_se[`yr']') ("`yr'") ("`party'")
		}
	}
}

postclose `appendixtable3'

use "appendixtable3.dta", clear
sort year party
