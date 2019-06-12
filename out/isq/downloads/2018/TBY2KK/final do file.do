log using may15_japan_final_log.smcl
clear
set more off
set seed 1234
set mem 500000
cd "C:\Documents and Settings\Benjamin\My Documents\Natsuko\Natsukof" 

*status quo equation

use use equation1_final.dta
estsimp mlogit dv in_demand any_reject cell3 lnmil_bal ally jp_othermid rv_othermid length cneg cthreat peaceyrs, robust genname(sq) sims(10000) b(2)

*diversionary incentives

*moving any_reject
setx  any_reject 0  in_demand 1 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi
setx  any_reject 1  in_demand 1 cell3 1 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(any_reject 0 1 in_demand 1 1 cell3 0 1)

*moving in_demand
setx  any_reject 1  in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi
setx  any_reject 1  in_demand 1 cell3 1 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(any_reject 1 1 in_demand 0 1 cell3 0 1)

*milbal
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal p10 ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal p90 ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal p20 ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal p80 ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal p25 ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal p75 ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(lnmil_bal p10 p90)
simqi, fd(pr) changex(lnmil_bal p20 p80)
simqi, fd(pr) changex(lnmil_bal p25 p75)

*ally
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 1 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(ally 0 1)

*jp_othermid 
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 1 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(jp_othermid 0 1)

*rv_othermid
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 1 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(rv_othermid 0 1)

*cneg
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 1 cthreat 0 peaceyrs mean
simqi

simqi, fd(pr) changex(cneg 0 1)

*cthreat
setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 0 peaceyrs mean
simqi

setx  any_reject 0 in_demand 0 cell3 0 lnmil_bal mean ally 0 jp_othermid 0 rv_othermid 0 length mean  cneg 0 cthreat 1 peaceyrs mean
simqi

simqi, fd(pr) changex(cthreat 0 1)

clear

*negotiations equation

use equation2_final.dta

*main eq
estsimp logit DV cell3 in_demand any_reject  ally lnmil_bal jp_initiate neg_issue rv_neg_bhv, robust genname(neg) sims(10000)

*move in_demand
setx cell3 0 in_demand 0 any_reject 1  ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 1 in_demand 1 any_reject 1  ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

simqi, fd(pr) changex(in_demand 0 1 any_reject 1 1 cell3 0 1)

*move any_reject

setx cell3 0 in_demand 1 any_reject 0  ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 1 in_demand 1 any_reject 1  ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

simqi, fd(pr) changex(in_demand 1 1 any_reject 0 1 cell3 0 1)

*milbal
setx cell3 0 in_demand 0 any_reject 0  ally 0 lnmil_bal p10  jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0  ally 0 lnmil_bal p90  jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0  ally 0 lnmil_bal p20 jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0  ally 0 lnmil_bal p80 jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0  ally 0 lnmil_bal p25 jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0  ally 0 lnmil_bal p75 jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

simqi, fd(pr) changex(lnmil_bal p10 p90)
simqi, fd(pr) changex(lnmil_bal p20 p80)
simqi, fd(pr) changex(lnmil_bal p25 p75)

*ally
setx cell3 0 in_demand 0 any_reject 0 ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0 ally 1 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

simqi, fd(pr) changex(ally 0 1)

*jp_initiate
setx cell3 0 in_demand 0 any_reject 0 ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 0 ally 0 lnmil_bal mean jp_initiate 1 neg_issue 0 rv_neg_bhv 0
simqi

simqi, fd(pr) changex(jp_initiate 0 1)

*neg_issue
setx cell3 0 in_demand 0 any_reject 10 ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 10 ally 0 lnmil_bal mean jp_initiate 0 neg_issue 1 rv_neg_bhv 0
simqi

simqi, fd(pr) changex(neg_issue 0 1)

*rv_neg_bhv
setx cell3 0 in_demand 0 any_reject 10 ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 0
simqi

setx cell3 0 in_demand 0 any_reject 10 ally 0 lnmil_bal mean jp_initiate 0 neg_issue 0 rv_neg_bhv 1
simqi

simqi, fd(pr) changex(rv_neg_bhv 0 1)
clear

*Escalation Equation

equation3_final.dta"

reg DV cell3 in_demand any_reject lnmil_bal ally jp_initiator rv_concede rv_troops_2 local_bal, robust

*any_reject conditional on in_demand

lincom any_reject + cell3*1

*in_demand condition on any_reject

lincom in_demand + cell3*1

clear

log close



