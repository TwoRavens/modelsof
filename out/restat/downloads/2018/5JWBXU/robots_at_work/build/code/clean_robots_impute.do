* imputing robot deliveries based on industry shares in years when non-missing
		
	* indicate when reporting started
	local AUS `"country=="AUS" & year>=2006"'
	local AUT `"country=="AUT" & year>=2003"'
	local BEL `"country=="BEL" & year>=2004"'
	local CHN `"country=="CHN" & year>=2006"'
	local DNK `"country=="DNK" & year>=1996"'
	local GRC `"country=="GRC" & year>=2006"'
	local HUN `"country=="HUN" & year>=2004"'
	local IRL `"country=="IRL" & year>=2006"'
	local KOR `"country=="KOR" & year!=2002 & year>=2001"'
	local NLD `"country=="NLD" & year>=2004"'
	local US `"country=="US" & year>=2004"'
		
	gen incl = ( country=="AUS" | country=="AUT" | country=="BEL" 	///
				| country=="CHN" | country=="DNK" | country=="GRC" 	///
				| country=="HUN" | country=="IRL" | country=="KOR"  ///
				| country=="NLD" | country=="US" )
		
	gen imp_delvrd = incl // imputation flag		
		la var imp_delvrd "imputation flag for deliveries"
		la def yesno 0 "No" 1 "Yes"
		la val imp_delvrd yesno
		
	* compute total for each country-year with non-missings, compute shares
	sort country year code_robots
		
	by country year: egen sumindus = total(delvrd)
	by country year: gen share = delvrd/sumindus
    
    * compute average shares and fill in, indicate imputation
	sort country code_robots year
				
	gen avg_share = .
	
	local countrylist "AUS AUT BEL CHN DNK GRC HUN IRL KOR NLD US"
	
	foreach country in `countrylist' {
		by country code_robots: egen avg_share_`country' = mean(share) if ``country''
		
		replace avg_share = avg_share_`country' if ``country''
		
		replace imp_delvrd = 0 if ``country''
	}
		
	by country code_robots: egen mean_share = mean(avg_share)
		drop avg_share*
				
	* imputation
	gen delvrd_raw = delvrd
		
	replace delvrd = mean_share*sumindus if imp_delvrd==1

	drop incl sumindus share
