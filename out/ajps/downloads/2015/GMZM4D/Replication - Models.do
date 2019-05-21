******************************************************************
******Replication of Models********************************
******************************************************************

*Author: Geoff Sheagley & Logan Dancey

*Creation Date: 6/19/2012

*Purpose: Replicate all analyses

*Input Files -  CCES_2006_CommonContent.dta

*Output Files - Assorted.


*****
*Models for Figures 2 & 3/Tables A1 and A2 + Predicted values used in Figure 4 (Predicted values require SPOST commands for Stata)
*****

**Deviation Models 

mlogit knowdevcap interest educ age woman income pidstrength ptyagdcap white ///
statedum40 statedum36 statedum30 statedum22 statedum3 ///
if knownondevcap!=. &  v5032 != 3 & v5033 != 3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowdeviraq interest educ age woman income pidstrength ptyagdiraq white ///
statedum3 statedum7 statedum19 statedum24 statedum30 statedum40  ///
if knownondeviraq!=. & v5027 != 3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowdevcafta interest educ age woman income pidstrength ptyagdcafta white ///
statedum2 statedum9 statedum10 statedum19 statedum27 statedum30 statedum33 ///
statedum38 statedum39 statedum41 statedum42 statedum47 ///
if knownondevcafta!=. & v5034 !=3 & v5035!=3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowdevimm interest educ age woman income pidstrength ptyid2agdimm white ///
statedum4 statedum14 statedum16-statedum18 statedum23 statedum24 statedum29 statedum31 ///
statedum33 statedum38-statedum41 statedum43 statedum45 statedum46  ///
if knownondevimm!=. & v5029 !=3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowdevminwage interest educ age woman income pidstrength ptyagdwage white /// 
statedum40 ///
if knownondevminwage!=. & v5030 !=3 & v5030 !=4 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowdevstem interest educ age woman income pidstrength ptyagdstem white ///
statedum4 statedum16 statedum28 statedum30 statedum31 statedum38-statedum40 statedum46 ///
if knownondevstem!=. [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowdevabort interest educ age woman income pidstrength ptyagdabort white ///
statedum30 statedum34 statedum40 statedum47 statedum50 ///
if knownondevabort!=. & v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

**Non-Deviation Models 

mlogit knownondevcap interest educ age woman income pidstrength ptyagndcap white ///
statedum40 statedum36 statedum30 statedum22 statedum3 ///
if knowdevcap!=. & v5032 != 3 & v5033 != 3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knownondeviraq interest educ age woman income pidstrength ptyagndiraq white ///
statedum3 statedum7 statedum10 statedum19 statedum24 statedum30  ///
if knowdeviraq!=. & v5027 != 3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knownondevcafta interest educ age woman income pidstrength ptyagndcafta white ///
statedum2 statedum9 statedum10 statedum19 statedum27 statedum30 statedum33 ///
statedum38 statedum39 statedum41 statedum42 statedum47 ///
if knowdevcafta!=. & v5034 !=3 & v5035!=3 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knownondevimm interest educ age woman income pidstrength ptyid2atndimm white ///
statedum4 statedum14 statedum16-statedum18 statedum23 statedum24 statedum29 statedum31 ///
statedum33 statedum38-statedum41 statedum43 statedum45 statedum46 ///
if knowdevimm!=. & v5029 !=3 [pw=v1001], base(0) 
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knownondevminwage interest educ age woman income pidstrength ptyagndwage white ///
statedum40 ///
if knowdevminwage!=. & v5030 !=3 & v5030 !=4 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knownondevstem interest educ  age woman income pidstrength ptyagndstem white ///
statedum4 statedum16 statedum28 statedum30 statedum31 statedum38-statedum40 statedum46 ///
if knowdevstem!=. [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knownondevabort interest educ age woman income pidstrength ptyagndabort white ///
statedum30 statedum34 statedum40 statedum47 statedum50 ///
if knowdevabort!=. & v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

*****
*Models for Tables A4 & A5
*****

*Deviators 

mlogit knowdevcap knowall educ age woman income pidstrength ptyagdcap white ///
statedum40 statedum36 statedum30 statedum22 statedum10 ///
if knownondevcap!=. &  v5032 != 3 & v5033 != 3 [pw=v1001], base(0)

mlogit knowdeviraq knowall educ age woman income pidstrength ptyagdiraq white ///
statedum3 statedum7 statedum10 statedum19 statedum24 statedum30  ///
if knownondeviraq!=. & v5027 != 3 [pw=v1001], base(0)

mlogit knowdevcafta knowall educ age woman income pidstrength ptyagdcafta white ///
statedum2 statedum9 statedum10 statedum19 statedum27 statedum30 statedum33 ///
statedum38 statedum39 statedum41 statedum42 statedum47  ///
if knownondevcafta!=. & v5034 !=3 & v5035!=3 [pw=v1001], base(0)

mlogit knowdevimm knowall educ age woman income pidstrength ptyid2agdimm white ///
statedum10 statedum14 statedum16-statedum18 statedum23 statedum24 statedum29 statedum31 ///
statedum33 statedum38-statedum41 statedum45 statedum46 ///
if knownondevimm!=. & v5029 !=3 [pw=v1001], base(0)

mlogit knowdevminwage knowall educ age woman income pidstrength ptyagdwage white /// 
statedum36 ///
if knownondevminwage!=. & v5030 !=3 & v5030 !=4 [pw=v1001], base(0)

mlogit knowdevstem knowall educ age woman income pidstrength ptyagdstem white ///
statedum4 statedum16 statedum28 statedum30 statedum31 statedum38-statedum40 statedum44 ///
if knownondevstem!=. [pw=v1001], base(0)


mlogit knowdevabort knowall educ age woman income pidstrength ptyagdabort white ///
statedum16 statedum30 statedum34 statedum40 statedum47 ///
if knownondevabort!=. & v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4 [pw=v1001], base(0)


*Non deviators 

mlogit knownondevcap knowall educ age woman income pidstrength ptyagndcap white ///
statedum40 statedum36 statedum30 statedum22 statedum10 ///
if knowdevcap!=. & v5032 != 3 & v5033 != 3 [pw=v1001], base(0)

mlogit knownondeviraq knowall educ age woman income pidstrength ptyagndiraq white ///
statedum3 statedum7 statedum10 statedum19 statedum24 statedum30  ///
if knowdeviraq!=. & v5027 != 3 [pw=v1001], base(0)

mlogit knownondevcafta knowall educ age woman income pidstrength ptyagndcafta white ///
statedum2 statedum9 statedum10 statedum19 statedum27 statedum30 statedum33 ///
statedum38 statedum39 statedum41 statedum42 statedum47 ///
if knowdevcafta!=. & v5034 !=3 & v5035!=3 [pw=v1001], base(0)

mlogit knownondevimm knowall educ age woman income pidstrength ptyid2atndimm white ///
statedum10 statedum14 statedum16-statedum18 statedum23 statedum24 statedum29 statedum31 ///
statedum33 statedum38-statedum41 statedum45 statedum46 ///
if knowdevimm!=. & v5029 !=3 [pw=v1001], base(0) 

mlogit knownondevminwage knowall educ age woman income pidstrength ptyagndwage white ///
statedum36 ///
if knowdevminwage!=. & v5030 !=3 & v5030 !=4 [pw=v1001], base(0)

mlogit knownondevstem knowall educ age woman income pidstrength ptyagndstem white ///
statedum4 statedum16 statedum28 statedum30 statedum31 statedum38-statedum40 statedum44 ///
if knowdevstem!=. [pw=v1001], base(0)

mlogit knownondevabort knowall educ age woman income pidstrength ptyagndabort white ///
statedum16 statedum30 statedum34 statedum40 statedum47 ///
if knowdevabort!=. & v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4 [pw=v1001], base(0)

****
*Values for Figure 1--Need to create issue-specific datasets
****

***Abortion***

svyset [pw=v1001]

gen statesen=state*10
replace statesen=statesen+Senator_Number

svy: tab interest Knowledge1 if dabort==1 & statesen!=91 ///
& statesen!=111 & statesen!=321 & statesen!=202 & statesen!=62 & statesen!=102 ///
& statesen!=152 & statesen!=192 & statesen!=282 & statesen!=372 ///
& statesen!=412 & statesen!=422, row

svy: tab interest Knowledge1 if dabort==2 & statesen!=91 ///
& statesen!=111 & statesen!=321 & statesen!=202 & statesen!=62 & statesen!=102 ///
& statesen!=152 & statesen!=192 & statesen!=282 & statesen!=372 ///
& statesen!=412 & statesen!=422, row

***CAFTA***

svyset [pw=v1001]

gen statesen=state*10
replace statesen=statesen+Senator_Number

svy: tab interest Knowledge1 if dcafta==1 & statesen!=321 & statesen!=72, row

svy: tab interest Knowledge1 if dcafta==2 & statesen!=321 & statesen!=72, row

***Capital Gains***

svyset [pw=v1001]

gen statesen=state*10
replace statesen=statesen+Senator_Number

svy: tab interest Knowledge1 if dcap==1 & statesen!=391 & statesen!=502, row

svy: tab interest Knowledge1 if dcap==2 & statesen!=391 & statesen!=502, row

***Immigration***

svyset [pw=v1001]

gen statesen=state*10
replace statesen=statesen+Senator_Number

svy: tab interest Knowledge1 if dimm==1 & statesen!=62 & statesen!=502, row

svy: tab interest Knowledge1 if dimm==2 & statesen!=62 & statesen!=502, row

***Iraq***

svyset [pw=v1001]

gen statesen=state*10
replace statesen=statesen+Senator_Number

svy: tab interest Knowledge1 if diraq==1 & statesen!=502, row

svy: tab interest Knowledge1 if diraq==2 & statesen!=502, row

***Minimum Wage***

svyset [pw=v1001]

gen statesen=state*10
replace statesen=statesen+Senator_Number

svy: tab interest Knowledge1 if dmin==1 & statesen!=321 & statesen!=121, row

svy: tab interest Knowledge1 if dmin==2 & statesen!=502 & statesen!=121, row

***Stem Cell***

svyset [pw=v1001]

svy: tab interest Knowledge1 if dstem==1, row

svy: tab interest Knowledge1 if dstem==2, row


*****
*Models for Tables A7 & A8
*****

*Abortion Models 

clear

use "Data - Issue(Abort)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

**Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number

*Deviator

mlogit Knowledge1 interest educ age woman income pidstrength ptyagree white ///
sendum* if dabort==2 & statesen!=111 & statesen!=321 & statesen!=202 & statesen!=62 & statesen!=102 ///
& statesen!=152 & statesen!=192 & statesen!=282 & statesen!=372 ///
& statesen!=412 & statesen!=422 [pw=v1001], base(1) cluster(Case_Id)

*Non-Deviator

mlogit Knowledge1 interest educ age woman income pidstrength ptyagree white /// 
sendum* if dabort==1 & statesen!=111 & statesen!=321 & statesen!=202 & statesen!=62 & statesen!=102 ///
& statesen!=152 & statesen!=192 & statesen!=282 & statesen!=372 ///
& statesen!=412 & statesen!=422 [pw=v1001], base(1) cluster(Case_Id)

clear

**Stem Cell Models 

use "Data - Issue(Stem)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

*Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number

mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dstem==2 [pw=v1001], base(1) cluster(Case_Id)

mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dstem==1 [pw=v1001], base(1) cluster(Case_Id)

clear

**Min Wage Models

use "Data - Issue(MinWage)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

*Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number


mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dmin==2 ///
& statesen!=321 & statesen!=121 [pw=v1001], base(1) cluster(Case_Id)

mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dmin==1 ///
& statesen!=321 & statesen!=121 [pw=v1001], base(1) cluster(Case_Id)

clear

**Immigration Models 

use "Data - Issue(Imm)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

*Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number


mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dimm==2  ///
& statesen!=62 & statesen!=502 [pw=v1001], base(1) cluster(Case_Id)

mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dimm==1  ///
& statesen!=62 & statesen!=502 [pw=v1001], base(1) cluster(Case_Id)

clear

**CAFTA Models 

use "Data - Issue(cafta)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

*Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number

mlogit Knowledge1 interest educ age woman income pidstrength ptyagree white sendum* if dcafta==2 ///
& statesen!=321 & statesen!=72 [pw=v1001], base(1) cluster(Case_Id)

mlogit Knowledge1 interest educ age woman income pidstrength ptyagree white sendum* if dcafta==1 ///
& statesen!=321 & statesen!=72 [pw=v1001], base(1) cluster(Case_Id)

clear

**Iraq Models 

use "Data - Issue(Iraq)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

*Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number

mlogit Knowledge1 interest educ age woman income pidstrength ptyagree white sendum* if diraq==2 ///
& statesen!=502 [pw=v1001], base(1) cluster(Case_Id)

mlogit Knowledge1 interest educ age woman income pidstrength ptyagree white sendum* if diraq==1 ///
& statesen!=502 [pw=v1001], base(1) cluster(Case_Id)

clear

**Cap Gains Models 

use "Data - Issue(Cap)"

tab senid if senid !=1, gen(sendum) 
sum sendum*

*Party Agreement Coding

tab ptyid2

gen ptyagree = .
replace ptyagree=1 if ptyid2 == 1 & v5016==3 & Senator_Number==1
replace ptyagree=1 if ptyid2 == 3 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 1 & v5016==4 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 3 & v5016==3 & Senator_Number==1
replace ptyagree=0 if ptyid2 == 2 

replace ptyagree=1 if ptyid2 == 1 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 3 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 1 & v5018==4 & Senator_Number==2
replace ptyagree=0 if ptyid2 == 3 & v5018==3 & Senator_Number==2
replace ptyagree=1 if ptyid2 == 2 & v5018==5

label define ptyagree 1 "Party Agreement" 0 "Party Disagreement"
label values ptyagree ptyagree

gen statesen=state*10
replace statesen=statesen+Senator_Number

mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dcap==2 ///
& statesen!=391 & statesen!=502 [pw=v1001], base(1) cluster(Case_Id)

mlogit Knowledge1 interest educ age woman income pidstrength  ptyagree white sendum* if dcap==1 ///
& statesen!=391 & statesen!=502 [pw=v1001], base(1) cluster(Case_Id)


*****
*Predicted Probabilities for Figures A2 and A3
*****

***DEWINE***

mlogit knowcapgainsen1 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowabortsen1 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowcaftasen1 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowimmdewine interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowminwagesen1 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowstemsen1 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowiraqsen1 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

***VOINOVICH***

mlogit knowcapgainsen2 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowabortsen2 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowcaftasen2 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowimmvoin interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowminwagesen2 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowstemsen2 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff

mlogit knowiraqsen2 interest educ age woman income pidstrength repub white if state==36 [pw=v1001], base(0)
prvalue, x(interest=1) rest(median) save
prvalue, x(interest=3) rest(median) diff
