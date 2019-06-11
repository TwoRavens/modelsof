clear
set more off
set matsize 2000

***Immediate LCA admin
do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg admin_p1 replace

**Cumulative LCA admin
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg admin_p1 merge

**Admin cumulative outcomes
do rd_reg village_comm merge
do rd_reg gvn_taxes merge
do rd_reg chief_visit merge

***Immediate LCA educ
do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg educ_p1 merge

**Cumulative LCA educ
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg educ_p1 merge

**Educ cumulative outcomes 
do rd_reg prim_access merge
do rd_reg sec_school_vilg merge

***Immediate LCA health
do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg health_p1 merge

**Cumulative LCA health
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg health_p1 merge

**Cumulative pub works
do rd_reg pworks_under_constr merge


outreg using table5, replay replace tex ctitles("", "Dependent variable is:"  \"","Administration", "","Vilg", "Vilg", "Chief" ,"Education", "","Primary", "Sec", "Health", "","Pub"  \ "", "Posterior Prob", "", "Comm", "Gov", "Visits" , "Posterior Prob", "", "School", "School", "Posterior Prob", "", "Works"  \"", "$ t+1$", "Cum", "Filled", "Taxes", "Hamlet" , "$ t+1$", "Cum", "Access", "Access", "$ t+1$", "Cum", "Cons." \ "",   "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)", "(12)") multicol(1, 2, 12; 2,2,2; 2, 7, 2; 2, 11, 2; 3, 2, 2; 3, 7, 2; 3, 11, 2) hlines(110001{0}1) plain fragment nocenter




