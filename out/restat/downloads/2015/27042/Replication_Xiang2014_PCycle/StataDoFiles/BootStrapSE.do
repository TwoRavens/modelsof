capture log close
drop _all
clear matrix
set matsize 5000
set more 1
set memory 10g
#delimit;
   
cd "C:\Main\p-cycle\Writing\ReStatRevision\BootStrapSE";

set logtype text; log using BootstrapSE, replace; 

*************This do file recalculates the bootstrapped SE for all the tables in the paper********************; 

**********************************************************column (2), Table 4***********************************;
use C:\Main\p-cycle\Writing\ReStatRevision\NGVintage\NgVintageReg, clear; drop if year <=77; log off; 
do VarConstructionNgVintage; log on; 

bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W DLate_tW ddlogtao2W, absorb(ind); 
nlcom -_b[tW]/(2*_b[t2W]);
nlcom (-_b[tW]-_b[DLate_tW])/(2*_b[t2W]);

**********************************************************column (3), Table 4***********************************;
gen sic2d=substr(msic87,1,2); gen rd=(sic2d=="28" | sic2d=="35" | sic2d=="36" | sic2d=="37" | sic2d=="38");
keep if rd==1; 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(ind); 
nlcom -_b[tW]/(2*_b[t2W]);

**********************************************************column (4), Table 4***********************************;
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W DLate_tW ddlogtao2W, absorb(ind); 
nlcom -_b[tW]/(2*_b[t2W]);
nlcom (-_b[tW]-_b[DLate_tW])/(2*_b[t2W]);

**********************************************************column (4), Table 3**********************************;
use C:\Main\p-cycle\Writing\ReStatRevision\CountryFE\NFE, clear; drop if year<=77; log off; 
do VarConstructionCountryFE; log on; 
egen fixed=group(wtdbcode msic87); 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(fixed); 
nlcom -_b[tW]/(2*_b[t2W]);

**********************************************************column (5), Table 3**********************************;
use C:\Main\p-cycle\Writing\ReStatRevision\CountryFE\SFE, clear; drop if year<=77; log off; 
do VarConstructionCountryFE; log on; 
egen fixed=group(wtdbcode msic87); 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(fixed); 
nlcom -_b[tW]/(2*_b[t2W]);

**********************************************************column (6), Table 3**********************************;
use C:\Main\p-cycle\Writing\ReStatRevision\VS\NS2DropMexChi, clear; drop if year<=77; log off; 
do VarConstruction; 
log on; 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(ind);
nlcom -_b[tW]/(2*_b[t2W]);

**********************************************************column (7), Table 3**********************************;
use C:\Main\p-cycle\Writing\ReStatRevision\VS\NS2DropExpGdp, clear; drop if year<=77; log off; 
do VarConstruction;  
log on; 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(ind);
nlcom -_b[tW]/(2*_b[t2W]);

********************************column (3), Table 3******************************************************;
use C:\Main\p-cycle\IndustryResults\NS2\NS2, clear; log off; do VarConstruction; 
log on; 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(ind);
nlcom -_b[tW]/(2*_b[t2W]);

********************************column (1), Table 3******************************************************;
drop if year<=77; 
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(ind);
nlcom -_b[tW]/(2*_b[t2W]);

********************************column (2), Table 3******************************************************;
bootstrap, reps(200) seed(20) cluster(time): areg ddlog2W tW t2W, absorb(ind);
nlcom -_b[tW]/(2*_b[t2W]);

*************************************************column (8), Table 3*****************************************;
scalar round=1000; 

mat NC=J(round,6,0); mat CL=J(round,8,0); gen rv=0; 

log on; 
*************random matching: if r.v. > 0.5, keep original order, otherwise flip;
set seed 24; log off;  

forvalues x=1/1000 {;
  replace rv=uniform(); 
  replace ddlog2W= -ddlog2W if rv < 0.5;
  replace ddlogtao2W=-ddlogtao2W if rv < 0.5;

  ***with trade cost; 
  quietly bootstrap, reps(50) cluster(time): areg ddlog2W tW t2W ddlogtao2W, absorb(ind);

  ***coefficients and std. errors for t and t2;
  mat CL[`x',1]=_b[tW]; mat CL[`x',2]=_se[tW]*_se[tW]; 
  mat CL[`x',3]=_b[t2W]; mat CL[`x',4]=_se[t2W]*_se[t2W];
  mat CL[`x',5]=_b[ddlogtao2W]; mat CL[`x',6]=_se[ddlogtao2W]*_se[ddlogtao2W];

  ***length of time and its standard error;
  scalar length=-_b[tW]/(2*_b[t2W]); mat A=e(V); mat Var=A[1..2,1..2];
  mat Dlength=(1/(2*_b[t2W]), -_b[tW]/(2*_b[t2W]*_b[t2W])); mat B=Dlength*Var*Dlength';
  scalar varlength=B[1,1]; 
  mat CL[`x',7]=length; mat CL[`x',8]=varlength;
};

mat A=J(1,round,1);
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

*********log(dd+1), weighted, with trade cost*************************: coeff std. dev;
mat list AV_CL;

log close; 
