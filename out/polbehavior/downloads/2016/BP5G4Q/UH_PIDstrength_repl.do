clear all

use  "UH_PIDstrength.dta"

*PID
gen PID = pid
recode PID 1=2 2=6 3/4=4
recode PID 2=1 if pidd==1
recode PID 6=7 if pidr==1
recode PID 4=3 if pidi==1
recode PID 4=5 if pidi==2

*Partisan strength and ideological extremity
gen PIDext = abs(PID - 4)
gen IdeoExt = abs(ideo - 4)

*Demos
gen Male = gender 
recode Male 2=0
gen Hisp = hisp
recode Hisp 4=0 5/11=1
gen Black = 0
recode Black 0=1 if race_20==1
gen Attend = attend
recode Attend 9=1 8=2 7=3 6=4 5=5 4=6
gen Foreign = foreign
recode Foreign 1=0 2=1


*MFQ*
gen CareF = (mfq_jdg1_1 + mfq_jdg1_7 + mfq_jdg2_4 + mfq_rel1_1 + mfq_rel1_7 + mfq_rel2_4 - 6)/30
gen FairF = (mfq_jdg1_2 + mfq_jdg1_8 + mfq_jdg2_5 + mfq_rel1_2 + mfq_rel1_8 + mfq_rel2_5 - 6)/30
gen LoyaF = (mfq_jdg1_3 + mfq_jdg2_1 + mfq_jdg2_6 + mfq_rel1_3 + mfq_rel2_1 + mfq_rel2_6 - 6)/30
gen AuthF = (mfq_jdg1_4 + mfq_jdg2_2 + mfq_jdg2_7 + mfq_rel1_4 + mfq_rel2_2 + mfq_rel2_7 - 6)/30
gen PureF = (mfq_jdg1_5 + mfq_jdg2_3 + mfq_jdg2_8 + mfq_rel1_5 + mfq_rel2_3 + mfq_rel2_8 - 6)/30


*MFVs*
forval x=22/31 {
	recode mfv1_`x' 4=1 5=2 6=3 7=4 9=5
	}
forval x=32/41 {
	recode mfv2_`x' 4=1 5=2 6=3 7=4 8=5
	}
	forval x=42/51 {
	recode mfv3_`x' 4=1 5=2 6=3 7=4 8=5
	}
	forval x=52/61 {
	recode mfv4_`x' 4=1 5=2 6=3 7=4 8=5
	}
gen MFVcare = (mfv1_25 + mfv1_26 + mfv1_27 + mfv1_31 + mfv2_33 + mfv2_38 + mfv2_39 + mfv2_41 + mfv4_52 - 9)/36
gen MFVfair = (mfv2_40 + mfv3_42 + mfv3_44 + mfv3_49 + mfv4_55 - 5)/20 
gen MFVloya = (mfv1_22 + mfv3_43 + mfv3_46 + mfv3_50 + mfv3_51 - 5)/20
gen MFVauth = (mfv1_29 + mfv1_30 + mfv2_36 + mfv3_48 + mfv4_57 - 5)/20
gen MFVsanc = (mfv2_32 + mfv3_47 + mfv4_54 + mfv4_58 + mfv4_60 - 5)/20


***********
* Results *
***********

*Table A4
sum PIDext CareF FairF AuthF LoyaF PureF MFVcare MFVfair MFVauth MFVloya MFVsanc
pwcorr PIDext CareF FairF AuthF LoyaF PureF MFVcare MFVfair MFVauth MFVloya MFVsanc, obs sig

*Table 3
ologit PIDext CareF FairF LoyaF AuthF PureF ideo IdeoExt Attend Male Black Hisp Foreign
est store m1
ologit PIDext MFVcare MFVfair MFVloya MFVauth MFVsanc ideo IdeoExt Attend Male Black Hisp Foreign
est store m2
estout m1, cells(b(star fmt(2)) se) stats(N r2)
estout m2, cells(b(star fmt(2)) se) stats(N r2)

