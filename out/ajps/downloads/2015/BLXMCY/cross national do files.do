****cross national model 
use "cross national replicate.dta" 
xtset ccode count
xi: xtpcse   vapturn logcumdead  avgdur totalconf  prevturn disproportion tenure ciepmonth parldum unemp inflation   i.ccode   if ccode~=640 & ccode~=212 , pairwise

****this creates table 1 of supplementary materials
summarize vapturn logcumdead  avgdur totalconf  prevturn disproportion tenure ciepmonth parldum unemp inflation if e(sample)


***this creates the out of party variable
use "Master Party Data.dta"
keep country ccode countryname electionid elect_yr elect_mo edate ingov pervote prepervote
save "inandout.dta", replace
gen outgov =1 if ingov==0
replace outgov=0 if ingov==1
sort ccode elect_yr elect_mo
save, replace

*** this merges the datasets and runs the out of party hypothesis
use "cross national replicate.dta"
sort ccode elect_yr elect_mo
merge ccode elect_yr elect_mo using "inandout.dta"
save "outpartycasualty.dta", replace
gen out_cas = outgov*logcumdead
xtset electionid
xtreg pervote logcumdead outgov out_cas prepervote   avgdur totalconf   disproportion tenure ciepmonth parldum unemp inflation i.ccode if ccode~=640 & ccode~=212

summarize vapturn logcumdead  avgdur totalconf  prevturn disproportion tenure ciepmonth parldum unemp inflation if e(sample)

