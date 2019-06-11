**********************************************************************************
* Code that produces bootstrapped standard errors
**********************************************************************************

set more off
clear all
set maxvar  11000
set matsize 11000

*************************
* Where data lies
*************************

cap cd ""

local out_dir = "Output"

* Fixed Effect Options
local fe_fico = "a=zero#bank#quarter b=lc#zero"
local N = 500

**********************************************************************************************
* Program to Produce Winzoried LHS
**********************************************************************************************

program define lhs_win
	cap drop lhs
	cap drop lhs_w
	qui gen lhs = `1'
	qui winsor2 lhs, cuts(2.5 97.5)
	cap replace lhs = lhs_w
	cap drop a
	cap drop b	
	cap drop c
	cap drop d
end
	
************************************************************************
* Program to assign output from reghdfe to matrices
************************************************************************

program define var_assign

	cap drop dummies

	* Use output from reghdfe
	mat def new = e(b)

	* Recover fixed effects from reghdfe
	qui predict dummies, d 
	qui su      dummies `2'
	qui local   cons = "`r(mean)'"

	cap mat def `1'1 = `1'1 \  `cons'
	cap mat def `1'2 = `1'2 \ (new[1,"2.fico_coarse_2"] + `cons')
	cap mat def `1'3 = `1'3 \ (new[1,"3.fico_coarse_2"] + `cons')
	cap mat def `1'4 = `1'4 \ (new[1,"4.fico_coarse_2"] + `cons')

end

********************************************************************************************************************
********************************************************************************************************************
* Boostrap
********************************************************************************************************************
********************************************************************************************************************

*****************************************************
* Produce dataset with bootstrapped coeffiecients
*****************************************************

clear
set obs 0
gen sample = 1
save "Data/RD Bootstrap", replace

set seed 1000

forvalues n = 1/`N' { 
	
	display ""
	display "-------------------------------------" 
	display "Start loop: `n'" 
	display ""
	
	qui {
 	
		use "Data`c(dirsep)'RD_Estimates_CL_Loop_Edit", replace
			
		* Sample with replacement
		if `n' != 1 { 
			bsample `_N'			
		}	
						
		* Adjust those on quarterly frequency to have monthly frequency
		forval i = 4(4)24 {
			cap local j = `i' * 3
			cap ren *_bcbal_f`i'* *_nbcbal_f`j'*
			cap ren *_bccl_f`i'*  *_nbccl_f`j'*
		}
		cap rename *_nb* *_b*
					
		****************************
		* RENAME FOR LONGER LOOP
		****************************
		
		forval i = 12(12)60 {
		
			* MARGINALS
			cap gen b_adb_btstr_f`i'         = b_cv_avgdailybal_f`i'_mean
			cap gen b_totpurvol_btstr_f`i'   = b_cv_totpurvol_po`i'_mean
			cap gen b_chgoff_btstr_f`i'      = b_cv_totchgoffamt_po`i'_mean
			cap gen b_evdpd90_btstr_f`i'     = b_cv_evdpd90p_po`i'_mean
			cap gen b_evdpd60_btstr_f`i'     = b_cv_evdpd60p_po`i'_mean
			cap gen b_bcbal_btstr_f`i'       = b_cv_bcbal_f`i'_mean
			cap gen b_bccl_btstr_f`i'        = b_cv_bccl_f`i'_mean
			cap gen b_cl_btstr_f`i'          = b_cv_currcredlimit_f`i'_mean
			cap gen b_intbrdt_btstr_f`i'     = b_cv_intbrdt_f`i'_mean
			cap gen b_cost_btstr_f`i'        = b_cv_cost_po`i'
			cap gen b_income_btstr_f`i'      = b_cv_income_po`i'
			cap gen b_profit_btstr_f`i'      = b_cv_netincome_po`i'
			cap gen b_totadb_btstr_f`i'      = b_cv_totadb_po`i'_mean
			cap gen b_totfinchg_btstr_f`i'   = b_cv_totfinchg_po`i'_mean
			cap gen b_totfees_btstr_f`i'     = b_cv_totfees_po`i'_mean
					
			* AVERAGES
			cap gen avg_adb_btstr_f`i'         = avg1_avgdailybal_f`i'_mean
			cap gen avg_totpurvol_btstr_f`i'   = avg1_totpurvol_po`i'_mean
			cap gen avg_chgoff_btstr_f`i'      = avg1_totchgoffamt_po`i'_mean
			cap gen avg_evdpd90_btstr_f`i'     = avg1_evdpd90p_po`i'_mean
			cap gen avg_evdpd60_btstr_f`i'     = avg1_evdpd60p_po`i'_mean
			cap gen avg_bcbal_btstr_f`i'       = avg1_bcbal_f`i'_mean
			cap gen avg_bccl_btstr_f`i'        = avg1_bccl_f`i'_mean
			cap gen avg_cl_btstr_f`i'          = avg1_currcredlimit_f`i'_mean
			cap gen avg_intbrdt_btstr_f`i'     = avg1_intbrdt_f`i'_mean
			cap gen avg_cost_btstr_f`i'        = avg1_cost_po`i'
			cap gen avg_income_btstr_f`i'      = avg1_income_po`i'
			cap gen avg_profit_btstr_f`i'      = avg1_netincome_po`i'   
			cap gen avg_totadb_btstr_f`i'      = avg1_totadb_po`i'_mean
			cap gen avg_totfinchg_btstr_f`i'   = avg1_totfinchg_po`i'_mean
			cap gen avg_totfees_btstr_f`i'     = avg1_totfees_po`i'_mean
		}
						
		foreach var in profit totadb chgoff bcbal adb evdpd90 evdpd60 cl cost income bccl totpurvol totfees totfinchg intbrdt { 			
		
			noisily display "   Variable: `var'"
			
			preserve			
			
			mat  def f = 0

			forval x = 1(1)4 {
				mat  def marginal`x'       = 0
				mat  def slope_marginal`x' = 0
			}
				
			foreach i in 12 24 36 48 60 {
				
				cap mat def f = f \ `i'
				
				*********************
				* MARGINAL EFFECT
				*********************
				
				cap lhs_win b_`var'_btstr_f`i'
				cap reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
				var_assign marginal

				***************************
				* SLOPE OF MARGINAL EFFECT
				***************************
				
				* Create Slope of Marginal under Linearity Assumption
				gen beta_marginal_`var'`i'  = 2 * (b_`var'_btstr_f`i' - (avg_`var'_btstr_f`i'/cl))/cl
				
				* How does this vary by FICO?
				cap noisily lhs_win beta_marginal_`var'`i'
				reghdfe lhs i.fico_coarse_2, absorb(`fe_fico') 
				var_assign slope_marginal
		}	
				
		clear
		svmat f	
			
		********************
		* OUTPUT FOR FILE
		********************
		
		forv i = 1/4 {
			svmat marginal`i'
			svmat slope_marginal`i'
		}
				
		drop in 1
						
		gen y_var  = "`var'"
		gen sample = `n'
			
		order y_var f1 sample
		
		append using "Data/RD Bootstrap"
		cap save "Data/RD Bootstrap", replace	
		
		restore	
		
		}
	}			
}

use "Data/RD Bootstrap", clear
br

************************************************************************
* NOW BOOTSTRAP THE MPL RESULTS
************************************************************************

set more off
clear all

set obs 0
gen sample = 1
save "Data/MPL Bootstrap", replace

use "Data/RD Bootstrap.dta", clear

sum sample
local N = `r(max)'
forvalues n = 1/`N' { 

	preserve
	
	qui keep if sample == `n'
	
	display "`n'"
	
	mat  def f = 0
	
	mat  def mpl1 = 0
	mat  def mpl2 = 0
	mat  def mpl3 = 0
	mat  def mpl4 = 0
		
	foreach i in 12 24 36 48 60 {
	
		mat def f = f \ `i'
		
		forv j = 1/4 {
		
			capture {
			
				display "`i' -- `j'"
				
				qui su marginal`j'1 if y_var == "totadb" & f1 == `i' 
				local mpb = `r(mean)'
				
				qui su slope_marginal`j' if y_var == "profit" & f1 == `i' 
				local beta = `r(mean)'
				
				mat def new = - (0.01/12) * `mpb'/`beta'
				mat def mpl`j' = mpl`j' \ new[1,1]
					
			}
		  }
		}	
	
	clear
	
	qui svmat f	
	
	forv i = 1/4 {
		qui svmat mpl`i'
	} 
		
	qui drop in 1
	qui gen y_var = "mpl"
	qui gen sample = `n'
	qui order y_var f1 sample
	
	sleep 1000
	qui append using "Data/MPL Bootstrap"	
	sleep 1000
	qui save "Data/MPL Bootstrap", replace
	sleep 1000
	restore
}
	
use "Data/MPL Bootstrap", clear
br
