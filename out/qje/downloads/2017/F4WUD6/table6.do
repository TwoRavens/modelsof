clear
set more off  
set matsize 2000

**SR LCA
do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg econ_p1 replace

**Cumulative LCA
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg econ_p1 merge

*******Cumulative HES outcomes

foreach V in nonrice_food manuf_avail surplus_goods nofarm_sec p_own_vehic p_require_assist pop_g {
	do rd_reg `V' merge
}

outreg using table7, replay replace tex ctitles("", "Dependent variable is:"  \"","Economic", "", "Non-Rice", "Manuf.", "Surplus", "No Farm", "\% HH", "\% HH", "Ham" \ "", "Posterior Prob", "", "Food", "Goods", "Goods", "Security", "Own", "Require", "Pop" \ "", "$ t+1$", "Cum", "Avail", "Avail", "Prod", "Bad", "Vehic", "Assist", "Growth" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)") multicol(1, 2, 9; 2,2,2; 3, 2, 2) hlines(110001{0}1) plain fragment nocenter





