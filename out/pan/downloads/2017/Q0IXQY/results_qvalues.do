//  This do-file generates Figure 6 in the paper
// "Using Split Samples to Improve Inference on Causal Effects" (M. Fafchamps and J. Labonne)

//  Note: the lines of code computing the sharpened qvalue rely on code (fdr_sharpened_qvalues) provided by Michael L. Anderson  
//  Available at http://are.berkeley.edu/~mlanderson/ARE_Website/Research.html visited on Sept 2, 2013


version 12
set more off , perm
net set ado  "ado"
adopath +  "ado"
set scheme sol


* Start by creating files with distributions of pvalues 

set seed 234
forvalues s=500(100)5000 { 
foreach e in  20  {

	clear
	g iteration=.
  	g pvalue_full = .
	g pvalue_split =.
	
	saveold  "data/pvalue_`s'_`e'.dta", replace
	
	clear

	local maxiter = 1000
	local iter = 1

	while `iter' <= `maxiter' {
	display "Iteration `iter' sample size `s' effect size `e'"
	qui {
			// generate the sample of size `s'
			clear
			set obs	`s'
			g iteration = `iter'
			g r=uniform()
			egen rank = rank(r) 
			g treated = (rank < `s'/2 +1 )
			drop r rank
			// generate the outcome variables w/ the adequate effect size
			gen y = rnormal(0,1) if treated==0			  			  
			replace y = rnormal( `e'/100,1) if treated==1		
	
			// split the sample between training and testing sample
			g r=uniform()
			egen rank = rank(r) 
			g testing = (rank < `s'/2 +1 )
			drop r rank					  			  
			
			* get p-value for the test on the full sample
			reg y treated 
			gen coeff = _b[treated]
			gen se = _se[treated]
			gen pvalue_full = 2*ttail( e(df_r) , abs(_b[treated] / _se[treated] ))
			drop se coeff
			
			* get p-value for the test on the testing sample	
			reg y treated if testing==1
			gen coeff = _b[treated]
			gen se = _se[treated]
			gen pvalue_split = 2*ttail( e(df_r) , abs(_b[treated] / _se[treated] ))
			drop se coeff
			
			*only keep the relevant information and append it to the main dataset
			keep iteration pvalue* 
			keep in 1
			append using  "data/pvalue_`s'_`e'.dta"
			saveold   "data/pvalue_`s'_`e'.dta", replace
		
			local iter = `iter' + 1
			
	}	
	}				
}
}	

// Now we compute the qvalues for both the full sample and the split sample 
forvalues s=500(100)5000 { 
foreach e in   20  {

	clear
	set obs 1000
	forvalues i=1(1)10 {
		g qvalue_full_`i' = .
		g qvalue_split_`i' =.
	}
	saveold  "data/qvalue_10_`s'_`e'.dta", replace

	clear

	local maxiter = 1000
	local iter = 1

while `iter' <= `maxiter' {
display "Iteration full `iter' sample size `s' effect size `e'"

qui {

		// we start by randomly selecting pvalues from the relevant distributions
		* we assume that we have 10 non-true null hypotheses 

		use "data/pvalue_`s'_`e'.dta", replace
		g r=uniform()
		egen rank = rank(r) 
		forvalues i=1(1)10 {
			su pvalue_full if rank==`i'
			local pvalue_full_`i' = r(mean)
		}
		
		// for the true null hypotheses the pvalue are uniformly distribution
		clear
		set obs	100
		g pvalue=uniform()
		forvalues i=1(1)10 {

			replace pvalue = `pvalue_full_`i'' in `i'
		}
		
		quietly sum pvalue 
		local totalpvals = r(N)
		
		* Sort the p-values in ascending order and generate a variable that codes each p-value's rank
		
		quietly gen int original_sorting_order = _n
		quietly sort  pvalue 
		quietly gen int rank = _n if  pvalue ~=.
		
		* Set the initial counter to 1 
		
		local qval = 1
		
		* Generate the variable that will contain the BKY (2006) sharpened q-values
		
		gen bky06_qval_`x' = 1 if  pvalue ~=.
		
		* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.
	
		
		while `qval' > 0 {
		
			* First Stage
			* Generate the adjusted first stage q level we are testing: q' = q/1+q
			local qval_adj = `qval'/(1+`qval')
			* Generate value q'*r/M
			gen fdr_temp1 = `qval_adj'*rank/`totalpvals'
			* Generate binary variable checking condition p(r) <= q'*r/M
			gen reject_temp1 = (fdr_temp1>= pvalue ) if  pvalue~=.
			* Generate variable containing p-value ranks for all p-values that meet above condition
			gen reject_rank1 = reject_temp1*rank
			* Record the rank of the largest p-value that meets above condition
			egen total_rejected1 = max(reject_rank1)
		
			* Second Stage
			* Generate the second stage q level that accounts for hypotheses rejected in first stage: q_2st = q'*(M/m0)
			local qval_2st = `qval_adj'*(`totalpvals'/(`totalpvals'-total_rejected1[1]))
			* Generate value q_2st*r/M
			gen fdr_temp2 = `qval_2st'*rank/`totalpvals'
			* Generate binary variable checking condition p(r) <= q_2st*r/M
			gen reject_temp2 = (fdr_temp2>= pvalue ) if  pvalue~=.
			* Generate variable containing p-value ranks for all p-values that meet above condition
			gen reject_rank2 = reject_temp2*rank
			* Record the rank of the largest p-value that meets above condition
			egen total_rejected2 = max(reject_rank2)
		
			* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
			replace bky06_qval_`x' = `qval' if rank <= total_rejected2 & rank~=.
			* Reduce q by 0.001 and repeat loop
			drop fdr_temp* reject_temp* reject_rank* total_rejected* 
			local qval = `qval' - .001
		}
	
		forvalues i=1(1)10 {
			su bky06_qval if original_sorting_order ==`i' 
			local mean_`i'=r(mean)
		}
		clear  
		use "data/qvalue_10_`s'_`e'.dta"
		forvalues i=1(1)10{
			replace qvalue_full_`i' = `mean_`i'' in `iter'
		}
		save "data/qvalue_10_`s'_`e'.dta" , replace

		local iter = `iter' + 1

}
}


clear

	* compute power on the training set as it's needed to estimate the number of tests on the testing sets
	local power_first_share =normal( `e'/100 * sqrt(.5*`s'/4) - invnormal(1-0.05/(2)) ) 
		
	local maxiter = 1000
	local iter = 1

while `iter' <= `maxiter' {
display "Iteration training `iter' sample size `s' effect size `e'"

qui {
		clear 
		set obs 1 
		* we have 90 true null hypotheses; we need to compute the number that will be wrongly rejected on the training set
		local nb_tests_true = rbinomial(90,0.05) 		
		
		* compute the number of non-true null hypotheses that are rejected on the training set
		if `power_first_share' < 1 {
			local nb_tests_false= rbinomial(10 , `power_first_share')    
		}
		if `power_first_share' == 1 {
			local nb_tests_false= 10 
		}
		
		
		* take pvalues 
		use "data/pvalue_`s'_`e'.dta", replace
		g r=uniform()
		egen rank = rank(r) 
		forvalues i=1(1)10 {
			su pvalue_split if rank==`i'
			local pvalue_split_`i' = r(mean) 	
		}

		
		clear
		local obs = `nb_tests_true' + 10 
		set obs	`obs'
		

		if `nb_tests_false' > 0 { 
		
			g pvalue=uniform()
			forvalues i=1(1)10 {
				replace pvalue = `pvalue_split_`i'' in `i'
			}
			quietly gen int original_sorting_order = _n

			g r=uniform()
			egen rank = rank(r) if _n < 11
			sort rank
			local j=1+ `nb_tests_false'  
			forvalues i=`j'(1)10 {
				replace pvalue = . in `i' 
			}
			drop r rank
			quietly sum pvalue 
			local totalpvals = r(N)
			
			* Sort the p-values in ascending order and generate a variable that codes each p-value's rank
			
			quietly sort  pvalue 
			quietly gen int rank = _n if  pvalue ~=.
			
			* Set the initial counter to 1 
			
			local qval = 1
			
			* Generate the variable that will contain the BKY (2006) sharpened q-values
			
			gen bky06_qval_`x' = 1 if  pvalue ~=.
			
			* Set up a loop that begins by checking which hypotheses are rejected at q = 1.000, then checks which hypotheses are rejected at q = 0.999, then checks which hypotheses are rejected at q = 0.998, etc.  The loop ends by checking which hypotheses are rejected at q = 0.001.
		
			
			while `qval' > 0 {
			
				* First Stage
				* Generate the adjusted first stage q level we are testing: q' = q/1+q
				local qval_adj = `qval'/(1+`qval')
				* Generate value q'*r/M
				gen fdr_temp1 = `qval_adj'*rank/`totalpvals'
				* Generate binary variable checking condition p(r) <= q'*r/M
				gen reject_temp1 = (fdr_temp1>= pvalue ) if  pvalue~=.
				* Generate variable containing p-value ranks for all p-values that meet above condition
				gen reject_rank1 = reject_temp1*rank
				* Record the rank of the largest p-value that meets above condition
				egen total_rejected1 = max(reject_rank1)
			
				* Second Stage
				* Generate the second stage q level that accounts for hypotheses rejected in first stage: q_2st = q'*(M/m0)
				local qval_2st = `qval_adj'*(`totalpvals'/(`totalpvals'-total_rejected1[1]))
				* Generate value q_2st*r/M
				gen fdr_temp2 = `qval_2st'*rank/`totalpvals'
				* Generate binary variable checking condition p(r) <= q_2st*r/M
				gen reject_temp2 = (fdr_temp2>= pvalue ) if  pvalue~=.
				* Generate variable containing p-value ranks for all p-values that meet above condition
				gen reject_rank2 = reject_temp2*rank
				* Record the rank of the largest p-value that meets above condition
				egen total_rejected2 = max(reject_rank2)
			
				* A p-value has been rejected at level q if its rank is less than or equal to the rank of the max p-value that meets the above condition
				replace bky06_qval_`x' = `qval' if rank <= total_rejected2 & rank~=.
				* Reduce q by 0.001 and repeat loop
				drop fdr_temp* reject_temp* reject_rank* total_rejected* 
				local qval = `qval' - .001
			}
			forvalues i=1(1)10 {
				su bky06_qval if original_sorting_order ==`i' 
				local mean_`i'=r(mean)
			}
			
			
			clear  
			use "data/qvalue_10_`s'_`e'.dta"
			
			forvalues i=1(1)10{
				replace qvalue_split_`i' = `mean_`i'' in `iter'
			}
		

			save "data/qvalue_10_`s'_`e'.dta" , replace
		}	
		local iter = `iter' + 1
}
}


}
}




// compute power for each combination of parameters
forvalues s=500(100)5000 { 
foreach e in   20  {

	use  "data/qvalue_10_`s'_`e'.dta", clear
	
	foreach x in  split full {
		local power_`x'_`s'_`e' = 0
		// compute is the share of iterations for which the qvalue is lower than .05
		forvalue i=1(1)10{
		
			count if qvalue_`x'_`i' <0.05
			local power_`x'_`s'_`e' = r(N)/1000 + `power_`x'_`s'_`e''
		}
		local power_`x'_`s'_`e'  = `power_`x'_`s'_`e'' /10
	}

}
}

// generate a file with power for each combination of parameters
clear
set obs 46
g n=100*(4+_n)
foreach e in  20  {

	g power_full_`e'_qvalue = .
	g power_split_`e'_qvalue = .
}

forvalues s=500(100)5000 { 
foreach e in  20  {
foreach x in full split {
	replace power_`x'_`e'_qvalue =  `power_`x'_`s'_`e'' if n==`s' 
	
}
}
}
sort n
save "data/results_qvalue.dta" , replace



*** GENERATE GRAPHS COMPARING SPLIT AND FULL SAMPLE APPROACHES
use "data/results.dta" , clear

*keep data for the relevant simulation parameters
keep if n< 5001 
keep if effect_size == .2
keep if share==.5
keep if m==100 & m0==90

sort n
merge n using "data/results_qvalue.dta"

*** FIGURE 6
foreach e in   20   {
	
	
	tw (line power_full_`e'_qvalue n , msize(vsmall) lpattern(solid) lcolor(gs9) legend(label(1 "Full sample (q-value)"))   ) ///
	(line power_split_`e'_qvalue  n , msize(vsmall) lpattern("-.") lcolor(gs9) legend(label(2 "Split sample (q-value)")) ///
	xtitle("Sample Size") ytitle("Power") name(power`b' , replace) )
	graph export "output/power_qvalue_`e'.pdf", as(pdf) replace
		
	
}

forvalues s=500(100)5000 { 
foreach e in   20  {
	capture erase "data/qvalue_10_`s'_`e'.dta"
	capture erase "data/pvalue_`s'_`e'.dta"
}
}
