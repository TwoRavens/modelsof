
*** Electoral Rule Disproportionality and Platform Polarization ***

* Konstantinos Matakos (LSE & King's College, London), Orestis Troumpounis (Lancaster University Management School), and Dimitrios Xefteris (University of Cyprus) *

*** This version: 01 September 2015 ***
******************************************************************************************************************************
use MTX_2015_ajps.dta, clear
// opens the analysis data file 

gen regime_type=1 if regime==1
replace regime_type=1 if regime==2
replace regime_type=0 if regime==0

gen govcoal=1 if gov_type==2 
replace govcoal=1 if gov_type==3
replace govcoal=1 if gov_type==5
replace govcoal=0 if gov_type==1
replace govcoal=0 if gov_type==4
replace govcoal=0 if gov_type==6
*** generates variable govcoal that takes the value of 1 if there is a coaltion government and 0 otherwise *** 

gen ENP_coal=ENP*govcoal
*** generates the interaction term between ENP and govcoal variables ***

gen ln_ENP = ln(ENP)
*** takes the natural log of the variable ENP *** 

gen ln_dist_magn = ln(dist_magn)
*** takes the natural log of the mean electoral district magnitude ***

tab yearnum2, gen(yeard)
*** generates year dummies ***

tab countryn, gen(countryd)
*** generates country dummies ***


* Table 1 *

*Column 1*
regress polarisation fptp ENP, vce(cl countryn)
*Column 2*
regress polarisation fptp ENP yeard1-yeard48, vce(cl countryn)
*Column 3*
regress polarisation n ENP yeard1-yeard48, vce(cl countryn) 
*Column 4: 
regress polarisation fptp ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48, vce(cl countryn)
*Column 5: 
regress polarisation n ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48, vce(cl countryn) 
*Column 6: 
regress polarisation fptp ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 7: 
regress polarisation n ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 8: 
xtreg polarisation fptp ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_new gov_gap yeard1- yeard48, re vce(cl countryn)
*Column 9: 
xtreg polarisation n ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_new gov_gap yeard1-yeard48, re vce(cl countryn)


* Table 2 *

*Column 1: 
regress polarisation fptp ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 2: 
regress polarisation n ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 3: 
xtreg polarisation fptp ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48, re vce(cl countryn)
*Column 4: 
xtreg polarisation n ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48, re vce(cl countryn)
*Column 5: 
regress polarisation2 fptp ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 6: 
regress polarisation2 n ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 7: 
xtreg polarisation2 fptp ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48, re vce(cl countryn)
*Column 8: 
xtreg polarisation2 n ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48, re vce(cl countryn)

*** Table 3 ***
* see the end of the do file *

** All figures and graphs in the main text are not produced from data and are graphical expositions of the formal results **
 

*** Online Appendix ***

* Table A.1 not produced from data (literature summary) * 

* Table A.2 (Summary statistics) *

sum fptp n regime_type govcoal polarisation polarisation2 dist_magn ln_dist_magn age_democracy ENP num_parties pig instcons

* Table A.3 *

*Column 1: 
regress polarisation fptp ln_ENP yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 2: 
regress polarisation fptp ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 3: 
regress polarisation ln_dist_magn ln_ENP yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 4: 
regress polarisation ln_dist_magn ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 5: 
reg polarisation2 fptp ln_ENP yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 6: 
regress polarisation2 fptp ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 7: 
regress polarisation2 ln_dist_magn ln_ENP yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 8: 
reg polarisation2 ln_dist_magn ln_ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)


***Table A.4 ***

*Column 1: 
regress polarisation2 fptp ENP yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 2: 
*same specification as in Column 5, Table A.3 above *
*Column 3: 
regress polarisation2 fptp num_parties yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 4: 
regress polarisation2 ln_dist_magn ENP yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 5: 
*same specification as in Column 7, Table A.3 above *
*Column 6: 
regress polarisation2 ln_dist_magn num_parties yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 7: 
regress polarisation2 fptp ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)
*Column 8: 
regress polarisation2 ln_dist_magn ENP govcoal ENP_coal pig regime_type age_democracy instcons gov_chan gov_gap yeard1-yeard48 countryd1-countryd23, vce(cl countryn)

*** Table 3 ***
* Greece 1974 - 1993 * 
sum polarisation2 if countryn==9&yearnum<1989
sum polarisation2 if countryn==9&yearnum>=1989&yearnum<1993
* use the estimates above to conduct the test*
ttesti 3 3.13 .15 4 2.22 .664 , unequal

* Greece 1989 - 2004 *
sum polarisation2 if countryn==9&yearnum>=1989&yearnum<1993
sum polarisation2 if countryn==9&yearnum>=1993
*use the estimates above to conduct the test*
ttesti 4 1.83 .597 3 3.13 .15, unequal

* New Zealand 1963 - 2005 *
sum polarisation2 if countryn==16&yearnum<1994
sum polarisation2 if countryn==16&yearnum>1994
* use the estimates above to conduct the test *
ttesti 4 3.57 .30 12 1.4 .472, unequal

* Italy 1963 - 2005  * 
replace polarisation2=1.69 if countryn==12&yearnum==1994
replace polarisation2=1.38 if countryn==12&yearnum==1996
replace polarisation2=1.47 if countryn==12&yearnum==2001
* replaces polarization with the MDP index for the FPTP component of the elections *
sum polarisation2 if countryn==12&yearnum<1993
sum polarisation2 if countryn==12&yearnum>1993&yearnum<=2005
* use the estimates above to conduct the test *
ttesti 3 1.51 .159 8 2.31375 .949, unequal  
* Note: for the FPTP component of the elections the MDP index was constructed by taking the difference between the two most distant pre-electoral pacts (for further details see the documentation file) *

*** All other figures and graphs in the appendix are not produced from data *** 
