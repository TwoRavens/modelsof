*TABLE 1

use "candidates-consultants-party.dta",clear
gen n=1
bysort consunique: egen goptotal=sum(gop)
bysort consunique: egen clienttotal=sum(n)

drop if consultant==""
collapse (mean) goptotal clienttotal,by(consunique)

gen partycrosser=(goptotal!=clienttotal & goptotal!=0)
tab partycrosser

/*one case out of 488 consultants by cycle (2002-2006)*/
list if goptotal!=clienttotal & goptotal!=0

tostring consunique,gen(custr) 
gen year=substr(custr,1,4)

/*table 1*/
bysort year: tab partycrosser
