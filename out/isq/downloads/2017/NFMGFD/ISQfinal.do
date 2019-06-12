*************************************************
*						*
*  File name: ISQfinal.do			*
*  Date: 6.26.14				*
*  Author: Joseph Wright			*	
*						*
*  Using data files: 				*
*						*
*	ATH.dta					*
*	ChinnIto2010_merge.dta 			*
*	emig12.dta 				*
*	gdpdeflator.dta 			*
*	GWFtscs.dta 				*
*	Hendrix.dta				*
*	nelda3.dta				*
*	netmigration.dta			*
*	remit_original.dta			*
*	rugged_data.dta				*
*	scad_original.dta			*
*	voteshares.dta				*
*	wdi-original3.dta			*
*						*
*  Using do files: 				*
*						*
*	clean_nelda.do				*
*	cowcodes.do				*
*	SCAD_prep.do				*
*	statecapacity.do			*
*	two.do					*
*						*	
*************************************************


capture log close
log using remittance.log, replace

**************************
***MERGE and CLEAN data***
**************************
***USE STATA 12.1***
qui do statecapacity
qui do clean_nelda
use ATH, clear 
set scheme lean1
set more off
sort cow year
merge cow year using ChinnIto2010_merge 
tab _merge  
drop if _merge==2
drop _merge
sort cow year
saveold temp, replace

*Merge Migration and State capacity data here*
merge cow year using statecapacity
tab _merge
drop if _merge==2
drop _merge
drop country
sort cow year 
saveold temp, replace
use netmigration, clear    	/*  WDI series under Labor and Social Protection, and under Migration:  Net migration(SM.POP.NETM) */
rename countryname country
gen cowcode=.
qui do cowcodes  /* countries without cowcodes are not in the GWF data set */
drop if cow==.
sort cow year
bysort cow: replace net = netmigration[_n-1] if net==. & netmigration[_n-1]~=.
keep cow year country  net
sort cow year
merge cow year using temp
tab _merge
drop _merge country
sort cow year
saveold temp, replace

use emig12, clear
drop if cow==.
gen repeat = year==year[_n-1] if cow==cow[_n-1]
drop if repeat==1
tsset cow year
gen moses_emigpc = ln(1+ (l.emig12/l.population))
rename country moses_country
gen moses_emig12original = emig12
keep cow year moses*
sort cow year
merge cow year using temp
tab _merge 
drop if _merge==1
drop _merge
sort cow year 
save temp, replace

merge cow year using nelda_merge
tab _merge
drop if _merge==2
drop _merge
rename nelda_country neldacountry
recode nelda_*   (.=0)  /* 1960 - 2010 so covers entire sample period */
sort cow year
save temp, replace

use wdi-original3, clear
gen cowcode = .
qui do "cowcodes.do"
drop if cowcode == .
tsset cow year
tssmooth ma wdi_l12population = populationtotal, window(2 0 0)
replace wdi_l12population = wdi_l12population/1000
gen pop = ln(l1.populationtotal)
keep cow year pop wdi*
label var wdi_l12population "Population (lagged two-year moving average), in thousands"
label var pop "Log population, lagged 1 year"
order cowcode year
sort cowcode year
merge cow year using temp
tab _merge 
drop if _merge == 1
drop _merge
sort cow year
saveold temp, replace

gen ged_dem =  geddes_fail_subsregime
recode ged_dem (3=0) (2=0) (4=0)
tab ged_dem geddes_fail_subs
recode ged_dem (0=1) if (cowcode==265 & year==1990 ) | (cowcode==365 & year==1991)  /*East Germany Russia*/
gen ged_dict = geddes_dict
recode ged_dict (1=0) if ged_dem==1
tsset cow year
sort cow year
 
gen ged_time = geddes_duration
replace ged_time = ged_time-63 if cow==530 & ged_time>90 /*Ethiopia monarchy begin in 1918*/
replace ged_time = ged_time-38 if cow==550 & ged_time>30 /*SAfrica NP begin in 1948*/
replace ged_time = ged_time-177 if cow==698 & ged_time>200 /*Oman monarchy begin in 1918*/
replace ged_time = ged_time-100 if cow==530 & ged_time>99 /*Nepal monarchy begin in 1946*/
gen ged_time2 = ged_time^2
gen ged_time3 = ged_time^3
tsset cow year
sort cow year

gen aid = sqrt(1+abs(wdi_l12aidpc))
label var aid "Aid"
tssmooth ma oil = ross_loil, window(2 0 0)
label var oil "Oil"
tssmooth ma r = wdi_remitc, window(1 0 0)
tssmooth ma r2 = wdi_remitc, window(2 0 0)
gen remit = ln(1+ (r/exp(pop)))   /* pop is lagged one year and logged */
gen remit_nopop = ln(1+r)
gen remit_2 = ln(1+(r2/(wdi_l12pop*1000)))
tssmooth ma kaopen = chinnito_kaopen, window(2 0 0)
gen migration = ln(1+abs(netmigration/(wdi_popl*1000)))   /* log the absolute value so as not to log negative values */
replace migration = migration*-1 if netmigration<0  /* get back the negative net migration */
gen protest = ln(1+l.banks_riot + l.banks_antigov + l.banks_genstrik)
gen remitXprotest  = remit*protest
qui reg pts_s pts_a, nocon
matrix b = e(b)
local b = b[1,1]
gen repression = l.pts_s
	replace repression = l.pts_a * `b' if repression ==.
forval x = 1/3 {
	egen maxstat`x' = max(m_statcap`x') , by(cow)				/* use the mean from 1984-1999 foreach country and apply to all years in country */
	replace m_statcap`x' = maxstat`x'
	drop maxstat
}

gen sp = geddes_party  if geddes_party~=. 		/* All dominant party regimes */
gen sp1 = geddes_regime=="sparty" if sp~=.		/* Pure dominant party regimes */
gen sp2 = geddes_regime~="sparty" & sp==1 if sp~=.	/* Hybrid dominant party regimes */
tab sp1 sp2
gen sp_remit_nopop = sp*remit_nopop
gen sp_remit_2 = sp*remit_2
gen pers = geddes_pers
gen time = year-1975
gen time2 = time^2
gen time3 = time^3

qui probit ged_dem sp remit if year>=1975
gen s = 1 if e(sample)
sort cow year
saveold temp, replace


******************
***Intro Figure***
******************
use temp, clear
gen remitpc=wdi_remitc/(wdi_popl*1000)
egen s_aid = sd(wdi_aidpc) if ged_time~=. & year>1960, by(cow)
egen s_remit = sd(remitpc) if ged_time~=. & year>1960, by(cow)
egen s_oil = sd(ross_oilgasrentPOP) if ged_time~=. & year>1960, by(cow)
sum s_*
egen m_aid= mean(wdi_aidpc) if ged_time~=., by(year)
egen m_oil= mean(ross_oilgasrentPOP)  if ged_time~=., by(year)
egen m_remitpc= mean(remitpc)  if ged_time~=., by(year)
tssmooth ma m2_aid = m_aid, window(1 1 0)
tssmooth ma m2_oil = m_oil, window(1 1 0)
tssmooth ma m2_remitpc= m_remitpc, window(1 1 0)
label var m2_aid "Foreign Aid"
label var m2_oil "Oil Rents per capita"
label var m2_remitpc "Remittances"
label var year "Year"
drop if year<1960
egen tag = tag(year) if m2_aid~=. & m2_oil~=. & m2_remitpc~=.
keep if tag==1
set scheme lean1
twoway (line m2_remitpc year, sort yaxis(1) ytitle("Aid/Remittances per capita") /*
*/  legend(pos(12) label(1 "Remittances") label(3 "Foreign aid") label(3 "Oil rents") col(3) ring(1))) /*
*/  (line m2_aid year, sort yaxis(1)) /*
*/  (line m2_oil year, sort   yaxis(2))
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\ForeignIncome.pdf", as(pdf)   replace

**************************
***Unit Effects Program***
**************************
capture program drop uniteffxRE
program define uniteffxRE
	use temp, clear
	gen gdp = l.wdi_lgdp
	gen nbr = l.neighbor_geddem 
	gen gr = wdi_lag12
	recode nbr (3=2) (4=2) (5=2)
	gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
	replace civwar = civwar*prio_lconflict_int 
	qui probit $y $x1 $x2 if year>=1975
	qui gen fsample = e(sample)
	local vars " $x1 $x2 $t"
	foreach z of local vars {
		egen cm_`z' = mean(`z') if fsample==1, by(cow)
		egen ym_`z' = mean(`z') if fsample==1, by(year)
	}
	qui probit $y $x1 $x2 cm_*  if year>=1975 
	gen sp_remit = sp*remit
	local vars "sp_remit"
	foreach z of local vars {
		egen cmsp_`z' = mean(`z') if fsample==1, by(cow)
		egen ymsp_`z' = mean(`z') if fsample==1, by(year)
	}
	qui gllamm $y $x1 $x2 $t cm_*  if year>=1975 & cow~=$cow,  adapt fam(bin) link(probit) i(cow) cluster(cow)
	lincom remit
	global i = $i +1
	est store pr$i
	sum year if e(sample)
	
	probit $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow
	lroc, nograph
	lincom remit
	lincom remit + sp_remit
	probit $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow, cluster(cow)
	lincom remit
	lincom remit + sp_remit
	xtprobit $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow, i(cow)
	lincom remit
	lincom remit + sp_remit
	gllamm $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow,  adapt fam(bin) link(probit) i(cow) cluster(cow)
	lincom remit
	lincom remit + sp_remit
	global i = $i +1
	est store pr$i
end


capture program drop uniteffx
program define uniteffx
	use temp, clear
	gen gdp = l.wdi_lgdp
	gen nbr = l.neighbor_geddem 
	gen gr = wdi_lag12
	recode nbr (3=2) (4=2) (5=2)
	gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
	replace civwar = civwar*prio_lconflict_int 
	qui probit $y $x1 $x2 if year>=1975
	qui gen fsample = e(sample)
	local vars "$x1 $x2 $t"
	foreach z of local vars {
		egen cm_`z' = mean(`z') if fsample==1, by(cow)
		egen ym_`z' = mean(`z') if fsample==1, by(year)
	}
	qui probit $y $x1 $x2 cm_*  if year>=1975 
	gen sp_remit = sp*remit
	local vars "sp_remit"
	foreach z of local vars {
		egen cmsp_`z' = mean(`z') if fsample==1, by(cow)
		egen ymsp_`z' = mean(`z') if fsample==1, by(year)
	}
	qui probit $y $x1 $x2 $t cm_*  if year>=1975 & cow~=$cow, cluster(cow)
	lincom remit
	lroc, nograph
	global i = $i +1
	est store pr$i
	sum year if e(sample)
	
	qui probit $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow, cluster(cow)
	lincom remit
	lincom remit + sp_remit
	lroc, nograph
	global i = $i +1
	est store pr$i
end


*********************************
***One-Stage Models in Table 1***
*********************************
global cow = 0  /*include all countries in sample*/
global i = 0
global x1 = "remit"
global y ="ged_dem"
global t = "ged_time ged_time2 time time2"

*columns 1 & 2*
global x2 = "sp"
uniteffxRE

*columns 3 & 4*
global x2 = "gdp pop civwar nbr sp"
uniteffxRE

*columns 5 & 6*
global x2 = "gdp pop civwar nbr sp migration"
uniteffxRE

*columns 7 & 8*
global x2 = "gdp pop civwar nbr sp migration gr protest"
uniteffxRE

*columns 9 & 10*
global x2 = "gdp pop civwar nbr sp migration gr protest aid oil kaopen"
uniteffxRE

estout pr1 pr2 pr3 pr4 pr5 pr6 pr7 pr8 pr9 pr10 using Table1.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01) title(Remittances and democratic transition)
sort cow year
saveold temp1, replace


** Check for NPH **
use temp, clear
gen spgtime = sp*ged_time
gen spgtime2 = sp*ged_time2
gen gdp = l.wdi_lgdp
gen nbr = l.neighbor_geddem 
gen gr = wdi_lag12
recode nbr (3=2) (4=2) (5=2)
gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
replace civwar = civwar*prio_lconflict_int 
qui probit $y $x1 $x2 if year>=1975
qui gen fsample = e(sample)
local vars " $x1 $x2 $t"
foreach z of local vars {
	egen cm_`z' = mean(`z') if fsample==1, by(cow)
	egen ym_`z' = mean(`z') if fsample==1, by(year)
}
qui probit $y $x1 $x2 cm_*  if year>=1975 
gen sp_remit = sp*remit
local vars "sp_remit"
foreach z of local vars {
	egen cmsp_`z' = mean(`z') if fsample==1, by(cow)
	egen ymsp_`z' = mean(`z') if fsample==1, by(year)
}
global t = "ged_time ged_time2 spgtime spgtime2 time time2"
global x2 = "gdp pop civwar nbr sp gr"
qui probit $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow, cluster(cow)
test spgtime spgtime2
lincom remit + sp_remit
lincom sp_remit
lincom remit
qui xtprobit $y $x1 sp_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow, i(cow) re
test spgtime spgtime2
lincom remit + sp_remit
lincom sp_remit
lincom remit	 

 
**********************************
***Exclude one sparty at a time***
**********************************
use temp1, clear
global cow =0
global t = "ged_time ged_time2 time time2"
global x2 = "gdp pop civwar nbr sp"
global y ="ged_dem"
uniteffx
tab cow if e(sample) &  ged_dem==1 & sp==1 /* This lists all the cowcodes for party regimes that democratize in the sample*/
local i=1
local vars = "1 70 92 93 150 345 370 420 433 437 451 471 481 484 501 510 517 530 540 541 551 552 565 570 571 615 616 630 651 652 701 710 780 811 812 816 820 850"
foreach c of local vars {
	global cow = `c'
	global x2 = "gdp pop civwar nbr sp"
	global y ="ged_dem"
	uniteffx
	nlcom _b[remit] + _b[sp_remit], post
      matrix coeff`c' =e(b) 
	local i = `i' +1 
}
gen f0=.
local i=1
local vars = "1 70 92 93 150 345 370 420 433 437 451 471 481 484 501 510 517 530 540 541 551 552 565 570 571 615 616 630 651 652 701 710 780 811 812 816 820 850"
foreach c of local vars {
	replace f0 = coeff`c'[1,1] if _n==`i'
	local i = `i' +1 
}
local a = coeff1[1,1] /*full sample beta*/ 
twoway (hist f0 if _n>1, bin(50) xlabel(0 (.2) 0.8) xscale(range(0 0.8)) xline(`a', lpattern(dash)) yscale(off) xtitle("Coefficients for Remittances (in party regimes)", size(small)) /*
*/ legend(label(1 "Estimates from dropping one country at a time") pos(12) col(1) ring(2)))|| function x = `a',xvarlab("Full sample coefficient")  
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\RemittanceBetasParty.pdf", as(pdf)   replace


*********************************************************
***Simulation of substantive effect at average values ***  e.g. Matt Golder's code
*********************************************************
global cow=0
global i = 0
global t = "ged_time ged_time2 time time2"
global x1 = "remit"
global x2 = "gdp pop civwar nbr sp"
global y ="ged_dem"
uniteffx
sum remit cm_remit  if e(sample)
gllamm $y $x1 sp_remit sp $t  gdp pop civwar nbr cm_*  cmsp_* if year>=1975 , adapt fam(bin) link(probit) i(cow) cluster(cow)
set seed 339487731
drawnorm b1-b24, n(10000) means(e(b)) cov(e(V))  clear 
gen prob_sp=.
gen prob_nsp=.
gen a =.
gen r_axis = (_n-1)/20 + 0 if _n<=91
/*We want remit to run from 0 to 4.5*/ 
local a=0
local t = 16
local gt = 17
while `a' <= 4.5 {
	gen x_betaSP = b1*`a'+b2*`a'+b3*1+b4*`gt'+b5*(`gt'^2)+b6*`t'+b7*(`t'^2)+ /*
		*/ b8*6.6+b9*16.2+b10*0.3+b11*0.4+ /*
		*/ b12*2.5+    b13*6.6 + b14*16.2 + b15*0.3 + b16*0.4 + /*
		*/ b17*0.9+b18*`gt'+b19*(`gt'^2)+b20*`t'+b21*(`t'^2)+b22*2.25+b23*1
	gen x_betaNSP= b1*`a'+b2*0+b3*0+b4*`gt'+b5*(`gt'^2)+b6*`t'+b7*(`t'^2)+ /*
		*/ b8*6.6+b9*16.2+b10*0.3+b11*0.4+ /*
		*/ b12*2.5+    b13*6.6 + b14*16.2 + b15*0.3 + b16*0.4 + /*
		*/ b17*0.1+b18*`gt'+b19*(`gt'^2)+b20*`t'+b21*(`t'^2)+b22*0.13+b23*1
	gen probSP = normal(x_betaSP)
	gen probNSP = normal(x_betaNSP)
	egen probhatSP=mean(probSP)
	egen probhatNSP=mean(probNSP)
 	quietly replace a = `a' 
	quietly replace prob_sp =  probhatSP if r_axis==a
	quietly replace prob_nsp =  probhatNSP if r_axis==a
	drop x_* probSP* probNSP* probhat* 
	local a = `a' + .05
}
*replace r_axis = exp(r_axis)
label var r_axis "Remittances per capita (log)"
label var prob_sp "Party"
label var prob_nsp "Non-Party"
set scheme lean1
merge using temp
probit ged_dem remit sp if year>=1975
gen f = e(sample)
label var remit "Remittance distribution"
twoway  (hist remit if remit<4.5 & f==1, lcolor(gs12) bin(100) yaxis(2)) (line prob_sp r_axis if r_axis<4.5, yaxis(1))  (line prob_nsp r_axis if r_axis<4.5, yaxis(1)) /*
*/ ,  xtitle("Remittances per capita (log)", size(3.5)) ytitle("Pr(Democratic Transition)", size(3.5)) legend(pos(12) col(3) ring(0)) /*
*/  xscale(range (0 4.5)) xlabel(0 (.5) 4.5)
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\Remit.pdf", as(pdf)  replace

*********************************************
*** Simulation of average marginal effect ***  e.g. Hanmer AJPS 2013
*********************************************
global x2 = "gdp pop civwar nbr sp"
global x1 = "remit"
global t = "ged_time ged_time2 time time2"
 
capture program drop margEFX
program define margEFX
	qui uniteffx
	centile remit if sp==1 & e(sample), centile(25, 75)
	global sp1 = r(c_2) - r(c_1)
	centile remit if sp==0 & e(sample), centile(25, 75)
	global sp0 = r(c_2) - r(c_1)

	probit $y $x1 sp_remit sp $t  gdp pop civwar nbr cm_*  cmsp_* if year>=1975 ,   cluster(cow)
	keep if e(sample)==1
	save temp1, replace
	set seed 339487731
	drawnorm b1-b23, n(1000) means(e(b)) cov(e(V))  clear 
	merge using temp1

	 gen marg_remitsp1=.
	 forvalues i = 1/1000 {
		qui gen p_`i' = normalden(b1[`i']*remit + b2[`i']*sp_remit + b3[`i']*sp + b4[`i']*ged_time +b5[`i']*ged_time2 +b6[`i']*time +/*
		*/ b7[`i']*time2 +b8[`i']*gdp +b9[`i']*pop +b10[`i']*civwar +b11[`i']*nbr +b12[`i']*cm_remit +b13[`i']*cm_gdp + /*
		*/ b14[`i']*cm_pop +b15[`i']*cm_civwar +b17[`i']*cm_nbr +b17[`i']*cm_sp +b18[`i']*cm_ged_time +b19[`i']*cm_ged_time2  /*
		*/ +b20[`i']*cm_time + b21[`i']*cm_time2 + b22[`i']*cmsp_sp_remit + b23[`i'] )*(b1[`i'] +  b2[`i'])*$sp1
		qui summarize p_`i', meanonly
		qui replace marg_remitsp1 = r(mean) in `i'
	}
	drop p_1-p_1000
	 
	 gen marg_remitsp0=.
	 forvalues i = 1/1000 {
		qui gen p_`i' = normalden(b1[`i']*remit + b2[`i']*sp_remit + b3[`i']*sp + b4[`i']*ged_time +b5[`i']*ged_time2 +b6[`i']*time +/*
		*/ b7[`i']*time2 +b8[`i']*gdp +b9[`i']*pop +b10[`i']*civwar +b11[`i']*nbr +b12[`i']*cm_remit +b13[`i']*cm_gdp + /*
		*/ b14[`i']*cm_pop +b15[`i']*cm_civwar +b17[`i']*cm_nbr +b17[`i']*cm_sp +b18[`i']*cm_ged_time +b19[`i']*cm_ged_time2  /*
		*/ +b20[`i']*cm_time + b21[`i']*cm_time2 + b22[`i']*cmsp_sp_remit + b23[`i'] )*(b1[`i'])*$sp0
		qui summarize p_`i', meanonly
		qui replace marg_remitsp0 = r(mean) in `i'
	}
	drop p_1-p_1000
	twoway (kdensity marg_remitsp1)  (kdensity marg_remitsp0) 
	gen est = .
	gen hi = .
	gen lo =.
	*Party regimes*
	centile marg_remitsp1, centile(2.5, 97.5)
	replace lo = r(c_1) if _n==1
	replace hi = r(c_2) if _n==1
	sum marg_remitsp1, meanonly
	replace est = r(mean) if _n==1
	*Non-party regimes*
	centile marg_remitsp0, centile(2.5, 97.5)
	replace lo = r(c_1) if _n==2
	replace hi = r(c_2) if _n==2
	sum marg_remitsp0, meanonly
	replace est = r(mean) if _n==2
	gen n=_n
	gen rest = round(est,.01)
	label define type1 1 "Party regime" 2 "Non-party regime" 
	label values n type1
	twoway (scatter est n if n<3, xscale(range(0.5 2.5)) xlabel(1 2, labsize(small)  valuel) xtitle("") yline(0,  lpattern(dash)) mlabel(rest) ytitle("Marginal effect of Remittances"))/*
	*/ (rspike  hi lo n  if n<3, ylabel(-.05 (0.05) 0.25) legend(label(1 "Estimate") label(2 "95% CI")  pos(12) col(2) ring(1)))
	graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\AveMargEFX$y.pdf", as(pdf)  replace
end

global y ="ged_dem"
margEFX
global y ="ged_dict"
margEFX


**********************
***Two-Stage Models***
**********************
set more off
set scheme lean1
do two

******************************************
********** Incumbent Vote Share **********
******************************************
use voteshares, clear
sort cow year
merge cow year using temp
tab _merge
drop _merge
tsset cow year

replace vote = vote/100
replace lastvote =  lastvote/100
gen diffvote = vote-lastvote
gen gr = l.wdi_gdppcgrowth
gen exp = l.wdi_expend
gen civilwar = prio_lconflict_intra>0 if prio_lconflict_intra~=.

* Error-correction models: intervals between elections are not equal so I don't know the proper lag *
* Thus I test for different lags, up to 4 years, because the ECM assumes a common lag for all units *
gen r1 = ln(1+(wdi_remitc/(wdi_pop*1000)))
forval i = 1/4 {
	qui gen d`i'gr = d`i'.gr
	qui gen d`i'remit = d`i'.r1
	qui tssmooth ma remit`i' = r1, window(`i' 0 0)
	qui tssmooth ma gr`i' = gr, window(`i' 0 0)
	xi: ivreg vote (diff= lastvote) i.sp*d`i'remit i.sp*remit`i' d`i'gr gr`i' if ged_dem!=., robust
	est store voteC`i'
}
forval i = 1/4 {
	est restore voteC`i'
	lincom  remit`i'
	lincom  remit`i' +  _IspXrem
}

gen spremit = sp*remit
gen spremit3 = sp*remit3


*Raw vote, Remittances lagged just one year
reg vote lastvote sp remit gr if ged_dem!=.
sum remit if e(sample), detail /*1.5 is from the 25%tile to the 75%tile in the remit distribution in sample*/
lincom remit*1.5
reg vote lastvote sp remit spremit gr if ged_dem!=.
lincom remit*1.5
lincom (remit + spremit)*1.5
*Get sample for Appendix*
*browse geddes_country year vote last if e(sample)
hist diff if e(sample), bin(25)

*Raw vote, Remittances lagged three years
reg vote lastvote sp remit3 gr if ged_dem!=., cluster(cow)
sum remit if e(sample), detail /*1.5 is from the 25%tile to the 75%tile in the remit distribution in sample*/
lincom remit3*1.56
reg vote lastvote sp remit3 spremit3 gr if ged_dem!=.
lincom remit3*1.56
lincom (remit3 + spremit3)*1.56


** REPORTED MODELS **
*Logit transform to get unbounded variable for OLS*
glm vote lastvote sp remit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
est store vote1
glm vote lastvote sp remit3 spremit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3
lincom (remit3 + spremit3)
est store vote2
 
*Add more control variables*
glm vote lastvote sp remit3 gr civilwar exp ged_time migration time time2 if ged_dem!=., family(bin) link(logit) cluster(cow)
est store vote3
glm vote lastvote sp remit3 spremit3 gr civilwar exp migration ged_time time time2 if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3
lincom (remit3 + spremit3)
est store vote4

*Region and Year effects*
gen region = geddes_region=="samerica" | geddes_region=="cacar" if geddes_region~=""
replace region =2 if geddes_region=="ssafrica"  
replace region= 3 if geddes_region=="casia" | geddes_region=="easia"  
replace region = 4 if geddes_region=="ceeurope" | geddes_region=="weu" 
local i=0
while `i'<12 {
	sort cowcode year
	bysort cowcode: replace region = region[_n-1] if region==. & region[_n-1]~=. & cowcode==cowcode[_n-1]
	bysort cowcode: replace region = region[_n+1] if region==. & region[_n+1]~=. & cowcode==cowcode[_n+1]
	local i = `i'+1
}
qui glm vote i.region i.year lastvote sp remit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
est store vote5
lincom remit3 
qui glm vote i.region i.year lastvote sp remit3 spremit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3 
lincom (remit3 + spremit3)
est store vote6

*Country fixed effects
qui glm vote i.cow sp remit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
est store vote7
lincom remit3 
qui glm vote i.cow  sp remit3 spremit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3 
 lincom (remit3 + spremit3)
est store vote8

*Allow for country-specific Cold War intercept (not reported)
gen cw = year<1989
xi: qui glm vote i.cow*cw  sp remit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3 
xi: qui glm vote i.cow*cw  sp remit3 spremit3 gr if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3 
 lincom (remit3 + spremit3)
 


** FOR APPENDIX **
**No control variables**
glm vote lastvote sp remit3 spremit3   if ged_dem!=., family(bin) link(logit) cluster(cow)
lincom remit3
lincom (remit3 + spremit3)
est store voteC5
*Address multivariate outliers*
hadimvo vote lastvote sp remit3 spremit3 gr if ged_dem!=., gen(out dist)
tab out
hist vote, bin(20)
reg vote lastvote sp remit3 spremit3 gr if ged_dem!=. & dist<4
reg vote lastvote sp remit3 spremit3 gr if ged_dem!=. 
avplot spremit3, mlabel(cow)
glm vote lastvote sp remit3 spremit3 gr if ged_dem!=. & cow~=345 & cow~=510  , family(bin) link(logit) cluster(cow) /*potential bivariate outliers*/
glm vote lastvote sp remit3 spremit3 gr if ged_dem!=. & out==0, family(bin) link(logit) cluster(cow)
lincom remit3
lincom (remit3 + spremit3)
est store voteC6
rreg vote lastvote sp remit3 spremit3 gr if ged_dem!=.    /* cannot cluster when estimator is robust regression */
lincom remit3
lincom (remit3 + spremit3)
est store voteC7

reg vote lastvote sp remit3 spremit3 gr if ged_dem!=.
dfbeta
gen cut = 2/sqrt(84)
gen id = _n if e(sample)
twoway (scatter  _dfbeta_2 id,   yline(.22 -.22) mlabel()) /*
*/  (scatter  _dfbeta_3 id,   yline(22 -.22) mlabel()) /*
*/  (scatter  _dfbeta_4 id ,   yline(22 -.22) mlabel() /*
*/ legend(label(1 "Remit (SP)") label(2 "Remit (non-SP)") label(3 "SP") pos(12) col(3) ring(1)))
glm vote lastvote sp remit3 spremit3 gr if ged_dem!=. & abs(_dfbeta_2)<.22 & abs(_dfbeta_3)<.22 & abs(_dfbeta_4)<.22 , family(bin) link(logit) cluster(cow)
lincom remit3*1.56
lincom (remit3 + spremit3)*1.56

estout vote1 vote2 vote3 vote4 vote5 vote6 vote7 vote8  using Table3.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)
estout voteC1 voteC2 voteC3 voteC4 voteC5 voteC6 voteC7 using TableC2.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)

saveold temp2, replace

**************************
*** Vote Share Graph 1 ***
**************************
use temp2, clear
gen est =. 
gen f0=.
gen var_est=.
gen parm=""
gen min =.
gen max=.
 
estimates restore vote2
nlcom (invlogit((_b[remit])*1.56))-.5, post
matrix beta =e(b)   
matrix v =e(V)      
replace var_est = v[1,1] if _n==2
replace est = beta[1,1]  if _n==2

estimates restore vote2
nlcom (invlogit((_b[remit] + _b[spremit3])*1.56))-.5, post
matrix beta =e(b)   
matrix v =e(V)      
replace var_est = v[1,1] if _n==1
replace est = beta[1,1]  if _n==1

replace parm="Non-party regime" if _n==2
replace parm="Party regime" if _n==1
sencode parm, gen(myparm)
replace min = (est-((sqrt(var_est))*1.96)) 
label var min "95% CI"
replace max =(est+((sqrt(var_est))*1.96))  
label var max "95% CI"
replace min= min*100
replace max = max*100
replace est = est*100
gen estr = round(est, .1)
label var estr "Estimate"

graph twoway (rspike min max myparm if _n<3, ytitle("% change in incumbent vote") xtitle("")) /*
*/ (scatter estr myparm if _n<3, mlabel(estr) mlabposition(1)),  /*
*/ xscale(range(.5 2.5)) yli(0, lpattern(dash)) /*
*/ xlab(1 "Party regime" 2 "Non-party regime") legend(pos(12) col(2) ring(1))
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\VoteShare1.pdf", as(pdf)  replace

**************************
*** Vote Share Graph 2 ***
**************************
use temp2, clear
local i=1
local vars = "1 70 92 93 150 345 370 420 433 437 451 471 481 484 501 510 517 530 540 541 551 552 565 570 571 615 616 630 651 652 701 710 780 811 812 816 820 850"
foreach c of local vars {
	qui glm vote lastvote sp remit3 spremit3 gr if ged_dem!=. & cow~=`c', family(bin) link(logit) cluster(cow)
	qui nlcom _b[spremit] + _b[remit], post
      qui matrix coeff`c' =e(b) 
	local i = `i' +1 
}
gen f0=.
local i=1
local vars = "1 70 92 93 150 345 370 420 433 437 451 471 481 484 501 510 517 530 540 541 551 552 565 570 571 615 616 630 651 652 701 710 780 811 812 816 820 850"
foreach c of local vars {
	replace f0 = coeff`c'[1,1] if _n==`i'
	local i = `i' +1 
}
local a = coeff1[1,1] /*full sample beta*/ 
twoway (hist f0 if _n>1, bin(50) xline(`a', lpattern(dash))  xlab(-.5 (.05) 0) yscale(off) xtitle("Coefficient estimates for Remittances (in party regimes)", size(small)) /*
*/ legend(label(1 "Estimates from dropping one country at a time") pos(12) col(1) ring(2)))|| function x = `a', xvarlab("Full sample coefficient")  
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\VoteShare2.pdf", as(pdf)  replace

**************
***Appendix***
**************

***Table S-1***
use temp, clear
gen gdp = l.wdi_lgdp
gen nbr = l.neighbor_geddem 
gen gr = wdi_lag12
recode nbr (3=2) (4=2) (5=2)
gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
replace civwar = civwar*prio_lconflict_int 
sutex ged_dem ged_time remit gdp pop civwar nbr sp time migration gr protest aid oil kaopen if s==1, minmax digit(2)

***Table S-2***
use temp, clear
egen tag = tag(geddes_case) if s==1
egen everdem = max(ged_dem) if s==1, by(geddes_case)
sort geddes_case
*browse geddes_case everdem sp if tag==1
listtex geddes_case everdem sp if tag==1, type rstyle(tabular) head("\begin{tabular}{rrr}""\textit{Autocratic regime} &\textit{Democratize}&\textit{Party regime}\\\\") foot("\end{tabular}")
*browse geddes_case year if s==1

***Table S-3***
use temp, clear
list geddes_case year cow if  geddes_fail_type==1 &  s==1 & geddes_fail==1 & ged_dict==1, clean
list geddes_case year cow if  geddes_fail_type==1 &  s==1 & geddes_fail==1 & ged_dem==1, clean
gen election  = geddes_fail_type==1
* These are: Cameroon 1983, Nigeria 1993, and Madagascar 1975 / * a new leader chosen in a regular autocratic succession changed the formal and informal rules defining the regime after his accession to power while himself remaining in power*/ 
recode election (1=0) if (cow==471  & year==1983) |   (cow==475  & year==1993) | (cow==580  & year==1975)
* These are Peru 2000 (Fujimori resignation) and Pakistan 2008 (Musharaff resignation); keep El Salvador 1994 and South Africa 1994 as elections
recode election (1=0) if (cow==135  & year==2000) |   (cow==770  & year==2008)  
egen tag = tag(geddes_case) if s==1 & geddes_fail==1
sort geddes_case
listtex geddes_case year election if tag==1 & ged_dem==1, type rstyle(tabular) head("\begin{tabular}{rrrr}""\textit{Autocratic regime} &\textit{Year}&\textit{Election}\\")
tab election if tag==1 & ged_dem==1
listtex geddes_case year election if tag==1 & ged_dict==1, type rstyle(tabular) head("\begin{tabular}{rrrr}""\textit{Autocratic regime} &\textit{Year}&\textit{Election}\\")
tab election if tag==1 & ged_dict==1


***************
***Table A-1***
***************
global i = 0
global cow=0
global y ="ged_dem"
global t = "ged_time ged_time2 time time2"

*Control for state capacity
global x2 = "gdp pop civwar nbr sp m_statcap1 m_statcap2 m_statcap3"
global x1 = "remit"
uniteffx     /* RE models won't converge */
*Reduced sample without State Capacity lowers estimate relative to reduced sample with State Capacity
qui probit $y $x1 sp_remit  gdp pop nbr civwar sp $t  cm_time2 cm_time cm_ged_time2 cm_ged_time cm_sp cm_nbr cm_civwar cm_pop cm_gdp cm_remit cmsp_*  if year>=1975 & cow~=$cow, cluster(cow)
lincom remit + sp_remit

*Control for repression
global x2 = "gdp pop civwar nbr sp repression"
global x1 = "remit"
uniteffxRE
 
*Control for protest and remitXprotest
global x2 = "gdp pop civwar nbr sp protest remitXprotest"
global x1 = "remit"
uniteffxRE
 
*No population in denominator of Remit
global x2 = "gdp pop civwar nbr sp"
global x1 = "remit_nopop"
uniteffxRE

*Remit is the lagged two-year moving average 
global x2 = "gdp pop civwar nbr sp"
global x1 = "remit_2"
uniteffxRE
estout pr1 pr2 pr3 pr4 pr5 pr6 pr7 pr8 pr9 pr10  using TableA1.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)

***************
***Table A-2***
***************
 
*RE Probit w. unit and year means
global x2 = "gdp pop civwar nbr sp"
global x1 = "remit"
global t = "ged_time ged_time2"
uniteffx
qui gllamm $y $x1 $x2 $t cm_*  ym_*   if year>=1975 & cow~=$cow,  adapt fam(bin) link(probit) i(cow) cluster(cow)
lincom remit
est store a21
qui gllamm $y $x1 sp_remit $x2 $t cm_* cmsp_* ym_* ymsp_* if year>=1975 & cow~=$cow,  adapt fam(bin) link(probit) i(cow) cluster(cow)
lincom remit
lincom remit + sp_remit
est store a22

*LPM w. country FE 
xi:  xtreg  $y  i.year remit sp pop gdp nbr civwar ged_time* if year>=1975, fe   cluster(cow)
lincom remit
est store lpm1
est store a23
xi:  xtreg  $y i.year remit sp_remit sp pop  gdp  nbr civwar ged_time*  if year>=1975, fe  cluster(cow)
lincom remit
lincom remit  + sp_remit
est store lpm2
est store a24

*Conditional logit*
xi: qui logit $y i.cow  remit sp pop gdp nbr civwar time time2 ged_time, cluster(geddes_case)
est store a25
xi: qui logit $y i.cow  remit sp_remit sp pop gdp nbr civwar time time2 ged_time, cluster(geddes_case)
est store a26
lincom remit
lincom remit + sp_remit

*Drop LA
global x2 = "gdp pop civwar nbr sp"
global x1 = "remit"
global t = "ged_time ged_time2"
uniteffx
qui gllamm $y $x1 $x2 $t cm_*  ym_*   if year>=1975 & cow>200,  adapt fam(bin) link(probit) i(cow) cluster(cow)
lincom remit
est store a37
qui gllamm $y $x1 sp_remit $x2 $t cm_* cmsp_* ym_* ymsp_* if year>=1975 & cow>200,  adapt fam(bin) link(probit) i(cow) cluster(cow)
lincom remit
lincom remit + sp_remit
est store a28
estout pr15 pr16 pr17 pr18 pr19 pr20 pr21 pr22  using TableA2.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)


*Cox with shared frailty*
use temp1, clear
stset ged_time, fail(ged_dem) id(geddes_case)
set seed 879797
stcox  remit sp_remit gdp pop civwar nbr sp time time2  wdi_lag12 if year>=1975, shared(cow) nohr schoenfeld(ssx*) scaledsch(ssy*) forceshared
estat phtest, log detail
lincom remit + sp_remit
stcox  remit gdp pop civwar nbr sp_remit sp time time2 wdi_lag12 if year>=1975, cluster(cow) nohr 
lincom remit + sp_remit
 


**********************************************
*** CGV democratic transition: Appendix Table A-3 ***
**********************************************
capture program drop uniteffx_cg
program define uniteffx_cg
	use temp, clear
	gen gdp = l.wdi_lgdp
	gen nbr = l.neighbor_geddem 
	recode nbr (3=2) (4=2) (5=2)
	gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
	replace civwar = civwar*prio_lconflict_int 
	gen cg_agedict = l.cg_agedem+1
	replace cg_agedict =cg_agedem if cg_agedem>1 & cg_agedem~=. & cg_agedict==.
	replace cg_agedict = 0 if cg_agedem==1 & cg_agedict==.
	gen cg_agedict2 = cg_agedict^2
	gen cg_agedict3 = cg_agedict^3
	gen cg_sp = sp
	replace cg_sp=1 if sp[_n-1]==1 & ged_dem[_n-1]~=. & cg_dem==1
	replace cg_sp=0 if sp[_n-1]==0 & ged_dem[_n-1]~=. & cg_dem==1
	recode cg_sp (.=0)	
	qui probit $y $x1 $x2 if year>=1975
	qui gen fsample = e(sample)
	local vars " $x1 $x2 $t"
	foreach z of local vars {
		egen cm_`z' = mean(`z') if fsample, by(cow)
	}
	gen cgsp_remit = cg_sp*remit
	local vars "cgsp_remit"
	foreach z of local vars {
		egen cm_`z' = mean(`z') if fsample, by(cow)
	}
	qui probit $y $x1 $x2 $t cm_*   if year>=1975, cluster(cow)
	est store cgv1
	qui probit $y $x1 cgsp_remit $x2 $t cm_*  if year>=1975, cluster(cow)
	lincom cgsp_remit + remit
	est store cgv2
end

global t = "cg_agedict cg_agedict2 cg_agedict3 time time2"
global x1 = "remit"
global x2 = "gdp pop civwar nbr cg_sp"
global y ="cg_dem"
uniteffx_cg


xi: xtreg $y i.year $x1 $x2 cg_agedict* if e(sample), fe
lincom remit
est store cgv3
xi: xtreg $y i.year $x1 cgsp_remit $x2 cg_agedict* if e(sample), fe
lincom remit 
lincom remit + cgsp_remit
est store cgv4
est store lpm4

estout cgv1 cgv2 cgv3 cgv4 using TableA3.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)
merge cow year using temp1 
sort cow year
save temp1, replace

*************************************
*** Linear Probability models and graph ***
*************************************
use temp1, clear
tempfile tf1 tf2 tf3 tf4
estimates restore lpm2
lincomest (remit)*3, level(95)
parmest,label saving(`tf2',replace)
estimates restore lpm2
lincomest  (remit + sp_remit)*3, level(95)
parmest,label saving(`tf1',replace)
estimates restore lpm4
lincomest (remit)*3, level(95)
parmest,label saving(`tf4',replace)
estimates restore lpm4
lincomest  (remit + cgsp_remit)*3, level(95)
parmest,label saving(`tf3',replace)
dsconcat `tf1' `tf2'  `tf3' `tf4'  
replace parm="Non-party (GWF)"   if  _n==2
replace parm="Party (GWF)"   if  _n==1
replace parm="Non-party (CGV)"   if  _n==4
replace parm="Party (CGV)"   if  _n==3
sencode parm, gen(myparm)
drop if _n>4
set scheme lean1
gen est  = estimate
gen mx = max
gen mn = min
gen rounde = round(est, .001)
eclplot est mn mx myparm, xscale(range(0.5 4.5)) yscale(range (0 0.1)) /*
*/ ylab(-.04 (.04) .12) xlab(1 2 3 4, labsize(small))  legend(label(1 "Estimate") label(2 "95% CI")  pos(12) col(2) ring(1)) ytitle("Marginal effect of Remittances") /*
*/ xtitle("") plotregion(margin(large)) yline(0, lpattern(dash))  /*
*/ estopts( mlabel(rounde) mlabposition(1))
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\RemitLPM.pdf", as(pdf)   replace

****************************************************
*** Personalist dicatorship interaction: Appendix Table A-4 ***
****************************************************

capture program drop uniteffxP
program define uniteffxP
	use temp, clear
	gen gdp = l.wdi_lgdp
	gen nbr = l.neighbor_geddem 
	gen gr = wdi_lag12
	recode nbr (3=2) (4=2) (5=2)
	gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
	replace civwar = civwar*prio_lconflict_int 
	qui probit $y $x1 $x2 if year>=1975
	qui gen fsample = e(sample)
	local vars " $x1 $x2 $t"
	foreach z of local vars {
		egen cm_`z' = mean(`z') if fsample==1, by(cow)
	}
	qui probit $y $x1 $x2 cm_*  if year>=1975 
	gen sp_remit = sp*remit
	gen pers_remit = pers*remit
	local vars "sp pers"
	foreach z of local vars {
		egen cm`z'_remit = mean(`z'_remit) if fsample==1, by(cow)
	}
	qui probit $y $x1 $x2 $t cm_* if year>=1975, cluster(cow)
	global i = $i +1
	est store pr$i
	sum year if e(sample)
	qui probit $y $x1 sp_remit pers_remit $x2 $t cm_* cmsp_*  cmpers_* if year>=1975,  cluster(cow)
	lincom remit
	lincom remit + sp_remit
	lincom remit + pers_remit
	global i = $i +1
	est store pr$i
end

global i = 0
global x1 = "remit"
global y ="ged_dem"
global t = "ged_time ged_time2 time time2"

global x2 = "sp pers"
uniteffxP

global x2 = "gdp pop civwar nbr sp pers"
uniteffxP

global x2 = "gdp pop civwar nbr sp pers migration"
uniteffxP

global x2 = "gdp pop civwar nbr sp pers migration gr protest"
uniteffxP

global x2 = "gdp pop civwar nbr sp pers migration gr aid oil kaopen"
uniteffxP

estout pr1 pr2 pr3 pr4 pr5 pr6 pr7 pr8 pr9 pr10 using TableA4.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)

use temp, clear
gen remit_gdp = l.wdi_remitg
gen remit_lgdp = ln(1+remit_gdp)
gen remit_pc = remit
label var remit_gdp "Remittances (% GDP)"
label var remit_lgdp "Remittances (% GDP, log)"
label var remit_pc "Remittances (per capita, constant $, log)"
label var remit_nopop "Remittances (constant $, log)"

corr remit_pc remit_gdp remit_nopop if s==1
twoway scatter remit_gdp remit_pc if s==1
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\RemitPCvGDP.pdf", as(pdf)  replace
twoway scatter remit_lgdp remit_pc if s==1
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\RemitPCvLGDP.pdf", as(pdf)  replace
twoway scatter remit_nopop remit_pc if s==1
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\RemitPCvNoPop.pdf", as(pdf)  replace
hist remit_gdp if  s==1 & cow~=570 & cow~=702
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\HistRemitGDP.pdf", as(pdf)  replace
hist remit_pc if  s==1 & cow~=570 & cow~=702  /*Lesotho and Tajikistan are outliers in Remit/GDP */
graph export "C:\Users\jwright\Documents\My Dropbox\Research\RemitDemocracy\March 2014\HistRemitPC.pdf", as(pdf)  replace

****************************************************************
** Separate pure and Hybrid party regimes: Appendix Table A-5 **
****************************************************************

capture program drop uniteffxREsp
program define uniteffxREsp
	use temp, clear
	gen gdp = l.wdi_lgdp
	gen nbr = l.neighbor_geddem 
	recode nbr (3=2) (4=2) (5=2)
	gen civwar=prio_lconflict_intra>0 if prio_lconflict_intra~=.
	replace civwar = civwar*prio_lconflict_int 
	qui probit $y $x1 $x2 if year>=1975
	qui gen fsample = e(sample)
	local vars " $x1 $x2 $t"
	foreach z of local vars {
		egen cm_`z' = mean(`z') if fsample==1, by(cow)
		egen ym_`z' = mean(`z') if fsample==1, by(year)
	}
	qui probit $y $x1 $x2 cm_*  if year>=1975 
	gen sp1_remit = sp1*remit
	gen sp2_remit = sp2*remit
	local vars "sp1_remit sp2_remit"
	foreach z of local vars {
		egen cmsp_`z' = mean(`z') if fsample==1, by(cow)
		egen ymsp_`z' = mean(`z') if fsample==1, by(year)
	}
	qui gllamm $y $x1 $x2 $t cm_*  if year>=1975 & cow~=$cow,  adapt fam(bin) link(probit) i(cow) cluster(cow)
	lincom remit
	global i = $i +1
	est store pr$i
	sum year if e(sample)
	
	gllamm $y $x1 sp1_remit sp2_remit $x2 $t cm_* cmsp_*  if year>=1975 & cow~=$cow,  adapt fam(bin) link(probit) i(cow) cluster(cow)
	lincom remit
	lincom remit + sp1_remit
	lincom remit + sp2_remit
	global i = $i +1
	est store pr$i
end

global cow = 0  /*include all countries in sample*/
global i = 0
global x1 = "remit"
global y ="ged_dem"
global t = "ged_time ged_time2 time time2"
global i = 0
global x2 = "gdp pop civwar nbr sp1 sp2"

uniteffxREsp
estout pr1 pr2 using TableA5.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01) title(Pure party-regimes only, no party-hybrids\label{tab2})

**********************************************
** Autocratic (not democratic) transitions: Table A-6 **
**********************************************

global i = 0
global x1 = "remit"
global y ="ged_dict"
global t = "ged_time ged_time2 time time2"

global x2 = "sp"
uniteffxRE

global x2 = "gdp pop civwar nbr sp"
uniteffxRE

global x2 = "gdp pop civwar nbr sp migration"
uniteffxRE

global x2 = "gdp pop civwar nbr sp migration gr protest"
uniteffxRE

global x2 = "gdp pop civwar nbr sp gr protest migration aid oil kaopen"
uniteffxRE

estout pr1 pr2 pr3 pr4 pr5 pr6 pr7 pr8 pr9 pr10 using TableA6.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)


**********************************
*** Election Models: Table A-7 ***
**********************************
global cow = 0  /*include all countries in sample*/
global i = 0
global x1 = "remit"
global y ="ged_dem"
global t = "ged_time ged_time2 time time2"
global x2 = "gdp pop civwar nbr sp"
global e = "elec"
uniteffx 

gen elec = nelda_incum_c  					/* office of the incumbent is contested */
gen elecXsp = elec*sp
gen elecXremit = remit*elec
gen elecXsp_remit = sp_remit*elec
* Probit with country means *
xi:  qui probit $y  elec sp_remit remit $x2 $t  cm_* cmsp*  if year>=1975 , cluster(cow)
lincom remit 								/* remit, no sp */
lincom remit + sp_remit						/* remit, yes sp */
est store pr1

xi:  qui probit $y  elec remit elecXremit $x2 $t cm_* cmsp*  if year>=1975 , cluster(cow)
lincom remit								/* remit, no election */
lincom remit + elecXremit				/* remit, yes election */
est store pr2

xi:  qui probit $y  elec remit elecXremit sp_remit elecXsp_remit elecXsp  $x2 $t  cm_* cmsp*  if year>=1975 , cluster(cow)
lincom remit 										/* remit, no sp, no election */
lincom remit + sp_remit          					/* remit, yes sp, no election */
lincom remit + elecXremit        					/* remit, no sp, yes election */
lincom remit+sp_remit+elecXremit+ elecXsp_remit 	/* remit, yes sp, yes election */
est store pr3

* FE LPM *
xi:  qui xtreg $y  elec sp_remit remit $x2 $t   if year>=1975 , cluster(cow) fe
lincom remit 								/* remit, no sp */
lincom remit + sp_remit						/* remit, yes sp */
est store pr4

xi: qui xtreg $y  elec remit elecXremit $x2 $t if year>=1975 , cluster(cow) fe
lincom remit								/* remit, no election */
lincom remit + elecXremit				/* remit, yes election */
est store pr5

xi:  qui xtreg $y  elec remit elecXremit sp_remit elecXsp_remit elecXsp $x2 $t  if year>=1975 , cluster(cow) fe
lincom remit 										/* remit, no sp, no election */
lincom remit + sp_remit          					/* remit, yes sp, no election */
lincom remit + elecXremit        					/* remit, no sp, yes election */
lincom remit+sp_remit+elecXremit+ elecXsp_remit 	/* remit, yes sp, yes election */
est store pr6

*Control for migration: not reported
xi:  qui xtreg $y  elec remit elecXremit sp_remit elecXsp_remit elecXsp $x2 $t migration  if year>=1975 , cluster(cow) fe
lincom remit 										/* remit, no sp, no election */
lincom remit + sp_remit          					/* remit, yes sp, no election */
lincom remit + elecXremit        					/* remit, no sp, yes election */
lincom remit+sp_remit+elecXremit+ elecXsp_remit 	/* remit, yes sp, yes election */
 
* Election year models *
	* RE Probit with unit means and SE clustered on country *
qui gllamm $y $x1 $x2 $t cm_*  if year>=1975 & $e==1, adapt fam(bin) link(probit) i(cow) cluster(cow)
lincom remit 								/* remit, no sp */
est store pr7
qui gllamm $y sp_remit $x1 $x2 $t cm_* cmsp* if year>=1975 & $e==1, adapt fam(bin) link(probit) i(cow) cluster(cow)
lincom remit 								/* remit, no sp */
lincom remit + sp_remit	
est store pr8
	* Probit with unit means and SE clustered on country *
qui probit $y sp_remit $x1 $x2 $t  cm_* cmsp* if year>=1975 & $e==1 , cluster(cow)
lincom remit 								/* remit, no sp */
lincom remit + sp_remit						/* remit, yes sp */	
	* RE Probit with SE clustered on country *
qui gllamm $y sp_remit $x1 $x2 $t if year>=1975 & $e==1, adapt fam(bin) link(probit) i(cow) cluster(cow)				 
lincom remit 								/* remit, no sp */
lincom remit + sp_remit	
	* Generalized linear models (GEE) with unit means and clustered errors (robust implies clustered on panel) *
qui xtgee $y sp_remit $x1 $x2 $t cm_* cmsp* if year>=1975 & $e==1, family(b) link(probit) vce(r)  
lincom remit 								/* remit, no sp */
lincom remit + sp_remit						/* remit, yes sp */
	* Generalized linear models (GEE) with clustered errors (robust implies clustered on panel) *
qui xtgee $y sp_remit $x1 $x2 $t if year>=1975 & $e==1, family(b) link(probit) vce(r)  
lincom remit 								/* remit, no sp */
lincom remit + sp_remit						/* remit, yes sp */

estout pr1 pr2 pr3 pr4 pr5 pr6 pr7 pr8 using TableA7.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)

***************************************************
*** Remittances and Protest: Appendix Tables D1 ***
***************************************************
set matsize 800
do SCAD_prep
use temp, clear
drop scad*
sort cow year
merge cow year using scad
tab _merge
gen sp_remit = remit*sp
gen gtime = ln(ged_time)
tsset cow year
gen nbr_protest = ln(1+l.neighbor_protest)
gen bprotest = banks_riot + banks_anti
gen gdp = l.wdi_lgdp
gen gr = l.wdi_gdppcgr
gen u = d2.wdi_urb
gen urban = ln(1+abs(u))
replace urban = urban*-1 if u<0
drop u
gen milper = ln(1+l.nmc_milper)
gen civwar=prio_conflict_intra>0 | prio_lconflict_intra>0  if prio_conflict_intra~=. & prio_lconflict_intra~=.
gen sprotest =  scad_orgdem +  scad_orgriot +  scad_spondem +  scad_sponriot
recode sprotest (.=0) if year>1989 & ((cow>399 & cow<626) | cow==651)
drop if _merge==2
drop _merge


xi: nbreg bprotest i.cow i.time i.sp remit gtime, 
est store protest1
xi: nbreg bprotest i.cow i.time i.sp*remit gtime, 
est store protest2
lincom remit +  _IspXremit_1
xi: nbreg bprotest i.cow i.time gtime gr civwar urban pop gdp milper i.sp remit if year>=1975, 
est store protest3
xi: nbreg bprotest i.cow i.time gtime gr civwar urban pop gdp milper i.sp*remit if year>=1975, 
est store protest4
lincom remit +  _IspXremit_1
xi: nbreg sprotest i.cow i.time i.sp remit gtime, 
est store protest5
xi: nbreg sprotest i.cow i.time i.sp*remit gtime, 
est store protest6
lincom remit +  _IspXremit_1
xi: nbreg sprotest i.cow i.time gtime gr civwar urban pop gdp milper i.sp remit if year>=1975, 
est store protest7
xi: nbreg sprotest i.cow i.time gtime gr civwar urban pop gdp milper i.sp*remit if year>=1975, 
est store protest8
lincom remit +  _IspXremit_1
estout protest* using TableD1.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)

*************************

*Remittances and tax revenue*
use temp, clear
tssmooth ma rr = remit, window(0 0 1)
replace remit = rr
set scheme lean1
gen lgdp  = exp(wdi_lgdp)-1
gen c = geddes_country
gen dremit = d.remit
gen dlgdp = d.lgdp
gen ka = kaop
gen dka = d.ka
gen trade = wdi_tradegdp
gen dtrade = d.trade
gen pol = pol4_polity2
gen dpol =  d.pol
replace c ="" if cow!=710  /*China*/
gen taxrev = ln(1+(wdi_taxrevgdp*( wdi_gdppccons*(wdi_pop*1000))))   /* log tax in constant dollars, no GDP in denominator */
xi: reg d.taxrev i.cow i.year l.taxrev dremit remit if ged_dem~=.
predict phat if e(sample), xb
xi: reg taxrev i.cow i.year phat dremit remit 
avplot remit, mlabel(c)
gen revtax = wdi_taxrevgdp
xi: ivreg2 taxrev i.cow i.year (d.taxrev =l.taxrev) dremit remit  if ged_dem~=., cluster(cow) 
est store tax1
xi: ivreg2 taxrev i.cow i.year (d.taxrev =l.taxrev) dremit remit dlgdp lgdp  if ged_dem~=., cluster(cow) 
est store tax2
xi: ivreg2 taxrev i.cow i.year (d.taxrev =l.taxrev) dremit remit dlgdp lgdp  if ged_dem~=. & cow~=710, cluster(cow) 
est store tax3
xi: ivreg2 taxrev i.cow i.year (d.taxrev =l.taxrev) dremit remit dlgdp lgdp dtrade trade dka ka dpol pol if ged_dem~=., cluster(cow) 
est store tax4
xi: ivreg2 taxrev i.cow i.year (d.taxrev =l.taxrev) dremit remit dlgdp lgdp dtrade trade dka ka dpol pol   if ged_dem~=. & cow~=710, cluster(cow) 
est store tax5
 
estout tax1 tax2 tax3 tax4 tax5 using TableE1.tex, cells(b(star  fmt(%9.3f)) se(par fmt(%9.2f))) stats(ll r2 N) style(tex) replace label starlevels(+ 0.10 * 0.05 ** 0.01)




*************
***THE END***
*************

capture log close

