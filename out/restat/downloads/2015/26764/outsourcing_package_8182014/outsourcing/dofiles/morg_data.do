#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~;
set mem 5000m;

capture log close;
*log using $path/research/outsourcing/logfiles/morg_data.log, replace;

/*==============================================================
 Program: morg_data.do
 Author:  Avi Ebenstein
 Created: June 2007
 Purpose: Pool together annual CEPR CPS MORG files and
          keep only those employed or unemployed
          (excluding those not in labor force),
          age 16-64. I use a consistent variable
          for years of education provided by CEPR, and assign
          the workers consistent occupation and
          industry codes. The occupation is used to gather
          info on the skill mix, and one can map SIC to
          The resulting data set is saved as morg_data.dta,
          and the manufacturing subset is morg_man7090.dta.
==============================================================*/

/*
gen a=1;
set obs 1;
forvalues year=1979/2002{;
cd ~/data/cps/morg/datafiles/;
!                     rm    ~/data/cps/morg/datafiles/cepr_org_`year'.dta -f;
!                     unzip $path/data/cps/morg/datafiles/cepr_org_`year'_dta.zip;                      
                    };
*/
  
*******************************************************************************;
* Assign occupation, industry, and skills of workers consistently across years ;
*******************************************************************************;
/*
forvalues year=1979/2002{;
                            use $path/data/cps/morg/datafiles/cepr_org_`year'.dta, clear;
                         
                            tab year;

                            if `year'>=1979 & `year'<=1982{;
                                                       sort occ70;
                                                       merge occ70 using $path/research/outsourcing/autor/dot91-70;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                       
                                                       sort ind70;
                                                       merge ind70 using $path/research/outsourcing/autor/ind70;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                     };

                            if `year'>=1983 & `year'<=1991{;
                                                       sort occ80;
                                                       merge occ80 using $path/research/outsourcing/autor/occ80;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;

                                                       sort occ8090;
                                                       merge occ8090 using $path/research/outsourcing/autor/dot91-8090;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                       
                                                       sort ind80;
                                                       merge ind80 using $path/research/outsourcing/autor/ind80;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                     };

                            if `year'>=1992 & `year'<=2002{;
                                                       capture rename occ80 occ90;
                                                       sort occ90;
                                                       merge occ90 using $path/research/outsourcing/autor/occ90;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                                     
                                                       sort occ8090;
                                                       merge occ8090 using $path/research/outsourcing/autor/dot91-8090;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                                     
                                                       capture rename ind80 ind90;
                                                       sort ind90;
                                                       merge ind90 using $path/research/outsourcing/autor/ind90;
                                                       tab _merge;
                                                       keep if _merge==1|_merge==3;
                                                       drop _merge;
                                                     };
!                                                     rm $path/data/cps/morg/datafiles/cepr_org_`year'.dta, replace;
                                                      save $path/research/outsourcing/datafiles/morg`year', replace;
                       };
*/
  
*****************************;
*  Bring in individual years ;
*****************************;

*use $path/data/cps/morg/datafiles/morg1979;
*for num 1980/2002: append using $path/data/cps/morg/datafiles/morgX;

use $path/research/outsourcing/datafiles/morg1979;
for num 1980/2002: append using $path/research/outsourcing/datafiles/morgX;

*save $path/data/cps/morg/datafiles/temp, replace;
*use $path/data/cps/morg/datafiles/temp,clear;

*********************;
* Education in years ;
*********************;

gen yrsed=0;
replace yrsed=10 if educ==1;
replace yrsed=12 if educ==2;
replace yrsed=13 if educ==3;
replace yrsed=16 if educ==4;
replace yrsed=18 if educ==5;

*********************;
* Experience in years;
*********************;

gen exper=max(age-yrsed-6,0);
gen exper2=exper*exper;
egen expercat=cut(exper), at(0,11,21,31,99);

*******************************************;
* NBER comments on calculating hourly wage ;
*******************************************;

*Earnings are collected per hour for hourly workers, and per week for other workers. If you want a consistent hourly wage series during entire period, you should use earnwke/uhourse. This gives imputed hourly wage for weekly workers and actual hourly wage for hourly workers. But check earnwke for top-coding. Do not use any wage data that may be present for self-employed workers.;

* Ann - We are relying on the CEPR topcoding adjustment;

*********************;
* Hourly wage        ;
*********************;

gen lwage=log(rw_ot);

********************;
* Race              ;
********************;

gen nonwhite=wbho~=1;

********************************************************;
* Drop self-employed workers and those neither employed ;
* or unemployed (i.e not in the labor force)            ;
********************************************************;

keep if (age>=16 & age<=64) & (selfemp~=1) & (nilf~=1);

********************************;
* The MORG weight is 3X too big ;
********************************;

gen earnwt=orgwgt/3;

******************************************************;
* Add a 3-digit SIC code to manufacturing workers     ;
******************************************************;
* Here, I use ind7090 to retrieve man7090. Elsewhere, ;
* match data in sic87 (e.g. qew) to man7090           ;
******************************************************;

* merge with man7090;
sort ind7090;
merge ind7090 using $path/research/outsourcing/autor/ind7090-man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

do $path/research/outsourcing/autor/labels_ind7090.do;
do $path/research/outsourcing/autor/labels_man7090.do;

label data "CPS MORG workers 1979-2002";
save $path/data/cps/morg/datafiles/morg_data,replace;

keep if man7090~=.;
sort year man7090;
label data "CPS MORG workers in manufacturing 1979-2002";

save $path/research/outsourcing/datafiles/morg_man7090, replace;

************************************************;
* Unemployed and smaller copies of the data     ;
************************************************;

use $path/data/cps/morg/datafiles/morg_data, clear;

********************;
* Save a small copy ;
********************;

sort year;
by year: keep if _n<=10000;
save $path/data/cps/morg/datafiles/morg_data_small,replace;
