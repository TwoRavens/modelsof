#delimit;

*****************************************************************************

this program takes the big panel with all years and shrinks just to the 
2011 x-section for our analysis

january 6, 2015 ** checking why the program ends with obs w/o ain 
august 4, 2017 ** saving as new name, commenting out things in other program
  used to be named
  /groups/brooksgrp/zoning/streetcar_stops/stata_programs/xsection_setup/
  data_01_06_2015.do
august 8, 2017
august 10, 2017
  .. moving zoning coding from main program into here
august 30, 2017 .. why no city_zone variable in final product?
august 31, 2017 .. same issue

data_stata_prep_v05.do

***************************************************************************;

clear all;
set trace off;
set more off;
set linesize 255;
capture restore, not;
capture log close;
pause on;

* this sets the date for the input and output datasets *;
local paneldt 20170808;

capture log using data_`paneldt'.log, replace; 

* make temporary directory *;
global temp "/scratch";

******************************************************************************;
* pull in overall dataset and add some zoning variables **********************;
******************************************************************************;

* program that creates this file is
  /home/lfbrooks/zoning/streetcars/sasprg/revise_merged_dataset/scar_setupv21.sas;
use /groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/scar_revmgd_`paneldt'.dta;

  ****** C. specific zoning set up things ****************************;

  * drop those with no zoning data and those with a second zone code;
  replace z_match_code_1 =  rtrim(ltrim(subinstr(z_match_code_1,"-","",.)));
  replace z_match_code_2 = rtrim(ltrim(z_match_code_2));
  replace z_match_code_2 = "" if z_match_code_2 == ".";

  replace city_name = "missing" if city_name == "";

  * define the zoning - treatment/control area fixed-effects;
  encode zone_code_id, gen(city_zone);
  egen z_area_fe = group(pestop_id_1 z_match_code_1 city_zone);
  replace z_area_fe = . if z_match_code_1 == "" | z_match_code_1 == ".";
  replace z_area_fe = . if z_match_code_2 ~= "";
  label variable city_zone "encoded version of zone_code_id";
  *drop city_zone;
  * 2013 zoning only variable for fe *;
  gen z_2013 = zone_code_id + z_match_code_1;
  replace z_2013 = "" if z_match_code_1 == "" | z_match_code_1 == ".";
  replace z_2013 = "" if z_match_code_2 ~= "";
  label variable z_2013 "zones for 2013 with city id (zone_code_id + z_match_code_1)";
  codebook z_area_fe;

  * make a zone code variable that tells us what the zone is *;
  gen zn_info = zone_code_id + z_match_code_1;
  label variable zn_info "city marker + zone code (zone_code_id + z_match_code_1)";

  * make a 1922 zone code fe *;
  tab z_1922;
  gen z22 = z_1922;
  replace z22 = "" if z_1922 == "NIS" | z_1922 == "U" | z_1922 == "TRB";
  replace z22 = "O" if z_1922 == "CEM" | z_1922 == "M";
  tab z22;
  egen z22_fe = group(pestop_id_1 z22);
  tab z22_fe;
  label variable z22    "zoning: 1922 zone code, string, cleaned to 6 codes";
  label variable z22_fe "zoning fe: pe stop + 1922 zone code, numeric, cleaned to 6 codes = z22";

  ** make a 2013/1922 zone code fe *;
  * first we clean the 2013 in 22 terms variable *;
  tab z_2013z22;
  gen z13_22 = z_2013z22;
  * F is the non-code code *;
  replace z13_22 = "" if z13_22 == "F";
  tab z13_22;
  label variable z13_22 "zoning: 2013 zone code, in 1922 terms, cleaned to 6 codes";

  * make zone change variables *;
  tab z22 z13_22;
  gen z_1922_nlp = 0 if z22 != "";
  replace z_1922_nlp = 1 if z22 > z13_22;
  gen z_1922_nmp = 0 if z22 != "";
  replace z_1922_nmp = 1 if z22 < z13_22;
  gen z_1922_ch = 0 if z22 != "" & z13_22 != "";
  replace z_1922_ch = 1 if z22 != z13_22 & z22 != "" & z13_22 != "";
  tab z_1922_nlp;
  tab z_1922_nmp;
  tab z_1922_ch;
  tab z22 z13_22 if z_1922_nlp == 1;
  tab z22 z13_22 if z_1922_nmp == 1;
  label variable z_1922_nlp "zng: 1 if parcel is now (2013) zoned less permissively than in 1922";
  label variable z_1922_nmp "zng: 1 if parcel is now (2013) zoned more permissively than in 1922";
  label variable z_1922_ch  "zng: 1 if parcel now (2013) has different zoning than 1922";


  * make zoning fe for 2013/1922 data *;
  egen z13_22_fe = group(pestop_id_1 z13_22);
  label variable z13_22_fe "zoning: pe stop + 2013 zone code, in 1922 terms, cleaned to 6 codes = z13_22";

  *** zoning fe, not crossed with pe stops *;
  * make sure we have the same sample for both *;

  * 2013/1922 data, not crossed with pe stop *;
  quietly tab z13_22 if z13_22 != "F" & z13_22 != "G" & z22 != "O", gen(z13_22_znonly_fe);
  summ z13_22_znonly_fe*;

  * more parsimonious specification of 2013 zoning fe *;
  forvalues j=1/2
    {;
    gen z13_22_zn3only_fe`j' = z13_22_znonly_fe`j';
    label variable z13_22_zn3only_fe`j' "2013 in 1922 terms zoning fe, 3 (not 4) groups";
    };
  gen z13_22_zn3only_fe3 = z13_22_znonly_fe3 + z13_22_znonly_fe4;
  label variable z13_22_zn3only_fe3 "2013 in 1922 terms zoning fe, 3rd group";

  * 1922 data, not crossed with pe stop *;
  quietly tab z22    if z13_22 != "F" & z13_22 != "G" & z22 != "O", gen(z22_znonly_fe);
  summ z22_znonly_fe*;


  * make more parsimonious 1922 zone codes for instruments *;
  forvalues j=1/3
    {;
    gen z22_zn4only_fe`j' = z22_znonly_fe`j';
    label variable z22_zn4only_fe`j' "1922 zoning fe, in four groups";
    };
  gen z22_zn4only_fe4 = z22_znonly_fe4 + z22_znonly_fe5;
  label variable z22_zn4only_fe3 "1922 zoning fe, in three groups: this is c, d and e";
  summ z22_zn4only_fe*;

  * zoning: res vs. non-res for 1922 and 2013 in 1922 terms *;
  foreach j in 
    z22 z13_22
    {;
    gen res`j' = 0 if `j' != "";
    replace res`j' = 1 if `j' == "A" | `j' == "B";
    gen nres`j' = 1 - res`j';
    };
  label variable resz22 
    "1 if zoned residential in 1922, 0 if in la 1922 and non-res, . o.w.";
  label variable nresz22
    "1 if zoned non-residential in 1922, 0 if in la 1922 and non-res, . o.w.";
  label variable resz13_22 
    "1 if zoned residential in 2013 (22 terms), 0 if in 1922 samp and non-res, . o.w.";


  tab z22 resz22;
  tab z13_22 resz13_22;

  * byrons code for 1922 zoning to 2013 zoning change: parcels not C that go to C *;
  gen z_1922_ch_to_C = 0 if z22 ~= "" & z13_22 ~= "";
  replace z_1922_ch_to_C = 1 if z22 ~= "C" & z13_22 == "C" & z22 ~= "" & z13_22 ~= "";
  tab z_1922_ch_to_C;

  * byrons code for 1922 zoning to 2013 zoning change: parcels not C or D that go to C or D*;
  gen z_1922_ch_to_CD = 0 if (z22 ~= "" & z13_22 ~= "");
  replace z_1922_ch_to_CD = 1 if (z22 ~= "C" & z22 ~= "D") & 
  	  		    (z13_22 == "C" | z13_22 == "D") & (z22 ~= "" & z13_22 ~= "");
  tab z_1922_ch_to_CD;
  tab z_1922_ch_to_C z_1922_ch_to_CD;


  *** E.1. more set-up ***;

  * just going to drop previous definition -- not bad, but just to keep consistent *;
  * defined slightly differently *;
  drop res;

  * dep. variables -- zoning things from modern zoning, all cities;
  gen res = 0 if use_cd != "";
  replace res = 1 if (substr(use_cd,1,1) == "0");
  label variable res "1 if residential use from 2011 use code; 0 if non-res, . if no use code";

  gen non_res = 0 if use_cd != "";
  replace non_res = 1 if (substr(use_cd,1,1) != "0");
  label variable non_res "1 if non-residential use from 2011 use code; 0 if res, . if no use code";


  * for the max zoning variables, 0 means that the max is undefined - i.e. not set by the zoning 
    authority.  in essence this means this type of restriction is not in use and should be set to 
    missing.;
  for var z_max_ht_feet z_max_ht_stories : replace X = . if X == 0;
  for var z_far z_max_ht_feet z_max_ht_stories z_min_ls : gen ln_X = ln(X);
  replace units_per_lotsize = units_per_lotsize * 10000;
  replace sqft_per_lotsize   = sqft_per_lotsize  * 100;
  gen vacant = 1000*(use == 3);
  foreach gd in z_far ln_z_far z_max_ht_feet ln_z_max_ht_feet z_max_ht_stories ln_z_max_ht_stories z_min_ls ln_z_min_ls z_c_parking z_uc_parking
    {;
    gen `gd'_r = `gd'; 
    replace `gd'_r = . if z_use_1 ~= 1;

    gen `gd'_nr = `gd';
    replace `gd'_nr = . if z_use_1 == 1;
    };
  gen multi_fam_r = (use == 2 | use == 2.5);
  replace multi_fam_r = . if (substr(use_cd,1,1) ~= "0");
  label variable multi_fam_r "1 if multifamily; 0 if mf and res; . if not res";
  * already defined earlier *;
  *gen ln_imp_val_lotsize = ln(imp_val_lotsize);

  gen z_nonres = (z_use_2 == 1 | z_use_3 == 1 | z_use_4 == 1 | z_use_5 == 1 | z_use_6 == 1 | z_use_7 == 1 | z_use_8 == 1 | z_use_9 == 1 | z_use_11 == 1);
  replace z_nonres = . if (z_use_2 == . & z_use_3 == . & z_use_4 == . & z_use_5 == . & z_use_6 == . & z_use_7 == . & z_use_8 == . & z_use_9 == . & z_use_11 == . & z_use_1 == . & z_use_12 == .);
  replace z_max_units = . if use >=3;

  global z_measures "z_far ln_z_far z_max_ht_feet ln_z_max_ht_feet z_max_ht_stories ln_z_max_ht_stories z_min_ls ln_z_min_ls z_c_parking z_uc_parking z_nonres multi_fam_r";

  * save dataset of all obs for later use in summary stats program *;
  save /groups/brooksgrp/temp/summstatsxsec, replace;

  * drop obs and vars. not to be used to speed things up;
  * set the max treatment radius to be used;
  *local loopmax = 30;
  *gen cir_`loopn'_outer  = pestop_min_dist_1  <= (`loopmax'/10)*(2^.5);
  *keep if cir_`loopn'_outer == 1;
  *drop cir_`loopn'_outer;

  * save this for use later here *;
  save ${temp}/scardats, replace;

******************************************************************************;
* Pull in the info to create the time since last sale in the 2011 x-section  *;
******************************************************************************;

* program that creates this file is this one! *;
use ain last_sale_date if last_sale_date ~= . 
  using ${temp}/scardats;

* comment out most of this, b/c i did it in the sas program *;
format last_sale_date %tdD_m_Y;
duplicates drop ain, force;
sort ain;
save /groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/last_sale_`paneldt', replace;

*******************************;
* Save the 2011 cross-section *;
*******************************;
do cato.ado;
use if year_of_data == 2011 
  using ${temp}/scardats;
desc, full;

* remove duplicates parcels - these are parcels that sold more than once in 2011;
sort ain sale_date;
by ain  : gen dup_num = _n;
duplicates tag ain, gen(dup);
tab dup dup_num, mis;
list ain sale_date dup dup_num if dup > 0, sepby(ain);
drop if dup == 2 & dup_num < 3;
drop if dup == 1 & dup_num < 2;
tab dup dup_num, mis;
drop dup dup_num;
duplicates report ain;

save /groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/scar_revmgd_`paneldt'_2011_xsec.dta, replace;

* merge in the 4 cities data;
use /groups/brooksgrp/zoning/streetcar_stops/streetcar_shapefile_maps/pe_points_w_4_minor_cities_marked/2013-03-12_1928_pe_points_4_cities_marked.dta;
gen pestop_id_1 = _n - 1;
sum pestop_id_1, det;
codebook pestop_id_1;
keep pestop_id_1 in4cities;
save fourcities_temp, replace;

use /groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/scar_revmgd_`paneldt'_2011_xsec.dta;
sort pestop_id_1;
merge m:1 pestop_id_1 using fourcities_temp;
tab _merge if pestop_id_1 ~= .;
* need to add this so we dont add no ain obs *;
drop if _merge == 2;
drop _merge;
!rm fourcities_temp.dta;
compress;
save /groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/scar_revmgd_`paneldt'_2011_xsec.dta, replace;


******************************************************;
* Create the panel dataset with sales values         *;
******************************************************;
use if sale_year >= 1999 
   using ${temp}/scardats;
save /groups/brooksgrp/zoning/parcel_datasets/streetcars/revised_merged_dataset/scar_revmgd_`paneldt'_sales_panel.dta, replace;


******************************************************;
* get rid of junk ************************************;
******************************************************;

! rm /scratch/scar*;

log close;
