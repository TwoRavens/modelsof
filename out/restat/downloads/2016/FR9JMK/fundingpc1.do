 clear all
set mem 500m
set more off
************************************************************************************
clear
use data_working

gen alos=(daysnp+daysfp+dayspb)/admtot
summ alos if admtot>1
** generate per capita beds **
gen popul=ipop/1000
gen bedstot_temps=beds_tot
replace bedstot_temps=0 if beds_tot==1
gen bedsnppub_temps=beds_nppub
replace bedsnppub_temps=0 if beds_nppub==1
gen bedsfp_temps=bdtotfp
replace bedsfp_temps=0 if bdtotfp==1

replace popul=0 if popul==.
gen bdpc=bedstot_temps/(popul+1)
gen bdpc_nppub=bedsnppub_temps/(popul+1)
gen bdpc_fp=bedsfp_temps/(popul+1)

gen admtotpc=admtot/(popul+1)
gen admnppubpc=adm_nppub/(popul+1)
gen admfppc=admtotfp/(popul+1)

drop if year==1947
sort fcounty year
by fcounty: gen byte ntreat = sum(treat_it)
sort fcounty ntreat
by fcounty ntreat: gen ntreat1=_n
gen byte first_it = (ntreat==1) & ntreat1==1
xtset fcounty year

gen byte treat_lag=first_it
  forvalues y=1/20  {
	gen byte treat_lag`y' = L`y'.treat_lag 
 	replace treat_lag`y' = 0 if treat_lag`y' ==.
  }

gen byte treat_lag21 = 0
  forvalues y=21/30  {
	replace treat_lag21 = 1 if L`y'.treat_it == 1
  }

gen ipop2=ipop/100000
gen pop65_pct=ipop65/ipop
gen poplt5_pct=ipoplt5/ipop

drop treat_lag
gen fund_now = hbfund_totinfladjust / ipop
replace fund_now=0 if year>1971
  forvalues y=1/20  {
	gen fund_lag`y' = L`y'.hbfund_totinfladjust / L`y'.ipop
  	replace fund_lag`y' = 0 if fund_lag`y' ==.
  }

gen fund_lag21 = 0
  forvalues y=21/30  {
	replace fund_lag21 = fund_lag21 + L`y'.hbfund_totinfladjust / L`y'.ipop if L`y'.hbfund_totinfladjust != .
  }

drop treat_lag*
gen treat_lag=treat_it
  forvalues y=1/20  {
	gen byte treat_lag`y' = L`y'.treat_lag 
	replace treat_lag`y' = 0 if treat_lag`y' ==.
  }

gen byte treat_lag21 = 0
  forvalues y=21/30  {
 	replace treat_lag21 = 1 if L`y'.treat_it == 1
  }
drop treat_lag

* create MDs per capita *
gen infmdpc=infmd/(popul+1)

label var ipop2 "Popn"
label var imedfaminc "Med. Fam Income"
label var pop65_pct "% Pop 65+"
label var poplt5_pct "% Pop <5"
label var infmdpc "NonFed MDs per Capita"
label var inwpop_pct "% Pop NonWh"

drop if year>1975
* this will drop 22 county/year observations with large swings (greater than 200 bed diff in dff in beds) and 0 beds as an observation *

gen diff2bd=abs(d2.beds_tot)
egen maxdiff2=max(diff2bd), by(fcounty)


bys fcounty : gen dropvar=1 if maxdiff2>200 & beds_tot==1 & beds_tot[_n-1]>1 & beds_tot[_n+1]>1  & year>=1948
replace dropvar=0 if missing(dropvar)
tab fcounty if dropvar==1

keep if dropvar==0 


xi i.year
***********

****************************
* Coefficients for Table 4 *
****************************

* run these with weights by county
areg bdpc treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts, replace noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_npp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*log close

***********
*run funding reg stratified by population
xtile quintile=ipop2 if year==1948, n(3)
tab quintile, sum (ipop2)
egen tercile=mean(quintile), by(fcounty)


*log using regs_wts_funding_stratified.log, replace

* run these with weights by county
areg bdpc treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==1 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile1, replace noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_npp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==1 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile1, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==1 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile1, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

areg bdpc treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==2 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile2, replace noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_npp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==2 [aw=ipop2], absorb(fcounty) cluster(fcounty) 
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile2, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==2 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile2, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")


areg bdpc treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==3 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile3, replace noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_npp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==3 [aw=ipop2], absorb(fcounty) cluster(fcounty) 
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile3, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_it treat_lag* fund_now fund_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==3 [aw=ipop2], absorb(fcounty) cluster(fcounty)
	outreg2 treat_it treat_lag* fund_now fund_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  using bedspc_fundpc_wts_tercile3, append noparen label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")



