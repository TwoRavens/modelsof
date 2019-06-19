/*

 Vancouver, Oct 2015.

 This Stata .do file accompanies "Estimation in the Fixed Effects Ordered Logit Model".
	by Chris Muris.

 This file reproduces the results in Tables 3 and 4 in Appendix B1.
 It implements the optimal minimum distance produce in the paper, for an arbitrary
   number of regressors, and arbitary number of categories, for T=2 time periods.

 For any questions about this code, please email me
 at cmuris@sfu.ca.

 If you use this code, please cite the latest version of the paper
 (title above). See my website for more information (www.sfu.ca/~cmuris).

*/

//////////////
// 1. Setup //
//////////////

log using "Muris-FEOL-Table3-4", text

// Preliminaries
clear all
set more off, permanently

// Set the number of simulations "S" and get an appropriate matrix size.
local S = 1000
set matsize 5100

// These matrices will hold the results. Seven estimators are compared.
matrix b1s = J(`S',8,0)
matrix dds = J(`S',8,0)

// Set the design parameters.
local N = 5000 // size cross-section dimension
local T = 2   // size time-series dimension
// Total number of observations in a given simulation
local NT = `N' * `T'

// Estimands
forval J = 3(1)5 {
local Jminone = `J' - 1
local delta1 = -1
local delta2 = 1
forval j = 3/`Jminone' {
	local jminone = `j'-1
	local delta`j' = `delta`jminone'' + 1
}
forval K = 1(2)5 {
local beta = 1 /`K' // keep total effect of X on ystar unchanged

//////////////////////////////////////////////////////
// 1a. Necessary ingredients for optimal averaging ///
//////////////////////////////////////////////////////

// Need to generate some macros and matrices that will be used below

// The following two macros will hold the list of estimation
//   procedures.
local estlistconstant ""
local estlistall ""

// Optimal weight matrix for OMD, time-invariant
mat e1K = I(`K')
mat H1 = J(`Jminone',1,1) # e1K

// Optimal weight matrix for OMD, all
local numgam = (`Jminone')^`T' - `Jminone'
local dimH  = ((`Jminone')^`T')*`K' + `numgam'
matrix H = J(`dimH',`K'+`numgam',0)
local rowcount = 0
local gamcount = 1
forval j1 = 1/`Jminone' {
		forval j2 = 1/`Jminone' {

			if (`j1'==`j2') {
				local estlistconstant "`estlistconstant' est`j1'`j2'"
				forval k = 1/`K' {
					matrix H[`rowcount'+`k',`k'] = 1
				}
				local rowcount = `rowcount' + `K'
			}
			else {
				forval k = 1/`K' {
					matrix H[`rowcount'+`k',`k'] = 1
				}

				matrix H[`rowcount'+`K'+1,`K'+`gamcount'] = 1

				local rowcount = `rowcount' + `K' + 1
				local gamcount = `gamcount' + 1
			}
			local estlistall "`estlistall' est`j1'`j2'"
		}
}

////////////////////////
// 2. Simulation loop //
////////////////////////

// Set seed
set seed 2014

// Start the simulation.
di "Start [Simulation design parameters: (`N',`J',`K',`S')]:"
forval s = 1/`S' {

	drop _all
	qui set obs `NT'

	// Keep track of time.
	if(`s' == 5) {
		di "s is `s'"
	}
	if(`s' == 100) {
		di "s is `s'"
	}
	if(`s' == 250) {
		di "s is `s'"
	}
	if(`s' == 500) {
		di "s is `s'"
	}
	if(`s' == 750) {
		di "s is `s'"
	}
	if(`s' == 1000) {
		di "s is `s'"
	}

	//
	// DATA GENERATION: see DGP in paper.
	//

	// Generate the panel data identifiers
	gen id = int((_n-1)/`T') +1
	gen t = mod(_n-1,`T') + 1

	// Generate the RHS
	forval k = 1/`K' {
		gen x`k' = invnorm(uniform())
		qui replace x`k' = x`k'-1 if t==1
		qui replace x`k' = x`k'+1 if t==2
	}

	// Generate the fixed effects to depend on the x's
	qui reshape wide x*, i(id) j(t)
	gen barx = 1/`T' * (x11+x12)
	gen alpha_i = barx //+ 1/`T' * ((x1 - xbar)^2 + (x2 - xbar)^2 )

	// Generate the latent variable and the outcome
	qui reshape long
	gen ystar = alpha_i - log(1/uniform() - 1)
	forval k = 1/`K' {
		qui replace ystar = ystar + `beta' * x`k'
	}
	gen y = 1

	forval j = 1/`Jminone' {
		qui replace y = (y+1) if (ystar > `delta`j'')
	}

	drop ystar

	//
	//  ESTIMATION
	//

	// First estimator: Oracle
	capture qui ologit y x* alpha_i
	matrix betas = e(b)
	matrix b1s[`s',1] = betas[1,1]
	matrix dds[`s',1] = betas[1,`K'+3] - betas[1,`K'+2]

	capture qui ologit y x*
	matrix betas = e(b)
	matrix b1s[`s',2] = betas[1,1]
	matrix dds[`s',2] = betas[1,`K'+2] - betas[1,`K'+1]


	//
	// First four estimators use only one transformation
	//

	local counter = 3
	forval j1 = 1/`Jminone' {
		forval j2 = 1/`Jminone' {

			gen d`j1'`j2' = 0
			gen cut`j1'`j2' = 0
			qui replace d`j1'`j2' = 1 if y<=`j1' & t==1
			qui replace d`j1'`j2' = 1 if y<=`j2' & t==2
			qui replace cut`j1'`j2' = 1 if t==2

			if (`j1'==`j2') {
				capture qui clogit d`j1'`j2' x*, group(id)
				//local estlistconstant "`estlistconstant' est`j1'`j2'"
			}
			else {
				capture qui clogit d`j1'`j2' x* cut`j1'`j2', group(id)
			}
			est sto est`j1'`j2'

			if(`j1'<=2 & `j2'<=2) {
				// Log the 11, 12, 21, 22 estimators for comparison.
				matrix betas = e(b)
				matrix b1s[`s',`counter'] = betas[1,1]
				matrix dds[`s',`counter'] = betas[1,`K'+1]
				local counter = `counter' + 1
			}
		}
	}

	// Now do the OMD stuff!

	// Time-invariant
	qui suest `estlistconstant', vce(cluster i)
	mat b_OMD1 = inv(H1'*inv(e(V))*H1)*H1'*inv(e(V))*e(b)'
	matrix b1s[`s',`counter'] = b_OMD1[1,1]

	// All

	local counter = `counter' + 1
	qui suest `estlistall', vce(cluster i)
	mat b_OMD = inv(H'*inv(e(V))*H)*H'*inv(e(V))*e(b)'
	matrix b1s[`s',`counter'] = b_OMD[1,1]
	matrix dds[`s',`counter'] = b_OMD[`K'+1,1]


} // end of forloop for S

/////////////////////////
// 3. Present results  //
/////////////////////////

di "Results [Simulation design parameters: N-J-K-S (`N',`J',`K',`S')]:"

svmat b1s
svmat dds
summarize b1s* dds*, separator(8)

}
}

log close
