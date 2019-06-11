* Models for Esarey and Schwindt-Bayer, 
* "Women’s Representation, Accountability, and Corruption in Democracies"

* NOTES:
* DV: higher values = more corruption (recoded from their original values)
* the "exclude_new" variable in each model was an extra variable that reduces the sample further to democracies only
* fh_neg is recoded freedom house scores so that higher scores are more democratic
* press3_inverse is recoded press freedom scores running from low freedom to higher freedom
* pers_lower is coded 0-13 in order of increasing personalization of electoral rules
* pres is coded 0=parliamentary, 1=semi-pres, 2=presidential
* pres_new is coded 0=parl, 1=pres

*   the icrg_corr variable is the PRS International Country Risk Guide corruption risk variable;
*	it is proprietary and must be licensed from PRS. For this reason, it is not included in our
*	public data file. You may obtain a license and merge this variable into our replication data
*	on your own; alternatively, if you send justin@justinesarey.com a copy of your license,
*   I will send you our complete replication file. 

log using esarey-schwbay.log, replace

*********************
* basic summaries and correlations
*********************


* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year
cor L.icrg_corr press3_inverse pres_new pers_lower

cor cpi_ti icrg_corr wb_corr

estpost sum cpi_ti icrg_corr wb_corr press3_inverse pres_new pers_lower pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1

esttab .  using summary.rtf, cells("mean(fmt(3)) sd(fmt(3)) count(fmt(3)) min(fmt(3)) max(fmt(3))") noobs coeflabels(cpi_ti "TI CPI" icrg_corr "ICRG" wb_corr "WBGI" press3_inverse "FH press freedom" pres_new "presidentialism" pers_lower "personalism" pctwomen "% women in lower house" fh_neg "FH freedom score" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights") noabbrev nonum wrap gaps varwidth(25) align(r) replace


***************************************************************************
* look at the "culture of corruption"
* effect of women in the context of past corruption levels
***************************************************************************

* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* scatterplot: Transparency International Measure
twoway (scatter cpi_ti pctwomen if l.cpi_ti<=5 & l.cpi_ti!=. & exclude_new!=1) (lfit cpi_ti pctwomen if l.cpi_ti<=5 & l.cpi_ti!=. & exclude_new!=1), title("Low Prior Corruption") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-lag-lo.emf, replace
graph export ti-lag-lo.eps, replace
twoway (scatter cpi_ti pctwomen if l.cpi_ti>5 & l.cpi_ti!=. & exclude_new!=1) (lfit cpi_ti pctwomen if l.cpi_ti>5 & l.cpi_ti!=. & exclude_new!=1), title("High Prior Corruption") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-lag-hi.emf, replace
graph export ti-lag-hi.eps, replace

qui reg cpi_ti l.cpi_ti pctwomen if exclude_new!=1
unique country if e(sample)
tab year if e(sample)

gen lagdum = .
replace lagdum = 0 if l.cpi_ti<=5 & l.cpi_ti!=.
replace lagdum = 1 if l.cpi_ti>5 & l.cpi_ti!=.
gen womXlagdum = pctwomen*lagdum
reg cpi_ti pctwomen lagdum womXlagdum if(exclude_new!=1)

xtunitroot fisher cpi_ti if exclude_new!=1, trend pperron lags(1)
xtunitroot fisher cpi_ti if exclude_new!=1, trend dfuller lags(1)


* check proportion of cases with l.cpi_ti > 7.5
qui reg cpi_ti l.cpi_ti  if exclude_new!=1
gen highti = .
replace highti = 0 if l.cpi_ti<7.5 & l.cpi_ti!=. & e(sample)
replace highti = 1 if l.cpi_ti>=7.5 & l.cpi_ti!=. & e(sample)
sum highti


ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

****
* ICRG Corruption Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* scatterplot: ICRG Measure
twoway (scatter icrg_corr pctwomen if l.icrg_corr<=3 & l.icrg_corr!=. & exclude_new!=1) (lfit icrg_corr pctwomen if l.icrg_corr<=3 & l.icrg_corr!=. & exclude_new!=1), title("Low Prior Corruption") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)
*graph export icrg-lag-lo.emf, replace
twoway (scatter icrg_corr pctwomen if l.icrg_corr>3 & l.icrg_corr!=. & exclude_new!=1) (lfit icrg_corr pctwomen if l.icrg_corr>3 & l.icrg_corr!=. & exclude_new!=1), title("High Prior Corruption") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)
*graph export icrg-lag-hi.emf, replace

qui reg icrg_corr l.icrg_corr pctwomen if exclude_new!=1
unique country if e(sample)

gen lagdum = .
replace lagdum = 0 if l.icrg_corr<=3 & l.icrg_corr!=.
replace lagdum = 1 if l.icrg_corr>3 & l.icrg_corr!=.
gen womXlagdum = pctwomen*lagdum
reg icrg_corr pctwomen lagdum womXlagdum if(exclude_new!=1)

xtunitroot fisher icrg_corr if exclude_new!=1, trend pperron lags(1)
xtunitroot fisher icrg_corr if exclude_new!=1, trend dfuller lags(1)


* check proportion of cases with l.icrg_corr > 5
qui reg icrg_corr l.icrg_corr  if exclude_new!=1
gen highicrg = .
replace highicrg = 0 if l.icrg_corr<5 & l.icrg_corr!=. & e(sample)
replace highicrg = 1 if l.icrg_corr>=5 & l.icrg_corr!=. & e(sample)
sum highicrg


ice icrg_corr pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.icrg_corr * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg icrg_corr l.icrg_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* scatterplot: WBGI Measure
twoway (scatter wb_corr pctwomen if l.wb_corr<=2 & l.wb_corr!=. & exclude_new!=1) (lfit wb_corr pctwomen if l.wb_corr<=2 & l.wb_corr!=. & exclude_new!=1), scheme(s2mono)
twoway (scatter wb_corr pctwomen if l.wb_corr>2  & l.wb_corr!=. & exclude_new!=1) (lfit wb_corr pctwomen if l.wb_corr>2 & l.wb_corr!=. & exclude_new!=1), scheme(s2mono)

* model: WBGI Measure, with lag

ice wb_corr pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace)
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.wb_corr * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg wb_corr l.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 
eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 

esttab ti_est icrg_est wbgi_est using lag.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" lagXwomen "% women * lag DV" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)







*********************************
* Press freedom: use press3_inverse so that higher values are more freedom 
*********************************

****
* Transparency International Measure
****

clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* scatterplots: Transparency International Corruption Measure
twoway (scatter cpi_ti pctwomen if press3_inverse <= -30 & press3_inverse!=. & exclude_new!=1) (lfit cpi_ti pctwomen if press3_inverse <= -30 & press3_inverse!=. & exclude_new!=1), title("Low Press Freedom") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-press-lo.emf, replace
graph export ti-press-lo.eps, replace
twoway (scatter cpi_ti pctwomen if press3_inverse > -30 & press3_inverse!=. & exclude_new!=1) (lfit cpi_ti pctwomen if press3_inverse > -30 & press3_inverse!=. & exclude_new!=1), title("High Press Freedom") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-press-hi.emf, replace
graph export ti-press-hi.eps, replace

gen pressdum = .
replace pressdum = 0 if press3_inverse<=-30 & press3_inverse!=.
replace pressdum = 1 if press3_inverse>-30 & press3_inverse!=.
gen womXpressdum = pctwomen*pressdum
reg cpi_ti pctwomen pressdum womXpressdum if(exclude_new!=1)
unique country if e(sample)
tab year if e(sample)


* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1


****
* ICRG Corruption Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year
* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* scatterplots: ICRG Corruption Measure
twoway (scatter icrg_corr pctwomen if press3_inverse < -30 & press3_inverse!=. & exclude_new!=1) (lfit icrg_corr pctwomen if press3_inverse < -30 & press3_inverse!=. & exclude_new!=1), title("Low Press Freedom") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)

*graph export icrg-press-lo.emf, replace

twoway (scatter icrg_corr pctwomen if press3_inverse >= -30 & press3_inverse!=. & exclude_new!=1) (lfit icrg_corr pctwomen if press3_inverse >= -30 & press3_inverse!=. & exclude_new!=1), title("High Press Freedom") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)

*graph export icrg-press-hi.emf, replace

gen pressdum = .
replace pressdum = 0 if press3_inverse<=-30 & press3_inverse!=.
replace pressdum = 1 if press3_inverse>-30 & press3_inverse!=.
gen womXpressdum = pctwomen*pressdum
reg icrg_corr pctwomen pressdum womXpressdum if(exclude_new!=1)
unique country if e(sample)


* generate multiple imputation data sets
ice icrg_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, passive(womenXpress3: pctwomen*press3_inverse) seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg icrg_corr l.icrg_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* scatterplots: World Bank Governance Indicator Corruption Measure
twoway (scatter wb_corr pctwomen  if press3_inverse < -30 & press3_inverse!=. & exclude_new!=1) (lfit wb_corr pctwomen  if press3_inverse < -30 & exclude_new!=1), scheme(s2mono)
twoway (scatter wb_corr pctwomen  if press3_inverse >= -30 & press3_inverse!=. & exclude_new!=1) (lfit wb_corr pctwomen  if press3_inverse >= -30 & exclude_new!=1), scheme(s2mono)

* generate multiple imputation data sets
ice wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg wb_corr l.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

esttab ti_est icrg_est wbgi_est using press.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" press3_inverse "press freedom" womenXpress3 "% women * press freedom" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)








***************************************************************************
* parliamentary vs. presidential systems
***************************************************************************


clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* create interaction
gen womenXpres=pctwomen*pres_new

****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* scatterplot: Transparency International Measure
twoway (scatter cpi_ti pctwomen if pres_new==0 & exclude_new!=1) (lfit cpi_ti pctwomen if pres_new==0 & exclude_new!=1), title("Parliamentary Systems") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-prez-n.emf, replace
graph export ti-prez-n.eps, replace
twoway (scatter cpi_ti pctwomen if pres_new==1 & exclude_new!=1) (lfit cpi_ti pctwomen if pres_new==1 & exclude_new!=1), title("Presidential Systems") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-prez-y.emf, replace
graph export ti-prez-y.eps, replace

reg cpi_ti pctwomen pres_new womenXpres if(exclude_new!=1)
unique countryid if e(sample)
tab year if e(sample)

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* ICRG Corruption Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* create interaction
gen womenXpres=pctwomen*pres_new

* scatterplot: ICRG Measure
twoway (scatter icrg_corr pctwomen if pres_new==0 & exclude_new!=1) (lfit icrg_corr pctwomen if pres_new==0 & exclude_new!=1), title("Parliamentary Systems") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)
*graph export icrg-prez-n.emf, replace
twoway (scatter icrg_corr pctwomen if pres_new==1 & exclude_new!=1) (lfit icrg_corr pctwomen if pres_new==1 & exclude_new!=1), title("Presidential Systems") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)
*graph export icrg-prez-y.emf, replace

reg icrg_corr pctwomen pres_new womenXpres if(exclude_new!=1)
unique countryid if e(sample)


* generate multiple imputation data sets
ice icrg_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg icrg_corr l.icrg_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create interaction
gen womenXpres=pctwomen*pres_new

* scatterplot: WBGI Measure
twoway (scatter wb_corr pctwomen if pres_new==0 & exclude_new!=1) (lfit wb_corr pctwomen if pres_new==0 & exclude_new!=1), scheme(s2mono)
twoway (scatter wb_corr pctwomen if pres_new==1 & exclude_new!=1) (lfit wb_corr pctwomen if pres_new==1 & exclude_new!=1), scheme(s2mono)

ice wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg wb_corr l.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

esttab ti_est icrg_est wbgi_est using prez.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" pres_new "presidential system" womenXpres "% women * presidentialism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)



*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
***************************************************************************

****
* Transparency International Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* scatterplots: Transparency International Corruption Measure
twoway (scatter cpi_ti pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1) (lfit cpi_ti pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1), title("Low Personalism") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-pers-lo.emf, replace
graph export ti-pers-lo.eps, replace
twoway (scatter cpi_ti pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1) (lfit cpi_ti pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1), title("High Personalism") xtitle("% Women in Lower House") ytitle("TI Corruption Perception Index") legend(label(1 "TI CPI") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6 7 8 9 10) scheme(s2mono)
graph export ti-pers-hi.emf, replace
graph export ti-pers-hi.eps, replace

gen persdum = .
replace persdum = 0 if pers_lower<=6 & pers_lower!=.
replace persdum = 1 if pers_lower>6 & pers_lower!=.
gen womXpersdum = pctwomen*persdum
reg cpi_ti pctwomen persdum womXpersdum if(exclude_new!=1)
unique country if e(sample)
tab year if e(sample)


* check proportion of cases with pers_lower < 2.5
qui reg cpi_ti l.cpi_ti pers_lower if exclude_new!=1
gen lowpers = .
replace lowpers = 1 if pers_lower<2.5 & e(sample)
replace lowpers = 0 if pers_lower>=2.5 & e(sample)
sum lowpers


* generate multiple imputation data sets
ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1




****
* ICRG Corruption Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* scatterplots: ICRG Corruption Measure
twoway (scatter icrg_corr pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1) (lfit icrg_corr pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1), title("Low Personalism") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)
*graph export icrg-pers-lo.emf, replace
twoway (scatter icrg_corr pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1) (lfit icrg_corr pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1), title("High Personalism") xtitle("% Women in Lower House") ytitle("ICRG Corruption Score") legend(label(1 "ICRG Score") label(2 "Linear Fit")) ylabel(0 1 2 3 4 5 6) scheme(s2mono)
*graph export icrg-pers-hi.emf, replace 

gen persdum = .
replace persdum = 0 if pers_lower<=6 & pers_lower!=.
replace persdum = 1 if pers_lower>6 & pers_lower!=.
gen womXpersdum = pctwomen*persdum
reg icrg_corr pctwomen persdum womXpersdum if(exclude_new!=1)
unique country if e(sample)

* check proportion of cases with pers_lower < 2.5
qui reg icrg_corr l.icrg_corr pers_lower if exclude_new!=1
gen lowpers = .
replace lowpers = 1 if pers_lower<2.5 & e(sample)
replace lowpers = 0 if pers_lower>=2.5 & e(sample)
sum lowpers

* generate multiple imputation data sets
ice icrg_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, passive(womenXpers: pctwomen*pers_lower) seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg icrg_corr l.icrg_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* scatterplots: World Bank Governance Indicator Corruption Measure
twoway (scatter wb_corr pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1) (lfit wb_corr pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1), scheme(s2mono)
twoway (scatter wb_corr pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1) (lfit wb_corr pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1), scheme(s2mono)

* generate multiple imputation data sets
ice wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg wb_corr l.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

esttab ti_est icrg_est wbgi_est using pers.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)








*
* Generate marginal effects plots for personalism-gender interaction
* Code stolen with love from Brambor, Clark, and Golder (2006)
* (all other ME plots come from the same source)
*****************************************************************

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate: reg cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
mi estimate, post


*     ****************************************************************  *
*       Generate the values of Z for which you want to calculate the    *
*       marginal effect (and standard errors) of X on Y.                *
*     ****************************************************************  *

generate MV=((_n-1)/10)+1

replace  MV=. if _n>120

*     ****************************************************************  *
*       Grab elements of the coefficient and variance-covariance matrix *
*       that are required to calculate the marginal effect and standard *
*       errors.                                                         *
*     ****************************************************************  *

matrix b=e(b) 
matrix V=e(V)
 
scalar b1=b[1,2] 
scalar b2=b[1,3]
scalar b3=b[1,4]


scalar varb1=V[2,2] 
scalar varb2=V[3,3] 
scalar varb3=V[4,4]

scalar covb1b3=V[2,4] 
scalar covb2b3=V[3,4]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*     ****************************************************************  *
*       Calculate the marginal effect of X on Y for all MV values of    *
*       the modifying variable Z.                                       *
*     ****************************************************************  *

gen conb=b1+b3*MV if _n<130


*     ****************************************************************  *
*       Calculate the standard errors for the marginal effect of X on Y *
*       for all MV values of the modifying variable Z.                  *
*     ****************************************************************  *

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<130


*     ****************************************************************  *
*       Generate upper and lower bounds of the confidence interval.     *
*       Specify the significance of the confidence interval.            *
*     ****************************************************************  *

gen a=1.96*conse
 
gen upper=conb+a
 
gen lower=conb-a

*     ****************************************************************  *
*       Graph the marginal effect of X on Y across the desired range of *
*       the modifying variable Z.  Show the confidence interval.        *
*     ****************************************************************  *

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   ,   xlabel(1 2 3 4 5 6 7 8 9 10 11 12 13, labsize(2.5))  ylabel(-0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0 0.01,   labsize(2.5)) yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of % Wom. in Parliament") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of % Women in Parliament" "on Corruption As Personalism Changes", size(4)) subtitle(" " "Dependent Variable: TI Corruption Perception Index" " ", size(3)) xtitle( "Personalism Score", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Women in Parliament", size(3)) scheme(s2mono) graphregion(fcolor(white)) yline(0.01 -0.06, lcolor(gs14)) 

graph export ti-me-pers.emf, replace
graph export ti-me-pers.eps, replace

drop MV conb conse a upper lower








*
* Generate marginal effects plots for presidentialism-gender interaction
* Code stolen with love from Brambor, Clark, and Golder (2006)
* (all other ME plots come from the same source)
*****************************************************************

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o


* recode the presidentialism measure
recode pres_new 2=1

* create interaction
gen womenXpres=pctwomen*pres_new

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate: reg cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
mi estimate, post




*     ****************************************************************  *
*       Grab elements of the coefficient and variance-covariance matrix *
*       that are required to calculate the marginal effect and standard *
*       errors.                                                         *
*     ****************************************************************  *

generate MV=_n-1

replace  MV=. if _n>2

*     ****************************************************************  *
*       Grab elements of the coefficient and variance-covariance matrix *
*       that are required to calculate the marginal effect and standard *
*       errors.                                                         *
*     ****************************************************************  *

matrix b=e(b) 
matrix V=e(V)
 
scalar b1=b[1,2] 
scalar b2=b[1,3]
scalar b3=b[1,4]


scalar varb1=V[2,2] 
scalar varb2=V[3,3] 
scalar varb3=V[4,4]

scalar covb1b3=V[2,4] 
scalar covb2b3=V[3,4]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*     ****************************************************************  *
*       Calculate the marginal effect of X on Y for all MV values of    *
*       the modifying variable Z.                                       *
*     ****************************************************************  *

gen conb=b1+b3*MV if _n<3


*     ****************************************************************  *
*       Calculate the standard errors for the marginal effect of X on Y *
*       for all MV values of the modifying variable Z.                  *
*     ****************************************************************  *

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<3


*     ****************************************************************  *
*       Generate upper and lower bounds of the confidence interval.     *
*       Specify the significance of the confidence interval.            *
*     ****************************************************************  *

gen a=1.96*conse
 
gen upper=conb+a
 
gen lower=conb-a


generate x=_n
replace  x=. if _n>2
label define govts 1 "parliamentary" 2 "presidential"
label values x govts
eclplot conb lower upper x, xscale(range(0.5 2.5)) xlabel(1 2) ytitle("Marginal Effect of Women in Parliament", size(3)) legend(on label(1 "95% Confidence Interval") label(2 "Parameter estimate")) yline(0, lcolor(black)) title("Marginal Effect of % Women in Parliament" "on Corruption by Government Type", size(4)) subtitle(" " "Dependent Variable: TI Corruption Perception Index" " ", size(3)) xtitle( "Government Type", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) yline(0.02, lcolor(gs15))
graph export ti-me-prez.emf, replace
graph export ti-me-prez.eps, replace







*
* Generate marginal effects plots for lag-gender interaction
* Code stolen with love from Brambor, Clark, and Golder (2006)
* (all other ME plots come from the same source)
*****************************************************************

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate: reg cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
mi estimate, post



*     ****************************************************************  *
*       Generate the values of Z for which you want to calculate the    *
*       marginal effect (and standard errors) of X on Y.                *
*     ****************************************************************  *

generate MV=((_n-1)/10)

replace  MV=. if _n>101

*     ****************************************************************  *
*       Grab elements of the coefficient and variance-covariance matrix *
*       that are required to calculate the marginal effect and standard *
*       errors.                                                         *
*     ****************************************************************  *

matrix b=e(b) 
matrix V=e(V)
 
scalar b1=b[1,2] 
scalar b2=b[1,1]
scalar b3=b[1,3]


scalar varb1=V[2,2] 
scalar varb2=V[1,1] 
scalar varb3=V[3,3]

scalar covb1b3=V[2,3] 
scalar covb2b3=V[1,3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*     ****************************************************************  *
*       Calculate the marginal effect of X on Y for all MV values of    *
*       the modifying variable Z.                                       *
*     ****************************************************************  *

gen conb=b1+b3*MV if _n<102


*     ****************************************************************  *
*       Calculate the standard errors for the marginal effect of X on Y *
*       for all MV values of the modifying variable Z.                  *
*     ****************************************************************  *

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<102


*     ****************************************************************  *
*       Generate upper and lower bounds of the confidence interval.     *
*       Specify the significance of the confidence interval.            *
*     ****************************************************************  *

gen a=1.96*conse
 
gen upper=conb+a
 
gen lower=conb-a

*     ****************************************************************  *
*       Graph the marginal effect of X on Y across the desired range of *
*       the modifying variable Z.  Show the confidence interval.        *
*     ****************************************************************  *

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   ,   xlabel(0 1 2 3 4 5 6 7 8 9 10, labsize(2.5))  ylabel(-0.05 -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04,   labsize(2.5)) yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of % Wom. in Parliament") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of % Women in Parliament" "on Corruption As Lag Corruption Changes", size(4)) subtitle(" " "Dependent Variable: TI Corruption Perception Index" " ", size(3)) xtitle( "Lag TI CPI", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Women in Parliament", size(3)) scheme(s2mono) graphregion(fcolor(white)) yline(-0.05, lcolor(gs15))

graph export ti-me-lag.emf, replace
graph export ti-me-lag.eps, replace

drop MV conb conse a upper lower







*
* Generate marginal effects plots for press restrictions-gender interaction
* Code stolen with love from Brambor, Clark, and Golder (2006)
* (all other ME plots come from the same source)
*****************************************************************


* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate: reg cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

mi estimate, post


*     ****************************************************************  *
*       Generate the values of Z for which you want to calculate the    *
*       marginal effect (and standard errors) of X on Y.                *
*     ****************************************************************  *

generate MV=(-1*(_n-1)/1)

replace  MV=. if _n>81

*     ****************************************************************  *
*       Grab elements of the coefficient and variance-covariance matrix *
*       that are required to calculate the marginal effect and standard *
*       errors.                                                         *
*     ****************************************************************  *

matrix b=e(b) 
matrix V=e(V)
 
scalar b1=b[1,2] 
scalar b2=b[1,3]
scalar b3=b[1,4]


scalar varb1=V[2,2] 
scalar varb2=V[3,3] 
scalar varb3=V[4,4]

scalar covb1b3=V[2,4] 
scalar covb2b3=V[3,4]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3


*     ****************************************************************  *
*       Calculate the marginal effect of X on Y for all MV values of    *
*       the modifying variable Z.                                       *
*     ****************************************************************  *

gen conb=b1+b3*MV if _n<82


*     ****************************************************************  *
*       Calculate the standard errors for the marginal effect of X on Y *
*       for all MV values of the modifying variable Z.                  *
*     ****************************************************************  *

gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<82


*     ****************************************************************  *
*       Generate upper and lower bounds of the confidence interval.     *
*       Specify the significance of the confidence interval.            *
*     ****************************************************************  *

gen a=1.96*conse
 
gen upper=conb+a
 
gen lower=conb-a

*     ****************************************************************  *
*       Graph the marginal effect of X on Y across the desired range of *
*       the modifying variable Z.  Show the confidence interval.        *
*     ****************************************************************  *

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   , ylabel(-0.06 -0.04 -0.02 0 0.02 0.04 0.06,   labsize(2.5)) xlabel(-80 -60 -40 -20 0, labsize(2.5))   yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of % Wom. in Parliament") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of % Women in Parliament" "on Corruption As Press Freedom Increases", size(4)) subtitle(" " "Dependent Variable: TI Corruption Perception Index" " ", size(3)) xtitle( "Press Freedom", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Women in Parliament", size(3)) scheme(s2mono) graphregion(fcolor(white)) yline(0.06, lcolor(gs15))

graph export ti-me-press.emf, replace
graph export ti-me-press.eps, replace

drop MV conb conse a upper lower


log close
























***************************************
***************************************
***************************************
* Robustness checks on our results
* mostly reviewer-mandated additions
***************************************
***************************************
***************************************

log using esarey-schwbay-robust.log, replace


***********************
***********************
*  using different lags as measure of
*  history of corruption
***********************
***********************

****
* TI CPI Corruption Measure
* one period lag
****


* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est: mi estimate, post

unique countryid if used==1


****
* TI CPI Corruption Measure
* two period lag
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = L2.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti L2.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est2: mi estimate, post

unique countryid if used==1


****
* TI CPI Corruption Measure
* three period lag
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = L3.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti L3.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est3: mi estimate, post

unique countryid if used==1



esttab ti_est ti_est2 ti_est3 using morelags.rtf, replace order(L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen lagXwomen fh_neg log_gdp trade_impexp wecon) keep(L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen lagXwomen fh_neg log_gdp trade_impexp wecon) mtitles("one year lag" "two year lag" "three year lag") coeflabels(L.cpi_ti "lag TI CPI" L2.cpi_ti "lag (2) TI CPI" L3.cpi_ti "lag (3) TI CPI" pctwomen "% women in lower house" lagXwomen "% women * lag DV" fh_neg "FH Freedom" log_gdp "log GDP per capita" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)













***********************
***********************
*  Models w/ more lags
***********************
***********************


****
* press freedom measure
* TI Corruption Measure
****

clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo pressfree: mi estimate, post

unique countryid if used==1




****
* presidentialism measure
* TI Corruption Measure
****

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* create interaction
gen womenXpres=pctwomen*pres_new


* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo president: mi estimate, post
unique countryid if used==1




****
* personalism measure
* TI Corruption Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* generate multiple imputation data sets
ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1


eststo personalism: mi estimate, post

unique countryid if used==1


esttab pressfree president personalism using lag3.rtf, replace order(L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) keep(L.cpi_ti L2.cpi_ti L3.cpi_ti pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) mtitles("press freedom" "presidentialism" "personalism") coeflabels(L.icrg_corr "lag TI CPI" L2.icrg_corr "lag (2) TI CPI" L3.icrg_corr "lag (3) TI CPI" pctwomen "% women in lower house" press3_inverse "press freedom" womenXpress3 "% women * press freedom" pres_new "presidential system" womenXpres "% women * presidentialism" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)










***********************
***********************
* Fixed Effects Models
***********************
***********************

*********
* lag DV
*********

* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year if exclude_new!=1, fe
eststo lagdv: mi estimate, post

unique countryid if used==1



*********************************
* Press freedom: use press3_inverse so that higher values are more freedom 
*********************************

****
* Transparency International Measure
****

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year if exclude_new!=1, fe

eststo pressfree: mi estimate, post

unique countryid if used==1






***************************************************************************
* parliamentary vs. presidential systems
***************************************************************************


clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* create interaction
gen womenXpres=pctwomen*pres_new

****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year if exclude_new!=1, fe
eststo president: mi estimate, post

unique countryid if used==1




*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
***************************************************************************

****
* Transparency International Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* generate multiple imputation data sets
ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year if exclude_new!=1, fe

eststo personalism: mi estimate, post

unique countryid if used==1

esttab lagdv pressfree president personalism using fe.rtf, replace order(L.cpi_ti pctwomen lagXwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) keep(pctwomen L.cpi_ti lagXwomen press3_inverse womenXpress3 womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) mtitles("lag DV" "press freedom" "presidentialism" "personalism") coeflabels(L.cpi_ti "lag TI CPI" pctwomen "% women in lower house" lagXwomen "% women * lag DV" press3_inverse "press freedom" womenXpress3 "% women * press freedom" pres_new "presidential system" womenXpres "% women * presidentialism" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)














***********************
***********************
* No Lag Models
***********************
***********************

*********************************
* Press freedom: use press3_inverse so that higher values are more freedom 
*********************************

****
* Transparency International Measure
****

clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo pressfree: mi estimate, post






***************************************************************************
* parliamentary vs. presidential systems
***************************************************************************


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* create interaction
gen womenXpres=pctwomen*pres_new

****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo president: mi estimate, post






*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
***************************************************************************

****
* Transparency International Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* generate multiple imputation data sets
ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo personalism: mi estimate, post



esttab pressfree president personalism using nolag.rtf, replace order(pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) keep(pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) mtitles("press freedom" "presidentialism" "personalism") coeflabels(pctwomen "% women in lower house" press3_inverse "press freedom" womenXpress3 "% women * press freedom" pres_new "presidential system" womenXpres "% women * presidentialism" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)
















***********************
***********************
* Arellano-Bond DPD Models
***********************
***********************


*********************************
* Press freedom: use press3_inverse so that higher values are more freedom 
* ICRG Corruption Measure
*********************************

* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse
tab year, gen(yr)

eststo pressfree: xtdpd L(0/2).cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen press3_inverse womenXpress3 fh_neg log_gdp trade_impexp wecon  yr1-yr20) vce(robust) 

qui xtdpd L(0/2).cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen press3_inverse womenXpress3 fh_neg log_gdp trade_impexp wecon  yr1-yr20) vce(robust) 
estat abond, artests(4)

unique countryid if e(sample)
tab year if e(sample)

qui xtdpd L(0/2).cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen press3_inverse womenXpress3 fh_neg log_gdp trade_impexp wecon  yr1-yr20) twostep
estat sargan


***************************************************************************
* parliamentary vs. presidential systems
* ICRG Corruption Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* recode the presidentialism measure
recode pres_new 2=1

* create interaction
gen womenXpres=pctwomen*pres_new
tab year, gen(yr)

eststo president: xtdpd L(0/2).cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen pres_new womenXpres fh_neg log_gdp trade_impexp wecon yr1-yr20) vce(robust) 

qui xtdpd L(0/2).cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3))  div(pctwomen pres_new womenXpres fh_neg log_gdp trade_impexp wecon yr1-yr20) vce(robust) 
estat abond, artests(4)

unique countryid if e(sample)
tab year if e(sample)

qui xtdpd L(0/2).cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3))  div(pctwomen pres_new womenXpres fh_neg log_gdp trade_impexp wecon yr1-yr20) twostep
estat sargan



*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
* ICRG Corruption Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower
tab year, gen(yr)

eststo personalism: xtdpd L(0/2).cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen pers_lower womenXpers fh_neg log_gdp trade_impexp wecon yr1-yr20) vce(robust)

qui xtdpd L(0/2).cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen pers_lower womenXpers fh_neg log_gdp trade_impexp wecon yr1-yr20) vce(robust)
estat abond, artests(4)

unique countryid if e(sample)
tab year if e(sample)

qui xtdpd L(0/2).cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp trade_impexp wecon yr1-yr20 if exclude_new!=1, dgmm(cpi_ti, lag(3 4)) lgmm(cpi_ti, lag(3)) div(pctwomen pers_lower womenXpers fh_neg log_gdp trade_impexp wecon yr1-yr20) twostep
estat sargan







esttab pressfree president personalism using arbond.rtf, replace order(L.cpi_ti L2.cpi_ti pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) keep(L.cpi_ti L2.cpi_ti pctwomen press3_inverse womenXpress3 womenXpres pers_lower womenXpers fh_neg log_gdp trade_impexp wecon) mtitles("press freedom" "presidentialism" "personalism") coeflabels(L.cpi_ti "lag TI CPI" L2.cpi_ti "lag (2) TI CPI" pctwomen "% women in lower house" press3_inverse "press freedom" womenXpress3 "% women * press freedom" pres_new "presidential system" womenXpres "% women * presidentialism" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)












********************************
********************************
* combined model
********************************
********************************

* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen pres_new press3_inverse pers_lower fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.cpi_ti * pctwomen; gen presXwomen = pres_new*pctwomen; gen pressXwomen = press3_inverse*pctwomen; gen persXwomen = pers_lower*pctwomen;

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen lagXwomen pres_new presXwomen press3_inverse pressXwomen pers_lower persXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est: mi estimate, post

unique countryid if used==1


****
* ICRG Corruption Measure
****

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

ice icrg_corr pctwomen pres_new press3_inverse pers_lower fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.icrg_corr * pctwomen; gen presXwomen = pres_new*pctwomen; gen pressXwomen = press3_inverse*pctwomen; gen persXwomen = pers_lower*pctwomen;

mi fvset base 2000 year
mi estimate, esample(used): reg icrg_corr l.icrg_corr pctwomen lagXwomen pres_new presXwomen press3_inverse pressXwomen pers_lower persXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

****
* World Bank Governance Indicator Measure
****
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

ice wb_corr pctwomen pres_new press3_inverse pers_lower fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.wb_corr * pctwomen; gen presXwomen = pres_new*pctwomen; gen pressXwomen = press3_inverse*pctwomen; gen persXwomen = pers_lower*pctwomen;

mi fvset base 2000 year
mi estimate, esample(used): reg wb_corr l.wb_corr pctwomen lagXwomen pres_new presXwomen press3_inverse pressXwomen pers_lower persXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo wbgi_est: mi estimate, post

unique countryid if used==1

esttab ti_est icrg_est wbgi_est using combined.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen lagXwomen pres_new presXwomen press3_inverse pressXwomen pers_lower persXwomen fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen lagXwomen pres_new presXwomen press3_inverse pressXwomen pers_lower persXwomen) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" lagXwomen "% women * lag DV" pres_new "presidential system" presXwomen "% women * presidentialism"  press3_inverse "press freedom" pressXwomen "% women * press freedom" pers_lower "personalism" persXwomen "%women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)































*********************************************************
*********************************************************
* study alternative measures of corruption
* (reviewer-mandated additions)
*********************************************************
*********************************************************

* personalist vs. party-centered systems

* global corruption barometer scores from the QoG
clear all 
set more off
use qog_std_ts_jan15.dta
recode ccodecow .=999 if cname=="Serbia"
gen scode = ccodecow
drop if scode == .
drop if year == .
tsset scode year
sort scode year
save "qog_std_ts_jan15_merge.dta", replace

* Contract intensive money scores from Mark Souva
clear 
use "cimmark variable June 2011.dta"
gen scode = cowcode
sort scode year
save "CIM-souva.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* merge in the QoG GCB scores
sort scode year
merge 1:1 scode year using "qog_std_ts_jan15_merge.dta", keepusing(gcb_bj gcb_bper gcb_bpol)
drop if _merge==2
drop _merge

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* merge in the contract intensive money score
merge 1:1 scode year using "CIM-souva.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset scode year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o
gen cimmark_inv = 1-cimmark


twoway (scatter gcb_bj cpi_ti) (qfit gcb_bj cpi_ti) if exclude_new!=1, title("TI CPI and GCB Legal/Judicial Bribery") xtitle("TI Corruption Perception Index") ytitle("Prop. of Respondents Paying Bribe") legend(label(1 "Proportion Paying Bribe") label(2 "Quadratic Fit")) scheme(s2mono)
graph export ti-gcb_bj.emf, replace
graph export ti-gcb_bj.eps, replace
qui reg gcb_bj cpi_ti if exclude_new!=1
tab year if e(sample)
twoway (scatter gcb_bper cpi_ti) (qfit gcb_bper cpi_ti) if exclude_new!=1, title("TI CPI and GCB Registry/Permit Bribery") xtitle("TI Corruption Perception Index") ytitle("Proportion Paying Bribe") legend(label(1 "Proportion Paying Bribe") label(2 "Quadratic Fit") ) scheme(s2mono)
graph export ti-gcb_bper.emf, replace
graph export ti-gcb_bper.eps, replace
twoway (scatter gcb_bpol cpi_ti) (qfit gcb_bpol cpi_ti) if exclude_new!=1, title("TI CPI and GCB Police Bribery") xtitle("TI Corruption Perception Index") ytitle("Proportion Paying Bribe") legend(label(1 "Proportion Paying Bribe") label(2 "Quadratic Fit") ) scheme(s2mono)
graph export ti-gcb_bpol.emf, replace
graph export ti-gcb_bpol.eps, replace
twoway (scatter cimmark_inv cpi_ti) (qfit cimmark_inv cpi_ti) if exclude_new!=1, title("TI CPI and Contract-intensive Money") xtitle("TI Corruption Perception Index") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Quadratic Fit") ) scheme(s2mono)
graph export ti-cim.emf, replace
graph export ti-cim.eps, replace

reg cimmark_inv cpi_ti if exclude_new!=1
tab year if e(sample)

* relationship between CIM and CPI with controls
eststo cimcpi: reg cimmark_inv cpi_ti fh_neg log_gdp pct_prot trade_impexp wecon  if exclude_new!=1
esttab cimcpi using cim_cpi.rtf, replace order(cpi_ti cpi_ti_sq fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("(1 - CIM)") coeflabels(cpi_ti "TI CPI" cpi_ti_sq "TI CPI Squared" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* scatterplots by personalism level
twoway (scatter cimmark_inv pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1) (lfit cimmark_inv pctwomen if pers_lower<=6 & pers_lower!=. & exclude_new!=1), title("Low Personalism") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-pers-lo.emf, replace
graph export cim-pers-lo.eps, replace
twoway (scatter cimmark_inv pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1) (lfit cimmark_inv pctwomen if pers_lower>6 & pers_lower!=. & exclude_new!=1), title("High Personalism") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-pers-hi.emf, replace
graph export cim-pers-hi.eps, replace

* are the slopes different?
gen persdum = pers_lower > 6
replace persdum = . if pers_lower==.
gen womenXpersdum = pctwomen*persdum
eststo personalism_bas: reg cimmark_inv pctwomen persdum womenXpersdum if exclude_new!=1
unique countryid if e(sample)
tab year if e(sample)

ice cimmark_inv pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year<=2008, passive(womenXpers: pctwomen*pers_lower) seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi stset, clear
mi fvset base 2000 year

mi estimate, esample(used): reg cimmark_inv l.cimmark_inv pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 & year<=2008
eststo personalism_est: mi estimate, post

unique country if used==1


* presidential vs. parliamentary systems 

* global corruption barometer scores from the QoG
clear
set more off
use qog_std_ts_jan15.dta
recode ccodecow .=999 if cname=="Serbia"
gen scode = ccodecow
drop if scode == .
drop if year == .
tsset scode year
sort scode year
save "qog_std_ts_jan15_merge.dta", replace

* Contract intensive money scores from Mark Souva
clear 
use "cimmark variable June 2011.dta"
gen scode = cowcode
sort scode year
save "CIM-souva.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* merge in the QoG GCB scores
sort scode year
merge 1:1 scode year using "qog_std_ts_jan15_merge.dta", keepusing(gcb_bj gcb_bper gcb_bpol)
drop if _merge==2
drop _merge

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* merge in the contract intensive money score
merge 1:1 scode year using "CIM-souva.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset scode year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o
gen cimmark_inv = 1-cimmark

* recode the presidentialism measure
recode pres_new 2=1

* create interaction
gen womenXpres=pctwomen*pres_new


* scatterplots by presidentialism
twoway (scatter cimmark_inv pctwomen if pres_new == 1 & exclude_new!=1) (lfit cimmark_inv pctwomen if pres_new==1 & exclude_new!=1), title("Presidential Systems") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-prez-yes.emf, replace
graph export cim-prez-yes.eps, replace
twoway (scatter cimmark_inv pctwomen if pres_new==0 & exclude_new!=1) (lfit cimmark_inv pctwomen if pres_new==0 & exclude_new!=1), title("Parliamentary Systems") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-prez-no.emf, replace
graph export cim-prez-no.eps, replace

* are the slopes different?
eststo prez_bas: reg cimmark_inv pctwomen pres_new womenXpres if exclude_new!=1
unique countryid if e(sample)
tab year if e(sample)

ice cimmark_inv pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year<=2008, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi stset, clear
mi fvset base 2000 year

mi estimate, esample(used): reg cimmark_inv l.cimmark_inv pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 & year<=2008
eststo prez_est: mi estimate, post

unique country if used==1




* lag interaction

* global corruption barometer scores from the QoG
clear
set more off
use qog_std_ts_jan15.dta
recode ccodecow .=999 if cname=="Serbia"
gen scode = ccodecow
drop if scode == .
drop if year == .
tsset scode year
sort scode year
save "qog_std_ts_jan15_merge.dta", replace

* Contract intensive money scores from Mark Souva
clear 
use "cimmark variable June 2011.dta"
gen scode = cowcode
sort scode year
save "CIM-souva.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* merge in the QoG GCB scores
sort scode year
merge 1:1 scode year using "qog_std_ts_jan15_merge.dta", keepusing(gcb_bj gcb_bper gcb_bpol)
drop if _merge==2
drop _merge

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* merge in the contract intensive money score
merge 1:1 scode year using "CIM-souva.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset scode year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o
gen cimmark_inv = 1-cimmark

* scatterplot: ICRG Measure
twoway (scatter cimmark_inv pctwomen if l.cimmark_inv<=0.1 & l.cimmark_inv!=. & exclude_new!=1) (lfit cimmark_inv pctwomen if l.cimmark_inv<=0.1 & l.cimmark_inv!=. & exclude_new!=1), title("Low Prior Corruption") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-lag-lo.emf, replace
graph export cim-lag-lo.eps, replace
twoway (scatter cimmark_inv pctwomen if l.cimmark_inv>0.1 & l.cimmark_inv!=. & exclude_new!=1) (lfit cimmark_inv pctwomen if l.cimmark_inv>0.1 & l.cimmark_inv!=. & exclude_new!=1), title("High Prior Corruption") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-lag-hi.emf, replace
graph export cim-lag-hi.eps, replace

qui reg cimmark_inv l.cimmark_inv pctwomen if exclude_new!=1
unique country if e(sample)

gen lagdum = .
replace lagdum = 0 if l.cimmark_inv<=0.1 & l.cimmark_inv!=.
replace lagdum = 1 if l.cimmark_inv>0.1 & l.cimmark_inv!=.
gen womXlagdum = pctwomen*lagdum
eststo lag_bas: reg cimmark_inv pctwomen lagdum womXlagdum if(exclude_new!=1)
unique countryid if e(sample)
tab year if e(sample)

xtunitroot fisher cimmark_inv if exclude_new!=1, trend pperron lags(1)
xtunitroot fisher cimmark_inv if exclude_new!=1, trend dfuller lags(1)

ice cimmark_inv pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year<=2008, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi stset, clear
mi tsset scode year
qui mi xeq: sort scode year; by scode: gen lagXwomen = l.cimmark_inv * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg cimmark_inv l.cimmark_inv pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 & year<=2008
eststo lag_est: mi estimate, post

unique country if used==1




* press freedom
* global corruption barometer scores from the QoG
clear
set more off
use qog_std_ts_jan15.dta
recode ccodecow .=999 if cname=="Serbia"
gen scode = ccodecow
drop if scode == .
drop if year == .
tsset scode year
sort scode year
save "qog_std_ts_jan15_merge.dta", replace

* Contract intensive money scores from Mark Souva
clear 
use "cimmark variable June 2011.dta"
gen scode = cowcode
sort scode year
save "CIM-souva.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* merge in the QoG GCB scores
sort scode year
merge 1:1 scode year using "qog_std_ts_jan15_merge.dta", keepusing(gcb_bj gcb_bper gcb_bpol)
drop if _merge==2
drop _merge

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* merge in the contract intensive money score
merge 1:1 scode year using "CIM-souva.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset scode year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o
gen cimmark_inv = 1-cimmark

* scatterplot: ICRG Measure
twoway (scatter cimmark_inv pctwomen if press3_inverse < -30 & press3_inverse!=. & exclude_new!=1) (lfit cimmark_inv pctwomen if press3_inverse < -30 & press3_inverse!=. & exclude_new!=1), title("Low Press Freedom") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-press-lo.emf, replace
graph export cim-press-lo.eps, replace
twoway (scatter cimmark_inv pctwomen if press3_inverse >= -30 & press3_inverse!=. & exclude_new!=1) (lfit cimmark_inv pctwomen if press3_inverse >= -30 & press3_inverse!=. & exclude_new!=1), title("High Press Freedom") xtitle("% Women in Lower House") ytitle("1 - Prop. of Contract-intensive Money") legend(label(1 "1 - CIM") label(2 "Linear Fit")) ylabel(0 0.1 0.2 0.3 0.4 0.5) scheme(s2mono)
graph export cim-press-hi.emf, replace
graph export cim-press-hi.eps, replace

qui reg cimmark_inv press3_inverse pctwomen if exclude_new!=1
unique country if e(sample)

gen pressdum = .
replace pressdum = 1 if press3_inverse < -30 & press3_inverse !=.
replace pressdum = 0 if press3_inverse >= -30 & press3_inverse !=.
gen womXpressdum = pctwomen*pressdum
eststo press_bas: reg cimmark_inv pctwomen pressdum womXpressdum if(exclude_new!=1)
unique countryid if e(sample)
tab year if e(sample)

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice cimmark_inv pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year<=2008, passive(womenXpress3: pctwomen*press3_inverse) seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi stset, clear
mi fvset base 2000 year
mi estimate, esample(used): reg cimmark_inv l.cimmark_inv pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 & year<=2008
eststo press_est: mi estimate, post

unique country if used==1




esttab lag_est press_est prez_est personalism_est using cim_results.rtf, replace order(L.cimmark_inv pctwomen lagXwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cimmark_inv pctwomen lagXwomen pres_new womenXpres press3_inverse womenXpress3 pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("lag DV" "press freedom" "presidentialism" "personalism") coeflabels(L.cimmark_inv "lag CIM inverse" pctwomen "% women in lower house" lagXwomen "% women * lag DV" pres_new "presidential system" womenXpres "% women * presidentialism"  press3_inverse "press freedom" womenXpress3 "% women * press freedom" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)

esttab lag_bas press_bas prez_bas personalism_bas using cim_basic_results.rtf, replace order(pctwomen lagdum womXlagdum pressdum womXpressdum pres_new womenXpres persdum womenXpersdum) mtitles("lag DV" "press freedom" "presidentialism" "personalism") coeflabels(pctwomen "% women in lower house" lagdum "lag DV > 0.1" womXlagdum "% women * lag dummy" pressdum "press freedom < -30 " womXpressdum "% women * press dummy" pres_new "presidentialism" womenXpres "% women * presidentialism" persdum "personalism > 6" womenXpersdum "% women * pers. dummy" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)














*********************************************************
*********************************************************
* add control variables
* (reviewer-mandated additions)
*********************************************************
*********************************************************

***************************************************************************
* lag DV
* TI CPI
****

* UNCHR Condemnation from the Lebovic and Voeten data set
clear all
set more off 
use jprworkdatanew.dta
gen scode = CCODE
rename YEAR year
sort scode year
save "jpr_merge.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* add women's suffrage count
qui do "suffrage_year.do"
drop if suffrageyear==.

* merge in the UNCHR condemnations and aid amounts
sort scode year
merge 1:1 scode year using "jpr_merge.dta", keepusing(WBCOMMIT ODA)
* set aid amounts to zero for donor countries
replace ODA = 0 if countryid==4 | countryid==5 | countryid==8 | countryid==15 | countryid==25 | countryid==26 | countryid==35 | countryid==36 | countryid==39 | countryid==41 | countryid==48 | countryid==51 | countryid==53 | countryid==55 | countryid==99 | countryid==76 | countryid==77 | countryid==81 | countryid==88 | countryid==89 | countryid==95 | countryid==96 | countryid==100 | countryid==102 | countryid==103 | countryid==109 | countryid==110
drop if _merge==2
drop _merge

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge


tsset scode year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi tsset scode year
qui mi xeq: sort scode year; by scode: gen lagXwomen = l.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA i.year i.region if exclude_new!=1
eststo lag_est: mi estimate, post

unique countryid if used==1







***************************************************************************
* press freedom
* TI Corruption Measure


* UNCHR Condemnation from the Lebovic and Voeten data set
clear
set more off 
use jprworkdatanew.dta
gen scode = CCODE
rename YEAR year
sort scode year
save "jpr_merge.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* add women's suffrage count
qui do "suffrage_year.do"
drop if suffrageyear==.

* merge in the UNCHR condemnations and aid amounts
sort scode year
merge 1:1 scode year using "jpr_merge.dta", keepusing(WBCOMMIT ODA)
* set aid amounts to zero for donor countries
replace ODA = 0 if countryid==4 | countryid==5 | countryid==8 | countryid==15 | countryid==25 | countryid==26 | countryid==35 | countryid==36 | countryid==39 | countryid==41 | countryid==48 | countryid==51 | countryid==53 | countryid==55 | countryid==99 | countryid==76 | countryid==77 | countryid==81 | countryid==88 | countryid==89 | countryid==95 | countryid==96 | countryid==100 | countryid==102 | countryid==103 | countryid==109 | countryid==110
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

gen womenXpress3 = pctwomen * press3_inverse

* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon  suffrageyear ODA i.year i.region if exclude_new!=1

eststo press_est: mi estimate, post

unique countryid if used==1


***************************************************************************
* parliamentary vs. presidential systems
* TI Corruption Measure
****

* UNCHR Condemnation from the Lebovic and Voeten data set
clear
set more off 
use jprworkdatanew.dta
gen scode = CCODE
rename YEAR year
sort scode year
save "jpr_merge.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* add women's suffrage count
qui do "suffrage_year.do"
drop if suffrageyear==.

* merge in the UNCHR condemnations and aid amounts
sort scode year
merge 1:1 scode year using "jpr_merge.dta", keepusing(WBCOMMIT ODA)
* set aid amounts to zero for donor countries
replace ODA = 0 if countryid==4 | countryid==5 | countryid==8 | countryid==15 | countryid==25 | countryid==26 | countryid==35 | countryid==36 | countryid==39 | countryid==41 | countryid==48 | countryid==51 | countryid==53 | countryid==55 | countryid==99 | countryid==76 | countryid==77 | countryid==81 | countryid==88 | countryid==89 | countryid==95 | countryid==96 | countryid==100 | countryid==102 | countryid==103 | countryid==109 | countryid==110
drop if _merge==2
drop _merge

* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* recode the presidentialism measure
recode pres_new 2=1

* create interaction
gen womenXpres=pctwomen*pres_new

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA i.year i.region if exclude_new!=1
eststo prez_est: mi estimate, post

unique countryid if used==1


*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
* ICRG Corruption Measure
****

* UNCHR Condemnation from the Lebovic and Voeten data set
clear
set more off 
use jprworkdatanew.dta
gen scode = CCODE
rename YEAR year
sort scode year
save "jpr_merge.dta", replace

* add COW codes to the Schwindt-Bayer/Tavits Data Set
clear 
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
gen sname = country
qui do "Name_to_COW.do"

* add women's suffrage count
qui do "suffrage_year.do"
drop if suffrageyear==.

* merge in the UNCHR condemnations and aid amounts
sort scode year
merge 1:1 scode year using "jpr_merge.dta", keepusing(WBCOMMIT ODA)
* set aid amounts to zero for donor countries
replace ODA = 0 if countryid==4 | countryid==5 | countryid==8 | countryid==15 | countryid==25 | countryid==26 | countryid==35 | countryid==36 | countryid==39 | countryid==41 | countryid==48 | countryid==51 | countryid==53 | countryid==55 | countryid==99 | countryid==76 | countryid==77 | countryid==81 | countryid==88 | countryid==89 | countryid==95 | countryid==96 | countryid==100 | countryid==102 | countryid==103 | countryid==109 | countryid==110
drop if _merge==2
drop _merge


* merge in Heritage Foundation Women's Economic Rights scores
merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* generate multiple imputation data sets
ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon suffrageyear ODA i.year i.region if exclude_new!=1
eststo personalism_est: mi estimate, post

unique countryid if used==1


esttab lag_est press_est prez_est personalism_est using add-controls.rtf, replace order(L.cpi_ti pctwomen lagXwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti pctwomen lagXwomen pres_new womenXpres press3_inverse womenXpress3 pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon suffrageyear ODA) mtitles("lag DV" "press freedom" "presidentialism" "personalism") coeflabels(L.cpi_ti "lag TI CPI" pctwomen "% women in lower house" lagXwomen "% women * lag DV" press3_inverse "press freedom" womenXpress3 "% women * press freedom"  pres_new "presidential system" womenXpres "% women * presidentialism"  pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" suffrageyear "years since women's suffrage" ODA "Official Development Assistance" _cons "constant") noabbrev wrap nogaps varwidth(35) align(r)














**************************
* lag the key independent variables as instruments
* (reviewer-mandated additions)
**************************



*********************************
* Press freedom: use press3_inverse so that higher values are more freedom 
*********************************

****
* Transparency International Measure
****

clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

eststo pressfree: ivregress 2sls cpi_ti l.cpi_ti fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region (pctwomen press3_inverse womenXpress3 = L2.pctwomen L2.press3_inverse L2.womenXpress3) if exclude_new!=1 & year>=1995  

unique countryid if e(sample)
tab year if e(sample)

***************************************************************************
* parliamentary vs. presidential systems
***************************************************************************

* create interaction
gen womenXpres=pctwomen*pres_new

****
* Transparency International Measure
****

eststo president: ivregress 2sls cpi_ti l.cpi_ti pres_new fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region (pctwomen womenXpres = L2.pctwomen L2.womenXpres) if exclude_new!=1 & year>=1995

unique countryid if e(sample)
tab year if e(sample)


*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
***************************************************************************

* create interaction variable
gen womenXpers=pctwomen*pers_lower
 
eststo personalism: ivregress 2sls cpi_ti l.cpi_ti fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region (pctwomen pers_lower womenXpers = L2.pctwomen L2.pers_lower L2.womenXpers) if exclude_new!=1 & year>=1995

unique countryid if e(sample)
tab year if e(sample)




esttab pressfree president personalism using endolag.rtf, replace order(L.cpi_ti pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti pctwomen press3_inverse womenXpress3 pres_new womenXpres pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("press freedom" "presidentialism" "personalism") coeflabels(L.cpi_ti "lag TI CPI" pctwomen "% women in lower house" press3_inverse "press freedom" womenXpress3 "% women * press freedom" pres_new "presidential system" womenXpres "% women * presidentialism" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(30) align(r)










*********************************************************
*********************************************************
* add additional measures of accountability
* (reviewer-mandated additions)
*********************************************************
*********************************************************

****
* democracy level
* Transparency International Measure
****

clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXdem=pctwomen*polity2

* generate multiple imputation data sets
ice cpi_ti pctwomen polity2 womenXdem fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen polity2 womenXdem fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo dem_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen polity2 womenXdem fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1






****
* electoral quotas
* Transparency International Measure
****

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen noquota = 1 - quota
gen womenXnoquota=pctwomen*noquota

* generate multiple imputation data sets
ice cpi_ti pctwomen noquota womenXnoquota fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): reg cpi_ti l.cpi_ti pctwomen noquota womenXnoquota fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo quota_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen noquota womenXnoquota fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1




esttab dem_est quota_est using other-acc.rtf, replace order(L.cpi_ti pctwomen polity2 womenXdem noquota womenXnoquota fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti pctwomen polity2 womenXdem noquota womenXnoquota fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("polity level" "quotas") coeflabels(L.cpi_ti "lag TI CPI" pctwomen "% women in lower house" polity2 "polity2 score" womenXdem "% women * polity" noquota "no electoral quota" womenXnoquota "% women * no quota" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(30) align(r)








******************************************
******************************************
* random effects models
******************************************
******************************************
***************************************************************************
* look at the "culture of corruption"
* effect of women in the context of past corruption levels
***************************************************************************

* load in the data
clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

ice cpi_ti pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.cpi_ti * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

****
* ICRG Corruption Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

ice icrg_corr pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.icrg_corr * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): xtreg icrg_corr l.icrg_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* model: WBGI Measure, with lag

ice wb_corr pctwomen fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace)
use wb_imputed, replace
mi import ice

qui mi xeq: sort countryid year; by countryid: gen lagXwomen = l.wb_corr * pctwomen

mi fvset base 2000 year
mi estimate, esample(used): xtreg wb_corr l.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 
eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1 

esttab ti_est icrg_est wbgi_est using re-lag.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen lagXwomen fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" lagXwomen "% women * lag DV" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)







*********************************
* Press freedom: use press3_inverse so that higher values are more freedom 
*********************************

****
* Transparency International Measure
****

clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse


* generate multiple imputation data sets
ice cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1


****
* ICRG Corruption Measure
****

* load in the data
clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year
* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice icrg_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, passive(womenXpress3: pctwomen*press3_inverse) seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg icrg_corr l.icrg_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****

clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create interaction variable
gen womenXpress3=pctwomen*press3_inverse

* generate multiple imputation data sets
ice wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg wb_corr l.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

esttab ti_est icrg_est wbgi_est using re-press.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen press3_inverse womenXpress3 fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" press3_inverse "press freedom" womenXpress3 "% women * press freedom" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)








***************************************************************************
* parliamentary vs. presidential systems
***************************************************************************


clear all
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* create interaction
gen womenXpres=pctwomen*pres_new

****
* Transparency International Measure
****

* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* generate multiple imputation data sets
ice cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* ICRG Corruption Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* create interaction
gen womenXpres=pctwomen*pres_new

* generate multiple imputation data sets
ice icrg_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg icrg_corr l.icrg_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create interaction
gen womenXpres=pctwomen*pres_new

ice wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg wb_corr l.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

esttab ti_est icrg_est wbgi_est using re-prez.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pres_new womenXpres fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" pres_new "presidential system" womenXpres "% women * presidentialism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)



*************************************************************************** 
* personalist vs. party systems in the lower house (pers_lower)
***************************************************************************

****
* Transparency International Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename cpi_ti cpi_ti_o
gen cpi_ti = 10 - cpi_ti_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* generate multiple imputation data sets
ice cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1994, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo ti_est: mi estimate, post

unique countryid if used==1

mibeta cpi_ti l.cpi_ti pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1




****
* ICRG Corruption Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year


* recode the DV
rename icrg_corr icrg_corr_o
gen icrg_corr = 6 - icrg_corr_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower


* generate multiple imputation data sets
ice icrg_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1, passive(womenXpers: pctwomen*pers_lower) seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg icrg_corr l.icrg_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1
eststo icrg_est: mi estimate, post

unique countryid if used==1

mibeta icrg_corr l.icrg_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1



****
* World Bank Governance Indicator Measure
****


clear
use schwindtbayer_tavits2016_TSCS_corruption_dataset_final.dta
set more off

merge 1:1 country year using "wecon-data.dta"
drop if _merge==2
drop _merge

* create inverse press variable 
gen press3_inverse = (-1)*press3
replace press3_inverse = . if year <= 1992

tsset countryid year

* recode the DV
rename wb_corr wb_corr_o
gen wb_corr = 2.6 - wb_corr_o

* create interaction variable
gen womenXpers=pctwomen*pers_lower

* generate multiple imputation data sets
ice wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon if exclude_new!=1 & year>=1995, seed(123456) m(50) saving(wb_imputed, replace) 
use wb_imputed, replace
mi import ice

mi fvset base 2000 year
mi estimate, esample(used): xtreg wb_corr l.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

eststo wbgi_est: mi estimate, post

unique countryid if used==1

mibeta wb_corr l.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_prot trade_impexp wecon i.year i.region if exclude_new!=1

esttab ti_est icrg_est wbgi_est using re-pers.rtf, replace order(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) keep(L.cpi_ti L.icrg_corr L.wb_corr pctwomen pers_lower womenXpers fh_neg log_gdp pct_protestant trade_impexp wecon) mtitles("TI CPI" "ICRG" "WBGI") coeflabels(L.cpi_ti "lag TI CPI" L.icrg_corr "lag ICRG" L.wb_corr "lag WBGI" pctwomen "% women in lower house" pers_lower "personalism" womenXpers "% women * personalism" fh_neg "FH Freedom" log_gdp "log GDP per capita" pct_protestant "% protestant" trade_impexp "trade imbalance (% of GDP)" wecon "women's economic rights" _cons "constant") noabbrev wrap gaps varwidth(25) align(r)



log close