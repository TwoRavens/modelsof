
*- Coleman and Mwangi
*- "Conflict, Cooperation, and Institutional Change on the Commons" AJPS
*----------------------
capture log close
clear
set more off
set scheme vg_s1m

*- data analysis

use kenya_inst.dta, clear

*- create histogram figure of land concentration
hist landcon, start(0) width(.05) bfcolor(gs16) percent addplot( hist landcon if landcon>.15, start(0) width(.05) bfcolor(gs10) percent || hist landcon if landcon>.25, start(0) width(.05) bfcolor(gs5) percent) legend(order(1 "Unconcentrated" 2 "Moderately" "Concentrated" 3 "Highly" "Concentrated") size(small) position(2) ring(0)) xsize(4) ysize(4) ytitle("Percent of""Common Property Groups", size(small)) xlab(0 .15 .25 1) title("Land Concentration") xtitle("Herfindahl Index")
graph export landcon.eps, replace

*- tabulate land concentration categories
recode landcon (0/.15=1) (.15/.25=2) (.25/1=3), gen(landcon3)
tab landcon3

*- Define controls
global y grintens veg landcon ownani
global z kinship g1-g7
global x tenure herdinc sex hhnum distkm edu age migrate status lit m_1

*- Post summary stats
qui estpost summarize $y pastmg acres $x $z g8
estout , cells("count(fmt(%9.0f)) mean(fmt(%9.3f)) sd(fmt(%9.3f)) min(fmt(%9.3f)) max(fmt(%9.3f))") label collabels("N" "Mean" "Std.Dev." "Min" "Max") mlabels(, none) varwidth(30)

*-take logs and get interactions
replace grintens=ln(grintens)
replace veg=ln(veg)
replace hhnum=ln(hhnum)
replace distkm=ln(distkm+1)
replace age=ln(age)
replace ownani=ln(ownani)
replace density=ln(density)

gen acresXpastmg=acres*pastmg
label var acresXpastmg "Landholdings X Common Property"

*- OLS Models
reg grintens pastmg $z $x, cluster(village)
estimates store graz, title("Grazing Intensity")

reg veg pastmg $z $x, cluster(village)
estimates store veg, title("Vegetation")

reg ownani pastmg acres acresXpastmg $z $x, cluster(village)
estimates store herd, title("Herd Size")

estout graz veg herd, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) label varlabels(_cons Constant ) starlevels(* 0.1 ** 0.05 *** 0.01) stats(F r2 N, fmt(%9.3f %9.3f %9.0f) star(F) labels("F" "R-Squared" "N")) numbers collabels(,none) varwidth(30) modelwidth(20) prehead("Linear Regression Models for Group and Individual Outcomes") wrap order(pastmg acres acresXpastmg) mgroups("Cooperation" "Conflict", span pattern(1 0 1)) refcat(kinship "Group-Specific" tenure "Respondent-Specific", nolabel)

log close
