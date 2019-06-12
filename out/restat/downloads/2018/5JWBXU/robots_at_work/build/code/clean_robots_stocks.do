* constructing measures of robot stocks (end of year)

*** cleaning the stocks using the step function approach of World Robotics ***
	
	local slife = 12
	
	gen stock_clean_`slife' = .
			
	sort country code_robots year 
		
	local countrylist1 "GRC IRL"
	local countrylist2 "ESP FIN FRA GER ITA SWE UK"
	local countrylist3 "AUS AUT BEL CHN DNK HUN KOR NLD US"
	
	forval i = 1/3 {
		gen case`i' = 0
		
		foreach country in `countrylist`i'' {
			replace case`i' = 1 if country=="`country'"
		}
	}
			
	gen exclude = case3
	
	by country code_robots: replace case1 = 1 if stock[1]==0 & exclude==0
		replace case2 = 0 if case1==1
	
	assert case1 + case2 + case3 == 1
	
			
	* case 1) countries / industries with initial zeros
		
	by country code_robots: replace stock_clean_`slife' = stock if _n==1 & case1==1
	by country code_robots: replace stock_clean_`slife' = ///
		stock_clean_`slife'[_n-1]+delvrd if _n>1 & _n<=`slife' & case1==1
		
	by country code_robots: replace stock_clean_`slife' = ///
		stock_clean_`slife'[_n-1]+delvrd-delvrd[_n-`slife'] if _n>`slife' & case1==1
		
	* case 2) countries / industries with initial positives (no missings)
	
	by country code_robots: replace stock_clean_`slife' = stock if _n<=`slife' & case2==1
		
	by country code_robots: replace stock_clean_`slife' = ///
		stock_clean_`slife'[_n-1]+delvrd-delvrd[_n-`slife'] if _n>`slife' & case2==1
				
	* case 3) countries with initial positives, reported only for total ("unspecified")
		** using the imputed initial stock value
	
	* indicate when reporting of "unspecified" started
	local AUS `"country=="AUS" & year==1993"'
	local AUT `"country=="AUT" & year==1993"'
	local BEL `"country=="BEL" & year==1993"'
	local CHN `"country=="CHN" & year==1999"'
	local DNK `"country=="DNK" & year==1993"'
	local GRC `"country=="GRC" & year==1993"'
	local HUN `"country=="HUN" & year==1993"'
	local IRL `"country=="IRL" & year==1993"'
	local KOR `"country=="KOR" & year==1993"'
	local NLD `"country=="NLD" & year==1993"'
	local US `"country=="US" & year==1993"'
		
	* using avg share of deliveries
			
	sort country year code_robots
	
	by country year: gen unspec_stock = stock if code_robots=="99" & case3==1 & (( year==1993 & country!="CHN" ) | ( year==1999 & country=="CHN" ))
	
	//	by country year: gen unspec_stock = stock if code_robots=="99" & ((`US') | (`CHN') | (`KOR'))
	by country year: egen sumindus_stock = mean(unspec_stock)
	
	so country code_robots year
	replace stock_clean_`slife' = mean_share*sumindus_stock if case3==1 & (( year==1993 & country!="CHN" ) | ( year==1999 & country=="CHN" ))
	
//drop if code_robots=="99"
drop if country=="CHN" & year<1999
	
	by country code_robots: replace stock_clean_`slife' = ///
		stock_clean_`slife'[_n-1]+delvrd if _n>1 & _n<=`slife' & case3==1
		
	by country code_robots: replace stock_clean_`slife' = ///
		stock_clean_`slife'[_n-1]+delvrd-delvrd[_n-`slife'] if _n>`slife' & case3==1	
		
	gen imp_stock_clean = 0
		replace imp_stock_clean = 1 if case3==1
	
	la val imp_stock_clean yesno
	la var imp_stock_clean "imputation flag for stocks (cleaned)"
	
	drop exclude mean_share unspec_stock sumindus_stock
	
*** computing stock measure based on perpetual inventory method *** 

	sort country code_robots year
	local deltavals "5 10 15"
	foreach delta in `deltavals' {
		by country code_robots: gen stock_pim_`delta' = stock_clean if _n==1 
		by country code_robots: replace stock_pim_`delta' = 	///
			delvrd + (1-`delta'/100)*stock_pim_`delta'[_n-1] if _n>1
	}
	
	* plots of pim stock against step function stock (optional)
	
	if "`1'"=="plotyes" {
	
	twoway scatter stock_pim stock_clean stock_clean, msymbol(oh oh) by(country)
	graph export "..\output/validate_stock_step-vs-pim.pdf", replace
	
	}
	
*** adjusting stocks for the US using fixed ratio
	
	
	foreach delta in `deltavals' {
		replace stock_pim_`delta' = stock_pim_`delta'*adjustUS_delvrd if country=="US"
	}
