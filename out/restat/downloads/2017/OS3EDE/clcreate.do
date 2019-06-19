clear 
clear matrix 
clear mata 
set matsize 5000 
set maxvar 32000 
set more off 

capture log close 
log using clcreate.log, replace

use clraw.dta, clear

destring purpose oyr omth fyr fmth , replace

foreach yr of numlist 1999/2008 {
  foreach inst of numlist 1/4 {
    gen t`inst'_yr`yr'=year(installment_`inst'_`yr')
     gen t`inst'_mth`yr'=month(installment_`inst'_`yr')
     }
  }
  
foreach yr of numlist 1999/2008 {
  foreach i of numlist 1/4 {
    gen age`i'_`yr'=(t`i'_yr`yr' - fyr)*12 + (t`i'_mth`yr'-fmth+1) 
     replace age`i'_`yr'=. if age`i'_`yr'<=0
     }
  }
gen agedue1=.
foreach yr of numlist 1999/2008 { 
  foreach inst of numlist 1/4 {
    replace agedue1=age`inst'_`yr' if age`inst'_`yr'<agedue1 
     }
  }

foreach yr of numlist 1999/2008 {
  foreach inst of numlist 1/4 {
    replace age`inst'_`yr'=. if agedue1==age`inst'_`yr'
     }
  }

gen agegrp=.
replace agegrp=1 if agedue1>=1 & agedue1<=3
replace agegrp=2 if agedue1>=4 & agedue1<=6
replace agegrp=3 if agedue1>=7 & agedue1<=9
replace agegrp=4 if agedue1>=10 

gen duemth=.
replace duemth=agedue1+fmth-1
replace duemth=duemth-12 if duemth>12

sort prop_zip
merge m:1 prop_zip using proptaxamt2004.dta, keep(1 3) nogen

drop zip
gen str zip=prop_zip
destring zip, replace
sort zip
merge m:1 zip using countyzip.dta, keep(1 3) nogen
gen month=fmth
gen year=fyr
sort fips month year
merge m:1 fips month year using ue.dta, keep(1 3) nogen
foreach var of varlist state_fips laborforce employed unemployed unemployrate county_fips {
  rename `var' `var'0
  }
replace year=fyr+1
merge m:1 fips month year using ue.dta, keep(1 3) nogen
foreach var of varlist state_fips laborforce employed unemployed unemployrate county_fips {
  rename `var' `var'12
  }
drop month year

gen installnum=1 
replace installnum=2 if installment_2_2007!=. & installment_3_2007==. & installment_4_2007==. 
replace installnum=3 if installment_2_2007!=. & installment_3_2007!=. & installment_4_2007==. 
replace installnum=4 if installment_2_2007!=. & installment_3_2007!=. & installment_4_2007!=. 

gen proptax_inc=proptax2004/income2004
gen propbill=proptax2004/installnum
gen prop_inc2004=propbill/income2004 

gen dti_b=under_rat1 if under_rat1!=0

gen month=duemth
gen year=fyr+1 if fmth>duemth
replace year=fyr if fmth<=duemth
merge m:1 fips month year using ue.dta, keep(1 3) nogen
foreach var of varlist state_fips laborforce employed unemployed unemployrate county_fips {
  rename `var' `var'_due
  }

gen ue_12mo=unemployrate12-unemployrate0
gen ue_pre=unemployrate_due-unemployrate0
gen ue_post=unemployrate12-unemployrate_due

replace sale_price=. if sale_price==0
xtile xtile_sale_price=sale_price , nq(5)

xtile p_ue_pre=ue_pre, nq(2)
xtile p_ue_post=ue_post, nq(2)

xtile xtile_prop_inc2004=prop_inc2004 , nq(5) 
xtile xtile_proptax_inc=proptax_inc , nq(5) 

xtile xtile_hpa=hpa , nq(5) 

gen sum_ltv=first_ltv + second_ltv
gen cltv=max(ltv,first_ltv,comb_ltv,sum_ltv)
gen second_lien=0
replace second_lien=1 if cltv>ltv & cltv!=.

*** need a value for hpi_0 ***
rename omth mth
rename oyr yr
drop zip
gen str zip=prop_zip
destring zip , replace
sort zip yr mth
merge m:1 zip yr mth using hpdata, keep(1 3) nogen
sort state yr mth
merge m:1 state yr mth using hpdata_s, keep(1 3) nogen
replace lphpiz=lphpis if lphpiz==.
rename lphpiz hpi0
rename mth omth
rename yr oyr

*** need a value for hpi at due date 
gen dueyr=.
replace dueyr=fyr if fmth<=duemth
replace dueyr=fyr+1 if fmth>duemth & fmth!=.
gen mth=duemth
rename dueyr yr
sort zip yr mth
merge m:1 zip yr mth using hpdata, keep(1 3) nogen
sort state yr mth
merge m:1 state yr mth using hpdata_s, keep(1 3) nogen
replace lphpiz=lphpis if lphpiz==.
drop mth dueyr

gen cltv_adj=cltv*hpi0/lphpiz

foreach var of varlist cltv cltv_adj {
  gen grp_`var'=1 if `var'<80 
  replace grp_`var'=2 if `var'>=80 & `var'<90 
  replace grp_`var'=3 if `var'>=90 & `var'<100 
  replace grp_`var'=4 if `var'>=100 & `var'<110 
  replace grp_`var'=5 if `var'>=110 & `var'<. 
  } 

save cl.dta, replace

log close
