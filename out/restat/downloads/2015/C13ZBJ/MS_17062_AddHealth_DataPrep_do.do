clear all
***A directory must be assigned
cd "Add_health_files_directory" 

*Preparing Add Health Wave 1 Data for analysis
use W1_in_home_interview, clear
sort AID, stable
save W1_in_home_interview_1, replace

*Preparing Add Health Wave 4 Data for analysis
use W4_all, clear
sort AID, stable
save W4_all_1, replace

*Preparing Add Health Wave 4 Constructed Variables for analysis
use W4_constructed, clear
sort AID, stable
save W4_constructed_1, replace


*Merging the Add Health data files for data creation
use W1_in_home_interview_1, clear
merge AID, using W4_all_1
*keep if _merge==3
drop _merge
sort AID, stable
merge AID, using W4_constructed_1
ta _merge 
keep if _merge==3


drop _merge
destring AID, replace
sort AID, stable

*Keeping the variables used in the analysis. 
keep  BIO_SEX4 IYEAR4 IMONTH4 IDAY4 IMONTH IDAY IYEAR H1GI1M H1GI1Y H1GI1M  H1GI1Y H4IR4 H4OD1M H4OD1Y H4IR4 H1GI4 H4ED2 C4VAR039 H4MI1 H4MI6A H4MI6B H4MI6A H4MI3 H4MI2 H4MI11Y H4MI11M /* 
     */ H4MI12Y H4MI12M H4MI4A H4MI4D H4MI4B H4MI4C H4MI6C H4SE1 H4RE1 H4ID5I H4MA3 H4HS1  AH_PVT H4MI8M H4MI8Y PA10 PA55 H1RM1 H4MI13 H4LM18 H4MI14 H4MI15 H4MI16A H4MI16C H4MI16B /*
	 */ H4MI10 H4MI8Y H4MI9M H4MI9Y H4MI8Y H4MI8Y H4TO1 H4TO6 H4TO33 H4TO40  H4TO65B H4TO71 H1DS5 H4MI9M H4MI9Y H4RD23 H4RD24 H4RD22 SCID H4RD8 H4RD14 H4TO99 C4VAR001 H1GH60 H1GH59A /*
	 */ H1GH59B H4WS1 H4MI10 H4TR10 H1RR1 H4RD7G H4RD7D
	 
gen male=0
replace male=1 if BIO_SEX4==1

ta BIO_SEX4
label var male "Male"
sum male
ta male


ta IYEAR4
ta H4OD1Y

* AGE
gen W1_intvdate=mdy(IMONTH,IDAY ,IYEAR+1900)

sum W1_intvdate

ta H1GI1M 
replace H1GI1M=. if H1GI1M>12

ta H1GI1Y 
replace H1GI1Y=. if H1GI1Y==96
ta H1GI1Y  

gen W1_birthday=mdy(H1GI1M,15, H1GI1Y+1900)

sum W1_birthday
generate agew1 =int((W1_intvdate-W1_birthday) / 365.25) 
ta agew1


gen intvdate=mdy(IMONTH4,IDAY4 ,IYEAR4)

sum intvdate
ta H4OD1M
ta H4OD1Y
gen birthday=mdy(H4OD1M,15,H4OD1Y)

sum birthday
generate ageiny=int((intvdate-birthday) / 365.25) 

label var ageiny "Age in Years"

gen ageiny2=ageiny*ageiny
label var ageiny2 "Age in Years Squared"


*************************
*H4IR4: race of the respondent
ta H4IR4
gen rwhite=0 if H4IR4~=. 
replace rwhite=1 if H4IR4==1
sum rwhite
label var rwhite "Race: White"

gen rblack=0 if H4IR4~=.  
replace rblack=1 if H4IR4==2
sum rblack
label var rblack "Race: Black"

gen rother=0 if H4IR4~=.  
replace rother=1 if H4IR4==3
replace rother=1 if H4IR4==4

gen mis_race=0
replace mis_race=1 if H4IR4==.

label var rother "Race: Other"

sum rwhite rblack rother mis_race
label var mis_race "Missing Data: Race"

ta H1GI4

gen hispanic=0 if H1GI4~=.
replace hispanic=1 if H1GI4==1
label var hispanic "Race: Hispanic"

gen mis_hispanic=0
replace mis_hispanic=1 if H1GI4==6| H1GI4==8
label var mis_hispanic "Missing Data: Race - Hispanic"

sum rwhite rblack rother hispanic mis_race mis_hispanic



***********************
gen     educ_scv=0 if H4ED2~=.
replace educ_scv=1 if H4ED2==4
replace educ_scv=1 if H4ED2==5
replace educ_scv=1 if H4ED2==6
label var educ_scv "Education: Some College "

gen     educ_cd=0  if H4ED2~=.
replace educ_cd=1 if H4ED2==7
replace educ_cd=1 if H4ED2==8
replace educ_cd=1 if H4ED2==12
replace educ_cd=1 if H4ED2==9
replace educ_cd=1 if H4ED2==10
replace educ_cd=1 if H4ED2==11
replace educ_cd=1 if H4ED2==13
label var educ_cd "Education: College"

gen mis_educ=0 
replace mis_educ=1 if H4ED2==.

label var mis_educ "Missing Data: Education"

*** Occupation
encode H4LM18, gen(occupation)
ta occupation
replace occupation=900 if occupation==714
replace occupation=900 if occupation==715
replace occupation=900 if occupation==716
replace occupation=900 if occupation==717
replace occupation=900 if occupation==.

tab occupation, gen(od)

gen ocp1=0
replace ocp1=1 if occupation>=1 & occupation<=32

gen ocp2=0
replace ocp2=1 if occupation>=33 & occupation<=62

gen ocp3=0
replace ocp3=1 if occupation>=63 & occupation<=77

gen ocp4=0
replace ocp4=1 if occupation>=78 & occupation<=107

gen ocp5=0
replace ocp5=1 if occupation>=108 & occupation<=140

gen ocp6=0
replace ocp6=1 if occupation>=141 & occupation<=157

gen ocp7=0
replace ocp7=1 if occupation>=158 & occupation<=164

gen ocp8=0
replace ocp8=1 if occupation>=165 & occupation<=213

gen ocp9=0
replace ocp9=1 if occupation>=214 & occupation<=251

gen ocp10=0
replace ocp10=1 if occupation>=252 & occupation<=297

gen ocp11=0
replace ocp11=1 if occupation>=298 & occupation<=312

gen ocp12=0
replace ocp12=1 if occupation>=313 & occupation<=332

gen ocp13=0
replace ocp13=1 if occupation>=333 & occupation<=351

gen ocp14=0
replace ocp14=1 if occupation>=352 & occupation<=361

gen ocp15=0
replace ocp15=1 if occupation>=362 & occupation<=384

gen ocp16=0
replace ocp16=1 if occupation>=385 & occupation<=405

gen ocp17=0
replace ocp17=1 if occupation>=406 & occupation<=458

gen ocp18=0
replace ocp18=1 if occupation>=459 & occupation<=471

gen ocp19=0
replace ocp19=1 if occupation>=472 & occupation<=526

gen ocp20=0
replace ocp20=1 if occupation>=527 & occupation<=568


gen ocp21=0
replace ocp21=1 if occupation>=569 & occupation<=661


gen ocp22=0
replace ocp22=1 if occupation>=662 & occupation<=700

gen ocp23=0
replace ocp23=1 if occupation>=714 & occupation<=717

gen ocp_mis=0
replace ocp_mis=1 if occupation==.

global acc_dummies " od701 od702 od703 od704 od705 od706 od707 od708 od709 od710 od711 od712 od713 ocp*"
**********************

*****Military membership
ta H4MI1
gen mil_ever=0 if H4MI1~=.
replace mil_ever=1 if H4MI1==1
label var mil_ever "Ever Been in Military"
ta mil_ever
sum mil_ever if mil_ever==1
 
************
ta H4MI6A
gen mil_nad=0
replace mil_nad=1 if H4MI6A==0
drop if H4MI6A==8
label var mil_nad "Served Exclusively in the Reserves"
ta H4MI6A

ta H4MI6B
gen mil_reserves=0 
replace mil_reserves=1 if H4MI6B==1
label var mil_reserves "Served in the Reserves"

replace H4MI6A=. if H4MI6A>7
gen mil_active=0 if H4MI6A~=.
replace mil_active=1 if H4MI6A==1
label var mil_active "Served in Active Duty"
 
*******************
ta BIO_SEX4
ta male
sum mil_ever if male==1
sum mil_ever if male==0

******Current Military Service
ta H4MI3
gen mil_current=0 if H4MI3~=.
replace mil_current=1 if H4MI3==1
label var mil_current "Military Service: Currently in the Military"
ta mil_current

**********************************

ta H4MI2
gen mil_us=0 
replace mil_us=1 if H4MI2==1 & mil_ever==1
label var mil_us "Military: Service Only in the United States"
ta mil_us

gen mil_abroad_us=0 
replace mil_abroad_us=1 if H4MI2==2 & mil_ever==1
replace mil_abroad_us=1 if H4MI2==3 & mil_ever==1
ta mil_abroad_us

label var mil_abroad_us "Military: Service Both in the United States and Outside"

****************
*****
d H4MI11Y
ta H4MI11Y

replace H4MI11Y=. if H4MI11Y>13

d H4MI11M
ta H4MI11M

replace H4MI11M=. if H4MI11M>11

gen mil_mnths=(H4MI11Y*12)+H4MI11M
sum mil_mnths
ta mil_mnths
label var mil_mnths "Months Served in the Military"

gen mis_mil_mnths=0 if mil_ever==1
replace mis_mil_mnths=1 if mil_ever==1 & mil_mnths==.
label var mis_mil_mnths "Missing Data: Months Served in the Military"


gen mil_mnths1=0 if mil_ever==1
replace mil_mnths1=1 if mil_mnths<12
label var mil_mnths1 "Military Service: Less Than a Year"


gen mil_mnths2=0 if mil_ever==1
replace mil_mnths2=1 if mil_mnths>=12 & mil_mnths<=36
label var mil_mnths2 "Military Service: 1 to 3 Years"

gen mil_mnths3=0 if mil_ever==1
replace mil_mnths3=1 if mil_mnths>=37 & mil_mnths<=60
label var mil_mnths3 "Military Service: 4 to 5 Years"

gen mil_mnths4=0 if mil_ever==1
replace mil_mnths4=1 if mil_mnths>=61
label var mil_mnths4 "Military Service: Longer than 5 Years"

sum mil_mnths1 mil_mnths2 mil_mnths3 mil_mnths4 mil_nad if mil_ever==1

**********
ta H4MI12Y
gen mil_combat=0
replace mil_combat=1 if H4MI12Y>0 & H4MI12Y<97 
replace mil_combat=1 if H4MI12M>0 & H4MI12M<97 
label var mil_combat "Combat Service"

************
**************************************************************************************************
ta H4MI4A
sum H4MI4A
replace H4MI4A=. if H4MI4A>7

sum H4MI4A if H4MI4A==8
gen mil_army=0 if H4MI4A~=.
replace mil_army=1 if H4MI4A==1
label var mil_army "Served in the Army"
ta H4MI4A
ta mil_army


sum H4MI4D
ta H4MI4D
replace H4MI4D=. if H4MI4D>7
sum H4MI4D if H4MI4D==8
sum H4MI4D if H4MI4D==7

gen mil_navy=0 if H4MI4D~=. 
replace mil_navy=1 if H4MI4D==1
label var mil_navy "Served in the Navy"
ta H4MI4D
ta mil_navy

sum H4MI4B
sum H4MI4B if H4MI4B==8
replace H4MI4B=. if H4MI4B>7

gen mil_airf=0 if H4MI4B~=.
replace mil_airf=1 if H4MI4B==1
label var mil_airf "Served in the Air Force"
ta H4MI4B
ta mil_airf


ta H4MI4C
sum H4MI4C
sum H4MI4C if H4MI4C==8
replace H4MI4C=. if H4MI4C>7

gen mil_mcorps=0 if H4MI4C~=.
replace mil_mcorps=1 if H4MI4C==1
label var mil_mcorps "Served in the Marine Corps "
ta H4MI4C
ta mil_mcorps

ta H4MI6C
sum H4MI6C
sum H4MI6C if H4MI6C==8
replace H4MI6C=. if H4MI6C>7
gen mil_nguard=0 if H4MI6C~=.
replace mil_nguard=1 if H4MI6C==1
label var mil_nguard "Served in the National Guard "
ta H4MI6C
ta mil_nguard 


sum mil_army mil_navy mil_airf mil_mcorps mil_nguard mil_nad if mil_ever==1
***

replace mil_current=0 if mil_nad==1
replace mil_combat=0 if mil_nad==1
replace mil_abroad_us=0 if mil_nad==1
replace mil_us=0 if mil_nad==1
*********************************
  
gen mil_outus_nc=0 if mil_ever~=.
replace mil_outus_nc=1 if mil_abroad_us==1 & mil_combat==0
label var mil_outus_nc "Active Duty Outside US (no combat)"

replace H4MI13=. if H4MI13==998
replace H4MI13=. if H4MI13==996
replace H4MI13=. if H4MI13==995

gen mil_combat1up=0 if H4MI13~=.
replace mil_combat1up=1 if H4MI13>=1 & H4MI13<997
replace mil_combat1up=0 if H4MI13==997
ta mil_combat1up
label var mil_combat1up  "Active Duty Combat >=1 Enemy Firefights"


ta mil_ever 
ta mil_active
ta mil_us

ta mil_nad
ta mil_active
ta mil_combat
ta mil_us
ta mil_abroad_us
ta mil_outus_nc
ta mil_us mil_abroad_us
ta mil_combat mil_outus_nc
ta mil_us mil_outus_nc
ta mil_ever mil_outus_nc
ta mil_ever mil_us

ta mil_active mil_nad

replace mil_outus_nc=0 if mil_combat==1
replace mil_outus_nc=0 if mil_nad==1

sum mil_ever mil_nad mil_combat mil_outus_nc mil_combat if mil_ever==1

sum  mil_combat mil_outus_nc mil_us mil_nad if mil_ever==1
cor mil_combat mil_outus_nc mil_us mil_nad 

ta mil_combat mil_outus_nc
ta mil_combat mil_us
ta mil_combat mil_nad

replace mil_us=0 if mil_combat==1
gen mil_test=mil_nad+mil_combat+mil_outus_nc+mil_us if mil_ever==1
ta mil_test 

sum  mil_combat mil_outus_nc mil_us mil_nad if mil_ever==1


*********************
*gen intvdate=mdy(IMONTH4,IDAY4 ,IYEAR4)
sum intvdate

gen lag_intvdate=mdy(IMONTH,IDAY,IYEAR+1900)

sum lag_intvdate
generate yearsince_w1=((intvdate-lag_intvdate) / 365.25) 
sum yearsince_w1
ta yearsince_w1
gen mnthsince_w1=yearsince_w1*12
ta mnthsince_w1

ta mil_mnths 

sum mil_mnths  mnthsince_w1 if mil_ever==1

ta H4MI8M H4MI8Y

replace H4MI8M=. if H4MI8M>12
replace H4MI8Y=. if H4MI8Y>2008

gen mil_startdate=mdy(H4MI8M,15,H4MI8Y) 


gen msbw1=0
replace msbw1=1 if lag_intvdate>mil_startdate & mil_ever==1

generate mil_startage=int((mil_startdate-birthday) / 365.25) 
ta mil_startage


label var msbw1 "Military Service Had Started Prior to Wave 1 Interview"

*********
ta H4MI14
gen killed=. 
replace killed=0 if H4MI14==0
replace killed=1 if H4MI14==1
label var killed "Killed Someone"
ta killed 

ta H4MI15
gen wounded=. 
replace wounded=0 if H4MI15==0
replace wounded=1 if H4MI15==1
label var wounded "Wounded or Injured"
 
 
gen saw_aco_killed=0 if mil_combat==1
replace saw_aco_killed=. if H4MI16A>1
replace saw_aco_killed=1 if H4MI16A==1
ta saw_aco_killed
label var saw_aco_killed "Witnessed Death of Ally"



*rank
replace H4MI10=. if H4MI10>25

ta H4MI10
gen DS_RR1=0 if H4MI10~=. 
replace DS_RR1=1 if H4MI10~=. & H4MI10>=1 & H4MI10<=3 

gen DS_RR2=0 if H4MI10~=. 
replace DS_RR2=1 if H4MI10~=. & H4MI10>=4 & H4MI10<=6

gen DS_RR3=0 if H4MI10~=. 
replace DS_RR3=1 if H4MI10~=. & H4MI10>=7 & H4MI10<=9

gen DS_RR4=0 if H4MI10~=. 
replace DS_RR4=1 if H4MI10~=. & H4MI10>16

gen DS_RR5=0 if H4MI10~=. 
replace DS_RR5=1 if H4MI10~=. & H4MI10>10 & H4MI10<=16

gen DS_RR6=0 if H4MI10~=. 

label var DS_RR1 "Rank E1-E3"
label var DS_RR2 "Rank E4-E6"
label var DS_RR3 "Rank E7-E9"
label var DS_RR4 "Rank W1-W5"
label var DS_RR5 "Rank O1-O3"
label var DS_RR6 "Rank O4-O10"



*********** Rank Categories for regression
gen rr1=0
replace rr1=1 if H4MI10==1
replace rr1=1 if H4MI10==2

gen rr2=0
replace rr2=1 if H4MI10==3

gen rr3=0
replace rr3=1 if H4MI10==4

gen rr4=0
replace rr4=1 if H4MI10==5

gen rr5=0
replace rr5=1 if H4MI10==6

gen rr6=0
replace rr6=1 if H4MI10==7
replace rr6=1 if H4MI10==8

gen rr7=0
replace rr7=1 if H4MI10==12
replace rr7=1 if H4MI10==13

gen rr8=0
replace rr8=1 if H4MI10==15
replace rr8=1 if H4MI10==16

gen rr9=0
replace rr9=1 if H4MI10>=17 & H4MI10~=.

**********




ta H4MI8Y

ta H4MI9Y
replace H4MI9Y=. if H4MI9Y>2008
ta H4MI9Y

gen mil_onlypre9_11=0 if mil_ever==1
replace mil_onlypre9_11=1 if H4MI9Y<2001
ta mil_onlypre9_11
label var mil_onlypre9_11 "Service Exclusively in Pre-September 11" 
 
gen discharge_date=mdy(H4MI9M,15 , H4MI9Y)

generate time_since_discharce =((intvdate-discharge_date) / 365.25) 
ta time_since_discharce



ta H4MI8Y
ta H4MI8Y
gen mil_onlyafter9_11=0 if mil_ever==1
replace mil_onlyafter9_11=1 if mil_ever==1 & H4MI8Y>2000
ta mil_onlyafter9_11
label var mil_onlyafter9_11 "Service Exclusively in After-September 11" 
ta mil_onlyafter9_11


gen mil_bfrandaftr9_11=0 if mil_ever==1
replace mil_bfrandaftr9_11=1 if mil_onlypre9_11==0 & mil_onlyafter9_11==0 & mil_ever==1
replace mil_bfrandaftr9_11=1 if mil_onlypre9_11==1 & mil_onlyafter9_11==1 & mil_ever==1

replace mil_onlyafter9_11=0 if mil_bfrandaftr9_11==1
replace mil_onlypre9_11=0 if mil_bfrandaftr9_11==1

sum mil_bfrandaftr9_11 mil_onlypre9_11 mil_onlyafter9_11 if mil_ever==1


ta H4MI13
replace  H4MI13=. if H4MI13==997
gen enemyff0=0 if H4MI13~=. 
replace enemyff0=1 if H4MI13==0 
label var enemyff0 "Zero Enemy Firefights"


gen enemyff1_plus=0 if H4MI13~=. & mil_combat==1
replace enemyff1_plus=1 if H4MI13>=1 & H4MI13<=666 & mil_combat==1
label var enemyff1_plus "1 or More Enemy Firefights"
sum enemyff1_plus



sum intvdate
ta H4MI9M
replace H4MI9M=. if H4MI9M>12
ta H4MI9Y

gen dischargeday=mdy(H4MI9M,15,H4MI9Y)



generate timesincelastdischange=((intvdate-dischargeday) / 365.25) 
sum  timesincelastdischange, det


gen combat_ff=0 
replace combat_ff=1 if enemyff1_plus==1 & mil_combat==1

label var combat_ff "Combat Exposure" 

gen combat_noff=0 
replace combat_noff=1 if enemyff1_plus==0 & mil_combat==1
label var combat_noff "Combat Service w/o Exposure" 


sum combat_ff combat_noff mil_outus_nc 
sum combat_ff combat_noff mil_outus_nc mil_us if mil_active==1

egen test=rowtotal(combat_ff combat_noff mil_outus_nc mil_us)
ta test if mil_active==1
gen mis_enemyff=0
replace mis_enemyff=1 if enemyff1_plus==. & mil_combat==1


sum combat_ff combat_noff mil_outus_nc mil_us mis_enemyff if mil_active==1 



ta mil_active
sum mil_active 
drop if mil_active==0
drop if mil_active==.
drop if msbw1==1

label var mil_army "Army" 
label var mil_mcorps "Marines" 
label var mil_navy "Navy" 
label var mil_airf "Air Force" 
***

gen    combat_test=. if mil_combat==1
replace combat_test=1 if combat_ff==1 | combat_noff==1

drop if combat_test~=1 & mil_combat==1
 
sum mil_combat combat_ff combat_noff if mil_us==0

drop if mil_us==1
drop if male==0


ta H4RD23
ta H4RD23 if mil_active==1 & mil_us==0



******************** SUICIDE
ta H4SE1

replace H4SE1=. if H4SE1>1
gen suicd_thgth=. if H4SE1~=.

replace suicd_thgth=0 if H4SE1==0
replace suicd_thgth=1 if H4SE1==1

label var suicd_thgth "Suicide Ideation" 

ta suicd_thgth
ta H4SE1

*************


****
*Religion
ta H4RE1
replace H4RE1=. if H4RE1>90
ta H4RE1

gen rel_norel=0 if H4RE1~=.
replace rel_norel=1 if H4RE1==1

label var rel_norel "Religion: None, Atheist, or Agnostic" 
gen rel_protestan=0 if H4RE1~=.
replace rel_protestan=1 if H4RE1==2
label var rel_protestan "Religion: Protestant"

gen rel_catholic=0 if H4RE1~=.
replace rel_catholic=1 if H4RE1==3

label var rel_catholic "Religion: Catholic"

gen rel_ochrist=0 if H4RE1~=.
replace rel_ochrist=1 if H4RE1==4

label var rel_ochrist "Religion: Other Christian"

gen rel_other=0 if H4RE1~=.
replace rel_other=1 if H4RE1>4 & H4RE1<96

label var rel_other "Religion: Other "

gen mis_rel=0
replace mis_rel=1 if H4RE1==.
label var mis_rel "Missing Data: Religion "


**********

ta H4ID5I

gen PTSD=H4ID5I if H4ID5I<2
sum PTSD
ta H4ID5I
ta PTSD

label var  PTSD "PTSD Diagnosis" 

**** Physical Multreatment during childhood
ta H4MA3
gen abuse_phy=0 if H4MA3<96
replace abuse_phy=1 if H4MA3==5  
label var abuse_phy "Physical Maltreatment Before Age 18"
gen mis_abuse_phy=0
replace mis_abuse_phy=1 if abuse_phy==.
label var mis_abuse_phy "Missing Data: Physical Maltreatment Before Age 18"
ta H4MA3
ta abuse_phy

**************************************
*No Health Insurance

ta H4HS1
sum H4HS1 if H4HS1>10

gen no_hlthins=0 if H4HS1<11
replace no_hlthins=1 if H4HS1==1
label var no_hlthins "No Health Insurance"
gen mis_no_hlthins=0
replace mis_no_hlthins=1 if H4HS1>10
label var mis_no_hlthins "Missing Data: Health Insurance Status"

ta H4HS1
ta no_hlthins
ta mis_no_hlthins

****Wave I PPTV
ta AH_PVT
gen ppvt_w1=AH_PVT
ta ppvt_w1
label var ppvt_w1 "Wave 1 Picture Vocabulary Test Score"
gen mis_ppvt_w1=0
replace mis_ppvt_w1=1 if ppvt_w1==.
label var mis_ppvt_w1 "Missing Data: Wave 1 Picture Vocabulary Test Score"
ta mis_ppvt_w1

*******************
*******************
ta  PA10
replace PA10=. if PA10>5

gen parent_nevermarried=0 if PA10~=.
replace parent_nevermarried=1 if PA10==1

gen parent_married=0 if PA10~=.
replace parent_married=1 if PA10==2

label var parent_married "Parent is Married in Wave 1"

gen parent_divsepwid=0 if PA10~=.
replace parent_divsepwid=1 if PA10==3
replace parent_divsepwid=1 if PA10==4
replace parent_divsepwid=1 if PA10==5
label var parent_divsepwid "Parent is Divorced, Separated or Widowed in Wave 1"
sum parent_divsepwid parent_nevermarried parent_divsepwid

gen mis_parent_marital=0 if PA10~=.
replace mis_parent_marital=1 if PA10==.

label var mis_parent_marital "Missing Data: Parents' Marital Status"
sum parent_nevermarried parent_married parent_divsepwid mis_parent_marital 

****
*Parental income in Wave 1
sum PA55
ta PA55

replace PA55=. if PA55==9996

gen mis_parent_income=0
replace  mis_parent_income=1 if PA55==.
label var mis_parent_income "Missing Data: Parental Income Wave 1"


sum PA55 if mis_parent_income==0


***
gen pictgry1=0 if PA55~=.
replace pictgry1=1  if PA55<21 & mis_parent_income==0

gen pictgry2=0 if PA55~=.
replace pictgry2=1  if PA55>=21 & PA55<31 & mis_parent_income==0

gen pictgry3=0 if PA55~=.
replace pictgry3=1  if PA55>=31 & PA55<40 & mis_parent_income==0

gen pictgry4=0 if PA55~=.
replace pictgry4=1  if PA55>=40 & PA55<50 & mis_parent_income==0

gen pictgry5=0 if PA55~=.
replace pictgry5=1  if PA55>=50 & PA55<61 & mis_parent_income==0

gen pictgry6=0 if PA55~=.
replace pictgry6=1  if PA55>=61 & PA55<83  & mis_parent_income==0

gen pictgry7=0 if PA55~=.
replace pictgry7=1  if PA55>=83 & mis_parent_income==0



label var pictgry2 "$19K=<Parental Income <$28K"
label var pictgry3 "$28K=<Parental Income <$36K"
label var pictgry4 "$36K=<Parental Income <$45K"
label var pictgry5 "$45K=<Parental Income <$56K"
label var pictgry6 "$56K=<Parental Income <$83K"
label var pictgry7 "$83K=<Parental Income"


sum pictgry2 pictgry3 pictgry4 pictgry5 pictgry6  pictgry7

****Mother's Education
ta H1RM1
ta H1RM1
replace H1RM1=. if H1RM1>10



gen momeduc_lhs=0 if H1RM1~=.
replace momeduc_lhs=1 if H1RM1==1
replace momeduc_lhs=1 if H1RM1==2
replace momeduc_lhs=1 if H1RM1==3
replace momeduc_lhs=1 if H1RM1==10

ta momeduc_lhs

gen momedhs=0 if H1RM1~=.
replace momedhs=1 if H1RM1==4
replace momedhs=1 if H1RM1==5

gen mommeduc_sc=0 if H1RM1~=.
replace mommeduc_sc=1 if H1RM1==6
replace mommeduc_sc=1 if H1RM1==7

gen mommeduc_c=0 if H1RM1~=.
replace mommeduc_c=1 if H1RM1==8
replace mommeduc_c=1 if H1RM1==9


gen moedmabovehs=mommeduc_sc
replace  moedmabovehs=1 if mommeduc_c==1

gen mis_momeducaction=0
replace mis_momeducaction=1 if H1RM1==.

label var momedhs "Mother's Education: High School"
label var moedmabovehs "Mother's Education: Above High School"

sum momeduc_lhs  momedhs moedmabovehs  mis_momeducaction



*******binge drinking in the last 30 days
ta H4TO40
replace H4TO40=. if H4TO40==95
replace H4TO40=. if H4TO40==96
replace H4TO40=. if H4TO40==98

gen binge=0 if H4TO40~=.
replace binge=1 if H4TO40>4 & H4TO40<=18
replace binge=. if H4TO33>1

****



****
*drugs marijuana
**H4TO71

replace H4TO65B=. if H4TO65B>1

ta H4TO71
replace H4TO71=. if H4TO71==96
replace H4TO71=. if H4TO71==98

gen marijuana30days=0 if H4TO71~=. 
replace marijuana30days=1 if H4TO71~=. & H4TO71~=97
replace marijuana30days=. if H4TO65B==.
****




*****Wave1_serious fight
ta H1DS5
ta H1DS5
replace H1DS5 =. if H1DS5>5
gen wave1_sff_12m=0 if H1DS5 ~=. 
replace wave1_sff_12m=1 if H1DS5>0 & H1DS5 <=3
replace wave1_sff_12m=. if msbw1==1
label var wave1_sff_12m "Pre-Deployment Serious Fight W1"

gen mis_wave1_sff_12m=0
replace mis_wave1_sff_12m=1 if wave1_sff_12m==.

*****************************



replace H4RD23=. if H4RD23>7
replace H4RD22=. if H4RD22>7
ta H4RD23
ta H4RD22

replace H4RD24=. if H4RD24==96 | H4RD24==98  



gen		injrdprtnr_ly=0 if H4RD24~=. 
replace injrdprtnr_ly=1 if H4RD24~=. & H4RD24>1 & H4RD24<97

label var injrdprtnr_ly "Injury"


gen		violenttp_ly=0 if H4RD22~=.
replace violenttp_ly=1 if H4RD22~=. & H4RD22>1

label var violenttp_ly "Threaten"



gen		shk_prtn_ly=0 if H4RD23~=.
replace shk_prtn_ly=1 if H4RD23~=. & H4RD23>1

label var shk_prtn_ly "Hit"

***H4RD7G
replace H4RD7G =. if H4RD7G>5
ta H4RD7G, sum(mil_combat)
ta H4RD7G, gen(trusted_prtnr)
ta H4RD7G
gen trusted_prtnr1_2= trusted_prtnr1
replace trusted_prtnr1_2=1 if trusted_prtnr2==1

label var trusted_prtnr1_2 "Trust"
***

ta H4RD7D
ta H4RD7D

replace H4RD7D=. if H4RD7D>5
ta H4RD7D, sum(mil_combat)

ta H4RD7D, gen(prnt_lstnd)

gen prnt_lstnd1_2=prnt_lstnd1
replace prnt_lstnd1_2=1 if prnt_lstnd2==1

label var prnt_lstnd1_2 "Listen"


****
gen ina_rlsnshp=0 if H4RD8~=.
replace ina_rlsnshp=1 if H4RD8~=. & H4RD8<7

label var ina_rlsnshp "Relationship" 
replace H4RD14=. if H4RD14>995


gen fav_drug30days=0 if H4TO99~=. 
replace fav_drug30days=1 if H4TO99~=. & H4TO99>0 & H4TO99<7

sum fav_drug30days marijuana30days

gen any_drug30days=0 
replace any_drug30days=1 if fav_drug30days==1 | marijuana30days==1

sum marijuana30days fav_drug30days any_drug30days

sum any_drug30days
label var binge				"Usual Binge Drinking" 
label var any_drug30days	"Drug Use" 


ta C4VAR001
replace C4VAR001=. if C4VAR001>20
gen chn_strss_scl=C4VAR001
label var chn_strss_scl "Psychological Stress Scale" 

sum  binge any_drug30days  PTSD suicd_thgth chn_strss_scl

d mil_army mil_mcorps mil_navy mil_airf 

 

replace H1GH60=. if H1GH60>290
gen w1_weight=H1GH60
gen mis_w1_weight=0
replace mis_w1_weight=1 if w1_weight==.

ta H1GH59A
replace H1GH59A=. if H1GH59A>11
replace H1GH59B =. if H1GH59B>11

gen w1_heightinch= H1GH59B+(H1GH59A*12)
gen mis_w1_heightinch=0 
replace mis_w1_heightinch=1 if w1_heightinch==.
  
sum w1_heightinch mis_w1_heightinch


sum parent_divsepwid parent_nevermarried parent_married mis_parent_marital

sum parent_divsepwid parent_married

gen numberofsiblings=H4WS1  if H4WS1<13
gen mis_numberofsiblings=0
replace mis_numberofsiblings=1 if numberofsiblings==. 


ta numberofsiblings, gen(numberofsiblings_dum)

gen sibling1=0
replace sibling1=1 if numberofsiblings==1 & mis_numberofsiblings==0

gen sibling2=0
replace sibling2=1 if numberofsiblings==2 & mis_numberofsiblings==0

gen sibling3=0
replace sibling3=1 if numberofsiblings==3 & mis_numberofsiblings==0

gen sibling4=0
replace sibling4=1 if numberofsiblings==4 & mis_numberofsiblings==0

gen sibling5up=0
replace sibling5up=1 if numberofsiblings>=5 & mis_numberofsiblings==0 & numberofsiblings~=. 

label var sibling1 "One sibling"
label var sibling2 "Two siblings"
label var sibling3 "Three siblings"
label var sibling4 "Four siblings"
label var sibling5up "Five or more siblings"

label var ppvt_w1  "Wave 1 Picture Vocabulary Test Score"

label var wave1_sff_12m "Pre-Deployment Serious Fight W1"
label var abuse_phy "Physical Maltreatment Before 18"
label var w1_weight "Wave 1 Weight"
label var w1_heightinch "Wave 1 Height"

label var rel_protestan "Religion: Protestant" 
label var rel_catholic "Religion: Catholic" 
label var rel_ochris "Religion: Other Christian" 
label var rel_other "Religion: Other"
label var ageiny "Age in Years"
label var ageiny2 "Age in Years Squared"

label var rblack "Race: Black"
label var rother "Race: Other"
label var hispanic "Race: Hispanic"

label var educ_scv "Some College" 
label var C4VAR039 "College"

label var parent_married "Parents: Married"

label var parent_divsepwid "Parents: Divorced, Separated or Widowed"


gen H4TR10z=H4TR10
replace H4TR10z=0 if H4TR10==97

gen c1to2=0 if H4TR10z~=. 
replace c1to2=1 if H4TR10z==1
replace c1to2=1 if H4TR10z==2

gen c3up=0
replace c3up=1 if H4TR10z>=3 & H4TR10z~=. 

label var c1to2 "One or Two Children"
label var c3up "Three or More Children"

ta H1RR1, gen(H1RR1_dum)
sum H1RR1_dum*
label var H1RR1_dum2 "Pre-Deployment Romantic Relationship Status" 
label var no_hlthins "No Health Insurance" 


gen ntest=. 
replace ntest=1 if violenttp_ly~=. 
replace ntest=1 if shk_prtn_ly~=. 
replace ntest=1 if injrdprtnr_ly~=. 
drop if ntest==. 




save addhealth_data, replace

