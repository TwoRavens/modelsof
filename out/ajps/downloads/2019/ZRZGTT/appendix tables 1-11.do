


*Appendix Table 1
use "Master data.dta"

logit opp_viol agecat male educat ideology7 polint activist if approve!=. & india==1 & gov_statement==0

outreg2 using table1, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label replace
logit gov_viol agecat male educat ideology7 polint activist if approve!=. & india==1 & gov_statement==0

outreg2 using table1, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label append
logit treaty agecat male educat ideology7 polint activist if approve!=. & india==1

outreg2 using table1, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label append
clear

*Appendix Table 2
use "Master data.dta"

logit opp_viol agecat male educat ideology7 polint activist if approve!=. & israel==1 & gov_statement==0

outreg2 using table2, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label replace
logit gov_viol agecat male educat ideology7 polint activist if approve!=. & israel==1 & gov_statement==0

outreg2 using table2, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label append
logit treaty agecat male educat ideology7 polint activist if approve!=. & israel==1

outreg2 using table2, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label append
clear

*Appendix Table 3
use "Master data.dta"

logit opp_viol agecat male educat activist if approve!=. & argentina==1 & gov_statement==0

outreg2 using table3, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label replace
logit gov_viol agecat male educat activist if approve!=. & argentina==1 & gov_statement==0

outreg2 using table3, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label append
logit treaty agecat male educat activist if approve!=. & argentina==1

outreg2 using table3, word ctitle(1) addstat(Pseudo R-squared, `e(r2_p)') label append
clear

*Appendix Tables 4-6
use "Master data.dta"

cor approve security competence reputation morality threat if india==1
cor approve security competence reputation morality threat if israel==1
cor approve security competence reputation if argentina==1

*Appendix Table 7

use "Master data.dta"

eststo clear
reg approve opp_viol gov_viol treaty agecat male educat ideology7 polint activist if india==1

eststo model1
reg approve opp_viol gov_viol treaty agecat male educat ideology7 polint activist if israel==1

eststo model2
reg approve opp_viol gov_viol treaty agecat male educat activist if argentina==1

eststo model3
esttab using table7.tex, r2 se(3) eqlabels(none) b(3) label replace
clear

*Appendix Table 8
use "Master data.dta"

eststo clear
reg approve opp_viol gov_viol treaty  if india==1

eststo model1
reg approve opp_viol gov_viol treaty  if israel==1

eststo model2
reg approve opp_viol gov_viol treaty  if argentina==1

eststo model3
esttab using table8.tex, r2 se(3) eqlabels(none) b(3) label replace
clear

*Appendix Table 9
use "Master data.dta"

eststo clear
oprobit approve opp_viol gov_viol treaty agecat male educat ideology7 polint activist  if india==1

eststo model1
oprobit approve opp_viol gov_viol treaty agecat male educat ideology7 polint activist if israel==1

eststo model2
oprobit approve opp_viol gov_viol treaty agecat male educat activist if argentina==1

eststo model3
esttab using table9.tex, pr2 se(3) eqlabels(none) b(3) label replace
clear

*Appendix Table 10

use "Master data.dta"

gen x=male*opp_viol
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

reg approve opp_viol x gov_viol treaty agecat male educat activist if argentina==1

drop x

gen x=agecat*opp_viol
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

reg approve opp_viol x gov_viol treaty agecat male educat activist if argentina==1

drop x

gen x=educat*opp_viol
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

reg approve opp_viol x gov_viol treaty agecat male educat activist if argentina==1

drop x

gen x=ideology7*opp_viol
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=polint*opp_viol
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=activist*opp_viol
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

reg approve opp_viol x gov_viol treaty agecat male educat activist if argentina==1

clear
*Appendix Table 11

use "Master data.dta"

gen x=male*treaty
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=agecat*treaty
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=educat*treaty
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=ideology7*treaty
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=polint*treaty
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x

gen x=activist*treaty
reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if india==1

reg approve opp_viol x gov_viol treaty agecat male educat ideology7 polint activist if israel==1

drop x
clear
