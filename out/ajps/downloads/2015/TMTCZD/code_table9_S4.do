**The following commands replicate Table 9 in online Appendix S4
*Set appropriate working directory, then run
use data_S4, clear
xi: regress union_member lab mmp lab_mmp, vce(robust)
display e(r2_a)
xi: regress union_member lab mmp lab_mmp i.district_code, vce(robust)
display e(r2_a)
xi: clogit union_member lab mmp lab_mmp, group(district_code)
