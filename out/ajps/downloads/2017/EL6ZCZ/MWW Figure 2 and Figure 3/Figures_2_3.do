* Date: February 17, 2016
* Apply to: mww_1.dta
* Description:  Graphs for Figures 2 and 3 of Making Washington Work

clear

set more off


* Open main MWW dataset

use "C:\MWW_Combined\1605 AJPS\Main\mww_1.dta", clear


* Generate Non-Invalid Pensions private bills

gen priv_ninv = private - invpens


* Generate Commerce, Rivers & Harbors, Public Buildings local bills

gen local_three = internal + publdgs


* Generate member index

gen add = 1


* Collapse bill totals to congress observations

sort congress icpsrno

collapse (sum) hse_terms private priv_ninv local local_three policy add ///
	 , by(congress)


* Generate bill introduction totals (hundreds)

gen local_hun = local / 100

gen local_three_hun = local_three / 100

gen policy_hun = policy / 100


* Generate average bill introduction totals

gen priv_ninv_ave = priv_ninv / add

gen local_ave = local / add

gen local_three_ave = local_three / add

gen policy_ave = policy / add


* Generate average tenure

gen hse_terms_ave = hse_terms / add


tset congress


* Figure 2: Local and Policy Bills -- Black and White

tsline local_hun, ///
     clcolor(black) clpattern(solid) || ///
     (scatter local_hun congress, mcolor(black) msymbol(t) msize(large)) || ///
	 tsline policy_hun, ///
     clcolor(black) clpattern(solid) || ///
     (scatter policy_hun congress, mcolor(black) msymbol(s) msize(large)) || ///
	 tsline local_three_hun, ///
     clcolor(black) clpattern(dash) || ///
     (scatter local_three_hun congress, mcolor(black) msymbol(O) msize(large)), ///
	 xlabel(47(2)71) xtitle(" " "{bf:Congress}") ///
	 ylabel(0(6)31) ///
	 ytitle("{bf:Bill Introductions (Hundreds)}" " ") ///
	 text(23 61.5 "{bf:Local}", color(black) size(medium)) ///
	 text(20 61.5 "{bf:(Commerce,}" "{bf:Public Buildings,}" "{bf:Rivers and Harbors)}", color(black) size(small)) ///
	 text(17.5 61.5 "{bf:|}", color(black) size(small)) ///
	 text(21 51 "{bf:Local}", color(black) size(medium)) ///
	 text(19 51 "{bf:(All)}", color(black) size(small)) ///
	 text(7 67 "{bf:Policy}", color(black) size(medium)) ///
	 legend(off) plotregion(margin(zero) color(white)) graphregion(color(white))

graph export "C:\MWW_Combined\1605 AJPS\MWW Figure 2 and Figure 3\Fig_2_local_policy.wmf", replace


* Figure 3: Private, Local and Policy Bills (Average) -- Black and White

tsline local_ave, ///
     yaxis(1) clcolor(black) clpattern(solid) || ///
     (scatter local_ave congress, yaxis(1) mcolor(black) msymbol(t) msize(large)) || ///
	 tsline policy_ave, ///
     clcolor(black) yaxis(1) clpattern(solid) || ///
     (scatter policy_ave congress, yaxis(1) mcolor(black) msymbol(s) msize(large)) || ///
	 tsline priv_ninv_ave, ///
     yaxis(1) clcolor(black) clpattern(solid) || ///
     (scatter priv_ninv_ave congress, yaxis(1) mcolor(black) msymbol(O) msize(large)) || ///
     tsline hse_terms_ave, yaxis(2) clcolor(black) clpattern(dash) clwidth(thick) ///
	 xlabel(47(2)71) xtitle(" " "{bf:Congress}") ///
     ylabel(0(5)25, axis(1)) ylabel(1(1)5, axis(2)) ///
     ylabel(0(5)25) ///
	 ytitle("{bf:Bills per Member}" " ", size(medium) axis(1)) ///
	 ytitle(" " "{bf:Terms per Member}", size(medium) axis(2)) ///
	 text(23 52 "{bf:Private}", color(black) size(medium)) ///
	 text(21.5 52 "{bf:(Non-Invalid Pensions)}", color(black) size(small)) ///
	 text(7 51 "{bf:Local}", color(black) size(medium)) ///
	 text(1.2 62 "{bf:Policy}", color(black) size(medium)) ///
	 text(13 60.5 "{bf:Tenure}", color(black) size(medium)) ///
	 legend(off) plotregion(margin(zero) color(white)) graphregion(color(white))

graph export "C:\MWW_Combined\1605 AJPS\MWW Figure 2 and Figure 3\Fig_3_pri_loc_pol_ten.wmf", replace

* End
