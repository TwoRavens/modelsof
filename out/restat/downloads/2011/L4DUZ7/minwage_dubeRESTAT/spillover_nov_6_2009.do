 

clear
set mem 3g
set matsize 11000
set maxvar 11000
 
************ SET UP DATA AND MERGE INTERIOR VALUES *******************
  
use QCEWindustry_minwage_contig.dta , clear
drop if period>90 | period<25
 
*** Renumber periods to go from 1 to 66 - matching interior average dataset ****
replace period = period - 24

*** Recode San Francisco to be same "state_fips" as rest of CA ***
replace state_fips=6 if countyreal==6075

sort state_fips period

merge state_fips period using interior_state_ave.dta

 egen tot = sum(all), by(pair_id_county)
 drop if tot!=66


 
 
************** CALCULATE WITHIN COUNTY RESIDUALS *******************
set more off
 

*** MINIMUM WAGE VAR ***

areg lnMW   , absorb(county)
predict lnMWR , res


**** OWN OUTCOMES *****

areg lnemp_rest_both   ,   absorb(county)
predict lnemp_rest_bothR, res

areg lnemp_TOT   , cluster(state_fips) absorb(county)
predict lnemp_TOTR, res

areg lnAWW_rest_both   ,   absorb(county)
predict lnAWW_rest_bothR, res

areg lnAWW_TOT   ,   absorb(county)
predict lnAWW_TOTR, res

areg lnpop    ,   absorb(county)
predict lnpopR , res


**** STATE INTERIOR OUTCOMES ****

areg ln_emp_rest_both_INT   ,   absorb(county)
predict lnemp_rest_bothR_INT, res

areg ln_AWW_rest_both_INT   ,   absorb(county)
predict lnAWW_rest_bothR_INT, res

areg ln_emp_TOT   ,   absorb(county)
predict lnemp_TOTR_INT, res

areg ln_AWW_TOT_INT   ,   absorb(county)
predict lnAWW_TOTR_INT, res

areg lnpop_INT   ,   absorb(county)
predict lnpopR_INT, res



**************  GENERATE DIFFERENCE BETWEEN OWN AND INTERIOR RESIDUALS ***************

gen  lnAWW_rest_bothR_pairdif2_INT = (lnAWW_rest_bothR - lnAWW_rest_bothR_INT)  
gen  lnAWW_TOTR_pairdif2_INT = (lnAWW_TOTR - lnAWW_TOTR_INT)  

gen  lnemp_rest_bothR_pairdif2_INT = (lnemp_rest_bothR - lnemp_rest_bothR_INT)  
gen  lnemp_TOTR_pairdif2_INT = (lnemp_TOTR - lnemp_TOTR_INT)  

gen  lnpopR_pairdif2_INT = (lnpopR - lnpopR_INT)  


************************************************************************************* 
 
 
 

**** SET DATA AS PANEL, AND SET TIME CONTROL ***
 
tsset pair_id_county period
egen absorb_5 = group(pair_id period)
 
 

***   MAKE BORDER SEGMENTS ******
sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)
egen bordersegment = group(st_min st_max)

*********************************


*** CREATE ESTIMATION SAMPLE FLAG THAT HAVE VARIATION FOR ALL SPECS ***
 
cap drop sampemp

 
quietly  areg lnemp_rest_bothR_INT lnMWR   lnemp_TOTR_INT lnpopR_INT  if nonmissing_rest_both==66  ,    a(absorb_5)  cluster(bordersegment)
gen sampemp=1 if e(sample)


*** MAIN ESTIMATES - EMPLOYMENT ***

cluster2areg lnemp_rest_bothR lnMWR  lnemp_TOTR  lnpopR   if nonmissing_rest_both==66 & sampemp==1 ,  w(all) a(absorb_5) tcluster(bordersegment) fcluster(state_fips)
      quietly lincom lnMWR
	quietly scalar define estMW_spec_1_emp  = r(estimate)  
	quietly scalar define seMW_spec_1_emp = -r(se)
	quietly scalar define N_spec_1_emp = e(N)
 
 
cluster2areg lnemp_rest_bothR_INT lnMWR   lnemp_TOTR_INT lnpopR_INT if nonmissing_rest_both==66 & sampemp==1    ,  w(all) a(absorb_5) tcluster(bordersegment) fcluster(state_fips)
      quietly lincom lnMWR
	quietly scalar define estMW_spec_2_emp= r(estimate)  
	quietly scalar define seMW_spec_2_emp= -r(se)
      quietly scalar define N_spec_2_emp = e(N)
 
 
  

cluster2areg lnemp_rest_bothR_pairdif2_INT lnMWR   lnemp_TOTR_pairdif2_INT  lnpopR_pairdif2_INT if nonmissing_rest_both==66 & sampemp==1   ,  a(absorb_5) tcluster(bordersegment) fcluster(state_fips) w(all)      
      quietly lincom lnMWR
	quietly scalar define estMW_spec_3_emp = r(estimate)  
	quietly scalar define seMW_spec_3_emp = -r(se)
	quietly scalar define N_spec_3_emp = e(N)
 
forval j =1/3  {
  foreach k  in "emp"  {
 matrix estseMW_`j'_`k' = [estMW_spec_`j'_`k' \ seMW_spec_`j'_`k'\N_spec_`j'_emp]
 }
}

 
 

matrix fullmat = [estseMW_1_emp, estseMW_2_emp,estseMW_3_emp ]

matrix list fullmat




******* MAIN ESTIMATES EARNINGS ***********

cluster2areg lnAWW_rest_bothR lnMWR  lnAWW_TOTR  if sampemp==1   , w(all) a(absorb_5) tcluster(bordersegment) fcluster(state_fips) 
      quietly lincom lnMWR
	quietly scalar define estMW_spec_1_AWW  = r(estimate)  
	quietly scalar define seMW_spec_1_AWW = -r(se)


 
cluster2areg lnAWW_rest_bothR_INT lnMWR   lnAWW_TOTR_INT   if sampemp==1     ,  w(all) a(absorb_5) tcluster(bordersegment) fcluster(state_fips)      
	quietly lincom lnMWR
	quietly scalar define estMW_spec_2_AWW= r(estimate)  
	quietly scalar define seMW_spec_2_AWW= -r(se)
      capture drop sampAWW
	gen sampAWW = 1 if e(sample)   

 
 
cluster2areg lnAWW_rest_bothR_pairdif2_INT lnMWR   lnAWW_TOTR_pairdif2_INT   if sampemp==1     , a(absorb_5) tcluster(bordersegment) fcluster(state_fips) w(all)      
	quietly lincom lnMWR
	quietly scalar define estMW_spec_3_AWW = r(estimate)  
	quietly scalar define seMW_spec_3_AWW = -r(se)

 
forval j =1/3  {
  foreach k  in "AWW"  {
 matrix estseMW_`j'_`k' = [estMW_spec_`j'_`k' \ seMW_spec_`j'_`k']
 }
}

 
 

matrix fullmat2 = [estseMW_1_AWW, estseMW_2_AWW,estseMW_3_AWW   ]

matrix list fullmat2


*************

 
