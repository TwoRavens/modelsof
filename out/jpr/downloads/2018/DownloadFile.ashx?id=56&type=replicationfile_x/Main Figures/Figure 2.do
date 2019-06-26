*Author: Mitch Radtke and Hyeran Jo 
*Project: Fighting the Hydra (Figure 2)
*Date Last Modified: December 1, 2017


*Opening up the Data
use "E:\Hyeran\Hydra\RR2\Replication\Data\RadtkeJo_JPR_Macro.dta", clear

*Set system directory

sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal"

***Effect size is going to be based on the fixed effect--try to keep that as close possible to the median value for the medium group (191) and only one obs for id. 
*PUK was the best I could do for high adaptability. Effect for high adaptablity likely overestimated a bit. 

twoway (scatter effect n, mcolor(black)) (rcap upper lower n, lcolor(black) vertical) if _n<=3, xtitle("Rebel Adaptability", height (5)) ytitle("Change in Predicted Battle Deaths", height(7)) graphr(fcolor(white)) xlabel(0 ""  1 "Low" 2 "Medium" 3 "High" 4 "") legend(off)


