
clear
set more off
sysdir set PERSONAL "C:\Users\siemer_m\Documents\outreg2"

cd "C:\Users\siemer_m\Documents\Results_new\DD_medium"
log using DD_20170309_medium, replace
use "C:\Users\siemer_m\Documents\SAStoSTATA\2017Feb\0709all_20170323.dta"




merge m:1 ein using "C:\Users\siemer_m\Documents\macrocontrols_ein_20170323.dta"
keep if _merge==1 | _merge==3

drop _merge 
merge m:1 fips using "C:\Users\siemer_m\Documents\macrocontrols_fips_renamed.dta"
keep if _merge==1 | _merge==3

local varlist hpi_gr0206 pop_gr0206 ur_gr0206 hpi_gr0206 income_gr0206 lf_gr0206  const_share_gr0206 

foreach var of local varlist {

replace `var'=`var'_fips if missing(`var')

}

replace ur_firm2004=ur2004 if missing(ur_firm2004)
replace pov_firm2004=pov2004 if missing(pov_firm2004)
replace p_nonwhite_firm2004 =p_nonwhite2004 if missing(p_nonwhite_firm2004)
replace p_less_hs_firm2004 =p_less_hs2004 if missing(p_less_hs_firm2004)
replace income_firm2004 = income2004 if missing(income_firm2004)
replace p_college_firm2004= p_college2004 if missing(p_college_firm2004)
replace const_share_firm2004=const_share2004 if missing(const_share_firm2004)

replace ur_firm2006=ur2006 if missing(ur_firm2006)
replace pov_firm2006=pov2006 if missing(pov_firm2006)
replace p_nonwhite_firm2006 =p_nonwhite2006 if missing(p_nonwhite_firm2006)
replace p_less_hs_firm2006 =p_less_hs2006 if missing(p_less_hs_firm2006)
replace income_firm2006 = income2006 if missing(income_firm2006)
replace p_college_firm2006= p_college2006 if missing(p_college_firm2006)
replace const_share_firm2006=const_share2006 if missing(const_share_firm2006)

* HP index: the lower the more financially constraint. 
gen HP_constraint=0
replace HP_constraint=1 if hadlockpierceindex_2006<5.037
gen high=0
replace high=1 if ext_dep_mat>0.0638633
*0.0786
drop younghigh
gen younghigh=young*high
gen check=HP_constraint
* WW index: 
gen WW_constraint=0
replace WW_constraint=1 if ww_index_2006>3840.5


gen growthrate=growthrate_0709
drop state_fips
gen state_fips=floor(fips/1000)
gen double state_industry=state_fips*100+sic2
gen medium=1
replace medium=0 if small==1
replace medium=0 if large==1
gen size=1 if small==1
replace size=2 if medium==1
replace size=3 if large==1
gen naics4=floor(naics/100)
gen state_size=state_fips*10+size
gen average_emp=(mean_emp_firm+initial_emp_firm)/2


drop small_duygan_bump large_duygan_bump
gen small_duygan_bump=0
replace small_duygan_bump=1 if average_emp<100
gen large_duygan_bump=0
replace large_duygan_bump=1 if average_emp>=100


gen younghigh_alt=young_alt*high

gen high_quartile=0
replace high_quartile=1 if ext_dep_mat>0.322
gen younghighquartile=young*high_quartile



gen age=1 if young==1
replace age=2 if young==0
gen state_age=state_fips*10+age

gen mediumhigh=medium*high
gen small=0
replace small=1 if average_emp<50
gen smallhigh=small*high

gen large=0
replace large=1 if average_emp>=500
gen largehigh=large*high
gen large_50=0
replace large_50=1 if small==0
gen large_50high=large_50*high
gen large_50younghigh=large_50*young*high
gen large_50young=large_50*young

gen medium=1
replace medium=0 if small==1
replace medium=0 if large==1
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
gen smallhigh=small*high
gen medium_duygan_bumpyoung=medium_duygan_bump*young
gen medium_duygan_bumpyounghigh=medium_duygan_bump*young*high

gen small_duygan_bumphigh_quart=small_duygan_bump*high_quartile
gen large_duygan_bumphigh_quart=large_duygan_bump*high_quartile

 gen youngsmall_duygan_bump=small_duygan_bump*young
 gen youngsmall_duygan_bumphigh=youngsmall_duygan_bump*high
 gen large_duygan_bumpyounghigh=large_duygan_bump*young*high
  gen large_duygan_bumpyoung=large_duygan_bump*young

  
  
gen low_quartile=0
replace low_quartile=1 if ext_dep_mat<-0.122
gen younglowquartile=young*low_quartile

gen county_industry=fips*100+sic2
gen double county_naics4=fips*10000+naics4
gen double county_naics3=fips*10000+naics3


gen double state_naics4=state_fips*10000+naics4

gen double state_naics3=state_fips*10000+naics3



gen young_ext_dep_mat=young*ext_dep_mat

gen young_alt_ext_dep_mat=young_alt*ext_dep_mat


* drop Alaska and PR and Hawaii
drop if state_fips==02
drop if state_fips==15
drop if state_fips==72

* drop states that are not supposed to be in my dataset
drop if state_fips==41
drop if state_fips==42
drop if state_fips==36
drop if state_fips==37
drop if state_fips==28
drop if state_fips==26
drop if state_fips==5

gen old=0
replace old=1 if young==0
gen oldhigh=old*high

gen old_alt=0
replace old_alt=1 if young_alt==0
gen oldhigh_alt=old_alt*high

gen smallWW=small*WW_constraint
gen smallHP=small*HP_constraint

gen largeWW=large*WW_constraint
gen largeHP=large*HP_constraint

gen large_50WW=large_50*WW_constraint
gen large_50HP=large_50*HP_constraint

drop pop2002_fips ur2002_fips hpi2002_fips lf2002_fips cra2002_fips hmda2002_fips p_nonwhite2002_fips p_less_hs2002_fips p_college2002_fips const_share2002_fips tradable_share2002_fips pop_gr0206_fips ur_gr0206_fips hpi_gr0206_fips income_gr0206_fips lf_gr0206_fips cra_gr0206_fips
drop hmda_gr0206_fips p_nonwhite_gr0206_fips p_less_hs_gr0206_fips p_college_gr0206_fips const_share_gr0206_fips tradable_share_gr0206_fips pop2004_fips ur2004_fips hpi2004_fips income2004_fips pov2004_fips lf2004_fips cra2004_fips hmda2004_fips p_nonwhite2004_fips p_less_hs2004_fips 
drop p_college2004_fips const_share2004_fips tradable_share2004_fips pop_gr0204_fips ur_gr0204_fips hpi_gr0204_fips income_gr0204_fips lf_gr0204_fips cra_gr0204_fips hmda_gr0204_fips
drop p_nonwhite_gr0204_fips p_less_hs_gr0204_fips p_college_gr0204_fips const_share_gr0204_fips tradable_share_gr0204_fips


forval i=2/9 {
capture erase table`i'.tex
capture erase table`i'.txt
capture erase table`i'.xml
capture erase table`i'.rtf
capture erase table`i'.doc
capture erase table`i'.xls

capture erase table`i'a.tex
capture erase table`i'a.txt
capture erase table`i'a.xml
capture erase table`i'a.rtf
capture erase table`i'a.doc
capture erase table`i'a.xls


capture erase table`i'_smalllarge.tex
capture erase table`i'_smalllarge.txt
capture erase table`i'_smalllarge.xml
capture erase table`i'_smalllarge.rtf
capture erase table`i'_smalllarge.doc
capture erase table`i'_smalllarge.xls


capture erase table`i'_smalllargeDB.tex
capture erase table`i'_smalllargeDB.txt
capture erase table`i'_smalllargeDB.xml
capture erase table`i'_smalllargeDB.rtf
capture erase table`i'_smalllargeDB.doc
capture erase table`i'_smalllargeDB.xls


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








* compute table II in paper

local varreg "small smallhigh    large largehigh medium "

reg growthrate `varreg' , vce(cluster state_fips)
outreg2 `varreg' using table2, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel



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


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel




* compute table II in paper with weights

local varreg "small smallhigh   medium large largehigh"

reg growthrate `varreg' [aw=mean_emp_firm], vce(cluster state_fips)
outreg2 `varreg' using table2_weighted, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, y) nocons dec(4) append excel
test smallhigh-largehigh=0

areg growthrate `varreg'  [aw=mean_emp_firm], absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_weighted, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel

local varreg "young younghigh old oldhigh"

areg growthrate `varreg' [aw=mean_emp_firm] , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_weighted, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg'  [aw=mean_emp_firm], absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_weighted, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' [aw=mean_emp_firm] , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_weighted, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel

local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' [aw=mean_emp_firm] , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_weighted, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel



* compute table II in paper 2 groups only

local varreg "small smallhigh large_50 large_50high"

reg growthrate `varreg' , vce(cluster state_fips)
outreg2 `varreg' using table2_smalllarge, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-large_50high=0

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllarge, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg "young younghigh old oldhigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllarge, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large_50 large_50high high old oldhigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllarge, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh large_50 large_50high"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllarge, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel




local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh large_50 large_50high large_50young large_50younghigh "

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllarge, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel





* compute table II in paper with different size threshold 2 groups only (duygan bump: 100 employees is cutoff) 
local varreg "small_duygan_bump small_duygan_bumphigh large_duygan_bump large_duygan_bumphigh"

reg growthrate `varreg' , vce(cluster state_fips)
outreg2 `varreg' using table2_smalllargeDB, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllargeDB, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "young younghigh old oldhigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllargeDB, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small_duygan_bump small_duygan_bumphigh  young younghigh  high old oldhigh  large_duygan_bump large_duygan_bumphigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllargeDB, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_duygan_bumphigh-large_duygan_bumphigh=0



local varreg "small_duygan_bump small_duygan_bumphigh young younghigh youngsmall_duygan_bump youngsmall_duygan_bumphigh high old oldhigh  large_duygan_bump large_duygan_bumphigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllargeDB, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small_duygan_bump small_duygan_bumphigh young younghigh youngsmall_duygan_bump youngsmall_duygan_bumphigh high old oldhigh  large_duygan_bump large_duygan_bumphigh large_duygan_bumpyoung large_duygan_bumpyounghigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_smalllargeDB, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel



* compute table II in paper with different size threshold (duygan bump: 100 employees is cutoff) 
local varreg "small_duygan_bump small_duygan_bumphigh medium_duygan_bump  large largehigh medium_duygan_bumphigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_size_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test small_duygan_bumphigh-largehigh=0

local varreg "young younghigh old oldhigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_size_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small_duygan_bump small_duygan_bumphigh  young younghigh large largehigh  high old oldhigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_size_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg "small_duygan_bump small_duygan_bumphigh young younghigh youngsmall_duygan_bump youngsmall_duygan_bumphigh high old oldhigh  medium_duygan_bump large largehigh medium_duygan_bumphigh medium_duygan_bump"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_size_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg "small_duygan_bump small_duygan_bumphigh young younghigh youngsmall_duygan_bump youngsmall_duygan_bumphigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh medium_duygan_bumpyounghigh medium_duygan_bumpyounghigh  medium_duygan_bumphigh medium_duygan_bump "

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_size_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


* compute table II in paper with different age threshold (7 years instead of 5 years) 



local varreg "small smallhigh   medium large largehigh"

reg growthrate `varreg' , vce(cluster state_fips)
outreg2 `varreg' using table2_age_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel



areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_age_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young_alt younghigh_alt old_alt oldhigh_alt"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_age_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young_alt younghigh_alt large largehigh high old_alt oldhigh_alt"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_age_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young_alt younghigh_alt youngsmall_alt  youngsmallhigh_alt high old_alt oldhigh_alt medium large largehigh"

areg growthrate `varreg'  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_age_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg "small smallhigh young_alt younghigh_alt youngsmall_alt  youngsmallhigh_alt high old oldhigh  large largehigh largehigh largeyoung_alt largeyounghigh_alt mediumyoung_alt mediumyounghigh_alt medium mediumhigh"

areg growthrate `varreg' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_age_change, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel



* compute table II in paper continuing 

local varreg "small smallhigh   medium large largehigh"

reg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , vce(cluster state_fips)
outreg2 `varreg' using table2_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"

areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg'  if growthrate~=2 & growthrate~=-2, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel



local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' if growthrate~=2 & growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_cont, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel



* compute table II in paper no entry

local varreg "small smallhigh   medium large largehigh"

reg growthrate `varreg' if growthrate~=2 , vce(cluster state_fips)
outreg2 `varreg' using table2_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg' if growthrate~=2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0


local varreg "young younghigh old oldhigh"

areg growthrate `varreg' if growthrate~=2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg'  if growthrate~=2, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' if growthrate~=2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' if growthrate~=2  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noentry, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel




* compute table II in paper no exit

local varreg "small smallhigh   medium large largehigh"

reg growthrate `varreg' if growthrate~=-2 , vce(cluster state_fips)
outreg2 `varreg' using table2_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg' if growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"

areg growthrate `varreg' if growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg'  if growthrate~=-2, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' if growthrate~=-2 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel



local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' if growthrate~=-2  , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table2_noexit, keep(`varreg') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel



/* table 7 and 8: additional control variables and interactions with high efd*/ 

local varlist hpi_gr0206 const_share_gr0206  const_share_firm2006 pop_gr0206 ur_gr0206 income_gr0206 lf_gr0206 ur_firm2006 income_firm2006 pov_firm2006 p_nonwhite_firm2006 p_less_hs_firm2006 p_college_firm2006

foreach var of local varlist{
gen `var'high=`var'*high
}

 
 local varcontrol "hpi_gr0206  const_share_gr0206 const_share_firm2006 pop_gr0206 ur_gr0206 hpi_gr0206 income_gr0206 lf_gr0206 ur_firm2006 income_firm2006 pov_firm2006 p_nonwhite_firm2006 p_less_hs_firm2006 p_college_firm2006"
 

 
 
local varreg "small smallhigh    large largehigh medium "

reg growthrate `varreg' `varcontrol' , vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' `varcontrol', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel

 
 
 
 
 local varcontrol "hpi_gr0206  const_share_gr0206  const_share_gr0206high const_share_firm2006  const_share_firm2006high  pop_gr0206 ur_gr0206 hpi_gr0206 income_gr0206 lf_gr0206 ur_firm2006 income_firm2006 pov_firm2006 p_nonwhite_firm2006 p_less_hs_firm2006 p_college_firm2006 pop_gr0206high ur_gr0206high hpi_gr0206high income_gr0206high lf_gr0206high ur_firm2006high income_firm2006high pov_firm2006high p_nonwhite_firm2006high p_less_hs_firm2006high p_college_firm2006high"
 

 
 
 
local varreg "small smallhigh    large largehigh medium "

reg growthrate `varreg' `varcontrol' , vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg'  `varcontrol', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' `varcontrol' , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg'  `varcontrol', absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table7, keep(`varreg' `varcontrol') addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel

 
 
 
 
 
 /* table 9: exclude construction */
 
 
 
local varreg "small smallhigh    large largehigh medium "

reg growthrate `varreg'  if sic2~=15 & sic2~=16 & sic2~=17, vce(cluster state_fips)
outreg2 `varreg' using table9, keep(`varreg' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, n, cluster state, y, weighted, n) nocons dec(4) append excel

areg growthrate `varreg' if sic2~=15 & sic2~=16 & sic2~=17 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table9, keep(`varreg' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel
test smallhigh-largehigh=0

local varreg "young younghigh old oldhigh"

areg growthrate `varreg' if sic2~=15 & sic2~=16 & sic2~=17 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table9, keep(`varreg' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel

local varreg " small smallhigh young younghigh large largehigh high old oldhigh"

areg growthrate `varreg' if sic2~=15 & sic2~=16 & sic2~=17 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table9, keep(`varreg' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh medium large largehigh"

areg growthrate `varreg' if sic2~=15 & sic2~=16 & sic2~=17 , absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table9, keep(`varreg' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, n) nocons dec(4) append excel


local varreg "small smallhigh young younghigh youngsmall  youngsmallhigh high old oldhigh  large largehigh largehigh largeyoung largeyounghigh mediumyoung mediumyounghigh medium mediumhigh"

areg growthrate `varreg' if sic2~=15 & sic2~=16 & sic2~=17, absorb(state_industry) vce(cluster state_fips)
outreg2 `varreg' using table9, keep(`varreg' ) addtext(County FE, n, county-ind FE, n, Ind FE, n, State fe, n, State-Ind FE, y, cluster state, y, weighted, y) nocons dec(4) append excel

 

 
 
 
 




log close 



