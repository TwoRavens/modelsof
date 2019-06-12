clear *
set more off
set matsize 4000

cd "/Users/kevinrinz/Box Sync/Research/Milwaukee Vouchers/Published Tables"

global data "Data"
global output "Output"

* Load data
foreach f in 2mi 3mi 1mi {
use "$data/assembled_data_`f'.dta", clear
quietly {
* Additional Data Prep
forvalues y = 1/14 {
	gen SY_`y' = Y_`y'*school
}

replace accused = 0 if accused==.

gen consistent = isschool==1 & use_schools==1 & r_p_nsexp!=. & r_p_nsexp>=0 & r_p_nsrev!=. & r_p_nsrev>=0 & r_offertory!=.
gen consistent2 = use_all==1 & r_p_nsexp!=. & r_p_nsexp>=0 & r_p_nsrev!=. & r_p_nsrev>=0 & r_offertory!=.

xtset groupid year
capture gen f1_eligfam1st_money = F1.eligfam1st_money
replace f1_eligfam1st_money = ((i_fpl300count1st*100)*(6442/.9841363))/1000 if (milwaukee==1 | racine==1) & year==2012 /* 2013 */
replace f1_eligfam1st_money = ((i_fpl185count1st*100)*(6442/.9841363))/1000 if milwaukee==0 & racine==0 & year==2012 /* 2013 */
capture gen f1_eligfam1st_money_X_school = f1_eligfam1st_money*school
capture gen f1_eligfam1st_money_X_noschool = f1_eligfam1st_money*noschool

capture gen f2_eligfam1st_money = F2.eligfam1st_money
replace f2_eligfam1st_money = ((i_fpl300count1st*100)*(6442/.9841363))/1000 if (milwaukee==1 | racine==1) & year==2011 /* 2013 */
replace f2_eligfam1st_money = ((i_fpl300count1st*100)*7210)/1000 if (milwaukee==1 | racine==1) & year==2012 /* 2014 */
replace f2_eligfam1st_money = ((i_fpl185count1st*100)*(6442/.9841363))/1000 if milwaukee==0 & racine==0 & year==2011 /* 2013 */
replace f2_eligfam1st_money = ((i_fpl185count1st*100)*7210)/1000 if milwaukee==0 & racine==0 & year==2012 /* 2014 */
capture gen f2_eligfam1st_money_X_school = f2_eligfam1st_money*school
capture gen f2_eligfam1st_money_X_noschool = f2_eligfam1st_money*noschool

capture gen f3_eligfam1st_money = F3.eligfam1st_money
replace f3_eligfam1st_money = ((i_fpl300count1st*100)*(6442/.9841363))/1000 if (milwaukee==1 | racine==1) & year==2010 /* 2013 */
replace f3_eligfam1st_money = ((i_fpl300count1st*100)*7210)/1000 if (milwaukee==1 | racine==1) & year==2011 /* 2014 */
replace f3_eligfam1st_money = ((i_fpl300count1st*100)*(7214/1.001197))/1000 if (milwaukee==1 | racine==1) & year==2012 /* 2015 */
replace f3_eligfam1st_money = ((i_fpl185count1st*100)*(6442/.9841363))/1000 if milwaukee==0 & racine==0 & year==2010 /* 2013 */
replace f3_eligfam1st_money = ((i_fpl185count1st*100)*7210)/1000 if milwaukee==0 & racine==0 & year==2011 /* 2014 */
replace f3_eligfam1st_money = ((i_fpl185count1st*100)*(7214/1.001197))/1000 if milwaukee==0 & racine==0 & year==2012 /* 2015 */
capture gen f3_eligfam1st_money_X_school = f3_eligfam1st_money*school
capture gen f3_eligfam1st_money_X_noschool = f3_eligfam1st_money*noschool

capture gen f4_eligfam1st_money = F4.eligfam1st_money
replace f4_eligfam1st_money = ((i_fpl300count1st*100)*(6442/.9841363))/1000 if (milwaukee==1 | racine==1) & year==2009 /* 2013 */
replace f4_eligfam1st_money = ((i_fpl300count1st*100)*7210)/1000 if (milwaukee==1 | racine==1) & year==2010 /* 2014 */
replace f4_eligfam1st_money = ((i_fpl300count1st*100)*(7214/1.001197))/1000 if (milwaukee==1 | racine==1) & year==2011 /* 2015 */
replace f4_eligfam1st_money = ((i_fpl300count1st*100)*(7323/1.013964))/1000 if (milwaukee==1 | racine==1) & year==2012 /* 2016 */
replace f4_eligfam1st_money = ((i_fpl185count1st*100)*(6442/.9841363))/1000 if milwaukee==0 & racine==0 & year==2009 /* 2013 */
replace f4_eligfam1st_money = ((i_fpl185count1st*100)*7210)/1000 if milwaukee==0 & racine==0 & year==2010 /* 2014 */
replace f4_eligfam1st_money = ((i_fpl185count1st*100)*(7214/1.001197))/1000 if milwaukee==0 & racine==0 & year==2011 /* 2015 */
replace f4_eligfam1st_money = ((i_fpl185count1st*100)*(7323/1.013964))/1000 if milwaukee==0 & racine==0 & year==2012 /* 2016 */
capture gen f4_eligfam1st_money_X_school = f4_eligfam1st_money*school
capture gen f4_eligfam1st_money_X_noschool = f4_eligfam1st_money*noschool

capture gen f5_eligfam1st_money = F5.eligfam1st_money
replace f5_eligfam1st_money = ((i_fpl300count1st*100)*(6442/.9841363))/1000 if (milwaukee==1 | racine==1) & year==2008 /* 2013 */
replace f5_eligfam1st_money = ((i_fpl300count1st*100)*7210)/1000 if (milwaukee==1 | racine==1) & year==2009 /* 2014 */
replace f5_eligfam1st_money = ((i_fpl300count1st*100)*(7214/1.001197))/1000 if (milwaukee==1 | racine==1) & year==2010 /* 2015 */
replace f5_eligfam1st_money = ((i_fpl300count1st*100)*(7323/1.013964))/1000 if (milwaukee==1 | racine==1) & year==2011 /* 2016 */
replace f5_eligfam1st_money = ((i_fpl300count1st*100)*(7530/1.035684))/1000 if (milwaukee==1 | racine==1) & year==2012 /* 2017 */
replace f5_eligfam1st_money = ((i_fpl185count1st*100)*(6442/.9841363))/1000 if milwaukee==0 & racine==0 & year==2008 /* 2013 */
replace f5_eligfam1st_money = ((i_fpl185count1st*100)*7210)/1000 if milwaukee==0 & racine==0 & year==2009 /* 2014 */
replace f5_eligfam1st_money = ((i_fpl185count1st*100)*(7214/1.001197))/1000 if milwaukee==0 & racine==0 & year==2010 /* 2015 */
replace f5_eligfam1st_money = ((i_fpl185count1st*100)*(7323/1.013964))/1000 if milwaukee==0 & racine==0 & year==2011 /* 2016 */
replace f5_eligfam1st_money = ((i_fpl185count1st*100)*(7530/1.035684))/1000 if milwaukee==0 & racine==0 & year==2012 /* 2017 */
capture gen f5_eligfam1st_money_X_school = f5_eligfam1st_money*school
capture gen f5_eligfam1st_money_X_noschool = f5_eligfam1st_money*noschool

capture gen l1_eligfam1st_money = L1.eligfam1st_money
replace l1_eligfam1st_money = ((i_fpl175count1st*100)*(4894/.6886592))/1000 if milwaukee==1 & year==1999 /* 1998 */
replace l1_eligfam1st_money = 0 if milwaukee==0 & year==1999
capture gen l1_eligfam1st_money_X_school = l1_eligfam1st_money*school
capture gen l1_eligfam1st_money_X_noschool = l1_eligfam1st_money*noschool

capture gen l2_eligfam1st_money = L2.eligfam1st_money
replace l2_eligfam1st_money = ((i_fpl175count1st*100)*(4696/.6781679))/1000 if milwaukee==1 & year==1999 /* 1997 */
replace l2_eligfam1st_money = ((i_fpl175count1st*100)*(4894/.6886592))/1000 if milwaukee==1 & year==2000 /* 1998 */
replace l2_eligfam1st_money = 0 if milwaukee==0 & year==1999
replace l2_eligfam1st_money = 0 if milwaukee==0 & year==2000
capture gen l2_eligfam1st_money_X_school = l2_eligfam1st_money*school
capture gen l2_eligfam1st_money_X_noschool = l2_eligfam1st_money*noschool

capture gen l3_eligfam1st_money = L3.eligfam1st_money
replace l3_eligfam1st_money = ((i_fpl175count1st*100)*(4373/.6626774))/1000 if milwaukee==1 & year==1999 /* 1996 */
replace l3_eligfam1st_money = ((i_fpl175count1st*100)*(4696/.6781679))/1000 if milwaukee==1 & year==2000 /* 1997 */
replace l3_eligfam1st_money = ((i_fpl175count1st*100)*(4894/.6886592))/1000 if milwaukee==1 & year==2001 /* 1998 */
replace l3_eligfam1st_money = 0 if milwaukee==0 & year==1999
replace l3_eligfam1st_money = 0 if milwaukee==0 & year==2000
replace l3_eligfam1st_money = 0 if milwaukee==0 & year==2001
capture gen l3_eligfam1st_money_X_school = l3_eligfam1st_money*school
capture gen l3_eligfam1st_money_X_noschool = l3_eligfam1st_money*noschool

capture gen l4_eligfam1st_money = L4.eligfam1st_money
replace l4_eligfam1st_money = ((i_fpl175count1st*100)*(3667/.6437719))/1000 if milwaukee==1 & year==1999 /* 1995 */
replace l4_eligfam1st_money = ((i_fpl175count1st*100)*(4373/.6626774))/1000 if milwaukee==1 & year==2000 /* 1996 */
replace l4_eligfam1st_money = ((i_fpl175count1st*100)*(4696/.6781679))/1000 if milwaukee==1 & year==2001 /* 1997 */
replace l4_eligfam1st_money = ((i_fpl175count1st*100)*(4894/.6886592))/1000 if milwaukee==1 & year==2002 /* 1998 */
replace l4_eligfam1st_money = 0 if milwaukee==0 & year==1999
replace l4_eligfam1st_money = 0 if milwaukee==0 & year==2000
replace l4_eligfam1st_money = 0 if milwaukee==0 & year==2001
replace l4_eligfam1st_money = 0 if milwaukee==0 & year==2002
capture gen l4_eligfam1st_money_X_school = l4_eligfam1st_money*school
capture gen l4_eligfam1st_money_X_noschool = l4_eligfam1st_money*noschool

capture gen l5_eligfam1st_money = L5.eligfam1st_money
replace l5_eligfam1st_money = ((i_fpl175count1st*100)*(3209/.6262043))/1000 if milwaukee==1 & year==1999 /* 1994 */
replace l5_eligfam1st_money = ((i_fpl175count1st*100)*(3667/.6437719))/1000 if milwaukee==1 & year==2000 /* 1995 */
replace l5_eligfam1st_money = ((i_fpl175count1st*100)*(4373/.6626774))/1000 if milwaukee==1 & year==2001 /* 1996 */
replace l5_eligfam1st_money = ((i_fpl175count1st*100)*(4696/.6781679))/1000 if milwaukee==1 & year==2002 /* 1997 */
replace l5_eligfam1st_money = ((i_fpl175count1st*100)*(4894/.6886592))/1000 if milwaukee==1 & year==2003 /* 1998 */
replace l5_eligfam1st_money = 0 if milwaukee==0 & year==1999
replace l5_eligfam1st_money = 0 if milwaukee==0 & year==2000
replace l5_eligfam1st_money = 0 if milwaukee==0 & year==2001
replace l5_eligfam1st_money = 0 if milwaukee==0 & year==2002
replace l5_eligfam1st_money = 0 if milwaukee==0 & year==2003
capture gen l5_eligfam1st_money_X_school = l5_eligfam1st_money*school
capture gen l5_eligfam1st_money_X_noschool = l5_eligfam1st_money*noschool

global dd_depvars s_exp s_rev p_nsexp p_nsrev p_opexp p_oprev offertory
global ddd_depvars p_nsexp p_nsrev offertory
global ddvars eligfam1st_money
global dddvars eligfam1st_money_X_school eligfam1st_money_X_noschool school
global f1_ddvars eligfam1st_money f1_eligfam1st_money
global f1_dddvars eligfam1st_money_X_school eligfam1st_money_X_noschool f1_eligfam1st_money_X_school f1_eligfam1st_money_X_noschool school
global f2_ddvars eligfam1st_money f2_eligfam1st_money
global f2_dddvars eligfam1st_money_X_school eligfam1st_money_X_noschool f2_eligfam1st_money_X_school f2_eligfam1st_money_X_noschool school
global f3_ddvars eligfam1st_money f3_eligfam1st_money
global f3_dddvars eligfam1st_money_X_school eligfam1st_money_X_noschool f3_eligfam1st_money_X_school f3_eligfam1st_money_X_noschool school
global f123_ddvars eligfam1st_money f1_eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money
global f123_dddvars eligfam1st_money_X_school eligfam1st_money_X_noschool f1_eligfam1st_money_X_school f2_eligfam1st_money_X_school f3_eligfam1st_money_X_school f1_eligfam1st_money_X_noschool f2_eligfam1st_money_X_noschool f3_eligfam1st_money_X_noschool school
global f234_dddvars eligfam1st_money_X_school eligfam1st_money_X_noschool f2_eligfam1st_money_X_school f3_eligfam1st_money_X_school f4_eligfam1st_money_X_school f2_eligfam1st_money_X_noschool f3_eligfam1st_money_X_noschool f4_eligfam1st_money_X_noschool school
global ll1_ddvars l1_eligfam1st_money eligfam1st_money f1_eligfam1st_money
global ll2_ddvars l2_eligfam1st_money eligfam1st_money f2_eligfam1st_money
global ll3_ddvars l3_eligfam1st_money eligfam1st_money f3_eligfam1st_money
global ll4_ddvars l4_eligfam1st_money eligfam1st_money f4_eligfam1st_money
global ll1b_ddvars l1_eligfam1st_money f1_eligfam1st_money
global ll2b_ddvars l2_eligfam1st_money f2_eligfam1st_money
global ll3b_ddvars l3_eligfam1st_money f3_eligfam1st_money
global ll4b_ddvars l4_eligfam1st_money f4_eligfam1st_money
global ll12_ddvars l2_eligfam1st_money l1_eligfam1st_money eligfam1st_money f1_eligfam1st_money f2_eligfam1st_money
global ll123_ddvars l3_eligfam1st_money l2_eligfam1st_money l1_eligfam1st_money eligfam1st_money f1_eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money
global ll1234_ddvars l4_eligfam1st_money l3_eligfam1st_money l2_eligfam1st_money l1_eligfam1st_money eligfam1st_money f1_eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money f4_eligfam1st_money
global ll12345_ddvars l5_eligfam1st_money l4_eligfam1st_money l3_eligfam1st_money l2_eligfam1st_money l1_eligfam1st_money eligfam1st_money f1_eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money f4_eligfam1st_money f5_eligfam1st_money
global ll23_ddvars l3_eligfam1st_money l2_eligfam1st_money eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money
global ll234_ddvars l4_eligfam1st_money l3_eligfam1st_money l2_eligfam1st_money eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money f4_eligfam1st_money
global ll2345_ddvars l5_eligfam1st_money l4_eligfam1st_money l3_eligfam1st_money l2_eligfam1st_money eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money f4_eligfam1st_money f5_eligfam1st_money
global covars i_share_* i_ur i_rmedfaminc i_educ_lths i_educ_socol i_educ_col i_married i_separated i_widowed i_divorced i_foreign i_lah_noteng accused
global covars_noacc i_share_* i_ur i_rmedfaminc i_educ_lths i_educ_socol i_educ_col i_married i_separated i_widowed i_divorced i_foreign i_lah_noteng
global format "auto(3)"
}

label var r_vouchermoney3 "Voucher Revenue"
label var eligfam1st_money "Potential Voucher Rev"
label var eligfam1st_money_X_school "Potential Voucher Rev, Parish w/ School"
label var eligfam1st_money_X_noschool "Potential Voucher Rev, Parish w/ no School"
label var f2_eligfam1st_money_X_school "2-yr Lead Potential Voucher Rev, Parish w/ School"
label var f2_eligfam1st_money_X_noschool "2-yr Lead Potential Voucher Rev, Parish w/ no School"
label var f3_eligfam1st_money_X_school "3-yr Lead Potential Voucher Rev, Parish w/ School"
label var f3_eligfam1st_money_X_noschool "3-yr Lead Potential Voucher Rev, Parish w/ no School"
label var f4_eligfam1st_money_X_school "4-yr Lead Potential Voucher Rev, Parish w/ School"
label var f4_eligfam1st_money_X_noschool "4-yr Lead Potential Voucher Rev, Parish w/ no School"
label var l4_eligfam1st_money "4-yr Lag Potential Voucher Rev"
label var l3_eligfam1st_money "3-yr Lag Potential Voucher Rev"
label var l2_eligfam1st_money "2-yr Lag Potential Voucher Rev"
label var f2_eligfam1st_money "2-yr Lead Potential Voucher Rev"
label var f3_eligfam1st_money "3-yr Lead Potential Voucher Rev"
label var f4_eligfam1st_money "4-yr Lead Potential Voucher Rev"

mean eligfam1st_money if use_all==1 & eligfam1st_money>0
global scale_`f' = round(_b[eligfam1st_money],.001)
disp "$scale_`f'"

mean eligfam1st_money if isschool==1 & use_schools==1 & eligfam1st_money>0
global scale_`f'_s = round(_b[eligfam1st_money],.001)
disp "$scale_`f'_s"

mean eligfam1st_money if isschool==0 & use_all==1 & eligfam1st_money>0
global scale_`f'_n = round(_b[eligfam1st_money],.001)
disp "$scale_`f'_n"

tempfile data`f'
save `data`f''
}





use `data1mi', clear

* Table 2: Mean Financial Characteristics of Milwaukee Parishes, by Parish Type
global finchar i_r_vouchermoney3 i_r_s_exp3 i_r_s_rev3 i_r_p_nsexp3 i_r_p_nsrev3 i_r_p_opexp3 i_r_p_oprev3 i_r_offertory3

local tablename table2
mean ${finchar} if use_all==1, cl(groupid)
outreg2 ${finchar} using "$output/`tablename'", replace tex(frag) sortvar(${finchar}) auto(3) noaster label ctitle("All Parishes") nonotes
mean ${finchar} if isschool==1 & use_schools==1, cl(groupid)
outreg2 ${finchar} using "$output/`tablename'", append tex(frag) sortvar(${finchar}) auto(3) noaster label ctitle("Parishes w/, Schools") nonotes
mean ${finchar} if isschool==0 & use_all==1, cl(groupid)
outreg2 ${finchar} using "$output/`tablename'", append tex(frag) sortvar(${finchar}) auto(3) noaster label ctitle("Parishes w/o, Schools") nonotes
mean ${finchar} if voucher_ever==1 & isschool==1 & use_schools==1, cl(groupid)
outreg2 ${finchar} using "$output/`tablename'", append tex(frag) sortvar(${finchar}) auto(3) noaster label ctitle("Parishes w/, Voucher Schools") nonotes
mean ${finchar} if voucher_ever==0 & isschool==1 & use_schools==1, cl(groupid)
outreg2 ${finchar} using "$output/`tablename'", append tex(frag) sortvar(${finchar}) auto(3) noaster label ctitle("Parishes w/, Schools, No Vouchers") nonotes





* Table 3: Effects of Vouchers on Parish Outcomes, All Parishes
local counter = 0
local tablename table3_rf
foreach y in vouchermoney $dd_depvars {
	local counter = `counter'+1
	local varlabel : var label i_r_`y'3
	local varlabel = subinstr("`varlabel'"," ",",",.)
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if use_all==1, cl(groupid)
	if `counter'==1 capture noisily outreg2 eligfam1st_money using "$output/`tablename'", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel')
	if `counter'==1 capture noisily outreg2 eligfam1st_money using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`varlabel')
	if `counter'>1 capture noisily outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel')
	if `counter'>1 capture noisily outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`varlabel')
}

local counter = 0
local tablename table3_iv
foreach y in $dd_depvars {
	local counter = `counter'+1
	local varlabel : var label i_r_`y'3
	local varlabel = subinstr("`varlabel'"," ",",",.)
	capture noisily ivregress 2sls i_r_`y'3 ${covars} Y_* P_* T_* (i_r_vouchermoney3 = eligfam1st_money) if use_all==1, cl(groupid)
	if `counter'==1 capture noisily outreg2 i_r_vouchermoney3 using "$output/`tablename'", replace tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel')
	if `counter'==1 capture noisily outreg2 i_r_vouchermoney3 using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`varlabel')
	if `counter'>1 capture noisily outreg2 i_r_vouchermoney3 using "$output/`tablename'", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel')
	if `counter'>1 capture noisily outreg2 i_r_vouchermoney3 using "$output/`tablename'_scale", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`varlabel')
}





* Table 4: Effects of Vouchers on Parish Outcomes by Presence of a School: Semi-Elasticity Estimates
local nsrevlabel : var label i_r_p_nsrev3
local nsrevlabel = subinstr("`nsrevlabel'"," ",",",.)
local offlabel : var label i_r_offertory3
local offlabel = subinstr("`offlabel'"," ",",",.)
local tablename table4
local outvars eligfam1st_money_X_school eligfam1st_money_X_noschool f2_eligfam1st_money_X_school f2_eligfam1st_money_X_noschool

reg i_r_p_nsrev3 ${dddvars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg i_r_offertory3 ${dddvars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')

reg i_r_p_nsrev3 ${dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg i_r_offertory3 ${dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')

reg i_r_p_nsrev3 ${f2_dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg i_r_offertory3 ${f2_dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')

reg i_r_p_nsrev3 ${f2_dddvars} ${covars} Y_* SY_* P_* T_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg i_r_offertory3 ${f2_dddvars} ${covars} Y_* SY_* P_* T_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')





* Table 5: Further Robustness Results, Parishes with Schools, Semi-Elasticities
local tablename table5
foreach y in p_nsrev offertory {
	local varlabel : var label i_r_`y'3
	local varlabel = subinstr("`varlabel'"," ",",",.)
	
	reg i_r_`y'3 eligfam1st_money Y_* P_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(`varlabel', No RHS)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No RHS)
	
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(`varlabel', No Trends)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Trends)
	
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* TZ_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, ZIP Linear) nonotes nocons ct(`varlabel', Alternate, Trends)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, ZIP Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Alternate, Trends)
	
	reg l_i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Log, Outcome)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Log, Outcome)
	
	reg r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', No Interpolation)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Interpolation)
	
	preserve
	use `data2mi', clear
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 2 miles)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_2mi_s}, replace se=se*${scale_2mi_s}) ct(`varlabel', Community:, 2 miles)
	restore
	
	preserve
	use `data3mi', clear
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 3 miles)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_3mi_s}, replace se=se*${scale_3mi_s}) ct(`varlabel', Community:, 3 miles)
	restore
}





* Table 6: Further Robustness Results, Parishes with Schools, 2SLS
local varlabel : var label i_r_vouchermoney3
local varlabel = subinstr("`varlabel'"," ",",",.)
local tablename table6_vouchermoney

reg i_r_vouchermoney3 eligfam1st_money Y_* P_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons ct(`varlabel', No RHS)
outreg2 eligfam1st_money using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No RHS)

reg i_r_vouchermoney3 eligfam1st_money ${covars} Y_* P_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons ct(`varlabel', No Trends)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Trends)

reg i_r_vouchermoney3 eligfam1st_money ${covars} Y_* P_* TZ_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, ZIP Linear) nonotes nocons ct(`varlabel', Alternate, Trends)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, ZIP Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Alternate, Trends)

reg l_i_r_vouchermoney3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*100, replace se=se*100) ct(`varlabel', Log, Outcome)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Log, Outcome)

reg r_vouchermoney3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons ct(`varlabel', No Bad Data, No Interp)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Bad Data, No Interp)

preserve
use `data2mi', clear
reg i_r_vouchermoney3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 2 miles)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_2mi_s}, replace se=se*${scale_2mi_s}) ct(`varlabel', Community:, 2 miles)
restore

preserve
use `data3mi', clear
reg i_r_vouchermoney3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 3 miles)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_3mi_s}, replace se=se*${scale_3mi_s}) ct(`varlabel', Community:, 3 miles)
restore

local tablename table6
foreach y in p_nsrev offertory {
	use `data1mi', clear
	local varlabel : var label i_r_`y'3
	local varlabel = subinstr("`varlabel'"," ",",",.)
	ivregress 2sls i_r_`y'3 Y_* P_* (i_r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'", replace tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons ct(`varlabel', No RHS)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'_scale", replace tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No RHS)
	
	ivregress 2sls i_r_`y'3 ${covars} Y_* P_* (i_r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons ct(`varlabel', No Trends)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Trends)
	
	ivregress 2sls i_r_`y'3 ${covars} Y_* P_* TZ_* (i_r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, ZIP Linear) nonotes nocons ct(`varlabel', Alternate, Trends)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, ZIP Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Alternate, Trends)
	
	ivregress 2sls l_i_r_`y'3 ${covars} Y_* P_* T_* (i_r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*100, replace se=se*100) ct(`varlabel', Log, Outcome)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Log, Outcome)
	
	ivregress 2sls r_`y'3 ${covars} Y_* P_* T_* (r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 r_vouchermoney3 using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(r_vouchermoney3) sortvar(r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons ct(`varlabel', No Bad Data, No Interp)
	outreg2 r_vouchermoney3 using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(r_vouchermoney3) sortvar(r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Bad Data, No Interp)
	
	preserve
	use `data2mi', clear
	ivregress 2sls i_r_`y'3 ${covars} Y_* P_* T_* (i_r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 2 miles)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_2mi_s}, replace se=se*${scale_2mi_s}) ct(`varlabel', Community:, 2 miles)
	restore
	
	preserve
	use `data3mi', clear
	ivregress 2sls i_r_`y'3 ${covars} Y_* P_* T_* (i_r_vouchermoney3 = eligfam1st_money) if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 3 miles)
	outreg2 i_r_vouchermoney3 using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(i_r_vouchermoney3) sortvar(i_r_vouchermoney3) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_3mi_s}, replace se=se*${scale_3mi_s}) ct(`varlabel', Community:, 3 miles)
	restore
}





* Table 7: Hazard Regressions on Parish Mergers
use "$data/assembled_data_1mi_mergers.dta", clear

set seed 89135763

stset year, id(groupid) failure(closed)

local tablename table7

stcox ${ddvars} ${covars}, vce(bootstrap, reps(200))
outreg2 eligfam1st_money using "$output/`tablename'", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(Parish, Closure)
outreg2 eligfam1st_money using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(Parish, Closure)

stcox ${ddvars}, vce(bootstrap, reps(200))
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(Parish, Closure)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(Parish, Closure)

stset year, id(groupid) failure(merger_involved)

stcox ${ddvars} ${covars}, vce(bootstrap, reps(200))
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(Parish, Merger)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(Parish, Merger)

stcox ${ddvars}, vce(bootstrap, reps(200))
outreg2 eligfam1st_money using "$output/`tablename'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(Parish, Merger)
outreg2 eligfam1st_money using "$output/`tablename'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, No, Parish FEs?, No, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(Parish, Merger)





* Monte Carlo exercise to verify intuition about sample selection
capture postclose mc

set seed 1292018

clear

postfile mc ols olsT areg aregT using "$output/mc_output", replace

forvalues i = 1(1)100 {
	drop _all
	qui set obs 2000 
	gen parish = ceil(_n/10)
	gen count = _n
	bysort parish: gen start = count[1]
	gen time = _n-start+1
	drop start count

	gen treatment = uniform()
	by parish: gen struggle = treatment[1]>.8
	
	scalar alpha = 1.5

	gen giving = rnormal() /*standard normal*/
	qui replace giving = giving - alpha*treatment if struggle==1 /*struggling churches do worse*/

	*Randomly assign vouchers. Vouchers do nothing except affect closures*
	gen vtreat=uniform()
	by parish: gen voucher = vtreat>0.67

	*Closures happen to struggling parishes unless there is a voucher expansion that will happen soon...
	gen closure = struggle==1 & voucher==0 & time>5
	qui drop if closure==1
	
	*But voucher expansion only ever happen after period 5*
	qui replace voucher = 0 if time<=5
	
	qui tab time, gen(T)

	qui regress giving voucher T*, robust cluster(parish)
	local ols = _b[voucher]
	local olsT = `ols'/_se[voucher]

	quietly areg giving voucher T*, absorb(parish) robust cluster(parish)
	local areg = _b[voucher]
	local aregT = `areg'/_se[voucher]

	post mc (`ols') (`olsT') (`areg') (`aregT') 
	}

postclose mc

use "$output/mc_output", clear

sum, detail
*OLS shows a negative bias, parish FEs does not*





* Table A1: Mean Community Characteristics of Milwaukee Parishes, by Parish Type
use `data1mi', clear

global indep i_share_* i_ur i_rmedfaminc i_educ_lths i_educ_socol i_educ_col i_married i_separated i_widowed i_divorced i_foreign i_lah_noteng

label var i_share_white_5_9 "Population share: White, age 5-9"
label var i_share_white_10_14 "Population share: White, age 10-14"
label var i_share_white_15_17 "Population share: White, age 15-17"
label var i_share_white_18_19 "Population share: White, age 18-19"
label var i_share_black_5_9 "Population share: Black, age 5-9"
label var i_share_black_10_14 "Population share: Black, age 10-14"
label var i_share_black_15_17 "Population share: Black, age 15-17"
label var i_share_black_18_19 "Population share: Black, age 18-19"
label var i_share_other_5_9 "Population share: Other, age 5-9"
label var i_share_other_10_14 "Population share: Other, age 10-14"
label var i_share_other_15_17 "Population share: Other, age 15-17"
label var i_share_other_18_19 "Population share: Other, age 18-19"
label var i_share_hispanic_5_9 "Population share: Hispanic, age 5-9"
label var i_share_hispanic_10_14 "Population share: Hispanic, age 10-14"
label var i_share_hispanic_15_17 "Population share: Hispanic, age 15-17"
label var i_share_hispanic_18_19 "Population share: Hispanic, age 18-19"
label var i_ur "Unemployment rate"
label var i_rmedfaminc "Median family income"
label var i_educ_lths "Educational attainment: less than high school"
label var i_educ_hs "Educational attainment: high school"
label var i_educ_socol "Educational attainment: some college"
label var i_educ_col "Educational attainment: college or higher"
label var i_married "Marital status: married"
label var i_separated "Marital status: separated"
label var i_widowed "Marital status: widowed"
label var i_divorced "Marital status: divorced"
label var i_foreign "Share born abroad"
label var i_lah_noteng "Share not speaking English at home"

local tablename tableA1
mean ${indep} if use_all==1, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", replace tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("All Parishes") nonotes
mean ${indep} if use_all==1 & school==1, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", append tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("Parishes w/, Schools") nonotes
mean ${indep} if use_all==1 & school==1 & voucher_ever==1, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", append tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("Parishes w/, Voucher Schools") nonotes
mean ${indep} if use_all==1 & school==1 & voucher_ever==0, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", append tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("Parishes w/, Schools, No Vouchers") nonotes
mean ${indep} if use_all==1 & school==0 & voucher_ever==0, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", append tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("Parishes w/o, Schools") nonotes





* Table A2: Initial Mean Community Characteristics of Milwaukee Parishes, by Exposure to Programs
gen eligfam1st_money_12 = eligfam1st_money if year==2012
bys id: egen pvr12 = mean(eligfam1st_money_12)
sum pvr12 if year==1999, d
gen pvr12_top = pvr12>r(p50)
bys id: egen use_all_full = max(use_all)

local tablename tableA2
mean ${indep} if use_all_full==1 & pvr12_top==0 & year==1999, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", replace tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("Never Exposed to Voucher Program") nonotes
mean ${indep} if use_all_full==1 & pvr12_top==1 & year==1999, cl(groupid)
outreg2 ${indep} using "$output/`tablename'", append tex(frag) sortvar(${indep}) auto(3) noaster label ctitle("Ever Exposed to Voucher Program") nonotes





* Table A3: Effects of Vouchers on Parish Outcomes, All Parishes
*** Produced above for Table 3





* Table A4: Effects of Voucher Expansion on Donations to Other Nonprofits, Semi-Elasticity Estimates
preserve
use "$data/nccs_analysis_sample.dta", clear
append using "$data/nccs_st_analysis_sample.dta"
append using "$data/nccs_bx_analysis_sample.dta"
append using "$data/nccs_small_analysis_sample.dta"

foreach var of varlist E_* T_* Y_* {
	replace `var' = 0 if `var'==.
}

egen id = group(ein)
gen archdiocese = inlist(fips,"55027","55039","55059","55079","55089") | inlist(fips,"55101","55117","55127","55131","55133")

global covars4 i_share_* i_ur i_rmedfaminc i_educ_lths i_educ_socol i_educ_col i_married i_separated i_widowed i_divorced i_foreign i_lah_noteng
global format "auto(3)"

capture log close
log using "$output/pvr_means_by_ntee.txt", replace text
table ntee1 if pvr>0, c(mean pvr n pvr)
log close

local counter = 0
local tablename tableA4a
foreach y in cont {
	foreach c in V H W I C Y Q E U M D T {
		mean pvr if pvr>0 & ntee1=="`c'"
		global scale_ntee = _b[pvr]
		findname Y_* E_* T_* if ntee1=="`c'", any(@>0) local(fetrend)
		local counter = `counter'+1
		reg r`y' pvr ${covars4} `fetrend' if ntee1=="`c'", cl(id)
		if `counter'==1 outreg2 pvr using "$output/`tablename'", replace tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons ct(`c')
		if `counter'==1 outreg2 pvr using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`c')
		if `counter'==1 outreg2 pvr using "$output/`tablename'_scale_b", replace tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_ntee}, replace se=se*${scale_ntee}) ct(`c')
		if `counter'>1 outreg2 pvr using "$output/`tablename'", append tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons ct(`c')
		if `counter'>1 outreg2 pvr using "$output/`tablename'_scale", append tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`c')
		if `counter'>1 outreg2 pvr using "$output/`tablename'_scale_b", append tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_ntee}, replace se=se*${scale_ntee}) ct(`c')
	}
}

local counter = 0
local tablename tableA4b
foreach y in cont {
	foreach c in V H W I C Y Q E U M D T {
		mean pvr if pvr>0 & ntee1=="`c'"
		global scale_ntee = _b[pvr]
		findname Y_* E_* T_* if ntee1=="`c'", any(@>0) local(fetrend)
		local counter = `counter'+1
		reg r`y' pvr ${covars4} `fetrend' if ntee1=="`c'" & archdiocese==1, cl(id)
		if `counter'==1 outreg2 pvr using "$output/`tablename'", replace tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons ct(`c')
		if `counter'==1 outreg2 pvr using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`c')
		if `counter'==1 outreg2 pvr using "$output/`tablename'_scale_b", replace tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_ntee}, replace se=se*${scale_ntee}) ct(`c')
		if `counter'>1 outreg2 pvr using "$output/`tablename'", append tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons ct(`c')
		if `counter'>1 outreg2 pvr using "$output/`tablename'_scale", append tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`c')
		if `counter'>1 outreg2 pvr using "$output/`tablename'_scale_b", append tex(frag) label ${format} keep(pvr) sortvar(pvr) addtext(Demog. Controls?, Yes, Year FEs?, Yes, EIN FEs?, Yes, EIN Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_ntee}, replace se=se*${scale_ntee}) ct(`c')
	}
}
restore





* Table A5: Alternate Leads
local nsrevlabel : var label i_r_p_nsrev3
local nsrevlabel = subinstr("`nsrevlabel'"," ",",",.)
local offlabel : var label i_r_offertory3
local offlabel = subinstr("`offlabel'"," ",",",.)
local tablename tableA5
local outvars eligfam1st_money_X_school eligfam1st_money_X_noschool f2_eligfam1st_money_X_school f3_eligfam1st_money_X_school f4_eligfam1st_money_X_school f2_eligfam1st_money_X_noschool f3_eligfam1st_money_X_noschool f4_eligfam1st_money_X_noschool

reg i_r_p_nsrev3 ${f234_dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg i_r_offertory3 ${f234_dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')





* Table A6: Leads and Lags for the Full Sample
local nsrevlabel : var label i_r_p_nsrev3
local nsrevlabel = subinstr("`nsrevlabel'"," ",",",.)
local offlabel : var label i_r_offertory3
local offlabel = subinstr("`offlabel'"," ",",",.)
local tablename tableA6
local outvars l4_eligfam1st_money l3_eligfam1st_money l2_eligfam1st_money eligfam1st_money f2_eligfam1st_money f3_eligfam1st_money f4_eligfam1st_money

reg i_r_p_nsrev3 ${ll234_ddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
outreg2 `outvars' using "$output/`tablename'", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None) nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`nsrevlabel')

reg i_r_offertory3 ${ll234_ddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None) nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi}, replace se=se*${scale_1mi}) ct(`offlabel')





* Table A7: 
* Winsorize outcomes
foreach y in $dd_depvars {
	gen w_i_r_`y'3 = i_r_`y'3
	sum i_r_`y'3 if use_all==1, d
	replace w_i_r_`y'3 = r(p5) if w_i_r_`y'3!=. & w_i_r_`y'3<r(p5) & use_all==1
	replace w_i_r_`y'3 = r(p95) if w_i_r_`y'3!=. & w_i_r_`y'3>r(p95) & use_all==1
}
gen w_i_r_vouchermoney3 = i_r_vouchermoney3

foreach y in $dd_depvars {
	gen w2_i_r_`y'3 = i_r_`y'3
	sum i_r_`y'3 if isschool==1 & use_schools==1, d
	replace w2_i_r_`y'3 = r(p5) if w2_i_r_`y'3!=. & w2_i_r_`y'3<r(p5) & isschool==1 & use_schools==1
	replace w2_i_r_`y'3 = r(p95) if w2_i_r_`y'3!=. & w2_i_r_`y'3>r(p95) & isschool==1 & use_schools==1
	sum i_r_`y'3 if isschool==0 & use_all==1, d
	replace w2_i_r_`y'3 = r(p5) if w2_i_r_`y'3!=. & w2_i_r_`y'3<r(p5) & isschool==0 & use_all==1
	replace w2_i_r_`y'3 = r(p95) if w2_i_r_`y'3!=. & w2_i_r_`y'3>r(p95) & isschool==0 & use_all==1
}
gen w2_i_r_vouchermoney3 = i_r_vouchermoney3

local nsrevlabel : var label i_r_p_nsrev3
local nsrevlabel = subinstr("`nsrevlabel'"," ",",",.)
local offlabel : var label i_r_offertory3
local offlabel = subinstr("`offlabel'"," ",",",.)
local tablename tableA7
local outvars eligfam1st_money_X_school eligfam1st_money_X_noschool f2_eligfam1st_money_X_school f2_eligfam1st_money_X_noschool

reg w2_i_r_p_nsrev3 ${dddvars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", replace tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg w2_i_r_offertory3 ${dddvars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')

reg w2_i_r_p_nsrev3 ${dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg w2_i_r_offertory3 ${dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')

reg w2_i_r_p_nsrev3 ${f2_dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg w2_i_r_offertory3 ${f2_dddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, None, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')

reg w2_i_r_p_nsrev3 ${f2_dddvars} ${covars} Y_* SY_* P_* T_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`nsrevlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`nsrevlabel')

reg w2_i_r_offertory3 ${f2_dddvars} ${covars} Y_* SY_* P_* T_* if use_all==1, cl(groupid)
test eligfam1st_money_X_school = eligfam1st_money_X_noschool
local fstat = r(F)
local pval = r(p)
outreg2 `outvars' using "$output/`tablename'", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`offlabel')
outreg2 `outvars' using "$output/`tablename'_scale_n", append tex(frag) label ${format} keep(`outvars') sortvar(`outvars') addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, Yes, Parish Trends?, Linear, "Wald test statistic",`=substr(string(`=round(`fstat',.001)'),1,5)',P-value,`=round(`pval',.001)') nonotes nocons stnum(replace coef=coef*${scale_1mi_n}, replace se=se*${scale_1mi_n}) ct(`offlabel')





* Table A8: 
local tablename tableA8
foreach y in p_nsexp baptisms p_hhs {
	local varlabel : var label i_r_`y'3
	local varlabel = subinstr("`varlabel'"," ",",",.)
	
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(`varlabel', No RHS)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", replace tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, No, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No RHS)
	
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons ct(`varlabel', No Trends)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, None) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Trends)
	
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* TZ_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, ZIP Linear) nonotes nocons ct(`varlabel', Alternate, Trends)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, ZIP Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Alternate, Trends)
	
	reg l_i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Log, Outcome)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', Log, Outcome)
	/*
	reg r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', No Interpolation)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_1mi_s}, replace se=se*${scale_1mi_s}) ct(`varlabel', No Interpolation)
	*/
	preserve
	use `data2mi', clear
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 2 miles)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_2mi_s}, replace se=se*${scale_2mi_s}) ct(`varlabel', Community:, 2 miles)
	restore
	
	preserve
	use `data3mi', clear
	reg i_r_`y'3 eligfam1st_money ${covars} Y_* P_* T_* if isschool==1 & use_schools==1 & consistent==1, cl(groupid)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons ct(`varlabel', Community:, 3 miles)
	outreg2 eligfam1st_money using "$output/`tablename'_`y'_scale", append tex(frag) label ${format} keep(eligfam1st_money) sortvar(eligfam1st_money) addtext(Demog. Controls?, Yes, Year FEs?, Yes, Parish FEs?, Yes, City x Year FEs?, No, School Status x Year FEs?, No, Parish Trends?, Linear) nonotes nocons stnum(replace coef=coef*${scale_3mi_s}, replace se=se*${scale_3mi_s}) ct(`varlabel', Community:, 3 miles)
	restore
}





preserve
import excel using "$data/Baptism_Data_for_figures.xlsx", clear sh("Sheet2") first

* Figure 1: Infant Baptisms in Milwaukee and the US
graph twoway (line us_ind year, lc(black)) || (line milwaukee_ind year, lc(gs8) lp(longdash)), ///
			ytitle("", size(small)) ylabel(50(10)120, labsize(small)) ///
			xtitle("", size(small)) xlabel(1999(1)2011, labsize(small)) ///
			legend(order(1 "US Baptisms" 2 "Milwaukee Baptisms") size(small) ring(0) bplacement(sw) c(1))
graph export "$output/figure1.png", replace





* Figure A1: Baptisms In-Sample and in All of Milwaukee
graph twoway (line sample_ind year, lc(black) lp(shortdash)) || (line milwaukee_ind year, lc(gs8) lp(longdash)), ///
			ytitle("", size(small)) ylabel(50(10)120, labsize(small)) ///
			xtitle("", size(small)) xlabel(1999(1)2011, labsize(small)) ///
			legend(order(1 "Baptisms in Sample" 2 "Baptisms in all Milwaukee") size(small) ring(0) bplacement(sw) c(1))
graph export "$output/figureA1.png", replace

restore





* Figure A2: Pre-Post Coefficients for Potential Voucher Revenue
local figname figureA2

matrix define `figname' = J(7,7,.)
matrix colnames `figname' = x beta_nsr ci95lb_nsr ci95ub_nsr beta_off ci95lb_off ci95ub_off

reg i_r_p_nsrev3 ${ll234_ddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
matrix `figname'[1,1]=-4
matrix `figname'[1,2]=_b[f4_eligfam1st_money]*${scale_1mi}
matrix `figname'[1,3]=(_b[f4_eligfam1st_money]-(invttail(e(df_r),.025)*_se[f4_eligfam1st_money]))*${scale_1mi}
matrix `figname'[1,4]=(_b[f4_eligfam1st_money]+(invttail(e(df_r),.025)*_se[f4_eligfam1st_money]))*${scale_1mi}
matrix `figname'[2,1]=-3
matrix `figname'[2,2]=_b[f3_eligfam1st_money]*${scale_1mi}
matrix `figname'[2,3]=(_b[f3_eligfam1st_money]-(invttail(e(df_r),.025)*_se[f3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[2,4]=(_b[f3_eligfam1st_money]+(invttail(e(df_r),.025)*_se[f3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[3,1]=-2
matrix `figname'[3,2]=_b[f2_eligfam1st_money]*${scale_1mi}
matrix `figname'[3,3]=(_b[f2_eligfam1st_money]-(invttail(e(df_r),.025)*_se[f2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[3,4]=(_b[f2_eligfam1st_money]+(invttail(e(df_r),.025)*_se[f2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[4,1]=0
matrix `figname'[4,2]=_b[eligfam1st_money]*${scale_1mi}
matrix `figname'[4,3]=(_b[eligfam1st_money]-(invttail(e(df_r),.025)*_se[eligfam1st_money]))*${scale_1mi}
matrix `figname'[4,4]=(_b[eligfam1st_money]+(invttail(e(df_r),.025)*_se[eligfam1st_money]))*${scale_1mi}
matrix `figname'[5,1]=2
matrix `figname'[5,2]=_b[l2_eligfam1st_money]*${scale_1mi}
matrix `figname'[5,3]=(_b[l2_eligfam1st_money]-(invttail(e(df_r),.025)*_se[l2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[5,4]=(_b[l2_eligfam1st_money]+(invttail(e(df_r),.025)*_se[l2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[6,1]=3
matrix `figname'[6,2]=_b[l3_eligfam1st_money]*${scale_1mi}
matrix `figname'[6,3]=(_b[l3_eligfam1st_money]-(invttail(e(df_r),.025)*_se[l3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[6,4]=(_b[l3_eligfam1st_money]+(invttail(e(df_r),.025)*_se[l3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[7,1]=4
matrix `figname'[7,2]=_b[l4_eligfam1st_money]*${scale_1mi}
matrix `figname'[7,3]=(_b[l4_eligfam1st_money]-(invttail(e(df_r),.025)*_se[l4_eligfam1st_money]))*${scale_1mi}
matrix `figname'[7,4]=(_b[l4_eligfam1st_money]+(invttail(e(df_r),.025)*_se[l4_eligfam1st_money]))*${scale_1mi}

reg i_r_offertory3 ${ll234_ddvars} ${covars} Y_* SY_* P_* if use_all==1, cl(groupid)
matrix `figname'[1,5]=_b[f4_eligfam1st_money]*${scale_1mi}
matrix `figname'[1,6]=(_b[f4_eligfam1st_money]-(invttail(e(df_r),.025)*_se[f4_eligfam1st_money]))*${scale_1mi}
matrix `figname'[1,7]=(_b[f4_eligfam1st_money]+(invttail(e(df_r),.025)*_se[f4_eligfam1st_money]))*${scale_1mi}
matrix `figname'[2,5]=_b[f3_eligfam1st_money]*${scale_1mi}
matrix `figname'[2,6]=(_b[f3_eligfam1st_money]-(invttail(e(df_r),.025)*_se[f3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[2,7]=(_b[f3_eligfam1st_money]+(invttail(e(df_r),.025)*_se[f3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[3,5]=_b[f2_eligfam1st_money]*${scale_1mi}
matrix `figname'[3,6]=(_b[f2_eligfam1st_money]-(invttail(e(df_r),.025)*_se[f2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[3,7]=(_b[f2_eligfam1st_money]+(invttail(e(df_r),.025)*_se[f2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[4,5]=_b[eligfam1st_money]*${scale_1mi}
matrix `figname'[4,6]=(_b[eligfam1st_money]-(invttail(e(df_r),.025)*_se[eligfam1st_money]))*${scale_1mi}
matrix `figname'[4,7]=(_b[eligfam1st_money]+(invttail(e(df_r),.025)*_se[eligfam1st_money]))*${scale_1mi}
matrix `figname'[5,5]=_b[l2_eligfam1st_money]*${scale_1mi}
matrix `figname'[5,6]=(_b[l2_eligfam1st_money]-(invttail(e(df_r),.025)*_se[l2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[5,7]=(_b[l2_eligfam1st_money]+(invttail(e(df_r),.025)*_se[l2_eligfam1st_money]))*${scale_1mi}
matrix `figname'[6,5]=_b[l3_eligfam1st_money]*${scale_1mi}
matrix `figname'[6,6]=(_b[l3_eligfam1st_money]-(invttail(e(df_r),.025)*_se[l3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[6,7]=(_b[l3_eligfam1st_money]+(invttail(e(df_r),.025)*_se[l3_eligfam1st_money]))*${scale_1mi}
matrix `figname'[7,5]=_b[l4_eligfam1st_money]*${scale_1mi}
matrix `figname'[7,6]=(_b[l4_eligfam1st_money]-(invttail(e(df_r),.025)*_se[l4_eligfam1st_money]))*${scale_1mi}
matrix `figname'[7,7]=(_b[l4_eligfam1st_money]+(invttail(e(df_r),.025)*_se[l4_eligfam1st_money]))*${scale_1mi}

clear
svmat `figname', n(col)

*rbar rcap rspike scatter

graph twoway (rcap ci95lb_nsr ci95ub_nsr x, lc(black) lw(thin) lp(dash)) || ///
			(scatter beta_nsr x, m(X) mc(ceablue)), ///
			legend(off) ///
			title("Pre-Post Coefficients of Non-School Revenue", size(small)) ///
			ytitle("", size(small)) ylabel(, labsize(small)) ///
			xtitle("", size(small)) xlabel(-4(1)4, labsize(small)) ///
			ysize(4) xsize(3) name(nsr, replace)
			
graph twoway (rcap ci95lb_off ci95ub_off x, lc(black) lw(thin) lp(dash)) || ///
			(scatter beta_off x, m(X) mc(ceablue)), ///
			legend(off) ///
			title("Pre-Post Coefficients of Offertory Revenue", size(small)) ///
			ytitle("", size(small)) ylabel(, labsize(small)) ///
			xtitle("", size(small)) xlabel(-4(1)4, labsize(small)) ///
			ysize(4) xsize(3) name(off, replace)

graph combine nsr off, ycommon
graph export "$output/figureA2.png", replace
