** This script combines the updated aid data with other variables
** Run in Stata 12.1

** I assume that the current working directory is the archive main directory

clear
set more off

** create in the raw gleditsch population data (I didn't keep straight population in the replication data)

local donornames Australia Austria Belgium Canada Denmark Finland France Germany Italy Japan Netherlands "New Zealand" Norway Sweden Switzerland "United States" "United Kingdom" Ireland Luxembourg Portugal Spain
foreach d of local donornames {
  clear
  insheet using "aid/rawdata/gleditsch/expgdpv5.0/expgdp_v5.0.asc", delimiter(" ")
  gen donorname = "`d'"
  save "aid/junk/`d'", replace
}
clear
foreach d of local donornames {
  di "`d'"
  append using "aid/junk/`d'.dta"
  erase "aid/junk/`d'.dta"
}

gen countryname_g="proper(countryname)"
rename stateid countrycode_g
run "aid/scripts/Standardize Country Codes.do"
move  countryname_g countrycode_g
drop countrynumcode_g origin
rename statenum countrynumcode_g
sort  countryname_g year
rename  pop population //(Units are in 1000's)
replace population = population*1000
drop countrynumcode_g countrycode_g rgdpch gdppc
rename countryname_g countryname
save "aid/junk/gleditsch.dta",replace

use "aid/madedata/years.dta", replace
merge 1:1 donorname countryname year using "aid/junk/gleditsch.dta", generate(_merge1)
*drop if _merge1==2
drop _merge1
keep year countryname donorname population
sort countryname donorname year
drop if year > 2008
save "aid/junk/gleditsch2.dta",replace


** This is the replication data from 
** Nielsen, Richard. 2013. "Rewarding Human Rights? Selective Aid Sanctions against Repressive States," 
** International Studies Quarterly, 57 (4), 791-803.
** Available at http://thedata.harvard.edu/dvn/dv/rnielsen
use "aid/rawdata/dat2.dta", clear
merge 1:1 donorname countryname year using "aid/junk/gleditsch.dta", generate(_merge1)
drop if _merge1==2
drop _merge1

** add in the new aid data through 2010
merge 1:1 donorname countryname year using "aid/madedata/aid2010.dta", generate(_merge1)
** note that the aid is missing years when there was no money

** extend gleditsch through 2010
** we are just copying and pasting here (could do better, but this won't matter much)
egen dyadid = group(donorname countryname)
tsset dyadid year
replace population = l.population if year==2005 & population==.
replace population = l.population if year==2006 & population==.
replace population = l.population if year==2007 & population==.
replace population = l.population if year==2008 & population==.
replace population = l.population if year==2009 & population==.
replace population = l.population if year==2010 & population==.

drop if stateinyeart_g==.

rename donorname name_1
rename countryname name_2

** gen aid pc variable
gen aidpc = totalaid/population
drop lnaidpc

** merge in the HRA data
** NOTE: these are originally from "aid/bits/madedata" but it seemed wise to copy
** them over here in case analysts decide to do the aid analysis before the trade
replace name_1="United States of America" if name_1=="United States"
merge 1:1 name_1 name_2 year using "aid/rawdata/dyadicHRAs name_1.dta", generate(_mergeHRA1)
drop if _mergeHRA1==2
merge 1:1 name_1 name_2 year using "aid/rawdata/dyadicHRAs name_2.dta", generate(_mergeHRA2)
drop if _mergeHRA2==2
replace name_1="United States" if name_1=="United States of America"


foreach var in iccpr opt1 cat art22 {
  gen `var'name1_treat = 0
  ** This creates a variable that is 1 if a country ratified the treaty in that year
  replace `var'name1_treat = 1 if `var'name_1[_n]==1 & `var'name_1[_n-1]==0 & (dyadid[_n]==dyadid[_n-1]) & ((year[_n-1]+1)==year[_n])
  ** treat==1 means that the country ratified in that year
  ** but if I want to look for aid increases preceding ratification...
  gen `var'name1_treat2 = 0
  replace `var'name1_treat2 = 1 if `var'name1_treat[_n+1]==1 & (dyadid[_n]==dyadid[_n+1]) & ((year[_n]+1)==year[_n+1])
  ** make a 6 year treatment window
  gen `var'name1_treat3 = 0
  replace `var'name1_treat3 = 1 if `var'name1_treat2==1 | `var'name1_treat==1
  forvalues i=1/4 {
    replace `var'name1_treat3 = 1 if `var'name1_treat[_n-`i']==1 & (dyadid[_n]==dyadid[_n-`i']) & ((year[_n]-`i')==year[_n-`i'])
  }
}

foreach var in iccpr opt1 cat art22 {
  gen `var'name2_treat = 0
  ** This creates a variable that is 1 if a country ratified the treaty in that year
  replace `var'name2_treat = 1 if `var'name_2[_n]==1 & `var'name_2[_n-1]==0 & (dyadid[_n]==dyadid[_n-1]) & ((year[_n-1]+1)==year[_n])
  ** treat==1 means that the country ratified in that year
  ** but if I want to look for aid increases preceding ratification...
  gen `var'name2_treat2 = 0
  replace `var'name2_treat2 = 1 if `var'name2_treat[_n+1]==1 & (dyadid[_n]==dyadid[_n+1]) & ((year[_n]+1)==year[_n+1])
  ** make a 6 year treatment window
  gen `var'name2_treat3 = 0
  replace `var'name2_treat3 = 1 if `var'name2_treat2==1 | `var'name2_treat==1
  forvalues i=1/4 {
    replace `var'name2_treat3 = 1 if `var'name2_treat[_n-`i']==1 & (dyadid[_n]==dyadid[_n-`i']) & ((year[_n]-`i')==year[_n-`i'])
  }
}

tsset dyadid year
save "aid/madedata/Aidtmp.dta", replace

foreach HRA in iccpr opt1 cat art22 {

  di "`HRA'"

  use "aid/madedata/Aidtmp.dta", clear

  ** `HRA'
  ** now, lag the controls so that I can just pull out the treated chunks
  gen elig = 0
  quietly replace elig = 1 if `HRA'name2_treat2==1 & (name_1[_n]==name_1[_n-1]) & (name_2[_n]==name_2[_n-1]) 

  local controls5 physint polity2 aidpc lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war
  local controls1 dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac
  
  foreach V of local controls5 {
    foreach i of numlist 1/5 {
      *di "`V'"`i'
      quietly gen l`i'`V' = l`i'.`V'
    }
  }
  
  foreach V of local controls1 {
    foreach i of numlist 1/5 {
      *di "`V'"`i'
      quietly gen l`i'`V' = l`i'.`V'
    }
  }

  ** make leads of the outcome
  local leads aidpc
  foreach V of local leads {
    foreach i of numlist 1/5 {
      *di "`V'"`i'
      quietly gen f`i'`V' = f`i'.`V'
    }
  }

  ** keep only the treated units
  local keepme name_1 name_2 dyadid dyadnum year f1* f2* f3* f4* f5* l1* l2* l3* l4* l5*  ///
             physint polity2 aidpc lnworldaidtotal ln_rgdpc ln_population ln_trade alliance war ///
			 dyad_colony socialist ColdWar coldwarsoc region_SSA region_Latin region_MENA region_EAsiaPac ///
             elig `HRA'name1_treat2 `HRA'name2_treat2 `HRA'name_1 `HRA'name_2

  keep `keepme'

  quietly compress
  save "aid/junk/all.dta", replace

  keep if elig==1

  gen treated = 1
  save "aid/junk/treated.dta", replace

  ** find control chunks
  use "aid/junk/all.dta", clear

  ** first, rule out all the observations I can't use
  gen dropme = 0
  replace dropme = 1 if `HRA'name2_treat2==1
  foreach i of numlist 1/6 {
     replace dropme = 1 if `HRA'name2_treat2[_n+`i']==1 & (name_1[_n]==name_1[_n+`i']) & (name_2[_n]==name_2[_n+`i']) & (year[_n]+`i'==year[_n+`i'])
  }

  ** keep only the eligible control chunks
  drop if dropme==1

  ** this macro is defined above
  keep `keepme'

  gen treated = 0
  save "aid/junk/control.dta", replace

  ** append the treated
  append using "aid/junk/treated.dta"


  ** make a few aid outcome variables
  ** I sum the indicators, but don't count it if they sign multiple ptas in that time.
  ** make a few aid outcome variables
  gen aidpc012 = aidpc + f1aidpc + f2aidpc
  gen aidpc123 = f1aidpc + f2aidpc + f3aidpc
  gen aidpc012345 = aidpc + f1aidpc + f2aidpc + f3aidpc + f4aidpc + f5aidpc
  gen aidpc01234 = aidpc + f1aidpc + f2aidpc + f3aidpc + f4aidpc

  save "aid/madedata/`HRA'RatEpisodeDat.dta", replace

  ** make a data set with just ratifying to non ratifying countries
  use "aid/madedata/`HRA'RatEpisodeDat.dta"
  keep if `HRA'name_1==1 & `HRA'name_2==0
  save "aid/madedata/`HRA'RatEpisodeDat_Ratifiers.dta", replace

  ** make a data set with just the non-ratifying countries as potential rewardees.
  use "aid/madedata/`HRA'RatEpisodeDat.dta"
  keep if `HRA'name_2==0
  save "aid/madedata/`HRA'RatEpisodeDat_nonRatifiers.dta", replace

}

** get rid of some of the junk data
erase "aid/junk/all.dta"
erase "aid/junk/treated.dta"
erase "aid/junk/control.dta"

