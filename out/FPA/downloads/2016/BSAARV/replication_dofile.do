Replication file for "Public Support for Economic Sanctions: An Experimental Analysis" 
Elena V. McLean and Dwight Roblyer 
Forthcoming in Foreign Policy Analysis

use dataset_FPA.dta, replace

Table 2:
anova spt type##effect##frame

Table 3:
anova q8 type effect frame
anova q9 type effect frame
preserve
gen subj=_n
keep subj type effect frame q8 q9
reshape long q, i(subj) j(rv)
sort type effect frame subj rv
order type effect frame subj rv
anova q type effect frame rv##type rv##effect rv##frame, repeated(rv) bseunit(subj) bse(frame)
restore

Table 4:
anova spt  type#c.q7 effect#c.q7 frame#c.q7 c.q7 type effect frame

Table 5:
anova spt  type#c.q4 effect#c.q4 frame#c.q4 c.q4 type effect frame

Table 6:
corr effect q4 q7

Table 7:
probit type effect frame q7 q8
