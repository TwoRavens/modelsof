# delimit;
set more off;
capture log close;
clear;
clear matrix;


set matsize 1100;

est clear;
matrix drop _all;

/*
*******************************;
Tables 2 (page 1746) and 4  (paqe 1747) in the published paper
19th January 2014
Author RL Bruno
randolph.bruno@ucl.ac.uk


See below notes on 

TABLE 2

TABLE 4




RHS variables in the regressions 
-CONTEMPORANEOUS
-L
-L2
-L3

for robustness check, only selected regressions are reported in the paper.

Regressions control for "same" and "opos" conditional to government change, i.e. reduced number of observations


*******************************;
*/


cd "C:\Bruno RL\PRE SSEES 2012-2013\LBS\July2010";

log using .\log\Table_2_4_published_19_Jan_2014.log, replace;

use .\dta\Regression_READY_Reg_Sect_Year_size_CAT_9_12_2010.dta, clear;

ssc install outreg2;
des;
sum;


sort size_CAT Region_NUM_id _2DIG_nace_primary year;

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

open*
elec* 
plural* 
media* 
ecolib* 
civsoc* 
polstruc* 
elites* 
corrup* 
local* 


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

/*create the variable for correcting the VCE with cluster*/

sort size_CAT Region_NUM_id _2DIG_nace_primary year;

egen id_89R_nace=group(size_CAT Region_NUM_id _2DIG_nace_primary);


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


tab size_CAT;

gen size1=1 if size_CAT==1;
replace size1=0 if size1==.;

gen size2=1 if size_CAT==2;
replace size2=0 if size2==.;

gen size3=1 if size_CAT==3;
replace size3=0 if size3==.;
 
tab size_CAT;

tab size1;
tab size2;
tab size3;
 

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

L_open 
L2_open 

L_elec 
L2_elec 

L_plural 
L2_plural 

L_media 
L2_media 

L_ecolib 
L2_ecolib 

L_civsoc 
L2_civsoc 

L_polstruc 
L2_polstruc 

L_elites 
L2_elites 

L_corrup 
L2_corrup 

L_local 
L2_local 

{;                
gen EU1_X_`var'=(Entry_1y_EU_BVD_98_03)*`var';
gen EU1_X_`var'_s1=(Entry_1y_EU_BVD_small_98_03)*`var'*size1;
gen EU1_X_`var'_s2=(Entry_1y_EU_BVD_medium_98_03)*`var'*size2;
gen EU1_X_`var'_s3=(Entry_1y_EU_BVD_big_98_03)*`var'*size3;

gen USA1_X_`var'=(Entry_1y_USA_98_99)*`var';
gen USA1_X_`var'_s1=(Entry_1y_USA_98_99)*`var'*size1;
gen USA1_X_`var'_s2=(Entry_1y_USA_98_99)*`var'*size2;
gen USA1_X_`var'_s3=(Entry_1y_USA_98_99)*`var'*size3;
};
/*controls with 89 regions and size interaction*/

xi: reg  Entry_rate_2DIG_Reg i.Region_NUM_id*i.size_CAT i._2DIG_nace_primary*i.size_CAT i.year;


/*setting global*/
global Sec_89R_Year_X
"
_IRegXsiz_*
_I_2DXsiz_*
_Iyear_*
";


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

set seed 87327;

/*LHS*/
global LHS
"Entry_rate_2DIG_Reg";

*"DELTA_t_l1_entry1y";

global RHS_L_political_synt
"EU1_X_L_pol_ch_synt_cum";

global RHS_L_gvch
"EU1_X_L_gvch_cum";

global RHS_L_elct
"EU1_X_L_elct_cum";

global RHS_L_same
"EU1_X_L_same_cum"; 

global RHS_L_opos
"EU1_X_L_opos_cum";

global RHS_L2_political_synt
"EU1_X_L2_pol_ch_synt_cum";

global RHS_L2_gvch
"EU1_X_L2_gvch_cum";

global RHS_L2_elct
"EU1_X_L2_elct_cum";

global RHS_L2_same
"EU1_X_L2_same_cum"; 

global RHS_L2_opos
"EU1_X_L2_opos_cum";


global RHS_dem
"EU1_X_dem ";

# delimit;
global RHS_L_dem
"EU1_X_L_dem";

global RHS_L2_dem
"EU1_X_L2_dem";

global RHS_L3_dem
"EU1_X_L3_dem";



# delimit;


/*THIS IS THE REGRESSION FOR TABLE 2: NOTE THAT CONTEMPORANEOUS RHS LAG 1 LAG2 AND LAG3 ARE RUN
,FOR ROBUSTNESS CHECK, BUT ONLY SELECTED REGRESSIONS REPORTED IN THE PAPER*/


/*ELECTIONS COLUMNS 1 AND 2*/
tobit $LHS 

EU1_X_elct_cum_s1
EU1_X_elct_cum_s2
EU1_X_elct_cum_s3

$Sec_89R_Year_X
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_elct_cum_s1
EU1_X_elct_cum_s2
EU1_X_elct_cum_s3);

estimates store elct_cum_s;

tobit $LHS 

EU1_X_L_elct_cum_s1
EU1_X_L_elct_cum_s2
EU1_X_L_elct_cum_s3

$Sec_89R_Year_X
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L_elct_cum_s1
EU1_X_L_elct_cum_s2
EU1_X_L_elct_cum_s3);

estimates store L_elct_cum_s;

# delimit;
set more off;


tobit $LHS 

$Sec_89R_Year_X 
EU1_X_L2_elct_cum_s1
EU1_X_L2_elct_cum_s2
EU1_X_L2_elct_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L2_elct_cum_s1
EU1_X_L2_elct_cum_s2
EU1_X_L2_elct_cum_s3);

estimates store L2_elct_cum_s;

tobit $LHS 

$Sec_89R_Year_X 
EU1_X_L3_elct_cum_s1
EU1_X_L3_elct_cum_s2
EU1_X_L3_elct_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L3_elct_cum_s1
EU1_X_L3_elct_cum_s2
EU1_X_L3_elct_cum_s3);

estimates store L3_elct_cum_s;


# delimit;
set more off;


/*GOVERNOR CHANGE COLUMNS 3 AND 4*/

/*L_gvch_cum and 2*/

# delimit;
set more off;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_gvch_cum_s1
EU1_X_gvch_cum_s2
EU1_X_gvch_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_gvch_cum_s1
EU1_X_gvch_cum_s2
EU1_X_gvch_cum_s3);

estimates store gvch_cum_s;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L_gvch_cum_s1
EU1_X_L_gvch_cum_s2
EU1_X_L_gvch_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L_gvch_cum_s1
EU1_X_L_gvch_cum_s2
EU1_X_L_gvch_cum_s3);

estimates store L_gvch_cum_s;

tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L2_gvch_cum_s1
EU1_X_L2_gvch_cum_s2
EU1_X_L2_gvch_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L2_gvch_cum_s1
EU1_X_L2_gvch_cum_s2
EU1_X_L2_gvch_cum_s3);

estimates store L2_gvch_cum_s;


tobit $LHS 

$Sec_89R_Year_X 

EU1_X_L3_gvch_cum_s1
EU1_X_L3_gvch_cum_s2
EU1_X_L3_gvch_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L3_gvch_cum_s1
EU1_X_L3_gvch_cum_s2
EU1_X_L3_gvch_cum_s3);

estimates store L3_gvch_cum_s;


# delimit;
set more off;


/*CROSS CHECK (NOT IN THE TABLE)*/

/*L2_same_cum*/

tobit $LHS 

  $Sec_89R_Year_X 
EU1_X_same_cum_s1
EU1_X_same_cum_s2
EU1_X_same_cum_s3 if (L_gvch==1 | L_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_same_cum_s1
EU1_X_same_cum_s2
EU1_X_same_cum_s3);

estimates store same_cum_s;



tobit $LHS 

  $Sec_89R_Year_X 
EU1_X_L_same_cum_s1
EU1_X_L_same_cum_s2
EU1_X_L_same_cum_s3 if (L_gvch==1 | L_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L_same_cum_s1
EU1_X_L_same_cum_s2
EU1_X_L_same_cum_s3);

estimates store L_same_cum_s;


# delimit;
set more off;

tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L2_same_cum_s1
EU1_X_L2_same_cum_s2
EU1_X_L2_same_cum_s3 if (L2_gvch==1 | L2_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L2_same_cum_s1
EU1_X_L2_same_cum_s2
EU1_X_L2_same_cum_s3);

estimates store L2_same_cum_s;


tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L3_same_cum_s1
EU1_X_L3_same_cum_s2
EU1_X_L3_same_cum_s3 if (L2_gvch==1 | L2_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L3_same_cum_s1
EU1_X_L3_same_cum_s2
EU1_X_L3_same_cum_s3);

estimates store L3_same_cum_s;



# delimit;
set more off;


/*ELITE CHANGE COLUMNS 5 AND 6*/
/*L2_opos_cum*/


tobit $LHS 

  
$Sec_89R_Year_X
 
EU1_X_opos_cum_s1
EU1_X_opos_cum_s2
EU1_X_opos_cum_s3 if (L_gvch==1 | L_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_opos_cum_s1
EU1_X_opos_cum_s2
EU1_X_opos_cum_s3);

estimates store opos_cum_s;


tobit $LHS 

  
$Sec_89R_Year_X
 
EU1_X_L_opos_cum_s1
EU1_X_L_opos_cum_s2
EU1_X_L_opos_cum_s3 if (L_gvch==1 | L_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L_opos_cum_s1
EU1_X_L_opos_cum_s2
EU1_X_L_opos_cum_s3);

estimates store L_opos_cum_s;

# delimit;
set more off;



tobit $LHS 

  
$Sec_89R_Year_X
 
EU1_X_L2_opos_cum_s1
EU1_X_L2_opos_cum_s2
EU1_X_L2_opos_cum_s3  if (L2_gvch==1 | L2_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L2_opos_cum_s1
EU1_X_L2_opos_cum_s2
EU1_X_L2_opos_cum_s3);


estimates store L2_opos_cum_s;


tobit $LHS 

  
$Sec_89R_Year_X
 
EU1_X_L3_opos_cum_s1
EU1_X_L3_opos_cum_s2
EU1_X_L3_opos_cum_s3  if (L2_gvch==1 | L2_elct==1)
& limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L3_opos_cum_s1
EU1_X_L3_opos_cum_s2
EU1_X_L3_opos_cum_s3);


estimates store L3_opos_cum_s;


# delimit;
set more off;


/*POLITICAL FLUIDITY COLUMNS 7 AND 8*/


/*pol_ch_synt_cum_LAG 1 and 2*/


tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_pol_ch_synt_cum_s1
EU1_X_pol_ch_synt_cum_s2
EU1_X_pol_ch_synt_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_pol_ch_synt_cum_s1
EU1_X_pol_ch_synt_cum_s2
EU1_X_pol_ch_synt_cum_s3);

estimates store pol_ch_synt_cum_s;



tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L_pol_ch_synt_cum_s1
EU1_X_L_pol_ch_synt_cum_s2
EU1_X_L_pol_ch_synt_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L_pol_ch_synt_cum_s1
EU1_X_L_pol_ch_synt_cum_s2
EU1_X_L_pol_ch_synt_cum_s3);

estimates store L_pol_ch_synt_cum_s;

# delimit;
set more off;





tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L2_pol_ch_synt_cum_s1
EU1_X_L2_pol_ch_synt_cum_s2
EU1_X_L2_pol_ch_synt_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L2_pol_ch_synt_cum_s1
EU1_X_L2_pol_ch_synt_cum_s2
EU1_X_L2_pol_ch_synt_cum_s3);

estimates store L2_pol_ch_synt_cum_s;


tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L3_pol_ch_synt_cum_s1
EU1_X_L3_pol_ch_synt_cum_s2
EU1_X_L3_pol_ch_synt_cum_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L3_pol_ch_synt_cum_s1
EU1_X_L3_pol_ch_synt_cum_s2
EU1_X_L3_pol_ch_synt_cum_s3);

estimates store L3_pol_ch_synt_cum_s;

# delimit;
set more off;




/***************************/

/***************************/
/***************************/
/***************************/
/***************************/
/***************************/


/*TABLE 4 : PLEASE NTE THAT LAG 3 IS ALSO RUN AS RBUSTNESS CHECK, NOT IN THE TABLE*/

tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_dem_s1
EU1_X_dem_s2
EU1_X_dem_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_dem_s1
EU1_X_dem_s2
EU1_X_dem_s3);

estimates store dem_s;


tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L_dem_s1
EU1_X_L_dem_s2
EU1_X_L_dem_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L_dem_s1
EU1_X_L_dem_s2
EU1_X_L_dem_s3);

estimates store L_dem_s;

tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L2_dem_s1
EU1_X_L2_dem_s2
EU1_X_L2_dem_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L2_dem_s1
EU1_X_L2_dem_s2
EU1_X_L2_dem_s3);

estimates store L2_dem_s;


tobit $LHS 

  
$Sec_89R_Year_X 
EU1_X_L3_dem_s1
EU1_X_L3_dem_s2
EU1_X_L3_dem_s3
if limited_sample==1,

vce(cluster id_89R_nace) ll(0) ul(1);
# delimit;
mfx compute, predict(ystar(0,1)) 
varlist(
EU1_X_L3_dem_s1
EU1_X_L3_dem_s2
EU1_X_L3_dem_s3);

estimates store L3_dem_s;



drop _I*;

drop EU*;
drop USA*;

save .\dta\Post_Regressions_Reg_Sect_Year_size_CAT_19_1_2014.dta, replace;

log close;
