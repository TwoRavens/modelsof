*** Brooks and Kurtz AJPS 2007
* There are two DVs, trade lib and CA lib

use "brooks-kurtz capital and trade dataset.dta", clear

ccode countryname, from(cty) to(cow) gen(ccode)
replace ccode = 101 if countryname=="Venezuela, RB"
sort ccode year

merge m:1 ccode using cites.dta, 
drop if _m==2

gen cites = year>=citesyr

xtset ccode year
gen debt_gdp_1=l.debt_gdp

gen study = ""

foreach n in orig noth fe time fet ct yfe cyfe {
gen method_`n' = ""
gen dv_`n' = ""
gen b_cites_`n' = .
gen se_cites_`n'= .
gen pval_cites_`n' = .
gen lo_cites_`n'=.
gen hi_cites_`n'=.
gen N_cites_`n'=.
}
gen studynum=.
gen timetrend=""
qui do cites.do
local ii = 1
/*
* Table 1
*Model 1
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1 year1  argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' orig
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1    if fhouse<6, c(psar1) pairwise
cites `ii' noth
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
  mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' fe
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1 year1  if fhouse<6, c(psar1) pairwise
cites `ii' time
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
  mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
cites `ii' fet
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
cites `ii' ct
xtreg  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  i.year if fhouse<6, re
cites `ii' yfe
xtreg  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  i.year if fhouse<6, fe
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1

* Model 2
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1  argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal ///
 honduras jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' orig
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1    if fhouse<6, c(psar1) pairwise
cites `ii' noth
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' fe
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1   if fhouse<6, c(psar1) pairwise
cites `ii' time
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
cites `ii' fet
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
   imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
cites `ii' ct
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.year if fhouse<6, c(psar1) pairwise
cites `ii' yfe
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber i.year if fhouse<6, c(psar1) pairwise
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1

* model 3
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1  argentin bolivia brazil chile colombia costaric dominica ecuador ///
  elsalvad guatemal honduras jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' orig
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1    if fhouse<6, c(psar1) pairwise
cites `ii' noth
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' fe
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1  if fhouse<6, c(psar1) pairwise
cites `ii' time
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad ///
  guatemal honduras jamaica mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
cites `ii' fet
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
cites `ii' ct
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.year if fhouse<6, c(psar1) pairwise
cites `ii' yfe
xtpcse  trade_index cites lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber i.year if fhouse<6, c(psar1) pairwise
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1 */
* Table 2
* Model 4
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   ka_open_1 year1 trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico ///
   nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' orig
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1  if fhouse<6, c(psar1) pairwise
cites `ii' noth
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico nicaragua paraguay peru ///
   trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' fe
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
 ka_open_1 year1 trade_index_1  if fhouse<6, c(psar1) pairwise
cites `ii' time
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico nicaragua ///
  paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
cites `ii' fet
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  ka_open_1  trade_index_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
cites `ii' ct
xtreg ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1 i.year if fhouse<6, re vce(cl ccode)
cites `ii' yfe
xtreg ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1 i.year if fhouse<6, fe vce(cl ccode)
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1
* Model 5
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1 year1 trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
  mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' orig
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 if fhouse<6, c(psar1) pairwise
cites `ii' noth
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico nicaragua ///
  paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' fe
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1 year1 trade_index_1  if fhouse<6, c(psar1) pairwise
cites `ii' time
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico ///
  nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
cites `ii' fet
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1  trade_index_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
cites `ii' ct
xtreg ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 i.year if fhouse<6, re vce(cl ccode)
cites `ii' yfe
xtreg ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 i.year if fhouse<6, fe vce(cl ccode)
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1
* Model 6
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1 year1 trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal ///
   honduras jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' orig
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1  if fhouse<6, c(psar1) pairwise
cites `ii' noth
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
   mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
cites `ii' fe
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1 year1 trade_index_1  if fhouse<6, c(psar1) pairwise
cites `ii' time
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
   jamaica mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
cites `ii' fet
xtpcse ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1  trade_index_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
cites `ii' ct
xtreg ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1 i.year if fhouse<6, re vce(cl ccode)
cites `ii' yfe
xtreg ka_open cites lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1 i.year if fhouse<6, fe vce(cl ccode)
cites `ii' cyfe
replace studynum = `ii' if _n==`ii'  
replace timetrend = "year" if _n==`ii' 
local ii=`ii'+1

replace study = "Brooks Kurtz" if studynum~=. 	

keep study-timetrend
drop if studynum==.
compress
save brookskurtz.dta , replace
