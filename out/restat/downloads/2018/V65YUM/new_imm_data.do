********************************************************************************
* New_imm_data.do
********************************************************************************

********************
* I. Preliminaries *
********************

clear
cap clear matrix
set more off, permanently


* folder paths:
* History base folder path
global hist "/home/jfuenzalida/HistManf_JL"

* program folder:
global log "$hist/log"

* data folder (where the 1890 spreadsheet is located)
global dta "$hist/dta"

*src folder
global src "$hist/src"

* temp folder
global temp "$hist/dta/temp"

* tab folder
global tab "$hist/tab/full"

* do folder
global do "$hist/do"


* log file
cap log close
log using "$log/new_imm_data.log", replace

use "$src/usa_00173", clear

drop if datanum==1 & year==1880 /*this sample does not have the literacy variable*/

* account for differences in sampling rates
gen stock=100
replace stock=10 if year==1880 /*There are two 1880 samples, 10% & 100%, the 10% sample has literacy*/
replace stock=20 if year==1900|year==1930
gen byte obs=1

* drop children (< 15 years)
drop if age<15

************************
* II.A. Literacy Variables
************************
* To construct "high" and "low" skill from literacy data, 

*Gen a dummy for manufacturing industries
gen manu=(ind1950>=300 & ind1950<500) if ind1950~=0 & ind1950~=.
replace ind1950=0 if manu==0

gen literate=lit==4 if lit~=0 & lit~=.
replace literate=0 if lit==0 & year<=1860 /*literacy in 1850 & 1860*/
replace literate=higrade>5 if year==1940 & higrade~=./*05 is second grade of elementary school (attended or completed)*/

keep if literate~=.



*************************************
* III. Country groups for immigrats *
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
drop if agethcode==.

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
	18 "Portuguese" ///
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
* III. Fix Geo*graphy *
*********************

* III.1 Make county boundaries consistent over time 
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

save "$dta/temp_literacy_imm_area.dta", replace 



**********
* Other years' data
* skills data by year for non-1890 years, immigrant origin from tempcty_literacy
**********
use "$src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge statea countya using "$dta/temp_literacy_imm_area.dta", uniqmaster sort 
tab _merge    
keep if _merge==3|_merge==2 /* for now we need the non-city counties */
drop _merge

* make missing countyid countyid=0 (really, non-city areas)
replace countyid=0 if countyid==.


* Construct "area," which, for now = county except in NYC.  
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */

gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850


gen native=(agethcode==0)
gen new_imm=(agethcode==12|agethcode==13|agethcode==14|agethcode==17|agethcode==18|agethcode==19|agethcode==21|agethcode==22|agethcode==23)
save "$dta/literacy_imm_area.dta", replace 


use "$dta/literacy_imm_area.dta", clear
keep if  year==1880 | year==1860
gen old_imm=(agethcode>=1 & agethcode<=5)

tabstat new_imm old_imm [w=perwt], by (year)

collapse (mean)new_imm old_imm native [pw=perwt], by(statea area year)
sort statea area 
drop native
reshape wide new_imm old_imm, i(statea area ) j(year)


gen newimm1880=0
replace newimm1880=1 if (new_imm1880>=.0076527) & new_imm1880!=.

gen oldimm1880=0
replace oldimm1880=1 if (old_imm1880>=.0896929) & old_imm1880!=.

gen newimm1860=0
replace newimm1860=1 if (new_imm1860>=.0027587)  & new_imm1860!=.

gen oldimm1860=0
replace oldimm1860=1 if (old_imm1860>=.1310157) & old_imm1860!=.


drop if area==0

save "$dta/temp_newimm", replace

log close
