
*The following coding corresponds to the data for the PreTest1RawData*

*Open PreTest1RawData.dta in STATA. This is raw, uncoded data. Since there are only two variables in this dataset, I have chosen not to rename them*

*Referenced on page 5 of Main Text: The following shows you the number/percentage of people who selected the “not political” option (3) in the POSITIVE condition*
tab posconditionpolitical

*Referenced on page 5 of Main Text: The following shows you the number/percentage of people who selected the “not political” option (3) in the NEGATIVE condition.*
tab negconditionpolitical 

*NOTE TO REPLICATORS: When you run this command above, it will indicate 25 people (58%) chose “not political” even though the manuscript says 63%. A few people were added to the “Not political” percentage in the manuscript because they selected the wrong option and indicated in the open response that they really didn’t find the candidate political. For example: One respondent wrote, “I actually have no reason to [think this person is political]” To see these open responses, use the following command:*

tab var22

*This will clear this dataset so you can open the next one*
clear all

*The following coding corresponds to the data for the PreTest2RawData*

*Open PreTest2RawData.dta in STATA*

*The code below shows where the PreTest2 subjects (different sample from PreTest1) placed the paragraph about the candidate’s issue positions on a 7-point ideology scale ranging from Extremely Liberal to Extremely Conservative. Since there is only one important variable I have chosen not to rename it*

*Referenced on page 6 of Main Text: This will show you the average/mean value chosen on the ideology scale (4.02)*
sum wherewouldyouplacethiscandidateo

*Referenced on page 6 of Main Text: This will show you the modal value chosen (4) for the candidate’s ideology.*
tab wherewouldyouplacethiscandidateo

*This will clear this dataset so you can open the next one*
clear all

*The following coding corresponds to the data for the main study called MainStudyProjectionRawData. The raw data will have some strange variable names. Therefore, I’ve included all the drop/rename/recode coding*

*Open MainStudyProjectionRawData.dta in STATA*

*DROPPING EXTRANEOUS QUALTRICS VARIABLES THAT ARE NOT PART OF THE STUDY*
drop responseid responseset name externaldatareference emailaddress ipaddress status startdate enddate finished mturkparticipantstogetpaidforcom thesurveyisoverthankyouagainfory researchconsentformcollegeofchar theresearchersconductingthissurv thissurveyhasbeendesignedtohelpr locationlatitude locationlongitude locationaccuracy correspondingauthorfrankpeterspe var28 var33

drop displayorderaffectivelypositivec displayorderaffectivelyneutralco displayorderaffectivelynegativec displayorderinferencequestions displayorderissuepositionquestio displayorderblockrandomizerfl_17

*RENAMING VARIABLES SO THEY ARE EASIER TO UNDERSTAND*
rename sometimeswhenpeoplefilloutsurvey Attentioncheck1
rename isenglishyourfirstlanguage EnglishFirstLanguage
rename inwhatareaofthecountryhaveyouspe region
rename howoldareyouselectyourageusingth age
rename whatisthehighestlevelofeducation education
rename whatracedoyouidentifywith race
rename whatgenderdoyoucurrentlyidentify gender
rename nowwearegoingtoshowyouanarticlea PositiveConditionOnly
rename onthefollowingscalepleaseindicat PositiveLikability
rename wherewouldyouplaceronaldfurmanon PositiveIdeoPlacement
rename wouldyousaythatronaldfurmanistoo PositiveTooIdeological
rename var27 NeutralConditionOnly
rename var29 NeutralLikability
rename var30 NeutralIdeoPlacement
rename var31 NeutralTooIdeological
rename var32 NegativeConditionOnly
rename var34 NegativeLikability
rename var35 NegativeIdeoPlacement
rename var36 NegativeTooIdeological

rename generallyspeakingwherewouldyoupu DemPartyPlacement
rename var38 RepublicanPartyPlacement
rename var39 ObamaPlacement
rename var40 HillaryClintonPlacement
rename var41 TrumpPlacement
rename var42 MittRomneyPlacement
rename generallyspeakingwhichofthefollo PartiesDivided

rename nowwehaveafewquestionsaboutyouro RepDemIndepOther
rename doyouconsideryourselftobeastrong StrongNotStrongRep
rename var46 StrongNotStrongDem
rename ifyouhadtochoosewhichpartyareyou PartyHadToChoose
rename whenitcomestopoliticswherewouldy IdeoSelfPlacement

rename wedliketoknowaboutyouropinionont TransitionQuestion
rename endingtaxloopholesforlargecorpor EndTaxLoopholes
rename providingtaxcutstoallindividuala TaxCutsToIndividuals
rename reducingthewelfarestatebyinvesti ReduceWelfareState
rename increasingmilitaryfundingtoensur IncreaseMilitaryFunding
rename tryingterrorismsuspectsincivilia CivilianCourts
rename reducingthenumberofnuclearweapon ReducingNuclearAmrs
rename strengtheninggunbackgroundchecks StrengthenBackgroundCheck
rename lengtheningwaitingperiodsinorder LengthenWaitPeriod
rename howdoyoufeelaboutnramembership NRAFeelings
rename peopleusemanydifferentnewsoutlet AttentionCheck2

rename belowaresomequestionsaboutameric SecOfState
rename howmanyyearsisonesenateterm SenateTerm
rename generallyspeakingwhichpartyisass IdeoKnow1ConParty
rename whoappointssupremecourtjustices CourtJustices
rename howmanyyearsisoneterminthehouseo HouseTerm
rename whichwomanisrunningforpresidenti CarlyFiorina
rename whatisitcalledwhenaprolongedspee Filibuster
rename generallyspeakingisraisingtaxesm IdeoKnow2RaiseTaxes
rename whatistheofficialnameforthemajor AffCareAct
rename whatpartydoeselizabethwarrenbelo ElizabethWarrenParty
rename generallyspeakingwhichpoliticalp IdeoKnow3LessCentralGovt
rename howmanysenatorsarethereforeachst SenatorsPerState

rename hadyouheardofronaldfurmanbeforet HeardofFurman
rename wedalsoliketoknowaboutyouropinio TRANSITIONTONEXTBLOCK

*RECODING AND CLEANING VARIABLES*

*Making experimental condition variables so if you are in the condition you have a 1 and if not you have a zero. This creates Positive, Neutral and Negative Condition Dummies*
gen PositiveCondition=.
replace PositiveCondition=1 if condition==1
replace PositiveCondition=0 if condition==2 | condition==3

gen NeutralCondition=.
replace NeutralCondition=1 if condition==2
replace NeutralCondition=0 if condition==1 | condition==3

gen NegativeCondition=.
replace NegativeCondition=1 if condition==3
replace NegativeCondition=0 if condition==1 | condition==2

*7 Point PartyID Variable: combines questions about partisanship to form a 7-point scale*
gen PartyID=.
replace PartyID=7 if StrongNotStrongRep==1
replace PartyID=6 if StrongNotStrongRep==2
replace PartyID=5 if PartyHadToChoose==1
replace PartyID=4 if PartyHadToChoose==3
replace PartyID=3 if PartyHadToChoose==2
replace PartyID=2 if StrongNotStrongDem ==2
replace PartyID=1 if StrongNotStrongDem ==1

*Political Sophistication: This recodes each question such that 1 means they got it correct, 0 otherwise. The command after scales all the answers together to form a continuous Political Sophistication variable*
recode SecOfState (1=0)(2=1)(3=0)(4=0)(5=0)
recode SenateTerm (1=0)(3=0)(4=1)(5=0)
recode CourtJustices (1=0)(2=0)(3=1)(4=0)(5=0)
recode HouseTerm (1=1)(2=0)(3=0)(4=0)(5=0)
recode CarlyFiorina (1=1)(2=0)(3=0)(5=0)
recode Filibuster (1=0)(2=1)(3=0)(4=0)(5=0)
recode AffCareAct (1=0)(2=0)(3=1)(4=0)(5=0)
recode ElizabethWarrenParty (1=0)(2=1)(3=0)(4=0)(5=0)
recode SenatorsPerState (1=1)(2=0)(3=0)(4=0)(5=0)

gen PoliticalSophistication= SecOfState+SenateTerm+CourtJustices+HouseTerm+CarlyFiorina+Filibuster+AffCareAct+ElizabethWarrenParty+SenatorsPerState

*Ideological Sophistication Questions: This recodes the questions such that 1 means they got it correct, zero otherwise. The next command scales all the answers together to form a continuous Ideological Sophistication Variable*
recode IdeoKnow1ConParty (1=0)(2=1)(3=0)
recode IdeoKnow2RaiseTaxes (1=1)(2=0)(3=0)
recode IdeoKnow3LessCentralGovt (1=0)(2=1)(3=0)

gen IdeoSophistication= IdeoKnow1ConParty+ IdeoKnow2RaiseTaxes+ IdeoKnow3LessCentralGovt

*This takes the candidate ideology perceptions from all three conditions and puts them into one variable*
gen IdeoPlacementALL=.

replace IdeoPlacementALL=1 if PositiveIdeoPlacement==1 | NeutralIdeoPlacement==1 | NegativeIdeoPlacement==1
replace IdeoPlacementALL=2 if PositiveIdeoPlacement==2 | NeutralIdeoPlacement==2 | NegativeIdeoPlacement==2
replace IdeoPlacementALL=3 if PositiveIdeoPlacement==3 | NeutralIdeoPlacement==3 | NegativeIdeoPlacement==3
replace IdeoPlacementALL=4 if PositiveIdeoPlacement==4 | NeutralIdeoPlacement==4 | NegativeIdeoPlacement==4
replace IdeoPlacementALL=5 if PositiveIdeoPlacement==5 | NeutralIdeoPlacement==5 | NegativeIdeoPlacement==5
replace IdeoPlacementALL=6 if PositiveIdeoPlacement==6 | NeutralIdeoPlacement==6 | NegativeIdeoPlacement==6
replace IdeoPlacementALL=7 if PositiveIdeoPlacement==7 | NeutralIdeoPlacement==7 | NegativeIdeoPlacement==7

*This takes the candidate likability ratings from all three conditions and puts them into one variable*
gen LikabilityALL=.
replace LikabilityALL=1 if PositiveLikability==1| NeutralLikability==1| NegativeLikability==1
replace LikabilityALL=2 if PositiveLikability==2| NeutralLikability==2| NegativeLikability==2
replace LikabilityALL=3 if PositiveLikability==3| NeutralLikability==3| NegativeLikability==3
replace LikabilityALL=4 if PositiveLikability==4| NeutralLikability==4| NegativeLikability==4
replace LikabilityALL=5 if PositiveLikability==5| NeutralLikability==5| NegativeLikability==5
replace LikabilityALL=6 if PositiveLikability==6| NeutralLikability==6| NegativeLikability==6
replace LikabilityALL=7 if PositiveLikability==7| NeutralLikability==7| NegativeLikability==7

*This makes the Self-report ideology variable trichotomous into liberal,moderate,conservative for Figure 1 in the Online Appendix*
gen Ideology3Point=.
replace Ideology3Point=1 if IdeoSelfPlacement<=3
replace Ideology3Point=2 if IdeoSelfPlacement==4
replace Ideology3Point=3 if IdeoSelfPlacement>=5


*This makes the Attention Check Variables for the Appendix models*
gen AttentionCheckControl1= Attentioncheck1
recode AttentionCheckControl1 (0=1)(2=0)(3=0)(4=0)(5=1)(6=0)(8=0)

gen AttentionCheckControl2= AttentionCheck2
recode AttentionCheckControl2 (1=0)(2=0)(3=0)(5=0)(7=0)(8=0)(10=0)(11=0)(12=0)(15=1)(16=0)(18=0)(19=0)

gen AttentionCheckScale=.

replace AttentionCheckScale=0 if AttentionCheckControl1==1 & AttentionCheckControl2==1
replace AttentionCheckScale=1 if AttentionCheckControl1==0 | AttentionCheckControl2==0
replace AttentionCheckScale=2 if AttentionCheckControl1==0 & AttentionCheckControl2==0

*STATISTICAL MODELS*

*FOR THE MODELS TO REPLICATE, YOU MUST DROP THE PEOPLE WHO DID NOT REPORT ENGLISH AS THEIR FIRST LANGUAGE OR CLAIMED TO HAVE HEARD OF THE CANDIDATE*
drop if English==2
drop if HeardofFurman==1

*Footnote 5 in the middle of page 7 references the results in the Online Appendix that apply the attention check questions in different ways. This includes the models in Online Appendix Table 3 and Online Appendix Figures 2 and 3. Though it makes more sense to run these models later, they are referenced early in the paper so I report the coding here:*

*Online Appendix Table 3: Same as Main Text Table 1 Model 2 but this model drops the Attention Check Failure Subjects (first model reported)*
reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.IdeoSelfPlacement i.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication if AttentionCheckControl1==1 & AttentionCheckControl2==1, robust

*Online Appendix Table 3: Same as Main Text Table 1 Model 2 but this model is controlling for Attention Check Failures Model (second model reported)*
reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.IdeoSelfPlacement i.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication AttentionCheckScale, robust

*Online Appendix: Figures 2 and 3: These commands run the 1st regression from Online Appendix Table 3, create the margins plot for the interaction, and save it. Then the commands do the same for the 2nd regression in Online Appendix Table 3.  The plots are then combined into one image so that they are side by side. The graphic itself it will not show up in the results log file*

reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.IdeoSelfPlacement i.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication if AttentionCheckControl1==1 & AttentionCheckControl2==1, robust

margins, at(PositiveCondition=(0 1) IdeoSelfPlacement = (1 7)) vsquish
marginsplot, name(g1, replace) nodraw

reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.IdeoSelfPlacement i.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication AttentionCheckScale, robust

margins, at(PositiveCondition=(0 1) IdeoSelfPlacement = (1 7)) vsquish
marginsplot, name(g2, replace) nodraw

graph combine g1 g2, ycommon name(combined, replace)
graph display combined, xsize(10)

*Referenced on page 7 of Main Text: Online Appendix Table 1: Demographics for Mechanical Turk Sample*
tab gender 
tab race 
tab education 
tab age
tab PartyID 
tab IdeoSelfPlacement 

*Referenced on page 7 of Main Text: Online Appendix Table 2: Demographic Balance Across Experimental Conditions (These tab commands give raw numbers. The percentage must be calculated)*
tab gender condition 
tab race condition 
tab education condition 
tab PartyID condition 
tab IdeoSelfPlacement condition 

*Main Text: Figure 2: Likability Ratings for Candidate by Experimental Condition and Ideological Self-Placement.*
***NOTE TO REPLICATORS: THE CODING FOR THE HISTOGRAM WILL AUTOMATICALLY DROP ALL THE VARIABLES NOT USED IN THE HISTOGRAM. UNLESS YOU WANT TO OPEN THE MAINSTUDYRAWDATA.dta FILE AGAIN AND RUN THE RENAMING/CLEANING CODE ABOVE, I SUGGEST RUNNING THIS FIGURE LAST. I HAVE ALSO MADE THIS NOTE IN THE README FILE AND THE RESULTS LOG FILE. I HAVE PUT THIS CODE AT THE END OF THIS FILE***

*Referenced on Page 8 of Main Text: T-tests for the differences with the Histogram bars. The following code makes a variable that dichotomizes experimental conditions and then uses them in the t-tests*
gen PosOrNeutral=.
replace PosOrNeutral=1 if PositiveCondition==1
replace PosOrNeutral=0 if NeutralCondition==1

ttest LikabilityALL if Ideology3Point==2, by (PosOrNeutral) 
ttest LikabilityALL if Ideology3Point==3, by (PosOrNeutral) 

*Main Text: Table 1, Model 1*
reg IdeoPlacementALL PositiveCondition NegativeCondition IdeoSelfPlacement c.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement, robust

*Main Text: Table 1, Model 2*
reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.IdeoSelfPlacement i.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement  PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication, robust

*Main Text Figure 3: This code has you run the regression and then uses the margins commands to plot the interaction.The graphic itself it will not show up in the results log file*
reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.IdeoSelfPlacement i.PositiveCondition#c.IdeoSelfPlacement i.NegativeCondition#c.IdeoSelfPlacement  PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication, robust

margins, at(PositiveCondition=(0 1) IdeoSelfPlacement = (1 7)) vsquish

marginsplot

*Referenced in Footnote 7: Online Appendix Figure 1: This code has you run the regression and then uses the margins commands to plot the interaction. The graphic itself it will not show up in the results log file*
reg IdeoPlacementALL i.PositiveCondition i.NegativeCondition c.Ideology3Point i.PositiveCondition#c.Ideology3Point i.NegativeCondition#c.Ideology3Point PartyID DemPartyPlacement RepublicanPartyPlacement PoliticalSophistication IdeoSophistication, robust

margins, at(PositiveCondition=(0 1) Ideology3Point = (1(1)3)) vsquish

marginsplot

*Online Appendix Figure 4: This graphic checks to see if liberals and conservatives show similar or dissimilar variances in how they respond to the Positive Condition candidate. First we need to make a dummy for liberals vs. conservatives, make a variable for the distance the respondent placed the candidate from them in either scale direction and then run the plot. Each step is annotated below. The graphic itself it will not show up in the results log file*

*This makes a binary liberal vs. conservative variable*
gen libsVscons=.
replace libsVscons=1 if Ideology3Point==1
replace libsVscons=0 if Ideology3Point==3

*This makes a variable for the distance put between a respondent and the candidate in either direction on the scale*
gen distancePositive= IdeoSelfPlacement-PositiveIdeoPlacement
gen distanceNeutral= IdeoSelfPlacement-NeutralIdeoPlacement
gen distanceNegative= IdeoSelfPlacement-NegativeIdeoPlacement

gen distanceALL=.
replace distanceALL=0 if distancePositive==0| distanceNeutral==0| distanceNegative==0
replace distanceALL=1 if distancePositive==1| distanceNeutral==1| distanceNegative==1 | distancePositive==-1| distanceNeutral==-1| distanceNegative==-1
replace distanceALL=2 if distancePositive==2| distanceNeutral==2| distanceNegative==2 | distancePositive==-2| distanceNeutral==-2| distanceNegative==-2
replace distanceALL=3 if distancePositive==3| distanceNeutral==3| distanceNegative==3 | distancePositive==-3| distanceNeutral==-3| distanceNegative==-3
replace distanceALL=4 if distancePositive==4| distanceNeutral==4| distanceNegative==4 | distancePositive==-4| distanceNeutral==-4| distanceNegative==-4
replace distanceALL=5 if distancePositive==5| distanceNeutral==5| distanceNegative==5 | distancePositive==-5| distanceNeutral==-5| distanceNegative==-5
replace distanceALL=6 if distancePositive==6| distanceNeutral==6| distanceNegative==6 | distancePositive==-6| distanceNeutral==-6| distanceNegative==-6

*This makes the Kernel Density Plot: The graphic itself it will not show up in the results log file*
kdensity distanceALL if libsVscons == 1 & PositiveCondition==1, addplot(kdensity distanceALL if libsVscons == 0 & PositiveCondition==1)  legend(label(1 "Liberals") label(2 "Conservatives") rows(1))

*This checks to see if the distributions differ from one another using a Kolmogorov-Smirnov test for equality of distribution*
ksmirnov distanceALL, by(libsVscons)


*Main Text: Figure 2: HERE I RUN THE HISTOGRAM  FROM EARLIER IN THE TEXT THAT DROPS THE REMAINING VARIABLES***

collapse (mean) meanLikabilityALL = LikabilityALL (sd) sdLikabilityALL = LikabilityALL (count) n= LikabilityALL, by(condition Ideology3Point)

generate hiLikabilityALL  = meanLikabilityALL  + invttail(n-1,0.025)*(sdLikabilityALL / sqrt(n))
generate lowLikabilityALL  = meanLikabilityALL -invttail(n-1,0.025)*(sdLikabilityALL / sqrt(n))
graph bar meanLikabilityALL, over(condition) over(Ideology3Point)

generate Ideology3PointCondition = condition if Ideology3Point==1
replace Ideology3PointCondition = condition+4 if Ideology3Point==2
replace Ideology3PointCondition = condition+8 if Ideology3Point==3
sort Ideology3PointCondition
list Ideology3PointCondition Ideology3Point condition, sepby (Ideology3Point)

twoway (bar meanLikabilityALL Ideology3PointCondition if condition ==1)(bar meanLikabilityALL Ideology3PointCondition if condition ==2)(bar meanLikabilityALL Ideology3PointCondition if condition ==3)(rcap hiLikabilityALL lowLikabilityALL Ideology3PointCondition), legend (order(1 "Positive" 2 "Neutral" 3 "Negative"))xlabel( 2 "Liberal" 6 "Moderate" 10 "Conservative", noticks) xtitle(“Ideology”) ytitle("Likability Rating")

