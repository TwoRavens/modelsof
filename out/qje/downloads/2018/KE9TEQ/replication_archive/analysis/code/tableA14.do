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
***		Table A.14
***
**********************************************************/;

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0  & abs(r_distance)<=5000 & r_Mage==0";
global VARs "r_age r_D_ptyd_base BORDER* YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_Mage";


log using $PATHlogs/log_tableA14.txt, replace;


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
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);



*** cols (1)-(3);
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";
		
			
		areg r_age
		T 
		distance1-distance`p' 
		T_x_distance1-T_x_distance`p'
		if abs(r_D_ptyd_base)<=`bw', cluster(BORDER) absorb(BORDER_10k_YEAR);
		
		local c=_b[T];
		local s=_se[T];
		local N=e(N);
		putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("disc_age") opt("modify");


		
	};
};






log close;

