*Appendix G
use "`data'", replace

gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

local vars  = "burglary_r larceny_r mv_theft_r stolen_prop_buy_rec_poss_r vandalism_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 0
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
*The listing approach runs into length of line issues
collapse (mean) burglary_r larceny_r mv_theft_r stolen_prop_buy_rec_poss_r vandalism_r burglary_r_left larceny_r_left mv_theft_r_left stolen_prop_buy_rec_poss_r_left vandalism_r_left burglary_r_right larceny_r_right mv_theft_r_right stolen_prop_buy_rec_poss_r_right vandalism_r_right, by(age_fortnight)

#delimit ;
graph twoway (scatter burglary_r age_fortnight,  mcolor(black)  msymbol(D)  msize(tiny)  ylabel(#3, nogrid)) 
             (line burglary_r_left age_fortnight, lwidth(thin) lcolor(black)  ) 
             (line burglary_r_right age_fortnight, lwidth(thin) lcolor(black) ) 
             (scatter larceny_r age_fortnight, mcolor(red)  msymbol(T)  msize(tiny)) 
             (line larceny_r_left age_fortnight, lwidth(thin) lcolor(red) ) 
             (line larceny_r_right age_fortnight, lwidth(thin) lcolor(red) ) 
             (scatter mv_theft_r age_fortnight, mcolor(green)  msymbol(S)  msize(tiny)) 
             (line mv_theft_r_left age_fortnight, lwidth(thin) lcolor(green) ) 
             (line mv_theft_r_right age_fortnight, lwidth(thin) lcolor(green) ) 			 
	         (scatter stolen_prop_buy_rec_poss_r age_fortnight, mcolor(blue)  msymbol(Dh)  msize(tiny)) 
	         (line stolen_prop_buy_rec_poss_r_left age_fortnight, lwidth(thin) lcolor(blue) ) 
             (line stolen_prop_buy_rec_poss_r_right age_fortnight, lwidth(thin) lcolor(blue) ) 		
	         (scatter vandalism_r age_fortnight, mcolor(orange)  msymbol(Dh)  msize(tiny)) 
	         (line vandalism_r_left age_fortnight, lwidth(thin) lcolor(orange) ) 
             (line vandalism_r_right age_fortnight, lwidth(thin) lcolor(orange) ) 	
              if age_fortnight >= 19 & age_fortnight < 23, title("Appendix G: Arrest Rates for Property Crimes") xtitle("Age at Time of Arrest")  ytitle("Arrest Rates") ylabel(#4)  legend(off) 
			  text(80 19.8 "Burglary", color(black)) 
			  text(125 19.8 "Larceny", color(red)) 
			  text(50 19.8 "Motor Vehicle Theft",color(green)) 
			  text(30 19.8 "Stolen Property", color(blue))  
			  text(15 19.8 "Vandalism", color(orange))  
			  note("Note: The points are average arrest rates for 14 day cells and the fitted lines are from a second order quadractic polynomial" 
			  "in age estimated seperately on either side of age 21 threshold. For codes that make up categories see web Appendix A.",size(vsmall)) graphregion(style(none) color(gs16))  

     ;
#delimit cr

cd "`base'"

grexportpdf Appendix_G.pdf 
