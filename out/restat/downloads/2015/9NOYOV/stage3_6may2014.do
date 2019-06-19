version 10
capture log close
cd "/volumes/jss/Staiger Productivity"
log using stage3_6may2014, text replace 
* this is stage3 program, 3 nov 2008
* Assumes that stage1 and stage2 (and stent_staiger) have already been run
set more off 
clear all
set mem 200m
use aha94
gen provider=real(hcfaid)
drop hcfaid
gen forprof=(cntrl>=31 & cntrl<=33)
gen govt=((cntrl>=11 & cntrl<=16)|(cntrl>=41 & cntrl<=48))
sort provider
save aha94_1, replace

use analysis_1986_2_2014
sort provider
merge provider using aha94_1
tab _merge
drop if _merge==2
drop _merge
replace teaching=0 if teaching==.
replace forprof=0 if forprof==.


rename f_joint1 f_level
rename f_joint1_5 f_level_5
*rename f_level1 f_level
*rename f_level1_5 f_level_5
rename f_joint2 f_bad
rename f_joint2_5 f_bad_5
tab f_level_5, gen(q_)
tsset provider year


* Create survival, cost & drg measures (fe + mean in sample)

summ dead1yr [aw=nobs_]
gen surv =   1 - r(mean) - fe_
gen surv_pre = surv*(year<1992)
*summ dead30d [aw=nobs_]
*gen surv30d = 1 - r(mean) - fe30d_hosp_ami
sum parta1y [aw=nobs_]
gen cost = r(mean)+hosp_cost
summ drgwgt1y [aw=nobs_]
gen drg = r(mean)+hosp_drg
summ cost [aw=nobs_]
scalar meancost=r(mean)
/* this is the average drg price plus dish plus outlier in 2004 for ami calculated by weiping */
scalar avgcostperdrg = 6044
summ drg [aw=nobs_]
scalar meandrg=r(mean)
disp "dollar cost per drg is " meancost/meandrg
disp "total cost per drg is "avgcostperdrg
gen moddrg=(avgcostperdrg)*drg

* Merge income data
capture drop _merge
sort hrr
merge hrr using "/volumes/jss/Staiger Productivity/hrr_names.dta"
tab _merge 
drop if _merge==2
drop _merge
rename hrrstate state
sort state year
merge state year using "/volumes/jss/Staiger Productivity/state_year_inc.dta"
tab _merge
drop if _merge==2
drop _merge
/* impute income by state & year for providers missing hrr */
/* use median income for same year and for providers with medicare provider number in same state */
gen state_mc=int(provider/10000)
egen medinc = median(income), by(state_mc year)
replace income=medinc if income==.
gen linc = log(income)
tab f_level_5 if year == 1994 | year == 1995 [aw=nobs_], sum(income)
tab f_bad_5 if year == 1994 | year == 1995 [aw=nobs_], sum(income)

/* drop if <5 obs */
drop if nobs_<5

save temp_6may2014, replace

/* now create graphs */
/* figure 2 -- aggregate trends */
anova cost year [aw=nobs_]
predict costhat
anova surv year [aw=nobs_]
predict survhat
collapse costhat survhat, by(year)
label var costhat "Expenditures (Left Axis)"
label var survhat "Survival (Right Axis)"
#delimit ;
twoway (connected costhat year, sort yaxis(1)) 
       (line survhat year, sort yaxis(2)), 
       ytitle(Expenditures $, axis(1)) ytitle(One-Year Survival, axis(2))
       ytitle(, margin(small) axis(1)) ytitle(, margin(small) axis(2))
       xtitle(Year, margin(small)) 
       ylabel(10000(2000)30000, labsize(small) angle(horizontal) nogrid axis(1))
       ylabel(.56(.02).72, labsize(small) angle(horizontal) nogrid axis(2))
       xlabel(1986(2)2004)
       saving(figure2_may2014, replace)
       ;
#delimit cr
graph export figure2_may2014.tif, replace

/* figures 3 & 4 --  trends in survival and costs/drg by quintile of propensity to adopt */
/* this uses the original one-factor, f_level1 & f_level1_5, based on bblockers, asa, & reperf12 */
clear
use temp_6may2014
anova cost year*f_level1_5 [aw=nobs_]
predict costhat
anova moddrg year*f_level1_5 [aw=nobs_]
predict moddrghat
anova surv year*f_level1_5 [aw=nobs_]
predict survhat
collapse costhat moddrghat survhat, by(year f_level1_5)
#delimit ;
twoway (connect survhat year if f_level1_5==1, sort) 
       (line survhat year if f_level1_5==2, sort)
       (line survhat year if f_level1_5==3, sort)
       (line survhat year if f_level1_5==4, sort)
       (connect survhat year if f_level1_5==5, sort), 
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       ylabel(.58(.02).72, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       legend(order(1 "Slowest Diffusion Quintile" 2 "2nd Quintile" 3 "Middle Quintile" 4 "4th Quintile"  5 "Fastest Diffusion Quintile"))
       /* scheme(s2mono) */
       saving(figure3_may2014, replace)
       ;
graph export figure3_may2014.tif, replace;

twoway (connect costhat year if f_level1_5==1, sort) 
       (line costhat year if f_level1_5==2, sort)
       (line costhat year if f_level1_5==3, sort)
       (line costhat year if f_level1_5==4, sort)
       (connect costhat year if f_level1_5==5, sort), 
       ytitle(One-Year Expenditures (2004$))
       ytitle(, margin(small))
       ylabel(10000(2000)30000, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       legend(order(1 "Slowest Diffusion Quintile" 2 "2nd Quintile" 3 "Middle Quintile" 4 "4th Quintile"  5 "Fastest Diffusion Quintile"))
       /* scheme(s2mono) */
       saving(figure4a_may2014, replace)
       ;
graph export figure4a_may2014.tif, replace;

twoway (connect moddrghat year if f_level1_5==1, sort) 
       (line moddrghat year if f_level1_5==2, sort)
       (line moddrghat year if f_level1_5==3, sort)
       (line moddrghat year if f_level1_5==4, sort)
       (connect moddrghat year if f_level1_5==5, sort), 
       ytitle(Normalized Expenditures (2004$))
       ytitle(, margin(small))
       ylabel(10000(2000)30000, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       legend(order(1 "Slowest Diffusion Quintile" 2 "2nd Quintile" 3 "Middle Quintile" 4 "4th Quintile"  5 "Fastest Diffusion Quintile"))
       /* scheme(s2mono) */
       saving(figure4b_may2014, replace)
       ;
graph export figure4b_may2014.tif, replace;
#delimit cr



clear
use temp_6may2014
anova cost year*f_bad_5 [aw=nobs_]
predict costhat
anova moddrg year*f_bad_5 [aw=nobs_]
predict moddrghat
anova surv year*f_bad_5 [aw=nobs_]
predict survhat
collapse costhat moddrghat survhat, by(year f_bad_5)

#delimit ;

twoway (connect survhat year if f_bad==1, sort) 
       (line survhat year if f_bad==2, sort)
       (line survhat year if f_bad==3, sort)
       (line survhat year if f_bad==4, sort)
       (connect survhat year if f_bad==5, sort), 
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       ylabel(.58(.02).72, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       legend(order(1 "Slowest Diffusion Quintile" 2 "2nd Quintile" 3 "Middle Quintile" 4 "4th Quintile"  5 "Fastest Diffusion Quintile"))
       /* scheme(s2mono) */
       saving(figure3bad_may2014, replace)
       ;
graph export figure3bad_may2014.tif, replace;

twoway (connect costhat year if f_bad==1, sort) 
       (line costhat year if f_bad==2, sort)
       (line costhat year if f_bad==3, sort)
       (line costhat year if f_bad==4, sort)
       (connect costhat year if f_bad==5, sort), 
       ytitle(One-Year Expenditures (2004$))
       ytitle(, margin(small))
       ylabel(10000(2000)30000, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       legend(order(1 "Slowest Diffusion Quintile" 2 "2nd Quintile" 3 "Middle Quintile" 4 "4th Quintile"  5 "Fastest Diffusion Quintile"))
       /* scheme(s2mono) */
       saving(figure4abad_may2014, replace)
       ;
graph export figure4abad_may2014.tif, replace;

twoway (connect moddrghat year if f_bad==1, sort) 
       (line moddrghat year if f_bad==2, sort)
       (line moddrghat year if f_bad==3, sort)
       (line moddrghat year if f_bad==4, sort)
       (connect moddrghat year if f_bad==5, sort), 
       ytitle(Normalized Expenditures (2004$))
       ytitle(, margin(small))
       ylabel(10000(2000)30000, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       legend(order(1 "Slowest Diffusion Quintile" 2 "2nd Quintile" 3 "Middle Quintile" 4 "4th Quintile"  5 "Fastest Diffusion Quintile"))
       /* scheme(s2mono) */
       saving(figure4bbad_may2014, replace)
       ;
graph export figure4bbad_may2014.tif, replace;
#delimit cr


/* figure 5 --  trends in variance across hospitals (sigma convergence) */
/* (note that this weights by nobs_^2 to get the variance) */
clear
use temp_6may2014
gen adjvar=.
gen noisevar = (rmse_hosp^2)/nobs_
forval y = 1986/2004 {
 summ surv if year==`y' [aw=nobs_^2]
 scalar totvar = r(Var)
 summ noisevar [aw=nobs_^2] if year==`y'
 replace adjvar = totvar-r(mean) if year==`y'
 }

collapse adjvar, by(year)
gen adjsd = sqrt(adjvar)
list year adjsd
#delimit ;
twoway (line adjsd year, sort), 
       ytitle(Standard Deviation of Hospital Survival)
       ytitle(, margin(small))
       ylabel(0(.01).06, labsize(small) angle(horizontal) nogrid)
       xlabel(1986(2)2004)
       scheme(s2mono)
       saving(figure5_may2014, replace)
       ;

#delimit cr
graph export figure5_may2014.tif, replace

* regressions:
clear
use temp_6may2014
gen lcost = log(cost)
gen ldrg  = log(drg)
gen lmdrg = log(moddrg)

/* this merges on surgical rates from ccp to see if they are more correlated with stent adoption */
sort provider
merge provider using ccp_hosp_surgrates
tab _merge
drop _merge
corr avdif cath30d revasc reper12 f_level [aw=nobs_]

/* asian tigers analysis */
gen insamp_tigers=(year==1994|year==1995|year==2003|year==2004)&(f_level1_5==1|f_level1_5==5)&(avdif_5==1|avdif_5==5)
gen change_11 = (f_level1_5==1 & avdif_5==1) if insamp_tigers==1
gen change_15 = (f_level1_5==1 & avdif_5==5) if insamp_tigers==1
gen change_51 = (f_level1_5==5 & avdif_5==1) if insamp_tigers==1
gen change_55 = (f_level1_5==5 & avdif_5==5) if insamp_tigers==1
foreach var in change_11 change_15 change_51 change_55 {
 gen post`var'=`var'*(year==2003|year==2004) if insamp_tigers==1
 }
/* here are means in 1994-1995 */
reg surv change_* [aw=nobs_] if year==1994 | year==1995, nocon cluster(provider)
/* here are means in 2003-2004 */
reg surv change_* [aw=nobs_] if year==2003 | year==2004, nocon cluster(provider)
/* here are the difs -- coefficients on the post variables */
reg surv change_* postchange_* [aw=nobs_] if year==1994 | year==1995 | year==2003 | year==2004, nocon cluster(provider)
test postchange_15=postchange_51
test postchange_15=postchange_51=postchange_11=postchange_55
test postchange_11=postchange_55
tab f_level_5 avdif_5 if insamp & year==1994
tab f_level_5 avdif_5 if insamp [fw=nobs_]
/* here are the difs in ldrg -- coefficients on the post variables */
reg ldrg change_* postchange_* [aw=nobs_] if year==1994 | year==1995 | year==2003 | year==2004, nocon cluster(provider)
test postchange_15=postchange_51
test postchange_15=postchange_51=postchange_11=postchange_55
test postchange_11=postchange_55


global minsize = 50

tsset provider year

* table 2

reg surv  ldrg f_level1  year [aw=nobs_] if nobs_ >=5, cluster(provider)
nlcom (_b[f_level1])/_b[year]
xi: reg surv  ldrg f_level1  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg i.f_level1_5 year [aw=nobs_] if nobs_ >=5, cluster(provider)
forval j=2/5 {
 nlcom (_b[_If_level1__`j'])/_b[year]
 }
xi: reg surv  ldrg i.f_level1_5 i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg ldrg i.f_level1_5 i.year [aw=nobs_] if nobs_>=5, cluster(provider)
xi: reg ldrg i.f_level1_5 year [aw=nobs_] if nobs_>=5, cluster(provider)
xi: reg ldrg f_level1 i.year [aw=nobs_] if nobs_>=5, cluster(provider)
reg ldrg f_level1 year [aw=nobs_] if nobs_>=5, cluster(provider)

reg surv  ldrg f_level f_bad  year [aw=nobs_] if nobs_ >=5, cluster(provider)
nlcom (_b[f_level]+_b[f_bad])/_b[year]
xi: reg surv  ldrg f_level f_bad  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg i.f_level_5 i.f_bad_5 year [aw=nobs_] if nobs_ >=5, cluster(provider)
forval j=2/5 {
 nlcom (_b[_If_level_5_`j']+_b[_If_bad_5_`j'])/_b[year]
 }
xi: reg surv  ldrg i.f_level_5 i.f_bad_5 i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg ldrg i.f_level_5 i.f_bad_5 i.year [aw=nobs_] if nobs_>=5, cluster(provider)
xi: reg ldrg i.f_level_5 i.f_bad_5 year [aw=nobs_] if nobs_>=5, cluster(provider)
xi: reg ldrg f_level f_bad i.year [aw=nobs_] if nobs_>=5, cluster(provider)
reg ldrg f_level f_bad year [aw=nobs_] if nobs_>=5, cluster(provider)


xi: areg surv ldrg i.year [aw=nobs_] if nobs_>=5, absorb(provider)
predict prov_fe, d
predict prov_feres, dres
egen totobs = sum(nobs_), by(provider)
gen totsigvar=(prov_fe^2)-((rmse_hosp^2)/totobs)
reg totsigvar [aw=nobs_], cluster(provider)
nlcom sqrt(_b[_cons])
gen yrsigvar = (prov_feres^2)-((rmse_hosp^2)/nobs_)
reg yrsigvar [aw=nobs_], cluster(provider)
nlcom sqrt(_b[_cons])

tsset provider year

* Table 3 Row 1
reg     surv  lcost         [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  lcost  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  L.lcost  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  lcost  i.year [aw=nobs_] if nobs_ >=$minsize, cluster(provider)

* Row 2
reg     surv  ldrg         [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  L.ldrg  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg  i.year [aw=nobs_] if nobs_ >=$minsize, cluster(provider)

* Row 3
xi: reg surv  ldrg  f_level1        [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg  f_level1  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  L.ldrg  f_level1  i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg  f_level1  i.year [aw=nobs_] if nobs_ >=$minsize, cluster(provider)

* Row 4
xi: reg surv  ldrg  i.f_level1_5         [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg  i.f_level1_5 i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  L.ldrg  i.f_level1_5 i.year [aw=nobs_] if nobs_ >=5, cluster(provider)
xi: reg surv  ldrg  i.f_level1_5 i.year [aw=nobs_] if nobs_ >=$minsize, cluster(provider)

* Row 5
xi: areg surv  ldrg          [aw=nobs_] if nobs_ >=5, cluster(provider) absorb(provider)
xi: areg surv  ldrg   i.year [aw=nobs_] if nobs_ >=5, cluster(provider) absorb(provider)
xi: areg surv  L.ldrg   i.year [aw=nobs_] if nobs_ >=5, cluster(provider) absorb(provider)
xi: areg surv  ldrg   i.year [aw=nobs_] if nobs_ >=$minsize, cluster(provider) absorb(provider)

* Row 6
xi: areg surv  ldrg          [aw=nobs_] if nobs_ >=5 & year<1995, cluster(provider) absorb(provider)
xi: areg surv  ldrg   i.year [aw=nobs_] if nobs_ >=5 & year<1995, cluster(provider) absorb(provider)
xi: areg surv  L.ldrg   i.year [aw=nobs_] if nobs_ >=5 & year<1995, cluster(provider) absorb(provider)
xi: areg surv  ldrg   i.year [aw=nobs_] if nobs_ >=$minsize & year<1995, cluster(provider) absorb(provider)

* Row 7
xi: areg surv  ldrg          [aw=nobs_] if nobs_ >=5 & year>=1995, cluster(provider) absorb(provider)
xi: areg surv  ldrg   i.year [aw=nobs_] if nobs_ >=5 & year>=1995, cluster(provider) absorb(provider)
xi: areg surv  L.ldrg   i.year [aw=nobs_] if nobs_ >=5 & year>=1995, cluster(provider) absorb(provider)
xi: areg surv  ldrg   i.year [aw=nobs_] if nobs_ >=$minsize & year>=1995, cluster(provider) absorb(provider)


*  Set things up for predicted values
sum ldrg [aw=nobs_], det
scalar p25=r(p25)
scalar p50=r(p50)
scalar p75=r(p75)

* Table 3 
capture drop ldrg2
gen ldrg2 = ldrg^2
capture drop ldrg3
gen ldrg3=ldrg^3
capture drop ldrg4
gen ldrg4=ldrg^4

/* full sample quadratic */
disp "full sample"
xi: areg surv ldrg ldrg2 i.year [aw=nobs_] if nobs_>=5, cluster(provider) absorb(provider)
disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 " (" _b[ldrg]+2*_b[ldrg2]*p75 "," _b[ldrg]+2*_b[ldrg2]*p25 ")" 
nlcom _b[ldrg]+2*_b[ldrg2]*p50
disp "max is at: " 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
nlcom 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))


/* old way -- f_level and f_bad quintiles independently */
capture drop survhat
gen survhat=.
capture drop dsurv_dldrg
gen dsurv_dldrg=.
forval i = 1/5 {
 display "Quintile " `i'
 xi: areg surv ldrg ldrg2 i.year [aw=nobs_] if nobs_>=5 & f_level_5==`i', cluster(provider) absorb(provider)
 replace survhat = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 if f_level_5==`i' & nobs_>=5
 replace dsurv_dldrg = _b[ldrg] + 2*_b[ldrg2]*ldrg if f_level_5==`i' & nobs_>=5
 disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 " (" _b[ldrg]+2*_b[ldrg2]*p75 "," _b[ldrg]+2*_b[ldrg2]*p25 ")" 
 nlcom _b[ldrg]+2*_b[ldrg2]*p75
 nlcom _b[ldrg]+2*_b[ldrg2]*p50
 nlcom _b[ldrg]+2*_b[ldrg2]*p25
  disp "max is at: " 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 nlcom 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 }

#delimit ;
twoway (line survhat moddrg if f_level_5==1, sort) 
       (line survhat moddrg if f_level_5==3, sort) 
       (line survhat moddrg if f_level_5==5, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       ylabel(.60(.02).72, labsize(small) angle(horizontal) nogrid)
       xlabel(15000(5000)35000)
       legend(order(1 "Slowest Diffusion Quintile" 2 "Middle Quintile" 3 "Fastest Diffusion Quintile"))
       saving(figure6_may2014, replace);
#delimit cr
graph export figure6_may2014.tif, replace

#delimit ;
twoway (line dsurv_dldrg moddrg if f_level_5==1, sort) 
       (line dsurv_dldrg moddrg if f_level_5==2, sort) 
       (line dsurv_dldrg moddrg if f_level_5==3, sort) 
       (line dsurv_dldrg moddrg if f_level_5==4, sort) 
       (line dsurv_dldrg moddrg if f_level_5==5, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       /* ylabel(.60(.02).72, labsize(small) angle(horizontal) nogrid) */
       xlabel(15000(5000)35000)
       legend(order(1 "Slowest Diffusion Quintile" 2 "Middle Quintile" 3 "Fastest Diffusion Quintile"))
       saving(figure6a_may2014, replace);
#delimit cr
graph export figure6a_may2014.tif, replace

/* this code redoes it without hospital fixed effects */
capture drop survhat
gen survhat=.
capture drop dsurv_dldrg
gen dsurv_dldrg=.
forval i = 1/5 {
 display "Quintile " `i'
 xi: reg surv ldrg ldrg2 i.year [aw=nobs_] if nobs_>=5 & f_level_5==`i', cluster(provider)
 replace survhat = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 if f_level_5==`i' & nobs_>=5
 replace dsurv_dldrg = _b[ldrg] + 2*_b[ldrg2]*ldrg if f_level_5==`i' & nobs_>=5
 disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 " (" _b[ldrg]+2*_b[ldrg2]*p75 "," _b[ldrg]+2*_b[ldrg2]*p25 ")" 
 nlcom _b[ldrg]+2*_b[ldrg2]*p75
 nlcom _b[ldrg]+2*_b[ldrg2]*p50
 nlcom _b[ldrg]+2*_b[ldrg2]*p25
  disp "max is at: " 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 nlcom 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 }

#delimit ;
twoway (line survhat moddrg if f_level_5==1, sort) 
       (line survhat moddrg if f_level_5==3, sort) 
       (line survhat moddrg if f_level_5==5, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       ylabel(.60(.02).72, labsize(small) angle(horizontal) nogrid)
       xlabel(15000(5000)35000)
       legend(order(1 "Slowest Diffusion Quintile" 2 "Middle Quintile" 3 "Fastest Diffusion Quintile"))
       saving(figure6_nofe_may2014, replace);
#delimit cr
graph export figure6_nofe_may2014.tif, replace

/* now redo this with f_bad */
capture drop survhat
gen survhat=.
capture drop dsurv_dldrg
gen dsurv_dldrg=.
forval i = 1/5 {
 display "Quintile " `i'
 xi: areg surv ldrg ldrg2 i.year [aw=nobs_] if nobs_>=5 & f_bad_5==`i', cluster(provider) absorb(provider)
 replace survhat = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 if f_bad_5==`i' & nobs_>=5
 replace dsurv_dldrg = _b[ldrg] + 2*_b[ldrg2]*ldrg if f_bad_5==`i' & nobs_>=5
 disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 " (" _b[ldrg]+2*_b[ldrg2]*p75 "," _b[ldrg]+2*_b[ldrg2]*p25 ")" 
 nlcom _b[ldrg]+2*_b[ldrg2]*p75
 nlcom _b[ldrg]+2*_b[ldrg2]*p50
 nlcom _b[ldrg]+2*_b[ldrg2]*p25
  disp "max is at: " 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 nlcom 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 }

#delimit ;
twoway (line survhat moddrg if f_bad_5==1, sort) 
       (line survhat moddrg if f_bad_5==3, sort) 
       (line survhat moddrg if f_bad_5==5, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       ylabel(.60(.02).72, labsize(small) angle(horizontal) nogrid)
       xlabel(15000(5000)35000)
       legend(order(1 "Slowest Diffusion Quintile" 2 "Middle Quintile" 3 "Fastest Diffusion Quintile"))
       saving(figure6bad_may2014, replace);
#delimit cr
graph export figure6bad_may2014.tif, replace

#delimit ;
twoway (line dsurv_dldrg moddrg if f_bad_5==1, sort) 
       (line dsurv_dldrg moddrg if f_bad_5==2, sort) 
       (line dsurv_dldrg moddrg if f_bad_5==3, sort) 
       (line dsurv_dldrg moddrg if f_bad_5==4, sort) 
       (line dsurv_dldrg moddrg if f_bad_5==5, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       /* ylabel(.60(.02).72, labsize(small) angle(horizontal) nogrid) */
       xlabel(15000(5000)35000)
       legend(order(1 "Slowest Diffusion Quintile" 2 "Middle Quintile" 3 "Fastest Diffusion Quintile"))
       saving(figure6abad_may2014, replace);
#delimit cr
graph export figure6abad_may2014.tif, replace

/* this code redoes it without hospital fixed effects */
capture drop survhat
gen survhat=.
capture drop dsurv_dldrg
gen dsurv_dldrg=.
forval i = 1/5 {
 display "Quintile " `i'
 xi: reg surv ldrg ldrg2 i.year [aw=nobs_] if nobs_>=5 & f_bad_5==`i', cluster(provider)
 replace survhat = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 if f_bad_5==`i' & nobs_>=5
 replace dsurv_dldrg = _b[ldrg] + 2*_b[ldrg2]*ldrg if f_bad_5==`i' & nobs_>=5
 disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 " (" _b[ldrg]+2*_b[ldrg2]*p75 "," _b[ldrg]+2*_b[ldrg2]*p25 ")" 
 nlcom _b[ldrg]+2*_b[ldrg2]*p75
 nlcom _b[ldrg]+2*_b[ldrg2]*p50
 nlcom _b[ldrg]+2*_b[ldrg2]*p25
  disp "max is at: " 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 nlcom 6044*exp(-_b[ldrg]/(2*_b[ldrg2]))
 }

#delimit ;
twoway (line survhat moddrg if f_bad_5==1, sort) 
       (line survhat moddrg if f_bad_5==3, sort) 
       (line survhat moddrg if f_bad_5==5, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       ylabel(.60(.02).72, labsize(small) angle(horizontal) nogrid)
       xlabel(15000(5000)35000)
       legend(order(1 "Slowest Diffusion Quintile" 2 "Middle Quintile" 3 "Fastest Diffusion Quintile"))
       saving(figure6bad_nofe_may2014, replace);
#delimit cr
graph export figure6bad_nofe_may2014.tif, replace

/* this code does cubic -- commented out for now */
/*
capture drop survhat3
gen survhat3=.
forval i = 1/5 {
 display "Quintile " `i'
 xi: areg surv ldrg ldrg2 ldrg3 i.year [aw=nobs_] if nobs_>=5 & f_level_5==`i', cluster(provider) absorb(provider)
 replace survhat3 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg3]*ldrg3 if f_level_5==`i' & nobs_>=5
 disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 + 3*_b[ldrg3]*(p50^2) 
 nlcom _b[ldrg]+2*_b[ldrg2]*p50 + 3*_b[ldrg3]*(p50^2)
 }

twoway (line survhat3 moddrg if f_level_5==1, sort) (line survhat3 moddrg if f_level_5==3, sort) (line survhat3 moddrg if f_level_5==5, sort) if moddrg>15000 & moddrg<35000
#delimit ;
twoway (line survhat moddrg if f_level_5==1, sort) 
       (line survhat3 moddrg if f_level_5==1, sort)
       (line survhat moddrg if f_level_5==3, sort)
       (line survhat3 moddrg if f_level_5==3, sort)
       (line survhat moddrg if f_level_5==5, sort)
       (line survhat3 moddrg if f_level_5==5, sort)
         if moddrg>15000 & moddrg<35000;
#delimit cr
*/

/* finally two regression looking at relationship between rate of diffusion & spending */
xi: reg ldrg f_level f_bad i.year [aw=nobs_] if nobs_>=5, cluster(provider)
xi: reg ldrg f_level f_bad linc i.year [aw=nobs_] if nobs_>=5, cluster(provider)

/* estimate translog with two factor interactions and plot at -1, 0 and +1 for each factor, holding other factor at 0 */
gen f_levelsq=f_level^2
gen f_badsq=f_bad^2
gen f_level_bad = f_level*f_bad
gen ldrg_level=ldrg*f_level
gen ldrg_bad=ldrg*f_bad

xi:reg surv ldrg ldrg2 f_level f_levelsq f_bad f_badsq ldrg_level ldrg_bad f_level_bad  i.year [aw=nobs_] if nobs_>=5, cluster(provider)
capture drop survhat*
gen survhat_level_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_level]*(-1) + _b[f_levelsq]*(1) + _b[ldrg_level]*(-1)*ldrg  if nobs_>=5
gen survhat_m1_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_level]*(-1) + _b[f_levelsq]*(1) + _b[ldrg_level]*(-1)*ldrg + _b[f_bad]*(-1) + _b[f_badsq]*(1) + _b[ldrg_bad]*(-1)*ldrg + _b[f_level_bad]*(1)  if nobs_>=5
gen survhat_m1_p1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_level]*(-1) + _b[f_levelsq]*(1) + _b[ldrg_level]*(-1)*ldrg + _b[f_bad]*(1) + _b[f_badsq]*(1) + _b[ldrg_bad]*(1)*ldrg + _b[f_level_bad]*(-1)  if nobs_>=5
gen survhat_p1_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_level]*(1) + _b[f_levelsq]*(1) + _b[ldrg_level]*(1)*ldrg + _b[f_bad]*(-1) + _b[f_badsq]*(1) + _b[ldrg_bad]*(-1)*ldrg + _b[f_level_bad]*(-1)  if nobs_>=5
gen survhat_level_0 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2  if nobs_>=5
gen survhat_level_p1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_level]*(1) + _b[f_levelsq]*(1) + _b[ldrg_level]*(1)*ldrg  if nobs_>=5
gen survhat_bad_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_bad]*(-1) + _b[f_badsq]*(1) + _b[ldrg_bad]*(-1)*ldrg  if nobs_>=5
gen survhat_bad_0 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2  if nobs_>=5
gen survhat_bad_p1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[f_bad]*(1) + _b[f_badsq]*(1) + _b[ldrg_bad]*(1)*ldrg  if nobs_>=5

twoway (line survhat_level_m1 moddrg, sort) (line survhat_level_0 moddrg, sort) (line survhat_level_p1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6_by_level, replace)
graph export new_fig6_by_level.tif, replace
twoway (line survhat_bad_m1 moddrg, sort) (line survhat_bad_0 moddrg, sort) (line survhat_bad_p1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6_by_bad, replace)
graph export new_fig6_by_bad.tif, replace
twoway (line survhat_m1_m1 moddrg, sort) (line survhat_m1_p1 moddrg, sort) (line survhat_p1_m1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6nofe_v3, replace)
graph export new_fig6nofe_v3.tif, replace
 
/* now redo using hospital fixed effects */
xi:areg surv ldrg ldrg2 f_level f_levelsq f_bad f_badsq ldrg_level ldrg_bad f_level_bad  i.year [aw=nobs_] if nobs_>=5, absorb(provider) cluster(provider)
capture drop hfe
predict hfe, d
capture drop survhat*
gen survhat_level_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_level]*(-1)*ldrg  if nobs_>=5
gen survhat_m1_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_level]*(-1)*ldrg + _b[ldrg_bad]*(-1)*ldrg  if nobs_>=5
gen survhat_m1_p1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_level]*(-1)*ldrg + _b[ldrg_bad]*(1)*ldrg  if nobs_>=5
gen survhat_p1_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_level]*(1)*ldrg + _b[ldrg_bad]*(-1)*ldrg  if nobs_>=5
gen survhat_level_0 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2  if nobs_>=5
gen survhat_level_p1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_level]*(1)*ldrg  if nobs_>=5
gen survhat_bad_m1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_bad]*(-1)*ldrg  if nobs_>=5
gen survhat_bad_0 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2  if nobs_>=5
gen survhat_bad_p1 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg_bad]*(1)*ldrg  if nobs_>=5
reg hfe f_level f_levelsq f_bad f_badsq f_level_bad [aw=nobs_] if nobs_>5, cluster(provider)
replace survhat_level_m1=survhat_level_m1+_b[_cons]+_b[f_level]*(-1) + _b[f_levelsq]*(1)
replace survhat_m1_m1=survhat_m1_m1+_b[_cons]+_b[f_level]*(-1) + _b[f_levelsq]*(1) +_b[f_bad]*(-1) + _b[f_badsq]*(1) + _b[f_level_bad]*(1)
replace survhat_m1_p1=survhat_m1_p1+_b[_cons]+_b[f_level]*(-1) + _b[f_levelsq]*(1) +_b[f_bad]*(1) + _b[f_badsq]*(1) + _b[f_level_bad]*(-1)
replace survhat_p1_m1=survhat_p1_m1+_b[_cons]+_b[f_level]*(1) + _b[f_levelsq]*(1) +_b[f_bad]*(-1) + _b[f_badsq]*(1) + _b[f_level_bad]*(-1)
replace survhat_level_p1=survhat_level_p1+_b[_cons]+_b[f_level]*(1) + _b[f_levelsq]*(1)
replace survhat_bad_m1=survhat_bad_m1+_b[_cons]+_b[f_bad]*(-1) + _b[f_badsq]*(1)
replace survhat_bad_p1=survhat_bad_p1+_b[_cons]+_b[f_bad]*(1) + _b[f_badsq]*(1)
twoway (line survhat_level_m1 moddrg, sort) (line survhat_level_0 moddrg, sort) (line survhat_level_p1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6fe_by_level, replace)
graph export new_fig6fe_by_level.tif, replace
twoway (line survhat_bad_m1 moddrg, sort) (line survhat_bad_0 moddrg, sort) (line survhat_bad_p1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6fe_by_bad, replace)
graph export new_fig6fe_by_bad.tif, replace

*twoway (line survhat_m1_m1 moddrg, sort) (line survhat_level_m1 moddrg, sort) (line survhat_level_p1 moddrg, sort) (line survhat_p1_p1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6fe_v2_by_level, replace)
*graph export new_fig6fe_v2_by_level.tif, replace
*twoway (line survhat_m1_m1 moddrg, sort) (line survhat_bad_m1 moddrg, sort) (line survhat_bad_p1 moddrg, sort) (line survhat_p1_p1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6fe_v2_by_bad, replace)
*graph export new_fig6fe_v2_by_bad.tif, replace

* twoway (line survhat_m1_m1 moddrg, sort) (line survhat_m1_p1 moddrg, sort) (line survhat_p1_m1 moddrg, sort) if moddrg>15000 & moddrg<35000, saving(new_fig6fe_v3, replace)
#delimit ;
twoway (line survhat_m1_m1 moddrg, sort) 
       (line survhat_m1_p1 moddrg, sort) 
       (line survhat_p1_m1 moddrg, sort) if moddrg>15000 & moddrg<35000,
       ytitle(One-Year Survival)
       ytitle(, margin(small))
       xtitle(Adjusted Expenditures)
       xtitle(, margin(small))
       ylabel(.60(.02).70, labsize(small) angle(horizontal) nogrid)
       xlabel(15000(5000)35000)
       legend(order(1 "Low Factor A, Low Factor B" 2 "High Factor A, Low Factor B" 3 "Low Factor A, High Factor B"))
       saving(figure6_fe_may2014, replace);
#delimit cr
graph export new_fig6fe_v3.tif, replace

 
/*
gen survhat3=.
forval i = 1/5 {
 display "Quintile " `i'
 xi: areg surv ldrg ldrg2 ldrg3 i.year [aw=nobs_] if nobs_>=5 & f_level_5==`i', cluster(provider) absorb(provider)
 replace survhat3 = _b[_cons] + _b[_Iyear_2004] + _b[ldrg]*ldrg + _b[ldrg2]*ldrg2 + _b[ldrg3]*ldrg3 if f_level_5==`i' & nobs_>=5
 disp "effect at median and IQR is: " _b[ldrg]+2*_b[ldrg2]*p50 + 3*_b[ldrg3]*(p50^2) 
 nlcom _b[ldrg]+2*_b[ldrg2]*p50 + 3*_b[ldrg3]*(p50^2)
 }

twoway (line survhat3 moddrg if f_level_5==1, sort) (line survhat3 moddrg if f_level_5==3, sort) (line survhat3 moddrg if f_level_5==5, sort) if moddrg>15000 & moddrg<35000
#delimit ;
twoway (line survhat moddrg if f_level_5==1, sort) 
       (line survhat3 moddrg if f_level_5==1, sort)
       (line survhat moddrg if f_level_5==3, sort)
       (line survhat3 moddrg if f_level_5==3, sort)
       (line survhat moddrg if f_level_5==5, sort)
       (line survhat3 moddrg if f_level_5==5, sort)
         if moddrg>15000 & moddrg<35000;
#delimit cr
*/

log close
      

