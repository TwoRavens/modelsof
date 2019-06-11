/*** The program defines and activates MCMC and MLE procedures */ 
/* needed in the estimation of why nations go under IMF agreements */
/* Alastair Smith: September 12th 2003 */
/* this program is called by other files */ 
/* The MLE programs are p2route (either mechanism 1 or 2 is a yes: Braumoller's Boolean Probit */
/* p2route_partial (for some cases we know Y1=1, for other we know Y2=1, for most we simple know that Y1 or Y2 =1 */
/*  throbit (threshold model: if latent y*1>tau1 then we know that Y1=1 and not Y2=1 etc.. )*/ 
/* The mcmc program is MCMC_IMF (the MCMC version of p2route_partial) */ 
/* MCMC_IMF_out is a program to summarize the output of the MCMC chain */ 


/********************* MLE: estimators ***********************/
#delimit;
capture program drop p2route;
program define p2route; 
version 6; 
args lnf b1 b2; 
quietly replace `lnf'=ln(1-(1-normprob(`b1'))*(1-normprob(`b2'))) if UNDER==1; 
quietly replace `lnf'=ln((1-normprob(`b1'))*(1-normprob(`b2'))) if UNDER==0; 
end;

#delimit;
capture program drop p2route_partial;
program define p2route_partial; 
version 6; 
args lnf b1 b2; 
quietly replace `lnf'=ln(1-(1-normprob(`b1'))*(1-normprob(`b2'))) if UNDER==1; 
quietly replace `lnf'=ln((1-normprob(`b1'))*(1-normprob(`b2'))) if UNDER==0; 
quietly replace `lnf'=ln(normprob(`b1')) if UNDER==1 & $case1==1 ; 
quietly replace `lnf'=ln(normprob(`b2')) if UNDER==1 & $case2==1; 
end;


#delimit;
capture program drop throbit;
program define throbit; 
version 6; 
args lnf b1 b2 t1 t2; 
tempvar areat0 area0t area00;
qui gen double `areat0' = normprob(`b1'-exp(`t1'))*normprob(exp(`t2')-`b2');
qui gen double `area0t' = normprob((`b2')-exp(`t2'))*normprob(exp(`t1')-(`b1'));
qui gen double `area00' = normprob(-(`b2'))*normprob(-(`b1'));

quietly replace `lnf'=ln(1-`area00'-`areat0'-`area0t')
				 if (UNDER==1 & ((y1~=1 & y2~=1)|(y1==1 & y2==1))); 
quietly replace `lnf'=ln(`areat0') if y1==1 ;
quietly replace `lnf'=ln(`area0t') if y2==1 ;
quietly replace `lnf'=ln(`area00') if UNDER==0; 
end;

#delimit;
capture program drop throbit2;
program define throbit2; 
version 6; 
args lnf b1 b2 t1 t2 r; 
tempvar areat0 area0t area00;
qui gen double `areat0' = binorm((`b1'-exp(`t1')),(exp(`t2')-`b2'),`r');
qui gen double `area0t' = binorm(((`b2')-exp(`t2')),(exp(`t1')-(`b1')),`r');
qui gen double `area00' = binorm((-(`b2')),(-(`b1')),`r');

quietly replace `lnf'=ln(1-`area00'-`areat0'-`area0t')
				 if (UNDER==1 & ((y1~=1 & y2~=1)|(y1==1 & y2==1))); 
quietly replace `lnf'=ln(`areat0') if y1==1 ;
quietly replace `lnf'=ln(`area0t') if y2==1 ;
quietly replace `lnf'=ln(`area00') if UNDER==0; 
end;




capture program drop MCMC_IMF;
program define MCMC_IMF; 
preserve; 
/* number of interations to run */
local m 100000; 
/* number of interations to discard */
local n0 200000 ; 
/*  prior mean for beta */  mat  b01_ = J($k1,1,0);  mat  b02_ = J($k2,1,0);

/*  prior variance for beta */ mat B01_ = 10*I($k1);  mat B02_ = 10*I($k2);


/******************** remove missing data ***********************/
egen missx=rmiss($x1 $x2 $y); tab missx; 
gen keepie=1; replace keepie=0 if missx~=0 |sample~=1; 
tab UNDER sample; 
keep if keepie==1; 
keep $x1 $x2 y1 y2 UNDER sample NNEED ;


/* printout info while running */ scalar pt = 50;

/* PRIORS */
global k1 : word count $x1; /* number of parameters in x1 */
global k2 : word count $x2; /* number of parameters in x1 */

/**************** starting values ************************/
mat a01_ =syminv(B01_);
mat a02_ =syminv(B02_);
mat bbb1=b01_'; mat bbb2=b02_';
mat colnames bbb1=  $x1 ;  
mat colnames bbb2= $x2;

/********* Storage and other things *************/
do c:\al2002\imf\mcmc\randomN.do;        /* defines the random number generator needed */
/* starting value */ gen latent1=0; gen latent2=0;gen err1=0; gen err2=0;gen YYY=0;gen  double AA=0; gen double  BB=0; 
gen  double CC=0; gen double DD=0;gen  double eee=0;

/************ Storage Matrix ************/
local boutstr " ( bbb1[1,1] )"; local tempp=2; 
while `tempp'<=$k1 {;  local boutstr " `boutstr' ( bbb1[1,`tempp'] ) "; local tempp= `tempp'+1; };
local tempp=1; 
while `tempp'<=$k2 {;  local boutstr " `boutstr' ( bbb2[1,`tempp'] )"; local tempp= `tempp'+1; };
display "`boutstr'";

postfile bstore iter $x1 $x2 using bstorage,replace;


/***** RUN ITERATIONS ***********/ 
local t=1; 
while `t'<=`m'+`n0' {;

/* Data Augmentation: make latent variables */
mat score yhat1=  bbb1;  /* calculates xb */
mat score yhat2=  bbb2;  /* calculates xb */
qui replace err1=uniform();
qui replace err2=uniform();

qui replace AA=norm(yhat1)*(1-norm(yhat2));  
qui replace BB=norm(yhat2)*(1-norm(yhat1));  
qui replace CC=norm(yhat1)*(norm(yhat2));  
qui replace DD=AA+BB+CC;
qui replace eee=invnorm(uniform()); 
qui replace YYY=3; 
qui replace YYY=1 if eee<AA/DD & $y==1;  
qui replace YYY=2 if eee>=AA/DD & eee<(AA+BB)/DD & $y==1; 


qui replace latent1 = yhat1 + invnorm(err1*(normprob(-yhat1))) if ($y==0 | YYY==2) ;
qui replace latent2 = yhat2 + invnorm(err2*(normprob(-yhat2))) if ($y==0 | YYY==1) ;


qui replace latent1 = yhat1 + invnorm(normprob(-yhat1)+err1*(1-normprob(-yhat1))) if $y==1 & (YYY==1|YYY==3);
qui replace latent2 = yhat2 + invnorm(normprob(-yhat2)+err2*(1-normprob(-yhat2))) if $y==1 & (YYY==2|YYY==3);


/***** this augmentation assumes that y1 and y2 are observed *******/
qui replace latent1 = yhat1 + invnorm(normprob(-yhat1)+err1*(1-normprob(-yhat1))) if $case1==1 & $case2==0 ;
qui replace latent2 = yhat2 + invnorm(normprob(-yhat2)+err2*(1-normprob(-yhat2))) if $case2==1 & $case1==0 ;

qui drop yhat1 yhat2;

/* posterior distribution of beta: equation 1 */ 
qui matrix accum W = latent1  $x1 ,  nocons; 
mat XY=W[2...,1];  /* calculates X'Y */ 
mat XX=W[2...,2...]; /* calculates X'X */ 

mat v = syminv(a01_ + XX); 
mat bhat = v*(a01_*b01_ + XY);
mat C = cholesky(v); 

rndn $k1 1 ; /* This function generates a vector of independent standard normals (kx1)*/

mat define b1 = bhat + C*r(rand_num);           /* draw beta */  


mat bbb1=b1'; 

/* posterior distribution of beta: equation 2 */ 
qui matrix accum W = latent2  $x2 ,  nocons; 
mat XY=W[2...,1];  /* calculates X'Y */ 
mat XX=W[2...,2...]; /* calculates X'X */ 

mat v = syminv(a02_ + XX);
mat bhat = v*(a02_*b02_ + XY);
mat C = cholesky(v);
rndn $k2 1 ; /* This function generates a vector of independent standard normals (kx1)*/

mat define b2 = bhat + C*r(rand_num);           /* draw beta */  


mat bbb2=b2'; 

/* printout as model runs */

 if `t'==round(`t',pt) { ;
display `t'; mat li b1; mat li b2; };

/********Store Draws ********/
if  `t'>`n0' {;
version 8;
post bstore (`t') `boutstr' ; 
};

 
local t = `t'+1;   /* next iteration */
};

postclose bstore;
end; 


capture program drop MCMC_IMF_out;
program define MCMC_IMF_out; 
preserve;
clear;
use c:\al2002\imf\bstorage.dta; 


display "$y"; display "$x1"; display "$x2";
global k1 : word count $x1; /* number of parameters in x1 */
global k2 : word count $x2; /* number of parameters in x1 */
mat  bbb1 = J(1,$k1,0);  mat  bbb2 = J(1,$k2,0);

sum ; 
#delimit;
local tempp=1;   local ind " $x1 $x2 ";
while `tempp'<=$k1+$k2 {;  local tt: word `tempp' of `ind';  qui count if `tt'>0; display "`tt'  "   r(N)/_N; 
local tempp=`tempp'+1;};

quietly {;
local tempp=1; 
while `tempp'<=$k1 {;  local tt: word `tempp' of $x1; sum(`tt'); 
display r(mean); mat bbb1[1,`tempp']=r(mean);
local tempp=`tempp'+1;};
display "ggg";
local tempp=1; 
while `tempp'<=$k2 {;  local tt: word `tempp' of $x2; sum(`tt'); display r(mean); mat bbb2[1,`tempp']=r(mean);
local tempp=`tempp'+1;};
 };
end; 


