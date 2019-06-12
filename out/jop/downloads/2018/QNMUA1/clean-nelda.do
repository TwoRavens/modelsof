	use nelda4-original, clear
	egen date = concat(mmdd)
	gen l = length(date)
	gen m = substr(date,-4,2) if l==4
	replace m= substr(date,-3,1) if l==3
	destring m, replace
	gen year_original = year
	gen month_original =m

	gen r = substr(electionid,-1,1)  /*get election round*/
	destring r, replace 
	gen t = substr(electionid,-2,1)  /*get election type*/
	gen eid = substr(electionid,1,13) 
	bysort eid: egen maxr = max(r)
	keep if t=="L" | t=="P" /*keep only legislative and presidential elections*/
	*keep if maxr==r         /*keep only final round of each election*/

	gen election=1 
	gen irelection = election
	replace irelection = 0 if nelda6=="no" 
	gen relection = election
	replace relection=0 if irelection==1
	gen mparty = nelda3=="yes" & nelda4=="yes" & nelda5=="yes" if nelda3~="" & nelda4~="" & nelda5~=""
	gen incumb = nelda20=="yes" if nelda20~=""
	gen boycott = nelda14=="yes" if nelda14~=""

	tab election
	gen cowcode =.
	qui do cowcodes
	recode cow (260=255) /* Germany, West Germany */
	sum

	drop if year>2010
	sort cowcode year 
	local type = "election relection irelection mparty incumb boycott month"
	foreach typen of local type {
		egen max_`typen' =max(`typen'), by(cow year)
	}
	egen min_month = min(month), by(cow year)
	forval x = 1/58 {
		gen y_nelda`x' = nelda`x'=="yes" if nelda`x'~=""
		egen max_nelda`x' =max(y_nelda`x'), by(cow year)
	}	
	egen tag  = tag(cow year)
	keep if tag==1
	keep cow year* max* country min
	local type = "election relection irelection mparty incumb boycott month"
	foreach typen of local type {
		rename max_`typen' nelda_`typen'
	}
	forval x = 1/58 {
		rename max_nelda`x' nelda_`x'
	}	
	rename min_month nelda_minmonth
	rename nelda_month nelda_maxmonth
	rename country nelda_country
	order cow year
	sort cowcode year
	save nelda-merge, replace
