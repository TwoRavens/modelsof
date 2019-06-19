// ------------------------------------------
// Export data to matlab
// ------------------------------------------

// Export data variable names: 
// varenr	= 	HS8 code
// foretak	= 	firm id
// verdi	= 	export value
// vekt	= 	weight
// mengde	=	alternative unit (used if present)
// obland	= 	destination country
// vnr_m2	= 	dummy = 1 if alternative unit present
// 
// Penn tables variable names:
// dist	=	distance, km
// cgdp 	=	GDP/capita
// pop	= 	population
//
// Note: a2group must be installed in order to remove product-destinations that are not identified.
// Note2: The return variable from a2group "mobgroup" should be = 1 for the biggest group. 

clear all
set mem 3g
set more off

clear all
//cd /Applications/Dropbox/RnD_KK/tradecost_replication/
cd /Dropbox/RnD_KK/tradecost_replication/

//global savepath "trade_costs"
global savepath2 "data_matlab"
global datapath "data"
global tmppath "tmp"
//global pennpath "$datapath/penn_6_2_full_iso2_dist" 

global oil `"varenr=="27090000" | varenr=="27112100" | varenr=="27111100" | varenr=="27090009" | varenr=="27090001""'
global unknown 4980	// Firm 4980 is a dummy group for all unidentified firms
global year "2004"
global thresh 20     // Number of firms that must be present in a destination (per product)

use "$datapath/moxnes_lopenr_$year", clear

keep if impeks=="2"		// Only exports
drop if foretak==$unknown
drop if $oil

// For some obs we have multiple product-firm-dest obs because transit country
// and country of origin differs (on the import side)

collapse (sum) verdi vekt mengde, by(foretak impeks year obland varenr year vnr_m2)
replace mengde=. if mengde==0 & vnr_m2=="1"
// Mengde is set to zero even if missing in the collapse

// Use alternative quantity if present
gen qty = vekt if mengde==.
replace qty = mengde if mengde!=.
//gen qty = vekt		// Always use kilos

rename obland iso2

// In Portuguese data, some quantities are 0.
drop if qty==0

// Calculate price
gen price = verdi/qty

// Winsorize each destination-product (was .02)
cumul qty, generate(cdf) by(varenr iso2)
drop if cdf<.02 | cdf>.98

gen sigma = 6

// Drop product-destinations with less than XX firms
egen numfirms = count(foretak), by(varenr iso2)
drop if numfirms<$thresh

// Drop product-dests not in the 1st mobility group
a2group, individual(varenr) unit(iso2) groupvar(mobgroup)
drop if mobgroup!=1
drop mobgroup

save "$tmppath/tmp", replace

// ------------------------------------------
// Find distance and GDP
// ------------------------------------------
use "$tmppath/tmp", clear

collapse (count) foretak, by(iso2 year)
joinby iso2 year using "$datapath/penn62_iso2_dist_small.dta", unmatched(none)
keep iso2 year dist cgdp pop
gen gdp = cgdp*pop
drop if cgdp==.
sort iso2
//outfile iso2 gdp cgdp pop dist using "$savepath2/data_dist_gdp_40thresh_`year'" , comma wide replace noquote
outfile iso2 gdp cgdp pop dist using "$savepath2/data_dist_gdp_${thresh}thresh_${year}" , comma wide replace noquote

save "$tmppath/tmp2", replace

// ------------------------------------------
// Merge
// ------------------------------------------
use "$tmppath/tmp", clear

// Drop destinations that are not matched to Penn
joinby iso2 year using "$tmppath/tmp2", unmatched(none)   //ignore all unmatched observations

// Make a matrix of total export value per product-destination (used as weights)
statsby, by(varenr iso2) saving("$savepath2/weights_${thresh}thresh_${year}", replace): total verdi vekt

// Make a vector of value, weight and quantities per product
statsby, by(varenr) saving("$savepath2/weight_value_${thresh}thresh_${year}", replace): total verdi vekt

// Make a vector of value, weight and quantities per product - only SE
statsby, by(varenr iso2) saving("$savepath2/weight_value_SE_${thresh}thresh_${year}", replace): total verdi vekt

// Make a vector of value, weight and quantities per product
statsby, by(varenr) saving("$savepath2/weight_qty_${thresh}thresh_${year}", replace): total vekt mengde

// Make a vector of value, weight and quantities per product - only SE
statsby, by(varenr) saving("$savepath2/weight_qty_SE_${thresh}thresh_${year}", replace): total vekt mengde if iso2=="SE"

capture drop cdf
drop dist pop cgdp gdp 
drop verdi impeks vnr_m2 vekt mengde numfirms 

// ------------------------------------------
// Make matrix
// ------------------------------------------

reshape wide qty price, i(foretak varenr) j(iso2) string

// Export to matlab
sort varenr foretak
destring varenr, replace

outfile foretak varenr qty* using "$savepath2/data_qty_${thresh}thresh_${year}", comma wide replace
outfile foretak varenr price* using "$savepath2/data_price_${thresh}thresh_${year}", comma wide replace
// Note: Missing values will be transformed into zeroes when imported into Matlab

// Export the number of firms per product
collapse (count) foretak, by(varenr sigma)
sort varenr
outfile varenr foretak sigma using "$savepath2/data_${year}_count_${thresh}thresh", comma wide replace


// Save weights as raw 
use "$savepath2/weights_${thresh}thresh_${year}", clear
reshape wide _b_verdi _b_vekt, i(iso2) j(varenr) string
drop _b_vekt*
outfile _b* using "$savepath2/weights_${thresh}thresh_${year}", comma wide replace

// Save weight & value per product as raw
use "$savepath2/weight_value_${thresh}thresh_${year}", clear
outfile _b* using "$savepath2/weight_value_${thresh}thresh_${year}", comma wide replace

// Save weight & value per product as raw - only SE
use "$savepath2/weight_value_SE_${thresh}thresh_${year}", clear
fillin varenr iso2 
keep if iso2=="SE"
outfile _b* using "$savepath2/weight_value_SE_${thresh}thresh_${year}", comma wide replace

// Save weight & unit per product as raw 
use "$savepath2/weight_qty_${thresh}thresh_${year}", clear
outfile _b* using "$savepath2/weight_qty_${thresh}thresh_${year}", comma wide replace

// Save weight & unit per product as raw - only SE
use "$savepath2/weight_qty_SE_${thresh}thresh_${year}", clear
outfile _b* using "$savepath2/weight_qty_SE_${thresh}thresh_${year}", comma wide replace
