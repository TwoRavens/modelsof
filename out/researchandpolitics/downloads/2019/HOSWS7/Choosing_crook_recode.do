
**Dependent Variables
* Probability to vote 
renam voteprob voteprob1
gen nvoteprob= voteprobability-1
gen voteprob=nvoteprob/10

* Forced choice 
gen select=.
replace select=selectr1 
replace select=select2 if select==. 
replace select=selectrd3 if select==. 

gen Y=0 
replace Y=1 if select==candidate 


**Independent variables - candidates characteristics

encode sex, gen(ngender)
encode party, gen(nparty)
encode outcomes, gen(nperformance)
rename corruption ccorruption
encode ccorruption, gen(ncorruption) 
encode qualities, gen(nqualities)

label drop ngender
label define ngender 1 "man" 2 "woman"
label drop ncorruption
label define ncorruption 1 "accused other parties" 2 "accused judge" 3 "honest" 
label drop nqualities 
label define nqualities 1 "low" 2 "high" 
label drop  nperformance
label define nperformance 1 "good" 2 "bad" 

recode ngender(1=0 "Man")(2=1 "Woman"), gen (woman)
recode ncorruption (3=0 "Honest") (1=1 "Accused parties") (2=2 "Accused judge"), gen (corruption)
recode corruption (1/2=1 "Corrupt") (0=0 "Honest"), gen (corrupt)
recode nperformance (2=0 "Bad outcomes")(1=1 "Good outcomes"), gen (strongperfor)
recode strongperfor (0=1 "Bad outcomes") (1=0 "Good outcomes"), gen (weakperfor)
recode nqualities (1=0 "Low qualities") (2=1 "High qualities"), gen (highqualities) 
recode highqualities (0=1 "Low qualities") (1=0 "High qualities"), gen (lowqualities)



** Respondents characteristics

* Party id

destring partyid, force replace 
la define partyidl  1 "PP"	 2 "PSOE"	 3 "Podemos"	 4 "Ciudadanos"	 5 "IU"	6 "ERC" 7 "CDC" 8 "PNV" 9 "Bildu" 10 "BNG"	11 "Compromís"	12 "Other parties" 13 "No party id"
la val partyid partyidl
recode partyid (1=1 "PP") (2=2 "PSOE") (3=3 "Podemos") (4=4 "Ciudadanos")(5/12=5 "Other parties")(13=6 "No party id"), gen (partyidr)

*Copartisanship (Generate a new variable that takes into account party id and party seen in the experiment) 

gen copartisanship=.
replace copartisanship=1 if  (partyidr==1 & nparty==2) | (partyidr==2 & nparty==3) | (partyidr==3 & nparty==4) | (partyidr==4 & nparty==1)  
replace copartisanship=2 if (partyidr==1 & nparty==3) | (partyidr==1 & nparty==4) | (partyidr==1 & nparty==1) | (partyidr==2 & nparty==2) | (partyidr==2 & nparty==4) | (partyidr==2 & nparty==1) | (partyidr==3 & nparty==2) | (partyidr==3 & nparty==3) | (partyidr==3 & nparty==1) | (partyidr==4 & nparty==2) | (partyidr==4 & nparty==3) | (partyidr==4 & nparty==4) | (partyidr==5 & nparty==1) | (partyidr==5 & nparty==2)| (partyidr==5 & nparty==3)| (partyidr==5 & nparty==4)       
replace copartisanship=3 if (partyidr==6)

la define copartisanshipl 1 "Same party" 2 "Different party" 3 "No partisanship"
la val copartisanship copartisanshipl

recode copartisanship (1=0 "Same party") (2/3=1 "Different party"), gen (differentp) 
recode copartisanship (1=1 "Same party") (2/3=0 "Different party"), gen (samep)


*Party preference (Generate a new variable that takes into account the predisposition to vote for the party seen in the experiment)

gen partypref =.
replace partypref= voteprob4_1 if nparty==2 //PP 
replace partypref= voteprob4_2 if nparty==3 //PSOE
replace partypref= voteprob4_4 if nparty==4 //Podemos 
replace partypref= voteprob4_5 if nparty==1 //Ciudadanos 

recode partypref (0/3=3 "Party vp 0-3%") (4/6=2 "Party vp 4-6%") (7/10=1 "Party vp 7-10%"), gen (partypref3) 


*Satisfaction with democracy
replace satisfdemo=satisfdemo-1
recode satisfdemo (0/4=1 "Unsatisfied")(5=2 "Neither") (6/10=3 "Satisfied"), gen (satisfdemo3)


* Ideology
replace ideol=ideol-1
recode ideol(11=.), gen (ideo)


 *Political sofistication 

recode polsoph1 (1/3=0 "wrong")(5=0 "wrong")(4=1 "correct"), gen (polsoph1correct)
recode polsoph2 (1/4=0 "wrong") (6=0 "wrong") (5=1 "correct"), gen (polsoph2correct) 
recode polsoph3 (1/2=0 "wrong") (3=1 "correct") (4/5=0 "wrong"), gen (polsoph3correct) 
recode polsoph4 (0/19.9=0 "wrong") (20/22.9=1 "correct") (23/100=0 "wrong") (.=0 "wrong") , gen (polsoph4correct) 
gen polsoph= polsoph1correct+polsoph2correct+polsoph3correct+polsoph4correct 


*Working status
recode sitlab 1/3=0 4/5=1 6/8=0, gen(unemployed)

*Respondents identification nomber 
destring gid, gen (id)
