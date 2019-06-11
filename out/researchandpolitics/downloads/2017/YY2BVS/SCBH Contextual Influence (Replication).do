*Title: SCBH Contextual Influence
*Author: Jack Reilly
*Date: 4.28.17
*Purpose: Examine contextual influence across social connectedness
*Requires: 1992 CNES Data File, "SCBH Data Management.do", "spost13" package, "sol" graphics scheme
*Output: Results, graphics
*Stata 13.1 SE on macOS 10.12

cd "~/your/working/directory"
use "connectedness_working.dta", clear

set scheme sol

*VOTE INFLUENCE
ologit vote c.outdegree##c.countyvote pid3 educ income minority hispanic female
margins, dydx(countyvote) at(outdegree=(0(1)5)) predict(xb)
marginsplot, title(Vote Choice) ylabel(0(1)4) ytitle(Effect of County Vote on Individual Vote) xtitle(Social Connectedness) l(95) scheme(s1manual)

*Nicer graph using mgen
mgen, dydx(countyvote) at(outdegree=(0(1)5) countyvote=-.061 income=3.35 educ=2 pid3=0 minority=0 hispanic=0 female=1) stub(VOTE_) level(95) predict(xb)
twoway (rarea VOTE_ll VOTE_ul VOTE_outdegree, fcolor(gs14) lcolor(gs14)) (line VOTE_d_xb VOTE_outdegree, lcolor(minority)), ytitle("Effect of County on Individual Vote" , size(medlarge)) yline(0, lwidth(medium) lpattern(dot)) ylabel(-1(1)4, labsize(medlarge) angle(horizontal)) xtitle("Social Connectedness", size(medlarge)) xlabel(0(1)5, labsize(medlarge)) subtitle("95% Confidence Intervals") legend(off) scheme(s1manual)
graph export "mfxvote_ctrl.pdf", replace

*Conditional upon county lean
margins, dydx(outdegree) at(countyvote=(-.4(.2).6)) predict(xb)
marginsplot, title(Vote Choice) ylabel(-1(.25)1) ytitle(Effect of Social Connectendess on Individual Vote by County Lean) xtitle(County Lean) l(90) scheme(s1manual)

mgen, dydx(outdegree) at(countyvote=(-.4(.2).6) outdegree=3 income=3.35 educ=2 pid3=0 minority=0 hispanic=0 female=1) stub(VOTEc_) level(95) predict(xb)
twoway (rarea VOTEc_ll VOTEc_ul VOTEc_countyvote, fcolor(gs14) lcolor(gs14)) (line VOTEc_d_xb VOTEc_countyvote, lcolor(minority)), ytitle("Effect of Connectedness on Individual Vote" , size(medlarge)) yline(0, lwidth(medium) lpattern(dot)) ylabel(-1(1)4, labsize(medlarge) angle(horizontal)) xtitle("County Lean", size(medlarge)) xlabel(-.4(.2).6, labsize(medlarge)) subtitle("95% Confidence Intervals") legend(off) scheme(s1manual)
graph export "mfxvote_ctrl_countylean.pdf", replace


*marginal effects
*AVERAGE
mgen, at(outdegree=3 income=3.35 educ=2 countyvote=.061 pid3=0 minority=0 hispanic=0 female=1) stub(clinton) level(95) predict(outcome(1))
mgen, at(outdegree=3 income=3.35 educ=2 countyvote=.061 pid3=0 minority=0 hispanic=0 female=1) stub(perot) level(95) predict(outcome(0))
mgen, at(outdegree=3 income=3.35 educ=2 countyvote=.061 pid3=0 minority=0 hispanic=0 female=1) stub(bush) level(95) predict(outcome(-1))

*CONNECTED IN DEM
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(clinton_connindem) level(95) predict(outcome(1))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(perot_connindem) level(95) predict(outcome(0))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(bush_connindem) level(95) predict(outcome(-1))

*CONNECTED IN REP
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(clinton_conninrep) level(95) predict(outcome(1))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(perot_conninrep) level(95) predict(outcome(0))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(bush_conninrep) level(95) predict(outcome(-1))

*ISO IN DEM
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(clinton_isoindem) level(95) predict(outcome(1))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(perot_isoindem) level(95) predict(outcome(0))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(bush_isoindem) level(95) predict(outcome(-1))

*ISO IN REP
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(clinton_isoinrep) level(95) predict(outcome(1))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(perot_isoinrep) level(95) predict(outcome(0))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(bush_isoinrep) level(95) predict(outcome(-1))

******************************
***ALTERNATE SPECIFICATIONS***
******************************

*ALTERNATE DV: TWO-PARTY VOTE
recode vote -1=0 0=. 1=1, gen(twopartyvote)

logit twopartyvote c.outdegree##c.countyvote pid3 educ income minority hispanic female
margins, dydx(countyvote) at(outdegree=(0(1)5)) predict(xb)
marginsplot, title(Vote Choice) ylabel(0(1)4) ytitle(Effect of County Vote on Individual Vote) xtitle(Social Connectedness) l(95) scheme(s1manual)

*with recalculated party lean
bys cnty: egen countyvote2=mean(twopartyvote)
logit twopartyvote c.outdegree##c.countyvote2 pid3 educ income minority hispanic female
margins, dydx(countyvote2) at(outdegree=(0(1)5)) predict(xb)
marginsplot, title(Vote Choice) ylabel(0(1)4) ytitle(Effect of County Vote on Individual Vote) xtitle(Social Connectedness) l(95) scheme(s1manual)

*ALTERNATE COUNTY LEAN: SUBTRACT EGO
ologit vote c.outdegree##c.countyvote_subego pid3 educ income minority hispanic female 
margins, dydx(countyvote_subego) at(outdegree=(0(1)5)) predict(xb)
marginsplot, title(Vote Choice) ylabel(0(1)4) ytitle(Effect of County Vote on Individual Vote) xtitle(Social Connectedness) l(95) scheme(s1manual)

*Nicer graph using mgen
mgen, dydx(countyvote_subego) at(outdegree=(0(1)5) income=3.35 educ=2 pid3=0 minority=0 hispanic=0 female=1) stub(VOTE_subego_) level(95) predict(xb)
twoway (rarea VOTE_subego_ll VOTE_subego_ul VOTE_subego_outdegree, fcolor(gs14) lcolor(gs14)) (line VOTE_subego_d_xb VOTE_subego_outdegree, lcolor(minority)), ytitle("Effect of County on Individual Vote" , size(medlarge)) yline(0, lwidth(medium) lpattern(dot)) ylabel(0(1)3, labsize(medlarge) angle(horizontal)) xtitle("Social Connectedness", size(medlarge)) xlabel(0(1)5, labsize(medlarge)) subtitle("95% Confidence Intervals") legend(off) scheme(s1manual)
graph export "mfxvote_ctrl_subego.pdf", replace

*marginal effects
*AVERAGE
mgen, at(outdegree=3 income=3.35 educ=2 countyvote=.061 pid3=0 minority=0 hispanic=0 female=1) stub(clint_se) level(95) predict(outcome(1))
mgen, at(outdegree=3 income=3.35 educ=2 countyvote=.061 pid3=0 minority=0 hispanic=0 female=1) stub(perot_se) level(95) predict(outcome(0))
mgen, at(outdegree=3 income=3.35 educ=2 countyvote=.061 pid3=0 minority=0 hispanic=0 female=1) stub(bush_se) level(95) predict(outcome(-1))

*CONNECTED IN DEM
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(clint_se_cid) level(95) predict(outcome(1))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(perot_se_cid) level(95) predict(outcome(0))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(bush_se_cid) level(95) predict(outcome(-1))

*CONNECTED IN REP
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(clint_se_cir) level(95) predict(outcome(1))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(perot_se_cir) level(95) predict(outcome(0))
mgen, at(outdegree=5 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(bush_se_cir) level(95) predict(outcome(-1))

*ISO IN DEM
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(clint_se_iid) level(95) predict(outcome(1))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(perot_se_iid) level(95) predict(outcome(0))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=.591 pid3=0 minority=0 hispanic=0 female=1) stub(bush_se_iid) level(95) predict(outcome(-1))

*ISO IN REP
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(clint_se_iir) level(95) predict(outcome(1))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(perot_se_iir) level(95) predict(outcome(0))
mgen, at(outdegree=0 income=3.35 educ=2 countyvote=-.391 pid3=0 minority=0 hispanic=0 female=1) stub(bush_se_iir) level(95) predict(outcome(-1))

*ALTERNATE COUNTY LEAN: USE PID AT THE COUNTY LEVEL
ologit vote c.outdegree##c.countypid3 pid3 educ income minority hispanic female
margins, dydx(countypid3) at(outdegree=(0(1)5)) predict(xb)
marginsplot, l(95)

*USING CLUSTERED STANDARD ERRORS
*VOTE INFLUENCE
ologit vote c.outdegree##c.countyvote pid3 educ income minority hispanic female, cluster(cnty)
margins, dydx(countyvote) at(outdegree=(0(1)5)) predict(xb)
marginsplot, title(Vote Choice) ylabel(0(1)4) ytitle(Effect of County Vote on Individual Vote) xtitle(Social Connectedness) l(90) scheme(s1manual)
