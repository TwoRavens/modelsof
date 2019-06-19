******************************************************************************************************************
* Table 1: OLS Estimates of Change in Offshoring and Import Penetration Given Industry Skill Composition in 1983 *						
******************************************************************************************************************
global x "$masterpath/datafiles/"
global z "$masterpath/outfiles/"
# delimit ;
set more off;
clear;
set mem 1500m;
capture log close;

use ${x}merge_educ_man7090, clear;
sort man7090_orig year;
do man7090_orig_ind7090.do;
sort ind7090 year;
merge ind7090 year using ${x}compuse_ind7090.dta;
tab _merge;
keep if _merge==3;

keep if year==1983|year==2002;
gen routine=(finger + sts)/(finger + sts + math + dcp + ehf);
gen loweduc=(educ==1|educ==2);
collapse routine finger sts math dcp ehf loweduc lowincemp highincemp lowincshare highincshare piinv79 tfp579 expmod79 penmod79 rpiship79 labor79 cap79 use, by(man7090_orig year);
reshape wide routine finger sts math dcp ehf loweduc lowincshare highincshare lowincemp highincemp piinv79 tfp579 expmod79 penmod79 rpiship79 labor79 cap79 use, i(man7090_orig) j(year);
sort routine1983;
gen diff_low=lowincshare2002-lowincshare1983;
replace lowincemp1983=1 if lowincemp1983==0;
replace lowincemp2002=1 if lowincemp2002==0;
gen llowincemp1983=log(lowincemp1983);
gen llowincemp2002=log(lowincemp2002);
gen lhigh1983=log(highincemp1983);
gen lhigh2002=log(highincemp2002);
gen diff_lowemp=llowincemp2002-llowincemp1983;
gen diff_highemp=lhigh2002-lhigh1983;

gen lpiinv1983=ln(piinv791983*100);
gen lpiinv2002=ln(piinv792002*100);
rename tfp5791983 tfp1983;
rename tfp5792002 tfp2002; 
rename expmod791983 expmod1983; 
rename expmod792002 expmod2002; 
rename penmod791983 penmod1983; 
rename penmod792002 penmod2002;

rename labor791983 labor1983; 
rename labor792002 labor2002;

rename cap791983 cap1983; 
rename cap792002 cap2002;

gen caplabor1983=cap1983/labor1983/1000;
gen caplabor2002=cap2002/labor2002/1000;

gen lncaplabor1983=ln(cap1983/labor1983);
gen lncaplabor2002=ln(cap2002/labor2002);

gen lrpiship1983=log(rpiship791983); 
gen lrpiship2002=log(rpiship792002); 

gen diff_lpiinv=lpiinv2002-lpiinv1983;
gen diff_tfp=tfp2002-tfp1983;
gen diff_expmod=expmod2002-expmod1983;
gen diff_penmod=penmod2002-penmod1983;
gen diff_lrpiship=lrpiship2002-lrpiship1983;
gen diff_use=use2002-use1983;
gen diff_caplabor=caplabor2002-caplabor1983;
*replace diff_caplabor=0 if diff_caplabor==.;
*replace diff_lpiinv=0 if diff_lpiinv==.;
*replace diff_lrpiship=0 if diff_lrpiship==.;

log using ${z}table1,text replace;
reg diff_lowemp routine1983;
outreg2 routine1983 using ${z}table1_r1, nolabel ctitle(Level-Low-nocontrols) replace;
reg diff_lowemp routine1983 diff_lpiinv diff_tfp  diff_use diff_caplabor;
outreg2 routine1983 diff_lpiinv diff_tfp diff_use diff_caplabor using ${z}table1_r1, nolabel ctitle(Level-Low) append;
reg diff_highemp routine1983;
outreg2 routine1983 using ${z}table1_r1, nolabel ctitle(Level-High-nocontrols) append;
reg diff_highemp routine1983 diff_lpiinv diff_tfp  diff_use diff_caplabor;
outreg2 routine1983 diff_lpiinv diff_tfp diff_use diff_caplabor using ${z}table1_r1, nolabel ctitle(Level-High) append;

reg diff_penmod routine1983;
outreg2 routine1983 using ${z}table1_r1, nolabel ctitle(ImportPen) append;
reg diff_penmod routine1983 diff_lpiinv diff_tfp  diff_use diff_caplabor;
outreg2 routine1983 diff_lpiinv diff_tfp diff_use diff_caplabor using ${z}table1_r1, nolabel ctitle(ImportPen) append;
log close;

exit;
