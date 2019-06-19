/* REPLICATION FILES for the article:
Spillovers from High-Skill Consumption to Low-Skill Labor Markets 
Francesca Mazzolari and Giuseppe Ragusa
REStat, March 2013, 95(1), 74-86

do file: 02_census.do

 This do file produces descriptive tables and figures:
  - Table B2 (in the on-line appendix B)
  - Figures 2 and 3 (in the paper)
  - Figures B1, B2 and B3 (in the on-line appendix B)
*/
 

* Set path to WORKING DIRECTORY
cd ~/scratch/Rep
set more off
use data/indiv80_90_00_05.dta, clear/*See do/01_census.do for more details on the construction of the sampleand definition of the variables*/keep if wagesamp==1* The sample is restricted to workers for salarykeep if metaread>0    /*metaread==0 not identifiable or not in an MSA*/* RESTRICT the analysis to the population that resides in a metropolitan statistical area (MSA)******************************************************************************** SUMMARY STATISTICS******************************************************************************* TABLE B2 (starts here) *** Calculate wage percentilesforeach i in 10 20 30 40 50 60 70 80 90 {by year, sort: egen hwg_p`i'=pctile(hrwage_CPI04), p(`i')}gen hwg_decile=0recode hwg_decile 0=10  if hrwage_CPI04<=hwg_p10                         recode hwg_decile 0=20  if hrwage_CPI04>hwg_p10 & hrwage_CPI04<=hwg_p20 recode hwg_decile 0=30  if hrwage_CPI04>hwg_p20 & hrwage_CPI04<=hwg_p30 recode hwg_decile 0=40  if hrwage_CPI04>hwg_p30 & hrwage_CPI04<=hwg_p40 recode hwg_decile 0=50  if hrwage_CPI04>hwg_p40 & hrwage_CPI04<=hwg_p50 recode hwg_decile 0=60  if hrwage_CPI04>hwg_p50 & hrwage_CPI04<=hwg_p60 recode hwg_decile 0=70  if hrwage_CPI04>hwg_p60 & hrwage_CPI04<=hwg_p70 recode hwg_decile 0=80  if hrwage_CPI04>hwg_p70 & hrwage_CPI04<=hwg_p80 recode hwg_decile 0=90  if hrwage_CPI04>hwg_p80 & hrwage_CPI04<=hwg_p90 recode hwg_decile 0=100 if hrwage_CPI04>hwg_p90                         label define hwg_decile 10 "Below 10" 20 "Between 10 and 20" 30 "Between 20 and 30" 40 "Between 30 and 40" 50 "Between 40 and 50"  60 "Between 50 and 60" 70 "Between 60 and 70"  80 "Between 70 and 80" 90 "Between 80 and 90"  100 "Above 90"  label values hwg_decile hwg_decile*Employment shares in different sectors by wage decile and year, 1980-2005by hwg_decile, sort: tabstat HOME_ind otherNT_ind TR Hotels CO WT FI BS PA ED HOME_occ otherNT_occ if wagesamp==1 [fweight = lswt], statistics( mean ) by(year) columns(statistics)** TABLE B2 (ends here) ***Generate Categorical Variable for six sectoral groupsgen sector_nt_6cat=0recode sector_nt_6cat 0=1 if HOME_indrecode sector_nt_6cat 0=2 if otherNT_indrecode sector_nt_6cat 0=3 if CO | Hotelsrecode sector_nt_6cat 0=4 if TR | WTrecode sector_nt_6cat 0=5 if FI | BSrecode sector_nt_6cat 0=6 if PA | EDlabel var sector_nt_6cat "Sector"label define sector 1 "HP sub's" 2 "Other NT" 3 "CO&Hotels" 4 "TR&WT" 5  "FI&BS" 6 "PA&ED"label values sector_nt_6cat sector 
** Figure B1 *** Contribution of specific subsectors of home production substitutegraph bar (mean) HOME_ind_eat HOME_ind_pers HOME_ind_child HOME_ind_other  if year==2005 [weight=lswt] , over(hwg_decile, relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10"))  ytitle (Sectoral Employment Shares in Each Wage Decile) stack ylabel(, angle(horizontal)) legend(order(1 "Restaurants" 2 "Personal Services" 3 "Child Care" 4 "Other HP sub's"))** Figure B2 *** FEMALE share (foreign and native) by sector in 2005gen female=1-malegen female_native=(female==1 & foreign==0)gen female_foreign=(female==1 & foreign==1)graph bar (mean) female_foreign female_native if year==2005 [weight=lswt], over(sector_nt_6cat) stack ytitle(Female share of sectoral workforce) legend(order(1 "Foreign-born Females" 2 "Native Females" ))
** Figure B3 *** Immigrant share (5 years or less, or more than 5 years) by sector in 2005gen foreign_morethan5=(foreign==1 & foreign_5yrs_orless==0)graph bar (mean) foreign_5yrs_orless foreign_morethan5 if year==2005 [weight=lswt], over(sector_nt_6cat) stack ytitle(Immigrant share of sectoral workforce)  legend(order(1 "Recent Immigrants (5 years or less)" 2 "Other Immigrants" ))** Figure 2 *** Store temporary individual level data* to be re-used after data are collapsedsave data/tmp/indiv80_90_00_05_sumstats.dta, replacesort year hwg_decile sector_nt_6catcollapse (sum) hours_ind_yr_hrwdec=lswt, by (year hwg_decile sector_nt_6cat)by hwg_decile year, sort: egen hours_yr_hrwdec=sum(hours_ind_yr_hrwdec)gen indsh_yr=hours_ind_yr_hrwdec/hours_yr_hrwdeclabel define sector2 1 "Home production sub's" 2 "Other non-traded jobs" 3 "Construction and Hotels" 4 "Trade and Wholesale" 5  "Finance and Business" 6 "PA and Education"label values sector_nt_6cat sector2label var sector_nt_6cat "sector"graph bar (mean) indsh_yr  if year==2005, over(hwg_decile, relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10")) by(sector_nt_6cat)  ytitle (Sectoral Employment Shares in Each Wage Decile) stack ylabel(, angle(horizontal))
** Figure 3 *** Employment shares in different sectors in the bottom two and the height highest deciles of the hourly wage distribution; 1980, 1990, 2000 and 2005 use data/tmp/indiv80_90_00_05_sumstats.dta, cleargen hwg_decile_2= hwg_decilerecode hwg_decile_2 10/20=1 30/100=2label define hwg_decile_2 1 "bottom two deciles" 2 "deciles 3 through 10" sort year hwg_decile_2 sector_nt_6catcollapse (sum) hours_ind_yr_hrwdec=lswt, by (year hwg_decile_2 sector_nt_6cat)by hwg_decile_2 year, sort: egen hours_yr_hrwdec=sum(hours_ind_yr_hrwdec)gen indsh_yr=hours_ind_yr_hrwdec/hours_yr_hrwdeclabel values sector_nt_6cat sector2label var sector_nt_6cat "sector"twoway (connected indsh_yr year if hwg_decile_2==1, sort) (connected indsh_yr year if hwg_decile_2==2, msymbol(triangle)), ytitle(Sectoral Employment Shares in Wage Deciles) xtitle(, size(zero)) xscale(range(1980 2005)) xlabel( 1980 1990 2000 2005 "05") legend(order(1 "bottom 2 deciles" 2 "deciles 3 through 10")) by(sector_nt_6cat)rm data/tmp/indiv80_90_00_05_sumstats.dta