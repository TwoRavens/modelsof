


use Original2Replication.dta,clear

gen demosat= DemocracyFunctions
gen leftright= LeftRightPlacement
replace leftright=. if LeftRightPlacement==55


***occupation
recode Occupation (1 2 3=1 "SelfEmployed")(9=0 "Unemployed")(4=2 "PublicSector")(5=3 "PrivateSector")(6 7=4 "Retiree") (11 10 8=5 "Other"), gen(jobs)

***polknow

gen q1=0
replace q1=1 if AvramopoulosForeignMinister==1
replace q1=0 if AvramopoulosForeignMinister==2
replace q1=0 if AvramopoulosForeignMinister==.

gen q2=0
replace q2=1 if Parliament200seats==1
replace q2=0 if Parliament200seats ==2
replace q2=0 if Parliament200seats ==.


gen q3=0
replace q3=1 if DeputyHomeAffairsMinisterGrgrks==1
replace q3=0 if DeputyHomeAffairsMinisterGrgrks ==2
replace q3=0 if DeputyHomeAffairsMinisterGrgrks ==.


gen q4=0
replace q4=1 if DeputyHomeAffairsMinisterGrgrks==1
replace q4=0 if DeputyHomeAffairsMinisterGrgrks ==2
replace q4=0 if DeputyHomeAffairsMinisterGrgrks ==.



gen know=q1+q2+q3+q4

recode know (0 1=0 "Low")(2=1 "Med")(3 4 =2 "High"), gen(polknow)



****Room experiment***


gen prospects=.

replace prospects =Exp4Treatment1 if Exp4Treatment1!=.
replace prospects = Exp4Treatment2 if Exp4Treatment2!=.
replace prospects = Exp4Control if Exp4Control!=.

recode prospects (1=5)(2=4)(3=3)(4=2)(5=1)
recode prospects (1 2=1 "Pessimists")(3=0 "Neutral")(4 5=2 "Optimists"), gen(prospects2)



gen E4T1=.
replace E4T1=1 if Exp4Treatment1!=.
gen E4T2=0
replace E4T2=1 if Exp4Treatment2!=.
gen E4C=0
replace E4C=1 if Exp4Control!=.


gen E4=0
replace E4=1 if Exp4Treatment1!=.
replace E4=2 if Exp4Treatment2!=.


recode E4 (1=1 "FullRoom") (2=2 "NoRoom")(0=0 "Control"), gen(rtm)



***manipulationcheck

gen manip=.
replace manip= GovrnmIMFRuleofEcon



**recode various voting (outcomes+controls)

recode VoteNextElections (1=1 "ND")(2=2 "Syriza")(3=3 "PASOK") ///
 (4 5 8=4 "OtherRight")(6 7=5 "OtherLeft") (9=6 "River") (10=7 "Other")(11=8 "Undecided"), gen(multivote)
 
 recode VoteNextElections (1 3=1 "Gov")(else=0 "Opp"), gen(binaryvote)
 
 recode VoteNextElections (1 3=1 "Coalition") (else=0 "Opposition"), gen(govsup)
  recode VoteNextElections (1 3=1 "Coalition") (11=0 "Undecided") (else=2 "Opposition"), gen(mgovsup)
  
    recode VoteNextElections (1=1 "ND") (2=2 "SYRIZA") (3=3 "Pasok")(else=0 "Other"), gen(multichoice)

  
  
  recode VoteEU2014 (1=1 "ND")(2=2 "Syriza")(3=3 "PASOK") ///
 (4 5 8=4 "OtherRight")(6 7=5 "OtherLeft") (10=6 "River") /// 
 (11 . =7 "Other"), gen(euvote2014)
 
   recode VoteEU2014 (1=1 "Gov")(2=2 "Opp")(3=1 "Gov") ///
 (4 5 8=2 "Opp")(6 7=2 "Opp") (10=2 "Opp") /// 
 (11 . 9 =2 "Opp"), gen(eubinaryvote)

  recode VoteJune2012 (1=1 "ND")(2=2 "Syriza")(3=3 "PASOK") ///
 (4 5 8=4 "OtherRight")(6 7=5 "OtherLeft") (. 9 11 =6 "Other"), gen(june12vote)

 
keep demosat GreeceParticipationEU Sex Age3Cat Age EduLevel leftright jobs know ///
polknow euvote prospects prospects2 manip multivote binaryvote mgovsup multichoice ///
euvote2014 eubinaryvote june12vote rtm 
 

 *save "AJPSKosmidisRtMdata.dta",replace
