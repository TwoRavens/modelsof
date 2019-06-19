log using Figure2.log, replace

***Create Premium Simulations figure
***Constructed in a few steps:
	***Estimated models for alpha
	***Run this do file

	
use Data/Figure2CostsAndAlpha.dta	
set scheme s1mono	

gen markup  = -100/(alpha*(1-0.05))
gen perfectcomppremiums = mepscosts/12
*Since alpha based on monthly premiums
gen imperfectcomppremiums = perfectcomppremiums +markup


***Both lines
twoway (line perfectcomppremiums agegroup, sort lcolor(black) lwidth(medium) lpattern(vshortdash)) (line imperfectcomppremiums agegroup, lpattern(solid) lcolor(black)) , ytitle("Monthly Premium ($)") xtitle(Age) xlabel(27 "27" 30 "30" 35 "35" 40 "40" 45 "45" 50 "50" 55 "55") legend(order(1 "Perfect Competition" 2 "Imperfect Competition" ))
graph save Results/Figure2-A.gph, replace

***Markup only
twoway (line markup agegroup, sort lcolor(black) lwidth(medium) lpattern(solid)), ytitle("Markup: $/Month") xtitle(Age) xlabel(27 "27" 30 "30" 35 "35" 40 "40" 45 "45" 50 "50" 55 "55") legend(order(1 "Markup"))
graph save Results/Figure2-B.gph, replace

graph combine "Results/Figure2-B.gph" "Results/Figure2-A.gph" , cols(1)
graph save Results/Figure2.gph, replace



log close


