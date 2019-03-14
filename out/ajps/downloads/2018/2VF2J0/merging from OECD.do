/*
Authors: Pardos-Prado & Xena (2018)

Purpose: Merging macro-variables with the ESS database

Instructions: first, we created a spreadsheet recording the years in which each round of the ESS survey was conducted, for each country.
We then used these years as the base years to merge with the ESS data. For those countries where the same wave of the ESS
was run over two different years, we take the average of the macro variables for that survey way, or if the macro variable isn't available
for both years, we impute using data from the other year in which the data was available.
Below, we illustrate this procedure for % of Foreign Born, GDP and Unemployment. 
*/

/* Get Years survey conducted, per round, per country */

insheet using ESSround_year.csv, names clear

replace r5 = "11_12" if country == "IRELAND"
gen millenium = "20"
gen comma = ","
forval i=1/6{
	gen under = strpos(r`i', "_")
	gen r`i'sub1 = substr(r`i', 1, 2) if under > 0
	egen r`i'y1 = concat(millenium r`i'sub1) if r`i'sub1 != ""
	gen r`i'sub2 = substr(r`i', under+1, 2) if under > 0
	egen r`i'y2 = concat(millenium r`i'sub2) if r`i'sub2 != ""
	replace r`i'y1 = r`i' if under == 0
	egen r`i'y =  concat(r`i'y1 comma r`i'y2) if r`i'y2 != ""
	replace r`i'y = r`i'y1 if r`i'y == ""
	replace r`i'y = "" if r`i'y == "-"
	drop under r`i'sub1 r`i'sub2 r`i'y1 r`i'y2
}
drop millenium comma
drop r1-r6
forval i = 1/6{
	rename r`i'y r`i'
}

reshape long r, i(country) j(round) string
rename r round_year
replace round_year = "" if country == "AUSTRIA" & round=="6"
gen multiple = 1
gen comma = strpos(round_year, ",")
replace multiple = 2 if comma > 0
expand multiple
bysort country round: gen dup = cond(_N==1, 0, _n)
replace round_year = substr(round_year, 1, 4) if dup == 1
replace round_year = substr(round_year, comma+1, 4) if dup == 2
drop comma dup multiple
destring round_year, replace
sort country round
list country round if round_year == .
drop if round_year == .
tab country

gen country_ess = "AT" if country == "AUSTRIA"
gen country_oecd = "AUS" if country == "AUSTRIA"
replace country_ess = "BE" if country == "BELGIUM"
replace country_oecd = "BEL" if country == "BELGIUM"
replace country_ess = "BG" if country == "BULGARIA"
replace country_oecd = "" if country == "BULGARIA"
replace country_ess = "HR" if country == "CROATIA"
replace country_oecd = "" if country == "CROATIA"
replace country_ess = "CY" if country == "CYPRUS"
replace country_oecd = "" if country == "CYPRUS"
replace country_ess = "CZ" if country == "CZECH REP" | country == "CZECH REPUBLIC"
replace country_oecd = "CZE" if country == "CZECH REP" | country == "CZECH REPUBLIC"
replace country_ess = "DK" if country == "DENMARK"
replace country_oecd = "DNK" if country == "DENMARK"
replace country_ess = "EE" if country == "ESTONIA"
replace country_oecd = "EST" if country == "ESTONIA"
replace country_ess = "FI" if country == "FINLAND"
replace country_oecd = "FIN" if country == "FINLAND"
replace country_ess = "FR" if country == "FRANCE"
replace country_oecd = "FRA" if country == "FRANCE"
replace country_ess = "DE" if country == "GERMANY"
replace country_oecd = "DEU" if country == "GERMANY"
replace country_ess = "GR" if country == "GREECE"
replace country_oecd = "GRC" if country == "GREECE"
replace country_ess = "HU" if country == "HUNGARY"
replace country_oecd = "HUN" if country == "HUNGARY"
replace country_ess = "IS" if country == "ICELAND"
replace country_oecd = "ISL" if country == "ICELAND"
replace country_ess = "IE" if country == "IRELAND"
replace country_oecd = "IRL" if country == "IRELAND"
replace country_ess = "IL" if country == "ISRAEL"
replace country_oecd = "ISR" if country == "ISRAEL"
replace country_ess = "IT" if country == "ITALY"
replace country_oecd = "ITA" if country == "ITALY"
replace country_ess = "XK" if country == "KOSOVO"
replace country_oecd = "" if country == "KOSOVO"
replace country_ess = "LV" if country == "LATVIA"
replace country_oecd = "" if country == "LATVIA"
replace country_ess = "LT" if country == "LITHUANIA"
replace country_oecd = "" if country == "LITHUANIA"
replace country_ess = "LU" if country == "LUXEMBOURG"
replace country_oecd = "LUX" if country == "LUXEMBOURG"
replace country_ess = "NL" if country == "NETHERLANDS"
replace country_oecd = "NLD" if country == "NETHERLANDS"
replace country_ess = "NO" if country == "NORWAY"
replace country_oecd = "NOR" if country == "NORWAY"
replace country_ess = "PL" if country == "POLAND"
replace country_oecd = "POL" if country == "POLAND"
replace country_ess = "PT" if country == "PORTUGAL"
replace country_oecd = "PRT" if country == "PORTUGAL"
replace country_ess = "RO" if country == "ROMANIA"
replace country_oecd = "" if country == "ROMANIA"
replace country_ess = "RU" if country == "RUSSIAN FED" | country == "RUSSIAN FEDERATION" 
replace country_oecd = "" if country == "RUSSIAN FED" | country == "RUSSIAN FEDERATION" 
replace country_ess = "SK" if country == "SLOVAKIA"
replace country_oecd = "SVK" if country == "SLOVAKIA"
replace country_ess = "SI" if country == "SLOVENIA"
replace country_oecd = "SLOVENIA" if country == "SLOVENIA"
replace country_ess = "ES" if country == "SPAIN"
replace country_oecd = "ESP" if country == "SPAIN"
replace country_ess = "SE" if country == "SWEDEN"
replace country_oecd = "SWE" if country == "SWEDEN"
replace country_ess = "CH" if country == "SWITZERLAND"
replace country_oecd = "CHE" if country == "SWITZERLAND"
replace country_ess = "GB" if country == "UK" | country == "UNITED KINGDOM"
replace country_oecd = "GBR" if country == "UK" | country == "UNITED KINGDOM"
replace country_ess = "UA" if country == "UKRAINE"
replace country_oecd = "" if country == "UKRAINE"
saveold macro1_new.dta, replace


/* % of foreign born (source: OECD) */

insheet using foreignborn.csv, names clear
drop if v1=="AUT"
rename v1 country_oecd
rename time year
rename value foreign
sort country_oecd year
label var foreign "% foreign born"
saveold foreign.dta, replace

/* Merge foreign born with macro dataset */
use macro1.dta, clear
gen year = round_year
bysort country_oecd year: gen dup = cond(_N == 1, 0, _n)
** From dup variable, rule is m:1
drop dup
sort country_oecd year
merge m:1 country_oecd year using foreign.dta
** _merge = 1 --> ESS round exists, but no foreign data;
** _merge = 2 --> ESS round does not exist, but foreign does;
** _merge = 3 --> ESS && Macrodata exist
drop if _merge == 2 // drop foreign born if there is no matched ESS round.
drop _merge
// Impute foreign data if round is the same but one composing year is missing //
sort country round foreign
bysort country round: carryforward foreign, replace
saveold macro2.dta, replace



/* Import unemployment and gdp variables (source: OECD) */

global filelist "unemployment gdp"
foreach file in $filelist{
	insheet using `file'.csv, names clear
	replace countryname = upper(countryname)
	reshape long y, i(countryname) j(year)
	rename countryname country
	rename y `file'
	sort country year
	gen country_ess = "AT" if country == "AUSTRIA"
	gen country_oecd = "AUS" if country == "AUSTRIA"
	replace country_ess = "BE" if country == "BELGIUM"
	replace country_oecd = "BEL" if country == "BELGIUM"
	replace country_ess = "BG" if country == "BULGARIA"
	replace country_oecd = "" if country == "BULGARIA"
	replace country_ess = "HR" if country == "CROATIA"
	replace country_oecd = "" if country == "CROATIA"
	replace country_ess = "CY" if country == "CYPRUS"
	replace country_oecd = "" if country == "CYPRUS"
	replace country_ess = "CZ" if country == "CZECH REP" | country == "CZECH REPUBLIC"
	replace country_oecd = "CZE" if country == "CZECH REP" | country == "CZECH REPUBLIC"
	replace country_ess = "DK" if country == "DENMARK"
	replace country_oecd = "DNK" if country == "DENMARK"
	replace country_ess = "EE" if country == "ESTONIA"
	replace country_oecd = "EST" if country == "ESTONIA"
	replace country_ess = "FI" if country == "FINLAND"
	replace country_oecd = "FIN" if country == "FINLAND"
	replace country_ess = "FR" if country == "FRANCE"
	replace country_oecd = "FRA" if country == "FRANCE"
	replace country_ess = "DE" if country == "GERMANY"
	replace country_oecd = "DEU" if country == "GERMANY"
	replace country_ess = "GR" if country == "GREECE"
	replace country_oecd = "GRC" if country == "GREECE"
	replace country_ess = "HU" if country == "HUNGARY"
	replace country_oecd = "HUN" if country == "HUNGARY"
	replace country_ess = "IS" if country == "ICELAND"
	replace country_oecd = "ISL" if country == "ICELAND"
	replace country_ess = "IE" if country == "IRELAND"
	replace country_oecd = "IRL" if country == "IRELAND"
	replace country_ess = "IL" if country == "ISRAEL"
	replace country_oecd = "ISR" if country == "ISRAEL"
	replace country_ess = "IT" if country == "ITALY"
	replace country_oecd = "ITA" if country == "ITALY"
	replace country_ess = "XK" if country == "KOSOVO"
	replace country_oecd = "" if country == "KOSOVO"
	replace country_ess = "LV" if country == "LATVIA"
	replace country_oecd = "" if country == "LATVIA"
	replace country_ess = "LT" if country == "LITHUANIA"
	replace country_oecd = "" if country == "LITHUANIA"
	replace country_ess = "LU" if country == "LUXEMBOURG"
	replace country_oecd = "LUX" if country == "LUXEMBOURG"
	replace country_ess = "NL" if country == "NETHERLANDS"
	replace country_oecd = "NLD" if country == "NETHERLANDS"
	replace country_ess = "NO" if country == "NORWAY"
	replace country_oecd = "NOR" if country == "NORWAY"
	replace country_ess = "PL" if country == "POLAND"
	replace country_oecd = "POL" if country == "POLAND"
	replace country_ess = "PT" if country == "PORTUGAL"
	replace country_oecd = "PRT" if country == "PORTUGAL"
	replace country_ess = "RO" if country == "ROMANIA"
	replace country_oecd = "" if country == "ROMANIA"
	replace country_ess = "RU" if country == "RUSSIAN FED" | country == "RUSSIAN FEDERATION" 
	replace country_oecd = "" if country == "RUSSIAN FED" | country == "RUSSIAN FEDERATION" 
	replace country_ess = "SK" if country == "SLOVAKIA" | country == "SLOVAK REPUBLIC"
	replace country_oecd = "SVK" if country == "SLOVAKIA" | country == "SLOVAK REPUBLIC"
	replace country_ess = "SI" if country == "SLOVENIA"
	replace country_oecd = "SLOVENIA" if country == "SLOVENIA"
	replace country_ess = "ES" if country == "SPAIN"
	replace country_oecd = "ESP" if country == "SPAIN"
	replace country_ess = "SE" if country == "SWEDEN"
	replace country_oecd = "SWE" if country == "SWEDEN"
	replace country_ess = "CH" if country == "SWITZERLAND"
	replace country_oecd = "CHE" if country == "SWITZERLAND"
	replace country_ess = "GB" if country == "UK" | country == "UNITED KINGDOM"
	replace country_oecd = "GBR" if country == "UK" | country == "UNITED KINGDOM"
	replace country_ess = "UA" if country == "UKRAINE"
	replace country_oecd = "" if country == "UKRAINE"
	saveold `file'.dta, replace
}

use unemployment.dta, clear
sort country year
merge 1:1 country year using gdp.dta
drop _merge
di _N // 408
sort country_ess year
codebook country_ess // no missings
bysort country_ess year: gen dup = cond(_N==1, 0, _n)
drop dup // no duplicates
saveold gdp_unemployment.dta, replace

/* Merge unemployment_gdp with macro2 */
use macro2.dta, clear
bysort country_ess year: gen dup = cond(_N==1, 0, _n)
drop dup // there are duplicates for Ireland;
sort country_ess year
merge m:1 country_ess year using gdp_unemployment.dta
tab year if _merge==2 // all irrelevant data
drop if _merge != 3
codebook gdp unemployment
saveold macro3.dta, replace


/* Collapse for merging with ESS main data file */
use macro3.dta, clear
/* Austria round 4:
di (26.6+26.9)/2 // Foreign born
di (4.4+4.1)/2 // unem
di (46659.84+51123.56)/2 // gdp
*/
collapse (mean) foreign gdp unemployment, by(country_ess round)
list foreign if country_ess == "AT" & round == "4" // 26.75
list unemployment if country_ess == "AT" & round == "4" // 4.25
list gdp if country_ess == "AT" & round == "4" // 48891.7
bysort country_ess round: gen dup = cond(_N==1, 0, _n)
assert dup == 0
drop dup
sort country_ess round
saveold macrovars.dta, replace


/*Final merge macro & main ESS dataset*/
use essdata.dta, clear
rename cntry country_ess
tostring essround, gen(round)
sort country_ess round
merge m:1 country_ess round using macrovars.dta
br if _merge==2
drop _merge
saveold essdata_macrovariables.dta, replace

