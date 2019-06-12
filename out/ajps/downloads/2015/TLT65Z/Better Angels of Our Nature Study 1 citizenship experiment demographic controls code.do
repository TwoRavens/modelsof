 *****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 1: The Citizenship Experiment and Study 3: The Voting Study (British section) Conducted using the British Comparative Campaign Analysis Project data****
***Demographic controls generation do file - generates demographic controls used in robustness checks for study 1 and study 3***
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 1 bccap final.dta", which is in the "Better Angels of Our Nature" folder at dataverse****


***Region 

gen england = 0
replace england = 1 if gor<10

gen neast = 0
replace neast = 1 if gor==1
gen nwest = 0
replace nwest = 1 if gor==2
gen yhum = 0
replace yhum = 1 if gor==3
gen emids = 0
replace emids = 1 if gor==4
gen wmids = 0
replace wmids = 1 if gor==5
gen eastern = 0
replace eastern = 1 if gor==6
gen seast = 0
replace seast = 1 if gor==8
gen swest = 0 
replace swest = 1 if gor==9
gen wales =0
replace wales = 1 if gor==10
gen scot = 0
replace scot = 1 if gor==11

gen north = 0 
replace north = 1 if neast ==1 
replace north = 1 if nwest ==1
replace north = 1 if yhum ==1

gen mids = 0
replace mids = 1 if emids ==1 
replace mids = 1 if wmids ==1

****Age***

gen ageunder30 = 0
replace ageunder30 = 1 if age<30
gen age30s = 0 
replace age30s = 1 if age>29 & age<40
gen age40s = 0
replace age40s = 1 if age>39 & age<50
gen age50s = 0
replace age50s = 1 if age>49 & age<60
gen age60plus = 0
replace age60plus = 1 if age>59
replace age60plus = 0 if age==.

****Educational qualifications

gen noqual = 0
replace noqual = 1 if term_edu==1
gen gcse = 0
replace gcse = 1 if term_edu>1 & term_edu<11
gen alevel = 0
replace alevel = 1 if term_edu>10 & term_edu<13
gen degree = 0
replace degree = 1 if term_edu==15
replace degree = 1 if term_edu==16
replace degree = 1 if term_edu==17
gen othqual = 0
replace othqual = 1 if term_edu==13
replace othqual = 1 if term_edu==14
replace othqual = 1 if term_edu==18

gen edumiss = 0
replace edumiss = 1 if term_edu==.

****Gender***

gen male = 0
replace male=1 if gender==1

***Working class

gen working = 0
replace working = 1 if socgrade==2

****OTHER DEMOGRAPHICS - all from wave 2 as earliest wave we analyse

gen incomescale = w2_p960q1
recode incomescale (17=.) (16=.) 

gen unionmember = 0
recode unionmember (0=1) if w1_p980q1_1==1 

gen incemp = 0
replace incemp = 1 if w1_p1010q1==1

gen incpens = 0
replace incpens = 1 if w1_p1010q1==2
replace incpens = 1 if w1_p1010q1==3
replace incpens = 1 if w1_p1010q1==4

gen incbens = 0
replace incbens = 1 if w1_p1010q1==5
replace incbens = 1 if w1_p1010q1==6
replace incbens = 1 if w1_p1010q1==7
replace incbens = 1 if w1_p1010q1==8

***Detailed social class 

gen profman = 0
replace profman = 1 if w1_p1020q1==1
replace profman = 1 if w1_p1020q1==2
replace profman = 1 if w1_p1020q1==3

gen rnonm = 0
replace rnonm = 1 if w1_p1020q1==4
replace rnonm = 1 if w1_p1020q1==5

gen petbou = 0
replace petbou = 1 if w1_p1020q1==6

gen skilman = 0
replace skilman = 1 if w1_p1020q1==7
replace skilman = 1 if w1_p1020q1==8

gen unskilman = 0
replace unskilman = 1 if w1_p1020q1==9


****Newspaper readership

gen mailexp = 0
replace mailexp = 1 if w1_p1140q1==1
replace mailexp = 1 if w1_p1140q1==2

gen sunstar = 0
replace sunstar = 1 if w1_p1140q1==4
replace sunstar = 1 if w1_p1140q1==5

gen mirror = 0
replace mirror = 1 if w1_p1140q1==3

gen telegraph = 0
replace telegraph = 1 if w1_p1140q1==6

gen guardian = 0 
replace guardian = 1 if w1_p1140q1==8

gen times = 0 
replace times = 1 if w1_p1140q1==10

gen nopaper = 0
replace nopaper = 1 if w1_p1140q1==16

****Home ownership and house value***

gen ownhouse = 0
replace ownhouse = 1 if w1_p1200q1==1

gen mortgage = 0
replace mortgage = 1 if w1_p1200q1==2

gen rentpriv = 0
replace rentpriv = 1 if w1_p1200q1==3

gen rentla = 0
replace rentla = 1 if w1_p1200q1==4

***House value (higher score=decrease)

gen houseval = w1_p1220q1
recode houseval (6=3) 

****Choice of wave - Ideally we want earliest possible wave, but also probably best not to have dependent variables at an earlier wave to independent variables.
***That suggests using wave 2, when the MCP items were asked, or wave 3 when the experiment was run. 

***Leader ratings

***Wave 2

gen ratebrownw2 = w2_p120q1
recode ratebrownw2 (99999=.)
gen ratecamw2 =  w2_p130q1
recode ratecamw2 (99999=.)
gen ratecleggw2 = w2_p110q1
recode ratecleggw2 (99999=.) 

***Wave 3

gen ratebrownw3 = w3_p120q1
recode ratebrownw3 (99999=.)
gen ratecamw3 =  w3_p130q1
recode ratecamw3 (99999=.)
gen ratecleggw3 = w3_p110q1
recode ratecleggw3 (99999=.) 

****Economic assessments - personal and national, prospective and retrospective

***Wave 2

gen natecoretw2 = w2_p660q1
recode natecoretw2 (6=.)

gen natecoprospw2 = w2_p670q1
recode natecoprospw2 (6=.)

gen perecoretw2 = w2_p680q1
recode perecoretw2 (6=.) 

gen perecoprospw2 = w2_p690q1
recode perecoprospw2 (6=.) 

***Wave 3

gen natecoretw3 = w3_p660q1
recode natecoretw3 (6=.)

gen natecoprospw3 = w3_p670q1
recode natecoprospw3 (6=.)

gen perecoretw3 = w3_p680q1
recode perecoretw3 (6=.) 

gen perecoprospw3 = w3_p690q1
recode perecoprospw3 (6=.) 

*****Left right self placement, and placement of parties 

***Wave 2

gen lrselfplacew2 = w2_p310q1
recode lrselfplacew2 (999=5)

gen lrlabplacew2 = w2_p320q1
recode lrlabplacew2 (999=5) 

gen lrldplacew2 = w2_p330q1
recode lrldplacew2 (999=5)

gen lrconplacew2 = w2_p340q1
recode lrconplacew2 (999=5) 

****Wave 3

gen lrselfplacew3 = w3_p310q1
recode lrselfplacew3 (999=5)

gen lrlabplacew3 = w3_p320q1
recode lrlabplacew3 (999=5) 

gen lrldplacew3 = w3_p330q1
recode lrldplacew3 (999=5)

gen lrconplacew3 = w3_p340q1
recode lrconplacew3 (999=5) 

****Competence

***Wave 2

capture drop gbcompw2
gen gbcompw2 = w2_p400q1-1
recode gbcompw2 (11=5)
gen dccompw2 = w2_p410q1-1
recode dccompw2 (11=5) 
gen nccompw2 = w2_p420-1
recode nccompw2 (11=5) 

***Wave 3

capture drop gbcompw3
gen gbcompw3 = w3_p400q1-1
recode gbcompw3 (11=5)
gen dccompw3 = w3_p410q1-1
recode dccompw3 (11=5) 
gen nccompw3 = w3_p420-1
recode nccompw3 (11=5) 


****Most important issue

***Wave 2

gen miiw2 = w2_p500q1
gen immiiw2 = 0

***Note: Manual recode of issues

***Wave 3

gen miiw3 = w3_p500q1
gen immiiw3 = 0

***Issues: perceptions and performance (higher scores = more negative/worse)

***Wave 2

gen crimeupw2 = w2_p510q1
recode crimeupw2 (1=5) (2=4) (4=2) (5=1) (6=.)

gen nhsworsew2 = w2_p520q1
recode nhsworsew2 (6=.)

gen govperfcrimw2 = w2_p510q2
recode govperfcrimw2 (6=.)

gen govperfnhsw2 = w2_p520q2
recode govperfnhsw2 (6=.) 

gen govperfterw2 = w2_p530q1
recode govperfterw2 (6=.)

gen govperfasyw2 = w2_p550q1
recode govperfasyw2 (6=.)

***Wave 3

gen crimeupw3 = w3_p510q1
recode crimeupw3 (1=5) (2=4) (4=2) (5=1) (6=.)

gen nhsworsew3 = w3_p520q1
recode nhsworsew3 (6=.)

gen govperfcrimw3 = w3_p510q2
recode govperfcrimw3 (6=.)

gen govperfnhsw3 = w3_p520q2
recode govperfnhsw3 (6=.) 

gen govperfterw3 = w3_p530q1
recode govperfterw3 (6=.)

gen govperfasyw3 = w3_p550q1
recode govperfasyw3 (6=.)


****Tax levels (higher score = too much)

***Wave 2

*Personal
gen perstaxhighw2 = 0
replace perstaxhigh = 1 if w2_p560q1==1

gen richtaxhighw2 = 0
replace richtaxhighw2 = 1 if w2_p570q1==1

gen richtaxlow2 = 0
replace richtaxlow2 = 1 if w2_p570q1==3

gen poortaxhighw2 = 0
replace poortaxhighw2 = 1 if w2_p580q1==1

gen poortaxlow2 = 0
replace poortaxlow2 = 1 if w2_p580q1==3

***National tax increased? 

gen nattaxlevelw2 = w2_p650q1
recode nattaxlevelw2 (1=5) (2=4) (4=2 ) (5=1) (6=.)

***Wave 3

*Personal
gen perstaxhighw3 = 0
replace perstaxhighw3 = 1 if w3_p560q1==1

gen richtaxhighw3 = 0
replace richtaxhighw3 = 1 if w3_p570q1==1

gen richtaxlow3 = 0
replace richtaxlow3 = 1 if w3_p570q1==3

gen poortaxhighw3 = 0
replace poortaxhighw3 = 1 if w3_p580q1==1

gen poortaxlow3 = 0
replace poortaxlow3 = 1 if w3_p580q1==3

***National tax increased? 

gen nattaxlevelw3 = w3_p650q1
recode nattaxlevelw3 (1=5) (2=4) (4=2 ) (5=1) (6=.)

***Satisfaction with democracy and interest in politics****

****Wave 2

gen satdemw2 = w2_p820q1
recode satdemw2 (1=4) (2=3) (3=2) (4=1) (5=.)

gen polintw2 = w2_p830q1
recode polintw2 (1=4) (2=3) (3=2) (4=1) (5=.) 


***Wave 3
gen satdemw3 = w3_p820q1
recode satdemw3 (1=4) (2=3) (3=2) (4=1) (5=.)

gen polintw3 = w3_p830q1
recode polintw3 (1=4) (2=3) (3=2) (4=1) (5=.) 



***generating and reversing some needed variables***

gen valid=1
replace valid =0 if TurkMaleRate_amp==0 |TurkMaleRate_amp==5

***Generating a new party ID variable from wave 2 and 3 q's. INCLUDING SYMPATHISERS***

****Wave 2

gen pidw2 = 0
replace pidw2 = 1 if w2_p770q1==1
replace pidw2 = 2 if w2_p770q1==2
replace pidw2 = 3 if w2_p770q1==3
replace pidw2 = 4 if w2_p770q1==7
replace pidw2 = 5 if w2_p770q1==8
replace pidw2 = 9 if w2_p770q1==4
replace pidw2 = 9 if w2_p770q1==5
replace pidw2 = 9 if w2_p770q1==9


replace pidw2 = 1 if w2_p780q1==1
replace pidw2 = 2 if w2_p780q1==2
replace pidw2 = 3 if w2_p780q1==3
replace pidw2 = 4 if w2_p780q1==7
replace pidw2 = 5 if w2_p780q1==8
replace pidw2 = 9 if w2_p780q1==4
replace pidw2 = 9 if w2_p780q1==5
replace pidw2 = 10 if w2_p780q1==10
replace pidw2 = 10 if w2_p780q1==11

recode pidw2 (0=.)

label variable pidw2 "party ID wave 2 data, incl sympathisers"
label drop pidw2
label values pidw2 pidw2

label define pidw2 1 "Lab" 2 "Con" 3 "LD" 4 "UKIP" 5 "BNP" 9 "Other" 10 "None/DK"

****Wave 3

gen pidw3 = 0
replace pidw3 = 1 if w3_p770q1==1
replace pidw3 = 2 if w3_p770q1==2
replace pidw3 = 3 if w3_p770q1==3
replace pidw3 = 4 if w3_p770q1==7
replace pidw3 = 5 if w3_p770q1==8
replace pidw3 = 9 if w3_p770q1==4
replace pidw3 = 9 if w3_p770q1==5
replace pidw3 = 9 if w3_p770q1==9


replace pidw3 = 1 if w3_p780q1==1
replace pidw3 = 2 if w3_p780q1==2
replace pidw3 = 3 if w3_p780q1==3
replace pidw3 = 4 if w3_p780q1==7
replace pidw3 = 5 if w3_p780q1==8
replace pidw3 = 9 if w3_p780q1==4
replace pidw3 = 9 if w3_p780q1==5
replace pidw3 = 10 if w3_p780q1==10
replace pidw3 = 10 if w3_p780q1==11

recode pidw3 (0=.)

label variable pidw3 "party ID wave 3 data, incl sympathisers"
label drop pidw3
label values pidw3 pidw3
label define pidw3 1 "Lab" 2 "Con" 3 "LD" 4 "UKIP" 5 "BNP" 9 "Other" 10 "None/DK"


***Vote Intention including leaners***

****Wave 2

gen votew2 = 0
replace votew2 = 1 if w2_p807q1==1
replace votew2 = 2 if w2_p807q1==2
replace votew2 = 3 if w2_p807q1==3
replace votew2 = 4 if w2_p807q1==7
replace votew2 = 5 if w2_p807q1==8
replace votew2 = 9 if w2_p807q1==4
replace votew2 = 9 if w2_p807q1==5
replace votew2 = 9 if w2_p807q1==9

replace votew2 = 1 if w2_p814q1==1
replace votew2 = 2 if w2_p814q1==2
replace votew2 = 3 if w2_p814q1==3
replace votew2 = 4 if w2_p814q1==7
replace votew2 = 5 if w2_p814q1==8
replace votew2 = 9 if w2_p814q1==4
replace votew2 = 9 if w2_p814q1==5
replace votew2 = 9 if w2_p814q1==9
replace votew2 = 10 if w2_p814q1==10


label variable votew2 "GE vote wave 2 data"
label drop votew2
label values votew2 votew2
label define votew2 1 "Lab" 2 "Con" 3 "LD" 4 "UKIP" 5 "BNP" 9 "Other" 10 "Don't know"

recode votew2 (0=.)

****Wave 3


gen votew3 = 0
replace votew3 = 1 if w3_p807q1==1
replace votew3 = 2 if w3_p807q1==2
replace votew3 = 3 if w3_p807q1==3
replace votew3 = 4 if w3_p807q1==7
replace votew3 = 5 if w3_p807q1==8
replace votew3 = 9 if w3_p807q1==4
replace votew3 = 9 if w3_p807q1==5
replace votew3 = 9 if w3_p807q1==9

replace votew3 = 1 if w3_p814q1==1
replace votew3 = 2 if w3_p814q1==2
replace votew3 = 3 if w3_p814q1==3
replace votew3 = 4 if w3_p814q1==7
replace votew3 = 5 if w3_p814q1==8
replace votew3 = 9 if w3_p814q1==4
replace votew3 = 9 if w3_p814q1==5
replace votew3 = 9 if w3_p814q1==9
replace votew3 = 10 if w3_p814q1==10

label variable votew3 "GE vote wave 3 data"
label drop votew3
label values votew3 votew3
label define votew3 1 "Lab" 2 "Con" 3 "LD" 4 "UKIP" 5 "BNP" 9 "Other" 10 "Don't know"

recode votew3 (0=.)


