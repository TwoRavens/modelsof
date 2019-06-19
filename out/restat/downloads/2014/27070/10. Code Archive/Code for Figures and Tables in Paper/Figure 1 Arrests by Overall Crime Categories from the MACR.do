*FIGURE 1 
use "`data'", replace

*Create the collapsed dataset for the analysis
gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

local vars  = "violent_r property_r ill_drugs_r alcohol_r other_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 0
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
*To get list of variables to pass to collapse 
ds
local a =  r(varlist)
local b  age_fortnight linear square
local c:list  a - b
disp "`c'"

collapse (mean) `c', by(age_fortnight)

#delimit ;
graph twoway (scatter property_r age_fortnight, mcolor(black)  msymbol(T)  msize(vsmall)  yscale(range(200,600) axis(1)) xlabel(,labsize(medlarge)) ylabel(#1, axis(1) nogrid  labsize(medlarge))) 
             (line property_r_left age_fortnight, lwidth(thin) lcolor(black) ) 
             (line property_r_right age_fortnight, lwidth(thin) lcolor(black) ) 
             (scatter ill_drugs_r age_fortnight, mcolor(green)  msymbol(S)  msize(vsmall) yaxis(2)) 
             (line ill_drugs_r_left age_fortnight, lwidth(thin) lcolor(green) yaxis(2)) 
             (line ill_drugs_r_right age_fortnight, lwidth(thin) lcolor(green) yaxis(2)) 			 
	         (scatter alcohol_r age_fortnight, mcolor(blue)  msymbol(Dh)  msize(vsmall)) 
	         (line alcohol_r_left age_fortnight, lwidth(thin) lcolor(blue) ) 
             (line alcohol_r_right age_fortnight, lwidth(thin) lcolor(blue) ) 		 
	         (scatter other_r age_fortnight, mcolor(brown)  msymbol(O)  msize(vsmall)) 
			 (line other_r_left age_fortnight, lwidth(thin) lcolor(brown) ) 
             (line other_r_right age_fortnight, lwidth(thin) lcolor(brown) ) 	
			 || (scatter violent_r age_fortnight,  mcolor(red)  msymbol(D)  msize(vsmall)  yaxis(2) yscale(range(100,300) axis(2)) ylabel(#3, axis(2) labsize(medlarge)) ) 
             (line violent_r_left age_fortnight, lwidth(thin) lcolor(red)   yaxis(2)) 
             (line violent_r_right age_fortnight, lwidth(thin) lcolor(red)  yaxis(2)) 
             if age_fortnight >= 19 & age_fortnight < 23, 
			 title("Figure 1: Arrest Rates Per 10,000 Person Years",size(medlarge)) 
			 xtitle("Age at Time of Arrest",size(medlarge))  
			 ytitle("Property, Alcohol Related & Other",size(medlarge)) ylabel(#3) 
			 ytitle("Violent & Drug Possession or Sale",size(medlarge) axis(2)) legend(off) 
			 text(340 22 "Violent", color(red) size(medlarge)) 
			 text(240 20 "Property", color(black) size(medlarge)) 
			 text(480 22 "Drug Possession or Sale", color(green) size(medlarge)) 
			 text(415 20 "Alcohol Related",color(blue) size(medlarge)) 
			 text(580 20 "Other",color(brown) size(medlarge))  
             graphregion(style(none) color(gs16))

     ;
#delimit cr

cd "`base'"
grexportpdf figure_1.pdf 			 
