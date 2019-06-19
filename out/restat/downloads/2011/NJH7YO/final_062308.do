*************************************************************************************************;
* The following file generates the estimation results for "Taxation with Representation."	*;									*;
*												*;
* Byron Lutz											*;
*************************************************************************************************;
#delimit;
clear all;
set maxvar 9000;
set mem 2000m;
set trace off;
set more off;
set linesize 255;
capture log close;
capture log using final_062308.log, replace;

 use town_restat, clear;

 * eliminate some towns due to data problems - Orford and Hanover are eliminated because they are cross-state districts
 * and suffer from clear longitudinal inconsistency, Seabrook if dropped due to uncertainty surrounding the taxing of 
 * the nuclear power plant;
 drop if nhid == 744;  * Hanover;
 drop if nhid == 843;  * Orford;
 drop if nhid == 2009; * Seabrook;

 * define the covariates;
 local covar = "sf3_pnwhite sf3_unemp sf3_ppov sf3_phs sf3_pcol sf3_sr95 rtot98 rtot982 sf3_hai sf3_hmi*"; 

 sort nhid year;
 tsset nhid year;
 quietly tab nhid, gen(towfe);
 
 preserve;
 for num 89 91 93 95 97 99 101 103 : drop if year == X;
 drop if year > 100;
 bysort nhid : egen c = count(c_l_ass_sch_rtot);
 tab c;
 gen balance = (c == 5);
 tsset nhid year;
 sort nhid year;

 **************************;
 * Two - Year Differences *;
 **************************;
  *****************;
  * OLS - Table 3 *;
  *****************;
  * (1) full;
  reg s2.c_l_ass_sch_rtot s2.c_strp_l_rtot s2.c_exc_rtot c_utax4_rtot c_rrev_rtot
         c_stnobuild100_rtot yearfe* 
         if admr_200 & balance, cluster(d_nhid);

  tab year if e(sample);

  **********************;
  * IV - Table 4 and 5 *;
  **********************;
  * (1) full;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot yearfe* 
                             if admr_200 & balance, cluster(d_nhid) ;

  test s2.c_exc_rtot + s2.c_strp_l_rtot = -1;

  * (2) district trends;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)   
                             c_stnobuild100_rtot yearfe* *towfe* 
                             if admr_200 & balance, cluster(d_nhid) ;

  test s2.c_exc_rtot + s2.c_strp_l_rtot = -1;

  * (3) covariates;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot `covar'
                             if admr_200 & balance & year == 100, cluster(d_nhid) ;

  test s2.c_exc_rtot + s2.c_strp_l_rtot = -1;

  
  * (4) seperate year intercepts by quartile of per-pupil property wealth;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild100_rtot *b*yearfe*   
                             if admr_200 & balance, cluster(d_nhid) ;

  test s2.c_exc_rtot + s2.c_strp_l_rtot = -1;

  * (5) ldp;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot   l2s2.c_l_ass_sch_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 l4.c_l_ass_sch_rtot)  
                             c_stnobuild100_rtot yearfe*  
                             if admr_200 & balance, cluster(d_nhid) ;

  test s2.c_exc_rtot + s2.c_strp_l_rtot = -1;


  * (1 weighted) - in footnote;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot yearfe* [w=rtot98]
                             if admr_200 & balance, cluster(d_nhid) ;

 *******************************;
 * First-Stages - for F-stats  *;
 *******************************;
  * (1) full;
  ivreg                      s2.c_strp_l_rtot    
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98  
                             c_stnobuild100_rtot yearfe* 
                             if admr_200 & balance;
  test s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (2) district trends;
  ivreg                      s2.c_strp_l_rtot    
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98  
                             c_stnobuild100_rtot yearfe* *towfe* 
                             if admr_200 & balance;
  test s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (3) covariates;
  ivreg                      s2.c_strp_l_rtot    
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98  
                             c_stnobuild100_rtot `covar'
                             if admr_200 & balance & year == 100;
  test s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (4) seperate year intercepts by quartile of per-pupil property wealth;
  ivreg                      s2.c_strp_l_rtot   
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 
                             c_stnobuild100_rtot *b*yearfe*   
                             if admr_200 & balance;
  test s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

 * (5) ldp;
  ivreg                      s2.c_strp_l_rtot    
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 l4.c_l_ass_sch_rtot  
                             c_stnobuild100_rtot yearfe*  
                             if admr_200 & balance;
  test s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  ********************;
  * IV - APPENDIX A1 *;
  ********************;
  * (1) full;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot yearfe* s2.lnadm_rtot 
                             if admr_200 & balance, cluster(d_nhid);

  test s2.c_exc_rtot + s2.c_strp_l_rtot = -1;

  * (2) district trends;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)   
                             c_stnobuild100_rtot yearfe* *towfe* s2.lnadm_rtot
                             if admr_200 & balance, cluster(d_nhid) first ;

  * (3) covariates;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot `covar' s2.lnadm_rtot
                             if admr_200 & balance & year == 100, cluster(d_nhid) first;

  * (4) seperate year intercepts by quartile of per-pupil property wealth;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild100_rtot *b*yearfe* s2.lnadm_rtot  
                             if admr_200 & balance, cluster(d_nhid) first;

  * (5) ldp;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot   l2s2.c_l_ass_sch_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 l4.c_l_ass_sch_rtot)  
                             c_stnobuild100_rtot yearfe* s2.lnadm_rtot 
                             if admr_200 & balance, cluster(d_nhid) first;

 ****************************;
 * Three - Year Differences *;
 ****************************; 
  *****************;
  * OLS - Table 3 *;
  *****************;
  restore;
  preserve;
  for num 88 90 91 93 94 96 97 99 100 102 103 : drop if year == X;
  drop if year > 101;
  bysort nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 4);
  tsset nhid year;
  sort nhid year; 

  * (1);
  reg s3.c_l_ass_sch_rtot s3.c_strp_l_rtot s3.c_exc_rtot c_utax4_rtot c_rrev_rtot 
                          c_stnobuild101_rtot yearfe* 
                          if admr_200 & balance, cluster(d_nhid);
  tab year if e(sample);

  **********************;
  * IV - Table 4 and 5 *;
  **********************;
  * (1);
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild101_rtot yearfe*  
                             if admr_200 & balance, cluster(d_nhid) ;
  * (2) trends;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot  = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild101_rtot yearfe*  *towfe*
                             if admr_200 & balance, cluster(d_nhid) ;

  * (3) - covariates;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot  = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild101_rtot `covar'
                             if admr_200 & balance & year == 101, cluster(d_nhid) ;

  * (4) - separate year intercepts;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild101_rtot *b*yearfe*   
                             if admr_200 & balance, cluster(d_nhid);

  * (5) ldp;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot   l3s3.c_l_ass_sch_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 l6.c_l_ass_sch_rtot)  
                             c_stnobuild101_rtot yearfe*  
                             if admr_200 & balance, cluster(d_nhid) ;

 *******************************;
 * First-Stages - for F-stats  *;
 *******************************;
  * (1) full;
  ivreg                      s3.c_strp_l_rtot    
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98  
                             c_stnobuild101_rtot yearfe* 
                             if admr_200 & balance;
  test s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (2) district trends;
  ivreg                      s3.c_strp_l_rtot    
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98  
                             c_stnobuild101_rtot yearfe* *towfe* 
                             if admr_200 & balance;
  test s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (3) covariates;
  ivreg                      s3.c_strp_l_rtot    
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98  
                             c_stnobuild101_rtot `covar'
                             if admr_200 & balance & year == 101;
  test s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (4) seperate year intercepts by quartile of per-pupil property wealth;
  ivreg                      s3.c_strp_l_rtot   
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 
                             c_stnobuild101_rtot *b*yearfe*   
                             if admr_200 & balance;
  test s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

  * (5) ldp;
  ivreg                      s3.c_strp_l_rtot    
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 l6.c_l_ass_sch_rtot  
                             c_stnobuild101_rtot yearfe*  
                             if admr_200 & balance;
  test s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98;

 **********************;
 * 3 - IV Appendix A1 *;
 **********************;
  * (1);
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild101_rtot  yearfe* s3.lnadm_rtot
                             if admr_200 & balance, cluster(d_nhid) ;


  * (2) trends;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot  = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild101_rtot yearfe*  *towfe* s3.lnadm_rtot
                             if admr_200 & balance, cluster(d_nhid) ;

  * (3) - covariates;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot  = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild101_rtot yearfe* `covar' s3.lnadm_rtot
                             if admr_200 & balance & year == 101, cluster(d_nhid) ;

  * (4) - separate year intercepts;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild101_rtot *b*yearfe*  s3.lnadm_rtot
                             if admr_200 & balance, cluster(d_nhid) ;

  * (5) ldp;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot c_utax4_rtot     c_rrev_rtot   l3s3.c_l_ass_sch_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98 l6.c_l_ass_sch_rtot)  
                             c_stnobuild101_rtot yearfe*  s3.lnadm_rtot 
                             if admr_200 & balance, cluster(d_nhid) ;

 ******************************;
 * Robustness Check - Table 6 *;
 ******************************;
  restore;
  preserve;
  for num 89 91 93 95 97 99 101 103 : drop if year == X;
  bysort nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 6);
  sort nhid year;

  * (1) robustness check;
  ivreg s2.c_l_ass_sch_rtot f2s2.c_edg_snp_rtot f2s2.c_exc_rtot f2.c_utax4_rtot f2.c_rrev_rtot f2.c_stnobuild100_rtot yearfe*  
        if admr_200 & balance & year <= 98, cluster(d_nhid) ;

  * (2) reduced form;
  ivreg s2.c_l_ass_sch_rtot (s2.c_edg_snp_rtot   s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot yearfe*  
                             if admr_200 & balance & year <= 100, cluster(d_nhid) ;

  restore;
  preserve;

  tsset nhid year;
  sort nhid year; 
  gen l1_c_edg_snp_rtot98 = l1.c_edg_snp_rtot98;
  gen l1_c_exc_rtot98     = l1.c_exc_rtot98;

  keep if year == 102 | year == 98 | year == 94 | year == 90;
  drop if year > 102;
  bysort nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 3);
  drop c;

   * (3) - 4th year;
  ivreg s4.c_l_ass_sch_rtot (s4.c_strp_l_rtot    s4.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             l1_c_edg_snp_rtot98 l1_c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild102_rtot yearfe*
	   	 	     if admr_200 & balance, cluster(d_nhid) first;
  tab year if e(sample);

  * (4) - 4th year with covariates;
  ivreg s4.c_l_ass_sch_rtot (s4.c_strp_l_rtot    s4.c_exc_rtot   c_utax4_rtot   c_rrev_rtot  = 
                             l1_c_edg_snp_rtot98 l1_c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild102_rtot yearfe* 
       			     `covar'
                             if admr_200 & balance & year == 102, cluster(d_nhid) first;

 *************************;
 * Exstensions - Table 8 *;
 *************************;
  * Panel A - Second Year of Reform;
  restore;
  preserve;
  for num 89 91 93 95 97 99 101 103 : drop if year == X;
  drop if year > 100;
  bysort nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 5);
  drop c;

  tsset nhid year;
  sort nhid year;

  * (1);
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_strp_l_st_rtot    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot =
                             s2.c_edg_snp_rtot98 s2.c_edg_snp_st_rtot98 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             c_stnobuild100_rtot  yearfe*
                             if admr_200 & type == 1 & balance & nomeet ~= 1, cluster(d_nhid) ;

  * (2);
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_exc_rtot   s2.c_strp_l_nm_rtot     c_utax4_rtot        c_rrev_rtot =
                             s2.c_edg_snp_rtot98 s2.c_exc_rtot98 s2.c_edg_snp_nm_rtot98  c_utax4_rtot98      c_rrev_rtot98) 
                             c_stnobuild100_rtot yearfe* 
                             if admr_200 & balance, cluster(d_nhid) ;

  * (3); * Engel Curve Runs - Table 8;
  ivreg s2.c_l_ass_sch_rtot (s2.c_strp_l_rtot    s2.c_strp_l_rtot_hmi    s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s2.c_edg_snp_rtot98 s2.c_edg_snp_rtot98_hmi s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
                             c_stnobuild100_rtot yearfe* 
                             if admr_200 & balance, cluster(d_nhid) ;

  local bmain2 = _b[s2.c_strp_l_rtot];
  local binte2 = _b[s2.c_strp_l_rtot_hmi];
  sum sf3_hmi if admr_200 & balance & year == 100, det;
  disp `bmain2' + (`binte2' * r(p25));
  disp `bmain2' + (`binte2' * r(p50));
  disp `bmain2' + (`binte2' * r(p75));

  * Panel B - Third Year of Response;
  restore;
  preserve;
  for num 88 90 91 93 94 96 97 99 100 102 103 : drop if year == X;
  drop if year > 101;
  bysort nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 4);
  drop c;  

  tsset nhid year;
  sort nhid year;
 
  * (4);
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_strp_l_st_rtot    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot =
                             s3.c_edg_snp_rtot98 s3.c_edg_snp_st_rtot98 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
                             yearfe* c_stnobuild101_rtot
                             if admr_200 & type == 1 & balance & nomeet ~= 1, cluster(d_nhid) ;

  * (5);
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_exc_rtot   s3.c_strp_l_nm_rtot     c_utax4_rtot        c_rrev_rtot =
                             s3.c_edg_snp_rtot98 s3.c_exc_rtot98 s3.c_edg_snp_nm_rtot98  c_utax4_rtot98      c_rrev_rtot98) 
                             yearfe*  c_stnobuild101_rtot 
                             if admr_200 & balance, cluster(d_nhid) ;

  * (6) Engel Curve Run;
  ivreg s3.c_l_ass_sch_rtot (s3.c_strp_l_rtot    s3.c_strp_l_rtot_hmi    s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
                             s3.c_edg_snp_rtot98 s3.c_edg_snp_rtot98_hmi s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)
                             c_stnobuild101_rtot yearfe* 
                             if admr_200 & balance, cluster(d_nhid) ;

  local bmain3 = _b[s3.c_strp_l_rtot];
  local binte3 = _b[s3.c_strp_l_rtot_hmi];
  sum sf3_hmi if admr_200 & balance & year == 101, det;
  disp `bmain3' + (`binte3' * r(p25));
  disp `bmain3' + (`binte3' * r(p50));
  disp `bmain3' + (`binte3' * r(p75));  

 **************************************;
 * Other Local Public Goods - Table 7 *;
 **************************************;
  **********************;
  * 2 Year Differences *;
  **********************;
  restore;
  use town_restat, clear;
  drop if nhid == 2009; * Seabrook / Nuclear Power situation;
  drop if nhid == 744;  * Hanover;
  drop if nhid == 843;  * Orford;

  for num 89 91 93 95 97 99 101 102 103 : drop if year == X;
  drop if year > 100;
  bysort nhid : egen c = count(c_l_ass_sch_sp);
  tab c;
  keep if c == 5;
  drop c; 

  quietly tab nhid, gen(towfe);
  tsset nhid year;
  sort nhid year;

  * (1) differenced;
  ivreg  s2.c_taxloc_sp (s2.c_edg_snp_sp   s2.c_exc_sp   s2.c_utax4_sp   s2.c_rrev_sp = 
                         s2.c_edg_snp_sp98 s2.c_exc_sp98 s2.c_utax4_sp98 s2.c_rrev_sp98) 
                         c_stnobuild100_sp yearfe*  
                         if admr_200, cluster(d_nhid);

  ***********************;
  * 3 Year Differences  *;
  ***********************;
  use town_restat, clear;
  drop if nhid == 2009; * Seabrook / Nuclear Power situation;
  drop if nhid == 744;  * Hanover;
  drop if nhid == 843;  * Orford;

  for num 89 90 91 93 94 96 97 99 100 102 103 : drop if year == X;
  drop if year > 101;
  bysort nhid : egen c = count(c_l_ass_sch_sp);
  tab c;
  keep if c == 4;
  drop c; 
  
  quietly tab nhid, gen(towfe);
  tsset nhid year;
  sort nhid year;

  * (1) differenced;;
  ivreg  s3.c_taxloc_sp (s3.c_edg_snp_sp   s3.c_exc_sp   s3.c_utax4_sp   s3.c_rrev_sp = 
                         s3.c_edg_snp_sp98 s3.c_exc_sp98 s3.c_utax4_sp98 s3.c_rrev_sp98) 
                         c_stnobuild101_sp yearfe*  
                         if admr_200, cluster(d_nhid);

  **************************************************;
  * Continous Engel Estimates - Quartic, Figure 1  *;
  **************************************************;
  use town_restat, clear;

  *eliminate some towns due to data problems - Orford and Hanover are eliminated because they are cross-state districts
  *and it is unclear what the data includes;
  drop if nhid == 744;  * Hanover;
  drop if nhid == 843;  * Orford;
  drop if nhid == 2009; * Seabrook - dropped due to uncertainty surrounding the taxing of the nuclear power plant;
 
  preserve;
  for num 89 91 93 95 97 99 101 103 : drop if year == X;
  drop if year > 100;
  by nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 5);
  sort nhid year;
  tsset nhid year;

  * note that figure 1 plots implied offset for the 5th to 95th percentile percentile of median income;

  sum sf3_hmi if admr_200 & balance & year == 100, det;
 
  ivreg s2.c_l_ass_sch_rtot 
       (s2.c_edg_snp_rtot   s2.c_edg_snp_rtot_hmi1   s2.c_edg_snp_rtot_hmi2   s2.c_edg_snp_rtot_hmi3   s2.c_edg_snp_rtot_hmi4   s2.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
        s2.c_edg_snp_rtot98 s2.c_edg_snp_rtot98_hmi1 s2.c_edg_snp_rtot98_hmi2 s2.c_edg_snp_rtot98_hmi3 s2.c_edg_snp_rtot98_hmi4 s2.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98)  
        c_stnobuild100_rtot yearfe*  
        if admr_200 & balance & year == 100, cluster(d_nhid) first;

 foreach fg of numlist 35000(100)75000 {;

  quietly {;
   
   local `fg'_2 = `fg'^2;
   local `fg'_3 = `fg'^3;
   local `fg'_4 = `fg'^4; 

   test ((s2.c_edg_snp_rtot) + (s2.c_edg_snp_rtot_hmi1*`fg') + (s2.c_edg_snp_rtot_hmi2*(``fg'_2')) + (s2.c_edg_snp_rtot_hmi3*(``fg'_3')) + 
         (s2.c_edg_snp_rtot_hmi4*(``fg'_4'))) = 0;

   local b_`fg'       = ((_b[s2.c_edg_snp_rtot]) + (_b[s2.c_edg_snp_rtot_hmi1]*`fg') + (_b[s2.c_edg_snp_rtot_hmi2]*(``fg'_2')) + 
                        (_b[s2.c_edg_snp_rtot_hmi3]*(``fg'_3')) + (_b[s2.c_edg_snp_rtot_hmi4]*(``fg'_4')));
   local u95b_`fg'    = `b_`fg'' + 1.96*abs(`b_`fg''/r(F)^.5);
   local l95b_`fg'    = `b_`fg'' - 1.96*abs(`b_`fg''/r(F)^.5); 

  };

  disp "`fg' `b_`fg'' `u95b_`fg'' `l95b_`fg''"; 

 };  

   * 3 year;
   restore;
   for num 88 90 91 93 94 96 97 99 100 102 103 : drop if year == X;
   drop if year > 101;
   by nhid : egen c = count(c_l_ass_sch_rtot);
   tab c;
   gen balance = (c == 4);
   drop c;

   tsset nhid year;
   sort nhid year;
   
   sum sf3_hmi if admr_200 & balance & year == 101, det;
    
   ivreg s3.c_l_ass_sch_rtot 
        (s3.c_edg_snp_rtot   s3.c_edg_snp_rtot_hmi1   s3.c_edg_snp_rtot_hmi2   s3.c_edg_snp_rtot_hmi3   s3.c_edg_snp_rtot_hmi4   s3.c_exc_rtot   c_utax4_rtot   c_rrev_rtot = 
         s3.c_edg_snp_rtot98 s3.c_edg_snp_rtot98_hmi1 s3.c_edg_snp_rtot98_hmi2 s3.c_edg_snp_rtot98_hmi3 s3.c_edg_snp_rtot98_hmi4 s3.c_exc_rtot98 c_utax4_rtot98 c_rrev_rtot98) 
         c_stnobuild101_rtot yearfe*  
         if admr_200 & balance & year == 101, cluster(d_nhid) first;

 foreach fh of numlist 35000(100)75000 {;

  quietly {;
   
   local `fh'_2 = `fh'^2;
   local `fh'_3 = `fh'^3;
   local `fh'_4 = `fh'^4; 

   test ((s3.c_edg_snp_rtot) + (s3.c_edg_snp_rtot_hmi1*`fh') + (s3.c_edg_snp_rtot_hmi2*(``fh'_2')) + (s3.c_edg_snp_rtot_hmi3*(``fh'_3')) + 
         (s3.c_edg_snp_rtot_hmi4*(``fh'_4'))) = 0;

   local b_`fh'       = ((_b[s3.c_edg_snp_rtot]) + (_b[s3.c_edg_snp_rtot_hmi1]*`fh') + (_b[s3.c_edg_snp_rtot_hmi2]*(``fh'_2')) + 
                        (_b[s3.c_edg_snp_rtot_hmi3]*(``fh'_3')) + (_b[s3.c_edg_snp_rtot_hmi4]*(``fh'_4')));
   local u95b_`fh'    = `b_`fh'' + 1.96*abs(`b_`fh''/r(F)^.5);
   local l95b_`fh'    = `b_`fh'' - 1.96*abs(`b_`fh''/r(F)^.5); 

  };

  disp "`fh' `b_`fh'' `u95b_`fh'' `l95b_`fh''"; 

 };  

log close;
    
    
    
    
    
