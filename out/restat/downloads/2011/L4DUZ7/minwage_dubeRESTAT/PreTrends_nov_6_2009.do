 
clear
set mem 3g
set matsize 11000
set maxvar 11000

 
use QCEWindustry_minwage_all.dta

************   residual leads/lags ***********

tsset countyreal period
 
forval j = 2(2)16 {
 
	gen lnMW_l`j' =  L`j'.lnMW 
       
      gen lnMW_f`j' = F`j'.lnMW 
     
} 


 
gen lnMW_l0 = lnMW

gen sampleperiod = (year>=1990 & (year<2006) | (year ==2006 & quarter<3) )

keep if nonmissing_rest_both==66

forval j = 2(2)16 {
 
      xi: qui areg lnMW_l`j' if sampleperiod  ,  absorb(countyreal)
      predict lnMWR_l`j', res
      xi: qui areg lnMW_f`j' if sampleperiod  ,  absorb(countyreal)
      predict lnMWR_f`j', res       
    
} 

*****************************

local varlist1 "lnemp_rest_both lnAWW_rest_both lnemp_TOT lnpop  lnMW   lnAWW_TOT "

foreach var of local varlist1 {

cap drop `var'R
   
xi: qui areg `var' if sampleperiod , absorb(countyreal)
predict `var'R, res

}

 

********   specifications 1 and 2  ****
* spec 1 = all counties     		  *
* spec 2 = cross-state metro		  *
*  						  *
***************************************

gen all=1
egen stperiod = group(state_fips period)

gen sample_1 = (all==1)
gen sample_2 = (sample_flag==2)
 

gen absorb_1 = period
egen absorb_2 = group(period cbmsa)

local MWleads "lnMWR_f12 lnMWR_f4 lnMWR"
local varlist2 "lnemp_rest_both   lnemp_TOT"
local varlist3 "lnemp_rest_both   lnemp_TOT lnAWW_rest_both   lnAWW_TOT" 

 
set more off
foreach depvar of local varlist3 {

	xi: areg `depvar'R  `MWleads' lnpopR  ,  cluster(state_fips)   a(absorb_1) 
	
	scalar N_`depvar'_s1 = e(N)	

  	lincom lnMWR_f12
	scalar est_`depvar'_s1_f12 = r(estimate)
	scalar se_`depvar'_s1_f12 = r(se)

	lincom lnMWR_f12 + lnMWR_f4
	scalar est_`depvar'_s1_f4 = r(estimate)
	scalar se_`depvar'_s1_f4 = r(se)

	lincom lnMWR_f4
	scalar est_`depvar'_s1_trend = r(estimate)
	scalar se_`depvar'_s1_trend = r(se)
		
	***

	xi: areg `depvar'R  `MWleads' lnpopR  ,  cluster(state_fips)   a(absorb_2)

	scalar N_`depvar'_s2 = e(N)	

  	lincom lnMWR_f12
	scalar est_`depvar'_s2_f12 = r(estimate)
	scalar se_`depvar'_s2_f12 = r(se)

	lincom lnMWR_f12 + lnMWR_f4
	scalar est_`depvar'_s2_f4 = r(estimate)
	scalar se_`depvar'_s2_f4 = r(se)

	lincom lnMWR_f4
	scalar est_`depvar'_s2_trend = r(estimate)
	scalar se_`depvar'_s2_trend = r(se)

}

local varlist3 "lnemp_rest_both  lnemp_TOT lnAWW_rest_both  lnAWW_TOT" 

#delimit ;

 
foreach depvar of local varlist3 { ;
	
	matrix est_`depvar' = 	[est_`depvar'_s1_f12 \ -se_`depvar'_s1_f12 \
					est_`depvar'_s1_f4 \ -se_`depvar'_s1_f4 \
					est_`depvar'_s1_trend \ -se_`depvar'_s1_trend \ N_`depvar'_s1 \ 
					est_`depvar'_s2_f12 \ -se_`depvar'_s2_f12\ 
					est_`depvar'_s2_f4 \ -se_`depvar'_s2_f4 \ 
					est_`depvar'_s2_trend \ -se_`depvar'_s2_trend \ N_`depvar'_s2 ];
    	if "`depvar'" == "lnemp_rest_both" {;
	matrix mymat = [est_`depvar'] ;
	};
	else {;
	matrix mymat = [mymat, est_`depvar'] ;
	};
};

#delimit cr

 


*********************** CONTIGUOUS COUNTIES *****************************************

drop _all


set more off
 
use QCEWindustry_minwage_contig.dta

************   residual leads/lags ***********

tsset pair_id_county period
 
forval j = 2(2)16 {
 
	gen lnMW_l`j' =  L`j'.lnMW 
       
      gen lnMW_f`j' = F`j'.lnMW 
     
} 


 
gen lnMW_l0 = lnMW

gen sampleperiod = (year>=1990 & (year<2006) | (year ==2006 & quarter<3) )

keep if nonmissing_rest_both==66

forval j = 2(2)16 {
 
      xi: qui areg lnMW_l`j' if sampleperiod  ,  absorb(countyreal)
      predict lnMWR_l`j', res
      xi: qui areg lnMW_f`j' if sampleperiod  ,  absorb(countyreal)
      predict lnMWR_f`j', res       
    
} 

*****************************

local varlist1 "lnemp_rest_both lnemp_TOT lnpop lnMW lnAWW_rest_both lnAWW_TOT  "

foreach var of local varlist1 {

cap drop `var'R
   
xi: qui areg `var' if sampleperiod , absorb(countyreal)
predict `var'R, res

}

 

********   specifications 1 and 2  ****
* spec 3 =  contiguous county 	  *
*  						  *
***************************************

  
egen pair_id_num = group(pair_id)

gen sample_3 = 1
egen absorb_3 = group(pair_id period)
egen stperiod = group(state_fips period)

sort  pair_id period
 
gen state_a = real(substr(pair_id, 1,2))
gen state_b = real(substr(pair_id, 7,2))

gen st_min = min( state_a, state_b)
gen st_max = max(state_a, state_b)

egen bordersegment = group(st_min st_max)
egen bordersegmentperiod = group(bordersegment period)

 

tsset pair_id_county period

local MWleads "lnMWR_f12 lnMWR_f4 lnMWR"
local varlist2 "lnemp_rest_both lnemp_TOT"
local varlist3 "lnemp_rest_both   lnemp_TOT lnAWW_rest_both   lnAWW_TOT" 

 



  
set more off
foreach depvar of local varlist3 {

 

	xi: cluster2areg `depvar'R  `MWleads' lnpopR   ,  tcluster(state_fips) fcluster(bordersegment)  a(absorb_3) w(all)

	scalar N_`depvar'_s3 = e(N)	

  	lincom lnMWR_f12
	scalar est_`depvar'_s3_f12 = r(estimate)
	scalar se_`depvar'_s3_f12 = r(se)

	lincom lnMWR_f12 + lnMWR_f4
	scalar est_`depvar'_s3_f4 = r(estimate)
	scalar se_`depvar'_s3_f4 = r(se)

	lincom lnMWR_f4
	scalar est_`depvar'_s3_trend = r(estimate)
	scalar se_`depvar'_s3_trend = r(se)

}

local varlist3 "lnemp_rest_both   lnemp_TOT lnAWW_rest_both  lnAWW_TOT" 

#delimit ;

 
foreach depvar of local varlist3 { ;
	
	matrix est_`depvar' = 	[est_`depvar'_s3_f12 \ -se_`depvar'_s3_f12 \ 
					est_`depvar'_s3_f4 \ -se_`depvar'_s3_f4 \ 
					est_`depvar'_s3_trend \ -se_`depvar'_s3_trend \ N_`depvar'_s3 ];
	
      if "`depvar'" == "lnemp_rest_both" {;
	matrix tempmat = [est_`depvar'] ;
	};
	else {;
	matrix tempmat = [tempmat, est_`depvar'] ;
	};


};

#delimit cr

matrix mymat = mymat\tempmat
matrix list mymat 

 
