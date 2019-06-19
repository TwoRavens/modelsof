********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 6

* START LOG SESSION
	log using "LOGS/TAB_6", replace

	* LOAD DATA 
		u "DATA/CONSTR_WORLD.dta", clear

	* CREATE PROGRAM THAT GENERATES LOG FLOOR SPACE COST ***********************
		program drop _all
		program COST
			* REGRESS LOG OF USABLE FLOOR SPACE - LOG OF GROSS FLOOR SPACE (converson) AGAINST LOG OF HEIGHT
				reg conversion lHEIGHT, robust
			* GENERATE PREDICTED CONVERSION RATE AS A FUNCTION OF HEIGHT
				predict temp
			* IMPUTE LOG USABLE FLOOR SPACE BASED ON CONVERSION RATE AND LOG GROSS FLOOR AREA
				gen lUFA = lgfa+temp
			* DROP TEMPORARY VARIABLE	
				drop temp
			* GENERATE LOG OF FLOOR SPACE COST PER USABLE FLOOR AREA	
				gen lAVCOST = log(constr_cost)-lUFA
				label var lAVCOST "Log floor space cost"
			* END PROGRAM
				end

	* GENERATE PSM WEIGHTS THAT WEIGHT US SAMPLE TO MATCH CHICAGO HEIGHT PROFILE
	* BE AWARE, THE COMPUTATION CAN TAKE SOME TIME
	
		* GENERATE PSM WEIGHTS FOR COMMERCIAL BUILDINGS
			psmatch2 CH lHEIGHT   if USE_COMMERCIAL == 1 &( constr_cost != . & HEIGHT != . ) & country == "U.S.A." | CH == 1   , kernel  k(biweight) 
				gen NWCHC = _weight if USE_COMMERCIAL == 1			
		* GENERATE PSM WEIGHTS FOR RESIDENTIAL BUILDINGS 
			psmatch2 CH lHEIGHT   if USE_RESIDENTIAL & ( constr_cost != . & HEIGHT != . ) & country == "U.S.A." | CH == 1   ,    kernel k(biweight) 
				gen  NWCHR = _weight		if USE_RESIDENTIAL == 1
		* PSM WEIGHTS COMMERCIAL AND RESIDENTIAL BUILDINGS				
			gen NWCH = .
				replace NWCH = NWCHC if USE_COMMERCIAL == 1
				replace NWCH = NWCHR if USE_RESIDENTIAL == 1				
	
	* CONSTRUCTION COST REGRESSIONS

		* [1] WORLD SAMPLE, SMALL BUILDINGS
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS < 5 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC  , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "All"
						estadd local Data "Observed"
						estadd local Buildings "Small"	
						estadd local Region "World"		
				
				* RESTORE FULL DATA SET
					restore 		


		* [2] WORLD SAMPLE, TALL COMMERCIAL
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS >= 5 & USE_COMMERCIAL == 1 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC  , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Commercial"
						estadd local Data "Observed"
						estadd local Buildings "Tall"	
						estadd local Region "World"		
				
				* RESTORE FULL DATA SET
					restore 

		* [3] WORLD SAMPLE, TALL RESIDENTIAL
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS >= 5 & USE_RESIDENTIAL == 1 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC  , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Residential"
						estadd local Data "Observed"
						estadd local Buildings "Tall"	
						estadd local Region "World"		
				
				* RESTORE FULL DATA SET
					restore 
 
		* [4] US SAMPLE, TALL COMMERCIAL
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS >= 5 & USE_COMMERCIAL == 1 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS if country == "U.S.A." , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC if country == "U.S.A." , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Commercial"
						estadd local Data "Observed"
						estadd local Buildings "Tall"	
						estadd local Region "US"		
				
				* RESTORE FULL DATA SET
					restore 

		* [5] US SAMPLE, TALL RESIDENTIAL
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS >= 5 & USE_RESIDENTIAL == 1 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS if country == "U.S.A." , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC if country == "U.S.A." , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Residential"
						estadd local Data "Observed"
						estadd local Buildings "Tall"	
						estadd local Region "US"		
				
				* RESTORE FULL DATA SET
					restore 

		* [6] PSEUDO CHICAGO SAMPLE, TALL COMMERCIAL
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS >= 5 & USE_COMMERCIAL == 1 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS [w=NWCH] , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC [w=NWCH] , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Commercial"
						estadd local Data "Observed"
						estadd local Buildings "Tall"	
						estadd local Region "Pseudo Chicago"		
				
				* RESTORE FULL DATA SET
					restore 

		* [7] PSEUDO CHICAGO SAMPLE, TALL RESIDENTIAL
				
				* PRESERVE DATA
					preserve 	
				* RESTRICT DATA TO SAMPLE
					keep if FLOORS >= 5 & USE_RESIDENTIAL == 1 
				* RUN PROGRAM TO CREATE LOG FLOOR SPACE COST WITHIN SAMPLE
					COST 
				* MEAN # FLOORS IN SAMPE
					sum FLOORS [w=NWCH] , d
						local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: areg lAVCOST lHEIGHT  i.CC [w=NWCH] , abs(country) robust
						estadd local Country_effects "Yes"
						estadd local Decade_effects "Yes"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Residential"
						estadd local Data "Observed"
						estadd local Buildings "Tall"	
						estadd local Region "Pseudo Chicago"		
				
				* RESTORE FULL DATA SET
					restore 					

	* SAVE DATA SET FOR FURTHER USE IN TAB_8 DO FILE
		save "DATA/TEMP/temp_CONSTR_WORLD_WEIGHTS.dta", replace
					
		* [8] ENGINEERING-BASED ESTIMATES FOR SUPER-TALL BUILDINGS
						
				* PRESERVE DATA
					preserve
					
				* LOAD ENGINEERING DATA
					u "DATA/ENGINEERING_DATA.dta", clear

				* MEAN # FLOORS IN SAMPE
					sum FLOORS, d
							local mean = r(mean)
				* RUN COST REGRESSION		
					eststo: reg lnspacecost lHEIGHT , robust
						estadd local Country_effects "-"
						estadd local Decade_effects "-"
						estadd scalar Semi_elasticity = round(_b[lHEIGHT]/`mean', 0.001	)	
						estadd scalar Floors = round(`mean', 0.1)
						estadd local Land_use "Commercial"
						estadd local Data "Engineering estimates"
						estadd local Buildings "Super tall"	
						estadd local Region "-"
				
				* RESTORE FULL DATA SET
					restore 					

			
	* WRITE TABLE 6				
		esttab using "TABS/TAB_6.rtf", replace b(3) se(3) onecell label compress r2(3) stats( Country_effects Decade_effects Floors  Semi_elasticity Data Land_use Buildings Region N  r2 , fmt(%18.3g)) drop( _cons *.CC) ///
		mtitles("Log floor space cost" "Log floor space cost" "Log floor space cost" "Log floor space cost" "Log floor space cost" "Log floor space cost" "Log floor space cost" "Log floor space cost") ///
		title ("Construction cost elasticity estimates") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) note("Notes:	Observed data is from Emporis. Engineering estimates (Engin.) are from Lee et al. (2011). Ln Floor space cost is computed using predicted usable floor space values based on the regressions reported in appendix section 4.6. Small buildings have less than five floors. Tall buildings have five or more floors. Super-tall buildings have 90 or more floors. The semi-elasticity is computed by dividing the cost elasticity by the mean number of floors. Pseudo Chicago sample is the US sample, re-weighted to resemble the distribution of ln building heights in Chicago (using a propensity score matching, see appendix 3.4). For a small percentage of buildings height is imputed based on floors using an auxiliary regression of height against floors (on average height increases by 3.6 meters per floor). Standard errors in parentheses.")
		eststo clear	
		
* END LOG SESSION
 log close	
