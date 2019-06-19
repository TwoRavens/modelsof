* creates yield measure for 1987, 1990 and 1993, and merges new ag data into district codes
* Price in 1985 as base price

use "$data\agri56_03.dta", clear




ge y85 = year == 1985
ge y87 = year == 1987

local l "price pbajra pjowar pbarley pmaize pwheat"
foreach v of local l{
ge x`v' = `v'*y85
egen `v'85 = max(x`v'), by(statenam distname)
drop  x`v'
}

keep if year == 1987| year == 1990| year == 1993
* sometime, zero price and quantity when acreage is zero
local l "rice bajra jowar barley maize wheat"
foreach v of local l{
replace p`v'85 = 1 if p`v'85 == 0
replace q`v' = 0 if q`v' == .
replace a`v' = 0 if a`v' == .
}

ge yield = (price85*qrice + pwheat85*qwheat + pjowar85*qjowar + pmaize85*qmaize + pbajra85*qbajra + pbarley85*qbarley)/(awheat + arice + ajowar+ abajra+ abarley +amaize)
* missing for 76 dist-years


keep  statenam distname year yield
rename statenam agrstate
rename distname agrdistrict
sort agrstate agrdistrict year
tempfile yield
save "$data\yield", replace

* merging into code

use "$data\code91_asicode88.dta", clear
sort code91
save "$data\code88", replace

use "$data\distcodes_nss_agri.dta", clear
sort code91
merge code91 using "$data\code88"
drop _m

keep agrstate agrdistrict asicode88
drop if agrstate == ""
duplicates drop
expand 3
egen year =seq(), by(asicode88)
replace year = 1987 if year == 1
replace year = 1990 if year == 2
replace year = 1993 if year == 3

sort agrstate agrdistrict year
save "$data\agrcode88", replace

use "$data\yield"
merge agrstate agrdistrict year using "$data\agrcode88"
drop _m
drop if year  < 1000
sort asicode88 year



