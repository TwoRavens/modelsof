# delimit;

********************************************************************

this program makes tables and figures for the streetcar paper


august 1, 2017
  .. copied from 
  /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
  cons1940tractpicsv12.do
august 2, 2017
august 3, 2017
august 4, 2017 
  .. now importing main table file
  /groups/brooksgrp/zoning/streetcar_stops/stata_programs/density_regressions/
  zones_drivev29.do
august 9, 2017     .. new dataset with additions
august 10, 2017    .. coefficients by distance
august 30, 2017    .. fix concentric picture to be a regression at 3 km
september 1, 2017  .. more of same, hopefully
september 15, 2017 .. cleaning up figures
september 20, 2017 .. implementing non-parametric stuff
september 21, 2017 .. more non-param stuff
september 22, 2017 .. still more
september 27, 2017 .. still more
september 28, 2017 .. working on r3 comment about initial zoning
september 29, 2017 .. fixing up tables
october 3, 2017	   .. re-doing semiparametric stuff
october 4, 2017	   .. wrapping up tables, modification of dummy picture
october 10, 2017   .. working stop + line regressions
october 11, 2017   .. same 
october 12, 2017   .. same
october 16, 2017   .. circle/ring vs bands
october 20, 2017   .. appendix tables
october 25, 2017   .. byrons request on bins
october 26, 2017   .. still on the bins, and appendix table 2
october 27, 2017   .. make picture with bins
october 29, 2017   .. re-do
november 2, 2017   .. price results
november 3, 2017   .. price results, again
november 5, 2017   .. price results, income figure
november 7, 2017   .. price results
november 8, 2017   .. price results
november 9, 2017   .. figure 4 / appendix table rings figure
november 15, 2017  .. make referee note tables on interactions
november 19, 2017  .. fixing references in initial zoning by type table
november 20, 2017  .. main results, control mean 
august 13, 2018	   .. black and white figures

tables_figures_v35.do

********************************************************************;

  
****** A. set up **************************************************;

*** A.1. start up things ***;


clear all;
pause on;
set more off;
set matsize 10000;

* set todays date;
dateo;

*** A.2. load data ***;

**** data grouped by distance to streetcar, mostly for figures ****;

* these data are created in
  /home/lfbrooks/zoning/streetcars/sasprg/consistent_1940_tracts/to1940tractsv33.sas *;
global figure_data 
  "/groups/brooksgrp/zoning/streetcar_stops/parcel_level_datasets/historical_population_densities/1940_consistent_tracts/binned_data/cons_ts_1940to2010_20170927";

*** parcel-lvl data, mostly for tables ***;

* 2011 x-section *;
* these data are created in 
  /groups/brooksgrp/zoning/streetcar_stops/stata_programs/xsection_setup/data_stata_prep_v02.do *;
global reg_data
  "/groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/scar_revmgd_20170808_2011_xsec.dta";


*** A.3. permanent locations ******;

* temporary directory *;
global temp "/scratch/streetcars";

* temporary that gets deleted *;
global templ "/lustre/groups/brooksgrp/trash";

* figures out *;
global figout "/groups/brooksgrp/zoning/streetcar_stops/stata_figures/restat_paper_figures";

* main tables out *;
global main_tables "/groups/brooksgrp/zoning/streetcar_stops/stata_output/restat_paper_tables/main";

* numbers for chat *;
global main_chat "/groups/brooksgrp/zoning/streetcar_stops/stata_output/restat_paper_tables/chat";

* intermediate datasets to graph *;
global interim_dats "/groups/brooksgrp/zoning/streetcar_stops/stata_output/restat_paper_tables/interim";

* appendix tables *;
global app_tables "/groups/brooksgrp/zoning/streetcar_stops/stata_output/restat_paper_tables/appendix";

*** A.4. set up gates ***;

*****************************************;
*********** main paper gates ******************;
*****************************************;

***** main figures ***********************;

* raw data: density vs distance figure *;
* this one also has appendix figures in it ***;
local gate_raw_density_vs_distance = 2;

* raw data: density by space over time *;
* also has regressions that test for differences in trend *;
local gate_density_over_time = 2;

* conditional data: density conditional on P and D covariates *;
local gate_conditional_density = 1;

***** main tables ***********************;

* gate for big ado program *;
local gate_table_ado = 1;

* gate for summmary stats *;
local summ_stats = 2;

* gate for main results *;
local main_results = 2;

* gate for robustness *;
local robustness_table = 2;

* gate for zoning results table *;
* also produces panel a of agglomeration table *;
local zoning_as_dv = 2;

* gate for zoning explains results table *;
local zoning_explains = 2;

* gate for zombie zoning table *;
local zombie_zoning = 2;

* gate for agglomeration table *;
local agglomeration = 2;

* gate for prices table *;
local prices = 2;

*** for additional distance dummy table ***;
* this is the program that makes the log-log regressions controlling for 
  streetcar line
  program is
  /href/brooks/home/bleah/zoning/streetcars/stataprg/assa_2014_tables/assa_jan14_tables_v02.do
  section C
*;
* should probably also re-do basic regression at our 3 km radius *;


*****************************************;
*********** appendix gates ********************;
*****************************************;

***** appendix figures *******;

* la population over time *;
local gate_population_over_time = 2;

* streetcar ridership over time *;
local gate_ridership_over_time = 2;

* median personal income figure *;
local gate_income_by_distance = 2;

* basic density picture without la railway *;
local gate_density_wo_lar = 2;

* 1930 density vs streetcar, city only *;
local gate_1930_only = 2;

* fig. 2, conditional on p and d *;
local gate_fig2_cond = 2;

* income figure *;
local income_fig = 2;


****** appendix tables ***********************;

* appendix table 1: overall parcel distance to streetcar *;
local app_tab_streetcar_dist = 2;

* appendix table 2: zoning 1922/2013 summary stats *;
local app_tab_zone_change = 2;

* appendix table 3: bus stop robustness check *;
local bus_stop_check = 2;

***** referee note tables / requests *******;

* using distance in bins *;
local gate_dist_bands = 2;

* control for line in main specification *;
local add_line = 2;

* control for line in log/log specification, more data *;
local gate_control_line = 2;

* non-parametric estimation *;
local gate_non_param_est = 2;

* look at other density premia in the presence of zoning controls *;
local cbd_prem_w_zoning = 2;

* look at all coefficients from original table 5 to see if there is a premium *;
local dist_prem_org = 2;

* streetcar stops w/o permissive zoning *;
local initial_zn_type = 2;

* main results w/ logged dv*;
local log_dv_main_results = 2;

* variation in zoning *;
local zoning_var = 2;

* aligning circle/ring with distance bands *;
local circle_vs_band = 2;

* 5th order polynominal *;
local fifth_order_poly = 2;

***********************************************************************************;
***********************************************************************************;
************************* DATA PREP ***********************************************;
***********************************************************************************;
***********************************************************************************;

***************** ado to load data and create variables for property-level 
		  x-section  ******************************************************;

capture program drop xsec_datagate;
program define xsec_datagate;

  syntax, [lastonly(string)];

  ******* A. load data ******************************************************************;

  * run this only if lastonly local macro is missing *;
  if "`lastonly'" == ""\
    {;
    * data created by 
    /groups/brooksgrp/zoning/streetcar_stops/stata_programs/xsection_setup/data_stata_prep_v02.do *;
    drop _all;
    use ${reg_data};

    keep     ain ln_min_dist_pestops map_tbg map_fips_place
         use use_cd pestop_min_dist_1 year_of_data last_sale_date units_per_lotsize    
	 city_name
	 ln_sqft_per_lotsize 
         lot_size sqft_per_lotsize units_per_lotsize pestop_id_1 imp_val_lotsize 
	 min_dist*
         z_max_ht_feet z_max_ht_stories z_far z_use_* z_min_ls z_c_parking z_uc_parking 
	 elevation year_built in4cities
	 years_last_sale*
	 z_area_fe z_2013 z_1922 z22 z22_fe z13_22 z_2013z22
	 z_1922 z_2013z22 z_zn2013map
         z_max_units z_zoningdata z_match_code* zone_code_id
	 ruggedness* ele_mis elevation*

    city_zone z_2013 zn_info z_1922 z22 z22_fe z_2013z22 z13_22 z_1922_nlp
    z_1922_nmp z_1922_ch z13_22_fe  z13_22_znonly_fe* z22_znonly_fe*
    resz22 nresz22 resz13_22 z_1922_ch_to_C z_1922_ch_to_CD res non_res
    ln_z_far ln_z_max_ht_feet ln_z_max_ht_stories ln_z_min_ls ln_lot_size*
    vacant 
    z_far* ln_z_far* z_max_ht_feet* ln_z_max_ht_feet* z_max_ht_stories* ln_z_max_ht_stories* 
    z_min_ls* ln_z_min_ls* z_c_parking* z_uc_parking*
    multi_fam_r ln_imp_val_lotsize
    z_nonres;
    }; * end of loop if lastonly is missing -- most cases *;

  ******* B. unconditional and condition, distance to the streetcar ***************************;

  * name covariates that pre-date the streetcar *;
  unab preexstc: elevation* ele_mis ruggedness ruggedness_0 min_dist_dt_pt* min_dist_coast* 
       		 min_dist_rds1925* min_dist_ints34*;
  global preexstc `preexstc';

  * name the remaining covariates we use *;
  unab othercovs: min_dist_majrd* min_dist_rail* min_dist_link* min_dist_hwy*;
  global othercovs `othercovs';

  * zoning measures *;
  global z_measures "z_far ln_z_far z_max_ht_feet ln_z_max_ht_feet z_max_ht_stories 
  	 	    ln_z_max_ht_stories z_min_ls ln_z_min_ls z_c_parking z_uc_parking 
		    z_nonres multi_fam_r";

end; * end of ado xsec_datagate;




***********************************************************************************;
***********************************************************************************;
************************* MAIN TEXT ***********************************************;
***********************************************************************************;
***********************************************************************************;

* set for all graphs *;
graph set eps orientation landscape;

***********************************************************************************;
************ figure: raw data: density vs distance to streetcar *******************;
***********************************************************************************;

if `gate_raw_density_vs_distance' == 1
{;

  * full program is 
    /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
    cons1940tractpicsv12.do *;

  ***** 1. load data **************************************************************;

  drop _all;
  use ${figure_data};

  ***** 2. density picture ********************************************************;

    lowess cvar1_1_2010 min_dist_any_scar, generate(lowess_p) bwidth(0.4);
    twoway
      (scatter cvar1_1_2010 min_dist_any_scar if cvar1_1_2010 <= 10 & min_dist_any_scar <= 6, msymbol(p))
      (scatter lowess_p     min_dist_any_scar if cvar1_1_2010 <= 10 & min_dist_any_scar <= 6, msymbol(p)),
      legend(off)
      ytitle("1000s of people per sq km")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

  *graph export 
    "${figout}/main/${date}_density.eps",
    replace;
  *shell convert -density 600 
    ${figout}/main/${date}_density.eps
    ${figout}/main/${date}_density.jpg;

  ***** 3. people per housing unit *************************************************;

    lowess cvar1_2_2010 min_dist_any_scar, generate(lowess_p) bwidth(0.4);
    twoway
      (scatter cvar1_2_2010 min_dist_any_scar if cvar1_2_2010 <= 4 & min_dist_any_scar <= 6, msymbol(p))
      (scatter lowess_p     min_dist_any_scar if cvar1_2_2010 <= 4 & min_dist_any_scar <= 6, msymbol(p)),
      legend(off)
      ytitle("people per housing unit")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

  *graph export 
    "${figout}/appendix/${date}_ppl_per_hu.eps",
    replace;
  *shell convert -density 600 
    ${figout}/appendix/${date}_ppl_per_hu.eps
    ${figout}/appendix/${date}_ppl_per_hu.jpg;

  ***** 4. housing units per land area ****************************************************;

    lowess cvar1_3_2010 min_dist_any_scar, generate(lowess_p) bwidth(0.4);
    twoway
      (scatter cvar1_3_2010 min_dist_any_scar if cvar1_3_2010 <= 4000 & min_dist_any_scar <= 6, msymbol(p))
      (scatter lowess_p     min_dist_any_scar if cvar1_3_2010 <= 4000 & min_dist_any_scar <= 6, msymbol(p)),
      legend(off)
      ytitle("housing units per sq km")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

  *graph export 
    "${figout}/appendix/${date}_hu_per_land.eps",
    replace;
  *shell convert -density 600 
    ${figout}/appendix/${date}_hu_per_land.eps
    ${figout}/appendix/${date}_hu_per_land.jpg;

  ***** 5. density picture: black & white ****************************************************;

    lowess cvar1_1_2010 min_dist_any_scar, generate(lowess_p) bwidth(0.4);
    twoway
      (scatter cvar1_1_2010 min_dist_any_scar if cvar1_1_2010 <= 10 & min_dist_any_scar <= 6, 
      	       msymbol(p) mcolor(gs10))
      (scatter lowess_p     min_dist_any_scar if cvar1_1_2010 <= 10 & min_dist_any_scar <= 6, 
      	       msymbol(p) mcolor(gs0)),
      legend(off)
      scheme(s1mono)
      ytitle("1000s of people per sq km")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

  graph export 
    "${figout}/main/${date}_density_bw.eps",
    replace;
  shell convert -density 600 
    ${figout}/main/${date}_density_bw.eps
    ${figout}/main/${date}_density_bw.jpg;



}; * this bracket ends the density vs distance gate *;


***********************************************************************************;
************ figure: raw data: density over time **********************************;
***********************************************************************************;


if `gate_density_over_time' == 1
{;

  * full program is 
    /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
    cons1940tractpicsv12.do *;
   
   ***** 1. fix up data to graph ***;

  drop _all;
  use ${figure_data};

  * bucket 4077 is the first bucket at 3 km, so we say that 4077 buckets make up the the 3 km radius *;

  * mark deciles 1 to 10, and 1st and 99th p *;

  local bucketmax = 4077;

  gen percentile = 0;
  foreach j in 
    10 20 30 40 50 60 70 80 90 
    {;
    replace percentile = `j' if bucket == round(`bucketmax'*(`j'/100),1);
    };

  * keep only marked deciles *;
  keep if percentile != 0;

  * keep bucket and percentile and density variables *;
  keep bucket percentile cvar1_1_*;

  * save before re-shaping *;
  save ${temp}/perc_prereshape, replace;

  * reshape, so years are in columns, not percentiles, just density *;
  drop cvar1_1_*_se;
  reshape long cvar1_1_, i(percentile) j(year);
  sort percentile year;
  * save to merge later *;
  save ${temp}/perc_density, replace;

  * reshape, but with errors, not densities *;
  drop _all;
  use ${temp}/perc_prereshape;
  keep percentile cvar1_1_*_se;
  * rename to get reshape to work *;
  forvalues j=1940(10)2010
    {;
    rename cvar1_1_`j'_se se_`j';
    };
  reshape long se_, i(percentile) j(year);
  sort percentile year;

  * merge densities and errors together *;
  merge 1:1 percentile year using ${temp}/perc_density;
  tab _merge;
  drop _merge;

  rename cvar1_1_ density;

  ***** 2. make pictures *********************************;

  * density gradient over time by percentile *;
    twoway
      (connected density year if percentile == 10) 
      (connected density year if percentile == 20)
      (connected density year if percentile == 30) 
      (connected density year if percentile == 40)
      (connected density year if percentile == 50)
      (connected density year if percentile == 60)
      (connected density year if percentile == 70)
      (connected density year if percentile == 80)
      (connected density year if percentile == 90),
      legend(off)
      ytitle("1000s of people per sq km")

      xscale(range(1940 2015))
      xlabel(1940(20)2010)

      text(5.6 2014.5 "0.3 km")
      text(5.0 2014 "0.6")
      text(4.6 2014 "0.9")
      text(4.1 2014 "1.2")
      text(3.6 2014 "1.5")
      text(3.2 2014 "2.4")
      text(2.7 2014 "2.7")
      
      xtitle("")
      xsize(11) ysize(8.5);

  *graph export 
    "${figout}/main/${date}_density_percentiles.eps",
    replace;

  *shell convert -density 600 
    ${figout}/main/${date}_density_percentiles.eps
    ${figout}/main/${date}_density_percentiles.jpg;


  ***** 3. make black and white pictures *********************************;

  * density gradient over time by percentile *;
    twoway
      (connected density year if percentile == 10, msymbol(O) mcolor(gs0) lcolor(gs0) lpattern(solid)) 
      (connected density year if percentile == 20, msymbol(D) mcolor(gs4) lcolor(gs4) lpattern(solid)) 
      (connected density year if percentile == 30, msymbol(T) mcolor(gs8) lcolor(gs8) lpattern(solid)) 
      (connected density year if percentile == 40, msymbol(S) mcolor(gs12) lcolor(gs12) lpattern(solid)) 
      (connected density year if percentile == 50, msymbol(O) mcolor(gs0) lcolor(gs0) lpattern(solid)) 
      (connected density year if percentile == 60, msymbol(T) mcolor(gs4) lcolor(gs4) lpattern(solid)) 
      (connected density year if percentile == 70, msymbol(D) mcolor(gs8) lcolor(gs8) lpattern(solid)) 
      (connected density year if percentile == 80, msymbol(S) mcolor(gs12) lcolor(gs12) lpattern(solid)) 
      (connected density year if percentile == 90, msymbol(O) mcolor(gs0) lcolor(gs0) lpattern(solid)),
      legend(off)
      ytitle("1000s of people per sq km")
      plotregion(style(none))

      scheme(s1mono)
      xscale(range(1940 2015))
      xlabel(1940(20)2010)

      text(5.6 2014.5 "0.3 km")
      text(5.0 2014 "0.6")
      text(4.6 2014 "0.9")
      text(4.1 2014 "1.2")
      text(3.6 2014 "1.5")
      text(3.2 2014 "2.4")
      text(2.7 2014 "2.7")
      
      xtitle("")
      xsize(11) ysize(8.5);

  graph export 
    "${figout}/main/${date}_density_percentiles_bw.eps",
    replace;

  shell convert -density 600 
    ${figout}/main/${date}_density_percentiles_bw.eps
    ${figout}/main/${date}_density_percentiles_bw.jpg;

  
  ***** 4. regressions to test change ****************************************;

  * make new distance variable for linear distance *;
  gen distance = 0;
  replace distance = 0.3 if percentile == 10;
  replace distance = 0.6 if percentile == 20;
  replace distance = 0.9 if percentile == 30;
  replace distance = 1.2 if percentile == 40;
  replace distance = 1.5 if percentile == 50;
  replace distance = 1.8 if percentile == 60;
  replace distance = 2.1 if percentile == 70;
  replace distance = 2.4 if percentile == 80;
  replace distance = 2.7 if percentile == 90;

  capture log close;
  *log using 
    ${main_chat}/${date}_by_radius_density_growth.log, replace;

  *** 3.a. let each distance have its own slope ***;

  * make variables so i can get specification i want *;
  quietly tab distance, gen(ddum);
  summ ddum*;
  forvalues j=1/9
    {;
    gen t_ddum`j' = year*ddum`j';
    };

  di "this regression tells us that the slope over time by distance to the 
      streetcar does not change significantly over time"; 
  xi: regress density ddum1-ddum8 t_ddum1-t_ddum9;
  test t_ddum1 = t_ddum2 = t_ddum3 = t_ddum4 == t_ddum5 = 
       t_ddum6 = t_ddum7 = t_ddum8 = t_ddum9;

  *** 3.b. let each year have its own slope ***;

  * make year dummies **;
  quietly tab year, gen(yeardum);
  summ yeardum*;
  forvalues j=1/8
    {;
    gen d_ydum`j' = distance*yeardum`j';
    };
  summ d_ydum*;

  di "this regression tells us that the year-specific slope in density 
      does not change significantly over time"; 
  xi: regress density yeardum1-yeardum7 d_ydum1-d_ydum8;
  test d_ydum1 = d_ydum2 = d_ydum3 = d_ydum4 == d_ydum5 = 
       d_ydum6 = d_ydum7 = d_ydum8 ;

  *log close;


}; * end of gate_density_over_time *;


***********************************************************************************;
************ figure 4: regression density effects by distance  ********************;
***********************************************************************************;

if `gate_conditional_density' == 1
  {;

  ***** 0. call data ********;

  drop _all;
  xsec_datagate;

  save ${templ}/f4test, replace;

  ***** 1. post-estimation output ***;

  * little ado to put coefficients, # streetcar stops, obs, std errors into local macros 
    for postfile *;

  capture program drop topost;
  program define topost;

    syntax, num(string) depvar(string) df(string) sdigs(string);

      global `depvar'_b`df'`num'  : display %5.`sdigs'f _b[cir_`df']; 
      global `depvar'_se`df'`num' : display %5.`sdigs'f  _se[cir_`df'];
      global `depvar'_n`df'`num'  : display %7.0fc e(N);
      by pestop_id_1: gen unq = _n == 1 & e(sample) == 1;
      count if unq;
      global `depvar'_sn`df'`num' : display %7.0fc r(N);
      drop unq;

  end;

  ****** 2. ado file **********;

  capture program drop circler2;
  program define circler2;

  syntax, tabletype(string) depvar(string) 
          [covs(string) andif(string) drop_near_lary(string) old_zone_only(string) 
	  post_1963(string) exclude_dt(string) dt_dist(string) 1922zfe(string) 
	  2013_22zfe(string) ringer(string)
	  zombiec(string) zonedvs(string) postname(string) no4(string)];

  forvalues df = 1/30
    {;

    * restore data if not the first run so we can reweight and re-drop *;
    if "`df'" != "1"
      {;
      drop _all;
      use ${templ}/f4test;
      *restore, preserve;
      };

    * make key variables -- should be defined in each round *;
    gen cir_`df'_outer  = pestop_min_dist_1  <= (`df'/10)*(2^.5);
    gen cir_`df'_inner  = pestop_min_dist_1  <= (`df'/10);
    gen lar_`df'_outer  = min_dist_lary      <= (`df'/10)*(2^.5);

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') 
    	      	       covs($preexstc $othercovs)
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/o covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner 
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ P covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner $preexstc 
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ P and D covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner $preexstc $othercovs
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(3) depvar(`depvar') df(`df') sdigs(4);
 
    *** post the output to the stata file ***;
    post humppic ("`tabletype'") ("`df'") ("no covs")
      ("${`depvar'_b`df'1}")  ("${`depvar'_se`df'1}")  
      ("${`depvar'_n`df'1}") ("${`depvar'_sn`df'1}");
    post humppic ("`tabletype'") ("`df'") ("control p")
      ("${`depvar'_b`df'2}")  ("${`depvar'_se`df'2}")  
      ("${`depvar'_n`df'2}") ("${`depvar'_sn`df'2}");
    post humppic ("`tabletype'") ("`df'") ("control p and d")
      ("${`depvar'_b`df'3}")  ("${`depvar'_se`df'3}")  
      ("${`depvar'_n`df'3}") ("${`depvar'_sn`df'3}");

    * get rid of largest consistent sample marker *;
    drop vok;

    }; * end of df loop *;

  end; * end of circler2 ado *;

  ***** 4. call the ado **************;
  
  *postfile humppic 
	 str100 tabletype str3 radius str100 covtype str15(coeff stderr obs stops) using 
	 ${interim_dats}/${date}_hump_pic, replace;

  *circler2, tabletype(output_for_picture) depvar(sqft_per_lotsize) drop_near_lary(yes);

  *postclose humppic;

  ***** 5. set up data to make the pictures ****************;  

  drop _all;
  *use ${interim_dats}/${date}_hump_pic;
  use ${interim_dats}/20170915_hump_pic;

  destring coeff, replace;
  destring stderr, replace;
  destring radius, replace;
  replace radius = radius / 10;

  gen cihi = coeff + 1.96*stderr;
  gen cilow = coeff - 1.96*stderr;

  ***** 6. make the pictures ***************************************;

  graph set eps orientation landscape;

  *** 6.a. coefficient and confidence intervals ***;

  twoway
    (rarea cilow cihi radius if covtype == "control p and d", bcolor(gs14))
    (connected coeff radius if covtype == "control p and d"),
    legend(off)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density: (structure sq ft / lot sq ft)*100")
    xlabel(0.1 (0.2) 2.9)
    yscale(range(-3 6))
    ylabel(-2 (2) 6)
    xsize(11)
    ysize(8.5);

  *graph export 
    "${figout}/main/${date}_causation_pic.eps", replace;
  *shell convert -density 600 
    ${figout}/main/${date}_causation_pic.eps
    ${figout}/main/${date}_causation_pic.jpg;

  **** 6.b. no controls vs p controls vs p and d controls ***;

  twoway
    (connected coeff radius if covtype == "no covs", 
      msymbol(o) lcolor(midblue) mcolor(midblue))
    (connected coeff radius if covtype == "control p", 
      msymbol(o) lcolor(green) mcolor(green))
    (connected coeff radius if covtype == "control p and d", 
      msymbol(o) lcolor(cranberry) mcolor(cranberry)),
    legend(off)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density: (structure sq ft / lot sq ft)*100")
    xlabel(0.1 (0.2) 2.9)
    ylabel(0 (3.5) 7)
    yscale(range(0 7))
    text(3.7 2.6 "Without controls")
    text(1.8 2.6 "{it:P} Controls")
    text(1.0 1.2 "{it:P} and {it:D} Controls")
    xsize(11)
    ysize(8.5);

  *graph export 
    "${figout}/main/${date}_main_vs_controls.eps", replace;
  *shell convert -density 600 
    ${figout}/main/${date}_main_vs_controls.eps
    ${figout}/main/${date}_main_vs_controls.jpg;

  *** 6.c. all coefficients and final confidence intervals ***;

  twoway
    (rarea cilow cihi radius if covtype == "control p and d", bcolor(gs14))
    (connected coeff radius if covtype == "no covs", 
      msymbol(o) lcolor(midblue) mcolor(midblue))
    (connected coeff radius if covtype == "control p", 
      msymbol(o) lcolor(green) mcolor(green))
    (connected coeff radius if covtype == "control p and d", 
      msymbol(o) lcolor(cranberry) mcolor(cranberry)),
    legend(off)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density: (structure sq ft / lot sq ft)*100")
    xlabel(0.1 (0.2) 2.9)
    ylabel(0 (3.5) 7)
    yscale(range(0 7))
    text(3.7 2.6 "Without controls")
    text(1.8 2.6 "{it:P} Controls")
    text(1.0 1.2 "{it:P} and {it:D} Controls")
    xsize(11)
    ysize(8.5);

  *graph export 
    "${figout}/main/${date}_circle_treat_3lines_and_ci.eps", replace;
  *shell convert -density 600 
    ${figout}/main/${date}_circle_treat_3lines_and_ci.eps
    ${figout}/main/${date}_circle_treat_3lines_and_ci.jpg;

  *** 6.d. all coefficients and final confidence intervals: black and white ***;

  twoway
    (rarea cilow cihi radius if covtype == "control p and d", bcolor(gs15))
    (connected coeff radius if covtype == "no covs", 
      msymbol(O) lcolor(gs8) mcolor(gs8) lpattern(solid) msize(small))
    (connected coeff radius if covtype == "control p", 
      msymbol(D) lcolor(gs4) mcolor(gs4) lpattern(solid) msize(small))
    (connected coeff radius if covtype == "control p and d", 
      msymbol(T) lcolor(gs0) mcolor(gs0) lpattern(solid) msize(small)),
    legend(off)
    scheme(s1mono)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density: (structure sq ft / lot sq ft)*100")
    xlabel(0.1 (0.2) 2.9)
    ylabel(0 (3.5) 7)
    yscale(range(0 7))
    text(3.7 2.6 "Without controls")
    text(1.8 2.6 "{it:P} Controls")
    text(1.0 1.2 "{it:P} and {it:D} Controls")
    xsize(11)
    ysize(8.5);

  graph export 
    "${figout}/main/${date}_circle_treat_3lines_and_ci_bw.eps", replace;
  shell convert -density 600 
    ${figout}/main/${date}_circle_treat_3lines_and_ci_bw.eps
    ${figout}/main/${date}_circle_treat_3lines_and_ci_bw.jpg;


}; * end of gate_conditional_density: main regression results figures *;


***********************************************************************************;
************ figure: fig 2, conditional on p and d  *******************************;
***********************************************************************************;

if `gate_fig2_cond' == 1
{;

  ***** 1. load data **************************************************************;

  drop _all;
  use ${figure_data};

  * to see how many obs are dropped due to restrictions on figure *;
  summ res_p res_pd;
  summ res_p if res_p < 4 & res_p > -2 ;
  summ res_pd if res_pd < 4 & res_pd > -2 ;
  summ res_pdll if res_pdll < 4 & res_pdll > -2 ;

  ***** 2. density picture ********************************************************;

  foreach dv in 
    p
    pd 
    ll
    pdll
  {;

    if "`dv'" == "p" {; local big "{it:P}"; };
    if "`dv'" == "pd" {; local big "{it:P} and {it:D}"; };
    if "`dv'" == "ll" {; local big "lat and long"; };
    if "`dv'" == "pdll" {; local big "{it:P}, {it:D}, lat and long"; };

    lowess res_`dv' min_dist_any_scar, generate(lowess_p) bwidth(0.4);
    twoway
      (scatter res_`dv' min_dist_any_scar 
        if res_`dv' < 4 & res_`dv' > -1.5 & min_dist_any_scar <= 6, msymbol(p))
      (scatter lowess_p     min_dist_any_scar 
        if res_`dv' < 4 & res_`dv' > -1.5 & min_dist_any_scar <= 6, msymbol(p)),
      legend(off)
      ytitle("residuals: population density conditional on `big'")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

    graph export 
      "${figout}/appendix/${date}_density_cond_`dv'.eps",
      replace;
    shell convert -density 600 
      ${figout}/appendix/${date}_density_cond_`dv'.eps
      ${figout}/appendix/${date}_density_cond_`dv'.jpg;

  };

}; * this bracket ends the density vs distance gate *;


********************************************************************;
***************** data prep stuff **********************************;
********************************************************************;


******************* big ado for tables ******************************************;

if `gate_table_ado' == 1 {;

*** E.0 post-estimation output ***;

* little ado to put coefficients, # streetcar stops, obs, std errors into local macros for postfile *;
capture program drop topost;
program define topost;

  syntax, num(string) depvar(string) df(string) sdigs(string);

    global `depvar'_b`df'`num'  : display %5.`sdigs'f _b[cir_`df']; 
    global `depvar'_se`df'`num' : display %5.`sdigs'f  _se[cir_`df'];
    global `depvar'_n`df'`num'  : display %7.0fc e(N);
    by pestop_id_1: gen unq = _n == 1 & e(sample) == 1;
    count if unq;
    global `depvar'_sn`df'`num' : display %7.0fc r(N);
    drop unq;

end;


*** E.2. ado for regs ***;

* set up stata file for output for ring regressions *;
*postfile ringer str20 typer str25 outtype col1 using 
  /href/brooks/home/bleah/zoning/streetcars/stataout/assa_jan14_tables/${date}_ring_regs, replace;

capture program drop circler;
program define circler;

  syntax, tabletype(string) depvar(string) typer(string) 
          [covs(string) andif(string) drop_near_lary(string) old_zone_only(string) post_1963(string)
	   exclude_dt(string) dt_dist(string) 1922zfe(string) 2013_22zfe(string) ringer(string)
	   zombiec(string) zonedvs(string) postname(string) no4(string) zombieendog(string)];

  local df       = 5; 
  local inner_area`df'                      = round(c(pi) * ((`df'/10)^2),.1);
  local kdist`df'                           = `df' /10;

  * preserve the data here so i can re-load to re-weight later for the ring regressions *;
  preserve;

  gen cir_`df'_outer  = pestop_min_dist_1  <= (`df'/10)*(2^.5);
  gen cir_`df'_inner  = pestop_min_dist_1  <= (`df'/10);
  gen lar_`df'_outer  = min_dist_lary      <= (`df'/10)*(2^.5);


  * main results only table *;
  if "`tabletype'" == "main"
    {;
    * the keep command needs to be kept here because many of the data steps below depend on 
      it already having been done;
    keep if cir_`df'_outer == 1;

    * switch if we only want the zoning data sample *;
    if "`zonedvs'" == "yes"
      {;
      * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
      keep if z_zoningdata == 1;
      };

    * save any true covariates in covs2 *;
    local covs2 `covs';

    * set covariates equal to the full set so we get a constant sample *;
    local covs $preexstc $othercovs;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * return covariates to original input *;
    local covs `covs2';

    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/ covariates *;
    areg  `depvar'  cir_`df'_inner `covs'
          $rweight
          if cir_`df'_outer == 1 & vok == 1  , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner `covs'
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);
    summ `depvar'_nol if cir_`df'_outer == 1 & cir_`df'_inner != 1 & vok == 1 $rweight_nol;
 
   * this will post the dep variable mean if we are doing the use and zone run *;
    if "`postname'" == "useandzone"
      {;
      local nol_mean = r(mean);
      local expost `"("`nol_mean'")"';
      };
      
    *** post the output to the stata file ***;
    post `postname' ("`typer'") ("coeffs")   
      ("${`depvar'_b`df'1}")  ("${`depvar'_b`df'2}") `expost';
    post `postname' ("`typer'") ("ses")      
      ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") `expost';
    post `postname' ("`typer'") ("parcels")  
      ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") `expost';
    post `postname' ("`typer'") ("stops")    
      ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") `expost';

    * get rid of largest consistent sample marker *;
    drop vok;

    };  * end of main regression loop *;

  * robustness results only table *;
  if "`tabletype'" == "robusto"
    {;

    * drop more parcels if the type is ringer *;
    if "`ringer'" == "yes"
      {;
      * the inner circle which is ommitted from the original treatment circle to form the 
        treatment ring has a radius equal to
        (2 * original control circle radius) - (radius of outer circle (e.g., treatment circle));
      * i still call it -cir- here for ease of programming, but its a ring if i specify the ringer
        option = yes *;
      gen temp_cir= cir_`df'_inner;
      gen rin_`df'_inner  
        = pestop_min_dist_1  <= (`df'/10) & (pestop_min_dist_1  > (((2*`df')/10)  - ((`df'/10)*(2^.5))));

      * this drops the very inner bit of the circle *;
      drop if cir_`df'_inner == 1 & rin_`df'_inner ~= 1;
      };

    * drop cities that have pre-streetcar development if type is requirepop *;
    * see notes below on how we make this choice *;
    if "`ringer'" == "drop_no_pop_cities"
      {;
      gen dropper=1 if 
        map_fips_place == "00884" | map_fips_place == "03274" | map_fips_place == "03386" | 
        map_fips_place == "15044" | map_fips_place == "19766" | map_fips_place == "36546" |
    	map_fips_place == "43000" | map_fips_place == "44000" | map_fips_place == "46492" |
    	map_fips_place == "48648" | map_fips_place == "56000" | map_fips_place == "58072" |
    	map_fips_place == "60018" | map_fips_place == "70000" | map_fips_place == "73220" | 
    	map_fips_place == "85292" ;
      drop if dropper == 1;
      drop dropper;
      };

    * define these extra variables for the regression if the dv is improvement value per
      lot size *;
    if "`depvar'" == "imp_val_lotsize"
      {;
      * define extra variables for value regressions *;
      local extravar = "years_last_sale years_last_sale2 years_last_sale3 years_last_sale4";
      };

    * the keep command needs to be kept here because many of the data steps below depend on it 
      already having been done;
    keep if cir_`df'_outer == 1;

    * save any true covariates in covs2 *;
    local covs2 `covs';

    * set covariates equal to the full set so we get a constant sample in the nol_ program *;
    * add years from sale so we get the biggest possible sample *;
    local covs $preexstc $othercovs `extravar';

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * make interactions of circle dummy and distance to streetcar stop and line *;
    gen cir_`df'_inner_stopd = cir_`df'_inner*pestop_min_dist_1;
    label variable cir_`df'_inner_stopd "interaction: cir_`df'_inner * distance to streetcar stop";
    gen cir_`df'_inner_lined = cir_`df'_inner*min_dist_pelines;
    label variable cir_`df'_inner_lined "interaction: cir_`df'_inner * distance to streetcar line";
     
    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/o covariates *;
    areg  `depvar'  cir_`df'_inner `extravars'
          $rweight
          if cir_`df'_outer == 1 & vok == 1  , a(pestop_id_1) cluster(pestop_id_1);
    summ `depvar' if cir_`df'_outer == 1 & cir_`df'_inner != 1 & vok == 1;
    global `depvar'_dvmn`df'1 : display %5.4f r(mean);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates *;
    areg  `depvar'  cir_`df'_inner `extravars' $preexstc
          $rweight
          if cir_`df'_outer == 1 & vok == 1  , a(pestop_id_1) cluster(pestop_id_1);
    summ `depvar' if cir_`df'_outer == 1 & cir_`df'_inner != 1 & vok == 1;
    global `depvar'_dvmn`df'2 : display %5.4f r(mean);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway *;
    areg  `depvar'  cir_`df'_inner `extravars' $preexstc $othercovs
          $rweight
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    summ `depvar' if cir_`df'_outer == 1 & cir_`df'_inner != 1 & vok == 1;
    global `depvar'_dvmn`df'3 : display %5.4f r(mean);
    topost, num(3) depvar(`depvar') df(`df') sdigs(4);
      
    *** post the output to the stata file ***;
    post robusto ("`typer'") ("coeffs")   
      ("${`depvar'_b`df'1}")  ("${`depvar'_b`df'2}") ("${`depvar'_b`df'3}");
    post robusto ("`typer'") ("ses")      
      ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") ("${`depvar'_se`df'3}");
    post robusto ("`typer'") ("parcels")  
      ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") ("${`depvar'_n`df'3}");
    post robusto ("`typer'") ("stops")    
      ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") ("${`depvar'_sn`df'3}");
    post robusto ("`typer'") ("dv mean")    
      ("${`depvar'_dvmn`df'1}") ("${`depvar'_dvmn`df'2}") ("${`depvar'_dvmn`df'3}");

    * get rid of largest consistent sample marker *;
    drop vok;

    };  * end of robustness regression loop *;


  * execute the regressions *;
  * if its the first basic table *;
  if "`tabletype'" == "basic"
    {;

    * the keep command needs to be kept here because many of the data steps below depend on it already having been done;
    keep if cir_`df'_outer == 1;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * make interactions of circle dummy and distance to streetcar stop and line *;
    gen cir_`df'_inner_stopd = cir_`df'_inner*pestop_min_dist_1;
    label variable cir_`df'_inner_stopd "interaction: cir_`df'_inner * distance to streetcar stop";
    gen cir_`df'_inner_lined = cir_`df'_inner*min_dist_pelines;
    label variable cir_`df'_inner_lined "interaction: cir_`df'_inner * distance to streetcar line";
     
    * define extra variables for value regressions *;
    local extravar = "years_last_sale years_last_sale2 years_last_sale3 years_last_sale4";

    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/o covariates *;
    areg  `depvar'  cir_`df'_inner 
          $rweight
         if cir_`df'_outer == 1, a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);
    gen esamp = e(sample);

    * regression w/ covariates *;
    areg  `depvar'  cir_`df'_inner `covs'
          $rweight
          if cir_`df'_outer == 1 & vok == 1  , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner `covs'
          $rweight
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(3) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway or stop clusters *;
    areg  `depvar'_nol_4  cir_`df'_inner `covs'
          $rweight           
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(4) depvar(`depvar') df(`df') sdigs(4);

    * structure value/lot size, full covariates, no la railway stops *;
    areg  imp_val_lotsize_nol  cir_`df'_inner `covs' `extravar'
          $rweight
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(5) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway and only unpopulated places *;
    areg  `depvar'_nol  cir_`df'_inner `covs'
          $rweight
          if cir_`df'_outer == 1 & vok == 1 `andif', a(pestop_id_1) cluster(pestop_id_1);
    topost, num(6) depvar(`depvar') df(`df') sdigs(4);

    *** post the output to the stata file ***;
    post circleo ("`typer'") ("coeffs")   
      ("${`depvar'_b`df'1}")  ("${`depvar'_b`df'2}")  ("${`depvar'_b`df'3}")  
      ("${`depvar'_b`df'4}")  ("${`depvar'_b`df'5}")  ("${`depvar'_b`df'6}");
    post circleo ("`typer'") ("ses")      
      ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") ("${`depvar'_se`df'3}") 
      ("${`depvar'_se`df'4}") ("${`depvar'_se`df'5}") ("${`depvar'_se`df'6}");
    post circleo ("`typer'") ("parcels")  
      ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}")  ("${`depvar'_n`df'3}")  
      ("${`depvar'_n`df'4}")  ("${`depvar'_n`df'5}")  ("${`depvar'_n`df'6}");
    post circleo ("`typer'") ("stops")    
      ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") ("${`depvar'_sn`df'3}") 
      ("${`depvar'_sn`df'4}") ("${`depvar'_sn`df'5}") ("${`depvar'_sn`df'6}");

    * get rid of largest consistent sample marker *;
    drop vok;
     
    };

  ************ robustness tables: rings *****************;

  if "`tabletype'" == "robustness"
    {;

    * the inner circle which is ommitted from the original treatment circle to form the treatment ring has a radius equal to
     (2 * original control circle radius) - (radius of outer circle (e.g., treatment circle));
    gen rin_`df'_inner  = pestop_min_dist_1  <= (`df'/10) & (pestop_min_dist_1  > (((2*`df')/10)  - ((`df'/10)*(2^.5))));

    * the keep command needs to be kept here because many of the data steps below depend on it already having been done;
    keep if cir_`df'_outer == 1;
    drop if cir_`df'_inner == 1 & rin_`df'_inner ~= 1;

    *** ring code ***;
     
    bysort pestop_id_1 : egen anylarycir_`df'_outer = sum(min_dist_lary < .1);
    replace anylarycir_`df'_outer = 1 if anylarycir_`df'_outer > 0 & anylarycir_`df'_outer ~= .;
    tab anylarycir_`df'_outer;  
    drop if anylarycir_`df'_outer == 1;

    * generate weights based on lot_size such that each inner and outer circle has equal weight in the regression;
    bysort pestop_id_1 : egen ls_weight_numi_`df' = sum(lot_size * rin_`df'_inner); 
    bysort pestop_id_1 : egen ls_weight_numo_`df' = sum(lot_size * cir_`df'_outer * (cir_`df'_inner ~= 1)); 

    gen      ls_weight_`df' = lot_size / ls_weight_numi_`df' if rin_`df'_inner == 1;
    replace  ls_weight_`df' = lot_size / ls_weight_numo_`df' if cir_`df'_outer == 1 & cir_`df'_inner ~= 1;
    drop ls_weight_numi_`df'  ls_weight_numo_`df' ;
    local weight = " [w=ls_weight_`df'] ";

    * drop areas in which the inner or outer circles which have less than 10 parcels;
    * this ensures that there is enough data to make a meaningful comparison between the inner and outer areas;
    * it also avoids cases where there are no observations in the outer, control circle;
    bysort pestop_id_1 : egen testi = sum(rin_`df'_inner); 
    bysort pestop_id_1 : egen testo = sum((rin_`df'_inner ~=1) * cir_`df'_outer);
    drop if testi < 10 | testo < 10;

    * set up variables w/o la railway info *;
    nol_vars, df(`df');
     

    * basic regression *;
    areg  `depvar'_nol_4  rin_`df'_inner `covs'
          `weight'
         if cir_`df'_outer == 1, a(pestop_id_1) cluster(pestop_id_1);
    local `depvar'_b`df'1  = _b[rin_`df'_inner];
    local `depvar'_se`df'1 = _se[rin_`df'_inner];
    local `depvar'_n`df'1  = e(N);

    gen esamp = e(sample);
    gen esamp1 = e(sample);
    gsort pestop_id_1 -esamp1;
    by pestop_id_1: gen unq = _n == 1 & e(sample) == 1;
    count if unq;
    local `depvar'_sn`df'1  : display %6.0fc r(N);
    drop unq;

    *** post the output to the stata file ***;
    post ringer ("`typer'") ("coeffs")   (``depvar'_b`df'1');
    post ringer ("`typer'") ("ses")      (``depvar'_se`df'1');
    post ringer ("`typer'") ("parcels")  (``depvar'_n`df'1');
    post ringer ("`typer'") ("stops")    (``depvar'_sn`df'1');

    * get rid of largest consistent sample marker *;
    drop vok;
     
    };

    ******************************* zoning fixed effects things *******************;

  if "`tabletype'" == "zoningfe"
    {;

    * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
    keep if z_zoningdata == 1;

    * the keep command needs to be kept here because many of the data steps below depend on it 
      already having been done;
    keep if cir_`df'_outer == 1;

    *** replace z_area_fe with z22_fe, when 1922zfe is yes *;
    * this needs to be before the ado command, so it can pick up the zoning fe either for the 
      modern or 1922 zoning *;
    local zfetype "z_area_fe";
    if "`1922zfe'" == "yes"
      {;
      local zfetype "z22_fe";
      };

    *** replace z_area_fe with z13_22_fe when we want 2013 codes in 1922 terms **;
    if "`2013_22zfe'" == "yes"
      {;
      local zfetype "z13_22_fe";
      };

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * then we run six regressions *;

    * 1. regular regression, sample is only cities with zoning defined *;
    areg  `depvar'  cir_`df'_inner 
         $rweight
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . `andif', a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(2);

    * 2. same as 1, but with covariates *;
    areg  `depvar'  cir_`df'_inner `covs'
         $rweight
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . `andif', a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(2);
    * for tabulation at end *;
    gen esamp0=e(sample);

    * 3. no controls, no zoning fixed-effect, but with obs dropped that dont have zone codes in 
         the circle and ring **;
    areg  `depvar'  cir_`df'_inner 
          $rweight
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . & treat_not_identified != 1 `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
    topost, num(3) depvar(`depvar') df(`df') sdigs(2);
    gen sr3=e(sample);

    * 4. 3, but with controsl *;
    areg  `depvar'  cir_`df'_inner `covs'
          $rweight
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . & treat_not_identified != 1 `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
    topost, num(4) depvar(`depvar') df(`df') sdigs(2);

    * 5. zoning fe, no controls;
    areg  `depvar'  cir_`df'_inner 
          $rweight
         if cir_`df'_outer == 1 & vok ==1 & treat_not_identified ~= 1 `andif', 
	 a(`zfetype') cluster(pestop_id_1);
    topost, num(5) depvar(`depvar') df(`df') sdigs(2);
    gen sr5=e(sample);

    * 6. zoning fe, with controls;
    areg  `depvar'  cir_`df'_inner `covs'
         $rweight
         if cir_`df'_outer == 1 & vok ==1 & treat_not_identified ~= 1 `andif', 
	 a(`zfetype') cluster(pestop_id_1);
    topost, num(6) depvar(`depvar') df(`df') sdigs(2);

    *** post the output to the stata file ***;
    * need the double quotes around the macro so we can get the comma into the parcels *;
    post circleo ("`typer'") ("coeffs")  ("${`depvar'_b`df'1}") ("${`depvar'_b`df'2}") ("${`depvar'_b`df'3}") 
    	 	 	     		 ("${`depvar'_b`df'4}") ("${`depvar'_b`df'5}") ("${`depvar'_b`df'6}");
    post circleo ("`typer'") ("ses")     ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") ("${`depvar'_se`df'3}") 
    	 	 	     		 ("${`depvar'_se`df'4}") ("${`depvar'_se`df'5}") ("${`depvar'_se`df'6}");
    post circleo ("`typer'") ("parcels") ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") ("${`depvar'_n`df'3}") 
    	 	 	     		 ("${`depvar'_n`df'4}") ("${`depvar'_n`df'5}") ("${`depvar'_n`df'6}");
    post circleo ("`typer'") ("stops")   ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") ("${`depvar'_sn`df'3}") 
    	 	 	     		 ("${`depvar'_sn`df'4}") ("${`depvar'_sn`df'5}") ("${`depvar'_sn`df'6}");

    * identify obs that are in the set of stops for which we have zoning fe, but we dont
      include the obs when we do regressions with zoning fe *;
    * in the restricted sample with streetcar stop fe (esamp0=1), but not in zoning fe sample *;
    * i think that these are stops where at least one obs is in the estimation sample (esamp==1)*;
    by pestop_id_1: egen zstop = max(esamp);
    label variable zstop "1 if this stop has obs in the zoning fe regressions";
    * then, for the obs that are in estimated stops, but DONT contribute to the estimation, find
      zones *;
    * create types *;
    gen zfe_type = "out";
    replace zfe_type = "drop_inner"  
      if zstop == 1 & esamp0 ==1 & esamp == 0 & cir_`df'_inner == 1;
    replace zfe_type = "drop_outer"
      if zstop == 1 & esamp0 ==1 & esamp == 0 & cir_`df'_outer == 1 & cir_`df'_inner != 1;
    replace zfe_type = "keep_inner"
      if zstop == 1 & esamp0 ==1 & esamp == 1 & cir_`df'_inner == 1;
    replace zfe_type = "keep_outer"
      if zstop == 1 & esamp0 ==1 & esamp == 1 & cir_`df'_outer == 1 & cir_`df'_inner != 1;
    tab zfe_type;
    sort zfe_type;
    by zfe_type: summ $z_measures;

    * original tabs to looking at zoning -- didnt find this helpful *;
    *by zfe_type: tab zn_info;
    * so it seems that these are too confusing to figure out -- too many codes, etc *;
    * maybe mean of zoning characteristics by these four groups *;

    * get rid of largest consistent sample marker *;
    drop vok;

    };


  *********************** zombie zoning test table ********************************;

  if "`tabletype'" == "zombie"
    {;

    * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
    keep if z_zoningdata == 1;

    * the keep command needs to be kept here because many of the data steps below depend on it 
      already having been done;
    keep if cir_`df'_outer == 1;

    * keep only obs where we observe 1922 and 2013 zoning *;
    keep if z22 != "" & z13_22 != "" & z_2013 != "";

    * define instruments *;
    * these are the 1922 categories, collapsed into 4 *;
    local ivzdum "z22_zn4only_fe1 z22_zn4only_fe2 z22_zn4only_fe3 z22_zn4only_fe4";

    * set covs to be the full set so i can get the maximal sample *;
    local covs "$preexstc $othercovs";

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * streetcar stop fe, and zoning fe, separately *;
    * z22_fe != . means that we keep 1922 zoning sample *;

    * this is for the non-instrument regressions *;    
    if "`zombiec'" != "instrument"
      {;

      * 1. no controls *;
      xi: areg  `depvar'  cir_`df'_inner `zombiec'
         $rweight
         if cir_`df'_outer == 1 & vok ==1 `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
      topost, num(1) depvar(`depvar') df(`df') sdigs(3);

      * 2. predecessor covariates *;
      xi: areg  `depvar'  cir_`df'_inner `zombiec' $preexstc 
         $rweight
         if cir_`df'_outer == 1 & vok ==1 & z22_fe != . `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
      topost, num(2) depvar(`depvar') df(`df') sdigs(3);

      * 3. predecessor and descendant covariates *;
      xi: areg  `depvar'  cir_`df'_inner `zombiec' $preexstc $othercovs
         $rweight
         if cir_`df'_outer == 1 & vok ==1 & z22_fe != . `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
      topost, num(3) depvar(`depvar') df(`df') sdigs(3);
      summ `depvar' $rweight if cir_`df'_outer == 1 & cir_`df'_inner != 1 & 
           vok ==1 & z22_fe != . `andif';
      global zdepvarmean : display %8.6f r(mean);

      }; * end of non-instrument call *;


    * this is for the instrument regressions *;
    if "`zombiec'" == "instrument"
      {;

      * 1. no controls *;
      xi: ivregress 2sls  `depvar'  cir_`df'_inner 
      		(`zombieendog' = `ivzdum')
		i.pestop_id_1
      		$rweight
         	if cir_`df'_outer == 1 & vok ==1 & z22_fe != . `andif', 
		cluster(pestop_id_1);
      topost, num(1) depvar(`depvar') df(`df') sdigs(2);

      * 2. predecessor covariates *;
      xi: ivregress 2sls  `depvar'  cir_`df'_inner $preexstc 
      		(`zombieendog' = `ivzdum')
		i.pestop_id_1
      		$rweight
         	if cir_`df'_outer == 1 & vok ==1 & z22_fe != . `andif', 
		cluster(pestop_id_1);
      topost, num(2) depvar(`depvar') df(`df') sdigs(2);

      * 3. predecessor and descendant covariates *;
      xi: ivregress 2sls  `depvar'  cir_`df'_inner $preexstc $othercovs
      		(`zombieendog' = `ivzdum')
		i.pestop_id_1
      		$rweight
         	if cir_`df'_outer == 1 & vok ==1 & z22_fe != . `andif', 
		cluster(pestop_id_1)
		first;	
      topost, num(3) depvar(`depvar') df(`df') sdigs(2);

      * do first stages *;
      foreach j in 
        `zombieendog'
	{;
	areg `j' `ivzdum'
	     	 cir_`df'_inner $preexstc $othercovs
      		 $rweight
		 if cir_`df'_outer == 1 & vok ==1 & z22_fe != . `andif', 
		 absorb(pestop_id_1) cluster(pestop_id_1);
	test `ivzdum';
	local F_`j': display %5.3f r(F);

	* this posts f stats to a file *;	
	post zftests ("`zombieendog'") ("`j'") ("`F_`j''");

	}; * end of first stage loop *;

      }; * end of instrumental variable loop *;


    *** post the output to the stata file ***;
    * need the double quotes around the macro so we can get the comma into the parcels *;
    post zom ("`typer'") ("coeffs")  
    	     ("${`depvar'_b`df'1}") ("${`depvar'_b`df'2}") ("${`depvar'_b`df'3}") ;
    post zom ("`typer'") ("ses")     
    	     ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") ("${`depvar'_se`df'3}"); 
    post zom ("`typer'") ("parcels") 
    	     ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") ("${`depvar'_n`df'3}") ;
    post zom ("`typer'") ("stops")   
    	     ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") ("${`depvar'_sn`df'3}") ;

    * get rid of largest consistent sample marker *;
    drop vok;

    };


  if "`tabletype'" == "simpzone"
    {;

    * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
    keep if z_zoningdata == 1;

    * the keep command needs to be kept here because many of the data steps below depend on it 
      already having been done;
    keep if cir_`df'_outer == 1;

    *** replace z_area_fe with z22_fe, when 1922zfe is yes *;
    * this needs to be before the ado command, so it can pick up the zoning fe either for the 
      modern or 1922 zoning *;
    local zfetype "z_area_fe";
    local zcontrol "i.z_2013";
    if "`1922zfe'" == "yes"
      {;
      local zfetype  "z22_fe";
      local zcontrol "z22_znonly_fe1 z22_znonly_fe2 z22_znonly_fe3 z22_znonly_fe4";
      };

    *** replace z_area_fe with z13_22_fe when we want 2013 codes in 1922 terms **;
    if "`2013_22zfe'" == "yes"
      {;
      local zfetype  "z13_22_fe";
      local zcontrol "z13_22_znonly_fe1 z13_22_znonly_fe2 z13_22_znonly_fe3";
      };

    ** make a extra bit for dependent varible name and wt if we are dropping near la ry **;
    if "`drop_near_lary'" == "yes"
      {;
      local ex "_nol";
      };

    *** replace macro for direct control of zoning based on type ***;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * then we run three regressions *;

    * 1. regular regression, sample is only cities with zoning defined, all covariates *;
    areg  `depvar'`ex'`no4'  cir_`df'_inner $preexstc $othercovs
         ${rweight`ex'`no4'}
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(2);

    * test joint equality of all distance premia *;
    * only useful when we save the log of these runs in gate dist_prem *;
    * define variables of interest *;
    local disto
      "min_dist_dt_pt* min_dist_coast* min_dist_rds1925* min_dist_ints34* min_dist_majrd* 
      min_dist_rail* min_dist_link* min_dist_hwy*";
    foreach gf in `disto'
      {;
      unab gf2: `gf';
      test `gf2';
      };   

    * 2. no zoning fixed-effect, but with obs dropped that dont have zone codes in 
         the circle and ring **;
    areg  `depvar'`ex'`no4'  cir_`df'_inner $preexstc $othercovs
          ${rweight`ex'`no4'}
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . & treat_not_identified != 1 `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(2);

    * test joint equality of all distance premia *;
    * only useful when we save the log of these runs in gate dist_prem *;
    * define variables of interest *;
    foreach gf in `disto'
      {;
      unab gf2: `gf';
      test `gf2';
      };   

    * 3. streetcar stop fe and zoning fe (not interacted), controls, sample as in 1 *;
    xi: areg  `depvar'`ex'`no4'  cir_`df'_inner `zcontrol' $preexstc $othercovs
          ${rweight`ex'`no4'}
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
    topost, num(3) depvar(`depvar') df(`df') sdigs(2);

    * test joint equality of all distance premia *;
    * only useful when we save the log of these runs in gate dist_prem *;
    * define variables of interest *;
    foreach gf in `disto'
      {;
      unab gf2: `gf';
      test `gf2';
      };   

    * 4. streetcar stop fe and zoning fe interacted, controls, sample as in 1 *;
    xi: areg  `depvar'`ex'`no4'  cir_`df'_inner $preexstc $othercovs
          ${rweight`ex'`no4'}
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . `andif', 
	 a(`zfetype') cluster(pestop_id_1);
    topost, num(4) depvar(`depvar') df(`df') sdigs(2);

    * test joint equality of all distance premia *;
    * only useful when we save the log of these runs in gate dist_prem *;
    foreach gf in `disto'
      {;
      unab gf2: `gf';
      test `gf2';
      };   
    
    *** post the output to the stata file ***;
    * need the double quotes around the macro so we can get the comma into the parcels *;
    post zonestat ("`typer'") ("coeffs")  
    	 ("${`depvar'_b`df'1}") ("${`depvar'_b`df'2}") 
	 ("${`depvar'_b`df'3}") ("${`depvar'_b`df'4}") ;
    post zonestat ("`typer'") ("ses")     
    	 ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") 
	 ("${`depvar'_se`df'3}") ("${`depvar'_se`df'4}"); 
    post zonestat ("`typer'") ("parcels") 
	 ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") 
	 ("${`depvar'_n`df'3}") ("${`depvar'_n`df'4}"); 
    post zonestat ("`typer'") ("stops")   
    	 ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") 
	 ("${`depvar'_sn`df'3}") ("${`depvar'_sn`df'4}") ;

    * get rid of largest consistent sample marker *;
    drop vok;

    };  ** end of simple zoning test table **;

  * use and zoning results table *;
  if "`tabletype'" == "useandzoneno4"
    {;
    * the keep command needs to be kept here because many of the data steps below depend on it already having been done;
    keep if cir_`df'_outer == 1;

    * switch if we only want the zoning data sample *;
    if "`zonedvs'" == "yes"
      {;
      * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
      keep if z_zoningdata == 1;
      };

    * save any true covariates in covs2 *;
    local covs2 `covs';

    * set covariates equal to the full set so we get a constant sample *;
    local covs $preexstc $othercovs;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * return covariates to original input *;
    local covs `covs2';

    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/ covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner `covs'
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1  , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway *;
    areg  `depvar'_nol_4  cir_`df'_inner `covs'
          $rweight_nol_4
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);
    summ `depvar'_nol if cir_`df'_outer == 1 & vok == 1 $rweight_nol_4;
 
   * this will post the dep variable mean if we are doing the use and zone run *;
    if "`postname'" == "useandzone"
      {;
      local nol_mean = r(mean);
      local expost `"("`nol_mean'")"';
      };
      
    *** post the output to the stata file ***;
    post `postname' ("`typer'") ("coeffs")   
      ("${`depvar'_b`df'1}")  ("${`depvar'_b`df'2}") `expost';
    post `postname' ("`typer'") ("ses")      
      ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") `expost';
    post `postname' ("`typer'") ("parcels")  
      ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") `expost';
    post `postname' ("`typer'") ("stops")    
      ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") `expost';

    * get rid of largest consistent sample marker *;
    drop vok;

    };  * end of use and zone, omit 4 clusters regression loop *;


  * main results only table *;
  if "`tabletype'" == "summstats"
    {;
    * the keep command needs to be kept here because many of the data steps below depend on 
      it already having been done;
    keep if cir_`df'_outer == 1;

    * switch if we only want the zoning data sample *;
    if "`zonedvs'" == "yes"
      {;
      * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
      keep if z_zoningdata == 1;
      };

    * save any true covariates in covs2 *;
    local covs2 `covs';

    * set covariates equal to the full set so we get a constant sample *;
    local covs $preexstc $othercovs;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    *** calculate summary stats and post *;

    * non-zoning variables *;
    if "`zonedvs'" != "yes"
      {;
      foreach j in $summvarsnz
        {;
        * inner circle *;
        summ `j' $rweight_nol if cir_`df'_inner == 1 & vok == 1, detail;
        local meano : display %5.2f r(mean);
        local sdo : display %5.2f r(sd);
        local obs : display %7.0fc r(N);
        post summer ("inner circle") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
        * outer ring *;
        summ `j' $rweight_nol if cir_`df'_inner != 1 & vok == 1, detail;
        local meano : display %5.2f r(mean);
        local sdo : display %5.2f r(sd);
        local obs : display %7.0fc r(N);
        post summer ("outer ring") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
        };
      };

    * zoning variables -- note that the limit restriction is above the nol_ado call *;
    if "`zonedvs'" == "yes"
      {;
      foreach j in $summvarsz
        {;
        * inner circle *;
        summ `j' $rweight_nol if cir_`df'_inner == 1 & vok == 1, detail;
        local meano : display %5.2f r(mean);
        local sdo : display %5.2f r(sd);
        local obs : display %7.0fc r(N);
        post summer ("inner circle") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
        * outer ring *;
        summ `j' $rweight_nol if cir_`df'_inner != 1 & vok == 1, detail;
        local meano : display %5.2f r(mean);
        local sdo : display %5.2f r(sd);
        local obs : display %7.0fc r(N);
        post summer ("outer ring") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
        };
      };

    * get rid of largest consistent sample marker *;
    drop vok;

    };  * end of summary stats regression loop *;


  if "`tabletype'" == "by_initial_zoning"
    {;

    * here we keep only obs for which zoning info is defined (70% of parcels, 50-ish cities) *;
    keep if z_zoningdata == 1;

    * the keep command needs to be kept here because many of the data steps below depend on it 
      already having been done;
    keep if cir_`df'_outer == 1;

    *** replace z_area_fe with z22_fe, when 1922zfe is yes *;
    * this needs to be before the ado command, so it can pick up the zoning fe either for the 
      modern or 1922 zoning *;
    local zfetype "z_area_fe";
    local zcontrol "i.z_2013";
    if "`1922zfe'" == "yes"
      {;
      local zfetype  "z22_fe";
      local zcontrol "z22_znonly_fe1 z22_znonly_fe2 z22_znonly_fe3 z22_znonly_fe4";
      };

    *** replace z_area_fe with z13_22_fe when we want 2013 codes in 1922 terms **;
    if "`2013_22zfe'" == "yes"
      {;
      local zfetype  "z13_22_fe";
      local zcontrol "z13_22_znonly_fe1 z13_22_znonly_fe2 z13_22_znonly_fe3";
      };

    ** make a extra bit for dependent varible name and wt if we are dropping near la ry **;
    if "`drop_near_lary'" == "yes"
      {;
      local ex "_nol";
      };

    *** replace macro for direct control of zoning based on type ***;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * make additional covariates: treatment by initial zoning of stop *;
    local addcovs "";
    gen cz=1;
    local cz "cz ";
    if "`covs'" != ""
      {;
      replace cz = cir_5_inner*`covs';
      };

    * then we run one regression *;

    * 1. regular regression, sample is only cities with zoning defined, all covariates *;
    areg  `depvar'`ex'`no4'  cir_`df'_inner `cz' $preexstc $othercovs
         ${rweight`ex'`no4'}
         if cir_`df'_outer == 1 & vok ==1 & `zfetype' != . `andif', 
	 a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(2);



    *** post the output to the stata file ***;
    * need the double quotes around the macro so we can get the comma into the parcels *;
    post initialz ("`typer'") ("coeffs")  
    	 ("${`depvar'_b`df'1}") (_b[cz]);
    post initialz ("`typer'") ("ses")     
    	 ("${`depvar'_se`df'1}") (_se[cz]);
    post initialz ("`typer'") ("parcels") 
	 ("${`depvar'_n`df'1}") (_b[cz]);

    * get rid of largest consistent sample marker *;
    drop vok;

    };  ** end of effect by initial zoning table **;

  * bus stop robustness check *;
  if "`tabletype'" == "bus"
    {;
    * the keep command needs to be kept here because many of the data steps below depend on 
      it already having been done;
    keep if cir_`df'_outer == 1;

    * need to keep only stops w/ at least one parcel w/i half a km of a bus stop *;
    bysort pestop_id_1 : egen buscir_`df'_outer = sum(min_dist_busstp <= .5);
    replace buscir_`df'_outer = 1 if buscir_`df'_outer > 0 & buscir_`df'_outer ~= .;
    tab buscir_`df'_outer;  
    keep if buscir_`df'_outer == 1;

    * save any true covariates in covs2 *;
    local covs2 `covs';

    * set covariates equal to the full set so we get a constant sample *;
    local covs $preexstc $othercovs;

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') covs(`covs')
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    * return covariates to original input *;
    local covs `covs2';

    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/ covariates *;
    areg  `depvar'  cir_`df'_inner `covs'
          $rweight
          if cir_`df'_outer == 1 & vok == 1  , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner `covs'
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);
    summ `depvar'_nol if cir_`df'_outer == 1 & cir_`df'_inner != 1 & vok == 1 $rweight_nol;
 
   * this will post the dep variable mean if we are doing the use and zone run *;
    if "`postname'" == "useandzone"
      {;
      local nol_mean = r(mean);
      local expost `"("`nol_mean'")"';
      };
      
    *** post the output to the stata file ***;
    post `postname' ("`typer'") ("coeffs")   
      ("${`depvar'_b`df'1}")  ("${`depvar'_b`df'2}") `expost';
    post `postname' ("`typer'") ("ses")      
      ("${`depvar'_se`df'1}") ("${`depvar'_se`df'2}") `expost';
    post `postname' ("`typer'") ("parcels")  
      ("${`depvar'_n`df'1}") ("${`depvar'_n`df'2}") `expost';
    post `postname' ("`typer'") ("stops")    
      ("${`depvar'_sn`df'1}") ("${`depvar'_sn`df'2}") `expost';

    * get rid of largest consistent sample marker *;
    drop vok;

    };  * end of main regression loop *;

  restore;

end;

}; * end of table gate ado *;

****************** summary stats table ***********************************************;

if `summ_stats' == 1 {;

  *** A. load data ***;

  drop _all;
  xsec_datagate;

  *** B. do stats ***;

  postfile summer str100 typer str100 varname str15(mean sd obs) using 
    ${main_tables}/${date}_summ_stats, replace;

  * non-zoning summary stats variables *;
  local summvarsnz sqft_per_lotsize imp_val_lotsize 
      	       	 non_res multi_fam_r;
  global summvarsnz `summvarsnz';
  * zoning summary stats variables *;
  local summvarsz z_nonres z_max_units z_max_ht_feet z_c_parking;
  global summvarsz `summvarsz';

  * preserve dataset *;
  preserve;

  * 1. summary stats for all parcels *;
  * non-zoning *;
  foreach j in $summvarsnz
    {;
    summ `j', detail;
    return list;
    local meano : display %5.2f r(mean);
    local sdo : display %5.2f r(sd);
    local obs : display %9.0fc r(N);
    local p99 = r(p99);
    post summer ("all parcels") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
    * for the two variables with very long tales, do just lt 99 p *;
    if "`j'" == "sqft_per_lotsize" | "`j'" == "imp_val_lotsize"
      {;
      summ `j' if `j' < `p99', detail;
      local meano : display %5.2f r(mean);
      local sdo : display %5.2f r(sd);
      local obs : display %9.0fc r(N);
      post summer ("all parcels - lt 99 p") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
      };
    };
  * non-zoning *;
  foreach j in $summvarsz
    {;
    summ `j' if z_zoningdata==1, detail;
    local meano : display %5.2f r(mean);
    local sdo : display %5.2f r(sd);
    local obs : display %9.0fc r(N);
    post summer ("all parcels") ("`j'") ("`meano'") ("`sdo'") ("`obs'") ;
    };

  * get back to dropped data *;
  restore; 

  * 2. summary stats for 0 to 0.5 km, 0.5 km to 0.7 km *;
  * non-zoning stuff *;
  circler, tabletype(summstats) depvar(z_c_parking) typer(nada)
	 drop_near_lary(yes);
  * zoning stuff *;
  circler, tabletype(summstats) depvar(z_c_parking) typer(nada)
	 drop_near_lary(yes) zonedvs(yes);

  postclose summer;

  * make a txt file *;
  shell st ${main_tables}/${date}_summ_stats.dta 
  	   ${main_tables}/${date}_summ_stats.txt -y;

}; * end of summary stats gate *;


****************** main results table ***********************************************;

if `main_results' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;

  * set up log file for control mean *;
  log using ${main_chat}/${date}_main_results_control_mean.log, replace;

  * set up stata file for output for regular regressions *;
  postfile tmain str100 typer str25 outtype str15(basic wo_lary) using 
    ${main_tables}/${date}_tmain_regs, replace;

  set trace on;
  set tracedepth 2;

  * panel a, no controls *;
  circler, tabletype(main) depvar(sqft_per_lotsize) typer(no covariates) 
  	   drop_near_lary(no) postname(tmain);

  * panel b, predecessors *;
  circler, tabletype(main) depvar(sqft_per_lotsize) typer(predecessors) 
	   covs($preexstc) drop_near_lary(no) postname(tmain);

  * panel c, descendants *;
  circler, tabletype(main) depvar(sqft_per_lotsize) typer(pred + descendants)  
	   covs($preexstc $othercovs) drop_near_lary(no) postname(tmain);

  postclose tmain;
  
  * make a txt file *;
  shell st ${main_tables}/${date}_tmain_regs.dta
  	   ${main_tables}/${date}_tmain_regs.txt -y;

  * close log;
  capture log close;

}; * end of main results gate *;




***** robustness table ***********************************************;

if `robustness_table' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;


  * set up stata file for output for regular regressions *;
  postfile robusto str100 typer str25 outtype str15(basic pred pandd) using 
    ${main_tables}/${date}_robustness_regs, replace;

  set trace on;
  set tracedepth 2;

  * each call does three regressions: no controls, predecessors, descendants *;

  * note that you need to put the _nol suffix directly into the call here to get all of these to work *;

  * using only post-1963 structures *;
  circler, tabletype(robusto) depvar(sqft_per_lotsize_nol) 
	 typer(only post-1963, no la ry) 
	 drop_near_lary(yes)
	 post_1963(yes);

  * limiting sample to only cities w/o any people before streetcar era *;
  * see excel sheet at 
    /groups/brooksgrp/zoning/streetcar_stops/sanborn_fire_insurance_map_dates/
    2014-12-11_la_cnty_list_of_cities_incl_extinct_ones.xlsx *;
  circler, tabletype(robusto) depvar(sqft_per_lotsize_nol) 
  	 typer(drop cities w/ pre-streetcar pop)
  	 drop_near_lary(yes) ringer(drop_no_pop_cities);

  * omitting stop clusters *;
  circler, tabletype(robusto) depvar(sqft_per_lotsize_nol_4) 
	 typer(omits 5 stop clusters, no la ry) 
	 drop_near_lary(yes);

  * using only a treatment ring *;
  * this one must go last, b/c it modifies the data -- not sure this is true w/ preserve*;
  circler, tabletype(robusto) depvar(sqft_per_lotsize_nol) 
	 typer(treatment ring, not circle, no la ry) 
	 drop_near_lary(yes) ringer(yes);

  * using structure value/lot size *;
  circler, tabletype(robusto) depvar(imp_val_lotsize_nol) 
	 typer(dv is structure value/ lot size, no la ry) 
	 drop_near_lary(yes);

  postclose robusto;

  * make a txt file *;
  shell st ${main_tables}/${date}_robustness_regs.dta
  	   ${main_tables}/${date}_robustness_regs.txt -y;

}; * end of robustness table *;


****** zoning dv variables table ******************************;

if `zoning_as_dv' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;

  * set up stata file for output for regular regressions *;
  postfile useandzone str100 typer str25 outtype str15(basic wolary dv_nol_mean) using 
    ${main_tables}/${date}_use_and_zone_regs, replace;

  * this does two regressions per dv *;
  * we really only need one, but we can just drop it from the table *;
  * it says drop_near_lary = no, but it does in the second regression *;

  set trace on;
  set tracedepth 2;

  * use is non-res *;
  circler, tabletype(main) depvar(non_res) typer(dv is res, pred + descendants)  
	 covs($preexstc $othercovs) drop_near_lary(no) postname(useandzone);

  * use is mf, among res properties *;
  circler, tabletype(main) depvar(multi_fam_r) typer(dv is mf, pred + descendants)  
	 covs($preexstc $othercovs) drop_near_lary(no) postname(useandzone);

  * zoned non-residential *;
  circler, tabletype(main) depvar(z_nonres) typer(dv is zn non-res, pred + descendants)  
	 covs($preexstc $othercovs) drop_near_lary(no) zonedvs(yes) postname(useandzone);

  * zoned max # of units, residential only *;
  circler, tabletype(main) depvar(z_max_units) typer(dv is zn max units, pred + descendants)  
	 covs($preexstc $othercovs) drop_near_lary(no) zonedvs(yes) postname(useandzone);

  * zoned max height in feet *;
  circler, tabletype(main) depvar(z_max_ht_feet) typer(dv is max ht ft, pred + descendants)  
	 covs($preexstc $othercovs) drop_near_lary(no) zonedvs(yes) postname(useandzone);

  * zoned min # of covered parking spaces *;
  circler, tabletype(main) depvar(z_c_parking) typer(dv is min covd parking, pred + descendants)  
	 covs($preexstc $othercovs) drop_near_lary(no) zonedvs(yes) postname(useandzone);

  postclose useandzone;

  * make a txt file *;
  shell st ${main_tables}/${date}_use_and_zone_regs.dta
  	   ${main_tables}/${date}_use_and_zone_regs.txt -y;


}; * this closes the zoning as dv table *;

******* zoning explains results table ***********************************;

if `zoning_explains' == 1 {'

  * load data *;
  drop _all;
  xsec_datagate;

  * set up stata file for output for regular regressions *;
  postfile zonestat str100 typer str25 outtype str15(zsamp overlap zcontrol zbyssfe) using 
        ${main_tables}/${date}_zone_explain_regs, replace;

 * all runs are coded to run only w/o obs near la railway *;
  * we do 3 regressions per call:
    1. full zoning sample
    2. zoning sample only w/o zone codes in treatment and control
    3. full zoning sample, controlling for zone code 
  *;

  set trace on;
  set tracedepth 1;

  *** regular sample ***;

  ** w/o la ry obs **;

  * do all obs *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(full zoning sample, no la ry) 
	 drop_near_lary(yes);

  * parcels with post-1963 *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(only post-1963, no la ry) 
	 drop_near_lary(yes)
	 post_1963(yes);

  *** w/ 1922 zoning sample ***;

  * do all obs *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(1922 zoning sample, modern zoning)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no);

  *** historical zoning ***;

  ** historical zoning obs with modern zoning **;

  * controlling for 1922 zoning *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(1922 zoning w/ mod zon info sample, 1922 zoning, > 6 km frm dt)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 1922zfe(yes)
	 andif(& z_area_fe != .);

  * controlling for modern zoning in 1922 terms *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(1922 zoning sample w/ mod zon info sample, 2013 zoning in 1922 terms)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .);

  ** all obs w/ historical zoning **;
  ** these last two are just for reference, not for the paper table **;

  * controlling for 1922 zoning *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(1922 zoning sample, 1922 zoning, > 6 km frm dt)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 1922zfe(yes)
	 drop_near_lary(no);

  * controlling for modern zoning in 1922 terms *;
  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(1922 zoning sample, 2013 zoning in 1922 terms)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 2013_22zfe(yes)
	 drop_near_lary(no);

  postclose zonestat;

  * make a txt file *;
  shell st ${main_tables}/${date}_zone_explain_regs.dta
  	   ${main_tables}/${date}_zone_explain_regs.txt -y;


}; * closes the zoning explains results table *;
*/

************* zombie zoning ******************************************;

if `zombie_zoning' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;

  * for each set, we want streetcar stop * zoning fe 
        	   	    and streetcar stop and zoning fe (not interacted) *;

  * define output file *;
  * set up stata file for output for regular regressions *;
  postfile zom str100 typer str25 outtype str15(zas_nc zas_wp zas_wpd) using 
        ${main_tables}/${date}_zombie_test_regs, replace;

  local i = 6;

  set trace on;
  set tracedepth 1;

  * this saves dv means from regression *;
  postfile zomznout str100 dv str50 dvmean using 
    ${main_tables}/${date}_zombie_dv_means, 
    replace;

  * zoned non-res in 1922 as dep var *;
  circler, tabletype(zombie) depvar(nresz22) 
	 typer(non-res in 1922, area w/ 1922 la zones, > `i' km frm dt) 
         covs($preexstc $othercovs) drop_near_lary(no) old_zone_only(yes)
	 exclude_dt(yes) dt_dist(`i');
  * post dependent variable mean *;
  post zomznout ("nresz22") ("$zdepvarmean");

  * zoning code change 1922 to 2013 *;
  circler, tabletype(zombie) depvar(z_1922_ch) 
	 typer(change in zn 1922 to 2013, area w/ 1922 la zones, > `i' km frm dt) 
         covs($preexstc $othercovs) drop_near_lary(no) old_zone_only(yes)
	 exclude_dt(yes) dt_dist(`i');
  * post dependent variable mean *;
  post zomznout ("z_1922_ch") ("$zdepvarmean");

  * zoning not C in 1922, but is C or D in 2013 *;
  circler, tabletype(zombie) depvar(z_1922_ch_to_C) 
	 typer(zn in 1922 ne C, zn in 2013 eq 3, area w/ 1922 la zones, > `i' km frm dt) 
         covs($preexstc $othercovs) drop_near_lary(no) old_zone_only(yes)
	 exclude_dt(yes) dt_dist(`i');
  * post dependent variable mean *;
  post zomznout ("z_1922_ch_to_C") ("$zdepvarmean");

  postclose zomznout;

  postclose zom;

  * make a txt file *;
  shell st ${main_tables}/${date}_zombie_test_regs.dta
  	   ${main_tables}/${date}_zombie_test_regs.txt -y;

  shell st ${main_tables}/${date}_zombie_dv_means.dta
    	   ${main_tables}/${date}_zombie_dv_means.txt -y;


}; * end of zombie zoning table *;


*************** agglomeration table ***********************************;

if `agglomeration' == 1 {;

  *** part a ***;

  * done elsewhere in this program *;

  *** part b ***;

  do agg_in_overall_v01.do;

}; * end of agglomeration table *;


*************** prices table ***********************************;

if `prices' == 1 {;

  * call do file in separate program *;
  do price_regs_v05.do;

}; * end of prices table *;


***********************************************************************************;
************ figure: main results in picture form *********************************;
***********************************************************************************;


***********************************************************************************;
***********************************************************************************;
************************* APPENDIX ************************************************;
***********************************************************************************;
***********************************************************************************;

***********************************************************************************;
************ appendix figure: la population over time *****************************;
***********************************************************************************;

if `gate_population_over_time' == 1 {;

  ** original program is 
     /home/lfbrooks/zoning/streetcars/stataprg/population_pictures/poppicsv02.do *;

  *** 1. load data ***;

  * source notes for this are in excel file by same name *;
  drop _all;
  use /groups/brooksgrp/zoning/streetcar_stops/los_angeles_population_over_long_time/assembled_data/2012-09-14_la_cnty_and_c3ities_pop_1850_2000.dta;


  ****** 2. fix data  ****************88************************************;

  gen lacnty_1000s = county_losangeles / 1000;
  format lacnty_1000s %12.0gc;
  gen lacity_1000s = city_losangeles / 1000;
  format lacnty_1000s %12.0gc;


  ***** 3. make pictures **************************************************;

  graph set eps orientation landscape;

  *** 1890 to 1950 ***;
  graph twoway
       (scatter lacnty_1000s year if year >= 1890 & year <= 1950,
        msymbol(Oh)
        connect(l)
        ytitle("Population in 1,000s"))

       (scatter lacity_1000s year if year >= 1890 & year <= 1950,
        connect(l)),

       legend(off)
       xtitle("")
       xlabel(1890 (10) 1950)
       text(3000 1930 "Los Angeles County")
       text(1000 1940 "City of Los Angeles")
       xsize(11) ysize(8.5);


  graph export "${figout}/appendix/${date}_cnty_city_pop_1890to1950.eps", replace; 

  shell convert -density 600 
      ${figout}/appendix/${date}_cnty_city_pop_1890to1950.eps
      ${figout}/appendix/${date}_cnty_city_pop_1890to1950.jpg;


}; * end of gate_population_over_time *;

***********************************************************************************;
************ appendix figure: streetcar ridership over time ***********************;
***********************************************************************************;

if `gate_ridership_over_time' == 1 {;

  ** original file is 
     /home/lfbrooks/zoning/streetcars/stataprg/ridership_pictures/ridershipfigsv09.do *;

  **** 1. load data *****;

  * these data are created in 
  /home/lfbrooks/zoning/streetcars/stataprg/ridership_pictures/ridershipfigsv09.do
  end of step b
  *;

  drop _all;
  use 
  /groups/brooksgrp/zoning/streetcar_stops/stata_output/restat_paper_tables/data/20170803_ridership_data.dta;

  **** 2. make picture *****;

  ** passengers per capita, pacific electric left axis, la ry right axis **;

  * without state totals *;
  graph twoway
    (connected pass_pc12 year if year >= 1910 & year <= 1939, yaxis(1) mcolor(cranberry) lcolor(cranberry))
    (connected pass_pc10 year if year >= 1910 & year <= 1939, yaxis(2) mcolor(gold) lcolor(gold)),
    xscale(range(1910 1940))
    yscale(range(0 300) axis(2))
    ylabel(0(100)300, axis(2))
    ytitle("Pacific Electric rides per capita", axis(1))
    ytitle("LA Railway rides per capita", axis(2))
    text(60 1936 "LA Railway")
    text(40 1925 "Pacific Electric")
    xtitle("")
    legend(off)
    xsize(11) ysize(8.5);

  graph export "${figout}/appendix/${date}_percapita_ridership_pe_adj_and_lary.eps",
    replace;

  shell convert -density 600 
      ${figout}/appendix/${date}_percapita_ridership_pe_adj_and_lary.eps
      ${figout}/appendix/${date}_percapita_ridership_pe_adj_and_lary.jpg;

}; * end of gate_ridership_over_time *;


***********************************************************************************;
************ appendix figure: raw data: income vs distance to streetcar ***********;
***********************************************************************************;


if `gate_income_by_distance' == 1 {;

  * full program is 
    /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
    cons1940tractpicsv12.do *;


  *** 0. load data *****;
  
  drop _all;
  use ${figure_data};

  *** 1. picture ado ***;

  capture program drop picup3;
  program define picup3;

    syntax, yearrange(string)
          yvar(string) yvardescp(string) ymax(string) yranger(string)
          xvar(string) xvarname(string) xvardescp(string) [iffer(string) ifname(string)];

    foreach year in `yearrange'
      {;
      lowess `yvar'_`year' `xvar', generate(lowess_p) bwidth(0.4);
      twoway
        (scatter `yvar'_`year' `xvar' if `yvar'_`year' <= `ymax' `iffer', msymbol(p))
        (scatter lowess_p      `xvar' if `yvar'_`year' <= `ymax' `iffer', msymbol(p)),
        subtitle(`year')
        legend(off)
        ytitle("`yvardescp'")
        xtitle("kilometers to streetcar")
        ylabel(`yranger')
        name(d`year'`yvar'`xvarname');
      global c2 $c2 d`year'`yvar'`xvarname';
      drop lowess_p;
      };

  end;
 
  *** 2. wrapper ado ***;

  capture program drop wrapper2;
  program define wrapper2;

  syntax, yearrange(string)
          yvar(string) yvardescp(string) ymax(string) yranger(string)
          xvar(string) xvarname(string)
          outname(string) outsubdir(string);

    global c2;
    set trace on;
    set tracedepth 1;
    picup3, yearrange(`yearrange')
          yvar(`yvar') yvardescp(`yvardescp') ymax(`ymax') yranger(`yranger')
          xvar(`xvar') xvarname(`xvarname') xvardescp(ok)
          iffer(& min_dist_any_scar <= 3);

    graph combine $c2,
      xcommon ycommon
      xsize(11) ysize(8.5);

    graph export 
      "${figout}/appendix/${date}_`outname'_vs_`xvarname'.eps",
      replace;

    shell convert -density 600 
      ${figout}/appendix/${date}_`outname'_vs_`xvarname'.eps
      ${figout}/appendix/${date}_`outname'_vs_`xvarname'.jpg;

  end;

  *** 3. graph things ***;

  ** share of ppl w/ income le median **;
  wrapper2, yearrange(1950 1960 1970 1990 2000 2010)
         yvar(cvar11_1) yvardescp(shr w/ income <= median) ymax(1) yranger(0(0.5)1)
         xvar(min_dist_any_scar) xvarname(min_dist_any_scar)
         outname(shr_inc_le_median) outsubdir(1940_consistent_tracts_demographics);

}; * end of gate_income_by_distance *;


***********************************************************************************;
************ appendix figure: raw data: density w/o la railway ********************;
***********************************************************************************;

if `gate_density_wo_lar' == 1 {;

  * full program is 
    /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
    cons1940tractpicsv12.do *;

  *** 1. load data *****;
  
  drop _all;
  use ${figure_data};

  * density w/o la railway obs *;
  * this does density by distance to any streetcar, but omits parcels w/i 0.5 km of the 
    la railway *;

  *** 2. make picture ***;

  local dvar scno05_mn_cvar1_1_2010;
    
    lowess `dvar' min_dist_any_scar_scno05, generate(lowess_p) bwidth(0.4);
    twoway
      (scatter `dvar'	  min_dist_any_scar_scno05 
      	       if scno05_mn_cvar1_1_2010 <= 10 & min_dist_any_scar_scno05 <= 6, msymbol(p))
      (scatter lowess_p   min_dist_any_scar_scno05 
      	       if scno05_mn_cvar1_1_2010 <= 10 & min_dist_any_scar_scno05 <= 6, msymbol(p)),
      legend(off)
      ytitle("1000s of people per sq km")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

  graph export 
    "${figout}/appendix/${date}_density_nolary_wi0p5km.eps",
      replace;

  shell convert -density 600 
      ${figout}/appendix/${date}_density_nolary_wi0p5km.eps
      ${figout}/appendix/${date}_density_nolary_wi0p5km.jpg;

}; * end of gate_density_wo_lar *;



***********************************************************************************;
************ appendix figure: raw data: 1930 density vs streetcar *****************;
***********************************************************************************;

if `gate_1930_only' == 1 {;

  * full program is in 
    /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
    carhistdenspicsv10.do *;

  ****** 1. load data ***;

  * these data are created in
    /href/brooks/home/jessicah/zoning/sasprg/adddensityv16.sas;

  use /groups/brooksgrp/zoning/streetcar_stops/parcel_level_datasets/historical_population_densities/aggregate_densities_for_plotting/density_1930to2000_20121030;

  ***** 2. make pictures *****;

  lowess density_1930 min_dist_sc, generate(lowess_p) bwidth(0.4);
  twoway
    (scatter density_1930 min_dist_sc if density_1930 <= 10 & min_dist_sc <= 3, msymbol(p))
    (scatter lowess_p     min_dist_sc if density_1930 <= 10 & min_dist_sc <= 3, msymbol(p)),
    subtitle(1930)
    legend(off)
    ytitle("1000s ppl/sq km")
    xtitle("kilometers to streetcar")
    ylabel(0(5)10)
    ysize(8.5)
    xsize(11);

  graph export
    "${figout}/appendix/${date}_1930density_vs_min_dist_scar.eps",
    replace;
  drop lowess_p;

  shell convert -density 600 
      ${figout}/appendix/${date}_1930density_vs_min_dist_scar.eps
      ${figout}/appendix/${date}_1930density_vs_min_dist_scar.jpg;

}; * end of raw data: 1930 density vs streetcar *;


***********************************************************************************;
************ appendix table: density by bins **************************************;
***********************************************************************************;

if `gate_dist_bands' == 1 {;

  **** 1. load data ****************************;

  * this part is based on 
    /home/lfbrooks/zoning/streetcars/stataprg/assa_2014_tables/assa_jan14_tables_v04.do    

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  **** 2. set up some data stuff ************;

  ** keep only obs w/i 3 km to be consistent with other pictures *;
  keep if pestop_min_dist <= 3;

  * make 0.1 km distance dummies *;
  local i=1;
  forvalues d=0(0.1)5.9
    {;
    local dd = `d' + 0.1 ;
    gen scar_dist_p1bin`i' = 0;
    replace scar_dist_p1bin`i' = 1 if pestop_min_dist_1 > `d' & pestop_min_dist_1 <= `dd';
    label variable scar_dist_p1bin`i' 
      "1 if pestop_min_dist_1 is > `d' km & < `dd' from streetcar stop ";
    local i = `i' + 1;
    };

  * make 0.2 km distance dummies *;
  local i = 1;
  forvalues d=0(0.2)3
    {;
    local dd = `d' + 0.2 ;
    gen scar_dist_p2bin`i' = 0;
    replace scar_dist_p2bin`i' = 1 if pestop_min_dist_1 > `d' & pestop_min_dist_1 <= `dd';
    label variable scar_dist_p2bin`i' 
      "1 if pestop_min_dist_1 is > `d' km & < `dd' from streetcar stop ";
    summ pestop_min_dist_1 if scar_dist_p2bin`i' == 1;
    local i = `i' + 1;
    };

  * make 0.3 km distance dummies *;
  local i = 1;
  forvalues d=0(0.3)5.9
    {;
    local dd = `d' + 0.3 ;
    gen scar_dist_p3bin`i' = 0;
    replace scar_dist_p3bin`i' = 1 if pestop_min_dist_1 > `d' & pestop_min_dist_1 <= `dd';
    label variable scar_dist_p3bin`i' 
      "1 if pestop_min_dist_1 is > `d' km & < `dd' from streetcar stop ";
    local i = `i' + 1;
    };
  * find largest consistent sample *;
  gen vok=1;
  foreach j in
    sqft_per_lotsize pestop_min_dist_1 ln_min_dist_pestops
    min_dist_pelines min_dist_pelines2 min_dist_pelines3
    $preexstc $othercovs
    min_dist_rds1925 min_dist_rds19252 min_dist_rds19253
    {;
    replace vok = 0 if `j' == .;
    };


  ****** weights so that each stop gets equal weight ***;

  * generate weights based on lot_size so that each streetcar stop has equal weight in regression *;
  bysort pestop_id_1 : egen ls_weight_d = sum(lot_size);
  gen    ls_weight = lot_size / ls_weight_d;
  global lweight = " [w=ls_weight] ";

  * drop stops w/o at least 10 obs -- this is to be sort of parallel with the other
      regressions *;
  bysort pestop_id_1 : egen test = count(lot_size);
  *tab test;
  drop if test < 10;
  drop test;


  **** 3. log by distance dummies, plot? *******;

  graph set eps orientation landscape;

  * set up a postfile *;
  *postfile linpicout 
      str25 type str25 dv distance b se 
      using ${main_chat}/${date}_linear_regs, replace;

  * make a little ado to do different flavors *;
  capture program drop linpic;
  program define linpic;

    syntax, maxdist(string) [depvar(string) covars(string) name(string)];

    * regression *;
    areg `depvar' scar_dist_p1bin1-scar_dist_p1bin9 `covars' $lweight
      if vok == 1 & pestop_min_dist_1 <= `maxdist', 
      absorb(pestop_id_1) cluster(pestop_id_1);

    * output each coefficient as a row *;
    forvalues d=1/9
      {;
      local dd = `d'/10;
      post linpicout
        ("`name'") ("`depvar'") (`dd') (_b[scar_dist_p1bin`d']) (_se[scar_dist_p1bin`d']);
      };

  end;

  *** run the regressions ***;
  * nada *;
  *linpic, maxdist(1) depvar(sqft_per_lotsize) name(no_covars);
  * p only *;
  *linpic, maxdist(1) depvar(sqft_per_lotsize) name(P) covars($preexstc);
  * p and d *;
  *linpic, maxdist(1) depvar(sqft_per_lotsize) name(PD) covars($preexstc $othercovs);
  * p and d *;
  *linpic, maxdist(1) depvar(ln_sqft_per_lotsize) name(PD) covars($preexstc $othercovs);

  * close the postfile *;
  *postclose linpicout;

  **** 4. make the coefficients together picture ***;
    
  * load the coefficient data *;
  preserve;
  drop _all;
  use ${main_chat}/${date}_linear_regs;

  * make error bars *;
  gen ci_hi = b + 1.94*se;
  gen ci_lo = b - 1.94*se;

  * make and output a picture *;
  twoway
     (rarea ci_hi ci_lo distance if distance <= 1 & type == "PD" & dv == "sqft_per_lotsize", 
       bcolor(gs14))
     (connected b distance if distance <= 1 & type == "PD" & dv == "sqft_per_lotsize", 
       lcolor(cranberry) mcolor(cranberry))
     (connected b distance if distance <= 1 & type == "P" & dv == "sqft_per_lotsize", 
       lcolor(green) mcolor(green))
     (connected b distance if distance <= 1 & type == "no_covars" & dv == "sqft_per_lotsize", 
       lcolor(midblue) mcolor(midblue)),
     ytitle("coefficient on distance to streetcar")
     xtitle("kilometers to streetcar stop")
     text(26 0.37 "red line:")
     text(24 0.37 "{it:P} and {it:D} controls")
     text(7  0.2 "blue line: no covariates")
     text(11 0.85 "green line:")
     text(9 0.85 "controls for {it:P}")
     legend(off)
     xsize(11)
     ysize(8.5);
  graph export "${figout}/appendix/${date}_bands_sqft_all3.eps", replace;
  shell convert -density 600 
      ${figout}/appendix/${date}_bands_sqft_all3.eps
      ${figout}/appendix/${date}_bands_sqft_all3.jpg;
  
}; * end of distance bin gate *;


*************************************************************************
********** referee request: check if robust to adding dist to line ******
*************************************************************************;

if `add_line' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;

  * set up stata file for output for regular regressions *;
  postfile tmain str100 typer str25 outtype str15(basic wo_lary) using 
    ${app_tables}/${date}_main_spec_w_line_dist, replace;

  set trace on;
  set tracedepth 2;

  * panel a, no controls *;
  circler, tabletype(main) depvar(sqft_per_lotsize) typer(no covariates) 
  	   drop_near_lary(no) postname(tmain);

  * panel b, predecessors *;
  circler, tabletype(main) depvar(sqft_per_lotsize) typer(predecessors) 
	   covs($preexstc min_dist_pelines) drop_near_lary(no) postname(tmain);

  * panel c, descendants *;
  circler, tabletype(main) depvar(sqft_per_lotsize) typer(pred + descendants)  
	   covs($preexstc $othercovs min_dist_pelines) drop_near_lary(no) postname(tmain);

  postclose tmain;
  
  * make stata file into text file *;
  shell st 
    ${app_tables}/${date}_main_spec_w_line_dist.dta
    ${app_tables}/${date}_main_spec_w_line_dist.txt -y;

}; * end of -add line- gate *;


*************************************************************************
********** referee request: log/log est w/ dist to line *****************
*************************************************************************;

if `gate_control_line' == 1 {;

  **** 1. load data ****************************;

  * this part is based on 
    /home/lfbrooks/zoning/streetcars/stataprg/assa_2014_tables/assa_jan14_tables_v04.do    

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  **** 2. set up some data stuff ************;

  * find largest consistent sample *;
  gen vok=1;
  foreach j in
    sqft_per_lotsize pestop_min_dist_1 ln_min_dist_pestops
    min_dist_pelines min_dist_pelines2 min_dist_pelines3
    $preexstc $othercovs
    min_dist_rds1925 min_dist_rds19252 min_dist_rds19253
    ln_sqft_per_lotsize
    {;
    replace vok = 0 if `j' == .;
    };

  * make logs of distance to pe line *;
  gen ln_min_dist_pelines = .;
  replace ln_min_dist_pelines = ln(min_dist_pelines) if min_dist_pelines != 0;
  forvalues j=2/3
    {;
    gen ln_min_dist_pelines`j' = ln_min_dist_pelines ^ `j';
    };

  **** 3. log-log regression *******************;

  * make a little ado to do different flavors *;
  capture program drop linregs;
  program define linregs;

    syntax, [depvar(string) ivar(string) covars(string) name(string) eno(string)
    	     lncovs(string)];

    di "*********** regression : `name' ******************************";

    local meano : display %5.2f r(mean);
    local sdo : display %5.2f r(sd);
    local obs : display %9.0fc r(N);


    regress sqft_per_lotsize pestop_min_dist_1 `covars' if vok == 1,
      cluster(pestop_id_1); 
    tab pestop_id_1 if e(sample) == 1;
    estadd scalar stops1 = r(r);
    estimates store lin_`eno';

    regress ln_sqft_per_lotsize ln_min_dist_pestops `lncovs' if vok == 1,
      cluster(pestop_id_1);
    tab pestop_id_1 if e(sample) == 1;
    estadd scalar stops1 = r(r);
    estimates store ln_`eno';

  end;

  * do the regressions *;

  * log it *;
  capture log close;
  log using ${main_chat}/${date}_control_for_line_distance_regs.log, replace;

  * truly unconditional *;
  linregs, eno(1) name(unconditional);
  * controlling for distance to the line *;
  linregs, eno(2) name(unconditional w/ lines)    covars(min_dist_pelines)
           lncovs(ln_min_dist_pelines);
  * conditional only on pre-existing covariates *;
  linregs, eno(3) name(conditional on pre-exist)  covars(min_dist_pelines $preexstc)
    	   lncovs(ln_min_dist_pelines $preexstc);
  * conditional on everything we can measure *;
  linregs, eno(4) name(conditional on everything) covars(min_dist_pelines $preexstc $othercovs)
           lncovs(ln_min_dist_pelines $preexstc $othercovs);
  * conditional on everything, quadratic in line *;
  linregs, eno(5) name(conditional on everything, q line) 
    	   covars(min_dist_pelines* $preexstc $othercovs)
	   lncovs(ln_min_dist_pelines* $preexstc $othercovs);

  * estimates out *;
  estout lin_1 lin_2 lin_3 lin_4 lin_5 ln_1 ln_2 ln_3 ln_4 ln_5 using
    ${main_chat}/${date}_regs_w_line_distance.txt, 
           replace label varwidth(12)
       cells(b(fmt(%9.3f)) se(par fmt(%9.3f))) 
       stats(r2 N stops1, 
         fmt(%9.3f %9.0g %9.3f ) 
         labels("R-squared" "Obs" "stops" ));
    estimates clear;

   ;

  log close;

}; * end of gate that has distance linearly and controls for line;


*************************************************************************
********** referee request: semi-param estimate for ref 2 ***************
*************************************************************************;

if `gate_non_param_est' == 1 {;

  ***** A. load data *******************************************;

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  ***** B. some data prep *************************************;

  ****** weights so that each stop gets equal weight ***;

  ** keep only obs w/i 3 km to be consistent with other pictures *;
  keep if pestop_min_dist <= 3;

  * generate weights based on lot_size so that each streetcar stop has equal weight in regression *;
  bysort pestop_id_1 : egen ls_weight_d = sum(lot_size);
  gen    ls_weight = lot_size / ls_weight_d;
  global lweight = " [w=ls_weight_`df'] ";

  * drop stops w/o at least 10 obs -- this is to be sort of parallel with the other
      regressions *;
  bysort pestop_id_1 : egen test = count(lot_size);
  *tab test;
  drop if test < 10;
  drop test;

  * find largest consistent sample *;
  gen vok=1;
  foreach j in
    sqft_per_lotsize pestop_min_dist_1 ln_min_dist_pestops
    min_dist_pelines min_dist_pelines2 min_dist_pelines3
    $preexstc $othercovs
    min_dist_rds1925 min_dist_rds19252 min_dist_rds19253
    {;
    replace vok = 0 if `j' == .;
    };

  ****** C. ado to do semiparametric estimation *************;

  * documentation for this command is 
    http://www.stata-journal.com/sjpdf.html?articlenum=st0278 *;

  capture program drop respic;
  program define respic;

    syntax, [covs(string) noscatter(string) gextra(string)];

    ***** C.1 do semipar regression ********************;

    * regression *;
** cant do this with a gaussian kernel and weights ***;
    semipar sqft_per_lotsize `covs' if vok == 1,
      nograph nonpar(pestop_min_dist_1) degree(3) generate(sp1) 
      cluster(pestop_id_1);

    * plots *;
    * dont do them above b/c it plots all the points and thats a mess *;
** cant do this with a gaussian kernel and weights ***;
    lpolyci sp1 pestop_min_dist_1, degree(3);

    * export *;
    graph export "${figout}/appendix/semiparametric_estimation/${date}_test.eps", replace;

    * make a jpg *;
    *shell convert -density 600 
      ${figout}/appendix/${date}_semipar_`namer'.eps
      ${figout}/appendix/${date}_semipar_`namer'.jpg;
  
    * drop residual calculation *;
    drop nonp_res;

  end;


  ****** D. run this with variations ***************************;

    semipar sqft_per_lotsize min_dist_dt_pt if vok == 1,
      nograph nonpar(pestop_min_dist_1) degree(3) generate(sp1) 
      cluster(pestop_id_1);

    * plots *;
    * dont do them above b/c it plots all the points and thats a mess *;
** cant do this with a gaussian kernel and weights ***;
    lpolyci sp1 pestop_min_dist_1, degree(3);

    * export *;
    graph export "${figout}/appendix/semiparametric_estimation/${date}_test.eps", replace;

  ** ss fixed effects only **;
  *respic, covs($preexstc);

  ** p controls **;
  *respic, ytit(density, conditional on SS FE and {it:P})
  	  noscatter(noscatter)
  	  covs($preexstc)
	  namer(wPonly);

  ** p + d controls **;
  *respic, ytit(density, conditional on SS FE, {it:P} and {it:D})
  	  noscatter(noscatter)
  	  covs($preexstc $othercovs)
	  namer(wPD);

  ** how about lines, too? **;
  *respic, ytit(density, conditional on FE, {it:P}, {it:D} and dist to line)
  	  noscatter(noscatter)
  	  covs($preexstc $othercovs min_dist_pelines)
	  namer(wPDandlinedist);

}; * end of gate that does semiparametric estimation *;


*************************************************************************
********** referee request: other density premia robust to zoning? ******
*************************************************************************;

if `cbd_prem_w_zoning' == 1
  {;
 
  ***** A. load data ********************************************;

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  capture log close;
  log using ${main_chat}/${date}_cbd_coeff_cond_zoning.log, replace;


  ***** B. establish cbd density premium ********************************;

  di "**************** A. basic premium *******************************";
  regress sqft_per_lotsize min_dist_dt_pt, cluster(pestop_id_1);

  ***** C. add zoning ***************************************************;

  di "**************** B. 2013 zoning *******************************";

  * 2013 zoning *;
  regress sqft_per_lotsize min_dist_dt_pt if z_match_code_1 != "", 
    cluster(pestop_id_1);
  areg sqft_per_lotsize min_dist_dt_pt, 
    absorb(z_match_code_1) cluster(pestop_id_1);
  areg sqft_per_lotsize min_dist_dt_pt $preexstc $othercovs, 
    absorb(z_match_code_1) cluster(pestop_id_1);

  di "**************** C. 1922 zoning *******************************";

  * 1922 zoning *;
  regress sqft_per_lotsize min_dist_dt_pt if z22 != "", 
    cluster(pestop_id_1);
  areg sqft_per_lotsize min_dist_dt_pt, absorb(z22) cluster(pestop_id_1);
  areg sqft_per_lotsize min_dist_dt_pt $preexstc $othercovs, 
    absorb(z22) cluster(pestop_id_1);

  di "**************** D. 2013 zoning in 1922 terms *******************************";

  * 2013 zoning in 1922 terms *;
  regress sqft_per_lotsize min_dist_dt_pt if z13_22 != "", 
    cluster(pestop_id_1);
  areg sqft_per_lotsize min_dist_dt_pt, absorb(z13_22) cluster(pestop_id_1);
  areg sqft_per_lotsize min_dist_dt_pt $preexstc $othercovs, 
    absorb(z13_22) cluster(pestop_id_1);

  log close;

  }; * end of evaluating cbd premium with zoning *;



*************************************************************************
********** referee request: any permissively zoned stops initially? *****
*************************************************************************;

if `initial_zn_type' == 1
  {;

  ****** A. load data *************************************************;

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  ****** B. make summary stats on initial 1922 zoning by ss **********;

  tab z22 if pestop_min_dist_1 <= 0.5;

  * make numbers just to get a sense of stringency *;
  gen z22_num = 0;
  replace z22_num = 1 if z22 == "A";
  replace z22_num = 2 if z22 == "B";
  replace z22_num = 3 if z22 == "C";
  replace z22_num = 4 if z22 == "D";
  replace z22_num = 5 if z22 == "E";

  * make numbers for 2013 zoning to get a sense of stringency *;
  gen z13_22_num = 0;
  replace z13_22_num = 1 if z13_22 == "A";
  replace z13_22_num = 2 if z13_22 == "B";
  replace z13_22_num = 3 if z13_22 == "C";
  replace z13_22_num = 4 if z13_22 == "D";
  replace z13_22_num = 5 if z13_22 == "G";
  tab z13_22_num if z13_22 != "";

  * here we need numbers for modern zoning *;
  capture program drop numup;
  program define numup;

    syntax, z13(string) [exif(string)];

    replace z13_full_num = $i if z_zn2013map == "`z13'" `exif';
    global i = $i + 1;

  end;

  * numbering *;
  * this ranking comes from here: 
    http://www.planning.lacity.org/HousingInitiatives/HousingElement/Final/HEAppendixE.pdf *;
  global i = 1;
  gen z13_full_num = 0;
  numup, z13(A1);
  numup, z13(A2);
  numup, z13(RA);
  numup, z13(RE40);
  numup, z13(RE20);
  numup, z13(RE15);
  numup, z13(RE11);
  numup, z13(RE9);
  numup, z13(RS);
  numup, z13(R1);
  numup, z13(RU);
  numup, z13(RZ2.5);
  numup, z13(RZ3);
  numup, z13(RZ4);
  numup, z13(RW1);
  numup, z13(R2);
  numup, z13(RD1.5);
  numup, z13(RD2);
  numup, z13(RD3) exif(`" | z_zn2013map == "R3P" "');
  numup, z13(RD4) exif(`" | z_zn2013map == "R4P" "');
  numup, z13(RD5) exif(`" | z_zn2013map == "R5P" "');
  numup, z13(RD6);
  numup, z13(RMP);
  numup, z13(RW2);
  numup, z13(R3);
  numup, z13(RAS3);
  numup, z13(R4);
  numup, z13(RAS4);
  numup, z13(R5);
  numup, z13(CR) exif(`" | z_zn2013map == "CR(PKM)" "');
  numup, z13(C1);
  numup, z13(C1.5);
  numup, z13(C2);
  numup, z13(C4);
  numup, z13(C5);
  numup, z13(CM);
  numup, z13(MR1);
  numup, z13(M1);
  numup, z13(MR2);
  numup, z13(M2);
  numup, z13(M3);
  numup, z13(P);
  numup, z13(PB);
  numup, z13(OS);
  numup, z13(PF);
  numup, z13(SL);

  tab z13_full_num if z_zn2013map != "";
  tab z_zn2013map if z13_full_num == 0;

  keep if z22 != "";

  * find the mode by stop *;
  foreach z in 
    z22
    z13_22
    z13_full
    {;
    egen md`z' = mode(`z'_num) if pestop_min_dist_1 <= 0.5, by(pestop_id_1);
    egen md`z'_r = mode(`z'_num) 
      if pestop_min_dist_1 > 0.5 & pestop_min_dist_1 < round(c(pi) * ((5/10)^2),.1), 
      by(pestop_id_1);
    };

  * preserve to keep data so I can do outer ring *;
  preserve;
  save ${temp}/befshrink, replace;

  * collapse to stop level *;
  collapse (mean) smnz22 = z22_num 
  	   (mean) smdz22 = mdz22 
	   (mean) mnz13 = z13_full_num
	   (mean) mdz13 = mdz13_full
	   (mean) mnz13_22 = z13_22_num 
  	   (mean) mdz13_22 = mdz13_22 
	   (count) obs = z22_num
	   (mean) mn_sqft_per_lotsize = sqft_per_lotsize
	   (median) md_sqft_per_lotsize = sqft_per_lotsize
	   (p75) p75_sqft_per_lotsize = sqft_per_lotsize
	   	 sp75z22 = z22_num
	   (p25) p25_sqft_per_lotsize = sqft_per_lotsize
	   	 sp25z22 = z22_num
	     [aweight = sqft_per_lotsize]
    if pestop_min_dist_1 <= 0.5, 
    by(pestop_id_1);

  sort pestop_id_1;
  save ${temp}/stops1, replace;

  * now take means at donut level *;
  restore;
  * collapse to stop level *;
  collapse (mean) mnz22_r = z22_num 
  	   (mean) mdz22_r = mdz22_r 
	   (mean) mnz13_r = z13_full_num
	   (mean) mdz13_r = mdz13_full_r
	   (mean) mnz13_22_r = z13_22_num 
  	   (mean) mdz13_22_r = mdz13_22_r 
	   (mean) mn_sqft_per_lotsize_r = sqft_per_lotsize
	   (median) md_sqft_per_lotsize_r = sqft_per_lotsize
	   (p75) p75_sqft_per_lotsize_r = sqft_per_lotsize
	   (p25) p25_sqft_per_lotsize_r = sqft_per_lotsize
	     [aweight = sqft_per_lotsize]
    if pestop_min_dist_1 > 0.5 & pestop_min_dist_1 < round(c(pi) * ((5/10)^2),.1),
    by(pestop_id_1);

  * merge circle and ring stuff together *;  
  merge 1:1 pestop_id_1 using ${temp}/stops1;
  sort _merge;
  by _merge: summ obs;
  gen circle_and_ring = 0;
  replace circle_and_ring = 1 if _merge == 3;

  *** create circle/ring differences ***;

  foreach v in 
    mn_sqft_per_lotsize
    md_sqft_per_lotsize
    p75_sqft_per_lotsize
    p25_sqft_per_lotsize
    mnz13_22
    mdz13_22
    mnz13
    mdz13
    {;
    gen d_`v' = `v' - `v'_r;
    };
 
  * calculate all-stop summary stats *;
  foreach v in 
    smnz22 
    {;
    egen amn_`v' = mean(smnz22);
    egen ap25_`v' = pctile(smnz22), p(25);
    egen ap75_`v' = pctile(smnz22), p(75);
    };
  foreach v in 
    smdz22 
    {;
    egen ap25_`v' = pctile(smdz22), p(25);
    egen ap75_`v' = pctile(smdz22), p(75);
    egen amd_`v' = median(smnz22);
    };

  keep pestop_id_1 smnz22 smdz22 sp25z22 sp75z22 a*;
  sort pestop_id_1;
  save ${temp}/stopszn, replace;

  *** get back to a parcel-level dataset **;
  drop _all;
  use ${temp}/befshrink;

  sort pestop_id_1;
  merge m:1 pestop_id_1 using ${temp}/stopszn;

  * make some interactions at the stop level *;
  foreach v in 
    smnz22
    smdz22
    {;
    gen gt_p25`v' = 0;
    replace gt_p25`v' = 1 if `v' > ap25_`v';
    gen gt_p75`v' = 0;
    replace gt_p75`v' = 1 if `v' > ap75_`v';
    };
  gen gt_mnsmnz22 = 0;
  replace gt_mnsmnz22 = 1 if smnz22 > amn_smnz22;
  gen gt_mdsmdz22 = 0;
  replace gt_mdsmdz22 = 1 if smdz22 > amd_smdz22;

  ***** C. regressions that interact different initial zoning things
  	   by stop with circle coefficient ********************************;

  * set up stata file for output for regular regressions *;
  postfile initialz str100 typer str25 outtype str15(zsamp) int_c using 
        ${app_tables}/initial_stringency_interact/${date}_zone_stringency, replace;


  *** historical zoning ***;

  ** historical zoning obs with modern zoning **;

  * controlling for 1922 zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(1922 zoning w/ mod zon info sample, 1922 zoning, > 6 km frm dt)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 1922zfe(yes)
	 andif(& z_area_fe != .);

  * interact with initial mean zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(interact w/ mean 1922 zoning)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .)
	 covs(smnz22);

  * interact with initial mode zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(interact w/ mode 1922 zoning)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .)
	 covs(smdz22);


  * interact with greater than mean zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(interact w/ greater than mean 1922 zoning by stop)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .)
	 covs(gt_mnsmnz22);

  * interact with greater than mode of mode zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(interact w/ greater than mean 1922 zoning by stop)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .)
	 covs(gt_mdsmdz22);

  * interact with greater than p25 zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(interact w/ gt p25 of mean of 1922 zoning)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .)
	 covs(gt_p25smnz22);

  * interact with greater than p75 zoning *;
  circler, tabletype(by_initial_zoning) depvar(sqft_per_lotsize) 
	 typer(interact w/ gt p75 of mean of 1922 zoning)
	 old_zone_only(yes)
	 exclude_dt(yes) dt_dist(6) 
	 drop_near_lary(no)
	 2013_22zfe(yes)
	 andif(& z_area_fe != .)
	 covs(gt_p75smnz22);


  postclose initialz;

  * make a txt file *;
  shell st         
    ${app_tables}/initial_stringency_interact/${date}_zone_stringency.dta
    ${app_tables}/initial_stringency_interact/${date}_zone_stringency.txt -y;

  ****** D. look at within zone code variation in 2013 ****************;

** just collapse and look at it *;
*  tabstat sqft_per_lotsize use, by(z_zn2013map) stat(mean sd median p25 p75 n);

  ****** E. delete stuff as needed **********************;

  shell rm ${temp}/stops1.dta;

}; * end of stuff by streetcar stops *;

*************************************************************************
********** referee request: log dv  *************************************
*************************************************************************;

if `log_dv_main_results' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;

  * set up stata file for output for regular regressions *;
  postfile tmain str100 typer str25 outtype str15(basic wo_lary) using 
    ${app_tables}/${date}_tmain_log_dv_regs, replace;

  * panel a, no controls *;
  circler, tabletype(main) depvar(ln_sqft_per_lotsize) typer(no covariates) 
  	   drop_near_lary(no) postname(tmain);

  * panel b, predecessors *;
  circler, tabletype(main) depvar(ln_sqft_per_lotsize) typer(predecessors) 
	   covs($preexstc) drop_near_lary(no) postname(tmain);

  * panel c, descendants *;
  circler, tabletype(main) depvar(ln_sqft_per_lotsize) typer(pred + descendants)  
	   covs($preexstc $othercovs) drop_near_lary(no) postname(tmain);

  postclose tmain;

  shell st ${app_tables}/${date}_tmain_log_dv_regs.dta
  	   ${app_tables}/${date}_tmain_log_dv_regs.txt -y;

}; * end of main result but with log dv gate *;


*************************************************************************
********** referee request: zoning variation  ***************************
*************************************************************************;

if `zoning_var' == 1 {;

  * load data *;
  drop _all;
  xsec_datagate;

  * look just at LA *;
  keep if substr(z_2013,1,2) == "LA";

  tab z_2013;

  * make a scatter plot of the codes with the most obs *;
  * these are c2, r1, r2, r3, r4, r5, rd1.5, rd2, c4 *;

  summ sqft_per_lotsize if z_2013 == "LAR1" | 
    z_2013 == "LAR2" | z_2013 == "LAR3" | z_2013 == "LAR4" | 
    z_2013 == "LAR5" | z_2013 == "LARD1.5" | z_2013 == "LARD2" |
    z_2013 == "LARD3" | z_2013 == "LARD4" | z_2013 == "LARD5" |
    z_2013 == "LARD6", detail;

  foreach z in 
    LAR1 LAR2 LAR3 LAR4 LAR5 
    LARD1.5 LARD2 LARD3 LARD4 LARD5 LARD6
    {;
    di "zone code is `z'";
    summ sqft_per_lotsize if z_2013 == "`z'", detail;
    twoway kdensity sqft_per_lotsize if z_2013 == "`z'" & sqft_per_lotsize <= 100, 
      yscale(range(0 0.05))
      ylabel(0(0.01)0.05)		
      xsize(11) ysize(8.5);
    if "`z'" == "LARD1.5" {; local z "LARD1p5"; };
    graph export "${figout}/appendix/zone_density_overlap/${date}_zone_`z'.eps", replace;
    };

  * overlay residential zones *;
  twoway 
    (kdensity sqft_per_lotsize if z_2013 == "LAR1" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LAR2" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LAR3" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LAR4" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LAR5" & sqft_per_lotsize <= 100),
    legend(off)
    text(0.045 21 "R1")
    text(0.036 22 "R2")
    text(0.014 95 "R3")
    text(0.012 24 "R4")
    text(0.002 31 "R5")
    yscale(range(0 0.05))
    ylabel(0(0.01)0.05)
    xtitle("structure square feet per lot size")
    ytitle("share of observations")
    xsize(11) ysize(8.5);
  graph export "${figout}/appendix/zone_density_overlap/${date}_residential_Rzones_kdensity.eps", 
    replace;
  shell convert -density 600 
    ${figout}/appendix/zone_density_overlap/${date}_residential_Rzones_kdensity.eps
    ${figout}/appendix/zone_density_overlap/${date}_residential_Rzones_kdensity.jpg;

  * overlay residential zones *;
  twoway 
    (kdensity sqft_per_lotsize if z_2013 == "LARD1.5" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LARD2" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LARD3" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LARD4" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LARD5" & sqft_per_lotsize <= 100)
    (kdensity sqft_per_lotsize if z_2013 == "LARD6" & sqft_per_lotsize <= 100),
    legend(off)
    text(0.0035 90 "RD2")
    text(0.017 61 "RD3")
    text(0.037 31 "RD4")
    text(0.025 5  "RD6")
    text(0.0065 97 "RD1.5")
    text(0.028 23 "RD5")
    yscale(range(0 0.05))
    ylabel(0(0.01)0.05)		
    xtitle("structure square feet per lot size")
    ytitle("share of observations")
    xsize(11) ysize(8.5);
  graph export "${figout}/appendix/zone_density_overlap/${date}_residential_RDzones_kdensity.eps", replace;
  shell convert -density 600 
    ${figout}/appendix/zone_density_overlap/${date}_residential_RDzones_kdensity.eps
    ${figout}/appendix/zone_density_overlap/${date}_residential_RDzones_kdensity.jpg;

  * overlay commercial zones *;
  * none using z_2013 (but there are from map...)*;


}; * end of pictures with zoning variation *;


*************************************************************************
********** appendix table: average dist to streetcar *********************
*************************************************************************;


if `app_tab_streetcar_dist' == 1
  {;

  **** A. load data *****;

  * load data *;
  drop _all;
  xsec_datagate;


  ****** B. summary stats on the streetcar distance variables ************;

  * what would we like:
    - mean distance from streetcar
    - sd 
    - share of obs < 1 km from streetcar
    - share of obs btwn 1 & 3 km from streetcar
    - share of obs gt 3 km from streetcar
    - max and min
  ;

  *** B.1. clean up and make markers   ***********************;

  * program to calculate markers for each stop type *;
  * stop types are: min(pe stop), min(la ry line in points), min(pe stop, la ry line) *;

  capture program drop stopper;
  program define stopper;

    syntax, stype(string) stypedescp(string);

    gen `stype'_wi0p5km = 0;
    replace `stype'_wi0p5km = 1 if min_dist_`stype' <= 0.5;
    label variable `stype'_wi0p5km "1 if 0 to 0.6 km from `stypedescp'";
    gen `stype'_wi0p5t0p7km = 0;
    replace `stype'_wi0p5t0p7km = 1 if min_dist_`stype' > 0.5 & min_dist_`stype' <= 0.7;
    label variable `stype'_wi0p5t0p7km "1 if 0.6 to 0.85 km from `stypedescp'";
    gen `stype'_wi0p7t3km = 0;
    replace `stype'_wi0p7t3km = 1 if min_dist_`stype' > 0.7 & min_dist_`stype' <= 3;
    label variable `stype'_wi0p7t3km "1 if 0.85 to 3 km from `stypedescp'";
    gen `stype'_gt3km = 0;
    replace `stype'_gt3km = 1 if min_dist_`stype' > 3;
    label variable `stype'_gt3km "1 if gt 3 km from `stypedescp'";

  end;

  stopper, stype(pestops) stypedescp(pacific electric stops);
  stopper, stype(lary) stypedescp(los angeles railway lines);
  stopper, stype(any_scar) stypedescp(min(pe stops, la ry lines));

  * save for use in next step *;
  save ${temp}/carsb2, replace;

  *** B.2. make summary stats ***;

  * program to calculate summary stats and stack *;
  capture program drop summer;
  program define summer;

    syntax, stype(string);

    drop _all;
    use ${temp}/carsb2;
    collapse (mean) mean_dist=min_dist_`stype' 
    	     	    shr_wi0p5km=`stype'_wi0p5km 
    	     	    shr_wi0p5t0p7km=`stype'_wi0p5t0p7km
		    shr_wi0p7t3km=`stype'_wi0p7t3km 
		    shr_gt3km=`stype'_gt3km
           (sd) sd_dist = min_dist_`stype'
           (min) min_dist = min_dist_`stype' (max) max_dist = min_dist_`stype'
           (count) obs=min_dist_`stype';
    gen stype = "`stype'";
    save ${temp}/dist$j, replace;
    if "$j" != "1"
      {;
      drop _all;
      use ${temp}/dist1;
      append using ${temp}/dist$j;
      list;
      save ${temp}/dist1, replace;
      };

    global j = $j + 1;

  end;

  global j=1;
  *set trace on;
  *set tracedepth 1;
  summer, stype(pestops);
  summer, stype(lary);
  summer, stype(any_scar);

  *** B.3. format to latex table? ***;

  order stype mean_dist sd_dist min_dist max_dist shr_wi0p5km shr_wi0p5t0p7km 
  	shr_wi0p7t3km shr_gt3km obs;

  set linesize 180;
  list;

  * save final dataset and convert to csv *;
  save ${app_tables}/${date}_streetcar_distance_stats, replace;

  shell st ${app_tables}/${date}_streetcar_distance_stats.dta
  	   ${app_tables}/${date}_streetcar_distance_stats.xls -y;

  }; * this bracket closes appendix table that caluclates distance to streetcar *;


*************************************************************************
********** appendix table: average dist to streetcar *********************
*************************************************************************;


if `bus_stop_check' == 1
  {;

  **** A. load data *****;

  * load data *;
  drop _all;
  xsec_datagate;

  * cubic in distance to bus stop *;
  for num 2 3: gen min_dist_busstpX = min_dist_busstp^X;

  ***** B. ugh ******;

  * set up stata file for output for regular regressions *;
  postfile tbus str100 typer str25 outtype str15(basic wo_lary) using 
    ${app_tables}/${date}_bus_stop_robustness, replace;

  set trace on;
  set tracedepth 2;

  * col 1, no controls *;
  circler, tabletype(bus) depvar(sqft_per_lotsize) typer(no covariates) 
  	   drop_near_lary(no) postname(tbus);

  * col 2, predecessors and descendants *;
  circler, tabletype(bus) depvar(sqft_per_lotsize) typer(pred + descendants)  
	   covs($preexstc $othercovs) drop_near_lary(no) postname(tbus);

  * col 3, predecessors and descendants and cubic in bus distance *;
  circler, tabletype(bus) depvar(sqft_per_lotsize) typer(pred + descendants + bus cube)  
	   covs($preexstc $othercovs min_dist_busstp*) drop_near_lary(no) postname(tbus);

  postclose tbus;
  
  * make a txt file *;
  shell st ${app_tables}/${date}_bus_stop_robustness.dta
  	   ${app_tables}/${date}_bus_stop_robustness.txt -y;

  }; * bracket closes gate with bus stop robustness check *;


*************************************************************************
********** referee request: distance premium ****************************
*************************************************************************;

if `dist_prem_org' == 1
  {;

  * goal here is to repeat table 5, panel 1
    and see if we get a premium for being near downtown *;

  * load data *;
  drop _all;
  xsec_datagate;

  * set up stata file for output for regular regressions: need this so it runs *;
  postfile zonestat str100 typer str25 outtype str15(zsamp overlap zcontrol zbyssfe) using 
        ${app_tables}/${date}_junk, replace;

  * do the log so i can see all coefficients *;
  capture log close;
  log using ${app_tables}/${date}_zoning_est_all_coeffs.log, replace;

 * all runs are coded to run only w/o obs near la railway *;
  * we do 3 regressions per call:
    1. full zoning sample
    2. zoning sample only w/o zone codes in treatment and control
    3. full zoning sample, controlling for zone code 
  *;

  *** regular sample ***;

  ** w/o la ry obs **;

  * do all obs *;

  circler, tabletype(simpzone) depvar(sqft_per_lotsize) 
	 typer(full zoning sample, no la ry) 
	 drop_near_lary(yes);

  postclose zonestat;

  * make a txt file *;
  shell rm ${app_tables}/${date}_zone_explain_regs.dta ;

  log close;


  }; * this bracket closes the analysis looking at distance premia in
       the main estimation *;


*************************************************************************
********** referee request: circle vs band analysis ****************************
*************************************************************************;

if `circle_vs_band' == 1 
  {;

  ***** 0. goals ********************************************************;

  * a. run band estimates on sample from table 2, col 2, panel a. *;

  * b. use maxdist from table 2 - i.e. (0.5)*(2^.5) and use standard treatment variables *;

  ** deleted some steps in here **;


  ****** 1. load data *************;
  drop _all;
  xsec_datagate;

  ****** 2. define bins ****************;

  * make 0.1 km distance dummies *;
  local i=1;
  forvalues d=0(0.1)5.9
    {;
    local dd = `d' + 0.1 ;
    gen scar_dist_p1bin`i' = 0;
    replace scar_dist_p1bin`i' = 1 if pestop_min_dist_1 > `d' & pestop_min_dist_1 <= `dd';
    label variable scar_dist_p1bin`i' 
      "1 if pestop_min_dist_1 is > `d' km & < `dd' from streetcar stop ";
    local i = `i' + 1;
    };

  * save data for re-use *;
  save ${templ}/f4test, replace;

  ***** 3. ado to run multiple regs *******;

  capture program drop circler3;
  program define circler3;

  syntax, tabletype(string) depvar(string) 
          [covs(string) andif(string) drop_near_lary(string) old_zone_only(string) 
	  post_1963(string) exclude_dt(string) dt_dist(string) 1922zfe(string) 
	  2013_22zfe(string) ringer(string)
	  zombiec(string) zonedvs(string) postname(string) no4(string)];

  foreach df in 5 21 
    {;

    * restore data if not the first run so we can reweight and re-drop *;
    if "`df'" != "5"
      {;
      drop _all;
      use ${templ}/f4test;
      };

    * make key variables -- should be defined in each round *;
    gen cir_`df'_outer  = pestop_min_dist_1  <= (`df'/10)*(2^.5);
    gen cir_`df'_inner  = pestop_min_dist_1  <= (`df'/10);
    gen lar_`df'_outer  = min_dist_lary      <= (`df'/10)*(2^.5);

    * set up variables 
     - dep vars w/o la railway info 
     - switch for dropping circles near la railway
     - weights for streetcar stops
     - drop cases where inner or outer circles have < 10 parcels ;
    nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') 
    	      	       covs($preexstc $othercovs)
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

    disp "*********";disp "inner radius `df'th of a kilometer"; disp "***********************";
    disp "**********************************";disp "`depvar'"; disp "************************";

    * regression w/o covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner 
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(1) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ P covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner $preexstc 
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(2) depvar(`depvar') df(`df') sdigs(4);

    * regression w/ P and D covariates, no la railway *;
    areg  `depvar'_nol  cir_`df'_inner $preexstc $othercovs
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    topost, num(3) depvar(`depvar') df(`df') sdigs(4);

    **** regression w/ bins, no la railway ****;

    * set end bin *;
    if `df' == 5 {; local lbin 6; };
    if `df' == 21 {; local lbin 28; };

    * regression w/o covariates, no la railway *;
    areg  `depvar'_nol scar_dist_p1bin1-scar_dist_p1bin`lbin' 
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    * put coefficients in local macros *;
    local num 4;
    local sdigs 3;
    forvalues j = 1/`lbin'
      {;
      global `depvar'_db`df'`j'_`num'  : display %5.`sdigs'f _b[scar_dist_p1bin`j']; 
      global `depvar'_dse`df'`j'_`num' : display %5.`sdigs'f  _se[scar_dist_p1bin`j'];
      global `depvar'_dn`df'`j'_`num'  : display %7.0fc e(N);
      by pestop_id_1: gen unq = _n == 1 & e(sample) == 1;
      count if unq;
      global `depvar'_dsn`df'`j'_`num' : display %7.0fc r(N);
      drop unq;
      global desc`num'_`j' "bin `j' : no covariates";
      };

    * regression w/ P covariates, no la railway *;
    areg  `depvar'_nol scar_dist_p1bin1-scar_dist_p1bin`lbin' $preexstc
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    * put coefficients in local macros *;
    local num 5;
    local sdigs 3;
    forvalues j = 1/`lbin'
      {;
      global `depvar'_db`df'`j'_`num'  : display %5.`sdigs'f _b[scar_dist_p1bin`j']; 
      global `depvar'_dse`df'`j'_`num' : display %5.`sdigs'f  _se[scar_dist_p1bin`j'];
      global `depvar'_dn`df'`j'_`num'  : display %7.0fc e(N);
      by pestop_id_1: gen unq = _n == 1 & e(sample) == 1;
      count if unq;
      global `depvar'_dsn`df'`j'_`num' : display %7.0fc r(N);
      drop unq;
      global desc`num'_`j' "bin `j' : P covariates";
      };

    * regression w/ P and D covariates, no la railway *;
    areg  `depvar'_nol scar_dist_p1bin1-scar_dist_p1bin`lbin' $preexstc $othercovs
          $rweight_nol
          if cir_`df'_outer == 1 & vok == 1 , a(pestop_id_1) cluster(pestop_id_1);
    * put coefficients in local macros *;
    local num 6;
    local sdigs 3;
    forvalues j = 1/`lbin'
      {;
      global `depvar'_db`df'`j'_`num'  : display %5.`sdigs'f _b[scar_dist_p1bin`j']; 
      global `depvar'_dse`df'`j'_`num' : display %5.`sdigs'f  _se[scar_dist_p1bin`j'];
      global `depvar'_dn`df'`j'_`num'  : display %7.0fc e(N);
      by pestop_id_1: gen unq = _n == 1 & e(sample) == 1;
      count if unq;
      global `depvar'_dsn`df'`j'_`num' : display %7.0fc r(N);
      drop unq;
      global desc`num'_`j' "bin `j' : P and D covariates";
      };


    *** post the output for overall coefficient to the stata file ***;
    post humppic ("`tabletype'") ("`df'") ("no covs")
      ("${`depvar'_b`df'1}")  ("${`depvar'_se`df'1}")  
      ("${`depvar'_n`df'1}") ("${`depvar'_sn`df'1}");
    post humppic ("`tabletype'") ("`df'") ("control p")
      ("${`depvar'_b`df'2}")  ("${`depvar'_se`df'2}")  
      ("${`depvar'_n`df'2}") ("${`depvar'_sn`df'2}");
    post humppic ("`tabletype'") ("`df'") ("control p and d")
      ("${`depvar'_b`df'3}")  ("${`depvar'_se`df'3}")  
      ("${`depvar'_n`df'3}") ("${`depvar'_sn`df'3}");

    *** post output for binned coefficients to the stata file ***;
    forvalues s=4/6
      {;
      forvalues j=1/`lbin'
        {;
        post humppic ("`tabletype'") ("`df'") ("${desc`s'_`j'}")
          ("${`depvar'_db`df'`j'_`s'}")  ("${`depvar'_dse`df'`j'_`s'}")  
          ("${`depvar'_dn`df'`j'_`s'}") ("${`depvar'_dsn`df'`j'_`s'}");
        };
      };

    * get rid of largest consistent sample marker *;
    drop vok;

    }; * end of df loop *;

  end; * end of circler2 ado *;

  ***** 4. call the ado **************;

  *postfile humppic 
	 str100 tabletype str3 radius str100 covtype str15(coeff stderr obs stops) using 
	 ${app_tables}/${date}_distance_bands_full_samp, replace;

  *circler3, tabletype(output_for_picture) depvar(sqft_per_lotsize) drop_near_lary(yes);

  *postclose humppic;

  ***** 5. load output, clean it up *************;

  drop _all;
  *use ${app_tables}/${date}_distance_bands_full_samp;
  use ${app_tables}/20171115_distance_bands_full_samp;

  * pull out distance variable *;
  destring coeff, replace;
  destring stderr, replace;
  destring radius, replace;
  replace radius = round(radius / 10, 0.1);

  * this is b/c I couldnt get the numeric radius to work as a subsetting if below *;
  gen radius_t = "0.5" if radius > 0.49 & radius < 0.51;
  replace radius_t = "2.1" if radius > 2.01 & radius < 2.11;
  tab radius_t;

  * pull out bin variables *;
  gen bin_num = substr(covtype,5,2) if substr(covtype,1,1) == "b";
  destring bin_num, replace;
  replace bin_num = bin_num / 10;

  * pull out estimation type *; 
  gen cl = strpos(covtype,":") + 2;
  gen sl = length(covtype) - cl +1;
  gen betype = substr(covtype,cl,sl);
  drop sl cl;

  gen cihi = coeff + 1.96*stderr;
  gen cilow = coeff - 1.96*stderr;

  list;

  ***** 6. make the pictures ***************************************;

  graph set eps orientation landscape;

  *** 6.a. 3 sets coefficients and 1 confidence interval : 
           same radius as main spec  ***;
  twoway
    (rarea cilow cihi bin_num
      if betype == "P and D covariates" & radius_t == "0.5", bcolor(gs14))
    (connected coeff bin_num
      if betype == "no covariates" & radius_t == "0.5",
      lcolor(midblue) mcolor(midblue))
    (connected coeff bin_num
      if betype == "P covariates" & radius_t == "0.5",
      lcolor(green) mcolor(green))
    (connected coeff bin_num
      if betype == "P and D covariates" & radius_t == "0.5",
      lcolor(cranberry) mcolor(cranberry)),
    legend(off)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density: (structure sq ft / lot sq ft)*100")
    text(9 0.16 "red:")
    text(8 0.16 "{it:P} and {it:D} controls")
    text(7 0.45 "green: {it:P} controls")
    text(1 0.47 "blue: no covariates")
    xsize(11)
    ysize(8.5);

  graph export 
    "${figout}/appendix/${date}_bin_0725km_radius.eps", replace;
  shell convert -density 600 
    ${figout}/appendix/${date}_bin_0725km_radius.eps
    ${figout}/appendix/${date}_bin_0725km_radius.jpg;


  *** 6.a. 3 sets coefficients and 1 confidence interval : 
           3 km radius  ***;

  twoway
    (rarea cilow cihi bin_num
      if betype == "P and D covariates" & radius_t == "2.1", bcolor(gs14))
    (connected coeff bin_num
      if betype == "no covariates" & radius_t == "2.1",
      lcolor(midblue) mcolor(midblue))
    (connected coeff bin_num
      if betype == "P covariates" & radius_t == "2.1",
      lcolor(green) mcolor(green))
    (connected coeff bin_num
      if betype == "P and D covariates" & radius_t == "2.1",
      lcolor(cranberry) mcolor(cranberry)),
    legend(off)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density: (structure sq ft / lot sq ft)*100")
    text(-4 0.5 "red: {it:P} and {it:D} controls")
    text(-6 0.5 "green: {it:P} controls")
    text(5  2.4 "blue: no covariates")
    xlabel(0.1(0.2)2.9)
    xscale(range(0 2.9))
    xsize(11)
    ysize(8.5);

  graph export 
    "${figout}/appendix/${date}_bin_3km_radius.eps", replace;
  shell convert -density 600 
    ${figout}/appendix/${date}_bin_3km_radius.eps
    ${figout}/appendix/${date}_bin_3km_radius.jpg;


  }; * this bracket closes the comparison of circle/ring to distance bands *;


*************************************************************************
********** appendix table: summary stats zone change ****************************
*************************************************************************;

if `app_tab_zone_change' == 1 {;

  *** 1. load data ***;

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  *** 2. make analysis sample ****;

  * keep just analysis sample *;
  keep if min_dist_pestops < (1/2)*(2^.5);

  * markers for zone type *;
  foreach j in
    A B C D E
    {;
    gen z2013_z22cd`j' = 0;
    replace z2013_z22cd`j' = 1 if z13_22 == "`j'";
    tab z2013_z22cd`j';
    };

  *** 3. collapse to relevant data ***;

  sort z_1922;
  collapse (sum) z2013_z22cd*, by(z_1922);
  list;

  * make a row total *;
  gen tot_parcels = z2013_z22cdA + z2013_z22cdB + z2013_z22cdC + z2013_z22cdD;

  * make some shares *;
  foreach j in 
    A B C D
    {;
    gen z2013_z22cd`j'_shr = z2013_z22cd`j' / tot_parcels;
    };

  list;

  **** 4. output table ***************************;

  save ${app_tables}/${date}_zoning_change_summ_stats, replace;

  shell st ${app_tables}/${date}_zoning_change_summ_stats.dta
  	   ${app_tables}/${date}_zoning_change_summ_stats.txt;

  }; * bracket closes summary stats zone change table *;



************************************************************************;
************ appendix figure: income ***********************************;
************************************************************************;

if `income_fig' == 1
  {;

  * full program is 
    /home/lfbrooks/zoning/streetcars/stataprg/car_distance_vs_hist_density_pictures/
    cons1940tractpicsv12.do *;
  * section I, near bottom *;

  ***** 1. load data **************************************************************;

  drop _all;
  use ${figure_data};

  ***** 2. income pictures ****************************************************;

  ** median family income **;
  foreach j in 1950 1960 1970 1990 2000 2010
    {;

    lowess cvar11_1_`j' min_dist_any_scar, generate(lowess_p) bwidth(0.2);

    twoway
      (scatter cvar11_1_`j' min_dist_any_scar if min_dist_any_scar <= 6, msymbol(p))
      (scatter lowess_p     min_dist_any_scar if min_dist_any_scar <= 6, msymbol(p)),
      legend(off)
      ylabel(0.2(0.2)1)
      yscale(range(0.2 1))
      ytitle("share with income <= median")
      xtitle("kilometers to the streetcar")
      xsize(11) ysize(8.5);
    drop lowess_p;

    graph export 
      "${figout}/appendix/${date}_le_median_income_`j'.eps",
      replace;
    shell convert -density 600 
      ${figout}/appendix/${date}_le_median_income_`j'.eps
      ${figout}/appendix/${date}_le_median_income_`j'.jpg;

    }; * end of by-year loop *;

  }; * this ends income figure loop *;

************************************************************************;
***** appendix figure: fifth order polynomial picture ***********************************;
************************************************************************;

if `fifth_order_poly' == 1
  {;

  * log to capture coefficients *;
  log using ${app_tables}/${date}_fifth_order_poly_estimates.log, replace;

  * 1. load data *;

  * call ado that loads data and makes key variables *;
  drop _all;
  xsec_datagate;

  * 2. ado to try to limit sample to what we use in main regression *;

  * this is copied from circler3 -- bad programming, should use same loop for both *;
  capture program drop circler4;
  program define circler4;

  syntax, tabletype(string) depvar(string) 
          [covs(string) andif(string) drop_near_lary(string) old_zone_only(string) 
	  post_1963(string) exclude_dt(string) dt_dist(string) 1922zfe(string) 
	  2013_22zfe(string) ringer(string)
	  zombiec(string) zonedvs(string) postname(string) no4(string)];

  local df 20;

  * make key variables -- should be defined in each round *;
  gen cir_`df'_outer  = pestop_min_dist_1  <= (`df'/10)*(2^.5);
  gen cir_`df'_inner  = pestop_min_dist_1  <= (`df'/10);
  gen lar_`df'_outer  = min_dist_lary      <= (`df'/10)*(2^.5);

  * set up variables 
   - dep vars w/o la railway info 
   - switch for dropping circles near la railway
   - weights for streetcar stops
   - drop cases where inner or outer circles have < 10 parcels ;
  nol_vars, df(`df') drop_near_lary(`drop_near_lary') tabletype(`tabletype') 
    	      	       covs($preexstc $othercovs)
    	      	       old_zone_only(`old_zone_only') post_1963(`post_1963') 
		       exclude_dt(`exclude_dt') dt_dist(`dt_dist') 
		       1922zfe(`1922zfe') 2013_22zfe(`2013_22zfe');

  * make fifth order terms *;
  forvalues j=1/5
    {;
    gen pestop_min_dist_1_p`j' = pestop_min_dist_1^`j';
    label variable pestop_min_dist_1_p`j' "pestop_min_dist_1^`j'";
    };

  * regression for 5th order polynomial *;
  areg `depvar'_nol pestop_min_dist_1_p1 pestop_min_dist_1_p2 pestop_min_dist_1_p3
      pestop_min_dist_1_p4 pestop_min_dist_1_p5 
      $preexstc $othercovs
      $rweight_nol
      if vok == 1 & pestop_min_dist_1 <= 3,
      absorb(pestop_id_1) cluster(pestop_id_1);
 
  * set up a postfile *;
  postfile fifthp dist b se using 
        ${app_tables}/${date}_fifth_order_polynomial_output, replace;

  * post values for distance amounts *;
  forvalues a = 0 (0.1) 3.1
    {; 

    * for validation *;
    quietly test          (`a' *             _b[pestop_min_dist_1_p1 ])           + ((`a'*`a') *           _b[pestop_min_dist_1_p2]) +
                              ((`a'*`a'*`a') * _b[pestop_min_dist_1_p3])           + ((`a'*`a'*`a'*`a') * _b[pestop_min_dist_1_p4]) +
                              ((`a'*`a'*`a'*`a'*`a') * _b[pestop_min_dist_1_p5]) = 0;
    
    * calculate coefficient at distance a*;
    local b = 
     (_b[pestop_min_dist_1_p1] * `a') +
     (_b[pestop_min_dist_1_p2] * `a' *`a') +
     (_b[pestop_min_dist_1_p3] * `a' * `a' * `a') +
     (_b[pestop_min_dist_1_p4] * `a' * `a' * `a' * `a') +
     (_b[pestop_min_dist_1_p5] * `a' * `a' * `a' * `a' * `a');

    * calculate standard error at distance a *;
    local se =  
     ((
     (_b[pestop_min_dist_1_p1] * `a') +
     (_b[pestop_min_dist_1_p2] * `a' *`a') +
     (_b[pestop_min_dist_1_p3] * `a' * `a' * `a') +
     (_b[pestop_min_dist_1_p4] * `a' * `a' * `a' * `a') +
     (_b[pestop_min_dist_1_p5] * `a' * `a' * `a' * `a' *`a'))
     / r(F)^.5);
    
    * post these things *;
    post fifthp (`a') (`b') (`se');

  }; * end of making values for all relevant distances *;

  postclose fifthp;

  end; * end of circler4 ado *;

  * 3. do fifth order polynomial regression *;

  *circler4, tabletype(output_for_picture) depvar(sqft_per_lotsize) drop_near_lary(yes);

  * 4. make a picture from results *;

  drop _all;
  use ${app_tables}/${date}_fifth_order_polynomial_output;

  * make confidence intervals *;
  gen ci_lo = b + 1.96 * abs(se);
  gen ci_hi = b - 1.96 * abs(se);

  list;

  twoway
    (rarea ci_lo ci_hi dist, bcolor(gs14))
    (line b dist, lcolor(cranberry) mcolor(cranberry)),
    legend(off)
    xtitle("Kilometers to Streetcar Stop")
    ytitle("Structure Density Relative to Stop")
    xsize(11)
    ysize(8.5);

  graph export 
    "${figout}/appendix/${date}_fifth_order_polynomial.eps", replace;
  shell convert -density 600 
    ${figout}/appendix/${date}_fifth_order_polynomial.eps
    ${figout}/appendix/${date}_fifth_order_polynomial.jpg;

  log close;

  }; * end of fifth order polynomial regression and picture *;

******* general clean-up ***************************************;





shell rm ${temp}/*;

