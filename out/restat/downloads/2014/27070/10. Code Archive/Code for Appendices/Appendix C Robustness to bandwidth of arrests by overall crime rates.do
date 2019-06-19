*APPENDIX C
drop _all
set matsize 2000

use "`data'", replace

*Create the collapsed dataset for the analysis

drop other_repo*

local dvars "all_r violent_r property_r ill_drugs_r alcohol_r other_r"

matrix drop _all 

foreach var  of varlist `dvars'  {
   forvalues rel_age = 3(1)1460  {
      reg `var' post linear square linear_post square_post birthday_19  birthday_19_1 birthday_20  birthday_20_1 birthday_21  birthday_21_1 birthday_22 birthday_22_1 birthday_23 birthday_23_1 if days_to_21 >= -`rel_age' -1 & days_to_21 <= `rel_age', robust 
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
gen band = results_all_r1/365

*Create the confidence intervals
foreach var  of varlist `dvars'  {
   gen `var'_upper_CI = results_`var'3 + 1.96*results_`var'4
   gen `var'_lower_CI = results_`var'3 - 1.96*results_`var'4
    
}

graph twoway  (line results_all_r3 band, lwidth(medium) lcolor(black)     yscale(range(0,150)) ylabel(#3, nogrid))  ///
			  (line all_r_upper_CI band, lwidth(thin) lcolor(black) clpattern(dot))  ///
			  (line all_r_lower_CI  band, lwidth(thin) lcolor(black) clpattern(dot)) /// 
			  (line results_violent_r3 band, lwidth(medium) lcolor(red)   )  ///
			  (line violent_r_upper_CI band, lwidth(thin) lcolor(red) clpattern(dot))  ///
			  (line violent_r_lower_CI  band, lwidth(thin) lcolor(red) clpattern(dot))  ///
			  (line results_property_r3 band, lwidth(medium) lcolor(green)    )  ///
			  (line property_r_upper_CI band, lwidth(thin) lcolor(green) clpattern(dot))  ///
			  (line property_r_lower_CI  band, lwidth(thin) lcolor(green) clpattern(dot)) /// 
		      (line results_ill_drugs_r3 band, lwidth(medium) lcolor(orange)    )  ///
			  (line ill_drugs_r_upper_CI band, lwidth(thin) lcolor(orange) clpattern(dot))  ///
			  (line ill_drugs_r_lower_CI  band, lwidth(thin) lcolor(orange) clpattern(dot))  ///
		      (line results_alcohol_r3 band, lwidth(medium) lcolor(blue)    )  ///
			  (line alcohol_r_upper_CI band, lwidth(thin) lcolor(blue) clpattern(dot))  ///
			  (line alcohol_r_lower_CI  band, lwidth(thin) lcolor(blue) clpattern(dot)) /// 
		      (line results_other_r3 band, lwidth(medium) lcolor(brown)    )  ///
			  (line other_r_upper_CI band, lwidth(thin) lcolor(brown) clpattern(dot))  ///
			  (line other_r_lower_CI  band, lwidth(thin) lcolor(brown) clpattern(dot))   if band > .3 & band < 3	///		  
              , title("Appendix C: Increase in Arrest Rates by Category")  subtitle("Robustness to Bandwidth Choice") xtitle("Bandwidth") ///
			   ytitle("Increase in Arrest Rates at 21") legend(off) ///
			  text(105 0.1 "All", color(black)) text(20 0.1 "Violent", color(red)) text(8 0.1 "Property", color(green)) ///
			 text(4 0.1 "Drugs", color(orange)) text(42 0.1 "Alcohol",color(blue)) ///
			 text(50 0.1 "Other",color(brown))  /// ///
			 note("Note: The estimates of the increase at age 21 are from a second order quadractic polynomial fully interacted with an indicator" ///
			      "variable for being over 21. The heavy line is the point estimate; the dotted line is the 95% confidence interval.",size(vsmall)) graphregion(style(none) color(gs16))  yline(0, lwidth(vthin) lcolor(black))

cd "`base'"

grexportpdf Appendix_C.pdf 


