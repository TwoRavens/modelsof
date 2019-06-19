*APPENDIX K
use "`data'", replace

*Create the collapsed dataset for the analysis
gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

local vars  = "murder_r manslaughter_r rape_r robbery_r aggravated_assault_r ot_assault_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 2*365
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
*The listing approach runs into length of line issues
collapse (mean) murder_r manslaughter_r rape_r robbery_r aggravated_assault_r ot_assault_r murder_r_left manslaughter_r_left rape_r_left robbery_r_left aggravated_assault_r_left ot_assault_r_left murder_r_right manslaughter_r_right rape_r_right robbery_r_right aggravated_assault_r_right ot_assault_r_right linear square , by(age_fortnight)

graph twoway  (scatter aggravated_assault_r age_fortnight, mcolor(blue)  msymbol(Dh)  msize(tiny) ylabel(#3, nogrid)) ///
		 	 (line aggravated_assault_r_left age_fortnight, lwidth(thin) lcolor(blue) ) ///
              (line aggravated_assault_r_right age_fortnight, lwidth(thin) lcolor(blue) ) ///	
	         (scatter ot_assault_r age_fortnight, mcolor(gold)  msymbol(Th)  msize(tiny)) ///
			 (line ot_assault_r_left age_fortnight, lwidth(thin) lcolor(gold) ) ///
              (line ot_assault_r_right age_fortnight, lwidth(thin) lcolor(gold) ) ///	
              if age_fortnight >= 19 & age_fortnight < 23, title("Appendix K: Persistence of Effects") xtitle("Age at Time of Arrest")  ytitle("Arrest Rates")  ///
			  yscale(range(40,80) axis(1)) ylabel(#1, axis(1))   legend(off) ///
			 text(67 19.8 "Aggravated Assault", color(blue)) text(59 20 "Assault Other",color(gold)) ///
             graphregion(style(none) color(gs16)) ///
			 note("Note: The projection of the counterfactual is based on a second order polynomial fitted to the arrest rates of those under 21.",size(vsmall)) 
			 
cd "`base'"

			 
grexportpdf Appendix_K.pdf 
