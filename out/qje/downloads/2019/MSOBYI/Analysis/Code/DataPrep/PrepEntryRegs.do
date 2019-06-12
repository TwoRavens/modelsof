/* PrepEntryRegs.do */
* This file takes the prepped household-by-quarter Homescan data and merges in the store entry dataset.
* It then takes the prepped household-by-year Homescan data and merges the ZPB supply dataset

global WindowList = "408 808" // "308 408 508 608 612 412"
global dlist = "15 10" // 015 // "S" for Supercenters



/* MERGE INTO QUARTERLY TRANSACTIONS DATA */
foreach dataset in HHxQuarter { // HHxQuarter_Magnet
	use household_code YQ Calories expshare_Grocery expshare_ChainGroc expshare_Mass expshare_Club expshare_Super expshare_DrugConv ///
		Produce lHEI_per1000Cal HEI_per1000Cal HealthIndex_per1000Cal InSample using $Externals/Calculations/Homescan/`dataset'.dta, replace, if InSample==1 // MilkFatPct Whole FreshProduce
	drop InSample
	gen int panel_year = year(dofq(YQ))
	
		* Implied expenditure shares
		gen expshare_SuperClub = expshare_Super+expshare_Club
		gen expshare_OtherMass = expshare_Mass-expshare_SuperClub
		gen expshare_CSC = expshare_ChainGroc+expshare_SuperClub
		gen expshare_GSC = expshare_Grocery+expshare_SuperClub
		gen expshare_NonChainGroc = expshare_Grocery-expshare_ChainGroc

		*gen expshare_ChainSuper = expshare_Super+expshare_ChainGroc
		* Alternative expshares moving Walmart and Target to the Entrant and Supercenter categories (it appears that some Walmart and Target supercenters are miscategorized in Homescan retailer codes as being regular)
		*foreach channel in SuperClub Entrant CSC GSC {
		*	gen expshare_A`channel' = expshare_`channel' + expshare_WalTar
		*}		

	** Merge household data
		/*
		if "`dataset'" == "HHxQuarter" {
			local pf = "projection_factor"
		}
		if "`dataset'" == "HHxQuarter_Magnet" {
			local pf = "projection_factor_magnet"
		}
		*/ 
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		nogen keep(match master) keepusing(FirstYearInZip HMS_Location_ID CTractGroup zip_code region_code IncomeResidQuartile $Ctls_Merge) // `pf'

	** Merge the store entry data
	merge m:1 HMS_Location_ID YQ using $Externals/Calculations/Homescan/HomescanLatLongwithStoreEntry.dta, keep(match master) nogen ///  TractCentroid_lat TractCentroid_lon
		keepusing(*PostEntryt_?? CountEntryt_?? CountEntryt_S_?? Entrantt_retailer_code_?? Entrantt_S_retailer_code_??) // CountEntryt_RetObs_1?  PostEntry_5 PostEntry_10
	
	* Merge subchannel
	/*
	foreach d in $dlist {
		gen store_code = Entrantt_store_code_`d'
		merge m:1 store_code using $Externals/Calculations/StoreEntryExit/AllRetailerEntry.dta, keep(match master) keepusing(subchannel) nogen
		rename subchannel subchannel_`d'
		drop store_code
	}
	*/
	
	** Generate the 0-15 minute data
	if strpos("$dlist","015")!=0 {
		forvalues q = 2/23 {
			gen Q`q'PostEntryt_015 = Q`q'PostEntryt_10+Q`q'PostEntryt_15
		}
		gen CountEntryt_015 = CountEntryt_10+CountEntryt_15
	}
		
	*** Merge expenditures across all entrant stores
	** Get a list of entering store and retailer codes for each household
	foreach code in retailer { // store
		foreach time in 10 15 {
			foreach u in t t_S {
				preserve 
				keep household_code Entrant`u'_`code'_code_`time'
				drop if Entrant`u'_`code'_code_`time'==.
				duplicates drop // In some cases a household has two different stores from the same retailer enter; drop these duplicates so we don't double-count these expenditures
				rename Entrant`u'_`code'_code_`time' `code'_code
				bysort household_code: gen n=_n
				reshape wide `code'_code, i(household_code) j(n)
				saveold $Externals/Calculations/Homescan/Temp_`code'_`u'_`time'.dta, replace
				restore
			}
		}
	}
	
	
	** Merge those entries
	foreach code in retailer { // store
		foreach u in t t_S {
			gen expshare_E`u'`code' = 0
	
			foreach time in 10 15 {
				merge m:1 household_code using $Externals/Calculations/Homescan/Temp_`code'_`u'_`time'.dta, ///
					nogen keep(match master)
				** Get expenditures for each entry and add to the expshare_E variable
				foreach var of varlist `code'_code* { 
					rename `var' `code'_code_uc
					merge 1:1 household_code YQ `code'_code_uc using $Externals/Calculations/Homescan/HHxQuarterx`code'.dta, ///
						keep(match master) keepusing(expshare) nogen
					replace expshare_E`u'`code' = expshare_E`u'`code' + expshare if expshare!=.
					drop `code'_code_uc expshare
				}
				erase $Externals/Calculations/Homescan/Temp_`code'_`u'_`time'.dta
			}
		}
	}
	** Rename variables for estimates
	rename expshare_Etretailer expshare_Eretailer
	rename expshare_Et_Sretailer expshare_ESretailer
	
	*****************************
	/*
	* tk temp: merge Walmart expenditures
	foreach retailer in 6905 6920 {
		gen expshare_`retailer' = 0
		gen retailer_code_uc = `retailer'
		merge 1:1 household_code YQ retailer_code_uc using $Externals/Calculations/Homescan/HHxQuarterxretailer.dta, ///
			keep(match master) keepusing(expshare) nogen
		replace expshare_`retailer' = expshare if expshare!=.
		drop retailer_code_uc expshare
	}
	gen expshare_Wal = expshare_6905+expshare_6920
	
	*
	*/
	******************************
	
	** Merge zip code supply characteristics as of each household's first year in the zip
	gen int year = FirstYearInZip
	local ZipChars = "meanHealthIndex NProduceUPCs lnNProduceUPCs est_Large est_LargeGroc est_SuperClub meanHealthIndex_3m NProduceUPCs_3m lnNProduceUPCs_3m est_Large_3m est_LargeGroc_3m est_SuperClub_3m" //  
	merge m:1 zip_code year using $Externals/Calculations/Geographic/ZipCodeSupplyInfo_3m.dta, nogen keep(match master) ///
		keepusing(`ZipChars' est_LSmallGroc est_LSmallGroc_3m)	
	foreach var in `ZipChars' est_LSmallGroc est_LSmallGroc_3m {
		rename `var' `var'Pre
	}
	drop year
		

	/* Balanced indicator variables and expenditures at entrant retailer */	
	foreach d in $dlist {
		foreach window in $WindowList {
			sort household_code YQ
			local prewindow = real(substr("`window'",1,1))
			local postwindow = real(substr("`window'",2,2))
			*** Balanced for figure
				* Define as Balanced if we see one entry, `prewindow' quarters before, and `postwindow' quarters after, with no missing quarters, in the same location
			** Balanced`window'_`d'_begin will represent the entry quarter of a balanced window.
			gen byte Balanced`window'_`d'_begin = 1 if Q10PostEntryt_`d'==1 // & inlist(subchannel_`d',"5-Supermarket-Conventional")==1 // ,"6-Supercenter"
			* Make sure we observe `prewindow' consecutive quarters before
			/*forvalues l= 1/`prewindow' {
				local Qtr=10-`l'
				replace Balanced`window'_`d'_begin = 0 if household_code[_n-`l']!=household_code | YQ[_n-`l']!=YQ-`l' | Q`Qtr'PostEntryt_`d'[_n-`l']!=1 | CTractGroup[_n-`l']==CTractGroup
			}
			*/
			* Make sure we observe `postwindow' consecutive quarters after
			forvalues l=-`prewindow'/`postwindow' {
				local Qtr=10+`l'
				replace Balanced`window'_`d'_begin = . if household_code[_n+`l']!=household_code | YQ[_n+`l']!=YQ+`l' | Q`Qtr'PostEntryt_`d'[_n+`l']!=1 | CTractGroup[_n+`l']!=CTractGroup
			}
			* Ensure only one entry over the period
			replace Balanced`window'_`d'_begin = . if CountEntryt_`d'!=CountEntryt_`d'[_n-`prewindow']+1 | CountEntryt_`d'!=CountEntryt_`d'[_n+`postwindow']
			
			* If any balanced windows will conflict, drop the later one
				* This does allow windows to persist if there is an unbalanced panel between them
			local begin = `postwindow'+1
			local end = `postwindow'+`prewindow'
			forvalues q = `begin'/`end' {
				replace Balanced`window'_`d'_begin = . if Balanced`window'_`d'_begin[_n-`q']==1 & household_code==household_code[_n-`q'] ///
					& YQ==YQ[_n-`q']+`q'
			}
			
			** Generate the balanced window indicator and the retailer code for that entry
			gen byte Balanced`window'_`d' = cond(Balanced`window'_`d'_begin==1,1,0)
			*gen long Entrantt_store_code`window'_`d' = .
			gen long Entrantt_retailer_code`window'_`d' = . 
			forvalues l=-`prewindow'/`postwindow' {
				replace Balanced`window'_`d'=1 if Balanced`window'_`d'_begin[_n-`l']==1
				*replace Entrantt_store_code`window'_`d' = Entrantt_store_code_`d'[_n-`l'] if Balanced`window'_`d'_begin[_n-`l']==1
				replace Entrantt_retailer_code`window'_`d' = Entrantt_retailer_code_`d'[_n-`l'] if Balanced`window'_`d'_begin[_n-`l']==1 
			}
			
			** Merge expenditures at entrant retailer
			foreach code in retailer { // store
				gen long `code'_code_uc = Entrantt_`code'_code`window'_`d'
				merge 1:1 household_code YQ `code'_code_uc using $Externals/Calculations/Homescan/HHxQuarterx`code'.dta, ///
					keep(match master) keepusing(expshare) nogen
				
				rename expshare expshare_E`code'`window'_`d'
				replace expshare_E`code'`window'_`d' = 0 if expshare_E`code'`window'_`d'==. & `code'_code_uc!=. // This sets to zero if the retailer code is known. If retailer code not known, then this is missing.
				drop `code'_code_uc
			}
			/* include this in EntryRegs.do
			*** Make the PostEntryt indicators 0 if in the Balanced window but not part of the entry being studied. 
				* This is necessary only for cases where the pre-window is part of the end of the post-window for a previous entry that occurred more than 3 quarters before, or when the post-window is part of the pre-window for a later entry that occurs more than 8 quarters later.
			local begin = 10-`prewindow'
			local end = 10+`postwindow'
			forvalues q = `begin'/`end' {
				replace Q`q'PostEntryt_`d' = 0 if Balanced`window'_`d'==1 & Balanced`window'_`d'_begin[_n+10-`q']!=1
			}
			*/
			*drop Balanced`window'_`d'_begin
			
		}
	}
	
	** Rescale variables
	* Produce share and expenditure shares in percentage points
	foreach var of varlist Produce expshare_* { // FreshProduce
		replace `var' = `var'*100
	}
	gen lnCalories = ln(Calories)
	
	** Household x census tract fixed effect group
	egen household_location = group(household_code CTractGroup)
	
	** Time/Region controls
	egen RegionYear = group(region_code panel_year)
	egen RegionYQ = group(region_code YQ)
	compress
	
	** Labels 
	label var CountEntryt_10 "Post entry: 0-10 minutes"
	label var CountEntryt_15 "Post entry: 10-15 minutes"
	capture label var CountEntryt_S_10 "Post entry: 0-10 minutes"
	capture label var CountEntryt_S_15 "Post entry: 10-15 minutes"
	save $Externals/Calculations/Homescan/`dataset'withEntry.dta, replace
}


