
*Name: Mitch Radtke and Hyeran Jo
*Project: Fighting the Hydra (Supplemental Part IV)
*Date last Modified: 12/04/2017


*Set system directory
sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal""

*Opening up data
use "E:\Hyeran\Hydra\Data and Results\Case Studies\DRC\M23\m23.dta", clear

*Figure A12: Battles Graph

#delimit;

graph twoway line battles counter, title("M23's Weekly Battles (2012-2014)", size(medium large) color(black)) ytitle("Number of Battles", height(7)) graphr(fcolor(white)) ///
	xlabel(18993 19364 19728 20085) lcolor(black) xline(19175 19308 19322 19357 19658, lstyle(thin) lpattern(vshortdash) lcolor(black)) ///
    text(15 19160 "M23 gains Bunagana", size(vsmall) orient(vertical) nobox) text(15 19265 "Makenga Sanctioned", size(vsmall) orient(vertical) nobox)  text(15 19635 "M23 loses Bunagana", size(vsmall) orient(vertical) nobox) ///
	text(15 19285 "Security Council Resolution 2078", size(vsmall) orient(vertical) nobox)  text(15 19345 "M23 Sanctioned", size(vsmall) orient(vertical) nobox) xtitle("Week", height (5));

*Figure A13: Losses Graph
#delimit;

graph twoway line losses counter, title("M23's Weekly Losses (2012-2014)", size(medium large) color(black)) ytitle("Number of Losses", height(7)) graphr(fcolor(white)) ///
	xlabel(18993 19364 19728 20085) lcolor(black) xline(19175 19308 19322 19357 19658, lstyle(thin) lpattern(vshortdash) lcolor(black)) ///
    text(3 19150 "M23 gains Bunagana", size(vsmall) orient(vertical) nobox) text(3 19255 "Makenga Sanctioned", size(vsmall) orient(vertical) nobox)  text(3 19635 "M23 loses Bunagana", size(vsmall) orient(vertical) nobox) ///
	text(3 19275 "Security Council Resolution 2078", size(vsmall) orient(vertical) nobox)  text(3 19345 "M23 Sanctioned", size(vsmall) orient(vertical) nobox) xtitle("Week", height (5));


