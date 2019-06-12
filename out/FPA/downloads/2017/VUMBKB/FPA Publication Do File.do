clear
use "C:\Users\Jeff\Documents\DissertationFolder\Aid\NewMasterData.dta"

drop if dyadid==.
drop if year==87
drop if year==-99
xtset dyadid year

label var imposition "Sanction Imposed"
label var sMyWNeoDummy "Sender Elite University"
label var tMyWNeoDummy "Target Elite University"
label var MyDyadWNeoDummy "Both Elite University" 
label var TestMyNeoliberal "Average Elite University"
label var MajorSenderCost "Major Sender Cost"
label var MajorTargetCost "Major Target Cost"
label var n_issue1 "Dispute Issues"
label var n_sanctiontypethreat "Type of Sanction Threat"
label var BIT "Bilateral Investment Treaty"
label var IMF "IMF Membership"
label var WTO "WTO Membership"
label var jointdem "Joint Democracy"
label var igomember "IGO Membership"
label var lowtradedep "Interdependence"
label var ussender "US Sender"
label var polity21 "Sender Regime"
label var polity22 "Target Regime"
label var us_targetdem "US*Target Regime"
label var alliance_r "Alliance"
label var capratio "Capability Ratio"
label var cwongo "Military Conflict"
label var sEdu "Sender Executive Education"
label var tEdu "Target Executive Education"
label var SenderGovt "Sender Government Ideology"
label var TargetGovt "Target Government Ideology"
label var WBScaleGovt "Overall Ideology"
label var AddRestrictions "Additive Restrictions"
label var FinOpen "Financial Openness"
label var ExecImp "Executive Imposition"
label var GovtImp "Government Imposition"


*****************************************Publication Models*******************************************************
****Table 1****
*Models 1 and 2*
heckprob imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat= sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 3*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 4*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 5*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 6*
logit ExecImp sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal  MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 7*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal  MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)




****Table 2****
*Models 1 and 2*
heckprob imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 3
logit threat sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 4*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 5*
logit threat sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 6*
logit ExecImp sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 7*
logit threat sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)




****Table 3****
*Models 1 and 2*
heckprob imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat= SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 3*
logit threat SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 4*
logit imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 5*
logit threat SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 7*
logit threat SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)




****Table 4****
*Models 1 and 2*
heckprob imposition AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 3*
logit threat AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 4*
logit imposition AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 5*
logit threat AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 7*
logit threat AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)





****Table 5****
*Models 1 and 2*
heckprob imposition FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 3*
logit threat FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 4*
logit imposition FinOpen BIT WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 5*
logit threat FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 6*
logit ExecImp FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat  BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 7*
logit threat FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat  BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)





**************************************Figures*********************************************************
*Figure 1*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
prgen tMyWNeoDummy, from (0) to (1) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Neoliberal Target State"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure1)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub



*Figure 2*
logit threat sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
prgen sEdu, from (0) to (1) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Graduate Education of Sender Executive"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure2)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub



*Figure 3*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
prgen sEdu, from (0) to (1) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Imposition" 

label variable duratx "Graduate Education of Sender Executive"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure3)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub



*Figure 4*
logit threat SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
prgen WBScaleGovt, from (0) to (3) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Ideology of Government"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure4)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub




*Figure 5*
logit imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
prgen TargetGovt, from (0) to (1) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Ideology of Target Government"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure5)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub




*Figure 6*
logit threat AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
prgen AddRestrictions, from (9.265653) to (195.8378) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Additive Restrictions of Sender and Target States"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure6)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub




*Figure 7*
logit imposition FinOpen BIT WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
prgen FinOpen, from (-1.875024) to (2.421764) generate(durat) rest(mean) ci 
label variable duratp1 "Probability of Sanction Threat" 

label variable duratx "Lowest Financial Openness of Dyad"  

label variable duratp1lb "95% lower limit" 

label variable duratp1ub "95% upper limit"

twoway (connected duratp1 duratx, lpattern(solid) lwidth(medthick) msymbol(none)) (connected duratp1lb duratx, lpattern(dash) lwidth(thin) msymbol(none)) (connected  duratp1ub duratx, lpattern(dash) lwidth(thin) msymbol(none)), saving(Figure7)

drop duratx duratp0 duratp1 duratp0lb duratp1lb duratp0ub duratp1ub
