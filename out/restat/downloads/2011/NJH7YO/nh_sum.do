*******************************************;
* This file produces the non-estimation	  *;
* statistics in the "Taxation  		  *;
* with Representation" paper.		  *;
*					  *;
* Byron Lutz  				  *;
*******************************************;
#delimit;
clear all;
set memory 500m;
set maxvar 9000;
set trace off;
set more off;
set linesize 255;
capture log close;
capture log using nh_sum.log, replace;

local sumt   = 1;
local eq     = 1;

*****************************************;
* Table 2				*;
* Make the primary summary stats table  *;
*****************************************;
if `sumt' {;

 **************;
 * Town Stats *;
 **************;
 use house_restat, clear;
 *********************************************;
 * restrict to the sample used in estimation *;
 *********************************************;
  keep if admr_200;
  drop if nhid == 744;  * Hanover;
  drop if nhid == 843;  * Orford;
  drop if nhid == 2009; * Seabrook - dropped due to uncertainty surrounding the taxing of the nuclear power plant;  

  for num 89 91 93 95 97 99 101 103 : drop if year == X;
  drop if year > 100;
  by nhid : egen c = count(c_l_ass_sch_rtot);
  tab c;
  gen balance = (c == 5);
  keep if balance;

 ********************************************************;
 * define some variables and make some required changes *;
 ********************************************************;  
  * There are several versions of the tax rate variable.  The table uses the total tax rate variable obtained from the VAL spreadsheets.;
  * This is the optimal series because it reflects the different property tax bases for the different taxes - i.e. local educ, state educ;
  * and other local.;
  capture drop ltax_rate;
  gen ltax_rate = v_tratee_tot;

  * recode c_eqval so as to make it readable on the table;
  replace c_eqval = c_eqval / 1000000;

  bysort nhid : egen donor = sum((cg_excess > 0) * (year == 100));
  replace c_edg_snp_rtot = . if edgrant == 0;
  replace c_exc_rtot     = . if c_exc_rtot == 0;
  bysort nhid : egen rectown = sum((c_edg_snp_rtot ~= .) * (year == 100));

  local sumlist1 = "sf3_hai donor nomeet sbtown";
  local sumlist2 = "spop adm_rtot c_l_ass_sch_rtot c_edg_snp_rtot c_exc_rtot c_eqval ltax_rate";
  local sumlist3 = "ltax_rate";

 *******************************************************************;
 * create local macros containing values to be displayed on table  *;
 *******************************************************************; 
  foreach c in `sumlist1' {;
   sum `c' if year == 100;
   local m_100_`c' = round(r(mean), .0001);
   local s_100_`c' = round(r(sd)  , .0001); 
   local n_100_`c' = r(N);
  };

  foreach b in 98 100 {;
   foreach c in `sumlist2' {;
    sum `c'  if year == `b', det;
    local m_`b'_`c'   = round(r(mean ), .0001);
    local s_`b'_`c'   = round(r(sd)   , .0001);
    local n_100_`c' = r(N);
   };
  };

  foreach b in 98 100 {;
   foreach c in `sumlist3' {;
    sum `c'  if year == `b', det;
    local m_`b'_`c'   = round(r(mean ), .0001);
    local s_`b'_`c'   = round(r(sd)   , .0001);
    local r10_`b'_`c' = round(r(p10)  , .0001);
    local r90_`b'_`c' = round(r(p90)  , .0001);
    local lr91_`b'_`c'= log(r(p90)) - log(r(p10));  
    local cv_`b'_`c'   = r(sd)/r(mean); 
    local n_`b'_`c'   = r(N);
   }; 
  };

 *****************;
 * School Stats  *;
 *****************;
  use dis_restat, clear;
  drop if d_nhid == 126;  * Orford;
  drop if d_nhid == 65;   * Hanover;
  drop if d_nhid == 146;  * Seabrook; 

  * restrict to districts with at least 200 students in 1998;
  bysort d_nhid : egen v33_200  = sum((v33 > 200)  * year == 98);
  keep if v33_200;
  keep if year == 98 | year == 100;
 
  by d_nhid : egen net = sum((v33_c_edg_plt_sn - v33_c_exc_plt) * (year == 100)); 
  gen v33_c_tcurelsc_pnet = v33_c_tcurelsc_l * (net > 0);
  gen v33_c_tcurelsc_nnet = v33_c_tcurelsc_l * (net <= 0);
  replace v33_c_tcurelsc_pnet = . if net <= 0;
  replace v33_c_tcurelsc_nnet = . if net >  0; 

  local sumlistdis = "v33 v33_c_str_l v33_c_tcurelsc_l v33_c_tcurelsc_pnet v33_c_tcurelsc_nnet";

 *******************************************************************;
 * create local macros containing values to be displayed on table  *;
 *******************************************************************; 
  foreach b in 98 100 {;
   foreach c in `sumlistdis' {;
    sum `c'     if year == `b', det;
    local m_`b'_`c'   = round(r(mean), .0001);
    local s_`b'_`c'   = round(r(sd)  , .0001);
    local n_`b'_`c'   = r(N);
   };

   sum v33_c_tcurelsc_l if year == `b', det; 
   local m_`b'_v33_c_tcurelsc_l    = round(r(mean ), .0001);
   local s_`b'_v33_c_tcurelsc_l    = round(r(sd)   , .0001);
   local n_`b'_v33_c_tcurelsc_l    = r(N);
   local lr91_`b'_v33_c_tcurelsc_l = log(r(p90)) - log(r(p10));  
   local cv_`b'_v33_c_tcurelsc_l   = r(sd)/r(mean);
  };
 
 *********************;
 * display the stats *;
 *********************;
  foreach c in `sumlist1' {;
   disp "XX XX `m_100_`c''";
   disp "XX XX `s_100_`c''";
   disp " ";
  };

  foreach c in `sumlist2' {;
   disp "`m_98_`c'' XX `m_100_`c''";
   disp "`s_98_`c'' XX `s_100_`c''";
   disp " ";
   if "`c'" == "ltax_rate" {;
    disp "`lr91_98_ltax_rate' XX `lr91_100_ltax_rate'";
    disp "`cv_98_ltax_rate'   XX `cv_100_ltax_rate'  ";
    disp " ";
   };
  };

 disp "`n_98_c_l_ass_sch_rtot' `n_100_c_l_ass_sch_rtot'";
 
 foreach c in `sumlistdis' {;
  disp "`m_98_`c'' XX `m_100_`c'' XX `mW_98_`c'' XX `mW_100_`c''";
  disp "`s_98_`c'' XX `s_100_`c'' XX `sW_98_`c'' XX `sW_100_`c''";
  disp " ";
  if "`c'" == "v33_c_tcurelsc_l" {;
    disp "`lr91_98_v33_c_tcurelsc_l' XX `lr91_100_v33_c_tcurelsc_l' XX `lr91W_98_v33_c_tcurelsc_l' XX `lr91W_100_v33_c_tcurelsc_l'";
    disp "`cv_98_v33_c_tcurelsc_l'   XX `cv_100_v33_c_tcurelsc_l' XX `cvW_98_v33_c_tcurelsc_l'   XX `cvW_100_v33_c_tcurelsc_l'";
    disp " ";
  };
 };
 disp "`n_98_v33_c_str_l' `n_100_v33_c_str_l' ";

};

******************************************;
* produce the fiscal equity calculations *;
******************************************;
if `eq' {;
 use house_restat, clear;
 keep if admr_200;
 drop if nhid == 744;  * Hanover;
 drop if nhid == 843;  * Orford;
 drop if nhid == 2009; * Seabrook - dropped due to uncertainty surrounding the taxing of the nuclear power plant;  
 keep if year == 98 | year == 100;

 * gen some required vars;
 * using -.9 as the estimate of offset - this is in the middle of the range of estimates;

 * dispersion vars;
 bysort nhid : egen c_eqval98 = sum(c_eqval * (year == 98));
 gen t_base_trate = ((((v_totptax)  * cpi) / c_eqval98) * 1000) if year == 98;
 bysort nhid : egen base_trate = sum(t_base_trate * (year == 98));
 gen post_trate = base_trate + (((-(c_edg_snp    * .9) + (c_exc)) / c_eqval98)*1000) if year == 100;

 foreach g in base_trate post_trate {;
  sum `g' if year == 100 & `g' ~= 0, det;
  local m_`g'   = round(r(mean ), .0001);
  local s_`g'   = round(r(sd)   , .0001);
  local r10_`g' = round(r(p10)  , .0001);
  local r90_`g' = round(r(p90)  , .0001);
  local lr91_`g'= log(r(p90)) - log(r(p10));  
  local cv_`g'  = r(sd)/r(mean); 
 };

 * elasticity vars.;
 bysort nhid : egen base_tax = sum((v_totptax * cpi) * (year == 98));
 gen post_tax = base_tax - (c_edg_snp * .9) + (c_exc) if year == 100;
 sum post_tax base_tax if year == 100;

 for var base_tax post_tax : gen X_sp98 = X / spop98;
 for var sf3_hai sf3_hmi base_tax_sp98 post_tax_sp98 : gen ln_X = ln(X); 

 ****************************************************************************;
 * The log ratio and cv of the property tax - changes implied by the reform *;
 ****************************************************************************;
 disp "`lr91_base_trate' `lr91_post_trate'";
 disp "`cv_base_trate' `cv_post_trate'";

 ************************************************;
 * Elasticity of mean local tax wrt mean income *;
 ************************************************;
 reg ln_base_tax_sp98 ln_sf3_hai if year == 100 & admr_200 & nhid ~= 744 & nhid ~= 843 & nhid ~= 2009;
 reg ln_post_tax_sp98 ln_sf3_hai if year == 100 & admr_200 & nhid ~= 744 & nhid ~= 843 & nhid ~= 2009;

};

log close;
