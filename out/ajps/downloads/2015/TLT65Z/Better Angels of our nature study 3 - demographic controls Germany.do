***G-CCAP recodes for vote analysis 7th December 2011***

****Immigration attitudes:
***v263: Agree/disagree imm contributes to competitiveness of econ
***v264: Agree/disagree - our culture is not perfect, but is superior to others 
***v265: Agree/disagree - we shld restrict immigration more than now
***v266: Agree/disagre - years of discrim mean minorities can't get out of lower classes
***v267: Agree/disagree - minorities have got less than they deserve in recent years
***v268: Agree/disagree - Minorities don't try hard enough; if they did, they could be as well off as whie ppl

***Dropping cultural superiority, keeping rest

gen immbadeco = v_263
gen cultsup = 6-v_264
gen redimm = 6-v_265

recode cultsup (0=.)

gen dischurtmins = v_266
recode dischurtmins (6=.)
gen minsgetless = v_267
recode minsgetless (6=.) 
gen minstryharder = 6-v_268
recode minstryharder (0=.) 

pwcorr immbadeco redimm dischurtmins minsgetless minstryharder
factor immbadeco redimm dischurtmins minsgetless minstryharder, pcf

alpha redimm immbadeco dischurtmins minsgetless minstryharder, item gen(immscale)
rename immscale01 immscale01old
gen immscale01 = (immscale-1)/4



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
***

gen nohed = 0
replace nohed = 1 if educ_degree==1
gen jobtrain = 0
replace jobtrain = 1 if educ_degree==2
gen meisterbrief = 0
replace meisterbrief = 1 if educ_degree==3
gen polytechnique = 0
replace polytechnique = 1 if educ_degree==4
gen degree = 0
replace degree = 1 if educ_degree==5
gen doctorate = 0
replace doctorate = 1 if educ_degree==6
replace doctorate = 1 if educ_degree==7
gen educoth = 0
replace educoth = 1 if educ_degree==8 


****Gender***

gen male = 0
replace male=1 if female==1

***Detailed social class 

gen selfemp = 0
replace selfemp = 1 if occ==1
replace selfemp = 1 if occ==2
replace selfemp = 1 if occ==8

gen profman = 0
replace profman = 1 if occ==3
replace profman = 1 if occ==4

gen rnonm = 0
replace rnonm = 1 if occ==9
replace rnonm = 1 if occ==10

gen technical = 0
replace technical = 1 if occ==6

gen skilman = 0
replace skilman = 1 if occ==5
replace skilman = 1 if occ==7

gen unskiloth = 0
replace unskiloth = 1 if occ==11
replace unskiloth = 1 if occ==12

gen unemp = 0
replace unemp = 1 if occ==13

****OTHER DEMOGRAPHICS - all from wave 2 as earliest wave we analyse, most unlikely to change so no need to update with new figures

gen incomescale = income
recode incomescale (9=.)

***Taxes vs public services w1

gen taxspendw1 = v_42
recode taxspendw1 (12=.) 

****Satisfaction with Democracy***

gen satdemw1 = v_149
recode satdemw1 (5=.) 

gen satdemw2 = v2_1524
recode satdemw2 (5=.) 

gen satdemw3 = v3_1524
recode satdemw3 (5=.) 


***Union HH***

gen unionhh = 0
replace unionhh = 1 if v_313<4

***HHinc source

gen hhincpens = 0
replace hhincpens = 1 if v_729==1

gen hhincbens = 0
replace hhincbens = 1 if v_730==1

****Housing circumstances***

gen ownhouse = 0
replace ownhouse = 1 if v_394==1

gen mortgage = 0
replace mortgage = 1 if v_394==2

gen sochouse = 0
replace sochouse = 1 if v_394==4

gen houseprice = v_395
recode houseprice (6=.) 

*****PARTY ID****

gen SPDidw1 = 0
replace SPDidw1 = 1 if g1_partyid==1

gen CDUidw1 = 0
replace CDUidw1 = 1 if g1_partyid==2

gen FDPidw1 = 0
replace FDPidw1 = 1 if g1_partyid==3

gen grnidw1 = 0
replace grnidw1 = 1 if g1_partyid==4

gen linkeidw1 = 0
replace linkeidw1 = 1 if g1_partyid==5

****MCP - NEED TO CHECK THE CONSTRUCTION OF THIS

rename imcpr IMCP01

****Leader ratings***

gen ratemerkw1 = v1_424
recode ratemerkw1 (12=.)

gen ratesteinw1 = v1_425
recode ratesteinw1 (12=.) 

gen ratemuntw1 = v1_426
recode ratemuntw1 (12=.) 

gen rateguidow1 = v1_427
recode rateguidow1 (12=.) 

gen raterenatew1 = v1_428
recode raterenatew1 (12=.)

gen ratetrittinw1 = v1_429
recode ratetrittinw1 (12=.)

gen rateguttenw1 = v1_430
recode rateguttenw1 (12=.)

gen rategysiw1 = v1_431
recode rategysiw1 (12=.)

gen rateoskar = v1_432
recode rateoskar (12=.)

gen rateseehoferw1 = v1_719
recode rateseehofer (12=.) 

***Wave 2

gen ratemerkw2 = v2_424
recode ratemerkw2 (12=.)

gen ratesteinw2 = v2_425
recode ratesteinw2 (12=.) 

gen ratemuntw2 = v2_426
recode ratemuntw2 (12=.) 

gen rateguidow2 = v2_427
recode rateguidow2 (12=.) 

gen raterenatew2 = v2_428
recode raterenatew2 (12=.)

gen ratetrittinw2 = v2_429
recode ratetrittinw2 (12=.)

gen rateguttenw2 = v2_430
recode rateguttenw2 (12=.)

gen rategysiw2 = v2_431
recode rategysiw2 (12=.)

gen rateoskarw2 = v2_432
recode rateoskarw2 (12=.)

gen rateseehoferw2 = v2_719
recode rateseehoferw2 (12=.) 

***Wave 3 

gen ratemerkw3 = v3_424
recode ratemerkw3 (12=.)

gen ratesteinw3 = v3_425
recode ratesteinw3 (12=.) 

gen ratemuntw3 = v3_426
recode ratemuntw3 (12=.) 

gen rateguidow3 = v3_427
recode rateguidow3 (12=.) 

gen raterenatew3 = v3_428
recode raterenatew3 (12=.)

gen ratetrittinw3 = v3_429
recode ratetrittinw3 (12=.)

gen rateguttenw3 = v3_430
recode rateguttenw3 (12=.)

gen rategysiw3 = v3_431
recode rategysiw3 (12=.)

gen rateoskarw3 = v3_432
recode rateoskarw3 (12=.)

gen rateseehoferw3 = v3_719
recode rateseehoferw3 (12=.) 


*****LR self placement and placement of parties

***Wave 1

capture drop LRselfplacew1
gen LRselfplacew1 = v1_23

gen LRCDUw1 = v1_447
gen LRCSUw1 = v1_448
gen LRSPDw1 = v1_449
gen LRgrnw1 = v1_450
gen LRlinkew1 = v1_451

****Wave 2 - MISSING

gen LRselfplacew2 = v2_23

gen LRCDUw2 = v2_447
gen LRCSUw2 = v2_448
gen LRSPDw2 = v2_449
gen LRgrnw2 = v2_450
gen LRlinkew2 = v2_451

***Wave 3 - MISSING

gen LRselfplacew3 = v3_23

gen LRCDUw3 = v3_447
gen LRCSUw3 = v3_448
gen LRSPDw3 = v3_449
gen LRgrnw3 = v3_450
gen LRlinkew3 = v3_451


*****Issues/competence****
***(NB:Prob with Merkel competence in w1)

***Wave 1

*gen merkcompw1 = v1_31
*recode merkcompw1 (6=.)

gen crimeratew1 = v1_34
recode crimeratew1 (1=5) (2=4) (4=2) (5=1) (6=.)

gen  crimeperfw1 = v1_35
recode crimeperfw1 (6=.)

gen healthqualw1 = v1_36
recode healthqualw1 (6=.) 

gen healthpolw1 = v1_37
recode healthpolw1 (6=.)

***Wave 2 - POLICY ONES MISSING

gen merkcompw2 = v2_31
recode merkcompw2 (6=.)

gen crimeratew2 = v2_34
recode crimeratew2 (1=5) (2=4) (4=2) (5=1) (6=.)

gen  crimeperfw2 = v2_35
recode crimeperfw2 (6=.)

gen healthqualw2 = v2_36
recode healthqualw2 (6=.) 

gen healthpolw2 = v2_37
recode healthpolw2 (6=.)

****Wave 3 - POLICY ONES MISSING

gen merkcompw3 = v3_31
recode merkcompw3 (6=.)

gen crimeratew3 = v3_34
recode crimeratew3 (1=5) (2=4) (4=2) (5=1) (6=.)

gen  crimeperfw3 = v3_35
recode crimeperfw3 (6=.)

gen healthqualw3 = v3_36
recode healthqualw3 (6=.) 

gen healthpolw3 = v3_37
recode healthpolw3 (6=.)

****Economic perceptions 

***Wave 1

gen natecoretw1 = v1_44
recode natecoretw1 (6=.)

gen natecoprospw1 = v1_45
recode natecoprospw1 (6=.)

gen perecoretw1 = v1_46
recode perecoretw1 (6=.) 

gen perecoprospw1 = v1_47
recode perecoprospw1 (6=.) 

***Wave 2

gen natecoretw2 = v2_44
recode natecoretw2 (6=.)

gen natecoprospw2 = v2_45
recode natecoprospw2 (6=.)

gen perecoretw2 = v2_46
recode perecoretw2 (6=.) 

gen perecoprospw2 = v2_47
recode perecoprospw2 (6=.) 

***Wave 3

gen natecoretw3 = v3_44
recode natecoretw3 (6=.)

gen natecoprospw3 = v3_45
recode natecoprospw3 (6=.)

gen perecoretw3 = v3_46
recode perecoretw3 (6=.) 

gen perecoprospw3 = v3_47
recode perecoprospw3 (6=.) 


***Political interest - MISSING WAVE 2 AND WAVE 3

capture drop polintw1

gen polintw1 = v1_150
recode polintw1 (6=.)

gen polintw2 = v2_150
recode polintw2 (6=.)

gen polintw2 = v3_150
recode polintw2 (6=.)

****VOTE CHOICE - details of others' parties missing from leaners data

gen votecandw1 = 0
replace votecandw1 = 1 if v1_414==1
replace votecandw1 = 2 if v1_414==2
replace votecandw1 = 3 if v1_414==3
replace votecandw1 = 4 if v1_414==4
replace votecandw1 = 5 if v1_414==5
replace votecandw1 = 7 if v1_414==6
replace votecandw1 = 6 if v1_74=="DRP"
replace votecandw1 = 6 if v1_74=="DVU"
replace votecandw1 = 6 if v1_74=="DVU - Die Neue Rechte"
replace votecandw1 = 6 if v1_74=="DVU,NPD oder Republikaner, Die Linke"
replace votecandw1 = 6 if v1_74=="Die Republikaner"
replace votecandw1 = 6 if v1_74=="NPD"
replace votecandw1 = 6 if v1_74=="NPD oder DVU"
replace votecandw1 = 6 if v1_74=="Rechte Partei"
replace votecandw1 = 6 if v1_74=="Rep"
replace votecandw1 = 6 if v1_74=="Republikaner"
replace votecandw1 = 6 if v1_74=="npd"
replace votecandw1 = 6 if v1_74=="rep"

replace votecandw1 = 1 if v1_455==1
replace votecandw1 = 2 if v1_455==2
replace votecandw1 = 3 if v1_455==3
replace votecandw1 = 4 if v1_455==4
replace votecandw1 = 5 if v1_455==5
replace votecandw1 = 7 if v1_455==6


gen voteptyw1 = 0
replace voteptyw1 = 1 if v1_415==1
replace voteptyw1 = 2 if v1_415==2
replace voteptyw1 = 3 if v1_415==3
replace voteptyw1 = 4 if v1_415==4
replace voteptyw1 = 5 if v1_415==5
replace voteptyw1 = 7 if v1_415==6
replace voteptyw1 = 6 if v1_72=="Abgeordneter der NPD"
replace voteptyw1 = 6 if v1_72=="DVU"
replace voteptyw1 = 6 if v1_72=="Die Republikaner"
replace voteptyw1 = 6 if v1_72=="NDP"
replace voteptyw1 = 6 if v1_72=="NPD"
replace voteptyw1 = 6 if v1_72=="REP"
replace voteptyw1 = 6 if v1_72=="Rennike"
replace voteptyw1 = 6 if v1_72=="Rep"
replace voteptyw1 = 6 if v1_72=="Republikaner"
replace voteptyw1 = 6 if v1_72=="npd"
replace voteptyw1 = 6 if v1_72=="rep"

replace voteptyw1 = 1 if v1_456==1
replace voteptyw1 = 2 if v1_456==2
replace voteptyw1 = 3 if v1_456==3
replace voteptyw1 = 4 if v1_456==4
replace voteptyw1 = 5 if v1_456==5
replace voteptyw1 = 7 if v1_456==6

*****Wave 2

gen votecandw2 = 0
replace votecandw2 = 1 if v2_414==1
replace votecandw2 = 2 if v2_414==2
replace votecandw2 = 3 if v2_414==3
replace votecandw2 = 4 if v2_414==4
replace votecandw2 = 5 if v2_414==5
replace votecandw2 = 7 if v2_414==6
replace votecandw2 = 6 if v2_74=="Die Republikaner"
replace votecandw2 = 6 if v2_74=="Dr. Schlierer"
replace votecandw2 = 6 if v2_74=="NDP"
replace votecandw2 = 6 if v2_74=="NPD"
replace votecandw2 = 6 if v2_74=="REP"
replace votecandw2 = 6 if v2_74=="RP"
replace votecandw2 = 6 if v2_74=="Rechts ( NPD )"
replace votecandw2 = 6 if v2_74=="Republikaner"
replace votecandw2 = 6 if v2_74=="einen deutschen kaiser"
replace votecandw2 = 6 if v2_74=="npd"
replace votecandw2 = 6 if v2_74=="npd/rep"
replace votecandw2 = 6 if v2_74=="rechts"

replace votecandw2 = 1 if v2_455==1
replace votecandw2 = 2 if v2_455==2
replace votecandw2 = 3 if v2_455==3
replace votecandw2 = 4 if v2_455==4
replace votecandw2 = 5 if v2_455==5
replace votecandw2 = 7 if v2_455==6


gen voteptyw2 = 0
replace voteptyw2 = 1 if v2_415==1
replace voteptyw2 = 2 if v2_415==2
replace voteptyw2 = 3 if v2_415==3
replace voteptyw2 = 4 if v2_415==4
replace voteptyw2 = 5 if v2_415==5
replace voteptyw2 = 7 if v2_415==6
replace voteptyw2 = 6 if v2_72=="Deutsche Partei"
replace voteptyw2 = 6 if v2_72=="DVU"
replace voteptyw2 = 6 if v2_72=="Die Republikaner"
replace voteptyw2 = 6 if v2_72=="NPD"
replace voteptyw2 = 6 if v2_72=="REP"
replace voteptyw2 = 6 if v2_72=="RP"
replace voteptyw2 = 6 if v2_72=="Rechts ( NPD )"
replace voteptyw2 = 6 if v2_72=="Rep"
replace voteptyw2 = 6 if v2_72=="Republikaner"
replace voteptyw2 = 6 if v2_72=="am liebsten nsdap"
replace voteptyw2 = 6 if v2_72=="dvu"
replace voteptyw2 = 6 if v2_72=="npd"
replace voteptyw2 = 6 if v2_72=="npd / rep"
replace voteptyw2 = 6 if v2_72=="republikaner"

*replace voteptyw2 = 1 if v2_456==1
*replace voteptyw2 = 2 if v2_456==2
*replace voteptyw2 = 3 if v2_456==3
*replace voteptyw2 = 4 if v2_456==4
*replace voteptyw2 = 5 if v2_456==5
*replace voteptyw2 = 7 if v2_456==6

****Wave 3

gen votecandw3 = 0
replace votecandw3 = 1 if v3_414==1
replace votecandw3 = 2 if v3_414==2
replace votecandw3 = 3 if v3_414==3
replace votecandw3 = 4 if v3_414==4
replace votecandw3 = 5 if v3_414==5
replace votecandw3 = 7 if v3_414==6
replace votecandw3 = 6 if v3_74=="Claus Cremer"
replace votecandw3 = 6 if v3_74=="DVU"
replace votecandw3 = 6 if v3_74=="NPD"
replace votecandw3 = 6 if v3_74=="Republikaner"
replace votecandw3 = 6 if v3_74=="dvu"
replace votecandw3 = 6 if v3_74=="npd"
replace votecandw3 = 6 if v3_74=="udo voigt"

replace votecandw3 = 1 if v3_455==1
replace votecandw3 = 2 if v3_455==2
replace votecandw3 = 3 if v3_455==3
replace votecandw3 = 4 if v3_455==4
replace votecandw3 = 5 if v3_455==5
replace votecandw3 = 7 if v3_455==6


gen voteptyw3 = 0
replace voteptyw3 = 1 if v3_415==1
replace voteptyw3 = 2 if v3_415==2
replace voteptyw3 = 3 if v3_415==3
replace voteptyw3 = 4 if v3_415==4
replace voteptyw3 = 5 if v3_415==5
replace voteptyw3 = 7 if v3_415==6
replace voteptyw3 = 6 if v3_72=="NPD"
replace voteptyw3 = 6 if v3_72=="REP"
replace voteptyw3 = 6 if v3_72=="Repubikaner"
replace voteptyw3 = 6 if v3_72=="Republikaner"
replace voteptyw3 = 6 if v3_72=="dvu"
replace voteptyw3 = 6 if v3_72=="npd"

replace voteptyw3 = 1 if v3_456==1
replace voteptyw3 = 2 if v3_456==2
replace voteptyw3 = 3 if v3_456==3
replace voteptyw3 = 4 if v3_456==4
replace voteptyw3 = 5 if v3_456==5
replace voteptyw3 = 7 if v3_456==6

****Wave 4

gen votecandw4 = 0
replace votecandw4 = 1 if v4_414==1
replace votecandw4 = 2 if v4_414==2
replace votecandw4 = 3 if v4_414==3
replace votecandw4 = 4 if v4_414==4
replace votecandw4 = 5 if v4_414==5
replace votecandw4 = 7 if v4_414==6
replace votecandw4 = 6 if v4_74=="DVU"
replace votecandw4 = 6 if v4_74=="NPD"
replace votecandw4 = 6 if v4_74=="Rep"
replace votecandw4 = 6 if v4_74=="Republikaner/NPD"
replace votecandw4 = 6 if v4_74=="dvu"
replace votecandw4 = 6 if v4_74=="npd"

*replace votecandw4 = 1 if v4_455==1
*replace votecandw4 = 2 if v4_455==2
*replace votecandw4 = 3 if v4_455==3
*replace votecandw4 = 4 if v4_455==4
*replace votecandw4 = 5 if v4_455==5
*replace votecandw4 = 7 if v4_455==6


gen voteptyw4 = 0
replace voteptyw4 = 1 if v4_415==1
replace voteptyw4 = 2 if v4_415==2
replace voteptyw4 = 3 if v4_415==3
replace voteptyw4 = 4 if v4_415==4
replace voteptyw4 = 5 if v4_415==5
replace voteptyw4 = 7 if v4_415==6
replace voteptyw4 = 6 if v4_72a==1
replace voteptyw4 = 6 if v4_72a==3

*replace voteptyw4 = 1 if v4_456==1
*replace voteptyw4 = 2 if v4_456==2
*replace voteptyw4 = 3 if v4_456==3
*replace voteptyw4 = 4 if v4_456==4
*replace voteptyw4 = 5 if v4_456==5
*replace voteptyw4 = 7 if v4_456==6

label define germpty 1 "SPD" 2 "CDU/CSU" 3 "FDP" 4 "Green" 5 "Linke" 6 "RadRt" 7 "Other" 
label values votecandw1 germpty
label values voteptyw1 germpty
label values votecandw2 germpty
label values voteptyw2 germpty
label values votecandw3 germpty
label values voteptyw3 germpty
label values votecandw4 germpty
label values voteptyw4 germpty


recode votecandw1 (0=.)
recode voteptyw1 (0=.) 
recode votecandw2 (0=.)
recode voteptyw2 (0=.) 
recode votecandw3 (0=.)
recode voteptyw3 (0=.) 
recode votecandw4 (0=.)
recode voteptyw4 (0=.) 

****Ever supported a radical right party? 

gen radrtever = 0
replace radrtever = 1 if votecandw1==6
replace radrtever = 1 if voteptyw1==6
replace radrtever = 1 if votecandw2==6
replace radrtever = 1 if voteptyw2==6
replace radrtever = 1 if votecandw3==6
replace radrtever = 1 if voteptyw3==6
replace radrtever = 1 if votecandw4==6
replace radrtever = 1 if voteptyw4==6

recode radrtever (0=.) if votecandw1==.

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
label values votew3 votew3
label define votew3 1 "Lab" 2 "Con" 3 "LD" 4 "UKIP" 5 "BNP" 9 "Other" 10 "Don't know"

recode votew3 (0=.)


