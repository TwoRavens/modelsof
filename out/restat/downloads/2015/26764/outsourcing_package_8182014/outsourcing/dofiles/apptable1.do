********************************************************************************************************************************************************
* Appendix Table 1: Summary Statistics of Current Population Survey Merged Outgoing Rotation Group Workers, Means and (Standard Deviations), 1983-2002 *
********************************************************************************************************************************************************
global x "$masterpath/datafiles/"
global y "$masterpath/lawrence/"
global z "$masterpath/outfiles/appendix/"
global folder_price_data "$masterpath/price_data/" //Tomer

clear
set mem 5000m
capture log close
set more off
!gunzip ${x}offshore_exposure.dta.gz
!gunzip ${x}price_data_all.dta.gz
!gunzip ${x}trade_man7090.dta.gz
!gunzip ${x}merge_micro_ind7090_small.dta.gz
!gunzip ${x}compuse_occ8090.dta.gz
use ${x}offshore_exposure, clear
sort man7090_orig year
merge man7090_orig year using ${y}importprices
tab _merge
keep if _merge==1 | _merge==3
drop _merge
sort ind7090 year
merge ind7090 year using ${folder_price_data}price_data_all
tab _merge
keep if _merge==1 | _merge==3
drop _merge
sort occ8090 year
save ${x}offshore_prices, replace

use ${x}trade_man7090.dta, clear
keep man7090 year rpiship79 tfp579 cap79 labor79
sort man7090 year
tempfile trade
save `trade', replace

use ${x}merge_micro_ind7090, clear
keep ind7090 year lowincemp highincemp penmod79 expmod79
sort ind7090 year
save ${x}merge_micro_ind7090_vars, replace

use ${x}offshore_exposure.dta, clear
sort occ8090 year
merge occ8090 year using ${x}offshore_prices
drop _merge
sort occ8090 year
merge occ8090 year using ${x}compuse_occ8090
tab _merge
drop if _merge==2 & year~=1982
drop _merge
sort man7090 year
merge man7090 year using `trade'
tab _merge
drop if year<1982
drop _merge
*************************************************************************************************
*** If want year 1982 for lowincemp highincemp penmod79 expmod79, drop from offshore_exposure ***
*** and read in from merge_micro_ind7090 (where we read them in from in offshore_exposure.do) ***
*************************************************************************************************
drop lowincemp highincemp penmod79 expmod79
sort ind7090 year
merge ind7090 year using ${x}merge_micro_ind7090_vars
tab _merge
drop if _merge==2

gen rwage=exp(lwage)
gen caplabor79=cap79/labor79

gen sector=1 if manuf==1
replace sector=2 if servs==1
replace sector=3 if agric==1
label define sector 1 "mfg", add
label define sector 2 "svs", add
label define sector 3 "agr", add
label values sector sector
 
global var "age female yrsed rwage ihwt lowincemp highincemp penmod79 expmod79 caplabor79 lowincemp_effective highincemp_effective penmod_effective expmod_effective piinv79 tfp579 use rpiship79 impfin1_effective expfin1_effective price_index importprice"  

foreach x in $var {
gen sd_`x'=`x'
}
global sd_var "sd_age sd_female sd_yrsed sd_rwage sd_ihwt sd_lowincemp sd_highincemp sd_penmod79 sd_expmod79 sd_caplabor79 sd_lowincemp_effective sd_highincemp_effective sd_penmod_effective sd_expmod_effective sd_piinv79 sd_tfp579 sd_use sd_rpiship79 sd_impfin1_effective sd_expfin1_effective sd_price_index sd_importprice"  
keep $var $sd_var year sector
save ${x}appendixtable1, replace

#delimit;

 global mylist "age sd_age female sd_female yrsed sd_yrsed rwage sd_rwage ihwt sd_ihwt
lowincemp sd_lowincemp highincemp sd_highincemp penmod79 sd_penmod79 expmod79 sd_expmod79 caplabor79 sd_caplabor79
lowincemp_effective sd_lowincemp_effective highincemp_effective sd_highincemp_effective penmod_effectiv sd_penmod_effective
expmod_effective sd_expmod_effective piinv79 sd_piinv79 tfp579 sd_tfp579 use sd_use rpiship79 sd_rpiship79 
impfin1_effective sd_impfin1_effective expfin1_effective sd_expfin1_effective price_index sd_price_index importprice sd_importprice";

use ${x}appendixtable1, clear;
capture log using ${z}appendixtable1.log, replace;
tablemat $var, stat(mean) by(sector);
tablemat $sd_var, stat(sd) by(sector);
tablemat $var if year==1983, stat(mean) by(sector);
tablemat $sd_var if year==1983, stat(sd) by(sector);
tablemat $var if year==2002, stat(mean) by(sector);
tablemat $sd_var if year==2002, stat(sd) by(sector);

capture gen dummy=1;

table dummy sector;
table dummy sector if year==1983;
table dummy sector if year==2002;
capture noisily log close;

erase ${x}offshore_prices.dta;
erase ${x}merge_micro_ind7090_vars.dta;
!gzip ${x}appendixtable1.dta;
!gzip ${x}offshore_exposure.dta;
!gzip ${x}price_data_all.dta;
!gzip ${x}trade_man7090.dta;
!gzip ${x}merge_micro_ind7090_small.dta;
!gzip ${x}compuse_occ8090.dta;

exit;

