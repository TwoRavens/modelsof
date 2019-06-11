*Neo-Kantianism and Coercive Diplomacy: The Complex Case of Economic Sanctions
*A. Cooper Drury, Patrick James, and Dursun Peksen
*Replication Data
*Please contact first author with any questions about the data and analysis

* TABLE 1 - Selection Corrected Models
*Heckman Probit (implied threats)
heckprob imposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_implied=jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid) nolog
*outreg2 using table1a, excel

*Heckman Probit (implied threats)
heckprob imposed jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_implied=jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid) nolog
*outreg2 using table1b, excel

* Heckman Probit (overt threats)
heckprob imposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel( threat_overt =jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid) nolog
*outreg2 using table1c, excel

* Heckman Probit (overt threats)
heckprob imposed jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel( threat_overt =jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid) nolog
*outreg2 using table1d, excel


* TABLE 2 - Individual Probit Models
*Logit threat models with implied threat
logit threat_implied jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) nolog cluster(dyadid)
*outreg2 using table22, excel
*Logit imposition models GLOBAL DYADS
logit imposed jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, nolog vce(cluster dyadid)
*outreg2 using table26, excel

*Logit models with overt threat
logit threat_overt jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) nolog cluster(dyadid)
*outreg2 using table23, excel
logit overtimposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, nolog vce(cluster dyadid)
*outreg2 using table27, excel

*Logit models with overt threat
logit threat_overt jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) nolog cluster(dyadid)
*outreg2 using table24, excel
logit overtimposed jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, nolog vce(cluster dyadid)
*outreg2 using table28, excel


* Predicted Probabilities for Democracy
*Logit threat models with implied threat
logit threat_implied jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) nolog cluster(dyadid)
*outreg2 using table21, excel
*Predicted probabilities
*Aut-Aut 0.03
prvalue, x(jointdem=0 polity21=-6 polity22=-6) rest(median)
*Dem-Aut 0.05
prvalue, x(jointdem=0 polity21=6 polity22=-6) rest(median)
*Aut-Dem 0.04
prvalue, x(jointdem=0 polity21=-6 polity22=6) rest(median)
*Dem-Dem 0.02
prvalue, x(jointdem=1 polity21=6 polity22=6) rest(median)
*Logit imposition models GLOBAL DYADS
logit imposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, nolog vce(cluster dyadid)
*outreg2 using table25, excel
*Predicted probabilities
*Aut-Aut 0.03
prvalue, x(jointdem=0 polity21=-6 polity22=-6) rest(median)
*Dem-Aut 0.05
prvalue, x(jointdem=0 polity21=6 polity22=-6) rest(median)
*Aut-Dem 0.04
prvalue, x(jointdem=0 polity21=-6 polity22=6) rest(median)
*Dem-Dem 0.02
prvalue, x(jointdem=1 polity21=6 polity22=6) rest(median)


* Predicted Probabilities for Interdependence
* Interdependence Graph -- Threat Stage
logit threat_implied jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) nolog cluster(dyadid)

prgen lowtradedep, from (0.04) to (0.2) generate(durat) rest(mean) ci 

label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Interdependence"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)) 

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub


* Predicted Probabilities for Common IGO Membership
* IGO Membership Grap - Threat Stage
logit threat_implied jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) nolog cluster(dyadid)

prgen igomember_log, from (0.7) to (4.6) generate(durat) rest(mean) ci 

label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "IGO Membership (logged)"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)) 

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub


* IGO Membership Grap - Imposition Stage
logit imposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, nolog vce(cluster dyadid)

prgen igomember_log, from (0.7) to (4.6) generate(durat) rest(mean) ci 

label variable duratp1 "Probability of Sanction Imposition" 

label variable duratx "IGO Membership (logged)"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)) 

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub



* APPENDIX TABLE -- POLITICALLY ACTIVE DYADS
*Heckman Probit (implied threats)
heckprob imposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo if active_r==1, sel(threat_implied=jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid) nolog
*outreg2 using table1a, excel
*Heckman Probit (implied threats)
heckprob imposed jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo if active_r==1, sel(threat_implied=jointdem igomember_log s_tradedep t_tradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid) nolog
*outreg2 using table1b, excel

* Heckman Probit (overt threats)
heckprob imposed jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo if active_r==1, sel( threat_overt =jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid) nolog
*outreg2 using table2a, excel
* Heckman Probit (overt threats)
heckprob imposed jointdem igomember_log s_tradedep t_tradedep  ussender polity21 polity22 us_targetdem alliance_r capratio cwongo if active_r==1, sel( threat_overt =jointdem igomember_log s_tradedep t_tradedep  ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid) nolog
*outreg2 using table2b, excel


* APPENDIX TABLE - Total Trade as a measue of interdependence
*Heckman Probit (implied threats)
heckprob imposed jointdem igomember_log totaltradependence ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_implied=jointdem igomember_log totaltradependence ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid) nolog
*outreg2 using table1a, excel

* Heckman Probit (overt threats)
heckprob imposed jointdem igomember_log totaltradependence ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel( threat_overt =jointdem igomember_log totaltradependence ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid) nolog
*outreg2 using table1brobust, excel


* APPENDIX: Correlation Matrix
logit threat_implied jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) nolog cluster(dyadid)
gen targetdem = polity22
gen senderdem = polity21
gen sanctionthreats = threat_implied
gen igomembership = igomember_log
gen interdependence = lowtradedep
gen conflict = cwongo 
corr sanctionthreats jointdem igomembership interdependence s_tradedep t_tradedep ussender  polity22 alliance_r capratio conflict
corr imposed jointdem igomembership interdependence s_tradedep t_tradedep ussender polity21 polity22 alliance_r capratio conflict




