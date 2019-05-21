
*****************************************************************
* Replication program for Bureaucratic Investments in Expertise *
*****************************************************************

use replicationfile.dta

******TABLE 1:******************
*Cross-randomization
tab discretiontreatmentgroups informationtreatment

******TABLE 2:******************
tab shareofreporttypes, m





******TABLE 3:********************
reg shareofreporttypes discretiontreatment group1  


*******TABLE 4:*******************
reg shareofreporttypes low_discretion medium_discretion high_discretion group1


*Effect sizes
sum shareofreporttypes if no_discretion==1
sum shareofreporttypes if low_discretion==1
sum shareofreporttypes if medium_discretion==1
sum shareofreporttypes if high_discretion==1




********TABLE 5**********************:
reg shareofreporttypes wellbeingtoppriority low_discretion Lowdiscretion_toppriority ///
	medium_discretion Mediumdiscretion_toppriority high_discretion Highdiscretion_toppriority group1

*F-test 
test Lowdiscretion_toppriority Mediumdiscretion_toppriority Highdiscretion_toppriority
	


********TABLE 6:********************
reg shareofreporttypes informationtreatment //Yes, significant




*SUPPLEMENTARY INFORMATION
********TABLE S4:*************************
logit anyreport discretiontreatment group1 

logit anyreport low_discretion medium_discretion high_discretion group1



*********TABLE S5:*************************
reg reporttypes3 informationtreatment

ologit reporttypes3 informationtreatment

reg shareofreporttypes3 informationtreatment


*********TABLE S6:***********
reg shareofreporttypes low_discretion medium_discretion high_discretion informationtreatment group1


*********TABLE S7:*************************


reg shareofreporttypes discretiontreatment group1
reg std_shareofreport discretiontreatment group1

reg shareofreporttypes low_discretion medium_discretion high_discretion group1
reg std_shareofreport low_discretion medium_discretion high_discretion group1


reg shareofreporttypes  wellbeingtoppriority ///
	low_discretion Lowdiscretion_toppriority ///
	medium_discretion           Mediumdiscretion_toppriority ///
	high_discretion        Highdiscretion_toppriority ///
	group1

reg std_shareofreport  wellbeingtoppriority ///
	low_discretion Lowdiscretion_toppriority ///
	medium_discretion           Mediumdiscretion_toppriority ///
	high_discretion          Highdiscretion_toppriority ///
	group1

reg shareofreporttypes informationtreatment
reg std_shareofreport informationtreatment



