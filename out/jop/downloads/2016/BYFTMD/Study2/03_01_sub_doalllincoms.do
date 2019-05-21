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
 
*Our political items
*ideology
local var1="Z*_q41_M1_F1"
local var2="Z*_q41_M1_F3"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q41_M3_F3"
local var2="Z*_q41_M3_F1"
qui include 03_01_sub_dolincom2vars.do

*interest
local var1="Z*_q42_M1_F1"
local var2="Z*_q42_M1_F4"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q42_M4_F4"
local var2="Z*_q42_M4_F1"
qui include 03_01_sub_dolincom2vars.do

*partisanship
local var1="Z*_q43_M1_F1"
local var2="Z*_q43_M1_F2"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q43_M2_F2"
local var2="Z*_q43_M2_F1"
qui include 03_01_sub_dolincom2vars.do

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

*News preferences
local var1="Z*_q46_M1_F1"
local var2="Z*_q46_M1_F3"
qui include 03_01_sub_dolincom2vars.do

local var1="Z*_q46_M3_F3"
local var2="Z*_q46_M3_F1"
qui include 03_01_sub_dolincom2vars.do

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
