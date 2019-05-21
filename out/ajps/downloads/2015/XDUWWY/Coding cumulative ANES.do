***Coding cumulative ANES limited to 1970-2004: all final variables coded to range from 0 to 1
duplicates drop VCF0006a, force

gen year=VCF0004
tab year

***Political Identity Coding

///Party Identity, directional
gen pid=VCF0301
recode pid 9=.
replace pid=(1-((pid-1)/6))
label variable pid "7-point PID Dem=hi"

///Ideology
gen ideo=VCF0803
recode ideo 9=.
replace ideo=(1-((ideo-1)/6))
label variable ideo "Ideology Liberal=hi"

///Party dummy variable
gen demrep=1 if VCF0301==1 | VCF0301==2 | VCF0301==3
replace demrep=0 if VCF0301==7 | VCF0301==6 | VCF0301==5
label variable demrep "Dem/Rep Dummy including leaners, 1=Dem"

///Partisan strength
gen pidstr=3 if VCF0301==1 | VCF0301==7
replace pidstr=2 if VCF0301==2 | VCF0301==6
replace pidstr=1 if VCF0301==3 | VCF0301==5
replace pidstr=0 if VCF0301==4 
replace pidstr=pidstr/3
label variable pidstr "Partisan strength, hi=strong"

///Ideological strength
gen ideostr=3 if VCF0803==1 | VCF0803 ==7
replace ideostr =2 if VCF0803 ==2 | VCF0803 ==6
replace ideostr =1 if VCF0803 ==3 | VCF0803 ==5
replace ideostr =0 if VCF0803 ==4 
replace ideostr=ideostr/3
label variable ideostr "Ideological strength, hi=strong"

//Partisan strength coded 1-4
gen pidstr1=4 if VCF0301==1 | VCF0301==7
replace pidstr1 =3 if VCF0301==2 | VCF0301==6
replace pidstr1 =2 if VCF0301==3 | VCF0301==5
replace pidstr1 =1 if VCF0301==4 
label variable pidstr1 "Partisan strength, 1 to 4, 4=strong"

//Ideological strength coded 1-4
gen ideostr1=4 if VCF0803==1 | VCF0803 ==7
replace ideostr1 =3 if VCF0803 ==2 | VCF0803 ==6
replace ideostr1 =2 if VCF0803 ==3 | VCF0803 ==5
replace ideostr1 =1 if VCF0803 ==4 
label variable ideostr1 "Ideological strength, 1 to 4, 4=strong"


***Religion coding
///Frequency of church attendance
gen attend=VCF0130
recode attend 7=5
replace attend=(1-((attend-1)/4))
label variable attend "Religious Attendance, hi=every week"

///Evangelical dummy variable
gen evangelical=0 
replace evangelical=1 if VCF0128b==1 | VCF0129==123 | VCF0129==122 | /// 
VCF0129==136 | VCF0129==131 | VCF0129==135 | VCF0129==131 | VCF0129==123 | ///
VCF0129==135 | VCF0129==101 & attend>.25 | VCF0129==123 | VCF0129==139 | ///
VCF0152==10 & attend>.25 | VCF0152==100 | VCF0152==102 | VCF0152==109 | ///
VCF0152==120 | VCF0152==122 | VCF0152==123 | VCF0152==124 | VCF0152==125 | ///
VCF0152==126 | VCF0152==127 | VCF0152==128 | VCF0152==135 | VCF0152==147 | ///
VCF0152==148 | VCF0152==149 | VCF0152==160 | VCF0152==161 | VCF0152==162 | ///
VCF0152==166 | VCF0152==167 | VCF0152==168 | VCF0152==170 | VCF0152==180 | ///
VCF0152==181 | VCF0152==182 | VCF0152==183 | VCF0152==184 | VCF0152==185 | ///
VCF0152==186 | VCF0152==199 | VCF0152==200 | VCF0152==201 | VCF0152==219 | ///
VCF0152==221 | VCF0152==222 | VCF0152==223 | VCF0152==230 | ///
VCF0152==234 | VCF0152==240 | VCF0152==250 | VCF0152==251 | VCF0152==252 | ///
VCF0152==253 | VCF0152==254 | VCF0152==255 | VCF0152==256 | VCF0152==257 | ///
VCF0152==258 | VCF0152==260 | VCF0152==261 | VCF0152==262 | VCF0152==263 | ///
VCF0152==264 | VCF0152==267 | VCF0152==268 | VCF0152==269 | VCF0152==272 | ///
VCF0152==275 | VCF0152==291 | VCF0152==292 | VCF0152==306 

label variable evangelical "1 if R is member of evang. denom, coding changes in 1990"

***Behavioral Polarization coding

***INGROUP BIAS
///Thermometer Bias: 
///Democratic Thermometer
gen demtherm=VCF0218/100
///Republican Thermometer
gen reptherm=VCF0224/100
///Thermometer Bias
gen thermbias=abs(demtherm-reptherm)
label variable thermbias "Difference btwn Dem and Rep Party thermometers"

///Like Bias
***Coded by ANES: Democratic Party Likes VCF0314, Dislikes VCF0315, Number Likes-Dislikes VCF0316
***Coded by ANES: Repub Party Likes VCF0318, Dislikes VCF0319, Number Likes-Dislikes VCF0320

///Democratic likes minus dislikes
gen demlikesminusdis=VCF0316+5
///Republican likes minus dislikes
gen replikesminusdis=VCF0320+5
///Like Bias
gen likebias=abs(demlikesminusdis-replikesminusdis)
replace likebias=likebias/10
label variable likebias "Dif between Dem and Rep like scores(#like minus #dis), hi=biggest diff, lo=same# of likes/dislikes for each party"


***ACTIVISM
***ANES pre-made scale of campaign involvement: count of following vars:
//Did R try to influence the vote of others
//Did R attend political meetings/rallies
//Did R work for party or candidate
//Did R display candidate button/sticker
//Did R donate money to party or candidate
///VCF0723 is count of number of above activities

gen pastactiv=VCF0723
replace pastactiv=(pastactiv-1)/5
label variable pastactiv "number of campaign activities, hi=5 activities"


***ANGER

///anger at outgroup candidate
///angry at Dem pres cand: VCF0358
///angry at Rep pres cand: VCF0370

gen angercand=1 if VCF0358==1 & demrep==0 | VCF0370==1 & demrep==1
replace angercand=0 if angercand==.
label variable angercand "anger at outgroup pres candidate, 1=felt anger, starts 1980, missing midterm years"


***ISSUE POSITION POLARIZATION

//Abortion: begins in 1980
gen abortion=VCF0838
recode abortion 9=.
replace abortion=(abortion-1)/3
label variable abortion "when should abortion be allowed by law, 1=always"

***strong abortion position dummy
gen abortionstr=1 if abortion==0 | abortion==1
replace abortionstr=0 if abortionstr==.


//Government services/spending
gen govspend=VCF0839
recode govspend 9=.
replace govspend=(govspend-1)/6
label variable govspend "gov services vs spending, 1=many more servic&spending"

***Government services/spending strength
gen govspendstr=0 if VCF0839==4
replace govspendstr=1 if VCF0839==5 | VCF0839==3
replace govspendstr=2 if VCF0839==2 | VCF0839==6
replace govspendstr=3 if VCF0839==1 | VCF0839==7
replace govspendstr=(govspendstr)/3


//Government health insurance
gen govhealth=VCF0806
recode govhealth 9=.
replace govhealth=(1-((govhealth-1)/6))
label variable govhealth "gov/private health insurance, 1=gov insurance plan"

***Government health insurance strength
gen govhealthstr=0 if VCF0806==4
replace govhealthstr=1 if VCF0806==5 | VCF0806==3
replace govhealthstr=2 if VCF0806==2 | VCF0806==6
replace govhealthstr=3 if VCF0806==1 | VCF0806==7
replace govhealthstr=(govhealthstr)/3

//Aid to Blacks 
gen aidblack=VCF0830
recode aidblack 9=.
replace aidblack=(1-((aidblack-1)/6))
label variable aidblack "govt aid to minorities, 1=gov should help"

***Aid to Blacks Strength
gen aidblackstr=0 if VCF0830 ==4
replace aidblackstr=1 if VCF0830 ==5 | VCF0830 ==3
replace aidblackstr=2 if VCF0830 ==2 | VCF0830 ==6
replace aidblackstr=3 if VCF0830 ==1 | VCF0830 ==7
replace aidblackstr=. if VCF0830==.
replace aidblackstr=(aidblackstr)/3
label variable aidblackstr "strength of aid to black opinion, 1=strong"

***Govt guarantee jobs
gen govtjobs=VCF0809
recode govtjobs 9=.
replace govtjobs =(1-((govtjobs-1)/6))
label variable govtjobs "govt guarantee jobs, 1=govt should guarantee jobs"

***Govt guarantee jobs strength
gen govtjobsstr =0 if VCF0809 ==4
replace govtjobsstr =1 if VCF0809 ==5 | VCF0809 ==3
replace govtjobsstr =2 if VCF0809 ==2 | VCF0809 ==6
replace govtjobsstr =3 if VCF0809 ==1 | VCF0809 ==7
replace govtjobsstr =(govtjobsstr)/3

***Defense Spending
gen defense=VCF0843
recode defense 9=.
replace defense =(1-((defense-1)/6))
label variable defense "defense spending, 1=greatly decrease defense spending"

***Defense spending strength
gen defensestr =0 if VCF0843 ==4
replace defensestr =1 if VCF0843 ==5 | VCF0843 ==3
replace defensestr =2 if VCF0843 ==2 | VCF0843 ==6
replace defensestr =3 if VCF0843 ==1 | VCF0843 ==7
replace defensestr =(defensestr)/3


***Index of Issue Strength
egen issuestr2=rmean(defensestr abortionstr govspendstr govhealthstr aidblackstr govtjobsstr)
label variable issuestr2 "6-item index of issue strength, 1=strongest positions"

   
***Issue Constraint 
egen issconstraint2=rowsd(defense abortion govspend govhealth aidblack govtjobs)
omscore issconstraint2
replace issconstraint2=rr_issconstraint2


***Demographic controls
//Education
gen educ=VCF0140a
replace educ=(educ-1)/6
label variable educ "education, 1=advanced degree"

//Male dummy
gen male=1 if VCF0104==1
replace male=0 if male==.
label variable male "dummy for male"

//White dummies
gen white=1 if VCF0106a==1
replace white=0 if white==.


//Age
gen age=VCF0101

//Urbanism
gen urban=1 if VCF0111==1
replace urban=0 if urban==.
gen rural=1 if VCF0111==3
replace rural=0 if rural==.

//South Dummy
gen south=1 if VCF0113==1
replace south=0 if south==.
label variable south "dummy=1 if state seceded in civil war"



***SORTING

///Partisan and Ideological Strength
//1-4 scales
gen pidideostr1=pidstr1*ideostr1

//Alignment between partisan and ideological strength
gen pid1=VCF0301
recode pid1 9=.

gen ideo1=VCF0803
recode ideo1 9=.

gen overlap=abs(pid1-ideo1)+1

omscore overlap
replace overlap=rr_overlap

label variable overlap "overlap between identities, hi=most overlap"


//Full sorting measure
gen overlapxstr=overlap*pidideostr1
gen idcomplexity=(overlapxstr-7)/105



