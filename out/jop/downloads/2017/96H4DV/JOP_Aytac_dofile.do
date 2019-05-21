* REPLICATION CODE
* Selim Erdem Aytac
* Relative Economic Performance and the Incumbent Vote
* January 2017

set more off

***Table 1

*Model 1
reg inc_vote growth_year vote_prev coalition enp presidential rerun, cluster(country)

*Model 2
reg inc_vote rel_dom_growth rel_intl_growth intl_growth growth_year vote_prev coalition enp presidential rerun, cluster(country)


***Table 2

*Model 1
reg inc_vote rel_intl_growth educxrel_intl rel_dom_growth educxrel_dom growth_year educxgrowth_year intl_growth vote_prev coalition enp presidential rerun education, cluster(country)

*Model 2
reg inc_vote rel_intl_growth incomexrel_intl rel_dom_growth incomexrel_dom growth_year incomexgrowth_year intl_growth vote_prev coalition enp presidential rerun income, cluster(country)

*Model 3
reg inc_vote rel_intl_growth tradexrel_intl rel_dom_growth tradexrel_dom growth_year tradexgrowth_year intl_growth vote_prev coalition enp presidential rerun trade_intensity, cluster(country)

*Model 4
reg inc_vote rel_intl_growth educxrel_intl rel_dom_growth educxrel_dom growth_year educxgrowth_year intl_growth vote_prev coalition enp presidential rerun education income trade_intensity, cluster(country)


***Table 3
reg inc_vote rel_intl_growth tradexrel_intl rel_dom_growth tradexrel_dom growth_year tradexgrowth_year intl_growth vote_prev coalition enp presidential rerun trade_intensity if education>=8, cluster(country)


***Figure 2
*Note: Some modifications were made manually (i.e., labels, scales) to published version 

preserve

reg inc_vote rel_intl_growth education educxrel_intl rel_dom_growth educxrel_dom growth_year educxgrowth_year intl_growth vote_prev coalition enp presidential rerun, cluster(country)

matrix b = e(b)
matrix V = e(V)

scalar b1 = b[1,1]
scalar b3 = b[1,3]
scalar varb1 = V[1,1]
scalar varb3 = V[3,3]
scalar covb1b3 = V[1,3]

gen varmeint = varb1 + varb3*(education^2) + 2*covb1b3*education
gen semeint = sqrt(varmeint)

gen meint = b1 + b3*education

gen up95 = meint + (1.645*semeint)
gen low95 = meint - (1.645*semeint)

sort education

twoway (line up95 meint low95 education)  histogram education, discrete width(1) percent yaxis(2) yscale(range(0 100) axis(2))

drop varmeint semeint meint up95 low95 

restore



***Figure 3
*Note: Some modifications were made manually (i.e., labels, scales) to published version 

preserve

reg inc_vote rel_intl_growth trade_intensity tradexrel_intl rel_dom_growth tradexrel_dom growth_year tradexgrowth_year intl_growth vote_prev coalition enp presidential rerun if education>=8, cluster(country)

matrix b = e(b)
matrix V = e(V)

scalar b1 = b[1,1]
scalar b3 = b[1,3]
scalar varb1 = V[1,1]
scalar varb3 = V[3,3]
scalar covb1b3 = V[1,3]

gen varmeint = varb1 + varb3*(trade_intensity ^2) + 2*covb1b3* trade_intensity
gen semeint = sqrt(varmeint)

gen meint = b1 + b3* trade_intensity

gen up95 = meint + (1.645*semeint)
gen low95 = meint - (1.645*semeint)

sort trade_intensity

twoway (line up95 meint low95 trade_intensity)  histogram trade_intensity, discrete width(1) percent yaxis(2) yscale(range(0 200) axis(2))

drop varmeint semeint meint up95 low95 

restore


***Table A2 in the online appendix

reg inc_vote rel_yty_growth rel_intl_growth growth_year intl_growth vote_prev coalition enp presidential rerun, cluster(country)
