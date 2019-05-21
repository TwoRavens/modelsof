*********Cross-Sectional Models: Effects of Fear of Gender Favoritism on Clinton Vote Choice in Democratic Primary Campaign (Table 2)******** 

*****wave 1: HC vs. Others, among Democrats (unweighted) (Table 2, Columns 1 and 2)*****

*effects & predicted probs for perceived gender fave among men

logit firstdemHC_1 FFWperceptionsZ1_1 perceivedFFBZ1_1 pidstrengthZ1_1 i.black_1 educZ1_1 incomeZ1_1 ageZ1_1 i.oldsouth_1 campcontactZ1_1 polinterest_1 viableDem_1 electableDem_1 HCBOJEissue6_1 ideoproxHCBOJE_1 if male_1==1
margins, at((mean) _all black_1=0 oldsouth_1=0 FFWperceptionsZ1_1=(0(.1)1)) vsquish post

*effects & predicted probs for perceived racial fave among men

logit firstdemHC_1 FFWperceptionsZ1_1 perceivedFFBZ1_1 pidstrengthZ1_1 i.black_1 educZ1_1 incomeZ1_1 ageZ1_1 i.oldsouth_1 campcontactZ1_1 polinterest_1 viableDem_1 electableDem_1 HCBOJEissue6_1 ideoproxHCBOJE_1 if male_1==1
margins, at((mean) _all black_1=0 oldsouth_1=0 perceivedFFBZ1_1=(0(.1)1)) vsquish post

*effects & predicted probs for perceived gender fave among women

logit firstdemHC_1 FFWperceptionsZ1_1 perceivedFFBZ1_1 pidstrengthZ1_1 i.black_1 educZ1_1 incomeZ1_1 ageZ1_1 i.oldsouth_1 campcontactZ1_1 polinterest_1 viableDem_1 electableDem_1 HCBOJEissue6_1 ideoproxHCBOJE_1 if male_1==0
margins, at((mean) _all black_1=0 oldsouth_1=0 FFWperceptionsZ1_1=(0(.1)1)) vsquish post

*effects & predicted probs for perceived racial fave among women

logit firstdemHC_1 FFWperceptionsZ1_1 perceivedFFBZ1_1 pidstrengthZ1_1 i.black_1 educZ1_1 incomeZ1_1 ageZ1_1 i.oldsouth_1 campcontactZ1_1 polinterest_1 viableDem_1 electableDem_1 HCBOJEissue6_1 ideoproxHCBOJE_1 if male_1==0
margins, at((mean) _all black_1=0 oldsouth_1=0 perceivedFFBZ1_1=(0(.1)1)) vsquish post

*pooled fully interactive model to assess whether impact of gender favoritism varies by respondent gender

logit firstdemHC_1 i.male_1##c.FFWperceptionsZ1_1 i.male_1##c.perceivedFFBZ1_1 i.male_1##c.pidstrengthZ1_1 i.male_1##i.black_1 i.male_1##c.educZ1_1 i.male_1##c.incomeZ1_1 i.male_1##c.ageZ1_1 i.male_1##i.oldsouth_1 i.male_1##c.campcontactZ1_1 i.male_1##c.polinterest_1 i.male_1##c.viableDem_1 i.male_1##c.electableDem_1 i.male_1##c.HCBOJEissue6_1 i.male_1##c.ideoproxHCBOJE_1 

*same models with weights

logit firstdemHC_1 FFWperceptionsZ1_1 perceivedFFBZ1_1 pidstrengthZ1_1 i.black_1 educZ1_1 incomeZ1_1 ageZ1_1 i.oldsouth_1 campcontactZ1_1 polinterest_1 viableDem_1 electableDem_1 HCBOJEissue6_1 ideoproxHCBOJE_1 [pweight=weight_1] if male_1==1
logit firstdemHC_1 FFWperceptionsZ1_1 perceivedFFBZ1_1 pidstrengthZ1_1 i.black_1 educZ1_1 incomeZ1_1 ageZ1_1 i.oldsouth_1 campcontactZ1_1 polinterest_1 viableDem_1 electableDem_1 HCBOJEissue6_1 ideoproxHCBOJE_1 [pweight=weight_1] if male_1==0

******wave 3: HC vs. Others (Obama), among Democrats (unweighted) (Table 2, Columns 3 and 4)******

*effects & predicted probs for perceived & attitude gender fave among men

logit firstdemHC_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pidstrengthZ1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 viableDem_3 electableDem_3 HCBOJEissue6_3 ideoproxHCBOJE_3 if male_3==1
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWperceptionsZ1_3=(0(.1)1)) vsquish post
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWattitudesZ1_3=(0(.1)1)) vsquish post

*effects & predicted probs for perceived & attitude racial fave among men

logit firstdemHC_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pidstrengthZ1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 viableDem_3 electableDem_3 HCBOJEissue6_3 ideoproxHCBOJE_3 if male_3==1
margins, at((mean) _all black_3=0 oldsouth_3=0 perceivedFFBZ1_3=(0(.1)1)) vsquish post
margins, at((mean) _all black_3=0 oldsouth_3=0 attitudeFFBZ1_3=(0(.1)1)) vsquish post

*effects & predicted probs for perceived & attitude gender fave among women

logit firstdemHC_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pidstrengthZ1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 viableDem_3 electableDem_3 HCBOJEissue6_3 ideoproxHCBOJE_3 if male_3==0
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWperceptionsZ1_3=(0(.1)1)) vsquish post
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWattitudesZ1_3=(0(.1)1)) vsquish post

*effects & predicted probs for perceived & attitude racial fave among women

logit firstdemHC_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pidstrengthZ1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 viableDem_3 electableDem_3 HCBOJEissue6_3 ideoproxHCBOJE_3 if male_3==0
margins, at((mean) _all black_3=0 oldsouth_3=0 perceivedFFBZ1_3=(0(.1)1)) vsquish post
margins, at((mean) _all black_3=0 oldsouth_3=0 attitudeFFBZ1_3=(0(.1)1)) vsquish post

*******Figure 1 plots of predicted probs of perceived & attitude gender fave by respondent gender

logit firstdemHC_3 i.male_3##c.FFWperceptionsZ1_3 i.male_3##c.FFWattitudesZ1_3 i.male_3##c.perceivedFFBZ1_3 i.male_3##c.attitudeFFBZ1_3 i.male_3##c.pidstrengthZ1_3 i.male_3##i.black_3 i.male_3##c.educZ1_3 i.male_3##c.incomeZ1_3 i.male_3##c.ageZ1_3 i.male_3##i.oldsouth_3 i.male_3##c.campcontactZ1_3 i.male_3##c.polinterest_3 i.male_3##c.viableDem_3 i.male_3##c.electableDem_3 i.male_3##c.HCBOJEissue6_3 i.male_3##c.ideoproxHCBOJE_3 
margins male_3, at((mean) _all black_3=0 oldsouth_3=0 FFWperceptionsZ1_3=(0(.1)1)) vsquish post
marginsplot, xlabel(0(.1)1) ylabel(0(.1)1) title("Wave 3") xtitle(Perceptions of Gender Favoritism) ytitle(Probability of a Vote for Clinton)
marginsplot, xlabel(0(.1)1) ylabel(0(.1)1) recast(line) recastci(rarea) title("Wave 3") xtitle(Perceptions of Gender Favoritism) ytitle(Probability of a Vote for Clinton)
margins, dydx(male_3) at((mean) _all black_3=0 oldsouth_3=0 FFWperceptionsZ1_3=(0(.1)1)) vsquish post
marginsplot, yline(0)

logit firstdemHC_3 i.male_3##c.FFWperceptionsZ1_3 i.male_3##c.FFWattitudesZ1_3 i.male_3##c.perceivedFFBZ1_3 i.male_3##c.attitudeFFBZ1_3 i.male_3##c.pidstrengthZ1_3 i.male_3##i.black_3 i.male_3##c.educZ1_3 i.male_3##c.incomeZ1_3 i.male_3##c.ageZ1_3 i.male_3##i.oldsouth_3 i.male_3##c.campcontactZ1_3 i.male_3##c.polinterest_3 i.male_3##c.viableDem_3 i.male_3##c.electableDem_3 i.male_3##c.HCBOJEissue6_3 i.male_3##c.ideoproxHCBOJE_3 
margins male_3, at((mean) _all black_3=0 oldsouth_3=0 FFWattitudesZ1_3=(0(.1)1)) vsquish post
marginsplot, xlabel(0(.1)1) ylabel(0(.1)1) title("Wave 3") xtitle(Attitudes about Gender Favoritism) ytitle(Probability of a Vote for Clinton)
marginsplot, xlabel(0(.1)1) ylabel(0(.1)1) recast(line) recastci(rarea) title("Wave 3") xtitle(Attitudes about Gender Favoritism) ytitle(Probability of a Vote for Clinton)
margins, dydx(male_3) at((mean) _all black_3=0 oldsouth_3=0 FFWattitudesZ1_3=(0(.1)1)) vsquish post
marginsplot, yline(0)

*same models with weights

logit firstdemHC_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pidstrengthZ1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 viableDem_3 electableDem_3 HCBOJEissue6_3 ideoproxHCBOJE_3 [pweight=weight_3] if male_3==1
logit firstdemHC_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pidstrengthZ1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 viableDem_3 electableDem_3 HCBOJEissue6_3 ideoproxHCBOJE_3 [pweight=weight_3] if male_3==0

********fixed effects logit models for two-period data (i.e., using difference scores to simplify presentation)

*explaining change in the Clinton vote

drop if firstdemHC_1==firstdemHC_3
gen FFWperceptions=FFWperceptionsZ1_3-FFWperceptionsZ1_1
gen perceivedFFB=perceivedFFBZ1_3-perceivedFFBZ1_1
gen pidstrength=pidstrengthZ1_3-pidstrengthZ1_1
gen ideo=ideoZ1_3-ideoZ1_1
gen nationecon=nationeconZ1_3-nationeconZ1_2
gen familyecon=familyeconZ1_3-familyeconZ1_2
gen libconHC=libconHCZ1_3-libconHCZ1_1
gen libconBO=libconBOZ1_3-libconBOZ1_1
gen HCther=HCther_3-HCther_1
gen campcontact=campcontactZ1_3-campcontactZ1_1
gen polinterest=polinterest_3-polinterest_1
gen viableDem=viableDem_3-viableDem_1
gen electableDem=electableDem_3-electableDem_1
gen HCBOJEissue6=HCBOJEissue6_3-HCBOJEissue6_1
gen HCBOissue6=HCBOissue6Z1_3-HCBOissue6Z1_1
gen ideoproxHCBOJE=ideoproxHCBOJE_3-ideoproxHCBOJE_1
gen ideoproxHCBO=ideoproxHCBOZ1_3-ideoproxHCBOZ1_1

*models shown in Table 5 (unweighted)

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==1 & firstdemHC13==1
logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==0 & firstdemHC13==1

*pooled fully interactive model to assess differential effects by gender

logit firstdemHC_3 c.FFWperceptions##i.male_1 c.FFWperceptionsZ1_1##i.male_1 c.perceivedFFB##i.male_1 c.perceivedFFBZ1_1##i.male_1 c.pidstrength##i.male_1 c.pidstrengthZ1_1##i.male_1 i.black_1##i.male_1 c.educZ1_1##i.male_1 c.incomeZ1_1##i.male_1 c.ageZ1_1##i.male_1 i.oldsouth_1##i.male_1 c.campcontact##i.male_1 c.campcontactZ1_1##i.male_1 c.polinterest##i.male_1 c.polinterest_1##i.male_1 c.viableDem##i.male_1 c.viableDem_1##i.male_1 c.HCBOJEissue6##i.male_1 c.HCBOJEissue6_1##i.male_1 c.ideoproxHCBOJE##i.male_1 c.ideoproxHCBOJE_1##i.male_1 if firstdemHC13==1

*models with weights

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 [pweight=weight_13] if male_1==1 & firstdemHC13==1
logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 [pweight=weight_13] if male_1==0 & firstdemHC13==1
logit firstdemHC_3 c.FFWperceptions##i.male_1 c.FFWperceptionsZ1_1##i.male_1 c.perceivedFFB##i.male_1 c.perceivedFFBZ1_1##i.male_1 c.pidstrength##i.male_1 c.pidstrengthZ1_1##i.male_1 i.black_1##i.male_1 c.educZ1_1##i.male_1 c.incomeZ1_1##i.male_1 c.ageZ1_1##i.male_1 i.oldsouth_1##i.male_1 c.campcontact##i.male_1 c.campcontactZ1_1##i.male_1 c.polinterest##i.male_1 c.polinterest_1##i.male_1 c.viableDem##i.male_1 c.viableDem_1##i.male_1 c.HCBOJEissue6##i.male_1 c.HCBOJEissue6_1##i.male_1 c.ideoproxHCBOJE##i.male_1 c.ideoproxHCBOJE_1##i.male_1 [pweight=weight_13] if firstdemHC13==1

*******probability of CHANGE in Clinton support at 10th and 90th percentile of perceptions of gender favoritism

summarize FFWperceptions, detail
summarize FFWperceptionsZ1_1, detail
table FFWperceptionsZ1_1

summarize perceivedFFB, detail
summarize perceivedFFBZ1_1, detail
table perceivedFFBZ1_1

****among male Dems

*change in perceived gender favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==1 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 FFWperceptions=(-.33(.066).33)) vsquish post

*initial perceived gender favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==1 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 FFWperceptionsZ1_1=(0(.06).66)) vsquish post

*change in perceived racial favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==1 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 perceivedFFB=(-.33(.066).33)) vsquish post

*initial perceived racial favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==1 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 perceivedFFBZ1_1=(0(.06).66)) vsquish post

****among female Dems

*change in perceived gender favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==0 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 FFWperceptions=(-.33(.066).33)) vsquish post

*initial perceived gender favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==0 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 FFWperceptionsZ1_1=(0(.06).66)) vsquish post

*change in perceived racial favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==0 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 perceivedFFB=(-.33(.066).33)) vsquish post

*initial perceived racial favoritism

logit firstdemHC_3 FFWperceptions FFWperceptionsZ1_1 perceivedFFB perceivedFFBZ1_1 pidstrength pidstrengthZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 campcontact campcontactZ1_1 polinterest polinterest_1 viableDem viableDem_1 HCBOJEissue6 HCBOJEissue6_1 ideoproxHCBOJE ideoproxHCBOJE_1 if male_1==0 & firstdemHC13==1
margins, at((mean) _all black_1=0 oldsouth_1=0 perceivedFFBZ1_1=(0(.06).66)) vsquish post

*********Cross-Sectional Models: Effects of Fear of Gender Favoritism in Hypothetical General Election Match-Up between Hillary Clinton and John McCain (Table 6)******** 

********wave 3: HC vs. JM, among all Rs*********

*among men

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==1
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWperceptionsZ1_3=(0(.1)1)) vsquish post

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==1
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWattitudesZ1_3=(0(.1)1)) vsquish post

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==1
margins, at((mean) _all black_3=0 oldsouth_3=0 perceivedFFBZ1_3=(0(.1)1)) vsquish post

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==1
margins, at((mean) _all black_3=0 oldsouth_3=0 attitudeFFBZ1_3=(0(.1)1)) vsquish post

*among women

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==0
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWperceptionsZ1_3=(0(.1)1)) vsquish post

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==0
margins, at((mean) _all black_3=0 oldsouth_3=0 FFWattitudesZ1_3=(0(.1)1)) vsquish post

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==0
margins, at((mean) _all black_3=0 oldsouth_3=0 perceivedFFBZ1_3=(0(.1)1)) vsquish post

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 if male_3==0
margins, at((mean) _all black_3=0 oldsouth_3=0 attitudeFFBZ1_3=(0(.1)1)) vsquish post

*wave 3: HC vs. JM, among all Rs (with weights)

logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 [pweight=weight_3] if male_3==1
logit HCJM_3 FFWperceptionsZ1_3 FFWattitudesZ1_3 perceivedFFBZ1_3 attitudeFFBZ1_3 pid7Z1_3 i.black_3 educZ1_3 incomeZ1_3 ageZ1_3 i.oldsouth_3 campcontactZ1_3 polinterest_3 HCJMissue6Z1_3 ideoproxHCJMZ1_3 [pweight=weight_3] if male_3==0
 
**********Predictors of Fear of Gender Favoritism (Online Appendix C Table C1*************

*wave 1 perceptions of gender fave

reg FFWperceptionsZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 male_1

reg FFWperceptionsZ1_1 black_1 educZ1_1 incomeZ1_1 ageZ1_1 oldsouth_1 male_1 pid7Z1_1 ideoZ1_1 campcontactZ1_1 polinterest_1 perceivedFFBZ1_1

*wave 3 perceptions of gender fave

reg FFWperceptionsZ1_3 black_3 educZ1_3 incomeZ1_3 ageZ1_3 oldsouth_3 male_3

reg FFWperceptionsZ1_3 black_3 educZ1_3 incomeZ1_3 ageZ1_3 oldsouth_3 male_3 pid7Z1_3 ideoZ1_3 campcontactZ1_3 polinterest_3 perceivedFFBZ1_3

*wave 3 attitudes about gender fave

reg FFWattitudesZ1_3 black_3 educZ1_3 incomeZ1_3 ageZ1_3 oldsouth_3 male_3

reg FFWattitudesZ1_3 black_3 educZ1_3 incomeZ1_3 ageZ1_3 oldsouth_3 male_3 pid7Z1_3 ideoZ1_3 campcontactZ1_3 polinterest_3 attitudeFFBZ1_3



