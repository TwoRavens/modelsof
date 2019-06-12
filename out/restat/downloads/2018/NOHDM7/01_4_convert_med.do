clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/


clear
disp "year: `1'"

insheet using Raw/med_clm/MED_CLM_`1'.TXT, delim("|") names
rm Raw/med_clm/MED_CLM_`1'.TXT
compress
gsave Raw/med_clm/MED_CLM_`1'.dta, replace

