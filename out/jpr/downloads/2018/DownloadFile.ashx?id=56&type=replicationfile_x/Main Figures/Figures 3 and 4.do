*Author: Mitch Radtke and Hyeran Jo 
*Project: Fighting the Hydra (Figures 3 and 4)
*Date Last Modified: October 22, 2017

*Opening up the UNITA data

use "E:\Hyeran\Hydra\Data and Results\Case Studies\UNITA\unita_rats_week.dta", clear

*Battles Graph

#delimit;

graph twoway line battles counter,  ytitle("Number of Battles", height(7)) graphr(fcolor(white)) lcolor(black) ///
	xlabel(13515 13880 14245 14610 14976 15341) xline(13817 14062 14217 14520 14541, lstyle(thin) lcolor(black) lpattern(dash)) text(35 13800 "Travel Ban Imposed" , size(vsmall) orient(vertical) nobox) ///
	text(35 14020 "Asset Freeze & Diamond Ban" , size(vsmall) orient(vertical) nobox) text(35 14175 "Civil War Resumes" , size(vsmall) orient(vertical) nobox) ///
	text(43 14370 "DeBeers Commitment" , size(vsmall) orient(vertical) nobox) text(43 14420 "Lose Central Highlands" , size(vsmall) orient(vertical) nobox) ///
	text(49 14550 "FAA Offensive" , size(vsmall) orient(horizontal) nobox) xtitle("Week", height (5)) leg(off) || rcap off_start off_end off_counter in 141/156, color(black) horizontal;
	
#Used Graph Editor to change X Axis labels; it was easier to keep dates as numbers instead of as dates for rest of code
#Steps for Changing Labels
 
#File, Start Graph Editor, Click on the X Axis, Click "Edit or add individual ticks", Edit, then type new name in label field

*Create new variable in order to have scale break 

gen losses_graphic = cond(losses== 21, 11, losses) 
   . label def losses_graphic 20 "12"
   . label val losses_graphic losses_graphic
   . label var losses_graphic losses

*Losses Graph	

#delimit;

graph twoway line losses_graphic counter, ytitle("Number of Losses", height(7)) graphr(fcolor(white)) lcolor(black) ///
	xlabel(13515 13880 14245 14610 14976 15341) yline(10, lstyle(dot)) ms(oh)  xline(13817 14062 14217 14520 14541, lstyle(thin) lcolor(black) lpattern(dash)) text(7 13800 "Travel Ban Imposed" , size(vsmall) orient(vertical) nobox) ///
	text(7 14020 "Asset Freeze & Diamond Ban" , size(vsmall) orient(vertical) nobox) text(7 14160 "Civil War Resumes" , size(vsmall) orient(vertical) nobox) ///
	text(7 14445 "DeBeers Commitment" , size(vsmall) orient(vertical) nobox) text(7 14485 "Lose Central Highlands" , size(vsmall) orient(vertical) nobox) ///
	xtitle("Week", height (5)) text(9.5 14550 "FAA Offensive" , size(vsmall) orient(horizontal) nobox) leg(off)  || rcap off_start off_end off_counter_loss in 141/156, color(black) horizontal;
 
