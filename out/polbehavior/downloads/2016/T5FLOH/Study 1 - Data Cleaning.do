******************************************************
************** Data Cleaning File for Study 1: SSI 
************** The following do file provides the code
************** for the independent and dependent variables
************** used in analyzing Study 1 and should be run
************** before replicating those analyses 
**************************************
**************************************
**************************************


		*********Demographics & Controls*******
		
	*Sex*
		gen gender = . 
		replace gender = 1 if Sex == 2
		replace gender = 0 if Sex == 1
		label var gender "R's Gender"
		label def gen 1 "Female" 0 "Male"
		label values gender gen
		tab gender
		
	*Race*
		gen race = . 
		replace race = 1 if Race == 1
		replace race = 2 if Race == 2
		replace race = 3 if Race == 3
		replace race = 4 if Race == 4
		replace race = 5 if Race >= 5 & Race <= 6
		label var race "R's Racial ID"
		label def rac 1 "White" 2 "African American" 3 "Asian American" 4 "Hispanic" 5 "Other"
		label values race rac
	
	*Age*
		*Note: 1 respondent indicated they are under 18; 
		*this person is lumped in with the 18-24 sample*
		gen age = . 
		replace age = 1 if Age >= 1 & Age <= 2
		replace age = 2 if Age == 3
		replace age = 3 if Age == 4
		replace age = 4 if Age == 5
		replace age = 5 if Age == 6
		label var age "R's Age (Categorical)"
		label def agecat 1 "18-24" 2 "25-34" 3 "35-50" 4 "51-65" 5 "65+"
		label values age agecat
		tab age
	
	*Education*
		gen educ = .
		replace educ = 1 if Ed == 1
		replace educ = 2 if Ed == 2
		replace educ = 3 if Ed >=3 & Ed <=4
		replace educ = 4 if Ed >= 5 & Ed <= 8
		label var educ "R's Education"
		label def educat 1 "<HS" 2 "HS Grad" 3 "Some Coll/2 Year Degree" 4 "Bachelor + "
		label values educ educat
		tab educ

	*Income*
		label var income "R's Annual Income"
		label def inc 1 "< 20,000" 2 "20-29,999" 3 "30-39,999" 4 "40-49,999" 5 "50-59,999" 6 "60-69,999" 7 "70-79,999" 8 "80-89,999" 9 "90,000+"
		label values income inc
		summ income, detail
		tab income

	*Political Interest*
		label var interest "R's Political Interest"
		label def inte 1 "Not at All" 2 "Somewhat" 3 "Interested" 4 "Very Interested"
		label values interest inte
		summ interest
		tab interest
		
		
	*Ideology*
		rename ideo ideology
		label var ideology "R's Ideology"
		label def ide 1 "Ext. Liberal" 2 "Liberal" 3 "Slightly Liberal" 4 "Moderate" 5 "Slightly Conservative" 6 "Conservative" 7 "Ext. Conservative"
		label values ideology ide
		summ ideology
		tab ideology
		
		
		gen ideology_3 = .
		replace ideology_3 = 1 if ideology >= 1 & ideology <= 3
		replace ideology_3 = 2 if ideology == 4
		replace ideology_3 = 3 if ideology >=5 & ideology <=7
		label var ideology_3 "Ideology (Categorical)"
		label def ideo3 1 "Liberal" 2 "Moderate" 3 "Conservative"
		label values ideology_3 ideo3
		tab ideology_3
	

	*PID*
		*Note: 185 people said something else or don't know; those who said something else
		*received a follow up (PartyOther). 
		*looking at the responses, basically nobody offered a specific party*
		*these individuals are excluded from the below variables*
		gen pid1 = .
		replace pid1 = 1 if Party == 2 & PartySt == 1
		replace pid1 = 2 if Party == 2 & PartySt == 2
		replace pid1 = 3 if Party == 3 & PartyInd == 2
		replace pid1 = 4 if Party == 3 & PartyInd == 3
		replace pid1 = 5 if Party == 3 & PartyInd == 1
		replace pid1 = 6 if Party == 1 & PartySt == 2
		replace pid1 = 7 if Party == 1 & PartySt == 1
		label var pid1 "R's PID"
		label def piddef 1 "Str. Dem" 2 "Not Very Strong D" 3 "Lean D" 4 "Pure Ind." 5 "Lean R" 6 "Not Very Strong R" 7 "Strong R"
		label values pid1 piddef
		tab pid1 
		summ pid1
		
		gen pid_3 = . 
		replace pid_3 = 1 if pid1 >=1 & pid1 <= 3
		replace pid_3 = 2 if pid1 == 4
		replace pid_3 = 3 if pid1 >= 5 & pid1 <=7
		label var pid_3 "R's PID (Simplified)"
		label def piddef1 1 "Democrat" 2 "Pure Independent" 3 "Republican"
		label values pid_3 piddef1
		tab pid_3
		
	*PID Importance*
		rename PtyImp pid_imp
		label var pid_imp "PID Importance"
		label def pidimp 1 "Not Important at All" 4 "Not Sure" 7 "Very Important"
		label values pid_imp pidimp
		summ pid_imp
		tab pid_imp
		
		
	*Political Trust/Cynicism*
		*coded so that negative values, e.g. distrust = high*
		label var untrust "Most Politicians are Untrustworthy"
		label def untr 1 "Str. Disagree" 2 " Disagree" 3 "Neither Agree Nor Disagree" 4 "Agree" 5 "Str. Agree"
		label values untrust untr
		
		gen honor1 = . 
		replace honor1 = 1 if honor == 5
		replace honor1 = 2 if honor == 4
		replace honor1 = 3 if honor == 3
		replace honor1 = 4 if honor == 2
		replace honor1 = 5 if honor == 1
		label var honor1 "In gen., politicians are honorable people"
		label def hono 1 "Str. Agree" 2 "Agree" 3 "Neither" 4 "Disagree" 5 "Str. Disagree"
		label values honor1 hono
		
		summ untrust honor1
		tab untrust
		tab honor1
		pwcorr untrust honor1, sig
		alpha untrust honor1
		
		egen trust_mean = rowmean(untrust honor1)
		label var trust_mean "Mean of Untrust and Honor"
		summ trust_mean
		
	*Importance of Dream Act Isusue Attitude*
		label var dream_imp "How Important is Issue of Dream Act/Immigration Reform"
		label def dimp 1 "Not at all" 2 "Slightly" 3 "Moderately" 4 "Very" 5 "Extremely"
		label values dream_imp dimp
		tab dream_imp
		summ dream_imp
		
			
			**************Outcome Variables & Variables of Interest*********
			**************Thermometer; Traits; Dream Act Issue Attitudes; Motives; Account Satisfaction*******
			
		*Feeling Thermometer
			rename therm_1 therm
			label var therm "Feeling Thermometer toward Cand. A"
			summ therm, detail
			histogram therm, normal
			
			su therm, meanonly
			gen therm01 = (therm - r(min))/(r(max)-r(min))
			label var therm01 "Feeling Thermometer (0-1)"
			
		*Traits & Traits Index
			*coding the individual traits*
			label def traits_label 1 "Strongly Disagree" 2 "Disagree" 3 "Neither" 4 "Agree" 5 "Str. Agree"
			
			gen honest1 = honest
			replace honest1 = . if honest1 == 9
			label var honest1 "Cand. is honest (no dk)"
			label values honest1 traits_label
			tab honest honest1
			
			gen intel = inteligent
			replace intel = . if intel == 9
			label var intel "Cand. is intelligent (no dk)"
			label values intel traits_label
			tab intel inteligent
			
			gen leader1 = leader
			replace leader1 = . if leader1 == 9
			label var leader1 "Cand. is a strong leader"
			label values leader1 traits_label
			tab leader1 leader
							
			gen open1 = open
			replace open1 = . if open1 == 9
			label var open1 "Cand. is open-minded"
			label values open1 traits_label
			tab open1 open
				
			gen compass = comp
			replace compass = . if compass == 9
			label var compass "Cand. is compassionate"
			label values compass traits_label
			tab compass comp
				
				***Note: respondents were also asked about the morality of the represntative
				***but there was a coding error on qualtrics - both strongly agree and disagree
				***were coded as 5; this variable is not used in any analyses as a result
					
			*Relationship among the traits & traits index
				pwcorr honest1 intel leader1 open1 compass, sig
				
				factor honest1 intel leader1 open1 compass, pcf
				rotate
				
				alpha honest1 intel leader1 open1 compass
				
				egen traits = rowmean(honest1 intel leader1 open1 compass)
				label var traits "Candidate Trait Rating"
				
				su traits, meanonly
				gen traits01 = (traits - r(min))/(r(max)-r(min))
				label var traits01 "Traits Index (0-1)"
		
		*Traits and Therm: Factor Variable
			factor therm honest1 intel leader1 open1 compass, pcf
			rotate
			predict factor1
			rename factor1 eval
			label var eval "Candidate A Evaluation"
	
		*Dream Act Issue Attitude
			label var dream "Support or Oppose Dream Act" 
			label def dre 1 "Strongly Support" 2 "Mod. Support" 3 "Somewhat Support" 4 "Neither" 5 "Somewhat Oppose" 6 "Mod. Oppose" 7 "Str. Oppose"
			label values dream dre
			
			gen dream1 = . 
			replace dream1 = 1 if dream >=1 & dream <=3 
			replace dream1 = 2 if dream == 4
			replace dream1 = 3 if dream >=5 & dream <= 7
			label var dream1 "Support or Oppose Dream Act (Cat.)"
			label def dre1 1 "Support" 2 "Neither" 3 "Oppose"
			label values dream1 dre1
			
			tab dream
			summ dream
			tab dream1
			
			gen dream_reverse = abs(7 - dream)+1
			label var dream_reverse "Dream Act Attitude (Higher = Support)"
			gen dream_reverse1 = dream_reverse - 4
			label var dream_reverse1 "Dream Act Attitude"
		
		
		*Motives
			label var help_all "Desire to Help All Americans"
			label var office "Desire to Win Office/Re-Election"
			label var influence "Desire to Increase Political Influence"
			label var help_con "Desire to Help Constituents"
			label var pander "To Pander to Voters"
			label def moti 1 "Ext. Unimportant" 2 "Mod. Unimportant" 3 "Somewhat Unimportant" 4 "Neither" 5 "Somewhat Important" 6 "Mod. Important" 7 "Ext. Important"
			label values help_all moti
			label values office moti
			label values influence moti
			label values help_con moti
			label values pander moti
	
	
			pwcorr help_all office influence help_con pander, sig 
			factor help_all office influence help_con pander, pcf
			
			egen motives_political = rowmean(office influence pander)
			egen motives_help = rowmean(help_all help_con)
			label var motives_political "Avg. Index of Political Motives"
			label var motives_help "Avg. Index of Helping Motives"
			
			su motives_political, meanonly
			gen political01 = (motives_political - r(min))/(r(max)-r(min))
			su motives_help, meanonly
			gen help01 = (motives_help - r(min))/(r(max)-r(min))
			label var political01 "Political Motives (0-1)"
			label var help01 "Representation Motives (0-1)"
			
			*Factor analyses: used in analyses*
				factor help_all office influence help_con pander, pcf
				rotate
				predict factor1 factor2
				rename factor1 polmotives_f
				label var polmotives_f "Political Motives (Factor)"
				rename factor2 helpmotives_f
				label var helpmotives_f "Rep. Motives (Factor)"
			
		*Account Satisfaction/Acceptance
			
			*Satisfaction: only for those in the repositioning/accounts condition
			label var satis_c "Satisfaction with Account for Change in Position"
			label def sati 1 "Very Dis." 2 "Mod. Dis" 3 "Somewhat Dis." 4 "Neither" 5 "Somewhat Satis." 6 "Mod. Satis" 7 "Very Satis"
			label values satis_c sati
			
			label var satis_no "Satisfaction with Account (Consistent)"
			label values satis_no sati
			
			*satisfaction for those in repositioning/accounts and 
			*consistent/accounts condition*
			gen satisfaction = . 
			replace satisfaction = 1 if satis_c == 1
			replace satisfaction = 2 if satis_c == 2
			replace satisfaction = 3 if satis_c == 3
			replace satisfaction = 4 if satis_c == 4
			replace satisfaction = 5 if satis_c == 5
			replace satisfaction = 6 if satis_c == 6
			replace satisfaction = 7 if satis_c == 7
			replace satisfaction = 1 if satis_no == 1
			replace satisfaction = 2 if satis_no == 2
			replace satisfaction = 3 if satis_no == 3
			replace satisfaction = 4 if satis_no == 4
			replace satisfaction = 5 if satis_no == 5
			replace satisfaction = 6 if satis_no == 6
			replace satisfaction = 7 if satis_no == 7
			label var satisfaction "Satisfaction with Account (All)"
			label def satisfac 1 "Very Dis." 2 "Mod. Dis." 3 "Somewhat Dis." 4 "Neither" 5 "Somewhat Satis." 6 "Mod. Satis." 7 "Very Satisfied"
			label values satisfaction satisfac
		
			
			**************Exp. Conditions*********
	
	*Full 12 condition categorical variable
		gen condition = .
		replace condition = 1 if JoshGroup == "C1: Pro, Pro; No Account"
		replace condition = 2 if JoshGroup == "C2: Con, Con; No Account"
		replace condition = 3 if JoshGroup == "C3: Pro, Con; No Account"
		replace condition = 4 if JoshGroup == "C4: Con, Pro; No Account"
		replace condition = 5 if JoshGroup == "C5: Pro, Pro: Societal Fairness"
		replace condition = 6 if JoshGroup == "C6: Con, Con: Societal Fairness"
		replace condition = 7 if JoshGroup == "C7: Pro, Con: Societal Fairness"
		replace condition = 8 if JoshGroup == "C8: Con, Pro: Societal Fairness"
		replace condition = 9 if JoshGroup == "C9: Pro, Pro: Comparison"
		replace condition = 10 if JoshGroup == "C10: Con, Con: Comparison"
		replace condition = 11 if JoshGroup == "C11: Pro, Con: Comparison"
		replace condition = 12 if JoshGroup == "C12: Con, Pro: Comparison"
		label var condition "Exp. Condition" 
		label def cond 1 "C1: Pro, Pro; No Account" 2 "C2: Con, Con; No Account" 3 "C3: Pro, Con; No Account" 4 "C4: Con, Pro; No Account" 5 "C5: Pro, Pro: Societal Fairness" 6 "C6: Con, Con: Societal Fairness" 7 "C7: Pro, Con: Societal Fairness" 8 "C8: Con, Pro: Societal Fairness" 9 "C9: Pro, Pro: Comparison" 10 "C10: Con, Con: Comparison" 11 "C11: Pro, Con: Comparison" 12 "C12: Con, Pro: Comparison"
		label values condition cond
		
	
	*Consistent vs. Inconsistent*
		gen inconsistent = .
		replace inconsistent = 0 if condition == 1
		replace inconsistent = 0 if condition == 2
		replace inconsistent = 0 if condition == 5
		replace inconsistent = 0 if condition == 6
		replace inconsistent = 0 if condition == 9
		replace inconsistent = 0 if condition == 10
		replace inconsistent = 1 if condition == 3
		replace inconsistent = 1 if condition == 4
		replace inconsistent = 1 if condition == 7
		replace inconsistent = 1 if condition == 8
		replace inconsistent = 1 if condition == 11
		replace inconsistent = 1 if condition == 12
		label var inconsistent "Inconsistent Candidate?"
		label def consis 0 "Consistent" 1 "Inconsistent" 
		label values inconsistent consis
		
	*Received Account*
		gen account = .
		replace account = 1 if condition >=5 & condition <= 12
		replace account = 0 if condition >=1 & condition <= 4
		label var account "Received Account?" 
		label def acc 1 "Received Account" 0 "Did Not"
		label values account acc
		
		gen account1 = .
		replace account1 = 1 if condition >=1 & condition <= 4
		replace account1 = 2 if condition >=5 & condition <= 8
		replace account1 = 3 if condition >= 9 & condition <= 12
		label var account1 "Received (Which) Account?"
		label def acc1 1 "Did Not" 2 "Soc. Fairness" 3 "Comparison"
		label values account1 acc1
	
		gen account2 = . 
		replace account2 = 1 if account1 == 2
		replace account2 = 0 if account1 == 3
		label var account2" Type of Account" 
		label def acc3 1 "Soc. Fairness" 0 "Comparison" 
		label values account2 acc3
		
	*Repositioned & Account Reception Categorical Variable - used in analyses*

		gen incon_acc = . 
		replace incon_acc = 1 if condition >=1 & condition <= 2
		replace incon_acc = 2 if condition >=5 & condition <=6
		replace incon_acc = 2 if condition >=9 & condition <=10
		replace incon_acc = 3 if condition >=3 & condition <= 4
		replace incon_acc = 4 if condition >=7 & condition< = 8
		replace incon_acc = 4 if condition >= 11 & condition <=12
		label def in1 1 "Consistent & No Account" 2 "Consistent & Account" 3 "Repositioned & No Account" 4 "Repositioned & Account"
		label values incon_acc in1 
		label var incon_acc "Repositioned & Justification Status"
			
		gen incon_acc2 = .
		replace incon_acc2 = 1 if incon_acc == 1
		replace incon_acc2 = 2 if incon_acc == 2
		replace incon_acc2 = 3 if incon_acc == 3
		replace incon_acc2 = 4 if incon_acc == 4 & account2 == 1
		replace incon_acc2 = 5 if incon_acc == 4 & account2 == 0
		label var incon_acc2 "Repositioned & Specific Justification Status"
		label def incon_a 1 "Con./No Acc." 2 "Con/Acc." 3 "Incon/No Acc" 4 "Incon/Soc. Fair" 5 "Incon/Compare"
		label values incon_acc2 incon_a

		gen incon_acc4 = .
		replace incon_acc4 = 1 if incon_acc2 == 1
		replace incon_acc4 = 2 if incon_acc2 == 3
		replace incon_acc4 = 3 if incon_acc2 == 4
		replace incon_acc4 = 4 if incon_acc2 == 5
		label def iacc4aa 1 "Consistent" 2 "Repositioneed (NA)" 3 "Repositioned(SF)" 4 "Repositioned (CO)"
		label var incon_acc4 "Repositioned & Specific Justification Status"
		label values incon_acc4 iacc4aa

	*Position history & proximity (for persuasion analyses and moderation analyses in the online appendix
		gen pos2 = . 
		replace pos2 = 1 if condition >=1 & condition <= 2
		replace pos2 = 2 if condition == 7
		replace pos2 = 3 if condition == 8
		replace pos2 = 4 if condition == 11
		replace pos2 = 5 if condition == 12
			label def po2 1 "Consistent Candidate" 2 "Support to Oppose (Soc. F)" 3 "Oppose to Support (Soc. F)" 4 "Support to Oppose (Comp.)" 5 "Oppose to Support (Comp.)"
				label values pos2 po2
				label var pos2 "Position History"
			
			
		gen pos = .
		replace pos = 1 if condition == 1 & dream >=  1 & dream <= 3
		replace pos = 1 if condition == 2 & dream >= 5 & dream <= 7
		replace pos = 1 if condition == 3 & dream >=  5 & dream <= 7
		replace pos = 1 if condition == 4 & dream >=  1 & dream <= 3
		replace pos = 1 if condition == 7 & dream >=  5 & dream <= 7
		replace pos = 1 if condition == 8 & dream >=  1 & dream <= 3
		replace pos = 1 if condition == 11 & dream >=  5 & dream <= 7
		replace pos = 1 if condition == 12 & dream >=  1 & dream <= 3
		replace pos = 2 if condition == 1 & dream >= 5 & dream <= 7
		replace pos = 2 if condition == 2 & dream >= 1 & dream <= 3
		replace pos = 2 if condition == 3 & dream >= 1 & dream <= 3
		replace pos = 2 if conditio == 4 & dream >= 5 & dream <= 7
		replace pos = 2 if condition == 7 & dream >= 1 & dream <= 3
		replace pos = 2 if conditio == 8 & dream >= 5 & dream <= 7
		replace pos = 2 if condition == 11 & dream >= 1 & dream <= 3
		replace pos = 2 if conditio == 12 & dream >= 5 & dream <= 7
		replace pos = 3 if dream == 4 & condition >= 1 & condition <= 4
		replace pos = 3 if dream == 4 & condition >= 7 & condition <= 8
		replace pos = 3 if dream == 4 & condition >= 11 & condition <= 12
		label var pos "Final Issue Match"
		label def posit 1 "Same Position" 2 "Different Position" 3 "Neither"
		label values pos posit

		gen prox4 = . 
		replace prox4 = 1 if dream1 == 1 & condition == 1
		replace prox4 = 1 if dream1 == 3 & condition == 2
		replace prox4 = 2 if dream1 == 1 & condition == 2
		replace prox4 = 2 if dream1 == 3 & condition == 1
		replace prox4 = 3 if dream1 == 1 & condition == 4
		replace prox4 = 3 if dream1 == 3 & condition == 3
		replace prox4 = 1 if dream1 == 1 & condition == 5
		replace prox4 = 1 if dream1 == 3 & condition == 6
		replace prox4 = 2 if dream1 == 1 & condition == 6
		replace prox4 = 2 if dream1 == 3 & condition == 5
		replace prox4 = 1 if dream1 == 1 & condition == 9
		replace prox4 = 1 if dream1 == 3 & condition == 10
		replace prox4 = 2 if dream1 == 1 & condition == 10
		replace prox4 = 2 if dream1 == 3 & condition == 9
		replace prox4 = 4 if dream1 == 1 & condition == 3
		replace prox4 = 4 if dream1 == 3 & condition == 4
		replace prox4 = 4 if dream1 == 1 & condition == 7
		replace prox4 = 3 if dream1 == 3 & condition == 7
		replace prox4 = 3 if dream1 == 1 & condition == 8
		replace prox4 = 4 if dream1 == 3 & condition == 8
		replace prox4 = 4 if dream1 == 1 & condition == 11
		replace prox4 = 3 if dream1 == 3 & condition == 11
		replace prox4 = 3 if dream1 == 1 & condition == 12
		replace prox4 = 4 if dream1 == 3 & condition == 12
		label var prox4 "Type of Proximity (All)"
		label def prox11 1 "Consistent: Same Position"  2 "Consistent:Opposite" 3 "Repositioned:Gained Proximity" 4 "Repositioned:Lost Proximity"
		label values prox4 prox11
		
		
		gen same_pos = . 
		replace same_pos = 1 if prox4 == 1
		replace same_pos = 1 if prox4 == 3
		replace same_pos = 0 if prox4 == 2
		replace same_pos = 0 if prox4 == 4
		label var same_pos "Same (Final) Position as R?"
		label def samp 1 "Same Position" 0 "Different Position"
		label values same_pos samp
		