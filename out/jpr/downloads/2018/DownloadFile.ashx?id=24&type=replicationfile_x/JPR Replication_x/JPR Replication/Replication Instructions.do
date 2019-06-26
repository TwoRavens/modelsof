*************************************************************************
*                                                                       * 
* Girl soldiering in rebel groups, 1989-2013: Introducing a new dataset *
*                                                                       *
* Roos Haer and Tobias Böhmelt                                          *
*                                                                       *
* Replication Instructions                                              *
*                                                                       *
* This Version: September 22, 2017                                      *
*                                                                       *
*************************************************************************

* Change to working directory *

use "G-CSDS.dta", clear

***********
* Table I *
***********

tab rgirldum 

tab rgirlord 
tab rgirlord if rgirldum==1

tab rgirlfight
tab rgirlfight if rgirldum==1
display 97/321
display 57/321

************
* Figure 1 *
************

preserve
use worlddata.dta, clear
spmap ordinal using worldcoor2.dta if admin!="Antarctica", id(id) clmethod(unique)
restore

************
* Table II *
************

logit rgirldum wopol physint islam secession terror competition small duration log_rgdpch polity2, cluster(cow)

logit rgirlfight wopol physint islam secession terror competition small duration log_rgdpch polity2, cluster(cow)

************
* Figure 2 *
************

estsimp logit rgirldum wopol physint islam secession terror competition small duration log_rgdpch polity2, cluster(cow)
setx median
simqi, fd(prval(1)) changex(wopol min max) level(90)
simqi, fd(prval(1)) changex(physint min max) level(90)
simqi, fd(prval(1)) changex(islam min max) level(90)
simqi, fd(prval(1)) changex(secession min max) level(90)
simqi, fd(prval(1)) changex(terror min max) level(90)
simqi, fd(prval(1)) changex(competition min max) level(90)
simqi, fd(prval(1)) changex(small min max) level(90)
simqi, fd(prval(1)) changex(duration min max) level(90)
simqi, fd(prval(1)) changex(log_rgdpch min max) level(90)
simqi, fd(prval(1)) changex(polity2 min max) level(90)
drop b*

preserve
logit rgirlfight wopol physint islam secession terror competition small duration log_rgdpch polity2, cluster(cow)
qui keep if e(sample)
estsimp logit rgirlfight wopol physint islam secession competition small duration log_rgdpch polity2, cluster(cow)
setx median
simqi, fd(prval(1)) changex(wopol min max) level(90)
simqi, fd(prval(1)) changex(physint min max) level(90)
simqi, fd(prval(1)) changex(islam min max) level(90)
simqi, fd(prval(1)) changex(secession min max) level(90)
simqi, fd(prval(1)) changex(competition min max) level(90)
simqi, fd(prval(1)) changex(small min max) level(90)
simqi, fd(prval(1)) changex(duration min max) level(90)
simqi, fd(prval(1)) changex(log_rgdpch min max) level(90)
simqi, fd(prval(1)) changex(polity2 min max) level(90)
drop b*
restore

preserve
use "Substantive Effects.dta", clear
twoway (scatter vertical_axis FDS if sample==1) (rcap lb ub vertical_axis if sample==1, horizontal msize(zero)) (scatter vertical_axis FDS if sample==2) (rcap lb ub vertical_axis if sample==2, horizontal msize(zero)), xline(0) legend(off) scheme(s1mono) aspectratio(1)
restore

********************
* Appendix Table I *
********************

logit rgirldum wopol physint islam secession terror competition small duration log_rgdpch median, cluster(cow)

logit rgirlfight wopol physint islam secession terror competition small duration log_rgdpch median, cluster(cow)

*********************
* Appendix Table II *
*********************

logit rgirldum women, cluster(cow)

logit rgirlfight women_combat, cluster(cow)

**********************
* Appendix Table III *
**********************

logit rgirldum forced_recruit , cluster(cow)

logit rgirlfight forced_recruit , cluster(cow)
