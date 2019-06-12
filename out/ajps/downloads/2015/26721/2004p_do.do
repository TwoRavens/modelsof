recode P001321 (996/997=.)(998=50)(999=.), into(gaytherm00)

gen gaytherm1_00 = gaytherm00/100

recode P025067 (887=.)(888=50)(889/999=.), into(gaytherm02)

gen gaytherm1_02 = gaytherm02/100

recode P045035 (777=.)(888=50)(889/999=.), into(gaytherm04)

gen gaytherm1_04 = gaytherm04/100

recode P000523 (1=.1667)(2=.333)(3=.5)(4=.667)(5=.833)(6=1)(7=.)(8=.5)(9=.), into(pid00)

recode P000446 (0=.)(8/9=4), into(ideo7_00)

gen ideology00 = (ideo7_00-1)/6

recode P000913 (1/2=0)(3=.25)(4/5=.5)(6=.75)(7=1)(9=.), into(edu00)

recode P001030 (2=1)(1=0)(3/9=0), into(black)

recode P001029 (1=1)(2=0), into(male)

recode P000092 (3=1)(1/2=0)(4=0), into(south00)

recode P000994 (1/4=1)(5/99=0), into(lowincome)

recode P000994 (1/9=0)(10/22=1)(98/99=0), into(highincome)

recode P001249 (0=.)(1=0)(2=.)(3=1)(4/9=.), into(bushvote00)

recode P045049A (0=.)(1=0)(2=.)(3=1)(4/9=.), into(bushvote04)

recode P023006X (0=.)(1/2=1)(3/8=0)(9=.), into(approve02)

recode P045005X(0=.)(1/2=1)(3/8=0), into(approve04)

recode P023006X (1=1)(2=.75)(0=.)(4=.25)(5=0)(8=.5)(9=.), into(approve5_02)

recode P045005X (1=1)(2=.75)(0=.)(4=.25)(5=0)(8=.5)(9=.), into(approve5_04)

gen voted_0004 = bushvote00*bushvote04

gen ch_approve = approve5_04-approve5_02

gen ch_gaytherm = gaytherm1_04-gaytherm1_02

####################Table A3#################################

logit bushvote00 gaytherm1_00 pid00 ideology00 edu00 highincome lowincom black male south if voted_0004<=1 [pweight=WT04]

logit bushvote04 gaytherm1_00 pid00 ideology00 edu00 highincome lowincom black male south if voted_0004<=1 [pweight=WT04]

logit approve02 gaytherm1_02 pid7_00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]

logit approve04 gaytherm1_02 pid7_00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]


####################Table A4#################################


reg ch_approve  gaytherm1_02 approve5_02 pid7_00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]

reg ch_gaytherm  gaytherm1_02 approve5_02 pid7_00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]



###############################Figure 2A #########################

logit bushvote00 gaytherm1_00 pid00 ideology00 edu00 highincome lowincom black male south if voted_0004<=1 [pweight=WT04]

adjust  pid00 ideology00 edu00 highincome lowincom black male south, by(gaytherm1_00) pr ci

logit bushvote04 gaytherm1_00 pid00 ideology00 edu00 highincome lowincom black male south if voted_0004<=1 [pweight=WT04]

adjust  pid00 ideology00 edu00 highincome lowincom black male south, by(gaytherm1_00) pr ci

###############################Figure 2B #########################

logit approve02 gaytherm1_02 pid00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]

adjust  pid00 ideology00 edu00 highincome lowincom black male south, by(gaytherm1_02) pr ci

logit approve04 gaytherm1_02 pid00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]

adjust  pid00 ideology00 edu00 highincome lowincom black male south, by(gaytherm1_02) pr ci

###############################Figure 2C #########################

reg ch_approve  gaytherm1_02 approve5_02 pid00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]

adjust  approve5_02 pid00 ideology00 edu00 highincome lowincom black male south , by(gaytherm1_02) ci

###############################Figure 2C #########################

reg ch_gaytherm  gaytherm1_02 approve5_02 pid00 ideology00 edu00 highincome lowincom black male south [pweight=WT04]

adjust  gaytherm1_02 pid00 ideology00 edu00 highincome lowincom black male south , by(approve5_02) ci
