*********************************************
* Stata v13
* Be sure to have tabstatout installed before running.
********************************************* 

*********************************************
*Working directory (adjust as needed)
********************************************* 

cd "~/Dropbox/Ethnic Quotas/data-analysis/paper-1"
   
* Also, create a folder in your working
* directory called "tabs-figs/" to store 
* results produced below.
   
*********************************************
* Clear memory, basic settings
********************************************* 
 	clear
	clear matrix
	clear mata
    set more off
	set scheme s1mono
*********************************************
* Bring in data
********************************************* 
  
use "recog-data-complete-final-2016-11-21.dta", replace

*********************************************
* Create some variables for use below
********************************************* 

g year_n = year -1990
g year_n2 = year_n^2

g fh_free = 0
replace fh_free = 1 if fh_status == 1 
g fh_partfree = 0
replace fh_partfree = 1 if fh_status == 2 

*********************************************
* Variable labels
********************************************* 

la var minldrnow "Minority leader"
la define minldr_lab 0 "Plurality leader" 1 "Minority leader"
la values minldrnow minldr_lab
la var minldrstart "Pre-violence minority leader"
la var ethfrac "Ethnic fractionalization"
la var ethconf "Ethnic conflict"
la var exclnow "Excluded proportion"
la var regconcgr "Regionally concentrated groups"
la var intleng "International engagement"
la var lgdppc "log(GDP/capita)"
la var fh_free "Freedom House 'free'"
la var fh_partfree "Freedom House 'partly free'"
la var logmntnpct "log(mountain percent)"
la var pitfatrocmaghistmax "PITF atrocities historical max"
g lgfat = log(fatalities + 1)
la var lgfat "log(fatalities + 1)"
la var prevpwrshr "Previous powersharing"
la var year "Year"
la var recogbin "Ethnic recognition in settlement" 
la var postmilvic "Military victory"

g ethconfXminldrnow = ethconf*minldrnow
la var ethconfXminldrnow "Min. incumb. X Eth. conf."
g minldrXethfrac = minldrnow*ethfrac
la var minldrXethfrac "Min. incumb. X Eth. frac."

*********************************************
* First analyze agreements
********************************************* 

preserve
keep if agreeyrbin == 1 & region !=.

*********************************************
* Regional & temporal trends
********************************************* 
log using "tabs-figs/trends-log.txt", replace text
sort region
tabstat recogbin, by(region) statistics(mean n) labelwidth(32) format(%9.2f)
sort year
lpoly recogbin year, degree(0) jitter(2) title("") ci legend(off) bwidth(5) rec pwidth(10) ytitle("Proportion with ethnic recognition")
graph export "tabs-figs/time-trend.pdf", replace
reg recogbin year_n
log close

*********************************************
* Correlates of recognition
********************************************* 

log using "tabs-figs/minority-recognition.txt", replace text
tab minldrnow recogbin, chi2 row
log close

log using  "tabs-figs/main-regs.txt", replace text
eststo clear
logit recogbin minldrnow, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrstart, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrstart ethfrac         exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng if ethconf==1, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng ethconfXminldrnow, cluster(cname)
eststo: mfx
margins, dydx(*) atmeans post
lincom minldrnow + ethconfXminldrnow
xi: logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng i.region, cluster(cname)
eststo: mfx
xi: logit recogbin minldrnow minldrstart ethfrac     exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng i.region  if ethconf==1, cluster(cname)
eststo: mfx
xi: logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng i.region  ethconfXminldrnow, cluster(cname)
eststo: mfx
margins, dydx(*) atmeans post
lincom minldrnow + ethconfXminldrnow
log close

*********************************************
* Interaction between ethfrac and minldrnow
********************************************* 
log using "tabs-figs/ethfrac.txt", replace text
logit recogbin minldrnow minldrXethfrac minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: mfx
lincom minldrnow + minldrXethfrac
* make a graph
log close
esttab using "tabs-figs/regs.csv", title("Minority leader as a correlate of recognition (logistic regression marginal effects)") replace margin label keep(minldrnow minldrstart ethconfXminldrnow ethfrac ethconf exclnow regconcgr lgdppc fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvict prevpwrshr intleng minldrXethfrac) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)

* Graph for interaction with Eth. Frac.

local control_vec minldrstart ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng
foreach var of varlist `control_vec'{
	sum `var'
	scalar mean_up = r(mean)
	g c_`var' = `var' - mean_up
} 

logit recogbin i.minldrnow##c.ethfrac c_*, cluster(cname)
margins minldrnow, at(ethfrac=(0(.05)1)) 
marginsplot, ytitle("Pr(Ethnic Recognition)") title("Interaction of Minority leader and Ethnic Fractionalization") ysc(r(0 1)) ylabel(0(.25)1) recast(line) recastci(rarea)
graph export "tabs-figs/ethfrac-interaction.pdf", replace

*********************************************
* Nonparametric matching estimates
*********************************************

* (Be sure to have tabstatout installed.)
tabstatout minldrstart ethfrac ethconf exclnow regconcgr, tf("tabs-figs/means_full")replace by(minldrnow) statistics(mean sd count) nototal 
tabstatout lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic, by(minldrnow) tf("tabs-figs/means_full")append statistics(mean sd count) nototal 
tabstatout year_n prevpwrshr intleng, by(minldrnow) tf("tabs-figs/means_full")append statistics(mean sd count) nototal

* Mahalanobis distance matching with bias adjustment

g index = _n
log using "tabs-figs/matching.txt", replace text
teffects nnmatch (recogbin minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n prevpwrshr intleng) (minldrnow), biasadj(ethfrac exclnow lgdppc logmntnpct lgfat pitfatrocmaghistmax year_n) generate(mahmatchi3) 
log close
predict mahmatch3dist, distance
g mahmatch3wgt = .
forvalues i =1(1)86{
	egen matchdum`i' = anycount(mahmatchi31), values(`i')
	egen matchcount`i' = total(matchdum`i')
	replace mahmatch3wgt = matchcount`i' if index == `i'
	drop matchdum* matchcount*
}
tabstatout minldrstart ethfrac ethconf exclnow regconcgr [fweight = mahmatch3wgt] if mahmatchi31!=0, tf("tabs-figs/means_full")append by(minldrnow) statistics(mean sd count) nototal 
tabstatout lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic [fweight = mahmatch3wgt] if mahmatchi31!=0, tf("tabs-figs/means_full")append by(minldrnow) statistics(mean sd count) nototal
tabstatout year_n prevpwrshr intleng [fweight = mahmatch3wgt] if mahmatchi31!=0, tf("tabs-figs/means_full")append by(minldrnow) statistics(mean sd count) nototal 

* For choosing cases:

g minldrnow_temp = minldrnow
xi: logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng i.region, cluster(cname)
replace minldrnow = 0
predict double prec_select, pr
replace minldrnow = minldrnow_temp
drop minldrnow_temp
export excel using "recog-data-complete-final-2015-01-16-short.xlsx", replace firstrow(var) 

* Propensity scores, accounting for minleader

xi: logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng i.region, cluster(cname)
predict double recog_pscore, pr
export excel using "recog-data-complete-final-2015-05-13-short-pscores.xlsx", replace firstrow(var) 


*********************************************
* Differences between settlements and constitutions?
********************************************* 

g minldrnowXsett = minldrnow*settlement
la var settlement "Settlement"  
la var minldrnowXsett "Min. incumb. X Settlement"  
eststo clear
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng settlement, cluster(cname)
eststo: mfx
logit recogbin minldrnow minldrnowXsett minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng settlement, cluster(cname)
eststo: mfx
log using  "tabs-figs/settlement-tests.txt", replace text
test minldrnowXsett
test settlement minldrnowXsett
log close
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng if settlement == 0, cluster(cname)
eststo: mfx
esttab using "tabs-figs/regs.csv", title("Minority leader as a correlate of recognition (logistic regression marginal effects)") append margin label keep(minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvict prevpwrshr intleng settlement minldrnowXsett) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)

log using  "tabs-figs/settlement.txt", replace text
tab minldrnow recogbin if settlement == 1
log close

*********************************************
* Checking for an interaction with levels of bloodshed
********************************************* 

g minldrnowXfat = minldrnow*lgfat
la var minldrnowXfat "Min. incumb. X log(fatalities + 1)"
g minldrnowXatroc = minldrnow*pitfatrocmaghistmax
la var minldrnowXatroc "Min. incumb. X PITF atrocities"

log using  "tabs-figs/bloodshed.txt", replace text
eststo clear
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng minldrnowXfat, cluster(cname)
eststo: mfx
lincom minldrnow+minldrnowXfat
logit recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng minldrnowXatroc, cluster(cname)
eststo: mfx
lincom minldrnow+minldrnowXatroc
esttab using "tabs-figs/regs.csv", title("Minority leader as a correlate of recognition (logistic regression marginal effects)") append margin label keep(minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvict prevpwrshr intleng minldrnowXfat minldrnowXatroc) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)
log close

*********************************************
* Do minority regimes yield less exclusion through informal
* accommodation?
********************************************* 

log using "tabs-figs/exclusion-regs.txt", replace text
eststo clear
eststo: reg exclf1 minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: reg exclf2 minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: reg exclf5 minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: reg exclf1 recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: reg exclf2 recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
eststo: reg exclf5 recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvic year_n year_n2 prevpwrshr intleng, cluster(cname)
esttab using "tabs-figs/regs.csv", title("Ethnic exclusion and minority leaders") append margin label keep(recogbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_partfree logmntnpct lgfat pitfatrocmaghistmax postmilvict prevpwrshr intleng) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)
log close
*********************************************
* Does minldrnow affect whether an agreement is ever reached?
********************************************* 
restore

g counter2 = counter^2
g counter3 = counter^3

eststo clear
logit agreeyrbin minldrnow counter counter2 counter3, cluster(cname)
eststo: mfx
logit agreeyrbin minldrnow minldrstart counter counter2 counter3, cluster(cname)
eststo: mfx
logit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr counter counter2 counter3, cluster(cname)
eststo: mfx
logit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax year_n year_n2 counter counter2 counter3, cluster(cname)
eststo: mfx
logit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax year_n year_n2 prevpwrshr intleng counter counter2 counter3, cluster(cname)
eststo: mfx
xi: logit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax year_n year_n2 prevpwrshr intleng i.region counter counter2 counter3, cluster(cname)
eststo: mfx
esttab using "tabs-figs/regs.csv", title("Minority incumbency as a correlate of conflict settlement (logistic regression event history model marginal effects)") append margin label keep(minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax prevpwrshr intleng) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)

* Cox model

eststo clear
eststo: clogit agreeyrbin minldrnow, group(counter) robust
eststo: clogit agreeyrbin minldrnow minldrstart, group(counter) robust
eststo: clogit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr, group(counter) robust
eststo: clogit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax year_n year_n2, group(counter) robust
eststo: clogit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax year_n year_n2 prevpwrshr intleng, group(counter) robust
eststo: xi: clogit agreeyrbin minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax year_n year_n2 prevpwrshr intleng, group(counter) robust
esttab using "tabs-figs/regs.csv", title("Minority incumbency as a correlate of conflict settlement (Cox/conditional logistic regression discrete time event history model)") append label keep(minldrnow minldrstart ethfrac ethconf exclnow regconcgr lgdppc fh_free fh_partfree logmntnpct pitfatrocmaghistmax prevpwrshr intleng) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01)
