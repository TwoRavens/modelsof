capture log close
clear
clear mata
clear matrix
set mem 500m
set more off
graph drop _all


#delimit ;


*	************************************************************************ *;
* 	File-Name: BetasPlot.do													 *;
*	Date:  02/28/13															 *;
*	Author: 	James Hollyer                                                *;
*	Purpose:   To create plots of the difficulty and discrimination 		 *;
*	parameters from the IRT model labeled by item.							 *;
*	OS: Windows 7						 								 	 *;
*	************************************************************************ *;

*	************************************************************************ *;
*	Before doing anything, I need to extract the variable names from the     *;
*	original data fed into the IRT model.									 *;
*	************************************************************************ *;

use "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\FullWDIIRTprep2.dta";

gen varnames="";

forvalues i=1(1)240{;
	local lab: var label var_`i';
	replace varnames = "`lab'" if _n==`i';
	};

keep varnames;

drop if varnames=="";
gen varnumber=_n if varnames~="";

save "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\VariableNames.dta",
replace;

clear;

use "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\TransparencyCoefficients112313.dta";

gen varnumber=_n if discrimination~=.;

merge 1:1 varnumber using "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\VariableNames.dta";

drop _merge varnumber;

*	************************************************************************ *;
*	The following will create a set of variable codes and labels for the     *;
*	coefficient plots.														 *;
*	************************************************************************ *;

sort discrimination;

gen varnum = .;
replace varnum=1 if _n==1;
replace varnum=varnum[_n-1]+1 if _n>1;


forvalues i=1(1)240{;
	local j=varnames[_n-1+`i'];
	label define variablename `i' "`j'", add;
	label values varnum variablename;
	};

*	************************************************************************ *;
*	The following will plot difficulty and discrimination parameters for the *;
*	25 lowest discrimination scores and the 25 highest discrimination scores.*;
*	************************************************************************ *;

*Figure 4;

graph twoway (rcap discriminationlb discriminationub varnum if varnum<26, horizontal
ylabel(1(1)25, valuelabel angle(horizontal) labsize(small)) 
  aspectratio(5, placement(r))) 
(scatter varnum discrimination if varnum<26, xtitle("Coefficient Value") 
ytitle("") xline(0) msize(small) scheme(s1mono)
graphregion(fcolor(white) ilstyle(none)) legend(off) title("Discrimination", justification(right)) 
name(lowdisc) fxsize(98));

graph twoway (rcap difficultylb difficultyub varnum if varnum<26, horizontal ylabel(none)
aspectratio(5, placement(r))) 
(scatter varnum difficulty if varnum<26, xtitle(Coefficient Value) ytitle("") xline(0) msize(small) 
scheme(s1mono) graphregion(fcolor(white)) legend(off) title("Difficulty", justification(right)) 
name(lowdif));

graph combine lowdisc lowdif, ycommon title(Low Discrimination Items)
graphregion(fcolor(white)) scheme(s1mono);


*graph export "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\lowdiscplot.png",
width(1000) replace;

*Figure 3;

graph twoway (rcap discriminationlb discriminationub varnum if varnum>214, horizontal
ylabel(215(1)240, valuelabel angle(horizontal) labsize(small))
 aspectratio(5,placement(r))) (scatter varnum discrimination
if varnum>214, xtitle(Coefficient Value) ytitle("") xline(0) msize(small) scheme(s1mono)
graphregion(fcolor(white)) legend(off) title("Discrimination", justification(right)) 
name(highdisc) fxsize(98));

graph twoway (rcap difficultylb difficultyub varnum if varnum>214, horizontal ylabel(none)
aspectratio(5, placement(r)))   (scatter varnum difficulty
if varnum>214, xtitle(Coefficient Value) ytitle("") xline(0) msize(small) scheme(s1mono)
graphregion(fcolor(white)) legend(off) title("Difficulty", justification(right)) name(highdif));

graph combine highdisc highdif, title(High Discrimination Items)
graphregion(fcolor(white) ilstyle(none)) scheme(s1mono);

*graph export "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\highdiscplot.png",
width(1000) replace;

*Appendix A;

graph twoway (rcap discriminationlb discriminationub varnum if varnum<60, horizontal
ylabel(1(1)59, valuelabel angle(horizontal) labsize(small)) 
 aspectratio(12, placement(r))) 
(scatter varnum discrimination if varnum<60, xtitle("Coefficient Value") 
ytitle("") xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white) ilstyle(none)) legend(off) title("Discrimination", justification(right)) 
name(lotslowdisc) fxsize(72));

graph twoway (rcap difficultylb difficultyub varnum if varnum<60, horizontal ylabel(none)
aspectratio(12, placement(l))) (scatter varnum difficulty
if varnum<60, xtitle(Coefficient Value) ytitle("") xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white)) legend(off) title("Difficulty", justification(right)) name(lotslowdif));

graph combine lotslowdisc lotslowdif, ycommon
graphregion(fcolor(white)) scheme(s1mono) ysize(10) xsize(7) scale(0.75);

*graph export "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\lotslowdiscplot.png",
width(2000) replace;

graph twoway (rcap discriminationlb discriminationub varnum if varnum>=60 & varnum<120, horizontal
ylabel(60(1)119, valuelabel angle(horizontal) labsize(small)) 
 aspectratio(12, placement(r))) 
(scatter varnum discrimination if varnum>=60 & varnum<120, xtitle("Coefficient Value") 
ytitle("") xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white) ilstyle(none)) legend(off) title("Discrimination", justification(right)) 
name(lotsmeddisc1) fxsize(72));

graph twoway (rcap difficultylb difficultyub varnum if varnum>=60 & varnum<120, horizontal ylabel(none)
aspectratio(12, placement(l))) (scatter varnum difficulty
if varnum>=60 & varnum<120, xtitle(Coefficient Value) ytitle("") xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white)) legend(off) title("Difficulty", justification(right)) name(lotsmeddif1));

graph combine lotsmeddisc1 lotsmeddif1, ycommon
graphregion(fcolor(white)) scheme(s1mono) ysize(10) xsize(7) scale(0.75);

*graph export "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\lotsmeddiscplot1.png",
width(2000) replace;

graph twoway (rcap discriminationlb discriminationub varnum if varnum>=120 & varnum<180, horizontal
ylabel(120(1)179, valuelabel angle(horizontal) labsize(small)) 
 aspectratio(12, placement(r))) 
(scatter varnum discrimination if varnum>=120 & varnum<180, xtitle("Coefficient Value") 
ytitle("") xlabel(0(5)10) xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white) ilstyle(none)) legend(off) title("Discrimination", justification(right)) 
name(lotsmeddisc2) fxsize(72));

graph twoway (rcap difficultylb difficultyub varnum if varnum>=120 & varnum<180, horizontal ylabel(none)
aspectratio(12, placement(l))) (scatter varnum difficulty
if varnum>=120 & varnum<180, xtitle(Coefficient Value) ytitle("") xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white)) legend(off) title("Difficulty", justification(right)) name(lotsmeddif2));

graph combine lotsmeddisc2 lotsmeddif2, ycommon
graphregion(fcolor(white)) scheme(s1mono) ysize(10) xsize(7) scale(0.75);

*graph export "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\Index Properties\lotsmeddiscplot2.png",
width(2000) replace;

graph twoway (rcap discriminationlb discriminationub varnum if varnum>=180 & varnum<=240, horizontal
ylabel(180(1)240, valuelabel angle(horizontal) labsize(small)) 
 aspectratio(12, placement(r))) 
(scatter varnum discrimination if varnum>=180 & varnum<=240, xtitle("Coefficient Value") 
ytitle("")  xlabel(0(50)100) xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white) ilstyle(none)) legend(off) title("Discrimination", justification(right)) 
name(lotshighdisc) fxsize(73));

graph twoway (rcap difficultylb difficultyub varnum if varnum>=180 & varnum<=240, horizontal ylabel(none)
aspectratio(12, placement(l))) (scatter varnum difficulty
if varnum>=180 & varnum<=240, xtitle(Coefficient Value) ytitle("") xline(0) msize(tiny) scheme(s1mono)
graphregion(fcolor(white)) legend(off) title("Difficulty", justification(right)) name(lotshighdif));

graph combine lotshighdisc lotshighdif, ycommon
graphregion(fcolor(white)) scheme(s1mono) ysize(10) xsize(7) scale(0.75);

*graph export "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencyindex\PAReplicationMaterials\IndexProperties\lotshighdiscplot.png",
width(2000) replace;
