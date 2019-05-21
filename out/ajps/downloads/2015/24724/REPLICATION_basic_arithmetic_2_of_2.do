/*********************************************************************
 *** REPLICATION MATERIALS
 ***
 *** "THE BASIC ARITHMETIC OF LEGISLATIVE DECISIONS"
 *** Michael Laver and Kenneth Benoit
 ***
 *** Code file 2 of 2  (run 1 of 2 first)
 ***
 *** Table 1: Greek Election Results
 ***          http://en.wikipedia.org/wiki/Greek_legislative_election,_May_2012
 ***          http://en.wikipedia.org/wiki/Greek_legislative_election,_June_2012
 *** Tables 2, 4-8 use "ERD legislative types.dta"
 *** Table 2: Legislative type frequencies in ERD data
 *** Table 4: Mean durations of govt formation by type
 *** Table 5: Cox PH hazard models for formation by type duration
 *** Table 6: Govt types by leg type
 *** Table 7: Mean govt duration by type
 *** Table 8: Cox PH model of govt duration
 *** Table 3: Multinomial regressions - this file
 ***          input: ERDsimulateddraws.dta, 
 ***                 created by REPLICATION_basic_arithmetic_1_of_2.R
 ***          requires: installation of outreg2 library
 ***     
 *** Figure 1: N/A Produced in MS Word
 *** Figure 2: N/A Produced in Adobe Illustrator
 *** Figure 3: Barpolot of leg types by S1-S3 
 ***           input: ERDtypesim.dta, 
 ***                  created by REPLICATION_basic_arithmetic_1_of_2.R
 *** Figure 4: Transitions Table plot
 ***           code in REPLICATION_basic_arithmetic_1_of_2.R   
 ***
 *** Figure A1: See REPLICATION_basic_arithmetic_1_of_2.R
 *** Figure A2: See REPLICATION_basic_arithmetic_1_of_2.R
 *** 
 *** 2013 
 *********************************************************************/


/*****************************************************************
 *** CREATE THE GOVERNMENT TYPES DATASET FROM THE ERD DATASET  ***
 *****************************************************************/
*** INSTALL ROW-SORTING ROUTINE IF NOT ALREADY INSTALLED
*** ssc install sortrows

version 11
use "./ERD Dataset/ERDdata.dta", clear

*** CALCULATE TOTAL SEATS, WINNING THRESHOLD, SMALLEST PARTY SIZE
egen int total_seats = rowtotal(v200e - v231e)
gen int W = int(total_seats/2) + 1
egen float Sn = rowmin(v200e - v231e)

*** SORT PARTY SEAT TOTALS IN DESCENDING ORDER OF SIZE AND RENAME
sortrows  v200e -  v231e, replace missing descending

*** CREAT NEW VARS AND BEAUTIFY VARIABLE NAMES
rename v001e country
label define country 1 "Austria" 2 "Belgium" 3 "Denmark" 4 "Finland" 5 "France" 6 "Germany" /// 
7 "Greece" 8 "Iceland" 9 "Ireland" 10 "Italy" 11 "Luxembourg" 12 "Netherlands" 13 "Norway" ///
14 "Portugal" 15 "Spain" 16 "Sweden" 17 "United Kingdom" 18 "Bulgaria" 19 "Cyprus" ///
20 "Czech Republic" 21 "Estonia" 22 "Hungary" 23 "Latvia" 24 "Lithuania" 25 "Malta" 26 "Poland" ///
27 "Romania" 28 "Slovakia" 29 "Slovenia"
label values country country

generate int CEU = 0
replace CEU = 1 if country >= 18
replace CEU = 0 if country ==19 | country == 25

rename v002e cabinetID
rename v003e cabinet_name
rename v004e date_in
rename v005e date_out
rename v008e election_date
rename v010e cabinet_composition

rename v100e  Austria 
rename v101e  Belgium 
rename v102e  Denmark 
rename v103e  Finland 
rename v104e  France 
rename v105e  Germany 
rename v106e  Greece 
rename v107e  Iceland
rename v108e  Ireland 
rename v109e  Italy 
rename v110e  Luxembourg 
rename v111e  Netherlands 
rename v112e  Norway 
rename v113e  Portugal 
rename v114e  Spain 
rename v115e  Sweden 
rename v116e  UK 
rename v117e  Bulgaria 
rename v118e  Cyprus 
rename v119e  Czech 
rename v120e  Estonia 
rename v121e  Hungary 
rename v122e  Latvia 
rename v123e  Lithuania 
rename v124e  Malta 
rename v125e  Poland 
rename v126e  Romania 
rename v127e  Slovakia 
rename v128e  Slovenia 

rename v129e  decade
rename v132e  decade1940
rename v133e  decade1950
rename v134e  decade1960
rename v135e  decade1970
rename v136e  decade1980
rename v137e  decade1990
rename v138e  decade2000
rename v139e  decade2010

rename v200e S1
rename v201e S2
rename v202e S3
rename v203e S4
rename v204e S5
rename v205e S6
rename v206e S7
rename v207e S8
rename v208e S9
rename v209e S10

rename v300e new_govt
rename v303e post_election
rename v306e n_parties
rename v309e enp
rename v312e p1_share
rename v313e p1_banzhaf
rename v314e minority_parlt
rename v315e non_partisan
rename v316e coalition
rename v317e cabinet_seats
rename v318e cabinet_seat_share
rename v320e cabinet_nparties
rename v321e cab_parties_change
rename v322e max_power_in
rename v323e one_party_majority
rename v324e one_party_minority
rename v325e minority_coalition
rename v326e majority_coalition
rename v327e minimal_winning
rename v328e surplus
rename v407e polarization 
rename v505e pos_parl
rename v508e constructive_nc
rename v330e n_ministers
rename v411e median1_in
rename v412e median2_in
generate DDM = 0
replace DDM = 1 if median1_in == 1 & median2_in == 1

rename v414e MWC

rename v600e bargaining_duration
rename v603e relative_cab_duration
rename v605e absolute_cab_duration

rename v702e inflation
rename v703e unemployment
rename v704e growth

gen gov_type = .
replace gov_type = 1 if one_party_majority == 1
replace gov_type = 2 if minimal_winning == 1 & one_party_minority == 0
replace gov_type = 3 if one_party_minority == 1
replace gov_type = 4 if minority_coalition == 1
replace gov_type = 5 if surplus == 1 
label define gov_type 1 "One-party majority" 2 "MWC" 3 "One-party minority" 4 "Minority coalition" 5 "Surplus"
label values gov_type gov_type

*** CLASSIFY THE TYPES

generate str case = "."
replace case = "A" if S1 >= W
replace case = "B" if S1 < W & (S1 + S3) >= W & (S2 + S3) < W
replace case = "B*" if S1 < W & (S1 + Sn) >= W & (S2 + S3) < W
replace case = "C" if S1 < W & S2 + S3 >= W
replace case = "D" if S1 < W & (S1 + S2) >= W & (S1 + S3) < W
replace case = "E" if S1 + S2 < W

gen case_A = 0
replace case_A = 1 if case == "A"
gen case_B = 0
replace case_B = 1 if case == "B"
gen case_Bstar = 0
replace case_Bstar = 1 if case == "B*"
gen case_Bplain = 0
replace case_Bplain = 1 if case_B == 1 & case_Bstar == 0
gen case_C = 0
replace case_C = 1 if case == "C"
gen case_D = 0
replace case_D = 1 if case == "D"
gen case_E = 0
replace case_E = 1 if case == "E"

*****TABS
tab case if new_govt == 1
tab case gov_type if case != "A" & new_govt == 1
tabstat absolute_cab_duration if new_govt == 1, by(case)
tabulate gov_type case if case != "A" & new_govt == 1, summarize(absolute_cab_duration) nostandard nofreq noobs
 
// save "./ERD dataset/ERD legislative types.dta"


/****************************** 
 ***  FIGURE 3 - BOX PLOT   ***
 ******************************/
use "ERD dataset/ERDtypesim.dta", clear
gen caseID = .
replace caseID = 1 if case == "A"
replace caseID = 2 if case == "B*"
replace caseID = 3 if case == "B"
replace caseID = 4 if case == "C"
replace caseID = 5 if case == "D"
replace caseID = 6 if case == "E"
label define case 1 "A" 2 "B*" 3 "B" 4 "C" 5 "D" 6 "E"
label values caseID case
gen p2_share = S2 / total_seats
gen p3_share = S3 / total_seats
label var p2_share "P2"
label var p3_share "P3"
label var p1_share "P1"
graph box p1_share p2_share p3_share if p1_share<20, ///
   over(caseID) horiz name(erdplot, replace) scheme(s1color) ///
   ytitle(Seat Share) legend(rows(3) symxsize(2) region(color(white)))


/*************************************************************************
*** TABLE 2: Frequencies of leg types in European elections, 1945-2010 ***
**************************************************************************/
use "ERD dataset/ERD legislative types.dta", clear
egen npcat = cut(n_parties) if post_election==1, at(2 7 16)
tab npcat case, row col
 
/***************************************************** 
 ***  TABLE 4 - MULTINOMIAL LOGISTIC REGRESSIONS   ***
 *****************************************************/
table case post_election, contents(mean bargaining_duration semean bargaining_duration ) row col format(%4.1f)


/***************************************************** 
 ***  TABLE 5 - GOLDER DATA DURATION MODELS        ***
 *****************************************************/
replace bargaining_duration = .01 if bargaining_duration == 0
stset bargaining_duration
stcox n_parties minority_parl constructive_nc CEU if post_election == 1, efron nohr robust 
stcox n_parties minority_parl constructive_nc CEU if post_election == 0, efron nohr robust
stcox n_parties constructive_nc CEU case_Bstar - case_E if post_election == 1, efron nohr robust
stcox n_parties constructive_nc CEU case_Bstar - case_E if post_election == 0, efron nohr robust
stcox n_parties constructive_nc CEU case_Bstar - case_E Austria-Italy Netherlands-Slovenia if post_election == 1, efron nohr robust
stcox n_parties constructive_nc CEU case_Bstar - case_E Austria-Italy Netherlands-Slovenia if post_election == 0, efron nohr robust

***************
*** TABLE 6 ***
***************
tab gov_type case if minority_parl == 1

***************
*** TABLE 7 ***
***************
table case post_election, contents(mean absolute_cab_duration semean  absolute_cab_duration) row col format(%4.0f)
table gov_type post_election, contents(mean absolute_cab_duration semean absolute_cab_duration) col  format(%4.0f)
table CEU post_election, contents(mean absolute_cab_duration semean absolute_cab_duration ) col format(%4.0f)

***************
*** TABLE 8 ***
***************
gen censored = 0
replace censored = 1 if absolute_cab_duration > 1350
stset absolute_cab_duration, failure (censored)
stcox n_parties CEU minimal_winning if minority_parl == 1 & post_election == 1, efron nohr robust
stcox n_parties CEU minimal_winning case_Bstar - case_D if minority_parl == 1 & post_election == 1, efron nohr robust
stcox n_parties CEU minimal_winning case_Bstar - case_D Austria-Denmark France-Slovenia if minority_parl == 1 & post_election == 1, efron nohr robust


   
/***************************************************** 
 ***  TABLE 3 - MULTINOMIAL LOGISTIC REGRESSIONS   ***
 ***            NOTE: requires library outreg2     ***
 *****************************************************/
 
// Load in simulated cases from ERDsimulateddraws.dta and predict effects
use "ERD dataset/ERDsimulateddraws.dta", clear
// Predict case transition probabilities for changes from original cases
// using original case as a baseline
capture erase output1.txt
capture erase output1.xml
capture erase output2.txt
capture erase output2.xml
gen p1lead = p1 - p2
gen p2lead = p2 - p3
gen p3lead = p3 - p4
set more off
forvalues i = 2/6 {
  outreg2 using output2.txt, excel stats(coef ci) addstat(Log-likelihood, `e(ll)') noaster adec(4) bracket nocons eform long: ///
     mlogit simtype p1lead p2lead p3lead pNchange if originaltype==`i', base(`i') rrr
}
set more off
forvalues i = 2/6 {
  outreg2 using output1.txt, excel stats(coef ci) addstat(Log-likelihood, `e(ll)') noaster adec(4) bracket nocons eform long: ///
     mlogit simtype p1 p2 p3 pNchange if originaltype==`i', base(`i') rrr
}
forvalues i = 2/6 {
  outreg2 using output1.txt, excel stats(coef ci) addstat(Log-likelihood, `e(ll)') noaster adec(4) bracket nocons eform long: ///
     mlogit simtype p1 p2 p3 pNchange if N>3 & originaltype==`i', base(`i') rrr
}


