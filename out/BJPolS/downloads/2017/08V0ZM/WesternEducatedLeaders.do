* ============================================================================================================
* Replication Do-File for Article "Are Western Educated Leaders Less Prone to Initiate Militarized Disputes?"
* by Joan Barcelo, 24.06.2017
* ============================================================================================================

cd "[filepath]"
use "ReplicationData3.dta", clear

* FIGURE 4 
* =======

tab westedu cwinit, row

* ==================================================
* TABLES 1 and 2
* ==================================================


**Warning: Some models may take time to run in some computers

* TABLE 1
* =======

* Model 1

xtmelogit cwinit westedu2 || leaderid: , var mle

* Model 2

xtmelogit cwinit westedu2 i.year|| ccode: || leaderid:, var mle

* Model 3

xtmelogit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service i.year|| ccode: || leaderid:, var mle

* Model 4

xtmelogit cwinit westedu2 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store Model4

* Model 5

logit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year
mat a = e(b)
mat a1 = (a, 0, 0)

xtmelogit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle from(a1, skip)
estimates store Model5

* Model 6

xtmelogit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp i.warwin i.warloss cinc logstudentflowthousand i.year i.ccode || leaderid:, var mle
estimates store Model6

* TABLE 2 
* =======

use "E:\~Joan Barcelo\~Present\~Washington U. in STL (PhD Political Science)\4th term\Comparative Political Parties\Research Paper\3. Data\matched_dataset.dta", clear

ttest cwinit, by (westedu2)

reg cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand, vce(cluster leaderid )
	 
estimates store Model1_match_controls

logit cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand, vce(cluster leaderid )		 

estimates store Model2_match_controls

logit cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand i.year, vce(cluster leaderid )

estimates store Model3_match_controls

logit cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand i.year i.ccode, vce(cluster leaderid )

estimates store Model4_match_controls

use "E:\~Joan Barcelo\~Present\~Washington U. in STL (PhD Political Science)\4th term\Comparative Political Parties\Research Paper\3. Data\master.dta" 


* ==================================================
* Online Appendix: Tables
* ==================================================

* TABLE B
* =======

* Model B1

xtmelogit cwinit2 westedu2 || leaderid: , var mle
estimates store ModelB1

* Model B2

xtmelogit cwinit2 westedu2 i.year|| ccode: || leaderid:, var mle
estimates store ModelB2

* Model B3

xtmelogit cwinit2 westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service i.year|| ccode: || leaderid:, var mle
estimates store ModelB3

* Model B4
logit cwinit2 westedu2 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year
mat a = e(b)
mat a1 = (a, 0, 0)

xtmelogit cwinit2 westedu2 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle from (a1, skip)
estimates store ModelB4

* Model B5
logit cwinit2 westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year
mat a = e(b)
mat a1 = (a, 0, 0)

xtmelogit cwinit2 westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle from(a1, skip)
estimates store ModelB5

* Model B6
logit cwinit2 westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year i.ccode

mat a = e(b)
mat a1 = (a, 0, 0)

xtmelogit cwinit2 westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp i.warwin i.warloss cinc logstudentflowthousand i.year i.ccode || leaderid:, var mle from(a1, skip)
estimates store ModelB6

* TABLE C 
* =======

* Model C1

xtmelogit cwinit demedu1 || leaderid: , var mle
estimates store ModelC1

* Model C2

xtmelogit cwinit demedu1 i.year|| ccode: || leaderid:, var mle
estimates store ModelC2

* Model C3

xtmelogit cwinit demedu1 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service i.year|| ccode: || leaderid:, var mle
estimates store ModelC3

* Model C4

xtmelogit cwinit demedu1 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store ModelC4

* Model C5

xtmelogit cwinit demedu1 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store ModelC5

* Model C6

xtmelogit cwinit demedu1 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp i.warwin i.warloss cinc logstudentflowthousand i.year i.ccode || leaderid:, var mle
estimates store ModelC6

* TABLE D 
* =======

* Model D1

xtmelogit cwinit demedu2 || leaderid: , var mle
estimates store ModelD1

* Model D2

xtmelogit cwinit demedu2 i.year|| ccode: || leaderid:, var mle
estimates store ModelD2

* Model D3

xtmelogit cwinit demedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service i.year|| ccode: || leaderid:, var mle
estimates store ModelD3

* Model D4

xtmelogit cwinit demedu2 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store ModelD4

* Model D5

xtmelogit cwinit demedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store ModelD5

* Model D6

xtmelogit cwinit demedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp i.warwin i.warloss cinc logstudentflowthousand i.year i.ccode || leaderid:, var mle
estimates store ModelD6

* TABLE E 
* =======

* Model E1

xtmelogit cwinit demedu3 || leaderid: , var mle
estimates store ModelE1

* Model E2

xtmelogit cwinit demedu3 i.year|| ccode: || leaderid:, var mle
estimates store ModelE2

* Model E3

xtmelogit cwinit demedu3 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service i.year|| ccode: || leaderid:, var mle
estimates store ModelE3

* Model E4

xtmelogit2 cwinit demedu3 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store ModelE4

* Model E5

xtmelogit cwinit demedu3 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x i.year|| ccode: || leaderid:, var mle
estimates store ModelE5

* Model E6

xtmelogit cwinit demedu3 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp i.warwin i.warloss cinc logstudentflowthousand i.year i.ccode || leaderid:, var mle
estimates store ModelE6

* TABLE F 
* =======

use "E:\~Joan Barcelo\~Present\~Washington U. in STL (PhD Political Science)\4th term\Comparative Political Parties\Research Paper\3. Data\matched_dataset1.dta", clear

reg cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand, vce(cluster leaderid )

estimates store ModelF1

logit cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand, vce(cluster leaderid )

estimates store ModelF2

logit cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand i.year, vce(cluster leaderid )

estimates store ModelF3

logit cwinit westedu2 polity2pre logcgdp logethn warwin warloss cinc colony_dummy min_dist_x businesspeople bluecollar military lawyers religious scientist gentry service i.leveledu logstudentflowthousand i.ccode, vce(cluster leaderid )

estimates store ModelF4

* TABLE G
* =======

xtmelogit cwinit westedu2 t t2 t3|| leaderid: , var mle

xtmelogit cwinit westedu2 t t2 t3 || ccode: || leaderid:, var mle

xtmelogit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service t t2 t3|| ccode: || leaderid:, var mle

xtmelogit cwinit westedu2 polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x  t t2 t3|| ccode: || leaderid:, var mle

xtmelogit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x  t t2 t3|| ccode: || leaderid:, var mle

xtmelogit cwinit westedu2 i.leveledu i.foredu i.uni_top i.businesspeople i.gentry i.bluecollar i.military i.lawyers i.religious i.scientist i.service polity2pre logcgdp logethn i.warwin i.warloss cinc logstudentflowthousand i.colony_dummy min_dist_x  t t2 t3 i.ccode || leaderid:, var mle
