// ##############################################################################################
// *
// * dofile: Sovereign_02_IssuerRatings.do
// * author: Finn Marten Körner
// * last edit: 30/11/2012
// * source data:  /CRA/Data/data/SP/SovereignsTotal/FullEntityData_SP.csv
// *			   /CRA/Data/data/Moodys/LT_Issuer_Ratings/Sovereigns_SenDL_FullRatingInfo.csv
// * target data:  /CRA/Data/output/analysis/IssuerRatings_LTForeign_AnnualPanel
// *
// * ORGANISATION:
// * 0. PRELIMINARIES
// # 1.	PREPARE S&P DATASET
// # 2.	PREPARE MOODY'S DATASET
// # 3.	APPEND S&P DATASET
// # 4.	CREATE PANEL DATASET OF LT FOREIGN ISSUER RATINGS
// # 5.	MERGE PANEL DATASET WITH MACRO DATA
// ##############################################################################################

// ##############################################################################################
// # 0. PRELIMINARIES
// ##############################################################################################

clear
clear matrix
set mem 900m
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
if "`os'" == "Windows" 	global zentra "C:\Users\`user'\PowerFolders\CRA\Data"

cd
cd $zentra
// cd $data

// program def stcmd
// shell "$st\st" `0'
// end

local replace = "TRUE"
// local replace = "FALSE"

// ##############################################################################################
// # 1.	PREPARE S&P DATASET
// ##############################################################################################

if "`replace'" == "TRUE" {
	// Read dataset
	clear
	insheet using data/SP/SovereignsTotal/FullEntityData_SP.csv, comma names

	di as result "Generate numeric date variables"
	foreach var in ratingdate creditwatchoutlookdate {
		gen `var'str = `var'
		destring `var', force replace
		replace `var' = date(`var'str, "DMY")
		format `var' %td
		drop `var'str
	}

	di as result "Rename country names for merging with UN dataset"
	rename issuer countryorareaname
	forvalues i = 1/`=_N' {
		qui replace countryorareaname = subinstr(countryorareaname[`i'],"_"," ",.) in `i'
		qui replace countryorareaname = trim(countryorareaname)
	}
	di as result "Individually rename some countries"
	replace countryorareaname = "United Arab Emirates" if countryorareaname == "Abu Dhabi"
	replace countryorareaname = "Bolivia (Plurinational State of)" if countryorareaname == "Bolivia"
	replace countryorareaname = "Cura`=char(141)'ao" if countryorareaname == "Curacao"
	replace countryorareaname = "Hong Kong Special Administrative Region" if countryorareaname == "Hong Kong"
	replace countryorareaname = "Isle of Man" if countryorareaname == "Isle Of Man"
	replace countryorareaname = "Republic of Korea" if countryorareaname == "Korea"
	replace countryorareaname = "Former Yugoslav Republic of Macedonia" if countryorareaname == "Macedonia"
	replace countryorareaname = "United Arab Emirates" if countryorareaname == "Ras Al Khaimah"
	replace countryorareaname = "United Kingdom of Great Britain and Northern Ireland" if countryorareaname == "United Kingdom"
	replace countryorareaname = "United States of America" if countryorareaname == "United States Of America"
	replace countryorareaname = "Venezuela (Bolivarian Republic of)" if countryorareaname == "Venezuela"
	replace countryorareaname = "Viet Nam" if countryorareaname == "Vietnam"

	di as result "Merge with UN country codes"
	tab countryorareaname
	merge m:m countryorareaname using $zentra/${data}UN/UN_country_codes
	tab countryorareaname if _merge == 1
	di as result "Drop unused countries from using dataset (UN)"
	drop if _merge == 2
	drop _merge v1

	di as result "Unify final data structure for merging"
	di as result "Generate agency variable (1 = Moodys, 2 = S&P)"
	gen agency = 2
	label define agency_label 1 "Moody's" 2 "S&P's"
	label values agency agency_label
	label variable agency "Credit rating agency (1=Moody's, 2=S&P)"
	replace ratingdate = creditwatchoutlookdate if ratingdate < creditwatchoutlookdate & creditwatchoutlookdate != .
	drop creditwatchoutlookdate

	order numericalcode isoalpha3code countryorareaname agency issuercreditrating rating ratingdate ratingaction creditwatchoutlook

	save $zentra/data/SP/SovereignsTotal/FullEntityData_SP, replace
}

// ##############################################################################################
// # 2.	PREPARE MOODY'S DATASET
// ##############################################################################################

if "`replace'" == "TRUE" {
	clear
	insheet using $zentra/data/Moodys/LT_Issuer_Ratings/Sovereigns_FullRatingInfo.csv, comma names

	di as result "Drop not needed variables and convert others"
	keep if substr(senioritydebtlist, 4, length("Issuer Rating")) == "Issuer Rating"
	drop isinx v1 file id debtdescription coupon maturity isiny saledate facevalue support type entity seniorityspecialdebt endorsement releasingoffice solicitation
	rename senioritydebtlist seniority
	foreach var in date dateratingaction {
		gen `var'str = `var'
		destring `var', force replace
		replace `var' = date(`var'str, "DMY")
		format `var' %td
		drop `var'str
	}
	replace seniority = "LT Issuer Rating (Foreign)" if seniority == "LT Issuer Rating" & currency == ""
	replace seniority = "ST Issuer Rating (Foreign)" if seniority == "ST Issuer Rating" & currency == ""
	replace seniority = "ST Issuer Rating (Domestic)" if seniority == "ST Issuer Rating" & currency != ""

	di as result "Rename country names for merging with UN dataset"
	rename country countryorareaname

	replace countryorareaname = "Bolivia (Plurinational State of)" if countryorareaname == "Bolivia"
	replace countryorareaname = "Hong Kong Special Administrative Region" if countryorareaname == "Hong Kong"
	replace countryorareaname = "Republic of Korea" if countryorareaname == "Korea"
	replace countryorareaname = "China, Macao Special Administrative Region" if countryorareaname == "Macao"
	replace countryorareaname = "Republic of Moldova" if countryorareaname == "Moldova"
	replace countryorareaname = "Saint Vincent and the Grenadines" if countryorareaname == "St. Vincent and the Grenadines, Gov-t of"
	replace countryorareaname = "Trinidad and Tobago" if countryorareaname == "Trinidad & Tobago"
	replace countryorareaname = "United Kingdom of Great Britain and Northern Ireland" if countryorareaname == "United Kingdom"
	replace countryorareaname = "Venezuela (Bolivarian Republic of)" if countryorareaname == "Venezuela"
	replace countryorareaname = "Viet Nam" if countryorareaname == "Vietnam"
	replace countryorareaname = "" if countryorareaname == ""

	di as result "Merge with UN country codes"
	tab countryorareaname
	merge m:m countryorareaname using $zentra/${data}UN/UN_country_codes
	tab countryorareaname if _merge == 1
	di as result "Drop unused countries from using dataset (UN)"
	drop if _merge == 2
	drop _merge

	di as result "Unify final data structure for merging"
	drop rating date lastratingaction watchstatus
	rename dateratingaction ratingdate
	rename newrating rating
	rename seniority issuercreditrating
	gen creditwatchoutlook = rating if ratingaction == "ON WATCH"

	di as result "Generate agency variable (1 = Moodys, 2 = S&P)"
	gen agency = 1
	label define agency_label 1 "Moody's" 2 "S&P's"
	label values agency agency_label
	label variable agency "Credit rating agency (1=Moody's, 2=S&P)"
	order numericalcode isoalpha3code countryorareaname agency issuercreditrating rating ratingdate ratingaction creditwatchoutlook currency

	compress
	save $zentra/data/Moodys/LT_Issuer_Ratings/Sovereigns_FullRatingInfo, replace
}

// ##############################################################################################
// # 3.	APPEND S&P DATASET
// ##############################################################################################

if "`replace'" == "TRUE" {
clear
use $zentra/data/Moodys/LT_Issuer_Ratings/Sovereigns_FullRatingInfo
append using $zentra/data/SP/SovereignsTotal/FullEntityData_SP

di as result "Generate new IssuerType variable"
gen issuertype = .
replace issuertype = 1 if issuercreditrating == "Foreign Long-Term" | issuercreditrating == "LT Issuer Rating (Foreign)"
replace issuertype = 2 if issuercreditrating == "Local Long-Term" | issuercreditrating == "LT Issuer Rating (Domestic)"
replace issuertype = 3 if issuercreditrating == "Foreign Short-Term" | issuercreditrating == "ST Issuer Rating (Foreign)"
replace issuertype = 4 if issuercreditrating == "Local Short-Term" | issuercreditrating == "ST Issuer Rating (Domestic)"
replace issuertype = 5 if issuertype == .
label define issuertype_label 1 "LT Foreign" 2 "LT Domestic" 3 "ST Foreign" 4 "ST Domestic" 5 "Regional"
label values issuertype issuertype_label
label variable issuertype "Type of Issuer (LT, ST, Foreign, Domestic, Regional)"
tab issuercreditrating issuertype
move issuertype agency
drop issuercreditrating

di as result "Generate new RatingAction variable"
rename ratingaction ratingactionstr
gen ratingaction = .
replace ratingaction = 0 if ratingactionstr == "New" | ratingactionstr == "New Rating" | ratingactionstr == "New Rating, CreditWatch/ Outlook"
replace ratingaction = 1 if ratingactionstr == "Upgrade" | ratingactionstr == "Upgraded" | ratingactionstr == "Upgrade, CreditWatch/ Outlook"
replace ratingaction = 2 if ratingactionstr == "Downgrade" | ratingactionstr == "Downgrade, CreditWatch/ Outlook"
replace ratingaction = 3 if ratingactionstr == "Reinstated" | ratingactionstr == "Confirmed"
replace ratingaction = 4 if ratingactionstr == "CreditWatch/ Outlook" | ratingactionstr == "Possible Upgrade"  | ratingactionstr == "Possible Downgrade"
replace ratingaction = 5 if ratingactionstr == "Not Rated" | ratingactionstr == "Not Rated, CreditWatch/ Outlook"
replace ratingaction = 6 if ratingactionstr == "Withdrawn" | ratingactionstr == "Decision not to Rate"
label define ratingaction_label 0 "New" 1 "Upgrade" 2 "Downgrade" 3 "Confirmed" 4 "On Watch/Outlook" 5 "Not Rated" 6 "Withdrawn"
label values ratingaction ratingaction_label
label variable ratingaction "RatingAction (Upgrade, Downgrade, Watch, Outlook)"
tab ratingactionstr ratingaction
move ratingaction creditwatchoutlook

di as result "Generate new RatingAction variable"
rename creditwatchoutlook creditwatchoutlookstr
gen creditwatchoutlook = .
replace creditwatchoutlook = -1 if creditwatchoutlookstr == "Watch Neg" | ratingactionstr == "Possible Downgrade"
// replace creditwatchoutlook = -1 if creditwatchoutlookstr == "Negative"
replace creditwatchoutlook = 0 if creditwatchoutlookstr == "Stable" | creditwatchoutlookstr == "Developing"
// replace creditwatchoutlook = 1 if creditwatchoutlookstr == "Positive"
replace creditwatchoutlook = 1 if creditwatchoutlookstr == "Watch Pos" | ratingactionstr == "Possible Upgrade"
// label define creditwatchoutlook_label -2 "Watch Neg" -1 "Outlook Neg" 0 "Stable" 1 "Outlook Pos" 2 "Watch Pos"
label define creditwatchoutlook_label -1 "Watch Neg" 0 "Stable/Dev" 1 "Watch Pos"
label values creditwatchoutlook creditwatchoutlook_label
label variable creditwatchoutlook "Outlook/Watch Status"
tab creditwatchoutlookstr creditwatchoutlook

di as result "Replace rating with last rating if Moody's ON WATCH"
sort numericalcode agency issuertype ratingdate
tab rating if agency == 1 & issuertype[_n] == issuertype[_n-1] & rating == "ON WATCH"
replace rating = rating[_n-1] if agency == 1 & issuertype[_n] == issuertype[_n-1] & country[_n] == country[_n-1] & rating == "ON WATCH"

drop ratingactionstr creditwatchoutlookstr

di as result "Individual ratings replacements for NZL, DNK, CAN for old Moody's methodology (1960s/1970s/1980s)"
replace rating = "Aa2" if ( numericalcode == 554 | numericalcode == 208 | numericalcode == 124 ) & rating == "Aa"
replace rating = "Baa2" if numericalcode == 554 & rating == "Baa"

di as result "Merge numerical rating scales to dataset"
di as result "(1) Merge Moodys rating scale"
foreach var in rating {
	rename `var' moodys_ltr
	merge m:m moodys_ltr using $zentra/${data}RatingScales/RatingScale_Moodys
	drop if _merge == 2
	drop _merge
	rename moodys_ltr `var'
	rename ratingscale20 `var'_20
	rename ratingscale60 `var'_60
	label variable `var'_20 "Rating Scale 20"
	label variable `var'_60 "Rating Scale 60"
	move `var'_20 `var'
	move `var'_60 `var'
}
di as result "(2) Merge S&P rating scale"
foreach var in rating {
	rename `var' sandp_ltr
	merge m:m sandp_ltr using $zentra/${data}RatingScales/RatingScale_SandP
	drop if _merge == 2
	drop _merge
	rename sandp_ltr `var'
	replace `var'_20 = ratingscale20 if `var'_20 == . & ratingscale20 != .
	replace `var'_60 = ratingscale60 if `var'_60 == . & ratingscale60 != .
}
drop ratingscale*

di as result "Add outlook/credit watch status to rating60 variable"
replace rating_60 = rating_60 - creditwatchoutlook if creditwatchoutlook != .

sort numericalcode issuertype ratingdate

compress
save $zentra/output/analysis/IssuerRatings_Moodys_SP, replace
}

// ##############################################################################################
// # 4a.	CREATE PANEL DATASET OF LT FOREIGN ISSUER RATINGS
// ##############################################################################################

if "`replace'" == "TRUE" {
clear
use $zentra/output/analysis/IssuerRatings_Moodys_SP

di as result "Keep if IssuerType is LT Foreign"
keep if issuertype == 1

sort numericalcode agency ratingdate

di as result "Generate panel structure"
generate year = yofd(ratingdate)
label variable year "Year"

gen id = numericalcode*10 + agency
label variable id "ID Numericalcode + Agency"
qui su id
local id = r(min)
local id_max = r(max)
local i = 1
gen n = _n
while `id' <= `id_max' {
	qui su n if id == `id'
	// continue if ID does not exist
	local n = r(N)
	if `n' == 0 continue

	di _newline as result"Evaluate entries for ID "as input "`id'/`id_max'" as result"."
	//	forvalues i = `=r(min)'/`=r(max)' {
	while `i' <= `=r(max)' {
		di as text"Evaluate entry "as input"`i'/`=_N'"as text"."

		// EXAMPLES
		// 1992 	1.	(first rating)
		// 1993 	2.	(second rating)
		// 1993	 	3.	(third rating)
		// 1996 	4.	(fourth rating)
		// 2000 	5. 	(maturity)
		// 2012 	5. 	(end of time-series)

		// 2. continue if next year equal to this year but not end of time-series
		if year[`i'+1] == year[`i'] & id[`i'+1] == id[`i'] & year[`i'] < 2012 {
			di "2. Continue if next entry's year equal to this year but not end of time-series (maturity)"
			local ++i
			continue
		}
		// 3. expand if different year and neither next year nor last year
		if ( year[`i'+1] > year[`i'] & id[`i'+1] == id[`i'] ) | ( id[`i'+1] != id[`i'] & year[`i'] < 2012 ) {
			if year[`i'+1] > year[`i'] & id[`i'+1] == id[`i']  local gap = year[`i'+1] - year[`i'] + 1
			if id[`i'+1] != id[`i'] & year[`i'] < 2012 	local gap = 2012 - year[`i'] + 1
			di "3. Expand if different year and neither same year nor last year"
			di "Duplicate entries forward "as input `gap' as text" times ("as input `gap'-1 as text" new)."
			expand `gap' in `i'
			// Update span of ID variable in n
			sort id year ratingdate
			qui replace n = _n
			qui su n if id == `id'
			// Delete information for rating changes in expanded entries
			forvalues j = 1/`=`gap'-1' {
				if `=`i'+`j'' > _N continue
				qui replace year = year[`i']+`j' in `=`i'+`j''
				qui replace ratingaction = . in `=`i'+`j''
				qui replace creditwatchoutlook = . in `=`i'+`j''
			}
			local i = `i' + `gap'
			continue
		}
		// 5. continue if end of time-series or maturity
		if year[`i'] == 2012  {
			di "1. Continue if end of time-series or maturity"
			local ++i
			continue
		}
		qui su n if id == `id'
		local ++i
	}
	local id = id[`=r(max)+1']
}
sort id year ratingdate
order id
drop n

di as result "Generate days of year for weighting"
gen days = ratingdate[_n+1] - dofy(year) if ( year[_n+1] == year & id[_n+1] == id ) & ( year[_n-1] != year & id[_n-1] == id )
replace days = ratingdate - days[_n-1] - dofy(year) if ( year[_n-1] == year & id[_n-1] == id )
replace days = dofy(year[_n+1]) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = dofy(2013) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] != id & year == 2012)
// replace days = 365 - days[_n+1] - days[_n-1] if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = ratingdate[_n+1] - ratingdate if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = 365 if days == .

di as result "Generate weighted rating"
foreach i in 20 60 {
	gen rating_`i'_w = rating_`i'*days/365
	egen rating_`i'_w_days = total(rating_`i'_w), by(year id)
	replace rating_`i' = rating_`i'_w_days
	drop rating_`i'_w rating_`i'_w_days
}

save $zentra/output/analysis/IssuerRatings_LTForeign_Panel, replace
}

// ##############################################################################################
// # 4b.	CREATE PANEL DATASET OF LT DOMESTIC ISSUER RATINGS
// ##############################################################################################

if "`replace'" == "TRUE" {
clear
use $zentra/output/analysis/IssuerRatings_Moodys_SP

di as result "Keep if IssuerType is LT Foreign"
keep if issuertype == 2

sort numericalcode agency ratingdate

di as result "Generate panel structure"
generate year = yofd(ratingdate)
label variable year "Year"

gen id = numericalcode*10 + agency
label variable id "ID Numericalcode + Agency"
qui su id
local id = r(min)
local id_max = r(max)
local i = 1
gen n = _n
while `id' <= `id_max' {
	qui su n if id == `id'
	// continue if ID does not exist
	local n = r(N)
	if `n' == 0 continue

	di _newline as result"Evaluate entries for ID "as input "`id'/`id_max'" as result"."
	//	forvalues i = `=r(min)'/`=r(max)' {
	while `i' <= `=r(max)' {
		di as text"Evaluate entry "as input"`i'/`=_N'"as text"."

		// EXAMPLES
		// 1992 	1.	(first rating)
		// 1993 	2.	(second rating)
		// 1993	 	3.	(third rating)
		// 1996 	4.	(fourth rating)
		// 2000 	5. 	(maturity)
		// 2012 	5. 	(end of time-series)

		// 2. continue if next year equal to this year but not end of time-series
		if year[`i'+1] == year[`i'] & id[`i'+1] == id[`i'] & year[`i'] < 2012 {
			di "2. Continue if next entry's year equal to this year but not end of time-series (maturity)"
			local ++i
			continue
		}
		// 3. expand if different year and neither next year nor last year
		if ( year[`i'+1] > year[`i'] & id[`i'+1] == id[`i'] ) | ( id[`i'+1] != id[`i'] & year[`i'] < 2012 ) {
			if year[`i'+1] > year[`i'] & id[`i'+1] == id[`i']  local gap = year[`i'+1] - year[`i'] + 1
			if id[`i'+1] != id[`i'] & year[`i'] < 2012 	local gap = 2012 - year[`i'] + 1
			di "3. Expand if different year and neither same year nor last year"
			di "Duplicate entries forward "as input `gap' as text" times ("as input `gap'-1 as text" new)."
			expand `gap' in `i'
			// Update span of ID variable in n
			sort id year ratingdate
			qui replace n = _n
			qui su n if id == `id'
			// Delete information for rating changes in expanded entries
			forvalues j = 1/`=`gap'-1' {
				if `=`i'+`j'' > _N continue
				qui replace year = year[`i']+`j' in `=`i'+`j''
				qui replace ratingaction = . in `=`i'+`j''
				qui replace creditwatchoutlook = . in `=`i'+`j''
			}
			local i = `i' + `gap'
			continue
		}
		// 5. continue if end of time-series or maturity
		if year[`i'] == 2012  {
			di "1. Continue if end of time-series or maturity"
			local ++i
			continue
		}
		qui su n if id == `id'
		local ++i
	}
	local id = id[`=r(max)+1']
}
sort id year ratingdate
order id
drop n

di as result "Generate days of year for weighting"
gen days = ratingdate[_n+1] - dofy(year) if ( year[_n+1] == year & id[_n+1] == id ) & ( year[_n-1] != year & id[_n-1] == id )
replace days = ratingdate - days[_n-1] - dofy(year) if ( year[_n-1] == year & id[_n-1] == id )
replace days = dofy(year[_n+1]) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = dofy(2013) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] != id & year == 2012)
// replace days = 365 - days[_n+1] - days[_n-1] if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = ratingdate[_n+1] - ratingdate if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = 365 if days == .

di as result "Generate weighted rating"
foreach i in 20 60 {
	gen rating_`i'_w = rating_`i'*days/365
	egen rating_`i'_w_days = total(rating_`i'_w), by(year id)
	replace rating_`i' = rating_`i'_w_days
	drop rating_`i'_w rating_`i'_w_days
}

save $zentra/output/analysis/IssuerRatings_LTDomestic_Panel, replace
}

// ##############################################################################################
// # 4.	CREATE PANEL DATASET OF ST FOREIGN ISSUER RATINGS
// ##############################################################################################

if "`replace'" == "TRUE" {
clear
use $zentra/output/analysis/IssuerRatings_Moodys_SP

di as result "Keep if IssuerType is ST Foreign"
keep if issuertype == 3

sort numericalcode agency ratingdate

di as result "Generate panel structure"
generate year = yofd(ratingdate)
label variable year "Year"

gen id = numericalcode*10 + agency
label variable id "ID Numericalcode + Agency"
qui su id
local id = r(min)
local id_max = r(max)
local i = 1
gen n = _n
while `id' <= `id_max' {
	qui su n if id == `id'
	// continue if ID does not exist
	local n = r(N)
	if `n' == 0 continue

	di _newline as result"Evaluate entries for ID "as input "`id'/`id_max'" as result"."
	//	forvalues i = `=r(min)'/`=r(max)' {
	while `i' <= `=r(max)' {
		di as text"Evaluate entry "as input"`i'/`=_N'"as text"."

		// EXAMPLES
		// 1992 	1.	(first rating)
		// 1993 	2.	(second rating)
		// 1993	 	3.	(third rating)
		// 1996 	4.	(fourth rating)
		// 2000 	5. 	(maturity)
		// 2012 	5. 	(end of time-series)

		// 2. continue if next year equal to this year but not end of time-series
		if year[`i'+1] == year[`i'] & id[`i'+1] == id[`i'] & year[`i'] < 2012 {
			di "2. Continue if next entry's year equal to this year but not end of time-series (maturity)"
			local ++i
			continue
		}
		// 3. expand if different year and neither next year nor last year
		if ( year[`i'+1] > year[`i'] & id[`i'+1] == id[`i'] ) | ( id[`i'+1] != id[`i'] & year[`i'] < 2012 ) {
			if year[`i'+1] > year[`i'] & id[`i'+1] == id[`i']  local gap = year[`i'+1] - year[`i'] + 1
			if id[`i'+1] != id[`i'] & year[`i'] < 2012 	local gap = 2012 - year[`i'] + 1
			di "3. Expand if different year and neither same year nor last year"
			di "Duplicate entries forward "as input `gap' as text" times ("as input `gap'-1 as text" new)."
			expand `gap' in `i'
			// Update span of ID variable in n
			sort id year ratingdate
			qui replace n = _n
			qui su n if id == `id'
			// Delete information for rating changes in expanded entries
			forvalues j = 1/`=`gap'-1' {
				if `=`i'+`j'' > _N continue
				qui replace year = year[`i']+`j' in `=`i'+`j''
				qui replace ratingaction = . in `=`i'+`j''
				qui replace creditwatchoutlook = . in `=`i'+`j''
			}
			local i = `i' + `gap'
			continue
		}
		// 5. continue if end of time-series or maturity
		if year[`i'] == 2012  {
			di "1. Continue if end of time-series or maturity"
			local ++i
			continue
		}
		qui su n if id == `id'
		local ++i
	}
	local id = id[`=r(max)+1']
}
sort id year ratingdate
order id
drop n

di as result "Generate days of year for weighting"
gen days = ratingdate[_n+1] - dofy(year) if ( year[_n+1] == year & id[_n+1] == id ) & ( year[_n-1] != year & id[_n-1] == id )
replace days = ratingdate - days[_n-1] - dofy(year) if ( year[_n-1] == year & id[_n-1] == id )
replace days = dofy(year[_n+1]) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = dofy(2013) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] != id & year == 2012)
// replace days = 365 - days[_n+1] - days[_n-1] if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = ratingdate[_n+1] - ratingdate if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = 365 if days == .

di as result "Generate weighted rating"
foreach i in 20 60 {
	gen rating_`i'_w = rating_`i'*days/365
	egen rating_`i'_w_days = total(rating_`i'_w), by(year id)
	replace rating_`i' = rating_`i'_w_days
	drop rating_`i'_w rating_`i'_w_days
}

save $zentra/output/analysis/IssuerRatings_STForeign_Panel, replace
}

// ##############################################################################################
// # 4.	CREATE PANEL DATASET OF ST DOMESTIC ISSUER RATINGS
// ##############################################################################################

if "`replace'" == "TRUE" {
clear
use $zentra/output/analysis/IssuerRatings_Moodys_SP

di as result "Keep if IssuerType is ST Domestic"
keep if issuertype == 4

sort numericalcode agency ratingdate

di as result "Generate panel structure"
generate year = yofd(ratingdate)
label variable year "Year"

gen id = numericalcode*10 + agency
label variable id "ID Numericalcode + Agency"
qui su id
local id = r(min)
local id_max = r(max)
local i = 1
gen n = _n
while `id' <= `id_max' {
	qui su n if id == `id'
	// continue if ID does not exist
	local n = r(N)
	if `n' == 0 continue

	di _newline as result"Evaluate entries for ID "as input "`id'/`id_max'" as result"."
	//	forvalues i = `=r(min)'/`=r(max)' {
	while `i' <= `=r(max)' {
		di as text"Evaluate entry "as input"`i'/`=_N'"as text"."

		// EXAMPLES
		// 1992 	1.	(first rating)
		// 1993 	2.	(second rating)
		// 1993	 	3.	(third rating)
		// 1996 	4.	(fourth rating)
		// 2000 	5. 	(maturity)
		// 2012 	5. 	(end of time-series)

		// 2. continue if next year equal to this year but not end of time-series
		if year[`i'+1] == year[`i'] & id[`i'+1] == id[`i'] & year[`i'] < 2012 {
			di "2. Continue if next entry's year equal to this year but not end of time-series (maturity)"
			local ++i
			continue
		}
		// 3. expand if different year and neither next year nor last year
		if ( year[`i'+1] > year[`i'] & id[`i'+1] == id[`i'] ) | ( id[`i'+1] != id[`i'] & year[`i'] < 2012 ) {
			if year[`i'+1] > year[`i'] & id[`i'+1] == id[`i']  local gap = year[`i'+1] - year[`i'] + 1
			if id[`i'+1] != id[`i'] & year[`i'] < 2012 	local gap = 2012 - year[`i'] + 1
			di "3. Expand if different year and neither same year nor last year"
			di "Duplicate entries forward "as input `gap' as text" times ("as input `gap'-1 as text" new)."
			expand `gap' in `i'
			// Update span of ID variable in n
			sort id year ratingdate
			qui replace n = _n
			qui su n if id == `id'
			// Delete information for rating changes in expanded entries
			forvalues j = 1/`=`gap'-1' {
				if `=`i'+`j'' > _N continue
				qui replace year = year[`i']+`j' in `=`i'+`j''
				qui replace ratingaction = . in `=`i'+`j''
				qui replace creditwatchoutlook = . in `=`i'+`j''
			}
			local i = `i' + `gap'
			continue
		}
		// 5. continue if end of time-series or maturity
		if year[`i'] == 2012  {
			di "1. Continue if end of time-series or maturity"
			local ++i
			continue
		}
		qui su n if id == `id'
		local ++i
	}
	local id = id[`=r(max)+1']
}
sort id year ratingdate
order id
drop n

di as result "Generate days of year for weighting"
gen days = ratingdate[_n+1] - dofy(year) if ( year[_n+1] == year & id[_n+1] == id ) & ( year[_n-1] != year & id[_n-1] == id )
replace days = ratingdate - days[_n-1] - dofy(year) if ( year[_n-1] == year & id[_n-1] == id )
replace days = dofy(year[_n+1]) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = dofy(2013) - ratingdate - 1 if ( year[_n+1] != year & year[_n-1] == year & id[_n-1] == id & id[_n+1] != id & year == 2012)
// replace days = 365 - days[_n+1] - days[_n-1] if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = ratingdate[_n+1] - ratingdate if ( year[_n+1] == year & year[_n-1] == year & id[_n-1] == id & id[_n+1] == id )
replace days = 365 if days == .

di as result "Generate weighted rating"
foreach i in 20 60 {
	gen rating_`i'_w = rating_`i'*days/365
	egen rating_`i'_w_days = total(rating_`i'_w), by(year id)
	replace rating_`i' = rating_`i'_w_days
	drop rating_`i'_w rating_`i'_w_days
}

save $zentra/output/analysis/IssuerRatings_STDomestic_Panel, replace
}

// ##############################################################################################
// # 5.	MERGE PANEL DATASET WITH MACRO DATA & OECD DEBT DATA
// ##############################################################################################

clear
foreach set in LTForeign LTDomestic STForeign STDomestic {
	clear
	use $zentra/output/analysis/IssuerRatings_`set'_Panel
	collapse (mean) numericalcode issuertype agency rating_20 rating_60 (count) ratingaction, by(year id isoalpha3code countryorareaname)
	sort id year
	tsset id year

	merge m:m numericalcode year using $zentra/${data}/OECD/OECD_full
	di as result "Drop if only using (=2) or before 1970 (=1)"
	drop if _merge == 2 | _merge == 1
	drop _merge
	sort id year

	merge m:m numericalcode year using $zentra/${data}/OECD/DebtInfoOECD
	tab country if _merge == 1
	drop if _merge == 2
	drop _merge
	sort id year

	rename isoalpha3code countrycode
	rename countryorareaname country
	merge m:m countrycode year using $zentra/${data}/ReinhartRogoff/rr_financial_data
	tab country if _merge == 1
	drop if _merge == 2
	drop _merge
	rename  countrycode isoalpha3code
	rename  country countryorareaname
	sort id year

	tsset id year
	rename monmarketabledebtnc nonmarketabledebtnc
	rename ndmpercentagegdp nmdpercentagegdp

	label data "Issuer Rating (`set') Panel"
	label variable numericalcode "UN numerical country code"
	label variable issuertype "Type of issuing entity"
	label variable agency "Credit Rating Agency (1=Moody's, 2=S&P)"
	label variable rating_20 "Credit rating (20-point-scale)"
	label variable rating_60 "Credit rating (60-point-scale)"
	label variable ratingaction "Number of rating events (per year)"
	label variable totaldebtnc "Total debt (in national currency, OECD)"
	label variable totaldebtusd "Total debt (in US dollars, OECD)"
	label variable marketabledebtusd "Marketable debt (in US dollars, OECD)"
	label variable tmdbondsnc "Marketable debt in bonds (in national currency, OECD)"
	label variable tmdbondsusd "Marketable debt in bonds (in US dollars, OECD)"
	label variable tmdforeigncurrencync "Marketable debt in foreign currency (in national currency, OECD)"
	label variable tmdforeigncurrencyusd "Marketable debt in foreign currency (in US dollars, OECD)"
	label variable nonmarketabledebtnc "Non-marketable debt (in national currency, OECD)"
	label variable nonmarketabledebtusd "Non-marketable debt (in US dollars, OECD)"
	label variable debtpercentagegdp "Debt-over-GDP (in % of GDP, OECD)"
	label variable nmdpercentagegdp "Non-marketable debt-over-GDP (in % of GDP, OECD)"
	label variable gdpnc "Gross domestic product (in national currency, OECD)"
	label variable gdpusd "Gross domestic product (in US dollars, OECD)"
	label variable exchangenc "Exchange rate (in national currency, OECD)"
	label variable exchangeusd "Exchange rate (in US dollars, OECD)"

	label values agency agency_label
	label variable agency "Credit rating agency (1=Moody's, 2=S&P)"
	label values issuertype issuertype_label
	label variable issuertype "Type of Issuer (LT, ST, Foreign, Domestic, Regional)"

	compress
	save $zentra/output/analysis/IssuerRatings_`set'_AnnualPanel, replace
}
