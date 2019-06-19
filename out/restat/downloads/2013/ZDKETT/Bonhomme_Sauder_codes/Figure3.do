*******  This program computes Quantile Treatment Effects for 2 or 3 endowments ********
*******  Figure 3 in the paper ********

******* The program uses Stata 10, with the Mata extension ********


clear
clear mata 
set mem 300m
set more off

cd D:\Dossiers\Stata\Inequality


** Prepare output


set obs 99
gen tau=.
local j=2
while `j'<=3{
gen est`j'=.
gen low`j'=.
gen up`j'=.
local j=`j'+1
}

save figure3, replace


** Start loop on the number of instruments B

scalar B=2
while B<=3{

do Figure3util

scalar B=B+1
}

use figure3, clear




scalar B=2
while B<=3{

local B=B

#delimit ;
twoway  
(line est`B' tau, lcolor(black) lpattern(solid) lwidth(medium)) 
(line low`B' tau, lcolor(black) lpattern(dash) lwidth(thin)) 
(line up`B' tau, lcolor(black) lpattern(dash) lwidth(thin))
if abs(tau-.5)<=.49,
 ysc(r(-5 5))
 yline(0)
 ytitle(quantile treatment effect) 
 xtitle(percentile) 
legend(order(1 "point estimate" 2 "+/- 2 standard errors") size(medsmall)) scheme(s1mono);
*graph export "/Users/uli/Desktop/phdchapters/comp/submission/revision mai 2008/revision oct 2008/test1.pdf",  preview(on) replace;
 #delimit cr

sleep 1000

scalar B=B+1
}








