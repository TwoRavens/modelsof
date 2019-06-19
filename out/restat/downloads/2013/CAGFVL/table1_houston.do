 /*****************************************************************************
 This program redoes table1 for Houston tracts only 
 Josh Hyman, May 2009
*****************************************************************************/

# delimit ;

clear;
capture log close;
set mem 1200m;
set more off;
set mat 8000;
program drop _all;
macro drop _all;

log using table1_houston.log, replace;


global n=2;

if $n==1{;
   global desktop "C:\Documents and Settings\jmhyman\Desktop\Gunshows\";
};

if $n==2{;
   global bulk "/disk/homes2b/nber/bajacob/bulk/gunshows/";
   global josh "/disk/homes2b/nber/bajacob/gunshows/josh/";
   global gun "/disk/homes2b/nber/bajacob/gunshows/";
   global mark_files "/disk/homes2b/nber/bajacob/gunshows/josh/mark_files/";
   global tables "/disk/homes2b/nber/bajacob/gunshows/josh/tables/raw_tables/";
   global mortality "/disk/homes2b/nber/bajacob/gunshows/mortality/";
   global houston "/disk/homes2b/nber/bajacob/gunshows/josh/revise_resubmit/houston_stuff/";
   global revise "/disk/homes2b/nber/bajacob/gunshows/josh/revise_resubmit/";

};


!gunzip ${bulk}new_vars_houston2.dta.gz;
use ${bulk}new_vars_houston2.dta;

***TABLE 1: Weekly crimes per 100,000 Residents ********;
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary 
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov, columns(statistics) 
 statistics(mean)  format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary 
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_show==1, 
 columns(statistics) statistics(mean)  format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_show==1 & anyshow==1, 
 columns(statistics) statistics(mean) format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_show==1 & anyshow==0, 
 columns(statistics) statistics(mean) format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_closeshow5==1, 
 columns(statistics) statistics(mean) format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_closeshow5==1 & 
 anycloseshow5==1, columns(statistics) statistics(mean) format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_closeshow5==1 & 
 anycloseshow5==0, columns(statistics) statistics(mean) format(%9.3f);
tabstat pc_nghomicide pc_ghomicide pc_ngassault pc_gassault pc_ngrape pc_grape pc_ngrobbery pc_grobbery pc_auto pc_theft pc_burglary
 pc_ngviolent pc_gviolent pc_property p_total p_density arealand pc_rural pc_hspnc pc_black pc_blw_pov if tract_has_show==0, 
 columns(statistics) statistics(mean) format(%9.3f);

**number of tracts and tracts*weeks;
*tracts;
count if tag==1;
count if tag==1 & tract_has_show==1;
count if tag==1 & tract_has_show==1 & anyshow==1;
count if tag==1 & tract_has_show==1 & anyshow==0;
count if tag==1 & tract_has_closeshow5==1;
count if tag==1 & tract_has_closeshow5==1 & anycloseshow5==1;
count if tag==1 & tract_has_closeshow5==1 & anycloseshow5==0;
count if tag==1 & tract_has_show==0;

*tract*weeks;
count;
count if tract_has_show==1;
count if tract_has_show==1 & anyshow==1;
count if tract_has_show==1 & anyshow==0;
count if tract_has_closeshow5==1;
count if tract_has_closeshow5==1 & anycloseshow5==1;
count if tract_has_closeshow5==1 & anycloseshow5==0;
count if tract_has_show==0;

/* DO ONLY TABLE 1B FOR NOW 

*******TABLE 2: Where do gun shows take place? Evidence from Texas and California;
!gunzip ${josh}merged.dta.gz;
 use ${josh}merged.dta, clear;

tabstat p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide if zip_has_show==1 & tag==1, 
columns(statistics) statistics(mean) by(state);
tabstat p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide if zip_has_show==0 & tag==1, 
 columns(statistics) statistics(mean) by(state);
tabstat p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide if zip_has_closeshow10==1 & tag==1, 
 columns(statistics) statistics(mean) by(state);
tabstat p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide if zip_has_closeshow10==0 & tag==1, 
 columns(statistics) statistics(mean) by(state);

estimates clear;

foreach s in ca tx {;
 foreach z in zip_has_show zip_has_closeshow10 {;
  if "`z'"=="zip_has_show" {; local t="1"; };
  if "`z'"=="zip_has_closeshow10" {; local t="2"; };
  foreach v in p_total p_density arealanm pc_rural pc_hspnc pc_black pc_blw_pov zip_in_msa frac_gsuicide {;

   display "`v' `z' `s'";
   reg `v' `z' if tag==1 & state=="`s'", cluster(zcta5);
   estimates store t2`v'`t'`s';
  }; *close demographics loop; 
 }; *close radius loop;
}; *close state loop;

estout _all using ${tables}table2_final.txt, cells(b(star fmt(%9.3f)) se(par)) replace order(zip_has_show zip_has_closeshow10 _cons) 
 starlevels(* .10 ** .05 *** .01) stats(N r2, fmt(%9.0g %9.3f) labels("Observations" "R-squared"));

estimates clear;



*****APPENDIX TABLE 1: Demographic, Gun Show and Gun Death Characteristics (mean, median and standard deviation only);
tabstat numshows_pre3_4 numshows_pre2 numshows_pre1 numshows_post0 numshows_post1 numshows_post2_3 closeshows10_pre3_4 closeshows10_pre2 
 closeshows10_pre1 closeshows10_post0 closeshows10_post1 closeshows10_post2_3 deaths gdeaths ghomicide nghomicide gsuicide ngsuicide 
 gacc_undet p_total arealanm p_density pc_urban-pc_abv_pov frac_gsuicide p_cap_incm if zip_has_closeshow10==1, columns(statistics) 
 statistics(mean med sd) format(%9.3f) by(state);
*/


*!gzip ${bulk}new_vars_houston2.dta;
log close;

END;





************************************************
************************************************;


/*    IGNORE - OLD CODE

*****TABLE 1b: Demographics;
tabstat p_total arealanm p_density pc_urban-pc_abv_pov p_cap_incm if tag==1, columns(statistics) statistics(min p10 p25 p50 p75 p90 max n) 
 format(%9.2f) by(state);

*****TABLE 1d: Demographics;
tabstat p_total arealanm p_density pc_urban-pc_abv_pov p_cap_incm if tag==1 & zip_has_closeshow10==1, columns(statistics) 
 statistics(min p10 p25 p50 p75 p90 max n) format(%9.2f) by(state);

***TABLE 1d: Demographic, Gun Show and Gun Death Characteristics (full distribution);
tabstat numshows_pre3_4 numshows_pre2 numshows_pre1 numshows_post0 numshows_post1 numshows_post2_3 closeshows10_pre3_4 closeshows10_pre2 
 closeshows10_pre1 closeshows10_post0 closeshows10_post1 closeshows10_post2_3 deaths gdeaths ghomicide nghomicide gsuicide ngsuicide 
 gacc_undet p_total arealanm p_density pc_urban-pc_abv_pov frac_gsuicide p_cap_incm if zip_has_closeshow10==1, columns(statistics) 
 statistics(min p10 p25 p50 p75 p90 max n) format(%9.3f) by(state);
*/



!gzip ${josh}new_vars.dta;
!gzip ${josh}merged.dta; 
log close;










