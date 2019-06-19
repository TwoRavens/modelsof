 
 

*********************************************county full sample*********************************
clear
set mem 3g
set matsize 11000
set maxvar 11000
set more off

use QCEWindustry_minwage_all.dta




************   residual leads/lags ***********

tsset countyreal period
 
forval j = 2(2)14 {
 
	gen lnMW_l`j' = S2.L`j'.lnMW 
      if `j' < 10 {
         gen lnMW_f`j' = S2.F`j'.lnMW 
       }
} 


gen lnMW_l16 = L16.lnMW
gen lnMW_l0 = S2.lnMW

gen sampleperiod = (year>=1990 & (year<2006) | (year ==2006 & quarter<3) )


forval j = 2(2)14 {
 
      xi: areg lnMW_l`j' if sampleperiod  , cluster(state_fips) absorb(countyreal)
      predict lnMWR_l`j', res
      if `j' < 10 {
         xi: areg lnMW_f`j' if sampleperiod  , cluster(state_fips) absorb(countyreal)
         predict lnMWR_f`j', res       
     }
} 

 

xi: areg lnMW_l16 if sampleperiod  , cluster(state_fips) absorb(countyreal)
      predict lnMWR_l16, res

xi: areg lnMW_l0 if sampleperiod  , cluster(state_fips) absorb(countyreal)
      predict lnMWR_l0, res


*****************************
 
  
xi: areg lnemp_rest_both if sampleperiod  , cluster(state_fips) absorb(countyreal)
predict lnemp_rest_bothR, res

xi: areg lnAWW_rest_both  if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnwage_rest_bothR, res



xi: areg lnemp_TOT  if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnemp_TOTR, res

xi: areg lnAWW_TOT  if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnwage_TOTR, res


xi: areg lnMW if sampleperiod  , cluster(state_fips) absorb(countyreal)
predict lnMWR , res

xi:  areg lnpop  if sampleperiod  ,    absorb(county)
predict lnpopR, res
 



 


 

********   specifications 1-4  ****
* spec 1 = all counties; spec2 = metro counties; spec 3 = metro+censusdiv; 
*     spec 4 = cross-state metro
* estMW = lnMW; estMWH = lnMW_HF; estMWL = lnMW_LF
*********

gen all=1
egen stperiod = group(state_fips period)

gen sample_1 = (all==1)
gen sample_2 = (sample_flag>0)
gen sample_3 = (sample_flag>0)
gen sample_4 = (sample_flag==2)

gen absorb_1 = period
gen absorb_2 = period
egen absorb_3 = group(period censusdiv)
egen absorb_4 = group(period cbmsa)

 


****** SPEC 1-4 *******


 
 
set more off

  xi: areg lnwage_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnwage_TOTR    if nonmissing_rest_both ==66    ,  cluster(state_fips)   a(absorb_1) 

mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est1_wage_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

  xi: areg lnwage_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnwage_TOTR    if nonmissing_rest_both ==66    ,  cluster(state_fips)   a(absorb_3) 

mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est2_wage_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

  xi: areg lnwage_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnwage_TOTR    i.state_fips*period if nonmissing_rest_both ==66    ,  cluster(state_fips)   a(absorb_3) 

mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est2b_wage_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

  xi: areg lnwage_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnwage_TOTR     if nonmissing_rest_both ==66    ,   cluster(state_fips)    a(absorb_4) 

mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est2c_wage_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

 



  xi: areg lnemp_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnemp_TOTR lnpopR  if nonmissing_rest_both ==66    ,  cluster(state_fips)   a(absorb_1) 

mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est1_emp_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

  xi: areg lnemp_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnemp_TOTR lnpopR  if nonmissing_rest_both ==66    ,  cluster(state_fips)   a(absorb_3) 
 
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est2_emp_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}


  xi: areg lnemp_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnemp_TOTR lnpopR i.state_fips*period if nonmissing_rest_both ==66    ,  cluster(state_fips)   a(absorb_3) 
 
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est2b_emp_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

  xi:  areg lnemp_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnemp_TOTR lnpopR   if nonmissing_rest_both ==66    ,   cluster(state_fips)    a(absorb_4) 
 
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est2c_emp_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

 

set more off

matrix fullmat = [est1_wage_1, est2_wage_1, est2b_wage_1, est2c_wage_1, est1_emp_1, est2_emp_1, est2b_emp_1 , est2c_emp_1] 

forval j = 2/13 {

 matrix fullmat = [fullmat\  [est1_wage_`j', est2_wage_`j', est2b_wage_`j', est2c_wage_`j', est1_emp_`j', est2_emp_`j', est2b_emp_`j', est2c_emp_`j' ]]
}

matrix list fullmat

 

*********************** CONTIGUOUS COUNTIES *****************************************

drop _all
 
use QCEWindustry_minwage_contig.dta

/*****  FIGURE 3 - DESCRIPTIVE *********/


/* number of counties with minimum wage gaps */

gen numpairstosum = 1/8 if year<2006
replace numpairstosum = 1/4 if year==2006

table year if lnMW_dif_period==1 & nonmissing_rest_both ==66   , c(sum numpairstosum) 

 
 
* mean minimum wage gap in counties with gap */
table year if lnMW_dif_period==1 & year<2007 & year>=1990 & nonmissing_rest_both==66     , c(mean lnMW_gap_pair )
 

 


************   residual leads/lags ***********

tsset pair_id_county period


 
forval j = 2(2)14 {
 
	gen lnMW_l`j' = S2.L`j'.lnMW 
      if `j' < 10 {
         gen lnMW_f`j' = S2.F`j'.lnMW 
       }
} 


gen lnMW_l16 = L16.lnMW
gen lnMW_l0 = S2.lnMW

gen sampleperiod = (year>=1990 & (year<2006) | (year ==2006 & quarter<3) )


forval j = 2(2)14 {
 
      xi: areg lnMW_l`j' if sampleperiod  , cluster(state_fips) absorb(countyreal)
      predict lnMWR_l`j', res
      if `j' < 10 {
         xi: areg lnMW_f`j' if sampleperiod  , cluster(state_fips) absorb(countyreal)
         predict lnMWR_f`j', res       
     }
} 

 

xi: areg lnMW_l16 if sampleperiod  , cluster(state_fips) absorb(countyreal)
      predict lnMWR_l16, res

xi: areg lnMW_l0 if sampleperiod  , cluster(state_fips) absorb(countyreal)
      predict lnMWR_l0, res


*****************************
 
  
xi: areg lnemp_rest_both if sampleperiod  , cluster(state_fips) absorb(countyreal)
predict lnemp_rest_bothR, res

xi: areg lnemp_TOT  if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnemp_TOTR, res

xi: areg lnMW if sampleperiod  , cluster(state_fips) absorb(countyreal)
predict lnMWR , res

xi:  areg lnpop  if sampleperiod  ,    absorb(county)
predict lnpopR, res
 


xi: areg lnAWW_TOT  if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnwage_TOTR, res

xi: areg lnAWW_RET  if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnwage_retR, res

xi: areg lnAWW_rest_both if sampleperiod , cluster(state_fips) absorb(countyreal)
predict lnwage_rest_bothR, res


foreach j in lnwage_rest_bothR lnwage_TOTR lnemp_rest_bothR lnemp_TOTR lnpopR lnMWR {
 xi: qui areg `j' if nonmissing_rest_both==66, a(pair_id_period)
 predict `j'R, res
}

 
egen pair_id_num = group(pair_id)
 

tsset pair_id_county period

 

 
gen sample_5 = 1
egen absorb_5 = group(pair_id period)
egen stperiod = group(state_fips period)

sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)

egen bordersegment = group(st_min st_max)

egen bordersegmentperiod = group(bordersegment period)

gen lnMWfed = ln(federalmin)
gen statemin_2 = federalmin
replace statemin_2 = stminwage if   stminwage> federalmin & stminwage!=.

 
gen lnMW_st = max(ln(federalmin), ln(statemin_2)) 

gen lnMWst = ln( stminwage)


tsset pair_id_county period

  
 
gen lnemp_TOTR_popR = lnemp_TOTR - lnpopR

gen lnemp_TOT_pop = exp(lnemp_TOTR_popR)


*

xi: cluster2areg lnemp_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnemp_TOTR lnpopR  if nonmissing_rest_both ==66   , w(all) tcluster(bordersegment) fcluster(state_fips) a(period)  
 
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est3_emp_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

xi: cluster2areg lnemp_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnemp_TOTR lnpopR  if nonmissing_rest_both ==66    , w(all) tcluster(bordersegment) fcluster(state_fips) a(pair_id_period)   
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est4_emp_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}
 

xi: cluster2areg lnwage_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnwage_TOTR    if nonmissing_rest_both ==66    , w(all) tcluster(bordersegment) fcluster(state_fips) a(period)  
 
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est3_wage_`j' = [B[1,`j'], -sqrt(V[`j',`j'])]
}

xi: cluster2areg lnwage_rest_bothR lnMWR_f8 lnMWR_f6 lnMWR_f4 lnMWR_f2 lnMWR_l0 lnMWR_l2 lnMWR_l4 lnMWR_l6 lnMWR_l8 lnMWR_l10 lnMWR_l12 lnMWR_l14 lnMWR_l16 lnwage_TOTR   if nonmissing_rest_both ==66   , w(all) tcluster(bordersegment) fcluster(state_fips) a(pair_id_period)   
mat B = e(b)
mat V = e(V)
forval j = 1/13 {
	mat est4_wage_`j' = [B[1,`j'],  -sqrt(V[`j',`j'])]
}
 

matrix fullmat2 = [est3_wage_1, est4_wage_1, est3_emp_1, est4_emp_1 ] 

forval j = 2/13 {

 matrix fullmat2 = [fullmat2\  [est3_wage_`j', est4_wage_`j', est3_emp_`j', est4_emp_`j' ]]
}

matrix list fullmat2



 
********************* Individual Border Segments ***********************

egen pair_id_real1 = group(pair_id) if lnMW_dif>0
replace pair_id_real1 = . if nonmissing_rest_both!=66

egen count1 = count(pair_id_real1), by(pair_id period)

replace pair_id_real1 = . if count1!=2

egen pair_id_real = group(pair_id_real1)

 

gen bordersegment1 = bordersegment if pair_id_real!=.  
replace bordersegment1 = . if nonmissing_rest_both!=66 | lnMW_dif!=1

 
cap drop bordersegment2
egen bordersegment2 = group(bordersegment1) if bordersegment1!=.



sum bordersegment2

 qui cap  areg lnemp_rest_bothR lnMWR lnpopR lnemp_TOTR if bordersegment2==1  , a(pair_id_period)
  	matrix B = e(b)
	scalar x = B[1,1]
	matrix betamat = [1, x]
 
 
forval j=2/64 {
 display  `j' 
 qui cap  areg lnemp_rest_bothR lnMWR lnpopR lnemp_TOTR if bordersegment2==`j'  , a(pair_id_period)
  	matrix B = e(b)
	scalar x = B[1,1]
	matrix betamat = [betamat\[`j', x]]  
}




tempfile mydata
save "`mydata'"

drop _all

svmat betamat
rename betamat1 bordersegment 
rename  betamat2 beta


twoway (kdensity beta   , w(.1) lwidth(thick) xline(0.05) xline(-0.21) xline(.17)  xline(0.34)  ytitle(Density) xtitle(Elasticity) )

twoway (kdensity beta   , w(.1)  lwidth(thick)  xline(0.20) xline(-0.00)   ytitle(Density) xtitle(Elasticity) )


 



 
