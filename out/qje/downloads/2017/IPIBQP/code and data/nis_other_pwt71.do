/*
*************************************************************************************
*************************************************************************************
*************************************************************************************

nis_otherdata


This program computes facts about natives and immigrants from standard data sources.
They are used as a comparison group in several ways for the specialized NIS data.  

Current version: May 7, 2017

Steps:
1.  Prepare PWT GDP data and an ISO-BPLD crosswalk
2.  Read in and save US Census
3.  Mean wage for natives
4.  Immigrant characteristics by source country.
5.  Compute log-wage corrections for observables

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 1: Prepare miscellaneous data sets and crosswalks

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/	

*
* 1.1: Prepare crosswalks
*

	* bpld to ISO codes
	import delimited using "./raw data/crosswalk/iso_bpld.csv", varnames(1) clear
	save ./temp/iso_bpld.dta, replace
	
	* Old PWT to new PWT iso codes
	import delimited "./raw data/crosswalk/iso oldnew.csv", varnames(1) clear
	save ./temp/iso_oldnew.dta, replace
	
	* Crosswalk from written  to PWT 7.1 iso code. 
	import delimited "./raw data/crosswalk/country_iso.csv", varnames(nonames) clear
	rename v1 code
	rename v2 name
	rename v3 iso
	save ./temp/country_iso.dta, replace

*
* 1.2: Prepare PWT average income data. 
*

	* Read and clean PWT 7.1
	import delimited "./raw data/pwt/pwt_71.csv", clear
	destring rgdpwok xrat ppp, replace ignore("na")
	rename countryisocode iso
	drop if iso == "CHN"
	merge m:1 iso using ./temp/iso_oldnew.dta
	replace iso = iso_replace if !missing(iso_replace)
	drop _merge* iso_replace
	
	* Move–Year GDP, relative to US
	gen rgdpwok2 = rgdpwok if iso == "USA"
	egen rgdpwokusa = max(rgdpwok2), by(year)
	gen gdp = rgdpwokusa/rgdpwok
	
	* 2005 GDP, relative to US
	gen gdp3 = gdp if year == 2005
	replace gdp3 = gdp if (year == 1996 & iso == "BMU")
	replace gdp3 = gdp if (year == 2000 & (iso == "DMA" | iso == "GRD" | iso == "SYC"))
	egen gdp2005 = max(gdp3), by(iso)
	
	keep iso year gdp gdp2005 rgdpwok
	rename year incwage_refyear
	rename rgdpwok gdp_unnorm
	
	preserve
	keep iso incwage_refyear gdp gdp_unnorm
	save ./temp/gdp.dta, replace
	restore
	
	keep if incwage_refyear == 2005
	keep gdp2005 iso
	save ./temp/gdp2005.dta, replace
	
	* Read and clean PWT 5.6, used to get 4 former countries
	import excel "./raw data/pwt/pwt_56.xls", sheet("PWT56") firstrow clear
	rename RGDPW rgdpwok
	rename Year year
	
	keep if Country == "U.S.S.R." | Country == "YUGOSLAVIA" | Country == "CZECHOSLOVAKIA" | Country == "MYANMAR" | Country == "U.S.A."
	gen iso = "SUN" if Country == "U.S.S.R."
	replace iso = "YUG" if Country == "YUGOSLAVIA"
	replace iso = "CSK" if Country == "CZECHOSLOVAKIA"
	replace iso = "MMR" if Country == "MYANMAR"
	replace iso = "USA" if Country == "U.S.A."
	
	keep iso rgdpwok year
	
	* Move–Year GDP, relative to US
	gen rgdpwok2 = rgdpwok if iso == "USA"
	egen rgdpwokusa = max(rgdpwok2), by(year)
	gen gdp = rgdpwokusa/rgdpwok
	
	* Substitute latest possible year for year 2005. 
	gen gdp2 = gdp if year == 1990 & (iso == "YUG" | iso == "CSK")
	replace gdp2 = gdp if year == 1989 & (iso == "MMR" | iso == "SUN")
	egen gdp2005 = max(gdp2), by(iso)
	
	rename year incwage_refyear
	rename rgdpwok gdp_unnorm
	drop if iso == "USA"
	
	preserve
	keep iso incwage_refyear gdp gdp_unnorm
	append using ./temp/gdp.dta
	save ./temp/gdp.dta, replace
	restore
	
	keep if incwage_refyear == 1990
	keep gdp2005 iso
	append using ./temp/gdp2005.dta
	save ./temp/gdp2005.dta, replace
	
*
* 1.3: Prepare allowable currency list. 
*

	* PWT iso to allowable currency code. This lists for each country which currency reports may be logical.
	import delimited "./raw data/crosswalk/iso_currency_match.csv", clear
	replace iso = trim(iso)
	save ./temp/isocurrency.dta, replace
	
*
* 1.4: Prepare WDI inflation data.
*

	import delimited "./raw data/wdi/wdi_inflation.csv", clear
	
	drop in 1/2
	rename v1 country
	rename v2 iso
	drop v3 v4

	forvalues x = 5/60 {
		local y = `x' + 1955
		rename v`x' inflation`y'
	}

	reshape long inflation, i(country iso) j(incwage_refyear)
	gen flag_inflation = 1 if inflation > 50 & !missing(inflation)
	replace flag_inflation = 0 if inflation <= 50
	egen flag_inflationever = max(flag_inflation), by(iso)
		
	keep iso incwage_refyear flag_inflation*
	save ./temp/wdi_inflation.dta, replace
	
*
* 1.5: Prepare list of currencies with devaluations. 
*

	import delimited "./raw data/crosswalk/devaluation.csv", varnames(1) clear
	replace flag_devaluation = 0 if missing(flag_devaluation)
	drop if missing(currency)
	save ./temp/devaluation.dta, replace
	
*
* 1.6: Prepare PWT currency conversion factors.
*

* PWT 7.1: baseline.
	* COLA
	import delimited "./raw data/pwt/pwt_71.csv", clear
	rename countryisocode iso
	drop if iso == "CHN"
	merge m:1 iso using ./temp/iso_oldnew.dta
	replace iso = iso_replace if !missing(iso_replace)
	drop _merge* iso_replace
	destring xrat ppp, replace ignore("na")
	gen cola = ppp/xrat
	keep iso year cola
	rename year incwage_refyear
	save ./temp/cola.dta, replace
	
	* Exchange rates
	import delimited "./raw data/pwt/pwt_71.csv", clear
	rename currency_unit currency_name
	replace currency_name = "CFA Franc" if currency_name == "CFA Franc BEAC"
	destring xrat, replace ignore("na")
	merge m:1 currency_name using ./temp/devaluation.dta
	keep currency year xrat
	drop if missing(currency) | currency < 0
	duplicates drop currency year, force
	rename year incwage_refyear
	save ./temp/xrate.dta, replace
	
* PWT 6.2: Exchange rates for pre–euro currencies, pre–dollarization Zimbabwe and El Salvador.
*		Also, PPP for Saudi Arabia before 1986. 
*		PWT6.2 is annoying: it has the right pre–euro exchange rate for most years
*		but randomly switches to euro in 1999 for most countries. So below I undo this conversion
*		using the fixed exchange rate. I already have the euro–dollar exchange rate from PWT 7.1. 
	* Exchange rates
	import delimited "./raw data/pwt/pwt_62.csv", clear
	rename countryisocode iso
	destring xrat, replace ignore("na")
	
	gen currency = .
	keep if iso == "AUT" | iso == "BEL" | iso == "CYP" | iso == "GER" | iso == "ESP" | iso == "FIN" | iso == "FRA" | iso == "GRC" | iso == "IRL" | iso == "ITA" | iso == "LUX" | iso == "NLD" | iso == "PRT" | iso == "SVK" | iso == "ZWE" | iso == "SLV" | iso == "MLT"
	replace currency = 4 if iso == "AUT"
	replace xrat = xrat*13.7603 if year >= 1999 & iso == "AUT"
	replace currency = 5 if iso == "BEL"
	replace xrat = xrat*40.3388 if year >= 1999 & iso == "BEL"
	replace currency = 15 if iso == "CYP"
	replace currency = 23 if iso == "GER" 
	replace xrat = xrat * 1.95583 if year >= 1999 & iso == "GER"
	replace currency = 54 if iso == "ESP"
	replace xrat = xrat * 166.386 if year >= 1999 & iso == "ESP"
	replace currency = 21 if iso == "FIN"
	replace xrat = xrat * 5.94573 if year >= 1999 & iso == "FIN"
	replace currency = 22 if iso == "FRA"
	replace xrat = xrat * 6.55957 if year >= 1999 & iso == "FRA"
	replace currency = 25 if iso == "GRC"
	replace xrat = xrat * 340.75 if year >= 2001 & iso == "GRC"
	replace currency = 32 if iso == "IRL"
	replace xrat = xrat * 0.787564 if year >= 1999 & iso == "IRL"
	replace currency = 33 if iso == "ITA"
	replace xrat = xrat * 1936.27 if year >= 1999 & iso == "ITA"
	replace currency = 39 if iso == "LUX"
	replace xrat = xrat * 40.3399 if year >= 1999 & iso == "LUX"
	replace currency = 18 if iso == "NLD"
	replace xrat = xrat * 2.20371 if year >= 1999 & iso == "NLD"
	replace currency = 48 if iso == "PRT"
	replace xrat = xrat * 200.482 if year >= 1999 & iso == "PRT"
	replace currency = 143 if iso == "SVK"
	replace currency = 64 if iso == "ZWE"
	replace currency = 86 if iso == "SLV"
	replace currency = 109 if iso == "MLT"
	
	keep currency xrat year
	rename year incwage_refyear
	append using ./temp/xrate.dta
	save ./temp/xrate.dta, replace
	
* PWT 6.1: Pre–dollarization Ecuador. 
	* Exchange rates
	import delimited "./raw data/pwt/pwt_61.csv", clear
	destring xrat, replace ignore("na")
	gen currency = 19
	
	keep currency xrat year
	rename year incwage_refyear
	append using ./temp/xrate.dta
	save ./temp/xrate.dta, replace
	
* PWT 5.6: USSR, Yugoslavia, Czechoslovakia, and Myanmar
	* COLA
	import excel "./raw data/pwt/pwt_56.xls", sheet("PWT56") firstrow clear
	rename P cola
	replace cola = cola/100
	rename Year incwage_refyear
	
	keep if Country == "U.S.S.R." | Country == "YUGOSLAVIA" | Country == "CZECHOSLOVAKIA" | Country == "MYANMAR"
	gen iso = "SUN" if Country == "U.S.S.R."
	replace iso = "YUG" if Country == "YUGOSLAVIA"
	replace iso = "CSK" if Country == "CZECHOSLOVAKIA"
	replace iso = "MMR" if Country == "MYANMAR"
	
	keep iso cola incwage_refyear
	append using "./temp/cola.dta"
	save ./temp/cola.dta, replace

	* Exchange rates
	import excel "./raw data/pwt/pwt_56.xls", sheet("PWT56") firstrow clear
	rename XR xrat
	rename Year incwage_refyear
	
	keep if Country == "U.S.S.R." | Country == "YUGOSLAVIA" | Country == "CZECHOSLOVAKIA" | Country == "MYANMAR"
	gen currency = 50 if Country == "U.S.S.R."
	replace currency = 137 if Country == "YUGOSLAVIA"
	replace currency = 16 if Country == "CZECHOSLOVAKIA"
	replace currency = 76 if Country == "MYANMAR"
	drop if currency == 16 & incwage_refyear >= 1980
	drop if currency == 50 & incwage_refyear >= 1990
	
	keep currency xrat incwage_refyear
	append using "./temp/xrate.dta"
	save ./temp/xrate.dta, replace
	
* Manually add a few exchange rates that are fixed or easy to find.
	import delimited "./raw data/pwt/manual.csv", clear
	append using "./temp/xrate.dta"
	save ./temp/xrate.dta, replace
	
*
* 1.7: Prepare wage growth
*

	* CPS wage growth by type
	import delimited "./raw data/cps/logwage.txt", clear
	rename v1 logwage_base
	rename v2 exp
	rename v3 educcat
	rename v4 sex
	rename v5 year_temp
	
	save ./temp/cpswagefile.dta, replace

	* CPS aggregate wage growth
	import delimited "./raw data/cps/mean_log_wage_by_year.txt", delimiter(space, collapse) varnames(nonames) rowrange(8) clear
	keep v1-v2
	rename v1 year_temp
	rename v2 meanlogwage
	gen norm = meanlogwage if year_temp == 2003
	egen norm2 = min(norm)
	gen aggwageadj = norm2 - meanlogwage
	keep year_temp aggwageadj

	save ./temp/cpswagefile_agg.dta, replace
	
*
* 1.8: Prepare Indian nominal GDP growth
*

	import delimited "./raw data/pwt/pwt_71.csv", clear
	destring rgdpch rgdpwok, replace ignore("na")
	gen lfpr = rgdpch/rgdpwok
	keep if countryisocode == "IND"
	keep year lfpr
	save ./temp/india_nomgdp.dta, replace
	
	import excel "./raw data/pwt/na_data.xlsx", sheet("Data") firstrow clear
	keep if countrycode == "IND"
	keep v_gdp pop year
	merge 1:1 year using ./temp/india_nomgdp.dta
	drop if _merge < 3
	drop _merge*
	gen nomgdppw = v_gdp / (pop*lfpr)
	
	gen base = nomgdppw if year == 1999
	egen base2 = max(base)
	replace nomgdppw = nomgdppw/base2
	drop base*
	
	rename year incwage_refyear
	save ./temp/india_nomgdp.dta, replace
	
*
* 1.9: Caselli's Non-agricultural PPP GDP per worker gaps
*

	import delimited "./raw data/wdi/WDI_Data.csv", varnames(1) clear
	keep if indicatorname == "Agriculture, value added (% of GDP)" | indicatorname == "Employment in agriculture (% of total employment)"
	keep countrycode indicatorname v30 v49-v51
	replace indicatorname = "agshare_nom" if indicatorname == "Agriculture, value added (% of GDP)"
	replace indicatorname = "empshare_wdi" if indicatorname == "Employment in agriculture (% of total employment)"

	gen value = v30 if indicatorname == "agshare_nom"
	replace value = v50 if indicatorname == "empshare_wdi"
	replace value = v49 if indicatorname == "empshare_wdi" & missing(value)
	replace value = v51 if indicatorname == "empshare_wdi" & missing(value)

	keep countrycode indicatorname value
	reshape wide value, i(countrycode) j(indicatorname) string

	rename countrycode iso
	rename valueagshare_nom agshare_nom
	rename valueempshare_wdi empshare_wdi 
	* US is curiously missing, but easy to find in NIPA
	replace agshare_nom = 1.8 if iso == "USA"
	save ./temp/wdi_ag.dta, replace

	use "./raw data/caselli2005/handbookdata.dta", clear
	keep iso ya ynona lashare y
	merge 1:1 iso using ./temp/wdi_ag.dta
	keep if _merge == 3
	drop _merge*

	gen ratio_ppp_nom_a = ya/(agshare_nom/100*y)*lashare/100
	gen ratiotemp = ratio_ppp_nom_a if iso == "USA"
	egen ratio_ppp_nom_usa = min(ratiotemp)
	replace ratio_ppp_nom_a = ratio_ppp_nom_a/ratio_ppp_nom_usa	
	drop ratiotemp ratio_ppp_nom_usa

	gen yatemp = ya if iso == "USA"
	egen yatemp2 = min(yatemp)
	replace ya = yatemp2/ya

	keep iso ratio_ppp_nom_a ya lashare empshare_wdi
	save ./temp/caselli.dta, replace

*
* 1.10: Education composition of labor force from Barro-Lee
*

	* Get quantities for non-migrants from Barro-Lee
	use "./raw data/barro lee/BL2013_MF_v2.0.dta", clear
	keep if agefrom == 25 & ageto == 999 & sex == "MF"
	keep if year == 2005
	rename WBcode iso
	keep iso l*
	save ./temp/impsub.dta, replace
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 2: Read in and save US Census

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/	
	
	clear all
	set more off
	set maxvar 10000

	quietly infix               ///
	  int     year       1-4    ///
	  float   perwt      5-14   ///
	  byte    sex        15-15  ///
	  int     age        16-18  ///
	  long    bpld       22-26  ///
	  int     yrimmig    27-30  ///
	  int     educd      33-35  ///
	  byte    empstat    36-36  ///
	  int     occ        39-42  ///
	  int     ind        43-46  ///
	  byte    classwkrd  48-49  ///
	  byte    wkswork1   50-51  ///
	  byte    uhrswork   52-53  ///
	  long    incwage    54-59  ///
	  byte    qincwage   60-60  ///
	  using `"./raw data/us census/usa_00161.dat"'

	replace perwt     = perwt     / 100

	format perwt     %10.2f

	label var year      `"Census year"'
	label var perwt     `"Person weight"'
	label var sex       `"Sex"'
	label var age       `"Age"'
	label var bpld      `"Birthplace [detailed version]"'
	label var yrimmig   `"Year of immigration"'
	label var educd     `"Educational attainment [detailed version]"'
	label var empstat   `"Employment status [general version]"'
	label var occ       `"Occupation"'
	label var ind       `"Industry"'
	label var classwkrd `"Class of worker [detailed version]"'
	label var wkswork1  `"Weeks worked last year"'
	label var uhrswork  `"Usual hours worked per week"'
	label var incwage   `"Wage and salary income"'
	label var qincwage  `"Flag for Incwage, Inctot, Incearn"'

	label define year_lbl 1850 `"1850"'
	label define year_lbl 1860 `"1860"', add
	label define year_lbl 1870 `"1870"', add
	label define year_lbl 1880 `"1880"', add
	label define year_lbl 1900 `"1900"', add
	label define year_lbl 1910 `"1910"', add
	label define year_lbl 1920 `"1920"', add
	label define year_lbl 1930 `"1930"', add
	label define year_lbl 1940 `"1940"', add
	label define year_lbl 1950 `"1950"', add
	label define year_lbl 1960 `"1960"', add
	label define year_lbl 1970 `"1970"', add
	label define year_lbl 1980 `"1980"', add
	label define year_lbl 1990 `"1990"', add
	label define year_lbl 2000 `"2000"', add
	label define year_lbl 2001 `"2001"', add
	label define year_lbl 2002 `"2002"', add
	label define year_lbl 2003 `"2003"', add
	label define year_lbl 2004 `"2004"', add
	label define year_lbl 2005 `"2005"', add
	label define year_lbl 2006 `"2006"', add
	label define year_lbl 2007 `"2007"', add
	label define year_lbl 2008 `"2008"', add
	label define year_lbl 2009 `"2009"', add
	label define year_lbl 2010 `"2010"', add
	label define year_lbl 2011 `"2011"', add
	label define year_lbl 2012 `"2012"', add
	label define year_lbl 2013 `"2013"', add
	label define year_lbl 2014 `"2014"', add
	label values year year_lbl

	label define sex_lbl 1 `"Male"'
	label define sex_lbl 2 `"Female"', add
	label values sex sex_lbl

	label define age_lbl 000 `"Less than 1 year old"'
	label define age_lbl 001 `"1"', add
	label define age_lbl 002 `"2"', add
	label define age_lbl 003 `"3"', add
	label define age_lbl 004 `"4"', add
	label define age_lbl 005 `"5"', add
	label define age_lbl 006 `"6"', add
	label define age_lbl 007 `"7"', add
	label define age_lbl 008 `"8"', add
	label define age_lbl 009 `"9"', add
	label define age_lbl 010 `"10"', add
	label define age_lbl 011 `"11"', add
	label define age_lbl 012 `"12"', add
	label define age_lbl 013 `"13"', add
	label define age_lbl 014 `"14"', add
	label define age_lbl 015 `"15"', add
	label define age_lbl 016 `"16"', add
	label define age_lbl 017 `"17"', add
	label define age_lbl 018 `"18"', add
	label define age_lbl 019 `"19"', add
	label define age_lbl 020 `"20"', add
	label define age_lbl 021 `"21"', add
	label define age_lbl 022 `"22"', add
	label define age_lbl 023 `"23"', add
	label define age_lbl 024 `"24"', add
	label define age_lbl 025 `"25"', add
	label define age_lbl 026 `"26"', add
	label define age_lbl 027 `"27"', add
	label define age_lbl 028 `"28"', add
	label define age_lbl 029 `"29"', add
	label define age_lbl 030 `"30"', add
	label define age_lbl 031 `"31"', add
	label define age_lbl 032 `"32"', add
	label define age_lbl 033 `"33"', add
	label define age_lbl 034 `"34"', add
	label define age_lbl 035 `"35"', add
	label define age_lbl 036 `"36"', add
	label define age_lbl 037 `"37"', add
	label define age_lbl 038 `"38"', add
	label define age_lbl 039 `"39"', add
	label define age_lbl 040 `"40"', add
	label define age_lbl 041 `"41"', add
	label define age_lbl 042 `"42"', add
	label define age_lbl 043 `"43"', add
	label define age_lbl 044 `"44"', add
	label define age_lbl 045 `"45"', add
	label define age_lbl 046 `"46"', add
	label define age_lbl 047 `"47"', add
	label define age_lbl 048 `"48"', add
	label define age_lbl 049 `"49"', add
	label define age_lbl 050 `"50"', add
	label define age_lbl 051 `"51"', add
	label define age_lbl 052 `"52"', add
	label define age_lbl 053 `"53"', add
	label define age_lbl 054 `"54"', add
	label define age_lbl 055 `"55"', add
	label define age_lbl 056 `"56"', add
	label define age_lbl 057 `"57"', add
	label define age_lbl 058 `"58"', add
	label define age_lbl 059 `"59"', add
	label define age_lbl 060 `"60"', add
	label define age_lbl 061 `"61"', add
	label define age_lbl 062 `"62"', add
	label define age_lbl 063 `"63"', add
	label define age_lbl 064 `"64"', add
	label define age_lbl 065 `"65"', add
	label define age_lbl 066 `"66"', add
	label define age_lbl 067 `"67"', add
	label define age_lbl 068 `"68"', add
	label define age_lbl 069 `"69"', add
	label define age_lbl 070 `"70"', add
	label define age_lbl 071 `"71"', add
	label define age_lbl 072 `"72"', add
	label define age_lbl 073 `"73"', add
	label define age_lbl 074 `"74"', add
	label define age_lbl 075 `"75"', add
	label define age_lbl 076 `"76"', add
	label define age_lbl 077 `"77"', add
	label define age_lbl 078 `"78"', add
	label define age_lbl 079 `"79"', add
	label define age_lbl 080 `"80"', add
	label define age_lbl 081 `"81"', add
	label define age_lbl 082 `"82"', add
	label define age_lbl 083 `"83"', add
	label define age_lbl 084 `"84"', add
	label define age_lbl 085 `"85"', add
	label define age_lbl 086 `"86"', add
	label define age_lbl 087 `"87"', add
	label define age_lbl 088 `"88"', add
	label define age_lbl 089 `"89"', add
	label define age_lbl 090 `"90 (90+ in 1980 and 1990)"', add
	label define age_lbl 091 `"91"', add
	label define age_lbl 092 `"92"', add
	label define age_lbl 093 `"93"', add
	label define age_lbl 094 `"94"', add
	label define age_lbl 095 `"95"', add
	label define age_lbl 096 `"96"', add
	label define age_lbl 097 `"97"', add
	label define age_lbl 098 `"98"', add
	label define age_lbl 099 `"99"', add
	label define age_lbl 100 `"100 (100+ in 1960-1970)"', add
	label define age_lbl 101 `"101"', add
	label define age_lbl 102 `"102"', add
	label define age_lbl 103 `"103"', add
	label define age_lbl 104 `"104"', add
	label define age_lbl 105 `"105"', add
	label define age_lbl 106 `"106"', add
	label define age_lbl 107 `"107"', add
	label define age_lbl 108 `"108"', add
	label define age_lbl 109 `"109"', add
	label define age_lbl 110 `"110"', add
	label define age_lbl 111 `"111"', add
	label define age_lbl 112 `"112 (112+ in the 1980 internal data)"', add
	label define age_lbl 113 `"113"', add
	label define age_lbl 114 `"114"', add
	label define age_lbl 115 `"115 (115+ in the 1990 internal data)"', add
	label define age_lbl 116 `"116"', add
	label define age_lbl 117 `"117"', add
	label define age_lbl 118 `"118"', add
	label define age_lbl 119 `"119"', add
	label define age_lbl 120 `"120"', add
	label define age_lbl 121 `"121"', add
	label define age_lbl 122 `"122"', add
	label define age_lbl 123 `"123"', add
	label define age_lbl 124 `"124"', add
	label define age_lbl 125 `"125"', add
	label define age_lbl 126 `"126"', add
	label define age_lbl 129 `"129"', add
	label define age_lbl 130 `"130"', add
	label define age_lbl 135 `"135"', add
	label values age age_lbl

	label define bpld_lbl 00100 `"Alabama"'
	label define bpld_lbl 00200 `"Alaska"', add
	label define bpld_lbl 00400 `"Arizona"', add
	label define bpld_lbl 00500 `"Arkansas"', add
	label define bpld_lbl 00600 `"California"', add
	label define bpld_lbl 00800 `"Colorado"', add
	label define bpld_lbl 00900 `"Connecticut"', add
	label define bpld_lbl 01000 `"Delaware"', add
	label define bpld_lbl 01100 `"District of Columbia"', add
	label define bpld_lbl 01200 `"Florida"', add
	label define bpld_lbl 01300 `"Georgia"', add
	label define bpld_lbl 01500 `"Hawaii"', add
	label define bpld_lbl 01600 `"Idaho"', add
	label define bpld_lbl 01610 `"Idaho Territory"', add
	label define bpld_lbl 01700 `"Illinois"', add
	label define bpld_lbl 01800 `"Indiana"', add
	label define bpld_lbl 01900 `"Iowa"', add
	label define bpld_lbl 02000 `"Kansas"', add
	label define bpld_lbl 02100 `"Kentucky"', add
	label define bpld_lbl 02200 `"Louisiana"', add
	label define bpld_lbl 02300 `"Maine"', add
	label define bpld_lbl 02400 `"Maryland"', add
	label define bpld_lbl 02500 `"Massachusetts"', add
	label define bpld_lbl 02600 `"Michigan"', add
	label define bpld_lbl 02700 `"Minnesota"', add
	label define bpld_lbl 02800 `"Mississippi"', add
	label define bpld_lbl 02900 `"Missouri"', add
	label define bpld_lbl 03000 `"Montana"', add
	label define bpld_lbl 03100 `"Nebraska"', add
	label define bpld_lbl 03200 `"Nevada"', add
	label define bpld_lbl 03300 `"New Hampshire"', add
	label define bpld_lbl 03400 `"New Jersey"', add
	label define bpld_lbl 03500 `"New Mexico"', add
	label define bpld_lbl 03510 `"New Mexico Territory"', add
	label define bpld_lbl 03600 `"New York"', add
	label define bpld_lbl 03700 `"North Carolina"', add
	label define bpld_lbl 03800 `"North Dakota"', add
	label define bpld_lbl 03900 `"Ohio"', add
	label define bpld_lbl 04000 `"Oklahoma"', add
	label define bpld_lbl 04010 `"Indian Territory"', add
	label define bpld_lbl 04100 `"Oregon"', add
	label define bpld_lbl 04200 `"Pennsylvania"', add
	label define bpld_lbl 04400 `"Rhode Island"', add
	label define bpld_lbl 04500 `"South Carolina"', add
	label define bpld_lbl 04600 `"South Dakota"', add
	label define bpld_lbl 04610 `"Dakota Territory"', add
	label define bpld_lbl 04700 `"Tennessee"', add
	label define bpld_lbl 04800 `"Texas"', add
	label define bpld_lbl 04900 `"Utah"', add
	label define bpld_lbl 04910 `"Utah Territory"', add
	label define bpld_lbl 05000 `"Vermont"', add
	label define bpld_lbl 05100 `"Virginia"', add
	label define bpld_lbl 05300 `"Washington"', add
	label define bpld_lbl 05400 `"West Virginia"', add
	label define bpld_lbl 05500 `"Wisconsin"', add
	label define bpld_lbl 05600 `"Wyoming"', add
	label define bpld_lbl 05610 `"Wyoming Territory"', add
	label define bpld_lbl 09000 `"Native American"', add
	label define bpld_lbl 09900 `"United States, ns"', add
	label define bpld_lbl 10000 `"American Samoa"', add
	label define bpld_lbl 10010 `"Samoa, 1940-1950"', add
	label define bpld_lbl 10500 `"Guam"', add
	label define bpld_lbl 11000 `"Puerto Rico"', add
	label define bpld_lbl 11500 `"U.S. Virgin Islands"', add
	label define bpld_lbl 11510 `"St. Croix"', add
	label define bpld_lbl 11520 `"St. John"', add
	label define bpld_lbl 11530 `"St. Thomas"', add
	label define bpld_lbl 12000 `"Other US Possessions:"', add
	label define bpld_lbl 12010 `"Johnston Atoll"', add
	label define bpld_lbl 12020 `"Midway Islands"', add
	label define bpld_lbl 12030 `"Wake Island"', add
	label define bpld_lbl 12040 `"Other US Caribbean Islands"', add
	label define bpld_lbl 12041 `"Navassa Island"', add
	label define bpld_lbl 12050 `"Other US Pacific Islands"', add
	label define bpld_lbl 12051 `"Baker Island"', add
	label define bpld_lbl 12052 `"Howland Island"', add
	label define bpld_lbl 12053 `"Jarvis Island"', add
	label define bpld_lbl 12054 `"Kingman Reef"', add
	label define bpld_lbl 12055 `"Palmyra Atoll"', add
	label define bpld_lbl 12090 `"US outlying areas, ns"', add
	label define bpld_lbl 12091 `"US possessions, ns"', add
	label define bpld_lbl 12092 `"US territory, ns"', add
	label define bpld_lbl 15000 `"Canada"', add
	label define bpld_lbl 15010 `"English Canada"', add
	label define bpld_lbl 15011 `"British Columbia"', add
	label define bpld_lbl 15013 `"Alberta"', add
	label define bpld_lbl 15015 `"Saskatchewan"', add
	label define bpld_lbl 15017 `"Northwest"', add
	label define bpld_lbl 15019 `"Ruperts Land"', add
	label define bpld_lbl 15020 `"Manitoba"', add
	label define bpld_lbl 15021 `"Red River"', add
	label define bpld_lbl 15030 `"Ontario/Upper Canada"', add
	label define bpld_lbl 15031 `"Upper Canada"', add
	label define bpld_lbl 15032 `"Canada West"', add
	label define bpld_lbl 15040 `"New Brunswick"', add
	label define bpld_lbl 15050 `"Nova Scotia"', add
	label define bpld_lbl 15051 `"Cape Breton"', add
	label define bpld_lbl 15052 `"Halifax"', add
	label define bpld_lbl 15060 `"Prince Edward Island"', add
	label define bpld_lbl 15070 `"Newfoundland"', add
	label define bpld_lbl 15080 `"French Canada"', add
	label define bpld_lbl 15081 `"Quebec"', add
	label define bpld_lbl 15082 `"Lower Canada"', add
	label define bpld_lbl 15083 `"Canada East"', add
	label define bpld_lbl 15500 `"St. Pierre and Miquelon"', add
	label define bpld_lbl 16000 `"Atlantic Islands"', add
	label define bpld_lbl 16010 `"Bermuda"', add
	label define bpld_lbl 16020 `"Cape Verde"', add
	label define bpld_lbl 16030 `"Falkland Islands"', add
	label define bpld_lbl 16040 `"Greenland"', add
	label define bpld_lbl 16050 `"St. Helena and Ascension"', add
	label define bpld_lbl 16060 `"Canary Islands"', add
	label define bpld_lbl 19900 `"North America, ns"', add
	label define bpld_lbl 20000 `"Mexico"', add
	label define bpld_lbl 21000 `"Central America"', add
	label define bpld_lbl 21010 `"Belize/British Honduras"', add
	label define bpld_lbl 21020 `"Costa Rica"', add
	label define bpld_lbl 21030 `"El Salvador"', add
	label define bpld_lbl 21040 `"Guatemala"', add
	label define bpld_lbl 21050 `"Honduras"', add
	label define bpld_lbl 21060 `"Nicaragua"', add
	label define bpld_lbl 21070 `"Panama"', add
	label define bpld_lbl 21071 `"Canal Zone"', add
	label define bpld_lbl 21090 `"Central America, ns"', add
	label define bpld_lbl 25000 `"Cuba"', add
	label define bpld_lbl 26000 `"West Indies"', add
	label define bpld_lbl 26010 `"Dominican Republic"', add
	label define bpld_lbl 26020 `"Haiti"', add
	label define bpld_lbl 26030 `"Jamaica"', add
	label define bpld_lbl 26040 `"British West Indies"', add
	label define bpld_lbl 26041 `"Anguilla"', add
	label define bpld_lbl 26042 `"Antigua-Barbuda"', add
	label define bpld_lbl 26043 `"Bahamas"', add
	label define bpld_lbl 26044 `"Barbados"', add
	label define bpld_lbl 26045 `"British Virgin Islands"', add
	label define bpld_lbl 26046 `"Anegada"', add
	label define bpld_lbl 26047 `"Cooper"', add
	label define bpld_lbl 26048 `"Jost Van Dyke"', add
	label define bpld_lbl 26049 `"Peter"', add
	label define bpld_lbl 26050 `"Tortola"', add
	label define bpld_lbl 26051 `"Virgin Gorda"', add
	label define bpld_lbl 26052 `"Br. Virgin Islands, ns"', add
	label define bpld_lbl 26053 `"Cayman Islands"', add
	label define bpld_lbl 26054 `"Dominica"', add
	label define bpld_lbl 26055 `"Grenada"', add
	label define bpld_lbl 26056 `"Montserrat"', add
	label define bpld_lbl 26057 `"St. Kitts-Nevis"', add
	label define bpld_lbl 26058 `"St. Lucia"', add
	label define bpld_lbl 26059 `"St. Vincent"', add
	label define bpld_lbl 26060 `"Trinidad and Tobago"', add
	label define bpld_lbl 26061 `"Turks and Caicos"', add
	label define bpld_lbl 26069 `"British West Indies, ns"', add
	label define bpld_lbl 26070 `"Other West Indies"', add
	label define bpld_lbl 26071 `"Aruba"', add
	label define bpld_lbl 26072 `"Netherlands Antilles"', add
	label define bpld_lbl 26073 `"Bonaire"', add
	label define bpld_lbl 26074 `"Curacao"', add
	label define bpld_lbl 26075 `"Dutch St. Maarten"', add
	label define bpld_lbl 26076 `"Saba"', add
	label define bpld_lbl 26077 `"St. Eustatius"', add
	label define bpld_lbl 26079 `"Dutch Caribbean, ns"', add
	label define bpld_lbl 26080 `"French St. Maarten"', add
	label define bpld_lbl 26081 `"Guadeloupe"', add
	label define bpld_lbl 26082 `"Martinique"', add
	label define bpld_lbl 26083 `"St. Barthelemy"', add
	label define bpld_lbl 26089 `"French Caribbean, ns"', add
	label define bpld_lbl 26090 `"Antilles, n.s."', add
	label define bpld_lbl 26091 `"Caribbean, ns"', add
	label define bpld_lbl 26092 `"Latin America, ns"', add
	label define bpld_lbl 26093 `"Leeward Islands, ns"', add
	label define bpld_lbl 26094 `"West Indies, ns"', add
	label define bpld_lbl 26095 `"Windward Islands, ns"', add
	label define bpld_lbl 29900 `"Americas, ns"', add
	label define bpld_lbl 30000 `"South America"', add
	label define bpld_lbl 30005 `"Argentina"', add
	label define bpld_lbl 30010 `"Bolivia"', add
	label define bpld_lbl 30015 `"Brazil"', add
	label define bpld_lbl 30020 `"Chile"', add
	label define bpld_lbl 30025 `"Colombia"', add
	label define bpld_lbl 30030 `"Ecuador"', add
	label define bpld_lbl 30035 `"French Guiana"', add
	label define bpld_lbl 30040 `"Guyana/British Guiana"', add
	label define bpld_lbl 30045 `"Paraguay"', add
	label define bpld_lbl 30050 `"Peru"', add
	label define bpld_lbl 30055 `"Suriname"', add
	label define bpld_lbl 30060 `"Uruguay"', add
	label define bpld_lbl 30065 `"Venezuela"', add
	label define bpld_lbl 30090 `"South America, ns"', add
	label define bpld_lbl 30091 `"South and Central America, n.s."', add
	label define bpld_lbl 40000 `"Denmark"', add
	label define bpld_lbl 40010 `"Faeroe Islands"', add
	label define bpld_lbl 40100 `"Finland"', add
	label define bpld_lbl 40200 `"Iceland"', add
	label define bpld_lbl 40300 `"Lapland, ns"', add
	label define bpld_lbl 40400 `"Norway"', add
	label define bpld_lbl 40410 `"Svalbard and Jan Meyen"', add
	label define bpld_lbl 40411 `"Svalbard"', add
	label define bpld_lbl 40412 `"Jan Meyen"', add
	label define bpld_lbl 40500 `"Sweden"', add
	label define bpld_lbl 41000 `"England"', add
	label define bpld_lbl 41010 `"Channel Islands"', add
	label define bpld_lbl 41011 `"Guernsey"', add
	label define bpld_lbl 41012 `"Jersey"', add
	label define bpld_lbl 41020 `"Isle of Man"', add
	label define bpld_lbl 41100 `"Scotland"', add
	label define bpld_lbl 41200 `"Wales"', add
	label define bpld_lbl 41300 `"United Kingdom, ns"', add
	label define bpld_lbl 41400 `"Ireland"', add
	label define bpld_lbl 41410 `"Northern Ireland"', add
	label define bpld_lbl 41900 `"Northern Europe, ns"', add
	label define bpld_lbl 42000 `"Belgium"', add
	label define bpld_lbl 42100 `"France"', add
	label define bpld_lbl 42110 `"Alsace-Lorraine"', add
	label define bpld_lbl 42111 `"Alsace"', add
	label define bpld_lbl 42112 `"Lorraine"', add
	label define bpld_lbl 42200 `"Liechtenstein"', add
	label define bpld_lbl 42300 `"Luxembourg"', add
	label define bpld_lbl 42400 `"Monaco"', add
	label define bpld_lbl 42500 `"Netherlands"', add
	label define bpld_lbl 42600 `"Switzerland"', add
	label define bpld_lbl 42900 `"Western Europe, ns"', add
	label define bpld_lbl 43000 `"Albania"', add
	label define bpld_lbl 43100 `"Andorra"', add
	label define bpld_lbl 43200 `"Gibraltar"', add
	label define bpld_lbl 43300 `"Greece"', add
	label define bpld_lbl 43310 `"Dodecanese Islands"', add
	label define bpld_lbl 43320 `"Turkey Greece"', add
	label define bpld_lbl 43330 `"Macedonia"', add
	label define bpld_lbl 43400 `"Italy"', add
	label define bpld_lbl 43500 `"Malta"', add
	label define bpld_lbl 43600 `"Portugal"', add
	label define bpld_lbl 43610 `"Azores"', add
	label define bpld_lbl 43620 `"Madeira Islands"', add
	label define bpld_lbl 43630 `"Cape Verde Islands"', add
	label define bpld_lbl 43640 `"St. Miguel"', add
	label define bpld_lbl 43700 `"San Marino"', add
	label define bpld_lbl 43800 `"Spain"', add
	label define bpld_lbl 43900 `"Vatican City"', add
	label define bpld_lbl 44000 `"Southern Europe, ns"', add
	label define bpld_lbl 45000 `"Austria"', add
	label define bpld_lbl 45010 `"Austria-Hungary"', add
	label define bpld_lbl 45020 `"Austria-Graz"', add
	label define bpld_lbl 45030 `"Austria-Linz"', add
	label define bpld_lbl 45040 `"Austria-Salzburg"', add
	label define bpld_lbl 45050 `"Austria-Tyrol"', add
	label define bpld_lbl 45060 `"Austria-Vienna"', add
	label define bpld_lbl 45070 `"Austria-Kaernsten"', add
	label define bpld_lbl 45080 `"Austria-Neustadt"', add
	label define bpld_lbl 45100 `"Bulgaria"', add
	label define bpld_lbl 45200 `"Czechoslovakia"', add
	label define bpld_lbl 45210 `"Bohemia"', add
	label define bpld_lbl 45211 `"Bohemia-Moravia"', add
	label define bpld_lbl 45212 `"Slovakia"', add
	label define bpld_lbl 45213 `"Czech Republic"', add
	label define bpld_lbl 45300 `"Germany"', add
	label define bpld_lbl 45301 `"Berlin"', add
	label define bpld_lbl 45302 `"West Berlin"', add
	label define bpld_lbl 45303 `"East Berlin"', add
	label define bpld_lbl 45310 `"West Germany"', add
	label define bpld_lbl 45311 `"Baden"', add
	label define bpld_lbl 45312 `"Bavaria"', add
	label define bpld_lbl 45313 `"Braunschweig"', add
	label define bpld_lbl 45314 `"Bremen"', add
	label define bpld_lbl 45315 `"Hamburg"', add
	label define bpld_lbl 45316 `"Hanover"', add
	label define bpld_lbl 45317 `"Hessen"', add
	label define bpld_lbl 45318 `"Hessen Nassau"', add
	label define bpld_lbl 45319 `"Holstein"', add
	label define bpld_lbl 45320 `"Lippe"', add
	label define bpld_lbl 45321 `"Lubeck"', add
	label define bpld_lbl 45322 `"Oldenburg"', add
	label define bpld_lbl 45323 `"Rhine Province"', add
	label define bpld_lbl 45324 `"Schleswig"', add
	label define bpld_lbl 45325 `"Schleswig-Holstein"', add
	label define bpld_lbl 45327 `"Waldeck"', add
	label define bpld_lbl 45328 `"Wurttemberg"', add
	label define bpld_lbl 45329 `"Waldecker"', add
	label define bpld_lbl 45330 `"Wittenberg"', add
	label define bpld_lbl 45331 `"Frankfurt"', add
	label define bpld_lbl 45332 `"Saarland"', add
	label define bpld_lbl 45333 `"Nordheim-Westfalen"', add
	label define bpld_lbl 45340 `"East Germany"', add
	label define bpld_lbl 45341 `"Anhalt"', add
	label define bpld_lbl 45342 `"Brandenburg"', add
	label define bpld_lbl 45344 `"Mecklenburg"', add
	label define bpld_lbl 45345 `"Sachsen-Altenburg"', add
	label define bpld_lbl 45346 `"Sachsen-Coburg"', add
	label define bpld_lbl 45347 `"Sachsen-Gotha"', add
	label define bpld_lbl 45350 `"Probable Saxony"', add
	label define bpld_lbl 45351 `"Schwerin"', add
	label define bpld_lbl 45353 `"Probably Thuringian States"', add
	label define bpld_lbl 45360 `"Prussia, nec"', add
	label define bpld_lbl 45361 `"Hohenzollern"', add
	label define bpld_lbl 45362 `"Niedersachsen"', add
	label define bpld_lbl 45400 `"Hungary"', add
	label define bpld_lbl 45500 `"Poland"', add
	label define bpld_lbl 45510 `"Austrian Poland"', add
	label define bpld_lbl 45511 `"Galicia"', add
	label define bpld_lbl 45520 `"German Poland"', add
	label define bpld_lbl 45521 `"East Prussia"', add
	label define bpld_lbl 45522 `"Pomerania"', add
	label define bpld_lbl 45523 `"Posen"', add
	label define bpld_lbl 45524 `"Prussian Poland"', add
	label define bpld_lbl 45525 `"Silesia"', add
	label define bpld_lbl 45526 `"West Prussia"', add
	label define bpld_lbl 45530 `"Russian Poland"', add
	label define bpld_lbl 45600 `"Romania"', add
	label define bpld_lbl 45610 `"Transylvania"', add
	label define bpld_lbl 45700 `"Yugoslavia"', add
	label define bpld_lbl 45710 `"Croatia"', add
	label define bpld_lbl 45720 `"Montenegro"', add
	label define bpld_lbl 45730 `"Serbia"', add
	label define bpld_lbl 45740 `"Bosnia"', add
	label define bpld_lbl 45750 `"Dalmatia"', add
	label define bpld_lbl 45760 `"Slovonia"', add
	label define bpld_lbl 45770 `"Carniola"', add
	label define bpld_lbl 45780 `"Slovenia"', add
	label define bpld_lbl 45790 `"Kosovo"', add
	label define bpld_lbl 45800 `"Central Europe, ns"', add
	label define bpld_lbl 45900 `"Eastern Europe, ns"', add
	label define bpld_lbl 46000 `"Estonia"', add
	label define bpld_lbl 46100 `"Latvia"', add
	label define bpld_lbl 46200 `"Lithuania"', add
	label define bpld_lbl 46300 `"Baltic States, ns"', add
	label define bpld_lbl 46500 `"Other USSR/Russia"', add
	label define bpld_lbl 46510 `"Byelorussia"', add
	label define bpld_lbl 46520 `"Moldavia"', add
	label define bpld_lbl 46521 `"Bessarabia"', add
	label define bpld_lbl 46530 `"Ukraine"', add
	label define bpld_lbl 46540 `"Armenia"', add
	label define bpld_lbl 46541 `"Azerbaijan"', add
	label define bpld_lbl 46542 `"Republic of Georgia"', add
	label define bpld_lbl 46543 `"Kazakhstan"', add
	label define bpld_lbl 46544 `"Kirghizia"', add
	label define bpld_lbl 46545 `"Tadzhik"', add
	label define bpld_lbl 46546 `"Turkmenistan"', add
	label define bpld_lbl 46547 `"Uzbekistan"', add
	label define bpld_lbl 46548 `"Siberia"', add
	label define bpld_lbl 46590 `"USSR, ns"', add
	label define bpld_lbl 49900 `"Europe, ns."', add
	label define bpld_lbl 50000 `"China"', add
	label define bpld_lbl 50010 `"Hong Kong"', add
	label define bpld_lbl 50020 `"Macau"', add
	label define bpld_lbl 50030 `"Mongolia"', add
	label define bpld_lbl 50040 `"Taiwan"', add
	label define bpld_lbl 50100 `"Japan"', add
	label define bpld_lbl 50200 `"Korea"', add
	label define bpld_lbl 50210 `"North Korea"', add
	label define bpld_lbl 50220 `"South Korea"', add
	label define bpld_lbl 50900 `"East Asia, ns"', add
	label define bpld_lbl 51000 `"Brunei"', add
	label define bpld_lbl 51100 `"Cambodia (Kampuchea)"', add
	label define bpld_lbl 51200 `"Indonesia"', add
	label define bpld_lbl 51210 `"East Indies"', add
	label define bpld_lbl 51220 `"East Timor"', add
	label define bpld_lbl 51300 `"Laos"', add
	label define bpld_lbl 51400 `"Malaysia"', add
	label define bpld_lbl 51500 `"Philippines"', add
	label define bpld_lbl 51600 `"Singapore"', add
	label define bpld_lbl 51700 `"Thailand"', add
	label define bpld_lbl 51800 `"Vietnam"', add
	label define bpld_lbl 51900 `"Southeast Asia, ns"', add
	label define bpld_lbl 51910 `"Indochina, ns"', add
	label define bpld_lbl 52000 `"Afghanistan"', add
	label define bpld_lbl 52100 `"India"', add
	label define bpld_lbl 52110 `"Bangladesh"', add
	label define bpld_lbl 52120 `"Bhutan"', add
	label define bpld_lbl 52130 `"Burma (Myanmar)"', add
	label define bpld_lbl 52140 `"Pakistan"', add
	label define bpld_lbl 52150 `"Sri Lanka (Ceylon)"', add
	label define bpld_lbl 52200 `"Iran"', add
	label define bpld_lbl 52300 `"Maldives"', add
	label define bpld_lbl 52400 `"Nepal"', add
	label define bpld_lbl 53000 `"Bahrain"', add
	label define bpld_lbl 53100 `"Cyprus"', add
	label define bpld_lbl 53200 `"Iraq"', add
	label define bpld_lbl 53210 `"Mesopotamia"', add
	label define bpld_lbl 53300 `"Iraq/Saudi Arabia"', add
	label define bpld_lbl 53400 `"Israel/Palestine"', add
	label define bpld_lbl 53410 `"Gaza Strip"', add
	label define bpld_lbl 53420 `"Palestine"', add
	label define bpld_lbl 53430 `"West Bank"', add
	label define bpld_lbl 53440 `"Israel"', add
	label define bpld_lbl 53500 `"Jordan"', add
	label define bpld_lbl 53600 `"Kuwait"', add
	label define bpld_lbl 53700 `"Lebanon"', add
	label define bpld_lbl 53800 `"Oman"', add
	label define bpld_lbl 53900 `"Qatar"', add
	label define bpld_lbl 54000 `"Saudi Arabia"', add
	label define bpld_lbl 54100 `"Syria"', add
	label define bpld_lbl 54200 `"Turkey"', add
	label define bpld_lbl 54210 `"European Turkey"', add
	label define bpld_lbl 54220 `"Asian Turkey"', add
	label define bpld_lbl 54300 `"United Arab Emirates"', add
	label define bpld_lbl 54400 `"Yemen Arab Republic (North)"', add
	label define bpld_lbl 54500 `"Yemen, PDR (South)"', add
	label define bpld_lbl 54600 `"Persian Gulf States, ns"', add
	label define bpld_lbl 54700 `"Middle East, ns"', add
	label define bpld_lbl 54800 `"Southwest Asia, nec/ns"', add
	label define bpld_lbl 54900 `"Asia Minor, ns"', add
	label define bpld_lbl 55000 `"South Asia, nec"', add
	label define bpld_lbl 59900 `"Asia, nec/ns"', add
	label define bpld_lbl 60000 `"Africa"', add
	label define bpld_lbl 60010 `"Northern Africa"', add
	label define bpld_lbl 60011 `"Algeria"', add
	label define bpld_lbl 60012 `"Egypt/United Arab Rep."', add
	label define bpld_lbl 60013 `"Libya"', add
	label define bpld_lbl 60014 `"Morocco"', add
	label define bpld_lbl 60015 `"Sudan"', add
	label define bpld_lbl 60016 `"Tunisia"', add
	label define bpld_lbl 60017 `"Western Sahara"', add
	label define bpld_lbl 60019 `"North Africa, ns"', add
	label define bpld_lbl 60020 `"Benin"', add
	label define bpld_lbl 60021 `"Burkina Faso"', add
	label define bpld_lbl 60022 `"Gambia"', add
	label define bpld_lbl 60023 `"Ghana"', add
	label define bpld_lbl 60024 `"Guinea"', add
	label define bpld_lbl 60025 `"Guinea-Bissau"', add
	label define bpld_lbl 60026 `"Ivory Coast"', add
	label define bpld_lbl 60027 `"Liberia"', add
	label define bpld_lbl 60028 `"Mali"', add
	label define bpld_lbl 60029 `"Mauritania"', add
	label define bpld_lbl 60030 `"Niger"', add
	label define bpld_lbl 60031 `"Nigeria"', add
	label define bpld_lbl 60032 `"Senegal"', add
	label define bpld_lbl 60033 `"Sierra Leone"', add
	label define bpld_lbl 60034 `"Togo"', add
	label define bpld_lbl 60038 `"Western Africa, ns"', add
	label define bpld_lbl 60039 `"French West Africa, ns"', add
	label define bpld_lbl 60040 `"British Indian Ocean Territory"', add
	label define bpld_lbl 60041 `"Burundi"', add
	label define bpld_lbl 60042 `"Comoros"', add
	label define bpld_lbl 60043 `"Djibouti"', add
	label define bpld_lbl 60044 `"Ethiopia"', add
	label define bpld_lbl 60045 `"Kenya"', add
	label define bpld_lbl 60046 `"Madagascar"', add
	label define bpld_lbl 60047 `"Malawi"', add
	label define bpld_lbl 60048 `"Mauritius"', add
	label define bpld_lbl 60049 `"Mozambique"', add
	label define bpld_lbl 60050 `"Reunion"', add
	label define bpld_lbl 60051 `"Rwanda"', add
	label define bpld_lbl 60052 `"Seychelles"', add
	label define bpld_lbl 60053 `"Somalia"', add
	label define bpld_lbl 60054 `"Tanzania"', add
	label define bpld_lbl 60055 `"Uganda"', add
	label define bpld_lbl 60056 `"Zambia"', add
	label define bpld_lbl 60057 `"Zimbabwe"', add
	label define bpld_lbl 60058 `"Bassas de India"', add
	label define bpld_lbl 60059 `"Europa"', add
	label define bpld_lbl 60060 `"Gloriosos"', add
	label define bpld_lbl 60061 `"Juan de Nova"', add
	label define bpld_lbl 60062 `"Mayotte"', add
	label define bpld_lbl 60063 `"Tromelin"', add
	label define bpld_lbl 60064 `"Eastern Africa, nec/ns"', add
	label define bpld_lbl 60065 `"Eritrea"', add
	label define bpld_lbl 60070 `"Central Africa"', add
	label define bpld_lbl 60071 `"Angola"', add
	label define bpld_lbl 60072 `"Cameroon"', add
	label define bpld_lbl 60073 `"Central African Republic"', add
	label define bpld_lbl 60074 `"Chad"', add
	label define bpld_lbl 60075 `"Congo"', add
	label define bpld_lbl 60076 `"Equatorial Guinea"', add
	label define bpld_lbl 60077 `"Gabon"', add
	label define bpld_lbl 60078 `"Sao Tome and Principe"', add
	label define bpld_lbl 60079 `"Zaire"', add
	label define bpld_lbl 60080 `"Central Africa, ns"', add
	label define bpld_lbl 60081 `"Equatorial Africa, ns"', add
	label define bpld_lbl 60082 `"French Equatorial Africa, ns"', add
	label define bpld_lbl 60090 `"Southern Africa:"', add
	label define bpld_lbl 60091 `"Botswana"', add
	label define bpld_lbl 60092 `"Lesotho"', add
	label define bpld_lbl 60093 `"Namibia"', add
	label define bpld_lbl 60094 `"South Africa (Union of)"', add
	label define bpld_lbl 60095 `"Swaziland"', add
	label define bpld_lbl 60096 `"Southern Africa, ns"', add
	label define bpld_lbl 60099 `"Africa, ns/nec"', add
	label define bpld_lbl 70000 `"Australia and New Zealand"', add
	label define bpld_lbl 70010 `"Australia"', add
	label define bpld_lbl 70011 `"Ashmore and Cartier Islands"', add
	label define bpld_lbl 70012 `"Coral Sea Islands Territory"', add
	label define bpld_lbl 70013 `"Christmas Island"', add
	label define bpld_lbl 70014 `"Cocos Islands"', add
	label define bpld_lbl 70020 `"New Zealand"', add
	label define bpld_lbl 71000 `"Pacific Islands"', add
	label define bpld_lbl 71010 `"New Caledonia"', add
	label define bpld_lbl 71012 `"Papua New Guinea"', add
	label define bpld_lbl 71013 `"Solomon Islands"', add
	label define bpld_lbl 71014 `"Vanuatu (New Hebrides)"', add
	label define bpld_lbl 71015 `"Fiji"', add
	label define bpld_lbl 71016 `"Melanesia, ns"', add
	label define bpld_lbl 71017 `"Norfolk Islands"', add
	label define bpld_lbl 71018 `"Niue"', add
	label define bpld_lbl 71020 `"Cook Islands"', add
	label define bpld_lbl 71022 `"French Polynesia"', add
	label define bpld_lbl 71023 `"Tonga"', add
	label define bpld_lbl 71024 `"Wallis and Futuna Islands"', add
	label define bpld_lbl 71025 `"Western Samoa"', add
	label define bpld_lbl 71026 `"Pitcairn Island"', add
	label define bpld_lbl 71027 `"Tokelau"', add
	label define bpld_lbl 71028 `"Tuvalu"', add
	label define bpld_lbl 71029 `"Polynesia, ns"', add
	label define bpld_lbl 71032 `"Kiribati"', add
	label define bpld_lbl 71033 `"Canton and Enderbury"', add
	label define bpld_lbl 71034 `"Nauru"', add
	label define bpld_lbl 71039 `"Micronesia, ns"', add
	label define bpld_lbl 71040 `"US Pacific Trust Territories"', add
	label define bpld_lbl 71041 `"Marshall Islands"', add
	label define bpld_lbl 71042 `"Micronesia"', add
	label define bpld_lbl 71043 `"Kosrae"', add
	label define bpld_lbl 71044 `"Pohnpei"', add
	label define bpld_lbl 71045 `"Truk"', add
	label define bpld_lbl 71046 `"Yap"', add
	label define bpld_lbl 71047 `"Northern Mariana Islands"', add
	label define bpld_lbl 71048 `"Palau"', add
	label define bpld_lbl 71049 `"Pacific Trust Terr, ns"', add
	label define bpld_lbl 71050 `"Clipperton Island"', add
	label define bpld_lbl 71090 `"Oceania, ns/nec"', add
	label define bpld_lbl 80000 `"Antarctica, ns/nec"', add
	label define bpld_lbl 80010 `"Bouvet Islands"', add
	label define bpld_lbl 80020 `"British Antarctic Terr."', add
	label define bpld_lbl 80030 `"Dronning Maud Land"', add
	label define bpld_lbl 80040 `"French Southern and Antarctic Lands"', add
	label define bpld_lbl 80050 `"Heard and McDonald Islands"', add
	label define bpld_lbl 90000 `"Abroad (unknown) or at sea"', add
	label define bpld_lbl 90010 `"Abroad, ns"', add
	label define bpld_lbl 90011 `"Abroad (US citizen)"', add
	label define bpld_lbl 90020 `"At sea"', add
	label define bpld_lbl 90021 `"At sea (US citizen)"', add
	label define bpld_lbl 90022 `"At sea or abroad (U.S. citizen)"', add
	label define bpld_lbl 95000 `"Other, nec"', add
	label define bpld_lbl 99900 `"Missing/blank"', add
	label values bpld bpld_lbl

	label define educd_lbl 000 `"N/A or no schooling"'
	label define educd_lbl 001 `"N/A"', add
	label define educd_lbl 002 `"No schooling completed"', add
	label define educd_lbl 010 `"Nursery school to grade 4"', add
	label define educd_lbl 011 `"Nursery school, preschool"', add
	label define educd_lbl 012 `"Kindergarten"', add
	label define educd_lbl 013 `"Grade 1, 2, 3, or 4"', add
	label define educd_lbl 014 `"Grade 1"', add
	label define educd_lbl 015 `"Grade 2"', add
	label define educd_lbl 016 `"Grade 3"', add
	label define educd_lbl 017 `"Grade 4"', add
	label define educd_lbl 020 `"Grade 5, 6, 7, or 8"', add
	label define educd_lbl 021 `"Grade 5 or 6"', add
	label define educd_lbl 022 `"Grade 5"', add
	label define educd_lbl 023 `"Grade 6"', add
	label define educd_lbl 024 `"Grade 7 or 8"', add
	label define educd_lbl 025 `"Grade 7"', add
	label define educd_lbl 026 `"Grade 8"', add
	label define educd_lbl 030 `"Grade 9"', add
	label define educd_lbl 040 `"Grade 10"', add
	label define educd_lbl 050 `"Grade 11"', add
	label define educd_lbl 060 `"Grade 12"', add
	label define educd_lbl 061 `"12th grade, no diploma"', add
	label define educd_lbl 062 `"High school graduate or GED"', add
	label define educd_lbl 063 `"Regular high school diploma"', add
	label define educd_lbl 064 `"GED or alternative credential"', add
	label define educd_lbl 065 `"Some college, but less than 1 year"', add
	label define educd_lbl 070 `"1 year of college"', add
	label define educd_lbl 071 `"1 or more years of college credit, no degree"', add
	label define educd_lbl 080 `"2 years of college"', add
	label define educd_lbl 081 `"Associates degree, type not specified"', add
	label define educd_lbl 082 `"Associates degree, occupational program"', add
	label define educd_lbl 083 `"Associates degree, academic program"', add
	label define educd_lbl 090 `"3 years of college"', add
	label define educd_lbl 100 `"4 years of college"', add
	label define educd_lbl 101 `"Bachelors degree"', add
	label define educd_lbl 110 `"5+ years of college"', add
	label define educd_lbl 111 `"6 years of college (6+ in 1960-1970)"', add
	label define educd_lbl 112 `"7 years of college"', add
	label define educd_lbl 113 `"8+ years of college"', add
	label define educd_lbl 114 `"Masters degree"', add
	label define educd_lbl 115 `"Professional degree beyond a bachelors degree"', add
	label define educd_lbl 116 `"Doctoral degree"', add
	label define educd_lbl 999 `"Missing"', add
	label values educd educd_lbl

	label define empstat_lbl 0 `"N/A"'
	label define empstat_lbl 1 `"Employed"', add
	label define empstat_lbl 2 `"Unemployed"', add
	label define empstat_lbl 3 `"Not in labor force"', add
	label values empstat empstat_lbl

	label define classwkrd_lbl 00 `"N/A"'
	label define classwkrd_lbl 10 `"Self-employed"', add
	label define classwkrd_lbl 11 `"Employer"', add
	label define classwkrd_lbl 12 `"Working on own account"', add
	label define classwkrd_lbl 13 `"Self-employed, not incorporated"', add
	label define classwkrd_lbl 14 `"Self-employed, incorporated"', add
	label define classwkrd_lbl 20 `"Works for wages"', add
	label define classwkrd_lbl 21 `"Works on salary (1920)"', add
	label define classwkrd_lbl 22 `"Wage/salary, private"', add
	label define classwkrd_lbl 23 `"Wage/salary at non-profit"', add
	label define classwkrd_lbl 24 `"Wage/salary, government"', add
	label define classwkrd_lbl 25 `"Federal govt employee"', add
	label define classwkrd_lbl 26 `"Armed forces"', add
	label define classwkrd_lbl 27 `"State govt employee"', add
	label define classwkrd_lbl 28 `"Local govt employee"', add
	label define classwkrd_lbl 29 `"Unpaid family worker"', add
	label values classwkrd classwkrd_lbl

	label define uhrswork_lbl 00 `"N/A"'
	label define uhrswork_lbl 01 `"1"', add
	label define uhrswork_lbl 02 `"2"', add
	label define uhrswork_lbl 03 `"3"', add
	label define uhrswork_lbl 04 `"4"', add
	label define uhrswork_lbl 05 `"5"', add
	label define uhrswork_lbl 06 `"6"', add
	label define uhrswork_lbl 07 `"7"', add
	label define uhrswork_lbl 08 `"8"', add
	label define uhrswork_lbl 09 `"9"', add
	label define uhrswork_lbl 10 `"10"', add
	label define uhrswork_lbl 11 `"11"', add
	label define uhrswork_lbl 12 `"12"', add
	label define uhrswork_lbl 13 `"13"', add
	label define uhrswork_lbl 14 `"14"', add
	label define uhrswork_lbl 15 `"15"', add
	label define uhrswork_lbl 16 `"16"', add
	label define uhrswork_lbl 17 `"17"', add
	label define uhrswork_lbl 18 `"18"', add
	label define uhrswork_lbl 19 `"19"', add
	label define uhrswork_lbl 20 `"20"', add
	label define uhrswork_lbl 21 `"21"', add
	label define uhrswork_lbl 22 `"22"', add
	label define uhrswork_lbl 23 `"23"', add
	label define uhrswork_lbl 24 `"24"', add
	label define uhrswork_lbl 25 `"25"', add
	label define uhrswork_lbl 26 `"26"', add
	label define uhrswork_lbl 27 `"27"', add
	label define uhrswork_lbl 28 `"28"', add
	label define uhrswork_lbl 29 `"29"', add
	label define uhrswork_lbl 30 `"30"', add
	label define uhrswork_lbl 31 `"31"', add
	label define uhrswork_lbl 32 `"32"', add
	label define uhrswork_lbl 33 `"33"', add
	label define uhrswork_lbl 34 `"34"', add
	label define uhrswork_lbl 35 `"35"', add
	label define uhrswork_lbl 36 `"36"', add
	label define uhrswork_lbl 37 `"37"', add
	label define uhrswork_lbl 38 `"38"', add
	label define uhrswork_lbl 39 `"39"', add
	label define uhrswork_lbl 40 `"40"', add
	label define uhrswork_lbl 41 `"41"', add
	label define uhrswork_lbl 42 `"42"', add
	label define uhrswork_lbl 43 `"43"', add
	label define uhrswork_lbl 44 `"44"', add
	label define uhrswork_lbl 45 `"45"', add
	label define uhrswork_lbl 46 `"46"', add
	label define uhrswork_lbl 47 `"47"', add
	label define uhrswork_lbl 48 `"48"', add
	label define uhrswork_lbl 49 `"49"', add
	label define uhrswork_lbl 50 `"50"', add
	label define uhrswork_lbl 51 `"51"', add
	label define uhrswork_lbl 52 `"52"', add
	label define uhrswork_lbl 53 `"53"', add
	label define uhrswork_lbl 54 `"54"', add
	label define uhrswork_lbl 55 `"55"', add
	label define uhrswork_lbl 56 `"56"', add
	label define uhrswork_lbl 57 `"57"', add
	label define uhrswork_lbl 58 `"58"', add
	label define uhrswork_lbl 59 `"59"', add
	label define uhrswork_lbl 60 `"60"', add
	label define uhrswork_lbl 61 `"61"', add
	label define uhrswork_lbl 62 `"62"', add
	label define uhrswork_lbl 63 `"63"', add
	label define uhrswork_lbl 64 `"64"', add
	label define uhrswork_lbl 65 `"65"', add
	label define uhrswork_lbl 66 `"66"', add
	label define uhrswork_lbl 67 `"67"', add
	label define uhrswork_lbl 68 `"68"', add
	label define uhrswork_lbl 69 `"69"', add
	label define uhrswork_lbl 70 `"70"', add
	label define uhrswork_lbl 71 `"71"', add
	label define uhrswork_lbl 72 `"72"', add
	label define uhrswork_lbl 73 `"73"', add
	label define uhrswork_lbl 74 `"74"', add
	label define uhrswork_lbl 75 `"75"', add
	label define uhrswork_lbl 76 `"76"', add
	label define uhrswork_lbl 77 `"77"', add
	label define uhrswork_lbl 78 `"78"', add
	label define uhrswork_lbl 79 `"79"', add
	label define uhrswork_lbl 80 `"80"', add
	label define uhrswork_lbl 81 `"81"', add
	label define uhrswork_lbl 82 `"82"', add
	label define uhrswork_lbl 83 `"83"', add
	label define uhrswork_lbl 84 `"84"', add
	label define uhrswork_lbl 85 `"85"', add
	label define uhrswork_lbl 86 `"86"', add
	label define uhrswork_lbl 87 `"87"', add
	label define uhrswork_lbl 88 `"88"', add
	label define uhrswork_lbl 89 `"89"', add
	label define uhrswork_lbl 90 `"90"', add
	label define uhrswork_lbl 91 `"91"', add
	label define uhrswork_lbl 92 `"92"', add
	label define uhrswork_lbl 93 `"93"', add
	label define uhrswork_lbl 94 `"94"', add
	label define uhrswork_lbl 95 `"95"', add
	label define uhrswork_lbl 96 `"96"', add
	label define uhrswork_lbl 97 `"97"', add
	label define uhrswork_lbl 98 `"98"', add
	label define uhrswork_lbl 99 `"99 (Topcode)"', add
	label values uhrswork uhrswork_lbl
*
* 2.2: Keep right years, employed wage workers, define log-wage and schooling, etc.
*

	keep if year == 2004
	
	* Drop if wages are imputed: dangerous for immigrants
	drop if qincwage == 4 & bpld > 09900

	* Employed wage workers. 
	keep if emp == 1 & classwkrd >= 22 & classwkrd <= 28
	keep if age >= 16 & age <= 70
	gen logwage = log(incwage/(uhrswork*wkswork1)) if incwage > 0 & uhrswork > 0 & wkswork1 > 0
	
* Recode schooling. Use all available information.
	gen yrschl = 0 if educd == 2 | educd == 11 | educd == 12
	replace yrschl = 2 if educd == 10
	replace yrschl = 2.5 if educd == 13
	replace yrschl = 1 if educd == 14
	replace yrschl = 2 if educd == 15
	replace yrschl = 3 if educd == 16
	replace yrschl = 4 if educd == 17
	replace yrschl = 6.5 if educd == 20
	replace yrschl = 5.5 if educd == 21
	replace yrschl = 5 if educd == 22
	replace yrschl = 6 if educd == 23
	replace yrschl = 7.5 if educd == 24
	replace yrschl = 7 if educd == 25
	replace yrschl = 8 if educd == 26
	replace yrschl = 9 if educd == 30
	replace yrschl = 10 if educd == 40
	replace yrschl = 11 if educd == 50
	replace yrschl = 12 if educd == 60 | educd == 61 | educd == 62 | educd == 63 | educd == 64 | educd == 65
	replace yrschl = 13 if educd == 70 | educd == 71
	replace yrschl = 14 if educd == 80 | educd == 81 | educd == 82 | educd == 83
	replace yrschl = 15 if educd == 90
	replace yrschl = 16 if educd == 100 | educd == 101
	replace yrschl = 17 if educd == 110
	replace yrschl = 18 if educd == 111 | educd == 114
	replace yrschl = 19 if educd == 112
	replace yrschl = 20 if educd == 113 | educd == 115 | educd == 116	
	
* Aggregate and clean birth-country codes. 
	keep if bpld < 95000
	replace bpld = 09900 if bpld < 10000
* Merge together UK
	replace bpld = 41300 if (bpld >= 41000 & bpld <= 41300) | bpld == 41410
* Merge together USVI
	replace bpld = 11500 if bpld == 11510 | bpld == 11520 | bpld == 11530
* Merge together Portugal
	replace bpld = 43600 if bpld >= 43600 & bpld <= 43640
* Merge together Germany
	replace bpld = 45300 if bpld >= 45300 & bpld <= 45362
* Merge together Korea
	replace bpld = 50200 if bpld >= 50200 & bpld <= 50220
* Merge together Yemen
	replace bpld = 54400 if bpld == 54500 
* Keep only valid birthplaces (drop not elsewhere specified and so on).
	keep if  bpld == 09900 | bpld == 11000 | bpld == 11500 | bpld == 15000 | ///
	bpld == 16010 | bpld == 16020 | bpld == 20000 | bpld == 21010 | bpld == 21020 | ///
	bpld == 21030 | bpld == 21040 | bpld == 21050 | bpld == 21060 | bpld == 21070 | ///
	bpld == 25000 | bpld == 26010 | bpld == 26020 | bpld == 26030 | bpld == 26042 | ///
	bpld == 26043 | bpld == 26044 | bpld == 26054 | bpld == 26055 | bpld == 26057 | ///
	bpld == 26058 | bpld == 26059 | bpld == 26060 | bpld == 30005 | bpld == 30010 | ///
	bpld == 30015 | bpld == 30020 | bpld == 30025 | bpld == 30030 | bpld == 30040 | ///
	bpld == 30045 | bpld == 30050 | bpld == 30060 | bpld == 30065 | bpld == 40000 | ///
	bpld == 40100 | bpld == 40200 | bpld == 40400 | bpld == 40500 | bpld == 41300 | ///
	bpld == 41400 | bpld == 42000 | bpld == 42100 | bpld == 42500 | bpld == 42600 | ///
	bpld == 43000 | bpld == 43300 | bpld == 43330 | bpld == 43400 | bpld == 43600 | ///
	bpld == 43610 | bpld == 43800 | bpld == 45000 | bpld == 45100 | bpld == 45200 | ///
	bpld == 45212 | bpld == 45213 | bpld == 45300 | bpld == 45400 | bpld == 45500 | ///
	bpld == 45600 | bpld == 45700 | bpld == 45710 | bpld == 45730 | bpld == 45740 | ///
	bpld == 45790 | bpld == 46000 | bpld == 46100 | bpld == 46200 | bpld == 46500 | bpld == 46510 | ///
	bpld == 46520 | bpld == 46530 | bpld == 46540 | bpld == 46541 | bpld == 46542 | ///
	bpld == 46547 | bpld == 46590 | bpld == 50000 | bpld == 50010 | bpld == 50040 | bpld == 50100 | ///
	bpld == 50200 | bpld == 51100 | bpld == 51200 | bpld == 51300 | bpld == 51400 | ///
	bpld == 51500 | bpld == 51600 | bpld == 51700 | bpld == 51800 | bpld == 52000 | ///
	bpld == 52100 | bpld == 52110 | bpld == 52130 | bpld == 52140 | bpld == 52150 | ///
	bpld == 52200 | bpld == 52400 | bpld == 53100 | bpld == 53200 | bpld == 53400 | ///
	bpld == 53500 | bpld == 53600 | bpld == 53700 | bpld == 54000 | bpld == 54100 | ///
	bpld == 54200 | bpld == 54400 | bpld == 60011 | bpld == 60012 | bpld == 60013 | ///
	bpld == 60014 | bpld == 60015 | bpld == 60023 | bpld == 60027 | bpld == 60031 | ///
	bpld == 60032 | bpld == 60033 | bpld == 60044 | bpld == 60045 | bpld == 60053 | ///
	bpld == 60054 | bpld == 60055 | bpld == 60057 | bpld == 60065 | bpld == 60072 | ///
	bpld == 60094 | bpld == 70010 | bpld == 70020 | bpld == 71021 | bpld == 71023 | ///
	bpld == 71025 | bpld == 71042
	
	* Keep any American or immigrants without US schooling
	keep if (bpld == 09900) | (bpld > 09900 & ((year - age) + (yrschl + 6) <= yrimmig))
	
	save ./temp/uscensus.dta, replace
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 3: Mean wage for natives

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/	

*
* 3.1: Mean wage
*

	keep if bpld <= 09900
	collapse (mean) usmeanlogwage = logwage [aw=perwt]
	save ./temp/usmeanwage.dta, replace


*
* 3.1: Mean wage by occupation and industry
*

	use ./temp/uscensus.dta, clear
	keep if bpld <= 09900
	collapse (mean) wage_newocc = logwage (sd) sigma_wage_newocc = logwage [aw=perwt], by(occ)
	rename occ newocc
	save ./temp/meanwage_newocc.dta, replace
	preserve
	keep if newocc == 3060 | newocc == 9140
	replace wage_newocc = exp(wage_newocc)
	export delimited using "./output/doctors_taxis", replace
	restore
	rename newocc oldocc
	rename wage_newocc wage_oldocc
	rename sigma_wage_newocc sigma_wage_oldocc
	save ./temp/meanwage_oldocc.dta, replace
	
	use ./temp/uscensus.dta, clear
	keep if bpld <= 09900
	collapse (mean) wage_newind = logwage (sd) sigma_wage_newind = logwage [aw=perwt], by(ind)
	rename ind newind
	save ./temp/meanwage_newind.dta, replace
	rename newind oldind
	rename wage_newind wage_oldind
	rename sigma_wage_newind sigma_wage_oldind
	save ./temp/meanwage_oldind.dta, replace
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 4: Immigrant characteristics by source country.

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/	

*
* 4.1: Basic characteristics by GDP per worker category. 
* 

	use ./temp/uscensus.dta, clear
	drop if bpld <= 09900
	merge m:1 bpld using ./temp/iso_bpld.dta
	keep if _merge == 3
	drop _merge*
	merge m:1 iso using ./temp/gdp2005.dta
	keep if _merge == 3
	drop _merge*
	
	gen gdpcat = 1 if gdp2005 > 16 & !missing(gdp2005)
	replace gdpcat = 2 if gdp2005 >= 8 & gdp2005 < 16
	replace gdpcat = 3 if gdp2005 >= 4 & gdp2005 < 8
	replace gdpcat = 4 if gdp2005 >= 2 & gdp2005 < 4
	replace gdpcat = 5 if gdp2005 <= 2 & !missing(gdp2005)
	drop if missing(gdpcat)
	
	collapse (mean) logwage_uscensus = logwage yrschl_uscensus = yrschl age_uscensus = age [aw=perwt], by(gdpcat)
	
	save ./temp/uscensus_immcompare.dta, replace	

*
* 4.2: Basic characteristics by birthplace and year of immigration
*

	use ./temp/uscensus.dta, clear
	drop if bpld <= 09900
	collapse (mean) logwage [aw=perwt], by(bpld yrimmig)
	merge m:1 bpld using ./temp/iso_bpld.dta
	drop if _merge < 3
	drop _merge
	rename logwage logwage_census 
	drop bpld
	save ./temp/uscensusestimates.dta, replace
	
/*

*************************************************************************************
*************************************************************************************
*************************************************************************************

Step 5: Compute log-wage corrections for observables

*************************************************************************************
*************************************************************************************
*************************************************************************************

*/

*
* 5.1: Load and clean the data. 
*

	use ./temp/uscensus.dta, clear
	
	* Keep natives
	keep if bpld <= 09900
	
	* Age bins
	gen agebin = 5*floor(age/5)
	replace agebin = 65 if agebin > 65
	
*
* 5.2: Fit and save a sequence of wage models for natives. 
*
	
	reg logwage yrschl i.agebin [aw=perwt]
	parmest, norestore
	keep parm estimate
	drop if parm == "_cons"
	gen age = substr(parm,1,2)
	destring age, replace force
	replace age = 0 if missing(age)
	keep estimate age
	gen i = 1
	reshape wide estimate, i(i) j(age)
	rename estimate0 estimate_yrschl
	drop i
	save ./temp/estimates_1.dta, replace
		
*
* 5.3: Read in Barro-Lee, compute year 2000 mean education and age distribution by bin.
*

	use "./raw data/barro lee/BL2013_MF_v2.0.dta", clear
	keep if year == 2000
	
	gen yrschl = yr_sch if agefrom == 15 & ageto == 999
	egen yrschl2 = max(yrschl), by(country)
	gen totpop = pop if agefrom == 15 & ageto == 999
	egen totpop2 = max(totpop), by(country)
	gen popfrac = pop/totpop2
	keep country agefrom ageto yrschl2 popfrac
	drop if (agefrom == 15 | agefrom == 25) & ageto == 999
	drop ageto
	reshape wide popfrac, i(country yrschl2) j(agefrom)
	rename yrschl2 yrschl
	replace popfrac65 = popfrac65 + popfrac70 + popfrac75
	drop popfrac70 popfrac75
	
	save ./temp/s_a.dta, replace
	
	
*
* 5.4: Cross with estimates, produce implied country human capital.
*

	* Version 1
	cross using ./temp/estimates_1.dta
	gen loghnonmig = yrschl*estimate_yrschl
	forvalues x = 15(5)65 {
		replace loghnonmig = loghnonmig + popfrac`x' *estimate`x'
	}
	
	keep country loghnonmig yrschl
	rename yrschl yrschl_nonmig
	rename country name
	replace name = upper(name)
	merge 1:1 name using ./temp/country_iso.dta
	keep if _merge == 3 & !missing(iso)
	keep iso loghnonmig yrschl_nonmig
	
	save ./temp/h_nonmig_1.dta, replace
	
*
* 5.5: Merge estimates with immigrants, generate residual wages. 
*
	
	use ./temp/uscensus.dta, clear
	
	* Keep immigrants
	keep if bpld > 09900
	gen yrschl_high = max(0,yrschl-12)
	gen agebin = 5*floor(age/5)
	replace agebin = 65 if agebin > 65
	
	cross using ./temp/estimates_1.dta
	gen residual = logwage - yrschl*estimate_yrschl
	forvalues x = 15(5)65 {
		replace residual = residual - estimate`x' if agebin == `x'
	}
	drop estimate*
	
*
* 5.6: Merge on GDP data, run Hendricks regressions
*		
	
	merge m:1 bpld using ./temp/iso_bpld.dta
	keep if _merge == 3
	drop _merge*
	merge m:1 iso using ./temp/gdp2005.dta
	keep if _merge == 3
	drop _merge*
	gen loggdp2005 = log(1/gdp2005)
	
	collapse (mean) residual loggdp2005 [aw=perwt], by(iso)
	
	reg residual loggdp2005

*
* Program Finished.
*
	
	