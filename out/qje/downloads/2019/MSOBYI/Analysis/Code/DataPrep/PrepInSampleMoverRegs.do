/* PrepInSampleMoverRegs.do */
* This file takes the prepped household-by-time Homescan data and merges in the movers


/* SETUP */
global AreaTypeList = "Ct Z"


/* GET TRANSACTIONS DATA, MERGE TRIP SHARES, AND THEN MERGE LOCAL INFO */
local Vars = "ShareCoke $HealthVar" // Produce g_prot_per1000Cal g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal" 
local PrD_Vars = "PrD_ShareCoke PrD_$HealthVar" // PrD_Produce PrD_g_prot_per1000Cal PrD_g_fiber_per1000Cal PrD_g_fat_sat_per1000Cal PrD_g_sugar_per1000Cal PrD_g_sodium_per1000Cal PrD_g_cholest_per1000Cal"

foreach Freq in Year { // Quarter Year
	if "`Freq'" == "Year" { 
		global WindowList = "102 300 103" // ""
		local tvar = "panel_year"
		use household_code panel_year `Vars' ///
			Calories CokePepsi_Calories InSample using $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
	}
	if "`Freq'" == "Quarter" {
		global WindowList = "308 408 412 812"
		local tvar = "YQ"
		use household_code YQ `Vars' ///
			Calories CokePepsi_Calories InSample using $Externals/Calculations/Homescan/HHxQuarter.dta, replace, if InSample==1	
		gen int panel_year = year(dofq(YQ))

	}
	drop InSample

	
	** Merge controls from household data
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		nogen keep(match master) keepusing(projection_factor $Ctls_Merge IncomeResidQuartile)	
	
	** Merge trip share data
		* Note that we use county trip shares (instead of zips) because people often shop outside their own zips.
	merge 1:1 household_code `tvar' using $Externals/Calculations/Homescan/TripShares_Ct_`Freq'.dta, keep(match master) keepusing(TripShareInCt_9 TripShareInCt_10) nogen
		gen ShareTripsInCurrentCt = TripShareInCt_10 

	/* Loop over area types */
	foreach areatype in $AreaTypeList {
		include Code/DataPrep/DefineGeonames.do
	
		** Merge location and mover indicator from household data
		merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
			nogen keep(match master) keepusing(`geoname' Move`areatype'Year)	
	

	
	
		/* Loop over balanced windows */
		local MinTripShare = 0.5 // The below code requires MinTripShare or more of observed RMS trips be in the local area for all periods before or after a move
		
		if "`Freq'" == "Quarter" {
			*** Get Move`areatype'Quarter
			gen byte quarter = quarter(dofq(YQ))
			sort household_code YQ
			gen byte Move`areatype'Quarter = cond( Move`areatype'Year==1 & ///
				TripShareInCt_10[_n+1]>=`MinTripShare' & TripShareInCt_10[_n+1]!=. & household_code==household_code[_n+1] & ///
				( (quarter>1 & TripShareInCt_9[_n-1]>=`MinTripShare' & TripShareInCt_9[_n-1]!=.) | ///
				  (quarter==1 & TripShareInCt_10[_n-1] & TripShareInCt_10[_n-1]!=.>=`MinTripShare')  ) , 1,0)
			
			** Clean moves will have two consecutive quarters that satisfy the above. Use the one with a smaller difference in trip share. If ties, use the later one.
			gen TripShareDiff = abs(TripShareInCt_10-TripShareInCt_9)
			replace Move`areatype'Quarter=0 if Move`areatype'Quarter==1&Move`areatype'Quarter[_n+1]==1 & TripShareDiff[_n+1]<=TripShareDiff & TripShareDiff[_n+1]!=. & TripShareDiff!=.
			replace Move`areatype'Quarter=0 if Move`areatype'Quarter==1&Move`areatype'Quarter[_n-1]==1 & TripShareDiff[_n-1]<TripShareDiff & TripShareDiff[_n-1]!=. & TripShareDiff!=.
			drop TripShareDiff

			** If still more than one MoveQuarter in a year, drop both.
			bysort household_code panel_year: egen sumMove`areatype'Quarter=sum(Move`areatype'Quarter)
			replace Move`areatype'Quarter = 0 if sumMove`areatype'Quarter>1
			drop sumMove`areatype'Quarter
			
			*** Fix ShareTripsInCurrent`areatype' for quarters before move in year of move
			forvalues q=1/3 {
				replace ShareTripsInCurrentCt = TripShareInCt_9 if MoveCtYear==1 & MoveCtQuarter==0 & ///
					Move`areatype'Quarter[_n+`q']==1 & household_code==household_code[_n+`q'] & panel_year==panel_year[_n+`q']
				* Fix location for quarters before move in year of move	
					this is required to get the proper location characteristics below
				replace `geoname' = `geoname' tk
			}
			
			
			
		}
		
		foreach window in $WindowList {
			local prewindow = real(substr("`window'",1,1))
			local postwindow = real(substr("`window'",2,2))
			/* Get Balanced indicator */ 
			gen byte Balanced`window'_`areatype'_begin = 1 if Move`areatype'`Freq'==1 
			sort household_code `tvar'
			* Make sure we observe balanced panels over the move window.
			forvalues l=-`prewindow'/`postwindow' {
				replace Balanced`window'_`areatype'_begin = . if household_code[_n+`l']!=household_code | `tvar'[_n+`l']!=`tvar'+`l' 			
			}	
			
			* Make sure we observe the household in the same post-move location for the full postwindow
				* and that MinTripShare or more of the trips are in the current location. (Note that this also keeps the observation if ShareTripsInCurrent`areatype'==., meaning that none of the observed trips are in RMS.
			forvalues l=1/`postwindow' {
				replace Balanced`window'_`areatype'_begin = . if `geoname'[_n+`l']!=`geoname' | ///
					ShareTripsInCurrentCt[_n+`l'] < `MinTripShare'
			}
			* Make sure we observe the household in the same pre-move location for the full prewindow
				* and that MinTripShare or more of the trips are in the current location
			forvalues l=1/`prewindow' {
				replace Balanced`window'_`areatype'_begin = . if `geoname'[_n-`l']!=`geoname'[_n-1] | ///
					ShareTripsInCurrentCt[_n-1] < `MinTripShare'
			}
			
			* If any balanced windows will conflict, drop the later one
				* This does allow windows to persist if there is an unbalanced panel between them
			local begin = `postwindow'+1
			local end = `postwindow'+`prewindow'
			forvalues l = `begin'/`end' {
				replace Balanced`window'_`areatype'_begin = . if Balanced`window'_`areatype'_begin[_n-`l']==1 & household_code==household_code[_n-`l'] ///
					& `tvar'==`tvar'[_n-`l']+`l'

			}
			
			** Get the count of moves by household
			sort household_code `tvar'
			bysort household_code: gen byte HH`areatype'MoveCount`window'_temp = sum(Balanced`window'_`areatype'_begin) if Balanced`window'_`areatype'_begin==1
	
			** Generate the balanced window indicator and move count
			gen byte Balanced`window'_`areatype' = cond(Balanced`window'_`areatype'_begin==1,1,0)
			gen byte HH`areatype'MoveCount`window' = .
			
			forvalues l=-`prewindow'/`postwindow' {
				replace Balanced`window'_`areatype'=1 if Balanced`window'_`areatype'_begin[_n-`l']==1
				replace HH`areatype'MoveCount`window' = HH`areatype'MoveCount`window'_temp[_n-`l'] if HH`areatype'MoveCount`window'_temp[_n-`l']!=.
			}
			
			** Get PostMove event study time variable and indicator
				* Takes value 0 if not near a move. Does not require a balanced panel. 
				gen byte Post`areatype'Move`window't = 0 
				sort household_code `tvar'
				local begin = 10-`prewindow'
				local end = 10+`postwindow'
				forvalues l=`begin'/`end' {
					replace Post`areatype'Move`window't = `l' if Balanced`window'_`areatype'_begin[_n+10-`l']==1
				}
			
			gen byte Post`areatype'Move`window' = cond(Post`areatype'Move`window't>10,1,0)
			drop Balanced`window'_`areatype'_begin HH`areatype'MoveCount`window'_temp
			
			***************************************************************
	
			/* Merge characteristics of old and new location */
			foreach l in O N { // Old and New locations
				if "`l'" == "O" {
					local t = 9 // time index just prior to move year
				}
				else if "`l'" == "N" { // time index just after the move
					local t = 10 
				}	
				
				*** Merge demand characteristics of old and new locations
				rename `geoname' `geoname'_hold
					
				gen `geodatatype' `geoname'_temp = `geoname'_hold if Post`areatype'Move`window't==`t'
				bysort household_code HH`areatype'MoveCount`window': egen `geodatatype' `geoname' = mean(`geoname'_temp) if HH`areatype'MoveCount`window'!=.
				
				merge m:1 `geoname' using $Externals/Calculations/Geographic/`areatype'_DemandInfo.dta, nogen keep(match master) ///
					keepusing(`PrD_Vars')
				foreach var in `PrD_Vars' {
					rename `var' `areatype'`window'`l'`var' 
				}
				drop `geoname'_temp
				rename `geoname' `l'`window'_`geoname'
				rename `geoname'_hold `geoname'
			}	
		
			*** Characteristics with areatype prefix
			foreach var in `Vars' {
			
				* Change from old to new
				gen D`areatype'`window'`var' = `areatype'`window'NPrD_`var' - `areatype'`window'OPrD_`var'
				
				* Replace with zero if missing
				replace D`areatype'`window'`var' = 0 if D`areatype'`window'`var'==.

			}		
		}
		
		/* Merge demand characteristics of current location */
		merge m:1 `geoname' using $Externals/Calculations/Geographic/`areatype'_DemandInfo.dta, nogen keep(match master) ///
		keepusing(`PrD_Vars')
		foreach var in `PrD_Vars' {
			rename `var' `areatype'_`var' 
		}
	}
	
	** Get indicator for shopping in own zip code.
		* Include if missing ShareTripsInCurrentCt (which is because of shopping in all or mostly non-RMS stores) because the data do show that most households do indeed shop in their own counties.
	gen byte OverMinTripShare = cond(ShareTripsInCurrentCt>=`MinTripShare'|ShareTripsInCurrentCt==.,1,0)
	
	** Drop un-needed variables
	drop TripShareInCt_*
	
	** Label variables	
	capture label var Ct_PrD_ShareCoke "County average Coke market share" 
	capture label var Ct_PrD_HealthIndex "County average Health Index" 
	capture label var Ct_PrD_lHEI "County average Health Index" 		

	capture label var Z_PrD_HealthIndex "Zip code average Health Index" 
	capture label var Z_PrD_lHEI "Zip code average Health Index" 
			
	compress
	saveold $Externals/Calculations/Homescan/HHx`Freq'withInSampleMovers.dta, replace
}	













