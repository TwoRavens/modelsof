** Rich Nielsen
** This file combines ratification data for the ICCPR and CAT with
** Goldstien, Rivers, and Tomz's (2007) gravity model of trade

clear
set more off

capture mkdir "trade/junk"

** load the treaty data and format it
insheet using "other/ICCPR and CAT through 2008.csv"

  ** standardize the country names
  /* Notes from Beth about the data:
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

  rename name countryname
  rename iccprob iccpr
  rename opirat opt1
  rename catob cat

  drop if countryname=="Czechos"
  drop if countryname=="YemenAR"

  run "pta/scripts/Standardize Country Names.do"
  run "pta/scripts/Standardize Country Codes.do"
   
  tab countryname if countrycode_g=="Country Code (Gleditsch)"

  ** to match Tomz's country names, I match a few of his country names which 
  ** make the following distinctions (different from my normal ones):
  replace countryname="Ethiopia (-1992)" if countryname=="Ethiopia" & year<=1992
  replace countryname="Ethiopia (1993+)" if countryname=="Ethiopia" & year>=1993
  replace countryname="Germany West (1945-1990)" if countryname=="German Federal Republic" & year<=1990
  replace countryname="Germany (1991+)" if countryname=="German Federal Republic" & year>=1991
  replace countryname="Pakistan (-1971)" if countryname=="Pakistan" & year<=1971
  replace countryname="Pakistan (1972+)" if countryname=="Pakistan" & year>=1972
  replace countryname="Pakistan (1972+)" if countryname=="Pakistan" & year>=1972
  replace countryname="Ussr (1917-1991)" if countryname=="Russia (Soviet Union)" & year<=1991
  replace countryname="Russia (1992-)" if countryname=="Russia (Soviet Union)" & year>=1992
  replace countryname="Serbia And Montenegro (1992-9999)" if countryname=="Yugoslavia (Serbia)" & year>=1992 & year <=1999
  replace countryname="Vietnam Unified (1976+)" if countryname=="Vietnam, Democratic Republic of" & year>=1976
  replace countryname="Yemen Unified (1990-)" if countryname=="Yemen, People's Republic of" & year>=1990

    ** to allow the loop below to make dyadic data out of this...
  replace countryname="Italy-Sardinia" if countryname=="Italy/Sardinia"
  replace countryname="Samoa-Western Samoa" if countryname=="Samoa/Western Samoa"
  replace countryname="Tanzania-Tanganyika" if countryname=="Tanzania/Tanganyika"
  replace countryname="Turkey-Ottoman Empire" if countryname=="Turkey/Ottoman Empire"


  ** make dummy variables for each year after ratification
  ** PROBLEM:  what do we do with a case like the USSR/Russia, where the ratification isn't new
  **  but the rules I've coded here would count it as new because it is a "new" country
  

  local hras iccpr opt1 cat art22
  foreach HRA of local hras {
    gen `HRA'_yrs = 0 if `HRA'==0
    replace `HRA'_yrs=1 if `HRA'==1 & `HRA'[_n-1]==0 & countryname==countryname[_n-1]
      ** the line below makes it so that "new" states (USSR -> Russia)
      **    start over on their ratification year.
      ** leaving it out leaves these states with missing values which doesn't seem right either.
    *replace `HRA'_yrs=1 if `HRA'==1 & countryname!=countryname[_n-1]
    replace `HRA'_yrs = `HRA'_yrs[_n-1]+1 if `HRA'_yrs==. & `HRA'!=. & countryname==countryname[_n-1]
  }

  ** what if the rewards come prior to the ratification?
  ** we make a second ratification years that has the year 6 years prior to ratification as the base year
  egen countrynum = group(countryname)
  tsset countrynum year

  local hras iccpr opt1 cat art22
  foreach HRA of local hras {
    gen `HRA'_yrs2 = f10.`HRA'_yrs  
    replace `HRA'_yrs2 = `HRA'_yrs2[_n-1]+1 if `HRA'_yrs2[_n-1]>0 & `HRA'_yrs2[_n-1]!=. & `HRA'_yrs2==. & `HRA'!=. & countryname==countryname[_n-1]
    replace `HRA'_yrs2 = 0 if `HRA'_yrs2[_n-1]==0 & `HRA'_yrs2==. & `HRA'!=. & countryname==countryname[_n-1]
  }



save "trade/junk/treaties.dta", replace
clear

  ** This creates the local for the next loop
use "trade/junk/treaties.dta", clear
levelsof countryname, local(cnames)

  ** This loop makes a separate dataset for each country
foreach COUNTRY of local cnames {
  use "trade/junk/treaties.dta", clear
  gen name_1="`COUNTRY'"
  rename countryname name_2
  save "trade/junk/treaty`COUNTRY'.dta", replace
  clear
}

  ** this makes the macro for the next loop (I need to exclude Afghanistan)
use "trade/junk/treaties.dta", clear
drop if countryname=="Afghanistan"
levelsof countryname, local(cnames)

  ** This loop puts all of the datasets together
use "trade/junk/treatyAfghanistan.dta", clear
foreach COUNTRY of local cnames {
  append using "trade/junk/treaty`COUNTRY'.dta"
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
  rename `HRA'_yrs `HRA'_yrs_name_2
  rename `HRA'_yrs2 `HRA'_yrs2_name_2
}

drop countrynum

save "trade/junk/dyadicHRAs name_2.dta", replace

  ** switch the countrynames so that the treaty data is now for the "name_1" country
rename name_1 name_1a
rename name_2 name_1
rename name_1a name_2

local hras iccpr opt1 cat art22
foreach HRA of local hras {
  rename `HRA'name_2 `HRA'name_1
  rename `HRA'_yrs_name_2 `HRA'_yrs_name1
  rename `HRA'_yrs2_name_2 `HRA'_yrs2_name1
}
drop countrynum
save "trade/junk/dyadicHRAs name_1.dta", replace

 
  ** this makes the macro for the loop to erase the datasets
use "trade/junk/treaties.dta", clear
levelsof countryname, local(cnames)
  ** this loop erases the datasets made in the process
foreach COUNTRY of local cnames {
  erase "trade/junk/treaty`COUNTRY'.dta"
}

erase "trade/junk/treaties.dta"

clear



** load the trade data
use "trade/rawdata/GRT_IO2007\GRT_IO_2007.dta", clear

  ** standardize the country names
     **
  rename name_1 countryname
  run "pta/scripts/Standardize Country Names.do"
  run "pta/scripts/Standardize Country Codes.do"
  tab countryname if countrycode_g=="Country Code (Gleditsch)"
  rename countryname name_1

  rename name_2 countryname
  run "pta/scripts/Standardize Country Names.do"
  run "pta/scripts/Standardize Country Codes.do"
  tab countryname if countrycode_g=="Country Code (Gleditsch)"
  rename countryname name_2

** merge the datasets
merge name_1 name_2  year using "trade/junk/dyadicHRAs name_1.dta", unique sort _merge(_mergeHRA1)
merge name_1 name_2  year using "trade/junk/dyadicHRAs name_2.dta", unique sort _merge(_mergeHRA2)

erase "trade/junk/dyadicHRAs name_1.dta"
erase "trade/junk/dyadicHRAs name_2.dta"
capture erase "trade/junk/dyadicHRAs.dta"



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

** Trade data complete
save "trade/rawdata/trade rewards.dta", replace




**  ADD the CIRI human rights variables
insheet using "trade/rawdata/CIRI 2007.csv", clear
rename ctry countryname
do "pta/scripts/Standardize Country Names.do"
do "pta/scripts/Standardize Country Codes.do"

replace countryname = "Ethiopia (-1992)" if countryname=="Ethiopia" & year <= 1992
replace countryname = "Ethiopia (1993+)" if countryname=="Ethiopia" & year >= 1993
replace countryname = "Germany West (1945-1990)" if countryname=="German Federal Republic" & year <= 1990
replace countryname = "Germany (1991+)" if countryname=="German Federal Republic" & year >= 1991
replace countryname = "Pakistan (-1971)" if countryname=="Pakistan" & year <= 1971
replace countryname = "Pakistan (1972+)" if countryname=="Pakistan" & year >= 1972
replace countryname = "Russia (1992-)" if countryname=="Russia (Soviet Union)" & year >= 1992
replace countryname = "Ussr (1917-1991)" if countryname=="Russia (Soviet Union)" & year <= 1991
replace countryname = "Serbia And Montenegro (1992-9999)" if countryname=="Yugoslavia, Federal Republic Of" & year >= 1992 & year <= 1999
replace countryname = "Vietnam Unified (1976+)" if countryname=="Vietnam, Democratic Republic of" & year >= 1976
replace countryname = "Yemen Unified (1990-)" if countryname=="Yemen (Arab Republic of Yemen)" & year >= 1990
replace countryname = "Yemen (Arab Republic of Yemen)" if countryname=="Yemen (Arab Republic of Yemen)" & year <= 1989
replace countryname = "Yemen, People's Republic of" if countryname=="Yemen, People's Republic of" & year <= 1989



gen name_1 = "United States of America"
rename countryname name_2

  ** get rid of some duplicates
duplicates tag name_1 name_2 year, gen(dup)
sort name_2 year
drop if dup>0 & cow==.
drop if dup>0 & unctry==.

drop dup
duplicates tag name_1 name_2 year, gen(dup) 
drop if dup>0 & physint==.
drop dup
duplicates list name_1 name_2 year

keep name_1 name_2 year physint disap kill polpris tort old_empinx
rename old_empinx empinx

replace  physint=. if physint==-999 /*1 missing value*/
replace  disap=. if disap==-999 
replace  kill=. if kill==-999 
replace  polpris=. if polpris==-999 
replace  tort=. if tort==-999 
replace  empinx=. if empinx==-999 /*1 missing value*/

replace  physint=. if physint==-77  /* 0 missing value */
replace  disap=. if disap==-77
replace  kill=. if kill==-77
replace  polpris=. if polpris==-77
replace  tort=. if tort==-77
replace  empinx=. if empinx==-77  /* 0 missing value */
replace  physint=. if physint==-66  /* 2 missing value */
replace  disap=. if disap==-66
replace  kill=. if kill==-66
replace  polpris=. if polpris==-66
replace  tort=. if tort==-66
replace  empinx=. if empinx==-66  /* 0 missing value */

save "trade/junk/ciri for merge.dta", replace



use "trade/rawdata/trade rewards.dta", clear
merge name_1 name_2 year using "trade/junk/ciri for merge.dta", unique sort

egen physint1 = max(physint), by(name_2 year)
egen empinx1 = max(empinx), by(name_2 year)



** Trade data complete
save "trade/rawdata/trade rewards.dta", replace

beep




