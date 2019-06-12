clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/

insheet using Raw/ref_tables/REF_CPT.txt, delim("|") names

encode cpt_desc, generate(cpt)
drop cpt_desc
label var cpt "Procedure"
compress
desc

duplicates report proc_code
collapse (first) cpt, by(proc_code)
label value cpt cpt

save build/proc_info.dta, replace





