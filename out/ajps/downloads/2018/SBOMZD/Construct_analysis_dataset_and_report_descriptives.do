////////////////////////
////////////////////////
//DATA CONSTRUCTION/////
//& DESCRIPTIVES////////
////////////////////////
////////////////////////

//The following analyses were carried out using STATA/IC 15.1

//This script constructs the analysis dataset and also reports key descriptive statistics as well as factor
//analysis results

/*Potentially set working directory. This directory must contain:
1. "eurobarometer_salience.dta"
2. "eurobarometer_opinion.dta"
3. "EU_adoption_data_replication.dta"
*/


//Uncomment the following line if you have not installed the "unique" command
//ssc install unique


//////////////////
//Merge datasets
//////////////////

//Load adoption data
use "EU_adoption_data_replication.dta", clear

//Rename identifier to fit Eurobarometer data
rename QuestionNumber question_id

//Merge with Eurobarometer data on public opinion
merge 1:1 question_id using "eurobarometer_opinion.dta", update replace
drop _merge

//Merge with Eurobarometer data on missingness/salience
merge 1:1 question_id using "eurobarometer_salience.dta", update replace
drop _merge


//////////////////
//Augment data
//////////////////

/*Set observations to missing for Bulgaria and Romania before 2007 
as well as Denmark in certain policy areas (note: some commands
lead to no changes, but are repeated here as a safeguard if the scripts
for the Eurobarometer data are changed)*/
 
replace country_3 = . if FieldworkStart < date("01/01/2007", "DMY") 
replace country_23 = . if FieldworkStart < date("01/01/2007", "DMY") 
replace country_7 = . if PolicyArea == "Justice & home affairs"
replace country_7 = . if QuestionN == "Rapid military reaction force"
replace missing_country_3 = . if FieldworkStart < date("01/01/2007", "DMY") 
replace missing_country_23 = . if FieldworkStart < date("01/01/2007", "DMY") 
replace missing_country_7 = . if PolicyArea == "Justice & home affairs"
replace missing_country_7 = . if QuestionN == "Rapid military reaction force"

//Set to missing where adoption information is missing
replace AdoptionDegree = . if AdoptionDegree == 999
//...these are the five issues for which we were unable to assess adoption, see the Supporting Information

//Drop question 78, for which all Eurobarometer measures are missing
drop if question_id == 78

//Set Adoption degree to 0 where Adoption occurred after more than 6 years
gen AdoptionDegree_ORIGINAL = AdoptionDegree
replace AdoptionDegree = 0 if (AdoptionTime - FieldworkStart) > 2190 & AdoptionDegree != .

//Create binary adoption measure at 50 percent as well as 80 percent adoption
gen AdoptionBinary_50pc = .
replace AdoptionBinary_50pc = 1 if AdoptionDegree != . & AdoptionDegree >= 50
replace AdoptionBinary_50pc = 0 if AdoptionDegree != . & AdoptionDegree < 50

gen AdoptionBinary_80pc = .
replace AdoptionBinary_80pc = 1 if AdoptionDegree != . & AdoptionDegree >= 80
replace AdoptionBinary_80pc = 0 if AdoptionDegree != . & AdoptionDegree < 80

//Save augmented dataset
save "merged_data_augmented.dta", replace



///////////////////////////////////////
//Descriptive statistics: macro level
///////////////////////////////////////

//Save simple mean of opinion across countries
egen mean_opinion = rowmean(country_1 country_2 country_3 country_4 country_5 country_6 country_7 country_8 country_9 country_10 country_11 country_12 country_13 country_14 country_15 country_16 country_17 country_18 country_19 country_20 country_21 country_22 country_23 country_24 country_25 country_26 country_27)

//Demean opinion (country-specific opinion minus average opinion across countries)
replace country_1 = (country_1 - mean_opinion) * 100
replace country_2 = (country_2 - mean_opinion) * 100
replace country_3 = (country_3 - mean_opinion) * 100
replace country_4 = (country_4 - mean_opinion) * 100
replace country_5 = (country_5 - mean_opinion) * 100
replace country_6 = (country_6 - mean_opinion) * 100
replace country_7 = (country_7 - mean_opinion) * 100
replace country_8 = (country_8 - mean_opinion) * 100
replace country_9 = (country_9 - mean_opinion) * 100
replace country_10 = (country_10 - mean_opinion) * 100
replace country_11 = (country_11 - mean_opinion) * 100
replace country_12 = (country_12 - mean_opinion) * 100
replace country_13 = (country_13 - mean_opinion) * 100
replace country_14 = (country_14 - mean_opinion) * 100
replace country_15 = (country_15 - mean_opinion) * 100
replace country_16 = (country_16 - mean_opinion) * 100
replace country_17 = (country_17 - mean_opinion) * 100
replace country_18 = (country_18 - mean_opinion) * 100
replace country_19 = (country_19 - mean_opinion) * 100
replace country_20 = (country_20 - mean_opinion) * 100
replace country_21 = (country_21 - mean_opinion) * 100
replace country_22 = (country_22 - mean_opinion) * 100
replace country_23 = (country_23 - mean_opinion) * 100
replace country_24 = (country_24 - mean_opinion) * 100
replace country_25 = (country_25 - mean_opinion) * 100
replace country_26 = (country_26 - mean_opinion) * 100
replace country_27 = (country_27 - mean_opinion) * 100

//Calculate range of opinion (member state with highest support for policy change minus member state with lowest support for policy change)
egen max_opinion = rowmax(country_1 country_2 country_3 country_4 country_5 country_6 country_7 country_8 country_9 country_10 country_11 country_12 country_13 country_14 country_15 country_16 country_17 country_18 country_19 country_20 country_21 country_22 country_23 country_24 country_25 country_26 country_27)
egen min_opinion = rowmin(country_1 country_2 country_3 country_4 country_5 country_6 country_7 country_8 country_9 country_10 country_11 country_12 country_13 country_14 country_15 country_16 country_17 country_18 country_19 country_20 country_21 country_22 country_23 country_24 country_25 country_26 country_27)
gen range_opinion = max_opinion - min_opinion
sum range_opinion if AdoptionDegree != ., detail
//...rounded median is 35 percentage points reported on page 17 in the article...


//Transform salience by deducting the fraction of missing responses from 1
replace missing_country_1 = 1 - missing_country_1 
replace missing_country_2 = 1 - missing_country_2 
replace missing_country_3 = 1 - missing_country_3 
replace missing_country_4 = 1 - missing_country_4 
replace missing_country_5 = 1 - missing_country_5 
replace missing_country_6 = 1 - missing_country_6 
replace missing_country_7 = 1 - missing_country_7 
replace missing_country_8 = 1 - missing_country_8 
replace missing_country_9 = 1 - missing_country_9 
replace missing_country_10 = 1 - missing_country_10 
replace missing_country_11 = 1 - missing_country_11 
replace missing_country_12 = 1 - missing_country_12
replace missing_country_13 = 1 - missing_country_13 
replace missing_country_14 = 1 - missing_country_14 
replace missing_country_15 = 1 - missing_country_15 
replace missing_country_16 = 1 - missing_country_16 
replace missing_country_17 = 1 - missing_country_17 
replace missing_country_18 = 1 - missing_country_18 
replace missing_country_19 = 1 - missing_country_19 
replace missing_country_20 = 1 - missing_country_20 
replace missing_country_21 = 1 - missing_country_21 
replace missing_country_22 = 1 - missing_country_22 
replace missing_country_23 = 1 - missing_country_23 
replace missing_country_24 = 1 - missing_country_24 
replace missing_country_25 = 1 - missing_country_25 
replace missing_country_26 = 1 - missing_country_26 
replace missing_country_27 = 1 - missing_country_27 

//Save simple mean of salience across countries
egen mean_salience = rowmean(missing_country_1 missing_country_2 missing_country_3 missing_country_4 missing_country_5 missing_country_6 missing_country_7 missing_country_8 missing_country_9 missing_country_10 missing_country_11 missing_country_12 missing_country_13 missing_country_14 missing_country_15 missing_country_16 missing_country_17 missing_country_18 missing_country_19 missing_country_20 missing_country_21 missing_country_22 missing_country_23 missing_country_24 missing_country_25 missing_country_26 missing_country_27)

//Demean salience (country-specific salience minus average salience across countries)
replace missing_country_1 = (missing_country_1 - mean_salience) * 100
replace missing_country_2 = (missing_country_2 - mean_salience) * 100
replace missing_country_3 = (missing_country_3 - mean_salience) * 100
replace missing_country_4 = (missing_country_4 - mean_salience) * 100
replace missing_country_5 = (missing_country_5 - mean_salience) * 100
replace missing_country_6 = (missing_country_6 - mean_salience) * 100
replace missing_country_7 = (missing_country_7 - mean_salience) * 100
replace missing_country_8 = (missing_country_8 - mean_salience) * 100
replace missing_country_9 = (missing_country_9 - mean_salience) * 100
replace missing_country_10 = (missing_country_10 - mean_salience) * 100
replace missing_country_11 = (missing_country_11 - mean_salience) * 100
replace missing_country_12 = (missing_country_12 - mean_salience) * 100
replace missing_country_13 = (missing_country_13 - mean_salience) * 100
replace missing_country_14 = (missing_country_14 - mean_salience) * 100
replace missing_country_15 = (missing_country_15 - mean_salience) * 100
replace missing_country_16 = (missing_country_16 - mean_salience) * 100
replace missing_country_17 = (missing_country_17 - mean_salience) * 100
replace missing_country_18 = (missing_country_18 - mean_salience) * 100
replace missing_country_19 = (missing_country_19 - mean_salience) * 100
replace missing_country_20 = (missing_country_20 - mean_salience) * 100
replace missing_country_21 = (missing_country_21 - mean_salience) * 100
replace missing_country_22 = (missing_country_22 - mean_salience) * 100
replace missing_country_23 = (missing_country_23 - mean_salience) * 100
replace missing_country_24 = (missing_country_24 - mean_salience) * 100
replace missing_country_25 = (missing_country_25 - mean_salience) * 100
replace missing_country_26 = (missing_country_26 - mean_salience) * 100
replace missing_country_27 = (missing_country_27 - mean_salience) * 100

//Calculate range of salience (member state with highest salience minus member state with lowest salience)
egen max_salience = rowmax(missing_country_1 missing_country_2 missing_country_3 missing_country_4 missing_country_5 missing_country_6 missing_country_7 missing_country_8 missing_country_9 missing_country_10 missing_country_11 missing_country_12 missing_country_13 missing_country_14 missing_country_15 missing_country_16 missing_country_17 missing_country_18 missing_country_19 missing_country_20 missing_country_21 missing_country_22 missing_country_23 missing_country_24 missing_country_25 missing_country_26 missing_country_27)
egen min_salience = rowmin(missing_country_1 missing_country_2 missing_country_3 missing_country_4 missing_country_5 missing_country_6 missing_country_7 missing_country_8 missing_country_9 missing_country_10 missing_country_11 missing_country_12 missing_country_13 missing_country_14 missing_country_15 missing_country_16 missing_country_17 missing_country_18 missing_country_19 missing_country_20 missing_country_21 missing_country_22 missing_country_23 missing_country_24 missing_country_25 missing_country_26 missing_country_27)
gen range_salience = max_salience - min_salience
sum range_salience if AdoptionDegree != ., detail
//...rounded median is 19 percentage points as reported in the article in section "A New Dataset on Policy Representation in the EU"

//Report number of distinct policy issues
unique QuestionN if AdoptionBinary_80pc != .
//...211 unique policy issues as reported in the article in section "A New Dataset on Policy Representation in the EU"

//Report number of questions and policy issues that mildly violated inclusion criteria
tab Problem if AdoptionBinary_80pc != .
encode Problem, gen(aux)
unique QuestionN if AdoptionBinary_80pc != . & aux == 2
drop aux
//47 questions relating to 46 policy issues as reported in the Supporting Information in section 1)

//Report number of questions and policy issues for which opinion estimates were flipped
tab FlippedOpinion if AdoptionBinary_80pc != .
encode FlippedOpinion, gen(aux)
unique QuestionN if AdoptionBinary_80pc != . & aux == 2
drop aux
//33 questions relating to 30 policy issues as reported in the Supporting Information in section 1)

//Show all questions with adoption degrees greater 0 but smaller 80
list QuestionN if AdoptionDegree != . & AdoptionDegree != 0 & AdoptionDegree < 80
//Only 7 are not related to enlargement as reported in the Supporting Information in section 1)

//Check overall frequency of policy change
tab AdoptionBinary_80pc
//...36 percent as reported in the article in section "A New Dataset on Policy Representation in the EU" 

//Produce Figure A1 from the Supporting Information
gen imp_duration = AdoptionT -  FieldworkStart
histogram imp_duration if AdoptionDegree_ORIGINAL != . & AdoptionDegree_ORIGINAL >= 80, bin(20) scheme(lean2) freq xtitle("Adoption lag (days)") kdensity 
graph export "Figure_A1.png", replace height(1500)

//Check when changes are adopted in case they are eventually adopted
tab imp_duration if AdoptionDegree_ORIGINAL >= 80
//...relevant for figures mentioned in footnote 4 in the article

//Check length of adoption time lag if only adoptions within 6 years are used
sum imp_duration if AdoptionDegree != . & AdoptionDegree >= 80, detail
//...median adoption time lag is 1,191 days as reported in the article in section "A New Dataset on Policy Representation in the EU"

//Check length of adoption time lag if all adoptions are used
sum imp_duration if AdoptionDegree_ORIGINAL != . & AdoptionDegree_ORIGINAL >= 80, detail
//...median adoption time lag is 1,271 days as reported in the Supporting Information

//Produce Table A2 from the Supporting Information
estpost tab PolicyArea if AdoptionDegree != ., sort
esttab using Table_A2.rtf, replace cells("b(label(freq)) pct(fmt(2)) cumpct(fmt(2))") varlabels(`e(labels)') nonumber nomtitle noobs label 
//...some of these figures are also mentioned in the article in section "A New Dataset on Policy Representation in the EU"

//Save demeaned dataset
save "merged_data_demeaned.dta", replace



////////////////////////////////////////////////////////
//Descriptive statistics: policy area and country level
////////////////////////////////////////////////////////

//Reshape data to long format
reshape long country_ missing_country_, i(question_id) j(member_state)
rename country_ Opinion
rename missing_country_ Salience

//Produce Table A3 in the Supporting Information
//Columns for "Opinion"
estpost tabstat Opinion if AdoptionDegree != ., by(PolicyArea) statistics(sd, min, max, count) columns(statistics) 
esttab using Table_A3.rtf, replace cells("sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") varlabels(`e(labels)') label
//Columns for "Salience"
estpost tabstat Salience if AdoptionDegree != ., by(PolicyArea) statistics(sd, min, max, count) columns(statistics) 
esttab using Table_A3.rtf, append cells("sd(fmt(2)) min(fmt(2)) max(fmt(2)) count(fmt(0))") varlabels(`e(labels)') label 

//Produce Table A4 in the Supporting Information
//Columns for "Opinion"
estpost tabstat Opinion if AdoptionDegree != ., by(member_state) statistics(mean, sd, min, max) columns(statistics)
esttab using Table_A4.rtf, append cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") varlabels(`e(labels)') label 
//Columns for "Salience"
estpost tabstat Salience if AdoptionDegree != ., by(member_state) statistics(mean, sd, min, max) columns(statistics)
esttab using Table_A4.rtf, append cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") varlabels(`e(labels)') label 



///////////////////
//Factor analyses 
///////////////////

//Load demeaned dataset
use "merged_data_demeaned.dta", clear

//Rename variables according to country codes for better display in graphs
rename missing_country_1 at
rename missing_country_2 be
rename missing_country_3 bu
rename missing_country_4 cy
rename missing_country_5 cz
rename missing_country_6 de
rename missing_country_7 dk
rename missing_country_8 ee
rename missing_country_9 el
rename missing_country_10 es
rename missing_country_11 fi
rename missing_country_12 fr
rename missing_country_13 hu
rename missing_country_14 ie
rename missing_country_15 it
rename missing_country_16 lt
rename missing_country_17 lu
rename missing_country_18 lv
rename missing_country_19 mt
rename missing_country_20 nl
rename missing_country_21 pl
rename missing_country_22 pt
rename missing_country_23 ro
rename missing_country_24 se
rename missing_country_25 si
rename missing_country_26 sk
rename missing_country_27 uk

rename country_1 AT
rename country_2 BE
rename country_3 BU
rename country_4 CY
rename country_5 CZ
rename country_6 DE
rename country_7 DK
rename country_8 EE
rename country_9 EL
rename country_10 ES
rename country_11 FI
rename country_12 FR
rename country_13 HU
rename country_14 IE
rename country_15 IT
rename country_16 LT
rename country_17 LU
rename country_18 LV
rename country_19 MT
rename country_20 NL
rename country_21 PL
rename country_22 PT
rename country_23 RO
rename country_24 SE
rename country_25 SI
rename country_26 SK
rename country_27 UK


//Produce Table A5 in the Supporting Information, note that "esttab" does not include
//the "uniqueness" column, which was copied by hand
factor AT BE CY CZ DE DK EE EL ES FI FR HU IE IT LT LU LV MT NL PL PT SE SI SK UK if AdoptionDegree != ., factors(5)
esttab e(L) using Table_A5.rtf, replace cells("L[Factor1](t) L[Factor2](t) L[Factor3](t) L[Factor4](t)  L[Factor5](t) Psi[Uniqueness](t)") nogap noobs nonumber nomtitle
screeplot
//Some of the figures are also mentioned in the Supporting Information in section 5)

//Get factor scores (maximum and minimum values can be investigated, i.e. what policy issues)
predict dim_opinion1 dim_opinion2 if AdoptionDegree != .

/* Dimension 1 shows contrast between core (DE, FR, AT, BE, LU) and new member states (PL, MT)
and is about deepening (in particular, in environment and JHA) vs. enlargement
Dimension 2 shows constrast between Nordics (SE, FI, DK, NL) and Southern member states (EL, CY, PT, IT, IE) 
and is about cuts in agriculture vs. no cuts and constitutional policy issues (Balkans enlargement / CFSP deepening)
*/

//Produce Figure A2 in the Supporting Information
loadingplot, scheme(lean2) xtitle("FACTOR 1") ytitle("FACTOR 2") title("") mlabposition(12) xline (0) yline(0) note("") msymbol(smdiamond) 
graph export "Figure_A2.png", replace height(1500)



///////////////////////////
//Create analysis dataset
///////////////////////////

//Load augmented dataset
use "merged_data_augmented.dta", clear

//Reshape data to long format
reshape long country_ missing_country_, i(question_id) j(member_state)
rename country_ Opinion
rename missing_country_ Salience

//Generate country variable as string
gen country = ""
replace country = "at" if member_state == 1
replace country = "be" if member_state == 2
replace country = "bu" if member_state == 3
replace country = "cy" if member_state == 4
replace country = "cz" if member_state == 5
replace country = "de" if member_state == 6
replace country = "dk" if member_state == 7
replace country = "ee" if member_state == 8
replace country = "el" if member_state == 9
replace country = "es" if member_state == 10
replace country = "fi" if member_state == 11
replace country = "fr" if member_state == 12
replace country = "hu" if member_state == 13
replace country = "ie" if member_state == 14
replace country = "it" if member_state == 15
replace country = "lt" if member_state == 16
replace country = "lu" if member_state == 17
replace country = "lv" if member_state == 18
replace country = "mt" if member_state == 19
replace country = "nl" if member_state == 20
replace country = "pl" if member_state == 21
replace country = "pt" if member_state == 22
replace country = "ro" if member_state == 23
replace country = "se" if member_state == 24
replace country = "si" if member_state == 25
replace country = "sk" if member_state == 26
replace country = "uk" if member_state == 27


//Recode salience measure by deducting fraction of missing responses from 1
replace Salience = (1 - Salience)

//Create opinion majority size measure
gen Opinion_majority = abs(Opinion - 0.5)

//Create survey-weighted EU-wide measures of salience and the opinion majority size
gen Salience_eu_wide = (1 - missing_eu_sw)
gen Opinion_majority_eu_wide = abs(eu_sw - 0.5)

//Create encoded version of unanimity variable
encode Unanimity, gen(Unanimity_enc)

//Create number of Council votes according to Nice formula
gen votes = .
replace votes = 12 if country == "be"
replace votes = 10 if country == "bu"
replace votes = 12 if country == "cz"
replace votes = 7 if country == "dk"
replace votes = 29 if country == "de"
replace votes = 4 if country == "ee"
replace votes = 7 if country == "ie"
replace votes = 12 if country == "el"
replace votes = 27 if country == "es"
replace votes = 29 if country == "fr"
replace votes = 29 if country == "it"
replace votes = 4 if country == "cy"
replace votes = 4 if country == "lv"
replace votes = 7 if country == "lt"
replace votes = 4 if country == "lu"
replace votes = 12 if country == "hu"
replace votes = 3 if country == "mt"
replace votes = 13 if country == "nl"
replace votes = 10 if country == "at"
replace votes = 27 if country == "pl"
replace votes = 12 if country == "pt"
replace votes = 14 if country == "ro"
replace votes = 4 if country == "si"
replace votes = 7 if country == "sk"
replace votes = 7 if country == "fi"
replace votes = 10 if country == "se"
replace votes = 29 if country == "uk"


//Create salience-weighted opinion for "Council: equal power" model
egen max_salience = max(Salience)
egen min_salience = min(Salience)
gen rescaled = (Salience - min_salience)/(max_salience - min_salience)

egen sum_rescaled = sum(rescaled), by(question_id)
egen Opinion_salience_weighted = sum((rescaled/sum_rescaled) * Opinion), by(question_id)


//Create salience- and vote-weighted opinion for "Council: unequal power" model
replace votes = . if Opinion == .
egen max_votes = max(votes)
egen min_votes = min(votes)
gen rescaled_votes = (votes - min_votes)/(max_votes - min_votes)

egen sum_votes = sum(votes), by(question_id)
egen sum_votes_rescaled = sum(rescaled_votes + rescaled), by(question_id)
egen Opinion_salience_power_weighted = sum(((rescaled_votes + rescaled)/sum_votes_rescaled) * Opinion), by(question_id)


//Create measure of opinion for "Council/EP-Commission" model
gen Opinion_salience_EP_COM_weighted = Opinion_salience_weighted
replace Opinion_salience_EP_COM_weighted = (0.5 * Opinion_salience_weighted + 0.5 * eu_sw) if Unanimity == "No"
replace Opinion_salience_EP_COM_weighted = (0.5 * Opinion_salience_weighted + 0.5 * eu_sw) if Unanimity == "Unclear"


//Create salience-weighted opinion without rescaling salience weights between 0 and 1 ("RAW")
egen sum_salience = sum(Salience), by(question_id)
egen Opinion_salience_weighted_raw = sum((Salience/sum_salience) * Opinion), by(question_id)
replace Opinion_salience_weighted_raw = . if Opinion_salience_weighted_raw == 0


//Create measure of conflicting opinion
gen opinion_bin = .
replace opinion_bin = 1 if Opinion >= 0.5
replace opinion_bin = 0 if Opinion < 0.5
replace opinion_bin = . if Opinion == .

egen sum_change = sum(opinion_bin), by(question_id)
egen obs = count(opinion_bin), by(question_id)
gen conflicts = obs - sum_change
replace conflicts = sum_change if sum_change < conflicts
gen conflict_perc = conflicts/obs


//Create congruence measures at 50 percent and 80 percent adoption
gen Congruent_50pc = .
replace Congruent_50pc = 0 if AdoptionDegree != . & Opinion != .
replace Congruent_50pc = 1 if AdoptionDegree >= 50 & Opinion > 0.5 & Opinion != .
replace Congruent_50pc = 1 if AdoptionDegree < 50 & Opinion <= 0.5 & Opinion != .
replace Congruent_50pc = . if AdoptionDegree == .

gen Congruent_80pc = .
replace Congruent_80pc = 0 if AdoptionDegree != . & Opinion != .
replace Congruent_80pc = 1 if AdoptionDegree >= 80 & Opinion > 0.5 & Opinion != . 
replace Congruent_80pc = 1 if AdoptionDegree < 80 & Opinion <= 0.5 & Opinion != .
replace Congruent_80pc = . if AdoptionDegree == .


//Create adoption and congruence measures with different maximum adoption lengths
gen AdoptionDegree_5halfyears = AdoptionDegree_ORIGINAL
replace AdoptionDegree_5halfyears = 0 if (AdoptionTime - FieldworkStart) > 2008 & AdoptionDegree_5halfyears != .

gen AdoptionBinary_5halfyears = .
replace AdoptionBinary_5halfyears = 1 if AdoptionDegree_5halfyears != . & AdoptionDegree_5halfyears >= 80
replace AdoptionBinary_5halfyears = 0 if AdoptionDegree_5halfyears != . & AdoptionDegree_5halfyears < 80

gen AdoptionDegree_5years = AdoptionDegree_ORIGINAL
replace AdoptionDegree_5years = 0 if (AdoptionTime - FieldworkStart) > 1825 & AdoptionDegree_5years != .

gen AdoptionBinary_5years = .
replace AdoptionBinary_5years = 1 if AdoptionDegree_5years != . & AdoptionDegree_5years >= 80
replace AdoptionBinary_5years = 0 if AdoptionDegree_5years != . & AdoptionDegree_5years < 80

gen Congruent_5halfyears = .
replace Congruent_5halfyears = 0 if AdoptionDegree_5halfyears != . & Opinion != .
replace Congruent_5halfyears = 1 if AdoptionDegree_5halfyears >= 80 & Opinion > 0.5 & Opinion != .
replace Congruent_5halfyears = 1 if AdoptionDegree_5halfyears < 80 & Opinion <= 0.5 & Opinion != .
replace Congruent_5halfyears = . if AdoptionDegree_5halfyears == .

gen Congruent_5years = .
replace Congruent_5years = 0 if AdoptionDegree_5years != . & Opinion != .
replace Congruent_5years = 1 if AdoptionDegree_5years >= 80 & Opinion > 0.5 & Opinion != .
replace Congruent_5years = 1 if AdoptionDegree_5years < 80 & Opinion <= 0.5 & Opinion != .
replace Congruent_5years = . if AdoptionDegree_5years == .


//Drop auxiliary variables
drop Opinion Unanimity AdoptionDegree_ORIGINAL AdoptionDegree_5halfyears AdoptionDegree_5years country missing_eu_sw sum_change opinion_bin obs conflicts max_salience min_salience rescaled sum_rescaled max_votes min_votes rescaled_votes sum_votes sum_votes_rescaled sum_salience 

//Report average support for policy change
sum eu_sw if member_state == 1 & AdoptionDegree != ., detail
//...mean of 0.64 as reported in the article in section "A New Dataset on Policy Representation in the EU"



///////////////////////////////
//Rename and relabel variables
///////////////////////////////

//Member state
label variable member_state "Member State / Country"
label define memberstates 1 "Austria" 2 "Belgium" 3 "Bulgaria" 4 "Cyprus" 5 "Czech Republic" 6 "Germany" 7 "Denmark" 8 "Estonia" 9 "Greece" 10 "Spain" 11 "Finland" 12 "France" 13 "Hungary" 14 "Ireland" 15 "Italy" 16 "Lithuania" 17 "Luxembourg" 18 "Latvia" 19 "Malta" 20 "Netherlands" 21 "Poland" 22 "Portugal" 23 "Romania" 24 "Sweden" 25 "Slovenia" 26 "Slovakia" 27 "United Kingdom"
label values member_state memberstates

//Survey id
label variable survey_id "Survey Number"

//Unanimity
label variable Unanimity_enc "Decision rule (encoded)"

//Votes
label variable votes "Number of Votes of Member State"

//Adoption degree
label variable AdoptionDegree "Adoption Degree (as coded)"
label variable AdoptionBinary_80pc "Binary Adoption Indicator (from 80 percent Adoption, 6 years)"
label variable AdoptionBinary_50pc "Binary Adoption Indicator (from 50 percent Adoption, 6 years)"
label variable AdoptionBinary_5halfyears "Binary Adoption Indicator (from 80 percent Adoption, 5.5 years)"
label variable AdoptionBinary_5years "Binary Adoption Indicator (from 80 percent Adoption, 5 years)"

//Congruence
label variable Congruent_80pc "Congruence (from 80 percent Adoption, 6 years)"
label variable Congruent_50pc "Congruence (from 50 percent Adoption, 6 years)"
label variable Congruent_5halfyears "Congruence (from 80 percent Adoption, 5.5 years)"
label variable Congruent_5years "Congruence (from 80 percent Adoption, 5 years)"

//Opinion and salience estimates
rename eu_sw Opinion_eu_wide
label variable Opinion_eu_wide "EU-wide Mean Opinion"
label variable Salience "Mean Salience in Member State"
label variable Salience_eu_wide "EU-wide Mean Salience"
label variable Opinion_majority_eu_wide "EU-wide Mean Opinion Majority"
label variable Opinion_majority "Mean Opinion Majority in Member State"
label variable Opinion_salience_weighted "Opinion under Council: equal power specification"
label variable Opinion_salience_weighted_raw "Opinion under Council: equal power specification (no rescaling of salience weights)"
label variable Opinion_salience_power_weighted "Opinion under Council: unequal power specification"
label variable Opinion_salience_EP_COM_weighted "Opinion under Council-EP/Commission specification"

//Conflict
label variable conflict_perc "Percentage of Member States with Diverging Majority Opinion"

//Create unique case id
sort question_id member_state
gen case_id = _n
label variable case_id "Unique Case Identifier"

//Save analysis dataset
save "analysis_dataset.dta", replace


