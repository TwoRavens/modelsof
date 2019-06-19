****************************************************************************************
* This file creates the variables used in the paper.
****************************************************************************************

cd "Directory_Path"


use NACUBO.dta, clear
merge 1:1 uni_numb using IPEDS_Main.dta

save Main_Data.dta

gen endow_per_fte_1000= size2003/(fte_student*1000)
gen actspending_to_nefi= actual_spend/nefi
