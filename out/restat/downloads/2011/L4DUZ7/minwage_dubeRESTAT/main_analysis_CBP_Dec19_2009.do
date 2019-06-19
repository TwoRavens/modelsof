
clear
set mem 1g
set matsize 5000
set maxvar 5000
set more off

 


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

merge period countyreal using MinWage_restaurants-CBP-6-5.dta

drop if _merge~=3
drop _merge

*drop all
gen all=1
*gen event = (event_type<3)



********
**recoding san francisco state code.
replace st_fips=99 if countyreal==6075
egen pair_id_period = group(pair_id period)
egen numduplcty = sum(all), by(period county)
gen weight_duplcty = 1/numduplcty
egen nonmissing_both_pair = min(nonmissing_rest_all), by(pair_id)
egen lnMW_min_pairperiod = min(lnMW), by(pair_id_period)
egen lnMW_max_pairperiod = max(lnMW), by(pair_id_period)
gen lnMW_dif_period = (lnMW_min_pairperiod != lnMW_max_pairperiod)
egen lnMW_dif = max(lnMW_dif_period), by(pair_id)
drop if lnMW_dif!=1 | nonmissing_both_pair!=16
**

egen pair_id_num = group(pair_id)
gen sample_5 = 1
egen absorb_5 = group(pair_id period)

***dropping large counties.
sort pair_id cntyarea
egen maxarea_within_pair=max(cntyarea), by(pair_id)
drop if maxarea_within_pair>2000
***
sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)
egen bordersegment = group(st_min st_max)

xi: areg lnMW   ,  absorb(county)
predict lnMWR , res

gen lnpop=ln(pop) 
xi: areg lnpop   ,    absorb(county)
predict lnpopR, res 

 
xi: areg lnemp_TOT   ,    absorb(county)
predict lnemp_TOTR, res 

xi: areg lnAWW_TOT   ,   absorb(county)
predict lnAWW_TOTR, res

*K loops through industries rest_full rest_limit  .
foreach k in rest_all {

xi: areg lnAWW_`k', absorb(county)
predict lnAWW_`k'R, res 
 
xi: areg lnemp_`k'   , absorb(county)
predict lnemp_`k'R, res

gen epop_`k' = (exp(lnemp_`k')/pop)
xi: areg epop_`k'   , absorb(county)
predict epop_`k'R, res


forval specification = 5/5 {

* Unclustered *
 xi: xtreg lnAWW_`k'R lnMWR lnAWW_TOTR if nonmissing_`k'==16 & sample_`specification'==1  , i(absorb_`specification') robust fe nonest
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'  = r(estimate)  
	quietly scalar define AWWseMW_spec`k'`specification'_cl0 = -r(se)
      quietly scalar define AWW_N_`k'`specification' = e(N)


 quietly xtreg lnemp_`k'R lnMWR lnemp_TOTR lnpopR if nonmissing_`k'==16 & sample_`specification'==1 , i(absorb_`specification') robust fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'  = r(estimate)  
	quietly scalar define EMPseMW_spec`k'`specification'_cl0 = -r(se)
      quietly scalar define EMP_N_`k'`specification' = e(N)

 quietly xtreg epop_`k'R lnMWR   if nonmissing_`k'==16 & sample_`specification'==1 , i(absorb_`specification') robust fe nonest
      quietly lincom lnMWR
	quietly scalar define EPOPestMW_spec`k'`specification'  = r(estimate)  
	quietly scalar define EPOPseMW_spec`k'`specification'_cl0 = -r(se)
      quietly scalar define EPOP_N_`k'`specification' = e(N)

* State  clustered 
 quietly xtreg lnAWW_`k'R lnMWR lnAWW_TOTR if nonmissing_`k' ==16 & sample_`specification'==1 , i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
 	quietly scalar define AWWseMW_spec`k'`specification'_cl4= -r(se)

 quietly xtreg lnemp_`k'R lnMWR lnemp_TOTR lnpopR if nonmissing_`k' ==16 & sample_`specification'==1 ,  i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPseMW_spec`k'`specification'_cl4 = -r(se)

 quietly xtreg epop_`k'R lnMWR  if nonmissing_`k' ==16 & sample_`specification'==1 ,  i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EPOPseMW_spec`k'`specification'_cl4 = -r(se)


*State-Boundary clustered *

    quietly xtreg lnAWW_`k'R lnMWR lnAWW_TOTR if nonmissing_`k' ==16 & sample_`specification'==1    , i(absorb_`specification') cluster(bordersegment) fe nonest
     quietly lincom lnMWR
	quietly scalar define AWWseMW_spec`k'`specification'_cl5 = -r(se) 

    quietly xtreg lnemp_`k'R lnMWR lnemp_TOTR lnpopR if nonmissing_`k' ==16 & sample_`specification'==1    , i(absorb_`specification') cluster(bordersegment) fe nonest
      quietly lincom lnMWR
 	quietly scalar define EMPseMW_spec`k'`specification'_cl5 = -r(se)

    quietly xtreg epop_`k'R lnMWR   if nonmissing_`k' ==16 & sample_`specification'==1    , i(absorb_`specification') cluster(bordersegment) fe nonest
      quietly lincom lnMWR
 	quietly scalar define EMPseMW_spec`k'`specification'_cl5 = -r(se)

}





matrix A = [AWW_N_`k'5 , AWWestMW_spec`k'5, AWWseMW_spec`k'5_cl0, AWWseMW_spec`k'5_cl4, AWWseMW_spec`k'5_cl5 , EMP_N_`k'5, EMPestMW_spec`k'5, EMPseMW_spec`k'5_cl0, EMPseMW_spec`k'5_cl4, EMPseMW_spec`k'5_cl5,EPOP_N_`k'5, EPOPestMW_spec`k'5, EPOPseMW_spec`k'5_cl0, EPOPseMW_spec`k'5_cl4, EPOPseMW_spec`k'5_cl5 ]
matrix MAIN`k' = MAIN`k'\A

}

 

matrix list MAINrest_all

log close



