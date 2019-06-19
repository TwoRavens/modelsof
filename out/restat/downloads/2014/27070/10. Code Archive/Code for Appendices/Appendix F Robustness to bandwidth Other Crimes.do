*APPENDIX F

drop _all
set matsize 2000
use "`data'", replace

local dvars  = "traffic_violations_r county_ordinance_r weapons_r   hit_run_reckl_driv_r"
	 
matrix drop _all 

foreach var  of varlist `dvars'  {
   forvalues rel_age = 3(1)1460 {
      qui reg `var' post linear square linear_post square_post birthday_19  birthday_19_1 birthday_20  birthday_20_1 birthday_21  birthday_21_1 birthday_22 birthday_22_1 birthday_23 birthday_23_1 if days_to_21 >= -`rel_age' -1 & days_to_21 <= `rel_age', robust 
     *Get number of obs and write to local N
      local N = e(N)
     *Write out the betas as a matrix on a row
      matrix eb = e(b)
     *matrix list eb
     *Write out the variances as a row
      matrix se = vecdiag(e(V))
     *matrix list eb
     *Write out the variance for just the post variable it is the first as it is the first listed in the reg command	 
      matrix res = (`rel_age',`N',eb[1,1],sqrt(se[1,1]))
     *matrix list res
      matrix results_`var' = (nullmat(results_`var') \ res)
   }
   matrix list results_`var' 
   svmat results_`var' 
}


*Create the confidence intervals
foreach var  of varlist `dvars'  {
   gen `var'_upper_CI = results_`var'3 + 1.96*results_`var'4
   gen `var'_lower_CI = results_`var'3 - 1.96*results_`var'4
}

*List variables for the figure
local var1   "traffic_violations_r"
local var2   "county_ordinance_r"
local var3   "weapons_r"
local var4   "hit_run_reckl_driv_r"


 
*Generate teh bandwidth variable
gen band = results_`var1'1/365

 
graph twoway  (line results_`var1'3 band, lwidth(medium) lcolor(black)     yscale(range(0,10)) ylabel(#3, nogrid))  ///
			  (line `var1'_upper_CI band, lwidth(thin) lcolor(black) clpattern(dot))  ///
			  (line `var1'_lower_CI  band, lwidth(thin) lcolor(black) clpattern(dot)) /// 
			  (line results_`var2'3 band, lwidth(medium) lcolor(red)   )  ///
			  (line `var2'_upper_CI band, lwidth(thin) lcolor(red) clpattern(dot))  ///
			  (line `var2'_lower_CI  band, lwidth(thin) lcolor(red) clpattern(dot))  ///
			  (line results_`var3'3 band, lwidth(medium) lcolor(green)    )  ///
			  (line `var3'_upper_CI band, lwidth(thin) lcolor(green) clpattern(dot))  ///
			  (line `var3'_lower_CI  band, lwidth(thin) lcolor(green) clpattern(dot)) /// 
		      (line results_`var4'3 band, lwidth(medium) lcolor(blue)    )  ///
			  (line `var4'_upper_CI band, lwidth(thin) lcolor(blue) clpattern(dot))  ///
			  (line `var4'_lower_CI  band, lwidth(thin) lcolor(blue) clpattern(dot))  ///
			  if band > .3 & band < 3	///		  
              , title("Appendix F: Arrest Rates for Other Crimes")  subtitle("Robustness to Bandwidth Choice") xtitle("Bandwidth") ///
			   ytitle("Increase in Arrest Rates at 21") legend(off) ///
			  text(5 0.15 "Traffic" "Violations", color(black) size(small)) ///
			  text(24 0.15 "County" "Ordinance", color(red) size(small)) ///
			  text(.6 0.15 "Weapons", color(green) size(small)) ///
			  text(2 0.15 "Hit and Run", color(blue) size(small)) ///
	 	 	  note("Note: The estimates of the increase at age 21 are from a second order quadractic polynomial fully interacted with an indicator" ///
			       "variable for being over 21. The heavy line is the point estimate; the dotted line is the 95% confidence interval.",size(vsmall)) graphregion(style(none) color(gs16))  yline(0, lwidth(vthin) lcolor(black))

cd "`base'"

grexportpdf Appendix_F.pdf 
