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
*** Figure A12
***
**********************************************************/;

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=30000";
global VARs "r_D_ptyd_base";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance";


log using $PATHlogs/log_figureA12.txt, replace;

cd $PATHcode;


use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;



quietly:  DCdensity r_D_ptyd_base, breakpoint(0) b(1000) h(2500) generate(Xj Yj r0 fhat se_fhat) nograph;
count;
local o=r(N);
replace Yj=`o' * Yj * 1000;
replace fhat=`o' * fhat * 1000;
twoway (scatter Yj Xj if abs(Xj)<25000, xline(0)) (line fhat r0 if abs(r0)<25000 & r0>0) (line fhat r0 if abs(r0)<25000 & r0<0);
graph play "$PATHcode/figureA12.grec";
graph save Graph "$PATHlogs/figureA12.gph", replace;
graph export "$PATHlogs/figureA12.eps", replace;








log close;
