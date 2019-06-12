	use nelda3, clear
	egen date = concat(mmdd)
	gen l = length(date)
	gen m = substr(date,-4,2) if l==4
	replace m= substr(date,-3,1) if l==3
	destring m, replace
	gen year_original = year

	gen r = substr(electionid,-1,1)  		/*get election round*/
	destring r, replace 
	gen t = substr(electionid,-2,1)  		/*get election type*/
	gen eid = substr(electionid,1,13) 
	bysort eid: egen maxr = max(r)
	keep if t=="L" | t=="P" 			/*keep only legislative and presidential elections*/
	keep if maxr==r                 		/*keep only final round of each election*/

	gen election=1 
	gen incum_contest = nelda20=="yes" if nelda20~=""  /* Was the office of the incumbent leader contested in this election? */

	tab election
	gen cowcode =.
	qui do cowcodes
	recode cow (260=255) /* Germany, West Germany */

	drop if year>2010
	sort cowcode year
	local type = "election incum_c"
	foreach typen of local type {
		egen max_`typen' =max(`typen'), by(cow year)
	}
 	
	egen tag  = tag(cow year)
	keep if tag==1
	keep cow year* max* country
	local type = "election incum_c"
	foreach typen of local type {
		rename max_`typen' nelda_`typen'
	}
 	
	rename country nelda_country
	keep cow year nelda_*  
	order cow year
	sort cowcode year
	save nelda_merge, replace
