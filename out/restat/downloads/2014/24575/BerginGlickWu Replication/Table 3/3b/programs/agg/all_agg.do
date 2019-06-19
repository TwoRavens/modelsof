/* 
   1. The order of the variables in the VECM is e, p_k, p. Please note that my provided
   codes need original series without transformation.
   
   2. According the STATA codes below,I assume that y`i' and x`i'_`k' indicate the nominal 
   exchange rate and the price of good k for country i, respectively. The series of p for 
   country i is the simple average of x`i'_`k' across k and indicates x as the price matrix 
   of p. Therefore, exchange is a TxN matrix of exchange rates, x_`k' is a TxN matrix of p_k
   and x is a TxN matrix of p (T is the number of observations and N is the number of cross section).

   3. output:
      the first row is the ccep_u estimates based on actual data
	  the second row is the mean bias
	  the third row is the bias adjusted coefficients
	  the last row is the standard deviation of bias adjusted coefficients
	 
	  for 3-var system:
	       The first 5 columns are estimates for the 1st equation, the next 5 columns are estimates for the 2nd equation,
		   and the last 5 columns are estimates for the 3rd equation. 
      for 2-var system:
	       The first 3 columns are estimates for the 1st equation, the next 3 columns are estimates for the 2nd equation.
		  
   */

/*	This matrix creation is all handled by pre-estimation file (it's more complicated for unbalanced panels)
	forvalue i=1/`group'{
	   gen d0s_`i'=D.y`i'                            //de(0)(i)                         
	   gen d1s_`i'=L.D.y`i'                          //de(-1)(i)                       
	
	           forvalue k=1/`good'{
	              gen d0p_`i'_`k'=D.x`i'_`k'         //dp(0)(i,k)      
	              gen d1p_`i'_`k'=L.d0p_`i'_`k'      //dp(-1)(i,k)      
	              gen q0_`i'_`k'=y`i'-x`i'_`k'
	              gen q1_`i'_`k'=L.q0_`i'_`k'        //q(-1)(i,k)       
	   
	           }
	}

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

local programpath "P:\BerginGlickWu Replication\Table 3\3b\programs\agg"
local outpath1 "P:\BerginGlickWu Replication\Table 3\results\3b"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

global datasetPWT "semiannual_lc_newPT3_PWT_f1_wide_`descrip'.dta"



/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/
capture program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

local goods = 101												//number of goods
local pairs = 20												//number of pairs
local tsobs = 35												//time observations
local group = 420

**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************



*
************* Seminnual - Traded - PW - Filter 1 ************
*
use U:\Ann\Reuven\Bergin\BGW\Datasets\aggregate_semiannual_lc_drop1_f1_wide_`descrip'.dta, clear

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
/*
local lambda1 -0.6
local lambda2 -0.4
local lambda3 -0.2
local lambda4 0
local lambda5 0.2
local lambda6 0.4
local lambda7 0.6
*/

*forvalues j = 1/7{
*	di in ye "Now running lambda = `lambda`j''"

	* for 2 vars 
	mat data2=exchange,x
	preserve
	ccep_main data2, vars(2) n1(1000) n2(2000) //lambda(`lambda`j'')
	restore

	mat output_1 = e(output)
	mat btstp_beta = e(btstp_beta)

	mat list output_1
*} 
	
** Creating variables to store the results
clear
set obs 1
gen agg = .

gen b_coef_d0s_Q1 = .
gen bias_coef_d0s_Q1 = .
gen adj_b_coef_d0s_Q1 = .
gen adj_se_coef_d0s_Q1 = .
gen adj_t_coef_d0s_Q1 = .
gen adj_05pct_coef_d0s_Q1 = .
gen adj_95pct_coef_d0s_Q1 = .
gen b_coef_d0s_d1s = .
gen bias_coef_d0s_d1s = .
gen adj_b_coef_d0s_d1s = .
gen adj_se_coef_d0s_d1s = .
gen adj_t_coef_d0s_d1s = .
gen adj_05pct_coef_d0s_d1s = .
gen adj_95pct_coef_d0s_d1s = .
gen b_coef_d0s_d1P = .
gen bias_coef_d0s_d1P = .
gen adj_b_coef_d0s_d1P = .
gen adj_se_coef_d0s_d1P = .
gen adj_t_coef_d0s_d1P = .
gen adj_05pct_coef_d0s_d1P = .
gen adj_95pct_coef_d0s_d1P = .
gen spacer1 = ""
gen b_coef_d0P_Q1 = .
gen bias_coef_d0P_Q1 = .
gen adj_b_coef_d0P_Q1 = .
gen adj_se_coef_d0P_Q1 = .
gen adj_t_coef_d0P_Q1 = .
gen adj_05pct_coef_d0P_Q1 = .
gen adj_95pct_coef_d0P_Q1 = .
gen b_coef_d0P_d1s = .
gen bias_coef_d0P_d1s = .
gen adj_b_coef_d0P_d1s = .
gen adj_se_coef_d0P_d1s = .
gen adj_t_coef_d0P_d1s = .
gen adj_05pct_coef_d0P_d1s = .
gen adj_95pct_coef_d0P_d1s = .
gen b_coef_d0P_d1P = .
gen bias_coef_d0P_d1P = .
gen adj_b_coef_d0P_d1P = .
gen adj_se_coef_d0P_d1P = .
gen adj_t_coef_d0P_d1P = .
gen adj_05pct_coef_d0P_d1P = .
gen adj_95pct_coef_d0P_d1P = .

** filling in the results
forvalues j = 1/1{
	replace agg = `j' in `j'
	** only filling in if we ran the estimation

	replace b_coef_d0s_Q1 = output_`j'[1,1] in `j'
	replace bias_coef_d0s_Q1 = output_`j'[2,1] in `j'
	replace adj_b_coef_d0s_Q1 = output_`j'[3,1] in `j'
	replace adj_se_coef_d0s_Q1 = output_`j'[4,1] in `j'
	replace adj_t_coef_d0s_Q1 = output_`j'[3,1]/output_`j'[4,1] in `j'
	replace adj_05pct_coef_d0s_Q1 = output_`j'[5,1] in `j'
	replace adj_95pct_coef_d0s_Q1 = output_`j'[6,1] in `j'
	replace b_coef_d0s_d1s = output_`j'[1,2] in `j'
	replace bias_coef_d0s_d1s = output_`j'[2,2] in `j'
	replace adj_b_coef_d0s_d1s = output_`j'[3,2] in `j'
	replace adj_se_coef_d0s_d1s = output_`j'[4,2] in `j'
	replace adj_t_coef_d0s_d1s = output_`j'[3,2]/output_`j'[4,2] in `j'
	replace adj_05pct_coef_d0s_d1s = output_`j'[5,2] in `j'
	replace adj_95pct_coef_d0s_d1s = output_`j'[6,2] in `j'
	replace b_coef_d0s_d1P = output_`j'[1,3] in `j'
	replace bias_coef_d0s_d1P = output_`j'[2,3] in `j'
	replace adj_b_coef_d0s_d1P = output_`j'[3,3] in `j'
	replace adj_se_coef_d0s_d1P = output_`j'[4,3] in `j'
	replace adj_t_coef_d0s_d1P = output_`j'[3,3]/output_`j'[4,3] in `j'
	replace adj_05pct_coef_d0s_d1P = output_`j'[5,3] in `j'
	replace adj_95pct_coef_d0s_d1P = output_`j'[6,3] in `j'

	replace b_coef_d0P_Q1 = output_`j'[1,4] in `j'
	replace bias_coef_d0P_Q1 = output_`j'[2,4] in `j'
	replace adj_b_coef_d0P_Q1 = output_`j'[3,4] in `j'
	replace adj_se_coef_d0P_Q1 = output_`j'[4,4] in `j'
	replace adj_t_coef_d0P_Q1 = output_`j'[3,4]/output_`j'[4,4] in `j'
	replace adj_05pct_coef_d0P_Q1 = output_`j'[5,4] in `j'
	replace adj_95pct_coef_d0P_Q1 = output_`j'[6,4] in `j'
	replace b_coef_d0P_d1s = output_`j'[1,5] in `j'
	replace bias_coef_d0P_d1s = output_`j'[2,5] in `j'
	replace adj_b_coef_d0P_d1s = output_`j'[3,5] in `j'
	replace adj_se_coef_d0P_d1s = output_`j'[4,5] in `j'
	replace adj_t_coef_d0P_d1s = output_`j'[3,5]/output_`j'[4,5] in `j'
	replace adj_05pct_coef_d0P_d1s = output_`j'[5,5] in `j'
	replace adj_95pct_coef_d0P_d1s = output_`j'[6,5] in `j'
	replace b_coef_d0P_d1P = output_`j'[1,6] in `j'
	replace bias_coef_d0P_d1P = output_`j'[2,6] in `j'
	replace adj_b_coef_d0P_d1P = output_`j'[3,6] in `j'
	replace adj_se_coef_d0P_d1P = output_`j'[4,6] in `j'
	replace adj_t_coef_d0P_d1P = output_`j'[3,6]/output_`j'[4,6] in `j'
	replace adj_05pct_coef_d0P_d1P = output_`j'[5,6] in `j'
	replace adj_95pct_coef_d0P_d1P = output_`j'[6,6] in `j'

}

* outsheeting the data
local filename "ccep_agg_biascorrection_ecm_newPT3_demeanq_semiannual_PW_f1_`descrip'.csv"
outsheet using "`outpath1'/`filename'", comma replace

* outsheeting the bootstrapped bias adjusted betas
clear
set obs 2000
gen sim = _n
svmat btstp_beta
local filename2 "ccep_agg_biascorrected_btstrp_betas_ecm_newPT3_demeanq_semiannual_PW_f1_`descrip'.csv"
outsheet using "`outpath1'/`filename2'", comma replace


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
 
 
 
