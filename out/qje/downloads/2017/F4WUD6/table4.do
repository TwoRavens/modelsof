clear
set more off
set matsize 2000

**SR LCA
do firstclose .2 1 1
label var fr_strikes_mean "Bombing ($ t+1$)"

do rd_reg sec_p1 replace

**Cumulative LCA
do firstclose .2 1 12
label var fr_strikes_mean "Bombing (Cum)"

do rd_reg sec_p1 merge

*******Cumulative HES outcomes

*Enemy presence
do rd_reg en_pres merge
do rd_reg guer_squad merge
do rd_reg mainforce_squad merge
do rd_reg en_base merge

*Attacks
do rd_reg all_atk merge

*VC infrastructure
do rd_reg vc_infr_vilg merge
do rd_reg part_vc_cont merge

*Propoganda
do rd_reg en_prop merge

*Extortion
do rd_reg entax_vilg merge


outreg using table3, replay replace tex ctitles("", "Dependent variable is:"  \"", "Security", "","Armed",  "Vilg", "VC", "VC", "VC" ,"Reg VC", "\% HH", "VC", "VC"  \ "", "Posterior Prob", "", "VC", "Guer", "Main", "Base", "Attack" , "Infra", "Part", "Prop", "Extorts" \ "", "$ t+1$", "Cum", "Present",  "Squad", "Squad", "Nearby", "Hamlet",  "Activity", "VC Infr", "Drive", "Pop" \"",  "(1)", "(2)", "(3)", "(4)", "(5)", "(6)", "(7)", "(8)", "(9)", "(10)", "(11)") multicol(1, 2, 11; 2, 2, 2; 3, 2, 2) hlines(110001{0}1) plain fragment nocenter


