
****************************************************************************

use DatCC1, clear

*Table 7 
global i = 1
probit Coop TICKET lagduration cycle2-cycle5 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2 & Period==1, 
	estimates store M$i
	global i = $i + 1

probit Coop TICKET lagduration cycle2-cycle5 periods* grimtrigger Lag1 Lag2 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2, 
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(session)
test TICKET
matrix F = r(p), r(drop), r(df), r(chi2), 7

drop _all
svmat double F
save results/SuestCC1, replace










