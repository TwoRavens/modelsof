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
***		Table A19
***
**********************************************************/;


log using $PATHlogs/log_tableA19.txt, replace;


cd $PATHcode;

use if r_Mcirc_hh==0 & abs(r_D_ptyd_base)<=35000 using $PATHdata/newspapers, clear;

** keep only papers that have any circulation somewhere around a particular border;
by BORDER_PAPER_YEAR, sort: egen avcirc=mean(r_circ_hh);
keep if avcirc>0;

* discontinuities in circulation?;

forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	
	foreach bw in 2500 5000 7500 {;

		di "BANDWIDTH: `bw' meters";
	
	
			areg r_circ_hh
			T 
			distance1-distance`p' 
			T_x_distance1-T_x_distance`p'
			if abs(r_D_ptyd_base)<`bw' & r_Mcirc_hh==0, cluster(BORDER) absorb(BORDER_PAPER_YEAR);
		
			local c=_b[T];
			local s=_se[T];
			local N=e(N);
			if `bw'==2500 {;
				local q = 500;
			};
			else if `bw'==5000 {;
				local q = 1000;
			};
			else {;
				local q = 5000;
			};	
			putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`q') n(`N') file("$PATHlogs/RDresults") sheet("newspapers") opt("modify");

	};
};




log close;









