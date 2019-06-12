****************************************************************************
**		File name:	cutoffs figure
**		Authors: 	Liran Harsgor, Orit Kedar, Raz Sheinerman
**		Date: 		Final version: August 4 2015
**		Purpose: 	Produce Figure A2					 							
**		input:		cutoffs.dta
*****************************************************************************

use "cutoffs.dta", clear
capture log using "lcutoffs.log", replace

* Produce Figure A2 mentioned in Footnote 20
twoway rcap high low district, ///
xlabel(2(1)12) ylabel(-0.1(0.1)0.6) ///
yline(0) ///
xtitle("Proportion elected in districts smaller than") ///
ytitle("Coefficient") ///
|| scatter closing district, mcolor(black) msymbol(o) ///
legend(off) scheme(s2mono) graphregion(fcolor(white))

log close
