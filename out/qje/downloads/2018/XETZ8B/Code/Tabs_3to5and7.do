clear all
set more off
set matsize 11000
set maxvar 32767
set segmentsize 128m

* Change working directory
global wkdir = "C:\Users\RMano\Desktop\Mypapers\Tarek\HassanManoQJE"
cd $wkdir

* Install ranktest
ssc install ranktest

**************************************************************************************************************************
* Table 3: Estimates of the Elasticity of Risk Premia with respect to Forward Premia
* Table 4: Slope Coefficients from In-sample v.s. Out-of-sample Regressions
* Table 5: Chi-square Difference Tests
* Table 7: Is the US Dollar Special? 
**************************************************************************************************************************

estimates drop _all
local K = 10000

* Pre-allocate matrix for #obs
mat N1 = J(8,1,0)
mat N2 = J(8,1,0)
mat betaN1 = J(8,1,0)
mat betaN2 = J(8,1,0)

* Programs to run bootstraps on 
program ESSratio1
	version 14
	args y1 x1 y2 x2
	confirm var `y1'
	confirm var `y2'
	confirm var `x1'
	confirm var `x2'
	reg `y1' `x1', noconstant
	scalar Estat = e(mss)
	reg `y2' `x2', noconstant 
	scalar Edyn = e(mss)
	scalar ESSCT = (Estat/(Estat+Edyn))*100
end

program ESSratio2
	version 14
	args y1 x1 y2 x2
	confirm var `y1'
	confirm var `y2'
	confirm var `x1'
	confirm var `x2'
	reg `y1' `x1'
	scalar Edol = e(mss)
	reg `y2' `x2', noconstant 
	scalar Edyn = e(mss)
	scalar ESSFPP = (Edol/(Edol+Edyn))*100
end

program ESSratio2_xREB
	version 14
	args y1 x1 x3 y2 x2
	reg `y1' `x1' `x3'
	scalar Edol = e(mss)
	reg `y2' `x2', noconstant 
	scalar Edyn = e(mss)
	scalar ESSFPP = (Edol/(Edol+Edyn))*100
end

*-------------------------------------------------------------------------------
* Run all Scenarios First 
*-------------------------------------------------------------------------------
{
// SCENARIO 1: 1 Rebalance Strategy (without bid-ask spread)

* Read data into memory
use "Input/Data/DOLdollar_BIG_ALLfwd_clean.dta", replace 

keep if countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42"

* Encode countries 

xtset countriesnum time
sort countries time

* Save data to disk
save "Temp/1REB95data.dta", replace

* IN SAMPLE ANALYSIS
keep if time >= 419

* Create avgfp
egen avgfp1m = mean(fp1m) if fp1m!=., by(countries)
egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
rename avgfp1m fpi
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)
gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds
egen fpt = mean(fp1m) if fp1m!=., by(time)
gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* RUN REGRESSIONS JOINTLY

* Static equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statIN_95
mat ESSstat = e(mss)

* Dynamic equation
gmm (eq1: rxwithin - {bdyn}*fpwithin), instruments(eq1: fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynIN_95
reg rxwithin fpwithin, noconstant robust
mat ESSdyn = e(mss)

* Dollar equation
ivreg2 drxt dfpt, cluster(time) dkraay(0) noconstant
estimates store dolIN_95
reg drxt dfpt, cluster(time) noconstant
mat ESSdol = e(mss)

* CT equation
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradIN_95

* FPP equation
gmm (eq1: rxfpp - {bfpp}*fpfpp), instruments(eq1: fpfpp, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store fppIN_95

* ESS Static T & ESS Dollar T
mat CT_in  = ESSstat[1,1] / (ESSstat[1,1] + ESSdyn[1,1])
mat FPP_in = ESSdol[1,1]  / (ESSdol[1,1]  + ESSdyn[1,1])

* Test
reg rxfpp dfpt fpwithin, noconstant cluster(time)
test (fpwithin=dfpt)
mat TEST = r(p)

keep countries time dfpi dfpt fpi
rename dfpi dfpiIN
rename dfpt dfptIN
rename fpi fpiIN
sort countries time

merge 1:1 countries time using "Temp/1REB95data.dta"
drop _merge
sort countries time

* STRICTLY OOS ANALYSIS
scalar finish = 604
scalar cut    = 419

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BEFORE 1995 
gen fp1mtemp = fp1m if time <= cut
egen avgfp1m = mean(fp1mtemp) if fp1m!=., by(countries)

xi i.countriesnum, noomit
* Standard OLS
reg fp1m _Icount* if time <= cut, noconstant
* V(fpihat)
mat D = e(V)
mat vfpi = D[1,1]

keep if time >= cut

egen rxi = mean(rx1m1) if rx1m1!=., by(countries)
rename avgfp1m fpi
egen fp = mean(fpi) if fpi!=., by(time)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=., by(time)
egen rx = mean(rxi) if rxi!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx
gen drxit = rx1m1-rx

egen fpt = mean(fp1m) if fp1m!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

gen error = dfpiIN-dfpi
gen fpwithinIN = fpwithin + dfpi - dfpiIN

tabulate countries, gen(c_)

forval i=1(1)`r(r)' {
    gen fpwithin_`i' = c_`i'*fpwithin
}

* UNIVARIATE REGRESSIONS & ESS RATIOS
mat V = J(3,3,0)
mat B = J(3,1,.)

gmm (rx1m1 - {b}*fp1m - {a}), instruments(fp1m) winitial(identity) wmatrix(hac nwest 12)
estimates store betaOOS_95
mat betaN1[1,1] = e(N)

* Static Equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statOOS_95
/* MT Adjustment: STACKED */ 
predict fit_stat, xb
mat V[1,1] = e(V)
mat B[1,1] = e(b)
mat ESSstat = e(mss)
g v = dfpi^2
sum v if time>=cut
mat VMT = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi[1,1]
mat seMT = sqrt(VMT[1,1])
esttab statOOS_95, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT  /* CORRECTION */
mat stat_v = VMT[1,1]
ereturn post b
quietly estadd matrix se
eststo statOOS_95

* Dynamic Equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_95
/* MT Adjustment: STACKED */ 
mat V[2,2] = e(V)
mat B[2,1] = e(b)
reg rxwithin fpwithin, noconstant robust
estimates store dynOOSrob_95
mat ESSdyn = e(mss)
predict fit_dyn, xb
replace v = fpwithin^2
sum v if time>=cut
mat VMT = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi[1,1]
mat seMT = sqrt(VMT[1,1])
esttab dynOOS_95, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT  /* CORRECTION */
mat dyn_v = VMT[1,1]
ereturn post b
quietly estadd matrix se
eststo dynOOS_95

* Dollar Equation
ivreg2 drxt dfpt, cluster(time) dkraay(0)
estimates store dolOOS_95
reg drxt dfpt, cluster(time)
mat v = e(V)
mat V[3,3] = v[1,1]
mat dol_v = v[1,1]
mat bb = e(b)
mat B[3,1] = bb[1,1]
mat adol = bb[1,2]
mat ESSdol = e(mss)
predict fit_dol, xb

* ESS Static T & ESS Dollar T
mat CT  = ESSstat[1,1] / (ESSstat[1,1] + ESSdyn[1,1])
mat FPP = ESSdol[1,1]  / (ESSdol[1,1]  + ESSdyn[1,1])

qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drxi dfpi rxwithin fpwithin
estimates store ESS_CT_1REB_boot

qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2 drxt dfpt rxwithin fpwithin
estimates store ESS_FPP_1REB_boot


* CT Equation
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradOOS_95
reg rxhml fphml, noconstant robust
estimates store tradOOSrob_95
mat Bct = _b[fphml]
corr fphml fpfpp, cov
mat b = r(C)
mat Act = b[1,1]
mat Afpp = b[2,2]

* FPP Equation
gmm (eq1: rxfpp - {afpp} - {bfpp}*fpfpp), instruments(eq1: fpfpp) winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_95
/* MT Adjustment: STACKED */ 
mat b = e(b)
mat b = b[1,2]
mat vfpp = e(V)
mat vfpp = vfpp[2,2]
replace v = fpfpp^2
sum v if time>=cut
mat VMT = vfpp + b[1,1]^2/`r(sum)'*vfpi[1,1]
mat seMT = sqrt(VMT[1,1])
esttab fppOOS_95, se nostar
mat c = r(coefs)
mat c[2,2] = seMT
mat b = c[1..2,1]'
mat se =  c[1..2,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_95
reg rxfpp fpfpp, robust
estimates store fppOOSrob_95
mat N1[1,1] = e(N)
mat Bfpp = _b[fpfpp]

* FPT multivariate regression
ivreg2 rxfpp dfpt fpwithin, cluster(time) dkraay(18)
estimates store fppOOS_95_multi

test _b[fpwithin]=0
mat pval_multi = r(p)
test _b[dfpt]=0
mat pval_multi = [pval_multi \ r(p)]
test _b[dfpt]=_b[fpwithin]
mat pval_multi = [pval_multi \ r(p)]

mat pval_dyneqdol_95 = J(6,1,.)
local j=1
forval i=0(6)30 {
ivreg2 rxfpp dfpt fpwithin, cluster(time) dkraay(`i')
test _b[dfpt]=_b[fpwithin]
mat pval_dyneqdol_95[`j',1] = r(p)
local `j++'
}


* TESTS ON STRATEGY RETURNS

gen rxcurr = rx1m1*(fp1m - fp)
gen rxfpt = rx1m1*(fp1m - fpi)
gen rxct = rx1m1*(fp1m-fpt)

corr dfpi fpwithin dfpt, cov
mat cc = r(C)
mat A = J(3,3,0)
mat A[1,1] = cc[1,1]
mat A[2,2] = cc[2,2]
mat A[3,3] = cc[3,3]
	
* FPT tests	
gen adyn = rx1m1*(dfpiIN - dfpi)
sum adyn
mat adyn = r(mean)	
sum rxfpt
mat rxfpt = r(mean)
mat adol = r(mean)
mat COV    = A*B*1000000
mat COVct  = Act*Bct*1000000
mat COVfpp = Afpp*Bfpp*1000000

* TAKING OUT k, adyn
gen k = rx*(-dfptIN+fpt - fp)
sum k
mat k = r(mean)	
mat rxfpt = rxfpt[1,1] - k[1,1] - adyn[1,1]
mat test = [0, 1, 1]*A*B
mat var = [0, 1, 1]*A*V*([0, 1, 1]*A)'
mat U = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* Test 1: beta^dyn = 0
mat test = [0, 0, 1]*A*B
mat var = [0, 0, 1]*A*V*([0, 0, 1]*A)'
mat Rdyn = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* Test 2: beta^dol = 0
mat test = [0, 1, 0]*A*B
mat var = [0, 1, 0]*A*V*([0, 1, 0]*A)'
mat Rdol = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* Test 3: beta^dol = beta^dyn
gmm (rxfpp - {a} - {b}*dfpt - {b}*fpwithin), instruments(dfpt fpwithin) winitial(identity) wmatrix(cluster time)
gen fit_dynr = _b[/b]*fpwithin
gen fit_dolr = _b[/b]*dfpt + _b[/a]
mat br = _b[/b]
mat v = e(V)
mat Br = (B[1,1] \ br[1,1] \ br[1,1])
mat Vr = V
mat Vr[2,2] = v[2,2]
mat Vr[3,3] = v[2,2]
mat test = [0, 1, 1]*A*Br
mat var = [0, 1, 1]*A*Vr*([0, 1, 1]*A)'
mat Rsame = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* Create the output matrix
mat CHIdyn_out  = chi2tail(1,Rdyn[1,1] - U[1,1])
mat CHIdol_out  = chi2tail(1,Rdol[1,1] - U[1,1])
mat CHIsame_out = chi2tail(1,Rsame[1,1] - U[1,1])

// SCENARIO 2: 1 Rebalance Strategy (with bid-ask spread)							                                                     

use "Input/Data/DOLdollar_BIG_ALLfwdnet_clean.dta", replace 
g date = dofm(time) 
g year = year(date)

keep if countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42"


xtset countriesnum time

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BUILD NET RETURNS
foreach name in "1m" "2m" "3m" "6m" {
	gen rx`name'it = rxlong`name' 
}

* BUILD NET ER changes
foreach name in "1m" "2m" "3m" "6m"  {
	gen ds`name'it = dslong`name' 
}

* BUILD NET RETURNS: 12m
gen rx1yit = rxlong12m 
gen ds1yit = dslong12m 

* Up to time t for each country
gen fp1mtemp = .
gen fp2mtemp = .
gen fp3mtemp = .
gen fp6mtemp = .
gen fp1ytemp = .

gen storefp1mi = .
gen storefp2mi = .
gen storefp3mi = .
gen storefp6mi = .
gen storefp1yi = .

rename fp12mid fp1yid

preserve

keep if time>=cut

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen fp`name'i = mean(fp`name'id) if fp`name'id!=., by(countries)
}

keep countries time fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

* GENERATE VARIABLES 
foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(time)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(time)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(time)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 2
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
		local lag = 12
	}
	else if "`name'"=="6m" {
		local lag = 18
	}
	else if "`name'"=="1y" {
		local lag = 24	
	}
	gmm (rx`name'it - {b}*fp`name'id - {a}), instruments(fp`name'id) winitial(identity) wmatrix(hac nwest `lag')
	estimates store betaNET`name'_95
	mat betaN1[`idx',1] = e(N)
	local idx = `idx' + 1
}

restore

* Strictly OOS Analysis with Bid-Ask Spreads

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	replace fp`name'temp = fp`name'id if time <= cut
	egen fp`name'i = mean(fp`name'temp), by(countries)	
	/* GET VARIANCE fpi: REGRESSION */
	xi i.countriesnum, noomit
	* Standard OLS
	reg fp`name'id _Icount* if time<=cut, noconstant
	* V(fpihat)
	mat D = e(V)
	mat vfpi`name' = D[1,1]
}

keep countries time fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

keep if time>=cut
g v=.

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(time)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(time)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(time)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 2
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
		local lag = 12
	}
	else if "`name'"=="6m" {
		local lag = 18
	}
	else if "`name'"=="1y" {
		local lag = 24
	}
	
	*------------------------------------------------------------------------------
	* UNIVARIATE REGRESSIONS & ESS RATIOS
	*------------------------------------------------------------------------------
	mat V = J(3,3,0)
	mat B = J(3,1,.)
		
	* Static Equation
	reg drx`name'i dfp`name'i, noconstant cluster(countries)
	estimates store statOOSNET`name'_95
	mat ESSstat = e(mss)
	mat V[1,1] = e(V) /* unadjusted SE */
	mat B[1,1] = e(b)
	/* MT Adjustment: STACKED*/
	replace v = dfp`name'i^2
	sum v if time>=cut
	mat VMT = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'[1,1]
	mat seMT = sqrt(VMT[1,1])
	esttab statOOSNET`name'_95, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOS`name'_95	
	
	* Dynamic Equation
	gmm (rx`name'within - {bdyn}*fp`name'within), instruments(fp`name'within, noconstant) winitial(identity) wmatrix(hac nwest `lag')
	estimates store dynOOSNET`name'_95
	mat V[2,2] = e(V)
	reg rx`name'within fp`name'within, noconstant robust
	estimates store dynOOSrobNET`name'_95
	mat ESSdyn = e(mss)
	{/* MT Adjustment: STACKED*/
	* VAR(dfpi)
	* DONE ABOVE
	replace v = fp`name'within^2
	sum v if time>=cut
	mat VMT = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi[1,1]
	mat seMT = sqrt(VMT[1,1])
	esttab dynOOSNET`name'_95, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	}
	eststo dynOOSNET`name'_95	
	
	* Dollar Equation
	local dk = 2*(`lag' - 12)
	ivreg2 drx`name't dfp`name't, cluster(time) dkraay(`dk')
	mat V  = e(V)
	mat dol_v = V[1,1]
	estimates store dolOOSNET`name'_95
	reg drx`name't dfp`name't, cluster(time)
	mat ESSdol = e(mss)
	
	* ESS Static T & ESS Dollar T
	mat CT  = (CT, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
	mat FPP = (FPP, ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))
	
	* CT Equation
	gmm (eq1: rx`name'hml - {btrad}*fp`name'hml), instruments(eq1: fp`name'hml, noconstant) winitial(identity) wmatrix(hac nwest `lag')
	estimates store tradOOSNET`name'_95
				
	reg rx`name'hml fp`name'hml, noconstant robust
	estimates store tradOOSrobNET`name'_95
    
    * FPP Equation 
	gmm (eq1: rx`name'fpp - {afpp} - {bfpp}*fp`name'fpp), instruments(eq1: fp`name'fpp) winitial(identity) wmatrix(hac nwest `lag')
	estimates store fppOOSNET`name'_95
	mat b = e(b)
	mat b = b[1,2]
	mat vfpp = e(V)
	mat vfpp = vfpp[2,2]
	reg rx`name'fpp fp`name'fpp, robust
	estimates store fppOOSrobNET`name'_95
	mat N1[`idx',1] = e(N)
	local idx = `idx' + 1
	{/* MT Adjustment: STACKED*/
	* VAR(dfpi)
	* DONE ABOVE
	replace v = fp`name'fpp^2
	sum v if time>=cut
	mat VMT = vfpp + b[1,1]^2/`r(sum)'*vfpi[1,1]
	mat seMT = sqrt(VMT[1,1])
	esttab fppOOSNET`name'_95, se nostar
	mat c = r(coefs)
	mat c[2,2] = seMT /* CORRECTION */
	mat b = c[1..2,1]'
	mat se =  c[1..2,2]'
	ereturn post b
	quietly estadd matrix se
	}
	eststo fppOOSNET`name'_95
	
	qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drx`name'i dfp`name'i rx`name'within fp`name'within
	estimates store ESS_CT_1REBNET`name'_boot

	qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2 drx`name't dfp`name't rx`name'within fp`name'within 
	estimates store ESS_FPP_1REBNET`name'_boot	
	
}

// SCENARIO 3: DOLdollar SAMPLE, 3 Rebalances Strategy: DEC89, DEC97, DEC04 									

use "Input/Data/DOLdollar_BIG_ALLfwd_clean.dta", replace 

gen rebal=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=359))

replace rebal=2 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<539 & time>=455))

replace rebal=3 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=539))

gen pre1=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<=359))

gen pre2=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=455))

gen pre3=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time<=539))


xtset countriesnum time

save "Temp/3REBdata.dta", replace

* In Sample Analysis
keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=359)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<539 & time>=455)) | /// 
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=539))

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

egen avgfp1m = mean(fp1m) if fp1m!=., by(countries rebal)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=. & rebal!=., by(time)
egen rxi = mean(rx1m1) if rx1m1!=., by(countries rebal)
egen rx = mean(rxi) if rxi!=., by(rebal)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

rename avgfp1m fpi
egen fpt = mean(fp1m) if fp1m!=., by(time)
egen fp = mean(fpi) if fpi!=., by(rebal)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

* RUN REGRESSIONS JOINTLY

* STATIC equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statIN_3REB
mat ESSstat = e(mss)

* DYNAMIC equation
gmm (eq1: rxwithin - {bdyn}*fpwithin), instruments(eq1: fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynIN_3REB
reg rxwithin fpwithin, noconstant robust
mat ESSdyn = e(mss)

* DOLLAR equation
ivreg2 drxt dfpt, cluster(time) dkraay(0) noconstant
estimates store dolIN_3REB
reg drxt dfpt, cluster(time) noconstant
mat ESSdol = e(mss)

* CT equation
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradIN_3REB

* FPP equation
gmm (eq1: rxfpp - {bfpp}*fpfpp), instruments(eq1: fpfpp, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store fppIN_3REB

* ESS Static T & ESS Dollar T
mat CT_in  = (CT_in, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
mat FPP_in = (FPP_in, ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))

* Test
reg rxfpp dfpt fpwithin, noconstant cluster(time)
test (fpwithin=dfpt)
mat TEST = (TEST, r(p))

keep countries time dfpi dfpt fp
rename dfpi dfpiIN
rename dfpt dfptIN
rename fp fpIN
sort countries time

merge 1:1 countries time using "Temp/3REBdata.dta"
drop _merge

* STRICTLY OOS ANALYSIS
scalar finish = 604
scalar cut3   = 539
scalar cut2   = 455
scalar cut1   = 359

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* rebal==1
gen fp1mtemp = fp1m if time<=cut1
egen avgfp1m = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi = mean(rx1m1) if rebal==1, by(countries)

* rebal==2
replace fp1mtemp = fp1m if time<=cut2
egen avgfp1m2 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi2 = mean(rx1m1) if rebal==2, by(countries)

replace avgfp1m = avgfp1m2 if rebal==2
replace rxi= rxi2 if rebal==2

* rebal==3
replace fp1mtemp = fp1m if time<=cut3
egen avgfp1m3 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi3 = mean(rx1m1) if rebal==3, by(countries)

replace avgfp1m = avgfp1m3 if rebal==3
replace rxi= rxi3 if rebal==3

rename avgfp1m fpi
egen fp = mean(fpi) if fpi!=.  & rebal!=., by(rebal)
egen rx = mean(rxi) if rxi!=.  & rebal!=., by(rebal)

* GET V(fpi): 1) using all pre-sample (_all); 2) per rebalance (_pr) and averaging

preserve

keep if pre1!=. | pre2!=. | pre3!=.
* 1) ALL PRE-SAMPLE
xi i.countriesnum, noomit 
* fpihat
reg fp1m _Icount*, noconstant
mat vfpi_all = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)

restore

mat vfpi_r = J(3,1,.)
* 2) PER REBALANCE
forval j=1(1)3 {
	preserve
	keep if pre`j'==1
	xi i.countriesnum, noomit 
	reg fp1m _Icount*, noconstant
	mat vfpi_r[`j',1] = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
	restore
	}
* V_R(fpihat)
mat vfpi_R = J(1,3,1)*vfpi_r/3

* Generate Variables
keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=359)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<539 & time>=455)) | /// 
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=539))

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=. & rebal!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

egen fpt = mean(fp1m) if fp1m!=. & rebal!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

gen error = dfpiIN-dfpi
gen fpwithinIN = fpwithin + dfpi - dfpiIN

* UNIVARIATE REGRESSIONS & ESS RATIOS

xi i.rebal
mat V = J(3,3,0)
mat B = J(3,1,.)

gmm (rx1m1 - {b}*fp1m - {a}), instruments(fp1m) winitial(identity) wmatrix(hac nwest 12)
estimates store betaOOS_3REB
mat betaN1[5,1] = e(N)

* STATIC equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statOOS_3REB
mat V[1,1] = e(V)
mat B[1,1] = e(b)
mat ESSstat = e(mss)
predict fit_stat, xb
g v = dfpi^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
mat stat_v = VMT_all[1,1]
* 2) PER REBALANCE
mat VMT_R = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab statOOS_3REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_all /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo statOOS_3REB_all
esttab statOOS_3REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_R /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo statOOS_3REB_R

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_3REB
mat V[2,2] = e(V)
mat B[2,1] = e(b)
reg rxwithin fpwithin, noconstant robust
estimates store dynOOSrob_3REB
mat ESSdyn = e(mss)
predict fit_dyn, xb
replace v = fpwithin^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
* 2) PER REBALANCE
mat VMT_R = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab dynOOS_3REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_all /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo dynOOS_3REB_all
esttab dynOOS_3REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_R /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo dynOOS_3REB_R

* DOLLAR equation
xi: ivreg2 drxt dfpt i.rebal, cluster(time) dkraay(0)
estimates store dolOOS_3REB
mat v = e(V)
mat V[3,3] = v[1,1]
mat dol_v = v[1,1]
mat bb = e(b)
mat B[3,1] = bb[1,1]
mat adol = bb[1,2]
mat ESSdol = e(mss)
predict fit_dol, xb

* ESS Static T & ESS Dollar T 
mat CT  = (CT, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
mat FPP = (FPP,ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))

qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drxi dfpi rxwithin fpwithin
estimates store ESS_CT_3REB_boot

qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2_xREB drxt dfpt i.rebal rxwithin fpwithin
estimates store ESS_FPP_3REB_boot

* CT equation
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradOOS_3REB
reg rxhml fphml, noconstant robust
estimates store tradOOSrob_3REB

* FPP equation
gmm (eq1: rxfpp - {afpp} - {afpp2}*_Irebal_2 - {afpp3}*_Irebal_3 - {bfpp}*fpfpp), instruments(eq1: fpfpp _Irebal_2 _Irebal_3) ///
winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_3REB
mat b = e(b)
mat b = b[1,4]
mat vfpp = e(V)
mat vfpp = vfpp[4,4]
{/* MT Adjustment*/
replace v = fpfpp^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = vfpp + b[1,1]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
* 2) PER REBALANCE
mat VMT_R = vfpp + b[1,1]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab fppOOS_3REB, se nostar
mat c = r(coefs)
mat c[4,2] = seMT_all /* CORRECTION */
mat b = c[1..4,1]'
mat se =  c[1..4,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_3REB_all
esttab fppOOS_3REB, se nostar
mat c = r(coefs)
mat c[4,2] = seMT_R /* CORRECTION */
mat b = c[1..4,1]'
mat se =  c[1..4,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_3REB_R
}
reg rxfpp fpfpp _Irebal_2 _Irebal_3, robust
estimates store fppOOSrob_3REB
mat N1[5,1] = e(N)
/* FIXMERM
* FPT multivariate regression
ivreg2 rxfpp dfpt fpwithin _Irebal_2 _Irebal_3, cluster(time) dkraay(24)
estimates store fppOOS_3REB_multi

test _b[fpwithin]=0
mat pval_multi = [pval_multi , [r(p) \ 0 \ 0]]
test _b[dfpt]=0
mat pval_multi[2,2] = r(p)
test _b[dfpt]=_b[fpwithin]
mat pval_multi[3,2] = r(p)

// Output to Table X -- Response Document Jira task 57
estout fppOOS_95_multi fppOOS_3REB_multi using "./Input/tex_figs/OOSfpp_multi.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(dfpt "\(\beta^{dol}\)" fpwithin "\(\beta^{dyn}\)") cells(b(star fmt(2)) se(par fmt(2))) drop(_Irebal_* _cons) ///
eqlabels(none) label starlevels(* 0.1 ** 0.05 *** 0.01) 

estout matrix(pval_multi, fmt(%3.2f)) using "./Input/tex_figs/CHIsq_tests_multi.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\(\beta^{dyn} = 0\)" r2 "\(\beta^{dol} = 0\)" r3 "\(\beta^{dol}=\beta^{dyn}\)" ) label 

mat pval_dyneqdol = J(6,1,.)
local j=1
forval i=0(6)30 {
ivreg2 rxfpp dfpt fpwithin _Irebal_2 _Irebal_3, cluster(time) dkraay(`i')
test _b[dfpt]=_b[fpwithin]
mat pval_dyneqdol[`j',1] = r(p)
local `j++'
}

mat pval_dyneqdol = [pval_dyneqdol_95 , pval_dyneqdol]

estout matrix(pval_dyneqdol, fmt(%3.2f)) using "./Input/tex_figs/CHIsq_tests_multi_rob.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "lag=0" r2 "lag=6" r3 "lag=12" r4 "lag=18" r5 "lag=24" r6 "lag=30" ) label 
*/

* TESTS ON STRATEGY RETURNS

gen rxcurr = rx1m1*(fp1m - fp)
gen rxfpt = rx1m1*(fp1m - fpi)
gen rxct = rx1m1*(fp1m-fpt)

corr dfpi fpwithin dfptIN, cov
mat cc = r(C)
mat A = J(3,3,0)
mat A[1,1] = cc[1,1]
mat A[2,2] = cc[2,2]
mat A[3,3] = cc[3,3]
	
* FPT tests
gen adyn = rxi*(dfpiIN - dfpi)
gen k = rx*(-dfptIN+fpt - fp)

mat adyn = 0
mat k = 0
mat rxfpt = 0

forval r = 1 (1) 3 {
	sum adyn if rebal==`r'
	mat adyn = adyn + r(mean)/3
	sum k if rebal==`r'
	mat k = k + r(mean)/3
	sum rxfpt if rebal==`r'
	mat rxfpt = rxfpt + r(mean)/3
}

* TAKING OUT k, adyn
mat rxfpt = rxfpt[1,1] - k[1,1] - adyn[1,1]

mat test = [0, 1, 1]*A*B
mat var = [0, 1, 1]*A*V*([0, 1, 1]*A)'

mat U = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* dyn=0

mat test = [0, 0, 1]*A*B
mat var = [0, 0, 1]*A*V*([0, 0, 1]*A)'

mat Rdyn = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* dol=0
mat test = [0, 1, 0]*A*B
mat var = [0, 1, 0]*A*V*([0, 1, 0]*A)'

mat Rdol = (test[1,1]-rxfpt[1,1])^2/var[1,1]

* dol = dyn
gmm (rxfpp - {a} - {a2}*_Irebal_2  - {a3}*_Irebal_3 - {b}*dfpt - {b}*fpwithin), instruments(dfpt fpwithin _Irebal_*) winitial(identity) wmatrix(cluster time)
mat br = _b[/b]
mat v = e(V)

mat Br = (B[1,1] \ br[1,1] \ br[1,1])
mat Vr = V
mat Vr[2,2] = v[4,4]
mat Vr[3,3] = v[4,4]

mat test = [0, 1, 1]*A*Br
mat var = [0, 1, 1]*A*Vr*([0, 1, 1]*A)'

mat Rsame = (test[1,1]-rxfpt[1,1])^2/var[1,1]

mat CHIdyn_out  = (CHIdyn_out, chi2tail(1,Rdyn[1,1] - U[1,1]))
mat CHIdol_out  = (CHIdol_out, chi2tail(1,Rdol[1,1] - U[1,1]))
mat CHIsame_out = (CHIsame_out, chi2tail(1,Rsame[1,1] - U[1,1]))

// SCENARIO 4: 3 Rebalance Strategy (with bid-ask spread)							                                                     

use "Input/Data/DOLdollar_BIG_ALLfwdnet_clean.dta", replace 
g date = dofm(time) 
g year = year(date)
gen rebal=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=359))

replace rebal=2 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<539 & time>=455))

replace rebal=3 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=539))

gen pre1=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<=359))

gen pre2=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=455))

gen pre3=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time<=539))


xtset countriesnum time

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BUILD NET RETURNS
foreach name in "1m" "2m" "3m" "6m"  {
	gen rx`name'it = rxlong`name' 
}

* BUILD NET ER changes
foreach name in "1m" "2m" "3m" "6m"  {
	gen ds`name'it = dslong`name' 
}

* BUILD NET RETURNS: 12m
gen rx1yit = rxlong12m 
gen ds1yit = dslong12m 

* Up to time t for each country
gen fp1mtemp = .
gen fp2mtemp = .
gen fp3mtemp = .
gen fp6mtemp = .
gen fp1ytemp = .

gen storefp1mi = .
gen storefp2mi = .
gen storefp3mi = .
gen storefp6mi = .
gen storefp1yi = .

rename fp12mid fp1yid

preserve

keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=359)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<539 & time>=455)) | /// 
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=539))

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen fp`name'i = mean(fp`name'id) if fp`name'id!=., by(countries rebal)
}

keep countries time rebal fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries rebal)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(rebal)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(rebal)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(rebal)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 6
foreach name in "1m" "6m" "1y"  {	
	if "`name'"=="1m" {
		local lag = 12
	}
	else if "`name'"=="6m" {
		local lag = 18
	}
	else if "`name'"=="1y" {
		local lag = 24
	}
	gmm (rx`name'it - {b}*fp`name'id - {a}), instruments(fp`name'id) winitial(identity) wmatrix(hac nwest `lag')
	estimates store betaNET`name'_3REB
	mat betaN1[`idx',1] = e(N)
	local idx = `idx' + 1
}

restore

* STRICTLY OOS ANALYSIS WITH BID-ASK SPREADS

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	* rebal==1
	replace fp`name'temp = fp`name'id if time<=cut1
	egen avgfp`name' = mean(fp`name'temp) if fp`name'id!=., by(countries)
	
	* rebal==2
	replace fp`name'temp = fp`name'id if time<=cut2
	egen avgfp`name'2 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'2 if rebal==2
	
	* rebal==3
	replace fp`name'temp = fp`name'id if time<=cut3
	egen avgfp`name'3 = mean(fp`name'temp) if fp`name'id!=., by(countries)

	replace avgfp`name' = avgfp`name'3 if rebal==3
	
	rename avgfp`name' fp`name'i
	
	*-------------------------------------------------------------------------------------
	* GET V(fpi): 1) using all pre-sample (_all); 2) per rebalance (_pr) and averaging
	*-------------------------------------------------------------------------------------
	preserve
	keep if pre1!=. | pre2!=. | pre3!=. 
	* 1) ALL PRE-SAMPLE
	xi i.countriesnum, noomit 
	* fpihat
	reg fp`name'id _Icount*, noconstant
	mat vfpi`name'_all = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
	restore

	mat vfpi`name'_r = J(3,1,.)
	* 2) PER REBALANCE
	forval j=1(1)3 {
		preserve
		keep if pre`j'==1
		xi i.countriesnum, noomit 
		reg fp`name'id _Icount*, noconstant
		mat vfpi`name'_r[`j',1] = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
		restore
	}
	* V_R(fpihat)
	mat vfpi`name'_R = J(1,3,1)*vfpi`name'_r/3	
}

keep countries time rebal fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

* GENERATE VARIABLES

keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=359)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<539 & time>=455)) | /// 
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | countries=="C39" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=539))

xi i.rebal
gen v=.
foreach name in "1m" "2m" "3m" "6m" "1y"  {
	
	*gen rx`name'i = storerx`name'i
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries rebal)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(rebal)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(rebal)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(rebal)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 6
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
		local lag = 12
	}
	else if "`name'"=="6m" {
		local lag = 18
	}
	else if "`name'"=="1y" {
		local lag = 24
	}
	
	mat V = J(3,3,0)
	mat B = J(3,1,.)
	
	* Static Equation
	reg drx`name'i dfp`name'i, cluster(countries) noconstant
	estimates store statOOSNET`name'_3REB
	mat ESSstat = e(mss)
	mat V[1,1] = e(V)
	{/* MT Adjustment: STACKED*/
	replace v = dfp`name'i^2
	sum v if time >= cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab statOOSNET`name'_3REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_all /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOSNET`name'_3REB_all
	esttab statOOSNET`name'_3REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_R /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOSNET`name'_3REB_R
	}

	* Dynamic Equation
	gmm (rx`name'within - {bdyn}*fp`name'within), instruments(fp`name'within, noconstant) winitial(identity) wmatrix(hac nwest `lag')
	estimates store dynOOSNET`name'_3REB
	mat V[2,2] = e(V)
	reg rx`name'within fp`name'within, noconstant robust
	estimates store dynOOSrobNET`name'_3REB
	mat ESSdyn = e(mss)
	{/* MT Adjustment: STACKED*/
	replace v = fp`name'within^2
	sum v if time>=cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab dynOOSNET`name'_3REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_all /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo dynOOSNET`name'_3REB_all
	esttab dynOOSNET`name'_3REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_R /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo dynOOSNET`name'_3REB_R
	}
	
	* Dollar Equation
	local dk = 2*(`lag' - 12)
	ivreg2 drx`name't dfp`name't _Irebal_*, cluster(time) dkraay(`dk')
	mat V  = e(V)
	mat dol_v = V[1,1]
	estimates store dolOOSNET`name'_3REB
	mat ESSdol = e(mss)
	mat CT = (CT, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
	mat FPP = (FPP,ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))

	* CT Equation
	gmm (eq1: rx`name'hml - {btrad}*fp`name'hml), instruments(eq1: fp`name'hml, noconstant) winitial(identity) wmatrix(hac nwest `lag')
	estimates store tradOOSNET`name'_3REB
	reg rx`name'hml fp`name'hml, noconstant robust
	estimates store tradOOSrobNET`name'_3REB
    
	* FPP Equation
	gmm (eq1: rx`name'fpp - {afpp}  - {afpp2}*_Irebal_2 - {afpp3}*_Irebal_3 - {bfpp}*fp`name'fpp), instruments(eq1: fp`name'fpp _Irebal_2 _Irebal_3) ///
	winitial(identity) wmatrix(hac nwest `lag')	
	estimates store fppOOSNET`name'_3REB
	mat b = e(b)
	mat b = b[1,4]
	mat vfpp = e(V)
	mat vfpp = vfpp[4,4]
	/* MT Adjustment*/
	replace v = fp`name'fpp^2
	sum v if time>=cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = vfpp + b[1,1]^2/`r(sum)'*vfpi_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = vfpp + b[1,1]^2/`r(sum)'*vfpi_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab fppOOSNET`name'_3REB, se nostar
	mat c = r(coefs)
	mat c[4,2] = seMT_all /* CORRECTION */
	mat b = c[1..4,1]'
	mat se =  c[1..4,2]'
	ereturn post b
	quietly estadd matrix se
	eststo fppOOSNET`name'_3REB_all
	esttab fppOOSNET`name'_3REB, se nostar
	mat c = r(coefs)
	mat c[4,2] = seMT_R /* CORRECTION */
	mat b = c[1..4,1]'
	mat se =  c[1..4,2]'
	ereturn post b
	quietly estadd matrix se
	eststo fppOOSNET`name'_3REB_R
	reg rx`name'fpp fp`name'fpp _Irebal_2 _Irebal_3, robust
	estimates store fppOOSrobNET`name'_3REB
	mat N1[`idx',1] = e(N)
	local idx = `idx' + 1
	
	qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drx`name'i dfp`name'i rx`name'within fp`name'within
	estimates store ESS_CT_3REBNET`name'_boot

	qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2_xREB drx`name't dfp`name't i.rebal rx`name'within fp`name'within 
	estimates store ESS_FPP_3REBNET`name'_boot		
	
}

// SCENARIO 5: DOLdollar SAMPLE, 6 Rebalances Strategy: DEC89, DEC93, DEC97, DEC01, DEC04, DEC07

use "Input/Data/DOLdollar_BIG_ALLfwd_clean.dta", replace 

* Generate data 
 gen rebal=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<407 & time>=359))

replace rebal=2 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=407))

replace rebal=3 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<491 & time>=455))

replace rebal=4 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=491 & time<539))

replace rebal=5 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=539 & time<575))

replace rebal=6 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=575))

gen pre1=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<=359))

gen pre2=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<=407))

gen pre3=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=455))

gen pre4=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time<=491))

gen pre5=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=539))

gen pre6=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=575))


xtset countriesnum time

save "Temp/6REBdata.dta", replace

* IN SAMPLE ANALYSIS

 keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<407 & time>=359)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=407)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<491 & time>=455)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=491 & time<539)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=539 & time<575)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=575))

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

egen avgfp1m = mean(fp1m) if fp1m!=., by(countries rebal)

egen rxt = mean(rx1m1) if rx1m1!=. & rebal!=., by(time)
egen rxi = mean(rx1m1) if rx1m1!=., by(countries rebal)
egen rx = mean(rxi) if rxi!=., by(rebal)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

rename avgfp1m fpi
egen fpt = mean(fp1m) if fp1m!=., by(time)
egen fp = mean(fpi) if fpi!=., by(rebal)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

* RUN REGRESSIONS JOINTLY

* STATIC equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statIN_6REB
mat ESSstat = e(mss)

* DYNAMIC equation
gmm (eq1: rxwithin - {bdyn}*fpwithin), instruments(eq1: fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynIN_6REB
reg rxwithin fpwithin, noconstant robust
mat ESSdyn = e(mss)

* DOLLAR equation
ivreg2 drxt dfpt, cluster(time) dkraay(0) noconstant
estimates store dolIN_6REB
reg drxt dfpt, cluster(time) noconstant
mat ESSdol = e(mss)

* CT equation
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradIN_6REB

* FPP equation
gmm (eq1: rxfpp - {bfpp}*fpfpp), instruments(eq1: fpfpp, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store fppIN_6REB

* ESS Static T & ESS Dollar T
mat CT2_in  = ESSstat[1,1] / (ESSstat[1,1] + ESSdyn[1,1])
mat FPP2_in = ESSdol[1,1]  / (ESSdol[1,1]  + ESSdyn[1,1])

* Test
reg rxfpp dfpt fpwithin, noconstant cluster(time)
test (fpwithin=dfpt)
mat TEST = (TEST, r(p))

keep countries time dfpi dfpt
rename dfpi dfpiIN
rename dfpt dfptIN
sort countries time

merge 1:1 countries time using "Temp/6REBdata.dta"
drop _merge

* STRICTLY OOS ANALYSIS

scalar finish = 604

scalar cut6 = 575
scalar cut5 = 539
scalar cut4 = 503
scalar cut3 = 455
scalar cut2 = 407
scalar cut1 = 359

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BEFORE each rebalance

* rebal==1: create avgfp
gen fp1mtemp = fp1m if time<=cut1
egen avgfp1m = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi = mean(rx1m1) if rebal==1, by(countries)

* rebal==2: create avgfp
replace fp1mtemp = fp1m if time<=cut2
egen avgfp1m2 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi2 = mean(rx1m1) if rebal==2, by(countries)
replace avgfp1m = avgfp1m2 if rebal==2
replace rxi= rxi2 if rebal==2

* rebal==3: create avgfp
replace fp1mtemp = fp1m if time<=cut3
egen avgfp1m3 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi3 = mean(rx1m1) if rebal==3, by(countries)
replace avgfp1m = avgfp1m3 if rebal==3
replace rxi= rxi3 if rebal==3

* rebal==4: create avgfp
replace fp1mtemp = fp1m if time<=cut4
egen avgfp1m4 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi4 = mean(rx1m1) if rebal==4, by(countries)
replace avgfp1m = avgfp1m4 if rebal==4
replace rxi= rxi4 if rebal==4

* rebal==5: create avgfp
replace fp1mtemp = fp1m if time<=cut5
egen avgfp1m5 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi5 = mean(rx1m1) if rebal==5, by(countries)
replace avgfp1m = avgfp1m5 if rebal==5
replace rxi= rxi5 if rebal==5

* rebal==6: create avgfp
replace fp1mtemp = fp1m if time<=cut6
egen avgfp1m6 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi6 = mean(rx1m1) if rebal==6, by(countries)
replace avgfp1m = avgfp1m6 if rebal==6
replace rxi= rxi6 if rebal==6

rename avgfp1m fpi
egen fp = mean(fpi) if fpi!=.  & rebal!=., by(rebal)
egen rx = mean(rxi) if rxi!=.  & rebal!=., by(rebal)

* GET V(fpi): 1) using all pre-sample (_all); 2) per rebalance (_pr) and averaging

preserve

keep if pre1!=. | pre2!=. | pre3!=. | pre4!=. | pre5!=. | pre6!=.
* 1) ALL PRE-SAMPLE
xi i.countriesnum, noomit 
* fpihat
reg fp1m _Icount*, noconstant
mat vfpi_all = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
restore

mat vfpi_r = J(6,1,.)
* 2) PER REBALANCE
forval j=1(1)6 {
	preserve
	keep if pre`j'==1
	xi i.countriesnum, noomit 
	reg fp1m _Icount*, noconstant
	mat vfpi_r[`j',1] = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
	restore
}
* V_R(fpihat)
mat vfpi_R = J(1,6,1)*vfpi_r/6  

* Generate Variables

 keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<407 & time>=359)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=407)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<491 & time>=455)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=491 & time<539)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=539 & time<575)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=575))

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=. & rebal!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

egen fpt = mean(fp1m) if fp1m!=. & rebal!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

gen error = dfpiIN-dfpi
gen fpwithinIN = fpwithin + dfpi - dfpiIN

* RUN REGRESSIONS JOINTLY

xi i.rebal

mat V = J(3,3,0)
mat B = J(3,1,.)

gmm (rx1m1 - {b}*fp1m - {a}), instruments(fp1m) winitial(identity) wmatrix(hac nwest 12)
estimates store betaOOS_6REB
mat betaN2[1,1] = e(N)

* STATIC equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statOOS_6REB
mat V[1,1] = e(V)
mat B[1,1] = e(b)
mat ESSstat = e(mss)
predict fit_stat, xb
{/* MT Adjustment*/
g v = dfpi^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
mat stat_v = VMT_all[1,1]
* 2) PER REBALANCE
mat VMT_R = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab statOOS_6REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_all /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo statOOS_6REB_all
esttab statOOS_6REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_R /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo statOOS_6REB_R
}

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_6REB
mat V[2,2] = e(V)
mat B[2,1] = e(b)
reg rxwithin fpwithin, noconstant robust
estimates store dynOOSrob_6REB
mat ESSdyn = e(mss)
predict fit_dyn, xb
{/* MT Adjustment: STACKED*/
replace v = fpwithin^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
mat dyn_v = VMT_all[1,1]
* 2) PER REBALANCE
mat VMT_R = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab dynOOS_6REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_all /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo dynOOS_6REB_all
esttab dynOOS_6REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_R /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo dynOOS_6REB_R
}

* DOLLAR equation
xi: ivreg2 drxt dfpt i.rebal, cluster(time) dkraay(0)
estimates store dolOOS_6REB
mat v = e(V)
mat V[3,3] = v[1,1]
mat dol_v = v[1,1]
mat bb = e(b)
mat B[3,1] = bb[1,1]
mat adol = bb[1,2]
mat ESSdol = e(mss)
predict fit_dol, xb

mat CT2 = ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1])
mat FPP2 = ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1])

qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drxi dfpi rxwithin fpwithin
estimates store ESS_CT_6REB_boot

qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2_xREB  drxt dfpt i.rebal rxwithin fpwithin
estimates store ESS_FPP_6REB_boot

gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradOOS_6REB

reg rxhml fphml, noconstant robust
estimates store tradOOSrob_6REB

gmm (eq1: rxfpp - {afpp} - {afpp2}*_Irebal_2 - {afpp3}*_Irebal_3 - {afpp4}*_Irebal_4 - {afpp5}*_Irebal_5 - ///
{afpp6}*_Irebal_6 - {bfpp}*fpfpp), instruments(eq1: fpfpp _Irebal_2 _Irebal_3 _Irebal_4 _Irebal_5 _Irebal_6) ///
winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_6REB
mat b = e(b)
mat b = b[1,7]
mat vfpp = e(V)
mat vfpp = vfpp[7,7]
{/* MT Adjustment*/
replace v = fpfpp^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = vfpp + b[1,1]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
* 2) PER REBALANCE
mat VMT_R = vfpp + b[1,1]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab fppOOS_6REB, se nostar
mat c = r(coefs)
mat c[7,2] = seMT_all /* CORRECTION */
mat b = c[1..7,1]'
mat se =  c[1..7,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_6REB_all
esttab fppOOS_6REB, se nostar
mat c = r(coefs)
mat c[7,2] = seMT_R /* CORRECTION */
mat b = c[1..7,1]'
mat se =  c[1..7,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_6REB_R
}

reg rxfpp fpfpp _Irebal_2 _Irebal_3 _Irebal_4 _Irebal_5 _Irebal_6, robust
estimates store fppOOSrob_6REB
mat N2[1,1] = e(N)

// SCENARIO 6: DOLdollar SAMPLE, 6 Rebalances Strategy: DEC89, DEC93, DEC97, DEC01, DEC04, DEC07, WITH BID-ASK SPREADS

use "Input/Data/DOLdollar_BIG_ALLfwdnet_clean.dta", replace 
g date = dofm(time) 
g year = year(date)
 gen rebal=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<407 & time>=359))

replace rebal=2 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=407))

replace rebal=3 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<491 & time>=455))

replace rebal=4 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=491 & time<539))

replace rebal=5 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=539 & time<575))

replace rebal=6 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=575))

gen pre1=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<=359))

gen pre2=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<=407))

gen pre3=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=455))

gen pre4=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time<=491))

gen pre5=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=539))

gen pre6=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=575))


xtset countriesnum time

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BUILD NET RETURNS
foreach name in "1m" "2m" "3m" "6m"  {
	gen rx`name'it = rxlong`name' 
}

* BUILD NET ER changes
foreach name in "1m" "2m" "3m" "6m"  {
	gen ds`name'it = dslong`name' 
}

* BUILD NET RETURNS: 12m
gen rx1yit = rxlong12m 
gen ds1yit = dslong12m 

* up to time t for each country
gen fp1mtemp = .
gen fp2mtemp = .
gen fp3mtemp = .
gen fp6mtemp = .
gen fp1ytemp = .

gen storefp1mi = .
gen storefp2mi = .
gen storefp3mi = .
gen storefp6mi = .
gen storefp1yi = .

rename fp12mid fp1yid

preserve

 keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<407 & time>=359)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=407)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<491 & time>=455)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=491 & time<539)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=539 & time<575)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=575))

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen fp`name'i = mean(fp`name'id) if fp`name'id!=., by(countries rebal)
}

keep countries time rebal fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries rebal)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(rebal)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(rebal)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(rebal)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 2
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
	local lag = 12
	}
	else if "`name'"=="6m" {
	local lag = 18
	}
	else if "`name'"=="1y" {
	local lag = 24
	}
	gmm (rx`name'it - {b}*fp`name'id - {a}), instruments(fp`name'id) winitial(identity) wmatrix(hac nwest `lag')
	estimates store betaNET`name'_6REB	
	mat betaN2[`idx',1] = e(N)
	local idx = `idx' + 1
}

restore
 
* STRICTLY OOS WITH BID-ASK SPREADS

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	* rebal==1
	replace fp`name'temp = fp`name'id if time<=cut1
	egen avgfp`name' = mean(fp`name'temp) if fp`name'id!=., by(countries)
	* rebal==2
	replace fp`name'temp = fp`name'id if time<=cut2
	egen avgfp`name'2 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'2 if rebal==2				
	* rebal==3
	replace fp`name'temp = fp`name'id if time<=cut3
	egen avgfp`name'3 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'3 if rebal==3
	* rebal==4
	replace fp`name'temp = fp`name'id if time<=cut4
	egen avgfp`name'4 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'4 if rebal==4				
	* rebal==5
	replace fp`name'temp = fp`name'id if time<=cut5
	egen avgfp`name'5 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'5 if rebal==5
	* rebal==6
	replace fp`name'temp = fp`name'id if time<=cut6
	egen avgfp`name'6 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'6 if rebal==6
	
	rename avgfp`name' fp`name'i
	
	*-------------------------------------------------------------------------------------
	* GET V(fpi): 1) using all pre-sample (_all); 2) per rebalance (_pr) and averaging
	*-------------------------------------------------------------------------------------
	preserve
	keep if pre1!=. | pre2!=. | pre3!=. | pre4!=. | pre5!=. | pre6!=.
	* 1) ALL PRE-SAMPLE
	xi i.countriesnum, noomit 
	* fpihat
	reg fp`name'id _Icount*, noconstant
	mat vfpi`name'_all = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
	restore

	mat vfpi`name'_r = J(6,1,.)
	* 2) PER REBALANCE
	forval j=1(1)6 {
		preserve
		keep if pre`j'==1
		xi i.countriesnum, noomit 
		reg fp`name'id _Icount*, noconstant
		mat vfpi`name'_r[`j',1] = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
		restore
	}
	* V_R(fpihat)
	mat vfpi`name'_R = J(1,6,1)*vfpi`name'_r/6		
}

keep countries time rebal fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

* Generate Variables

 keep if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<407 & time>=359)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | countries=="C7" | ///
countries=="C8" | countries=="C9" | countries=="C10" | countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | countries=="C22" | ///
countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | countries=="C34" | ///
countries=="C35" | countries=="C41" | countries=="C42") & (time<455 & time>=407)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<491 & time>=455)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C8" | countries=="C15" | ///
countries=="C22" | countries=="C24" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C40" | countries=="C41" | countries=="C42") & (time>=491 & time<539)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=539 & time<575)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | countries=="C8" | ///
countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" |  ///
countries=="C24" | countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | ///
countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | countries=="C37" | ///
countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time>=575))

xi i.rebal
gen v=.
foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries rebal)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(rebal)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(rebal)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(rebal)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 2
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
		local lag = 12
	}
	else if "`name'"=="6m" {
		local lag = 18
	}
	else if "`name'"=="1y" {
		local lag = 24
	}
	
	mat V = J(3,3,0)
	mat B = J(3,1,.)	
	
	* STATIC equation
	reg drx`name'i dfp`name'i, cluster(countries) noconstant
	estimates store statOOSNET`name'_6REB
	mat ESSstat = e(mss)
	mat V[1,1] = e(V)	
	{/* MT Adjustment: STACKED*/
	* VAR(dfpi)
	replace v = dfp`name'i^2
	sum v if time>=cut1	
	* 1) ALL PRE-SAMPLE
	mat VMT_all = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])	
	* 2) PER REBALANCE
	mat VMT_R = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab statOOSNET`name'_6REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_all /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOSNET`name'_6REB_all	
	esttab statOOSNET`name'_6REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_R /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOSNET`name'_6REB_R
    }		
	
	* DYNAMIC equation
	gmm (rx`name'within - {bdyn}*fp`name'within), instruments(fp`name'within, noconstant) ///
	winitial(identity) wmatrix(hac nwest `lag')
	estimates store dynOOSNET`name'_6REB
	mat V[2,2] = e(V)		
	reg rx`name'within fp`name'within, noconstant robust
	estimates store dynOOSrobNET`name'_6REB
	mat ESSdyn = e(mss)	
	{/* MT Adjustment: STACKED*/
	replace v = fp`name'within^2
	sum v if time>=cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab dynOOSNET`name'_6REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_all /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo dynOOSNET`name'_6REB_all
	esttab dynOOSNET`name'_6REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_R /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo dynOOSNET`name'_6REB_R
    }
	
	* DOLLAR equation
	local dk = 2*(`lag' - 12)
	ivreg2 drx`name't dfp`name't _Irebal_*, cluster(time) dkraay(`dk')
	mat V  = e(V)
	mat dol_v = V[1,1]	
	estimates store dolOOSNET`name'_6REB
	*reg drx`name't dfp`name't _Irebal_*, cluster(time)
	mat ESSdol = e(mss)
	
	mat CT2 = (CT2, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
	mat FPP2 = (FPP2,ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))	
	
	* CT equation 
	gmm (eq1: rx`name'hml - {btrad}*fp`name'hml), instruments(eq1: fp`name'hml, noconstant) ///
	winitial(identity) wmatrix(hac nwest `lag')
	estimates store tradOOSNET`name'_6REB
	reg rx`name'hml fp`name'hml, noconstant robust
	estimates store tradOOSrobNET`name'_6REB
	
	* FPP equation
	gmm (eq1: rx`name'fpp - {afpp} - {afpp2}*_Irebal_2 - {afpp3}*_Irebal_3 - ///
	{afpp4}*_Irebal_4 - {afpp5}*_Irebal_5 - ///
	{afpp6}*_Irebal_6 - {bfpp}*fp`name'fpp), ///
	instruments(eq1: fp`name'fpp _Irebal_2 _Irebal_3 _Irebal_4 _Irebal_5 _Irebal_6) ///
	winitial(identity) wmatrix(hac nwest `lag')
	estimates store fppOOSNET`name'_6REB
	mat N2[`idx',1] = e(N)
	local idx = `idx' + 1
	mat b = e(b)
	mat b = b[1,7]
	mat vfpp = e(V)
	mat vfpp = vfpp[7,7]
	{/* MT Adjustment*/
	replace v = fp`name'fpp^2
	sum v if time>=cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = vfpp + b[1,1]^2/`r(sum)'*vfpi_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = vfpp + b[1,1]^2/`r(sum)'*vfpi_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab fppOOSNET`name'_6REB, se nostar
	mat c = r(coefs)
	mat c[7,2] = seMT_all /* CORRECTION */
	mat b = c[1..7,1]'
	mat se =  c[1..7,2]'
	ereturn post b
	quietly estadd matrix se
	eststo fppOOSNET`name'_6REB_all
	esttab fppOOSNET`name'_6REB, se nostar
	mat c = r(coefs)
	mat c[7,2] = seMT_R /* CORRECTION */
	mat b = c[1..7,1]'
	mat se =  c[1..7,2]'
	ereturn post b
	quietly estadd matrix se
	eststo fppOOSNET`name'_6REB_R	
    }	
	
	qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drx`name'i dfp`name'i rx`name'within fp`name'within
	estimates store ESS_CT_6REBNET`name'_boot

	qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2_xREB drx`name't dfp`name't i.rebal rx`name'within fp`name'within 
	estimates store ESS_FPP_6REBNET`name'_boot	
	
}

// SCENARIO 7: DOLdollar SAMPLE, 12 Rebalances:	Jun86,88,90,92,94,96,98,00,02,04,06,08				

* Read data into memory
use "Input/Data/DOLdollar_BIG_ALLfwd_clean.dta", replace 

gen rebal=1 if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<341 & time>=317))

replace rebal=2 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<365 & time>=341))

replace rebal=3 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<389 & time>=365))

replace rebal=4 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<413 & time>=389))

replace rebal=5 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<437 & time>=413))

replace rebal=6 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<461 & time>=437))

replace rebal=7 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<485 & time>=461))

replace rebal=8 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<509 & time>=485))

replace rebal=9 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<533 & time>=509))

replace rebal=10 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<557 & time>=533))

replace rebal=11 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<581 & time>=557))

replace rebal=12 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time>=581)

gen pre1=1 if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<=317))

gen pre2=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=341))

gen pre3=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=365))

gen pre4=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=389))

gen pre5=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=413))

gen pre6=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<=437))

gen pre7=1 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<=461))

gen pre8=1 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=485))

gen pre9=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=509))

gen pre10=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=533))

gen pre11=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=557))

gen pre12=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time<=581)



xtset countriesnum time

save "Temp/12REBdata.dta", replace

* IN SAMPLE ANALYSIS

keep if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<341 & time>=317)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<365 & time>=341)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<389 & time>=365)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<413 & time>=389)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<437 & time>=413)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<461 & time>=437)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<485 & time>=461)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<509 & time>=485)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<533 & time>=509)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<557 & time>=533)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<581 & time>=557)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time>=581)


* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

egen avgfp1m = mean(fp1m) if fp1m!=., by(countries rebal)

* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=. & rebal!=., by(time)
egen rxi = mean(rx1m1) if rx1m1!=., by(countries rebal)
egen rx = mean(rxi) if rxi!=.  & rebal!=., by(rebal)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

rename avgfp1m fpi
egen fpt = mean(fp1m) if fp1m!=., by(time)
egen fp = mean(fpi) if fpi!=.  & rebal!=., by(rebal)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

* RUN REGRESSIONS JOINTLY

* STATIC equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statIN_12REB
mat ESSstat = e(mss)

* DYNAMIC equation
gmm (eq1: rxwithin - {bdyn}*fpwithin), instruments(eq1: fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynIN_12REB
reg rxwithin fpwithin, noconstant robust
mat ESSdyn = e(mss)

* DOLLAR equation
ivreg2 drxt dfpt, cluster(time) dkraay(0) noconstant
estimates store dolIN_12REB
reg drxt dfpt, cluster(time)
mat ESSdol = e(mss)

* CT equation
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradIN_12REB

* FPP equation
gmm (eq1: rxfpp - {bfpp}*fpfpp), instruments(eq1: fpfpp, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store fppIN_12REB

* ESS Static T & ESS Dollar T
mat CT2_in  = (CT2_in, ESSstat[1,1] / (ESSstat[1,1] + ESSdyn[1,1]))
mat FPP2_in = (FPP2_in, ESSdol[1,1]  / (ESSdol[1,1]  + ESSdyn[1,1]))

* Test
reg rxfpp dfpt fpwithin, noconstant cluster(time)
test (fpwithin=dfpt)
mat TEST = (TEST, r(p))

keep countries time dfpi dfpt
rename dfpi dfpiIN
rename dfpt dfptIN
sort countries time

merge 1:1 countries time using "Temp/12REBdata.dta"
drop _merge

* STRICTLY OOS ANALYSIS

scalar finish = 604

scalar cut12 = 581
scalar cut11 = 557
scalar cut10 = 533
scalar cut9 = 509
scalar cut8 = 485
scalar cut7 = 461
scalar cut6 = 437
scalar cut5 = 413
scalar cut4 = 389
scalar cut3 = 365
scalar cut2 = 341
scalar cut1 = 317

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BEFORE each rebalance

* rebal==1: create avgfp
gen fp1mtemp = fp1m if time<=cut1
egen avgfp1m = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi = mean(rx1m1) if rebal==1, by(countries)

* rebal==2: create avgfp
replace fp1mtemp = fp1m if time<=cut2
egen avgfp1m2 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi2 = mean(rx1m1) if rebal==2, by(countries)
replace avgfp1m = avgfp1m2 if rebal==2
replace rxi= rxi2 if rebal==2

* rebal==3: create avgfp
replace fp1mtemp = fp1m if time<=cut3
egen avgfp1m3 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi3 = mean(rx1m1) if rebal==3, by(countries)
replace avgfp1m = avgfp1m3 if rebal==3
replace rxi= rxi3 if rebal==3

* rebal==4: create avgfp
replace fp1mtemp = fp1m if time<=cut4
egen avgfp1m4 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi4 = mean(rx1m1) if rebal==4, by(countries)
replace avgfp1m = avgfp1m4 if rebal==4
replace rxi= rxi4 if rebal==4

* rebal==5: create avgfp
replace fp1mtemp = fp1m if time<=cut5
egen avgfp1m5 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi5 = mean(rx1m1) if rebal==5, by(countries)
replace avgfp1m = avgfp1m5 if rebal==5
replace rxi= rxi5 if rebal==5

* rebal==6: create avgfp
replace fp1mtemp = fp1m if time<=cut6
egen avgfp1m6 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi6 = mean(rx1m1) if rebal==6, by(countries)
replace avgfp1m = avgfp1m6 if rebal==6
replace rxi= rxi6 if rebal==6

* rebal==7: create avgfp
replace fp1mtemp = fp1m if time<=cut7
egen avgfp1m7 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi7 = mean(rx1m1) if rebal==7, by(countries)
replace avgfp1m = avgfp1m7 if rebal==7
replace rxi= rxi7 if rebal==7

* rebal==8: create avgfp
replace fp1mtemp = fp1m if time<=cut8
egen avgfp1m8 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi8 = mean(rx1m1) if rebal==8, by(countries)
replace avgfp1m = avgfp1m8 if rebal==8
replace rxi= rxi8 if rebal==8

* rebal==9: create avgfp
replace fp1mtemp = fp1m if time<=cut9
egen avgfp1m9 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi9 = mean(rx1m1) if rebal==9, by(countries)
replace avgfp1m = avgfp1m9 if rebal==9
replace rxi= rxi9 if rebal==9

* rebal==10: create avgfp
replace fp1mtemp = fp1m if time<=cut10
egen avgfp1m10 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi10 = mean(rx1m1) if rebal==10, by(countries)
replace avgfp1m = avgfp1m10 if rebal==10
replace rxi= rxi10 if rebal==10

* rebal==11: create avgfp
replace fp1mtemp = fp1m if time<=cut11
egen avgfp1m11 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi11 = mean(rx1m1) if rebal==11, by(countries)
replace avgfp1m = avgfp1m11 if rebal==11
replace rxi= rxi11 if rebal==11

* rebal==12: create avgfp
replace fp1mtemp = fp1m if time<=cut12
egen avgfp1m12 = mean(fp1mtemp) if fp1m!=., by(countries)
egen rxi12 = mean(rx1m1) if rebal==12, by(countries)
replace avgfp1m = avgfp1m12 if rebal==12
replace rxi= rxi12 if rebal==12

rename avgfp1m fpi
egen fp = mean(fpi) if fpi!=.  & rebal!=., by(rebal)
egen rx = mean(rxi) if rxi!=.  & rebal!=., by(rebal)

* GET V(fpi): 1) using all pre-sample (_all); 2) per rebalance (_pr) and averaging

preserve

keep if pre1!=. | pre2!=. | pre3!=. | pre4!=. | pre5!=. | pre6!=. | pre7!=. | pre8!=. | pre9!=. | pre10!=. | pre11!=. | pre12!=.

* 1) ALL PRE-SAMPLE
xi i.countriesnum, noomit 
* fpihat
reg fp1m _Icount*, noconstant
mat vfpi_all = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)

restore

mat vfpi_r = J(12,1,.)
* 2) PER REBALANCE
forval j=1(1)12 {
	preserve
	keep if pre`j'==1
	xi i.countriesnum, noomit 
	reg fp1m _Icount*, noconstant
	mat vfpi_r[`j',1] = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
	restore
}
* V_R(fpihat)
mat vfpi_R = J(1,12,1)*vfpi_r/12

* Generate Variables

keep if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<341 & time>=317)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<365 & time>=341)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<389 & time>=365)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<413 & time>=389)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<437 & time>=413)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<461 & time>=437)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<485 & time>=461)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<509 & time>=485)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<533 & time>=509)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<557 & time>=533)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<581 & time>=557)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time>=581)


* Generate averages: time and country level
egen rxt = mean(rx1m1) if rx1m1!=. & rebal!=., by(time)

gen drxi = rxi - rx
gen rxhml = rx1m1 - rxt
gen rxwithin = rxhml - drxi
gen rxfpp = rx1m1 - rxi
gen drxt = rxt - rx

egen fpt = mean(fp1m) if fp1m!=. & rebal!=., by(time)

gen fphml = fp1m - fpt
gen dfpi = fpi - fp
gen fpwithin = fphml - dfpi
gen fpfpp = fp1m - fpi
gen dfpt = fpt - fp

* Generate all ds variables
egen dsi = mean(ds1m), by(countries)
egen dst = mean(ds1m) if ds1m!=., by(time)
egen ds = mean(dsi) if dsi!=., by(time)

gen ddsi = dsi - ds
gen dshml = ds1m - dst
gen dswithin = dshml - ddsi
gen dsfpp = ds1m - dsi
gen ddst = dst - ds

gen error = dfpiIN-dfpi
gen fpwithinIN = fpwithin + dfpi - dfpiIN

* UNIVARIATE REGRESSIONS & ESS RATIOS

xi i.rebal

mat V = J(3,3,0)
mat B = J(3,1,.)

gmm (rx1m1 - {b}*fp1m - {a}), instruments(fp1m) winitial(identity) wmatrix(hac nwest 12)
estimates store betaOOS_12REB
mat betaN2[5,1] = e(N)

* STATIC equation
reg drxi dfpi, noconstant cluster(countries)
estimates store statOOS_12REB
mat V[1,1] = e(V)
mat B[1,1] = e(b)
mat ESSstat = e(mss)
predict fit_stat, xb
{/* MT Adjustment*/
g v = dfpi^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
mat stat_v = VMT_all[1,1]
* 2) PER REBALANCE
mat VMT_R = V[1,1] + _b[dfpi]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab statOOS_12REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_all /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo statOOS_12REB_all
esttab statOOS_12REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_R /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo statOOS_12REB_R
}

* DYNAMIC equation
gmm (rxwithin - {bdyn}*fpwithin), instruments(fpwithin, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store dynOOS_12REB
mat V[2,2] = e(V)
mat B[2,1] = e(b)
reg rxwithin fpwithin, noconstant robust
estimates store dynOOSrob_12REB
mat ESSdyn = e(mss)
predict fit_dyn, xb
{/* MT Adjustment: STACKED*/
replace v = fpwithin^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
mat dyn_v = VMT_all[1,1]
* 2) PER REBALANCE
mat VMT_R = V[2,2] + _b[fpwithin]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab dynOOS_12REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_all /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo dynOOS_12REB_all
esttab dynOOS_12REB, se nostar
mat c = r(coefs)
mat b = c[1,1]
mat se = seMT_R /* CORRECTION */
ereturn post b
quietly estadd matrix se
eststo dynOOS_12REB_R
}

* DOLLAR equation
xi: ivreg2 drxt dfpt i.rebal, cluster(time) dkraay(0)
estimates store dolOOS_12REB
mat v = e(V)
mat V[3,3] = v[1,1]
mat dol_v = v[1,1]
mat bb = e(b)
mat B[3,1] = bb[1,1]
mat adol = bb[1,2]
mat ESSdol = e(mss)
predict fit_dol, xb

mat CT2 = (CT2, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
mat FPP2 = (FPP2,ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))

qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drxi dfpi rxwithin fpwithin
estimates store ESS_CT_12REB_boot

qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2_xREB  drxt dfpt i.rebal rxwithin fpwithin
estimates store ESS_FPP_12REB_boot

* CT MULTIPLE equation by running OLS
gmm (eq1: rxhml - {btrad}*fphml), instruments(eq1: fphml, noconstant) winitial(identity) wmatrix(hac nwest 12)
estimates store tradOOS_12REB
reg rxhml fphml, noconstant robust
estimates store tradOOSrob_12REB

* FPP equation
gmm (eq1: rxfpp - {afpp} - {afpp2}*_Irebal_2 - {afpp3}*_Irebal_3 - {afpp4}*_Irebal_4 - {afpp5}*_Irebal_5 - ///
{afpp6}*_Irebal_6 - {afpp7}*_Irebal_7 - {afpp8}*_Irebal_8 - {afpp9}*_Irebal_9  - {afpp10}*_Irebal_10 - ///
{afpp11}*_Irebal_11 - {afpp12}*_Irebal_12 - {bfpp}*fpfpp), instruments(eq1: fpfpp _Irebal_2 _Irebal_3 _Irebal_4 _Irebal_5 _Irebal_6 ///
_Irebal_7 _Irebal_8 _Irebal_9 _Irebal_10 _Irebal_11 _Irebal_12) ///
winitial(identity) wmatrix(hac nwest 12)
estimates store fppOOS_12REB
mat b = e(b)
mat b = b[1,13]
mat vfpp = e(V)
mat vfpp = vfpp[13,13]
/* MT Adjustment*/
replace v = fpfpp^2
sum v if time>=cut1
* 1) ALL PRE-SAMPLE
mat VMT_all = vfpp + b[1,1]^2/`r(sum)'*vfpi_all[1,1]
mat seMT_all = sqrt(VMT_all[1,1])
* 2) PER REBALANCE
mat VMT_R = vfpp + b[1,1]^2/`r(sum)'*vfpi_R[1,1]
mat seMT_R = sqrt(VMT_R[1,1])
esttab fppOOS_12REB, se nostar
mat c = r(coefs)
mat c[13,2] = seMT_all /* CORRECTION */
mat b = c[1..13,1]'
mat se =  c[1..13,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_12REB_all
esttab fppOOS_12REB, se nostar
mat c = r(coefs)
mat c[13,2] = seMT_R /* CORRECTION */
mat b = c[1..13,1]'
mat se =  c[1..13,2]'
ereturn post b
quietly estadd matrix se
eststo fppOOS_12REB_R
xi: reg rxfpp fpfpp i.rebal, robust
estimates store fppOOSrob_12REB
mat N2[5,1] = e(N)

// SCENARIO 8: DOLdollar SAMPLE, 12 Rebalances:	Jun86,88,90,92,94,96,98,00,02,04,06,08	, with Bid-Ask Spreads

* Read data into memory
use "Input/Data/DOLdollar_BIG_ALLfwdnet_clean.dta", replace 
g date = dofm(time) 
g year = year(date)
gen rebal=1 if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<341 & time>=317))

replace rebal=2 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<365 & time>=341))

replace rebal=3 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<389 & time>=365))

replace rebal=4 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<413 & time>=389))

replace rebal=5 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<437 & time>=413))

replace rebal=6 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<461 & time>=437))

replace rebal=7 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<485 & time>=461))

replace rebal=8 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<509 & time>=485))

replace rebal=9 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<533 & time>=509))

replace rebal=10 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<557 & time>=533))

replace rebal=11 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<581 & time>=557))

replace rebal=12 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time>=581)

gen pre1=1 if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<=317))

gen pre2=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=341))

gen pre3=1 if ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=365))

gen pre4=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=389))

gen pre5=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<=413))

gen pre6=1 if ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<=437))

gen pre7=1 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<=461))

gen pre8=1 if ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=485))

gen pre9=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=509))

gen pre10=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=533))

gen pre11=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<=557))

gen pre12=1 if ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time<=581)



xtset countriesnum time

* GENERATE VARIABLES NEEDED FOR THE REGRESSIONS

* BUILD NET RETURNS
foreach name in "1m" "2m" "3m" "6m"  {
	gen rx`name'it = rxlong`name' 
}

* BUILD NET ER changes
foreach name in "1m" "2m" "3m" "6m"  {
	gen ds`name'it = dslong`name' 
}

* BUILD NET RETURNS: 12m
gen rx1yit = rxlong12m 
gen ds1yit = dslong12m 

* up to time t for each country
gen fp1mtemp = .
gen fp2mtemp = .
gen fp3mtemp = .
gen fp6mtemp = .
gen fp1ytemp = .

gen storefp1mi = .
gen storefp2mi = .
gen storefp3mi = .
gen storefp6mi = .
gen storefp1yi = .

rename fp12mid fp1yid

preserve

keep if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<341 & time>=317)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<365 & time>=341)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<389 & time>=365)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<413 & time>=389)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<437 & time>=413)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<461 & time>=437)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<485 & time>=461)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<509 & time>=485)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<533 & time>=509)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<557 & time>=533)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<581 & time>=557)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time>=581)


foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen fp`name'i = mean(fp`name'id) if fp`name'id!=., by(countries rebal)
}

keep countries time rebal fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries rebal)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(rebal)
	
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)

	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(rebal)
	
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(rebal)

	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}		

* RUN REGRESSIONS JOINTLY
local idx = 6
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
		local lag = 12
	}
	else if "`name'"=="6m" {
		local lag = 18
	}
	else if "`name'"=="1y" {
		local lag = 24
	}
	
	gmm (rx`name'it - {b}*fp`name'id - {a}), instruments(fp`name'id) winitial(identity) wmatrix(hac nwest `lag')
	estimates store betaNET`name'_12REB
	mat betaN2[`idx',1] = e(N)
	local idx = `idx' + 1
}

restore

* STRICTLY OOS WITH BID-ASK SPREADS

foreach name in "1m" "6m" "1y" /* "2m" "3m" */ {
	* rebal==1
	replace fp`name'temp = fp`name'id if time<=cut1
	egen avgfp`name' = mean(fp`name'temp) if fp`name'id!=., by(countries)
	* rebal==2
	replace fp`name'temp = fp`name'id if time<=cut2
	egen avgfp`name'2 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'2 if rebal==2				
	* rebal==3
	replace fp`name'temp = fp`name'id if time<=cut3
	egen avgfp`name'3 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'3 if rebal==3
	* rebal==4
	replace fp`name'temp = fp`name'id if time<=cut4
	egen avgfp`name'4 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'4 if rebal==4				
	* rebal==5
	replace fp`name'temp = fp`name'id if time<=cut5
	egen avgfp`name'5 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'5 if rebal==5
	* rebal==6
	replace fp`name'temp = fp`name'id if time<=cut6
	egen avgfp`name'6 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'6 if rebal==6
	* rebal==7: create avgfp
	replace fp`name'temp = fp`name'id if time<=cut7
	egen avgfp`name'7 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'7 if rebal==7
	* rebal==8: create avgfp
	replace fp`name'temp = fp`name'id if time<=cut8
	egen avgfp`name'8 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'8 if rebal==8
	* rebal==9: create avgfp
	replace fp`name'temp = fp`name'id if time<=cut9
	egen avgfp`name'9 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'9 if rebal==9
	* rebal==10: create avgfp
	replace fp`name'temp = fp`name'id if time<=cut10
	egen avgfp`name'10 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'10 if rebal==10
	* rebal==11: create avgfp
	replace fp`name'temp = fp`name'id if time<=cut11
	egen avgfp`name'11 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'11 if rebal==11
	* rebal==12: create avgfp
	replace fp`name'temp = fp`name'id if time<=cut12
	egen avgfp`name'12 = mean(fp`name'temp) if fp`name'id!=., by(countries)
	replace avgfp`name' = avgfp`name'12 if rebal==12
	
	rename avgfp`name' fp`name'i
	
	*-------------------------------------------------------------------------------------
	* GET V(fpi): 1) using all pre-sample (_all); 2) per rebalance (_pr) and averaging
	*-------------------------------------------------------------------------------------
	preserve
	keep if pre1!=. | pre2!=. | pre3!=. | pre4!=. | pre5!=. | pre6!=. | ///
	pre7!=. | pre8!=. | pre9!=. | pre10!=. | pre11!=. | pre12!=.
	* 1) ALL PRE-SAMPLE
	xi i.countriesnum, noomit 
	* fpihat
	reg fp`name'id _Icount*, noconstant
	mat vfpi`name'_all = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
	restore

	mat vfpi`name'_r = J(12,1,.)
	* 2) PER REBALANCE
	forval j=1(1)12 {
		preserve
		keep if pre`j'==1
		if "`name'"=="1y" {
			drop if pre6==1 & countries=="C39"
		}
		xi i.countriesnum, noomit 
		reg fp`name'id _Icount*, noconstant
		mat vfpi`name'_r[`j',1] = J(1,e(rank),1)*e(V)*J(e(rank),1,1)/e(rank)
		restore
		}
	* V_R(fpihat)
	mat vfpi`name'_R = J(1,12,1)*vfpi`name'_r/12	
}

keep countries time rebal fp1mid fp2mid fp3mid fp6mid fp1yid countriesnum rx1mit rx2mit rx3mit rx6mit rx1yit *i ds*it year

* Generate Variables

keep if ((countries=="C3" | countries=="C5" | countries=="C7" | countries=="C13" | ///
countries=="C15" | countries=="C22" | countries=="C41") & (time<341 & time>=317)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<365 & time>=341)) | ///
 ((countries=="C2" | countries=="C3" | countries=="C4" | countries=="C5" | ///
countries=="C7" | countries=="C8" | countries=="C13" | countries=="C15" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<389 & time>=365)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<413 & time>=389)) | ///
((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" | countries=="C41" | countries=="C42") & (time<437 & time>=413)) | ///
 ((countries=="C1" | countries=="C2" | countries=="C3" | countries=="C4" | ///
countries=="C5" | countries=="C7" | countries=="C8" | countries=="C9" | countries=="C10" | ///
countries=="C13" | countries=="C15" | countries=="C18" | countries=="C21" | ///
countries=="C22" | countries=="C24" | countries=="C26" | countries=="C27" | countries=="C28" | countries=="C29" | ///
countries=="C33" | countries=="C34" | countries=="C35" |  countries=="C39" | countries=="C41" | countries=="C42") & (time<461 & time>=437)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C39" | countries=="C41" | countries=="C42") & (time<485 & time>=461)) | ///
 ((countries=="C2" | countries=="C4" | ///
countries=="C5" | countries=="C8" | countries=="C15" | countries=="C22" | countries=="C24" | ///
countries=="C28" | countries=="C29" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<509 & time>=485)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<533 & time>=509)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C24" | ///
countries=="C25" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<557 & time>=533)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C19" | countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C36" | countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & (time<581 & time>=557)) | ///
 ((countries=="C2" | countries=="C4" | countries=="C5" | countries=="C6" | ///
countries=="C8" | countries=="C11" | countries=="C15" | countries=="C16" | countries=="C17" | countries=="C19" | countries=="C20" | ///
countries=="C22" | countries=="C23" | countries=="C24" | ///
countries=="C25" | countries=="C26" | countries=="C28" | countries=="C29" | countries=="C30" | countries=="C31" | countries=="C33" | countries=="C34" | countries=="C35" | ///
countries=="C37" | countries=="C38" | countries=="C39" | countries=="C40" | countries=="C41" | countries=="C42") & time>=581)


xi i.rebal
gen v=.
foreach name in "1m" "2m" "3m" "6m" "1y"  {
	egen rx`name'i = mean(rx`name'it) if rx`name'it!=., by(countries rebal)
	egen fp`name' = mean(fp`name'i) if fp`name'i!=., by(rebal)
	egen fp`name't = mean(fp`name'id) if fp`name'id!=., by(time)
	gen fp`name'hml = fp`name'id - fp`name't
	gen dfp`name'i = fp`name'i - fp`name'
	gen fp`name'within = fp`name'hml - dfp`name'i
	gen fp`name'fpp = fp`name'id - fp`name'i
	gen dfp`name't = fp`name't - fp`name'	
	
	* Generate averages: time and country level
	egen rx`name't = mean(rx`name'it) if rx`name'it!=., by(time)
	egen rx`name' = mean(rx`name'i) if rx`name'i!=., by(rebal)
	gen drx`name'i = rx`name'i - rx`name'
	gen rx`name'hml = rx`name'it - rx`name't
	gen rx`name'within = rx`name'hml - drx`name'i
	gen rx`name'fpp = rx`name'it - rx`name'i
	gen drx`name't = rx`name't - rx`name'
	
	* Generate all ds variables
	egen ds`name'i = mean(ds`name'it), by(countries)
	egen ds`name't = mean(ds`name'it) if ds`name'it!=., by(time)
	egen ds`name' = mean(ds`name'i) if ds`name'i!=., by(rebal)
	gen dds`name'i = ds`name'i - ds`name'
	gen ds`name'hml = ds`name'it - ds`name't
	gen ds`name'within = ds`name'hml - dds`name'i
	gen ds`name'fpp = ds`name'it - ds`name'i
	gen dds`name't = ds`name't - ds`name'
}

* RUN REGRESSIONS JOINTLY
local idx = 6
foreach name in "1m" "6m" "1y"  {
	if "`name'"=="1m" {
	local lag = 12
	}
	else if "`name'"=="6m" {
	local lag = 18
	}
	else if "`name'"=="1y" {
	local lag = 24
	}
	mat V = J(3,3,0)
	mat B = J(3,1,.)	

	* STATIC equation	
	reg drx`name'i dfp`name'i, cluster(countries) noconstant
	estimates store statOOSNET`name'_12REB
	mat V[1,1] = e(V)	
	mat ESSstat = e(mss)
	{/* MT Adjustment: STACKED*/
	* VAR(dfpi)
	replace v = dfp`name'i^2
	sum v if time>=cut1	
	* 1) ALL PRE-SAMPLE
	mat VMT_all = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])	
	* 2) PER REBALANCE
	mat VMT_R = V[1,1] + _b[dfp`name'i]^2/`r(sum)'*vfpi`name'_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab statOOSNET`name'_12REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_all /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOSNET`name'_12REB_all	
	esttab statOOSNET`name'_12REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_R /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo statOOSNET`name'_12REB_R
	}
	
	* DYNAMIC equation
	gmm (rx`name'within - {bdyn}*fp`name'within), instruments(fp`name'within, noconstant) ///
	winitial(identity) wmatrix(hac nwest `lag')
	estimates store dynOOSNET`name'_12REB
	mat V[2,2] = e(V)			
	reg rx`name'within fp`name'within, noconstant robust
	estimates store dynOOSrobNET`name'_12REB
	mat ESSdyn = e(mss)	
	{/* MT Adjustment: STACKED*/
	replace v = fp`name'within^2
	sum v if time>=cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = V[2,2] + _b[fp`name'within]^2/`r(sum)'*vfpi_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab dynOOSNET`name'_12REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_all /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo dynOOSNET`name'_12REB_all
	esttab dynOOSNET`name'_12REB, se nostar
	mat c = r(coefs)
	mat b = c[1,1]
	mat se = seMT_R /* CORRECTION */
	ereturn post b
	quietly estadd matrix se
	eststo dynOOSNET`name'_12REB_R
	}	

	* DOLLAR equation
	local dk = 2*(`lag' - 12)
	ivreg2 drx`name't dfp`name't _Irebal_*, cluster(time) dkraay(`dk')	
	mat V  = e(V)
	mat dol_v = V[1,1]
	estimates store dolOOSNET`name'_12REB
	*reg drx`name't dfp`name't _Irebal_*, cluster(time)
	mat ESSdol = e(mss)
	
	mat CT2 = (CT2, ESSstat[1,1]/(ESSstat[1,1] + ESSdyn[1,1]))
	mat FPP2 = (FPP2,ESSdol[1,1]/(ESSdol[1,1] + ESSdyn[1,1]))	

	* CT MULTIPLE equation by running OLS
	gmm (eq1: rx`name'hml - {btrad}*fp`name'hml), instruments(eq1: fp`name'hml, noconstant) ///
	winitial(identity) wmatrix(hac nwest `lag')
	estimates store tradOOSNET`name'_12REB
	reg rx`name'hml fp`name'hml, noconstant robust
	estimates store tradOOSrobNET`name'_12REB
	
	* FPP equation
	gmm (eq1: rx`name'fpp - {afpp} - {afpp2}*_Irebal_2 - {afpp3}*_Irebal_3 - {afpp4}*_Irebal_4 - {afpp5}*_Irebal_5 - ///
	{afpp6}*_Irebal_6  - {afpp7}*_Irebal_7 - {afpp8}*_Irebal_8 - {afpp9}*_Irebal_9   - {afpp10}*_Irebal_10 - ///
	{afpp11}*_Irebal_11 - {afpp12}*_Irebal_12 - {bfpp}*fp`name'fpp), ///
	instruments(eq1: fp`name'fpp _Irebal_2 _Irebal_3 _Irebal_4 _Irebal_5 _Irebal_6 ///
	_Irebal_7 _Irebal_8 _Irebal_9 _Irebal_10 _Irebal_11 _Irebal_12) ///
	winitial(identity) wmatrix(hac nwest `lag')
	estimates store fppOOSNET`name'_12REB
	mat N2[`idx',1] = e(N)
	local idx = `idx' + 1
	mat b = e(b)
	mat b = b[1,13]
	mat vfpp = e(V)
	mat vfpp = vfpp[13,13]			
	{/* MT Adjustment*/
	replace v = fp`name'fpp^2
	sum v if time>=cut1
	* 1) ALL PRE-SAMPLE
	mat VMT_all = vfpp + b[1,1]^2/`r(sum)'*vfpi_all[1,1]
	mat seMT_all = sqrt(VMT_all[1,1])
	* 2) PER REBALANCE
	mat VMT_R = vfpp + b[1,1]^2/`r(sum)'*vfpi_R[1,1]
	mat seMT_R = sqrt(VMT_R[1,1])
	esttab fppOOSNET`name'_12REB, se nostar
	mat c = r(coefs)
	mat c[13,2] = seMT_all /* CORRECTION */
	mat b = c[1..13,1]'
	mat se =  c[1..13,2]'
	ereturn post b
	quietly estadd matrix se
	eststo fppOOSNET`name'_12REB_all
	esttab fppOOSNET`name'_12REB, se nostar
	mat c = r(coefs)
	mat c[13,2] = seMT_R /* CORRECTION */
	mat b = c[1..13,1]'
	mat se =  c[1..13,2]'
	ereturn post b
	quietly estadd matrix se
	eststo fppOOSNET`name'_12REB_R
    }		
	
	qui bootstrap CT_ratio =ESSCT , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio1 drx`name'i dfp`name'i rx`name'within fp`name'within
	estimates store ESS_CT_12REBNET`name'_boot

	qui bootstrap FPP_ratio =ESSFPP , cluster(year) idcluster(years) group(time) reps(`K') seed(12345): ESSratio2_xREB  drx`name't dfp`name't i.rebal rx`name'within fp`name'within 
	estimates store ESS_FPP_12REBNET`name'_boot	
	
}


}

//  Output to Table 3

mat CT  = CT * 100
mat CT2  = CT2 * 100

mat FPP = FPP * 100
mat FPP2 = FPP2 * 100

estout statOOS_95 statOOSNET*_95 statOOS_3REB_all statOOSNET*_3REB_all using "./Input/tex_figs/OOScoeffs_main1.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(dfpi "Static T: \(\beta^{stat}\)") ///
rename(c1 dfpi dfp1mi dfpi dfp2mi dfpi dfp3mi dfpi dfp6mi dfpi dfp1yi dfpi) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) eqlabels(none) unstack equations(1) label ///
extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)
estout dynOOS_95 dynOOSNET*_95 dynOOS_3REB_all dynOOSNET*_3REB_all using "./Input/tex_figs/OOScoeffs_main1.tex", append style(tex) ///
ml( ,none) collabels(, none) varlabels(_cons "Dynamic T: \(\beta^{dyn}\)") rename(c1 _cons) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) eqlabels(none)  label extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)
estout dolOOS_95 dolOOSNET*_95 dolOOS_3REB dolOOSNET*_3REB using "./Input/tex_figs/OOScoeffs_main1.tex", append style(tex) ///
ml( ,none)  collabels(, none) ///
rename(/*c1 dfpt*/ dfp1mt dfpt dfp6mt dfpt dfp1yt dfpt) varlabels(dfpt "Dollar T: \(\beta^{dol}\)") ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3) label(Rui))*/) eqlabels(none) drop(_Irebal_* _cons) label ///
extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout tradOOS_95 tradOOSNET*_95 tradOOS_3REB tradOOSNET*_3REB using "./Input/tex_figs/tradOOScoeffs_main1.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(btrad:_cons "Carry Trade: \(\beta^{ct}\)") ///
cells(b(star fmt(2)) se(par fmt(2))) eqlabels(none) label  extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout fppOOS_95 fppOOSNET*_95 fppOOS_3REB_all fppOOSNET*_3REB_all using "./Input/tex_figs/fppOOScoeffs_main1.tex", replace style(tex) ///
ml( ,none) collabels(, none) ///
varlabels(bfpp:_cons "Forward Premium T: \(\beta^{fpp}\)") /*rename(c1 _cons)*/ drop(afpp:_cons afpp2:_cons afpp3:_cons) ///
cells(b(star fmt(2)) se(par fmt(2))) eqlabels(none) label extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout matrix(CT, fmt(%2.0f)) using "./Input/tex_figs/ESS_CT_main1.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\% ESS Static T" ) label extracols(5)

estout matrix(FPP, fmt(%2.0f)) using "./Input/tex_figs/ESS_FPP_main1.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\% ESS Dollar T" ) label extracols(5)

estout statOOS_6REB_all statOOSNET*_6REB_all statOOS_12REB_all statOOSNET*_12REB_all ///
using "./Input/tex_figs/OOScoeffs_main2stat.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(dfpi "Static T: \(\beta^{stat}\)") ///
rename(c1 dfpi dfp1mi dfpi dfp2mi dfpi dfp3mi dfpi dfp6mi dfpi dfp1yi dfpi) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) ///
eqlabels(none) unstack equations(1) label extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout dynOOS_6REB_all dynOOSNET*_6REB_all dynOOS_12REB_all dynOOSNET*_12REB_all ///
using "./Input/tex_figs/OOScoeffs_main2dyn.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(_cons "Dynamic T: \(\beta^{dyn}\)") rename(c1 _cons) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) ///
eqlabels(none) label extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout dolOOS_6REB dolOOSNET*_6REB dolOOS_12REB dolOOSNET*_12REB ///
using "./Input/tex_figs/OOScoeffs_main2dol.tex", replace style(tex) ml( ,none) collabels(, none) ///
rename(dfp1mt dfpt dfp6mt dfpt dfp1yt dfpt) varlabels(dfpt "Dollar T: \(\beta^{dol}\)") ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) ///
eqlabels(none) drop(_Irebal_* _cons) label extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout tradOOS_6REB tradOOSNET*_6REB tradOOS_12REB tradOOSNET*_12REB ///
using "./Input/tex_figs/tradOOScoeffs_main2.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(btrad:_cons "Carry Trade: \(\beta^{ct}\)") ///
cells(b(star fmt(2)) se(par fmt(2))) eqlabels(none) label  extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout fppOOS_6REB_all fppOOSNET*_6REB_all fppOOS_12REB_all fppOOSNET*_12REB_all ///
using "./Input/tex_figs/fppOOScoeffs_main2.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(bfpp:_cons "Forward Premium T: \(\beta^{fpp}\)") drop(afpp:_cons afpp2:_cons afpp3:_cons afpp4:_cons afpp5:_cons afpp6:_cons ///
 afpp7:_cons afpp8:_cons afpp9:_cons afpp10:_cons afpp11:_cons afpp12:_cons) ///
cells(b(star fmt(2)) se(par fmt(2))) eqlabels(none) label extracols(5) starlevels(* 0.1 ** 0.05 *** 0.01)

estout matrix(CT2, fmt(%2.0f)) using "./Input/tex_figs/ESS_CT_main2.tex", replace ///
style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\% ESS Static T" ) label extracols(5)

estout matrix(FPP2, fmt(%2.0f)) using "./Input/tex_figs/ESS_FPP_main2.tex", replace ///
style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\% ESS Dollar T" ) label extracols(5)

estout ESS_CT_1REB_boot ESS_CT_1REBNET*_boot ESS_CT_3REB_boot ESS_CT_3REBNET*_boot using "./Input/tex_figs/ESS_CT_main1_boot.tex", replace style(tex) ml( ,none) collabels(, none) cells(b(star fmt(0)) se(par fmt(0))) ///
eqlabels(none) unstack equations(1) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(CT_ratio "\% ESS Static T")  extracols(5)

estout ESS_FPP_1REB_boot ESS_FPP_1REBNET*_boot ESS_FPP_3REB_boot ESS_FPP_3REBNET*_boot using "./Input/tex_figs/ESS_FPP_main1_boot.tex", replace style(tex) ml( ,none) collabels(, none) cells(b(star fmt(0)) se(par fmt(0))) ///
eqlabels(none) unstack equations(1) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(FPP_ratio "\% ESS Dollar T")  extracols(5)

estout ESS_CT_6REB_boot ESS_CT_6REBNET*_boot ESS_CT_12REB_boot ESS_CT_12REBNET*_boot using "./Input/tex_figs/ESS_CT_main2_boot.tex", replace style(tex) ml( ,none) collabels(, none) cells(b(star fmt(0)) se(par fmt(0))) ///
eqlabels(none) unstack equations(1) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(CT_ratio "\% ESS Static T")  extracols(5)

estout ESS_FPP_6REB_boot ESS_FPP_6REBNET*_boot ESS_FPP_12REB_boot ESS_FPP_12REBNET*_boot using "./Input/tex_figs/ESS_FPP_main2_boot.tex", replace style(tex) ml( ,none) collabels(, none) cells(b(star fmt(0)) se(par fmt(0))) ///
eqlabels(none) unstack equations(1) label starlevels(* 0.1 ** 0.05 *** 0.01) varlabels(FPP_ratio "\% ESS Dollar T")  extracols(5)

preserve
clear
set obs 1
gen a = " "
replace a = "N" in 1
forval i = 1/9 {
	gen f_`i' = .
	if `i' <= 4 {
		replace f_`i' = N1[`i',1] in 1 
	}
	if `i' >= 6 {
		replace f_`i' = N1[`i'-1,1] in 1 
	}
}
format f_* %9.0f 
ssc install listtex
listtex a f_* using ./Input/tex_figs/N_main1.tex, replace rstyle(tabular) 
restore

preserve
clear
set obs 1
gen a = " "
replace a = "N" in 1
forval i = 1/9 {
	gen f_`i' = .
	if `i' <= 4 {
		replace f_`i' = N2[`i',1] in 1 
	}
	if `i' >= 6 {
		replace f_`i' = N2[`i'-1,1] in 1 
	}
}
format f_* %9.0f 
ssc install listtex
listtex a f_* using ./Input/tex_figs/N_main2.tex, replace rstyle(tabular) 
restore


// Output to Table 4

estout statIN_95 statOOS_95 statIN_3REB statOOS_3REB_all statIN_6REB statOOS_6REB_all statIN_12REB statOOS_12REB_all using "./Input/tex_figs/stat_IN_OOS_4scenarios.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(dfpi "Static Trade") ///
rename(c1 dfpi dfp1mi dfpi dfp2mi dfpi dfp3mi dfpi dfp6mi dfpi dfp1yi dfpi) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) eqlabels(none) unstack equations(1) label starlevels(* 0.1 ** 0.05 *** 0.01)

estout dynIN_95 dynOOS_95 dynIN_3REB dynOOS_3REB_all dynIN_6REB dynOOS_6REB_all dynIN_12REB dynOOS_12REB_all using "./Input/tex_figs/dyn_IN_OOS_4scenarios.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(_cons "Dynamic Trade") rename(c1 _cons) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) eqlabels(none) label starlevels(* 0.1 ** 0.05 *** 0.01)

estout fppIN_95 fppOOS_95 fppIN_3REB fppOOS_3REB_all fppIN_6REB fppOOS_6REB_all fppIN_12REB fppOOS_12REB_all using "./Input/tex_figs/fpp_IN_OOS_4scenarios.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(bfpp:_cons "F.P. Trade") drop(afpp:_cons afpp2:_cons afpp3:_cons afpp4:_cons afpp5:_cons afpp6:_cons ///
afpp7:_cons afpp8:_cons afpp9:_cons afpp10:_cons afpp11:_cons afpp12:_cons) cells(b(star fmt(2)) se(par fmt(2))) eqlabels(none) label starlevels(* 0.1 ** 0.05 *** 0.01)
*/
* build matrix
mat CT_in = CT_in*100
mat CT2_in = CT2_in*100

mat FPP_in = FPP_in*100
mat FPP2_in = FPP2_in*100
 
mat CT_table4 = (CT_in[1,1] , CT[1,1] , CT_in[1,2] , CT[1,5] ,CT2_in[1,2] , CT2[1,1], CT2_in[1,2] , CT2[1,5] )
mat FPP_table4 = (FPP_in[1,1] , FPP[1,1] , FPP_in[1,2] , FPP[1,5] ,FPP2_in[1,2] , FPP2[1,1], FPP2_in[1,2] , FPP2[1,5] )

estout matrix(CT_table4, fmt(%2.0f)) using "./Input/tex_figs/ESS_CT_table4.tex", replace ///
style(tex) ml( ,none) collabels(, none) varlabels(r1 "\% ESS Static T" ) label 
estout matrix(FPP_table4, fmt(%2.0f)) using "./Input/tex_figs/ESS_FPP_table4.tex", replace ///
style(tex) ml( ,none) collabels(, none) varlabels(r1 "\% ESS Dollar T" ) label 

// Output to Table 5

mat CHIsq = (CHIdyn_out \ CHIdol_out \ CHIsame_out )

estout matrix(CHIdyn_out, fmt(%3.2f)) using "./Input/tex_figs/CHIsq_tests.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\(\beta^{dyn} = 0\)" ) label starlevels(* 0.1 ** 0.05 *** 0.01)
estout matrix(CHIdol_out, fmt(%3.2f)) using "./Input/tex_figs/CHIsq_tests.tex", append style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\(\beta^{dol} = 0\)" ) label starlevels(* 0.1 ** 0.05 *** 0.01)
estout matrix(CHIsame_out, fmt(%3.2f)) using "./Input/tex_figs/CHIsq_tests.tex", append style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "\(\beta^{dol}=\beta^{dyn}\)" ) label starlevels(* 0.1 ** 0.05 *** 0.01)

// Output to Table 7

estout dolOOS_95 dolOOS_3REB dolOOS_6REB dolOOS_12REB using "./Input/tex_figs/OOSdynDOL_4scenarios.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(dfpt "\(\beta^{dol}\)") cells(b(star fmt(2)) se(par fmt(2))) drop(_Irebal_* _cons) ///
eqlabels(none) label starlevels(* 0.1 ** 0.05 *** 0.01) 

estout dynIN_95 dynIN_3REB dynIN_6REB dynIN_12REB using "./Input/tex_figs/INdynDOL_4scenarios.tex", replace style(tex) ///
ml( ,none) collabels(, none) varlabels(_cons "$\sum_i\omega_i\beta^{dyn}_i$") rename(c1 _cons) ///
cells(b(star fmt(2)) se(par fmt(2)) /*p(par([ ]) fmt(3))*/) eqlabels(none) label starlevels(* 0.1 ** 0.05 *** 0.01)

estout matrix(TEST, fmt(%3.2f)) using "./Input/tex_figs/INDdynDOL_4scenarios_pval.tex", replace style(tex) ml( ,none) collabels(, none) ///
varlabels(r1 "p-val(\(\beta^{dol}=\sum_i\omega_i\beta^{dyn}_i\))" )  label
