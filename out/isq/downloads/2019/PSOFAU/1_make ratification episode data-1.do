** Start making the data for the PTA analysis

** This script assumes that the current working directory is the top level of the archive
clear
set more off

** Make the HRA data
clear
insheet using "other\ICCPR and CAT through 2008.csv"

  ** standardize the country names
  /* Notes from Beth about the data (via email):
    Here is the ratification data for the ICCPR and the CAT, through 2008.  
    Note that the data are really "obligation" because it includes both 
    ratification and accession for both of the main treaties.  (I am pretty 
    sure it does also for the OP1 of the ICCPR, which gives the individual a
    right of standing before the implementation committee.)  The CAT does
    not have such an optional protocol; rather the equivalent obligation is
    undertaken by making an Article 22 declaration, which is what is coded 
    here as well.  See the red triangles for clarification.
 
    There are a few wacky things to keep in mind about the countries.  The 
    Democratic Republic of Congo is still Zaire in these data; there are 
    two Yemens and we should just delete the DRY; there is the Czech republic
    and Czechoslovakia and we should eliminate the latter; there is still 
    Yugoslavia, and we should check to see what it is really referring to. 
    Myanmar is under Burma and Cote d'Ivoire is under Ivory Coast.  Note also 
    that the data are rectangular, even if the country did not exist in the 
    early years (they always drop out because of missing explanatory variables).
    Most of the rest is straight-forward.

    "These data are believed to be correct and complete to the best of my knowledge."
    We should each feel free to spot check at various points to be sure.
  */

** rename some variables
rename name countryname
rename iccprob iccpr
rename opirat opt1
rename catob cat

** standardize names
run "pta/scripts/Standardize Country Names.do"
run "pta/scripts/Standardize Country Codes.do"

** take out slashes in names to allow the loop below to make dyadic data out of this...
replace countryname="Italy-Sardinia" if countryname=="Italy/Sardinia"
replace countryname="Samoa-Western Samoa" if countryname=="Samoa/Western Samoa"
replace countryname="Tanzania-Tanganyika" if countryname=="Tanzania/Tanganyika"
replace countryname="Turkey-Ottoman Empire" if countryname=="Turkey/Ottoman Empire"

capture mkdir "pta/junk"
save "pta/junk/treaties.dta", replace
clear

** This creates the local for the next loop
use "pta/junk/treaties.dta", clear
levelsof countryname, local(cnames)

** This loop makes a separate dataset for each country
foreach COUNTRY of local cnames {
  use "pta/junk/treaties.dta", clear
  gen name_1="`COUNTRY'"
  rename countryname name_2
  save "pta/junk/treaty`COUNTRY'.dta", replace
  clear
}

** this makes the macro for the next loop (I need to exclude Afghanistan)
use "pta/junk/treaties.dta", clear
drop if countryname=="Afghanistan"
levelsof countryname, local(cnames)

** This loop puts all of the datasets together
use "pta/junk/treatyAfghanistan.dta", clear
foreach COUNTRY of local cnames {
  append using "pta/junk/treaty`COUNTRY'.dta"
}
 
** Note that the treaty data goes with the "name_2" country.
** drop countries paired with themselves
drop if name_1 == name_2

** change the country names with slashes back
local vars name_1 name_2
foreach countryname of local vars {
  replace `countryname'="Italy/Sardinia" if `countryname'=="Italy-Sardinia"
  replace `countryname'="Samoa/Western Samoa" if `countryname'=="Samoa-Western Samoa"
  replace `countryname'="Tanzania/Tanganyika" if `countryname'=="Tanzania-Tanganyika"
  replace `countryname'="Turkey/Ottoman Empire" if `countryname'=="Turkey-Ottoman Empire"
}

local hras iccpr opt1 cat art22
foreach HRA of local hras {
  rename `HRA' `HRA'name_2
}

save "pta/rawdata/dyadicHRAs name_2.dta", replace

  ** switch the countrynames so that the treaty data is now for the "name_1" country
rename name_1 name_1a
rename name_2 name_1
rename name_1a name_2

local hras iccpr opt1 cat art22
foreach HRA of local hras {
  rename `HRA'name_2 `HRA'name_1
}

save "pta/rawdata/dyadicHRAs name_1.dta", replace

 
  ** this makes the macro for the loop to erase the datasets
use "pta/junk/treaties.dta", clear
levelsof countryname, local(cnames)
  ** this loop erases the datasets made in the process
foreach COUNTRY of local cnames {
  erase "pta/junk/treaty`COUNTRY'.dta"
}

erase "pta/junk/treaties.dta"

clear
** Done making the treaty data


** Start working with the PTA data

** This is the Milner and Mansfield replication data from 
** Votes, Vetoes, and the Political Economy of International Trade Agreements.
** Obtained at https://ncgg.princeton.edu/ptas/ on 5/24/2013
use "pta/rawdata/milnerptadata/dyadicdata/dyadicdata.dta" 
tsset dyadid year
** Replicate Milner result
xi: logit nohs_rat2_onset2 polity2_04 polconiiiA  ptadum_new llntradenew llnGDP_gled08 ldGDP_gled08V2 larmconflict latopally fmrcol_new lcontig_new lndistance lheg_new pcw89 llnGDPratio_g onsetperc2 lnewgatt i.region nohs2_ptaonsp1_r2 nohs2_ptaonsp2_r2 nohs2_ptaonsp3_r2, cluster(dyadid)


** Looking at the years covered
gen inmysample=e(sample)
tab inmysample
tab year if inmysample==1
drop inmysample

** There is a problem with converting the cow codes -- some aren't cow codes
** This is some R code I used to try to check out the problem
/*
############################################
## R code
library(foreign)
dat <- read.dta("pta/rawdata/milnerptadata/dyadicdata/dyadicdata.dta")
#http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=3&ved=0CEAQFjAC&url=http%3A%2F%2Fcran.r-project.org%2Fweb%2Fpackages%2Fcountrycode%2Fcountrycode.pdf&ei=BSEEUtbzJPK44AP5vIDICA&usg=AFQjCNETaUtBJtKcX0FU_vUaEvJXG3f14g&sig2=9AWmMClb2ABhpa3nduob1g&bvm=bv.50500085,d.dmg
library(countrycode)
## I checked all the other options and it's clearly mostly cow codes
table(countrycode(dat$ccode1,"cown","iso3n"))
length(dat$ccode1) - length(na.omit(countrycode(dat$ccode1,"cown","iso3n")))
## these are the codes that are not cow codes
unique(dat$ccode1[which(is.na(countrycode(dat$ccode1,"cown","cowc")))])
unique(dat$ccode2[which(is.na(countrycode(dat$ccode2,"cown","cowc")))])
## 260, 532, 678, 715, 720, 721, 731, 817
## According to Jana von Stien's cow code list: http://www-personal.umich.edu/~janavs/cowcodes.do
## 260 = Germany
## The rest are unidentifiable.
## I will drop them
############################################
*/

** Ultimately, I drop the codes that I can't figure out
di _N
drop if ccode1== 260 | ccode1==532 | ccode1==678 | ccode1==715 | ccode1==720 | ccode1==721 | ccode1==731 | ccode1==817
drop if ccode2== 260 | ccode2==532 | ccode2==678 | ccode2==715 | ccode2==720 | ccode2==721 | ccode2==731 | ccode2==817
di _N
** The results remaine the same
xi: logit nohs_rat2_onset2 polity2_04 polconiiiA  ptadum_new llntradenew llnGDP_gled08 ldGDP_gled08V2 larmconflict latopally fmrcol_new lcontig_new lndistance lheg_new pcw89 llnGDPratio_g onsetperc2 lnewgatt i.region nohs2_ptaonsp1_r2 nohs2_ptaonsp2_r2 nohs2_ptaonsp3_r2, cluster(dyadid)


gen country=""
gen partner=""
run "pta/scripts/COW convert.do"
rename country name_1
rename partner name_2
duplicates tag name_1 name_2 year, gen(dup)
tab dup
drop dup


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

** Merge in the HRA data
merge 1:1 name_1 name_2 year using "pta/rawdata/dyadicHRAs name_1.dta", generate(_mergeHRA1)
** check the merge
edit ccode1 ccode2 name_1 name_2 year _mergeHRA1
*drop if year < 1967 | year > 2006
tab _mergeHRA1
edit ccode1 ccode2 name_1 name_2 year if _mergeHRA1==1
tab name_2 if _mergeHRA1==1
** I think the rest can be deleted -- I'm losing the states that have very high counts on the last tab
*drop if _mergeHRA1==1
tab _mergeHRA1
edit ccode1 ccode2 name_1 name_2 year if _mergeHRA1==2
** basically, the treaty data has countries from before they exist, but the pta data doesn't
drop if _mergeHRA1==2

merge 1:1 name_1 name_2 year using "pta/rawdata/dyadicHRAs name_2.dta", generate(_mergeHRA2)
* this is the same
*drop if _mergeHRA2==2

sort name_1 name_2 year


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
** I think I've merged them correctly


** add in human rights data
capture mkdir "pta/madedata"
save "pta/madedata/tmPTAs.dta", replace
use "pta/madedata/tmPTAs.dta", clear
replace name_1 = regexr(name_1,"/","---")
levelsof name_1, local(levels)
** this is the Cingrinelli-Richards human rights data, accessed 5/4/2007
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
save "pta/junk/CIRI vars.dta" , replace
foreach i of local levels{
  use "pta/junk/CIRI vars.dta"
  rename countryname name_2
  gen name_1 = regexr("`i'","---","/")
  save "pta/junk/`i'.dta", replace
  di "`i'"
}
clear
*use "junk\Afghanistan.dta", clear
foreach i of local levels {
  append using "pta/junk/`i'.dta"
  erase "pta/junk/`i'.dta"
}
erase "pta/junk/CIRI vars.dta"
drop if name_1==name_2
save "pta/junk/CIRI vars for merge.dta", replace
use "pta/madedata/tmPTAs.dta", clear


merge name_1 name_2 year using "pta/junk/CIRI vars for merge.dta", unique sort _merge(_merge_ciri_vars)
** we don't have to worry about the 1s
tab year if _merge_ciri_vars==1
**I think we can just drop the 2s -- 
edit ccode1 ccode2 name_1 name_2 year if _merge_ciri_vars==2
drop if _merge_ciri_vars==2
drop  _merge_ciri_vars
erase "pta/junk/CIRI vars for merge.dta"


/*  This adds an OECD variable, as defined by the World Bank, 2006 */
gen OECD=1 if name_1=="United States of America" | name_1=="Austria" | name_1=="Belgium" | name_1=="Canada" | name_1=="Denmark" | name_1=="France" | name_1=="German Federal Republic" | name_1=="Greece" | name_1=="Iceland" | name_1=="Ireland" | name_1=="Italy/Sardinia" | name_1=="Luxembourg" | name_1=="Netherlands" | name_1=="Norway" | name_1=="Portugal" | name_1=="Spain" | name_1=="Sweden" | name_1=="Switzerland" | name_1=="United Kingdom"
replace OECD=1 if name_1=="Japan" | name_1=="Finland" | name_1=="Australia" | name_1=="New Zealand"
replace OECD=1 if name_1=="Germany West (1945-1990)" | name_1=="Germany (1991+)"
/*Not sure about these ones--these are the new members?*/
*replace OECD=1 if name_1=="Turkey/Ottoman Empire" | name_1=="Mexico" | name_1=="Czech Republic"  | name_1=="Hungary" | name_1=="Poland" | name_1=="Korea, Republic of" | name_1=="Slovakia"
replace OECD=0 if OECD!=1

/*  This adds an OECDname2 variable, as defined by the World Bank, 2006 */
gen OECDname2=1 if name_2=="United States of America" | name_2=="Austria" | name_2=="Belgium" | name_2=="Canada" | name_2=="Denmark" | name_2=="France" | name_2=="German Federal Republic" | name_2=="Greece" | name_2=="Iceland" | name_2=="Ireland" | name_2=="Italy/Sardinia" | name_2=="Luxembourg" | name_2=="Netherlands" | name_2=="Norway" | name_2=="Portugal" | name_2=="Spain" | name_2=="Sweden" | name_2=="Switzerland" | name_2=="United Kingdom"
replace OECDname2=1 if name_2=="Japan" | name_2=="Finland" | name_2=="Australia" | name_2=="New Zealand"
replace OECDname2=1 if name_2=="Germany West (1945-1990)" | name_2=="Germany (1991+)"
/*Not sure about these ones--these are the new members?*/
*replace OECDname2=1 if name_2=="Turkey/Ottoman Empire" | name_2=="Mexico" | name_2=="Czech Republic"  | name_2=="Hungary" | name_2=="Poland" | name_2=="Korea, Republic of" | name_2=="Slovakia"
replace OECDname2=0 if OECDname2!=1

** I don't use region because it's colinear in the Art22 matching and the variance covariance matrix can't be inverted
drop _Iregion*

save "pta/madedata/tmPTAs.dta", replace


****************************
** make ratification episode data sets

foreach HRA in iccpr opt1 cat art22 {

  di "`HRA'"

  use "pta/madedata/tmPTAs.dta", clear
  
  ** ICCPR
  ** now, lag the controls so that I can just pull out the treated chunks
  gen elig = 0
  quietly replace elig = 1 if `HRA'name2_treat2==1 & (name_1[_n]==name_1[_n-1]) & (name_2[_n]==name_2[_n-1]) 

  drop if dyadid==.
  tsset dyadid year
  local controls physint polity2_04 polconiiiA  ptadum_new llntradenew llnGDP_gled08 ldGDP_gled08V2 larmconflict latopally fmrcol_new lcontig_new lndistance lheg_new pcw89 llnGDPratio_g onsetperc2 lnewgatt /*_Iregion_2 _Iregion_3 _Iregion_4 _Iregion_5 _Iregion_6 _Iregion_7 _Iregion_8*/

  foreach V of local controls {
    foreach i of numlist 1/5 {
      *di "`V'"`i'
      quietly gen l`i'`V' = l`i'.`V'
    }
  }

  ** make leads of the outcome
local leads nohs_rat2_onset2
foreach V of local leads {
  foreach i of numlist 1/5 {
    *di "`V'"`i'
    quietly gen f`i'`V' = f`i'.`V'
  }
}

** keep only the treated units
local keepme name_1 name_2 dyadid year f1* f2* f3* f4* f5* l1* l2* l3* l4* l5*  ///
             polity2_04 polconiiiA  ptadum_new llntradenew llnGDP_gled08 ldGDP_gled08V2 larmconflict latopally fmrcol_new lcontig_new lndistance lheg_new pcw89 llnGDPratio_g onsetperc2 lnewgatt nohs2_ptaonsp1_r2 nohs2_ptaonsp2_r2 nohs2_ptaonsp3_r2 ///
             elig `HRA'name2_treat2 nohs_rat2_onset2 OECDname2 OECD `HRA'name_1 `HRA'name_2 
			 /*_Iregion* */

keep `keepme'

quietly compress
save "pta/junk/tradetmp.dta", replace

keep if elig==1

gen treated = 1
save "pta/junk/treated.dta", replace



** find control chunks
use "pta/junk/tradetmp.dta", clear

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
save "pta/junk/control.dta", replace

** append the treated
append using "pta/junk/treated.dta"


** make a few aid outcome variables
** I sum the indicators, but don't count it if they sign multiple ptas in that time.
gen pta012 = (nohs_rat2_onset2 + f1nohs_rat2_onset2 + f2nohs_rat2_onset2) > 0 & (nohs_rat2_onset2 + f1nohs_rat2_onset2 + f2nohs_rat2_onset2) < .
replace pta012 = . if nohs_rat2_onset2==. | f1nohs_rat2_onset2==. | f2nohs_rat2_onset2==.
gen pta123 = (f1nohs_rat2_onset2 + f2nohs_rat2_onset2 + f3nohs_rat2_onset2) > 0 & (f1nohs_rat2_onset2 + f2nohs_rat2_onset2 + f3nohs_rat2_onset2) < .
replace pta123 = . if f1nohs_rat2_onset2==. | f2nohs_rat2_onset2==. | f3nohs_rat2_onset2==.
gen pta012345 = (nohs_rat2_onset2 + f1nohs_rat2_onset2 + f2nohs_rat2_onset2 + f3nohs_rat2_onset2 + f4nohs_rat2_onset2 + f5nohs_rat2_onset2) > 0 & (nohs_rat2_onset2 + f1nohs_rat2_onset2 + f2nohs_rat2_onset2 + f3nohs_rat2_onset2 + f4nohs_rat2_onset2 + f5nohs_rat2_onset2) < .
replace pta012345 = . if nohs_rat2_onset2==. | f1nohs_rat2_onset2==. | f2nohs_rat2_onset2==. | f3nohs_rat2_onset2==. | f4nohs_rat2_onset2==. | f5nohs_rat2_onset2==.
gen pta01234 = (nohs_rat2_onset2 + f1nohs_rat2_onset2 + f2nohs_rat2_onset2 + f3nohs_rat2_onset2 + f4nohs_rat2_onset2) > 0 & (nohs_rat2_onset2 + f1nohs_rat2_onset2 + f2nohs_rat2_onset2 + f3nohs_rat2_onset2 + f4nohs_rat2_onset2) < .
replace pta01234 = . if nohs_rat2_onset2==. | f1nohs_rat2_onset2==. | f2nohs_rat2_onset2==. | f3nohs_rat2_onset2==. | f4nohs_rat2_onset2==.

save "pta/madedata/`HRA'RatEpisodeDat.dta", replace

** make a data set with just ratifying to non ratifying countries
use "pta/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'name_1==1 & `HRA'name_2==0
save "pta/madedata/`HRA'RatEpisodeDat_Ratifiers.dta", replace

** make a data set with just the non-ratifying countries as potential rewardees.
use "pta/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'name_2==0
save "pta/madedata/`HRA'RatEpisodeDat_nonRatifiers.dta", replace

** make a data set with just ratifying 
use "pta/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'name_1==1
save "pta/madedata/`HRA'RatEpisodeDat_Ratifiers1.dta", replace


}




