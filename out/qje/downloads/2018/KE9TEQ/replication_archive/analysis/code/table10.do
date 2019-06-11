/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do

#delim;


/**********************************************************
***
***		Table 10
***
**********************************************************/;

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptya_base==0 & abs(r_distance)<=5000";
global VARs "r_vote r_D_ptya_base r_ptya_base_own BORDER* r_other_none";
global SampleVars "r_registered r_matched_none r_MD_ptya_base r_distance";


log using $PATHlogs/log_table10.txt, replace;

cd $PATHcode;


use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;

* helper vars;
gen byte T=(r_D_ptya_base>0);
forvalues p=1(1)4 {;
	gen distance`p'= r_D_ptya_base^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*r_D_ptya_base^`p';
};



*** cols (1)-(3) panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";

		preserve;
		keep if abs(r_D_ptya_base)<=`bw' & r_other_none==1;

		
		tsls r_vote  (r_ptya_base_own = T) distance1-distance`p' T_x_distance1-T_x_distance`p', cluster(BORDER) fe(BORDER_10k_PARTY_YEAR) demean;
		
		local c=_b[r_ptya_base_own];
		local s=_se[r_ptya_base_own];
		local N=_N;
		
		putexcel_wrapper, coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("other_tot_tsls") opt("modify");
		
		restore;
		

	};
};



*** cols (1)-(3) panel B;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";

		preserve;
		keep if abs(r_D_ptya_base)<=`bw';

		
		tsls r_vote  (r_ptya_base_own = T) distance1-distance`p' T_x_distance1-T_x_distance`p', cluster(BORDER) fe(BORDER_10k_PARTY_YEAR) demean;
		
		local c=_b[r_ptya_base_own];
		local s=_se[r_ptya_base_own];
		local N=_N;
		
		putexcel_wrapper, coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("all_tot_tsls") opt("modify");
		
		restore;
		

	};
};


log close;

