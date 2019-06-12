
use data/yop_analysis, clear

cap drop subcounty 
cap drop village 
cap drop name* 
cap drop attrition_cat 
cap drop sq1a-sq1cc 
cap drop enumerator 
cap drop supervisor 
cap drop editor 
cap drop keyer 
cap drop sq2 
cap drop sq14b* 
cap drop sq24b 
cap drop sq26 
cap drop sq34* 
cap drop sq6a* 
cap drop sq6b* 
cap drop sq25* 
cap drop sq61* 
cap drop sq295* 
cap drop sq296* 
cap drop sq297* 
cap drop sq299* 
cap drop sq300* 
cap drop sq301 
cap drop sq302 
cap drop enumerator_e 
cap drop incamp_e 
cap drop supervisor_e 
cap drop intown_e 
cap drop invillage_e 
cap drop inparish_e 
cap drop sq306*

save data/yop_analysis_deident, replace
