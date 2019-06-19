capture log close
drop _all
clear all
set memory 10g
set more 1
#delimit;
   
cd "C:\Main\p-cycle\Writing\ReStatRevision\NGVintage";

set logtype text; 
log using NgVintage, replace; 


*****************************************************************
***************This Do File performs the exercises looking**************
***************at the T values for the new goods with different***********************
**************vintages**********************************************;

*********uses NgVintageReg (created by NgVintageConstruction.do) as inputs**************;


use NgVintageReg, clear;

sum *_a, detail; hist peak_a; *********large cluster around 1972, and mean is 1976; 
gen DLate=(peak_a>=1979.5);

sort msic87; egen x=sum(fobSng), by(msic87); egen y=sum(fobNng), by(msic87);
drop if x==0 & y==0; drop x y; 
gen dd=(fobSng/fobSog)/(fobNng/fobNog); 
gen ddlog=log(dd+1); ***making sure that 0 values in dd still have 0 values in ddlog;
gen ddlog2=log(dd);
*********starting in 1978**********************************************************************; 
**********the results for starting in 1972 are very, very similar*********************************;
drop if year<=77; 
gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; by msic87, sort: egen vtbar=mean(vt); egen time=group(t);

gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; 
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao=log(ddtao+1); gen ddlogtao2=log(ddtao);

gen DLate_t=DLate*t; 

log on; **************0. start from 1978, very similar to column 1 of Table 3 in the paper************;
areg ddlog2 t t2 ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time); 
log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); log on; mat C=(length, stdlength); matlist C; 

******************augment regression with interaction term DLate_t********************************;
****************1. DLate is peak after 1979.5, the mid point of 1972-1987*************************;
areg ddlog2 t t2 DLate_t ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time); 
log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); 
log on; **************************time length for early vintage new products**************************;
mat C=(length, stdlength); matlist C; 
log off;
scalar length2=(-_b[t]-_b[DLate_t])/(2*_b[t2]); mat A2=e(V); mat Var2=A2[1..3,1..3];
mat Dlength2=(1/(2*_b[t2]), (-_b[t]-_b[DLate_t])/(2*_b[t2]*_b[t2]), 1/(2*_b[t2])); mat B2=Dlength2*Var2*Dlength2';
scalar stdlength2=sqrt(B2[1,1]); 
log on; **********************time length for late vintage new products*******************************;
mat C2=(length2, stdlength2); matlist C2; 


****************2. Just the 5 R&D intensive 2-digit SIC: 28, 35, 36, 37 and 38************************;
gen sic2d=substr(msic87,1,2); gen rd=(sic2d=="28" | sic2d=="35" | sic2d=="36" | sic2d=="37" | sic2d=="38");

**************2.1 start from 1978, no distinction between old and new vintages************;
areg ddlog2 t t2 ddlogtao2 [aweight=vtbar] if rd==1, absorb(ind) cluster(time); 
log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); log on; mat C=(length, stdlength); matlist C; 


************2.2 augment previous regression with interaction between time and DLate******************;
areg ddlog2 t t2 DLate_t ddlogtao2 [aweight=vtbar] if rd==1, absorb(ind) cluster(time); 
log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); 
log on; **************************time length for early vintage new products**************************;
mat C=(length, stdlength); matlist C; 
log off;
scalar length2=(-_b[t]-_b[DLate_t])/(2*_b[t2]); mat A2=e(V); mat Var2=A2[1..3,1..3];
mat Dlength2=(1/(2*_b[t2]), (-_b[t]-_b[DLate_t])/(2*_b[t2]*_b[t2]), 1/(2*_b[t2])); mat B2=Dlength2*Var2*Dlength2';
scalar stdlength2=sqrt(B2[1,1]); 
log on; **********************time length for late vintage new products*******************************;
mat C2=(length2, stdlength2); matlist C2; 


log close; 











