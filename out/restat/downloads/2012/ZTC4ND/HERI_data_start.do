clear
set memory 250m
set more off
cd C:\data\timeuse\
/*Following line accesses restricted use data */
use C:\data\restricted\babcock87-05_all, clear

gen hrstudy = .5*(studybin==2)+ 1.5*(studybin==3)+4*(studybin==4)+8*(studybin==5)+13*(studybin==6)+18*(studybin==7)+24*(studybin==8) if !missing(studybin)
gen hrsclass = .5*(classbin==2)+ 1.5*(classbin==3)+4*(classbin==4)+8*(classbin==5)+13*(classbin==6)+18*(classbin==7)+24*(classbin==8) if !missing(classbin)
bysort cssace year: egen ssize=count(cssace)
gen study16up = (studybin==7)+(studybin==8) if !missing(studybin)
gen study20up = (studybin==8) if !missing(studybin)
gen study5down = (studybin==1)+(studybin==2)+(studybin==3)+(studybin==4) if !missing(studybin)
gen class16up = (classbin==7)+(classbin==8) if !missing(classbin)
gen class20up = (classbin==8) if !missing(classbin)
gen class5down = (classbin==1)+(classbin==2)+(classbin==3)+(classbin==4) if !missing(classbin)
replace white = white-1
replace black = black-1
replace asian = asian-1
gen latino = 1 if chicano==2
replace latino=1 if puertorican==2
replace latino=1 if olatino==2
replace latino=0 if latino==.
gen hisp=0
replace hisp=1 if chicano==2|latino==2|puertorican==2
drop if hrstudy==.

/*Generate age variable, given that 2004 and 2005 use different age questions */
gen agebin=age if year<1995
gen age1 = 3+ 16*(age==1)+ 17*(age==2)+18*(age==3)+19*(age==4)+20*(age==5)+23*(age==6)+27*(age==7)+34.5*(age==8) + 47*(age==9) if !missing(age)
replace byear=. if byear==0
replace bmonth=. if bmonth<=0
replace age1=year-1900-byear -1 if !missing(byear) & (year==2004|year==2005)
drop age
ren age1 age
gen rel_age = age-21
replace agebin=1*(age==19)+2*(age==20)+3*(age==21)+4*(age==22)+5*(age==23)+6*(age>23&age<28)+7*(age>=28&age<33)+8*(age>=33& age<43) +9*(age>=43) if (year==2004|year==2005)&!missing(age)

/*Generate work variable, given that 2005 uses different work question */
gen working = .5*(workingbin==2)+ 1.5*(workingbin==3)+4*(workingbin==4)+8*(workingbin==5)+13*(workingbin==6)+18*(workingbin==7)+24*(workingbin==8) if !missing(workingbin)
gen workingoncampus = .5*(csshpw08==2)+ 1.5*(csshpw08==3)+4*(csshpw08==4)+8*(csshpw08==5)+13*(csshpw08==6)+18*(csshpw08==7)+24*(csshpw08==8) if !missing(csshpw08)
gen workingoffcampus = .5*(csshpw09==2)+ 1.5*(csshpw09==3)+4*(csshpw09==4)+8*(csshpw09==5)+13*(csshpw09==6)+18*(csshpw09==7)+24*(csshpw09==8) if !missing(csshpw09)
gen workbin=workingbin 
gen working05=workingoncampus+workingoffcampus
replace working05 =24 if working05>22 & working05 !=.
gen workbin2=csshpw08
gen workbin3=csshpw09
replace working05 =24 if working05>22 & working05 !=.
replace working =working05 if year==2005
gen hrswork=working
gen work20up = 1 if hrswork>=20 & !missing(hrswork)
replace work20up=0 if hrswork<20
gen work16up=1 if hrswork>=16 & !missing(hrswork)
replace work16up=0 if working<16

gen work=0 if hrswork==0 
replace work=1 if hrswork>0 &hrswork<20
replace work=2 if work20up==1

tabulate year, gen(yeardum)

*Demogrphic controls

gen non=(cssen==1) if !missing(cssen)
gen female=(csssex==2) if !missing(csssex)
gen femaledum=1 if female==.
replace femaledum=0 if femaledum==.
replace female=0 if femaledum==1


/* SAT score coding, given change in norming */
replace satv=. if satv<200
replace satm=. if satm<200
replace satv=. if satv>800
replace satm=. if satm>800
gen satvrev=satv+10 if satv==790
replace satvrev=800 if satv>720
replace satvrev=satv+70 if satv>=710&satv<=720
replace satvrev=satv+60 if satv<710 & satv>=600
replace satvrev=satv+70 if satv<600 & satv>=530
replace satvrev=satv+80 if satv<530 & satv>=250
replace satvrev=satv+70 if satv<250 & satv>210
replace satvrev=satv+60 if satv==210
replace satvrev=satv+30 if satv<210 & satv>=200
replace satvrev=. if satv==.
gen satmrev=800 if satm>770
replace satmrev=790 if satm==770
replace satmrev=770 if satm==760
replace satmrev=760 if satm==750
replace satmrev=satm if satm<750 & satm>710
replace satmrev=satm-10 if satm<720 & satm>650
replace satmrev=satm if satm<660 & satm>590
replace satmrev=satm+10 if satm<600 & satm>540
replace satmrev=satm+20 if satm<550 & satm>490
replace satmrev=satm+30 if satm<500 & satm>440
replace satmrev=satm+40 if satm<450 & satm>380
replace satmrev=satm+50 if satm<390 & satm>310
replace satmrev=satm+40 if satm<320 & satm>280
replace satmrev=satm+30 if satm<290 & satm>260
replace satmrev=280 if satm==260
replace satmrev=260 if satm==250
replace satmrev=240 if satm==240
replace satmrev=220 if satm==230
replace satmrev=200 if satm<230
replace satmrev=. if satm==.
replace satv=satvrev if year==1987 & !missing(satv)
replace satv=satvrev if year==1988 & !missing(satv)
replace satv=satvrev if year==1989 & !missing(satv)
replace satv=satvrev if year==1995 & !missing(satv)
replace satv=satvrev if year==1996 & !missing(satv)
replace satv=satvrev if year==1997 & !missing(satv)
replace satm=satmrev if year==1987 & !missing(satm)
replace satm=satmrev if year==1988 & !missing(satm)
replace satm=satmrev if year==1989 & !missing(satm)
replace satm=satmrev if year==1995 & !missing(satm) 
replace satm=satmrev if year==1996 & !missing(satm) 
replace satm=satmrev if year==1997 & !missing(satm) 

replace satv=. if satv==0
gen satvlow=(satv<540) if !missing(satv)
gen satvmid=(satv>=540&satv<620) if !missing(satv)
gen satvhi=(satv>=620) if !missing(satv)
bysort cssace: egen satv_sch=mean(satv)
gen satvslow=(satv_sch<=550) if !missing(satv_sch)
gen satvsmid=(satv_sch>550&satv<600) if !missing(satv_sch)
gen satvshi=(satv_sch>=600) if !missing(satv_sch)
gen satvdum = (missing(satv)==1)

gen agriculture=1 if cssmajd==80
replace agriculture=1 if cssmajd==77
replace agriculture=0 if agriculture==.

gen biology=1 if cssmajd==46
replace biology=1 if cssmajd>11 & cssmajd<20
replace biology=1 if cssmajd==56
replace biology=1 if cssmajd==81
replace biology=0 if biology==.

gen business=1 if cssmajd>19 & cssmajd<28
replace business=0 if business==.

gen communication=1 if cssmajd==4
replace communication=1 if cssmajd==78
replace communication=0 if communication==.

gen compsci=1 if cssmajd==79
replace compsci=1 if cssmajd==72
replace compsci=0 if compsci==.

gen ed=1 if cssmajd>27 & cssmajd<35
replace ed=0 if ed==.

gen techvoc=1 if cssmajd==71
replace techvoc=1 if cssmajd==74
replace techvoc=1 if cssmajd==75
replace techvoc=1 if cssmajd==76
replace techvoc=0 if techvoc==. 

gen engine=1 if cssmajd>34 & cssmajd<42
replace engine=0 if engine==.

gen arts=1 if cssmajd==1
replace arts=1 if cssmajd==6
replace arts=1 if cssmajd==9
replace art=0 if arts==.

gen health=1 if cssmajd==53
replace health=1 if cssmajd>56 & cssmajd<61
replace health=0 if health==.

gen home_ec=1 if cssmajd==52
replace home_ec=0 if home_ec==.

gen letters=1 if cssmajd==2
replace letters=1 if cssmajd==5
replace letters=1 if cssmajd==7
replace letters=1 if cssmajd==8
replace letters=1 if cssmajd==11
replace letters=0 if letters==.

gen lib=1 if cssmajd==55
replace lib=0 if lib==.

gen math_stat =1 if cssmajd==47
replace math_stat=1 if cssmajd==49
replace math_stat=0 if math_stat==.

gen military=1 if cssmajd==83
replace military=0 if military==.

gen phy_sci=1 if cssmajd>41 & cssmajd<46
replace phy_sci=1 if cssmajd==48
replace phy_sci=1 if cssmajd==50
replace phy_sci=0 if phy_sci==.

gen psy=1 if cssmajd==66
replace psy=0 if psy==.

gen public_service=1 if cssmajd==67
replace public_service=1 if cssmajd==82
replace public_service=0 if public_service==.

gen socsci=1 if cssmajd>60 & cssmajd<66
replace socsci=1 if cssmajd>67 & cssmajd<71
replace socsci=1 if cssmajd==3
replace socsci=0 if socsci==.


gen theology=1 if cssmajd==10
replace theology=0 if theology==.

gen architecture=1 if cssmajd==51
replace architecture=1 if cssmajd==73
replace architecture=0 if architecture==.

gen majormis=1 if cssmajd==.
replace majormis=0 if majormis==.

bysort cssmajd: egen majorstudy = mean (hrstudy)

replace socsci=1 if psy==1
drop psy

replace engine=1 if cssmajd==51
*adding arch

replace techvoc=1 if cssmajd==73
drop architecture

replace techvoc =1 if public_==1
drop public_

replace letters=1 if arts==1
drop arts

replace bus=1 if communication==1
drop communication

replace phy_sci =1 if math==1
drop math

replace letters=1 if theo==1
drop theo

replace techvoc=1 if compsci==1
drop compsci

replace techvoc=1 if lib==1
drop lib

replace techvoc=1 if military==1
drop military

replace techvoc=1 if home_ec==1
drop home_ec

replace techvoc=1 if agri==1
drop agri

gen year_dec=1988 if year==1987|year==1988|year==1989 
replace year_dec=1996 if year==1995|year==1996|year==1997 
replace year_dec=2004 if year==2003|year==2004|year==2005

bysort cssace year_dec: egen sampled=count(hrstudy)
drop if sampled<15

bysort cssace: egen haveyear1987= max(yeardum1)
bysort cssace: egen haveyear1988= max(yeardum2)
bysort cssace: egen haveyear1989= max(yeardum3)

bysort cssace: egen haveyear1995= max(yeardum4)
bysort cssace: egen haveyear1996= max(yeardum5)
bysort cssace: egen haveyear1997= max(yeardum6)

bysort cssace: egen haveyear2002= max(yeardum7)
bysort cssace: egen haveyear2003= max(yeardum8)
bysort cssace: egen haveyear2004= max(yeardum9)
bysort cssace: egen haveyear2005= max(yeardum10)

gen have90s = (haveyear1995==1|haveyear1996==1|haveyear1997==1)
gen have00s = (haveyear2003==1|haveyear2004==1|haveyear2005==1)
gen have80s = (haveyear1987==1|haveyear1988==1|haveyear1989==1)

/*
keep if have80s==1 & have00s==1
collapse studybin, by(cssace)
tab cssace
*/

gen dec96=1 if year==1995|year==1996|year==1997 
replace dec96=0 if dec96==.
gen dec88=1 if year==1987|year==1988|year==1989 
replace dec88=0 if dec88==.
gen dec04=1 if year==2003|year==2004|year==2005 
replace dec04=0 if dec04==.

drop if have90s*have00s==0&have80s*have00s==0&have80s*have90s==0
gen dec96_=dec96 if dec96>0
gen doc_res =(carnegie_==15) if !missing(carnegie_)
replace doc_res =1 if carnegie_==16
gen masters=(carnegie_==21) if !missing(carnegie_)
replace masters =1 if carnegie_==22
gen bac_lib=(carnegie_==31) if !missing(carnegie_)
gen bac_oth=(carnegie_==32) if !missing(carnegie_)
gen work1=(work==0) if !missing(work)
gen work2=(work==1) if !missing(work)
gen work3=(work==2) if !missing(work)
gen wgt=head_all/sampled
gen size=head_all_
gen majorgroup=.
replace majorgroup=1 if bus==1
replace majorgroup=2 if ed==1
replace majorgroup=3 if engine==1
replace majorgroup=4 if bio==1
replace majorgroup=5 if phy_sci==1
replace majorgroup=6 if letters==1
replace majorgroup=7 if socsci==1
replace majorgroup=8 if health==1
replace majorgroup=9 if techvoc ==1
replace majorgroup=10 if majorgroup==.
replace majorgroup=. if cssmaja==.

tabulate majorgroup, gen(majordum)

gen fath_nohs=(fathed<3) if !missing(fathed)
gen fath_hs=(fathed>=3&fathed<6) if !missing(fathed)
gen fath_col=(fathed>=6) if !missing(fathed)

save temp, replace

use temp, clear
keep if dec88==1 & have00s==1
/*Table 1, Column 5,6 */ 
sum hrstudy study20up study16up study5down hrsclass class20up class16up class5down work3 work2 work1 white asian black female age fath_nohs fath_hs fath_col satv doc_res masters bac_lib bac_oth [aw=wgt] 

/*Table 6 , Column 3*/
replace hrstudy=hrstudy+3.65
reg hrstudy [pw=wgt] 
outreg using pol1.xls , replace

reg hrstudy [pw=wgt] if work==0
outreg using pol1.xls , append 
reg hrstudy [pw=wgt] if work==1
outreg using pol1.xls , append 
reg hrstudy [pw=wgt] if work==2
outreg using pol1.xls, append 

reg hrstudy [pw=wgt] if fath_nohs==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if fath_hs==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if fath_col==1
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if female==0
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if female==1
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if white==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if asian==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if black==1
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if satv<540
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if satv>=540 & satv<=620
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if satv>620&!missing(satv)
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if majorgroup==1
outreg using pol2.xls , replace
reg hrstudy [pw=wgt] if majorgroup==2
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==3
outreg using pol2.xls, append 
reg hrstudy [pw=wgt] if majorgroup==4
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==5
outreg using pol2.xls, append 
reg hrstudy [pw=wgt] if majorgroup==6
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==7
outreg using pol2.xls, append 
reg hrstudy [pw=wgt] if majorgroup==8
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==9
outreg using pol2.xls, append 

reg hrstudy [pw=wgt] if carnegie_==15|carnegie_==16
outreg using pol3.xls , replace
reg hrstudy [pw=wgt] if carnegie_==21|carnegie_==22
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if carnegie_==31
outreg using pol3.xls, append 
reg hrstudy [pw=wgt] if carnegie_==32
outreg using pol3.xls, append 

reg hrstudy [pw=wgt] if satvslow==1
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if satvsmid==1
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if satvshi==1
outreg using pol3.xls , append 

reg hrstudy [pw=wgt] if size<2500
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if size>=2500 & size <=7500
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if size >7500&!missing(head_all_)
outreg using pol3.xls , append 

use temp, clear
/*Table 1, Column 7,8 */ 
keep if dec04==1& have80s==1
sum hrstudy study20up study16up study5down hrsclass class20up class16up class5down work3 work2 work1 white asian black female age fath_nohs fath_hs fath_col satv doc_res masters bac_lib bac_oth [aw=wgt] 

/*Table 6 , Column 4*/
replace hrstudy=hrstudy+3.65

reg hrstudy [pw=wgt] 
outreg using pol1.xls , replace

reg hrstudy [pw=wgt] if work==0
outreg using pol1.xls , append 
reg hrstudy [pw=wgt] if work==1
outreg using pol1.xls , append 
reg hrstudy [pw=wgt] if work==2
outreg using pol1.xls, append 

reg hrstudy [pw=wgt] if fath_nohs==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if fath_hs==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if fath_col==1
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if female==0
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if female==1
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if white==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if asian==1
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if black==1
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if satv<540
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if satv>=540 & satv<=620
outreg using pol1.xls , append 
reg hrstudy  [pw=wgt] if satv>620&!missing(satv)
outreg using pol1.xls , append 

reg hrstudy [pw=wgt] if majorgroup==1
outreg using pol2.xls , replace
reg hrstudy [pw=wgt] if majorgroup==2
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==3
outreg using pol2.xls, append 
reg hrstudy [pw=wgt] if majorgroup==4
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==5
outreg using pol2.xls, append 
reg hrstudy [pw=wgt] if majorgroup==6
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==7
outreg using pol2.xls, append 
reg hrstudy [pw=wgt] if majorgroup==8
outreg using pol2.xls , append 
reg hrstudy [pw=wgt] if majorgroup==9
outreg using pol2.xls, append 

reg hrstudy [pw=wgt] if carnegie_==15|carnegie_==16
outreg using pol3.xls , replace
reg hrstudy [pw=wgt] if carnegie_==21|carnegie_==22
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if carnegie_==31
outreg using pol3.xls, append 
reg hrstudy [pw=wgt] if carnegie_==32
outreg using pol3.xls, append 

reg hrstudy [pw=wgt] if satvslow==1
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if satvsmid==1
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if satvshi==1
outreg using pol3.xls , append 

reg hrstudy [pw=wgt] if size<2500
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if size>=2500 & size <=7500
outreg using pol3.xls , append 
reg hrstudy [pw=wgt] if size >7500&!missing(head_all_)
outreg using pol3.xls , append 


use temp, clear
gen hrsworkd=(hrswork==.)
replace hrswork=0 if hrsworkd==1
gen femaled=(female==.)
replace female=0 if femaled==1
gen raced=0
gen fathed_d=(fathed==.)
replace fath_hs =0 if fathed_d==1
replace fath_col =0 if fathed_d==1
replace raced=1 if black==0&white==0&asian==0&hisp==0
replace black=0 if raced==1
replace asian=0 if raced==1
replace hisp=0 if raced==1
gen majord=(majorgroup==.)
replace rel_age=1.07 if year==2003
gen rel_age_d=(rel_age==.)
replace rel_age=0 if rel_age_d==1
gen satvd=(satv==.)
replace satv=0 if satvd==1
replace satv=satv/100

keep if dec88==1|dec04==1
keep if have80s==1&have00s==1

/* Table 5 Column 2 */
reg hrstudy rel_age female black asian fath_hs fath_col satv satvd raced rel_age_d fathed_d [aw=wgt] if dec04==0
estimates store y1988
reg hrstudy rel_age female black asian fath_hs fath_col satv satvd raced rel_age_d fathed_d [aw=wgt] if dec04==1
estimates store y1996
oaxaca y1988 y1996, weight(1 0)



