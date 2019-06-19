clear all
set mem 4g
set matsize 11000
set maxvar 11000

   
use QCEWindustry_minwage_contig.dta, clear
keep if period>=25 & period<=90


sort pair_id period county

foreach x in "lnMW" "lnemp_TOT" "lnemp_rest_both"  "lnAWW_TOT" "lnAWW_rest_both"  "cntyarea" "lnpop" "nonmissing_rest_both" "state_fips"  {

  gen `x'_pairother = `x'[_n-1] if pair_id== pair_id[_n-1] & period==period[_n-1] & county!= county[_n-1]
  replace `x'_pairother = `x'[_n+1] if pair_id== pair_id[_n+1] & period==period[_n+1] & county!= county[_n-1]

}

gen mweqfedmw = (minwage==federalmin)
egen counterfactual_sample = min(mweqfedmw), by(pair_id_county)
keep if counterfactual_sample==1  

tsset pair_id_county period
  
 
 xi:   qui areg lnAWW_rest_both_pairother lnMW_pairother  lnAWW_TOT_pairother lnemp_TOT_pairother lnpop_pairother i.period  if  nonmissing_rest_both_pairother ==66 & cntyarea_pairother<2000   , cluster(state_fips) absorb(county) 
		mat mat_earn = [_b[lnMW_pairother]\_se[lnMW_pairother]] 
 xi:   qui areg lnAWW_rest_both  lnMW_pairother  lnAWW_TOT lnpop lnemp_TOT     i.period  if  nonmissing_rest_both_pairother ==66  & cntyarea <2000    , cluster(state_fips) absorb(county) 
		mat mat_earn = [mat_earn \ [_b[lnMW_pairother]\_se[lnMW_pairother]] ]
 
 xi:   qui areg lnemp_rest_both_pairother lnMW_pairother lnpop_pairother lnemp_TOT_pairother  i.period  if     nonmissing_rest_both_pairother ==66 & cntyarea_pairother <2000  , cluster(state_fips) absorb(county) 
 		mat mat_emp = [_b[lnMW_pairother]\_se[lnMW_pairother]]   
 xi:   qui areg lnemp_rest_both  lnMW_pairother lnpop  lnemp_TOT   i.period  if    cntyarea<2000 & nonmissing_rest_both==66, cluster(state_fips) absorb(county) 
 		mat mat_emp = [ mat_emp \ [_b[lnMW_pairother]\_se[lnMW_pairother]] ]

mat fullmat = [mat_earn, mat_emp]
mat list fullmat
 
 
