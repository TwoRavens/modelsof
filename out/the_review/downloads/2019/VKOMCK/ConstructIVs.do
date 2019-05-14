/*
8 April 2016

This do-file creates both votes & seats PI indexes for the 2004 and 2009 elections. 
The 2004 PI index requires data from the 1999 election and 2004 election. 
The 2009 PI index requires data from the 2004 election and 2009 election. 

*/

cd "D:\Users\bholtemeyer\Dropbox (IFPRI)\Brian\Mali\dta"	// change as necessary
qui {
cap program drop longtowide
	program longtowide
	syntax, k(str) m(str) pi_yr(int) pi_yr2(int)
	keep year `k' `m'
	preserve
		keep if year == `pi_yr'
		drop year
		foreach kk in `k'{
			loc labb: var label `kk'
			lab var `kk' "`labb' (`pi_yr')"
			rename `kk' `kk'_`pi_yr'
		}
		tempfile somedata_tf
		sa		`somedata_tf'
	restore
	keep if year == `pi_yr2'
	drop year
	foreach kk in `k'{
		loc labb: var label `kk'
		lab var `kk' "`labb' (`pi_yr2')"
		rename `kk' `kk'_`pi_yr2'
	}
	mer 1:1 `m' using `somedata_tf'
end
}

********************
//Measures of competitiveness: HHI for political competition
********************

use "cleanData_6-15-2016", clear


**calculate vote & seat shares by commune
foreach k in  votes		seats { // 
	gsort 	commune year -`k'_won c1 c2 c3 c4 c5 c6 c7
	bys		commune year: gen `k'_order = _n
	gen		`k'_share2 =(`k'_won / `k'_won_tot)^2
	egen 	`k'_max = max(`k'_share), by(commune year)
	gen		`k'_share_without_highest = `k'_share
	replace `k'_share_without_highest = -999 if `k'_order==1
	egen 	`k'_max_without_highest = max(`k'_share_without_highest ), by(commune year)
	gen		`k'_margin = `k'_max -	`k'_max_without_highest 
	recode	`k'_margin  (1000 = 1) // those with only 1 party per commune/year 
	lab var	`k'_margin "`k' win margin"
	format	`k'_margin %9.2f
}

preserve
	collapse (sum) seats_share2 	votes_share2	, by(commune year)
	rename (seats_share2 	votes_share2) (seats_HHI	votes_HHI)
	lab var seats_HHI "HHI: seat share"
	lab var votes_HHI "HHI: vote share"
	format 	votes_HHI seats_HHI %9.2f
	tempfile HHI_tf
	sa		`HHI_tf'
restore

keep commune year seats_margin votes_margin 
duplicates drop * , force
mer 1:1 commune year using `HHI_tf', assert(3) nogen

reshape8 wide votes_margin seats_margin seats_HHI votes_HHI, i(commune) j(year)

rename *2009 *_2009
rename *2004 *_2004
rename *1999 *_1999

tempfile HHI_and_marginOfVict_tf
sa		`HHI_and_marginOfVict_tf'


********************
//PI Measures 
********************


qui foreach t in seats votes {
foreach PI_yr in 2004 2009 {
	/*
	loc t 		=	"votes"
	loc PI_yr 	= 	2009
	loc t 		=	"seats"	
	loc PI_yr 	= 	2004
	*/

	
	/*
		The 2004 PI index requires data from the 1999 election and 2004 election. 
		The 2009 PI index requires data from the 2004 election and 2009 election. 
	*/
	if `PI_yr'==2009 loc PI_yr2 = 2004
	if `PI_yr'==2004 loc PI_yr2 = 1999


	********************
	//construct intermediary var for PI_a
	********************
	use "cleanData_6-15-2016", clear
	**use "smallfile", clear

	longtowide, k(`t'_share) m("commune ticket") pi_yr(`PI_yr') pi_yr2(`PI_yr2')
	rename 	`t'_share*	`t'_share_PI_a*
	recode 	`t'_share_PI_a_`PI_yr'		`t'_share_PI_a_`PI_yr2'	(.=0)
	lab var `t'_share_PI_a_`PI_yr' "used to construct PI (a)"

	tempfile PI_A_tf
	sa		`PI_A_tf'


	********************
	//construct intermediary var for PI_b
	********************
	use "cleanData_6-15-2016", clear
	**use "smallfile", clear

	keep if inlist(year, `PI_yr', `PI_yr2')
	ta year,m
	loc v = "`t'_won	seats_won_tot 	votes_won_tot `t'_share"

	drop ticket* 
	reshape long  c@ ,i(commune year party 	`v') 	j(parties_alpha_order) // now data are at the year/commune/coalition-member level
	drop if c==""
	rename c member

	**allocate SEAT share equally among all members of a coalition
	egen total_parties_per_coalition = max(parties_alpha_order), by(commune	year	party)
	gen		`t'_share_PI_b = `t'_share / total_parties_per_coalition
	lab var `t'_share_PI_b "to construct PI(b)"
	format 	`t'_share_PI_b %9.2f

	********************
	//construct intermediary vars for PI_c vars
	********************
	loc v = "`t'_share_PI_b 	party 	total_parties_per_coalition 	`t'_won		votes_won_tot 	seats_won_tot 	`t'_share"
	longtowide,  k(`v'	) m("commune member") pi_yr(`PI_yr') pi_yr2(`PI_yr2') // after this reshape the data are at the commune/coalition-member level
	drop _merge

	order commune *`PI_yr2' member 
	sort 	commune party_`PI_yr' party_`PI_yr2', stable
	recode 	`t'_share_PI_b_`PI_yr'		`t'_share_PI_b_`PI_yr2'	(.=0)
	egen 	tot = sum(`t'_share_PI_b_`PI_yr'), by(commune	party_`PI_yr')

	/*
	br if commune==1125 //good for 2004-2009
	br if inlist(commune,4515) // good for 1999-2004
	br if commune==1125 //good for 2004-2009
	br if commune==6523 //good for 2004-2009
	br if commune==3177 //good for 2004-2009
	br if 	total_parties_per_coalition_2009>3	
	*/
	
	**PI_c1 (use next weakest party)
	recode 	`t'_share_PI_b_`PI_yr2' (0=999)	if `t'_won_`PI_yr2'	==. // temporary
	egen 	min 			= min(`t'_share_PI_b_`PI_yr2'), by(commune party_`PI_yr') 

	recode 	min 	`t'_share_PI_b_`PI_yr2' 	(999=0)
	gen		shares_`PI_yr2'_new = 			`t'_share_PI_b_`PI_yr2'
	replace	shares_`PI_yr2'_new = min if 	`t'_share_PI_b_`PI_yr2'==0
	replace	shares_`PI_yr2'_new = 0   if 	`t'_share_PI_b_`PI_yr2'==0 & `t'_won_`PI_yr2'==0
	egen 	party_tot_`t'	= sum(shares_`PI_yr2'_new), by(commune party_`PI_yr') 
	gen		party_distrib1 	= (shares_`PI_yr2'_new	/	party_tot_`t')
	drop 	min		shares_`PI_yr2'_new 	party_tot_`t'
	
	
	**PI_c2 (use "threshold" for those who were not present in 2004)
	if "`t'"=="seats" { // give new coalition members 1 seat
		g		seats_won_`PI_yr2'_temp =	seats_share_PI_b_`PI_yr2'
		replace seats_won_`PI_yr2'_temp	= 1/seats_won_tot_`PI_yr' if 	seats_won_`PI_yr2'==. & total_parties_per_coalition_`PI_yr'>1
	}
	if "`t'"=="votes" { // give new coalition members votes equal to (tot votes in prior election/tot seats prior election) 
		gen 	votes_per_seat 	= votes_won_tot_`PI_yr' / seats_won_tot_`PI_yr'		
		g		votes_won_`PI_yr2'_temp = votes_won_`PI_yr2'
		replace votes_won_`PI_yr2'_temp	= votes_per_seat if votes_won_`PI_yr2'_temp==. & total_parties_per_coalition_`PI_yr'>1
	}
	egen	tot_commune_`t'= sum(`t'_won_`PI_yr2'_temp), by(commune party_`PI_yr')
	gen		party_distrib2 = (`t'_won_`PI_yr2'_temp/tot_commune_`t')
	replace	party_distrib2 	=.  if party_`PI_yr2'==.  		& total_parties_per_coalition_`PI_yr'==1 // do this so that all of the 'party_distrib?' vars have the same skip pattern
	drop 	tot_commune_`t' 	`t'_won_`PI_yr2'_temp
	cap drop votes_per_seat*
	
	
	**PI_c3 (my addition; give zero weight to coalition members not present in 2004)
	egen	tot_commune_`t'3= sum(	`t'_share_PI_b_`PI_yr2'), by(commune party_`PI_yr')
	gen		party_distrib3 	= (		`t'_share_PI_b_`PI_yr2'	/	tot_commune_`t'3)
	drop 	tot_commune_`t'3


	**PI_c4 (my addition; give largest weight to new members)
	egen 	max 			= max(`t'_share_PI_b_`PI_yr2'),by(commune		party_`PI_yr') 
	gen		shares_`PI_yr2'_max = `t'_share_PI_b_`PI_yr2'
	replace	shares_`PI_yr2'_max = max 	if `t'_share_PI_b_`PI_yr2'==0
	replace	shares_`PI_yr2'_max = 0		if `t'_share_PI_b_`PI_yr2'==0 & `t'_won_`PI_yr2'==0
	egen 	party_tot_`t'2= sum(shares_`PI_yr2'_max), by(commune party_`PI_yr') 
	gen		party_distrib4 	= (shares_`PI_yr2'_max	/	party_tot_`t'2 )
	drop 	max 	shares_`PI_yr2'_max 	party_tot_`t'2


	**make 3 vars that will be used in the first 2 lines of the loop below
	g	dm_mis = (`t'_won_`PI_yr2'==.)
	egen maxx = max(`t'_won_`PI_yr2')	, by(commune 	party_`PI_yr')
	egen summ = sum(dm_mis)				, by(commune 	party_`PI_yr')

	**use the intraparty distribution to get vote share (only for PI_cX vars)
	forv k = 1/4 { 
		/*
		The next 2 lines of code address the issue of coalitions (that received votes/seats) that only have  
		members that received 0 or . seats in 2004. I decided to allocate their 2009 seats by these rule: 
			i)All coalition members had 0 seats in 2004: assign equal weight to each
			ii)Not all coalition members had 0 seats in 2004: (ie at least one new member),
				divide weights equally among new members (0 weight to those who received 0 seats)	
				FYI: communes 2264, 3591, and 4143 are all affected by this change
		*/
		replace party_distrib`k' 			= 	total_parties_per_coalition_`PI_yr'^-1	if maxx==0 & 	summ==0
		replace party_distrib`k' 			= 	dm_mis/summ								if maxx==0 & 	summ!=0

		replace	party_distrib`k' 			=	total_parties_per_coalition_`PI_yr'^-1	if party_`PI_yr2'==.	&		party_distrib`k'==.
		gen		`t'_share_PI_c`k'_`PI_yr'	=	`t'_share_PI_b_`PI_yr' 					if total_parties_per_coalition_`PI_yr'==1
		replace `t'_share_PI_c`k'_`PI_yr'	=	party_distrib`k'*tot 					if total_parties_per_coalition_`PI_yr'>1
		lab var `t'_share_PI_c`k'_`PI_yr' "used to construct PI (c) `k'"
		format 	`t'_share_PI_c`k'_`PI_yr' %9.2f
		recode  `t'_share_PI_c`k'_`PI_yr' (.=0)
	}
	recode `t'_share_PI_b* (.=0)
	keep commune member `t'_share_PI_*

	preserve	//QUICK CHECK:
		collapse (sum) `t'_share_PI_*, by(commune)
		noi sum *
		noi list commune if `t'_share_PI_b_`PI_yr2'<0.99	//this check is fine. It's not 1 for the missing communes. 
	restore

	tempfile PI_BandC_tf
	sa		`PI_BandC_tf'

	********************
	//Now use intermediary vars to construct PI_b & PI_c vars
	********************
	loc descrip_a =  "PIa: treat each coalition as new party"
	loc descrip_b =  "PIb: split equally among coalition parties"
	loc descrip_c1 = "PIc1: use next weakest party"
	loc descrip_c2 = "PIc2: votes/seat threshold"
	loc descrip_c3 = "PIc3: 0 shares for new parties"
	loc descrip_c4 = "PIc4: use strongest party"

	/*
	Pederson Index Type A: Type A captures volatility due to entry and exit of political parties from the system. 
	It is basically a seat share Pederson index computed using only a subset of the parties competing. Which to 
	use? Only those that held one or more legislative seats in only one of the two elections. Essentially, this 
	means just summing the seat shares of those who held a seat in 2004 but didn’t hold a seat in 2009, and 
	adding to that sum the sum of seat shares of those who held a seat in 2009 but didn’t hold a seat in 2004, 
	and then dividing the overall total by 2. See p. 6 of Tucker and Powell (2012) for the exact formula, and 
	check that instructions accord with that. 
	
	Pederson Index Type B: Type B captures volatility due to established parties winning and losing votes to other 
	established parties. It is basically a seat share Pederson index computed using only a subset of the parties 
	competing. Which to use? Only those that held one or more legislative seats in both elections. Again, please uses
	seats to decide if you use the party in the calculation (i.e. the party must have one 1+ seats in both elections). 
	*/
	foreach k in a b c1 c2 c3 c4 {
		if "`k'"=="a" { 
			use `PI_A_tf', clear	// the PI_a varible is constructed using a different data set than the PI_b or PI_c vars
			gen		dm_type_A = (`t'_share_PI_a_`PI_yr'==0	|	`t'_share_PI_a_`PI_yr2'==0)
			gen 	PI_`k' = abs(`t'_share_PI_a_`PI_yr' 	- 	`t'_share_PI_a_`PI_yr2')/2 
		}
		else { 
			use `PI_BandC_tf', clear
			**considered type A if do NOT get any seat/vote share in both years:
 			gen		dm_type_A = (`t'_share_PI_b_`PI_yr'==0		|	`t'_share_PI_b_`PI_yr2'==0)	// we can use "b" here because it will provide the same result as the cX vars
			gen 	PI_`k' = abs(`t'_share_PI_`k'_`PI_yr'		- 	`t'_share_PI_b_`PI_yr2')/2	// we need to subtract the 'b' term 
		}
		format 		PI_`k' 	%9.1f
		collapse (sum) PI_`k', by(commune dm_type_A)
		lab var dm_type_A "type A volatility (parties entering/leaving)"
		lab var PI_`k' "`descrip_`k''"
		
		tempfile `k'
		sa		``k''
	}

	**merge all data sets together
	use									`a'		, clear
	mer 1:1 commune dm_type_A	using	`b'		, nogen
	mer 1:1 commune dm_type_A	using	`c1'	, nogen
	mer 1:1 commune dm_type_A	using	`c2'	, nogen
	mer 1:1 commune dm_type_A	using	`c3'	, nogen
	mer 1:1 commune dm_type_A	using	`c4'	, nogen

	rename PI_* 	PI_*_`t'_`PI_yr'
	
	tempfile `t'_`PI_yr'
	sa		``t'_`PI_yr''
}
}


use									`seats_2004'	, clear
mer 1:1 commune dm_type_A	using	`seats_2009'	, nogen 
mer 1:1 commune dm_type_A	using	`votes_2004'	, nogen 
mer 1:1 commune dm_type_A	using	`votes_2009'	, nogen 

********************
//Edits (the rest is easy)
********************


**reshape wide for type A / type B PI (to get commune-level data set)
preserve
	reshape wide PI*, i(commune) j(dm_type_A)
	rename *0 *_type_B
	rename *1 *_type_A
	rename *200?_type_B *type_B_200?
	rename *200?_type_A *type_A_200?
	tempfile typeAB_tf
	sa		`typeAB_tf'
restore

**get total PI instead of type A / type B PI (will have commune-level data set)
collapse (sum) PI*, by(commune)
mer 1:1 commune 	using	`typeAB_tf'					,assert(3) nogen 
mer 1:1 commune 	using	`HHI_and_marginOfVict_tf'	,assert(3) nogen
mer 1:1 commune 	using	"commune_descriptions"		,assert(3) nogen


**Some communes have missing values for either type A or type B PI. They should be 0s. Next I'll worry about communes that are missing
recode PI* (.=0)


**Can't compute PI for communes in which the prior election data aren't available
unab ele2009: PI_*_2009*
foreach k in `ele2009' {
	di "`k'"
	replace `k' = . if dm_present_2004==0
}
unab ele2004: PI_*_2004*
foreach k in `ele2004' {
	di "`k'"
	replace `k' = . if dm_present_1999==0
}


**round so that comparisons don't pick up rounding issues
unab all: PI_*
foreach k in `all' {
	replace `k' = round(`k',.000001)
}


**improve the var labels (got messed up by the collapse and reshape)
foreach t in seats votes {
	foreach PI_yr in 2004 2009 {
		foreach k in a b c1 c2 c3 c4 {
			lab var PI_`k'_`t'_`PI_yr' 					"`t': `PI_yr': `descrip_`k''"
			lab var PI_`k'_`t'_type_A_`PI_yr'	"type A: `t': `PI_yr': `descrip_`k''"
			lab var PI_`k'_`t'_type_B_`PI_yr' 	"type B: `t': `PI_yr': `descrip_`k''"
		}
	}
}

fsum *2009*
fsum *2004*

**these are the subset of PI vars that we're focusing on for the regressions

#delimit ;
	loc RHS = "
	seats_margin 
	seats_HHI 
	PI_a_seats
	PI_c2_seats 
	PI_c3_seats
	PI_a_seats_type_B 
	PI_c2_seats_type_B 
	PI_c3_seats_type_B 
	PI_a_seats_type_A 
	PI_c2_seats_type_A 
	PI_c3_seats_type_A";
#delimit cr

foreach y in `RHS' { 						
	gen			`y'_2009_dif = 	`y'_2009 		-	 `y'_2004				
	lab var 	`y'_2009_dif "difference in: `y' (2009-2004)"		
	
	gen			`y'_2009_sq = 	`y'_2009^2
	lab var 	`y'_2009_sq "squared: `y' (2009)"
	
	**OLD METHOD:
	**gen			`y'_2009_dif_sq = 	`y'_2009_dif^2
	**lab var 	`y'_2009_dif_sq "squared difference in: `y' (2009-2004)"

	gen			`y'_2009_dif_sq = 	`y'_2009^2		-	 `y'_2004^2	
	lab var 	`y'_2009_dif_sq "difference in squares: `y' ($ 2009^2 - 2004^2 $ )"
}
foreach y in `RHS' { 						
	gen			`y'_2004_sq = 	`y'_2004^2
	lab var 	`y'_2004_sq "squared: `y' (2004)"
}

**None of the PI vars exist in 1999 because we don't have elections data prior to 1999
#delimit ;
	loc RHS = "
	seats_margin 
	seats_HHI ";
#delimit cr
												
foreach y in `RHS' { 						
	gen			`y'_2004_dif = 	`y'_2004 		-	 `y'_1999			
	lab var 	`y'_2004_dif "difference in: `y' (2004-1999)"		

	**OLD METHOD:
	**gen			`y'_2004_dif_sq = 	`y'_2004_dif^2
	**lab var 	`y'_2004_dif_sq "squared difference in: `y' (2004-1999)"	
	
	gen			`y'_2004_dif_sq = 	`y'_2004^2 		-	 `y'_1999^2	
	lab var 	`y'_2004_dif_sq "difference in squares: `y' ($ 2004^2 - 1999^2 $ )"
}	

**this is the variable "commune_Jessica" that allows us to link to the other data sets
ren commune commune_Jessica 

sa "PI_vars_6-15-2016", replace

exit
