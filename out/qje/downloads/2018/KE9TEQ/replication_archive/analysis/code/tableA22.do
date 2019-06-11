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
***		Table A.22
***
**********************************************************/;

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=5000 & (r_dem==1 | r_rep==1)";
global VARs "r_vote r_D_ptyd_base r_ptyd_base_own r_dem r_rep BORDER*";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance";


log using $PATHlogs/log_tableA22.txt, replace;

cd $PATHcode;

use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;

* helper vars;
gen byte T=(r_D_ptyd_base>0);
forvalues p=1(1)4 {;
	gen distance`p'= r_D_ptyd_base^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*r_D_ptyd_base^`p';
};


*** cols (1)-(3) panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";
		
			
		areg r_vote
		T 
		distance1-distance`p' 
		T_x_distance1-T_x_distance`p'
		if abs(r_D_ptyd_base)<=`bw' & (r_dem==1), cluster(BORDER) absorb(BORDER_10k_PARTY_YEAR);
		
		local c=_b[T];
		local s=_se[T];
		local N=e(N);
		putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("dem_rf") opt("modify");


		
	};
};


*** cols (1)-(3) panel B;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";

		areg r_vote
		T 
		distance1-distance`p' 
		T_x_distance1-T_x_distance`p'
		if abs(r_D_ptyd_base)<=`bw' & (r_rep==1), cluster(BORDER) absorb(BORDER_10k_PARTY_YEAR);
		
		local c=_b[T];
		local s=_se[T];
		local N=e(N);
		putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("rep_rf") opt("modify");
		

	};
};


log close;

