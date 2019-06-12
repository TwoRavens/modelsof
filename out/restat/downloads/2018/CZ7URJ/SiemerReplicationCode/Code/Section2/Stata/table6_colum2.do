
clear
set more off


cd "yourresultpath"
log using table6_column1_and_3, replace
use "yourpath2\0709all.dta"


merge m:1 sic using "Data\Stata\EFD_low_and_high.dta"
keep if _merge==1 | _merge==3
drop _merge 


local varlist hpi_gr0206 pop_gr0206 ur_gr0206  income_gr0206 lf_gr0206 const_share_gr0206  

foreach var of local varlist {

rename `var'_firm=`var'

}


/* create a number of variables and interactions */ 
gen growthrate=growthrate_0709
drop state_fips
gen state_fips=floor(fips/1000)
gen double state_industry=state_fips*100+sic2
gen county_industry=fips*100+sic2
gen naics4=floor(naics/100)
gen double county_naics4=fips*10000+naics4
gen double county_naics3=fips*10000+naics3
gen double state_naics4=state_fips*10000+naics4
gen double state_naics3=state_fips*10000+naics3


gen younghigh_alt=young_alt*high
gen smallhigh=small*high
gen largehigh=large*high
gen large_50=0
replace large_50=1 if small==0
gen large_50high=large_50*high
gen large_50younghigh=large_50*young*high
gen large_50young=large_50*young
gen mediumhigh=medium*high
gen youngsmall=young*small
gen youngsmall_alt=young_alt*small
gen youngsmallhigh= young*small*high
gen youngsmallhigh_alt= young_alt*small*high
gen largeyoung=large*young
gen mediumyoung=medium*young
gen largeyounghigh=largeyoung*high
gen mediumyounghigh=mediumyoung*high
gen largeyoung_alt=large*young_alt
gen mediumyoung_alt=medium*young_alt
gen largeyounghigh_alt=largeyoung_alt*high
gen mediumyounghigh_alt=mediumyoung_alt*high
gen medium_duygan_bump=0
replace medium_duygan_bump=1 if small_duygan_bump==0 & large==0
gen medium_duygan_bumphigh=medium_duygan_bump*high
gen medium_duygan_bumpyoung=medium_duygan_bump*young
gen medium_duygan_bumpyounghigh=medium_duygan_bump*young*high
 gen youngsmall_duygan_bump=small_duygan_bump*young
 gen youngsmall_duygan_bumphigh=youngsmall_duygan_bump*high
 gen large_duygan_bumpyounghigh=large_duygan_bump*young*high
  gen large_duygan_bumpyoung=large_duygan_bump*young

  
  
gen old=0
replace old=1 if young==0
gen oldhigh=old*high

gen old_alt=0
replace old_alt=1 if young_alt==0
gen oldhigh_alt=old_alt*high


forval i=6 {
capture erase table`i'_column2.tex
capture erase table`i'_column2.txt
capture erase table`i'_column2.xml
capture erase table`i'_column2.rtf
capture erase table`i'_column2.doc
capture erase table`i'_column2.xls



}



local varlist hpi_gr0206 pop_gr0206 const_share_gr0206  ur_gr0206 income_gr0206 lf_gr0206  const_share_firm2006 ur_firm2004 income_firm2004 pov_firm2004 p_nonwhite_firm2004 p_less_hs_firm2004 p_college_firm2004

foreach var of local varlist{
gen `var'high=`var'*high
}


foreach var of local varlist{
gen `var'small=`var'*small
gen `var'large=`var'*large
gen `var'young=`var'*young
}

local varcontrol "hpi_gr0206 pop_gr0206 const_share_gr0206 const_share_firm2006 ur_gr0206 income_gr0206 lf_gr0206 ur_firm2004 income_firm2004 pov_firm2004 p_nonwhite_firm2004 p_less_hs_firm2004 p_college_firm2004"
 local listinteract "hpi_gr0206large pop_gr0206large ur_gr0206large income_gr0206large lf_gr0206large ur_firm2004large income_firm2004large pov_firm2004large p_nonwhite_firm2004large p_less_hs_firm2004large p_college_firm2004large hpi_gr0206small pop_gr0206small ur_gr0206small income_gr0206small lf_gr0206small ur_firm2004small income_firm2004small pov_firm2004small p_nonwhite_firm2004small p_less_hs_firm2004small p_college_firm2004small"

 local listinteract2 "hpi_gr0206young pop_gr0206young ur_gr0206young income_gr0206young lf_gr0206young ur_firm2004young income_firm2004young pov_firm2004young p_nonwhite_firm2004young p_less_hs_firm2004young p_college_firm2004young"





local varcontrol "hpi_gr0206 pop_gr0206 const_share_gr0206 const_share_firm2006 ur_gr0206 income_gr0206 lf_gr0206 ur_firm2004 income_firm2004 pov_firm2004 p_nonwhite_firm2004 p_less_hs_firm2004 p_college_firm2004"
 local listinteract "hpi_gr0206large pop_gr0206large ur_gr0206large income_gr0206large lf_gr0206large ur_firm2004large income_firm2004large pov_firm2004large p_nonwhite_firm2004large p_less_hs_firm2004large p_college_firm2004large hpi_gr0206small pop_gr0206small ur_gr0206small income_gr0206small lf_gr0206small ur_firm2004small income_firm2004small pov_firm2004small p_nonwhite_firm2004small p_less_hs_firm2004small p_college_firm2004small"

 local listinteract2 "hpi_gr0206young pop_gr0206young ur_gr0206young income_gr0206young lf_gr0206young ur_firm2004young income_firm2004young pov_firm2004young p_nonwhite_firm2004young p_less_hs_firm2004young p_college_firm2004young"
 
 
local varreg "small smallhigh  large largehigh medium high  "
areg growthrate `varreg'  `listinteract'  `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table6_column2, keep(`varreg'  `listinteract'  `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append tex(frag) excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"
areg growthrate `varreg'  `listinteract2'  `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table6_column2, keep(`varreg'   `listinteract2'  `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append tex(frag) excel



local varreg "small smallhigh young younghigh high old oldhigh large largehigh medium "

areg growthrate `varreg'  `listinteract' `listinteract2'  `varcontrol', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table6_column2, keep(`varreg' `listinteract' `listinteract2'  `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append tex(frag) excel




log close 



