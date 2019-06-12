
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      austria.do                                      * 
*       Date:           April 5, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	Performs basic recoding of variables            * 
*                       and analysis of Austrian data                   *
* 	    Input File:                                                     * 
*       Data Output:                                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 




set more off
version 15.1
set mem 100m




/* 
AUTNES PRE-POST 
Panel Study 2013
*/

use "ZA5859_en_v2-0-1.dta", clear


*** expected voteshare not included - replaced with actual election results 2013
*** However, this does probably make not much sense
gen v_spoe = 26.82
gen v_oevp = 23.99
gen v_fpoe = 20.51
gen v_green = 12.42



*** Left-right self-placement
recode w1_q11x* w1_q12 (88=.) (99=.) (77=.)
gen lr_self = w1_q12
gen centrist_self = abs(lr_self - 5)


*** Left-right party positions
gen lr_spoe=w1_q11x1
gen lr_oevp=w1_q11x2
gen lr_fpoe=w1_q11x3
gen lr_green=w1_q11x5




**************************
* Ideological Centrality *
**************************

* the degree to which a party is perceived in the idiological center
foreach i in oevp spoe fpoe green {
	gen center_`i'= 5-abs(lr_`i' -5)
	label var center_`i' "ideological centrality `i'"
	label var lr_`i' "left/right party placement of `i'"
	}
	
	
	* Ideological centrality
gen center_so = center_spoe - center_oevp
gen center_of = center_oevp - center_fpoe
gen center_sb = center_spoe - center_green
gen center_sf = center_spoe - center_fpoe




*** Political Knowledge
* AGE OF ELIGIBILITY    
*gen know1 = (w1_q77==4)
* WHO APPOINTS THE CHANCELLOR?
gen know2 = (w1_q79==1)
* WHY SHALL PEOPLE BE ALLOWED TO SEE DOCUMENTS?
gen know3 = (w1_q80==1)
* WHICH PARTY MARIA FEKTER
gen know4 = (w1_q81x1==2)
* WHICH PARTY ALOIS STOEGER
gen know5 = (w1_q81x2==1)
* WHICH PARTY RUDOLF HUNDSTORFER
gen know6 = (w1_q81x3==1)

* Overall knowledge item
sum know*
alpha know*, item    /* shows that know1 should not be used */
alpha know*, gen(know)

* Median split 
egen knowhigh = cut(know), group(2) label



*** Perception of coalition ratings (left-right)
recode w1_q60x* w1_q63x*(88=.) (99=.)

* SPOE-GREENS
gen coal_spoegreen = w1_q60x1
replace coal_spoegreen = w1_q63x1 if w1_q60x1==.

* SPÖ-ÖVP
gen coal_spoeoevp = w1_q60x2
replace coal_spoeoevp = w1_q63x2 if w1_q60x2==.
	
* OEVP-FPOE
gen coal_oevpfpoe = w1_q60x3
replace coal_oevpfpoe = w1_q63x3 if w1_q60x3==.
	
* SPOE-FPOE
gen coal_spoefpoe = w1_q60x4
replace coal_spoefpoe = w1_q63x4 if w1_q60x4==.	




*****************************************
* R Expectation of government coalition *
*****************************************
fre w1_q59* w1_q62*


mvdecode w1_q59* w1_q62*, mv(99=. \ 88=.) /* get rid of missing values */

* SPOE-GREENS
gen exp_spoegreen = w1_q59x1
replace exp_spoegreen = w1_q62x1 if w1_q59x1==.

* SPÖ-ÖVP
gen exp_spoeoevp = w1_q59x2
replace exp_spoeoevp = w1_q62x2 if w1_q59x2==.
	
* OEVP-FPOE
gen exp_oevpfpoe = w1_q59x3
replace exp_oevpfpoe = w1_q62x3 if w1_q59x3==.
	
* SPOE-FPOE
gen exp_spoefpoe = w1_q59x4
replace exp_spoefpoe = w1_q62x4 if w1_q59x4==.	



* Dummy=1 if R thinks it is (rather OR very) likely that coalition will form
gen exp_sg    = (exp_spoegreen==1 | exp_spoegreen==2)
gen exp_so    = (exp_spoeoevp==1 | exp_spoeoevp==2)
gen exp_of    = (exp_oevpfpoe==1 | exp_oevpfpoe==2)
gen exp_sf    = (exp_spoefpoe==1 | exp_spoefpoe==2)


foreach i in sg so of sf {
		label var exp_`i' "expectation that `i' coalition will form"
		}
	


foreach i in spoegreen spoeoevp oevpfpoe spoefpoe {
		label var exp_`i' "Likelihood of `i' coalition"
		label var coal_`i' "Left/right placement of coalition `i' "
		}





*** Dependent on Split-Sample? No, fortunately, although SPÖFPÖ coalition is close

gen split = ballot2
recode split 2=0     // split2A==1


foreach i in spoegreen spoeoevp oevpfpoe spoefpoe {
		reg exp_`i' split
		reg coal_`i' split
		ologit  coal_`i' split
		}



*************************************************************
*** Party leader evaluations  - Candidate differential    ***
*************************************************************

/*
How much do you like the following politicians?
Werner Faymann (SPÖ) 
Michael Spindelegger (ÖVP) 
Heinz-Christian Strache (FPÖ) 
Eva Glawischnig (Green)

w1_q47x1        byte    %8.0g      W1_Q47X1   LIKE-DISLIKE: WERNER FAYMANN
w1_q47x2        byte    %8.0g      W1_Q47X2   LIKE-DISLIKE: MICHAEL SPINDELEGGER
w1_q47x3        byte    %8.0g      W1_Q47X3   LIKE-DISLIKE: HEINZ-CHRISTIAN STRACHE
w1_q47x5        byte    %8.0g      W1_Q47X5   LIKE-DISLIKE: EVA GLAWISCHNIG
*/


mvdecode w1_q47x*, mv(99=. \ 88=. \ 77=.) /* get rid of missing values */


* Candidate differential (-1; 1)
gen cand_sb = (w1_q47x1 - w1_q47x5)/10
gen cand_so = (w1_q47x1 - w1_q47x2)/10
gen cand_of = (w1_q47x2 - w1_q47x3)/10
gen cand_sf = (w1_q47x1 - w1_q47x3)/10
		
sum cand_*		


* Party like/dislike scores: w1_q45x*

fre w1_q45x*
mvdecode w1_q45x*, mv(99 77 88) /* get rid of missing values */

* scaled on 0 - 1
gen scalo_o = (w1_q45x2)/10 // Scalo ÖVP
gen scalo_s = (w1_q45x1)/10 // Scalo SPÖ
gen scalo_f = (w1_q45x3)/10 // Scalo FPÖ
gen scalo_b = (w1_q45x5)/10 // Scalo Greens

* Scalo differential of coalition parties (-1, 1)
gen scalo_so = scalo_s - scalo_o
gen scalo_of = scalo_o - scalo_f
gen scalo_sb = scalo_s - scalo_b
gen scalo_sf = scalo_s - scalo_f



* Create C-B and A-B for the  two party coalitions

* SPÖ-ÖVP
gen cb_so = coal_spoeoevp - lr_oevp
gen ab_so = lr_spoe - lr_oevp

* OEVP-FPOE
gen cb_of = coal_oevpfpoe - lr_fpoe
gen ab_of = lr_oevp - lr_fpoe

* SPOE-GREENS
gen cb_sb = coal_spoegreen - lr_green
gen ab_sb = lr_spoe - lr_green

* SPOE-FPOE
gen cb_sf = coal_spoefpoe - lr_fpoe
gen ab_sf = lr_spoe - lr_fpoe


gen CB=.
gen AB=.
eststo clear
foreach coal in so of sb sf {
	replace CB=cb_`coal'
	replace AB=ab_`coal'
	reg CB AB, nocons
	eststo
	test _b[AB] = .5
	}




*******************************************************
*** Table A5: Estimated Coalition Weight (Austria)  ***
*******************************************************

* Estimates are presented in figure 1 of the paper.

#delimit ;
esttab using simplestAUT.tex, b(%9.3f) se(%9.3f) mtitles("SPÖ-ÖVP" "ÖVP-FPÖ" "SPÖ-Greens" "SPÖ-FPÖ")
varlabels(AB "\alpha") subs("\alpha" "$\alpha\$")
mgroups("\sc Coalition", pattern(1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
alignment(D{.}{.}{-1}) sfmt(%9.2f)   
stats(N, fmt(%9.0f) labels("\sc Observations")) label 
booktabs title(\sc Estimated Coalition Weight (Austria)\label{tab:simplestAUT})
 replace nonotes addnote("Standard errors in parentheses. \sym{*}  p $< 0.10$, \sym{**} p $< 0.05$,  \sym{***} p $< 0.01$ given H\(_0\): \alpha = 0.5.")  
 star(* 0.10 ** 0.05 *** 0.01) nonum
 ;
#delimit cr




*******************************************
******** Testing Order effect *************
*******************************************



* SPOE-GREENS
gen coal_spoegreen1 = w1_q60x1
replace coal_spoegreen1 = w1_q63x1 if w1_q60x1==.

* SPÖ-ÖVP
gen coal_spoeoevp1 = w1_q60x2

* ÖVP-SPÖ
gen coal_oevpspoe1 = w1_q63x2 
	
* OEVP-FPOE
gen coal_oevpfpoe1 = w1_q60x3
* FPOE-OEVP
gen coal_fpoeoevp1 = w1_q63x3 
	
* SPOE-FPOE
gen coal_spoefpoe1 = w1_q60x4
* FPOE-SPOE
gen coal_fpoespoe1 = w1_q63x4 



* SPÖ-ÖVP
gen cb1_so = coal_spoeoevp1 - lr_oevp
gen ab1_so = lr_spoe - lr_oevp

* ÖVP-SPÖ
gen cb1_os = coal_oevpspoe1 - lr_spoe
gen ab1_os = lr_oevp - lr_spoe


* OEVP-FPOE
gen cb1_of = coal_oevpfpoe1 - lr_fpoe
gen ab1_of = lr_oevp - lr_fpoe

* FPÖ-ÖVP
gen cb1_fo = coal_fpoeoevp1 - lr_oevp
gen ab1_fo = lr_fpoe - lr_oevp

* SPOE-GREENS
gen cb1_sb = coal_spoegreen1 - lr_green
gen ab1_sb = lr_spoe - lr_green

* SPOE-FPOE
gen cb1_sf = coal_spoefpoe1 - lr_fpoe
gen ab1_sf = lr_spoe - lr_fpoe

* FPÖ-SPÖ
gen cb1_fs = coal_fpoespoe1 - lr_spoe
gen ab1_fs = lr_fpoe - lr_spoe








capture drop CB AB 
gen CB=.
gen AB=.
eststo clear
foreach coal in so os of fo sb sf fs {
	replace CB=cb1_`coal'
	replace AB=ab1_`coal'
	reg CB AB, nocons
	eststo
	}
	
******************************************************	
** Table to generate data for figure 3 in the paper **
******************************************************	

#delimit ;
esttab using simplest_split.tex, b(%9.3f) se(%9.3f) mtitles("SPÖ-ÖVP" "ÖVP-SPÖ" "ÖVP-FPÖ" "FPÖ-ÖVP" "SPÖ-Greens" "SPÖ-FPÖ" "FPÖ-SPÖ")
varlabels(AB "\alpha") subs("\alpha" "$\alpha\$")
mgroups("\sc Coalition", pattern(1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
alignment(D{.}{.}{-1}) sfmt(%9.2f)   
stats(N, fmt(%9.0f) labels("\sc Observations")) label 
booktabs title(\sc Estimated Coalition Weight of First Party in Austria\label{tab:simplestAUT})
 replace nonotes addnote("Standard errors in parentheses. \sym{*}  p $< 0.10$, \sym{**} p $< 0.05$,  \sym{***} p $< 0.01$ given H\(_0\): \alpha = 0.5.")  
 star(* 0.10 ** 0.05 *** 0.01) nonum fragment
 ;
#delimit cr



	
	
***************************************************************************************
***** How much do scholars go wrong assuming Gamson? Using election results of 2013 ***
***************************************************************************************

gen range_sf = abs(lr_spoe - lr_fpoe)
gen range_sg = abs(lr_spoe - lr_green)
gen range_of = abs(lr_oevp - lr_fpoe)
gen range_so = abs(lr_spoe - lr_oevp)

	
	
	
	
	reg cb_so ab_so, nocons
    gen coal_spoeoevp_w = 	_b[ab_so]*lr_spoe + (1-_b[ab_so])*lr_oevp   // our model prediction
	gen coal_spoeoevp_hat = 	.2682/(.2682 + .2399)*lr_spoe + (1-.2682/(.2682 + .2399))*lr_oevp
    gen coal_spoeoevp_dif = coal_spoeoevp_hat - coal_spoeoevp_w
	gen coal_spoeoevp_dif_abs = abs(coal_spoeoevp_hat - coal_spoeoevp_w)
	gen coal_spoeoevp_difs = abs(coal_spoeoevp_dif)/range_so  /* Difference rel. to absolute distance betwen parties*/
	sum coal_spoeoevp_*
    
	
	reg cb_of ab_of, nocons
    gen coal_oevpfpoe_w = 	_b[ab_of]*lr_oevp + (1-_b[ab_of])*lr_fpoe   // our model prediction
	gen coal_oevpfpoe_hat = 	.2399/(.2399 + .2051)*lr_oevp + (1-.2399/(.2399 + .2051))*lr_fpoe
    gen coal_oevpfpoe_dif = coal_oevpfpoe_hat - coal_oevpfpoe_w
	gen coal_oevpfpoe_dif_abs = abs(coal_oevpfpoe_hat - coal_oevpfpoe_w)
	gen coal_oevpfpoe_difs = abs(coal_oevpfpoe_dif)/range_of  /* Difference rel. to absolute distance betwen parties*/
	sum coal_oevpfpoe_*
    
	
	reg cb_sb ab_sb, nocons
    gen coal_spoegreen_w = 	_b[ab_sb]*lr_spoe + (1-_b[ab_sb])*lr_green   // our model prediction
	gen coal_spoegreen_hat = 	.2682/(.2682 + .1242)*lr_spoe + (1-.2682/(.2682 + .1242))*lr_green
    gen coal_spoegreen_dif = coal_spoegreen_hat - coal_spoegreen_w
	gen coal_spoegreen_dif_abs = abs(coal_spoegreen_hat - coal_spoegreen_w)
	gen coal_spoegreen_difs = abs(coal_spoegreen_dif)/range_sg  /* Difference rel. to absolute distance betwen parties*/
	sum coal_spoegreen_*
    
	
	reg cb_sf ab_sf, nocons
    gen coal_spoefpoe_w = 	_b[ab_sf]*lr_spoe + (1-_b[ab_sf])*lr_fpoe   // our model prediction
	gen coal_spoefpoe_hat = 	.2682/(.2682 + .2051)*lr_spoe + (1-.2682/(.2682 + .2051))*lr_fpoe
    gen coal_spoefpoe_dif = coal_spoefpoe_hat - coal_spoefpoe_w
	gen coal_spoefpoe_dif_abs = abs(coal_spoefpoe_hat - coal_spoefpoe_w)
	gen coal_spoefpoe_difs = abs(coal_spoefpoe_dif)/range_sf  /* Difference rel. to absolute distance betwen parties*/
	sum coal_spoefpoe_*



************************
*** Table 1 in paper ***
************************


** Values to replicate TABLE 1 
 sum coal_*_abs  
 sum coal_*_difs  
  
 
* Difference between Gamson and actual placement of coalitons is between 1 an 14% of the distance  between the parties.
 
 
 
 
****************************************************************
*** Save data for generating table of decription in Appendix ***
****************************************************************

preserve
gen lfdn = pagnr
gen country = "Austria"
keep country lfdn coal_spoegreen coal_spoeoevp coal_oevpfpoe coal_spoefpoe lr_oevp lr_spoe lr_fpoe lr_green know 

compress
save description_a, replace
restore


 
exit
