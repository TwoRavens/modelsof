*Load up data file
*Emergency Department Cell Data
use "`base'\Data Files and Code That Produced Them\P03 ED Analysis File", replace

gen pop_all_np =  1 + 0.00104*(months_21/12)
gen pop_m      =  1 + 0.00016718*(months_21/12)
gen pop_f_np   =  1 + 0.00196*(months_21/12)
 
local sufs = "all all_np f f_np m"  
local vars  = "visit  illness injury_or_alc  alcohol_any inj_by_self inj_by_oth inj_accident   "

*Create all fitted lines on either side of RD
foreach suf of local sufs {
   foreach var of local vars {  
     *Fit the left side polynomial;
      reg `var'_`suf'_r age_c age_c_sq  if age_c >= -2 & age_c < 0 [aweight=pop_`suf'], robust
      predict `var'_`suf'_left        if age_c >= -2 & age_c <= 0
     *Fit the right side polynomial;
      reg `var'_`suf'_r age_c age_c_sq  if age_c > 0 & age_c < 2 [aweight=pop_`suf'], robust
      predict `var'_`suf'_right       if age_c >= 0 & age_c < 2
   }
}
  
keep if age_months >= 21 - 2  & age_months < 21 + 2 
 
sum alcohol_any_all_np_r inj_by_self_all_np_r inj_by_oth_all_np_r inj_accident_all_np_r

*Total split into two groups
gen dif = injury_or_alc_all_np_r - (alcohol_any_all_np_r + inj_by_self_all_np_r + inj_by_oth_all_np_r + inj_accident_all_np_r)
sum  dif
drop dif
tab inj_accident_all_np_r
#delimit ;
graph twoway  
 	        (scatter inj_accident_m_r age_months, mcolor(blue)  msymbol(O)  msize(.6) yaxis(1) 
			   yscale(titlegap(2)) 
			   ylabel(0(500)1500, axis(1) nogrid)
			   ) 
			(line inj_accident_m_left age_months, lwidth(thin) lcolor(blue) yaxis(1)) 
            (line inj_accident_m_right age_months, lwidth(thin) lcolor(blue) yaxis(1)) 
			  
	        (scatter alcohol_any_m_r age_months, mcolor(black)  msymbol(D)  msize(.4) yaxis(2) 
			   ylabel(0(70)210, axis(2) nogrid)
			   )
            (line alcohol_any_m_left age_months, lwidth(thin) lcolor(black) yaxis(2)) 
            (line alcohol_any_m_right age_months, lwidth(thin) lcolor(black) yaxis(2)) 

	        (scatter inj_by_self_m_r age_months, mcolor(red)  msymbol(Th)  msize(.8) yaxis(2)) 
            (line inj_by_self_m_left age_months, lwidth(thin) lcolor(red) yaxis(2)) 
            (line inj_by_self_m_right age_months, lwidth(thin) lcolor(red) yaxis(2)) 
			
	        (scatter inj_by_oth_m_r age_months, mcolor(green)  msymbol(Sh)  msize(.8) yaxis(2)) 
            (line inj_by_oth_m_left age_months, lwidth(thin) lcolor(green) yaxis(2)) 
            (line inj_by_oth_m_right age_months, lwidth(thin) lcolor(green) yaxis(2)) 			
             , 
			 title("Appendix 1: Emergency Department Visits by Cause - Male", size(4)) 
			 xtitle("Age at Time of ED Visit")  
			 ytitle("Accidental Injuries",axis(1)) 
			 ytitle("Alcohol Intoxication & Deliberate Injuries", axis(2)) 
			 legend(off) 
			 text(1310 20 "Accidental Injury",color(blue) size(3)) 
			 text( 620 20 "Alcohol Intoxication", color(black) size(3))
			 text( 250 20 "Deliberately Self Inflicted Injury", color(red) size(3)) 
			 text( 1080 20 "Deliberately Injured by Other Person", color(green) size(3)) 
			 note("Note: The points are ED visit rates per 10,000 and the fitted lines are from a second order quadratic polynomial" 
			      "in age estimated separately on either side of the threshold.",size(vsmall)) graphregion(style(none) color(gs16))  
 
      ;
#delimit cr
grexportpdf "`base'\Code for Appendices\Appendix 1.pdf"
