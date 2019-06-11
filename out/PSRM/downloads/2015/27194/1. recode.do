****************************************
* Political Science Research and Methods
* Replication material for the article "The Role of Party Identification in Spatial Models of Voting Choice"
*
* Romain Lachat
* Universitat Pompeu Fabra, Barcelona
* mail@romain-lachat.ch
*
* This syntax file recodes the relevant variables from the 1994, 1998, 2002 and 2006 Dutch 
* Election studies, and merges them into a pooled dataset ("nlstacked.dta")
* The syntax "2. analysis.do" contains the command to replicate the papers' tables and graphs, based on this merged file.
****************************************


cd "c:\data\"


***********************
* 1994 Election Study *
***********************

clear
set mem 10m
use nl1994

* Party utilities
for num 472/474 476 \ num 1 2 4 3: g utilY=(varX-1)/9
for num 1 2 3 4 \ any pvda vvd cda d66: la var utilX "electoral utility Y"


* Party identifiers
g identifier=var021
recode identifier 1=1 2=0 *=.
la de identifier 0"no pid" 1 "party identifier"
la val identifier identifier
la var identifier "Party identifier"


* Party identification: which party
g pid=var027
recode pid 1=1 2=3 3=2 4=4 5=5 7=6 11=8 6 8 9 10 12 13=10 *=.
la de pid 1 PvdA 2 VVD 3 CDA 4 D66 5 GroenLinks 6 GPV 7 LPF 8 SP 9 ChristenUnie 10 Others
la val pid pid
la var pid "Party identification"


* Issue position: euthanasia
g iss1=(var061-1)/6
la var iss1 "Voter position: euthanasia"
la de iss1 0 forbid 1 allow
la val iss1 iss1
for num 57/60 \ num 3 1 2 4: g iss1pY=(var0X-1)/6
for num 1/4 \ any pvda vvd cda d66: la var iss1pX "Party position: euthanasia - Y" \ la val iss1pX iss1

* Issue position: crime
g iss2=((var066*-1)+7)/6
la var iss2 "Voter position: crime"
la de iss2 0 "tough enough" 1 "much tougher"
la val iss2 iss2
for num 62/65 \ num 3 1 2 4: g iss2pY=((var0X*-1)+7)/6
for num 1/4 \ any pvda vvd cda d66: la var iss2pX "Party position: crime - Y" \ la val iss2pX iss2

* Issue position: income differences
g iss3=(var071-1)/6
la var iss3 "Voter position: income differences"
la de iss3 0 "larger differences" 1 "smaller differences"
la val iss3 iss3
for num 67/70 \ num 3 1 2 4: g iss3pY=(var0X-1)/6
for num 1/4 \ any pvda vvd cda d66: la var iss3pX "Party position: income differences - Y" \ la val iss3pX iss3

* Issue position: nuclear plants
g iss4=(var076-1)/6
la var iss4 "Voter position: nuclear plants"
la de iss4 0 "more nuclear plants" 1 "no nuclear plants"
la val iss4 iss4
for num 72/75 \ num 3 1 2 4: g iss4pY=(var0X-1)/6
for num 1/4 \ any pvda vvd cda d66: la var iss4pX "Party position: nuclear plants - Y" \ la val iss4pX iss4

* Issue position: ethnic minorities
g iss5=(var081-1)/6
la var iss5 "Voter position: ethnic minorities"
la de iss5 0 "keep own culture" 1 "adjust completely"
la val iss5 iss5
for num 77/80 \ num 3 1 2 4: g iss5pY=(var0X-1)/6
for num 1/4 \ any pvda vvd cda d66: la var iss5pX "Party position: ethnic minorities - Y" \ la val iss5pX iss5

* Issue position: European unification
g iss6=(var331-1)/6
la var iss6 "Voter position: european unification"
la de iss6 0 "going too fast" 1 "as fast as possible"
la val iss6 iss6
for num 324/327 \ num 3 1 2 4: g iss6pY=(varX-1)/6
for num 1/4 \ any pvda vvd cda d66: la var iss6pX "Party position: european unification - Y" \ la val iss6pX iss6


* Political sophistication
g soph=var357/12
la de soph 0 low 1 high
la val soph soph
la var soph "Political sophistication"


* Social class
for num 1/5: g classX=var178==X \ replace classX=. if var178==.
for num 1/5 \ any "upper class" "upper middle class" "middle class" "upper working class" "working class": la var classX "Y"

* Age
g age=var172

* Gender
g gender=var176-1
la de gender 0 male 1 female
la val gender gender

* Religious denomination
g relig=var159
recode relig 1=1 2=2 3=3 4 5=4 *=.
la de relig 1 catholic 2"dutch reformed" 3 calvinist 4"other, none"
la val relig relig
for num 1/4: g religX=relig
recode relig1 1=1 2/4=0
recode relig2 2=1 1 3 4=0
recode relig3 3=1 1 2 4=0
recode relig4 4=1 1/3=0
la var relig1 catholic
la var relig2 reformed
la var relig3 calvinist
la var relig4 "other, none"

* Religiosity (church attendance)
g religiosity=var162
recode religiosity 1 2 3=1 *=0
la de religiosity 0 low 1 high
la val religiosity religiosity
la var religiosity "Church attendance"


keep util1-religiosity
g year=1994
compress
save nl1994r, replace



***********************
* 1998 Election Study *
***********************

clear
set mem 10m
use nl1998


* Party utilities
for num 830/834 836 \ num 1 2 4 5 3 6: g utilY=(v0X-1)/9
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var utilX "electoral utility Y"


* Party identifiers
g identifier=v0050
recode identifier 1=1 2=0 *=.
la de identifier 0"no pid" 1 "party identifier"
la val identifier identifier
la var identifier "Party identifier"

* Party identification: which party
g pid=v0059
recode pid 1=1 2=3 3=2 4=4 5=5 7=6 12=8 6 8/11 13/70=10 *=.
la de pid 1 PvdA 2 VVD 3 CDA 4 D66 5 GroenLinks 6 GPV 7 LPF 8 SP 9 ChristenUnie 10 Others
la val pid pid
la var pid "Party identification"


* Issue position: euthanasia
g iss1=(v0116-1)/6
la var iss1 "Voter position: euthanasia"
la de iss1 0 forbid 1 allow
la val iss1 iss1
for num 110/115 \ num 3 1 2 4 5 6: g iss1pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss1pX "Party position: euthanasia - Y" \ la val iss1pX iss1

* Issue position: income differences
g iss3=(v0123-1)/6
la var iss3 "Voter position: income differences"
la de iss3 0 "larger differences" 1 "smaller differences"
la val iss3 iss3
for num 117/122 \ num 3 1 2 4 5 6: g iss3pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss3pX "Party position: income differences - Y" \ la val iss3pX iss3

* Issue position: asylum seekers
g iss7=(v0130-1)/6
la var iss7 "Voter position: asylum seekers"
la de iss7 0"admit more" 1"send back"
la val iss7 iss7
for num 124/129 \ num 3 1 2 4 5 6: g iss7pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss7pX "Party position: asylum seekers - Y" \ la val iss7pX iss7

* Issue position: European unification
g iss6=(v0137-1)/6
la var iss6 "Voter position: european unification"
la de iss6 0 "going too fast" 1 "as fast as possible"
la val iss6 iss6
for num 131/136 \ num 3 1 2 4 5 6: g iss6pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss6pX "Party position: european unification - Y" \ la val iss6pX iss6

* Issue position: ethnic minorities
g iss5=(v0144-1)/6
la var iss5 "Voter position: ethnic minorities"
la de iss5 0 "preserve cultural customs" 1 "completely adjust to dutch culture"
la val iss5 iss5
for num 138/143 \ num 3 1 2 4 5 6: g iss5pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss5pX "Party position: ethnic minorities - Y" \ la val iss5pX iss5

* Issue position: social benefits
g iss8=(v0736-1)/6
la var iss8 "Voter position: social benefits"
la de iss8 0 "too low" 1 "too high"
la val iss8 iss8
for num 730/735 \ num 3 1 2 4 5 6: g iss8pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss8pX "Party position: social benefits - Y" \ la val iss8pX iss8

* Issue position: nuclear plants
g iss4=(v0743-1)/6
la var iss4 "Voter position: nuclear plants"
la de iss4 0 "more nuclear plants" 1 "no nuclear plants"
la val iss4 iss4
for num 737/742 \ num 3 1 2 4 5 6: g iss4pY=(v0X-1)/6
for num 1/6 \ any pvda vvd cda d66 groenlinks gpv: la var iss4pX "Party position: nuclear plants - Y" \ la val iss4pX iss4


* Political sophistication
g soph=v0202/12
la de soph 0 low 1 high
la val soph soph
la var soph "Political sophistication"

* Social class
for num 1/5: g classX=v0394==X \ replace classX=. if v0394==.
for num 1/5 \ any "upper class" "upper middle class" "middle class" "upper working class" "working class": la var classX "Y"

* Age
g age=v0316

* Gender
g gender=v0288-1
la de gender 0 male 1 female
la val gender gender

* Religious denomination
g relig=v0377
recode relig 1=1 2=2 3=3 4/8=4 *=.
la de relig 1 catholic 2"dutch reformed" 3 calvinist 4"other, none"
la val relig relig
for num 1/4: g religX=relig
recode relig1 1=1 2/4=0
recode relig2 2=1 1 3 4=0
recode relig3 3=1 1 2 4=0
recode relig4 4=1 1/3=0
la var relig1 catholic
la var relig2 reformed
la var relig3 calvinist
la var relig4 "other, none"

* Religiosity (church attendance)
g religiosity=v0382
recode religiosity 1 2 3=1 *=0
la de religiosity 0 low 1 high
la val religiosity religiosity
la var religiosity "Church attendance"

keep util1-religiosity
g year=1998
compress
save nl1998r, replace




***********************
* 2002 Election Study *
***********************

clear
set mem 50m
use nl2002

* Party utilities
for num 932/935 941 \ num 3 1 2 4 7: g utilY=(v0X-1)/9
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var utilX "electoral utility Y"


* Party identifiers
g identifier=v0087
recode identifier 1=1 2=0 *=.
la de identifier 0"no pid" 1 "party identifier"
la val identifier identifier
la var identifier "Party identifier"

* Party identification: which party
g pid=v0103 if v0103<14
replace pid=v0107 if v0107<14
replace pid=v0110 if v0110<14
replace pid=. if v0103==14 | v0107==14 | v0110==14
recode pid 1=1 2=3 3=2 4=4 5=5 7=9 9=7 10=8 6 8 11/13=10 *=.
la de pid 1 PvdA 2 VVD 3 CDA 4 D66 5 GroenLinks 6 GPV 7 LPF 8 SP 9 ChristenUnie 10 Others
la val pid pid
la var pid "Party identification"


* Issue position: euthanasia
g iss1=(v0209-1)/6
la var iss1 "Voter position: euthanasia"
la de iss1 0 forbid 1 allow
la val iss1 iss1
for num 204/208 \ num 3 1 2 4 7: g iss1pY=(v0X-1)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss1pX "Party position: euthanasia - Y" \ la val iss1pX iss1

* Issue position: income differences
g iss3=(v0215-1)/6
la var iss3 "Voter position: income differences"
la de iss3 0 "larger differences" 1 "smaller differences"
la val iss3 iss3
for num 210/214 \ num 3 1 2 4 7: g iss3pY=(v0X-1)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss3pX "Party position: income differences - Y" \ la val iss3pX iss3

* Issue position: asylum seekers
g iss7=(v0221-1)/6
la var iss7 "Voter position: asylum seekers"
la de iss7 0"admit more" 1"send back"
la val iss7 iss7
for num 216/220 \ num 3 1 2 4 7: g iss7pY=(v0X-1)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss7pX "Party position: asylum seekers - Y" \ la val iss7pX iss7

* Issue position: crime
g iss2=(v0227-1)/6
la var iss2 "Voter position: crime"
la de iss2 0 "gvt too tough" 1 "gvt not tough enough"
la val iss2 iss2
for num 222/226 \ num 3 1 2 4 7: g iss2pY=(v0X-1)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss2pX "Party position: crime - Y" \ la val iss2pX iss2


* Issue position: nuclear plants
g iss4=(v0875-1)/6
la var iss4 "Voter position: nuclear plants"
la de iss4 0 "more nuclear plants" 1 "no nuclear plants"
la val iss4 iss4
for num 869/872 874 \ num 3 1 2 4 7: g iss4pY=(v0X-1)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss4pX "Party position: nuclear plants - Y" \ la val iss4pX iss4

* Issue position: ethnic minorities
g iss5=(v0882-1)/6
la var iss5 "Voter position: ethnic minorities"
la de iss5 0 "preserve cultural customs" 1 "completely adjust to dutch culture"
la val iss5 iss5
for num 876/879 881 \ num 3 1 2 4 7: g iss5pY=(v0X-1)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss5pX "Party position: ethnic minorities - Y" \ la val iss5pX iss5

* Issue position: European unification
g iss6=((v0889*-1)+7)/6
la var iss6 "Voter position: european unification"
la de iss6 0 "gone too far" 1 "go further"
la val iss6 iss6
for num 883/886 888 \ num 3 1 2 4 7: g iss6pY=((v0X*-1)+7)/6
for num 1/4 7 \ any pvda vvd cda d66 lpf: la var iss6pX "Party position: european unification - Y" \ la val iss6pX iss6


* Political sophistication
g soph=v0325/12
la de soph 0 low 1 high
la val soph soph
la var soph "Political sophistication"


* Social class
for num 1/5: g classX=v0505==X \ replace classX=. if v0505==.
for num 1/5 \ any "upper class" "upper middle class" "middle class" "upper working class" "working class": la var classX "Y"

* Age
g age=v0457

* Gender
g gender=v0459-1
la de gender 0 male 1 female
la val gender gender

* Religious denomination
g relig=v0489
recode relig 1=1 2/6=2 7/12=3 13/15=4 *=.
replace relig=4 if v0488==2
la de relig 1 catholic 2"dutch reformed" 3 calvinist 4"other, none"
la val relig relig
for num 1/4: g religX=relig
recode relig1 1=1 2/4=0
recode relig2 2=1 1 3 4=0
recode relig3 3=1 1 2 4=0
recode relig4 4=1 1/3=0
la var relig1 catholic
la var relig2 reformed
la var relig3 calvinist
la var relig4 "other, none"

* Religiosity (church attendance)
g religiosity=v0493
recode religiosity 1 2 3=1 *=0
la de religiosity 0 low 1 high
la val religiosity religiosity
la var religiosity "Church attendance"


keep util3-religiosity
g year=2002
compress
save nl2002r, replace



***********************
* 2006 Election Study *
***********************

clear
set mem 50m
use nl2006

* Party utilities
for num 110/112 116 117 \ num 1 3 2 9 8: g utilY=(vX-1)/9
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie" : la var utilX "electoral utility Y"


* Party identifiers
g identifier=v060
recode identifier 1=1 2=0 *=.
la de identifier 0"no pid" 1 "party identifier"
la val identifier identifier
la var identifier "Party identifier"

* Party identification: which party
g pid=v063
replace pid=v064 if v063==.
recode pid 1=3 2=1 3=2 4=5 5=8 6=4 7=9 9=7 8 10/30=10 *=.
la de pid 1 PvdA 2 VVD 3 CDA 4 D66 5 GroenLinks 6 GPV 7 LPF 8 SP 9 ChristenUnie 10 Others
la val pid pid
la var pid "Party identification"


* Issue position: euthanasia
g iss1=(v135-1)/6
la var iss1 "Voter position: euthanasia"
la de iss1 0 forbid 1 allow
la val iss1 iss1
for num 130/134 \ num 3 1 2 8 9: g iss1pY=(vX-1)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss1pX "Party position: euthanasia - Y" \ la val iss1pX iss1

* Issue position: income differences
g iss3=(v145-1)/6
la var iss3 "Voter position: income differences"
la de iss3 0 "larger differences" 1 "smaller differences"
la val iss3 iss3
for num 140/144 \ num 3 1 2 8 9: g iss3pY=(vX-1)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss3pX "Party position: income differences - Y" \ la val iss3pX iss3

* Issue position: asylum seekers
g iss7=(v155-1)/6
la var iss7 "Voter position: asylum seekers"
la de iss7 0"admit more" 1"send back"
la val iss7 iss7
for num 150/154 \ num 3 1 2 8 9: g iss7pY=(vX-1)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss7pX "Party position: asylum seekers - Y" \ la val iss7pX iss7

* Issue position: crime
g iss2=(v165-1)/6
la var iss2 "Voter position: crime"
la de iss2 0 "gvt too tough" 1 "gvt not tough enough"
la val iss2 iss2
for num 160/164 \ num 3 1 2 8 9: g iss2pY=(vX-1)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss2pX "Party position: crime - Y" \ la val iss2pX iss2

* Issue position: nuclear plants
g iss4=(v175-1)/6
la var iss4 "Voter position: nuclear plants"
la de iss4 0 "more nuclear plants" 1 "no nuclear plants"
la val iss4 iss4
for num 170/174 \ num 3 1 2 8 9: g iss4pY=(vX-1)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss4pX "Party position: nuclear plants - Y" \ la val iss4pX iss4

* Issue position: ethnic minorities
g iss5=(v185-1)/6
la var iss5 "Voter position: ethnic minorities"
la de iss5 0 "preserve cultural customs" 1 "completely adjust to dutch culture"
la val iss5 iss5
for num 180/184 \ num 3 1 2 8 9: g iss5pY=(vX-1)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss5pX "Party position: ethnic minorities - Y" \ la val iss5pX iss5

* Issue position: European unification
g iss6=((v195*-1)+7)/6
la var iss6 "Voter position: european unification"
la de iss6 0 "gone too far" 1 "go further"
la val iss6 iss6
for num 190/194 \ num 3 1 2 8 9: g iss6pY=((vX*-1)+7)/6
for num 1 2 3 8 9 \ any pvda vvd cda sp "christen unie": la var iss6pX "Party position: european unification - Y" \ la val iss6pX iss6


* Political sophistication
g soph=v255/12
la de soph 0 low 1 high
la val soph soph
la var soph "Political sophistication"


* Social class
for num 1/5: g classX=v428==X \ replace classX=. if v428==.
for num 1/5 \ any "upper class" "upper middle class" "middle class" "upper working class" "working class": la var classX "Y"

* Age
g age=2006-v421

* Gender
g gender=v420-1
la de gender 0 male 1 female
la val gender gender

* Religious denomination
g relig=v426
recode relig 1=4 2=1 3 5=2 4=3 6 7=4 *=.
la de relig 1 catholic 2"dutch reformed" 3 calvinist 4"other, none"
la val relig relig
for num 1/4: g religX=relig
recode relig1 1=1 2/4=0
recode relig2 2=1 1 3 4=0
recode relig3 3=1 1 2 4=0
recode relig4 4=1 1/3=0
la var relig1 catholic
la var relig2 reformed
la var relig3 calvinist
la var relig4 "other, none"

* Religiosity (church attendance)
g religiosity=v427
recode religiosity 1 2 3=1 *=0
la de religiosity 0 low 1 high
la val religiosity religiosity
la var religiosity "Church attendance"

keep util1-religiosity
g year=2006
compress
save nl2006r, replace



**************************
*   Merge datasets and   *
* reshape to long format *
**************************

clear
set mem 300m
use nl1994r.dta
append using nl1998r
append using nl2002r
append using nl2006r


* Reshape dataset
g id=_n
la var id "Respondent ID"
reshape long util iss1p iss2p iss3p iss4p iss5p iss6p iss7p iss8p, i(id) j(party)
drop if util==.
for num 1/8 \ any euthanasia crime "income diff" "nuclear plants" "ethnic minorities" "European unification" "asylum seekers" "social benefits": la var issX "Respondent: Y" \ la var issXp "Party: Y"
la var util "Party utility"
la de party 1 PvdA 2 VVD 3 CDA 4 D66 5 GroenLinks 6 GPV 7 LPF 8 SP 9 ChristenUnie
la val party party


* Party identification dummies
g idown=.
replace idown=1 if identifier==1 & pid==party
replace idown=0 if identifier==1 & pid!=party & pid!=.
replace idown=0 if identifier==0

g idother=.
replace idother=1 if identifier==1 & pid!=party & pid!=.
replace idother=0 if identifier==1 & pid==party
replace idother=0 if identifier==0

g idnone=idown==idother
replace idnone=. if idown==. | idother==.

g idyes=idnone
recode idyes 0=1 1=0



* Voter-party distances: squared distance between voter and perceived party position
for num 1/8: g prox2_issX=(issX-issXp)^2
for num 1/8 \ any euthanasia crime "income diff" "nuclear plants" "ethnic minorities" "European unification" "asylum seekers" "social benefits": la var prox2_issX "squared voter-party distance, Y"

* Voter-party distances: linear distance between voter and perceived party position
for num 1/8: g prox_issX=abs(issX-issXp)
for num 1/8 \ any euthanasia crime "income diff" "nuclear plants" "ethnic minorities" "European unification" "asylum seekers" "social benefits": la var prox_issX "linear voter-party distance, Y"

* Voter-party distances: squared distance between voter and average perceived party position
* NB:	the average perceived party positions are computed using the same sample of respondents than for
*	the regression models. This subset of obsevations is identified by the variable 'sample'
g sample=0
quietly regress util prox2_iss1-prox2_iss6 idown idother if year==1994
replace sample=1 if e(sample)
quietly regress util prox2_iss1 prox2_iss3-prox2_iss8 idown idother if year==1998
replace sample=1 if e(sample)
quietly regress util prox2_iss1-prox2_iss7 idown idother if year==2002
replace sample=1 if e(sample)
quietly regress util prox2_iss1-prox2_iss7 idown idother if year==2006
replace sample=1 if e(sample)

for num 1/8: g prox2m_issX=.
foreach y of numlist 1994(4)2006 {
	foreach v in iss1 iss2 iss3 iss4 iss5 iss6 iss7 iss8 {
		foreach p of numlist 1/9 {
			quietly su `v'p if year==`y' & party==`p' & sample==1
			if r(N)>0 {
				quietly replace prox2m_`v'=(`v'-`r(mean)')^2 if year==`y' & party==`p' & sample==1
			}
		}
	}
}
for num 1/8 \ any euthanasia crime "income diff" "nuclear plants" "ethnic minorities" "European unification" "asylum seekers" "social benefits": la var prox2m_issX "squared distance voter-party (average perception), Y"


* Weights (1 divided by the number of available observations for a given respondent)
bys id: egen weighti1994=count(prox_iss1+prox_iss2+prox_iss3+prox_iss4+prox_iss5+prox_iss6)
bys id: egen weighti1998=count(prox_iss1+prox_iss3+prox_iss4+prox_iss5+prox_iss6+prox_iss7+prox_iss8)
bys id: egen weighti2002=count(prox_iss1+prox_iss2+prox_iss3+prox_iss4+prox_iss5+prox_iss6+prox_iss7)
bys id: egen weighti2006=count(prox_iss1+prox_iss2+prox_iss3+prox_iss4+prox_iss5+prox_iss6+prox_iss7)
g weighti=.
for any 1994 1998 2002 2006: replace weighti=1/weightiX if year==X
drop weighti1994 weighti1998 weighti2002 weighti2006


* Party-specific constants for models with valence terms
for any pvda vvd cda d66 gl gpv lpf sp christenunie \ num 1/9: g X=party==Y


* Interactions issues x party identification
for var prox2_iss1-prox_iss8 prox2m_iss1-prox2m_iss8: g idown_X=X*idown \ g idother_X=X*idother \ g idnone_X=X*idnone \ g idyes_X=X*idyes


* Save merged file
order id year party util identifier pid idown idother idnone idyes iss1 iss2 iss3 iss4 iss5 iss6 iss7 iss8 iss1p iss2p iss3p iss4p iss5p iss6p iss7p iss8p age gender class1-class5 relig relig1-relig4 religiosity
compress
save nlstacked, replace


