

use "C:\Steven\Dropbox\Research Projects\Individual Chapter\APSR Submission\Replication\Public\Datasets\Rogers-DataforIndividualRollCallAnalyses.dta", clear
	
***
* Label Variables
***
	
	label variable Referendum "District Support for Bill"
	label variable IncumbentPartyPresVote "Incumbent Party Pres Vote"
	label variable IncFundraisingAdvantage "Incumbent Contribution Advantage"
	label variable Current_FourCandidates "Current Four Candidates"
	label variable Current_ThreeCandidates "Current Three Candidates"
	label variable IncumbentPrevVoteShare "Incumbent Previous Vote Share"
	label variable IncumbentPrevContested "Incumbent Previously Contested"
	label variable Prev_ThreeCandidates "Previous Three Candidates"
	label variable Prev_FourCandidates "Previous Four Candidates"
	label variable SenateDummy "State Senate Race"
	label variable DemocraticDummy "Member of the Democratic Party"
	label variable PresPartyDummy "Member of the President's Party"
	label variable FreshmanDummy "Freshman Incumbent"
	label variable Prof_StaffPerMember "Legislative Staff per Member"
	label variable Prof_Salary "Legislator Salary (in 1000s of 2010 dollars)"
	label variable Prof_SessionLength "Session Length"
	label variable LogDistrictSize "District Size (Logged)"
	label variable FullTimeReporters "Full Time State Capital Reporters (Logged)"

	* Convert state to a string for usage in if statements
	decode State, gen (StateString)

	
****
* Analyses for Table 5
* Dependent Variable: Incumbent Vote Share among Contested Incumbents who appeared in the general election
****

	* Table 5 ~ Column 1
		** Varying Slopes ~ Base
			xtmixed IncumbentVoteShare Referendum IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested IncFundraisingAdvantage ///
				SenateDummy DemocraticDummy ///
				Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  ///
				if Contested==1 & IncumbentinGeneral==1, ||Bill: Referendum, cov(indep)
				
	* Table 5 ~ Column 2
		** Varying Slopes ~ Controls
			xtmixed IncumbentVoteShare Referendum  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
				SenateDummy DemocraticDummy PresPartyDummy ///
				Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
				FreshmanDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters if Contested==1, ||Bill: Referendum, cov(indep) 

				
	* Table 5 ~ Column 3
		** Varying Slopes ~ Controls
		** Single Member Districts
			xtmixed IncumbentVoteShare Referendum  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
				SenateDummy DemocraticDummy PresPartyDummy ///
				FreshmanDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters  ///
				if Contested==1 & StateString!="MD" & StateString!="ND" & StateString!="AZ" , ||Bill: Referendum, cov(indep) 

				
	* Table 5 ~ Column 4
		** Varying Slopes ~ Controls
		** Marginal Districts	
			xtmixed IncumbentVoteShare Referendum  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
				SenateDummy DemocraticDummy PresPartyDummy ///
				FreshmanDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters  ///
				Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
				if Contested==1 & IncumbentPartyPresVote<60, ||Bill: Referendum, cov(indep)

	* Table 5 ~ Column 5
		** Varying Slopes ~ Controls
		** Safe Districts
			xtmixed IncumbentVoteShare Referendum  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
				SenateDummy DemocraticDummy PresPartyDummy ///
				FreshmanDummy LogDistrictSize Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters  ///
				Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
				if Contested==1 & IncumbentPartyPresVote>=60, ||Bill: Referendum, cov(indep)
	
****
* Analyses for Table A-15
* Dependent Variable: Whether Incumbent Sought Reelection in the Primary Election
****

	xtset Bill

	* Column 1
	* Base Model
		xtprobit IncumbentSeekingReelection Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy ///
		Prev_ThreeCandidates Prev_FourCandidates 

	* Column 2
	** Add Controls
		xtprobit IncumbentSeekingReelection Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		Prev_ThreeCandidates Prev_FourCandidates ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize

	* Column 3
	** Base Model
	** Single Member Districts
		xtprobit IncumbentSeekingReelection Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy ///
		if StateString!="MD" & StateString!="ND" & StateString!="AZ"  	

	* Column 4
	** Add controls
	** Single Member Districts
		xtprobit IncumbentSeekingReelection Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize ///
		if StateString!="MD" & StateString!="ND" & StateString!="AZ"  

****
* Analyses for Table A-16
* Dependent Variable: Incumbent Reelection
****

	xtset Bill

	* Column 1
	** Base Model
			xtprobit IncumbentWinner Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
			SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  
			
	* Column 2
	** Controls
			xtprobit IncumbentWinner Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
			SenateDummy DemocraticDummy PresPartyDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
			FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize

	* Column 3
	** Base Model
	** Single Member Districts
			xtprobit IncumbentWinner Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
			SenateDummy DemocraticDummy PresPartyDummy ///
			FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize  ///
			if StateString!="MD" & StateString!="ND" & StateString!="AZ" 
		
	* Column 4
	** Controls
	** Marginal Districts
			xtprobit IncumbentWinner Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
			SenateDummy DemocraticDummy PresPartyDummy ///
			FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize  ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
			if IncumbentPartyPresVote<60
			
	* Column 5
	** Controls
	** Safe Districts
			xtprobit IncumbentWinner Referendum  IncumbentPartyPresVote IncumbentPrevVoteShare IncumbentPrevContested ///
			SenateDummy DemocraticDummy PresPartyDummy ///
			FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize  ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
			if IncumbentPartyPresVote>=60

	xtset,clear
			
****
* Analyses for Table A-17
* Dependent Variable: Incumbent Vote Share among Contested Incumbents who appeared in the general election
***
	
	* Create a dummy variable for if a majority of the district supported the legislator's position
	gen MajorityRefSupport=0
	replace MajorityRefSupport=1 if Referendum>50

	* Column 1
	* Base Model
		xtmixed IncumbentVoteShare MajorityRefSupport  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy ///
		Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  ///
		if Contested==1, ||Bill: Referendum, cov(indep)

	* Column 2
	* Controls
		xtmixed IncumbentVoteShare MajorityRefSupport  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize if Contested==1, ||Bill: Referendum, cov(indep) 

	* Column 3
	* Controls
	* Single Member Districts
		xtmixed IncumbentVoteShare MajorityRefSupport  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize  ///
		if Contested==1 & StateString!="MD" & StateString!="ND" & StateString!="AZ" , ||Bill: Referendum, cov(indep) 

	* Column 4
	* Controls
	* Marginal Districts
		xtmixed IncumbentVoteShare MajorityRefSupport  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize  ///
		Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
		if Contested==1 & IncumbentPartyPresVote<60, ||Bill: Referendum, cov(indep)

	* Column 5
	* Controls
	* Safe Districts
		xtmixed IncumbentVoteShare MajorityRefSupport  IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize  ///
		Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates ///
		if Contested==1 & IncumbentPartyPresVote>=60, ||Bill: Referendum, cov(indep)

****
* Analyses for Table A-18
* Dependent Variable: Incumbent Vote Share among Contested Incumbents who appeared in the general election
***

	* Column 1
	* All Districts
		xtmixed  IncumbentVoteShare Referendum  ///
		IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		c.Referendum#c.Prof_StaffPerMember c.Referendum#c.Prof_Salary c.Referendum#c.Prof_SessionLength ///
		c.Referendum#c.FullTimeReporters c.Referendum#c.IncFundraisingAdvantage ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize ///
		Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  ///
		if Contested==1 , ||Bill: Referendum, cov(indep)

	* Column 2
	* Single Member Districts
		xtmixed  IncumbentVoteShare Referendum  ///
		IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested ///
		c.Referendum#c.Prof_StaffPerMember c.Referendum#c.Prof_Salary c.Referendum#c.Prof_SessionLength ///
		c.Referendum#c.FullTimeReporters c.Referendum#c.IncFundraisingAdvantage ///
		SenateDummy DemocraticDummy PresPartyDummy ///
		FreshmanDummy Prof_StaffPerMember Prof_Salary Prof_SessionLength FullTimeReporters LogDistrictSize ///
		if Contested==1 & StateString!="MD" & StateString!="AZ" & StateString!="ND", ||Bill: Referendum, cov(indep)
		
***
* Analyses for Tables A-19 through A-28
***
	* Create a string variable for bills for usage in if statements
	decode Bill, gen (BillString)
	
	* Table A-19
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 & BillString=="AK-SB267"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 & BillString=="AK-SB267"

	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 & BillString=="AK-SB21"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 & BillString=="AK-SB21"

	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB2"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB2"
	
	* Table A-20
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB957"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB957"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB175"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB175"	
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB903"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB903"	
	
	* Table A-21
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB174"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-SB174"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-AB277"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="CA-AB277"	
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ID-SB1184"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ID-SB1184"	

	* Table A-22
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ID-SB1110"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ID-SB1110"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ID-SB1108"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ID-SB1108"	
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ME-LS1196"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ME-LS1196"

	* Table A-23
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ME-LD2247"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ME-LD2247"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ME-LD1020"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="ME-LD1020"	
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MI-PA269"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MI-PA269"

	* Table A-24
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MI-PA4"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MI-PA4"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MI-PA160"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MI-PA160"
		
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MT-SB423"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="MT-SB423"

	* Table A-25
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="OH-HB545"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="OH-HB545"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="OH-SB5"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="OH-SB5"	
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-ESSHB2295"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-ESSHB2295"

	* Table A-26
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-SB5726"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-SB5726"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-SB6239"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-SB6239"	
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-SB5688"
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy if Contested==1 &  BillString=="WA-SB5688"

	* Table A-27
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="MD-HB1368"	
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="MD-HB1368"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="MD-HB438"	
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="MD-HB438"

	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="MD-SB167"	
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="MD-SB167"

	* Table A-28
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="ND-SB2370"	
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Current_FourCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="ND-SB2370"
	
	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="AZ-SB1373"	
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="AZ-SB1373"

	reg  IncumbentVoteShare Referendum IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="AZ-HB2518"	
	reg  IncumbentVoteShare IncumbentPartyPresVote IncFundraisingAdvantage IncumbentPrevVoteShare IncumbentPrevContested SenateDummy DemocraticDummy ///
			Current_ThreeCandidates Prev_ThreeCandidates Prev_FourCandidates  if Contested==1 &  BillString=="AZ-HB2518"
