/** figure2.do 

This do-file creates motivational graphs of variance
and key percentiles of the wage distribution against
city size and time.

The point is to show that in both dimensions the wage
distribution looks very similar.

***/

clear
set mem 800m
set more off

capture log close
log using figure2.log,replace text


**** 1. Calculate the Betas, Thetas and Eps2 and Put Them in the Dataset Temp **** 

capture program drop doall
program define doall 

use ../censusmicro/census`1'.dta

keep if hoursamp==1

if `1' == 80 {
   gen perwt = 1
}

egen totwt = sum(perwt), by(age Dedu size_`2')
egen beta = sum(lincwgb*perwt/totwt), by(age Dedu size_`2')
gen sig = lincwgb-beta
gen sig2 = sig*sig

gen n = perwt

#delimit ;
collapse (rawsum) n (sd) sdw=lincwgb sdb=beta (mean) mw=lincwgb sig2 msapop
(p10) w10=lincwgb (p25) w25=lincwgb (p50) w50=lincwgb (p75) w75=lincwgb (p90) w90=lincwgb
[aw=perwt], by(size_`2');
#delimit cr

rename size_`2' size
gen str1 type = "`2'"

gen varw = sdw^2
drop sdw
gen varb = sdb^2
drop sdb

gen year = 1900+`1'
if `1' == 00 {
replace year = 2000
}
if `1' == 07 {
replace year = 2007
}

if `1' ~= 80 | "`2'"~="a" {
    append using figure2.dta
}

save figure2.dta, replace

end

doall 80 a
doall 90 a
doall 00 a
doall 07 a

doall 80 b
doall 90 b
doall 00 b
doall 07 b

doall 80 c
doall 90 c
doall 00 c
doall 07 c

label variable mw "Mean Wage"
label variable varw "Variance of Wage"
label variable w10 "10th Pctile Wage"
label variable w25 "25th Pctile Wage"
label variable w50 "50th Pctile Wage"
label variable w75 "75th Pctile Wage"
label variable w90 "90th Pctile Wage"
label variable type "a=2000 Sizes, b=Contemporaneous Bins, c=Bins from 2000"

saveold figure2.dta, replace


********************* Figure 2 ************************

** Panel A
tabdisp size year if type=="a", cell(varw)
** Panel B
gen w9050 = w90-w50
tabdisp size year if type=="a", cell(w9050)
**Panel C
gen w5010 = w50-w10
tabdisp size year if type=="a", cell(w5010)


******** Robustness of Variance to Size Classification *********
tabdisp size year if type=="b", cell(varw)
tabdisp size year if type=="c", cell(varw)

****** Components of percentile gaps
tabdisp size year if type=="a", cell(w10)
tabdisp size year if type=="a", cell(w50)
tabdisp size year if type=="a", cell(w90)

***** Between and Within Components of Variance
tabdisp size year if type=="a", cell(varb)
tabdisp size year if type=="a", cell(sig2)


log close


