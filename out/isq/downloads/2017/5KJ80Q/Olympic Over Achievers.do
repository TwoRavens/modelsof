*********************************************************************************************************
* Do File for "Exploring the Final Frontier: An Empirical Analysis of Global Civil Space Proliferation" *
* By Bryan R. Early, University at Albany, SUNY															*
* Contact at: bearly@albany.edu    																	    *
* Last Updated: 6/17/2013																				*
*********************************************************************************************************

**Note: This provides the analysis for identifying the Olympic Over Achievers Variable**

**Medal Predictions**

**Total Medals**
nbreg medals lnPop lnrGDPpc  polity2 polity2_sq hosted time CW, robust
predict predmedals if medals!=.
gen StatusSeekerM=.
replace StatusSeekerM=0 if medals!=.
replace StatusSeekerM=1 if medals!=. &  medals> 2*predmedals & medals>=5
label var StatusSeekerM "Olympic Games Over-Achiever - Medals Operationalization"

***Filling in for the Years Spent Preparing for an Olympic Games**

sort ccode1 year
tsset ccode1 year

gen SSMprep=StatusSeekerM
by ccode1: replace SSMprep=f.SSMprep if SSMprep==.
by ccode1: replace SSMprep=f.SSMprep if SSMprep==.
by ccode1: replace SSMprep=f.SSMprep if SSMprep==.
label var SSMprep "Status Seeking Behavior - Medals Operationalization"


**Table 1, Appendix 1**

summ medals lnPop lnrGDPpc  polity2 polity2_sq hosted time CW if medals!=.

**Table 2, Appendix 1**
eststo M1: nbreg medals lnPop lnrGDPpc  polity2 polity2_sq hosted time CW, robust

esttab M1, se(2) pr2 b(2) star(* 0.10 ** 0.05 *** 0.01)
