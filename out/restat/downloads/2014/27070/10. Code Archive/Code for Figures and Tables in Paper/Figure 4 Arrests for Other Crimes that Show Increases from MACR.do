*FIGURE 4  

use "`data'", replace

*Create the collapsed dataset for the analysis
gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

local vars  = "weapons_r county_ordinance_r traffic_violations_r hit_run_reckl_driv_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 0
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
*The listing approach runs into length of line issues
collapse (mean) weapons_r county_ordinance_r traffic_violations_r hit_run_reckl_driv_r weapons_r_left county_ordinance_r_left traffic_violations_r_left hit_run_reckl_driv_r_left weapons_r_right county_ordinance_r_right traffic_violations_r_right hit_run_reckl_driv_r_right linear square , by(age_fortnight)

#delimit ;
graph twoway (scatter county_ordinance_r age_fortnight, mcolor(black)  msymbol(T)  msize(vsmall)) 
             (line county_ordinance_r_left age_fortnight, lwidth(thin) lcolor(black) ) 
             (line county_ordinance_r_right age_fortnight, lwidth(thin) lcolor(black) ) 
             (scatter weapons_r age_fortnight , mcolor(red)  msymbol(D)  msize(vsmall) yaxis(2)) 
             (line weapons_r_left age_fortnight, lwidth(medium) lcolor(red) yaxis(2) lpattern(shortdash) ) 
             (line weapons_r_right age_fortnight, lwidth(medium) lcolor(red) yaxis(2) lpattern(shortdash)) 
             (scatter traffic_violations_r age_fortnight, mcolor(green)  msymbol(Dh)  msize(vsmall)) 
             (line traffic_violations_r_left age_fortnight, lwidth(thin) lcolor(green) ) 
             (line traffic_violations_r_right age_fortnight, lwidth(thin) lcolor(green) ) 			 
	         (scatter hit_run_reckl_driv_r age_fortnight, mcolor(blue)  msymbol(Sh)  msize(vsmall) yaxis(2)) 
	         (line hit_run_reckl_driv_r_left age_fortnight, lwidth(thin) lcolor(blue) yaxis(2)) 
             (line hit_run_reckl_driv_r_right age_fortnight, lwidth(thin) lcolor(blue) yaxis(2)) 		 
             if age_fortnight >= 19 & age_fortnight < 23, 
			 title("Figure 4: Arrest Rates for Other Crimes That Show Increases",size(medlarge)) 
			 xtitle("Age at Time of Arrest",size(medlarge))  
			 ytitle("Traffic Violations & County Ordinances",size(medlarge)) 
			 ylabel(0(70)140, axis(1) nogrid) 
			 ylabel(0(21)42, axis(2)) 
			 ytitle("Weapons & Hit and Run/Reckless Driving", axis(2) size(medlarge)) 
			 legend(off) 
			 text(114 22 "Weapons: Carrying/Possessing", color(red) size(medlarge)) 
			 text(62 19.8 "County Ordinance", color(black) size(medlarge)) 
			 text(130 20.3 "Traffic Violations", color(green) size(medlarge)) 
			 text(90 20.3 "Hit and Run",color(blue) size(medlarge)) 
             graphregion(style(none) color(gs16))  
			 
     ;
#delimit cr

cd "`base'"
grexportpdf figure_4.pdf


