********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 7

* START LOG SESSION
	log using "LOGS/TAB_7", replace

	* LOAD DATA 
		u "DATA/CONSTR_EXTRASPACE.dta", clear

	* KEEP TALL BUILDINGS IN CHICAGO WITH INFORMATION ON FLOOR AREA, LAND, USE, BUILDING FOOTPRING
*		keep if (lgfa != . | lufa != .)&  bldn_fp != . & (USE_COMMERCIAL  == 1 | USE_RESIDENTIAL  == 1) & city == "Chicago" & FLOORS>=5	
		gen conversion = lufa-lgfa
	* CREATE PROGRAM THAT GENERATES LOG FLOOR  AREA**** ***********************
		program drop _all
		program NET
			* REGRESS LOG OF USABLE FLOOR SPACE - LOG OF GROSS FLOOR SPACE (converson) AGAINST LOG OF HEIGHT
				qui reg conversion lHEIGHT, robust
			* GENERATE PREDICTED CONVERSION RATE AS A FUNCTION OF HEIGHT
				predict temp
			* IMPUTE LOG USABLE FLOOR SPACE BASED ON CONVERSION RATE AND LOG GROSS FLOOR AREA
				gen lUFA_net = lgfa +temp
				replace lUFA=lufa if lufa  != .
			* DROP TEMPORARY VARIABLE	
				drop temp
			* GENERATE LOG FLOOR AREA
				gen lFAR_net = lUFA - log(bldn_fp)
				label var lFAR_net "Log floor area ratio (log floor area - log parcel area)"
			* END PROGRAM
				end

		
	* RUN FAR REGRESSIONS
	
		* [1] COMMERCIAL BUILDINGS
		
			* RESTRICT TO SAMPLE
				preserve 
				keep if COM  == 1
			* RUN PROGRAM THAT GENERATES FAR
				NET
				
			* RUN REGRESSION
				eststo: reg lFAR_net lHEIGHT, abs(CC) cluster(CC)
					estadd local Cohort_effects "Yes"
					estadd local Building_type "Commercial"	
					local lambda = round(1-_b[lHEIGHT],0.001)
					estadd local Lambda = `lambda'
					sum FLOORS  // 
					local F = round(r(mean))
					estadd local Floors = `F'				
				
				* RESTORE DATA FOR FURTHER USE
					restore 
	
		* [2] RSIDENTIAL BUILDINGS
		
			* RESTRICT TO SAMPLE
				preserve 
				keep if RES  == 1
			* RUN PROGRAM THAT GENERATES FAR
				NET
				
			* RUN REGRESSION
				eststo: reg lFAR_net lHEIGHT, abs(CC) cluster(CC)
					estadd local Cohort_effects "Yes"
					estadd local Building_type "Residential"	
					local lambda = round(1-_b[lHEIGHT],0.001)
					estadd local Lambda = `lambda'
					sum FLOORS 
					local F = round(r(mean))
					estadd local Floors = `F'				
				
				* RESTORE DATA FOR FURTHER USE
					restore 

	* WRITE TABLE
	esttab using "TABS/TAB_7.rtf", replace b(3) se(3) wide label compress r2(3) drop( _cons ) ///
	title ("Extra space elasticity estimates") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) stats(Cohort_effects Building_type Lambda Floors r2 N , fmt(%18.3g ))  ///
	addnote("Missing usable floor space imputed from gross floor space using the procedure outlined in appendix section 4.6. Standard errors clustered on cohorts.")
	eststo clear					
					
* END LOG SESSION
 log close	
