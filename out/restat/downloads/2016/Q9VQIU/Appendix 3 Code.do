set matsize 2000

*Emergency Department Cell Data
use "`base'\Data Files and Code That Produced Them\P03 ED Analysis File", replace
 
gen pop_all_np =  1 + 0.00104*(months_21/12)
gen pop_m      =  1 + 0.00016718*(months_21/12)
gen pop_f_np   =  1 + 0.00196*(months_21/12)

local dvars "illness_all_np_r injury_or_alc_all_np_r"

matrix drop _all 

foreach var  of varlist `dvars'  {
   forvalues rel_age = 5(1)36 {
      reg `var'  over dummy21   age_c age_c_sq age_c_post age_c_post_sq  if months_21 >= -`rel_age' -1 & months_21 <= `rel_age' [aweight=pop_all_np], robust
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

*Generate the bandwidth variable
gen band = results_illness_all_np_r1/12

*Create the confidence intervals
foreach var  of varlist `dvars'  {
   gen `var'_upper_CI = results_`var'3 + 1.96*results_`var'4
   gen `var'_lower_CI = results_`var'3 - 1.96*results_`var'4
}

#delimit ;
graph twoway  (line results_illness_all_np_r3 band, lwidth(heavy) lcolor(black)     yscale(range(-100,100)) ylabel(#3, nogrid))  
			  (line illness_all_np_r_upper_CI band, lwidth(medium) lcolor(black) clpattern(dot))  
			  (line illness_all_np_r_lower_CI  band, lwidth(medium) lcolor(black) clpattern(dot))  
			  (line results_injury_or_alc_all_np_r3 band, lwidth(heavy) lcolor(blue)   )  
			  (line injury_or_alc_all_np_r_upper_CI band, lwidth(medium) lcolor(blue) clpattern(dot))  
			  (line injury_or_alc_all_np_r_lower_CI  band, lwidth(medium) lcolor(blue) clpattern(dot))   if band > .3 & band < 3			  
              , title("Appendix 3: Increase in ED Visits", size(4))  
			  subtitle("Robustness to Bandwidth Choice", size(3)) 
			  xtitle("Bandwidth in Years") 
			   ytitle("Increase in ED Visit Rates at 21") legend(off) 
			  text(23 1.8 "Not Injury or Intoxication", color(black))    
			  text(78  1.8 "Injury or Alcohol Intoxication",color(blue))    
			  note("Note: The estimates of the increase at age 21 are from a second order quadratic polynomial fully interacted with an indicator" 
			      "variable for being over 21. The heavy line is the point estimate; the dotted line is the 95% confidence interval.",size(vsmall)) graphregion(style(none) color(gs16))  yline(0, lwidth(vthin) lcolor(black))
      ;
#delimit cr
grexportpdf "`base'\Code for Appendices\Appendix 3.pdf"



 
 



