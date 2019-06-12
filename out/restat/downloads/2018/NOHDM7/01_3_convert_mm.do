clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/

clear
disp "year: `1'"

insheet using Raw/members/MEMBERMONTH_`1'.TXT, delim("|") names
rm Raw/members/MEMBERMONTH_`1'.TXT
compress
gsave Raw/members/MEMBERMONTH_`1'.dta, replace

