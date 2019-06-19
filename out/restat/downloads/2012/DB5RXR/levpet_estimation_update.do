version 9
clear
set memory 200m
*set matsize 800
capture program drop _all
capture log close
log using ${empdecomp}levpet_estimation_update, text replace
set more off
*
***11.10.07* SH *****Rev 28.04.2008 RB **********************************
* Based on previous levpet-dofiles
* This does Levinsohn-Petrin prod fct estimation to obtain a TFP measure
* Energy share in intermediates is used as instrument
* justid, 1000 boot strap replications
* The levpet estimations is done for different capital measures
* Saves all levpet residuals in {industri}tfp_lp_i2_empdecomp.dta
**********************************************************************

* Prepare temp file 
	use ${industri}empdecomppanel1_update.dta, clear

* Generate share of energy in mat use em
	gen em=v34/Mi
* Other variables	
	gen isic2=int(naering/1000)
	quietly gen q=ln(Qidef)
	quietly gen m=ln(Midef)
	quietly gen h=ln(Li_h/1000)
* Generate log of different capital variables
* Use k1 k2 k3 here
	quietly gen lk1=ln(k1)
	quietly gen lk2=ln(k2)
	quietly gen lk3=ln(k3)
	drop k1 k2 k3
	rename lk1 k1
	rename lk2 k2
	rename lk3 k3
* Save temp file
	keep bnr aar isic2 q m k1 k2 k3 h em 
	save ${industri}levpet, replace


* 2. levpet estimation for capital measure k1
	use using ${industri}levpet.dta if isic2==31, clear
	levpet q if isic2==31, free(h m) proxy(em) capital(k1) rev justid i(bnr) t(aar) reps(1000)
	predict qhat31, omega
	keep bnr aar isic2 qhat31
	quietly save ${industri}qhat_i2.dta, replace

	foreach t in 32 33 34 35 36 37 38 39 {
		use using ${industri}levpet.dta if isic2==`t', clear
		display "--------------------isic2==`t'------------------------"
		levpet q if isic2==`t', free(h m) proxy(em) capital(k1) rev justid i(bnr) t(aar) reps(1000)
		predict qhat`t', omega
		keep bnr aar isic2 qhat`t'
		append using ${industri}qhat_i2.dta
		quietly save ${industri}qhat_i2.dta, replace
	}

	use ${industri}qhat_i2.dta, clear
	quietly gen qhati_1=qhat31
	foreach t in 32 33 34 35 36 37 38 39 {
		quietly replace qhati_1=qhat`t' if isic2==`t'
	}
	keep bnr aar qhati
	sort bnr aar
	save ${industri}tfp_lp_i2_empdecomp_update.dta, replace
	erase ${industri}qhat_i2.dta

* 3. levpet estimation for capital measure k2
	use using ${industri}levpet.dta if isic2==31, clear
	levpet q if isic2==31, free(h m) proxy(em) capital(k2) rev justid i(bnr) t(aar) reps(1000)
	predict qhat31, omega
	keep bnr aar isic2 qhat31
	quietly save ${industri}qhat_i2.dta, replace

	foreach t in 32 33 34 35 36 37 38 39 {
		use using ${industri}levpet.dta if isic2==`t', clear
		display "--------------------isic2==`t'------------------------"
		levpet q if isic2==`t', free(h m) proxy(em) capital(k2) rev justid i(bnr) t(aar) reps(1000)
		predict qhat`t', omega
		keep bnr aar isic2 qhat`t'
		append using ${industri}qhat_i2.dta
		quietly save ${industri}qhat_i2.dta, replace
	}

	use ${industri}qhat_i2.dta, clear
	quietly gen qhati_2=qhat31
	foreach t in 32 33 34 35 36 37 38 39 {
		quietly replace qhati_2=qhat`t' if isic2==`t'
	}
	keep bnr aar qhati_2
	sort bnr aar
	merge bnr aar using ${industri}tfp_lp_i2_empdecomp_update.dta
	assert _merge==3
	drop _merge
	sort bnr aar
	save ${industri}tfp_lp_i2_empdecomp_update.dta, replace
	erase ${industri}qhat_i2.dta

* 4. levpet estimation for capital measure k3
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
	sort bnr aar
	merge bnr aar using ${industri}tfp_lp_i2_empdecomp_update.dta
	assert _merge==3
	drop _merge
	sort bnr aar
	save ${industri}tfp_lp_i2_empdecomp_update.dta, replace
	erase ${industri}qhat_i2.dta

******
sum qhati_*, d
erase ${industri}levpet.dta

capture log close
exit


