/*Selfish and Cooperative Voting: Can the Majroity Restrain Themselves? Replication File. August 17, 2018 */
*Set stata directory to where the data replciation file is location*

//Experiment 1
*Import experiment 1 file
import excel "SelfishCooperativeVotingReplicationData.xlsx", sheet("experiment1") firstrow clear
///convert the string variables to numeric variables
*Constitution from string to numeric
encode Constitution, generate(Constitution2)
drop Constitution
*make new variable 0 or 1
gen Constitution = Constitution2 - 1
drop Constitution2
label var Constitution "0 = Lottery, 1 = Voting"
*same thing for decision
encode Decision, generate(Decision2)
drop Decision
*make new variable 0 or 1
gen Decision = Decision2-1
drop Decision2
label var Decision "0 = North, 1 = South"
*Same thing for artisan/farmer
encode Type, gen(Type2)
drop Type
*make new variable 0 or 1
gen Type = Type2-1
drop Type2
label var Type "0 = Artisan, 1 = Farmer"

//Analysis for Results Section of Experiment 1
*Decision by Artisans/Farmer for the Voting Condition
tab Decision Type if Constitution == 1, col exact
*Test if more than half of the Artisans chose the road that would be best for society
bitest Decision == .5 if Type == 0 & Constitution == 1
*Decision by Artisan/Farmer for the Voting Condition
tab Decision Type if Constitution == 0, col exact
*Test if more than half of the Artisans chose the road that would be best for society
bitest Decision == .5 if Type == 0 & Constitution == 0
*Did choice differ by institution? 
*Artisans
tab Decision Constitution if Type == 0, col exact
*Farmers
tab Decision Constitution if Type == 1, col exact

*Import experiment 2 file
import excel "SelfishCooperativeVotingReplicationData.xlsx", sheet("experiment2") firstrow clear
///convert the string variables to numeric variables
*Constitution from string to numeric
encode Constitution, generate(Constitution2)
drop Constitution
*make new variable 0, 1, or 2
gen Constitution = Constitution2 - 1
drop Constitution2
label var Constitution "0 = Leader, 1 = Lottery, 2 = Voting"
*same thing for decision
encode Decision, generate(Decision2)
drop Decision
*make new variable 0 or 1
gen Decision = Decision2-1
drop Decision2
label var Decision "0 = North, 1 = South"
*Same thing for artisan/farmer
encode Type, gen(Type2)
drop Type
*make new variable 0 or 1
gen Type = Type2-1
drop Type2
label var Type "0 = Artisan, 1 = Farmer"

///Analysis for Results Section of Experiment 2
*Decision by Artisan/Farmer for Voting Condition
tab Decision Type if Constitution == 2, col exact
*Test if more than half of the Artisans chose the road that would be best for society
 bitest Decision == .5 if Type == 0 & Constitution == 2
 *Decision by Artisan/Farmer for the Leader Condition
 tab Decision Type if Constitution == 0, col exact
 *Test if more than half of the Artisans chose the road that would be best for society
 bitest Decision == .5 if Type == 0 & Constitution == 0
*Decision by Artisan/Farmer in the Lottery Condition
tab Decision Type if Constitution == 1, col exact
 *Test if more than half of the Artisans chose the road that would be best for society
bitest Decision == .5 if Type == 0 & Constitution == 1

*Did choice differ by institution?
*Artisans
tab Decision Constitution if Type == 0, col exact
*Pairwise for artisans
tab Decision Constitution if Type == 0 & Constitution != 0, exact
tab Decision Constitution if Type == 0 & Constitution != 1, exact
tab Decision Constitution if Type == 0 & Constitution != 2, exact
*Farmers
tab Decision Constitution if Type == 1, col exact
*Pairwise
tab Decision Constitution if Type == 1 & Constitution != 0, exact
tab Decision Constitution if Type == 1 & Constitution != 1, exact
tab Decision Constitution if Type == 1 & Constitution != 2, exact

///Appendix Analyses for Experiment 2 
*create a dichotomous Republican variable (Republican = 1, Democrat = 0)
encode PartyID, generate(PartyID2)
gen Republican = 0
replace Republican = 1 if PartyID2 == 2|PartyID2 == 4|PartyID2 == 6
* create dichotomous variable for ideology
encode Ideology, generate(Ideology2)
gen Conservative = 0 
replace Conservative = 1 if Ideology2 ==1|Ideology2 ==3|Ideology2 == 5
*These analyses examine choice of north road
gen North = 0
replace North = 1 if Decision == 0
*Recode the Egalitarianism variables
replace TreatEqually = TreatEqually-4
replace GoneTooFar = (-1*GoneTooFar)+4
replace NotaProblem = (-1*NotaProblem)+4
replace WorryLess = (-1*WorryLess)+4
replace EqualChance = EqualChance - 4
replace EqualOpp = EqualOpp - 4
gen EgalScale = (TreatEqually+GoneTooFar+NotaProblem+WorryLess+EqualChance+EqualOpp)/6


*Party Effect on choice
*For Artisans
tab Decision Republican if Type == 0, col exact
*effects by institution
bysort Constitution: tab Decision Republican if Type == 0, col exact
*For Farmers
tab Decision Republican if Type == 1, col exact
*effects by Institution
bysort Constitution: tab Decision Republican if Type == 1, col exact

*Ideology Effect on choice
*For Artisans
tab Decision Conservative if Type == 0, col exact
*effects by institution
bysort Constitution: tab Decision Conservative if Type == 0, col exact
*For Farmers
tab Decision Conservative if Type == 1, col exact
*effects by Institution
bysort Constitution: tab Decision Conservative if Type == 1, col exact

*Egalitarianism Predicting choice of North for Farmers
logit North EgalScale if Type == 1, or
*by institution
bysort Constitution: logit North EgalScale if Type == 1, or
*Egalitarianism Predicting choice of North for Artisans
logit North EgalScale if Type == 0, or
*by institution
bysort Constitution: logit North EgalScale if Type == 0, or

import excel "SelfishCooperativeVotingReplicationData.xlsx", sheet("experiment2followup") firstrow clear
///convert string decision to trichotomus variable
encode Type, gen(Type2)
drop Type
*make new variable 0 , 1, or 2 variable (NOTE: 0 and 1 are from the voting condition of Experiment 2). 
gen Type = Type2-1
drop Type2
label var Type "0 = Artisan, 1 = Farmer, 2 = Observer"
*convert Decision variable from string to numeric
encode Decision, generate(Decision2)
drop Decision
*make new variable 0 or 1
gen Decision = Decision2-1
drop Decision2
label var Decision "0 = North, 1 = South"
*test judgment of impartial observer against chance
bitest Decision == .5 if Type == 2
*Experiment 2 Artisans vs. Impartial Observer
tab Decision Type if Type != 1, col exact
*Experiment 2 Farmers vs. Impartial Observer
tab Decision Type if Type != 0, col exact

///Import Experiment 3 File
import excel "SelfishCooperativeVotingReplicationData.xlsx", sheet("experiment3") firstrow clear
///convert the string variables to numeric variables
*Constitution from string to numeric
encode Constitution, generate(Constitution2)
drop Constitution
*make new variable 0, 1, or 2
gen Constitution = Constitution2 - 1
drop Constitution2
label var Constitution "0 = Leader, 1 = Lottery, 2 = Voting"
*same thing for decision
encode Decision, generate(Decision2)
drop Decision
*make new variable 0 or 1
gen Decision = Decision2-1
drop Decision2
label var Decision "0 = North, 1 = South"
*Same thing for artisan/farmer
encode Type, gen(Type2)
drop Type
*make new variable 0 or 1
gen Type = Type2-1
drop Type2
label var Type "0 = Artisan, 1 = Farmer"

/// Results Section of Experiment 3
tab Decision Type if Constitution == 2, col exact
*Test if more than half of the Artisans chose the road that would be best for society
 bitest Decision == .5 if Type == 0 & Constitution == 2
 *Decision by Artisan/Farmer for the Leader Condition
 tab Decision Type if Constitution == 0, col exact
 *Test if more than half of the Artisans chose the road that would be best for society
 bitest Decision == .5 if Type == 0 & Constitution == 0
*Decision by Artisan/Farmer in the Lottery Condition
tab Decision Type if Constitution == 1, col exact
 *Test if more than half of the Artisans chose the road that would be best for society
bitest Decision == .5 if Type == 0 & Constitution == 1

*Did choice differ by institution?
*Artisans
*Voting vs. Lottery
tab Decision Constitution if Type == 0 & Constitution != 0, col exact
*Voting vs. Leader
tab Decision Constitution if Type == 0 & Constitution != 1, col exact
*Leader vs. Lottery
tab Decision Constitution if Type == 0 & Constitution != 2, col exact
*Farmers
*Voting vs. Lottery
tab Decision Constitution if Type == 1 & Constitution != 0, col exact
*Voting vs. Leader
tab Decision Constitution if Type == 1 & Constitution != 1, col exact
*Leader vs. Lottery
tab Decision Constitution if Type == 1 & Constitution != 2, col exact

///Appendix Analyses for Experiment 3
*create a dichotomous Republican variable (Republican = 1, Democrat = 0)
encode PartyID, generate(PartyID2)
gen Republican = 0
replace Republican = 1 if PartyID2 == 2|PartyID2 == 4|PartyID2 == 6
* create dichotomous variable for ideology
encode Ideology, generate(Ideology2)
gen Conservative = 0 
replace Conservative = 1 if Ideology2 ==1|Ideology2 ==3|Ideology2 == 5
*These analyses examine choice of north road
gen North = 0
replace North = 1 if Decision == 0
*Recode the Egalitarianism variables
replace TreatEqually = TreatEqually-4
replace GoneTooFar = (-1*GoneTooFar)+4
replace NotaProblem = (-1*NotaProblem)+4
replace WorryLess = (-1*WorryLess)+4
replace EqualChance = EqualChance - 4
replace EqualOpp = EqualOpp - 4
gen EgalScale = (TreatEqually+GoneTooFar+NotaProblem+WorryLess+EqualChance+EqualOpp)/6


*Party Effect on choice
*For Artisans
tab Decision Republican if Type == 0, col exact
*effects by institution
bysort Constitution: tab Decision Republican if Type == 0, col exact
*For Farmers
tab Decision Republican if Type == 1, col exact
*effects by Institution
bysort Constitution: tab Decision Republican if Type == 1, col exact

*Ideology Effect on choice
*For Artisans
tab Decision Conservative if Type == 0, col exact
*effects by institution
bysort Constitution: tab Decision Conservative if Type == 0, col exact
*For Farmers
tab Decision Conservative if Type == 1, col exact
*effects by Institution
bysort Constitution: tab Decision Conservative if Type == 1, col exact

*Egalitarianism Predicting choice of North for Farmers
logit North EgalScale if Type == 1, or
*by institution
bysort Constitution: logit North EgalScale if Type == 1, or
*Egalitarianism Predicting choice of North for Artisans
logit North EgalScale if Type == 0, or
*by institution
bysort Constitution: logit North EgalScale if Type == 0, or



///Comparison of Artisans in Experiment1, Experiment 2, and Experiment 3 voting conditions (appears in discussion of E3)
import excel "SelfishCooperativeVotingReplicationData.xlsx", sheet("artisanvote") firstrow clear
*same thing for decision
encode Decision, generate(Decision2)
drop Decision
*make new variable 0 or 1
gen Decision = Decision2-1
drop Decision2
label var Decision "0 = North, 1 = South"
*compare artisans in E1 to E2 (appears in Discussion of E2)
tab Decision Experiment if Experiment != 3, col exact
*compare artisans in E2 to E3 (following two tests appear in Discussion of E3)
tab Decision Experiment if Experiment != 1, col exact
*Compare E1 to E3
tab Decision Experiment if Experiment != 2, col exact

