// set directory

set more off

use analysis, clear

// Model (1) - bivariate

logit dtrust dlisten if qc5==1, r cluster(ea_code)

// Model (2) & (3) - full

logit dtrust aware* dbenefit vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code)

logit dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code)


// Model (4) - multilevel 

melogit dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1, || ea_code:, vce(cluster ea_code)


// Model (5) - Selection bias

heckprob dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc4==1 & z7a!=2 & z7a!=4, select(stay=age asset migrant edu) r cluster(ea_code_07)


// Model (6) - Simultaneous bias

// ivprobit dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1) if qc5==1, twostep first

ivprobit dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1 visit) if qc5==1, twostep first
rivtest

ivregress 2sls dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1 visit) if qc5==1
estat endog
estat overid
estat firststage

ivregress 2sls dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1 visit) if qc5==1, vce(robust)
estat endog
estat overid
estat firststage



// Model (7) - public goods and other controls

logit dtrust dlisten aware* dmarket droad dwater dhealth dedu vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code)


// Models (8) & (9) - multinomial logit

drop dtrust
gen dtrust=.
replace dtrust=4 if trust07==2 & trust08==1
replace dtrust=3 if trust07==1 & trust08==1
replace dtrust=2 if trust07==2 & trust08==2
replace dtrust=1 if trust07==1 & trust08==2

mlogit dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code) base(2)

mlogit dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code) base(3)




// Online Appendix 



// Keeping only two groups (benchmark: remaining mistrust)

use analysis, clear

drop dtrust
gen dtrust=.
replace dtrust=4 if trust07==2 & trust08==1
replace dtrust=3 if trust07==1 & trust08==1
replace dtrust=2 if trust07==2 & trust08==2
replace dtrust=1 if trust07==1 & trust08==2

drop if dtrust==3 | dtrust==1
replace dtrust=1 if dtrust==4
replace dtrust=0 if dtrust==2

heckprob dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc4==1 & z7a!=2 & z7a!=4, select(stay=age asset migrant edu) r cluster(ea_code_07)



// Model (6) - Simultaneous bias

ivprobit dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1) if qc5==1, twostep first

ivregress 2sls dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1) if qc5==1, first
estat endog
estat firststage

ivprobit dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1 visit) if qc5==1, twostep first
rivtest

ivregress 2sls dtrust aware* dbenefit vic female asset community age migrant member consensus (dlisten=iv1 visit) if qc5==1
estat endog
estat overid
estat firststage



// Model (10) - bootstrapped se

use analysis, clear

logit dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1, vce(bootstrap, cluster(ea_code) seed(101))



// Model (11) - Corruption perception as trustworthniess

gen corrupt=0 if dcorrupt!=.
replace corrupt=1 if dcorrupt>0

logit corrupt dlisten dbenefit vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code)


// Model (12) - diamonds and elf

logit dtrust dlisten aware* dmarket droad dwater dhealth dedu vic female asset community age migrant member consensus diamond elf if qc5==1, r cluster(ea_code)


// Model (13) - Satisfaction 

logit dtrust dlisten aware* edu_sat hea_sat vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code)


// Descriptive statistics and correlation matrix

use analysis, clear

sum dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus diamond elf dmarket droad dwater dhealth dedu edu_sat hea_sat if qc5==1

corr dtrust dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1



// Diagram 

logit dtrust i.dlisten aware* dbenefit vic female asset community age migrant member consensus if qc5==1, r cluster(ea_code)
margins dlisten, at(asset08=(0(1)7) aware08=1 aware07=1 dbenefit=0 vic=1 female=0 community=1 migrant=0 member=1 consensus=1 age=42)
marginsplot

// SEM 


// gsem (dlisten -> dtrust, family(bernoulli) link(logit))  (consensus -> dtrust, family(bernoulli) link(logit)) (consensus -> dlisten, family(bernoulli) link(logit)) (dbenefit -> dtrust, family(bernoulli) link(logit)) (dbenefit -> dlisten, family(bernoulli) link(logit)) (project08 -> dlisten, family(bernoulli) link(logit)) (project08 -> dbenefit, family(bernoulli) link(logit)) if qc5==1, vce(cluster ea_code) nocapslatent

sem (consensus -> dtrust, ) (consensus -> dlisten, ) (dbenefit -> dtrust, ) (dbenefit -> dlisten, ) (dlisten -> dtrust, ) (project08 -> dbenefit, ) (project08 -> dlisten, ) if qc5==1, vce(cluster ea_code) nocapslatent

nlcom _b[dtrust:consensus]
nlcom _b[dtrust:dlisten]*_b[dlisten:consensus]
nlcom _b[dtrust:dlisten]*_b[dlisten:project08]
nlcom _b[dtrust:dbenefit]*_b[dbenefit:project08]
nlcom _b[dtrust:dlisten]*_b[dlisten:dbenefit]*_b[dbenefit:project08]
nlcom _b[dtrust:dlisten]
nlcom _b[dtrust:dbenefit]



// Co-ethnics effect


use analysis.dta, clear

keep if hh_no==1 | hh_no==2

keep ea_code hh_no ethnic trust08 trust07

sort ea_code hh_no
gen same_hh=1 if hh_no[_n]==hh_no[_n-1]
drop if same_hh==1

by ea_code, sort: gen same_eth=1 if ethnic[_n]==ethnic[_n-1]
by ea_code, sort: replace same_eth=0 if ethnic[_n]!=ethnic[_n-1]
replace same_eth=. if hh_no==1

by ea_code, sort: gen same_08=1 if trust08[_n]==trust08[_n-1]
by ea_code, sort: replace same_08=0 if trust08[_n]!=trust08[_n-1]
replace same_08=. if hh_no==1

by ea_code, sort: gen same_07=1 if trust07[_n]==trust07[_n-1]
by ea_code, sort: replace same_07=0 if trust07[_n]!=trust07[_n-1]
replace same_07=. if hh_no==1

tab same_eth same_08
display 113/196
display 260/436
prtesti 196 .57653061 436 .59633028

tab same_eth same_07
display 117/196
display 264/436
prtesti 196 .59693878 436 .60550459

log close