#delim;
qui {;
clear;
set more off;
pause on;
set mem 200m;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Aug-25-2010*/ 
/*decomps*/
/*
Inputs:	EUKLEMS output from industry_components.do	
*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
loc fname1="$path2"+"$nameout";

/*--------------------------------------------------------------*/
global cov "cov";
*global covi "cov_i";
*global cov_f "cov_f";
*global covi_f "cov_i_f";

noi use "`fname1'", clear;

gen lntau=ln($tau);
gen mistau=0; replace mistau=1 if lntau==.;

gen phi=$phi;

/*** OP term ***/
/*       $ind   */
by $ind $yr, sort: egen simpleag=total(phi*lntau)			;
by $ind $yr, sort: egen lntau_m=mean(lntau)				;
by $ind $yr, sort: egen x1 = mean(phi)					;
by $ind $yr, sort: egen x3 = total((phi  - x1)*(lntau-lntau_m))	;
rename x3 $cov;
drop x1;


sort $id $yr;
gen double dlntau		= lntau	-	L.lntau;
/*aggr prod with two shares*/
gen double lntau_a	= lntau_m	+	$cov;

/*** mark Con/eN/Ex, can be switched off ***/
sort $id $yr;
gen C=0; gen E=0; gen X=0;
noi di in green "mark X observations relative to t";
noi di in green "ie for last t of C==1: X==1";
replace C=1 if $id!=. & L.$id!=.;
replace E=1 if $id!=. & L.$id==.;
replace X=1 if $id!=. & F.$id==.;

pause;
save "$path3\dc_workfile_industry", replace;

loc    tokeep1 "lntau_m lntau_a";
global aggrlist "$cov `tokeep1'";
global merglist "     `tokeep1'";
global firstword = word("$aggrlist",1);

noi run "$path3\outsiders\gen_decomp_aggregates.do";

use "$path3\dc_workfile_industry", clear;
sort $ind $yr;
merge $ind $yr using "$temppath\temp"; drop if _merge==2; drop _merge;

/*within term*/;
local shlist   "_o";
local dtaulist "_o";
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

		 by touse C $ind $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;
		*by touse C      $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;
		
		local namelist1 = "`namelist1'"+" `vname3'";
		drop `vname2';
		};
	drop `vname1';
};
noi di in green "within term of dc1 done"; 

/*between term*/
local shlist   "_o";
local ataulist "_a";
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

		 by touse C $ind $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;
		*by touse C      $yr, sort: egen `vname3' = total(`vname2') if touse==1 & C==1;

		local namelist2 = "`namelist2'"+" `vname3'";
		drop `vname2';
	};
	drop `vname1';
};
noi di in green "between term of dc1 done";

/*net entry term*/
local shlist   "_o";
local ataulist "_a";
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
		 by touse E $ind $yr, sort: egen vE = total(`vname21') if touse==1 & E==1;
		 by touse X $ind $yr, sort: egen vX = total(`vname22') if touse==1 & X==1;
		*by touse E      $yr, sort: egen vE = total(`vname21') if touse==1 & E==1;
		*by touse X      $yr, sort: egen vX = total(`vname22') if touse==1 & X==1;

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

global aggrlist1 "$cov lntau_m lntau_a";
global aggrlist2 "	`namelist1'";
global aggrlist3 "	`namelist2'";
*global aggrlist4 "	`namelist30'";
*global aggrlist5 "	`namelist31'";
*global aggrlist6 "	`namelist33'";

global merglist1 "$cov lntau_m lntau_a";
global merglist2 "	`namelist1'";
global merglist3 "	`namelist2'";
*global merglist4 "	`namelist30'";
*global merglist5 "	`namelist31'";
*global merglist6 "	`namelist33'";

global firstword = word("$aggrlist1",1);
save "$path2\dc_workfile_industry", replace;

noi run "$path3\newcode\gen_decomp_2_industrycomps.do";

}; /*end of main qui block*/;
