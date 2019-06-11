/* This do-file calculates miscellaneous statistics that are presented throughout the paper
for Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 

***Preamble***

capture log close
*Set log
log using "${log_dir}miscnumbers.log", replace

*Reset output variables
scalar drop _all

***** STATS REPORTED IN INTRODUCTION ******

***Get sales shares of Japan for digestive diseases and other diseases***
use "${intersavedir}clean_sales_raw_sq.dta", clear

* U116 - peptic ulcer disease
* U119 - other digestive diseases

* calculate all sales in U119, U116
egen sales_digestive = total(sales_mnf_usd) if ( gbd_code == "U116" | gbd_code == "U119" )

* calculate exports by Japan in U119, U116
egen exports_Japan_digestive = total(sales_mnf_usd) if ( gbd_code == "U116" | gbd_code == "U119" ) & sales_ctry == "JAPAN" & dest_ctry != "JAPAN"

* calculate share of Japanese exports in digestive diseases
gen share_Japan_digestive = exports_Japan_digestive/sales_digestive

* calculate all sales
egen sales_total = total(sales_mnf_usd)

* all exports by Japan
egen exports_Japan = total(sales_mnf_usd) if sales_ctry == "JAPAN" & dest_ctry != "JAPAN"

* all sales without digestive diseases
gen sales_not_digestive = sales_total - sales_digestive

* exports by Japan without digestive diseases
gen exports_Japan_not_digestive = exports_Japan - exports_Japan_digestive

* share of Japanese sales in non-digestive diseases
gen share_Japan_not_digestive = exports_Japan_not_digestive/sales_not_digestive

*collapse for output
collapse (mean) share_Japan_digestive share_Japan_not_digestive

scalar JapanDigestiveSalesPct = round(share_Japan_digestive[1]*100, 0.01)
scalar JapanNonDigestiveSalesPct = round(share_Japan_not_digestive[1]*100, 0.01)



***Get data on deaths for Japan in digestive disorders***
use "${intersavedir}us_census_popXwho_gbd.dta", clear

*Only keep relevant gbd codes
drop if gbd_2012 != "W116" & gbd_2012 != "W119"

bysort country: egen deaths_country = total(deaths)
bysort country gbd_code: egen pop_country_gbd = total(pop_who)

* create aggregates in gbd cell
egen deaths_gbd = total(deaths)
bysort gbd_code: egen pop_gbd = total(pop_who)

* calculate deaths per 1000 people in a country
gen deaths_p1000 = (deaths_country/pop_country_gbd)*1000000

* calculate deaths per 1000 people in all other countries
gen deaths_p1000_out = ((deaths_gbd - deaths_country)/(pop_gbd - pop_country_gbd))*1000000

* create output:
sort country gbd_code
drop if country != "Japan"

scalar JapanDigestiveDeaths = round(deaths_p1000[1], 0.001)
scalar AvgDigestiveDeaths = round(deaths_p1000_out[1], 0.001)


******** STATISTICS REPORTED IN SECTION 4 **********

***Get identified firm sales as share of total firm sales in IMS MIDAS***
use "${intersavedir}sales_raw.dta", clear

*create total sales
egen all_midas_sales = total(sales_mnf_usd)

*create firm sales
egen all_firm_sales = total(sales_mnf_usd) if matched_crp == 1

***Get sample sales as share of total MIDAS sales***

*merge in square dataset_countries for sales_ctry
merge m:1 sales_ctry using "${intersavedir}destination_countries.dta"
*Drop Luxembourg as it is only dest_ctry
drop if _m == 2
*use _m as indicator
egen square_midas_sales = total(sales_mnf_usd) if _m == 3

*get share
collapse (mean) all_midas_sales all_firm_sales square_midas_sales 

scalar sharesquareofMIDAS = round(square_midas_sales[1]/all_midas_sales[1]*100,0.01)
scalar sharefirmsofMIDAS = round(all_firm_sales[1]/all_midas_sales[1]*100,0.01)


scalar list

log close




