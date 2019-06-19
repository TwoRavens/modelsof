*Appendix H 
use "`data'", replace

*Create the collapsed dataset for the analysis
gen age_fortnight = 21 + (14*floor(days_to_21/14))/365 

local vars  = "cocaine_opio_sale_manuf_r mj_sale_manuf_r dang_non_narc_sale_manuf_r cocaine_opio_posses_r mj_posses_r dang_non_narc_posses_r"

keep  `vars' age_fortnight days_to_21 linear square

foreach var of local vars {  
   reg `var' linear square  if days_to_21 >= -2*364 & days_to_21 < 0
   predict `var'_left if days_to_21 >= -2*365 & days_to_21 <= 0
   reg `var' linear square  if days_to_21 >= 2 & days_to_21 < 2*364
   predict `var'_right if days_to_21 >= 0 & days_to_21 < 2*365
}
*The listing approach runs into length of line issues
collapse (mean)  cocaine_opio_sale_manuf_r mj_sale_manuf_r dang_non_narc_sale_manuf_r cocaine_opio_posses_r mj_posses_r dang_non_narc_posses_r cocaine_opio_sale_manuf_r_right mj_sale_manuf_r_right dang_non_narc_sale_manuf_r_right cocaine_opio_posses_r_right mj_posses_r_right dang_non_narc_posses_r_right cocaine_opio_sale_manuf_r_left mj_sale_manuf_r_left dang_non_narc_sale_manuf_r_left cocaine_opio_posses_r_left mj_posses_r_left dang_non_narc_posses_r_left, by(age_fortnight)



#delimit ;
graph twoway (scatter cocaine_opio_sale_manuf_r age_fortnight,  mcolor(black)  msymbol(D)  msize(tiny)  ylabel(#3, nogrid)) ///
             (line cocaine_opio_sale_manuf_r_left age_fortnight, lwidth(thin) lcolor(black)  ) ///
             (line cocaine_opio_sale_manuf_r_right age_fortnight, lwidth(thin) lcolor(black) ) ///
             (scatter mj_sale_manuf_r age_fortnight, mcolor(red)  msymbol(T)  msize(tiny)) ///
             (line mj_sale_manuf_r_left age_fortnight, lwidth(thin) lcolor(red) ) ///
             (line mj_sale_manuf_r_right age_fortnight, lwidth(thin) lcolor(red) ) ///
             (scatter dang_non_narc_sale_manuf_r age_fortnight, mcolor(green)  msymbol(S)  msize(tiny)) ///
             (line dang_non_narc_sale_manuf_r_left age_fortnight, lwidth(thin) lcolor(green) ) ///
             (line dang_non_narc_sale_manuf_r_right age_fortnight, lwidth(thin) lcolor(green) ) ///			 
	         (scatter cocaine_opio_posses_r age_fortnight, mcolor(blue)  msymbol(Dh)  msize(tiny)) ///
	         (line cocaine_opio_posses_r_left age_fortnight, lwidth(thin) lcolor(blue) ) ///
             (line cocaine_opio_posses_r_right age_fortnight, lwidth(thin) lcolor(blue) ) ///		
	         (scatter mj_posses_r age_fortnight, mcolor(orange)  msymbol(Dh)  msize(tiny)) ///
	         (line mj_posses_r_left age_fortnight, lwidth(thin) lcolor(orange) ) ///
             (line mj_posses_r_right age_fortnight, lwidth(thin) lcolor(orange) ) ///	
	         (scatter dang_non_narc_posses_r age_fortnight, mcolor(brown)  msymbol(Dh)  msize(tiny)) ///
	         (line dang_non_narc_posses_r_left age_fortnight, lwidth(thin) lcolor(brown) ) ///
             (line dang_non_narc_posses_r_right age_fortnight, lwidth(thin) lcolor(brown) ) ///	
              if age_fortnight >= 19 & age_fortnight < 23, title("Appendix H: Arrest Rates for Drug Possession or Sale") xtitle("Age at Time of Arrest")  ytitle("Arrest Rates") ylabel(#4)  legend(off) ///
			  text(30 19.8 "Cocaine/Opium (Sale or Manufacture)", color(black) size(small)) ///
			  text(22 19.8 "Marijuana (Sale or Manufacture)", color(red) size(small)) ///
			  text(5 20.5 "Other Dangerous Nonnarcotic (Sale or Manufacture)",color(green) size(small)) ///
			  text(75 19.8 "Cocaine/Opium (Possession)", color(blue) size(small))  ///
			  text(60 21 "Marijuana (Possession)", color(orange) size(small))  ///
			  text(48 19.9 "Other Dangerous Nonnarcotic (Possession)", color(brown) size(small))  ///
			  note("Note: The points are average arrest rates for 14 day cells and the fitted lines are from a second order quadractic polynomial" ///
			  "in age estimated seperately on either side of age 21 threshold. For codes that make up categories see web Appendix A.",size(vsmall)) graphregion(style(none) color(gs16))  

     ;
#delimit cr

cd "`base'"

grexportpdf Appendix_H.pdf 
