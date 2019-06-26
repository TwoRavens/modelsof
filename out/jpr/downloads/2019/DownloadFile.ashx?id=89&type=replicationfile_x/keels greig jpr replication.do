set more off
use "C:\Dropbox\keels greig jpr replication data.dta", clear
label variable case "Case identifier"
label variable start_date "Conflict start date (century-month)"
label variable end_date "Conflict end date (century-month)"
label variable date "Current date (century-month)"
label variable year "Current year"
label variable lnGDP "GDP (logged)"
label variable total_dead0 "Battle deaths"
label variable terr_issue_any "Territorial issue"
label variable democracy "Democracy"
label variable elapsed_time "Elapsed time of conflict"
label variable multiple_med "Multiple mediation efforts"
label variable milper "Military personnel"
label variable reb_strength "Rebel strength"
label variable talks "Negotiation ongoing"
label variable rolling_talks "Number of previous negotiations (lagged 1 month)"
label variable any_dialogue "Mediation or negotiation ongoing in current month"
label variable any_settle "Mediation or negotiation achieve a full or partial settlement in current month"

**** Note: date variables calculated using century-month format
**** Century month=((year-1800)*12)+month-1
****



log using "C:\Dropbox\keels greig replication.smcl", replace


******** Estimates models reported in Table 2
***** Analysis for occurrence of mediation, outcome is mediated settlement
heckprob med_settle groups exclude democracy terr_issue_any multiple_med one_initiate civilwar_number, select(med_ongoing = rolling_medcount lnGDP democracy groups exclude reb_strength total_dead0 elapsed_time medmos med_spline1 med_spline2 med_spline3 milper democracies talks) cluster(case)

***** Analysis for occurrence of mediation or negotiation, outcome is mediated or negotiated settlement
heckprob any_settle groups exclude democracy terr_issue_any multiple_med one_initiate civilwar_number, select(any_dialogue = rolling_medcount rolling_talks lnGDP democracy groups exclude reb_strength total_dead0 elapsed_time dialoguemos any_spline1 any_spline2 any_spline3 milper democracies) cluster(case)


********** Predicted probabiliites
***** Generates predicted probabilities reported in text and Figures 1-4
heckprob med_settle groups exclude democracy terr_issue_any multiple_med one_initiate civilwar_number, select(med_ongoing = rolling_medcount lnGDP democracy groups exclude reb_strength total_dead0 elapsed_time medmos med_spline1 med_spline2 med_spline3 milper democracies talks) cluster(case)




*** Predicted probabibilities of mediation ongoing
*** at integers nearest means
margins, atmeans at(democracy=0 groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)

*** Excluded groups at integer nearest means (4.48), increasing number of ethnic groups
margins, atmeans at(democracy=0 groups=(0(2)42) exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)

**** Groups held at integer nearest mean, increasing number of excluded groups
margins, atmeans at(democracy=0 groups=8 exclude=(0(1)8) medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)


**** Increasing number of ethnic groups, 25% are excluded
margins, atmeans at(democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=4 exclude=1 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=8 exclude=2 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=12 exclude=3 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=16 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=20 exclude=5 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=24 exclude=6 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=28 exclude=7 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=32 exclude=8 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=36 exclude=9 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=40 exclude=10 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)

**** Increasing number of ethnic groups, 50% are excluded
margins, atmeans at(democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=4 exclude=2 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=12 exclude=6 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=16 exclude=8 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=20 exclude=10 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=24 exclude=12 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=28 exclude=14 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=32 exclude=16 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=36 exclude=18 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=40 exclude=20 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)

**** Increasing number of ethnic groups, 75% are excluded
margins, atmeans at(democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=4 exclude=3 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=8 exclude=6 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=12 exclude=9 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=16 exclude=12 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=20 exclude=15 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=24 exclude=18 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=28 exclude=21 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=32 exclude=24 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=36 exclude=27 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=40 exclude=30 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)

**** Increasing number of ethnic groups, 100% are excluded
margins, atmeans at(democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=4 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=8 exclude=8 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=12 exclude=12 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=16 exclude=16 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=20 exclude=20 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=24 exclude=24 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=28 exclude=28 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=32 exclude=32 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)
margins, atmeans at(democracy=0 groups=35 exclude=35 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(psel)


*************************************
*************************************
*************************************
*** Predicted probabilities of mediation agreement, conditional on mediation occurrence
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

*** Excluded groups at integer nearest means (4.48), increasing number of ethnic groups
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=(0(2)42) exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=(0(2)42) exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=(0(2)42) exclude=0 medmos=3 med_spline1=-26.25 med_spline2=-24.25 med_spline3=-20.125) pred(pcond)



**** Groups held at integer nearest mean, increasing number of excluded groups
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=8 exclude=(0(1)8) medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

**** Increasing number of ethnic groups, 25% are excluded
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=4 exclude=1 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=8 exclude=2 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=12 exclude=3 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=16 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=20 exclude=5 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=24 exclude=6 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=28 exclude=7 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=32 exclude=8 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=36 exclude=9 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=40 exclude=10 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

**** Increasing number of ethnic groups, 50% are excluded
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=4 exclude=2 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=12 exclude=6 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=16 exclude=8 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=20 exclude=10 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=24 exclude=12 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=28 exclude=14 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=32 exclude=16 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=36 exclude=18 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=40 exclude=20 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

**** Increasing number of ethnic groups, 100% are excluded
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=0 exclude=0 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=4 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=8 exclude=8 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=12 exclude=12 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=16 exclude=16 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=20 exclude=20 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=24 exclude=24 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=28 exclude=28 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=32 exclude=32 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=0 groups=35 exclude=35 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)



**** Disputant-initiated
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=(0(1)1) democracy=0 groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

**** Territory issue
margins, atmeans at(terr_issue_any=(0(1)1) multiple_med=0 one_initiate=0 democracy=0 groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

**** Democracy
margins, atmeans at(terr_issue_any=0 multiple_med=0 one_initiate=0 democracy=(0(1)1) groups=8 exclude=4 medmos=0 med_spline1=0 med_spline2=0 med_spline3=0) pred(pcond)

log close
translate "C:\Dropbox\keels greig replication.smcl" "C:\Dropbox\keels greig replication.ps", replace
