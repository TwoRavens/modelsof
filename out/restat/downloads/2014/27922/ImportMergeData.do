//
// The Tip of the Iceberg: A Quantitative Framework for Estimating Trade Costs' 
//             by Irarrazabal, Moxnes and Opromolla (2014)

// ---------------------------------------------
// Descriptives before truncating the dataset.
// ---------------------------------------------
clear all

cd /Dropbox/RnD_KK/tradecost_replication/

global datapath "data"
global pennpath "$datapath/penn62_iso2_dist_small"
global tmppath "tmp"

//global oil = `"varenr=="27090000" | varenr=="27112100" | varenr=="27111100" | varenr=="27090009" | varenr=="27090001""'
//global unknown = 4980	// Firm 4980 is a dummy group for all unidentified firms
//global thresh = 40      // Number of firms that must be present in a destination (per product)
//global savepath = "C:\Users\andreamo\Documents\My Dropbox\Work\trade_costs"


// Preliminaries .........................................................

use "$datapath/moxnes_lopenr_2004", clear

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
rename obland iso2
label var qty "Quantities. Either kg or units"

// Unit values
gen price = verdi/qty

// Express value in mill NOK
replace verdi = verdi/1000000
label var verdi "Export value, mill NOK"

// Cut quantity >99 and <1 percentile within each destination-product
cumul qty, generate(cdf) by(varenr iso2)
//drop if cdf<.01 | cdf>.99

encode varenr, gen(varenr2)

// Add gravity variables
joinby iso2 year using "$datapath/penn62_iso2_dist_small", unmatched(none)

save "$tmppath/tmp_tc", replace

