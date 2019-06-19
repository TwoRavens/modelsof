 /*****************************************************************************
 This program creates the event study style figures for the "Revise and Resubmit" 
 version of the paper with 10 leads and lags, first TX and CA combined, then separately.
 It first creates OLS figures then Negative Binomial figures.
 Josh Hyman, last updated: May 2009
*****************************************************************************/

# delimit ;

clear;
capture log close;
set mem 5000m;
set more off;
set mat 8000;
program drop _all;
macro drop _all;

log using rr_figures.log, replace;

display "$S_TIME  $S_DATE";

global n=2;

if $n==1{;
   global desktop "C:\Documents and Settings\jmhyman\Desktop\Gunshows\";
};

if $n==2{;
   global bulk "/disk/homes2b/nber/bajacob/bulk/gunshows/"; 
   global josh "/disk/homes2b/nber/bajacob/gunshows/josh/";
   global mark_files "/disk/homes2b/nber/bajacob/gunshows/josh/mark_files/";
   global tables "/disk/homes2b/nber/bajacob/gunshows/josh/tables/raw_tables/";
   global mortality "/disk/homes2b/nber/bajacob/gunshows/mortality/";
   global rr "/disk/homes2b/nber/bajacob/gunshows/josh/revise_resubmit/";
};


!gunzip ${bulk}rr_new_vars.dta.gz;
use ${bulk}rr_new_vars.dta;


**** CREATE FIGURES USING OLS REGRESSIONS ****;

  foreach x in /*zip_has_show zip_has_closeshow5*/ zip_has_closeshow10 /*zip_has_closeshow25*/ {;
    if "`x'"=="zip_has_show" {; local name="In Zip Code"; local varname="anyshow"; local numshow="numshows"; local table="a"; };
    if "`x'"=="zip_has_closeshow5" {; local name="In 5 Mile Area"; local varname="anycloseshow5"; local numshow="closeshows5";
     local table="b"; };
    if "`x'"=="zip_has_closeshow10" {; local name="In 10 Mile Area"; local varname="anycloseshow10"; local numshow="closeshows10";
     local table="c"; };
    if "`x'"=="zip_has_closeshow25" {; local name="In 25 Mile Area"; local varname="anycloseshow25"; local numshow="closeshows25";
     local table="d"; }; 

    foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="Non-Gun Suicides"; };
      
      preserve;
      disp "`dth' BOTH STATES, `name'";
      areg `d' `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 
      `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 `numshow'_post1 `numshow'_post2 `numshow'_post3 
      `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 `numshow'_post8 `numshow'_post9  mm_* if `x'==1, 
      a(zy) cluster(zcta5);
      *estimates store main_`table'`d'both;
      *FOR EACH REGRESSOR GENERATE VARIABLES EQUAL TO ITS COEFFICIENT, AND UPPER AND LOWER CONFIDENCE INTERVAL;
      foreach b in `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 
      `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 `numshow'_post1 `numshow'_post2 `numshow'_post3 
      `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 `numshow'_post8 `numshow'_post9 {;
         gen b_`b' = _b[`b'];
	 gen u_`b' = b_`b' + ( _se[`b'] * 1.96 );
	 gen d_`b' = b_`b' - ( _se[`b'] * 1.96 );
      };
      *KEEP ONLY THE REGRESSION COEFFICIENTS AND CONFIDENCE INTERVALS;
      keep b_* u_* d_*;
      *COLLAPSE DOWN TO ONE OBS PER REGRESSOR;
      collapse b_* u_* d_*;
      *CREATE THREE DATASETS, ONE W/THE COEFFICIENTS, AND ONE W/EACH CI. FOR EACH DATASET, 
       SWITH THE VARS INTO OBS, SO THAT EACH REGRESSOR BECOMES AN OBS
       AND CREATE AN X VARIABLE THAT REPRESENTS THE REGRESSORS (LAGS/LEADS);;
      tempfile temp_bud;
      save "`temp_bud'";
      keep b_*;
      xpose, clear;
      rename v1 beta;
      gen lag_lead = _n - 11;
      tempfile temp_b;
      save "`temp_b'";
      use "`temp_bud'", clear;
      keep u_*;
      xpose, clear;
      rename v1 upper_ci;
      gen lag_lead = _n - 11;
      tempfile temp_u;
      save "`temp_u'";
      use "`temp_bud'", clear;
      keep d_*;
      xpose, clear;
      rename v1 lower_ci;
      gen lag_lead = _n - 11;
      tempfile temp_d;
      save "`temp_d'";      

      use "`temp_b'", clear;
      mmerge lag_lead using "`temp_u'", type(1:1);
      mmerge lag_lead using "`temp_d'", type(1:1);
      list;      
      twoway (line beta lag_lead, lcolor(black) lpattern(solid))
       (line upper_ci lag_lead, lcolor(black) lpattern(dash))
       (line lower_ci lag_lead, lcolor(black) lpattern(dash)),
       title("Outcome = Number of `dth'")
       xtitle(# Weeks Pre/Post Gun Show)
       ytitle(Coefficient on Lead/Lag)
       yscale(/* range(-.004 .004)*/ titlegap(2) )
       /*ylabel(-.004 (.002) 0.004)  
       ytick (-.004 (.002) 0.004)*/
       xscale( titlegap(2) )
       legend(off) yline(0);
      
      graph export ${tables}graphols_txca_final_`d'.eps, replace;
      
      *egen temp`d'both`table' = tag(zcta5) if e(sample);
      *count if temp`d'both`table'==1;
      *sum `d' if e(sample);
      *gen mean_`d' = r(mean);
      *gen sd_`d' = r(sd);
     
      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      *tab1 mean_* sd_*;
      *drop mean_* sd_*;
      restore; 
      *CONVERT EPS TO PDF FILES;
     !epstopdf /disk/homes2b/nber/bajacob/gunshows/josh/tables/raw_tables/graphols_txca_final_`d'.eps;

    }; *close gun/non-gun loop;
  }; *close zip/10 mile loop;


/*
foreach s in ca tx {;
  if "`s'"=="tx" {; local st_name="Texas"; };
  if "`s'"=="ca" {; local st_name="California"; };

  foreach x in zip_has_show zip_has_closeshow5 zip_has_closeshow10 zip_has_closeshow25{;
    if "`x'"=="zip_has_show" {; local name="In Zip Code"; local varname="anyshow"; local numshow="numshows"; local table="a"; };
    if "`x'"=="zip_has_closeshow5" {; local name="In 5 Mile Area"; local varname="anycloseshow5"; local numshow="closeshows5";
     local table="b"; };
    if "`x'"=="zip_has_closeshow10" {; local name="In 10 Mile Area"; local varname="anycloseshow10"; local numshow="closeshows10";
     local table="c"; };
    if "`x'"=="zip_has_closeshow25" {; local name="In 25 Mile Area"; local varname="anycloseshow25"; local numshow="closeshows25";
     local table="d"; };

    foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
      
      preserve;
      disp "`dth', `st_name', `name'";
      areg `d' `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 
      `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 `numshow'_post1 `numshow'_post2 `numshow'_post3 
      `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 `numshow'_post8 `numshow'_post9  mm_* if `x'==1 & state=="`s'", 
      a(zy) cluster(zcta5);
      *estimates store main_`table'`d'`s';
      *FOR EACH REGRESSOR GENERATE VARIABLES EQUAL TO ITS COEFFICIENT, AND UPPER AND LOWER CONFIDENCE INTERVAL;
      foreach b in `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 
      `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 `numshow'_post1 `numshow'_post2 `numshow'_post3 
      `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 `numshow'_post8 `numshow'_post9 {;
         gen b_`b' = _b[`b'];
         gen u_`b' = b_`b' + ( _se[`b'] * 1.96 );
         gen d_`b' = b_`b' - ( _se[`b'] * 1.96 );
      };
      *KEEP ONLY THE REGRESSION COEFFICIENTS AND CONFIDENCE INTERVALS;
      keep b_* u_* d_*;
      *COLLAPSE DOWN TO ONE OBS PER REGRESSOR;
      collapse b_* u_* d_*;
      *CREATE THREE DATASETS, ONE W/THE COEFFICIENTS, AND ONE W/EACH CI. FOR EACH DATASET, 
       SWITH THE VARS INTO OBS, SO THAT EACH REGRESSOR BECOMES AN OBS
       AND CREATE AN X VARIABLE THAT REPRESENTS THE REGRESSORS (LAGS/LEADS);;
      tempfile temp_bud;
      save "`temp_bud'";
      keep b_*;
      xpose, clear;
      rename v1 beta;
      gen lag_lead = _n - 11;
      tempfile temp_b;
      save "`temp_b'";
      use "`temp_bud'", clear;
      keep u_*;
      xpose, clear;
      rename v1 upper_ci;
      gen lag_lead = _n - 11;
      tempfile temp_u;
      save "`temp_u'";
      use "`temp_bud'", clear;
      keep d_*;
      xpose, clear;
      rename v1 lower_ci;
      gen lag_lead = _n - 11;
      tempfile temp_d;
      save "`temp_d'";      

      use "`temp_b'", clear;
      mmerge lag_lead using "`temp_u'", type(1:1);
      mmerge lag_lead using "`temp_d'", type(1:1);
      list;      
      twoway (line beta lag_lead, lcolor(black) lpattern(solid))
       (line upper_ci lag_lead, lcolor(black) lpattern(dash))
       (line lower_ci lag_lead, lcolor(black) lpattern(dash)),
       title("`dth' in `st_name', `name'")
       xtitle(# Weeks Pre/Post Gunshow Week)
       ytitle(Coefficient on Lead/Lag)
       legend(off) yline(0);
      
      graph export ${tables}graphols_`s'_`d'_`table'.eps, replace;
      
      *egen temp`d'`s'`table' = tag(zcta5) if e(sample);
      *count if temp`d'`s'`table'==1;
      *sum `d' if e(sample);
      *gen mean_`d' = r(mean);
      *gen sd_`d' = r(sd);
     
      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      *tab1 mean_* sd_*;
      *drop mean_* sd_*;
      restore; 
    }; *close gun/non-gun loop;
  }; *close zip/10 mile loop;
}; *end state loop;  
*/

/*
*** CREATE FIGURES USING NEGATIVE BINOMIAL REGRESSIONS ***;

  foreach x in /* zip_has_show zip_has_closeshow5 */ zip_has_closeshow10 /* zip_has_closeshow25 */ {;
    if "`x'"=="zip_has_show" {; local name="In Zip Code"; local varname="anyshow"; local numshow="numshows"; local table="a"; };
    if "`x'"=="zip_has_closeshow5" {; local name="In 5 Mile Area"; local varname="anycloseshow5"; local numshow="closeshows5";
     local table="b"; };
    if "`x'"=="zip_has_closeshow10" {; local name="In 10 Mile Area"; local varname="anycloseshow10"; local numshow="closeshows10";
     local table="c"; };
    if "`x'"=="zip_has_closeshow25" {; local name="In 25 Mile Area"; local varname="anycloseshow25"; local numshow="closeshows25";
     local table="d"; };

    foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
      
      preserve;

      tsset, clear;
      disp "`dth' BOTH STATES, `name'";
      bootstrap, reps(100) cluster(zcta5): xtnbreg `d' `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 
       `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 
       `numshow'_post1 `numshow'_post2 `numshow'_post3 `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 
       `numshow'_post8 `numshow'_post9 mm_* if zip_has_closeshow10==1, irr iterate(50) fe i(zy);
      *estimates store main_`table'`d'both;
      *FOR EACH REGRESSOR GENERATE VARIABLES EQUAL TO ITS COEFFICIENT, AND UPPER AND LOWER CONFIDENCE INTERVAL;
      foreach b in `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 
      `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 `numshow'_post1 `numshow'_post2 `numshow'_post3 
      `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 `numshow'_post8 `numshow'_post9 {;
         gen b_`b' = _b[`b'];
	 gen u_`b' = b_`b' + ( _se[`b'] * 1.96 );
	 gen d_`b' = b_`b' - ( _se[`b'] * 1.96 );
      };
      *KEEP ONLY THE REGRESSION COEFFICIENTS AND CONFIDENCE INTERVALS;
      keep b_* u_* d_*;
      *COLLAPSE DOWN TO ONE OBS PER REGRESSOR;
      collapse b_* u_* d_*;
      *CREATE THREE DATASETS, ONE W/THE COEFFICIENTS, AND ONE W/EACH CI. FOR EACH DATASET, 
       SWITH THE VARS INTO OBS, SO THAT EACH REGRESSOR BECOMES AN OBS
       AND CREATE AN X VARIABLE THAT REPRESENTS THE REGRESSORS (LAGS/LEADS);;
      tempfile temp_bud;
      save "`temp_bud'";
      keep b_*;
      xpose, clear;
      rename v1 beta;
      gen lag_lead = _n - 11;
      tempfile temp_b;
      save "`temp_b'";
      use "`temp_bud'", clear;
      keep u_*;
      xpose, clear;
      rename v1 upper_ci;
      gen lag_lead = _n - 11;
      tempfile temp_u;
      save "`temp_u'";
      use "`temp_bud'", clear;
      keep d_*;
      xpose, clear;
      rename v1 lower_ci;
      gen lag_lead = _n - 11;
      tempfile temp_d;
      save "`temp_d'";      

      use "`temp_b'", clear;
      mmerge lag_lead using "`temp_u'", type(1:1);
      mmerge lag_lead using "`temp_d'", type(1:1);
      list;      
      twoway (line beta lag_lead, lcolor(black) lpattern(solid))
       (line upper_ci lag_lead, lcolor(black) lpattern(dash))
       (line lower_ci lag_lead, lcolor(black) lpattern(dash)),
       title("`dth' in TX and CA, `name'")
       xtitle(# Weeks Pre/Post Gunshow Week)
       ytitle(Coeff. on Lead/Lag Dummy)
       legend(off) yline(0);
      
      graph export ${tables}graphnb_both_`d'_`table'.eps, replace;
      
      *egen temp`d'both`table' = tag(zcta5) if e(sample);
      *count if temp`d'both`table'==1;
      *sum `d' if e(sample);
      *gen mean_`d' = r(mean);
      *gen sd_`d' = r(sd);
     
      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      *tab1 mean_* sd_*;
      *drop mean_* sd_*;
      restore; 
    }; *close gun/non-gun loop;
  }; *close zip/10 mile loop;


foreach s in ca tx {;
  if "`s'"=="tx" {; local st_name="Texas"; };
  if "`s'"=="ca" {; local st_name="California"; };

  foreach x in zip_has_show zip_has_closeshow5 zip_has_closeshow10 zip_has_closeshow25{;
    if "`x'"=="zip_has_show" {; local name="In Zip Code"; local varname="anyshow"; local numshow="numshows"; local table="a"; };
    if "`x'"=="zip_has_closeshow5" {; local name="In 5 Mile Area"; local varname="anycloseshow5"; local numshow="closeshows5";
     local table="b"; };
    if "`x'"=="zip_has_closeshow10" {; local name="In 10 Mile Area"; local varname="anycloseshow10"; local numshow="closeshows10";
     local table="c"; };
    if "`x'"=="zip_has_closeshow25" {; local name="In 25 Mile Area"; local varname="anycloseshow25"; local numshow="closeshows25";
     local table="d"; };

    foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
      
      preserve;
      display "$S_TIME  $S_DATE";
      disp "`dth', `st_name', `name'";
      bootstrap, reps(100) cluster(zcta5): xtnbreg `d' `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7
       `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0
       `numshow'_post1 `numshow'_post2 `numshow'_post3 `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7
       `numshow'_post8 `numshow'_post9 mm_* if zip_has_closeshow10==1 & state=="`s'", irr iterate(50) fe i(zy);
      display "$S_TIME  $S_DATE";
      *estimates store main_`table'`d'`s';
      *FOR EACH REGRESSOR GENERATE VARIABLES EQUAL TO ITS COEFFICIENT, AND UPPER AND LOWER CONFIDENCE INTERVAL;
      foreach b in `numshow'_pre10 `numshow'_pre9 `numshow'_pre8 `numshow'_pre7 `numshow'_pre6 `numshow'_pre5 `numshow'_pre4 
      `numshow'_pre3 `numshow'_pre2 `numshow'_pre1 `numshow'_post0 `numshow'_post1 `numshow'_post2 `numshow'_post3 
      `numshow'_post4 `numshow'_post5 `numshow'_post6 `numshow'_post7 `numshow'_post8 `numshow'_post9 {;
         gen b_`b' = _b[`b'];
         gen u_`b' = b_`b' + ( _se[`b'] * 1.96 );
         gen d_`b' = b_`b' - ( _se[`b'] * 1.96 );
      };
      *KEEP ONLY THE REGRESSION COEFFICIENTS AND CONFIDENCE INTERVALS;
      keep b_* u_* d_*;
      *COLLAPSE DOWN TO ONE OBS PER REGRESSOR;
      collapse b_* u_* d_*;
      *CREATE THREE DATASETS, ONE W/THE COEFFICIENTS, AND ONE W/EACH CI. FOR EACH DATASET, 
       SWITH THE VARS INTO OBS, SO THAT EACH REGRESSOR BECOMES AN OBS
       AND CREATE AN X VARIABLE THAT REPRESENTS THE REGRESSORS (LAGS/LEADS);;
      tempfile temp_bud;
      save "`temp_bud'";
      keep b_*;
      xpose, clear;
      rename v1 beta;
      gen lag_lead = _n - 11;
      tempfile temp_b;
      save "`temp_b'";
      use "`temp_bud'", clear;
      keep u_*;
      xpose, clear;
      rename v1 upper_ci;
      gen lag_lead = _n - 11;
      tempfile temp_u;
      save "`temp_u'";
      use "`temp_bud'", clear;
      keep d_*;
      xpose, clear;
      rename v1 lower_ci;
      gen lag_lead = _n - 11;
      tempfile temp_d;
      save "`temp_d'";      

      use "`temp_b'", clear;
      mmerge lag_lead using "`temp_u'", type(1:1);
      mmerge lag_lead using "`temp_d'", type(1:1);
      list;      
      twoway (line beta lag_lead, lcolor(black) lpattern(solid))
       (line upper_ci lag_lead, lcolor(black) lpattern(dash))
       (line lower_ci lag_lead, lcolor(black) lpattern(dash)),
       title("`dth' in `st_name', `name'")
       xtitle(# Weeks Pre/Post Gunshow Week)
       ytitle(Coeff. on Lead/Lag Dummy)
       legend(off) yline(0);
      
      graph export ${tables}graphnb_`s'_`d'_`table'.eps, replace;
      
      *egen temp`d'`s'`table' = tag(zcta5) if e(sample);
      *count if temp`d'`s'`table'==1;
      *sum `d' if e(sample);
      *gen mean_`d' = r(mean);
      *gen sd_`d' = r(sd);
     
      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      *tab1 mean_* sd_*;
      *drop mean_* sd_*;
      restore; 
    }; *close gun/non-gun loop;
  }; *close zip/10 mile loop;
}; *end state loop;  
*/

*!gzip ${bulk}rr_new_vars.dta;

display "$S_TIME  $S_DATE";
log close;



END;






