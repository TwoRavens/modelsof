clear
set more off  
set matsize 2000

do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg fr_forces_mean replace
do rd_reg fw_opday_dummy merge
do rd_reg fw_init merge
do rd_reg fw_d merge
do rd_reg fr_d merge
do rd_reg en_d merge

**Cumulative
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg fr_forces_mean merge
do rd_reg fw_opday_dummy merge
do rd_reg fw_init merge
do rd_reg fw_d merge
do rd_reg fr_d merge
do rd_reg en_d merge

outreg using table4, replay replace tex ctitles("", "Dependent variable is:"  \ "", "Immediate", "", "", "", "", "", "Cumulative", "", "", "" \"","Friendly","US", "US",  "US", "SVN", "VC","Friendly", "US", "US", "US", "SVN", "VC" \ "", "Forces", "Ops", "Attacks", "Troop Deaths", "", "", "Forces", "Ops", "Attacks", "Troop Deaths", "", "" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)", "(12)") multicol(1, 2, 12; 2, 2, 6; 2, 8, 6; 4,5,3; 4, 11, 3) hlines(110001{0}1) plain fragment nocenter
