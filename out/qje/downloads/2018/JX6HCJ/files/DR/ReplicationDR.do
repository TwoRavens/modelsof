

*Getting treatment vector

use sampling_frame, clear
keep id wave occupation treatment
rename treatment treat
sort id
save aa, replace

use dataset_savingsAEJ, clear
sum wave*
*missing data
*eliminating duplicate observations 
drop if treatment == . & (id == 1013 | id == 1033)
*getting missing wave data (Pascaline Dupas's instructions)
sort id
merge id using aa
tab _m
tab id if _m == 1
list if id == 362
*from dropped wave (wave 0) due to no bank in area (correspondence with Pascaline Dupas) - no data and so doesn't appear in any regressions - a completely separate wave and strate
drop if _m == 1
tab treatment treat
egen Strata = group(wave occupation), label

***************************************************

*Reproducing results

gen active=(first6_num_trans_savings>1) if first6_num_trans_savings!=.
gen treatment_bg_boda=treatment*bg_boda  
gen active_bg_boda=active*bg_boda  
gen bg_boda_wave2=bg_boda & wave2
gen bg_malevendor_wave2=bg_malevendor  & wave2
gen bg_malevendor_wave3=bg_malevendor  & wave3
gen treatment_bg_malevendor=treatment*bg_malevendor  
gen active_bg_malevendor=active*bg_malevendor  
gen saved_towards_loan_total=1 if (total_dep_shares!=. & total_dep_shares!=0) | (total_dep_loan!=. & total_dep_loan!=0)
gen saved_towards_loan_first6=1 if (first6_dep_shares!=. & first6_dep_shares!=0) | (first6_dep_loan!=. & first6_dep_loan!=0)
gen got_loan_total=1 if total_wd_loan!=. & total_wd_loan!=0
gen got_loan_first6=1 if first6_wd_loan!=. & first6_wd_loan!=0
gen size_deposit=total_dep_savings/num_dep_savings
egen m_exp=mean(exp_total), by(id)
gen ratio_mw=size_deposit/exp_total  
replace ratio_mw=. if treatment==0
sum ratio, detail
local ratio_threshold=r(p50)

*intent to treat version of ivregs duplicates other regressions

global controls="wave2 wave3 bg_boda bg_malevendor bg_boda_wave2 bg_malevendor_wave2 bg_married bg_num_children bg_age bg_kis_read bg_rosca_contrib_lyr filled_log "


*Table 2 - All okay

foreach X in bank_savings animal_savings rosca_contrib {
	reg `X' treatment ${controls}, robust
	reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 3 - All okay

foreach X in total_hours investment investment_t5 revenues {
	reg `X' treatment ${controls}, robust
	reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 4 - All okay

foreach X in exp_total exp_food exp_tot_private {
	reg `X' treatment ${controls}, robust
	reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}


*Table 5 - All conditional on receiving treatment

*Table A3 - All okay

reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust

foreach X in exp_food exp_tot_private {
	reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

*Table A4

reg investment treatment ${controls} if (ratio<`ratio_threshold' | ratio==.), robust
reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<`ratio_threshold' | ratio==.), robust
reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<`ratio_threshold' | ratio==.), robust
reg exp_total treatment ${controls} if (ratio<`ratio_threshold' | ratio==.), robust
reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<`ratio_threshold' | ratio==.), robust

foreach X in exp_food exp_tot_private {
	reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<`ratio_threshold' | ratio==.), robust
	}

save DatDR, replace

capture erase aa.dta

