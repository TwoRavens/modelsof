***************** TESS Economists and Public Opinion - Coding and Analysis ********************

***** Coding of Key Variables *****

*Experimental treatment indicators*

gen condition=XTESS138

gen control=0
replace control=1 if condition==11

gen nocue=0
replace nocue=1 if condition>0 & condition<6

gen cue=0
replace cue=1 if condition>5 & condition<11

*Political vars (r=.61)*

gen pid=XPARTY7
omscore pid
drop pid
rename rr_pid pid
recode01 pid

gen ideo=xideo
recode ideo -1=.
recode01 ideo

gen right01=(ideo01+pid01)/2

*Demographics*

gen age=ppage
recode01 age

gen educ=ppeduc
recode educ 1/8=0 9=1 10=2 11=3 12=4 13/14=5
tab educ, gen(educ)

gen college=.
replace college=0 if educ==0|educ==1|educ==2|educ==3
replace college=1 if educ==4|educ==5

gen white=ppethm
recode white 1=1 else=0

gen black=ppethm
recode black 2=1 else=0

gen hisp=ppethm
recode hisp 4=1 else=0

gen male=ppgender
recode male 1=1 2=0

gen income=ppincimp
recode01 income

gen south=PPREG4
recode south 3=1 else=0

**Survey Questions (correspond with condition #'s)**

*“The average US citizen would be better off if a larger number of highly educated foreign workers were 
*legally allowed to immigrate to the US each year.”

gen imm=.
replace imm=Q1A if condition==1
replace imm=Q6A if condition==6
recode imm -1=. 5=.

gen immdk=.
replace immdk=0 if imm==1|imm==2|imm==3|imm==4
replace immdk=1 if Q1A==5|Q6A==5

gen timm=.
replace timm=-1 if imm==3|imm==4
replace timm=0 if immdk==1
replace timm=1 if imm==1|imm==2

*“Long run fiscal sustainability in the U.S. will reQuire cuts in currently promised Medicare and Medicaid 
*benefits and/or tax increases that include higher taxes on households with incomes below $250,000.”

gen cuts=.
replace cuts=Q2A if condition==2
replace cuts=Q7A if condition==7
recode cuts -1=. 5=.

gen cutsdk=.
replace cutsdk=0 if cuts==1|cuts==2|cuts==3|cuts==4
replace cutsdk=1 if Q2A==5|Q7A==5

gen tcuts=.
replace tcuts=-1 if cuts==3|cuts==4
replace tcuts=0 if cutsdk==1
replace tcuts=1 if cuts==1|cuts==2

*“Trade with China makes most Americans better off because, among other advantages, 
*they can buy goods that are made or assembled more cheaply in China.”

gen china=.
replace china=Q3A if condition==3
replace china=Q8A if condition==8
recode china -1=. 5=.

gen chinadk=.
replace chinadk=0 if china==1|china==2|china==3|china==4
replace chinadk=1 if Q3A==5|Q8A==5

gen tchina=.
replace tchina=-1 if china==3|china==4
replace tchina=0 if chinadk==1
replace tchina=1 if china==1|china==2

*“A cut in federal income tax rates in the US right now would raise taxable income 
*enough so that the annual total tax revenue would be higher within five years than without the tax cut.”

gen tax=.
replace tax=Q4A if condition==4
replace tax=Q9A if condition==9
recode tax -1=. 5=.

gen taxdk=.
replace taxdk=0 if tax==1|tax==2|tax==3|tax==4
replace taxdk=1 if Q4A==5|Q9A==5

gen ttax=.
replace ttax=-1 if tax==1|tax==2
replace ttax=0 if taxdk==1
replace ttax=1 if tax==3|tax==4

*“If the US replaced its discretionary monetary policy regime with a gold standard, 
*defining a ‘dollar’ as a specific number of ounces of gold, the price-stability and 
*employment outcomes would be better for the average American.”

gen gold=.
replace gold=Q5A if condition==5
replace gold=Q10A if condition==10
recode gold -1=. 5=.

gen golddk=.
replace golddk=0 if gold==1|gold==2|gold==3|gold==4
replace golddk=1 if Q5A==5|Q10A==5

gen tgold=.
replace tgold=-1 if gold==1|gold==2
replace tgold=0 if golddk==1
replace tgold=1 if gold==3|gold==4

*Trust in economists (r=.49)*

gen trust=Q11A
recode trust -1=.
omscore trust
drop trust
rename rr_trust trust
recode01 trust

gen rely=Q12A
recode rely -1=.
recode01 rely

gen trustecon=(trust01+rely01)/2


***** Analysis *****

***Bases of trust***

reg trustecon age01 male black hisp educ2-educ6 income01 south right01 if condition==11, robust
reg trustecon age01 male black hisp educ2-educ6 income01 south right01 if condition==11, robust level(68)

reg trustecon age01 male black hisp college income01 south right01 if condition==11, robust


***Models for persuasion***

mlogit timm cue, b(0)
mlogit timm cue, b(-1)

estsimp mlogit timm cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit tcuts cue, b(0)
mlogit tcuts cue, b(-1)

estsimp mlogit tcuts cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit tchina cue, b(0)
mlogit tchina cue, b(-1)

estsimp mlogit tchina cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit ttax cue, b(0)
mlogit ttax cue, b(-1)

estsimp mlogit ttax cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit tgold cue, b(0)
mlogit tgold cue, b(-1)

estsimp mlogit tgold cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


egen combined=rowtotal(timm tcuts tchina ttax tgold)
replace combined=. if condition==11

mlogit combined cue, b(0)
mlogit combined cue, b(-1)

estsimp mlogit combined cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


***Motivated skepticism***

*Gap between predicted and actual

reg trustecon age01 male black hisp college income01 south right01 if control==1, robust

predict p_trust if condition>5 & condition<11, xb

gen trustdiff = trustecon - p_trust

*combined1 = disagree with consensus, combined3 = agree, baseline = uncertain

tab combined, gen(combined)

reg trustdiff combined1 combined2 combined3, robust noconstant

reg trustdiff combined1 combined2 combined3 if condition==6|condition==7|condition==8, robust noconstant

reg trustdiff combined1 combined2 combined3 if condition==9|condition==10, robust noconstant



















































