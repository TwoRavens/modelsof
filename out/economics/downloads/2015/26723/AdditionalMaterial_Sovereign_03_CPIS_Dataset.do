// ##############################################################################################
// *
// * dofile: Sovereign_03_CPIS_Dataset.do
// * author: Finn Marten Körner
// * last edit: 18/01/2013
// * source data:  /CRA/Data/output/analysis/IssuerRatings_LTForeign_AnnualPanel
// * target data:  /CRA/Data/output/analysis/Portfolio_Ratings_BilateralDataset
// *
// * ORGANISATION:
// * 0. PRELIMINARIES
// # 1.	PREPARE PANEL DATASET WITH MACRO DATA
// # 2a	PREPARE PANEL DATASET WITH PORTFOLIO INVESTMENT DATA
// # 2b PREPARE PANEL DATASET WITH WORLDBANK PORTFOLIO FLOWS
// # 3.	MERGE SOVEREIGN ISSUES DATA FOR TRANSMITTING AND RECEIVING COUNTRY
// # 3a MERGE PORTES & REY (2005) DATASET FROM CROSSBORDERCAPITAL
// # 3b MERGE Issuer Ratings dataset to (`dir') country
// # 3c MERGE WORLD BANK FINANCIAL SECTOR INDICATORS
// # 4.	MERGE CHINN-ITO INDEX FOR SENDING AND RECEIVING COUNTRY
// # 5.	MERGE MADDISON (2010) DATASET FOR REAL GDP AND POPULATION
// # 6.	MERGE DISTANCE AND ADJACENCY DATA
// # 7.	MERGE JEDH DATA ON FOREIGN DEBT HOLDINGS
// # 8.	MERGE LANE/MILESI-FERRETTI DATASET
// # 9.	MERGE WORLDBANK GLOBAL FINANCIAL DEVELOPMENT INDICATORS
// *
// ##############################################################################################

// ##############################################################################################
// # 0. PRELIMINARIES
// ##############################################################################################

clear
clear matrix
set mem 300m
set more off, perm
program drop _all
capture log close
local time_start = c(current_time)

global do   "do/"
global data "data/"
global output "output/"

local os: di c(os)
local user: di c(username)
if "`os'" == "MacOSX" 	global zentra "/Users/`user'/ZenTra/Data/Data"
if "`os'" == "Windows" & "`user'" != "VwlZenTra"	global zentra "C:\Users\`user'\PowerFolders\CRA\Data"

if "`user'" == "VwlZenTra" global zentra "D:\PowerFolder\CRA\Data"
if "`user'" == "VwlZenTra" global Dropbox "D:\Dropbox\CRA\Data"


cd
cd $zentra
// cd $data

// program def stcmd
// shell "$st\st" `0'
// end

// local replace = "TRUE"
local replace = "FALSE"

// ##############################################################################################
// # 1.	PREPARE PANEL DATASET WITH MACRO DATA
// ##############################################################################################

timer on 1

if "`replace'" == "TRUE" {
clear
use $zentra/output/analysis/IssuerRatings_LTForeign_AnnualPanel

tsset id year

di as result "Drop if no GDP data available"
drop if gdp == . & gdpnc == . & gdpusd == .

di as result "Keep selected variables and replace as GDP shares"
// local varlist "ca fa_di fa_pi fa_ra pct_outflows pct_inflows gdp gdp_dd gdp_c gdp_cf gdp_eb debt_total debt_cp debt_bonds debt_foreign issues_total issues_tbills issues_cp issues_bonds issues_foreign rr_debtgdp_1 rr_debtgdp_2 rr_debtgdp_3 rr_debtgdp_4 rr_infl rr_black rr_official rr_PREMIA_percent rr_premia rr_gold rr_v_1 rr_v_2 rr_v_3 rr_v_4 rr_v_5 rr_v_6 rr_v_7 rr_v_8"
// keep id iso country year numer issuertype agency rating* `varlist'
gen ln_gdp = ln(gdp)
gen dln_gdp = D.ln_gdp
label variable dln_gdp "GDP growth"
foreach var in `varlist'  {
	if "`var'" == "gdp" continue
	replace `var' = `var'/gdp
}

xtreg fa_pi_gdp rating_60 ca pct_outflows pct_inflows gdp dln_gdp gdp_c gdp_cf gdp_eb debt_total rr_infl, fe

save $zentra/output/analysis/Analysis_LTForeign_AnnualPanel, replace
}

// ##############################################################################################
// # 2a.PREPARE PANEL DATASET WITH PORTFOLIO INVESTMENT DATA
// ##############################################################################################

if "`replace'" == "TRUE" {
clear
di as text "Use UN country codes to look for files to convert."
use $zentra/${data}UN/UN_country_codes
cd $zentra/data/IMF/CPIS/Table1/
local i = 0

di as text "Loop over countries. Continue if file non-existent, convert otherwise."
#delimit ;
local filelist `"Hungary Argentina Iceland India Aruba Indonesia  Austria "Isle of Man"
"Bahamas, The" Italy "Bahrain, Kingdom of" Japan Jersey
Barbados Kazakhstan Korea Belgium "Kosovo, Republic of" Kuwait
Bermuda Latvia Lebanon Brazil Lithuania Luxembourg Bulgaria Malaysia Malta
Canada Mauritius Mexico "Cayman Islands" "Netherlands Antilles" Netherlands Chile
Norway "China, P.R. Macao" Pakistan Panama Colombia
"Costa Rica" Portugal "Curacao and St. Maarten"  "Russian Federation" Cyprus Singapore "Slovak Republic"
"Czech Republic" Slovenia "South Africa" Denmark  Sweden Egypt Thailand  Turkey
France Ukraine Germany Gibraltar Uruguay Greece Vanuatu
Guernsey "Venezuala, Republica Bolivariana de"
"United States"  "United Kingdom" Finland Estonia Switzerland Spain Australia Ireland "New Zealand"
"China, P.R. Hong Kong" Philippines Poland Romania"'; // "
#delimit cr;

// ##############################################################################################
// CONVERT files by sheet

foreach file in `filelist' {
foreach sheet in "Table 1- Total Investment" "Table 1.1-Equity Securities" "Table 1.2-Debt Securities" "Table 1.2.A-Long Term Debt Secu" "Table 1.2.B-Short Term Debt Sec" {
	local ++i
	local c: di "`file'"
	local sheetname = subinstr(subinstr(substr("`sheet'",1,strpos("`sheet'","-")-1)," ","",.),".","_",.)
	di as text "Next country to convert is " as input "`c'" as text"."
	capture confirm file "$zentra/data/IMF/CPIS/Table1/`c'.xls"
	if _rc continue
	capture confirm file "$zentra/data/IMF/CPIS/`sheetname'/`c'_`sheet'.dta"
	if !_rc continue
	xls2dta using `"$zentra/data/IMF/CPIS/Table1/`c'.xls"', save($zentra/data/IMF/CPIS/`sheetname'/) allsheets("`sheet'") //"
	di as result "Country successfully converted."
}
}
di as input "`i'" as text" countries successfully converted."

// ##############################################################################################
// APPEND into single dataset

clear
local j = 1
foreach sheet in "Table 1- Total Investment" "Table 1.1-Equity Securities" "Table 1.2-Debt Securities" "Table 1.2.A-Long Term Debt Secu" "Table 1.2.B-Short Term Debt Sec" {
foreach file in `filelist' {
	local sheetname = subinstr(subinstr(substr("`sheet'",1,strpos("`sheet'","-")-1)," ","",.),".","_",.)
	local sheetdesc = substr("`sheet'",strpos("`sheet'","-")+1,length("`sheet'"))
	append using `"$zentra/data/IMF/CPIS/`sheetname'/`file'.dta"' // "
	replace A = `j' if A == .
	label define country_labels `j' "`file'", add
	local ++j
	if "`file'" == "Hungary" {
		local notes = ""
		forvalues i = 255 / 261 {
			note: B[`i']
		}
	}
	drop in `=_N-10'/`=_N'
}
label values A country_labels

rename A to_country
rename B from_country
rename C CPIS_`sheetname'_1997
local year = 2001
foreach var of varlist D-N {
	di as result "Rename variable " as input"`var'"as result " into "as input "CPIS_`sheetname'_`year'" as result"."
	rename `var' CPIS_`sheetname'_`year'
	label variable CPIS_`sheetname'_`year' "Portfolio investment in `year' (US Dollars, Millions)"
	local ++year
}

// ##############################################################################################
// CREATE long panel dataset

bysort to_country: gen id = _n
drop if id <= 6
foreach var of varlist CPIS_`sheetname'_1997-CPIS_`sheetname'_2011 {
	qui replace `var' = "" if `var' == "..." | `var' == "-"
}
destring CPIS_`sheetname'_*, replace

label data "`sheetname': Reported Portfolio Investment Assets by Economy of Nonresident Issuer: `sheetdesc'"

di as text "Reshape into long dataset."
reshape long CPIS_`sheetname'_, i(to_country from_country id) j(year)

// ##############################################################################################
// MERGE UN country codes to countries

rename to_country to_country_num
decode to_country_num, gen(to_country)
drop to_country_num

foreach c in to from {
	rename `c'_country countryorareaname
	replace countryorareaname = "Bahamas" if countryorareaname == "Bahamas, The"
	replace countryorareaname = "Bahrain" if countryorareaname == "Bahrain, Kingdom of"
	replace countryorareaname = "Bolivia (Plurinational State of)" if countryorareaname == "Bolivia"
	replace countryorareaname = "Democratic Republic of the Congo" if countryorareaname == "Congo, Democratic Republic of"
	replace countryorareaname = "Congo" if countryorareaname == "Congo, Republic of"
	replace countryorareaname = "C`=char(153)'te d'Ivoire" if countryorareaname == "Cote d'Ivoire"
	replace countryorareaname = "Cura`=char(141)'ao" if countryorareaname == "Curacao and St. Maarten"
	replace countryorareaname = "Cura`=char(141)'ao" if countryorareaname == "Curacao"
	replace countryorareaname = "China, Hong Kong Special Administrative Region" if countryorareaname == "China, P.R. Hong Kong"
	replace countryorareaname = "Republic of Korea" if countryorareaname == "Korea"
	replace countryorareaname = "China, Macao Special Administrative Region" if countryorareaname == "China, P.R. Macao"
	replace countryorareaname = "Republic of Moldova" if countryorareaname == "Moldova"
	replace countryorareaname = "Slovakia" if countryorareaname == "Slovak Republic"
	replace countryorareaname = "United Kingdom of Great Britain and Northern Ireland" if countryorareaname == "United Kingdom"
	replace countryorareaname = "United States of America" if countryorareaname == "United States"
	replace countryorareaname = "Venezuela (Bolivarian Republic of)" if countryorareaname == "Venezuela, Republica Bolivariana de"
	replace countryorareaname = "Viet Nam" if countryorareaname == "Vietnam"
	replace countryorareaname = "Yemen" if countryorareaname == "Yemen, Republic of"

	replace countryorareaname = "The former Yugoslav Republic of Macedonia" if countryorareaname == "Macedonia, FYR"
	replace countryorareaname = "Timor-Leste" if countryorareaname == "Timor Leste"
	replace countryorareaname = "Serbia" if countryorareaname == "Serbia, Republic of"
	replace countryorareaname = "Democratic People's Republic of Korea" if countryorareaname == "Korea, Democratic People's Rep. of"
	replace countryorareaname = "Republic of Korea" if countryorareaname == "Korea, Republic of"
	replace countryorareaname = "Bonaire, Saint Eustatius and Saba" if countryorareaname == "Bonaire, Sint Eustatius and Saba"
	replace countryorareaname = "China, Hong Kong Special Administrative Region" if countryorareaname == "China, P.R.: Hong Kong"
	replace countryorareaname = "China, Macao Special Administrative Region" if countryorareaname == "China, P.R.: Macao"
	replace countryorareaname = "Faeroe Islands" if countryorareaname == "Faroe Islands"
	replace countryorareaname = "Falkland Islands (Malvinas)" if countryorareaname == "Falkland Islands"
	replace countryorareaname = "Gambia" if countryorareaname == "Gambia, The"
	replace countryorareaname = "Iran (Islamic Republic of)" if countryorareaname == "Iran, Islamic Republic of"
	replace countryorareaname = "Kyrgyzstan" if countryorareaname == "Kyrgyz Republic"
	replace countryorareaname = "Lao People's Democratic Republic" if countryorareaname == "Lao, P.D.R."
	replace countryorareaname = "Marshall Islands" if countryorareaname == "Marshall Islands, Republic of"
	replace countryorareaname = "Micronesia (Federated States of)" if countryorareaname == "Micronesia, Federated States of"
	replace countryorareaname = "Montenegro" if countryorareaname == "Montenegro, Republic of"
	replace countryorareaname = "Taiwan" if countryorareaname == "Taiwan Province of China"
	replace countryorareaname = "United States Virgin Islands" if countryorareaname == "US Virgin Islands"
	replace countryorareaname = "United Republic of Tanzania" if countryorareaname == "Tanzania"
	replace countryorareaname = "Saint Lucia" if countryorareaname == "St. Lucia"
	replace countryorareaname = "Saint Vincent and the Grenadines" if countryorareaname == "St. Vincent and the Grenadines"
	replace countryorareaname = "Tokelau" if countryorareaname == "Tokelau Islands"
	replace countryorareaname = "Saint Kitts and Nevis" if countryorareaname == "St. Kitts and Nevis"
	replace countryorareaname = "China" if countryorareaname == "China, P.R.: Mainland"
	replace countryorareaname = "R`=char(142)'union" if countryorareaname == "Reunion"
	replace countryorareaname = "Sint Maarten (Dutch pat)" if countryorareaname == "Sint Maarten"
	replace countryorareaname = "Wallis and Futuna Islands" if countryorareaname == "Wallis and Futuna"
	replace countryorareaname = "British Virgin Islands" if countryorareaname == "Virgin Islands, British"

	merge m:m countryorareaname using $zentra/${data}UN/UN_country_codes
	tab countryorareaname if _merge == 1
	tab countryorareaname if _merge == 2
	replace _merge = 0 if countryorareaname == "Total Value of Investment" | countryorareaname == "Unallocated Data" | countryorareaname == "Confidential Data" | countryorareaname == "International Organizations"
	drop if _merge == 2 | _merge == 1
	drop _merge
	rename countryorareaname `c'_countryorareaname
	rename numericalcode `c'_numericalcode
	rename isoalpha3code `c'_isoalpha3code

}

order to* from* CPIS_`sheetname' year id
label variable to_countryorareaname "Portfolio investment in country"
label variable from_countryorareaname "Portfolio investment from country"
rename CPIS_`sheetname'_ CPIS_`sheetname'
label variable CPIS_`sheetname' "Portfolio investment `sheetdesc' in `year' (US Dollars, Millions)"
label variable year "Year"

sort to_country from_country year

compress
save $zentra/output/analysis/CPIS_`sheetname'_AllCountries, replace
}
}

// ##############################################################################################
// # 2b.PREPARE PANEL DATASET WITH WORLDBANK PORTFOLIO FLOWS
// ##############################################################################################

// Portfolio equity includes net inflows from equity securities other than those recorded as direct
// investment and including shares, stocks, depository receipts (American or global), and direct
// purchases of shares in local stock markets by foreign investors. Data are in current U.S. dollars.
// URL: http://data.worldbank.org/indicator/BX.PEF.TOTL.CD.WD/countries?display=default

if "`replace'" == "FALSE" {
clear
di as text "Use UN country codes to look for files to convert."
use $zentra/${data}UN/UN_country_codes
cd $zentra/data/Worldbank/
local i = 0

#delimit;
local filelist "Bank_cap2asset_ratio
Bank_npl_loans
Calims_on_other_sectors
Central_gvt_debt
Claims_on_gvt
CPI_inflation
Credit_depth
Deposit_interest_rates
Domestic_credit
Exports_GS
External_debt_stocks
FDI_inflows
GDP_USD
GDP_growth
GDP_deflator
IR_spread
Legal_rights
Lending_rate
Listed_domestic_companies
Market_cap_GDP
Market_cap_USD
Money_growth
Population
Portf_Inv_inflows
Real_interest_rate
SP_Global_equity_index
Stocks_traded_total_GDP
Total_reserves";
#delimit cr;

foreach c in `filelist' {
	capture confirm file "`c'.xls"
	if _rc continue
	capture confirm file "`c'.dta"
	if !_rc continue
	xls2dta using `"$zentra/data/Worldbank/`c'.xls"', save($zentra/data/Worldbank/) //"
	di as result "Dataset successfully converted."
}

di as input "`i'" as text" datasets successfully converted."

// ##############################################################################################
// APPEND into single dataset

clear
local j = 1
gen variable = .
foreach file in `filelist' {
	append using `"$zentra/data/Worldbank/`file'.dta"' // "
	drop if A == "Country Name"
	replace variable = `j' if variable == .
	label define labels `j' "`file'", add
	local ++j
}
label values variable labels

rename A countryorareaname
rename B isoalpha3code
local year = 1960
foreach var of varlist C-BC {
	di as result "Rename variable " as input"`var'"as result " into "as input "WB_`year'" as result"."
	rename `var' WB_`year'
	label variable WB_`year' "`filelist'"
	local ++year
}

// ##############################################################################################
// CREATE long panel dataset

bysort countryorareaname: gen id = _n
foreach var of varlist WB_1960-WB_2012 {
	qui replace `var' = "" if `var' == "..." | `var' == "-"
}
destring WB_* variable, replace

label data "World Bank: Financial Sector Indicators"
// notes IMF "Portfolio equity includes net inflows from equity securities other than those recorded as direct investment and including shares, stocks, depository receipts (American or global), and direct purchases of shares in local stock markets by foreign investors. Data are in current U.S. dollars."

di as text "Reshape into long dataset."
reshape long WB_, i(countryorareaname id) j(year)
tab variable
drop id
reshape wide WB_, i(countryorareaname isoalpha3code year) j(variable)
local i = 1
foreach file in `filelist' {
	rename WB_`i' WB_`file'
	label variable WB_`file' "WorldBank `file'"
	local ++i
}


// ##############################################################################################
// MERGE UN country codes to countries

rename countryorareaname to_country
// decode to_country_num, gen(to_country)
// drop to_country_num

foreach c in to {
	rename `c'_country countryorareaname
	replace countryorareaname = "Bahamas" if countryorareaname == "Bahamas, The"
	replace countryorareaname = "Bahrain" if countryorareaname == "Bahrain, Kingdom of"
	replace countryorareaname = "Bolivia (Plurinational State of)" if countryorareaname == "Bolivia"
	replace countryorareaname = "Democratic Republic of the Congo" if countryorareaname == "Congo, Democratic Republic of"
	replace countryorareaname = "Congo" if countryorareaname == "Congo, Rep."
	replace countryorareaname = "Democratic Republic of the Congo" if countryorareaname == "Congo, Dem. Rep."
	replace countryorareaname = "C`=char(153)'te d'Ivoire" if countryorareaname == "Cote d'Ivoire"
	replace countryorareaname = "Cura`=char(141)'ao" if countryorareaname == "Curacao and St. Maarten"
	replace countryorareaname = "Cura`=char(141)'ao" if countryorareaname == "Curacao"
	replace countryorareaname = "Hong Kong Special Administrative Region" if countryorareaname == "China, P.R. Hong Kong"
	replace countryorareaname = "Egypt" if countryorareaname == "Egypt, Arab Rep."
	replace countryorareaname = "Republic of Korea" if countryorareaname == "Korea, Rep."
	replace countryorareaname = "China, Macao Special Administrative Region" if countryorareaname == "China, P.R. Macao"
	replace countryorareaname = "Republic of Moldova" if countryorareaname == "Moldova"
	replace countryorareaname = "Slovakia" if countryorareaname == "Slovak Republic"
	replace countryorareaname = "United Kingdom of Great Britain and Northern Ireland" if countryorareaname == "United Kingdom"
	replace countryorareaname = "United States of America" if countryorareaname == "United States"
	replace countryorareaname = "Venezuela (Bolivarian Republic of)" if countryorareaname == "Venezuela, RB"
	replace countryorareaname = "Viet Nam" if countryorareaname == "Vietnam"
	replace countryorareaname = "Yemen" if countryorareaname == "Yemen, Rep."
	replace countryorareaname = "The former Yugoslav Republic of Macedonia" if countryorareaname == "Macedonia, FYR"
	replace countryorareaname = "Timor-Leste" if countryorareaname == "Timor Leste"
	replace countryorareaname = "Serbia" if countryorareaname == "Serbia, Republic of"
	replace countryorareaname = "Democratic People's Republic of Korea" if countryorareaname == "Korea, Dem. Rep."
	replace countryorareaname = "Republic of Korea" if countryorareaname == "Korea, Republic of"
	replace countryorareaname = "Bonaire, Saint Eustatius and Saba" if countryorareaname == "Bonaire, Sint Eustatius and Saba"
	replace countryorareaname = "Hong Kong Special Administrative Region" if countryorareaname == "Hong Kong SAR, China"
	replace countryorareaname = "China, Macao Special Administrative Region" if countryorareaname == "Macao SAR, China"
	replace countryorareaname = "Faeroe Islands" if countryorareaname == "Faroe Islands"
	replace countryorareaname = "Falkland Islands (Malvinas)" if countryorareaname == "Falkland Islands"
	replace countryorareaname = "Gambia" if countryorareaname == "Gambia, The"
	replace countryorareaname = "Iran (Islamic Republic of)" if countryorareaname == "Iran, Islamic Rep."
	replace countryorareaname = "Kyrgyzstan" if countryorareaname == "Kyrgyz Republic"
	replace countryorareaname = "Lao People's Democratic Republic" if countryorareaname == "Lao PDR"
	replace countryorareaname = "Marshall Islands" if countryorareaname == "Marshall Islands, Republic of"
	replace countryorareaname = "Micronesia (Federated States of)" if countryorareaname == "Micronesia, Fed. Sts."
	replace countryorareaname = "Montenegro" if countryorareaname == "Montenegro, Republic of"
	replace countryorareaname = "Taiwan" if countryorareaname == "Taiwan Province of China"
	replace countryorareaname = "United States Virgin Islands" if countryorareaname == "US Virgin Islands"
	replace countryorareaname = "United Republic of Tanzania" if countryorareaname == "Tanzania"
	replace countryorareaname = "Saint Lucia" if countryorareaname == "St. Lucia"
	replace countryorareaname = "Saint Vincent and the Grenadines" if countryorareaname == "St. Vincent and the Grenadines"
	replace countryorareaname = "Tokelau" if countryorareaname == "Tokelau Islands"
	replace countryorareaname = "Saint Kitts and Nevis" if countryorareaname == "St. Kitts and Nevis"
	replace countryorareaname = "China" if countryorareaname == "China, P.R.: Mainland"
	replace countryorareaname = "R`=char(142)'union" if countryorareaname == "Reunion"
	replace countryorareaname = "Saint-Martin (French part)" if countryorareaname == "St. Martin (French part)"
	replace countryorareaname = "Sint Maarten (Dutch part)" if countryorareaname == "Sint Maarten"
	replace countryorareaname = "Wallis and Futuna Islands" if countryorareaname == "Wallis and Futuna"
	replace countryorareaname = "British Virgin Islands" if countryorareaname == "Virgin Islands, British"
	replace countryorareaname = "United States Virgin Islands" if countryorareaname == "Virgin Islands (U.S.)"
	replace countryorareaname = "" if countryorareaname == ""

	merge m:m countryorareaname isoalpha3code using $zentra/${data}UN/UN_country_codes
	tab countryorareaname if _merge == 1
	tab countryorareaname if _merge == 2
	replace _merge = 0 if countryorareaname == "Total Value of Investment" | countryorareaname == "Unallocated Data" | countryorareaname == "Confidential Data" | countryorareaname == "International Organizations"
	drop if _merge == 2 | _merge == 1 | _merge == 0
	drop _merge

}

order countryorareaname numericalcode isoalpha3code isoalpha2code year

compress
save $zentra/data/Worldbank/Financial_Sector_Indicators, replace
}

// ##############################################################################################
// # 3.	MERGE SOVEREIGN ISSUES DATA FOR TRANSMITTING AND RECEIVING COUNTRY
// ##############################################################################################

clear
use $zentra/output/analysis/CPIS_Table1_AllCountries

append using $zentra/data/IMF/CPIS/CPIS_2012

// ##############################################################################################
// # 3.a MERGE PORTES & REY (2005) DATASET FROM CROSSBORDERCAPITAL
// ##############################################################################################

merge m:m year from_isoalpha3code to_isoalpha3code using ${zentra}/data/CrossBorderCapital/datacrossborder
di as result "Countries not merged (from)"
tab from_countryorareaname if _merge == 1
di as result "Countries not merged (to)"
tab to_countryorareaname if _merge == 1

// Keep all merged data since years cannot overlap: CPIS (1997-2011) vs. Portes & Rey (1989-96)
drop _merge

// ##############################################################################################
// # 3.b MERGE Issuer Ratings dataset to (`dir') country
// # 3.c MERGE WORLD BANK FINANCIAL SECTOR INDICATORS
// ##############################################################################################

foreach dir in from to {
	di as result "Merge Issuer Ratings dataset to (`dir') country"
	rename `dir'_numericalcode numericalcode
	merge m:m numericalcode year using $zentra/output/analysis/IssuerRatings_LTForeign_AnnualPanel
	tab _merge
	tab `dir'_country if _merge == 1
	drop if _merge == 2
	drop _merge countryorareaname
	di as result "Drop variables with less than 10% nonmissing values (over 200.000 missing)"
	drop fa fa_di fa_pi fa_pi_assets fa_pi_liab fa_fd fa_oi_assets fa_oi_liabilities fa_gdp fa_di_gdp fa_pi_gdp issues_nonres_gdp
	// foreach var in numericalcode rating_20 rating_60 ratingaction {
	foreach var in issuertype agency rating_20 rating_60 ratingaction ca fa_oi fa_ra rc_outflows rc_inflows rc_op rc_ip usd_outflows usd_inflows usd_op usd_ip pct_outflows pct_inflows pct_op pct_ip gdp gdp_dd gdp_c gdp_eb gdp_cf debt_total debt_marketable debt_tbills debt_cp debt_other_mmi debt_bonds debt_nonres debt_foreign debt_nonmarket issues_total issues_tbills issues_cp issues_other_mmi issues_bonds issues_nonres issues_foreign issues_nonmarket ca_gdp fa_ra_gdp debt_total_gdp debt_nonres_gdp debt_foreign_gdp issues_total_gdp issues_foreign_gdp totaldebtnc totaldebtusd marketabledebtnc marketabledebtusd tmdbondsnc tmdbondsusd tmdforeigncurrencync tmdforeigncurrencyusd nonmarketabledebtnc nonmarketabledebtusd debtpercentagegdp tmdpercentagegdp nmdpercentagegdp gdpnc gdpusd exchangenc exchangeusd rr_debtgdp_1 rr_debtgdp_2 rr_debtgdp_3 rr_debtgdp_4 rr_infl rr_black rr_official rr_PREMIA_percent rr_premia rr_gold rr_v_1 rr_v_2 rr_v_3 rr_v_4 rr_v_5 rr_v_6 rr_v_7 rr_v_8 {
		rename `var' `dir'_`var'
	}

	di as result "Merge WorldBank Financial Sector Indicators dataset to (`dir') country"
	merge m:m numericalcode year using $zentra/data/Worldbank/Financial_Sector_Indicators
	tab _merge
	tab `dir'_countryorareaname if _merge == 1
	tab `dir'_countryorareaname if _merge == 2
	drop _merge
	rename numericalcode `dir'_numericalcode
	rename WB_Listed_domestic_companies WB_Listed_domestic_comp
	rename WB_* `dir'_WB_*
}

// ##############################################################################################
// # 4.	MERGE CHINN-ITO INDEX FOR SENDING AND RECEIVING COUNTRY
// ##############################################################################################

foreach dir in from to {
	rename `dir'_isoalpha3code ccode
	merge m:m ccode year using ${zentra}/data/ChinnIto/kaopen_2011
	rename ccode `dir'_isoalpha3code
	label variable kaopen "Chinn-Ito (2010) Index"
	rename kaopen `dir'_kaopen
	drop if _merge == 2
	drop cn country_name _merge
}

// ##############################################################################################
// # 5.	MERGE MADDISON (2010) DATASET FOR REAL GDP AND POPULATION
// ##############################################################################################

rename year time
foreach dir in from to {
	rename `dir'_numericalcode numericalcode
	merge m:m numericalcode time using ${zentra}/data/Maddison/Maddison2010_UN, keepusing(GDP GDPpp Pop)
	tab `dir'_country if _merge == 1
	rename numericalcode `dir'_numericalcode
	rename Pop `dir'_population
	rename GDPpp `dir'_Maddison_GDP_pp
	rename GDP `dir'_Maddison_GDP
	drop if _merge == 2
	drop _merge
}
rename time year

// ##############################################################################################
// # 6.	MERGE DISTANCE AND ADJACENCY DATA
// ##############################################################################################

rename from_isoalpha3code iso_o
rename to_isoalpha3code iso_d
merge m:m iso_o iso_d using ${zentra}/data/Distance/dist_cepii
rename iso_o from_isoalpha3code
rename iso_d to_isoalpha3code
foreach var in contig comlang_off comlang_ethno colony comcol curcol col45 smctry dist distcap distw distwces {
	rename `var' dist_cepii_`var'
}
di as result "Countries not merged (from)"
tab from_countryorareaname if _merge == 1
di as result "Countries not merged (to)"
tab to_countryorareaname if _merge == 1
drop if _merge == 2
drop _merge

// ##############################################################################################
// # 7.	MERGE JEDH DATA ON FOREIGN DEBT HOLDINGS
// ##############################################################################################

foreach dir in from to {
	rename `dir'_numericalcode numericalcode
	merge m:m numericalcode year using ${zentra}/data/JEDH/Foreign_Holdings_1990-2013
	tab `dir'_country if _merge == 1
	rename JEDH_21 `dir'_JEDH_21
	rename JEDH_28 `dir'_JEDH_28
	drop if _merge == 2
	drop _merge
	rename numericalcode `dir'_numericalcode
}

// ##############################################################################################
// # 8.	MERGE LANE/MILESI-FERRETTI DATASET
// ##############################################################################################

foreach dir in from to {
	rename `dir'_numericalcode numericalcode
	merge m:m numericalcode year using ${zentra}/data/ExternalWealthNations/EWN_LaneMF
	tab `dir'_country if _merge == 1
	rename (EWN_* numericalcode) (`dir'_EWN_* `dir'_numericalcode)
	drop if _merge == 2
	drop _merge
}

// ##############################################################################################
// # 9.	MERGE WORLDBANK GLOBAL FINANCIAL DEVELOPMENT INDICATORS
// ##############################################################################################

foreach dir in from to {
	rename `dir'_numericalcode numericalcode
	merge m:m numericalcode year using ${zentra}/data/WorldBank/GFD_indicators
	tab `dir'_country if _merge == 1
	rename (GFD_* numericalcode) (`dir'_GFD_* `dir'_numericalcode)
	drop if _merge == 2
	drop _merge
}

// ##############################################################################################
// # 10.	MERGE IMF INTERNATIONAL FINANCIAL STATISTICS
// ##############################################################################################

foreach dir in from to {
	rename `dir'_numericalcode numericalcode
	merge m:m numericalcode year using ${zentra}/data/IMF/IFS/IFS_dataset
	tab `dir'_country if _merge == 1
	rename (IFS_* numericalcode) (`dir'_IFS_* `dir'_numericalcode)
	drop if _merge == 2
	drop _merge
}

// ##############################################################################################
// # 11.	MERGE SPATIAL DATA
// ##############################################################################################

foreach dir in from to {
	rename `dir'_isoalpha3code iso_a3
	merge m:m iso_a3 using ${zentra}/data/World_country_boundaries/worlddata, keepusing(id economy income_grp continent region_un subregion)
	drop if _merge != 3
	drop _merge
	rename iso_a3 `dir'_isoalpha3code
	rename (id economy income_grp continent region_un subregion) (`dir'_id `dir'_economy `dir'_income_grp `dir'_continent `dir'_region_un `dir'_subregion)
}

// ##############################################################################################
// # 12.	MERGE LaPorta LAW AND FINANCE DATA
// ##############################################################################################

drop isoalpha3code
foreach dir in from to {
	rename `dir'_isoalpha3code isoalpha3code
	merge m:m isoalpha3code using ${zentra}/data/LaPorta/LaPorta_LawFinance
	drop if _merge != 3
	drop _merge
	rename isoalpha3code `dir'_isoalpha3code
	rename (LaPorta_*) (`dir'_LaPorta_*)
}

// ##############################################################################################
// # 13.	MERGE BILATERAL TRADE DATA (ROSE)
// ##############################################################################################

merge m:m from_numericalcode to_numericalcode using ${zentra}/data/BilateralTrade/BilateralTrade_1999, keepusing(GATT_ltrade GATT_ldist GATT_comlang GATT_border GATT_curcol GATT_rta)
drop if _merge == 2
drop _merge

// ##############################################################################################
// # GENERATE panel dataset and additional variables

capture confirm variable cid
if !_rc drop cid
egen cid = group(to_country from_country)
label variable cid "Group Identifier for country pair"
drop if cid == .
sort to_num from_num year
xtset cid year

gen from_rating = 1 if from_rating_20 != .
replace from_rating = 0 if from_rating_20 == .
label variable from_rating "Investing country is being rated"
gen to_rating = 1 if to_rating_20 != .
replace to_rating = 0 if to_rating_20 == .
label variable to_rating "Receiving country is being rated"

drop countryorareaname

// ##############################################################################################
// # 0.	DEFINITION OF ADDITIONAL VARIABLES FOR ESTIMATION
// ##############################################################################################


sort cid year
foreach dir in to from {
	di as result"Generate GDP growth variable (`dir')"
	gen `dir'_dln_gdp = ln(`dir'_gdp) - ln(`dir'_gdp[_n-1])
	replace `dir'_dln_gdp = ln(`dir'_gdpnc) - ln(`dir'_gdpnc[_n-1]) if `dir'_dln_gdp == .
	replace `dir'_dln_gdp = ln(`dir'_gdpusd) - ln(`dir'_gdpusd[_n-1]) if `dir'_dln_gdp == .
	label variable `dir'_dln_gdp "Real GDP growth rate (`dir')"

	di as result"Generate log GDP variable (`dir')"
	gen `dir'_ln_gdp = ln(`dir'_gdp)
	replace `dir'_ln_gdp = ln(`dir'_gdpusd) if `dir'_ln_gdp == .
	label variable `dir'_ln_gdp "log GDP (`dir')"

	di as result"Generate log population variable (`dir')"
	gen `dir'_ln_population = ln(`dir'_population)
	label variable `dir'_ln_population "log Population (`dir')"

	di as result"Generate exchange rate appreciation and volatility variables (`dir')"
	gen `dir'_dln_exchangenc = ln(`dir'_exchangenc) - ln(`dir'_exchangenc[_n-1])
	label variable `dir'_dln_exchangenc "Appreciation of exchange rate (y-o-y in USD)"
	gen `dir'_dln_exchangenc2 = `dir'_dln_exchangenc^2
	label variable `dir'_dln_exchangenc2 "Square Appreciation of exchange rate (y-o-y in USD)"

	di as result"Generate investment grade rating and transition variables (`dir')"
	gen `dir'_rating_invgrade =  1 if `dir'_rating_20 <= 8 & `dir'_rating_20 != 0
	replace `dir'_rating_invgrade = 0 if `dir'_rating_invgrade == .
	label variable `dir'_rating_invgrade "`dir' country has investment grade rating"

	gen `dir'_rating_invupgrade = 1 if ((`dir'_rating_20[_n-1] > 8 & `dir'_rating_20[_n-1] != . & `dir'_rating_20[_n] <= 8 ) | (`dir'_rating_20[_n-2] > 8 & `dir'_rating_20[_n-1] <= 8 & `dir'_rating_20[_n-2] != . ) )  & `dir'_rating_20[_n] != 0 & cid[_n-1] == cid[_n]
	gen `dir'_rating_invupgrade_years = 0 if `dir'_rating_invupgrade == 1
	forvalues j = 1 / 10 {
		replace `dir'_rating_invupgrade_years = `j' if `dir'_rating_invupgrade_years[_n-`j'] == 0 & cid[_n-`j'] == cid[_n]
	}
	label variable `dir'_rating_invupgrade_years "Years since `dir' country has been upgraded to investment grade rating"
	replace `dir'_rating_invupgrade = 0 if `dir'_rating_invupgrade == . | `dir'_rating_20 == 0 | `dir'_rating_20[_n-1] == 0 | cid[_n-1] != cid[_n] | cid[_n-2] != cid[_n]
	label variable `dir'_rating_invupgrade "`dir' country has been upgraded to investment grade rating this year or last year"

 	gen `dir'_rating_invdowngrade = 1 if ((`dir'_rating_20[_n-1] <= 8 & `dir'_rating_20[_n] > 8 & `dir'_rating_20[_n] != .) | (`dir'_rating_20[_n-2] <= 8 & `dir'_rating_20[_n-1] > 8 & `dir'_rating_20[_n-2] != .) & `dir'_rating_20 != 0 & cid[_n-1] == cid[_n] )
 	replace `dir'_rating_invdowngrade = 0 if `dir'_rating_invdowngrade == . | `dir'_rating_20 == 0 | `dir'_rating_20[_n-1] == 0 | cid[_n-1] != cid[_n] | cid[_n-2] != cid[_n]
 	label variable `dir'_rating_invdowngrade "`dir' country has been downgraded below investment grade rating"

	gen `dir'_newrating = 1 if ((`dir'_rating_20[_n-1] == . & `dir'_rating_20[_n] != . ) & cid[_n-1] == cid[_n] )
 	replace `dir'_newrating = 0 if `dir'_newrating == .
 	egen `dir'_newrating_abs = max(`dir'_newrating), by(cid)
 	label variable `dir'_newrating "`dir' country has been awarded a rating"

	gen `dir'_newrating_years = 1 if `dir'_newrating == 1
	label variable `dir'_newrating_years "Years since `dir' country has been awarded a rating"
	forvalues j = 1 / 10 {
		replace `dir'_newrating_years = `j'+1 if `dir'_newrating[_n-`j'] == 1 & cid[_n-`j'] == cid[_n]
	}
 	replace `dir'_newrating_years = 0 if `dir'_newrating_years == .
}

// #################################################################################
// Create period dummies
tab year, gen(years)
local i = 1
foreach var of numlist 1989/1997 2001/2011 {
	rename years`i' year_`var'
	label variable year_`var' "Dummy `var'"
	local ++i
}

// #################################################################################
// Create log variables
gen ln_CPIS = ln(CPIS_Table1)
label variable ln_CPIS "log CPIS Table 1 (Total Investment)"

gen ln_dist_cepii_distcap = ln(dist_cepii_distcap)
label variable ln_dist_cepii_distcap "log simple distance between capitals (capitals, km)"

// #################################################################################
// Create regional dummy variables
foreach dir in from to {
	gen `dir'_wh = 0
	foreach country in "United States of America" Canada {
		replace `dir'_wh = 1 if `dir'_country == "`country'"
	}
	gen `dir'_nonsc = 0
	label variable `dir'_nonsc "d European Non-Scandinavian countries"
	foreach country in Austria Germany Netherlands Belgium France Italy Portugal Spain "United Kingdom of Great Britain and Northern Ireland" Ireland { // Norway Sweden Denmark Finland Iceland {
		replace `dir'_nonsc = 1 if `dir'_country == "`country'"
	}
	gen `dir'_easia = 0
	label variable `dir'_easia "d East Asia"
	foreach country in Japan "China, Hong Kong Special Administrative Region" Singapore {
		replace `dir'_easia = 1 if `dir'_country == "`country'"
	}
	gen `dir'_EU15 = 0
	label variable `dir'_EU15 "d EU-15 countries"
	foreach country in Germany France Italy Netherlands Belgium "United Kingdom of Great Britain and Northern Ireland" Denmark Finland Sweden Spain Portugal Greece Luxembourg Ireland Austria {
		replace `dir'_EU15 = 1 if `dir'_country == "`country'"
	}
}

// #################################################################################
// ADD Portes&Rey dummies
gen portes_rey_countries = 0
gen wh = 0
	label variable wh "Western Hemisphere dummy"
gen nonsc = 0
	label variable nonsc "European Non-Scandinavian dummy"
gen easia = 0
	label variable easia "East Asia dummy"
gen EU15 = 0
	label variable EU15 "EU-15 dummy"
foreach var in wh nonsc easia EU15 {
	qui replace `var' = 1 if from_`var' == 1 & to_`var' == 1
}

label variable portes_rey_countries "Dummy for country from Portes & Rey (2005)"
foreach from_c in "United States of America" Canada Japan "China, Hong Kong Special Administrative Region" Singapore "United Kingdom of Great Britain and Northern Ireland" Germany France Netherlands Spain Italy Switzerland Scandinavia Australia {
foreach to_c   in "United States of America" Canada Japan "China, Hong Kong Special Administrative Region" Singapore "United Kingdom of Great Britain and Northern Ireland" Germany France Netherlands Spain Italy Switzerland Scandinavia Australia {
	qui replace portes_rey_countries = 1 if from_country == "`from_c'" & to_country == "`to_c'"
}
}

// #################################################################################
// ADD rating dummy
gen both_rating = 1 if to_rating == 1 & from_rating == 1
replace both_rating = 0 if both_rating == .
label variable both_rating "Both countries have a rating"

// #################################################################################
// Generate growth variable
bysort year: egen growth = mean(from_dln_gdp)

// #################################################################################
// Change Portes & Rey portfolio investment data from billions to millions to streamline with CPIS_Table1

// replace ln_CPIS = log(exp(logequityij)*1000) if tin(1989,1996) & logequityij != . // GROSS FLOWS, not holdings

// ##############################################################################################
// # 1.e 	MERGE foreign portfolio investment home bias (to/from_HB_FPI)

// 232 from_countries, 76 to_countries

// MERGE Home Bias Indicator for 76 to_countries
sort from_iso to_iso year
merge 1:1 from_iso to_iso year using $zentra/output/analysis/Portfolio_HomeBias_Indicator // keep(keep from_iso to_iso year to_MC_dom_share to_dFPI to_fFPI to_HB_FPI to_Domestic_Market_cap World_Market_cap)
drop if _merge == 2
drop _merge


compress
save $zentra/output/analysis/Portfolio_Ratings_BilateralDataset, replace

timer off 1
timer list 1
