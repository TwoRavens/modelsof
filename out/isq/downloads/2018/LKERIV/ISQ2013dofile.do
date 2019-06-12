tsset  cc_usaid year
*Table 1
*model 1.1
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust) 
*model 1.2
xtreg lnExports             lnUSAfTL2 lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust) 
*model 1.3
xtreg lnExportstoUSA lnExportstoUSAL1 lnUSAfTL2 lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust) 
*model 1.4
xtreg lnExportstoROW lnExportstoROWL1 lnUSAfTL2 lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust) 

*Table 2
*model 2.1
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDPpc lnUSAfTL2XlnGDPpc lnGDP _Iyear_2000- _Iyear_2008, fe vce (robust) level (90)
*model 2.2
xtreg lnExports lnExportsL1 lnUSAfTL2 lnDistance lnUSAfTL2XlnDistance lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust) level (90)
*model 2.3
xtreg lnExports lnExportsL1 lnUSAfTL2 Landlocked lnUSAfTL2XLandlocked lnGDP _Iyear_2000- _Iyear_2008, fe vce (robust) level (90) 
*model 2.4
xtreg lnExports lnExportsL1 lnUSAfTL2 AfTDemand lnUSAfTL2XAfTDemand lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust) level (90)

*Table 3
*model 3.1
xtreg lnExports lnExportsL1 lnUSAfTpcL2 lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust)
*model 3.2
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP lnUSODAL2 lnNonUSODAL2 lnEnergyProduction PostConflict  _Iyear_2000- _Iyear_2008, fe vce (robust)
*model 3.3
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  _Iyear_2000- _Iyear_2008 if lnUSAfTL2>0, fe vce (robust) 
*1st stage equation for model 3.4
*reg GetUSAfT lnEnergyProduction PostConflict, robust
*predict GetUSAfThat
*gen InverseMillsRatio=normalden(GetUSAfThat)/normal(GetUSAfThat)
*model 3.4
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  InverseMillsRatio _Iyear_2000- _Iyear_2008 if lnUSAfTL2>0, fe vce (robust)
*model 3.5 
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  _Iyear_2000- _Iyear_2008 if lnUSAfTL2<14.53, fe vce (robust)
*model 3.6
reg lnExports   lnExportsL1 lnUSAfTL2 lnGDP  lnGDPpc lnDistance Landlocked Island, robust
*model 3.7
xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  lnGDPpc lnDistance Landlocked Island, re vce (robust)
*Hausman test for model 3.7
*xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  lnGDPpc lnDistance Landlocked Island, fe 
*estimates store fixed
*xtreg lnExports lnExportsL1 lnUSAfTL2 lnGDP  lnGDPpc lnDistance Landlocked Island, re
*hausman fixed . , sigmamore
*model 3.8
xtreg lnExports lnExportsL1 lnUSAfTnolag lnGDP  _Iyear_2000- _Iyear_2008 if lnUSAfTL2~=., fe vce (robust)
*model 3.9
xtreg lnUSAfTnolag lnUSAfTL1 lnExportsL2 lnGDP  _Iyear_2000- _Iyear_2008, fe vce (robust)
*model 3.10
xtabond2 lnExports lnExportsL1 lnUSAfTL2 lnGDP _Iyear_2000- _Iyear_2008, gmm (lnUSAfTL2 lnGDP, lag (2 2)) twostep robust
