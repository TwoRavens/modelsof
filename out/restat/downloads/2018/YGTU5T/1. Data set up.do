********************************************************************************
*                                                                              *
*                               DATA SET-UP                                    *
*                                                                              *
********************************************************************************


clear all
cd "U:\"  // Set directory
set matsize 2500

* Set sensitivity options
global decay = 0                      // Generate decay variable 1=yes, 0=no 
global distvar = 0                    // Generate distance variables 1=yes, 0=no
global adjacent = 0                   // Generate adjacent variable
global domflex = 0                    // Generate flexible function of days on the market
global fullsample = 0                 // Generate full sample (including non-repeated sales)
global sensitivity = 0                // Generate variables for sensitivity analysis
global descriptives = 0               // Provide descriptive statistics
global woonyears = 0				  // Keep only years that are in WoOn 

* Define dates
global tyear = 2007 // threshold year 
global tmonth = 7 // threshold month
global tday = 14 // threshold day
global tyear = 2007 // threshold year 
global tryear = 2009 // threshold year for the ranks
global trmonth = 2 // threshold month for the ranks
global trday = 26 // threshold day for the ranks
global minyear = 2000
global maxyear = 2014

qui use "nvm19852015_xy_raw.dta", clear
qui append using "nvm2016_xy_raw.dta",
g key = _n 
replace isbelegg = isbelegging if isbelegg == .
replace monumentaal = monumental if monumentaal == .
replace datum_aanm = datumaanm if datum_aanm==""
replace datum_afm = datumafm if datum_afm==""
replace ged_verh = gedverh if  ged_verh==.
drop datumaanm datumafm isbelegging gedverh monumental provincie_code year
drop count var nummeraanduiding_id v86

/// Drop if price, size, or price per m2 exceed a certain value
drop if transapr > 2500000
drop if transapr < 25000
drop if m2 > 250
drop if m2 < 25
g prijsm2 = transapr/m2
drop if prijsm2 > 5000
drop if prijsm2 < 500
drop if nkamers > 25
drop if x < 0 | x == .
drop if y < 0 | y == .

egen houseid1 = group(pc6code huisnr huisnrtoev type bwper), missing

by houseid1, sort: egen corr_m2 = mean(m2)
by houseid1, sort: egen corr_nkamers = mean(nkamers)

replace corr_m2 = int((m2-corr_m2-0.0001)/10) // 0 = no more than 5 m2 difference from mean
replace corr_nkamers = int((nkamers-corr_nkamers-0.0001)/5) // 0 = no more than 2.5 rooms difference from mean
egen houseid2 = group(pc6code huisnr huisnrtoev type corr_m2 corr_nkamers bwper), missing
drop houseid1 corr_m2 corr_nkamers

*translating to English
rename transapr price
rename prijsm2 pricesqm
rename oorsprpr pricelist
rename laatstpr pricelistadj
rename m2 size
rename perceel lotsize
rename nkamers rooms
rename prov_id provid

g apartment = 0
replace apartment = 1 if type==-1 | type==0
g terraced = 0
replace terraced = 1 if type==1 | type==2
g semidetached = 0
replace semidetached = 1 if type==3 | type==4
g detached = 0
replace detached = 1 if type==5
drop type
g garage = 0
replace garage = 1 if parkeer==3 | parkeer==4 | parkeer==6 | parkeer==8
g parking = parkeer > 0
drop parkeer
g garden = 0
replace garden = 1 if tuinafw>1
drop tuinlig
g onbibu = onbi+onbu
g maintgood = 0
replace maintgood = 1 if onbibu>13
g maintoutside = (onbu-1)*0.125 if onbu>0
g maintinside = (onbi-1)*0.125 if onbi>0
drop onbibu
drop onbi
drop onbu
g centralheating = 0
replace centralheating = 1 if verw > 1
drop verw
g listed = monument
drop monument

g constrlt1945 = 0
replace constrlt1945 = 1 if bwper==0 | bwper==1 | bwper==2 | bwper==3
g constr19451959 = 0 
replace constr19451959 = 1 if bwper==4
g constr19601970 = 0 
replace constr19601970 = 1 if bwper==5
g constr19711980 = 0 
replace constr19711980 = 1 if bwper==6
g constr19811990 = 0 
replace constr19811990 = 1 if bwper==7
g constr19912000 = 0 
replace constr19912000 = 1 if bwper==8
g constrgt2000 = 0 
replace constrgt2000 = 1 if bwper==9
order constr*, after(listed)
drop bwper

// Determine day id of start of transaction
g year = substr(datum_aanm,-4,4)
destring year, force replace
g day = substr(datum_aanm,-7,2)
g day2 = substr(datum_aanm,-6,1)
destring day, force replace
destring day2, force replace
replace day = day2 if day == .
g month = substr(datum_aanm,-10,2) if day > 9
g month2 = substr(datum_aanm,-9,1) if day > 9
replace month = substr(datum_aanm,-9,2) if day <= 9
replace month2 = substr(datum_aanm,-8,1) if day <= 9
destring month, force replace
destring month2, force replace
replace month = month2 if month == .
drop day2 month2
merge m:1 day month year using "Time.dta", keep(1 3) nogen
rename dayid dayid_start
drop year day month

// Determine day id of end of transaction
g year = substr(datum_afm,-4,4)
destring year, force replace
g day = substr(datum_afm,-7,2)
g day2 = substr(datum_afm,-6,1)
destring day, force replace
destring day2, force replace
replace day = day2 if day == .
g month = substr(datum_afm,-10,2) if day > 9
g month2 = substr(datum_afm,-9,1) if day > 9
replace month = substr(datum_afm,-9,2) if day <= 9
replace month2 = substr(datum_afm,-8,1) if day <= 9
destring month, force replace
destring month2, force replace
replace month = month2 if month == .
drop day2 month2
merge m:1 day month year using "Time.dta", keep(1 3) nogen
rename dayid dayid_end

g pc6 = pc6code
replace pc6 = . if pc6 == 0
drop pc6code
tostring pc6, force g(pc4)
replace pc4 = substr(pc4,1,4)
destring pc4, force replace

rename gem_id mun
rename x xcoord
rename y ycoord
destring mun, force replace
destring provid, force replace

rename loopt daysonmarket 

* Generate unique house id
duplicates tag houseid2, g(times)
replace times = times+1
duplicates tag houseid2 year, g(yeartimes)
replace yeartimes = yeartimes+1
g random = 0
replace random = runiform() if times > 10 // change houseid if more than 10 times transacted in 30 year
replace random = runiform() if yeartimes > 1 // change houseid if more than 1 times transacted in one year
egen houseid = group(houseid2 random), missing
egen xyid = group(xcoord ycoord), missing
drop houseid2 times yeartimes random

drop  kelder ged_verh permanent erfpacht ligdrukw ligmooi ligcentr ///
tuinafw inpandig nbadk nwc nbijkeuk nkeuken ndakterr ndakkap nbalkon woonka praktijkr vlier zolder vtrap nverdiep ///
kwaliteit lift openport status isbelegg isnieuwbw nvmcijfers datum_afm datum_aanm verkpcond procversch ///
soortwon soortapp kenmwon soorthuis huisklasse inhoud woonopp categorie woonplaats ///
afd_id nvmreg_id
rename straat street
drop monumentaal 
*rename nummer_id obsid // is not working anymore since 2014
rename (huisnrtoev huisnr) (nmbradd nmbr)
egen obsid = group(houseid year)
duplicates drop obsid, force
replace obsid = key
drop key
order houseid xyid, after(obsid)

label variable price "transaction price in euro"
label variable pricesqm "transaction price in euro per m2"
label variable pricelist "list price in euro"
label variable pricelistadj "adjusted list price in euro"
label variable size "size of property in m2"
label variable lotsize "size of parcel in m2"
label variable rooms "number of rooms"
label variable parking "property has private parking space"
label variable garage "property has garage"
label variable apartment "apartment"
label variable terraced "terraced property"
label variable semidetached "semi-detached property"
label variable detached "detached property"
label variable garden "property has garden"
label variable maintgood "maintenance state is good"
label variable maintinside "maintenance score of the inside"
label variable maintoutside "maintenance score of the outside"
label variable centralheating "property has central heating"
label variable listed "property is (part of) listed building"
label variable isol "number of types of insulation"
label variable constrlt1945 "construction year <1945"
label variable constr19451959 "construction year 1945-1959"
label variable constr19601970 "construction year 1960-1970"
label variable constr19711980 "construction year 1971-1980"
label variable constr19811990 "construction year 1981-1990"
label variable constr19912000 "construction year 1991-2000"
label variable constrgt2000 "construction year >2000"
label variable year "year of observation"
label variable month "month of observation"
label variable day "day of observation"
label variable pc6 "postcode 6-digit"
label variable pc4 "postcode 4-digit"
label variable mun "municipality code"
label variable provid "province id"
label variable xcoord "x-coordinate (gcs amersfoort)"
label variable ycoord "y-coordinate (gcs amersfoort)"
label variable street "street"
label variable nmbradd "address number, addition"
label variable nmbr "address number"
label variable daysonmarket "days on the market"
label variable houseid "property id"
label variable obsid "unique observation id"
label variable xyid "location id"

order obsid xcoord ycoord street nmbr* houseid xyid pc6 pc4 mun provid price pricelist pricelistadj pricesqm daysonmarket size lotsize rooms apartment terraced semidetached detached garage garden maintgood isol centralheating listed constr* year month day
sort obsid 

drop if daysonmarket == . | daysonmarket == 0 | pricesqm == . // Drop missings 

local n = _N

quietly drop if year < $minyear | year > $maxyear
if $woonyears == 1 {
	keep if year == 2002 | year == 2006 | year == 2009 | year == 2012 | year == 2015
}

duplicates tag houseid, g(rs)

merge m:1 pc4 using "kw_pc4.dta", nogenerate keep(3)
g scorerule = 0
replace scorerule = 1 if zscore > 7.29
g inkw = kw
merge m:1 xcoord ycoord using "kw_distances.dta", nogenerate keep(3)
replace kwdist = 0 if kw==1
replace kwadjacent = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
replace scoreruleadjacent = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
g kwaftdist = kwdist 
replace kwaftdist = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
order kwaftdist, after(kwdist)
replace scorerule = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
replace kw = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
replace kw = 0 if kw==.
replace kwinvpp = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
replace kwinvpp = 0 if kwinvpp==.
replace kwinvpsqm = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
replace kwinvpsqm = 0 if kwinvpsqm==.
g kwinvpsqm2 = (kwinvpsqm)^2

g kwexcl = 0 
replace kwexcl = 1 if (zscore > 7.29 & kw == 0) | (zscore < 7.30 & kw == 1)

merge m:1 pc4 year using "pc4data.dta", nogenerate keep(1 3)
merge m:1 pc4 year using "pc4_income.dta", nogenerate keep(1 3)
merge m:1 pc4 year using "pc4_shiftshare.dta", nogenerate keep(1 3)
merge m:1 pc4 year using "pc4_shiftshare_national.dta", nogenerate keep(1 3)

if $woonyears == 1 {
merge m:1 pc4 year using "pc4_housingunits.dta", nogenerate keep(1 3) keepusing(shownocc shprivrent shsocialrent shwownocc shwprivrent shwsocialrent)
}
* Generate logged variables
g logpricesqm = ln(pricesqm)
g logdaysonmarket = ln(daysonmarket)
g logsize = ln(size)
g logincome = ln(income)
g logincomepred = ln(incomepred)
g logincomenpred = ln(incomenpred)
g logpopdens = ln(popdens)
g logpopdenspred = ln(popdenspred)
g logpopdensnpred = ln(popdensnpred)
g percask = price/priceask*100
g percaskadj = price/priceaskadj*100
replace logpopdens = 0 if logpopdens == .
replace logpopdenspred = 0 if logpopdenspred == .
replace logpopdensnpred = 0 if logpopdensnpred == .
order logpricesqm, after(pricesqm)
order logdaysonmarket, after(daysonmarket)
order logsize, after(size)
order logpopdens, after(popdens)
order logpopdenspred, after(popdenspred)
order logpopdensnpred, after(popdensnpred)
order logincome, after(income)
order logincomepred, after(incomepred)
order logincomenpred, after(incomenpred)

* Drop outliers
drop if daysonmarket < 1 | daysonmarket > 1826.25
drop if percask < 70 | percask > 110 | percask == .
replace percaskadj = percask if percaskadj < 70 | percaskadj > 110 | priceaskadj==.

if $fullsample == 0 { 
	drop if rs == 0 // Drop non-repeated sales
	drop if rs > 4 // More than 5 transactions (rs+1) in time period
}

if $distvar == 1 {

	forvalues i = 0(500)2000 {
		local j = `i'+500
		g kw`i'_`j' = 0
		replace kw`i'_`j' = (kwdist <= `j'/1000 & kwdist > `i'/1000) & inkw == 0
		replace kw`i'_`j' = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
		g srule`i'_`j' = 0
		replace srule`i'_`j' = (scoringruledist <= `j'/1000 &  scoringruledist > `i'/1000) & zscore < 7.3
		replace srule`i'_`j' = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	}
}
	
if $decay == 1 {
	
	forvalues j = 0(1)25 {
	
	local dT = `j'/10
	g kwdec`j' = 0
	replace kwdec`j' = (1-(kwdist/`dT')) if kwdist < `dT'
	replace kwdec`j' = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	replace kwdec`j' = 0 if inkw == 1
	
	}
}

if $sensitivity == 1 {
	
	merge m:1 year month day using "dates.dta", nogenerate keep(1 3)
	replace daysinv = daysinv/365
	replace daysinv = 0 if daysinv==.
	g daysinv_sc = 0
	replace daysinv = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	replace daysinv_sc = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	g dayspbo = daysinv
	replace daysinv_sc = daysinv if zscore>7.29
	replace daysinv = 0 if kwdist>0
		
	g daysinv1 =  daysinv
	g daysinv2 =  daysinv^2
	g daysinv3 =  daysinv^3
	g daysinv4 =  daysinv^4
	g daysinv5 =  daysinv^5
	g daysinv1_sc =  daysinv_sc
	g daysinv2_sc =  daysinv_sc^2
	g daysinv3_sc =  daysinv_sc^3
	g daysinv4_sc =  daysinv_sc^4
	g daysinv5_sc =  daysinv_sc^5
	
	g timeafterinv = ceil(daysinv/2.5)
	replace timeafterinv = 0 if inkw == 0
	g timeafterinv_sc = ceil(daysinv_sc/2.5)
	replace timeafterinv_sc = 0 if inkw == 0
	
	g kw_y1 = (timeafterinv==1)
	g kw_y2 = (timeafterinv==2)
	g kw_y3 = (timeafterinv>=3)
	g scorerule_y1 = (timeafterinv_sc==1)
	g scorerule_y2 = (timeafterinv_sc==2)
	g scorerule_y3 = (timeafterinv_sc>=3) 
	drop timeafterinv*
	
	g kw_alt1 = 0
	g kw_alt2 = 0
	replace kw_alt1 = 1 if kwdist == 0
	replace kw_alt2 = 1 if kwdist == 0
	replace kw_alt1 = 0 if (year < 2007 | (year == 2007 & month < 3) | (year == 2007 & month == 3 & day <= 22))
	replace kw_alt2 = 0 if (year < 2008 | (year == 2008 & month < 1) | (year == 2008 & month == 1 & day <= 1))
	g scorerule_date1 = 1
	replace scorerule_date1 = 0 if zscore < 7.3 | (year < 2007 | (year == 2007 & month < 3) | (year == 2007 & month == 3 & day <= 22))
	g scorerule_date2 = 1
	replace scorerule_date2 = 0 if zscore < 7.3 | (year < 2008 | (year == 2008 & month < 1) | (year == 2008 & month == 1 & day <= 1))
	g scorerule_winsemius = 1
	replace scorerule_winsemius = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday)) | zscore < 2.5
	
	* Generate placebo vars
	g daysinvpp = dayspbo*kwinvpp
	g daysinvpsqm = dayspbo*kwinvpsqm
	
	g pbo_kamp = kamp
	replace pbo_kamp = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	g pbo_kampXdayspbo = pbo_kamp*dayspbo
	
	g pbo_winsemius = winsemius
	replace pbo_winsemius = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	g pbo_winsemiusXdayspbo = pbo_winsemius*dayspbo
	
	g pbo_kwtime = 0
	replace pbo_kwtime = 1 if inkw == 1
	replace pbo_kwtime = 0 if (year < 2003)
		
	g pbo_scoreruletime = (zscore > 7.29)
	replace pbo_scoreruletime = 0 if (year<2003)
	g pbo_scoreruletimeXdayspbo = pbo_scoreruletime*dayspbo
	
	g pbo_kwplus = kwplus
	replace pbo_kwplus = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	g pbo_kwplusXdayspbo = pbo_kwplus*dayspbo
	
	g pbo_gsb = gsbneighbourhood
	replace pbo_gsb = 0 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	g pbo_gsbXdayspbo = pbo_gsb*dayspbo
	
	* Generate trend for distance to CBD
	forvalues k = $minyear(1)$maxyear {
		g distcbd_`k' = distcbd if year == `k'
		replace distcbd_`k' = 0 if distcbd_`k' == .
		g logdistcbd_`k' = ln(distcbd) if year == `k'
		replace logdistcbd_`k' = 0 if logdistcbd_`k' == .
	}
}

sort houseid year

if $domflex == 1 {
	g daysonmarket2 = daysonmarket^2
	g daysonmarket3 = daysonmarket^3
	g daysonmarket4 = daysonmarket^4
	g daysonmarket5 = daysonmarket^5
	g daysonmarket6 = daysonmarket^6
	g daysonmarket7 = daysonmarket^7
}

local n = _N

if $fullsample == 0 {	
	g dpricesqm = pricesqm[_n]-pricesqm[_n-1] if houseid[_n]==houseid[_n-1]
	g dlogpricesqm = logpricesqm[_n]-logpricesqm[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysonmarket = daysonmarket[_n]-daysonmarket[_n-1] if houseid[_n]==houseid[_n-1]
	g dlogdaysonmarket = logdaysonmarket[_n]-logdaysonmarket[_n-1] if houseid[_n]==houseid[_n-1]
	g dpercask = percask[_n]-percask[_n-1] if houseid[_n]==houseid[_n-1]
	g dpercaskadj = percaskadj[_n]-percaskadj[_n-1] if houseid[_n]==houseid[_n-1]
	g dkw = kw[_n]-kw[_n-1]  if houseid[_n]==houseid[_n-1]
	g dkwdist = kwaftdist[_n]-kwaftdist[_n-1]  if houseid[_n]==houseid[_n-1]
	g dscorerule = scorerule[_n]-scorerule[_n-1]  if houseid[_n]==houseid[_n-1]
	g dsize = size[_n]-size[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlogsize = logsize[_n]-logsize[_n-1]  if houseid[_n]==houseid[_n-1]
	g drooms = rooms[_n]-rooms[_n-1]  if houseid[_n]==houseid[_n-1]
	g dmaintgood = maintgood[_n]-maintgood[_n-1]  if houseid[_n]==houseid[_n-1]
	g dcentralheating = centralheating[_n]-centralheating[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlisted = listed[_n]-listed[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlogincome = logincome[_n]-logincome[_n-1]  if houseid[_n]==houseid[_n-1]
	g dincomeimp = max(incomeimp[_n], incomeimp[_n-1]) if houseid[_n]==houseid[_n-1]
	g dlogpopdens = logpopdens[_n]-logpopdens[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshforeign = shnwforeign[_n]-shnwforeign[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshnwforeign = shnwforeign[_n]-shnwforeign[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshyoung = shyoung[_n]-shyoung[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshold = shold[_n]-shold[_n-1]  if houseid[_n]==houseid[_n-1]
	g dhhsize = hhsize[_n]-hhsize[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlogincomepred = logincomepred[_n]-logincomepred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlogpopdenspred = logpopdenspred[_n]-logpopdenspred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshforeignpred = shnwforpred[_n]-shnwforpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshyoungpred = shyoungpred[_n]-shyoungpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dsholdpred = sholdpred[_n]-sholdpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dhhsizepred = hhsizepred[_n]-hhsizepred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlogincomenpred = logincomenpred[_n]-logincomenpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlogpopdensnpred = logpopdensnpred[_n]-logpopdensnpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshforeignnpred = shnwfornpred[_n]-shnwfornpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dshyoungnpred = shyoungnpred[_n]-shyoungnpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dsholdnpred = sholdnpred[_n]-sholdnpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dhhsizenpred = hhsizenpred[_n]-hhsizenpred[_n-1]  if houseid[_n]==houseid[_n-1]
	g dluinfr = luinfr[_n]-luinfr[_n-1]  if houseid[_n]==houseid[_n-1]
	g dlures = lures[_n]-lures[_n-1]  if houseid[_n]==houseid[_n-1]	
	g dluind = luind[_n]-luind[_n-1]  if houseid[_n]==houseid[_n-1]
	g dluopens = luopens[_n]-luopens[_n-1]  if houseid[_n]==houseid[_n-1]
	g dluwater = luwater[_n]-luwater[_n-1]  if houseid[_n]==houseid[_n-1]
	g yearmin = year[_n-1]  if houseid[_n]==houseid[_n-1]
	g monthmin = year[_n-1]  if houseid[_n]==houseid[_n-1]
	g daymin = year[_n-1]  if houseid[_n]==houseid[_n-1]
	
	g beforeafter = 0
	replace beforeafter = 1 if (year < $tyear | (year == $tyear & month < $tmonth) | (year == $tyear & month == $tmonth & day <= $tday))
	replace beforeafter = 1 if (yearmin >= $tyear | (yearmin == $tyear & monthmin >= $tmonth) | (yearmin == $tyear & monthmin == $tmonth & daymin > $tday))
	
forvalues k = $minyear(1)$maxyear {
	g dyear`k' = 0  
	replace dyear`k' = 1  if year[_n] == `k' & houseid[_n]==houseid[_n-1]
	replace dyear`k' = -1  if year[_n-1] == `k' & houseid[_n]==houseid[_n-1]
}
	
if $adjacent == 1 {
	g dkwadjacent = kwadjacent[_n]-kwadjacent[_n-1]  if houseid[_n]==houseid[_n-1]
	g dscoreruleadjacent = scoreruleadjacent[_n]-scoreruleadjacent[_n-1]  if houseid[_n]==houseid[_n-1]
} 
	
if $distvar == 1 {

	forvalues i = 0(500)2000 {
		local j = `i'+500
		g dkw`i'_`j' = kw`i'_`j'[_n]-kw`i'_`j'[_n-1] if houseid[_n]==houseid[_n-1]
		g dsrule`i'_`j' = srule`i'_`j'[_n]-srule`i'_`j'[_n-1] if houseid[_n]==houseid[_n-1]
	}
	
	}
	
if $decay == 1 {
	forvalues k = 0(1)5 {
		g dkwdec`k' = kwdec`k'[_n]-kwdec`k'[_n-1]  if houseid[_n]==houseid[_n-1]
	}
}
	
if $domflex == 1 {
	g ddaysonmarket2 = daysonmarket2[_n]-daysonmarket2[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysonmarket3 = daysonmarket3[_n]-daysonmarket3[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysonmarket4 = daysonmarket4[_n]-daysonmarket4[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysonmarket5 = daysonmarket5[_n]-daysonmarket5[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysonmarket6 = daysonmarket6[_n]-daysonmarket6[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysonmarket7 = daysonmarket7[_n]-daysonmarket7[_n-1] if houseid[_n]==houseid[_n-1]
}
	
if $sensitivity == 1  {
	g dkwinvpp = kwinvpp[_n]-kwinvpp[_n-1] if houseid[_n]==houseid[_n-1]
	g dkwinvpsqm = kwinvpsqm[_n]-kwinvpsqm[_n-1] if houseid[_n]==houseid[_n-1]
	g dkwinvpsqm2 = kwinvpsqm2[_n]-kwinvpsqm2[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysinvpp = daysinvpp[_n]-daysinvpp[_n-1] if houseid[_n]==houseid[_n-1]
	g ddaysinvpsqm = daysinvpsqm[_n]-daysinvpsqm[_n-1] if houseid[_n]==houseid[_n-1]
	g dkw_alt1 = kw_alt1[_n]-kw_alt1[_n-1] if houseid[_n]==houseid[_n-1]
	g dkw_alt2 = kw_alt2[_n]-kw_alt2[_n-1] if houseid[_n]==houseid[_n-1]
	g dscorerule_date1 = scorerule_date1[_n]-scorerule_date1[_n-1]  if houseid[_n]==houseid[_n-1]
	g dscorerule_date2 = scorerule_date2[_n]-scorerule_date2[_n-1]  if houseid[_n]==houseid[_n-1]
	g dscorerule_winsemius = scorerule_winsemius[_n]-scorerule_winsemius[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_kamp = pbo_kamp[_n]-pbo_kamp[_n-1]  if houseid[_n]==houseid[_n-1]
	replace dpbo_kamp = 0 if dpbo_kamp < 0
	g dpbo_winsemius = pbo_winsemius[_n]-pbo_winsemius[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_scoreruletime = pbo_scoreruletime[_n]-pbo_scoreruletime[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_kwplus = pbo_kwplus[_n]-pbo_kwplus[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_gsb = pbo_gsb[_n]-pbo_gsb[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_kampXdayspbo = pbo_kampXdayspbo[_n]-pbo_kampXdayspbo[_n-1]  if houseid[_n]==houseid[_n-1]
	replace dpbo_kampXdayspbo = 0 if pbo_kampXdayspbo < 0
	g dpbo_winsemiusXdayspbo = pbo_winsemiusXdayspbo[_n]-pbo_winsemiusXdayspbo[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_kwplusXdayspbo = pbo_kwplusXdayspbo[_n]-pbo_kwplusXdayspbo[_n-1]  if houseid[_n]==houseid[_n-1]
	g dpbo_gsbXdayspbo = pbo_gsbXdayspbo[_n]-pbo_gsbXdayspbo[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv = daysinv[_n]-daysinv[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv1 = daysinv1[_n]-daysinv1[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv2 = daysinv2[_n]-daysinv2[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv3 = daysinv3[_n]-daysinv3[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv4 = daysinv4[_n]-daysinv4[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv5 = daysinv5[_n]-daysinv5[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv_sc = daysinv_sc[_n]-daysinv_sc[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv1_sc = daysinv1_sc[_n]-daysinv1_sc[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv2_sc = daysinv2_sc[_n]-daysinv2_sc[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv3_sc = daysinv3_sc[_n]-daysinv3_sc[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv4_sc = daysinv4_sc[_n]-daysinv4_sc[_n-1]  if houseid[_n]==houseid[_n-1]
	g ddaysinv5_sc = daysinv5_sc[_n]-daysinv5_sc[_n-1]  if houseid[_n]==houseid[_n-1]
	
	forvalues i = 1(1)3 {
		g dkw_y`i' = kw_y`i'[_n]-kw_y`i'[_n-1]  if houseid[_n]==houseid[_n-1]
		g dscorerule_y`i' = scorerule_y`i'[_n]-scorerule_y`i'[_n-1]  if houseid[_n]==houseid[_n-1]
	}
	
	* Generate trend for distance to CBD
	forvalues k = $minyear(1)$maxyear {
		g ddistcbd_`k' = distcbd_`k'[_n]-distcbd_`k'[_n-1] if houseid[_n]==houseid[_n-1]
		g dlogdistcbd_`k' = logdistcbd_`k'[_n]-logdistcbd_`k'[_n-1] if houseid[_n]==houseid[_n-1]
		drop distcbd_`k' logdistcbd_`k'
	}
	
	if $woonyears == 1 {
	g dshownocc = shownocc[_n]-shownocc[_n-1] if houseid[_n]==houseid[_n-1]
	g dshprivrent = shprivrent[_n]-shprivrent[_n-1] if houseid[_n]==houseid[_n-1] 
	g dshsocialrent = shsocialrent[_n]-shsocialrent[_n-1] if houseid[_n]==houseid[_n-1] 
	g dshwownocc = shwownocc[_n]-shwownocc[_n-1] if houseid[_n]==houseid[_n-1] 
	g dshwprivrent = shwprivrent[_n]-shwprivrent[_n-1] if houseid[_n]==houseid[_n-1] 
	g dshwsocialrent = shwsocialrent[_n]-shwsocialrent[_n-1] if houseid[_n]==houseid[_n-1]
	}
}

forvalues i = 1(1)3 {
	g zscore_`i' = (zscore-7.3)^`i'
	g zscorescrule_`i' = zscore_`i'*(zscore>=7.3)
	g zscorenscrule_`i' = zscore_`i'*(zscore<7.3)
	label variable zscore_`i' "z-score ^ `i'"
}

	label variable dpricesqm "change house price"
	label variable dlogpricesqm "change log house price"
	label variable ddaysonmarket "change days on market"
	label variable ddaysonmarket "change log days on market"
	label variable dpercask "change in the ratio transaction/asking price"
	label variable dsize "change house size"
	label variable dlogsize "change log house size"
	label variable drooms "change rooms"
	label variable dmaintgood "change maintenance quality"
	label variable dcentralheating "change central heating"
	label variable dlisted "change listed status"
	label variable dlogpopdens "change population density"
	label variable dshforeign "change share foreigner"
	label variable dshnwforeign "change share of non-western foreigner"
	label variable dshyoung "change share young people"
	label variable dshold "change share elderly people"
	label variable dhhsize "change average household size"
	label variable dluinfr "change share infrastructure"
	label variable dlures "change share residential land"
	label variable dluind "change share industrial land"
	label variable dluopens "change share open space"
	label variable dlogdaysonmarket "change days on market"
	label variable dkw "change in krachtwijk"
	label variable dkwdist "change distance to krachtwijk"
	label variable kwdist "distance to krachtwijk"


if $decay == 1 {
	label variable dkwdec1 "change weighted effect based on distance, dT=0.5"
	label variable dkwdec2 "change weighted effect based on distance, dT=1"
	label variable dkwdec3 "change weighted effect based on distance, dT=1.5"
	drop kwdec*
}

if $adjacent== 1  {
	label variable dkwadjacent "change in adjacent to investment"
}

forvalues k = $minyear(1)$maxyear {
label variable dyear`k' "change transaction year"
}

if $domflex == 1  {
	label variable ddaysonmarket2 "change days on market ^ 2"
	label variable ddaysonmarket3 "change days on market ^ 3"
	label variable ddaysonmarket4 "change days on market ^ 4"
	label variable ddaysonmarket5 "change days on market ^ 5"
	label variable ddaysonmarket6 "change days on market ^ 6"
	label variable ddaysonmarket7 "change days on market ^ 7"
}

if $sensitivity == 1 {
drop daysinv* pbo_*
}

}

if $fullsample == 0 {
save "NVM_20002014.dta", replace
}



if $descriptives == 1 {
/// GENERATE DESCRIPTIVE STATISTICS
use "NVM_20002014.dta", clear
drop if inkw == 0
order pricesqm daysonmarket kw zscore size apartment terraced semi-detached detached garage garden maintgood centralheating listed constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000
outreg2 using "Current projects\Probleemwijken\Results\Table 1, in kw - full", replace sum(log) label word keep(pricesqm daysonmarket percask kw zscore size maintgood centralheating listed apartment terraced semi-detached detached garage garden constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000)

use "NVM_20002014.dta", clear
drop if inkw == 1
order pricesqm daysonmarket kw zscore size apartment terraced semi-detached detached garage garden maintgood centralheating listed constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000
outreg2 using "Current projects\Probleemwijken\Results\Table 1, out kw - full", replace sum(log) label word keep(pricesqm daysonmarket percask kw zscore size maintgood centralheating listed apartment terraced semi-detached detached garage garden constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000)

* Drop non-repeated sales
use "NVM_20002014.dta", clear
drop if rs == 0 // Drop non-repeated sales
drop if rs > 4 // More than 5 transactions (rs+1) in time period
save "NVM_20002014.dta", replace

use "NVM_20002014.dta", clear
drop if inkw == 0
g weight = 1
outreg2 using "Current projects\Probleemwijken\Results\Table 1, in kw - repeated sales", replace sum(log) label word keep(pricesqm daysonmarket percask kw zscore size maintgood centralheating listed apartment terraced semi-detached detached garage garden constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000)

use "NVM_20002014.dta", clear
drop if inkw == 1
g weight = 1
outreg2 using "Current projects\Probleemwijken\Results\Table 1, out kw - repeated sales", replace sum(log) label word keep(pricesqm daysonmarket percask kw zscore size maintgood centralheating listed apartment terraced semi-detached detached garage garden constrlt1945 constr19451959 constr19601970 constr19711980 constr19811990 constr19912000 constrgt2000)

use "NVM_20002014.dta", clear
replace dpricesqm = pricesqm/(year-yearmin)
drop if inkw == 0
g weight = 1
outreg2 using "Current projects\Probleemwijken\Results\Table A1, in kw - repeated sales", replace sum(log) label word keep(dpricesqm ddaysonmarket dpercask dkw dscorerule dsize dmaintgood dcentralheating dlisted)

use "NVM_20002014.dta", clear
replace dpricesqm = pricesqm/(year-yearmin)
drop if inkw == 1
g weight = 1
outreg2 using "Current projects\Probleemwijken\Results\Table A1, out kw - repeated sales", replace sum(log) label word keep(dpricesqm ddaysonmarket dpercask dkw dscorerule dsize dmaintgood dcentralheating dlisted)
}

if $fullsample == 0 {

use "NVM_20002014.dta", clear

* drop time-invariant housing attributes
drop price popdens apartment terraced semidetached detached garage garden constrlt1945 constr19451959 constr19711980 constr19601970 constr19811990 constr19912000 constrgt2000
* drop time-varying housing attributes in levels
drop nmbr nmbradd xyid provid priceask priceaskadj lotsize isol rs pc4name kwinitial percaskadj rooms centralheating listed kwaftdist kw luinfr lures luind luopens   //shforeign logpopdens  shyoung shold hhsize shnwforeign
order d*, after(mun)
order yearmin, after(year)

save "NVM_20002014.dta", replace

}

if $fullsample == 1 {
keep obsid houseid xcoord ycoord pc6 pc4 logpricesqm logdaysonmarket logsize rooms apartment terraced semidetached detached garage garden maintgood month day isol centralheating listed constr* year kw kwdist inkw daysinv daysinv1_sc scoringruledist zscore scorerule logincome logpopdens shforeign shyoung shold shnwforeign hhsize lures luind luinfr luopensp luwater
	
	forvalues i = 1(1)3 {
		g zscore_`i' = (zscore-7.3)^`i'
		g zscorescrule_`i' = zscore_`i'*(zscore>=7.3)
		g zscorenscrule_`i' = zscore_`i'*(zscore<7.3)
	label variable zscore_`i' "z-score ^ `i'"
	}

	forvalues i = $minyear(1)$maxyear {
	g year_`i' = (`i'==year)
	}

	foreach var of varlist logpricesqm logdaysonmarket logsize rooms apartment terraced semidetached detached garage garden maintgood isol centralheating listed constr* year kw daysinv scorerule daysinv1_sc logincome logpopdens shforeign shyoung shold shnwforeign hhsize lures luind luinfr luopensp luwater year_* {
		egen temp = mean(`var'), by(pc6)
		generate dm`var' = `var'-temp
		drop temp
	}
	
save "NVM_20002014_full.dta", replace
}
