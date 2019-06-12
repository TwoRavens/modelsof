*************************************
****************
*** CREATING THE ANALYSIS DATA FILE
****************
*************************************

*** Start ISSP_LFS_may29.dta, which is the original dataset Philippe Rehm provided. It has 178,405 observations. 
*** Next, merged in cleaned 2006-2010 ISSP waves, which produced a dataset of 239,708 observations. The code is as follows:
 
*** use "/Users/ahertel/Dropbox/Torben RA Work/Micro Dataset/ISSP_LFS_may29.dta", clear

*** First, merge the two former parts of Germany 
*** gen ccode_DE = ccode
*** recode ccode_DE (261=255) (262=255)

*** Update this file with waves subsequent to Philippe's data: this appended dataset appears in the replication materials 
*** append using "/Users/ahertel/Dropbox/Torben RA Work/Micro Dataset/2006-2010 Merged/issp060910_merged_formatted_lfsdata.dta"
***save "/Users/ahertel/Dropbox/Torben RA Work/Micro Dataset/Full Merged/ISSP_LFS_85_10_AHF.dta", replace
 
*** Drop if countries aren't in sample
	
*** drop if ccode==.
*** save "/Users/ahertel/Dropbox/Torben RA Work/Micro Dataset/Full Merged/ISSP_LFS_85_10_AHF_C.dta", replace
*** drop _merge

*** Now add national covariates 

*** merge m:1 ccode_DE yr_field using "/Users/ahertel/Dropbox/Torben RA Work/Macro Variables/macro_vars_styr_5:29.dta"
*** This file is also supplied with the replication materials, along with the Excel file giving definitions and sources.

*** save "/Users/ahertel/Dropbox/Torben RA Work/Micro Dataset/Full Merged/ISSP_LFS_85_10_AHF_C_NatlVars_7:20.dta", replace

*** This file, the original plus the supplied updated waves and national covariates, is our main analytic file

*** To generate the analysis dataset provided:
*** Drop all unused variables and select all observations that appear in any of the tables presented in the paper or supplementary materials.
*** This step uses sample definitions that relate to analyses run: e.g. inologit = observation is in Table 1 (generated from e(sample) after running the analysis)

*** select if incolumn1 ==1 | incolumn2 ==1 | incolumn3 == 1 
*** All of those variables are described in the do-file below.

*** This produces the analysis dataset, which has 129,284 observations
**********************************************************************

*** Consistent identifier
*** The variable "id" is the consistentent identifier that matches observations back to our original master data file. It is created on one basis up to 2006, and on a different basis thereafter. It cannot be linked to the original ISSP microdata, which we do not have.
*** 
**********************************************************************

*************************************
****************
*** ABSOLUTELY FINAL MODELS, APPENDIX, GRAPHS
****************
*************************************

*** START HERE to replicate results:  Tables 1 and 2, Figure 1 and all supplementary materials
*** STOP where indicated at Line 335. All results are replicated by then. 
*** NOTES: 1. All output tables were created with outreg2, converting to XML files and editing those with Excel.
***        2. The variable used in regressions, income_new, equals income - 1, so its values go from 0 to 8. This simplifies interactions. 
***          Since income_new = 0 is always dropped in calculating interactions, the omitted category is income = 1, and estimates are provided
***          for income values 2 through 9.
***        3. The variable ethnic_minority_recode in the dataset is called Minority self-designated in text and tables.
****************
*** ABSOLUTELY FINAL TABLE 1 FULL MODEL OF REDISTRIBUTION PREFERENCES
****************

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if inologit == 1 [pweight=iweight]  , cluster(clus)

****************
*** ABSOLUTELY FINAL TABLE 2 MINORITIES ANALYSIS
****************

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if minority_case > 0 [pweight=iweight]  , cluster(clus)

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode min_share_poor2 minxminsp unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if minority_case > 0 [pweight=iweight]  , cluster(clus)

*** non-US only  quietly ologit ws44 risk_income_constant risk_within s1_lfs skew2 i.income income_new_times_skew2 unemprate age1 educdg female unempl nonempl student i.ethnic_minority_recode min_share_poor2 minxminsp income_new#c.ethnic_frag_imput i.ctry_year  if minority_case == 1 & ccode~=2  [pweight=iweight] , cluster(clus)

****************
*** ABSOLUTELY FINAL FIGURE 1
****************
****************

**** Need same with ws44_dummy for Figures 1

*** gen ws44_dummy=ws44
*** recode ws44_dummy 1=0 2=0 3=1 4=1

************
***** FIGURE 1a Combined model / marginal effects of segmentation:
************

centile segment_ratio if incolumn3==1, centile(5,95)

*** [record observed values 1.193777 1.493762]

***
*** FOR segmentation_ratio, NEW DATA FILE IS "Data for Figure_1_a.dta"
***

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

*** low segmentation 

margins, at(income=1 income_new=0 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** I cut and paste it directly into the Stata data editor (using "copy table"). In then delete the columns we don't need. 
*** So for a single margins output there will be one column for minority share and three for the estimated probabilities at
*** the mean and at the 5th and 95th percentiles (which makes up one line with CI's).
 
*** high segmentation: 

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

margins, at(income=1 income_new=0 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file: Data for Figure_1_a.dta ] Need to have the correct local folder for next instruction

Use "Data for Figure_1_a.dta"

*** twoway (rline p_segm_comb_l_5 p_segm_comb_l_95 income, lcolor(black) lwidth(thin) lpattern(longdash_3dot)) (rline p_segm_comb_h_5 p_segm_comb_h_95 income, lcolor(black) lwidth(thin) lpattern(longdash)) (line p_segm_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_segm_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash)), ytitle(Probability of support) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9) legend(off)

***  or for grayscale as used in paper: edit border and insert text labels with Graph editor

twoway (rarea p_segm_comb_l_5 p_segm_comb_l_95 income, fcolor(gs14) lcolor(gs14) lwidth(vvvthin)) (rarea p_segm_comb_h_5 p_segm_comb_h_95 income, fcolor(gs14) lcolor(gs14)) (line p_segm_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_segm_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash)), ytitle(Probability of support) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9) legend(off)

*** TEST of slope equivalance:

reg p_segm_comb_l income
estimates store sequallow
reg p_segm_comb_h income
estimates store sequalhigh
suest sequallow sequalhigh
test [sequallow_mean]income-[sequalhigh_mean]income = 0

**********
***** FIGURE 1b Combined model / marginal effects of distance:
**********


centile distance if incolumn3==1, centile(5,95)
*** [record values  .815534, 1.115385]

***
*** FOR distance, NEW DATA FILE IS "Data for Figure_1_b.dta"
***

*** low distance 

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

margins, at(income=1 income_new=0 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 distance=.815534 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** high distance: 

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

margins, at(income=1 income_new=0 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 distance=1.115385 (mean) risk_within s1_lfs segment_ratio ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** [copy results into new data file: Data for Figure_1_b.dta ] Need to have the correct local folder for next instruction

use "Data for Figure_1_b.dta"

*** twoway (line p_skew_comb_l income, msize(zero) lcolor(black) lwidth(thick) lpattern (longdash_3dot)) (line p_skew_comb_l_5 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash_3dot)) (line p_skew_comb_l_95 income, msize(zero) lcolor(gray)lwidth(medium thin) lpattern(longdash_3dot)) (line p_skew_comb_h income, msize(zero) lcolor(black) lwidth(thick) lpattern (longdash)) (line p_skew_comb_h_5 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash)) (line p_skew_comb_h_95 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).65) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9, ticks) legend(off)

*** twoway (line p_distance_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_distance_comb_l_5 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_l_95 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash) ) (line p_distance_comb_h_5 income, lcolor(gray) lwidth(medium) lpattern(longdash)) (line p_distance_comb_h_95 income, lcolor(gray) lwidth(medium) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).8) xtitle(Income in nine (national) quantiles) xlabel(1(1)9) legend(off)

***  or for grayscale: edit border and insert text labels with Graph editor

twoway (rarea p_distance_comb_l_5 p_distance_comb_l_95 income, fcolor(gs14) lcolor(gs14) lwidth(vvvthin)) (rarea p_distance_comb_h_5 p_distance_comb_h_95 income, fcolor(gs14) lcolor(gs14)) (line p_distance_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_distance_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash)), ytitle(Probability of support) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9) legend(off)

*** twoway (line p_distance_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_distance_comb_l_5 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_l_95 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash) ) (line p_distance_comb_h_5 income, lcolor(gray) lwidth(medium) lpattern(longdash)) (line p_distance_comb_h_95 income, lcolor(gray) lwidth(medium) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).8) xtitle(Income in nine (national) quantiles) xlabel(1(1)9) legend(off)

*** TEST of slope equivalance:

reg p_distance_comb_l income
estimates store dequallow
reg p_distance_comb_h income
estimates store dequalhigh
suest dequallow dequalhigh
test [dequallow_mean]income-[dequalhigh_mean]income = 0


*******************
****************
*** ABSOLUTELY FINAL SUPPLEMENTARY MATERIALS
****************
*******************


*** Part 1 is variable definitions (also in .cbk file)

*** Part 2 is samples (code for 2E) and summary statistics

summ ws44 unemppref unempl unemprate s1_lfs segment_ratio risk_within distance ethnic_frag_imput ethnic_minority_recode min_share_poor2 income age1 educdg female nonempl student lr if inologit==1

**** Needs code for Figures SM1 and SM2

*** Part 3 is detailed derivation of model (no code)

*** Part 4 is linear relation between occupational risk and income

*** In main datafile, use the following instruction:

twoway (lfit fm_ur_1d income, lwidth(medthick)) (lowess fm_ur_1d income, lwidth(medium)), ytitle(Occupational unemployment rate) 


*** Part 5 is average marginal effect of distance and segmentation (with code for regessions, figures, and test statstics)

***** Combined model:

********* segmentation 

centile segment_ratio if incolumn3==1, centile(5,95)

*** [record values]

*** whole sample:

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

margins, at(segment_ratio=1.193777) at(segment_ratio=1.493762) atmeans pwcompare

*** Ethnic majority:

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 & ethnic_minority_recode==0 [pweight=iweight]  , cluster(clus)

margins, at(segment_ratio=1.193777) at(segment_ratio=1.493762) atmeans pwcompare

*** Economic majority:

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if income>3 & incolumn3 == 1 [pweight=iweight]  , cluster(clus)

margins, at(segment_ratio=1.193777) at(segment_ratio=1.493762) atmeans pwcompare

*** [Copy results in Stata editor]


******** distance:

centile distance if incolumn3==1, centile(5,95)

*** [record values]

*** whole sample:

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

margins, at(distance=.815534) at(distance=1.115385) atmeans pwcompare

*** Ethnic majority:

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 & ethnic_minority_recode==0 [pweight=iweight]  , cluster(clus)

margins, at(distance=.815534) at(distance=1.115385) atmeans pwcompare

*** Economic majority:

logit ws44_dummy segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 & income>3 [pweight=iweight]  , cluster(clus)

margins, at(distance=.815534) at(distance=1.115385) atmeans pwcompare

*** [Copy results in Stata editor and save results in local folder as "Figure_direct_effects.dta"]

*** This dataset is in the replication materials provided
use "Figure_direct_effects.dta", clear

graph box skew_full skew_eth_maj skew_econ_maj segment_full  segment_eth_maj segemnt_econ_maj, box(1, fcolor(gray) lcolor(none) lwidth(none) lpattern(dot)) box(2, fcolor(gray) lcolor(none) lwidth(none) lpattern(dot)) box(3, fcolor(gray) lcolor(none) lpattern(dot)) box(4, fcolor(gray) lcolor(none) lpattern(dot)) box(5, fcolor(gray) lcolor(none) lpattern(dot)) box(6, fcolor(gray) lcolor(none) lwidth(none) lpattern(dot)) medtype(cline) medline(lcolor(black) lpattern(solid)) ytitle(Predicted effect) legend(off)


*** Part 6 is separate estimates for distance and segmentation 

*** Column 1 AFFINITY only 
ologit ws44 i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag i.year i.ctry_short if incolumn2 == 1 [pweight=iweight]  , cluster(clus)

*** Column 2 RISK only
ologit ws44 segment_ratio risk_within s1_lfs i.income_new unemprate age1 educdg female unempl nonempl student   income_new#c.segment_ratio i.year i.ctry_short if incolumn1 == 1 [pweight=iweight]  , cluster(clus)

*** Part 7 is ISSC minorities data: full models underlying Table 2

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if minority_case > 0 [pweight=iweight]  , cluster(clus)

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode min_share_poor2 minxminsp unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if minority_case > 0 [pweight=iweight]  , cluster(clus)

*** non-US only  ologit ws44 risk_income_constant risk_within s1_lfs skew2 i.income income_new_times_skew2 unemprate age1 educdg female unempl nonempl student i.ethnic_minority_recode min_share_poor2 minxminsp income_new#c.ethnic_frag_imput i.ctry_year  if minority_case == 1 & ccode~=2  [pweight=iweight] , cluster(clus)


*** Part 8 is Robustness

*** (1) Linear probability version of model

reg ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

***  (2)Table 1 with C-Y FEs

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.ctry_year if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

***  (3)Table 1 with lr added

ologit ws44 lr segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

***  (4)Table 1 without PO

*** column 4: to drop PO ADD "if ccode_DE != 235" TO (2) with i.year and i.ctry_short

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 & ccode_DE != 235 [pweight=iweight]  , cluster(clus)

***  (5)Table 1 without PO, NZ

*** column 5: to drop PO and NZ ADD "if (ccode_DE != 235 & ccode_DE != 920" TO (2) with i.year and i.ctry_short

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 & (ccode_DE != 235 & ccode_DE != 920) [pweight=iweight]  , cluster(clus)

*** column 6 is Table 1, full model, with spending for unemployment benefits as dependent variable

ologit unemppref risk_income_constant risk_within s1_lfs skew2 i.income unemprate age1 educdg female unempl nonempl student income_new#c.skew2 i.ethnic_minority_recode income_new#c.ethnic_frag_imput i.year i.ctry_short if incolumn3 == 1  [pweight=iweight] , cluster(clus)

*************************
*************************
*** STOP replication here. From here on down all lines are already in AJPS data file, these are transition
*** from original data to analysis file. Note:

*** 1. You cannot run any instruction that creates a variable from the analysis file without first dropping it.

*** 2.  The code below contains some instructions and variables that are no longer needed to replicate any results presented.

*** 3. The analysis datafile contains a number of variables that are not needed to replicate our results.

*************************
*************************



by ccode year, sort: egen risk_low=mean(fm_ur_1d) if income<5
by ccode year, sort: egen risk_high=mean(fm_ur_1d) if income>5
by ccode year, sort: egen risk_low_2 = mean(risk_low)
by ccode year, sort: egen risk_high_2 = mean(risk_high)
by ccode, sort: egen risk_ratio2_av_country = mean(risk_ratio2)
by ccode, sort: egen skew2_av_country = mean(skew2)
twoway (scatter skew2_av_country risk_ratio2_av_country, mlabel(ccode)) if ctry_short~=. & ccode~=235, ytitle(Skew) xtitle(Risk ratio)


gen risk_ratio2 = risk_low_2/risk_high_2
gen income_times_risk_ratio = income * risk_ratio2
gen skew2= d9d5/ d5d1
gen income_times_skew2 = income * skew2

****************
*** ALTERNATE CODING OF DISTANCE
****************

gen distance = 1/skew2

segmentation:

by ccode year, sort: egen risk_low2=mean(fm_ur_1d) if income<3
by ccode year, sort: egen risk_high2=mean(fm_ur_1d) if income>4
by ccode year, sort: egen risk_low_22 = mean(risk_low2)
by ccode year, sort: egen risk_high_22 = mean(risk_high2)
gen segmentation = risk_low_22/risk_high_22
gen income_times_segmentation = income * segmentation


gen income_sq=income*income
gen income_sq_times_skew2 = income_sq * skew2

gen income_times_risk_ratio2 = income * risk_ratio2



*************************************************************
*** added 2/27
*** Generate country codes with East and West Germany merged
***
*** gen ccode_DE = ccode
*** recode ccode_DE (261=255) (262=255)
*************************************************************

egen age_av = mean(age1)
egen skew2_av = mean(skew2)
egen risk_ratio2_av = mean(risk_ratio2)
egen income_times_skew2_av = mean(income_times_skew2)
egen income_times_risk_ratio2_av = mean(income_times_risk_ratio2)

ge ctry_short = ccode_DE
replace ctry_short = . if(ccode_DE == 70 |ccode_DE == 155|ccode_DE == 211| ccode_DE == 212|ccode_DE == 290|ccode_DE == 310|ccode_DE == 316|ccode_DE == 317|ccode_DE == 349|ccode_DE == 350|ccode_DE == 366|ccode_DE == 395|ccode_DE == 640|ccode_DE == 666|ccode_DE == 730|ccode_DE == 740)

gen ws_42_a=redi4
recode ws_42_a 1=1 2=1 *=0
gen redpref2=ws_52_a
replace redpref2=ws_42_a if ws_52_a==.

*** Here is where you should begin, up to here everything is in the datafile already.


Graphs: 


egen fm_ur_1d_av=mean(fm_ur_1d) if redpref2~=.

gen income_times_fm_ur_1d_av=income*fm_ur_1d_av if redpref2~=.

egen educdg_av=mean(educdg) if redpref2~=.

egen skew2_av_b=mean(skew2) if redpref2~=.

gen income_times_skew2_av_b=income*skew2_av_b if redpref2~=.

egen risk_ratio2_av_b=mean(risk_ratio2) if redpref2~=.

gen income_times_risk_ratio2_av_b= income*risk_ratio2_av_b  if redpref2~=.

gen income_log_times_fm_ur_1d_ = income_log * fm_ur_1d_av

egen unempl_av=mean(unempl) if redpref2~=.

egen s1_lfs_av=mean(s1_lfs) if redpref2~=.



We first need several additional interaction terms for the graphs:

gen income_log_times_fm_ur_1d = income_log * fm_ur_1d

gen income_log_times_ethnic_frag_i = income_log * ethnic_frag_imput

egen ethnic_frag_imput_av = mean(ethnic_frag_imput) if redpref2~=.

gen income_log_times_ethnic_frag_av = income_log * ethnic_frag_imput_av

gen income_log_times_skew2_av_b=income_log*skew2_av_b 

gen income_log_times_risk_ratio2_av = income_log *risk_ratio2_av_b  





REDISTRIBUTION REGRESSIONS WITH NEW SEGMENTATION VARIABLE:
NO LONGER USED!

segmentation:


by ccode year, sort: egen risk_low2=mean(fm_ur_1d) if income<3
by ccode year, sort: egen risk_high2=mean(fm_ur_1d) if income>4
by ccode year, sort: egen risk_low_22 = mean(risk_low2)
by ccode year, sort: egen risk_high_22 = mean(risk_high2)
gen segmentation = risk_low_22/risk_high_22
gen income_times_segmentation = income * segmentation

egen segmentation_av = mean(segmentation)
gen income_times_segmentation_av =income * segmentation_av
egen s1_lfs_av = mean(s1_lfs)
egen unempl_av = mean(unempl)
egen ethnic_frag_av = mean(ethnic_frag)
gen income_times_ethnic_frag_av = income * ethnic_frag_av
gen income_times_skew2_av = income * skew2_av

ge inappendix1 = 1 if redpref2!=.
quietly logit redpref2 c.income c.fm_ur_1d unempl s1_lfs segmentation income_times_segmentation age1 educdg female nonempl student i.year i.ctry_short  [pweight=iweight], robust
ge incolumn1 = 1 if e(sample)
quietly logit redpref2 c.income skew2 income_times_skew2 c.income#c.ethnic_frag_imput age1 educdg female nonempl student i.year i.ctry_short  [pweight=iweight] , robust
ge incolumn2 = 1 if e(sample)
quietly logit redpref2 c.income c.fm_ur_1d unempl s1_lfs segmentation income_times_segmentation skew2 income_times_skew2 c.income#c.ethnic_frag_imput age1 educdg female nonempl student i.year i.ctry_short  [pweight=iweight] , robust
ge incolumn3 = 1 if e(sample)

Figure 1: 

twoway (lfit fm_ur_1d income, lwidth(medthick)) (lowess fm_ur_1d income, lwidth(medium)), ytitle(Occupational unemployment rate)

*****
**** Try to start here for confidence intervals 10/4/14 ***** The logit form below here is correct. The code for creating "_new" variables starts at 672. 
**** You have to jump away to 746 and then come back from there to 705 to finish the new creations and then back to here. Correct plots now at line 1259.
**** Appendix runs begin around 552.
*****

*************************************************************
***
*** DATA WORK
***
*************************************************************
***
*** COUNTRY-YEAR EFFECTS
***
ge ctry_year = 0
replace ctry_year = 1 if ccode_DE==2 & year == 1985
replace ctry_year = 52 if ccode_DE==2 & year == 1987
replace ctry_year = 53 if ccode_DE==2 & year == 1991
replace ctry_year = 54 if ccode_DE==2 & year == 1992
replace ctry_year = 55 if ccode_DE==2 & year == 1993
replace ctry_year = 56 if ccode_DE==2 & year == 1998
replace ctry_year = 57 if ccode_DE==2 & year == 2000
replace ctry_year = 58 if ccode_DE==2 & year == 2010
replace ctry_year = 2 if ccode_DE==2 & year == 1990
replace ctry_year = 3 if ccode_DE==2 & year == 1996
replace ctry_year = 4 if ccode_DE==2 & year == 2006
replace ctry_year = 5 if ccode_DE==20 & year == 1999
replace ctry_year = 6 if ccode_DE==20 & year == 2001
replace ctry_year = 7 if ccode_DE==20 & year == 2006
replace ctry_year = 8 if ccode_DE==200 & year == 1991
replace ctry_year = 9 if ccode_DE==200 & year == 1992
replace ctry_year = 10 if ccode_DE==200 & year == 1993
replace ctry_year = 11 if ccode_DE==200 & year == 1996
replace ctry_year = 12 if ccode_DE==200 & year == 1999
replace ctry_year = 13 if ccode_DE==200 & year == 2000
replace ctry_year = 14 if ccode_DE==200 & year == 2006
replace ctry_year = 15 if ccode_DE==200 & year == 2009
replace ctry_year = 16 if ccode_DE==200 & year == 2010
replace ctry_year = 17 if ccode_DE==205 & year == 2006
replace ctry_year = 18 if ccode_DE==225 & year == 1998
replace ctry_year = 19 if ccode_DE==225 & year == 2000
replace ctry_year = 20 if ccode_DE==230 & year == 2007
replace ctry_year = 21 if ccode_DE==235 & year == 2006
replace ctry_year = 22 if ccode_DE==255 & year == 1992
replace ctry_year = 23 if ccode_DE==255 & year == 1993
replace ctry_year = 24 if ccode_DE==255 & year == 1996
replace ctry_year = 25 if ccode_DE==255 & year == 1998
replace ctry_year = 26 if ccode_DE==255 & year == 2000
replace ctry_year = 27 if ccode_DE==255 & year == 2006
replace ctry_year = 28 if ccode_DE==375 & year == 2000
replace ctry_year = 29 if ccode_DE==375 & year == 2006
replace ctry_year = 30 if ccode_DE==375 & year == 2009
replace ctry_year = 31 if ccode_DE==380 & year == 1998
replace ctry_year = 32 if ccode_DE==380 & year == 1999
replace ctry_year = 33 if ccode_DE==380 & year == 2001
replace ctry_year = 34 if ccode_DE==380 & year == 2006
replace ctry_year = 35 if ccode_DE==380 & year == 2009
replace ctry_year = 36 if ccode_DE==385 & year == 1999
replace ctry_year = 37 if ccode_DE==385 & year == 2000
replace ctry_year = 38 if ccode_DE==385 & year == 2006
replace ctry_year = 39 if ccode_DE==390 & year == 1998
replace ctry_year = 40 if ccode_DE==390 & year == 2001
replace ctry_year = 41 if ccode_DE==390 & year == 2008
replace ctry_year = 42 if ccode_DE==390 & year == 2009
replace ctry_year = 43 if ccode_DE==900 & year == 1998
replace ctry_year = 44 if ccode_DE==900 & year == 1999
replace ctry_year = 45 if ccode_DE==900 & year == 2007
replace ctry_year = 46 if ccode_DE==920 & year == 1992
replace ctry_year = 47 if ccode_DE==920 & year == 1997
replace ctry_year = 48 if ccode_DE==920 & year == 1998
replace ctry_year = 49 if ccode_DE==920 & year == 1999
replace ctry_year = 50 if ccode_DE==920 & year == 2000
replace ctry_year = 51 if ccode_DE==920 & year == 2006
***replace ctry_year = 52 if ccode_DE==2 & year == 1987
***replace ctry_year = 53 if ccode_DE==2 & year == 1991
***replace ctry_year = 54 if ccode_DE==2 & year == 1992
***replace ctry_year = 55 if ccode_DE==2 & year == 1993
***replace ctry_year = 56 if ccode_DE==2 & year == 1998
***replace ctry_year = 57 if ccode_DE==2 & year == 2000
***replace ctry_year = 58 if ccode_DE==2 & year == 2010

***
*** NEW SEGMENTATION VARIABLE - ALREADY SAVED IN DATA
***

use "C:\Torben\Documents\Alt survey\Combined_working_ISSC_3_8_13.dta", clear

by income ccode year, sort: egen income_mean_risk = mean( fm_ur_1d)

*** above is done in current file
***
*** Needed for new nl approach

gen gamma=1
gen segment_new=1

*** Also set so the lowest value of income is 0:
gen income2=income-1
***
*** [Saved data file at this point so as to keep the above]

nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1985
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1985) 
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1987
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1987) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1989 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1989) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1990 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1990) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1991 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1991) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1992 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1992) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1993 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1993) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1996 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1996) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 2006) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==2 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 2, year, 2010) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==1992 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 1992) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==1993 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 1993) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==1996 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 1996) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==2001 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 2001) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==20 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 20, year, 2006) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==1991 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 1991) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==1992 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 1992) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==1993 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 1993) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==1996 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 1996) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 2006) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 2009) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==200 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 200, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==1989 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 1989) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==1991 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 1991) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==1993 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 1993) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==1996 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 1996) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==2001 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 2001) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==2003 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 2003) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==205 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 205, year, 2006) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==2005 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 2005) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==2007 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 2007) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 2009) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==225 & year==2011 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 225, year, 2011) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==1994 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 1994) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==1996 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 1996) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==2007 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 2007) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 2009) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==230 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 230, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==235 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 235, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==235 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 235, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==235 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 235, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==235 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 235, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==235 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 235, year, 2006) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==235 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 235, year, 2009) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==1992 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 1992) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==1993 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 1993) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==1996 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 1996) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==2003 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 2003) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 2006) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==255 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 255, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==305 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 305, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==305 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 305, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==305 & year==2001 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 305, year, 2001) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==305 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 305, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==305 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 305, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==325 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 325, year, 1997) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==375 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 375, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==375 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 375, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==375 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 375, year, 2006) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==375 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 375, year, 2009) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==375 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 375, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==2001 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 2001) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 2006) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 2009) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==380 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 380, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==385 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 385, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==385 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 385, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==385 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 385, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==385 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 385, year, 2006) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==2001 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 2001) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==2008 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 2008) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==2009 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 2009) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==390 & year==2010 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 390, year, 2010) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==900 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 900, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==900 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 900, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==900 & year==2005 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 900, year, 2005) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==900 & year==2007 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 900, year, 2007) append
***
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==1991 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 1991) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==1992 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 1992) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==1993 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 1993) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==1997 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 1997) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==1998 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 1998) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==1999 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 1999) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==2000 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 2000) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==2004 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 2004) append
nl (income_mean_risk=( {gamma}*gamma/(1+{segment_new}*segment_new*income2) ) )if income_mean_risk~=. & income~=. & ccode_DE==920 & year==2006 
regsave using  "/Users/jalt/Desktop/Race&Segment/Data/incomerisk_new.dta", addlabel(ccode_DE, 920, year, 2006) append

**********************************
**** Only needed in linear version
*** gen segmentation = (-1)*coef
**** Create within-group risk and interaction variables:
***** run same regression as before but with risk_within instead of fm_ur_1d and new interaction instead of old
**********************************

***
*** This now in file incomerisk_new.dta, var has the variables gamma and segment_new, r2 varies from .9826 to .9998
*** It takes two passes to save the new "constant" gamma_new and the new "coef" segment_new
***
sort var 
keep if var == "gamma:_cons"
sort ccode_DE year
save "/Users/jalt/Desktop/Race&Segment/Data/gamma_new.dta"
ge gamma_new = coef
ge stderr_gamma = stderr
drop var coef stderr N r2
save "/Users/jalt/Desktop/Race&Segment/Data/gamma_new.dta", replace

***Save as gamma_new.dta, then go back to incomerisk_new

keep if var == "segment_new:_cons"
sort ccode_DE year
save "/Users/jalt/Desktop/Race&Segment/Data/segment_new.dta", replace
ge segment_new = coef
ge stderr_segment = stderr
drop var coef stderr N r2
save "/Users/jalt/Desktop/Race&Segment/Data/segment_new.dta", replace

****
**** Here is where you go back to the original dataset for merge, use "Combine datasets" under Data

drop gamma segment_new
sort ccode_DE year
*** Now do the merge using both gamma_new and segment_new, many-to-one using ccode_DE and year as key variables, 164,967 cases in _merge (drop)
merge m:1 ccode_DE year using "/Users/jalt/Desktop/Race&Segment/Data/gamma_new.dta"
drop _merge
merge m:1 ccode_DE year using "/Users/jalt/Desktop/Race&Segment/Data/segment_new.dta"

gen risk_within = fm_ur_1d - income_mean_risk

gen income_times_segment_new = income * segment_new

gen risk_between = gamma_new/(1+income_times_segment_new)

gen income_new_times_segment_new = income_new * segment_new

*** sequence for new runs
ge risk_error = income_mean_risk - risk_between
replace risk_between = gamma_new/(1+income_new_times_segment_new)
replace risk_within = fm_ur_1d - risk_between

Ordered logit:

gen ws54=ws5 /*[this is the five category answer version of the redistribution question]*/

recode ws54 *=2 if ws_52_a==0 & ws54==3 /*[this recodes the middle category to match the way we dichotomized it]*/

recode ws54 *=4 if ws_52_a==1 & ws54==3

recode ws54 1=1 2=2 4=3 5=4 /*[using the same codes as the four-category variable]*/

gen ws44 = ws4 /*[this is the four category answer]*/

replace ws44=ws54 if ws44 == . /*[using the values from the 5-cat variable when the 4-cat variable is missing]*/

ologit ws44 c.income c.fm_ur_1d unempl s1_lfs segmentation income_times_segmentation skew2 income_times_skew2 c.income#c.ethnic_frag_imput age1 educdg female nonempl student i.year i.ctry_short  [pweight=iweight] , robust

ge inologit = 1 if e(sample)


gen risk_within = fm_ur_1d - income_mean_risk



*** RESET risk_income_constant TO CORRECT MEAN (done in my data already)

*** summ gamma_new if incolumn3 ==1
*** gen risk_income_constant= 7.607115/(1+income_new*segment_new)

*** No longer needed: replace risk_income_constant= 7.607115/(1+income_new*segment_new)

*** In data already: egen clus = group(ctry_short year income)

***
** if needed gen msdxmsp = ethnic_minority_recode * min_share_poor2
***

****************
*** ALTERNATE CODING OF INCOME*FRAGMENTATION-- NEED TO DO IT, ADJUST
*** Ensures that correct code (income_new == 0) is omitted when interactions are included
****************

***
*** Defines income_d1 - income_d9 corresponding to income_new (0,8) = income (1,9) 
tab income_new, gen(income_d)


gen income_d2_times_frag= income_d2*ethnic_frag_imput

gen income_d3_times_frag= income_d3*ethnic_frag_imput

gen income_d4_times_frag= income_d4*ethnic_frag_imput

gen income_d5_times_frag= income_d5*ethnic_frag_imput

gen income_d6_times_frag= income_d6*ethnic_frag_imput

gen income_d7_times_frag= income_d7*ethnic_frag_imput

gen income_d8_times_frag= income_d8*ethnic_frag_imput

gen income_d9_times_frag= income_d9*ethnic_frag_imput

 

*** ologit ws44 segment_ratio risk_within s1_lfs i.income_new skew2 i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.skew2 income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight]  , cluster(clus)

 
****************
*** ALTERNATE CODING OF SEGMENTATION
****************
gen segment_ratio_all = segment_ratio

by ccode year, sort: egen lower_y=mean(fm_ur_1d) if income<5 & incolumn3 == 1

by ccode year, sort: egen higher_y=mean(fm_ur_1d) if income>5 & incolumn3 == 1

by ccode year, sort: egen lower_y_risk=mean( lower_y) if incolumn3 == 1

by ccode year, sort: egen higher_y_risk=mean( higher_y) if incolumn3 == 1

gen segment_ratio= lower_y_risk/ higher_y_risk if incolumn3 == 1

ologit ws44 segment_ratio  risk_within s1_lfs i.income skew2 i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.skew2 income_new#c.ethnic_frag_imput income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight] , cluster(clus)

ologit ws44 segment_ratio  risk_within s1_lfs i.income skew2 i.ethnic_minority_recode min_share_poor2 unemprate age1 educdg female unempl nonempl student income_new#c.skew2 income_new#c.ethnic_frag_imput income_new#c.segment_ratio i.year i.ctry_short if incolumn3 == 1 [pweight=iweight] , cluster(clus)



***************************
This is code for 
Country to country segmentation
***************************

ologit ws44 segment_ratio risk_within s1_lfs i.income_new distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if inologit == 1 & (ccode_DE != 235 & ccode_DE != 920) [pweight=iweight]  , cluster(clus)


***** FIGURE 1a Combined model / segmentation

centile segment_ratio if inologit == 1 & (ccode_DE != 235 & ccode_DE != 920), centile(5,95)

[record values]

***
*** FOR segmentation_ratio, NEW DATA FILE IS "Data for Figure_1_a.dta"
***

logit unemppref_bin segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode ethnic_frag_imput unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if inologit == 1 & (ccode_DE != 235 & ccode_DE != 920) [pweight=iweight]  , cluster(clus)

*** low segmentation 

margins, at(income=1 income_new=0 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 segment_ratio=1.193777 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** I cut and paste it directly into the Stata data editor (using "copy table"). In then delete the columns we don't need. 
*** So for a single margins output there will be one column for minority share and three for the estimated probabilities at
*** the mean and at the 5th and 95th percentiles (which makes up one line with CI's).
 
*** high segmentation: 

logit unemppref_bin segment_ratio risk_within s1_lfs i.income distance i.ethnic_minority_recode ethnic_frag_imput unemprate age1 educdg female unempl nonempl student income_new#c.distance income_d2_times_frag income_d3_times_frag income_d4_times_frag income_d5_times_frag income_d6_times_frag income_d7_times_frag income_d8_times_frag income_d9_times_frag  income_new#c.segment_ratio i.year i.ctry_short if inologit == 1 & (ccode_DE != 235 & ccode_DE != 920) [pweight=iweight]  , cluster(clus)

margins, at(income=1 income_new=0 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 segment_ratio=1.493762 (mean) risk_within s1_lfs distance ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** use "name of new data file"

*** twoway (line p_segm_comb_l income, lcolor(black) lwidth(medthick)) (line p_segm_comb_l_5 income, lcolor(gray) lwidth(medium) lpattern(dash)) (line p_segm_comb_l_95 income, lcolor(gray) lwidth(medium) lpattern(dash)) (line p_segm_comb_h income, lcolor(black) lwidth(medthick)) (line p_segm_comb_h_5 income, lcolor(gray) lwidth(medium) lpattern(dash)) (line p_segm_comb_h_95 income, lcolor(gray) lwidth(medium) lpattern(dash)), ytitle(Probability of support) ylabel(.3(.05).8) xtitle(Income in nine (national) quantiles) xlabel(1(1)9) legend(off)
*** twoway (line p_segm_comb_l income, msize(zero) lcolor(black) lwidth(thick) lpattern (longdash_3dot)) (line p_segm_comb_l_5 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash_3dot)) (line p_segm_comb_l_95 income, msize(zero) lcolor(gray)lwidth(medium thin) lpattern(longdash_3dot)) (line p_segm_comb_h income, msize(zero) lcolor(black) lwidth(thick) lpattern (longdash)) (line p_segm_comb_h_5 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash)) (line p_segm_comb_h_95 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).65) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9, ticks) legend(off)

twoway (rline p_segm_comb_l_5 p_segm_comb_l_95 income, lcolor(black) lwidth(thin) lpattern(longdash_3dot)) (rline p_segm_comb_h_5 p_segm_comb_h_95 income, lcolor(black) lwidth(thin) lpattern(longdash)) (line p_segm_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_segm_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash)), ytitle(Probability of support) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9) legend(off)

***  or for grayscale

twoway (rarea p_segm_comb_l_5 p_segm_comb_l_95 income, fcolor(gs14) lcolor(gs14) lwidth(vvvthin)) (rarea p_segm_comb_h_5 p_segm_comb_h_95 income, fcolor(gs14) lcolor(gs14)) (line p_segm_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_segm_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash)), ytitle(Probability of support) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9) legend(off)

*** TEST of slope equivalance:

reg p_segm_comb_l income
estimates store sequallow
reg p_segm_comb_h income
estimates store sequalhigh
suest sequallow sequalhigh
test [sequallow_mean]income-[sequalhigh_mean]income = 0

**************************
Figure 1 b for separate model of affinity
***************************

centile distance if incolumn1==1, centile(5,95)
*** [record values]  .8196, 1.1429

***
*** FOR skew2, NEW DATA FILE IS "Data for Figure_1_b.dta"
***

*** low distance 

logit ws44_dummy i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput i.year i.ctry_short if incolumn2 == 1 [pweight=iweight]  , cluster(clus)

margins, at(income=1 income_new=0 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 distance=.8196 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** high distance: 

logit ws44_dummy i.income distance i.ethnic_minority_recode unemprate age1 educdg female unempl nonempl student income_new#c.distance income_new#c.ethnic_frag_imput i.year i.ctry_short if incolumn2 == 1 [pweight=iweight]  , cluster(clus)

margins, at(income=1 income_new=0 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=2 income_new=1 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=3 income_new=2 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=4 income_new=3 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=5 income_new=4 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=6 income_new=5 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=7 income_new=6 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=8 income_new=7 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) at(income=9 income_new=8 distance=1.1429 (mean) ethnic_minority_recode ethnic_frag_imput female unemprate age1 educdg unempl nonempl student ) post

*** [copy results into new data file]

*** use "name of new data file"

*** twoway (line p_segm_comb_l income, lcolor(black) lwidth(medthick)) (line p_segm_comb_l_5 income, lcolor(gray) lwidth(medium) lpattern(dash)) (line p_segm_comb_l_95 income, lcolor(gray) lwidth(medium) lpattern(dash)) (line p_segm_comb_h income, lcolor(black) lwidth(medthick)) (line p_segm_comb_h_5 income, lcolor(gray) lwidth(medium) lpattern(dash)) (line p_segm_comb_h_95 income, lcolor(gray) lwidth(medium) lpattern(dash)), ytitle(Probability of support) ylabel(.3(.05).8) xtitle(Income in nine (national) quantiles) xlabel(1(1)9) legend(off)

*** twoway (line p_skew_comb_l income, msize(zero) lcolor(black) lwidth(thick) lpattern (longdash_3dot)) (line p_skew_comb_l_5 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash_3dot)) (line p_skew_comb_l_95 income, msize(zero) lcolor(gray)lwidth(medium thin) lpattern(longdash_3dot)) (line p_skew_comb_h income, msize(zero) lcolor(black) lwidth(thick) lpattern (longdash)) (line p_skew_comb_h_5 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash)) (line p_skew_comb_h_95 income, msize(zero) lcolor(gray) lwidth(medium thin) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).65) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9, ticks) legend(off)

twoway (line p_distance_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_distance_comb_l_5 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_l_95 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash) ) (line p_distance_comb_h_5 income, lcolor(gray) lwidth(medium) lpattern(longdash)) (line p_distance_comb_h_95 income, lcolor(gray) lwidth(medium) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).8) xtitle(Income in nine (national) quantiles) xlabel(1(1)9) legend(off)

***  or for grayscale

twoway (rarea p_distance_comb_l_5 p_distance_comb_l_95 income, fcolor(gs14) lcolor(gs14) lwidth(vvvthin)) (rarea p_distance_comb_h_5 p_distance_comb_h_95 income, fcolor(gs14) lcolor(gs14)) (line p_distance_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_distance_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash)), ytitle(Probability of support) xtitle(Income in 9 (national) quantiles) xlabel(1(1)9) legend(off)
*** twoway (line p_distance_comb_l income, lcolor(black) lwidth(medthick) lpattern(longdash_3dot)) (line p_distance_comb_l_5 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_l_95 income, lcolor(gray) lwidth(medium) lpattern(longdash_3dot)) (line p_distance_comb_h income, lcolor(black) lwidth(medthick) lpattern(longdash) ) (line p_distance_comb_h_5 income, lcolor(gray) lwidth(medium) lpattern(longdash)) (line p_distance_comb_h_95 income, lcolor(gray) lwidth(medium) lpattern(longdash)), ytitle(Probability of support) ylabel(.3(.05).8) xtitle(Income in nine (national) quantiles) xlabel(1(1)9) legend(off)


