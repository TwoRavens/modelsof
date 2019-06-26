

*********************************************************************************
*	Replication of analysis for 												*
*	"Forecasting the Onset of Genocide and Politicide: 							*
*	Annual Out-of-Sample Forecasts on a Global Dataset, 1989-2004"				*
*	Goldsmith, Butcher, Semenovich & Sowmya										*
*	JPR, Tables 1, 2,3, and robustness checks.									*
*	These files compiled 7 January 2013.										*
*********************************************************************************

#del;

***N.B.: users must supply directory name in which data file is stored after "cd" (change directory) command;

clear;

cd "C:\yourdirectoryhere";

use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


*****TABLE 1*********



#del;

sort year;

set more off;

****N.B. year of onset is year t [table 1 also includes end year, found in the data file and original data source];

list statename year if fgenpolonsetd==1;



*****TABLE 2 **********;

#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   

predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;

#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;

drop pmarg_IS;


 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 
predict pmarg_OOS if year >=1988 & year <2004;


#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



****above analysis without imputed data:


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 & impute01~=1, vce(cluster ccode);
   
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 & impute01~=1, graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 & impute01~=1, graph summary;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 & impute01~=1, vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988 & impute01~=1;


#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 & impute01~=1, graph summary;

drop pmarg_IS;


****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 & impute01~=1, vce(cluster ccode);
 
predict pmarg_OOS if year >=1988 & year <2004 & impute01~=1;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004 & impute01~=1, graph summary level(90);

drop pmarg_OOS pr_instab ;


*************************Drop variables sequentially from 1st stage (instability model, assess differences in AUC for both stages);



**drop instability, stage 1;



#del;

set more off;

probit finstability   RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   

predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);

predict pmarg_IS if year > 1973 & year < 1988;

#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;


****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 
predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop RulingEliteEthnicity, stage 1;

#del;

set more off;

probit finstability instability  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
   

predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;



#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;


#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;


 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 

predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



**drop _prefailstab, stage 1;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   

predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;


#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;

 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 

predict pmarg_OOS if year >=1988 & year <2004;


#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop polity2sq_inv, stage 1;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab         
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;

#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;


****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 

predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop regchange1to3 , stage 1;

#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
 lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;


#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;

drop pmarg_IS;

****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 

predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;

**drop lIMR, stage 1;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3     lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;


#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;


****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 
predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop lAssassinDum, stage 1;

#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR     
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;

#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;

drop pmarg_IS;

 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 
predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop lntotalpop , stage 1;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
   ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);

predict pmarg_IS if year > 1973 & year < 1988;

#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;


****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 

predict pmarg_OOS if year >=1988 & year <2004;

#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop ef , stage 1;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      
predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);


predict pmarg_IS if year > 1973 & year < 1988;


#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;

 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 

predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;







**drop efNELDAperiod, stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef  NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;





**drop NELDAperiod , stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;





**drop nac , stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;







**drop mena , stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
  csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;







**drop csasia , stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;






**drop SLDdum, stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia   stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;







**drop stabyrs, stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum   stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;



#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


**drop stabyrs2, stage 1;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs  if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


*************************Drop 2nd stage variables from both models (where relevant), assess change in AUC in-sample (IS) and out-of-sample (OOS);


****in-sample

#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;



***drop _prefailgp  


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd     RulingEliteEthnicity     AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;

 
***drop RulingEliteEthnicity 


#del;

set more off;

probit finstability instability  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;



***drop AssassinDum


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity       lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop lAssassinDum [both stages]


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR    
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop fNELDAperiod


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
      exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;






#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod     FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop FDexuncHDB_cc


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc    humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop humdefburCC


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop SLDdum [both stages]


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia   stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
      ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop ef [both stages]


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum      fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop fullaut


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef  partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop partaut


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut  partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab;



***drop partdem


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut  regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;

 
 
***drop regchange1to3


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem  NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;

 
 
***drop NUMIGO


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;

  

 
***drop nogpyrs2


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 
  nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;

 
 
***drop nogpyrs3


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod  nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2  pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;

 
 
***drop pr_instab


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3  if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;

 
 
***full model


#del;

set more off;

probit finstability instability RulingEliteEthnicity  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year< 1988 , graph summary;


 drop pmarg_IS pr_instab ;


*******************Out of Sample AUC change for 2nd stage/both stages (where relevant);



***drop _prefailgp


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd         AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;
 
 

***drop RulingEliteEthnicity


#del;

set more off;

probit finstability instability  
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;


***drop AssassinDum


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity       lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop lAssassinDum [both stages]


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR    
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop fNELDAperiod


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
      exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;






#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod     FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop FDexuncHDB_cc


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc    humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop humdefburCC


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop SLDdum [both stages]


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia   stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
      ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop ef [both stages]


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum      fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop fullaut


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef  partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop partaut


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity      AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut  partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


 drop pmarg_OOS pr_instab;



***drop partdem


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut  regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;

 
 
***drop regchange1to3


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem  NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;

 
 
***drop NUMIGO


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;

 
 
***drop nogpyrs2


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
  nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;

 
 
***drop nogpyrs3


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod  nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2  pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;

 
 
***drop pr_instab


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3  if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;

 
 
***full model


#del;

set more off;

probit finstability instability RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

#del;

set more off;

probit    fgenpolonsetd   _prefailgp RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>= 1988 , graph summary;


drop pmarg_OOS pr_instab;





**********************TABLE 3******************




***year-on-year forecasts ;


#del;

set more off;

sort year statename;


#del;

list  ccode statename year if fgenpolonsetd==1, noobs  separator(10);


***for years 1988 through 2003 (forecasting genocides at t+1, so beginning with genocide onsets in 1989)


***year==1988


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1988 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1988 , vce(cluster ccode);


predictnl pr_1988 = predict() if year ==1988;

gsort -pr_1988;

#del; 

roctab fgenpolonsetd pr_1988 if year==1988 , graph summary;



***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1988~=. & pr_1988 > .012, noobs  separator(10);


list year statename fgenpolonsetd  pr_1988  if  pr_1988~=. & pr_1988 > .012, noobs  separator(10);




drop pr_instab;

drop pr_1988 ;




***year==1989


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1989 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1989 , vce(cluster ccode);


predictnl pr_1989 = predict() if year ==1989;

gsort -pr_1989;

#del; 

roctab fgenpolonsetd pr_1989 if year==1989 , graph summary;


#del;


***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1989~=. & pr_1989 > .0001, noobs  separator(10);


list year statename fgenpolonsetd  pr_1989 if  pr_1989~=. & pr_1989 > .0001, noobs  separator(10);




drop pr_instab;

drop pr_1989   ;





***year==1990

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1990 , vce(cluster ccode);
      


predict pr_instab ;

  


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1990 , vce(cluster ccode);


predictnl pr_1990 = predict() if year ==1990;

gsort -pr_1990;

#del; 

*roctab fgenpolonsetd pr_1990 if year==1990 , graph summary;





#del;





***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1990~=. & pr_1990 > .022, noobs  separator(10);


list year statename fgenpolonsetd  pr_1990  if  pr_1990~=. & pr_1990 > .022, noobs  separator(10);




drop pr_instab;

drop pr_1990  ;






***year==1991

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1991 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1991 , vce(cluster ccode);


predictnl pr_1991 = predict() if year ==1991;

gsort -pr_1991;

#del; 

*roctab fgenpolonsetd pr_1991 if year==1991 , graph summary;





#del;


***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1991~=. & pr_1991 > .019, noobs  separator(10);


list year statename fgenpolonsetd  pr_1991  if  pr_1991~=. & pr_1991 > .019, noobs  separator(10);




drop pr_instab;

drop pr_1991  ;


***year==1992


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1992 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1992 , vce(cluster ccode);


predictnl pr_1992 = predict() if year ==1992;

gsort -pr_1992;

#del; 

roctab fgenpolonsetd pr_1992 if year==1992 , graph summary;





#del;




***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1992~=. & pr_1992 > .0002, noobs  separator(10);


list year statename fgenpolonsetd  pr_1992  if  pr_1992~=. & pr_1992 > .0002, noobs  separator(10);




drop pr_instab;

drop pr_1992  ;



***year==1993


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1993 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1993 , vce(cluster ccode);


predictnl pr_1993 = predict() if year ==1993;

gsort -pr_1993;

#del; 

roctab fgenpolonsetd pr_1993 if year==1993 , graph summary;







***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1993~=. & pr_1993 > .002, noobs  separator(10);


list year statename fgenpolonsetd  pr_1993  if  pr_1993~=. & pr_1993 > .002, noobs  separator(10);




drop pr_instab;

drop pr_1993  ;



***year==1994

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1994 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1994 , vce(cluster ccode);


predictnl pr_1994 = predict() if year ==1994;

gsort -pr_1994;

#del; 

roctab fgenpolonsetd pr_1994 if year==1994 , graph summary;






***model's predictions,  ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1994~=. & pr_1994 > .025, noobs  separator(10);


list year statename fgenpolonsetd  pr_1994 if  pr_1994~=. & pr_1994 > .025, noobs  separator(10);




drop pr_instab;

drop pr_1994  ;



***year==1995


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1995 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1995 , vce(cluster ccode);


predictnl pr_1995 = predict() if year ==1995;

gsort -pr_1995;

#del; 

*roctab fgenpolonsetd pr_1995 if year==1995 , graph summary;







***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1995~=. & pr_1995 > .027, noobs  separator(10);


list year statename fgenpolonsetd  pr_1995  if  pr_1995~=. & pr_1995 > .027, noobs  separator(10);




drop pr_instab;

drop pr_1995  ;



***year==1996

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1996 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1996 , vce(cluster ccode);


predictnl pr_1996 = predict() if year ==1996;

gsort -pr_1996;

#del; 

*roctab fgenpolonsetd pr_1996 if year==1996 , graph summary;







***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1996~=. & pr_1996 > .033, noobs  separator(10);


list year statename fgenpolonsetd  pr_1996  if  pr_1996~=. & pr_1996 > .033, noobs  separator(10);




drop pr_instab;

drop pr_1996 ;



***year==1997 [onset]


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1997 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1997 , vce(cluster ccode);


predictnl pr_1997 = predict() if year ==1997;

gsort -pr_1997;

#del; 

roctab fgenpolonsetd pr_1997 if year==1997 , graph summary;






***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1997~=. & pr_1997 > .013, noobs  separator(10);


list year statename fgenpolonsetd  pr_1997  if  pr_1997~=. & pr_1997 > .013, noobs  separator(10);




drop pr_instab;

drop pr_1997  ;




***year==1998 [onset]


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1998 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1998 , vce(cluster ccode);


predictnl pr_1998 = predict() if year ==1998;

gsort -pr_1998;

#del; 

roctab fgenpolonsetd pr_1998 if year==1998 , graph summary;




***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1998~=. & pr_1998 > .00003, noobs  separator(10);


list year statename fgenpolonsetd  pr_1998  if  pr_1998~=. & pr_1998 > .00003, noobs  separator(10);




drop pr_instab;

drop pr_1998 ;



***year==1999

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 1999 , vce(cluster ccode);
      


predict pr_instab ;

   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 1999 , vce(cluster ccode);


predictnl pr_1999 = predict() if year ==1999;

gsort -pr_1999;

#del; 

*roctab fgenpolonsetd pr_1999 if year==1999 , graph summary;





***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_1999~=. & pr_1999 > .012, noobs  separator(10);


list year statename fgenpolonsetd  pr_1999  if  pr_1999~=. & pr_1999 > .012, noobs  separator(10);




drop pr_instab;

drop pr_1999  ;



***year==2000

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 2000 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 2000 , vce(cluster ccode);


predictnl pr_2000 = predict() if year ==2000;

gsort -pr_2000;

#del; 

*roctab fgenpolonsetd pr_2000 if year==2000 , graph summary;





***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_2000~=. & pr_2000 > .012, noobs  separator(10);


list year statename fgenpolonsetd  pr_2000  if  pr_2000~=. & pr_2000 > .012, noobs  separator(10);




drop pr_instab;

drop pr_2000  ;



***year==2001

#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 2001 , vce(cluster ccode);
      


predict pr_instab ;

   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 2001 , vce(cluster ccode);


predictnl pr_2001 = predict() if year ==2001;

gsort -pr_2001;

#del; 

*roctab fgenpolonsetd pr_2001 if year==2001 , graph summary;





***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_2001~=. & pr_2001 > .011, noobs  separator(10);


list year statename fgenpolonsetd  pr_2001  if  pr_2001~=. & pr_2001 > .011, noobs  separator(10);




drop pr_instab;

drop pr_2001  ;



***year==2002


#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 2002 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 2002 , vce(cluster ccode);


predictnl pr_2002 = predict() if year ==2002;

gsort -pr_2002;

#del; 

*roctab fgenpolonsetd pr_2002 if year==2002 , graph summary;





***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_2002~=. & pr_2002 > .004, noobs  separator(10);


list year statename fgenpolonsetd  pr_2002  if  pr_2002~=. & pr_2002 > .004, noobs  separator(10);




drop pr_instab;

drop pr_2002  ;




***year==2003 [onset]



#del;

set more off;

probit finstability instability  RulingEliteEthnicity 
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop ef efNELDAperiod NELDAperiod    nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year < 2003 , vce(cluster ccode);
      


predict pr_instab ;


   


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity    AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year < 2003 , vce(cluster ccode);


predictnl pr_2003 = predict() if year ==2003;

gsort -pr_2003;

#del; 

roctab fgenpolonsetd pr_2003 if year==2003 , graph summary;






***model's predictions ;

#del;

list ccode year statename fgenpolonsetd  fgenpold genpold  if  pr_2003~=. & pr_2003 > .005, noobs  separator(10);


list year statename fgenpolonsetd  pr_2003  if  pr_2003~=. & pr_2003 > .005, noobs  separator(10);




drop pr_instab;

drop pr_2003  ;




























******************robustness check***********************************************************************************************


*******drop onsets one by one

****all years

***N.B.: users must supply directory name in which data file is stored after "cd" (change directory) at the beginning of each section dropping a case from the analysis;

#del;

clear;

cd "C:\yourdirectoryhere";

use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988, vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



*******drop Angola     540   1975

#del;

clear;

cd "C:\yourdirectoryhere";

use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;

drop if year==1975 & ccode==540;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988, vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988, vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988, vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;




*******drop Indonesia     850   1975

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1975 & ccode==850;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



*******drop  Cambodia     811   1975

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1975 & ccode==811;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;





*******drop  Argentina     160   1976

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1976 & ccode==160;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;






*******drop Ethiopia     530   1976

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1976 & ccode==530;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Democratic Republic of the Congo     490   1977 

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1977 & ccode==490;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



*******drop Guatemala      90   1978

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1978 & ccode==90;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop  Myanmar     775   1978

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1978 & ccode==775;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop  Afghanistan     700   1978

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1978 & ccode==700;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;




*******drop Uganda     500   1980

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1980 & ccode==500;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;




*******drop El Salvador      92   1980

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1980 & ccode==92;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop  Iran     630   1981

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1981 & ccode==630;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



*******drop  Syria     652   1981

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1981 & ccode==652;










#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Sudan     625   1983

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1983 & ccode==625;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Zimbabwe     552   1983 

#del;

clear;

cd "C:\yourdirectoryhere";



use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;

drop if year==1983 & ccode==552;





#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


*******drop Iraq     645   1988

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1988 & ccode==645;



#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Somalia     520   1988

#del;

clear;

cd "C:\yourdirectoryhere";



use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1988 & ccode==520;





#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Burundi     516   1988

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1988 & ccode==516;





#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Sri Lanka     780   1989 

#del;

clear;

cd "C:\yourdirectoryhere";



use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1989 & ccode==780;


#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



*******drop Bosnia and Herzegovina     346   1992

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1992 & ccode==346;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;



*******drop Burundi     516   1993

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1993 & ccode==516;





#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;





*******drop Rwanda     517   1994

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1994 & ccode==517;





#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop Democratic Republic of the Congo     490   1997

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1997 & ccode==490;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;




*******drop Angola     540   1998

#del;

clear;

cd "C:\yourdirectoryhere";



use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1998 & ccode==540;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;




*******drop Yugoslavia     345   1998

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==1998 & ccode==345;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;



 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 



predict pmarg_OOS if year >=1988 & year <2004;



#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;








*******drop  Sudan     625   2003

#del;

clear;

cd "C:\yourdirectoryhere";


use "GBSSgenocideforecastingdatasetJPR2013.dta", clear;


drop if year==2003 & ccode==625;




#del;

set more off;

probit finstability instability  RulingEliteEthnicity
_prefailstab    polity2sq_inv     
regchange1to3  lIMR   lAssassinDum  
  lntotalpop  ef efNELDAperiod NELDAperiod   nac 
mena   csasia SLDdum  stabyrs stabyrs2 if year > 1973 & year < 1988 , vce(cluster ccode);
   
      



predict pr_instab ;

roctab finstability pr_instab if year > 1973 & year< 1988 , graph summary;

roctab finstability pr_instab if year >= 1988 & year< 2004 , graph summary;


#del;

set more off;

probit    fgenpolonsetd   _prefailgp   RulingEliteEthnicity   AssassinDum lAssassinDum  
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);




predict pmarg_IS if year > 1973 & year < 1988;



#del; 

roctab fgenpolonsetd pmarg_IS if year > 1973 & year< 1988 , graph summary;


drop pmarg_IS;

 
****forecasting post 1988 based on up to 1988,

#del;

set more off;

probit    fgenpolonsetd   _prefailgp    RulingEliteEthnicity  AssassinDum lAssassinDum 
  fNELDAperiod    exuncHDB_cc FDexuncHDB_cc   humdefburCC 
  SLDdum     ef fullaut partaut partdem regchange1to3 NUMIGO 
 nogpyrs2 nogpyrs3 pr_instab if year > 1973 & year < 1988 , vce(cluster ccode);
 
predict pmarg_OOS if year >=1988 & year <2004;


#del; 

roctab fgenpolonsetd pmarg_OOS if year>=1988 & year <2004, graph summary level(90);

drop pmarg_OOS pr_instab ;


clear;
