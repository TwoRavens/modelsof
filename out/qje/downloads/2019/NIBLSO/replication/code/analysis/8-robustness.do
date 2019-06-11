/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Robustness

INPUTS:
- aff_ds_1.dta
- aff_ds_2.dta
- rel_interest.dta
- prices_merged_wid.csv
- See .ado files for inputs indirectly used
  
OUTPUTS:
- Table A-3
- Table A-4
- Table A-9
- Figure A-1
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

global cptchars Survey_Pre_Eval_Time Survey_Pre_Positioning_Time ///
	Survey_Pre_Service_Scrub_Dress_W Survey_Median_Pre_Service_Time ///
	Survey_Median_Intra_Time Survey_Median_Post__ZZZ_XXX_000_ ///
	Survey_Day_of_Proc__090_010_ Survey_Length_of_Hosp_Stay Survey_Median_Post_Time ///
	Survey_Immediate_Post_Time Total_RUC_Survey_Time A99204 A99211 A99212 A99213 ///
	A99214 A99215 A99231 A99232 A99233 A99238 A99239 A99291 A99292 A99296 A99297

******************************************************************************************
*** Affiliation effect (Tables A-3 and A-4, Figure A-1) **********************************
******************************************************************************************	
	
*** Load data ****************************************************************************
gen_working_data, specwt collapse cptfreq keepvars(${cptchars}) spec_wt_opts(keepall)
gen_var, prervu 	
proc_pred_vars, jackknife cptterms pos_medbene sor drop ///
	keepvars(lnsurvey_respondents lnsurvey_sample_size ///
	lnsurvey_respondents_avg lnsurvey_sample_size_avg)
merge 1:1 obs_id using data/intermediate/aff_ds_1, assert(match master) ///
	keep(match) nogen

*** Table A-3 ****************************************************************************
foreach mom in mn 33 {
	foreach source of numlist 1/5 {
		estimates clear
		qui foreach num of numlist 1/5 {
			preserve
			rename naff_`source'_`num'_`mom' aff_sce`source_num'_`mom'
			eststo: reg lnruc_rec aff_sce`source_num'_`mom' lnprervu prervu_miss ///
				lnxb_pos_medbene lnxb_cptchars* *lnruc_rec_xb_sor_jk ///
				lnxb_cptterms i.ruc_yr i.mtg_num specialty_wt*, vce(cluster mtgid)
			sum lnruc_rec if e(sample)
			estadd scalar sample_mean=r(mean)
			restore
		}
		esttab, keep(aff_sce`source_num'_`mom') cells(b(fmt(3) star) se(fmt(3) par)) ///
			nolines starlevels(* .1 ** .05 *** .01) noobs compress nomtitles ///
			varwidth(13)
	}
}
/*
                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_mn        0.101***     0.103***     0.055**      0.061**      0.033** 
                (0.029)      (0.029)      (0.021)      (0.025)      (0.015)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_mn        0.076***     0.079***     0.048**      0.057**      0.028*  
                (0.026)      (0.026)      (0.020)      (0.025)      (0.015)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_mn        0.094***     0.094***     0.038*       0.037*       0.033** 
                (0.029)      (0.029)      (0.019)      (0.021)      (0.015)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_mn        0.088***     0.088***     0.056**      0.052**      0.036** 
                (0.029)      (0.030)      (0.022)      (0.025)      (0.016)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_mn        0.072***     0.069**      0.045**      0.032        0.036** 
                (0.027)      (0.027)      (0.021)      (0.020)      (0.015)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_33        0.104***     0.111***     0.061**      0.060**      0.026*  
                (0.032)      (0.031)      (0.024)      (0.026)      (0.014)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_33        0.076***     0.082***     0.060**      0.051**      0.027*  
                (0.024)      (0.026)      (0.024)      (0.024)      (0.013)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_33        0.089***     0.092***     0.039*       0.027        0.027*  
                (0.031)      (0.033)      (0.021)      (0.022)      (0.014)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_33        0.086**      0.092***     0.066***     0.054**      0.038** 
                (0.033)      (0.034)      (0.025)      (0.026)      (0.018)   

                    (1)          (2)          (3)          (4)          (5)   
                   b/se         b/se         b/se         b/se         b/se   
aff_sce_33        0.088***     0.085***     0.053**      0.043**      0.034** 
                (0.029)      (0.029)      (0.022)      (0.018)      (0.016)   
*/
	
*** Table A-4 ****************************************************************************
tempfile master
save `master'
gen_ruc_memspec
joinby ruc_yr mtg_num using `master', unmatched(both)
assert _merge==3|_merge==1
keep if _merge==3
drop _merge
gen_util_expend, type(medicare) year(ruc_yr) yearincs(-3/7) specexp ///
	specialty(member_specialty)
gen spec_sh_cpt=med_freq/med_cptfreq
gen cpt_sh_spec=med_freq/med_specfreq
gen cpt_sh_specexp=med_freq*ss_rec/med_specexp	
drop med_specfreq med_freq med_specexp
by obs_id member_id, sort: drop if _n>1
collapse_by_ruc_member, measures(spec_sh_cpt cpt_sh_spec cpt_sh_specexp) ///
	moments(mean median 33tile)
qui foreach var of varlist spec_sh_cpt_* cpt_sh_spec_* cpt_sh_specexp_* {
	sum `var'
	gen n`var'=(`var'-r(mean))/r(sd)
}
merge 1:1 obs_id using data/intermediate/rel_interest, ///
	assert(match using) keep(match) nogen
	
estimates clear
local regline lnprervu prervu_miss lnxb_pos_medbene lnxb_cptchars* ///
	lnxb_cptterms *lnruc_rec_xb_sor_jk i.ruc_yr i.mtg_num specialty_wt*
qui foreach num of numlist 1/5 {
	if `num'==1 eststo: reg lnruc_rec naff_1_1_mn ncpt_sh_spec_mn ///
		`regline', vce(cluster mtgid)
	if `num'==2 eststo: reg lnruc_rec naff_1_1_mn ncpt_sh_specexp_mn ///
		`regline', vce(cluster mtgid)
	if `num'==3 eststo: reg lnruc_rec naff_1_1_mn a_nfreq_int_mn ///
		m_nfreq_int_mn `regline', vce(cluster mtgid)
	if `num'==4 eststo: reg lnruc_rec naff_1_1_mn a_nrev_int_mn ///
		m_nrev_int_mn `regline', vce(cluster mtgid)
	if `num'==5 eststo: reg lnruc_rec naff_1_1_mn i.nprops ///
		`regline', vce(cluster mtgid)
	sum lnruc_rec if e(sample)
	estadd scalar sample_mean=r(mean)
}
esttab, keep(naff_1_1_mn ncpt_sh_spec_mn ncpt_sh_specexp_mn ///
	a_nfreq_int_mn a_nrev_int_mn) ///
	cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_a sample_mean, fmt(0 3 3)) starlevels(* .1 ** .05 *** .01)
/*
--------------------------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)             (5)   
                lnruc_rec       lnruc_rec       lnruc_rec       lnruc_rec       lnruc_rec   
                     b/se            b/se            b/se            b/se            b/se   
--------------------------------------------------------------------------------------------
naff_1_1_mn         0.098***        0.103***        0.104***        0.098***        0.112** 
                  (0.029)         (0.030)         (0.029)         (0.029)         (0.043)   
ncpt_sh~c_mn        0.021**                                                                 
                  (0.009)                                                                   
ncpt_sh~p_mn                        0.031***                                                
                                  (0.007)                                                   
a_nfreq_in~n                                        0.052**                                 
                                                  (0.021)                                   
a_nrev_int~n                                                        0.048***                
                                                                  (0.013)                   
--------------------------------------------------------------------------------------------
N                    4401            4254            4401            4401            4401   
r2_a                0.891           0.895           0.894           0.892           0.891   
sample_mean         1.567           1.567           1.567           1.567           1.567   
--------------------------------------------------------------------------------------------
*/

*** Figure A-1 ***************************************************************************
merge 1:1 obs_id using data/intermediate/aff_ds_2, assert(match master) ///
	keep(match) nogen
local affsources 6/11
local affvars 6(0.1)7
qui {
foreach affsource of numlist `affsources' {
		estimates clear
		foreach affvar of numlist `affvars' {
			local str_affsource `=subinstr("`affsource'",".","_",.)'
			local str_affvar `=subinstr("`affvar'",".","_",.)'
			capture d naff_`str_affsource'_`str_affvar'_mn
			if !_rc {
				preserve
				rename naff_`str_affsource'_`str_affvar'_mn aff_sce`str_affsource'_mn
				eststo: reg lnruc_rec aff_sce`str_affsource'_mn lnprervu prervu_miss ///
					lnxb_pos_medbene lnxb_cptchars* *lnruc_rec_xb_sor_jk ///
					lnxb_cptterms i.ruc_yr i.mtg_num specialty_wt*, vce(cluster mtgid)
				sum lnruc_rec if e(sample)
				estadd scalar sample_mean=r(mean)
				restore
				gen_aff, affvar(`affvar') affsource(`affsource') query
				local str_affvar`str_affvar' `=r(affvars)'
				local str_affsource`str_affsource' `=r(sourcefile)'
			}
		}
		noi esttab, keep(aff_sce`str_affsource'_mn) cells(b(fmt(7)) se(fmt(7))) ///
			nostar nolines noobs compress nomtitles varwidth(20)
}
}

/*
                           (1)       (2)       (3)       (4)       (5)       (6)       (7)       (8)       (9)      (10)      (11)
                          b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se
aff_sce42_mn         0.0221044 0.0271337 0.0323257 0.0375346 0.0426898 0.0474330 0.0515561 0.0555354 0.0599895 0.0636934 0.0644706
                     0.0351156 0.0352789 0.0349027 0.0338474 0.0319774 0.0294639 0.0270040 0.0255607 0.0255144 0.0265927 0.0277381

                           (1)       (2)       (3)       (4)       (5)       (6)       (7)       (8)       (9)      (10)      (11)
                          b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se
aff_sce43_mn         0.0644706 0.0673001 0.0705427 0.0743298 0.0786918 0.0834722 0.0883554 0.0930056 0.0970644 0.0997616 0.1006948
                     0.0277381 0.0281539 0.0285497 0.0289242 0.0292376 0.0294509 0.0295415 0.0294780 0.0292850 0.0290857 0.0290010

                           (1)       (2)       (3)       (4)       (5)       (6)       (7)       (8)       (9)      (10)      (11)
                          b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se
aff_sce44_mn         0.0169892 0.0179438 0.0201602 0.0253294 0.0357173 0.0516975 0.0650241 0.0678775 0.0678700 0.0679355 0.0673810
                     0.0248982 0.0246808 0.0242994 0.0236912 0.0228703 0.0220870 0.0219124 0.0233364 0.0247875 0.0252955 0.0253943

                           (1)       (2)       (3)       (4)       (5)       (6)       (7)       (8)       (9)      (10)      (11)
                          b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se
aff_sce45_mn         0.0673810 0.0703524 0.0736860 0.0772819 0.0810194 0.0847911 0.0884533 0.0916573 0.0938665 0.0948083 0.0951047
                     0.0253943 0.0259957 0.0265908 0.0271450 0.0276750 0.0281231 0.0284677 0.0286525 0.0287510 0.0288007 0.0288123

                           (1)       (2)       (3)       (4)       (5)       (6)       (7)       (8)       (9)      (10)      (11)
                          b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se
aff_sce46_mn         0.0197772 0.0231036 0.0264283 0.0319763 0.0388101 0.0479406 0.0593094 0.0699697 0.0792755 0.0860199 0.0911000
                     0.0169528 0.0172279 0.0176845 0.0183246 0.0190807 0.0198920 0.0201192 0.0204847 0.0215691 0.0236888 0.0261909

                           (1)       (2)       (3)       (4)       (5)       (6)       (7)       (8)       (9)      (10)      (11)
                          b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se      b/se
aff_sce47_mn         0.0911000 0.0916808 0.0923020 0.0928616 0.0933827 0.0940704 0.0946893 0.0945820 0.0903143 0.0712761 0.0321318
                     0.0261909 0.0262684 0.0263896 0.0265751 0.0268097 0.0270425 0.0271385 0.0266602 0.0244254 0.0187176 0.0152494
*/

// Above results saved in output/data_for_figure_A1.dta
use output/data_for_figure_A1.dta, clear
gen ucl=b+1.96*se
gen lcl=b-1.96*se
foreach aff in eucdq eucdr cos {
	foreach num of numlist 1/2 {
		if `num'==1 local cond gamma2==0
		else local cond gamma1==1
		twoway (line b gamma`num', lpattern(solid) lcolor(black)) ///
			(line ucl gamma`num', lpattern(dash) lcolor(black)) ///
			(line lcl gamma`num', lpattern(dash) lcolor(black)) ///
			if aff=="`aff'"&`cond', ///
			xtitle(Regularization parameter ({it:{&gamma}}{sub:`num'})) ///
			ytitle(Coefficient ({it:{&alpha}})) ///
			graphregion(color(white)) ylabel(, nogrid) name(`aff'_`num', replace) ///
			legend(off)
	 }
}
graph combine eucdq_1 eucdq_2, ysize(2.4) cols(2) iscale(*1.3) graphregion(color(white)) ///
	title("A: Quantity Euclidean Distance", color(black)) name(eucdq, replace) ycommon
graph combine eucdr_1 eucdr_2, ysize(2.4) cols(2) iscale(*1.3) graphregion(color(white)) ///
	title("B: Revenue Euclidean Distance", color(black)) name(eucdr, replace) ycommon
graph combine cos_1 cos_2, ysize(2.4) cols(2) iscale(*1.3) graphregion(color(white)) ///
	title("C: Cosine Similarity", color(black)) name(cos, replace) ycommon
graph combine eucdq eucdr cos, ysize(7.2) xsize(5.5) cols(1) iscale(*.9) ///
	graphregion(color(white)) name(Figure_A1, replace)
graph export output/Figure_A-1.eps, as(eps) replace

******************************************************************************************
*** Price following (Table A-9) **********************************************************
******************************************************************************************	
global sample (abs(log_medp - log_medp_tm1)>.3&(log_medp - log_medp_tm1)!=.)|aff!=.
global controls i.health_plan i.ruc_yr i.mtg_num i.year i.year_med 

*** Load data ****************************************************************************
// RUC meeting info on RUC member specialty volume, overall volume
gen_working_data, collapse cptfreq specwt spec_wt_opts(keepall)
tempfile master
save `master'
gen_ruc_memspec
joinby ruc_yr mtg_num using `master', unmatched(both)
assert _merge==3|_merge==1
keep if _merge==3
drop _merge
gen_util_expend, type(medicare) year(ruc_yr) yearincs(-3/7) specialty(member_specialty)
gen spec_sh_cpt=med_freq/med_cptfreq
gen cpt_sh_spec=med_freq/med_specfreq
gen lnspecfreq=ln(med_freq+1)
drop med_specfreq med_freq
collapse_by_ruc_member, measures(spec_sh_cpt cpt_sh_spec lnspecfreq) ///
	moments(mean median 33tile)
save `master', replace

import delimited using "data/intermediate/prices_merged_wid.csv", clear
merge m:1 obs_id using data/intermediate/aff_ds_1, keep(match master) nogen
rename aff_1_1_mn aff
isid year cpt_code health_plan
merge m:1 obs_id using `master', keep(match master) nogen

// Shorten price names
rename priv_p_norm_t privp
rename priv_p_norm_tm1 privp_tm1
rename med_t_use medp
rename med_tm1_use medp_tm1

// Select sample, generate variables
keep if sum_freq_use>10 & medp>0
foreach var of varlist medp medp_tm1 privp privp_tm1 {
	gen log_`var'=log(`var')
}

// Generate quantiles of aff and "information"
xtile infom1 = spec_sh_cpt_mn, nq(3)
xtile infom2 = cpt_sh_spec_mn, nq(3)
xtile infom3 = lnspecfreq_mn, nq(3)
gen med_freq=exp(lncptfreq)
xtile totalfreq = med_freq+priv_freq, nq(3)
xtile mktfreq = priv_freq, nq(3)
xtile affm = aff, nq(2)
gen byte hi_aff=affm==2
gen byte aff_pres=obs_id!=.
qui foreach var of varlist infom? ruc_yr mtg_num affm lncptfreq totalfreq mktfreq ///
	specialty_wt* {
	replace `var'= 0  if `var' == .
}

*** Predict price following **************************************************************
gen diff_log_medp = log_medp - log_medp_tm1
gen diff_log_privp = log_privp - log_privp_tm1
foreach var of varlist diff_log_medp diff_log_privp {
	sum `var' [aw=sum_freq_use] if aff!=.
	replace `var'=`var'-r(mean)
}
gen ratio=diff_log_privp/diff_log_medp
qui reg ratio i.totalfreq i.mktfreq i.health_plan i.ruc_yr ///
	i.mtg_num i.year i.year_med specialty_wt* [aw=sum_freq_use]
predict ratioxb, xb
xtile iratioxb = ratioxb, nq(3)
replace iratioxb=0 if iratioxb==.
	
*** Table A-9 ****************************************************************************
local regline1 i.affm#c.log_medp hi_aff aff_pres ${controls} if ${sample}
local regline2 i.affm#c.log_medp hi_aff i.infom1#c.log_medp i.infom1 aff_pres ///
	${controls} if ${sample}
local regline3 i.affm#c.log_medp hi_aff i.infom2#c.log_medp i.infom2 aff_pres ///
	${controls} if ${sample}
local regline4 i.affm#c.log_medp hi_aff i.mktfreq#c.log_medp i.mktfreq aff_pres ///
	${controls} if ${sample}
local regline5 i.affm#c.log_medp hi_aff i.totalfreq#c.log_medp i.totalfreq aff_pres ///
	${controls} if ${sample}
local regline6 i.affm#c.log_medp hi_aff i.iratioxb#c.log_medp i.iratioxb aff_pres ///
	${controls} if ${sample}
	
estimates clear
qui foreach num of numlist 1/6 {
	eststo: areg log_privp `regline`num'' [aw=sum_freq_use], ///
		absorb(cpt_code) 
}
local vars log_medp 0.affm#c.log_medp 1.affm#c.log_medp 2.affm#c.log_medp hi_aff
esttab, order(`vars') keep(`vars') cells(b(fmt(3) star) se(fmt(3) par)) varwidth(10) ///
	stats(N r2_a, fmt(0 3)) starlevels(* .1 ** .05 *** .01)
/*
----------------------------------------------------------------------------------------------------------
                    (1)             (2)             (3)             (4)             (5)             (6)   
              log_privp       log_privp       log_privp       log_privp       log_privp       log_privp   
                   b/se            b/se            b/se            b/se            b/se            b/se   
----------------------------------------------------------------------------------------------------------
log_medp                                                                                                  
                                                                                                          
0.affm#c~p        0.331***        0.291***        0.328***        0.338***        0.329***        0.326***
                (0.022)         (0.022)         (0.022)         (0.023)         (0.022)         (0.022)   
1.affm#c~p        0.520***        0.513***        0.530***        0.536***        0.524***        0.520***
                (0.023)         (0.027)         (0.023)         (0.024)         (0.023)         (0.023)   
2.affm#c~p        0.642***        0.733***        0.653***        0.657***        0.655***        0.629***
                (0.041)         (0.044)         (0.041)         (0.042)         (0.041)         (0.040)   
hi_aff           -0.016           0.168**        -0.017          -0.003           0.001          -0.048   
                (0.067)         (0.069)         (0.067)         (0.067)         (0.068)         (0.066)   
----------------------------------------------------------------------------------------------------------
N                  7182            7182            7182            7182            7182            7182   
r2_a              0.987           0.988           0.987           0.987           0.987           0.988   
----------------------------------------------------------------------------------------------------------
*/
