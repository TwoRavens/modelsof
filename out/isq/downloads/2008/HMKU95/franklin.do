version 7.0
log using "C:\myfiles\research\PolRep\result1", replace
use "C:\MyFiles\research\PolRep\ISQ\jfisqdata.dta", clear
set more off

generate rep2=reptot2
recode rep2 1/3=1 4/8=2 9/18=3

gen depend=aidgni+fdigdp

replace hrngo_1=0 if hrngo_1<0
replace hrrel_1=0 if hrrel_1<0
replace hrigo_1=0 if hrigo_1<0
replace hrgov_1=0 if hrgov_1<0

replace hrngo_6=0 if hrngo_6<0
replace hrrel_6=0 if hrrel_6<0
replace hrigo_6=0 if hrigo_6<0
replace hrgov_6=0 if hrgov_6<0

gen hrigodep_1=hrigo_1*depend
gen hrngodep_1=hrngo_1*depend
gen hrgovdep_1=hrgov_1*depend
gen hrreldep_1=hrrel_1*depend

gen hrigodep_6=hrigo_6*depend
gen hrngodep_6=hrngo_6*depend
gen hrgovdep_6=hrgov_6*depend
gen hrreldep_6=hrrel_6*depend

gen hr2_1=hrngo_1+hrrel_1+hrigo_1+hrgov_1
gen hr2dep_1=hr2_1*depend
gen hr2_6=hrngo_6+hrrel_6+hrigo_6+hrgov_6
gen hr2dep_6=hr2_6*depend


generate post1985=1 if year>1985
replace post1985=0 if year<1986

drop if rev==1 & country2==4
drop if rev==1 & country2==6


oprobit rep2 hr2_1 hr2dep_1 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985, cluster(country2)
oprobit rep2 hrngo_1 hrngodep_1 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985, cluster(country2)
oprobit rep2 hrrel_1 hrreldep_1 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985 , cluster(country2)
oprobit rep2 hrigo_1 hrigodep_1 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985 , cluster(country2)
oprobit rep2 hrgov_1 hrgovdep_1 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985 , cluster(country2)

oprobit rep2 hr2_6 hr2dep_6 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985, cluster(country2)
oprobit rep2 hrngo_6 hrngodep_6 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985, cluster(country2)
oprobit rep2 hrrel_6 hrreldep_6 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985 , cluster(country2)
oprobit rep2 hrigo_6 hrigodep_6 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985 , cluster(country2)
oprobit rep2 hrgov_6 hrgovdep_6 depend rev part2 dur dissvio execsupp polity reptotlag2 post1985 , cluster(country2)

log close
