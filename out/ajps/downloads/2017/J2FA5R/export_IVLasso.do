#delim;


use main_data, replace;


local KREISsample "r_MNSDAP_NOV1932_p==0 & r_M1925C_kath==0 & KREIS==1";

local ivcontrols1 "r_1925C_juden r_1933C_frauen r_M1933C_frauen r_stadtkreis r_1925C_logtotpop";
local ivcontrols2 "r_1933C_arbfrau r_1933C_ang_arbeitslos r_M1933C_ang_arbeitslos r_1933C_arb_arbeitslos r_1933C_hausang_arbeitslos";
local ivcontrols3 "r_1933C_ind r_1933C_hand r_1933C_oeffprivd r_1933C_haus";
local ivcontrols4 "r_1933C_angest r_1933C_arb r_1933C_beamt r_1933C_selbst r_1933C_hausang";
local ivcontrols5 "r_latitude r_longitude r_distance_berlin r_distance_nearestcity r_distance_border r_distance_seaport r_distance_river r_distance_resources";
local ivcontrols6 "r_reichsmatrikel r_Mreichsmatrikel r_ecclesiastical r_Mecclesiastical r_distance_wittenberg r_press";

local WK "_WKNR_1 _WKNR_2 _WKNR_3 _WKNR_4 _WKNR_5 _WKNR_6 _WKNR_7 _WKNR_8 _WKNR_9 _WKNR_10 _WKNR_11 _WKNR_12 _WKNR_13 _WKNR_14 _WKNR_15 _WKNR_16 _WKNR_17 _WKNR_18 _WKNR_19 _WKNR_20 _WKNR_21 _WKNR_22 _WKNR_23 _WKNR_24 _WKNR_25 _WKNR_26 _WKNR_27 _WKNR_28 _WKNR_29 _WKNR_30 _WKNR_31 _WKNR_32 _WKNR_33 _WKNR_34 _WKNR_35";

local z "r_kath1624 r_gem1624";

local IVcontrols "`ivcontrols1' `ivcontrols2' `ivcontrols3' `ivcontrols4' `ivcontrols5' `ivcontrols6' `WK'";


* keep only estimation sample;
keep if `KREISsample';


* outocme;
gen y = r_NSDAP_NOV1932_p;


* rename control variables;
local C ;
local counter = 1;
foreach w of local IVcontrols { ;

				quietly : gen C`counter' = `w' ;
				local tempname = "C`counter'" ;
				local C : list C | tempname ;
				
				local counter = `counter'+1;

} ;

* instruments & interactions;
gen Z1 = r_kath1624;
gen Z2 = r_gem1624;
local Z "Z1 Z2";
local counter = 3;
foreach w of local z { ;
	foreach x of local WK {;

				quietly : gen Z`counter' = `w' * `x' ;
				local tempname = "Z`counter'" ;
				local Z : list Z | tempname ;
				
				local counter = `counter'+1;
	};
} ;

gen d = r_1925C_kath;

keep y `Z' `C' d;


export delimited using "lasso_data.csv", replace;