
* merge in aghion data controls
preserve

use "$data\aghion_stateindustrypanel.dta", clear

egen syr=group(state year)
collapse state year proe prow cmjan cmhdlft cmreg cmcona delicense pcona phdlft pjan phindu preg cmhindu head clre runbfor ubt77 ubt90 devexp ldevexp leduexp lhlthexp lothexp AgricTariff90 CommTariff90 FDIreform,by(syr)

*creating new statecode88 to merge with district files
ge statecode88=.
replace statecode88=41 if state==1
replace statecode88=34 if state==2
replace statecode88=31 if state==3
replace statecode88=51 if state==4
replace statecode88=14 if state==5
replace statecode88=13 if state==7
replace statecode88=53 if state==8
replace statecode88=43 if state==9
replace statecode88=22 if state==10
replace statecode88=52 if state==11
replace statecode88=32 if state==14
replace statecode88=12 if state==15
replace statecode88=11 if state==16
replace statecode88=42 if state==18
replace statecode88=21 if state==20
replace statecode88=33 if state==21

sort statecode88 year
tempfile tatti
save `tatti'

restore

sort statecode88 year
merge m:1 statecode88 year using `tatti', gen(_mergeaghion)

foreach x of varlist cmjan-FDIreform {
	g `x'_shockpctile = `x'*shockpctile
	}

replace prow_shockpctile = prow*shockpctile
replace proe_shockpctile = proe*shockpctile
