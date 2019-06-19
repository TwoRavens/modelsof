version 10
clear
set memory 200m
*set matsize 800
capture program drop _all
capture log close
log using ${empdecomp}levpet_estimation_employees, text replace
set more off
*
***19.09.2008 ****************************************************
* Based on levpet_estimation_update.do
* Makes just one levpet measure: based on 
* k3 capital measure, and uses # of employees 
* instead of hours worked in the plant.
* Saves residual in {industri}tfp_lp_i2_employees.dta
**********************************************************************

* Prepare temp file 
	use ${industri}empdecomppanel1_update.dta, clear

* Generate share of energy in mat use em
	gen em=v34/Mi
* Other variables	
	gen isic2=int(naering/1000)
	quietly gen q=ln(Qidef)
	quietly gen m=ln(Midef)
	quietly gen h=ln(v13)
	quietly gen lk3=ln(k3)
	drop k3
	rename lk3 k3
* Save temp file
	keep bnr aar isic2 q m k3 h em 
	save ${industri}levpet, replace


*  levpet estimation for capital measure k3
	use using ${industri}levpet.dta if isic2==31, clear
	levpet q if isic2==31, free(h m) proxy(em) capital(k3) rev justid i(bnr) t(aar) reps(1000)
	predict qhat31, omega
	keep bnr aar isic2 qhat31
	quietly save ${industri}qhat_i2.dta, replace

	foreach t in 32 33 34 35 36 37 38 39 {
		use using ${industri}levpet.dta if isic2==`t', clear
		display "--------------------isic2==`t'------------------------"
		levpet q if isic2==`t', free(h m) proxy(em) capital(k3) rev justid i(bnr) t(aar) reps(1000)
		predict qhat`t', omega
		keep bnr aar isic2 qhat`t'
		append using ${industri}qhat_i2.dta
		quietly save ${industri}qhat_i2.dta, replace
	}

	use ${industri}qhat_i2.dta, clear
	quietly gen qhati_3=qhat31
	foreach t in 32 33 34 35 36 37 38 39 {
		quietly replace qhati_3=qhat`t' if isic2==`t'
	}
	keep bnr aar qhati_3
	rename qhati_3emp
	lavel var qhati_3emp "levpet residual using k3 and # employees"
	sort bnr aar
	save ${industri}tfp_lp_i2_employees.dta, replace
	erase ${industri}qhat_i2.dta

******
sum qhati_*, d
erase ${industri}levpet.dta

capture log close
exit


