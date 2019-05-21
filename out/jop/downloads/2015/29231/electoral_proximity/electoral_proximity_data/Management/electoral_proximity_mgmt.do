/// Date Created: 6/29/2012
/// Last Update: 11/17/2014

*	What: This file creates data for "Electoral Proximity and Security Policy"
*	Co-PIs: Nikolay Marinov and William Nomikos

*	Idea: The file grabs data from COW, ISAF, the World Bank, NELDA, turns all into c-y-m format, merges
*	and outputs elections_troops.dta

*	Steps:

*	(1) Make sure this .do file and the data files listed below are in the 
*		same dir (this results automatically from unpacking of .zip file; 
*		should all be located in "Management" folder"). For list of files see
*		"electoral_proximity_data_instructions.rtf."
*	(2) Make "Management" folder with these files STATA's working dir.
*	(3) Run this entire .do file



/// Presets **********************************************************
	clear all
	set memory 1000000
	set more off
	

///	Working directory **********************************************************
	///	Change this to directory in which "Management" subfolder was saved
		cd "/Users/wnomikos/Box Sync/Research/Afghanistan/electoral_proximity_data/Management"
///	Add ISAF troops **********************************************************
	*** Brings in data on ISAF troops in between January 2007 and
	*** October 2011 collected from official ISAF "placemats" website. 
	*** The data is in country-year-month format and contains all states in the
	*** international system. 
			
	///	Bring in raw placemat data
		clear
		use isaf_troops.dta
		
	/// Keep only necessary variables
		drop country
			
	///	Add Montenegro, which is missing a country code
		replace ccode=341 if missing(ccode)
			
	///	Change ccode of German Federal Republic (260) to Germany (255) to reflect post-1990 state
		replace ccode=255 if ccode==260
	
	///	Rename variables
		rename troops trpsISAF
		rename year_yyyy year
		rename month_numberformat month
	
	order ccode year month
	sort ccode year month
	
	///	Save ISAF data reformated
		save "elections_troops.dta", replace
		
///	Extend time series **********************************************************
	*** Extends time series for ISAF states from 1/01 to 12/13
	*** This produces data in c-y-m format with values for "trpsisaf"
	*** variable missing from 1/01 through 12/06 and from 10/11 to 12/13.  
	
	/// Isolate the countries for which the time series needs to be expanded
			keep ccode 
		
	///	We expand a time series for the ccode variable using the same method as earlier
			gen length = 2014-2000
			expand length
			bys ccode : gen year=2000+_n-1
			drop length
	
	///	Add month by expansion based on ccode and year
			gen length = 12
			expand length
			bys ccode year : gen month =1+_n-1
			drop length	
		
	///	Temporal scope conditions 
			drop if year < 2000
			drop if year > 2013

						
	///	We save this data in a tempfile which we will then append to the ISAF_troop_data
			tempfile datefill
			save "`datefill'", replace
	
	///	We will switch back to the ISAF_troop_data.dta to append using the datefill tempfile
			clear 
			use "elections_troops.dta"
			append using "`datefill'"
			sort ccode year month, stable
		
	/// Create variable that checks to see if troop data is missing for each observation
			gen missing = missing(trpsISAF)
		
	///	Check for duplicates - multiple observations for the same months
			quietly by ccode year month:  gen dup = cond(_N==1,0,_n)
			
	///	Drop duplicates that are missing the troop data to prevent loss of data
			drop if dup > 0 & missing == 1
	
	///	Quick test to see if all duplicates have been handled:
			/*quietly by statenme year month:  gen dup2 = cond(_N==1,0,_n)
			keep if dup2 > 0*/
	
	///	Impute missing values if we are missing a few months in between month reporting
			replace trpsISAF = trpsISAF[_n-1] if missing(trpsISAF) & ccode[_n]==ccode[_n-1]
	
	///	Replace values after October 2011 as missing since this is the last reported month in placemat data
			replace trpsISAF = . if year>2011| (year==2011 &month >10)
	
	drop dup
	replace trpsISAF=. if trpsISAF==0
	drop missing
		
	///	Save data with ISAF numbers and full dates 		
		save "elections_troops.dta", replace
			
///	Merge with COW data to get statenme and stateabb **********************************************************
	*** Uses list of states from Correlates of War project to get state names 
	*** and abbreviations by merging on country code. The merge drops states 
	*** not in the international system, which are listed only in the COW data. 
		
	clear
		
	///	Bring in COW data
		insheet using "states2011.csv"
			
	///	Keep only necessary variables
		keep stateabb ccode statenme
	
	///	Merge with ISAF data on ccode
		merge m:m ccode using "elections_troops.dta" 
		sort ccode year month
			
	///	Only keep values that match on ccode
		keep if _merge==3
					
	///	Drop merge variable
		drop _merge
	
	///	Save with statenme and stateabb
		save "elections_troops.dta", replace

		
///	Merge data on troops collected from Ministries of Defense **********************************************************
	*** Brings in orginally collected from ministries of defense from each 
	*** state and merges with master data. We drop unmatched data from the 
	*** ministry data because this dataset contains data outside
	*** of scope of interest (01/01-09/01 and 11/11-03/13). We keep unmatched 
	*** data from the master dataset because this contains all of the states
	*** in the international system and data from later contributors to ISAF 
	*** not in the ministries data. 
		
	///	Bring in MoD data
		clear
		insheet using marinov_nomikos_mod.csv
	
	///	Save for merging purposes
		tempfile mod
		save "`mod'", replace
	
	///	Bring in master data
		clear
		use elections_troops.dta
		
	/// Merge MOD data
		merge 1:1 ccode year month using "`mod'" 
		sort ccode year month
	
	///	Drop merge variable 
		drop _merge

	
	/// Save ISAF + MoD troop data
		save "elections_troops.dta", replace
			
			
///	Manage troop numbers **********************************************************
	***	Places all of the figures from the ministries of defense data into
	*** one variable, trpsmod. Creates variable trpsavg that averages figures 
	*** from ministries and ISAF. Generates main variable of analysis, ntroops,
	*** that contains value from one of the two sources or their average.
		
	///	Put all the data from the ministries of defense in the trpsmod variable
	///	Here we don't distinguish between troops mandate and boots on the ground
		replace trpsmod=trpsmand if missing(trpsmod) & !missing(trpsmand) & missing(trpsgrnd)  
		replace trpsmod=trpsgrnd if missing(trpsmod) & !missing(trpsgrnd) & missing(trpsmand) 
		
	///	Indicator for whether there exists ISAF data
		gen ISAF=0 if missing(trpsISAF)
		replace ISAF=1 if !missing(trpsISAF)
		
	///	Indicator for whether there exists MoD data
		gen mod=0 if missing(trpsmod)
		replace mod=1 if !missing(trpsmod)
	
	///	Indicator for whether there exists OEF data
		gen OEF=0 if missing(trpsoef)
		replace OEF=1 if !missing(trpsoef)
	
	///	Create trpsavg that takes average of ISAF and MoD data if we have values for both 
		gen trpsavg=.
		replace trpsavg=(trpsISAF+trpsmod)/2 if (ISAF==1&mod==1)

	///	The main variable of analysis is ntroops, for which we want to have as many values as possible
			gen ntroops=. 
		///	ntroops takes average of ISAF and MoD data if we have values for both and nothing for OEF
			replace ntroops=trpsavg if !missing(trpsavg) & OEF==0
		///	ntroops takes on value trpsavg + OEF if we have OEF data
			replace ntroops=trpsavg+trpsoef if !missing(trpsavg) & OEF==1
		///	Variable takes on ISAF value if MoD is missing
			replace ntroops=trpsISAF if mod==0 & ISAF==1
		///	Variable takes on MoD value if ISAF is missing
			replace ntroops=trpsmod if ISAF==0 & mod==1
		///	Variable takes on MoD value for US because DoD sent total numbers
			replace ntroops=trpsmod if ccode==2

	drop ISAF mod OEF
	
	/// Save 
		save "elections_troops.dta", replace

/// Merge Casualties data**********************************************************
	***	Merges master data with casualty dataset. We assumed that a state that 
	*** contributed troops to ISAF but is not listed in the icasualties 
	*** database has suffered 0 casualties as opposed to merely being 
	*** "missing." In addition to the matched data (i.e., when a 
	*** state that contributed to ISAF suffered a casualty), we also keep
	*** unmatched data from the master dataset. 
			
	merge 1:1 ccode year month using "icasualties.dta" 
	sort ccode year month

		
	/// Drop merge variable 
		drop _merge
	
	/// Replace casualties with "0" if a state contributed to ISAF
		replace casualties=0 if ntroops>0 & ntroops!=. & casualties==.

	/// Save 
		save "elections_troops.dta", replace
			
			
/// Introduce World Bank Population data**********************************************************
	*** Incorporates population data from World Bank. Some state names need 
	*** to be reformatted for merging (we only did so for ISAF contributors,
	*** however). In addition to the matched data (i.e., the population
	*** of a state that contributed to ISAF), we also keep
	*** unmatched data from the master dataset. We drop unmatched data from
	*** the World Bank data, which is for population groups (e.g., regions).
	
	clear	
	insheet using "Population_Data_World_Bank.csv"
	
	///	Drop unnecessary variables
		drop countrycode
	
	///	Rename variables and observations for merging purposes
		rename countryname statenme	
		replace statenme="Slovakia" if statenme=="Slovak Republic"
		replace statenme="United States of America" if statenme=="United States"
		replace statenme="South Korea" if statenme=="Korea, Rep."
		replace statenme="Macedonia" if statenme=="Macedonia, FYR"

	/// Reshape data from horizontal to vertical format
		reshape long y, i(statenme) j(year)	
		rename y population
			
	/// Save as tempfile
		tempfile pop
		save "`pop'", replace
		
	/// Reopen master dataset and merge based upon variables (statenme, year) using tempfile
	
		clear
		use "elections_troops.dta"
		merge m:1 statenme year using "`pop.dta'"
		sort ccode year month

	/// Drop population group observations from World Bank
		drop if _merge==2
		
	/// Drop merge variable 
		drop _merge
				
		
	/// Save ISAF + MoD troop data with population data
		save elections_troops.dta, replace	

///	Add Cheibub, Gandhi, and Vreeland democratic system  data *********************************************************		 
	***	Reformats DD data from Cheibub et al.: keeps only relevant years;
	*** we assume regimes stayed stable after 2008 and extend the data. Merges
	*** DD data with master data. Keeps matched observations (regime type for 
	*** ISAF contributors) and unmatched observations from master data (DD
	*** does not have regime information for these states). 
	
		clear
		use  "ddrevisited_data_v1.dta"
		
	/// Keep only variables of interest
		keep cowcode year regime democracy
	
	///	Rename cowcode to ccode
		rename cowcode ccode
		
	///	Keep only relevant years
		keep if year>=2000
	
	///	The countries we want data for (ISAF contributors--double check this)
		#delimit ;
		egen ISAF = anymatch(ccode), values(2 20 92 200 205 210 211 212 
		220 225 230 235 255 290 305 310 316 317 325 339 341 343 344 346 
		349 350 355 360 366 367 368 369 371 372 373 375 380 385 390 395 
		640 663 696 712 732 820 830 900 920 955);
		keep if ISAF;
		#delimit cr
			
	///	Data only goes up to 2008, assume regime stayed stable after 2008
		
		///	Duplicate observations after 2008
			expand 6 if year==2008
		
		///	Create count variable for each state
			sort ccode year
			bysort ccode: gen count=_n
		
		///	Replace year data for the appropriate observation
			foreach var of numlist 09/13 {
			replace year=20`var' if count==`var' & `var'>9
			replace year=200`var' if count==`var' & `var'==9
			}

		/// Does not work for 341 Montenegro b/c it didn't exist until 2006
			sort ccode year
			replace year=year[_n-1]+1 if ccode==ccode[_n-1] & ccode==341 & year<=year[_n-1]
		
	///	Drop unnecessary 
		drop count

		
	///	Save DD data temp
		tempfile dd
		save "`dd'", replace
	
	clear
	use "elections_troops.dta"
	merge m:1 ccode year using "`dd'"
			
	/// Drop merge variable 
		drop _merge
				
	///	Save 
		save elections_troops.dta, replace
	
///	Add NELDA Legislative data **********************************************************		 
	*** Incorporates NELDA legislative data with one row for each month. 
	*** After the merge with the master data, keep matched data (ISAF states 
	*** in months they had leg elections) and unmatched data from master 
	*** (ISAF states in months they did not have elections). Drop unmatched 
	*** data from NELDA (legislative elections for non-ISAF contributors or
	*** outside time period). 

	clear
 	use "id & q-wide.dta"

	/// Retaining Legislative elections
		keep if substr(electionid,-2,1)=="L"
		#delimit ;
		egen ISAF = anymatch(ccode), values(2 20 92 200 205 210 211 212 
		220 225 230 235 255 290 305 310 316 317 325 339 341 343 344 346 
		349 350 355 360 366 367 368 369 371 372 373 375 380 385 390 395 
		640 663 696 712 732 820 830 900 920 955);
		keep if ISAF;
		drop ISAF;
		#delimit cr
		
	///  Not needed vars from NELDA

	drop timesubmitted-stateid  coder-dateentered 

	forvalues i=1/58 {
		drop nelda`i'notes	
	}

	sort ccode year mmdd  
	
	gen mmddstr=string(mmdd)
	label var mmddstr "mm dd of election as a string"
	replace mmddstr="0"+mmddstr if length(mmddstr)==3
	assert length(mmddstr)==4
	gen month=real(substr(mmddstr,1,2))
	label var month "month of election as a string"
	assert month>=1 & month<=12
	drop mmddstr
	egen el_cym=group(ccode year month)
	label var el_cym "id, multiple election in month get same id"
	duplicates tag ccode year month, gen(el_mm)
	replace el_mm=el_mm+1
	label var el_mm "number of elections in month"

	order month el_*
	sort el_cym
	by el_cym: gen j=_n	
		
	foreach i of var electionid mmdd notes nelda1-nelda58 {
	
		rename `i' `i'L
	
	}

	reshape wide electionidL mmddL notesL nelda1L-nelda58L, i(el_cym) j(j)

	order ccode country year month types

	drop el_* country
		
	egen check=group(ccode month year)	
	duplicates report check
	drop check

	sort ccode year month 
	///	Germany FR in most data used by Marinov is 260 (continues the West German coding); change
		replace ccode=255 if ccode==260
	
	tempfile NELDA_L
	save "`NELDA_L'", replace

	
	///	Merge NELDA L data with master **********************************************************
		clear
		use "elections_troops.dta"
		merge 1:1 ccode year month using "`NELDA_L'"
	    
		/// only keep values inside time period
		drop if _merge==2
		/// drop merge variable 
		drop _merge
		
	///	Save 
		save elections_troops.dta, replace

		
		
///	Add NELDA Presidential data **********************************************************		 
	*** Incorporates NELDA Presidential data with one row for each month. 
	*** After the merge with the master data, keep matched data (ISAF states 
	*** in months they had pres elections) and unmatched data from master 
	*** (ISAF states in months they did not have elections). Drop unmatched 
	*** data from NELDA (presidential elections for non-ISAF contributors or
	*** outside time period). 	
	
 	use "id & q-wide.dta"

	/// Retaining Presidential elections
		keep if substr(electionid,-2,1)=="P"
		#delimit ;
		egen ISAF = anymatch(ccode), values(2 20 92 200 205 210 211 212 
		220 225 230 235 255 290 305 310 316 317 325 339 341 343 344 346 
		349 350 355 360 366 367 368 369 371 372 373 375 380 385 390 395 
		640 663 696 712 732 820 830 900 920 955);
		keep if ISAF;
		drop ISAF;
		#delimit cr		
	///  Not needed vars from NELDA

		drop timesubmitted-stateid  coder-dateentered 
	
		forvalues i=1/58 {
		drop nelda`i'notes	
		}

	sort ccode year mmdd  
	
	gen mmddstr=string(mmdd)
	label var mmddstr "mm dd of election as a string"
	replace mmddstr="0"+mmddstr if length(mmddstr)==3
	assert length(mmddstr)==4
	gen month=real(substr(mmddstr,1,2))
	label var month "month of election as a string"
	assert month>=1 & month<=12
	drop mmddstr
	egen el_cym=group(ccode year month)
	label var el_cym "id, multiple election in month get same id"
	duplicates tag ccode year month, gen(el_mm)
	replace el_mm=el_mm+1
	label var el_mm "number of elections in month"

	order month el_*
	sort el_cym
	by el_cym: gen j=_n	
		
	foreach i of var electionid mmdd notes nelda1-nelda58 {
	
		rename `i' `i'P
	
	}

	reshape wide electionidP mmddP notesP nelda1P-nelda58P, i(el_cym) j(j)


	order ccode country year month types

	drop el_* country

		
	egen check=group(ccode month year)	
	duplicates report check 
	drop check

	sort ccode year month
	///	Germany FR in most data used by Marinov is 260 (continues the West German coding); change
			replace ccode=255 if ccode==260
	
	tempfile NELDA_P
	save "`NELDA_P'", replace

	///	Merge NELDA P data with master **********************************************************
		clear
		///reopen the tempfile process (which stores the master dataset)
		use "elections_troops.dta"
		merge 1:1 ccode year month using "`NELDA_P'"
	    
		/// only keep values inside time period
		drop if _merge==2
		/// drop merge variable 
		drop _merge
		
		save elections_troops.dta, replace

///	Electoral proximity variables**********************************************************
	*** To construct election vars it helps to establish what kind of system
	*** each state has. In Cheibub et al, 0 indicates parliamentary, 1 indicates 
	*** mixed, 2 indicates presidential. We use this to code when elections for
	***	executives are approaching and receding in each state. In 
	*** Parl, we count leg elections, in Pres, presidential, in mixed, both 
	*** L and P elections. 
	*** Note: NELDA does not code Icelend and Luxembourg.

		egen yearmo=group(year month)
		tsset ccode yearmo

		sort ccode yearmo

		*move system headofstate
	
	
	/// Vars for elections approaching and receding within n months of obs

		gen electionapproach6=0 if (statenme!="Iceland" & statenme!="Luxembourg")

		gen electionapproach12=0 if (statenme!="Iceland" & statenme!="Luxembourg")


		gen electionrecede6=0 if (statenme!="Iceland" & statenme!="Luxembourg")

		gen electionrecede12=0 if (statenme!="Iceland" & statenme!="Luxembourg")


	
	/// to use the time-series functions, derive numeric versions of nelda vars
	/// eP1/2 eL1/2/3 = 1 if election in that month

		gen eP1=(electionidP1!="") if statenme!="Iceland" & statenme!="Luxembourg"
		gen eP2=(electionidP2!="") if statenme!="Iceland" & statenme!="Luxembourg"
		gen eL1=(electionidL1!="") if statenme!="Iceland" & statenme!="Luxembourg"
		gen eL2=(electionidL2!="") if statenme!="Iceland" & statenme!="Luxembourg"
		gen eL3=(electionidL2!="") if statenme!="Iceland" & statenme!="Luxembourg"

		egen eL123P12=rowmax(eP1 eP2 eL1 eL2 eL3)
		label var eL123P12 "rowmax(eP1 eP2 eL1 eL2 eL3)"

	/// Parliamentary (regime==0) and mixed (regime==1) 

		forvalues i=1/3 {														
		///	Election will take place within six months
			replace electionapproach6=1 if (f1.eL`i'==1	| f2.eL`i'==1	| f3.eL`i'==1	| f4.eL`i'==1	| f5.eL`i'==1 | f6.eL`i'==1) & (regime==0 | regime==1)								
		///	Election will take place within twelve months
			replace electionapproach12=1 if (f1.eL`i'==1	| f2.eL`i'==1	| f3.eL`i'==1	| f4.eL`i'==1	| f5.eL`i'==1 | f6.eL`i'==1	| f7.eL`i'==1	| f8.eL`i'==1	| f9.eL`i'==1	| f10.eL`i'==1 | f11.eL`i'==1 | f12.eL`i'==1) & (regime==0 | regime==1)			
		///	Election has taken place in past six months
			replace electionrecede6=1 if (eL`i'==1	| l1.eL`i'==1	| l2.eL`i'==1	| l3.eL`i'==1	| l4.eL`i'==1	| l5.eL`i'==1) & (regime==0 | regime==1)		
		///	Election has taken place in past twelve months
			replace electionrecede12=1 if (eL`i'==1	| l1.eL`i'==1	| l2.eL`i'==1	| l3.eL`i'==1	| l4.eL`i'==1	| l5.eL`i'==1	| l6.eL`i'==1	| l7.eL`i'==1	| l8.eL`i'==1 | l9.eL`i'==1 | l10.eL`i'==1 | l11.eL`i'==1) & (regime==0 | regime==1)										
	}												
											
	
	///	Presidential system (regime==2) or mixed (regime==1) 												
																										
		forvalues i=1/2 {													
		///	Election will take place within six months										
		replace electionapproach6=1 if (f1.eP`i'==1	| f2.eP`i'==1	| f3.eP`i'==1	| f4.eP`i'==1	| f5.eP`i'==1 | f6.eP`i'==1) & electionapproach6!=1 & (regime==1 | regime==2)								
		///	Election will take place within twelve months
		replace electionapproach12=1 if (f1.eP`i'==1	| f2.eP`i'==1	| f3.eP`i'==1	| f4.eP`i'==1	| f5.eP`i'==1 | f6.eP`i'==1	| f7.eP`i'==1	| f8.eP`i'==1	| f9.eP`i'==1	| f10.eP`i'==1 | f11.eP`i'==1 | f12.eP`i'==1) & electionapproach12!=1 & (regime==1 | regime==2)			
		///	Election has taken place in past six months
		replace electionrecede6=1 if (eP`i'==1	| l1.eP`i'==1	| l2.eP`i'==1	| l3.eP`i'==1	| l4.eP`i'==1	| l5.eP`i'==1) & (regime==1 | regime==2)		
		///	Election has taken place in past twelve months
		replace electionrecede12=1 if (eP`i'==1	| l1.eP`i'==1	| l2.eP`i'==1	| l3.eP`i'==1	| l4.eP`i'==1	| l5.eP`i'==1	| l6.eP`i'==1	| l7.eP`i'==1	| l8.eP`i'==1 | l9.eP`i'==1 | l10.eP`i'==1 | l11.eP`i'==1) & (regime==1 | regime==2)											
	
	}		
	///	Generate New Variable for type of election (legislative or presidential
		
		gen electype=.
	
		///	Leg/Parl elections using NELDA designation
			replace electype =0 if eL1==1|eL2==1|eL3==1
				
		///	Presidential elections using NELDA designation
			replace electype =1 if eP1==1|eP2==1

	
	///	Generate variable execelec if a state is holding an executive election
		gen execelec=0 if statenme!="Iceland" & statenme!="Luxembourg"
		/// Presidential or mixed	
			forvalues i=1/2 {	
			replace execelec=1 if (eP`i'==1) & execelec!=1 & (regime==1 | regime==2)								
	
			}
		/// Parliamentary or mixed	
			forvalues i=1/3 {	
			replace execelec=1 if (eL`i'==1) & execelec!=1 & (regime==0 | regime==1)								
	
			}
			
	save elections_troops.dta, replace
		
///	New variable to indicate type of election	******************************************
	***	Uses NELDA to recode whether an election was for leadership position
	*** or not. This creates an alternative coding of the proximity variables.
		
	///	Drop NELDA types variable to eliminate confusion
		drop types
	
	///	Generate new variables
		gen electionapproach6v2=0
		gen electionapproach12v2=0

	/// Legislative 

		forvalues i=1/3 {														

		encode nelda20L`i', gen(L`i'_20)
		drop nelda20L`i'
		gen nelda20L`i'=(L`i'_20==2) if L`i'_20!=.
		///	Election will take place within six months								
		replace electionapproach6v2 =1 if f1.nelda20L`i'==1 | f2.nelda20L`i'==1	| f3.nelda20L`i'==1	| f4.nelda20L`i'==1	| f5.nelda20L`i'==1 | f6.nelda20L`i'==1					
		///	Election will take place within twelve months								
		replace electionapproach12v2=1 if f1.nelda20L`i'==1 | f2.nelda20L`i'==1	| f3.nelda20L`i'==1	| f4.nelda20L`i'==1	| f5.nelda20L`i'==1 | f6.nelda20L`i'==1 | f7.nelda20L`i'==1 | f8.nelda20L`i'==1 | f9.nelda20L`i'==1 | f10.nelda20L`i'==1 | f11.nelda20L`i'==1 | f12.nelda20L`i'==1 						
		}												
											
	
	///	Presidential 												
																										
		forvalues i=1/2 {													
	
		encode nelda20P`i', gen(P`i'_20)
		drop nelda20P`i'
		gen nelda20P`i'=(P`i'_20==2) if P`i'_20!=.
	
		///	Election will take place within six months								
		replace electionapproach6v2 =1 if f1.nelda20P`i'==1 | f2.nelda20P`i'==1	| f3.nelda20P`i'==1	| f4.nelda20P`i'==1	| f5.nelda20P`i'==1 | f6.nelda20P`i'==1					
		///	Election will take place within twelve months								
		replace electionapproach12v2 =1 if f1.nelda20P`i'==1 | f2.nelda20P`i'==1	| f3.nelda20P`i'==1	| f4.nelda20P`i'==1	| f5.nelda20P`i'==1 | f6.nelda20P`i'==1 | f7.nelda20P`i'==1 | f8.nelda20P`i'==1 | f9.nelda20P`i'==1 | f10.nelda20P`i'==1 | f11.nelda20P`i'==1 | f12.nelda20P`i'==1 						
		}

	save elections_troops.dta, replace

///	New variable to indicate election	early or late ******************************************
	***	Uses NELDA to recode whether an election was early or late (nelda6 is "yes")
	*** or not. This creates an alternative coding of the proximity variables.
		
	
	///	Generate new variables
		gen electionapproach6v6=0
		gen electionapproach12v6=0

	/// Legislative 

		forvalues i=1/3 {														

		encode nelda6L`i', gen(L`i'_6)
		drop nelda6L`i'
		gen nelda6L`i'=(L`i'_6==4) if L`i'_6!=.
		///	Election will take place within six months								
		replace electionapproach6v6 =1 if f1.nelda6L`i'==1 | f2.nelda6L`i'==1	| f3.nelda6L`i'==1	| f4.nelda6L`i'==1	| f5.nelda6L`i'==1 | f6.nelda6L`i'==1					
		///	Election will take place within twelve months								
		replace electionapproach12v6=1 if f1.nelda6L`i'==1 | f2.nelda6L`i'==1	| f3.nelda6L`i'==1	| f4.nelda6L`i'==1	| f5.nelda6L`i'==1 | f6.nelda6L`i'==1 | f7.nelda6L`i'==1 | f8.nelda6L`i'==1 | f9.nelda6L`i'==1 | f10.nelda6L`i'==1 | f11.nelda6L`i'==1 | f12.nelda6L`i'==1 						
		}												
											
	
	///	Presidential 												
																										
		forvalues i=1/2 {													
	
		encode nelda6P`i', gen(P`i'_6)
		drop nelda6P`i'
		gen nelda6P`i'=(P`i'_6==4) if P`i'_6!=.
	
		///	Election will take place within six months								
		replace electionapproach6v6 =1 if f1.nelda6P`i'==1 | f2.nelda6P`i'==1	| f3.nelda6P`i'==1	| f4.nelda6P`i'==1	| f5.nelda6P`i'==1 | f6.nelda6P`i'==1					
		///	Election will take place within twelve months								
		replace electionapproach12v6 =1 if f1.nelda6P`i'==1 | f2.nelda6P`i'==1	| f3.nelda6P`i'==1	| f4.nelda6P`i'==1	| f5.nelda6P`i'==1 | f6.nelda6P`i'==1 | f7.nelda6P`i'==1 | f8.nelda6P`i'==1 | f9.nelda6P`i'==1 | f10.nelda6P`i'==1 | f11.nelda6P`i'==1 | f12.nelda6P`i'==1 						
		}

	*	Indicate whether election was held early or not
	gen early12=electionapproach12
	replace early12=0 if electionapproach12v6==0

	*	Indicate whether election was held early or not
	gen early6=electionapproach6
	replace early6=0 if electionapproach6v6==0

	*	Indicate any type of early election
	gen early=0
	replace early=execelec if (nelda6L1==1|nelda6L2==1|nelda6L3==1|nelda6P1==1|nelda6P2==1)


	save elections_troops.dta, replace

	
	
/// Public Opinion **********************************************************
	***	Merges data gathered on public opinion polls on war with master data.
	*** Data not gathered for all country-year-months so we keep unmatched 
	*** observations from master dataset.
	
	merge 1:1 stateabb year month using "marinov_nomikos_public_opinion.dta"
	
	drop _merge

	save elections_troops.dta, replace

/// Manifestos **********************************************************
	*** Creates a left-right measure, rile, not of governments but of average vote 
	***by party. States with positive values for rile are more right-leaning,
	***states with negative values for rile more left-leaning
	***in terms of the average of all vote; shares of parties tends to sum up 
	***to the right). 

		clear 
		use "MPDataset_MPDS2012_READY.dta"
	
	///	Rename for merging purposes	
		replace statenme="Bosnia and Herzegovina" if statenme=="Bosnia-Herzegovina"
		replace statenme="South Korea" if statenme=="Korea"
		replace statenme="Yugoslavia" if statenme=="Serbia"

		save "MPDataset_MPDS2012_READY.dta", replace
		clear
		use elections_troops.dta

	/// Merge
		merge 1:1 statenme year month using "MPDataset_MPDS2012_READY.dta", keepusing(statenme year month edate party* pervote* rile* intpeace*)

	/// Left-right measure
		gen rile=0 if _merge==3


	
		forvalues i=1/16 {
			replace rile=rile+rile`i'*pervote`i'/100 if pervote`i'!=. & rile`i'!=.	
		}
		order rile


		sort ccode year month
		replace rile=rile[_n-1] if ccode==ccode[_n-1] & rile==. & ccode[_n-1]!=.

				gen intpeace=0 if _merge==3


		forvalues i=1/16 {
			replace intpeace=intpeace+intpeace`i'*pervote`i'/100 if pervote`i'!=. & intpeace`i'!=.	
		}
		order intpeace


		sort ccode year month
		replace intpeace=intpeace[_n-1] if ccode==ccode[_n-1] & intpeace==. & ccode[_n-1]!=.

	
		drop _merge

	

		
///	Create additional variables **********************************************************
	*** Creates additional variables from data. For more information on these,
	*** see variable appendix in the online supplement. 
	
	///	Keep only data within 10/01 to 10/11
		drop if year>2011
		drop if year==2011 & month>10
		drop if year==2001 & month<10
		drop if year<2001
		
	/// Count contributions
		sort ccode year month
	
		egen totalmonths=count(ntroops), by(ccode)
	
	///	Generate NATO variable 
	
		#delimit ;
    	gen NATO=1 if statenme=="Albania"
 	   |statenme== "Belgium" |statenme=="Canada" |statenme=="Croatia" 
	    |statenme=="Czech Republic" |statenme=="France" |statenme=="Denmark" 
    	|statenme=="Iceland" |statenme=="Italy" |statenme=="Luxembourg" 
	    |statenme=="Norway" |statenme=="Portugal" |statenme=="United Kingdom" 
    	|statenme=="United States of America" |statenme=="Greece" |statenme=="Turkey" 
	    |statenme=="Germany" |statenme=="Spain" |statenme=="Hungary" |statenme=="Poland"
    	|statenme=="Bulgaria" |statenme=="Estonia" |statenme=="Latvia" 
	    |statenme=="Lithuania" |statenme=="Romania" |statenme=="Slovakia" 
	    |statenme=="Slovenia"|statenme=="Netherlands";
	    replace NATO=0 if missing(NATO);
   
		#delimit cr

	/// Ln of troops
		gen lntroops = ln(ntroops)
	/// Large contributors
		gen lgcontr = 0 if ntroops>=0 & ntroops<1000
		replace lgcontr = 1 if ntroops>=1000 & ntroops!=.
	/// Casualty country
		#delimit ;
    	gen OK=1 if statenme=="Croatia"|statenme=="Iceland"|statenme=="Luxembourg" 
   	 	|statenme=="Greece" |statenme=="Bulgaria"|statenme=="Slovakia" 
   	 	|statenme=="Slovenia";    
		#delimit cr
		gen cas_state=1 if NATO==1 & OK!=1
		replace cas_state=0 if casualties==0 & cas_state!=1
		drop OK
	/// Other countries' troops
		egen otroops=total(ntroops), by(yearmo)
		replace otroops=otroops-ntroops

	///	Create log of casualties variable 
		gen lncasualties=ln(1+casualties)
	
	///	Create ln(UStroops) variable
		gen uslntrps=lntroops if ccode==2

		gsort yearmo ccode -uslntrps

		by yearmo: replace uslntrps=uslntrps[_n-1] if uslntrps==. & uslntrps[_n-1]!=.
	///	Create logged pop var
		gen lnpop=ln(population)
		
	///	Create pop var in millions
		gen pop2=population/1000000
			
	/// Troops per capita
		gen trpspcap = ntroops/pop2
		
	/// Non-fighting season	(winter)
		gen nofightsea=0
		replace nofightsea=1 if (month>10|month<5)
		replace nofightsea=. if missing(ntroops)
		
	/// Indicates an election held because of troops to Afghanistan
		gen electrps=0
		//Netherlands 2010
		replace electrps=1 if (statenme=="Netherlands" & yearmo>101 & yearmo<126)

		///New DVs without these elections
		gen ntroopsv2=ntroops
		replace ntroopsv2=. if electrps==1 
		
		gen trpspcapv2=trpspcap
		replace trpspcapv2=. if electrps==1

	save elections_troops.dta, replace

	
///	Labels **********************************************************

	label variable statenme "State name (COW)"
	label variable stateabb "State abbreviations (COW)"
	label variable ccode "Country code (COW)"
	label variable year "Year 2001-2011"
	label variable month "Month 10/2001-10/2011s"
	
	label variable ntroops "Number of troops in Afghanistan, total from other troop level measures"
	label variable lntroops "Natural log of number of troops in Afghanistan, total from other troop level measures"
	label variable trpspcap "Number of troops in Afghanistan per millions of citizens"
	label variable trpsavg "Number of troops in Afghanistan, average of mod and ISAF measures"
	label variable trpsISAF "Number of troops committed to ISAF"
	label variable trpsmand "Number of troops executive is perimitted to send to Afghanistan"
	label variable trpsgrnd "Number of troops on the ground in Afghanistan"
	label variable trpsmod "Number of troops, from communication with ministries of defense"
	
	label variable casualties "Number of casualties"
	label variable lncasualties "Natural log of number of casualties"
	label variable population "Population"
	label variable pop2 "Population in millions"
	label variable lnpop "Natural log of population"
	label variable totalmonths "Total months of contributions (in available data)"

	label variable NATO "1 if NATO member state, 0 if not"
	label variable lgcontr "1 if large contributor, 0 if small contributor"
	label variable cas_state "1  if state experienced casualties, 0 if not"
	
	label var electionapproach6 "Executive election in 6 months"
	label var electionapproach12 "Executive election in 12 mos"
	label var electionapproach6v2 "Executive election in 6 months (alt measure)"
	label var electionapproach12v2 "Executive election in 12 mos (alt measure)"
	label var electionrecede6 "Executive election previous 6 mos"
	label var electionrecede12 "Executive election previous 12 mos"
	
	label var regime "0 parl 1 mixed 2 pres (DD)"
	label var electype "0 if Legislative/Parliamentary, 1 if Presidential election (NELDA)"
	label var execelec "1 if election for executive, 0 if not"
	
	label var rile "Average LR based on parties' vote share (Comparative Manifestos Project)"

	label var transatlantic_increase "% who want increase of troops"
	label var transatlantic_keep "% who want to keep troops at current level"
	label var transatlantic_reduce "% who want to reduce troops"
	label var transatlantic_withdraw "% who want total withdrawal"
	label var transatlantic_refused "% refused to answer"

	label var transatlantic2_approve "% who approve of troops"
	label var transatlantic2_disapprove "% who disapprove of troops"
	label var transatlantic2_dk "% who donÕt know"
	
	label var transatlantic3_very_much_approve "% approve of troops"
	label var transatlantic3_somewhat_approve "% somewhat approve of troops"
	label var transatlantic3_somewhat_disappro "% somewhat disapprove of troops"
	label var transatlantic3_very_much_disappr "% disapprove very much of troops"
	label var transatlantic3_dk "% donÕt know"
	label var transatlantic3_refused "% refused to answer"
	
	label var transatlantic4_very_much_approve "% approve of troops"
	label var transatlantic4_somewhat_approve "% somewhat approve of troops"
	label var transatlantic4_somewhat_disappro "% somewhat disapprove of troops"
	label var transatlantic4_very_much_disappr "% disapprove of troops"
	label var transatlantic4_dk "% donÕt know"
		
	label var pew1_keep_troops "% keep troops"
	label var pew1_remove_troops "% remove troops"
	label var pew1_dk "% donÕt know"

	label var pew2_approve "% approve of war in Afghanistan"
	label var pew2_disapprove "% disapprove of war in Afghanistan"
	label var pew2_dk "% donÕt know"

	label var yougov1_yes  "% of people think UK is winning Afghan war"
	label var yougov1_no_but_will "% of people think UK will eventually win Afghan war"
	label var yougov1_no_never "% of people think UK will never win Afghan war"
	label var  yougov1_dk  "% of people did not respond to yougov1 question"
	label var  yougov2_yes_now  "% of people think UK troops should return now"
	label var  yougov2_yes_soon "% of people think UK troops should return soon" 
	label var  yougov2_no "% of people think UK troops should not return"
	label var  yougov2_dk "% of people did not respond to yougov2 question"

	label var nofightsea "Was the month during the non-fighting (winter) season?"

	label var early6 "Indicates within 6 months of early election"
	label var early12 "Indicates within 12 months of early election"
	label var early "Indicates  early election"

	
///	Save data **********************************************************
	
	#delimit ;
	order statenme ccode stateabb year month 
	electionapproach6 electionapproach12 electionapproach6v2 electionapproach12v2 electionrecede6 electionrecede12   
	ntroops lntroops trpspcap trpsISAF trpsmand trpsgrnd trpsoef trpsmod trpsavg uslntrps
	casualties lncasualties population pop2 lnpop nofightsea electionapproach6v6 electionapproach12v6 early6 early12 early
	NATO lgcontr cas_state
	democracy regime electype execelec 	
	totalmonths 
	rile
	;
	#delimit cr
	
	sort ccode year month
	
	        
	///	Save as .dta 
		save "elections_troops.dta", replace
	
	///	Save as .csv
		outsheet using "elections_troops.csv", replace comma
		
		
