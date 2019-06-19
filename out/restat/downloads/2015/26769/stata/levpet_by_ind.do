#delim;

qui {;
clear;
set more off;
pause on;
set mem 100m;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-14-2009*/ 
/*Levinsohn-Petrin estimates for a set of industries*/
/* Inputs:	capital, labor and input materials
		industry identifier, all declared in main.do
   Output:  estimated parameter-file (res_storname) and tfp-file (omega_storename)
		stored in a subdirectory named $storename
   Procedures:
		outliers.do
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/****************************************************************************/

use "$path1\$fname.dta", clear;

/*mark outliers/missing values*/
noi run "$path1\outliers.do";

sort $id $yr;
/*new id to make sure levpet.ado doesn't get stuck at huge firm-ids*/
tempvar id1;
egen `id1'=group($id);

/*store industry codes in matrix*/
qui tab $ind, matrow(X);
scalar sr1=rowsof(X); loc lsr1=sr1;

/*build command acc to value added/revenue*/
if "$model"=="va" {;
	local cmd "$depvar if $ind==X[1,1], reps($rep) free($emp) proxy($proxy) capital($cap) i(`id1') t($yr)";
	};
else {;
	local cmd "$depvar if $ind==X[1,1], reps($rep) free($emp) rev grid proxy($proxy) capital($cap) i(`id1') t($yr)";
	};

preserve;
	scalar sa=X[1,1];
	keep if $ind==X[1,1] & out!=1;
	levpet `cmd';
	matrix beta=e(b); matrix v=e(V); matrix ster=sqrt(v[1,1]),sqrt(v[2,2]);
	matrix crts=e(waldcrs); matrix nobs=e(N);
	loc rnames=X[1,1];
restore;
mat score double rhs=beta; replace rhs=. if $ind!=X[1,1];
gen omega=exp($depvar-rhs) if $ind==X[1,1]; drop rhs;
noi di in green "estimating prod func in indstry:";
forvalues num=2/`lsr1' {;
	if "$model"=="va" {;
		local cmd "$depvar if $ind==X[`num',1], reps($rep) free($emp) proxy($proxy) capital($cap) i(`id1') t($yr)";
		};
	else {;
		local cmd "$depvar if $ind==X[`num',1], reps($rep) free($emp) rev grid proxy($proxy) capital($cap) i(`id1') t($yr)";
		};
	scalar sa=X[`num',1]; loc displaycode = sa;
	noi di "`displaycode'";
	preserve;
		keep if $ind==X[`num',1] & out!=1;
		capture levpet `cmd';
		if !_rc {;
			di in yellow "on no-error path";
			levpet `cmd';
			matrix beta=beta\e(b);
			matrix beta1=e(b); /*to predict omega*/
			matrix v=e(V); matrix ster=ster\[sqrt(v[1,1]),sqrt(v[2,2])];
			matrix crts=crts\e(waldcrs);
			matrix nobs=nobs\e(N);
			};
		else {;
			di in yellow "on error path";
			matrix beta=beta\[0,0];
			matrix beta1=[0,0]; matrix colnames beta1 = $emp $cap;
			matrix ster=ster\[0,0];
			matrix crts=crts\[0];
			matrix nobs=nobs\[0];
			matrix list beta;
			};
		loc rnames = "`rnames' "+string(X[`num',1]);
	restore;
	mat score double rhs=beta1; replace rhs=. if $ind!=X[`num',1] | rhs==0;
	replace omega=exp($depvar-rhs) if $ind==X[`num',1]; drop rhs;
};

matrix results=beta,crts,nobs;
matrix colnames results = $emp $cap crts nobs;
matrix rownames results = `rnames';
matrix colnames ster    = $emp $cap;
matrix rownames ster    = `rnames';

/*Format&convert result matrices*/
preserve;
	svmat double results;
	keep results1 results2 results3 results4;
	rename results1 L; rename results2 K; rename results3 ctrs; rename results4 nobs;
	svmat X; rename X1 $ind; move $ind L; sort $ind;
	compress;
	save "$temppath\pars_$storename.dta", replace;
restore;
preserve;
	svmat double ster;
	keep ster1 ster2; rename ster1 seL; rename ster2 seK; 
	svmat X; rename X1 $ind; move $ind seL; sort $ind; compress;
	save "$temppath\serr_$storename.dta", replace;
restore;
matrix drop _all; scalar drop _all;

rename omega omega$storename;
drop `id1';
keep $id $yr $ind out omega; compress;
loc spath="$respath\"+"$tfpfile";
save "`spath'", replace;

use "$temppath\pars_$storename.dta", clear;
sort $ind;
merge $ind using "$temppath\serr_$storename.dta"; compress;
loc spath="$respath\"+"$parfile";
save "`spath'", replace;

erase "$temppath\pars_$storename.dta";
erase "$temppath\serr_$storename.dta";

local drop all;
}; /*end of main qui block*/
