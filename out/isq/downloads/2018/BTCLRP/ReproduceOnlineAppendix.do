/* Do file for "Investment, Opportunity, and Risk: Do U.S. Sanctions 
Deter or Encourage Global Investment?" by Dave Lektzian and Glen Biglaiser.
The commands in this do file reproduce the information in the online appendix */

* Appendix A: Table 2 Using Change in Global FDI as the Dependent Variable w/o Subtracting USFDI (Discussed in fn. 9) 
	* Model 1 
		xtreg DWDIFDIPerGDP lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDP  Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in in differences 
		xtreg DWDIFDIPerGDP l.USsanCostHD l.USsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg DWDIFDIPerGDP l.US_sanIO l.US_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg DWDIFDIPerGDP	l.US_Major_Goal l.US_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		
		xtreg DWDIFDIPerGDP	lUS_dem6 lUS_N_dem6 ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDP AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6

* Appendix B: Table 2 For Developing Countries Only (Discussed in fn. 19)
	* Model 1
		xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut  Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1 & DevelopedDummy==0,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in in differences 
		xtreg DWDIFDIPerGDPNonUSCapOut l.USsanCostHD l.USsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib  DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & DevelopedDummy==0, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg DWDIFDIPerGDPNonUSCapOut  l.US_sanIO l.US_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & DevelopedDummy==0, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg DWDIFDIPerGDPNonUSCapOut  l.US_Major_Goal l.US_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & DevelopedDummy==0, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		
		xtreg DWDIFDIPerGDPNonUSCapOut lUS_dem6 lUS_N_dem6    ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & DevelopedDummy==0, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6
		
* Appendix C: The Effect of Lagged U.S. Sanctions on GDP, LogGDP, change in GDP and change in LogGDP (Discussed in fn. 23).    
	xtreg WDIGDPCurUSD lsanUSSen l.WDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  vce(robust) re
	
	xtreg logWDIGDPCurUSD lsanUSSen l.logWDIGDPCurUSD ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1, vce(robust) fe

	xtreg DWDIGDPCurUSD lsanUSSen l.DWDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1, vce(robust) fe
		
	xtreg DlogWDIGDPCurUSD lsanUSSen l.DlogWDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1, vce(robust) fe

* Appendix D: The Effect of U.S. Sanctions on Chane in USFDI/GDP and Change in Logged USFDI in USD (Discussed in fn. 25)
	xtreg DUSFDICapOutPerGDP lsanUSSen l.DUSFDICapOutPerGDP  ///
	Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1, vce(robust) fe
	
	xtreg DlogUSFDICapOutUSD lsanUSSen l.DlogUSFDICapOutUSD  ///
	Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1, vce(robust) fe

* Appendix E: Table 2 For Countries That are not Rich in Natural Resources (Discussed in fn. 27)
	* Model 1
		xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut  Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1 & ResourceCurse==0,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in in differences 
		xtreg DWDIFDIPerGDPNonUSCapOut l.USsanCostHD l.USsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib  DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & ResourceCurse==0, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg DWDIFDIPerGDPNonUSCapOut  l.US_sanIO l.US_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & ResourceCurse==0, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg DWDIFDIPerGDPNonUSCapOut  l.US_Major_Goal l.US_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & ResourceCurse==0, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		
		xtreg DWDIFDIPerGDPNonUSCapOut lUS_dem6 lUS_N_dem6    ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1 & ResourceCurse==0, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6
			
* Appendix F: Table 2 Using Level of Global FDI as the Dependent Variable (Discussed in fn. 28)
	* Model 1
		xtreg WDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in in differences 
		xtreg WDIFDIPerGDPNonUSCapOut l.USsanCostHD l.USsanCostLD ///
		lUSFDICapOutPerGDP lWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg WDIFDIPerGDPNonUSCapOut  ///
		l.US_sanIO l.US_san_N_IO   ///
		lUSFDICapOutPerGDP lWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg WDIFDIPerGDPNonUSCapOut   ///
		l.US_Major_Goal l.US_N_Major_Goal  ///
		lUSFDICapOutPerGDP lWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		
		xtreg WDIFDIPerGDPNonUSCapOut   ///
		lUS_dem6 lUS_N_dem6    ///
		lUSFDICapOutPerGDP lWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6
		
* Appendix G: Variance Inflation Collinearity Diagnostics (Discussed in fn. 28)
	* Model 1
		collin DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut  Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1
		
	* Model 2: high cost and low cost sanctions with dep var in in differences 
		collin DWDIFDIPerGDPNonUSCapOut lUSsanCostHD lUSsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1

	* Model 3: IO in Sender
		collin DWDIFDIPerGDPNonUSCapOut lUS_sanIO lUS_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1

	* Model 4: Major Goal
		collin DWDIFDIPerGDPNonUSCapOut lUS_Major_Goal lUS_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1

	* Model 5: regime type of the target of sanctions
		collin DWDIFDIPerGDPNonUSCapOut lUS_dem6 lUS_N_dem6    ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1

	* correlation matrix
		corr lUS_dem6 lUS_Major_Goal lUS_sanIO lC_DUSFDICapOutPerGDP lUSsanCostHD lsanUSSen ///
		lSanC_DUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut  Polity4 AGEHINST6CLASSDurCheib ///
		DevelopLogGDPCap GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar

* Appendix H: The Effect of Export, Import, and Finance Sanctions on Change in Global FDI/GDP
	xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lUSsanx lUSSanxC_DUSFDICapOutPerGDP ///
	lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  vce(robust) fe

	xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lUSsani lUSSaniC_DUSFDICapOutPerGDP ///
	lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if year<2001 & nomiss==1,  vce(robust) fe
	
	xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lUSsanf lUSSanfC_DUSFDICapOutPerGDP ///
	lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if year<2001 & nomiss==1,  vce(robust) fe

* Appendix I: The Effect of Export, Import, and Finance Sanctions on Change in French FDI/GDP
	xtreg DFrenchFDIPerGDP lC_DUSFDICapOutPerGDP lUSsanx lUSSanxC_DUSFDICapOutPerGDP ///
	lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  vce(robust) fe

	xtreg DFrenchFDIPerGDP lC_DUSFDICapOutPerGDP lUSsani lUSSaniC_DUSFDICapOutPerGDP ///
	lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  vce(robust) fe
	
	xtreg DFrenchFDIPerGDP lC_DUSFDICapOutPerGDP lUSsanf lUSSanfC_DUSFDICapOutPerGDP ///
	lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
	GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  vce(robust) fe

* Appendix J: Table 2 With Year Dummies: The Effect of U.S. Sanctions and Change in U.S. FDI/GDP ///
* on Change in Global FDI/GDP
	* Model 1
		xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year81 year85 year97 year98 if nomiss==1,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in differences 
		xtreg DWDIFDIPerGDPNonUSCapOut l.USsanCostHD l.USsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year81 year85 year97 year98 if nomiss1==1, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg DWDIFDIPerGDPNonUSCapOut l.US_sanIO l.US_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year81 year85 year97 year98 if nomiss1==1, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg DWDIFDIPerGDPNonUSCapOut l.US_Major_Goal l.US_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year81 year85 year97 year98 if nomiss1==1, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		
		xtreg DWDIFDIPerGDPNonUSCapOut lUS_dem6 lUS_N_dem6 ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year81 year85 year97 year98 if nomiss1==1, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6

* Appendix K: Table 3 With Year Dummies: The Effect of U.S. Sanctions and Change in U.S. FDI/GDP on Change in Global FDI/GDP
	* Table 3: Model 1.  Roubustness with French FDI as DV
		xtreg DFrenchFDIPerGDP  lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP    ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		i.year if year<2001 , vce(robust) fe

		xtreg DFrenchFDIPerGDP  lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP    ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year91 year98 year99 year00  , vce(robust) fe

	* Table 3: Model 2: high cost and low cost sanctions with dep var in in differences  
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.USsanCostHD l.USsanCostLD ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year91 year98 year99 year00 , vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD

	*Table 3: Model 3: IO in Sender
		xtreg DFrenchFDIPerGDP  lDUSFDICapOutPerGDP l.US_sanIO l.US_san_N_IO   ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year91 year98 year99 year00, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO

	* Table 3: Model 4: Major Goal
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.US_Major_Goal l.US_N_Major_Goal  ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year91 year98 year99 year00 , vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal

	* Table 3: Model 5: regime type of the target of sanctions
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.US_dem6 l.US_N_dem6    ///
		lFrenchFDIPerGDP AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		year91 year98 year99 year00, vce(robust) fe

		test l.US_dem6 = l.US_N_dem6

/* Appendix L - Table 2 With a Control for the Duration of Sanctions: The Effect of U.S. 
Sanctions and Change in U.S. FDI/GDP on Change in Global FDI/GDP */

	* Model 1:
		xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		l.USsanyrdur1 if nomiss==1,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in differences 
		xtreg DWDIFDIPerGDPNonUSCapOut l.USsanCostHD l.USsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		l.USsanyrdur1 if nomiss1==1, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg DWDIFDIPerGDPNonUSCapOut l.US_sanIO l.US_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		l.USsanyrdur1 if nomiss1==1, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg DWDIFDIPerGDPNonUSCapOut l.US_Major_Goal l.US_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		l.USsanyrdur1 if nomiss1==1, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		xtreg DWDIFDIPerGDPNonUSCapOut lUS_dem6 lUS_N_dem6    ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		l.USsanyrdur1 if nomiss1==1, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6

/* Appendix M - Table 3 With a Control for the Duration of Sanctions: The Effect of U.S. 
Sanctions and Change in U.S. FDI/GDP on Change in French FDI/GDP */
	
	* Table 3: Model 1.  Roubustness with French FDI as DV
		xtreg DFrenchFDIPerGDP  lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP    ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar l.USsanyrdur1, vce(robust) fe

	* Table 3: Model 2: high cost and low cost sanctions with dep var in in differences  
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.USsanCostHD l.USsanCostLD ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar l.USsanyrdur1, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD

	*Table 3: Model 3: IO in Sender
		xtreg DFrenchFDIPerGDP  lDUSFDICapOutPerGDP l.US_sanIO l.US_san_N_IO   ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar l.USsanyrdur1, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO

	* Table 3: Model 4: Major Goal
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.US_Major_Goal l.US_N_Major_Goal  ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar l.USsanyrdur1, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal

	* Table 3: Model 5: regime type of the target of sanctions
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.US_dem6 l.US_N_dem6    ///
		lFrenchFDIPerGDP AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar l.USsanyrdur1, vce(robust) fe

		test l.US_dem6 = l.US_N_dem6
