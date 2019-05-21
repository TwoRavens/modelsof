set more off
set matsize 1000

use data\dyads_withrecoding_Top20zips_1500eachgender.dta
drop Xm_age* Xmf_* Zmf_*

*For each person (man) figure out how many people they messaged. This is used for the predictions below.
egen ctmansend=sum(msg_mansendwomanreply), by(m_usernum)

summ msg_mansendwomanreply
local meanofdv = `r(mean)'

*First run the apolitical model
reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X*
predict predictedmansend_nopols

*Now run the political model
reg msg_mansendwomanreply msg_woman_recdmsgrate msg_man_sendmsgrate msg_man_replyrate msg_woman_replyrate X* Z*_q41* Z*_q42* Z*_q43* Z*_q44* Z*_q45* Z*_q46* Z*_q47*
predict predictedmansend_withpols

gsort m_usernum -predictedmansend_withpols
gen pred_bin_withpols=0
bysort m_usernum: replace pred_bin_withpols=1 if _n<=ctmansend

gsort m_usernum -predictedmansend_nopols
gen pred_bin_nopols=0
bysort m_usernum: replace pred_bin_nopols=1 if _n<=ctmansend

* These match codes are equivalent to those used in the simple descriptive analysis from before in the paper
gen match_ideo= Z_q41_M1_F1 + Z_q41_M2_F2 + Z_q41_M3_F3
gen match_pid=Z_q43_M1_F1 + Z_q43_M2_F2 + Z_q43_M3_F3
gen match_media=Z_q46_M1_F1 + Z_q46_M2_F2 + Z_q46_M3_F3
gen match_churchstate=Z_q45_M1_F1+ Z_q45_M2_F2
gen match_taxspend=Z_q47_M1_F1+ Z_q47_M2_F2
gen match_impt=Z_q42_M1_F1 + Z_q42_M2_F2 + Z_q42_M3_F3 + Z_q42_M4_F4
gen match_dutyvote=Z_q44_M1_F1+ Z_q44_M2_F2

* For each political variable, generate a flag for whether or not that outcome is missing
local ctr=41
foreach var of varlist match_ideo match_impt match_pid match_dutyvote match_churchstate match_media match_taxspend {
 * Whether there is a 1 in any row for that dyad
 egen temp1=rowtotal(Z*`ctr'*)
 * Whether there is a 1 in any row for that dyad for outcomes that match missing data (9 outcome)
 egen temp2=rowtotal(Z*`ctr'*9*)
 replace temp1=temp1-temp2
 gen smp_`var'=(temp1==1)
 drop temp1 temp2
 local ctr= `ctr'+1
 }

* Zero out cases where there is no political variable provided by either member of dyad
foreach var of varlist match_ideo match_impt match_pid match_dutyvote match_churchstate match_media match_taxspend {
 replace `var'=. if smp_`var'~=1
 }

gen Outcome=""
gen Match_Random=.
gen Match_NoPols=.
gen Match_WithPols=.
local ctr=1
foreach var of varlist match_ideo match_pid match_media match_churchstate match_taxspend match_impt match_dutyvote  {
 replace Outcome="`var'" in `ctr'
 summ `var', sep(0)
 replace Match_Random=`r(mean)' in `ctr'
 summ `var' if pred_bin_nopols==1, sep(0)
 replace Match_NoPols=`r(mean)' in `ctr'
 summ `var' if pred_bin_withpols==1, sep(0)
 replace Match_WithPols=`r(mean)' in `ctr'
 local ctr=`ctr'+1
 }
 
gen givenavailablepoolraw=(Match_WithPols-Match_Random)/Match_Random
gen givenavailablepoolmodeladjusted=(Match_WithPols-Match_NoPols)/Match_NoPols

keep in 1/7
keep Outcome-givenavailablepoolmodeladjusted
gen outcomenum=_n

graph hbar (asis) givenavailablepoolraw  givenavailablepoolmodeladjusted, over(outcomenum, relabel(1 "Ideology" 2 "Partisanship" 3 "Media Preferences" 4 "Role of Church" 5 "How Balance Budget" 6 "Political Interest" 7 "Duty to Vote") label(labsize(vsmall))) bar(1, fcolor(black) lcolor(black)) ytitle(Increase in Predicted Matching) ytitle(, size(vsmall)) ylabel(0 "0%" .1 "10%"  .2 "20%" .3 "30%" .4 "40%", labsize(vsmall) grid glwidth(vthin) glcolor(black)) title("Figure S4: Model Predicted Political Sorting Relative to Baseline Sorting", size(small)) subtitle("Joint Communication", size(small)) legend(order(1 "Raw" 2 "Model Adjusted") size(vsmall) title(Relative to Available Pool, size(vsmall))) scheme(s1mono) name(SIFigureS8, replace) xsize(10) ysize(7.5)

graph export "figures\\FigureS4.eps", as(eps) preview(off) replace
graph export "figures\\FigureS4.pdf", as(pdf) replace



