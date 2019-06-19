/***********************************************

*												*

*	Do-File which generates estimation results	*

*												*

************************************************/

version 12.1
clear
clear matrix
set more off
capture log close



// Set working directory (has to be adjusted by the user)
cd "`c(pwd)'/"


// Log-file
log using "estimation_results.log", replace





*******************************************************************************************
*                                                                                         *
*   Table 3 - Nonlinear Estimation and Kmenta Approximation of CES - Electricity Sector   * 	
*                                                                                         *
*******************************************************************************************

qui{

	* Load data
	use "electricity_sector.dta"

	* Generate dummies
	tab country, gen(c)

	global COUNTRY {b_c1}*c1+{b_c2}*c2+{b_c3}*c3+{b_c4}*c4+{b_c5}*c5+{b_c6}*c6+{b_c7}*c7+{b_c8}*c8+{b_c9}*c9+{b_c10}*c10+{b_c11}*c11+ {b_c12}*c12 + {b_c13}*c13 + {b_c14}*c14 + {b_c15}*c15 + {b_c16}*c16 + {b_c17}*c17 + {b_c18}*c18 + {b_c19}*c19 + {b_c20}*c20 + {b_c21}*c21 + {b_c22}*c22 + {b_c23}*c23 + {b_c24}*c24 + {b_c25}*c25

	global COUNTRY2 {b_c1}*inrange(newid,1,1)+{b_c2}*inrange(newid,2,2)+{b_c3}*inrange(newid,3,3)+{b_c4}*inrange(newid,4,4)+{b_c5}*inrange(newid,5,5)+{b_c6}*inrange(newid,6,6)+{b_c7}*inrange(newid,7,7)+{b_c8}*inrange(newid,8,8)+ ///
	{b_c9}*inrange(newid,9,9)+{b_c10}*inrange(newid,10,10)+{b_c11}*inrange(newid,11,11)+ {b_c12}*inrange(newid,12,12) + {b_c13}*inrange(newid,13,13) + {b_c14}*inrange(newid,14,14) + {b_c15}*inrange(newid,15,15) + {b_c16}*inrange(newid,16,16) + ///
	 {b_c17}*inrange(newid,17,17) + {b_c18}*inrange(newid,18,18) + {b_c19}*inrange(newid,19,19) + {b_c20}*inrange(newid,20,20) + {b_c21}*inrange(newid,21,21) + {b_c22}*inrange(newid,22,22) + {b_c23}*inrange(newid,23,23) + {b_c24}*inrange(newid,24,24) + ///
	 {b_c25}*inrange(newid,25,25)

	* Generate country-id
	egen id = group(country)

}




***
* Column 1: Nonlinear Estimation of CES in Levels - Electricity Sector
***

macro drop _*

* Estimation
#delimit ;
nl ( ln_eg = {a} + {d}*year +
${COUNTRY}    
+(1/{psi}*ln({omega}*EC_c^({psi})+(1-{omega})*EC_d^({psi}))) ) , 
initial( a 20 d 0.01 psi -0.5 omega 0.5) vce(cluster country) iterate(100);
#delimit cr
est store e_ces

local a = _b[/a]
local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]

* Bootstrapping
#delimit ;
nl ( ln_eg = {a} + {d}*year +
${COUNTRY2}    
+(1/{psi}*ln({omega}*EC_c^({psi})+(1-{omega})*EC_d^({psi}))) ) , 
initial( a `a' d `d' psi `psi' omega `omega') vce(bootstrap, cluster(country) idcluster(newid) reps(400) reject(_b[/psi] > 1 | _se[/psi] == 0) seed(123)) iterate(100);
#delimit cr
est store e_ces

* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1





***
* Column 2: Nonlinear Estimation of CES in First Differences - Electricity Sector
***

macro drop _*

xtset id year

* Generate variables in first differences
gen d1ln_eg = D.ln_eg
gen l1EC_c = L.EC_c
gen l1EC_d = L.EC_d
gen l1FU_d = L.FU_d

xtset id

* Estimation
#delimit ;
nl ( d1ln_eg = {d}
+(1/({psi})*ln( ( {omega}*EC_c^({psi})+(1-{omega})*EC_d^({psi})) / ( {omega}*l1EC_c^({psi})+ (1-{omega})*l1EC_d^({psi})) ) ) ) if year >= 1996, 
initial( d 0.01 psi -0.5 omega 0.5) vce(cluster country);
#delimit cr
est store e_ces

local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]

* Bootstrapping
#delimit ;
nl ( d1ln_eg = {d}
+(1/({psi})*ln( ( {omega}*EC_c^({psi})+(1-{omega})*EC_d^({psi})) / ( {omega}*l1EC_c^({psi})+ (1-{omega})*l1EC_d^({psi})) ) ) ) if year >= 1996, 
initial( d `d' psi `psi' omega `omega') vce(bootstrap, cluster(country) reps(400) reject(_b[/psi] > 1 | _se[/psi] == 0) seed(123));
#delimit cr
est store e_ces


* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1






***
* Column 3: Linear Estimation of Kmenta Approximation in Levels - Electricity Sector
***

macro drop _*

* OLS
reg ln_egecd c1-c25 year ln_eccd ln_eccd_2, vce(cluster country)

*		(d: _b[t]) ///

nlcom 	(a: _b[_cons]) ///
		(d: _b[year]) ///
		(omega: _b[ln_eccd]) ///
		(psi:  ((_b[ln_eccd]*(1-_b[ln_eccd])/(_b[ln_eccd]*(1-_b[ln_eccd])-_b[ln_eccd_2])) - 1) / (_b[ln_eccd]*(1-_b[ln_eccd])/(_b[ln_eccd]*(1-_b[ln_eccd])-_b[ln_eccd_2]))) ///
		
testnl  (((_b[ln_eccd]*(1-_b[ln_eccd])/(_b[ln_eccd]*(1-_b[ln_eccd])-_b[ln_eccd_2])) - 1) / (_b[ln_eccd]*(1-_b[ln_eccd])/(_b[ln_eccd]*(1-_b[ln_eccd])-_b[ln_eccd_2])) = 0)
dis "sigma: " _b[ln_eccd]*(1-_b[ln_eccd])/(_b[ln_eccd]*(1-_b[ln_eccd])-_b[ln_eccd_2]) 
dis e(r2_a)






***
* Column 4: Linear Estimation of Kmenta Approximation in First Differences - Electricity Sector
***

macro drop _*

xtset id year
gen dln_egecd = D.ln_egecd
gen dln_eccd = D.ln_eccd 
gen dln_eccd_2 = D.ln_eccd_2

* FD-OLS
reg dln_egecd dln_eccd dln_eccd_2, vce(cluster country)

nlcom 	(d: _b[_cons]) ///
		(omega: _b[dln_eccd]) ///
		(psi:  ((_b[dln_eccd]*(1-_b[dln_eccd])/(_b[dln_eccd]*(1-_b[dln_eccd])-_b[dln_eccd_2])) - 1) / (_b[dln_eccd]*(1-_b[dln_eccd])/(_b[dln_eccd]*(1-_b[dln_eccd])-_b[dln_eccd_2])))

testnl  (((_b[dln_eccd]*(1-_b[dln_eccd])/(_b[dln_eccd]*(1-_b[dln_eccd])-_b[dln_eccd_2])) - 1) / (_b[dln_eccd]*(1-_b[dln_eccd])/(_b[dln_eccd]*(1-_b[dln_eccd])-_b[dln_eccd_2])) = 0)
dis "sigma: " _b[dln_eccd]*(1-_b[dln_eccd])/(_b[dln_eccd]*(1-_b[dln_eccd])-_b[dln_eccd_2]) 
dis e(r2_a)








*****************************************************************************************************************************
*                                                                                                                           *
*   Table 4 - Nonlinear Estimation and Kmenta Approximation of CES with an Alternative Capital Proxy - Electricity Sector   * 	
*                                                                                                                           *
*****************************************************************************************************************************

qui{

	clear

	macro drop _*

	* Load data
	use "electricity_sector.dta"
	
	* Define Sample
	reg ln_eg EC_c_alt EC_d_alt EC_total  FU_d 										
	keep if e(sample)

	* Generate dummies
	tab country if e(sample), gen(c)
	global COUNTRY {b_c1}*c1+{b_c2}*c2+{b_c3}*c3+{b_c4}*c4+{b_c5}*c5+{b_c6}*c6+{b_c7}*c7+{b_c8}*c8+{b_c9}*c9+{b_c10}*c10+{b_c11}*c11+ {b_c12}*c12 + {b_c13}*c13 + {b_c14}*c14 + {b_c15}*c15 + {b_c16}*c16 + {b_c17}*c17 + {b_c18}*c18 + {b_c19}*c19 + {b_c20}*c20 + {b_c21}*c21 + {b_c22}*c22 + {b_c23}*c23 + {b_c24}*c24 + {b_c25}*c25

	global COUNTRY2 {b_c1}*inrange(newid,1,1)+{b_c2}*inrange(newid,2,2)+{b_c3}*inrange(newid,3,3)+{b_c4}*inrange(newid,4,4)+{b_c5}*inrange(newid,5,5)+{b_c6}*inrange(newid,6,6)+{b_c7}*inrange(newid,7,7)+{b_c8}*inrange(newid,8,8)+ ///
	{b_c9}*inrange(newid,9,9)+{b_c10}*inrange(newid,10,10)+{b_c11}*inrange(newid,11,11)+ {b_c12}*inrange(newid,12,12) + {b_c13}*inrange(newid,13,13) + {b_c14}*inrange(newid,14,14) + {b_c15}*inrange(newid,15,15) + {b_c16}*inrange(newid,16,16) + ///
	 {b_c17}*inrange(newid,17,17) + {b_c18}*inrange(newid,18,18) + {b_c19}*inrange(newid,19,19) + {b_c20}*inrange(newid,20,20) + {b_c21}*inrange(newid,21,21) + {b_c22}*inrange(newid,22,22) + {b_c23}*inrange(newid,23,23) + {b_c24}*inrange(newid,24,24) + ///
	 {b_c25}*inrange(newid,25,25)

	* Generate time-series relevant variables
	egen id = group(country)
	xtset id year
	sort id year

	* Generate lagged variables and variables in first differences
	gen d1ln_eg = D.ln_eg
	gen l1EC_c_alt = L.EC_c_alt
	gen l1EC_d_alt = L.EC_d_alt
	gen l1FU_d = L.FU_d

	xtset id
 
}


***
* Column 1: Nonlinear Estimation of CES in Levels - Electricity Sector - Alternative Capital Proxy
*** 

macro drop _*

* Estimation
#delimit ;
nl ( ln_eg = {a} + {d}*year +
${COUNTRY}    
+(1/{psi}*ln({omega}*EC_c_alt^({psi})+(1-{omega})*EC_d_alt^({psi}))) ) , 
initial( a 20 d 0.01 psi -0.5 omega 0.5) vce(cluster country) iterate(100);
#delimit cr
est store e_ces

local a = _b[/a]
local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]

* Bootstrapping
#delimit ;
nl ( ln_eg = {a} + {d}*year +
${COUNTRY2}    
+(1/{psi}*ln({omega}*EC_c_alt^({psi})+(1-{omega})*EC_d_alt^({psi}))) ) , 
initial(a `a' d `d' psi `psi' omega `omega') vce(bootstrap, cluster(country) idcluster(newid) reps(400) reject(_b[/psi] > 1 | _se[/psi] == 0)  seed(123)) iterate(100);
#delimit cr
est store e_ces

* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1





***
* Column 2: Nonlinear Estimation of CES in First Differences - Electricity Sector - Alternative Capital Proxy
*** 

macro drop _*

* Estimation
#delimit ;
nl ( d1ln_eg = {d}
+(1/({psi})*ln( ( {omega}*EC_c_alt^({psi})+(1-{omega})*EC_d_alt^({psi})) / ( {omega}*l1EC_c_alt^({psi})+ (1-{omega})*l1EC_d_alt^({psi})) ) ) ) if year >= 1996, 
initial( d 0.01 psi -0.5 omega 0.5) vce(cluster country);
#delimit cr
est store e_ces

local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]

* Bootstrapping
#delimit ;
nl ( d1ln_eg = {d}
+(1/({psi})*ln( ( {omega}*EC_c_alt^({psi})+(1-{omega})*EC_d_alt^({psi})) / ( {omega}*l1EC_c_alt^({psi})+ (1-{omega})*l1EC_d_alt^({psi})) ) ) ) if year >= 1996, 
initial( d `d' psi `psi' omega `omega') vce(bootstrap, cluster(country) reps(400) reject(_b[/psi] > 1 | _se[/psi] == 0)  seed(123));
#delimit cr
est store e_ces


* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1





***
* Column 3: Linear Estimation of Kmenta Approximation in Levels - Electricity Sector - Alternative Capital Proxy
*** 

macro drop _*

* Generate additional variables 
drop ln_egecd ln_eccd ln_eccd_2
gen ln_ecc_ecd_alt = ln_ecc_alt * ln_ecd_alt
gen ln_egecd_alt = ln_eg - ln_ecd_alt
gen ln_eccd_alt = ln_ecc_alt-ln_ecd_alt
gen ln_eccd_2_alt = 0.5*(ln_ecc_alt-ln_ecd_alt)^2

* OLS
reg ln_egecd_alt c1-c25 year ln_eccd_alt ln_eccd_2_alt, vce(cluster country)

nlcom 	(a: _b[_cons]) ///
		(d: _b[year]) ///
		(omega: _b[ln_eccd_alt]) ///
		(psi: ((_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])-_b[ln_eccd_2_alt]))-1)/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])-_b[ln_eccd_2_alt]))) ///
		
testnl 	(((_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])-_b[ln_eccd_2_alt]))-1)/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])-_b[ln_eccd_2_alt])) = 0)
dis "sigma: " _b[ln_eccd_alt]*(1-_b[ln_eccd_alt])/(_b[ln_eccd_alt]*(1-_b[ln_eccd_alt])-_b[ln_eccd_2_alt])
dis e(r2_a)





***
* Column 4: Linear Estimation of Kmenta Approximation in First Differences - Electricity Sector - Alternative Capital Proxy
*** 

macro drop _*

* Generate additional variables
xtset id year
gen dln_egecd_alt = D.ln_egecd_alt
gen dln_eccd_alt = D.ln_eccd_alt 
gen dln_eccd_2_alt = D.ln_eccd_2_alt
xtset id


* FD-OLS
reg dln_egecd_alt dln_eccd_alt dln_eccd_2_alt, vce(cluster country)

nlcom 	(d: _b[_cons]) ///
		(omega: _b[dln_eccd_alt]) ///
		(psi:  ((_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])/(_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])-_b[dln_eccd_2_alt])) - 1) / (_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])/(_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])-_b[dln_eccd_2_alt])))

testnl  (((_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])/(_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])-_b[dln_eccd_2_alt])) - 1) / (_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])/(_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])-_b[dln_eccd_2_alt])) = 0)
dis "sigma: " _b[dln_eccd_alt]*(1-_b[dln_eccd_alt])/(_b[dln_eccd_alt]*(1-_b[dln_eccd_alt])-_b[dln_eccd_2_alt]) 
dis e(r2_a)








**********************************************************************************
*                                                                                *
*   Table 5 - Nonlinear Estimation of Cobb-Douglas in CES - Electricity Sector   * 	
*                                                                                *
**********************************************************************************

qui{

	clear
	macro drop _*

	* Load data
	use "electricity_sector.dta"

	* Generate dummies
	tab country, gen(c)

	global COUNTRY {b_c1}*c1+{b_c2}*c2+{b_c3}*c3+{b_c4}*c4+{b_c5}*c5+{b_c6}*c6+{b_c7}*c7+{b_c8}*c8+{b_c9}*c9+{b_c10}*c10+{b_c11}*c11+ {b_c12}*c12 + {b_c13}*c13 + {b_c14}*c14 + {b_c15}*c15 + {b_c16}*c16 + {b_c17}*c17 + {b_c18}*c18 + {b_c19}*c19 + {b_c20}*c20 + {b_c21}*c21 + {b_c22}*c22 + {b_c23}*c23 + {b_c24}*c24 + {b_c25}*c25

	global COUNTRY2 {b_c1}*inrange(newid,1,1)+{b_c2}*inrange(newid,2,2)+{b_c3}*inrange(newid,3,3)+{b_c4}*inrange(newid,4,4)+{b_c5}*inrange(newid,5,5)+{b_c6}*inrange(newid,6,6)+{b_c7}*inrange(newid,7,7)+{b_c8}*inrange(newid,8,8)+ ///
	{b_c9}*inrange(newid,9,9)+{b_c10}*inrange(newid,10,10)+{b_c11}*inrange(newid,11,11)+ {b_c12}*inrange(newid,12,12) + {b_c13}*inrange(newid,13,13) + {b_c14}*inrange(newid,14,14) + {b_c15}*inrange(newid,15,15) + {b_c16}*inrange(newid,16,16) + ///
	 {b_c17}*inrange(newid,17,17) + {b_c18}*inrange(newid,18,18) + {b_c19}*inrange(newid,19,19) + {b_c20}*inrange(newid,20,20) + {b_c21}*inrange(newid,21,21) + {b_c22}*inrange(newid,22,22) + {b_c23}*inrange(newid,23,23) + {b_c24}*inrange(newid,24,24) + ///
	 {b_c25}*inrange(newid,25,25)

	* Generate country id
	egen id = group(country)

	xtset id year

	gen d1ln_eg = D.ln_eg
	gen l1EC_c = L.EC_c
	gen l1EC_d = L.EC_d
	gen l1FU_d = L.FU_d

	xtset id

}



***
* Column 1: Nonlinear Estimation of Cobb-Douglas in CES - Electricity Sector - Main Capital Proxy
*** 

macro drop _*

* NLS-Estimation
#delimit ;
capture noisily nl (
ln_eg = {a} + {d} * year +
${COUNTRY}
+ 1 / ({psi}) * ln(
{omega} * (EC_c)^({psi})
+
(1-{omega}) * (EC_d^{alpha}*FU_d^(1-{alpha}))^(({psi})))
),
iterate(100) initial( a 0 d 0.01 omega 0.5 alpha 0.7 psi -0.2) vce(cluster country);
#delimit cr
est store e_ces

local a = _b[/a]
local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]
local alpha = _b[/alpha]

* Bootstrapping
#delimit ;
capture noisily nl (
ln_eg = {a} + {d} * year +
${COUNTRY2}
+ 1 / ({psi}) * ln(
{omega} * (EC_c)^({psi})
+
(1-{omega}) * (EC_d^{alpha}*FU_d^(1-{alpha}))^(({psi})))
),
iterate(100) initial( a `a' d `d' omega `omega' alpha `alpha' psi `psi') vce(bootstrap, cluster(country) reject(_b[/psi] > 1 | _se[/psi] == 0) idcluster(newid) reps(400)  seed(123));
#delimit cr
est store e_ces


* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1




***
* Column 2: Nonlinear Estimation of Cobb-Douglas in CES in FD - Electricity Sector - Main Capital Proxy
*** 

macro drop _*

* FD-NLS-Estimation
#delimit ;
capture noisily nl (
d1ln_eg = {d}  + 1 / ({psi}) * ln(
( {omega} * (EC_c)^({psi})
+
(1-{omega}) * (EC_d^{alpha}*FU_d^(1-{alpha}))^(({psi}))) 
/
( {omega} * (l1EC_c)^({psi})
+
(1-{omega}) * (l1EC_d^{alpha}*l1FU_d^(1-{alpha}))^(({psi}))) )
) if year >= 1996 ,
iterate(100)  initial( d 0.01 omega 0.5 alpha 0.5 psi -0.5) vce(cluster country);
#delimit cr
est store e_ces

local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]
local alpha = _b[/alpha]

* Bootstrapping
#delimit ;
capture noisily nl (
d1ln_eg = {d}  + 1 / ({psi}) * ln(
( {omega} * (EC_c)^({psi})
+
(1-{omega}) * (EC_d^{alpha}*FU_d^(1-{alpha}))^(({psi}))) 
/
( {omega} * (l1EC_c)^({psi})
+
(1-{omega}) * (l1EC_d^{alpha}*l1FU_d^(1-{alpha}))^(({psi}))) )
) if year >= 1996 ,
iterate(100)  initial( d `d' omega `omega' alpha `alpha' psi `psi') vce(bootstrap, cluster(country) reps(400) reject(_b[/psi] > 1 | _se[/psi] == 0) seed(123));
#delimit cr
est store e_ces


* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1




***
* Electricity Sector Data - Alternative Capital Proxy
***

qui{

	macro drop _*

	clear

	* Load data
	use "electricity_sector.dta"
	
	* Define Sample
	reg ln_eg EC_c_alt EC_d_alt EC_total  FU_d 										// generates one sample which can be used for all subsequent estimations
	keep if e(sample)

	* Generate dummies
	tab country if e(sample), gen(c)
	global COUNTRY {b_c1}*c1+{b_c2}*c2+{b_c3}*c3+{b_c4}*c4+{b_c5}*c5+{b_c6}*c6+{b_c7}*c7+{b_c8}*c8+{b_c9}*c9+{b_c10}*c10+{b_c11}*c11+ {b_c12}*c12 + {b_c13}*c13 + {b_c14}*c14 + {b_c15}*c15 + {b_c16}*c16 + {b_c17}*c17 + {b_c18}*c18 + {b_c19}*c19 + {b_c20}*c20 + {b_c21}*c21 + {b_c22}*c22 + {b_c23}*c23 + {b_c24}*c24 + {b_c25}*c25

	global COUNTRY2 {b_c1}*inrange(newid,1,1)+{b_c2}*inrange(newid,2,2)+{b_c3}*inrange(newid,3,3)+{b_c4}*inrange(newid,4,4)+{b_c5}*inrange(newid,5,5)+{b_c6}*inrange(newid,6,6)+{b_c7}*inrange(newid,7,7)+{b_c8}*inrange(newid,8,8)+ ///
	{b_c9}*inrange(newid,9,9)+{b_c10}*inrange(newid,10,10)+{b_c11}*inrange(newid,11,11)+ {b_c12}*inrange(newid,12,12) + {b_c13}*inrange(newid,13,13) + {b_c14}*inrange(newid,14,14) + {b_c15}*inrange(newid,15,15) + {b_c16}*inrange(newid,16,16) + ///
	 {b_c17}*inrange(newid,17,17) + {b_c18}*inrange(newid,18,18) + {b_c19}*inrange(newid,19,19) + {b_c20}*inrange(newid,20,20) + {b_c21}*inrange(newid,21,21) + {b_c22}*inrange(newid,22,22) + {b_c23}*inrange(newid,23,23) + {b_c24}*inrange(newid,24,24) + ///
	 {b_c25}*inrange(newid,25,25)

	* Generate time-series relevant variables
	egen id = group(country)
	xtset id year
	sort id year

	* Generate lagged variables and variables in first differences
	gen d1ln_eg = D.ln_eg
	gen l1EC_c_alt = L.EC_c_alt
	gen l1EC_d_alt = L.EC_d_alt
	gen l1FU_d = L.FU_d

	xtset id

}



***
* Column 3: Nonlinear Estimation of Cobb-Douglas in CES - Electricity Sector - Alternative Capital Proxy
*** 

macro drop _*

* NLS-Estimation
#delimit ;
capture noisily nl (
ln_eg = {a} + {d} * year +
${COUNTRY}
+ 1 / ({psi}) * ln(
{omega} * (EC_c_alt)^({psi})
+
(1-{omega}) * (EC_d_alt^{alpha}*FU_d^(1-{alpha}))^(({psi})))
),
iterate(100) initial( a 0 d 0.01 omega 0.5 alpha 0.7 psi -0.2) vce(cluster country);
#delimit cr

local a = _b[/a]
local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]
local alpha = _b[/alpha]

* Bootstrapping
#delimit ;
capture noisily nl (
ln_eg = {a} + {d} * year +
${COUNTRY2}
+ 1 / ({psi}) * ln(
{omega} * (EC_c_alt)^({psi})
+
(1-{omega}) * (EC_d_alt^{alpha}*FU_d^(1-{alpha}))^(({psi})))
),
iterate(100) initial( a `a' d `d' omega `omega' alpha `alpha' psi `psi') vce(bootstrap, cluster(country) idcluster(newid) reject(_b[/psi] > 1 | _se[/psi] == 0) reps(400) seed(123));
#delimit cr
est store e_ces


* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1




***
* Column 4: Nonlinear Estimation of Cobb-Douglas in CES in FD - Electricity Sector - Alternative Capital Proxy
*** 

macro drop _*

* FD-NLS-Estimation
#delimit ;
capture noisily nl (
d1ln_eg = {d}  + 1 / ({psi}) * ln(
( {omega} * (EC_c_alt)^({psi})
+
(1-{omega}) * (EC_d_alt^{alpha}*FU_d^(1-{alpha}))^(({psi}))) 
/
( {omega} * (l1EC_c_alt)^({psi})
+
(1-{omega}) * (l1EC_d_alt^{alpha}*l1FU_d^(1-{alpha}))^(({psi}))) )
) if year >= 1996 ,
iterate(100)  initial( d 0.01 omega 0.5 alpha 0.5 psi -0.5) vce(cluster country);
#delimit cr
est store e_ces

local d = _b[/d]
local psi = _b[/psi]
local omega = _b[/omega]
local alpha = _b[/alpha]

* Bootstrapping
#delimit ;
capture noisily nl (
d1ln_eg = {d}  + 1 / ({psi}) * ln(
( {omega} * (EC_c_alt)^({psi})
+
(1-{omega}) * (EC_d_alt^{alpha}*FU_d^(1-{alpha}))^(({psi}))) 
/
( {omega} * (l1EC_c_alt)^({psi})
+
(1-{omega}) * (l1EC_d_alt^{alpha}*l1FU_d^(1-{alpha}))^(({psi}))) )
) if year >= 1996 ,
iterate(100)  initial( d `d' omega `omega' alpha `alpha' psi `psi') vce(bootstrap, cluster(country) reps(400) reject(_b[/psi] > 1 | _se[/psi] == 0) seed(123));
#delimit cr
est store e_ces

* Testing both against the psi corresponding to sigma = 1 and sigma = infinity
test _b[/psi] = 0
test _b[/psi] = 1

* Computing sigma
dis 1 / (1-_b[/psi])

* Testing nonlinearly for psi and sigma
testnl _b[/psi] = 0
testnl 1/(1-_b[/psi]) = 1




**************************************************************************************************************
*                                                                                                            *
*   Table 6	- Nonlinear Estimation and Kmenta Approximation of CES in Cobb-Douglas - Non-Energy Industries   * 	
*                                                                                                            *
**************************************************************************************************************

qui{

	clear

	macro drop _*

	* Load data
	use "nonenergy_industries.dta"						

	* Generate country dummies
	tab country , gen(c)
	global CDCES +{b_c1}*c1+{b_c2}*c2+{b_c3}*c3+{b_c4}*c4+{b_c5}*c5+{b_c6}*c6+{b_c7}*c7+{b_c8}*c8+{b_c9}*c9+{b_c10}*c10+{b_c11}*c11+{b_c12}*c12+{b_c13}*c13+{b_c14}*c14+{b_c15}*c15+{b_c16}*c16+{b_c17}*c17+{b_c18}*c18

	* Generate country dummies
	tab industry , gen(i)
	global INDCES +{b_i1}*i1+{b_i2}*i2+{b_i3}*i3+{b_i4}*i4+{b_i5}*i5+{b_i6}*i6+{b_i7}*i7+{b_i8}*i8+{b_i9}*i9+{b_i10}*i10+{b_i11}*i11+{b_i12}*i12+{b_i13}*i13+{b_i14}*i14+{b_i15}*i15+{b_i16}*i16+{b_i17}*i17+{b_i18}*i18+{b_i19}*i19+{b_i20}*i20+{b_i21}*i21+{b_i22}*i22+{b_i23}*i23+ {b_i24}*i24+{b_i25}*i25+{b_i26}*i26+{b_i27}*i27

	egen id=group(country industry)

}



***
* Column 1: Nonlinear Estimation of CES in Cobb-Douglas - Non-Energy Industries - Value Added
***

macro drop _*

* NLS-Estimation
#delimit ;
capture noisily nl ( ln_vaxiie = {a} + {d}*year +(1-{alph}-{gamm})*ln_xl+{alph}*ln_xk
${CDCES}
${INDCES}
+{gamm}*(1/{psi}*ln(xd^({psi})+xc^({psi}) )) ) , vce(cluster id) iterate(100)
initial( a 0 d 0.01 alph 0.3 gamm 0.1 psi 0.2 );
#delimit cr

local a = _b[/a]
local d = _b[/d]
local psi = _b[/psi]
local alph = _b[/alph]
local gamm = _b[/gamm]

* Bootstrapping
#delimit ;
capture noisily nl ( ln_vaxiie = {a} + {d}*year +(1-{alph}-{gamm})*ln_xl+{alph}*ln_xk
${CDCES}
${INDCES}
+{gamm}*(1/{psi}*ln(xd^({psi})+xc^({psi}) )) ) , vce(bootstrap, cluster(country industry) reps(400) reject(_b[/psi] >1 | _se[/psi] == 0)  seed(123)) iterate(100)
initial( a `a' d `d' alph `alph' gamm `gamm' psi `psi' );
#delimit cr
est store ces

test _b[/psi] = 0
dis "sigma: " 1/(1-_b[/psi]) 




***
* Column 2: Nonlinear Estimation of CES in Cobb-Douglas - Non-Energy Industries - Gross Output
***

macro drop _*

* NLS-Estimation
#delimit ;
capture noisily nl ( ln_go = {a} + {d}*year +(1-{alph}-{gamm}-{theta})*ln_xl+{alph}*ln_xk+{theta}*ln_xiims
${CDCES}
${INDCES}
+{gamm}*(1/({psi})*ln(xd^({psi})+xc^({psi}) )) ), vce(cluster id) iterate(100)
initial( a 0 d 0.01 alph 0.3 gamm 0.1 theta 0.1 psi -0.2 );
#delimit cr

local a = _b[/a]
local d = _b[/d]
local psi = _b[/psi]
local alph = _b[/alph]
local gamm = _b[/gamm]
local theta = _b[/theta]

* Bootstrapping
#delimit ;
capture noisily nl ( ln_go = {a} + {d}*year +(1-{alph}-{gamm}-{theta})*ln_xl+{alph}*ln_xk+{theta}*ln_xiims
${CDCES}
${INDCES}
+{gamm}*(1/({psi})*ln(xd^({psi})+xc^({psi}) )) ), vce(bootstrap, cluster(country industry) reject(_b[/psi] >1 | _se[/psi] == 0) reps(400)  seed(123)) iterate(100)
initial( a `a' d `d' alph `alph' gamm `gamm' theta `theta' psi `psi' );
#delimit cr
est store ces

test _b[/psi] = 0
dis "sigma: " 1/(1-_b[/psi])




***
* Column 3: Kmenta Approximation of CES in Cobb-Douglas - Non-Energy Industries - Value Added
***

macro drop _*

* Estimation
cons def 2 ln_xcl=ln_xdl
cnsreg ln_vaxiiel c1-c18 i1-i27 year ln_xkl ln_xdl ln_xcl ln_xdc_2, cons(2) vce(cluster id)

* Store estimates
cap drop ln_vaxiiel_trans
predict ln_vaxiiel_trans
cap matrix drop _all
cap scalar drop _all
matrix b=e(b)

nlcom 	(a: _b[_cons]) ///
		(d: _b[year]) ///
		(alpha: _b[ln_xkl]) ///
		(gamma: _b[ln_xdl]/0.5) ///
		(sigma: 1/(1-_b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25))) ///
		(psi: _b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25))

testnl 	(1-(1-_b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25)) = 0)	
testnl (1/(1-_b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25)) =1)

/*
* alternative way of obtaining these results
#delimit ;
capture noisily nl ( ln_vaxiiel = {a} ${CDCES} ${INDCES} + {d}*year + {alpha}*ln_xkl + {gamma}*ln_xdl + {gamma}*ln_xcl + {jota}*ln_xdc_2), vce(cluster id) iterate(100);
#delimit cr
*/


		
***
* Column 4: Kmenta Approximation of CES in Cobb-Douglas - Non-Energy Industries - Gross Output
***

macro drop _*

* Estimation
cons def 2 ln_xcl=ln_xdl
cnsreg ln_gol c1-c18 i1-i27 year ln_xkl ln_xdl ln_xcl ln_xdc_2 ln_xiimsl, cons(2) vce(cluster id)

* Store estimates
cap drop ln_gol_trans
predict ln_gol_trans
cap matrix drop _all
cap scalar drop _all
matrix b=e(b)

nlcom 	(a: _b[_cons]) ///
		(d: _b[year]) ///
		(alpha: _b[ln_xkl]) ///
		(gamma: _b[ln_xdl]/0.5) ///
		(theta: _b[ln_xiimsl]) ///
		(sigma: 1/(1-_b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25))) ///
		(psi: _b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25))

testnl 	(1-(1-_b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25)) = 0)	
testnl (1/(1-_b[ln_xdc_2]/(_b[ln_xdl]/0.5*0.25)) =1)

/*
* alternative way of obtaining these results
#delimit ;
capture noisily nl ( ln_gol = {a} ${CDCES} ${INDCES} + {d}*year + {alpha}*ln_xkl + {gamma}*ln_xdl + {gamma}*ln_xcl + {jota}*ln_xdc_2 + {theta}*ln_xiimsl), vce(cluster id) iterate(100);
#delimit cr 
*/



log close

clear
