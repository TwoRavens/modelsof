**************************

 *Yearly replication JPR*
 *Kaisa Hinkkainen & Joakim Kreutz*
 
 *Last edited 24.02.2018
 
 *All estimations performed using Stata/SE 15.1 

**************************

use grid_month.dta

*****

* Table IV - Interrupted Time Series Regression


nbreg best_est c.talkstime2 i.talks i.talks#c.postintervention if talkstime>-4 & talkstime<4, cluster(priogrid_gid) 
est store ITS1
nbreg best_est c.talkstime2 i.talks i.talks#c.postintervention if talkstime>-7 & talkstime<7, cluster(priogrid_gid)
est store ITS2
nbreg best_est c.talkstime2 i.talks i.talks#c.postintervention if talkstime>-10 & talkstime<10, cluster(priogrid_gid)
est store ITS3
nbreg best_est c.talkstime2 i.talks i.talks#c.postintervention, cluster(priogrid_gid)
est store ITS4

esttab ITS1 ITS2 ITS3 ITS4 using tableITS1.tex


* Figure 3 - Different-in-difference regressions

xtnbreg best_est resources##talks if talkstime>-4 & talkstime<4, exposure(priogrid_gid) fe irr
est store A
xtnbreg best_est resources##talks if talkstime>-7 & talkstime<7, exposure(priogrid_gid) fe irr
est store B
xtnbreg best_est resources##talks if talkstime>-10 & talkstime<10, exposure(priogrid_gid) fe irr
est store C
xtnbreg best_est resources##talks, exposure(priogrid_gid) fe irr
est store D

coefplot (A, label(+/- 3 months) msymbol(O) mcolor(black) mfcolor(white)) (B, label (+/- 6 months) msymbol(T) mcolor(black) mfcolor(white)) (C, label(+/- 9 months) msymbol(S) mcolor(black) mfcolor(white)) (D, label(+/-12 months) msymbol(D) mcolor(black) mfcolor(white)), drop(_cons) byopts(xrescale) ciopts(lwidth(*2) lcolor(black)) graphregion(fcolor(white)) lcolor(black) grid(between glcolor(black) glpattern(dot)) xline(0, lcolor(black) lwidth(thin) lpattern(dash))

