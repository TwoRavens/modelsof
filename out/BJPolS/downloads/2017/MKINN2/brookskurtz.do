*** Brooks and Kurtz AJPS 2007
** BrooksKurtz_AJPS07
use "brooks-kurtz capital and trade dataset.dta", clear

ccode countryname, from(cty) to(cow) gen(ccode)
replace ccode = 101 if countryname=="Venezuela, RB"
sort ccode year

merge m:1 ccode using gattlist.dta, gen(m1)
drop if m1==2
merge m:1 ccode using wtolist.dta, gen(m2)
drop if m2==2

gen gatt = year>=gattjoin
gen wto = year>=wtojoin
gen gattwto = gatt==1 | wto==1

xtset ccode year
gen debt_gdp_1=l.debt_gdp

gen study = ""

foreach n in orig noth fe time fet ct yfe cyfe {
gen method_`n' = ""
gen dv_`n' = ""
gen b_gatt_`n' = .
gen se_gatt_`n'= .
gen pval_gatt_`n' = .
gen lo_gatt_`n'=.
gen hi_gatt_`n'=.
gen N_gatt_`n'=.
}
gen studynum=.
gen timetrend=""
qui do gatt.do
local ii = 1
/*
* Table 1
*Model 1
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1 year1  argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' orig
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1    if fhouse<6, c(psar1) pairwise
gatt `ii' noth
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
  mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' fe
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1 year1  if fhouse<6, c(psar1) pairwise
gatt `ii' time
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
  mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
gatt `ii' fet
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
gatt `ii' ct
xtreg  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  i.year if fhouse<6, re
gatt `ii' yfe
xtreg  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  i.year if fhouse<6, fe
gatt `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1

* Model 2
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1  argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal ///
 honduras jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' orig
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1    if fhouse<6, c(psar1) pairwise
gatt `ii' noth
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' fe
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1   if fhouse<6, c(psar1) pairwise
gatt `ii' time
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
gatt `ii' fet
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
   imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
gatt `ii' ct
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.year if fhouse<6, c(psar1) pairwise
gatt `ii' yfe
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber i.year if fhouse<6, c(psar1) pairwise
gatt `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1

* model 3
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1  argentin bolivia brazil chile colombia costaric dominica ecuador ///
  elsalvad guatemal honduras jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' orig
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1    if fhouse<6, c(psar1) pairwise
gatt `ii' noth
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
  jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' fe
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 year1  if fhouse<6, c(psar1) pairwise
gatt `ii' time
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1   argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad ///
  guatemal honduras jamaica mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
gatt `ii' fet
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf ///
  wbflows_gdp_1 imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
gatt `ii' ct
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.year if fhouse<6, c(psar1) pairwise
gatt `ii' yfe
xtpcse  trade_index gattwto lngdp gdpcapita tradebal_1 gdpcapgrow_1  ln_inflation_1 y1995 partisan_new legherfindx   partisannew_legherf wbflows_gdp_1 ///
  imfflow_gdp_1 debt_gdp_1 trade_index_1  ka_open_1 i.countrynumber i.year if fhouse<6, c(psar1) pairwise
gatt `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1
*/
* Table 2
* Model 4
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   ka_open_1 year1 trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico ///
   nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' orig
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1  if fhouse<6, c(psar1) pairwise
gatt `ii' noth
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico nicaragua paraguay peru ///
   trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' fe
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
 ka_open_1 year1 trade_index_1  if fhouse<6, c(psar1) pairwise
gatt `ii' time
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico nicaragua ///
  paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
gatt `ii' fet
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  ka_open_1  trade_index_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
gatt `ii' ct
xtreg ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1 i.year if fhouse<6, re vce(cl ccode)
gatt `ii' yfe
xtreg ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ka_open_1 ///
   trade_index_1 i.year if fhouse<6, fe vce(cl ccode)
gatt `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1
* Model 5
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1 year1 trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
  mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' orig
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 if fhouse<6, c(psar1) pairwise
gatt `ii' noth
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico nicaragua ///
  paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' fe
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1 year1 trade_index_1  if fhouse<6, c(psar1) pairwise
gatt `ii' time
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica mexico ///
  nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
gatt `ii' fet
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
  y1995 ka_open_1  trade_index_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
gatt `ii' ct
xtreg ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 i.year if fhouse<6, re vce(cl ccode)
gatt `ii' yfe
xtreg ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
  ka_open_1  trade_index_1 i.year if fhouse<6, fe vce(cl ccode)
gatt `ii' cyfe
replace studynum = `ii' if _n==`ii'   
replace timetrend = "year" if _n==`ii'   
local ii=`ii'+1
* Model 6
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1 year1 trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal ///
   honduras jamaica mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' orig
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1  if fhouse<6, c(psar1) pairwise
gatt `ii' noth
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras jamaica ///
   mexico nicaragua paraguay peru trintab uruguay if fhouse<6, c(psar1) pairwise
gatt `ii' fe
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1 year1 trade_index_1  if fhouse<6, c(psar1) pairwise
gatt `ii' time
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1  trade_index_1 argentin bolivia brazil chile colombia costaric dominica ecuador elsalvad guatemal honduras ///
   jamaica mexico nicaragua paraguay peru trintab uruguay year1 if fhouse<6, c(psar1) pairwise
gatt `ii' fet
xtpcse ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 ///
   y1995  trade_gdp_1 ka_open_1  trade_index_1 i.countrynumber#c.year1 if fhouse<6, c(psar1) pairwise
gatt `ii' ct
xtreg ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1 i.year if fhouse<6, re vce(cl ccode)
gatt `ii' yfe
xtreg ka_open gattwto lngdp  gdpcapita curracct debt_gdp fixedcapform_1 gdpcapgrow_1 partisan_new legherfindx wbflows_gdp_1 imfflow_gdp_1 y1995 ///
   trade_gdp_1 ka_open_1  trade_index_1 i.year if fhouse<6, fe vce(cl ccode)
gatt `ii' cyfe
replace studynum = `ii' if _n==`ii'  
replace timetrend = "year" if _n==`ii' 
local ii=`ii'+1

replace study = "Brooks Kurtz" if studynum~=. 	

keep study-timetrend
drop if studynum==.
compress
save brookskurtz.dta , replace
