**********************

*Capital Account Liberalization, Financial Structure, and Access to Credit (Replication Code)

*Install xtabond2 (Roodman) module to estimate dynamic panel data models
*ssc install xtabond2

*All figures below use dataset CapLib1.dta
*Save dataset to desktop and run 
clear
use "~/Desktop/CapLib1.dta"

**********************

*Figure 1. Capital Account Liberalization, Financial Structure, and Domestic Financial Reform

clear
use "~/Desktop/CapLib1.dta"

tsset cow year

quietly xi:xtscc ref_ssqstd ckaopen concentration00 ckaothree00 log_gdp_per_cap log_open polity2_2010 lref_ssqstd l2ref_ssqstd i.year, fe

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3

generate MVZ=_n+1
replace MVZ=. if _n>100

gen conbx=b1+b3*MVZ if _n<101
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101
gen ax=1.65*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax

gen where=-2
gen pipe = "|"
egen tag_nonslav = tag(concentration)
gen yline=0

replace lowerx=. if conbx>0.4
replace upperx=. if conbx>0.4
replace yline=. if conbx>0.4
replace MVZ=. if conbx>0.4
replace conbx=. if conbx>0.4

graph twoway hist concentration00, log width(0.5) percent color(gs14) yaxis(2) || scatter where concentration00 if tag_nonslav, xsc(r(20 100)) plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)  || line conbx   MVZ, xsc(r(20 100)) clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  || line upperx  MVZ, xsc(r(20 100)) clpattern(dash) clwidth(thin) clcolor(black) ||   line lowerx  MVZ, xsc(r(20 100)) clpattern(dash) clwidth(thin) clcolor(black) ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)   ||,xlabel(20 30 40 50 60 70 80 90 100, nogrid labsize(2))   ylabel(-2 "-0.50" -1 "-0.25" 0 1 "0.25" 2 "0.50" 3 "0.75", axis(1) nogrid labsize(2))   ylabel(0 1 2 3 4, axis(2) nogrid labsize(2)) yscale(noline alt)   yscale(noline alt axis(2))	         xscale(noline)        legend(off) xtitle("Bank Concentration" , size(vsmall)  )  ytitle("Percent of Bank Concentration" , axis(2) size(vsmall)) ytitle("Marginal Effect of Capital Account Liberalization" , axis(1) size(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

**********************

*Figure 2. Capital Account Liberalization, Financial Structure, and Access to Credit by Governments and SOEs

clear
use "~/Desktop/CapLib1.dta"

tsset cow year

quietly xi:xtscc loggovcredit00 ckaopen concentration00 ckaothree00 log_gdp_per_cap log_open polity2_2010 lloggovcredit00 l2loggovcredit00 i.year, fe 

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3

generate MVZ=_n+1
replace MVZ=. if _n>100

gen conbx=b1+b3*MVZ if _n<101
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101
gen ax=1.65*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax

gen where=-30
gen pipe = "|"
egen tag_nonslav = tag(concentration)
gen yline=0

replace lowerx=. if conbx<-12
replace upperx=. if conbx<-12
replace MVZ=. if conbx<-12
replace conbx=. if conbx<-12

graph twoway hist concentration00, log width(0.5) percent color(gs14) yaxis(2) || scatter where concentration00 if tag_nonslav, xsc(r(20 100)) plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)  || line conbx   MVZ, xsc(r(20 100)) clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  || line upperx  MVZ, xsc(r(20 100)) clpattern(dash) clwidth(thin) clcolor(black) ||   line lowerx  MVZ, xsc(r(20 100)) clpattern(dash) clwidth(thin) clcolor(black) ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)   ||,xlabel(20 30 40 50 60 70 80 90 100, nogrid labsize(2))   ylabel(-30 -20 -10 0 10 20 30 40, axis(1) nogrid labsize(2))   ylabel(0 1 2 3 4, axis(2) nogrid labsize(2)) yscale(noline alt)   yscale(noline alt axis(2))	         xscale(noline)        legend(off) xtitle("Bank Concentration" , size(vsmall)  )  ytitle("Percent of Bank Concentration" , axis(2) size(vsmall)) ytitle("Marginal Effect of Capital Account Liberalization" , axis(1) size(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

**********************

*Table 3. Capital Account Liberalization, Financial Structure, and Access to Credit by Private Firms and Households

clear
use "~/Desktop/CapLib1.dta"

tsset cow year

quietly xi:xtscc lpcrdbgdp00 ckaopen concentration00 ckaothree00 log_gdp_per_cap log_open polity2_2010 llpcrdbgdp00 l2lpcrdbgdp00 i.year, fe

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b3=b[1,3]
scalar varb1=V[1,1]
scalar varb3=V[3,3]
scalar covb1b3=V[1,3]

scalar list b1 b3 varb1 varb3 covb1b3

generate MVZ=_n+1
replace MVZ=. if _n>100

gen conbx=b1+b3*MVZ if _n<101
gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ) if _n<101
gen ax=1.65*consx
gen upperx=conbx+ax
gen lowerx=conbx-ax

gen where=-10
gen pipe = "|"
egen tag_nonslav = tag(concentration)
gen yline=0

replace lowerx=. if conbx>3.5
replace upperx=. if conbx>3.5
replace yline=. if conbx>3.5
replace MVZ=. if conbx>3.5
replace conbx=. if conbx>3.5

graph twoway hist concentration00,  log width(0.5) percent color(gs14) yaxis(2)  || scatter where concentration00 if tag_nonslav, xsc(r(20 100)) plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6) legend(off)  ||  || line conbx   MVZ, xsc(r(20 100)) clpattern(solid) clwidth(medium) clcolor(black) yaxis(1)  || line upperx  MVZ, xsc(r(20 100)) clpattern(dash) clwidth(thin) clcolor(black) ||   line lowerx  MVZ, xsc(r(20 100)) clpattern(dash) clwidth(thin) clcolor(black) ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid)   ||,xlabel(20 30 40 50 60 70 80 90 100, nogrid labsize(2))   ylabel(-10 -5 0 5 10, axis(1) nogrid labsize(2))   ylabel(0 1 2 3 4, axis(2) nogrid labsize(2)) yscale(noline alt)   yscale(noline alt axis(2))	         xscale(noline)        legend(off) xtitle("Bank Concentration" , size(vsmall)  )  ytitle("Percent of Bank Concentration" , axis(2) size(vsmall)) ytitle("Marginal Effect of Capital Account Liberalization" , axis(1) size(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

**********************
