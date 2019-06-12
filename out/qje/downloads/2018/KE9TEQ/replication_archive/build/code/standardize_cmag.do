/**************************************************************************
	
	Program: standardize_cmag.do
	Political Advertising Project
	Last Update: July 2016
	JS/DT
	
	Standardize CMAG data from Wisconsin Advertising Project	
		and Wesleyan Media Project.
	
**************************************************************************/

* Age and sex-age groups in Nielsen data 

* Standardizes file (Takes year and office as arguments)
	cap program drop standardize_cmag
	program define standardize_cmag
	
		* Arguments
		local year = `1'
		local office = "`2'"
		
		* Abbreviations for sex-age groups
		local male_2_plus = "m2_p"
		local male_18_34 = "m18_34"
		local male_35_64 = "m35_64"
		local male_65_plus = "m65_p"
		local male_35_plus = "m35_p"
		local male_18_plus = "m18_p"
		local female_2_plus = "f2_p"
		local female_18_34 = "f18_34"
		local female_35_64 = "f35_64"
		local female_65_plus = "f65_p"
		local female_35_plus = "f35_p"
		local female_18_plus = "f18_p"
		
		recode statdist (1505=1501)
		
		* National ads are handled separately
		* Nielsen ratings information not available at local level for Cable 
		replace market = upper(market)
		drop if inlist(market,"CABLE","NATIONAL","NATIONAL CABLE","NATIONAL NETWORK")
		
		* Drop Alaska markets
		drop if inlist(market,"ANCHORAGE","FAIRBANKS","JUNEAU")
		
		* Fix known issues in CMAG data
		replace market = "ABILENE-SWEETWATER" if regexm(market,"ABILENE\-SWEET.*")
		replace market = "ALBANY, NY" if market == "ALBANY"		
		replace market = "BLFLD-BECKLY-OH" if regexm(market,"BLUEFIELD\-BECK.*")
		replace market = "BOSTON" if inlist(market,"MANCHESTER, NH","MANCHESTER,")
		replace market = "CASPER-RIVERTON" if market == "CASPER"
		replace market = "CHARLESTON-HUNTINGTON" if market == "CHARLESTON SC" & inlist(fips,54,21,39)
		replace market = "CHARLESTON, WV" if inlist(market,"CHARLESTON","CHARLESTON,")
		replace market = "COLORADO SPRINGS" if inlist(market,"COLORADO SPR","COLORADO SPRING","COLORADO SPRIN") 
		replace market = "COLUMBUS-TUPELO-WESTPOINT" if regexm(market,"COLUMBUS.TUP.*")
		replace market = "COLUMBUS, OH" if market == "COLUMBUS"
		replace market = "GREENVILLE, SC" if inlist(market,"GREENVILLE","GREENVILLE,")
		replace market = "HATIESBRG-LAURL" if regexm(market,"HATTIESBURG.*")
		replace market = "IDHFLS-PC(JCK)" if regexm(market,"IDAHO FALLS\-POC.*")
		replace market = "JACKSON, MS" if market == "JACKSON"
		replace market = "LAFAYETTE, LA" if inlist(market,"LAFAYETTE","LAFAYETTE, L")
		replace market = "LAFAYETTE, IN" if market == "LAFAYETTE, I"
		replace market = "MEDFORD-KLMFLS" if regexm(market,"MEDFORD-KLAMATH.*")
		replace market = "ROCHESTER, NY" if inlist(market,"ROCHESTER, N","ROCHESTER")
		replace market = "ROCHESTER, MN" if market == "ROCHESTER, M"
		replace market = "SANTA BARBARA" if market == "SANTA BARBAR"
		replace market = "SPRINGFIELD, MO" if inlist(market,"SPRINGFIELD","SPRINGFIELD, M")
		replace market = "WEST PALM BEACH" if market == "WEST PALM BEAC"
		replace market = "WHEELING-STEUBENVILLE" if regexm(market,"WHEELING\-STE.*")
		
		* Dates
		gen days_to_election = date("${election`year'}","DMY") - stata_date
		keep if inrange(days_to_election,0,180)
		egen period = cut(days_to_election), at(0,15,31,61,121,181) icodes
		format stata_date %td
		format stata_time %tC
		gen hour = hh(stata_time)
		gen minute = mm(stata_time)
		gen halfhour = floor(minute/30)
		gen quarterhour = floor(minute/15)
		
		* Recode ad characeteristics
		tostring tone, replace force
		replace tone = "oth" if inlist(tone,"98","99",".","N/A")
		replace tone = "att" if inlist(tone,"1","NEG","NEGATIVE")
		replace tone = "con" if inlist(tone,"2","CONTRAST")
		replace tone = "pro" if inlist(tone,"3","PRO","POSITIVE","POS")
		
		tostring party, replace force
		replace party = "dem" if party == "1"
		replace party = "rep" if party == "2"
		replace party = "oth" if party == "3"
		
		tostring sponsor, replace force
		replace sponsor = "oth" if sponsor == "."
		replace sponsor = "can" if sponsor == "1"
		replace sponsor = "pty" if sponsor == "2"
		replace sponsor = "int" if sponsor == "3"
		replace sponsor = "hyb" if sponsor == "4"
		
		if inlist(`year',2004,2008) {
					
			* Merge Nielsen ratings information in 15- and 30-minute intervals
			merge m:1 distributor stata_date hour quarterhour using "$data/nielsen/`year'/nielsen_ratings`year'_15m.dta", keep(1 3) nogenerate
			merge m:1 distributor stata_date hour halfhour using "$data/nielsen/`year'/nielsen_ratings`year'_30m.dta", keep(1 3) nogenerate

			keep market distributor year stata_date stata_time hour halfhour quarterhour est_cost spotleng party sponsor tone ///
				office period scope creative ad_id days_to_election tv_*
			
		}

		else if `year' == 2012 {

			* Merge Nielsen ratings information 
			gen month = month(stata_date)
			gen year_month = 100*year + month 
			gen nielsen_date = stata_date
			* According 2012 manual, SpotTV Nielsen days continue through 2AM
			replace nielsen_date = stata_date - 1 if stata_time < Clock("2:00:00","hms")
			* Day of week for Nielsen begins at 1 and Stata begins at zero
			gen dayofweek = dow(nielsen_date) + 1

			gen hour_interval = hh(stata_time)
			gen stata_minute = mm(stata_time)
			
			gen date_interval = stata_date 
		
			gen minute_interval = 15 if inrange(stata_minute,3,14)
			replace minute_interval = 28 if inrange(stata_minute,15,27)
			replace minute_interval = 33 if inrange(stata_minute,28,32)
			replace minute_interval = 45 if inrange(stata_minute,33,44)
			replace minute_interval = 58 if inrange(stata_minute,45,57)
			replace minute_interval = 0 if inrange(stata_minute,58,59)
			replace hour_interval = hour_interval + 1 if minute_interval == 0
			replace date_interval = date_interval + 1 if hour_interval == 24
			recode hour_interval (24=0)
			replace minute_interval = 3 if inrange( stata_minute,0,2)

			merge m:1 distributor hour_interval minute_interval date_interval using "$data/nielsen/`year'/nielsen_spotkey_ratings`year'.dta", keep(1 3) keepusing(tv_hh* tv_pp*)
			drop _merge
			
			merge m:1 hour_interval minute_interval using "$data/xwalk/time_interval_dictionary.dta", assert(2 3) keep(3) nogenerate keepusing(time_interval_number)
			merge m:1 distributor year_month dayofweek time_interval_number using "$data/nielsen/`year'/nielsen_ratings`year'.dta", keep(1 3 4 5) keepusing(tv_hh* tv_pp*) update
		
		}

		* Standardize market name
		rename market county_dma
		merge m:1 county_dma using "$data/xwalk/dma_map.dta", keepusing(dma_name) keep(1 3 4) assert(1 2 3 4) nogenerate update
		rename county_dma nielsen_dma
		merge m:1 nielsen_dma using "$data/xwalk/dma_map.dta", keepusing(dma_name) keep(1 3 4) assert(1 2 3 4) nogenerate update
		rename nielsen_dma cmag1_dma
		merge m:1 cmag1_dma using "$data/xwalk/dma_map.dta", keepusing(dma_name) keep(1 3 4) assert(1 2 3 4) nogenerate update
		rename cmag1_dma cmag2_dma
		merge m:1 cmag2_dma using "$data/xwalk/dma_map.dta", keepusing(dma_name) keep(1 3 4) assert(1 2 3 4) nogenerate update
		
		* Add markets not included in 2008 and top 100 markets not included in 2004 file
		merge m:1 dma_name using "$data/xwalk/dma_map.dta", keepusing(dma_name cmag_sample`year') keep(1 2 3 4) assert(1 2 3 4) nogenerate update
		replace year = `year' 
		
		/*CHECK*/
		egen temp_ct = total(1), by(dma_name)
		assert temp_ct == 1 if cmag_sample`year' == 0
		
		drop if cmag_sample`year' == 0
		drop temp_ct cmag_sample`year'
		assert !missing(dma_name)
		destring period, replace
			
		* Merge Nielsen data
		merge m:1 year dma_name using "$data/nielsen/`year'/nielsen_data.dta", keep(3) assert(2 3) nogenerate 
		
		if inlist(`year',2004,2008) {
		
			** Calculate GRPs and impute values for missing ads
			gen nads = (spotleng/30)
			gen period_02 = inrange(period,0,2)
			egen nunique = tag(creative dma_name party office scope period_02)
			gen est_cost2 = est_cost^2
		
			foreach group of global groups {
				
				foreach incr in 15m 30m {
				
					di "`group' ``group'' `incr'"
					* Calculate number of impressions for ad
					gen imps_``group''_`incr' = (tv_pp_`group'_`incr' / tv_nads_`incr') * (spotleng/30)

					* Determine whether impressions needs to be imputed
					gen imputed_``group''_`incr' = missing(imps_``group''_`incr') 
						
					* Construct GRP measure 
					gen grp_``group''_`incr' = imps_``group''_`incr' / (market_viewers_``group'' * 10)
					
					* Impute local ads based on the CMAG predicted cost in market	
					qui: areg imps_``group''_`incr' est_cost est_cost2 if scope == "local", absorb(dma_name)
					predict imps_hat_``group''_`incr' if scope == "local"

					* Impute national ads based on average GRP of spot in other market; construct impressions measure
					* Only available for 2008 Presidential ads
					if ((`year' == 2008) & (office[1] == "pres")) {
						qui: areg grp_``group''_`incr' if scope == "national", absorb(ad_id)
							predict grp_hat_``group''_`incr' if scope == "national"
						replace imps_hat_``group''_`incr' = grp_hat_``group''_`incr'*market_viewers_``group''*10
						replace imps_``group''_`incr' = max(0,imps_hat_``group''_`incr') if imputed_``group''_`incr'
						replace grp_hat_``group''_`incr' = imps_hat_``group''_`incr'/(market_viewers_``group''*10)
					} 
					else {
						gen grp_hat_``group''_`incr' = imps_hat_``group''_`incr'/(market_viewers_``group''*10)
					}

					* Construct GRP measure for imputed local ads	
					replace grp_``group''_`incr' = max(0,grp_hat_``group''_`incr') if imputed_``group''_`incr'
					
				}
			
			}

		}
		
		else if `year' == 2012 {
		
			** Calculate GRPs and impute values for missing ads
			gen nads = (spotleng/30)
			gen period_02 = inrange(period,0,2)
			egen nunique = tag(creative dma_name party office scope period_02)
			gen est_cost2 = est_cost^2
				
			foreach group of global groups {
				
				di "`group' ``group''"
				* Calculate number of impressions for ad
				gen imps_``group'' = tv_pp_`group'

				* Determine whether impressions needs to be imputed
				gen imputed_``group'' = missing(imps_``group'') 
					
				* Construct GRP measure 
				gen grp_``group'' = imps_``group'' / (market_viewers_``group'' * 10)
				
				* Impute local ads based on the CMAG predicted cost in market	
				qui: areg imps_``group'' est_cost est_cost2 if scope == "local", absorb(dma_name)
				predict imps_hat_``group'' if scope == "local"

				gen grp_hat_``group'' = imps_hat_``group''/(market_viewers_``group''*10)	
				
				* Construct GRP measure for imputed local ads	
				replace grp_``group'' = max(0,grp_hat_``group'') if imputed_``group''
							
			}

		}
		
		save "$temp/cmag_spots_`year'`office'", replace
		collapse (sum) grp* imps* imputed* nads nunique est_cost, by(year dma_name party office tone period sponsor scope)

	end

**************************************************************************

* END OF FILE
