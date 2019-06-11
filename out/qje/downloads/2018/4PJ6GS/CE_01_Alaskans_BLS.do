/*=====================================================================================

 Alaskans_BLS.do: 
	
   Creates identifier of Alaskans.
		   
	
		Lorenz Kueng, November 2014 (BLS VERSION)
		
=======================================================================================*/

cap log close CE_01_BLS
log using "$homedir/log-files/CE_01_BLS_$date.log", replace name(CE_01_BLS)					


*=========================================
* generate Alaska identifier
*=========================================

use "$homedir/data/stata/internal_to_publicuse_bridge.dta", clear
	
	generate Alaska =       (state==2 | state==94) // using internal data
	replace  Alaska = 1 if  (STATE==2 | STATE==94) // using public-use STATE variable for old files in 861 and 1051
	lab var  Alaska "Alaska identifier: state==02 | state==94"
	tab yq_num if Alaska==1	
	
	keep  yq_num newid NEWID Alaska state age_ref_ age2_
	order yq_num newid NEWID Alaska state age_ref_ age2_
	
	drop if newid==.
	
	duplicates drop newid state, force
	
	duplicates tag newid, g(tag)
	tab tag
	count if tag>0
	drop tag
	
	duplicates drop newid, force	

	compress
	sort newid
	save "$homedir/data/stata/State_BLS.dta", replace


log close CE_01_BLS
