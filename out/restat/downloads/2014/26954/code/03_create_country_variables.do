/* 
The programs and data files replicate the descriptive statistics and the estimation results in the paper

	Hornok, Cec’lia and Mikl—s Koren, forthcoming. ÒPer-Shipment Costs and the Lumpiness of International Trade.Ó Review of Economics and Statistics.

Please cite the above paper when using these programs.

For your convenience, we reproduce some of the data resources here. Although all of these are widely available macroeconomic data, please check with the data vendors whether you have the right to use them.

Our software and data are provided AS IS, and we assume no liability for their use or misuse. 

If you have any questions about replication, please contact Mikl—s Koren at korenm@ceu.hu.
*/

*** Converts the various datasets into Stata format and merges them. The output is data/derived/merged_importer_data.dta.

clear
tempfile countries country_list_wb

* country codes
clear
insheet using data/own/country_list.csv
save `country_list_wb', replace
* read census numerical codes
clear
infix census_code 1-4 str iso2 69-70 using data/census/country.txt in 6/246
saveold data/census/country_list, replace

* read unilateral vars from CEPII
clear
use data/cepii/geo_cepii.dta
keep iso2 iso3 country landlocked
ren country country_name
duplicates drop
save `countries', replace


* read bilateral vars from CEPII
clear
use data/cepii/dist_cepii.dta
keep if iso_o=="USA" | iso_o=="ESP"
ren iso_o exporter
ren iso_d iso3
keep exporter iso3 comlang_off col45 distwces
merge m:1 iso3 using `countries'
drop _m
keep if !missing(exporter)
save `countries', replace

merge m:1 iso2 using data/census/country_list
drop _m
keep if !missing(iso3) & !missing(exporter)
save `countries', replace

* island dummy
clear
insheet using data/wikipedia/island.csv, comma case
merge 1:m iso2 using `countries'
drop _m country
keep if !missing(iso3) & !missing(exporter)
save `countries', replace


* GDP
use data/worldbank/ny.gdp.mktp.cd.dta, clear
ren ny_gdp gdp
ren countrycode iso3
replace iso3 = "ZAR" if iso3=="COD" /* different coding for Congo-Kinshasa, Romania, Timor-Leste */
replace iso3 = "ROM" if iso3=="ROU"
replace iso3 = "TMP" if iso3=="TLS"
merge 1:m iso3 using `countries', keep(match using)
drop _m
save `countries', replace


* GDP per capita
use data/worldbank/ny.gdp.pcap.cd.dta, clear
ren ny_gdp gdppc
ren countrycode iso3
replace iso3 = "ZAR" if iso3=="COD" /* different coding for Congo-Kinshasa, Romania, Timor-Leste */
replace iso3 = "ROM" if iso3=="ROU"
replace iso3 = "TMP" if iso3=="TLS"
merge 1:m iso3 using `countries', keep(match using)
drop _m
save `countries', replace


* Doing Business indicators
merge m:1 iso3 using  data/worldbank/doingbusiness/trading_across_borders_2009, keepusing(*_import)
drop _m
save `countries', replace

* free trade agreements
clear
import excel using data/bergstrand/EIA2013.xlsx, firstrow sheet("Data Sheet")
keep Exporter Importer IDIM BL
ren Exporter exporter
ren Importer importer
ren IDIM bergstrand_id

keep if exporter=="USA" | exporter=="Spain"
replace exporter="ESP" if exporter=="Spain"
drop if BL=="NoCty"
destring BL, replace
ren BL eia

* correspondence to iso codes
merge m:m bergstrand_id using `country_list_wb', keepusing(iso3)
drop _m importer 
drop if missing(exporter,iso3)

* define FTA dummy
gen byte fta = (eia>2)
merge 1:1 exporter iso3 using `countries'
drop _m eia
save `countries', replace


* adjust fta and pta to 2009 situation (year is entry into force)
replace fta = 1 if exp=="USA" & iso3=="DOM"  /* USA - Dominican Republic, 2007 */
replace fta = 1 if exp=="USA" & iso3=="CRI"  /* USA - Costa Rica, Jan 2009 */
replace fta = 1 if exp=="USA" & iso3=="SLV"  /* USA - El Salvador, 2006 */
replace fta = 1 if exp=="USA" & iso3=="GTM"  /* USA - Guatemala, 2006 */
replace fta = 1 if exp=="USA" & iso3=="HND"  /* USA - Honduras, 2006 */
replace fta = 1 if exp=="USA" & iso3=="NIC"  /* USA - Nicaragua, 2006 */
replace fta = 1 if exp=="USA" & iso3=="BHR"  /* USA - Bahrain, 2006 */
replace fta = 1 if exp=="USA" & iso3=="MAR"  /* USA - Morocco, 2006 */
replace fta = 1 if exp=="USA" & iso3=="OMN"  /* USA - Oman, Jan 2009 */
replace fta = 1 if exp=="USA" & iso3=="PER"  /* USA - Peru, Feb 2009 */
replace fta = 1 if exp=="ESP" & iso3=="ALB"  /* EC - Albania, 2006 */
replace fta = 1 if exp=="ESP" & iso3=="BIH"  /* EC - Bosnia and Herzegovina, 2008 */
table fta


* create variables
ren total_time_import day
gen lcost = ln(total_cost_import)
gen adminday = document_time_import + customs_time_import
gen transitday = port_time_import + inland_time_import
gen ladmincost = ln(document_cost_import + customs_cost_import)
gen ltransitcost = ln(port_cost_import +  inland_cost_import)
drop *_import

foreach X of var gdp gdppc distwces {
	gen l`X' = ln(`X') 
}
drop gdp gdppc distwces


* label variables
lab var exporter "Exporter USA or Spain"
lab var census_code "US Census country code"
lab var island "Importer is island"
lab var lcost "Ln monetary cost"
lab var adminday "Days to documents and customs"
lab var transitday "Days to port and transit"
lab var ladmincost "Ln monetary cost to doc and customs"
lab var ltransitcost "Ln monetary cost to port and transit"
lab var lgdp "Ln nominal GDP"
lab var lgdppc "Ln GDP per capita"
lab var ldistwces "Ln distance (pop-weight, ces)"
lab var fta "Free trade agreement"

drop if missing(exporter)

compress
saveold data/derived/merged_importer_data, replace
