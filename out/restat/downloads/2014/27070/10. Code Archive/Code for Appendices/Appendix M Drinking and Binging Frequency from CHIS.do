*APPENDIX M

insheet using "`data_CHIS'", comma clear   

gen age_sq = age*age

gen propdaysdank_p = 100*propdaysdank
gen propdaysbinged_p = 100*propdaysbinged

local vars  = "propdaysdank_p propdaysbinged_p"

foreach var of local vars {  
   reg `var' age age_sq  if age < 21
   predict `var'_left if age <= 21
   reg `var' age age_sq  if age >= 21
   predict `var'_right if age >= 21
}


			  

graph twoway  (scatter propdaysdank_p age, mcolor(black)  msymbol(T)  msize(tiny)  yscale(range(0,20)) ylabel(#3, nogrid )) ///
              (line propdaysdank_p_left age, lwidth(thin) lcolor(black) ) ///
              (line propdaysdank_p_right age, lwidth(thin) lcolor(black) ) ///
             (scatter propdaysbinged_p age, mcolor(red)  msymbol(S)  msize(tiny)) ///
              (line propdaysbinged_p_left age, lwidth(thin) lcolor(red)) ///
              (line propdaysbinged_p_right age, lwidth(thin) lcolor(red))  ///			 
               , title("Appendix M: Percent of Days Drinking and Binge Drinking") xtitle("Age on Day of Survey") ///
			   ytitle("Percent of Days in Last Month")  ///
			 legend(off) text(17 22 "Drinking", color(black)) text(7 22 "Binge Drinking", color(red)) ///
			 note("Note: From California Health Interview Survey 2001-2005. The points are averages for 30 day cells and the fitted lines are" ///
			      "from a second order quadractic polynomial in age estimated seperately on either side of age 21 threshold.",size(vsmall)) graphregion(style(none) color(gs16))  

cd "`base'"
grexportpdf Appendix_M.pdf 
