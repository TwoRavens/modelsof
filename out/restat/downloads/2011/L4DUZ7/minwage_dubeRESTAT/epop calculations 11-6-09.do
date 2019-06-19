**This file runs our prefered specification for the county-pair sample for the employment / population ratio. 
**THESE RESULTS FEED INTO TABLE 5. 
clear
set mem 1g
set matsize 5000
set maxvar 5000
set more off

cd "C:\Users\Bill\Desktop\REstat Do files"

*********************** CONTIGUOUS COUNTIES *****************************************
set more off

use QCEWindustry_minwage_contig.dta


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

****GENERATING LNEPOP VARIABLES.

gen lnepop_rest_both=ln(emp_rest_both/pop)
xi: areg lnepop   ,  absorb(county)
predict lnepop_rest_bothR , res

**FINDING THE AVERAGE epop_rest_both IN SAMPLE.

gen epop_rest_both=(emp_rest_both/pop)
sum epop_rest_both if sample_3==1 & nonmissing_rest_both==66
sum lnepop_rest_both if sample_3==1 & nonmissing_rest_both==66

*mean=.0243

xi: areg lnMW   ,  absorb(county)
predict lnMWR , res

xi: areg lnemp_TOT   ,    absorb(county)
predict lnemp_TOTR, res 

xi: areg lnAWW_TOT   ,   absorb(county)
predict lnAWW_TOTR, res


foreach k in rest_both {

xi: areg lnAWW_`k', absorb(county)
predict lnAWW_`k'R, res 
 
xi: areg lnemp_`k'   , absorb(county)
predict lnemp_`k'R, res


forval specification = 3/4 {

*population controls 
quietly cluster2areg lnAWW_`k'R lnMWR  if sample_`specification'==1 & nonmissing_`k'==66,  fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c2  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c2 = -r(se)
		quietly scalar define AWW_N_`k'`specification' = e(N)

 quietly cluster2areg lnepop_`k'R lnMWR if sample_`specification'==1 & nonmissing_`k'==66, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR 
	quietly scalar define EMPestMW_spec`k'`specification'_c2  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c2 = -r(se)
	

* Total Employment Controls C3*
quietly cluster2areg lnAWW_`k'R lnAWW_TOTR lnpopR lnMWR  if sample_`specification'==1 & nonmissing_`k'==66,  fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c3  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c3 = -r(se)
	

 quietly cluster2areg lnepop_`k'R lnMWR lnemp_TOTR lnpopR if sample_`specification'==1 & nonmissing_`k'==66, fcluster(state_fips) w(all) tcluster(bordersegment) a(absorb_`specification')
      quietly lincom lnMWR 
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	

}


matrix MAIN`k'= [AWW_N_`k'3, AWWestMW_spec`k'3_c2, AWWseMW_spec`k'3_c2, AWWestMW_spec`k'3_c3, AWWseMW_spec`k'3_c3, 0, EMPestMW_spec`k'3_c2, EMPseMW_spec`k'3_c2, EMPestMW_spec`k'3_c3, EMPseMW_spec`k'3_c3,0]
 
matrix A =  [AWW_N_`k'4, AWWestMW_spec`k'4_c2, AWWseMW_spec`k'4_c2, AWWestMW_spec`k'4_c3, AWWseMW_spec`k'4_c3, 0, EMPestMW_spec`k'4_c2, EMPseMW_spec`k'4_c2, EMPestMW_spec`k'4_c3, EMPseMW_spec`k'4_c3,0]

matrix MAIN`k' = MAIN`k'\A

}

log using epop-results-11-6.log, replace
*rest_limit rest_full
foreach k in rest_both  {
matrix list MAIN`k'
}
log close



