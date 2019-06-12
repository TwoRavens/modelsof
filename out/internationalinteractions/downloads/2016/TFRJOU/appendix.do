**********************************************
** appendix.do for auxiliary analysis       **
** Daehee Bak, daehee.bak@ttu.edu			**
** Date created: January 12, 2016			**
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


*** Appendix 1: Table 1 ***
use fdicycle, clear
xtpcse $fdigdp lndura1 lndura2 $control $country if cgvdem==0, pair cor(ar1)
xtscc $fdigdp lndura1 lndura2 $control if cgvdem==0, fe
xtpcse $fdigdp lnexecdura lnexecdura2 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
xtscc $fdigdp lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe
xtpcse $fdigdp lnexecdura lnexecdura2 $control $country if cgvregime==2, pair cor(ar1)
xtscc $fdigdp lnexecdura lnexecdura2 $control if cgvregime==2, fe

*** Appendix 2: Table 2 ***
xtpcse $fdiinflow lnlegisdura lnlegisdura2 $control $country if cgvregime==0, pair cor(ar1)
xtscc $fdiinflow lnlegisdura lnlegisdura2 $control if cgvregime==0, fe
xtpcse $fdiinflow legisquota legisquota2 $control $country if cgvregime==0, pair cor(ar1)
xtscc $fdiinflow legisquota legisquota2 $control if cgvregime==0, fe

*** Appendix 3: Table 3 ***
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if cgvdem==0, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvdem==0, fe
xtpcse $fdiinflow execquota execquota2 $control $country if cgvdem==0, pair cor(ar1)
xtscc $fdiinflow execquota execquota2 $control if cgvdem==0, fe

*** Appendix 4: Table 4 ***
xtpcse $fdiinflow lnexecdura lnexecdura2 $control DPI_prtyin DPI_allhouse DPI_execrlc $country if cgvdem==1 & dpipresidential ==1, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control DPI_prtyin DPI_allhouse DPI_execrlc if cgvdem==1 & dpipresidential ==1, fe
xtpcse $fdigdp lnexecdura lnexecdura2 $control DPI_prtyin DPI_allhouse DPI_execrlc $country if cgvdem==1 & dpipresidential ==1, pair cor(ar1)
xtscc $fdigdp lnexecdura lnexecdura2 $control DPI_prtyin DPI_allhouse DPI_execrlc if cgvdem==1 & dpipresidential ==1, fe


*** Appendix 5 ***
gen mature5 = cgvage>5
replace mature5 = . if cgvage==.
gen lnexecdura_age5 = lnexecdura * mature5
gen lnexecdura2_age5 = lnexecdura2 * mature5

gen mature6 = cgvage>6
replace mature6 = . if cgvage==.
gen lnexecdura_age6 = lnexecdura * mature6
gen lnexecdura2_age6 = lnexecdura2 * mature6

gen mature4 = cgvage>4
replace mature4 = . if cgvage==.
gen lnexecdura_age4 = lnexecdura * mature4
gen lnexecdura2_age4 = lnexecdura2 * mature4

* Table 5
xtpcse $fdiinflow lnexecdura lnexecdura2 $control cgvage $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control cgvage if cgvregime==1 | cgvregime==2, fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control mature5 $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control mature5 if cgvregime==1 | cgvregime==2, fe

* Table 6
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if mature5==1 & (cgvregime==1 | cgvregime==2), pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if mature5==1 & (cgvregime==1 | cgvregime==2), fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if mature6==1 & (cgvregime==1 | cgvregime==2), pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if mature6==1 & (cgvregime==1 | cgvregime==2), fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if mature4==1 & (cgvregime==1 | cgvregime==2), pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if mature4==1 & (cgvregime==1 | cgvregime==2), fe

* Table 7
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if mature5==0 & (cgvregime==1 | cgvregime==2), pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if mature5==0 & (cgvregime==1 | cgvregime==2), fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if mature6==0 & (cgvregime==1 | cgvregime==2), pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if mature6==0 & (cgvregime==1 | cgvregime==2), fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if mature4==0 & (cgvregime==1 | cgvregime==2), pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if mature4==0 & (cgvregime==1 | cgvregime==2), fe

* Table 8
xtpcse $fdiinflow lnexecdura lnexecdura2 mature5 lnexecdura_age5 lnexecdura2_age5 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
lincom lnexecdura2 + lnexecdura2_age5
xtscc $fdiinflow lnexecdura lnexecdura2 mature5 lnexecdura_age5 lnexecdura2_age5 $control if cgvregime==1 | cgvregime==2, fe
lincom lnexecdura2 + lnexecdura2_age5
xtpcse $fdiinflow lnexecdura lnexecdura2 mature6 lnexecdura_age6 lnexecdura2_age6 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
lincom lnexecdura2 + lnexecdura2_age6
xtscc $fdiinflow lnexecdura lnexecdura2 mature6 lnexecdura_age6 lnexecdura2_age6 $control if cgvregime==1 | cgvregime==2, fe
lincom lnexecdura2 + lnexecdura2_age6
xtpcse $fdiinflow lnexecdura lnexecdura2 mature4 lnexecdura_age4 lnexecdura2_age4 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
lincom lnexecdura2 + lnexecdura2_age4
xtscc $fdiinflow lnexecdura lnexecdura2 mature4 lnexecdura_age4 lnexecdura2_age4 $control if cgvregime==1 | cgvregime==2, fe
lincom lnexecdura2 + lnexecdura2_age4


*** Appendix 6 ***

* Table 9 
xtpcse $fdiinflow lndura1 lndura2 $control $country if gwfmil==1 | gwfper==1, pair cor(ar1)
xtscc $fdiinflow lndura1 lndura2 $control if gwfmil==1 | gwfper==1, fe
xtpcse $fdiinflow lndura1 lndura2 $control $country if gwfpar==1, pair cor(ar1)
xtscc $fdiinflow lndura1 lndura2 $control if gwfpar==1, fe

* Figure 1
preserve
xtscc $fdiinflow lndura1 lndura2 $control if gwfmil==1 | gwfper==1, fe
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
xtscc $fdiinflow lndura1 lndura2 $control if gwfmil==1 | gwfper==1, fe
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
twoway (line PROB PROBlow PROBhigh lndura1 if lndura1<=3.14, ///
	clpattern(solid dash dash) ///
	yline(0, lpattern(solid) lwidth(vvthin)) ///
	yaxis(1) ylabel(#4)), ///
	xtitle("ln(Tenure)", size(3.5)) ///
	ytitle("ln(FDI Inflows)", size(3.5)) ///
	yscale(titlegap(*+10)) ///
	title("(1) Military/Personalist", size(3)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	legend(off) scheme(s1mono) saving(militarypersonal, replace)
restore

preserve 
xtscc $fdiinflow lndura1 lndura2 $control if gwfpar==1, fe
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
xtscc $fdiinflow lndura1 lndura2 $control if gwfpar==1, fe
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
twoway (line PROB PROBlow PROBhigh lndura1 if lndura1<=3.14, ///
	clpattern(solid dash dash) ///
	yline(0, lpattern(solid) lwidth(vvthin)) ///
	yaxis(1) ylabel(#4)), ///
	xtitle("ln(Tenure)", size(3.5)) ///
	ytitle("ln(FDI Inflows)", size(3.5)) ///
	yscale(titlegap(*+10)) ///
	title("(2) Single Party", size(3)) ///
	plotregion(fcolor(white)) graphregion(fcolor(white)) ///
	legend(off) scheme(s1mono) saving(singleparty, replace)
restore

graph combine militarypersonal.gph singleparty.gph, ycommon saving(autoregime, replace)
graph export autoregime.pdf, as(pdf) replace




*** Appendix 7: Table 10 ***
xtset ccode year
xtreg $fdiinflow L.lnfdiUN lndura1 lndura2 $control if cgvdem==0, fe
xtreg $fdiinflow L.lnfdiUN lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe
xtreg $fdiinflow L.lnfdiUN lnexecdura lnexecdura2 $control if cgvregime==2, fe
xtreg $fdiinflow L.lnfdiUN execquota execquota2 $control if cgvregime==1 | cgvregime==2, fe
xtreg $fdiinflow L.lnfdiUN execquota execquota2 $control if cgvregime==2, fe


*** Appendix 8 ***
 
* Table 11 
xtscc $fdiinflow lndura1 lndura2 $control $year if cgvdem==0, fe
xtscc $fdiinflow lnexecdura lnexecdura2 $control $year if cgvregime==1 | cgvregime==2, fe
xtscc $fdiinflow lnexecdura lnexecdura2 $control $year if cgvregime==2, fe
xtscc $fdiinflow execquota execquota2 $control $year if cgvregime==1 | cgvregime==2, fe
xtscc $fdiinflow execquota execquota2 $control $year if cgvregime==2, fe

* Table 12
xtreg $fdiinflow L.lnfdiUN lndura1 lndura2 $control $year if cgvdem==0, fe
xtreg $fdiinflow L.lnfdiUN lnexecdura lnexecdura2 $control $year if cgvregime==1 | cgvregime==2, fe
xtreg $fdiinflow L.lnfdiUN lnexecdura lnexecdura2 $control $year if cgvregime==2, fe
xtreg $fdiinflow L.lnfdiUN execquota execquota2 $control $year if cgvregime==1 | cgvregime==2, fe
xtreg $fdiinflow L.lnfdiUN execquota execquota2 $control $year if cgvregime==2, fe


*** Appendix 9 ***

* Table 13 
probit archfail gdppcL1 growth age oilL1 lnaiddata colonydum coupL1 priointrawarL1 lnbanksindexL1 cgvmil archdura1 archdura2 archdura3 $country if cgvdem==0
gen sample = e(sample)
capture drop athxb athse athpr athres
predict athxb if e(sample), xb
predict athse if e(sample), stdp
predict athpr if e(sample), pr

* Table 14 
xtpcse $fdiinflow athxb $control $country if cgvdem==0 & sample, pair cor(ar1)
xtscc $fdiinflow athxb $control if cgvdem==0 & sample, fe


*** Appendix 10: Table 15 ***
gen lnexecdura_gr = lnexecdura * growth
gen lnexecdura_gr2 = lnexecdura2 * growth
xtpcse $fdiinflow lnexecdura lnexecdura2 lnexecdura_gr lnexecdura_gr2 $control $country if cgvregime==1 | cgvregime==2, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 lnexecdura_gr lnexecdura_gr2 $control if cgvregime==1 | cgvregime==2, fe
xtpcse $fdiinflow lnexecdura lnexecdura2 lnexecdura_gr lnexecdura_gr2 $control $country if cgvregime==2, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 lnexecdura_gr lnexecdura_gr2 $control if cgvregime==2, fe


*** Appendix 11: Figure 2 ***
xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0, fe
mat automargin = J(400,3,0)  
forvalues i = 1(1)400 {
	quietly lincom lndura1 + (lndura2*`i'/100)
	scalar k = `i'
	mat automargin[k,1] = r(estimate)	
	mat automargin[k,2] = r(estimate) - (1.96*r(se))							
	mat automargin[k,3] = r(estimate) + (1.96*r(se))							
}
capture drop automargin*
svmat double automargin
capture drop x_lndura
gen x_lndura = _n/100
save automargin, replace
twoway (line automargin1 automargin2 automargin3 x_lndura if x_lndura<4, ///
		yline(0, lstyle(foreground)) ///
		clpattern(solid dash dash) yaxis(1)), ///
		legend(off) ///
		ytitle("Marginal Effect of Tenure", size(3)) title("", size(3)) scheme(s1mono)  ///
		xtitle("Tenure") saving(automargin, replace) 

xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==1 | cgvregime==2, fe
mat demmargin = J(420,3,0)  
forvalues i = 1(1)420 {
	quietly lincom lnexecdura + (lnexecdura2*`i'/100)
	scalar k = `i'
	mat demmargin[k,1] = r(estimate)	
	mat demmargin[k,2] = r(estimate) - (1.96*r(se))							
	mat demmargin[k,3] = r(estimate) + (1.96*r(se))							
}
capture drop demmargin*
svmat double demmargin
capture drop x_lnexecdura
gen x_lnexecdura = _n/100
save automargin, replace
twoway (line demmargin1 demmargin2 demmargin3 x_lndura if x_lnexecdura<4.2, ///
		yline(0, lstyle(foreground)) ///
		clpattern(solid dash dash) yaxis(1)), ///
		legend(off) ///
		ytitle("Marginal Effect of Election Proximity", size(3)) title("", size(3)) scheme(s1mono)  ///
		xtitle("Election Proximity") saving(demmargin, replace) 
graph combine automargin.gph demmargin.gph, saving(margin, replace)  		
graph export margin.pdf, as(pdf) replace


*** Appendix 12: Table 16 ***
xtscc $fdiinflow lndura1 lndura2 $control veto PWT81_xr2 cimmark econcrisis if cgvdem==0, fe
xtscc $fdiinflow lnexecdura lnexecdura2 $control veto PWT81_xr2 cimmark econcrisis if cgvregime==1 | cgvregime==2, fe
xtscc $fdiinflow lnexecdura lnexecdura2 $control veto PWT81_xr2 cimmark econcrisis if cgvregime==2, fe


*** Appendix 13 ***

* Table 17 
xtpcse $fdiinflow lndura1 lndura2 $control $country if cgvdem==0 & oecd==0, pair cor(ar1)
xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0 & oecd==0, fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if (cgvregime==1 | cgvregime==2) & oecd==0, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if (cgvregime==1 | cgvregime==2) & oecd==0, fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if cgvregime==2 & oecd==0, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==2 & oecd==0, fe

* Table 18 
xtpcse $fdiinflow lndura1 lndura2 $control $country if cgvdem==0 & oecd==1, pair cor(ar1)
xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0 & oecd==1, fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if (cgvregime==1 | cgvregime==2) & oecd==1, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if (cgvregime==1 | cgvregime==2) & oecd==1, fe
xtpcse $fdiinflow lnexecdura lnexecdura2 $control $country if cgvregime==2 & oecd==1, pair cor(ar1)
xtscc $fdiinflow lnexecdura lnexecdura2 $control if cgvregime==2 & oecd==1, fe


*** Appendix 13: Table 19 ***
xtpcse $fdiinflow lndura1 lndura2 $control $country if cgvdem==0 & ccode~=830 & ccode~=732 & ccode~=713 & ccode~=710, pair cor(ar1)
xtscc $fdiinflow lndura1 lndura2 $control if cgvdem==0 & ccode~=830 & ccode~=732 & ccode~=713 & ccode~=710, fe

