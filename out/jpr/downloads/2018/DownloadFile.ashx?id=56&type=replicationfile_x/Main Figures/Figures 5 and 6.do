*Author: Mitch Radtke and Hyeran Jo 
*Project: Fighting the Hydra (Figures 5 and 6)
*Date Last Modified: October 22, 2017

*Opening up the Al-Shabaab data

use "E:\Hyeran\Hydra\Data and Results\Case Studies\Somalia\somalia_rats_week_new.dta", clear

*Battles Graph

#delimit;

graph twoway line battles counter,  ytitle("Number of Battles", height(7)) graphr(fcolor(white)) lcolor(black) ///
	xlabel(17532 18263 18993 19724) xline(17856 18202 18254 18461 19045 19224 19267, lstyle(thin) lcolor(black) lpattern(dash)) text(21 17835 "First UN Sanctions" , size(vsmall) orient(vertical) nobox) ///
	text(21 18140 "Gained Full Control of Kismayo" , size(vsmall) orient(vertical) nobox) ///
	text(21 18180 "UN Sanctions on Eritrea" , size(vsmall) orient(vertical) nobox) text(21 18410 "UN Sanctions on Al-Shabaab" , size(vsmall) orient(vertical) nobox)  ///
	 text(21 19015 "Charcoal Ban" , size(vsmall) orient(vertical) nobox) text(21 19110 "Permanent Govt. Forms" , size(vsmall) orient(vertical) nobox) text(21 19150 "Lost Kismayo" , size(vsmall) orient(vertical) nobox)  ///
	xtitle("Week", height (5));
	
#Used Graph Editor to change X Axis labels; it was easier to keep dates as numbers instead of as dates for rest of code
#Steps for Changing Labels
 
#File, Start Graph Editor, Click on the X Axis, Click "Edit or add individual ticks", Edit, then type new name in label field

*Losses Graph 

#delimit;

graph twoway line losses counter,ytitle("Number of Territories Lost", height(7))  graphr(fcolor(white)) lcolor(black) ///
	xlabel(17532 18263 18993 19724) xline(17856 18202 18254 18461 19045 19224 19267, lstyle(thin) lcolor(black) lpattern(dash)) text(3 17835 "First UN Sanctions" , size(vsmall) orient(vertical) nobox) ///
    text(3 18140 "Gain Full Control of Kismayo" , size(vsmall) orient(vertical) nobox) ///
	text(3 18180 "UN Sanctions on Eritrea" , size(vsmall) orient(vertical) nobox) text(3 18410 "Sanctions on Al-Shabaab" , size(vsmall) orient(vertical) nobox)  ///
    text(3 19015 "Charcoal Ban" , size(vsmall) orient(vertical) nobox) text(4.5 19195 "Lost Kismayo" , size(vsmall) orient(vertical) nobox)  ///
	text(4.5 19155 "Permanent Government Forms" , size(vsmall) orient(vertical) nobox) xtitle("Week", height (5));

