#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-raw-sts3.log, replace;

* William Kerr;
* Create raw panel files at state level;
* Last Modified: July 2010;

clear; clear matrix; set mem 5g; set matsize 8000; set more off;
chdir /rdcprojects/br1/br00598/data/lbd10/;

*** Unzip base data;
*for num 1976/2005: !gunzip ./data/lbdXa.dta;

*** Generate index values;
use stlbl, clear;
levelsof st, local(Ist);

*** Collapse county distributions;
foreach S1 of local Ist {;
use lbdnum yr state county emp cfn pay mu sic bestsic naics 
    if st==`S1' using ./data/lbd1976a.dta, clear;
compress; save temp1-sts3, replace;
forvalues YR1=1977(1)2005 {;
use lbdnum yr state county emp cfn pay mu sic bestsic naics 
    if st==`S1' using ./data/lbd`YR1'a.dta, clear;
compress; append using temp1-sts3;
save temp1-sts3, replace;
};

*** Prepare industry codes;
sum; count if sic!=""; count if bestsic!=""; 
ren bestsic sico; replace sico=sic if sico=="" & sic!=""; drop sic;
gen str6 temp1=rtrim(ltrim(sico)); gen temp2=length(temp1); tab temp2;
gen str6 temp3=temp1 if temp2==6; replace temp3=temp1+"0" if temp2==5;
replace temp3=temp1+"00" if temp2==4; replace temp3=temp1+"000" if temp2==3;
replace temp3=temp1+"0000" if temp2==2; replace temp3=temp1+"00000" if temp2==1;
replace temp3="000000" if temp2==0; destring temp3, generate(sic) force; drop temp*;
tab sico if (sic==. | sic==0); count if (sico=="" | sico=="      ");
gen temp1=emp if (sic==. | sic==0);
egen temp2=sum(temp1); sum temp2; drop temp*; 
gen sic4=int(sic/100); drop sico;

/*
*** Convert SIC4 codes to 1987 basis;
* Agriculture, forestry and fishing; 
replace sic4=831 if sic4==821 & yr<=1987; replace sic4=831 if sic4==843 & yr<=1987;
replace sic4=831 if sic4==849 & yr<=1987;

* Mining;
replace sic4=1099 if sic4==1051 & yr<=1987; replace sic4=1231 if sic4==1111 & yr<=1987;
replace sic4=1241 if sic4==1112 & yr<=1987; replace sic4=1241 if sic4==1213 & yr<=1987;
replace sic4=1221 if sic4==1211 & yr<=1987;

* Construction;

* Manufacturing; 
replace sic4=2258 if sic4==2292 & yr<=1987; replace sic4=2671 if sic4==2641 & yr<=1987;
replace sic4=2677 if sic4==2642 & yr<=1987; replace sic4=2674 if sic4==2643 & yr<=1987;
replace sic4=2675 if sic4==2645 & yr<=1987; replace sic4=2679 if sic4==2646 & yr<=1987;
replace sic4=2676 if sic4==2647 & yr<=1987; replace sic4=2678 if sic4==2648 & yr<=1987;
replace sic4=2679 if sic4==2649 & yr<=1987; replace sic4=2621 if sic4==2661 & yr<=1987;
replace sic4=3069 if sic4==3031 & yr<=1987; replace sic4=3052 if sic4==3041 & yr<=1987;
replace sic4=3081 if sic4==3079 & yr<=1987; replace sic4=3053 if sic4==3293 & yr<=1987;
replace sic4=3543 if sic4==3565 & yr<=1987; replace sic4=3596 if sic4==3576 & yr<=1987;
replace sic4=3548 if sic4==3623 & yr<=1987; replace sic4=3844 if sic4==3693 & yr<=1987;
replace sic4=3821 if sic4==3811 & yr<=1987; replace sic4=3826 if sic4==3832 & yr<=1987;
replace sic4=3999 if sic4==3962 & yr<=1987; 

* Transportation and Utilities;
replace sic4=4482 if sic4==4452 & yr<=1987; replace sic4=4499 if sic4==4453 & yr<=1987;
replace sic4=4492 if sic4==4454 & yr<=1987; replace sic4=4449 if sic4==4459 & yr<=1987;
replace sic4=4491 if sic4==4463 & yr<=1987; replace sic4=4499 if sic4==4464 & yr<=1987;
replace sic4=4493 if sic4==4469 & yr<=1987; replace sic4=4512 if sic4==4521 & yr<=1987;
replace sic4=4731 if sic4==4712 & yr<=1987; replace sic4=4731 if sic4==4723 & yr<=1987;

* Wholesale; 
replace sic4=5091 if sic4==5041 & yr<=1987; replace sic4=5092 if sic4==5042 & yr<=1987;
replace sic4=5044 if sic4==5081 & yr<=1987; replace sic4=5047 if sic4==5086 & yr<=1987;

* Retail;
replace sic4=5632 if sic4==5681 & yr<=1987;

* FIRE; 
replace sic4=6091 if sic4==6042 & yr<=1987; replace sic4=6091 if sic4==6044 & yr<=1987;
replace sic4=6081 if sic4==6052 & yr<=1987; replace sic4=6099 if sic4==6054 & yr<=1987;
replace sic4=6099 if sic4==6055 & yr<=1987; replace sic4=6082 if sic4==6056 & yr<=1987;
replace sic4=6099 if sic4==6059 & yr<=1987; replace sic4=6035 if sic4==6122 & yr<=1987;
replace sic4=6036 if sic4==6123 & yr<=1987; replace sic4=6036 if sic4==6124 & yr<=1987;
replace sic4=6036 if sic4==6125 & yr<=1987; replace sic4=6111 if sic4==6131 & yr<=1987;
replace sic4=6061 if sic4==6142 & yr<=1987; replace sic4=6062 if sic4==6143 & yr<=1987;
replace sic4=6411 if sic4==6611 & yr<=1987; 

* Services; 
replace sic4=7383 if sic4==7351 & yr<=1987; replace sic4=8731 if sic4==7391 & yr<=1987;
replace sic4=8741 if sic4==7392 & yr<=1987; replace sic4=7381 if sic4==7393 & yr<=1987;
replace sic4=7353 if sic4==7394 & yr<=1987; replace sic4=7384 if sic4==7395 & yr<=1987;
replace sic4=7389 if sic4==7396 & yr<=1987; replace sic4=8734 if sic4==7397 & yr<=1987;
replace sic4=7389 if sic4==7399 & yr<=1987; replace sic4=7999 if sic4==7932 & yr<=1987;
replace sic4=8093 if sic4==8081 & yr<=1987; replace sic4=8711 if sic4==8911 & yr<=1987;
replace sic4=8733 if sic4==8922 & yr<=1987; replace sic4=8721 if sic4==8931 & yr<=1987;
*/

gen sic3=int(sic4/10); drop sic4 sic;

compress; sort lbdnum yr; sum;
cap n erase ./st1s3/lbdc-raw-s3-`S1'.dta.gz;
save ./st1s3/lbdc-raw-s3-`S1'.dta, replace;
!gzip ./st1s3/lbdc-raw-s3-`S1'.dta;
erase temp1-sts3.dta;
};

*** Zip base data;
*for num 1976/2005: !gzip ./data/lbdXa.dta;

***End Program;
cap n log close;