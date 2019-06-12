**************************************************************************************************
*			                       Replication file for:     		           	        	     *
*    "Employment effects of Chinese trade competition in 17 sectors across 18 OECD countries"    *
*																						 		 *			
* Author: 			Stefan Thewissen and Olaf van Vliet                                   		 *
* Contact: 			stefan.thewissen@spi.ox.ac.uk                                              	 *
* Date: 			26th of July 2017                                                     		 *
* Version:			Stata 14                                                              		 *                                                                          
* Dataset:          Dragon_dta_file                                           					 *		
* Logfile: 			Dragon_log_file.txt															 *
*																								 *
**************************************************************************************************



** Set directory to the location where replication files have been saved, for example:
*cd "/Users/PSRM replication"

** Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year






************************
************************
***** DESCRIPTIVES *****
************************
************************

** How large is relative sectoral employment in the industries we look at (total manufacturing, agric + mining)?
** As we write in our introduction:
/*
"On average across our sample, 23% of all workers are employed in these sectors, 
making it a vital part of the economy and society."
*/

preserve
	keep if inlist(code,"AtB","C","D")
	keep cou year code relempe
	bysort cou year: egen totrelempe = sum(relempe)
	keep if code=="AtB"
	drop code
	sum totrelempe
restore


/*
"Interestingly, the exposure to import and export competition from China varies considerably across sectors. 
This is also reflected by a low correlation between the two measures (0.25)."
*/
pwcorr sicve wexptiindus if id==1 


/* See text:
"... as indicated by a low correlation (0.14) and a much more rapid rise of Chinese imports 
(15.2 instead of 2.0% on average per year for our sample)." 
*/
pwcorr sicve sincve if id==1 

foreach x in sicve sincve {
	bysort indus: egen `x'1990 = mean(`x') if year==1990
	bysort indus: egen `x'2007 = mean(`x') if year==2007
	sort cou year indus
	replace `x'2007=`x'2007[_n+306] if year==1990
	gen `x'diff = ((`x'2007/`x'1990)^(1/(2007-1990))-1)*100
}
format *diff %9.1fc
list class *diff if year==1990 & cntry==1 & class=="Total", sep(0) noo
drop *diff *1990 *2007



** In Section 3.4 we conduct cointegration tests. See text for descriptions of the models we run:
xtset cs year

** If predicted errors coefficient is negative and significant: cointegration
foreach var of varlist relempe {
	qui reg `var' sicve wexptiindus capitrve va_qi sincve i.indus if id==1
	predict res, residuals
	reg d.`var' l.d.`var' res d.sicve d.wexptiindus d.capitrve d.va_qi d.sincve i.indus if id==1
	drop res
}

foreach var of varlist h_ls {
	qui reg `var' sicve wexptiindus capitrve va_qi sincve adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol i.indus if id==1 
	predict res`var', residuals
	reg d.`var' l.d.`var' res`var' d.sicve d.wexptiindus d.capitrve d.va_qi d.sincve d.adjcovpol d.coord d.eprc_v1 d.ept_v1 d.rrapwpol d.unem d.gdpcap d.gov_left1 d.lhcpol i.indus if id==1 
	drop res`var'
}







********************************************************************
***** FIGURE 2: Evolution Chinese imports and exports exposure *****
********************************************************************

** Figure 2: Evolution Chinese imports and exports exposure
preserve
	* Putting Chinese imports as % GDP
	replace sicve = sicve * 1000
	
	* Generating an average for import competition (sicve) and export competition (wexptiindus) for each year for included industries
	foreach var of varlist sicve wexptiindus {
		bysort year: egen m`var'=mean(`var') if id==1
	}

	* Plotting the actual lines
	tsline msicve if cou=="USA", yti("% of value added") ti("Chinese imports exposure") legend(label(1 "%")) xti("Year") scheme(s1mono) name(panela, replace) nodraw
	tsline mwexptiindus if cou=="USA", yti("Chinese exports exposure index") ti("Chinese exports exposure") legend(label(1 "%")) xti("Year") scheme(s1mono) name(panelb, replace) nodraw

	graph combine panela panelb, title("") scheme(s1mono) 
	graph export "Figure_2.pdf", replace

restore



*************************************************
***** TABLE 1: Imports and exports exposure *****
*************************************************

** Table 1: Imports and exports exposure
preserve
	sort cou year indus

	* Putting sicve (Chinese imports) back as % GDP
	replace sicve = sicve * 1000

	* We calculate absolute difference for import (sicve) and export competition (wexptiindus) per industry for first (1990) and last year (2007)
	foreach x in wexptiindus sicve {
		bysort indus: egen `x'1990 = mean(`x') if year==1990
		bysort indus: egen `x'2007 = mean(`x') if year==2007
		sort cou year indus
		replace `x'2007=`x'2007[_n+306] if year==1990
		gen `x'diff = `x'2007-`x'1990
	}
	
	//Keeping one single observation
	keep if year==1990 & cntry==1 & class~="Total"
	keep class code sicve1990 sicve2007 sicvediff wexptiindus1990 wexptiindus2007 wexptiindusdiff
	//Creating an average (leaving out man. coke chemicals rubber, and total manufacturing to avoid duplicates)
	expand 2 if code=="36t37"
	replace class = "Average" if class == "Man. n.e.c." & class[_n-1] == "Man. n.e.c."
	replace code = "" if class== "Average"
	foreach v of varlist sicve1990 sicve2007 sicvediff wexptiindus1990 wexptiindus2007 wexptiindusdiff {
		replace `v' = . if class=="Average"
		qui sum `v' if !inlist(class,"Average","Total manufacturing","Man. coke, chemicals, rubber")
		replace `v' = r(mean) if class=="Average"
	}
	
	
	format sicve1990 sicve2007 sicvediff %9.1fc
	format wexptiindus1990 wexptiindus2007 wexptiindusdiff %9.2fc
	
	list class sicve1990 sicve2007 sicvediff wexptiindus1990 wexptiindus2007 wexptiindusdiff, sep(0) noo
restore




***********************
***********************
***** REGRESSIONS *****
***********************
***********************


** Defining the models (the vector of independent variables) als globals

** The exact vector of independent variables depend on (1) the independent variable and (2) the model specification (error correction model (ECM) or partial adjustment model (PA)
global controlecmrelempe 	"d.sicve l.sicve d.wexptiindus l.wexptiindus d.sincve l.sincve d.capitrve l.capitrve d.va_qi l.va_qi i.indus"
global controlecmh_ls 		"d.sicve l.sicve d.wexptiindus l.wexptiindus d.sincve l.sincve d.capitrve l.capitrve d.va_qi l.va_qi l.adjcovpol l.coord l.gov_left1 l.eprc_v1 l.ept_v1 l.rrapwpol l.lhcpol l.unem l.gdpcap i.indus"

global controlparelempe 	"sicve wexptiindus sincve capitrve va_qi i.indus"
global controlpah_ls 		"sicve wexptiindus sincve capitrve va_qi adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap i.indus"




***************************************************************************************
***** TABLE 2: Chinese import and export competition and relative employment size *****
***************************************************************************************

eststo clear
	eststo: quietly xtpcse d.relempe l.relempe  $controlecmrelempe, c(psar1), if id==1 
		display(1-(1-e(r2))*(e(N)-1)/(e(N)-e(df)-1))
	eststo: quietly xtpcse relempe  l.relempe 	$controlparelempe, 	c(psar1), if id==1 	
		display(1-(1-e(r2))*(e(N)-1)/(e(N)-e(df)-1))
esttab, order(l.relempe l.h_ls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Table 2: Chinese import and export competition and relative employment size) 


***************************************************************************************
***** TABLE 3: Chinese import and export competition and hours worked low-skilled *****
***************************************************************************************

eststo clear
	eststo: quietly xtpcse d.h_ls 	 l.h_ls 	$controlecmh_ls, 	c(psar1), if id==1 
		display(1-(1-e(r2))*(e(N)-1)/(e(N)-e(df)-1))
	eststo: quietly xtpcse h_ls		l.h_ls 		$controlpah_ls, 	c(psar1), if id==1 
		display(1-(1-e(r2))*(e(N)-1)/(e(N)-e(df)-1))
esttab, order(l.relempe l.h_ls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Table 3: Chinese import and export competition and hours worked low-skilled) 

	
	

*****************************
*****************************
***** SENSITIVITY TESTS *****
*****************************
*****************************


** Sensitivity test 1: Include total exports in %VA to China and conduct with net imports 

** ECM
eststo clear
	eststo: quietly xtpcse d.relempe l.relempe $controlecmrelempe, c(psar1), if id==1 
	eststo: quietly xtpcse d.relempe l.relempe $controlecmrelempe, c(psar1), if id==1 & d.secve~=.
	eststo: quietly xtpcse d.relempe l.relempe $controlecmrelempe d.secve l.secve, c(psar1), if id==1 
	
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls, c(psar1), if id==1 
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls, c(psar1), if id==1 & d.secve~=. 
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls  d.secve l.secve, c(psar1), if id==1 

esttab, order(l.relempe l.h_ls) p compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Sensitivity 1a with exports to China ECM) mtitle("original" "d.secve sample" "d.secve" "original" "d.secve sample" "d.secve")

** PA
eststo clear
	eststo: quietly xtpcse relempe  l.relempe 	$controlparelempe, c(psar1), if id==1 
	eststo: quietly xtpcse relempe  l.relempe 	$controlparelempe, c(psar1), if id==1 & secve~=.
	eststo: quietly xtpcse relempe  l.relempe 	$controlparelempe secve, c(psar1), if id==1 
	
	eststo: quietly xtpcse h_ls 	l.h_ls 		$controlpah_ls, c(psar1), if id==1 
	eststo: quietly xtpcse h_ls 	l.h_ls 		$controlpah_ls, c(psar1), if id==1 & secve~=. 
	eststo: quietly xtpcse h_ls 	l.h_ls 		$controlpah_ls secve, c(psar1), if id==1 

esttab, order(l.relempe l.h_ls) p compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Sensitivity 1b with exports to China PA) mtitle("original" "secve sample" "secve" "original" "secve sample" "secve")


** Sensitivity test 2: Other emerging countries


* Checking growth rates (
sum sicve emicomve if id==1

* Comparing growth rates
foreach x in sicve emicomve {
	bysort indus: egen `x'1990 = mean(`x') if year==1990
	bysort indus: egen `x'2007 = mean(`x') if year==2007
	sort cou year indus
	replace `x'2007=`x'2007[_n+306] if year==1990
	gen `x'diff = ((`x'2007/`x'1990)^(1/(2007-1990))-1)*100
}
list class *diff if year==1990 & cntry==1, sep(0) noo
drop *diff *1990 *2007

** We have to exclude industries 3 and 10, otherwise we cannot apply xtpcse with c(psar1)
xtset cs year

*/First test original regressions without industries 3 and 10. 

** ECM

eststo clear
	eststo: quietly xtpcse d.relempe l.relempe $controlecmrelempe, c(psar1), if id==1 
	eststo: quietly xtpcse d.relempe l.relempe $controlecmrelempe, c(psar1), if id==1 & !inlist(indus,3,10)
	eststo: quietly xtpcse d.relempe l.relempe d.sicve l.sicve d.wexptiindus l.wexptiindus d.emicomve l.emicomve d.sincemcomve l.sincemcomve ///
		d.capitrve l.capitrve d.va_qi l.va_qi i.indus, c(psar1), if id==1 & !inlist(indus,3,10) 

	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls, c(psar1), if id==1 
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls, c(psar1), if id==1 & !inlist(indus,3,10)
	eststo: quietly xtpcse d.h_ls l.h_ls d.sicve l.sicve d.wexptiindus l.wexptiindus d.emicomve l.emicomve d.sincemcomve l.sincemcomve ///
		d.capitrve l.capitrve d.va_qi l.va_qi ///
		l.adjcovpol l.coord l.gov_left1 l.eprc_v1 l.ept_v1 l.rrapwpol l.lhcpol l.unem l.gdpcap i.indus, c(psar1), if id==1 & !inlist(indus,3,10)

esttab, p compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Sensitivity 2a Other emerging ECM) mtitle("relempe orig" "excl 3 and 10" "+other emerging" "h_ls orig" "excl 3 and 10" "+other emerging")

	
** PA
	
eststo clear
	eststo: quietly xtpcse relempe l.relempe $controlparelempe, c(psar1), if id==1 
	eststo: quietly xtpcse relempe l.relempe $controlparelempe, c(psar1), if id==1 & !inlist(indus,3,10)
	eststo: quietly xtpcse relempe l.relempe sicve wexptiindus emicomve sincemcomve ///
		capitrve va_qi i.indus, c(psar1), if id==1 & !inlist(indus,3,10) 

	eststo: quietly xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 
	eststo: quietly xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 & !inlist(indus,3,10)
	eststo: quietly xtpcse h_ls l.h_ls sicve wexptiindus emicomve sincemcomve ///
		capitrve va_qi ///
		adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap i.indus, c(psar1), if id==1 & !inlist(indus,3,10)

esttab, p compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Sensitivity 2b Other emerging PAM) mtitle("relempe orig" "excl 3 and 10" "+other emerging" "h_ls orig" "excl 3 and 10" "+other emerging")
		
		
** Sensitivity 3: FDI

preserve
xtset cs year

*/For FDI data code="20" is actually code=="20t22" and code="27t28" is actually code=="27t29"

*/So for other sectoral data we have to fill 20 with a corrected version of 20 and 20t22
*/capitrve va_qi wexptiindus: a weighted average
sort cou year indus
foreach var of varlist capitrve wexptiindus {
	replace `var' = `var'*va/(va+va[_n+1]) + `var'[_n+1]*va[_n+1]/(va+va[_n+1]) if code=="20"
}

*/All trade data: sum absolute nominators and denominators and regenerate the fractions
foreach var of varlist vad sicd sincd {
	replace `var' = `var' + `var'[_n+1] if code=="20"
}

foreach x in sic sinc {
	replace `x've = `x'd/vad*100
}

replace code="20t22" if code=="20"

*/So for other sectoral data we have to fill 20 with a corrected version of 27t28 and 29
*/capitrve va_qi wexptiindus: a weighted average
sort cou year indus
foreach var of varlist capitrve wexptiindus {
	replace `var' = `var'*va/(va+va[_n+1]) + `var'[_n+1]*va[_n+1]/(va+va[_n+1]) if code=="27t28"
}

*/all trade data: sum absolute nominators and denominators and regenerate the fractions
foreach var of varlist vad sicd sincd {
	replace `var' = `var' + `var'[_n+1] if code=="27t28"
}
foreach x in sic sinc {
	replace `x've = `x'd/vad*100
}

replace code="27t29" if code=="27t28"

xtset cs year

*/Placing FDI in percentage of value added: use VA from EU-KLEMS, both are in national currency 
foreach var of varlist fdiflowir fdiflowor fdiposir fdiposor {
	gen `var'va = `var'/va*100
	label var `var'va "`var' in %value added EU-KLEMS"
}

pwcorr fdiflowirva-fdiposorva sicve wexptiindus


*/The data contains so many gaps that xtpcse is no option at all, so many countries and industries need to be dropped, and it would still not work. We fall back to xtregar
foreach y of varlist fdiflowirva-fdiposorva {
	eststo clear
		eststo: quietly xtregar relempe sicve wexptiindus sincve capitrve va_qi `y' i.indus, fe, if id==1
		eststo: quietly xtregar h_ls 	sicve wexptiindus sincve capitrve va_qi `y' adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap i.indus, fe, if id==1 
		esttab, p compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
			title(Sensitivity 3a FDI `y' xtregar) mtitle("relempe" "h_ls")
}

foreach y of varlist fdiflowirva-fdiposorva {
	eststo clear
		eststo: quietly xtregar relempe l.relempe 	sicve wexptiindus sincve capitrve va_qi `y' i.indus, fe, if id==1
		eststo: quietly xtregar h_ls 	l.h_ls		sicve wexptiindus sincve capitrve va_qi `y' adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap i.indus, fe, if id==1 
		esttab, p compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
			title(Sensitivity 3b FDI `y' xtregar) mtitle("relempe" "h_ls")
}

restore


** Sensitivity 4: Minimum wage

eststo clear
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls, c(psar1), if id==1 
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls, c(psar1), if id==1 & l.minwagemean~=.
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls l.minwagemean i.indus, c(psar1), if id==1 
	eststo: quietly xtpcse d.h_ls l.h_ls $controlecmh_ls l.minwagemedian i.indus, c(psar1), if id==1 
esttab, compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Sensitivity 4a minimum wage ECM) mtitle("original" "min wage sample" "min wage mean" "min wage median")
		

eststo clear
	eststo: quietly xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 
	eststo: quietly xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 & minwagemean~=.
	eststo: quietly xtpcse h_ls l.h_ls $controlpah_ls minwagemean i.indus, c(psar1), if id==1 
	eststo: quietly xtpcse h_ls l.h_ls $controlpah_ls minwagemedian i.indus, c(psar1), if id==1 
esttab, compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop (*.indus) ///
	title(Sensitivity 4b minimum wage PA) mtitle("original" "min wage sample" "min wage mean" "min wage median")
	




*******************************
*******************************
***** DYNAMIC SIMULATIONS *****
*******************************
*******************************


********************************************************************************
*** Figure 3: Simulated long term effects of Chinese import competition and ****
*************** technological change on relative employment size *************** 
********************************************************************************

** Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

xtset cs year

global controlparelempe 	"sicve wexptiindus sincve capitrve va_qi i.indus"

* Generating auxiliary variables for the simulations
sum indus
forv i = 1(1)18 {
	gen indusx`i' = 1 if indus==`i'
	replace indusx`i' = 0 if indusx`i'~=1
}

xtset cs year

gen lrelempe = l.relempe
gen lh_ls = l.h_ls

* Calculating the 5% and 95% values 
foreach v of varlist sicve capitrve wexptiindus {
	
	di "`v'"
	qui sum `v' if id==1 & relempe~=. & l.relempe~=. & sicve~=. & wexptiindus~=. & sincve~=. & capitrve~=. & va_qi~=., d
	local low = r(p5)
	local high = r(p95)
	di "low"
	list cou year classification `v' if `v'<= `low' & cou=="CAN" 
	di "high"
	list cou year classification `v' if `v'>=  `high' & cou=="CAN" & `v'~=.
	
}

* Evaluating for tech change & import competition
xtpcse relempe l.relempe $controlparelempe, c(psar1), if id==1
est sto model1
est restore model1

foreach v of varlist sicve wexptiindus capitrve {
	di "`v'"
	qui sum `v' if e(sample)==1, d
	di r(p5)
	di r(p95)
}

* Defining the median of the LDV for the regression sample
sum l.relempe if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309

* With the industry dummies, we have 22 variables
drawnorm SN_b1-SN_b22, n(10000) means(e(b)) cov(e(V)) clear

* Close all open postfiles
postutil clear

* Declare variable names and filename of dataset where results will be saved
postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

* Each scenario begins with the lagged value and adjusts to the previous year’s estimate as the simulation progresses
local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'

* These are the 10 years
local a=0 
while `a' <= 10 { 
	{		

* Mind the other of b coefficients. See above when doing ereturn list. b(22) is the intercept with all the industry dummies.
		scalar h_sicve			= .0080549	
		scalar h_wexptiindus	= -.0751575
		scalar h_sincve 		= .2165022
		scalar h_capitrve 		= .0284745
		scalar h_va_qi 			= 114.3623
		
* sicve at p(5) = .00010967
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .00010967  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

* sicve at p(95)  = .03616054
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .03616054  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

										
* capitrve at p(5) = .00134799					
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .00134799		///
                            + SN_b6* h_va_qi		///
							+ SN_b20* 1				///
                            + SN_b22*1
							
* capitrve at p(95) = .07246957									
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .07246957		///
                            + SN_b6* h_va_qi		///
							+ SN_b20* 1				///
                            + SN_b22*1 														

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

* This draws the confidence intervals			
			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims			
                               

graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted relative employment size", size(3))							///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 5% and 95%" 3 "Technological change at 5% and 95%" ) )
					
graph export "Figure_3.pdf", replace

drop _merge




***************************************************************************************
********* Figure 4: Simulated long-term effects of Chinese import competition, ********
*** Chinese export competition and technological change on hours worked low-skilled *** 
***************************************************************************************

** This figure is ran into two steps, and then combined in other software
** In this step we simulate shocks in import and export competition

** See for more explanation in the steps we take here the descriptions for Figure 3 (above)

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

global controlpah_ls 		"sicve wexptiindus sincve capitrve va_qi adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap i.indus"

* Generating auxiliary variables for the simulations
sum indus
forv i = 1(1)18 {
	gen indusx`i' = 1 if indus==`i'
	replace indusx`i' = 0 if indusx`i'~=1
}

xtset cs year

gen lrelempe = l.relempe
gen lh_ls = l.h_ls



xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 
	est sto model1
	ereturn list
	mat li e(b)
* The intercept is the last entrance in the b-coefficient matrix. The matrix is 1 x 31. 
	
	
foreach x in sicve wexptiindus sincve capitrve va_qi adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap {
	qui sum `x' if e(sample)==1
	di "`x'"
	di r(mean)
} 

qui sum sicve if e(sample)==1, d
di "sicve"
di r(p5)
di r(p95)

qui sum wexptiindus if e(sample)==1, d
di "wexptiindus"
di r(p5)
di r(p95)

qui sum capitrve if e(sample)==1, d
di "capitrve"
di r(p5)
di r(p95)

est restore model1

* Defining the median of the LDV for the regression sample
sum l.h_ls if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309

* In this draw for h_ls it becomes 

drawnorm SN_b1-SN_b31, n(10000) means(e(b)) cov(e(V)) clear

* Close all open postfiles
postutil clear

* Declare variable names and filename of dataset where results will be saved
postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years simulated

local a=0 
while `a' <= 10 { 
	{		

* Mind the other of b coefficients. See above when doing ereturn list. b(31) is the intercept with all the industry dummies.

		scalar h_sicve			= .00670653	
		scalar h_wexptiindus	= -.07931103
		
		scalar h_sincve			= .20569587
		scalar h_capitrve		= .02842318
		scalar h_va_qi			= 110.81575
		
		scalar h_adjcovpol		= 68.048812
		scalar h_coord			= 3.0492921
		scalar h_gov_left1		= 35.698254
		scalar h_eprc_v1		= 2.1603919
		scalar h_ept_v1			= 1.695759
		scalar h_rrapwpol		= .55502319
		scalar h_lhcpol			= 12.808864
		scalar h_unem			= 8.1012754
		scalar h_gdpcap			= 30.986734
		


* sicve at p(5) 
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .00010629  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
					
						
* sicve at p(95)  
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .03106327  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
		
* wexptiindus at p(5)					
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* -.32018423		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
							
* wexptiindus at p(95)								
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* .03433738		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 				

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

* Potentially this draws the confidence intervals			
			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims
                               

graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted share of hours worked low-skilled", size(3))					///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 5% and 95%" 3 "Export competition at 5% and 95%" ) )

graph export "Figure_4A.pdf", replace
drop _merge








** This is part 2 of Figure 4
** In this step we simulate shocks in import and technological change

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

xtset cs year
xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 
	est sto model1
	ereturn list
	mat li e(b)

est restore model1

* Defining the median of the LDV for the regression sample
sum l.h_ls if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309

* In this draw for h_ls it becomes 

drawnorm SN_b1-SN_b31, n(10000) means(e(b)) cov(e(V)) clear

* Close all open postfiles
postutil clear

* Declare variable names and filename of dataset where results will be saved
postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years simulated

local a=0 
while `a' <= 10 { 
	{		

* Mind the other of b coefficients. See above when doing ereturn list. b(31) is the intercept with all the industry dummies.

		scalar h_sicve			= .00670653	
		scalar h_wexptiindus	= -.07931103
		
		scalar h_sincve			= .20569587
		scalar h_capitrve		= .02842318
		scalar h_va_qi			= 110.81575
		
		scalar h_adjcovpol		= 68.048812
		scalar h_coord			= 3.0492921
		scalar h_gov_left1		= 35.698254
		scalar h_eprc_v1		= 2.1603919
		scalar h_ept_v1			= 1.695759
		scalar h_rrapwpol		= .55502319
		scalar h_lhcpol			= 12.808864
		scalar h_unem			= 8.1012754
		scalar h_gdpcap			= 30.986734
		
* sicve at p(5) 
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .00010629  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
					
						
* sicve at p(95)  
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .03106327  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 

* capitrve at p(5): .00151658				
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .00151658		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
							
* capitrve at p(95): .07158607								
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .07158607		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 				

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

* This draws the confidence intervals			
			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims
                               

graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted share of hours worked low-skilled", size(3))					///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 5% and 95%" 3 "Technological change at 5% and 95%" ) )

graph export "Figure_4B.pdf", replace
drop _merge





**********************
**********************
***** APPENDICES *****
**********************
**********************


****************************************************
***** Table A1: Descriptives of main variables *****
****************************************************

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

foreach x in relempe h_ls sicve wexptiindus sincve capitrve va_qi ///
	adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap {
		sum `x' if id==1
}


*******************************************************************************************
***** Table A4: Chinese import and export competition and wage bill share low-skilled *****
*******************************************************************************************

eststo clear
	eststo: quietly xtpcse d.labls 	 l.labls 	$controlecmh_ls, 	c(psar1), if id==1 
			display(1-(1-e(r2))*(e(N)-1)/(e(N)-e(df)-1))
	eststo: quietly xtpcse labls	l.labls 	$controlpah_ls, 	c(psar1), if id==1 
			display(1-(1-e(r2))*(e(N)-1)/(e(N)-e(df)-1))
esttab, order(l.labls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) drop(*.indus) ///
	title(Table A4: Chinese import and export competition and wage bill share low-skilled) mtitle("ECM" "PA") 
	

***************************************************************************************************************************
***** Figure A1: Simulated long term effects of import competition and export competition on relative employment size *****
***************************************************************************************************************************

** Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

* Generating auxiliary variables for the simulations
sum indus
forv i = 1(1)18 {
	gen indusx`i' = 1 if indus==`i'
	replace indusx`i' = 0 if indusx`i'~=1
}

xtset cs year
gen lrelempe = l.relempe
gen lh_ls = l.h_ls

global controlparelempe 	"sicve wexptiindus sincve capitrve va_qi i.indus"


* Estimating the model, saving as model1
xtpcse relempe l.relempe $controlparelempe, c(psar1), if id==1
	est sto model1
	ereturn list
	mat li e(b)
	
	
* Here I already obtain the descriptives for later
foreach x in sicve wexptiindus sincve capitrve va_qi {
	qui sum `x' if e(sample)==1
	di "`x'"
	di r(mean)
} 

* We evaluate at p(5) and p(95)
qui sum sicve if e(sample)==1, d
di "sicve"
di r(p5)
di r(p95)

qui sum wexptiindus if e(sample)==1, d
di "wexptiindus"
di r(p5)
di r(p95)

qui sum capitrve if e(sample)==1, d
di "capitrve"
di r(p5)
di r(p95)

* What about the industry dummies?
forv i = 1(1)18 {
	sum indusx`i' if e(sample)==1
}

/*
The 8th industry has the modal effect size. This is coefficient b(20)
*/	
	

est restore model1

* Defining the median of the LDV for the regression sample
sum l.relempe if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

set more off 
preserve
set seed 8675309

drawnorm SN_b1-SN_b22, n(10000) means(e(b)) cov(e(V)) clear

* Close all open postfiles
postutil clear

* Declare variable names and filename of dataset where results will be saved
postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years
local a=0 
while `a' <= 10 { 
	{		

		scalar h_sicve			= .0080549	
		scalar h_wexptiindus	= -.0751575
		scalar h_sincve 		= .2165022
		scalar h_capitrve 		= .0284745
		scalar h_va_qi 			= 114.3623
		
* sicve at p(5) = .00010967
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .00010967  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

* sicve at p(95)  = .03616054
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .03616054  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

* wexptiindus at p(5) = -.30728811					
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* -.30728811		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20* 1				///
                            + SN_b22*1
							
* wexptiindus at p(95) = .04538862									
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* .04538862		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20* 1				///
                            + SN_b22*1 														

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims			
                               

graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted relative employment size", size(3))							///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 5% and 95%" 3 "Export competition at 5% and 95%" ) )
				
graph export "Figure_A1.pdf", replace
drop _merge



	
*********************
*********************
***** FOOTNOTES *****
*********************
*********************


*/Footnote 7: Correlation between total imports in VA country level and imports of goods & services in % GDP World Bank

pwcorr importsgdp siwve if indus==1
sum importsgdp siwve if indus==1 & importsgdp~=. & siwve~=.

*/Footnotes 8, 9, 10, 12: Available upon request (2014-08-25 Export competition correct form.do and EU-KLEMS files)

*/Footnote 13: Im-Pesaran-Shin tests for each time-series individually:
	//Ho: All panels contain unit roots
	//Ha: Some panels are stationary 
** Dependent variables at sectoral level
foreach var of varlist relempe h_ls { 
	gen unitroot`var'=.
	forvalues i=1(1)20 {
		foreach x in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
			qui xtunitroot ips `var' if cntry==`i' & indus==`x', trend l(aic)
			qui replace unitroot`var'=`r(p_wtbar)' if cntry==`i' & indus==`x'
		}
	}
}
foreach var of varlist unitrootrelempe-unitrooth_ls {
	qui sum `var' if id==1 & year==1990
	qui local tot = `r(N)'
	qui sum `var' if `var'<0.05 & year==1990
	qui local p05 = `r(N)'
	display (`p05')/`tot'*100
}

** Independent variables at sectoral level
foreach var of varlist sicve wexptiindus capitrve va_qi sincve {
	gen unitroot`var'=.
		forvalues i=1(1)20 {
			foreach x in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
			qui xtunitroot ips `var' if cntry==`i' & indus==`x', trend l(aic)
			qui replace unitroot`var'=`r(p_wtbar)' if cntry==`i' & indus==`x'
		}
	}
}
foreach var of varlist unitrootsicve-unitrootsincve {
	qui sum `var' if id==1 & year==1990
	qui local tot = `r(N)'
	qui sum `var' if `var'<0.05 & year==1990
	qui local p05 = `r(N)'
	di "`var' 
	display (`p05')/`tot'*100
}

** Independent variables at country level
foreach var of varlist adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol {
	gen unitroot`var'=.
	forvalues i=1(1)20 {
		qui xtunitroot ips `var' if cntry==`i' & indus==2, trend l(aic)
		qui replace unitroot`var'=`r(p_wtbar)' if cntry==`i' & indus==2
	}
}
foreach var of varlist unitrootadjcovpol-unitrootlhcpol {
	qui sum `var' if indus==2 & year==1990 & `var'~=.
	qui local tot = `r(N)'
	qui sum `var' if indus==2 & `var'<0.05 & year==1990 & `var'~=.
	qui local p05 = `r(N)'
	di (`p05')/`tot'*100
}

drop unitroot*


** First difference all the indicators (except va_q) and redo the tests
** Dependent variables
xtset cs year
foreach var of varlist relempe h_ls sicve wexptiindus capitrve va_qi sincve adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol {
	gen d`var' = d.`var'
}

foreach var of varlist relempe h_ls { 
	gen unitroot`var'=.
	forvalues i=1(1)20 {
		foreach x in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
			qui xtunitroot ips d`var' if cntry==`i' & indus==`x', trend l(aic)
			qui replace unitroot`var'=`r(p_wtbar)' if cntry==`i' & indus==`x'
		}
	}
}
foreach var of varlist unitrootrelempe-unitrooth_ls {
	di "`var' 
	qui sum `var' if id==1 & year==1990
	qui local tot = `r(N)'
	qui sum `var' if `var'<0.05 & year==1990
	qui local p05 = `r(N)'
	display (`p05')/`tot'*100
}

** Independent variables at sectoral level
foreach var of varlist sicve wexptiindus capitrve va_qi sincve {
	gen unitroot`var'=.
	forvalues i=1(1)20 {
		foreach x in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
			qui xtunitroot ips d`var' if cntry==`i' & indus==`x', trend l(aic)
			qui replace unitroot`var'=`r(p_wtbar)' if cntry==`i' & indus==`x'
		}
	}
}
foreach var of varlist unitrootsicve-unitrootsincve {
	di "`var' 
	qui sum `var' if id==1 & year==1990
	qui local tot = `r(N)'
	qui sum `var' if `var'<0.10 & year==1990
	qui local p05 = `r(N)'
	display (`p05')/`tot'*100
}

** Independent variables at country level
foreach var of varlist adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol {
	gen unitroot`var'=.
	forvalues i=1(1)20 {
		qui xtunitroot ips d`var' if cntry==`i' & indus==2, trend l(aic)
		qui replace unitroot`var'=`r(p_wtbar)' if cntry==`i' & indus==2
	}
}
foreach var of varlist unitrootadjcovpol-unitrootlhcpol {
	di "`var' 
	qui sum `var' if indus==2 & year==1990 & `var'~=.
	qui local tot = `r(N)'
	qui sum `var' if indus==2 & `var'<0.05 & year==1990 & `var'~=.
	qui local p05 = `r(N)'
	display (`p05')/`tot'*100
}

drop unitroot*
foreach var of varlist relempe h_ls sicve wexptiindus capitrve va_qi sincve adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol {
	drop d`var'
}



*/Footnote 14: on the Nickell bias: running the regressions without unit fixed effects

** Table 3: Relative employment size

eststo clear
	eststo: quietly xtpcse d.relempe l.relempe  d.sicve l.sicve d.wexptiindus l.wexptiindus d.sincve l.sincve d.capitrve l.capitrve d.va_qi l.va_qi, c(psar1), if id==1 
	eststo: quietly xtpcse relempe  l.relempe 	sicve wexptiindus sincve capitrve va_qi, 	c(psar1), if id==1 	
esttab, order(l.relempe) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
	title(Relative employment size without industry dummies) 

** Table 4: Hours worked low skilled

eststo clear
	eststo: quietly xtpcse d.h_ls 	 l.h_ls 	d.sicve l.sicve d.wexptiindus l.wexptiindus d.sincve l.sincve d.capitrve l.capitrve d.va_qi l.va_qi l.adjcovpol l.coord l.gov_left1 l.eprc_v1 l.ept_v1 l.rrapwpol l.lhcpol l.unem l.gdpcap, 	c(psar1), if id==1 
	eststo: quietly xtpcse h_ls		l.h_ls 		sicve wexptiindus sincve capitrve va_qi adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap, 	c(psar1), if id==1 
esttab, order(l.h_ls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
	title(Hours low-skilled without industry dummies) 

	

*/Footnotes 15 and 22: Exploring interaction effects
*/Interactions with all dummies

** Interactions within the ECM framework: import competition
foreach x in ve {
	eststo clear
	eststo: quietly xtpcse d.relempe l.relempe d.sic`x' 			i.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x', c(psar1), if id==1 
	eststo: quietly xtpcse d.relempe l.relempe i.indus##d.c.sic`x' 	i.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x', c(psar1), if id==1 

	eststo: quietly xtpcse d.h_ls l.h_ls d.sic`x' 				i.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' l.adjcovpol l.coord l.eprc_v1 l.ept_v1 l.rrapwpol l.unem l.gdpcap l.gov_left1 l.lhcpol, c(psar1), if id==1 
	eststo: quietly xtpcse d.h_ls l.h_ls i.indus##d.c.sic`x' 	i.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' l.adjcovpol l.coord l.eprc_v1 l.ept_v1 l.rrapwpol l.unem l.gdpcap l.gov_left1 l.lhcpol, c(psar1), if id==1 
	esttab, order(l.relempe l.h_ls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
		title(Sectoral interactions import comp ECM) ///
		mtitle("level interact" "level+first dif" "level interact" "level+first dif")
}

** Interactions within the ECM framework: export competition
foreach x in ve {
	eststo clear
	eststo: quietly xtpcse d.relempe l.relempe d.sic`x' l.sic`x' d.wexptiindus 				i.indus##l.c.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x', c(psar1), if id==1 
	eststo: quietly xtpcse d.relempe l.relempe d.sic`x' l.sic`x' i.indus##d.c.wexptiindus 	i.indus##l.c.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x', c(psar1), if id==1 

	eststo: quietly xtpcse d.h_ls l.h_ls d.sic`x' l.sic`x' d.wexptiindus 			i.indus##l.c.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' l.adjcovpol l.coord l.eprc_v1 l.ept_v1 l.rrapwpol l.unem l.gdpcap l.gov_left1 l.lhcpol, c(psar1), if id==1 
	eststo: quietly xtpcse d.h_ls l.h_ls d.sic`x' l.sic`x' i.indus##d.c.wexptiindus i.indus##l.c.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' l.adjcovpol l.coord l.eprc_v1 l.ept_v1 l.rrapwpol l.unem l.gdpcap l.gov_left1 l.lhcpol, c(psar1), if id==1 
	esttab, order(l.relempe l.h_ls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
		title(Sectoral interactions export comp ECM) /// 
		mtitle("level interact" "level+first dif" "level interact" "level+first dif")
}

** Interactions within the OLS PA framework for same sample

foreach x in ve {
	eststo clear
	eststo: quietly xtpcse relempe l.relempe 	i.indus##c.sic`x' wexptiindus capitrve va_qi sinc`x', c(psar1), if id==1 & d.sic`x' ~=. & d.wexptiindus~=. & d.capitrve~=. & d.va_qi~=. & d.sinc`x'~=.
	eststo: quietly xtpcse h_ls l.h_ls 			i.indus##c.sic`x' wexptiindus capitrve va_qi sinc`x' adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol, c(psar1), if id==1 & d.sic`x' ~=. & d.wexptiindus~=. & d.capitrve~=. & d.va_qi~=. & d.sinc`x'~=. & l.adjcovpol~=. & l.coord~=. & l.eprc_v1~=. & l.ept_v1~=. & l.rrapwpol~=. & l.unem~=. & l.gdpcap~=. & l.gov_left1~=. & l.lhcpol~=.
	
	eststo: quietly xtpcse relempe l.relempe	sic`x' i.indus##c.wexptiindus capitrve va_qi sinc`x', c(psar1), if id==1 & d.sic`x' ~=. & d.wexptiindus~=. & d.capitrve~=. & d.va_qi~=. & d.sinc`x'~=.
	eststo: quietly xtpcse h_ls l.h_ls 			sic`x' i.indus##c.wexptiindus capitrve va_qi sinc`x' adjcovpol coord eprc_v1 ept_v1 rrapwpol unem gdpcap gov_left1 lhcpol, c(psar1), if id==1 & d.sic`x' ~=. & d.wexptiindus~=. & d.capitrve~=. & d.va_qi~=. & d.sinc`x'~=. & l.adjcovpol~=. & l.coord~=. & l.eprc_v1~=. & l.ept_v1~=. & l.rrapwpol~=. & l.unem~=. & l.gdpcap~=. & l.gov_left1~=. & l.lhcpol~=.
	
	esttab, order(l.relempe l.h_ls) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
		title(Sectoral interactions import and export comp) ///
		mtitle("Import interact" "Import interact" "Export interact" "Export interact")
}
	
	
** Interactions one by one: import competition

foreach x in ve {
	eststo clear
	foreach y in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
		eststo: quietly xtpcse d.relempe l.relempe d.sic`x' 				`y'.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' i.indus, c(psar1), if id==1 
		eststo: quietly xtpcse d.relempe l.relempe `y'.indus##d.c.sic`x' 	`y'.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' i.indus, c(psar1), if id==1 
	}
	esttab, order(l.relempe) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
	title(Sectoral interactions) ///
		mtitle("2" "2 + diff" "3" "3 + diff" "5" "5 + diff" "6" "6 + diff" "7" "7 + diff" "8" "8 + diff" "10" "10 + diff" "11" "11 + diff" ///
		"12" "12 + diff" "13" "13 + diff" "14" "14 + diff" "15" "15 + diff" "16" "16 + diff" "17" "17 + diff" "18" "18 + diff")

}

foreach x in ve {
	eststo clear
	foreach y in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
		eststo: quietly xtpcse d.h_ls l.h_ls d.sic`x' 				`y'.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' l.adjcovpol l.coord l.eprc_v1 l.ept_v1 l.rrapwpol l.unem l.gdpcap l.gov_left1 l.lhcpol i.indus, c(psar1), if id==1 
		eststo: quietly xtpcse d.h_ls l.h_ls `y'.indus##d.c.sic`x' 	`y'.indus##l.c.sic`x' d.wexptiindus l.wexptiindus d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' l.adjcovpol l.coord l.eprc_v1 l.ept_v1 l.rrapwpol l.unem l.gdpcap l.gov_left1 l.lhcpol i.indus, c(psar1), if id==1 
	}
	esttab, order(l.relempe) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) ///
		title(Sectoral interactions) ///
		mtitle("2" "2 + diff" "3" "3 + diff" "5" "5 + diff" "6" "6 + diff" "7" "7 + diff" "8" "8 + diff" "10" "10 + diff" "11" "11 + diff" ///
		"12" "12 + diff" "13" "13 + diff" "14" "14 + diff" "15" "15 + diff" "16" "16 + diff" "17" "17 + diff" "18" "18 + diff")

}	
	
** Interactions one by one: export competition

foreach x in ve {
	eststo clear
	foreach y in 2 3 5 6 7 8 10 11 12 13 14 15 16 17 18 {
		eststo: quietly xtpcse d.relempe l.relempe d.wexptiindus 				`y'.indus##l.c.wexptiindus d.sic`x' l.sic`x' d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' i.indus, c(psar1), if id==1 
		eststo: quietly xtpcse d.relempe l.relempe `y'.indus##d.c.wexptiindus 	`y'.indus##l.c.wexptiindus d.sic`x' l.sic`x' d.capitrve l.capitrve d.va_qi l.va_qi d.sinc`x' l.sinc`x' i.indus, c(psar1), if id==1 
	}
	esttab, order(l.relempe) compress nogap star(* 0.1 ** 0.05 *** 0.01) b(%6.3f) scalars(N  r2) /// ///
		title(Sectoral interactions for export competition) ///
		mtitle("2" "2 + diff" "3" "3 + diff" "5" "5 + diff" "6" "6 + diff" "7" "7 + diff" "8" "8 + diff" "10" "10 + diff" "11" "11 + diff" ///
		"12" "12 + diff" "13" "13 + diff" "14" "14 + diff" "15" "15 + diff" "16" "16 + diff" "17" "17 + diff" "18" "18 + diff")

}


*/Footnote 18: Simulations for 15th and 85th for relative employment size


* This produces the 15 and 85th percentile distribution version of Figure 3: Import competition & technological change

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

xtset cs year
xtpcse relempe l.relempe $controlparelempe, c(psar1), if id==1
est sto model1
est restore model1

foreach v of varlist sicve capitrve {
	di "`v'"
	_pctile `v' if e(sample)==1, p(15, 85)
	return list
}

* Calculating the mean values of all variables
foreach v of varlist sicve wexptiindus capitrve sincve va_qi {
	di "`v'"
	qui sum `v' if e(sample)==1, d
	di r(mean)
}

* Defining the median of the LDV for the regression sample
sum l.relempe if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309


drawnorm SN_b1-SN_b22, n(10000) means(e(b)) cov(e(V)) clear

* Close all open postfiles
postutil clear

* Declare variable names and filename of dataset where results will be saved
postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years
local a=0 
while `a' <= 10 { 
	{		

* These values here are the mean values when e(sample)==1

		scalar h_sicve			= .0080549	
		scalar h_wexptiindus	= -.0751575
		scalar h_sincve 		= .2165022
		scalar h_capitrve 		= .0284745
		scalar h_va_qi 			= 114.3623

		
		
* sicve at p(15) = .000296117446851
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .000296117446851  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

* sicve at p(85)  = .0112841166555882
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .0112841166555882  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

										
* capitrve at p(15) = .0087742945179343					
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .0087742945179343		///
                            + SN_b6* h_va_qi		///
							+ SN_b20* 1				///
                            + SN_b22*1
							
* capitrve at p(85) = .0466375611722469									
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .0466375611722469		///
                            + SN_b6* h_va_qi		///
							+ SN_b20* 1				///
                            + SN_b22*1 														

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims			
                               


graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted relative employment size", size(3))							///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 15% and 85%" 3 "Technological change at 15% and 85%" ) )
			
graph export "Footnote18_Figure_3_at_15and85percent.pdf", replace
drop _merge







* This produces the 15 and 85th percentile distribution version of Figure A1: Import & export competition

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

* Generating auxiliary variables for the simulations
sum indus
forv i = 1(1)18 {
	gen indusx`i' = 1 if indus==`i'
	replace indusx`i' = 0 if indusx`i'~=1
}

xtpcse relempe l.relempe $controlparelempe, c(psar1), if id==1
	est sto model1
	ereturn list
	mat li e(b)
	
foreach v of varlist sicve wexptiindus {
	di "`v'"
	_pctile `v' if e(sample)==1, p(15, 85)
	return list
}

* Calculating the mean values of all variables
foreach v of varlist sicve wexptiindus capitrve sincve va_qi {
	di "`v'"
	qui sum `v' if e(sample)==1, d
	di r(mean)
}
	
forv i = 1(1)18 {
	sum indusx`i' if e(sample)==1
}

est restore model1

* Defining the median of the LDV for the regression sample
sum l.relempe if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309


* With the industry dummies, this becomes 22
drawnorm SN_b1-SN_b22, n(10000) means(e(b)) cov(e(V)) clear

postutil clear

postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years
local a=0 
while `a' <= 10 { 
	{		


		scalar h_sicve			= .0080549	
		scalar h_wexptiindus	= -.0751575
		scalar h_sincve 		= .2165022
		scalar h_capitrve 		= .0284745
		scalar h_va_qi 			= 114.3623
		
* sicve at p(15) = .000296117446851
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .000296117446851  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

* sicve at p(85)  = .0112841166555882
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .0112841166555882  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 

* wexptiindus at p(15) = -.1542479693889618					
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* -.1542479693889618		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1
							
* wexptiindus at p(85) = .0039237579330802									
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* .0039237579330802		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
							+ SN_b20*1				///
                            + SN_b22*1 														

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims			
                               

graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted relative employment size", size(3))							///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 15% and 85%" 3 "Export competition at 20% and 80%" ) )
			
graph export "Footnote18_Figure_A1_at_15and85percent.pdf", replace
drop _merge





*/Footnote 23: Simulations for 15th and 85th for hours worked by low-skilled

** This is the 15th and 85th version of Figure 4A: import and export competition

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 
	est sto model1
	ereturn list
	mat li e(b)
* The intercept is the last entrance in the b-coefficient matrix. The matrix is now 1 x 31. 
	
	
foreach x in sicve wexptiindus sincve capitrve va_qi adjcovpol coord gov_left1 eprc_v1 ept_v1 rrapwpol lhcpol unem gdpcap {
	qui sum `x' if e(sample)==1
	di "`x'"
	di r(mean)
} 

* Calculating the p15 and p85 instead of the p(5) and p(95)
foreach v of varlist sicve wexptiindus {
	di "`v'"
	_pctile `v' if e(sample)==1, p(15, 85)
	return list
}

est restore model1

* Defining the median of the LDV for the regression sample
sum l.h_ls if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309

drawnorm SN_b1-SN_b31, n(10000) means(e(b)) cov(e(V)) clear

postutil clear

postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years simulated

local a=0 
while `a' <= 10 { 
	{		

* Mind the other of b coefficients. See above when doing ereturn list. b(31) is the intercept with all the industry dummies.

		scalar h_sicve			= .00670653	
		scalar h_wexptiindus	= -.07931103
		
		scalar h_sincve			= .20569587
		scalar h_capitrve		= .02842318
		scalar h_va_qi			= 110.81575
		
		scalar h_adjcovpol		= 68.048812
		scalar h_coord			= 3.0492921
		scalar h_gov_left1		= 35.698254
		scalar h_eprc_v1		= 2.1603919
		scalar h_ept_v1			= 1.695759
		scalar h_rrapwpol		= .55502319
		scalar h_lhcpol			= 12.808864
		scalar h_unem			= 8.1012754
		scalar h_gdpcap			= 30.986734
		


* sicve at p(15) = .000282730703475
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .000282730703475  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
					
						
* sicve at p(85) = .0096767600625753
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .0096767600625753  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
		
* wexptiindus at p(15)	= -.156337633728981
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* -.156337633728981		///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
							
* wexptiindus at p(85)	= .0009213723824359 
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* .0009213723824359 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 				

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims
                               

graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted share of hours worked low-skilled", size(3))					///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 15% and 85%" 3 "Export competition at 15% and 85%" ) )

graph export "Footnote23_Figure_4A_at_15and85percent.pdf", replace
drop _merge










** This is the 15th and 85th version of Figure 4B: import competition and technological change

* Load the data
clear
use "Dragon_dta_file.dta"
xtset cs year

xtpcse h_ls l.h_ls $controlpah_ls, c(psar1), if id==1 
	est sto model1
	ereturn list
	mat li e(b)

* Calculating the p15 and p85 instead of the p(5) and p(95)
foreach v of varlist sicve capitrve {
	di "`v'"
	_pctile `v' if e(sample)==1, p(15, 85)
	return list
}	
	
	
est restore model1

* Defining the median of the LDV for the regression sample
sum l.h_ls if e(sample), det
local lagmean = `r(p50)'
di "LMILEX1 mode =" `lagmean'

* Drawing from a multivariate normal distribution 
set more off 
preserve
set seed 8675309


drawnorm SN_b1-SN_b31, n(10000) means(e(b)) cov(e(V)) clear

postutil clear

postfile mypost	EYIIA_lo EYIIA_hi ///
				EYIIB_lo EYIIB_hi ///
				EYDMA_lo EYDMA_hi ///
				EYDMB_lo EYDMB_hi ///
				_t 	using sims, replace
						
noisily display "start"

local lagIIA = `lagmean'
local lagIIB = `lagmean'
local lagDMA = `lagmean'
local lagDMB = `lagmean'


* These are the 10 years simulated

local a=0 
while `a' <= 10 { 
	{		

* Mind the other of b coefficients. See above when doing ereturn list. b(31) is the intercept with all the industry dummies.

		scalar h_sicve			= .00670653	
		scalar h_wexptiindus	= -.07931103
		
		scalar h_sincve			= .20569587
		scalar h_capitrve		= .02842318
		scalar h_va_qi			= 110.81575
		
		scalar h_adjcovpol		= 68.048812
		scalar h_coord			= 3.0492921
		scalar h_gov_left1		= 35.698254
		scalar h_eprc_v1		= 2.1603919
		scalar h_ept_v1			= 1.695759
		scalar h_rrapwpol		= .55502319
		scalar h_lhcpol			= 12.808864
		scalar h_unem			= 8.1012754
		scalar h_gdpcap			= 30.986734
		
* sicve at p(15) = .000282730703475
			gen EYIIA = 	  SN_b1*`lagIIA' 		///
                            + SN_b2* .000282730703475  	///
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
					
						
* sicve at p(85) = .0096767600625753
			gen EYIIB =       SN_b1*`lagIIB' 		///
                            + SN_b2* .0096767600625753  	/// 
                            + SN_b3* h_wexptiindus 	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* h_capitrve		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 

* capitrve at p(15) = .008862835355103				
			gen EYDMA = 	  SN_b1*`lagDMA' 		///
                            + SN_b2* h_sicve   		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .008862835355103		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 
							
* capitrve at p(85) = .0461765863001347								
			gen EYDMB = 	  SN_b1*`lagDMB' 		///
                            + SN_b2* h_sicve  		///
                            + SN_b3* h_wexptiindus	///
                            + SN_b4* h_sincve 		///
                            + SN_b5* .0461765863001347		///
                            + SN_b6* h_va_qi		///
													///
							+ SN_b7* h_adjcovpol	///
							+ SN_b8* h_coord		///
							+ SN_b9* h_gov_left1	///
							+ SN_b10* h_eprc_v1		///
							+ SN_b11* h_ept_v1		///
							+ SN_b12* h_rrapwpol	///
							+ SN_b13* h_lhcpol		///
							+ SN_b14* h_unem		///
							+ SN_b15* h_gdpcap		///						
													///
							+ SN_b18*1				///
                            + SN_b31*1 				

			gen time = `a'
			egen _time = max(time)
			egen _lagIIA = mean(EYIIA)
			egen _lagIIB = mean(EYIIB)
			egen _lagDMA = mean(EYDMA)
			egen _lagDMB = mean(EYDMB)	
			
  tempname 	EYIIA_lo EYIIA_hi 	///
			EYIIB_lo EYIIB_hi	///
			EYDMA_lo EYDMA_hi 	///
			EYDMB_lo EYDMB_hi 	///
			_t 			

			 _pctile EYIIA, p(2.5,97.5) 
			    scalar `EYIIA_lo' = r(r1)
				scalar `EYIIA_hi' = r(r2)
			 _pctile EYIIB, p(2.5,97.5)
			    scalar `EYIIB_lo' = r(r1)
				scalar `EYIIB_hi' = r(r2)
			 _pctile EYDMA, p(2.5,97.5) 
			    scalar `EYDMA_lo' = r(r1)
				scalar `EYDMA_hi' = r(r2)
			 _pctile EYDMB, p(2.5,97.5) 
			    scalar `EYDMB_lo' = r(r1)
				scalar `EYDMB_hi' = r(r2)				
			 scalar `_t'=_time

			
   post mypost 	(`EYIIA_lo') (`EYIIA_hi') 	///
				(`EYIIB_lo') (`EYIIB_hi')	///
				(`EYDMA_lo') (`EYDMA_hi')	///
				(`EYDMB_lo') (`EYDMB_hi')	///
				(`_t')		
			
    }      
    
    
    local a=`a'+ 1
	
	local list IIA IIB DMA DMB  
	foreach i of local list {
		qui sum EY`i' , meanonly 
		local lag`i' = `r(mean)'
		}


    drop EY* time _time _lag* 

    display "." _c
	display "lagIIA =" `lagIIA' "lagIIB=" `lagIIB' 	
    
} 
display ""

postclose mypost

restore

merge using sims
                               
graph twoway rcap EYIIA_lo EYIIA_hi _t, clwidth(medium) color(black)  						///
        ||   rcap EYIIB_lo EYIIB_hi _t, clwidth(medium) color(black) 						///
        ||   rcapsym EYDMA_lo EYDMA_hi _t, clwidth(medium) color(gs7)  msymbol(smx)			///
        ||   rcapsym  EYDMB_lo EYDMB_hi _t, clwidth(medium) color(gs7)   msymbol(smx)		///
        ||  ,   																			///
            xlabel(0 5 10, nogrid labsize(2)) 												///
            ylabel(,  nogrid labsize(2))													///
			xtitle(Years, size(3))															///
            ytitle("Predicted share of hours worked low-skilled", size(3))					///
		    xsca(titlegap(4)) ysca(titlegap(4)) 											///
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))			///
			legend(size(small) order(1 "Import competition at 15% and 85%" 3 "Technological change at 15% and 85%" ) )

graph export "Footnote23_Figure_4B_at_15and85percent.pdf", replace
drop _merge



