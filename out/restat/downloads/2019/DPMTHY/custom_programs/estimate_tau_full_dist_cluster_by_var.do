capture program drop estimate_tau_cluster_by_var
capture program drop estimate_tau_collapsed
mata: mata clear


program define estimate_tau_cluster_by_var, eclass
	syntax, max_epdf_size(integer) bandwidth(real) n_b(integer) cluster(str) [dummies(str) SUBsample(str) max_size_for_naive(str) max_size(str) subsample_title(str) save_output(str)]
	* Requires the variables freq and total_workers for collapsing
	*
	* max_epdf_size: 		the largest enterprise size on which we want to use the empirical PDF instead of the kernel density estimates
	* bandwidth:			the bandwidth used in estimating the kernel density on the transformed data (using the Markovitch and Krieger transformation)
	* n_b:					number of bootstrap replications used in computing standard errors (use 0 to estimate without standard errors)
	* dummies: 				numbers of total_workers other than 1 for which we want to create dummies (perfect fits)
	* subsample: 			the subsample on which we want to estimate the model
	* max_size_for_naive:	the maximum firm size for the naive estimator
	* max_size:				the maximum firm size on which the model is fitted (after smoothing)
	* subsample_title:		the name of the subsample to add to the generated graph
	* save_output:			a filepath to save the fits to
	
	tempfile original
	save "`original'"
	
	* argument defaults
	local dummies = "1 `dummies'"
	if "`subsample'"=="" local subsample 1
	if "`max_size_for_naive'"=="" local max_size_for_naive "1000000"
	

	qui keep if `subsample'
	
	
	tempfile sub
	save "`sub'"
	
	qui tab `cluster'
	local n_clusters = r(r)
	
	collapse (sum) freq=freq, by(total_workers)
	
	*save point_pre_collapse.dta, replace
	
	estimate_tau_collapsed freq, max_epdf_size(`max_epdf_size') max_size(`max_size') bandwidth(`bandwidth') graph(1) dummies(`dummies') max_size_for_naive(`max_size_for_naive') title(`subsample_title') save_output(`save_output')
	
	*save point_post_collapse.dta, replace

	local point_alpha = e(alpha)
	local point_beta = e(beta)
	local point_delta = e(delta)
	local point_theta = e(theta)
	local point_tau = e(tau)
	local point_naive_tau = e(naive_tau)


	local se_alpha = .
	local se_beta = .
	local se_delta = .
	local se_theta = .
	local se_tau = .
	local se_naive_tau = .
	

	if `n_b' > 0 & `n_clusters' > 1 {
		
		mat b_params = J(`n_b', 6, .)


		forvalues b=1/`n_b' {
	
			use "`sub'", clear
			
			bsample, cluster(`cluster')
			
			collapse (sum) freq=freq, by(total_workers)
	
			capture estimate_tau_collapsed freq, max_epdf_size(`max_epdf_size') max_size(`max_size') bandwidth(`bandwidth') graph(0) dummies(`dummies') max_size_for_naive(`max_size_for_naive')
			
			if _rc == 0 {
				mat b_params[`b', 1] = e(alpha)
				mat b_params[`b', 2] = e(beta)
				mat b_params[`b', 3] = e(delta)
				mat b_params[`b', 4] = e(theta)
				mat b_params[`b', 5] = e(tau)
				mat b_params[`b', 6] = e(naive_tau)
			}
			else {
				continue
			}
			
			*save "`b'_post_collapse.dta", replace
			
		}

		mata: st_matrix("ses", diagonal(sqrt(variance(st_matrix("b_params")))))

		local se_alpha = ses[1, 1]
		local se_beta = ses[2, 1]
		local se_delta = ses[3, 1]
		local se_theta = ses[4, 1]
		local se_tau = ses[5, 1]
		local se_naive_tau = ses[6, 1]
	}

	
	di "tau: `point_tau'"
	di "tau SE: `se_tau'"

	ereturn scalar alpha = `point_alpha'
	ereturn scalar beta = `point_beta'
	ereturn scalar delta = `point_delta'
	ereturn scalar theta = `point_theta'
	ereturn scalar tau = `point_tau'
	ereturn scalar naive_tau = `point_naive_tau'

	ereturn scalar alpha_se = `se_alpha'
	ereturn scalar beta_se = `se_beta'
	ereturn scalar delta_se = `se_delta'
	ereturn scalar theta_se = `se_theta'
	ereturn scalar tau_se = `se_tau'
	ereturn scalar naive_tau_se = `se_naive_tau'
	
	di "alpha: `point_alpha'"
	di "alpha SE: `se_alpha'"
	
	di "beta: `point_beta'"
	di "beta SE: `se_beta'"
	
	di "delta: `point_delta'"
	di "delta SE: `se_delta'"
	
	di "theta: `point_theta'"
	di "theta SE: `se_theta'"
	
	use "`original'", clear
	
end



program define estimate_tau_collapsed, eclass
	syntax varname, max_epdf_size(integer) bandwidth(real) graph(integer) max_size_for_naive(str) [max_size(str) dummies(str) title(str) save_output(str)]
	* Estimates tau on collapsed data, should not be called externally
	*
	* varname:		the name of the variable containing the frequencies
	
	if "`max_size'"!="" local max_size " if total_workers <= `max_size' "

	
	* make sure the data are collapsed
	collapse (sum) freq=freq, by(total_workers)

	egen total = total(freq)
	gen p = freq/total
		
	* T(workers), T'(workers)
	gen t_workers = 2/_pi * atan(total_workers)
	gen t_prime_workers = 2/(_pi*(1 + total_workers^2))
	
	
	* apparently can't be longer than 246 characters in Stata12 ...
	local dummy_var_names = ""
	
	foreach dummy in `dummies' {
		local dummy_var_name = "n_worker_`dummy'"
		gen `dummy_var_name' = total_workers == `dummy'
		local dummy_var_names = "`dummy_var_names' `dummy_var_name'"
	}
	
	gen log_workers = log(total_workers)
	gen log_p = log(p)
	gen gte_10 = total_workers >= 10

	
	
	* Compute Markovitch and Krieger kernel density estimate	
	
	qui mata: gen_kdens("`varlist'", `bandwidth')
	
	
	* with small bandwidth, the kernel density estimate is blown up for small sizes,
	* set some of these to the EPDF
	qui replace kdens = p if total_workers <= `max_epdf_size'
	
	
	gen log_kdens = log(kdens)
	

	* naive estimator
	* -----------------------
	reg log_p log_workers gte_10 `dummy_var_names' if total_workers <= `max_size_for_naive'

	* naive theta and tau
	matrix coeffs = e(b)
	
	matrix alpha_mat = coeffs[1, "_cons"]
	local alpha = alpha_mat[1,1]
	
	matrix beta_mat = -coeffs[1, "log_workers"]
	local beta = beta_mat[1,1]
	
	matrix delta_mat = coeffs[1, "gte_10"]
	local delta = delta_mat[1,1]
	
	local theta = 1/(1 + exp((`alpha' - log(`beta' - 1))/(1 - `beta')))
	
	local naive_tau = exp(`delta' * (`theta' - 1) / (`beta' - 1) ) - 1
	
	
	* main results
	* ---------------------
	
	if `graph' {
		reg log_kdens log_workers gte_10 `dummy_var_names' `max_size'
	}
	else {
		qui reg log_kdens log_workers gte_10 `dummy_var_names' `max_size'

	}
	

	* =====================================================
	* produce a plot of the model-implied distribution
	* =====================================================
	
	if `graph' {
		
		predict pred_log_p, xb
		gen pred_p = exp(pred_log_p)
		replace pred_p = . if total_workers >= 10 & total_workers <= `max_epdf_size'
		
		local xlabels = "1 2 3 4 5 6 7 8 9 "
		forval x = 1(1)4{
		  local y = 10^`x'
		  local xlabels =  "`xlabels'`y' "
		}

		local ylabels = ".5 .1 .01 .001 .00001 .00000001"
		
		graph twoway (scatter p total_workers, msize(vtiny) mcolor(black)) ///
						(scatter kdens total_workers, mcolor(gs5) msize(small) mlwidth(vvthin) msymbol(Oh)) ///
						(line pred_p total_workers, lstyle(solid)),  /// 
						xtitle("Total number of workers") xscale(log) xlabel(`xlabels', labsize(tiny)) ///
						ytitle("Fraction of enterprises")  yscale(log)  ylabel(`ylabels', labsize(tiny)) ///
						legend( order( 1 "Data" 2 "Smoothed data" 3 "Model fit") ) ///
						scheme(s2mono) title(`title')

	
	}
	if "`save_output'" != "" {
		saveold "`save_output'", replace version(12)
	}
	

	* ======================================================
	* compute theta and tau
	* ======================================================
	
	matrix coeffs = e(b)
	
	matrix alpha_mat = coeffs[1, "_cons"]
	local alpha = alpha_mat[1,1]
	
	matrix beta_mat = -coeffs[1, "log_workers"]
	local beta = beta_mat[1,1]
	
	matrix delta_mat = coeffs[1, "gte_10"]
	local delta = delta_mat[1,1]
	
	local theta = 1/(1 + exp((`alpha' - log(`beta' - 1))/(1 - `beta')))
	
	local tau = exp(`delta' * (`theta' - 1) / (`beta' - 1) ) - 1
	
	* ======================================================
	* return values
	* ======================================================
	
	ereturn scalar naive_tau = `naive_tau'
	ereturn scalar alpha = `alpha'
	ereturn scalar beta = `beta'
	ereturn scalar delta = `delta'
	ereturn scalar theta = `theta'
	ereturn scalar tau = `tau'
end

* mata functions
mata:	
	void gen_kdens(string scalar varname, real scalar band) {
		band_recip = 1/band
			
		t = st_data(., ("t_workers"))
		unique_sizes = rows(t)
		
		eval = t # J(1, unique_sizes, 1)
		data = t' # J(unique_sizes, 1, 1)
		
		eval_minus_data = eval :- data
		
		k = epanechnikov(eval_minus_data*band_recip)
		
		f = st_data(., (varname))
		
		kdens_t = band_recip/sum(f) * k * f
		
		kdens = kdens_t :* st_data(., ("t_prime_workers"))
		
		st_addvar("double", "kdens")
		st_store(., "kdens", kdens)
	}
	
	matrix function epanechnikov(matrix x) {
		xrows = rows(x)
		xcols = cols(x)
		abs_lt_1 = abs(x) :< J(xrows, xcols, 1)
		return( abs_lt_1 :* ( J(xrows, xcols, 1) - x:^2) * 3/4 )
	}
end



