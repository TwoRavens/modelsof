
clear
set more off


cd "yourresultpath"
log using table6_column1_and_3, replace
use "yourpath2\0709all.dta"


merge m:1 sic using "Data\Stata\EFD_low_and_high.dta"
keep if _merge==1 | _merge==3
drop _merge 


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
capture erase table`i'_column3.tex
capture erase table`i'_column3.txt
capture erase table`i'_column3.xml
capture erase table`i'_column3.rtf
capture erase table`i'_column3.doc
capture erase table`i'_column3.xls



}





merge m:1 sic2 using "Compustat_controls_all.dta"

drop _merge

merge m:1 sic2 using "growth_by_age_naic.dta"
drop _merge

/*HadlockPierceIndex_ave WW_index_ave*/ 
local compuvar "RnD_intensity capital_intensity advertising_intensity"


foreach var of local compuvar{
gen `var'small=`var'*small
gen `var'large=`var'*large
gen `var'young=`var'*young
}

foreach var of local compuvar{
gen `var'smallhigh=`var'*small*high
gen `var'largehigh=`var'*large*high
gen `var'younghigh=`var'*young*high
}




local controlscompu1 "advertising_intensitylarge  capital_intensitylarge advertising_intensitylarge  RnD_intensity capital_intensity  advertising_intensity  advertising_intensitysmall RnD_intensitysmall capital_intensitysmall"
local controlscompu2 "  RnD_intensity capital_intensity RnD_intensityyoung capital_intensityyoung advertising_intensity advertising_intensityyoung"
local listcontrols  "growth5ysmall growth5ylarge "
local listcontrols3  "growth5ysmall growth5young   growth5yyoungsmall growth5ylarge"
local listcontrols2  "growth5young"


local listinteract "advertising_intensity advertising_intensitysmall advertising_intensitylarge RnD_intensity capital_intensity RnD_intensitysmall capital_intensitysmall RnD_intensitylarge capital_intensitylarge "
local listinteract2 "advertising_intensity advertising_intensityyoung RnD_intensity capital_intensity  RnD_intensityyoung capital_intensityyoung "
local listinteract3 " advertising_intensity advertising_intensitysmall advertising_intensitylarge  advertising_intensityyoung RnD_intensity capital_intensity RnD_intensitysmall capital_intensitysmall RnD_intensitylarge capital_intensitylarge RnD_intensityyoung capital_intensityyoung "





local varreg "small smallhigh high  large medium largehigh "
areg growthrate `varreg'   `listinteract' `listcontrols' `controlscompu1', absorb(_state_industry) vce(cluster state_fips)
outreg2 `varreg' using table6_column3, keep(`varreg' `listinteract' `listcontrols' `controlscompu1' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append tex(frag) excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"
areg growthrate `varreg'  `listinteract2' `listinteract' `listcontrols2'  `controlscompu2', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table6_column3, keep(`varreg' `listinteract2'  `listinteract' `listcontrols2'  `controlscompu2' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append tex(frag) excel


local varreg "small smallhigh young younghigh high old oldhigh large largehigh medium mediumhigh"

areg growthrate `varreg'  `listinteract3' `listcontrols' `listcontrols2' `controlscompu1' `controlscompu2', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table6_column3, keep(`varreg' `listinteract3' `listcontrols' `listcontrols2' `controlscompu1' `controlscompu2') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append tex(frag) excel




log close 



