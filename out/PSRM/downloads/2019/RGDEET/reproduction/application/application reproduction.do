clear
clear matrix
clear mata
cap log close
 set linesize 80
set matsize 11000
set maxvar 10000

// Set directory to parent "reproduction" folder

*==============================================================================
*==============================================================================
*=     File-Name:      "application reproduction.do"						                  
*=     Date:           12/20/2018                         
*=     Author:         Laron Williams (williamslaro@missouri.edu)                        
*=     Purpose:        Replicate the results for the democracy diffusion example, 
*=					   PSRM Spatial Interpretation paper.                                            
*=     Data File 1:    "diffusion.dta"                                 
*=     Output File:    "application reproduction.smcl"
*=     Data Output:    "fig1.dta", "fig2.dta", "fig3.dta"	                                             
*==============================================================================
*==============================================================================

log using "application/application reproduction.smcl", replace  

*******************************************************************************
*** Load the dataset
*******************************************************************************
use "application/diffusion.dta", clear
sort ccode year 

gen log_rgdppc = log(rgdppc_pwt)
qui tab region, gen(R)

*******************************************************************************
*** Load the W for 1994: row-standardize the weights matrices with -spatwmat-
*******************************************************************************
preserve
	local y = 1994 
	
	use "application/generate data/W`y'.dta", clear
	mkmat w*, matrix(W)
	
	keep w*
	tempfile W
	save `W', replace
	spatwmat using `W', name(W) eigenval(E) stand
	spatwmat using "application/generate data/W`y'_o2.dta", name(Wo2) stand
	spatwmat using "application/generate data/W`y'_o3.dta", name(Wo3) stand	
restore

************************************************************************
*** Parameters for simulations
************************************************************************
local draws = 1000				/* How many draws?  */
local ss = 90					/* Level of statistical significance */

************************************************************************
*** Table 3: Spatial autoregressive (SAR) and spatial-X (SLX) models of the 
*** relationship between wealth and democracy
************************************************************************
preserve
	keep if year == `y'
	di "******************* Year == `y' *************************"

	*** OLS regression model
	reg fh log_rgdppc R1 R3 - R5

	*** Diagnostic tests
	spatdiag, weights(W)	
	
	*** Model 1: SAR
	spatreg fh log_rgdppc R1 R3 - R5, weights(W) eigenval(E) model(lag)
	mat r = e(resid)
	svmat r

	mat m1_b = e(b)
	mat m1_V = e(V)
	
	* Moran's I and Geary's C
	spatgsa r1, w(W) m g

	*** Model 2: SLX
	mkmat log_rgdppc, matrix(ch)
	matrix Wch = W*ch
	
	matrix W2ch = W*W*ch
	matrix W3ch = W*W*W*ch
	
	matrix Wo2ch = Wo2*ch
	matrix Wo3ch = Wo3*ch
	
	svmat Wch
	svmat W2ch
	svmat W3ch
	svmat Wo2ch
	svmat Wo3ch
	
	reg fh log_rgdppc Wch R1 R3 - R5
	vif

	mat m2_b = e(b)
	mat m2_V = e(V)	
	
	*** Model 3: SLX with higher-order effects (traditional)
	reg fh log_rgdppc Wch W2ch W3ch R1 R3 - R5
	vif

	mat m3_b = e(b)
	mat m3_V = e(V)
	
	*** Model 4: SLX with higher-order effects (higher-order contiguity)
	reg fh log_rgdppc Wch Wo2ch Wo3ch R1 R3 - R5
	vif	
	
	mat m4_b = e(b)
	mat m4_V = e(V)	
restore

********************************************************************************
*** Simulate N draws from the multivariate normal distribution for all four 
*** models
********************************************************************************

qui foreach m of numlist 1(1)4 {
	preserve
		clear
		
		local c = colsof(m`m'_b)
		
		corr2data b1 - b`c', n(`draws') means(m`m'_b) cov(m`m'_V) seed(648)
		
		mkmat b*, matrix(draws_m`m')
	restore
}


********************************************************************************
*** Table 5: Spatial partitioning of direct, indirect and total impacts of 
*** wealth on democracy from the SLX models (Models 2-4)
********************************************************************************

******************* Model 2: SLX ***************************
local m = 2						/* Model 2 */

qui foreach tv in m`m'_beta m`m'_theta1 m`m'_total {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m2)
local lo = 100 - `ss'
local hi = `ss'

qui foreach r of numlist 1(1)`rows' {

	*** Get the coefficient for GDP (first column) and the theta_1 
	*** (second column) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]

	*** Fill in the values of beta
	replace `m`m'_beta' = beta in `r'
	
	*** Generate the theta_1*W matrix
	mat theta1W = theta1 * W
	
	*** Calculate the first-order effects with the average row sum 
	*** (constant since we row-standardize)
	mata: st_matrix("o1", rowsum(st_matrix("theta1W")))
	replace `m`m'_theta1' = o1[1,1]	in `r'
	
	*** Calculate the total effects across orders
	replace `m`m'_total' = (beta + o1[1,1]) in `r'
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
foreach tv in m`m'_beta m`m'_theta1 m`m'_total {
	qui sum ``tv'', meanonly
	local mean = r(mean)
	
	_pctile ``tv'', p(`lo' `hi') 
	
	di _newline(1) "`tv': mean = " `mean' "	`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

**************** Model 3: (SLX with 3 traditional thetas) ******************
local m = 3						/* Model 3 */

qui foreach tv in m`m'_beta m`m'_direct1 m`m'_indirect1 m`m'_total1 m`m'_direct2 m`m'_indirect2 m`m'_total2 m`m'_direct3 m`m'_indirect3 m`m'_total3 m`m'_totaldirect m`m'_totalindirect m`m'_totaltotal {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m`m')
local lo = 100 - `ss'
local hi = `ss'

qui foreach r of numlist 1(1)`rows' {

		*** Get the coefficient for GDP (first column) and the three thetas (second-fourth columns) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]
	scalar theta2 = draws_m`m'[`r',3]
	scalar theta3 = draws_m`m'[`r',4]

	*** Fill in the values of beta
	replace `m`m'_beta' = beta in `r'
	
	*** Generate the spatial-X matrices
	* First-order effects
	mat theta1W = theta1 * W

	* Second-order effects
	mat theta2W = theta2 * W * W

	* Third-order effects
	mat theta3W = theta3 * W * W * W
	
	*** Calculate the first- through third-order effects with the average row sum (constant since we row-standardize)
	mata: st_matrix("deffect1", 1/rows(st_matrix("W"))*trace(st_matrix("theta1W")))
	mata: st_matrix("teffect1", 1/rows(st_matrix("W"))*sum(st_matrix("theta1W")))
	mata: st_matrix("ieffect1", 1/rows(st_matrix("W"))*(sum(st_matrix("theta1W"))-trace(st_matrix("theta1W"))))

	mata: st_matrix("deffect2", 1/rows(st_matrix("W"))*trace(st_matrix("theta2W")))
	mata: st_matrix("teffect2", 1/rows(st_matrix("W"))*sum(st_matrix("theta2W")))
	mata: st_matrix("ieffect2", 1/rows(st_matrix("W"))*(sum(st_matrix("theta2W"))-trace(st_matrix("theta2W"))))

	mata: st_matrix("deffect3", 1/rows(st_matrix("W"))*trace(st_matrix("theta3W")))
	mata: st_matrix("teffect3", 1/rows(st_matrix("W"))*sum(st_matrix("theta3W")))
	mata: st_matrix("ieffect3", 1/rows(st_matrix("W"))*(sum(st_matrix("theta3W"))-trace(st_matrix("theta3W"))))
	
	foreach o of numlist 1(1)3 {
		replace `m`m'_direct`o'' = deffect`o'[1,1] in `r'
		replace `m`m'_indirect`o'' = ieffect`o'[1,1] in `r'
		replace `m`m'_total`o'' = teffect`o'[1,1] in `r'
		
		*** Calculate the total effects across orders
		if `o' == 1 {
			replace `m`m'_totaltotal' = (teffect`o'[1,1] + `m`m'_beta') in `r'		
			replace `m`m'_totaldirect' = (deffect`o'[1,1] + `m`m'_beta') in `r'
			replace `m`m'_totalindirect' = ieffect`o'[1,1] in `r'
		}
		else {
			replace `m`m'_totaltotal' = (`m`m'_totaltotal' + teffect`o'[1,1]) in `r'
			replace `m`m'_totaldirect' = (`m`m'_totaldirect' + deffect`o'[1,1]) in `r'
			replace `m`m'_totalindirect' = (`m`m'_totalindirect' + ieffect`o'[1,1]) in `r'			
		}
	}	
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
foreach v in m`m'_beta m`m'_total1 m`m'_direct1 m`m'_indirect1 m`m'_total2 m`m'_direct2 m`m'_indirect2 m`m'_total3 m`m'_direct3 m`m'_indirect3 m`m'_totaltotal m`m'_totaldirect m`m'_totalindirect {
	qui sum ``v'', meanonly
	local mean = r(mean)
	
	_pctile ``v'', p(`lo' `hi') 
	
	di _newline(1) "`v': mean = " `mean' "		`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

********* Model 4: (SLX with 3 thetas based on higher-order contiguity) *****************
local m = 4						/* Model 4 */

qui foreach tv in m`m'_beta m`m'_direct1 m`m'_indirect1 m`m'_total1 m`m'_direct2 m`m'_indirect2 m`m'_total2 m`m'_direct3 m`m'_indirect3 m`m'_total3 m`m'_totaldirect m`m'_totalindirect m`m'_totaltotal {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m`m')
local lo = 100 - `ss'
local hi = `ss'

qui foreach r of numlist 1(1)`rows' {

	*** Get the coefficient for GDP (first column) and the three thetas (second-fourth columns) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]
	scalar theta2 = draws_m`m'[`r',3]
	scalar theta3 = draws_m`m'[`r',4]

	*** Fill in the values of beta
	replace `m`m'_beta' = beta in `r'
	
	*** Generate the spatial-X matrices
	* First-order effects
	mat theta1W = theta1 * W

	* Second-order effects
	mat theta2W = theta2 * Wo2

	* Third-order effects
	mat theta3W = theta3 * Wo3
	
	*** Calculate the first- through third-order effects with the average row sum (constant since we row-standardize)
	mata: st_matrix("deffect1", 1/rows(st_matrix("W"))*trace(st_matrix("theta1W")))
	mata: st_matrix("teffect1", 1/rows(st_matrix("W"))*sum(st_matrix("theta1W")))
	mata: st_matrix("ieffect1", 1/rows(st_matrix("W"))*(sum(st_matrix("theta1W"))-trace(st_matrix("theta1W"))))

	mata: st_matrix("deffect2", 1/rows(st_matrix("W"))*trace(st_matrix("theta2W")))
	mata: st_matrix("teffect2", 1/rows(st_matrix("W"))*sum(st_matrix("theta2W")))
	mata: st_matrix("ieffect2", 1/rows(st_matrix("W"))*(sum(st_matrix("theta2W"))-trace(st_matrix("theta2W"))))

	mata: st_matrix("deffect3", 1/rows(st_matrix("W"))*trace(st_matrix("theta3W")))
	mata: st_matrix("teffect3", 1/rows(st_matrix("W"))*sum(st_matrix("theta3W")))
	mata: st_matrix("ieffect3", 1/rows(st_matrix("W"))*(sum(st_matrix("theta3W"))-trace(st_matrix("theta3W"))))
	
	foreach o of numlist 1(1)3 {
		replace `m`m'_direct`o'' = deffect`o'[1,1] in `r'
		replace `m`m'_indirect`o'' = ieffect`o'[1,1] in `r'
		replace `m`m'_total`o'' = teffect`o'[1,1] in `r'
		
		*** Calculate the total effects across orders
		if `o' == 1 {
			replace `m`m'_totaltotal' = (teffect`o'[1,1] + `m`m'_beta') in `r'		
			replace `m`m'_totaldirect' = (deffect`o'[1,1] + `m`m'_beta') in `r'
			replace `m`m'_totalindirect' = ieffect`o'[1,1] in `r'
		}
		else {
			replace `m`m'_totaltotal' = (`m`m'_totaltotal' + teffect`o'[1,1]) in `r'
			replace `m`m'_totaldirect' = (`m`m'_totaldirect' + deffect`o'[1,1]) in `r'
			replace `m`m'_totalindirect' = (`m`m'_totalindirect' + ieffect`o'[1,1]) in `r'			
		}
	}	
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
foreach v in m`m'_beta m`m'_total1 m`m'_direct1 m`m'_indirect1 m`m'_total2 m`m'_direct2 m`m'_indirect2 m`m'_total3 m`m'_direct3 m`m'_indirect3 m`m'_totaltotal m`m'_totaldirect m`m'_totalindirect {
	qui sum ``v'', meanonly
	local mean = r(mean)
	
	_pctile ``v'', p(`lo' `hi') 
	
	di _newline(1) "`v': mean = " `mean' "		`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

********************************************************************************
*** Figure 3: Spatial diffusion patterns following a 1-unit increase in Bolivian 
*** wealth for Bolivia and other South American countries
***
*** NOTE: 
*** Bolivia, 1994 (145, or 7th column)
*** Produces the dataset ('fig2.dta') used to create the figure in R.
********************************************************************************

local m = 4						/* Model 4 */
local rows = rowsof(draws_m`m')
local ss = 90

local lo = 100 - `ss'
local hi = `ss'

mat bolivia = J(1,44,.)

qui foreach r of numlist 1(1)`rows' {
	
	*** Get the coefficient for GDP (first column) and the three thetas (second-fourth columns) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]
	scalar theta2 = draws_m`m'[`r',3]
	scalar theta3 = draws_m`m'[`r',4]

	*** Direct effects: 
	mat direct = (0\0\0\0\0\0\beta\0\0\0\0)
	mat rownames direct = effect0100 effect0101 effect0115 effect0130 effect0135 effect0140 effect0145 effect0150 effect0155 effect0160 effect0165
	
	*** Higher-order effects
	foreach o of numlist 1(1)3 {
		if `o' == 1 {
			mat theta`o'W = theta`o' * W
		}
		if `o' == 2 {
			mat theta`o'W = theta`o' * W * W
		}
		else {
			mat theta`o'W = theta`o' * W * W * W
		}
		mat sa`o' = theta`o'W[23..33,23..33]
		mat bolivia`o' = sa`o'[1..11,7]
		mat rownames bolivia`o' = effect`o'100 effect`o'101 effect`o'115 effect`o'130 effect`o'135 effect`o'140 effect`o'145 effect`o'150 effect`o'155 effect`o'160 effect`o'165
	}

	*** Generate the matrix containing the 0-order through 3-order effects for all 11 states for each of the N draws.
	if `r' == 1 {
		mat bolivia = (direct', bolivia1', bolivia2', bolivia3' )
	}
	else {
		mat bolivia = (bolivia \ direct', bolivia1', bolivia2', bolivia3' )
	}
}

*** Generate the dataset used to produce Figure 3 in R
preserve
	clear
	svmat2 bolivia, names(col)
	gen draw = _n
	reshape long effect0 effect1 effect2 effect3, i(draw) j(ccode)
	
	reshape long effect, i(draw ccode) j(order)
	
	bys ccode order: egen effect_mn = mean(effect)
	bys ccode order: egen effect_lo = pctile(effect), p(`lo')
	bys ccode order: egen effect_hi = pctile(effect), p(`hi')
	
	duplicates drop ccode order, force
	drop draw effect
	
	gen str20 country2 = ""
	replace country2 = "Argentina (1,2,3)" if ccode == 160
	replace country2 = "Bolivia (0,2,3)" if ccode == 145
	replace country2 = "Brazil (1,2,3)" if ccode == 140
	replace country2 = "Chile (1,2,3)" if ccode == 155
	replace country2 = "Colombia (2,3)" if ccode == 100
	replace country2 = "Ecuador (2,3)" if ccode == 130
	replace country2 = "Paraguay (1,2,3)" if ccode == 150
	replace country2 = "Peru (1,2,3)" if ccode == 135
	replace country2 = "Suriname (2,3)" if ccode == 115
	replace country2 = "Uruguay (2,3)" if ccode == 165
	replace country2 = "Venezuela (2,3)" if ccode == 101
	
	sort order ccode
	save "figures/fig3.dta", replace
restore

********************************************************************************
*** Table 4: Spatial partitioning of average direct, indirect and total impacts 
*** of wealth on democracy from the SAR model (Model 1)
********************************************************************************

local m = 1						/* Model 1 (SAR) */

qui foreach tv in m`m'_teffect m`m'_deffect m`m'_ieffect m`m'_teffect0 m`m'_deffect0 m`m'_ieffect0 m`m'_teffect1 m`m'_deffect1 m`m'_ieffect1 m`m'_teffect2 m`m'_deffect2 m`m'_ieffect2 m`m'_teffect3 m`m'_deffect3 m`m'_ieffect3 m`m'_teffect4 m`m'_deffect4 m`m'_ieffect4 {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m`m')
local lo = 100 - `ss'
local hi = `ss'

mat I = I(colsof(W))
mata: I = st_matrix("I")
mata: W = st_matrix("W")

* Generate the weights matrices up to order 4
local W W		
local multW *W		
foreach i of numlist 2(1)4 {
	local W `W'`multW'
	mat W`i' = `W'
}

qui foreach r of numlist 1(1)`rows' {

	scalar beta = draws_m`m'[`r',1]
	scalar rho = draws_m`m'[`r',7] 
	mata: rho = st_numscalar("rho")
	mata: beta = st_numscalar("beta")

	*** Average Effects 
	mata: pd = luinv(I-rho*W)*beta
	mata: deffect = 1/rows(W)*trace(pd)
	mata: teffect = 1/rows(W)*sum(pd)
	mata: ieffect = 1/rows(W)*(sum(pd)-trace(pd))
	
	mata: st_matrix("teffect", teffect)
	mata: st_matrix("deffect", deffect)
	mata: st_matrix("ieffect", ieffect)
	
	replace `m`m'_teffect' = teffect[1,1] in `r'
	replace `m`m'_deffect' = deffect[1,1] in `r'
	replace `m`m'_ieffect' = ieffect[1,1] in `r'
	
	*** Partitioned Effects
	mata: W2 = st_matrix("W2")
	mata: W3 = st_matrix("W3")
	mata: W4 = st_matrix("W4")

	mata: o0 = I*beta
	mata: o1 = rho*W*beta
	mata: o2 = rho^2*W2*beta
	mata: o3 = rho^3*W3*beta
	mata: o4 = rho^4*W4*beta

	mata: deffect0 = 1/rows(W)*trace(o0)
	mata: teffect0 = 1/rows(W)*sum(o0)
	mata: ieffect0 = 1/rows(W)*(sum(o0)-trace(o0))

	mata: deffect1 = 1/rows(W)*trace(o1)
	mata: teffect1 = 1/rows(W)*sum(o1)
	mata: ieffect1 = 1/rows(W)*(sum(o1)-trace(o1))

	mata: deffect2 = 1/rows(W)*trace(o2)
	mata: teffect2 = 1/rows(W)*sum(o2)
	mata: ieffect2 = 1/rows(W)*(sum(o2)-trace(o2))

	mata: deffect3 = 1/rows(W)*trace(o3)
	mata: teffect3 = 1/rows(W)*sum(o3)
	mata: ieffect3 = 1/rows(W)*(sum(o3)-trace(o3))

	mata: deffect4 = 1/rows(W)*trace(o4)
	mata: teffect4 = 1/rows(W)*sum(o4)
	mata: ieffect4 = 1/rows(W)*(sum(o4)-trace(o4))

	mata: st_matrix("teffect0", teffect0)
	mata: st_matrix("deffect0", deffect0)
	mata: st_matrix("ieffect0", ieffect0)

	mata: st_matrix("teffect1", teffect1)
	mata: st_matrix("deffect1", deffect1)
	mata: st_matrix("ieffect1", ieffect1)
	
	mata: st_matrix("teffect2", teffect2)
	mata: st_matrix("deffect2", deffect2)
	mata: st_matrix("ieffect2", ieffect2)
	
	mata: st_matrix("teffect3", teffect3)
	mata: st_matrix("deffect3", deffect3)
	mata: st_matrix("ieffect3", ieffect3)
	
	mata: st_matrix("teffect4", teffect4)
	mata: st_matrix("deffect4", deffect4)
	mata: st_matrix("ieffect4", ieffect4)	
	
	foreach o of numlist 0(1)4 {
		replace `m`m'_teffect`o'' = teffect`o'[1,1] in `r'
		replace `m`m'_deffect`o'' = deffect`o'[1,1] in `r'
		replace `m`m'_ieffect`o'' = ieffect`o'[1,1] in `r'		
	}
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
qui foreach tv in m`m'_teffect0 m`m'_deffect0 m`m'_ieffect0 m`m'_teffect1 m`m'_deffect1 m`m'_ieffect1 m`m'_teffect2 m`m'_deffect2 m`m'_ieffect2 m`m'_teffect3 m`m'_deffect3 m`m'_ieffect3 m`m'_teffect4 m`m'_deffect4 m`m'_ieffect4 m`m'_teffect m`m'_deffect m`m'_ieffect {
	nois sum ``tv'', meanonly
	local mean = r(mean)
	
	_pctile ``tv'', p(`lo' `hi') 
	
	nois di _newline(1) "`tv': mean = " `mean' "		`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

********************************************************************************
*** Figure 1: Partitioned effects of a 1-unit increase in logged real GDP per 
*** capita in Boliva, 1994 (SAR Model 1)
***
*** NOTE: 
*** Bolivia, 1994 (Observation #140, 6th column)
*** Produces the dataset ('South American Effects.dta') used to create the 
*** figure in R.
********************************************************************************

local y = 1994 					/* Year = 1994 */
	
use "application/generate data/W`y'.dta", clear
mkmat w*, matrix(W)
keep w100_1994 - w165_1994
keep in 23/33
	
keep w*
tempfile W
save `W', replace
spatwmat using `W', name(AW) stand
	
*** Create the n-order matrices by hand
local AW AW		
local multAW *AW		
foreach i of numlist 2(1)9 {
	local AW `AW'`multAW'
	mat AW`i' = `AW'
}	

*** Make these matrices available in mata
mat I = I(colsof(AW))

mata: 
	I = st_matrix("I")
	AW = st_matrix("AW")
	AW2 = st_matrix("AW2")
	AW3 = st_matrix("AW3")
	AW4 = st_matrix("AW4")

	o0 = I*beta
	o1 = rho*AW*beta
	o2 = rho^2*AW2*beta
	o3 = rho^3*AW3*beta
	o4 = rho^4*AW4*beta

	e0 = o0[.,7]
	e1 = o1[.,7]
	e2 = o2[.,7]
	e3 = o3[.,7]
	e4 = o4[.,7]

end

getmata e0 e1 e2 e3 e4

*** Generate the ccode variable from the variable names
gen str20 ccode = ""
local b = 1
qui foreach v of varlist w* {
	local ccode = substr("`v'", 2, 3)
	replace ccode = "`ccode'" in `b'
	local b = `b' + 1
}

destring ccode, force replace

preserve
	use "application/generate data/COW country codes.dta", clear
	rename statename COUNTRY
	replace COUNTRY = "Congo DRC" if COUNTRY == "Democratic Republic of the Congo"
	duplicates drop ccode, force
	keep ccode COUNTRY
	sort ccode
	tempfile cc
	save `cc', replace
restore

sort ccode
merge ccode using `cc'
tab _merge
drop if _merge == 2
drop _merge

keep COUNTRY ccode e*
order COUNTRY ccode e*

// Prepare for R/ggplot2:
rename COUNTRY region
reshape long e, i(ccode) j(order) 
rename e impact
drop if order == 4
label define order 0 "Zero-order Effects" 1 "First-order Effects" 2 "Second-order Effects" 3 "Third-order effects"
label values order order
decode order, generate(type)
drop order
gen cut = "G" if impact == 0
replace cut = "A" if impact > 1
replace cut = "B" if impact < 1 & impact > .01
replace cut = "C" if impact < .01 & impact > .005
replace cut = "D" if impact < .005 & impact > .003
replace cut = "E" if impact < .003 & impact > .001
replace cut = "F" if impact < .001 & impact > .0008

order region ccode 

save "figures/fig1.dta", replace

********************************************************************************
*** Figure 2: Spatial diffusion patterns following a 10-point increase in the 
*** Freedom House score for the Democratic Republic of the Congo
***
*** NOTE: Democratic Republic of the Congo, 1994
********************************************************************************

local m = 1						/* Model 1 (SAR) */
local y = 1994 					/* Year = 1994 */

*** Try out a few scenarios of states with a lot of neighbors
*local obs = 26					/* Observation #26 (ccode == 510): Tanzania */
local obs = 23					/* Observation #23 (ccode == 490): DRC */
*local obs = 33					/* Observation #33 (ccode == 551): Zambia */
*local obs = 17					/* Observation #17 (ccode == 471): Cameroon */

local rows = rowsof(draws_m`m')
	
use "application/generate data/W`y'.dta", clear
mkmat w*, matrix(W)
keep w403_1994 - w572_1994
keep in 72/111
	
keep w*
tempfile W
save `W', replace
spatwmat using `W', name(AW) stand

mat cf = (10)				/* Counterfactual shock: +10 for all observations */
mata: cf = st_matrix("cf")
mata: W = st_matrix("AW")

qui foreach r of numlist 1(1)`rows' {

	scalar rho = draws_m1[`r',7] 			/* First draw, for now */
	
	mata: rho = st_numscalar("rho")
	mata: cfest = (W * cf * rho)
	mata: cfest_`obs' = cfest[,`obs']'		
	mata: st_matrix("cfest", cfest_`obs')

	if `r' == 1 {
		mat cfshock = cfest
	}
	else {
		mat cfshock = (cfshock \ cfest)
	}
}	

clear
svmat cfshock
gen simno = _n
reshape long cfshock, i(simno) j(ccode)
sort ccode simno

*** Generate the mean and confidence intervals
bys ccode: egen cfshock_mn = mean(cfshock)
bys ccode: egen cfshock_lo95 = pctile(cfshock), p(2.5)
bys ccode: egen cfshock_lo90 = pctile(cfshock), p(5)
bys ccode: egen cfshock_hi90 = pctile(cfshock), p(95)
bys ccode: egen cfshock_hi95 = pctile(cfshock), p(97.5)

drop cfshock simno
duplicates drop ccode, force

*** Link the observation number to COW country codes and label the observations 
*** (with # of neighbors in parentheses)
recode ccode (1=403) (2=404) (3=411) (4=420) (5=432) (6=433) (7=434) (8=435) ///
			 (9=436) (10=437) (11=438) (12=439) (13=450) (14=451) (15=452) ///
			 (16=461) (17=471) (18=475) (19=481) (20=482) (21=483) (22=484) ///
			 (23=490) (24=500) (25=501) (26=510) (27=516) (28=517) (29=522) ///
			 (30=530) (31=540) (32=541) (33=551) (34=552) (35=553) (36=560) ///
			 (37=565) (38=570) (39=571) (40=572)

cap lab drop ccode
lab def ccode 2 "USA" 20 "Canada" 31 "Bahamas" 40 "Cuba" 41 "Haiti" ///
			  42 "Dominican Republic" 53 "Barbados" 55 "Grenada" ///
			  56 "St. Lucia" 57 "St. Vincent and the Grenadines" ///
			  51 "Jamaica" 52 "Trinidad & Tobago" 70 "Mexico" ///
			  90 "Guatemala" 91 "Honduras" 92 "El Salvador" 93 "Nicaragua" ///
			  94 "Costa Rica" 95 "Panama" 100 "Colombia" 101 "Venezuela" ///
			  110 "Guyana" 115 "Suriname" 130 "Ecuador" 135 "Peru" ///
			  140 "Brazil" 145 "Bolivia" 150 "Paraguay" 155 "Chile" ///
			  160 "Argentina" 165 "Uruguay" 200 "Great Britain" 205 "Ireland" ///
			  210 "Netherlands" 211 "Belgium" 212 "Luxembourg" 220 "France" ///
			  225 "Switzerland" 230 "Spain" 235 "Portugal" 255 "Germany" ///
			  265 "German Democratic Republic" 290 "Poland" 305 "Austria" ///
			  310 "Hungary" 315 "Czechoslovakia" 316 "Czech Republic" ///
			  317 "Slovakia" 325 "Italy" 338 "Malta" 339 "Albania" ///
			  341 "Montenegro" 343 "Macedonia" 344 "Croatia" 345 "Yugoslavia" ///
			  346 "Bosnia-Herzegovina" 349 "Slovenia" 350 "Greece" ///
			  352 "Cyprus" 355 "Bulgaria" 359 "Moldova" 360 "Romania" ///
			  365 "Russia" 366 "Estonia" 367 "Latvia" 368 "Lithuania" ///
			  369 "Ukraine" 370 "Belarus" 371 "Armenia" 372 "Georgia" ///
			  373 "Azerbaijan" 375 "Finland" 380 "Sweden" 385 "Norway" ///
			  390 "Denmark" 395 "Iceland" 402 "Cape Verde" ///
			  403 "Sao Tome and Principe (2)" 404 "Guinea-Bissau (2)" ///
			  411 "Equatorial Guinea (4)" 420 "Gambia (1)" 432 "Senegal (6)" ///
			  433 "Senegal (5)" 434 "Benin (5)" 435 "Mauritania (2)" ///
			  436 "Niger (6)" 437 "Ivory Coast (5)" 438 "Guinea (6)" ///
			  439 "Burkina Faso (6)" 450 "Liberia (3)" 451 "Sierra Leone (2)" ///
			  452 "Ghana (4)" 461 "Togo (3)" 471 "Cameroon (7)" ///
			  475 "Nigeria (5)" 481 "Gabon (4)" ///
			  482 "Central African Republic (4)" ///
			  483 "Chad (4)" 484 "Congo (5)" ///
			  490 "Democratic Republic of the Congo (8)" ///
			  500 "Uganda (4)" 501 "Kenya (3)" 510 "Tanzania (8)" ///
			  516 "Burundi (3)" 517 "Rwanda (4)" 520 "Somalia" ///
			  522 "Djibouti (1)" 530 "Ethiopia (2)" 540 "Angola (4)" ///
			  541 "Mozambique (6)" 551 "Zambia (8)" 552 "Zimbabwe (4)" ///
			  553 "Malawi (3)" 560 "South Africa (6)" 565 "Namibia (4)" ///
			  570 "Lesotho (1)" 571 "Botswana (4)" 572 "Swaziland (2)" ///
			  580 "Madagascar" 581 "Comoros" 590 "Mauritius" 591 "Seychelles" ///
			  600 "Morocco" 615 "Algeria" 616 "Tunisia" 620 "Libya" ///
			  625 "Sudan" 630 "Iran" 645 "Iraq" 651 "Egypt" 652 "Syria" ///
			  640 "Turkey" 663 "Jordan" 666 "Israel" 670 "Saudi Arabia" ///
			  678 "Yemen Arab Republic" 680 "Yemen People's Republic" ///
			  690 "Kuwait" 692 "Bahrain" 694 "Qatar" ///
			  696 "United Arab Emirates" 698 "Oman" 700 "Afghanistan" ///
			  710 "China" 713 "Taiwan" 732 "South Korea" 730 "Korea" ///
			  740 "Japan" 750 "India" 770 "Pakistan" 771 "Bangladesh" ///
			  775 "Myanmar" 780 "Sri Lanka" 781 "Maldives" 790 "Nepal" ///
			  800 "Thailand" 811 "Cambodia" 812 "Laos" 820 "Malaysia" ///
			  830 "Singapore" 840 "Philippines" 850 "Indonesia" ///
			  900 "Australia" 910 "Papua New Guinea" 920 "New Zealand" ///
			  950 "Fiji" 990 "Samoa"
			  
lab val ccode ccode

gsort -cfshock_mn
list ccode cfshock_mn cfshock_lo90 cfshock_hi90 cfshock_lo95 cfshock_hi95 if cfshock_mn > 0

decode ccode, generate(country)

save "figures/fig2.dta", replace

log close
clear
clear matrix
clear mata
cap log close
 set linesize 80
set matsize 11000
set maxvar 10000
cap cd "~/Desktop/reproduction/" 
cap cd "`:environment USERPROFILE'/Desktop/reproduction/"

*==============================================================================
*==============================================================================
*=     File-Name:      "application reproduction.do"						                  
*=     Date:           6/7/2018                         
*=     Author:         Laron Williams (williamslaro@missouri.edu)                        
*=     Purpose:        Replicate the results for the democracy diffusion example, 
*=					   PSRM Spatial Interpretation paper.                                            
*=     Data File 1:    "diffusion.dta"                                 
*=     Output File:    "application reproduction.smcl"
*=     Data Output:    "fig1.dta", "fig2.dta", "fig3.dta"	                                             
*==============================================================================
*==============================================================================

log using "application/application reproduction.smcl", replace  

*******************************************************************************
*** Load the dataset
*******************************************************************************
use "application/diffusion.dta", clear
sort ccode year 

gen log_rgdppc = log(rgdppc_pwt)
qui tab region, gen(R)

*******************************************************************************
*** Load the W for 1994: row-standardize the weights matrices with -spatwmat-
*******************************************************************************
preserve
	local y = 1994 
	
	use "application/generate data/W`y'.dta", clear
	mkmat w*, matrix(W)
	
	keep w*
	tempfile W
	save `W', replace
	spatwmat using `W', name(W) eigenval(E) stand
	spatwmat using "application/generate data/W`y'_o2.dta", name(Wo2) stand
	spatwmat using "application/generate data/W`y'_o3.dta", name(Wo3) stand	
restore

************************************************************************
*** Parameters for simulations
************************************************************************
local draws = 1000				/* How many draws?  */
local ss = 90					/* Level of statistical significance */

************************************************************************
*** Table 3: Spatial autoregressive (SAR) and spatial-X (SLX) models of the 
*** relationship between wealth and democracy
************************************************************************
preserve
	keep if year == `y'
	di "******************* Year == `y' *************************"

	*** OLS regression model
	reg fh log_rgdppc R1 R3 - R5

	*** Diagnostic tests
	spatdiag, weights(W)	
	
	*** Model 1: SAR
	spatreg fh log_rgdppc R1 R3 - R5, weights(W) eigenval(E) model(lag)
	mat r = e(resid)
	svmat r

	mat m1_b = e(b)
	mat m1_V = e(V)
	
	* Moran's I and Geary's C
	spatgsa r1, w(W) m g

	*** Model 2: SLX
	mkmat log_rgdppc, matrix(ch)
	matrix Wch = W*ch
	
	matrix W2ch = W*W*ch
	matrix W3ch = W*W*W*ch
	
	matrix Wo2ch = Wo2*ch
	matrix Wo3ch = Wo3*ch
	
	svmat Wch
	svmat W2ch
	svmat W3ch
	svmat Wo2ch
	svmat Wo3ch
	
	reg fh log_rgdppc Wch R1 R3 - R5
	vif

	mat m2_b = e(b)
	mat m2_V = e(V)	
	
	*** Model 3: SLX with higher-order effects (traditional)
	reg fh log_rgdppc Wch W2ch W3ch R1 R3 - R5
	vif

	mat m3_b = e(b)
	mat m3_V = e(V)
	
	*** Model 4: SLX with higher-order effects (higher-order contiguity)
	reg fh log_rgdppc Wch Wo2ch Wo3ch R1 R3 - R5
	vif	
	
	mat m4_b = e(b)
	mat m4_V = e(V)	
restore

********************************************************************************
*** Simulate N draws from the multivariate normal distribution for all four 
*** models
********************************************************************************

qui foreach m of numlist 1(1)4 {
	preserve
		clear
		
		local c = colsof(m`m'_b)
		
		corr2data b1 - b`c', n(`draws') means(m`m'_b) cov(m`m'_V) seed(648)
		
		mkmat b*, matrix(draws_m`m')
	restore
}


********************************************************************************
*** Table 5: Spatial partitioning of direct, indirect and total impacts of 
*** wealth on democracy from the SLX models (Models 2-4)
********************************************************************************

******************* Model 2: SLX ***************************
local m = 2						/* Model 2 */

qui foreach tv in m`m'_beta m`m'_theta1 m`m'_total {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m2)
local lo = 100 - `ss'
local hi = `ss'

qui foreach r of numlist 1(1)`rows' {

	*** Get the coefficient for GDP (first column) and the theta_1 
	*** (second column) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]

	*** Fill in the values of beta
	replace `m`m'_beta' = beta in `r'
	
	*** Generate the theta_1*W matrix
	mat theta1W = theta1 * W
	
	*** Calculate the first-order effects with the average row sum 
	*** (constant since we row-standardize)
	mata: st_matrix("o1", rowsum(st_matrix("theta1W")))
	replace `m`m'_theta1' = o1[1,1]	in `r'
	
	*** Calculate the total effects across orders
	replace `m`m'_total' = (beta + o1[1,1]) in `r'
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
foreach tv in m`m'_beta m`m'_theta1 m`m'_total {
	qui sum ``tv'', meanonly
	local mean = r(mean)
	
	_pctile ``tv'', p(`lo' `hi') 
	
	di _newline(1) "`tv': mean = " `mean' "	`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

**************** Model 3: (SLX with 3 traditional thetas) ******************
local m = 3						/* Model 3 */

qui foreach tv in m`m'_beta m`m'_direct1 m`m'_indirect1 m`m'_total1 m`m'_direct2 m`m'_indirect2 m`m'_total2 m`m'_direct3 m`m'_indirect3 m`m'_total3 m`m'_totaldirect m`m'_totalindirect m`m'_totaltotal {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m`m')
local lo = 100 - `ss'
local hi = `ss'

qui foreach r of numlist 1(1)`rows' {

		*** Get the coefficient for GDP (first column) and the three thetas (second-fourth columns) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]
	scalar theta2 = draws_m`m'[`r',3]
	scalar theta3 = draws_m`m'[`r',4]

	*** Fill in the values of beta
	replace `m`m'_beta' = beta in `r'
	
	*** Generate the spatial-X matrices
	* First-order effects
	mat theta1W = theta1 * W

	* Second-order effects
	mat theta2W = theta2 * W * W

	* Third-order effects
	mat theta3W = theta3 * W * W * W
	
	*** Calculate the first- through third-order effects with the average row sum (constant since we row-standardize)
	mata: st_matrix("deffect1", 1/rows(st_matrix("W"))*trace(st_matrix("theta1W")))
	mata: st_matrix("teffect1", 1/rows(st_matrix("W"))*sum(st_matrix("theta1W")))
	mata: st_matrix("ieffect1", 1/rows(st_matrix("W"))*(sum(st_matrix("theta1W"))-trace(st_matrix("theta1W"))))

	mata: st_matrix("deffect2", 1/rows(st_matrix("W"))*trace(st_matrix("theta2W")))
	mata: st_matrix("teffect2", 1/rows(st_matrix("W"))*sum(st_matrix("theta2W")))
	mata: st_matrix("ieffect2", 1/rows(st_matrix("W"))*(sum(st_matrix("theta2W"))-trace(st_matrix("theta2W"))))

	mata: st_matrix("deffect3", 1/rows(st_matrix("W"))*trace(st_matrix("theta3W")))
	mata: st_matrix("teffect3", 1/rows(st_matrix("W"))*sum(st_matrix("theta3W")))
	mata: st_matrix("ieffect3", 1/rows(st_matrix("W"))*(sum(st_matrix("theta3W"))-trace(st_matrix("theta3W"))))
	
	foreach o of numlist 1(1)3 {
		replace `m`m'_direct`o'' = deffect`o'[1,1] in `r'
		replace `m`m'_indirect`o'' = ieffect`o'[1,1] in `r'
		replace `m`m'_total`o'' = teffect`o'[1,1] in `r'
		
		*** Calculate the total effects across orders
		if `o' == 1 {
			replace `m`m'_totaltotal' = (teffect`o'[1,1] + `m`m'_beta') in `r'		
			replace `m`m'_totaldirect' = (deffect`o'[1,1] + `m`m'_beta') in `r'
			replace `m`m'_totalindirect' = ieffect`o'[1,1] in `r'
		}
		else {
			replace `m`m'_totaltotal' = (`m`m'_totaltotal' + teffect`o'[1,1]) in `r'
			replace `m`m'_totaldirect' = (`m`m'_totaldirect' + deffect`o'[1,1]) in `r'
			replace `m`m'_totalindirect' = (`m`m'_totalindirect' + ieffect`o'[1,1]) in `r'			
		}
	}	
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
foreach v in m`m'_beta m`m'_total1 m`m'_direct1 m`m'_indirect1 m`m'_total2 m`m'_direct2 m`m'_indirect2 m`m'_total3 m`m'_direct3 m`m'_indirect3 m`m'_totaltotal m`m'_totaldirect m`m'_totalindirect {
	qui sum ``v'', meanonly
	local mean = r(mean)
	
	_pctile ``v'', p(`lo' `hi') 
	
	di _newline(1) "`v': mean = " `mean' "		`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

********* Model 4: (SLX with 3 thetas based on higher-order contiguity) *****************
local m = 4						/* Model 4 */

qui foreach tv in m`m'_beta m`m'_direct1 m`m'_indirect1 m`m'_total1 m`m'_direct2 m`m'_indirect2 m`m'_total2 m`m'_direct3 m`m'_indirect3 m`m'_total3 m`m'_totaldirect m`m'_totalindirect m`m'_totaltotal {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m`m')
local lo = 100 - `ss'
local hi = `ss'

qui foreach r of numlist 1(1)`rows' {

	*** Get the coefficient for GDP (first column) and the three thetas (second-fourth columns) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]
	scalar theta2 = draws_m`m'[`r',3]
	scalar theta3 = draws_m`m'[`r',4]

	*** Fill in the values of beta
	replace `m`m'_beta' = beta in `r'
	
	*** Generate the spatial-X matrices
	* First-order effects
	mat theta1W = theta1 * W

	* Second-order effects
	mat theta2W = theta2 * Wo2

	* Third-order effects
	mat theta3W = theta3 * Wo3
	
	*** Calculate the first- through third-order effects with the average row sum (constant since we row-standardize)
	mata: st_matrix("deffect1", 1/rows(st_matrix("W"))*trace(st_matrix("theta1W")))
	mata: st_matrix("teffect1", 1/rows(st_matrix("W"))*sum(st_matrix("theta1W")))
	mata: st_matrix("ieffect1", 1/rows(st_matrix("W"))*(sum(st_matrix("theta1W"))-trace(st_matrix("theta1W"))))

	mata: st_matrix("deffect2", 1/rows(st_matrix("W"))*trace(st_matrix("theta2W")))
	mata: st_matrix("teffect2", 1/rows(st_matrix("W"))*sum(st_matrix("theta2W")))
	mata: st_matrix("ieffect2", 1/rows(st_matrix("W"))*(sum(st_matrix("theta2W"))-trace(st_matrix("theta2W"))))

	mata: st_matrix("deffect3", 1/rows(st_matrix("W"))*trace(st_matrix("theta3W")))
	mata: st_matrix("teffect3", 1/rows(st_matrix("W"))*sum(st_matrix("theta3W")))
	mata: st_matrix("ieffect3", 1/rows(st_matrix("W"))*(sum(st_matrix("theta3W"))-trace(st_matrix("theta3W"))))
	
	foreach o of numlist 1(1)3 {
		replace `m`m'_direct`o'' = deffect`o'[1,1] in `r'
		replace `m`m'_indirect`o'' = ieffect`o'[1,1] in `r'
		replace `m`m'_total`o'' = teffect`o'[1,1] in `r'
		
		*** Calculate the total effects across orders
		if `o' == 1 {
			replace `m`m'_totaltotal' = (teffect`o'[1,1] + `m`m'_beta') in `r'		
			replace `m`m'_totaldirect' = (deffect`o'[1,1] + `m`m'_beta') in `r'
			replace `m`m'_totalindirect' = ieffect`o'[1,1] in `r'
		}
		else {
			replace `m`m'_totaltotal' = (`m`m'_totaltotal' + teffect`o'[1,1]) in `r'
			replace `m`m'_totaldirect' = (`m`m'_totaldirect' + deffect`o'[1,1]) in `r'
			replace `m`m'_totalindirect' = (`m`m'_totalindirect' + ieffect`o'[1,1]) in `r'			
		}
	}	
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
foreach v in m`m'_beta m`m'_total1 m`m'_direct1 m`m'_indirect1 m`m'_total2 m`m'_direct2 m`m'_indirect2 m`m'_total3 m`m'_direct3 m`m'_indirect3 m`m'_totaltotal m`m'_totaldirect m`m'_totalindirect {
	qui sum ``v'', meanonly
	local mean = r(mean)
	
	_pctile ``v'', p(`lo' `hi') 
	
	di _newline(1) "`v': mean = " `mean' "		`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

********************************************************************************
*** Figure 3: Spatial diffusion patterns following a 1-unit increase in Bolivian 
*** wealth for Bolivia and other South American countries
***
*** NOTE: 
*** Bolivia, 1994 (145, or 7th column)
*** Produces the dataset ('fig2.dta') used to create the figure in R.
********************************************************************************

local m = 4						/* Model 4 */
local rows = rowsof(draws_m`m')
local ss = 90

local lo = 100 - `ss'
local hi = `ss'

mat bolivia = J(1,44,.)

qui foreach r of numlist 1(1)`rows' {
	
	*** Get the coefficient for GDP (first column) and the three thetas (second-fourth columns) in each draw
	scalar beta = draws_m`m'[`r',1]
	scalar theta1 = draws_m`m'[`r',2]
	scalar theta2 = draws_m`m'[`r',3]
	scalar theta3 = draws_m`m'[`r',4]

	*** Direct effects: 
	mat direct = (0\0\0\0\0\0\beta\0\0\0\0)
	mat rownames direct = effect0100 effect0101 effect0115 effect0130 effect0135 effect0140 effect0145 effect0150 effect0155 effect0160 effect0165
	
	*** Higher-order effects
	foreach o of numlist 1(1)3 {
		if `o' == 1 {
			mat theta`o'W = theta`o' * W
		}
		if `o' == 2 {
			mat theta`o'W = theta`o' * W * W
		}
		else {
			mat theta`o'W = theta`o' * W * W * W
		}
		mat sa`o' = theta`o'W[23..33,23..33]
		mat bolivia`o' = sa`o'[1..11,7]
		mat rownames bolivia`o' = effect`o'100 effect`o'101 effect`o'115 effect`o'130 effect`o'135 effect`o'140 effect`o'145 effect`o'150 effect`o'155 effect`o'160 effect`o'165
	}

	*** Generate the matrix containing the 0-order through 3-order effects for all 11 states for each of the N draws.
	if `r' == 1 {
		mat bolivia = (direct', bolivia1', bolivia2', bolivia3' )
	}
	else {
		mat bolivia = (bolivia \ direct', bolivia1', bolivia2', bolivia3' )
	}
}

*** Generate the dataset used to produce Figure 3 in R
preserve
	clear
	svmat2 bolivia, names(col)
	gen draw = _n
	reshape long effect0 effect1 effect2 effect3, i(draw) j(ccode)
	
	reshape long effect, i(draw ccode) j(order)
	
	bys ccode order: egen effect_mn = mean(effect)
	bys ccode order: egen effect_lo = pctile(effect), p(`lo')
	bys ccode order: egen effect_hi = pctile(effect), p(`hi')
	
	duplicates drop ccode order, force
	drop draw effect
	
	gen str20 country2 = ""
	replace country2 = "Argentina (1,2,3)" if ccode == 160
	replace country2 = "Bolivia (0,2,3)" if ccode == 145
	replace country2 = "Brazil (1,2,3)" if ccode == 140
	replace country2 = "Chile (1,2,3)" if ccode == 155
	replace country2 = "Colombia (2,3)" if ccode == 100
	replace country2 = "Ecuador (2,3)" if ccode == 130
	replace country2 = "Paraguay (1,2,3)" if ccode == 150
	replace country2 = "Peru (1,2,3)" if ccode == 135
	replace country2 = "Suriname (2,3)" if ccode == 115
	replace country2 = "Uruguay (2,3)" if ccode == 165
	replace country2 = "Venezuela (2,3)" if ccode == 101
	
	sort order ccode
	save "figures/fig3.dta", replace
restore

********************************************************************************
*** Table 4: Spatial partitioning of average direct, indirect and total impacts 
*** of wealth on democracy from the SAR model (Model 1)
********************************************************************************

local m = 1						/* Model 1 (SAR) */

qui foreach tv in m`m'_teffect m`m'_deffect m`m'_ieffect m`m'_teffect0 m`m'_deffect0 m`m'_ieffect0 m`m'_teffect1 m`m'_deffect1 m`m'_ieffect1 m`m'_teffect2 m`m'_deffect2 m`m'_ieffect2 m`m'_teffect3 m`m'_deffect3 m`m'_ieffect3 m`m'_teffect4 m`m'_deffect4 m`m'_ieffect4 {
	tempvar `tv'
	gen ``tv'' = .
}

local rows = rowsof(draws_m`m')
local lo = 100 - `ss'
local hi = `ss'

mat I = I(colsof(W))
mata: I = st_matrix("I")
mata: W = st_matrix("W")

* Generate the weights matrices up to order 4
local W W		
local multW *W		
foreach i of numlist 2(1)4 {
	local W `W'`multW'
	mat W`i' = `W'
}

qui foreach r of numlist 1(1)`rows' {

	scalar beta = draws_m`m'[`r',1]
	scalar rho = draws_m`m'[`r',7] 
	mata: rho = st_numscalar("rho")
	mata: beta = st_numscalar("beta")

	*** Average Effects 
	mata: pd = luinv(I-rho*W)*beta
	mata: deffect = 1/rows(W)*trace(pd)
	mata: teffect = 1/rows(W)*sum(pd)
	mata: ieffect = 1/rows(W)*(sum(pd)-trace(pd))
	
	mata: st_matrix("teffect", teffect)
	mata: st_matrix("deffect", deffect)
	mata: st_matrix("ieffect", ieffect)
	
	replace `m`m'_teffect' = teffect[1,1] in `r'
	replace `m`m'_deffect' = deffect[1,1] in `r'
	replace `m`m'_ieffect' = ieffect[1,1] in `r'
	
	*** Partitioned Effects
	mata: W2 = st_matrix("W2")
	mata: W3 = st_matrix("W3")
	mata: W4 = st_matrix("W4")

	mata: o0 = I*beta
	mata: o1 = rho*W*beta
	mata: o2 = rho^2*W2*beta
	mata: o3 = rho^3*W3*beta
	mata: o4 = rho^4*W4*beta

	mata: deffect0 = 1/rows(W)*trace(o0)
	mata: teffect0 = 1/rows(W)*sum(o0)
	mata: ieffect0 = 1/rows(W)*(sum(o0)-trace(o0))

	mata: deffect1 = 1/rows(W)*trace(o1)
	mata: teffect1 = 1/rows(W)*sum(o1)
	mata: ieffect1 = 1/rows(W)*(sum(o1)-trace(o1))

	mata: deffect2 = 1/rows(W)*trace(o2)
	mata: teffect2 = 1/rows(W)*sum(o2)
	mata: ieffect2 = 1/rows(W)*(sum(o2)-trace(o2))

	mata: deffect3 = 1/rows(W)*trace(o3)
	mata: teffect3 = 1/rows(W)*sum(o3)
	mata: ieffect3 = 1/rows(W)*(sum(o3)-trace(o3))

	mata: deffect4 = 1/rows(W)*trace(o4)
	mata: teffect4 = 1/rows(W)*sum(o4)
	mata: ieffect4 = 1/rows(W)*(sum(o4)-trace(o4))

	mata: st_matrix("teffect0", teffect0)
	mata: st_matrix("deffect0", deffect0)
	mata: st_matrix("ieffect0", ieffect0)

	mata: st_matrix("teffect1", teffect1)
	mata: st_matrix("deffect1", deffect1)
	mata: st_matrix("ieffect1", ieffect1)
	
	mata: st_matrix("teffect2", teffect2)
	mata: st_matrix("deffect2", deffect2)
	mata: st_matrix("ieffect2", ieffect2)
	
	mata: st_matrix("teffect3", teffect3)
	mata: st_matrix("deffect3", deffect3)
	mata: st_matrix("ieffect3", ieffect3)
	
	mata: st_matrix("teffect4", teffect4)
	mata: st_matrix("deffect4", deffect4)
	mata: st_matrix("ieffect4", ieffect4)	
	
	foreach o of numlist 0(1)4 {
		replace `m`m'_teffect`o'' = teffect`o'[1,1] in `r'
		replace `m`m'_deffect`o'' = deffect`o'[1,1] in `r'
		replace `m`m'_ieffect`o'' = ieffect`o'[1,1] in `r'		
	}
}

*** Generate the mean, lower and upper confidence intervals from the N draws 
qui foreach tv in m`m'_teffect0 m`m'_deffect0 m`m'_ieffect0 m`m'_teffect1 m`m'_deffect1 m`m'_ieffect1 m`m'_teffect2 m`m'_deffect2 m`m'_ieffect2 m`m'_teffect3 m`m'_deffect3 m`m'_ieffect3 m`m'_teffect4 m`m'_deffect4 m`m'_ieffect4 m`m'_teffect m`m'_deffect m`m'_ieffect {
	nois sum ``tv'', meanonly
	local mean = r(mean)
	
	_pctile ``tv'', p(`lo' `hi') 
	
	nois di _newline(1) "`tv': mean = " `mean' "		`ss'% CI: [" `r(r1)' ", " `r(r2)' "]"
}

********************************************************************************
*** Figure 1: Partitioned effects of a 1-unit increase in logged real GDP per 
*** capita in Boliva, 1994 (SAR Model 1)
***
*** NOTE: 
*** Bolivia, 1994 (Observation #140, 6th column)
*** Produces the dataset ('South American Effects.dta') used to create the 
*** figure in R.
********************************************************************************

local y = 1994 					/* Year = 1994 */
	
use "application/generate data/W`y'.dta", clear
mkmat w*, matrix(W)
keep w100_1994 - w165_1994
keep in 23/33
	
keep w*
tempfile W
save `W', replace
spatwmat using `W', name(AW) stand
	
*** Create the n-order matrices by hand
local AW AW		
local multAW *AW		
foreach i of numlist 2(1)9 {
	local AW `AW'`multAW'
	mat AW`i' = `AW'
}	

*** Make these matrices available in mata
mat I = I(colsof(AW))

mata: 
	I = st_matrix("I")
	AW = st_matrix("AW")
	AW2 = st_matrix("AW2")
	AW3 = st_matrix("AW3")
	AW4 = st_matrix("AW4")

	o0 = I*beta
	o1 = rho*AW*beta
	o2 = rho^2*AW2*beta
	o3 = rho^3*AW3*beta
	o4 = rho^4*AW4*beta

	e0 = o0[.,7]
	e1 = o1[.,7]
	e2 = o2[.,7]
	e3 = o3[.,7]
	e4 = o4[.,7]

end

getmata e0 e1 e2 e3 e4

*** Generate the ccode variable from the variable names
gen str20 ccode = ""
local b = 1
qui foreach v of varlist w* {
	local ccode = substr("`v'", 2, 3)
	replace ccode = "`ccode'" in `b'
	local b = `b' + 1
}

destring ccode, force replace

preserve
	use "application/generate data/COW country codes.dta", clear
	rename statename COUNTRY
	replace COUNTRY = "Congo DRC" if COUNTRY == "Democratic Republic of the Congo"
	duplicates drop ccode, force
	keep ccode COUNTRY
	sort ccode
	tempfile cc
	save `cc', replace
restore

sort ccode
merge ccode using `cc'
tab _merge
drop if _merge == 2
drop _merge

keep COUNTRY ccode e*
order COUNTRY ccode e*

// Prepare for R/ggplot2:
rename COUNTRY region
reshape long e, i(ccode) j(order) 
rename e impact
drop if order == 4
label define order 0 "Zero-order Effects" 1 "First-order Effects" 2 "Second-order Effects" 3 "Third-order effects"
label values order order
decode order, generate(type)
drop order
gen cut = "G" if impact == 0
replace cut = "A" if impact > 1
replace cut = "B" if impact < 1 & impact > .01
replace cut = "C" if impact < .01 & impact > .005
replace cut = "D" if impact < .005 & impact > .003
replace cut = "E" if impact < .003 & impact > .001
replace cut = "F" if impact < .001 & impact > .0008

order region ccode 

save "figures/fig1.dta", replace

********************************************************************************
*** Figure 2: Spatial diffusion patterns following a 10-point increase in the 
*** Freedom House score for the Democratic Republic of the Congo
***
*** NOTE: Democratic Republic of the Congo, 1994
********************************************************************************

local m = 1						/* Model 1 (SAR) */
local y = 1994 					/* Year = 1994 */

*** Try out a few scenarios of states with a lot of neighbors
*local obs = 26					/* Observation #26 (ccode == 510): Tanzania */
local obs = 23					/* Observation #23 (ccode == 490): DRC */
*local obs = 33					/* Observation #33 (ccode == 551): Zambia */
*local obs = 17					/* Observation #17 (ccode == 471): Cameroon */

local rows = rowsof(draws_m`m')
	
use "application/generate data/W`y'.dta", clear
mkmat w*, matrix(W)
keep w403_1994 - w572_1994
keep in 72/111
	
keep w*
tempfile W
save `W', replace
spatwmat using `W', name(AW) stand

mat cf = (10)				/* Counterfactual shock: +10 for all observations */
mata: cf = st_matrix("cf")
mata: W = st_matrix("AW")

qui foreach r of numlist 1(1)`rows' {

	scalar rho = draws_m1[`r',7] 			/* First draw, for now */
	
	mata: rho = st_numscalar("rho")
	mata: cfest = (W * cf * rho)
	mata: cfest_`obs' = cfest[,`obs']'		
	mata: st_matrix("cfest", cfest_`obs')

	if `r' == 1 {
		mat cfshock = cfest
	}
	else {
		mat cfshock = (cfshock \ cfest)
	}
}	

clear
svmat cfshock
gen simno = _n
reshape long cfshock, i(simno) j(ccode)
sort ccode simno

*** Generate the mean and confidence intervals
bys ccode: egen cfshock_mn = mean(cfshock)
bys ccode: egen cfshock_lo95 = pctile(cfshock), p(2.5)
bys ccode: egen cfshock_lo90 = pctile(cfshock), p(5)
bys ccode: egen cfshock_hi90 = pctile(cfshock), p(95)
bys ccode: egen cfshock_hi95 = pctile(cfshock), p(97.5)

drop cfshock simno
duplicates drop ccode, force

*** Link the observation number to COW country codes and label the observations 
*** (with # of neighbors in parentheses)
recode ccode (1=403) (2=404) (3=411) (4=420) (5=432) (6=433) (7=434) (8=435) ///
			 (9=436) (10=437) (11=438) (12=439) (13=450) (14=451) (15=452) ///
			 (16=461) (17=471) (18=475) (19=481) (20=482) (21=483) (22=484) ///
			 (23=490) (24=500) (25=501) (26=510) (27=516) (28=517) (29=522) ///
			 (30=530) (31=540) (32=541) (33=551) (34=552) (35=553) (36=560) ///
			 (37=565) (38=570) (39=571) (40=572)

cap lab drop ccode
lab def ccode 2 "USA" 20 "Canada" 31 "Bahamas" 40 "Cuba" 41 "Haiti" ///
			  42 "Dominican Republic" 53 "Barbados" 55 "Grenada" ///
			  56 "St. Lucia" 57 "St. Vincent and the Grenadines" ///
			  51 "Jamaica" 52 "Trinidad & Tobago" 70 "Mexico" ///
			  90 "Guatemala" 91 "Honduras" 92 "El Salvador" 93 "Nicaragua" ///
			  94 "Costa Rica" 95 "Panama" 100 "Colombia" 101 "Venezuela" ///
			  110 "Guyana" 115 "Suriname" 130 "Ecuador" 135 "Peru" ///
			  140 "Brazil" 145 "Bolivia" 150 "Paraguay" 155 "Chile" ///
			  160 "Argentina" 165 "Uruguay" 200 "Great Britain" 205 "Ireland" ///
			  210 "Netherlands" 211 "Belgium" 212 "Luxembourg" 220 "France" ///
			  225 "Switzerland" 230 "Spain" 235 "Portugal" 255 "Germany" ///
			  265 "German Democratic Republic" 290 "Poland" 305 "Austria" ///
			  310 "Hungary" 315 "Czechoslovakia" 316 "Czech Republic" ///
			  317 "Slovakia" 325 "Italy" 338 "Malta" 339 "Albania" ///
			  341 "Montenegro" 343 "Macedonia" 344 "Croatia" 345 "Yugoslavia" ///
			  346 "Bosnia-Herzegovina" 349 "Slovenia" 350 "Greece" ///
			  352 "Cyprus" 355 "Bulgaria" 359 "Moldova" 360 "Romania" ///
			  365 "Russia" 366 "Estonia" 367 "Latvia" 368 "Lithuania" ///
			  369 "Ukraine" 370 "Belarus" 371 "Armenia" 372 "Georgia" ///
			  373 "Azerbaijan" 375 "Finland" 380 "Sweden" 385 "Norway" ///
			  390 "Denmark" 395 "Iceland" 402 "Cape Verde" ///
			  403 "Sao Tome and Principe (2)" 404 "Guinea-Bissau (2)" ///
			  411 "Equatorial Guinea (4)" 420 "Gambia (1)" 432 "Senegal (6)" ///
			  433 "Senegal (5)" 434 "Benin (5)" 435 "Mauritania (2)" ///
			  436 "Niger (6)" 437 "Ivory Coast (5)" 438 "Guinea (6)" ///
			  439 "Burkina Faso (6)" 450 "Liberia (3)" 451 "Sierra Leone (2)" ///
			  452 "Ghana (4)" 461 "Togo (3)" 471 "Cameroon (7)" ///
			  475 "Nigeria (5)" 481 "Gabon (4)" ///
			  482 "Central African Republic (4)" ///
			  483 "Chad (4)" 484 "Congo (5)" ///
			  490 "Democratic Republic of the Congo (8)" ///
			  500 "Uganda (4)" 501 "Kenya (3)" 510 "Tanzania (8)" ///
			  516 "Burundi (3)" 517 "Rwanda (4)" 520 "Somalia" ///
			  522 "Djibouti (1)" 530 "Ethiopia (2)" 540 "Angola (4)" ///
			  541 "Mozambique (6)" 551 "Zambia (8)" 552 "Zimbabwe (4)" ///
			  553 "Malawi (3)" 560 "South Africa (6)" 565 "Namibia (4)" ///
			  570 "Lesotho (1)" 571 "Botswana (4)" 572 "Swaziland (2)" ///
			  580 "Madagascar" 581 "Comoros" 590 "Mauritius" 591 "Seychelles" ///
			  600 "Morocco" 615 "Algeria" 616 "Tunisia" 620 "Libya" ///
			  625 "Sudan" 630 "Iran" 645 "Iraq" 651 "Egypt" 652 "Syria" ///
			  640 "Turkey" 663 "Jordan" 666 "Israel" 670 "Saudi Arabia" ///
			  678 "Yemen Arab Republic" 680 "Yemen People's Republic" ///
			  690 "Kuwait" 692 "Bahrain" 694 "Qatar" ///
			  696 "United Arab Emirates" 698 "Oman" 700 "Afghanistan" ///
			  710 "China" 713 "Taiwan" 732 "South Korea" 730 "Korea" ///
			  740 "Japan" 750 "India" 770 "Pakistan" 771 "Bangladesh" ///
			  775 "Myanmar" 780 "Sri Lanka" 781 "Maldives" 790 "Nepal" ///
			  800 "Thailand" 811 "Cambodia" 812 "Laos" 820 "Malaysia" ///
			  830 "Singapore" 840 "Philippines" 850 "Indonesia" ///
			  900 "Australia" 910 "Papua New Guinea" 920 "New Zealand" ///
			  950 "Fiji" 990 "Samoa"
			  
lab val ccode ccode

gsort -cfshock_mn
list ccode cfshock_mn cfshock_lo90 cfshock_hi90 cfshock_lo95 cfshock_hi95 if cfshock_mn > 0

decode ccode, generate(country)

save "figures/fig2.dta", replace

log close

translate "application/application reproduction.smcl" ///
		  "application/application reproduction.pdf", trans(smcl2pdf)

clear
