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
***		Table A21
***
**********************************************************/;


log using $PATHlogs/log_tableA21.txt, replace;

cd $PATHcode;


global varlist "sa_val_assd r_D_ptyd_base r_MD_ptyd_base BORDER";
global sample "sa_val_assd>0 & r_MD_ptyd_base==0";

use  $varlist if $sample using  $PATHdata/dataquick.dta, clear;

* helper vars;
gen byte T=(r_D_ptyd_base>0);
forvalues p=1(1)4 {;
	gen distance`p'= r_D_ptyd_base^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*r_D_ptyd_base^`p';
};
gen log_val = log(sa_val_assd);



*** cols (1)-(3);
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	
	foreach bw in 500 1000 5000 {;

		di "BANDWIDTH: `bw' meters";
		
			
		areg log_val
		T 
		distance1-distance`p'
		T_x_distance1-T_x_distance`p'
		if abs(r_D_ptyd_base)<=`bw', cluster(BORDER) absorb(BORDER);

	
		local c=_b[T];
		local s=_se[T];
		local N=e(N);
		putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`bw') n(`N') file("$PATHlogs/RDresults") sheet("home_val") opt("modify");


		
	};
};


log close;

