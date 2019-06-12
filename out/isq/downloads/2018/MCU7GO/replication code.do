' Merge Bueno de Mesquita et. al. datasets from http://www.nyu.edu/gsas/dept/politics/data/bdm2s2/Logic.htm.  
set mem 100m
use "C:\Users\Owner\Documents\selectorate paper folder\leader_data\bdm2s2_leader_year_data.dta", clear
sort ccode year
save "C:\Users\Owner\Documents\selectorate paper folder\leader_data\bdm2s2_leader_year_data.dta", replace
merge ccode year using "C:\Users\Owner\Documents\selectorate paper folder\leader_data\bdm2s2_leader_year_data.dta", uniqusing
save "C:\Users\Owner\Documents\selectorate paper folder\leader_data\bdm2s2_leader_year_data.dta", replace

' Merge for additional democracy datasets.
merge ccode year using "C:\Users\Owner\Documents\Regime Data\ACLP Data\ACLP Data2.dta", uniqusing
merge ccode year using "C:\Users\Owner\Documents\Regime Data\Boix democracy data\democracy-1800-1999.dta", uniqusing
merge ccode year using "C:\Users\Owner\Documents\Regime Data\Gasiorowski and Reich democracy measure\PRC.dta", uniqusing
merge ccode year using "C:\Users\Owner\Documents\Regime Data\Jackman and Trier Latent Variable\rk_sampes_4merge.dta", uniqusing
merge ccode year using "C:\Users\Owner\Documents\Regime Data\polyarchy dataset\file42535_polyarchy_v2.dta", uniqusing


' stset procedure
stset endtime, id(leader_id) fail(leadgone==1) origin(time intime)  scale(365.25)

' Reproduce original Bueno de Mesquita (1999) measures of W and S
gen Worig = W * 4
gen Sorig = S * 2

' Generate time interaction variable - ln(t+1)
gen _t01 = _t0 + 1
gen ln_t01 = ln(_t01)

Online Appendix A: Replication

' Replication of Bueno de Mesquita (1999) results.
stcox Worig Sorig, scaledsch(sca*) schoenfeld(sch*)

' Harrel's Rho test for disproportionality.
estat phtest, detail

' Generate time interactions of Worig and Sorig.
gen Worig_x = Worig * ln_t01
gen Sorig_x = Sorig * ln_t01

' Correction of Bueno de Mesquita (1999) results for disproportionality.
stcox Worig Worig_x Sorig Sorig_x

Main Body of Paper:

' Cox model with residualized Polity measure of democracy.
stcox Worig Sorig WSdemres, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with residualized Polity measure of democracy.
stcox Worig Worig_x Sorig Sorig_x WSdemres WSdemres_x

' Cox model with non-residualized Polity measure of democracy.
stcox Worig Sorig Polity2, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with non-residualized Polity measure of democracy.
stcox Worig Worig_x Sorig Sorig_x polity2 polity2_x

' Cox model with dummy variable for competitive election.
stcox Worig Sorig election, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with dummy variable for competitive election.
stcox Worig Worig_x Sorig Sorig_x election election_x

' Cox model with Freedom House scores.
stcox Worig Sorig PR CL, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with Freedom House scores.
stcox Worig Worig_x Sorig Sorig_x PR PR_x CL CL_x

' Cox model with ACLP scores.
stcox Worig Sorig ACLPreg, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with ACLP scores.
stcox Worig Worig_x Sorig Sorig_x ACLPreg ACLPreg_x

' Cox model stratified by election.
stcox Worig Sorig, strata(election) scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model stratified by election.
stcox Worig Sorig Sorig_x, strata(election)

' Cox model in non-electoral context.
stcox Worig Sorig if election == 0, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model in non-electoral context.
stcox Worig Sorig Sorig_x if election == 0

' Cox model in electoral context.
stcox Worig Sorig if election == 1, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model in electoral context.
stcox Worig Sorig Sorig_x if election == 1

' Generate military regime variable
gen military_regime = 1 if RegimeType > 1 & RegimeType < 4 & RegimeType < .
mvencode military_regime if RegimeType < ., mv(0)

' Cox model with military variable.
stcox Worig Sorig military_regime, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with military variable
stcox Worig Worig_x Sorig Sorig_x military_regime military_regime_x

' Cox model for non-military regimes.
stcox Worig Sorig if military_regime == 0, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model for non-military regimes.
stcox Worig Worig_x Sorig Sorig_x if military_regime == 0

' Cox model for military regimes.
stcox Worig Sorig if military_regime == 1, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model for military regimes.
stcox Worig Worig_x Sorig Sorig_x if military_regime == 1

' Cox model for years before 1945.
stcox Worig Sorig if year < 1945, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model for years before 1945
stcox Worig Worig_x Sorig Sorig_x if year < 1945

' Cox model for years after 1945.
stcox Worig Sorig if year >= 1945, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model for years after 1945
stcox Worig Worig_x Sorig Sorig_x if year >= 1945

' Code for Figure 1
line winning_coalitions selectorate_size _t0, xtitle(Time in Office) xlabel(0(10)60) ytitle(Percent Change in Hazard) scheme(s2mono) sort

' Code for Figure 2
line electoral_regime _t0, xtitle(Time in Office) xlabel(0(10)60) ytitle(Percent Change in Hazard) scheme(s2mono) sort

' Code for Figure 3
histogram Worig if election == 0, discrete percent addlabels normal ytitle(Percent in Category for Non-Electoral Regimes) xtitle(Winning Coalition Size) xlabel(0(1)4) scheme(s2mono)
sfrancia Worig if election == 0

' Code for Figure 4
twoway (line winning_coalitions _t0, sort) (line winning_coalition_no_election _t0, sort) (line winning_coalition_election _t0, sort), ytitle(Percent Change in Hazard) xtitle(Time in Office) xlabel(0(10)60) legend(rows(3)) scheme(s2mono)

' Code for Figure 5
twoway (line selectorate_size _t0, sort) (line selectorate_w_military _t0, sort) (line selectorate_nonmilitary _t0, sort), ytitle(Percent Change in Hazard) xtitle(Time in Office) xlabel(0(10)60) legend(rows(3)) scheme(s2mono)

' Code for Figure 6
line Pre_1945 Post_1945 _t0, xtitle(Time in Office) xlabel(0(10)60) ytitle(Percent Change in Hazard) scheme(s2mono) legend(on) sort


Online Appendix A:
' Code for Figure A.I.1
histogram Worig, discrete percent addlabels normal ytitle(Percent in Category for Non-Electoral Regimes) xtitle(Winning Coalition Size) xlabel(0(1)4) scheme(s2mono)
sfrancia Worig


Online Appendix B:
' Replication using WoverS (as coded by Bueno de Mesquita et. al. authors).
stcox WoverS, scaledsch(sca*) schoenfeld(sch*)

' Cox model with residualized Polity measure of democracy.
stcox WoverS WSdemres, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with residualized Polity measure of democracy.
stcox WoverS WSdemres WSdemres_x

' Cox model with non-residualized Polity measure of democracy.
stcox WoverS Polity2, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with non-residualized Polity measure of democracy.
stcox WoverS WoverS_x polity2 polity2_x

' Cox model with dummy variable for competitive election.
stcox WoverS election, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with dummy variable for competitive election.
stcox WoverS election election_x

' Cox model with Freedom House scores.
stcox WoverS PR CL, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with Freedom House scores.
stcox WoverS PR CL CL_x

' Cox model with ACLP scores.
stcox WoverS ACLPreg, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with ACLP scores.
stcox WoverS ACLPreg ACLPreg_x

' Cox model stratified by election.
stcox WoverS, strata(election) scaledsch(sca*) schoenfeld(sch*)

' Cox model in non-electoral context.
stcox WoverS if election == 0, scaledsch(sca*) schoenfeld(sch*)

' Cox model in electoral context.
stcox WoverS if election == 1, scaledsch(sca*) schoenfeld(sch*)

' Cox model with military variable.
stcox WoverS military_regime, scaledsch(sca*) schoenfeld(sch*)

' Corrected cox model with military variable
stcox WoverS WoverS_x military_regime military_regime_x

' Cox model for non-military regimes.
stcox WoverS if military_regime == 0, scaledsch(sca*) schoenfeld(sch*)

' Cox model for military regimes.
stcox WoverS if military_regime == 1, scaledsch(sca*) schoenfeld(sch*)

' Cox model for years before 1945.
stcox WoverS if year < 1945, scaledsch(sca*) schoenfeld(sch*)

' Cox model for years after 1945.
stcox WoverS if year >= 1945, scaledsch(sca*) schoenfeld(sch*)

Appendix C:

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W, dist(weibull) ancillary(W)

' Replication of second weibull model (with S) from Bueno de Mesquita et. al. (2003)
streg W S, dist(weibull) ancillary(W)

' Replication of exponential model from Bueno de Mesquita et. al. (2003)
streg W Wln_t01 ln_t01, dist(exponential) nohr nolog

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W WSdemres, dist(weibull) ancillary(W WSdemres)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W polity2, dist(weibull) ancillary(W polity2)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W election, dist(weibull) ancillary(W election)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W PR CL, dist(weibull) ancillary(W PR CL)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W ACLPreg, dist(weibull) ancillary(W ACLPreg)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W S WSdemres, dist(weibull) ancillary(W WSdemres)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W S polity2, dist(weibull) ancillary(W polity2)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W S election, dist(weibull) ancillary(W election)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W S PR CL, dist(weibull) ancillary(W PR CL)

' Replication of weibull model from Bueno de Mesquita et. al. (2003)
streg W S ACLPreg, dist(weibull) ancillary(W ACLPreg)

' Replication of exponential model from Bueno de Mesquita et. al. (2003)
streg W Wln_t01 ln_t01 WSdemres, dist(exponential) nohr nolog

' Replication of exponential model from Bueno de Mesquita et. al. (2003)
streg W Wln_t01 ln_t01 polity2, dist(exponential) nohr nolog

' Replication of exponential model from Bueno de Mesquita et. al. (2003)
streg W Wln_t01 ln_t01 election, dist(exponential) nohr nolog

' Replication of exponential model from Bueno de Mesquita et. al. (2003)
streg W Wln_t01 ln_t01 PR CL, dist(exponential) nohr nolog

' Replication of exponential model from Bueno de Mesquita et. al. (2003)
streg W Wln_t01 ln_t01 ACLPreg, dist(exponential) nohr nolog

' Exponential model in non-electoral context
streg W Wln_t01 ln_t01 if election == 0, dist(exponential) nohr nolog

' Exponential model in electoral context
streg W Wln_t01 ln_t01 if election == 1, dist(exponential) nohr nolog


Appendix D:

' Cox model stratified with Boix data.
stcox Worig Sorig Sorig_x if sovereign == 1, strata(democracy)

' Cox model with just non-electoral regimes coded by Boix.
stcox Worig Worig_x Sorig Sorig_x if sovereign == 1 & democracy == 0

' Cox model with just electoral regimes coded by Boix.
stcox Worig Sorig Sorig_x if sovereign == 1 & democracy == 1

' Cox model stratified with Boix data using W/S.
stcox WoverS if sovereign == 1, strata(democracy)

'Cox model with just non-electoral regimes coded by Boix using W/S.
stcox WoverS if sovereign == 1 & democracy == 0

'Cox model with just electoral regimes coded by Boix using W/S.
stcox WoverS if sovereign == 1 & democracy == 0

' Cox model stratified with PRC data.
stcox Worig Sorig Sorig_x, strata(prc)

' Cox model with just authoritarian regimes in PRC data.
stcox Worig Sorig Sorig_x if prc == 1

' Cox model with just mixed regimes in PRC data.
stcox Worig Sorig if prc == 2

' Cox model with just democratic regimes in PRC data.
stcox Worig Sorig if prc == 3

' Cox model stratified with PRC data using W/S.
stcox WoverS WoverS_x, strata(prc)

'Cox model with just authoritarian regimes in PRC data using W/S.
stcox WoverS WoverS_x if prc == 1

'Cox model with just mixed regimes in PRC data using W/S.
stcox WoverS WoverS_x if prc == 2

'Cox model with just democratic regimes in PRC data using W/S.
stcox WoverS WoverS_x if prc == 3

