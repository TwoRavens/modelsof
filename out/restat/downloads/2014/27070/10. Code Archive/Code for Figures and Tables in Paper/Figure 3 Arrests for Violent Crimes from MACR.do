*FIGURE 3

use "`data'", replace

*Create the collapsed dataset for the analysis
gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

local vars  = "murder_r manslaughter_r rape_r robbery_r aggravated_assault_r ot_assault_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 0
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
 
collapse (mean) murder_r manslaughter_r rape_r robbery_r aggravated_assault_r ot_assault_r murder_r_left manslaughter_r_left rape_r_left robbery_r_left aggravated_assault_r_left ot_assault_r_left murder_r_right manslaughter_r_right rape_r_right robbery_r_right aggravated_assault_r_right ot_assault_r_right linear square , by(age_fortnight)

#delimit ;
graph twoway (scatter robbery_r age_fortnight, mcolor(green)  msymbol(O)  msize(vsmall) yaxis(1)) 
	         (line robbery_r_left age_fortnight, lwidth(thin) lcolor(green) ) 
             (line robbery_r_right age_fortnight, lwidth(thin) lcolor(green) ) 	
		     (scatter murder_r age_fortnight,  mcolor(red)  msymbol(D)  msize(vsmall) yaxis(2)) 
             (line murder_r_left age_fortnight, lwidth(thin) lcolor(red) yaxis(2) ) 
             (line murder_r_right age_fortnight, lwidth(thin) lcolor(red) yaxis(2)) 
             (scatter manslaughter_r age_fortnight, mcolor(black)  msymbol(T)  msize(vsmall) yaxis(2)) 
             (line manslaughter_r_left age_fortnight, lwidth(thin) lcolor(black) yaxis(2)) 
             (line manslaughter_r_right age_fortnight, lwidth(thin) lcolor(black) yaxis(2)) 
             (scatter rape_r age_fortnight, mcolor(brown)  msymbol(Sh)  msize(vsmall) yaxis(2)) 
             (line rape_r_left age_fortnight, lwidth(medium) lcolor(brown) yaxis(2)) 
             (line rape_r_right age_fortnight, lwidth(medium) lcolor(brown) yaxis(2)) 			 
	         (scatter aggravated_assault_r age_fortnight, mcolor(blue)  msymbol(Dh)  msize(vsmall)) 
		 	 (line aggravated_assault_r_left age_fortnight, lwidth(thin) lcolor(blue) ) 
             (line aggravated_assault_r_right age_fortnight, lwidth(thin) lcolor(blue) ) 	
	         (scatter ot_assault_r age_fortnight, mcolor(gray)  msymbol(Th)  msize(vsmall)) 
			 (line ot_assault_r_left age_fortnight, lwidth(thin) lcolor(gray) ) 
             (line ot_assault_r_right age_fortnight, lwidth(thin) lcolor(gray) ) 	
             if age_fortnight >= 19 & age_fortnight < 23, 
			 title("Figure 3: Arrest Rates for Violent Crimes",size(medlarge)) 
			 xtitle("Age at Time of Arrest",size(medlarge))  
			 ytitle("Robbery & Assault",size(medlarge))   
             ylabel(0(40)80, axis(1) nogrid )
			 ylabel(0(10)20, axis(2)) 
			 ytitle("Murder, Manslaughter & Rape",axis(2) size(medlarge))
			 legend(off) 
			 text(8.5 21.7 "Murder", color(red) size(medlarge)) 
			 text(5 22.4 "Manslaughter", color(black) size(medlarge)) 
			 text(19 22 "Rape", color(brown) size(medlarge)) 
			 text(34 20 "Robbery",color(green) size(medlarge)) 
			 text(70 19.8 "Aggravated Assault", color(blue) size(medlarge)) 
			 text(50 20 "Other Assault",color(gray) size(medlarge)) 
             graphregion(style(none) color(gs16))  
     ;
#delimit cr

cd "`base'"
grexportpdf figure_3.pdf 

 
