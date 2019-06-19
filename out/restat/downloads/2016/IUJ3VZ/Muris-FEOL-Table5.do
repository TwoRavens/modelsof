/*

 Vancouver, Oct 2015.

 This Stata .do file accompanies "Estimation in the Fixed Effects Ordered Logit Model".
	by Chris Muris.

 This file reproduces the results for large T in Table 5 in Appendix B.
 It implements the optimal minimum distance and composite likelihood estimators
   described in the paper, focuses on J=3, K=1, general T.

 For any questions about this code, please email me
 at cmuris@sfu.ca.

 If you use this code, please cite the latest version of the paper
 (title above). See my website for more information (www.sfu.ca/~cmuris).

*/


//////////////
// 1. Setup //
//////////////

// Preliminaries
clear
set more off, permanently

// Set the number of simulations "S" and get an appropriate matrix size.
log using "Muris-FEOL-Table5", text

local S = 100
set matsize 5100

// Set the design parameters.
local N = 350 // size cross-section dimension
forval T = 2(2)8 {  // size time-series dimension
//local T = 2
// Total number of observations in a given simulation
local NT = `N' * `T'

// Estimands
local beta = 1
local J = 3 // code here is written with emphasis on J=3.
local jminone = `J'-1
local jminonet = (`J'-1)^(`T')
//local K = 1
local delta1 = -1
local delta2 = 1

// The following forval loops generates a matrix with all the possible
//    transformations.
matrix pimat = J(`jminonet',`T',0)
forval picounter = 1/`jminonet' {

	local remainder = `picounter' - 1

	forval tcounter = 1/`T' {

		local invt = `T'-`tcounter'
		local divver = `jminone'^`invt'
		local plugthis = floor(`remainder'/`divver')
		matrix pimat[`picounter',`tcounter'] = `plugthis' + 1
		local remainder = `remainder' - `plugthis' * `divver'

	}
}

// The following matrices will be useful for extraction of the
//     results from all the CMLEs.
// What follows is specific to J=3

// For DvS, we need to throw away the dummies that comes with the time-
///    constant transformations.
matrix select1 = [1, 0, 0, 0 \ 0, 0, 1, 0]
matrix H1      = [1 \ 1]

// For the OMD, we need to throw away the dummies for each est.
matrix e2       = [1,0,0]
matrix select_b = [1,0, J(1,(`jminonet'-2)*3+2,0) \ ///
				   J((`jminonet'-2),2,0),I(`jminonet'-2) # [1,0,0], J((`jminonet'-2),2,0) \ ///
				   J(1,(`jminonet'-2)*3+2,0), 1,0 ]
matrix H = J(`jminonet',1,1)

matrix select_d = [J((`jminonet'-2),2,0),I(`jminonet'-2) # [0,0,1], J((`jminonet'-2),2,0)]
matrix Hd = J(`jminonet'-2,1,1)


// These matrices will hold the results.
local numest = `jminone'^`T' + 5 // CMLEs + Oracle, 2xcompositeLikelihood
matrix b1s = J(`S',`numest',0)
matrix dds = J(`S',`numest',0)

////////////////////////
// 2. Simulation loop //
////////////////////////

// Set seed
set seed 2014

// Start the simulation.
forval s = 1/`S' {

	drop _all
	// In this loop, the "expand" command changes
	//   the sample size. It needs to be reset.
	qui set obs `NT'

	// Keep track of time.
	di "Simulations `s' for `T' time periods. Stamp. `c(current_time)' `c(current_date)'"

	//
	// DATA GENERATION: see DGP in paper.
	//

	// Generate the panel data identifiers
	gen id = int((_n-1)/`T') +1
	gen t = mod(_n-1,`T') + 1

	// Generate the RHS
	gen x = invnorm(uniform())
	qui replace x = x-1 if t==1
	qui replace x = x+1 if t==2

	// Generate the fixed effects to depend on the x's
	qui reshape wide x, i(id) j(t)
	gen alpha_i = 0.5*(x1+x2)

	// Generate the latent variable and the outcome
	qui reshape long
	gen ystar = alpha_i + `beta'*x - log(1/uniform() - 1)
	gen y = 1
	qui replace y = (y+1) if (ystar > `delta1')
	qui replace y = (y+1) if (ystar > `delta2')
	drop ystar

	//
	//  ESTIMATION
	//

	// First estimator: Oracle
	capture qui ologit y x alpha_i
	matrix betas = e(b)
	matrix b1s[`s',1] = betas[1,1]
	matrix dds[`s',1] = betas[1,4] - betas[1,3]

	// now, code this into cut point regressions.
	forval picounter = 1/`jminonet' {

		//di "Simulation number `s', Transformation `picounter' out of `jminonet'"
		// Initialize the cutpoint variable, and the transformed variable
		gen cut`picounter' = 0
		gen ybin`picounter' = 0


		forval tcounter = 1/`T' {
			//qui replace cut = pimat[`picounter',`tcounter']  if tid==`picounter' & t==`tcounter'
			qui replace cut`picounter' = pimat[`picounter',`tcounter']  if t==`tcounter'
		}

		qui replace ybin`picounter' = y<=cut`picounter'

		//capture qui clogit ybin x i.cut if tid==`picounter', group(newid)
		//capture qui clogit ybin x i.cut, group(id)
		qui clogit ybin`picounter' x i.cut`picounter', group(id)
		est sto est`picounter'


		matrix betas = e(b)
		matrix b1s[`s',`picounter'+1] = betas[1,1]
		if `picounter' ==1 | `picounter' == `jminonet' {
			matrix dds[`s',`picounter'+1] = 0
		}
		else {
			matrix dds[`s',`picounter'+1] = betas[1,3]
		}


	}

	//
	// Minimum distance
	//
	// 1. DvS
	// First, grab the estimators, extract the coefficient estimates
	qui suest est1 est`jminonet', vce(cluster i)
	//qui suest est1 est8, vce(cluster i)
	matrix b1 =  select1 * e(b)'
	matrix V1 =  select1 * e(V) * select1'
	mat b_OMD1 = inv(H1'*inv(V1)*H1)*H1'*inv(V1)*b1
	matrix b1s[`s',`jminonet'+3] = b_OMD1[1,1]

	// 2. Optimal MD
	qui suest est*, vce(cluster i)
	matrix b2 =  select_b * e(b)'
	matrix V2 =  select_b * e(V) * select_b'
	mat b_OMD2 = inv(H'*inv(V2)*H)*H'*inv(V2)*b2
	matrix b1s[`s',`jminonet'+5] = b_OMD2[1,1]

	matrix d2 = select_d * e(b)'
	matrix Vd2 = select_d * e(V) * select_d'
	mat d_OMD2 = inv(Hd'*inv(Vd2)*Hd)*Hd'*inv(Vd2)*d2
	matrix dds[`s',`jminonet'+5] = d_OMD2[1,1]

	//////////////////////////
	// COMPOSITE LIKELIHOOD //
	//////////////////////////

	// For the composite likelihood estimator, we can
	//    expand the data set by making one copy per transformation:
	//   - size of the expansion: (J-1)^T
	qui expand `jminonet'
	// Re-sort
	qui sort id t
	// Generate the transformation identifier. Select on tid to obtain
	//   different estimators.
	gen tid = mod(_n-1,`jminonet') + 1

	//
	// Initialize the cutpoint variable.
	gen cut = 0
	forval picounter = 1/`jminonet' {
		forval tcounter = 1/`T' {
			qui replace cut = pimat[`picounter',`tcounter']  if tid==`picounter' & t==`tcounter'
		}
	}

	// For all of them, generate the cut variable
	gen ybin = y<=cut
	// And adjust the group identifier.
	gen newid = id*`jminonet' + tid


	//
	// BUC estimator, from Baetschmann et al.
	// 	Uses only the ones with constant cutoffs, in this case tid <= 2
	//
	capture qui clogit ybin x if tid==1 | tid==`jminonet', group(newid) //specific to J=3
	est store DvS
	matrix betas = e(b)
	matrix b1s[`s',`jminonet'+2] = betas[1,1]
	matrix dds[`s',`jminonet'+2] = 0

	//
	// Estimator proposed in the paper
	//   Uses all the transformations.
	//
	capture qui clogit ybin x i.cut, group(newid)
	est store allCMLE
	matrix betas = e(b)
	matrix b1s[`s',`jminonet'+4] = betas[1,1]
	matrix dds[`s',`jminonet'+4] = betas[1,3]

	// Drop the estimation results from the last run
	estimates drop *

} // end of forloop for S



/////////////////////////
// 3. Present results  //
/////////////////////////

svmat b1s
summarize b1s*

svmat dds
summarize dds*


}

log close
