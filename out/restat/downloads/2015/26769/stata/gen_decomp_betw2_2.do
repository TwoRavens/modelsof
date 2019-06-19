#delim;
qui {;
set more off;
noi di in red "call gen_decomp_aggregates.do to get other vars...";

forvalues num=1/3 {;
	local alname = "aggrlist"+"`num'";
	local mlname = "merglist"+"`num'";
	global aggrlist = "$`alname'";
	global merglist = "$`mlname'";
	
	if "`num'"!="1" {;
		use "$path1\dc2_workfile", clear;
		};
	
	/*
	noi di in green "aggrlist:";
	noi di in yellow "$aggrlist";
	noi di in green "merglist:";
	noi di in yellow "$merglist";
	noi di in green "+++";
	*/
	noi run "$path1\gen_decomp_aggregates.do";
	sort $ind $yr;
	save "$temppath\temp`num'", replace;
};

noi di in white "tempfiles ready for final merge";

use "$temppath\temp1.dta", clear;
forvalues num=2/3 {;
	local alname = "aggrlist"+"`num'";
	local mlname = "merglist"+"`num'";
	global aggrlist = "$`alname'";
	global merglist = "$`mlname'";
	sort $ind $yr;
	merge $ind $yr using "$temppath\temp`num'.dta", keep("$aggrlist"); drop if _merge==2;
	drop _merge;
	};

sort $ind $yr;

}; /*end of qui block*/;
