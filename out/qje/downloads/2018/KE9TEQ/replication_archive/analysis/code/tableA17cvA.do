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
***		Table A17 CV, panel A
***
**********************************************************/;

args start stop inc BW maxDist; 

global inc "`inc'";
global FOLDS "10";
global BW "`BW'";

local filename "tableA17cvA";

global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_vote_next_midterm r_vote_prev_primary r_D_ptyd_base r_ptyd_base_own YEAR r_dem BORDER* ID";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote_prev_primary";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";



cd $PATHcode;

* load data;
use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;


* "fold" in cross-fold validation;
gen U=runiform();
xtile FOLD=U, nq($FOLDS);
drop U; keep if abs($DISTvar)<=`stop';

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen dem_x_distance`p'=r_dem*$DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_dem_x_distance`p'= T*r_dem*$DISTvar^`p';
};


postfile cvkeep CVh h f N pol using "$PATHdata/cv/`filename'_`stop'", replace;

timer on 1;
forvalues bw=`start'($inc)`stop' {;
forvalues f=1(1)$FOLDS {;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw'   FOLD:`f'";
	

	quietly {;
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
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

