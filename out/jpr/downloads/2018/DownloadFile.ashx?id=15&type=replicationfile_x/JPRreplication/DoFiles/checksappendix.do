
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
* Do-File: checksappendix.do
************************************
************************************

*Loading data
use "$datapath\repdata.dta", clear


************************************
*TABLE A.II. Summary statistics
************************************
#delimit ;
		sum	nvictims ndisappear nexecut
			cavalry infantry artillery communications engineering
			rankhigh homedeploy polcon offmerit oem 
			experience comdur multunits
			planrepprop samegarr armmatprop
			baprov capfed santafe cordoba tucuman 
			d_nrebact d_nrebactdeath d_nrebactname
			nrebact nrebactdeath nrebactname
			if army==1;
#delimit cr 


************************************
*TABLE A.III. Negative binomial regression results for repression with binary controls for rebel activity
************************************

*Model 7: All Rebel Activity
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 d_nrebact
		 if army==1, cluster(area);
	#delimit cr	

*Model 8: Lethal Rebel Activity
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 d_nrebactdeath
		 if army==1, cluster(area);
	#delimit cr	
	
*Model 9: Activity by Known Group
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 d_nrebactname	
		 if army==1, cluster(area);
	#delimit cr	


************************************
*TABLE A.IV. Negative binomial regression results for repression with controls for rebel hot spots
************************************

*Model 10: Buenos Aires Prov.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 baprov 
		 if army==1, robust;
	#delimit cr

*Model 11: Buenos Aires Cap.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 baprov capfed
		 if army==1, robust;
	#delimit cr
	
*Model 12: Santa Fe Prov.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 baprov capfed santafe
		 if army==1, robust;
	#delimit cr	

*Model 13: Cordoba Prov.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 baprov capfed santafe cordoba
		 if army==1, robust;
	#delimit cr

*Model 14: Tucuman Prov.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 baprov capfed santafe cordoba tucuman
		 if army==1, robust;
	#delimit cr	


************************************
*TABLE A.V. Negative binomial regression results with measure for favoritism and individual merit
************************************

*Model 15: Capability
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem offmerit
		  if army==1, cluster(area);
	#delimit cr

*Model 16: Capability
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem offmerit
		 experience comdur multunits
		 if army==1, cluster(area);
	#delimit cr
	
*Model 17: Capability
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem offmerit
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr


************************************
*TABLE A.VI. Negative binomial regression results for repression with fixed effects for areas with branch changes
************************************

*Model 18: Branch Changes FE
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem
		  areabrchangedum1-areabrchangedum12
		  if army==1, robust;
	#delimit cr
	
*Model 19: Branch Changes FE
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 areabrchangedum1-areabrchangedum12
		 if army==1, robust;
	#delimit cr	
	
*Model 20: Branch Changes FE
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 areabrchangedum1-areabrchangedum12
		 if army==1, robust;
	#delimit cr


************************************
*TABLE A.VII. Negative binomial regression results when excluding areas with branch changes
************************************

*Model 21: w/o Branch Changes
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem
		 if army==1 & areabranchchange!=1, cluster(area);
	#delimit cr

*Model 22: w/o Branch Changes	
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 if army==1 & areabranchchange!=1, cluster(area);
	#delimit cr
	
*Model 23: w/o Branch Changes	
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1 & areabranchchange!=1, cluster(area);
	#delimit cr


************************************
*TABLE A.VIII. Negative binomial regression results for different types of repression
************************************

*Model 24: Disappearances
	#delimit ;
	nbreg ndisappear
		 infantry artillery communications engineering 
		 rankhigh homedeploy polcon oem  
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr
	
*Model 25: Executions
	#delimit ;
	nbreg nexecut
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem  
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr


************************************
*TABLE A.IX. Negative binomial regression results without last commanding area officer
************************************

*Model 26: w/o Last Officer
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem
		  if army==1 & exttime==0, cluster(area);
	#delimit cr

*Model 27: w/o Last Officer
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering 
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 if army==1 & exttime==0, cluster(area);
	#delimit cr
	
*Model 28: w/o Last Officer
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering 
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1 & exttime==0, cluster(area);
	#delimit cr


************************************
*TABLE A.X. Negative binomial regression results with random samples of zero repression observations
************************************

*Distributions of zeros by armybranch
gen dnvictims=0 if nvictims==0
replace dnvictims=1 if nvictims>0

tab armybranch dnvictims, row 
	
*Identifying zeros in dependent variable	
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1, cluster(area);
	#delimit cr	
gen zerosample=1 if e(sample) & nvictims==0	
tab zerosample

*Drawing for each zero a random number and then divide zeros in four equally sized groups	
set seed 138572
gen zerorandomval=floor((111-1+1)*runiform() + 1) if zerosample==1
egen zerogroup=cut(zerorandomval), group(4)


*Model 29-32: Using zeros of each group
forval i=0/3 {
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1 & zerogroup==`i' | zerogroup==., cluster(area);
	#delimit cr
	disp "Number of non-zero values in model"
	count if e(sample) & nvictims>0
	disp "Number of zero values in model"
	count if e(sample) & nvictims==0
	hist nvictims if e(sample), freq bin(20)
}

capture graph close

************************************
*TABLE A.XI. Negative binomial regression results with normal and robust standard errors
************************************

*Model 33: Normal S.E.
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem
		  if army==1;
	#delimit cr

*Model 34: Normal S.E.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 if army==1;
	#delimit cr
	
*Model 35: Normal S.E.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1;
	#delimit cr

*Model 36: Robust S.E.
	#delimit ;
	nbreg nvictims
		  infantry artillery communications engineering
		  rankhigh polcon oem
		  if army==1,robust;
	#delimit cr

*Model 37: Robust S.E.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 if army==1,robust;
	#delimit cr
	
*Model 38: Robust S.E.
	#delimit ;
	nbreg nvictims
		 infantry artillery communications engineering
		 rankhigh homedeploy polcon oem 
		 experience comdur multunits
		 planrepprop samegarr armmatprop
		 if army==1,robust;
	#delimit cr

	
log off	
clear

