

** After Amelia
set more off
local i = 1
while `i' <= 20 {
 display `i'
 use amelia00sout`i'.dta, clear
 set seed 10`i'
 
 quietly merge 1:1 id using observed00s.dta, keepusing(WT00PRE WT00PO pref00 pref04)
 quietly drop _merge
 quietly drop numbercallspre00-interviewlength04 conversion00 cooperate00 cooperate04 votedin02 repcandtherm02 liberalstherm02 conservtherm02 clintontherm02 militarytherm02 presapprove02 econ02 pid02 thirdparty02 apolitical02 income02
 
 
 quietly drop candthermdiff00 candthermdiff04 
 quietly gen candthermdiff00 = demcandtherm_post00-repcandtherm_post00
 quietly gen partythermdiff00 = demtherm00-reptherm00
 quietly gen partythermavg00 = (demtherm00+reptherm00)/2
 quietly gen candthermdiff04 = demcandtherm04-repcandtherm04

 quietly gen thirdpartydiff00 = nadertherm_post00-demcandtherm_post00 if candthermdiff00>=0 & candthermdiff00!=. 
 quietly replace thirdpartydiff00 = nadertherm_post00-repcandtherm_post00 if candthermdiff00<0 & candthermdiff00!=.
 quietly replace thirdpartydiff00 = buchanantherm00-demcandtherm_post00 if buchanantherm00>nadertherm_post00 & candthermdiff00>=0 
 quietly replace thirdpartydiff00 = buchanantherm00-repcandtherm_post00 if buchanantherm00>nadertherm_post00 & candthermdiff00<0

 quietly gen thirdpartydiff04 = nadertherm_post04-demcandtherm04 if candthermdiff04>=0 & candthermdiff04!=. 
 quietly replace thirdpartydiff04 = nadertherm_post04-repcandtherm04 if candthermdiff04<0 & candthermdiff04!=.


 quietly gen demprepref00 = 0
 quietly replace demprepref00 = 1 if prepref00==2
 quietly gen repprepref00 = 0
 quietly replace repprepref00 = 1 if prepref00==3
 quietly gen otherprepref00 = 0
 quietly replace otherprepref00 = 1 if prepref00==4
 quietly gen undecided00 = 0
 quietly replace undecided00 = 1 if prepref00==1
 quietly replace undecided00 = 1 if prepref00==5

 quietly recode swing00 1=0 2=1



 recode female 1=0 2=1
 recode black 1=0 2=1
 recode catholic 1=0 2=1
 recode south 1=0 2=1
 recode midwest 1=0 2=1
 recode iraqworth 1=0 2=1

 *label drop female black catholic south midwest iraqworth swing00
 
  ** Party Strength

 gen strongpartisan00 = abs(pid00-3)
 gen strongpartisan04 = abs(pid04-3)

 ** Issue Vote

 gen issuevote00 = 0
 replace issuevote00 = issuevote00+1 if (haveopinion11 + seediff11)==2
 replace issuevote00 = issuevote00+1 if (haveopinion12 + seediff12)==2
 replace issuevote00 = issuevote00+1 if (haveopinion13 + seediff13)==2	
 replace issuevote00 = issuevote00+1 if (haveopinion14 + seediff14)==2	
 replace issuevote00 = issuevote00+1 if (haveopinion15 + seediff15)==2	
 replace issuevote00=issuevote00/5
 rename issuevote00 issuevote

 ** Mentions
 
 gen demmentions00 = (dempos00 + repneg00)
 gen repmentions00 = (reppos00 + demneg00) 
 gen demcandmentions00 = (demcandpos00 + repcandneg00)
 gen repcandmentions00 = (repcandpos00 + demcandneg00)
 gen candambiv00 = (demcandmentions00 + repcandmentions00)/2 - abs(demcandmentions00-repcandmentions00)
 gen partyambiv00 = (demmentions00 + repmentions00)/2 - abs(demmentions00-repmentions00)
 gen totalambiv00 = (demmentions00 + repmentions00 + demcandmentions00 + repcandmentions00)/2 - abs(demmentions00 + demcandmentions00 -repmentions00 - repcandmentions00)

 gen mentiondiff00 = demcandmentions00-repcandmentions00
 gen partydislikes00 = repneg00 + demneg00
 gen partylikes00 = reppos00 + dempos00
 gen canddislikes00 = repcandneg00 + demcandneg00
 gen candlikes00 = repcandpos00 + demcandpos00

 recode pref00 4=.
 
 gen newpref00 = pref00
 gen newpref04 = pref04
 
 gen demvreppref00 = 1 if pref00==1
 replace demvreppref00 = 0 if pref00==2
 gen demvreppref04 = 1 if pref04==1
 replace demvreppref04 = 0 if pref04==2

 mlogit pref00 candthermdiff00 thirdpartydiff00 mentiondiff00 demprepref00 undecided00 otherprepref00 swing00 pid00 strongpartisan00 presapprove00 attend00 south midwest west issuevote [pw=WT00PO], iterate(60)
 
 predict hatdem, outcome(1)
 predict hatrep, outcome(2)
 predict hatother, outcome(3)
 
 sum hatother if pref00==1
 sum hatother if pref00==2
 sum hatother if pref00==3
   
 gen uniform = uniform()

 gen repchoice = hatdem+hatrep
 replace newpref00 = 1 if uniform<=hatdem & pref00==.
 replace newpref00 = 2 if hatdem<uniform & uniform<=repchoice & pref00==.
 replace newpref00 = 3 if repchoice<uniform & pref00==.
 drop hatdem hatrep hatother uniform repchoice
  
 local k = 1
 
 
 while `k' <= 10{
 
  quietly mlogit newpref00 candthermdiff00 thirdpartydiff00  demprepref00 undecided00 otherprepref00 swing00 pid00 strongpartisan00 presapprove00 canddislikes00 econ00 partythermdiff00 clintontherm00 betterworse00 attend00 female black thirdparty00 south midwest west education income00 issuevote [pw=WT00PRE], iterate(60)
  quietly predict hatdem, outcome(1)
  quietly predict hatrep, outcome(2)
  quietly predict hatother, outcome(3)
 
  quietly gen uniform = uniform()

  quietly gen repchoice = hatdem+hatrep
  quietly replace newpref00 = 1 if uniform<=hatdem & pref00==.
  quietly replace newpref00 = 2 if hatdem<uniform & uniform<=repchoice & pref00==.
  quietly replace newpref00 = 3 if repchoice<uniform & pref00==.
  
  if `k' == 10 {
    quietly gen draw = repchoice*uniform()
    quietly gen demchoice = 0
    quietly replace demchoice = 1 if draw<=hatdem
    quietly replace demvreppref00 = demchoice if demvreppref00==.
    quietly drop draw demchoice
  }
  quietly drop hatdem hatrep hatother uniform repchoice
  display `k'
  local k = `k'+1
 }
 
 local k = 1
 while `k' <= 10{
   quietly logit demvreppref00 candthermdiff00 thirdpartydiff00 demprepref00 repprepref00 swing00 pid00 strongpartisan00 presapprove00 canddislikes00 econ00 partythermdiff00 clintontherm00 betterworse00 attend00 female black south midwest west education income00 issuevote [pw=WT00PRE], iterate(60)
   quietly predict hatdem, pr
   quietly gen uniform = uniform()
   quietly replace demvreppref00 = 1 if uniform<=hatdem & pref00!=2 & pref00!=1
   quietly replace demvreppref00 = 0 if uniform>hatdem & pref00!=2 & pref00!=1
   quietly drop hatdem uniform
   display `k'
   local k = `k'+1
 }
 
 gen demvote00 = 0 
 replace demvote00 = 1 if newpref00==1
 gen repvote00 = 0 
 replace repvote00 = 1 if newpref00==2
 gen thirdpartyvote00 = 0 
 replace thirdpartyvote00 = 1 if newpref00==3

 
 mlogit newpref04 candthermdiff04 repvote00 thirdpartyvote00 thirdpartydiff04 pid04 presapprove04 betterworse04 iraqaction female black south midwest attend04  education income00, iterate(60)

 predict hatdem, outcome(1)
 predict hatrep, outcome(2)
 predict hatother, outcome(3)
 
 sum hatother if pref04==1
 sum hatother if pref04==2
 sum hatother if pref04==3
   
 gen uniform = uniform()

 gen repchoice = hatdem+hatrep
 replace newpref04 = 1 if uniform<=hatdem & pref04==.
 replace newpref04 = 2 if hatdem<uniform & uniform<=repchoice & pref04==.
 replace newpref04 = 3 if repchoice<uniform & pref04==.
 drop hatdem hatrep hatother uniform repchoice
  
 local k = 1
 
 
 while `k' <= 10{
 
  quietly mlogit newpref04 candthermdiff04 repvote00 thirdpartyvote00 thirdpartydiff04 pid04 strongpartisan04 presapprove04 econ04 iraqaction thirdparty04 fundtherm04 uniontherm04 liberalstherm04 diplomacyscale04 betterworse04 govserv04 attend04 female black south midwest west  education income00 issuevote [pw=WT00PRE], iterate(60)
  quietly predict hatdem, outcome(1)
  quietly predict hatrep, outcome(2)
  quietly predict hatother, outcome(3)
 
  quietly gen uniform = uniform()

  quietly gen repchoice = hatdem+hatrep
  quietly replace newpref04 = 1 if uniform<=hatdem & pref04==.
  quietly replace newpref04 = 2 if hatdem<uniform & uniform<=repchoice & pref04==.
  quietly replace newpref04 = 3 if repchoice<uniform & pref04==.
  if `k' == 10 {
    quietly gen draw = repchoice*uniform()
    quietly gen demchoice = 0
    quietly replace demchoice = 1 if draw<=hatdem
    quietly replace demvreppref04 = demchoice if demvreppref04==.
    quietly drop draw demchoice
  }
  
  quietly drop hatdem hatrep hatother uniform repchoice
  display `k'
  local k = `k'+1
 }

 local k = 1
 while `k' <= 10{
   quietly logit demvreppref04 candthermdiff04 repvote00 thirdpartyvote00 pid04 presapprove04 econ04 iraqaction fundtherm04 uniontherm04 liberalstherm04 diplomacyscale04 betterworse04 govserv04 attend04 female black south midwest west education income00 issuevote [pw=WT00PRE], iterate(60)
   quietly predict hatdem, pr
   quietly gen uniform = uniform()
   quietly replace demvreppref00 = 1 if uniform<=hatdem & pref00!=2 & pref00!=1
   quietly replace demvreppref00 = 0 if uniform>hatdem & pref00!=2 & pref00!=1
   quietly drop hatdem uniform
   display `k'
   local k = `k'+1
 }

 ** Party Mentions
 
 gen avgpartylikes = partylikes00
 gen avgpartydislikes = partydislikes00
 gen avgcandlikes = candlikes00
 gen avgcanddislikes = canddislikes00


 
 ** Efficacy

 gen efficacyindex00 = (efficacy1_00-1)/4 + (efficacy2_00-1)/4 + (efficacy3_00-1)/4 
 gen efficacyindex04 = 1.5*(efficacy1_04/2 + efficacy2_04/2)
 gen avgefficacy = (efficacyindex00+efficacyindex04)/2
 
 * Voter variable
 gen voter = 0 if votedin00!=. & votedin04!=.
 replace voter = 1 if votedin00==2 & votedin04==2
 
 ** Switch variable
 gen switch = .
 replace switch = 0 if newpref00==1 & newpref04==1
 replace switch = 0 if newpref00==2 & newpref04==2
 replace switch = 0 if newpref00==3 & newpref04==3

 replace switch = 1 if newpref00!=1 & newpref04==1
 replace switch = 1 if newpref00!=2 & newpref04==2 
 replace switch = 1 if newpref00!=3 & newpref04==3 
 replace switch = 1 if newpref00==1 & newpref04!=1 
 replace switch = 1 if newpref00==2 & newpref04!=2 
 replace switch = 1 if newpref00==3 & newpref04!=3 
 
 gen demrepswitch = abs(demvreppref00-demvreppref04)

 gen thirdpartyvoter = 0
 replace thirdpartyvoter = thirdpartyvoter+.5 if newpref00==3
 replace thirdpartyvoter = thirdpartyvoter+.5 if newpref04==3
 
 gen conservparty = -1 if conservdem>conservrep
 replace conservparty = 1 if conservrep>conservdem
 replace conservparty = 0 if conservdem==conservrep
 replace conservparty = 0 if conservdemdk==1 
 replace conservparty = 0 if conservrepdk==1
 
 gen partyambivindex = partyambiv00
 gen candambivindex = candambiv00
 gen totalambivindex = totalambiv00
 
 gen undecidedvoter = 0 if undecided00!=. 
 replace undecidedvoter =1 if undecided00==1

 gen demrepund = undecidedvoter
 replace demrepund = 1 if otherprepref00==1
 
 gen swingvoter = 0 if swing00!=.
 replace swingvoter=1 if swing00==1
 replace swingvoter=0 if demprepref00==1 & newpref00==1
 replace swingvoter=0 if repprepref00==1 & newpref00==2 
 replace swingvoter=0 if otherprepref00==1 & newpref00==3
 replace swingvoter=1 if demprepref00==1 & newpref00==2
 replace swingvoter=1 if demprepref00==1 & newpref00==3
 replace swingvoter=1 if repprepref00==1 & newpref00==1
 replace swingvoter=1 if repprepref00==1 & newpref00==3 
 replace swingvoter=1 if otherprepref00==1 & newpref00==1
 replace swingvoter=1 if otherprepref00==1 & newpref00==2
 
 gen partisan = 0 if pid00!=. & pid00!=.
 replace partisan = 1 if strongpartisan00>=2 & partisan!=.
 replace partisan = 1 if strongpartisan04>=2 & partisan!=.
 
 gen strongpartisan  = 0 if pid00!=. & pid04!=.
 replace strongpartisan = strongpartisan+.5 if  strongpartisan00==3 & strongpartisan!=.
 replace strongpartisan = strongpartisan+.5 if  strongpartisan04==3 & strongpartisan!=.

 gen independent = 0 if pid00!=. & pid04!=.
 replace independent = independent+.5 if strongpartisan00==0
 replace independent = independent+.5 if strongpartisan04==0

 gen leaner  = 0 if pid00!=. & pid04!=.
 replace leaner = 1 if  strongpartisan00==1
 replace leaner = 1 if  strongpartisan04==1
 
 replace age = 18 if age<18
 gen agesquared = age^2
 
 gen highschool = 0
 replace highschool = 1 if education>=3 
 
 gen collegegrad = 0
 replace collegegrad = 1 if education>=6

 gen educationsquared= education^2

 gen income = (income00)
 gen incomesquared = income^2
 
 gen noimpdiff = 1-impdiff00

 gen avgpartymentions = avgpartylikes + avgpartydislikes
 gen avgcandmentions = avgcandlikes + avgcanddislikes
 gen avgtotalmentions = avgpartymentions + avgcandmentions

 keep WT00PRE id polsoph00 polsoph04 votedin00 votedin04 pref00 prepref00 pref04 newpref00 newpref04 voter switch demrepswitch thirdpartyvoter female black catholic leaner partisan independent strongpartisan swingvoter undecidedvoter demrepund avgefficacy efficacyindex00 age agesquared education educationsquared highschool collegegrad income incomesquared south midwest noimpdiff conservparty issuevote candambivindex partyambivindex totalambivindex avgpartylikes avgpartydislikes pid00 pid04 avgtotalmentions 
 
 save statami00s_`i'.dta, replace
 
 local i = `i'+1
 
}

clear
