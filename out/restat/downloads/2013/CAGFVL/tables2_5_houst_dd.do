 /*****************************************************************************
 This program creates the new Houston tables 2 through 5 for the version of 
 the paper using the DD method created for the revise and resubmit at ReStat. 
 Josh Hyman, May 2009
*****************************************************************************/

# delimit ;

clear;
capture log close;
set mem 1700m;
set more off;
set mat 8000;
program drop _all;
macro drop _all;

log using tables2_5_houst_dd.log, replace;

display "$S_TIME  $S_DATE";

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


!gunzip ${bulk}new_vars_houston2.dta.gz;
 use ${bulk}new_vars_houston2.dta;


****run regressions****;

foreach d in ngviolent gviolent property {;
   if "`d'"=="ngviolent" {; local dth="# Non-Gun Violent Crimes"; };
   if "`d'"=="gviolent" {; local dth="# Gun Violent Crimes"; };
   if "`d'"=="property" {; local dth="# Property Crimes"; };
/*
   foreach x in 5 7 8 10 5_10 7_15 {;

      **BASELINE - CREATES RESULTS FOR TABLES ;
      disp "`dth', in Houston, in `x' mile radius";
      areg `d' closeshows`x'_post_month closeshows`x'_postpre_month mm_* if tract_has_closeshow`x'==1, a(ty) cluster(census_tract);
      estimates store main_`d'_`x';
      egen temp`d'_`x' = tag(census_tract) if e(sample);
      count if temp`d'_`x'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;

      **SAME BUT WEIGHT REGS BY POPULATION;
      disp "`dth', in Houston, WGT, in `x' mile radius";
      areg `d' closeshows`x'_post_month closeshows`x'_postpre_month mm_* if tract_has_closeshow`x'==1 [aw=p_total], 
       a(ty) cluster(census_tract);
      estimates store main_`d'_wgt_`x';
      egen temp`d'_`x'_wgt = tag(census_tract) if e(sample);
      count if temp`d'_`x'_wgt==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
   };



     
    **TABLE 4 - SPLIT BY POVERTY;    
    foreach p in povpct<15 povpct>=15 {;
      if "`p'"=="povpct<15" {; local cat="cat1"; };
      if "`p'"=="povpct>=15" {; local cat="cat2"; };
       
      disp "`dth', Houston, in 5 Mile Radius, `p'";
      areg `d' closeshows5_post_month closeshows5_postpre_month mm_* if tract_has_closeshow5==1 & `p', a(ty) cluster(census_tract);
      estimates store rp_`d'`cat';
      egen temp`d'`st'`table'`cat' = tag(census_tract) if e(sample);
      count if temp`d'`cat'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end rural/poverty split loop;
      
    **TABLE 5 - SPLIT BY YEAR;
    foreach y in "year<2000" "year>=2000" {;
      if "`y'"=="year<2000" {; local yr="1994-1999"; local yr2="90s"; };
      if "`y'"=="year>=2000" {; local yr="2000-2004"; local yr2="00s"; };

      disp "`dth', In Houston, `yr'";
      areg `d' closeshows5_post_month closeshows5_postpre_month mm_* if tract_has_closeshow5==1 & `y', a(ty) cluster(census_tract);
      estimates store yr_`d'`yr2';
      egen temp`d'`yr2' = tag(census_tract) if e(sample);
      count if temp`d'`yr2'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end year split;
 
 
    **SPLIT BY MODEL - TABLE 3;
    disp "BASELINE, `dth', In Houston, In 5 Mile Area";
    areg `d' closeshows5_post_month closeshows5_postpre_month mm_* if tract_has_closeshow5==1, a(ty) cluster(census_tract);
    estimates store mdls_`d'bln;
    egen temp`d'bln = tag(census_tract) if e(sample);
    count if temp`d'bln==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "BASELINE WEIGHTED, `dth', In Houston, In 5 Mile area";
    areg `d' closeshows5_post_month closeshows5_postpre_month mm_* if tract_has_closeshow5==1 [aw=p_total], 
     a(ty) cluster(census_tract);
    estimates store mdls_`d'wtd;
    egen temp`d'wtd = tag(census_tract) if e(sample);
    count if temp`d'wtd==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;
*/
    tsset, clear; *THIS COMMAND MIGHT BE UNNECESSARY;
    
    disp "NEGATIVE BINOMIAL, `dth', In Houston, In 5 MILE AREA";
    bootstrap, reps(100) cluster(census_tract): xtnbreg `d' closeshows5_post_month closeshows5_postpre_month mm_* if tract_has_closeshow5==1,
     irr iterate(50) fe i(ty);
    estimates store mdls_`d'nb;
    egen temp`d'nb = tag(census_tract) if e(sample);
    count if temp`d'nb==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "POISSON, `dth', In Houston, IN 5 MILE AREA";
    bootstrap, reps(100) cluster(census_tract): xtpoisson `d' closeshows5_post_month closeshows5_postpre_month mm_* 
     if tract_has_closeshow5==1, irr iterate(50) fe i(ty);
    estimates store mdls_`d'psn;
    egen temp`d'psn = tag(census_tract) if e(sample);
    count if temp`d'psn==1;
    gen tagnl_`d' = 1 if e(sample);
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;
/*
    disp "BASELINE ON LIMITED-NON-LINEAR SAMPLE, `dth', In Houston, IN 5 MILE AREA";
    areg `d' closeshows5_post_month closeshows5_postpre_month mm_* if tract_has_closeshow5==1 & tagnl_`d'`st'==1, 
     a(ty) cluster(census_tract);
    estimates store lmtd_`d';
    egen temp`d'lmtd = tag(census_tract) if e(sample);
    count if temp`d'lmtd==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;
*/
}; *end crime loop;  



**Create Tables;
/*
*TABLE 2;
estout main* using ${tables}tbl_houst2dd.txt, cells(b(star fmt(%9.4f)) se(par)) replace 
 keep(closeshows5_post_month closeshows7_post_month closeshows8_post_month closeshows10_post_month closeshows5_10_post_month 
 closeshows7_15_post_month ) starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*TABLE 3 - COLUMNS 1,2,5,6,7,10;
estout mdls*bln mdls*wtd lmtd* using ${tables}tbl_houst3a_dd.txt, cells(b(star fmt(%9.4f)) se(par)) replace drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
*/
*TABLE 3 - COLUMNS 3,4,8,9;
estout mdls*nb mdls*psn using ${tables}tbl_houst3b_dd.txt, cells(b(star fmt(%9.3f)) p(par)) replace eform drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
/*
*TABLE 4;
estout rp* using ${tables}tbl_houst4dd.txt, cells(b(star fmt(%9.4f)) se(par)) replace keep(closeshows5_post_month)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*TABLE 5;
estout yr* using ${tables}tbl_houst5dd.txt, cells(b(star fmt(%9.4f)) se(par)) replace keep(closeshows5_post_month)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
*/
*!gzip ${bulk}new_vars_houston2.dta;

display "$S_TIME  $S_DATE";
log close;










