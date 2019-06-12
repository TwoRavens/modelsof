************************************************************
*-------------- Prep TDLinx from Raw Files ----------------*
************************************************************

*----------------------------------------------------------*
*------------------- Define Directories -------------------*
*----------------------------------------------------------*

global data			"$Externals/Calculations/StoreEntryExit"
global tdlinx		"$Externals/Data/StoreEntryExit"

local loc = "stdlinxscd stdlinxocd slat slong"
local chars = "sname channel subchannel numstores annvol ssqft sgas spharm sliquor sbeer swine"
local TDLinxversion "082616"
local filepref "open_"
local TDLinxyears "04 05 06 07 08 09 10 11 12 13 14 15 16"
local dataset "TDLinx"

*----------------------------------------------------------*
*--------------------- Define Programs --------------------*
*----------------------------------------------------------*

cap prog drop cleanchars
prog define cleanchars
	
if 1==1{	
	foreach var in sgas sliquor swine sbeer {
		replace `var' = "1" if `var' == "Y"
		replace `var' = "0" if `var' == "N"
		replace `var' = "." if `var' == "NULL" | `var' == "---"
		destring `var', replace 
	}
	
	* Annual volume 
	replace annvol = substr(annvol,1,2)
		replace annvol = "250000" if annvol == "01"
		replace annvol = "750000" if annvol == "02"
		replace annvol = "1250000" if annvol == "03"
		replace annvol = "1750000" if annvol == "04"
		replace annvol = "3000000" if annvol == "05"
		replace annvol = "5000000" if annvol == "06"
		replace annvol = "7000000" if annvol == "07"
		replace annvol = "10000000" if annvol == "08"
		replace annvol = "14000000" if annvol == "09"
		replace annvol = "18000000" if annvol == "10"
		replace annvol = "22500000" if annvol == "11"
		replace annvol = "27500000" if annvol == "12"
		replace annvol = "32500000" if annvol == "13"
		replace annvol = "37500000" if annvol == "14"
		replace annvol = "42500000" if annvol == "15"
		replace annvol = "47500000" if annvol == "16"
		replace annvol = "62500000" if annvol == "17"
		replace annvol = "87500000" if annvol == "18"
		replace annvol = "130000000" if annvol == "19"
		replace annvol = "." if annvol == "NU"
	destring annvol, replace
	
	* Number of stores
	replace numstores = substr(numstores,1,1)
	gen nstores = . 
		replace nstores = 1 if numstores == "A"
		replace nstores = 2.5 if numstores == "B"
		replace nstores = 4.5 if numstores == "C"
		replace nstores = 8 if numstores == "D"
		replace nstores = 18 if numstores == "E"
		replace nstores = 38 if numstores == "F"
		replace nstores = 75.5 if numstores == "G"
		replace nstores = 150.5 if numstores == "H"
		replace nstores = 350.5 if numstores == "J"
		replace nstores = 501*1.3 if numstores == "K"

	* Fix store names (for stores in chains with over 200 stores)
	gen sname_original = sname
	foreach name in "A & P" Albertsons BI-LO Biggs "Bristol Farms" Brunos "Dollar General" Maxx "Fresh & Easy" Frys "Giant Eagle" "Harris Teeter" "H E B" Henrys ///
		IGA Jewel "Key Food" Kroger Martins "Piggly Wiggly" "Price Chopper" Publix Ralphs Safeway "Smart & Final" "Stop & Shop" "Tom Thumb" Vons Whites /// 
		"United Grocery" "Wild Oats" "Western Beef" "Winn Dixie" {
		
		replace sname = "`name'" if strpos(sname, "`name'") != 0 
	}
	replace sname = "Maxx" if sname == "Foodmax"
	replace sname = "Maxx" if sname == "Max Foods"
	replace sname = "LoBill" if sname == "Lobill Foods"
	replace sname = "Waldbaums" if sname == "Waldbaum Super Market"
	replace sname = "." if sname == "Grocery Warehouse"
	
	replace sname = subinstr(sname,"The ","",.)
	replace sname = subinstr(sname," Marketplace","",.)
	replace sname = subinstr(sname," Food Market","",.)
	replace sname = subinstr(sname," Market District","",.)
	replace sname = subinstr(sname," Farmers Market","",.)
	replace sname = subinstr(sname," Super Market","",.)
	replace sname = subinstr(sname," Markets","",.)
	replace sname = subinstr(sname," Market","",.) if sname != "The Market"
	replace sname = subinstr(sname," Supermarket","",.)
	replace sname = subinstr(sname," Supermkt","",.)
	replace sname = subinstr(sname," Supermark","",.)
	replace sname = subinstr(sname," Food Store","",.)
	replace sname = subinstr(sname," Food Center","",.)
	replace sname = subinstr(sname," Food Warehouse","", .)
	replace sname = subinstr(sname," Food Mart","",.)
	replace sname = subinstr(sname," Food & Drug","", .)
	replace sname = subinstr(sname," Finer Foods","",.)
	replace sname = subinstr(sname," Foods","",.) if sname != "Whole Foods" & sname != "Foods Co"
	replace sname = subinstr(sname," Super Store","", .)
	replace sname = subinstr(sname," Store","",.)
	replace sname = subinstr(sname," Family","",.)
	
	* 99 Cents
	replace sname = "99 Cents Only" if strpos(sname,"99 Cents Only")!=0 // |strpos(sname,"99 Cents Plus")!=0 HA thinks these may be different
	
	* Alco 
	replace sname = "Alco" if sname=="Alco"|strpos(sname,"Alco Discount Sto")!=0
	
	* Associated Supermarkets
	replace sname = "Associated Supermarkets" if strpos(sname,"Associated Superma")!=0 | strpos(sname,"Associated Food St")!=0|sname=="Associated"
	
	* Carnival
	replace sname = "Carnival" if strpos(sname,"Carnival Food")!=0
	
	* C- Town
	replace sname = "C Town" if sname=="C-Town"
	
	* Compare
	replace sname = "Compare" if sname=="Comparee"
	
	* Festival
	replace sname = "Festival" if strpos(sname,"Festival Mar")!=0|strpos(sname,"Festival Sup")!=0
	
	* Grocery Outlet
	replace sname = "Grocery Outlet" if strpos(sname,"Grocery Outlet Bargain")!=0
	
	* Harvey's
	replace sname = "Harveys" if sname=="Harveyse"
	
	* IGA
	replace sname = "IGA" if sname=="Community IG" | sname=="Cranbury IG" | sname=="Edmonds Fresh IG" | sname=="Fairmount IG"
	
	* Met Food
	replace sname = "Met Food" if sname=="Met"
	
	* Natural Grocers
	replace sname = "Natural Grocers" if strpos(sname,"Natural Grocers Vitamin")!=0|strpos(sname,"Vitamin Cottage")!=0
	
	* Northgate Gonzalez
	replace sname = "Northgate Gonzalez" if sname=="Northgate"
	
	* Pavilions
	replace sname = "Pavilions" if sname=="Pavillions"
	
	* Pioneer
	replace sname = "Pioneer" if sname=="Pioneere"
	
	* Shop n Save
	replace sname = "Shop N Save" if strpos(sname,"Shop & Save")!=0 | strpos(sname,"Shop N Save")!=0
	
	* Shoprite
	replace sname = "ShopRite" if (strpos(sname,"ShopRite")!=0|strpos(sname,"Shoprite")!=0|strpos(sname,"Shop Rite")!=0|strpos(sname,"Shop rite")!=0)
	
	* Sprouts
	replace sname = "Sprouts" if (strpos(sname,"Sprouts")!= 0|strpos(sname,"Sprouts Farmers M")!=0)
	
	* Sunflower
	replace sname = "Sunflower" if strpos(sname,"Sunflower Farmers")!=0
	
	* Super Dollar
	replace sname = "Super Dollar" if strpos(sname,"Super Dollar Dis")!=0 | strpos(sname,"Super Dollar Mark")!=0
	
	* Thorne
	replace sname = "Thornes" if sname=="Thorne"
	
	* Tops 
	replace sname = "Tops" if strpos(sname,"Tops Friendly")!=0
	
	* Value Center
	replace sname = "Value Center" if strpos(sname,"Value Center Mar")!=0
	
	* Value King
	replace sname = "Valu King" if sname == "Value King"
	
	* Walmart
	replace sname = "Walmart" if (strpos(sname,"Wal Mart")!= 0|strpos(sname,"Walmart")!=0) & channel=="08 - Mass Merchandiser"
	replace sname = "Walmart Supercenter" if (strpos(sname,"Wal Mart")!= 0|strpos(sname,"Walmart")!=0) & subchannel=="6 - Supercenter"
	replace sname = "Walmart Neighborhood" if (strpos(sname,"Wal Mart")!=0|strpos(sname,"Walmart")!=0) & subchannel=="5 - Supermarket-Conventional"
	
	* Target
	replace sname = "Target" if strpos(sname,"Target")!=0 & strpos(sname,"City")==0 & channel=="08 - Mass Merchandiser"
	replace sname = "CityTarget" if strpos(sname,"Target")!=0 &strpos(sname,"City")!=0
	replace sname = "SuperTarget" if strpos(sname,"Target")!= 0 & subchannel=="6 - Supercenter"
	
	*Kmart
	*replace sname = "Kmart" if strpos(sname,"Kmart")!= 0&strpos(sname,"Fresh")==0
	replace sname = "Kmart" if strpos(sname,"Kmart")!= 0 & channel=="08 - Mass Merchandiser"
	replace sname = "Kmart Supercenter" if strpos(sname,"Kmart")!= 0 & subchannel=="6 - Supercenter"
}
end

************************************************************
*------------------ Prep New Raw Files --------------------*
************************************************************


	* identify TDLinx stores that went through merger/acquisition
		import delimited using "${tdlinx}/USDAJune2015Changes.txt", clear
							// raw data from USDA
			isid stdlinxscd prevdate
			tostring prevdate, replace
			gen date_change = date(prevdate, "YMD")
			
			foreach v in exit entry {
				preserve
				gen `v'_year = year(date_change)
				gen `v'_month = month(date_change)
				
				isid stdlinxscd `v'_year `v'_month
				keep stdlinxscd `v'_year `v'_month
				saveold "${data}/temp/TDLinx_changes_`v'.dta", replace
				restore
			}

* Location information and store characteristics
	local firstyr = word("`TDLinxyears'", 1)
	di "first year: `firstyr'"
	foreach yr in `TDLinxyears'{
	
		use "${tdlinx}/`filepref'`yr'.dta", clear
		cap rename dateadded Date_Added
		cap rename date_added Date_Added
		cap rename stropen Date_Added
		replace Date_Added = "" if Date_Added == "#N/A"
		foreach var in stdlinxscd stdlinxocd Date_Added slat slong {
			destring `var', replace
		}
		drop if stdlinxscd == .
		sum stdlinxscd
	
		* Lots of duplicates with "NULL" and ""
		replace spharm = "1" if spharm == "Y"
		replace spharm = "0" if spharm == "N"
		replace spharm = "." if spharm == "NULL" | spharm == "" | spharm == "---"
		destring spharm, replace 
	
		* Lots of duplicates (same stdlinxscd and stdlinxocd)
		* Keep one with more information 
		
		duplicates drop `loc' `chars', force
		
		cap noisily isid stdlinxscd stdlinxocd
		if _rc != 0 {
			duplicates tag stdlinxscd stdlinxocd, gen(tag)  
			tab tag
		
			foreach var in ssqft Date_Added {
				gen `var'_mi = `var' == .
				bys stdlinxscd stdlinxocd: egen `var'_mi_dup = sum(`var'_mi)
				drop if tag == 1 & `var'_mi == 1 & `var'_mi_dup == 1
				drop `var'_mi*
			} 
			drop tag
			
			* stdlinxscd duplicates that remain have very different info - drop
			duplicates tag stdlinxscd, gen(tag)
			drop if tag == 1
			drop tag 
		}
		else di "Unique id in `yr': stdlinxscd stdlinxocd"
		
		sort stdlinxscd 
		*saveold "${tdlinx}/tdl20`yr'_clean.dta", replace
	
		* ---------- Clean and combine across years ---------- *
		
		cap drop year
		gen year = 2000+`yr'
		cleanchars
		
		sort stdlinxscd 
		*saveold "${data}/TDLinxstorechars_new_20`yr'.dta", replace
		
		if "`yr'" != "`firstyr'" {
			append using "${data}/TDLinxstorechars_new.dta"
		}
			
		sort stdlinxscd year 
		saveold "${data}/TDLinxstorechars_new.dta", replace	
	}

	

*********************************************************************************************
*--------------- Append Old and New Files and Deal with Multiple Locations -----------------*
*********************************************************************************************

		use "${data}/TDLinxstorechars_new.dta", clear
		
		preserve
	
	**Deal with multiple latitude-longitude pairs
		egen grouplatlong=group(slat slong)
		bys stdlinxscd latlong grouplatlong: gen latlongoccurences=_N 
			// figure out the number of times that each lat-long pair is observed wihtin each store and lat-long recording type
		gsort stdlinxscd latlong -latlongoccurences -year
		by stdlinxscd: keep if _n==1 
			// keep the modal latitude-longitude of type A (Geocoded to specific address), where available, 
			//	B (Geocoded to block group), or otherwise Z - Geocoded to ZIP centriod, using the most recently 
			// recorded latitude-longitude pair observed for a store in cases where two pairs take the modal number 
			// of occurences.
	
		sort stdlinxscd
		keep stdlinxscd slat slong
		saveold "${data}/TDLinxstorelatlongs_FULL.dta", replace	
			// Note: latlongs datasets only contain one unique observation per stdlinxscd.
		
		restore
		foreach v in slat slong latlong {
			rename `v' `v'raw
		}
		merge m:1 stdlinxscd using "${data}/TDLinxstorelatlongs_FULL.dta", nogen
		
	**Merge in full set of blockids		
		rename sblockid sblockidraw
		merge m:1 stdlinxscd using "${tdlinx}/tdlinx_blockids", nogen keep(1 3)
	
	**Sort and save
		sort stdlinxscd year
		saveold "${data}/TDLinxstorechars_FULL.dta", replace
			// Note: store characteristics (including location) vary year-to-year in this dataset.
	
	* identify TDLinx entries
		use "${data}/TDLinxstorechars_FULL.dta", clear
			
		split channel, p(- " ") generate(TDlinx_channel_code)
		destring TDlinx_channel_code1, generate(channel_code)
		des TDlinx_channel_code?, fullname
		drop TDlinx_channel_code?
		
		gen subchannel_abrev = subinstr(subchannel, " ", "", .)
		egen subchannelgrp = group(subchannel_abrev)
		
		tab subchannel_abrev subchannelgrp, m
		
		preserve
		* save a data set of subchannel id
			keep subchannel_abrev subchannelgrp
			bys subchannel_abrev subchannelgrp: keep if _n == 1
			isid subchannel_abrev
			isid subchannelgrp
			saveold "${data}/temp/TDLinx_subchannel_id.dta", replace
		
		restore
		
		preserve
		* save a data set of store subchannel type and block id
			keep stdlinxscd year subchannel subchannel_abrev subchannelgrp sblockid slat slong channel_code
			keep if year >= 2004 & year <= $MaxYear
			saveold "${data}/temp/TDLinx_storeinfo_2005_2012.dta", replace
		
		restore
		
		preserve
		* save a data set that identifies the number of stores of each type in each block in each year
			isid stdlinxscd year
			gen stcount = 1
			collapse (sum) stcount, by(sblockid year subchannelgrp) fast
			
			reshape wide stcount, i(sblockid year) j(subchannelgrp)
			rename year prevyear
			tempfile tempblock
			save `tempblock'
		restore
		
		tostring Date_Added, replace
		gen date_added = date(Date_Added, "YMD")
		format date_added %td
		label var date_added "TDLinx date added"
		drop Date_Added
				
		gen entry_year = year(date_added)
		gen entry_month = month(date_added)
		keep if entry_year>=2004 & entry_year<=$MaxYear
		bys stdlinxscd (year date_added): keep if _n ==1 
		
		rename year tdlinx_year	

	***Entry validity check...
		di "* Merge in store availability in a block in the year before entry"
			gen prevyear = tdlinx_year - 1 
			count
			merge m:1 sblockid prevyear using `tempblock', keep(1 3) 
			drop _merge
			
		di "* Identify invalid entry"
			* a store entry is considered invalid if there exist stores of the same type (subchannel) in the year before entry year in the block where the store is located 
			levelsof subchannelgrp, local(channelgrp)
			gen invalidentry = 0
			foreach g of local channelgrp{
				replace invalidentry = 1 if subchannelgrp == `g' & stcount`g' > 0 & stcount`g' != .
			}
			di "number of entries:"
				count
			di "number of invalid entries:"
				count if invalidentry==1
			drop if invalidentry == 1
		
			drop stcount* invalidentry prevyear
			cap drop _merge
			
		di "* Drop store entry, for which a merger & acquisition is observed in the same month"
			count
			merge m:1 stdlinxscd entry_year entry_month using "${data}/temp/TDLinx_changes_entry.dta", keep(1 3) 
					 // created in subprogram tdlinxID
			keep if _merge==1
			drop _merge
				
		di "*Merge in sales information for potential weighting scheme"
			rename  tdlinx_year year
			merge 1:1 stdlinxscd year using "${data}/TDLinxstorechars_FULL.dta", keepusing(swklyvol ssqft annvol) keep(1 3)
			rename year tdlinx_year 
			drop _merge
			
		* Save 
			compress
			rename stdlinxscd tdlinx
			saveold "${data}/TDLinxEntries.dta", replace
		
		* Erase temporary files
		foreach file in TDLinxstorechars_FULL TDLinxstorechars_new TDLinxstorelatlongs_FULL {
			erase $Externals/Calculations/StoreEntryExit/`file'.dta
		}
