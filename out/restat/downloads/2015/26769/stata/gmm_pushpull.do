#delim;

qui {;
set more off;
pause on;

/*Oct-25-2009*/ 
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*estimates simple gmm (Anderson-Hsiao IV) regressions of two structural equations*/
/*   Procedures:
		frontiercalc.do		
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

noi di in green "estimating auxiliary models";
noi run "$path1\frontiercalc.do";
sort $id $yr;

/*Estimation*/
/*model in logs: dtau(it)=b*(fro(t)-tau(it))+error */
noi di in green "model for lntau";
tab $ind, matrow($ind); local lnr=rowsof($ind);
gen lnfro=ln(fro);
sort $id $yr;
gen X=(lnfro-lntau)   if touse==1;
gen Y=(lntau-L.lntau) if touse==1;
gen Z=L2.X 		    if touse==1;
foreach var in X Y Z{;
	replace `var'=0 if `var'==.;
};

preserve;
	keep if $ind==$ind[1,1];
	ivreg Y (X=Z), noconst;
	matrix b=e(b); matrix v=e(V);
	matrix v=sqrt(v[1,1]);
	matrix res = b,v;
restore;
forvalues num=2/`lnr' {;
preserve;
	keep if $ind==$ind[`num',1];
	matrix result=.;
	ivreg Y (X=Z), noconst;
	matrix b=e(b); matrix v=e(V);
	matrix v=sqrt(v[1,1]);
	matrix result=b,v;
	matrix res=res\result;
restore;
};

matrix colnames res = b se;
matrix rownames res = 10 11 12 13 15 16 17 18 19 20 21 22;
noi matrix list res;

/*IV-fittedvals for dtau*/
gen dlntau_f=.;
forvalues num=1/`lnr' {;
	replace dlntau_f=res[`num',1]*X if dlntau_f==. & $ind==$ind[`num',1] & touse==1;
};

label var dlntau_f "fitted dtau's from IV reg";
drop X Y Z;

/*Estimation*/
/*model in logs: ln(phi(it))=b0+b1(tau(it)-imean(tau))+error*/
/*prep vars for phi model*/
by touse $ind $yr, sort: egen lntau_m=mean(lntau) if touse==1;
sort $id $yr;
gen X=(lntau-lntau_m);
gen Z=L.X    if touse==1;
gen Y1=phi   if touse==1;
gen Y2=phi_i if touse==1;
gen const=1  if touse==1;
foreach var in X Y1 Y2 Z const{;
	replace `var'=0 if `var'==. ;
};

forvalues num=1/2{;
	if "`num'"=="1"{;
		gen Y=Y1;
		local model "phi";
		noi di in green "model for `model'";
	};
	else {;
		gen Y=Y2;
		local model "phi_i";
		noi di in green "model for `model'";
	};
	preserve;
		keep if $ind==$ind[1,1];
		ivreg Y (X=Z);
		matrix b=e(b); matrix v=e(V);
		matrix v=sqrt(v[1,1]),sqrt(v[2,2]);
		matrix res = b,v;
	restore;
	forvalues num=2/`lnr' {;
		preserve;
		keep if $ind==$ind[`num',1];
		ivreg Y (X=Z);
		matrix b=e(b); matrix v=e(V);
		matrix v=sqrt(v[1,1]),sqrt(v[2,2]);
		matrix result=b,v;
		matrix res=res\result;
		restore;
	};
	
	matrix colnames res = b0 b1 se0 se1 ;
	matrix rownames res = 10 11 12 13 15 16 17 18 19 20 21 22;
	noi matrix list res;

	/*gen IV-fittedvals for phi*/
	gen `model'_f=.;
	forvalues num=1/`lnr' {;
		replace `model'_f=res[`num',1]*const+res[`num',2]*X if `model'_f==. & $ind==$ind[`num',1] & touse==1;
		label var `model'_f "fitted `model'-s from IV reg";
	};

drop Y;
}; /*endforvalues Y1 Y2*/
drop X Y1 Y2 Z const lntau_m;

sort $id $yr;
}; /*end of main qui block*/;
