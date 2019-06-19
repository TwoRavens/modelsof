**This file runs our prefered specification for the county-pair sample for the employment / population ratio. 

clear
set mem 1g
set matsize 5000
set maxvar 5000
set more off

use MinWage_restaurants-CBP.dta

*********************** CONTIGUOUS COUNTIES *****************************************
set more off
drop _all

insheet using "county-pairs with cross-state msa codes.txt", comma
rename county countyreal
rename countypair_id pair_id


expand 16
egen pair_id_county = group(pair_id countyreal)
sort pair_id_county
generate firstob=1 if pair_id_county!= pair_id_county[_n-1]
gen period=1 if firstob
replace period=period[_n-1]+1 if firstob!=1

sort period countyreal pair_id

merge period countyreal using MinWage_restaurants-CBP-6-15.dta

drop if _merge~=3
drop _merge


*****************

gen all=1
gen event = (event_type<3)

********
**recoding san francisco state code.
replace st_fips=99 if countyreal==6075
egen pair_id_period = group(pair_id period)
egen numduplcty = sum(all), by(period county)
gen weight_duplcty = 1/numduplcty

egen nonmissing_both_pair = min(nonmissing_rest_both), by(pair_id)

egen lnMW_min_pairperiod = min(lnMW), by(pair_id_period)
egen lnMW_max_pairperiod = max(lnMW), by(pair_id_period)
gen lnMW_dif_period = (lnMW_min_pairperiod != lnMW_max_pairperiod)
egen lnMW_dif = max(lnMW_dif_period), by(pair_id)

*drop if nonmissing_both_pair!=16 

drop if period>78 
drop if year<1990
**

egen pair_id_num = group(pair_id)
gen sample_3 = 1
gen absorb_3 = period
gen sample_4 = 1
egen absorb_4 = group(pair_id period)

sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)
egen bordersegment = group(st_min st_max)

****Generating lnepop data
rename  empRESTBOTH emp_rest_both

gen lnepop_rest_both=ln(emp_rest_both/pop)
gen lnepop_TOT=ln(empTOT/pop)

xi: areg lnepop_rest_both   ,  absorb(county)
predict lnepop_rest_bothR , res


xi: areg lnMW   ,  absorb(county)
predict lnMWR , res

gen lnpop=ln(pop) 
xi: areg lnpop   ,    absorb(county)
predict lnpopR, res 

xi: areg lnepop_TOT   ,    absorb(county)
predict lnepop_TOTR, res 

*K loops through industries .
*
foreach k in rest_both {

xi: areg lnAWW_`k', absorb(county)
predict lnAWW_`k'R, res 
 
xi: areg lnemp_`k'   , absorb(county)
predict lnemp_`k'R, res


forval specification = 3/4 {

*
quietly cluster2areg lnAWW_`k'R lnMWR  if sample_`specification'==1 & nonmissing_`k'==16,  fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c2  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c2 = -r(se)
		quietly scalar define AWW_N_`k'`specification' = e(N)

 quietly cluster2areg lnepop_`k'R lnMWR if sample_`specification'==1 & nonmissing_`k'==16, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR 
	quietly scalar define EMPestMW_spec`k'`specification'_c2  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c2 = -r(se)
	

* Total Employment Controls C3*
quietly cluster2areg lnAWW_`k'R  lnMWR  if sample_`specification'==1 & nonmissing_`k'==16,  fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c3  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c3 = -r(se)
	

 quietly cluster2areg lnepop_`k'R lnMWR lnepop_TOTR if sample_`specification'==1 & nonmissing_`k'==16, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR 
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	

}


matrix MAIN`k'= [AWW_N_`k'3, AWWestMW_spec`k'3_c2, AWWseMW_spec`k'3_c2, AWWestMW_spec`k'3_c3, AWWseMW_spec`k'3_c3, 0, EMPestMW_spec`k'3_c2, EMPseMW_spec`k'3_c2, EMPestMW_spec`k'3_c3, EMPseMW_spec`k'3_c3,0]
 
matrix A =  [AWW_N_`k'4, AWWestMW_spec`k'4_c2, AWWseMW_spec`k'4_c2, AWWestMW_spec`k'4_c3, AWWseMW_spec`k'4_c3, 0, EMPestMW_spec`k'4_c2, EMPseMW_spec`k'4_c2, EMPestMW_spec`k'4_c3, EMPseMW_spec`k'4_c3,0]

matrix MAIN`k' = MAIN`k'\A

}

log using epop-results-10-9.log, replace
*rest_limit rest_full
foreach k in rest_both  {
matrix list MAIN`k'
}
log close



