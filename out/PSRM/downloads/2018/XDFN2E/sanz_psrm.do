********************************************************************************************************
***      Carlos Sanz                                                                                 ***
***      "Direct Democracy and Government Size: Evidence from Spain"      ***
***      Version: 27 November 2018                                                                   *** 
********************************************************************************************************

clear all
set more off, permanently
capture log close
set logtype text
log using sanz_psrm.txt, replace
set matsize 11000 // this may depend on the version of Stata

**** Part 1: Prepare Data ****
use sanz_psrm.dta, replace

* Drop observations with missing data or from out-of-sample years
sort id year
keep if year>1987 & year<=2011 & expenditures_c!=.

* Generate centered population
gen population_100=population-99.5

* Generate municipality-specific time trends
rdbwselect log_expenditures_c population_100, bwselect(IK) kernel(uniform)
scalar log_expenditures_c_opt_bw = min(e(h_IK),150)
gen close=1 if population_100<log_expenditures_c_opt_bw & population_100>-log_expenditures_c_opt_bw

tab id if close==1, gen(id_)
forvalues i = 1 (1) 1145 {
gen time_id_`i' = year*id_`i'
}

* Generate variables for Table A11
tab j, gen(j_)

gen j_456=(j==4 | j==5 | j==6)

forvalues i=1(1)6 {
replace j_`i'=0 if dd==0
gen dd_j_`i'=dd*j_`i'
gen population_j_`i'=population_100*j_`i'
}

gen dd_j_456=dd*j_456
gen population_j_456=population_100*j_456

* Gen year dummies
tab year, gen(year_)

* Generate variables for Figure A5
drop population_100
forvalues i=28 (1) 225 {
local k=`i'-1
local j=`i'-0.5
gen pl_`i'=1 if population<`i' & population!=.
replace pl_`i'=0 if population>`k' & population!=.
gen population_`i'=population-`j'
gen population_pl_`i'=population_`i'*pl_`i'
}

global outcomes log_expenditures_c log_revenues_c deficit_c
foreach x of varlist $outcomes {
gen delta_`x'=.
gen tstat_`x'=.

forvalues i=28 (1) 225 {
rdbwselect `x' population_`i' if population<251, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)

xtivreg2 `x' year_* pl_`i' population_`i' population_pl_`i' if population_`i'<`x'_opt_bw & population_`i'>-`x'_opt_bw, fe cluster(population_`i' id)
replace delta_`x'=_b[pl_`i'] if population==`i'
replace tstat_`x'=delta_`x'/_se[pl_`i'] if population==`i'
}
}

* Generate global macros
global specific time_id*
global outcomes log_expenditures_c log_revenues_c deficit_c
global covariates l_g_p_votes_pp l_g_p_votes_psoe l_g_p_votes_iu l_g_p_diff l_g_p_votes_winner l_g_p_turnout age_avg sh_young sh_adult sh_old sh_foreign sh_eu unemployment_rate
global l_outcomes l_log_expenditures_c l_log_revenues_c l_deficit_c
global controls dd_j_2 dd_j_3 dd_j_456 population_j_2 population_j_3 population_j_456

* Generate variables for RDD figures
tab population if population<251, gen(population_d_) //cutoff is from 95 (=99) to 96 (=100)
drop population_d_96
egen bin_population=cut(population_100), at(-100(4)400) 
replace bin_population=bin_population+2
global population population_d_*

foreach x in $outcomes $l_outcomes $covariates {

xtivreg2 `x' year_* $population if close==1, fe cluster(population_100 id)

gen `x'_gr=.

forvalues j= 70(1)95{
local k=`j'+4
replace `x'_gr=_b[population_d_`j'] if population==`k'
}
forvalues j= 97(1)121{
local k=`j'+4
replace `x'_gr=_b[population_d_`j'] if population==`k'
}
replace `x'_gr=0 if population==100

egen bin_`x'_gr = mean(`x'_gr), by(bin_population)

gen `x'_res=-bin_`x'_gr if population==100
sort `x'_res
replace `x'_res=`x'_res[_n-1] if `x'_res==.
replace `x'_res=`x'_res[_n+1] if `x'_res==.

replace `x'_gr=`x'_gr+`x'_res
replace bin_`x'_gr=bin_`x'_gr+`x'_res
}

* Generate interactions
gen dd_population=population_100*dd

gen population_2=population_100*population_100
gen dd_population_2=population_2*dd

gen population_3=population_100*population_100*population_100
gen dd_population_3=population_3*dd

gen population_4=population_100*population_100*population_100*population_100
gen dd_population_4=population_4*dd

gen population_5=population_100*population_100*population_100*population_100*population_100
gen dd_population_5=population_5*dd

* Gen bw variale
gen bw=population_100
replace bw=-population_100 if population_100<0

save temp.dta, replace

**** Part 2: Main Text Results ****
use temp.dta, replace

* Table 1
eststo clear
estpost tabstat expenditures_c revenues_c deficit_c g_p_votes_pp g_p_votes_psoe g_p_votes_iu g_p_diff g_p_votes_winner g_p_turnout age_avg sh_young sh_adult sh_old sh_foreign sh_eu population unemployment_rate, statistics (mean sd p1 median p99 count) columns(statistics)
esttab using table_1.tex, cells("mean (fmt(%9.1f)) sd (fmt(%9.1f))  p1 (fmt(%9.1f)) p50 (fmt(%9.1f)) p99 (fmt(%9.1f))  count (fmt(%9.0f))") noobs replace label

* Table 2
foreach x of varlist log_expenditures_c {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, fe cluster(population_100 id)

eststo: xtivreg2 `x' $specific year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)

esttab using table_2_a.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

foreach x of varlist log_revenues_c {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, fe cluster(population_100 id)

eststo: xtivreg2 `x' $specific year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)

esttab using table_2_b.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

foreach x of varlist deficit_c {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, fe cluster(population_100 id)

eststo: xtivreg2 `x' $specific year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)

esttab using table_2_c.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Figure 2
histogram population if population<400, width(5) start(0) freq xsize(4) ysize(2.5)  graphregion(fcolor(white) style(none) istyle(none)) plotregion(fcolor(white) ) color(gs3) lcolor(gs10) ytitle(Observations, size(large)) xtitle(Population, size(large)) xlabel(,labsize(large)) ylabel(,labsize(large))
graph export figure_2.png, replace
graph export figure_2.eps, replace

* Figure 3
preserve
bys population: drop if population==population[_n-1]

twoway lfit log_expenditures_c_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit log_expenditures_c_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_log_expenditures_c_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_3_a.png, replace
gr export figure_3_a.eps, replace

twoway lfit log_revenues_c_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit log_revenues_c_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_log_revenues_c_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_3_b.png, replace
gr export figure_3_b.eps, replace

twoway lfit deficit_c_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit deficit_c_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(-100 (50) 100, labsize(large)) || scatter bin_deficit_c_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_3_c.png, replace
gr export figure_3_c.eps, replace
restore


**** Part 3: Online Appendix Results ****

* Table A1
bys id t: gen x=_n

bys t: count if x==1
bys t: count if x==1 & dd==1
bys t: count if x==1 & dd==0

bys t: count if ( (dd==1 & l_dd==0) | (dd==0 & l_dd==1) ) & x==1 // the switches at t=2 are from the 1983-1987 to the 1987-1991 terms and hence do not enter the sample, which only starts at t=2
bys t: count if ( (dd==1 & l_dd==0) ) & x==1
bys t: count if ( (dd==0 & l_dd==1) ) & x==1

* Table A2
foreach x of varlist $outcomes {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: ivreg2 `x' dd population_100 dd_population if bw<`x'_opt_bw, cluster(population_100 id)
eststo: ivreg2 `x' dd population_100 dd_population if bw<`x'_opt_bw*1.5, cluster(population_100 id)
eststo: ivreg2 `x' dd population_100 dd_population if bw<`x'_opt_bw*.5, cluster(population_100 id)

eststo: ivreg2 `x' dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, cluster(population_100 id)
eststo: ivreg2 `x' dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, cluster(population_100 id)
eststo: ivreg2 `x' dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, cluster(population_100 id)

esttab using table_a2_`x'.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A3
foreach x of varlist log_transfers_c {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, fe cluster(population_100 id)

eststo: xtivreg2 `x' $specific year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)

esttab using table_a3.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A4
foreach x of varlist log_capital_c {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, fe cluster(population_100 id)

eststo: xtivreg2 `x' $specific year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)

esttab using table_a4.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A5
foreach x of varlist $covariates {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

esttab using table_a5_`x'.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A6
foreach x of varlist $l_outcomes {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population population_2 dd_population_2 population_3 dd_population_3 population_4 dd_population_4 population_5 dd_population_5, fe cluster(population_100 id)

eststo: xtivreg2 `x' $specific year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)

esttab using table_a6_`x'.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A7
foreach x in $outcomes {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population  if (population>100 | population<99), fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population  if (population>102 | population<97), fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population  if (population>104 | population<95), fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population  if (population>109 | population<90), fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population  if (population>114 | population<85), fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population  if (population>119 | population<80), fe cluster(population_100 id)

esttab using table_a7_`x'.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A8
foreach x in $outcomes {
eststo clear
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)

eststo: xtivreg2 `x' year_* dd population_100 dd_population  if bw<`x'_opt_bw, fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population if ((dd==1 & l_dd==1) | (dd==0 & l_dd==0) | (dd==1 & l_dd==0)) & bw<`x'_opt_bw , fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if ((dd==1 & l_dd==1) | (dd==0 & l_dd==0) | (dd==1 & l_dd==0)) & bw<`x'_opt_bw*1.5 , fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if ((dd==1 & l_dd==1) | (dd==0 & l_dd==0) | (dd==1 & l_dd==0)) & bw<`x'_opt_bw*.5 , fe cluster(population_100 id)

eststo: xtivreg2 `x' year_* dd population_100 dd_population if ((dd==1 & l_dd==1) | (dd==0 & l_dd==0) | (dd==0 & l_dd==1)) & bw<`x'_opt_bw , fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if ((dd==1 & l_dd==1) | (dd==0 & l_dd==0) | (dd==0 & l_dd==1)) & bw<`x'_opt_bw*1.5 , fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if ((dd==1 & l_dd==1) | (dd==0 & l_dd==0) | (dd==0 & l_dd==1)) & bw<`x'_opt_bw*.5 , fe cluster(population_100 id)

esttab using table_a8_`x'.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A9
foreach x in $outcomes {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)

winsor `x' if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, gen(`x'_out_100) p(0.01)
winsor `x' if population_100<`x'_opt_bw*1.5 & population_100>-`x'_opt_bw*1.5, gen(`x'_out_150) p(0.01)
winsor `x' if population_100<`x'_opt_bw*1.25 & population_100>-`x'_opt_bw*1.25, gen(`x'_out_125) p(0.01)
winsor `x' if population_100<`x'_opt_bw*.75 & population_100>-`x'_opt_bw*.75, gen(`x'_out_75) p(0.01)
winsor `x' if population_100<`x'_opt_bw*.5 & population_100>-`x'_opt_bw*.5, gen(`x'_out_50) p(0.01)

eststo clear
eststo: xtivreg2 `x' year_* dd population_100 dd_population  if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, fe cluster(population_100 id)

eststo: xtivreg2 `x'_out_100 year_* dd population_100 dd_population  if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x'_out_150 year_* dd population_100 dd_population  if population_100<`x'_opt_bw*1.5 & population_100>-`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x'_out_125 year_* dd population_100 dd_population  if population_100<`x'_opt_bw*1.25 & population_100>-`x'_opt_bw*1.25, fe cluster(population_100 id)
eststo: xtivreg2 `x'_out_75 year_* dd population_100 dd_population  if population_100<`x'_opt_bw*.75 & population_100>-`x'_opt_bw*.75, fe cluster(population_100 id)
eststo: xtivreg2 `x'_out_50 year_* dd population_100 dd_population  if population_100<`x'_opt_bw*.5 & population_100>-`x'_opt_bw*.5, fe cluster(population_100 id)

esttab using table_a9_`x'.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}

* Table A10
preserve
use sanz_psrm.dta, replace

gen available=1 if year>1987 & year<=2011 & expenditures_c!=.
replace available=0 if year>1987 & year<=2011 & expenditures_c==.

gen population_100=population-99.5

gen dd_population=population_100*dd

gen bw=population_100
replace bw=-population_100 if population_100<0

tab year, gen(year_)

foreach x of varlist available {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
eststo clear

eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*1.25, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if bw<`x'_opt_bw*.25, fe cluster(population_100 id)

esttab using table_a10.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)
}
restore

* Table A11
eststo clear
foreach x of varlist $outcomes {
rdbwselect `x' population_100 if population<251, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)

eststo: xtivreg2 `x' year_* dd population_100 dd_population $controls if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population $controls if population_100<`x'_opt_bw*1.5 & population_100>-`x'_opt_bw*1.5, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population $controls if population_100<`x'_opt_bw*.5 & population_100>-`x'_opt_bw*.5, fe cluster(population_100 id)
}
esttab using table_a11.tex, label keep(dd dd_j_*) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)

* Table A12
eststo clear
foreach x in g_p_votes_pp g_p_votes_psoe g_p_votes_iu g_p_turnout {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)

eststo: xtivreg2 `x' year_* dd population_100 dd_population if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if population_100<`x'_opt_bw*.5 & population_100>-`x'_opt_bw*.5, fe cluster(population_100 id)
}
esttab using table_a12_a.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)

eststo clear
foreach x in f_g_p_votes_pp f_g_p_votes_psoe f_g_p_votes_iu f_g_p_turnout {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)

eststo: xtivreg2 `x' year_* dd population_100 dd_population if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, fe cluster(population_100 id)
eststo: xtivreg2 `x' year_* dd population_100 dd_population if population_100<`x'_opt_bw*.5 & population_100>-`x'_opt_bw*.5, fe cluster(population_100 id)
}
esttab using table_a12_b.tex, label keep(dd) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust2)

* Figure A1
gen sh_deficit = 100*deficit_c / revenues_c
foreach x in expenditures_c revenues_c deficit_c sh_deficit {
rdbwselect `x' population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),150)
egen `x'_p99= pctile(`x') if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, p(99)
egen `x'_p1= pctile(`x') if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, p(1)
egen `x'_p95= pctile(`x') if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, p(95)
egen `x'_p5= pctile(`x') if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, p(5)
egen `x'_p90= pctile(`x') if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, p(90)
egen `x'_p10= pctile(`x') if population_100<`x'_opt_bw & population_100>-`x'_opt_bw, p(10)
}

histogram expenditures_c if population_100<expenditures_c_opt_bw & population_100>-expenditures_c_opt_bw & expenditures_c<expenditures_c_p99 & expenditures_c>expenditures_c_p1, freq width(100) graphregion(fcolor(white)) plotregion(fcolor(white)) color(gs3) lcolor(gs10) ytitle(Observations, size(large)) xtitle(Expenditures (euros per capita per year), size(large)) xlabel(,labsize(large)) ylabel(0 (1000) 2000, labsize(large))
graph export figure_a1_a.png, replace
graph export figure_a1_a.eps, replace
histogram revenues_c if population_100<revenues_c_opt_bw & population_100>-revenues_c_opt_bw & revenues_c<revenues_c_p99 & revenues_c>revenues_c_p1, freq width(100) graphregion(fcolor(white)) plotregion(fcolor(white)) color(gs3) lcolor(gs10) ytitle(Observations, size(large)) xtitle(Revenues (euros per capita per year), size(large)) xlabel(,labsize(large)) ylabel(0 (1000) 2000, labsize(large))
graph export figure_a1_b.png, replace
graph export figure_a1_b.eps, replace
histogram sh_deficit if population_100<deficit_c_opt_bw & population_100>-deficit_c_opt_bw & sh_deficit<sh_deficit_p90 & sh_deficit>sh_deficit_p10, freq width(5) start(-15) graphregion(fcolor(white)) plotregion(fcolor(white)) color(gs3) lcolor(gs10) ytitle(Observations, size(large)) xtitle(Deficit (% of revenues), size(large)) xlabel(,labsize(large)) ylabel(, labsize(large))
graph export figure_a1_c.png, replace
graph export figure_a1_c.eps, replace

* Figure A2
foreach x of varlist $outcomes {
preserve
tempname memhold
tempfile results
postfile `memhold' bw te1 se1 using results_`x'.dta, replace
  forvalues bw=11(1)150{
xtivreg2 `x' year_* dd population_100 dd_population if bw<`bw', fe cluster(population_100 id)
    local te1 = _b[dd]
	local se1 = _se[dd]

    post `memhold' (`bw') (`te1') (`se1')
  }
 postclose `memhold'
 
 use results_`x'.dta, clear
 label var bw "Bandwidth"
 label var te1 "Treatment Effect"
  serrbar te1 se1 bw, yline(0) scale(1.96) mvopts( msize(small) sort) xlabel(10(20)140)
   graph export figure_a2_`x'.png, replace
   graph export figure_a2_`x'.eps, replace
   restore
}

* Figure A3
twoway lfit l_g_p_votes_pp_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_g_p_votes_pp_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_l_g_p_votes_pp_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_a.png, replace
gr export figure_a3_a.eps, replace

twoway lfit l_g_p_votes_psoe_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_g_p_votes_psoe_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large))  xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_l_g_p_votes_psoe_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_b.png, replace
gr export figure_a3_b.eps, replace

twoway lfit l_g_p_votes_iu_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_g_p_votes_iu_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_l_g_p_votes_iu_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_c.png, replace
gr export figure_a3_c.eps, replace

twoway lfit l_g_p_diff_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_g_p_diff_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_l_g_p_diff_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_d.png, replace
gr export figure_a3_d.eps, replace

twoway lfit l_g_p_votes_winner_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_g_p_votes_winner_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_l_g_p_votes_winner_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_e.png, replace
gr export figure_a3_e.eps, replace

twoway lfit l_g_p_turnout_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_g_p_turnout_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_l_g_p_turnout_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_f.png, replace
gr export figure_a3_f.eps, replace

twoway lfit age_avg_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit age_avg_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_age_avg_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_g.png, replace
gr export figure_a3_g.eps, replace

twoway lfit sh_young_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit sh_young_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_sh_young_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_h.png, replace
gr export figure_a3_h.eps, replace

twoway lfit sh_adult_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit sh_adult_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_sh_adult_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_i.png, replace
gr export figure_a3_i.eps, replace

twoway lfit sh_old_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit sh_old_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_sh_old_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_j.png, replace
gr export figure_a3_j.eps, replace

twoway lfit sh_foreign_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit sh_foreign_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_sh_foreign_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_k.png, replace
gr export figure_a3_k.eps, replace

twoway lfit sh_eu_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit sh_eu_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(, labsize(large)) || scatter bin_sh_eu_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a3_l.png, replace
gr export figure_a3_l.eps, replace

* Figure A4
twoway lfit l_log_expenditures_c_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_log_expenditures_c_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(-.1 (.05) .3, labsize(large)) || scatter bin_l_log_expenditures_c_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a4_a.png, replace
gr export figure_a4_a.eps, replace

twoway lfit l_log_revenues_c_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_log_revenues_c_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(-.1 (.05) .3, labsize(large)) || scatter bin_l_log_revenues_c_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a4_b.png, replace
gr export figure_a4_b.eps, replace

twoway lfit l_deficit_c_gr population_100  if population_100<=0 & close==1, lcolor(black) fcolor(white) alcolor(gs2) ||  lfit l_deficit_c_gr population_100  if  population_100>=0 & close==1, lcolor(black) legend(off) xti(Population, size(large)) xline(0, lcolor(black)) graphregion(fcolor(white)) plotregion(fcolor(white)) xlabel(-30 "70" 0 "100" 30 "130", labsize(large)) ylabel(-100 (50) 100, labsize(large)) || scatter bin_l_deficit_c_gr bin_population if close==1, msize(small) mcolor(black)
gr export figure_a4_c.png, replace
gr export figure_a4_c.eps, replace

* Figure A5
preserve
bys population: drop if population==population[_n-1]

tab delta_log_expenditures_c tstat_log_expenditures_c if population==100
tab delta_log_revenues_c tstat_log_revenues_c if population==100
tab delta_deficit_c tstat_deficit_c if population==100

cumul delta_log_expenditures_c if population>30 & population<221, gen(cum_delta_log_expenditures_c)
cumul tstat_log_expenditures_c if population>30 & population<221, gen(cum_tstat_log_expenditures_c)
cumul delta_log_revenues_c if population>30 & population<221, gen(cum_delta_log_revenues_c)
cumul tstat_log_revenues_c if population>30 & population<221, gen(cum_tstat_log_revenues_c)
cumul delta_deficit_c if population>30 & population<221, gen(cum_delta_deficit_c)
cumul tstat_deficit_c if population>30 & population<221, gen(cum_tstat_deficit_c)

twoway scatter cum_delta_log_expenditures_c delta_log_expenditures_c if population>30 & population<221, mcolor(black) xlabel(,labsize(large)) ylabel(,labsize(large)) xline(-.07987, lwidth(thick) lcolor(black)) msize(medium) legend(off) xti(Point Estimates, size(large))  yti(CDF, size(large)) graphregion(fcolor(white)) plotregion(fcolor(white))  caption(p-value = 0.036, size(large))
gr export figure_a5_a.png, replace
gr export figure_a5_a.eps, replace

twoway scatter cum_tstat_log_expenditures_c tstat_log_expenditures_c if population>30 & population<221, mcolor(black) xlabel(,labsize(large)) ylabel(,labsize(large)) xline(-2.993382, lwidth(thick) lcolor(black)) msize(medium) legend(off) xti(t-statistics, size(large))  yti(CDF, size(large)) graphregion(fcolor(white)) plotregion(fcolor(white))  caption(p-value = 0.01, size(large))
gr export figure_a5_b.png, replace
gr export figure_a5_b.eps, replace

twoway scatter cum_delta_log_revenues_c delta_log_revenues_c if population>30 & population<221, mcolor(black) xlabel(,labsize(large)) ylabel(,labsize(large)) xline(-.052124, lwidth(thick) lcolor(black)) msize(medium) legend(off) xti(Point Estimates, size(large))  yti(CDF, size(large)) graphregion(fcolor(white)) plotregion(fcolor(white)) caption(p-value = 0.126, size(large))
gr export figure_a5_c.png, replace
gr export figure_a5_c.eps, replace

twoway scatter cum_tstat_log_revenues_c tstat_log_revenues_c if population>30 & population<221, mcolor(black) xlabel(,labsize(large)) ylabel(,labsize(large)) xline(-1.997069, lwidth(thick) lcolor(black)) msize(medium) legend(off) xti(t-statistics, size(large))  yti(CDF, size(large)) graphregion(fcolor(white)) plotregion(fcolor(white)) caption(p-value = 0.068, size(large))
gr export figure_a5_d.png, replace
gr export figure_a5_d.eps, replace

twoway scatter cum_delta_deficit_c delta_deficit_c if population>30 & population<221, mcolor(black) xlabel(,labsize(large)) ylabel(,labsize(large)) xline(-7.877209, lwidth(thick) lcolor(black)) msize(medium) legend(off) xti(Point Estimates, size(large))  yti(CDF, size(large)) graphregion(fcolor(white)) plotregion(fcolor(white)) caption(p-value = 0.405, size(large))
gr export figure_a5_e.png, replace
gr export figure_a5_e.eps, replace

twoway scatter cum_tstat_deficit_c tstat_deficit_c if population>30 & population<221, mcolor(black) xlabel(,labsize(large)) ylabel(,labsize(large)) xline(-.9785889, lwidth(thick) lcolor(black)) msize(medium) legend(off) xti(t-statistics, size(large))  yti(CDF, size(large)) graphregion(fcolor(white)) plotregion(fcolor(white)) caption(p-value = 0.242, size(large))
gr export figure_a5_f.png, replace
gr export figure_a5_f.eps, replace
restore
