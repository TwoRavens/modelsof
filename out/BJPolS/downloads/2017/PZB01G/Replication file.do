***DATA PREPARATION

*Insert file path
use "C:\...\Vignette data.dta" 

**Generate Treatment Dummies
gen pos_culture = 0
recode pos_culture (0=1) if split==2 | split==4 | split== 6 | split== 8

gen pos_econ = 0 
recode pos_econ (0=1) if split==2 | split==3 | split== 6 | split== 7

gen pos_poli = 0 
recode pos_poli (0=1) if split==2 | split==3 | split==4 |split== 5

gen neg_culture = 0
recode neg_culture (0=1) if split==3 | split==5 | split== 7 | split== 9

gen neg_econ = 0 
recode neg_econ (0=1) if split==4 | split==5 | split== 8 | split== 9

gen neg_poli = 0
recode neg_poli (0=1) if split==6 | split==7 | split==8 |split== 9


gen pos_culture_v_c = 0 if split==1
replace pos_culture_v_c =1 if split==2 | split==4 | split== 6 | split== 8

*Insert file path
gen pos_econ_v_c = 0  if split==1
replace pos_econ_v_c =1 if split==2 | split==3 | split== 6 | split== 7

gen pos_poli_v_c = 0
replace pos_poli_v_c =1 if split==2 | split==3 | split==4 |split== 5

gen neg_culture_v_c = 0 if split==1
replace neg_culture_v_c =1 if split==3 | split==5 | split== 7 | split== 9

gen neg_econ_v_c = 0  if split==1
replace neg_econ_v_c =1 if split==4 | split==5 | split== 8 | split== 9

gen neg_poli_v_c = 0 if split==1
replace neg_poli_v_c =1 if split==6 | split==7 | split==8 |split== 9



gen PC_PE_PP = 0 if split==1
recode PC_PE_PP (.=1) if split==2

gen AC_PE_PP = 0 if split==1
recode AC_PE_PP (.=1) if split==3

gen PC_AE_PP = 0 if split==1
recode PC_AE_PP (.=1) if split==4

gen AC_AE_PP = 0 if split==1
recode AC_AE_PP (.=1) if split==5

gen PC_PE_AP = 0 if split==1
recode PC_PE_AP (.=1) if split==6

gen AC_PE_AP = 0 if split==1
recode AC_PE_AP (.=1) if split==7

gen PC_AE_AP = 0 if split==1
recode PC_AE_AP (.=1) if split==8

gen AC_AE_AP = 0 if split==1
recode AC_AE_AP (.=1) if split==9

gen pro2 = 1 if (split > 1 & split < 5) | split == 6
recode pro2 (.=0)

gen anti2 = 1 if (split > 6 & split < 99) | split == 4
recode anti2 (.=0)

gen anti2vpro2 = 1 if (split > 1 & split < 5) | split == 6
replace anti2vpro2 = 0 if (split > 6 & split < 99) | split == 4

gen pro2_v_c = 0 if split==1
replace pro2_v_c =1 if (split > 1 & split < 5) | split == 6

gen anti2_v_c = 0 if split==1
replace anti2_v_c =1 if (split > 6 & split < 99) | split == 4


gen pro3 = 1 if split==2
recode pro3 (.=0) if split==1

gen pro2anti1 = 1 if split==3 | split==4 | split == 6
recode pro2anti1 (.=0) if split==1

gen pro1anti2 = 1 if split==5 | split==7 | split == 8
recode pro1anti2 (.=0) if split==1

gen anti3 = 1 if split==9
recode anti3 (.=0) if split==1



**Generate Moderates and extremists variables (nb. wave1q1 codebook: 1=0, 2=1, 3=2 .... 10=11, 11=12)
gen EUmoderate = 1 if wave1q1 > 3 & wave1q1 < 9
replace EUmoderate = 0 if wave1q1 <=3 | (wave1q1 >= 9 & wave1q1<=11)

gen EUmoderate_456 = 1 if wave1q1 > 4 & wave1q1 < 8
replace EUmoderate_456 = 0 if wave1q1 <=4 | (wave1q1 >= 8 & wave1q1<=12)

gen EUextremists = 1 if wave1q1 < 5 | wave1q1 > 7
replace EUextremists = 0 if wave1q1==5 | wave1q1==6 | wave1q1==7 | wave1q1>11

gen EUextremist_anti = 1 if wave1q1 < 5
replace EUextremist_anti = 0 if wave1q1 >=5

gen EUextremist_pro = 1 if wave1q1 > 7 & wave1q1 < 12
replace EUextremist_pro = 0 if wave1q1 <=7 | wave1q1>11


**Generate Length of time variables
gen wave2time = WAVE2endtime - WAVE2starttime



**Generate Dependent Variables
recode wave1q2 (1=0) (2=1) (3/99 = 0), into(leave1)
recode wave2q2 (1=0) (2=1) (3/99 = 0), into(leave2)
gen delta_leave = leave2 - leave1

recode wave1q2 (1=1)  (2/99 = 0), into(remain1)
recode wave2q2 (1=1) (2/99 = 0), into(remain2)
gen delta_remain = remain2 - remain1

recode wave1q2 (1/2=0) (3/99 = 1), into(dk1)
recode wave2q2 (1/2=0) (3/99 = 1), into(dk2)
gen delta_dk = dk2 - dk1

gen wave1q5 = (wave1q5a) if wave1q5a~=99
replace wave1q5 = -(wave1q5b) if wave1q5b~=99 & wave1q5b~=.

gen wave2q5 = (wave2q5a) if wave2q5a~=99
replace wave2q5 = -(wave2q5b) if wave2q5b~=99 & wave2q5b~=.

gen delta_EU = wave2q5 - wave1q5



***FIGURES IN THE MAIN BODY OF THE PAPER

*Figure 1. Difference-in-differences effects of the treatments
reg delta_remain PC_PE_PP
estimates store PC_PE_PP_coef
reg delta_remain AC_PE_PP
estimates store AC_PE_PP_coef
reg delta_remain PC_AE_PP
estimates store PC_AE_PP_coef
reg delta_remain PC_PE_AP
estimates store PC_PE_AP_coef
reg delta_remain AC_PE_AP
estimates store AC_PE_AP_coef
reg delta_remain PC_AE_AP
estimates store PC_AE_AP_coef
reg delta_remain AC_AE_PP
estimates store AC_AE_PP_coef
reg delta_remain AC_AE_AP
estimates store AC_AE_AP_coef
reg delta_leave PC_PE_PP
estimates store PC_PE_PP_coef_l
reg delta_leave AC_PE_PP
estimates store AC_PE_PP_coef_l
reg delta_leave PC_AE_PP
estimates store PC_AE_PP_coef_l
reg delta_leave PC_PE_AP
estimates store PC_PE_AP_coef_l
reg delta_leave AC_PE_AP
estimates store AC_PE_AP_coef_l
reg delta_leave PC_AE_AP
estimates store PC_AE_AP_coef_l
reg delta_leave AC_AE_PP
estimates store AC_AE_PP_coef_l
reg delta_leave AC_AE_AP
estimates store AC_AE_AP_coef_l

coefplot (PC_PE_PP_coef \ PC_PE_AP_coef \ AC_PE_PP_coef \ PC_AE_PP_coef \ AC_AE_PP_coef \ PC_AE_AP_coef \ AC_PE_AP_coef \ AC_AE_AP_coef), bylabel(Remain) ///
|| (PC_PE_PP_coef_l \ PC_PE_AP_coef_l \ AC_PE_PP_coef_l \ PC_AE_PP_coef_l \ AC_AE_PP_coef_l \ PC_AE_AP_coef_l \ AC_PE_AP_coef_l \ AC_AE_AP_coef_l), bylabel(Leave) ///
|| , drop(_cons) levels(90) xline(0) msymbol(d) mfcolor(white) legend(off) xlabel(-.08(.04).08)  ///
coeflabels(PC_PE_PP="Pro Cult, Pro Econ, Pro Poli" \ PC_PE_AP="Pro Cult, Pro Econ, Anti Poli" \ AC_PE_PP="Anti Cult, Pro Econ, Pro Poli" \ PC_AE_PP="Pro Cult, Anti Econ, Pro Poli" \  AC_AE_PP="Anti Cult, Anti Econ, Pro Poli" \  PC_AE_AP="Pro Cult, Anti Econ, Anti Poli" \  AC_PE_AP="Anti Cult, Pro Econ, Anti Poli" \  AC_AE_AP="Anti Cult, Anti Econ, Anti Poli")


*Figure 2. Difference-in-differences effects of the relative volume of arguments
reg delta_remain pro3
estimates store pro3_coef
reg delta_remain pro2anti1
estimates store pro2anti1_coef
reg delta_remain pro1anti2
estimates store pro1anti2_coef
reg delta_remain anti3
estimates store anti3_coef
reg delta_leave pro3
estimates store pro3_coef_l
reg delta_leave pro2anti1
estimates store pro2anti1_coef_l
reg delta_leave pro1anti2
estimates store pro1anti2_coef_l
reg delta_leave anti3
estimates store anti3_coef_l

coefplot (pro3_coef \ pro2anti1_coef \ pro1anti2_coef \ anti3_coef), bylabel(Remain) ///
|| (pro3_coef_l \ pro2anti1_coef_l \ pro1anti2_coef_l \ anti3_coef_l), bylabel(Leave) ///
|| , drop(_cons) levels(90) xline(0) msymbol(O) mcolor(black) mfcolor(black) ciopts(lwidth(medthick) lcolor(black)) legend(off) xlabel(-.08(.04).08) ///
coeflabels(pro3="3 Pro / 0 Anti" \ pro2anti1="2 Pro / 1 Anti" \ pro1anti2="1 Pro / 2 Anti" \ anti3="0 Pro / 3 Anti")


*Figure 3. Extremists and Moderates 
reg delta_remain pro3 if EUmoderate==1
estimates store pro3_coef_EU_mod
reg delta_remain pro2anti1 if EUmoderate==1
estimates store pro2anti1_coef_EU_mod
reg delta_remain pro1anti2 if EUmoderate==1
estimates store pro1anti2_coef_EU_mod
reg delta_remain anti3 if EUmoderate==1
estimates store anti3_coef_EU_mod
reg delta_leave pro3 if EUmoderate==1
estimates store pro3_coef_l_EU_mod
reg delta_leave pro2anti1 if EUmoderate==1
estimates store pro2anti1_coef_l_EU_mod
reg delta_leave pro1anti2 if EUmoderate==1
estimates store pro1anti2_coef_l_EU_mod
reg delta_leave anti3 if EUmoderate==1
estimates store anti3_coef_l_EU_mod
reg delta_dk pro3 if EUmoderate==1
estimates store pro3_coef_dk_EU_mod
reg delta_dk pro2anti1 if EUmoderate==1
estimates store pro2anti1_coef_dk_EU_mod
reg delta_dk pro1anti2 if EUmoderate==1
estimates store pro1anti2_coef_dk_EU_mod
reg delta_dk anti3 if EUmoderate==1
estimates store anti3_coef_dk_EU_mod
reg delta_remain pro3 if EUextremist_anti==1
estimates store pro3_coef_EUextrA
reg delta_remain pro2anti1 if EUextremist_anti==1
estimates store pro2anti1_coef_EUextrA
reg delta_remain pro1anti2 if EUextremist_anti==1
estimates store pro1anti2_coef_EUextrA
reg delta_remain anti3 if EUextremist_anti==1
estimates store anti3_coef_EUextrA
reg delta_leave pro3 if EUextremist_anti==1
estimates store pro3_coef_l_EUextrA
reg delta_leave pro2anti1 if EUextremist_anti==1
estimates store pro2anti1_coef_l_EUextrA
reg delta_leave pro1anti2 if EUextremist_anti==1
estimates store pro1anti2_coef_l_EUextrA
reg delta_leave anti3 if EUextremist_anti==1
estimates store anti3_coef_l_EUextrA
reg delta_dk pro3 if EUextremist_anti==1
estimates store pro3_coef_dk_EUextrA
reg delta_dk pro2anti1 if EUextremist_anti==1
estimates store pro2anti1_coef_dk_EUextrA
reg delta_dk pro1anti2 if EUextremist_anti==1
estimates store pro1anti2_coef_dk_EUextrA
reg delta_dk anti3 if EUextremist_anti==1
estimates store anti3_coef_dk_EUextrA
reg delta_remain pro3 if EUextremist_pro==1
estimates store pro3_coef_EUextrP
reg delta_remain pro2anti1 if EUextremist_pro==1
estimates store pro2anti1_coef_EUextrP
reg delta_remain pro1anti2 if EUextremist_pro==1
estimates store pro1anti2_coef_EUextrP
reg delta_remain anti3 if EUextremist_pro==1
estimates store anti3_coef_EUextrP
reg delta_leave pro3 if EUextremist_pro==1
estimates store pro3_coef_l_EUextrP
reg delta_leave pro2anti1 if EUextremist_pro==1
estimates store pro2anti1_coef_l_EUextrP
reg delta_leave pro1anti2 if EUextremist_pro==1
estimates store pro1anti2_coef_l_EUextrP
reg delta_leave anti3 if EUextremist_pro==1
estimates store anti3_coef_l_EUextrP
reg delta_dk pro3 if EUextremist_pro==1
estimates store pro3_coef_dk_EUextrP
reg delta_dk pro2anti1 if EUextremist_pro==1
estimates store pro2anti1_coef_dk_EUextrP
reg delta_dk pro1anti2 if EUextremist_pro==1
estimates store pro1anti2_coef_dk_EUextrP
reg delta_dk anti3 if EUextremist_pro==1
estimates store anti3_coef_dk_EUextrP

coefplot (pro3_coef_EU_mod \ pro2anti1_coef_EU_mod \ pro1anti2_coef_EU_mod \ anti3_coef_EU_mod, label(EU moderate)) (pro3_coef_EUextrA \ pro2anti1_coef_EUextrA \ pro1anti2_coef_EUextrA \ anti3_coef_EUextrA, label(Anti-EU extremist)) (pro3_coef_EUextrP \ pro2anti1_coef_EUextrP \ pro1anti2_coef_EUextrP \ anti3_coef_EUextrP, label(Pro-EU extremist)), bylabel(Remain) ///
|| (pro3_coef_dk_EU_mod \ pro2anti1_coef_dk_EU_mod \ pro1anti2_coef_dk_EU_mod \ anti3_coef_dk_EU_mod, label(EU moderate)) (pro3_coef_dk_EUextrA \ pro2anti1_coef_dk_EUextrA \ pro1anti2_coef_dk_EUextrA \ anti3_coef_dk_EUextrA, label(Anti-EU extremist)) (pro3_coef_dk_EUextrP \ pro2anti1_coef_dk_EUextrP \ pro1anti2_coef_dk_EUextrP \ anti3_coef_dk_EUextrP, label(Pro-EU extremist)), bylabel(Don't Know) ///
|| (pro3_coef_l_EU_mod \ pro2anti1_coef_l_EU_mod \ pro1anti2_coef_l_EU_mod \ anti3_coef_l_EU_mod, label(EU moderate)) (pro3_coef_l_EUextrA \ pro2anti1_coef_l_EUextrA \ pro1anti2_coef_l_EUextrA \ anti3_coef_l_EUextrA, label(Anti-EU extremist)) (pro3_coef_l_EUextrP \ pro2anti1_coef_l_EUextrP \ pro1anti2_coef_l_EUextrP \ anti3_coef_l_EUextrP, label(Pro-EU extremist)), bylabel(Leave) ///
|| , drop(_cons) levels(90) xline(0) msymbol(d) mfcolor(white) legend(off) xlabel(-.12(.06).12) byopts(rows(1)) legend(rows(1)) ///
coeflabels(pro3="3 Pro / 0 Anti" \ pro2anti1="2 Pro / 1 Anti" \ pro1anti2="1 Pro / 2 Anti" \ anti3="0 Pro / 3 Anti")


*Figure 4A. by party support
reg delta_remain pro3 if partyid_2015==1
estimates store pro3_coef_Con
reg delta_remain pro2anti1 if partyid_2015==1
estimates store pro2anti1_coef_Con
reg delta_remain pro1anti2 if partyid_2015==1
estimates store pro1anti2_coef_Con
reg delta_remain anti3 if partyid_2015==1
estimates store anti3_coef_Con
reg delta_leave pro3 if partyid_2015==1
estimates store pro3_coef_l_Con
reg delta_leave pro2anti1 if partyid_2015==1
estimates store pro2anti1_coef_l_Con
reg delta_leave pro1anti2 if partyid_2015==1
estimates store pro1anti2_coef_l_Con
reg delta_leave anti3 if partyid_2015==1
estimates store anti3_coef_l_Con
reg delta_dk pro3 if partyid_2015==1
estimates store pro3_coef_dk_Con
reg delta_dk pro2anti1 if partyid_2015==1
estimates store pro2anti1_coef_dk_Con
reg delta_dk pro1anti2 if partyid_2015==1
estimates store pro1anti2_coef_dk_Con
reg delta_dk anti3 if partyid_2015==1
estimates store anti3_coef_dk_Con
reg delta_remain pro3 if partyid_2015==2
estimates store pro3_coef_Lab
reg delta_remain pro2anti1 if partyid_2015==2
estimates store pro2anti1_coef_Lab
reg delta_remain pro1anti2 if partyid_2015==2
estimates store pro1anti2_coef_Lab
reg delta_remain anti3 if partyid_2015==2
estimates store anti3_coef_Lab
reg delta_leave pro3 if partyid_2015==2
estimates store pro3_coef_l_Lab
reg delta_leave pro2anti1 if partyid_2015==2
estimates store pro2anti1_coef_l_Lab
reg delta_leave pro1anti2 if partyid_2015==2
estimates store pro1anti2_coef_l_Lab
reg delta_leave anti3 if partyid_2015==2
estimates store anti3_coef_l_Lab
reg delta_dk pro3 if partyid_2015==2
estimates store pro3_coef_dk_Lab
reg delta_dk pro2anti1 if partyid_2015==2
estimates store pro2anti1_coef_dk_Lab
reg delta_dk pro1anti2 if partyid_2015==2
estimates store pro1anti2_coef_dk_Lab
reg delta_dk anti3 if partyid_2015==2
estimates store anti3_coef_dk_Lab

coefplot (pro3_coef_Con \ pro2anti1_coef_Con \ pro1anti2_coef_Con \ anti3_coef_Con, label(Conservatives)) (pro3_coef_Lab \ pro2anti1_coef_Lab \ pro1anti2_coef_Lab \ anti3_coef_Lab, label(Labour)), bylabel(Remain) ///
|| (pro3_coef_dk_Con \ pro2anti1_coef_dk_Con \ pro1anti2_coef_dk_Con \ anti3_coef_dk_Con, label(Conservatives)) (pro3_coef_dk_Lab \ pro2anti1_coef_dk_Lab \ pro1anti2_coef_dk_Lab \ anti3_coef_dk_Lab, label(Labour)), bylabel(Don't Know) ///
|| (pro3_coef_l_Con \ pro2anti1_coef_l_Con \ pro1anti2_coef_l_Con \ anti3_coef_l_Con, label(Conservatives)) (pro3_coef_l_Lab \ pro2anti1_coef_l_Lab \ pro1anti2_coef_l_Lab \ anti3_coef_l_Lab, label(Labour)), bylabel(Leave) ///
|| , drop(_cons) levels(90) xline(0) msymbol(d) mfcolor(white) legend(off) xlabel(-.12(.06).12) byopts(rows(1)) ///
coeflabels(pro3="3 Pro / 0 Anti" \ pro2anti1="2 Pro / 1 Anti" \ pro1anti2="1 Pro / 2 Anti" \ anti3="0 Pro / 3 Anti")


*Figure 4B. by age finished education
recode profile_education_age 1=1 2=1 3=2 4=2 5=3 6=., generate(education_recoded)

reg delta_remain pro3 if education_recoded==1
estimates store pro3_coef_eduless17
reg delta_remain pro2anti1 if education_recoded==1
estimates store pro2anti1_coef_eduless17
reg delta_remain pro1anti2 if education_recoded==1
estimates store pro1anti2_coef_eduless17
reg delta_remain anti3 if education_recoded==1
estimates store anti3_coef_eduless17
reg delta_leave pro3 if education_recoded==1
estimates store pro3_coef_l_eduless17
reg delta_leave pro2anti1 if education_recoded==1
estimates store pro2anti1_coef_l_eduless17
reg delta_leave pro1anti2 if education_recoded==1
estimates store pro1anti2_coef_l_eduless17
reg delta_leave anti3 if education_recoded==1
estimates store anti3_coef_l_eduless17
reg delta_dk pro3 if education_recoded==1
estimates store pro3_coef_dk_eduless17
reg delta_dk pro2anti1 if education_recoded==1
estimates store pro2anti1_coef_dk_eduless17
reg delta_dk pro1anti2 if education_recoded==1
estimates store pro1anti2_coef_dk_eduless17
reg delta_dk anti3 if education_recoded==1
estimates store anti3_coef_dk_eduless17
reg delta_remain pro3 if education_recoded==2
estimates store pro3_coef_Edu1719
reg delta_remain pro2anti1 if education_recoded==2
estimates store pro2anti1_coef_Edu1719
reg delta_remain pro1anti2 if education_recoded==2
estimates store pro1anti2_coef_Edu1719
reg delta_remain anti3 if education_recoded==2
estimates store anti3_coef_Edu1719
reg delta_leave pro3 if education_recoded==2
estimates store pro3_coef_l_Edu1719
reg delta_leave pro2anti1 if education_recoded==2
estimates store pro2anti1_coef_l_Edu1719
reg delta_leave pro1anti2 if education_recoded==2
estimates store pro1anti2_coef_l_Edu1719
reg delta_leave anti3 if education_recoded==2
estimates store anti3_coef_l_Edu1719
reg delta_dk pro3 if education_recoded==2
estimates store pro3_coef_dk_Edu1719
reg delta_dk pro2anti1 if education_recoded==2
estimates store pro2anti1_coef_dk_Edu1719
reg delta_dk pro1anti2 if education_recoded==2
estimates store pro1anti2_coef_dk_Edu1719
reg delta_dk anti3 if education_recoded==2
estimates store anti3_coef_dk_Edu1719
reg delta_remain pro3 if education_recoded==3
estimates store pro3_coef_Edu20plus
reg delta_remain pro2anti1 if education_recoded==3
estimates store pro2anti1_coef_Edu20plus
reg delta_remain pro1anti2 if education_recoded==3
estimates store pro1anti2_coef_Edu20plus
reg delta_remain anti3 if education_recoded==3
estimates store anti3_coef_Edu20plus
reg delta_leave pro3 if education_recoded==3
estimates store pro3_coef_l_Edu20plus
reg delta_leave pro2anti1 if education_recoded==3
estimates store pro2anti1_coef_l_Edu20plus
reg delta_leave pro1anti2 if education_recoded==3
estimates store pro1anti2_coef_l_Edu20plus
reg delta_leave anti3 if education_recoded==3
estimates store anti3_coef_l_Edu20plus
reg delta_dk pro3 if education_recoded==3
estimates store pro3_coef_dk_Edu20plus
reg delta_dk pro2anti1 if education_recoded==3
estimates store pro2anti1_coef_dk_Edu20plus
reg delta_dk pro1anti2 if education_recoded==3
estimates store pro1anti2_coef_dk_Edu20plus
reg delta_dk anti3 if education_recoded==3
estimates store anti3_coef_dk_Edu20plus

coefplot (pro3_coef_eduless17 \ pro2anti1_coef_eduless17 \ pro1anti2_coef_eduless17 \ anti3_coef_eduless17, label(<17)) (pro3_coef_Edu1719 \ pro2anti1_coef_Edu1719 \ pro1anti2_coef_Edu1719 \ anti3_coef_Edu1719, label(17-19)) (pro3_coef_Edu20plus \ pro2anti1_coef_Edu20plus \ pro1anti2_coef_Edu20plus \ anti3_coef_Edu20plus, label(20+)), bylabel(Remain) ///
|| (pro3_coef_dk_eduless17 \ pro2anti1_coef_dk_eduless17 \ pro1anti2_coef_dk_eduless17 \ anti3_coef_dk_eduless17, label(<17)) (pro3_coef_dk_Edu1719 \ pro2anti1_coef_dk_Edu1719 \ pro1anti2_coef_dk_Edu1719 \ anti3_coef_dk_Edu1719, label(17-19)) (pro3_coef_dk_Edu20plus \ pro2anti1_coef_dk_Edu20plus \ pro1anti2_coef_dk_Edu20plus \ anti3_coef_dk_Edu20plus, label(20+)), bylabel(Don't Know) ///
|| (pro3_coef_l_eduless17 \ pro2anti1_coef_l_eduless17 \ pro1anti2_coef_l_eduless17 \ anti3_coef_l_eduless17, label(<17)) (pro3_coef_l_Edu1719 \ pro2anti1_coef_l_Edu1719 \ pro1anti2_coef_l_Edu1719 \ anti3_coef_l_Edu1719, label(17-19)) (pro3_coef_l_Edu20plus \ pro2anti1_coef_l_Edu20plus \ pro1anti2_coef_l_Edu20plus \ anti3_coef_l_Edu20plus, label(20+)), bylabel(Leave) ///
|| , drop(_cons) levels(90) xline(0) msymbol(d) mfcolor(white) legend(off) xlabel(-.12(.06).12) byopts(rows(1)) legend(rows(1)) ///
coeflabels(pro3="3 Pro / 0 Anti" \ pro2anti1="2 Pro / 1 Anti" \ pro1anti2="1 Pro / 2 Anti" \ anti3="0 Pro / 3 Anti")



**APPENDIX


**Wave 1 descriptives 

*Insert file paths
save "C:\...\Vignette data recode.dta"
use "C:\...\Wave 1 data.dta", clear

*Table A1
tab Bpcas2

*Table A2
tab Socgrade4_W8

*Table A3
tab Partyid_2010

*Table A4
tab Newgor_W8

*Table A5
tab Profile_Newspaper_Readership_201

*Insert file path
use "C:\...\Vignette data recode.dta", clear

**Vote Descriptives
tab wave1q2
tab wave2q2

**Table A6
tab PC_PE_PP 
tab AC_PE_PP 
tab PC_AE_PP 
tab AC_AE_PP 
tab PC_PE_AP 
tab AC_PE_AP 
tab PC_AE_AP 
tab AC_AE_AP

**Transition Probabilities
recode wave1q2 (99=3), into(wave1q2_rc)

recode wave2q2 (99=3), into(wave2q2_rc)


*Table A7: Balance test

reg leave1 i.split 
forvalues i=1/9 {
mean leave1 if split==`i'
}
reg remain1 i.split 
forvalues i=1/9 {
mean remain1 if split==`i'
}

reg partyid_2015 i.split 
forvalues i=1/9 {
mean partyid_2015 if split==`i'
}
reg age i.split 
forvalues i=1/9 {
mean age if split==`i'
}
reg profile_education_age i.split 
forvalues i=1/9 {
mean profile_education_age if split==`i'
}
reg profile_ethnicity i.split 
forvalues i=1/9 {
mean profile_ethnicity if split==`i'
}
reg profile_gender i.split 
forvalues i=1/9 {
mean profile_gender if split==`i'
}

reg socgrade4 i.split 
forvalues i=1/9 {
mean socgrade4 if split==`i'
}
reg newgor i.split 
forvalues i=1/9 {
mean newgor if split==`i'
}

***

**Figure A1: Flows from Wave 1 to Wave 2 for control and two treatment groups
**Table A8. Flows from Wave 1 to Wave 2 for control and two treatment groups
** -> See "Replication of Flows figure and table" folder

**Table A9. Determinants of support for leaving the EU in May 2015

*Insert file paths
save "C:\...\Vignette data recode.dta"
use "C:\...\BES data analysis_Jan2016.dta", clear
logit eurefvote_recode top_issue_immig top_issue_economy vote_con vote_lab age_less25 age_26to35 age_36to45 age_46to55 age_56to65 educ_bef17 educ_1719 income_less20k income_2040k income_4060k income_60100k london north midlands_eastern south wales if educ_still==0 [pweight = weight]



**Tables for Figures in the manuscript

*Insert file path
use "C:\...\Vignette data recode.dta", clear


*Table A10. Difference-in-differences effects of the treatments (Figure 1)
reg delta_remain PC_PE_PP
reg delta_remain PC_PE_AP
reg delta_remain AC_PE_PP
reg delta_remain PC_AE_PP
reg delta_remain AC_AE_PP
reg delta_remain PC_AE_AP
reg delta_remain AC_PE_AP
reg delta_remain AC_AE_AP

reg delta_leave PC_PE_PP
reg delta_leave PC_PE_AP
reg delta_leave AC_PE_PP
reg delta_leave PC_AE_PP
reg delta_leave AC_AE_PP
reg delta_leave PC_AE_AP
reg delta_leave AC_PE_AP
reg delta_leave AC_AE_AP

reg delta_dk PC_PE_PP
reg delta_dk PC_PE_AP
reg delta_dk AC_PE_PP
reg delta_dk PC_AE_PP
reg delta_dk AC_AE_PP
reg delta_dk PC_AE_AP
reg delta_dk AC_PE_AP
reg delta_dk AC_AE_AP

*Table A11. Difference-in-differences effects of the relative volume of arguments (Figure 2)
reg delta_remain pro3
reg delta_remain pro2anti1
reg delta_remain pro1anti2
reg delta_remain anti3

reg delta_leave pro3
reg delta_leave pro2anti1
reg delta_leave pro1anti2
reg delta_leave anti3

reg delta_dk pro3
reg delta_dk pro2anti1
reg delta_dk pro1anti2
reg delta_dk anti3

*Table A13. Difference-in-differences effects of the relative volume of arguments, by EU position (Figure 4)

reg delta_remain pro3 if EUmoderate==1
reg delta_remain pro2anti1 if EUmoderate==1
reg delta_remain pro1anti2 if EUmoderate==1
reg delta_remain anti3 if EUmoderate==1

reg delta_leave pro3 if EUmoderate==1
reg delta_leave pro2anti1 if EUmoderate==1
reg delta_leave pro1anti2 if EUmoderate==1
reg delta_leave anti3 if EUmoderate==1

reg delta_dk pro3 if EUmoderate==1
reg delta_dk pro2anti1 if EUmoderate==1
reg delta_dk pro1anti2 if EUmoderate==1
reg delta_dk anti3 if EUmoderate==1

reg delta_remain pro3 if EUextremist_anti==1
reg delta_remain pro2anti1 if EUextremist_anti==1
reg delta_remain pro1anti2 if EUextremist_anti==1
reg delta_remain anti3 if EUextremist_anti==1

reg delta_leave pro3 if EUextremist_anti==1
reg delta_leave pro2anti1 if EUextremist_anti==1
reg delta_leave pro1anti2 if EUextremist_anti==1
reg delta_leave anti3 if EUextremist_anti==1

reg delta_dk pro3 if EUextremist_anti==1
reg delta_dk pro2anti1 if EUextremist_anti==1
reg delta_dk pro1anti2 if EUextremist_anti==1
reg delta_dk anti3 if EUextremist_anti==1

reg delta_remain pro3 if EUextremist_pro==1
reg delta_remain pro2anti1 if EUextremist_pro==1
reg delta_remain pro1anti2 if EUextremist_pro==1
reg delta_remain anti3 if EUextremist_pro==1

reg delta_leave pro3 if EUextremist_pro==1
reg delta_leave pro2anti1 if EUextremist_pro==1
reg delta_leave pro1anti2 if EUextremist_pro==1
reg delta_leave anti3 if EUextremist_pro==1

reg delta_dk pro3 if EUextremist_pro==1
reg delta_dk pro2anti1 if EUextremist_pro==1
reg delta_dk pro1anti2 if EUextremist_pro==1
reg delta_dk anti3 if EUextremist_pro==1


*Table A13. Difference-in-differences effects of the relative volume of arguments, by subgroup (Figure 4)
*A. by party support
reg delta_remain pro3 if partyid_2015==1
reg delta_remain pro2anti1 if partyid_2015==1
reg delta_remain pro1anti2 if partyid_2015==1
reg delta_remain anti3 if partyid_2015==1

reg delta_leave pro3 if partyid_2015==1
reg delta_leave pro2anti1 if partyid_2015==1
reg delta_leave pro1anti2 if partyid_2015==1
reg delta_leave anti3 if partyid_2015==1

reg delta_dk pro3 if partyid_2015==1
reg delta_dk pro2anti1 if partyid_2015==1
reg delta_dk pro1anti2 if partyid_2015==1
reg delta_dk anti3 if partyid_2015==1

reg delta_remain pro3 if partyid_2015==2
reg delta_remain pro2anti1 if partyid_2015==2
reg delta_remain pro1anti2 if partyid_2015==2
reg delta_remain anti3 if partyid_2015==2

reg delta_leave pro3 if partyid_2015==2
reg delta_leave pro2anti1 if partyid_2015==2
reg delta_leave pro1anti2 if partyid_2015==2
reg delta_leave anti3 if partyid_2015==2

reg delta_dk pro3 if partyid_2015==2
reg delta_dk pro2anti1 if partyid_2015==2
reg delta_dk pro1anti2 if partyid_2015==2
reg delta_dk anti3 if partyid_2015==2

*B. by age finished education
reg delta_remain pro3 if education_recoded==1
reg delta_remain pro2anti1 if education_recoded==1
reg delta_remain pro1anti2 if education_recoded==1
reg delta_remain anti3 if education_recoded==1

reg delta_leave pro3 if education_recoded==1
reg delta_leave pro2anti1 if education_recoded==1
reg delta_leave pro1anti2 if education_recoded==1
reg delta_leave anti3 if education_recoded==1

reg delta_dk pro3 if education_recoded==1
reg delta_dk pro2anti1 if education_recoded==1
reg delta_dk pro1anti2 if education_recoded==1
reg delta_dk anti3 if education_recoded==1

reg delta_remain pro3 if education_recoded==2
reg delta_remain pro2anti1 if education_recoded==2
reg delta_remain pro1anti2 if education_recoded==2
reg delta_remain anti3 if education_recoded==2

reg delta_leave pro3 if education_recoded==2
reg delta_leave pro2anti1 if education_recoded==2
reg delta_leave pro1anti2 if education_recoded==2
reg delta_leave anti3 if education_recoded==2

reg delta_dk pro3 if education_recoded==2
reg delta_dk pro2anti1 if education_recoded==2
reg delta_dk pro1anti2 if education_recoded==2
reg delta_dk anti3 if education_recoded==2

reg delta_remain pro3 if education_recoded==3
reg delta_remain pro2anti1 if education_recoded==3
reg delta_remain pro1anti2 if education_recoded==3
reg delta_remain anti3 if education_recoded==3

reg delta_leave pro3 if education_recoded==3
reg delta_leave pro2anti1 if education_recoded==3
reg delta_leave pro1anti2 if education_recoded==3
reg delta_leave anti3 if education_recoded==3

reg delta_dk pro3 if education_recoded==3
reg delta_dk pro2anti1 if education_recoded==3
reg delta_dk pro1anti2 if education_recoded==3
reg delta_dk anti3 if education_recoded==3

*Insert file path
save "C:\...\Vignette data recode.dta", replace


**Additional Analyses

*Table A14. Additional difference-in-differences effects sub-group analysis 
*A. by social grade
*Diff in Diff Effects, Social Grade ABC1

*Insert file path
save "C:\...\Vignette data Social Grade ABC1.dta"
keep if new_socgrade==1

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*Diff in Diff Effects, Social Grade C2DE

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Social Grade C2DE.dta"
keep if new_socgrade==2

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*B. by age group, part 1 (18-24 and 25-39)
*Diff in Diff Effects, Age 18-24

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Age 18-24.dta"
keep if wellsage==1

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*Diff in Diff Effects, Age 25-39

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Age 25-39.dta" 

keep if wellsage==2

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)

*B. by age group, part 2 (40-59 and 60+)
*Diff in Diff Effects, Age 40-59

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Age 40-59.dta" 

keep if wellsage==3

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*Diff in Diff Effects, Age 60+

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Age 60+.dta" 

keep if wellsage==4

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*C. by English region, part 1 (London and Southern)
*recode region variable
recode newgor 1=1 2=2 3=2 4=3 5=4 6=5 7=6, generate(region_recoded)


*Diff in Diff Effects, Region-London

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Region-London.dta"
keep if region_recoded==3

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*Diff in Diff Effects, Region-South

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Region-South.dta"
keep if region_recoded==4

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*C. by English region, part 2 (Midlands & Eastern and Northern)

*Diff in Diff Effects, Region-North

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Region-North.dta"
keep if region_recoded==1

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)


*Diff in Diff Effects, Region-Midlands&East

*Insert file paths
use "C:\...\Vignette data recode.dta", clear
save "C:\...\Vignette data Region-Midlands&East.dta"
keep if region_recoded==2

reg delta_leave PC_PE_PP
reg delta_remain PC_PE_PP
reg delta_dk PC_PE_PP
reg delta_EU PC_PE_PP

reg delta_leave AC_PE_PP
reg delta_remain AC_PE_PP
reg delta_dk AC_PE_PP
reg delta_EU AC_PE_PP

reg delta_leave PC_AE_PP
reg delta_remain PC_AE_PP
reg delta_dk PC_AE_PP
reg delta_EU PC_AE_PP

reg delta_leave PC_PE_AP
reg delta_remain PC_PE_AP
reg delta_dk PC_PE_AP
reg delta_EU PC_PE_AP

reg delta_leave AC_PE_AP
reg delta_remain AC_PE_AP
reg delta_dk AC_PE_AP
reg delta_EU AC_PE_AP

reg delta_leave PC_AE_AP
reg delta_remain PC_AE_AP
reg delta_dk PC_AE_AP
reg delta_EU PC_AE_AP

reg delta_leave AC_AE_PP
reg delta_remain AC_AE_PP
reg delta_dk AC_AE_PP
reg delta_EU AC_AE_PP

reg delta_leave AC_AE_AP
reg delta_remain AC_AE_AP
reg delta_dk AC_AE_AP
reg delta_EU AC_AE_AP

*Marginals
tab split, sum(remain1)
tab split, sum(remain2)

tab split, sum(leave1)
tab split, sum(leave2)

tab split, sum(dk1)
tab split, sum(dk2)



















