** Make the data for the BITs analysis
** This script assumes that the current working directory is the top level of the archive
clear
set more off 

capture mkdir "bits/madedata"
capture mkdir "bits/junk"
** I tried to update the BITs through 2012 using data that Beth has(see below) but the problem is that I 
** don't know from Beth's list which are the home and which are the host countries.  When I
** merged in the data, I ran into many cases where they didn't match up -- about 330 where
** the way Beth has it entered in the 2012 spreadsheet is reversed from the senior/junior 
** designation in the original data set.  For the anlysis, I'm going to just "update" the data, meaning that 
** I keep the old data for the parts where it exists, but use the new BIT spreadsheet where
** the time runs out.

** Get the updated BIT data from Beth
insheet using "bits/rawdata/Bilateral Investment Treaties 1959-2012.csv", clear
rename cowcodecountry senior
rename cowcodepartner junior
replace junior=972 if junior==955
replace junior=211 if partner=="Belgium and Luxembourg"
replace senior=211 if country=="Belgium and Luxembourg"
replace junior=732 if partner=="Korea, People's Republic of"
replace senior=732 if country=="Korea, People's Republic of"
replace senior=212 if country=="(Belgium and?) Luxembourg"
replace senior=346 if country=="Bosnia"
replace junior=260 if junior==255
replace senior=260 if senior==255
drop if junior==. | senior==.

rename senior senior1
rename junior senior
rename senior1 junior

split( signature), gen(sig) p("-")
gen year = real(sig3)
replace year = year+1
drop sig3
keep senior junior year 
gen newbit = 1
save "bits/junk/newbit.dta", replace
** This flipped the junior/senior and appended because I don't know exactly how 
** they determined junior/senior, but then that led to problems as well
*rename senior senior1
*rename junior senior
*rename senior1 junior
*append using "C:\Users\Richard Nielsen\Desktop\Papers\Rewards for Ratification\bits\bitjunk\newbit.dta"
duplicates tag senior junior year, gen(dup)
drop if dup>0
save "bits/junk/newbit.dta", replace


use "bits/rawdata/bits_io2006_rev5_2008/bits_io2006_rev5_08.dta", clear
drop if junior==. | senior==.
save "bits/junk/ytmp1.dta", replace
foreach i of numlist 2001/2012 {
  use "bits/junk/ytmp1.dta", clear
  keep if year==2000
  keep junior senior year
  duplicates drop
  replace year=`i'
  save "bits/junk/ytmp2.dta", replace
  use "bits/junk/ytmp1.dta", clear
  append using "bits/junk/ytmp2.dta"
  save "bits/junk/ytmp1.dta", replace
}
keep junior senior year
merge 1:1 senior junior year using "bits/junk/newbit.dta"
drop if _merge==2
keep senior junior year newbit
replace newbit=0 if newbit==.
save "bits/junk/newbits2.dta", replace

erase "bits/junk/ytmp1.dta"
erase "bits/junk/ytmp2.dta"
erase "bits/junk/newbit.dta"


** try merging the data
use "bits/rawdata/bits_io2006_rev5_2008/bits_io2006_rev5_08.dta", clear
stset year, id(dyad)  failure(bit) origin(time atrisk)
gen ccode1 = junior
gen ccode2 = senior
** make the country names
gen country=""
gen partner=""
run "pta/scripts/COW convert.do"
** what the heck, there are some codes that aren't really codes
** There is no cow code 972
** FROM the IMF codes, it turns out its Tonga
*replace country="Tonga" if ccode1==972
*replace partner="Tonga" if ccode2==972
rename country host
rename partner home
edit if host=="" & junior!=.
edit if home=="" & senior!=.

** There's a problem with the atrisk var -- some are missing
sort home host year
gen atrisk2 = _origin
replace atrisk2=. if host[_n-1]==host[_n]
edit year home host bit _* atrisk*

** remove duplicates
drop if host==""
rename host name_1
rename home name_2
** Can't drop because I lose the "atrisk" var for some obs
*drop if year <1967 | year > 2008
save "bits/junk/bittmp.dta", replace

use "bits/junk/bittmp.dta", clear

** add in the new bits
merge 1:1 senior junior year using "bits/junk/newbits2.dta", gen(_mergeN)
*drop if _mergeN
drop _mergeN
** figure out if the bits are the same
edit bit newbit
gen tmp = bit-newbit
tab tmp
tab tmp if bit==1
drop dyad
egen dyad = group(senior junior)
*sort name_1 name_2 year
edit name_1 name_2 senior junior year bit newbit tmp dyad if tmp!=0
** Hmmm... the updated seems to have some bits that the old data doesn't have
edit name_1 name_2 year bit newbit tmp dyad if dyad==130
edit name_1 name_2 year bit newbit tmp dyad if dyad==3997
edit name_1 name_2 year bit newbit tmp dyad if dyad==4140

** Well, it's not perfectly matching up, so I'm keeping the old data where I have it
** and adding the new data so I can get more temporal coverage
replace bit = newbit if year>2000
drop newbit

** Need to redo the names from the codes
drop ccode1 ccode2 
gen ccode1 = junior
gen ccode2 = senior
** make the country names
gen country=""
gen partner=""
run "pta/scripts/COW convert.do"
** There is no cow code 972
** FROM the IMF codes, it turns out its Tonga
replace country="Tonga" if ccode1==972
replace partner="Tonga" if ccode2==972
drop name_1 name_2
rename country name_1
rename partner name_2


** standardize names
rename name_1 countryname
run "pta/scripts/Standardize Country Names.do"
rename countryname name_1
rename name_2 countryname
run "pta/scripts/Standardize Country Names.do"
rename countryname name_2
duplicates tag name_1 name_2 year, gen(dup)
tab dup
drop dup

** Merge with the HRA data
** See the PTA analysis for the creation of this data
di _N
merge 1:1 name_1 name_2 year using "pta/rawdata/dyadicHRAs name_1.dta", generate(_mergeHRA1)
di _N
*drop if _mergeHRA1==1 /* this drops brunei and nauru */
drop if _mergeHRA1==2 /* some countries are missing -- some drop out when they sign */

merge 1:1 name_1 name_2 year using "pta/rawdata/dyadicHRAs name_2.dta", generate(_mergeHRA2)
drop if _mergeHRA2==2

rename name_1 host
rename name_2 home
*drop if _d ==.

foreach name in iccpr opt1 cat art22 {
  rename `name'name_1 `name'_host
  rename `name'name_2 `name'_home
}

** I think I've merged them correctly -- I checked a few cases

foreach var in iccpr opt1 cat art22 {
  gen `var'_host_treat = 0
  ** This creates a variable that is 1 if a country ratified the treaty in that year
  replace `var'_host_treat = 1 if `var'_host[_n]==1 & `var'_host[_n-1]==0 & (dyad[_n]==dyad[_n-1]) & ((year[_n-1]+1)==year[_n])
  ** treat==1 means that the country ratified in that year
  ** but if I want to look for aid increases preceding ratification...
  gen `var'_host_treat2 = 0
  replace `var'_host_treat2 = 1 if `var'_host_treat[_n+1]==1 & (dyad[_n]==dyad[_n+1]) & ((year[_n]+1)==year[_n+1])
  ** make a 6 year treatment window
  gen `var'_host_treat3 = 0
  replace `var'_host_treat3 = 1 if `var'_host_treat2==1 | `var'_host_treat==1
  forvalues i=1/4 {
    replace `var'_host_treat3 = 1 if `var'_host_treat[_n-`i']==1 & (dyad[_n]==dyad[_n-`i']) & ((year[_n]-`i')==year[_n-`i'])
  }
}

foreach var in iccpr opt1 cat art22 {
  gen `var'_home_treat = 0
  ** This creates a variable that is 1 if a country ratified the treaty in that year
  replace `var'_home_treat = 1 if `var'_home[_n]==1 & `var'_home[_n-1]==0 & (dyad[_n]==dyad[_n-1]) & ((year[_n-1]+1)==year[_n])
  ** treat==1 means that the country ratified in that year
  ** but if I want to look for aid increases preceding ratification...
  gen `var'_home_treat2 = 0
  replace `var'_home_treat2 = 1 if `var'_home_treat[_n+1]==1 & (dyad[_n]==dyad[_n+1]) & ((year[_n]+1)==year[_n+1])
  ** make a 6 year treatment window
  gen `var'_home_treat3 = 0
  replace `var'_home_treat3 = 1 if `var'_home_treat2==1 | `var'_home_treat==1
  forvalues i=1/4 {
    replace `var'_home_treat3 = 1 if `var'_home_treat[_n-`i']==1 & (dyad[_n]==dyad[_n-`i']) & ((year[_n]-`i')==year[_n-`i'])
  }
}


** exclude dyads where the j is developed
** We need to make some quick fixes to the data first
/*  This adds an OECD variable, as defined by the World Bank, 2006 */
gen OECD_host=1 if host=="United States of America" | host=="Austria" | host=="Belgium" | host=="Canada" | host=="Denmark" | host=="France" | host=="German Federal Republic" | host=="Greece" | host=="Iceland" | host=="Ireland" | host=="Italy/Sardinia" | host=="Luxembourg" | host=="Netherlands" | host=="Norway" | host=="Portugal" | host=="Spain" | host=="Sweden" | host=="Switzerland" | host=="United Kingdom"
replace OECD_host=1 if host=="Japan" | host=="Finland" | host=="Australia" | host=="New Zealand"
replace OECD_host=1 if host=="Germany West (1945-1990)" | host=="Germany (1991+)"
/*Not sure about these ones--these are the new members?*/
*replace OECD=1 if host=="Turkey/Ottoman Empire" | host=="Mexico" | host=="Czech Republic"  | host=="Hungary" | host=="Poland" | host=="Korea, Republic of" | host=="Slovakia"
replace OECD_host=0 if OECD_host!=1

/*  This adds an OECDhome variable, as defined by the World Bank, 2006 */
gen OECD_home=1 if home=="United States of America" | home=="Austria" | home=="Belgium" | home=="Canada" | home=="Denmark" | home=="France" | home=="German Federal Republic" | home=="Greece" | home=="Iceland" | home=="Ireland" | home=="Italy/Sardinia" | home=="Luxembourg" | home=="Netherlands" | home=="Norway" | home=="Portugal" | home=="Spain" | home=="Sweden" | home=="Switzerland" | home=="United Kingdom"
replace OECD_home=1 if home=="Japan" | home=="Finland" | home=="Australia" | home=="New Zealand"
replace OECD_home=1 if home=="Germany West (1945-1990)" | home=="Germany (1991+)"
/*Not sure about these ones--these are the new members?*/
*replace OECDhome=1 if home=="Turkey/Ottoman Empire" | home=="Mexico" | home=="Czech Republic"  | home=="Hungary" | home=="Poland" | home=="Korea, Republic of" | home=="Slovakia"
replace OECD_home=0 if OECD_home!=1



** add in human rights data
save "bits/madedata/tmpBIT.dta", replace
use "bits/madedata/tmpBIT.dta", clear
replace home = regexr(home,"/","---")
levelsof home, local(levels)
insheet using "pta/rawdata/data.CIRI.csv", clear
rename ctry countryname
/* The fix below deleted missing values where Gleditsch treats the
	countries as continuous and CIRI treats them as separate  */
drop if countryname=="Soviet Union" & year>=1992
drop if countryname=="Russia" & year<=1991
drop if countryname=="Yemen Arab Republic (North Yemen)" & year>=1991
drop if countryname=="Yemen" & year<=1990
do "pta/scripts/Standardize Country Names.do"
replace  physint=. if physint==-999 | physint==-77 | physint==-66
keep year countryname physint
save "bits/junk/CIRI vars.dta" , replace
foreach i of local levels{
  use "bits/junk/CIRI vars.dta"
  rename countryname host
  gen home = regexr("`i'","---","/")
  save "bits/junk/`i'.dta", replace
  di "`i'"
}
clear

foreach i of local levels {
  append using "bits/junk/`i'.dta"
  erase "bits/junk/`i'.dta"
}
erase "bits/junk/CIRI vars.dta"
drop if host==home
save "bits/junk/CIRI vars for merge.dta", replace
use "bits/madedata/tmpBIT.dta", clear


merge home host year using "bits/junk/CIRI vars for merge.dta", unique sort _merge(_merge_ciri_vars)
** The ones that don't match are just extra from the CIRI
drop if _merge_ciri_vars==2
*drop  _merge_ciri_vars
erase "bits/junk/CIRI vars for merge.dta"


** replicate BITs paper

drop _*
sort home host year
tab year

stset year, id(dyad)  failure(bit) origin(time atrisk2)
edit year home host bit _* atrisk

stcox jmsbit mjfdi jextract jcorruption jcl2 jrelbit stb juse_dich jgdp jgdpcap jchgdplag2 jfdilag jillit jca_gdp jlaworder jdem jtotemb jpriv sfdi tradgdp comcol comlang alliance coldwar bitcount

** drop the obs after ratification and re-estimate with logit
drop if _d==.
** run logit with year dummies
xi: logit bit jmsbit mjfdi jextract jcorruption jcl2 jrelbit stb juse_dich jgdp jgdpcap jchgdplag2 jfdilag jillit jca_gdp jlaworder jdem jtotemb jpriv sfdi tradgdp comcol comlang alliance coldwar bitcount i.year
** logit without year dummies
logit bit jmsbit mjfdi jextract jcorruption jcl2 jrelbit stb juse_dich jgdp jgdpcap jchgdplag2 jfdilag jillit jca_gdp jlaworder jdem jtotemb jpriv sfdi tradgdp comcol comlang alliance coldwar bitcount

save "bits/madedata/tmpBITs.dta", replace


****************************
** make ratification episode data sets


foreach HRA in iccpr opt1 cat art22 {

  di "`HRA'"

  use "bits/madedata/tmpBITs.dta", clear

  ** `HRA'
  ** now, lag the controls so that I can just pull out the treated chunks
  gen elig = 0
  quietly replace elig = 1 if `HRA'_host_treat2==1 & (host[_n]==host[_n-1]) & (home[_n]==home[_n-1]) 

  drop if dyad==.
  tsset dyad year
  local controls physint jmsbit mjfdi jextract jcorruption jcl2 jrelbit stb juse_dich jgdp jgdpcap jchgdplag2 jfdilag jillit jca_gdp jlaworder jdem jtotemb jpriv sfdi tradgdp comcol comlang alliance coldwar bitcount

  foreach V of local controls {
    foreach i of numlist 1/5 {
      *di "`V'"`i'
      quietly gen l`i'`V' = l`i'.`V'
    }
  }

  ** make leads of the outcome
local leads bit
foreach V of local leads {
  foreach i of numlist 1/5 {
    *di "`V'"`i'
    quietly gen f`i'`V' = f`i'.`V'
  }
}

** keep only the treated units
local keepme host home dyad year f1* f2* f3* f4* f5* l1* l2* l3* l4* l5*  ///
             jmsbit mjfdi jextract jcorruption jcl2 jrelbit stb juse_dich jgdp jgdpcap jchgdplag2 jfdilag jillit jca_gdp jlaworder jdem jtotemb jpriv sfdi tradgdp comcol comlang alliance coldwar bitcount ///
             elig `HRA'_host_treat2 bit OECD_host OECD_home `HRA'_host `HRA'_home

keep `keepme'

quietly compress
save "bits/junk/bittmp.dta", replace

keep if elig==1

gen treated = 1
save "bits/junk/treated.dta", replace



** find control chunks
use "bits/junk/bittmp.dta", clear

** first, rule out all the observations I can't use
gen dropme = 0
replace dropme = 1 if `HRA'_host_treat2==1
foreach i of numlist 1/6 {
  replace dropme = 1 if `HRA'_host_treat2[_n+`i']==1 & (home[_n]==home[_n+`i']) & (host[_n]==host[_n+`i']) & (year[_n]+`i'==year[_n+`i'])
}

** keep only the eligible control chunks
drop if dropme==1

** this macro is defined above
keep `keepme'

gen treated = 0
save "bits/junk/control.dta", replace

** append the treated
append using "bits/junk/treated.dta"


** make a few aid outcome variables
tsset dyad year
gen bit012 = 0
replace bit012 = 1 if bit==1 | f1.bit==1 | f2.bit==1
gen bit123 = 0
replace bit123 = 1 if f1.bit==1 | f2.bit==1 | f3.bit==1
gen bit01234 = 0
replace bit01234 = 1 if bit==1 | f1.bit==1 | f2.bit==1 | f3.bit==1 | f4.bit==1
gen bit012345 = 0
replace bit012345 = 1 if bit==1 | f1.bit==1 | f2.bit==1 | f3.bit==1 | f4.bit==1 | f5.bit==1

** THis code was the old code that was not working as I expected
** I sum the indicators, but don't count it if they sign multiple ptas in that time.
*gen bit012 = (bit + f1bit + f2bit) > 0 & (bit + f1bit + f2bit) < .
*replace bit012 = . if bit==. | f1bit==. | f2bit==.
*gen bit123 = (f1bit + f2bit + f3bit) > 0 & (f1bit + f2bit + f3bit) < .
*replace bit123 = . if f1bit==. | f2bit==. | f3bit==.
*gen bit012345 = (bit + f1bit + f2bit + f3bit + f4bit + f5bit) > 0 & (bit + f1bit + f2bit + f3bit + f4bit + f5bit) < .
*replace bit012345 = . if bit==. | f1bit==. | f2bit==. | f3bit==. | f4bit==. | f5bit==.
*gen bit01234 = (bit + f1bit + f2bit + f3bit + f4bit) > 0 & (bit + f1bit + f2bit + f3bit + f4bit) < .
*replace bit01234 = . if bit==. | f1bit==. | f2bit==. | f3bit==. | f4bit==.



save "bits/madedata/`HRA'RatEpisodeDat.dta", replace

** make a data set with just the OECD to non OECD countries
use "bits/madedata/`HRA'RatEpisodeDat.dta"
keep if OECD_host==0 & OECD_home==1
save "bits/madedata/`HRA'RatEpisodeDat_OECD.dta", replace

** make a data set with just ratifying to non ratifying countries
use "bits/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'_home==1 & `HRA'_host==0
save "bits/madedata/`HRA'RatEpisodeDat_Ratifiers.dta", replace

** make a data set with just the non-ratifying countries as potential rewardees.
use "bits/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'_host==0
save "bits/madedata/`HRA'RatEpisodeDat_nonRatifiers.dta", replace

}
