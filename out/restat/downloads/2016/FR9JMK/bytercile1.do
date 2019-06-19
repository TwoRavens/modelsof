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

summ bdpc if popul>0, det
summ bdpc_nppub if popul>0, det
summ bdpc_fp if popul>0, det

summ admtotpc if popul>0, det
summ admnppubpc if popul>0, det
summ admfppc if popul>0, det


drop if year==1947
bys fcount : gen first_treat=sum(treat_it)
** gen year first treated **
forvalues i=1/1{
	gen yeart`i'=year if treat_it==1 & first_treat==`i'
	by fcounty1: egen yeart`i'2=mean(yeart`i')
	drop yeart`i'
	rename yeart`i'2 yeart`i'
	}

sort fcounty year
by fcounty: gen byte ntreat = sum(treat_it)
sort fcounty ntreat
by fcounty ntreat: gen ntreat1=_n
gen byte first_it = (ntreat==1) & ntreat1==1
xtset fcounty year

* create lags *
gen byte treat_lag=first_it
  forvalues y=1/20  {
	gen byte treat_lag`y' = L`y'.treat_lag 
 	replace treat_lag`y' = 0 if treat_lag`y' ==.
  }

gen byte treat_lag21 = 0
  forvalues y=21/30  {
	replace treat_lag21 = 1 if L`y'.treat_it == 1
  }

* create leads *
  forvalues y=1/9  {
	gen byte treat_lead`y' = F`y'.treat_lag 
 	replace treat_lead`y' = 0 if treat_lead`y' ==.
  }

** Summary stats**
summ yeart if yeart!=., det
summ beds* if year==1953 & yeart==., det
summ admtot adm_npp admtotfp if year==1953 & yeart==., det
gen firmstot=firmsfp+firmsnp+firmspb
gen firms_nppub=firmsnp+firmspb
summ firmstot firms_npp firmsf if year==1953 & yeart==., det
replace daysfp=0 if missing(daysfp)
replace daysnp=0 if missing(daysnp)
replace dayspb=0 if missing(dayspb)

gen daystot=daysfp+daysnp+dayspb
gen days_nppub=daysnp+daysp

forvalues i=1/20 {
	label var treat_lag`i' "`i' Years Later"
}
label var treat_lag21 "21+ Years Later"
label var treat_lag "Year of Funding"

forvalues i=1/9  {
	label var treat_lead`i' "`i' Years Prior"
}

gen ipop2=ipop/100000
replace yeart=3000 if yeart==.

* create MDs per capita *
gen infmdpc=infmd/(popul+1)


*add on earlier years so we can re-create lag structure*
drop if year>1975
append using countyyear_1920_1947
sort fcounty1 year
xtset fcounty1 year

gen treatnew_lag0=0
replace treatnew_lag0=f27.treat_lag

forvalues i=1/21{
	gen treatnew_lag`i'=0
	replace treatnew_lag`i'=f27.treat_lag`i'
}

forvalues i=1/9{
	gen treatnew_lead`i'=0
	replace treatnew_lead`i'=f27.treat_lead`i'
}
gen pop65_pct=ipop65/ipop
gen poplt5_pct=ipoplt5/ipop

label var ipop2 "Popn"
label var imedfaminc "Med. Fam Income"
label var pop65_pct "% Pop 65+"
label var poplt5_pct "% Pop <5"
label var infmdpc "NonFed MDs per Capita"
label var inwpop_pct "% Pop NonWh"

*keep if year==1948
* this will drop 22 county/year observations with large swings (greater than 200 bed diff in dff in beds) and 0 beds as an observation *

gen diff2bd=abs(d2.beds_tot)
egen maxdiff2=max(diff2bd), by(fcounty)


bys fcounty : gen dropvar=1 if maxdiff2>200 & beds_tot==1 & beds_tot[_n-1]>1 & beds_tot[_n+1]>1  & year>=1948
replace dropvar=0 if missing(dropvar)
tab fcounty if dropvar==1

keep if dropvar==0 


xi i.year
xtset fcounty1 year

*log using regs_stratifiedbypop.log, replace

* generate variable for whether a county was ever treated *
egen evertreat=mean(treat_lag), by(fcounty)
replace evertreat=1 if evertreat>0

******************
* create evenly space terciles and run weighted and unweighted regressions within each tercile *
******************

xtile quintile=ipop2 if year==1948, n(3)
tab quintile, sum (ipop2)
egen tercile=mean(quintile), by(fcounty)

sort fcounty year

replace first_treat=1 if first_treat>0
gen firstfundpcamt=hbfund_totinfladjust / ipop if first_treat==1 & yeart==year
gen firstfundpcamt1=hbfund_tot / ipop if first_treat==1 & yeart==year

replace firstfundpcamt=0 if missing(firstfundpcamt)
replace firstfundpcamt1=0 if missing(firstfundpcamt1)

* sum stats within tercile *
replace yeart=. if yeart==3000
* tercile 1 *
** never funded **
summ bdpc* if year==1953 & yeart==. & tercile==1, det
summ admtotpc admnppubpc admfppc if year==1953 & yeart==. & tercile==1, det
summ firmstot firms_npp firmsf if year==1953 & yeart==. & tercile==1, det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if year==1953 & yeart==. & tercile==1,det

** all counties **
summ bdpc* if year==1953 & tercile==1,det
summ admtotpc admnppubpc admfppc if year==1953 & tercile==1,det
summ firmstot firms_npp firmsf if year==1953 & tercile==1 ,det
summ daystot days_npp daysf if year==1953 & tercile==1,det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if year==1953 & tercile==1,det
summ hbfund_totinfl if treat_lag==1& tercile==1, det

** received funding **
summ bdpc* if treat_lag==1 & tercile==1,det
summ admtotpc admnppubpc admfppc if treat_lag==1 & tercile==1,det
summ firmstot firms_npp firmsf if treat_lag==1 & tercile==1,det
summ daystot days_npp daysf if treat_lag==1 & tercile==1,det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if treat_lag==1 & tercile==1,det
summ firstfundpcamt if firstfundpcamt>0 & tercile==1, det
summ hbfund_totinfladjust if first_treat==1 & yeart==year &firstfundpcamt>0 & tercile==1, det

* tercile 2 *
summ bdpc* if year==1953 & yeart==. & tercile==2, det
summ admtotpc admnppubpc admfppc if year==1953 & yeart==. & tercile==2, det
summ firmstot firms_npp firmsf if year==1953 & yeart==. & tercile==2, det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if year==1953 & yeart==. & tercile==2,det

summ bdpc* if year==1953 & tercile==2,det
summ admtotpc admnppubpc admfppc if year==1953 & tercile==2,det
summ firmstot firms_npp firmsf if year==1953 & tercile==2 ,det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if year==1953 & tercile==2,det
summ hbfund_totinfl if treat_lag==1& tercile==2, det
summ firstfundpcamt if firstfundpcamt>0 & tercile==2, det
summ hbfund_totinfladjust if first_treat==1 & yeart==year &firstfundpcamt>0 & tercile==2, det

summ bdpc* if treat_lag==1 & tercile==2,det
summ admtotpc admnppubpc admfppc if treat_lag==1 & tercile==2,det
summ firmstot firms_npp firmsf if treat_lag==1 & tercile==2,det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if treat_lag==1 & tercile==2,det

* tercile 3 *
summ bdpc* if year==1953 & yeart==. & tercile==3, det
summ admtotpc admnppubpc admfppc if year==1953 & yeart==. & tercile==3, det
summ firmstot firms_npp firmsf if year==1953 & yeart==. & tercile==3, det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if year==1953 & yeart==. & tercile==3,det

summ bdpc* if year==1953 & tercile==3,det
summ admtotpc admnppubpc admfppc if year==1953 & tercile==3,det
summ firmstot firms_npp firmsf if year==1953 & tercile==3 ,det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if year==1953 & tercile==3,det
summ hbfund_totinfl if treat_lag==1& tercile==3, det
summ firstfundpcamt if firstfundpcamt>0 & tercile==3, det
summ hbfund_totinfladjust if first_treat==1 & yeart==year &firstfundpcamt>0 & tercile==3, det

summ bdpc* if treat_lag==1 & tercile==3,det
summ admtotpc admnppubpc admfppc if treat_lag==1 & tercile==3,det
summ firmstot firms_npp firmsf if treat_lag==1 & tercile==3,det
summ ipop imedfaminc pop65_pct poplt5_pct inwpop_pct infmdpc if treat_lag==1 & tercile==3,det


**************************************************************************************
* Coefficients for Figure 5 (right and left panels), Coefficients listed in Table A5 *
**************************************************************************************
** regressions by tercile for all counties**

*** first tercile weighted, no leads ***
areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile1, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile1, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile1, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** first tercile weighted, WITH leads ***
areg bdpc treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile1, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile1, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile1, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** first tercile unweighted, no leads ***
*areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==1, absorb(fcounty) cluster(fcounty)
*areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  if tercile==1,  absorb(fcounty) cluster(fcounty)
*areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==1,  absorb(fcounty) cluster(fcounty)


*** 2nd tercile weighted, no leads ***
areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile2, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile2, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile2, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 2nd tercile weighted, WITH leads ***
areg bdpc treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile2, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile2, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile2, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 2nd tercile weighted, no leads & dropping top 9 county outliers ***
areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 , absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile2_dropoutliers, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile2_dropoutliers, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile2_dropoutliers, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 2nd tercile weighted, WITH leads & dropping top 9 county outliers ***
areg bdpc treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 , absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile2_dropoutliers, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile2_dropoutliers, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile2_dropoutliers, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 2nd tercile unweighted, no leads ***
*areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==2, absorb(fcounty) cluster(fcounty)
*areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  if tercile==2,  absorb(fcounty) cluster(fcounty)
*areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==2,  absorb(fcounty) cluster(fcounty)


*** 3rd tercile weighted, no leads ***
areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile3, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile3, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile3, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 3rd tercile weighted, WITH leads ***
areg bdpc treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile3, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile3, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile3, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 3rd tercile weighted, no leads & dropping top 9 county outliers ***
areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 , absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile3_dropoutlier, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile3_dropoutlier, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_noleads_wts_tercile3_dropoutlier, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 3rd tercile weighted, WITH leads & dropping top 9 county outliers ***
areg bdpc treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3 & fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 , absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile3_dropoutlier, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_nppub treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3 &fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile3_dropoutlier, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg bdpc_fp treat_lead* treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3 &fcounty1!=24007&fcounty1!=26125&fcounty1!=34013&fcounty1!=34017&fcounty1!=36119&fcounty1!=39049&fcounty1!=6067&fcounty1!=12103&fcounty1!=53053 ,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lead* treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using bedspc_wleads_wts_tercile3_dropoutlier, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 3rd tercile unweighted, no leads ***
*areg bdpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==3, absorb(fcounty) cluster(fcounty)
*areg bdpc_nppub treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct  if tercile==3,  absorb(fcounty) cluster(fcounty)
*areg bdpc_fp treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct if tercile==3,  absorb(fcounty) cluster(fcounty)


**************************************************************************************
* Coefficients for Figure 7, Coefficients listed in Table A11 *
**************************************************************************************
******** ADMISSIONS REGRESSIONS BY TERCILE **************************************
*** first tercile 
areg admtotpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile1, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg admnppubpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile1, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg admfppc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==1,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile1, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 2nd tercile 
areg admtotpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile2, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg admnppubpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile2, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg admfppc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==2,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile2, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")

*** 3rd tercile 
areg admtotpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3, absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile3, replace label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg admnppubpc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile3, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
areg admfppc treat_lag* _Iyear* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct [aw=ipop2] if tercile==3,  absorb(fcounty) cluster(fcounty)
   outreg2 treat_lag* ipop2 imedfaminc pop65_pct poplt5_pct infmdpc inwpop_pct using admspc_noleads_wts_tercile3, append label tex se sym(***,**,*) title("Effect of Hill-Burton Treatment (0/1)")
