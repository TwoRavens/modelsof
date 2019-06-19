//
// Two-sided Heterogeneity and Trade: Descriptive tables
// 

/* Explanatory notes:
 $dfile consists of seller-buyer-country-product-year observations
 impeks=1: imports, impeks=2: exports.
 value=trade flow in current NOK
 abland=destination country
 foretak=firm id, custid=customer id */

// ------------------------------------------------------------------
// TABLE 1 : The Margins of Trade
// ------------------------------------------------------------------

// Number of products per destination-year 
use $wdata/$dfile, clear
collapse (sum) value,by(abland year hs96)
collapse (count) p=hs96,by(abland year)
sort abland year
save $tmp/p,replace

// Number of firms per destination-year, f
use $wdata/$dfile, clear
collapse (sum) value,by(abland year foretak)
collapse (count) f=foretak,by(abland year)
sort abland year
save $tmp/f,replace

// Number of customers per destination-year, c
use $wdata/$dfile, clear
collapse (sum) value,by(abland year custid)
collapse (count) c=custid,by(abland year)
sort abland year
save $tmp/c,replace

// Number of firm-product-customers for each destination-year, d
use $wdata/$dfile, clear
collapse (sum) value,by(abland year foretak hs6 custid)
collapse (count) d=value,by(abland year)
sort abland year
save $tmp/d,replace

// Merge everything
use $wdata/$dfile, clear
sort abland year
merge abland year using $tmp/p
tab _merge
drop _merge
sort abland year
merge abland year using $tmp/f
tab _merge
drop _merge
sort abland year
merge abland year using $tmp/c
tab _merge
drop _merge
sort abland year
merge abland year using $tmp/d
tab _merge
drop _merge
collapse (sum) value (mean) p f c d, by(abland year)
// Total exports for each destination-year, as well as #firms, #customers, etc.

gen lnp = ln(p)
gen lnf = ln(f)
gen lnc = ln(c)
gen lnd = ln(d/(p*f*c))
gen lnxbar = ln(value/d)
gen lnvalue = ln(value)
label var lnvalue "Exports (log)"

// Regressions
global y 2006
reg lnp lnvalue if year==$y
reg lnf lnvalue if year==$y
reg lnc lnvalue if year==$y
reg lnd lnvalue if year==$y
reg lnxbar lnvalue if year==$y


// ------------------------------------------------------------------
// TABLE 2 : Within-Firm Gravity
// ------------------------------------------------------------------
use "$wdata/$dfile", clear
collapse (sum) value, by(foretak abland custid year) 
collapse (sum) value (count) custid, by(foretak abland year)

gen lnEx = log(value)
gen lnEx_cust = log(value/custid) // Average export value per customer, for every product
gen lnCust = log(custid)

keep if year==2006
replace year=2004 if year==2006

rename abland iso2
joinby iso2 year using "$wdata/penn_6_2_full_iso2_dist", unmatched(none)
gen lndist= log(dist)
gen lnGdp = log(cgdp*pop)
gen lnGdpCap = log(cgdp)

xtreg lnEx lndist lnGdp, fe i(foretak) vce(cluster foretak)
xtreg lnCust lndist lnGdp, fe i(foretak) vce(cluster foretak)
xtreg lnEx_cust lndist lnGdp, fe i(foretak) vce(cluster foretak)

// --------------------------------------------------
// TABLE 3 : Types of Matches between Exporters and Importers.
// --------------------------------------------------

use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(foretak abland year custid)
egen num_cust = count(custid), by(foretak abland year)
egen num_ex = count(foretak), by(custid abland year)
gen MCU = num_cust>1
gen MEX = num_ex>1
collapse (sum) value (count) pairs=foretak, by(year MCU MEX)
egen totv = total(value), by(year)
egen totp = total(pairs), by(year)
gen shv = value/totv
gen shp = pairs/totp
list


// ---------------------------------------
// Table 9: Top exported Products by Number of Exporters and Value
// ---------------------------------------

use $wdata/$dfile, clear
keep if year==2006
collapse (sum) value, by(foretak year hs96)
collapse (sum) value (count) foretak, by(year hs96)
gsort -value
gsort -foretak

// ------------------------------------------------------------------
// TABLE 10: Descriptive statistics
// ------------------------------------------------------------------


global OECD `"gen OECD=abland=="AU" | abland=="AT" | abland=="BE" | abland=="CA" | abland=="CL" | abland=="CZ" | abland=="DK" | abland=="FI" | abland=="FR" | abland=="DE" | abland=="GR" | abland=="HU" | abland=="IS" | abland=="IR" | abland=="IT" | abland=="JP" | abland=="KR" | abland=="LX" | abland=="MX" | abland=="NL" | abland=="NZ" | abland=="PL" | abland=="PT" | abland=="SL" | abland=="ES" | abland=="SE" | abland=="TR" | abland=="GB" | abland=="US" "'
global cty `"(abland=="SE" | abland=="US" | abland=="DE" | abland=="CN" | abland=="JP"  | abland=="ES" ) "'

//
// Share of total exports in each market
//
use $wdata/$dfile, clear
keep if impeks==2
collapse (sum) value, by(abland year)
egen totval = total(value), by(year)
gen share = value/totval
list abland share if $cty & year==2006
$OECD
collapse (sum) share, by(year OECD)
list if year==2006

//
// # buyers and sellers in each market
//
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
egen num_ex=tag(foretak abland year)
egen num_cust=tag(custid abland year)
collapse (sum) num_ex num_cust value, by(abland year)
label var num_ex "# exporters per market"
label var num_ex "# customers per market"
list if $cty & year==2006
$OECD
collapse (mean) num*, by(year OECD)
list if year==2006

// Average across all countries
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
egen num_ex=tag(foretak abland year)
egen num_cust=tag(custid abland year)
collapse (sum) num_ex num_cust value, by(abland year)
label var num_ex "# exporters per market"
label var num_ex "# customers per market"
collapse (mean) num*, by(year)
list if year==2006

// Overall
use $wdata/$dfile, clear
collapse (sum) value, by(foretak year abland custid)
egen num_ex=tag(foretak year)
egen num_cust=tag(custid abland year)
collapse (sum) num_ex num_cust value, by(year)
label var num_ex "# exporters"
label var num_ex "# customers"
list

//
// Mean buyers per exporter, and mean exporters per buyer
//
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) custid, by(foretak abland year)
collapse (mean) custid (median) mcustid=custid, by(abland year)
label var custid "# Buyers per exporter, mean"
label var mcustid "# Buyers per exporter, median"
list if $cty & year==2006
$OECD
collapse (mean) cust* mcust*, by(year OECD)
list if year==2006

// Average across all countries
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) custid, by(foretak abland year)
collapse (mean) custid (median) mcustid=custid, by(abland year)
collapse (mean) cust* mcust*, by(year)
list if year==2006

use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) foretak, by(custid abland year)
collapse (mean) foretak (median) mforetak=foretak, by(abland year)
label var foretak "# Exporters per buyer, mean"
label var mforetak "# Exporters per buyer, median"
list if $cty & year==2006
$OECD
collapse (mean) for* mfor*, by(year OECD)
list if year==2006

// Average across all countries
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) foretak, by(custid abland year)
collapse (mean) foretak (median) mforetak=foretak, by(abland year)
collapse (mean) for* mfor*, by(year)
list if year==2006

//
// Mean buyers per exporter, and mean exporters per buyer, unconditional on country
//
use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) custid, by(foretak abland year)
collapse (mean) custid (median) mcustid=custid, by(year)
label var custid "# Buyers per exporter, mean"
label var mcustid "# Buyers per exporter, median"
list 

use $wdata/$dfile, clear
collapse (sum) value, by(foretak abland year custid)
collapse (count) foretak, by(custid abland year)
collapse (mean) foretak (median) mforetak=foretak, by(year)
label var foretak "# Exporters per buyer, mean"
label var mforetak "# Exporters per buyer, median"
list

//
// Share NO exports by 10% largest exporters
//

use "$wdata/$dfile", clear
collapse (sum) value, by(foretak year abland)
bys year abland: cumul value, gen (cdf)
gen top10 = cdf>=.90
collapse (sum) value, by(top10 year abland)
bys year abland: egen totex = total(value)
gen share = value/totex
keep if top10==1
list if $cty & year==2006
$OECD
collapse (mean) share, by(year OECD)
list if year==2006

// Average across all countries
use "$wdata/$dfile", clear
collapse (sum) value, by(foretak year abland)
bys year abland: cumul value, gen (cdf)
gen top10 = cdf>=.90
collapse (sum) value, by(top10 year abland)
bys year abland: egen totex = total(value)
gen share = value/totex
keep if top10==1
collapse (mean) share, by(year)
list if year==2006

//
// Share NO exports by 10% largest buyers
//

use "$wdata/$dfile", clear
collapse (sum) value, by(custid year abland)
bys year abland: cumul value, gen (cdf)
gen top10 = cdf>=.90
collapse (sum) value, by(top10 year abland)
bys year abland: egen totex = total(value)
gen share = value/totex
keep if top10==1
list if $cty & year==2006
$OECD
collapse (mean) share, by(year OECD)
list if year==2006

// Average across all countries
use "$wdata/$dfile", clear
collapse (sum) value, by(custid year abland)
bys year abland: cumul value, gen (cdf)
gen top10 = cdf>=.90
collapse (sum) value, by(top10 year abland)
bys year abland: egen totex = total(value)
gen share = value/totex
keep if top10==1
collapse (mean) share, by(year)
list if year==2006

// 
// Share NO exports by 10% largest exporters, unconditional on country
//

use "$wdata/$dfile", clear
collapse (sum) value, by(foretak year abland)
bys year abland: cumul value, gen (cdf)
gen top10 = cdf>=.90
collapse (sum) value, by(top10 year)
bys year: egen totex = total(value)
gen share = value/totex
keep if top10==1
list if year==2006

use "$wdata/$dfile", clear
collapse (sum) value, by(custid year)
bys year: cumul value, gen (cdf)
gen top10 = cdf>=.90
collapse (sum) value, by(top10 year)
bys year: egen totex = total(value)
gen share = value/totex
keep if top10==1
list if year==2006

//
// Dispersion in exports
//
use "$wdata/$dfile", clear
collapse (sum) value, by(foretak year abland)
gen lnv = log(value)
gen v = value
collapse (max) max=v (p90) p90=v (p50) p50=v (p10) p10=v (sd) v, by(year abland)
gen p9010 = log(p90/p10)
gen m50 = log(max/p50)
list abland m50 p9010 v if $cty & year==2006
$OECD
collapse (mean) p* m50 v, by(year OECD)
list if year==2006

// Average across countries
use "$wdata/$dfile", clear
collapse (sum) value, by(foretak year abland)
gen lnv = log(value)
gen v = value
collapse (max) max=v (p90) p90=v (p50) p50=v (p10) p10=v (sd) v, by(year abland)
gen p9010 = log(p90/p10)
gen m50 = log(max/p50)
collapse (mean) p* m50 v, by(year)
list if year==2006

//
// Dispersion in imports
//
use "$wdata/$dfile", clear
collapse (sum) value, by(custid year abland)
gen lnv = log(value)
gen v = value
collapse (max) max=v (p90) p90=v (p50) p50=v (p10) p10=v (sd) v, by(year abland)
gen p9010 = log(p90/p10)
gen m50 = log(max/p50)
list abland m50 p9010 v if $cty & year==2006
$OECD
collapse (mean) p* m50 v, by(year OECD)
list if year==2006

// Average across countries
use "$wdata/$dfile", clear
collapse (sum) value, by(custid year abland)
gen lnv = log(value)
gen v = value
collapse (max) max=v (p90) p90=v (p50) p50=v (p10) p10=v (sd) v, by(year abland)
gen p9010 = log(p90/p10)
gen m50 = log(max/p50)
collapse (mean) p* m50 v, by(year)
list if year==2006

//
// Dispersion in exports/imports, unconditional on country
//
use "$wdata/$dfile", clear
collapse (sum) value, by(foretak year)
gen lnv = log(value)
gen v = value
collapse (max) max=v (p90) p90=v (p50) p50=v (p10) p10=v (sd) v, by(year)
gen p9010 = log(p90/p10)
gen m50 = log(max/p50)
list year m50 p9010 v 

use "$wdata/$dfile", clear
collapse (sum) value, by(custid year)
gen lnv = log(value)
gen v = value
collapse (max) max=v (p90) p90=v (p50) p50=v (p10) p10=v (sd) v, by(year)
gen p9010 = log(p90/p10)
gen m50 = log(max/p50)
list year m50 p9010 v 


* ---------------------------------------------------
* Table 11: Correlation Matrix
* ---------------------------------------------------

clear
use cepii/GeoDist/dist_cepii, clear
keep if iso_o=="NOR"
drop iso_o
rename iso_d iso3
merge 1:1 iso3 using ssb/iso_codes.dta, keep(match master) keepusing(iso2)
drop if _merge==1
drop _merge
save /tmp/tmpdistNO, replace

use $path/Orbis/dispersion_emp_50_50+.dta, clear
keep if nfirm>1000
rename countryisocode iso2
gen year=2006
merge 1:n iso2 year using Penn/pwt90/pwt90_iso2, keep(match master)
drop _merge
merge 1:1 iso2 using /tmp/tmpdistNO, keep(match master)
drop _merge
gen lngdpcap = log(cgdpe/pop)
gen lnpop = log(pop)
gen lngdp = log(cgdpe)
gen lndist = log(dist)
pwcorr pareto pratio lngdpcap lnpop lngdp lndist, sig star(.05)


// -------------------------------------------------
// Table 12: Decomposition of Aggregate Imports
// -------------------------------------------------

* Preliminaries
use $wdata/$dfile, clear
collapse (sum) value, by(foretak custid abland year)
merge m:1 foretak year using capitaldb, keepusing(drinnt prodinnsats)
drop if _merge==1 // outside manufacturing
drop if _merge==2 // Non-importers
drop _merge
save /tmp/tmp, replace


// Year-by-year
local j = 2009
//while `j'<=2009 {  // big while loop
local i = `j'+1
use /tmp/tmp, clear
keep if year==`j' | year==`i'

// categorize firms in "continuing", "exiting" and "entering"
sort foretak year
gen cont_firm = foretak[_n]==foretak[_n-1] & year[_n]==`i' & year[_n-1]==`j'  /* continuing firm */
egen e_cont_firm =max(cont_firm), by(foretak) /* so we set cont=1 in all years */
drop cont_firm
sort foretak year
gen exit_firm = e_cont_firm==0 & year==`j' /* exiting firm */
gen ent_firm = e_cont_firm==0 & year==`i' /* entering firm */
// Note: exit=1 if present in t-1 but not t, entry=1 if present in t but not t-1,
// cont=1 in t-1 if present in both t-1 and t, cont=1 in t if present in t-1 and t.
gen firm_cat = 1 if  ent_firm==1
replace firm_cat=2 if  exit_firm==1
replace firm_cat=3 if  e_cont_firm==1
label define firm_cat 1 "entering firm" 2 "exiting firm" 3 "continuing firm" 
label values firm_cat firm_cat
label var firm_cat "type of firm"

// categorize country-products in "added", "dropped" and "continuing", for "continuing" firms only
sort foretak abland year
gen cont_copr = firm_cat==3 & foretak[_n]==foretak[_n-1] & abland[_n]==abland[_n-1] & year[_n]==`i' & year[_n-1]==`j' /* at the firm level, country-product active both in `j' and in `i' by a continuing firm */
egen e_cont_copr =max(cont_copr), by(foretak abland)
drop cont_copr
sort foretak abland year
gen exit_copr = firm_cat==3 & e_cont_copr==0 & year==`j' /* at the firm level, country-product active in `j' but not in `i' */
gen ent_copr = firm_cat==3 & e_cont_copr==0 & year==`i' /* at the firm level, country-product active in `i' but not in `j' */
gen copr_cat = 4 if  ent_copr==1
replace copr_cat=5 if  exit_copr==1
replace copr_cat=6 if  e_cont_copr==1
label define copr_cat 4 "entering copr" 5 "exiting copr" 6 "continuing copr" 
label values copr_cat copr_cat
label var copr_cat "type of copr"
drop  e_cont_copr exit_copr ent_copr

// categorize country-product-customer relationships as "added", "dropped" and "continuing" within "continuing" country-product relationships of "continuing" firms
sort foretak abland custid year
gen cont_coprcu = firm_cat==3 & foretak[_n]==foretak[_n-1] & abland[_n]==abland[_n-1] & custid[_n]==custid[_n-1] & year[_n]==`i' & year[_n-1]==`j' /* at the firm level, country-product-customer active both in `j' and in `i' for a continuing country-product for a continuing firm*/
egen e_cont_coprcu =max(cont_coprcu),by(foretak abland custid)
drop cont_coprcu
sort foretak abland custid year
gen exit_coprcu = firm_cat==3 & e_cont_coprcu==0 & year==`j' /* at the firm level, country-product-customer active in `j' but not in `i', in a continuing country-product */
gen ent_coprcu = firm_cat==3  & e_cont_coprcu==0 & year==`i' /* at the firm level, country-product-customer active in `i' but not in `j', in a continuing country-product */

gen coprcu_cat = 7 if  ent_coprcu==1
replace coprcu_cat=8 if  exit_coprcu==1
replace coprcu_cat=9 if  e_cont_coprcu==1
label define coprcu_cat 7 "added coprcu" 8 "dropped coprcu" 9 "continuing coprcu" 
label values coprcu_cat coprcu_cat
label var coprcu_cat "type of country-product-customer"
drop  e_cont_coprcu exit_coprcu ent_coprcu

// Decompose
collapse (sum) value, by(year firm_cat coprcu_cat)
egen export_bef = sum(value) if year==`j'
egen export_aft = sum(value) if year==`i'
egen export_t_1 = max(export_bef)
egen export_t = max(export_aft)
drop export_bef export_aft
label var export_t_1 "export in t-1"
label var export_t "export in t"
replace value = value/(export_t_1) /* percentage terms */
drop export_t_1 export_t
recode  coprcu_cat (.=0)
reshape wide value, i(firm_cat coprcu_cat) j(year)
recode  value* (.=0)
gen exit_firm =  value`i' - value`j' if firm_cat==2
gen ent_firm =  value`i' - value`j' if firm_cat==1
gen cont_firm =  value`i' - value`j' if firm_cat==3
gen exit_coprcu =  value`i' - value`j' if firm_cat==3 & coprcu_cat==8	// country-prod-cust
gen ent_coprcu =  value`i' - value`j' if firm_cat==3  & coprcu_cat==7	// country-prod-cust
gen cont_coprcu =  value`i' - value`j' if firm_cat==3 & coprcu_cat==9
gen agg = value`i' - value`j'
gen var = 1
collapse (sum) agg exit* ent* cont*,by(var)  /* decomposition by firm */
drop var
gen final_yr = `i'
l agg ent_firm exit_firm cont_firm final_yr
l ent_coprcu exit_coprcu cont_coprcu final_yr

