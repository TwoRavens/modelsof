
***********************************
***********************************
* REPLICATION
*
* IDEOLOGY AND STATE TERROR
* How officer beliefs shaped repression during Argentina’s ‘Dirty War’
*
* JOURNAL OF PEACE RESEARCH
*
* Author: Adam Scharpf (University of Mannheim)		   
* 	
* Date: Feb 2018		
*
* Do-File: robustcheck.do
************************************
************************************

*Loading data
use "$datapath\repdata.dta", clear

log on

************************************
*TABLE II. Negative binomial regression results for repression with continuous controls for rebel activity
************************************

*Model 4: All rebel activity 
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 nrebact
		 if army==1, cluster(area);
	#delimit cr	
	
*Model 5: Lethal rebel activity	
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 nrebactdeath
		 if army==1, cluster(area);
	#delimit cr		
	
*Model 6: Activity by known group
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 nrebactname	
		 if army==1, cluster(area);
	#delimit cr	
	
clear
