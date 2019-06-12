/***************************************************************************
*			Title: CLEAN LC5 ELECTION RESULTS         
*			Output: 
*			Date: MARCH 2016
*			Files Used: 
****************************************************************************/

/***************************************************************************
*** 1. SET UP **************************************************************
****************************************************************************/

// CLEAR 
	drop _all 
	clear matrix
	clear mata
	
// SET PARAMETERS 
	set more off
	set varabbrev on
	set maxvar 27000

// SET GLOBAL FOR DIRECTORY

	// Mathilde
		*gl data "C:\Users\memeriau\Dropbox\Projects\NUSAF\YOP 4-year"
		*gl paper "C:\Users\memeriau\Dropbox\Projects\Does foreign aid buy domestic votes"
			  
	// Chris
		*gl data "/Users/chrisblattman/Dropbox/Research & Writing/Projects/Uganda/IPA Uganda NUSAF YOP/YOP 4-year"
		*gl paper "/Users/chrisblattman/Dropbox/Research & Writing/Papers - Pipeline/NUSAF political"
		
	// Patryk
		gl data "C:\Users\pperkowski\Dropbox\NUSAF\YOP 4-year"
		gl paper "C:\Users\pperkowski\Dropbox\Does foreign aid buy domestic votes"
		
/***************************************************************************
*** 2. MERGE NEW DATA *******************************************************
***************************************************************************/
	
// IMPORT ELECTION DATA	
	*import excel using "$paper/Analysis/dofiles/LC5 party/2011_District_Chairperson_district_level.xlsx", firstrow
	use "$paper/Analysis/dofiles/LC5 party/District_Chairperson_winners_2011.dta", clear

	*keep if STATUS=="WINNER"
	
	gen win_nrm = 0
	replace win_nrm=1 if partyorindependent=="NRM"
	la var win_nrm "NRM LC5 won 2011 election"
	gen win_opp = !win_nrm
	la var win_opp "NRM LC5 lost 2011 election"
	
	rename district district_e
	keep district_e win_*
	
	gen e2=1
	
	
	save "$paper/Analysis/dofiles/LC5 party/2011_LC5_by_district.dta", replace
