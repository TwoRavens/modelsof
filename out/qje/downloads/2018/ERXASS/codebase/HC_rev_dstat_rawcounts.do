/*-----------------------------------------------------------HC_rev_dstat_rawcounts.do

Stuart Craig
Last updated	20180816
*/

timestamp, output
cap mkdir dstat_rawcounts
cd dstat_rawcounts

use ${ddHC}/HC_raw_totspending.dta, clear
keep spending_ip spending_tot year

// Adjust spending for inflation
	cpigen
	qui summ cpi if year==2011, mean
	qui replace cpi = cpi/r(mean)
	foreach v of varlist spend* {
		qui replace `v' = `v'/cpi
	}
	drop cpi*

// Create a total
	preserve
		collapse (sum) spend*, fast
		gen year=9000
		tempfile tot
		save `tot', replace
	restore
	append using `tot'
	sort year

// 	Format and save
	foreach v of varlist spend* {
		cap drop temp
		rename `v' temp
		qui gen `v' = string(temp,"%15.0fc")
		drop temp
	}
	
	export excel using HC_rev_dstat_rawcounts.xls, first(var) replace

exit
