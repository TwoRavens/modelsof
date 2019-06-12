
****************************************************************************

use DatCL, clear

*Table 7
global i = 1
reg attach_to_gr paintings chat oo within_subj, 
	estimates store M$i
	global i = $i + 1

ologit attach_to_gr paintings chat oo within_subj, 
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(date)
test paintings chat oo within_subj
matrix F = r(p), r(drop), r(df), r(chi2), 7

drop _all
svmat double F
save results/SuestCL, replace












