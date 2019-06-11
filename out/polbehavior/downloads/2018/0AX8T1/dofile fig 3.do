*Name: Martin Vinæs Larsen*
*Date: June 2018*
*Article: "Is the Relationship between Political Responsibility and Electoral Accountability Causal, Adaptive and Policy-specific?"*
*Reproduces: Figure 3 (difference in difference analysis)* 
*Data: reppool.dta (Pooled data from the 2005 and 2009 municipal election surveys)*
*Version 15.1*
*Dependencies: blindschemes*


*loading pooled muncipal election survey dataset
use reppool.dta, clear

*estimating modified difference in difference model.
logit borg_vote ((treatment)##c.unemp_perf##(year)  c.housing c.elderly)##amal gov_may, vce(cluster muni)

*creatubg temorary files where AMEs can be saved
tempfile t

*saving marginal effects in temporary file
margins, dydx(unemp_perf) at(year=(2005 2009) treatment=(0 1) ) post saving (`t', replace) noestimcheck 
test 3._at 1bn._at
local a=round(r(p),.01)
test 4._at 2._at
local b=round(r(p),.01)
test 4._at-2._at=3._at-1bn._at

*opening file with stored AME's 
use `t', clear

*reorganizing data so that we can make the graph
recode _at (2=3) (3=2)

*generating 90 pct confidence intervals
gen _ci_l2=-_se*1.64+_margin
gen _ci_u2=_se*1.64+_margin

*saving lines for the graph 
local plot1="scatteri 0.4 1 .4 2, recast(line) lpattern(solid) lcolor(black) ||"
local plot2="scatteri 0.35 1 .4 1, recast(line) lpattern(solid) lcolor(black) ||"
local plot3="scatteri 0.37 2 .4 2, recast(line) lpattern(solid) lcolor(black) ||"
local plot4="scatteri 0.6 3 .6 4, recast(line) lpattern(solid) lcolor(black) ||"
local plot5="scatteri 0.45 3 .6 3, recast(line) lpattern(solid) lcolor(black) ||"
local plot6="scatteri 0.57 4 .6 4, recast(line) lpattern(solid) lcolor(black) ||"
local plot7="scatteri 0.72 1.5 0.72 3.5, recast(line) lpattern(solid) lcolor(black) ||"
local plot8="scatteri 0.67 3.5 0.72 3.5, recast(line) lpattern(solid) lcolor(black) ||"
local plot9="scatteri 0.5 1.5 0.72 1.5, recast(line) lpattern(solid) lcolor(black) "

*drawing graph
twoway rspike  _ci_lb _ci_ub _at , lcolor(black)  lwidth(medthick) || ///
rspike  _ci_l2 _ci_u2 _at , lcolor(black) lwidth(thick)  || ///
scatter  _margin _at if _at ==1 | _at==3, msize(vlarge) msym(O)  mlwidth(medthick)  mfcolor(white) mlcolor(black) || ///
scatter  _margin _at if _at ==2 | _at==4, msize(vlarge) msym(O) mlwidth(medthick) mfcolor(black) mlcolor(black) || ///
`plot1' `plot2' `plot3' `plot4' `plot5' `plot6' `plot7' `plot8' `plot9' ///
ylab(-0.1(0.1)0.85, labsize(medlarge)) scheme(plotplain) lcolor(black) ///
yline(0) xtick(0.9 2.5 4.1) xlabel(1.5 `" " " "        2005 (pre-treatment)" "' 3.5 `" " " "2009 (post-treatment)        " "', notick labsize(medlarge) nogrid) ///
ytitle("AME of Unemployment Performance", size(medlarge)) xtitle(" ") xsize(7) ///
legend(bmargin(o) order(4 3) label(3 "Control") size(medlarge) label(4 "Treatment")) ///
text(0.43 1.5 "D=0.00, p=0.20", size(medlarge)) text(0.63 3.5 "D=0.20, p<0.01", size(medlarge)) ///
text(0.75 2.5 "DiD=0.20, p<0.1", size(medlarge))

*exporting graph
graph export "figure3.eps", replace






