***********************************
*** AJPS MTurk Replication File ***
***********************************

*** Miller, Saunders, & Farhart, 2015 ***
*** Conspiracy Endorsement as Motivated Reasoning: The Moderating Roles of Political Knowledge and Trust ***

* use "/MTurk.dta"

* Run MTurk.do first
* Run ANES.do second

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
* The following variable transformations and analyses were carried out using Stata/SE 14. 
* However, the datasets have been saved in Stata 12 format for Dataverse. 
* All commands used to transform the variables are included below, but are commented out.
* All variables reflected in MTurk.dta and ANES.dta have been created.
* MTurk analyses begin on line 1077.
* In order to create tables and figures, this do-file and ANES.do need to be run together, 
* as the analyses within the do-files have been separated by respective datasets.
****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

********************************
********************************
********************************
*** Variable Transformations ***
********************************
********************************
********************************

******************************
*** Unique Case Identifier ***
******************************
* A unique case identifier was generated for each respondent
* "caseid" is the variable name representing these unique case identifiers
	* gen caseid = _n
	* label var caseid "Unique Case Identifier"

*****************************
*****************************
*** Explanatory Variables ***
*****************************
*****************************

**************************
*** Conservative Dummy ***
**************************
* Analyses below are run with Conservative dummy variable (Conservative = 1; Liberal = 0) 
	* label var QC24 "Ideology 7-Point Scale (Same as ideo7)"
	* label define QC24l 1 "Extremely Liberal" 2 "Liberal" 3 "Slightly Liberal" 4 "Moderate; Middle of the Road" 5 "Slightly Conservative" 6 "Conservative" 7 "Extremely Conservative"
	* label value QC24 QC24l

	* gen ideo7 = QC24
	* label var ideo7 "Recode of QC24: Ideology 7-Point Scale"
	* label define ideo7l 1 "Extremely Liberal" 2 "Liberal" 3 "Slightly Liberal" 4 "Moderate; Middle of the Road" 5 "Slightly Conservative" 6 "Conservative" 7 "Extremely Conservative"
	* label value ideo7 ideo7l
	* tab ideo7 QC24

	* recode ideo7 (1/3=1 "Liberal") (4=2 "Moderate") (5/7=3 "Conservative") (.=.), generate(ideo3)
	* tab ideo7 ideo3
	* label var ideo3 "Recode of ideo7: Political Ideology 3-Category"

* Dummy variable for only conservatives and liberals used in analyses
	* recode ideo7 (1/3=0 "Liberal") (4=. ) (5/7=1 "Conservative") (.=.), generate(Conservative)
	* tab ideo7 Conservative
	* label var Conservative "Conservative Dummy without Moderates: Recode of ideo7"

****************************
*** Party Identification ***
****************************
* For Online Appendix Tables 4 and 5
* The following commands are used to generate 7 category party identification

	* label var QG2a "Would you call yourself a strong Democrat or a not very strong Democrat?"
	* label define QG2al 1 "Strong Democrat" 2 "Not very strong Democrat"
	* label value QG2a QG2al

	* label var QG2b "Would you call yourself a strong Republican or a not very strong Republican?"
	* label define QG2bl 1 "Strong Republican" 2 "Not very strong Republican"
	* label value QG2b QG2bl

	* label var QG2c "Do you think of yourself as closer to the Democratic Party or the Republican Party?"
	* label define QG2cl 1 "Closer to the Democratic Party" 2 "Closer to the Republican Party" 3 "Closer to Neither Party"
	* label value QG2c QG2cl

	* gen pid7 = .
	* replace pid7 = 1 if QG2a == 1
	* replace pid7 = 2 if QG2a == 2
	* replace pid7 = 3 if QG2c == 1
	* replace pid7 = 4 if QG2c == 3
	* replace pid7 = 5 if QG2c == 2
	* replace pid7 = 6 if QG2b == 2
	* replace pid7 = 7 if QG2b == 1
	* tab pid7

	* label var pid7 "Party Identification 7-point (Comb of Branched QG2a QG2a QG2a)"
	* label define pid7l 1 "Strong Democrat" 2 "Not Very Strong Democrat" 3 "Lean Democrat" 4 "Independent" 5 "Lean Republican" 6 "Not Very Strong Republican" 7 "Strong Republican"
	* label values pid7 pid7l
	* tab pid7

* The following commands are used to generate a 6 category party identification, removing independents
* "pid6" is the party identification variable used for analyses appearing in the Online Appendix Tables 4 and 5
	* recode pid7 (1=1 "Strong Democrat") (2=2 "Weak Democrat") (3=3 "Lean Democrat") (4=.) (5=4 "Lean Republican") (6=5 "Weak Repulican") (7=6 "Strong Republican"), generate (pid6_alt)
	* label var pid6_alt "Recode of pid6: Party Id - No Independents"
	* gen pid6 = (pid6_alt-1)/5
	* label var pid6 "Party ID - No Independents (0-1 Recode of pid6_alt)"
	* tab pid6
	* sum pid6, d


*********************************
*** Political Knowledge Index ***
*********************************
* Political knowledge index - recoded each into 0 (wrong) vs. 1 (correct), then averaged
* f1_alt-f14_alt coded with missing variables=0 for skipped/dk included as wrong response
* Missing values are coded as zero/wrong answer
* 14-item index

	* label var QF1 "Which pty currently has most members in the U.S. House of Reps?"
	* label define QF1l 1 "Republican Party" 2 "Democratic Party" 
	* label value QF1 QF1l
	* gen f1_alt = .
	* replace f1_alt = 1 if QF1==1
	* replace f1_alt = 0 if QF1==2 
	* replace f1_alt = 0 if QF1 ==.
	* label define f1_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f1_alt f1_altl 
	* label var f1_alt "0-1 PolKnow Dummy Recode of QF1: Pty w/ most members in House"
	* tab f1_alt

	* label var QF2 "Which pty is more conservative than the other at the national level?"
	* label define QF2l 1 "Republican Party" 2 "Democratic Party" 3 "Neither party is more conservative than the other"
	* label value QF2 QF2l
	* gen f2_alt = .
	* replace f2_alt = 1 if QF2==1
	* replace f2_alt = 0 if QF2==2 | QF2==3
	* replace f2_alt =0 if QF2 ==.
	* label define f2_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f2_alt f2_altl 
	* label var f2_alt "0-1 PolKnow Dummy Recode of QF2: Which pty is more conservative"
	* tab f2_alt

	* label var QF3 "What job or political office is now held by John Roberts?"
	* label define QF3l 1 "Chair of the Democratic National Committee" 2 "Senate Majority Leader" 3 "Chief Justice of the Supreme Court" 4 "Chair of the Republican National Committee"
	* label value QF3 QF3l
	* gen f3_alt = .
	* replace f3_alt = 1 if QF3==3
	* replace f3_alt = 0 if QF3==1 | QF3==2 | QF3==4
	* replace f3_alt =0 if QF3 ==.
	* label define f3_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f3_alt f3_altl 
	* label var f3_alt "0-1 PolKnow Dummy Recode of QF3: Job held by John Roberts"
	* tab f3_alt

	* label var QF4 "Who is the current President of Russia?"
	* label define QF4l 1 "Dimitry Medvedev" 2 "Vladimir Putin" 3 "Boris Yeltsin" 4 "Viktor Zubkov"
	* label value QF4 QF4l
	* gen f4_alt = .
	* replace f4_alt = 1 if QF4==2
	* replace f4_alt = 0 if QF4==1 | QF4==3 | QF4==4
	* replace f4_alt =0 if QF4==.
	* label define f4_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f4_alt f4_altl 
	* label var f4_alt "0-1 PolKnow Dummy Recode of QF4: President of Russia"
	* tab f4_alt

	* label var QF5 "Who is current Speaker of U.S. House of Representatives?"
	* label define QF5l 1 "Nancy Pelosi" 2 "Harry Reid" 3 "Marco Rubio" 4 "John Boehner"
	* label value QF5 QF5l
	* gen f5_alt = .
	* replace f5_alt = 1 if QF5==4
	* replace f5_alt = 0 if QF5==1 | QF5==2 | QF5==3
	* replace f5_alt =0 if QF5 ==.
	* label define f5_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f5_alt f5_altl 
	* label var f5_alt "0-1 PolKnow Dummy Recode of QF5: Speaker of the House"
	* tab f5_alt

	* label var QF6 "What job or political office is now held by Joe Biden?"
	* label define QF6l 1 "House Minority Leader" 2 "Vice President of the United States" 3 "Secretary of Defense" 4 "Secretary of State"
	* label value QF6 QF6l
	* gen f6_alt = .
	* replace f6_alt = 1 if QF6==2
	* replace f6_alt = 0 if QF6==1 | QF6==3 | QF6==4
	* replace f6_alt =0 if QF6 ==.
	* label define f6_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f6_alt f6_altl 
	* label var f6_alt "0-1 PolKnow Dummy Recode of QF6: Office held by Joe Biden"
	* tab f6_alt

	* label var QF7 "What job or political office is now held by David Cameron?"
	* label define QF7l 1 "Prime Minister of the United Kingdom" 2 "CEO of Target Corp." 3 "Prime Minister of Australia" 4 "Secretary of Treasury"
	* label value QF7 QF7l
	* gen f7_alt = .
	* replace f7_alt = 1 if QF7==1
	* replace f7_alt = 0 if QF7==2 | QF7==3 | QF7==4
	* replace f7_alt =0 if QF7 ==.
	* label define f7_altl 0 "wrong response/dk" 1 "correct response"  
	* label value f7_alt f7_altl 
	* label var f7_alt "0-1 PolKnow Dummy Recode of QF7: Office held by David Cameron"
	* tab f7_alt

	* label var QF8 "Who nominates judges to the U.S. Federal Courts?"
	* label define QF8l 1 "The President" 2 "The U.S. Senate" 3 "The U.S. House of Representatives" 4 "The Supreme Court"
	* label value QF8 QF8l
	* gen f8_alt = .
	* replace f8_alt = 1 if QF8==1
	* replace f8_alt = 0 if QF8==2 | QF8==3 | QF8==4
	* replace f8_alt =0 if QF8 ==.
	* label define f8_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f8_alt f8_altl 
	* label var f8_alt "0-1 PolKnow Dummy Recode of QF8: Who nominates judges to Fed Cts"
	* tab f8_alt

	* label var QF9 "How long is the term of office for a U.S. Senator?"
	* label define QF9l 1 "2 years" 2 "4 years" 3 "6 years" 4 "8 years"
	* label value QF9 QF9l
	* gen f9_alt = .
	* replace f9_alt = 1 if QF9==3
	* replace f9_alt = 0 if QF9==1 | QF9==2 | QF9==4
	* replace f9_alt =0 if QF9 ==.
	* label define f9_altl 0 "wrong response/dk" 1 "correct response"  
	* label value f9_alt f9_altl 
	* label var f9_alt "0-1 PolKnow Dummy Recode of QF9: Senate term length"
	* tab f9_alt

	* label var QF10 "Who determines if a law is constitutional or not?"
	* label define QF10l 1 "The President" 2 "The U.S. Senate" 3 "The U.S. House of Representatives" 4 "The Supreme Court"
	* label value QF10 QF10l
	* gen f10_alt = .
	* replace f10_alt = 1 if QF10==4
	* replace f10_alt = 0 if QF10==1 | QF10==2 | QF10==3
	* replace f10_alt =0 if QF10 ==.
	* label define f10_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f10_alt f10_altl 
	* label var f10_alt "0-1 PolKnow Dummy Recode of QF10: Who determines law is/not constitutional"
	* tab f10_alt

	* label var QF11 "What majority is req for Senate & House to override a pres. veto?"
	* label define QF11l 1 "1/2" 2 "3/5" 3 "2/3" 4 "3/4"
	* label value QF11 QF11l
	* gen f11_alt = .
	* replace f11_alt = 1 if QF11==3
	* replace f11_alt = 0 if QF11==1 | QF11==2| QF11==4
	* replace f11_alt =0 if QF11 ==.
	* label define f11_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f11_alt f11_altl 
	* label var f11_alt "0-1 PolKnow Dummy Recode of QF11: Majority req. to override pres. veto"
	* tab f11_alt

	* label var QF12 "Who is the current U.S. Secretary of State?"
	* label define QF12l 1 "Hillary Clinton" 2 "Janet Napolitano" 3 "John Kerry" 4 "Tom Ridge"
	* label value QF12 QF12l
	* gen f12_alt = .
	* replace f12_alt = 1 if QF12==3
	* replace f12_alt = 0 if QF12==1 | QF12==2| QF12==4
	* replace f12_alt =0 if QF12 ==.
	* label define f12_altl 0 "wrong response/dk" 1 "correct response"  
	* label value f12_alt f12_altl 
	* label var f12_alt "0-1 PolKnow Dummy Recode of QF12: U.S. Secretary of State"
	* tab f12_alt

	* label var QF13 "Who is the current U.S. Secretary of Treasury?"
	* label define QF13l 1 "Ben Bernanke" 2 "Timothy Geithner" 3 "Larry Summers" 4 "Jacob Lew"
	* label value QF13 QF13l
	* gen f13_alt = .
	* replace f13_alt = 1 if QF13==4
	* replace f13_alt = 0 if QF13==1 | QF13==2| QF13==3
	* replace f13_alt =0 if QF13 ==.
	* label define f13_altl 0 "wrong response/dk" 1 "correct response"  
	* label value f13_alt f13_altl 
	* label var f13_alt "0-1 PolKnow Dummy Recode of QF13: U.S. Secretary of Treasury"
	* tab f13_alt

	* label var QF14 "Who is the current Prime Minister of Canada?"
	* label define QF14l 1 "John Major" 2 "Stephen Harper" 3 "Francois Mitterrand" 4 "Paul Martin"
	* label value QF14 QF14l
	* gen f14_alt = .
	* replace f14_alt = 1 if QF14==2
	* replace f14_alt = 0 if QF14==1 | QF14==3| QF14==4
	* replace f14_alt =0 if QF14 ==.
	* label define f14_altl 0 "wrong response/dk" 1 "correct response" 
	* label value f14_alt f14_altl 
	* label var f14_alt "0-1 PolKnow Dummy Recode of QF14: Prime Minister of Canada"
	* tab f14_alt

*_alt includes the variables where missing values are coded as 0
* polknow_alt is the political knowledge index used in the analyses below
	* gen polknow_alt = (f1_alt + f2_alt + f3_alt + f4_alt + f5_alt + f6_alt + f7_alt + f8_alt + f9_alt + f10_alt + f11_alt + f12_alt + f13_alt + f14_alt)/14
	* label var polknow_alt "0-1 Political Knowledge Index (Avg of 14 pol know items)"
	* tab polknow_alt
	* sum polknow_alt

* The following variable transformation is used to create the high/low knowledge split used in Appendix C
* Appendix C analyses are included below
	* tab polknow_alt 
	* recode polknow_alt (.7142856/1=1 "High") (0/.6428572=0 "Low") (.=.), generate(polknow_hl)
	* tab polknow_hl
	* label var polknow_hl "High/Low Split for Political Knowledge: Recode of polknow_alt"

***********************
*** Trust Questions ***
***********************
* The following commands were used to generate the generalized trust index used in the analyses below. 
* Trust in gov't - QC11a; QC11stem_A_1
	* label var QC11a "How much of the time do you think you can trust the federal govt to do what is right?"
	* label define QC11al 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11a QC11al
	
	* label var QC11stem_A_1 "Grid: How much of the time do you think you can trust the federal govt to do what is right?"
	* label define QC11stem_A_1l 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11stem_A_1 QC11stem_A_1l

	* gen trust_g = .
	* replace trust_g = 1 if QC11a == 4
	* replace trust_g = 2 if QC11a == 3
	* replace trust_g = 3 if QC11a == 2
	* replace trust_g = 4 if QC11a == 1
	* replace trust_g = 1 if QC11stem_A_1 == 4
	* replace trust_g = 2 if QC11stem_A_1 == 3
	* replace trust_g = 3 if QC11stem_A_1 == 2
	* replace trust_g = 4 if QC11stem_A_1 == 1

	* label define trust_gl 1 "Almost never" 2 "Some of the time" 3 "Most of the time" 4 "Almost always"
	* label value trust_g trust_gl 
	* label var trust_g "Comb QC11a & QC11stem_A_1: Trust the Fed govt to do what's right"
	* tab trust_g

* Variable placed on a 0-1 scale
	* gen trust_govt = (trust_g-1)/3
	* label var trust_govt "0-1 Recode of trust_g: Trust the Fed govt to do what's right"
	* tab trust_govt

* Trust in police/law enforcement - QC11b; QC11stem_A_2
	* label var QC11b "How much of the time do you think you can trust law enforcement to do what is right?"
	* label define QC11bl 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11b QC11bl
	
	* label var QC11stem_A_2 "Grid: How much of the time do you think you can trust law enforcement to do what is right?"
	* label define QC11stem_A_2l 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11stem_A_2 QC11stem_A_2l

	* gen trust_le = .
	* replace trust_le = 1 if QC11b == 4
	* replace trust_le = 2 if QC11b == 3
	* replace trust_le = 3 if QC11b == 2
	* replace trust_le = 4 if QC11b == 1
	* replace trust_le = 1 if QC11stem_A_2 == 4
	* replace trust_le = 2 if QC11stem_A_2 == 3
	* replace trust_le = 3 if QC11stem_A_2 == 2
	* replace trust_le = 4 if QC11stem_A_2 == 1

	* label define trust_lel 1 "Almost never" 2 "Some of the time" 3 "Most of the time" 4 "Almost always"
	* label value trust_le trust_lel 
	* label var trust_le "Comb QC11b & QC11stem_A_2: Trust law enforcement to do what's right"
	* tab trust_le

* Variable placed on a 0-1 scale
	* gen trust_police = (trust_le-1)/3
	* label var trust_police "0-1 Recode of trust_le: Trust law enforcement to do what's right"
	* tab trust_police

* Trust in media - QC11c; QC11stem_A_3
	* label var QC11c "How much of the time do you think you can trust the media to do what is right?"
	* label define QC11cl 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11c QC11cl
	
	* label var QC11stem_A_3 "Grid: How much of the time do you think you can trust the media to do what is right?"
	* label define QC11stem_A_3l 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11stem_A_3 QC11stem_A_3l

	* gen trust_m = .
	* replace trust_m = 1 if QC11c == 4
	* replace trust_m = 2 if QC11c == 3
	* replace trust_m = 3 if QC11c == 2
	* replace trust_m = 4 if QC11c == 1
	* replace trust_m = 1 if QC11stem_A_3 == 4
	* replace trust_m = 2 if QC11stem_A_3 == 3
	* replace trust_m = 3 if QC11stem_A_3 == 2
	* replace trust_m = 4 if QC11stem_A_3 == 1

	* label define trust_ml 1 "Almost never" 2 "Some of the time" 3 "Most of the time" 4 "Almost always"
	* label value trust_m trust_ml 
	* label var trust_m "Comb QC11c & QC11stem_A_3: Trust media to do what's right"
	* tab trust_m

* Variable placed on a 0-1 scale
	* gen trust_media = (trust_m-1)/3
	* label var trust_media "0-1 Recode of trust_m: Trust media to do what's right"
	* tab trust_media

* Trust in people - QC11d; QC11stem_A_4
	* label var QC11d "How much of the time do you think you can trust people to do what is right?"
	* label define QC11dl 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11d QC11dl
	
	* label var QC11stem_A_4 "Grid: How much of the time do you think you can trust people to do what is right?"
	* label define QC11stem_A_4l 1 "Almost always" 2 "Most of the time" 3 "Some of the time" 4 "Almost Never"
	* label value QC11stem_A_4 QC11stem_A_4l

	* gen trust_p = .
	* replace trust_p = 1 if QC11d == 4
	* replace trust_p = 2 if QC11d == 3
	* replace trust_p = 3 if QC11d == 2
	* replace trust_p = 4 if QC11d == 1
	* replace trust_p = 1 if QC11stem_A_4 == 4
	* replace trust_p = 2 if QC11stem_A_4 == 3
	* replace trust_p = 3 if QC11stem_A_4 == 2
	* replace trust_p = 4 if QC11stem_A_4 == 1

	* label define trust_pl 1 "Almost never" 2 "Some of the time" 3 "Most of the time" 4 "Almost always"
	* label value trust_p trust_pl 
	* label var trust_p "Comb QC11d & QC11stem_A_4: Trust people to do what's right"
	* tab trust_p

* Variable placed on a 0-1 scale
	* gen trust_people = (trust_p-1)/3
	* label var trust_people "0-1 Recode of trust_p: Trust people to do what's right"
	* tab trust_people

* We combined the 4 individual trust items (police, govt, media, and people) into a generalized trust index and took the row mean
* "trust_comb" is the continuous generalized trust index used in the analyses below
	* tab1 trust_govt trust_police trust_media trust_people
	* egen trust_comb = rowmean(trust_govt trust_police trust_media trust_people)
	* tab trust_comb
	* label var trust_comb "0-1 Generalized Trust Index (Avg of trust_govt trust_police trust_media trust_people)"

* The following commands create the high/low split 0, 1s used in graphing
	* gen trusthighlow_alt = .
	* replace trusthighlow_alt = 0 if trust_comb < .5
	* replace trusthighlow_alt = 1 if trust_comb >= .5
	* label define trusthighlow_alt 0 "Low Trust" 1 "High Trust"
	* label value trusthighlow_alt trusthighlow_altl 
	* label var trusthighlow_alt "High/Low Split for Generalized Trust: Recode of trust_comb"
	* tab trusthighlow_alt trust_comb

* The following commands create the standardized MTurk trust index to compare with ANES standardized trust index
* This discussion is under the section heading below, "A Snapshot of the Two Datasets: More Similarities than Differences"
	* egen trust_govt_std = std(trust_govt)
	* egen trust_police_std = std(trust_police)
	* egen trust_media_std = std(trust_media)
	* egen trust_people_std = std(trust_people)
	* egen trust_comb_std = rowmean(trust_govt_std trust_police_std trust_media_std trust_people_std)
	* label var trust_comb_std "Standardized Generalized Trust Index"

************
*** TIPI ***
************
* Big 5 Traits; original variables QE1stem_A_1-QE1stem_A_10

*Flip so that high values are high on domain: 
* 1 and 6 are extraversion; 6 is reverse coded
* 2 and 7 are agreeableness; 2 is reverse coded
* 3 and 8 are consciousness; 8 is reverse coded
* 4 and 9 are emotional stability; 4 is reverse coded
* 5 and 10 are openness; 10 is reverse coded 
* Thus, flip 1, 7, 3, 9, and 5

	* label var QE1stem_A_1 "TIPI: extraverted, enthusiastic"
	* label define QE1stem_A_1l 1 "Agree strongly" 2 "Agree moderately" 3 "Agree a little" 4 "Neither agree nor disagree" 5 "Disagree a little" 6 "Disagree moderately" 7 "Disagree strongly"
	* label value QE1stem_A_1 QE1stem_A_1l
	* tab QE1stem_A_1
	* gen E1stem_A_1 = QE1stem_A_1
	* recode E1stem_A_1 1=7 2=6 3=5 4=4 5=3 6=2 7=1 .=.
	* label define E1stem_A_1l 1 "Disagree strongly" 2 "Disagree moderately" 3 "Disagree a little" 4 "Neither agree nor disagree" 5 "Agree a little" 6 "Agree moderately" 7 "Agree strongly" 
	* label value E1stem_A_1 E1stem_A_1l 
	* tab E1stem_A_1

	* label var QE1stem_A_7 "TIPI: sympathetic, warm"
	* label define QE1stem_A_7l 1 "Agree strongly" 2 "Agree moderately" 3 "Agree a little" 4 "Neither agree nor disagree" 5 "Disagree a little" 6 "Disagree moderately" 7 "Disagree strongly"
	* label value QE1stem_A_7 QE1stem_A_7l
	* tab QE1stem_A_7
	* gen E1stem_A_7 = QE1stem_A_7
	* recode E1stem_A_7 1=7 2=6 3=5 4=4 5=3 6=2 7=1 .=.
	* label define E1stem_A_7l 1 "Disagree strongly" 2 "Disagree moderately" 3 "Disagree a little" 4 "Neither agree nor disagree" 5 "Agree a little" 6 "Agree moderately" 7 "Agree strongly" 
	* label value E1stem_A_7 E1stem_A_7l 
	* tab E1stem_A_7

	* label var QE1stem_A_3 "TIPI: dependable, self-disciplined"
	* label define QE1stem_A_3l 1 "Agree strongly" 2 "Agree moderately" 3 "Agree a little" 4 "Neither agree nor disagree" 5 "Disagree a little" 6 "Disagree moderately" 7 "Disagree strongly"
	* label value QE1stem_A_3 QE1stem_A_3l
	* tab QE1stem_A_3
	* gen E1stem_A_3  = QE1stem_A_3
	* recode E1stem_A_3 1=7 2=6 3=5 4=4 5=3 6=2 7=1 .=.
	* label define E1stem_A_3l 1 "Disagree strongly" 2 "Disagree moderately" 3 "Disagree a little" 4 "Neither agree nor disagree" 5 "Agree a little" 6 "Agree moderately" 7 "Agree strongly" 
	* label value E1stem_A_3 E1stem_A_3l 
	* tab E1stem_A_3

	* label var QE1stem_A_9 "TIPI: calm, emotionally stable"
	* label define QE1stem_A_9l 1 "Agree strongly" 2 "Agree moderately" 3 "Agree a little" 4 "Neither agree nor disagree" 5 "Disagree a little" 6 "Disagree moderately" 7 "Disagree strongly"
	* label value QE1stem_A_9 QE1stem_A_9l	
	* tab QE1stem_A_9
	* gen E1stem_A_9  = QE1stem_A_9
	* recode E1stem_A_9 1=7 2=6 3=5 4=4 5=3 6=2 7=1 .=.
	* label define E1stem_A_9l 1 "Disagree strongly" 2 "Disagree moderately" 3 "Disagree a little" 4 "Neither agree nor disagree" 5 "Agree a little" 6 "Agree moderately" 7 "Agree strongly" 
	* label value E1stem_A_9 E1stem_A_9l 
	* tab E1stem_A_9

	* label var QE1stem_A_5 "TIPI: open to new experiences, complex"
	* label define QE1stem_A_5l 1 "Agree strongly" 2 "Agree moderately" 3 "Agree a little" 4 "Neither agree nor disagree" 5 "Disagree a little" 6 "Disagree moderately" 7 "Disagree strongly"
	* label value QE1stem_A_5 QE1stem_A_5l
	* tab QE1stem_A_5
	* gen E1stem_A_5  = QE1stem_A_5
	* recode E1stem_A_5 1=7 2=6 3=5 4=4 5=3 6=2 7=1 .=.
	* label define E1stem_A_5l 1 "Disagree strongly" 2 "Disagree moderately" 3 "Disagree a little" 4 "Neither agree nor disagree" 5 "Agree a little" 6 "Agree moderately" 7 "Agree strongly" 
	* label value E1stem_A_5 E1stem_A_5l 
	* tab E1stem_A_5

	* label var QE1stem_A_4 "TIPI: anxious, easily upset"
	* label define QE1stem_A_4l 1 "Agree strongly" 2 "Agree moderately" 3 "Agree a little" 4 "Neither agree nor disagree" 5 "Disagree a little" 6 "Disagree moderately" 7 "Disagree strongly"
	* label value QE1stem_A_4 QE1stem_A_4l
	* tab QE1stem_A_4
	* gen E1stem_A_4  = QE1stem_A_4
	* recode E1stem_A_4 1=7 2=6 3=5 4=4 5=3 6=2 7=1 .=.
	* label define E1stem_A_4l 1 "Disagree strongly" 2 "Disagree moderately" 3 "Disagree a little" 4 "Neither agree nor disagree" 5 "Agree a little" 6 "Agree moderately" 7 "Agree strongly" 
	* label value E1stem_A_4 E1stem_A_4l 
	* tab E1stem_A_4

* Recoded extraversion to 0-1
	* gen extraversion = ((E1stem_A_1 + QE1stem_A_6)-2)/12
	* tab extraversion

* Recoded agreeableness to 0-1
	* gen agreeableness = ((QE1stem_A_2 + E1stem_A_7)-2)/12
	* tab agreeableness

* Recoded conscientiousness to 0-1
	* gen conscientiousness = ((E1stem_A_3 + QE1stem_A_8)-2)/12
	* tab conscientiousness

* Recoded emotional stability to 0-1
* Can reverse code this for neuroticism
	* gen emostab = ((QE1stem_A_4 + E1stem_A_9)-2)/12
	* tab emostab

*Recoded openness to 0-1
	* gen openness = ((E1stem_A_5 + QE1stem_A_10)-2)/12
	* tab openness
	
	* label var E1stem_A_1 "Reverse Code of QE1stem_A_1: TIPI extraverted, enthusiastic"
	* label var E1stem_A_3 "Reverse Code of QE1stem_A_3: TIPI dependable, self-disciplined"
	* label var E1stem_A_4 "Reverse Code of QE1stem_A_4: TIPI anxious, easily upset"
	* label var E1stem_A_5 "Reverse Code of QE1stem_A_5: TIPI open to new experiences"
	* label var E1stem_A_7 "Reverse Code of QE1stem_A_7: TIPI sympathetic, warm"
	* label var E1stem_A_9 "Reverse Code of QE1stem_A_9: TIPI calm, emotionally stable"
	
	* label var extraversion "TIPI Extraversion 0-1 (Avg of E1stem_A_1 & QE1stem_A_6)"
	* label var agreeableness "TIPI Agreeableness 0-1 (Avg of QE1stem_A_2 & E1stem_A_7)"
	* label var conscientiousness "TIPI Conscientiousness 0-1 (Avg of E1stem_A_3 & QE1stem_A_8)"
	* label var emostab "TIPI Emotional Stability 0-1 (Avg of QE1stem_A_4 & E1stem_A_9)"
	* label var openness "TIPI Openness 0-1 (Avg of E1stem_A_5 & QE1stem_A_10)"

* Analyses below include all 5 TIPI variables: 
* extraversion 
* agreeableness 
* conscientiousness 
* emostab 
* openness

************************
*** Authoritarianism ***
************************
* Authoritarianism index
* Varables are coded 0,1
* Independence, curiosity, self-reliance, and being considerate are low authoritarian
* Respect for elders, good manners, obedience, and well behaved are high authoritarian

* Respect for elders
	* label var QE4a "Authoritarianism: Independence or Respect for Elders"
	* label define QE4al 1 "Independence" 2 "Respect for Elders" 
	* label value QE4a QE4al
	* tab QE4a
	* gen E4a = QE4a
	* recode E4a 1=0 2=1
	* label define E4al 0 "Independence" 1 "Respect for elders"
	* label values E4a E4al
	* tab E4a

* Good manners
	* label var QE4b "Authoritarianism: Curiosity or Good Manners"
	* label define QE4bl 1 "Curiosity" 2 "Good Manners" 
	* label value QE4b QE4bl
	* tab QE4b
	* gen E4b = QE4b
	* recode E4b 1=1 2=0
	* label define E4bl 1 "Curiosity" 0 "Good manners"
	* label values E4b E4bl
	* tab E4b

* Obedience
	* label var QE4c "Authoritarianism: Obedience or Self-reliance"
	* label define QE4cl 1 "Obedience" 2 "Self-reliance" 
	* label value QE4c QE4cl
	* tab QE4c
	* gen E4c = QE4c
	* recode E4c 1=1 2=0
	* label define E4cl 1 "Obedience" 0 "Self-reliance"
	* label values E4c E4cl
	* tab E4c

* Well behaved
	* label var QE4d "Authoritarianism: Being Considerate or Well Behaved"
	* label define QE4dl 1 "Being Considerate" 2 "Well Behaved" 
	* label value QE4d QE4dl
	* tab QE4d
	* gen E4d = QE4d
	* recode E4d 1=0 2=1
	* label define E4dl 1 "Well behaved" 0 "Being considerate"
	* label values E4d E4dl
	* tab E4d

	* label var E4a "Auth 0-1 Recode of QE4a: Respect for Elders"
	* label var E4b "Auth 0-1 Recode of QE4b: Good Manners"
	* label var E4c "Auth 0-1 Recode of QE4c: Obedience"
	* label var E4d "Auth 0-1 Recode of QE4d: Well-Behaved"
	
* "auth" is the authoritarianism variable used in the analyses below
	* egen auth = rowmean (E4a E4b E4c E4d)
	* label var auth "Authoritarianism Scale 0-1 (Avg of E4a, E4b, E4c & E4d)"
	* tab auth

*************************
*** External Efficacy ***
*************************
* Combined QC13 and QC14 into an external efficacy index 
* The orders for each question were both rotated
* Coded such that higher values = more efficacy
* QC13_rev; QC14_rev

	* label var QC13_rev "How much do public officials care what people like you think?"
	* label define QC13_revl 1 "A great deal" 2 "A lot" 3 "A moderate amount" 4 "A little" 5 "Not at all"
	* label value QC13_rev QC13_revl
	
	* label var QC14_rev "How much can people like you affect what the govt does?"
	* label define QC14_revl 1 "A great deal" 2 "A lot" 3 "A moderate amount" 4 "A little" 5 "Not at all"
	* label value QC14_rev QC14_revl		

	* recode QC13_rev (1=5 "A great deal") (2=4 "A lot") (3=3 "A moderate amount") (4=2 "A little") (5=1 "Not at all") (.=.), generate(C13_rev_alt)
	* recode QC14_rev (1=5 "A great deal") (2=4 "A lot") (3=3 "A moderate amount") (4=2 "A little") (5=1 "Not at all") (.=.), generate(C14_rev_alt)
	
	* label var C13_rev_alt "Reverse Code of QC13_rev: public officials care what ppl like you think"
	* label var C14_rev_alt "Reverse Code of QC14_rev: can ppl like you affect what govt does"

	* gen eff1 = (C13_rev_alt-1)/4
	* tab eff1

	* gen eff2 = (C14_rev_alt-1)/4
	* tab eff2
	
	* label var eff1 "0-1 Recode of C13_rev_alt: public officials care what ppl like you think"
	* label var eff2 "0-1 Recode of C14_rev_alt: can ppl like you affect what govt does"

* "efficacy" is the external efficacy variable used in the analyses below
	* egen efficacy = rowmean(eff1 eff2)
	* label var efficacy "External Efficacy Index (Avg of eff1 & eff2)"
	* tab efficacy

**************************
*** Need for Cognition ***
**************************
* Branched questions combined into needcog; QE3a-d
	* label var QE3a "Do you like handling situations that require a lot of thinking?"
	* label define QE3al 1 "Like" 2 "Dislike" 3 "Neither like nor dislike"
	* label value QE3a QE3al

	* label var QE3b "Do you like situations requiring thinking a lot or somewhat?"
	* label define QE3bl 1 "A lot" 2 "Somewhat" 
	* label value QE3b QE3bl

	* label var QE3c "Do you dislike situations requiring thinking a lot or somewhat?"
	* label define QE3cl 1 "A lot" 2 "Somewhat" 
	* label value QE3c QE3cl
	
	* tab QE3a
	* tab QE3b
	* tab QE3c

	* gen needcog_alt = . 
	* replace needcog_alt = 1 if QE3c == 1
	* replace needcog_alt = 2 if QE3c == 2 
	* replace needcog_alt = 3 if QE3a == 3
	* replace needcog_alt = 4 if QE3b == 2
	* replace needcog_alt = 5 if QE3b == 1 

	* label var needcog_alt "Need for Cognition (Comb of Branched QE3a QE3b QE3c)"
	* label define needcog_altl 5 "Like a lot" 4 "Like somewhat" 3 "Neither like nor dislike" 2 "Dislike somewhat" 1 "Dislike a lot"
	* label values needcog_alt needcog_altl
	* tab needcog_alt

	* gen needcog = (needcog_alt-1)/4
	* label var needcog "0-1 Recode of needcog_alt: Need for Cognition"
	* tab needcog

* Simple vs. Complex problems (already labeled)
	* label var QE3d "Which type of problem do you prefer to solve: simple or complex?"
	* label define QE3dl 1 "Simple" 2 "Complex" 
	* label value QE3d QE3dl
	
	* tab QE3d
	* gen needcog2=QE3d
	* label var needcog2 "Recode of QE3d: Which type of problem do you prefer to solve"
	* label define needcog2l 1 "Simple" 2 "Complex" 
	* label value needcog2 needcog2l
	* tab needcog2

	* recode needcog2 (1=0 "Simple") (2=1 "Complex") (.=.), generate(complex)
	* recode needcog2 (1=1 "Simple") (2=0 "Complex") (.=.), generate(simple)
	* tab complex
	* tab simple
	* label var complex "0-1 Dummy of needcog2: Pref for solving complex problems"
	* label var simple "0-1 Dummy of needcog2: Pref for solving simple problems"

* The following code combines the 2 need cog questions and takes the average b/w the two 0-1 scales
* "needcog_comb" is the need for cognition variable used in the analyses below (only for MTurk analyses)
	* gen needcog_comb = (needcog+complex)/2
	* tab needcog_comb
	* sum needcog_comb, detail
	* label var needcog_comb "0-1 Need for Cognition (Avg of needcog & complex)"

************************
*** Need to Evaluate ***
************************
* 2 need to evaluate questions (E5) -  first kept separate, then combined 
* Higher values = higher need to evaluate * QE5a_rev; QE5c_rev
	
	* label var QE5a_rev "Opinions abt everything, many, some, or few things?"
	* label define QE5a_revl 1 "Almost everything" 2 "Many things" 3 "Some things" 4 "Very few things" 
	* label value QE5a_rev QE5a_revl
	* tab QE5a_rev
	* recode QE5a_rev (1=4 "Almost Everything") (2=3 "Many things") (3=2 "Some things") (4=1 "Very few things") (.=.), generate(QE5a_rev_alt)
	* tab QE5a_rev QE5a_rev_alt
	* label var QE5a_rev_alt "Reverse Code of QE5a_rev: Opinions abt everything, many, some, or few things?"
	
	* gen needeval = (QE5a_rev_alt-1)/3
	* label var needeval "0-1 Recode of QE5a_rev_alt: Opinions abt everything, many, some, or few things"
	* tab needeval

	* label var QE5c_rev "Do you have fewer, same, or more opinions abt whether things are good or bad?"
	* label define QE5c_revl 1 "Fewer opinions" 2 "About the same number of opinions" 3 "More opinions" 
	* label value QE5c_rev QE5c_revl

	* gen needeval2_new = (QE5c_rev-1)/2
	* label var needeval2_new "0-1 Recode of QE5c_rev: Opinions abt whether things are good or bad"
	* tab needeval2_new QE5c_rev

* "needeval_comb_alt" is the need to evaluate variable used in the analyses below
	* gen needeval_comb_alt = (needeval+ needeval2_new)/2
	* tab needeval_comb_alt
	* sum needeval_comb_alt, detail
	* label var needeval_comb_alt "0-1 Need to Evaluate (Avg of needeval & needeval2_new)"

*****************************
*** Ideological Extremity ***
*****************************
* The following command folds ideo7 without moderates to create an ideological extremity variable
	* recode ideo7 (1=3) (7=3) (2=2) (6=2) (3=1) (5=1) (4=.) (.=.), generate(idextr)
	* tab idextr
	* label var idextr "Reverse Code of ideo7: Ideological Extremity"
	* label define idextrl 1 "Slightly Ideological" 2 "Somewhat Ideological" 3 "Extremely Ideological" 
	* label value idextr idextrl

* On 0-1 scale
	* gen ideo_extr = (idextr-1)/2
	* tab ideo_extr
	* label var ideo_extr "0-1 Recode of idextr: Ideological Extremity"

* "ideo_extr" is the ideological extremity variable used in the analyses below

******************************
*** Federal Gov't Attitude ***
******************************
* MTurk analyses utilize a question about attitudes regarding federal government power
* QC20 was recoded: 0 = too little power, .5 = about right, 1 = too much power
	* label var QC20 "Fed govt has too much, about right amt, or too little power?"
	* label define QC20l 1 "Too much power" 2 "About the right amount of power" 3 "Too little power"
	* label value QC20 QC20l
	* gen fed_power = .
	* replace fed_power = 1 if QC20 == 1
	* replace fed_power = .5 if QC20 == 2
	* replace fed_power = 0 if QC20 == 3
	* label var fed_power "0-1 Reverse Code of QC20: Fed govt power"
	* tab fed_power

* "fed_power" is the federal government attitude variable used in the analyses below

*******************
*** Religiosity ***
*******************
* The original variable, QG8, was flipped so that higher numbers = more religious
	* label var QG8 "How would you classify your level of involvement with your religion or spirituality?"
	* label define QG8l 1 "Very active" 2 "Moderately active" 3 "Neither active nor inactive" 4 "Moderately inactive" 5 "Very inactive"
	* label value QG8 QG8l

	* recode QG8 (1=5 "Very active") (2=4 "Moderately active") (3=3 "Neither active nor inactive") (4=2 "Moderately inactive") (5=1 "Very inactive") (.=.), generate(G8)
	* label var G8 "Reverse Code of QG8: Level of involvement with religion or spirituality"
	* gen religiosity = (G8-1)/4
	* label var religiosity "0-1 Recode of G8: Level of religion or spirituality"
	* tab religiosity

* "religiosity" is the religiosity variable used in the analyses below

*****************
*** Education ***
*****************
* The following commands create the level of education variable used in the analyses below
	* label var QG11 "What is the highest level of school you have completed or the highest degree you have received?"
	* label define QG11L 1 "Less than 1st grade" 2 "1st, 2nd, 3rd, or 4th grade" 3 "5th or 6th grade" 4 "7th or 8th grade" 5 "9th grade" 6 "10th grade" 7 "11th grade" 8 "12th grade no diploma" 9 "High school graduate - high school diploma or equivalent (GED)" 10 "Some college but no degree" 11 "Associate degree" 12 "Bachelor's Degree" 13 "Master's Degree" 14 "Professional School Degree" 15 "Doctorate degree" 16 "Other, please specify"
	* label value QG11 QG11L
	* tab QG11
	* recode QG11 (1/8=1 "No HS diploma or GED") (9=2 "HS diploma or GED") (10/11=3 "Some college or Associate's") (12=4 "Bachelor's degree") (13/15=5 "Post-Bachelor's degree") (16=.) (.=.), generate(G11)
	* tab G11
	* label var G11 "Recode of QG11: Highest level of school or degree achieved (5 categories)"

* Education Recode 0-1
	* recode QG11 (1/9=1 "Up to and including HS diploma or GED") (10/11=2 "Some college or Associate's") (12=3 "Bachelor's degree") (13/15=4 "Post-Bachelor's degree") (16=.) (.=.), generate(G11_alt)
	* tab G11_alt
	* label var G11_alt "Recode of QG11: Highest level of school or degree achieved (4 categories)"
	* gen educ_alt = (G11_alt-1)/3
	* label var educ_alt "0-1 Recode of G11_alt: Level of education (4 category)"
	* tab educ_alt

* "educ_alt" is the level of education variable used in the analyses below

**************
*** Income ***
**************
* The following commands create the level of income variable used in the analyses below
* The original variable was collapsed into 5 categories
	* label var QG12 "What was your total HOUSEHOLD income in the past 12 months?"
	* label define QG12L 1 "Under $5,000" 2 "$5,000-9,999" 3 "$10,000-12,499" 4 "$12,500-14,999" 5 "$15,000-17,499" 6 "$17,500-19,999" 7 "$20,000-22,499" 8 "$22,500-24,999" 9 "$25,000-27,499" 10 "$27,500-29,999" 11 "$30,000-34,999" 12 "$35,000-39,999" 13 "$40,000-44,999" 14 "$45,000-49,999" 15 "$50,000-54,999" 16 "$55,000-59,999" 17 "$60,000-64,999" 18 "$65,000-69,999" 19 "$70,000-74,999" 20 "$75,000-79,999" 21 "$80,000-89,999" 22 "$90,000-99,999" 23 "$100,000-109,999" 24 "$110,000-124,999" 25 "$125,000-149,999" 26 "$150,000-174,999" 27 "$175,000-249,999" 28 "$250,000 or more"
	* label value QG12 QG12L
	* tab QG12
	* recode QG12 (1/4=1 "Under $15,000") (5/8=2 "$15,000-24,999") (9/14=3 "$25,000-49,999") (15/22=4 "$50,000-99,999") (23/28=5 "Over $100,000") (.=.), generate(G12)
	* tab G12
	* label var G12 "Recode of QG12: Household income last 12 months (5 categories)"

* "income" is the income variable used in the analyses below
	* gen income = (G12-1)/4
	* label var income "0-1 Recode of G12: Household Income"
	* tab income

**************
*** Gender ***
**************
* The following commands create the female dummy variable used in the analyses below
	* label var QG9 "Are you male or female?"
	* label define QG9L 1 "Male" 2 "Female" 
	* label value QG9 QG9L

	* gen female=.
	* replace female=0 if QG9==1
	* replace female=1 if QG9==2
	* replace female=. if QG9==.
	* label var female "Female Dummy Variable (Recode of QG9)"
	* label define femaleL 0 "Male" 1 "Female" 
	* label value female femaleL

	* tab female
	* sum female, detail

* "female" is the gender dummy variable used in the analyses below

***********
*** Age ***
***********
* The following commands first drop the one respondent younger than voting age, then place the age variable on a 0-1 scale
* age (18-81)
	* label var QG10_1 "What age did you turn on your most recent birthday?"
	* gen age=QG10_1
	* label var age "Recode of QG10_1: Age in Years"
	* drop if age==17
	* tab age
	* sum age
* Recoded age to 0-1
	* gen age_alt = (age-18)/63
	* label var age_alt "0-1 Recode of age: Age"
	* tab age_alt

* "age_alt" is the age variable used in the analyses below

**************
*** Latino ***
**************
* The following commands recode the demographic variable asking about identification as Spanish, Hispanic, or Latino 
	* label var QG14 "Are you Spanish, Hispanic, or Latino?"
	* label define QG14L 1 "No" 2 "Yes" 
	* label value QG14 QG14L
* To create the dummy variable:
	* gen latino=.
	* replace latino =1 if QG14 ==2
	* replace latino =0 if QG14 ==1
	* replace latino =. if QG14 ==.
	* label var latino "Spanish, Hispanic, or Latino Dummy Variable: Recode of QG14"
	* label define latinoL 1 "Spanish, Hispanic, or Latino" 0 "Other" 
	* label value latino latinoL
	* tab latino

* "latino" is the dummy variable for those who identified as Spanish, Hispanic, or Latino used in the analyses below

*************
*** White ***
*************
* The following commands create the "white/non-white" dummy variable
* race (white vs. other racial identities); QG15_1, QG15_2, QG15_3, QG15_4, QG15_5, QG15_6 
	* label var QG15_1 "Please choose one or more races that you consider yourself to be: White"
	* label var QG15_2 "Please choose one or more races that you consider yourself to be: Black or African-American"
	* label var QG15_3 "Please choose one or more races that you consider yourself to be: American Indian or Alaska Native"
	* label var QG15_4 "Please choose one or more races that you consider yourself to be: Asian"
	* label var QG15_5 "Please choose one or more races that you consider yourself to be: Native Hawaiian or other Pacific Islander"
	* label var QG15_6 "Please choose one or more races that you consider yourself to be: Other, please specify"

	* gen white=.
	* replace white = 1 if QG15_1 ==1
	* replace white = 0 if QG15_2 ==1 | QG15_3 ==1 | QG15_4 ==1 | QG15_5 ==1 | QG15_6 ==1 
	* label var white "White Dummy Variable: Recode of QG15_1-6"
	* label define whitel 1 "White" 0 "Other" 
	* label value white whitel
	* tab white 

* "white" is the race dummy variable used in the analyses below

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***************************
***************************
***************************
*** Dependent Variables ***
***************************
***************************
***************************

* Conspiracy Questions; Recoded variables 0-1, high levels = high endorsement

	* label var QB1 "Was Barack Obama born in the U.S."
	* label define QB1l 1 "Definitely born in the U.S." 2 "Probably born in the U.S." 3 "Probably born in another country" 4 "Definitely born in another country"
	* label value QB1 QB1l
	* gen conspiracy1 = (QB1-1)/3
	* label var conspiracy1 "0-1 Recode of QB1: Barack Obama born in the U.S."
	* tab conspiracy1 QB1
	* sum conspiracy1

	* label var QB2 "Does 2010 Health Care Act authorize panels to make end of life decisions?"
	* label define QB2l 1 "Definitely authorizes" 2 "Probably authorizes" 3 "Probably does not authorize" 4 "Definitely does not authorize"
	* label value QB2 QB2l
	* recode QB2 (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB2_alt)
	* tab QB2 QB2_alt
	* label var QB2_alt "Reverse Code of QB2: 2010 Health Care Act authorize deathpanels?"
	* label define QB2_altl 4 "Definitely authorizes" 3 "Probably authorizes" 2 "Probably does not authorize" 1 "Definitely does not authorize"
	* label value QB2_alt QB2_altl
	* gen conspiracy2 = (QB2_alt-1)/3
	* label var conspiracy2 "0-1 Recode of QB2_alt: 2010 Health Care Act authorizes deathpanels"
	* tab conspiracy2 QB2_alt
	* sum conspiracy2

	* label var QB3 "Did fed govt know about terrorist attacks on 9/11 before they happened?"
	* label define QB3l 1 "Definitely knew" 2 "Probably knew" 3 "Probably did not know" 4 "Definitely did not know"
	* label value QB3 QB3l
	* recode QB3 (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB3_alt)
	* tab QB3 QB3_alt
	* label var QB3_alt "Reverse Code of QB3: Fed govt knew abt 9/11 before it happened"
	* label define QB3_altl 4 "Definitely knew" 3 "Probably knew" 2 "Probably did not know" 1 "Definitely did not know"
	* label value QB3_alt QB3_altl
	* gen conspiracy3 = (QB3_alt-1)/3
	* label var conspiracy3 "0-1 Recode of QB3_alt: Fed govt knew abt 9/11 before it happened"
	* tab conspiracy3 QB3_alt
	* sum conspiracy3

	* label var QB5 "Did govt intentionally breach levees in H. Katrina to flood poor areas?"
	* label define QB5l 1 "Definitely did this" 2 "Probably did this" 3 "Probably did not do this" 4 "Definitely did not do this"
	* label value QB5 QB5l
	* recode QB5 (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB5_alt)
	* tab QB5 QB5_alt
	* label var QB5_alt "Reverse Code of QB5: Intentional levee breech in H. Katrina to flood poor areas"
	* label define QB5_altl 4 "Definitely did this" 3 "Probably did this" 2 "Probably did not do this" 1 "Definitely did not do this"
	* label value QB5_alt QB5_altl	
	* gen conspiracy5 = (QB5_alt-1)/3
	* label var conspiracy5 "0-1 Recode of QB5_alt: Intentional levee breech in H. Katrina to flood poor areas"
	* tab conspiracy5 QB5_alt
	* sum conspiracy5

	* label var QB7a_rev "Some believe global warming is a hoax. Others don't. You?"
	* label define QB7a_revl 1 "Global warming is definitely a hoax" 2 "Global warming is probably a hoax" 3 "Global warming is probably not a hoax" 4 "Global warming is definitely not a hoax"
	* label value QB7a_rev QB7a_revl
	
	* label var QB7aa_rev "Some believe climate change is a hoax. Others don't. You?"
	* label define QB7aa_revl 1 "Climate change is definitely a hoax" 2 "Climate change is probably a hoax" 3 "Climate change is probably a hoax" 4 "Climate change is definitely not a hoax"
	* label value QB7aa_rev QB7aa_revl
	
	* gen QB7_combrev = .
	* replace QB7_combrev = 1 if QB7a_rev==1 | QB7aa_rev==1
	* replace QB7_combrev = 2 if QB7a_rev==2 | QB7aa_rev==2
	* replace QB7_combrev = 3 if QB7a_rev==3 | QB7aa_rev==3
	* replace QB7_combrev = 4 if QB7a_rev==4 | QB7aa_rev==4
	* tab QB7_combrev
	* label var QB7_combrev "Combined QB7a_rev & QB7aa_rev: global warming/climate change hoax"
	* label define QB7_combrevL 1 "GW/CC is definitely a hoax" 2 "GW/CC is probably a hoax" 3 "GW/CC is probably a hoax" 4 "GW/CC is definitely not a hoax"
	* label value QB7_combrev QB7_combrevL
	
	* recode QB7_combrev (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB7_alt)
	* tab QB7_combrev QB7_alt
	* label var QB7_alt "Reverse Code of QB7_combrev: global warming/climate change hoax"
	* label define QB7_altl 4 "GW/CC is definitely a hoax" 3 "GW/CC is probably a hoax" 2 "GW/CC is probably a hoax" 1 "GW/CC is definitely not a hoax"
	* label value QB7_alt QB7_altl

	* gen conspiracy7 = (QB7_alt-1)/3
	* label var conspiracy7 "0-1 Recode of QB7_alt: Global warming/climate change is a hoax"
	* tab conspiracy7 QB7_alt
	* sum conspiracy7

	* label var QB8_rev "Bush Administration and weapons of mass destruction in Iraq"
	* label define QB8_revl 1 "Definitely misled the public" 2 "Probably misled the public" 3 "Probably did not mislead the public" 4 "Definitely did not mislead the public"
	* label value QB8_rev QB8_revl	
	* recode QB8_rev (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB8_alt)
	* tab QB8_rev QB8_alt
	* label var QB8_alt "Reverse Code of QB8_rev: Bush Admin and WMDs in Iraq"
	* label define QB8_altl 4 "Definitely misled the public" 3 "Probably misled the public" 2 "Probably did not mislead the public" 1 "Definitely did not mislead the public"
	* label value QB8_alt QB8_altl	
	* gen conspiracy8 = (QB8_alt-1)/3
	* label var conspiracy8 "0-1 Recode of QB8_alt: Bush Admin and WMDs in Iraq"
	* tab conspiracy8 QB8_alt
	* sum conspiracy8

	* label var QB9_rev "Some believe Saddam Hussein was involved in 9/11. You?"
	* label define QB9_revl 1 "Definitely did this" 2 "Probably did this" 3 "Probably did not do this" 4 "Definitely did not do this"
	* label value QB9_rev QB9_revl
	* recode QB9_rev (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB9_alt)
	* tab QB9_rev QB9_alt
	* label var QB9_alt "Reverse Code of QB9_rev: Saddam Hussein involved in 9/11"
	* label define QB9_altl 4 "Definitely did this" 3 "Probably did this" 2 "Probably did not do this" 1 "Definitely did not do this"
	* label value QB9_alt QB9_altl
	* gen conspiracy9 = (QB9_alt-1)/3
	* label var conspiracy9 "0-1 Recode of QB9_alt: Saddam Hussein involved in 9/11"
	* tab conspiracy9 QB9_alt
	* sum conspiracy9

	* label var QB11_rev "Some think Republicans stole 2004 pres election w/ voter fraud"
	* label define QB11_revl 1 "Definitely stole the 2004 election" 2 "Probably stole the 2004 election" 3 "Probably did not sealt the 2004 election" 4 "Definitely did not steal the 2004 election"
	* label value QB11_rev QB11_revl
	* recode QB11_rev (1=4) (2=3) (3=2) (4=1) (.=.), generate(QB11_alt)
	* tab QB11_rev QB11_alt
	*label var QB11_alt "Reverse Code of QB11_rev: Reps stole 2004 election w/ voter fraud"
	* label define QB11_altl 4 "Definitely stole the 2004 election" 3 "Probably stole the 2004 election" 2 "Probably did not sealt the 2004 election" 1 "Definitely did not steal the 2004 election"
	* label value QB11_alt QB11_altl
	* gen conspiracy11 = (QB11_alt-1)/3
	* label var conspiracy11 "0-1 Recode of QB11_alt: Reps stole 2004 election w/ voter fraud"
	* tab conspiracy11 QB11_alt
	* sum conspiracy11

* Conspiracy sub-indices, using row means for:
* Conservative Conspiracy Index:	
* a) Q1, Q2, Q7, Q9 (the conservative conspiracy questions)
	* egen con_index_rep2 = rowmean (conspiracy1 conspiracy2 conspiracy7 conspiracy9)
	* label var con_index_rep2 "Conservative Conspiracy Index (Avg of conspiracy1 conspiracy2 conspiracy7 conspiracy9)"
	* tab con_index_rep2
	* sum con_index_rep2, detail

* Liberal Conspiracy Index:
* b) Q3, Q5, Q8, Q11 (the liberal conspiracy questions)
	* egen con_index_dem4 = rowmean (conspiracy3 conspiracy5 conspiracy8 conspiracy11)
	* label var con_index_dem4 "Liberal Conspiracy Index (Avg of conspiracy3 conspiracy5 conspiracy8 conspiracy11)"
	* tab con_index_dem4
	* sum con_index_dem4, detail

* "con_index_rep2" is the dependent variable measuring the Conservative Conspiracy Index in the analyses below
* "con_index_dem4" is the dependent variable measuring the Liberal Conspiracy Index in the analyses below

* Dependent variable for the unrelated regression analyses below
	* gen negdemindex=-1*con_index_dem4
	* label var negdemindex "DV for Unrelated Regression (-1*con_index_dem4)"

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

* The following descriptions and analyses follow the order of the article, unless otherwise noted. 

*******************************************
*******************************************
*******************************************
*** Description of Studies and Measures ***
*******************************************
*******************************************
*******************************************

*******************
*** MTurk Study ***
*******************

* MTurk N for liberals and conservatives
tab Conservative

* Dependent variables, see above

* Explanatory variables, see above

* Reliability of knowledge index:
alpha f1_alt f2_alt f3_alt f4_alt f5_alt f6_alt f7_alt f8_alt f9_alt f10_alt f11_alt f12_alt f13_alt f14_alt

* Reliability of trust index:
alpha trust_govt trust_police trust_media trust_people

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***************
***************
***************
*** Results ***
***************
***************
***************

**************************************************************************
*** A Snapshot of the Two Datasets: More Similarities than Differences ***
**************************************************************************

* See Appendix B below for Descriptive Statistics for Demographics – MTurk and ANES

* Knowledge means/standard deviations for conservatives and liberals
	* Liberals
sum polknow_alt if Conservative==0
	* Conservatives
sum polknow_alt if Conservative==1

* Trust means/standard deviations for conservatives and liberals
* Standardized MTurk trust index to compare with ANES standardized trust index
	* Conservatives
sum trust_comb_std if Conservative == 1
	* Liberals
sum trust_comb_std if Conservative == 0

******************************************************************************************
*** H1: Conservatives Endorse Ideologically-Consistent Conspiracies More than Liberals ***
******************************************************************************************

* See Table 1
* See Table 2 (columns 1-4)

* Unrelated Regression Analyses
svyset _n
svy: reg con_index_rep2 Conservative polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income female age_alt latino white
estimates store dv1

svy: reg negdemindex Conservative polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income female age_alt latino white
estimates store dv2

suest dv1 dv2, svy

test [dv1]Conservative=[dv2]Conservative

********************************************
*** H2: The Moderating Role of Knowledge ***
********************************************

* See Table 2 (columns 5-8) and Figure 1 

************************************************************
*** H3: The Joint Moderating Role of Knowledge and Trust ***
************************************************************

* See Table 2 (columns 9-12) and Figures 2 and 3


****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

**************
**************
**************
*** Tables ***
**************
**************
************** 

************************************************************************************************
************************************************************************************************
************************************************************************************************
*** Table 1. Means on Conspiracy Items and Indices Separately for Conservatives and Liberals ***
************************************************************************************************
************************************************************************************************
************************************************************************************************

* Conservative Conspiracy Index - conspiracy1 conspiracy2 conspiracy7 conspiracy9
	* conspiracy1 - Was Barack Obama born in the U.S.?
robvar conspiracy1, by(Conservative)
ttest conspiracy1, by(Conservative) level(95) unequal
	* conspiracy2 - Death panels?
robvar conspiracy2, by(Conservative)
ttest conspiracy2, by(Conservative) level(95) unequal
	* conspiracy7 - Global Warming/Climate Change
robvar conspiracy7, by(Conservative)
ttest conspiracy7, by(Conservative) level(95) unequal
	* conspiracy9 - Saddam Hussein was involved in 9/11
robvar conspiracy9, by(Conservative)
ttest conspiracy9, by(Conservative) level(95) unequal

robvar  con_index_rep2, by(Conservative)
ttest con_index_rep2, by(Conservative) level(95) unequal

* Liberal Conspiracy Index - conspiracy3 conspiracy5 Conspiracy8 conspiracy11
	* conspiracy5 - Fed gov't intentionally breached flood levees during Hurricane Katrina
robvar conspiracy5, by(Conservative)
ttest conspiracy5, by(Conservative) level(95)
	* conspiracy3 - Gov't knew about 9/11 prior to attacks
robvar conspiracy3, by(Conservative)
ttest conspiracy3, by(Conservative) level(95) unequal
	* conspiracy11 - Republicans stole the 2004 presidential election
robvar conspiracy11, by(Conservative)
ttest conspiracy11, by(Conservative) level(95)
	* conspiracy8 - WMDs in Iraq
robvar conspiracy8, by(Conservative)
ttest conspiracy8, by(Conservative) level(95) unequal

robvar con_index_dem4, by(Conservative)
ttest con_index_dem4, by(Conservative) level(95) unequal


*************************************************************
*************************************************************
*************************************************************
*** Table 2. Effect of Ideology, Knowledge, Trust, and their Interactions on Conspiracy Endorsement 
*************************************************************
*************************************************************
*************************************************************

**************************
*** Main Effect Models ***
**************************
	* Conservative Conspiracy Index
reg con_index_rep2 Conservative ///
polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store m1
	* Liberal Conspiracy Index
reg con_index_dem4 Conservative ///
polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store m3

******************************************************
*** 2-way Interactive Models with Ideo x Knowledge ***
******************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 i.Conservative##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store m5
	* Liberal Conspiracy Index
reg con_index_dem4 i.Conservative##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store m7

**************************************************************
*** 3-way Interactive Models with Ideo x Knowledge x Trust ***
**************************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 i.Conservative##c.trust_comb##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store m9
	* Liberal Conspiracy Index
reg con_index_dem4 i.Conservative##c.trust_comb##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store m11

* Where m2, m4, m6, m8, m10, and m12 are estimates from ANES.do
* esttab m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 using "Table 2.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)
* Table 2 reflects our variables of interest. Control variables were not reported within the table in-text.
* These models are provided in full within the Online Appendix.

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***************
***************
***************
*** Figures ***
***************
***************
*************** 

***************************************************************************************************************************************
***************************************************************************************************************************************
***************************************************************************************************************************************
*** Figure 1. Effect of Knowledge on Endorsement of Conservative Conspiracy Theories (Conservative Index) *****************************
*** for Conservatives and Liberals and on Endorsement of Liberal Conspiracy Theories (Liberal Index) for Conservatives and Liberals ***
***************************************************************************************************************************************
***************************************************************************************************************************************
***************************************************************************************************************************************

******************************************************
*** 2-way Interactive Models with Ideo x Knowledge ***
******************************************************
	* Conservative Index
reg con_index_rep2 i.Conservative##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
margins, dydx(polknow_alt) at(Conservative=(0(1)1))

margins, at(polknow_alt=(0(.1)1)) over(Conservative)
marginsplot, title("MTurk", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Conservative Index") ///
	legend(textfirst) ///
	text(.49 .5 ".07 (.03)") ///
    text(.18 .5 "-.30 (.02)") ///
	scheme(s1mono)
graph save conpolknow_con_mturk_bw.gph, replace

	* Liberal Index
reg con_index_dem4 i.Conservative##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
margins, dydx(polknow_alt) at(Conservative=(0(1)1))

margins, at(polknow_alt=(0(.1)1)) over(Conservative)
marginsplot, title("MTurk", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Liberal Index") ///
	legend(textfirst) ///
	text(.56 .5 "-.04 (.03)") ///
    text(.32 .5 "-.28 (.04)") ///
	scheme(s1mono)
graph save lib4polknow_con_mturk_bw.gph, replace

* To combine graphs for Figure1:
	* gr combine conpolknow_con_mturk_bw.gph conpolknow_con_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("Conservative Conspiracy Index", col(white) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure1_comb_conpolknow_con_anesmturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

	* gr combine lib4polknow_con_mturk_bw.gph libpolknow_con_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("Liberal Conspiracy Index", col(white) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure1_comb_libpolknow_con_anesmturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************
*** Figure 2. Effect of Knowledge on Endorsement of Conservative Conspiracy Theories (Conservative Index) *** 
*** for Conservatives and Liberals Separately for Respondents Low and High in Generalized Trust ************* 
*************************************************************************************************************
*************************************************************************************************************
*************************************************************************************************************

**************************************************************
*** 3-way Interactive Models with Ideo x Knowledge x Trust ***
**************************************************************
	* Conservative Index
	* Low Trust
reg con_index_rep2 i.Conservative##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==0
margins, dydx(polknow_alt) at(Conservative=(0(1)1))

margins, at(polknow_alt=(0(.1)1)) over(Conservative)
marginsplot, title("Low Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Conservative Index") ///
	legend(textfirst) ///	
	text(.51 .5 ".12 (.04)") ///
    text(.18 .5 "-.29 (.03)") ///
	scheme(s1mono)
graph save conpolknow_con_lowtrust_mturk_bw.gph, replace

	* High Trust
reg con_index_rep2 i.Conservative##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==1
margins, dydx(polknow_alt) at(Conservative=(0(1)1))

margins, at(polknow_alt=(0(.1)1)) over(Conservative)
marginsplot, title("High Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Conservative Index", col(white)) ///
	legend(textfirst) ///	
	text(.48 .5 "-.08 (.06)") ///
    text(.17 .5 "-.30 (.04)") ///
	scheme(s1mono)
graph save conpolknow_con_hightrust_mturk_bw.gph, replace

* To combine graphs for Figure2:
	* gr combine conpolknow_con_lowtrust_mturk_bw.gph conpolknow_con_hightrust_mturk_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("MTurk", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure2a_comb_conpolknow_con_highlow_mturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

	* gr combine conpolknow_con_lowtrust_anes_bw.gph conpolknow_con_hightrust_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("ANES", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure2b_comb_conpolknow_con_highlow_anes_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

***************************************************************************************************
***************************************************************************************************
***************************************************************************************************
*** Figure 3. Effect of Knowledge on Endorsement of Liberal Conspiracy Theories (Liberal Index) ***
*** for Conservatives and Liberals Separately for Respondents Low and High in Generalized Trust *** 
***************************************************************************************************
***************************************************************************************************
***************************************************************************************************

**************************************************************
*** 3-way Interactive Models with Ideo x Knowledge x Trust ***
**************************************************************
	* Liberal Index
	* Low Trust
reg con_index_dem4 i.Conservative##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==0
margins, dydx(polknow_alt) at(Conservative=(0(1)1))

margins, at(polknow_alt=(0(.1)1)) over(Conservative)
marginsplot, title("Low Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Liberal Index") ///
	legend(textfirst) ///
	text(.60 .5 "-.06 (.04)") ///
    text(.33 .5 "-.28 (.05)") ///
	scheme(s1mono)
graph save lib4polknow_con_lowtrust_mturk_bw.gph, replace

	* High Trust
reg con_index_dem4 i.Conservative##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==1
margins, dydx(polknow_alt) at(Conservative=(0(1)1))

margins, at(polknow_alt=(0(.1)1)) over(Conservative)
marginsplot, title("High Trust", col(black) nospan) xtitle(Political Knowledge) recast(line) recastci(rline) legend(rows(1)) ///
	ci1opts(lpat(dash) lcol(gs7)) ///
	ci2opts(lpat(dash) lcol(gs7)) ///
	plot1opts(lwidth(thick)) ///
	plot2opts(lwidth(thick)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25).75, angle(0) labsize(small)) ///
	xlab(0 "Low" 1 "High", labsize(small)) ///
	ytitle("Liberal Index", col(white)) ///
	legend(textfirst) ///
	text(.51 .5 "-.01 (.04)") ///
    text(.25 .5 "-.24 (.07)") ///
	scheme(s1mono)
graph save lib4polknow_con_hightrust_mturk_bw.gph, replace

* To combine graphs for Figure3:
	* gr combine lib4polknow_con_lowtrust_mturk_bw.gph lib4polknow_con_hightrust_mturk_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("MTurk", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure3a_comb_lib4polknow_con_highlow_mturk_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

	* gr combine libpolknow_con_lowtrust_anes_bw.gph libpolknow_con_hightrust_anes_bw.gph, ycommon altshrink graphregion(fcolor(white) lcolor(white)) title("ANES", col(black) size(medium)) note("Values beside each simple slope represent respective unstandardized regression coefficients and standard errors")
	* graph save Figure3b_comb_libpolknow_con_highlow_anes_bw.gph, replace
* Within graph editor, right legend offset x by 30 and contents hidden; left legend was moved to center (offset x by 50).

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

*************************
*************************
*************************
*** Footnote Analyses ***
*************************
*************************
*************************

******************
*** Footnote 2 ***
******************
* Iterated principal components analysis 
factor conspiracy1 conspiracy2 conspiracy7 conspiracy9 conspiracy3 conspiracy5 conspiracy8 conspiracy11
factor conspiracy1 conspiracy2 conspiracy7 conspiracy9 conspiracy3 conspiracy5 conspiracy8 conspiracy11, ipf
factor conspiracy1 conspiracy2 conspiracy7 conspiracy9 conspiracy3 conspiracy5 conspiracy8 conspiracy11, ipf blanks(.30)
factor conspiracy1 conspiracy2 conspiracy7 conspiracy9 conspiracy3 conspiracy5 conspiracy8 conspiracy11, ipf factors(2)
factor conspiracy1 conspiracy2 conspiracy7 conspiracy9 conspiracy3 conspiracy5 conspiracy8 conspiracy11, ipf factors(2) blanks(.30)

******************
*** Footnote 7 ***
******************
* See Appendix C

******************
*** Footnote 9 ***
******************
* See Online Appendix for tables of full models

*******************
*** Footnote 11 ***
*******************
* Another way to display the shape of the three-way interaction on the conservative index 
* is to examine the (continuous) trust x (continuous) knowledge two-way interaction separately for conservatives and liberals
* Conservative Conspiracy Index
	* For Conservatives:
reg con_index_rep2 c.polknow_alt##c.trust_comb ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white if Conservative==1
	* For Liberals:
reg con_index_rep2 c.polknow_alt##c.trust_comb ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white if Conservative==0

*******************
*** Footnote 12 ***
*******************
* See Online Appendix Tables 4 and 5 for party identification models

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

******************
******************
******************
*** Appendix B ***
******************
******************
******************

* Table reports demographics limited to liberals and conservatives in the sample.
* Moderates are not included within this table. 
sum age if Conservative == 1 | Conservative == 0
tab female if Conservative == 1 | Conservative == 0
tab white if Conservative == 1 | Conservative == 0
tab educ_alt if Conservative == 1 | Conservative == 0
tab income if Conservative == 1 | Conservative == 0
tab latino if Conservative == 1 | Conservative == 0

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

******************
******************
******************
*** Appendix C ***
******************
******************
******************

* Cell Percentages and Counts for Ideology Cross-tabbed with Low and High-Knowledge and Trust – MTurk and ANES
* Reports crosstabs by high/low splits
* The coding for the high/low trust and knowledge splits are above.
bysort Conservative: tab trusthighlow_alt polknow_hl, col cell row

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************

***********************
***********************
***********************
*** Online Appendix ***
***********************
***********************
***********************

*****************************************************************************
*** Online Appendix Table 1. Effect of Ideology on Conspiracy Endorsement ***
*****************************************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 Conservative ///
polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store a1
	* Liberal Conspiracy Index
reg con_index_dem4 Conservative ///
polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store a3

* Where a2 and a4 are estimates from ANES.do
* esttab a1 a2 a3 a4 using "Online Appendix Table 1.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

***************************************************************************************
*** Online Appendix Table 2. Knowledge x Ideology Predicting Conspiracy Endorsement ***
***************************************************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 i.Conservative##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store b1
	* Liberal Conspiracy Index
reg con_index_dem4 i.Conservative##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store b3

* Where b2 and b4 are estimates from ANES.do
* esttab b1 b2 b3 b4 using "Online Appendix Table 2.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

***********************************************************************************************
*** Online Appendix Table 3. Knowledge x Trust x Ideology Predicting Conspiracy Endorsement ***
***********************************************************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 i.Conservative##c.trust_comb##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store c1
	* Liberal Conspiracy Index
reg con_index_dem4 i.Conservative##c.trust_comb##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt ideo_extr fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store c3

* Where c2 and c4 are estimates from ANES.do
* esttab c1 c2 c3 c4 using "Online Appendix Table 3.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

***************************************************************************************************************
*** Online Appendix Table 4. Effect of Party Identification, Knowledge, and Trust on Conspiracy Endorsement ***
***************************************************************************************************************
**************************
*** Main Effect Models ***
**************************
	* Conservative Conspiracy Index
reg con_index_rep2 pid6 ///
polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store d1
	* Liberal Conspiracy Index
reg con_index_dem4 pid6 ///
polknow_alt trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store d3
*****************************************************
*** 2-way Interactive Models with PID x Knowledge ***
*****************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 c.pid6##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store d5
	* Liberal Conspiracy Index
reg con_index_dem4 c.pid6##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store d7
*************************************************************
*** 3-way Interactive Models with PID x Knowledge x Trust ***
*************************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 c.pid6##c.polknow_alt##c.trust_comb ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white 
estimates store d9
	* Liberal Conspiracy Index
reg con_index_dem4 c.pid6##c.polknow_alt##c.trust_comb ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
estimates store d11

* Where d2, d4, d6, d8, d10, and d12 are estimates from ANES.do
* esttab d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 using "Online Appendix Table 4.rtf", se ar2 replace starlevels(* 0.05) b(2) se(2)

********************************************************************************************************************************************************
*** Online Appendix Table 5. Simple Slopes for Political Knowledge Predicting Conspiracy Endorsement Across Levels of Party Identification and Trust ***
********************************************************************************************************************************************************
*****************************************************
*** 2-way Interactive Models with PID x Knowledge ***
*****************************************************
	* Conservative Conspiracy Index
reg con_index_rep2 c.pid6##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
margins, dydx(polknow_alt) at(pid6=(0(.2)1))	
	* Liberal Conspiracy Index
reg con_index_dem4 c.pid6##c.polknow_alt ///
trust_comb extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white
margins, dydx(polknow_alt) at(pid6=(0(.2)1))	
*************************************************************
*** 3-way Interactive Models with PID x Knowledge x Trust ***
*************************************************************
	* Conservative Conspiracy Index - Low Trust
reg con_index_rep2 c.pid6##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==0
margins, dydx(polknow_alt) at(pid6=(0(.2)1))	
	* Conservative Conspiracy Index- High Trust
reg con_index_rep2 c.pid6##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==1
margins, dydx(polknow_alt) at(pid6=(0(.2)1))	
	* Liberal Conspiracy Index - Low Trust
reg con_index_dem4 c.pid6##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==0
margins, dydx(polknow_alt) at(pid6=(0(.2)1))	
	* Liberal Conspiracy Index - High Trust
reg con_index_dem4 c.pid6##c.polknow_alt ///
extraversion agreeableness conscientiousness emostab openness ///
auth efficacy needcog_comb needeval_comb_alt fed_power religiosity educ_alt income /// 
female age_alt latino white if trusthighlow_alt==1
margins, dydx(polknow_alt) at(pid6=(0(.2)1))

****************************************************************************************************
****************************************************************************************************
****************************************************************************************************
