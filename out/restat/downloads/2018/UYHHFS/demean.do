*this file residualises log earnings and prepares them for estimation of 
*second moments of the individual intertemporal covariance structire



clear all
set mem 5000m
set more off			
capture log close
log using demean.log,replace 



forvalues i=0(1)2 {
	use earnings_long,clear
	quietly summ cohort if bob==`i'
	global min_`i'=_result(5)
	global max_`i'=_result(6)
	forvalues y=${min_`i'}(3)${max_`i'} {
		use earnings_long,clear
		keep if bob == `i'
		ta year, ge(years)
		di `y'
		ge agesq=ageC^2
		regress  logearn years* ageC agesq if cohort==`y',noc
		predict res if cohort==`y',resid
		keep pnr pnrf logearn res year yob   age* cohort 
		keep if cohort==`y'
		compress
		save res_`i'_`y',replace
	}
}
	
log close
