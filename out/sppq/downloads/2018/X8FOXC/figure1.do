****************************
*All analysis in Stata 14.1*
****************************

*clear contents

clear

*load data 

use "/Users/goelzhauser/Box Sync/Research/classifying selection institutions/sppq replication/figure1.dta"

*set delimiter

#delimit;

*create Figure 1;

graph hbar included, over(state, sort(sort) gap(*1.2))
linetype(line) lines(lpattern(blank))
ytitle("Times Included", margin(medsmall))
ylabel(, nogrid)
ysize(7);

