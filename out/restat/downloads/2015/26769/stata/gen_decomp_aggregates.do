#delim;
qui{;
pause on;
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-15-2009*/ 
/* Inputs:	varlist
   Output:	unique list of values (& leads/lags) of elements in varlist
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*noi di in green "gen aggregates...";*/
foreach var in $aggrlist {;
*noi di in yellow "`var'";
	gen str50 s0   = string(`var',"%40.10g") if `var'!=.; 
	gen exp        = strpos(s0,"e");
	gen str50 s0exp= string(`var',"%40.0f" ) if `var'!=.;
	replace s0	   = s0exp if exp!=0;

	gen sign=substr(s0,1,1); 				/*"-" for negative aggregates*/
	replace sign="" if sign!="-"; 	
	
	gen s1	= s0	if sign!="-";
	replace s1	= substr(s0,2,length(s0)) if sign=="-";	/*numeric chars in strings after "-" sign*/
	
	gen str50 y="";
	*replace y=(sign + string($yr) + string($ind) + s1)	if touse==1 & `var'!=. & sign=="-";		
	*replace y=(sign + string($yr) + string($ind) + s0)	if touse==1 & `var'!=. & sign!="-";		
	 replace y=(sign + string($yr) + string($ind) + s1)	if touse==1 & `var'!=.		    ;
*pause;
	drop s0 sign s1 exp s0exp;
	destring y, replace force; format y %30.0g;
	tab y, matrow(z);

	preserve;
		keep if touse==1;
		drop _all;
		svmat double z;

		gen str50 s0   = string(z,"%40.10g");
		gen exp        = strpos(s0,"e");
		gen str50 s0exp= string(z,"%40.0f" );	
		replace s0	   = s0exp if exp!=0;

		gen sign     = substr(s0,1,1);				/*"-" for negative aggregates*/
		replace sign ="" if sign!="-";

		gen s1	= s0	if sign!="-";
		replace s1	= substr(s0,2,length(s0)) if sign=="-";	/*numeric chars in strings after "-" sign*/

		gen $yr  = .;
		gen $ind = .;
		gen x    = .;

		replace $yr  = real(substr(s1,1,4))	;	
		replace $ind = real(substr(s1,5,2))	;
		replace x    = real(substr(s1,7,.))	;
		replace x    = (-1)*x if sign=="-"	;

		/*
		replace $yr  = real(substr(s0,2,4))		if sign=="-";
		replace $ind = real(substr(s0,6,2))		if sign=="-";
		replace x    = real(sign+substr(s0,8,.))	if sign=="-";

		replace $yr  = real(substr(s0,1,4))		if sign!="-";
		replace $ind = real(substr(s0,5,2))		if sign!="-";
		replace x    = real(substr(s0,7,.))		if sign!="-";
		*/

		drop if x==0;

		sort $ind $yr;
		local newname=`"`var'"';
		rename x `newname'; 
		sort $ind $yr;

		drop if $ind==.;
		drop if `var'==.;
*pause;
		tsset $ind $yr;
		sort $ind $yr;

		gen F`var'=F.`var';
		gen L`var'=L.`var';
		
		drop s0 sign s1 exp s0exp;
		loc lpath = "$temppath\"+"`newname'";
		save "`lpath'", replace;
		local drop `newname';
	restore;
	drop y;
};
loc lpath = "$temppath\"+"$firstword";
use "`lpath'", clear;

foreach var in $merglist {;
	loc lpath = "$temppath\"+"`var'";
	sort $ind $yr;
	merge $ind $yr using "`lpath'.dta";
	drop _merge;
};
drop z1;

sort $ind $yr;
save "$temppath\temp", replace;
};
