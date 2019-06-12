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
***		RD estimates at CV-optimal BW
***
**********************************************************/;


local steps = "3500(500)35000";
local steps17 = "4000(1000)50000";
local steps18 = "4000(1000)50000";


cd $PATHcode;


*** Table 9;
log using $PATHlogs/log_table9cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/table9cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_vote r_D_ptyd_base r_dem BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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

* panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("main_rf") opt("modify");
	
};

* panel B;
forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("main_tsls") opt("modify");
		

};

log close;




*** Table 10;
log using $PATHlogs/log_table10cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
     append using $PATHdata/cv/table10cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!"; 
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptya_base==0 & abs(r_distance)<=`maxDist' & r_other_none==1";
global VARs "r_vote r_D_ptya_base BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptya_base r_distance r_other_none";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptya_base";
global ADvar "r_ptya_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  ($ADvar = T ) distance1-distance`p' T_x_distance1-T_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[$ADvar];
	local s=_se[$ADvar];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("other_tot_tsls") opt("modify");
		

};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/table10cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptya_base==0 & abs(r_distance)<=`maxDist'";
global VARs "r_vote r_D_ptya_base BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptya_base r_distance r_other_none";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptya_base";
global ADvar "r_ptya_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  ($ADvar = T ) distance1-distance`p' T_x_distance1-T_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[$ADvar];
	local s=_se[$ADvar];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("all_tot_tsls") opt("modify");
		

};


log close;





*** Table A22;
log using $PATHlogs/log_tableA22cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA22cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & r_dem==1";
global VARs "r_vote r_D_ptyd_base BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_dem";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("dem_rf") opt("modify");
	
};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA22cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & r_rep==1";
global VARs "r_vote r_D_ptyd_base BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("rep_rf") opt("modify");
	
};


log close;






*** Table A23;
log using $PATHlogs/log_tableA23cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA23cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1) & YEAR==2008";
global VARs "r_vote r_D_ptyd_base r_dem BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep YEAR";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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


forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("y2008_tsls") opt("modify");
		

};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA23cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1) & YEAR==2012";
global VARs "r_vote r_D_ptyd_base r_dem BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep YEAR";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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


forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("y2012_tsls") opt("modify");
		

};

log close;






*** Table A24;
log using $PATHlogs/log_tableA24cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA24cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_D_ptyd_base BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_dem r_rep";

global OUTCOME "r_ptyd_base_own";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("main_fs") opt("modify");
	
};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA24cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptya_base==0 & abs(r_distance)<=`maxDist'";
global VARs "r_D_ptya_base BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptya_base r_distance";

global OUTCOME "r_ptya_base_own";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptya_base";
global ADvar "r_ptya_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("all_tot_fs") opt("modify");
	
};

log close;






*** Table A13;
log using $PATHlogs/log_tableA13cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA13cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & r_Mhouse_tenure==0";
global VARs "r_house_tenure r_D_ptyd_base BORDER BORDER_10k YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_Mhouse_tenure";

global OUTCOME "r_house_tenure";
global FE "BORDER_10k_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("disc_house_tenure") opt("modify");
	
};


log close;






*** Table A14;
log using $PATHlogs/log_tableA14cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA14cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & r_Mage==0";
global VARs "r_age r_D_ptyd_base BORDER BORDER_10k YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_Mage";

global OUTCOME "r_age";
global FE "BORDER_10k_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("disc_age") opt("modify");
	
};


log close;





*** Table A15;
log using $PATHlogs/log_tableA15cv.txt, replace;

clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA15cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & r_Mfemale==0";
global VARs "r_female r_D_ptyd_base BORDER BORDER_10k* YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_Mfemale";

global OUTCOME "r_female";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("disc_female") opt("modify");
	
};


log close;





*** Table A16;
log using $PATHlogs/log_tableA16cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA16cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist'";
global VARs "r_other_none r_D_ptyd_base BORDER BORDER_10k YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance";

global OUTCOME "r_other_none";
global FE "BORDER_10k_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("disc_party") opt("modify");
	
};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA16cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_dem r_D_ptyd_base BORDER BORDER_10k YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_dem";
global FE "BORDER_10k_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("disc_dem") opt("modify");
	
};


log close;






*** Table A18;
log using $PATHlogs/log_tableA18cv.txt, replace;

clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA18cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist'";
global VARs "r_oth_ptyd_base_own r_D_ptyd_base BORDER BORDER_10k YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance";

global OUTCOME "r_oth_ptyd_base_own";
global FE "BORDER_10k_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};
egen BORDER_10k_YEAR=group(BORDER_10k YEAR);


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("disc_cmag_other_party_diff") opt("modify");
	
};


log close;





*** Table A19;
log using $PATHlogs/log_tableA19cv.txt, replace;


clear;

forvalues q=`steps17' {;
    append using $PATHdata/cv/tableA19cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global OUTCOME "r_circ_hh";
global FE "BORDER_PAPER_YEAR";
global DISTvar "r_D_ptyd_base";


* load data;
use if r_Mcirc_hh==0 & abs(r_D_ptyd_base)<=`maxDist' using $PATHdata/newspapers, clear;

** keep only papers that have any circulation somewhere around a particular border;
by BORDER_PAPER_YEAR, sort: egen avcirc=mean(r_circ_hh);
keep if avcirc>0;



forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("newspapers") opt("modify");
	
};


log close;











*** Table A21;
log using $PATHlogs/log_tableA21cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA21cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global varlist "sa_val_assd r_D_ptyd_base r_MD_ptyd_base BORDER";
global sample "sa_val_assd>0 & r_MD_ptyd_base==0";

global OUTCOME "log_val";
global FE "BORDER";
global DISTvar "r_D_ptyd_base";

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



forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("home_val") opt("modify");
	
};


log close;






*** Table A25;
log using $PATHlogs/log_tableA25cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA25cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_vote r_D_ptyd_base r_dem r_female r_Mfemale r_house_tenure r_Mhouse_tenure r_age r_Mage r_oth_ptyd_base_own BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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

* panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local controls = "r_female r_Mfemale r_house_tenure r_Mhouse_tenure r_age r_Mage r_oth_ptyd_base_own";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `controls' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("rob_controls_rf") opt("modify");
	
};

* panel B;
forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local controls = "r_female r_Mfemale r_house_tenure r_Mhouse_tenure r_age r_Mage r_oth_ptyd_base_own";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `controls' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("rob_controls_tsls") opt("modify");
		

};

log close;







*** Table A26;
log using $PATHlogs/log_tableA26cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA26cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1) & r_matched_street==1";
global VARs "r_vote r_D_ptyd_base r_dem BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep r_matched_street";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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

* panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("rob_street_rf") opt("modify");
	
};

* panel B;
forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("rob_street_tsls") opt("modify");
		

};

log close;








*** Table A27;
log using $PATHlogs/log_tableA27cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA27cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_vote r_D_ptyd_base r_dem BORDER CD_BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote";
global FE "CD_BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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

* panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("CDfe_rf") opt("modify");
	
};

* panel B;
forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("CDfe_tsls") opt("modify");
		

};

log close;




*** Table A28;
log using $PATHlogs/log_tableA28cv.txt, replace;


clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA28cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1)";
global VARs "r_vote r_D_ptyd_base r_dem BORDER BORDER_20k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote";
global FE "BORDER_20k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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

* panel A;
forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("fe20k_rf") opt("modify");
	
};

* panel B;
forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("fe20k_tsls") opt("modify");
		

};

log close;








*** Table A29;
log using $PATHlogs/log_tableA29cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA29cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=`maxDist' & (r_dem==1 | r_rep==1) & r_sigviewed==0";
global VARs "r_vote r_D_ptyd_base r_dem BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep r_sigviewed";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
gen byte T_x_dem=T*r_dem;
gen PDIFFdem=$ADvar*r_dem;
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


forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  (PDIFFdem $ADvar = T T_x_dem) distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[PDIFFdem];
	local s=_se[PDIFFdem];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("rob_sigviewed_tsls") opt("modify");
		

};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA29cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptya_base==0 & abs(r_distance)<=`maxDist' & r_sigviewed==0";
global VARs "r_vote r_D_ptya_base r_dem BORDER BORDER_10k_PARTY_YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptya_base r_distance r_sigviewed";

global OUTCOME "r_vote";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptya_base";
global ADvar "r_ptya_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

* helper vars;
gen byte T=($DISTvar>0);
forvalues p=1(1)4 {;
	gen distance`p'= $DISTvar^`p';
};
forvalues p=1(1)4 {;
	gen T_x_distance`p'= T*$DISTvar^`p';
};


forvalues p=1(1)4 {;

	di "POLYNOMIAL: degree `p' BANDWIDTH: `bw`p'' meters";

	preserve;
	keep if abs($DISTvar)<=`bw`p'';
	
	local regspec "$OUTCOME  ($ADvar = T ) distance1-distance`p' T_x_distance1-T_x_distance`p'";
	local options ", cluster(BORDER) fe($FE) demean";
		
	tsls `regspec' `options';
		
	local c=_b[$ADvar];
	local s=_se[$ADvar];
	local N=_N;
		
	restore;

	putexcel_wrapper_cv, coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("aggt_sigviewed_tsls") opt("modify");
		

};


log close;




*** Table A20;
log using $PATHlogs/log_tableA20cv.txt, replace;


clear;

forvalues q=`steps18' {;
    append using $PATHdata/cv/tableA20cv_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


* estimates at C-V optimal bandwidth;
global OUTCOME "r_ln_cur_exp_ps";
global FE "BORDER_YEAR";
global DISTvar "r_D_ptyd_base";


* load data;
use $PATHdata/schools, clear;

keep if ELEMENTARY==1 | SECONDARY==1 | COMBINED==1;
keep if r_Mln_cur_exp_ps==0;



forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T distance1-distance`p' T_x_distance1-T_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T];
		local s=_se[T];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("schools") opt("modify");
	
};
log close;


*** Table A17;
log using $PATHlogs/log_tableA17cv.txt, replace;

* panel A;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA17cvA_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=5000 & (r_dem==1 | r_rep==1)";
global VARs "r_vote_next_midterm r_vote_prev_primary r_D_ptyd_base r_ptyd_base_own YEAR r_dem BORDER* ID";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote_prev_primary";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

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


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("prev_prim_rf") opt("modify");
	
};


* panel B;
clear;

forvalues q=`steps' {;
    append using $PATHdata/cv/tableA17cvB_`q'.dta;  
};

collapse (mean) CVh [aw=N], by(h pol);
by pol, sort: egen m=min(CVh);
forvalues p=1(1)4 {;
	sum h if pol==`p' & CVh==m;
    if r(N)==1 {;
        local bw`p' = r(mean);
    };
    else {;
        local bw`p' = r(max);  di "more than one CV-optimal BW!";
    };  
};
local maxDist = max(`bw1',`bw2',`bw3',`bw4');


global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0 & abs(r_distance)<=5000 & (r_dem==1 | r_rep==1)";
global VARs "r_vote_next_midterm r_vote_prev_primary r_D_ptyd_base r_ptyd_base_own YEAR r_dem BORDER* ID";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base r_distance r_rep";

global OUTCOME "r_vote_next_midterm";
global FE "BORDER_10k_PARTY_YEAR";
global DISTvar "r_D_ptyd_base";
global ADvar "r_ptyd_base_own";


* load data;
use $VARs $SampleVars $ADvar if $SAMPLE using $PATHdata/voterpanel.dta, clear;
drop $SampleVars;

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


forvalues p=1(1)4 {;
	
	di "POLYNOMIAL: `p'   BANDWIDTH: `bw`p''";
	
	
		local regspec "$OUTCOME T_x_dem T distance1-distance`p' dem_x_distance1-dem_x_distance`p' T_x_distance1-T_x_distance`p' T_x_dem_x_distance1-T_x_dem_x_distance`p'";
		local options "if abs($DISTvar)<=`bw`p'', absorb($FE) cluster(BORDER)";
		
		areg `regspec' `options';
		
		local c=_b[T_x_dem];
		local s=_se[T_x_dem];
		local bw=`bw`p'';
		putexcel_wrapper_cv  , coeff(`c') se(`s') p(`p') bw(`bw`p'') file("$PATHlogs/RDresults") sheet("next_gen_rf") opt("modify");
	
};


log close;



