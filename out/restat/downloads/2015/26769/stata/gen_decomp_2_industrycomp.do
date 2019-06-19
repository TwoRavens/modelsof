#delim;
qui {;

/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

forvalues num=1/3 {;
	local alname = "aggrlist"+"`num'";
	local mlname = "merglist"+"`num'";
	global aggrlist = "$`alname'";
	global merglist = "$`mlname'";
	
	if "`num'"!="1" {;
		use "$path2\dc_workfile_industry", clear;
		};
	
	/*
	noi di in green "aggrlist:";
	noi di in yellow "$aggrlist";
	noi di in green "merglist:";
	noi di in yellow "$merglist";
	noi di in green "+++";
	*/
	noi run "$path3\outsiders\gen_decomp_aggregates.do";

	sort $ind $yr;
	save "$temppath\temp`num'", replace;
};


noi di in white "tempfiles ready for final merge";
use "$temppath\temp1.dta", clear;
tsset $ind $yr; tsfill;

forvalues num=2/3 {;
	local alname = "aggrlist"+"`num'";
	local mlname = "merglist"+"`num'";
	global aggrlist = "$`alname'";
	global merglist = "$`mlname'";
	sort $ind $yr;
	merge $ind $yr using "$temppath\temp`num'.dta", keep("$aggrlist"); drop if _merge==2;
	drop _merge;
	};

noi di in green "calculate net entry terms with all p. components";
*noi di in white "(need to pick relevant ones only later)";
tab $yr, matrow(yr); tab $ind, matrow(ind);

gen dc1_e_sd_ad=.;
gen dc1_x_sd_ad=.;
tsset $ind $yr;
local shsufflist   "_sd";
local tausufflist  "_ad";
local nelist "";
foreach x of local shsufflist {;
	foreach y of local tausufflist {;
		local vnamein1="dc1_e"+"`x'"+"`y'";
		local vnamein2="dc1_x"+"`x'"+"`y'";
		local vnameout="dc1_ne"+"`x'"+"`y'";
		local nelist = "`nelist'"+" `vnameout'";
		sort $ind $yr;
		global filluplist "`vnamein1' `vnamein2'";
		noi run "$path3\outsiders\fillup_aggregates.do";
		replace `vnamein1'=0 if `vnamein1'==.;
		replace `vnamein2'=0 if `vnamein2'==.;
		gen `vnameout'=`vnamein1'-L.`vnamein2';
		*replace `vnameout'=`vnamein1' if $yr==1978;
		};	
	};
sort $ind $yr;

/*
drop	Fcov Lcov Fcov_i Lcov_i Flntau_m Llntau_m 
	Flntau_a Llntau_a Flntau_i_a Llntau_i_a 
	Fphi_$ind Lphi_$ind;
*/
/*
/*compile aggregate manufacturing results*/
global nelist = "`nelist'";
*local myaggrlist "aggrlist2 aggrlist3 aggrlist4 nelist";
local myaggrlist "aggrlist2 aggrlist3 		 nelist";
foreach x of local myaggrlist {;

	local alname = "`x'";
	local mlname = "`x'";
	local aggrlist = "$`alname'";
	local merglist = "$`mlname'";
		foreach var in `aggrlist' {;
			loc ls=substr("`var'",5,.);
			gen y=$phi_ind*`var';
			by $yr, sort: egen man=total(y);
			sort $ind $yr;
			loc lsm="m_"+"`ls'";
			gen `lsm'=man; 
			drop man y;
		};
};
*/
/*gen y         = $phi_ind*lntau_a; by $yr, sort: egen x=total(y);*/
sort $ind $yr;
gen logdiff_ag= lntau_a-L.lntau_a;
*gen simple_i= lntau_i_a-L.lntau_i_a;
gen decomp = dc1_w_sd_td + dc1_b_sd_ad + dc1_ne_sd_ad;
*gen si_ai = dc1_w_si_td + dc1_b_si_ai + dc1_ne_si_ai;

save "$path2\dc_workfile_industry", replace;

}; /*end of qui block*/;
