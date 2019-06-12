****************************************************************
*** Replication file "You've Got Some Explaining To Do: The Influence of Economic Conditions and Spatial Competition on Party Strategy"
*** Laron K. Williams, Katsunori Seki and Guy D. Whitten
*** Political Science Research & Methods
***
*** Created: 5-27-14
***
*** NOTE: make sure that you run the programs at the bottom of the do file first!
****************************************************************

* Set up working directory
*cd 

use "Williams Seki and Whitten.dta", clear

***************************************************************************************
********************** Replication: Manuscript ****************************************
***************************************************************************************

*** Model 1: Government/Opposition
preserve
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche"
	local w "W1"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa ep_400_tot_dm, w(`w') m g two
	qui reg ep_400_tot_dm annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche, robust	
	spatdiag, weights(`w')
	spatreg ep_400_tot_dm $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_g
	mat b = e(b)
	svmat b, name(b)
	keep in 1
	outsheet b* using "b_`w'.csv", comma replace	
restore

*** Model 2: Government percentage interactions
preserve
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag Gperc Gperc_gdp Gperc_un Gperc_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche"
	local w "W1"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa ep_400_tot_dm, w(`w') m g two
	qui reg ep_400_tot_dm annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag Gperc Gperc_gdp Gperc_un Gperc_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche, robust	
	spatdiag, weights(`w')
	spatreg ep_400_tot_dm $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_perc
restore

*** Model 3: PM & FM interactions
preserve
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf FM FM_gdp FM_un FM_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche"
	local w "W1"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa ep_400_tot_dm, w(`w') m g two
	qui reg ep_400_tot_dm annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf FM FM_gdp FM_un FM_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche, robust	
	spatdiag, weights(`w')
	spatreg ep_400_tot_dm $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_pmfm
restore


***************************************************************************************
********************** Replication: Additional Materials ******************************
***************************************************************************************
*** Government Specification: PM & CP interactions
preserve
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf CP CP_gdp CP_un CP_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche"
	local w "W1"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa ep_400_tot_dm, w(`w') m g two
	qui reg ep_400_tot_dm annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf CP CP_gdp CP_un CP_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche, robust	
	spatdiag, weights(`w')
	spatreg ep_400_tot_dm $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_pmcp
restore

*** Directional Models
*** Model 1: G interactions
preserve
	qui reg shift_t annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche, robust	
	keep if e(sample)
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche"
	local w "W2"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa shift_t, w(`w') m g two
	qui reg shift_t annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche, robust	
	spatdiag, weights(`w')
	spatreg shift_t $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_g
restore

*** Model 2: Government percentage interactions
preserve
	qui reg shift_t annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche, robust	
	keep if e(sample)
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag Gperc Gperc_gdp Gperc_un Gperc_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche"
	local w "W2"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa shift_t, w(`w') m g two
	qui reg shift_t annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag Gperc Gperc_gdp Gperc_un Gperc_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche, robust	
	spatdiag, weights(`w')
	spatreg shift_t $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_perc_am
restore

*** Model 3: PM & FM interactions
preserve
	qui reg shift_t annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche, robust	
	keep if e(sample)
	global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf FM FM_gdp FM_un FM_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche"
	local w "W2"
	spatwmat using "`w'.dta", name(`w') eigenval(E_`w')
	spatgsa shift_t, w(`w') m g two
	qui reg shift_t annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf FM FM_gdp FM_un FM_inf pervote_tm1 shift_tm1 abs_rile_tm1 niche, robust	
	spatdiag, weights(`w')
	spatreg shift_t $rhs, weights(`w') eigenval(E_`w') model(lag) robust 
	me_pmfm
restore

***************************************************************************************
********************** Substantive Effects ********************************************
***************************************************************************************
*** Marginal effect of a 1-standard deviation increase (+3.834%) in unemployment for the G.
use "Williams Seki and Whitten.dta", clear

cap gen cons = 1

global rhs "annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag G G_gdp G_un G_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche"
qui reg ep_400_tot_dm $rhs, robust
keep if e(sample)
local w "W1"

preserve
	clear
	insheet using "b_W1.csv", comma
	mkmat b1-b14, matrix(b)
	mkmat b15, matrix(rho)
	local rho = rho[1,1]
	matrix B = b'
	mat list b
	mat list B
	mat list rho
restore

local nobs = 5	
matrix eye = I(`nobs')
	
* Create the weights matrix (left to right): 
* 1 = far-left, 2 = moderate-left, 3 = center, 4 = moderate-right, 5 = far-right
* first number refers to row, second number refers to column

keep in 1/`nobs'
replace new_rile = -40 in 1
replace new_rile = -15 in 2
replace new_rile = 0 in 3
replace new_rile = 15 in 4
replace new_rile = 40 in 5
	
mkmat new_rile, matrix(r)
	
scalar w_1_2 = 1/abs(r[2,1]-r[1,1])
scalar w_1_3 = 1/abs(r[3,1]-r[1,1])
scalar w_1_4 = 1/abs(r[4,1]-r[1,1])
scalar w_1_5 = 1/abs(r[5,1]-r[1,1])

scalar w_2_1 = 1/abs(r[1,1]-r[2,1])
scalar w_2_3 = 1/abs(r[3,1]-r[2,1])
scalar w_2_4 = 1/abs(r[4,1]-r[2,1])
scalar w_2_5 = 1/abs(r[5,1]-r[2,1])

scalar w_3_1 = 1/abs(r[1,1]-r[3,1])
scalar w_3_2 = 1/abs(r[2,1]-r[3,1])
scalar w_3_4 = 1/abs(r[4,1]-r[3,1])
scalar w_3_5 = 1/abs(r[5,1]-r[3,1])

scalar w_4_1 = 1/abs(r[1,1]-r[4,1])
scalar w_4_2 = 1/abs(r[2,1]-r[4,1])
scalar w_4_3 = 1/abs(r[3,1]-r[4,1])
scalar w_4_5 = 1/abs(r[5,1]-r[4,1])

scalar w_5_1 = 1/abs(r[1,1]-r[5,1])
scalar w_5_2 = 1/abs(r[2,1]-r[5,1])
scalar w_5_3 = 1/abs(r[3,1]-r[5,1])
scalar w_5_4 = 1/abs(r[4,1]-r[5,1])
	
mat W = (0, w_1_2, w_1_3, w_1_4, w_1_5 \ w_2_1, 0, w_2_3, w_2_4, w_2_5 \ w_3_1, w_3_2, 0, w_3_4, w_3_5 \ w_4_1, w_4_2, w_4_3, 0, w_4_5 \ w_5_1, w_5_2, w_5_3, w_5_4, 0)
mat list W
	
matrix est = eye - `rho'*W
matrix invest = inv(est)

*** First scenario	
preserve	
	matrix XB = (-1 \ -10 \ 1.194 \ -10 \ -1)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	keep new_rile y_hat1
	keep in 1/5 
	sort new_rile
	tempfile s1
	save `s1', replace
restore

*** Second scenario	
preserve	
	matrix XB = (-1 \ -3 \ 1.194 \ -3 \ -1)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat2
	keep new_rile y_hat2
	keep in 1/5 
	sort new_rile
	tempfile s2
	save `s2', replace	
restore

*** Third scenario	
preserve	
	matrix XB = (0 \ 0 \ 1.194 \ 0 \ 0)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat3
	keep new_rile y_hat3
	keep in 1/5 
	sort new_rile	
	tempfile s3
	save `s3', replace		
restore	

*** Fourth scenario	
preserve	
	matrix XB = (-1 \ 3 \ 1.194 \ 3 \ -1)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat4
	keep new_rile y_hat4
	keep in 1/5 
	sort new_rile	
	tempfile s4
	save `s4', replace		
restore	

*** Fifth scenario	
preserve	
	matrix XB = (-1 \ 10 \ 1.194 \ 10 \ -1)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat5
	keep new_rile y_hat5
	keep in 1/5 
	sort new_rile	
	tempfile s5
	save `s5', replace		
restore	

*** Put it all together
preserve
	use `s1', clear
	sort new_rile 

	merge new_rile using `s2', sort
	drop _merge

	merge new_rile using `s3', sort
	drop _merge

	merge new_rile using `s4', sort
	drop _merge

	merge new_rile using `s5', sort
	drop _merge

	gen me = .
	foreach i of numlist 1(1)5 {
		qui sum y_hat`i' in 3
		qui replace me = r(mean) in `i'	
	}

	egen v = fill(1(1)5)

	outsheet using "ME_un1.csv", comma replace
restore


*** First scenario	
preserve	
	matrix XB = (-10 \ -1 \ 1.194 \ -1 \ -10)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	keep new_rile y_hat1
	keep in 1/5 
	sort new_rile
	tempfile s1
	save `s1', replace
restore

*** Second scenario	
preserve	
	matrix XB = (-3 \ -1 \ 1.194 \ -1 \ -3)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat2
	keep new_rile y_hat2
	keep in 1/5 
	sort new_rile
	tempfile s2
	save `s2', replace	
restore

*** Third scenario	
preserve	
	matrix XB = (0 \ 0 \ 1.194 \ 0 \ 0)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat3
	keep new_rile y_hat3
	keep in 1/5 
	sort new_rile	
	tempfile s3
	save `s3', replace		
restore	

*** Fourth scenario	
preserve	
	matrix XB = (3 \ -1 \ 1.194 \ -1 \ 3)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat4
	keep new_rile y_hat4
	keep in 1/5 
	sort new_rile	
	tempfile s4
	save `s4', replace		
restore	

*** Fifth scenario	
preserve	
	matrix XB = (10 \ -1 \ 1.194 \ -1 \ 10)
	mat list XB

	matrix y_hat = invest*XB
	svmat y_hat
	list new_rile y_hat
	rename y_hat1 y_hat5
	keep new_rile y_hat5
	keep in 1/5 
	sort new_rile	
	tempfile s5
	save `s5', replace		
restore	

preserve
	*** Put it all together
	use `s1', clear
	sort new_rile 

	merge new_rile using `s2', sort
	drop _merge

	merge new_rile using `s3', sort
	drop _merge

	merge new_rile using `s4', sort
	drop _merge

	merge new_rile using `s5', sort
	drop _merge

	gen me = .
	foreach i of numlist 1(1)5 {
		qui sum y_hat`i' in 3
		qui replace me = r(mean) in `i'		
	}

	egen v = fill(1(1)5)

	outsheet using "ME_un2.csv", comma replace
restore

***************************************************************************************
********************** Descriptive Statistics *****************************************
***************************************************************************************
use "Williams Seki and Whitten.dta", clear

sum ep_400_tot_dm annual_ch_rgdppc unem_harm_monthly_lag inf_py_quarterly_lag PM PM_gdp PM_un PM_inf pervote_tm1 ep_400_tot_tm1_dm elec_ep_400_tot_tm1_dm elec_fam_ep_400_tot_tm1_dm abs_pr niche

bys ccode: sum ep_400_tot
tab ccode

preserve
	di _N
	collapse (count) party (min) min_y = year (max) max_y = year, by(ccode)
	list ccode party min_y max_y
restore

pwcorr rile purge_rile, sig

gen type = .
replace type = 1 if O == 1
replace type = 2 if G == 1 & PM == 0 & FM == 0
replace type = 3 if G == 1 & PM == 0 & FM == 1
replace type = 4 if G == 1 & PM == 1 & FM == 0
replace type = 5 if PM == 1 & FM == 1

lab def type 1 "Opposition" 2 "Government, Neither" 3 "FM Only" 4 "PM Only" 5 "PM & FM"
lab val type type

tab type

log close





***************************************************************************************
**************************** Programs ************************************************
***************************************************************************************
capture program drop me_g
program define me_g, rclass
	syntax
	
	matrix b=e(b)
	matrix V=e(V)

	local k = colsof(b)
	foreach c of numlist 1(1)`k' {
		local b`c' = b[1,`c']
		local varb`c' = V[`c',`c']
		foreach r of numlist 1(1)`k' {
			local covb`r'b`c' = V[`r',`c']
		}
	}

	* First, GDP
	quietly foreach i of numlist 0 1 {
		local n = 1

		local me = `b1' + (`b5' * `i')
		local se = sqrt(`varb1'+((`i'^2)*`varb5')+(2*`i'*`covb1b5'))
		local lo_90 = `me' - (1.65 * `se')
		local hi_90 = `me' + (1.65 * `se')
		local lo_95 = `me' - (1.96 * `se')
		local hi_95 = `me' + (1.96 * `se')
		
		noisily di
		noisily di
		noisily di as result "The marginal effect for GDP is " `me'
		noisily di
		noisily di as result "The 95% confidence interval is " `lo_95' 	"	and		"	`hi_95'
		noisily di
		noisily di as result "The 90% confidence interval is " `lo_90'   "    and      " `hi_90' 
		noisily di
		noisily di as result "G = 	" `i'
		noisily di
}

	* Next, unemployment
	quietly foreach i of numlist 0 1 {
		local n = 1

		local me = `b2' + (`b6' * `i')
		local se = sqrt(`varb2'+((`i'^2)*`varb6')+(2*`i'*`covb2b6'))
		local lo_95 = `me' - (1.96 * `se')
		local hi_95 = `me' + (1.96 * `se')
		local lo_90 = `me' - (1.65 * `se')
		local hi_90 = `me' + (1.65 * `se')
		
		noisily di
		noisily di
		noisily di as result "The marginal effect for unemployment is " `me'
		noisily di
		noisily di as result "The 95% confidence interval is " `lo_95' 	"	and		"	`hi_95'
		noisily di
		noisily di as result "The 90% confidence interval is " `lo_90'   "    and      " `hi_90' 
		noisily di
		noisily di as result "G = 	" `i'
		noisily di
}

	* Inflation
	quietly foreach i of numlist 0 1 {
		local n = 1

		local me = `b3' + (`b7' * `i')
		local se = sqrt(`varb3'+((`i'^2)*`varb7')+(2*`i'*`covb3b7'))
		local lo_95 = `me' - (1.96 * `se')
		local hi_95 = `me' + (1.96 * `se')
		local lo_90 = `me' - (1.65 * `se')
		local hi_90 = `me' + (1.65 * `se')
		
		noisily di
		noisily di
		noisily di as result "The marginal effect for inflation is " `me'
		noisily di
		noisily di as result "The 95% confidence interval is " `lo_95' 	"	and		"	`hi_95'
		noisily di
		noisily di as result "The 90% confidence interval is " `lo_90'   "    and      " `hi_90' 
		noisily di
		noisily di as result "G = 	" `i'
		noisily di
}

end

*** Marginal effects for percentage of government seats specification:
cap program drop me_perc
program define me_perc

	mat b = e(b)
	mat V = e(V)
	
	local c: colnames b
	local cno = colsof(b)
	
	local k = e(rank)
	foreach i of numlist 1(1)`k' {
		scalar b`i' = b[1,`i']
		scalar varb`i' = V[`i',`i']
		foreach x of numlist 1(1)`k' {
			scalar covb`i'b`x' = V[`i',`x']
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "annual_ch_rgdppc" {
			local g = `i'
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "unem_harm_monthly_lag" {
			local u = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "inf_py_quarterly_lag" {
			local in = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "Gperc_gdp" {
			local gg = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "Gperc_un" {
			local gu = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "Gperc_inf" {
			local gi = `i'
		}	
	}	

	*** GDP
	foreach i of numlist 0 0.25 0.50 0.75 1 {
		scalar me_g = round(b`g' + (`i'*b`gg'), .001)
		scalar se_g = round(sqrt(varb`g' + ((`i'^2)*varb`gg') + (2*`i'*covb`g'b`gg')), .001)
	
		di _newline(2)
		di as result "Marginal effect of GDP when gperc = `i' = " me_g
		di as result "90% CI for marginal effect when gperc = `i' = [" me_g - (1.65*se_g) ", "  me_g + (1.65*se_g) "]"
		di as result "95% CI for marginal effect when gperc = `i' = [" me_g - (1.96*se_g) ", "  me_g + (1.96*se_g) "]"
	}
	
	*** Unemployment
	foreach i of numlist 0 0.25 0.50 0.75 1 {
		scalar me_u = round(b`u' + (`i'*b`gu'), .001)
		scalar se_u = round(sqrt(varb`u' + ((`i'^2)*varb`gu') + (2*`i'*covb`u'b`gu')), .001)
	
		di _newline(2)
		di as result "Marginal effect of unemployment when gperc = `i' = " me_u
		di as result "90% CI for marginal effect when gperc = `i' = [" me_u - (1.65*se_u) ", "  me_u + (1.65*se_u) "]"
		di as result "95% CI for marginal effect when gperc = `i' = [" me_u - (1.96*se_u) ", "  me_u + (1.96*se_u) "]"
	}

	*** Inflation
	foreach i of numlist 0 0.25 0.50 0.75 1 {
		scalar me_i = round(b`in' + (`i'*b`gi'), .001)
		scalar se_i = round(sqrt(varb`in' + ((`i'^2)*varb`gi') + (2*`i'*covb`in'b`gi')), .001)
	
		di _newline(2)
		di as result "Marginal effect of Inflation when gperc = `i' = " me_i
		di as result "90% CI for marginal effect when gperc = `i' = [" me_i - (1.65*se_i) ", "  me_i + (1.65*se_i) "]"
		di as result "95% CI for marginal effect when gperc = `i' = [" me_i - (1.96*se_i) ", "  me_i + (1.96*se_i) "]"
	}
	
	
	postfile gperc xaxis me_g se_g lo_g hi_g me_u se_u lo_u hi_u me_i se_i lo_i hi_i using "gperc.dta", replace
	
	foreach i of numlist 0(.01)1 {
		scalar me_g = round(b`g' + (`i'*b`gg'), .001)
		scalar se_g = round(sqrt(varb`g' + ((`i'^2)*varb`gg') + (2*`i'*covb`g'b`gg')), .001)
		scalar lo_g = me_g - (1.96 * se_g)
		scalar hi_g = me_g + (1.96 * se_g)
		
		scalar me_u = round(b`u' + (`i'*b`gu'), .001)
		scalar se_u = round(sqrt(varb`u' + ((`i'^2)*varb`gu') + (2*`i'*covb`u'b`gu')), .001)		
		scalar lo_u = me_u - (1.96 * se_u)
		scalar hi_u = me_u + (1.96 * se_u)
		
		scalar me_i = round(b`in' + (`i'*b`gi'), .001)
		scalar se_i = round(sqrt(varb`in' + ((`i'^2)*varb`gi') + (2*`i'*covb`in'b`gi')), .001)
		scalar lo_i = me_i - (1.96 * se_i)
		scalar hi_i = me_i + (1.96 * se_i)
		
		post gperc (`i') (me_g) (se_g) (lo_g) (hi_g) (me_u) (se_u) (lo_u) (hi_u) (me_i) (se_i) (lo_i) (hi_i) 
	}	
	
	
	postclose gperc
	
end


*** Marginal effects for percentage of government seats specification: Additional Materials specification (Model 2)
cap program drop me_perc_am
program define me_perc_am

	mat b = e(b)
	mat V = e(V)
	
	local c: colnames b
	local cno = colsof(b)
	
	local k = e(rank)
	foreach i of numlist 1(1)`k' {
		scalar b`i' = b[1,`i']
		scalar varb`i' = V[`i',`i']
		foreach x of numlist 1(1)`k' {
			scalar covb`i'b`x' = V[`i',`x']
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "annual_ch_rgdppc" {
			local g = `i'
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "unem_harm_monthly_lag" {
			local u = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "inf_py_quarterly_lag" {
			local in = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "Gperc_gdp" {
			local gg = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "Gperc_un" {
			local gu = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "Gperc_inf" {
			local gi = `i'
		}	
	}	

	*** GDP
	foreach i of numlist 0 0.25 0.50 0.75 1 {
		scalar me_g = round(b`g' + (`i'*b`gg'), .001)
		scalar se_g = round(sqrt(varb`g' + ((`i'^2)*varb`gg') + (2*`i'*covb`g'b`gg')), .001)
	
		di _newline(2)
		di as result "Marginal effect of GDP when gperc = `i' = " me_g
		di as result "90% CI for marginal effect when gperc = `i' = [" me_g - (1.65*se_g) ", "  me_g + (1.65*se_g) "]"
		di as result "95% CI for marginal effect when gperc = `i' = [" me_g - (1.96*se_g) ", "  me_g + (1.96*se_g) "]"
	}
	
	*** Unemployment
	foreach i of numlist 0 0.25 0.50 0.75 1 {
		scalar me_u = round(b`u' + (`i'*b`gu'), .001)
		scalar se_u = round(sqrt(varb`u' + ((`i'^2)*varb`gu') + (2*`i'*covb`u'b`gu')), .001)
	
		di _newline(2)
		di as result "Marginal effect of unemployment when gperc = `i' = " me_u
		di as result "90% CI for marginal effect when gperc = `i' = [" me_u - (1.65*se_u) ", "  me_u + (1.65*se_u) "]"
		di as result "95% CI for marginal effect when gperc = `i' = [" me_u - (1.96*se_u) ", "  me_u + (1.96*se_u) "]"
	}

	*** Inflation
	foreach i of numlist 0 0.25 0.50 0.75 1 {
		scalar me_i = round(b`in' + (`i'*b`gi'), .001)
		scalar se_i = round(sqrt(varb`in' + ((`i'^2)*varb`gi') + (2*`i'*covb`in'b`gi')), .001)
	
		di _newline(2)
		di as result "Marginal effect of Inflation when gperc = `i' = " me_i
		di as result "90% CI for marginal effect when gperc = `i' = [" me_i - (1.65*se_i) ", "  me_i + (1.65*se_i) "]"
		di as result "95% CI for marginal effect when gperc = `i' = [" me_i - (1.96*se_i) ", "  me_i + (1.96*se_i) "]"
	}
	
	
	postfile gperc_am xaxis me_g se_g lo_g hi_g me_u se_u lo_u hi_u me_i se_i lo_i hi_i using "gperc--AM.dta", replace
	
	foreach i of numlist 0(.01)1 {
		scalar me_g = round(b`g' + (`i'*b`gg'), .001)
		scalar se_g = round(sqrt(varb`g' + ((`i'^2)*varb`gg') + (2*`i'*covb`g'b`gg')), .001)
		scalar lo_g = me_g - (1.96 * se_g)
		scalar hi_g = me_g + (1.96 * se_g)
		
		scalar me_u = round(b`u' + (`i'*b`gu'), .001)
		scalar se_u = round(sqrt(varb`u' + ((`i'^2)*varb`gu') + (2*`i'*covb`u'b`gu')), .001)		
		scalar lo_u = me_u - (1.96 * se_u)
		scalar hi_u = me_u + (1.96 * se_u)
		
		scalar me_i = round(b`in' + (`i'*b`gi'), .001)
		scalar se_i = round(sqrt(varb`in' + ((`i'^2)*varb`gi') + (2*`i'*covb`in'b`gi')), .001)
		scalar lo_i = me_i - (1.96 * se_i)
		scalar hi_i = me_i + (1.96 * se_i)
		
		post gperc_am (`i') (me_g) (se_g) (lo_g) (hi_g) (me_u) (se_u) (lo_u) (hi_u) (me_i) (se_i) (lo_i) (hi_i) 
	}	
	
	
	postclose gperc_am
	
end

*** Marginal effects for PM/FM specification:
cap program drop me_pmfm
program define me_pmfm

	mat b = e(b)
	mat V = e(V)
	
	local c: colnames b
	local cno = colsof(b)
	
	local k = e(rank)
	foreach i of numlist 1(1)`k' {
		scalar b`i' = b[1,`i']
		scalar varb`i' = V[`i',`i']
		foreach x of numlist 1(1)`k' {
			scalar covb`i'b`x' = V[`i',`x']
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "annual_ch_rgdppc" {
			local g = `i'
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "unem_harm_monthly_lag" {
			local u = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "inf_py_quarterly_lag" {
			local in = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "PM_gdp" {
			local pmg = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "FM_gdp" {
			local fmg = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "PM_un" {
			local pmu = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "FM_un" {
			local fmu = `i'
		}	
	}	
	
	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "PM_inf" {
			local pmi = `i'
		}	
	}
	
	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "FM_inf" {
			local fmi = `i'
		}	
	}	

	*** GDP
	scalar me_o = round(b`g', .001)
	scalar me_fm = round(b`g' + (1*b`fmg'), .001)
	scalar me_pm = round(b`g' + (1*b`pmg'), .001)
	scalar me_pmfm = round(b`g' + (1*b`fmg') + (1*b`pmg'), .001)

	scalar se_o = round(sqrt(varb`g'), .001)
	scalar se_fm = round(sqrt(varb`g' + ((1^2)*varb`fmg') + (2*1*covb`g'b`fmg')), .001)	
	scalar se_pm = round(sqrt(varb`g' + ((1^2)*varb`pmg') + (2*1*covb`g'b`pmg')), .001)
	scalar se_pmfm = round(sqrt(varb`g' + ((1^2)*varb`pmg') + ((1^2)*varb`fmg') + (2*1*covb`g'b`pmg') + (2*1*covb`g'b`fmg') + (2*1*1*covb`pmg'b`fmg')), .001)

	di _newline(2)
	di as result "Marginal effect of GDP for Opposition = " me_o
	di as result "90% CI for marginal effect for opposition = [" me_o - (1.65*se_o) ", "  me_o + (1.65*se_o) "]"
	di as result "95% CI for marginal effect for opposition = [" me_o - (1.96*se_o) ", "  me_o + (1.96*se_o) "]"
	di _newline(1)
	di as result "Marginal effect of GDP for FM = " me_fm
	di as result "90% CI for marginal effect for FM = [" me_fm - (1.65*se_fm) ", "  me_fm + (1.65*se_fm) "]"
	di as result "95% CI for marginal effect for FM = [" me_fm - (1.96*se_fm) ", "  me_fm + (1.96*se_fm) "]"
	di _newline(1)
	di as result "Marginal effect of GDP for PM = " me_pm
	di as result "90% CI for marginal effect for PM = [" me_pm - (1.65*se_pm) ", "  me_pm + (1.65*se_pm) "]"
	di as result "95% CI for marginal effect for PM = [" me_pm - (1.96*se_pm) ", "  me_pm + (1.96*se_pm) "]"
	di _newline(1)
	di as result "Marginal effect of GDP for PM/FM = " me_pmfm
	di as result "90% CI for marginal effect for PM/FM = [" me_pmfm - (1.65*se_pmfm) ", "  me_pmfm + (1.65*se_pmfm) "]"
	di as result "95% CI for marginal effect for PM/FM = [" me_pmfm - (1.96*se_pmfm) ", "  me_pmfm + (1.96*se_pmfm) "]"
	
	*** Unemployment
	scalar meu_o = round(b`u', .001)
	scalar meu_fm = round(b`u' + (1*b`fmu'), .001)
	scalar meu_pm = round(b`u' + (1*b`pmu'), .001)
	scalar meu_pmfm = round(b`u' + (1*b`fmu') + (1*b`pmu'), .001)

	scalar seu_o = round(sqrt(varb`u'), .001)
	scalar seu_fm = round(sqrt(varb`u' + ((1^2)*varb`fmu') + (2*1*covb`u'b`fmu')), .001)	
	scalar seu_pm = round(sqrt(varb`u' + ((1^2)*varb`pmu') + (2*1*covb`u'b`pmu')), .001)
	scalar seu_pmfm = round(sqrt(varb`u' + ((1^2)*varb`pmu') + ((1^2)*varb`fmu') + (2*1*covb`u'b`pmu') + (2*1*covb`u'b`fmu') + (2*1*1*covb`pmu'b`fmu')), .001)

	di _newline(2)
	di as result "Marginal effect of Unemployment for Opposition = " meu_o
	di as result "90% CI for marginal effect for opposition = [" meu_o - (1.65*seu_o) ", "  meu_o + (1.65*seu_o) "]"
	di as result "95% CI for marginal effect for opposition = [" meu_o - (1.96*seu_o) ", "  meu_o + (1.96*seu_o) "]"
	di _newline(1)
	di as result "Marginal effect of Unemployment for FM = " meu_fm
	di as result "90% CI for marginal effect for FM = [" meu_fm - (1.65*seu_fm) ", "  meu_fm + (1.65*seu_fm) "]"
	di as result "95% CI for marginal effect for FM = [" meu_fm - (1.96*seu_fm) ", "  meu_fm + (1.96*seu_fm) "]"
	di _newline(1)
	di as result "Marginal effect of Unemployment for PM = " meu_pm
	di as result "90% CI for marginal effect for PM = [" meu_pm - (1.65*seu_pm) ", "  meu_pm + (1.65*seu_pm) "]"
	di as result "95% CI for marginal effect for PM = [" meu_pm - (1.96*seu_pm) ", "  meu_pm + (1.96*seu_pm) "]"
	di _newline(1)
	di as result "Marginal effect of Unemployment for PM/FM = " meu_pmfm
	di as result "90% CI for marginal effect for PM/FM = [" meu_pmfm - (1.65*seu_pmfm) ", "  meu_pmfm + (1.65*seu_pmfm) "]"
	di as result "95% CI for marginal effect for PM/FM = [" meu_pmfm - (1.96*seu_pmfm) ", "  meu_pmfm + (1.96*seu_pmfm) "]"

	*** Inflation
	scalar mei_o = round(b`in', .001)
	scalar mei_fm = round(b`in' + (1*b`fmi'), .001)
	scalar mei_pm = round(b`in' + (1*b`pmi'), .001)
	scalar mei_pmfm = round(b`in' + (1*b`fmi') + (1*b`pmi'), .001)

	scalar sei_o = round(sqrt(varb`in'), .001)
	scalar sei_fm = round(sqrt(varb`in' + ((1^2)*varb`fmi') + (2*1*covb`in'b`fmi')), .001)	
	scalar sei_pm = round(sqrt(varb`in' + ((1^2)*varb`pmi') + (2*1*covb`in'b`pmi')), .001)
	scalar sei_pmfm = round(sqrt(varb`in' + ((1^2)*varb`pmi') + ((1^2)*varb`fmi') + (2*1*covb`in'b`pmi') + (2*1*covb`in'b`fmi') + (2*1*1*covb`pmi'b`fmi')), .001)

	di _newline(2)
	di as result "Marginal effect of Inflation for Opposition = " mei_o
	di as result "90% CI for marginal effect for opposition = [" mei_o - (1.65*sei_o) ", "  mei_o + (1.65*sei_o) "]"
	di as result "95% CI for marginal effect for opposition = [" mei_o - (1.96*sei_o) ", "  mei_o + (1.96*sei_o) "]"
	di _newline(1)
	di as result "Marginal effect of Inflation for FM = " mei_fm
	di as result "90% CI for marginal effect for FM = [" mei_fm - (1.65*sei_fm) ", "  mei_fm + (1.65*sei_fm) "]"
	di as result "95% CI for marginal effect for FM = [" mei_fm - (1.96*sei_fm) ", "  mei_fm + (1.96*sei_fm) "]"
	di _newline(1)
	di as result "Marginal effect of Inflation for PM = " mei_pm
	di as result "90% CI for marginal effect for PM = [" mei_pm - (1.65*sei_pm) ", "  mei_pm + (1.65*sei_pm) "]"
	di as result "95% CI for marginal effect for PM = [" mei_pm - (1.96*sei_pm) ", "  mei_pm + (1.96*sei_pm) "]"
	di _newline(1)
	di as result "Marginal effect of Inflation for PM/FM = " mei_pmfm
	di as result "90% CI for marginal effect for PM/FM = [" mei_pmfm - (1.65*sei_pmfm) ", "  mei_pmfm + (1.65*sei_pmfm) "]"
	di as result "95% CI for marginal effect for PM/FM = [" mei_pmfm - (1.96*sei_pmfm) ", "  mei_pmfm + (1.96*sei_pmfm) "]"
	
end



*** Marginal effects for PM/CP specification:
cap program drop me_pmcp
program define me_pmcp

	mat b = e(b)
	mat V = e(V)
	
	local c: colnames b
	local cno = colsof(b)
	
	local k = e(rank)
	foreach i of numlist 1(1)`k' {
		scalar b`i' = b[1,`i']
		scalar varb`i' = V[`i',`i']
		foreach x of numlist 1(1)`k' {
			scalar covb`i'b`x' = V[`i',`x']
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "annual_ch_rgdppc" {
			local g = `i'
		}
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'
		if "`v'" == "unem_harm_monthly_lag" {
			local u = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "inf_py_quarterly_lag" {
			local in = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "PM_gdp" {
			local pmg = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "CP_gdp" {
			local cpg = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "PM_un" {
			local pmu = `i'
		}	
	}

	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "CP_un" {
			local cpu = `i'
		}	
	}	
	
	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "PM_inf" {
			local pmi = `i'
		}	
	}
	
	foreach i of numlist 1(1)`cno' {
		local v: word `i' of `c'	
		if "`v'" == "CP_inf" {
			local cpi = `i'
		}	
	}	

	*** GDP
	scalar me_o = round(b`g', .001)
	scalar me_g = round(b`g' + (1*b`cpg'), .001)
	scalar me_pm = round(b`g' + (1*b`pmg'), .001)

	scalar se_o = round(sqrt(varb`g'), .001)
	scalar se_g = round(sqrt(varb`g' + ((1^2)*varb`cpg') + (2*1*covb`g'b`cpg')), .001)
	scalar se_pm = round(sqrt(varb`g' + ((1^2)*varb`pmg') + (2*1*covb`g'b`pmg')), .001)

	di _newline(2)
	di as result "Marginal effect of GDP for Opposition = " me_o
	di as result "90% CI for marginal effect for opposition = [" me_o - (1.65*se_o) ", "  me_o + (1.65*se_o) "]"
	di as result "95% CI for marginal effect for opposition = [" me_o - (1.96*se_o) ", "  me_o + (1.96*se_o) "]"
	di _newline(1)
	di as result "Marginal effect of GDP for Government (Non-PM) = " me_g
	di as result "90% CI for marginal effect for government (Non-PM) = [" me_g - (1.65*se_g) ", "  me_g + (1.65*se_g) "]"
	di as result "95% CI for marginal effect for government (Non-PM) = [" me_g - (1.96*se_g) ", "  me_g + (1.96*se_g) "]"
	di _newline(1)
	di as result "Marginal effect of GDP for PM = " me_pm
	di as result "90% CI for marginal effect for PM = [" me_pm - (1.65*se_pm) ", "  me_pm + (1.65*se_pm) "]"
	di as result "95% CI for marginal effect for PM = [" me_pm - (1.96*se_pm) ", "  me_pm + (1.96*se_pm) "]"

	* ME for Opposition = Government
	test CP_gdp = 0

	* ME for Opposition = PM
	test PM_gdp = 0
	
	* ME for Government = PM
	test PM_gdp = CP_gdp

	*** Unemployment
	scalar meu_o = round(b`u', .001)
	scalar meu_g = round(b`u' + (1*b`cpu'), .001)
	scalar meu_pm = round(b`u' + (1*b`pmu'), .001)

	scalar seu_o = round(sqrt(varb`u'), .001)
	scalar seu_g = round(sqrt(varb`u' + ((1^2)*varb`cpu') + (2*1*covb`u'b`cpu')), .001)
	scalar seu_pm = round(sqrt(varb`u' + ((1^2)*varb`pmu') + (2*1*covb`u'b`pmu')), .001)

	di _newline(2)
	di as result "Marginal effect of Unemployment for Opposition = " meu_o
	di as result "90% CI for marginal effect for opposition = [" meu_o - (1.65*seu_o) ", "  meu_o + (1.65*seu_o) "]"
	di as result "95% CI for marginal effect for opposition = [" meu_o - (1.96*seu_o) ", "  meu_o + (1.96*seu_o) "]"
	di _newline(1)
	di as result "Marginal effect of Unemployment for Government (Non-PM) = " meu_g
	di as result "90% CI for marginal effect for government (Non-PM) = [" meu_g - (1.65*seu_g) ", "  meu_g + (1.65*seu_g) "]"
	di as result "95% CI for marginal effect for government (Non-PM) = [" meu_g - (1.96*seu_g) ", "  meu_g + (1.96*seu_g) "]"
	di _newline(1)
	di as result "Marginal effect of Unemployment for PM = " meu_pm
	di as result "90% CI for marginal effect for PM = [" meu_pm - (1.65*seu_pm) ", "  meu_pm + (1.65*seu_pm) "]"
	di as result "95% CI for marginal effect for PM = [" meu_pm - (1.96*seu_pm) ", "  meu_pm + (1.96*seu_pm) "]"

	* ME for Opposition = Government
	test CP_un = 0

	* ME for Opposition = PM
	test PM_un = 0
	
	* ME for Government = PM
	test CP_un = PM_un
	
	*** Inflation
	scalar mei_o = round(b`in', .001)
	scalar mei_g = round(b`in' + (1*b`cpi'), .001)
	scalar mei_pm = round(b`in' + (1*b`pmi'), .001)

	scalar sei_o = round(sqrt(varb`in'), .001)
	scalar sei_g = round(sqrt(varb`in' + ((1^2)*varb`cpi') + (2*1*covb`in'b`cpi')), .001)
	scalar sei_pm = round(sqrt(varb`in' + ((1^2)*varb`pmi') + (2*1*covb`in'b`pmi')), .001)

	di _newline(2)
	di as result "Marginal effect of Inflation for Opposition = " mei_o
	di as result "90% CI for marginal effect for opposition = [" mei_o - (1.65*sei_o) ", "  mei_o + (1.65*sei_o) "]"
	di as result "95% CI for marginal effect for opposition = [" mei_o - (1.96*sei_o) ", "  mei_o + (1.96*sei_o) "]"
	di _newline(1)
	di as result "Marginal effect of Inflation for Government (Non-PM) = " mei_g
	di as result "90% CI for marginal effect for government (Non-PM) = [" mei_g - (1.65*sei_g) ", "  mei_g + (1.65*sei_g) "]"
	di as result "95% CI for marginal effect for government (Non-PM) = [" mei_g - (1.96*sei_g) ", "  mei_g + (1.96*sei_g) "]"
	di _newline(1)
	di as result "Marginal effect of Inflation for PM = " mei_pm
	di as result "90% CI for marginal effect for PM = [" mei_pm - (1.65*sei_pm) ", "  mei_pm + (1.65*sei_pm) "]"
	di as result "95% CI for marginal effect for PM = [" mei_pm - (1.96*sei_pm) ", "  mei_pm + (1.96*sei_pm) "]"

	* ME for Opposition = Government
	test CP_inf = 0

	* ME for Opposition = PM
	test PM_inf = 0
	
	* ME for Government = PM
	test CP_inf = PM_inf
	
end





