**********************************************
** fdicycle.do for the main analysis        **
** Daehee Bak, daehee.bak@ttu.edu			**
** Date created: April 4, 2015				**
** Date updated: March 12, 2016				**
**											**
** Using files: 							**
**     fdicyle.dta							**
**********************************************

drop _all
estimates clear
clear all
set more off
use fdicycle, clear 
xtset ccode year

xi i.year i.ccode  
global country "_Iccode*"
global year "_Iyear*"


global control "gdppcL1 growth lnpopL1 tradeL1 bit_oecd_dumL1 kaopen oilL1 priointrawarL1 lnbanksindexL1"

global fdigdp "fdigdpUN"
global fdiinflow "lnfdiUN" 


*** Table 1: Summary Statistics ***	

* (semi)presidential
xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe
sum lnfdiUN lnexecdura lnexecdura2 $control if e(sample)

* autocracy
xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0, fe
sum lnfdiUN lndura1 lndura2 $control if e(sample)



*** Table 2: Model (1) ***	
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)

*** Table 2: Model (2) ***	
xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe

*** Table 2: Model (3) ***	
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if cgvregime==2, pair cor(ar1)

*** Table 2: Model (4) ***	
xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==2, fe

*** Table 2: Model (5) ***	
xtpcse $fdiinflow lndura1 lndura2 $control $country if cgvdem==0, pair cor(ar1)

*** Table 2: Model (6) ***	
xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0, fe



*** Table 3: Model (1) ***	
xtpcse $fdiinflow execquota execquota2 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)

*** Table 3: Model (2) ***	
xtscc $fdiinflow execquota execquota2 $control if cgvregime==1 | cgvregime==2, fe

*** Table 3: Model (3) ***	
xtpcse $fdiinflow execquota execquota2 $control $country if cgvregime==2, pair cor(ar1)

*** Table 3: Model (4) ***	
xtscc $fdiinflow execquota execquota2 $control if cgvregime==2, fe



*** Figure 1 ***

* Simulation: Autocracy 

xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0, fe

global control "gdppcL1 growth lnpopL1 tradeL1 bit_oecd_dumL1 kaopen oilL1 priointrawarL1 lnbanksindexL1"

	sum lndura1 if e(sample), detail 
	scalar lndura1=r(mean) 
	sum gdppcL1 if e(sample) 
	scalar gdppcL1=r(mean) 
	sum growth if e(sample) 
	scalar growth=r(mean) 
	sum lnpopL1 if e(sample) 
	scalar lnpopL1=r(mean) 
	sum tradeL1 if e(sample) 
	scalar tradeL1=r(mean) 	
	sum bit_oecd_dumL1 if e(sample), detail 
	scalar bit_oecd_dumL1=r(p50) 
	sum kaopen if e(sample) 
	scalar kaopen=r(mean) 
	sum oilL1 if e(sample) 
	scalar oilL1=r(mean)  
	sum priointrawarL1 if e(sample), detail  
	scalar priointrawarL1=r(p50) 
	sum lnbanksindexL1 if e(sample) 
	scalar lnbanksindexL1=r(mean)     
	scalar h_constant=1 

xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0, fe

drawnorm b1-b12, n(10000) means(e(b)) cov(e(V))  clear 
gen PROB=.
gen PROBlow=.
gen PROBhigh=.

gen a =.
gen lndura1 = (_n-1)/100

local a=0
while `a' <= 3.9 {
	gen x_beta = b1*`a' + b2*`a'^2 + b3*gdppcL1 ///
			+ b4*growth + b5*lnpopL1 + b6*tradeL1 ///
			+ b7*bit_oecd_dumL1 + b8*kaopen + b9*oilL1 ///
			+ b10*priointrawarL1 + b11*lnbanksindexL1 + b12*1 

    gen prob = x_beta
	egen probhat=mean(prob)
    _pctile prob, p(2.5,97.5) 
    scalar problow= r(r1) 
    scalar probhigh= r(r2)
 	quietly replace a = `a' 	
	quietly replace PROB =  probhat if lndura1==a  
	quietly replace PROBlow =  problow  if lndura1==a
	quietly replace PROBhigh =  probhigh  if lndura1==a	
	drop x_beta* prob* probhat*
	local a = `a' + 0.01	
	display "." _c 
}

gen dura1 = exp(lndura1)

save fdiinflow_autocracy, replace

twoway (line PROB PROBlow PROBhigh lndura1 if lndura1<=3.14, ///
	clpattern(solid dash dash) ///
	yline(0, lpattern(solid) lwidth(vvthin)) ///
	yaxis(1) ylabel(#4)), ///
	xtitle("ln(Tenure)", size(3.5)) ///
	ytitle("ln(FDI Inflows)", size(3.5)) ///
	xline(1.41) yscale(titlegap(*+10)) ///
	title("(1) Autocracy", size(3)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	legend(off) scheme(s1mono) saving(fdiinflow_autocracy_lndura1, replace)

* Simulation: Democracy  	

use fdicycle, clear 

xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe

global control "gdppcL1 growth lnpopL1 tradeL1 bit_oecd_dumL1 kaopen oilL1 priointrawarL1 lnbanksindexL1"

	sum lnexecdura if e(sample), detail 
	scalar lnexecdura=r(mean) 
	sum gdppcL1 if e(sample) 
	scalar gdppcL1=r(mean) 
	sum growth if e(sample) 
	scalar growth=r(mean) 
	sum lnpopL1 if e(sample) 
	scalar lnpopL1=r(mean) 
	sum tradeL1 if e(sample) 
	scalar tradeL1=r(mean) 	
	sum bit_oecd_dumL1 if e(sample), detail 
	scalar bit_oecd_dumL1=r(p50) 
	sum kaopen if e(sample) 
	scalar kaopen=r(mean) 
	sum oilL1 if e(sample) 
	scalar oilL1=r(mean)  
	sum priointrawarL1 if e(sample), detail  
	scalar priointrawarL1=r(p50) 
	sum lnbanksindexL1 if e(sample) 
	scalar lnbanksindexL1=r(mean)     
	scalar h_constant=1 

xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe

drawnorm b1-b12, n(10000) means(e(b)) cov(e(V))  clear 
gen PROB=.
gen PROBlow=.
gen PROBhigh=.

gen a =.
gen lnexecdura = (_n-1)/100

local a=0
while `a' <= 4.1 {
	gen x_beta = b1*`a' + b2*`a'^2 + b3*gdppcL1 ///
			+ b4*growth + b5*lnpopL1 + b6*tradeL1 ///
			+ b7*bit_oecd_dumL1 + b8*kaopen + b9*oilL1 ///
			+ b10*priointrawarL1 + b11*lnbanksindexL1 + b12*1 

    gen prob = x_beta
	egen probhat=mean(prob)
    _pctile prob, p(2.5,97.5) 
    scalar problow= r(r1) 
    scalar probhigh= r(r2)
 	quietly replace a = `a' 	
	quietly replace PROB =  probhat if lnexecdura==a  
	quietly replace PROBlow =  problow  if lnexecdura==a
	quietly replace PROBhigh =  probhigh  if lnexecdura==a	
	drop x_beta* prob* probhat*
	local a = `a' + 0.01	
	display "." _c 
}

gen execdura = exp(lnexecdura)

save fdiinflow_democracy, replace

twoway (line PROB PROBlow PROBhigh lnexecdura if lnexecdura<=1.79, ///
	clpattern(solid dash dash) ///
	yaxis(1) ylabel(#4)), ///
	xtitle("ln(Election Proximity)", size(3.5)) ///
	ytitle("ln(FDI Inflows)", size(3.5)) ///
	xline(0.85) yscale(titlegap(*+10)) ///
	title("(2) Democracy", size(3)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	legend(off) scheme(s1mono) saving(fdiinflow_democracy_lnexecdura, replace)

graph combine fdiinflow_democracy_lnexecdura.gph fdiinflow_autocracy_lndura1.gph, saving(fdiinflow_combine, replace) 
graph export fdiinflow_combine.pdf, as(pdf) replace



*** Figure 2 ***

use fdicycle, clear 

xtscc $fdiinflow execquota execquota2 $control if cgvregime==1 | cgvregime==2, fe

global control "gdppcL1 growth lnpopL1 tradeL1 bit_oecd_dumL1 kaopen oilL1 priointrawarL1 lnbanksindexL1"

	sum execquota if e(sample), detail 
	scalar execquota=r(mean) 
	sum gdppcL1 if e(sample) 
	scalar gdppcL1=r(mean) 
	sum growth if e(sample) 
	scalar growth=r(mean) 
	sum lnpopL1 if e(sample) 
	scalar lnpopL1=r(mean) 
	sum tradeL1 if e(sample) 
	scalar tradeL1=r(mean) 	
	sum bit_oecd_dumL1 if e(sample), detail 
	scalar bit_oecd_dumL1=r(p50) 
	sum kaopen if e(sample) 
	scalar kaopen=r(mean) 
	sum oilL1 if e(sample) 
	scalar oilL1=r(mean)  
	sum priointrawarL1 if e(sample), detail  
	scalar priointrawarL1=r(p50) 
	sum lnbanksindexL1 if e(sample) 
	scalar lnbanksindexL1=r(mean)     
	scalar h_constant=1 

xtscc $fdiinflow execquota execquota2 $control if cgvregime==1 | cgvregime==2, fe

drawnorm b1-b12, n(10000) means(e(b)) cov(e(V))  clear 
gen PROB=.
gen PROBlow=.
gen PROBhigh=.

gen a =.
gen execquota = (_n-1)/100

local a=0
while `a' <= 1 {
	gen x_beta = b1*`a' + b2*`a'^2 + b3*gdppcL1 ///
			+ b4*growth + b5*lnpopL1 + b6*tradeL1 ///
			+ b7*bit_oecd_dumL1 + b8*kaopen + b9*oilL1 ///
			+ b10*priointrawarL1 + b11*lnbanksindexL1 + b12*1 

    gen prob = x_beta
	egen probhat=mean(prob)
    _pctile prob, p(2.5,97.5) 
    scalar problow= r(r1) 
    scalar probhigh= r(r2)
 	quietly replace a = `a' 	
	quietly replace PROB =  probhat if execquota==a  
	quietly replace PROBlow =  problow  if execquota==a
	quietly replace PROBhigh =  probhigh  if execquota==a	
	drop x_beta* prob* probhat*
	local a = `a' + 0.01	
	display "." _c 
}

save fdiinflow_democracy_execquota, replace

twoway (line PROB PROBlow PROBhigh execquota if execquota<=1, ///
	clpattern(solid dash dash) ///
	yaxis(1) ylabel(#4)), ///
	xtitle("Election Quota", size(3.5)) ///
	ytitle("ln(FDI Inflows)", size(3.5)) ///
	xline(0.41) yscale(titlegap(*+10)) ///
	title("", size(3)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	legend(off) scheme(s1mono) saving(fdiinflow_democracy_execquota, replace)

graph export fdiinflow_democracy_execquota.pdf, as(pdf) replace



