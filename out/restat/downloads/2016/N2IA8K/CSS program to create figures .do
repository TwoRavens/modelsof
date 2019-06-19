
set more off

global dir  "enter path name here/CSS_REStat_2016"

/*
RE Stat guidelines
FIGURES: THE JOURNAL IS PRINTED IN BLACK AND WHITE.
 Titles/legends/captions should be double-spaced.
 Titles/legends/captions should be in 12 pt. font.
 Figures should be in black and white.
 Each figure should be on a page.
*/

/*
Figure 1

Relationship between test size and feasible number of clusters (G*A) 
for a simulation model with only a binary regressor (p=0.5) with five 
different ways of treating the error term (homoskedastic error, 
het error with c=0.9, het error with c=90, t-dist error (df of 4), 
log normal error)
*/



use "$dir/CSS_sim_testsize.dta", clear
merge m:1 design using "$dir/groupsizes.dta"

*just binary regressor
keep if xtype==1

twoway scatter tsize effclusters_CSS_BOUND_med  if type==1, mcolor(gs0) m(O) mlw(vthin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==2, mcolor(gs0) m(T) mlw(vthin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==3, mcolor(gs0) m(D) mlw(vthin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==4, mcolor(gs0) m(Oh) mlw(vthin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==5, mcolor(gs0) m(Sh) mlw(vthin) msize(small) || ///
,  yline(0.05, lcolor(black) lwidth(medium)) ylabel(0(0.05)0.45) ///
legend(cols(2) colfirst order(1 2 3 4 5) label(1 "Homosk. Error") label(2 "Low Het. Error") label(3 "High Het. Error") ///
 label(4 "T-dist Error") label(5 "Log Normal Error")) ///
 ytitle("Empirical Test Size") xtitle("Feasible Effective Number of Clusters")  ///
 graphregion(color(white)) bgcolor(white) ysize(4) text(, size(4.16))
 graph export "$dir/Figure1.eps", replace
  graph export "$dir/Figure1.png", replace
   graph export "$dir/Figure1.pdf", replace
    graph export "$dir/Figure1.tif", replace
	
	
/*
Figure 2

Relationship between effective number of clusters (G*) and the 
cluster size coefficient of variation for a simulation model 
with only a binary regressor (p=0.5) with three subfigures: 

	(2a, top center) low heteroskedasticity case (c=0.9) and plot with a point 
		at the median G* for 1000 simulations over each design and a bar displaying 
		the range between min and max. This plot would include an indicator for 
		the coefficient of variation for our empirical examples. 
	(2b, lower left) same as 2a but with c=90
	(2c, lower right) same as 2a but with c=0 (homoskedastic case)
*/


use "$dir/CSS_sim.dta", clear
keep if xtype==1

merge m:1 design using "$dir/groupsizes.dta"

*create an extra obs to label on graph for US state coef of var and two empirical examples predict effective clusters (interpretation?)
*US state: *coef of var = 1.1112077 (closest to design 122)
set obs 508
replace coef_var=1.1112077 in 506
*Krueger: *coef of variation=0.2196834 (closest to design 6)
replace coef_var=0.2196834 in 507
*Hersh: *coef of variation = 1.7609651 (closest 
replace coef_var=1.7609651 in 508
gen exlabel="US States Pop Dist, CV=1.11" if _n==506
replace exlabel="Krueger (1999), CV=0.22" if _n==507
replace exlabel="Hersh (1998), CV=1.76" if _n==508

replace type=1 if inrange(_n,506,508)
sort type coef_var
ipolate effclusters_CSS_med coef_var if type==1, gen(ipolate)
replace ipolate=. if effclusters_CSS_med~=.

twoway rbar effclusters_CSS_med effclusters_CSS_min coef_var if type==1, bcolor(gs8) barw(0.01) lcolor(black) || ///
rbar effclusters_CSS_med effclusters_CSS_max coef_var if type==1, bcolor(gs8)  barw(0.01) lcolor(black) || ///
scatter effclusters_CSS_med  coef_var if type==1, m(Oh) msize(small) mcolor(black)   || ///
scatter effclusters_CSS_med  coef_var if type==2, m(Th) msize(small) mcolor(black) mlw(thin)   || ///
scatter effclusters_CSS_med  coef_var if type==3, m(Dh) msize(small) mcolor(black) mlw(thin)   || ///
pcarrowi 98.575386 2 98.575386 0.07 (3) "balanced: 20 obs per group", mlabsize(vsmall) mcolor(black) mlc(black) mlw(thin) lw(thin) lc(black) lp(dash) || ///
pcarrowi 30 4 10 4 (9) "unbalanced: 1015 obs in 1 group, 15 obs in 99 groups", mlabsize(vsmall) mcolor(black) mlcolor(black) mlw(thin) lw(thin) lc(black) lp(dash) || ///
pcarrowi 30 4 2 4 (9) , mlabsize(vsmall) mcolor(black) mlcolor(black) mlw(thin) lw(thin) lc(black) lp(dash) || ///
pcarrowi 75 2 75 0.21968 (3) "Krueger (1999), CV=0.22", mlabsize(vsmall) mlabc(gs0) mc(gs0) mlc(gs0) mlw(thin) lc(gs0) lw(thin) lp(dash) || ///
pcarrowi 55 2 55 1.1112077 (3) "US States Pop Dist, CV=1.11", mlabsize(vsmall) mlabc(gs0) mc(gs0) mlc(gs0) mlw(thin) lc(gs0) lw(thin) lp(dash) || ///
pcarrowi 65 2 65 1.7609651 (3) "Hersh (1998), CV=1.76", mlabsize(vsmall) mlabc(gs0) mc(gs0) mlc(gs0) mlw(thin) lc(gs0) lw(thin) lp(dash) || ///
, xlabel(0(0.25)4) ylabel(0(10)100) ///
xline(0.2196834, lcolor(gs0) lw(vthin)) ///
xline(1.1112077, lcolor(gs0) lw(vthin)) ///
xline(1.7609651, lcolor(gs0) lw(vthin)) ///
ytitle("Effective Number of Clusters", size(large)) xtitle("Cluster Size Coefficient of Variation (CV)", size(large))  scheme(sj) saving(x1, replace) ///
 graphregion(color(white)) bgcolor(white) ///
 legend(cols(2) colfirst order(3 2 4 5) label(3 "Homosk. Error") label(2 "Min-Max Range") label(4 "Low Het. Error") label(5 "High Het. Error") symy(1) symx(2)) ///
ysize(4) xsize(6) text(, size(4.16))
  graph export "$dir/Figure2.eps", replace
  graph export "$dir/Figure2.png", replace
   graph export "$dir/Figure2.pdf", replace
    graph export "$dir/Figure2.tif", replace

	
	
	
/*
Figure 4
Relationship between test size and feasible number of clusters (G*A) 
for a simulation model with only a continuous regressor. The figure would 
include points representing the test size over 1000 simulations for each 
cluster size design for the following scenarios:

X(gi)=z(g)+z(gi)
c=0
c=0.9
c=90
T-dist
Log normal

X(gi)=sqrt(2)*z(gi)
c=0
c=0.9
c=90
T-dist
Log normal
*/	
	

	
use "$dir/CSS_sim_testsize.dta", clear
merge m:1 design using "$dir/groupsizes.dta"

gen tlabel="T"
gen llabel="L"
*continuous group-invariant regressor
keep if xtype==2

twoway scatter tsize effclusters_CSS_BOUND_med  if type==1, m(Oh) mcolor(black) mlw(thin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==2, mcolor(black) m(Th) mlw(thin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==3, mcolor(black) m(Dh) mlw(thin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==4, mcolor(black) m(th) mlw(vthin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==5, mcolor(black) m(sh) mlw(vthin) msize(small)   || ///
, title("Xig=Xg")   yline(0.05, lcolor(black) lwidth(medium)) ylabel(0(0.1)0.6) ///
legend(cols(1) colfirst order(1 2 3 4 5) label(1 "Homosk. Error") label(2 "Low Het. Error") label(3 "High Het. Error") ///
 label(4 "T-dist Error") label(5 "Log Normal Error")) ///
 ytitle("Empirical Test Size") xtitle("Feasible Effective Number of Clusters")  ///
 graphregion(color(white)) bgcolor(white) saving(a, replace)

use "$dir/CSS_sim_testsize.dta", clear
merge m:1 design using "$dir/groupsizes.dta"

*continuous group-invariant regressor
keep if xtype==3

twoway scatter tsize effclusters_CSS_BOUND_med  if type==1, m(Oh) mcolor(black) mlw(thin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==2, mcolor(black) m(Th) mlw(thin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==3, mcolor(black) m(Dh) mlw(thin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==4, mcolor(black) m(th) mlw(vthin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==5, mcolor(black) m(sh) mlw(vthin) msize(small)   || ///
,  title("Xig=Xi+Xg")  yline(0.05, lcolor(black) lwidth(medium)) ylabel(0(0.1)0.6) ///
legend(cols(1) colfirst order(1 2 3 4 5) label(1 "Homosk. Error") label(2 "Low Het. Error") label(3 "High Het. Error") ///
 label(4 "T-dist Error") label(5 "Log Normal Error")) ///
 ytitle("Empirical Test Size") xtitle("Feasible Effective Number of Clusters")  ///
 graphregion(color(white)) bgcolor(white) saving(b, replace)

		
use "$dir/CSS_sim_testsize.dta", clear
merge m:1 design using "$dir/groupsizes.dta"

*continuous group-invariant regressor
keep if xtype==4

twoway scatter tsize effclusters_CSS_BOUND_med  if type==1, m(Oh) mcolor(black) mlw(thin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==2, mcolor(black) m(Th) mlw(thin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==3, mcolor(black) m(Dh) mlw(thin) msize(small)  || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==4, mcolor(black) m(th) mlw(vthin) msize(small) || ///
scatter tsize effclusters_CSS_BOUND_med  if  type==5, mcolor(black) m(sh) mlw(vthin) msize(small)   || ///
,  title("Xig=Xi")  yline(0.05, lcolor(black) lwidth(medium)) ylabel(0(0.1)0.6) ///
legend(cols(1) colfirst order(1 2 3 4 5) label(1 "Homosk. Error") label(2 "Low Het. Error") label(3 "High Het. Error") ///
 label(4 "T-dist Error") label(5 "Log Normal Error")) ///
 ytitle("Empirical Test Size") xtitle("Feasible Effective Number of Clusters")  ///
 graphregion(color(white)) bgcolor(white) saving(c, replace)

 
 
 grc1leg a.gph b.gph c.gph, row(2) legendfrom(c.gph) position(5) ring(0) graphregion(color(white)) 
	
	  graph export "$dir/Figure4.eps", replace
  graph export "$dir/Figure4.png", replace
   graph export "$dir/Figure4.pdf", replace
    graph export "$dir/Figure4.tif", replace
	
