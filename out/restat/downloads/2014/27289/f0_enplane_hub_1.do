

set more off

* cleans concentration data
	
	use "clean_2000.dta", clear

	* drops total rows and extra spaces from xls files
	drop if locid==""
	drop if carrier=="Airport Total"
	drop if carrier==""
	drop if enplane==.
	
	* checks if data was read in incorrectly for airports with one carrier (ruben error)
	bysort locid: egen airport_enplane=total(enplane)
	gen temp=0
	replace temp=1 if airport_enplane<enplane
	bysort locid: egen ruben_flag=max(temp)
	drop temp
	su ruben_flag
		
	* calculates carrier shares at each airport
	gen pct_enplane=enplane/airport_enplane
	
	* generates share of top 2 carriers at each airport (and each seperately)
	gen temp=1
	gsort locid -pct_enplane
	by locid: gen carrier_rank=sum(temp)
	drop temp
	
	keep if carrier_rank==1
	drop carrier_rank
	
	gen temp=""
	replace temp="WN" if carrier=="SOUTHWEST AIRLIN"
	replace temp="DL" if carrier=="DELTA AIRLINES,"
	replace temp="CO" if carrier=="CONTINENTAL AIRL"
	replace temp="AA" if carrier=="AMERICAN AIRLINE"
	replace temp="FL" if carrier=="AIRTRAN AIRWAYS,"
	replace temp="UA" if carrier=="UNITED AIRLINES,"
	replace temp="US" if carrier=="US AIRWAYS, INC."
	replace temp="NW" if carrier=="NORTHWEST AIRLIN"
	replace temp="TW" if carrier=="TRANS WORLD AIRL"
	replace temp="AS" if carrier=="ALASKA AIRLINES,"
	replace temp="HA" if carrier=="HAWAIIAN AIRLINE"
	replace temp="YX" if carrier=="MIDWEST EXPRESS"
	replace temp="AQ" if carrier=="ALOHA AIRLINES,"
	replace temp="HP" if carrier=="AMERICA WEST AIR"
	replace temp="JI" if carrier=="MIDWAY AIRLINES,"
	
	
	drop carrier
	gen carrier=temp
	drop temp
	
	gen domcarrier=1
	
	keep if carrier~=""
	
	
	* keeps only variables needed
	keep carrier locid domcarrier
	rename locid airport 
	sort airport carrier
	save "dominant.dta", replace
	

