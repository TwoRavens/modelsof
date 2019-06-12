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
***		Table A21 CV
***
**********************************************************/;

args start stop inc BW maxDist; 

global inc "`inc'";
global FOLDS "10";
global BW "`BW'";

local filename "tableA21cv";


global SAMPLE "sa_val_assd>0 & r_MD_ptyd_base==0 & abs(r_D_ptyd_base)<=`maxDist'";
global VARs "sa_val_assd r_D_ptyd_base r_MD_ptyd_base BORDER";
global SampleVars "r_MD_ptyd_base";

global OUTCOME "log_val";
global FE "BORDER";
global DISTvar "r_D_ptyd_base";


cd $PATHcode;

use  $VARs if $SAMPLE using  $PATHdata/dataquick.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=(r_D_ptyd_base>0);
forvalues p=1(1)4 {;
	gen distance`p'= r_D_ptyd_base^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*r_D_ptyd_base^`p';
};
gen log_val = log(sa_val_assd);



* "fold" in cross-fold validation;
gen U=runiform();
xtile FOLD=U, nq($FOLDS);
drop U; keep if abs($DISTvar)<=`stop';



postfile cvkeep CVh h f N pol using "$PATHdata/cv/`filename'_`stop'", replace;

timer on 1;
forvalues bw=`start'($inc)`stop' {;
forvalues f=1(1)$FOLDS {;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw'   FOLD:`f'";
	

	quietly {;
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if FOLD!=`f' & abs($DISTvar)<=`bw', absorb($FE)";
		
		areg `regspec' `options';
		
		predict Xb, xb;
		predict mu, d;

		by $FE, sort: egen mu_m=mean(mu);
	
		gen eps_squ = (Xb + mu_m - $OUTCOME)^2;
		sum eps_squ if FOLD==`f' & abs($DISTvar)<=$BW;
		
		post cvkeep (r(mean)) (`bw') (`f') (r(N)) (`p');

		drop Xb-eps_squ;
	
	};
};
};
};
postclose cvkeep;
timer off 1;
timer list;


