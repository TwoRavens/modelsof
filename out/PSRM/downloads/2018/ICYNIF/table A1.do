/*******************************************************************************
This file replicates Table A1.
*******************************************************************************/

use dataset, clear

keep if studynumber == 6

eststo clear

eststo: reg zip passed, robust
eststo: reg passed raffle, cl(zipcode)
eststo: reg zip raffle, cl(zipcode)

label variable zip "Zip Code Matched"
label variable passed "Passed Screener"
label variable raffle "Incentives"

#delimit;

esttab
	using "table A1.tex"
	,
		replace
		se 
		nostar
		label
		stats(N, label("Sample size"))
		booktabs
		width(\textwidth)
		nonote
		;

#delimit cr
