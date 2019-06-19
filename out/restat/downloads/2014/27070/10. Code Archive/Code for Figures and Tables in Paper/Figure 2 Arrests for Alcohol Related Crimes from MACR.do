*FIGURE 2  

use "`data'", replace

*Create the collapsed dataset for the analysis
gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

generate combined_oth_r =  disorderly_cond_r + vagrancy_r
generate drunk_risk_r = drunk_at_risk_r + drunkeness_pc_r
local vars  = "dui_r liquor_laws_r drunk_risk_r combined_oth_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 0
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
 
collapse (mean) dui_r liquor_laws_r drunk_risk_r combined_oth_r dui_r_left liquor_laws_r_left drunk_risk_r_left combined_oth_r_left dui_r_right liquor_laws_r_right drunk_risk_r_right combined_oth_r_right , by(age_fortnight)

#delimit ;
graph twoway (scatter drunk_risk_r age_fortnight,  mcolor(red)  msymbol(D)  msize(vsmall)) 
             (line drunk_risk_r_left age_fortnight, lwidth(thin) lcolor(red)  ) 
             (line drunk_risk_r_right age_fortnight, lwidth(thin) lcolor(red) ) 
             (scatter dui_r age_fortnight, mcolor(black)  msymbol(T)  msize(vsmall)) 
             (line dui_r_left age_fortnight, lwidth(thin) lcolor(black) ) 
             (line dui_r_right age_fortnight, lwidth(thin) lcolor(black) ) 
             (scatter liquor_laws_r age_fortnight, mcolor(green)  msymbol(S)  msize(vsmall)) 
             (line liquor_laws_r_left age_fortnight, lwidth(medium) lcolor(green) lpattern(dash)) 
             (line liquor_laws_r_right age_fortnight, lwidth(medium) lcolor(green) lpattern(dash) ) 			 
	         (scatter combined_oth_r age_fortnight, mcolor(blue)  msymbol(Dh)  msize(vsmall)) 
	         (line combined_oth_r_left age_fortnight, lwidth(thin) lcolor(blue) lpattern(solid)) 
             (line combined_oth_r_right age_fortnight, lwidth(thin) lcolor(blue) lpattern(solid)) 		 
             if age_fortnight >= 19 & age_fortnight < 23, 
			 title("Figure 2: Arrest Rates for Alcohol Related Crimes",size(medlarge)) 
			 xtitle("Age at Time of Arrest",size(medlarge))  
			 ytitle("Arrest Rates",size(medlarge)) ylabel(#4 , nogrid) 
			 legend(off)  
			 text(195 19.8 "Driving Under the Influence", color(black) size(medlarge)) 
			 text(130 19.8 "Liquor Laws", color(green) size(medlarge)) 
			 text(150 22 "Drunkenness",color(red) size(medlarge)) 
			 text(30 20.1 "Disorderly Conduct or Vagrancy", color(blue) size(medlarge))  
             graphregion(style(none) color(gs16))  				  
     ;
#delimit cr

cd "`base'"
grexportpdf figure_2.pdf 

 
