* this do file replicates most of the results in Table 1 from Siminski (2013) 'Employment Effects of Army Service and Veterans’ Compensation: Evidence from the Australian Vietnam-Era Conscription Lotteries' The Review of Economics and Statistics 95(1): 87–97

* the omitted results (i.e. days of service in Vietnam & died in Vietnam) were derived from restricted access data which cannot be easily summarised into a usable form that could be provided to other users.

use first_stage, clear
tabstat armserv vietnam [fw=fweight], by(ballot)
tab ballot [fw=fweight]

use second_stage_employ_census, clear
tabstat emp [fw=fweight], by(ballot)
tab ballot [fw=fweight]

use second_stage_disability_census, clear
tabstat disab [fw=fweight], by(ballot)

use second_stage_schooling_census, clear
g postschool = max(degree,trade)
tabstat degree postschool [fw=fweight], by(ballot)

use second_stage_tax_returns.dta, clear
tabstat employed l_earn09 [w=wt09], by(ballot)
tab ballot [fw=wt09]
tabstat employed l_earn93 [w=wt93], by(ballot)
tab ballot [fw=wt93]
