
use lpsraw.dta, clear

gen omth=month(close_dt)
gen oyr=year(close_dt)

rename prop_state state

merge m:1 state using uniformstate.dta 
gen match=0
replace match=1 if _merge==3
drop _merge
foreach num of numlist 1/4 {
  foreach yr of numlist 2000/2007 {
    rename installment_`num'_`yr' st_installment_`num'_`yr'
	 }
  }

merge m:1 prop_zip using uniformcountyborough.dta 
replace match=1 if _merge==3
drop _merge
foreach num of numlist 1/4 { 
  foreach yr of numlist 2000/2007 { 
    rename Installment_`num'_`yr' installment_`num'_`yr' 
	 } 
  } 

drop if match==0

foreach num of numlist 1/4 {
  foreach yr of numlist 2000/2007 {
    replace installment_`num'_`yr'=st_installment_`num'_`yr' if ///
	         st_installment_`num'_`yr'!=.
	 }
  }

gen fyr=oyr
gen fmth=omth

*** code to create variable equal to # months b/t birthday and 1st property tax due date 
*** need to account for annual, bi-annual, or quad-annual due dates 
foreach yr of numlist 1999/2008 { 
  foreach inst of numlist 1/4 { 
    gen t`inst'_yr`yr'=year(installment_`inst'_`yr') 
     gen t`inst'_mth`yr'=month(installment_`inst'_`yr') 
     } 
  } 

* calculate birthday at each installment date 
foreach yr of numlist 1999/2008 { 
  foreach i of numlist 1/4 { 
    gen age`i'_`yr'=(t`i'_yr`yr' - fyr)*12 + (t`i'_mth`yr'-fmth+1)  
	 * if fyr <= `yr' 
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

gen installnum=1 
replace installnum=2 if installment_2_2007!=. & installment_3_2007==. & installment_4_2007==. 
replace installnum=3 if installment_2_2007!=. & installment_3_2007!=. & installment_4_2007==. 
replace installnum=4 if installment_2_2007!=. & installment_3_2007!=. & installment_4_2007!=. 

gen proptax_inc=proptax2004/income2004
gen propbill=proptax2004/installnum
gen prop_inc2004=propbill/income2004 

gen month=omth
gen year=oyr
sort fips month year
merge m:1 fips month year using ue.dta, keep(1 3) nogen
drop state_fips laborforce employed unemployed county_fips
rename unemployrate unemployrate0
replace year=fyr+1
merge m:1 fips month year using ue.dta, keep(1 3) nogen
drop state_fips laborforce employed unemployed county_fips
rename unemployrate unemployrate12
drop month year
gen month=duemth
gen year=fyr+1 if fmth>duemth
replace year=fyr if fmth<=duemth
merge m:1 fips month year using ue.dta, keep(1 3) nogen
drop state_fips laborforce employed unemployed county_fips
rename unemployrate unemployrate_due

gen ue_12mo=unemployrate12-unemployrate0
gen ue_pre=unemployrate_due-unemployrate0
gen ue_post=unemployrate12-unemployrate_due

xtile xtile_appraisal_amt=appraisal_amt , nq(5)

gen ltv_ratio_sq=ltv_ratio^2
gen mtmltv_sq=mtmltv^2

xtile xtile_prop_inc2004=prop_inc2004 , nq(5) 

xtile p_ue_pre=ue_pre, nq(2)
xtile p_ue_post=ue_post, nq(2)

save lps.dta, replace