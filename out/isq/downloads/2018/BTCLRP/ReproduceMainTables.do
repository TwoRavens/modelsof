/* Do file for "Investment, Opportunity, and Risk: Do U.S. Sanctions 
Deter or Encourage Global Investment?" by Dave Lektzian and Glen Biglaiser.
The commands in this do file reproduce the information in the main tables, figure 1, 
and the diagnostics mentioned in fn.21 */

* Table 1: Summary Statistics
	* FDI Variables
		sum WDIFDIPerGDPNonUSCapOut USFDICapOutPerGDP FrenchFDIPerGDP   ///
			if nomiss==1 & sanUSSen==1

		sum WDIFDIPerGDPNonUSCapOut USFDICapOutPerGDP FrenchFDIPerGDP   ///
			if year<2001 & nomiss==1 & sanUSSen==0

		sum WDIFDIPerGDPNonUSCapOut USFDICapOutPerGDP FrenchFDIPerGDP   ///
			if nomiss==1 

	*Sanctions Characteristics Variables
		sum sanUSSen USsanCostHD USsanCostLD US_Major_Goal US_N_Major_Goal ///
			US_sanIO US_san_N_IO US_dem6 US_N_dem6 ///
			if nomiss==1
		
	* Control Variables
		sum	Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
			GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
			ResourceCurse DevelopedDummy ///
			if nomiss==1

* Table 2: The Effect of US Sanctions and Change in US FDI/GDP on Change in Global FDI/GDP
	* Model 1
		xtreg DWDIFDIPerGDPNonUSCapOut lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1,  vce(robust) fe

	* Model 2: high cost and low cost sanctions with dep var in in differences 
		xtreg DWDIFDIPerGDPNonUSCapOut  l.USsanCostHD l.USsanCostLD ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD
			
	* Model 3: IO in Sender
		xtreg DWDIFDIPerGDPNonUSCapOut l.US_sanIO l.US_san_N_IO   ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO
			
	* Model 4: Major Goal
		xtreg DWDIFDIPerGDPNonUSCapOut l.US_Major_Goal l.US_N_Major_Goal  ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal
			
	* Model 5: regime type of the target of sanctions
		
		xtreg DWDIFDIPerGDPNonUSCapOut lUS_dem6 lUS_N_dem6    ///
		lDUSFDICapOutPerGDP lDWDIFDIPerGDPNonUSCapOut AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss1==1, vce(robust) fe

		test lUS_dem6 = lUS_N_dem6
		
* Table 3: The Effect of US Sanctions and Change in US FDI/GDP on Change in French FDI/GDP
	* Table 3: Model 1.  Roubustness with French FDI as DV
		xtreg DFrenchFDIPerGDP  lC_DUSFDICapOutPerGDP lsanUSSen lSanC_DUSFDICapOutPerGDP    ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar, vce(robust) fe

	* Table 3: Model 2: high cost and low cost sanctions with dep var in in differences  
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.USsanCostHD l.USsanCostLD ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar, vce(robust) fe

		test l.USsanCostHD = l.USsanCostLD

	*Table 3: Model 3: IO in Sender
		xtreg DFrenchFDIPerGDP  lDUSFDICapOutPerGDP l.US_sanIO l.US_san_N_IO   ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar, vce(robust) fe

		test l.US_sanIO = l.US_san_N_IO

	* Table 3: Model 4: Major Goal
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.US_Major_Goal l.US_N_Major_Goal  ///
		lFrenchFDIPerGDP Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar, vce(robust) fe

		test l.US_Major_Goal = l.US_N_Major_Goal

	* Table 3: Model 5: regime type of the target of sanctions
		xtreg DFrenchFDIPerGDP lDUSFDICapOutPerGDP l.US_dem6 l.US_N_dem6    ///
		lFrenchFDIPerGDP AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar, vce(robust) fe

		test l.US_dem6 = l.US_N_dem6
		
* Figure 1: Marginal Effect of Sanctions on Change in Global FDI/GDP at Differing Levels of Change in US FDI/GDP
	capture drop MV conb conse a upper lower

	* Model
		xtreg DWDIFDIPerGDPNonUSCapOut lsanUSSen lDUSFDICapOutPerGDP  lDSanFDIOutPerGDP ///
		lDWDIFDIPerGDPNonUSCapOut Polity4 AGEHINST6CLASSDurCheib DevelopLogGDPCap ///
		GDPGrowthAnnualPer openc ChinnItoCapOen ongouofmid CivWar ///
		if nomiss==1, vce(robust) fe

	generate MV=(_n-1)-1 if _n<4

	matrix b=e(b) 
	matrix V=e(V)
	 
	scalar b1=b[1,1] 
	scalar b2=b[1,2]
	scalar b3=b[1,3]


	scalar varb1=V[1,1] 
	scalar varb2=V[2,2] 
	scalar varb3=V[3,3]

	scalar covb1b3=V[1,3] 
	scalar covb2b3=V[2,3]

	scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

	gen conb=b1+b3*MV if _n<6

	gen conse=sqrt(varb1+(2*covb1b3*MV)+varb3*(MV^2)) if _n<6 

	gen a=1.9*conse
	 
	gen upper=conb+a
	 
	gen lower=conb-a

	graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ///
			||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
			||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ///
			||   ,   ///
				 xlabel(-1 -.75 -.5 -.25 0 .25 .5 .75 1,labsize(2.5)) ///
				 ylabel(-4.0 -2.0 0 2 4 6,   labsize(2.5)) ///
				 yscale(noline) ///
				 xscale(noline) /// 
				 legend(col(1) order(1 2) label(1 "Marginal Effect of Sanctions")size(3) ///
										  label(2 "95% Confidence Interval") /// 
										  label(3 " ")) ///
				 yline(0, lcolor(black)) ///  
				 xtitle( Change in USFDI as percent of GDP, size(3)  ) ///
				 xsca(titlegap(2)) /// 
				 ysca(titlegap(2)) ///
				 ytitle("Marginal Effect of Sanctions on Change in Global FDI/GDP", size(2.75)) ///
				 scheme(s2mono) graphregion(fcolor(white))
				 
	capture drop MV conb conse a upper lower

	****************
* (fn. 21) - Diagnostics for fe and re
	xtreg WDIGDPCurUSD lsanUSSen l.WDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  fe
	
	estimates store fixed

	xtreg WDIGDPCurUSD lsanUSSen l.WDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  re

	hausman fixed ., sigmamore
	xttest0

*****************
	xtreg logWDIGDPCurUSD lsanUSSen l.logWDIGDPCurUSD ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  fe
	
	estimates store fixed

	xtreg logWDIGDPCurUSD lsanUSSen l.logWDIGDPCurUSD ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  re
	
	hausman fixed ., sigmamore
	xttest0

*******************************
	xtreg DWDIGDPCurUSD lsanUSSen l.DWDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  fe
	
	estimates store fixed

	xtreg DWDIGDPCurUSD lsanUSSen l.DWDIGDPCurUSD  ///
	Polity4 AGEHINST6CLASSDurCheib openc ChinnItoCapOen ongouofmid CivWar ///
	if nomiss==1,  re
	hausman fixed ., sigmamore
	xttest0

***************************
* XTSerial Tests on the dependendent variable
	xtserial WDIFDIPerGDPNonUSCapOut if nomiss==1

	xtserial DWDIFDIPerGDPNonUSCapOut if nomiss==1

	xtserial FrenchFDIPerGDP if nomiss==1

	xtserial DFrenchFDIPerGDP if nomiss==1
