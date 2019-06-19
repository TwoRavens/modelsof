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


local programpath "P:\BerginGlickWu Replication\Table 3\3b\programs\disagg"
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

local goods  =101												//number of goods
local pairs = 20												//number of pairs
local tsobs = 35												//time observations
local group = 532												//number of pairs b4 taking sample

**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************


*
************* Seminnual - Traded - PW - Filter 1 ************
*


// Transferring variables and results to matrix

forvalues j = 1/`goods'{
	* reading in the data for only good j
	use series_title date q* s* ERprod_PWonecity* if series_title == `j' using "`datapath'\semiannual_lc_drop1_f1_wide_`descrip'.dta", clear
	
	/* adjusting the exchange rate series
	it is currently in the form (LC/USD) so q = p - s
	currently it is log(nom price(i))-log(nom price(j)) - (log(lc(i)/USD) - log(lc(j)/USD))
	we will flip the exchange rate series by multiplying by negative 1
	so that the calculation for q is q = p + s
	We also create the q series (calling it rer)
	*/
	forvalues i = 1/`group'{
		quietly replace s`i' = -s`i'
		rename s`i' s`i'_0
		rename q`i' q`i'_0
		quietly gen rer`i'_0 = q`i'_0 + s`i'_0
	}
	
	capture drop series_title
	
	** dropping if there are missing values
	** or if they are not part of the PW group
	local counter = 0
	forvalues i = 1/`group'{
		quietly count if q`i'_0 != .
		if r(N) == `tsobs'{
			quietly count if s`i'_0 != .
			if r(N) == `tsobs'{
				if ERprod_PWonecity`i' == 1{
					local exchange `exchange' s`i'_0
					local x `x' q`i'_0
				}
				else{
					capture quietly drop q`i'_0
					capture quietly drop s`i'_0
					capture quietly drop rer`i'_0
					local counter = `counter' + 1
				}
			}
			else{
				capture quietly drop q`i'_0
				capture quietly drop s`i'_0
				capture quietly drop rer`i'_0
				local counter = `counter' + 1
			}
				
		}
		else{
			capture quietly drop q`i'_0
			capture quietly drop s`i'_0
			capture quietly drop rer`i'_0
			local counter = `counter' + 1
		}
		
	}
	
	capture drop ERprod_PWonecity*

	
	** number of pairs for the given good
	local nopairs_`j' = `group' - `counter'
	sort date
	
	if `nopairs_`j'' >1{
	
		* creating matrices for estimation
		mkmat `exchange', mat(exchange)								//exchange rate matrix for good k
		mkmat `x', mat(x)											//pk matrix for good k

		mat data2 = exchange, x	
	
		preserve
		ccep_main data2, vars(2) n1(1000) n2(2000)
		restore
		mat output_`j' = e(output)
		mat btstp_beta_`j'_ = e(btstp_beta)
		di "good `j'"
		mat list output_`j'
	}

	local exchange												//rewriting exchange local so that we can reuse it
	local x														//rewriting x local so that we can reuse it
}


** Creating variables to store the results
clear
set obs `goods'
gen good = .
gen pairs = .
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
gen spacer1 = ""
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


** filling in the results
forvalues j = 1/`goods'{
	replace good = `j' in `j'

	** only filling in if we ran the estimation
	if `nopairs_`j'' > 1{
		quietly{
			replace pairs = `nopairs_`j'' in `j'
			replace b_coef_d0s_qk1 = output_`j'[1,1] in `j'
			replace bias_coef_d0s_qk1 = output_`j'[2,1] in `j'
			replace adj_b_coef_d0s_qk1 = output_`j'[3,1] in `j'
			replace adj_se_coef_d0s_qk1 = output_`j'[4,1] in `j'
			replace adj_t_coef_d0s_qk1 = output_`j'[3,1]/output_`j'[4,1] in `j'
			replace adj_05pct_coef_d0s_qk1 = output_`j'[5,1] in `j'
			replace adj_95pct_coef_d0s_qk1 = output_`j'[6,1] in `j'
			replace b_coef_d0s_d1s = output_`j'[1,2] in `j'
			replace bias_coef_d0s_d1s = output_`j'[2,2] in `j'
			replace adj_b_coef_d0s_d1s = output_`j'[3,2] in `j'
			replace adj_se_coef_d0s_d1s = output_`j'[4,2] in `j'
			replace adj_t_coef_d0s_d1s = output_`j'[3,2]/output_`j'[4,2] in `j'
			replace adj_05pct_coef_d0s_d1s = output_`j'[5,2] in `j'
			replace adj_95pct_coef_d0s_d1s = output_`j'[6,2] in `j'
			replace b_coef_d0s_d1pk = output_`j'[1,3] in `j'
			replace bias_coef_d0s_d1pk = output_`j'[2,3] in `j'
			replace adj_b_coef_d0s_d1pk = output_`j'[3,3] in `j'
			replace adj_se_coef_d0s_d1pk = output_`j'[4,3] in `j'
			replace adj_t_coef_d0s_d1pk = output_`j'[3,3]/output_`j'[4,3] in `j'
			replace adj_05pct_coef_d0s_d1pk = output_`j'[5,3] in `j'
			replace adj_95pct_coef_d0s_d1pk = output_`j'[6,3] in `j'

			replace b_coef_d0pk_qk1 = output_`j'[1,4] in `j'
			replace bias_coef_d0pk_qk1 = output_`j'[2,4] in `j'
			replace adj_b_coef_d0pk_qk1 = output_`j'[3,4] in `j'
			replace adj_se_coef_d0pk_qk1 = output_`j'[4,4] in `j'
			replace adj_t_coef_d0pk_qk1 = output_`j'[3,4]/output_`j'[4,4] in `j'
			replace adj_05pct_coef_d0pk_qk1 = output_`j'[5,4] in `j'
			replace adj_95pct_coef_d0pk_qk1 = output_`j'[6,4] in `j'
			replace b_coef_d0pk_d1s = output_`j'[1,5] in `j'
			replace bias_coef_d0pk_d1s = output_`j'[2,5] in `j'
			replace adj_b_coef_d0pk_d1s = output_`j'[3,5] in `j'
			replace adj_se_coef_d0pk_d1s = output_`j'[4,5] in `j'
			replace adj_t_coef_d0pk_d1s = output_`j'[3,5]/output_`j'[4,5] in `j'
			replace adj_05pct_coef_d0pk_d1s = output_`j'[5,5] in `j'
			replace adj_95pct_coef_d0pk_d1s = output_`j'[6,5] in `j'
			replace b_coef_d0pk_d1pk = output_`j'[1,6] in `j'
			replace bias_coef_d0pk_d1pk = output_`j'[2,6] in `j'
			replace adj_b_coef_d0pk_d1pk = output_`j'[3,6] in `j'
			replace adj_se_coef_d0pk_d1pk = output_`j'[4,6] in `j'
			replace adj_t_coef_d0pk_d1pk = output_`j'[3,6]/output_`j'[4,6] in `j'
			replace adj_05pct_coef_d0pk_d1pk = output_`j'[5,6] in `j'
			replace adj_95pct_coef_d0pk_d1pk = output_`j'[6,6] in `j'
			
	
		}
	}	
}

* outsheeting the data
local filename "ccep_disagg_biascorrection_ecm_newPT3_demeanq_semiannual_PW_f1_`descrip'.csv"
outsheet using "`outpath1'/`filename'", comma replace

* saving the bootstrapped betas
clear
set obs 2000
gen sim = _n
forvalues i = 1/`goods'{
	if `nopairs_`i'' > 1{
		svmat btstp_beta_`i'_
	}
}

local filename2 "ccep_disagg_biascorrected_btstrp_betas_ecm_newPT3_demeanq_semiannual_PW_f1_`descrip'.csv"
outsheet using "`outpath1'/`filename2'", comma replace

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
 
 
 
