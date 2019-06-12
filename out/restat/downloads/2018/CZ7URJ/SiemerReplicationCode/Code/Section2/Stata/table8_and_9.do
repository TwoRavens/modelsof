
clear
set more off


cd "yourresultpath"
log using table8_and_9, replace
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


merge m:1 sic2 using "Data\Stata\loan_asset_ssbf98.dta"

drop _merge

/* note: the data can be obtained from Egon Zakrajsek */ 
merge m:1 naics3 using "Data\Stata\spr_naics3_q_2009q4.dta"
drop _merge


gen naics2=floor(naics3/10)
merge m:1 naics2 using "Data\Stata\Kauffman_DA_2004_2006.dta"
drop _merge





gen small_SBFF=small*SBFF_constraint
gen large_SBFF=large*SBFF_constraint
gen medium_SBFF=medium*SBFF_constraint
gen youngsmall_SBFF=young*small*SBFF_constraint
gen youngsmall_SBFF=young*small*SBFF_constraint
gen young_SBFF=young*SBFF_constraint
gen old_SBFF=old*SBFF_constraint
gen spread_increase=ave_increase
gen young_spr_increase=young*ave_increase
gen old_spr_increase=old*ave_increase
gen small_spr_increase=small*ave_increase
gen large_spr_increase=large*ave_increase
gen medium_spr_increase=medium*ave_increase



gen small_Kaufman_high=small*Kaufman_high
gen large_Kaufman_high=large*Kaufman_high
gen young_Kaufman_high=young*Kaufman_high
gen old_Kaufman_high=old*Kaufman_high




forval i=8 {
capture erase table`i'.tex
capture erase table`i'.txt
capture erase table`i'.xml
capture erase table`i'.rtf
capture erase table`i'.doc
capture erase table`i'.xls


capture erase table`i'_HP.tex
capture erase table`i'_HP.txt
capture erase table`i'_HP.xml
capture erase table`i'_HP.rtf
capture erase table`i'_HP.doc
capture erase table`i'_HP.xls

capture erase table`i'_WW.tex
capture erase table`i'_WW.txt
capture erase table`i'_WW.xml
capture erase table`i'_WW.rtf
capture erase table`i'_WW.doc
capture erase table`i'_WW.xls

capture erase table`i'_SSBF.tex
capture erase table`i'_SSBF.txt
capture erase table`i'_SSBF.xml
capture erase table`i'_SSBF.rtf
capture erase table`i'_SSBF.doc
capture erase table`i'_SSBF.xls

capture erase table`i'_Kaufman.tex
capture erase table`i'_Kaufman.txt
capture erase table`i'_Kaufman.xml
capture erase table`i'_Kaufman.rtf
capture erase table`i'_Kaufman.doc
capture erase table`i'_Kaufman.xls


capture erase table`i'_Spread.tex
capture erase table`i'_Spread.txt
capture erase table`i'_Spread.xml
capture erase table`i'_Spread.rtf
capture erase table`i'_Spread.doc
capture erase table`i'_Spread.xls


capture erase table`i'_Startupcost.tex
capture erase table`i'_Startupcost.txt
capture erase table`i'_Startupcost.xml
capture erase table`i'_Startupcost.rtf
capture erase table`i'_Startupcost.doc
capture erase table`i'_Startupcost.xls

capture erase table`i'a.tex
capture erase table`i'a.txt
capture erase table`i'a.xml
capture erase table`i'a.rtf
capture erase table`i'a.doc
capture erase table`i'a.xls


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


capture erase table`i'_weighted.tex
capture erase table`i'_weighted.txt
capture erase table`i'_weighted.xml
capture erase table`i'_weighted.rtf
capture erase table`i'_weighted.doc
capture erase table`i'_weighted.xls

capture erase table`i'_size_change.tex
capture erase table`i'_size_change.txt
capture erase table`i'_size_change.xml
capture erase table`i'_size_change.rtf
capture erase table`i'_size_change.doc
capture erase table`i'_size_change.xls



capture erase table`i'_age_change.tex
capture erase table`i'_age_change.txt
capture erase table`i'_age_change.xml
capture erase table`i'_age_change.rtf
capture erase table`i'_age_change.doc
capture erase table`i'_age_change.xls
}



local varreg "small small_SBFF   large large_SBFF medium "
areg growthrate `varreg' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table8_SSBF, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_SBFF-large_SBFF=0


local varreg "young young_SBFF old old_SBFF"
areg growthrate `varreg', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table8_SSBF, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test young_SBFF-old_SBFF=0


local varreg "small small_SBFF young young_SBFF   large large_SBFF"
areg growthrate `varreg' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table8_SSBF, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small small_Kaufman_high   large large_Kaufman_high" 
areg growthrate `varreg' , absorb(state_naics2) vce(cluster state_fips)
outreg2 `varreg' using table8_Kaufman, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_Kaufman_high-large_Kaufman_high=0	

local varreg "young young_Kaufman_high   old old_Kaufman_high" 
areg growthrate `varreg' , absorb(state_naics2) vce(cluster state_fips)
outreg2 `varreg' using table8_Kaufman, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg "small small_Kaufman_high   large large_Kaufman_high young young_Kaufman_high   old old_Kaufman_high" 
areg growthrate `varreg' , absorb(state_naics2) vce(cluster state_fips)
outreg2 `varreg' using table8_Kaufman, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_Kaufman_high-large_Kaufman_high=0


local varreg "small small_spr_increase large large_spr_increase medium medium_spr_increase"
areg growthrate `varreg' , absorb(state_naics3) vce(cluster state_fips)
outreg2 `varreg' using table8_Spread, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_spr_increase-large_spr_increase=0


local varreg "young young_spr_increase old old_spr_increase"
areg growthrate `varreg' , absorb(state_naics3) vce(cluster state_fips)
outreg2 `varreg' using table8_Spread, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test young_spr_increase-old_spr_increase=0

local varreg "small small_spr_increase large large_spr_increase young young_spr_increase old old_spr_increase medium medium_spr_increase"
areg growthrate `varreg' , absorb(county_naics3) vce(cluster state_fips)
outreg2 `varreg' using table8_Spread, keep(`varreg') addtext(County FE, n, county-ind FE, y, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

log close 



