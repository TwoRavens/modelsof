/* PrepStoreEntry.do */
* This preps the store entry data

/* Prep the TDLinx entry data */
include Code/DataPrep/Supply/CleanEntries.do


/* Import crosswalk from TDLinx to store_code_uc and retailer_code_uc */
** TDLinx -> store code
insheet using $Externals/Calculations/StoreEntryExit/EntrantTDLinxCodes.csv, comma case names clear
keep stdlinxscd LocationIdentifier
rename stdlinxscd tdlinx
saveold $Externals/Calculations/StoreEntryExit/TDlinx_store_code_uc_crosswalk.dta,replace
insheet using "$Externals/Data/StoreEntryExit/EntrantTDLinxCodes - Translated 2018-06-22.csv.", comma case names clear
merge 1:1 LocationIdentifier using $Externals/Calculations/StoreEntryExit/TDlinx_store_code_uc_crosswalk.dta, keepusing(tdlinx)
assert _m==3
drop _m date_added LocationIdentifier
sort tdlinx
compress
saveold $Externals/Calculations/StoreEntryExit/TDlinx_store_code_uc_crosswalk.dta,replace


**** Get TDLinx crosswalk to retailers
** Store code -> retailer code from trips files
clear
save $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, replace emptyok
forvalues year = 2004/$MaxYear {
	use $Externals/Calculations/Homescan/Trips/trips_`year'.dta, replace
	drop if store_code_uc == 0
	gen N = 1
	collapse (sum) N,by(store_code_uc retailer_code) 
	bysort store_code_uc (N): keep if _n==_N
	drop N
	gen int panel_year = `year'
	rename retailer_code retailer_code_trips
	append using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta
	saveold $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, replace
}


** store code - retailer code - tdlinx code from Kilts TDLinx.dta dataset
use $Externals/Data/StoreEntryExit/TDlinx.dta,clear
replace store_code_uc = store_id_uc if store_code_uc==.
replace retailer_code = retailer_id if retailer_code==.
rename retailer_code retailer_code_uc
keep tdlinx panel_year retailer_code_uc store_code_uc
* Impute missing retailer_code using the closest year
	* store_code_uc is never missing
gen retailer_code_orig = retailer_code_uc
label values retailer_code_orig retailer_code
forvalues i = 1/8 {
	gsort tdlinx panel_year
	replace retailer_code_uc = retailer_code_uc[_n+1] if tdlinx==tdlinx[_n+1]&retailer_code_uc==.
	*replace store_code_uc = store_code_uc[_n+1] if tdlinx==tdlinx[_n+1]&store_code_uc==.
	gsort tdlinx -panel_year
	replace retailer_code_uc = retailer_code_uc[_n+1] if tdlinx==tdlinx[_n+1]&retailer_code_uc==.
	*replace store_code_uc = store_code_uc[_n+1] if tdlinx==tdlinx[_n+1]&store_code_uc==.
}
rename retailer_code_uc retailer_code
saveold $Externals/Calculations/StoreEntryExit/TDlinx_retailer_code_crosswalk.dta, replace

* Merge matches from trips files and make sure that there aren't too many mismatches.
merge m:1 panel_year store_code_uc using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta
gen mismatch = cond(retailer_code_trips!=retailer_code&retailer_code_trips!=.&retailer_code!=.,1,0)
sum mismatch
assert r(mean)<0.001


****************************************************************************
/* Clean TDLinx entries */
use $Externals/Calculations/StoreEntryExit/TDLinxEntries.dta, replace
/*
* This code was used to output TDLinx codes for matching.
sort slat slong
gen LocationIdentifier = _n*2+1203
keep stdlinxscd date_added LocationIdentifier
sort stdlinxscd
outsheet using $Externals/Calculations/StoreEntryExit/EntrantTDLinxCodes.csv, comma names replace
*/

replace subchannel_abrev = "2-Supermarket-Natural/Gourmet" if strpos(subchannel_abrev,"2-Supermarket-Natural/Gour")!=0
replace subchannel_abrev = "1-Supermarket-LimitedAssort" if strpos(subchannel_abrev,"1-Supermarket-Limited")!=0


* Keep Wholesale Club, Grocery. Note that Target and Walmart supercenters are included in "grocery," not mass, under subchannel_abrev "6-Supercenter" or "5-Supermarket-Conventional"
keep if inlist(channel_code,1,5) 
drop if inlist(subchannel_abrev,"7-MilitaryCommissary","4-Superette","3-WarehouseGrocery") // We are keeping "1-Supermarket-LimitedAssort". tab sname if subchannel_abrev=="1-Supermarket-LimitedAssort". This is 35% Aldi, 18% Fresh and Easy, 28% Save A Lot. 
	// We are dropping warehouse grocery. 1/2 of these are clearly wholesalers, e.g. Cash & Carry (https://www.smartfoodservice.com/search/freshproduce/) and GFS (https://www.gfs.com/en-us/who-we-serve)
* Natural/Gourmet includes Trader Joes, Whole Foods, Earth Fare, Sprouts, Fresh, Natural Grocery, and then a bunch of non-chains. We do want the larger ones, so we comment this line and just drop entrants below that don't match to a Nielsen retailer name.
*drop if subchannel_abrev=="2-Supermarket-Natural/Gourmet"&inlist(sname,"Earth Fare","Fresh","Natural Grocers","Sprouts","Sunflower","Trader Joes","Whole Foods")==0
drop if sname=="Murrys" // This is a chain of closed-down steak stores

** Merge store_code_uc
merge 1:1 tdlinx using $Externals/Calculations/StoreEntryExit/TDlinx_store_code_uc_crosswalk.dta, ///
	keepusing(store_code_uc) nogen keep(match master)

*** Merge retailer_code
** Using store code
* From RMS
gen year = entry_year-2
merge 1:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_RMSm2
replace year = year+1
merge 1:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_RMSm1
replace year = year+1
merge 1:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_RMS0
replace year = year+1
merge 1:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_RMS1
replace year = year+1
merge 1:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_RMS2
drop year


* From trips files
gen panel_year = entry_year-2
merge 1:1 store_code_uc panel_year using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, keep(match master) nogen
rename retailer_code_trips retailer_code_tripsm2
replace panel_year = panel_year+1
merge 1:1 store_code_uc panel_year using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, keep(match master) nogen
rename retailer_code_trips retailer_code_tripsm1
replace panel_year = panel_year+1
merge 1:1 store_code_uc panel_year using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, keep(match master) nogen
rename retailer_code_trips retailer_code_trips0
replace panel_year = panel_year+1
merge 1:1 store_code_uc panel_year using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, keep(match master) nogen
rename retailer_code_trips retailer_code_trips1
replace panel_year = panel_year+1
merge 1:1 store_code_uc panel_year using $Externals/Calculations/StoreEntryExit/store_retailer_crosswalk.dta, keep(match master) nogen
rename retailer_code_trips retailer_code_trips2
drop panel_year

** Using TDLinx code
gen panel_year=entry_year-2
merge 1:1 tdlinx panel_year using $Externals/Calculations/StoreEntryExit/TDlinx_retailer_code_crosswalk.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_tdlinxm2
replace panel_year=panel_year+1
merge 1:1 tdlinx panel_year using $Externals/Calculations/StoreEntryExit/TDlinx_retailer_code_crosswalk.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_tdlinxm1
replace panel_year=panel_year+1
merge 1:1 tdlinx panel_year using $Externals/Calculations/StoreEntryExit/TDlinx_retailer_code_crosswalk.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_tdlinx0
replace panel_year=panel_year+1
merge 1:1 tdlinx panel_year using $Externals/Calculations/StoreEntryExit/TDlinx_retailer_code_crosswalk.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_tdlinx1
replace panel_year=panel_year+1
merge 1:1 tdlinx panel_year using $Externals/Calculations/StoreEntryExit/TDlinx_retailer_code_crosswalk.dta, keepusing(retailer_code) keep(match master) nogen
rename retailer_code retailer_code_tdlinx2
drop panel_year
label values retailer_code* retailer_code

**** Drop entries if ...
* Any trips to that store_code_uc in either of the two years prior to entry (suggests not a new entry)
	* Note: TDLinx.dta is artificially a balanced panel, as is RMS for at least some years, so we do this only for the trips data
		* Exclude Walmart Supercenter conversions; these have retailer code switch from Walmart to Walmart Supercenter (6905 to 6920), but this is a legitimate entry of a new grocery section.
foreach source in trips {
	drop if retailer_code_`source'm2!=.|retailer_code_`source'm1!=. & inlist(sname,"Walmart Supercenter")!=0
}
* Store changes retailer_name in any dataset around the entry
	* Again exclude Walmart Supercenter conversions
foreach source in trips RMS tdlinx {
	drop if retailer_code_`source'0!=retailer_code_`source'm1 & retailer_code_`source'0!=.&retailer_code_`source'm1!=. & inlist(sname,"Walmart Supercenter")!=0
	drop if retailer_code_`source'0!=retailer_code_`source'1 & retailer_code_`source'0!=.&retailer_code_`source'1!=. & inlist(sname,"Walmart Supercenter")!=0
	drop if retailer_code_`source'1!=retailer_code_`source'2 & retailer_code_`source'1!=.&retailer_code_`source'2!=. & inlist(sname,"Walmart Supercenter")!=0
}


**** Choose most likely retailer name
drop retailer_code*m?
gen retailer_code = .
foreach source in tdlinx0 tdlinx1 tdlinx2 trips0 trips1 trips2 RMS0 RMS1 RMS2 { // in order of HA's assessment of reliability. Note that the observation is already dropped if retailer codes 0,1,2 disagree, so this just orders so we use the tdlinx file, then the trips file, then RMS.
	replace retailer_code = retailer_code_`source' if retailer_code==.
}
drop retailer_code_*
/* Get match from sname to retailer code and merge in that match */
***********************************
preserve
gen N=1
collapse (sum) N,by(sname retailer_code)
* Find the retailer_code that best matches the sname
by sname: egen total = sum(N)
gen share = N/total
drop if inlist(retailer_code,.,3996,3997,9999)==1
bysort sname (N): keep if _n==_N
keep if share>0.3 & N>1 // keep if more than X% of stores are classified into the same sname
drop if sname=="AJs Fine" & retailer_code==21 // AJ's/Basha's
drop if sname=="Pavilions"&retailer_code==236 // Pavilions/Vons
drop if sname=="Super G Food & Dru"&retailer_code==90
drop if sname=="Western Beef"&retailer_code==241
keep retailer_code sname
rename retailer_code retailer_code_sname
label values retailer_code retailer_code
saveold $Externals/Calculations/StoreEntryExit/sname_retailer_code_crosswalk.dta, replace
restore
***********************************


*** Merge retailer code using sname
merge m:1 sname using $Externals/Calculations/StoreEntryExit/sname_retailer_code_crosswalk.dta, keepusing(retailer_code_sname) keep(match master) nogen
* Use the sname retailer code if non-missing, except for various snames that match to multiple retailer_codes. One option is to combine the retailer codes by running CleanRetailerCodes.do everywhere. The other is to just not use these for matching when they conflict. When they don't conflict, we use them for matching because they are correct most of the time.
replace retailer_code = retailer_code_sname if retailer_code_sname!=. & inlist(sname,"Food 4 Less","Food City","Giant","Grocery Outlet")!=1 & ///
	inlist(sname,"H E B","Lowes","Martins","Price Chopper","Shop N Save","Super Dollar","Western Beef")!=1
drop retailer_code_sname

** Manual fixes
replace retailer_code = 327 if sname == "99 Ranch"
replace retailer_code = 855 if sname == "Food Basics"
replace retailer_code = 904 if sname == "Food Depot"
replace retailer_code = 906 if sname == "Earth Fare"
replace retailer_code = 914 if sname == "Marcs"
replace retailer_code = 923 if sname == "Culebra Meat"
replace retailer_code = 9101 if sname == "Sams Club"
replace retailer_code = 9103 if sname == "Costco Wholesale"
replace retailer_code = 9104 if sname == "BJs Wholesale Club"

*** Drop an entry if we don't have a Nielsen retailer code. 
	* Reasons:
		* On inspection, these are mostly small latin/international markets, small gourmet/natural markets, other things that are far short of a "supermarket"
		* It makes things confusing to have a different sample for estimating expenditures.
drop if inlist(retailer_code,.,3996,3997,9999)==1

** Rename variables to match subsequent data pipeline set up for ADD
rename store_code_uc store_code
rename sname RetailerName
rename slat storelat
rename slong storelon
rename date_added OpenDate
drop subchannel
rename subchannel_abrev subchannel
gen zip_code = real(substr(szip,1,5))



/*
** Merge zip centroid and spot-check distance.
	* HA looked at the 9 largest distance outliers.
		* One had an erroneous zip in TDLinx but had correct lat/lon
		* Three were wrong
		* Three were totally right and were in weirdly shaped zips with centroids far away.
		* Two had wrong zips
merge m:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match master) nogen keepusing(ZipCentroid*) 
geodist storelat storelon ZipCentroid_lat ZipCentroid_lon, gen(Distance) miles sphere
sort Distance
order Distance
browse if Distance!=.
*/
** Individual data corrections based on the zip comparisons
replace zip_code = 43054 if tdlinx == 1688140
replace zip_code = 31405 if tdlinx == 1911504
drop if inlist(tdlinx,2593034,2144502,1876446) // HA's manual inspection that these addresses are wrong.

/*
** Get a unique location ID variable
	* Comment this out because we want the location IDs to be stable, as they are connected to the drivetime data.
save temp.dta, replace
collapse (first) OpenDate, by(storelat storelon)
drop OpenDate
sort storelat storelon
egen int Store_Location_ID = group(storelat storelon)
drop if Store_Location_ID==.
save $Externals/Calculations/StoreEntryExit/Store_Location_ID.dta // No replace- this file can't be overwritten because we need the Store_Location_ID to not change.
erase temp.dta
*/

keep RetailerName tdlinx store_code retailer_code channel subchannel OpenDate zip_code storelat storelon annvol sftemploy // fips_state_code

** Merge the unique location ID variable.
merge m:1 storelat storelon using $Externals/Calculations/StoreEntryExit/Store_Location_ID.dta, keep(match master)
assert _m==3 // There are no missing observations
drop _m


compress
saveold $Externals/Calculations/StoreEntryExit/AllRetailerEntry.dta, replace

*************************************************************************


** Get the travel time data
	* Outsheet data for perlscript
	*include Code/DataPrep/Homescan/OutsheetLatLonforDrivetime.do
	* Insheet data from perlscript
	include Code/DataPrep/Homescan/ImportDrivetime.do

/* PREP STORE ENTRY DATA AT THE CENSUS TRACT LEVEL */
/* Get list of centroids in the household data, by quarter */
use $Externals/Calculations/Homescan/Prepped-Household-Panel.dta,replace

collapse (first) TractCentroid_lat TractCentroid_lon,by(panel_year HMS_Location_ID)
drop if TractCentroid_lat==.|TractCentroid_lon==.

egen n = group(HMS_Location_ID) // This n identifies each unique location at which a Homescan household exists. Used in the code below.

saveold $Externals/Calculations/Homescan/HomescanLatLon.dta, replace
gen byte Q=1
append using $Externals/Calculations/Homescan/HomescanLatLon.dta
replace Q=2 if Q==.
append using $Externals/Calculations/Homescan/HomescanLatLon.dta
replace Q=3 if Q==.
append using $Externals/Calculations/Homescan/HomescanLatLon.dta
replace Q=4 if Q==.

gen int YQ = yq(panel_year,Q)

saveold $Externals/Calculations/Homescan/HomescanLatLon.dta, replace


/* Now merge all retailer entries into this dataset */
use Store_Location_ID storelat storelon OpenDate store_code retailer_code subchannel using $Externals/Calculations/StoreEntryExit/AllRetailerEntry.dta, clear
sort Store_Location_ID
local N=_N

append using $Externals/Calculations/Homescan/HomescanLatLon.dta, gen(Homescan)
erase $Externals/Calculations/Homescan/HomescanLatLon.dta // This is just a temporary file.

gen sortorder = _n

/* Get entry count indicators */
*local dlist = "15 10"
*foreach d in `dlist' {
*	gen byte Entry_`d' = 0
*	gen long Entrant_store_code_`d' = .
*}

local tlist = "15 10"
foreach t in `tlist' {
	gen byte Entryt_`t' = 0
	*gen long Entrantt_store_code_`t' = .
	gen int Entrantt_retailer_code_`t' = .
	
	gen byte Entryt_S_`t' = 0 // Supercenters only
	gen int Entrantt_S_retailer_code_`t' = . // Could be different because there is overwriting if two stores enter at once
}

*** Loop over all stores to get drive distances and drive times
	rename Store_Location_ID Store_Location_ID_temp

forvalues i = 1/`N' {
	sort sortorder // Need to return to the original order so that the stores are at the top of the dataset.
	display "This is store `i'."
	gen QtrPost = YQ-qofd(OpenDate[`i']) // Quarters post the entry date of the store in row `i'.
	
	foreach dim in lat lon {
		local Store`dim' = store`dim'[`i']
	}
	gen Store_Location_ID = Store_Location_ID_temp[`i']
	*local store_code = store_code[`i']
	local retailer_code = retailer_code[`i']
	local Supercenter = cond(subchannel[`i']=="6-Supercenter",1,0)
	
	* Merge in distances and travel times. 
	merge m:1 Store_Location_ID HMS_Location_ID using $Externals/Calculations/Homescan/DriveTime.dta, nogen keep(match master) keepusing(DriveTime) // Store_Distance

	
	** Travel distance
	*foreach d in `dlist' {
	*	replace Entry_`d' = Entry_`d'+1 if Store_Distance<`d' & Store_Distance>=`d'-5 & QtrPost==0
	*	replace Entrant_store_code_`d' = `store_code' if Store_Distance<`d' & Store_Distance>=`d'-5 & QtrPost==0
	*}	

	** Travel time
	foreach t in `tlist' {
		if `t'<15 {
			replace Entryt_`t' = Entryt_`t'+1 if DriveTime<`t' & DriveTime>=`t'-10 & QtrPost==0
			replace Entryt_S_`t' = Entryt_S_`t'+1 if DriveTime<`t' & DriveTime>=`t'-10 & QtrPost==0 & `Supercenter'==1
			*replace Entrantt_store_code_`t' = `store_code' if DriveTime<`t' & DriveTime>=`t'-10 & QtrPost==0
			replace Entrantt_retailer_code_`t' = `retailer_code' if DriveTime<`t' & DriveTime>=`t'-10 & QtrPost==0 
			replace Entrantt_S_retailer_code_`t' = `retailer_code' if DriveTime<`t' & DriveTime>=`t'-10 & QtrPost==0 & `Supercenter'==1
		}
		if `t'>=15 {
			replace Entryt_`t' = Entryt_`t'+1 if DriveTime<`t' & DriveTime>=`t'-5 & QtrPost==0
			replace Entryt_S_`t' = Entryt_S_`t'+1 if DriveTime<`t' & DriveTime>=`t'-5 & QtrPost==0 & `Supercenter'==1
			*replace Entrantt_store_code_`t' = `store_code' if DriveTime<`t' & DriveTime>=`t'-5 & QtrPost==0
			replace Entrantt_retailer_code_`t' = `retailer_code' if DriveTime<`t' & DriveTime>=`t'-5 & QtrPost==0 
			replace Entrantt_S_retailer_code_`t' = `retailer_code' if DriveTime<`t' & DriveTime>=`t'-5 & QtrPost==0 & `Supercenter'==1
		}
	}

	drop QtrPost Store_Location_ID DriveTime // Store_Distance

}

** drop missing data and the Store list append
drop if Homescan==0
** drop variables from the store entry data
drop storelat storelon OpenDate store_code retailer_code Homescan sortorder Store_Location_ID_temp


saveold $Externals/Calculations/Homescan/HomescanLatLongwithStoreEntry_intermediatetemp.dta, replace
*local tlist = "15 10"
/* Get lag and lead variables */
sort n YQ
	foreach u in t t_S { // d would be for driving distance, but we are using driving time (t). tS is for retailer observed
		if "`u'" == "d" {
			local Entry = "Entry"
		}
		if "`u'" == "t" {
			local Entry = "Entryt"
		}
		if "`u'" == "t_S" {
			local Entry = "Entryt_S"
		}

	foreach n in `tlist' {
		forvalues Qtr = 2/9 {
			local l = 10-`Qtr'
			gen byte Q`Qtr'Post`Entry'_`n' = 0 
			* Look over each of the previous 8 observations (because this dataset is not a balanced panel)
			forvalues f = 1/8 {
				replace Q`Qtr'Post`Entry'_`n' = `Entry'_`n'[_n+`f'] if n==n[_n+`f'] & YQ[_n+`f']-`l'==YQ // This makes the count of entries
			}
		}
		gen byte Q10Post`Entry'_`n' = `Entry'_`n' // Entry is a count of entries
			
		forvalues Qtr = 11/22 {
			local l = 10-`Qtr'
			gen byte Q`Qtr'Post`Entry'_`n' = 0
			* Look over each of the previous 12 observations (because this dataset is not a balanced panel)
			forvalues f = 1/12 {
				replace Q`Qtr'Post`Entry'_`n' = `Entry'_`n'[_n-`f'] if n==n[_n-`f'] & YQ[_n-`f']-`l'==YQ // This makes the count of entries
			}
		}
	
		** Q23: Any lag larger than 12
		gen byte Q23Post`Entry'_`n' = 0
		forvalues f = 1/52 { // 52 is 13 years of data x 4 quarters: the maximum possible number of quarters after an entry
			replace Q23Post`Entry'_`n' = Q23Post`Entry'_`n' + `Entry'_`n'[_n-`f'] if n==n[_n-`f'] & YQ[_n-`f']<=YQ-13 // This the count of entries
		}
			
		/* Get PostEntry variables */
		egen byte Post`Entry'_`n' = rowmax(Q10Post`Entry'_`n'-Q23Post`Entry'_`n') // This (plus the below line) makes an indicator
		replace Post`Entry'_`n' = min(1,Post`Entry'_`n')
		egen byte Count`Entry'_`n' = rowtotal(Q10Post`Entry'_`n'-Q23Post`Entry'_`n') // This is the count
	}
}



compress
saveold $Externals/Calculations/Homescan/HomescanLatLongwithStoreEntry.dta, replace


********************************************************************************
