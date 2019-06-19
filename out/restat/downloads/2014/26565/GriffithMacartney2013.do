set more off

cd C:\Dropbox\ReplicationData\GriffithMacartney_REStat2013

***********
* Table 2 *
***********
* columns (1) and (2)
use "mne_epl_full.dta", clear
table country, c(sum no_of_firms sum patent_cnt ) row
* columns (3) and (4)
use "mne_epl_main.dta", clear
table country, c(sum no_of_firms sum patent_cnt) row

***********
* Table 3 *
***********
use "aggregate_EPL.dta", clear
keep if (iso2_code=="GB")|(iso2_code=="FR")|(iso2_code=="FI")|(iso2_code=="NL")|(iso2_code=="IT")|(iso2_code=="BE")|(iso2_code=="CZ")|(iso2_code=="DE")|(iso2_code=="DK")|(iso2_code=="ES")|(iso2_code=="NO")|(iso2_code=="PL")|(iso2_code=="SE")|(iso2_code=="GR")|(iso2_code=="PT")
keep if patent_cnt~=.&priv
gen nace2_stan_prop_npl_pc=100*nace2_stan_prop_npl
collapse (mean) nace2_stan_prop_npl_pc,by(industry)
replace industry=proper(industry)
gen temp=-nace2
so temp
format nace2 %5.0f
l industry nace2

***********
* Table 4 *
***********
use "aggregate_EPL.dta", clear
* Country dummies
gen gb=(iso2_code=="GB")
gen fr=(iso2_code=="FR")
gen fi=(iso2_code=="FI")
gen nl=(iso2_code=="NL")
gen it=(iso2_code=="IT")
gen be=(iso2_code=="BE")
gen cz=(iso2_code=="CZ")
gen de=(iso2_code=="DE")
gen dk=(iso2_code=="DK")
gen es=(iso2_code=="ES")
gen no=(iso2_code=="NO")
gen pl=(iso2_code=="PL")
gen se=(iso2_code=="SE")
gen gr=(iso2_code=="GR")
gen pt=(iso2_code=="PT")
reg patent_cnt patent_cnt if priv &(de|gb|fr|it|be|es|fi|se|nl|no|dk|pt)
gen samp_priv=e(sample)
global Samp "samp_priv"
collapse (sum) patent_cnt, by(iso2_code nace3 samp_priv  isonace3_cit_rece isonace3_cit isonace3_prop_npl isonace3_noinvs isonace3_inventor_diff_cty isonace3_rel_sd_emp isonace3_prop_npl nace3_prop_npl nace3_noinvs nace3_inventor_diff_cty nace3_rel_sd_emp nace3_prop_npl isonace3_rel_sd_sales)
pwcorr isonace3_prop_npl isonace3_noinvs isonace3_rel_sd_emp isonace3_rel_sd_sales if $Samp, sig


***********
* Table 5 *
***********
use "mne_epl_main.dta", clear
tab mne, g(ff)
tab nace3, g(ii)
** Col 2
glm patent_cnt epl_r  ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r  using "TABLE5", replace bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 3 
glm patent_cnt epl_r pop15_65 lsh_h lskill_times_educspend_n Phskill_n  ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r pop15_65 lsh_h lskill_times_educspend_n Phskill_n  using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 4 
glm patent_cnt epl_r pop15_65 liso_cap_abund_at1997 lcap_abun_intensity_at1997 us_cap_intensity lsh_h lskill_times_educspend_n Phskill_n ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r pop15_65 liso_cap_abund_at1997 lcap_abun_intensity_at1997 us_cap_intensity lsh_h lskill_times_educspend_n Phskill_n using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)
use "mne_epl_main_mls.dta", clear
tab mne, g(ff)
tab nace3, g(ii)
** Col 5 
glm patent_cnt epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini be de dk es fi fr gb it nl no pt se ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 6 
glm patent_cnt epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n be de dk es fi fr gb it nl no pt se ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 7 
glm patent_cnt epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n lcap_abun_intensity_at1997 us_cap_intensity be de dk es fi fr gb it nl no pt se ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n lcap_abun_intensity_at1997 us_cap_intensity using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 8 
glm patent_cnt epl_r_mls_hi9603_ini be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit") label(insert)
** Col 9 
glm patent_cnt epl_r_mls_hi9603_ini be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit_received], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit_received") label(insert)
use "mne_epl_main_size.dta", clear
tab mne, g(ff)
tab nace3, g(ii)
** Col 10 
glm patent_cnt epl_r_iso2_big iso2_big  ff* be de dk es fi fr gb it nl no pt se [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_iso2_big iso2_big  using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 11
glm patent_cnt epl_r_iso2_big be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_iso2_big using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit") label(insert)
** Col 12
glm patent_cnt epl_r_iso2_big be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit_received], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r_iso2_big using "TABLE5", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit_received") label(insert)

***********
* Table 6 *
***********
use "mne_epl_main.dta", clear
tab mne, g(ff)
tab nace3, g(ii)
** Col 1 
glm bvd_prop_npl epl_r  ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r  using "TABLE6_w", replace bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 2 
glm bvd_prop_npl epl_r pop15_65 lsh_h lskill_times_educspend_n Phskill_n  ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r pop15_65 lsh_h lskill_times_educspend_n Phskill_n  using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 3 
glm bvd_prop_npl epl_r pop15_65 liso_cap_abund_at1997 lcap_abun_intensity_at1997 us_cap_intensity lsh_h lskill_times_educspend_n Phskill_n ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r pop15_65 liso_cap_abund_at1997 lcap_abun_intensity_at1997 us_cap_intensity lsh_h lskill_times_educspend_n Phskill_n using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)
use "mne_epl_main_mls.dta", clear
tab mne, g(ff)
tab nace3, g(ii)
** Col 4 
glm bvd_prop_npl epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini be de dk es fi fr gb it nl no pt se ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 5 
glm bvd_prop_npl epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n be de dk es fi fr gb it nl no pt se ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 6 
glm bvd_prop_npl epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n lcap_abun_intensity_at1997 us_cap_intensity be de dk es fi fr gb it nl no pt se ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini mass_layoff_rate_9603_hi_ini lskill_times_educspend_n Phskill_n lcap_abun_intensity_at1997 us_cap_intensity using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 7 
glm bvd_prop_npl epl_r_mls_hi9603_ini be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit") label(insert)
** Col 8 
glm bvd_prop_npl epl_r_mls_hi9603_ini be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit_received], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_mls_hi9603_ini using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit_received") label(insert)
use "mne_epl_main_size.dta", clear
tab mne, g(ff)
tab nace3, g(ii)
** Col 9 
glm bvd_prop_npl epl_r_iso2_big iso2_big  ff* be de dk es fi fr gb it nl no pt se [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_iso2_big iso2_big  using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", No, "Weight", "bvd_cit") label(insert)
** Col 10 
glm bvd_prop_npl epl_r_iso2_big be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_iso2_big using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit") label(insert)
** Col 11 
glm bvd_prop_npl epl_r_iso2_big be de dk es fi fr gb it nl no pt se ii* ff* [aw=bvd_cit_received], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r_iso2_big using "TABLE6_w", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", Yes, "Industry effect", Yes, "Weight", "bvd_cit_received") label(insert)

***********
* Table 7 *
***********
use "mne_epl_main.dta", clear
cap drop epl_r_sd 
gen gr_pat_dum=(granted_patent_cnt!=0)
gen gr_npl_dum=(bvd_gr_npl!=0)
so buo_bvd1
by buo_bvd1: egen epl_r_sd=sd(epl_r) if gr_pat_dum &bvd_gr_cit!=0 &bvd_gr_cit!=.
by buo_bvd1: egen mne_gr_tot_pat_dums=sum(gr_pat_dum) if epl_r_sd!=0 &epl_r_sd!=.
by buo_bvd1: egen mne_gr_tot_npl_dums=sum(gr_npl_dum) if mne_gr_tot_pat_dums!=0 &mne_gr_tot_pat_dums!=.
by buo_bvd1: egen no_of_subsids_gran=sum(no_of_firms) if mne_gr_tot_npl_dums!=0 &mne_gr_tot_npl_dums!=.
gen samp_gran=(no_of_subsids_gran>1&no_of_subsids_gran!=.)
global Samp "samp_gran"
cap drop ff*
tab buo_bvd1 if $Samp, g(ff)
*** Pats
glm granted_patent_cnt epl_r  ff* if $Samp [aw=bvd_cit], fam(poisson) vce(cluster iso2_code)
outreg2          epl_r  using "TABLE7", replace bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)

*** NPL
gen bvd_prop_gr_npl=bvd_gr_npl/bvd_gr_cit
glm bvd_prop_gr_npl epl_r  ff* if $Samp [aw=bvd_cit], fam(binomial) link(logit) vce(cluster iso2_code)
outreg2          epl_r  using "TABLE7", append bdec(4) se nonotes bracket excel addt("Firm effect", Yes, "Country effect", No, "Industry effect", No, "Weight", "bvd_cit") label(insert)



