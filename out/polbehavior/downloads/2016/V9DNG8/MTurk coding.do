clear all
set seed 77007
use "/Users/spencerpiston/Dropbox/disgust project/MTurk Replication/mturkrepdata_old.dta"
set more off

*demographics
gen Male = gender
recode Male 2=0
gen PID = pid
recode PID 1=2 2=6 3/4=4
recode PID 2=1 if pidd==1
recode PID 6=7 if pidr==1
recode PID 4=3 if pidi==1
recode PID 4=5 if pidi==2
recode PID -99=.
gen pidrep0to1=(PID-1)/6
tab PID pidrep0to1, miss
gen Black = 0
recode Black 0=1 if race==2
gen Hisp = 0
recode Hisp 0=1 if race==4
gen OtherR = 0
recode OtherR 0=1 if (race==3 | race==5)
gen Attend = attend
recode Attend 1=6 2=5 3=4 4=3 5=2 6=1
replace Attend=(Attend-1)/5
tab Attend
gen Age = born + 4
gen age0to1=(Age-19)/57
tab age0to1
gen ideo0to1=(ideo-1)/6
gen educ0to1=(educ-1)/4

*disgust recoding
alpha tdds*, item gen(DS)
gen ds=(DS-1)/6

*immigration recoding
recode immchild 1=7 2=6 3=5 5=3 6=2 7=1
alpha immlevel immskill immchild, item gen(ImmOpp)

gen immpath = immpol_1
gen immpatrol = immpol_2
gen immquest = immpol_3
gen immfine = immpol_4
gen immdeport = immpol_5
recode immpatrol 1=7 2=6 3=5 5=3 6=2 7=1 
recode immquest 1=7 2=6 3=5 5=3 6=2 7=1 
recode immfine 1=7 2=6 3=5 5=3 6=2 7=1 
recode immdeport 1=7 2=6 3=5 5=3 6=2 7=1 

corr immlevel immskill immchild immpath immpatrol immquest immfine immdeport

*immigration experiment treatments
gen Treat1 = case1t
recode Treat1 .=0 if case1c==1
gen Treat2 = case2t
recode Treat2 .=0 if case2c==1

*immigration experiment outcomes
recode c1visa 4=1 5=2 6=3 7=4 8=5 9=6 10=7
recode c1cit 4=1 5=2 6=3 7=4 8=5 9=6 10=7
recode c2visa 4=1 5=2 6=3 7=4 8=5 9=6 10=7
recode c2cit 4=1 5=2 6=3 7=4 8=5 9=6 10=7
recode c3visa 4=1 5=2 6=3 7=4 8=5 9=6 10=7
recode c3cit 4=1 5=2 6=3 7=4 8=5 9=6 10=7
alpha c1visa c1cit, item gen(Case1)
alpha c2visa c2cit, item gen(Case2)
alpha c3visa c3cit, item gen(Case3)

*interactions
gen T1xDS = Treat1*DS
gen T2xDS = Treat2*DS

*immigrant traits
rename immtraits_1 itraithard
rename immtraits_2 itraitintel
rename immtraits_3 itraitclean
rename immtraits_4 itraitpatr
rename immtraits_5 itraitcare
rename immtraits_6 itraithealth

*homeless policy recoding
factor homepol*, ml factors(2)
rotate, promax blanks(.3)

*banning homeless
recode homepol_1 1=7 2=6 3=5 5=3 6=2 7=1
recode homepol_2 1=7 2=6 3=5 5=3 6=2 7=1
alpha homepol_1 homepol_2, item gen(Homeban)
gen homesleep = homepol_1
gen homesleep0to1=(homesleep-1)/6
gen homepan = homepol_2
gen homepan0to1=(homepan-1)/6
*helping homeless
recode homepol_4 1=7 2=6 3=5 5=3 6=2 7=1
recode homepol_5 1=7 2=6 3=5 5=3 6=2 7=1
alpha homepol_4 homepol_5, item gen(Homehelp)
gen homeaid = homepol_4
gen homeaid0to1=(homeaid-1)/6
gen homesubs = homepol_5
gen homesubs0to1=(homesubs-1)/6

*busing homeless - seems strangely orthogonal 
rename homepol_3 homebus
recode homebus 1=7 2=6 3=5 5=3 6=2 7=1

*homeless traits
rename hometraits_1 htraithard
rename hometraits_2 htraitintel
rename hometraits_3 htraitclean
rename hometraits_4 htraitpatr
rename hometraits_5 htraitcare
rename hometraits_6 htraithealth

*homeless attributions
gen homelazy = homeatt_1
gen homefact = homeatt_2
gen homechoi = homeatt_3
gen homehous = homeatt_4
gen homerich = homeatt_5
gen homedrug = homeatt_6
recode homelazy 1=4 2=3 3=2 4=1
recode homefact 1=4 2=3 3=2 4=1
recode homechoi 1=4 2=3 3=2 4=1
recode homehous 1=4 2=3 3=2 4=1
recode homerich 1=4 2=3 3=2 4=1
recode homedrug 1=4 2=3 3=2 4=1
gen homelazy0to1=(homelazy-1)/3
gen homefact0to1=(homefact-1)/3
gen homechoi0to1=(homechoi-1)/3
gen homehous0to1=(homehous-1)/3
gen homerich0to1=(homerich-1)/3
gen homedrug0to1=(homedrug-1)/3

egen homeattint=rowmean(homelazy0to1 homechoi0to1)
tab homeattint
egen homeattintbig=rowmean(homelazy0to1 homechoi0to1 homedrug0to1)
tab homeattintbig
egen homeattext=rowmean(homefact0to1 homehous0to1 homerich0to1)
tab homeattext

lab var ds "Disgust Sensitivity"
lab var pidrep0to1 "Party ID (Rep.)" 
lab var ideo0to1 "Ideology (Cons.)" 
lab var Attend "Church Attendance"
lab var educ0to1 "Education"
lab var Male "Male"
lab var age0to1 "Age"
lab var Hisp "Hispanic"
lab var Black "Black"
lab var OtherR "Other Race"

save "/Users/spencerpiston/Dropbox/disgust project/MTurk Replication/mturkrepconstructed.dta", replace
