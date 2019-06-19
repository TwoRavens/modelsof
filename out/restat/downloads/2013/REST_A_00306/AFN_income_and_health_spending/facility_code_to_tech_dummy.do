
**
* run as ...
*  "do facility_code_to_tech_dummy temp_var init|update"
**

local techs_1_to_20 = ///
 "post_op cardiac_intensive icu open_heart pharmacy_ft pharmacy_pt xray_ther megavolt radio_implants radioiso_diag radioiso_ther histopath_lab organ_bank blood_bank eeg inhale_therapy premature self_care skilled_ltcu hemodialysis_in"

local techs_21_to_35 = ///
 "hemodialysis_out burn_care physical_therapy occ_therapy rehab_in rehab_out psych_in psych_out psych_partial psych_er psych_foster psych_consult_educ psych_clinical organized_out_center er_dept"

local techs_36_to_53 = ///
 "social_work family_planning genetric_counseling abortion_in abortion_out home_care dental podiatrist_service speech_therapy auxiliary volunteer patient_rep alcohol_in alcohol_out tbresp neonatal ped_in ct"

if ("`1'" == "init") {

 foreach tech of local techs_1_to_20 {
  gen `tech' = 0
 }
 foreach tech of local techs_21_to_35 {
  gen `tech' = 0
 }
 foreach tech of local techs_36_to_53 {
  gen `tech' = 0
 }
 
}

local i = 1
if ("`1'" == "update") {
 
 foreach tech of local techs_1_to_20 {
  di "updating [`tech'] at `i' ..."
  replace `tech' = 1 if `2' == `i'
  local i = `i' + 1
 }
 assert (`i' == 21)
 foreach tech of local techs_21_to_35 {
  di "updating [`tech'] at `i' ..."
  replace `tech' = 1 if `2' == `i'
  local i = `i' + 1
 }
 assert (`i' == 36)
 foreach tech of local techs_36_to_53 {
  di "updating [`tech'] at `i' ..."
  replace `tech' = 1 if `2' == `i'
  local i = `i' + 1
 }
}


