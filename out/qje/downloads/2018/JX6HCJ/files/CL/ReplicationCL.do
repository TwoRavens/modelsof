*Earlier tables - regs are only for one treatment regime (side by side), or report means and p-values but not coef. & se.

*Table 7 - Two rounding errors

use 20061107_data_survey_Chen_Li.dta, clear
*Correction of dates - see correspondence with Sherry Xin Li
*All double-checked and consistent with data_behavior file and data.dta (unified file provided by Li)
*If double-checking, remember to change treatment = "randomwithin" to "random within" in data_behavior
replace date = "a" if date == "050729LO"
replace date = "b" if date == "050722O6"
replace date = "c" if date == "050729NK"
replace date = "050729NK" if date == "a"
replace date = "050729LO" if date == "b"
replace date = "050722O6" if date == "c"

drop if treatment == "control"
*Note: dependent variable not coded for "control" - control not used in any regression

gen paintings = 1 if treatment == "original" | treatment == "nochat" | treatment == "nohelp"
replace paintings = 0 if treatment == "random within" | treatment == "random btw same" | treatment == "random btw other"

gen chat = 1 if treatment == "original" | treatment == "random within" | treatment == "random btw same" | treatment == "random btw other"
replace chat = 0 if treatment == "nochat" | treatment == "nohelp"    

gen oo = 1 if treatment == "original" | treatment == "nochat" | treatment == "random btw same" | treatment == "random btw other" | treatment == "random within"
replace oo = 0 if treatment == "nohelp"

gen within_subj = 1 if treatment == "original" | treatment == "random within" | treatment == "nochat" | treatment == "nohelp"    
replace within_subj = 0 if treatment == "random btw same" | treatment == "random btw other"

reg attach_to_gr paintings chat oo within_subj, cluster(date)
ologit attach_to_gr paintings chat oo within_subj, cluster(date)

save DatCL, replace
