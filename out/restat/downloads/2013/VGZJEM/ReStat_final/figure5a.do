/*** Albouy (REStat, 2013), Figure 5a ***/
/*** Run Figure 5b first to get full Figure 5 ***/

# delimit ;

version 11.2;
set more off ;
cd c:\data\political ;

local intvars = "s_d h_d m ";
local convars = "year1970-year2003 fipsst1-fipsst56 lpop lpop2 pct* med* *_avgten *_i " ;

local years = "1985 ";
local myears = "y1985 ";

local halfint = "10";

use spend_panel_restat, replace ;

g lpop = log(pop) ;
g lpop2 = lpop^2;
g dot = hwydot+umtdot+airdot;

g d= h_d +s_d ;
g m= h_m+s_m ;

g y =  log(dot);

qui for N in num 1970 (1) 2003 : 
	g byte yearN = year==N ;

qui for N in num 
	1 2 4 5  
	8 9 10 12 13 15 16 17 18 19 20 21 22
	23 24 25 26 27 28 29 30 31 32 33 34 35 36 37
	38 39 40 41 42 44 45 46 47 48 49 50 51 53
	54 55 56 :
	g fipsstN = fipsst==N ;


drop if y==.;
drop if m==.;

save temp, replace ;

drop _all ;
input year beta low_ci hi_ci ;
. . . . . ;
end;
save estimates, replace ;



foreach Y of numlist 1975 (1) 2000 { ;

use temp, replace ;
keep if year+`halfint'>=`Y' & year-`halfint'<=`Y' ;

qui reg y  `intvars' `convars' , cluster(fipsst) ;
estimates store y`Y' ;
drop _all;
qui set obs 1 ;
g year = `Y';
mat m`Y' = e(b);
mat beta = m`Y'[1,"m"];
mat v`Y' = e(V);
mat var_beta = v`Y'["m","m"] ;
svmat beta ;
svmat var_beta;
qui append using estimates;
qui save estimates, replace ;

} ;


use estimates, replace ;
g se = sqrt(var_beta);
replace low_ci = beta1-1.96*se ;
replace hi_ci = beta1+1.96*se ;
sort year ;
g zero=0;


la var beta1 "Linear Panel Estimate";
la var low_ci "95% confidence interval";
la var year " ";

line beta1 low_ci hi_ci zero year, 
ti("Figure 5a: Majority Effect on Transportation Spending", size(3.5)) 
t2("Panel estimates over time with a 20-year window", size(2.5))
l2("Effect of House or Senate Delegation being in Majority") 
xti("") 
b2(" " "Fiscal Midyear (+/- 10 Years)")
lwidth(medthick medthick medthick medium) 
xlabel(1975(5)2000, grid)
	graphregion(fcolor(white) icolor(white) color(white))
legend( order(1 2))
lpat(solid dot dot dash) xsize(6) ysize(4)
lcolor(black black black black)
note(" " "Effect from the linear model with share of Senate and House Majority representation combined.", size(3))
saving(dotgraph.gph, replace);

graph combine dotgraph.gph dodgraph.gph,
rows(2) iscale(.7)
xsize(6.5) ysize(9) 
	graphregion(fcolor(white) icolor(white) color(white))
ti("Figure 5: Moving Panel Estimates for Longer Series", size(3.5) )
;

