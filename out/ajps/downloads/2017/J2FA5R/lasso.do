#delim;
preserve;

local KREISsample_lasso "r_MNSDAP_NOV1932_p==0 & r_M1925C_kath==0 & KREIS==1";
local religion_lasso "r_1925C_kath";
local demographics_lasso "r_1925C_juden r_M1925C_juden r_1925C_others r_M1925C_others r_1933C_frauen r_M1933C_frauen r_stadtkreis r_1925C_logtotpop r_M1925C_logtotpop";
local employment_lasso "r_1933C_arbfrau r_M1933C_arbfrau r_1933C_ang_arbeitslos r_M1933C_ang_arbeitslos r_1933C_arb_arbeitslos r_M1933C_arb_arbeitslos r_1933C_hausang_arbeitslos r_M1933C_hausang_arbeitslos";
local industry_lasso "r_1933C_ind r_M1933C_ind r_1933C_hand r_M1933C_hand r_1933C_oeffprivd r_M1933C_oeffprivd r_1933C_haus r_M1933C_haus";
local workforce_lasso "r_1933C_angest r_M1933C_angest r_1933C_beamt r_M1933C_beamt r_1933C_arb r_M1933C_arb r_1933C_hausang r_M1933C_hausang r_1933C_selbst r_M1933C_selbst";
local WK_lasso "_WKNR_1 _WKNR_2 _WKNR_3 _WKNR_4 _WKNR_5 _WKNR_6 _WKNR_7 _WKNR_8 _WKNR_9 _WKNR_10 _WKNR_11 _WKNR_12 _WKNR_13 _WKNR_14 _WKNR_15 _WKNR_16 _WKNR_17 _WKNR_18 _WKNR_19 _WKNR_20 _WKNR_21 _WKNR_22 _WKNR_23 _WKNR_24 _WKNR_25 _WKNR_26 _WKNR_27 _WKNR_28 _WKNR_29 _WKNR_30 _WKNR_31 _WKNR_32 _WKNR_33 _WKNR_34 _WKNR_35";
local geo_lasso "r_latitude r_longitude r_distance_berlin r_distance_nearestcity r_distance_border r_distance_seaport r_distance_river r_distance_resources";
local OLScontrols "`demographics_lasso' `employment_lasso' `industry_lasso' `workforce_lasso' `WK_lasso' `geo_lasso'";

* keep only estimation sample;
keep if `KREISsample_lasso';

* create LASSO variables;
local O ;
local counter = 1;
foreach w of local OLScontrols { ;
	foreach x of local OLScontrols { ;
				quietly : gen O`counter' = `w' * `x'  ;
				local tempname = "O`counter'" ;
				local O : list O | tempname ;
				local counter = `counter'+1;
	};
} ;
gen one=1;
local AllC : list OLScontrols | O;

* remove collinear vars;
_rmcollright  `AllC';
local dropped `r(dropped)';
local AllC : list AllC - dropped;	

* outcome equ;
lassoShooting r_NSDAP_NOV1932_p `AllC' , controls(one) lasiter(100) verbose(1) fdisplay(0) ;
local yvSel `r(selected)' ;
di "`ySel'" ;

* X equ;
lassoShooting `religion_lasso' `AllC' , controls(one) lasiter(100) verbose(1) fdisplay(0) ;
local xvSel `r(selected)' ;
di "`xSel'" ;

* union of selected instruments ;
local vDS : list ySel | xSel ;

* regression with selected controls ;
reg r_NSDAP_NOV1932_p `religion_lasso' `vDS' , cluster(WKNR) ;

restore;