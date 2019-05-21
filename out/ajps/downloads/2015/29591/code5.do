version 13.1
clear all
set more off

local var "turnout support_left2 support_right2 support_left"
foreach x of local var{
cd "/Users/hangartn/Dropbox/Compulsory Voting (Analysis and Papers)/01 Diff mob/Replication Archive"

use data1.dta, replace
svyset  [pweight=weight]

gen period = .
replace period = 1 if inrange(year, 1908,1918)
replace period = 2 if inrange(year, 1919,1924)
replace period = 3 if inrange(year, 1925,1932)
replace period = 4 if inrange(year, 1933,1940)
replace period = 5 if inrange(year, 1946,1948)

bysort anr: egen mean_pop_vd = mean(ber) if knum==22
bysort anr bnum: gen weight_vd= ber/mean_pop_vd if  knum==22

matrix beta1=J(5,1,.)
matrix beta_cov1=J(5,1,.)
matrix beta2=J(5,1,.)
matrix beta_cov2=J(5,1,.)

forvalues i=1(1)5{
reg `x' [pweight=weight_vd] if knum==22 & period==`i', cluster(bnum)
matrix beta1[`i',1]=e(b)  
matrix beta_cov1[`i',1]=e(V) 
reg `x' [pweight=weight] if knum!=22 & period==`i', cluster(bnum)
matrix beta2[`i',1]=e(b)  
matrix beta_cov2[`i',1]=e(V) 
}
	
svmat beta1, names(beta1)
svmat beta_cov1, names(beta_cov1)
svmat beta2, names(beta2)
svmat beta_cov2, names(beta_cov2)

keep if beta1!=.
keep period beta11 beta_cov11 beta21 beta_cov21

saveold fig1_`x'.dta, replace

drop beta*
}
