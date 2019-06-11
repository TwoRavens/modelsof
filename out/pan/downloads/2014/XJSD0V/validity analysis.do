set mem 100m
usespss "C:\ANES2008TS_knowledge20110810 complete.sav"

* SURVEY SETUP
svyset [pweight=v080102], strata(v081206) psu(v081205)

* CRITERION VARIABLE SETUP

*unemployment
generate unemployment = .
replace unemployment = 0 if v083087 == 1
replace unemployment = 1 if v083087 == 3
replace unemployment = 2 if v083087 == 5
replace unemployment = unemployment/2
label define unemployment 0 "less knowledgable" 1 "more knowledgable"
label values unemployment unemployment

*house majority party
generate housemajority = .
replace housemajority = 1 if v085066 == 1
replace housemajority = 0 if v085066 == 5
replace housemajority = 0 if v085066 == -8
label define housemajority 0 "0. incorrect" 1 "1. correct"
label values housemajority housemajority

*senate majority party
generate senatemajority = .
replace senatemajority = 1 if v085067 == 1
replace senatemajority = 0 if v085067 == 5
replace senatemajority = 0 if v085067 == -8
label define senatemajority 0 "0. incorrect" 1 "1. correct"
label values senatemajority senatemajority

*incomegap
generate incomegap = .
replace incomegap = 1 if v085080 == 1
replace incomegap = 0 if v085080 > 1 & v085080 < 6
replace incomegap = 0 if v085080 == -8
label define incomegap 0 "0. incorrect" 1 "1. correct"
label values incomegap incomegap

*partyconservative
*is one party more conservative than the other? which?
generate partyconservative = .
replace partyconservative = 1 if v085119 == 1 & v085119a == 5
replace partyconservative = 0 if v085119 == 1 & v085119a == 1
replace partyconservative = 0 if v085119 == 1 & v085119a == -8
replace partyconservative = 0 if v085119 == 5
replace partyconservative = 0 if v085119 == -8
label define partyconservative 0 "0. incorrect" 1 "1. correct"
label values partyconservative partyconservative

*party left-right
generate demlr = v085189a if v085189a > -1 & v085189a < 11
generate replr = v085189b if v085189b > -1 & v085189b < 11
generate partylr = .
replace partylr = demlr - replr
recode partylr (-10=1) (-9=1) (-8=1) (-7=1) (-6=1) (-5=1) (-4=1) (-3=1) (-2=1) (-1=1) (0=1) (1=0) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0) (8=0) (9=0) (10=0)
replace partylr = 0 if v085189a == -7
replace partylr = 0 if v085189a == -8
replace partylr = 0 if v085189b == -7
replace partylr = 0 if v085189b == -8
label define partylr 0 "0. incorrect" 1 "1. correct"
label values partylr partylr

*democrat ideology
generate demideology = 1 if v083071a > 0 & v083071a < 5
replace demideology = 0 if v083071a > 4 & v083071a < 8
replace demideology = 0 if v083071a == -8
label define demideology 0 "0. incorrect" 1 "1. correct"
label values demideology demideology

*republican ideology
generate repideology = 1 if v083071b > 3 & v083071b < 8
replace repideology = 0 if v083071b > 0 & v083071b < 4
replace repideology = 0 if v083071b == -8
label define repideology 0 "0. incorrect" 1 "1. correct"
label values repideology repideology

*candidate left-right
generate mccainlr = v085190a if v085190a > -1 & v085190a < 11
generate obamalr = v085190b if v085190b > -1 & v085190b < 11
generate candidatelr = .
replace candidatelr = mccainlr - obamalr
recode candidatelr (-10=0) (-9=0) (-8=0) (-7=0) (-6=0) (-5=0) (-4=0) (-3=0) (-2=0) (-1=0) (0=1) (1=1) (2=1) (3=1) (4=1) (5=1) (6=1) (7=1) (8=1) (9=1) (10=1)
replace candidatelr = 0 if v085190a == -7
replace candidatelr = 0 if v085190a == -8
replace candidatelr = 0 if v085190b == -7
replace candidatelr = 0 if v085190b == -8
label define candidatelr 0 "0. incorrect" 1 "1. correct"
label values candidatelr candidatelr

* alternative criterion variables
gen clr=0
replace clr = 1 if candidatelr==1
gen plr=0
replace plr = 1 if partylr==1 
gen sm=0
gen hm=0
replace sm=1 if senatemajority==1
replace hm=1 if housemajority==1

* descriptives on criterion variables

prop unemployment housemajority senatemajority incomegap partyconservative partylr demideology repideology candidatelr

svy: prop unemployment housemajority senatemajority incomegap partyconservative partylr demideology repideology candidatelr

* PRODUCE SCALES FOR KNOWLEDGE ITEMS (scheme 6 for each)
gen p2_1 = p2/2
gen r5_1 = r5/2
gen r4_1 = r4/4
replace r4_1 = 1 if r4_1 > 1

*code r6 reflects degrees of correctness for Roberts
* 0 is not correct
* .33 is judge or court
* .66 is head of the high court
* 1 is chief justice of the supreme court
gen r6=0
replace r6= .33 if (r5==1 | r4 > 0)
replace r6= .67 if (r2==1 | r3 ==1)
replace r6=1 if r1==1

* code p6 reflects degrees of correctness for Pelosi
* 1 speaker of the house
* .66 head of congress
* .33 congress/representative
* 0 not correct
gen p6=0
replace p6 = .33 if p2==1
replace p6 = .67 if p3==1
replace p6 = 1 if p1==1

* code b6 reflects degrees of correctness for Brown
* 1 PM UK
* .66 leader UK
* .33 foreign leader 
* 0 not correct
gen b6=0
replace b6=.33 if b3==1
replace b6=.67 if b2==1
replace b6=1 if b1==1

*generate 0-1 dichotomous indicator summary variables for proportions table
gen p2s=0
replace p2s = 1 if p2 > 0
gen p6s = 0
replace p6s = 1 if p6 > 0 
gen b6s = 0
replace b6s =1 if b6 >0
gen r4s=0
replace r4s=1 if r4 > 0
gen r5s=0
replace r5s=1 if r5 >0
gen r6s=0
replace r6s=1 if r6 > 0

* PROPORTIONS
svy:prop p1 p2s p3 p6s c1 b1 b2 b3 b6s r1 r2 r3 r4s r5s r6s

svy:prop p1 p2 p3 p6 c1 b1 b2 b3 b6 r1 r2 r3 r4 r5 r6 

* VALIDITY BIVARIATE REGRESSIONS on KNOWLEDGE

svy:logit clr p1
svy:logit clr p2_1
svy:logit clr p3
svy:logit clr p6
svy:logit clr c1
svy:logit clr b1
svy:logit clr b2
svy:logit clr b3
svy:logit clr b6
svy:logit clr r1
svy:logit clr r2
svy:logit clr r3
svy:logit clr r4_1
svy:logit clr r5_1
svy:logit clr r6

svy:logit plr p1
svy:logit plr p2_1
svy:logit plr p3
svy:logit plr p6
svy:logit plr c1
svy:logit plr b1
svy:logit plr b2
svy:logit plr b3
svy:logit plr b6
svy:logit plr r1
svy:logit plr r2
svy:logit plr r3
svy:logit plr r4_1
svy:logit plr r5_1
svy:logit plr r6

svy:logit sm p1
svy:logit sm p2_1
svy:logit sm p3
svy:logit sm p6
svy:logit sm c1
svy:logit sm b1
svy:logit sm b2
svy:logit sm b3
svy:logit sm b6
svy:logit sm r1
svy:logit sm r2
svy:logit sm r3
svy:logit sm r4_1
svy:logit sm r5_1
svy:logit sm r6

svy:logit hm p1
svy:logit hm p2_1
svy:logit hm p3
svy:logit hm p6
svy:logit hm c1
svy:logit hm b1
svy:logit hm b2
svy:logit hm b3
svy:logit hm b6
svy:logit hm r1
svy:logit hm r2
svy:logit hm r3
svy:logit hm r4_1
svy:logit hm r5_1
svy:logit hm r6




** PREPARE SOPHISTICATION CORRELATES

* education v083218x
gen edu = .
replace edu = v083218x/7

* age v081104
gen age = (v081104-17)/73
gen agesq= v081104*v081104
gen age2 = .
replace age2 = (agesq-289)/8100

* interest in politics v083001a,b
gen interest = .
replace interest=1 if v083001b==1
replace interest=.75 if v083001b==2 
replace interest=.5 if v083001b==3 
replace interest=.25 if v083001b==4 
replace interest=0 if v083001b==5 

* attention to politics
* media use (nat'l news) v083019a 
gen tv = .
replace tv=1   if v083019a== 1 
replace tv=.75 if v083019a== 2 
replace tv=.5  if v083019a== 3 
replace tv=.25 if v083019a== 4 
replace tv=0   if v083019a== 5 

* political discussion v085108 v085109
gen talk=.
replace talk=0 if v085108 ==5
replace talk=v085108a/7 if v085108 ==1
replace talk=v085109/7 if (v085109>=0 & v085109<=7)

* internal efficacy v085151a,b,c,d; v085152a,b,c,d

gen eff2b=.
replace eff2b = -.25*(v085152b-6)-.25
tab eff2b


* iwr rating of R's intelligence v085404
gen iwint = .
replace iwint = (-1*(v085404-6)-1)/4

* iwr rating of R's information v085403
gen iwinfo = .
replace iwinfo = (-1*(v085403-6)-1)/4

* iwr rating of R's interest in interview v085406
gen iwinterest=.
replace iwinterest = (-1*(v085406-6)-1)/4

* SOPHISTICATION VALIDITY TESTS

svy:reg edu p1
svy:reg edu p2_1
svy:reg edu p3
svy:reg edu p6
svy:reg edu c1
svy:reg edu b1
svy:reg edu b2
svy:reg edu b3
svy:reg edu b6
svy:reg edu r1
svy:reg edu r2
svy:reg edu r3
svy:reg edu r4_1
svy:reg edu r5_1
svy:reg edu r6

svy:reg eff2b p1
svy:reg eff2b p2_1
svy:reg eff2b p3
svy:reg eff2b p6
svy:reg eff2b c1
svy:reg eff2b b1
svy:reg eff2b b2
svy:reg eff2b b3
svy:reg eff2b b6
svy:reg eff2b r1
svy:reg eff2b r2
svy:reg eff2b r3
svy:reg eff2b r4_1
svy:reg eff2b r5_1
svy:reg eff2b r6

svy:reg age p1
svy:reg age p2_1
svy:reg age p3
svy:reg age p6
svy:reg age c1
svy:reg age b1
svy:reg age b2
svy:reg age b3
svy:reg age b6
svy:reg age r1
svy:reg age r2
svy:reg age r3
svy:reg age r4_1
svy:reg age r5_1
svy:reg age r6

svy:reg interest p1
svy:reg interest p2_1
svy:reg interest p3
svy:reg interest p6
svy:reg interest c1
svy:reg interest b1
svy:reg interest b2
svy:reg interest b3
svy:reg interest b6
svy:reg interest r1
svy:reg interest r2
svy:reg interest r3
svy:reg interest r4_1
svy:reg interest r5_1
svy:reg interest r6

svy:reg tv p1
svy:reg tv p2_1
svy:reg tv p3
svy:reg tv p6
svy:reg tv c1
svy:reg tv b1
svy:reg tv b2
svy:reg tv b3
svy:reg tv b6
svy:reg tv r1
svy:reg tv r2
svy:reg tv r3
svy:reg tv r4_1
svy:reg tv r5_1
svy:reg tv r6


svy:reg iwint p1
svy:reg iwint p2_1
svy:reg iwint p3
svy:reg iwint p6
svy:reg iwint c1
svy:reg iwint b1
svy:reg iwint b2
svy:reg iwint b3
svy:reg iwint b6
svy:reg iwint r1
svy:reg iwint r2
svy:reg iwint r3
svy:reg iwint r4_1
svy:reg iwint r5_1
svy:reg iwint r6

svy:reg talk p1
svy:reg talk p2_1
svy:reg talk p3
svy:reg talk p6
svy:reg talk c1
svy:reg talk b1
svy:reg talk b2
svy:reg talk b3
svy:reg talk b6
svy:reg talk r1
svy:reg talk r2
svy:reg talk r3
svy:reg talk r4_1
svy:reg talk r5_1
svy:reg talk r6

svy:reg iwinfo p1
svy:reg iwinfo p2_1
svy:reg iwinfo p3
svy:reg iwinfo p6
svy:reg iwinfo c1
svy:reg iwinfo b1
svy:reg iwinfo b2
svy:reg iwinfo b3
svy:reg iwinfo b6
svy:reg iwinfo r1
svy:reg iwinfo r2
svy:reg iwinfo r3
svy:reg iwinfo r4_1
svy:reg iwinfo r5_1
svy:reg iwinfo r6


svy:reg iwinterest p1
svy:reg iwinterest p2_1
svy:reg iwinterest p3
svy:reg iwinterest p6
svy:reg iwinterest c1
svy:reg iwinterest b1
svy:reg iwinterest b2
svy:reg iwinterest b3
svy:reg iwinterest b6
svy:reg iwinterest r1
svy:reg iwinterest r2
svy:reg iwinterest r3
svy:reg iwinterest r4_1
svy:reg iwinterest r5_1
svy:reg iwinterest r6

** TURNOUT MODEL SETUP

*female
gen female=.
replace female = 1 if v081101 == 2
replace female = 0 if v081101 == 1
label define female 0 "0. male" 1 "1. female"
label values female female

*hh income
xtile hhincome = v083248x if v083248x > 1 & v083248x < 26, nq(4)
replace hhincome = (hhincome - 1)/3
label define hhincome 0 "0. $3,000-$21,999" 1 "1. $75,000-$150,000+"
label values hhincome hhincome

*education
generate education = 1 if v083217 > -1 & v083217 < 9
replace education = 2 if v083217 > 8 & v083217 < 13
replace education = 3 if v083217 > 12 & v083217 < 17
replace education = 4 if v083217 > 16 & v083217 < 18
replace education = (education - 1)/3
label define education 0 "0-8 years" 1 "17+ years"
label values education education

*white
generate white = 1 if v081102 == 1
replace white = 0 if v081102 == 2
replace white = 1 if v081102 == 3
replace white = 0 if v081102 == 4
replace white = 1 if v081102 == 5
replace white = 0 if v081102 == 6
replace white = 1 if v081102 == 7
replace white = 0 if v083251a > 9 & v083251a < 50 & white == .
replace white = 1 if v083251a == 50
replace white = 0 if v083251a > 50 & v083251a < 85 & white == .
replace white = 1 if v083251a == 85
replace white = 0 if v083251a == 90 & white == .
replace white = 0 if v083251b > 9 & v083251b < 50 & white == .
replace white = 1 if v083251b == 50
replace white = 0 if v083251b > 50 & v083251b < 85 & white == .
replace white = 1 if v083251b == 85
replace white = 0 if v083251b == 90 & white == .
replace white = 1 if v083252a > 859 & v083252a < 862
replace white = 0 if v083252a > 861 & v083252a < 865 & white == .

* black
gen black = .
replace black = 0 if (v083251a > 10 & v083251a <=50) | (v083251a >=82 & v083251a <=90)
replace black = 1 if v083251a ==10 | v083251a==81.

* sex female
gen female=.
if v081101 =1 female==0
if v081101=2 female ==1

* discuss politics: talk
* already calculated as talk

* efficacy v085151a,b,c,d; v085152a,b,c,d
* higher scores inticate greater efficacy
gen eff1a=.
gen eff1b=.
gen eff1c=.
gen eff1d=.
gen eff2a=.
gen eff2b=.
gen eff2c=.
gen eff2d=.

replace eff1a = (v085151a-1)/4
replace eff1b = .
 replace eff1b = 1 if v085151b==1
 replace eff1b = .75 if v085151b==2
 replace eff1b = .5 if v085151b==3
 replace eff1b = .25 if v085151b==4
 replace eff1b = 0 if v085151b==5
replace eff1c= (v085151c-1)/4
replace eff1d= (v085151d-1)/4
replace eff1 = (eff1a+eff1b+eff1c+eff1d)/4

replace eff2a = (v085152a-1)/4
replace eff2b = .
 replace eff2b = 1 if v085152b==1
 replace eff2b = .75 if v085152b==2
 replace eff2b = .5 if v085152b==3
 replace eff2b = .25 if v085152b==4
 replace eff2b = 0 if v085152b==5
replace eff2c = .
 replace eff2c = 1 if v085152c==1
 replace eff2c = .75 if v085152c==2
 replace eff2c = .5 if v085152c==3
 replace eff2c = .25 if v085152c==4
 replace eff2c = 0 if v085152c==5
replace eff2d = .
 replace eff2d = 1 if v085152d==1
 replace eff2d = .75 if v085152d==2
 replace eff2d = .5 if v085152d==3
 replace eff2d = .25 if v085152d==4
 replace eff2d = 0 if v085152d==5
replace eff2 = (eff2a+eff2b+eff2c+eff2d)/4
replace eff = .
replace eff = eff1 if eff1>=0 & eff1 <= 1
replace eff = eff2 if eff2>=0 & eff2 <= 1

* EXTERNAL efficacy
gen exteff=.
gen exteff1=.
gen exteff2=.
replace exteff1 = (eff1c+eff1d)/2 
replace exteff2 = (eff2c+eff2d)/2
replace exteff = exteff1 if exteff1 >=0 & exteff1 <=1
replace exteff = exteff2 if exteff2 >=0 & exteff2 <=1
 
* EXTERNAL EFFICACY PRE-ELECTION

gen preeff1=.
replace preeff1 = (v083079c+v083079d-2)/8
tab preeff1
gen preeff2=.
replace preeff2 = (v083080c+v083080d-2)/8
replace preeff2 = -1*(preeff2-1)
gen preeff=.
replace preeff = preeff1 if preeff1>=0 & preeff1<=1
replace preeff = preeff2 if preeff2>=0 & preeff2<=1

* turnout: v085036x
* use as is

gen age2 = age*age 

* south
gen south = .
replace south = 1 if v081204==3
replace south =0 if (v081204==1 | v081204==2 | v081204==4)

* homeowner
gen homeown=.
replace homeown=1 if v083281 == 1
replace homeown=0 if (v083281== 5 | v083281==7) 

* PID strength
gen pidstrength = .
replace pidstrength = 0 if v083098x == 3
replace pidstrength = 1 if v083098x == 2 | v083098x == 4
replace pidstrength = 2 if v083098x == 1 | v083098x == 5
replace pidstrength = 3 if v083098x == 0 | v083098x == 6
replace pidstrength = pidstrength /3
label define pidstrength 0 "0. Independent" 1 "1. Strong partisan"
label values pidstrength pidstrength 

* years in community
gen newmover = .
replace newmover = 1 if v083266a ==0 | v083266a==1
replace newmover = 0 if v083266a >=2 & v083266a <=90

gen move1=.
replace move1 = 1 if v083266a == 0
replace move1 = 0 if v083266a >=1 & v083266a <=90

* care about election
gen care = .
replace care = 1 if v083034 == 1
replace care = .67 if v083034 == 2
replace care = .33 if v083034 == 3
replace care = 0 if v083034 == 4 

* difference of FTs, ANM
gen ftdiff = .
replace ftdiff = (abs(v083037a - v083037b))/100
gen bothpos = .
gen bothneg = .
replace bothpos = 1 if v083037a > 50 & v083037b > 50
replace bothpos = 0 if v083037a <=50 | v083037b <= 50
replace bothneg = 1 if v083037a < 50 & v083037b < 50
replace bothneg = 0 if v083037a >=50 | v083037b >=50
gen ftp = ftdiff * bothpos
gen ftn = ftdiff * bothneg 


* TURNOUT MODELS

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff 

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff p1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff p2_1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff p3

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff p6

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff c1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff b1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff b2

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff b3

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff b6

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff r1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff r2

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff r3

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff r4_1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff r5_1

svy:logit v085036x female hhincome education black talk exteff age age2 south homeown pidstrength newmover care ftdiff r6



*** VOTE CHOICE MODEL 

* voted for mccain
gen mccain=.
replace mccain=1 if v085044a==3
replace mccain=0 if v085044a==1 | v085044a==7

* issue score -- orient all items on liberal(0)-conservative(1)
* Spending and services
gen spend1 = .
replace spend1 = (v083105-1)/6 
replace spend1 = -1*(spend1-1)

* defense 
gen def1 = .
replace def1 = (v083112-1)/6

* jobs
gen jobs1 = .
replace jobs1 = (v083128-1)/6

* blacks
gen blacks1 = .
replace blacks1 = (v083137-1)/6

* living
gen living1 = .
replace living1 = (v083154-1)/6

* gun
gen gun1 = .
replace gun1 = 1 if v083164==3
replace gun1 =.5 if v083164==5
replace gun1 = 0 if v083164==1

* abortion pro life
gen life1 = .
replace life1 = 1 if v085086==1
replace life1 = .67 if v085086==2
replace life1 = .33 if v085086==3
replace life1 = 0 if v085086==4

* v083213 gay adoption
gen nogayadopt = .
replace nogayadopt = 1 if v083213 == 5
replace nogayadopt = 0 if v083213 == 1

gen policylibcon = .
replace policylibcon = (spend1+def1+jobs1+blacks1+living1+gun1+life1+nogayadopt)/8

* knowledge interaction terms
gen p1_policylibcon = .
replace p1_policylibcon = p1 * policylibcon

gen r6_policylibcon=.
replace r6_policylibcon = r6 * policylibcon

* interactions
gen life1p1 =.
gen life1p2_1 =.
gen life1p3 =.
gen life1p6 =.
gen life1c1 =.
gen life1b1 =.
gen life1b2 =.
gen life1b3 =.
gen life1b6 =.
gen life1r1 =.
gen life1r2 =.
gen life1r3 =.
gen life1r4_1 =.
gen life1r5_1 =.
gen life1r6 =.

replace life1p1 = life1*p1
replace life1p2_1 = life1*p2_1
replace life1p3 = life1*p3
replace life1p6 = life1*p6
replace life1c1 = life1*c1
replace life1b1 = life1*b1
replace life1b2 = life1*b2
replace life1b3 = life1*b3
replace life1b6 = life1*b6
replace life1r1 = life1*r1
replace life1r2 = life1*r2
replace life1r3 = life1*r3
replace life1r4_1 = life1*r4_1
replace life1r5_1 = life1*r5_1
replace life1r6 =  life1*r6

gen jobs1p1 =.
gen jobs1p2_1 =.
gen jobs1p3 =.
gen jobs1p6 =.
gen jobs1c1 =.
gen jobs1b1 =.
gen jobs1b2 =.
gen jobs1b3 =.
gen jobs1b6 =.
gen jobs1r1 =.
gen jobs1r2 =.
gen jobs1r3 =.
gen jobs1r4_1 =.
gen jobs1r5_1 =.
gen jobs1r6 =.

replace jobs1p1 = jobs1*p1
replace jobs1p2_1 = jobs1*p2_1
replace jobs1p3 = jobs1*p3
replace jobs1p6 = jobs1*p6
replace jobs1c1 = jobs1*c1
replace jobs1b1 = jobs1*b1
replace jobs1b2 = jobs1*b2
replace jobs1b3 = jobs1*b3
replace jobs1b6 = jobs1*b6
replace jobs1r1 = jobs1*r1
replace jobs1r2 = jobs1*r2
replace jobs1r3 = jobs1*r3
replace jobs1r4_1 = jobs1*r4_1
replace jobs1r5_1 = jobs1*r5_1
replace jobs1r6 =  jobs1*r6

gen def1p1 =.
gen def1p2_1 =.
gen def1p3 =.
gen def1p6 =.
gen def1c1 =.
gen def1b1 =.
gen def1b2 =.
gen def1b3 =.
gen def1b6 =.
gen def1r1 =.
gen def1r2 =.
gen def1r3 =.
gen def1r4_1 =.
gen def1r5_1 =.
gen def1r6 =.

replace def1p1 = def1*p1
replace def1p2_1 = def1*p2_1
replace def1p3 = def1*p3
replace def1p6 = def1*p6
replace def1c1 = def1*c1
replace def1b1 = def1*b1
replace def1b2 = def1*b2
replace def1b3 = def1*b3
replace def1b6 = def1*b6
replace def1r1 = def1*r1
replace def1r2 = def1*r2
replace def1r3 = def1*r3
replace def1r4_1 = def1*r4_1
replace def1r5_1 = def1*r5_1
replace def1r6 =  def1*r6


** REGRESSION
svy:logit mccain life1p1 life1 p1 
svy:logit mccain life1p2_1 life1 p2_1 
svy:logit mccain life1p3 life1 p3 
svy:logit mccain life1p6 life1 p6 
svy:logit mccain life1c1 life1 c1 
svy:logit mccain life1b1 life1 b1 
svy:logit mccain life1b2 life1 b2 
svy:logit mccain life1b3 life1 b3 
svy:logit mccain life1b6 life1 b6 
svy:logit mccain life1r1 life1 r1 
svy:logit mccain life1r2 life1 r2 
svy:logit mccain life1r3 life1 r3 
svy:logit mccain life1r4_1 life1 r4_1 
svy:logit mccain life1r5_1 life1 r5_1 
svy:logit mccain life1r6 life1 r6 

svy:logit mccain jobs1p1 jobs1 p1 
svy:logit mccain jobs1p2_1 jobs1 p2_1 
svy:logit mccain jobs1p3 jobs1 p3 
svy:logit mccain jobs1p6 jobs1 p6 
svy:logit mccain jobs1c1 jobs1 c1 
svy:logit mccain jobs1b1 jobs1 b1 
svy:logit mccain jobs1b2 jobs1 b2 
svy:logit mccain jobs1b3 jobs1 b3 
svy:logit mccain jobs1b6 jobs1 b6 
svy:logit mccain jobs1r1 jobs1 r1 
svy:logit mccain jobs1r2 jobs1 r2 
svy:logit mccain jobs1r3 jobs1 r3 
svy:logit mccain jobs1r4_1 jobs1 r4_1 
svy:logit mccain jobs1r5_1 jobs1 r5_1 
svy:logit mccain jobs1r6 jobs1 r6 

svy:logit mccain def1p1 def1 p1 
svy:logit mccain def1p2_1 def1 p2_1 
svy:logit mccain def1p3 def1 p3 
svy:logit mccain def1p6 def1 p6 
svy:logit mccain def1c1 def1 c1 
svy:logit mccain def1b1 def1 b1 
svy:logit mccain def1b2 def1 b2 
svy:logit mccain def1b3 def1 b3 
svy:logit mccain def1b6 def1 b6 
svy:logit mccain def1r1 def1 r1 
svy:logit mccain def1r2 def1 r2 
svy:logit mccain def1r3 def1 r3 
svy:logit mccain def1r4_1 def1 r4_1 
svy:logit mccain def1r5_1 def1 r5_1 
svy:logit mccain def1r6 def1 r6 



** MARCH 18, 2012
* Estimate value of partially correct responses
* Step 1 of 4, create a political knowledge variable, pk, for the DV
* this is built from knowing senate majority, house majority, party placement, candidate placement, and cheney as VP
gen pk=o
replace pk=0
replace pk = plr +clr +hm +sm +c1
replace pk = pk/5
tab pk
* Step 2 of 4, create the dummy variables showing partial credit
gen p_part0 = 0
replace p_part0 = 0
replace p_part0 = 1 if p6 > .32 & p6 < .34
gen p_part1 = 0
replace p_part1 = 0
replace p_part1 = 1 if p6 > .65 & p6 < .68

gen b_part0 = 0
replace b_part0 = 0
replace b_part0 = 1 if b6 > .32 & b6 < .34
gen b_part1 = 0
replace b_part1 = 0
replace b_part1 = 1 if b6 > .65 & b6 < .68

gen r_part0 = 0
replace r_part0 = 0
replace r_part0 = 1 if r6 > .32 & r6 < .34
gen r_part1 = 0
replace r_part1 = 0
replace r_part1 = 1 if r6 > .65 & r6 < .68

* Step 3 of 4, regress 
regress pk p_part0 p_part1 p1 
regress pk b_part0 b_part1 b1
regress pk r_part0 r_part1 r1

* Step 4 of 4, calculate ratios of results
* Do this manually
* The ratio of the part0 coefficient to the full credit coefficient is the score for minimal partial credit
* the ratio of the part1 coefficient to the full credit coefficient is the score for maximal partial (not full) credit
* Voila. 
* Results for Pelosi are .463 and .748
* Results for Brown are .674 and .789
* Results for Roberts are .867 and 1


gen p7 = p6
replace p7=p6
replace p7 = .463 if p7 > .32 & p7 < .34
replace p7 = .748 if p7 > .65 & p7 < .68  

gen def1p7 = . 
replace def1p7 =  def1*p7
svy:logit mccain def1p7 def1 p7
