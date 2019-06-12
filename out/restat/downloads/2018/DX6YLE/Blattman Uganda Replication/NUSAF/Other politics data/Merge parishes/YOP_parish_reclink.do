/***************************************************************************
*			Title: RECLINK PARISH 
*			Output: Yop_data
*			Date: May, 2012
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
	set varabbrev on
	set maxvar 10000

// SET GLOBAL FOR DIRECTORY
	gl Dropbox "C:\Users\memeriau\Dropbox"
	
// TEMPFILES 
	tempfile yop pres11 pres06 exclude06 exclude11
	
/***************************************************************************
*** 2. LOAD DATA ***********************************************************
****************************************************************************/
	
// OPEN YOP FILE 
	use  "$Dropbox\Projects\Does foreign aid buy domestic votes\Analysis\data\yop_analysis_temp.dta"  , clear
	keep groupid district subcounty_final parish_final assigned
	ren parish_final parish
	ren subcounty_final scounty
	duplicates drop
	foreach x in district scounty parish { 
		replace `x' = lower(`x')
		replace `x' = trim(`x')
	}
	sort groupid 
	drop if parish == ""
	save "`yop'", replace
	
// OPEN 2011 ELECTION FILE

	insheet using "$Dropbox\Projects\Does foreign aid buy domestic votes\Analysis\Other data\Elections\rawdata\2011_pres.csv", clear
	format parish_id_res11 %12.0f
	keep e_district_name e_scounty_name e_parish_name parish_id_res
	ren e_district_name district
	ren e_scounty_name scounty
	ren e_parish_name parish
	
	foreach x in district scounty parish { 
		replace `x' = lower(`x')
		replace `x' = trim(`x')
	}	
	duplicates drop
	sort district scounty parish
	gen idusing = _n
	save "`pres11'", replace

// OPEN 2006 ELECTION FILE
 
	insheet using "$Dropbox\Projects\Does foreign aid buy domestic votes\Analysis\Other data\Elections\rawdata\2006_pres.csv", clear
	format parish_id_res06 %12.0f

	keep e_district_name e_scounty_name e_parish_name parish_id_res06
	ren e_district_name district
	ren e_scounty_name scounty
	ren e_parish_name parish
	
	duplicates drop
	foreach x in district scounty parish { 
		replace `x' = lower(`x')
		replace `x' = trim(`x')
	
	}
	sort district scounty parish
	gen idusing = _n
	save "`pres06'", replace
	
// 2006 EXLUDE FILE 
	insheet using "$Dropbox\Projects\Does foreign aid buy domestic votes\Analysis\Merge parishes\reclink\parish_yoppres06.csv", clear
	format parish_id_res06 %12.0f
	duplicates tag groupid, gen(dup)
	save "`exclude06'", replace 
	
// 2011 EXCLUDE FILE 
	insheet using "$Dropbox\Projects\Does foreign aid buy domestic votes\Analysis\Merge parishes\reclink\parish_yoppres11.csv", clear
	format parish_id_res11 %12.0f
	duplicates tag groupid, gen(dup)
	save "`exclude11'", replace 

/***************************************************************************
*** 3. RECLINK *************************************************************
****************************************************************************/
	
// RECLINK with 2006

	use "`yop'", clear
	*reclink parish scounty district using "`pres06'", idmaster(groupid) idusing(idusing) gen(matchprob)  minscore(.5) exclude("`exclude06'")
	reclink parish  using "`pres06'", idmaster(groupid) idusing(idusing) gen(matchprob)  minscore(.5) exclude("`exclude06'")
	format parish_id_res06 %12.0f
 xx
// RECLINK with 2011

	*use "`yop'", clear
	*reclink parish scounty district using "`pres11'", idmaster(groupid) idusing(idusing) gen(matchprob)  minscore(.5)
	*format parish_id_res11 %12.0f
	xx
// MERGE YOP AND 2011 ELECTIONS DATA 
	
	use "`merge'", clear
	ren udistrict  districtname
	ren usubcounty scountyname
	ren uparish parishname
	merge districtname 

	
	






















