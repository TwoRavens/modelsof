use "Data_programs/Data/EAShort.dta", clear

* Figure 4

preserve

gen type=1 if kinship_score>=.25
replace type=2 if kinship_score<.25
gen b=1

foreach i in s_diff_violence s_loyalty_local{
gen se_`i'=.

forvalues j=1/2{
qui bs, reps(500):  reg `i' if type==`j', cluster(cluster)
replace se_`i'=_se[_cons] if type==`j'
}
}

foreach i in s_moral_god s_hierlocal_village s_hierabovelocal s_sex_taboo{
gen se_`i'=.

forvalues j=1/2{
reg `i' if type==`j', cluster(cluster)
replace se_`i'=_se[_cons] if type==`j'
}
}


collapse s_diff_violence s_sex_taboo s_loyalty_local s_moral_god s_hierlocal_ s_hierabovelocal se_s_diff_violence se_s_sex_taboo se_s_loyalty_local se_s_moral_god se_s_hierlocal_village se_s_hierabovelocal, by(type)

stack s_diff_violence se_s_diff_violence type s_moral_god se_s_moral_god type s_loyalty_local se_s_loyalty_local type s_sex_taboo se_s_sex_taboo type s_hierlocal_village se_s_hierlocal_village type s_hierabovelocal se_s_hierabovelocal type, into(mean se type)

gen upper=mean+se
gen lower=mean-se
rename _ stack

drop if type==0
gen order=1 if stack==1 & type==1
replace order=2 if stack==1 & type==2

replace order=4 if stack==2 & type==1
replace order=5 if stack==2 & type==2

replace order=7 if stack==3 & type==1
replace order=8 if stack==3 & type==2

replace order=10 if stack==4 & type==1
replace order=11 if stack==4 & type==2

replace order=13 if stack==5 & type==1
replace order=14 if stack==5 & type==2

replace order=16 if stack==6 & type==1
replace order=17 if stack==6 & type==2
drop if order==.

graph twoway (bar mean order if stack==1 & type==1,color(navy)) (bar mean order if stack==1 & type==2, color(maroon)) (bar mean order if stack==2 & type==1,color(navy)) (bar mean order if stack==2 & type==2, color(maroon)) (bar mean order if stack==3 & type==1,color(navy)) (bar mean order if stack==3 & type==2, color(maroon)) (bar mean order if stack==4 & type==1,color(navy)) (bar mean order if stack==4 & type==2, color(maroon)) (bar mean order if stack==5 & type==1,color(navy)) (bar mean order if stack==5 & type==2, color(maroon)) (bar mean order if stack==6 & type==1,color(navy)) (bar mean order if stack==6 & type==2, color(maroon)) (bar mean order if stack==7 & type==1,color(navy)) (bar mean order if stack==7 & type==2, color(maroon))   (rcap upper lower order, lcolor(black) xtitle("") yline(0,lcolor(black) lpattern(dash)) xlabel(1.5 `""{it:Δ Violence}" "{it:Out- vs. in-group}""' 4.5 `""{it:Moralizing}" {it:god}"' 7.5 `""{it:Loyalty}" {it:community}"' 10.5 `""{it:Purity}" {it:concerns}"' 13.5 `""{it:Village}" "{it:institutions}""' 16.5 `""{it:Global}" {it:institutions}"') title("Historical moral systems") ytitle("Average ± s.e.m. (z-scores)") ylabel(-.9 -.6 -.3 0 .3 .6) yscale(range(-.75 .5)) legend(order(1 2) label(1 "Tight") label(2 "Loose")) graphregion(fcolor(white) lcolor(white)))
graph export Source_files/Figs/Overview_ea.pdf, replace

restore

