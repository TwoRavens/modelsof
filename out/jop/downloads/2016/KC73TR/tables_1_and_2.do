/**************************************************/
/* Create Table 1 */
/**************************************************/
#delimit;
use data/credit_data, clear;

 
capture program drop norm;
program define norm;
 summarize  `1';
 replace `1' = (`1'-r(min))/(r(max)-r(min));
 summarize  `1';
end;


norm  all_mort_30_change;
norm  all_mort_90_change;
norm all_mort_90_change0807; 
norm all_mort_30_change0807;
norm  all_mort_90_change0908;

 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  if year == 2008 [aw=total_reg], cluster(county);
	outreg2 using results/table_1, replace word auto(2) se; 

 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  if year == 2008 [aw=total_reg], cluster(county); 
	outreg2 using results/table_1, append word auto(2) se; 

 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000 iavginc* if year == 2008 [aw=total_reg], cluster(county); 
	outreg2 using results/table_1, append word auto(2) se; 

/**************************************************/
/* Create Table 2 -robustness */
/**************************************************/
#delimit cr

use data/credit_data, clear
sum dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000 iavginc* if year == 2008
keep if dem_prs_share!=.
 
 norm  all_mort_30_change
norm  all_mort_90_change
norm all_mort_90_change0807 
norm all_mort_30_change0807
norm  all_mort_90_change0908

xtile vote_2004_4 = L4.dem_prs_share , n(4)	
xtile total_pop_2 = total_pop, n(2)	

file open myfile using results/table_2.rtf, write replace
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000 iavginc* if year == 2008 [aw=total_reg], cluster(county) 
  	file write myfile %9s "Change in share of mortgages 90+ days delinquent, 2006-2008 (Table 1, Col. 3)" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
    file write myfile %9s " " _tab   _n 
 reg dem_prs_share all_mort_90_change0807  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 [aw=total_reg], cluster(county)
  	file write myfile %9s "Change in share of mortgages 90+ days delinquent, 2007-2008" _tab %7.1f (_b[all_mort_90_change0807]) "(" %-1.3g (_se[all_mort_90_change0807]) ")"  _n 
 reg dem_prs_share all_mort_30_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 [aw=total_reg], cluster(county)
  	file write myfile %9s "Change in share of mortgages 30+ days delinquent, 2006-2008" _tab %7.1f (_b[all_mort_30_change]) "(" %-1.3g (_se[all_mort_30_change]) ")"  _n 
 reg dem_prs_share all_mort_30_change0807  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 [aw=total_reg], cluster(county)
  	file write myfile %9s "Change in share of mortgages 30+ days delinquent, 2007-2008" _tab %7.1f (_b[all_mort_30_change0807]) "(" %-1.3g (_se[all_mort_30_change0807]) ")"  _n 
    file write myfile %9s " " _tab   _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc* iblack_migration_percent iwhite_migration_percent ihispanic_migration_percent if year == 2008 [aw=total_reg], cluster(county)
  	file write myfile %9s "Controlling for black, hispanic, and white migration" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
    file write myfile %9s " " _tab   _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 & vote_2004_4==1 [aw=total_reg], cluster(county)
  	file write myfile %9s "1st quartile of 2004 Democratic vote" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 & vote_2004_4==2 [aw=total_reg], cluster(county)
  	file write myfile %9s "2nd quartile of 2004 Democratic vote" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 & vote_2004_4==3 [aw=total_reg], cluster(county)
  	file write myfile %9s "3rd quartile of 2004 Democratic vote" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 & vote_2004_4==4 [aw=total_reg], cluster(county)
  	file write myfile %9s "4th quartile of 2004 Democratic vote" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 	
    file write myfile %9s " " _tab   _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 &total_pop_2 == 1 , cluster(county)
  	file write myfile %9s "Below the median zip-code population (no weights)" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
 reg dem_prs_share all_mort_90_change  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000  iavginc*  if year == 2008 & total_pop_2 == 2 , cluster(county)
  	file write myfile %9s "Above the median zip-code population (no weights)" _tab %7.1f (_b[all_mort_90_change]) "(" %-1.3g (_se[all_mort_90_change]) ")"  _n 
    file write myfile %9s " " _tab   _n 
    file write myfile %9s "Placebo Tests Using Post-Election Economy Measure (zip code level)" _tab   _n 
 reg dem_prs_share all_mort_90_change0908  L4.dem_prs_share  iblackp_2000 iwhitep_2000 ihispp_2000 iavginc* if year == 2008 [aw=total_reg], cluster(county) 
  	file write myfile %9s "Change in share of mortgages 90+ days delinquent, 2008-2009" _tab %7.1f (_b[all_mort_90_change0908]) "(" %-1.3g (_se[all_mort_90_change0908]) ")"  _n 
file close myfile 
