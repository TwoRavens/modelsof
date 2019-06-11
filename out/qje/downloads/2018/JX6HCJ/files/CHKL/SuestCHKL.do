
****************************************************************************

use DatCHKL, clear

*Table 7 

global i = 1
tobit post_rating dumconf dumnetb pre_rating, ll 
	estimates store M$i
	global i = $i + 1
	
tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
	estimates store M$i
	global i = $i + 1

tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3
test dumconf dumnetb
matrix F = r(p), r(drop), r(df), r(chi2), 7

drop _all
svmat double F
save results/SuestCHKL, replace










