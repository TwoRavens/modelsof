*Analysis has 4 parts: 
	*Part A: Build Variables 
	*Part B: Main Analysis (in this do file) 
	*Part C: Appendix Results (line 226 of this file calls the do file for Part C) 
	*Part D: Online Appendix Results (line 231 of this file calls the do file for Part D) 

*Call Data 
use LokSabhaElections_1971_2004, replace 		
		
******Part A: Preliminaries******

		do PartA_Prelims /*constructs variables used in the analysis */
		
********Part B: Main Statistics and Results*********
		
// Table II: Diff-Diff Descriptives 

	preserve 	
		gen Post = DepositChange
		collapse (mean) turnout n_entrants electors Post state_election CitCand winner_share (first) constname state year Unscheduled UnScheduledDepChange Ruling* (max) IndepVoteSh, by(constituency_election)		
		gen Election = Post 
		label variable Unscheduled "Constituency NOT Reserved for Member of Scheduled Caste or Tribe" 
		label variable UnScheduledDepChange "Not Reserved and First Post-1996 Election" 
		label variable Election "First Post-1996 Election" 		
		label variable CitCand "Independents or Candidates from a One-Member Unrecognised Party"
		label variable n_entrants "Number of Candidates Overall"		
		label variable turnout "Voter Turnout" 										
	*some more prelims 	
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
	*Keep the main years 
		keep if year>=1977&year<=2004 /*for main analysis*/ 				
		*keep if year>=1967&year<=2004 (for pictures)						
	*Generate interaction 
		gen PostUnscheduled = Post*Unscheduled  
	*Change the measurement units for turnout, and define turnout in the base period 
		gen Turnout = 100*turnout 		
	*Set the panel 
		xtset constituency year 		 
		*All 
		 estimates drop _all 		
		 estpost summ Turnout CitCand n_entrants if Unscheduled==1&Post==0
		 est sto OpenPre 
		 estpost summ Turnout CitCand n_entrants if Unscheduled==1&Post==1
		 est sto OpenPost
		 reg Turnout Post if Unscheduled ==1, cluster(constituency)
		 reg CitCand Post if Unscheduled ==1, cluster(constituency)
		 reg n_entrants Post if Unscheduled ==1, cluster(constituency) 
		 estpost summ Turnout CitCand n_entrants if Unscheduled==0&Post==0
		 est sto ReservedPre  
		 estpost summ Turnout CitCand n_entrants if Unscheduled==0&Post==1
		 est sto ReservedPost 
		 reg Turnout Post if Unscheduled ==0, cluster(constituency) 
		 reg CitCand Post if Unscheduled ==0, cluster(constituency)
		 reg n_entrants Post if Unscheduled ==0, cluster(constituency)
		 xtreg Turnout Post PostUnscheduled, fe cluster(constituency) 		 
		 xtreg CitCand Post PostUnscheduled, fe cluster(constituency) 		 
		 xtreg n_entrants Post PostUnscheduled, fe cluster(constituency) 		 
		 *IV
		 xtivreg2 Turnout Post (CitCand = PostUnscheduled), fe cluster(constituency) 		 		 		 
		esttab * using "Tab2_NationalDescriptives.tex", cell(mean(fmt(2)) sd(par)) sfmt(2) mti collabels(none) gaps label replace 
	restore 	
				
//Table III: First Stage 
	estimates drop _all 
	qui eststo: xi: xtreg CitCand UnScheduledDepChange i.year, fe vce(cluster constituency)	
	qui eststo: xi: xtreg CitCand UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu i.year, fe vce(cluster constituency)	
	qui eststo: xi: xtreg CitCand UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu i.year, fe vce(cluster constituency)	
	qui eststo: xi: xtreg CitCand UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors i.year, fe vce(cluster constituency)	
	qui eststo: xi: xtreg CitCand UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg AdjUnrecPties UnScheduledDepChange AdjUnrecPtiesBaseTrend AdjUnrecPtiesBaseTrendSq AdjUnrecPtiesBaseTrendCu AdjUnrecPtiesBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg StateParties UnScheduledDepChange StatePartiesBaseTrend StatePartiesBaseTrendSq StatePartiesBaseTrendCu StatePartiesBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors  LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg NationalParties UnScheduledDepChange NationalPartiesBaseTrend NationalPartiesBaseTrendSq NationalPartiesBaseTrendCu NationalPartiesBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors  LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
	esttab using "Tab3_NationalFirstStage.tex",  b(3) p(3) scalars(N r2) sfmt(3)   indicate(CitCandBase* TurnoutBase* LnElectors* Lag* _I*) label nonotes replace 						

//Figures 1 and 2: Evolutions of Independents and Turnout Across Open and Reserved Constituencies 
	reg CitCand UnScheduledDepChange Unscheduled Post 
	predict CitCandBaseRes, r 
	reg Turnout CitCandBaseRes 
	predict TurnoutBaseRes, r 
	preserve 		
	*Generate interaction for Independents 
	generate CitCandScheduled = CitCand*IScheduled 
	replace CitCandScheduled = . if CitCandScheduled ==0/*otherwise it includes 0s in averages */
	generate CitCandUnscheduled = CitCand*(Unscheduled)	
	replace CitCandUnscheduled = . if CitCandUnscheduled ==0 /*otherwise it includes 0s in averages */	
	*Generate interaction for Base Turnout Residuals  		
	generate TurnoutBaseResScheduled = TurnoutBaseRes*IScheduled 
	replace TurnoutBaseResScheduled = . if TurnoutBaseResScheduled ==0/*otherwise it includes 0s in averages */
	generate TurnoutBaseResUnscheduled = TurnoutBaseRes*(Unscheduled)	
	replace TurnoutBaseResUnscheduled = . if TurnoutBaseResUnscheduled ==0 /*otherwise it includes 0s in averages */			
	*Collapse Data 	
	collapse (mean) TurnoutBaseResScheduled TurnoutBaseResUnscheduled CitCandScheduled CitCandUnscheduled, by(year)			
	*Plot raw trends for Fringe 				
	twoway 	(scatter CitCandScheduled year, connect(l) lpattern(dash) xline(1996.8) xlabel(1971 1977 1984 1991 1998 2004) xsc(titlegap(2)) xtitle("Year") ytitle("#Independent Candidates") legend(off)) ///
			scatter CitCandUnscheduled year, connect(d) ///
			text(22 2000.8 "Entry Deposit is" "5000 Rupees" "for Minorities," "10000 Rupees" "for Everyone Else") ///
			text(22 1984 "Entry Deposit is" "250 Rupees" "for Minorities," "500 Rupees" "for Everyone Else") ///
			text(12 1984.5 "Seats are Open") ///				
			text(1 1984.5 "Seats are Reserved") ///								
			|| pcarrowi 11.5 1984.5 9 1984.5 (3), mcolor(black) lcolor(black) ///
			|| pcarrowi 2 1984.5 4.5 1984.5 (3), mcolor(black) lcolor(black) 
			graph export "Fig1_Independents.png", as(png) replace							
	*Plot raw trends for Turnout	
	twoway 	(scatter TurnoutBaseResScheduled year, connect(l) lpattern(dash) xline(1996.8) xlabel(1971 1977 1984 1991 1998 2004) xsc(titlegap(2)) xtitle("Year") ytitle("Voter Turnout (% of Eligible Electors)") legend(off)) ///
			scatter TurnoutBaseResUnscheduled year, connect(d) ///		
			text(-8 2000.8 "Entry Deposit is" "5000 Rupees" "for Minorities," "10000 Rupees" "for Everyone Else") ///
			text(-8 1992 "Entry Deposit is" "250 Rupees" "for Minorities," "500 Rupees" "for Everyone Else") ///			
			text(5 1992 "Seats are Open") ///				
			text(-9 1978 "Seats are Reserved") ///								
			|| pcarrowi -8.5 1978 -4.5 1978 (3), mcolor(black) lcolor(black) ///
			|| pcarrowi 4.5 1992 -1.2 1992 (3), mcolor(black) lcolor(black) 
			graph export "Fig2_Turnout.png", as(png) replace							
	restore 			
		
//Table IV: OLS, IV, and Reduced Form for Voter Turnout 
	*OLS
	estimates drop _all	 	
	qui eststo: xi: xtreg Turnout CitCand_s i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
	esttab using "NationalOLS.tex",  b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* Turnout* Lag*) label nonotes replace 								
	*IV
	estimates drop _all	 	
	eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
	esttab using "NationalIV.tex",  b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* Turnout* _I*) label nonotes replace 					
	*Reduced Form
	estimates drop _all	 	
	qui eststo: xi: xtreg Turnout UnScheduledDepChange i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors i.year, fe vce(cluster constituency)
	qui eststo: xi: xtreg Turnout UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
	esttab using "NationalRF.tex",  b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* Turnout* Lag*) label nonotes replace 			
	
//Table V: Leads and Lags for Independents and Turnout		
	estimates drop _all 
	qui eststo: xtreg CitCand Lead4UnScheduled1998 Lead3UnScheduled1998 Lead2UnScheduled1998 Lead1UnScheduled1998 UnScheduled1998 Lag1UnScheduled1998 Lag2UnScheduled1998 CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)		
	qui eststo: xtreg Turnout Lead4UnScheduled1998 Lead3UnScheduled1998 Lead2UnScheduled1998 Lead1UnScheduled1998 UnScheduled1998 Lag1UnScheduled1998 Lag2UnScheduled1998 TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)		
	esttab using "Tab5_NationalLeadsLags.tex",  b(2) p(2) scalars(N r2) sfmt(2)  indicate(LnElectors* Turnout* 19* 20*) label nonotes replace 						
				
// Table VI: Vote shares of Independents and Winner.  
	estimates drop _all 
	*Independents. 	
	eststo: xi: xtivreg2 IndepVoteSh100 (CitCand_s = UnScheduledDepChange) i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 IndepVoteSh100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 IndepVoteSh100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu IndepVoteShBaseTrend IndepVoteShBaseTrendSq IndepVoteShBaseTrendCu IndepVoteShBaseTrendQu i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 IndepVoteSh100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu IndepVoteShBaseTrend IndepVoteShBaseTrendSq IndepVoteShBaseTrendCu IndepVoteShBaseTrendQu LnElectors i.year, fe cluster(constituency) first
	eststo: xi: xtivreg2 IndepVoteSh100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu IndepVoteShBaseTrend IndepVoteShBaseTrendSq IndepVoteShBaseTrendCu IndepVoteShBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
	*Winner, Runner-up, etc. 	
	eststo: xi: xtivreg2 winner_share100 (CitCand_s = UnScheduledDepChange) i.year, fe cluster(constituency) 					
	eststo: xi: xtivreg2 winner_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu i.year, fe cluster(constituency) 				
	eststo: xi: xtivreg2 winner_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu winner_shareBaseTrend winner_shareBaseTrendSq winner_shareBaseTrendCu winner_shareBaseTrendQu i.year, fe cluster(constituency) 			
	eststo: xi: xtivreg2 winner_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu winner_shareBaseTrend winner_shareBaseTrendSq winner_shareBaseTrendCu winner_shareBaseTrendQu LnElectors i.year, fe cluster(constituency) 		
	eststo: xi: xtivreg2 winner_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu winner_shareBaseTrend winner_shareBaseTrendSq winner_shareBaseTrendCu winner_shareBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 
	esttab using "Tab6_NationalVoteShareMain.tex", b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* _I*) label nonotes replace 		

// Table VII: Is the governing-coalition candidate more or less likely to win? 
		estimates drop _all	 
		qui eststo: xi: xtreg RulingAllyWins CitCand_s i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu LnElectors i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins CitCand_s CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu LnElectors  LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
		esttab using "RulingAllyWinsOLS.tex",  b(2) p(2) scalars(N r2) sfmt(2) indicate(CitCandBase* LnElectors* RulingAllyBase* _I* Lag*) label nonotes replace 									
		est drop _all 		
		eststo: xi: xtivreg2 RulingAllyWins (CitCand_s = UnScheduledDepChange) i.year, fe cluster(constituency) first					
		eststo: xi: xtivreg2 RulingAllyWins (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  i.year, fe cluster(constituency) first					
		eststo: xi: xtivreg2 RulingAllyWins (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu i.year, fe cluster(constituency) first 					
		eststo: xi: xtivreg2 RulingAllyWins (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu LnElectors i.year, fe cluster(constituency) first					
		eststo: xi: xtivreg2 RulingAllyWins (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first					
		esttab using "RulingAllyWinsIV.tex",  b(2) p(2) scalars(N r2) sfmt(2) drop(CitCandBase* LnElectors* RulingAllyBase* _I* Lag*) label nonotes replace 			
		est drop _all
		qui eststo: xi: xtreg RulingAllyWins UnScheduledDepChange i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu LnElectors i.year, fe vce(cluster constituency)
		qui eststo: xi: xtreg RulingAllyWins UnScheduledDepChange CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu  RulingAllyBaseTrend RulingAllyBaseTrendSq RulingAllyBaseTrendCu RulingAllyBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe vce(cluster constituency)
		esttab using "RulingAllyWinsRF.tex",  b(2) p(2) scalars(N r2) sfmt(2) indicate(CitCandBase* LnElectors* _I* Lag*) label nonotes replace 			

//Table VIII: Rise of Ethnic Parties 	
	preserve
	keep if year<=1998 & year>=1996	
	//Shift in Vote Share	
		replace BJPSh = 0 if BJPSh==.
		replace INCSh = 0 if INCSh==.
		g NatAllianceShare = 0
		replace NatAllianceShare = BJPSh+INCSh if year==1996
		replace NatAllianceShare = NDAshare+INCSh if year==1998
		g ElseShare = 1 - NatAllianceShare - REGshare
		//Regressions
		xi: xtivreg2 NatAllianceShare (CitCand_s = UnScheduledDepChange)  LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
		xi: xtivreg2 REGshare (CitCand_s = UnScheduledDepChange) LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
		xi: xtivreg2 ElseShare (CitCand_s = UnScheduledDepChange)  LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first	
	//Change in Win probability
		replace BJPWins = 0 if BJPWins==.
		replace INCWins = 0 if INCWins==.
		g NatAllianceWins = 0
		replace NatAllianceWins = BJPWins+INCWins if year==1996
		replace NatAllianceWins = NDAWins+INCWins if year==1998
		g ElseWins = 1 - NatAllianceWins - REGWins
		//Regressions
		xi: xtivreg2 NatAllianceWins (CitCand_s = UnScheduledDepChange)  LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
		xi: xtivreg2 REGWins (CitCand_s = UnScheduledDepChange) LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
		xi: xtivreg2 ElseWins (CitCand_s = UnScheduledDepChange)  LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first	
	restore
		
	
*******Part C: Appendix Statistics and Results**********	
	
		do PartC_Appendix 

	
***********Part D: Remaining Online Appendix Tables*************		

		do PartD_OnlineAppendix 

		



		
		
		
		

