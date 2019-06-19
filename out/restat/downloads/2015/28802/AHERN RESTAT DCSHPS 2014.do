* This Stata do file generates results for "Do Common Stocks Have Perfect Substitutes? Product Market Competition and the Elasticity of Demand for Stocks"
* Published in Review of Economic Statistics, October 2014, Vol. 96(4) 756-766

insheet using "TORQSTOCK.nonan.csv",clear

* Create scaled variable
gen volatility_00=volatility/100

* Gen dummy variables
gen ebsthidummy=.
egen ebstmed=median(elas_prod)
replace ebsthidummy=1 if elas_prod>ebstmed & elas_prod~=.
replace ebsthidummy=0 if elas_prod<=ebstmed & elas_prod~=.

gen maxrbrhidummy=.
egen maxrbrmed=median(maxr2)
replace maxrbrhidummy=1 if maxr2>maxrbrmed & maxr2~=.
replace maxrbrhidummy=0 if maxr2<=maxrbrmed & maxr2~=.

gen atattorqcogind2mednhidummy=.
egen atattorqcogind2mednmed=median(indcomove)
replace atattorqcogind2mednhidummy=1 if indcomove>atattorqcogind2mednmed & indcomove~=.
replace atattorqcogind2mednhidummy=0 if indcomove<=atattorqcogind2mednmed & indcomove~=.

gen ff3ftorqcogind2mednhidummy=.
egen ff3ftorqcogind2mednmed=median(riskadjcomove)
replace ff3ftorqcogind2mednhidummy=1 if riskadjcomove>ff3ftorqcogind2mednmed & riskadjcomove~=.
replace ff3ftorqcogind2mednhidummy=0 if riskadjcomove<=ff3ftorqcogind2mednmed & riskadjcomove~=.

gen dispersionhidummy=.
egen dispersionmed=median(dispersion)
replace dispersionhidummy=1 if dispersion>dispersionmed & dispersion~=.
replace dispersionhidummy=0 if dispersion<=dispersionmed & dispersion~=.

gen turnoverhidummy=.
egen turnovermed=median(turnover)
replace turnoverhidummy=1 if turnover>turnovermed & turnover~=.
replace turnoverhidummy=0 if turnover<=turnovermed & turnover~=.

gen mrrrgmmhidummy=.
egen mrrrgmmmed=median(mrr)
replace mrrrgmmhidummy=1 if mrr>mrrrgmmmed & mrr~=.
replace mrrrgmmhidummy=0 if mrr<=mrrrgmmmed & mrr~=.

gen bsghlambdahidummy=.
egen bsghlambdamed=median(lambda)
replace bsghlambdahidummy=1 if lambda>bsghlambdamed & lambda~=.
replace bsghlambdahidummy=0 if lambda<=bsghlambdamed & lambda~=.

gen pinmrhidummy=.
egen pinmrmed=median(pin)
replace pinmrhidummy=1 if pin>pinmrmed & pin~=.
replace pinmrhidummy=0 if pin<=pinmrmed & pin~=.

gen volatilityhidummy=.
egen volatilitymed=median(volatility)
replace volatilityhidummy=1 if volatility>volatilitymed & volatility~=.
replace volatilityhidummy=0 if volatility<=volatilitymed & volatility~=.

gen ff3fr2hidummy=.
egen ff3fr2med=median(riskadjr2)
replace ff3fr2hidummy=1 if riskadjr2>ff3fr2med & riskadjr2~=.
replace ff3fr2hidummy=0 if riskadjr2<=ff3fr2med & riskadjr2~=.

gen lahidummy=.
egen lamed=median(logassets)
replace lahidummy=1 if logassets>lamed & logassets~=.
replace lahidummy=0 if logassets<=lamed & logassets~=.

* SECTION II.A - SUMMARY STATS - Table 1
sum elas_stock vigme vigpr vigbm vigep if ~missing(elas_stock) & ~missing(vigpr),d

* SECTION III - UNIVARIATE - Table 2
ttest elas_stock, by(ebsthidummy) unequal unpaired
ttest elas_stock, by(atattorqcogind2mednhidummy) unequal unpaired
ttest elas_stock, by(ff3ftorqcogind2mednhidummy) unequal unpaired
ttest elas_stock, by(ff3fr2hidummy) unequal unpaired
ttest elas_stock, by(dispersionhidummy) unequal unpaired
ttest elas_stock, by(turnoverhidummy) unequal unpaired
ttest elas_stock, by(mrrrgmmhidummy) unequal unpaired
ttest elas_stock, by(bsghlambdahidummy) unequal unpaired
ttest elas_stock, by(pinmrhidummy) unequal unpaired
ttest elas_stock, by(lahidummy) unequal unpaired
ttest elas_stock, by(volatilityhidummy) unequal unpaired

** SECTION III - CORRELATIONS - Table 3
* exclude extreme values of elas_prod (product market elasticity)
pwcorr elas_stock elas_prod indcomove riskadjcomove riskadjr2 dispersion turnover mrr lambda  pin logassets volatility if elas_prod>-1, sig

** SECTION III - REGRESSIONS - Table 4
eststo clear
eststo: reg elas_stock elas_prod 									   			  logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 	    riskadjcomove   				  	    	  logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 	                         riskadjr2                       logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock                                  dispersion                  logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 										 turnover         logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock                                                mrr logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock elas_prod riskadjcomove  riskadjr2 dispersion turnover mrr logassets volatility_00 i.ffind5 if elas_prod>-1, robust
esttab, p ar2

** SECTION IV.D - ROBUSTNESS TESTS - Industry Maturity, page 765
* Include dummy for mature industry
eststo clear
eststo: reg elas_stock elas_prod 									   			  mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 	    riskadjcomove   				  	    	  mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 	                         riskadjr2                       mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock                                  dispersion                  mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 										 turnover         mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock                                                mrr mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock elas_prod riskadjcomove  riskadjr2 dispersion turnover mrr mature logassets volatility_00 i.ffind5 if elas_prod>-1, robust
esttab, p ar2

* Include industry peak year
eststo clear
eststo: reg elas_stock elas_prod 									   			  indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 	    riskadjcomove   				  	    	  indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 	                         riskadjr2                       indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock                                  dispersion                  indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock 										 turnover         indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock                                                mrr indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
eststo: reg elas_stock elas_prod riskadjcomove  riskadjr2 dispersion turnover mrr indpeak logassets volatility_00 i.ffind5 if elas_prod>-1, robust
esttab, p ar2

** SECTION IV.A - ROBUSTNESS TESTS - S&P 500 Index Additions
use "SP500.dta", clear
* Drop extremes
reg elas_stock_scaled elas_prod vigme if elas_stock<1000 & elas_prod>-1 & elas_stock>-1000, robust
reg elas_stock_scaled elas_prod vigme if elas_stock<751.28 & elas_prod>-1 & elas_stock>-239.97, robust

** SECTION IV.B - ROBUSTNESS TESTS - Gulf War - Figure 2 and Table 5
** In Matlab .m file

** SECTION IV.C - ROBUSTNESS TESTS - Return Decompositions
insheet using "VUOLTEENAHO.nonan.csv",clear
reg elas_prod comove_cashflow comove_discountrate
pwcorr elas_prod comove_cashflow comove_discountrate, sig

** OTHER RESULTS
* PERSISTENCE USING DAILY DATA - ROBUSTNESS TEST Page 758
use "TORQPANEL.dta", clear
tsset permno dateno
eststo clear
eststo: xtreg elas_stock l(1).elas_stock, robust fe
eststo: xtreg elas_stock l(1).elas_stock  l(0/1).mktrf l(0/1).smb l(0/1).hml l(0/1).umd, robust fe
eststo: xtreg pbas l(1).pbas, robust fe
eststo: xtreg pbas l(1).pbas  l(0/1).mktrf l(0/1).smb l(0/1).hml l(0/1).umd, robust fe
eststo: xtreg ret l(1).ret, robust fe
eststo: xtreg ret l(1).ret  l(0/1).mktrf l(0/1).smb l(0/1).hml l(0/1).umd, robust fe
eststo: xtreg turnover l(1).turnover, robust fe
eststo: xtreg turnover l(1).turnover  l(0/1).mktrf l(0/1).smb l(0/1).hml l(0/1).umd, robust fe
esttab, p ar2
