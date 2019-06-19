capture log close
drop _all
set more 1
set matsize 1000
#delimit;
   
cd "C:\Main\p-cycle\IndustryResults\NS2";

set logtype text; 
log using Table3_mainresults, replace; log off; 

use NS2;

sort msic87; egen x=sum(fobSng), by(msic87); egen y=sum(fobNng), by(msic87);
drop if x==0 & y==0; drop x y; 
gen mainsample=(year>=78);
gen dd=(fobSng/fobSog)/(fobNng/fobNog); 
gen ddlog=log(dd+1); 
gen ddlog2=log(dd); ***making sure that 0 values in dd still have 0 values in ddlog;
gen t=year-77; gen t2=t*t; 
encode msic87, gen (ind); ***from 1 to 265; sort ind; 
gen tb=.; gen tse=.; gen t2b=.; gen t2se=.; gen tblog=.; gen tselog=.; gen t2blog=.; 
gen t2selog=.;gen vt=fobSng+fobSog+fobNng+fobNog; 
by msic87, sort: egen vtbar=mean(vt); 
egen time=group(t);

gen taoSng=(cifSng-fobSng)/fobSng; gen taoSog=(cifSog-fobSog)/fobSog;
gen taoNng=(cifNng-fobNng)/fobNng; gen taoNog=(cifNog-fobNog)/fobNog;

log on; count if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0; 
sum tao* if taoSng>=0 & taoSog>=0 & taoNng>=0 & taoNog>=0; log off;
gen ddtao=(taoSng/taoSog)/(taoNng/taoNog);
replace ddtao=. if taoSng<0 | taoSog<0 | taoNng<0 | taoNog<0;
gen ddlogtao=log(ddtao+1); gen ddlogtao2=log(ddtao);

save c10, replace;

log on; 

***column 2;
areg ddlog2 t t2 [aweight=vtbar] if mainsample==1, absorb(ind) cluster(time); 
outreg2 t t2 using Table3_mainresults, replace ctitle(Regression 9);
*** length of product cycles (length) and its std. dev. (stdlength), computed;
*** using the delta method; log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); log on; mat C=(length, stdlength); matlist C; 

***column 1;
areg ddlog2 t t2 ddlogtao2 [aweight=vtbar] if mainsample==1, absorb(ind) cluster(time); 
outreg2 t t2 ddlogtao2 using Table3_mainresults, append ctitle(Regression 9);
*** length of product cycles (length) and its std. dev. (stdlength), computed;
*** using the delta method; log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); log on; mat C=(length, stdlength); matlist C; 


***column 3;
areg ddlog2 t t2 ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time); 
outreg2 t t2 ddlogtao2 using Table3_mainresults, append ctitle(Start in 1972);
*** length of product cycles (length) and its std. dev. (stdlength), computed;
*** using the delta method; log off; 
scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
scalar stdlength=sqrt(B[1,1]); log on; mat C=(length, stdlength); matlist C; 



***column 8 is as follows, plus a version with no trade cost; log off;

scalar round=1000; 

mat NC=J(round,6,0); mat CL=J(round,8,0); gen rv=0; 

log on; 
*************random matching: if r.v. > 0.5, keep original order, otherwise flip;
set seed 24; log off;  

forvalues x=1/1000 {;
  replace rv=uniform(); 
  replace ddlog2= -ddlog2 if rv < 0.5;
  replace ddlogtao2=-ddlogtao2 if rv < 0.5;

  ***no trade cost;
  quietly areg ddlog2 t t2 [aweight=vtbar], absorb(ind) cluster(time); 

  ***coefficients and std. errors for t and t2;
  mat NC[`x',1]=_b[t]; mat NC[`x',2]=_se[t]*_se[t]; 
  mat NC[`x',3]=_b[t2]; mat NC[`x',4]=_se[t2]*_se[t2];

  ***length of time and its standard error;
  scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
  mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
  scalar varlength=B[1,1]; 
  mat NC[`x',5]=length; mat NC[`x',6]=varlength;

  ***with trade cost; 
  quietly areg ddlog2 t t2 ddlogtao2 [aweight=vtbar], absorb(ind) cluster(time); 

  ***coefficients and std. errors for t and t2;
  mat CL[`x',1]=_b[t]; mat CL[`x',2]=_se[t]*_se[t]; 
  mat CL[`x',3]=_b[t2]; mat CL[`x',4]=_se[t2]*_se[t2];
  mat CL[`x',5]=_b[ddlogtao]; mat CL[`x',6]=_se[ddlogtao]*_se[ddlogtao];

  ***length of time and its standard error;
  scalar length=-_b[t]/(2*_b[t2]); mat A=e(V); mat Var=A[1..2,1..2];
  mat Dlength=(1/(2*_b[t2]), -_b[t]/(2*_b[t2]*_b[t2])); mat B=Dlength*Var*Dlength';
  scalar varlength=B[1,1]; 
  mat CL[`x',7]=length; mat CL[`x',8]=varlength;
};

mat A=J(1,round,1); mat TMP=A*NC; mat AV_NC=J(1,8,0); 
forvalues x=1/8 {;
  if `x'/2>int(`x'/2)+0.1 {;
     mat AV_NC[1,`x']=TMP[1,`x']/round; ****these are the coefficients;
  };
  else {;
     mat AV_NC[1,`x']=sqrt(TMP[1,`x'])/round; ***these are the std. errors;
  };
};

mat drop TMP;

mat TMP=A*CL; mat AV_CL=J(1,8,0); 
forvalues x=1/8 {;
  if `x'/2>int(`x'/2)+0.1 {;
     mat AV_CL[1,`x']=TMP[1,`x']/round; ****these are the coefficients;
  };
  else {;
     mat AV_CL[1,`x']=sqrt(TMP[1,`x'])/round; ***these are the std. errors;
  };
};


log on; 
******log(dd), weighted, no trade cost*********: coeff  std. dev;
mat list AV_NC;

*********log(dd+1), weighted, with trade cost*************************: coeff std. dev;
mat list AV_CL;

log close; 

clear; 
erase c10.dta; 