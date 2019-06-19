**THIS DO FILE PRODUCES THE RESULTS FOR APPENDIX TABLE A1.

*outline of file:  All specifications will include a state linear trend "i.state_fips*period ". 
*Specification 1: All counties
*2)  all metro counties
*3) All counties with Census Division controls
*4) All county border pairs
*5) All county border pairs with CCBP fixed effects.


clear
set mem 1g
set matsize 5000
set maxvar 5000
set more off


use QCEWindustry_minwage_all.dta

gen all=1

egen stperiod = group(state_fips period)

gen sample_1 = (all==1)
gen sample_2 = (all==1)
gen sample_3 = (all==1)
gen sample_4 = (all==1)


gen absorb_1 = period
egen absorb_2 = group (period cbmsa) 
egen absorb_3= group (period censusdiv)

keep if period>24 & period<91

xi: areg lnMW  if period>24 & period<91,   absorb(county)
predict lnMWR , res
sum lnMWR

xi: areg lnpop   ,    absorb(county)
predict lnpopR, res 

xi: areg lnemp_TOT   ,    absorb(county)
predict lnemp_TOTR, res 


foreach k in rest_both {
set more off
xi: areg lnemp_`k'   ,    absorb(county)
predict lnemp_`k'R, res 



****** SPEC 1-3 *******

forval specification = 1/3 {


xi: quietly xtreg lnemp_`k'R lnMWR lnemp_TOTR i.state_fips*period if sample_`specification'==1 & nonmissing_`k'==66, i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	quietly scalar define EMP_N_spec`k'`specification'_c3 = e(N)	
}


  
matrix MAIN`k' = [EMP_N_spec`k'1_c3 ,EMPestMW_spec`k'1_c3, EMPseMW_spec`k'1_c3,0]
  
forval j= 2/3 {
 matrix A =  [EMP_N_spec`k'`j'_c3 ,EMPestMW_spec`k'`j'_c3, EMPseMW_spec`k'`j'_c3,0]
 
 matrix MAIN`k'= MAIN`k'\A
}
}
 

*********************** CONTIGUOUS COUNTIES *****************************************
set more off
drop _all

use QCEWindustry_minwage_contig.dta

keep if period>24 & period<91

egen pair_id_num = group(pair_id)
gen sample_4 = 1
gen absorb_4 = period
gen sample_5 = 1
egen absorb_5 = group(pair_id period)


sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)
egen bordersegment = group(st_min st_max)

xi: areg lnMW  if period>24 & period<91 ,  absorb(county)
predict lnMWR , res

xi: areg lnpop   ,    absorb(county)
predict lnpopR, res 

xi: areg lnemp_TOT   ,    absorb(county)
predict lnemp_TOTR, res 


foreach k in rest_both  {

 
xi: areg lnemp_`k'   , absorb(county)
predict lnemp_`k'R, res


forval specification = 4/5 {

xi: quietly cluster2areg lnemp_`k'R lnMWR lnemp_TOTR lnpopR i.state_fips*period if sample_`specification'==1 & nonmissing_`k'==66, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
        quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	quietly scalar define EMP_N_spec`k'`specification'_c3 = e(N)	
}


matrix A= [EMP_N_spec`k'4_c3 ,EMPestMW_spec`k'4_c3, EMPseMW_spec`k'4_c3,0]

matrix MAIN`k' = MAIN`k'\A
  
matrix A = [EMP_N_spec`k'5_c3 ,EMPestMW_spec`k'5_c3, EMPseMW_spec`k'5_c3,0]


matrix MAIN`k' = MAIN`k'\A

}

log using appendix_statelineartrends-11-6-09.log, replace

foreach k in rest_both  {
matrix list MAIN`k'
}
log close



