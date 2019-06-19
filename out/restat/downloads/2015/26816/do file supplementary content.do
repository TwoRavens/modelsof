

use "data.dta", clear

* Generating variables

do "creating variables.do"



**********************************************

* APPENDIX C: TABLES IN SUPPLEMENTARY CONTENT

**********************************************

preserve
drop if session==1

* TABLE C1: BONUS, Main treatment
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 , robust cl(groupid)
outreg2 using bonusC1, addstat(Pseudo R-squared, `e(r2_p)') title(Table 2: Bonus)  ctitle(informed, all rounds) bdec(3) tdec(3) rdec(3)   tex      replace

xi: dprobit  highbonus highcosts   female Altruist Trusting Fair Reciprocal i.stage if  maintreatment==1 & principal==1, robust cl(groupid)
outreg2 using bonusC1, addstat(Pseudo R-squared, `e(r2_p)') ctitle(informed, all rounds) bdec(3) tdec(3) rdec(3)   tex      append

xi: dprobit  highbonus highcosts   female Altruist Trusting Fair Reciprocal i.stage if  maintreatment==1 & principal==1 &   Rounds11_20==0, robust cl(groupid)
outreg2 using bonusC1, addstat(Pseudo R-squared, `e(r2_p)') ctitle(informed, rounds 1-10) bdec(3) tdec(3) rdec(3)   tex      append

xi: dprobit  highbonus highcosts   female Altruist Trusting Fair Reciprocal i.stage if  maintreatment==1 & principal==1 &   Rounds11_20==1, robust cl(groupid)
outreg2 using bonusC1, addstat(Pseudo R-squared, `e(r2_p)') ctitle(informed, rounds 11-20) bdec(3) tdec(3) rdec(3)   tex      append


* TABLE C2: Effort, Main treatment
xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  i.stage if    maintreatment==1 & agent==1 , robust cl(groupid)
outreg2 using mainC2, addstat(Pseudo R-squared, `e(r2_p)') title(Table 3: Effort in Main Treatment) ctitle(joint project, all rounds) bdec(3) tdec(3) rdec(3)    tex      replace

xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
outreg2 using mainC2, addstat(Pseudo R-squared, `e(r2_p)') ctitle(joint project, all rounds) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
outreg2 using mainC2,  addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, all rounds) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
outreg2 using mainC2, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, all rounds) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1   & Rounds11_20 ==0, robust cl(groupid)
outreg2 using mainC2, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, rounds 1-10) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1   & Rounds11_20 ==1, robust cl(groupid)
outreg2 using mainC2, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, rounds 11-20) bdec(3) tdec(3) rdec(3)    tex      append

restore


***************************************

* APPENDIX D: ANALYSIS OF ORDER EFFECTS

***************************************


* STARTS AS AGENT

* BONUS, STARTS AS AGENT
	
 
bys groupid: egen x1211=mean(highbonus) if principal==1 & informed==0   & startagent==1
bys groupid: egen x1221=mean(highbonus) if principal==1 & informed==1   & highcost==0 & startagent==1
bys groupid: egen x1231=mean(highbonus) if principal==1 & informed==1   & highcost==1 & startagent==1

* following uses notation: 
* "av" for average, "u" or "i" for uninformed (control treatment) or informed (main treatment), "h" or "l"  for high or low bonus, "A" or "P" for starting role agent or principal

bys groupid: egen avbonusuA=max(x1211)
bys groupid: egen avbonusilA=max(x1221)
bys groupid: egen avbonusihA=max(x1231)

sum avbonusuA avbonusihA avbonusilA if flaggroup==1 
signrank  avbonusihA = avbonusilA  if flaggroup==1 

* EFFORT OWN, STARTS AS AGENT

bys groupid: egen x311=mean(effort_own) if agent==1 &informed==0  & highbonus==1  & goodsignal==1 & startagent==1
bys groupid: egen x312=mean(effort_own) if agent==1 &informed==0  & highbonus==0  & goodsignal==1 & startagent==1
bys groupid: egen x313=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & goodsignal==1 & startagent==1
bys groupid: egen x314=mean(effort_own) if agent==1 &informed==1  & highbonus==0  & goodsignal==1 & startagent==1

bys groupid: egen x315=mean(effort_own) if agent==1 &informed==0  & highbonus==1  & goodsignal==0  & startagent==1
bys groupid: egen x316=mean(effort_own) if agent==1 &informed==0  & highbonus==0  & goodsignal==0  & startagent==1
bys groupid: egen x317=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & goodsignal==0  & startagent==1
bys groupid: egen x318=mean(effort_own) if agent==1 &informed==1  & highbonus==0  & goodsignal==0  & startagent==1

bys groupid: egen aveffort_ownuhgA=max(x311)
bys groupid: egen aveffort_ownulgA=max(x312)
bys groupid: egen aveffort_ownihgA=max(x313)
bys groupid: egen aveffort_ownilgA=max(x314)

bys groupid: egen aveffort_ownuhbA=max(x315)
bys groupid: egen aveffort_ownulbA=max(x316)
bys groupid: egen aveffort_ownihbA=max(x317)
bys groupid: egen aveffort_ownilbA=max(x318)


ci  aveffort_ownuhgA aveffort_ownulgA aveffort_ownihgA aveffort_ownilgA aveffort_ownuhbA aveffort_ownulbA aveffort_ownihbA aveffort_ownilbA if  flaggroup==1


signrank  aveffort_ownihgA = aveffort_ownilgA if flaggroup==1
signrank  aveffort_ownihbA = aveffort_ownilbA if flaggroup==1
signrank  aveffort_ownuhgA = aveffort_ownulgA if flaggroup==1
signrank  aveffort_ownuhbA = aveffort_ownulbA if flaggroup==1

bys groupid: gen diffugA=aveffort_ownuhgA-aveffort_ownulgA
bys groupid: gen diffubA=aveffort_ownuhbA-aveffort_ownulbA
bys groupid: gen diffigA=aveffort_ownihgA-aveffort_ownilgA
bys groupid: gen diffibA=aveffort_ownihbA-aveffort_ownilbA
ci  diffugA diffubA diffigA diffibA if flaggroup==1, level(90)


* EFFORT JOINT, STARTS AS AGENT


bys groupid: egen z311=mean(effort_joint) if agent==1 &informed==0  & highbonus==1  & goodsignal==1 & startagent==1
bys groupid: egen z312=mean(effort_joint) if agent==1 &informed==0  & highbonus==0  & goodsignal==1 & startagent==1
bys groupid: egen z313=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & goodsignal==1 & startagent==1
bys groupid: egen z314=mean(effort_joint) if agent==1 &informed==1  & highbonus==0  & goodsignal==1 & startagent==1

bys groupid: egen z315=mean(effort_joint) if agent==1 &informed==0  & highbonus==1  & goodsignal==0  & startagent==1
bys groupid: egen z316=mean(effort_joint) if agent==1 &informed==0 & highbonus==0 & goodsignal==0  & startagent==1
bys groupid: egen z317=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & goodsignal==0  & startagent==1
bys groupid: egen z318=mean(effort_joint) if agent==1 &informed==1  & highbonus==0  & goodsignal==0  & startagent==1

bys groupid: egen aveffort_jointuhgA=max(z311)
bys groupid: egen aveffort_jointulgA=max(z312)
bys groupid: egen aveffort_jointihgA=max(z313)
bys groupid: egen aveffort_jointilgA=max(z314)

bys groupid: egen aveffort_jointuhbA=max(z315)
bys groupid: egen aveffort_jointulbA=max(z316)
bys groupid: egen aveffort_jointihbA=max(z317)
bys groupid: egen aveffort_jointilbA=max(z318)


ci  aveffort_jointuhgA aveffort_jointulgA aveffort_jointihgA aveffort_jointilgA aveffort_jointuhbA aveffort_jointulbA aveffort_jointihbA aveffort_jointilbA if  flaggroup==1

signrank  aveffort_jointihgA = aveffort_jointilgA if flaggroup==1
signrank  aveffort_jointihbA = aveffort_jointilbA if flaggroup==1
signrank  aveffort_jointuhgA = aveffort_jointulgA if flaggroup==1
signrank  aveffort_jointuhbA = aveffort_jointulbA if flaggroup==1


bys groupid: gen diffejugA=aveffort_jointuhgA-aveffort_jointulgA
bys groupid: gen diffejubA=aveffort_jointuhbA-aveffort_jointulbA
bys groupid: gen diffejigA=aveffort_jointihgA-aveffort_jointilgA
bys groupid: gen diffejibA=aveffort_jointihbA-aveffort_jointilbA
ci  diffejugA diffejubA diffejigA diffejibA if flaggroup==1, level(90)	

* STARTS AS PRINCIPAL

* BONUS, STARTS AS PRINCIPAL

*start as principal 
bys groupid: egen x1111=mean(highbonus) if principal==1 & informed==0   & startagent==0
bys groupid: egen x1121=mean(highbonus) if principal==1 & informed==1   & highcost==0 & startagent==0
bys groupid: egen x1131=mean(highbonus) if principal==1 & informed==1   & highcost==1 & startagent==0

bys groupid: egen avbonusuP=max(x1111)
bys groupid: egen avbonusilP=max(x1121)
bys groupid: egen avbonusihP=max(x1131)

sum avbonusuP avbonusihP avbonusilP if flaggroup==1 
signrank  avbonusihP = avbonusilP  if flaggroup==1 


* EFFORT OWN, STARTS AS PRINCIPAL

bys groupid: egen x211=mean(effort_own) if agent==1 &informed==0  & highbonus==1  & goodsignal==1 & startagent==0
bys groupid: egen x212=mean(effort_own) if agent==1 &informed==0  & highbonus==0  & goodsignal==1 & startagent==0
bys groupid: egen x213=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & goodsignal==1 & startagent==0
bys groupid: egen x214=mean(effort_own) if agent==1 &informed==1  & highbonus==0  & goodsignal==1 & startagent==0

bys groupid: egen x215=mean(effort_own) if agent==1 &informed==0  & highbonus==1  & goodsignal==0 & startagent==0
bys groupid: egen x216=mean(effort_own) if agent==1 &informed==0 & highbonus==0 & goodsignal==0  & startagent==0
bys groupid: egen x217=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & goodsignal==0  & startagent==0
bys groupid: egen x218=mean(effort_own) if agent==1 &informed==1  & highbonus==0  & goodsignal==0  & startagent==0

bys groupid: egen aveffort_ownuhgP=max(x211)
bys groupid: egen aveffort_ownulgP=max(x212)
bys groupid: egen aveffort_ownihgP=max(x213)
bys groupid: egen aveffort_ownilgP=max(x214)

bys groupid: egen aveffort_ownuhbP=max(x215)
bys groupid: egen aveffort_ownulbP=max(x216)
bys groupid: egen aveffort_ownihbP=max(x217)
bys groupid: egen aveffort_ownilbP=max(x218)


ci  aveffort_ownuhgP aveffort_ownulgP aveffort_ownihgP aveffort_ownilgP aveffort_ownuhbP aveffort_ownulbP aveffort_ownihbP aveffort_ownilbP if  flaggroup==1


signrank  aveffort_ownihgP = aveffort_ownilgP if flaggroup==1
signrank  aveffort_ownihbP = aveffort_ownilbP if flaggroup==1
signrank  aveffort_ownuhgP = aveffort_ownulgP if flaggroup==1
signrank  aveffort_ownuhbP = aveffort_ownulbP if flaggroup==1

bys groupid: gen diffugP=aveffort_ownuhgP-aveffort_ownulgP
bys groupid: gen diffubP=aveffort_ownuhbP-aveffort_ownulbP
bys groupid: gen diffigP=aveffort_ownihgP-aveffort_ownilgP
bys groupid: gen diffibP=aveffort_ownihbP-aveffort_ownilbP
ci  diffugP diffubP diffigP diffibP if flaggroup==1, level(90)



* EFFORT JOINT, STARTS AS PRINCIPAL

bys groupid: egen z211=mean(effort_joint) if agent==1 &informed==0  & highbonus==1  & goodsignal==1 & startagent==0
bys groupid: egen z212=mean(effort_joint) if agent==1 &informed==0  & highbonus==0  & goodsignal==1 & startagent==0
bys groupid: egen z213=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & goodsignal==1 & startagent==0
bys groupid: egen z214=mean(effort_joint) if agent==1 &informed==1  & highbonus==0  & goodsignal==1 & startagent==0

bys groupid: egen z215=mean(effort_joint) if agent==1 &informed==0  & highbonus==1  & goodsignal==0  & startagent==0
bys groupid: egen z216=mean(effort_joint) if agent==1 &informed==0 & highbonus==0 & goodsignal==0  & startagent==0
bys groupid: egen z217=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & goodsignal==0  & startagent==0
bys groupid: egen z218=mean(effort_joint) if agent==1 &informed==1  & highbonus==0  & goodsignal==0  & startagent==0

bys groupid: egen aveffort_jointuhgP=max(z211)
bys groupid: egen aveffort_jointulgP=max(z212)
bys groupid: egen aveffort_jointihgP=max(z213)
bys groupid: egen aveffort_jointilgP=max(z214)

bys groupid: egen aveffort_jointuhbP=max(z215)
bys groupid: egen aveffort_jointulbP=max(z216)
bys groupid: egen aveffort_jointihbP=max(z217)
bys groupid: egen aveffort_jointilbP=max(z218)


ci  aveffort_jointuhgP aveffort_jointulgP aveffort_jointihgP aveffort_jointilgP aveffort_jointuhbP aveffort_jointulbP aveffort_jointihbP aveffort_jointilbP if  flaggroup==1

signrank  aveffort_jointihgP = aveffort_jointilgP if flaggroup==1
signrank  aveffort_jointihbP = aveffort_jointilbP if flaggroup==1
signrank  aveffort_jointuhgP = aveffort_jointulgP if flaggroup==1
signrank  aveffort_jointuhbP = aveffort_jointulbP if flaggroup==1


bys groupid: gen diffejugP=aveffort_jointuhgP-aveffort_jointulgP
bys groupid: gen diffejubP=aveffort_jointuhbP-aveffort_jointulbP
bys groupid: gen diffejigP=aveffort_jointihgP-aveffort_jointilgP
bys groupid: gen diffejibP=aveffort_jointihbP-aveffort_jointilbP
ci  diffejugP diffejubP diffejigP diffejibP if flaggroup==1, level(90)	


* BY FIRST OR SECOND TREATMENT

* BONUS, FIRST TREATMENT
bys groupid: egen x1011=mean(highbonus) if principal==1 & informed==0   & stage==1
bys groupid: egen x1021=mean(highbonus) if principal==1 & informed==1   & highcost==0 & stage==1
bys groupid: egen x1031=mean(highbonus) if principal==1 & informed==1   & highcost==1 & stage==1

bys groupid: egen avbonusu1=max(x1011)
bys groupid: egen avbonusil1=max(x1021)
bys groupid: egen avbonusih1=max(x1031)

sum avbonusu1 avbonusih1 avbonusil1 if flaggroup==1 
signrank  avbonusih1 = avbonusil1  if flaggroup==1 & stage==1

* BONUS, SECOND TREATMENT
bys groupid: egen x1411=mean(highbonus) if principal==1 & informed==0   & stage==2
bys groupid: egen x1421=mean(highbonus) if principal==1 & informed==1   & highcost==0 & stage==2
bys groupid: egen x1431=mean(highbonus) if principal==1 & informed==1   & highcost==1 & stage==2

bys groupid: egen avbonusuS2=max(x1411)
bys groupid: egen avbonusilS2=max(x1421)
bys groupid: egen avbonusihS2=max(x1431)

sum avbonusuS2 avbonusihS2 avbonusilS2 if flaggroup==1 
signrank  avbonusihS2 = avbonusilS2  if flaggroup==1 & stage==1



* EFFORT OWN, FIRST TREATMENT
bys groupid: egen x1=mean(effort_own) if agent==1 & informed==0  & highbonus==1 & stage==1 & goodsignal==1
bys groupid: egen x2=mean(effort_own) if agent==1 &informed==0  & highbonus==0 & stage==1 & goodsignal==1
bys groupid: egen x3=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & stage==1 & goodsignal==1
bys groupid: egen x4=mean(effort_own) if agent==1 &informed==1  & highbonus==0 & stage==1 & goodsignal==1

bys groupid: egen x5=mean(effort_own) if agent==1 &informed==0  & highbonus==1 & stage==1 & goodsignal==0
bys groupid: egen x6=mean(effort_own) if agent==1 &informed==0 & highbonus==0 & stage==1 & goodsignal==0
bys groupid: egen x7=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & stage==1 & goodsignal==0
bys groupid: egen x8=mean(effort_own) if agent==1 &informed==1  & highbonus==0 & stage==1 & goodsignal==0

bys groupid: egen aveffort_ownuhg=max(x1)
bys groupid: egen aveffort_ownulg=max(x2)
bys groupid: egen aveffort_ownihg=max(x3)
bys groupid: egen aveffort_ownilg=max(x4)

bys groupid: egen aveffort_ownuhb=max(x5)
bys groupid: egen aveffort_ownulb=max(x6)
bys groupid: egen aveffort_ownihb=max(x7)
bys groupid: egen aveffort_ownilb=max(x8)

ci  aveffort_ownuhg aveffort_ownulg aveffort_ownihg aveffort_ownilg aveffort_ownuhb aveffort_ownulb aveffort_ownihb aveffort_ownilb if  flaggroup==1
signrank  aveffort_ownihg = aveffort_ownilg if flaggroup==1
signrank  aveffort_ownihb = aveffort_ownilb if flaggroup==1
signrank  aveffort_ownuhg = aveffort_ownulg if flaggroup==1
signrank  aveffort_ownuhb = aveffort_ownulb if flaggroup==1

bys groupid: gen diffug=aveffort_ownuhg-aveffort_ownulg
bys groupid: gen diffub=aveffort_ownuhb-aveffort_ownulb
bys groupid: gen diffig=aveffort_ownihg-aveffort_ownilg
bys groupid: gen diffib=aveffort_ownihb-aveffort_ownilb
ci  diffug diffub diffig diffib if flaggroup==1, level(90)

*EFFORT OWN, SECOND TREATMENT

bys groupid: egen x51=mean(effort_own) if agent==1 & informed==0  & highbonus==1 & stage==2 & goodsignal==1
bys groupid: egen x52=mean(effort_own) if agent==1 &informed==0  & highbonus==0 & stage==2 & goodsignal==1
bys groupid: egen x53=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & stage==2 & goodsignal==1
bys groupid: egen x54=mean(effort_own) if agent==1 &informed==1  & highbonus==0 & stage==2 & goodsignal==1

bys groupid: egen x55=mean(effort_own) if agent==1 &informed==0  & highbonus==1 & stage==2 & goodsignal==0
bys groupid: egen x56=mean(effort_own) if agent==1 &informed==0 & highbonus==0 & stage==2 & goodsignal==0
bys groupid: egen x57=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & stage==2 & goodsignal==0
bys groupid: egen x58=mean(effort_own) if agent==1 &informed==1  & highbonus==0 & stage==2 & goodsignal==0

bys groupid: egen aveffort_ownuhgS2=max(x51)
bys groupid: egen aveffort_ownulgS2=max(x52)
bys groupid: egen aveffort_ownihgS2=max(x53)
bys groupid: egen aveffort_ownilgS2=max(x54)

bys groupid: egen aveffort_ownuhbS2=max(x55)
bys groupid: egen aveffort_ownulbS2=max(x56)
bys groupid: egen aveffort_ownihbS2=max(x57)
bys groupid: egen aveffort_ownilbS2=max(x58)

ci  aveffort_ownuhgS2 aveffort_ownulgS2 aveffort_ownihgS2 aveffort_ownilgS2 aveffort_ownuhbS2 aveffort_ownulbS2 aveffort_ownihbS2 aveffort_ownilbS2 if  flaggroup==1
signrank  aveffort_ownihgS2 = aveffort_ownilgS2 if flaggroup==1
signrank  aveffort_ownihbS2 = aveffort_ownilbS2 if flaggroup==1
signrank  aveffort_ownuhgS2 = aveffort_ownulgS2 if flaggroup==1
signrank  aveffort_ownuhbS2 = aveffort_ownulbS2 if flaggroup==1

bys groupid: gen diffugS2=aveffort_ownuhgS2-aveffort_ownulgS2
bys groupid: gen diffubS2=aveffort_ownuhbS2-aveffort_ownulbS2
bys groupid: gen diffigS2=aveffort_ownihgS2-aveffort_ownilgS2
bys groupid: gen diffibS2=aveffort_ownihbS2-aveffort_ownilbS2
ci  diffugS2 diffubS2 diffigS2 diffibS2 if flaggroup==1, level(90)

*EFFORT JOINT, FIRST TREATMENT

bys groupid: egen z1=mean(effort_joint) if agent==1 &informed==0  & highbonus==1 & stage==1 & goodsignal==1
bys groupid: egen z2=mean(effort_joint) if agent==1 &informed==0  & highbonus==0 & stage==1 & goodsignal==1
bys groupid: egen z3=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & stage==1 & goodsignal==1
bys groupid: egen z4=mean(effort_joint) if agent==1 &informed==1  & highbonus==0 & stage==1 & goodsignal==1

bys groupid: egen z5=mean(effort_joint) if agent==1 &informed==0  & highbonus==1 & stage==1 & goodsignal==0
bys groupid: egen z6=mean(effort_joint) if agent==1 &informed==0 & highbonus==0 & stage==1 & goodsignal==0
bys groupid: egen z7=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & stage==1 & goodsignal==0
bys groupid: egen z8=mean(effort_joint) if agent==1 &informed==1  & highbonus==0 & stage==1 & goodsignal==0

bys groupid: egen aveffortuhg=max(z1)
bys groupid: egen aveffortulg=max(z2)
bys groupid: egen aveffortihg=max(z3)
bys groupid: egen aveffortilg=max(z4)

bys groupid: egen aveffortuhb=max(z5)
bys groupid: egen aveffortulb=max(z6)
bys groupid: egen aveffortihb=max(z7)
bys groupid: egen aveffortilb=max(z8)


ci  aveffortuhg aveffortulg aveffortihg aveffortilg aveffortuhb aveffortulb aveffortihb aveffortilb if  flaggroup==1

signrank  aveffortihg = aveffortilg if flaggroup==1
signrank  aveffortihb = aveffortilb if flaggroup==1
signrank  aveffortuhg = aveffortulg if flaggroup==1
signrank  aveffortuhb = aveffortulb if flaggroup==1

*EFFORT JOINT, SECOND TREATMENT

bys groupid: egen z31=mean(effort_joint) if agent==1 &informed==0  & highbonus==1 & stage==2 & goodsignal==1
bys groupid: egen z32=mean(effort_joint) if agent==1 &informed==0  & highbonus==0 & stage==2 & goodsignal==1
bys groupid: egen z33=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & stage==2 & goodsignal==1
bys groupid: egen z34=mean(effort_joint) if agent==1 &informed==1  & highbonus==0 & stage==2 & goodsignal==1

bys groupid: egen z35=mean(effort_joint) if agent==1 &informed==0  & highbonus==1 & stage==2 & goodsignal==0
bys groupid: egen z36=mean(effort_joint) if agent==1 &informed==0 & highbonus==0 & stage==2 & goodsignal==0
bys groupid: egen z37=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & stage==2 & goodsignal==0
bys groupid: egen z38=mean(effort_joint) if agent==1 &informed==1  & highbonus==0 & stage==2 & goodsignal==0

bys groupid: egen aveffortuhgS2=max(z31)
bys groupid: egen aveffortulgS2=max(z32)
bys groupid: egen aveffortihgS2=max(z33)
bys groupid: egen aveffortilgS2=max(z34)

bys groupid: egen aveffortuhbS2=max(z35)
bys groupid: egen aveffortulbS2=max(z36)
bys groupid: egen aveffortihbS2=max(z37)
bys groupid: egen aveffortilbS2=max(z38)


ci  aveffortuhgS2 aveffortulgS2 aveffortihgS2 aveffortilgS2 aveffortuhbS2 aveffortulbS2 aveffortihbS2 aveffortilbS2 if  flaggroup==1

signrank  aveffortihgS2 = aveffortilgS2 if flaggroup==1
signrank  aveffortihbS2 = aveffortilbS2 if flaggroup==1
signrank  aveffortuhgS2 = aveffortulgS2 if flaggroup==1
signrank  aveffortuhbS2 = aveffortulbS2 if flaggroup==1


