version 11
set more off
clear all

/* ***********
Here we will add the correction for resource rents as a share of GDP, and the KOF variable.
*/


** Set up. Open up the data file
** Setup:
global p "C:\Users\User\Documents\Research\Alison\JPR Submission\R&R2\ResourceIntensity"
global q "C:\Users\User\Documents\Research\Alison\FinalAnalysis\FinalData"
global r "C:\Users\User\Documents\Research\Alison\FinalAnalysis\FinalTables"

capture log using "$p\WithKOF.log", replace


** Add the natural resource intensity variable
cd "$p"
use resourcerents.dta, clear
	codebook 
	destring year, replace
	table year, c(N resourcegdp)
	keep if year>=1995 & year<=2007
	egen NumObs = count(resourcegdp), by(country_code)
		sum NumObs
		tab NumObs
	** 	browse if NumObs==0
		drop if NumObs==0
	codebook country_name
	collapse (mean) resourcegdp NumObs, by(country_name country_code)
		sum resourcegdp, det
		sort resourcegdp
	**	browse country_name resourcegdp
	keep country_name resourcegdp
	tab country_name
	sort country_name
save temp.dta, replace

use wbcodesuncodes, clear
	codebook
	sort country_name
	keep if country_name~=""
	merge 1:1 country_name using temp.dta
		replace Country = country_name if _merge~=3
		codebook Country country_name
		count if Country == country_name
		count if Country ~= country_name		
		drop _merge country_name
sort Country
save temp.dta, replace

** Open up the regular dataset and merge
use $q\FinalData.dta, clear
replace GII = 0.7 if Country=="Zimbabwe"

sort Country

merge 1:1 Country using temp.dta
*	browse Country if _merge==1
*	browse Country if _merge==2
	drop if _merge==2 /*This gets rid of countries in the WB set that are not UN countries */
	drop _merge
sort Country
save temp.dta, replace	

** Now add the KOF variable
use kof_data_stataready.dta, clear
	codebook
	sum
	table year, c(N kof)
	keep if year>=1995 & year<=2007
	egen NumObs = count(kof), by(country)
		sum NumObs
		tab NumObs
		drop if NumObs==0
	collapse (mean) kof, by(country)
rename country country_kof
sort country_kof
merge 1:1 country_kof using kofcountrycodes.dta
	replace country = country_kof if _merge==1
	rename country Country
	drop country_kof _merge
sort Country

merge 1:1 Country using temp.dta
*	browse Country if _merge==1
*	browse Country if _merge==2
	drop if _merge==1
	drop _merge

*************************************************

** Table 1.	Summary Statistics
sum  Genociderat WarCrimesrat  CEDAWrat CEDAW_Optrat CATrat  CAT_Protrat  CRC_Prot_1rat  CRC_Prot_2rat  ICCPR_Prot_1rat  ICCPR_Prot_2rat  Disabilitiesrat
sum ICCrat BIArat
sum Iranyes Myanmaryes Nkoreayes EJExecutionsyes DeathPenaltyyes
sum AntiLGBT ProLGBT ICCPR3 ICESRAmmend
sum Refugees pkshare odaTogni
sum  Aid  Trade  Investment  Migration  Environment  Security  Technology
sum GEM GEI GII WIP Sex_Ratio
sum GDPPC PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
destring PSOW IFL, replace
sum PSOW IFL
sum resource kof

** Table Y.	Distribution of treaty ratifiers (including the ICC)
** TBD: INCLUDE CEDAW_Opt in this exercise.

sum  WarCrimesrat CAT_Protrat ICCPR_Prot_2rat Disabilitiesrat CEDAW_Optrat ICCPR_Prot_1rat ICCrat Genociderat CRC_Prot_1rat CATrat CRC_Prot_2rat CEDAWrat 

 


quietly foreach var1 in WarCrimes CAT_Prot ICCPR_Prot_2 Disabilities CEDAW_Opt ICCPR_Prot_1 ICC Genocide CRC_Prot_1 CAT CRC_Prot_2 CEDAW {
	foreach var2 in WarCrimes CAT_Prot ICCPR_Prot_2 Disabilities CEDAW_Opt ICCPR_Prot_1 ICC Genocide CRC_Prot_1 CAT CRC_Prot_2 CEDAW {
			sum `var2'rat if `var1'rat==1 
			matrix temprat = nullmat(temprat),r(mean)
	}
	display "Variable = `var1'
	matlist temprat
	matrix CondProbRat = nullmat(CondProbRat)\temprat
	matrix drop temprat
}

matrix rownames CondProbRat = WarCrimes CAT_Prot ICCPR_Prot_2 Disabilities CEDAW_Opt ICCPR_Prot_1 ICC Genocide CRC_Prot_1 CAT CRC_Prot_2 CEDAW 
matlist CondProbRat, format(%4.3f)
matrix drop CondProbRat


** Table Z.	Distribution of General Assembly vote (with key treaties included).
sum  Genociderat WarCrimesrat ICCrat Iranyes Myanmaryes Nkoreayes EJExecutionsyes DeathPenaltyyes

quietly foreach var1 in WarCrimesrat Iranyes Myanmaryes Nkoreayes DeathPenaltyyes ICCrat EJExecutionsyes Genociderat {
	foreach var2 in WarCrimesrat Iranyes Myanmaryes Nkoreayes DeathPenaltyyes ICCrat EJExecutionsyes Genociderat {
			sum `var2' if `var1'==1 
			matrix temprat = nullmat(temprat),r(mean)
	}
	display "Variable = `var1'
	matlist temprat
	matrix CondProbRat = nullmat(CondProbRat)\temprat
	matrix drop temprat
}

matrix rownames CondProbRat = WarCrimes Iran Myanmar Nkorea DeathPenalty ICC EJExecutions Genocide 
matlist CondProbRat, format(%4.3f)


** Table A1.	Countries ratifying most/least treaties (and votes, but don't include these in the final table)
gen NumTreaties = Genociderat+WarCrimesrat+CEDAWrat+CEDAW_Optrat+CATrat+CAT_Protrat+CRC_Prot_1rat+CRC_Prot_2rat+ICCPR_Prot_1rat+ICCPR_Prot_2rat+Disabilitiesrat+ICCrat
sum NumTreaties Country
bysort NumTreaties: list Country

gen NumVotes = Iranyes + Myanmaryes + Nkoreayes + EJExecutionsyes + DeathPenaltyyes
sum NumVotes
bysort NumVotes: list Country

** Table A2.	Correlations between Global Citizenry measures and between Gender Equity Measures
pwcorr NumTreaties NumVotes pkshare odaTogni Overall Aid  Trade  Investment  Migration  Environment  Security  Technology, obs sig
* Note that treaties are more closely related to commitment to development than to raw supplies of bodies or cash.
pwcorr GEM GEI GII polity1948 polity2007 pts1975 pts2007
* Note the fairly strong relationship between the gender equity measures, and the reasonable relationship between polity and pts
ttest NumTreaties, by(BIA)
gen GBAbinary = GBA
	replace GBAbinary=1 if GBAbinary==2
ttest NumTreaties, by(GBAbinary)

sum Iranyes Myanmaryes Nkoreayes EJExecutionsyes DeathPenaltyyes
sum AntiLGBT ProLGBT ICCPR3 ICESRAmmend

gen AntiLGBTYes = cond(AntiLGBT==-1,1,0,.)
gen ProLGBTYes = cond(ProLGBT==1,1,0,.)
gen ICCPR3CommYes = cond(ICCPR3Comm==-1,1,0,.)
gen ICESRAmmendYes = cond(ICESRAmmend==-1,1,0,.)

gen NumHRVotes = Iranyes+Myanmaryes+Nkoreayes+EJExecutionsyes+DeathPenaltyyes+AntiLGBTYes+ProLGBTYes+ICCPR3CommYes+ICESRAmmendYes

pwcorr NumTreaties NumHRVotes if AntiLGBT~=., obs sig

**********************************************************************************
*** Make the interractions between the polity and GE measures ********************
**********************************************************************************
sum GEM GEI GII WIP Sex_Ratio polity2007 polity1948
bysort polity1948: list Country

** First scale the GE measures
foreach var in GEM GEI GII WIP Sex_Ratio {
	sum `var' if GEI~=. & GII ~=. & WIP~=.
	local mean = r(mean)
		display `mean'
	local variance = r(Var)
		display `variance'
	gen `var'2 = (`var'-`mean')/sqrt(`variance')
	drop `var'
	rename `var'2 `var'
}

sum GEM GEI GII WIP Sex_Ratio polity1948

foreach year in 1948 1966 1968 1979 1984 1989 2000 2002 2007 {
	sum polity`year' if GEI~=. & GII ~=. & WIP~=.
	local mean = r(mean)
		display `mean'
	local variance = r(Var)
		display `variance'
	gen polity`year'2 = (polity`year'-`mean')/sqrt(`variance')
	drop polity`year'
	rename polity`year'2 polity`year'
	foreach var in GEM GEI GII WIP {
		gen `var'Pol`year' = `var'*polity`year'
	}
	gen SexPol`year' = Sex_Ratio*polity`year'
}

replace PopTot = PopTot/1000000	

** Table X.	Probits of treaty ratification.  Plus ordered probit of total number of treaties.

**WarCrimes CAT_Prot ICCPR_Prot_2 Disabilities ICCPR_Prot_1  ICC Genocide CRC_Prot_1 CAT CRC_Prot_2 CEDAW {

** Genocide
dprobit Genociderat GEM GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948 GEMPol1948
	outreg2 using Table4.out, bdec(3) excel replace sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Genocide) eqdrop(cut1 cut2) nocons
dprobit Genociderat GEI GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948 GEIPol1948
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Genocide) eqdrop(cut1 cut2) nocons
dprobit Genociderat GII GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948 GIIPol1948
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Genocide) eqdrop(cut1 cut2) nocons
dprobit Genociderat WIP GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948 WIPPol1948
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Genocide) eqdrop(cut1 cut2) nocons
dprobit Genociderat Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948 SexPol1948
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Genocide) eqdrop(cut1 cut2) nocons

** War Crimes
dprobit WarCrimesrat GEM GEMPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1968 GEI GEIPol1968 GII GIIPol1968 WIP WIPPol1968 WIPPol1968 Sex_Ratio SexPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968) stats(coef) alpha(0.05, 0.01) ctitle(WarCrimes) eqdrop(cut1 cut2) nocons
dprobit WarCrimesrat GEI GEIPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1968 GEI GEIPol1968 GII GIIPol1968 WIP WIPPol1968 WIPPol1968 Sex_Ratio SexPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968) stats(coef) alpha(0.05, 0.01) ctitle(WarCrimes) eqdrop(cut1 cut2) nocons
dprobit WarCrimesrat GII GIIPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1968 GEI GEIPol1968 GII GIIPol1968 WIP WIPPol1968 WIPPol1968 Sex_Ratio SexPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968) stats(coef) alpha(0.05, 0.01) ctitle(WarCrimes) eqdrop(cut1 cut2) nocons
dprobit WarCrimesrat WIP WIPPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1968 GEI GEIPol1968 GII GIIPol1968 WIP WIPPol1968 WIPPol1968 Sex_Ratio SexPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968) stats(coef) alpha(0.05, 0.01) ctitle(WarCrimes) eqdrop(cut1 cut2) nocons
dprobit WarCrimesrat Sex_Ratio SexPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1968 GEI GEIPol1968 GII GIIPol1968 WIP WIPPol1968 WIPPol1968 Sex_Ratio SexPol1968 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968) stats(coef) alpha(0.05, 0.01) ctitle(WarCrimes) eqdrop(cut1 cut2) nocons

	
** CAT
dprobit CATrat GEM GEMPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1984 GEI GEIPol1984 GII GIIPol1984 WIP WIPPol1984 WIPPol1984 Sex_Ratio SexPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984) stats(coef) alpha(0.05, 0.01) ctitle(CAT) eqdrop(cut1 cut2) nocons
dprobit CATrat GEI GEIPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1984 GEI GEIPol1984 GII GIIPol1984 WIP WIPPol1984 WIPPol1984 Sex_Ratio SexPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984) stats(coef) alpha(0.05, 0.01) ctitle(CAT) eqdrop(cut1 cut2) nocons
dprobit CATrat GII GIIPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1984 GEI GEIPol1984 GII GIIPol1984 WIP WIPPol1984 WIPPol1984 Sex_Ratio SexPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984) stats(coef) alpha(0.05, 0.01) ctitle(CAT) eqdrop(cut1 cut2) nocons
dprobit CATrat WIP WIPPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1984 GEI GEIPol1984 GII GIIPol1984 WIP WIPPol1984 WIPPol1984 Sex_Ratio SexPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984) stats(coef) alpha(0.05, 0.01) ctitle(CAT) eqdrop(cut1 cut2) nocons
dprobit CATrat Sex_Ratio SexPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1984 GEI GEIPol1984 GII GIIPol1984 WIP WIPPol1984 WIPPol1984 Sex_Ratio SexPol1984 GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984) stats(coef) alpha(0.05, 0.01) ctitle(CAT) eqdrop(cut1 cut2) nocons

** CAT_Prot
dprobit CAT_Protrat GEM GEMPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(CAT_Prot) eqdrop(cut1 cut2) nocons
dprobit CAT_Protrat GEI GEIPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(CAT_Prot) eqdrop(cut1 cut2) nocons
dprobit CAT_Protrat GII GIIPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(CAT_Prot) eqdrop(cut1 cut2) nocons
dprobit CAT_Protrat WIP WIPPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(CAT_Prot) eqdrop(cut1 cut2) nocons
dprobit CAT_Protrat Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(CAT_Prot) eqdrop(cut1 cut2) nocons

** ICCPR_Prot_1
dprobit ICCPR_Prot_1rat GEM GEMPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1966 GEI GEIPol1966 GII GIIPol1966 WIP WIPPol1966 WIPPol1966 Sex_Ratio SexPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_1) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_1rat GEI GEIPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1966 GEI GEIPol1966 GII GIIPol1966 WIP WIPPol1966 WIPPol1966 Sex_Ratio SexPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_1) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_1rat GII GIIPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1966 GEI GEIPol1966 GII GIIPol1966 WIP WIPPol1966 WIPPol1966 Sex_Ratio SexPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_1) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_1rat WIP WIPPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1966 GEI GEIPol1966 GII GIIPol1966 WIP WIPPol1966 WIPPol1966 Sex_Ratio SexPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_1) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_1rat Sex_Ratio SexPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1966 GEI GEIPol1966 GII GIIPol1966 WIP WIPPol1966 WIPPol1966 Sex_Ratio SexPol1966 GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_1) eqdrop(cut1 cut2) nocons

** ICCPR_Prot_2
dprobit ICCPR_Prot_2rat GEM GEMPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1989 GEI GEIPol1989 GII GIIPol1989 WIP WIPPol1989 WIPPol1989 Sex_Ratio SexPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_2) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_2rat GEI GEIPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1989 GEI GEIPol1989 GII GIIPol1989 WIP WIPPol1989 WIPPol1989 Sex_Ratio SexPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_2) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_2rat GII GIIPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1989 GEI GEIPol1989 GII GIIPol1989 WIP WIPPol1989 WIPPol1989 Sex_Ratio SexPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_2) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_2rat WIP WIPPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1989 GEI GEIPol1989 GII GIIPol1989 WIP WIPPol1989 WIPPol1989 Sex_Ratio SexPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_2) eqdrop(cut1 cut2) nocons
dprobit ICCPR_Prot_2rat Sex_Ratio SexPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol1989 GEI GEIPol1989 GII GIIPol1989 WIP WIPPol1989 WIPPol1989 Sex_Ratio SexPol1989 GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR_Prot_2) eqdrop(cut1 cut2) nocons
	
** CRC_Prot_1
dprobit CRC_Prot_1rat GEM GEMPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_1) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_1rat GEI GEIPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_1) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_1rat GII GIIPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_1) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_1rat WIP WIPPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_1) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_1rat Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_1) eqdrop(cut1 cut2) nocons
	
** CRC_Prot_2
dprobit CRC_Prot_2rat GEM GEMPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_2) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_2rat GEI GEIPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_2) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_2rat GII GIIPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_2) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_2rat WIP WIPPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_2) eqdrop(cut1 cut2) nocons
dprobit CRC_Prot_2rat Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CRC_Prot_2) eqdrop(cut1 cut2) nocons
	

** Disabilities
dprobit Disabilitiesrat GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Disabilities) eqdrop(cut1 cut2) nocons
dprobit Disabilitiesrat GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Disabilities) eqdrop(cut1 cut2) nocons
dprobit Disabilitiesrat GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Disabilities) eqdrop(cut1 cut2) nocons
dprobit Disabilitiesrat WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Disabilities) eqdrop(cut1 cut2) nocons
dprobit Disabilitiesrat Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Disabilities) eqdrop(cut1 cut2) nocons

** CEDAW_Opt
dprobit CEDAW_Optrat GEM GEMPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CEDAW_Opt) eqdrop(cut1 cut2) nocons
dprobit CEDAW_Optrat GEI GEIPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CEDAW_Opt) eqdrop(cut1 cut2) nocons
dprobit CEDAW_Optrat GII GIIPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CEDAW_Opt) eqdrop(cut1 cut2) nocons
dprobit CEDAW_Optrat WIP WIPPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CEDAW_Opt) eqdrop(cut1 cut2) nocons
dprobit CEDAW_Optrat Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2000 GEI GEIPol2000 GII GIIPol2000 WIP WIPPol2000 WIPPol2000 Sex_Ratio SexPol2000 GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000) stats(coef) alpha(0.05, 0.01) ctitle(CEDAW_Opt) eqdrop(cut1 cut2) nocons

/* Number of treaties ratified
oprobit NumTreaties GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NumTreaties) eqdrop(cut1 cut2) nocons
oprobit NumTreaties GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NumTreaties) eqdrop(cut1 cut2) nocons
oprobit NumTreaties GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NumTreaties) eqdrop(cut1 cut2) nocons
oprobit NumTreaties WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NumTreaties) eqdrop(cut1 cut2) nocons
oprobit NumTreaties Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table4.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NumTreaties) eqdrop(cut1 cut2) nocons

poisson NumTreaties GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
poisson NumTreaties GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
*/
	
** Table 5.	Ordered probits of ICC, BIA and ICC-plus.
oprobit ICC GEM GEMPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel replace sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICC) eqdrop(cut1 cut2) nocons
oprobit ICC GEI GEIPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICC) eqdrop(cut1 cut2) nocons
oprobit ICC GII GIIPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICC) eqdrop(cut1 cut2) nocons
oprobit ICC WIP WIPPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICC) eqdrop(cut1 cut2) nocons
oprobit ICC Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICC) eqdrop(cut1 cut2) nocons

replace BIA = 1 - BIA
dprobit BIA GEM GEMPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(BIA) eqdrop(cut1 cut2) nocons
dprobit BIA GEI GEIPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(BIA) eqdrop(cut1 cut2) nocons
dprobit BIA GII GIIPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(BIA) eqdrop(cut1 cut2) nocons
dprobit BIA WIP WIPPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(BIA) eqdrop(cut1 cut2) nocons
dprobit BIA Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(BIA) eqdrop(cut1 cut2) nocons

oprobit ICCplus GEM GEMPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICCplus) eqdrop(cut1 cut2) nocons
oprobit ICCplus GEI GEIPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICCplus) eqdrop(cut1 cut2) nocons
oprobit ICCplus GII GIIPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICCplus) eqdrop(cut1 cut2) nocons
oprobit ICCplus WIP WIPPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICCplus) eqdrop(cut1 cut2) nocons
oprobit ICCplus Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002
	mfx compute, predict(outcome(#3))
	outreg2 using Table5.out, bdec(3) excel append sortvar(GEM GEMPol2002 GEI GEIPol2002 GII GIIPol2002 WIP WIPPol2002 WIPPol2002 Sex_Ratio SexPol2002 GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002) stats(coef) alpha(0.05, 0.01) ctitle(ICCplus) eqdrop(cut1 cut2) nocons


** Table 6.	Ordered probits of GA resolutions.  Plus ordered probit of total number of yes votes.
oprobit Iran GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel replace sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Iran) eqdrop(cut1 cut2) nocons
oprobit Iran GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Iran) eqdrop(cut1 cut2) nocons
oprobit Iran GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Iran) eqdrop(cut1 cut2) nocons
oprobit Iran WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Iran) eqdrop(cut1 cut2) nocons
oprobit Iran Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Iran) eqdrop(cut1 cut2) nocons

oprobit Myanmar GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Myanmar) eqdrop(cut1 cut2) nocons
oprobit Myanmar GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Myanmar) eqdrop(cut1 cut2) nocons
oprobit Myanmar GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Myanmar) eqdrop(cut1 cut2) nocons
oprobit Myanmar WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Myanmar) eqdrop(cut1 cut2) nocons
oprobit Myanmar Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Myanmar) eqdrop(cut1 cut2) nocons

oprobit Nkorea GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Nkorea) eqdrop(cut1 cut2) nocons
oprobit Nkorea GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Nkorea) eqdrop(cut1 cut2) nocons
oprobit Nkorea GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Nkorea) eqdrop(cut1 cut2) nocons
oprobit Nkorea WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Nkorea) eqdrop(cut1 cut2) nocons
oprobit Nkorea Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(Nkorea) eqdrop(cut1 cut2) nocons

tab EJExecutions

oprobit EJExecutions GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#2))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(EJExecutions) eqdrop(cut1 cut2) nocons
oprobit EJExecutions GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#2))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(EJExecutions) eqdrop(cut1 cut2) nocons
oprobit EJExecutions GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#2))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(EJExecutions) eqdrop(cut1 cut2) nocons
oprobit EJExecutions WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#2))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(EJExecutions) eqdrop(cut1 cut2) nocons
oprobit EJExecutions Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#2))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(EJExecutions) eqdrop(cut1 cut2) nocons

oprobit DeathPenalty GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(DeathPenalty) eqdrop(cut1 cut2) nocons
oprobit DeathPenalty GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(DeathPenalty) eqdrop(cut1 cut2) nocons
oprobit DeathPenalty GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(DeathPenalty) eqdrop(cut1 cut2) nocons
oprobit DeathPenalty WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(DeathPenalty) eqdrop(cut1 cut2) nocons
oprobit DeathPenalty Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(DeathPenalty) eqdrop(cut1 cut2) nocons

oprobit AntiLGBT GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(AntiLGBT) eqdrop(cut1 cut2) nocons
oprobit AntiLGBT GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(AntiLGBT) eqdrop(cut1 cut2) nocons
oprobit AntiLGBT GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(AntiLGBT) eqdrop(cut1 cut2) nocons
oprobit AntiLGBT WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(AntiLGBT) eqdrop(cut1 cut2) nocons
oprobit AntiLGBT Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(AntiLGBT) eqdrop(cut1 cut2) nocons

oprobit ProLGBT GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ProLGBT) eqdrop(cut1 cut2) nocons
oprobit ProLGBT GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ProLGBT) eqdrop(cut1 cut2) nocons
oprobit ProLGBT GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ProLGBT) eqdrop(cut1 cut2) nocons
oprobit ProLGBT WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ProLGBT) eqdrop(cut1 cut2) nocons
oprobit ProLGBT Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ProLGBT) eqdrop(cut1 cut2) nocons

oprobit ICCPR3Comm GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR3) eqdrop(cut1 cut2) nocons
oprobit ICCPR3Comm GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR3) eqdrop(cut1 cut2) nocons
oprobit ICCPR3Comm GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR3) eqdrop(cut1 cut2) nocons
oprobit ICCPR3Comm WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR3) eqdrop(cut1 cut2) nocons
oprobit ICCPR3Comm Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICCPR3) eqdrop(cut1 cut2) nocons

oprobit ICESRAmmend GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICESRAmmend) eqdrop(cut1 cut2) nocons
oprobit ICESRAmmend GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICESRAmmend) eqdrop(cut1 cut2) nocons
oprobit ICESRAmmend GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICESRAmmend) eqdrop(cut1 cut2) nocons
oprobit ICESRAmmend WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICESRAmmend) eqdrop(cut1 cut2) nocons
oprobit ICESRAmmend Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
	mfx compute, predict(outcome(#3))
	outreg2 using Table6.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948) stats(coef) alpha(0.05, 0.01) ctitle(ICESRAmmend) eqdrop(cut1 cut2) nocons

** Table X. Regression of Peacekeeping and Refugee acceptance.
drop Region
sort Country
save temp.dta, replace

use $q\regions.dta, clear
sort Country
merge 1:1 Country using temp.dta

tab Region, gen(reg)

** Peacekeeping
tobit pkshare GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7a.out, bdec(3) excel replace sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons

tobit pkshare GEM GDPPC resource PopTot, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare GEI GDPPC resource PopTot, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare GII GDPPC resource PopTot, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare WIP WIPPol2007 GDPPC resource PopTot, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit pkshare Sex_Ratio GDPPC resource PopTot, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons

tobit pkshare GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit pkshare GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit pkshare GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit pkshare WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit pkshare Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7a.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons

replace Refugees = Refugees/1000
	
tobit Refugees GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7b.out, bdec(3) excel replace sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit Refugees GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit Refugees GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit Refugees WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons

** Refugee acceptance	
tobit Refugees GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit Refugees GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit Refugees GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons
tobit Refugees WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 reg2-reg7, ll(0)
	outreg2 using Table7b.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(Region) eqdrop(cut1 cut2) nocons

** Gender Based Asylum
oprobit GBA GEM
	mfx compute, predict(outcome(#3))
	outreg2 using Table7c.out, bdec(3) excel replace sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
oprobit GBA GEI 
	mfx compute, predict(outcome(#3))
	outreg2 using Table7c.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
oprobit GBA GII
	mfx compute, predict(outcome(#3))
	outreg2 using Table7c.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
oprobit GBA GEM GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	mfx compute, predict(outcome(#3))
	outreg2 using Table7c.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
oprobit GBA GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	mfx compute, predict(outcome(#3))
	outreg2 using Table7c.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
oprobit GBA GII GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	mfx compute, predict(outcome(#3))
	outreg2 using Table7c.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons


** UNPF contributions
replace UNFP_Pledge = 0 if UNFP_Pledge==.
sum UNFP_Pledge GDPPC resource PopTot

gen GDP = 1000*GDPPC*(1000000*PopTot)
sum UNFP_Pledge GDPPC resource PopTot GDP

gen UNFPgdp = 100*(UNFP_Pledge/GDP)
replace UNFPgdp=UNFPgdp*1000
sum UNFPgdp, det
sum UNFPgdp
list Country UNFPgdp UNFP_Pledge GDPPC resource PopTot

pwcorr NumTreaties UNFPgdp, obs sig

tobit UNFPgdp GEM GEMPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7d.out, bdec(3) excel replace sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEMPol2007 GEI GEIPol2007 GII GIIPol2007 WIP WIPPol2007 WIPPol2007 Sex_Ratio SexPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons

tobit UNFPgdp GEM GDPPC resource PopTot, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp GEI GDPPC resource PopTot, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp GII GDPPC resource PopTot, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp WIP GDPPC resource PopTot, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons
tobit UNFPgdp Sex_Ratio GDPPC resource PopTot, ll(0)
	outreg2 using Table7d.out, bdec(3) excel append sortvar(GEM GEI GII WIP Sex_Ratio GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01) ctitle(NoRegion) eqdrop(cut1 cut2) nocons

	
** Figure 1: ODA/GNI
save $q\temp.dta, replace

keep if odaTogni~=.
replace Code = "CZE" if Country == "Czech Republic"
replace Code = "HUN" if Country == "Hungary"
replace Code = "ISL" if Country == "Iceland"
replace Code = "LUX" if Country == "Luxembourg"
replace Code = "POL" if Country == "Poland"
replace Code = "SVK" if Country == "Slovakia"
replace Code = "TUR" if Country == "Turkey"

#delimit;
** ODA to GNI ratio;
twoway (scatter odaTogni GEI, mlabel(Code)) (lfit odaTogni GEI), 
	title("Figure 1: Gender Equity and the ODA:GNI ratio")
	xtitle(GEI) ytitle(Ratio of ODA to GNI) legend(off)
	note("Note: The dashed line is the line of best fit.")
	saving("odaTogni", replace);
#delimit cr

** Figure 2a-h: CDI vs gender measure.
use $q\temp.dta, clear

keep if Aid~=.

pwcorr GEI GII Aid Trade Investment Migration Environment Security Technology Overall if Overall~=., star(0.05) obs

replace GEI = GEI*100

#delimit;
** Overall;
twoway (scatter Overall GEI, mlabel(Code)) (lfit Overall GEI), 
	title("(a) Overall", position(6))
	xtitle(GEI) ytitle(CDI Overall Index) legend(off)
	saving("Overall", replace);
** Aid;
twoway (scatter Aid GEI, mlabel(Code)) (lfit Aid GEI), 	title("(b) Aid", position(6))
	xtitle(GEI) ytitle(CDI Aid Index) legend(off)
	saving("Aid", replace);
** Trade;
twoway (scatter Trade GEI, mlabel(Code)) (lfit Trade GEI), 
	title("(c) Trade", position(6))
	xtitle(GEI) ytitle(CDI Trade Index) legend(off)
	saving("Trade", replace);
** Investment;
twoway (scatter Investment GEI, mlabel(Code)) (lfit Investment GEI), 
	title("(d) Investment", position(6))
	xtitle(GEI) ytitle(CDI Investment Index) legend(off)
	saving("Investment", replace);
** Migration;
twoway (scatter Migration GEI, mlabel(Code)) (lfit Migration GEI), 
	title("(e) Migration", position(6))
	xtitle(GEI) ytitle(CDI Migration Index) legend(off)
	saving("Migration", replace);
** Environment;
twoway (scatter Environment GEI, mlabel(Code)) (lfit Environment GEI), 
	title("(f) Environment", position(6))
	xtitle(GEI) ytitle(CDI Environment Index) legend(off)
	saving("Environment", replace);
** Security;
twoway (scatter Security GEI, mlabel(Code)) (lfit Security GEI), 
	title("(g) Security", position(6))
	xtitle(GEI) ytitle(CDI Security Index) legend(off)
	saving("Security", replace);
** Technology;
twoway (scatter Technology GEI, mlabel(Code)) (lfit Technology GEI), 
	title("(h) Technology", position(6))
	xtitle(GEI) ytitle(CDI Technology Index) legend(off)
	saving("Technology", replace);
# delimit cr;

cd "$p"
#delimit;
graph combine Overall.gph Aid.gph Trade.gph Investment.gph Migration.gph Environment.gph, iscale(0.45)
	title("Figure 2: Commitment to Development & Gender Equity")
	note("Note: The dashed line is the line of best fit.")
	saving("Figure2A", replace);
graph combine Migration.gph Environment.gph Security.gph Technology.gph, iscale(0.45)
	title("Figure 2: Commitment to Development & Gender Equity (contd.)")
	note("Note: The dashed line is the line of best fit.")
	saving("Figure2B", replace);
# delimit cr;

** Table 8.	Regression of ODA/GNI, plus CDI aggregate.  (Examine disaggregated CDI and see if worth reporting).

use $q\temp.dta, clear


** Now look at the CDI using regression
regress odaTogni GEI GDPPC polity2007 

regress odaTogni GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel replace sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Overall GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Aid GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Trade GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Investment GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Migration GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Environment GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Security GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Technology GEI GDPPC resource polity2007 
	outreg2 using Table8a.out, bdec(3) excel append sortvar(GEI GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)

** Now look at the CDI using regression with the GII
regress odaTogni GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel replace sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Overall GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Aid GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Trade GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Investment GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Migration GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Environment GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Security GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)
regress Technology GII GDPPC resource polity2007 
	outreg2 using Table8b.out, bdec(3) excel append sortvar(GII GDPPC resource polity2007 PopTot polity2007) stats(coef) alpha(0.05, 0.01)

** Now look at the CDI using regression with the GEM
regress odaTogni GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel replace sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Overall GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Aid GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Trade GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Investment GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Migration GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Environment GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Security GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Technology GEM GDPPC resource polity2007 
	outreg2 using Table8c.out, bdec(3) excel append sortvar(GEM GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)

** Now look at the CDI using regression with the WIP
regress odaTogni WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel replace sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Overall WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Aid WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Trade WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Investment WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Migration WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Environment WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Security WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Technology WIP GDPPC resource polity2007 
	outreg2 using Table8d.out, bdec(3) excel append sortvar(WIP GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)

** Now look at the CDI using regression with the Sex_Ratio Ratio
regress odaTogni Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel replace sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Overall Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Aid Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Trade Sex_Ratio GDPPC resource polity2007 
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Investment Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Migration Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Environment Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Security Sex_Ratio GDPPC resource polity2007
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)
regress Technology Sex_Ratio GDPPC resource polity2007 
	outreg2 using Table8e.out, bdec(3) excel append sortvar(Sex_Ratio GDPPC resource polity2007 PopTot ) stats(coef) alpha(0.05, 0.01)

	
	
** Just for good measure do the CDI using regression with full controls
regress odaTogni GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel replace sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Overall GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Aid GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Trade GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Investment GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Migration GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Environment GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Security GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)
regress Technology GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007
	outreg2 using Table8f.out, bdec(3) excel append sortvar(GEI GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007) stats(coef) alpha(0.05, 0.01)

************************************************************************************************************
********************   Now test the Marginal Effects *******************************************************
************************************************************************************************************	

	
foreach sex in GEI GII WIP {
	quietly probit Genociderat `sex' GDPPC resource PopTot kof_b TradeGDP pts1975 polity1948 c.`sex'#c.polity1948
		margins, dydx(`sex') at(polity1948=-1)
		margins, dydx(`sex') at(polity1948=1)
	quietly probit WarCrimesrat `sex' GDPPC resource PopTot kof_b TradeGDP pts1975 polity1968 c.`sex'#c.polity1968
		margins, dydx(`sex') at(polity1968=-1)
		margins, dydx(`sex') at(polity1968=1)
	quietly probit CATrat `sex' GDPPC resource PopTot kof_b TradeGDP pts1984 polity1984 c.`sex'#c.polity1984
		margins, dydx(`sex') at(polity1984=-1)
		margins, dydx(`sex') at(polity1984=1)
	quietly probit CAT_Protrat `sex' GDPPC resource PopTot kof_b TradeGDP pts2002 polity2002 c.`sex'#c.polity2002 
		margins, dydx(`sex') at(polity2002=-1)
		margins, dydx(`sex') at(polity2002=1)
	quietly probit ICCPR_Prot_1rat `sex' GDPPC resource PopTot kof_b TradeGDP pts1975 polity1966 c.`sex'#c.polity1966 
		margins, dydx(`sex') at(polity1966=-1)
		margins, dydx(`sex') at(polity1966=1)
	quietly probit ICCPR_Prot_2rat `sex' GDPPC resource PopTot kof_b TradeGDP pts1989 polity1989 c.`sex'#c.polity1989 
		margins, dydx(`sex') at(polity1989=-1)
		margins, dydx(`sex') at(polity1989=1)
}

foreach sex in GEI GII WIP {
	dprobit CRC_Prot_1rat `sex' GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000 `sex'Pol2000 
	quietly probit CRC_Prot_1rat `sex' GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000 c.`sex'#c.polity2000 
		margins, dydx(`sex') at(polity2000=-1)
		margins, dydx(`sex') at(polity2000=1)
	quietly probit CRC_Prot_2rat `sex' GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000 c.`sex'#c.polity2000 
		margins, dydx(`sex') at(polity2000=-1)
		margins, dydx(`sex') at(polity2000=1)
	quietly probit Disabilitiesrat `sex' GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007 c.`sex'#c.polity2007 
		margins, dydx(`sex') at(polity2007=-1)
		margins, dydx(`sex') at(polity2007=1)
	quietly probit CEDAW_Optrat `sex' GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000 c.`sex'#c.polity2000 
		margins, dydx(`sex') at(polity2000=-1)
		margins, dydx(`sex') at(polity2000=1)
}

dprobit CRC_Prot_1rat GII GDPPC resource PopTot kof_b TradeGDP pts2000 polity2000 GIIPol2000 
	sum polity2000 if e(sample)


foreach sex in GEI GII WIP {
	foreach outcome in odaTogni Overall Aid Trade Investment {
		display "Outcome variable: `outcome'"
		quietly regress `outcome' `sex' GDPPC resource c.`sex'#c.polity2007
			margins, dydx(`sex') at(polity2007=-1)
			margins, dydx(`sex') at(polity2007=1)
	}
}
	
foreach sex in GEI GII WIP {
	quietly oprobit ICC `sex' c.`sex'#c.polity2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
		margins, dydx(`sex') at(polity2002=-1) predict(outcome(2))
		margins, dydx(`sex') at(polity2002=+1) predict(outcome(2))
	quietly probit BIA `sex' c.`sex'#c.polity2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
		margins, dydx(`sex') at(polity2002=-1)
		margins, dydx(`sex') at(polity2002=+1)
	quietly oprobit ICCplus `sex' c.`sex'#c.polity2002 GDPPC resource PopTot kof_b TradeGDP pts1975 pts2002 polity1948 polity2002  
		margins, dydx(`sex') at(polity2002=-1) predict(outcome(3))
		margins, dydx(`sex') at(polity2002=+1) predict(outcome(3))
}

foreach sex in GEI GII WIP {
	quietly oprobit Iran `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(1))
	quietly oprobit Myanmar `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(1))
	quietly oprobit Nkorea `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(1))
	quietly oprobit EJExecutions `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(1))
	quietly oprobit DeathPenalty `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(1))
	quietly oprobit AntiLGBT `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(-1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(-1))
	quietly oprobit ProLGBT `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(1))
	quietly oprobit ICCPR3Comm `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(-1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(-1))
	quietly oprobit ICESRAmmend `sex' c.`sex'#c.polity2007 GDPPC resource PopTot kof_b TradeGDP pts2007 pts1975 polity2007 polity1948
		margins, dydx(`sex') at(polity2007=-1) predict(outcome(-1))
		margins, dydx(`sex') at(polity2007=+1) predict(outcome(-1))
}

quietly tobit UNFPgdp GEI GEIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	nlcom (_b[GEI]-_b[GEIPol2007]) (_b[GEI]+_b[GEIPol2007]) 
quietly tobit UNFPgdp GII GIIPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	nlcom (_b[GII]-_b[GIIPol2007]) (_b[GII]+_b[GIIPol2007]) 
quietly tobit UNFPgdp WIP WIPPol2007 GDPPC resource PopTot kof_b TradeGDP pts2007 polity2007, ll(0)
	nlcom (_b[WIP]-_b[WIPPol2007]) (_b[WIP]+_b[WIPPol2007]) 

	
save $q\ReplicationData.dta, replace
erase $q\temp.dta

log close


