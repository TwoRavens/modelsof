#delim;
qui {;
clear;
set more off;
pause on;
set mem 200m;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-15-2009*/ 
/*decomps*/
/* Inputs:	estimation output from levpet_by_ind.do
   Output:	components of Bailey-Bartelsman-Haltiwanger (2001) at the firm level
   Procedures:
		shares_for_decomps.do
		gmm_pushpull.do
		gen_decomp_aggregates.do
		gen_decomp_2.do		
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

global tau = "omega"+"$storename";
loc fname1 ="$respath\"+"$tfpfile";
loc fname2 ="$respath\"+"$parfile";
loc fname3 ="$path1\$fname";
/*--------------------------------------------------------------*/
global cov "cov";
global covi "cov_i";
global cov_f "cov_f";
global covi_f "cov_i_f";

noi use "`fname1'", clear;

gen lntau=ln($tau);
gen mistau=0; replace mistau=1 if lntau==.;

/*call shares_for_decomps excluding missing taus*/

noi run "$path1\shares_for_decomps.do";
gen model="$model"; 

*keep if touse==1;
/*
/*diagnostics: check share sums*/
by touse /*$ind*/ $yr, sort: egen x1=total(phi)	if touse==1;
by touse /*$ind*/ $yr, sort: egen x2=total(phi_i)	if touse==1;
replace x1=round(x1,0.001);
replace x2=round(x2,0.001);
noi di "phi sums:"; noi tab x1; noi tab x2;
drop x1 x2;
*/

/*Push & Pull equations*/
noi run "$path1\gmm_pushpull.do";

/*** OP term ***/
/*       $ind   */
by touse      $yr, sort: egen simpleag=total(phi*lntau)			if touse==1;
by touse      $yr, sort: egen lntau_m=mean(lntau)				if touse==1;
by touse      $yr, sort: egen x1 = mean(phi)					if touse==1;
by touse      $yr, sort: egen x2 = mean(phi_i)					if touse==1;
by touse      $yr, sort: egen x3 = total((phi  - x1)*(lntau-lntau_m))	if touse==1;
by touse      $yr, sort: egen x4 = total((phi_i- x2)*(lntau-lntau_m))	if touse==1;
rename x3 $cov; rename x4 $covi;
drop x1 x2;

by touse	  $yr, sort: egen x10 = mean(phi_f)   ;
by touse	  $yr, sort: egen x11 = mean(phi_i_f) ;
by touse	  $yr, sort: egen x12=total((phi_f    - x10)*(lntau-lntau_m));
by touse	  $yr, sort: egen x13=total((phi_i_f  - x11)*(lntau-lntau_m));
rename x12 $cov_f; rename x13 $covi_f;
drop x10 x11;

sort $id $yr;
gen double dlntau		= lntau	-	L.lntau;
/*aggr prod with two shares*/
gen double lntau_a	= lntau_m	+	$cov;
gen double lntau_i_a	= lntau_m	+	$covi;
gen lntau_f_a		= lntau_m	+	$cov_f;
gen lntau_i_f_a		= lntau_m	+	$covi_f;

/*** mark Con/eN/Ex, can be switched off ***/
sort $id $yr;
merge $id $yr using "`fname3'", keep($status); drop if _merge==2; drop _merge;
gen C=0; gen E=0; gen X=0;
sort $id $yr;
/*
noi di in green "mark X observations relative to t";
noi di in green "ie for last t of C==1: X==1";*/
replace C=1 if $id!=. & L.$id!=.;
replace E=1 if $id!=. & L.$id==.;
replace X=1 if $id!=. & F.$id==.;
*/
replace C=1 if $status=="CO";
replace E=1 if $status=="EN";
replace X=1 if $status=="EX";
save "$path1\dc_workfile", replace;

loc    tokeep1 "lntau_m lntau_a lntau_i_a lntau_f_a lntau_i_f_a";
global aggrlist "$cov `tokeep1'";
global merglist "     `tokeep1'";
global firstword = word("$aggrlist",1);
noi run "$path1\gen_decomp_aggregates.do";

use "$path1\dc_workfile", clear;
sort $ind $yr;
merge $ind $yr using "$temppath\temp"; drop if _merge==2; drop _merge;

/*within term*/;
/*two shares*/;
local shlist   "_o _i _f _i_f";
local dtaulist "_o _f";
local namelist1 "";
foreach x of local shlist {;
	if "`x'"=="_o"{;
		local sh "";
		local shsuff "d";
		};
	else if "`x'"=="_i"{;
		local sh "`x'";
		local shsuff ="i";
		};
	else if "`x'"=="_f"{;
		local sh "`x'";
		local shsuff ="f";
		};
	else {;
		local sh "`x'";
		local shsuff ="if";
		};
	/****** phi ******/
	local vname1  ="y1"+"`sh'";
	local phiname ="phi"+"`sh'";
	sort $id $yr;
	gen `vname1'= (`phiname'+L.`phiname')/2	if C==1;
	replace `vname1' = 0 if C!=1;
	foreach y of local dtaulist {;
		if "`y'"=="_o"{;
			local dt "";
			local tausuff ="d";
			};
		else {;
			local dt "_f";
			local tausuff ="f";
			};
		/****** tau ******/
		local tauname ="dlntau"+"`dt'";
		local vname2  ="y2"+"`shsuff'"+"`tausuff'";
		gen `vname2' = `vname1' * `tauname';
		local vname3 = "dc1_w"+"_s"+"`shsuff'"+"_t"+"`tausuff'";

		*by touse C $ind $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;
		 by touse C      $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;
		
		local namelist1 = "`namelist1'"+" `vname3'";
		drop `vname2';
		};
	drop `vname1';
};
noi di in green "within term of dc1 done"; 

/*between term*/
local shlist   "_o _i _f _i_f";
local ataulist "_a _i_a _f_a _i_f_a";
local namelist2 "";
foreach x of local shlist {;
	if "`x'"=="_o"{;
		local sh "";
		local shsuff "d";
		};
	else if "`x'"=="_i"{;
		local sh "`x'";
		local shsuff ="i";
		};
	else if "`x'"=="_f"{;
		local sh "`x'";
		local shsuff ="f";
		};
	else {;
		local sh "`x'";
		local shsuff ="if";
		};
	local vname1  ="b1"+"`sh'";
	local phiname ="phi"+"`sh'";
	/****** phi ******/
	sort $id $yr;
	gen `vname1'= (`phiname' - L.`phiname')	if C==1;
	replace `vname1' = 0 if C!=1;
	foreach y of local ataulist {;
		local dt "`y'";
		if "`y'"=="_a"{;
			local tausuff ="_ad";
			};
		else if "`y'"=="_i_a"{;
			local tausuff ="_ai";
			};
		else if "`y'"=="_f_a"{;
			local tausuff ="_af";
			};
		else {;
			local tausuff ="_aif";
			};

		/****** tau ******/
		local atauname ="lntau"+"`dt'";
		local Latauname="L"+"`atauname'";
		local vname2   ="b2"+"`shsuff'"+"`tausuff'";
		sort $id $yr;
		gen `vname2' = `vname1' *((lntau+L.lntau)/2 -(`atauname'+`Latauname')/2);
		local vname3 = "dc1_b"+"_s"+"`shsuff'"+"`tausuff'";

		*by touse C $ind $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;
		 by touse C      $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;

		local namelist2 = "`namelist2'"+" `vname3'";
		drop `vname2';
	};
	drop `vname1';
};
noi di in green "between term of dc1 done";

/*net entry term*/
local shlist   "_o _i _f _i_f";
local ataulist "_a _i_a _f_a _i_f_a";
local namelist30 ""; local namelist31 "";
local stringindicator "";
foreach x of local shlist {;
	if "`x'"=="_o"{;
		local sh "";
		local shsuff "d";
		};
	else if "`x'"=="_i"{;
		local sh "`x'";
		local shsuff ="i";
		};
	else if "`x'"=="_f"{;
		local sh "`x'";
		local shsuff ="f";
		};
	else {;
		local sh "`x'";
		local shsuff ="if";
		};
	local vname1  ="b1"+"`sh'";
	local phiname ="phi"+"`sh'";
	/****** phi ******/
	sort $id $yr;
	gen `vname1'= `phiname' ;
	foreach y of local ataulist {;
		local dt "`y'";
		if "`y'"=="_a"{;
			local tausuff ="_ad";
			};
		else if "`y'"=="_i_a"{;
			local tausuff ="_ai";
			};
		else if "`y'"=="_f_a"{;
			local tausuff ="_af";
			};
		else {;
			local tausuff ="_aif";
			};

		/****** tau ******/
		local vname21   = "b21"+"`shsuff'"+"`tausuff'";
		local vname22   = "b22"+"`shsuff'"+"`tausuff'";
		local atauname  = "lntau"+"`dt'";
		local Latauname = "L"+"`atauname'";
		local Fatauname = "F"+"`atauname'";
		sort $id $yr;

		gen `vname21' = `vname1' *(lntau - (`Latauname'+`atauname')/2) ;
		gen `vname22' = `vname1' *(lntau - (`Fatauname'+`atauname')/2) ;
		*by touse E $ind $yr, sort: egen vE = total(`vname21') if touse==1 & E==1;
		*by touse X $ind $yr, sort: egen vX = total(`vname22') if touse==1 & X==1;
		 by touse E      $yr, sort: egen vE = total(`vname21') if touse==1 & E==1;
		 by touse X      $yr, sort: egen vX = total(`vname22') if touse==1 & X==1;

		local vname31 = "dc1_e"+"_s"+"`shsuff'"+"`tausuff'";
		local vname32 = "dc1_x"+"_s"+"`shsuff'"+"`tausuff'";
		sort $id $yr;
		rename vE `vname31';
		rename vX `vname32';

		/*when string gets too long start another one (namelist31)*/
		*local namelist30 = "`namelist30'"+" `vname31'"+" `vname32'";
		*scalar sl=length("`namelist30'");
		*scalar ss=0;
		if "`vname32'"=="dc1_x_sf_ai"{;
			local stringindicator="now";
			local namelist33 = "`namelist30'";
		};

		if "`stringindicator'"==""{;
			local namelist30 = "`namelist30'"+" `vname31'"+" `vname32'";
			};
		else{;
			local namelist31= "`namelist31'"+" `vname31' `vname32'";
			};
		drop `vname21';
		drop `vname22';
	};
	drop `vname1';
};
noi di in green "entry/exit terms of dc1 done";

notes drop _dta;
note: "1st suffix is component name (w/b/netentry (ne))";
note: "2nd suffix is share indicator (sd - default, _si - inputshare)";
note: "3rd is aggregate tau indicator (_ad - default/_ai - calculated with input shares)";
note: "d is default; i is input";
noi notes;

global aggrlist1 "$cov	$covi lntau_m lntau_a lntau_i_a $phi_ind";
global aggrlist2 "	`namelist1'";
global aggrlist3 "	`namelist2'";
global aggrlist4 "	`namelist30'";
global aggrlist5 "	`namelist31'";
global aggrlist6 "	`namelist33'";

global merglist1 "$cov	$covi lntau_m lntau_a lntau_i_a $phi_ind";
global merglist2 "	`namelist1'";
global merglist3 "	`namelist2'";
global merglist4 "	`namelist30'";
global merglist5 "	`namelist31'";
global merglist6 "	`namelist33'";

global firstword = word("$aggrlist1",1);
save "$path1\dc1_workfile", replace;
noi run "$path1\gen_decomp_2.do";

}; /*end of main qui block*/;
