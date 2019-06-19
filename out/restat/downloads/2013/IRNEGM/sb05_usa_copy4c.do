*Notes: excludes establishments that were never located in California.
*Notes: uses NETS 05 data from Ingrid's directory.
*uses NAICS codes. also is better equiped to handle firm growth, imputation and rounding than sb05_old

*********************
*Set Paths/Directories
*********************

local log_dir "F:\NETSData2007\Generated_files\SB05\Logs"
local root_dir "F:\NETSData2007\Generated_files"
local result_dir "F:\NETSData2007\Generated_files\SB05\Results4c"
local temp_dir "F:\NETSData2007\Generated_files\SB05\Temp4c"

* local dataset "netspanel07_extract.dta"
local dataset "netspanel07.dta"
*********************
*Set Input/Output Filenames
*********************

local log_file "`log_dir'\sb05_usa_copy4c.log"

clear
set mem 40g
set more off
capture log close
log using "`log_file'", replace

use "`root_dir'\\`dataset'", clear

*BW1 save "`temp_dir'\smallbusiness_temp.dta", replace

** my strategy is to just treat closed estabs as having zero employment.  I'm pretty sure that this is what DHS does.  Does this seem right?

**generate zero pre and post year  (In the prepared data I had previously dropped all of the non-existant years, specifically, I need a year after death, and a year before birth, in order to generate the denominators for the empchange rates)
keep emp dunsnumber year firstyear lastyear hqduns naics fips_ca empc
keep if year==firstyear+1 | year==lastyear
* duplicates report dunsnumber
save "`temp_dir'\multiyearestab.dta", replace
keep if year==firstyear+1 & year==lastyear
replace year=lastyear+1 if year==lastyear
append using `temp_dir'\multiyearestab.dta
erase "`temp_dir'\multiyearestab.dta"
replace year=firstyear if year==firstyear+1
replace year=lastyear+1 if year==lastyear
replace emp=0
keep emp dunsnumber year firstyear lastyear hqduns naics fips_ca empc
save "`temp_dir'\smallbusiness_append.dta", replace

use "`root_dir'\\`dataset'", clear
keep emp dunsnumber year firstyear lastyear hqduns naics fips_ca empc

append using "`temp_dir'\smallbusiness_append.dta"
erase "`temp_dir'\smallbusiness_append.dta"
*BW1 erase "`temp_dir'\smallbusiness_temp.dta"

** BELOW: This part of the script can be remarked
******************
***Keep only specific industries
******************
keep emp dunsnumber year firstyear lastyear hqduns naics fips_ca empc
gen naics2 = floor(naics/10000)

* surpress spurious naics data for pre-birth and post-death years
replace naics2 = . if emp==0

gen naics_ind = .
replace naics_ind = 1  if naics2==11
replace naics_ind = 2  if naics2==21
replace naics_ind = 3  if naics2==22
replace naics_ind = 4  if naics2==23
replace naics_ind = 5  if naics2>=31 & naics2<=33
replace naics_ind = 6  if naics2==42
replace naics_ind = 7  if naics2>=44 & naics2<=45
replace naics_ind = 8  if naics2>=48 & naics2<=49
replace naics_ind = 9  if naics2==51
replace naics_ind = 10 if naics2==52
replace naics_ind = 11 if naics2==53
replace naics_ind = 12 if naics2==54
replace naics_ind = 13 if naics2==55
replace naics_ind = 14 if naics2==56
replace naics_ind = 15 if naics2==61
replace naics_ind = 16 if naics2==62
replace naics_ind = 17 if naics2==71
replace naics_ind = 18 if naics2==72
replace naics_ind = 19 if naics2==81
replace naics_ind = 20 if naics2==92
replace naics_ind = 21 if naics2==99

label define naics_ind 1 "Agr, forest, fishing and hunting" 2 "Mining" 3 "Utilities" 4 "Construction" 5 "Manufacturing" 6 "Wholesale trade" 7 "Retail Trade" 8 "Transportation and Warehousing" 9 "Information" 10 "Finance and insurance" 11 "Real estate and rental and leasing" 12 "Professional and technical services" 13 "Management of companies and enterprises" 14 "Administrative and waste services" 15 "Educational services" 16 "Health care and social assistance" 17 "Arts, entertainment, and recreation" 18 "Accommodation and food services" 19 "Other services, except public administration" 20 "Public Administration" 21 "Unclassified" 
label values naics_ind naics_ind

egen indyears=count(emp) if year>=1993, by(dunsnumber naics_ind)

egen indyears_max=max(indyears) if year>=1993, by(dunsnumber)
gen ind_major = naics_ind if indyears_max==indyears & year>=1993
egen indlyear=max(year) if ind_major~=. & year>=1993, by(dunsnumber)
gen ind_major2 = naics_ind if indlyear==year & year>=1993
egen ind_major3=max(ind_major2), by(dunsnumber)
drop ind_major2 indyears indyears_max indlyear ind_major 
rename ind_major3 ind_major

keep if ind_major>=9 & ind_major<=19
** ABOVE: This part of the script can be remarked
*

** BELOW: This part of the script can be remarked
******************
***Drop gov't establishments...
******************
keep emp dunsnumber year firstyear lastyear hqduns naics fips_ca empc
gen govt=.
replace govt=1 if naics>=920000 & naics<930000 & year>=1993
replace govt=0 if (naics<920000 | naics>=930000) & naics~=. & year>=1993
egen alwaysgovt=min(govt) if naics~=., by(dunsnumber)
* egen evergovt=max(govt) if naics~=., by(dunsnumber)
drop if alwaysgovt==1
drop govt alwaysgovt
** ABOVE: This part of the script can be remarked


/** BELOW: This part of the script can be remarked
******************
***Drop establishments with imputed employment data...
******************
keep emp dunsnumber year hqduns naics fips_ca empc
replace empc=. if emp==0
gen imp=.
replace imp=1 if empc~=0 & empc~=. & year>=1993
replace imp=0 if empc==0 & year>=1993

egen impsum=sum(imp) if naics~=., by(dunsnumber)
egen impyears=count(imp) if year>=1993 & emp~=0, by(dunsnumber)
gen imppct=impsum/impyears
egen imppct2= max(imppct), by(dunsnumber)
drop if imppct2>.25 | imppct2==.
drop imp impsum impyears imppct imppct2

*egen alwaysimp=min(imp) if naics~=., by(dunsnumber)
* egen everimp=max(imp) if naics~=., by(dunsnumber)
* drop if alwaysimp==1
* drop imp alwaysimp
count
** ABOVE: This part of the script can be remarked
*/

/** BELOW: This part of the script can be remarked
******************
***Drop establishments with rounded employment data... (drop multi50 or mult100, how much is left?)
******************
keep emp dunsnumber year hqduns naics fips_ca empc
gen rnd=.
gen int1=emp/10
gen int2=round(int1)
replace rnd=1 if int1==int2 & int1~=. & year>=1993 & emp~=0
replace rnd=0 if int1~=int2 & int1~=. & year>=1993

egen alwaysrnd=min(rnd) if naics~=., by(dunsnumber)
drop if alwaysrnd==1
drop int1 int2 rnd alwaysrnd
* egen everrnd=max(rnd) if naics~=., by(dunsnumber)
* drop if everrnd==1
* drop int1 int2 rnd everrnd
count
** ABOVE: This part of the script can be remarked
*/


/** BELOW: This part of the script can be remarked
******************
***Sythentic rounding: robustness check 10, round/floor/ceiling
******************
replace emp=round(emp,10)

*round emp<100 to nearest 10, round emp>=100 to nearest 100
* replace emp=round(emp,10) if emp<100
* replace emp=round(emp,100) if emp>100

** ABOVE: This part of the script can be remarked
*/


******************
*2. collapse to firm level method

keep emp dunsnumber year hqduns fips_ca
save `temp_dir'\trulytempdata, replace

collapse (sum) firmemp = emp, by(hqduns year)
tsset hqduns year

capture drop sizecat
capture label drop sizecat

******************
***Save data with never located in California establishments for firm analysis, analyze firm with all branches
******************
***place after neverlocated in CA if only want to analyze jc/jd at firm level for estabs in CA
******************

gen firmbaseemp = L.firmemp
gen avgfirmemp = (L.firmemp + firmemp)/2
gen firmempdiff = firmemp - L.firmemp
rename firmempdiff empdiff

*COUNT FIRM DATA

count if year>=1994 & year<=2005 & avgfirmemp~=. & avgfirmemp~=0

save `result_dir'\smallbusinessfirmdata, replace

capture drop firmemp
capture drop hqduns

drop if year<1994
drop if year>2005
gen emp_growth_rate = empdiff / avgfirmemp
collapse (mean) emp_growth_rate (count) freq_weight=emp_growth_rate, by(avgfirmemp)

save `result_dir'\firmnonpardata, replace







use `temp_dir'\trulytempdata, clear
erase `temp_dir'\trulytempdata.dta

sort dunsnumber year
count if emp==.
gen empdiff = emp - L.emp
gen avgemp = (L.emp + emp)/2


/******************
***treat moves in and out of california as deaths (can I just set emp to zero for out of CA periods?) This can be commented out
******************

count if emp==.
replace emp=0 if fips_ca ~=1
drop empdiff avgemp

gen empdiff = emp - L.emp

gen avgemp = (L.emp + emp)/2

drop if avgemp==0

******************
***option1.Drop establishments never located in California for establishment analysis
******************

egen fips_ca2 = max(fips_ca), by(dunsnumber)
keep if fips_ca2==1
drop fips_ca fips_ca2
*/

/******************
***option2.Drop establishments ever located outside California for establishment analysis
******************

egen fips_ca2 = min(fips_ca), by(dunsnumber)
drop if fips_ca2==0
drop fips_ca fips_ca2
*/

******************
***option3.Keep all establishments, regardless of location USA analysis
******************
drop fips_ca


* Count observations
count if year>=1994 & year<=2005 & avgemp~=. & avgemp~=0


gen baseemp = L.emp

save `result_dir'\smallbusinessdata, replace

capture drop firmemp
capture drop hqduns

drop if year<1994
drop if year>2005
gen emp_growth_rate = empdiff / avgemp
collapse (mean) emp_growth_rate (count) freq_weight=emp_growth_rate, by(avgemp)

save `result_dir'\nonpardata, replace



***size categories from DHS
**********************************************
*1. current estab size measure (avg of two years)
**********************************************
use `result_dir'\smallbusinessdata, clear

capture drop firmemp

gen sizecat=.
local j = 0
foreach condition in "avgemp>=0 & avgemp<20" "avgemp>=20 & avgemp<50" "avgemp>=50 & avgemp<100" "avgemp>=100 & avgemp<250" "avgemp>=250 & avgemp<500" "avgemp>=500 & avgemp<1000" "avgemp>=1000 & avgemp<2500" "avgemp>=2500 & avgemp<5000" "avgemp>=5000 & avgemp~=." {
local j = `j' + 1
replace sizecat=`j' if `condition'
}

label var sizecat "Establishment Employment Size Categories"
label define sizecat 1 "0-19" 2 "20-49" 3 "50-99" 4 "100-249" 5 "250-499" 6 "500-999" 7 "1000-2499" 8 "2500-4999" 9 "5000+"
label values sizecat sizecat

**current estab size measure (avg of two years)

drop if sizecat==.
drop if year<1994
drop if year>2005

************
* FINAL OBS COUNT
************

count

save `temp_dir'\currentempdata, replace

rename avgemp curremp
collapse (sum) curremp, by(sizecat year)
reshape wide curremp, i(sizecat) j(year)
forvalues x=1994/2005 {
rename curremp`x' _`x'
}

forvalues missingcat = 1/9 {
count if sizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace sizecat = `missingcat' in `fillinobs'
}
}
sort sizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(curremp)
matrix rownames curremp= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+



**gross creation table
use `temp_dir'\currentempdata, clear
collapse (sum) empdiff if empdiff>0, by(sizecat year)
rename empdiff curr_gcreation
reshape wide curr_gcreation, i(sizecat) j(year)
forvalues x=1994/2005 {
rename curr_gcreation`x' _`x'
}

forvalues missingcat = 1/9 {
count if sizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace sizecat = `missingcat' in `fillinobs'
}
}
sort sizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(curr_gcreation)
matrix rownames curr_gcreation= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+



**gross destruction table
use `temp_dir'\currentempdata, clear
collapse (sum) empdiff if empdiff<0, by(sizecat year)
rename empdiff curr_gdestruct
replace curr_gdestruct=-1*curr_gdestruct
reshape wide curr_gdestruct, i(sizecat) j(year)
forvalues x=1994/2005 {
rename curr_gdestruct`x' _`x'
}

forvalues missingcat = 1/9 {
count if sizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace sizecat = `missingcat' in `fillinobs'
}
}
sort sizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(curr_gdestruct)
matrix rownames curr_gdestruct= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+


**net job creation
matrix curr_netchange= (curr_gcreation-curr_gdestruct)
**gross creation rate
matrix define curr_gc_rate = J(9,12,0)
matrix define curr_gd_rate = J(9,12,0)
matrix define curr_nc_rate = J(9,12,0)
forvalues i = 1/9 {
forvalues j = 1/12 {
**gross creation rate
matrix curr_gc_rate[`i',`j'] = curr_gcreation[`i',`j']/curremp[`i',`j']
**gross destruction rate
matrix curr_gd_rate[`i',`j'] = curr_gdestruct[`i',`j']/curremp[`i',`j']
**net change job creation rate
matrix curr_nc_rate[`i',`j'] = curr_netchange[`i',`j']/curremp[`i',`j']
}
}


**Current Emp Size Category Share of Overall Employment
matrix define curr_empshare = J(9,12,0)
forvalues i = 1/9 {
forvalues j = 1/12 {
**gross creation rate
matrix curr_empshare[`i',`j'] = curremp[`i',`j']/(curremp[1,`j']+curremp[2,`j']+curremp[3,`j']+curremp[4,`j']+curremp[5,`j']+curremp[6,`j']+curremp[7,`j']+curremp[8,`j']+curremp[9,`j'])
}
}


****save data

drop _all

input str15 rowname
"0-19"
"20-49"
"50-99"
"100-249"
"250-499"
"500-999"
"1000-2499"
"2500-4999"
"5000+"
end


foreach x in curr_gcreation curr_gdestruct curremp curr_netchange curr_gc_rate curr_gd_rate curr_nc_rate curr_empshare {

matrix colnames `x' = _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005
matrix rownames `x' = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+

svmat double `x', names(col)
save "`result_dir'\\`x'", replace

drop _*

}



*base-year measure of plant size
*historical average plant size measure
*current-year measure of plant size


***size categories from DHS

**********************************************
*2. baseyear estab size measure (first of two years)
**********************************************
use `result_dir'\smallbusinessdata, clear
capture drop firmemp
capture drop avgemp
capture drop sizecat
capture label drop sizecat


* gen baseemp = L.emp

gen sizecat=.
local j = 0
foreach condition in "baseemp>=0 & baseemp<20" "baseemp>=20 & baseemp<50" "baseemp>=50 & baseemp<100" "baseemp>=100 & baseemp<250" "baseemp>=250 & baseemp<500" "baseemp>=500 & baseemp<1000" "baseemp>=1000 & baseemp<2500" "baseemp>=2500 & baseemp<5000" "baseemp>=5000 & baseemp~=." {
local j = `j' + 1
replace sizecat=`j' if `condition'
}

label var sizecat "Establishment Employment Size Categories"
label define sizecat 1 "0-19" 2 "20-49" 3 "50-99" 4 "100-249" 5 "250-499" 6 "500-999" 7 "1000-2499" 8 "2500-4999" 9 "5000+"
label values sizecat sizecat

drop if sizecat==.
drop if year<1994
drop if year>2005

count

save `temp_dir'\baseempdata, replace

**current estab size measure (avg of two years)
collapse (sum) baseemp, by(sizecat year)
reshape wide baseemp, i(sizecat) j(year)
forvalues x=1994/2005 {
rename baseemp`x' _`x'
}

forvalues missingcat = 1/9 {
count if sizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace sizecat = `missingcat' in `fillinobs'
}
}
sort sizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(baseemp)
matrix rownames baseemp= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+



**gross creation table
use `temp_dir'\baseempdata, clear
collapse (sum) empdiff if empdiff>0, by(sizecat year)
rename empdiff base_gcreation
reshape wide base_gcreation, i(sizecat) j(year)
forvalues x=1994/2005 {
rename base_gcreation`x' _`x'
}

forvalues missingcat = 1/9 {
count if sizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace sizecat = `missingcat' in `fillinobs'
}
}
sort sizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(base_gcreation)
matrix rownames base_gcreation= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+



**gross destruction table
use `temp_dir'\baseempdata, clear
collapse (sum) empdiff if empdiff<0, by(sizecat year)
rename empdiff base_gdestruct
replace base_gdestruct=-1*base_gdestruct
reshape wide base_gdestruct, i(sizecat) j(year)
forvalues x=1994/2005 {
rename base_gdestruct`x' _`x'
}

forvalues missingcat = 1/9 {
count if sizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace sizecat = `missingcat' in `fillinobs'
}
}
sort sizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(base_gdestruct)
matrix rownames base_gdestruct= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+




**net job creation
matrix base_netchange= (base_gcreation-base_gdestruct)
**gross creation rate
matrix define base_gc_rate = J(9,12,0)
matrix define base_gd_rate = J(9,12,0)
matrix define base_nc_rate = J(9,12,0)
forvalues i = 1/9 {
forvalues j = 1/12 {
**gross creation rate
matrix base_gc_rate[`i',`j'] = base_gcreation[`i',`j']/baseemp[`i',`j']
**gross destruction rate
matrix base_gd_rate[`i',`j'] = base_gdestruct[`i',`j']/baseemp[`i',`j']
**net change job creation rate
matrix base_nc_rate[`i',`j'] = base_netchange[`i',`j']/baseemp[`i',`j']
}
}


**Current Emp Size Category Share of Overall Employment
matrix define base_empshare = J(9,12,0)
forvalues i = 1/9 {
forvalues j = 1/12 {
**gross creation rate
matrix base_empshare[`i',`j'] = baseemp[`i',`j']/(baseemp[1,`j']+baseemp[2,`j']+baseemp[3,`j']+baseemp[4,`j']+baseemp[5,`j']+baseemp[6,`j']+baseemp[7,`j']+baseemp[8,`j']+baseemp[9,`j'])
}
}


****save data

drop _all

input str15 rowname
"0-19"
"20-49"
"50-99"
"100-249"
"250-499"
"500-999"
"1000-2499"
"2500-4999"
"5000+"
end


foreach x in base_gcreation base_gdestruct baseemp base_netchange base_gc_rate base_gd_rate base_nc_rate base_empshare {

matrix colnames `x' = _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005
matrix rownames `x' = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+

svmat double `x', names(col)
save "`result_dir'\\`x'", replace

drop _*

}


**********************************************
*3. current firm size measure (avg of two years) [using each estab observation for each firm]
**********************************************

use `result_dir'\smallbusinessfirmdata, clear

capture firmbaseemp

gen firmsizecat=.
local j = 0
foreach condition in "avgfirmemp>=0 & avgfirmemp<20" "avgfirmemp>=20 & avgfirmemp<50" "avgfirmemp>=50 & avgfirmemp<100" "avgfirmemp>=100 & avgfirmemp<250" "avgfirmemp>=250 & avgfirmemp<500" "avgfirmemp>=500 & avgfirmemp<1000" "avgfirmemp>=1000 & avgfirmemp<2500" "avgfirmemp>=2500 & avgfirmemp<5000" "avgfirmemp>=5000 & avgfirmemp<10000" "avgfirmemp>=10000 & avgfirmemp<25000" "avgfirmemp>=25000 & avgfirmemp<50000"  "avgfirmemp>=50000 & avgfirmemp~=." {
local j = `j' + 1
replace firmsizecat=`j' if `condition'
}

label var firmsizecat "Firm Employment Size Categories"
label define firmsizecat 1 "0-19" 2 "20-49" 3 "50-99" 4 "100-249" 5 "250-499" 6 "500-999" 7 "1000-2499" 8 "2500-4999" 9 "5000-9999" 10 "10000-24999" 11 "25000-49999" 12 "50000+"
label values firmsizecat firmsizecat

**current firm size measure (avg of two years)

drop if firmsizecat==.
drop if year<1994
drop if year>2005
save `temp_dir'\currentempdata, replace

rename avgfirmemp currentemp
collapse (sum) currentemp, by(firmsizecat year)
reshape wide currentemp, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename currentemp`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmcurremp)
matrix rownames firmcurremp = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+

**gross creation table
use `temp_dir'\currentempdata, clear
collapse (sum) empdiff if empdiff>0, by(firmsizecat year)
rename empdiff firmcurr_gcreation
reshape wide firmcurr_gcreation, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmcurr_gcreation`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmcurr_gcreation)
matrix rownames firmcurr_gcreation = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+


**gross destruction table
use `temp_dir'\currentempdata, clear
collapse (sum) empdiff if empdiff<0, by(firmsizecat year)
rename empdiff firmcurr_gdestruct
replace firmcurr_gdestruct=-1*firmcurr_gdestruct
reshape wide firmcurr_gdestruct, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmcurr_gdestruct`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmcurr_gdestruct)
matrix rownames firmcurr_gdestruct = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+

**net job creation
matrix firmcurr_netchange= (firmcurr_gcreation-firmcurr_gdestruct)
**gross creation rate
matrix define firmcurr_gc_rate = J(12,12,0)
matrix define firmcurr_gd_rate = J(12,12,0)
matrix define firmcurr_nc_rate = J(12,12,0)
forvalues i = 1/12 {
forvalues j = 1/12 {
**gross creation rate
matrix firmcurr_gc_rate[`i',`j'] = firmcurr_gcreation[`i',`j']/firmcurremp[`i',`j']
**gross destruction rate
matrix firmcurr_gd_rate[`i',`j'] = firmcurr_gdestruct[`i',`j']/firmcurremp[`i',`j']
**net change job creation rate
matrix firmcurr_nc_rate[`i',`j'] = firmcurr_netchange[`i',`j']/firmcurremp[`i',`j']
}
}


**Current Emp Size Category Share of Overall Employment
matrix define firmcurr_empshare = J(12,12,0)
forvalues i = 1/12 {
forvalues j = 1/12 {
**gross creation rate
matrix firmcurr_empshare[`i',`j'] = firmcurremp[`i',`j']/(firmcurremp[1,`j']+firmcurremp[2,`j']+firmcurremp[3,`j']+firmcurremp[4,`j']+firmcurremp[5,`j']+firmcurremp[6,`j']+firmcurremp[7,`j']+firmcurremp[8,`j']+firmcurremp[9,`j']+firmcurremp[10,`j']+firmcurremp[11,`j']+firmcurremp[12,`j'])
}
}


****save data

drop _all

input str15 rowname
"0-19"
"20-49"
"50-99"
"100-249"
"250-499"
"500-999"
"1000-2499"
"2500-4999"
"5000-9999"
"10000-24999"
"25000-49999"
"50000+"
end


foreach x in firmcurr_gcreation firmcurr_gdestruct firmcurremp firmcurr_netchange firmcurr_gc_rate firmcurr_gd_rate firmcurr_nc_rate firmcurr_empshare {

matrix colnames `x' = _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005
matrix rownames `x' = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+

svmat double `x', names(col)
save "`result_dir'\\`x'", replace

drop _*

}


**********************************************
*4. baseyear firm size measure (first of two years)
**********************************************

use `result_dir'\smallbusinessfirmdata, clear

capture drop avgfirmemp

gen firmsizecat=.
local j = 0
foreach condition in "firmbaseemp>=0 & firmbaseemp<20" "firmbaseemp>=20 & firmbaseemp<50" "firmbaseemp>=50 & firmbaseemp<100" "firmbaseemp>=100 & firmbaseemp<250" "firmbaseemp>=250 & firmbaseemp<500" "firmbaseemp>=500 & firmbaseemp<1000" "firmbaseemp>=1000 & firmbaseemp<2500" "firmbaseemp>=2500 & firmbaseemp<5000" "firmbaseemp>=5000 & firmbaseemp<10000" "firmbaseemp>=10000 & firmbaseemp<25000" "firmbaseemp>=25000 & firmbaseemp<50000"  "firmbaseemp>=50000 & firmbaseemp~=." {
local j = `j' + 1
replace firmsizecat=`j' if `condition'
}

label var firmsizecat "Firm Employment Size Categories"
label define firmsizecat 1 "0-19" 2 "20-49" 3 "50-99" 4 "100-249" 5 "250-499" 6 "500-999" 7 "1000-2499" 8 "2500-4999" 9 "5000-9999" 10 "10000-24999" 11 "25000-49999" 12 "50000+"
label values firmsizecat firmsizecat

**base firm size measure (avg of two years)

drop if firmsizecat==.
drop if year<1994
drop if year>2005

count

save `temp_dir'\firmbaseempdata, replace

collapse (sum) firmbaseemp, by(firmsizecat year)
reshape wide firmbaseemp, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmbaseemp`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmbaseemp)
matrix rownames firmbaseemp= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+


**gross creation table
use `temp_dir'\firmbaseempdata, clear
collapse (sum) empdiff if empdiff>0, by(firmsizecat year)
rename empdiff firmbase_gcreation
reshape wide firmbase_gcreation, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmbase_gcreation`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmbase_gcreation)
matrix rownames firmbase_gcreation= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+



**gross destruction table
use `temp_dir'\firmbaseempdata, clear
collapse (sum) empdiff if empdiff<0, by(firmsizecat year)
rename empdiff firmbase_gdestruct
replace firmbase_gdestruct=-1*firmbase_gdestruct
reshape wide firmbase_gdestruct, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmbase_gdestruct`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmbase_gdestruct)
matrix rownames firmbase_gdestruct= 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+



**net job creation
matrix firmbase_netchange= (firmbase_gcreation-firmbase_gdestruct)
**gross creation rate
matrix define firmbase_gc_rate = J(12,12,0)
matrix define firmbase_gd_rate = J(12,12,0)
matrix define firmbase_nc_rate = J(12,12,0)
forvalues i = 1/12 {
forvalues j = 1/12 {
**gross creation rate
matrix firmbase_gc_rate[`i',`j'] = firmbase_gcreation[`i',`j']/firmbaseemp[`i',`j']
**gross destruction rate
matrix firmbase_gd_rate[`i',`j'] = firmbase_gdestruct[`i',`j']/firmbaseemp[`i',`j']
**net change job creation rate
matrix firmbase_nc_rate[`i',`j'] = firmbase_netchange[`i',`j']/firmbaseemp[`i',`j']
}
}


**Current Emp Size Category Share of Overall Employment
matrix define firmbase_empshare = J(12,12,0)
forvalues i = 1/12 {
forvalues j = 1/12 {
**gross creation rate
matrix firmbase_empshare[`i',`j'] = firmbaseemp[`i',`j']/(firmbaseemp[1,`j']+firmbaseemp[2,`j']+firmbaseemp[3,`j']+firmbaseemp[4,`j']+firmbaseemp[5,`j']+firmbaseemp[6,`j']+firmbaseemp[7,`j']+firmbaseemp[8,`j']+firmbaseemp[9,`j']+firmbaseemp[10,`j']+firmbaseemp[11,`j']+firmbaseemp[12,`j'])
}
}


****save data

drop _all

input str15 rowname
"0-19"
"20-49"
"50-99"
"100-249"
"250-499"
"500-999"
"1000-2499"
"2500-4999"
"5000-9999"
"10000-24999"
"25000-49999"
"50000+"
end


foreach x in firmbase_gcreation firmbase_gdestruct firmbaseemp firmbase_netchange firmbase_gc_rate firmbase_gd_rate firmbase_nc_rate firmbase_empshare {

matrix colnames `x' = _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005
matrix rownames `x' = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+

svmat double `x', names(col)
save "`result_dir'\\`x'", replace

drop _*

}



/**********************************************
*5b. current firm size measure (avg of two years) [using one firm obs for each firm]
**********************************************
**NOTE: THIS SECTION IS CODED WRONG.  The firmemp already defined uses all branches, the new summed firmemp
**only uses CA branches.  we can't use the firmemp_total as a denominator, because the empdiff only considers CA branches, so the rate would be calculated incorrectly
use `result_dir'\smallbusinessdata, clear

**new code  
collapse (max) firmemp_total (sum) firmemp_ca=emp (sum) empdiff, by(hqduns year)
tsset hqduns year
**end- new code

gen avgfirmemp = (L.firmemp + firmemp)/2

gen firmsizecat=.
local j = 0
foreach condition in "avgfirmemp>=0 & avgfirmemp<20" "avgfirmemp>=20 & avgfirmemp<50" "avgfirmemp>=50 & avgfirmemp<100" "avgfirmemp>=100 & avgfirmemp<250" "avgfirmemp>=250 & avgfirmemp<500" "avgfirmemp>=500 & avgfirmemp<1000" "avgfirmemp>=1000 & avgfirmemp<2500" "avgfirmemp>=2500 & avgfirmemp<5000" "avgfirmemp>=5000 & avgfirmemp<10000" "avgfirmemp>=10000 & avgfirmemp<25000" "avgfirmemp>=25000 & avgfirmemp<50000"  "avgfirmemp>=50000 & avgfirmemp~=." {
local j = `j' + 1
replace firmsizecat=`j' if `condition'
}

label var firmsizecat "Firm Employment Size Categories"
label define firmsizecat 1 "0-19" 2 "20-49" 3 "50-99" 4 "100-249" 5 "250-499" 6 "500-999" 7 "1000-2499" 8 "2500-4999" 9 "5000-9999" 10 "10000-24999" 11 "25000-49999" 12 "50000+"
label values firmsizecat firmsizecat

**current firm size measure (avg of two years)

drop if firmsizecat==.
drop if year<1994
drop if year>2005
collapse (sum) emp (sum) empdiff (max) firmemp (min) firmemp_min=firmemp (max) avgfirmemp (min) avgfirmemp_min=avgfirmemp (sum) avgemp, by(hqduns year)
* check to see that emp = firmemp = firmemp_min
* gen avgfirmemp2 = (L.memp + emp)/2


save `temp_dir'\currentempdata, replace

rename avgfirmemp currentfirmemp
collapse (sum) currentfirmemp, by(firmsizecat year)
reshape wide currentfirmemp, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename currentfirmemp`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(currentfirmemp)
matrix rownames currentfirmemp = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+

**gross creation table
use `temp_dir'\currentempdata, clear
collapse (sum) empdiff if empdiff>0, by(firmsizecat year)
rename empdiff firmcurr_gcreation
reshape wide firmcurr_gcreation, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmcurr_gcreation`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmcurr_gcreation)
matrix rownames firmcurr_gcreation = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+


**gross destruction table
use `temp_dir'\currentempdata, clear
collapse (sum) empdiff if empdiff<0, by(firmsizecat year)
rename empdiff firmcurr_gdestruct
replace firmcurr_gdestruct=-1*firmcurr_gdestruct
reshape wide firmcurr_gdestruct, i(firmsizecat) j(year)
forvalues x=1994/2005 {
rename firmcurr_gdestruct`x' _`x'
}

forvalues missingcat = 1/12 {
count if firmsizecat==`missingcat'
if (`r(N)' == 0) {
local fillinobs = _N + 1
set obs `fillinobs'
replace firmsizecat = `missingcat' in `fillinobs'
}
}
sort firmsizecat

forvalues zerovalue = 1994/2005 {
replace _`zerovalue' = 0 if _`zerovalue' == .
}

mkmat _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005, matrix(firmcurr_gdestruct)
matrix rownames firmcurr_gdestruct = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000-9999 10000-24999 25000-49999 50000+

**net job creation
matrix firmcurr_netchange= (firmcurr_gcreation-firmcurr_gdestruct)
**gross creation rate
matrix define firmcurr_gc_rate = J(12,12,0)
matrix define firmcurr_gd_rate = J(12,12,0)
matrix define firmcurr_nc_rate = J(12,12,0)
forvalues i = 1/12 {
forvalues j = 1/12 {
**gross creation rate
matrix firmcurr_gc_rate[`i',`j'] = firmcurr_gcreation[`i',`j']/currentfirmemp[`i',`j']
**gross destruction rate
matrix firmcurr_gd_rate[`i',`j'] = firmcurr_gdestruct[`i',`j']/currentfirmemp[`i',`j']
**net change job creation rate
matrix firmcurr_nc_rate[`i',`j'] = firmcurr_netchange[`i',`j']/currentfirmemp[`i',`j']
}
}


**Current Emp Size Category Share of Overall Employment
matrix define firmcurr_empshare = J(12,12,0)
forvalues i = 1/12 {
forvalues j = 1/12 {
**gross creation rate
matrix firmcurr_empshare[`i',`j'] = currentfirmemp[`i',`j']/(currentfirmemp[1,`j']+currentfirmemp[2,`j']+currentfirmemp[3,`j']+currentfirmemp[4,`j']+currentfirmemp[5,`j']+currentfirmemp[6,`j']+currentfirmemp[7,`j']+currentfirmemp[8,`j']+currentfirmemp[9,`j']+currentfirmemp[10,`j']+currentfirmemp[11,`j']+currentfirmemp[12,`j'])
}
}


****save data

drop _all

input str15 rowname
"0-19"
"20-49"
"50-99"
"100-249"
"250-499"
"500-999"
"1000-2499"
"2500-4999"
"5000-9999"
"10000-24999"
"25000-49999"
"50000+"
end


foreach x in firmcurr_gcreation firmcurr_gdestruct currentfirmemp firmcurr_netchange firmcurr_gc_rate firmcurr_gd_rate firmcurr_nc_rate firmcurr_empshare {

matrix colnames `x' = _1994 _1995 _1996 _1997 _1998 _1999 _2000 _2001 _2002 _2003 _2004 _2005
matrix rownames `x' = 0-19 20-49 50-99 100-249 250-499 500-999 1000-2499 2500-4999 5000+

svmat double `x', names(col)
save "`result_dir'\\`x'", replace

drop _*

}

*/



log close

