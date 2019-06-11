* Stata/MP 13.1 for Mac (64-bit Intel)

* Change directory to location where replication files have been downloaded

*** Process source data from a variety of publicly available datasets to prep for merging with original datasets

* Hall and Windett Data v.1 downloaded (Nov. 1, 2015) from https://sites.google.com/a/slu.edu/jwindett/research/state-court-project
use "Archive/Master Data.dta", clear
keep LexisNexisCitationNumber Year LegalArea
keep if Year == 2010
drop Year
split LexisNexisCitationNumber, generate(lex) parse(;)
gen CitingCase = lex5 if regexm(lex5, "LEXIS")
replace CitingCase = lex4 if regexm(lex4, "LEXIS")
replace CitingCase = lex3 if regexm(lex3, "LEXIS")
replace CitingCase = lex2 if regexm(lex2, "LEXIS")
replace CitingCase = lex1 if regexm(lex1, "LEXIS")
drop if CitingCase == ""
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, " ", "")
replace CitingCase = regexr(CitingCase, "\.", "")
replace CitingCase = regexr(CitingCase, "\.", "")
replace CitingCase = regexr(CitingCase, "\.", "")
replace CitingCase = regexr(CitingCase, "\.", "")
drop LexisNexisCitationNumber lex1-lex8
duplicates drop
save "HallWindett.dta", replace

* Bonica State Supreme Court Ideal Point Estimates downloaded (Nov. 1, 2015) from http://web.stanford.edu/~bonica/data. 
import delimited "bw_ssc_db/bw_ssc_db.csv", delimiter(comma, collapse) varnames(1) clear
keep if year_enter < 2011
keep if year_exit == "2010" | year_exit == "2011" | year_exit == "Present" | year_exit == "present"
replace cfscore = "." if cfscore == "NA"
destring cfscore, replace
collapse (median) cfscore, by(state)
replace state = "OC" if state == "OK (crim)"
replace state = "TC" if state == "TX (Crim)"
save "cfScores.dta", replace

** Revised 1960-2013 Citizen Ideology Scores from Berry et. al. (1998) downloaded (Nov. 1, 2015) from https://rcfording.wordpress.com/state-ideology-data
use "ideo6014.dta", clear
keep statename citi6013 year
keep if year == 2010
save "berryData.dta", replace


* State of Residence in 2000 by State of Birth: 2000 (.csv file), downloaded (Nov. 18, 2015) from https://www.census.gov/hhes/migration/decennial.html
* Original downloaded dataset was processed using migrationData.R to generate the .csv file used here.
import delimited "migration.csv",  delimiter(comma) bindquote(strict) case(preserve) varnames(1) clear 
rename * state*
rename statev1 v1
reshape long state, i(v1) j(state2) string
rename v1 state1
rename state bornInCitedState
label variable bornInCitedState "% of citing state population born in cited state"
drop if state1 == state2
rename state1 citingCourt
rename state2 citedCourt
save "migrationData.dta", replace



*** Merge citation-level data with case type from Hall & Windett ***

** Open original dataset containing each citation to another state high court found within a published 2010 opinion from a state high court
use "OutwardCitedDyads.dta", clear

** Merge with Hall and Windett data to classify each 2010 opinion as a criminal or civil case
merge m:1 CitingCase using "HallWindett.dta"

drop if _merge == 2
drop _merge

gen criminal = 0
replace criminal = 1 if LegalArea == "Criminal Law & Procedure"

gen civil = 1
replace civil = 0 if criminal == 1 
replace civil = 0 if LegalArea == ""
drop CitingCase
drop if citedCourt == "DC"

saveold "OutwardCitedDyadsHW.dta", replace

*** Summarize Outward Citations by state
use "OutwardCitedDyadsHW.dta", clear
collapse (sum) s2sCites=Citation s2sCitesCrim=criminal s2sCitesCivil=civil, by(citingCourt)
save "outwardByState.dta", replace

*** Summarize Inward Citations by state
use "OutwardCitedDyadsHW.dta", clear
collapse (sum) citedTo=Citation citedToCrim=criminal citedToCivil=civil, by(citedCourt)
save "inwardByState.dta", replace


*** Generate Dyadic Outcome Variables
use "OutwardCitedDyadsHW.dta", clear
collapse (sum) citeCount=Citation crimCiteCount=criminal civilCiteCount=civil, by(citingCourt citedCourt)
save "dvDyads.dta", replace


*****************************************************
*** IMPORT, PROCESS, AND CREATE CONTROL VARIABLES ***
*****************************************************

*** State level explanatory variables

use "StateLevelVariables_1.dta", clear 
** Manually compiled source data containing state-level variables, information on location of sources listed below:
     * SquireIndex: Legal professionalsim score for each state obtained from Squire (2008) Table 1, pp. 228-229
	 * Pop2010: Data obtained from the Census Bureau available at http://www.census.gov/prod/cen2010/briefs/c2010br-01.pdf (last accessed Nov. 18, 2015)
	 * TortScore: Data obtained from a ranking of the lawsuit climate in each state in 2010 provided by the U.S. Chamber Institute for 
	 *  		   Legal reform available at https://www.uschamber.com/sites/default/files/documents/files/2010LawsuitClimateReport.pdf (last accessed August 11, 2015).
 
* Merge in citizen ideology scores for each state from Berry, et. al. (1998)
merge m:1 statename using "berryData.dta"
drop _merge
rename citi6013 BerryCitID

* Merge in state high court ideology scores from Bonica and Woodruff (2010)
merge 1:1 state using "cfScores.dta"
drop _merge

save "AllStateLevelVariables.dta", replace

use "AllStateLevelVariables.dta", clear
drop statename
rename state Court
rename * citing*
save "citingStateLevelVariables.dta", replace

use "AllStateLevelVariables.dta", clear
drop statename
rename state Court
rename * cited*
save "citedStateLevelVariables.dta", replace


**************************************************
*** MERGE SUBSETS OF DATA AND CREATE VARIABLES ***
**************************************************

* Outcome variables
use "dvDyads.dta", clear

** Merge in dyadic explanatory variables compiled manually by research assistants, geographic distance between capitols and contiguity
* Add in dyadic explanatory variables
merge 1:1 citingCourt citedCourt using "ivDyads.dta"
drop if citedCourt == "DC"
drop if citingCourt == "DC"
replace citeCount = 0 if _merge == 2
replace civilCiteCount = 0 if _merge == 2
replace crimCiteCount = 0 if _merge == 2
drop _merge

** Merge in dyadic migration data for Cultural Linkage variable
merge 1:1 citingCourt citedCourt using "migrationData.dta"
drop if _merge==2
drop _merge

* Merge in state-level variables for citing states
merge m:1 citingCourt using "citingStateLevelVariables.dta"
drop if _merge == 2
drop _merge

* Merge in state-level variables for cited states
merge m:1 citedCourt using "citedStateLevelVariables.dta"
drop if _merge == 2
drop _merge

* Merge in state-level variables for how much each state cites other courts overall
merge m:1 citingCourt using "outwardByState.dta"
drop _merge

save "fullDataset.dta", replace


***************************************************************************************
*** VARIABLE TRANSORMATION ***
***************************************************************************************

** Create variables used for analysis
use "fullDataset.dta", clear

gen ctIDdistance = abs(citingcfscore - citedcfscore)

gen berryCitDif = abs(citingBerryCitID - citedBerryCitID)

gen distanceS = .
replace distanceS = distance/100

gen citedPopMil = citedPop2010/1000000
gen citingPopMil = citingPop2010/1000000
gen diffPopMil = abs(citingPopMil - citedPopMil)

* Create buckets with all possible cominations of West region, same federal circuit, and contiguity
gen sameWestRegion = 0
replace sameWestRegion = 1 if citingWestRegion == citedWestRegion
gen sameCircuit = 0
replace sameCircuit = 1 if citingCircuit == citedCircuit
gen geobucket = 0
replace geobucket = 1 if sameWestRegion == 1 & sameCircuit == 0 & contiguous == 0
replace geobucket = 2 if sameWestRegion == 0 & sameCircuit == 1 & contiguous == 0
replace geobucket = 3 if sameWestRegion == 0 & sameCircuit == 0 & contiguous == 1
replace geobucket = 4 if sameWestRegion == 1 & sameCircuit == 1 & contiguous == 0
replace geobucket = 5 if sameWestRegion == 1 & sameCircuit == 0 & contiguous == 1
replace geobucket = 6 if sameWestRegion == 0 & sameCircuit == 1 & contiguous == 1
replace geobucket = 7 if sameWestRegion == 1 & sameCircuit == 1 & contiguous == 1
label define buck_lab 0 "None" 1 "Same West Region" 2 "Same Circuit" 3 "Contiguous" 4 "Same West, Circuit" 5 "Same West, Contiguous" 6 "Same Circuit, Contigous" 7 "Same West, Circuit, Contiguous", replace
label values geobucket buck_lab

gen sameMethod = 0
replace sameMethod = 1 if citingMethod == citedMethod

rename citedSquireIndex citedSquireProf

gen citedLegCapS = .
replace citedLegCapS = citedLegCap/10000

gen citedElected2 = citedElected

gen citingElected2 = citingElected

gen citingLA = 0
replace citingLA = 1 if citingCourt == "LA"

gen citedLA = 0
replace citedLA = 1 if citedCourt == "LA"

gen s2sCites2 = s2sCites - citeCount
gen s2sCitesCrim2 = s2sCitesCrim - crimCiteCount
gen s2sCitesCivil2 = s2sCitesCivil - civilCiteCount

keep citingCourt citedCourt citeCount crimCiteCount civilCiteCount s2sCitesCrim2 s2sCitesCivil2 ctIDdistance berryCitDif bornInCitedState distanceS diffPopMil geobucket sameMethod citedSquireProf citedLegCapS citedPopMil citedElected2 citingElected2 citingLA citedLA s2sCites2 citedTortScore citedMethod citingMethod citedWestRegion citingWestRegion

label variable citeCount "Model 1 DV"
label variable crimCiteCount "Model 2 DV"
label variable civilCiteCount "Model 3 DV"
label variable ctIDdistance "Ideological Distance: Courts"
label variable berryCitDif "Ideological Distance: Citizens"
label variable bornInCitedState "Cultural Linkage"
label variable distanceS "Geographic Distance"
label variable diffPopMil "Population Difference"
label variable sameMethod "Same Selection Method"
label variable citedSquireProf "Legal Professionalism_j"
label variable citedLegCapS "Legal Capital_j"
label variable citedPopMil "Population_j"
label variable citedElected2 "Elected_j"
label variable citingElected2 "Elected_i"
label variable citedLA "Louisiana_j"
label variable citingLA "Louisiana_i"
label variable s2sCites2 "Total Cites_{i,-j}"
label variable s2sCitesCrim2 "Total Criminal Cites_{i,-j}"
label variable s2sCitesCivil2 "Total Civil Cites_{i,-j}"
label variable citedTortScore "Litigation Environment_j"

saveold "data.for.analysis.dta", replace




****** CREATE DATASET FOR APP B ******

** Open original dataset containing each citation to another state high court or the Court of Appeals for the District of Columbia found within a published 2010 opinion from a state high court
use "OutwardCitedDyadsB.dta", clear

replace citingCourt = "OK" if citingCourt == "OC"
replace citingCourt = "TX" if citingCourt == "TC"

replace citedCourt = "OK" if citedCourt == "OC"
replace citedCourt = "TX" if citedCourt == "TC"

drop if citingCourt == citedCourt

collapse (sum) Citation, by(citingCourt citedCourt)
rename Citation citeCount

save "dvDyadsAppB.dta", replace

*** Summarize Outward Citations by state
use "OutwardCitedDyadsB.dta", clear
replace citingCourt = "OK" if citingCourt == "OC"
replace citingCourt = "TX" if citingCourt == "TC"
replace citedCourt = "OK" if citedCourt == "OC"
replace citedCourt = "TX" if citedCourt == "TC"
drop if citingCourt == citedCourt

collapse (sum) s2sCites=Citation, by(citingCourt)
save "outwardByStateAppB.dta", replace

*** Summarize Inward Citations by state
use "OutwardCitedDyadsB.dta", clear
replace citingCourt = "OK" if citingCourt == "OC"
replace citingCourt = "TX" if citingCourt == "TC"
replace citedCourt = "OK" if citedCourt == "OC"
replace citedCourt = "TX" if citedCourt == "TC"
drop if citingCourt == citedCourt

collapse (sum) citedToTotal=Citation, by(citedCourt)
save "inwardByStateAppB.dta", replace

**************************************************
*** MERGE SUBSETS OF DATA AND CREATE VARIABLES ***
**************************************************

* Outcome variables
use "dvDyadsAppB.dta", clear

* Add in dyadic explanatory variables
merge 1:1 citingCourt citedCourt using "ivDyads.dta"
replace citeCount = 0 if _merge == 2
drop _merge

merge 1:1 citingCourt citedCourt using "migrationData.dta"
replace citeCount = 0 if _merge == 2
drop _merge

drop if citedCourt == "TC" | citedCourt == "OC"
drop if citingCourt == "TC" | citingCourt == "OC"

* Add in state-level variables for citing states
merge m:1 citingCourt using "citingStateLevelVariables.dta"
drop if _merge == 2
drop _merge

* Add in state-level variables for cited states
merge m:1 citedCourt using "citedStateLevelVariables.dta"
drop if _merge == 2
drop _merge

* Add in state-level variables for number of outward cites from each state
merge m:1 citingCourt using "outwardByStateAppB.dta"
drop if _merge == 2
drop _merge

* Add in state-level variables for number of inward cites to each state
merge m:1 citedCourt using "inwardByStateAppB.dta"
drop if _merge == 2
drop _merge


save "fullDatasetAppB.dta", replace


***************************************************************************************
*** VARIABLE TRANSORMATION ***
***************************************************************************************
use "fullDatasetAppB.dta", clear

*Outcome Variable
gen citesStandardized = citeCount / s2sCites

** Characteristics of Cited Court
* Prestige
gen citedPrestige = citedToTotal - citeCount

* Legal Professionalism
gen citedSquireProf = citedSquireIndex 

* Squared Caseload 
gen citedCaseload2 = citedCaseload*citedCaseload

** Relational Characteristics
* Relational Prestige: The code grabs citingPrestige from the opposite dyad when the citing court was the cited court (and paired up with the same other state)
gen citingPrestige = 0

local N = _N
forvalues i = 1/`N' {

	forvalues j = 1/`N' {
	
		if citingCourt[`i'] == citedCourt[`j'] & citedCourt[`i'] == citingCourt[`j']  {
			qui replace citingPrestige = citedPrestige[`i'] in `j'
		}
		
}
	display `i'
}


gen diffPrestige = citingPrestige - citedPrestige

* Relational Legal Professionalism
gen diffProf = citingSquireIndex - citedSquireIndex

* Relational Population
gen diffPop = citingPop2010 - citedPop2010

* Relational Legal Capital
gen diffLegCap = citingLegCap - citedLegCap


* Distance squared
gen distancesq = distance * distance

* Legal Reporting Districts (omit SW)
gen bothAtlantic = 0
replace bothAtlantic = 1 if citingWestRegion == "A" & citedWestRegion == "A"
gen bothNE = 0
replace bothNE = 1 if citingWestRegion == "NE" & citedWestRegion == "NE"
gen bothNW = 0
replace bothNW = 1 if citingWestRegion == "NW" & citedWestRegion == "NW"
gen bothPacific = 0
replace bothPacific = 1 if citingWestRegion == "P" & citedWestRegion == "P"
gen bothSouthern = 0
replace bothSouthern = 1 if citingWestRegion == "S" & citedWestRegion == "S"
gen bothSE = 0
replace bothSE = 1 if citingWestRegion == "SE" & citedWestRegion == "SE"
gen bothSW = 0
replace bothSW = 1 if citingWestRegion == "SW" & citedWestRegion == "SW"

keep citingCourt citedCourt citesStandardized citedPrestige citedSquireProf citedPop2010 citedLegCap citedCaseload citedCaseload2 diffPrestige diffProf diffPop diffLegCap bornInCitedState distance distancesq bothAtlantic bothNE bothSE bothSouthern bothPacific bothNW 

saveold "data.for.analysis.appB.dta", replace
