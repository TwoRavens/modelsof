*	Title: electoral_proximity_analysis.do 
*	Date Created: 6/29/2012
*	Last Update: 11/23/2014

*	What: This file creates data for "Does Electoral Proximity Affect Security
*	Policy"
*	Co-PIs: Nikolay Marinov and William Nomikos

*	Idea: The file grabs data from the data management, analyzes
*	outputs election_proximity.dta

*	Read "electoral_proximity_instructions.rtf" for more details and 
*	instructions on replication of data



///	Presets ***************************************************
	clear all
	set memory 1000000
	set more off
	capture log close
	log using election_proximity, text replace

	
///	**********************************************************

	///	Working directory 
	///	Change this to directory in which data is saved 
		cd ../Management

	///	Import electoral troops data */
		
		use "elections_troops.dta",


/// Tables in the Manuscript ******************************************
			
/// Table 2: ttests ******************************************

	/// ttests, troops
		ttest ntroops, by(electionapproach12) unequal 
		ttest ntroops if ccode!=2, by(electionapproach12) unequal 
		ttest ntroops if NATO==1, by(electionapproach12) unequal
		ttest ntroops if NATO==0, by(electionapproach12) unequal
		ttest ntroops if cas_state==1, by(electionapproach12) unequal 
		ttest ntroops if cas_state==0, by(electionapproach12) unequal
		
	/// ttests, trpspcap 
		ttest trpspcap, by(electionapproach12) unequal
		ttest trpspcap if ccode!=2, by(electionapproach12) unequal
		ttest trpspcap if NATO==1, by(electionapproach12)  unequal
		ttest trpspcap if NATO==0, by(electionapproach12) unequal
		ttest trpspcap if cas_state==1, by(electionapproach12) unequal
		ttest trpspcap if cas_state==0, by(electionapproach12) unequal

/// Table 3: OLS Regressions, trpspcap ******************************************

	/// OLS Regressions, trpspcap, all countries 

		regress trpspcap electionapproach12 	
		regress trpspcap electionapproach12 i.ccode 	
		regress trpspcap electionapproach12 i.ccode i.year
		regress trpspcap electionapproach12 i.ccode i.yearmo

	/// OLS Regressions, ntroops, all countries (no US) 
		preserve
		drop if ccode==2

		regress trpspcap electionapproach12	
		regress trpspcap electionapproach12 i.ccode 	
		regress trpspcap electionapproach12 i.ccode i.year
		regress trpspcap electionapproach12 i.ccode i.yearmo
		regress trpspcap electionapproach12 i.ccode uslntrps	

		restore

	/// OLS Regressions, ntroops, NATO countries 
		preserve
		keep if NATO==1

		regress trpspcap electionapproach12	
		regress trpspcap electionapproach12 i.ccode 	
		regress trpspcap electionapproach12 i.ccode i.year
		regress trpspcap electionapproach12 i.ccode i.yearmo
	
		restore

/// OLS Regressions, ntroops, non-NATO countries ******************************************
preserve
keep if NATO==0

	regress trpspcap electionapproach12	
	regress trpspcap electionapproach12 i.ccode 	
	regress trpspcap electionapproach12 i.ccode i.year
	regress trpspcap electionapproach12 i.ccode i.yearmo
	regress trpspcap electionapproach12 i.ccode uslntrps	

restore

/// OLS Regressions, ntroops, casualty countries ******************************************
preserve
keep if cas_state==1

	regress trpspcap electionapproach12	
	regress trpspcap electionapproach12 i.ccode 	
	regress trpspcap electionapproach12 i.ccode i.year
	regress trpspcap electionapproach12 i.ccode i.yearmo
		
restore

/// OLS Regressions, ntroops, no-casualty countries ******************************************
preserve
keep if cas_state==0

	regress trpspcap electionapproach12	
	regress trpspcap electionapproach12 i.ccode 	
	regress trpspcap electionapproach12 i.ccode i.year
	regress trpspcap electionapproach12 i.ccode i.yearmo
	regress trpspcap electionapproach12 i.ccode uslntrps	
	
restore


/// Casualties as DC******************************************


*	Table with coefficients

	regress casualties electionapproach12 i.ccode i.yearmo
	regress casualties electionapproach12 ntroops i.ccode i.yearmo
		regress casualties electionapproach12 trpspcap i.ccode i.yearmo


*	regress lncasualties electionapproach12
*	regress lncasualties electionapproach12 i.ccode i.yearmo


/// Left-Right

*	Table and Coeff Plots: 4 of them

	*Right
	regress ntroops electionapproach12 i.ccode i.yearmo if rile<0 & rile!=. & ccode!=2
	*Left
	regress ntroops electionapproach12 i.ccode i.yearmo if rile>0 & rile!=. & ccode!=2
	*Right
	regress trpspcap electionapproach12 i.ccode i.yearmo if rile<0 & rile!=. & ccode!=2
	*Left
	regress trpspcap electionapproach12 i.ccode i.yearmo if rile>0 & rile!=. & ccode!=2


/// Public Opinion ******************************************



* 	codes moving ave of casualties

	tsset ccode yearmo
	tssmooth ma mac=casualties, window(0 0 6)

*	shows that preferences for withdrawal are a fn of casualties, going up as casualties mount; TA - 13 cs 2009-11 - is signicant in 1st case, pew -14 cs - 2007-11 is significant	in both

*	Tables with coefficients: FE suppressed
	
	regress transatlantic_withdraw l1.casualties i.ccode i.year
	regress transatlantic_withdraw mac i.ccode i.year

	regress pew1_remove_troops l1.casualties i.ccode i.year
	regress pew1_remove_troops mac i.ccode i.year

*	regress yougov2_yes_soon l1.casualties
*	regress yougov2_yes_soon mac
	

*	per cent thinking UK is winning in Afgh

*	Table with coeff

	regress yougov1_yes l1.casualties
	regress yougov1_yes mac


* 	crude but interesting: shows that troops per capita do not decrease as preference for withdrawal increases, possible validation of "this is above the fray of daytoday politics"
*	DO NOT INCLUDE

*	regress trpspcap pew1_remove_troops i.ccode i.year
*	regress trpspcap transatlantic_withdraw i.ccode i.year


	* Dutch report - voters knowledge is higher in the runup to election

	regress nlmonitor_know* l1.casua*
	regress nlmonitor_know* electionapproach6


/// OLS Regressions, ntroops, all countries ******************************************

	regress ntroops electionapproach12	
	regress ntroops electionapproach12 i.ccode 	
	regress ntroops electionapproach12 i.ccode i.year
	regress ntroops electionapproach12 i.ccode i.yearmo

/// OLS Regressions, ntroops, all countries (no US) ******************************************
preserve
drop if ccode==2

	regress ntroops electionapproach12	
	regress ntroops electionapproach12 i.ccode 	
	regress ntroops electionapproach12 i.ccode i.year
	regress ntroops electionapproach12 i.ccode i.yearmo
	regress ntroops electionapproach12 i.ccode uslntrps	

restore

/// OLS Regressions, ntroops, NATO countries ******************************************
preserve
keep if NATO==1

	regress ntroops electionapproach12	
	regress ntroops electionapproach12 i.ccode 	
	regress ntroops electionapproach12 i.ccode i.year
	regress ntroops electionapproach12 i.ccode i.yearmo
	
restore

/// OLS Regressions, ntroops, non-NATO countries ******************************************
preserve
keep if NATO==0

	regress ntroops electionapproach12	
	regress ntroops electionapproach12 i.ccode 	
	regress ntroops electionapproach12 i.ccode i.year
	regress ntroops electionapproach12 i.ccode i.yearmo
	regress ntroops electionapproach12 i.ccode uslntrps	

restore

/// OLS Regressions, ntroops, casualty countries ******************************************
preserve
keep if cas_state==1

	regress ntroops electionapproach12	
	regress ntroops electionapproach12 i.ccode 	
	regress ntroops electionapproach12 i.ccode i.year
	regress ntroops electionapproach12 i.ccode i.yearmo
		
restore

/// OLS Regressions, ntroops, no-casualty countries ******************************************
preserve
keep if cas_state==0

	regress ntroops electionapproach12	
	regress ntroops electionapproach12 i.ccode 	
	regress ntroops electionapproach12 i.ccode i.year
	regress ntroops electionapproach12 i.ccode i.yearmo
	regress ntroops electionapproach12 i.ccode uslntrps	
	
restore





// Fighting Season ******************************************

	* Does no fighting season predict a decrease in casualties
	regress casualties nofightsea
	
	* Does the fighting season predict electoral timing
	regress execelec nofightsea
	regress execelec nofightsea i.ccode i.yearmo
	regress electionapproach12 nofightsea
	regress electionapproach12 nofightsea i.ccode i.yearmo
	logit execelec nofightsea
	logit execelec nofightsea i.ccode i.yearmo
	logit electionapproach12 nofightsea
	logit electionapproach12 nofightsea i.ccode i.yearmo
	
// Early elections ******************************************

	* Add early12 to general model
	regress ntroops early12
	regress ntroops early12 i.ccode 	
	regress ntroops early12 i.ccode i.year
	regress ntroops early12 i.ccode i.yearmo

	* Add early12 to casualties model, absolute troop numbers

	regress ntroops electionapproach12 early12 if cas_state==1
	regress ntroops electionapproach12 early12 i.ccode 	if cas_state==1
	regress ntroops electionapproach12 early12 i.ccode i.year if cas_state==1
	regress ntroops electionapproach12 early12 i.ccode i.yearmo if cas_state==1
	
	* Add early12 to general model
	regress trpspcap electionapproach12 early12
	regress trpspcap electionapproach12 early12 i.ccode 	
	regress trpspcap electionapproach12 early12 i.ccode i.year
	regress trpspcap electionapproach12 early12 i.ccode i.yearmo

	* Add early12 to casualties model, troops pcap numbers

	regress trpspcap electionapproach12 early12 if cas_state==1
	regress trpspcap electionapproach12 early12 i.ccode 	if cas_state==1
	regress trpspcap electionapproach12 early12 i.ccode i.year if cas_state==1
	regress trpspcap electionapproach12 early12 i.ccode i.yearmo if cas_state==1

	
