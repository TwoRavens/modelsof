/* 
The programs and data files replicate the descriptive statistics and the estimation results in the paper

	Hornok, Cecília and Miklós Koren, forthcoming. “Per-Shipment Costs and the Lumpiness of International Trade.” Review of Economics and Statistics.

Please cite the above paper when using these programs.

For your convenience, we reproduce some of the data resources here. Although all of these are widely available macroeconomic data, please check with the data vendors whether you have the right to use them.

Our software and data are provided AS IS, and we assume no liability for their use or misuse. 

If you have any questions about replication, please contact Miklós Koren at korenm@ceu.hu.
*/

*** Downloads all data from the available internet resources and saves them to the folder data/. This script uses a Unix shell, so requires Unix, Linux or Mac OS X. If you are running Windows, check how to use zip and gzip from the command line. We have saved the output of this script in data/ for your convenience, so you can skip the downloads.

set more off

* unzip Census trade data
shell gunzip -r data/census/trade

* read unilateral vars from CEPII
copy "http://www.cepii.fr/distance/geo_cepii.dta" data/cepii/geo_cepii.dta, replace

* read bilateral vars from CEPII
copy "http://www.cepii.fr/distance/dist_cepii.dta" data/cepii/dist_cepii.dta, replace

* read census numerical codes
copy "http://www.census.gov/foreign-trade/schedules/c/country.txt" data/census/country.txt, replace text

* indicators from World Bank Data API
foreach indicator in ny.gdp.pcap.cd ny.gdp.mktp.cd ic.exp.cost.imp ic.exp.time.imp {
	capture wbopendata, indicator(`indicator') year(2009) clear long
	saveold data/worldbank/`indicator'.dta, replace
}

* Concordance between Combine Nomenclature and Broad Economic Categories
copy "http://ec.europa.eu/eurostat/ramon/other_documents/combined%20nomenclature/conversion_tables/cn_bec_8809.zip" data/eurostat/cn_bec_8809.zip, replace
shell unzip -o data/eurostat/cn_bec_8809.zip -d data/eurostat

* Concordance between Harmonized System and Broad Economic Categories
copy "http://unstats.un.org/unsd/trade/conversions/HS2007-BEC4%20Correlation%20and%20conversionTable.xls" data/unsd/hs2bec.xls, replace


* Economic integration agreements database on Jeffrey Bergstrand’s homepage. We saved the “Data Sheet” from file “Current Working Document May 31 2013” as a text file under data/EIA2013.txt.
* this is a huge file, so we save it to /tmp
tempfile EIA2013
tempfile unzip
mkdir "`unzip'"
copy "http://www3.nd.edu/~jbergstr/DataEIAsMay2013/EIADatabaseMay2013.zip" `EIA2013', replace
shell unzip -o `EIA2013' -d `unzip'
copy "`unzip'/Current Working Document May 31 2013.xlsx" data/bergstrand/EIA2013.xlsx, replace


* EUR USD exchange rates
copy "http://epp.eurostat.ec.europa.eu/NavTree_prod/everybody/BulkDownloadListing?sort=1&downfile=data%2Fert_bil_eur_m.tsv.gz" data/eurostat/ert_bil_eur_m.tsv.gz, replace
shell gunzip data/eurostat/ert_bil_eur_m.tsv.gz


* AT uses completely different URLs by month
local jan "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/cg09en"
local feb "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Febrero/cg09fb"
local mar "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Marzo/cg09mz"
local apr "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Abril/cg09ab"
local may "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Mayo/cg09my"
local jun "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Junio/cg09jn"
local jul "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Julio/cg09jl"
local aug "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Agosto/cg09ag"
local sep "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Septiembre/cg09sp"
local oct "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Octubre/cg09oc"
local nov "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Noviembre/cg09nv"
local dec "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Diciembre/cg09dc"

local products 22 39 53 61 63 74 84 86 90 99
local months jan feb mar apr may jun jul aug sep oct nov dec
tempfile zip csv
foreach month in `months' {
	clear
	save `csv', replace emptyok
	foreach product in `products' {
		capture copy "``month''`product'.zip" `zip', replace
		if _rc {
			* this file is at a different URL
			copy "http://www.agenciatributaria.es/static_files/AEAT/Aduanas/Contenidos_Privados/Estadisticas_Comercio_Exterior/comercio_exterior/datos_mensuales_maxima_desagregacion/2009/Enero/cg09en`product'.zip" `zip', replace
		}
		shell unzip -o `zip' -d data/agenciatributaria
		local filename = substr("``month''", length("``month''")-5, 6)+"`product'"
		di "`filename'"
            /* process file */
            clear
            #delimit ;
            infix
            str flow 1-1
            byte year 2-3
            byte month 4-5
            byte customs_office 6-7
            byte year_filing 20-21
            byte month_filing 22-23
            byte day_filing 24-25
            long cn8 26-33 byte extra2digit 34-35
            str intrastat 38
            byte tradezone 66
            str country_final 67-69
            str country_transit 70-72
            str country3 73-75
            byte province_final 76-77
            byte province_transit  78-79
            str declaration_type 80-82
            byte procedure_requested 83-84
            byte procedure_previous 85-86
            weight 90-104
            quantity 105-119
            value_stat 120-131
            value_invoice 132-143
            //int currency 144-146
            str currency 144-146
            byte containerized 159
            str transport_regime 160-164
            byte transport_mode 165-166
            str transport_nationality 167-169
            byte declaration_simplified 170
            byte transaction_nature 173-174
            str transport_parity 175-177
            quota 178-183
            tariff_preference 184-189
            freight_charge 190-201
            byte province_filing 225-226
            using data/agenciatributaria/`filename'.;
            #delimit cr
			
			append using `csv'
			save `csv', replace
			
			erase data/agenciatributaria/`filename'.
			}
	export delimited using data/agenciatributaria/`month'.csv, replace
}


* download detailed indicators for 2009
* these are no longer on the website, so use web.archive.org
tempfile doingbusiness clist
clear
insheet using data/own/country_list.csv
save `clist'
clear

save `doingbusiness', replace emptyok
forval i = 2/210 {
	shell wget http://web.archive.org/web/20100710032239/http://www.doingbusiness.org/ExploreTopics/TradingAcrossBorders/Details.aspx?economyid=`i' -O data/worldbank/doingbusiness/`i'.html
	import delimited using data/worldbank/doingbusiness/`i'.html, clear rowrange(724:724) delimiters("</td><td", asstring)
	count 
	if r(N)>0 {
	gen i = `i'
	reshape long v, i(i) j(j)
	gen number = real(regexs(1)) if regexm(v, "right'>([0-9]+)")
	reshape wide v number, i(i) j(j)

	local flow export
	local comp time
	ren number2 document_`comp'_`flow'
	ren number4 customs_`comp'_`flow'
	ren number6 port_`comp'_`flow'
	ren number8 inland_`comp'_`flow'
	ren number10 total_`comp'_`flow'
	local comp cost
	ren number3 document_`comp'_`flow'
	ren number5 customs_`comp'_`flow'
	ren number7 port_`comp'_`flow'
	ren number9 inland_`comp'_`flow'
	ren number11 total_`comp'_`flow'
	local flow import
	local comp time
	ren number12 document_`comp'_`flow'
	ren number14 customs_`comp'_`flow'
	ren number16 port_`comp'_`flow'
	ren number18 inland_`comp'_`flow'
	ren number20 total_`comp'_`flow'
	local comp cost
	ren number13 document_`comp'_`flow'
	ren number15 customs_`comp'_`flow'
	ren number17 port_`comp'_`flow'
	ren number19 inland_`comp'_`flow'
	ren number21 total_`comp'_`flow'
	
	keep i *export *import
	ren i doing_business_id
	gen year = 2009
	
	append using `doingbusiness'
	save `doingbusiness', replace
	}

}
merge 1:1 doing_business_id using `clist', keep(match)
drop _m
saveold data/worldbank/doingbusiness/trading_across_borders_2009, replace


