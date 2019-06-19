*APPENDIX L

insheet using "`data_CHIS'", comma clear   

gen age_sq = age*age

gen dranklm_p = 100*dranklm
gen bingedlm_p = 100*bingedlm

local vars  = "dranklm_p bingedlm_p"

foreach var of local vars {  
   reg `var' age age_sq  if age < 21
   predict `var'_left if age <= 21
   reg `var' age age_sq  if age >= 21
   predict `var'_right if age >= 21
}

graph twoway  (scatter dranklm_p age, mcolor(black)  msymbol(T)  msize(tiny)  yscale(range(0,1)) ylabel(#3 , nogrid)) ///
              (line dranklm_p_left age, lwidth(thin) lcolor(black) ) ///
              (line dranklm_p_right age, lwidth(thin) lcolor(black) ) ///
             (scatter bingedlm_p age, mcolor(red)  msymbol(S)  msize(tiny)) ///
              (line bingedlm_p_left age, lwidth(thin) lcolor(red)) ///
              (line bingedlm_p_right age, lwidth(thin) lcolor(red))  ///			 
               , title("Appendix L: Drinking and Binge Drinking in the Past Month") xtitle("Age on Day of Survey") ///
			   ytitle("Percent Participating")  ///
			 legend(off) text(80 22 "Drinking", color(black)) text(45 22 "Binge Drinking", color(red)) ///
			 note("Note: From California Health Interview Survey 2001-2005. The points are averages for 30 day cells and the fitted lines are" ///
			      "from a second order quadractic polynomial in age estimated seperately on either side of age 21 threshold.",size(vsmall)) graphregion(style(none) color(gs16))  

cd "`base'"
grexportpdf Appendix_L.pdf 

