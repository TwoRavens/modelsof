local filename=`"summstats"';
cap log close
log using `filename'.log, replace

#delimit ;
** SUMMARY STATISTICS;
clear;
set mem 300m;
set matsize 1000;
set more off;




;;;
** SUMMSTATS FOR TABLE;
;;;

foreach year in 1998 2000 {;

use regdata`year'_9800samp, clear;


* Keep only if data complete for main first stage;


xi: areg chlexport
shockindex 
lwgdp_pcap for_sh95 lcaplab95
dest_exportshare_95 
for025 for2550 for5075 for75100 
i.size
ltrade_value96 ltrade_value93
lexport95 lexport94_mod
lsales_income95 lsales_income94_mod
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
, a(prov_ind) 
;
keep if e(sample);


;;;
** BASIC STATS ;
;;;

* DISTRIBUTION OF SHARE OF EXPORTS GOING TO TOP TWO DESTINATIONS;

count if first_countryname~="" ;
count if first_countryname~="" & second_countryname=="";
count if dest_exportshare_95==1;
count if dest_exportshare_95>=.75 & dest_exportshare_95~=.;

su dest_exportshare_95, d;


* FIRMS REPORTING HONG Kong;

gen hongkong=0;
for any first second: replace hongkong=1 if X_countryname=="Hong Kong, China";

tab hongkong;



* Number of provinces, industries, and prov-industries;

codebook province new_industry prov_ind;




* Keep only observations with data on key variables;

tab size;


keep
shockindex 
chlexport exit
chlprod_ols_mod chlprod_levpet_mod 
chlemployee chlf_asset_net_value 
chlcapital_labor 
chlwage_payable_employeefr chope_profit_totalassetfr 
chlsales_income chlsales_income_employeefr 
chlinter_input 
chfor_sh
wgdp_pcap for_sh95 f_asset_net_value_employeefr95
dest_exportshare_95 
for025 for2550 for5075 for75100 
trade_value96 trade_value93
export95 export94
sales_income95 sales_income94
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
;

save tempdata, replace;



;;;
** SUMM STATS FOR TABLE ;
;;;


for any
shockindex 
chlexport exit
chlprod_ols_mod chlprod_levpet_mod 
chlemployee chlf_asset_net_value 
chlcapital_labor 
chlwage_payable_employeefr chope_profit_totalassetfr 
chlsales_income chlsales_income_employeefr 
chlinter_input 
chfor_sh
wgdp_pcap for_sh95 f_asset_net_value_employeefr95
dest_exportshare_95 
for025 for2550 for5075 for75100 
trade_value96 trade_value93
export95 export94
sales_income95 sales_income94
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
:
use tempdata, clear \ 
collapse (mean) mean=X (sd) sd=X (min) min=X (p10) p10=X (median) med=X (p90) p90=X (max) max=X (count) count=X \
gen str25 var="X" \
save tempX, replace \
;
erase tempdata.dta;



use tempshockindex, clear;
for any 
chlexport exit
chlprod_ols_mod chlprod_levpet_mod 
chlemployee chlf_asset_net_value 
chlcapital_labor 
chlwage_payable_employeefr chope_profit_totalassetfr 
chlsales_income chlsales_income_employeefr 
chlinter_input 
chfor_sh
wgdp_pcap for_sh95 f_asset_net_value_employeefr95
dest_exportshare_95 
for025 for2550 for5075 for75100 
trade_value96 trade_value93
export95 export94
sales_income95 sales_income94
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
:
append using tempX;
format mean med sd p10 p90 min max%15.0g;
order var;
list;
outsheet using `filename'`year', replace;


for any 
chlexport exit
chlprod_ols_mod chlprod_levpet_mod 
chlemployee chlf_asset_net_value 
chlcapital_labor 
chlwage_payable_employeefr chope_profit_totalassetfr 
chlsales_income chlsales_income_employeefr 
chlinter_input 
chfor_sh
wgdp_pcap for_sh95 f_asset_net_value_employeefr95
dest_exportshare_95 
for025 for2550 for5075 for75100 
trade_value96 trade_value93
export95 export94
sales_income95 sales_income94
export95_sales_income95fr export94_sales_income94fr_mod
salesyn94 
exportyn94 
export95_sales_income95_1 
: 
erase tempX.dta \ 
;


};


log close;
