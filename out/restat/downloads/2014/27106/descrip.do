#delimit ;

log using descrip.log, replace ;

/*****

Descriptive statistics.

*****/

set mem 700m ;
set matsize 300 ;
set more off ;

use "/afs/crc.nd.edu/user/a/awaggone/Private/Private/Drugs_2011/marcps.dta" ;
*use marcps_test.dta ;

gen empdhi=1 if empd==1 & inlist(ind1,1,4,5,3,11)==1 ;
replace empdhi=0 if empd==1 & inlist(ind1,1,4,5,3,11)~=1 ;
summ empdhi ;

gen empdmid=1 if firmsizer==2 | firmsizer==3 ;
replace empdmid=0 if firmsizer==1 | firmsizer==4 ;

gen lrhw=log(rhwage) ;

gen somecoll=(edgrp4>=3) ;
replace somecoll=. if edgrp4==. ;

gen young=(age<=25) ;

* Pro and anti dummies, by state-year ;
gen pro=0 ;
replace pro=1 if (year>=yrpro & yrpro~=0) ;
gen anti=0 ;
replace anti=1 if (year>=yranti & yranti~=0) ;

gen empdlg=1 if firmsizer==4 ;
replace empdlg=0 if firmsizer==1 | firmsizer==2 | firmsizer==3 ;

gen ph=. ;
replace ph=1 if pensionr==1 | inclughr==1 ;
replace ph=0 if pensionr==0 & inclughr==0 ;
replace ph=. if pensionr==. | inclughr==. ;

sort state ;
by state: egen everanti=max(anti) ;
by state: egen everpro=max(pro) ;

summ everanti everpro ;
summ yranti if everanti==1 ;
summ yrpro if everpro==1 ;


/* Not sure weights below are right. Using pw in estimation but that's not allowed in summ, so did both here. */

* Unweighted ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti if year<=1988 ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti if everpro==1 & year<=1988 ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti if everanti==1 & year<=1988 ;

* Weighted ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti [w=wtsupp] ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti if year<=1988 [w=wtsupp] ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti if everpro==1 & year<=1988 [w=wtsupp] ;
summ year age empd empdhi empdlg rhwage lrhw hwagesamp inclughr pensionr ph female black hisp 
 somecoll young pro anti if everanti==1 & year<=1988 [w=wtsupp] ;
  
* Unweighted - by subsamples ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==1 ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==1 & year<=1988 ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==1 & everpro==1 & year<=1988 ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==1 & everanti==1 & year<=1988 ;  
   
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==0 & hisp==0 ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==0 & hisp==0 & year<=1988 ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==0 & hisp==0 & everpro==1 & year<=1988 ;
summ empd empdhi empdlg inclughr pensionr ph lrhw if black==0 & hisp==0 & everanti==1 & year<=1988 ;  
      
log close ;
clear ;  
  