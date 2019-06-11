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
***		Table A20
***
**********************************************************/;


log using $PATHlogs/log_tableA20.txt, replace;

cd $PATHcode;


use $PATHdata/schools, clear;

keep if ELEMENTARY==1 | SECONDARY==1 | COMBINED==1;
keep if r_Mln_cur_exp_ps==0;

* current educational expenditures per student;

forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: degree `p'";
	
	foreach bw in 5000 10000 15000 {;

		di "BANDWIDTH: `bw' meters";
	
	
			areg r_ln_cur_exp_ps
			T 
			distance1-distance`p' 
			T_x_distance1-T_x_distance`p'
			if abs(r_D_ptyd_base)<`bw', cluster(BORDER_YEAR) absorb(BORDER);

			local c=_b[T];
			local s=_se[T];
			local N=e(N);
			if `bw'==5000 {;
				local q = 500;
			};
			else if `bw'==10000 {;
				local q = 1000;
			};
			else {;
				local q = 5000;
			};	
			putexcel_wrapper  , coeff(`c') se(`s') p(`p') bw(`q') n(`N') file("$PATHlogs/RDresults") sheet("schools") opt("modify");
		

	};
};


log close;








