** load the trade data
** this script assumes that the current dir is the top level of the archive

clear
set more off

use "trade/rawdata/GRT_IO2007\GRT_IO_2007.dta", clear
capture mkdir "trade/madedata"
capture mkdir "trade/junk"

** Code directly from Tomz's do-file

*****************************************************
* CREATE DUMMY VARIABLES FOR GATT/WTO PARTICIPATION *
*****************************************************

* Gatt: Formal membership
gen byte gattF_1 = cond(gatt_1=="wto"|gatt_1=="art33"|gatt_1=="orig"|gatt_1=="art26:5", 1, 0)  /* GATT: Country 1 is formal member */
gen byte gattF_2 = cond(gatt_2=="wto"|gatt_2=="art33"|gatt_2=="orig"|gatt_2=="art26:5", 1, 0)  /* GATT: Country 2 is formal member */

* Gatt: Nonmember participant
gen byte gattN_1 = cond(gatt_1=="col"|gatt_1=="df"|gatt_1=="prov", 1, 0) /* GATT: Country 1 is a NMP */
gen byte gattN_2 = cond(gatt_2=="col"|gatt_2=="df"|gatt_2=="prov", 1, 0) /* GATT: Country 2 is a NMP */

* Gatt: Participation (EITHER formal OR defacto)
gen byte gattP_1 = cond(gatt_1=="out", 0, 1) /* GATT: Country 1 participates */
gen byte gattP_2 = cond(gatt_2=="out", 0 ,1) /* GATT: Country 2 participates */

* Gatt: Interactions
gen byte gattPP = cond(gattP_1==1 & gattP_2==1, 1, 0)
label var gattPP "GATT: Both Participate"
gen byte gattPO = cond((gattP_1==1 & gattP_2==0)|(gattP_1==0 & gattP_2==1), 1, 0)
label var gattPO "GATT: Only one participates"
gen byte gattFF = cond(gattF_1==1 & gattF_2==1,1,0)
label var gattFF "GATT: Both are formal members"
gen byte gattFN = cond((gattF_1==1 & gattN_2==1)|(gattN_1==1 & gattF_2==1),1,0)
label var gattFN "GATT: One formal, one NMP"
gen byte gattFO = cond((gattF_1==1 & gattP_2==0)|(gattP_1==0 & gattF_2==1),1,0)
label var gattFO "GATT: One formal, other is out"
gen byte gattNN = cond(gattN_1==1 & gattN_2==1,1,0)
label var gattNN "GATT: Both nonmbr participants"
gen byte gattNO = cond((gattN_1==1 & gattP_2==0)|(gattP_1==0 & gattN_2==1),1,0)
label var gattNO "GATT: One NMP, other is out"
drop gattF_1 gattF_2 gattN_1 gattN_2 gattP_1 gattP_2 

gen byte round1 = cond(year < 1949, 1, 0)                 /* GATT pre Annecy round */
gen byte round2 = cond(year >= 1949 & year < 1951, 1, 0)  /* Annecy to Torquay round */
gen byte round3 = cond(year >= 1951 & year < 1956, 1, 0)  /* Torquay to Geneva */
gen byte round4 = cond(year >= 1956 & year < 1961, 1, 0)  /* Geneva to Dillon */
gen byte round5 = cond(year >= 1961 & year < 1967, 1, 0)  /* Dillon to Kennedy */
gen byte round6 = cond(year >= 1967 & year < 1979, 1, 0)  /* Kennedy to Tokyo */
gen byte round7 = cond(year >= 1979 & year < 1994, 1, 0)  /* Tokyo to Uruguay */
gen byte round8 = cond(year >= 1994, 1, 0)                /* After Uruguay round */
forvalues i = 1/8 {                                  /* create variables for each of 8 rounds */ 
   gen byte gattPP_round`i' = gattPP * round`i'
   label var gattPP_round`i' "GATT: Both Participate, Round `i'"              
   gen byte gattPO_round`i' = gattPO * round`i'
   label var gattPO_round`i' "GATT: One Participates, Round `i'"             
   local gattPPbyround `gattPPbyround' gattPP_round`i'
   local gattPObyround `gattPObyround' gattPO_round`i'
}
drop round1-round8

* Article 35 invoked by one or both countries?
gen byte gatt35x1 = cond((gatt35_1==1 & gatt35_2==0)|(gatt35_1==0 & gatt35_2==1),1,0) /* only one invokes */
label var gatt35x1 "GATT: One invokes Art 35"
gen byte gatt35x2 = cond(gatt35_1==1 & gatt35_2==1,1,0)  /* both invoke */
label var gatt35x2 "GATT: Both invoke Art 35"

****************************
* GENERATE OTHER VARIABLES *
****************************

quietly tab year, gen(yeardummy)
gen byte ptarecip_nohigher = cond(ptarecip == 1 & colorbit==0, 1, 0)
gen byte ptarecip_withhigher = cond(ptarecip == 1 & colorbit==1, 1, 0)
gen byte gattPP_nocolrecip = cond(gattPP == 1 & colorbit==0 & ptarecip==0, 1, 0)
gen byte gattPP_withcolrecip = cond(gattPP == 1 & (colorbit==1 | ptarecip==1),1,0)
gen byte gattPO_nocolrecip = cond(gattPO == 1 & colorbit==0 & ptarecip==0, 1, 0)
gen byte gattPO_withcolrecip = cond(gattPO == 1 & (colorbit==1 | ptarecip==1),1,0)
gen byte nonrecip_nohigher = cond((gsp==1 | ptanonrecip==1) & colorbit == 0 & ptarecip==0 & gattPP==0 & gattPO==0,1,0)
gen byte nonrecip_withhigher = cond((gsp==1 | ptanonrecip==1) & (colorbit==1 | ptarecip==1 | gattPP==1 | gattPO==1),1,0)

** End tomz code


  ** standardize the country names
     **
  rename name_1 countryname
  replace countryname="Ethiopia" if countryname=="Ethiopia (-1992)" |  countryname=="Ethiopia (1993+)"
  replace  countryname="German Federal Republic" if countryname=="Germany West (1945-1990)" | countryname=="Germany (1991+)"
  replace countryname="German Federal Republic" if countryname=="Germany (1991+)"
  replace countryname="Pakistan" if countryname=="Pakistan (-1971)" | countryname=="Pakistan (1972+)"
  replace countryname="Russia (Soviet Union)" if countryname=="Ussr (1917-1991)" | countryname=="Russia (1992-)" | countryname=="USSR (1917-1991)"
  replace countryname="Yugoslavia (Serbia)" if countryname=="Serbia and Montenegro (1992-9999)"
  replace countryname="Vietnam, Democratic Republic of" if countryname=="Vietnam Unified (1976+)"
  replace countryname="Yemen, People's Republic of" if countryname=="Yemen Unified (1990-)"
  replace countryname="East Germany" if countryname=="Germany East (1945-1990)"
  replace countryname="Yugoslavia" if countryname=="Yugoslavia (1918-1992)"
  run "pta/scripts/Standardize Country Names.do"
  run "pta/scripts/Standardize Country Codes.do"
  tab countryname if countrycode_g=="Country Code (Gleditsch)"
  rename countryname name_1

  rename name_2 countryname
  replace countryname="Ethiopia" if countryname=="Ethiopia (-1992)" |  countryname=="Ethiopia (1993+)"
  replace  countryname="German Federal Republic" if countryname=="Germany West (1945-1990)" | countryname=="Germany (1991+)"
  replace countryname="German Federal Republic" if countryname=="Germany (1991+)"
  replace countryname="Pakistan" if countryname=="Pakistan (-1971)" | countryname=="Pakistan (1972+)"
  replace countryname="Russia (Soviet Union)" if countryname=="Ussr (1917-1991)" | countryname=="Russia (1992-)" | countryname=="USSR (1917-1991)"
  replace countryname="Yugoslavia (Serbia)" if countryname=="Serbia and Montenegro (1992-9999)"
  replace countryname="Vietnam, Democratic Republic of" if countryname=="Vietnam Unified (1976+)"
  replace countryname="Yemen, People's Republic of" if countryname=="Yemen Unified (1990-)"
  replace countryname="East Germany" if countryname=="Germany East (1945-1990)"
  replace countryname="Yugoslavia" if countryname=="Yugoslavia (1918-1992)"
  run "pta/scripts/Standardize Country Names.do"
  run "pta/scripts/Standardize Country Codes.do"
  tab countryname if countrycode_g=="Country Code (Gleditsch)"
  rename countryname name_2
    
	
*gen inmysample = e(sample)
*drop if inmysample==0
merge 1:1 name_1 name_2 year using "pta/rawdata/dyadicHRAs name_1.dta", generate(_mergeHRA1)
** check the merge
drop if year<= 1967
edit name_1 name_2 year _mergeHRA1
drop if _mergeHRA1!=3
drop _merge*

merge 1:1 name_1 name_2 year using "pta/rawdata/dyadicHRAs name_2.dta", generate(_mergeHRA2)
drop if year<= 1967
tab _mergeHRA2
drop if _mergeHRA2!=3
* this is the same
*drop if _mergeHRA2==2
sort name_1 name_2 year
save "bits/madedata/tmpTrade.dta", replace

rename directed_dyad_id dyadid

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


save "trade/madedata/tmpTrade.dta", replace

use "trade/madedata/tmpTrade.dta", clear
replace name_1 = regexr(name_1,"/","---")
levelsof name_1, local(levels)
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
save "trade/junk/CIRI vars.dta" , replace
foreach i of local levels{
  use "trade/junk/CIRI vars.dta"
  rename countryname name_2
  gen name_1 = regexr("`i'","---","/")
  save "trade/junk/`i'.dta", replace
  di "`i'"
}
clear
*use "junk\Afghanistan.dta", clear
foreach i of local levels {
  append using "trade/junk/`i'.dta"
  erase "trade/junk/`i'.dta"
}
erase "trade/junk/CIRI vars.dta"
drop if name_1==name_2
save "trade/junk/CIRI vars for merge.dta", replace
use "trade/madedata/tmpTrade.dta", clear


merge name_1 name_2 year using "trade/junk/CIRI vars for merge.dta", unique sort _merge(_merge_ciri)
** we don't have to worry about the 1s
tab year if _merge_ciri==1
drop if _merge_ciri!=3
erase "trade/junk/CIRI vars for merge.dta"
save "trade/madedata/tmpTrade.dta", replace




***************************
** make ratification episode data sets


foreach HRA in iccpr opt1 cat art22 {

  di "`HRA'"

  use "trade/madedata/tmpTrade.dta", clear
  
  ** ICCPR
  ** now, lag the controls so that I can just pull out the treated chunks
  gen elig = 0
  quietly replace elig = 1 if `HRA'name2_treat2==1 & (name_1[_n]==name_1[_n-1]) & (name_2[_n]==name_2[_n-1]) 

  drop if dyadid==.
  tsset dyadid year
  local controls physint gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area
  
  foreach V of local controls {
    foreach i of numlist 1/5 {
      *di "`V'"`i'
      quietly gen l`i'`V' = l`i'.`V'
    }
  }

  ** make leads of the outcome
local leads imports
foreach V of local leads {
  foreach i of numlist 1/5 {
    *di "`V'"`i'
    quietly gen f`i'`V' = f`i'.`V'
  }
}

** keep only the treated units
local keepme name_1 name_2 dyadid year f1* f2* f3* f4* f5* l1* l2* l3* l4* l5*  ///
             physint gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area ///
             elig `HRA'name2_treat2 imports `HRA'name_1 `HRA'name_2 
			 /*_Iregion* */

keep `keepme'

quietly compress
save "trade/junk/tradetmp.dta", replace

keep if elig==1

gen treated = 1
save "trade/junk/treated.dta", replace



** find control chunks
use "trade/junk/tradetmp.dta", clear

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
save "trade/junk/control.dta", replace

** append the treated
append using "trade/junk/treated.dta"


** make a few aid outcome variables
** I sum the indicators, but don't count it if they sign multiple ptas in that time.
gen imports012 = imports + f1imports + f2imports
replace imports012 = . if imports==. | f1imports==. | f2imports==.
gen imports123 = f1imports + f2imports + f3imports
replace imports123 = . if f1imports==. | f2imports==. | f3imports==.
gen imports012345 = imports + f1imports + f2imports + f3imports + f4imports + f5imports
replace imports012345 = . if imports==. | f1imports==. | f2imports==. | f3imports==. | f4imports==. | f5imports==.

save "trade/madedata/`HRA'RatEpisodeDat.dta", replace


** make a data set with just ratifying to non ratifying countries
use "trade/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'name_1==1 & `HRA'name_2==0
save "trade/madedata/`HRA'RatEpisodeDat_Ratifiers.dta", replace

** make a data set with just the non-ratifying countries as potential rewardees.
use "trade/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'name_2==0
save "trade/madedata/`HRA'RatEpisodeDat_nonRatifiers.dta", replace

** make a data set with just ratifying 
use "trade/madedata/`HRA'RatEpisodeDat.dta"
keep if `HRA'name_1==1
save "trade/madedata/`HRA'RatEpisodeDat_Ratifiers1.dta", replace

}
