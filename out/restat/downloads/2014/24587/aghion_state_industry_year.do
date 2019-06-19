*******************************************
* Creates state-industry-year dataset with rainfall and labor regulations.
*Source: factories\burgess data\aghion burgess data\data\ABRZ3dAER.dta. is the main state-3-digit-industry-yr dataset used in  aghion-burgess-redding-zilibotti
* factories\burgess data\Socioeconomic\Socioeconomic.dta has state-yr rainfall from Besley-Burgess
*Checked that state codes are consistent
*  ABRZ3dAER.dta is an unbalanced panel, in the sense that state-industry-year cells with zero factories are simply not in there. 
*******************************************
clear
set more off 
set mem 700m
set matsize 4000


global do		"C:\Users\Siddharth\Desktop\factories\do"
global rain		"C:\Users\Siddharth\Desktop\factories\data\rainfall"
global data		"C:\Users\Siddharth\Desktop\factories\data"
global besleyburgess  "C:\Users\Siddharth\Desktop\factories\burgess data\Socioeconomic"
global aghion  "C:\Users\Siddharth\Desktop\factories\burgess data\aghion burgess data\data"


/*
global do		"C:\Users\SSharma1\Desktop\factories\do"
global rain		"C:\Users\SSharma1\Desktop\factories\data\rainfall"
global data		"C:\Users\SSharma1\Desktop\factories\data"
global besleyburgess  "C:\Users\SSharma1\Desktop\factories\burgess data\Socioeconomic"
global aghion  "C:\Users\SSharma1\Desktop\factories\burgess data\aghion burgess data\data"
*/ 

* Using Delaware rainfall data (district_rain_wide_code91) to get rainfall by state-yr

use "$data\asi_50_55_43_code91.dta", clear
sort code91
merge code91 using "$rain\district_rain_wide_code91.dta"
keep if _m == 3

* State codes as in aghion dataset


ge state = .
replace state = 1 if asi_state_ut == "Andhra Pradesh"
replace state = 2 if asi_state_ut == "Assam"
replace state = 3 if asi_state_ut == "Bihar"
replace state = 4 if asi_state_ut == "Gujarat"
replace state = 5 if asi_state_ut == "Haryana"
replace state = 7 if asi_state_ut == "Jammu and Kashmir"
replace state = 8 if asi_state_ut == "Karnataka"
replace state = 9 if asi_state_ut == "Kerala"
replace state = 10 if asi_state_ut == "Madhya Pradesh"
replace state = 11 if asi_state_ut == "Maharashtra"
replace state = 14 if asi_state_ut == "Orissa"
replace state = 15 if asi_state_ut == "Punjab"
replace state = 16 if asi_state_ut == "Rajasthan"
replace state = 18 if asi_state_ut == "Tamil Nadu"
replace state = 20 if asi_state_ut == "Uttar Pradesh"
replace state = 21 if asi_state_ut == "West Bengal"


drop if state == .
* taking district averages within states

collapse (mean) annual*, by(state)
reshape long annual, i(state) j(year)
rename annual rainfall
bys state: egen histmean = mean(rainfall)
bys state: egen histsd = sd(rainfall)
bys state: egen p20 = pctile(rainfall), p(20) 
bys state: egen p80 = pctile(rainfall), p(80)
ge shockpctile = 0
replace shockpctile = 1 if rainfall < p20
replace shockpctile = -1 if rainfall > p80
ge shocknorm = -((rainfall-histmean)/histsd)
keep state year shockpctile shocknorm 
sort state year
tempfile staterain_delaware
save `staterain_delaware', replace


* Generating state-year rainfall shock dataset from Socioeconomic.dta 

u "$besleyburgess\Socioeconomic.dta", clear
/*
bys state: egen histmean = mean(rainfall)
bys state: egen histsd = sd(rainfall)
bys state: egen p20 = pctile(rainfall), p(20) 
bys state: egen p80 = pctile(rainfall), p(80)
ge shockpctile = 0
replace shockpctile = 1 if rainfall < p20
replace shockpctile = -1 if rainfall > p80
ge shocknorm = -((rainfall-histmean)/histsd)
*/

* average values of other state characteritics
bys state: egen meannsdp = mean(nsdp)
bys state: egen meannsdpag = mean(nsdpag)
bys state: egen meannsdpman = mean(nsdpman)
label var meannsdp "mean state gdp"
label var meannsdpag "mean state agr production"
label var meannsdpman "mean state mfg production"
drop if rainfall  == .

sort state year
keep state year  meannsdp meannsdpag  meannsdpman 
tempfile socio
save `socio', replace

* Additinal labor reg vars from Chari
use $data\labregrainfall.dta, clear
ge state = .
replace state = 1 if statenm == "Andhra Pradesh"
replace state = 2 if statenm == "Assam"
replace state = 3 if statenm == "Bihar"
replace state = 4 if statenm == "Gujarat"
replace state = 5 if statenm == "Haryana"
replace state = 7 if statenm == "JK"
replace state = 8 if statenm == "Karnataka"
replace state = 9 if statenm == "Kerala"
replace state = 10 if statenm == "MP"
replace state = 11 if statenm == "Maharashtra"
replace state = 14 if statenm == "Orissa"
replace state = 15 if statenm == "Punjab"
replace state = 16 if statenm == "Rajasthan"
replace state = 18 if statenm == "Tamil Nadu"
replace state = 20 if statenm == "UP"
replace state = 21 if statenm == "WB"
keep if year == 1990
keep  state APcode APDS Bhatt EPLprow DSproe DSprow Bhattproe Bhattprow
sort state
tempfile laborregs
save `laborregs', replace

u "$aghion\ABRZ3dAER.dta", clear
sort state year
merge state year using `staterain_delaware' 
* rainfall data merges for 18 years: 1980-1997
keep if _m == 3
drop _m
sort state year
merge state year using `socio' 
drop _m
sort state
merge state using `laborregs'
drop _m

* proe is proemployer state, prow is proworker state
ge proe = nstrict < 0
ge prow = nstrict > 0
replace prow = . if nstrict == .

* rainshock*nic3 interactions

tab nic3, ge(nic3dummy)

local ic =  1
while `ic' <= 112{
ge shocknorm_nic3dum`ic' = shocknorm*nic3dummy`ic'
ge shockpctile_nic3dum`ic' = shockpctile*nic3dummy`ic'
local ic = `ic' + 1
} 

ge Bproe = Bhattproe
ge Bprow = Bhattprow

* interactions of rainshock with labor reg and other state characterisics
local l "shocknorm shockpctile"
foreach v of local l{
local g " nstrict  prow proe APcode APDS Bhatt EPLprow DSproe DSprow Bproe Bprow"
foreach w of local g{
ge `w'_`v' = `w'*`v'
}
}



local l "shocknorm shockpctile"
foreach v of local l{
local h "meannsdp meannsdpag meannsdpman"
foreach w of local h{
ge `w'_`v' = `w'*`v'
local g " nstrict  prow proe APcode APDS Bhatt EPLprow DSproe DSprow Bproe Bprow"
foreach z of local g{
ge `z'_`w'_`v' = `z'*`w'*`v'
}
}
}

local h "meannsdp meannsdpag meannsdpman"
foreach w of local h{
local g " nstrict  prow proe APcode APDS Bhatt EPLprow DSproe DSprow Bproe Bprow"
foreach z of local g{
ge `z'_`w' = `z'*`w'
}
}

******************************************************************************************
* Specification example from Aghion paper: state-ind, industry-year and state-year FEs.
*xi: areg lRirout nstrictdelic i.stateyr i.nic3yr if noj_yr==18, abs(statenic3) cluster(statefirstyr);
* In our case, state-yr FEs will be perfectly collinear with rain shock....
* This spec works: xi: areg workers shockpctile proe_shockpctile prow_shockpctile proe prow shockpctile_nic3dum*   i.year, abs(statenic3) cluster(stateyr)
********************************************************************************************
drop if year < 1980

saveold "$data\aghion_stateindustrypanel.dta", replace








