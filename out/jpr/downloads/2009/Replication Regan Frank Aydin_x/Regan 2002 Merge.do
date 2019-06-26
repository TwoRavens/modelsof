/**************************************************************/
/*                                                            */
/*               Do File for Merging                          */ 
/*   Regan et al.'s (2009)Diplomatic Interventions Dataset    */
/*           with Regan (2002) Military and                   */
/*           Economic Interventions Dataset                   */
/*                                                            */
/**************************************************************/

/* paste pathway for Regan (2002) below */

use "replication.10.26.01.dta", clear


/* paste pathway for the Diplomatic Interventions dataset below */

append using "diplomaticinterventions.dta"

sort conflict time

gen str2 strttempmnth= substr(startdate, 1,index (startdate, "/")-1)

gen str2 strttempyr = substr(startdate, -2, .)

destring strttempmnth, replace
destring strttempyr, replace

gen yrmo = (strttempyr*100) + strttempmnth
replace _yearmo=yrmo if _yearmo==.

replace opposing=0 if conflict==conflict[_n-1]
replace neutral=0 if conflict==conflict[_n-1]
replace opp=0 if conflict==conflict[_n-1] & diplomatic==1
replace govt=0 if conflict==conflict[_n-1] & diplomatic==1
replace govt=0 if conflict==conflict[_n-1]& diplomatic==1
replace target=0 if conflict==conflict[_n-1]& diplomatic==1
replace died=died[_n-1] if conflict==conflict[_n-1] & _yearmo==_yearmo[_n-1] & diplomatic==1
replace group1=group1[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
replace group2=group2[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
replace group3=group3[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
replace group4=group4[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
replace refugees=refugees[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
replace coldwar=coldwar[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace typeIden=typeIden[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace fatal=fatal[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace sizeopp=sizeopp[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace military=0 if diplomatic==1
replace economic=0 if diplomatic==1
replace ethnic_=ethnic_[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace ethn_nam=ethn_nam[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace troops=0 if diplomatic==1
replace navy=0 if diplomatic==1
replace equip=0 if diplomatic==1
replace intel=0 if diplomatic==1
replace airforce=0 if diplomatic==1
replace credit=0 if diplomatic==1
replace relief=0 if diplomatic==1
replace sanction=0 if diplomatic==1
replace force=0 if diplomatic==1
replace avefrac=avefrac[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace ideology=ideology[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace religion=religion[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace ethnic=ethnic[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace intense=intense[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace avemnth=avemnth[_n-1] if conflict==conflict[_n-1] & diplomatic==1
replace milint=0 if diplomatic==1
replace econint=0 if diplomatic==1
replace govmil=0 if diplomatic==1
replace govecon=0 if diplomatic==1
replace oppmil=0 if diplomatic==1
replace neutmil=0 if diplomatic==1
replace neutecon=0 if diplomatic==1
replace grant=0 if diplomatic==1
replace loan=0 if diplomatic==1
replace aid=0 if diplomatic==1















