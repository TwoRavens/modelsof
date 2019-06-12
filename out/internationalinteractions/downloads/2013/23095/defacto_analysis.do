******************************************************************************************
* Unionization and the Political Economy of Restrictions on Foreign Direct Investment
* Erica Owen
* International International Replication 
* Analysis of De facto Barriers 
******************************************************************************************

use "/defacto_data.dta"
	
gen skillintensity = ((emp-prode)/prode)
gen wageavg=(pay*1000)/emp
gen realavgwage = wageavg/cpi

* Estimate de facto dependent variable: Foreign capital contribution to Value Added"

reg vaddbil posbil
predict fava if e(sample), xb
gen lnfava=ln(fava)
* Recreate Table 3 in Text

global dv lnfava

xtpcse $dv union skillintensity realavgwage emp , corr(ar1) pairwise
estimates store modelin1
xtpcse $dv union skillintensity realavgwage emp collected_duties, corr(ar1) pairwise
estimates store modelin2
xtpcse $dv union skillintensity realavgwage emp collected_duties lnoutpos , corr(ar1) pairwise
estimates store modelin3
xtpcse $dv union skillintensity realavgwage emp collected_duties lnoutpos dtfp4 , corr(ar1) pairwise
estimates store modelin4
xtpcse $dv union skillintensity realavgwage emp collected_duties lnoutpos dempres, corr(ar1) pairwise
estimates store modelin5
reg $dv union skillintensity realavgwage emp collected_duties lnoutpos  conc , cluster(cic2002)
estimates store modelin6


