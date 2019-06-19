* hwealth.do FILE

* Compute human capital
* Retirees: current income until death.
* Non-retirees
*	until 64: current income grows as in Cocco, Gomes and Maenhout (2005)
* 	at 65: current income times replacement rate
*	after 65: income is fixed to the last value or to the value at 65

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



* Calibration:

* Real risk free rate
* Average between 1980 and 2004
* = nominal risk free rate over inflation growth
scalar disc = 1.059324/1.0390212

* Retirement age
scalar retage = 65

* Number of observations
scalar nobs = _N

* Income growth
* from Cocco, Gomes, Maenhout (2005)
* age, age2/10, age3/100
mat beta1 = (-2.1361, 0.1684, -0.0353, 0.0023)
scalar repl1 = 0.88983
mat beta2 = (-2.1700, 0.1682, -0.0323, 0.0020)
scalar repl2 = 0.68212
mat beta3 = (-4.3148, 0.3194, -0.0577, 0.0033)
scalar repl3 = 0.938873

* Survival probability until age 100
* 2004 period life tables
* from Human Mortality Database (www.mortality.org/)

mat survm = (0.99253, 0.99949, 0.99967, 0.99975, 0.99979, 0.99982, 0.99982, 0.99984, 0.99985, 0.99984, ///
0.99985, 0.99984, 0.99979, 0.99976, 0.99968, 0.99954, 0.99931, 0.9991, 0.99881, 0.99868, ///
0.99867, 0.99855, 0.99859, 0.99865, 0.99865, 0.99861, 0.99865, 0.99862, 0.99871, 0.99865, ///
0.99873, 0.99861, 0.99853, 0.99852, 0.99847, 0.99829, 0.99823, 0.99807, 0.99796, 0.99781, ///
0.99759, 0.99733, 0.99705, 0.99687, 0.99668, 0.99626, 0.99593, 0.9955, 0.9952, 0.99488, ///
0.99438, 0.99388, 0.99337, 0.99289, 0.99263, 0.99211, 0.99166, 0.99043, 0.99056, 0.98919, ///
0.98823, 0.98682, 0.98605, 0.98467, 0.9835, 0.98216, 0.98061, 0.979, 0.97715, 0.97516, ///
0.97314, 0.9704, 0.96805, 0.96494, 0.96192, 0.95792, 0.95394, 0.94945, 0.9445, 0.94002, ///
0.93376, 0.92781, 0.92031, 0.91343, 0.90329, 0.89866, 0.88582, 0.87639, 0.87061, 0.86579, ///
0.85302, 0.83882, 0.8219, 0.80557, 0.78069, 0.77709, 0.7618, 0.74606, 0.72994, 0.7135, 0)
mat survf = (0.99391, 0.99954, 0.99973, 0.99981, 0.99983, 0.99984, 0.99987, 0.99988, 0.99988, 0.99988, ///
0.99987, 0.99988, 0.99986, 0.99983, 0.99978, 0.99974, 0.99963, 0.99959, 0.99952, 0.99952, ///
0.99954, 0.99952, 0.99953, 0.99954, 0.99951, 0.99952, 0.99946, 0.99945, 0.99945, 0.9994, ///
0.99941, 0.99935, 0.99927, 0.99924, 0.99915, 0.9991, 0.99904, 0.9989, 0.99882, 0.99871, ///
0.99853, 0.99844, 0.99825, 0.99808, 0.99799, 0.99777, 0.99749, 0.99739, 0.99723, 0.997, ///
0.99674, 0.99654, 0.99632, 0.99609, 0.99566, 0.99531, 0.99495, 0.99413, 0.99409, 0.99319, ///
0.99265, 0.99164, 0.99117, 0.99031, 0.98934, 0.98844, 0.98734, 0.9862, 0.98517, 0.98393, ///
0.98209, 0.98046, 0.9782, 0.9768, 0.97419, 0.97204, 0.96898, 0.96584, 0.96244, 0.95883, ///
0.95439, 0.94861, 0.94292, 0.93779, 0.92851, 0.92293, 0.91374, 0.9027, 0.89671, 0.88956, ///
0.87729, 0.86234, 0.84826, 0.82927, 0.81223, 0.80017, 0.78329, 0.76569, 0.74747, 0.72871, 0)




********************************************************************
scalar D = colsof(survm)

mat survmale = J(D,D,0)
mat survfemale = J(D,D,0)
local i = 1
while `i' < D {
	mat survmale[`i',`i'] = survm[1,`i']
	mat survfemale[`i',`i'] = survf[1,`i']
	local j = `i'+1
	while `j' <= D {
		mat survmale[`i',`j'] = survmale[`i',`j'-1]*survm[1,`j']
		mat survfemale[`i',`j'] = survfemale[`i',`j'-1]*survf[1,`j']
		local j = `j'+1
	}
	local i = `i'+1
}

scalar D = D-1

* Current income
gen inco = x5702 + x5704 + x5716 + x5718 + x5720 + x5722 + x5724
gen hc = inco

* Computation for each observation
local i = 1
while `i' <= nobs {

	scalar incnow = inco[`i']
	scalar cohort = x8022[`i']
	* start from current age
	local j = cohort+1
	qui while `j' < D {

		* Non-retiree head, before retirement age: update income
		if x4100[`i'] != 50 & `j' < retage {
			* No high school education
			if x5901[`i'] < 12 {
				scalar growth = beta1[1,2]* (`j'-cohort) + beta1[1,3]*(`j'^2 - cohort^2)/10 + beta1[1,4]*(`j'^3 -cohort^3)/100
			}
			* High school education
			else if x5901[`i'] >= 12 & x5901[`i'] < 16 {
				scalar growth = beta2[1,2]* (`j'-cohort) + beta2[1,3]*(`j'^2 - cohort^2)/10 + beta2[1,4]*(`j'^3 -cohort^3)/100
			}
			* College education
			else if x5901[`i'] >= 16 {
				scalar growth = beta3[1,2]* (`j'-cohort) + beta3[1,3]*(`j'^2 - cohort^2)/10 + beta3[1,4]*(`j'^3 -cohort^3)/100
			}
			scalar incnow = inco[`i'] *(1+growth)
		}
		* Non-retiree head, first retirement age: consider replacement rate
		else if x4100[`i'] != 50 & `j' == retage {
			* No high school education
			if x5901[`i'] < 12 {
				scalar incnow = incnow * repl1
			}
			* High school education
			else if x5901[`i'] >= 12 & x5901[`i'] < 16 {
				scalar incnow = incnow * repl2
			}
			* College education
			else if x5901[`i'] >= 16 {
				scalar incnow = incnow * repl3
			}
		}
		* What is left: retiree head or above fixed retirement age: keep incnow fixed

		replace hc = hc + incnow *survmale[cohort,`j'] /(1+disc)^(`j'-cohort) if x8021 == 1 in `i'
		replace hc = hc + incnow *survfemale[cohort,`j'] /(1+disc)^(`j'-cohort) if x8021 == 2 in `i'
		local j = `j'+1
	}
	local i = `i'+1
}
