// Recoding sponsor bias data
// last revision: 15 October 2018 by Thomas

//cleaning the data
	drop name responseset externaldatareference emailaddress
	drop if status != 0
	drop if consent != 1

//date
	split startdate, generate(begin) limit(2)
	split enddate, generate(end) limit(2)
	gen surveydate=date(begin1,"MD20Y")
	format surveydate %td

// experimental condition
	encode condition, generate(condition1)
	label define conditionlabel 1 "Control" ///
								2 "Marketing (Heavy)" ///
								3 "Marketing (Light)" ///
								4 "University (Heavy)" ///
								5 "University (Light)"
	label values condition1 conditionlabel
	
	//gen condition2=.
	//replace condition2 = 1 if condition1 == 2
	//replace condition2 = 2 if condition1 == 3
	//replace condition2 = 2 if condition1 == 4
	//replace condition2 = 3 if condition1 == 5
	//replace condition2 = 3 if condition1 == 6
	//label define cond 1 "control" 2 "marketing" 3 "university"
	//label values condition2 cond	

// experience stratum

	gen stratum1 = .
	replace stratum1 = 1 if stratum2 == "<100"
	replace stratum1 = 2 if stratum2 == "100-500"
	replace stratum1 = 3 if stratum2 == "500-1000"
	replace stratum1 = 4 if stratum2 == "1000-2000"
	replace stratum1 = 5 if stratum2 == ">2000"
	label var stratum1 "Stratum1"
	drop stratum2
	
	
	gen stratum2 = .
	replace stratum2 = 1 if stratum == "<100"
	replace stratum2 = 2 if stratum == "100-500"
	replace stratum2 = 3 if stratum == "500-1000"
	replace stratum2 = 4 if stratum == "1000-2000"
	replace stratum2 = 5 if stratum == ">2000"
	replace stratum2 = 6 if stratum == ">5000"
	label var stratum2 "Stratum2"
	drop stratum
		
	gen stratum3 = .
	replace stratum3 = 2 if stratum1 >= 4
	replace stratum3 = 1 if stratum1 < 4
	
	
	
// Voting (social desirability)
	
	gen votedsum = voted_1 + voted_2 + voted_3 + voted_4 + voted_5
	
// other social desirable political behaviors
	
	recode socialdes_1 (1=1) (else=0), gen(sd1)
	recode socialdes_2 (1=1) (else=0), gen(sd2)
	recode socialdes_3 (1=1) (else=0), gen(sd3)
	recode socialdes_4 (else=0), gen(sd4)
	recode socialdes_5 (else=0), gen(sd5)
	recode socialdes_6 (else=0), gen(sd6)
	recode socialdes_7 (1=1) (else=0), gen(sd7)
	recode socialdes_8 (else=0), gen(sd8)
	recode socialdes_9 (else=0), gen(sd9)
	recode socialdes_10 (1=0) (else=1), gen(sd10)
	
	gen sdsum = (sd1 + sd2 + sd3 + sd7 + sd10)/5
	
	
// list experiments

	/* We need to work on how these are coded. 
	   There's a lot of messy free response-ness. */

	gen lista1 = .
	replace lista1 = 0 if dlea1 == "0"
	replace lista1 = 1 if dlea1 == "1"
	replace lista1 = 1 if dlea1 == "One"
	replace lista1 = 1 if dlea1 == "one"
	replace lista1 = 2 if dlea1 == "2"
	replace lista1 = 2 if dlea1 == "Two"
	replace lista1 = 3 if dlea1 == "3"
	replace lista1 = 3 if dlea1 == "Three"
	replace lista1 = 4 if dlea1 == "4"
	label variable lista1 "list experiment 1a (five items)"
	
	gen lista2 = .
	replace lista2 = 0 if dlea2 == "0"
	replace lista2 = 0 if dlea2 == "none"
	replace lista2 = 1 if dlea2 == "1"
	replace lista2 = 1 if dlea2 == "One"
	replace lista2 = 1 if dlea2 == "one"
	replace lista2 = 2 if dlea2 == "2"
	replace lista2 = 2 if dlea2 == "Two"
	replace lista2 = 3 if dlea2 == "3"
	replace lista2 = 3 if dlea2 == "Three"
	label variable lista2 "list experiment 2a (four items)"
	
	gen listb1 = .
	replace listb1 = 0 if dleb1 == "0"
	replace listb1 = 0 if dleb1 == "none"
	replace listb1 = 1 if dleb1 == "1"
	replace listb1 = 1 if dleb1 == "One"
	replace listb1 = 1 if dleb1 == "one"
	replace listb1 = 2 if dleb1 == "2"
	replace listb1 = 2 if dleb1 == "Two"
	replace listb1 = 2 if dleb1 == "two"
	replace listb1 = 3 if dleb1 == "3"
	replace listb1 = 3 if dleb1 == "Three"
	label variable listb1 "list experiment 1b (five items)"

	gen listb2 = .
	replace listb2 = 0 if dleb2 == "0"
	replace listb2 = 0 if dleb2 == "none"
	replace listb2 = 1 if dleb2 == "1"
	replace listb2 = 1 if dleb2 == "one"
	replace listb2 = 2 if dleb2 == "2"
	replace listb2 = 2 if dleb2 == "Two"
	replace listb2 = 2 if dleb2 == "two"
	replace listb2 = 3 if dleb2 == "3"
	replace listb2 = 4 if dleb2 == "4"
	label variable listb2 "list experiment 2b (four items)"
	
	gen list1 = .
	replace list1 = lista1 if lista1 != .
	replace list1 = listb1 if listb1 != .
	label variable list1 "list experiment 1"
	
	gen list2 = .
	replace list2 = lista2 if lista2 != .
	replace list2 = listb2 if listb2 != .
	label variable list2 "list experiment 2"
	
	/* for between-subjects list experiment, compare lista1 to listb1 and lista2 to listb2 */
	*summ lista1 lista2 listb1 listb2
	gen listcondition1 = .
	replace listcondition1 = 1 if lista1 != .
	replace listcondition1 = 0 if listb1 != .
	label variable listcondition1 "list 1 treatment"
	gen listcondition2 = .
	replace listcondition2 = 0 if lista2 != .
	replace listcondition2 = 1 if listb2 != .
	label variable listcondition2 "list 2 treatment"
	label define listlabel 0 "Control" 1 "Treatment"
	label values listcondition1 listcondition2 listlabel
	
	
	
	/* within-subjects list experiment */
	gen listA = .
	replace listA = lista1-lista2
	label variable listA "list experiment A"
	
	gen listB = .
	replace listB = listb2-listb1
	label variable listB "list experiment B"
	
	gen listAB = listA
	replace listAB = listB if listAB == .
	label variable listAB "within-subjects list experiment"
	
	drop listA listB
	
	
// good subject

	/*encode the good subjects, including sysmis*/
	
	/*treatment group*/
	gen good1 = q93
	replace good1 = . if good1 == 3
	gen good2 = q94
	replace good2 = . if good2 == 3
	gen good3 = q95
	replace good3 = . if good3 == 3 
	gen good4 = q96
	replace good4 = . if good4 == 3
	gen good5 = q97
	replace good5 = . if good5 == 3
	gen good6 = q98
	replace good6 = . if good6 == 3
	gen good7 = q99
	replace good7 = . if good7 == 3
	gen good8 = q100
	replace good8 = . if good8 == 3
	gen good9 = q101
	replace good9 = . if good9 == 3
	gen good10 = q102
	replace good10 = . if good10 == 3
	
	/*control group*/
	gen good11 = gs1
	replace good11 = . if good11 == 3
	gen good12 = gs2
	replace good12 = . if good12 == 3
	gen good13 = gs3
	replace good13 = . if good13 == 3 
	gen good14 = gs4
	replace good14 = . if good14 == 3
	gen good15 = gs5
	replace good15 = . if good15 == 3
	gen good16 = gs6
	replace good16 = . if good16 == 3
	gen good17 = gs7
	replace good17 = . if good17 == 3
	gen good18 = gs8
	replace good18 = . if good18 == 3
	gen good19 = gs9
	replace good19 = . if good19 == 3
	gen good20 = gs10
	replace good20 = . if good20 == 3
	
	/*encode randomization to figure out which one is on the left*/
	
	encode doqq93, gen(good1_o)
	encode doqq94, gen(good2_o)
	encode doqq95, gen(good3_o)
	encode doqq96, gen(good4_o)
	encode doqq97, gen(good5_o)
	encode doqq98, gen(good6_o)
	encode doqq99, gen(good7_o)
	encode doqq100, gen(good8_o)
	encode doqq101, gen(good9_o)
	encode doqq102, gen(good10_o)

	encode doqgs1, gen(good11_o)
	encode doqgs2, gen(good12_o)
	encode doqgs3, gen(good13_o)
	encode doqgs4, gen(good14_o)
	encode doqgs5, gen(good15_o)
	encode doqgs6, gen(good16_o)
	encode doqgs7, gen(good17_o)
	encode doqgs8, gen(good18_o)
	encode doqgs9, gen(good19_o)
	encode doqgs10, gen(good20_o)
	
	/*give value of 1 if they chose the lefthand option, 0 if not*/
	
	gen onleft1=good1
	replace onleft1=0 if onleft1 != good1_o
	replace onleft1=1 if onleft1==2
	gen onleft2=good2
	replace onleft2=0 if onleft2 != good2_o
	replace onleft2=1 if onleft2==2
	gen onleft3=good3
	replace onleft3=0 if onleft3 != good3_o
	replace onleft3=1 if onleft3==2
	gen onleft4=good4
	replace onleft4=0 if onleft4 != good4_o
	replace onleft4=1 if onleft4==2
	gen onleft5=good5
	replace onleft5=0 if onleft5 != good5_o
	replace onleft5=1 if onleft5==2
	gen onleft6=good6
	replace onleft6=0 if onleft6 != good6_o
	replace onleft6=1 if onleft6==2
	gen onleft7=good7
	replace onleft7=0 if onleft7 != good7_o
	replace onleft7=1 if onleft7==2
	gen onleft8=good8
	replace onleft8=0 if onleft8 != good8_o
	replace onleft8=1 if onleft8==2
	gen onleft9=good9
	replace onleft9=0 if onleft9 != good9_o
	replace onleft9=1 if onleft9==2
	gen onleft10=good10
	replace onleft10=0 if onleft10 != good10_o
	replace onleft10=1 if onleft10==2

	gen onleft11=good11
	replace onleft11=0 if onleft11 != good11_o
	replace onleft11=1 if onleft11==2
	gen onleft12=good12
	replace onleft12=0 if onleft12 != good12_o
	replace onleft12=1 if onleft12==2
	gen onleft13=good13
	replace onleft13=0 if onleft13 != good13_o
	replace onleft13=1 if onleft13==2
	gen onleft14=good14
	replace onleft14=0 if onleft14 != good14_o
	replace onleft14=1 if onleft14==2
	gen onleft15=good15
	replace onleft15=0 if onleft15 != good15_o
	replace onleft15=1 if onleft15==2
	gen onleft16=good16
	replace onleft16=0 if onleft16 != good16_o
	replace onleft16=1 if onleft16==2
	gen onleft17=good17
	replace onleft17=0 if onleft17 != good17_o
	replace onleft17=1 if onleft17==2
	gen onleft18=good18
	replace onleft18=0 if onleft18 != good18_o
	replace onleft18=1 if onleft18==2
	gen onleft19=good19
	replace onleft19=0 if onleft19 != good19_o
	replace onleft19=1 if onleft19==2
	gen onleft20=good20
	replace onleft11=0 if onleft20 != good20_o
	replace onleft11=1 if onleft20==2

	gen gstreatment = 1 if gstreat == 1
	replace gstreatment = 0 if gscontrol == 1
	gen onleft_sum1 = onleft1 + onleft2 + onleft3 + onleft4 + onleft5 + onleft6 + onleft7 + onleft8 + onleft9 + onleft10
	gen onleft_sum2 = onleft11 + onleft12 + onleft13 + onleft14 + onleft15 + onleft16 + onleft17 + onleft18 + onleft19 + onleft20
	gen onleft_sum = onleft_sum1
	replace onleft_sum = onleft_sum2 if onleft_sum2 != .
	

//Political knowledge open-ended questions

	/*For each of these I made three variables: the actual estimate, the error
	(absolute distance from correct number), and a dichotomous version (with 
	some wiggle room, described in labels).*/ 

	//unemployment
	
	replace unemp = . if unemp==99
	label variable unemp "estimate of unemployment rate"

	gen unemp_error = abs(5.7-unemp)
	label variable unemp_error "absolute error of unemp estimate"
	
	gen unemp2 = 0
	replace unemp2 = 1 if (unemp <= 5.8) & (unemp >= 5.6)
	replace unemp2 = . if (unemp==.)  
	label variable unemp2 "dichotomous correct unemp estimate (between 5.6 and 5.8)"

	//number of people w 4-year college ed
	
	label variable college "percent of Americans with college education"
	
	gen college_round = round(college, 1)
	label variable college_round "rounded to nearest whole number"
	
	gen college_error = abs(34-college_round)
	label variable college_error "absolute error of college estimate"
	
	gen college2 = 0
	replace college2 = 1 if (college_round <= 35) & (college_round >= 33)
	replace college2 = . if (college_round==.)
	label variable college2 "dichot correct college estimate (btwn 33 and 35)" 

	//number of states with gay marriage
	
	replace states = . if states==99
	replace states = . if states > 50
	label variable states "number of states with gay marriage"
	
	gen states_error = abs(37-states)
	label variable states_error "absolute error of gay marriage estimate"
	
	gen states2 = 0
	replace states2 = 1 if (states <= 38) & (states >= 36)
	replace states2 = . if (states==.)
	
//Political knowledge closed-ended questions

	replace pres = . if pres>2
	label variable pres "how many terms can the President serve"

	replace const = . if const>2.
	label variable const "what are the first 10 amendments to the constitution called"

	replace cons = . if cons>2.
	label variable cons "which party is more conservative"

	replace senator = . if senator>2.
	label variable senator "how long does a Senator serve"

	replace judge = . if judge>2.
	label variable judge "who nominates judge to federal court"

	gen know_pol = (pres+const+cons+senator+judge)
	label variable know_pol "number of correct political knowledge answers"
	
//Political interest

	replace interest2 = . if interest2 > 5
	gen polinterest = (interest2-1)/4
	
//Recall of Staci Appel facts

	gen appelcount = length(recall4)
	label variable appelcount "total characters in appel recall"

	replace appel = . if appel==99.
	label variable appel "number of correct things recalled about appel"

	replace appelwrong = . if appelwrong==99.
	label variable appelwrong "number of incorrect things recalled about appel"

//General/science knowledge closed-ended questions

	recode genknow_1 (1=1) (else = 0), gen(know1) // XY chromosome
	recode genknow_2 (2=1) (else = 0), gen(know2) // antibiotics
	recode genknow_3 (1=1) (else = 0), gen(know3) // big bang
	recode genknow_4 (1=1) (else = 0), gen(know4) // earth's core
	recode genknow_5 (1=1) (else = 0), gen(know5) // continental drift
	recode genknow_6 (2=1) (else = 0), gen(know6) // radioactivity
	recode genknow_7 (2=1) (else = 0), gen(know7) // lasers
	recode genknow_8 (1=1) (else = 0), gen(know8) // electrons

	gen know_gen = know1 + know2 + know3 + know4 + know5 + know6 + know7 + know8
	label variable know_gen "number of correct science knowledge answers"

//DKs on political knowledge questions

	gen know_pol_dk1 = 0
	replace know_pol_dk1 = 1 if polknow1 == 2
	gen know_pol_dk2 = 0
	replace know_pol_dk2 = 1 if polknow2 == 2
	gen know_pol_dk3 = 0
	replace know_pol_dk3 = 1 if polknow3 == 2
	gen know_pol_dk4 = 0
	replace know_pol_dk4 = 1 if polknow4 == 2
	gen know_pol_dk5 = 0
	replace know_pol_dk5 = 1 if polknow5 == 2

	gen know_pol_dk = (know_pol_dk1 + know_pol_dk2 + know_pol_dk3 + know_pol_dk4 + know_pol_dk5)/5
	label variable know_pol_dk "number of political knowledge DKs"
	
//DKs on general knowledge questions

	gen know_gen_dk1 = 0
	replace know_gen_dk1 = 1 if genknow_1 == 3
	gen know_gen_dk2 = 0
	replace know_gen_dk2 = 1 if genknow_2 == 3
	gen know_gen_dk3 = 0
	replace know_gen_dk3 = 1 if genknow_3 == 3
	gen know_gen_dk4 = 0
	replace know_gen_dk4 = 1 if genknow_4 == 3
	gen know_gen_dk5 = 0
	replace know_gen_dk5 = 1 if genknow_5 == 3
	gen know_gen_dk6 = 0
	replace know_gen_dk6 = 1 if genknow_6 == 3
	gen know_gen_dk7 = 0
	replace know_gen_dk7 = 1 if genknow_7 == 3
	gen know_gen_dk8 = 0
	replace know_gen_dk8 = 1 if genknow_8 == 3
	
	gen know_gen_dk = (know_gen_dk1 + know_gen_dk2 + know_gen_dk3 ///
	                   + know_gen_dk4 + know_gen_dk5 + know_gen_dk6 ///
					   + know_gen_dk7 + know_gen_dk8)/8
	label variable know_gen_dk "number of science knowledge DKs"

//Self-reported cheating on knowledge questions

	recode cheat_gen (2=0)
	recode cheat_pol (2=0)
	

//Question timing

	gen timing_appel=q72_1

	
//Evaluation of the survey etc

	//how much they think they should have gotten paid 
	//replace pay2 = . if pay2==99.
	
	/* I suspect answers over 100 (there are two 100's and one 150) are actually
	missing decimal points, and recoded as such below but we could also drop 
	or topcode */
	// I've updated this for anything over 75; again problems in the earlier data conversion
	
	replace pay2 = pay2/100 if pay2 >= 75
	label variable pay2 "how much they should have been paid for the MTurk survey"

	//evaluations of the relevant institutions

	gen eval_univ1 = orgratings_1
	replace eval_univ1=. if eval_univ1==100
	label variable eval_univ1 "Favorability - Universities" 
	
	gen eval_univ2 = orgratings_4
	replace eval_univ2=. if eval_univ2==100
	label variable eval_univ2 "Favorability - Colleges" 

	egen eval_univ = rowmean(eval_univ1 eval_univ2)
	label variable eval_univ "Favorability - Colleges and Universities"

	gen eval_market = orgratings_3
	replace eval_market=. if eval_market==100
	label variable eval_market "Favorability - Market Research Companies" 

	//evaluation of survey
	recode survey (6 = .)
	
	//permission to email
	recode email (2 = 0)

// Experience stratum: stratum1
	label define stratumlabel   1 "Under 100 HITs" ///
								2 "100-500 HITs" ///
								3 "500-1000 HITs" ///
								4 "1000-2000 HITs" ///
								5 "Over 2000 HITs"
	label values stratum1 stratumlabel
	
	
// demographics

	// age
	replace age="" if age == "."
	drop if age == "33N1S8XHHM5UCD92E6Q237PAGQCZ1C"
	destring age, gen(age2)
	summ age2, detail
	label var age2 "Age"
	
	// sex (1 = male; 2 = female)
	tab sex
	label var sex "Female"
	
	// race (1 = white; 2 = black; 3 = asian; 4 = hispanic; 5 = native; 6 = other)
	tab race
	label var race "Race"
	
	// education (1 = 1-8; 2 = high school; 3 = 12 or GED; 4 = trade school; 5 = college; 6 = BA; 7 = > BA)
	replace education = "" if education == "."
	destring education, gen(education2)
	tab education2
	summ education2, detail
	label var education2 "Education"
	
	// partyid (1 = Strong Dem; 7 = Strong Rep)
	replace partyid = "" if partyid == "."
	destring partyid, gen(partyid2)
	tab partyid2
	summ partyid2, detail
	label var partyid2 "Party ID (Republican)"
	
	// ideology (1 = Extremely liberal; 7 = Extremely conservative)
	tab ideology
	summ ideology, detail
	label var ideology "Ideology (Conservative)"

// variable labels

	label var votedsum "Reported Past Voting"

	label var sdsum "Reported Good Behaviors"
	
	label var polinterest "Political Interest"
	
	gen temp = listcondition1
	label define listtemplabel 0 "Control" 1 "Treatment"
	label values temp listtemplabel
	label var list1 "List Experiment A"
	label var list2 "List Experiment B"
	label var listAB "List Experiment A/B"
	
	label define goodsublabel 0 "Control" 1 "Treatment"
	label values gstreatment goodsublabel
	label var onleft_sum "Good Subjects Behavior"
	
	label var appelcount "Information Recall (Characters)"
	label var appelwrong "Information Recall (Incorrect)"
	label var timing_appel "Information Recall (Timing)"
	
	label var check5_5 "Attention Check"
	
	label var know_pol "Political Knowledge (Total)"
	label var know_pol_dk "Political Knowledge (DKs)"
	
	label var know_gen "General Knowledge (Total)"
	label var know_gen_dk "General Knowledge (DKs)"
	
	label var cheat_pol "Cheating: Political Knowledge"
	label var cheat_gen "Cheating: General Knowledge"
	
	label var email "Willing to Receive Email"
	label var survey "Survey Rating"
	label var pay2 "Fair Compensation"
	
	label var eval_univ "Evaluation of Universities"
	label var eval_market "Evaluation of Marketing Firms"

	