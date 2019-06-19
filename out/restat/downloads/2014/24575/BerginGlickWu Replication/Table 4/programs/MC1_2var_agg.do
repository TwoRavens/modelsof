/* 
Monte Carlo for aggregated 2 variable system Part 1:

From Bergin:

1) First: do a MC study specific to our empirical estimates, which is basically the same as the bootstrapping above. 
Use draws of our actual residuals, do the DGP with our estimated parameters as the truth.  Do for both disaggregated 
and aggregated systems, where for the disaggregated data do it for each of our 100 goods and report averages. (all as 
we are currently doing). I don’t see a need to include a common factor. Report: the assumed rhos in the DGP, and the 
mean and confidence band of the estimated rhos.

Steps:

1) Run 2 var system on aggregate data and get estimates and residuals (ccep_2var.ado file)
2) Bootstrap from the residuals (demeaned). (b_res_t1.ado and b_block_t2 files)
3) Using the ACTUAL parameter values obtained from 1) generate a dataset (b_res_t1.ado and b_block_t2 files)
4) Then run Pesaran method to generate biased estimates of the values. Get confidence bands(ccep_2v_alt.ado file)
5) Repeat steps 2-4 1000 times

Output
1) Assumed rhos (Pesaran coefficients returned in Step 1)
2) Mean of 1000 estimated coefficients, along w/ 5 and 95% confidence bands

*/

matrix drop _all
clear
clear results
clear mata
capture log close
set more off
set mem 700m
set varabbrev off

local descrip "indust"

local programpath "P:\BerginGlickWu Replication\Table 4\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 4\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

capture program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

** initializing values

local goods =101												//number of goods
local pairs = 20												//number of pairs
local tsobs = 35												//time observations
local tsobs2 = `tsobs' - 2
local group = 420
local sims = 1000												//num. of simulations for Monte Carlo
local vars = 2													//num. of variables in system
local rr = `vars' - 1											//for creation of coefficient matrix
local bk = 3													// block size
local dropd = 0													// number of iterations to burn in
local nregressor = 3											// number of regressors in each equation
local lag = 2


**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************



*
************* Seminnual - Traded - PW - Filter 1 ************
*
use "`datapath'\aggregate_semiannual_lc_drop1_f1_wide_`descrip'.dta", clear

// Transfer variable to matrix

/* adjusting the exchange rate series
it is currently in the form (LC/USD) so q = p - s
currently it is log(nom price(i))-log(nom price(j)) - (log(lc(i)/USD) - log(lc(j)/USD))
we will flip the exchange rate series by multiplying by negative 1
so that the calculation for q is q = p + s
We also want to check for any series that have missing values
if there is at least on missing value we will drop the variable
*/

 ** creating e, p matrices and running the 2 var equation

 forvalues i = 1/`group' {
		quietly replace s`i' = -s`i'
		rename s`i' s`i'_0
		rename q`i' q`i'_0
		quietly gen rer`i'_0 = q`i'_0 + s`i'_0
	}

capture drop series_title

local counter = 0
** cleaning up the data
forvalues i = 1/`group' {
	quietly count if q`i'_0 != .
	if r(N) != `tsobs' {
		capture quietly drop q`i'_0
		capture quietly drop s`i'_0
		capture quietly drop rer`i'_0
		local counter = `counter' + 1
	}	
	if r(N) == `tsobs' {
		quietly count if s`i'_0 != .
		if r(N) != `tsobs' {
			
			capture quietly drop q`i'_0
			capture quietly drop s`i'_0
			capture quietly drop rer`i'_0
			local counter = `counter' + 1
		}
	}
	if ERprod_PWonecity`i' != 1  & r(N) == `tsobs' {
		capture quietly drop q`i'_0
		capture quietly drop s`i'_0
		capture quietly drop rer`i'_0
		local counter = `counter' + 1
	}
	else{
		local exchange `exchange' s`i'_0
		local x `x' q`i'_0
	}	
}

capture drop ERprod_PWonecity*

** creating matrices here
mkmat `exchange', mat(exchange)
mkmat `x', mat(x)

***************************************************************************************************************
** Step 1: Run 2 var system on aggregate data and get adjusted estimates and residuals (ccep_main_adj.ado file)
***************************************************************************************************************
* cointegrating vector
mat coefi = (1\1)

* running 2 var system
mat data2=exchange,x
local tc=colsof(data2)
ccep_2v data2 coefi, dropdata(`dropd')

* saving the actual parameter values and demeaned residuals for running a bootstrap
mat actual_beta_1 = e(beta)
mat res = e(res)

* creating a demeaned list of residuals
mat tavg2 = J((`tsobs'-`lag'),1,1)/(`tsobs' - `lag')
mat resavg = (res'*tavg2)'

mat resavgmat = J((`tsobs'-2),`tc',.)
forvalues i = 1/`tsobs2'{
	mat resavgmat[`i',1] = resavg
}

mat res_demean = res - resavgmat

* outputting estimates
mat list actual_beta_1

* saving a coef matrix to feed the bootstrap program
mat coef = actual_beta_1[....,1..`rr'],coefi, actual_beta_1[....,(`rr'+1)...]

***************************************************************************************************************
** Step 2 + 3 + 4: Bootstrap residuals and generate a dataset and running it through biased estimator
***************************************************************************************************************

mat betasims_1 = J(`sims',`=`vars'*`nregressor'',.)
mat se_eqn1_sims_1 = J(`sims',`nregressor',.)
mat se_eqn2_sims_1 = J(`sims',`nregressor',.)
mat mod_check_1 = J(`sims', 1,0)

* 1000 simulations
forvalues i = 1/`sims'{

	* bootstrap from residuals and create a dataset
	b_res_t1 res_demean coef data2, dr(`dropd') bs(`bk') sss(`i')
	mat simd = r(bsimd)
	
	* running the 2 var unrestricted CCEP estimator on the generated data
	ccep_2v_alt simd coefi, dr(`dropd')
	
	* saving the simulated betas
	mat betasims = e(beta)
	mat betasims_1[`i',1] = (vec(betasims'))'
	mat se_eqn1_sims_1[`i',1] = (vecdiag(e(cov_eqn1)))
	mat se_eqn2_sims_1[`i',1] = (vecdiag(e(cov_eqn2)))
	
	* doing a modulus calculation
	mat coefl = betasims[1..2,`rr']
	mat coefs = betasims[1..2,`rr'+1...]
	
	mat f=(coefs,coefl) \ (coefi'*coefs,(I(`rr')+coefi'*coefl))

	mat eigenvalues re im = f
	mat norm=hadamard(re,re)'+hadamard(im,im)'
	m_max norm
	mat m0=r(mmax)
	local m0=sqrt(det(m0))
	
	mat mod_check_1[`i',1] = `m0'
	
	
}	

** reporting the mean and 5 and 95 percentile of the beta simulations
mat oo = J(`sims',1,1)/`sims'
mat betasims_m_1 = (betasims_1' * oo)'

* percentiles
clear
svmat betasims_1

mat pctile05_1 = J(1,`=`vars'*`nregressor'',.)
mat pctile95_1 = J(1,`=`vars'*`nregressor'',.)

local i = 1
ds
local varlist `r(varlist)'
foreach var in `varlist'{
	_pctile `var', p(5,95)
	mat pctile05_1[1,`i'] = r(r1)
	mat pctile95_1[1,`i'] = r(r2)
	local i = `i' + 1
}

***************************************************************************************************************
** Output: actual beta, average simulated biased beta, 5th percentile of simulated beta, 95th percentile
***************************************************************************************************************

clear
set obs 1
gen good = "agg"
**gen pair = .

gen adj_b_coef_d0s_Q1 = .
gen MC_b_coef_d0s_Q1 = .
gen MC_05pct_coef_d0s_Q1 = .
gen MC_95pct_coef_d0s_Q1 = .
gen adj_b_coef_d0s_d1s = .
gen MC_b_coef_d0s_d1s = .
gen MC_05pct_coef_d0s_d1s = .
gen MC_95pct_coef_d0s_d1s = .
gen adj_b_coef_d0s_d1P = .
gen MC_b_coef_d0s_d1P = .
gen MC_05pct_coef_d0s_d1P = .
gen MC_95pct_coef_d0s_d1P = .
gen spacer1 = ""
gen adj_b_coef_d0P_Q1 = .
gen MC_b_coef_d0P_Q1 = .
gen MC_05pct_coef_d0P_Q1 = .
gen MC_95pct_coef_d0P_Q1 = .
gen adj_b_coef_d0P_d1s = .
gen MC_b_coef_d0P_d1s = .
gen MC_05pct_coef_d0P_d1s = .
gen MC_95pct_coef_d0P_d1s = .
gen adj_b_coef_d0P_d1P = .
gen MC_b_coef_d0P_d1P = .
gen MC_05pct_coef_d0P_d1P = .
gen MC_95pct_coef_d0P_d1P = .

forvalues i = 1/1{

	replace adj_b_coef_d0s_Q1 = actual_beta_`i'[1,1] in `i'
	replace MC_b_coef_d0s_Q1 = betasims_m_`i'[1,1] in `i'
	replace MC_05pct_coef_d0s_Q1 = pctile05_`i'[1,1] in `i'
	replace MC_95pct_coef_d0s_Q1 = pctile95_`i'[1,1] in `i'
	replace adj_b_coef_d0s_d1s = actual_beta_`i'[1,2] in `i'
	replace MC_b_coef_d0s_d1s = betasims_m_`i'[1,2] in `i'
	replace MC_05pct_coef_d0s_d1s = pctile05_`i'[1,2] in `i'
	replace MC_95pct_coef_d0s_d1s = pctile95_`i'[1,2] in `i'
	replace adj_b_coef_d0s_d1P = actual_beta_`i'[1,3] in `i'
	replace MC_b_coef_d0s_d1P = betasims_m_`i'[1,3] in `i'
	replace MC_05pct_coef_d0s_d1P = pctile05_`i'[1,3] in `i'
	replace MC_95pct_coef_d0s_d1P = pctile95_`i'[1,3] in `i'

	replace adj_b_coef_d0P_Q1 = actual_beta_`i'[2,1] in `i'
	replace MC_b_coef_d0P_Q1 = betasims_m_`i'[1,4] in `i'
	replace MC_05pct_coef_d0P_Q1 = pctile05_`i'[1,4] in `i'
	replace MC_95pct_coef_d0P_Q1 = pctile95_`i'[1,4] in `i'
	replace adj_b_coef_d0P_d1s = actual_beta_`i'[2,2] in `i'
	replace MC_b_coef_d0P_d1s = betasims_m_`i'[1,5] in `i'
	replace MC_05pct_coef_d0P_d1s = pctile05_`i'[1,5] in `i'
	replace MC_95pct_coef_d0P_d1s = pctile95_`i'[1,5] in `i'
	replace adj_b_coef_d0P_d1P = actual_beta_`i'[2,3] in `i'
	replace MC_b_coef_d0P_d1P = betasims_m_`i'[1,6] in `i'
	replace MC_05pct_coef_d0P_d1P = pctile05_`i'[1,6] in `i'
	replace MC_95pct_coef_d0P_d1P = pctile95_`i'[1,6] in `i'

}

** outsheet
local filename "MC_2var_agg_method1.csv"
outsheet using "`outpath1'/`filename'", comma replace


 /*
 * for 2 vars 
 mat data2=exchange,x
 ccep_main data2, vars(2) n1(1000) n2(2000)
 mat list e(output)
 
 * for 1 var
 mat data1=q
 ccep_main_1v data1, n1(1000) n2(2000)
  mat list e(output)
 */
 
 
 
