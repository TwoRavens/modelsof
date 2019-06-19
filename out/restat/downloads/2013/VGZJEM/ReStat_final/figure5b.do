/*** Albouy (REStat, 2013), Figure 5b ***/
/* Run before Figure 5a command to get combined figure 5 */

# delimit ;

version 11.2;
set more off ;
cd c:\data\political ;

local intvars = "d m ";
local convars = "year1960-year2003 fipsst1-fipsst56 lpop lpop2 pct* med* *_avgten *_i " ;

local years = "1975 1980 1985 1990 1995 2000 ";
local myears = "y1975 y1980 y1985 y1990 y1995 y2000 ";
local halfint = "10";


use spend_panel_restat, replace ;

g mil = pcdod + swdodmil ;
g swdod = swdodmil + swdodciv ;
g dod = swdod + pcdod ;
g lpop = log(pop) ;
g lpop2 = lpop^2 ;

g d= h_d +s_d ;
g m= h_m+s_m ;

g y =  log(dod);

qui for N in num 1960 (1) 2003 : 
	g byte yearN = year==N ;

qui for N in num 
	1 2 4 5  
	8 9 10 12 13 15 16 17 18 19 20 21 22
	23 24 25 26 27 28 29 30 31 32 33 34 35 36 37
	38 39 40 41 42 44 45 46 47 48 49 50 51 53
	54 55 56 :
	g fipsstN = fipsst==N ;

for N in num 1 2:
g fNdeml = fracNdem*(fracNdem<.5) \
g fNdemr = fracNdem*(fracNdem>=.5) \
g fNdeml2 = fNdeml^2 \
g fNdemr2 = fNdemr^2 \
g fNdem1 = fracNdem \
g fNdem2 = fracNdem^2 \
g fNdem3 = fracNdem^3 \
g fNdem4 = fracNdem^4 \
g fNdem_0 = fracNdem==0 \
g fNdem_1 = fracNdem==1 ;

local polydem = "f1dem1 f1dem2 f1dem3 f1dem4 f1dem_0 f1dem_1 f2dem1 f2dem2 f2dem3 f2dem4 f2dem_0 f2dem_1" ;


drop if y==.;
drop if m==.;


save temp, replace ;

drop _all ;
input year beta1 low_ci hi_ci betard1 low_cird hi_cird ;
. . . . . . . . ;
end;
save estimates, replace ;

foreach Y of numlist 1975 (1) 2000 { ;

use temp, replace ;
keep if year+`halfint'>=`Y' & year-`halfint'<=`Y' ;
drop if year<1970;
qui reg y `convars' `intvars', cluster(fipsst) ;
estimates store y`Y' ;
mat d`Y' = e(b);
mat beta = d`Y'[1,"d"];
mat v`Y' = e(V);
mat var_beta = v`Y'["d","d"] ;
qui reg y `convars' `intvars' `polydem', cluster(fipsst) ;
estimates store y`Y'rd ;
mat d`Y'rd = e(b);
mat betard = d`Y'rd[1,"d"];
mat v`Y'rd = e(V);
mat var_betard = v`Y'rd["d","d"] ;
drop _all;
qui set obs 1 ;
g year = `Y';
svmat beta ;
svmat var_beta;
svmat betard;
svmat var_betard;

qui append using estimates;
qui save estimates, replace ;

} ;


use estimates, replace ;
g se = sqrt(var_beta1);
replace beta1 = -beta1;
replace low_ci = beta1-invttail(50,.025)*se ;
replace hi_ci = beta1+invttail(50,.025)*se ;

g serd = sqrt(var_betard);
replace betard1 = -betard1;
replace low_cird = betard1-invttail(50,.025)*serd ;
replace hi_cird = betard1+invttail(50,.025)*serd ;

sort year ;
g zero=0;


la var beta1 "Linear Panel Estimate";
la var low_ci "95% confidence interval";

la var betard1 "RD Estimate";
la var low_cird "RD 95% confidence interval";

la var year " ";


line beta1 low_ci hi_ci zero year, 
lwidth(medthick medthick medthick medium) 
lcolor(black black black black)
xtick(1975(5)2000, grid)
xlabel(1975(5)2000)
	graphregion(fcolor(white) icolor(white) color(white))
l2("Effect of House or Senate Delegation being Republican") 
b2("Fiscal Midyear (+/- 10 Years)")
ti("Figure 5b: Republican Effect for Defense Spending", size(3.5)) 
t2("Panel estimates over time with a 20-year window", size(2.5))
legend( order(1 2))
 lpat(solid dot dot dash) xsize(6) ysize(4) 
lcolor(black black black black)
note(" " "Effect from the linear model with share of Senate and House Republican representation combined.", size(3))
saving(dodgraph.gph, replace) 
;



estimates table `myears', keep(`intvars')  b(%5.3f)  star(.1 .05 .01);
estimates drop _all ;

