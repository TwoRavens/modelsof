
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      recode.do                                       * 
*       Date:           April 6, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	Performs basic recoding of variables            * 
*                       and analysis of German data                     *
* 	    Input File:                                                     * 
*       Data Output:                                                    *              
*     ****************************************************************  * 
*     ****************************************************************  * 



set more off
version 15.1
set mem 100m

* GLES data
use "ZA5305_en_v5-0-0.dta", clear


************************************
* data from 4th wave is funky.     *
* we only take data from 6th wave  *
************************************
keep if w6==1


******************************************
* R expected party strength/vote shares  *
******************************************

/* Estimated voteshare kp6_1020x
(A) CDU/CSU
(B) SPD
(C) FDP
(D) Buendnis 90/Die Gruenen
(E) Die Linke
(F) Other parties */


/* Question wording: "Was denken Sie, wie viel Prozent der Zweitstimmen werden die Parteien 
bei der Bundestagswahl am 27. September 2009 wohl bekommen?"*/

* sum-100-constraint included in survey instrument

gen v_cdu=kp6_1020a
gen v_spd=kp6_1020b 
gen v_fdp=kp6_1020c 
gen v_b90=kp6_1020d 
gen v_dl=kp6_1020e 
gen v_oth=kp6_1020f 

**********************************
* R expected difference in size  *
**********************************

gen vdiff_cs= (v_cdu- v_spd) 
gen vdiff_cf= (v_cdu- v_fdp) 
gen vdiff_sb= (v_spd- v_b90)  


label var vdiff_cs "Difference CDU-SPD vote share"
label var vdiff_cf "Difference CDU-FDP vote share"


*****************************************
* R Expectation of government coalition *
*****************************************

foreach i in cdu spd fdp b90 dl {
	gen v`i' = v_`i'
	replace v`i' = 0 if v_`i'<5 /* only parties above the threshold are relevant*/
	label var v`i' "expected vote share of `i' (above threshold)"
	}


gen vcduspd    = vcdu + vspd
gen vcdufdp    = vcdu + vfdp
gen vspdb90    = vb90 + vspd
gen vspdfdpb90 = vb90 + vspd + vfdp
gen vcdufdpb90 = vb90 + vcdu + vfdp
gen vspddlb90  = vb90 + vspd + vdl

		


/*
Regardless of the real majorities after the election, how likely do you think is it that the following political parties would be willing to enter into a coalition with each other?
(A) CDU/CSU and SPD (grand coalition)
(B) CDU/CSU and FDP (black-yellow coalition)
(C) SPD and GRUENE (red-green coalition)
(D) SPD, FDP and GRUENE (traffic-light-coalition)
(E) CDU/CSU, FDP and GRUENE (Jamaica-coalition)
(F) SPD, DIE LINKE and GRUENE (red-red-green coalition)
- Very unlikely
- Rather unlikely 
- Rather likely
- Very likely
*/


** Do people think that SG- coalition has a chance? No -------> In footnote next to table 3

fre kp5_940
fre kp5_950  if kp5_940<=3

* 58% C-F (1439),  7% S-G (178) and Neither and then C-S say 430 respondents.

/*
2) kp5_940 (+ kp5_950)
What do you think the results of the federal election will be?
- Majority of seats for black-yellow (CDU/CSU and FDP) 
- Majority of seats for red-green (SPD and GRUENE)
- Neither of these coalitions will win a majority of seats

if (3): then
Which parties do you think will actually form a government after the federal election?
- CDU/CSU and SPD (grand coalition)
- SPD, FDP and GRUENE (traffic-light-coalition)
- CDU/CSU, FDP and GRUENE (Jamaica-coalition)
- SPD, DIE LINKE and GRUENE (red-red-green coalition)
*/



fre kp4_970*
/*
If you think of the statements of CDU/CSU made so far in the election campaign, what do you think how likely or not are CDU and CSU to form a coalition with the following parties?
CDU and CSU and .... (A) SPD
(B) FDP
(C) GRUENE
(D) The party DIE LINKE
- would never form a coalition
- are unlikely to form a coalition
- are likely to form a coalition
- are very likely to form a coalition
*/







*********************************************************
* R Left-right assesment of parties, coalitions & self  *
*********************************************************

sum kp*_1510*
	
/* kp6_1500 Left-right self assessment 
   kp6_1490a-f Left-right assessment, parties
    (A) CDU
	(B) CSU
	(C) SPD
	(D) FDP
	(E) Buendnis 90/Die Gruenen
	(F) Die Link
   kp6_1510a-f Left-right assessment coalitions
    (A) Grand coalition (CDU/CSU and SPD)
	(B) Black-yellow coalition (CDU/CSU and FDP )
	(C) Red-green coalition (SPD and Buendnis 90/Die Gruenen)
	(D) Traffic-light- coalition (SPD, FDP and Buendnis 90/Die Gruenen)
	(E) Jamaica- coalition (CDU/CSU, FDP and Buendnis 90/Die Gruenen)
	(F) Red-red-green coalition (SPD, Die Linke and Buendnis 90/Die Gruenen)
   */



drop if kp6_1510a==. | kp6_1510b==. | kp6_1510c==. | kp6_1510d==. | kp6_1510e==. | kp6_1510f==. 
recode kp6_1490* kp6_1500 kp6_1510* (98=.) (99=.)


* Rescale from 1-11 to 0-10
gen lr_cdu=kp6_1490a-1
gen lr_csu=kp6_1490b-1
* WE should take the perception for the CSU rather than the CDU for respondents from Bavaria
* because the CDU is nowhere on the ballot there
replace lr_cdu = lr_csu if fedstate==9

gen lr_spd=kp6_1490c-1
gen lr_fdp=kp6_1490d-1
gen lr_b90=kp6_1490e-1
gen lr_dl=kp6_1490f-1

* perception of coalition ratings (left-right)
gen coal_cduspd=kp6_1510a-1
gen coal_cdufdp=kp6_1510b-1
gen coal_spdb90=kp6_1510c-1
gen coal_spdfdpb90=kp6_1510d-1
gen coal_cdufdpb90=kp6_1510e-1
gen coal_spddlb90=kp6_1510f-1


* Ideology: The more centrist a voter the less
gen lr_self = kp6_1500-1
gen centrist_self = abs(lr_self - 5)




	
**********************************
* R level of Political Knowledge *
**********************************


* What does the term `overhang seats' mean?
gen know1 = (kp6_145==4)
gen know2 = (kp7_145==4)
* Do you happen to know who currently holds the majority in the Federal Council (Bundesrat)?
gen know3 = (kp6_140==2)
gen know4 = (kp3_140==2)
* Who elects the Chancellor of the Federal Republic of Germany?
gen know5 = (kp6_130==3)
gen know6 = (kp3_130==3)
*  how many federal states in total the Federal Republic of Germany
gen know7 = (kp2_120==16)
* Which vote is more important, thus determining how strongly the party is represented in the Bundestag?
gen know8  = (kp1_110==2)
gen know9  = (kp4_110==2)
gen know10 = (kp6_110==2)
gen know11 = (kp7_110==2)
* What does the term 'secrecy of the ballot' mean?
gen know12 = (kp3_100==4)
* Which vote is more important, thus determining how strongly the party is represented in the Bundestag?
gen know13 = (kp2_090==5)
gen know14 = (kp4_090==5)
gen know15 = (kp6_090==5)
gen know16 = (kp7_090==5)

* drop items measured after wave 6
drop know2 know11 know16

sum know*
alpha know*, gen(know)

sum know, detail

* Median split 
egen knowhigh = cut(know), group(2) label


	
	


******************************************************
*** Table A4: Estimated Coalition Weight (Germany) ***
******************************************************


gen cb_cs = coal_cduspd - lr_spd
gen ab_cs = lr_cdu - lr_spd

gen cb_cf = coal_cdufdp - lr_fdp
gen ab_cf = lr_cdu - lr_fdp

gen cb_sb = coal_spdb90 - lr_b90
gen ab_sb = lr_spd - lr_b90

gen CB=.
gen AB=.
eststo clear
foreach coal in cs cf sb {
	replace CB=cb_`coal'
	replace AB=ab_`coal'
	reg CB AB, nocons
	eststo
	test _b[AB] = .5	
	}


  
#delimit ;
esttab using simplestBoth.tex, b(%9.3f) se(%9.3f) mtitles("CDU-SPD" "CDU-FDP" "SPD-B90")
varlabels(AB "\alpha") subs("\alpha" "$\alpha\$")
mgroups("\sc Coalition", pattern(1 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
alignment(D{.}{.}{-1}) sfmt(%9.2f)   
stats(N, fmt(%9.0f) labels("\sc Observations")) label 
booktabs title(\sc Estimated Coalition Weight (Germany) \label{tab:simplestBoth})
 replace nonotes addnote("Standard errors in parentheses. \sym{*}  p $< 0.10$, \sym{**} p $< 0.05$,  \sym{***} p $< 0.01$ for H\(_0\): \alpha = 0.5.")  
 star(* 0.10 ** 0.05 *** 0.01) nonum
 ;
#delimit cr


	


	
********************************************************************************************
***** How much do scholars go wrong assuming Gamson? Using election results of 2009 ********
********************************************************************************************

gen dif_cs = lr_cdu - lr_spd
gen dif_cf = lr_cdu - lr_fdp
gen dif_sb = lr_spd - lr_b90
fre dif_cs
sum dif_*


gen range_cs = abs(lr_cdu - lr_spd)
gen range_cf = abs(lr_cdu - lr_fdp)
gen range_sb = abs(lr_spd - lr_b90)
sum range_*


	reg cb_cs ab_cs, nocons
    gen coal_cduspd_w = 	_b[ab_cs]*lr_cdu + (1-_b[ab_cs])*lr_spd   // our model prediction
	gen coal_cduspd_hat = 	.338/(.338 + .23)*lr_cdu + (1-.338/(.338 + .23))*lr_spd // prediction based on Gamson
    gen coal_cduspd_dif = coal_cduspd_hat - coal_cduspd_w
	gen coal_cduspd_dif_abs = abs(coal_cduspd_hat - coal_cduspd_w)
	gen coal_cduspd_difs = abs(coal_cduspd_dif)/range_cs  /* Difference rel. to absolute distance betwen parties*/
	sum coal_cduspd_dif*

	
	
	reg cb_cf ab_cf, nocons
    gen coal_cdufdp_w = 	_b[ab_cf]*lr_cdu + (1-_b[ab_cf])*lr_fdp   // our model prediction
	gen coal_cdufdp_hat = 	.338/(.338 + .098)*lr_cdu + (1-.338/(.338 + .098))*lr_fdp
    gen coal_cdufdp_dif = coal_cdufdp_hat - coal_cdufdp_w
	gen coal_cdufdp_dif_abs = abs(coal_cdufdp_hat - coal_cdufdp_w)
	gen coal_cdufdp_difs = abs(coal_cdufdp_dif)/range_cf  /* Difference rel. to absolute distance betwen parties*/
	sum coal_cdufdp_dif*

	
	reg cb_sb ab_sb, nocons
    gen coal_spdb90_w = 	_b[ab_sb]*lr_spd + (1-_b[ab_sb])*lr_b90   // our model prediction
	gen coal_spdb90_hat = 	.23/(.23 + .107)*lr_spd + (1-.23/(.23 + .107))*lr_b90
    gen coal_spdb90_dif = coal_spdb90_hat - coal_spdb90_w
	gen coal_spdb90_dif_abs = abs(coal_spdb90_hat - coal_spdb90_w)
	gen coal_spdb90_difs = abs(coal_spdb90_dif)/range_sb  /* Difference rel. to absolute distance betwen parties*/
	sum coal_spdb90_dif*
	
********************************************************************************************



************************
*** Table 1 in paper ***
************************


** Values to replicate TABLE 1 
 sum coal_*_difs  
 sum coal_*_abs   
 
* Difference between Gamson and predicted placement of coalitons is between 6 an 14% of the distance  between the parties.
 


************************************************************
*** Robustness Test for the impact of measurement error ****
************************************************************

preserve
sum know, detail
* Replicate basic model for political Experts
keep if know > r(p50)
eststo clear
foreach coal in cs cf sb {
	replace CB=cb_`coal'
	replace AB=ab_`coal'
	reg CB AB, nocons
	eststo
	test _b[AB] = .5	
	}

	


********************************************************************
*** Table  A8: Estimated Coalition Weight (Germany) for Experts  ***
********************************************************************

#delimit ;
esttab using simplestBothExpert.tex, b(%9.3f) se(%9.3f) mtitles("CDU-SPD" "CDU-FDP" "SPD-B90")
varlabels(AB "\alpha") subs("\alpha" "$\alpha\$")
mgroups("\sc Coalition", pattern(1 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
alignment(D{.}{.}{-1}) sfmt(%9.2f)   
stats(N, fmt(%9.0f) labels("\sc Observations")) label 
booktabs title(\sc Estimated Coalition Weight (Germany) \\ -- Experts only -- \label{tab:simplestBothExpert})
 replace nonotes addnote("Standard errors in parentheses. \sym{*}  p $< 0.10$, \sym{**} p $< 0.05$ for H\(_0\): \alpha = 0.5.")  
 star(* 0.10 ** 0.05) nonum
 ;
#delimit cr

restore




*******************************************************************
**** TABLE  A9: Testing the Proportional Influence Heuristic ******
*******************************************************************


eststo clear

*** Estimating the results coalition-by-coalition

* Grand CDU/SPD
gen v_sc=v_spd/(v_spd+v_cdu)
gen wp_sc=v_sc*lr_spd
gen wp_cs=(1-v_sc)*lr_cdu
gen v_cs=v_cdu/(v_spd+v_cdu) /* CDU share of CS coalition*/
label var v_sc "SPD share of CDU-SPD vote share"
label var v_cs "CDU share of CDU-SPD vote share"




* Black Yellow - CDU/FDP
gen v_cf=v_cdu/(v_cdu+v_fdp) 	/* CDU share of CF coalition*/
gen v_fc=1-v_cf 				/* FDP share of CDU-FDP coalition */
gen wp_cf=v_cf*lr_cdu
gen wp_fc=(1-v_cf)*lr_fdp
label var v_cf "CDU share of CDU-FDP vote share"
label var v_fc "FDP share of CDU-FDP vote share"




* Red Green SPD/B90
gen v_sb=v_spd/(v_spd+v_b90)  /* SPD share of SB coalition*/
gen v_bs=1-v_sb
gen wp_sb=v_sb*lr_spd
gen wp_bs=(1-v_sb)*lr_b90
label var v_sb "SPD share of SPD-B90 coalition vote share"
label var v_bs "B90 share of SPD-B90 coalition vote share"



*** Create simple table for the Gamson's Law test

capture drop wp_1 wp_2

eststo clear

gen wp_1=wp_cs
gen wp_2=wp_sc
reg coal_cduspd wp_1 wp_2, noco
matrix pval = r(table)  // needed to automatically correct p-value
test wp_1=1
test wp_2=1
* Fix p-value of hyp. test
* Thanks to Ben Jann.
* - matrix define - 
matrix pval = pval["pvalue", 1...]
matrix pval[1, colnumb(pval, "wp_2")] = `r(p)'   // returns 1st row pval & changes automatically col of pval with name "wp_2" with p-value of last hyp. test
estadd matrix p = pval
test (wp_1=1) (wp_2=1)
eststo



replace wp_1=wp_cf
replace wp_2=wp_fc
reg coal_cdufdp wp_1 wp_2, nocons
test wp_1=1
test wp_2=1
test (wp_1=1) (wp_2=1)
eststo

replace wp_1=wp_sb
replace wp_2=wp_bs
reg coal_spdb90 wp_1 wp_2, nocons
test wp_1=1
test wp_2=1
test (wp_1=1) (wp_2=1)
eststo



*******************************************************************
**** TABLE  A9: Testing the Proportional Influence Heuristic ******
*******************************************************************

#delimit ;
esttab using gamsonGER.tex, b(%9.3f) se(%9.3f) mtitles("CDU-SPD" "CDU-FDP" "SPD-B90")
varlabels(wp_1 "\alpha_A" wp_2 "\alpha_B" wp_sc "\alpha_B") subs("\alpha_A" "$\alpha_A\$" "\alpha_B" "$\alpha_B\$")
alignment(D{.}{.}{-1}) sfmt(%9.2f)   
stats(N, fmt(%9.0f) labels("\sc Observations")) label 
booktabs title(\sc Testing Gamson's Law \\ \small --- Proportional Influence of Coalition Parties --- \label{tab:gamsonGER})
 replace nonotes addnote("Standard errors in parentheses. \sym{*}p $< 0.10$, \sym{**}p $< 0.05$,  \sym{***}p $< 0.01$ given H\(_0\): $\alpha = 1$.") 
 star(* 0.10 ** 0.05 *** 0.01) nonum    
 ;
#delimit cr





************************************************************
*** Robustness Test for the impact of measurement error ****
************************************************************

preserve
sum know, detail
* Replicate basic model for political Experts
keep if know > r(p50)


*** Create simple table for the Gamson's Law test - for political Experts only
capture drop wp_1 wp_2

eststo clear

gen wp_1=wp_cs
gen wp_2=wp_sc
reg coal_cduspd wp_1 wp_2, noco
matrix pval1 = r(table)  // needed to automatically correct p-value
test wp_1=1
test wp_2=1
* Fix p-value of hyp. test automatically
matrix pval1 = pval1["pvalue", 1...]
matrix pval1[1, colnumb(pval1, "wp_2")] = `r(p)'  // returns 1st row pval & changes automatically col of pval1 with name "wp_2" with p-value of last hyp. test
estadd matrix p = pval1
test (wp_1=1) (wp_2=1)
eststo


replace wp_1=wp_cf
replace wp_2=wp_fc
reg coal_cdufdp wp_1 wp_2, nocons
test wp_1=1
test wp_2=1
test (wp_1=1) (wp_2=1)
eststo

replace wp_1=wp_sb
replace wp_2=wp_bs
reg coal_spdb90 wp_1 wp_2, nocons
test wp_1=1
test wp_2=1
test (wp_1=1) (wp_2=1)
eststo

** Result: Only the weight for SPD in CDU-SPD coalition is NOT different from 1
**         But both weights are jointly different from 1




****************************************************************************
*** Table A10: The Proportional Influence Heuristic (Political Experts)  ***
****************************************************************************


#delimit ;
esttab using gamsonGERk.tex, b(%9.3f) se(%9.3f) mtitles("CDU-SPD" "CDU-FDP" "SPD-B90")
varlabels(wp_1 "\alpha_A" wp_2 "\alpha_B" wp_sc "\alpha_B") subs("\alpha_A" "$\alpha_A\$" "\alpha_B" "$\alpha_B\$")
alignment(D{.}{.}{-1}) sfmt(%9.2f)   
stats(N, fmt(%9.0f) labels("\sc Observations")) label 
booktabs title(\sc Testing Gamson's Law (Political Experts)\\ \small --- Proportional Influence of Coalition Parties --- \label{tab:gamsonGERk})
 replace nonotes addnote("Standard errors in parentheses. \sym{*}p $< 0.10$, \sym{**}p $< 0.05$,  \sym{***}p $< 0.01$ given H\(_0\): $\alpha = 1$.") 
 star(* 0.10 ** 0.05 *** 0.01) nonum    
 ;
#delimit cr

restore



*********************************************
* Party like/dislike scores: kp6_430*     ***
*********************************************

mvdecode kp6_430*, mv(99=.) /* get rid of missing values */

* scaled on 0 - 1
gen scalo_c = (kp6_430a - 1)/10 // Scalo CDU
replace scalo_c = (kp6_430b - 1)/10 if fedstate==9 // Scalo CSU
gen scalo_s = (kp6_430c-1)/10 // Scalo SPD
gen scalo_f = (kp6_430d-1)/10 // Scalo FDP
gen scalo_b = (kp6_430e-1)/10 // Scalo B90

* Scalo differential of coalition parties (-1, 1)
gen scalo_cs = scalo_c - scalo_s
gen scalo_cf = scalo_c - scalo_f
gen scalo_sb = scalo_s - scalo_b



*********************************************
*** Party leader evaluations kp*_650*     ***
*********************************************

mvdecode kp*_650*, mv(99=. \ 98=.) /* get rid of missing values */

*(A) Angela Merkel (CDU)
sum kp*_650a
sum kp*_650c
*(C) Horst Seehofer (CSU)


*(B) Frank-Walter Steinmeier (SPD)
sum kp*_650b

*(F) Guido Westerwelle (FDP)
sum kp*_650f

*(G) Renate Künast (B90)
*(H) Jürgen Trittin (B90)

sum kp*_650g
sum kp*_650h


* Candidate differential (-1; 1)
gen cand_cs = (kp1_650a - kp1_650b)/10
gen cand_cf = (kp1_650a - kp1_650f)/10
gen cand_sb = (kp1_650b - kp1_650h)/10




****************************************************
* Ideological Centrality (Appendix) for robustness *
****************************************************

* the degree to which a party is perceived in the ideological center (for robustness in Appendix)
foreach i in cdu spd fdp b90 dl {
	gen center_`i'= 5-abs(lr_`i' -5)
	label var center_`i' " ideological centrality `i'"
	}
	
gen center_cs = center_cdu - center_spd
gen center_cf = center_cdu - center_fdp
gen center_sb = center_spd - center_b90
	

*** justification of using '5'

egen lr_median = rowmedian(lr_cdu lr_spd lr_fdp lr_b90)

sum lr_median   // We get almost identical results if sample is subset to estimation samples that are defined later
	

	
	
****************************************
* Ideological Centrality used in paper *
****************************************


**********************************************************************************
*** USE THE RESPONDENT'S OWN MEDIAN AS BASIS FOR CREATING CENTRALITY MEASURE
**********************************************************************************

* Create share of vote out of total vote for the five main parties
foreach p in cdu spd fdp b90 dl {
	gen vv_`p'=v_`p'/((v_cdu+v_spd+v_fdp+v_b90+v_dl)/100)
	}

gen run_vote=0
gen center_pos=.
forvalues i=0/10 {
	foreach p in cdu spd fdp b90 dl {
		replace run_vote=run_vote+vv_`p' if lr_`p'==`i'
		}
	replace center_pos=`i' if center_pos==. & run_vote>50
	}

foreach i in cdu spd fdp b90 dl {
	gen dist_i_`i'= abs(lr_`i' - center_pos)
	}


gen center_i_cs =  -dist_i_cdu + dist_i_spd
gen center_i_cf =  -dist_i_cdu + dist_i_fdp
gen center_i_sb =  -dist_i_spd + dist_i_b90





********************************************************
**** IHI: Calculate bargaining indicies
**** Banzhaf:

* for 5 parties there are 2^5 different coalitions

forvalues i=1/31 {
	inbase 2 `i' 
	gen count`i'=r(base)
	}
order count*

tostring count*, replace
forvalues i=1/15 {
	local k=5-length(count`i')
	forvalues j=1/`k' {
		replace count`i'="0"+count`i'
		}
	}

		
* TG replaced v_cdu into vcdu ect to account for 5% threshold
gen v_1=vcdu
gen v_2=vspd
gen v_3=vfdp
gen v_4=vb90
gen v_5=vdl

egen vsum = rowtotal(vcdu vspd vfdp vb90 vdl)

*generate expected vote share for each coalition
forvalues i=1/31 {
	gen vote_c`i'=0
		forvalues j=1/5 {
			replace vote_c`i'=vote_c`i'+v_`j' if substr(count`i',`j',1)=="1"
			}
		}

gen totalpiv=0
forvalues i=1/5 {
	gen piv`i'=0
	forvalues j=1/31 {
	
		* A party i is pivotal if a coalition would loose 
		* its majority (= coalition vote share > vsum - [coalition vote share - v_i]) if party i is not part of it.
		
		replace piv`i'=piv`i'+1 if vote_c`j'>=vsum-vote_c`j' & vote_c`j'-v_`i'<vsum-(vote_c`j' - v_`i') & substr(count`j',`i',1)=="1"		
		}
	replace totalpiv=totalpiv+piv`i'
	}

local i=0
foreach party in cdu spd fdp b90 dl  {
	local i=`i'+1
	gen banzhaf`party'=piv`i'/totalpiv
	label var banzhaf`party' "banzhaf index `party'"
	}
	
************************************************************************************************************




* Banzhaf Index
	gen b_rat_cs=banzhafcdu/(banzhafcdu+banzhafspd)
	gen b_rat_cf=banzhafcdu/(banzhafcdu+banzhaffdp)
	gen b_rat_sb=banzhafspd/(banzhafspd+banzhafb90)


	
* Interaction Party Size *  Ideo Centrality  
gen ivcenter_cs = v_cs*center_cs
gen ivcenter_cf = v_cf*center_cf
gen ivcenter_sb = v_sb*center_sb

gen ivdiffcenter_cs = vdiff_cs*center_cs 
gen ivdiffcenter_cf = vdiff_cf*center_cf 
gen ivdiffcenter_sb = vdiff_sb*center_sb 


gen ivcenter_i_cs = v_cs*center_i_cs 
gen ivcenter_i_cf = v_cf*center_i_cf 
gen ivcenter_i_sb = v_sb*center_i_sb 

gen ivdiffcenter_i_cs = vdiff_cs*center_i_cs 
gen ivdiffcenter_i_cf = vdiff_cf*center_i_cf 
gen ivdiffcenter_i_sb = vdiff_sb*center_i_sb 



* Delta Ideo Centrality * Banzhaf  
gen icb_rat_cs = center_cs*b_rat_cs
gen icb_rat_cf = center_cf*b_rat_cf
gen icb_rat_sb = center_sb*b_rat_sb


gen ibrcenter_i_cs = b_rat_cs*center_i_cs 
gen ibrcenter_i_cf = b_rat_cf*center_i_cf 
gen ibrcenter_i_sb = b_rat_sb*center_i_sb 



** Generate variables with Knowldege Interaction


* no knowledge interaction needed for: ibcenter_i_cf ibcenter_i_cs icb_rat_cs icb_rat_cf

foreach i in v_cs  center_cs  cand_cs  scalo_cs v_cf  center_cf  cand_cf  scalo_cf v_sb  center_sb  cand_sb  scalo_sb ivcenter_cs ivcenter_cf{
	gen know_`i'= know*`i' 
	}
foreach i in center_i_cs   ivcenter_i_cs center_i_cf    ivcenter_i_cf   b_rat_cs   b_rat_cf ibrcenter_i_cs  ibrcenter_i_cf{ 
	gen know_`i'= know*`i' 
	}

compress
save analysis, replace



*****************************************************************************
***** APPENDIX A: How many R place parties & coalitions on L/R scale? *******
*****************************************************************************

* save data for descriptive overview

fre lr_* coal_* 

sum v_cdu v_spd v_fdp v_b90 v_dl
 
preserve
gen country = "Germany"
keep country lfdn coal_cduspd coal_cdufdp coal_spdb90 lr_cdu lr_spd lr_fdp lr_b90 v_cdu v_spd v_fdp v_b90 v_dl know 
compress
save description_g, replace
restore


* Perceptual biases regarding party leaders 
* may lead respondents to overestimate the size of the parties whose leaders they consider competent

* Info for Footnote

reg v_cs scalo_cs
reg v_cf scalo_cf
reg v_sb scalo_sb

sum scalo_* cand_*, detail

reg v_cs cand_cs
reg v_cf cand_cf
reg v_sb cand_sb

reg v_cs scalo_cs cand_cs
reg v_cf scalo_cf cand_cf
reg v_sb scalo_sb cand_sb
* scalo rather than cand matter!




****************************************************
**** Code to simplify NLS estimation in Stata ******
****************************************************



************************************************************************************************************
**** Create program that sets up the linear predictor (zi)				
capture program drop nlconvex
program nlconvex, rclass
                version 11 /* Why not 13.1? */
                syntax varlist(min=2 max=15) [aw fw iw] if /* TG increased max to 15!!!! */
				local lhs: word 1 of `varlist'
				local party1: word 2 of `varlist'
				local party2: word 3 of `varlist'
				local zi ""
				local nvar: word count `varlist'
				forvalues i=4/`nvar' {
					local dep: word `i' of `varlist'
					local j=`i'-3
					local dep "{gamma`j'}*`dep'"
					local zi "`zi'+`dep'"
					}
                return local eq "`lhs' = invlogit({gamma0=0.4}`zi')*`party1' + (1-(invlogit({gamma0}`zi')))*`party2'"
                return local title "Program test"
            end

*** Create program that expands party pairs into dependent variable & lr_party1 and lr_party2
*** and then calls nlconvex to run model			
capture program drop nlcl
program nlcl
				local n: word count `0'
				global ivar "coal_`1'`2' lr_`1' lr_`2'"
				display "`1'"
				display `n'
				display "$ivar"
				forvalues i=3/`n' {
					local w: word `i' of `0'
					global ivar "$ivar `w'"
					}
				display "$ivar"
				nl convex: $ivar
				end
			
*nl cl: coal_cduspd lr_cdu lr_spd know spid_cdu spid_spd
**** The syntax for nlcl is:
**** nlcsl [party1] [party2] [independent variables]
**** note that [independent variables] excludes lr_party1 and lr_party2 --- those are created automatically



* Constant only model (same results as in the OLS case)

nlcl cdu spd
nlcom (invlogit(_b[/gamma0]))

nlcl cdu fdp 
nlcom (invlogit(_b[/gamma0]))

nlcl spd b90 
nlcom (invlogit(_b[/gamma0]))




**************************
*** Estimation results ***
**************************


capture drop sample3_*
nlcl cdu spd  v_cs  center_cs  cand_cs  scalo_cs know
gen sample3_cs = e(sample)
nlcl cdu fdp  v_cf  center_cf  cand_cf  scalo_cf know
gen sample3_cf = e(sample)
nlcl spd b90  v_sb  center_sb  cand_sb  scalo_sb know
gen sample3_sb = e(sample)

* Justification for taking '5' as median for center_*
sum lr_median if sample3_cs
sum lr_median if sample3_cf
sum lr_median if sample3_sb


* Justification for red-green government was not seen to win a majority
fre kp5_940 if sample3_cs
fre kp5_940 if sample3_cf
fre kp5_940 if sample3_sb






******************************************************************
*** Table 2: Determinants of Determinants of Coalition Weight  ***
******************************************************************

 
capture drop sample_*
nlcl cdu spd  center_i_cs  v_cs  ivcenter_i_cs   cand_cs  scalo_cs  know      // Ideo Centrality & Party Size 
gen sample_cs1 = e(sample)                                                   
nlcl cdu spd  center_i_cs b_rat_cs  ibrcenter_i_cs  cand_cs  scalo_cs  know   // Ideo Centrality & Banzhaf 
gen sample_cs2 = e(sample)                                                   
nlcl cdu fdp  center_i_cf  v_cf  ivcenter_i_cf   cand_cf  scalo_cf  know      // Ideo Centrality & Party Size 
gen sample_cf1 = e(sample)                                                   
nlcl cdu fdp  center_i_cf b_rat_cf  ibrcenter_i_cf    cand_cf  scalo_cf  know // Ideo Centrality & Banzhaf         
gen sample_cf2 = e(sample)

eststo clear


*** Need to trick esttab to leave space for interaction term (for order in table)
*** Then use substitute() in esttab to remove.
gen dummy=0



* CDU-SPD models

nlcl cdu spd  center_i_cs  v_cs  dummy cand_cs  scalo_cs  know    if  sample_cs1             // Ideo Centrality & Party Size   
eststo                                                                                       
nlcl cdu spd  center_i_cs  v_cs  ivcenter_i_cs   cand_cs  scalo_cs know if  sample_cs1       // Ideo Centrality & Party Size 
eststo                                                                                       
nlcl cdu spd  center_i_cs  b_rat_cs  dummy cand_cs  scalo_cs  know    if  sample_cs2         // Ideo Centrality & Banzhaf 
eststo                                                                                       
nlcl cdu spd  center_i_cs  b_rat_cs  ibrcenter_i_cs   cand_cs  scalo_cs know  if  sample_cs2 // Ideo Centrality & Banzhaf             
eststo


* CDU-FDP models

nlcl cdu fdp  center_i_cf  v_cf     dummy cand_cf  scalo_cf  know   if  sample_cf1             // Ideo Centrality & Party Size    
eststo                                                                                         
nlcl cdu fdp  center_i_cf  v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  if  sample_cf1    // Ideo Centrality & Party Size        
eststo                                                                                         
nlcl cdu fdp  center_i_cf b_rat_cf  dummy cand_cf  scalo_cf  know   if  sample_cf2             // Ideo Centrality &  Banzhaf
eststo                                                                                         
nlcl cdu fdp  center_i_cf b_rat_cf  ibrcenter_i_cf   cand_cf  scalo_cf  know    if  sample_cf2  // Ideo Centrality & Banzhaf           
eststo



* fragment allows to be scaled and input in tex-file
#delimit 
esttab  using RnRtable_new.tex, b(%9.3f) se(%9.3f)  booktabs title(\sc Determinants of Coalition Weight $\alpha$) nonumbers
 varlabels(gamma0:_cons "Intercept" gamma1:_cons "{$\Delta$}Ideological Centrality" gamma2:_cons "Bargaining Power" 
 gamma3:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power" 
 gamma4:_cons "{$\Delta$}Leader Evaluation" gamma5:_cons "{$\Delta$}Party Preference" gamma6:_cons "Political Knowledge")
 mgroups("CDU-SPD" "CDU-FDP", pattern(1 0 0 0 1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
 alignment(D{.}{.}{-1}) sfmt(%9.2f)   eqlabels(none) mtitles("Party Size" "Party Size" "Banzhaf Index" "Banzhaf Index" "Party Size" "Party Size" "Banzhaf Index" "Banzhaf Index") 
 stats(N rmse , fmt(%9.0f %9.2f) labels("\sc Observations" "\sc Root MSE")) label sub(0.000 ~ (.) ~)
 replace nonotes addnote("*  p < 0.10; ** p < 0.05; *** p < 0.01.")  star(* 0.10 ** 0.05 *** 0.01) 
fragment
;
#delimit cr




************************************************************************
*** Table A11: Determinants of SPD-B90 Coalition Weight: APPENDIX E  ***
************************************************************************

capture drop sample_*
nlcl spd b90  center_i_sb  v_sb  ivcenter_i_sb   cand_sb  scalo_sb  know      // Ideo Centrality & Party Size 
gen sample_sb1 = e(sample)                                                   
nlcl spd b90  center_i_sb b_rat_sb  ibrcenter_i_sb  cand_sb  scalo_sb  know   // Ideo Centrality & Banzhaf 
gen sample_sb2 = e(sample)                                                   


eststo clear


* SPD-B90 models

nlcl spd b90  center_i_sb  v_sb  dummy   cand_sb  scalo_sb  know   if  sample_sb1              // Ideo Centrality & Party Size   
eststo                                                                                       
nlcl spd b90  center_i_sb  v_sb  ivcenter_i_sb   cand_sb  scalo_sb  know   if  sample_sb1      // Ideo Centrality & Party Size 
eststo                                                                                       
nlcl spd b90  center_i_sb b_rat_sb  dummy  cand_sb  scalo_sb  know    if  sample_sb2           // Ideo Centrality & Banzhaf 
eststo                                                                                       
nlcl spd b90  center_i_sb b_rat_sb  ibrcenter_i_sb  cand_sb  scalo_sb  know    if  sample_sb2  // Ideo Centrality & Banzhaf             
eststo




* fragment allows to be scaled and input in tex-file
#delimit 
esttab  using RnRtable_sb.tex, b(%9.3f) se(%9.3f)  booktabs title(\sc Determinants of SPD-B90 Coalition Weight $\alpha$) nonumbers
 varlabels(gamma0:_cons "Intercept" gamma1:_cons "{$\Delta$}Ideological Centrality" gamma2:_cons "Bargaining Power" 
 gamma3:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power" 
 gamma4:_cons "{$\Delta$}Leader Evaluation" gamma5:_cons "{$\Delta$}Party Preference" gamma6:_cons "Political Knowledge")
 mgroups("SPD-B90", pattern(1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
 alignment(D{.}{.}{-1}) sfmt(%9.2f)   eqlabels(none) mtitles("Party Size" "Party Size" "Banzhaf Index" "Banzhaf Index") 
 stats(N rmse , fmt(%9.0f %9.2f) labels("\sc Observations" "\sc Root MSE")) label sub(0.000 ~ (.) ~)
 replace nonotes addnote("*  p < 0.10; ** p < 0.05; *** p < 0.01.")  star(* 0.10 ** 0.05 *** 0.01) 
fragment
;
#delimit cr




****************************************************************
*** Table A12: Determinants of Coalition Weight: APPENDIX F  ***
****************************************************************

capture drop sample_*
nlcl cdu spd  center_cs v_cs     ivcenter_cs cand_cs  scalo_cs  know // alt. Ideo Centrality & Party Size
gen sample_cs1 = e(sample)
nlcl cdu spd  center_cs b_rat_cs icb_rat_cs  cand_cs  scalo_cs  know // alt. Ideo Centrality & Banzhaf
gen sample_cs2 = e(sample)
nlcl cdu fdp  center_cf v_cf     ivcenter_cf cand_cf  scalo_cf  know // alt. Ideo Centrality & Party Size
gen sample_cf1 = e(sample)
nlcl cdu fdp  center_cf b_rat_cf icb_rat_cf    cand_cf  scalo_cf  know // alt. Ideo Centrality & Banzhaf     
gen sample_cf2 = e(sample)


eststo clear

*CDU-SPD Models

nlcl cdu spd  center_cs v_cs  dummy  cand_cs  scalo_cs  know if sample_cs1          // alt. Ideo centrality & Party Size       
eststo
nlcl cdu spd  center_cs v_cs  ivcenter_cs   cand_cs  scalo_cs know if sample_cs1    // alt. Ideo centrality * Party Size 
eststo
nlcl cdu spd  center_cs b_rat_cs  dummy cand_cs  scalo_cs  know if sample_cs2       // alt. Ideo centrality & Banzhaf     
eststo
nlcl cdu spd  center_cs b_rat_cs icb_rat_cs   cand_cs  scalo_cs  know if sample_cs2  // alt. Ideo centrality * Banzhaf       
eststo

* CDU-FDP Models

nlcl cdu fdp  center_cf v_cf   	dummy 			cand_cf  scalo_cf  know      if  sample_cf1   // alt. Ideo centrality & Party Size             
eststo                                                                                        
nlcl cdu fdp  center_cf v_cf  ivcenter_cf   cand_cf  scalo_cf  know  if  sample_cf1           // alt. Ideo centrality * Party Size 
eststo                                                                                        
nlcl cdu fdp  center_cf b_rat_cf  	dummy 		cand_cf  scalo_cf  know   if  sample_cf2      // alt. Ideo centrality & Banzhaf     
eststo                                                                                        
nlcl cdu fdp  center_cf b_rat_cf icb_rat_cf cand_cf  scalo_cf  know    if  sample_cf2          // alt. Ideo centrality * Banzhaf            
eststo

* fragment allows to be scaled and input in tex-file

#delimit 
esttab  using RnRtable_org.tex, b(%9.3f) se(%9.3f)  booktabs title(\sc Determinants of Coalition Weight $\alpha$) nonumbers
 varlabels(gamma0:_cons "Intercept" gamma1:_cons "{$\Delta$}Ideol.~Centrality" gamma2:_cons "Barg.~Power" 
 gamma3:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power" 
 gamma4:_cons "{$\Delta$}Leader Evaluation" gamma5:_cons "{$\Delta$}Party Preference" gamma6:_cons "Pol.~Knowledge")
 mgroups("CDU-SPD" "CDU-FDP", pattern(1 0 0 0 1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
 alignment(D{.}{.}{-1}) sfmt(%9.2f)   eqlabels(none) mtitles("Party Size" "Party Size" "Banzhaf Index" "Banzhaf Index" "Party Size" "Party Size" "Banzhaf Index" "Banzhaf Index") 
 stats(N rmse , fmt(%9.0f %9.2f) labels("\sc Observations" "\sc Root MSE")) label sub(0.000 ~ (.) ~)
 replace nonotes addnote("*  p < 0.10; ** p < 0.05; *** p < 0.01.")  star(* 0.10 ** 0.05 *** 0.01) 
fragment
;
#delimit cr





*******************************************************************************************
********* Models, incl knowledge interaction  using  knowledge subsample ******************
*******************************************************************************************




************************************************************************
*** Table A13: Determinants of CDU-SPD Coalition Weight: APPENDIX H  ***
************************************************************************


*** CDU-SPD Model

capture drop sample_*
nlcl cdu spd  center_i_cs v_cs     ivcenter_i_cs   cand_cs  scalo_cs  know // Ideo Centrality & Party Size
gen sample_cs1 = e(sample)

nlcl cdu spd  center_i_cs b_rat_cs ibrcenter_i_cs  cand_cs  scalo_cs  know // Ideo Centrality & Banzhaf
gen sample_cs2 = e(sample)


* CDU-SPD model; Party Size

eststo clear
nlcl cdu spd  center_i_cs v_cs     ivcenter_i_cs   cand_cs  scalo_cs  know  if  sample_cs1 
eststo
sum know if  sample_cs1, detail
scalar know50 =`r(p50)'
nlcl cdu spd  center_i_cs v_cs     ivcenter_i_cs   cand_cs  scalo_cs    if  know < know50
eststo
nlcl cdu spd  center_i_cs v_cs     ivcenter_i_cs   cand_cs  scalo_cs    if  know > know50
eststo
nlcl cdu spd  center_i_cs v_cs     ivcenter_i_cs   cand_cs  scalo_cs  know  know_center_i_cs  know_v_cs  know_ivcenter_i_cs   know_cand_cs  know_scalo_cs if  sample_cs1        
eststo


* CDU-SPD model; Banzhaf

nlcl cdu spd  center_i_cs b_rat_cs ibrcenter_i_cs  cand_cs  scalo_cs  know  if  sample_cs2        
eststo
sum know if  sample_cs2, detail
scalar know50 =`r(p50)'
nlcl cdu spd  center_i_cs b_rat_cs ibrcenter_i_cs  cand_cs  scalo_cs    if  know < know50    
eststo
nlcl cdu spd  center_i_cs b_rat_cs ibrcenter_i_cs  cand_cs  scalo_cs    if  know > know50   
eststo
nlcl cdu spd  center_i_cs b_rat_cs ibrcenter_i_cs  cand_cs  scalo_cs  know  know_center_i_cs  know_b_rat_cs  know_ibrcenter_i_cs   know_cand_cs  know_scalo_cs if  sample_cs2        
eststo



* fragment allows to be scaled and input in tex-file
#delimit 
esttab  using RnRtable_new_csk.tex, b(%9.3f) se(%9.3f)  booktabs title(\sc Determinants of Coalition Weight $\alpha$ for CDU-SPD coalition) nonumbers
 varlabels(gamma0:_cons "Intercept" gamma1:_cons "{$\Delta$}Ideological Centrality" gamma2:_cons "Bargaining Power" 
 gamma3:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power" 
 gamma4:_cons "{$\Delta$}Leader Evaluation" gamma5:_cons "{$\Delta$}Party Preference" gamma6:_cons "Political Knowledge"
 gamma7:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Pol.~Knowledge" gamma8:_cons "Barg.~Power{$\times$}Pol.~Knowledge" 
 gamma9:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power{$\times$}Pol.~Knowledge" 
 gamma10:_cons "{$\Delta$}Leader Evaluation{$\times$}Pol.~Knowledge" gamma11:_cons "{$\Delta$}Party Preference{$\times$}Pol.~Knowledge")
 mgroups("Party Size" "Banzhaf Index", pattern(1 0 0 0 1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
 alignment(D{.}{.}{-1}) sfmt(%9.2f)   eqlabels(none) mtitles("All" "Novices" "Experts" "All" "All" "Novices" "Experts" "All") 
 stats(N rmse , fmt(%9.0f %9.2f) labels("\sc Observations" "\sc Root MSE")) label
 replace nonotes addnote("*  p < 0.10; ** p < 0.05; *** p < 0.01.")  star(* 0.10 ** 0.05 *** 0.01) 
fragment
;
#delimit cr




************************************************************************
*** Table A14: Determinants of CDU-FDP Coalition Weight: APPENDIX H  ***
************************************************************************

*** CDU-FDP  Models

capture drop sample_*
nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know // Ideo Centrality & Party Size
gen sample_cf1 = e(sample)

nlcl cdu fdp  center_i_cf b_rat_cf ibrcenter_i_cf    cand_cf  scalo_cf  know // Ideo Centrality & Banzhaf     
gen sample_cf2 = e(sample)


* CDU-FDP model; Party Size

eststo clear
nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  if  sample_cf1 
eststo
sum know if  sample_cf1, detail
scalar know50 =`r(p50)'
nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf    if  know < know50 
eststo                                                                  
nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf    if  know > know50 
eststo
nlcl cdu fdp  center_i_cf v_cf     ivcenter_i_cf   cand_cf  scalo_cf  know  know_center_i_cf  know_v_cf  know_ivcenter_i_cf   know_cand_cf  know_scalo_cf if  sample_cf1  
eststo


* CDU-SPD model; Banzhaf

nlcl cdu fdp  center_i_cf b_rat_cf ibrcenter_i_cf    cand_cf  scalo_cf  know  if  sample_cf2        
eststo
sum know if  sample_cf2, detail
scalar know50 =`r(p50)'
nlcl cdu fdp  center_i_cf b_rat_cf ibrcenter_i_cf    cand_cf  scalo_cf    if  know < know50     
eststo                                                                    
nlcl cdu fdp  center_i_cf b_rat_cf ibrcenter_i_cf    cand_cf  scalo_cf    if  know > know50   
eststo
nlcl cdu fdp  center_i_cf b_rat_cf ibrcenter_i_cf    cand_cf  scalo_cf  know  know_center_i_cf  know_b_rat_cf  know_ibrcenter_i_cf   know_cand_cf  know_scalo_cf if  sample_cf2        
eststo


* fragment allows to be scaled and input in tex-file
#delimit 
esttab  using RnRtable_new_cfk.tex, b(%9.3f) se(%9.3f)  booktabs title(\sc Determinants of Coalition Weight $\alpha$ for CDU-SPD coalition) nonumbers
 varlabels(gamma0:_cons "Intercept" gamma1:_cons "{$\Delta$}Ideological Centrality" gamma2:_cons "Bargaining Power" 
 gamma3:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power" 
 gamma4:_cons "{$\Delta$}Leader Evaluation" gamma5:_cons "{$\Delta$}Party Preference" gamma6:_cons "Political Knowledge"
 gamma7:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Pol.~Knowledge" gamma8:_cons "Barg.~Power{$\times$}Pol.~Knowledge" 
 gamma9:_cons "{$\Delta$}Ideol.~Centr.{$\times$}Barg.~Power{$\times$}Pol.~Knowledge" 
 gamma10:_cons "{$\Delta$}Leader Evaluation{$\times$}Pol.~Knowledge" gamma11:_cons "{$\Delta$}Party Preference{$\times$}Pol.~Knowledge")
 mgroups("Party Size" "Banzhaf Index", pattern(1 0 0 0 1 0 0 0)   prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
 alignment(D{.}{.}{-1}) sfmt(%9.2f)   eqlabels(none) mtitles("All" "Novices" "Experts" "All" "All" "Novices" "Experts" "All") 
 stats(N rmse , fmt(%9.0f %9.2f) labels("\sc Observations" "\sc Root MSE")) label
 replace nonotes addnote("*  p < 0.10; ** p < 0.05; *** p < 0.01.")  star(* 0.10 ** 0.05 *** 0.01) 
fragment
;
#delimit cr







exit

