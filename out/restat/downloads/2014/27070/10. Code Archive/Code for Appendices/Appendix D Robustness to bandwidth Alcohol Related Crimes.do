*APPENDIX D Robustness to bandwidth for results for Aclohol Related crimes

drop _all
set matsize 2000
use "`data'", replace

generate drunk_risk_r = drunk_at_risk_r + drunkeness_pc_r
generate combined_oth_r =  disorderly_cond_r + vagrancy_r

local dvars "drunk_risk_r dui_r  liquor_laws_r combined_oth_r"

display 	"`dvars' "
	 
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
local var1   "dui_r"
local var2   "drunk_risk_r"
local var3   "liquor_laws_r"
local var4   "combined_oth_r"

*Generate the bandwidth variable
gen band = results_`var1'1/365

 
graph twoway  (line results_`var1'3 band, lwidth(medium) lcolor(black)     yscale(range(0,100)) ylabel(#3, nogrid))  ///
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
			  if band > .3 & band < 3	///		  
              , title("Appendix D: Arrest Rates for Alcohol Related Crimes")  subtitle("Robustness to Bandwidth Choice") xtitle("Bandwidth") ///
			   ytitle("Increase in Arrest Rates at 21") legend(off) ///
			  text(55 0.1 "DUI", color(black)) ///
			  text(25 0.3 "Drunkeness", color(red)) ///
			  text(-45 0.3 "Liquor Laws", color(green)) ///
			  text(8 0.1 "Other", color(orange)) ///
	 		 note("Note: The estimates of the increase at age 21 are from a second order quadractic polynomial fully interacted with an indicator" ///
			      "variable for being over 21. The heavy line is the point estimate; the dotted line is the 95% confidence interval.",size(vsmall)) graphregion(style(none) color(gs16))  yline(0, lwidth(vthin) lcolor(black))


cd "`base'"

grexportpdf Appendix_D.pdf 
