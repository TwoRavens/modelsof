# delimit;
capture log close;
clear;
clear matrix;

set more off;

set matsize 11000;


est clear;
matrix drop _all;

/*
*******************************;
Tables 1 (1745) and 3 (1747) in the published paper
19th January 2014
Author RL Bruno
randolph.bruno@ucl.ac.uk


See below notes on 

TABLE 1

TABLE 3




RHS variables are in the regressions 
-CONTEMPORANEOUS
-L
-L2
-L3

for robustness check, only selected regressions are reported in the paper.

Regressions control for "same" and "opos" conditional to government change, i.e. reduced number of observations

*******************************;
*/


cd "C:\Bruno RL\PRE SSEES 2012-2013\LBS\July2010";

log using .\log\Table_1_3_published_19_Jan_2014.log, replace;

use .\dta\Regression_READY_Reg_Sect_Year_9_12_2010.dta, clear;

ssc install outreg2;
des;
sum;


sort Region_NUM_id _2DIG_nace_primary year;

/*delete ALL old governors variables and merge with new*/

drop  gvch* elct* same* opos* wima* difv* pol_ch_synt*;

sort Region_NUM_id year;

merge m:1 Region_NUM_id year using .\dta\expregdata\Governor_LONG_1996_2008.dta;

tab _merge;


rename *_LAG1 L_*;
rename *_LAG2 L2_*;
rename *_LAG3 L3_*;
rename *_LAG4 L4_*;
rename *_LAG5 L5_*;
rename *_LAG6 L6_*;
rename *_LAG7 L7_*;
rename *_LAG8 L8_*;
rename *_LAG9 L9_*;
rename *_LAG10 L10_*;
rename *_LAG11 L11_*;
rename *_LAG12 L12_*;
rename *_LAG13 L13_*;


sort Region_NUM_id _2DIG_nace_primary year;



/*stardadize the rank variables between [0,1]*/



foreach var of varlist 


dem
L_dem
L2_dem
L3_dem


{;                
replace `var'=`var'/45;
};





foreach var of varlist 



open
L_open
L2_open
L3_open
L4_open
L5_open
L6_open
L7_open
L8_open
L9_open
L10_open
L11_open
L12_open
L13_open
 
 elec
L_elec
L2_elec
L3_elec
L4_elec
L5_elec
L6_elec
L7_elec
L8_elec
L9_elec
L10_elec
L11_elec
L12_elec
L13_elec
 
 
plural
L_plural
L2_plural
L3_plural
L4_plural
L5_plural
L6_plural
L7_plural
L8_plural
L9_plural
L10_plural
L11_plural
L12_plural
L13_plural 

media
L_media
L2_media
L3_media
L4_media
L5_media
L6_media
L7_media
L8_media
L9_media
L10_media
L11_media
L12_media
L13_media

ecolib
L_ecolib
L2_ecolib
L3_ecolib
L4_ecolib
L5_ecolib
L6_ecolib
L7_ecolib
L8_ecolib
L9_ecolib
L10_ecolib
L11_ecolib
L12_ecolib
L13_ecolib 

civsoc
L_civsoc
L2_civsoc
L3_civsoc
L4_civsoc
L5_civsoc
L6_civsoc
L7_civsoc
L8_civsoc
L9_civsoc
L10_civsoc
L11_civsoc
L12_civsoc
L13_civsoc

polstruc
L_polstruc
L2_polstruc
L3_polstruc
L4_polstruc
L5_polstruc
L6_polstruc
L7_polstruc
L8_polstruc
L9_polstruc
L10_polstruc
L11_polstruc
L12_polstruc
L13_polstruc

elites
L_elites
L2_elites
L3_elites
L4_elites
L5_elites
L6_elites
L7_elites
L8_elites
L9_elites
L10_elites
L11_elites
L12_elites
L13_elites

corrup
L_corrup
L2_corrup
L3_corrup
L4_corrup
L5_corrup
L6_corrup
L7_corrup
L8_corrup
L9_corrup
L10_corrup
L11_corrup
L12_corrup
L13_corrup

local
L_local
L2_local
L3_local
L4_local
L5_local
L6_local
L7_local
L8_local
L9_local
L10_local
L11_local
L12_local
L13_local


{;                
replace `var'=`var'/5;
};


foreach var of varlist 

pol_ch_synt
L_pol_ch_synt
L2_pol_ch_synt
L3_pol_ch_synt
L4_pol_ch_synt
L5_pol_ch_synt
L6_pol_ch_synt
L7_pol_ch_synt
L8_pol_ch_synt
L9_pol_ch_synt
L10_pol_ch_synt
L11_pol_ch_synt
L12_pol_ch_synt
L13_pol_ch_synt


{;                
replace `var'=`var'/3;
};
foreach var of varlist 

pol_ch_synt_cum
L_pol_ch_synt_cum
L*_pol_ch_synt_cum


{;                
replace `var'=`var'/12;
};
foreach var of varlist 

elct_cum
L_elct_cum
L*_elct_cum

gvch_cum
L_gvch_cum
L*_gvch_cum

same_cum
L_same_cum
L*_same_cum

opos_cum
L_opos_cum
L*_opos_cum

{;                
replace `var'=`var'/6;
};

/*create the variable for correcting the VCE with cluster, now the standard*/

sort Region_NUM_id _2DIG_nace_primary year;

/*note no size effect category*/
egen id_89R_nace=group(Region_NUM_id _2DIG_nace_primary);


/*necessary for xttobit*/

xtset id_89R_nace year;


/*create lagged entry*/


gen  Entry_rate_2DIG_Reg_LAG1=l1.Entry_rate_2DIG_Reg;
gen  Entry_rate_2DIG2y_Reg_LAG1=l1.Entry_rate_2DIG2y_Reg;

browse Region_NUM_id _2DIG_nace_primary year id_89R_nace 
Entry_rate_2DIG_Reg_LAG1 Entry_rate_2DIG_Reg Entry_rate_2DIG2y_Reg_LAG1 Entry_rate_2DIG2y_Reg;

/*create deltas*/

gen DELTA_t_l1_entry1y=Entry_rate_2DIG_Reg-Entry_rate_2DIG_Reg_LAG1;
gen DELTA_t_l1_entry2y=Entry_rate_2DIG2y_Reg-Entry_rate_2DIG2y_Reg_LAG1;


foreach var of varlist 
DELTA_t_l1_*

elct
L_elct
L2_elct
L3_elct

gvch
L_gvch
L2_gvch
L3_gvch

same
L_same
L2_same
L3_same

opos
L_opos
L2_opos
L3_opos

pol_ch_synt
L_pol_ch_synt
L2_pol_ch_synt
L3_pol_ch_synt

elct_cum
L_elct_cum
L2_elct_cum
L3_elct_cum

gvch_cum
L_gvch_cum
L2_gvch_cum
L3_gvch_cum

same_cum
L_same_cum
L2_same_cum
L3_same_cum

opos_cum
L_opos_cum
L2_opos_cum
L3_opos_cum

pol_ch_synt_cum
L_pol_ch_synt_cum
L2_pol_ch_synt_cum
L3_pol_ch_synt_cum

dem 
L_dem
L2_dem
L3_dem

open 
elec 
plural 
media 
ecolib 
civsoc 
polstruc 
elites 
corrup 
local 


L*_open 

 
L*_elec 

 
L*_plural 

 
L*_media 

 
L*_ecolib 

 
L*_civsoc 

 
L*_polstruc 

 
L*_elites 

 
L*_corrup 

 
L*_local 


{;                
gen EU1_X_`var'=(Entry_1y_EU_BVD_98_03)*`var';
gen USA1_X_`var'=(Entry_1y_USA_98_99)*`var';
};

/*setting global*/


xi: reg  Entry_rate_2DIG_Reg i.Region_NUM_id i._2DIG_nace_primary i.year;

global Sec_89R_Year_X
"
_IRegion_NU_*
_I_2DIG_nac_*
_Iyear_*
";

/*LHS*/
global LHS
"Entry_rate_2DIG_Reg";

*"DELTA_t_l1_entry1y";

global RHS_L2_political_synt
"EU1_X_L2_pol_ch_synt_cum";

global RHS_L2_gvch
"EU1_X_L2_gvch_cum";

global RHS_L2_elct
"EU1_X_L2_elct_cum";

global RHS_L2_same
"EU1_X_L2_same_cum"; 

global RHS_L2_opos
"EU1_X_L2_opos_cum ";

global RHS_dem
"EU1_X_dem ";

# delimit;
global RHS_L_dem
"EU1_X_L_dem ";

global RHS_L2_dem
"EU1_X_L2_dem ";

global RHS_L3_dem
"EU1_X_L3_dem ";

gen limited_sample=1;

replace limited_sample=0 if 

(_2DIG_nace_primary==1 |
_2DIG_nace_primary==2 |
_2DIG_nace_primary==5 |
_2DIG_nace_primary==10 |
_2DIG_nace_primary==11 |
_2DIG_nace_primary==12 |
_2DIG_nace_primary==13 |
_2DIG_nace_primary==14 |
_2DIG_nace_primary==40 |
_2DIG_nace_primary==41 |
_2DIG_nace_primary==65 |
_2DIG_nace_primary==66 |
_2DIG_nace_primary==67 |
_2DIG_nace_primary==75 |
_2DIG_nace_primary==80 |
_2DIG_nace_primary==85);

replace limited_sample=0 if  Region_NUM_id==37 ;


tab limited_sample;

browse _2DIG_nace_primary if limited_sample==1;

tab _2DIG_nace_primary if limited_sample==0;
tab _2DIG_nace_primary if limited_sample==1;


/**********************************************************/
/**********************************************************/
/**********************************************************/
/**********************************************************/
/**********************************************************/
/**********************************************************/
/**********************************************************/
/**********************************************************/

/*START REGRESSIONS*/

set seed 987132;


/*THE FOLLOWING REGRESSIONS ARE A REPLICATION OF TABLE 1 IN THE PAPER (PAGE 1745)*/
/*PLEASE NOTE THAT THE REGRESSIONS RUN CONTEMPORANOUS LAG 1 LAG 2 LAG 3 REGRESSIONS FOR ROBUSTENESS CHECK:
AN HOURSE RACE REGRESSION; SAME ELITE IN P[OWER

WHEREAS THE PAPER
REPORTS LAG 1 AND LAG 2 ONLY FOR 
ELECTIONS
GOVERNOR CHANGE
ELITE CHAGE (OPOS)
POLITICAL FLUIDITY (pol_ch_synt)
*/

/*L_elct_cum and 2 ELECTIONS*/

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_elct_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);

# delimit;

mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_elct_cum);

estimates store elct_cum;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L_elct_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);

# delimit;

mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L_elct_cum);

# delimit;

estimates store L_elct_cum;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L2_elct_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L2_elct_cum);

estimates store L2_elct_cum;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L3_elct_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L3_elct_cum);

estimates store L3_elct_cum;

/*GOVERNMENT CHANGE*/


tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_gvch_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_gvch_cum);

estimates store gvch_cum;


/*gvch_LAG 1 and 2 EU*/

tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_L_gvch_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L_gvch_cum);

estimates store L_gvch_cum;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L2_gvch_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L2_gvch_cum);

estimates store L2_gvch_cum;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L3_gvch_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L3_gvch_cum);

estimates store L3_gvch_cum;


/*ELITE CHANGE L_same and 2 NB CONDITIONAL TO govchange==1 or elct ==1*/

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_same_cum if (gvch==1 | elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_same_cum);

estimates store same_cum;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L_same_cum if (L_gvch==1 | L_elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L_same_cum);

estimates store L_same_cum;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L2_same_cum if (L2_gvch==1 | L2_elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L2_same_cum);

estimates store L2_same_cum;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L3_same_cum if (L3_gvch==1 | L3_elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L3_same_cum);

estimates store L3_same_cum;

/*L_opos and 2 NB CONDITIONAL TO govchange==1 | elct==1*/


tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_opos_cum if (gvch==1 | elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_opos_cum);

estimates store opos_cum;



tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_L_opos_cum if (L_gvch==1 | L_elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L_opos_cum);

estimates store L_opos_cum;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L2_opos_cum if (L2_gvch==1 | L2_elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L2_opos_cum);

estimates store L2_opos_cum;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L3_opos_cum if (L3_gvch==1 | L3_elct==1) & limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L3_opos_cum);

estimates store L3_opos_cum;




/*POLITICAL FLUIDITY L_pol_ch_synt and 2*/

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_pol_ch_synt_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_pol_ch_synt_cum);

estimates store pol_ch_synt_cum;



tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L_pol_ch_synt_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L_pol_ch_synt_cum);

estimates store L_pol_ch_synt_cum;


tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_L2_pol_ch_synt_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L2_pol_ch_synt_cum);

estimates store L2_pol_ch_synt_cum;


tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_L3_pol_ch_synt_cum if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L3_pol_ch_synt_cum);


/*END TABLE 1 REGRESSIONS*/

estimates store L3_pol_ch_synt_cum;

# delimit;


/*the following regression replicate TABLE 3 IN THE PAPER*/


/*COLUMN 1*/
tobit $LHS 

$Sec_89R_Year_X 

EU1_X_dem if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_dem);

estimates store dem;


/*COLUMN 2*/

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L_dem if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L_dem);

estimates store L_dem;


/*COLUMN 3*/

tobit $LHS 

  
$Sec_89R_Year_X 

EU1_X_L2_dem if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L2_dem);

estimates store L2_dem;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L3_dem if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(EU1_X_L3_dem);

estimates store L3_dem;


drop _I*;

drop EU*;
drop USA*;

save .\dta\Post_Regressions_Reg_Sect_Year_19_1_2014.dta, replace;

log close;
