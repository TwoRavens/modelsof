// Table A1: Summary Statistics for full Sample 
	
	preserve 	
		gen Post = DepositChange
		collapse (mean) turnout n_entrants Post winner_share runnerup_share thirdplace_share fourthplace_share fifthplace_share RulingAllyWins IndepVoteSh CitCand (first) constname state year Unscheduled UnScheduledDepChange, by(constituency_election)		
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
	*Change the measurement units for turnout, and define turnout in the base period 
		gen Turnout = 100*turnout 		
		g winner_share100 = 100*winner_share 
		g runnerup_share100 = 100*runnerup_share
		g thirdplace_share100 = 100*thirdplace_share
		g fourthplace_share100 = 100*fourthplace_share
		g fifthplace_share100 = 100*fifthplace_share 
		g IndepVoteSh100 = 100*IndepVoteSh
		estpost summarize CitCand n_entrants Turnout IndepVoteSh100 winner_share100 runnerup_share100 thirdplace_share100 fourthplace_share100 fifthplace_share100 RulingAllyWins 
		esttab using "TabA1_SummaryStats.tex", cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2)) count") nomtitle nonumber replace 						
		g MoreThanSD = (CitCand >=12.50)
		summ MoreThanSD /* 721 observations with more than 12.50 Independents */ 
		summ MoreThanSD if year==1996 /* 320 observations (59 percent) with more than 12.50 Independents */ 
		summ MoreThanSD if year==1996|year==1991 /* 478 observations (44 percent) with more than 12.50 Independents */ 
		summ MoreThanSD if year==1996|year==1991|year==1989 /* 553 observations (34 percent) with more than 12.50 Independents */ 		
	restore
		
		
// Tables A2, OA1 (OA = online appendix), and Figures OA1(a) and OA1(b): Robustness to Smallest Window Around Reform and Outliers 
	preserve 
	keep if year>=1996&year<=1998 
	drop CitCand_s
	summ CitCand 
	g CitCand_s = (CitCand-r(mean))/r(sd) /*renormalization based on short window */ 
	g PostUnscheduled = Post*Unscheduled  
	*Descriptive Statistics
	estimates drop _all 		
	estpost summ CitCand Turnout RulingAllyWins if Unscheduled==1&Post==0
	est sto OpenPre 
	estpost summ CitCand Turnout RulingAllyWins if Unscheduled==1&Post==1
	est sto OpenPost
	reg CitCand Post if Unscheduled ==1, cluster(constituency) 
	reg Turnout Post if Unscheduled ==1, cluster(constituency)
	reg RulingAllyWins Post if Unscheduled ==1, cluster(constituency) 
	estpost summ CitCand Turnout RulingAllyWins if Unscheduled==0&Post==0
	est sto ReservedPre  
	estpost summ CitCand Turnout RulingAllyWins if Unscheduled==0&Post==1
	est sto ReservedPost 
	reg CitCand Post if Unscheduled ==0, cluster(constituency) 
	reg Turnout Post if Unscheduled ==0, cluster(constituency)
	reg RulingAllyWins Post if Unscheduled ==0, cluster(constituency) 		
	xtreg CitCand Post PostUnscheduled, fe cluster(constituency) 
	xtreg Turnout Post PostUnscheduled, fe cluster(constituency) 		 
	xtreg RulingAllyWins Post PostUnscheduled, fe cluster(constituency) 		 
	xtivreg2 Turnout Post (CitCand_s = PostUnscheduled), fe cluster(constituency) 		 		 		 
	xtivreg2 RulingAllyWins Post (CitCand_s = PostUnscheduled), fe cluster(constituency) 		 		 		 		
	esttab * using "TabA2_NationalDescriptives.tex", cell(mean(fmt(2)) sd(par)) sfmt(2) mti collabels(none) gaps label replace 				
	*Online Appendix Table OA1, replicates Table A1, but without outliers and high-leverage observations 
		sort constituency year 
		by constituency: g DiffTurnout = Turnout[2] - Turnout[1]		
		by constituency: g DiffCitCand = CitCand[2]-CitCand[1]
		by constituency: g DiffRulingAlly = RulingAllyWins[2]-RulingAllyWins[1]		
		drop CitCand_s
		summ CitCand if (DiffTurnout>=-30&DiffTurnout<=30&DiffCitCand>=-59)  
		g CitCand_s = (CitCand-r(mean))/r(sd) /*renormalization based on short window */ 			
		g Influential = !(DiffTurnout>=-30&DiffTurnout<=30&DiffCitCand>=-59)
		estimates drop _all 		
		estpost summ CitCand Turnout RulingAllyWins if Unscheduled==1&Post==0&Influential==0
		est sto OpenPre 
		estpost summ CitCand Turnout RulingAllyWins if Unscheduled==1&Post==1&Influential==0
		est sto OpenPost
		reg CitCand Post if Unscheduled ==1&Influential==0, cluster(constituency) 
		reg Turnout Post if Unscheduled ==1&Influential==0, cluster(constituency)
		reg RulingAllyWins Post if Unscheduled ==1&Influential==0, cluster(constituency) 
		estpost summ CitCand Turnout RulingAllyWins if Unscheduled==0&Post==0&Influential==0
		est sto ReservedPre  
		estpost summ CitCand Turnout RulingAllyWins if Unscheduled==0&Post==1&Influential==0
		est sto ReservedPost 
		reg CitCand Post if Unscheduled ==0&Influential==0, cluster(constituency) 
		reg Turnout Post if Unscheduled ==0&Influential==0, cluster(constituency)
		reg RulingAllyWins Post if Unscheduled ==0&Influential==0, cluster(constituency) 		
		xtreg CitCand Post PostUnscheduled if Influential==0, fe cluster(constituency) 
		xtreg Turnout Post PostUnscheduled if Influential==0, fe cluster(constituency) 		 
		xtreg RulingAllyWins Post PostUnscheduled if Influential==0, fe cluster(constituency) 		 
		xtivreg2 Turnout Post (CitCand_s = PostUnscheduled) if Influential==0, fe cluster(constituency) 		 		 		 
		xtivreg2 RulingAllyWins Post (CitCand_s = PostUnscheduled)if Influential==0, fe cluster(constituency) 		 		 		 		
		esttab * using "TabOA1_NationalDescriptives.tex", cell(mean(fmt(2)) sd(par)) sfmt(2) mti collabels(none) gaps label replace 							
	*Online Appendix Figures OA1a and OA1b 
		*Collapse data into first differences 
		collapse (first) Turnout CitCand Diff* Unscheduled Influential constname state, by(constituency)  
		twoway scatter DiffTurnout DiffCitCand, ysc(titlegap(2)) ytitle("Change in Voter Turnout") xsc(titlegap(2)) xtitle("Change in Number of Independents") name(Outliers, replace) 
		graph export "FigOA1a_WithOutliers.png", as(png) replace										
		twoway scatter DiffTurnout DiffCitCand if Influential==0, ysc(titlegap(2)) ytitle("Change in Voter Turnout") xsc(titlegap(2)) xtitle("Change in Number of Independents") name(NoOutliers, replace) 
		graph export "FigOA1b_NoOutliers.png", as(png) replace			
	restore 
		
// Table A3: Vote shares of Runner-up, etc.  	
	estimates drop _all 
	eststo: xi: xtivreg2 runnerup_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu runnerup_shareBaseTrend runnerup_shareBaseTrendSq runnerup_shareBaseTrendCu runnerup_shareBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 
	eststo: xi: xtivreg2 thirdplace_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu thirdplace_shareBaseTrend thirdplace_shareBaseTrendSq thirdplace_shareBaseTrendCu thirdplace_shareBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 
	eststo: xi: xtivreg2 fourthplace_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu fourthplace_shareBaseTrend fourthplace_shareBaseTrendSq fourthplace_shareBaseTrendCu fourthplace_shareBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 
	eststo: xi: xtivreg2 fifthplace_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu fifthplace_shareBaseTrend fifthplace_shareBaseTrendSq fifthplace_shareBaseTrendCu fifthplace_shareBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 
	eststo: xi: xtivreg2 sixthplace_share100 (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu sixthplace_shareBaseTrend sixthplace_shareBaseTrendSq sixthplace_shareBaseTrendCu sixthplace_shareBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 
	esttab using "TabA3_NationalVoteShareOther.tex", b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* _I*) label nonotes replace 		
		
// Table A4: Not just about the BJP or INC. It's about the ruling party. 
	estimates drop _all 
	foreach var of varlist BJPINCWins RulingBJPINCWins{				
		qui eststo: xi: xtivreg2 `var' (CitCand_s = UnScheduledDepChange) CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu `var'BaseTrend `var'BaseTrendSq `var'BaseTrendCu `var'BaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) 		
	}	
	esttab using "TabA4_ItsAboutRulingParty.tex",  b(2) p(2) scalars(N r2) sfmt(2) drop(CitCandBase* LnElectors Ruling* _I*) label nonotes replace 		
	
		
// Tables A5 and OA8 (OA = online appendix): Robustness of Turnout Results to paid holiday reform 
	//Merge in state gdp data 
	drop _merge 
	merge m:1 state year using FinalStateDomesticProduct
	drop if _merge==2 
	estimates drop _all	 	
	summ gnp 
	g StdGNP = (gnp - r(mean))/r(sd) 
	g UnscheduledGNP = Unscheduled*StdGNP
	estimates drop _all 
	qui eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) StdGNP UnscheduledGNP i.year, fe cluster(constituency) first				
	qui eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) StdGNP UnscheduledGNP CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu i.year, fe cluster(constituency) first			
	qui eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) StdGNP UnscheduledGNP CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu i.year, fe cluster(constituency) first		
	qui eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) StdGNP UnscheduledGNP CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors i.year, fe cluster(constituency) first	
	eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) StdGNP UnscheduledGNP CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
	esttab using "TabA5_NationalStateIncome.tex",  b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* Turnout* _I*) label nonotes replace 						
	//rural-treatment interactions instead of gdp 
		replace state="PUDUCHERRY" if state =="PONDICHERRY" 
		replace state="DELHI" if state =="NCT OF DELHI" 		
	*Using 2001 census. 
		replace state="CHANDIGARH" if state =="CHANDIGARGH" 			
		preserve 
		import delimited "census2001.csv", clear 	
		egen StatePop = total(persons), by(statenam) 
		egen StateRuralPop = total(rural), by(statenam) 
		g StateRuralSh = StateRuralPop/StatePop 
		keep statenam StateRuralSh
		collapse (first) StateRuralSh, by(statenam)
		replace statenam="Pondicherry" if statenam =="puducherry" 
		replace statenam="Manipur" if statenam=="Manipur (Excl. 3 Sub-Divisions)"
		replace statenam="Uttarakhand" if statenam=="Uttaranchal"	
		g state = upper(statenam) 
		drop statenam 
		save StateRuralSh, replace 		
		restore 	
		drop _merge 
		merge m:1 state using StateRuralSh
		g StateRuralSh100 = StateRuralSh*100
		g RuralTrend = StateRuralSh100*trend 
		g RuralTrendSq = StateRuralSh100*TrendSq 	
		g RuralTrendCu = StateRuralSh100*TrendCu 	
		g RuralTrendQu = StateRuralSh100*TrendQu 	
		estimates drop _all 
		eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) RuralTrend RuralTrendSq RuralTrendCu RuralTrendQu i.year, fe cluster(constituency) first				
		eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) RuralTrend RuralTrendSq RuralTrendCu RuralTrendQu CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu i.year, fe cluster(constituency) first			
		eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) RuralTrend RuralTrendSq RuralTrendCu RuralTrendQu CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu i.year, fe cluster(constituency) first				
		eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) RuralTrend RuralTrendSq RuralTrendCu RuralTrendQu CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors i.year, fe cluster(constituency) first	
		eststo: xi: xtivreg2 Turnout (CitCand_s = UnScheduledDepChange) RuralTrend RuralTrendSq RuralTrendCu RuralTrendQu CitCandBaseTrend CitCandBaseTrendSq CitCandBaseTrendCu CitCandBaseTrendQu TurnoutBaseTrend TurnoutBaseTrendSq TurnoutBaseTrendCu TurnoutBaseTrendQu LnElectors LagWinDist LagWinDistSq LagWinDistCu LagWinDistQu LagTightElection i.year, fe cluster(constituency) first
		esttab using "TabOA8_NationalRural.tex",  b(2) p(2) scalars(N r2) sfmt(2)  indicate(CitCandBase* LnElectors* Turnout* _I*) label nonotes replace 						
