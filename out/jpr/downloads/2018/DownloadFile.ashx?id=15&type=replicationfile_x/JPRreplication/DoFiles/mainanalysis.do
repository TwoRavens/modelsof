
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
* Do-File: mainanalysis.do
************************************
************************************

*Loading data
use "$datapath\repdata.dta", clear


************************************
*TABLE I. Negative binomial regression results for repression during Argentina’s Dirty War, 1975–81
************************************

*Model 1: Officer
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem
		  if army==1, cluster(area);
	#delimit cr


*Model 2: Area
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 if army==1, cluster(area);
	#delimit cr


*Model 3: Subzone
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr

	
log off	
clear
