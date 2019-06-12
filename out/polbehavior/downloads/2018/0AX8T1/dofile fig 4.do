*Name: Martin Vinæs Larsen*
*Date: June 2018*
*Article: "Is the Relationship between Political Responsibility and Electoral Accountability Causal, Adaptive and Policy-specific?"*
*Reproduces: Figure 4. 
*Data: 09rep.dta (survey data from the 2009 Danish municipal election survey)*
*Machine: Work Desktop*
*Dependencies: blindschemes*

*opening 2009 municipal election survey data
use "09rep", clear

*creating temporary files for storage of AMEs
tempfile t1 t2 t3


*estimating models for municipal, regional and national level and storing estimates
logit borg_vote (c.unemp)##treat c.admin c.housing c.elderly ft_vote i.gov_may c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor govsupport logindb, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) saving(`t1') post
test _b[unemp_perf:1bn._at]=_b[unemp_perf:2._at]
local p1=r(p)
local d1=-_b[unemp_perf:1bn._at]+_b[unemp_perf:2._at]
logit reg_vote2 (c.unemp)##treat  c.admin c.housing c.elderly ft_reg c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor  logindb, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) saving(`t2') post
test _b[unemp_perf:1bn._at]=_b[unemp_perf:2._at]
local p2=r(p)
local d2=-_b[unemp_perf:1bn._at]+_b[unemp_perf:2._at]
logit natgov (c.unemp)##treat  c.admin c.housing c.elderly lft_natgov c.ideology i.localmed i.educ i.employment c.age logindv kvindpol govmayor logindb, vce(cluster muni)
margins, dydx(unemp) at(treat=(0 1)) saving(`t3') post
test _b[unemp_perf:1bn._at]=_b[unemp_perf:2._at]
local p3=r(p) 
local d3=-_b[unemp_perf:1bn._at]+_b[unemp_perf:2._at]

*merging temporary files including different AME's
use `t1', clear
append using `t2'
append using `t3'

*creating 90 pct confidence intervals
gen ub2=_margin+1.64*_se
gen lb2=_margin-1.64*_se

*adding organizing variable
gen id=_n

*storing lines for the graph
local plot1="scatteri .4 1 .4 2, recast(line) lpattern(solid) lcolor(black) ||"
local plot2="scatteri .2 1 .4 1, recast(line) lpattern(solid) lcolor(black) ||"
local plot3="scatteri .36 2 .4 2, recast(line) lpattern(solid) lcolor(black) ||"
local plot4="scatteri .35 3 .35 4, recast(line) lpattern(solid) lcolor(black) ||"
local plot5="scatteri .22 3 .35 3, recast(line) lpattern(solid) lcolor(black) ||"
local plot6="scatteri .3 4 .35 4, recast(line) lpattern(solid) lcolor(black) ||"
local plot7="scatteri .18 5 .18 6, recast(line) lpattern(solid) lcolor(black) ||"
local plot8="scatteri .13 5 .18 5, recast(line) lpattern(solid) lcolor(black) ||"
local plot9="scatteri .13 6 .18 6, recast(line) lpattern(solid) lcolor(black) ||"

*storing numbers
foreach x in 1 2 3 {
local d: di %8.2f `d`x''
local p: di %8.2f `p`x''
local descrip`x'=subinstr("d=`d', p=`p'", " ", "",. )
}


*drawing graphs
twoway ///
 `plot1'  `plot2'  `plot3'  `plot4'  `plot5'  `plot6' `plot7'  `plot8'  `plot9'   ///
 rspike _ci_lb _ci_ub id,  lwidth(medthick)  xsize(7) lcolor(black) || ///
 rspike  ub2 lb2 id,  lwidth(thick)   lcolor(black)  || ///
 || scatter  _margin id if _at==2, scheme(plotplain) mcolor(black) msym(o) msize(vlarge)   ///
|| scatter  _margin id  if _at==1, mcolor(white) msym(o) mlwidth(medthick)  mlcolor(black) msize(vlarge) ///
  ylabel(-0.1(0.1)0.5, labsize(medlarge)) ytitle("AME of Unemployment Services", size(medlarge)) ///
  yline(0, lpattern(dash)) ytick(-0.1(0.1)0.4) ymtick(-0.2(0.05)0.4) ///
   xlabel(1.5 `" "Mayoral" " party" "' 3.5 `" "Regional" "government" "' 5.5 `" "National" "government" "' , notick nogrid angle(0) labsize(medlarge)) ///
   xtitle(" ") xtick(0.5(2)6.5) legend(style(background) color(none) cols(1) position(4) bmargin(tiny) ///
order(12 13)  label(12 "Treatment") label(13 "Control") size(medlarge)) ///
text(0.45 1.5 "`descrip1'", size(medlarge)) text(0.4 3.5 "`descrip2'", size(medlarge)) text(.23 5.5 "`descrip3'" , size(medlarge))

graph export "figure4.eps", replace
