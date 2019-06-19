**outline of file.
*1) County-Full sample
*2) Cross-state metro analysis
*3) census division effects
*4) county-Full sample w. census division & state linear trends

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
egen absorb_4= group (period censusdiv)

xi: areg lnMW   ,   absorb(county)
predict lnMWR , res

xi: areg lnpop   ,    absorb(county)
predict lnpopR, res 

xi: areg lnemp_TOT   ,    absorb(county)
predict lnemp_TOTR, res 

xi: areg lnAWW_TOT   ,   absorb(county)
predict lnAWW_TOTR, res


*k will loop through industries
*ACFS RETAIL ACFSRETAIL LOWWAGE FIRE MFG rest_limit rest_full

foreach k in rest_both {
set more off
xi: areg lnemp_`k'   ,    absorb(county)
predict lnemp_`k'R, res 

xi: areg lnAWW_`k'   ,   absorb(county)
predict lnAWW_`k'R, res



****** SPEC 1-2 *******

forval specification = 1/3 {

*population controls C2*
quietly xtreg lnAWW_`k'R lnMWR if sample_`specification'==1 & nonmissing_`k'==66 ,  i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c2  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c2 = -r(se)
      quietly scalar define AWW_N_`k'`specification' = e(N)
	

 quietly xtreg lnemp_`k'R lnMWR lnpopR if sample_`specification'==1 & nonmissing_`k'==66, i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c2  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c2 = -r(se)
	quietly lincom lnpopR 
	quietly scalar define EMPpopest_spec`k'`specification'_c2 = r(estimate)
	quietly scalar define EMPpopse_spec`k'`specification'_c2 = -r(se)

* Population & Total Employment Controls C3*
quietly xtreg lnAWW_`k'R lnAWW_TOTR  lnMWR  if sample_`specification'==1 & nonmissing_`k'==66,  i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c3  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c3 = -r(se)
	

 quietly xtreg lnemp_`k'R lnMWR lnemp_TOTR lnpopR if sample_`specification'==1 & nonmissing_`k'==66, i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	quietly lincom lnpopR + lnemp_TOTR
	quietly scalar define EMPpopest_spec`k'`specification'_c3 = r(estimate)
	quietly scalar define EMPpopse_spec`k'`specification'_c3 = -r(se)
}

*SPEC 4 Census division & state linear trends together. 

forval specification = 4/4 {

*population controls
xi: quietly xtreg lnAWW_`k'R lnMWR  i.state_fips*period if sample_`specification'==1 & nonmissing_`k'==66 ,  i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c2  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c2 = -r(se)
	quietly scalar define AWW_N_`k'`specification' = e(N)

xi: quietly xtreg lnemp_`k'R lnMWR lnpopR i.state_fips*period if sample_`specification'==1 & nonmissing_`k'==66, i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c2  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c2 = -r(se)
  	quietly lincom lnpopR 
	quietly scalar define EMPpopest_spec`k'`specification'_c2 = r(estimate)
	quietly scalar define EMPpopse_spec`k'`specification'_c2 = -r(se)

* Population & Total Employment Controls C3*
xi: quietly xtreg lnAWW_`k'R lnAWW_TOTR  lnMWR  i.state_fips*period if sample_`specification'==1 & nonmissing_`k'==66,  i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define AWWestMW_spec`k'`specification'_c3  = r(estimate) 
 	quietly scalar define AWWseMW_spec`k'`specification'_c3 = -r(se)
	
xi: quietly xtreg lnemp_`k'R lnMWR lnemp_TOTR lnpopR i.state_fips*period if sample_`specification'==1 & nonmissing_`k'==66, i(absorb_`specification') cluster(state_fips) fe nonest
      quietly lincom lnMWR
	quietly scalar define EMPestMW_spec`k'`specification'_c3  = r(estimate)  
 	quietly scalar define EMPseMW_spec`k'`specification'_c3 = -r(se)
	quietly lincom lnpopR + lnemp_TOTR
	quietly scalar define EMPpopest_spec`k'`specification'_c3 = r(estimate)
	quietly scalar define EMPpopse_spec`k'`specification'_c3 = -r(se)

}
  
matrix MAIN`k' = [AWW_N_`k'1, AWWestMW_spec`k'1_c2, AWWseMW_spec`k'1_c2,  AWWestMW_spec`k'1_c3, AWWseMW_spec`k'1_c3, 0, EMPestMW_spec`k'1_c2, EMPseMW_spec`k'1_c2, EMPpopest_spec`k'1_c2, EMPpopse_spec`k'1_c2, EMPestMW_spec`k'1_c3, EMPseMW_spec`k'1_c3,EMPpopest_spec`k'1_c3, EMPpopse_spec`k'1_c3,0]
  
forval j= 2/4 {
 matrix A =  [AWW_N_`k'`j',  AWWestMW_spec`k'`j'_c2, AWWseMW_spec`k'`j'_c2, AWWestMW_spec`k'`j'_c3, AWWseMW_spec`k'`j'_c3, 0, EMPestMW_spec`k'`j'_c2, EMPseMW_spec`k'`j'_c2, EMPpopest_spec`k'`j'_c2, EMPpopse_spec`k'`j'_c2, EMPestMW_spec`k'`j'_c3, EMPseMW_spec`k'`j'_c3,EMPpopest_spec`k'`j'_c3, EMPpopse_spec`k'`j'_c3,0]
 
 matrix MAIN`k'= MAIN`k'\A
}
}
 


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

foreach k in rest_both  {

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


matrix A= [AWW_N_`k'5, AWWestMW_spec`k'5_c2, AWWseMW_spec`k'5_c2,  AWWestMW_spec`k'5_c3, AWWseMW_spec`k'5_c3, 0, EMPestMW_spec`k'5_c2, EMPseMW_spec`k'5_c2, EMPpopest_spec`k'5_c2, EMPpopse_spec`k'5_c2, EMPestMW_spec`k'5_c3, EMPseMW_spec`k'5_c3,EMPpopest_spec`k'5_c3, EMPpopse_spec`k'5_c3,0]

matrix MAIN`k' = MAIN`k'\A
  
matrix A =  [AWW_N_`k'6, AWWestMW_spec`k'6_c2, AWWseMW_spec`k'6_c2,  AWWestMW_spec`k'6_c3, AWWseMW_spec`k'6_c3, 0, EMPestMW_spec`k'6_c2, EMPseMW_spec`k'6_c2, EMPpopest_spec`k'6_c2, EMPpopse_spec`k'6_c2, EMPestMW_spec`k'6_c3, EMPseMW_spec`k'6_c3,EMPpopest_spec`k'6_c3, EMPpopse_spec`k'6_c3,0]

matrix MAIN`k' = MAIN`k'\A

}

log using main-industry-results-11-5-09.log, replace
*rest_limit rest_full
foreach k in rest_both  {
matrix list MAIN`k'
}
log close



