 /*****************************************************************************
 This program creates the event study style figures for the "Revise and Resubmit" 
 version of the paper with 10 leads and lags, first TX and CA combined, then separately.
 It first creates OLS figures then Negative Binomial figures.
 Josh Hyman, last updated: May 2009
*****************************************************************************/

# delimit ;

clear;
capture log close;
set mem 1000m;
set more off;
set mat 8000;
program drop _all;
macro drop _all;

log using houst_figures2.log, replace;

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


!gunzip ${bulk}new_vars_houston2.dta.gz;
use ${bulk}new_vars_houston2.dta;


**** CREATE FIGURES USING OLS REGRESSIONS ****;

foreach d in /*ngviolent*/ gviolent /*property*/ /*homicide ghomicide rape grape robbery grobbery assault gassault burglary theft auto */{;
      if "`d'"=="ngviolent" {; local dth="Non-Gun Violent Crimes"; };
      if "`d'"=="gviolent" {; local dth="Gun Violent Crimes"; };
      if "`d'"=="property" {; local dth="Property Crimes"; };
/*
      if "`d'"=="homicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="rape" {; local dth="# Forcible Rapes"; };
      if "`d'"=="grape" {; local dth="# Gun Forcible Rapes"; };
      if "`d'"=="robbery" {; local dth="# Robberies"; };
      if "`d'"=="grobbery" {; local dth="# Gun Robberies"; };
      if "`d'"=="assault" {; local dth="# Assaults"; };
      if "`d'"=="gassault" {; local dth="# Gun Assaults"; };
      if "`d'"=="burglary" {; local dth="# Burglaries"; };
      if "`d'"=="theft" {; local dth="# Thefts, Excluding Auto"; };
      if "`d'"=="auto" {; local dth="# Auto Thefts"; };
  */   
      preserve;
      disp "`dth', Houston";     
      areg `d' closeshows5_pre10 closeshows5_pre9 closeshows5_pre8 closeshows5_pre7 closeshows5_pre6 closeshows5_pre5 closeshows5_pre4 
      closeshows5_pre3 closeshows5_pre2 closeshows5_pre1 closeshows5_post0 closeshows5_post1 closeshows5_post2 closeshows5_post3 
      closeshows5_post4 closeshows5_post5 closeshows5_post6 closeshows5_post7 closeshows5_post8 closeshows5_post9  mm_* if
       tract_has_closeshow5==1, 
      a(ty) cluster(census_tract);
      *estimates store main_`table'`d'both;
      *FOR EACH REGRESSOR GENERATE VARIABLES EQUAL TO ITS COEFFICIENT, AND UPPER AND LOWER CONFIDENCE INTERVAL;
      foreach b in closeshows5_pre10 closeshows5_pre9 closeshows5_pre8 closeshows5_pre7 closeshows5_pre6 closeshows5_pre5 closeshows5_pre4 
      closeshows5_pre3 closeshows5_pre2 closeshows5_pre1 closeshows5_post0 closeshows5_post1 closeshows5_post2 closeshows5_post3 
      closeshows5_post4 closeshows5_post5 closeshows5_post6 closeshows5_post7 closeshows5_post8 closeshows5_post9 {;
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
       yscale( range(-0.04 0.04) titlegap(2) )
       ylabel(-0.04 (0.02) 0.04)
       /*ytick (-0.04 (0.02) 0.04)*/
       xscale( titlegap(2) )
       legend(off) yline(0);
       graph export ${tables}graphols_houst_final_`d'2.eps, replace;

      *CONVERT EPS TO PDF FILES;
     !epstopdf /disk/homes2b/nber/bajacob/gunshows/josh/tables/raw_tables/graphols_houst_final_`d'2.eps;

      restore; 
  }; *close crime loop;





/*

*** CREATE FIGURES USING NEGATIVE BINOMIAL REGRESSIONS ***;

foreach d in ngviolent gviolent property /*homicide ghomicide rape grape robbery grobbery assault gassault burglary theft auto */{;
      if "`d'"=="ngviolent" {; local dth="# Non-Gun Violent Crimes"; };
      if "`d'"=="gviolent" {; local dth="# Gun Violent Crimes"; };
      if "`d'"=="property" {; local dth="# Property Crimes"; };
/*
      if "`d'"=="homicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="rape" {; local dth="# Forcible Rapes"; };
      if "`d'"=="grape" {; local dth="# Gun Forcible Rapes"; };
      if "`d'"=="robbery" {; local dth="# Robberies"; };
      if "`d'"=="grobbery" {; local dth="# Gun Robberies"; };
      if "`d'"=="assault" {; local dth="# Assaults"; };
      if "`d'"=="gassault" {; local dth="# Gun Assaults"; };
      if "`d'"=="burglary" {; local dth="# Burglaries"; };
      if "`d'"=="theft" {; local dth="# Thefts, Excluding Auto"; };
      if "`d'"=="auto" {; local dth="# Auto Thefts"; };
*/      
      preserve;

      tsset, clear;
      disp "`dth' Houston";
      bootstrap, reps(100) cluster(census_tract): xtnbreg `d' closeshows5_pre10 closeshows5_pre9 closeshows5_pre8 closeshows5_pre7 
       closeshows5_pre6 closeshows5_pre5 closeshows5_pre4 closeshows5_pre3 closeshows5_pre2 closeshows5_pre1 closeshows5_post0 
       closeshows5_post1 closeshows5_post2 closeshows5_post3 closeshows5_post4 closeshows5_post5 closeshows5_post6 closeshows5_post7 
       closeshows5_post8 closeshows5_post9 mm_* if tract_has_closeshow5==1, irr iterate(50) fe i(ty);
      *estimates store main_`table'`d'both;
      *FOR EACH REGRESSOR GENERATE VARIABLES EQUAL TO ITS COEFFICIENT, AND UPPER AND LOWER CONFIDENCE INTERVAL;
      foreach b in closeshows5_pre10 closeshows5_pre9 closeshows5_pre8 closeshows5_pre7 closeshows5_pre6 closeshows5_pre5 closeshows5_pre4 
      closeshows5_pre3 closeshows5_pre2 closeshows5_pre1 closeshows5_post0 closeshows5_post1 closeshows5_post2 closeshows5_post3 
      closeshows5_post4 closeshows5_post5 closeshows5_post6 closeshows5_post7 closeshows5_post8 closeshows5_post9 {;
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
       title("`dth' in Houston, In 5 Mile Radius, Neg. Bin.")
       xtitle(# Weeks Pre/Post Gunshow Week)
       ytitle(Coeff. on Lead/Lag Dummy)
       legend(off) yline(0);
      
      graph export ${tables}graphnb_houst_`d'.eps, replace;
      
      *egen temp`d'both`table' = tag(zcta5) if e(sample);
      *count if temp`d'both`table'==1;
      *sum `d' if e(sample);
      *gen mean_`d' = r(mean);
      *gen sd_`d' = r(sd);
     
      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      *tab1 mean_* sd_*;
      *drop mean_* sd_*;
      restore; 
  }; *close crime loop;
*/

*!gzip ${bulk}new_vars_Houston.dta;

display "$S_TIME  $S_DATE";
log close;




