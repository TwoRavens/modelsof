*****************************************
*Name: Jonathan Rogers and Marcelo Tyszler                  *
*Date: May 2016                                       *
*Purpose: Information and Economic Voting Replication          *
*Data: First 16 Sessions all_sessions.dta *
*Machine: Work Desktop                    *
*Version 13                              *
******************************************

* Dependencies: you will need the following packages to run this file
* triplot.ado
* estout.ado
* latab.ado
*
*

clear
capture log close
log using Information_And_Economic_Voting.log, replace

************
* Figure 1 *
************

clear
set more off

** For Politicians:
use all_sessions_full, clear
keep if type>0

gen Incumbent = 1 if type==current_incumbent
replace Incumbent = 0 if type!=current_incumbent

label define Incumbent 1 "Incumbent"
label define Incumbent 0 "Candidate", add
label values Incumbent Incumbent

** Final allocations
gen final_1 =  endowment_1+ delta_welfare_1
gen final_2 =  endowment_2+ delta_welfare_2
gen final_3 =  endowment_3+ delta_welfare_3

gen s = final_1+final_2+final_3
gen f1 = final_1/s
gen f2 = final_2/s
gen f3 = final_3/s

triplot f1 f2 f3 if treatment==1 , ltext(Community 1) rtext(Community 2) btext(Community 3) separate(Incumbent) y label(nolabels) bltext(100% C3) brtext(100% C2) ttext(100% C1) text(mlabsize(large))
graph export "`graphs_dir'triplot_A_bw.eps", as(eps) preview(off) replace 
triplot f1 f2 f3 if treatment==2 , ltext(Community 1) rtext(Community 2) btext(Community 3) separate(Incumbent) y label(nolabels) bltext(100% C3) brtext(100% C2) ttext(100% C1) text(mlabsize(large))
graph export "`graphs_dir'triplot_B_bw.eps", as(eps) preview(off) replace
triplot f1 f2 f3 if treatment==3 , ltext(Community 1) rtext(Community 2) btext(Community 3) separate(Incumbent) y label(nolabels) bltext(100% C3) brtext(100% C2) ttext(100% C1) text(mlabsize(large))
graph export "`graphs_dir'triplot_C_bw.eps", as(eps) preview(off) replace
triplot f1 f2 f3 if treatment==4 , ltext(Community 1) rtext(Community 2) btext(Community 3) separate(Incumbent) y label(nolabels) bltext(100% C3) brtext(100% C2) ttext(100% C1) text(mlabsize(large))
graph export "`graphs_dir'triplot_D_bw.eps", as(eps) preview(off) replace

** Summary:
latabstat tax_rate final_1-final_3 if treatment==1, by (Incumbent) format(%9.2f) nototal
latabstat tax_rate final_1-final_3 if treatment==2, by (Incumbent) format(%9.2f) nototal
latabstat tax_rate final_1-final_3 if treatment==3, by (Incumbent) format(%9.2f) nototal
latabstat tax_rate final_1-final_3 if treatment==4, by (Incumbent) format(%9.2f) nototal
latabstat tax_rate final_1-final_3, by (Incumbent) format(%9.2f) nototal

***************
** Figure 2  **
***************

* The first three graphs are the panels individually.  The fourth is Figure 2, as presented in the manuscript

** For Voters:
use all_sessions_full, clear
keep if type==0

set scheme  s1manual 

twoway (lowess  total_info Period if treat==1, color(black)) (lowess  total_info Period if treat==2, color(gray)) (lowess  total_info Period if treat==3, color(black) lpattern(--)) (lowess  total_info Period if treat==4, color(gray) lpattern(--)),  legend(label(1 "Baseline") label(2 "Clustered") label(3 "Poor") label(4 "Heterogeneous"))  ytitle(Fraction of Total Information)
graph export "`graphs_dir'info_demand_per_period_total_bw.eps", as(eps) preview(off) replace

twoway (lowess  total_info Period if treat==1 & endowment==100, color(black)) (lowess  total_info Period if treat==2 & endowment==100, color(gray)) (lowess  total_info Period if treat==3 & endowment==100, color(black) lpattern(--)) (lowess  total_info Period if treat==4 & endowment==100, color(gray) lpattern(--)),  legend(label(1 "Baseline") label(2 "Clustered") label(3 "Poor") label(4 "Heterogeneous"))  ytitle(Fraction of Total Information)
graph export "`graphs_dir'info_demand_per_period_low_bw.eps", as(eps) preview(off) replace

twoway (lowess  total_info Period if treat==1 & endowment==500, color(black)) (lowess  total_info Period if treat==2 & endowment==500, color(gray)) (lowess  total_info Period if treat==3 & endowment==500, color(black) lpattern(--)) (lowess  total_info Period if treat==4 & endowment==500, color(gray) lpattern(--)),  legend(label(1 "Baseline") label(2 "Clustered") label(3 "Poor") label(4 "Heterogeneous"))  ytitle(Fraction of Total Information)
graph export "`graphs_dir'info_demand_per_period_high_bw.eps", as(eps) preview(off) replace

twoway (lowess  total_info Period if treat==1, color(black)) (lowess  total_info Period if treat==2, color(gray)) (lowess  total_info Period if treat==3, color(black) lpattern(--)) (lowess  total_info Period if treat==4, color(gray) lpattern(--)),  legend(label(1 "Baseline") label(2 "Clustered") label(3 "Poor") label(4 "Heterogeneous")) by(endowment, total note("")) ytitle(Percentage of Total Information)
graph export "`graphs_dir'info_demand_per_period_bw.eps", as(eps) preview(off) replace

**************
** Figure 3 **
**************

use all_sessions_full, clear
keep if type==0

gen conflict=1  if IncumbentAdvantage<0 &  dist_tax>0
replace conflict=2 if IncumbentAdvantage>0 &  dist_tax<0
replace conflict=3 if IncumbentAdvantage<0 &  dist_tax<0
replace conflict=4 if IncumbentAdvantage>0 &  dist_tax>0

label define conflict 1 "Negative Own vs. Positive National"
label define conflict 2 "Positive Own vs. Negative National", add
label define conflict 3 "Negative Own and Negative National", add
label define conflict 4 "Positive Own and Positive National", add
label values conflict conflict

gen election_app = -election

label define election_app -1 "Voting"
label define election_app 0 "Approval", add
label values election_app election_app

gen vote_approve = .
replace vote_approve = VoteIncumbent if election==1
replace vote_approve = approve if election == 0

graph bar (mean) vote_approve if conflict==1, over(info_nat) by(election_app, note("")) ytitle(Probability of Voting for the Incumbent)  yscale(range(0 1))
graph export "`graphs_dir'conflicts_Neg_Own_Pos_Nat_bw.eps", as(eps) preview(off) replace

graph bar (mean) vote_approve if conflict==2, over(info_nat) by(election_app, note("")) ytitle(Probability of Voting for the Incumbent)  yscale(range(0 1))
graph export "`graphs_dir'conflicts_Pos_Own_Neg_Nat_bw.eps", as(eps) preview(off) replace


***********
* Table 3 *
***********

use all_sessions_full, clear
keep if type == 0

summarize tax_rate_inc if treatment == 1
summarize tax_rate_cand if treatment == 1

summarize tax_rate_inc if treatment == 2
summarize tax_rate_cand if treatment == 2

summarize tax_rate_inc if treatment == 3
summarize tax_rate_cand if treatment == 3

summarize tax_rate_inc if treatment == 4
summarize tax_rate_cand if treatment == 4

summarize tax_rate_inc
summarize tax_rate_cand

***********
* Table 4 *
***********

*Baseline Total
summarize info_1_own if treatment == 1
gen avothers = (info_2_other_1 + info_3_other_2)/2
summarize avothers if treatment == 1
summarize info_4_nation if treatment == 1
summarize info_5_tax if treatment == 1

*Baseline Low Endowment
summarize info_1_own if treatment == 1 & endowment == 100
summarize avothers if treatment == 1 & endowment == 100
summarize info_4_nation if treatment == 1 & endowment == 100
summarize info_5_tax if treatment == 1 & endowment == 100

*Baseline High Endowment
summarize info_1_own if treatment == 1 & endowment == 500
summarize avothers if treatment == 1 & endowment == 500
summarize info_4_nation if treatment == 1 & endowment == 500
summarize info_5_tax if treatment == 1 & endowment == 500

*Clustered Total
summarize info_1_own if treatment == 2
summarize avothers if treatment == 2
summarize info_4_nation if treatment == 2
summarize info_5_tax if treatment == 2

*Clustered Low Endowment
summarize info_1_own if treatment == 2 & endowment == 100
summarize avothers if treatment == 2 & endowment == 100
summarize info_4_nation if treatment == 2 & endowment == 100
summarize info_5_tax if treatment == 2 & endowment == 100

*Clustered High Endowment
summarize info_1_own if treatment == 2 & endowment == 500
summarize avothers if treatment == 2 & endowment == 500
summarize info_4_nation if treatment == 2 & endowment == 500
summarize info_5_tax if treatment == 2 & endowment == 500


*Poor Total
summarize info_1_own if treatment == 3
summarize avothers if treatment == 3
summarize info_4_nation if treatment == 3
summarize info_5_tax if treatment == 3

*Poor Low Endowment
summarize info_1_own if treatment == 3 & endowment == 100
summarize avothers if treatment == 3 & endowment == 100
summarize info_4_nation if treatment == 3 & endowment == 100
summarize info_5_tax if treatment == 3 & endowment == 100

*Poor High Endowment
summarize info_1_own if treatment == 3 & endowment == 500
summarize avothers if treatment == 3 & endowment == 500
summarize info_4_nation if treatment == 3 & endowment == 500
summarize info_5_tax if treatment == 3 & endowment == 500


*Heterodox Total
summarize info_1_own if treatment == 4
summarize avothers if treatment == 4
summarize info_4_nation if treatment == 4
summarize info_5_tax if treatment == 4

*Heterodox Low Endowment
summarize info_1_own if treatment == 4 & endowment == 100
summarize avothers if treatment == 4 & endowment == 100
summarize info_4_nation if treatment == 4 & endowment == 100
summarize info_5_tax if treatment == 4 & endowment == 100

*Heterodox High Endowment
summarize info_1_own if treatment == 4 & endowment == 500
summarize avothers if treatment == 4 & endowment == 500
summarize info_4_nation if treatment == 4 & endowment == 500
summarize info_5_tax if treatment == 4 & endowment == 500


*Total Total
summarize info_1_own
summarize avothers
summarize info_4_nation
summarize info_5_tax

*Total Low Endowment
summarize info_1_own if endowment == 100
summarize avothers if endowment == 100
summarize info_4_nation if endowment == 100
summarize info_5_tax if endowment == 100

*Total High Endowment
summarize info_1_own if endowment == 500
summarize avothers if endowment == 500
summarize info_4_nation if endowment == 500
summarize info_5_tax if endowment == 500


******************
* Tables 5 and 6 *
******************

use all_sessions_full, clear

keep if type==0
xtset Id Period

gen self =  sign(delta_own_welfare_1-delta_own_welfare_2) if current_incumbent==1
replace self =  sign(delta_own_welfare_2-delta_own_welfare_1) if current_incumbent==2

gen self_x_own = self*info_1
gen self_x_others = self*info_others
gen self_x_national = self*info_nat

gen own_comm =  sign(avg_delta_welfare_own_communi71- avg_delta_welfare_own_communi72) if current_incumbent==1
replace own_comm =  sign(avg_delta_welfare_own_communi72- avg_delta_welfare_own_communi71) if current_incumbent==2

gen own_comm_x_own = own_comm*info_1

gen national =  sign(avg_delta_welfare_nation_1-avg_delta_welfare_nation_2) if current_incumbent==1
replace national =  sign(avg_delta_welfare_nation_2-avg_delta_welfare_nation_1) if current_incumbent==2

gen national_x_national = national*info_nat

gen fair = -sign(fair_inc-fair_cand)
gen fair_x_others = fair*info_others

xi: xtprobit VoteInc self  self_x_own self_x_others self_x_national  own_comm_x_own   fair_x_others national_x_national i.session if election==1
mfx, pred(pu0) at(zero)
est store vote

xi: xtprobit VoteInc self  self_x_own self_x_others self_x_national  own_comm_x_own   fair_x_others national_x_national i.session if election==1 & endowment==100
mfx, pred(pu0) at(zero)
est store vote_poor

xi: xtprobit VoteInc self  self_x_own self_x_others self_x_national  own_comm_x_own   fair_x_others national_x_national i.session if election==1 & endowment==500
mfx, pred(pu0) at(zero)
est store vote_rich

xi: xtprobit approve self  self_x_own self_x_others self_x_national  own_comm_x_own   fair_x_others national_x_national i.session if election==0
mfx, pred(pu0) at(zero)
est store approve

xi: xtprobit approve self  self_x_own self_x_others self_x_national  own_comm_x_own   fair_x_others national_x_national i.session if election==0 & endowment==100
mfx, pred(pu0) at(zero)
est store approve_poor

xi: xtprobit approve self  self_x_own self_x_others self_x_national  own_comm_x_own   fair_x_others national_x_national i.session if election==0 & endowment==500
mfx, pred(pu0) at(zero)
est store approve_rich

estout vote vote_poor vote_rich, cells(b(star fmt(3)) se(par fmt(3)))   starlevels(+ 0.10 * 0.05 ** 0.01)    legend label varlabels(_cons constant) margin stats(r2 N) style(tex)
estout approve approve_poor approve_rich, cells(b(star fmt(3)) se(par fmt(3)))   starlevels(+ 0.10 * 0.05 ** 0.01)    legend label varlabels(_cons constant) margin stats(r2 N) style(tex)

***********
* Table 7 *
***********

*gen positive_own=1 if IncumbentAdvantage>0
*replace positive_own=0 if IncumbentAdvantage<0

drop Incumb_Opt_Tax_Dist Cand_Opt_Tax_Dist

* Creating a variable for distance between incumbent tax rate and optimal tax *
* Optimal Tax is 20% *

generate Incumb_Opt_Tax_Dist = .
replace Incumb_Opt_Tax_Dist = abs(20-tax_rate_1) if current_incumbent == 1
replace Incumb_Opt_Tax_Dist = abs(20-tax_rate_2) if current_incumbent == 2

* Creating a variable for distance between candidate tax rate and optimal tax *
* Optimal Tax is 20% *

generate Cand_Opt_Tax_Dist = .
replace Cand_Opt_Tax_Dist = abs(20-tax_rate_2) if current_incumbent == 1
replace Cand_Opt_Tax_Dist = abs(20-tax_rate_1) if current_incumbent == 2

gen owncom = avg_delta_welfare_own_communi71 if current_incumbent == 1
replace owncom = avg_delta_welfare_own_communi72 if current_incumbent == 2

gen netgain = delta_own_welfare_1 if current_incumbent == 1
replace netgain = delta_own_welfare_2 if current_incumbent == 2

xtprobit VoteInc IncumbentAdvantage owncom Incumb_Opt_Tax_Dist Cand_Opt_Tax_Dist fair_inc fair_cand endowment if election == 1

xtprobit VoteInc IncumbentAdvantage owncom Incumb_Opt_Tax_Dist Cand_Opt_Tax_Dist fair_inc fair_cand endowment if election == 1 & netgain < 0


** Non-parametric Tests

use all_sessions_full, clear
keep if type == 0

collapse total_info, by(treatment session)

gen treat1 = 0
replace treat1 = 1 if treatment == 1

gen treat2 = 0
replace treat2 = 1 if treatment == 2

gen treat3 = 0
replace treat3 = 1 if treatment == 3

gen treat4 = 0
replace treat4 = 1 if treatment == 4


ranksum total_info, by(treat1)
ranksum total_info, by(treat2)
ranksum total_info, by(treat3)
ranksum total_info, by(treat4)

use all_sessions_full, clear
keep if type == 0

collapse total_info if endowment == 500, by(treatment session)

gen treat1 = 0
replace treat1 = 1 if treatment == 1

gen treat2 = 0
replace treat2 = 1 if treatment == 2

gen treat3 = 0
replace treat3 = 1 if treatment == 3

gen treat4 = 0
replace treat4 = 1 if treatment == 4

ranksum total_info, by(treat1)
ranksum total_info, by(treat2)
ranksum total_info, by(treat3)
ranksum total_info, by(treat4)

use all_sessions_full, clear
keep if type == 0

collapse total_info if endowment == 100, by(treatment session)

gen treat1 = 0
replace treat1 = 1 if treatment == 1

gen treat2 = 0
replace treat2 = 1 if treatment == 2

gen treat3 = 0
replace treat3 = 1 if treatment == 3

gen treat4 = 0
replace treat4 = 1 if treatment == 4

ranksum total_info, by(treat1)
ranksum total_info, by(treat2)
ranksum total_info, by(treat3)
ranksum total_info, by(treat4)

use all_sessions_full, clear
keep if type == 0


gen conflict=1  if IncumbentAdvantage<0 &  dist_tax>0
replace conflict=2 if IncumbentAdvantage>0 &  dist_tax<0
replace conflict=3 if IncumbentAdvantage<0 &  dist_tax<0
replace conflict=4 if IncumbentAdvantage>0 &  dist_tax>0

label define conflict 1 "Negative Own vs. Positive National"
label define conflict 2 "Positive Own vs. Negative National", add
label define conflict 3 "Negative Own and Negative National", add
label define conflict 4 "Positive Own and Positive National", add
label values conflict conflict

collapse VoteInc approve if conflict!=., by(election  session conflict info_nat)

gen Vote_Incumbent_No_info = VoteIncumbent if election==1 & info==0
gen Vote_Incumbent_info = VoteIncumbent[_n+1] if election==1 & info==0

gen Approve_Incumbent_No_info = approve if election==0 & info==0
gen Approve_Incumbent_info = approve[_n+1] if election==0 & info==0

signrank  Vote_Incumbent_info=Vote_Incumbent_No_info if conflict==1
signrank  Vote_Incumbent_info=Vote_Incumbent_No_info if conflict==2

signrank  Approve_Incumbent_No_info= Approve_Incumbent_info if conflict==1
signrank  Approve_Incumbent_No_info= Approve_Incumbent_info if conflict==2


log close	
