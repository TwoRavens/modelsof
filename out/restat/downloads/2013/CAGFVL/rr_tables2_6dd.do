 /*****************************************************************************
 This program creates the DD baseline estimates  for the version of the paper created
 for the revise and resubmit at ReStat. Table 1 and Appendix tables 1 and 2 are 
 created in other do files.
 Josh Hyman, July 2009
*****************************************************************************/

# delimit ;

clear;
capture log close;
set mem 1700m;
set more off;
set mat 8000;
program drop _all;
macro drop _all;

log using rr_tables2_6dd.log, replace;

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


!gunzip ${bulk}rr_new_vars.dta.gz;
 use ${bulk}rr_new_vars.dta;


/*  THIS WAS NECESSASARY FOR THE AN OLD TABLE NO LONGER PRESENTED
**create interaction terms, needed for Table 6;
*STATES COMBINED;
foreach b in pc_rural frac_gsuicide {;
  if "`b'"=="pc_rural" {; local c="rl"; };
  if "`b'"=="frac_gsuicide" {; local c="su"; };

  egen mean_both_`c' = mean(`b') if `b'~=.;
  tab mean_both_`c';

  gen demean_both_`c' = `b' - mean_both_`c';

  foreach g in closeshows10_post_month closeshows10_postpre_month {;
    gen both`c'`g' = demean_both_`c' * `g';
  }; **end lags/leads loop;
}; ** end demographic vars loop;

*STATES SEPARATELY;
foreach s in tx ca {;
  foreach b in pc_rural frac_gsuicide {;
    if "`b'"=="pc_rural" {; local c="rl"; };
    if "`b'"=="frac_gsuicide" {; local c="su"; };

    egen mean_`s'_`c' = mean(`b') if state=="`s'" & `b'~=.;
    tab mean_`s'_`c';

    gen demean_`s'_`c' = `b' - mean_`s'_`c';
    
    foreach g in closeshows10_post_month closeshows10_postpre_month {;
      gen `s'`c'`g' = demean_`s'_`c' * `g';
    }; **end lags/leads loop;
  }; ** end demographic vars loop;
}; **end state loop;
  
**drop means and demeaned vars;
drop mean_* demean_*;
*/



****RUN REGRESSIONS****;


**BOTH STATES SEPARATELY;

foreach s in ca tx{;
  if "`s'"=="ca" {; local st_name="CALIFORNIA"; };
  if "`s'"=="tx" {; local st_name="TEXAS"; };
/*
  foreach x in zip_has_show zip_has_closeshow5 zip_has_closeshow10 zip_has_closeshow25 {;
    if "`x'"=="zip_has_show" {; local name="IN ZIP CODE"; local varname="anyshow"; local numshow="numshows"; local table="a"; };
    if "`x'"=="zip_has_closeshow5" {; local name="IN 5 MILE AREA"; local varname="anycloseshow5"; local numshow="closeshows5";
     local table="b"; };
    if "`x'"=="zip_has_closeshow10" {; local name="IN 10 MILE AREA"; local varname="anycloseshow10"; local numshow="closeshows10";
     local table="c"; };
    if "`x'"=="zip_has_closeshow25" {; local name="IN 25 MILE AREA"; local varname="anycloseshow25"; local numshow="closeshows25";
     local table="d"; };

    foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
      
      **TABLE 3 AND APPENDIX TABLE 2 - BASELINE RESULTS;
      disp "`dth' `st_name', `name'";
      areg `d' `numshow'_post_month `numshow'_postpre_month mm_* if `x'==1 & state=="`s'", a(zy) cluster(zcta5);
      estimates store main_`table'`d'`s';
      egen temp`d'`s'`table' = tag(zcta5) if e(sample);
      count if temp`d'`s'`table'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *close gun/non-gun loop;
  }; *close zip/distance loop;
*/
   foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
/*      
    **APPENDIX TABLE 5 - SPLIT BY RURAL/POVERTY;    
    foreach p in "pc_rural>=.3" "pc_rural<.3 & pc_blw_pov<.1" "pc_rural<.3 & pc_blw_pov>=.1" {;
      if "`p'"=="pc_rural>=.3" {; local cat="cat1"; };
      if "`p'"=="pc_rural<.3 & pc_blw_pov<.1" {; local cat="cat2"; };
      if "`p'"=="pc_rural<.3 & pc_blw_pov>=.1" {; local cat="cat3"; };
     
      disp "`dth' `st_name', 10 MILE RADIUS, `p'";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' & state=="`s'", a(zy) cluster(zcta5);
      estimates store rp_`table'`d'`s'`cat';
      egen temp`d'`s'`table'`cat' = tag(zcta5) if e(sample);
      count if temp`d'`s'`table'`cat'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end rural/poverty split loop;
*/  
    **APPENDIX TABLE 6 - SPLIT BY FRACTION GUN SUICIDE;
    sum frac_gsuicide if zip_has_closeshow10==1 & state=="ca", d; *25th percentile=.39, 75th percentile=.57;
    sum frac_gsuicide if zip_has_closeshow10==1 & state=="tx", d; *25th percentile=.51, 75th percentile=.70;
    
    if "`s'"=="ca" {;
      foreach p in "frac_gsuicide<.39" "frac_gsuicide>=.39 & frac_gsuicide<=.57" "frac_gsuicide>.57 & frac_gsuicide~=." {;
        if "`p'"=="frac_gsuicide<.39" {; local cat="low"; };
        if "`p'"=="frac_gsuicide>=.39 & frac_gsuicide<=.57" {; local cat="mid"; };
        if "`p'"=="frac_gsuicide>.57 & frac_gsuicide~=." {; local cat="high"; };

        disp "`dth' `st_name', 10 MILE RADIUS, `p'";
        areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' & state=="`s'", 
	 a(zy) cluster(zcta5);
        estimates store g_own_`table'`d'`s'`cat';
        egen temp`d'`s'`table'`cat' = tag(zcta5) if e(sample);
        count if temp`d'`s'`table'`cat'==1;
        sum `d' if e(sample);
        gen mean_`d' = r(mean);
        gen sd_`d' = r(sd);

        **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
        tab1 mean_* sd_*;
        drop mean_* sd_*;
      }; *end fraction gun suicide loop;
    }; *end if state = ca statement;

    if "`s'"=="tx" {;
      foreach p in "frac_gsuicide<.51" "frac_gsuicide>=.51 & frac_gsuicide<=.70" "frac_gsuicide>.70 & frac_gsuicide~=." {;
        if "`p'"=="frac_gsuicide<.51" {; local cat="low"; };
        if "`p'"=="frac_gsuicide>=.51 & frac_gsuicide<=.70" {; local cat="mid"; };
        if "`p'"=="frac_gsuicide>.70 & frac_gsuicide~=." {; local cat="high"; };

        disp "`dth' `st_name', 10 MILE RADIUS, `p'";
        areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' & state=="`s'",
         a(zy) cluster(zcta5);
        estimates store g_own_`table'`d'`s'`cat';
        egen temp`d'`s'`table'`cat' = tag(zcta5) if e(sample);
        count if temp`d'`s'`table'`cat'==1;
        sum `d' if e(sample);
        gen mean_`d' = r(mean);
        gen sd_`d' = r(sd);

        **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
        tab1 mean_* sd_*;
        drop mean_* sd_*;
      }; *end fraction gun suicide loop;
    }; *end if state = tx statement;
/*
    **APPENDIX TABLE 7 - SPLIT BY YEAR;
    foreach y in "year<2000" "year>=2000" {;
      if "`y'"=="year<2000" {; local yr="1994-1999"; local yr2="90s"; };
      if "`y'"=="year>=2000" {; local yr="2000-2004"; local yr2="00s"; };

      disp "`dth' `st_name', IN 10 MILE AREA, `yr'";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `y' & state=="`s'", a(zy) cluster(zcta5);
      estimates store yr_`table'`d'`s'`yr2';
      egen temp`d'`s'`table'`yr2' = tag(zcta5) if e(sample);
      count if temp`d'`s'`table'`yr2'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end year split;
*/  
    **APPENDIX TABLE 8 - SPLIT BY ZIP CODE POPULATION;
    sum p_total if zip_has_closeshow10==1 & state=="ca", d; *25th percentile=13119, 50th percentile=27452, 75th percentile=42727;
    sum p_total if zip_has_closeshow10==1 & state=="tx", d; *25th percentile=8251,  50th percentile=19023, 75th percentile=30420;

    if "`s'"=="ca" {;
      foreach p in "p_total<13119" "p_total>=13119 & p_total<27452" "p_total>=27452 & p_total<42727" "p_total>=42727" {;
        if "`p'"=="p_total<13119" {; local cat="1pop"; };
        if "`p'"=="p_total>=13119 & p_total<27452" {; local cat="2pop"; };
        if "`p'"=="p_total>=27452 & p_total<42727" {; local cat="3pop"; };
        if "`p'"=="p_total>=42727" {; local cat="4pop"; };

        disp "`dth' `st_name', 10 MILE RADIUS, `p'";
        areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' & state=="`s'",
         a(zy) cluster(zcta5);
        estimates store pop_`table'`d'`s'`cat';
        egen temp`d'`s'`table'`cat' = tag(zcta5) if e(sample);
        count if temp`d'`s'`table'`cat'==1;
        sum `d' if e(sample);
        gen mean_`d' = r(mean);
        gen sd_`d' = r(sd);
    
        **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
        tab1 mean_* sd_*;
        drop mean_* sd_*;
      }; *end fraction gun suicide loop;
    }; *end if state = ca statement;

    if "`s'"=="tx" {;
      foreach p in "p_total<8251" "p_total>=8251 & p_total<19023" "p_total>=19023 & p_total<30420" "p_total>=30420" {;
        if "`p'"=="p_total<8251" {; local cat="1pop"; };
        if "`p'"=="p_total>=8251 & p_total<19023" {; local cat="2dpop"; };
        if "`p'"=="p_total>=19023 & p_total<30420" {; local cat="3pop"; };
        if "`p'"=="p_total>=30420" {; local cat="4pop"; };

        disp "`dth' `st_name', 10 MILE RADIUS, `p'";
        areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' & state=="`s'",
         a(zy) cluster(zcta5);
        estimates store pop_`table'`d'`s'`cat';
        egen temp`d'`s'`table'`cat' = tag(zcta5) if e(sample);
        count if temp`d'`s'`table'`cat'==1;
        sum `d' if e(sample);
        gen mean_`d' = r(mean);
        gen sd_`d' = r(sd);

        **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
        tab1 mean_* sd_*;
        drop mean_* sd_*;
      }; *end fraction gun suicide loop;
    }; *end if state = tx statement;

/*
    **APPENDIX TABLE 3 - SPLIT BY MODEL;
    disp "BASELINE, `dth', `st_name', IN 10 MILE AREA";
    areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & state=="`s'", a(zy) cluster(zcta5);
    estimates store mdls_`table'`d'`s'bln;
    egen temp`d'`s'`table'bln = tag(zcta5) if e(sample);
    count if temp`d'`s'`table'bln==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "BASELINE WEIGHTED, `dth', `st_name', IN 10 MILE AREA";
    areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & state=="`s'" [aw=p_total], 
     a(zy) cluster(zcta5);
    estimates store mdls_`d'`s'wtd;
    egen temp`d'`s'`table'wtd = tag(zcta5) if e(sample);
    count if temp`d'`s'`table'wtd==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    tsset, clear; *THIS COMMAND MIGHT BE UNNECESSARY;
    
    disp "NEGATIVE BINOMIAL, `dth', `st_name', IN 10 MILE AREA";
    bootstrap, reps(100) cluster(zcta5): xtnbreg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 
     & state=="`s'", irr iterate(50) fe i(zy);
    estimates store mdls_`table'`d'`s'nb;
    egen temp`d'`s'`table'nb = tag(zcta5) if e(sample);
    count if temp`d'`s'`table'nb==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "POISSON, `dth', `st_name', IN 10 MILE AREA";
    bootstrap, reps(100) cluster(zcta5): xtpoisson `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 
     & state=="`s'", irr iterate(50) fe i(zy);
    estimates store mdls_`table'`d'`s'psn;
    egen temp`d'`s'`table'psn = tag(zcta5) if e(sample);
    count if temp`d'`s'`table'psn==1;
    gen tagnl_`d'`s' = 1 if e(sample);
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "BASELINE ON LIMITED-NON-LINEAR SAMPLE, `dth', `st_name', IN 10 MILE AREA";
    areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & state=="`s'" & tagnl_`d'`s'==1, 
     a(zy) cluster(zcta5);
    estimates store lmtd_`d'`s';
    egen temp`d'`s'lmtd = tag(zcta5) if e(sample);
    count if temp`d'`s'lmtd==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;
*/  
  
/* OLD NO LONGER PRESENTED
    **TABLE 7 - FRACTION GUN SUICIDE INTERACTIONS TABLE;
    disp "INTERACTIONS, FRAC_GUN_SUIC `dth', `st_name', IN 10 MILE AREA";
    areg `d' closeshows10_post_month `s'sucloseshows10_post_month closeshows10_postpre_month `s'sucloseshows10_postpre_month 
     mm_* if zip_has_closeshow10==1 & state=="`s'", a(zy) cluster(zcta5);
    estimates store ints_`table'`d'`s'frc;
    egen temp`d'`s'`table'frc = tag(zcta5) if e(sample);
    count if temp`d'`s'`table'frc==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);
    sum frac_gsuicide if e(sample), detail;
    foreach r in p10 p25 p50 p75 p90 {;
      gen pcntl_`r'`d'`s'su = r(`r');
    }; **end percentile loop;

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_* pcntl*;
    drop mean_* sd_* pcntl*;
    
    disp "INTERACTIONS, FRAC_GUN_SUIC and RURAL, `dth', `st_name', IN 10 MILE AREA";
    areg `d' closeshows10_post_month `s'sucloseshows10_post_month `s'rlcloseshows10_post_month closeshows10_postpre_month 
     `s'sucloseshows10_postpre_month `s'rlcloseshows10_postpre_month mm_* if zip_has_closeshow10==1 & state=="`s'", a(zy) cluster(zcta5);
    estimates store ints_`table'`d'`s'rl;
    egen temp`d'`s'`table'rl = tag(zcta5) if e(sample);
    count if temp`d'`s'`table'rl==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);
    sum frac_gsuicide if e(sample), detail;
    foreach r in p10 p25 p50 p75 p90 {;
      gen pcntl_`r'`d'`s'su = r(`r');
    }; **end fraction gun suicide percentile loop;
    sum pc_rural if e(sample), detail;
    foreach r in p10 p25 p50 p75 p90 {;
      gen pcntl_`r'`d'`s'rl = r(`r');
    }; **end percent rural percentile loop;

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_* pcntl*;
    drop mean_* sd_* pcntl*;
*/
  }; *end homicide/suicide loop; 
}; *end state loop;  






*BOTH STATES COMBINED;
/*
  foreach x in zip_has_show zip_has_closeshow5 zip_has_closeshow10 zip_has_closeshow25 {;
    if "`x'"=="zip_has_show" {; local name="IN ZIP CODE"; local varname="anyshow"; local numshow="numshows"; local table="a"; };
    if "`x'"=="zip_has_closeshow5" {; local name="IN 5 MILE AREA"; local varname="anycloseshow5"; local numshow="closeshows5";
     local table="b"; };
    if "`x'"=="zip_has_closeshow10" {; local name="IN 10 MILE AREA"; local varname="anycloseshow10"; local numshow="closeshows10";
     local table="c"; };
    if "`x'"=="zip_has_closeshow25" {; local name="IN 25 MILE AREA"; local varname="anycloseshow25"; local numshow="closeshows25";
     local table="d"; };

    foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
      
      **TABLE 2 - BASELINE RESULTS;
      disp "`dth' BOTH, `name'";
      areg `d' `numshow'_post_month `numshow'_postpre_month mm_* if `x'==1 , a(zy) cluster(zcta5);
      estimates store main_`table'`d'both;
      egen temp`d'both`table' = tag(zcta5) if e(sample);
      count if temp`d'both`table'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *close gun/non-gun loop;
  }; *close zip/10 mile loop;
*/
   foreach d in ghomicide nghomicide gsuicide ngsuicide {;
      if "`d'"=="ghomicide" {; local dth="# Gun Homicides"; };
      if "`d'"=="nghomicide" {; local dth="# Non-Gun Homicides"; };
      if "`d'"=="gsuicide" {; local dth="# Gun Suicides"; };
      if "`d'"=="ngsuicide" {; local dth="# Non-Gun Suicides"; };
/*       
    **TABLE 5 - SPLIT BY RURAL/POVERTY;    
    foreach p in "pc_rural>=.3" "pc_rural<.3 & pc_blw_pov<.1" "pc_rural<.3 & pc_blw_pov>=.1" {;
      if "`p'"=="pc_rural>=.3" {; local cat="cat1"; };
      if "`p'"=="pc_rural<.3 & pc_blw_pov<.1" {; local cat="cat2"; };
      if "`p'"=="pc_rural<.3 & pc_blw_pov>=.1" {; local cat="cat3"; };
     
      disp "`dth' BOTH, 10 MILE RADIUS, `p'";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' , a(zy) cluster(zcta5);
      estimates store rp_`table'`d'both`cat';
      egen temp`d'both`table'`cat' = tag(zcta5) if e(sample);
      count if temp`d'both`table'`cat'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end rural/poverty split loop;
*/
    **TABLE 6 - SPLIT BY FRACTION GUN SUICIDE;
    sum frac_gsuicide if zip_has_closeshow10==1, d; *25th percentile=.43, 75th percentile=.65;
      
    foreach p in "frac_gsuicide<.43" "frac_gsuicide>=.43 & frac_gsuicide<=.65" "frac_gsuicide>.65 & frac_gsuicide~=." {;
      if "`p'"=="frac_gsuicide<.43" {; local cat="low"; };
      if "`p'"=="frac_gsuicide>=.43 & frac_gsuicide<=.65" {; local cat="mid"; };
      if "`p'"=="frac_gsuicide>.65 & frac_gsuicide~=." {; local cat="high"; };

      disp "`dth' BOTH, 10 MILE RADIUS, `p'";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p' , a(zy) cluster(zcta5);
      estimates store g_own_`table'`d'both`cat';
      egen temp`d'both`table'`cat' = tag(zcta5) if e(sample);
      count if temp`d'both`table'`cat'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end fraction gun suicide loop;
/*
    **APPENDIX TABLE 6 - SPLIT BY YEAR;
    foreach y in "year<2000" "year>=2000" {;
      if "`y'"=="year<2000" {; local yr="1994-1999"; local yr2="90s"; };
      if "`y'"=="year>=2000" {; local yr="2000-2004"; local yr2="00s"; };

      disp "`dth' BOTH, IN 10 MILE AREA, `yr'";
      areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `y' , a(zy) cluster(zcta5);
      estimates store yr_`table'`d'both`yr2';
      egen temp`d'both`table'`yr2' = tag(zcta5) if e(sample);
      count if temp`d'both`table'`yr2'==1;
      sum `d' if e(sample);
      gen mean_`d' = r(mean);
      gen sd_`d' = r(sd);

      **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
      tab1 mean_* sd_*;
      drop mean_* sd_*;
    }; *end year split;
*/  
    **APPENDIX TABLE 8 - SPLIT BY ZIP CODE POPULATION;
    sum p_total if zip_has_closeshow10==1, d; *25th percentile=10394, 50th percentile=23771, 75th percentile=36749;
    
      foreach p in "p_total<10394" "p_total>=10394 & p_total<23771" "p_total>=23771 & p_total<36749" "p_total>=36749" {;
        if "`p'"=="p_total<10394" {; local cat="1pop"; };
        if "`p'"=="p_total>=10394 & p_total<23771" {; local cat="2pop"; };
        if "`p'"=="p_total>=23771 & p_total<36749" {; local cat="3pop"; };
        if "`p'"=="p_total>=36749" {; local cat="4pop"; };

        disp "`dth' BOTH, 10 MILE RADIUS, `p'";
        areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & `p', a(zy) cluster(zcta5);
        estimates store pop_`table'`d'both`cat';
        egen temp`d'both`table'`cat' = tag(zcta5) if e(sample);
        count if temp`d'both`table'`cat'==1;
        sum `d' if e(sample);
        gen mean_`d' = r(mean);
        gen sd_`d' = r(sd);
    
        **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
        tab1 mean_* sd_*;
        drop mean_* sd_*;
      }; *end zip code population loop;
    
/*    
    **TABLE 4 - SPLIT BY MODEL;
    disp "BASELINE, `dth', BOTH, IN 10 MILE AREA";
    areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 , a(zy) cluster(zcta5);
    estimates store mdls_`table'`d'bothbln;
    egen temp`d'both`table'bln = tag(zcta5) if e(sample);
    count if temp`d'both`table'bln==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "BASELINE WEIGHTED, `dth', BOTH, IN 10 MILE AREA";
    areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1  [aw=p_total], 
     a(zy) cluster(zcta5);
    estimates store mdls_`d'bothwtd;
    egen temp`d'both`table'wtd = tag(zcta5) if e(sample);
    count if temp`d'both`table'wtd==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    tsset, clear; *THIS COMMAND MIGHT BE UNNECESSARY;
    
    disp "NEGATIVE BINOMIAL, `dth', BOTH, IN 10 MILE AREA";
    bootstrap, reps(100) cluster(zcta5): xtnbreg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 ,
     irr iterate(50) fe i(zy);
    estimates store mdls_`table'`d'bothnb;
    egen temp`d'both`table'nb = tag(zcta5) if e(sample);
    count if temp`d'both`table'nb==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "POISSON, `dth', BOTH, IN 10 MILE AREA";
    bootstrap, reps(100) cluster(zcta5): xtpoisson `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 , 
     irr iterate(50) fe i(zy);
    estimates store mdls_`table'`d'bothpsn;
    egen temp`d'both`table'psn = tag(zcta5) if e(sample);
    count if temp`d'both`table'psn==1;
    gen tagnl_`d'both = 1 if e(sample);
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;

    disp "BASELINE ON LIMITED-NON-LINEAR SAMPLE, `dth', BOTH, IN 10 MILE AREA";
    areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1  & tagnl_`d'both==1, 
     a(zy) cluster(zcta5);
    estimates store lmtd_`d'both;
    egen temp`d'bothlmtd = tag(zcta5) if e(sample);
    count if temp`d'bothlmtd==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_*;
    drop mean_* sd_*;
*/
/*    
    **OLD TABLE NO LONGER PRESENTED- FRACTION GUN SUICIDE INTERACTIONS;
    disp "INTERACTIONS, FRAC_GUN_SUIC `dth', BOTH, IN 10 MILE AREA";
    areg `d' closeshows10_post_month bothsucloseshows10_post_month closeshows10_postpre_month bothsucloseshows10_postpre_month 
     mm_* if zip_has_closeshow10==1, a(zy) cluster(zcta5);
    estimates store ints_`table'`d'bothfrc;
    egen temp`d'both`table'frc = tag(zcta5) if e(sample);
    count if temp`d'both`table'frc==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);
    sum frac_gsuicide if e(sample), detail;
    foreach r in p10 p25 p50 p75 p90 {;
      gen pcntl_`r'`d'bothsu = r(`r');
    }; **end percentile loop;

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_* pcntl*;
    drop mean_* sd_* pcntl*;
    
    disp "INTERACTIONS, FRAC_GUN_SUIC and RURAL, `dth', BOTH, IN 10 MILE AREA";
    areg `d' closeshows10_post_month bothsucloseshows10_post_month bothrlcloseshows10_post_month closeshows10_postpre_month 
     bothsucloseshows10_postpre_month bothrlcloseshows10_postpre_month mm_* if zip_has_closeshow10==1, a(zy) cluster(zcta5);
    estimates store ints_`table'`d'bothrl;
    egen temp`d'both`table'rl = tag(zcta5) if e(sample);
    count if temp`d'both`table'rl==1;
    sum `d' if e(sample);
    gen mean_`d' = r(mean);
    gen sd_`d' = r(sd);
    sum frac_gsuicide if e(sample), detail;
    foreach r in p10 p25 p50 p75 p90 {;
      gen pcntl_`r'`d'bothsu = r(`r');
    }; **end fraction gun suicide percentile loop;
    sum pc_rural if e(sample), detail;
    foreach r in p10 p25 p50 p75 p90 {;
      gen pcntl_`r'`d'bothrl = r(`r');
    }; **end percent rural percentile loop;

    **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
    tab1 mean_* sd_* pcntl*;
    drop mean_* sd_* pcntl*;
*/
/*
   **RUN A FEW ADDITIONAL SPECS TO SEE IF ANYTHING CHANGES;

   **FIRST RUN A SPEC WHERE WE DROP ZIP-WEEKS ABOVE THE 99TH PERCENTILE OF MORTALITY;
   sum deaths if zip_has_closeshow10==1, d;  *99th percentile = 13;

   disp "`dth' BOTH, 10 MILE RADIUS, drop 1% highest mortality zips";
   areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1 & deaths<=13, a(zy) cluster(zcta5);
   estimates store new_`d'_mort;
   egen temp`d'both`table'mort = tag(zcta5) if e(sample);
   count if temp`d'both`table'mort==1;
   sum `d' if e(sample);
   gen mean_`d' = r(mean);
   gen sd_`d' = r(sd);

   **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
   tab1 mean_* sd_*;
   drop mean_* sd_*;

   **NOW RUN A SPEC WHERE WE CLUSTER BY MSA. OF THE 1596 ZIPS WITH A SHOW WITHIN 10 MILES, 141 OF THEM ARE NOT IN AN MSA 
    (ARE OUT IN THE MIDDLE OF NO WHERE SOMEWHERE) AND I AM JUST INCLUDING THESE AS A SEPARATE "MSA", FOR THE PURPOSES OF
    THE CLUSTERING;
   disp "`dth' BOTH, 10 MILE RADIUS, MSA;
   areg `d' closeshows10_post_month closeshows10_postpre_month mm_* if zip_has_closeshow10==1, a(zy) cluster(msa);
   estimates store new_`d'_msa;
   egen temp`d'both`table'msa = tag(zcta5) if e(sample);
   count if temp`d'both`table'msa==1;
   sum `d' if e(sample);
   gen mean_`d' = r(mean);
   gen sd_`d' = r(sd);

   **view all the means and standard deviations of the dependent vars for this loop, then drop them to save space;
   tab1 mean_* sd_*;
   drop mean_* sd_*;
*/
}; *end homicide/suicide loop; 




**CREATE TABLES;

/*
*TABLES 2, 3 AND A2;
estout main* using ${tables}tbl_fnl_nongun.txt, cells(b(star fmt(%9.4f)) se(par)) replace drop(mm_*) 
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*TABLES 4 AND A3 - COLUMNS 1,2,5,6,7,10;
estout mdls*bln mdls*wtd lmtd* using ${tables}tbl_fnl_modelswtd.txt, cells(b(star fmt(%9.4f)) se(par)) replace drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*TABLES 4 AND A3 - COLUMNS 3,4,8,9;
estout mdls*nb mdls*psn using ${tables}tbl_fnl_modelseform.txt, cells(b(star fmt(%9.3f)) p(par)) replace eform drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*TABLES 5 AND A5;
estout rp* using ${tables}tbl_fnl_rpsplt.txt, cells(b(star fmt(%9.4f)) se(par)) replace drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
*/
*TABLE 6 AND A6;
estout g_own* using ${tables}tbl_fnl_gun_own.txt, cells(b(star fmt(%9.4f)) se(par)) replace keep(closeshows10_post_month)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
/*
*TABLE A6;
estout yr* using ${tables}tbl_fnl_yrsplt.txt, cells(b(star fmt(%9.4f)) se(par)) replace drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
*/
*TAABLE A8;
estout pop* using ${tables}tbl_fnl_pop.txt, cells(b(star fmt(%9.4f)) se(par)) replace keep(closeshows10_post_month)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
/*
*TABLE NOT PRESENTED;
estout ints* using ${tables}tbl_fnl_intrcts.txt, cells(b(star fmt(%9.4f)) se(par)) replace  drop(mm_*)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

*NEW TABLE JUST TO CHECK IT OUT;
estout new* using ${tables}tbl_fnl_new.txt, cells(b(star fmt(%9.4f)) se(par)) replace keep(closeshows10_post_month)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));
*/

*!gzip ${bulk}rr_new_vars.dta;
display "$S_TIME  $S_DATE";
log close;










