*******************************************************************
******REPLICATION FILE: RACIAL ISOLATION DRIVES RACIAL VOTING******
**********************POLITICAL BEHAVIOR***************************
******************MELISSA SANDS, DANIEL DE KADT********************
*******************************************************************

******************************************
***********AGGREGATE ANALYSES*************
******************************************
**Set Working Dir & Call Data**
cd "C:/Users/ddeka/Dropbox/South_Africa_segregation/replication_archive"
use "data/aggregate_data.dta", replace

**Local Macros**
local covariates "log_income1991 education1991 employment_narrow1991 employment_broad1991"
local conditionset "white_iso1991 white_frac1991 black_frac1991 colored_frac1991"

******************************************
**************MAIN RESULTS****************
******************************************
eststo clear

******************************************
****************TABLE 1*******************
*********INSTRUMENTAL VARIABLES***********
******************************************
eststo: xi: ivreg2 anc_vs2011 (white_iso2011 = log_mean_tri) `conditionset' i.municname , cl(municname)
eststo: xi: ivreg2 anc_vs2011 (white_iso2011 = nn_lra) `conditionset' i.municname, cl(municname)
eststo: xi: ivreg2 anc_vs2011 (white_iso2011 = log_mean_tri) `conditionset' `covariates' i.municname , cl(municname)
eststo: xi: ivreg2 anc_vs2011 (white_iso2011 = nn_lra) `conditionset' `covariates' i.municname , cl(municname)
esttab using "results\ivreg_maineffects.tex", b(3) se(3) r2 label title(Instrumental Variables Regression of White Isolation (2011) on ANC Vote Share (2014) \label{tab:results_ivreg}) addnote("Standard errors clustered by municipality in parentheses") keep(white_iso2011 white_iso1991 white_frac1991 black_frac1991 colored_frac1991) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear


******************************************
****************TABLE 2*******************
********DIFFERENCE-IN-DIFFERENCES*********
******************************************
eststo: xi: reg change_anc_vs change_white_frac change_black_frac change_col_frac change_white_iso ch_white_frac_change_white_iso i.cat_b, cl(cat_b)
eststo: xi: reg change_anc_vs change_white_frac change_black_frac change_col_frac change_white_iso ch_white_frac_change_white_iso change_log_income change_education change_employment_b i.cat_b, cl(cat_b)
eststo: xi: reg change_anc_vs change_white_frac change_black_frac change_col_frac change_white_iso_dummy_med ch_white_frac_white_iso_dum_med i.cat_b, cl(cat_b)
eststo: xi: reg change_anc_vs change_white_frac change_black_frac change_col_frac change_white_iso_dummy_med ch_white_frac_white_iso_dum_med change_log_income change_education change_employment_b i.cat_b, cl(cat_b)
esttab using "results\did_maineffects.tex", b(3) se(3) r2 label title(Difference-in-Differences Regression \label{tab:diff_in_diff}) addnote("Standard errors clustered by municipality in parentheses") keep(change_white_frac change_black_frac change_col_frac change_white_iso ch_white_frac_change_white_iso change_white_iso_dummy_med ch_white_frac_white_iso_dum_med) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************APPENDIX*******************
******************************************

******************************************
***************TABLE B.2******************
***********SUMMARY STATISTICS*************
******************************************
sutex white_iso1991 white_iso2011 black_frac1991 black_frac2011 colored_frac1991 colored_frac2011 white_frac1991 white_frac2011 log_income1991 log_income2011 education1991 education2011  employment_broad1991 employment_broad2011 employment_narrow1991 employment_narrow2011 anc_vs2011 anc_vs1996, minmax

******************************************
***************TABLE C.3******************
*********FIRST STAGE RELATIONSHIP*********
******************************************
eststo: areg white_iso2011  log_mean_tri `conditionset', absorb(municname) cl(municname)
eststo: areg white_iso2011  nn_lra `conditionset' , absorb(municname) cl(municname)
eststo: areg white_iso2011 log_mean_tri `conditionset'  `covariates', absorb(municname) cl(municname)
eststo: areg white_iso2011 nn_lra `conditionset'  `covariates', absorb(municname) cl(municname)
esttab using "results\ivreg_firststage.tex", b(4) se(4) r2 label title(First Stage Relationship \label{tab:results_ivreg_firststage}) addnote("Standard errors clustered by municipality in parentheses") keep(log_mean_tri nn_lra white_iso1991 white_frac1991 black_frac1991 colored_frac1991) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear

******************************************
***************TABLE D.4******************
****COVARIATE/INST CORRELATION MATRIX*****
******************************************
eststo: cor employment_narrow1991 employment_narrow2011 log_mean_tri
eststo: cor employment_broad1991 employment_broad2011 log_mean_tri
eststo: cor education1991 education2011 log_mean_tri 
eststo: cor income1991 income2011 log_mean_tri

eststo: cor employment_narrow1991 employment_narrow2011 nn_lra 
eststo: cor employment_broad1991 employment_broad2011 nn_lra
eststo: cor education1991 education2011 nn_lra 
eststo: cor income1991 income2011 nn_lra
esttab using "results\instrument_correlations.csv", se  b( %10.0g)  se( %10.0g) nostar nopar nogaps nolines nonum nonotes noobs replace 
eststo clear

******************************************
***************TABLE D.5******************
**********IGNORABILITY TESTS**************
******************************************
eststo: areg log_income1991 log_mean_tri `conditionset', absorb(cat_b) cl(municname)
eststo: areg log_income1991 nn_lra `conditionset', absorb(cat_b) cl(municname)
eststo: areg education1991 log_mean_tri `conditionset', absorb(cat_b) cl(municname)
eststo: areg education1991  nn_lra `conditionset', absorb(cat_b) cl(municname)
eststo: areg employment_narrow1991 log_mean_tri `conditionset', absorb(cat_b) cl(municname)
eststo: areg employment_narrow1991 nn_lra `conditionset', absorb(cat_b) cl(municname)
eststo: areg employment_broad1991 log_mean_tri `conditionset', absorb(cat_b) cl(municname)
eststo: areg employment_broad1991  nn_lra `conditionset', absorb(cat_b) cl(municname)
esttab using "results\ivreg_ignorability.tex", b(6) se(6) r2 label title(Test for Ignorability of Instruments \label{tab:ivreg_ignorability}) addnote("Standard errors clustered by municipality in parentheses") keep(log_mean_tri nn_lra white_iso1991 white_frac1991 black_frac1991 colored_frac1991) replace star(* 0.10 ** 0.05 *** 0.01)
eststo clear
