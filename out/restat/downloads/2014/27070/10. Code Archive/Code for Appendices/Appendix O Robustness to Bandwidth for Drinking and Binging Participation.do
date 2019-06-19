*APPENDIX O

insheet using "`data_CHIS'", comma clear                   

gen age_c = age - 21
gen post = 0
replace post = 1 if age_c >= 0
gen age_c_p = age_c*post
gen age_c_sq = age_c*age_c
gen age_c_sq_p = age_c*age_c*post
gen bmonth = 1 
replace bmonth = 1 if relmonths == 0

gen dranklm_p = 100*dranklm
gen bingedlm_p = 100*bingedlm


local drink_meas  = "dranklm_p bingedlm_p "

matrix drop _all 


foreach var  of varlist `drink_meas'  {
   forvalues rel_age = 3(1)24 {
      reg `var' post bmonth age_c age_c_p age_c_sq age_c_sq_p if relmonths >= -`rel_age' -1 & relmonths <= `rel_age'
     *Get number of obs and write to local N
      local N = e(N)
     *Write out the betas as a matrix on a row
      matrix eb = e(b)
      matrix list eb
     *Write out the variances as a row
      matrix se = vecdiag(e(V))
      matrix list eb
     *Write out the variance for just the post variable it is the first as it is the first listed in the reg command	 
      matrix res = (`rel_age',`N',eb[1,1],sqrt(se[1,1]))
      matrix list res
      matrix results_`var' = (nullmat(results_`var') \ res)
   }
   matrix list results_`var' 
   svmat results_`var' 
}

*Get degrees of freedom
gen df = results_dranklm_p2 - 5

*Import students T
gen student_t = 12.71 if df == 1 
replace student_t = 4.303 if df == 2 
replace student_t = 3.182 if df == 3 
replace student_t = 2.776 if df == 4 
replace student_t = 2.571 if df == 5 
replace student_t = 2.447 if df == 6 
replace student_t = 2.365 if df == 7 
replace student_t = 2.306 if df == 8 
replace student_t = 2.262 if df == 9 
replace student_t = 2.228 if df == 10 
replace student_t = 2.201 if df == 11 
replace student_t = 2.179 if df == 12 
replace student_t = 2.160 if df == 13 
replace student_t = 2.145 if df == 14 
replace student_t = 2.131 if df == 15 
replace student_t = 2.120 if df == 16 
replace student_t = 2.110 if df == 17 
replace student_t = 2.101 if df == 18 
replace student_t = 2.093 if df == 19 
replace student_t = 2.086 if df == 20 
replace student_t = 2.080 if df == 21 
replace student_t = 2.074 if df == 22 
replace student_t = 2.069 if df == 23 
replace student_t = 2.064 if df == 24 
replace student_t = 2.060 if df == 25 
replace student_t = 2.056 if df == 26 
replace student_t = 2.052 if df == 27 
replace student_t = 2.048 if df == 28 
replace student_t = 2.045 if df == 29 
replace student_t = 2.042 if df >= 30 & df < 40 
replace student_t = 2.021 if df >= 40 & df < 50 
replace student_t = 2.009 if df >= 50 & df < 60 
replace student_t = 2.000 if df >= 60 & df < 80 
replace student_t = 1.990 if df >= 80 & df < 100
replace student_t = 1.984 if df >= 100 & df < 120
replace student_t = 1.980 if df == 120
replace student_t = 1.960 if df > 120 

*Generate the bandwidth variable
gen band = results_bingedlm_p1/12

*Create the confidence intervals
foreach var  of varlist `drink_meas'  {
   gen `var'_upper_CI = results_`var'3 + student_t*results_`var'4
   gen `var'_lower_CI = results_`var'3 - student_t*results_`var'4
    
}




graph twoway  (scatter results_dranklm_p3 band, mcolor(black)  msymbol(T)  msize(small)  yscale(range(0,20)) ylabel(#3, nogrid))  ///
              (line results_dranklm_p3 band, lwidth(thin) lcolor(black) ) ///
			  (line  dranklm_p_upper_CI  band, lwidth(thin) lcolor(black) clpattern(dot)) ///
			  (line  dranklm_p_lower_CI band, lwidth(thin) lcolor(black) clpattern(dot)) ///
              (scatter results_bingedlm_p3 band, mcolor(red)  msymbol(S)  msize(small)) ///
              (line results_bingedlm_p3 band, lwidth(thin) lcolor(red)) ///	
			  (line  bingedlm_p_upper_CI  band, lwidth(thin) lcolor(red) clpattern(dot)) 	///
			  (line  bingedlm_p_lower_CI band, lwidth(thin) lcolor(red) clpattern(dot)) 	///
              , title("Appendix O: Percent of Days Drinking and Binge Drinking")  subtitle("Robustness to Bandwidth Choice") xtitle("Bandwidth") ///
			   ytitle("Estimate of Precent Jump at 21")  ///
			 legend(off) text(28 1.7 "Drinking", color(black)) text(7 1.7 "Binge Drinking", color(red)) ///
			 note("Note: The estimates of the increase at age 21 are from a second order quadractic polynomial fully interacted with an indicator" ///
			      "variable for being over 21. The heavy line is the point estimate; the dotted line is the 95% confidence interval.",size(vsmall)) graphregion(style(none) color(gs16))  yline(0, lwidth(vthin) lcolor(black))

cd "`base'"
grexportpdf Appendix_O.pdf 
