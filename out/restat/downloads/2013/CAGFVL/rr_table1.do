 /*****************************************************************************
 This program redoes table1 for both states combined 
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

log using rr_table1.log, replace;


global n=2;

if $n==1{;
   global desktop "C:\Documents and Settings\jmhyman\Desktop\Gunshows\";
};

if $n==2{;
   global josh "/disk/homes2b/nber/bajacob/gunshows/josh/";
   global bulk "/disk/homes2b/nber/bajacob/bulk/gunshows/";
   global gun "/disk/homes2b/nber/bajacob/gunshows/";
   global mark_files "/disk/homes2b/nber/bajacob/gunshows/josh/mark_files/";
   global tables "/disk/homes2b/nber/bajacob/gunshows/josh/tables/raw_tables/";
   global mortality "/disk/homes2b/nber/bajacob/gunshows/mortality/";
   global houston "/disk/homes2b/nber/bajacob/gunshows/josh/revise_resubmit/houston_stuff/";
   global revise "/disk/homes2b/nber/bajacob/gunshows/josh/revise_resubmit/";
};


!gunzip ${bulk}rr_new_vars.dta.gz;
use ${bulk}rr_new_vars.dta;


***TABLE 1a: Weekly Gun-Related Deaths per 100,000 Residents CA AND TX********;
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide,
  columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_show==1, columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_show==1 & anyshow==1, columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_show==1 & anyshow==0, columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_closeshow10==1, columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_closeshow10==1 & anycloseshow10==1, columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_closeshow10==1 & anycloseshow10==0, columns(statistics) statistics(mean) by(state) format(%9.3f);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_show==0, columns(statistics) statistics(mean) by(state) format(%9.3f);

**number of zips and zip*weeks, both states combined;
*zips;
count if tag==1;
count if tag==1 & zip_has_show==1;
count if tag==1 & zip_has_show==1 & anyshow==1;
count if tag==1 & zip_has_show==1 & anyshow==0;
count if tag==1 & zip_has_closeshow10==1;
count if tag==1 & zip_has_closeshow10==1 & anycloseshow10==1;
count if tag==1 & zip_has_closeshow10==1 & anycloseshow10==0;
count if tag==1 & zip_has_show==0;

*zip*weeks;
count;
count if zip_has_show==1;
count if zip_has_show==1 & anyshow==1;
count if zip_has_show==1 & anyshow==0;
count if zip_has_closeshow10==1;
count if zip_has_closeshow10==1 & anycloseshow10==1;
count if zip_has_closeshow10==1 & anycloseshow10==0;
count if zip_has_show==0;

*NOW STATES SEPARATELY;

**number of zips and zip*weeks;
*zips;
foreach s in ca tx {;
count if state=="`s'" & tag==1;
count if state=="`s'" & tag==1 & zip_has_show==1;
count if state=="`s'" & tag==1 & zip_has_show==1 & anyshow==1;
count if state=="`s'" & tag==1 & zip_has_show==1 & anyshow==0;
count if state=="`s'" & tag==1 & zip_has_closeshow10==1;
count if state=="`s'" & tag==1 & zip_has_closeshow10==1 & anycloseshow10==1;
count if state=="`s'" & tag==1 & zip_has_closeshow10==1 & anycloseshow10==0;
count if state=="`s'" & tag==1 & zip_has_show==0;

*zip*weeks;
count if state=="`s'";
count if state=="`s'" & zip_has_show==1;
count if state=="`s'" & zip_has_show==1 & anyshow==1;
count if state=="`s'" & zip_has_show==1 & anyshow==0;
count if state=="`s'" & zip_has_closeshow10==1;
count if state=="`s'" & zip_has_closeshow10==1 & anycloseshow10==1;
count if state=="`s'" & zip_has_closeshow10==1 & anycloseshow10==0;
count if state=="`s'" & zip_has_show==0;
};


******APPENDIX TABLE 1A: Where do gun shows take place? Evidence from Texas and California;
!gunzip ${bulk}rr_new_vars.dta.gz;
 use ${bulk}rr_new_vars.dta, clear;

tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_show==1, columns(statistics) statistics(mean) by(state);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_show==0, columns(statistics) statistics(mean) by(state);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_closeshow10==1, columns(statistics) statistics(mean) by(state);
tabstat pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide 
 if zip_has_closeshow10==0, columns(statistics) statistics(mean) by(state);

estimates clear;

foreach s in ca tx {;
 foreach z in zip_has_show zip_has_closeshow10 {;
  if "`z'"=="zip_has_show" {; local t="1"; };
  if "`z'"=="zip_has_closeshow10" {; local t="2"; };
  foreach v in pc_gdeaths pc_gsuicide pc_ghomicide p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa 
   frac_gsuicide {;

   display "`v' `z' `s'";
   reg `v' `z' if state=="`s'", cluster(zcta5);
   estimates store t2`v'`t'`s';
  }; *close demographics loop;
 }; *close radius loop;
}; *close state loop;

estout _all using ${tables}tableApp1A_final.txt, cells(b(star fmt(%9.3f)) se(par)) replace order(zip_has_show zip_has_closeshow10 _cons)
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

estimates clear;


*!gzip ${bulk}rr_new_vars.dta;
log close;










