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
***		Figure 3
***
**********************************************************/;

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=25000 & (r_dem==1 | r_rep==1)";
global VARs "r_vote r_D_ptyd_base r_ptyd_base_own r_dem";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";


log using $PATHlogs/log_figure3.txt, replace;

cd $PATHcode;


use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;

local lb=-25000;
local ub=25000;
local bins=20;


postfile sca bin d_r_v using $PATHdata/figure3, replace;

gen BIN=.;

forvalues b=1(1)`bins' {;

	quietly {;
		replace BIN= `b'  if r_D_ptyd_base>=`lb'+(`b'-1)*(`ub'-`lb')/`bins' & r_D_ptyd_base<`lb'+`b'*(`ub'-`lb')/`bins';

		reg r_vote r_dem  if BIN==`b';
		local d_r_v = _b[r_dem];
	
	
		local mp=(`lb'+(`b'-1)*(`ub'-`lb')/`bins' + `lb'+`b'*(`ub'-`lb')/`bins')/2;
	};
	
	post sca (`mp') (`d_r_v');
};
postclose sca;


use $PATHdata/figure3, clear;

twoway (scatter d_r_v  bin if bin<0) (scatter d_r_v  bin if bin>0)  (lfitci d_r_v bin if bin<0, ciplot(rline)) (lfitci d_r_v bin if bin>0, legend(off) ciplot(rline));
graph play "$PATHcode/figure3.grec";
graph save Graph "$PATHlogs/figure3.gph", replace;
graph export "$PATHlogs/figure3.eps", replace;




log close;

