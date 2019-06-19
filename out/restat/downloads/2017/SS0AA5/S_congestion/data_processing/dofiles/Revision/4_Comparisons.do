/********************************
comparisons.do


GD June 2011. Inversion of the indices in May 2012. Updated February 2016.

Compares and aggregates results

Generates the instruments for the estimation of supply curves for travel in the US and for each msa.   *********************************/





**************  Start  ********************************************************;

*set up;
#delimit;
clear all;

set memory 5g;

set matsize 5000;
set more 1;
quietly capture log close;
cd;

global data_source  D:\S_congestion\data_processing\dofiles\Revision\output\ ;

global data_source2  D:\S_congestion\data_processing\data_generated\ ;

global data_source3  D:\S_congestion\data_processing\dofiles\Revision\data ;


*********************************************************************************************;
************** Data assembly part 1   *******************************************************;
*********************************************************************************************;


if 1==1 {;

* Average measured speed;

use "$data_source\npts_index_50.dta";

rename L_95A L_95_50A;
rename L_01A L_01_50A;
rename L_09A L_09_50A;

rename L_95B L_95_50B;
rename L_01B L_01_50B;
rename L_09B L_09_50B;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_100.dta";

rename L_95A L_95_100A;
rename L_01A L_01_100A;
rename L_09A L_09_100A;

rename L_95B L_95_100B;
rename L_01B L_01_100B;
rename L_09B L_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;

use "$data_source\npts_index_240.dta";

rename L_95A L_95_240A;
rename L_01A L_01_240A;
rename L_09A L_09_240A;

rename L_95B L_95_240B;
rename L_01B L_01_240B;
rename L_09B L_09_240B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


* OLS with no controls;

use "$data_source\npts_index_a_50.dta";

keep msa La_95 La_01 La_09 rank;

rename La_95 La_95_50A;
rename La_01 La_01_50A;
rename La_09 La_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_a_100.dta";

keep msa La_95 La_01 La_09;

rename La_95 La_95_100A;
rename La_01 La_01_100A;
rename La_09 La_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_a_240.dta";

keep msa La_95 La_01 La_09;

rename La_95 La_95_240A;
rename La_01 La_01_240A;
rename La_09 La_09_240A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


* OLS with controls (comprehensive set in A, less comprehensive in B);

use "$data_source\npts_index_b_50.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_50A;
rename Lb_01 Lb_01_50A;
rename Lb_09 Lb_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_100.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_100A;
rename Lb_01 Lb_01_100A;
rename Lb_09 Lb_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_240.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_240A;
rename Lb_01 Lb_01_240A;
rename Lb_09 Lb_09_240A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_502.dta";

keep msa Lb_95 Lb_01 Lb_09 Pb_95 Pb_01 Pb_09 Fb_95 Fb_01 Fb_09;

rename Lb_95 Lb_95_50B;
rename Lb_01 Lb_01_50B;
rename Lb_09 Lb_09_50B;

rename Pb_95 Pb_95_50B;
rename Pb_01 Pb_01_50B;
rename Pb_09 Pb_09_50B;

rename Fb_95 Fb_95_50B;
rename Fb_01 Fb_01_50B;
rename Fb_09 Fb_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1002.dta";

keep msa Lb_95 Lb_01 Lb_09 Pb_95 Pb_01 Pb_09 Fb_95 Fb_01 Fb_09;

rename Lb_95 Lb_95_100B;
rename Lb_01 Lb_01_100B;
rename Lb_09 Lb_09_100B;

rename Pb_95 Pb_95_100B;
rename Pb_01 Pb_01_100B;
rename Pb_09 Pb_09_100B;

rename Fb_95 Fb_95_100B;
rename Fb_01 Fb_01_100B;
rename Fb_09 Fb_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_2402.dta";

keep msa Lb_95 Lb_01 Lb_09 Pb_95 Pb_01 Pb_09 Fb_95 Fb_01 Fb_09;

rename Lb_95 Lb_95_240B;
rename Lb_01 Lb_01_240B;
rename Lb_09 Lb_09_240B;

rename Pb_95 Pb_95_240B;
rename Pb_01 Pb_01_240B;
rename Pb_09 Pb_09_240B;

rename Fb_95 Fb_95_240B;
rename Fb_01 Fb_01_240B;
rename Fb_09 Fb_09_240B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_503.dta";

keep msa Lb_95 Lb_01 Lb_09 Pb_95 Pb_01 Pb_09 Fb_95 Fb_01 Fb_09;

rename Lb_95 Lb_95_50C;
rename Lb_01 Lb_01_50C;
rename Lb_09 Lb_09_50C;

rename Pb_95 Pb_95_50C;
rename Pb_01 Pb_01_50C;
rename Pb_09 Pb_09_50C;

rename Fb_95 Fb_95_50C;
rename Fb_01 Fb_01_50C;
rename Fb_09 Fb_09_50C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1003.dta";

keep msa Lb_95 Lb_01 Lb_09 Pb_95 Pb_01 Pb_09 Fb_95 Fb_01 Fb_09;

rename Lb_95 Lb_95_100C;
rename Lb_01 Lb_01_100C;
rename Lb_09 Lb_09_100C;

rename Pb_95 Pb_95_100C;
rename Pb_01 Pb_01_100C;
rename Pb_09 Pb_09_100C;

rename Fb_95 Fb_95_100C;
rename Fb_01 Fb_01_100C;
rename Fb_09 Fb_09_100C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_2403.dta";

keep msa Lb_95 Lb_01 Lb_09 Pb_95 Pb_01 Pb_09 Fb_95 Fb_01 Fb_09;

rename Lb_95 Lb_95_240C;
rename Lb_01 Lb_01_240C;
rename Lb_09 Lb_09_240C;

rename Pb_95 Pb_95_240C;
rename Pb_01 Pb_01_240C;
rename Pb_09 Pb_09_240C;

rename Fb_95 Fb_95_240C;
rename Fb_01 Fb_01_240C;
rename Fb_09 Fb_09_240C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_504.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_50D;
rename Lb_01 Lb_01_50D;
rename Lb_09 Lb_09_50D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1004.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_100D;
rename Lb_01 Lb_01_100D;
rename Lb_09 Lb_09_100D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_2404.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_240D;
rename Lb_01 Lb_01_240D;
rename Lb_09 Lb_09_240D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_505.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_50E;
rename Lb_01 Lb_01_50E;
rename Lb_09 Lb_09_50E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1005.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_100E;
rename Lb_01 Lb_01_100E;
rename Lb_09 Lb_09_100E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_2405.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_240E;
rename Lb_01 Lb_01_240E;
rename Lb_09 Lb_09_240E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;




use "$data_source\npts_index_b_506.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_50F;
rename Lb_01 Lb_01_50F;
rename Lb_09 Lb_09_50F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1006.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_100F;
rename Lb_01 Lb_01_100F;
rename Lb_09 Lb_09_100F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_2406.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_240F;
rename Lb_01 Lb_01_240F;
rename Lb_09 Lb_09_240F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_b_507.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_50G;
rename Lb_01 Lb_01_50G;
rename Lb_09 Lb_09_50G;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1007.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_100G;
rename Lb_01 Lb_01_100G;
rename Lb_09 Lb_09_100G;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_2407.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_240G;
rename Lb_01 Lb_01_240G;
rename Lb_09 Lb_09_240G;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_508.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_50H;
rename Lb_01 Lb_01_50H;
rename Lb_09 Lb_09_50H;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_b_1008.dta";

keep msa Lb_95 Lb_01 Lb_09;

rename Lb_95 Lb_95_100H;
rename Lb_01 Lb_01_100H;
rename Lb_09 Lb_09_100H;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;




* Estimations with fixed effects (without and with time dummies);

use "$data_source\npts_index_c_50.dta";

keep msa Lc_95 Lc_01 Lc_09;

rename Lc_95 Lc_95_50A;
rename Lc_01 Lc_01_50A;
rename Lc_09 Lc_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_c_100.dta";

keep msa Lc_95 Lc_01 Lc_09;

rename Lc_95 Lc_95_100A;
rename Lc_01 Lc_01_100A;
rename Lc_09 Lc_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_c_240.dta";

keep msa Lc_95 Lc_01 Lc_09;

rename Lc_95 Lc_95_240A;
rename Lc_01 Lc_01_240A;
rename Lc_09 Lc_09_240A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_c_502.dta";

keep msa Lc_95 Lc_01 Lc_09;

rename Lc_95 Lc_95_50B;
rename Lc_01 Lc_01_50B;
rename Lc_09 Lc_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_c_1002.dta";

keep msa Lc_95 Lc_01 Lc_09;

rename Lc_95 Lc_95_100B;
rename Lc_01 Lc_01_100B;
rename Lc_09 Lc_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_c_2402.dta";

keep msa Lc_95 Lc_01 Lc_09;

rename Lc_95 Lc_95_240B;
rename Lc_01 Lc_01_240B;
rename Lc_09 Lc_09_240B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


* IV distance in own city by trip type (manual two steps with comprehensive controls in A, with less comprehensive controls in B, with city by city TSLS after taking out effect of individual controls in C;

use "$data_source\npts_index_d_50.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_50A;
rename Ld_01 Ld_01_50A;
rename Ld_09 Ld_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_100.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_100A;
rename Ld_01 Ld_01_100A;
rename Ld_09 Ld_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_240.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_240A;
rename Ld_01 Ld_01_240A;
rename Ld_09 Ld_09_240A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_502.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_50B;
rename Ld_01 Ld_01_50B;
rename Ld_09 Ld_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_1002.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_100B;
rename Ld_01 Ld_01_100B;
rename Ld_09 Ld_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_2402.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_240B;
rename Ld_01 Ld_01_240B;
rename Ld_09 Ld_09_240B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_d_503.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_50C;
rename Ld_01 Ld_01_50C;
rename Ld_09 Ld_09_50C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_1003.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_100C;
rename Ld_01 Ld_01_100C;
rename Ld_09 Ld_09_100C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_d_504.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_50D;
rename Ld_01 Ld_01_50D;
rename Ld_09 Ld_09_50D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_d_1004.dta";

keep msa Ld_95 Ld_01 Ld_09;

rename Ld_95 Ld_95_100D;
rename Ld_01 Ld_01_100D;
rename Ld_09 Ld_09_100D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


* IV distance in other cities by trip type (All estimation first do a manual two steps with comprehensive controls 
and condition out the effects of trip and driver characteristics in a city by city TSLS after taking out effect of individual controls: in A the matching MSAs are by size and geography, in B by size only, in C by driving results using OLS with no characteristics, in D by driving results using OLS with characteristics;

use "$data_source\npts_index_e_501.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_50A;
rename Le_01 Le_01_50A;
rename Le_09 Le_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_1001.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_100A;
rename Le_01 Le_01_100A;
rename Le_09 Le_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;

use "$data_source\npts_index_e_502.dta";

keep msa Le_95 Le_01 Le_09 Pe_95 Pe_01 Pe_09 Fe_95 Fe_01 Fe_09;

rename Le_95 Le_95_50B;
rename Le_01 Le_01_50B;
rename Le_09 Le_09_50B;

rename Pe_95 Pe_95_50B;
rename Pe_01 Pe_01_50B;
rename Pe_09 Pe_09_50B;

rename Fe_95 Fe_95_50B;
rename Fe_01 Fe_01_50B;
rename Fe_09 Fe_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_1002.dta";

keep msa Le_95 Le_01 Le_09 Pe_95 Pe_01 Pe_09 Fe_95 Fe_01 Fe_09;

rename Le_95 Le_95_100B;
rename Le_01 Le_01_100B;
rename Le_09 Le_09_100B;

rename Pe_95 Pe_95_100B;
rename Pe_01 Pe_01_100B;
rename Pe_09 Pe_09_100B;

rename Fe_95 Fe_95_100B;
rename Fe_01 Fe_01_100B;
rename Fe_09 Fe_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_503.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_50C;
rename Le_01 Le_01_50C;
rename Le_09 Le_09_50C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_1003.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_100C;
rename Le_01 Le_01_100C;
rename Le_09 Le_09_100C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_504.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_50D;
rename Le_01 Le_01_50D;
rename Le_09 Le_09_50D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_1004.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_100D;
rename Le_01 Le_01_100D;
rename Le_09 Le_09_100D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;




use "$data_source\npts_index_e_505.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_50E;
rename Le_01 Le_01_50E;
rename Le_09 Le_09_50E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_1005.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_100E;
rename Le_01 Le_01_100E;
rename Le_09 Le_09_100E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_506.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_50F;
rename Le_01 Le_01_50F;
rename Le_09 Le_09_50F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_1006.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_100F;
rename Le_01 Le_01_100F;
rename Le_09 Le_09_100F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_e_507.dta";

keep msa Le_95 Le_01 Le_09;

rename Le_95 Le_95_50G;
rename Le_01 Le_01_50G;
rename Le_09 Le_09_50G;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;
























* IV trip type (All estimation first do a manual two steps with comprehensive controls 
and condition out the effects of trip and driver characteristics in a city by city TSLS after taking out effect of individual controls: in A we use all 8 trip types, in B there are aggregated in 4 groups, in C we use shopping/perosnal business vs school/medical and in D we use work vs school/medical;

use "$data_source\npts_index_f_501.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50A;
rename Lf_01 Lf_01_50A;
rename Lf_09 Lf_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1001.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100A;
rename Lf_01 Lf_01_100A;
rename Lf_09 Lf_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_f_502.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50B;
rename Lf_01 Lf_01_50B;
rename Lf_09 Lf_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1002.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100B;
rename Lf_01 Lf_01_100B;
rename Lf_09 Lf_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;





use "$data_source\npts_index_f_503.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50C;
rename Lf_01 Lf_01_50C;
rename Lf_09 Lf_09_50C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1003.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100C;
rename Lf_01 Lf_01_100C;
rename Lf_09 Lf_09_100C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_f_504.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50D;
rename Lf_01 Lf_01_50D;
rename Lf_09 Lf_09_50D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1004.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100D;
rename Lf_01 Lf_01_100D;
rename Lf_09 Lf_09_100D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;




use "$data_source\npts_index_f_505.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50E;
rename Lf_01 Lf_01_50E;
rename Lf_09 Lf_09_50E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1005.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100E;
rename Lf_01 Lf_01_100E;
rename Lf_09 Lf_09_100E;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_f_506.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50F;
rename Lf_01 Lf_01_50F;
rename Lf_09 Lf_09_50F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1006.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100F;
rename Lf_01 Lf_01_100F;
rename Lf_09 Lf_09_100F;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;




use "$data_source\npts_index_f_507.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50G;
rename Lf_01 Lf_01_50G;
rename Lf_09 Lf_09_50G;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1007.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100G;
rename Lf_01 Lf_01_100G;
rename Lf_09 Lf_09_100G;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;




use "$data_source\npts_index_f_508.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_50H;
rename Lf_01 Lf_01_50H;
rename Lf_09 Lf_09_50H;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_f_1008.dta";

keep msa Lf_95 Lf_01 Lf_09;

rename Lf_95 Lf_95_100H;
rename Lf_01 Lf_01_100H;
rename Lf_09 Lf_09_100H;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



* Fixed effects and IV distance in other cities by trip type (All estimation first do a manual two steps with comprehensive controls 
and condition out the effects of trip and driver characteristics in a city by city TSLS after taking out effect of individual controls: in A the matching MSAs are by size and geography, in B by size only, in C by driving results using OLS with no characteristics, in D by driving results using OLS with characteristics;

use "$data_source\npts_index_g_501.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_50A;
rename Lg_01 Lg_01_50A;
rename Lg_09 Lg_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_1001.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_100A;
rename Lg_01 Lg_01_100A;
rename Lg_09 Lg_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_2401.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_240A;
rename Lg_01 Lg_01_240A;
rename Lg_09 Lg_09_240A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_502.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_50B;
rename Lg_01 Lg_01_50B;
rename Lg_09 Lg_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_1002.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_100B;
rename Lg_01 Lg_01_100B;
rename Lg_09 Lg_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_2402.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_240B;
rename Lg_01 Lg_01_240B;
rename Lg_09 Lg_09_240B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;



use "$data_source\npts_index_g_503.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_50C;
rename Lg_01 Lg_01_50C;
rename Lg_09 Lg_09_50C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_1003.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_100C;
rename Lg_01 Lg_01_100C;
rename Lg_09 Lg_09_100C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_2403.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_240C;
rename Lg_01 Lg_01_240C;
rename Lg_09 Lg_09_240C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_504.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_50D;
rename Lg_01 Lg_01_50D;
rename Lg_09 Lg_09_50D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_1004.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_100D;
rename Lg_01 Lg_01_100D;
rename Lg_09 Lg_09_100D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_g_2404.dta";

keep msa Lg_95 Lg_01 Lg_09;

rename Lg_95 Lg_95_240D;
rename Lg_01 Lg_01_240D;
rename Lg_09 Lg_09_240D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


* Fixed effects and IV trip type: in A we use all 8 trip types, in B there are aggregated in 4 groups, in C we use shopping/perosnal business vs school/medical and in D we use work vs school/medical;

use "$data_source\npts_index_h_501.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_50A;
rename Lh_01 Lh_01_50A;
rename Lh_09 Lh_09_50A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_h_1001.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_100A;
rename Lh_01 Lh_01_100A;
rename Lh_09 Lh_09_100A;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_h_502.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_50B;
rename Lh_01 Lh_01_50B;
rename Lh_09 Lh_09_50B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_h_1002.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_100B;
rename Lh_01 Lh_01_100B;
rename Lh_09 Lh_09_100B;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;






use "$data_source\npts_index_h_503.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_50C;
rename Lh_01 Lh_01_50C;
rename Lh_09 Lh_09_50C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_h_1003.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_100C;
rename Lh_01 Lh_01_100C;
rename Lh_09 Lh_09_100C;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;





use "$data_source\npts_index_h_504.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_50D;
rename Lh_01 Lh_01_50D;
rename Lh_09 Lh_09_50D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;


use "$data_source\npts_index_h_1004.dta";

keep msa Lh_95 Lh_01 Lh_09;

rename Lh_95 Lh_95_100D;
rename Lh_01 Lh_01_100D;
rename Lh_09 Lh_09_100D;

sort msa;

merge msa using "$data_source\temp_index.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;






use "$data_source2\working_msa.dta";

*rename largemsa rank;
	
*drop _merge;

sort rank_msa;

save "$data_source\temp_npts_msa.dta", replace;


use "$data_source\temp_index.dta";

foreach type in Lh_95_100D Lh_01_100D 
Lh_09_100D Lh_95_50D Lh_01_50D Lh_09_50D  
Lh_95_100C Lh_01_100C Lh_09_100C Lh_95_50C Lh_01_50C Lh_09_50C  
Lh_95_100B Lh_01_100B Lh_09_100B Lh_95_50B Lh_01_50B Lh_09_50B 
Lh_95_100A Lh_01_100A Lh_09_100A Lh_95_50A 
Lh_01_50A Lh_09_50A Lg_95_240D Lg_01_240D Lg_09_240D Lg_95_100D Lg_01_100D 
Lg_09_100D Lg_95_50D Lg_01_50D Lg_09_50D Lg_95_240C Lg_01_240C Lg_09_240C Lg_95_100C 
Lg_01_100C Lg_09_100C Lg_95_50C Lg_01_50C Lg_09_50C Lg_95_240B Lg_01_240B Lg_09_240B 
Lg_95_100B Lg_01_100B Lg_09_100B Lg_95_50B Lg_01_50B Lg_09_50B Lg_95_240A Lg_01_240A 
Lg_09_240A Lg_95_100A Lg_01_100A Lg_09_100A Lg_95_50A Lg_01_50A Lg_09_50A 
Lf_95_100H Lf_01_100H Lf_09_100H Lf_95_50H Lf_01_50H Lf_09_50H
Lf_95_100G Lf_01_100G Lf_09_100G Lf_95_50G Lf_01_50G 
Lf_09_50G Lf_95_100F Lf_01_100F Lf_09_100F Lf_95_50F 
Lf_01_50F Lf_09_50F Lf_95_100E Lf_01_100E Lf_09_100E 
Lf_95_50E Lf_01_50E Lf_09_50E Lf_95_100D 
Lf_01_100D Lf_09_100D Lf_95_50D Lf_01_50D Lf_09_50D  
Lf_95_100C Lf_01_100C Lf_09_100C Lf_95_50C Lf_01_50C Lf_09_50C 
Lf_95_100B Lf_01_100B Lf_09_100B Lf_95_50B Lf_01_50B 
Lf_09_50B Lf_95_100A Lf_01_100A Lf_09_100A Lf_95_50A 
Lf_01_50A Lf_09_50A 
Le_95_50G Le_01_50G Le_09_50G 
Le_95_100F Le_01_100F Le_09_100F Le_95_50F Le_01_50F Le_09_50F 
Le_95_100E Le_01_100E Le_09_100E Le_95_50E Le_01_50E Le_09_50E 
Le_95_100D Le_01_100D Le_09_100D Le_95_50D Le_01_50D Le_09_50D 
Le_95_100C Le_01_100C Le_09_100C Le_95_50C Le_01_50C Le_09_50C Le_95_100B 
Le_01_100B Le_09_100B Pe_95_100B Pe_01_100B Pe_09_100B Fe_95_100B Fe_01_100B Fe_09_100B 
Le_95_50B Le_01_50B Le_09_50B Pe_95_50B Pe_01_50B Pe_09_50B Fe_95_50B Fe_01_50B Fe_09_50B 
Le_95_100A Le_01_100A Le_09_100A Le_95_50A Le_01_50A 
 Le_09_50A Ld_95_100D Ld_01_100D Ld_09_100D Ld_95_50D 
 Ld_01_50D Ld_09_50D Ld_95_100C Ld_01_100C Ld_09_100C 
 Ld_95_50C Ld_01_50C Ld_09_50C Ld_95_240B Ld_01_240B Ld_09_240B Ld_95_100B Ld_01_100B 
 Ld_09_100B Ld_95_50B Ld_01_50B Ld_09_50B Ld_95_240A Ld_01_240A Ld_09_240A Ld_95_100A 
 Ld_01_100A Ld_09_100A Ld_95_50A Ld_01_50A Ld_09_50A Lc_95_240B Lc_01_240B Lc_09_240B 
 Lc_95_100B Lc_01_100B Lc_09_100B Lc_95_50B Lc_01_50B Lc_09_50B Lc_95_240A Lc_01_240A 
 Lc_09_240A Lc_95_100A Lc_01_100A Lc_09_100A Lc_95_50A Lc_01_50A Lc_09_50A 
Lb_95_100H Lb_01_100H Lb_09_100H Lb_95_50H Lb_01_50H Lb_09_50H
Lb_95_100G Lb_01_100G Lb_09_100G Lb_95_50G Lb_01_50G Lb_09_50G
Lb_95_100F Lb_01_100F Lb_09_100F Lb_95_50F Lb_01_50F Lb_09_50F
Lb_95_100E Lb_01_100E Lb_09_100E Lb_95_50E Lb_01_50E Lb_09_50E
  Lb_95_240D Lb_01_240D Lb_09_240D Lb_95_100D Lb_01_100D Lb_09_100D Lb_95_50D Lb_01_50D 
 Lb_09_50D Lb_95_240C Lb_01_240C Lb_09_240C Pb_95_240C Pb_01_240C Pb_09_240C Fb_95_240C 
 Fb_01_240C Fb_09_240C Lb_95_100C Lb_01_100C Lb_09_100C Pb_95_100C Pb_01_100C Pb_09_100C 
 Fb_95_100C Fb_01_100C Fb_09_100C Lb_95_50C Lb_01_50C Lb_09_50C Pb_95_50C Pb_01_50C Pb_09_50C 
 Fb_95_50C Fb_01_50C Fb_09_50C Lb_95_240B Lb_01_240B Lb_09_240B Pb_95_240B Pb_01_240B 
 Pb_09_240B Fb_95_240B Fb_01_240B Fb_09_240B Lb_95_100B Lb_01_100B Lb_09_100B Pb_95_100B 
 Pb_01_100B Pb_09_100B Fb_95_100B Fb_01_100B Fb_09_100B Lb_95_50B Lb_01_50B Lb_09_50B Pb_95_50B
 Pb_01_50B Pb_09_50B Fb_95_50B Fb_01_50B Fb_09_50B Lb_95_240A Lb_01_240A Lb_09_240A Lb_95_100A 
 Lb_01_100A Lb_09_100A Lb_95_50A Lb_01_50A Lb_09_50A La_95_240A La_01_240A La_09_240A 
 La_95_100A La_01_100A La_09_100A La_95_50A La_01_50A La_09_50A L_95_240A L_01_240A L_09_240A 
 L_95_240B L_01_240B L_09_240B L_95_100A L_01_100A L_09_100A L_95_100B L_01_100B L_09_100B 
 L_95_50A L_01_50A L_09_50A L_95_50B L_01_50B L_09_50B {;
	
replace `type' = 1/`type';

};

sort rank_msa;


display "XXXX";

merge rank_msa using "$data_source\temp_npts_msa.dta";
drop _merge;

save "$data_source\temp_index.dta", replace;




use "$data_source\npts_index_np_100.dta";


foreach type in Lnp_95 Lnp_01 Lnp_09 {;
	
replace `type' = 1/`type';

};

drop l_Lnp_95 l_Lnp_01 l_Lnp_09;

rename Lnp_95 Lnp_95_100;
rename Lnp_01 Lnp_01_100;
rename Lnp_09 Lnp_09_100;

sort msa;

save "$data_source\temp_npts_msa.dta", replace;


use "$data_source\temp_index.dta";

sort msa;

merge msa using "$data_source\temp_npts_msa.dta";

drop _merge;

sort msa;

save "$data_source\temp_index.dta", replace;

erase "$data_source2\temp_npts_msa.dta";


};



*********************************************************************************************;
************** Data assembly part 2   *******************************************************;
*********************************************************************************************;


if 1==0 {;


use "$data_source2\working_pmsa.dta";

sort pmsa;

save "$data_source2\working_pmsa.dta", replace;


use "$data_source3\county2msa.dta";

keep msa pmsa msa_name;

drop if msa==.;

replace pmsa=msa if pmsa==.;

sort pmsa;

quietly by pmsa:  gen dup = cond(_N==1,0,_n);

keep if dup<2;

drop dup;

sort pmsa;

save "$data_source2\pmsa_temp2", replace;


use "$data_source2\hpms2_pmsa";

sort pmsa;

merge pmsa using "$data_source2\working_pmsa";

keep if _merge==3; 
drop _merge;
*314 pmsa;

sort pmsa;

merge pmsa using "$data_source2\pmsa_temp2";
keep if _merge==3; 
drop _merge;
*314 pmsa;

order pmsa msa rank_pmsa msa_name pop1960 pop1990 pop2000 pop2010;
sort pmsa;

save "$data_source2\temp_pmsa.dta", replace;


* Average measured speed;

use "$data_source\npts_index_a_p50.dta";

keep pmsa La_09;
rename La_09 La_09_50A;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_a_p100.dta";
keep pmsa La_09;
rename La_09 La_09_100A;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_b_p50.dta";
keep pmsa Lb_09;
rename Lb_09 Lb_09_50A;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_b_p100.dta";
keep pmsa Lb_09;
rename Lb_09 Lb_09_100A;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_b_p502.dta";
keep pmsa Lb_09;
rename Lb_09 Lb_09_50B;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_b_p1002.dta";
keep pmsa Lb_09;
rename Lb_09 Lb_09_100B;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_e_p502.dta";
keep pmsa Le_09;
rename Le_09 Le_09_50A;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_e_p1002.dta";
keep pmsa Le_09;
rename Le_09 Le_09_100A;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_e_p503.dta";
keep pmsa Le_09;
rename Le_09 Le_09_50B;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_e_p1003.dta";
keep pmsa Le_09;
rename Le_09 Le_09_100B;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_e_p504.dta";
keep pmsa Le_09;
rename Le_09 Le_09_50C;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;
sort pmsa;
save "$data_source\pmsa_index.dta", replace;

use "$data_source\npts_index_e_p1004.dta";
keep pmsa Le_09;
rename Le_09 Le_09_100C;
sort pmsa;
merge pmsa using "$data_source\pmsa_index.dta";
drop _merge;

order pmsa La_09_50A La_09_100A Lb_09_50A Lb_09_100A Lb_09_50B Lb_09_100B Le_09_50A Le_09_100A Le_09_50B Le_09_100B Le_09_50C Le_09_100C;

sort pmsa;
save "$data_source\pmsa_index.dta", replace;

merge pmsa using "$data_source2\temp_pmsa.dta";

order pmsa msa rank_pmsa msa_name Le_09_100A Le_09_50A;

drop if _merge==2;
drop _merge;
*100 pmsa;

foreach index in La_09_50A La_09_100A Lb_09_50A Lb_09_100A Lb_09_50B Lb_09_100B Le_09_50A Le_09_100A Le_09_50B Le_09_100B Le_09_50C Le_09_100C {;
replace `index'=1/`index';
};

sort Le_09_50A;




replace msa_name="Boston, MA-NH PMSA" if pmsa==1120;
replace msa_name="Chicago, IL PMSA" if pmsa==1600;
replace msa_name="Cincinnati, OH-KY-IN PMSA" if pmsa==1640;
replace msa_name="Cleveland-Lorain-Elyria, OH PMSA" if pmsa==1680;
replace msa_name="Dallas, TX PMSA" if pmsa==1920;
replace msa_name="Denver, CO PMSA" if pmsa==2080;
replace msa_name="Detroit, MI PMSA" if pmsa==2160;
replace msa_name="Houston, TX PMSA" if pmsa==3360;
replace msa_name="Los Angeles-Long Beach, CA PMSA" if pmsa==4480;
replace msa_name="Miami, FL PMSA" if pmsa==5000;
replace msa_name="Milwaukee-Waukesha, WI PMSA" if pmsa==5080;
replace msa_name="New York, NY PMSA" if pmsa==5600;
replace msa_name="Philadelphia, PA-NJ PMSA" if pmsa==6160;
replace msa_name="Portland-Vancouver, OR-WA PMSA" if pmsa==6440;
replace msa_name="San Francisco, CA PMSA" if pmsa==7360;
replace msa_name="Seattle-Bellevue-Everett, WA PMSA" if pmsa==7600;
replace msa_name="Washington, DC-MD-VA-WV PMSA" if pmsa==8840;


replace msa_name="Gary, IN PMSA" if pmsa==2960;
replace msa_name="Fort Worth-Arlington, TX PMSA" if pmsa==2800;
replace msa_name="Orange County, CA PMSA" if pmsa==5945;
replace msa_name="Riverside-San Bernardino, CA PMSA" if pmsa==6780;
replace msa_name="Fort Lauderdale, FL PMSA" if pmsa==2680;
replace msa_name="Bergen-Passaic, NJ PMSA" if pmsa==0875;
replace msa_name="Nassau-Suffolk, NY PMSA" if pmsa==5380;
replace msa_name="Newark, NJ PMSA" if pmsa==5640;
replace msa_name="San Jose, CA PMSA" if pmsa==7400;
replace msa_name="Baltimore, MD PMSA" if pmsa==0720;
replace msa_name="Oakland, CA PMSA" if pmsa==5775;
};

save "$data_source\pmsa_index.dta", replace;






*********************************************************************************************;
************** Correlations  part 1   *******************************************************;
*********************************************************************************************;

if 1==1 {;


log using $data_source/comparisons, text replace;


use "$data_source\temp_index.dta";


display "comparisons within estimations";


pwcorr L_95_50A L_95_100A L_95_240A;
pwcorr L_01_50A L_01_100A L_01_240A;
pwcorr L_09_50A L_09_100A L_09_240A;

pwcorr L_95_50B L_95_100B L_95_240B;
pwcorr L_01_50B L_01_100B L_01_240B;
pwcorr L_09_50B L_09_100B L_09_240B;

pwcorr La_95_50A La_95_100A La_95_240A;
pwcorr La_01_50A La_01_100A La_01_240A;
pwcorr La_09_50A La_09_100A La_09_240A;

pwcorr Lb_95_50A Lb_95_100A Lb_95_240A;
pwcorr Lb_01_50A Lb_01_100A Lb_01_240A;
pwcorr Lb_09_50A Lb_09_100A Lb_09_240A;

pwcorr Lb_95_50B Lb_95_100B Lb_95_240B;
pwcorr Lb_01_50B Lb_01_100B Lb_01_240B;
pwcorr Lb_09_50B Lb_09_100B Lb_09_240B;

pwcorr Lb_95_50C Lb_95_100C Lb_95_240C;
pwcorr Lb_01_50C Lb_01_100C Lb_01_240C;
pwcorr Lb_09_50C Lb_09_100C Lb_09_240C;

pwcorr Lb_95_50D Lb_95_100D Lb_95_240D;
pwcorr Lb_01_50D Lb_01_100D Lb_01_240D;
pwcorr Lb_09_50D Lb_09_100D Lb_09_240D;

pwcorr Lb_95_50E Lb_95_100E Lb_95_240E;
pwcorr Lb_01_50E Lb_01_100E Lb_01_240E;
pwcorr Lb_09_50E Lb_09_100E Lb_09_240E;

pwcorr Lc_95_50A Lc_95_100A Lc_95_240A;
pwcorr Lc_01_50A Lc_01_100A Lc_01_240A;
pwcorr Lc_09_50A Lc_09_100A Lc_09_240A;

pwcorr Lc_95_50B Lc_95_100B Lc_95_240B;
pwcorr Lc_01_50B Lc_01_100B Lc_01_240B;
pwcorr Lc_09_50B Lc_09_100B Lc_09_240B;

pwcorr Ld_95_50A Ld_95_100A Ld_95_240A;
pwcorr Ld_01_50A Ld_01_100A Ld_01_240A;
pwcorr Ld_09_50A Ld_09_100A Ld_09_240A;

pwcorr Ld_95_50B Ld_95_100B Ld_95_240B;
pwcorr Ld_01_50B Ld_01_100B Ld_01_240B;
pwcorr Ld_09_50B Ld_09_100B Ld_09_240B;

pwcorr Ld_95_50C Ld_95_100C;
pwcorr Ld_01_50C Ld_01_100C;
pwcorr Ld_09_50C Ld_09_100C;

pwcorr Ld_95_50D Ld_95_100D;
pwcorr Ld_01_50D Ld_01_100D;
pwcorr Ld_09_50D Ld_09_100D;

pwcorr Le_95_50A Le_95_100A ;
pwcorr Le_01_50A Le_01_100A ;
pwcorr Le_09_50A Le_09_100A ;

pwcorr Le_95_50B Le_95_100B ;
pwcorr Le_01_50B Le_01_100B ;
pwcorr Le_09_50B Le_09_100B ;

pwcorr Le_95_50C Le_95_100C ;
pwcorr Le_01_50C Le_01_100C ;
pwcorr Le_09_50C Le_09_100C ;

pwcorr Le_95_50D Le_95_100D ;
pwcorr Le_01_50D Le_01_100D ;
pwcorr Le_09_50D Le_09_100D ;

pwcorr Lf_95_50A Lf_95_100A ;
pwcorr Lf_01_50A Lf_01_100A ;
pwcorr Lf_09_50A Lf_09_100A ;

pwcorr Lf_95_50B Lf_95_100B ;
pwcorr Lf_01_50B Lf_01_100B ;
pwcorr Lf_09_50B Lf_09_100B ;

pwcorr Lf_95_50C Lf_95_100C ;
pwcorr Lf_01_50C Lf_01_100C ;
pwcorr Lf_09_50C Lf_09_100C ;

* It makes no difference whether we restrict the sample before or after (except for the fixed effect estimates;


display "comparison laspeyre paasche fisher";


pwcorr Lb_95_50B Pb_95_50B Fb_95_50B;
pwcorr Lb_95_100B Pb_95_100B Fb_95_100B;
pwcorr Lb_95_240B Pb_95_240B Fb_95_240B;

pwcorr Lb_01_50B Pb_01_50B Fb_01_50B;
pwcorr Lb_01_100B Pb_01_100B Fb_01_100B;
pwcorr Lb_01_240B Pb_01_240B Fb_01_240B;

pwcorr Lb_09_50B Pb_09_50B Fb_09_50B;
pwcorr Lb_09_100B Pb_09_100B Fb_09_100B;
pwcorr Lb_09_240B Pb_09_240B Fb_09_240B;


pwcorr Le_95_50B Pe_95_50B Fe_95_50B;
pwcorr Le_95_100B Pe_95_100B Fe_95_100B;

pwcorr Le_01_50B Pe_01_50B Fe_01_50B;
pwcorr Le_01_100B Pe_01_100B Fe_01_100B;

pwcorr Le_09_50B Pe_09_50B Fe_09_50B;
pwcorr Le_09_100B Pe_09_100B Fe_09_100B;


* High correlations between all three indices;

display "comparisons across years";

pwcorr L_95_50A L_01_50A L_09_50A;
pwcorr L_95_100A L_01_100A L_09_100A;
pwcorr L_95_240A L_01_240A L_09_240A;

pwcorr L_95_50B L_01_50B L_09_50B;
pwcorr L_95_100B L_01_100B L_09_100B;
pwcorr L_95_240B L_01_240B L_09_240B;

pwcorr La_95_50A La_01_50A La_09_50A;
pwcorr La_95_100A La_01_100A La_09_100A;
pwcorr La_95_240A La_01_240A La_09_240A;

pwcorr Lb_95_50A Lb_01_50A Lb_09_50A;
pwcorr Lb_95_100A Lb_01_100A Lb_09_100A;
pwcorr Lb_95_240A Lb_01_240A Lb_09_240A;

pwcorr Lb_95_50B Lb_01_50B Lb_09_50B;
pwcorr Lb_95_100B Lb_01_100B Lb_09_100B;
pwcorr Lb_95_240B Lb_01_240B Lb_09_240B;

pwcorr Pb_95_50B Pb_01_50B Pb_09_50B;
pwcorr Pb_95_100B Pb_01_100B Pb_09_100B;
pwcorr Pb_95_240B Pb_01_240B Pb_09_240B;

pwcorr Fb_95_50B Fb_01_50B Fb_09_50B;
pwcorr Fb_95_100B Fb_01_100B Fb_09_100B;
pwcorr Fb_95_240B Fb_01_240B Fb_09_240B;

pwcorr Lb_95_50C Lb_01_50C Lb_09_50C;
pwcorr Lb_95_100C Lb_01_100C Lb_09_100C;
pwcorr Lb_95_240C Lb_01_240C Lb_09_240C;

pwcorr Lb_95_50D Lb_01_50D Lb_09_50D;
pwcorr Lb_95_100D Lb_01_100D Lb_09_100D;
pwcorr Lb_95_240D Lb_01_240D Lb_09_240D;

pwcorr Lb_95_50E Lb_01_50E Lb_09_50E;
pwcorr Lb_95_100E Lb_01_100E Lb_09_100E;
pwcorr Lb_95_240E Lb_01_240E Lb_09_240E;

pwcorr Lc_95_50A Lc_01_50A Lc_09_50A;
pwcorr Lc_95_100A Lc_01_100A Lc_09_100A;
pwcorr Lc_95_240A Lc_01_240A Lc_09_240A;

pwcorr Lc_95_50B Lc_01_50B Lc_09_50B;
pwcorr Lc_95_100B Lc_01_100B Lc_09_100B;
pwcorr Lc_95_240B Lc_01_240B Lc_09_240B;

pwcorr Ld_95_50A Ld_01_50A Ld_09_50A;
pwcorr Ld_95_100A Ld_01_100A Ld_09_100A;


pwcorr Ld_95_50B Ld_01_50B Ld_09_50B;
pwcorr Ld_95_100B Ld_01_100B Ld_09_100B;


pwcorr Ld_95_50C Ld_01_50C Ld_09_50C;
pwcorr Ld_95_100C Ld_01_100C Ld_09_100C;


pwcorr Ld_95_50D Ld_01_50D Ld_09_50D;
pwcorr Ld_95_100D Ld_01_100D Ld_09_100D;


pwcorr Le_95_50A Le_01_50A Le_09_50A;
pwcorr Le_95_100A Le_01_100A Le_09_100A;


pwcorr Le_95_50B Le_01_50B Le_09_50B;
pwcorr Le_95_100B Le_01_100B Le_09_100B;


pwcorr Le_95_50C Le_01_50C Le_09_50C;
pwcorr Le_95_100C Le_01_100C Le_09_100C;


pwcorr Le_95_50D Le_01_50D Le_09_50D;
pwcorr Le_95_100D Le_01_100D Le_09_100D;


pwcorr Lf_95_50A Lf_01_50A Lf_09_50A;
pwcorr Lf_95_100A Lf_01_100A Lf_09_100A;


pwcorr Lf_95_50B Lf_01_50B Lf_09_50B;
pwcorr Lf_95_100B Lf_01_100B Lf_09_100B;


pwcorr Lf_95_50C Lf_01_50C Lf_09_50C;
pwcorr Lf_95_100C Lf_01_100C Lf_09_100C;


pwcorr Lf_95_50D Lf_01_50D Lf_09_50D;
pwcorr Lf_95_100D Lf_01_100D Lf_09_100D;


pwcorr Lf_95_50E Lf_01_50E Lf_09_50E;
pwcorr Lf_95_100E Lf_01_100E Lf_09_100E;


pwcorr Lf_95_50F Lf_01_50F Lf_09_50F;
pwcorr Lf_95_100F Lf_01_100F Lf_09_100F;


pwcorr Lf_95_50G Lf_01_50G Lf_09_50G;
pwcorr Lf_95_100G Lf_01_100G Lf_09_100G;


pwcorr Lf_95_50H Lf_01_50H Lf_09_50H;
pwcorr Lf_95_100H Lf_01_100H Lf_09_100H;


pwcorr Lg_95_50A Lg_01_50A Lg_09_50A;
pwcorr Lg_95_100A Lg_01_100A Lg_09_100A;


pwcorr Lg_95_50B Lg_01_50B Lg_09_50B;
pwcorr Lg_95_100B Lg_01_100B Lg_09_100B;


pwcorr Lg_95_50C Lg_01_50C Lg_09_50C;
pwcorr Lg_95_100C Lg_01_100C Lg_09_100C;


pwcorr Lg_95_50D Lg_01_50D Lg_09_50D;
pwcorr Lg_95_100D Lg_01_100D Lg_09_100D;


pwcorr Lh_95_50A Lh_01_50A Lh_09_50A;
pwcorr Lh_95_100A Lh_01_100A Lh_09_100A;


pwcorr Lh_95_50B Lh_01_50B Lh_09_50B;
pwcorr Lh_95_100B Lh_01_100B Lh_09_100B;


pwcorr Lh_95_50C Lh_01_50C Lh_09_50C;
pwcorr Lh_95_100C Lh_01_100C Lh_09_100C;


pwcorr Lh_95_50D Lh_01_50D Lh_09_50D;
pwcorr Lh_95_100D Lh_01_100D Lh_09_100D;


display "comparisons across estimations";

pwcorr L_95_50A L_95_50B La_95_50A Lb_95_50A Lb_95_50B Lb_95_50C Lb_95_50D Lb_95_50E Lc_95_50A Lc_95_50B Ld_95_50A Ld_95_50B Ld_95_50C Ld_95_50D Le_95_50A Le_95_50B Le_95_50C Le_95_50D Lf_95_50A Lf_95_50B Lf_95_50C Lf_95_50D Lf_95_50E Lf_95_50F Lf_95_50G Lf_95_50H Lg_95_50A Lg_95_50B Lg_95_50C Lg_95_50D Lh_95_50A Lh_95_50B Lh_95_50C Lh_95_50D;

pwcorr L_95_100A L_95_100B La_95_100A Lb_95_100A Lb_95_100B Lb_95_100C Lb_95_100D Lb_95_100E Lc_95_100A Lc_95_100B Ld_95_100A Ld_95_100B Ld_95_100C Ld_95_100D Le_95_100A Le_95_100B Le_95_100C Le_95_100D Lf_95_100A Lf_95_100B Lf_95_100C Lf_95_100D Lf_95_100E Lf_95_100F Lf_95_100G Lf_95_100H Lg_95_100A Lg_95_100B Lg_95_100C Lg_95_100D Lh_95_100A Lh_95_100B Lh_95_100C Lh_95_100D;

*pwcorr L_95_240A L_95_240B La_95_240A Lb_95_240A Lb_95_240B Lb_95_240C Lb_95_240D Lb_95_240E Lc_95_240A Lc_95_240B Ld_95_240A Ld_95_240B Ld_95_240C Ld_95_240D Le_95_240A Le_95_240B Le_95_240C Le_95_240D Lf_95_240A Lf_95_240B Lf_95_240C Lf_95_240D Lf_95_240E Lf_95_240F Lf_95_240G Lf_95_240H Lg_95_240A Lg_95_240B Lg_95_240C Lg_95_240D Lh_95_240A Lh_95_240B Lh_95_240C Lh_95_240D;

pwcorr L_01_50A L_01_50B La_01_50A Lb_01_50A Lb_01_50B Lb_01_50C Lb_01_50D Lb_01_50E Lc_01_50A Lc_01_50B Ld_01_50A Ld_01_50B Ld_01_50C Ld_01_50D Le_01_50A Le_01_50B Le_01_50C Le_01_50D Lf_01_50A Lf_01_50B Lf_01_50C Lf_01_50D Lf_01_50E Lf_01_50F Lf_01_50G Lf_01_50H Lg_01_50A Lg_01_50B Lg_01_50C Lg_01_50D Lh_01_50A Lh_01_50B Lh_01_50C Lh_01_50D;

pwcorr L_01_100A L_01_100B La_01_100A Lb_01_100A Lb_01_100B Lb_01_100C Lb_01_100D Lb_01_100E Lc_01_100A Lc_01_100B Ld_01_100A Ld_01_100B Ld_01_100C Ld_01_100C Le_01_100A Le_01_100B Le_01_100C Le_01_100D Lf_01_100A Lf_01_100B Lf_01_100C Lf_01_100D Lf_01_100E Lf_01_100F Lf_01_100G Lf_01_100H Lg_01_100A Lg_01_100B Lg_01_100C Lg_01_100D Lh_01_100A Lh_01_100B Lh_01_100C Lh_01_100D;

*pwcorr L_01_240A L_01_240B La_01_240A Lb_01_240A Lb_01_240B Lb_01_240C Lb_01_240D Lb_01_240E Lc_01_240A Lc_01_240B Ld_01_240A Ld_01_240B Ld_01_240C Ld_01_240D Le_01_240A Le_01_240B Le_01_240C Le_01_240D Lf_01_240A Lf_01_240B Lf_01_240C Lf_01_240D Lf_01_240E Lf_01_240F Lf_01_240G Lf_01_240H Lg_01_240A Lg_01_240B Lg_01_240C Lg_01_240D Lh_01_240A Lh_01_240B Lh_01_240C Lh_01_240D;

pwcorr L_09_50A L_09_50B La_09_50A Lb_09_50A Lb_09_50B Lb_01_50C Lb_01_50D Lb_09_50E Lc_09_50A Lc_09_50B Ld_09_50A Ld_09_50B Ld_09_50C Ld_09_50D Le_09_50A Le_09_50B Le_09_50C Le_09_50D Lf_09_50A Lf_09_50B Lf_09_50C Lf_09_50D Lf_09_50E Lf_09_50F Lf_09_50G Lf_09_50H Lg_09_50A Lg_09_50B Lg_09_50C Lg_09_50D Lh_09_50A Lh_09_50B Lh_09_50C Lh_09_50D;

pwcorr L_09_100A L_09_100B La_09_100A Lb_09_100A Lb_09_100B Lb_09_100C Lb_01_100D Lb_09_100E Lc_09_100A Lc_09_100B Ld_09_100A Ld_09_100B Ld_09_100C Ld_09_100D Le_09_100A Le_09_100B Le_09_100C Le_09_100D Lf_09_100A Lf_09_100B Lf_09_100C Lf_09_100D Lf_09_100E Lf_09_100F Lf_09_100G Lf_09_100H Lg_09_100A Lg_09_100B Lg_09_100C Lg_09_100D Lh_09_100A Lh_09_100B Lh_09_100C Lh_09_100D;

*pwcorr L_09_240A L_09_240B La_09_240A Lb_09_240A Lb_09_240B Lb_09_240C Lb_09_240D Lb_09_240E Lc_09_240A Lc_09_240B Ld_09_240A Ld_09_240B Ld_09_240C Ld_09_240D Le_09_240A Le_09_240B Le_09_240C Le_09_240D  Lf_09_240A Lf_09_240B Lf_09_240C Lf_09_240D  Lf_09_240E Lf_09_240F Lf_09_240G Lf_09_240H Lg_09_240A Lg_09_240B Lg_09_240C Lg_09_240D Lh_09_240A Lh_09_240B Lh_09_240C Lh_09_240D;


* Controlling or not and the exact controls used do not matter so much;

display "differences in s.d.";

sum L_95_50A L_95_50B La_95_50A Lb_95_50A Lb_95_50B Lb_95_50C Lb_95_50D Lb_95_50E Lc_95_50A Lc_95_50B Ld_95_50A Ld_95_50B Ld_95_50C Ld_95_50D Le_95_50A Le_95_50B Le_95_50C Le_95_50D Lf_95_50A Lf_95_50B Lf_95_50C Lf_95_50D Lf_95_50E Lf_95_50F Lf_95_50G Lf_95_50H Lg_95_50A Lg_95_50B Lg_95_50C Lg_95_50D Lh_95_50A Lh_95_50B Lh_95_50C Lh_95_50D;

sum L_01_50A L_01_50B La_01_50A Lb_01_50A Lb_01_50B Lb_01_50C Lb_01_50D Lb_01_50E Lc_01_50A Lc_01_50B Ld_01_50A Ld_01_50B Ld_01_50C Ld_01_50D Le_01_50A Le_01_50B Le_01_50C Le_01_50D Lf_01_50A Lf_01_50B Lf_01_50C Lf_01_50D Lf_01_50E Lf_01_50F Lf_01_50G Lf_01_50H Lg_01_50A Lg_01_50B Lg_01_50C Lg_01_50D Lh_01_50A Lh_01_50B Lh_01_50C Lh_01_50D;

sum L_09_50A L_09_50B La_09_50A Lb_09_50A Lb_09_50B Lb_09_50C Lb_09_50D Lb_09_50E Lc_09_50A Lc_09_50B Ld_09_50A Ld_09_50B Ld_09_50C Ld_09_50D Le_09_50A Le_09_50B Le_09_50C Le_09_50D Lf_09_50A Lf_09_50B Lf_09_50C Lf_09_50D Lf_09_50E Lf_09_50F Lf_09_50G Lf_09_50H Lg_09_50A Lg_09_50B Lg_09_50C Lg_09_50D Lh_09_50A Lh_09_50B Lh_09_50C Lh_09_50D;

sum L_95_100A L_95_100B La_95_100A Lb_95_100A Lb_95_100B Lb_95_100C Lb_95_100D Lb_95_100E Lc_95_100A Lc_95_100B Ld_95_100A Ld_95_100B Ld_95_100C Ld_95_100D Le_95_100A Le_95_100B Le_95_100C Le_95_100D Lf_95_100A Lf_95_100B Lf_95_100C Lf_95_100D Lf_95_100E Lf_95_100F Lf_95_100G Lf_95_100H Lg_95_100A Lg_95_100B Lg_95_100C Lg_95_100D Lh_95_100A Lh_95_100B Lh_95_100C Lh_95_100D;

sum L_01_100A L_01_100B La_01_100A Lb_01_100A Lb_01_100B Lb_01_100C Lb_01_100D Lb_01_100E Lc_01_100A Lc_01_100B Ld_01_100A Ld_01_100B Ld_01_100C Ld_01_100C Le_01_100A Le_01_100B Le_01_100C Le_01_100D Lf_01_100A Lf_01_100B Lf_01_100C Lf_01_100D Lf_01_100E Lf_01_100F Lf_01_100G Lf_01_100H Lg_01_100A Lg_01_100B Lg_01_100C Lg_01_100D Lh_01_100A Lh_01_100B Lh_01_100C Lh_01_100D;

sum L_09_100A L_09_100B La_09_100A Lb_09_100A Lb_09_100B Lb_09_100C Lb_09_100D Lb_09_100E Lc_09_100A Lc_09_100B Ld_09_100A Ld_09_100B Ld_09_100C Ld_09_100D Le_09_100A Le_09_100B Le_09_100C Le_09_100D Lf_09_100A Lf_09_100B Lf_09_100C Lf_09_100D Lf_09_100E Lf_09_100F Lf_09_100G Lf_09_100H Lg_09_100A Lg_09_100B Lg_09_100C Lg_09_100D Lh_09_100A Lh_09_100B Lh_09_100C Lh_09_100D;

*sum L_95_240A L_95_240B La_95_240A Lb_95_240A Lb_95_240B Lb_95_240C Lb_95_240D Lb_95_240E Lc_95_240A Lc_95_240B Ld_95_240A Ld_95_240B Ld_95_240C Ld_95_240D Le_95_240A Le_95_240B Le_95_240C Le_95_240D Lf_95_240A Lf_95_240B Lf_95_240C Lf_95_240D Lf_95_240E Lf_95_240F Lf_95_240G Lf_95_240H Lg_95_240A Lg_95_240B Lg_95_240C Lg_95_240D Lh_95_240A Lh_95_240B Lh_95_240C Lh_95_240D;

*sum L_01_240A L_01_240B La_01_240A Lb_01_240A Lb_01_240B Lb_01_240C Lb_01_240D Lb_01_240E Lc_01_240A Lc_01_240B Ld_01_240A Ld_01_240B Ld_01_240C Ld_01_240D Le_01_240A Le_01_240B Le_01_240C Le_01_240D Lf_01_240A Lf_01_240B Lf_01_240C Lf_01_240D  Lf_01_240E Lf_01_240F Lf_01_240G Lf_01_240H Lg_01_240A Lg_01_240B Lg_01_240C Lg_01_240D Lh_01_240A Lh_01_240B Lh_01_240C Lh_01_240D;

*sum L_09_240A L_09_240B La_09_240A Lb_09_240A Lb_09_240B Lb_09_240C Lb_09_240D Lb_09_240E Lc_09_240A Lc_09_240B Ld_09_240A Ld_09_240B Ld_09_240C Ld_09_240D Le_09_240A Le_09_240B Le_09_240C Le_09_240D Lf_09_240A Lf_09_240B Lf_09_240C Lf_09_240D  Lf_09_240E Lf_09_240F Lf_09_240G Lf_09_240H Lg_09_240A Lg_09_240B Lg_09_240C Lg_09_240D Lh_09_240A Lh_09_240B Lh_09_240C Lh_09_240D;


log close; 
};



exit;












	 
	 

