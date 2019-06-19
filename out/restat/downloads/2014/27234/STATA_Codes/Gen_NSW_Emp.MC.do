** This program generated the data sets for EMPIRICAL MONTE CARLO (Section 3)
** based on Busso, DiNardo, McCrary (RESTAT, forthcoming)

pr drop _all
clear
set more off
 
** Bad Overlap
cd "/working_dir/"

run nswdgp.ado
set seed 12345678

quietly {
local i=1
while `i'<=5000{
nswdgp2, k(1) replicas(1) post
*k(1) bad overlap k(5) good overlap

logit T age educ dropout married unempl74 unempl75 earn74 earn74sq earn75 earn75sq unempl74_unempl75 earn74_earn75, iterate(50) asis
predict ps

*We set the sample size in N=400 to see performance in finite sample
sample 400, count
outsheet using NSW-EMP1_`i'.raw, replace
local i=`i'+1

}
}



** Good Overlap
cd "~/working_dir/"
set seed 12345678

quietly {
local i=1
while `i'<=5000{
nswdgp2, k(5) replicas(1) post

logit T age educ dropout married unempl74 unempl75 earn74 earn74sq earn75 earn75sq unempl74_unempl75 earn74_earn75, iterate(50) asis
predict ps

*We set sample size in N=400
sample 400, count
outsheet using NSW-EMP2_`i'.raw, replace
local i=`i'+1

}
}




