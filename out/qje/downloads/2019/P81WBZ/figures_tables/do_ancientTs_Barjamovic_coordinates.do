// Retrieve T's from estimated alpha's using Barjamovic coordinates
clear

/*******************************/
// Load Barjamovic coordinates (robustness in Appendix table V)
// and calculate Ancient T's via ppml
/*******************************/
cd ..
import delimited "estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/main/report_table_twostepse.csv", encoding(ISO-8859-1)
cd "figures_tables"

keep long_x lat_y name
rename name anccity
save temp_baselinesamplecities,replace

clear
cd ..
import delimited "raw/itinerary_data/anccities_trade_iticount_for_inverse_gravity.csv", encoding(ISO-8859-1)
rename anccityid1 id_city
merge m:1 id_city using "raw/itinerary_data/39anccities.dta"
rename id_city anccityid1
rename anccity anccity1
keep if _merge==3
drop _merge
rename anccityid2 id_city
merge m:1 id_city using "raw/itinerary_data/39anccities.dta"
rename id_city anccityid2
rename anccity anccity2
keep if _merge==3
drop _merge
order anccityid1 anccityid2
sort anccityid1 anccityid2
drop if iticount==.

cd "figures_tables"
rename anccity1 anccity
merge m:1 anccity using temp_baselinesamplecities
keep if _merge==3
drop _merge
rename anccity anccity1
rename long_x long_x1 
rename lat_y lat_y1

rename anccity2 anccity
merge m:1 anccity using temp_baselinesamplecities
keep if _merge==3
drop _merge
rename anccity anccity2
rename long_x long_x2 
rename lat_y lat_y2

drop certainty*
sort anccityid1 anccityid2
order anccityid1 anccity1 anccityid2 anccity2 iticount long_x* lat_y*

gen dist = sqrt((cos(37.9/180*_pi)*(long_x2-long_x1))^2  + (lat_y2-lat_y1)^2)
replace dist = dist*10000/90

save temp_baselinesamplecities,replace


collapse (sum) iticount,by(anccity1)
rename anccity1 anccity
rename iticount exportmention
save exportmention,replace

use temp_baselinesamplecities,clear
collapse (sum) iticount,by(anccity2)
rename anccity2 anccity
rename iticount importmention
save importmention,replace

clear

/**************************************/
/* Estimate size with fixed locations */
/**************************************/
use temp_baselinesamplecities

sort anccity2
by anccity2: egen totimp = total(iticount)
gen tradeshare = iticount/totimp
drop totimp 


sort anccity2
qui tab anccity2,gen(impdum)

sort anccity1
qui tab anccity1,gen(expdum)

gen lndist = ln(dist)

ppml tradeshare expdum*  impdum* lndist, noconstant

forval i=1(1)25 {
  gen alfa`i' = _b[expdum`i']
}

gen sigma = _b[lndist]

collapse (mean) alfa* sigma,by(anccity1)
gen rank = _n
reshape long alfa,i(anccity1 rank sigma) j(rank2)
keep if rank==rank2
rename anccity1 anccity
drop rank*

save temp_ppml_barjamovic_location,replace

use temp_baselinesamplecities,clear
keep anccity1 anccity2 dist

fillin anccity1 anccity2
replace dist = 30 if _fillin==1
drop _fillin


rename anccity1 anccity
merge m:1 anccity using temp_ppml_barjamovic_location
rename alfa alpha_o
rename anccity anccity_o
drop _merge sigma

rename anccity2 anccity
merge m:1 anccity using temp_ppml_barjamovic_location
rename alfa alpha_d
rename anccity anccity_d
drop _merge

/****************/
/*Calculate size*/
/****************/
sort anccity_o anccity_d

gen theta = 4

gen Tsum_o = dist^(-sigma) * alpha_d  //*(1/numcity) //because we will sum over anccity_o below

collapse (sum) Tsum_o (mean) theta alpha_o , by(anccity_o)
 
gen T_anc =  ( alpha_o^(1+1/theta) * Tsum_o) // ^theta

rename anccity_o anccity
sort  anccity

keep anccity T_anc

// Normalize wrt Kanes
gen T_anc_norm = .
replace T_anc_norm = T_anc if anccity=="Kanes"
sort T_anc_norm
replace T_anc_norm = T_anc_norm[_n-1] if T_anc_norm==.
replace T_anc = 100* T_anc / T_anc_norm
sort anccity
drop T_anc_norm

//
erase temp_ppml_barjamovic_location.dta
erase temp_baselinesamplecities.dta
