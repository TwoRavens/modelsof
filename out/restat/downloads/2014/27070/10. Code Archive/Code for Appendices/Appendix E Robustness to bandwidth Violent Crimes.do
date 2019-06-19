*APPENDIX E

drop _all
set matsize 2000
use "`data'", replace

local dvars  = "murder_r manslaughter_r rape_r robbery_r aggravated_assault_r ot_assault_r"
	 
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
local var1   "murder_r"
local var2   "manslaughter_r"
local var3   "rape_r"
local var4   "robbery_r"
local var5   "aggravated_assault_r"
local var6   "ot_assault_r"

 
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
		      (line results_`var4'3 band, lwidth(medium) lcolor(orange)    )  ///
			  (line `var4'_upper_CI band, lwidth(thin) lcolor(orange) clpattern(dot))  ///
			  (line `var4'_lower_CI  band, lwidth(thin) lcolor(orange) clpattern(dot))  ///
			  (line results_`var5'3 band, lwidth(medium) lcolor(blue)    )  ///
			  (line `var5'_upper_CI band, lwidth(thin) lcolor(blue) clpattern(dot))  ///
			  (line `var5'_lower_CI  band, lwidth(thin) lcolor(blue) clpattern(dot))  ///  
			  (line results_`var6'3 band, lwidth(medium) lcolor(brown)    )  ///
			  (line `var6'_upper_CI band, lwidth(thin) lcolor(brown) clpattern(dot))  ///
			  (line `var6'_lower_CI  band, lwidth(thin) lcolor(brown) clpattern(dot))  ///
			  if band > .3 & band < 3	///		  
              , title("Appendix E: Arrest Rates for Violent Crimes")  subtitle("Robustness to Bandwidth Choice") xtitle("Bandwidth") ///
			   ytitle("Increase in Arrest Rates at 21") legend(off) ///
			  text(1 0.1 "Murder", color(black) size(small)) ///
			  text(-.5 0.2 "Manslaughter", color(red) size(small)) ///
			  text(0 0.1 "Rape", color(green) size(small)) ///
			  text(3.7 0.1 "Robbery", color(orange) size(small)) ///
			  text(6.5 0.15 "Aggravated ", color(blue) size(small)) ///
			  text(6.0 0.15 "Assault", color(blue) size(small)) ///
			  text(5.4 0.15 "Other", color(brown) size(small)) ///
			  text(4.9 0.15 "Assault", color(brown) size(small)) ///
	 	 	  note("Note: The estimates of the increase at age 21 are from a second order quadractic polynomial fully interacted with an indicator" ///
			       "variable for being over 21. The heavy line is the point estimate; the dotted line is the 95% confidence interval.",size(vsmall)) graphregion(style(none) color(gs16))  yline(0, lwidth(vthin) lcolor(black))

cd "`base'"

grexportpdf Appendix_E.pdf 
