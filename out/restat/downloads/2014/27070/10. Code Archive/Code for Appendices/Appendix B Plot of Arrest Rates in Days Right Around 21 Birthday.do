*Appendix B

*These are the new figures with the revised denominators
use "`data'", replace
 
local vars  = "violent_r property_r ill_drugs_r alcohol_r other_r"

#delimit ;
graph twoway (scatter property_r days_to_21, mcolor(black)  msymbol(T)  msize(vsmall)  yscale(range(0,900) axis(1)) ylabel(#1, axis(1))) ///
              (line property_r days_to_21, lwidth(thin) lcolor(black) ) ///
             (scatter ill_drugs_r days_to_21, mcolor(green)  msymbol(Sh)  msize(vsmall) yaxis(2))  ///
		              (line ill_drugs_r days_to_21, lwidth(thin) lcolor(green) yaxis(2)) ///
	         (scatter alcohol_r days_to_21, mcolor(blue)  msymbol(Dh)  msize(vsmall)) ///
			               (line alcohol_r days_to_21, lwidth(thin) lcolor(blue) ) ///
	         (scatter other_r days_to_21, mcolor(brown)  msymbol(Oh)  msize(vsmall))  ///
			               (line other_r days_to_21, lwidth(thin) lcolor(brown) )
						    ///
			 (scatter violent_r days_to_21,  mcolor(red)  msymbol(D)  msize(vsmall)  yaxis(2) yscale(range(0,300) axis(2)) ylabel(#3, axis(2)) ) ///
			               (line violent_r days_to_21, lwidth(thin) lcolor(red)  yaxis(2)) ///
			  if days_to_21 >= -50 & days_to_21 < 50, title("Appendix B: Birthday Effects by Type of Crime") xtitle("Days from 21st Birthday")  ytitle("Property, Alcohol Related & Other") ylabel(#3) ///	
			 ytitle("Violent & Illegal Drugs", axis(2)) legend(off) text(480 30 "Violent", color(red)) text(280 -30 "Property", color(black)) ///
			 text(880 30 "Drug Possession or Sale", color(green)) text(445 -30 "Alcohol Related",color(blue)) ///
			 text(630 -30 "Other",color(brown))   graphregion(style(none) color(gs16)) ///
		     note("Note: Each point is a count of arrests for each crime type for a single day of age relative to the 21st birthday.",size(vsmall))
			 

     ;
#delimit cr
cd "`base'"
grexportpdf Appendix_B.pdf 
