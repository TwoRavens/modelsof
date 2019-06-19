#delim;
qui {;
clear;
set more off;
pause on;
set mem 100m;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-15-2009*/ 
/*Declares globals and paths; calls levpet_by_ind.do*/
/* Inputs:	names of vars necessary for pf estimation
   Output:	parameter file and tfp file
   Procedures:
		levpet_by_ind.do
		gen_decomp.do
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
noi di in yellow "start main";

/***** FILEPATHS/-NAMES *****/
global path1    ="C:\"; /*current directory*/
global fname    ="mydata";
global temppath ="$path1"+"temp";

/***** VARIABLE NAMES (inputs for levpet_by_ind) *****/
global id      = "id";
global yr      = "yr";
global model   = "va";
global depvar  = "lnva"; /*global depvar = "lnq";*/
global cap     = "lnk";
global emp     = "lnemp";
global pay     = "npayroll";
global proxy   = "lnm";
global ind     = "ind"; /*must be two-digit coded for aggregator routine*/
global rep     = "3";
global shvar_n = "nvadd";
global phi_ind = "phi"+"_$ind";
global status  = "status";

noi di in red "GIVE THIS RUN A NAME TO SAVE PARAMETERS & OMEGAS";
noi di in red "TYPE: global storename= ''myrun'' AND THEN PRESS Q";
pause;

global respath  ="$path1\result_"+"$storename";
global parfile  ="pars_"+"$storename";
global tfpfile  ="omega_"+"$storename";

mkdir "$temppath";
mkdir "$respath";

noi run "$path1\levpet_by_ind.do";
noi di in green "prod func estimation ready";

noi run "$path1\gen_decomp.do";

noi di "end main";
macro drop all;
*keep if $ind==15;
}; /*end of main qui block*/
