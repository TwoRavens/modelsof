*this file prepares the data for computing second moments between familiy members
*it calls the file covaxn_extrad that does the estimation of moments


set trace off
clear all
set mem 5000m
set maxvar 30000
set matsize 10000
cap log close
set more off
log using demean_extrad.log,replace


*set trace on
forv b = 0(1)2 {
	use earnings_long	, clear
	qui summ cohort if bob == `b'
	local min =  r(min)
	local max =  r(max)	
	forv co = `min'(3)`max' { 
		use earnings_long	, clear
		keep if bob==`b' & cohort==`co'		
		ta year, ge(years)
		ge agesq=ageC^2
		regress  logearn years* ageC agesq ,noc
		predict res ,resid
		compress
		save res_b`b'_c`co',replace
		sort year 
		global from_b`b'_c`co'=year[1]		
		global to_b`b'_c`co'=year[_N]		
		forv j = ${from_b`b'_c`co'}(1)${to_b`b'_c`co'} {
			preserve
			keep if year==`j'
			sort pnrf
			by pnrf: assert _N==1
			rename res res_b`b'_c`co'_`j'
			rename ageA ageA_b`b'_c`co'_`j'
			rename ageC ageC_b`b'_c`co'_`j'
			keep pnr pnrf res_b`b'_c`co'_`j' ageA_b`b'_c`co'_`j' ageC_b`b'_c`co'_`j' 
			save  err_b`b'_c`co'_`j',replace
			restore
			local j=`j'+1
		}
		erase res_b`b'_c`co'.dta
		use err_b`b'_c`co'_${from_b`b'_c`co'}
		local k= ${from_b`b'_c`co'} + 1
		forv j= `k'(1)${to_b`b'_c`co'} {
			merge pnrf using err_b`b'_c`co'_`j'
			drop _merge
			sort pnrf
			by pnrf: assert _N==1
			erase err_b`b'_c`co'_`j'.dta
		}
		save resi_b`b'_c`co', replace
		erase err_b`b'_c`co'_${from_b`b'_c`co'}.dta
	}
}




forv b1 = 0(1)1 {
	local k = `b1' + 1
	forv b2 = `k'(1)2 {
		use earnings_long	, clear
		qui summ co if bob==`b1'
		local fb1=r(min)
		local tb1=r(max)
		qui summ co if bob==`b2'
		local fb2=r(min)
		local tb2=r(max)
		forv cob1 = `fb1'(3)`tb1' {
			forv cob2 = `fb2'(3)`tb2' {
				global b1 = `b1'
				global b2 = `b2'
				global cob1 = `cob1'
				global cob2 = `cob2'
				use resi_b`b1'_c`cob1', clear
				merge pnrf using resi_b`b2'_c`cob2'
				sort pnrf
				by pnrf: assert _N==1
				keep if _merge==3
				drop _merge
				if _N>100 {		//compute moments only for cross cohorts pairs with at least 100 matches
					do covaxn_extrad
				}
			}
		}
		use earnings_long	, clear
		qui summ co if bob==`b1'
		local fb1=r(min)
		local tb1=r(max)
		qui summ co if bob==`b2'
		local fb2=r(min)
		local tb2=r(max)
		forv i = `fb1'(3)`tb1' {
			forv j = `fb2'(3)`tb2' {
				if `i' ==`fb1' & `j' ==`fb2' {
					use mmfm_b${b1}${b2}_co`i'`j'
				}
				if `i' >`fb1' | `j' >`fb2'{
					capture append using mmfm_b${b1}${b2}_co`i'`j'
					capture erase mmfm_b${b1}${b2}_co`i'`j'.dta
				}
			}
		}
		save moments_`b1'_`b2', replace
		erase mmfm_b${b1}${b2}_co`fb1'`fb2'.dta
	}
}




forv b = 0(1)2 {
	use earnings_long	, clear
	qui summ co if bob==`b'
	local fb1=r(min)
	local tb1=r(max)
	forv co = `fb1'(3)`tb1' { 
		erase resi_b`b'_c`co'.dta
		}
}



cap log close
