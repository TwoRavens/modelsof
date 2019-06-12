
clear
set more off


cd "yourresultpath"
log using table2_and_3, replace
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


forval i=2/9 {
capture erase table`i'.tex
capture erase table`i'.txt
capture erase table`i'.xml
capture erase table`i'.rtf
capture erase table`i'.doc
capture erase table`i'.xls

capture erase table`i'_noentry.tex
capture erase table`i'_noentry.txt
capture erase table`i'_noentry.xml
capture erase table`i'_noentry.rtf
capture erase table`i'_noentry.doc
capture erase table`i'_noentry.xls


capture erase table`i'_noexit.tex
capture erase table`i'_noexit.txt
capture erase table`i'_noexit.xml
capture erase table`i'_noexit.rtf
capture erase table`i'_noexit.doc
capture erase table`i'_noexit.xls


capture erase table`i'_cont.tex
capture erase table`i'_cont.txt
capture erase table`i'_cont.xml
capture erase table`i'_cont.rtf
capture erase table`i'_cont.doc
capture erase table`i'_cont.xls

}








* compute table II in paper

local varreg "small smallhigh    large largehigh medium "
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0


local varreg "young younghigh old oldhigh"
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg " small smallhigh young younghigh large largehigh high old oldhigh"
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"
areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel



* compute table II in paper continuing 

local varreg "small smallhigh   medium large largehigh"
areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"
areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"
areg growthrate `varreg'  if growthrate~=2 & growthrate~=-2, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"
areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


* compute table II in paper no entry

local varreg "small smallhigh   medium large largehigh"
areg growthrate `varreg' if growthrate~=2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0


local varreg "young younghigh old oldhigh"
areg growthrate `varreg' if growthrate~=2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"
areg growthrate `varreg'  if growthrate~=2, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"
areg growthrate `varreg' if growthrate~=2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


* compute table II in paper no exit

local varreg "small smallhigh   medium large largehigh"
areg growthrate `varreg' if growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"
areg growthrate `varreg' if growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"
areg growthrate `varreg'  if growthrate~=-2, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"
areg growthrate `varreg' if growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table3_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel



log close 



