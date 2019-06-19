clear
set memory 500000
set matsize 8000
program drop _all
mat drop _all
scalar drop _all




use "Cycle_region_CRFs_2cents.dta", clear
gen cycle=1
sort region

merge region using "market_characteristics.dta", nokeep

/* THE market_characteristics.dta DATA CONTAINS THE FOLLOWING VARIALBES:

region			REGION NAME
populationperstation 	POPULATION OF MSA / # OF GASOLINE STATIONS FROM 2002 ECONOMIC CENSUS ESTABLISHMENTS DATA
indephhi		HERFINDAHL INDEX WITHIN INDEPENDENT RETAIL CHAINS AND STATIONS
indepshr		TOTAL MARKET SHARE OF ALL INDEPENDENT RETAIL CHAINS AND STATIONS
*/


drop _merge
sort region
save "temp.dta", replace

use "noncycle_city_CRFs.dta", clear
sort region
gen cycle=0

merge region using "market_characteristics.dta", nokeep

drop _merge
sort region

append using "temp.dta"


/*THE LOOP BELOW CONVERTS NON-CYCLE CRFs TO POSITIVE NUMBERS TO BE CONSISTENT WITH THE CYCLING MARKET CRFs.*/
local i=1
while `i'<=49 {
	replace day`i'=-day`i' if cycle==0 & up_down==2
	local i=`i'+1
	}



gen pos=up_down==1
gen neg=up_down==2

sum popperstation , meanonly
gen popperstationscaled=popperstation0- r(mean)

sum  indepshr , meanonly
gen indepshrscaled=indepshr- r(mean)

sum  withinindephhi , meanonly
gen withinindephhiscaled=withinindephhi- r(mean)

reg day5 cycle  popperstationscaled indepshrscaled withinindephhiscaled pos neg, noc
xi: reg day5 cycle  i.cycle|popperstationscaled i.cycle|indepshrscaled i.cycle|withinindephhiscaled  pos neg  if popperstation0~=0, noc

