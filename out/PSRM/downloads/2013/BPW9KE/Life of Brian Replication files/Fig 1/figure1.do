/***********************************************************
************************************************************
** Alexander Baturo and Slava Mikhaylov (2013). "Life of Brian Revisited: Assessing Informational and Non-Informational Leadership Tools." Political Science Research and Methods, 2013, 1(1): 139-157.
** Replication files
************************************************************
**  Figure 1
************************************************************
************************************************************/

use fig1, clear

sort speechdate
 
 
twoway (scatter score_nof speechdate, msize(vsmall) mcolor(green) ) (line Putin speechdate, yaxis(2) lcolor(red) lpattern(vshortdash)) (line Medvedev speechdate, yaxis(2) lcolor(blue) lpattern(longdash_shortdash)) (lpoly score_nof speechdate, lcolor(magenta) lwidth(thick)) if speechdate>=17846, ytitle(Raw wordscores) ytitle("Perceived influence" "expert survey scores", axis(2)) xtitle("")  xlabel(17841 18213 18596  18894  19120, labsize(vsmall)) yline(0,lcolor(red)) scheme(s1mono)  legend(on order(1 "Speeches by regional leaders" 2 "Fitted local regression" 3 "Putin perceived influence" 4 "Medvedev perceived influence") cols(2) size(small) color(black) region(lcolor(white)) position(5) span) graphregion(lcolor(black))

