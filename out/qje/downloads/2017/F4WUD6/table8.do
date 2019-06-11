clear
set more off  
set matsize 2000

**SR LCA
do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg soccap_p1 replace

**Cumulative LCA
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg soccap_p1 merge

*******Cumulative HES outcomes

foreach V in civic_org_part phh_psdf econ_train self_dev_part selfdev_vilg youth_act vilg_council_meet {
	do rd_reg `V' merge
}

outreg using table6, replay replace tex ctitles("", "Dependent variable is:"  \ "", "Civic Society", "", "\% HH with a Member Active in", "", "", "", "Self Dev", "Youth", "Council" \"","Posterior Prob.", "", "Civic", "PSDF", "Econ", "Dev", "Proj", "Org", "Meets" \ "", "$ t+1$", "Cum", "Org", "Units", "Train", "Proj", "Underway", "Exists", "Regularly" \ "",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)") multicol(1, 2, 9; 2, 2, 2; 2, 4, 4; 3,2,2) hlines(110001{0}1) plain fragment nocenter 







