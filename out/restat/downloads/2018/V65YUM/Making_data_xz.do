********************************************************************************
* Making_data_xz.do
* May, 2018
*\
* This constructs the data for regressors & instruments.
********************************************************************************

********************
* I. Preliminaries *
********************

clear
cap clear matrix
set more off, permanently

set matsize 10000


* log file
cap log close
log using log/making-data-xz.log, replace



use "src/usa_00173", clear

drop if year==1850 /*drop sample, append full census*/ 
append using "src/usa_00174.dta"  /*1850 full census (100%)*/

drop if datanum==1 & year==1880 /*this sample does not have the literacy variable*/

* account for differences in sampling rates
gen stock=100
replace stock=10 if year==1880 /*There are two 1880 samples, 10% & 100%, the 10% sample has literacy*/
replace stock=20 if year==1900|year==1930
replace stock=1 if year==1850
gen byte obs=1

* drop children (< 15 years)
drop if age<15


************************
* II.A. Literacy Variables
************************
* To construct "high" and "low" skill from literacy data, 
* This part comes from industry_ipums.do

*Gen a dummy for manufacturing industries
gen manu=(ind1950>=300 & ind1950<500) if ind1950~=0 & ind1950~=.
replace ind1950=0 if manu==0

gen clerks=occ1950<=499 if occ1950~=0 & occ1950<980
gen skilled=occ1950>=500 & occ1950<=699 if occ1950~=0 & occ1950<980
gen wageworkers=occ1950>=700 & occ1950<=970 if occ1950~=0 & occ1950<980

gen literate=lit==4 if lit~=0 & lit~=.
replace literate=0 if lit==0 & year<=1860 /*literacy in 1850 & 1860*/
replace literate=higrade>5 if year==1940 & higrade~=./*05 is second grade of elementary school (attended or completed)*/

keep if literate~=.

gen clerks_lit=clerks*literate
gen skilled_lit=skilled*literate
gen wageworkers_lit=wageworkers*literate

gen clerks_notlit=clerks*(1-literate)
gen skilled_notlit=skilled*(1-literate)
gen wageworkers_notlit=wageworkers*(1-literate)


gen lowskill_stock=(1-literate)
gen highskill_stock=literate


drop clerks skilled wageworkers literate 


*************************************
* III.A Country groups for immigrats *
*************************************

* create country groups for immigrants
* (cgrps program from original do-file, modified to fit the new country groups) 

cap program drop cgrps
program define cgrps
gen agethcode=.
replace agethcode=0 if bpld<15000
replace agethcode=1 if (bpld>=41000 & bpld<41100) | bpld==41300
replace agethcode=2 if bpld==41100
replace agethcode=3 if bpld>=41400 & bpld<41900
replace agethcode=4 if bpld==41200
replace agethcode=5 if bpld>=42100 & bpld<42200
replace agethcode=6 if bpld>=45000 & bpld<45100
replace agethcode=7 if bpld>=45300 & bpld<45400
replace agethcode=8 if bpld==42600
replace agethcode=9 if bpld>=40000 & bpld<40100
replace agethcode=10 if bpld>=40400 & bpld<40500
replace agethcode=11 if bpld==40500
replace agethcode=12 if (bpld>=46000 & bpld<49900) | (bpld>=45500 & bpld<45600)
replace agethcode=13 if bpld>=43300 & bpld<43400
replace agethcode=14 if bpld==43400
replace agethcode=15 if bpld==42500
replace agethcode=16 if bpld==42000
replace agethcode=17 if bpld==43800
replace agethcode=18 if bpld>=43600 & bpld<43700
replace agethcode=19 if bpld>=45200 & bpld<45300
replace agethcode=20 if bpld==40100
replace agethcode=21 if bpld==45400
replace agethcode=22 if bpld>=45600 & bpld<45700
replace agethcode=23 if bpld>=40000 & bpld<50000 & agethcode==.
replace agethcode=24 if bpld>=15000 & bpld<15500
replace agethcode=25 if bpld==20000
replace agethcode=26 if bpld>=30000 & bpld<40000
replace agethcode=27 if bpld>=21000 & bpld<25000
replace agethcode=28 if bpld>=25000 & bpld<30000
replace agethcode=29 if bpld>=54200 & bpld<54300
replace agethcode=30 if bpld>=50000 & bpld<50100
replace agethcode=31 if bpld>=50000 & bpld<60000 & agethcode==.
replace agethcode=32 if bpld>70000 & bpld<70100
replace agethcode=33 if bpld>60000 & bpld<70000
replace agethcode=34 if bpld<=90010 & agethcode==.

label define origins ///
	0 "US-Born" ///
	1 "English" ///
	2 "Scottish" ///
	3 "Irish" ///
	4 "Welsh" ///
	5 "French" ///
	6 "Austrian" ///
	7 "German" ///
	8 "Swiss" ///
	9 "Danish" ///
	10 "Norwegian" ///
	11 "Swedish" ///
	12 "Russian/Polish" ///
	13 "Greek" ///
	14 "Italian" ///
	15 "Dutch" ///
	16 "Belgian" ///
	17 "Spanish" ///
	18 "Portugeuse" ///
	19 "Czech" ///
	20 "Finnish" ///
	21 "Hungarian" ///
	22 "Romanian" ///
	23 "Other European" ///
	24 "Canadian" ///
	25 "Mexican" ///
	26 "South American" ///
	27 "Central American" ///
	28 "West Indies" ///
	29 "Turkish" ///
	30 "Chinese" ///
	31 "Other Asian" ///
	32 "Australian/New Zealander" ///
	33 "African" ///
	34 "Other"

label values agethcode origins
end

cgrps

*********************
* III.B Fix Geography *
*********************

* III.B.1 Make county boundaries consistent over time 
* (for city areas only -- non-city areas set to county code=0)
* is fixgeo program from original do-file
cap program drop fixgeo
program define fixgeo

gen statea=string(statefip*10)
replace statea="0"+string(statefip*10) if statefip<10
drop if county==.|county==0
gen countya=string(county)
replace countya="00"+string(county) if county<100
replace countya="0"+string(county) if county>=100 & county<1000
replace countya="0395" if countya=="0410" & statefip==13
replace countya="2015" if countya=="2030" & statefip==13
replace countya="0090" if countya=="9010" & statefip==4
replace countya="0470" if countya=="0450" & statefip==24
replace countya="0450" if countya=="0430" & statefip==24
replace countya="0430" if countya=="0410" & statefip==24
replace countya="0410" if countya=="0390" & statefip==24
replace countya="0390" if countya=="0350" & statefip==24
replace countya="0350" if countya=="0330" & statefip==24
replace countya="0330" if countya=="0310" & statefip==24
replace countya="0310" if countya=="0290" & statefip==24
replace countya="0290" if countya=="0270" & statefip==24
replace countya="0270" if countya=="0250" & statefip==24
replace countya="0250" if countya=="0230" & statefip==24
replace countya="0230" if countya=="0210" & statefip==24
replace countya="0210" if countya=="0190" & statefip==24
replace countya="0190" if countya=="0170" & statefip==24
replace countya="0170" if countya=="0150" & statefip==24
replace countya="0150" if countya=="0130" & statefip==24
replace countya="0130" if countya=="0110" & statefip==24
replace countya="0110" if countya=="0090" & statefip==24
replace countya="0090" if countya=="0070" & statefip==24
replace countya="1860" if countya=="1930" & statefip==29
replace countya="0250" if countya=="0510" & statefip==32
replace countya="9055" if countya=="9070" & statefip==38
replace statea="178" if statea=="400" & county>9000
replace countya="9015" if countya=="9010" & statea=="178"
replace countya="9035" if countya=="9030" & statea=="178"
replace countya="9055" if countya=="9050" & statea=="178"
replace countya="9075" if countya=="9070" & statea=="178"
replace countya="9095" if countya=="9090" & statea=="178"
replace countya="9115" if countya=="9120" & statea=="178"
replace countya="9135" if countya=="9130" & statea=="178"
replace countya="9155" if countya=="9140" & statea=="178"
replace countya="9195" if countya=="9160" & statea=="178"
replace countya="9215" if countya=="9170" & statea=="178"
replace countya="9235" if countya=="9180" & statea=="178"
replace countya="9015" if countya=="9210" & statea=="178"
replace countya="9035" if countya=="9230" & statea=="178"
replace countya="9055" if countya=="9250" & statea=="178"
replace countya="9075" if countya=="9270" & statea=="178"
replace countya="" if countya=="0610" & statea=="410"
replace countya="0610" if countya=="0605" & statea=="410"
replace countya="9015" if countya=="9010" & statea=="460"
replace countya="9075" if countya=="9030" & statea=="460"
replace countya="9095" if countya=="9050" & statea=="460"
replace countya="9115" if countya=="9070" & statea=="460"
replace countya="9075" if countya=="1055" & statea=="460"
replace countya="1890" if countya=="1875" & statea=="510"
replace countya="6855" if countya=="6860" & statea=="510"
replace countya="7805" if countya=="7850" & statea=="510"
replace countya="0470" if countya=="0455" & statea=="560"
drop county
compress
end 

fixgeo

save dta/temp.dta,   replace
collapse (sum) clerks* skilled* wageworkers* lowskill_stock* highskill_stock* [pw=perwt], by(year statea countya agethcode ind1950)
sort statea countya
save dta/tempcty_literacy.dta,   replace  



********************************************************************************
* Constructing the initial (1850)
* stocks data necessary to construct the instrument using the 100% 1850
* sample that is available for some states.  For the other states, it uses
* tabulations from Ancestry.com (which are also used as the denominator of
* the "share" for all states.
********************************************************************************
clear
* read in data
use "src/usa_00174.dta", clear  /*Full 1850 census*/


*************************************
* III.C Country groups for immigrats *
*************************************

* create country groups for immigrants

cgrps

*********************
* III. Fix Geography *
*********************
* Make county boundaries consistent over time 

fixgeo


save temp/1850temp.dta,   replace

**************************
* IV. Collapse to county *
**************************
use temp/1850temp.dta, clear
gen ones=1
bysort agethcode: egen total_usa=sum(ones)
drop if agethcode==0 /*only immigrants*/
save temp/1850origins.dta, replace


* now collapse to the "area" codes, which must be added in first
use "src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge 1:m statea countya using temp/1850origins.dta
tab _merge


* IV.2 Construct "area," which, for now = county except in NYC.  
* /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */
gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850

* make missing countyid countyid=0 (really, non-city areas)
replace area=0 if countyid==.
replace statea="" if countyid==.
replace countya="" if countyid==.
replace st_name="" if countyid==.

rename st_name state
drop if area==0

collapse (sum) ones (mean) total_usa [pw=perwt], by(statea area agethcode)
gen share=ones/total_usa


save dta/1850origins.dta,    replace



* A few counties in California, Texas, Iowa and Nebraska were not covered in 1850, get from 1860
* "Other asian" total for 1860 comes from census bureau tabulation, not ancestry
clear
import excel using "src/Ancestry2.xlsx", sheet("1860") firstrow
drop if state==""
reshape long agethcode_, i(state area countynames) j(agethcode)
rename agethcode_ stock
gen total=stock if state=="TOTAL"
bysort agethcode: egen total_USA=mean(total)
drop total
drop if state=="TOTAL"
gen share=stock/total_USA

* record state code:
gen fipst=floor(area/100000)
gen statea=string(fipst*10)
replace statea="0"+string(fipst*10) if fipst<10
drop fipst

*drop total_USA stock
rename total_USA total_usa
collapse (sum) share stock (mean) total_usa, by(area agethcode state statea)
rename stock ones
sort area agethcode
save temp/ancestry.dta, replace


* merge Ancestry shares to PUMS shares
use  dta/1850origins.dta, clear
merge 1:1 area agethcode using temp/ancestry.dta
drop _merge
save dta/1850origins.dta,   replace


* clean up
erase temp/1850origins.dta

}


************************************ 
* SHARES for natives (1880 & 1850)
************************************
{

clear
* read in data
use "src/usa_00173", clear

keep if  datanum==3 & year==1880   /*Full 1880 census*/
append using "src/usa_00174.dta"  /*Full 1850 census*/


keep if bpl<100 /*Natives*/

*********************
* II. Fix Geography *
*********************
* Make county boundaries consistent over time 

fixgeo
save temp/nativestemp.dta, replace

**************************
* III. Collapse to county *
**************************
use temp/nativestemp.dta, clear
gen ones=1
save temp/origins_natives.dta, replace


* now collapse to the "area" codes, which must be added in first
use "src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge 1:m statea countya using temp/origins_natives.dta
tab _merge

keep if _merge==3|_merge==2 /* for now we need the non-city counties */
drop _merge

* IV.2 Construct "area," which, for now = county except in NYC.  
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */
gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850

* make missing countyid countyid=0 (really, non-city areas)
replace area=0 if countyid==.
replace statea="" if countyid==.
replace countya="" if countyid==.
replace st_name="" if countyid==.

rename st_name state


collapse (sum) ones , by(statea area year bpl)

destring statea, g(rpl)  /*residence place*/


bysort bpl year: egen total_usa=sum(ones)
bysort year: egen total_pop=sum(ones)

gen share_native=ones/total_usa

keep statea area bpl year share_native ones total_usa total_pop
  
reshape wide share_native ones total_usa total_pop, i(statea area bpl) j(year)

save dta/origins_native.dta,   replace

*Clean
erase temp/origins_natives.dta
erase temp/nativestemp.dta

clear

***ADD LITERACY DATA***

// 1. Read in state, city literacy data
//    a. city 
import excel using "src/LiteracyTables.xlsx", cellrange(A2:D126) firstrow sheet("Condados")
gen statename=proper(lower(trim(Estado)))

* merge on postal codes and state FIPS codes:
merge m:1 statename using "src/fipst.dta"
keep if _merge==3
drop _merge

* create City, state
gen City = trim(Condado)+", "+stabb
drop Condado Estado
order City
save temp/1890lit-v0.dta, replace

* Collapse to the state level, which combined with state totals can be used to create non-covered city residual for each state
collapse (sum) citTotal=Total citIll = Illiterate, by(fipst)
save temp/1890stot_lit.dta, replace

//   b. state
clear
import excel using "src/LiteracyTables.xlsx", cellrange(A2:C51) firstrow sheet("Estados")
gen statename=proper(lower(trim(Estado)))

* merge on postal codes and state FIPS codes:
merge m:1 statename using "src/fipst.dta"
keep if _merge==3
drop _merge

* merge on totals across cities, to create residual
merge 1:1 fipst using temp/1890stot_lit.dta

gen resTotal = Total - citTotal
gen resIlliterate = Illiterate - citIll

* if no city data, use state totals
replace resTotal = Total if _merge==1
replace resIlliterate = Illiterate if _merge==1
keep statename stabb fipst res*
order statename stabb fipst 
save temp/1890lit-state.dta, replace
erase temp/1890stot_lit.dta


// 2. Get list of 1890 cities in manufacturing data
use src/1890final.dta, clear
keep City state
egen one=tag(City)
keep if one==1
drop one
rename state stabb

* extra space in city name of Charleston which needs to fixed before merge
replace City = "Charleston, SC" if City=="Charleston,  SC"

merge 1:1 City using temp/1890lit-v0.dta

* States that have unmerged citie
gen byte nocitlit1890 = _merge==1
  label variable nocitlit1890 "No Lit Data in 1890, use state resid"
tab stabb if nocitlit1890
drop _merge

* merge on state residuals
merge m:1 stabb using temp/1890lit-state.dta
keep if _merge==1|_merge==3
drop _merge
replace Total=resTotal if nocitlit1890
replace Illiterate=resIlliterate if nocitlit1890==1

* clean up some city names:
gen city2=City
  label variable city2 "City name used in IPUMS"
replace city2="La Crosse, WI" if City=="Lacrosse, WI"
replace city2="Pittsburgh, PA" if City=="Pittsburg, PA"
replace city2="Salt Lake City, UT" if City=="Salt Lake, UT"
replace city2="Saint Joseph, MO" if City=="St. Joseph, MO"
replace city2="Saint Louis, MO" if City=="St. Louis, MO"
replace city2="Saint Paul, MN" if City=="St. Paul, MN"
replace city2="Wilkes-Barre, PA" if City=="Wilkesbarre, PA"
replace city2="Newburgh, NY" if City=="Newburg, NY"

* save cleaned up version
keep City city2 stabb Total Illiterate nocitlit1890
save dta/1890literacy.dta,   replace


//* 3. Merge on county codes

use src\usa_00173, clear

*** 2a. Account for differences in sampling rates
gen stock=100
replace stock=1 if year==1880
replace stock=20 if year==1900

*** 2c. Create consistent county boundaries over time; non-city areas are NOT fixed by this
fixgeo
save temp/tempcty, replace


*** 3. Now for the real work: compute share of each city's employment in each county it is in
use temp/tempcty, clear
keep if city>0 & city~=.

collapse (sum) empcitycounty=stock, by(year city countyid_new st_name cnty_name)
bysort year city: egen empcity=sum(empcitycounty)
gen shrcity_in_county = empcitycounty/empcity
  label variable shrcity_in_count "Share of this city in this county"
  label variable empcity "City's Total Employment"
  label variable empcitycounty "Emp in City - county intersection"

* order from top to bottom share and keep first
gsort year city -shrcity
bysort year city: gen countyrank = sum(1)
  label variable countyrank "Rank of County in City's Makeup"
bysort year city: egen countyct = max(countyrank)
  label variable countyct "#of counties this city is in"
save temp/citycounty.dta, replace

* How many multi-city counties are there?
bysort year countyid_new: egen cityct = count(city)
  label variable cityct "#of cities in this county"
save, replace
tab year cityct

* Now get, and merge on total employment in each county
use temp/tempcty, clear
collapse (sum) empcounty=stock, by(year countyid_new)
merge year countyid_new using temp/citycounty.dta, uniqmaster sort

* drop counties without cites
keep if _merge==3
drop _merge

* Compute share of county in each city
gen shrcounty_in_city = empcitycounty/empcounty
  label variable shrcounty_in_city "Share of county made of this city"
save temp/citycounty.dta, replace

* Look at multicounty cities
list year st_name cnty_name city empcity shrcity countyct cityct shrcounty if countyct>1

* Look at using just the top county for each city: any non-majority?
list year st_name cnty_name city empcity shrcity if countyct>1 & countyrank==1 & shrcity<.5

*** Now just keep top county for each city, except NYC, which we will define as its five counties in all years
keep if countyrank==1
drop if city==4610|city==4611 /* NYC and brooklyn, we will deal with later separately */
drop countyrank
save temp/topcounties0.dta, replace


* Now make sure this definition is consistent across years
foreach year in 1850 1860 1870 1880 1900 1910 1920 1930 1940 {
  use temp/topcounties0.dta, clear
  keep if year==`year'
  keep city countyid_new st_name cnty_name shrcity shrcounty cityct
  foreach var in countyid st_name cnty_name shrcity shrcounty cityct {
    rename `var' `var'`year'
  }
  if `year'>1850 {
    merge city using temp/topcountiesyr.dta, uniq sort
	drop _merge
  }
  save temp/topcountiesyr.dta, replace
}

* check if there are any multiple copies of any cities: an indication of county switch
bysort city: egen cityct = count(city)
list city cityct if cityct>1

* keep track of (1) max #of cities located in this county (2) min county share across all years : use to identify good county proxies for later cities
gen maxcityct = max(cityct1850,cityct1860,cityct1870,cityct1880,cityct1900,cityct1910,cityct1920,cityct1930,cityct1940)
gen minshrcty = min(shrcounty1850,shrcounty1860,shrcounty1870,shrcounty1880,shrcounty1900,shrcounty1910,shrcounty1920,shrcounty1930,shrcounty1940)
gen maxshrcty = max(shrcounty1850,shrcounty1860,shrcounty1870,shrcounty1880,shrcounty1900,shrcounty1910,shrcounty1920,shrcounty1930,shrcounty1940)
gen goodcityproxy = (maxcityct==1)
  label variable goodcityproxy "=1 if this city is unique in this county"

* document years in which a city has positive employment in the census 
foreach year in 1850 1860 1870 1880 1900 1910 1920 1930 1940 {
  gen avail`year' = shrcounty`year'>0 & shrcounty`year'~=.
    label variable avail`year' "City w/>0 emp in `year' Census"
}
  
* finally, create a single variable containing the county of each city which is time invariant
gen st_name=""
gen cnty_name=""
gen countyid=.
foreach year in 1850 1860 1870 1880 1900 1910 1920 1930 1940 {
  replace st_name=st_name`year' if st_name==""
  replace cnty_name=cnty_name`year' if cnty_name==""
  replace countyid=countyid`year' if countyid==.
  drop st_name`year' cnty_name`year' countyid`year' shrcity`year' shrcounty`year' cityct`year'
}
drop cityct

* variable labels and save
order city countyid st_name cnty_name goodcityproxy maxcity minshr maxshr avail*
  label variable city "IPUMS city code"
  label variable countyid "Matched County ID (FIPS)"
  label variable st_name "State Name"
  label variable cnty_name "County Name"
  label variable maxcityct "Max #cities in this County, 1850-1940"
  label variable minshrcty "City's Min Share of County, 1850-1940"
  label variable maxshrcty "City's Max Share of County, 1850-1940"
save dta/county-city-new.dta, replace


* clean up raw files
erase temp/topcounties0.dta


use dta/county-city-new.dta", clear

gen st_ab=""
replace st_ab="AL" if st_name=="Alabama"
replace st_ab="AK" if st_name=="Alaska"
replace st_ab="AZ" if st_name=="Arizona"
replace st_ab="AR" if st_name=="Arkansas"
replace st_ab="CA" if st_name=="California"
replace st_ab="CO" if st_name=="Colorado"
replace st_ab="CT" if st_name=="Connecticut"
replace st_ab="DE" if st_name=="Delaware"
replace st_ab="DC" if st_name=="District Of Columbia"
replace st_ab="FL" if st_name=="Florida"
replace st_ab="GA" if st_name=="Georgia"
replace st_ab="HI" if st_name=="Hawaii"
replace st_ab="ID" if st_name=="Idaho"
replace st_ab="IL" if st_name=="Illinois"
replace st_ab="IN" if st_name=="Indiana"
replace st_ab="IA" if st_name=="Iowa"
replace st_ab="KS" if st_name=="Kansas"
replace st_ab="KY" if st_name=="Kentucky"
replace st_ab="LA" if st_name=="Louisiana"
replace st_ab="ME" if st_name=="Maine"
replace st_ab="MD" if st_name=="Maryland"
replace st_ab="MA" if st_name=="Massachusetts"
replace st_ab="MI" if st_name=="Michigan"
replace st_ab="MN" if st_name=="Minnesota"
replace st_ab="MS" if st_name=="Mississippi"
replace st_ab="MO" if st_name=="Missouri"
replace st_ab="MT" if st_name=="Montana"
replace st_ab="NE" if st_name=="Nebraska"
replace st_ab="NV" if st_name=="Nevada"
replace st_ab="NH" if st_name=="New Hampshire"
replace st_ab="NJ" if st_name=="New Jersey"
replace st_ab="NM" if st_name=="New Mexico"
replace st_ab="NY" if st_name=="New York"
replace st_ab="NC" if st_name=="North Carolina"
replace st_ab="ND" if st_name=="North Dakota"
replace st_ab="OH" if st_name=="Ohio"
replace st_ab="OK" if st_name=="Oklahoma"
replace st_ab="OR" if st_name=="Oregon"
replace st_ab="PA" if st_name=="Pennsylvania"
replace st_ab="RI" if st_name=="Rhode Island"
replace st_ab="SC" if st_name=="South Carolina"
replace st_ab="SD" if st_name=="South Dakota"
replace st_ab="TN" if st_name=="Tennessee"
replace st_ab="TX" if st_name=="Texas"
replace st_ab="UT" if st_name=="Utah"
replace st_ab="VT" if st_name=="Vermont"
replace st_ab="VA" if st_name=="Virginia"
replace st_ab="WA" if st_name=="Washington"
replace st_ab="WV" if st_name=="West Virginia"
replace st_ab="WI" if st_name=="Wisconsin"
replace st_ab="WY" if st_name=="Wyoming"

label define city_lbl 6390 "Schenectady, NY", modify
replace countyid=600730 if countyid==600740 & cnty_name=="San Diego"
replace countyid=800310 if countyid==800320 & cnty_name=="Arapahoe"
replace countyid=1200570 if countyid==1200580 & cnty_name=="Hillsborough"
replace countyid=1301210 if countyid==1301220 & cnty_name=="Fulton"
replace countyid=1550035 if countyid==1500030 & cnty_name=="Honolulu"
replace countyid=2300050 if countyid==2300020 & cnty_name=="Cumberland"
replace countyid=2700370 if countyid==2700200 & cnty_name=="Dakota"
replace countyid=2700530 if countyid==2700200 & cnty_name=="Hennepin"
replace countyid=3400130 if countyid==3400140 & cnty_name=="Essex"
replace countyid=3400390 if countyid==3400140 & cnty_name=="Union"
replace countyid=4000370 if countyid==4000380 & cnty_name=="Creek"
replace countyid=4001430 if countyid==4000380 & cnty_name=="Tulsa"
replace countyid=4001110 if countyid==4000380 & cnty_name=="Okmulgee"
replace countyid=4100510 if countyid==4100060 & cnty_name=="Multnomah"
replace countyid=4700650 if countyid==4700660 & cnty_name=="Hamilton"
replace countyid=4801410 if countyid==4801100 & cnty_name=="El Paso"
decode city , generate(city_st)
rename city citycode
drop if city_st=="Wilkinsburg, PA"
drop if city_st=="Cohoes, NY"
drop if city_st=="Lebanon, PA"
drop if city_st=="Vallejo, CA"
save dta/county-city-new2.dta,   replace

decode citycode, gen(city2)
keep city2 countyid st_name cnty_name

* eliminate weird double coded cities
egen one=tag(city2)
keep if one==1
drop one

* merge to 1890 literacy
merge 1:1 city2 using dta/1890literacy.dta
keep if _merge==2|_merge==3
drop _merge

* add back in "area", which is basically county except new york
gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850|City=="Brooklyn, NY"|City=="New York, NY"
replace countyid = 3600470 if City=="Brooklyn, NY"
replace st_name = "New York" if City=="Brooklyn, NY"
replace cnty_name = "Kings" if City=="Brooklyn, NY"
replace countyid = 3600610 if City=="New York, NY"
replace st_name = "New York" if City=="New York, NY"
replace cnty_name = "New York"  if City=="New York, NY"

save dta/1890literacy.dta,   replace
tab area

* versions collapsed to the "area" level.
* use "imputed" city data where there are no other cities in the area with unimputed data
egen ncities=count(Total), by(area)
egen nimpute=sum(nocitlit1890), by(area)

drop if nocitlit1890==1 & ncities>nimpute /* drops the impute cities where there are non-impute cities in the area */


collapse (sum) Total Illiterate nimpute=nocitlit1890 (count) ncities=Total, by(area)
  label variable nimpute "#of cities with state-imputed literacy-1890"
  label variable ncities "#of cities used to compute county lit-1890"

* change variable names / construct new variables to sync with other years
gen skratio_lit = ln((Total-Illiterate)/Illiterate)

*Match missing counties 
replace area=800320 if area==800310
replace area=1301220 if area==1301210
replace area=2700200 if area==2700530
replace area=3400140  if area==3400130
replace area=4100060 if area==4100510
replace area=4700660  if area==4700650

gen year=1890
save dta/1890literacy-area.dta,   replace



* erase temp files
erase temp/1890lit-state.dta
erase temp/1890lit-v0.dta


* Combines (nationally) tabulated data on immigrants and natives in
* in 1890 with IPUMS data for 1880 and 1900 to create imputed national
* origin group x literacy adult population counts for 1890.  Final dataset:
* stocks1890national.dta.
*
* 1880 literacy data, from version of 1880 IPUMS on Ethan's computer (1+10% files)
use src/cens1880.dta, clear


keep if datanum==2 /* just use the 10% sample, dont know if it overlaps with the 1% */
keep if age>=10 /* literacy only defined in this subsample */
cgrps  /*program that generates agethcode*/
gen islit=(lit==4) if lit~=0 & lit~=.

collapse (mean) shrlit1880=islit (rawsum) imms1880=perwt [pw=perwt], by(agethcode)
save temp/1890stocks0.dta, replace


use src/usa_00173, clear


keep if year==1900
keep if age>=10 /* literacy only defined in this subsample */
cgrps 
gen islit=(lit==4) if lit~=0 & lit~=.

* pre-1890 immigrant
gen pre1890 = yrimmig<=1890 if yrimmig~=0 & yrimmig ~=. & agethcode~=0
gen pre1890islit=islit if pre1890
gen imms1900pre1890=pre1890*perwt

collapse (mean) shrlit1900=islit shrlit1900pre1890=pre1890islit (rawsum) imms1900=perwt imms1900pre1890 [pw=perwt], by(agethcode)

* merge 1900 + 1880 and compare or interpolate
merge 1:1 agethcode using temp/1890stocks0.dta
drop _merge

* interpolated:
gen imp1shrlit1890 = (shrlit1880+shrlit1900)/2
gen imp1imms1890 = (imms1900+imms1880)/2

list agethcode shrlit* imp1* imms*

sort shrlit1880
gr two (scatter shrlit1900 shrlit1880 if agethcode~=0 [w=imms1880], ms(oh)) (scatter shrlit1880 shrlit1880 if agethcode~=0, c(l) ms(none) lp(dash)), legend(off)
sort imp1shrlit1890
gr two (scatter shrlit1900pre1890 imp1shrlit1890 if agethcode~=0 [w=imms1880], ms(oh)) (scatter imp1shrlit1890 imp1shrlit1890 if agethcode~=0, c(l) ms(none) lp(dash)), ///
  title("Two Different Estimates of 1890 Share Literate by Origin") xtitle("Simple Interpolation (1880+1900 average)") ytitle("1900 Imms who were in US by 1890") legend(off)


* save the simple imputation, which appears fine.
keep agethcode imp1shrlit1890 imp1imms1890 shrlit1880 shrlit1900
rename imp1shrlit1890 shrlit1890
  label variable shrlit1890 "Lit Share 1890, Imputed from 1880+1900"
label variable imp1imms1890 "Pop age>10 by Origin 1890, Imputed from 1880+1900"
save temp/1890stocks0.dta, replace

* merge on actual 1890 data, which is more detailed than our origin groups (obtained from NGHIS-NT46)
use "src/immstocks1890-national.dta", clear
collapse (sum) imms1890, by(agethcode)
merge 1:1 agethcode using temp/1890stocks0.dta
erase temp/1890stocks0.dta
drop _merge
list

* create imputed stocks by literacy, using 1880 literacy rates
local shrlit "shrlit1890"
gen total_lowskill=(1-`shrlit')*imms1890
gen total_highskill=`shrlit'*imms1890
  /* for a couple of origins, we require imputed data on stocks as well */
  gen stock1890_imputed = imms1890==.
    label variable stock1890_imputed "1890 Imm Totals Imp. from 1880+1900 avg"
  replace total_lowskill=(1-`shrlit')*imp1imms1890 if stock1890_imputed
  replace total_highskill=`shrlit'*imp1imms1890  if stock1890_imputed

* year:
gen year=1890


* totals for 1890:
su total_* if agethcode==0
su total_* if agethcode~=0
su total_* if agethcode~=0 & stock1890_imputed==0

* For natives: 
* Tabulated data: 5,107,671 low skilled and 38,473,159-5,107,671 high skilled according to tabulations)
* we also have the imputed total_lowskill and total_highskill, which comes from average native population in 1880 and 1900. */
gen total_natlow=5107671 if agethcode==0
  replace total_lowskill=. if agethcode==0 /* so as not to be accidentally combined with immigrant counts */
gen total_nathigh=38473159-5107671 if agethcode==0
  replace total_highskill=. if agethcode==0 /* so as not to be accidentally combined with immigrant counts */

save dta/stocks1890national.dta,   replace


*******************************************************************************
* INSTRUMENTS
* 
* Constructs instruments, endogenous
* variables.  skill mix measure:
* ln(literate/non-literate).
*******************************************************************************

************
* NATIVES
************

************
* 1890 data for natives
***********
* Imputing literacy shares from 1880 & 1900
use "src/usa_00173", clear


keep if year==1900 | year==1880
keep if age>=10 /* literacy only defined in this subsample */
cgrps 
keep if agethcode==0
gen islit=(lit==4) if lit~=0 & lit~=.

collapse islit [pw=perwt], by(bpl year)
collapse islit, by(bpl)

save temp/natives_stock1890.dta,   replace

merge 1:1 bpl using "src/natstocks1890-national.dta"
keep if _merge==3
gen total_nat_high1890=islit*natives_stock
gen total_nat_low1890=(1-islit)*natives_stock

rename natives_stock total_nat_stock1890
gen total_natives=50997200
rename total_natives total_nat_usa1890

egen total_nat_H1890=sum(total_nat_high1890)
egen total_nat_L1890=sum(total_nat_low1890)


keep bpl total_nat_stock1890 total_nat_usa1890 total_nat_H1890 total_nat_L1890

save temp/natives_stock1890, replace

**********
* Other years' data
* skills data by year for non-1890 years
**********
use "src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge statea countya using dta/temp, uniqmaster sort  
tab _merge    
keep if _merge==3|_merge==2 /* for now we need the non-city counties */
drop _merge

* make missing countyid countyid=0 (really, non-city areas)
replace countyid=0 if countyid==.


* IV.2 Construct "area," which, for now = county except in NYC.  
* (May want to add other multi-county cities later)
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */

gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850

drop if agethcode!=0 /*only natives*/

collapse (sum) lowskill_stock* highskill_stock* [pw=perwt], by(year area bpl statea)

* get rid of "states" for non-city areas -- just residual areas to get totals right
replace statea="" if area==0

* get totals by year and origin 
bysort year bpl: egen total_lowskill=sum(lowskill_stock)
bysort year bpl: egen total_highskill=sum(highskill_stock)

gen total_stock_bpl=total_lowskill+total_highskill

* get totals by year
bysort year : egen total_low=sum(lowskill_stock)
bysort year : egen total_high=sum(highskill_stock)

gen total_stock_usa=total_low+total_high



save temp/natives_pred, replace


* Create 1890 totals
use temp/natives_pred, clear
keep if year>=1880 & year<=1900
bysort bpl area: egen contar=count(area)
keep if contar==2
collapse total_lowskill* total_highskill* total_stock*, by(bpl)
rename total_lowskill total_L
rename total_highskill total_H
rename total_stock_usa total_LH_usa
rename total_stock_bpl total_LH_bpl


save temp/natives_pred_1890, replace



use temp/natives_pred, clear
keep if year>=1880 & year<=1900
bysort bpl area: egen contar=count(area)
collapse total_lowskill* total_highskill* total_stock* total_high total_low contar , by(area bpl) /*to use area codes*/

gen year=1890

merge m:1 bpl using temp/natives_pred_1890

rename total_lowskill total_lowskill_1890

rename total_stock_usa total_stock_usa1890

rename total_stock_bpl total_stock_bpl1890

rename total_highskill total_highskill_1890

drop total_H* total_L*

save temp/natives_pred_1890, replace



** Append 1890 to total database
use temp/natives_pred, clear
append using temp/natives_pred_1890
drop _merge

merge m:1 bpl using temp/natives_stock1890
keep if _merge==3
drop _merge


keep statea year bpl area total_high total_low total_nat_L1890 total_nat_H1890 total_stock_usa* total_stock_bpl* total_nat_stock1890 total_nat_usa1890     

* Merge natives' shares
merge m:1 area bpl using dta/origins_native.dta


destring statea, g(rpl)
bysort area: egen rpl_=mean(rpl)
replace rpl=rpl_ if year==1890
drop rpl_

* PREDICTED /*it replaces total_stocks by place of birth for  of N_jt*H_t/N_t */
gen pred_nat_high2=share_native1850*(total_high*total_stock_bpl/total_stock_usa)  
replace pred_nat_high2=share_native1880*(total_high*total_stock_bpl/total_stock_usa)  if  year>=1890
replace pred_nat_high2=share_native1880*(total_nat_H1890*total_nat_stock1890/total_nat_usa1890)  if year==1890

gen pred_nat_low2=share_native1850*(total_low*total_stock_bpl/total_stock_usa)  
replace pred_nat_low2=share_native1880*(total_low*total_stock_bpl/total_stock_usa)  if  year>=1890
replace pred_nat_low2=share_native1880*(total_nat_L1890*total_nat_stock1890/total_nat_usa1890)  if  year==1890


* collapse to the area level
collapse (sum)pred_* , by(area statea year)
drop if year==.


foreach x of varlist pred_* {
   rename `x' `x'_lit
}

foreach x of varlist pred_* {
replace `x'=0 if `x'==.
}

save dta/predicted_natives.dta,   replace



************************************************
* Immigrants
************************************************

*First generate shares for 1880

use data\county_match3_old.dta, clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge statea countya using temp/tempcty, uniqmaster sort
tab _merge
keep if _merge==3|_merge==2 /* for now we need the non-city counties */
drop _merge

* make missing countyid countyid=0 (really, non-city areas)
replace countyid=0 if countyid==.

* IV.2 Construct "area," which, for now = county except in NYC.  
* (May want to add other multi-county cities later)
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */
gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850

collapse (sum) lowskill_stock highskill_stock, by(year area agethcode statea)
keep if year==1880
bysort agethcode: egen total=sum(lowskill_stock+highskill_stock)
gen share_1880=(lowskill_stock+highskill_stock)/total
sort area statea agethcode
save dta/shares_1880v2, replace

erase temp/tempcty

************
* 1890 data
* 1. For instrument for 1890: merge 1890 tabulations of immigrant counts to base year
************
local byr1880 1890 /* year that we switch from base year 1850 to base year 1880. */
if `byr1880'>1890 { /* use 1850 as base year for 1890 */

   use dta/1850origins.dta, clear
	drop if area==0
   merge m:1 agethcode using dta/stocks1890national.dta
   keep if _merge==3
   keep area statea state agethcode year total_lowskill total_highskill total_natlow total_nathigh share
   save temp/1890pred.dta, replace
}
else { /* use 1880 as a base year for 1890 */

   use dta/shares_1880v2.dta, clear
   drop if area==0 /* non-city areas not needed, and causes problems with merge because of multiple states per "area" */
   keep statea area agethcode share_1880
   merge m:m agethcode using dta/stocks1890national.dta
   keep if _merge==3
   keep area statea state agethcode year total_lowskill total_highskill total_natlow total_nathigh share
   save temp/1890pred.dta, replace
}  




**********
* Other years' data
* skill data by year for non-1890 years, immigrant origin from tempcty_literacy
**********
use "src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge statea countya using dta/temp, uniqmaster sort  
tab _merge    
keep if _merge==3|_merge==2 /* for now we need the non-city counties */
drop _merge

* make missing countyid countyid=0 (really, non-city areas)
replace countyid=0 if countyid==.


* IV.2 Construct "area," which, for now = county except in NYC.  
* (May want to add other multi-county cities later)
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */

gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850


collapse (sum) lowskill_stock* highskill_stock* [pw=perwt], by(year area agethcode statea)

bysort year: egen total_native=sum(lowskill_stock+highskill_stock) if agethcode==0 & year==1850

gen stocknat_1850=(lowskill_stock+highskill_stock)/total_native if agethcode==0 & year==1850

bysort area state: egen share_native=mean(stocknat_1850) if agethcode==0

drop stocknat_1850 total_native
sort area agethcode
merge m:1 area agethcode using dta/1850origins.dta, keepusing(share area agethcode)
drop if _merge==2
drop _merge

sort area statea agethcode
merge m:1 area statea agethcode using dta/shares_1880v2, keepusing(share_1880 area agethcode)  
drop if _merge==2            
drop _merge

* get rid of "states" for non-city areas -- just residual areas to get totals right
replace statea="" if area==0

* get totals by year, origin 
bysort year agethcode: egen total_lowskill=sum(lowskill_stock)
bysort year agethcode: egen total_highskill=sum(highskill_stock)


* append on imputed 1890 totals (from above)
append using temp/1890pred.dta
rename total_natlow tn
rename total_nathigh th

* year varying native totals
  bysort year: egen total_natlow=sum(lowskill_stock) if agethcode==0 & year~=1890 /* already defined for 1890 */
  replace total_natlow=tn if year==1890
  drop tn
  
    gen total_natlow0 = total_natlow if year==1850 & agethcode==0
    egen total_natlow1850 = mean(total_natlow0)
	  gen total_natlow1=total_natlow if year==1880 & agethcode==0
	  egen total_natlow1880 = mean(total_natlow1)
    drop total_natlow0  total_natlow1
	
  bysort year: egen total_nathigh=sum(highskill_stock) if agethcode==0 & year~=1890 /* already defined for 1890 */
  replace total_nathigh=th if year==1890
  drop th
    gen total_nathigh0 = total_nathigh if year==1850 & agethcode==0
      egen total_nathigh1850 = mean(total_nathigh0)
	  gen total_nathigh1 = total_nathigh if year==1880 & agethcode==0
      egen total_nathigh1880 = mean(total_nathigh1)
    drop total_nathigh0 total_nathigh1


* base year native totals, by area
gen natlow0 = lowskill_stock if agethcode==0 & year==1850
    bysort area: egen natlow1850 = mean(natlow0) if agethcode==0
  gen natlow1=lowskill_stock if agethcode==0 & year==1880
   bysort area: egen natlow1880=mean(natlow1) if agethcode==0
  gen nathigh0 = highskill_stock if agethcode==0 & year==1850
    bysort area: egen nathigh1850 = mean(nathigh0) if agethcode==0
  gen nathigh1=highskill_stock if agethcode==0 & year==1880
  bysort area: egen nathigh1880 = mean(nathigh1) if agethcode==0

  
  drop natlow0 nathigh0 natlow1 nathigh1 

  
* base year share of natives for 1890
bysort area state: egen share_native1890=min(share_native) if agethcode==0
replace share_native=share_native1890 if year==1890 & share_native==.
drop share_native1890

* base year ratio of natives for 1890
bysort area state agethcode: egen total_lowskill_1890=mean(total_lowskill) if year<=1900 & year>=1880
bysort area state agethcode: egen total_highskill_1890=mean(total_highskill) if year<=1900 & year>=1880

replace total_lowskill=total_lowskill_1890 if year==1890
replace total_highskill=total_highskill_1890 if year==1890


drop total_highskill_1890 total_lowskill_1890

* now, predicted
local byr1880 1890
gen pred_lowskill=share*total_lowskill if year<`byr1880' & agethcode~=0
gen pred_highskill=share*total_highskill if year<`byr1880' & agethcode~=0
replace pred_lowskill=share_1880*total_lowskill if year>=`byr1880' & agethcode~=0
replace pred_highskill=share_1880*total_highskill if year>=`byr1880' & agethcode~=0

  
drop share share_native* share_1880 total_* 


* actual skills by nativity (not currently available for 1890)
gen lowskill_imm_stock=lowskill_stock if agethcode~=0 & year~=1890
gen highskill_imm_stock=highskill_stock if agethcode~=0  & year~=1890
gen lowskill_nat_stock=lowskill_stock if agethcode==0  & year~=1890
gen highskill_nat_stock=highskill_stock if agethcode==0  & year~=1890


* collapse to the area level
collapse (sum)pred_* (sum)*_stock , by(area statea year)



foreach x of varlist pred_* *_stock {
   rename `x' `x'_lit
}

foreach x of varlist pred_* *_stock_* {
replace `x'=0 if `x'==.
}



rename highskill_stock_lit highskill_stock_all_lit
rename lowskill_stock_lit lowskill_stock_all_lit
rename highskill_imm_stock_lit highskill_stock_lit
rename lowskill_imm_stock_lit lowskill_stock_lit
rename highskill_nat_stock_lit highskill_stock_native_lit
rename lowskill_nat_stock_lit lowskill_stock_native_lit


* merge on tabulated 1890 skills here
merge m:1 area year using dta/1890literacy-area.dta, keepusing(area year skratio_lit nimpute ) /* created by import1890literacy.do */
drop _merge


* merge on predicted natives from state of birth
merge 1:1 area year using dta/predicted_natives.dta
drop if _merge==2
drop _merge

foreach x of varlist pred_*  {
replace `x'=0 if `x'==.
}





******************************************************************************  
* Create skill ratios (literacy)
******************************************************************************
 

rename skratio sk /* rename 1890 version of variable temporarily */
gen skratio_lit=ln(highskill_stock_all_lit/ lowskill_stock_all_lit) if year~=1890
replace skratio_lit = sk if year==1890
  label variable skratio_lit "ln(H/L)"
  

******************************************************************************  
* Instrument: Apportioning natives like immigrants (replaces predictions for totals from state of birth)
******************************************************************************

gen zratio_smith_lit=ln(pred_highskill_lit+pred_nat_high2_lit)-ln(pred_lowskill_lit+pred_nat_low2_lit) 
label variable zratio_smith_lit "ln(H/L) among 'predicted' imm + nat (apportioned) stock from bpl"


* Year dummies
tab year, gen(yrdum)
sort area statea year
save dta/endogenouscty4_full,   replace

* Clean up
erase temp/1890pred.dta



********************************************

*Clean
erase dta/1850origins.dta
erase dta/1890literacy-area.dta
erase dta/1890literacy.dta
erase dta/stocks1890national.dta
erase dta/origins_native.dta
erase dta/predicted_natives.dta

log close
