use "/Users/spencerpiston/Dropbox/Data/CCES/From YouGov/CCES14_SCI_Feb2015.dta", clear
set more off

*IVs

*age
gen age=2014-birthyr
gen age0to1=(age-18)/70
tab age0to1, miss

*male
gen male=0
replace male=1 if gender==1
tab male gender, miss
*female
gen female=0
replace female=1 if gender==2
tab female gender, miss

*race
gen white=0
recode white 0=1 if race==1 & hispanic~=1
gen black=0
recode black 0=1 if race==2 & hispanic~=1
rename hispanic hispCCES
gen hispanic=0
recode hispanic 0=1 if race==3|hispCCES==3
gen otherrace=0
recode otherrace 0=1 if race==4|race==5|race==6|race==7|race==8
recode otherrace 1=0 if hispCCES==1

*married
gen married=0
recode married 0=1 if marstat==1
tab married marstat, miss

*south
gen south=0
recode south 0=1 if region==3
tab south region, miss

*unemployed
gen unemployed=0
recode unemployed 0=1 if employ==4
tab unemployed employ, miss

*union
recode union 1=1 2=0 3=0 8=.
tab union

*healthins
gen healthins=1
replace healthins=0 if healthins_6==1
replace healthins=. if healthins_6==.
tab healthins healthins_6, miss

*ownhome
recode ownhome 2/8=0
tab ownhome

*ownstock
gen ownstock=investor
recode ownstock 2=0 8=.
tab ownstock investor, miss

*student loan
gen sloan=edloan
recode sloan 2=0 998=.
tab edloan sloan, miss

*income 
*NOTE MANY MISSING VALUES
gen inc0to1=faminc
recode inc0to1 32=. 97=.
replace inc0to1=(inc0to1-1)/15
tab inc0to1 faminc, miss
*inc0to1big
gen inc0to1big=inc0to1
replace inc0to1big=0 if faminc==97
tab inc0to1big
*incmiss
gen incmiss=0
replace incmiss=1 if faminc==97

*education
gen educ0to1=educ
replace educ0to1=(educ0to1-1)/5
tab educ0to1 educ, miss

*bornagain
gen bornagain=0
replace bornagain=1 if pew_bornagain==1
replace bornagain=. if pew_bornagain==8
tab pew_bornagain bornagain, miss

*church attendance
gen churchatt=pew_churatd
recode churchatt 7=6 8=.
replace churchatt=((churchatt*(-1))+6)/5
tab pew_churatd churchatt, miss

*party id
gen pidrep0to1=pid7
recode pidrep0to1 98=. 99=. 8=4
replace pidrep0to1=(pidrep0to1-1)/6 
tab pidrep0to1 pid7, miss

*ideology
*note that 'not sure' is put in the middle of the scale
gen ideo0to1=CC334A
recode ideo0to1 98=. 8=4
replace ideo0to1=((ideo0to1*(-1))+7)/6
tab ideo0to1 CC334A, miss
replace ideo0to1=(ideo0to1*(-1))+1

*immigrant
gen immigrant=0
replace immigrant=1 if immstat==1|immstat==2
tab immigrant immstat, miss

*third generation
gen thirdgen=0
recode thirdgen 0=1 if immstat==5
tab thirdgen immstat, miss

*classid
gen rich=0
replace rich=1 if SCI359==1
tab rich SCI359, miss
gen middlec=0
replace middlec=1 if SCI359==2
tab middlec SCI359, miss
gen workingc=0
replace workingc=1 if SCI359==3
tab workingc SCI359, miss
gen poor=0
replace poor=1 if SCI359==4
tab poor SCI359, miss
gen otherclass=0
replace otherclass=1 if SCI359==5
tab otherclass SCI359, miss

*disgust sensitivity
gen disgdp=SCI360
recode disgdp 8=.
gen disgbo=SCI361
recode disgbo 8=.
gen disgmo=SCI362
recode disgmo 8=.
gen disgsw=SCI363
recode disgsw 8=.
alpha disgdp disgbo disgmo disgsw, gen(ds) item
replace ds=(ds-1)/6

*worknotluck - Which of the following two statements better describes what you believe? 1. In the long run, hard work usually brings a better life. 2. Hard work doesn't generally bring success - it's more a matter of luck and connections.
gen worknotluck=SCI380
recode worknotluck 1=1 2=0 8=.
tab SCI380 worknotluck, miss

*likelyrich - How likely are you to become RICH at some point in the future?
*higher values indicate very likely
gen likelyrich=SCI381
recode likelyrich 8=. 1=1 2=.67 3=.33 4=0 9=.
tab SCI381 likelyrich, miss

*likelypoor - How likely are you to become POOR at some point in the future?
gen likelypoor=SCI382
recode likelypoor 8=. 1=1 2=.67 3=.33 4=0 9=.
tab SCI382 likelypoor, miss

*emotions toward class groups
*compassion for the poor
gen emopc=SCI301
recode emopc 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI301 emopc, miss
*sympathy for the poor
gen emops=SCI302
recode emops 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI302 emops, miss
*anger toward the poor
gen emopa=SCI303
recode emopa 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI303 emopa, miss
*resentment toward the poor
gen emopr=SCI304
recode emopr 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI304 emopr, miss

*compassion for the rich
gen emorc=SCI305
recode emorc 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI305 emorc, miss
*sympathy for the rich
gen emors=SCI306
recode emors 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI306 emors, miss
*anger toward the rich
gen emora=SCI307
recode emora 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI307 emora, miss
*resentment toward the rich
gen emorr=SCI308
recode emorr 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI308 emorr, miss

*deservingness - class groups
gen poorlesstemp=SCI309
recode poorlesstemp 8=.
gen poorless=(poorlesstemp-1)/6
tab poorless SCI309, miss
gen richlesstemp=SCI310
recode richlesstemp 8=.
gen richless=(richlesstemp-1)/6
tab richless SCI310, miss

*index - sympathy for the poor
alpha emops emopc poorless, gen(poorind) item
*index - resentment of the rich
alpha emorr emora richless, gen(richind) item


*thermometers
*homeless thermometer
gen homelesstherm=SCI364
recode homelesstherm 998=.
gen homelesstherm0to1=homelesstherm/100
tab homelesstherm0to1
*rich thermometer
gen richtherm=SCI365
recode richtherm 998=.
gen richtherm0to1=richtherm/100
tab richtherm0to1
*poor thermometer
gen poortherm=SCI366
recode poortherm 998=.
gen poortherm0to1=poortherm/100
tab poortherm0to1
*atheist thermometer
gen atheisttherm=SCI367
recode atheisttherm 998=.
gen atheisttherm0to1=atheisttherm/100
tab atheisttherm0to1



*trust - Generally speaking, how often do you think you can trust federal civil servants to do what’s right?
gen trustdoright=SCI325
recode trustdoright 8=. 4=0 3=.33 2=.67 1=1
tab SCI325 trustdoright, miss
*trust - How much confidence do you have in federal civil servants? 
gen trustconf=SCI326
recode trustconf 8=. 4=0 3=.33 2=.67 1=1
tab SCI326 trustconf, miss
alpha trustdoright trustconf, item

*govt competent - The people working for the federal government are competent.
gen govtcomp=SCI327
recode govtcomp 8=.
recode govtcomp 1=1 2=.75 3=.5 4=.25 5=0
tab SCI327 govtcomp, miss

*govt respect - In my own interactions with the people working for the federal government I have been treated with respect.
gen govtresp=SCI328
recode govtresp 8=.
recode govtresp 1=1 2=.75 3=.5 4=.25 5=0
tab SCI328 govtresp, miss

*limited government - The government has gone too far in regulating business and interfering with the free enterprise system. 
gen limgovttoofar=SCI311
recode limgovttoofar 8=. 1=1 2=.75 3=.5 4=.25 5=0
tab SCI311 limgovttoofar, miss
*limited government reverse coded - The government should regulate major companies, industries, and institutions to be sure they don’t take advantage of the public.
gen limgovtregREV=SCI312
recode limgovtregREV 8=. 1=0 2=.25 3=.5 4=.75 5=1
tab SCI312 limgovtregREV, miss

*limgovt1 - We need a strong government to handle today’s complex social problems.
gen limgovt1REV=SCI350
recode limgovt1REV 1=0 2=.25 3=.5 4=.75 5=1 8=.
tab SCI350 limgovt1REV, miss
*limgovt2 - The main reason government has become bigger over the years is because it has gotten involved in things that people should do for themselves.
gen limgovt2=SCI351
recode limgovt2 1=1 2=.75 3=.5 4=.25 5=0 8=.
tab SCI351 limgovt2, miss

factor govtcomp govtresp limgovt1REV limgovt2 limgovttoofar limgovtregREV

*egalitarianism
*egalworrylessREV - This country would be better off if we worried less about how equal people are.
gen egalworrylessREV=SCI348
recode egalworrylessREV 1=0 2=.25 3=.5 4=.75 5=1 8=.
tab SCI348 egalworrylessREV, miss

*humanitarianism
*hum1 - A person should always be concerned about the well-being of others.
gen hum1=SCI376
recode hum1 1=1 2=.75 3=.5 4=.25 5=0 8=.
tab SCI376 hum1, miss
*hum2REV - People tend to pay attention to the well-being of others more often than they should.
gen hum2REV=SCI378
recode hum2REV 1=0 2=.25 3=.5 4=.75 5=1 8=.
tab SCI378 hum2REV, miss
alpha hum1 hum2REV, gen(hum) item

*tax burden too much
*For each of the following people, please indicate whether they pay MORE THAN THEY SHOULD in federal income taxes, about the RIGHT AMOUNT, or LESS THAN THEY SHOULD:
*taxbtoomuchyou
gen taxbtoomuchyou=SCI352
recode taxbtoomuchyou 1=1 2=0 3=.5 8=.
tab SCI352 taxbtoomuchyou, miss
*taxbtoomuchrichpeople
gen taxbtoomuchrich=SCI353
recode taxbtoomuchrich 1=1 2=0 3=.5 8=.
tab SCI353 taxbtoomuchrich, miss
*taxbtoomuchpoorpeople
gen taxbtoomuchpoor=SCI354
recode taxbtoomuchpoor 1=1 2=0 3=.5 8=.
tab SCI354 taxbtoomuchpoor, miss

*lazy stereotype
gen stlazywtemp=SCI355
recode stlazywtemp 8=.
gen stlazyw=(stlazywtemp-1)/6
tab SCI355 stlazyw, miss
gen stlazybtemp=SCI356
recode stlazybtemp 8=.
gen stlazyb=(stlazybtemp-1)/6
tab SCI356 stlazyb, miss
gen stlazyhtemp=SCI357
recode stlazyhtemp 8=.
gen stlazyh=(stlazyhtemp-1)/6
tab SCI357 stlazyh, miss
gen stlazyatemp=SCI358
recode stlazyatemp 8=.
gen stlazya=(stlazyatemp-1)/6
tab SCI358 stlazya, miss

*blacks lazier than whites
gen stlazybw=(stlazyb-stlazyw+1)/2
tab stlazybw

*hispanics lazier than whites
gen stlazyhw=(stlazyh-stlazyw+1)/2
tab stlazyhw

*racial resentment
gen raceresirish=CC422a
recode raceresirish 8=. 9=. 1=1 2=.75 3=.5 4=.25 5=0
tab CC422a raceresirish, miss
gen raceresgenREV=CC422b
recode raceresgenREV 8=. 9=. 1=0 2=.25 3=.5 4=.75 5=1
tab CC422b raceresgenREV, miss
alpha raceresirish raceresgenREV, gen(raceres) item

*econ worse - "Would you say that over the past year the nation's economy has..."
gen econworse=CC14_302
recode econworse 8=. 1=0 2=.25 3=.5 4=.75 5=1 6=.5
tab CC14_302 econworse, miss

*PISTON CANDIDATE EXPERIMENT
gen condcand=SCI401_rand
*help the rich - nonpartisan
gen condhelprichnp=0
recode condhelprichnp 0=1 if condcand==5
*help our district - nonpartisan
gen condhelpdist=0
recode condhelpdist 0=1 if condcand==7
*hurt the rich - nonpartisan
gen condhurtrichnp=0
recode condhurtrichnp 0=1 if condcand==6
*hurt the district
gen condhurtdist=0
recode condhurtdist 0=1 if condcand==8
*help the rich - and he's a Democrat
gen condhelprichd=0
recode condhelprichd 0=1 if condcand==3
*hurt the rich - and he's a Democrat
gen condhurtrichd=0
recode condhurtrichd 0=1 if condcand==4
*help the rich - and he's a Republican
gen condhelprichr=0
recode condhelprichr 0=1 if condcand==1
*hurt the rich - and he's a Republican
gen condhurtrichr=0
recode condhurtrichr 0=1 if condcand==2

*help the rich - big (all 3 conditions combined)
gen condhelprichbig=0
recode condhelprichbig 0=1 if condhelprichnp==1|condhelprichd==1|condhelprichr==1
*hurt the rich - big (all 3 conditions combined)
gen condhurtrichbig=0
recode condhurtrichbig 0=1 if condhurtrichnp==1|condhurtrichd==1|condhurtrichr==1
*dem - big (all 2 conditions combined
gen conddem=0
recode conddem 0=1 if condhelprichd==1|condhurtrichd==1
*rep - big (all 2 conditions combined)
gen condrep=0
recode condrep 0=1 if condhelprichr==1|condhurtrichr==1

*PISTON METTLERESQUE EXPERIMENTS
*Home Mortgage condition - information
gen hmcondinfo=.
replace hmcondinfo=1 if SCI403_rand==2
replace hmcondinfo=0 if SCI403_rand==1
tab SCI403_rand hmcondinfo, miss
*Earned Income Tax Credit condition - information
gen eicondinfo=.
replace eicondinfo=1 if SCI405_rand==2
replace eicondinfo=0 if SCI405_rand==1
tab SCI405_rand eicondinfo, miss

*PISTON ESTATE TAX EXPERIMENT
*what percent of people are eligible (ask)
gen etpercent=SCI406
recode etpercent 998=. 999=.
tab etpercent

*tell condition (rather than ask)
gen etcondtell=.
replace etcondtell=0 if SCI406_rand==1|SCI406_rand==2
replace etcondtell=1 if SCI406_rand==3|SCI406_rand==4
tab etcondtell SCI406_rand, miss
*"death tax" condition (rather than estate)
gen etconddeath=.
replace etconddeath=1 if SCI406_rand==1|SCI406_rand==3
replace etconddeath=0 if SCI406_rand==2|SCI406_rand==4
tab etconddeath SCI406_rand, miss

*PISTON DEACTIVATION STEREOTYPES EXPERIMENT
gen deportcondcont=0
replace deportcondcont=1 if SCI425_rand==1
gen deportcondobama=0
replace deportcondobama=1 if SCI425_rand==2
gen deportconddem=0
replace deportconddem=1 if SCI425_rand==3

*TIM RYAN EXPERIMENT
*CONDITION: does respondent get $200
gen get200=0
replace get200=1 if SCI320_treat==4|SCI320_treat==5|SCI320_treat==6
tab SCI320_treat get200, miss
lab def get200 0 "R No benefit" 1 "R Gets $200"
lab val get200 get200
*CONDITION: does the policy hurt the rich
gen hurtrich=0
replace hurtrich=1 if SCI320_treat==3|SCI320_treat==6 
replace hurtrich=2 if SCI320_treat==2|SCI320_treat==5
lab def hurtrich 0 "Rich the same" 1 "Hurt rich" 2 "Rich benefit"
lab val hurtrich hurtrich
tab SCI320_treat hurtrich, miss

*SCOTT CLIFFORD EXPERIMENT
*Homeless experimental conditions
gen hcondtc=0
recode hcondtc 0=1 if SCI409_rand==4
gen hcondc=0
recode hcondc 0=1 if SCI409_rand==1
gen hcondf=0
recode hcondf 0=1 if SCI409_rand==2
gen hcondd=0
recode hcondd 0=1 if SCI409_rand==3
lab def hcondd 0 "Control Condition" 1 "Disgust Condition"
lab val hcondd hcondd


*DVs

*Candidate experiment Piston DVs
gen suptaylortemp=SCI401 
gen suptaylorrev=(suptaylortemp-1)/6
gen suptaylor=(suptaylorrev*(-1))+1
tab SCI401 suptaylor, miss
*support for Taylor 3 category
gen suptaylor3cat=suptaylor
replace suptaylor3cat=0 if suptaylor<.5
replace suptaylor3cat=1 if suptaylor>.5 & suptaylor<=1
tab SCI401 suptaylor3cat, miss
gen suptaylor3catbig=suptaylor3cat*2

*taylor thermometer
gen taylortherm=SCI402
recode taylortherm 998=.
gen taylortherm0to1=taylortherm/100

*turnout intention
gen turnoutorint=CC354
recode turnoutorint 1=1 2=0 3=1 4=1 5=0 6=0
tab CC354 turnoutorint, miss

*turnout 2014
gen turnout=0
replace turnout=. if CC401==8|CC401==9|CC401==.
replace turnout=1 if CC401==5
tab CC401 turnout, miss

*vote for the democrat in the senate election
gen votedemsenate=.
recode votedemsenate .=1 if CC410b==1
recode votedemsenate .=0 if CC410b==2
tab CC410b votedemsenate, miss

*vote for the democrat in the gubernatorial election
gen votedemgov=.
recode votedemgov .=1 if CC411==1
recode votedemgov .=0 if CC411==2
tab CC411 votedemgov, miss

*vote for the democrat in the house election
gen votedemhouse=.
recode votedemhouse .=1 if CC412==1
recode votedemhouse .=0 if CC412==2
tab CC412 votedemhouse, miss

*candidates/public figures
*Obama approval - "We'd now like to ask some questions about the people who represent you in Washington D.C. Do you approve of the way each is doing their job..."
gen obamaapp=CC14_308a
recode obamaapp 8=. 5=.5 1=1 2=.75 3=.25 4=0
tab CC14_308a obamaapp, miss

*tea party support
*dk's coded as missing
gen tp=CC424
replace tp=. if tp>=6
replace tp=((tp*(-1))+5)/4
tab CC424 tp, miss
*dk's coded in the middle
gen tpbig=tp
recode tpbig .=.5 if CC424==6

*ACA
*voteACA2010 - would you have voted for the affordable care act if you were in Congress in 2010
gen voteACA2010=CC14_324_1
recode voteACA2010 8=. 1=1 2=0
tab CC14_324_1 voteACA2010, miss
*repealACA - would you vote to repeal the affordable care act if you were in Congress today?
gen repealACA=CC14_324_2
recode repealACA 8=. 1=1 2=0
tab CC14_324_2 repealACA, miss
*staterefACA - should your state refuse to implement the expansion of health care for poor people, even if it costs the state federal Medicaid funds?
gen staterefACA=CC14_324_3
recode staterefACA 8=. 1=1 2=0
tab CC14_324_3 staterefACA, miss

*middle class tax cut act - would extend bush era tax cuts for incomes below $200k; would increase budget deficit by an estimated $250 billion
gen mctca=CC14_325_3
recode mctca 1=1 2=0 8=.
tab CC14_325_3 mctca, miss
*tax hike prevention act - would extend bush era tax cuts for all individuals, regardless of income; would increase budget deficit by an estimated $405 billion
gen thpa=CC14_325_4
recode thpa 1=1 2=0 8=.
tab CC14_325_4 thpa, miss
*four category of the two previous measures - purpose is to isolate those who want to refuse tax cuts on ONLY the rich
gen taxcut4cat=.
replace taxcut4cat=1 if mctca==0 & thpa==0
replace taxcut4cat=2 if mctca==0 & thpa==1
replace taxcut4cat=3 if mctca==1 & thpa==0
replace taxcut4cat=4 if mctca==1 & thpa==1
lab def taxcut4cat 1 "Oppose Both" 2 "Oppose MCTCA, Support THPA" 3 "Support MCTCA, Oppose THPA" 4 "Support Both"
lab val taxcut4cat taxcut4cat

*strengthen enforcement of Clean Air Act even if it costs jobs
gen CAAnotjobs=CC14_326_4
recode CAAnotjobs 1=1 2=0 8=.
tab CC14_326_4 CAAnotjobs, miss


*TAX BREAK DVs (Faricy/Ellis)
*Here is a list of some programs that can allow people to reduce their federal income tax. Please tell me whether you strongly support, somewhat support, neither support nor oppose, somewhat oppose, or strongly oppose each program. 
*higher values indicate support
*tax break employer sponsored health care - A tax break which allows citizens to pay no federal income tax on their contributions to employer-sponsored health care plans. 
gen tbeshc=SCI336
recode tbeshc 8=.
recode tbeshc 1=1 2=.75 3=.5 4=.25 5=0
tab SCI336 tbeshc, miss
*tax break charity - A tax break which allows citizens to reduce the amount they pay in income taxes based on how much they donate to charity.
gen tbchar=SCI337
recode tbchar 8=.
recode tbchar 1=1 2=.75 3=.5 4=.25 5=0
tab SCI337 tbchar, miss
*tax break home mortgage - A tax break which allows citizens to reduce the amount they pay in income taxes based on how much they pay in interest on their home mortgages.
gen tbhome=SCI338
recode tbhome 8=.
recode tbhome 1=1 2=.75 3=.5 4=.25 5=0
tab SCI338 tbhome, miss
*tax break low-income earners - A tax break which subsidizes the wages of low-income earners by increasing the size of the federal income tax refund that these citizens receive. 
gen tbeitc=SCI339
recode tbeitc 8=.
recode tbeitc 1=1 2=.75 3=.5 4=.25 5=0
tab SCI339 tbeitc, miss
*tax break for employer-sponsored retirement plans - A tax break which allows citizens to pay no federal income tax on the amount they contribute to employer-sponsored retirement plans.
gen tbesrp=SCI340
recode tbesrp 8=.
recode tbesrp 1=1 2=.75 3=.5 4=.25 5=0
tab SCI340 tbesrp, miss
*tax break for children's college education - A tax break which allows parents to reduce the amount they pay in income taxes based on how much they pay for their children’s college education.  
gen tbcollege=SCI341
recode tbcollege 8=.
recode tbcollege 1=1 2=.75 3=.5 4=.25 5=0
tab SCI341 tbcollege, miss
*tax break for student loans - A tax break which allows citizens to reduce the amount they pay in income taxes based on how much they pay in interest on their student loans. 
gen tbsloan=SCI342
recode tbsloan 8=.
recode tbsloan 1=1 2=.75 3=.5 4=.25 5=0
tab SCI342 tbsloan, miss

*GOVERNMENT SPENDING DVs (Faricy/Ellis)
*We are faced with many problems in this country, none of which can be solved easily or inexpensively. I'm going to name some of these problems, and for each one I'd like you to tell me whether you think we're spending too much money on it, too little money, or about the right amount.
*higher values indicate that government is spending too little
*aid poor - Aid to the poor
gen gsaidpoor=SCI343
recode gsaidpoor 1=0 2=1 3=.5 8=.
tab SCI343 gsaidpoor, miss
*public health - Improving public health
gen gsph=SCI344
recode gsph 1=0 2=1 3=.5 8=.
tab SCI344 gsph, miss
*unemployed - Assistance to the unemployedgen gsunemp=SCI345
recode gsunemp 1=0 2=1 3=.5 8=.
tab SCI345 gsunemp, miss*elderly - Assistance to the elderlygen gseld=SCI346recode gseld 1=0 2=1 3=.5 8=.
tab SCI346 gseld, miss
*college - Making college affordable 
gen gscoll=SCI347recode gscoll 1=0 2=1 3=.5 8=.
tab SCI347 gscoll, miss

*STATE SPENDING DVs (Common Content)
*State Legislatures must make choices when making spending decisions on important state programs. How would you like your legislature to spend money on each of the five areas below?
*welfare
gen sswelfare=CC426_1
recode sswelfare 8=. 9=. 1=1 2=.75 3=.5 4=.25 5=0
tab CC426_1 sswelfare, miss
*health care
gen sshealthcare=CC426_2
recode sshealthcare 8=. 9=. 1=1 2=.75 3=.5 4=.25 5=0
tab CC426_2 sshealthcare, miss
*education
gen sseduc=CC426_3
recode sseduc 8=. 9=. 1=1 2=.75 3=.5 4=.25 5=0
tab CC426_3 sseduc, miss
*law enforcement
gen ssle=CC426_4
recode ssle 8=. 9=. 1=1 2=.75 3=.5 4=.25 5=0
tab CC426_4 ssle, miss
*transportation/infrastructure
gen sstrans=CC426_5
recode sstrans 8=. 9=. 1=1 2=.75 3=.5 4=.25 5=0
tab CC426_5 sstrans, miss

*SCOTT CLIFFORD IMMIGRATION DVs
*deport child migrants
gen deportcm=SCI425
recode deportcm 8=.
replace deportcm=((deportcm*(-1))+7)/6
tab SCI425 deportcm, miss

*grant legal status to all illegal immigrants with jobs, paid taxes, no felonies
gen grantlegal=CC14_322_1
recode grantlegal 1=1 2=0
tab grantlegal CC14_322_1, miss

*increase the number of border patrols US/Mexico
gen incborder=CC14_322_2
recode incborder 1=1 2=0
tab incborder CC14_322_2, miss

*allow police to question anyone they think may be in the country illegally
gen allowpolice=CC14_322_3
recode allowpolice 1=1 2=0
tab allowpolice CC14_322_3, miss

*fine businesses that hire illegal immigrants
gen finebus=CC14_322_4
recode finebus 1=1 2=0
tab finebus CC14_322_4, miss

*identify and deport illegal immigrants
gen idanddep=CC14_322_5
recode idanddep 1=1 2=0
tab idanddep CC14_322_5, miss

alpha deportcm grantlegal incborder allowpolic finebus idanddep, gen(immopind) item

*Immigration DVs - Creating two indices via factor analysis with polychoric correlations
polychoric deportcm grantlegal incborder allowpolic finebus idanddep
display r(sum_w)
global N = r(sum_w)
matrix r = r(R)
factormat r, n($N) factors(2) ml
rotate, promax blanks(.3)
predict Fine Deport

*Immigration DVs - Creating additive indices inspired by EFA above
gen FineOrd = incborder + allowpolice + finebus
gen grantlegalrev = grantlegal
recode grantlegalrev 0=1 1=0
gen deportcmdi = deportcm
recode deportcmdi 0/.5=0 .6/1=1
gen DeportOrd = deportcmdi + grantlegalrev + idanddep

*SCOTT CLIFFORD HOMELESS DVs

*government aid to homeless
gen gah=SCI410
recode gah 8=.
replace gah=((gah*(-1))+7)/6
tab gah SCI410, miss
*government aid to homeless 3 category
gen gah3cat=.
replace gah3cat=0 if gah<.5
replace gah3cat=1 if gah==.5
replace gah3cat=2 if gah>.5 & gah<=1
tab gah3cat gah, miss

*government subsidize housing to homeless
gen ghh=SCI411
recode ghh 8=.
replace ghh=((ghh*(-1))+7)/6
tab ghh SCI411, miss
*government subsidize housing to homeless 3 category
gen ghh3cat=.
replace ghh3cat=0 if ghh<.5
replace ghh3cat=1 if ghh==.5
replace ghh3cat=2 if ghh>.5 & ghh<=1
tab ghh3cat ghh, miss

*government ban sleeping in public areas
gen gbs=SCI412
recode gbs 8=.
replace gbs=((gbs*(-1))+7)/6
tab gbs SCI412, miss
*government ban sleeping in public areas 3 category
gen gbs3cat=.
replace gbs3cat=0 if gbs<.5
replace gbs3cat=1 if gbs==.5
replace gbs3cat=2 if gbs>.5 & gbs<=1
tab gbs3cat gbs, miss

*government ban panhandling
gen gbp=SCI413
recode gbp 8=.
replace gbp=((gbp*(-1))+7)/6
tab gbp SCI413, miss
*government ban panhandling 3 category
gen gbp3cat=.
replace gbp3cat=0 if gbp<.5
replace gbp3cat=1 if gbp==.5
replace gbp3cat=2 if gbp>.5 & gbp<=1
tab gbp3cat gbp, miss

*index of government banning
alpha gbs gbp, gen(gb) item

*attributions for homelessness
*laziness
gen homeattlazy=SCI414
recode homeattlazy 8=.
replace homeattlazy=((homeattlazy*(-1))+4)/3
tab SCI414 homeattlazy, miss
*factors outside their control
gen homeattfact=SCI415
recode homeattfact 8=.
replace homeattfact=((homeattfact*(-1))+4)/3
tab SCI415 homeattfact, miss
*their choice to be homeless
gen homeattchoice=SCI416
recode homeattchoice 8=.
replace homeattchoice=((homeattchoice*(-1))+4)/3
tab SCI416 homeattchoice, miss
*lack of affordable housing
gen homeattlack=SCI417
recode homeattlack 8=.
replace homeattlack=((homeattlack*(-1))+4)/3
tab SCI417 homeattlack, miss
*greedy rich people
gen homeattgrp=SCI418
recode homeattgrp 8=.
replace homeattgrp=((homeattgrp*(-1))+4)/3
tab SCI418 homeattgrp, miss

*attributions of homeless index
alpha homeattlazy homeattchoice homeattlack homeattfact homeattgrp, gen(homeatt) item
replace homeatt=(homeatt+.4)/1.2333334
tab homeatt
egen homeattint = rowmean(homeattlazy homeattchoice)
tab homeattint
egen homeattext = rowmean(homeattlack homeattfact homeattgrp)
tab homeattext

*METTLERESQUE DVs WAVE 1
*Home Mortgage Interest Tax Credit Wave 1
gen hmitcw1=SCI368
recode hmitcw1 8=.
replace hmitcw1=((hmitcw1*(-1))+7)/6
tab SCI368 hmitcw1, miss
*Home Mortgage Interest Tax Credit Wave 2
gen hmitcw2=SCI403
recode hmitcw2 8=.
replace hmitcw2=((hmitcw2*(-1))+7)/6
tab SCI403 hmitcw2, miss

*Retirement Savings Contribution Tax Credit Wave 1
gen rsctcw1=SCI369
recode rsctcw1 8=.
replace rsctcw1=((rsctcw1*(-1))+7)/6
tab SCI369 rsctcw1, miss
*Earned Income Tax Credit Wave 1
gen eitcw1=SCI370
recode eitcw1 8=.
replace eitcw1=((eitcw1*(-1))+7)/6
tab SCI370 eitcw1, miss
*Earned Income Tax Credit Wave 2
gen eitcw2=SCI405
recode eitcw2 8=.
replace eitcw2=((eitcw2*(-1))+7)/6
tab SCI405 eitcw2, miss

*estate/death tax opinion
gen etax=SCI407
replace etax=((etax*(-1))+7)/6
tab SCI407 etax, miss

*TIM RYAN DVs
*do you like the policy or not
gen favpolicy=((SCI320*(-1))+7)/6
tab SCI320 favpolicy, miss
*would you (those who make under $300k) be better off
gen rbetter=SCI321
recode rbetter 8=.
replace rbetter=((rbetter*(-1))+7)/6
tab SCI321 rbetter, miss
*would rich (those who make more than $300k) be better off
gen richbetter=SCI322
recode richbetter 8=.
replace richbetter=((richbetter*(-1))+7)/6
tab SCI322 richbetter, miss
*would you worry about the deficit more (rather than less)?
gen worrydefmore=SCI323
recode worrydefmore 8=.
replace worrydefmore=((worrydefmore*(-1))+7)/6
tab SCI323 worrydefmore, miss
*would deficit expand (rather than shrink)
gen defexp=SCI324
recode defexp 98=.
replace defexp=((defexp*(-1))+9)/8
tab SCI324 defexp, miss

gen gbsbig=gbs*6
gen gbpbig=gbp*6

lab var hcondtc "True Control - Subj Read Nothing"
lab var hcondc "Control - Mention Homeless"
lab var hcondf "Fear Condition - Unruly Homeless"
lab var hcondd "Disgust Condition - Unclean Homeless"
lab var gah "Increase Govt Aid to Homeless"
lab var ghh "Govt Subsidize Housing for Homeless"
lab var gbs "Govt Ban Sleeping in Public Areas"
lab var gbp "Govt Ban Panhandling"
lab var ds "Disgust Sensitivity"
lab var pidrep0to1 "Party ID (Rep.)"
lab var ideo0to1 "Ideology (Cons.)"
lab var educ0to1 "Education"
lab var south "South"
lab var inc0to1big "Income"
lab var incmiss "Income - Missing"
lab var unemp "Unemployed"
lab var male "Male"
lab var age0to1 "Age"
lab var hispanic "Hispanic"
lab var black "Black"
lab var otherrace "Other Race"
lab var churchatt "Church Attendance"

save "/Users/spencerpiston/Dropbox/Data/CCES/From YouGov/CCES14_SCI_Feb2015_constructed.dta", replace

*do analysis of blaming rich for homelessness
*didn't code whether resp owns a gun
*didn't do all possible indices (e.g., class)
*didn't do church attendance
*didn't (yet) do all the common content
*didn't do a lot of specific governor/senator/etc. races - preferences and vote choice
*zip code
