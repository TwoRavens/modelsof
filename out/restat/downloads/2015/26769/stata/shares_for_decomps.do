#delim;

qui {;
pause on;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-15-2009*/ 
/*calculates input/output/va shares for aggregation & decomps*/
/*called by gen_decomp.do*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

gen touse=1 if out!=1 & mistau!=1;
replace touse=0 if touse==.;

merge $id $yr using "$path1\$fname.dta", keep($shvar_n $emp $cap $proxy);
drop if _merge==2; drop _merge;

/*va/q shares...*/
replace $shvar_n =. if $shvar_n<0;
by touse $ind $yr, sort: egen su1=total($shvar_n) if touse==1;
by touse      $yr, sort: egen su2=total($shvar_n) if touse==1;

gen $phi_ind = su1/su2;
*gen phi	 = $shvar_n/su1;
 gen phi	 = $shvar_n/su2;

tsset $id $yr; sort $id $yr;
gen dphi=phi-L.phi; 

/*inputshares*/
loc rpath="$respath\"+"$parfile";
preserve;
	use "`rpath'", clear;
	sort $ind;
	save "$temppath\temp.dta", replace;
restore;

sort $ind;
if "$model"=="va"{;
	merge $ind using "$temppath\temp.dta", keep(L K);
	gen x		= exp($emp*L + $cap*K) if touse==1;
	};
else{;
	merge $ind using "$temppath\temp.dta", keep(L K M);
	gen x		= exp($emp*L + $cap*K + $proxy*M) if touse==1;
	};
replace x =. if x<0;
*by touse $ind $yr, sort: egen su3=total(x) if touse==1;
 by touse      $yr, sort: egen su3=total(x) if touse==1;

gen phi_i	= x / su3;

sort $id $yr;
gen dphi_i=phi_i-L.phi_i;
drop if _merge==2; drop _merge x su1 su2 su3;

erase "$temppath\temp.dta";

}; /*end of main qui block*/
