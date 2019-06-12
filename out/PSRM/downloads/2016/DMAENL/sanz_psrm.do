********************************************************************************************************
***      Carlos Sanz                                                                                 ***
***      "The Effect of Electoral Systems on Voter Turnout: Evidence from a Natural Experiment"      ***
***      Version: April 24, 2015                                                                     *** 
********************************************************************************************************

clear all
set more off, permanently
capture log close
set logtype text
log using sanz_psrm.txt, replace

**** Part 1: Prepare Data ****
use sanz_psrm.dta, replace

* Redefine as percentage points
replace p_turnout=p_turnout*100
replace p_nota=p_nota*100
replace p_null=p_null*100
replace g_p_turnout=g_p_turnout*100
replace g_p_nota=g_p_nota*100
replace g_p_null=g_p_null*100

* Define valid votes
gen valid=candidates+nota
gen g_valid=g_candidates+g_nota

* Redefine as percentage points
gen g_p_votes_pp=(g_votes_pp/g_valid)*100
gen g_p_votes_psoe=(g_votes_psoe/g_valid)*100
gen g_p_votes_iu=(g_votes_iu/g_valid)*100

* Drop observations with missing ir wrong data
global variables population census nota null candidates g_population g_census g_nota g_null g_candidates turnout g_turnout p_turnout g_p_turnout p_nota g_p_nota p_null g_p_null g_p_votes_pp g_p_votes_psoe g_p_votes_iu lists
global g_variables g_population g_census g_nota g_null g_candidates g_turnout g_p_turnout g_p_nota g_p_null g_p_votes_pp g_p_votes_psoe g_p_votes_iu
gen aux1=1 if population==0 | census==0 | turnout==0 | (p_turnout>100 & p_turnout!=.)| (p_nota>100 & p_nota!=.)| (p_null>100 & p_null!=.)
foreach x in $variables {
replace `x'=. if aux1==1
}
gen aux2=1 if g_population==0 | g_census==0 | g_turnout==0 | (g_p_turnout>100 & g_p_turnout!=.)| (g_p_nota>100 & g_p_nota!=.)| (g_p_null>100 & g_p_null!=.) | (g_p_votes_pp>100 & g_p_votes_pp!=.) | (g_p_votes_psoe>100 & g_p_votes_psoe!=.) | (g_p_votes_iu>100 & g_p_votes_iu!=.)
foreach x in $g_variables {
replace `x'=. if aux2==1
}
drop if population==. | census==. | nota==. | null==. | candidates==. |  lists==. | p_turnout==. | p_nota==. | p_null==. 

* Balance the panel (to create lag and lead variables)
sort id year
save data.dta, replace
bys id: keep if _n==1
keep id
expand (9)
bys id: gen year=1979 if _n==1
bys id: replace year=1983 if _n==2
bys id: replace year=1987 if _n==3
bys id: replace year=1991 if _n==4
bys id: replace year=1995 if _n==5
bys id: replace year=1999 if _n==6
bys id: replace year=2003 if _n==7
bys id: replace year=2007 if _n==8
bys id: replace year=2011 if _n==9
sort id year
merge id year using data.dta

* Define treatment and running variables
gen ol=1 if population<251 & population>99 & population!=.
replace ol=0 if ol==. & population!=.
gen ol_b=1 if population>99 & population<251 & population!=. & year!=1979 & year!=1983 & year!=2011
replace ol_b=0 if ol_b==. & population!=. & year!=1979 & year!=1983 & year!=2011

gen log_population=log(population)
gen log_population_100=log_population-log(100)
gen log_population_250=log_population-log(251)

gen ol_log_population=log_population_250*ol
gen ol_b_log_population=log_population_100*ol_b

* Define lag and lead variables
global variables_b ol ol_b log_population log_population_100 log_population_250 ol_log_population ol_b_log_population g_p_turnout g_p_nota g_p_null g_p_votes_pp g_p_votes_psoe g_p_votes_iu
sort id year
foreach x in $variables_b {
bys id: gen l_`x'=`x'[_n-1]
}
foreach x in $variables_b {
bys id: gen f_`x'=`x'[_n+1]
}

* Lable variables
label define answ 1 "OL" 0 "CL"
label values ol "answ"

label variable p_turnout turnout
label variable l_g_p_turnout "n turnout"
label variable l_g_p_nota "n blank"
label variable l_g_p_null "n spoilt"
label variable l_g_p_votes_pp "n right"
label variable l_g_p_votes_psoe "n left"
label variable l_g_p_votes_iu "n far left"
label variable ol "OL"
label variable ol_b "OL"
label variable f_ol "OL(+1)"
label variable f_ol_b "OL(+1)"

* Generate year dummies
tab year, gen(year_)



**** Part 2: Results ****

* Table 2
eststo clear
estpost tabstat p_turnout lists l_g_p_turnout l_g_p_nota l_g_p_null l_g_p_votes_pp l_g_p_votes_psoe l_g_p_votes_iu if population<400 & population>99, by(ol) statistics (mean sd min p10 median p90 max count) columns(statistics)
esttab using table_2bc.tex, cells("mean (fmt(a2)) sd (fmt(a2)) min (fmt(%9.2f)) p10 (fmt(a2)) p50 (fmt(a2)) p90 (fmt(a2)) max (fmt(a2)) count (fmt(a2))") noobs replace label

eststo clear
estpost tabstat p_turnout lists l_g_p_turnout l_g_p_nota l_g_p_null l_g_p_votes_pp l_g_p_votes_psoe l_g_p_votes_iu, statistics (mean sd min p10 median p90 max count) columns(statistics)
esttab using table_2a.tex, cells("mean (fmt(a2)) sd (fmt(a2)) min (fmt(%9.2f)) p10 (fmt(a2)) p50 (fmt(a2)) p90 (fmt(a2)) max (fmt(a2)) count (fmt(a2))") noobs replace label

* Figure
histogram population if population>100 & population<400, width(5) start(101) freq graphregion(fcolor(white)) plotregion(fcolor(white)) color(gs3) lcolor(gs10) ytitle(Number of Municipalities) xtitle(Population) xlabel(100 250 400)
graph export figure.png, replace
graph export figure.eps, replace


* Table 3
global ol p_turnout
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo clear
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
esttab using table_3.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)
}

* Table 4
global ol lists
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo clear
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
esttab using table_4a.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)
}
global ol p_turnout
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo clear
eststo: xtreg `x' year_* lists ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* lists ol log_population ol_log_population if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* lists ol log_population ol_log_population if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* lists ol log_population ol_log_population if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* lists ol log_population ol_log_population if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* lists ol log_population ol_log_population if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
esttab using table_4b.tex, label keep(ol lists) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)
}

* Table 6
global ol l_g_p_turnout l_g_p_nota 
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
}
esttab using table_6a.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol l_g_p_null l_g_p_votes_pp
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
}
esttab using table_6b.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol l_g_p_votes_psoe l_g_p_votes_iu
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
}
esttab using table_6c.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

* Table 7
global ol p_turnout
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
}
esttab using table_7a.tex, label keep(ol  f_ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol lists
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.85 & log_population_250>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.7 & log_population_250>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.55 & log_population_250>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.4 & log_population_250>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol  f_ol log_population f_log_population ol_log_population f_ol_log_population  if log_population_250<`x'_opt_bw*.25 & log_population_250>-`x'_opt_bw*.25, fe robust
}
esttab using table_7b.tex, label keep(ol  f_ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

* Table 8
global ol p_turnout
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw & (population>253 | population<248), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw & (population>255 | population<246), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw & (population>260 | population<241), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5 & (population>253 | population<248), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5 & (population>255 | population<246), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5 & (population>260 | population<241), fe robust
}
esttab using table_8a.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol lists
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_250, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw & (population>253 | population<248), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw & (population>255 | population<246), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw & log_population_250>-`x'_opt_bw & (population>260 | population<241), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5, fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5 & (population>253 | population<248), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5 & (population>255 | population<246), fe robust
eststo: xtreg `x' year_* ol log_population ol_log_population if log_population_250<`x'_opt_bw*.5 & log_population_250>-`x'_opt_bw*.5 & (population>260 | population<241), fe robust
}
esttab using table_8b.tex, label keep(ol) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

* Table 5
global ol p_turnout
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_100 if year!=1979 & year!=1983 & year!=2011, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.85 & log_population_100>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.7 & log_population_100>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.55 & log_population_100>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.4 & log_population_100>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.25 & log_population_100>-`x'_opt_bw*.25, fe robust
}
esttab using table_5a.tex, label keep(ol_b) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol lists
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_100 if year!=1979 & year!=1983 & year!=2011, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.85 & log_population_100>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.7 & log_population_100>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.55 & log_population_100>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.4 & log_population_100>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.25 & log_population_100>-`x'_opt_bw*.25, fe robust
}
esttab using table_5b.tex, label keep(ol_b) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

* Table 9
global ol p_turnout
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.85 & log_population_100>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.7 & log_population_100>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.55 & log_population_100>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.4 & log_population_100>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.25 & log_population_100>-`x'_opt_bw*.25, fe robust
}
esttab using table_9a.tex, label keep(ol_b f_ol_b) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol lists
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.85 & log_population_100>-`x'_opt_bw*.85, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.7 & log_population_100>-`x'_opt_bw*.7, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.55 & log_population_100>-`x'_opt_bw*.55, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.4 & log_population_100>-`x'_opt_bw*.4, fe robust
eststo: xtreg `x' year_* ol_b  f_ol_b log_population f_log_population ol_b_log_population f_ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.25 & log_population_100>-`x'_opt_bw*.25, fe robust
}
esttab using table_9b.tex, label keep(ol_b f_ol_b) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

* Table 10
global ol p_turnout
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw & (population>102 | population<97), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw & (population>104 | population<95), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw & (population>109 | population<90), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5 & (population>102 | population<97), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5 & (population>104 | population<95), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5 & (population>109 | population<90), fe robust
}
esttab using table_10a.tex, label keep(ol_b) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)

global ol lists
eststo clear
foreach x in $ol {
rdbwselect `x' log_population_100, bwselect(IK) kernel(uniform)
scalar `x'_opt_bw = min(e(h_IK),log(251)-log(100))
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw & (population>102 | population<97), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw & (population>104 | population<95), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw & log_population_100>-`x'_opt_bw & (population>109 | population<90), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5, fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5 & (population>102 | population<97), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5 & (population>104 | population<95), fe robust
eststo: xtreg `x' year_* ol_b log_population ol_b_log_population if year!=1979 & year!=1983 & year!=1987 & year!=2011 & log_population_100<`x'_opt_bw*.5 & log_population_100>-`x'_opt_bw*.5 & (population>109 | population<90), fe robust
}
esttab using table_10b.tex, label keep(ol_b) se replace star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust)
