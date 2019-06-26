version 11
set more off
clear all

/* ***********
Analyzes the relationship between the Gender variables from Women Stat and international samaritan positions************ 

*/


** Set up. Open up the data file
** Setup:
global p "C:\Users\Aashish\Documents\Research\Alison\FinalAnalysis"
global q "C:\Users\User\Documents\Research\Alison\FinalAnalysis\FinalData"
global r "C:\Users\Aashish\Documents\Research\Alison\FinalAnalysis\FinalTables"

capture log using $p\WomenStatAnalysis", replace

use $q\ReplicationData.dta, clear

** TBD: FINISH OFF TABLE 1
** Table 1.	Summary Statistics
sum  Genociderat WarCrimesrat  CEDAW_Optrat CEDAW_Optrat CATrat  CAT_Protrat  CRC_Prot_1rat  CRC_Prot_2rat  ICCPR_Prot_1rat  ICCPR_Prot_2rat  Disabilitiesrat
sum ICCrat BIArat
sum Iranyes Myanmaryes Nkoreayes EJExecutionsyes DeathPenaltyyes
sum Refugees pkshare odaTogni
sum  Aid  Trade  Investment  Migration  Environment  Security  Technology
sum GEM GEI GII WIP Sex_Ratio
sum GDPPC PopTot Internet TradeGDP pts2007 pts1975 polity2007 polity1948

** See whether PSOW and IFL capture similar things, and clean them.
tab PSOW IFL

sort PSOW Country
list Country PSOW

sort IFL Country
list Country IFL


tab PSOW, gen(PSOW)
drop PSOW4
tab IFL, gen(IFL)
drop IFL5

*************************************************************************************************
******* Now for the Binary outcome variables, go through and test the relationships *************
*************************************************************************************************

** PSOW
quietly foreach var in Genociderat WarCrimesrat CEDAW_Optrat CATrat  CAT_Protrat  CRC_Prot_1rat  CRC_Prot_2rat  ICCPR_Prot_1rat  ICCPR_Prot_2rat  Disabilitiesrat ICCrat BIA {
	matrix temp = J(1,6,.)
	matrix rownames temp =`var'
	probit `var' PSOW1 PSOW2 PSOW3 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,3] = _b[PSOW1]
		matrix temp[1,4] = _b[PSOW2]
		matrix temp[1,5] = _b[PSOW3]
		matrix temp[1,6] = e(N)
		test PSOW1 PSOW2 PSOW3
			matrix temp[1,1]= r(drop)
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value PSOW1 PSOW2 PSOW3
matlist Results
matrix drop Results

** PSOW: For those that had complete determination, add PSOW1 and PSOW2
gen PSOW12 = PSOW1+PSOW2
quietly foreach var in WarCrimesrat CEDAW_Optrat CATrat CRC_Prot_1rat  CRC_Prot_2rat  ICCrat {
	matrix temp = J(1,6,.)
	matrix rownames temp =`var'
	probit `var' PSOW12 PSOW3 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,4] = _b[PSOW12]
		matrix temp[1,5] = _b[PSOW3]
		matrix temp[1,6] = e(N)
		test PSOW12 PSOW3
			matrix temp[1,1]= r(drop)
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value PSOW1 PSOW2 PSOW3
matlist Results
matrix drop Results

** IFL
quietly foreach var in Genociderat WarCrimesrat  CEDAW_Optrat  CATrat  CAT_Protrat  CRC_Prot_1rat  CRC_Prot_2rat  ICCPR_Prot_1rat  ICCPR_Prot_2rat  Disabilitiesrat ICCrat BIA {
	matrix temp = J(1,7,.)
	matrix rownames temp =`var'
	probit `var' IFL1 IFL2 IFL3 IFL4 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,3] = _b[IFL1]
		matrix temp[1,4] = _b[IFL2]
		matrix temp[1,5] = _b[IFL3]
		matrix temp[1,6] = _b[IFL4]
		matrix temp[1,7] = e(N)
		test IFL1 IFL2 IFL3 IFL4
			matrix temp[1,1]= r(drop)
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value IFL1 IFL2 IFL3 IFL4 N

matlist Results
matrix drop Results

** IFL: For those that had complete determination, add IFL1 and IFL2
gen IFL12 = IFL1+IFL2

quietly foreach var in CATrat  CRC_Prot_1rat  ICCPR_Prot_1rat  ICCPR_Prot_2rat ICCrat BIA {
	matrix temp = J(1,7,.)
	matrix rownames temp =`var'
	probit `var' IFL12 IFL3 IFL4 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,4] = _b[IFL12]
		matrix temp[1,5] = _b[IFL3]
		matrix temp[1,6] = _b[IFL4]
		matrix temp[1,7] = e(N)
		test IFL12 IFL3 IFL4
			matrix temp[1,1]= r(drop)
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value IFL1 IFL2 IFL3 IFL4 N

matlist Results
matrix drop Results


*************************************************************************************************
******* Now for the ordinal outcome variables, go through and test the relationships ************
*************************************************************************************************

***************** PSOW: Check which are completely determined, and then check the others ********
foreach var in ICC  ICCplus Iran Myanmar Nkorea EJExecutions DeathPenalty AntiLGBT ProLGBT ICCPR3Comm ICESRAmmend {
	tab `var' PSOW, col nof
}

** For those without complete determination, run the regression as is
quietly foreach var in Iran Nkorea AntiLGBT ICCPR3Comm ICESRAmmend {
	noisily tab `var' PSOW
	matrix temp = J(1,6,.)
	matrix rownames temp =`var'
	oprobit `var' PSOW1 PSOW2 PSOW3 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,1]= e(N_cd)
		matrix temp[1,3] = _b[PSOW1]
		matrix temp[1,4] = _b[PSOW2]
		matrix temp[1,5] = _b[PSOW3]
		matrix temp[1,6] = e(N)
		test PSOW1 PSOW2 PSOW3
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value PSOW1 PSOW2 PSOW3
matlist Results

** For those with complete determination, add PSOW1 and PSOW2
quietly foreach var in ICC ICCplus Myanmar EJExecutions DeathPenalty ProLGBT {	
	noisily tab `var' PSOW
	matrix temp = J(1,6,.)
	matrix rownames temp =`var'
	oprobit `var' PSOW12 PSOW3 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,1]= e(N_cd)
		matrix temp[1,4] = _b[PSOW12]
		matrix temp[1,5] = _b[PSOW3]
		matrix temp[1,6] = e(N)
		test PSOW12 PSOW3
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value PSOW1 PSOW2 PSOW3 N
matlist Results
matrix drop Results

***************** IFL: Check which are completely determined, and then check the others ********
foreach var in ICC  ICCplus Iran Myanmar Nkorea EJExecutions DeathPenalty AntiLGBT ProLGBT ICCPR3Comm ICESRAmmend {
	tab `var' IFL, col nof
}
** Note: Being in the top IFL category predicts perfect performance in all but one case (Death Penalty). Therefore, 
** we will simply combine the first and second category.
quietly foreach var in ICC  ICCplus Iran Myanmar Nkorea EJExecutions DeathPenalty AntiLGBT ProLGBT ICCPR3Comm ICESRAmmend {	
	matrix temp = J(1,6,.)
	matrix rownames temp =`var'
	oprobit `var' IFL12 IFL3 IFL4 GDPPC resource PopTot kof TradeGDP polity2000
		matrix temp[1,1]= e(N_cd)
		matrix temp[1,3] = _b[IFL12]
		matrix temp[1,4] = _b[IFL3]
		matrix temp[1,5] = _b[IFL4]
		matrix temp[1,6] = e(N)
		test IFL12 IFL3 IFL4
			matrix temp[1,2] = r(p)
	matrix Results = nullmat(Results)\temp
}

matrix colnames Results = PerfPred P-value IFL12 IFL3 IFL4 N
matlist Results
matrix drop Results

*************************************************************************************************
********************************* Now for UNFP Contributions ************************************
*************************************************************************************************
** UNPF contributions
replace UNFP_Pledge = 0 if UNFP_Pledge==.
sum UNFP_Pledge GDPPC PopTot

**gen UNFPgdp = 100*(UNFP_Pledge/(1000*GDPPC))/PopTot
replace UNFPgdp=UNFPgdp*1000
sum UNFPgdp, det

tobit UNFPgdp PSOW1 PSOW2 PSOW3 GDPPC resource PopTot kof TradeGDP polity2000, ll(0)
	test PSOW1 PSOW2 PSOW3

tobit UNFPgdp IFL1 IFL2 IFL3 IFL4 GDPPC resource PopTot kof TradeGDP polity2000, ll(0)
	test IFL1 IFL2 IFL3 IFL4

log close


