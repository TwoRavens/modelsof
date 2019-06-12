***********************************Supplemental Appendix Models**************************************
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
label var FinOpen "Financial Openness
label var MaxEducation "Both Graduate Education"
label var NewExecDumm2 "Shared Executive Ideology"
label var NewP1Dummy2 "Shared Party Ideology"
label var NewSenderIdeology "Sender Executive Ideology"
label var NewTargetIdeology "Target Executive Ideology"
label var SenderP1Ideology "Sender Party Ideology"
label var TargetP1Ideology "Target Party Ideology"
label var AveRestrictions "Average Restrictions"
label var senderrestrictions "Sender Restrictions"
label var targetrestrictions "Target Restrictions"
label var senderkaopen "Sender Financial Openness"
label var targetkaopen "Target Financial Openness"
label var ExecThreat "Executive Threat"
label var GovtThreat "Government Threat"

*****************Tables 6-10 Overt Threat Models************************
****Table 1****
*Models 1 and 2*
heckprob imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_overtn= sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 3*
logit threat_overtn sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 4*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 5*
logit threat_overtn sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 6
logit ExecImp sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 7*
logit threat_overtn sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table1 , word label title(Table 1: Elite University Attendance For Senders and Targets) bdec(3)




****Table 2****
*Models 1 and 2*
heckprob imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_overtn=sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 3
logit threat_overtn sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 4*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 5*
logit threat_overtn sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 6*
logit ExecImp sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 7*
logit threat_overtn sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table2 , word label title(Table 2: Graduate School Attendance For Senders and Targets) bdec(3)




****Table 3****
*Models 1 and 2*
heckprob imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_overtn= SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 3*
logit threat_overtn SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 4*
logit imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 5*
logit threat_overtn SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 7*
logit threat_overtn SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, iterate(10) cluster(dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table3 , word label title(Table 3: Political Ideology for Senders and Targets) bdec(3)




****Table 4****
*Models 1 and 2*
heckprob imposition AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_overtn=AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 3*
logit threat_overtn AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 4*
logit imposition AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 5*
logit threat_overtn AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 7*
logit threat_overtn AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table4 , word label title(Table 4: Level of Restrictions for Senders and Targets) bdec(3)




****Table 5****
*Models 1 and 2*
heckprob imposition FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat_overtn=FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o) vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 3*
logit threat_overtn FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 4*
logit imposition FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 5*
logit threat_overtn FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 6*
logit ExecImp FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat  BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 7*
logit threat_overtn FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_o threat_years2_o threat_years3_o, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat  BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table5 , word label title(Table 5: Level of Financial Openness For Senders and Targets) bdec(3)



********************Different Specification Tables 11-17*************************
****Table 6****
*Models 1 and 2*
heckprob imposition MaxEducation BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=MaxEducation BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 3
logit threat MaxEducation BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 4*
logit imposition MaxEducation BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 5*
logit threat MaxEducation BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 6*
logit ExecImp MaxEducation MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 7*
logit threat MaxEducation BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 8*
logit GovtImp MaxEducation MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table6 , word label title(Table 6: Graduate School Attendance For Senders and Targets) bdec(3)




****Table 7****
*Models 1 and 2*
heckprob imposition NewExecDumm2 NewP1Dummy2 BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat= NewExecDumm2 NewP1Dummy2 BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)

*Model 3*
logit threat NewExecDumm2 NewP1Dummy2 BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)

*Model 4*
logit imposition NewExecDumm2 NewP1Dummy2 BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)

*Model 5*
logit threat NewExecDumm2 NewP1Dummy2 BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp NewExecDumm2 NewP1Dummy2 MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)

*Model 7*
logit threat NewExecDumm2 NewP1Dummy2 BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp NewExecDumm2 NewP1Dummy2 MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table7 , word label title(Table 7: Political Ideology for Senders and Targets) bdec(3)



****Table 8****
*Models 1 and 2*
heckprob imposition NewSenderIdeology NewTargetIdeology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat= NewSenderIdeology NewTargetIdeology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)

*Model 3*
logit threat NewSenderIdeology NewTargetIdeology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)

*Model 4*
logit imposition NewSenderIdeology NewTargetIdeology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)

*Model 5*
logit threat NewSenderIdeology NewTargetIdeology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp NewSenderIdeology NewTargetIdeology WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)

*Model 7*
logit threat NewSenderIdeology NewTargetIdeology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp NewSenderIdeology NewTargetIdeology WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table8 , word label title(Table 8: Political Ideology for Senders and Targets) bdec(3)



****Table 9****
*Models 1 and 2*
heckprob imposition SenderP1Ideology TargetP1Ideology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat= SenderP1Ideology TargetP1Ideology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)

*Model 3*
logit threat SenderP1Ideology TargetP1Ideology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)

*Model 4*
logit imposition SenderP1Ideology TargetP1Ideology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)

*Model 5*
logit threat SenderP1Ideology TargetP1Ideology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp SenderP1Ideology TargetP1Ideology WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)

*Model 7*
logit threat SenderP1Ideology TargetP1Ideology WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp SenderP1Ideology TargetP1Ideology WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table9 , word label title(Table 9: Political Ideology for Senders and Targets) bdec(3)



****Table 10****
*Models 1 and 2*
heckprob imposition AveRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=AveRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)

*Model 3*
logit threat AveRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)

*Model 4*
logit imposition AveRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)

*Model 5*
logit threat AveRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp AveRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)

*Model 7*
logit threat AveRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp AveRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table10 , word label title(Table 10: Level of Restrictions for Senders and Targets) bdec(3)



****Table 11****
*Models 1 and 2*
heckprob imposition senderrestrictions targetrestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=senderrestrictions targetrestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)

*Model 3*
logit threat senderrestrictions targetrestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)

*Model 4*
logit imposition senderrestrictions targetrestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)

*Model 5*
logit threat senderrestrictions targetrestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp senderrestrictions targetrestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)

*Model 7*
logit threat senderrestrictions targetrestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp senderrestrictions targetrestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table11 , word label title(Table 11: Level of Restrictions for Senders and Targets) bdec(3)



****Table 12****
*Models 1 and 2*
heckprob imposition senderkaopen targetkaopen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=senderkaopen targetkaopen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)

*Model 3*
logit threat senderkaopen targetkaopen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)

*Model 4*
logit imposition senderkaopen targetkaopen BIT WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)

*Model 5*
logit threat senderkaopen targetkaopen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)

*Model 6*
logit ExecImp senderkaopen targetkaopen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)

*Model 7*
logit threat senderkaopen targetkaopen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)

*Model 8*
logit GovtImp senderkaopen targetkaopen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table12 , word label title(Table 12: Level of Restrictions for Senders and Targets) bdec(3)



******************** Tables 13-17 Executive and Government Threat Models*************************
****Table 13****
*Model 1*
logit ExecThreat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table13 , word label title(Table 13: Executive Threats and Elite University Attendance) bdec(3)

*Model 2*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table13 , word label title(Table 13: Executive Threats and Elite University Attendance) bdec(3)

*Model 3*
logit GovtThreat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table13 , word label title(Table 13: Executive Threats and Elite University Attendance) bdec(3)

*Model 4*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table13 , word label title(Table 13: Executive Threats and Elite University Attendance) bdec(3)




****Table 14****
*Model 1*
logit ExecThreat sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table14 , word label title(Table 14: Executive Threats and Graduate Education) bdec(3)

*Model 2*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table14 , word label title(Table 14: Executive Threats and Graduate Education) bdec(3)

*Model 3*
logit GovtThreat sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table14 , word label title(Table 14: Executive Threats and Graduate Education) bdec(3)

*Model 15*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table14 , word label title(Table 14: Executive Threats and Graduate Education) bdec(3)




****Table 15****
*Model 1*
logit ExecThreat SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table15 , word label title(Table 15: Executive and Government Threats and Political Ideology) bdec(3)

*Model 2*
logit imposition  SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table15 , word label title(Table 15: Executive and Government Threats and Political Ideology) bdec(3)

*Model 3*
logit GovtThreat SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table15 , word label title(Table 15: Executive and Government Threats and Political Ideology) bdec(3)

*Model 4*
logit imposition  SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table15 , word label title(Table 15: Executive and Government Threats and Political Ideology) bdec(3)




****Table 16****
*Model 1*
logit ExecThreat AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table16 , word label title(Table 16: Executive and Government Threats and Restrictions) bdec(3)

*Model 2*
logit imposition  AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table16 , word label title(Table 16: Executive and Government Threats and Restrictions) bdec(3)

*Model 3
logit GovtThreat AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table16 , word label title(Table 16: Executive and Government Threats and Restrictions) bdec(3)

*Model 4*
logit imposition  AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table16 , word label title(Table 16: Executive and Government Threats and Restrictions) bdec(3)



****Table 17****
*Model 1*
logit ExecThreat FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table17 , word label title(Table 17: Executive and Government Threats and Financial Openness) bdec(3)

*Model 2*
logit imposition  FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table17 , word label title(Table 17: Executive and Government Threats and Financial Openness) bdec(3)

*Model 3*
logit GovtThreat FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table17 , word label title(Table 17: Executive and Government Threats and Financial Openness) bdec(3)

*Model 4*
logit imposition  FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table17 , word label title(Table 17: Executive and Government Threats and Financial Openness) bdec(3)


*****************************Tables 25-29 Corrected Models for Tables 18-22 of Supplemental*************************************************

****Table 25****
*Model 1*
logit ExecThreat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table25 , word label title(Table 25: Executive Threats and Elite University Attendance) bdec(3)

*Model 2*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table25 , word label title(Table 25: Executive Threats and Elite University Attendance) bdec(3)

*Model 3*
logit GovtThreat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table25 , word label title(Table 25: Executive Threats and Elite University Attendance) bdec(3)

*Model 4*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table25 , word label title(Table 25: Executive Threats and Elite University Attendance) bdec(3)




****Table 26****
*Model 1*
logit ExecThreat sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table26 , word label title(Table 26: Executive Threats and Graduate Education) bdec(3)

*Model 2*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table26 , word label title(Table 26: Executive Threats and Graduate Education) bdec(3)

*Model 3*
logit GovtThreat sEdu tEdu MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table26 , word label title(Table 26: Executive Threats and Graduate Education) bdec(3)

*Model 4*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table26 , word label title(Table 26: Executive Threats and Graduate Education) bdec(3)




****Table 27****
*Model 1*
logit ExecThreat SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table27 , word label title(Table 27: Executive and Government Threats and Political Ideology) bdec(3)

*Model 2*
logit imposition  SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table27 , word label title(Table 27: Executive and Government Threats and Political Ideology) bdec(3)

*Model 3*
logit GovtThreat SenderGovt TargetGovt WBScaleGovt MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table27 , word label title(Table 27: Executive and Government Threats and Political Ideology) bdec(3)

*Model 4*
logit imposition  SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table27 , word label title(Table 27: Executive and Government Threats and Political Ideology) bdec(3)




****Table 28****
*Model 1*
logit ExecThreat AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table28 , word label title(Table 28: Executive and Government Threats and Restrictions) bdec(3)

*Model 2*
logit imposition  AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table28, word label title(Table 28: Executive and Government Threats and Restrictions) bdec(3)

*Model 3
logit GovtThreat AddRestrictions MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table28 , word label title(Table 28: Executive and Government Threats and Restrictions) bdec(3)

*Model 4*
logit imposition  AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table28 , word label title(Table 28: Executive and Government Threats and Restrictions) bdec(3)



****Table 29****
*Model 1*
logit ExecThreat FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_exec threat_years2_exec threat_years3_exec, iterate(10) cluster(dyadid)
outreg2 using Table29 , word label title(Table 29: Executive and Government Threats and Financial Openness) bdec(3)

*Model 2*
logit imposition  FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table29 , word label title(Table 29: Executive and Government Threats and Financial Openness) bdec(3)

*Model 3*
logit GovtThreat FinOpen MajorSenderCost MajorTargetCost i.n_threatenedtargetinterest n_issue1 n_sanctiontypethreat BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_govt threat_years2_govt threat_years3_govt, iterate(10) cluster(dyadid)
outreg2 using Table29 , word label title(Table 29: Executive and Government Threats and Financial Openness) bdec(3)

*Model 4*
logit imposition  FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table30 , word label title(Table 29: Executive and Government Threats and Financial Openness) bdec(3)



*******************************Table 18 Interaction Models******************************
****Table 18****
*Models 1 and 2* 
heckprob imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat= sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy c.TestMyNeoliberal##i.BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table18 , word label title(Table 18: Average Elite University Attendance and Bilateral Investment Treaties) bdec(3)

*Model 3*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy c.TestMyNeoliberal##i.BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, iterate(10) cluster(dyadid)
outreg2 using Table18 , word label title(Table 18: Average Elite University Attendance and Bilateral Investment Treaties) bdec(3)

*Model 4*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table18 , word label title(Table 18: Average Elite University Attendance and Bilateral Investment Treaties) bdec(3)



*****************************Tables 29-34 Fixed Effect Models*********************************
****Table 19****
*Model 1*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode1, iterate(10) cluster(dyadid)
outreg2 using Table19 , word label title(Table 19: Elite University Attendance For Senders and Targets With Fixed Effects) bdec(3)

*Model 2*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode1, vce(cluster dyadid)
outreg2 using Table19 , word label title(Table 19: Elite University Attendance For Senders and Targets With Fixed Effects) bdec(3)

*Model 3*
logit threat sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode2, iterate(10) cluster(dyadid)
outreg2 using Table19 , word label title(Table 19: Elite University Attendance For Senders and Targets With Fixed Effects) bdec(3)

*Model 4*
logit imposition sMyWNeoDummy tMyWNeoDummy MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode2, vce(cluster dyadid)
outreg2 using Table19 , word label title(Table 19: Elite University Attendance For Senders and Targets With Fixed Effects) bdec(3)



****Table 20****
*Model 1*
logit threat sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode1, iterate(10) cluster(dyadid)
outreg2 using Table20 , word label title(Table 20: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 2*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode1, vce(cluster dyadid)
outreg2 using Table20 , word label title(Table 20: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 3*
logit threat sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode2, iterate(10) cluster(dyadid)
outreg2 using Table20 , word label title(Table 20: Graduate School Attendance For Senders and Targets) bdec(3)

*Model 4*
logit imposition sEdu tEdu BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode2, vce(cluster dyadid)
outreg2 using Table20 , word label title(Table 20: Graduate School Attendance For Senders and Targets) bdec(3)



****Table 21****
*Model 1*
logit threat SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode1, iterate(10) cluster(dyadid)
outreg2 using Table21 , word label title(Table 21: Political Ideology For Senders and Targets) bdec(3)

*Model 2*
logit imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode1, vce(cluster dyadid)
outreg2 using Table21 , word label title(Table 21: Political Ideology For Senders and Targets) bdec(3)

*Model 3*
logit threat SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode2, iterate(10) cluster(dyadid)
outreg2 using Table21 , word label title(Table 21: Political Ideology For Senders and Targets) bdec(3)

*Model 4*
logit imposition SenderGovt TargetGovt WBScaleGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode2, vce(cluster dyadid)
outreg2 using Table21 , word label title(Table 21: Political Ideology For Senders and Targets) bdec(3)



****Table 22****
*Model 1*
logit threat AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode1, iterate(10) cluster(dyadid)
outreg2 using Table22 , word label title(Table 22: Restrictions For Senders and Targets) bdec(3)

*Model 2*
logit imposition AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode1, vce(cluster dyadid)
outreg2 using Table22 , word label title(Table 22: Restrictions For Senders and Targets) bdec(3)

*Model 3*
logit threat AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode2, iterate(10) cluster(dyadid)
outreg2 using Table22 , word label title(Table 22: Restrictions For Senders and Targets) bdec(3)

*Model 4*
logit imposition AddRestrictions BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode2, vce(cluster dyadid)
outreg2 using Table22 , word label title(Table 22: Restrictions For Senders and Targets) bdec(3)



****Table 23****
*Model 1*
logit threat FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode1, iterate(10) cluster(dyadid)
outreg2 using Table23 , word label title(Table 23: Financial Openness For Senders and Targets) bdec(3)

*Model 2*
logit imposition FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode1, vce(cluster dyadid)
outreg2 using Table23 , word label title(Table 23: Financial Openness For Senders and Targets) bdec(3)

*Model 3*
logit threat FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.ccode2, iterate(10) cluster(dyadid)
outreg2 using Table23 , word label title(Table 23: Financial Openness For Senders and Targets) bdec(3)

*Model 4*
logit imposition FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo i.ccode2, vce(cluster dyadid)
outreg2 using Table23 , word label title(Table 23: Financial Openness For Senders and Targets) bdec(3)



****Table 24****
*Model 1*
xtlogit threat MyDyadWNeoDummy TestMyNeoliberal BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.year, fe
outreg2 using Table24 , word label title(Table 24: Dyad Fixed Effects) bdec(3)

*Model 2*
xtlogit threat MyDyadWNeoDummy c.TestMyNeoliberal##i.BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.year, fe
outreg2 using Table24 , word label title(Table 24: Dyad Fixed Effects) bdec(3)

*Model 3*
xtlogit threat SenderGovt TargetGovt BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.year, fe
outreg2 using Table24 , word label title(Table 24: Dyad Fixed Effects) bdec(3)

*Model 4*
xtlogit threat FinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i i.year, fe
outreg2 using Table24 , word label title(Table 24: Dyad Fixed Effects) bdec(3)



**************************************Additional Reviewer 3 Additions************************************
********Additive vs. Shared*********
gen AddIdeology = (NewSenderIdeology + NewTargetIdeology) if (NewSenderIdeology!=. & NewTargetIdeology!=.)
gen AddFinOpen = (senderrestrictions + targetrestrictions) if (senderrestrictions!=. & targetrestrictions!=.)
gen DyadFinOpen = ((senderkaopen + targetkaopen)/2) 

****Table 30****
*Models 1 and 2*
heckprob imposition WBScaleGovt AddIdeology BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=WBScaleGovt AddIdeology BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table30 , word label title(Table 30: Additive vs. Shared Ideology) bdec(3)

*Model 3*
logit threat WBScaleGovt AddIdeology BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table30 , word label title(Table 30: Additive vs. Shared Ideology) bdec(3)

*Model 4*
logit imposition WBScaleGovt AddIdeology BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table30 , word label title(Table 30: Additive vs. Shared Ideology) bdec(3)



****Table 31****
*Models 1 and 2*
heckprob imposition AddFinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, sel(threat=AddFinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i) vce(cluster dyadid)
outreg2 using Table31 , word label title(Table 31: Additive Financial Openness) bdec(3)

*Model 3*
logit threat AddFinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo threat_years_i threat_years2_i threat_years3_i, vce(cluster dyadid)
outreg2 using Table31 , word label title(Table 31: Additive Financial Openness) bdec(3)

*Model 4*
logit imposition AddFinOpen BIT IMF WTO jointdem igomember_log lowtradedep ussender polity21 polity22 us_targetdem alliance_r capratio cwongo, vce(cluster dyadid)
outreg2 using Table31 , word label title(Table 31: Additive Financial Openness) bdec(3)







