// Creates figure in section "analysis of key votes"
//
// Step 1: estimate impact of u membership and concentration
// on key votes in 11th Congress
// creates file: Figure_III_est.dta
//


set seed 132456

// program to calc quantities of interest:
// effect of (1) SD increase in $u, (2) SD decrease in $uc
// on probability of vote, expressed in percentage points
prog qi, rclass
	est sto mod
	qui sum U_logmemb, d
	qui local val1 = `r(mean)'
	qui local val2 = `r(mean)' + `r(sd)'
	qui margins, at(U_logmemb=`val1') at(U_logmemb=`val2') predict(pr) post
	lincom (_b[2._at] - _b[1bn._at])*100
	return local b_u = r(estimate)
	return local se_u = r(se)
	qui est rest mod
	qui sum U_membcr4, d
	qui local val1 = `r(mean)'
	qui local val2 = `r(mean)'-`r(sd)'
	qui margins, at(U_membcr4=`val1') at(U_membcr4=`val2') predict(pr) post
	lincom (_b[2._at] - _b[1bn._at])*100
	return local b_uc = r(estimate)
	return local se_uc = r(se)
end

use ../Data/data_D, clear
keep if congress==111
merge 1:1 statefip cd using ../Data/afl-cio-voting/keyvotes111
drop _merge
xtset statefip


// Loop and save estimates and SE to file
postfile pf str10 voteid float b_u se_u b_uc se_uc using Figure_III_est, replace
foreach v of varlist v2009_1 - v2010_14 {
	qui xtlogit `v' A_median_income A_white A_BA_or_higher A_service /// 
	U_logmemb U_membcr4, vce(clu statefip) intp(15)
	qi
	post pf ("`v'") (`r(b_u)') (`r(se_u)') (`r(b_uc)') (`r(se_uc)')
}
postclose pf

