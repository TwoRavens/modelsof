set more off
set matsize 10000
capture log close
clear all

*Working Directory"
cap cd "..."


*************************************************************************;
*  File-Name: 	Analysis.do												*;
*  Purpose: 	Replicating 
*				"How Large Are The Political Costs of Fiscal Austerity?"
*  Data-in: 	Data.dta for main analysis, TableA17.dta for Table A17	*;
*************************************************************************;


*************************************************************************;
* ADO-FILES TO INSTALL
*************************************************************************;

*ssc install reghdfe
*ssc install tuples

*************************************************************************;
* DATA IN
*************************************************************************;

use Data , clear


*************************************************************************;
* DESCRIPTIVE 
*************************************************************************;


*TABLE 1
summarize regular if dexpenditures<0 & dexpenditures~=. & iso3code!="CHE"
summarize regular if dexpenditures>0 & dexpenditures~=. & iso3code!="CHE"
summarize regular if dexpenditures<-5 & dexpenditures~=. & iso3code!="CHE"
summarize regular if dexpenditures>-5 & dexpenditures~=. & iso3code!="CHE"
summarize irregular if dexpenditures<0 & dexpenditures~=.
summarize irregular if dexpenditures>0 & dexpenditures~=.
summarize irregular if dexpenditures<-5 & dexpenditures~=.
summarize irregular if dexpenditures>-5 & dexpenditures~=.

*TABLE A1
summarize regular if dexp<0 & dexp~=. & iso3code!="CHE"
summarize regular if dexp>0 & dexp~=. & iso3code!="CHE"
summarize regular if dexp<-5 & dexp~=. & iso3code!="CHE"
summarize regular if dexp>-5 & dexp~=. & iso3code!="CHE"
summarize irregular if dexp<0 & dexp~=.
summarize irregular if dexp>0 & dexp~=.
summarize irregular if dexp<-5 & dexp~=.
summarize irregular if dexp>-5 & dexp~=.


*************************************************************************;
* ANALYSIS 
*************************************************************************;

xtset ccode year

*READJUST VARS FOR BETTER VISUALIZATION
replace dexpenditures = dexpenditures / 100
replace dexp = dexp / 100


*************************************************************************;
* TABLE 2 
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' dexpenditures , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexpenditures democracy loggdp loggdppc rgc d gg_budg ,  a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexp , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexp democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures dexp) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr
}
break



*************************************************************************;
* TABLE 3 - IV ESTIMATES
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade (dexp=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexp=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N Ftest, fmt(0 2) labels("Observations" "Kleibergen-Paap F-stat"))  
 starlevels(+ 0.10 * 0.05 ** 0.01) label  keep(dexpenditures dexp) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr
}
break


*TABLE A2 (FIRST STAGE OF TABLE 3) [Note: regular and irregular transitions produce same first stage]
set more off
qui foreach y of varlist regular irregular {

eststo clear

#delimit ;
qui reghdfe `y'  shock_rgc_trade (dexpenditures=interact)  , 
a(ccode year c.year#i.ccode) vce(cl ccode year) ; 
cap drop ESAMPLE ; g ESAMPLE = 1 if e(sample)==1 ;
reghdfe dexpenditures interact shock_rgc_trade
if ESAMPLE==1, a(ccode year c.year#i.ccode) vce(cl ccode year) ; eststo ;

qui reghdfe `y'  shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact)  , 
a(ccode year c.year#i.ccode) vce(cl ccode year) ;
cap drop ESAMPLE ; g ESAMPLE = 1 if e(sample)==1 ;
reghdfe dexpenditures interact shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg
if ESAMPLE==1, a(ccode year c.year#i.ccode) vce(cl ccode year) ; eststo ;

qui reghdfe `y'  shock_rgc_trade (dexp=interact) , 
a(ccode year c.year#i.ccode) vce(cl ccode year) ; 
cap drop ESAMPLE ; g ESAMPLE = 1 if e(sample)==1 ;
reghdfe dexp interact shock_rgc_trade
if ESAMPLE==1, a(ccode year c.year#i.ccode) vce(cl ccode year) ; eststo ;

qui reghdfe `y'  shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexp=interact) , 
a(ccode year c.year#i.ccode) vce(cl ccode year) ;
cap drop ESAMPLE ; g ESAMPLE = 1 if e(sample)==1 ;
reghdfe dexp interact shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg
if ESAMPLE==1, a(ccode year c.year#i.ccode) vce(cl ccode year) ; eststo ;

noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr
}
break



*************************************************************************;
* TABLE A3 - real Growth
*************************************************************************;

eststo clear
qui xi: reg rgc dexpenditures i.country i.year  , cluster(country) 
eststo
qui xi: reg rgc dexpenditures ldemocracy lloggdp lloggdppc ld gg_budg i.country i.year , cluster(country) 
eststo
qui xi: reg loggdp lloggdp dexpenditures i.country i.year , cluster(country)
eststo
qui xi: reg loggdp lloggdp dexpenditures ldemocracy lloggdppc ld gg_budg i.country i.year , cluster(country) 
eststo
#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
keep(lloggdp dexpenditures ldemocracy lloggdp lloggdppc ld gg_budg);
eststo clear ;
#delimit cr



*************************************************************************;
* TABLE A4-A5 - OLS + 2SLS while transforming abs(expenditure cut)<.05 to zero
*************************************************************************;

preserve
replace dexpenditures = 0 if inrange(dexpenditures, -.05, .05) & dexpenditures!=.
replace dexp = 0 if inrange(dexp, -.05, .05) & dexp!=.

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' dexpenditures , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexpenditures democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexp , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexp democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures dexp) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr
}
break

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact), a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade (dexp=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexp=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N Ftest, fmt(0 2) labels("Observations" "Kleibergen-Paap F-stat"))  
 starlevels(+ 0.10 * 0.05 ** 0.01) label  keep(dexpenditures dexp) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr
}
break

restore


*************************************************************************;
* TABLE A6: OLS Robustness to Indicators of Expenditure Cuts
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' dexpenditures3 , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexpenditures3 democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexpenditures5 , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
reghdfe `y' dexpenditures5 democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures3 dexpenditures5) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr
}
break

*************************************************************************;
* TABLE A7: 2SLS Robustness to Indicators of Expenditure Cuts
*************************************************************************;


set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' shock_rgc_trade (dexpenditures3=interact), a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures3=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade (dexpenditures5=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures5=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N Ftest, fmt(0 2) labels("Observations" "Kleibergen-Paap F-stat"))  
 starlevels(+ 0.10 * 0.05 ** 0.01) label  keep(dexpenditures3 dexpenditures5) ;
#delimit cr
}
break


*************************************************************************;
* TABLE A8: Robustness for Lag Lengths
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe f.`y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'
reghdfe f.`y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact), a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'

reghdfe f2.`y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'
reghdfe f2.`y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'

reghdfe f3.`y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'
reghdfe f3.`y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'

reghdfe f4.`y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'
reghdfe f4.`y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'

reghdfe f5.`y' shock_rgc_trade (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'
reghdfe f5.`y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpenditures=interact), a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth") ;
#delimit cr
}
break

*************************************************************************;
* TABLE A9: Robustness for Windows of Expenditure Growth
*************************************************************************;

cap drop dexpendituresT*
qby ccode: gen dexpendituresT3=((expenditures-expenditures[_n-3])/expenditures[_n-3])
qby ccode: gen dexpendituresT5=((expenditures-expenditures[_n-5])/expenditures[_n-5])
qby ccode: gen dexpendituresT10=((expenditures-expenditures[_n-10])/expenditures[_n-10])


set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' shock_rgc_trade (dexpendituresT3=interact), a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpendituresT3=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade (dexpendituresT5=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpendituresT5=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade (dexpendituresT10=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

reghdfe `y' shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg (dexpendituresT10=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N Ftest, fmt(0 2) labels("Observations" "Kleibergen-Paap F-stat"))
 starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpendituresT3 dexpendituresT5 dexpendituresT10) ;
#delimit cr
}
break





*************************************************************************;
* TABLE A10: Robustness to Expenditure Definitions (ie CAPB)
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' dexpenditures , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

reghdfe `y' dexpenditures democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

reghdfe `y' dexp , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

reghdfe `y' dexp democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

reghdfe `y' capb_imf_growth , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

reghdfe `y' capb_imf_growth democracy loggdp loggdppc rgc d gg_budg  , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 , fmt(0 2 2) 
labels("Observations" "$ R^2$")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
keep (dexpenditures dexp capb_imf_growth) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" c.dexpenditures#c.latam "$\times$ Latin America"
) ;
#delimit cr
}
break


*************************************************************************;
* TABLE A11: Robustness to Duration models (probit)
*************************************************************************;

*Panel A
eststo clear
qui xi: probit regular dexpenditures regular_time* i.region i.year , cluster(country) 
eststo
qui xi: probit regular dexpenditures regular_time* democracy loggdp loggdppc rgc d gg_budg i.region i.year  , cluster(country) 
eststo
qui xi: probit regular dexp regular_time* i.region i.year, cluster(country)
eststo
qui xi: probit regular dexp regular_time* democracy loggdp loggdppc rgc d gg_budg i.region i.year , cluster(country) 
eststo
#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N ll, fmt(0 2) labels("Observations" "Log-Likelihood"))
 starlevels(+ 0.10 * 0.05 ** 0.01) label keep(dexpenditures dexp) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr

*Panel B
eststo clear
qui xi: probit irregular dexpenditures irregular_time* i.region i.year , cluster(country) 
eststo
qui xi: probit irregular dexpenditures irregular_time* democracy loggdp loggdppc rgc d gg_budg i.region i.year , cluster(country) 
eststo
qui xi: probit irregular dexp irregular_time* i.region i.year, cluster(country)
eststo
qui xi: probit irregular dexp irregular_time* democracy loggdp loggdppc rgc d gg_budg i.region i.year  , cluster(country) 
eststo
#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N ll, fmt(0 2) labels("Observations" "Log-Likelihood"))
 starlevels(+ 0.10 * 0.05 ** 0.01) label keep(dexpenditures dexp) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr


*************************************************************************;
* TABLE A12: Robustness to Duration models (IV probit)
*************************************************************************;

*PANEL A
set more off
eststo clear

qui xi: ivprobit regular (dexpenditures=interact) regular_time* shock_rgc_trade i.region i.year  , vce(cl country) first 
eststo
qui xi: ivprobit regular (dexpenditures=interact) regular_time* shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg i.region i.year , vce(cl country) first
eststo
qui xi: ivprobit regular (dexp=interact) regular_time* shock_rgc_trade i.region i.year , vce(cl country) first 
eststo 
qui xi: ivprobit regular (dexp=interact) regular_time* shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg i.region i.year , vce(cl country) first 
eststo


#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N ll, fmt(0 2) labels("Observations" "Log-Likelihood"))
 starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures dexp interact) ;
#delimit cr


*PANEL B
set more off
eststo clear

qui xi: ivprobit irregular (dexpenditures=interact) irregular_time* shock_rgc_trade i.region i.year , vce(cl country) first 
eststo
qui xi: ivprobit irregular (dexpenditures=interact) irregular_time* shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg i.region i.year  , vce(cl country) first 
eststo 
qui xi: ivprobit irregular (dexp=interact) irregular_time* shock_rgc_trade i.region i.year, vce(cl country) first 
eststo 
qui xi: ivprobit irregular (dexp=interact) irregular_time* shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg i.region i.year , vce(cl country) first 
eststo 

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N ll, fmt(0 2) labels("Observations" "Log-Likelihood"))
 starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures dexp interact) ;
#delimit cr


*************************************************************************;
* TABLE A13 - CONTROLLING FOR ELECTORAL CYCLES
*************************************************************************;

xtset ccode year

g felection = f.election
g lelection = l.election

set more off
eststo clear

qui reghdfe regular shock_rgc_trade election (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe regular shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg election (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe regular shock_rgc_trade election_pres election_parl (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe regular shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg election_pres election_parl (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe regular shock_rgc_trade lelection election felection (dexpenditures=interact), a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe regular shock_rgc_trade democracy loggdp loggdppc rgc d gg_budg l.election election f.election (dexpenditures=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N Ftest, fmt(0 2) labels("Observations" "Kleibergen-Paap F-stat"))
 starlevels(+ 0.10 * 0.05 ** 0.01) label 
 keep(dexpenditures felection election lelection election_pres election_parl) 
 order(dexpenditures felection election lelection election_pres election_parl) 
varlabel(dexpenditures "Real Gov. Expenditure Growth" dexp "Gov. Expenditure Growth (\% of GDP)") ;
#delimit cr


*************************************************************************;
* TABLE A14: NA/Europe VS LatAM
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' c.dexpenditures##c.latam  , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexpenditures=c.dexpenditures#c.latam
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexpenditures##c.latam  democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexpenditures=c.dexpenditures#c.latam
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexp##c.latam , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexp=c.dexp#c.latam
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexp##c.latam democracy loggdp loggdppc rgc d gg_budg  , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexp=c.dexp#c.latam
  estadd scalar Test=`r(p)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 Test , fmt(0 2 2) 
labels("Observations" "$ R^2$" "Test: same effect ($ p$ value)")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
keep (dexpenditures dexp c.dexpenditures#c.latam c.dexp#c.latam) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" c.dexpenditures#c.latam "$\times$ Latin America"
dexp "Gov. Expenditure Growth (\% of GDP)" c.dexp#c.latam "$\times$ Latin America") ;
#delimit cr
}
break

*************************************************************************;
* TABLE A15: Executive Ideology
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' c.dexpenditures##c.left  , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexpenditures=c.dexpenditures#c.left
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexpenditures##c.left  democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexpenditures=c.dexpenditures#c.left
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexp##c.left  , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexp=c.dexp#c.left
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexp##c.left democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexp=c.dexp#c.left
  estadd scalar Test=`r(p)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 Test , fmt(0 2 2) 
labels("Observations" "$ R^2$" "Test: same effect ($ p$ value)")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
keep (dexpenditures dexp c.dexpenditures#c.left c.dexp#c.left) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" c.dexpenditures#c.left "$\times$ Left ideology"
dexp "Gov. Expenditure Growth (\% of GDP)" c.dexp#c.left "$\times$ Left ideology") ;
#delimit cr
}
break


*************************************************************************;
* TABLE A16: PRESIDENTIAL VS PARLIAMENT
*************************************************************************;

set more off
qui foreach y of varlist regular irregular {

eststo clear

reghdfe `y' c.dexpenditures##c.presidential , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexpenditures=c.dexpenditures#c.presidential
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexpenditures##c.presidential  democracy loggdp loggdppc rgc d gg_budg  , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexpenditures=c.dexpenditures#c.presidential
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexp##c.presidential , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexp=c.dexp#c.presidential
  estadd scalar Test=`r(p)'

reghdfe `y' c.dexp##c.presidential democracy loggdp loggdppc rgc d gg_budg , a(ccode year c.year#i.ccode) vce(cl ccode)
eststo
  test dexp=c.dexp#c.presidential
  estadd scalar Test=`r(p)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
stats(N r2 Test , fmt(0 2 2) 
labels("Observations" "$ R^2$" "Test: same effect ($ p$ value)")) starlevels(+ 0.10 * 0.05 ** 0.01) label 
keep (dexpenditures dexp c.dexpenditures#c.presidential c.dexp#c.presidential) 	
varlabel(dexpenditures "Real Gov. Expenditure Growth" c.dexpenditures#c.presidential "$\times$ Presidential"
dexp "Gov. Expenditure Growth (\% of GDP)" c.dexp#c.presidential "$\times$ Presidential") ;
#delimit cr
}
break




*************************************************************************;
* TABLE A17: Robustness to broader sample of countries
*************************************************************************;

use TableA17 , clear

eststo clear

qui reghdfe regular shock_rgc_trade (dexp1=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe regular shock_rgc_trade democracy loggdppcwdi logpopwdi growthwdi (dexp1=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe irregular shock_rgc_trade (dexp1=interact) , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

qui reghdfe irregular shock_rgc_trade democracy loggdppcwdi logpopwdi growthwdi (dexp1=interact)  , a(ccode year c.year#i.ccode) vce(cl ccode year)
eststo 
estadd scalar Ftest=`e(widstat)'

#delimit ;
noisily estout, style(tex) cells(b(star fmt(3)) se(par)) 
 stats(N Ftest, fmt(0 2) labels("Observations" "Kleibergen-Paap F-stat"))  
 starlevels(+ 0.10 * 0.05 ** 0.01) label  keep(dexp1) 	
varlabel(dexp1 "Real Gov. Expenditure Growth") ; eststo clear ;
#delimit cr


*************************************************************************;
* Closing log
*************************************************************************;
capture log close 
*************************************************************************;
