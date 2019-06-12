clear all
set more off
set matsize 11000
set maxvar 25000
 
**Aaron Flaaen
**October 22, 2013
**Last Updated: September 08, 2017

**This File Builds the sample for the static Model
**---------------------------------------------------------------------------


**----------------------------------------------------------------------------
**Step 1: Take Quarterly Values for Employment/Payroll, adjust for our periods
**----------------------------------------------------------------------------

**Get Quarterly Employment Payroll
cd $dir 
/*
!gunzip analysisdata_manuf_Q.dta.gz

use analysisdata_manuf_Q.dta, clear
keep firmid year quarter emp pay naics_code
drop if year==2012
drop if year==2009
drop if year==2010 & (quarter==1 | quarter==2)
drop if year==2011 & quarter==4
gen time = 1
replace time = 2 if year==2010 & quarter==4
replace time = 3 if year==2011 & quarter==1
replace time = 4 if year==2011 & quarter==2
replace time = 5 if year==2011 & quarter==3

drop year quarter
reshape wide emp pay naics_code, i(firmid) j(time)

gen pay_tm1 = (1/3)*pay1 + pay2 + (2/3)*pay3
gen pay_t = pay4 + pay5
gen emp_tm1 = (1/6)*emp1 + (1/2)*emp2 + (1/3)*emp3
gen emp_t = (1/2)*emp4 + (1/2)*emp5 
drop if emp_t==. | emp_t==. | pay_tm1==. | pay_t==.
keep firmid pay_tm1 pay_t emp_tm1 emp_t naics_code1
rename naics_code1 naics_code
sort firmid

save quart_emppay.dta, replace
!gzip analysisdata_manuf_Q.dta
*/

**--------------------------------------------------------------------------
**Step 2: Aggregate up Unit Values for Imports
**--------------------------------------------------------------------------
cd $dir

!gunzip analysisdata_manuf_imp_uv.dta.gz
use analysisdata_manuf_imp_uv.dta, clear
!gzip analysisdata_manuf_imp_uv.dta
keep if intm==1
drop if year==2012
drop rel_uv nonrel_uv
collapse (sum) nonrelvalue nonrelqty relvalue relqty, by(firmid month hs baseroot year flag_for_mult flag_us_mult naics_code jpn japan emp pay)
drop baseroot
reshape wide nonrelvalue nonrelqty relvalue relqty, i(firmid month hs flag_for_mult japan flag_us_mult naics_code year emp pay) j(jpn)

rename nonrelvalue0 njimp_nrel
rename nonrelvalue1 jimp_nrel
rename nonrelqty0 njimp_nrel_quant
rename nonrelqty1 jimp_nrel_quant
rename relvalue0 njimp_rel
rename relvalue1 jimp_rel
rename relqty0 njimp_rel_quant
rename relqty1 jimp_rel_quant



foreach var of varlist jimp_rel jimp_rel_quant jimp_nrel jimp_nrel_quant njimp_rel njimp_rel_quant njimp_nrel njimp_nrel_quant {
	replace `var' = 0 if `var'==.
}



**Two Periods of Analysis
gen periods = 0
replace periods = 1 if year==2010 & (month==12 | month==11 | month==10 | month==9)
replace periods = 1 if year==2011 & (month==1 | month==2)
replace periods = 2 if year==2011 & (month==4 | month==5 | month==6 | month==7 | month==8 | month==9)
drop if periods==0

gen emp2010 = emp if year==2010
bys firmid: egen emp20102 = min(emp2010)
drop emp2010
rename emp20102 emp2010

gen emp2011 = emp if year==2011
bys firmid: egen emp20112 = min(emp2011)
drop emp2011
rename emp20112 emp2011

gen pay2010 = pay if year==2010
bys firmid: egen pay20102 = min(pay2010)
drop pay2010
rename pay20102 pay2010

gen pay2011 = pay if year==2011
bys firmid: egen pay20112 = min(pay2011)
drop pay2011
rename pay20112 pay2011


**Calculate number of periods of non-zero imports: for creation of sample
**------------------------------------------------
preserve
gen jimp = jimp_rel + jimp_nrel
gen njimp = njimp_rel + njimp_nrel
collapse (sum) jimp njimp, by(firmid month year periods)

foreach var of varlist jimp njimp {
	gen `var'_num = 0
	replace `var'_num = 1 if `var'>0
	bys firmid periods: egen `var'_num_sum = sum(`var'_num)
}
keep firmid month jimp_num_sum njimp_num_sum periods
drop month
collapse (first) jimp_num_sum njimp_num_sum, by(firmid periods)

reshape wide jimp_num_sum njimp_num_sum, i(firmid) j(periods)

**There are some firms that may not have a transaction in one period (at all)
foreach var of varlist jimp_num_sum* njimp_num_sum* {
	replace `var'=0 if `var'==.
}	

gen insample_imp = 1
replace insample_imp = 0 if jimp_num_sum1<x | jimp_num_sum2<x
replace insample_imp = 0 if njimp_num_sum1<x | njimp_num_sum2<x

keep firmid insample_imp
sort firmid 
save imp_temp.dta, replace
restore

sort firmid
merge m:1 firmid using imp_temp.dta
tab _m
drop _m

**----------------
**we only kept int inputs above, so final_pot is always zero
gen final_pot = 0
collapse (first) insample_imp japan flag_for_mult flag_us_mult naics_code final_pot emp2010 pay2010 emp2011 pay2011 (sum) jimp_rel jimp_rel_quant jimp_nrel jimp_nrel_quant njimp_rel njimp_rel_quant njimp_nrel njimp_nrel_quant, by(firmid periods hs)



**Recalculate unit values
gen jimp_rel_uv = jimp_rel / jimp_rel_quant
gen jimp_nrel_uv = jimp_nrel / jimp_nrel_quant
gen njimp_rel_uv = njimp_rel / njimp_rel_quant
gen njimp_nrel_uv = njimp_nrel / njimp_nrel_quant

**Create weights to aggregate unit values up to level of firm
foreach var of varlist jimp_rel jimp_nrel njimp_rel njimp_nrel {
	bys firmid final_pot periods: egen sum`var' = sum(`var')
	gen `var'_weight = `var' / sum`var'
	
	gen `var'_uv_sum2 = `var'_uv*`var'_weight
	replace `var'_uv_sum2 = 0 if `var'_uv_sum==.

	bys firmid final_pot periods: egen `var'_uv_sum = sum(`var'_uv_sum2)
	drop `var'_uv_sum2
}


collapse (first) insample_imp japan flag_for_mult flag_us_mult naics_code emp2010 pay2010 emp2011 pay2011 jimp_rel_uv_sum jimp_nrel_uv_sum njimp_rel_uv_sum njimp_nrel_uv_sum (sum) jimp_rel jimp_rel_quant jimp_nrel jimp_nrel_quant njimp_rel njimp_rel_quant njimp_nrel njimp_nrel_quant , by(firmid periods)


**One final collapse (that between nrel and rel)
gen jimp = jimp_rel + jimp_nrel
gen njimp = njimp_rel + njimp_nrel

gen jimp_relshare = jimp_rel / jimp
gen njimp_relshare = njimp_rel / njimp

gen jimp_uv_sum = jimp_rel_uv_sum*jimp_relshare + (1-jimp_relshare)*jimp_nrel_uv_sum
gen njimp_uv_sum = njimp_rel_uv_sum*njimp_relshare + (1-njimp_relshare)*njimp_nrel_uv_sum

keep firmid periods jimp_uv_sum njimp_uv_sum jimp njimp insample_imp
sort firmid periods
save imp_firms_static.dta, replace


**--------------------------------------------------------------------------
**Step 3: Aggregate up Unit Values for Exports
**--------------------------------------------------------------------------

!gunzip analysisdata_manuf_exp_uv.dta.gz
use analysisdata_manuf_exp_uv.dta, clear
!gzip analysisdata_manuf_exp_uv.dta
*keep if intm==1
gen final_pot = 0
replace final_pot = 1 if intm==0
drop if year==2012
keep if na==1
drop rel_uv nonrel_uv
collapse (sum) nonrelvalue nonrelqty relvalue relqty, by(firmid month hs baseroot year final_pot flag_for_mult japan flag_us_mult naics_code emp pay)

rename nonrelvalue naexp_nrel
rename nonrelqty naexp_nrel_quant
rename relvalue naexp_rel
rename relqty naexp_rel_quant


foreach var of varlist naexp_rel naexp_rel_quant naexp_nrel naexp_nrel_quant{
	replace `var' = 0 if `var'==.
}

cap drop naexp_rel_uv naexp_nrel_uv

**Two Periods of Analysis
gen periods = 0
replace periods = 1 if year==2010 & (month==12 | month==11 | month==10 | month==9)
replace periods = 1 if year==2011 & (month==1 | month==2)
replace periods = 2 if year==2011 & (month==4 | month==5 | month==6 | month==7 | month==8 | month==9)
drop if periods==0

gen emp2010 = emp if year==2010
bys firmid: egen emp20102 = min(emp2010)
drop emp2010
rename emp20102 emp2010

gen emp2011 = emp if year==2011
bys firmid: egen emp20112 = min(emp2011)
drop emp2011
rename emp20112 emp2011

gen pay2010 = pay if year==2010
bys firmid: egen pay20102 = min(pay2010)
drop pay2010
rename pay20102 pay2010

gen pay2011 = pay if year==2011
bys firmid: egen pay20112 = min(pay2011)
drop pay2011
rename pay20112 pay2011

**Calculate number of periods of non-zero exports: for creation of sample
**------------------------------------------------
preserve
gen naexp = naexp_rel + naexp_nrel
collapse (sum) naexp, by(firmid month periods)

gen naexp_num = 0
replace naexp_num = 1 if naexp>0
bys firmid periods: egen naexp_num_sum = sum(naexp_num)

keep firmid month naexp_num_sum periods
drop month
collapse (first) naexp_num_sum, by(firmid periods)

reshape wide naexp_num_sum, i(firmid) j(periods)

**There are some firms that may not have a transaction in one period (at all)
foreach var of varlist naexp_num_sum* {
	replace `var'=0 if `var'==.
}

gen insample_exp = 1
replace insample_exp = 0 if naexp_num_sum1<x | naexp_num_sum2<x

keep firmid insample_exp
sort firmid 
save exp_temp.dta, replace
restore

sort firmid
merge m:1 firmid using exp_temp.dta
tab _m
drop _m
**----------------

collapse (first) insample_exp baseroot japan flag_for_mult flag_us_mult naics_code final_pot emp2010 pay2010 emp2011 pay2011 (sum) naexp_rel naexp_rel_quant naexp_nrel naexp_nrel_quant  , by(firmid periods hs)

**Recalculate unit values
gen naexp_rel_uv = naexp_rel / naexp_rel_quant
gen naexp_nrel_uv = naexp_nrel / naexp_nrel_quant


**Create weights to aggregate unit values up to level of firm
foreach var of varlist naexp_rel naexp_nrel  {
	bys firmid final_pot periods: egen sum`var' = sum(`var')
	gen `var'_weight = `var' / sum`var'
	
	gen `var'_uv_sum2 = `var'_uv*`var'_weight
	replace `var'_uv_sum2 = 0 if `var'_uv_sum==.

	bys firmid final_pot periods: egen `var'_uv_sum = sum(`var'_uv_sum2)
	drop `var'_uv_sum2
}

collapse (first) insample_exp japan flag_for_mult flag_us_mult naics_code emp2010 pay2010 emp2011 pay2011 naexp_rel_uv_sum naexp_nrel_uv_sum (sum) naexp_rel naexp_rel_quant naexp_nrel naexp_nrel_quant  , by(firmid periods)


**One final collapse (that between nrel and rel)
gen naexp = naexp_rel + naexp_nrel


gen naexp_relshare = naexp_rel / naexp

gen naexp_uv_sum = naexp_rel_uv_sum*naexp_relshare + (1-naexp_relshare)*naexp_nrel_uv_sum


**--------------------------------------------------------------------------
**Step 4: Combine Data
**--------------------------------------------------------------------------

**4.1 Combine Import UVs with Export UVs
keep firmid periods naexp_uv_sum naexp emp2010 emp2011 pay2010 pay2011 japan flag* insample_exp naics*
sort firmid periods
merge 1:1 firmid periods using imp_firms_static.dta
keep if _m==3
drop _m

gen imp_int = njimp + jimp
gen jimp_int = jimp
gen njimp_int = njimp



**4.2 Bring in 2007 cost shares (what to do about firmids that don't exist?)

sort firmid
merge m:1 firmid using cm_shares2007.dta
tab _m
drop if _m==2
drop _m

**Calculate firm-specific alpha
gen alpha_firm = (.15*tae/ww)/(1+(.15*tae/ww))


**CM and SW are in thousands in the CM
replace cm = cm*1000
replace sw = sw*1000


gen cmshare = cm/(cm+sw+sw*0.5)
bys naics_code: egen cmshare_naics = mean(cmshare)
replace cmshare = cmshare_naics if cmshare==. | cmshare==0


**4.3 Bring in Quarterly employment/payroll information
drop naics_code
sort firmid
merge m:1 firmid using quart_emppay.dta
tab _m
drop if _m==2
**im _m==1, then only in 2012??
drop if _m==1
drop _m



gen naics6 = substr(naics_code,1,6)
gen naics4 = substr(naics_code,1,4)
gen naics2 = substr(naics_code,1,2)

**Naics-4-digit alpha code
bys naics4: egen alpha_ind = mean(alpha_firm)



bys naics6: egen cmshare_naics6 = mean(cmshare)
replace cmshare = cmshare_naics6 if cmshare==.

bys naics4: egen cmshare_naics4 = mean(cmshare)
replace cmshare = cmshare_naics4 if cmshare==.

bys naics2: egen cmshare_naics2 = mean(cmshare)
replace cmshare = cmshare_naics2 if cmshare==.
drop cmshare_naics*

**new
gen jimp_imp_share = jimp_int / imp_int

gen impshare = imp_int/(cm+sw+sw*0.5)
replace impshare = . if impshare>0.95

bys naics_code: egen impshare_naics = mean(impshare)
replace impshare = impshare_naics if impshare==.

bys naics6: egen impshare_naics6 = mean(impshare)
replace impshare = impshare_naics6 if impshare==.

bys naics4: egen impshare_naics4 = mean(impshare)
replace impshare = impshare_naics4 if impshare==.

bys naics2: egen impshare_naics2 = mean(impshare)
replace impshare = impshare_naics2 if impshare==.
drop impshare_naics*

**new
gen jimpshare = impshare*jimp_imp_share
drop jimp_imp_share


**Very few that don't have the quarterly values. If not, then use annual
replace emp_t = emp2011 if emp_t==.
replace emp_tm1 = emp2011 if emp_tm1==.
replace pay_t = (1/2)*pay2011 if pay_t==.
replace pay_tm1 = (1/2)*pay2011 if pay_tm1==.


**--------------------------------------------------------------------------
**Step 5: Output Data
**--------------------------------------------------------------------------

gen nonjpnshare = cmshare - jimpshare
**a few are negative ... what to do?
replace nonjpnshare = 0.01 if nonjpnshare<0

gen scale  = nonjpnshare/ (impshare-jimpshare)

**Create industry indicators
gen naics3 = substr(naics_code,1,3)
egen indgroup = group(naics3)


save sample_full_update.dta, replace


**Sample 1: Japanese Firms
use sample_full_update.dta, clear

cd 

keep if japan==1 & insample_exp==1 & insample_imp==1

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000

drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
*keep firmid pay20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 
*order pay20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 firmid
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_jpn_nsU_update.txt, comma nonames replace



**Sample 2: Non-Japanese Multinational Firms
use sample_full_update.dta, clear

keep if japan==0 & insample_exp==1 & insample_imp==1 & (flag_for_mult==1 | flag_us_mult==1)

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000
drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 

duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_nonjpn_nsU_update.txt, comma nonames replace



**Sample 3: Non-Japanese Non-Multinational Firms
use sample_full_update.dta, clear
keep if japan==0 & insample_exp==1 & insample_imp==1 & (flag_for_mult==0 & flag_us_mult==0)

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000
drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_nonmult_nsU_update.txt, comma nonames replace



**Sample 4: ALL
use sample_full_update.dta, clear
keep if insample_exp==1 & insample_imp==1 

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000
drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale alpha_ind, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 alpha_ind1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid alpha_ind1
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_all_nsU_update.txt, comma nonames replace









**Create variable for auto firms
use sample_full_update.dta, clear
capture drop auto
gen auto = 0
replace auto = 1 if substr(naics_code,1,3)=="336"
bys firmid: egen maxauto = max(auto)
drop auto
rename maxauto auto

save sample_full_update_auto.dta, replace


**Sample 5: Auto Japanese
keep if japan==1 & insample_exp==1 & insample_imp==1 & auto==1

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000

drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_jpn_auto_nsU_update.txt, comma nonames replace



**Sample 6: Non-Auto Japanese
use sample_full_update_auto.dta, clear
keep if japan==1 & insample_exp==1 & insample_imp==1 & auto==0
drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000

drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_jpn_nonauto_nsU_update.txt, comma nonames replace




**Sample 7: Auto All
use sample_full_update_auto.dta, clear
keep if insample_exp==1 & insample_imp==1 & auto==1

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000

drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)


**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_all_auto_nsU_update.txt, comma nonames replace



**Sample 8: Non-Auto All
use sample_full_update_auto.dta, clear
keep if insample_exp==1 & insample_imp==1 & auto==0

drop japan insample* flag*

replace pay2011 = pay2011*1000
replace pay_tm1= pay_tm1*1000
replace pay_t= pay_t*1000

drop naics* impshare jimpshare nonjpnshare imp_int jimp_int njimp_int
reshape wide jimp_uv_sum njimp_uv_sum  naexp_uv_sum jimp njimp naexp emp2011 pay2011 cmshare emp_tm1 emp_t pay_tm1 pay_t indgroup scale, i(firmid) j(periods)

**Output matrices
**-------------------------------------------------------
keep firmid pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1
order pay20111 emp20111 naexp1 jimp1 njimp1 njimp_uv_sum1 jimp_uv_sum1 naexp_uv_sum1 naexp2 jimp2 njimp2 njimp_uv_sum2 jimp_uv_sum2 naexp_uv_sum2 cmshare1 emp_tm11 emp_t1 pay_tm11 pay_t1 indgroup1 scale1 firmid 
duplicates drop
sort firmid 
drop firmid
outsheet using sample_static_all_nonauto_nsU_update.txt, comma nonames replace

