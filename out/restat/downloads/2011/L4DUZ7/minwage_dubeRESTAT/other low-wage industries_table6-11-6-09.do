*THIS DO FILE RUNS OUR PREFERRED SPECIFICATION FOR DETAILED RESTAURANT INDUSTRIES AND OTHER LOW WAGE SECTORS, AS WELL AS
*MANUFACTURING.  THESE RESULTS FORM TABLE 6. 

clear
set mem 1g
set matsize 5000
set maxvar 5000
set more off

*cd "SET PATH HERE"
*********************** CONTIGUOUS COUNTIES *****************************************
drop _all 

use QCEWindustry_minwage_contig.dta

**

egen pair_id_num = group(pair_id)
gen sample_5 = 1
gen absorb_5 = period
gen sample_6 = 1
egen absorb_6 = group(pair_id period)

sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)
egen bordersegment = group(st_min st_max)

xi: areg lnMW   ,  absorb(county)
predict lnMWR , res

xi: areg lnpop   ,    absorb(county)
predict lnpopR, res 

xi: areg lnemp_TOT   ,    absorb(county)
predict lnemp_TOTR, res 

xi: areg lnAWW_TOT   ,   absorb(county)
predict lnAWW_TOTR, res

*K loops through industries .

foreach k in rest_limit rest_full ACFS RETAIL ACFSRETAIL MFG {

xi: areg lnAWW_`k', absorb(county)
predict lnAWW_`k'R, res 
 
xi: areg lnemp_`k'   , absorb(county)
predict lnemp_`k'R, res


forval specification = 5/6 {

*population controls 
quietly cluster2areg lnAWW_`k'R lnMWR  if sample_`specification'==1 & nonmissing_`k'==66,  fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c2  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c2 = -r(se)
	quietly scalar define AWW_N_`k'`specification' = e(N)

 quietly cluster2areg lnemp_`k'R lnMWR lnpopR if sample_`specification'==1 & nonmissing_`k'==66, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c2  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c2 = -r(se)
	quietly lincom lnpopR 
	quietly scalar define EMPpopest_spec`k'`specification'_c2 = r(estimate)
	quietly scalar define EMPpopse_spec`k'`specification'_c2 = -r(se)

* Population & Total Employment Controls C3*
quietly cluster2areg lnAWW_`k'R lnAWW_TOTR lnMWR  if sample_`specification'==1 & nonmissing_`k'==66,  fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c3  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c3 = -r(se)
	
 quietly cluster2areg lnemp_`k'R lnMWR lnemp_TOTR lnpopR if sample_`specification'==1 & nonmissing_`k'==66, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	quietly lincom lnpopR + lnemp_TOTR
	quietly scalar define EMPpopest_spec`k'`specification'_c3 = r(estimate)
	quietly scalar define EMPpopse_spec`k'`specification'_c3 = -r(se)

}




matrix MAIN`k'= [AWW_N_`k'5, AWWestMW_spec`k'5_c2, AWWseMW_spec`k'5_c2,  AWWestMW_spec`k'5_c3, AWWseMW_spec`k'5_c3, 0, EMPestMW_spec`k'5_c2, EMPseMW_spec`k'5_c2, EMPpopest_spec`k'5_c2, EMPpopse_spec`k'5_c2, EMPestMW_spec`k'5_c3, EMPseMW_spec`k'5_c3,EMPpopest_spec`k'5_c3, EMPpopse_spec`k'5_c3,0]

 
matrix A =  [AWW_N_`k'6, AWWestMW_spec`k'6_c2, AWWseMW_spec`k'6_c2,  AWWestMW_spec`k'6_c3, AWWseMW_spec`k'6_c3, 0, EMPestMW_spec`k'6_c2, EMPseMW_spec`k'6_c2, EMPpopest_spec`k'6_c2, EMPpopse_spec`k'6_c2, EMPestMW_spec`k'6_c3, EMPseMW_spec`k'6_c3,EMPpopest_spec`k'6_c3, EMPpopse_spec`k'6_c3,0]

matrix MAIN`k' = MAIN`k'\A

}

log using otherlowwage-industry-results-11-6-09.log, replace

foreach k in rest_limit rest_full ACFS RETAIL ACFSRETAIL MFG {
matrix list MAIN`k'
}
log close



