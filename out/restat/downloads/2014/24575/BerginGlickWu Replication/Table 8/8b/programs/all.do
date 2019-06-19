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


local programpath "P:\BerginGlickWu Replication\Table 8\8b\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 8\results\8b"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"


global datasetPWT "semiannual_lc_newPT3_PWT_f1_wide_indust.dta"



/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/
capture program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

local goods  =101												//number of goods
local pairs = 20												//number of pairs
local tsobs = 35												//time observations
local nirp = 40

**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************



*
************* Seminnual - Traded - PW - Filter 1 ************
*

use "`datapath'/$datasetPWT", clear

// Transfer variable to matrix

/* adjusting the exchange rate series
it is currently in the form (LC/USD) so q = p - s
currently it is log(nom price(i))-log(nom price(j)) - (log(lc(i)/USD) - log(lc(j)/USD))
we will flip the exchange rate series by multiplying by negative 1
so that the calculation for q is q = p + s
We also want to check for any series that have missing values
if there is at least on missing value we will drop the variable
*/
local counter = 0
forvalues j = 1/`goods'{
	local goodcounter`j' = 0
}

forvalues i = 1/`pairs'{
	quietly replace s_`i' = -s_`i'
	forvalues j = 1/`goods'{
		local nonmissing = 0
		clear results
		capture count if p_`i'_`j' != .
		capture local nonmissing = r(N)

		** generating variables if it is necessary
		if `nonmissing' == `tsobs'{
			local dummy_`i'_`j' = 1
			
			quietly gen q_`i'_`j' = p_`i'_`j' + s_`i'
		}
		
		else{
			local dummy_`i'_`j' = 0
			capture drop p_`i'_`j'
			local counter = `counter' + 1
			local goodcounter`j' = `goodcounter`j'' + 1
			
		}
	}
}
 
 ** creating e, p, pk matrices and running the 3 var equation
 forvalues j = 1/`goods'{
	* temp is a counter for the number of pairs for a given good
	local temp = 0
	
	*creating string to create the matrices later
	local exchange
	local x_`j'
	local x
	local q
	
	forvalues i = 1/`pairs'{
		if `dummy_`i'_`j'' == 1{
			di in ye "Creating good `j' and pair `i' matrices"
			
			local temp = `temp' + 1
			
			** creating e, pk, and q matrices
			local exchange `exchange' s_`i'
			local x_`j' `x_`j'' p_`i'_`j'
			local q `q' q_`i'_`j'
			
			** creating p matrix
			egen p_`i'_m = rowmean(p_`i'_*)
			local x `x' p_`i'_m
		}
	}

	assert `temp' == `pairs' - `goodcounter`j''					//checking to make sure that the number of pairs we count is equal to how many we counted above

	local nopairs_`j' = `pairs' - `goodcounter`j''				//number of pairs available for the goods

	* run estimation only if there is more than one pair available for a good
	if `nopairs_`j'' > 1{
		* creating matrices for estimation
		mkmat `exchange', mat(exchange)								//exchange rate matrix for good k
		mkmat `x_`j'', mat(x_`j')									//pk matrix for good k
		mkmat `x', mat(x)											//P matrix for good 
		mkmat `q', mat(q)											//q matrix for good k
		mat data3 = exchange, x_`j', x

		** no longer need the p variables
		drop p_*_m
	
		*for 3 vars
		preserve
		ccep_main_3v data3, vars(3) n1(1000) n2(2000)
		restore
		mat output_`j' = e(output)
		mat halflife_`j' = e(halflife)
		di "good `j'"
		mat list output_`j'
	}
	
}

** Creating variables to store the results
clear
set obs `goods'
gen good = .
gen pairs = .
gen b_coef_d0s_Q1 = .
gen bias_coef_d0s_Q1 = .
gen adj_b_coef_d0s_Q1 = .
gen adj_se_coef_d0s_Q1 = .
gen adj_05pct_coef_d0s_Q1 = .
gen adj_95pct_coef_d0s_Q1 = .
gen adj_t_coef_d0s_Q1 = .
gen b_coef_d0s_qk1 = .
gen bias_coef_d0s_qk1 = .
gen adj_b_coef_d0s_qk1 = .
gen adj_se_coef_d0s_qk1 = .
gen adj_t_coef_d0s_qk1 = .
gen adj_05pct_coef_d0s_qk1 = .
gen adj_95pct_coef_d0s_qk1 = .
gen b_coef_d0s_d1s = .
gen bias_coef_d0s_d1s = .
gen adj_b_coef_d0s_d1s = .
gen adj_se_coef_d0s_d1s = .
gen adj_t_coef_d0s_d1s = .
gen adj_05pct_coef_d0s_d1s = .
gen adj_95pct_coef_d0s_d1s = .
gen b_coef_d0s_d1pk = .
gen bias_coef_d0s_d1pk = .
gen adj_b_coef_d0s_d1pk = .
gen adj_se_coef_d0s_d1pk = .
gen adj_t_coef_d0s_d1pk = .
gen adj_05pct_coef_d0s_d1pk = .
gen adj_95pct_coef_d0s_d1pk = .
gen b_coef_d0s_d1P = .
gen bias_coef_d0s_d1P = .
gen adj_b_coef_d0s_d1P = .
gen adj_se_coef_d0s_d1P = .
gen adj_t_coef_d0s_d1P = .
gen adj_05pct_coef_d0s_d1P = .
gen adj_95pct_coef_d0s_d1P = .
gen spacer1 = ""
gen b_coef_d0pk_Q1 = .
gen bias_coef_d0pk_Q1 = .
gen adj_b_coef_d0pk_Q1 = .
gen adj_se_coef_d0pk_Q1 = .
gen adj_t_coef_d0pk_Q1 = .
gen adj_05pct_coef_d0pk_Q1 = .
gen adj_95pct_coef_d0pk_Q1 = .
gen b_coef_d0pk_qk1 = .
gen bias_coef_d0pk_qk1 = .
gen adj_b_coef_d0pk_qk1 = .
gen adj_se_coef_d0pk_qk1 = .
gen adj_t_coef_d0pk_qk1 = .
gen adj_05pct_coef_d0pk_qk1 = .
gen adj_95pct_coef_d0pk_qk1 = .
gen b_coef_d0pk_d1s = .
gen bias_coef_d0pk_d1s = .
gen adj_b_coef_d0pk_d1s = .
gen adj_se_coef_d0pk_d1s = .
gen adj_t_coef_d0pk_d1s = .
gen adj_05pct_coef_d0pk_d1s = .
gen adj_95pct_coef_d0pk_d1s = .
gen b_coef_d0pk_d1pk = .
gen bias_coef_d0pk_d1pk = .
gen adj_b_coef_d0pk_d1pk = .
gen adj_se_coef_d0pk_d1pk = .
gen adj_t_coef_d0pk_d1pk = .
gen adj_05pct_coef_d0pk_d1pk = .
gen adj_95pct_coef_d0pk_d1pk = .
gen b_coef_d0pk_d1P = .
gen bias_coef_d0pk_d1P = .
gen adj_b_coef_d0pk_d1P = .
gen adj_se_coef_d0pk_d1P = .
gen adj_t_coef_d0pk_d1P = .
gen adj_05pct_coef_d0pk_d1P = .
gen adj_95pct_coef_d0pk_d1P = .
gen spacer2 = ""
gen b_coef_d0P_Q1 = .
gen bias_coef_d0P_Q1 = .
gen adj_b_coef_d0P_Q1 = .
gen adj_se_coef_d0P_Q1 = .
gen adj_t_coef_d0P_Q1 = .
gen adj_05pct_coef_d0P_Q1 = .
gen adj_95pct_coef_d0P_Q1 = .
gen b_coef_d0P_qk1 = .
gen bias_coef_d0P_qk1 = .
gen adj_b_coef_d0P_qk1 = .
gen adj_se_coef_d0P_qk1 = .
gen adj_t_coef_d0P_qk1 = .
gen adj_05pct_coef_d0P_qk1 = .
gen adj_95pct_coef_d0P_qk1 = .
gen b_coef_d0P_d1s = .
gen bias_coef_d0P_d1s = .
gen adj_b_coef_d0P_d1s = .
gen adj_se_coef_d0P_d1s = .
gen adj_t_coef_d0P_d1s = .
gen adj_05pct_coef_d0P_d1s = .
gen adj_95pct_coef_d0P_d1s = .
gen b_coef_d0P_d1pk = .
gen bias_coef_d0P_d1pk = .
gen adj_b_coef_d0P_d1pk = .
gen adj_se_coef_d0P_d1pk = .
gen adj_t_coef_d0P_d1pk = .
gen adj_05pct_coef_d0P_d1pk = .
gen adj_95pct_coef_d0P_d1pk = .
gen b_coef_d0P_d1P = .
gen bias_coef_d0P_d1P = .
gen adj_b_coef_d0P_d1P = .
gen adj_se_coef_d0P_d1P = .
gen adj_t_coef_d0P_d1P = .
gen adj_05pct_coef_d0P_d1P = .
gen adj_95pct_coef_d0P_d1P = .

** filling in the results
forvalues j = 1/`goods'{
	replace good = `j' in `j'
	** only filling in if we ran the estimation
	if `nopairs_`j'' > 1{
		quietly{
			replace pairs = `nopairs_`j'' in `j'
			replace b_coef_d0s_Q1 = output_`j'[1,1] in `j'
			replace bias_coef_d0s_Q1 = output_`j'[2,1] in `j'
			replace adj_b_coef_d0s_Q1 = output_`j'[3,1] in `j'
			replace adj_se_coef_d0s_Q1 = output_`j'[4,1] in `j'
			replace adj_t_coef_d0s_Q1 = output_`j'[3,1]/output_`j'[4,1] in `j'
			replace adj_05pct_coef_d0s_Q1 = output_`j'[5,1] in `j'
			replace adj_95pct_coef_d0s_Q1 = output_`j'[6,1] in `j'
			replace b_coef_d0s_qk1 = output_`j'[1,2] in `j'
			replace bias_coef_d0s_qk1 = output_`j'[2,2] in `j'
			replace adj_b_coef_d0s_qk1 = output_`j'[3,2] in `j'
			replace adj_se_coef_d0s_qk1 = output_`j'[4,2] in `j'
			replace adj_t_coef_d0s_qk1 = output_`j'[3,2]/output_`j'[4,2] in `j'
			replace adj_05pct_coef_d0s_qk1 = output_`j'[5,2] in `j'
			replace adj_95pct_coef_d0s_qk1 = output_`j'[6,2] in `j'
			replace b_coef_d0s_d1s = output_`j'[1,3] in `j'
			replace bias_coef_d0s_d1s = output_`j'[2,3] in `j'
			replace adj_b_coef_d0s_d1s = output_`j'[3,3] in `j'
			replace adj_se_coef_d0s_d1s = output_`j'[4,3] in `j'
			replace adj_t_coef_d0s_d1s = output_`j'[3,3]/output_`j'[4,3] in `j'
			replace adj_05pct_coef_d0s_d1s = output_`j'[5,3] in `j'
			replace adj_95pct_coef_d0s_d1s = output_`j'[6,3] in `j'
			replace b_coef_d0s_d1pk = output_`j'[1,4] in `j'
			replace bias_coef_d0s_d1pk = output_`j'[2,4] in `j'
			replace adj_b_coef_d0s_d1pk = output_`j'[3,4] in `j'
			replace adj_se_coef_d0s_d1pk = output_`j'[4,4] in `j'
			replace adj_t_coef_d0s_d1pk = output_`j'[3,4]/output_`j'[4,4] in `j'
			replace adj_05pct_coef_d0s_d1pk = output_`j'[5,4] in `j'
			replace adj_95pct_coef_d0s_d1pk = output_`j'[6,4] in `j'
			replace b_coef_d0s_d1P = output_`j'[1,5] in `j'
			replace bias_coef_d0s_d1P = output_`j'[2,5] in `j'
			replace adj_b_coef_d0s_d1P = output_`j'[3,5] in `j'
			replace adj_se_coef_d0s_d1P = output_`j'[4,5] in `j'
			replace adj_t_coef_d0s_d1P = output_`j'[3,5]/output_`j'[4,5] in `j'
			replace adj_05pct_coef_d0s_d1P = output_`j'[5,5] in `j'
			replace adj_95pct_coef_d0s_d1P = output_`j'[6,5] in `j'

			replace b_coef_d0pk_Q1 = output_`j'[1,6] in `j'
			replace bias_coef_d0pk_Q1 = output_`j'[2,6] in `j'
			replace adj_b_coef_d0pk_Q1 = output_`j'[3,6] in `j'
			replace adj_se_coef_d0pk_Q1 = output_`j'[4,6] in `j'
			replace adj_t_coef_d0pk_Q1 = output_`j'[3,6]/output_`j'[4,6] in `j'
			replace adj_05pct_coef_d0pk_Q1 = output_`j'[5,6] in `j'
			replace adj_95pct_coef_d0pk_Q1 = output_`j'[6,6] in `j'
			replace b_coef_d0pk_qk1 = output_`j'[1,7] in `j'
			replace bias_coef_d0pk_qk1 = output_`j'[2,7] in `j'
			replace adj_b_coef_d0pk_qk1 = output_`j'[3,7] in `j'
			replace adj_se_coef_d0pk_qk1 = output_`j'[4,7] in `j'
			replace adj_t_coef_d0pk_qk1 = output_`j'[3,7]/output_`j'[4,7] in `j'
			replace adj_05pct_coef_d0pk_qk1 = output_`j'[5,7] in `j'
			replace adj_95pct_coef_d0pk_qk1 = output_`j'[6,7] in `j'
			replace b_coef_d0pk_d1s = output_`j'[1,8] in `j'
			replace bias_coef_d0pk_d1s = output_`j'[2,8] in `j'
			replace adj_b_coef_d0pk_d1s = output_`j'[3,8] in `j'
			replace adj_se_coef_d0pk_d1s = output_`j'[4,8] in `j'
			replace adj_t_coef_d0pk_d1s = output_`j'[3,8]/output_`j'[4,8] in `j'
			replace adj_05pct_coef_d0pk_d1s = output_`j'[5,8] in `j'
			replace adj_95pct_coef_d0pk_d1s = output_`j'[6,8] in `j'
			replace b_coef_d0pk_d1pk = output_`j'[1,9] in `j'
			replace bias_coef_d0pk_d1pk = output_`j'[2,9] in `j'
			replace adj_b_coef_d0pk_d1pk = output_`j'[3,9] in `j'
			replace adj_se_coef_d0pk_d1pk = output_`j'[4,9] in `j'
			replace adj_t_coef_d0pk_d1pk = output_`j'[3,9]/output_`j'[4,9] in `j'
			replace adj_05pct_coef_d0pk_d1pk = output_`j'[5,9] in `j'
			replace adj_95pct_coef_d0pk_d1pk = output_`j'[6,9] in `j'
			replace b_coef_d0pk_d1P = output_`j'[1,10] in `j'
			replace bias_coef_d0pk_d1P = output_`j'[2,10] in `j'
			replace adj_b_coef_d0pk_d1P = output_`j'[3,10] in `j'
			replace adj_se_coef_d0pk_d1P = output_`j'[4,10] in `j'
			replace adj_t_coef_d0pk_d1P = output_`j'[3,10]/output_`j'[4,10] in `j'
			replace adj_05pct_coef_d0pk_d1P = output_`j'[5,10] in `j'
			replace adj_95pct_coef_d0pk_d1P = output_`j'[6,10] in `j'

			replace b_coef_d0P_Q1 = output_`j'[1,11] in `j'
			replace bias_coef_d0P_Q1 = output_`j'[2,11] in `j'
			replace adj_b_coef_d0P_Q1 = output_`j'[3,11] in `j'
			replace adj_se_coef_d0P_Q1 = output_`j'[4,11] in `j'
			replace adj_t_coef_d0P_Q1 = output_`j'[3,11]/output_`j'[4,11] in `j'
			replace adj_05pct_coef_d0P_Q1 = output_`j'[5,11] in `j'
			replace adj_95pct_coef_d0P_Q1 = output_`j'[6,11] in `j'
			replace b_coef_d0P_qk1 = output_`j'[1,12] in `j'
			replace bias_coef_d0P_qk1 = output_`j'[2,12] in `j'
			replace adj_b_coef_d0P_qk1 = output_`j'[3,12] in `j'
			replace adj_se_coef_d0P_qk1 = output_`j'[4,12] in `j'
			replace adj_t_coef_d0P_qk1 = output_`j'[3,12]/output_`j'[4,12] in `j'
			replace adj_05pct_coef_d0P_qk1 = output_`j'[5,12] in `j'
			replace adj_95pct_coef_d0P_qk1 = output_`j'[6,12] in `j'
			replace b_coef_d0P_d1s = output_`j'[1,13] in `j'
			replace bias_coef_d0P_d1s = output_`j'[2,13] in `j'
			replace adj_b_coef_d0P_d1s = output_`j'[3,13] in `j'
			replace adj_se_coef_d0P_d1s = output_`j'[4,13] in `j'
			replace adj_t_coef_d0P_d1s = output_`j'[3,13]/output_`j'[4,13] in `j'
			replace adj_05pct_coef_d0P_d1s = output_`j'[5,13] in `j'
			replace adj_95pct_coef_d0P_d1s = output_`j'[6,13] in `j'
			replace b_coef_d0P_d1pk = output_`j'[1,14] in `j'
			replace bias_coef_d0P_d1pk = output_`j'[2,14] in `j'
			replace adj_b_coef_d0P_d1pk = output_`j'[3,14] in `j'
			replace adj_se_coef_d0P_d1pk = output_`j'[4,14] in `j'
			replace adj_t_coef_d0P_d1pk = output_`j'[3,14]/output_`j'[4,14] in `j'
			replace adj_05pct_coef_d0P_d1pk = output_`j'[5,14] in `j'
			replace adj_95pct_coef_d0P_d1pk = output_`j'[6,14] in `j'
			replace b_coef_d0P_d1P = output_`j'[1,15] in `j'
			replace bias_coef_d0P_d1P = output_`j'[2,15] in `j'
			replace adj_b_coef_d0P_d1P = output_`j'[3,15] in `j'
			replace adj_se_coef_d0P_d1P = output_`j'[4,15] in `j'
			replace adj_t_coef_d0P_d1P = output_`j'[3,15]/output_`j'[4,15] in `j'
			replace adj_05pct_coef_d0P_d1P = output_`j'[5,15] in `j'
			replace adj_95pct_coef_d0P_d1P = output_`j'[6,15] in `j'
	
		}
	}	
}

* outsheeting the results
local filename "ccep_biascorrection_ecm_newPT3_demeanq_semiannual_PW_f1_indust.csv"
outsheet using "`outpath1'/`filename'", comma replace

***********************************************************************
** Storing halflives 1000 simulations per 101 goods
***********************************************************************

clear

set obs 2000
gen sim = _n

forvalues i = 1/`goods'{
	if `nopairs_`i'' > 1{
		svmat halflife_`i', names(col)
		rename c1 hl_q_eshock_good`i'
		rename c2 hl_qk_eshock_good`i'
		rename c3 hl_q_Pshock_good`i'
		rename c4 hl_qk_Pshock_good`i'
		rename c5 hl_q_pkshock_good`i'
		rename c6 hl_qk_pkshock_good`i'
	}
	gen spacer`i' = .
}

* outsheeting the results
local filename "ccep_halflives_ecm_newPT3_demeanq_semiannual_PW_f1_indust.csv"
outsheet using "`outpath1'/`filename'", comma replace

log close

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
 
 
 
