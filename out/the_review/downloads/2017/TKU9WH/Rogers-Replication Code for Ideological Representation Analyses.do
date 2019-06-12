

***
* Here (and in below use commands) replace "C:\Steven\Dropbox\Research Projects\Individual Chapter\APSR Submission\Replication\Public"
* with the directory that holds \Datasets\Rogers-DataforIdeologicalRepresentationAnalyses.dta from the replication zip file
***

use "C:\Steven\Dropbox\Research Projects\Individual Chapter\APSR Submission\Replication\Public\Datasets\Rogers-DataforIdeologicalRepresentationAnalyses.dta", clear


* Generate dummy variables for Fixed Effects
quietly tab Year, gen(Yr)


	***
	* Label Variables
	***
		label variable IdealPoint "Legislator Ideal Point"
		label variable DemocraticPresVoteShare "Democratic Party Pres Vote"
		label variable DemocratFundraisingAdvantage "Democrat Contribution Advantage"
		label variable Prev_DemVoteShare "Democrat Previous Vote Share"
		label variable IncumbentPrevContested "Incumbent Previously Contested"
		label variable SenateDummy "State Senate Race"
		label variable DemocraticMemberDummy "Member of the Democratic Party"
		label variable PresPartyDummy "Member of the President's Party"
		label variable FreshmanDummy "Freshman Incumbent"
		label variable Prof_StaffPerMember "Legislative Staff per Member"
		label variable Prof_Salary "Legislator Salary (in 1000s of 2010 dollars)"
		label variable Prof_SessionLength "Session Length"
		label variable LogDistrictSize "District Size (Logged)"
		label variable FullTimeReporters "Full Time State Capital Reporters (Logged)"
		label variable Q4StateEcon "Change Annual Log Q4 State Personal Income"
		label variable Q4StateEcon_DemAdjusted "Change Annual Log Q4 State Personal Income (Adjusted)"
		label variable MidtermDummy "Midterm Election"

****
* Analyses for Table 1
* Dependent Variable: Incumbent Vote Share, amongst contested elections where incumbent sought reelection
****

	* Table 1 ~ Column 1
		* No Distance Squared
		xtmixed IncumbentVoteShare Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	* Table 1 ~ Column 2
		** Distance Squared
		 xtmixed IncumbentVoteShare Distance c.Distance#c.Distance  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	* Table 1 ~ Column 3	
		** Distance Squared with Interactions
		xtmixed IncumbentVoteShare Distance c.Distance#c.Distance ///
			c.Distance#c.Prof_StaffPerMember c.Distance#c.Prof_Salary c.Distance#c.Prof_SessionLength c.Distance#c.FullTimeReporters c.Distance#c.IncFundraisingAdvantage ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ///
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	* Table 1 ~ Column 4
		**Distance Squared with Interactions
		**Marginal Districts
		xtmixed IncumbentVoteShare Distance c.Distance#c.Distance ///
			c.Distance#c.Prof_StaffPerMember c.Distance#c.Prof_Salary c.Distance#c.Prof_SessionLength c.Distance#c.FullTimeReporters c.Distance#c.IncFundraisingAdvantage ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1 & IncumbentPartyPresVote<60, ||State:

	* Table 1 ~ Column 5
		**Distance Squared with Interactions
		**Safe Districts
			xtmixed IncumbentVoteShare Distance c.Distance#c.Distance ///
				c.Distance#c.Prof_StaffPerMember c.Distance#c.Prof_Salary c.Distance#c.Prof_SessionLength c.Distance#c.FullTimeReporters c.Distance#c.IncFundraisingAdvantage ///
				IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
				PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
				Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1 & IncumbentPartyPresVote>=60, ||State:


***
* Analyses for Table 2
***

	xtset State
	
	* Table 2 ~ Column 1
	* Distance
		xtprobit IncumbentWinner Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy ///
			FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters 

	* Table 2 ~ Column 2
	* Distance
	* Include Interactions
		xtprobit IncumbentWinner Distance c.Distance#c.Prof_StaffPerMember c.Distance#c.Prof_Salary c.Distance#c.Prof_SessionLength c.Distance#c.FullTimeReporters ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy ///
			LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters
			
	* Table 2 ~ Column 3
	* Distance
	* Include Interactions
	* Marginal Districts
		xtprobit IncumbentWinner Distance c.Distance#c.Prof_StaffPerMember c.Distance#c.Prof_Salary c.Distance#c.Prof_SessionLength c.Distance#c.FullTimeReporters ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy ///
			LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters if IncumbentPartyPresVote <60

	* Table 2 ~ Column 4
	* Distance
	* Include Interactions
	* Safe Districts
		xtprobit IncumbentWinner Distance c.Distance#c.Prof_StaffPerMember c.Distance#c.Prof_Salary c.Distance#c.Prof_SessionLength c.Distance#c.FullTimeReporters ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy ///
			LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters if IncumbentPartyPresVote >=60


	xtset,clear

****
* Analyses for Table A-4
* Responsiveness approach: Dependent Variable changed to Democratic Vote Share, other variables (e.g. Campaign Contributions) adjusted to be consisted with new DV
****		

	* Column 1: Base Model
	xtmixed DemocraticVoteShare IdealPoint DemocraticPresVoteShare Prev_DemVoteShare  IncumbentPrevContested DemocratFundraisingAdvantage ///
		PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy  ///
		Q4StateEcon_DemAdjusted MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters ///
		 Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:
		
	* Column 2: Add Squared Term
	xtmixed DemocraticVoteShare IdealPoint c.IdealPoint#c.IdealPoint DemocraticPresVoteShare Prev_DemVoteShare  IncumbentPrevContested DemocratFundraisingAdvantage ///
		PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy  ///
		Q4StateEcon_DemAdjusted MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters ///
		 Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:
	
	* Column 3: Interactions
	xtmixed DemocraticVoteShare IdealPoint c.IdealPoint#c.IdealPoint DemocraticPresVoteShare Prev_DemVoteShare  IncumbentPrevContested DemocratFundraisingAdvantage ///
		c.IdealPoint#c.Prof_StaffPerMember c.IdealPoint#c.Prof_Salary c.IdealPoint#c.Prof_SessionLength c.IdealPoint#c.FullTimeReporters c.IdealPoint#c.DemocratFundraisingAdvantage ///
		PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy  ///
		Q4StateEcon_DemAdjusted MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters ///
		 Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

****
* Analyses for Table A-5
** Responsiveness Approach: Dependent Variable: Democratic Winner
****		

	xtset State

	* Column 1: Base Model
	xtprobit DemocraticWinner IdealPoint DemocraticPresVoteShare Prev_DemVoteShare IncumbentPrevContested ///
	PresPartyDummy FreshmanDummy SenateDummy Q4StateEcon_DemAdjusted MidtermDummy LogDistrictSize Prof_StaffPerMember ///
	Prof_Salary Prof_SessionLength FullTimeReporters 

	* Column 2: Interactions
	xtprobit DemocraticWinner IdealPoint DemocraticPresVoteShare Prev_DemVoteShare IncumbentPrevContested ///
		c.IdealPoint#c.Prof_StaffPerMember c.IdealPoint#c.Prof_Salary c.IdealPoint#c.Prof_SessionLength c.IdealPoint#c.FullTimeReporters ///
		PresPartyDummy FreshmanDummy SenateDummy  ///
		Q4StateEcon_DemAdjusted MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters 

	xtset,clear


****
* Analyses for Table A-6
** Absolute Value Approach: Dependent Variable: Incumbent Vote Share
****		
	
	* Generate the Absolute Value of a legislator's ideal point
	gen Abs_IdealPoint=abs(IdealPoint)

	* Column 1
		* No Distance Squared
		xtmixed IncumbentVoteShare Abs_IdealPoint IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	* Column 2
		** Distance Squared
		 xtmixed IncumbentVoteShare Abs_IdealPoint c.Abs_IdealPoint#c.Abs_IdealPoint  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	* Column 3	
		** Distance Squared with Interactions
		xtmixed IncumbentVoteShare Abs_IdealPoint c.Abs_IdealPoint#c.Abs_IdealPoint ///
			c.Abs_IdealPoint#c.Prof_StaffPerMember c.Abs_IdealPoint#c.Prof_Salary c.Abs_IdealPoint#c.Prof_SessionLength c.Abs_IdealPoint#c.FullTimeReporters c.Abs_IdealPoint#c.IncFundraisingAdvantage ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ///
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

****
* Analyses for Table A-7
** Absolute Value Approach: Dependent Variable: Incumbent Reelection
****

	xtset State
		
	* Column 1
	* Distance
		xtprobit IncumbentWinner Abs_IdealPoint IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy ///
			FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters 

	* Column 2
		xtprobit IncumbentWinner Abs_IdealPoint c.Abs_IdealPoint#c.Prof_StaffPerMember c.Abs_IdealPoint#c.Prof_Salary c.Abs_IdealPoint#c.Prof_SessionLength c.Abs_IdealPoint#c.FullTimeReporters ///
			IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy ///
			LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters
			
	xtset,clear

	drop Abs_IdealPoint
	
****
* Analyses for Table A-8
** Alternative District Ideal Points
** Dependent Variable: Incumbent Vote Share
****

	* Create Distance Metric based on District Ideal Points created with Demographic Variables
	gen Distance_DemogVoteBased=abs(IdealPoint-DistrictIP_DemogBased)

	* Create Distance Metric based on District Ideal Points created with presidential vote
	gen Distance_PresVoteBased=abs(IdealPoint-DistrictIP_PresVoteBased)

	* Column 1
	** Distance Squared
	** TW Based District Ideal Points
		 xtmixed IncumbentVoteShare Distance c.Distance#c.Distance  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:
	
	* Column 2
	** Distance Squared
	** Demographic Variable Based District Ideal Points
		 xtmixed IncumbentVoteShare Distance_DemogVoteBased c.Distance_DemogVoteBased#c.Distance_DemogVoteBased  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:
	
	* Column 3
	** Distance Squared
	** Presidential Vote Based District Ideal Points
		 xtmixed IncumbentVoteShare Distance_PresVoteBased c.Distance_PresVoteBased#c.Distance_PresVoteBased  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
			Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

****
* Analyses for Table A-9
** Alternative District Ideal Points
** Dependent Variable: Incumbent Reelection
****

	xtset State
	
	* Column 1
	** TW Based District Ideal Points
			xtprobit IncumbentWinner Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy ///
			FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters 

	* Column 2
		** Demographic Variable Based District Ideal Points
			xtprobit IncumbentWinner Distance_DemogVoteBased IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy ///
			FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters 

	* Column 3
	** Demographic Variable Based District Ideal Points
			xtprobit IncumbentWinner Distance_PresVoteBased IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested PresPartyDummy DemocraticMemberDummy ///
			FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters 

	xtset,clear
			
****
* Analyses for Table A-10
** Sensitivity Analysis for Uncertainty of TW District Ideal Points
****

	* Column 1
	** No Squared Distance Term
	xtmixed IncumbentVoteShare Distance c.Distance#c.TW_MRP_SD TW_MRP_SD IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
	PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy  ///
	Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters ///
	 Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	* Column 2
	**  Squared Distance Term
	xtmixed IncumbentVoteShare Distance c.Distance#c.Distance c.Distance#c.TW_MRP_SD c.Distance#c.Distance#c.TW_MRP_SD TW_MRP_SD IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
	PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy  ///
	Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters ///
	 Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

****
* Analyses for Table A-11
** Control for Challenger Quality in State Senate Elections
****

	* Create a String Variable for Chamber to Seperate out Senate Elections
	decode Chamber, gen (ChamberString)

	* Column 1
	** Distance Squared ~ Senate Elections Only
	xtmixed IncumbentVoteShare Distance c.Distance#c.Distance  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
	PresPartyDummy DemocraticMemberDummy FreshmanDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
	Prof_SessionLength FullTimeReporters  Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1 & ChamberString=="S", ||State:

	* Column 2
	** Distance Squared ~ Senate Elections Only
	** Control for Challenger Quality
	xtmixed IncumbentVoteShare Distance c.Distance#c.Distance  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
	PresPartyDummy DemocraticMemberDummy FreshmanDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
	Prof_SessionLength FullTimeReporters QualityChallenger Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1 & ChamberString=="S", ||State:
	
	drop ChamberString

****
* Analyses for Table A-12
** Robustness: Sensititivity to Controls and States
****

	* Convert Labels of State to a String Variable for usage in if statements
	decode State, gen (StateString)

	* Column 1
	* No Controls
		xtmixed IncumbentVoteShare Distance Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 Yr9 if Contested==1, ||State:

	* Column 2
	* Only Control for Pres Vote
		xtmixed IncumbentVoteShare Distance IncumbentPartyPresVote Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 Yr9 if Contested==1, ||State:
		
	* Column 3
	* No RI ~ For Smallest Estimate
		xtmixed IncumbentVoteShare Distance c.Distance#c.Distance  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
		PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
		Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 Yr9 if Contested==1 & StateString!="RI", ||State:

	* Column 4
	* No NY ~ For Largest Estimate
		xtmixed IncumbentVoteShare Distance c.Distance#c.Distance  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
		PresPartyDummy DemocraticMemberDummy FreshmanDummy SenateDummy Q4StateEcon MidtermDummy LogDistrictSize Prof_StaffPerMember Prof_Salary ////
		Prof_SessionLength FullTimeReporters Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 Yr9 Yr10 if Contested==1 & StateString!="NY", ||State:

***
* Analyses for Table A-13
***

use "C:\Steven\Dropbox\Research Projects\Individual Chapter\APSR Submission\Replication\Public\Datasets\USHouseStateLegCommonIdealPoints.dta", clear

	reg StateLegIdealPoint USHouseIdealPoint RepublicanDummy

***
* Analyses for Table A-14
***
	***
	* The following is for analyses of US House Elections
	***
	
	* Below put the file location of Rogers-DataforIdeologicalRepresentationAnalyses-USHouseData.dta below
	use "C:\Steven\Dropbox\Research Projects\Individual Chapter\APSR Submission\Replication\Public\Datasets\Rogers-DataforIdeologicalRepresentationAnalyses-USHouseData.dta", clear
	
	quietly tab Year, gen(Yr)

		label variable Distance "Ideological Distance from District"
		label variable IncumbentPartyPresVote "Incumbent Party Pres Vote"
		label variable IncSpendingAdvantage "Incumbent Campaign Fin. Advantage"
		label variable IncumbentPrevVoteShare "Incumbent Previous Vote Share"
		label variable IncumbentPrevContested "Incumbent Previously Contested"
		label variable DemocraticDummy "Member of the Democratic Party"
		label variable PresPartyDummy "Member of the President's Party"
		label variable FreshmanDummy "Freshman Incumbent"
		label variable MidtermDummy "Midterm Election"

		* Table A-14: Column 1
		* US House Elections
		* No Squared Distance
			xtmixed IncumbentVoteShare Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncSpendingAdvantage ///
			PresPartyDummy DemocraticDummy FreshmanDummy MidtermDummy ///
			Yr1 Yr2 Yr3 Yr4 Yr5 if Contested==1, ||State:

		* Table A-14: Column 2
		* US House Elections
		* Squared Distance
			xtmixed IncumbentVoteShare Distance c.Distance#c.Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncSpendingAdvantage ///
			PresPartyDummy DemocraticDummy FreshmanDummy MidtermDummy ///
			 Yr1 Yr2 Yr3 Yr4 Yr5 if Contested==1, ||State:

	***
	* The following is for analyses of State Legislative Elections
	***	 
	use "C:\Steven\Dropbox\Research Projects\Individual Chapter\APSR Submission\Replication\Public\Datasets\Rogers-DataforIdeologicalRepresentationAnalyses.dta", clear

	quietly tab Year, gen(Yr)

		label variable Distance "Ideological Distance from District"
		label variable IncumbentPartyPresVote "Incumbent Party Pres Vote"
		label variable IncFundraisingAdvantage "Incumbent Campaign Fin. Advantage"
		label variable IncumbentPrevVoteShare "Incumbent Previous Vote Share"
		label variable IncumbentPrevContested "Incumbent Previously Contested"
		label variable DemocraticMemberDummy "Member of the Democratic Party"
		label variable PresPartyDummy "Member of the President's Party"
		label variable FreshmanDummy "Freshman Incumbent"
		label variable MidtermDummy "Midterm Election"

		* Table A-14: Column 3
		* State Legislative Elections
		* No Squared Distance
			xtmixed IncumbentVoteShare Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy MidtermDummy ///
			Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

		* Table A-14: Column 4
		* State Legislative Elections
		* Squared Distance
			xtmixed IncumbentVoteShare Distance c.Distance#c.Distance IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
			PresPartyDummy DemocraticMemberDummy FreshmanDummy MidtermDummy ///
			Yr1 Yr2 Yr3 Yr4 Yr5 Yr6 Yr7 Yr8 if Contested==1, ||State:

	 
