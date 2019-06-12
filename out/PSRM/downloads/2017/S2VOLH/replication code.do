**********************************************************************************************
*** Replication code for ms "The impact of party cues on manual coding of political texts" ***
*** Paper conditionally accepted at Political Science Research and Methods *******************
*** Laurenz Ennser-Jedenastik & Thomas M. Meyer **********************************************
*** University of Vienna, Department of Government *******************************************
*** July 2017 *******************************************************************************
**********************************************************************************************

********************************************************************************************
*** NOTE: The following analyses require installing the regoprob2 & the st0085_2 package ***
********************************************************************************************

*** log file
log using logfile, replace

ssc install regoprob2
* for more info, see: https://ideas.repec.org/c/boc/bocode/s457153.html

net sj 14-2 st0085_2
net install st0085_2
* for more info, see: http://repec.org/bocode/e/estout/esttab.html

*** load data
use "replication data.dta", clear

*** xtset
xtset sent_id

*** FIGURE 1
gen dv1 = dv
gen dv2 = dv
gen dv3 = dv
recode dv1 (0 = 1) (1/2 = 0)
recode dv2 (2 = 0)
recode dv3 (1 = 0) (2 = 1)
graph hbar dv1 dv2 dv3, over(cue) stack percentage blabel(bar, position(center) format(%9.1f)) legend(off)
graph export Fig1.png

*** TABLE 1: Regressions
* Run models
ologit dv ib3.cue i.coder i.sent_id, nolog
estimates store model1

xtologit dv ib3.cue i.coder, nolog 
estimates store model2

xtologit dv ib4.cue##i.agreement i.coder if cue != 3, nolog
estimates store model3

* View regression output:
esttab model1 model2 model3, s(N ll) se drop(*sent_id* *coder* 3.cue *4.cue#* *0.agreement*) ///
  order(5.cue 4.cue 3.cue 2.cue 1.cue 1.agreement 2.agreement 5.cue#* 2.cue#* 1.cue#*) label nogaps mtitles("I" "II" "III")

  
 
*** FIGURE 2: Marginal effects
qui xtologit dv ib3.cue i.coder, nolog 
* Left panel: Greens
margins, dydx(5.cue) asobserved predict(pu0 outcome(0)) predict(pu0 outcome(1)) predict(pu0 outcome(2)) 
marginsplot, horiz xdimension(_outcome) plotopts(connect(none)) title("Greens")
graph export Fig2_part1.png
* Right panel: FPÖ:
margins, dydx(1.cue) asobserved predict(pu0 outcome(0)) predict(pu0 outcome(1)) predict(pu0 outcome(2)) 
marginsplot, horiz xdimension(_outcome) plotopts(connect(none)) title("FPÖ")
graph export Fig2_part2.png

*** FIGURE 3: Marginal effects (interaction model)
qui xtologit dv ib4.cue##i.agreement i.coder if cue != 3, nolog
* Upper panel: Greens vs. SPÖ
margins, dydx(5.cue) asobserved  at(agreement=(0 1 2)) predict(pu0 outcome(0)) predict(pu0 outcome(1)) predict(pu0 outcome(2))
marginsplot, horiz xdimension(_outcome) plotopts(connect(none)) title("Greens vs. SPÖ") by(agreement)
graph export Fig3_part1.png
* Lower panel: FPÖ vs. SPÖ
margins, dydx(1.cue) asobserved  at(agreement=(0 1 2)) predict(pu0 outcome(0)) predict(pu0 outcome(1)) predict(pu0 outcome(2))
marginsplot, horiz xdimension(_outcome) plotopts(connect(none)) title("FPÖ vs. SPÖ") by(agreement)
graph export Fig3_part2.png

*** APPENDIX MODELS:

* simple probit models (A1 & A3):
qui xtoprobit dv ib3.cue i.coder, nolog 
estimates store modelprobitA1
xtoprobit dv ib4.cue##i.agreement i.coder if cue != 3, nolog
estimates store modelprobitA3

esttab modelprobitA1 modelprobitA3, s(N ll) se drop(*coder* 3.cue *4.cue#* *0.agreement*) ///
  order(5.cue 4.cue 2.cue 1.cue 1.agreement 2.agreement 5.cue#* 2.cue#* 1.cue#*) label nogaps mtitles("A1" "A3")


* generate dummies for party cues & coders & interactions (required by gologit2)
gen fpoe = cue == 1
gen oevp = cue == 2
gen spoe = cue == 4
gen greens = cue == 5

forval x = 2/10 {
gen c`x' = coder == `x'
}

gen ambig = agreement == 1
gen clearlypos = agreement == 2
gen grXambig = greens * ambig
gen fpXambig = fpoe * ambig
gen vpXambig = oevp * ambig
gen grXclpos = greens * clearlypos
gen fpXclpos = fpoe * clearlypos
gen vpXclpos = oevp * clearlypos

* ordered probit models with relaxation of parallel regression assumption for coders 5 & 8:
regoprob2 dv greens spoe oevp fpoe c2 c3 c4 c5 c6 c7 c8 c9 c10, i(sent_id) npl(c5 c8) nolog
estimates store modelprobitA2

regoprob2 dv greens oevp fpoe ambig clearlypos grXambig fpXambig vpXambig grXclpos fpXclpos vpXclpos ///
  c2 c3 c4 c5 c6 c7 c8 c9 c10 if cue != 3, i(sent_id) npl(c5 c8) nolog
estimates store modelprobitA4

* view models A2 & A4 (TABLE A1):
esttab modelprobitA2 modelprobitA4, s(N ll) se drop(c2 c3 c4 c5 c6 c7 c8 c9 c10) label nogaps mtitles("A2" "A4") ///
  order(greens spoe oevp fpoe ambig clearlypos grXambig grXclpos vpXambig vpXclpos fpXambig fpXclpos)

* end log
log close
