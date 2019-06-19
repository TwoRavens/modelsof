 /*****************************************************************************
 This program creates Appendix table 4 of the new tables for the Revise and Resubmit
 version of the paper.
 Josh Hyman, May 2009
*****************************************************************************/

# delimit ;

clear;
capture log close;
set mem 5000m;
set more off;
set mat 8000;
program drop _all;
macro drop _all;

log using rr_apptable4_dd.log, replace;


global n=2;

if $n==1{;
   global desktop "C:\Documents and Settings\jmhyman\Desktop\Gunshows\";
};

if $n==2{;
   global bulk "/disk/homes2b/nber/bajacob/bulk/gunshows/";
   global gun "/disk/homes2b/nber/bajacob/gunshows/";
   global josh "/disk/homes2b/nber/bajacob/gunshows/josh/";
   global mark_files "/disk/homes2b/nber/bajacob/gunshows/josh/mark_files/";
   global tables "/disk/homes2b/nber/bajacob/gunshows/josh/tables/raw_tables/";
   global mortality "/disk/homes2b/nber/bajacob/gunshows/mortality/";
   global rr "/disk/homes2b/nber/bajacob/gunshows/josh/revise_resubmit/";
   global mortality "/disk/homes2b/nber/bajacob/gunshows/mortality/";
};

!gunzip ${bulk}rr_new_vars.dta.gz;
 use ${bulk}rr_new_vars.dta;

**keep relevant obs;
keep if zip_has_closeshow10==1;

**keep relevant variables **Memory becomes an issue here so drop unnecessary variables;

keep zcta5 cont_week state year zy closeshows10_post_month closeshows10_postpre_month ghomicide gsuicide mm_* zip_has_closeshow10;
describe;

compress;

*Create some extra fixed effects for Robustness table;
**create a week_of_the_year variable;

gen woy = cont_week;
replace woy = woy-52 if woy>=53 & woy<=104 ;
replace woy = woy-104 if woy>=105 & woy<=156;
replace woy = woy-156 if woy>=157 & woy<=208 ;
replace woy = woy-208 if woy>=209 & woy<=260 ;
replace woy = woy-260 if woy>=261 & woy<=312 ;

**** NOTE: 1999 has 53 weeks*******
**** classifying 53rd week as 52, so 1999 will have two week 52s **;
replace woy = 52 if woy==313 ;

replace woy = woy-313 if woy>=314 & woy<=365 ;
replace woy = woy-365 if woy>=366 & woy<=417 ;
replace woy = woy-417 if woy>=418 & woy<=469 ;
replace woy = woy-469 if woy>=470 & woy<=521 ;
replace woy = woy-519 if woy>=522 & woy<=572 ;
tab woy, m;

tab woy, gen(woy_);
compress;

tab year, gen(year_);
tab cont_week, gen(cont_week_);

compress; 
  
describe;

**notice cont_week_1 actually refers to observations with a value of 10 for cont_week, similarly cont_week_554 refers to those 
 with a value of 563 for cont_week. This is because we dropped the first nine weeks from the sample.;


**run regressions;


**BOTH STATES SEPARATELY;

foreach s in ca tx{;
  if "`s'"=="ca" {; local st_name="CALIFORNIA"; };
  if "`s'"=="tx" {; local st_name="TEXAS"; };
  
  foreach d in ghomicide gsuicide {;
    if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; local short="ghom"; local adth="Gun Homicide";};
    if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; local short="gsuic"; local adth="Gun Suicide";};
    
    **SPEC2: MONTH, YEAR, ZIP FEs;
    disp "SPEC2, `dth' `st_name'";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* year_* if zip_has_closeshow10==1 & state=="`s'", 
       a(zcta5) cluster(zcta5);
      estimates store rbst_`table'`d'`s'2;
      egen temp`d'`s'`table'2 = tag(zcta5) if e(sample);
      count if temp`d'`s'`table'2==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    
      **SPEC3: WEEK (1-573), ZIP FEs;
      disp "SPEC3, `dth' `st_name'";
      areg `d' closeshows10_post_month closeshows10_postpre_month cont_week_1-cont_week_554 if zip_has_closeshow10==1 & state=="`s'", 
       a(zcta5) cluster(zcta5);
      estimates store rbst_`table'`d'`s'3;
      egen temp`d'`s'`table'3 = tag(zcta5) if e(sample);
      count if temp`d'`s'`table'3==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    
      **SPEC4: WEEK (1-52), YEAR*ZIP FEs;
      disp "SPEC4, `dth' `st_name'";
      areg `d' closeshows10_post_month closeshows10_postpre_month woy_* if zip_has_closeshow10==1 & state=="`s'", a(zy) cluster(zcta5);
      estimates store rbst_`table'`d'`s'4;
      egen temp`d'`s'`table'4 = tag(zcta5) if e(sample);
      count if temp`d'`s'`table'4==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;

    }; *end homicide/suicide loop;
}; *end state loop;





*BOTH STATES COMBINED;

  
  foreach d in ghomicide gsuicide {;
    if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; local short="ghom"; local adth="Gun Homicide";};
    if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; local short="gsuic"; local adth="Gun Suicide";};
    
    **SPEC2: MONTH, YEAR, ZIP FEs;
    disp "SPEC2, `dth' BOTH";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* year_* if zip_has_closeshow10==1 , a(zcta5) cluster(zcta5);
      estimates store rbst_`table'`d'both2;
      egen temp`d'both`table'2 = tag(zcta5) if e(sample);
      count if temp`d'both`table'2==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    
      **SPEC3: WEEK (1-573), ZIP FEs;
      disp "SPEC3, `dth' BOTH";
      areg `d' closeshows10_post_month closeshows10_postpre_month cont_week_1-cont_week_554 if zip_has_closeshow10==1 , 
       a(zcta5) cluster(zcta5);
      estimates store rbst_`table'`d'both3;
      egen temp`d'both`table'3 = tag(zcta5) if e(sample);
      count if temp`d'both`table'3==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    
      **SPEC4: WEEK (1-52), YEAR*ZIP FEs;
      disp "SPEC4, `dth' BOTH";
      areg `d' closeshows10_post_month closeshows10_postpre_month woy_* if zip_has_closeshow10==1 , a(zy) cluster(zcta5);
      estimates store rbst_`table'`d'both4;
      egen temp`d'both`table'4 = tag(zcta5) if e(sample);
      count if temp`d'both`table'4==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;

    }; *end homicide/suicide loop;


**Create Appendix Table 2 ;

estout rbst* using ${tables}tbl_fnl_rbstnss.txt, cells(b(star fmt(%9.4f)) se(par)) replace keep(closeshows10_post_month)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*!gzip new_vars.dta;
log close;










