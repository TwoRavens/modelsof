*do file for “Printing and Protestants: an empirical test of the role of printing in the Reformation” Review of Economics and Statistics (2014), 96(2): 270-286
*Jared Rubin


clear all

*-------------------------------------------------------------------------------------------------------------------------
use "Printing_ReStat.dta"
*-------------------------------------------------------------------------------------------------------------------------

** Conditions for all regressions - do not include Mainz, Wittenberg, or Zurich

local conditions "city != "Mainz" & city != "Wittenberg" & city != "Zürich""


** Region dummies

local country1500dum "scotdum engdum iredum denmarkdum findum swededum nordum frandum prusdum italiandum italianhre poldum portdum espdum belghredum nethdum"
local hrecircdummies "electorate upperrhencirc lowersaxoncirc swabiancirc franccirc westphalcirc bavariancirc bohemiancirc austriancirc"
local hrecircdummies2 "electorate upperrhencirc lowersaxoncirc swabiancirc franccirc westphalcirc bavariancirc switzdum"


** Control variables

local citysize "logpop1500 i.indepcity" 
local demandcity "i.univ1450 i.bishop i.laymag"
local supplycity "marketpot1500 i.water i.hanseatic logdistwitt logdistzurich"
local citygeog "`hrecircdummies' `country1500dum'"
local cityvar "`citysize' `demandcity' `supplycity' `citygeog'"


** Control variables

local citysizeiv "logpop1500 indepcity" 
local demandcityiv "univ1450 bishop laymag"
local supplycityiv "marketpot1500 water hanseatic logdistwitt logdistzurich"
local citygeogiv "`hrecircdummies' `country1500dum'"
local cityvariv "`citysizeiv' `demandcityiv' `supplycityiv' `citygeogiv'"

local citygeog2 "`hrecircdummies2' `country1500dum'"
local cityvar2 "`citysize' `demandcity' `supplycity' `citygeog2'"

local varlists "prot1530 prot1560 prot1600 press `citysizeiv' `demandcityiv' `supplycityiv' logdistmainz"


** Conditions on dummies by specification

local dummyconditionsall "denmarkdum == 0 & findum == 0 & prusdum == 0 & italiandum == 0 & nordum == 0 & poldum == 0 & portdum == 0 & espdum == 0 & swededum == 0 & engdum == 0 & italianhre == 0 & iredum == 0 & nethdum == 0"
local dummyconditions_1530 "scotdum == 0 & frandum == 0 & belghredum == 0 & bavariancirc == 0 & austriancirc == 0"
local dummyconditions_1560 "1==1"
local dummyconditions_1600 "belghredum == 0"


** Marginal effects for dummy variables

local dummymargin "electorate = 1 upperrhencirc = 0 lowersaxoncirc = 0 swabiancirc = 0 franccirc = 0 westphalcirc = 0 bavariancirc = 0 bohemiancirc = 0 belghredum = 0 nethdum = 0 austriancirc = 0 engdum = 0 scotdum = 0 denmarkdum = 0 findum = 0 frandum = 0 prusdum = 0 iredum = 0 italiandum = 0 italianhre = 0 nordum = 0 poldum = 0 portdum = 0 espdum = 0 swededum = 0"
local dummymarginA "electorate = 1 upperrhencirc = 0 lowersaxoncirc = 0 swabiancirc = 0 franccirc = 0 westphalcirc = 0 bavariancirc = 0 switzdum = 0 belghredum = 0 nethdum = 0 engdum = 0 scotdum = 0 denmarkdum = 0 findum = 0 frandum = 0 prusdum = 0 iredum = 0 italiandum = 0 italianhre = 0 nordum = 0 poldum = 0 portdum = 0 espdum = 0 swededum = 0"


*-------------------------------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------------------------------

** PRIMARY TABLES

** Table 5: Test for exogeneity of instrument

reg press `citysizeiv' `demandcityiv' `supplycityiv' `citygeogiv'  logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg indepcity logpop1500 `demandcityiv' `supplycityiv' `citygeogiv'  logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg bishop logpop1500 indepcity univ1450  `supplycityiv' `citygeogiv' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg water `citysizeiv' `demandcityiv' marketpot1500 hanseatic logdistwitt logdistzurich `citygeogiv' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg hanseatic `citysizeiv' `demandcityiv' marketpot1500 water logdistwitt logdistzurich `citygeogiv' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg logdistwitt `citysizeiv' `demandcityiv' marketpot1500 water hanseatic logdistzurich `citygeogiv' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg logcitygrowth16 indepcity `demandcityiv' `supplycityiv' `citygeogiv' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)
reg logcitygrowth15 indepcity `demandcityiv' water hanseatic logdistwitt logdistzurich `citygeogiv' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_1560', robust cluster(territory)


** Table 6: Probit - press data

foreach y of numlist 1530 1560 1600 {

	reg prot`y' press if `conditions' & pop1500 != ., noconstant robust cluster(territory)
		
	probit prot`y' i.press `citysize' `demandcity' if `conditions', robust cluster(territory)
	estpost margins, dydx(*)
		
	probit prot`y' i.press `citysize' `demandcity' `supplycity' `coords' if `conditions', robust cluster(territory)
	estpost margins, dydx(*)
	
	probit prot`y' i.press `citysize' `demandcity' `supplycity' `citygeog' if `conditions' & city != "Mainz", robust cluster(territory)
	estpost margins, force dydx(*) at (`dummymargin')
	
}

	
** Table 7: IVProbit - Distance to Mainz as 'instrument'

local cityvarnofixed "`citysize' `demandcity' `supplycity' `coords'"
local cityvarnofixediv "`citysizeiv' `demandcityiv' `supplycityiv' `coordsiv'"

foreach y of numlist 1530 1560 1600 {

	reg press `cityvar' logdistmainz if `conditions' & `dummyconditionsall' & `dummyconditions_`y'', robust cluster(territory)
		
	ivprobit prot`y' `cityvar' (press = logdistmainz) if `conditions', first robust cluster(territory)
	estpost margins, dydx(*) predict(p) at (`dummymargin')
	
}


**---------------------------------------------------------------------------------------
**---------------------------------------------------------------------------------------

** APPENDIX

** Table A2: 2SLS

foreach y of numlist 1530 1560 1600 {
	
	reg press `cityvariv' logdistmainz if `conditions', robust cluster(territory)
	
	ivreg2 prot`y' `cityvariv' (press = logdistmainz) if `conditions', robust cluster(territory) first ffirst savefirst
		
}
	

** Table A3: Bivariate probit - Distance to Mainz as 'instrument'

foreach y of numlist 1530 1560 {

	biprobit (prot`y' i.press `cityvar') (press `cityvar' logdistmainz) if `conditions', robust cluster(territory)
	estpost margins, dydx(*) predict(pmarg1) at (`dummymargin') force
	
	biprobit (prot`y' i.press `cityvar') (press `cityvar' logdistmainz) if `conditions', robust cluster(territory)
	estpost margins, dydx(*) predict(pmarg2) at (`dummymargin') force
	
}


** Note: in order to achieve convergence, I combine the Bohemian and Austrian Imperial Circles

foreach y of numlist 1600 {

	biprobit (prot`y' i.press `cityvar2') (press `cityvar2' logdistmainz) if `conditions', robust cluster(territory)
	estpost margins, dydx(*) predict(pmarg1) at (`dummymarginA') force
	
	biprobit (prot`y' i.press `cityvar2') (press `cityvar2' logdistmainz) if `conditions', robust cluster(territory)
	estpost margins, dydx(*) predict(pmarg2) at (`dummymarginA') force
	
}
