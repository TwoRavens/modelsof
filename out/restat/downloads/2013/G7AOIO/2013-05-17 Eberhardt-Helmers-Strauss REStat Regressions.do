
************************************************************
* Do-file: Regression results for
* Eberhardt, Helmers & Strauss, "Do Spillovers Matter when
* Estimating Private Returns to R&D?" 
* Review of Economics and Statistics, 95(2): 436-448	
************************************************************
* Note: This do-file requires
*	(a) Stata MP & large memory for the CCEP regressions
*	(b) pescadf and xtfisher commands (by Piotr Lewandowski
* 		and Scott Merryman respectively) installed: these  
*		are available from SSC (-findit command- in Stata)
*	(c) xtmg, xtcd, multipurt commands installed: these
*		are available from SSC (-findit command- in Stata)
*		or at https://sites.google.com/site/medevecon/code
*	(d) md_ar1 installed: this is available from Mans
*		Soderbom's website at 
*		http://www.soderbom.net/Resources.htm
************************************************************
* This file: 17th May 2013
* ME
************************************************************


************************************************************
*** Pooled static regressions
*** Table 5 
************************************************************
clear matrix
clear mata
clear
set mem 2g
set matsize 11000
global DATA "C:\Users\lezme\Dropbox\RD Spillover\Replication data"
* change the path to your file store

use "$DATA\EberhardtHelmersStrauss_RDspillover.dta", clear
xtset id year
tab year, gen(time)
drop time1


************************************************************
****************             POLS           ****************
reg lny lnl lnk lnrd time2-time26, robust
predict ePOLS if e(sample), res
test lnl+lnk+lnrd=1
abar, lags(2)


************************************************************
****************            2FE             ****************
xi: reg lny lnl lnk lnrd time2-time26 i.id, robust
predict e2FE if e(sample), res
test lnl+lnk+lnrd=1
* Note the error in the paper: CRS p-value is .00, not .34.
abar, lags(2)


************************************************************
****************     FD-OLS w/ year FE     *****************
reg d.lny d.lnl d.lnk d.lnrd time3-time26, robust nocons
predict eFD if e(sample), res
test d.lnl+d.lnk+d.lnrd=1
abar, lags(2)


************************************************************
****************            CCEP                 ***********
xtset id year
qui xtreg lny lnl lnk lnrd, robust fe
keep if e(sample)
tab id, gen(cs)
qui xtreg lny lnl lnk lnrd time*, robust fe
sort year id
by year: egen lnyT=mean(lny) if e(sample)
by year: egen lnlT=mean(lnl) if e(sample)
by year: egen lnkT=mean(lnk) if e(sample)
by year: egen lnrdT=mean(lnrd) if e(sample)
sort id year
forvalues l=1/119{
qui gen xlny`l'=.
qui gen xlnl`l'=.
qui gen xlnk`l'=.
qui gen xlnrd`l'=.
qui replace xlny`l'=lnyT*cs`l' if e(sample)
qui replace xlnl`l'=lnlT*cs`l' if e(sample)
qui replace xlnk`l'=lnkT*cs`l' if e(sample)
qui replace xlnrd`l'=lnrdT*cs`l' if e(sample)
}
order id year xlny* xlnl* xlnk* xlnrd*
xi:  reg lny lnl lnk lnrd xlny* xlnl* xlnk* xlnrd* i.id, robust nocons
predict eCCEP if e(sample), res
test lnl+lnk+lnrd=1
abar, lags(2)


************************************************************
****************      CCEP w/ year FE       ****************
xi:  reg lny lnl lnk lnrd xlny* xlnl* xlnk* xlnrd* i.id time2-time26, robust nocons
predict eCCEPt if e(sample), res
test lnl+lnk+lnrd=1
abar, lags(2)
drop xlny* xlnl* xlnk* xlnrd*


************************************************************
****************         Diagnostics             ***********
xtcd ePOLS e2FE  eCCEP eCCEPt
xtcd eFD
* Note: These need to be run separately as otherwise only 
* 2,518 observations (FD sample) are investigated 
multipurt ePOLS e2FE  eCCEP eCCEPt, lags(2)
multipurt eFD, lags(2)


************************************************************
************* End of Pooled Static Regressions *************
************************************************************





************************************************************
*** Pooled dynamic regressions
*** Table 6 
************************************************************
clear matrix
clear mata
clear
set mem 2g
set matsize 11000

global DATA "C:\Users\lezme\Dropbox\RD Spillover\Replication data"

use "$DATA\EberhardtHelmersStrauss_RDspillover.dta", clear
xtset id year
qui xtreg lny lnl lnk lnrd, fe
keep if e(sample)
tab year, gen(time)

************************************************************
****************             POLS           ****************
reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny time3-time26, robust
predict ePOLS if e(sample), res
md_ar1, nx(3) beta(e(b)) cov(e(V))
nlcom ((_b[lnl ]+_b[l.lnl])/(1-_b[l.lny ])) ((_b[lnk ]+_b[l.lnk ])/(1-_b[l.lny ])) ((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny ]))
qui reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny time3-time26, robust
testnl ((_b[lnl]+_b[l.lnl])/(1-_b[l.lny]))+((_b[lnk]+_b[l.lnk])/(1-_b[l.lny]))+((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny]))=1


************************************************************
****************            2FE             ****************
xi: reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny time3-time26 i.id, robust 
predict e2FE if e(sample), res
md_ar1, nx(3) beta(e(b)) cov(e(V))
* COMFAC restriction not rejected.
* nlcom ((_b[lnl ]+_b[l.lnl])/(1-_b[l.lny ])) ((_b[lnk ]+_b[l.lnk ])/(1-_b[l.lny ])) ((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny ]))
xi: reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny time3-time26 i.id, robust 
testnl ((_b[lnl]+_b[l.lnl])/(1-_b[l.lny]))+((_b[lnk]+_b[l.lnk])/(1-_b[l.lny]))+((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny]))=1


************************************************************
****************            BB              ****************
xi: xtabond2 lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny i.year, gmm(lny lnl lnk lnrd, lag(3 .) collapse) iv(i.year, equation(level)) robust twostep small nomata
predict eBB if e(sample), res
md_ar1, nx(3) beta(e(b)) cov(e(V))
* Note: the nlcom command takes a fair bit of time to compute...
xi: xtabond2 lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny i.year, gmm(lny lnl lnk lnrd, lag(3 .) collapse) iv(i.year, equation(level)) robust twostep small nomata
nlcom ((_b[lnl ]+_b[l.lnl])/(1-_b[l.lny ])) ((_b[lnk ]+_b[l.lnk ])/(1-_b[l.lny ])) ((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny ]))
xi: xtabond2 lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny i.year, gmm(lny lnl lnk lnrd, lag(3 .) collapse) iv(i.year, equation(level)) robust twostep small nomata
testnl ((_b[lnl]+_b[l.lnl])/(1-_b[l.lny]))+((_b[lnk]+_b[l.lnk])/(1-_b[l.lny]))+((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny]))=1
drop _Iyear*

************************************************************
****************            CCEP                 ***********
tab id, gen(cs)
qui xtreg lny lnl lnk lnrd time*, robust fe
sort year id
by year: egen lnyT=mean(lny) if e(sample)
by year: egen lnlT=mean(lnl) if e(sample)
by year: egen lnkT=mean(lnk) if e(sample)
by year: egen lnrdT=mean(lnrd) if e(sample)
tsset id year
forvalues l=1/119{
qui gen xlny`l'=.
qui gen xlnl`l'=.
qui gen xlnk`l'=.
qui gen xlnrd`l'=.
qui gen lxlny`l'=.
qui gen lxlnl`l'=.
qui gen lxlnk`l'=.
qui gen lxlnrd`l'=.
qui replace xlny`l'=lnyT*cs`l' if e(sample)
qui replace xlnl`l'=lnlT*cs`l' if e(sample)
qui replace xlnk`l'=lnkT*cs`l' if e(sample)
qui replace xlnrd`l'=lnrdT*cs`l' if e(sample)
qui replace lxlny`l'=l.lnyT*cs`l' if e(sample)
qui replace lxlnl`l'=l.lnlT*cs`l' if e(sample)
qui replace lxlnk`l'=l.lnkT*cs`l' if e(sample)
qui replace lxlnrd`l'=l.lnrdT*cs`l' if e(sample)
}
order id year xlny* xlnl* xlnk* xlnrd* lxlny* lxlnl* lxlnk* lxlnrd*
xi: reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny xlny* xlnl* xlnk* xlnrd* lxlny* lxlnl* lxlnk* lxlnrd* i.id, robust
predict eCCEP if e(sample), res
md_ar1, nx(3) beta(e(b)) cov(e(V))
* Note: the nlcom command takes a fair bit of time to compute...
nlcom ((_b[lnl ]+_b[l.lnl])/(1-_b[l.lny ])) ((_b[lnk ]+_b[l.lnk ])/(1-_b[l.lny ])) ((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny ]))
xi: reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny xlny* xlnl* xlnk* xlnrd* lxlny* lxlnl* lxlnk* lxlnrd* i.id, robust
testnl ((_b[lnl]+_b[l.lnl])/(1-_b[l.lny]))+((_b[lnk]+_b[l.lnk])/(1-_b[l.lny]))+((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny]))=1


************************************************************
****************      CCEP w/ year FE       ****************
xi: reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny xlny* xlnl* xlnk* xlnrd* lxlny* lxlnl* lxlnk* lxlnrd* i.id time*,  robust
predict eCCEPt if e(sample), res
md_ar1, nx(3) beta(e(b)) cov(e(V))
* Note: the nlcom command takes a fair bit of time to compute...
nlcom ((_b[lnl ]+_b[l.lnl])/(1-_b[l.lny ])) ((_b[lnk ]+_b[l.lnk ])/(1-_b[l.lny ])) ((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny ]))
xi: reg lny lnl l.lnl lnk l.lnk lnrd l.lnrd l.lny xlny* xlnl* xlnk* xlnrd* lxlny* lxlnl* lxlnk* lxlnrd* i.id time*,  robust
testnl ((_b[lnl]+_b[l.lnl])/(1-_b[l.lny]))+((_b[lnk]+_b[l.lnk])/(1-_b[l.lny]))+((_b[lnrd]+_b[l.lnrd])/(1-_b[l.lny]))=1

************************************************************
****************         Diagnostics             ***********
xtcd ePOLS e2FE eBB eCCEP eCCEPt
multipurt ePOLS e2FE eBB eCCEP eCCEPt, lags(2)
pescadf ePOLS, lags(3)
pescadf e2FE, lags(3)
pescadf eBB, lags(3)
pescadf eCCEP, lags(3)
pescadf eCCEPt, lags(3)



************************************************************
************* End of Pooled Dynamic Regressions ************
************************************************************





************************************************************
*** Heterogeneous static regressions 
*** Table 7
************************************************************
clear
clear matrix
clear mata
set mem 100m
set matsize 11000

use "$DATA\EberhardtHelmersStrauss_RDspillover.dta", clear
xtset id year

qui xtreg lny lnl lnk lnrd, robust fe
sort year id
by year: egen lnyT=mean(lny) if e(sample)
by year: egen lnlT=mean(lnl) if e(sample)
by year: egen lnkT=mean(lnk) if e(sample)
by year: egen lnrdT=mean(lnrd) if e(sample)
gen lnyDM=lny-lnyT
gen lnlDM=lnl-lnlT
gen lnkDM=lnk-lnkT
gen lnrdDM=lnrd-lnrdT


************************************************************
****************             MG             ****************
xtmg lny lnl lnk lnrd, trend res(r_mg)
test lnl+lnk+lnrd=1


************************************************************
****************            CDMG            ****************
xtmg lnyDM lnlDM lnkDM lnrdDM, res(r_cdmg) 
test lnlDM+lnkDM+lnrdDM=1


************************************************************
****************             CMG            ****************
xtmg lny lnl lnk lnrd, cce res(r_cmg)
test lnl+lnk+lnrd=1


************************************************************
****************          CMG w/ trends     ****************
xtmg lny lnl lnk lnrd, cce trend res(r_cmgt)
test lnl+lnk+lnrd=1


************************************************************
****************         Diagnostics             ***********
xtcd r_mg r_cdmg r_cmg r_cmgt
multipurt r_mg r_cdmg r_cmg r_cmgt, lags(2)
pescadf r_mg, lags(3)
pescadf r_cdmg, lags(3)
pescadf r_cmg, lags(3)
pescadf r_cmgt, lags(3)


************************************************************
********** End of Heterogeneous Static Regressions *********
************************************************************





************************************************************
*** Heterogeneous dynamic regressions
*** Table 8 
************************************************************
clear
clear matrix
clear mata
set mem 100m
set matsize 11000

global DATA "C:\Users\lezme\Dropbox\RD Spillover\Replication data"

use "$DATA\EberhardtHelmersStrauss_RDspillover.dta", clear
xtset id year
local z "lny lnl lnk lnrd "
foreach k of local z{
	gen l1_`k'=l.`k'
}
qui xtreg lny lnl lnk lnrd, fe
sort year id
by year: egen lnyT=mean(lny) if e(sample)
by year: egen lnlT=mean(lnl) if e(sample)
by year: egen lnkT=mean(lnk) if e(sample)
by year: egen lnrdT=mean(lnrd) if e(sample)
gen lnyDM=lny-lnyT
gen lnlDM=lnl-lnlT
gen lnkDM=lnk-lnkT
gen lnrdDM=lnrd-lnrdT

sort id year
local z "lnyDM lnlDM lnkDM lnrdDM"
foreach k of local z{
	gen l1_`k'=l.`k'
}


************************************************************
****************             MG             ****************
xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny, trend res(r_mg)
testnl ((_b[lnl]+_b[l1_lnl])/(1-_b[l1_lny]))+((_b[lnk]+_b[l1_lnk])/(1-_b[l1_lny]))+((_b[lnrd]+_b[l1_lnrd])/(1-_b[l1_lny]))=1
sum r_mg
qui xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny, trend res(r_mg)
md_ar1, nx(3) beta(e(b)) cov(e(V))



************************************************************
****************            CDMG            ****************
xtmg lnyDM lnlDM l1_lnlDM lnkDM l1_lnkDM lnrdDM l1_lnrdDM l1_lnyDM, res(r_cdmg)
testnl ((_b[lnlDM]+_b[l1_lnlDM])/(1-_b[l1_lnyDM]))+((_b[lnkDM]+_b[l1_lnkDM])/(1-_b[l1_lnyDM]))+((_b[lnrdDM]+_b[l1_lnrdDM])/(1-_b[l1_lnyDM]))=1
sum r_cdmg
qui xtmg lnyDM lnlDM l1_lnlDM lnkDM l1_lnkDM lnrdDM l1_lnrdDM l1_lnyDM, res(r_cdmg)
md_ar1, nx(3) beta(e(b)) cov(e(V))


************************************************************
****************             CMG            ****************
qui xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny, trend cce
qui gen dd=1 if e(sample)
sort id
by id: egen ddsum=sum(dd) if e(sample)

xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny  if ddsum>14, cce res(r_cmg)
testnl ((_b[lnl]+_b[l1_lnl])/(1-_b[l1_lny]))+((_b[lnk]+_b[l1_lnk])/(1-_b[l1_lny]))+((_b[lnrd]+_b[l1_lnrd])/(1-_b[l1_lny]))=1
sum r_cmg
qui xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny  if ddsum>14, cce res(r_cmg)
md_ar1, nx(3) beta(e(b)) cov(e(V))


************************************************************
****************          CMG w/ trends     ****************
xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny  if ddsum>14, cce trend res(r_cmgt)
testnl ((_b[lnl]+_b[l1_lnl])/(1-_b[l1_lny]))+((_b[lnk]+_b[l1_lnk])/(1-_b[l1_lny]))+((_b[lnrd]+_b[l1_lnrd])/(1-_b[l1_lny]))=1
sum r_cmgt
qui xtmg lny lnl l1_lnl lnk l1_lnk lnrd l1_lnrd l1_lny  if ddsum>14, cce trend res(r_cmgt)
md_ar1, nx(3) beta(e(b)) cov(e(V))


************************************************************
****************         Diagnostics             ***********
xtcd r_mg r_cdmg 
xtcd r_cmg r_cmgt
multipurt r_mg r_cdmg, lags(2)
multipurt r_cmg r_cmgt, lags(2)
pescadf r_mg, lags(3)
pescadf r_cdmg, lags(3)
pescadf r_cmg, lags(3)
pescadf r_cmgt, lags(3)


************************************************************
********** End of Heterogeneous Static Regressions *********
************************************************************
