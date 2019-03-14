	*Here we construct the variables to be used in the analysis 	
	*standardize some key variables	
		summ CitCand 
		gen CitCand_s = (CitCand)/r(sd)		
		summ CitCand2 
		gen CitCand2_s = (CitCand2)/r(sd)				
		summ CitCand3 
		gen CitCand3_s = (CitCand3)/r(sd)				
	*some more prelims 	
		gen Election = Post 
		encode constname, generate(constituencyTemp)
 		egen constituency = group(constituencyTemp state)
	*Drop the Constituency-Years where there was no election
		drop if turnout==0	
	*Drop Singletons to generate a balanced panel
		sort constituency
		generate single=1
		by constituency: egen singlecount = total(single) 
		drop if singlecount==1
	*Remove duplicates 
		duplicates report constituency year
		duplicates tag constituency year, gen(isdup)			
		drop if isdup>0			
	*Generate higher order trends 
		gen trend = 1 
		replace trend = 2 if year==1980
		replace trend = 3 if year==1984
		replace trend = 4 if year==1989
		replace trend = 5 if year==1991
		replace trend = 6 if year==1996			
		replace trend = 7 if year==1998
		replace trend = 8 if year==1999
		replace trend = 9 if year==2004
		replace trend = 10 if year==2009		
		gen TrendSq = trend^2
		gen TrendCu = trend^3			
		gen TrendQu = trend^4						
	*Take logs of electors (to deal with outliers) 
		g LnElectors = ln(electors) 
	*Interaction between open and 1998 (when the policy change occurred)
		gen I1998=year==1998
		gen UnScheduled1998=Unscheduled*I1998
	*Generate Leads and Lags 
		xtset constituency year
		bysort constituency (year): g Lead1UnScheduled1998=UnScheduled1998[_n+1]
		replace Lead1UnScheduled1998 = 0 if Lead1UnScheduled1998==. 
		bysort constituency (year): g Lead2UnScheduled1998=UnScheduled1998[_n+2]		
		replace Lead2UnScheduled1998 = 0 if Lead2UnScheduled1998==. 		
		bysort constituency (year): g Lead3UnScheduled1998=UnScheduled1998[_n+3]				
		replace Lead3UnScheduled1998 = 0 if Lead3UnScheduled1998==. 		
		bysort constituency (year): g Lead4UnScheduled1998=UnScheduled1998[_n+4]				
		replace Lead4UnScheduled1998 = 0 if Lead4UnScheduled1998==. 				
		bysort constituency (year): g Lag1UnScheduled1998=UnScheduled1998[_n-1]				
		bysort constituency (year): g Lag2UnScheduled1998=UnScheduled1998[_n-2]	
	*Keep the main years 
		keep if year>=1977&year<=2004 /*for main analysis*/ 				
		keep if year>=1970&year<=2004 /*(for pictures)						*/
	*Change the measurement units for turnout, and define turnout in the base period 
		gen Turnout = 100*turnout 
	*Create differential trends 	
		sort constituency year 
		foreach var of varlist CitCand CitCand2 CitCand3 AdjUnrecPties UnrecParties StateParties NationalParties Turnout winner_share runnerup_share thirdplace_share fourthplace_share fifthplace_share sixthplace_share seventhplace_share eighthplace_share{		
			bys constituency (year): gen `var'Base = `var'[1] 		
			gen `var'BaseTrend = `var'Base*trend 
			gen `var'BaseTrendSq = `var'Base*TrendSq 	
			gen `var'BaseTrendCu = `var'Base*TrendCu 	
			gen `var'BaseTrendQu = `var'Base*TrendQu 			
			}
	*Trends for Ruling Alliance  
		bys constituency (year): gen RulingAllyBase = RulingAllyWins[1] 		
		gen RulingAllyBaseTrend = RulingAllyBase*trend 
		gen RulingAllyBaseTrendSq = RulingAllyBase*TrendSq 	
		gen RulingAllyBaseTrendCu = RulingAllyBase*TrendCu 	
		gen RulingAllyBaseTrendQu = RulingAllyBase*TrendQu 			
	*Trends for Independent Vote Shares   
		replace IndepVoteSh = 0 if IndepVoteSh==. 
		replace IndepVoteSh2 = 0 if IndepVoteSh2==. 
		replace IndepVoteSh3 = 0 if IndepVoteSh3==. 		
		foreach var of varlist IndepVoteSh IndepVoteSh2 IndepVoteSh3{		
			bys constituency (year): gen `var'Base = `var'[1] 		
			gen `var'BaseTrend = `var'Base*trend 
			gen `var'BaseTrendSq = `var'Base*TrendSq 	
			gen `var'BaseTrendCu = `var'Base*TrendCu 	
			gen `var'BaseTrendQu = `var'Base*TrendQu 			
			}
	*Trends for BJP or INC Wins, BJP or INC Wins and is Ruling Party
		egen BJPINCWins = rowtotal(INCWins-BJPWins)  	
		g RulingBJPINCWins = BJPINCWins*RulingAllyWins			
		sort constituency year 
		foreach var of varlist BJPINCWins RulingBJPINCWins{		
		bys constituency (year): gen `var'Base = `var'[1] 		
		gen `var'BaseTrend = `var'Base*trend 
		gen `var'BaseTrendSq = `var'Base*TrendSq 	
		gen `var'BaseTrendCu = `var'Base*TrendCu 	
		gen `var'BaseTrendQu = `var'Base*TrendQu 								
		}				
	*Define districts which were safe in the last election: 
		bysort constituency (year): g LagWinDist=windist[_n-1]						
		g LagWinDistSq = LagWinDist^2	
		g LagWinDistCu = LagWinDist^3			
		g LagWinDistQu = LagWinDist^4					
		g LagTightElection = LagWinDist<=.05
	*Labels 
		label variable CitCand "$\#$ Independents"		
		label variable UnScheduledDepChange "Open Seat After the Fee Increase"		
		label variable Lead4UnScheduled1998 "Fours Elections Ahead"		
		label variable Lead3UnScheduled1998 "Three Elections Ahead"		
		label variable Lead2UnScheduled1998 "Two Elections Ahead"		
		label variable Lead1UnScheduled1998 "One Election Ahead"				
		label variable UnScheduled1998 "Election where Entry Fees first Changed"								
		label variable Lag1UnScheduled1998 "One Election Ago"						
		label variable Lag2UnScheduled1998 "Two Elections Ago"				
	*Reserved Constituencies 
		gen IScheduled = 1 - Unscheduled 
	*Vote shares  
		*convert votes shares to 100 point scale
		*convert 0's to missing 
		foreach var of varlist winner_share runnerup_share thirdplace_share fourthplace_share fifthplace_share sixthplace_share seventhplace_share eighthplace_share IndepVoteSh IndepVoteSh2 IndepVoteSh3{
			gen `var'100 = 100*`var'
			replace `var'100 = . if `var'100==0 
		}	
