*Name: Mitch Radtke and Hyeran Jo
*Project: Fighting the Hydra (Supplemental Part IV)
*Date last Modified: 12/04/2017


*Set system directory
sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal""

*Opening up data

use "E:\Hyeran\Hydra\Data and Results\Case Studies\Sierra Leone\sierra_leone_rats_week.dta", clear

*Figure A10: Battles Graph

#delimit;

graph twoway line battles counter, title("RUF's Weekly Battles (Jan 1997-Dec 2001)", size(medium large) color(black)) ytitle("Number of Battles", height(7)) graphr(fcolor(white)) ///
	xlabel(13515 13880 14245 14610 14976 15341) lcolor(black) xline(13659 13792 13911 14044 14429 14730 14793 14856  15038, lstyle(thin) lpattern(vshortdash) lcolor(black)) ///
    text(20 13635 "AFRC/RUF Coup", size(vsmall) orient(vertical) nobox) text(20 13770 "Oil Embargo", size(vsmall) orient(vertical) nobox) text(26 13890 "ECOMOG Offensive", size(vsmall) orient(vertical) nobox) text(20 14010 "Targeted Sanctions on RUF", size(vsmall) orient(vertical) nobox) ///
	text(20 14400 "Lome Agreement", size(vsmall) orient(vertical) nobox)  text(20 14700 "Operation Palliser", size(vsmall) orient(vertical) nobox) ///
    text(20 14775 "Diamond Ban", size(vsmall) orient(vertical) nobox) text(20 14835 "Guinea enters into Conflict", size(vsmall) orient(vertical) nobox) text(20 15005 "Sanctions on Liberia", size(vsmall) orient(vertical) nobox) xtitle("Week", height (5));

*Figure A11: Losses Graph

#delimit;

graph twoway line losses counter, title("RUF's Weekly Losses (Jan 1997-Dec 2001)", size(medium large) color(black)) ytitle("Number of Losses", height(7)) graphr(fcolor(white)) ///
	xlabel(13515 13880 14245 14610 14976 15341) lcolor(black) xline(13659 13792 13911 14044 14429 14730 14793 14856  15038, lstyle(thin) lpattern(vshortdash) lcolor(black)) ///
    text(9 13635 "AFRC/RUF Coup", size(vsmall) orient(vertical) nobox) text(9 13770 "Oil Embargo", size(vsmall) orient(vertical) nobox) text(9 13885 "ECOMOG Offensive", size(vsmall) orient(vertical) nobox) text(9 14010 "Targeted Sanctions on RUF", size(vsmall) orient(vertical) nobox) ///
	text(9 14400 "Lome Agreement", size(vsmall) orient(vertical) nobox)  text(9 14700 "Operation Palliser", size(vsmall) orient(vertical) nobox) ///
    text(9 14775 "Diamond Ban", size(vsmall) orient(vertical) nobox) text(9 14835 "Guinea enters into Conflict", size(vsmall) orient(vertical) nobox) text(9 15005 "Sanctions on Liberia", size(vsmall) orient(vertical) nobox) xtitle("Week", height (5));
