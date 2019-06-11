version 6.0 
#delimit ;
log using c:\stata\log\acmainsim.log, replace ;
set memory 64000 ;

/* initialize actual programs */
do c:\stata\do\initializevars; /* sets up initvar program */;
do c:\stata\do\meancalculator; /* sets up meancalc program */;
do c:\stata\do\extractstderr;  /* sets up getstde program */;
display "$S_TIME" ;
/* call do that will read data and initialize and test prior to simulation */;
quietly {;
do c:\stata\do\acphase1;  
};
display "simulation phase begins";
display "$S_TIME" ;
/* Set number of simulations to perform and call simulation do file */ ;
scalar maxsim=500 ;

display maxsim ;

***********         ;                                                                       
***********  select one of the three below, by removing the *  ;
***********         ;
quietly {; 
*do c:\stata\do\acdirsimphaseLK5;     /*directional*/
*do c:\stata\do\acproxCBsimphaseLK5;    /*city-block proximity*/
*do c:\stata\do\acproxEU2simphaseLK5; /*squared Euclidean proximity*/
};
display "simulation complete" ; 
display "$S_TIME" ;
log close ;
