/*

 Vancouver, Oct 2015.

 This Stata .do file accompanies "Estimation in the Fixed Effects Ordered Logit Model".
	by Chris Muris.

 This file reproduces the results for the misspecification analysis in Table 6
 in Appendix B.

 For any questions about this code, please email me
 at cmuris@sfu.ca.

 If you use this code, please cite the latest version of the paper
 (title above). See my website for more information (www.sfu.ca/~cmuris).

*/

//////////////
// 1. Setup //
//////////////

log using "FEOL-Table6", text


forval design = 1(1)3 {

// Preliminaries
clear all
set more off, permanently

// Set the number of simulations "S" and get an appropriate matrix size.
local S = 1000
set matsize 5100

// These matrices will hold the results. Seven estimators are compared.
matrix b1s = J(`S',8,0)
matrix dds = J(`S',8,0)
matrix rats = J(`S',8,0)

// Set the design parameters.
local N = 5000 // size cross-section dimension
local T = 2   // size time-series dimension
// Total number of observations in a given simulation
local NT = `N' * `T'

// Estimands
local J = 3
local Jminone = `J' - 1
local delta1 = -1
local delta2 = 1
local K = 1
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
			/*    we will deal with imposing equal constr on
			      cut points later
				if (`j1' == 1 & `j2' == 2) {
					matrix H[`rowcount'+`K'+1,`K'+1] = 1
				}
				if (`j1' == 2 & `j2' == 1) {
					matrix H[`rowcount'+`K'+1,`K'+1] = -1
				}

			*/

				matrix H[`rowcount'+`K'+1,`K'+`gamcount'] = 1

				local rowcount = `rowcount' + `K' + 1
				local gamcount = `gamcount' + 1
			}
			local estlistall "`estlistall' est`j1'`j2'"
		}
}

// Necessary ingredients for the CLE
matrix pimat = [1,1\1,2\2,1\2,2]

////////////////////////
// 2. Simulation loop //
////////////////////////

// Set seed
set seed 2014

// Start the simulation.
forval s = 1/`S' {

	drop _all
	qui set obs `NT'

	// Keep track of time.
	di "s is `s'"


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



	local sdlogit = 1.81379936423
	//if(`design' == 5) {
	//		// Logit errors: no misspecification
	//		gen ystar = alpha_i - log(1/uniform() - 1)
	//}

	if(`design' == 3) {
			// Standard normal
			gen ystar = alpha_i - rnormal(0,1)
	}

	if(`design' == 2) {
			// Chi-squared distribution with 3 degress of freedom
			gen ystar = alpha_i - (rchi2(3)-3)
	}

	if(`design' == 1) {
			// Poisson, mean 5
			gen ystar = alpha_i - (rpoisson(2)-2)
	}

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
	matrix rats[`s',1] = b1s[`s',1] / dds[`s',1]

	capture qui ologit y x*
	matrix betas = e(b)
	matrix b1s[`s',2] = betas[1,1]
	matrix dds[`s',2] = betas[1,`K'+2] - betas[1,`K'+1]
	matrix rats[`s',2] = b1s[`s',2] / dds[`s',2]


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
				if(`j1' == `j2') {

				}
				else {
					matrix rats[`s',`counter'] = b1s[`s',`counter'] / dds[`s',`counter']
				}

				local counter = `counter' + 1
			}
		}
	}

	// OMD estimator
	qui suest `estlistall', vce(cluster i)
	mat b_OMD = inv(H'*inv(e(V))*H)*H'*inv(e(V))*e(b)'
	matrix b1s[`s',7]  = b_OMD[1,1]
	matrix dds[`s',7]  = b_OMD[`K'+1,1]
	matrix rats[`s',7] = b1s[`s',7] / dds[`s',7]

	// CLE

		// For the composite likelihood estimator, we can
	//    expand the data set by making one copy per transformation:
	//   - size of the expansion: (J-1)^T
	qui expand 4
	// Re-sort
	qui sort id t
	// Generate the transformation identifier. Select on tid to obtain
	//   different estimators.
	gen tid = mod(_n-1,4) + 1

	//
	// Initialize the cutpoint variable.
	gen cut = 0
	forval picounter = 1/4 {
		forval tcounter = 1/2 {
			qui replace cut = pimat[`picounter',`tcounter']  if tid==`picounter' & t==`tcounter'
		}
	}

	// For all of them, generate the cut variable
	gen ybin = y<=cut
	// And adjust the group identifier.
	gen newid = id*4 + tid


	//
	// Estimator proposed in the paper
	//   Uses all the transformations.
	//

	capture qui clogit ybin x i.cut, group(newid)
	matrix betas = e(b)
	matrix b1s[`s',8] = betas[1,1]
	matrix dds[`s',8] = betas[1,3]
	matrix rats[`s',8] = b1s[`s',8] / dds[`s',8]


	// Drop the estimation results from the last run
	estimates drop *


} // end of forloop for S

/////////////////////////
// 3. Present results  //
/////////////////////////

di "Results [Design `design']:"

//svmat b1s
//svmat dds
svmat rats
//summarize b1s* dds*, separator(8)
summarize rats*


}

log close
