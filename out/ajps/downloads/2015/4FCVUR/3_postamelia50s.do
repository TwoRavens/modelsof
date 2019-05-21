
set more off
** After Amelia

set seed 49301

local i = 1
while `i' <= 10 {

 use amelia50sout`i'.dta, clear
 set seed 10`i'
 
 quietly merge 1:1 id using observed50s.dta, keepusing(pref56 pref60)
 quietly drop _merge
 quietly drop pre56-post60 finsit58 pid58-apolitical58 dempos58 demneg58 reppos58 repneg58 income58
 
 quietly gen canddiff56 = demcandpos56+repcandneg56-repcandpos56-demcandneg56
 quietly gen partydiff56 = dempos56+repneg56-reppos56-demneg56
 quietly gen candpartylike56 = (demcandpos56 + repcandpos56 + dempos56 + reppos56)
 quietly gen candpartydislike56 = (demcandneg56 + repcandneg56 + demneg56 + repneg56)
 quietly gen partylikes56 = dempos56 + reppos56
 quietly gen partydislikes56 = demneg56 + repneg56
 quietly gen candlikes56 = demcandpos56 + repcandpos56
 quietly gen canddislikes56 = demcandneg56 + repcandneg56

 quietly gen canddiff60 = demcandpos60+repcandneg60-repcandpos60-demcandneg60
 quietly gen partydiff60 = dempos60+repneg60-reppos60-demneg60
 quietly gen candpartylike60 = (demcandpos60 + repcandpos60 + dempos60 + reppos60)
 quietly gen candpartydislike60 = (demcandneg60 + repcandneg60 + demneg60 + repneg60)
 quietly gen partylikes60 = dempos60 + reppos60
 quietly gen partydislikes60 = demneg60 + repneg60
 quietly gen candlikes60 = demcandpos60 + repcandpos60
 quietly gen canddislikes60 = demcandneg60 + repcandneg60
 
 quietly gen demprepref56 = 0
 quietly replace demprepref56 = 1 if prepref56==1
 quietly gen repprepref56 = 0
 quietly replace repprepref56 = 1 if prepref56==2
 quietly gen undecided56 = 0
 quietly replace undecided56 = 1 if prepref56==0
 
 quietly gen demprepref60 = 0
 quietly replace demprepref60 = 1 if prepref60==1
 quietly gen repprepref60 = 0
 quietly replace repprepref60 = 1 if prepref60==2
 quietly gen otherprepref60 = 0
 quietly replace otherprepref60 = 1 if prepref60==3
 quietly gen undecided60 = 0
 quietly replace undecided60 = 1 if prepref60==0

 
 ** Party Strength

 gen strongpartisan56 = abs(pid56-3)
 gen strongpartisan60 = abs(pid60-3)

 ** Mentions
 
 gen demmentions56 = (dempos56 + repneg56)
 gen repmentions56 = (reppos56 + demneg56) 
 gen demcandmentions56 = (demcandpos56 + repcandneg56)
 gen repcandmentions56 = (repcandpos56 + demcandneg56)
 
 gen candambiv56 = (demcandmentions56 + repcandmentions56)/2 - abs(demcandmentions56-repcandmentions56)
 gen partyambiv56 = (demmentions56 + repmentions56)/2 - abs(demmentions56-repmentions56)
 gen totalambiv56 = (demcandmentions56 + repcandmentions56 + demmentions56 + repmentions56)/2 - abs(demmentions56 + demcandmentions56 - repmentions56 - repcandmentions56)

 gen demmentions60 = (dempos60 + repneg60)
 gen repmentions60 = (reppos60 + demneg60) 
 gen demcandmentions60 = (demcandpos60 + repcandneg60)
 gen repcandmentions60 = (repcandpos60 + demcandneg60)
 gen candambiv60 = (demcandmentions60 + repcandmentions60)/2 - abs(demcandmentions60-repcandmentions60)
 gen partyambiv60 = (demmentions60 + repmentions60)/2 - abs(demmentions60-repmentions60)
 gen totalambiv60 = (demcandmentions60 + repcandmentions60 + demmentions60 + repmentions60)/2 - abs(demmentions60 + demcandmentions60 - repmentions60 - repcandmentions60)

 
 gen newpref56 = pref56
 gen newpref60 = pref60


 gen demvreppref56 = 1 if pref56==1
 replace demvreppref56 = 0 if pref56==2
 gen demvreppref60 = 1 if pref60==1
 replace demvreppref60 = 0 if pref60==2

 mlogit newpref56 canddiff56 partydiff56 candpartylike56 candpartydislike56 demprepref56 undecided56 strongpartisan56 swing56 warchances56 finsit56 voteplan56 pid56, iterate(30)
 predict hatdem, outcome(1)
 predict hatrep, outcome(2)
 predict hatother, outcome(3)
 
 sum hatother if pref56==1
 sum hatother if pref56==2
 sum hatother if pref56==3
   
 gen uniform = uniform()

 gen repchoice = hatdem+hatrep
 replace newpref56 = 1 if uniform<=hatdem & pref56==.
 replace newpref56 = 2 if hatdem<uniform & uniform<=repchoice & pref56==.
 replace newpref56 = 3 if repchoice<uniform & pref56==.
 drop hatdem hatrep hatother uniform repchoice
  
 local k = 1
 
 
 while `k' <= 10{
 
  quietly mlogit newpref56 canddiff56 partydiff56 candpartylike56 candpartydislike56 demprepref56 undecided56 strongpartisan56 swing56 warchances56 finsit56 voteplan56 pid56 black age female education income56 south midwest, iterate(30)
  quietly predict hatdem, outcome(1)
  quietly predict hatrep, outcome(2)
  quietly predict hatother, outcome(3)
 
  quietly gen uniform = uniform()

  quietly gen repchoice = hatdem+hatrep
  quietly replace newpref56 = 1 if uniform<=hatdem & pref56==.
  quietly replace newpref56 = 2 if hatdem<uniform & uniform<=repchoice & pref56==.
  quietly replace newpref56 = 3 if repchoice<uniform & pref56==.
  if `k' == 10 {
    quietly gen draw = repchoice*uniform()
    quietly gen demchoice = 0
    quietly replace demchoice = 1 if draw<=hatdem
    quietly replace demvreppref56 = demchoice if demvreppref56==.
    quietly drop draw demchoice
  }
  quietly drop hatdem hatrep hatother uniform repchoice
  display `k'
  local k = `k'+1
 }

 local k = 1
 while `k' <= 10{
   quietly logit demvreppref56 canddiff56 partydiff56 candpartylike56 candpartydislike56 demprepref56 undecided56 strongpartisan56 swing56 warchances56 finsit56 voteplan56 pid56 black age female education income56 south midwest, iterate(60)
   quietly predict hatdem, pr
   quietly gen uniform = uniform()
   quietly replace demvreppref56 = 1 if uniform<=hatdem & pref56!=2 & pref56!=1
   quietly replace demvreppref56 = 0 if uniform>hatdem & pref56!=2 & pref56!=1
   quietly drop hatdem uniform
   display `k'
   local k = `k'+1
 }

 
 gen demvote56 = 0
 replace demvote56 = 1 if newpref56==1
 gen repvote56 = 0
 replace repvote56 = 1 if newpref56==2
 gen thirdpartyvote56 = 0
 replace thirdpartyvote56 = 1 if newpref56==3
 
 mlogit newpref60 canddiff60 partydiff60 repvote56 candpartylike60 candpartydislike60 demprepref60 undecided60 strongpartisan60 swing60 voteplan60 pid60 catholic south, iterate(30)

 predict hatdem, outcome(1)
 predict hatrep, outcome(2)
 predict hatother, outcome(3)
 
 sum hatother if pref60==1
 sum hatother if pref60==2
 sum hatother if pref60==3
   
 gen uniform = uniform()

 gen repchoice = hatdem+hatrep
 replace newpref60 = 1 if uniform<=hatdem & pref60==.
 replace newpref60 = 2 if hatdem<uniform & uniform<=repchoice & pref60==.
 replace newpref60 = 3 if repchoice<uniform & pref60==.
 drop hatdem hatrep hatother uniform repchoice
  
 local k = 1
 
 
 while `k' <= 10{
 
  quietly mlogit newpref60 repvote56 canddiff60 partydiff60 candpartylike60 candpartydislike60 demprepref60 undecided60 strongpartisan60 swing60 warchances60 finsit60 voteplan60 pid60 catholic black age female education income60 south midwest, iterate(30)
  quietly predict hatdem, outcome(1)
  quietly predict hatrep, outcome(2)
  quietly predict hatother, outcome(3)
 
  quietly gen uniform = uniform()

  quietly gen repchoice = hatdem+hatrep
  quietly replace newpref60 = 1 if uniform<=hatdem & pref60==.
  quietly replace newpref60 = 2 if hatdem<uniform & uniform<=repchoice & pref60==.
  quietly replace newpref60 = 3 if repchoice<uniform & pref60==.
  if `k' == 10 {
    quietly gen draw = repchoice*uniform()
    quietly gen demchoice = 0
    quietly replace demchoice = 1 if draw<=hatdem
    quietly replace demvreppref60 = demchoice if demvreppref60==.
    quietly drop draw demchoice
  }
  quietly drop hatdem hatrep hatother uniform repchoice
  display `k'
  local k = `k'+1
 }

 local k = 1
 while `k' <= 10{
   quietly logit demvreppref60 repvote56 canddiff60 partydiff60 candpartylike60 candpartydislike60 demprepref60 undecided60 strongpartisan60 swing60 warchances60 finsit60 voteplan60 pid60 catholic black age female education income60 south midwest, iterate(60)
   quietly predict hatdem, pr
   quietly gen uniform = uniform()
   quietly replace demvreppref60 = 1 if uniform<=hatdem & pref60!=2 & pref60!=1
   quietly replace demvreppref60 = 0 if uniform>hatdem & pref60!=2 & pref60!=1
   quietly drop hatdem uniform
   display `k'
   local k = `k'+1
 }

 
 ** Party Mentions
 
 gen avgpartylikes = (partylikes56 + partylikes60)/2
 gen avgpartydislikes = (partydislikes56 + partydislikes60)/2
 gen avgcandlikes = (candlikes56 + candlikes60)/2
 gen avgcanddislikes = (canddislikes56 + canddislikes60)/2

 gen avgpartymentions = avgpartylikes + avgpartydislikes
 gen avgcandmentions = avgcandlikes + avgcanddislikes
 gen avgtotalmentions = avgpartymentions + avgcandmentions

 gen totalmentions56 = (partylikes56+partydislikes56)/2 + (candlikes56+canddislikes56)/2
 gen totalmentions60 = (partylikes60+partydislikes60)/2 + (candlikes60+canddislikes60)/2
 gen mintotalmentions= totalmentions56
 replace mintotalmentions = totalmentions60 if totalmentions60<totalmentions56
 gen maxtotalmentions = totalmentions56
 replace maxtotalmentions = totalmentions60 if totalmentions60>totalmentions56 & totalmentions60!=.


** Efficacy, make index 3 point scale

 gen efficacyindex56 = efficacy561 + efficacy562 + efficacy563
 gen efficacyindex60 = efficacy601 + efficacy602 + efficacy603
 
 * Voter variable
 gen voter = 0 if votedin56!=. & votedin60!=.
 replace voter = 1 if votedin56==2 & votedin60==2
 
 ** Switch variable
 gen switch = .
 replace switch = 0 if newpref56==1 & newpref60==1
 replace switch = 0 if newpref56==2 & newpref60==2
 replace switch = 0 if newpref56==3 & newpref60==3

 gen thirdpartyvoter = 0
 replace thirdpartyvoter = thirdpartyvoter + .5 if newpref56==3
 replace thirdpartyvoter = thirdpartyvoter + .5 if newpref60==3
 
 replace switch = 1 if newpref56!=1 & newpref60==1
 replace switch = 1 if newpref56!=2 & newpref60==2 
 replace switch = 1 if newpref56!=3 & newpref60==3 
 replace switch = 1 if newpref56==1 & newpref60!=1 
 replace switch = 1 if newpref56==2 & newpref60!=2 
 replace switch = 1 if newpref56==3 & newpref60!=3 

 gen demrepswitch = abs(demvreppref56-demvreppref60)

 gen partyambivindex = partyambiv56
 replace partyambivindex = partyambiv60 if partyambiv60>partyambivindex & partyambiv60!=.

 gen candambivindex = candambiv56
 replace candambivindex =  candambiv60 if candambiv60>candambivindex & candambiv60!=.
 
 gen totalambivindex = totalambiv56
 replace totalambivindex =  totalambiv60 if totalambiv60>totalambivindex & totalambiv60!=.
 
 gen undecidedvoter = (undecided56 + undecided60)/2

 replace swing56 = 0 if demprepref56==1 & pref56==1
 replace swing56 = 0 if repprepref56==1 & pref56==2
 replace swing60 = 0 if demprepref60==1 & pref60==1
 replace swing60 = 0 if repprepref60==1 & pref60==2
 replace swing60 = 0 if otherprepref60==1 & pref60==3
 
 gen swingvoter = (swing56 + swing60)/2
 
 gen partisan = 0 if pid56!=. & pid60!=.
 replace partisan = 1 if strongpartisan56>=2 & partisan!=.
 replace partisan = 1 if strongpartisan60>=2 & partisan!=.
 *gen strongpartisan  = 0 if pid56!=. & pid60!=.
 *replace strongpartisan = 1 if  strongpartisan56==3 & strongpartisan!=.
 *replace strongpartisan = 1 if  strongpartisan60==3 & strongpartisan!=.
 gen leaner  = 0 if pid56!=. & pid60!=.
 replace leaner = 1 if  strongpartisan56==1
 replace leaner = 1 if  strongpartisan60==1
 
 gen strongpartisan  = 0 if pid56!=. & pid60!=.
 replace strongpartisan = strongpartisan+.5 if  strongpartisan56==3 & strongpartisan!=.
 replace strongpartisan = strongpartisan+.5 if  strongpartisan60==3 & strongpartisan!=.

 gen independent = 0 if pid56!=. & pid60!=.
 replace independent = independent+.5 if strongpartisan56==0
 replace independent = independent+.5 if strongpartisan60==0
 
 gen avgefficacy = (efficacyindex56 + efficacyindex60)/2
 replace avgefficacy = efficacyindex56 if avgefficacy==.
 replace avgefficacy = efficacyindex60 if avgefficacy==.

 replace age = 18 if age<=18
 gen agesquared = age^2
 gen educationsquared= education^2
 
 gen highschool = 0
 replace highschool = 1 if education>=5
 
 gen collegegrad = 0
 replace collegegrad = 1 if education>=8

 gen avgincome = (income56+income60)/2
 gen avgincomesquared = avgincome^2


 ** Issue voting score
 gen issuevote56 = 0
 replace issuevote56 = issuevote56+1 if (haveopinion11 + seediff11)==2
 replace issuevote56 = issuevote56+1 if (haveopinion12 + seediff12)==2
 replace issuevote56 = issuevote56+1 if (haveopinion13 + seediff13)==2	
 replace issuevote56 = issuevote56+1 if (haveopinion14 + seediff14)==2	
 replace issuevote56 = issuevote56+1 if (haveopinion15 + seediff15)==2	

 gen issuevote60 = 0
 replace issuevote60 = issuevote60+1 if (haveopinion21 + seediff21)==2
 replace issuevote60 = issuevote60+1 if (haveopinion22 + seediff22)==2
 replace issuevote60 = issuevote60+1 if (haveopinion23 + seediff23)==2	
 replace issuevote60 = issuevote60+1 if (haveopinion24 + seediff24)==2	
 replace issuevote60 = issuevote60+1 if (haveopinion25 + seediff25)==2	

 gen issuevote = issuevote56/5 
 replace issuevote = issuevote60/5 if issuevote60<issuevote56

 keep id votedin56 votedin60 pref56 prepref56 pref60 prepref60 newpref56 newpref60 voter switch demrepswitch thirdpartyvoter catholic female black leaner partisan independent strongpartisan swingvoter undecidedvoter avgefficacy age agesquared education educationsquared highschool collegegrad avgincome avgincomesquared south midwest impdiff60 conservparty issuevote56 issuevote60 issuevote candambivindex partyambivindex avgpartylikes avgpartydislikes pid56 pid60 avgtotalmentions mintotalmentions maxtotalmentions candambivindex totalambivindex  nixonstate kennedystate knowmajority

 save statami50s_`i'.dta, replace
 
 local i = `i'+1
 
}

clear
