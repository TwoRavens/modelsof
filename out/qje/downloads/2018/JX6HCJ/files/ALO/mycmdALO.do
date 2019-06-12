global cluster = "id"

use DatALO1, clear

global basic1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global basic2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 
global all1 SEX2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9
global all2 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9

global i = 1
global j = 1

*Table 3
foreach X in signup used_ssp used_adv used_fsg {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="M", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $basic2 if noshow == 0 & sex=="F", robust
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & sex=="F", robust
	}
	
*Table 5 
foreach X in grade_20059_fall GPA_year1 {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0, robust
	mycmd (ssp sfpany) reg `X' ssp sfpany $all1 if noshow == 0, robust
	}

foreach X in grade_20059_fall GPA_year1 {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group', robust
		mycmd (ssp sfpany) reg `X' ssp sfpany $all2 if noshow == 0 & group`group', robust
		}	
	}

*Table 6 
foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}	

foreach X in GPA_YEAR1 prob_year1 goodstanding_year1 credits_earned1  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all1 if noshow == 0 & C, robust
	}

foreach X in GPA_year2 prob_year2 goodstanding_year2 credits_earned2  {
	foreach group in 2 3 {
		mycmd (ssp sfp sfsp) reg `X' ssp sfp sfsp $all2 if noshow == 0 & group`group' & C, robust
		}	
	}
	
**************************************

use DatALO2, clear

global all1 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

*Table 7 
foreach group in 2 3 {
	mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp $all1  if S == 1 & group`group', cluster(id)
	foreach quantile in .1 .25 .5 .75 .9 {
		mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp $all1 if S == 1 & group`group', quantile(`quantile')
		}	
	}
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, cluster(id)
mycmd (ssp sfp sfsp) reg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, cluster(id)
foreach quantile in .1 .25 .5 .75 .9 {
	mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 HSGROUP2-HSGROUP3 if S == 1 & group3, quantile(`quantile')
	mycmd (ssp sfp sfsp) qreg GPA_year ssp sfp sfsp YEAR2 if S == 1 & group3, quantile(`quantile')
	}	

************************************************************

*Table 8 

use DatALO3, clear

global all3 MTONGUE2-MTONGUE3 HSGROUP2-HSGROUP3 NUMCOURSES2-NUMCOURSES5 LASTMIN2-LASTMIN5 MOM_EDN2-MOM_EDN9 DAD_EDN2-DAD_EDN9 YEAR2

foreach X in prob_year credits_earned GPA_year {
	mycmd (ssp_p sfp_p sfsp_p) ivreg `X' (ssp_p sfp_p sfsp_p = ssp sfsp sfp) $all3 if S == 1, robust cluster(id)
	}	


