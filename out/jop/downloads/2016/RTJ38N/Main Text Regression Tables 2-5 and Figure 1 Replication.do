/*******************************************************************************

Stewart and Liou Replication Code
"Do Good Borders Make Good Rebels?"

This Code replicates analyses shown in Tables 2-5 and Figure 1 of the Main Text

Code Last Modified 6/15/2016 (Yu-Ming Liou)

*******************************************************************************/

use "C:\Users\Yu-Ming Liou\Dropbox\Insurgency Safe Haven\JOP Replication\Regression Replication.dta", clear

set more off

********************************************************************************
*	NB:
*	bd_log is ln(bdeadbes)
********************************************************************************

xtset countrynum

********************************************************************************
********************************************************************************

*	Main Text Table 2

********************************************************************************
********************************************************************************

set seed 8181983

*	Model 1: Base Model (includes everything) with country and year fixed effects

bootstrap: xtreg  oneside_best_log exterrdum_low terrdum bd_log ///
 strengthcent_ord rebstrength_ord  nonmilsupport rebestsize ///
 l1popdensity   l1gdppc_log l1gdppc_change yeardum44-yeardum57, i(countrynum) fe
 
*	Model 2: Insurgency-level random effects (cannot use FE b/c measures are "sticky")
	*	NB: THERE IS VARIATION, just not a lot.

xtset insurgentnum year

bootstrap: xtreg  oneside_best_log bd_log exterrdum_low terrdum ///
 strengthcent_ord rebstrength_ord  nonmilsupport rebestsize ///
 l1popdensity   l1gdppc_log l1gdppc_change yeardum44-yeardum57, re

xtset countrynum

set seed 8181983

*	Model 3: Country-level characteristics only (country and year FE)  
bootstrap: xtreg  oneside_best_log bd_log exterrdum_low terrdum ///
  l1popdensity   l1gdppc_log l1gdppc_change yeardum44-yeardum57, i(countrynum) fe
  
*	Model 4: Group characteristics only (no FE)
bootstrap: xtreg  oneside_best_log bd_log exterrdum_low terrdum ///
 strengthcent_ord rebstrength_ord  nonmilsupport rebestsize 
  
*	Plain regression (no RE or FE)
bootstrap: xtreg  oneside_best_log bd_log exterrdum_low terrdum ///
 strengthcent_ord rebstrength_ord  nonmilsupport rebestsize ///
 l1popdensity   l1gdppc_log l1gdppc_change
  
set seed 8181983

********************************************************************************
********************************************************************************

*	Main Text Tables 3-5

********************************************************************************
******************************************************************************** 

gen total_border_ln = log(total_border) 

*	Model 1: Base IV Model
xtivreg2 oneside_best_log bd_log terrdum strengthcent_ord rebstrength_ord ///
 yeardum44-yeardum57 nonmilsupport rebestsize ///
 l1popdensity l1gdppc_log  l1gdppc_change ///
 (exterrdum_low=total_border_ln), fe first robust savefirst
 
*	Model 2: Base IV Model sans country-level predictors
xtivreg2 oneside_best_log bd_log terrdum strengthcent_ord rebstrength_ord ///
 yeardum44-yeardum57 nonmilsupport rebestsize ///
 (exterrdum_low=total_border_ln), fe first robust savefirst	
 
*	Model 3: Overidentified model
ivreg2 oneside_best_log bd_log terrdum strengthcent_ord rebstrength_ord ///
 yeardum44-yeardum57 countrydum2-countrydum88 nonmilsupport rebestsize ///
 l1popdensity l1gdppc_log  l1gdppc_change ///
 (exterrdum_low=total_border_ln total), first robust redundant(total_border_ln)  ///
 partial(countrydum2-countrydum88) savefirst savefprefix(first)

*	Model 4: Overidentified model minus country level predictors
ivreg2 oneside_best_log bd_log terrdum strengthcent_ord rebstrength_ord ///
 yeardum44-yeardum57 countrydum2-countrydum88 nonmilsupport rebestsize ///
  (exterrdum_low=total_border_ln total), first robust redundant(total)  ///
 partial(countrydum2-countrydum88) savefirst  

********************************************************************************
********************************************************************************

*	Figure 1a

********************************************************************************
******************************************************************************** 

********************************************************************************
*	NB:
*	bd_log is ln(bdeadbes)
********************************************************************************


*	BASE MODEL
*	Use LSDV model (equivalent to xtreg with fe) so that eform option is available 
*	THIS MEANS THAT P-VALUES AND CIs ARE CORRECT
reg  oneside_best_log exterrdum_low terrdum bd_log ///
 strengthcent_ord rebstrength_ord  nonmilsupport rebestsize ///
 l1popdensity   l1gdppc_log l1gdppc_change ///
 yeardum44-yeardum57 countrydum2-countrydum88, eform(GM_ratio) robust 
 
 *	Combined Plot with Base Model
margins, at((mean)_all exterrdum_low=0 terrdum=1 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) ///
at((mean)_all exterrdum_low=0 terrdum=0 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) /// 
at((mean)_all exterrdum_low=1 terrdum=1 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) ///
at((mean)_all exterrdum_low=1 terrdum=0 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0)

marginsplot, plotopts(c(none) mcolor(black)) legend(off) graphregion(color(white))   ///
ciopts(lcolor(black)) ylabel(, angle(horizontal) notick labsize(medlarge)) ///
 xscale(range(.7(.5)4.3) titlegap(4)) xlabel(1 "Domestic" 2 "None" 3 "Both" 4 "Foreign", labsize(medlarge) nogrid notick) /// 
 yscale(range(-1 3) titlegap(4)) ytitle("", size(large)) ylabel(-1(1)3) ///
 ytitle("Proportion of (Geometric) Mean", size(large)) ///
 xtitle("Territorial Control", size(large))  ///
 title("") ///
 yline(1)

********************************************************************************
********************************************************************************

*	Figure 1b

********************************************************************************
******************************************************************************** 
 
ivreg2 oneside_best_log bd_log terrdum strengthcent_ord rebstrength_ord ///
 yeardum44-yeardum57 nonmilsupport rebestsize ///
 l1popdensity l1gdppc_log  l1gdppc_change countrydum2-countrydum88 ///
 (exterrdum_low=total_border_ln), robust eform(GM_Ratio)
 
*	Combined Plot with Base Model
margins, at((mean)_all exterrdum_low=0 terrdum=1 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) ///
at((mean)_all exterrdum_low=0 terrdum=0 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) /// 
at((mean)_all exterrdum_low=1 terrdum=1 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) ///
at((mean)_all exterrdum_low=1 terrdum=0 strengthcent_ord=2 rebstrength_ord=2 nonmilsupport=0) post

marginsplot, plotopts(c(none) mcolor(black)) legend(off) graphregion(color(white))   ///
ciopts(lcolor(black)) ylabel(, angle(horizontal) notick labsize(medlarge)) ///
 xscale(range(.7(.5)4.3) titlegap(4)) xlabel(1 "Domestic" 2 "None" 3 "Both" 4 "Foreign", labsize(medlarge) nogrid notick) /// 
 ysca(titlegap(4)) ytitle("", size(large)) ///
 ytitle("Proportion of (Geometric) Mean", size(large)) ///
 xtitle("Territorial Control", size(large))  /// 
 yline(1) ///
 title("") 
 
test _b[1._at]=_b[4._at]
*	X^2=6.44, p=0.0112 
test _b[2._at]=_b[4._at]
*	X^2=5.00, p=0.0254
test _b[3._at]=_b[4._at]
*	X^2=2.81, p=0.0938 
