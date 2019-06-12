/* this do file replicates the findings of the elections model */
/* risk is coded as 1 is retirement and 2 is electoral loss */
/* other variables should be understood from the text */
use "C:*editpathwaytodata/JOPElect.dta", clear
mlogit risk closelec ideodist ideoagree district salary termlen workload incumbent intermappoint age sex minority logcount, robust cluster(jcode) base(0)
/* and with Odds Ratios */
mlogit risk closelec ideodist ideoagree district salary termlen workload incumbent intermappoint age sex minority logcount, robust cluster(jcode) base(0) rrr
