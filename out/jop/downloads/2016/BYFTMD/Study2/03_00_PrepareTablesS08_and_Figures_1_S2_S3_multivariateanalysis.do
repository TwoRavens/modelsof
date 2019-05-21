set more off
set matsize 1000

use data\dyads_withrecoding_Top20zips_1500eachgender.dta
drop Xm_age* Xmf_* Zmf_*

local dv="msg_mansendwomanreply"

* Prepare Files for Storing MFX Estimates used to create figures
file open myfile using "tables\SIFigures3and4_Data_forpaper_datingdyads_bothsend_nofe_lincom_zf`zipstring'_mf`manfilter'_wf`womanfilter'_mpf`manpolfilter'_wpf`womanpolfilter'_`datetimestring'_bivariatelincom.out", write replace
file write myfile "Model;MFX;Estimate;SE;P-value" _n
 
qui summ msg_mansendwomanreply
local meanofdv = `r(mean)'

di "Current DV is msg_mansendwomanreply with mean of `meanofdv'"

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", addnote("Mean of msg_mansendwomanreply is `meanofdv'.") ctitle("Base, No Politics") se bracket bdec(6) tdec(6) 3aster replace

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "No Pol Items"

*Age
local var1="X_age_10"
local var2="X_age_0"
qui include 03_01_sub_dolincom2vars.do

*height
local var1="X_ht_M1_F1"
local var2="X_ht_M1_F5"
qui include 03_01_sub_dolincom2vars.do

local var1="X_ht_M5_F5"
local var2="X_ht_M5_F1"
qui include 03_01_sub_dolincom2vars.do

*education
local var1="X_ed_Mcollege_Fcollege"
local var2="X_ed_Mcollege_Fhs"
qui include 03_01_sub_dolincom2vars.do

*race
local var1="X_race_Mwhite_Fwhite"
local var2="X_race_Mwhite_Fblack"
qui include 03_01_sub_dolincom2vars.do

local var1="X_race_Mblack_Fblack"
local var2="X_race_Mblack_Fwhite"
qui include 03_01_sub_dolincom2vars.do

*dating needs
local var1="X_lf_Mltdating_Fltdating"
local var2="X_lf_Mltdating_Fstdating"
qui include 03_01_sub_dolincom2vars.do

local var1="X_lf_Mstdating_Fstdating"
local var2="X_lf_Mstdating_Fltdating"
qui include 03_01_sub_dolincom2vars.do

*vices
local var1="X_am_Mdrinklots_Fdrinklots"
local var2="X_am_Mdrinklots_Fdrinknever"
qui include 03_01_sub_dolincom2vars.do

*religion
local var1="X_rel_Mathagn_Fathagn"
local var2="X_rel_Mathagn_Fchristian"
qui include 03_01_sub_dolincom2vars.do

local var1="X_rel_Mchristian_Fchristian"
local var2="X_rel_Mchristian_Fathagn"
qui include 03_01_sub_dolincom2vars.do

*kids
local var1="X_kids_Mwant_Fwant"
local var2="X_kids_Mwant_Fnotwant"
qui include 03_01_sub_dolincom2vars.do

local var1="X_kids_Mnotwant_Fnotwant"
local var2="X_kids_Mnotwant_Fwant"
qui include 03_01_sub_dolincom2vars.do

restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just Ideology") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*ideology
local var1="Z*_q41_M1_F1"
local var2="Z*_q41_M1_F3"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q41_M3_F3"
local var2="Z*_q41_M3_F1"
qui include 03_01_sub_dolincom2vars.do
restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q43*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just Partisanship") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*partisanship
local var1="Z*_q43_M1_F1"
local var2="Z*_q43_M1_F2"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q43_M2_F2"
local var2="Z*_q43_M2_F1"
qui include 03_01_sub_dolincom2vars.do
restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q46*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just News Preference") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*News preferences
local var1="Z*_q46_M1_F1"
local var2="Z*_q46_M1_F3"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q46_M3_F3"
local var2="Z*_q46_M3_F1"
qui include 03_01_sub_dolincom2vars.do
restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q45*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just Church-State Preference") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*Church state separate
capture summ Z*_q45_M1_F2
if _rc~=0 {
local var1=""
local var2="Z*_q45_M1_F1"
qui include 03_01_sub_dolincom1vars.do

local var1="-"
local var2="Z*_q45_M2_F1"
qui include 03_01_sub_dolincom1vars.do
}
else {
local var1="Z*_q45_M1_F1"
local var2="Z*_q45_M1_F2"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q45_M2_F2"
local var2="Z*_q45_M2_F1"
qui include 03_01_sub_dolincom2vars.do
}
restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q47*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just Fiscal Policy Preference") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*Cut taxes/spending
capture summ Z*_q47_M1_F2
if _rc~=0 {
local var1=""
local var2="Z*_q47_M1_F1"
qui include 03_01_sub_dolincom1vars.do

local var1="-"
local var2="Z*_q47_M2_F1"
qui include 03_01_sub_dolincom1vars.do
}
else {
local var1="Z*_q47_M1_F1"
local var2="Z*_q47_M1_F2"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q47_M2_F2"
local var2="Z*_q47_M2_F1"
qui include 03_01_sub_dolincom2vars.do
}
restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q42*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just Political Interest") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*interest
local var1="Z*_q42_M1_F1"
local var2="Z*_q42_M1_F4"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q42_M4_F4"
local var2="Z*_q42_M4_F1"
qui include 03_01_sub_dolincom2vars.do
restore

reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q44*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("Just Duty to Vote") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
local model = "Individual Pol Items"

*duty to vote
capture summ Z*_q44_M1_F2
if _rc~=0 {
local var1=""
local var2="Z*_q44_M1_F1"
qui include 03_01_sub_dolincom1vars.do

local var1="-"
local var2="Z*_q44_M2_F1"
qui include 03_01_sub_dolincom1vars.do
}
else {
local var1="Z*_q44_M1_F1"
local var2="Z*_q44_M1_F2"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q44_M2_F2"
local var2="Z*_q44_M2_F1"
qui include 03_01_sub_dolincom2vars.do
}
restore

di " All political items" 
reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* *_q47*, cluster(m_usernum)
outreg using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("All Political Items Simultaneously") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* *_q47*
local model = "All Pol Items"
qui include 03_01_sub_doalllincoms.do
restore

di " Kitchen sink, limited outreg to avoid breaking outreg"
reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*, cluster(m_usernum)
outreg  msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47* using "tables\TableS08_Study2_PredictingJointCommunication.out", se bracket bdec(6) tdec(6) 3aster ctitle("All Political Items and 40 Match Questions") append

preserve
keep msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*
local model = "All Questions"
qui include 03_01_sub_doalllincoms.do
restore

file close myfile 
