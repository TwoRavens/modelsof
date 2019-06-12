******************************************************
************** Data Cleaning File for Study 2: MTurk 
************** The following do file provides the code
************** for the independent and dependent variables
************** used in analyzing Study 2 and should be run
************** before replicating those analyses 
**************************************
**************************************
**************************************


		*********Demographics & Controls*******
	
	*Gender*
		rename gender gend
		gen gender = gend - 1
		label def gen 1 "Female" 0 "Male" 
		label values gender gen
		label var gender "Gender"
		tab gender		

	*Age*
		label def ag 1 "18-24" 2 "25-34" 3 "35-44" 4 "45-54" 5 "55-64" 6 "65+"
		label values age ag
		tab age
		label var age "Age"
		summ age, detail
		
	*Education*
		label def edu 1 "<HS" 2 "HS/GED" 3 "Some College" 4 "2-Yr Degree" 5 "4-Yr Degree" ///
			6 "Masters Degree" 7 "Doctoral Degree" 8 "Professional Degree"
		label values educ edu
		tab educ	
		
		*collapsing the different types of 
		*advanced degrees into one category:
		gen educ1 = . 
		replace educ1  = 1  if educ >= 1 & educ <= 2
		replace educ1  = 2  if educ == 3
		replace educ1  = 3  if educ == 4
		replace educ1  = 4  if educ == 5
		replace educ1  = 5  if educ >= 6 & educ <= 8
		label def edu1 1 "<HS & HS" 2 "Some College" 3 "2 YR Degree" 4 "4 YR Degree" 5 "Advanced Degree"
		label values educ1 edu1 
		tab educ1
		label var educ "Education"
		label var educ1 "Education"
	
		
	*Income*
		label def inc 1 "< 20,000" 2 "20-29,999" 3 "30-39,999" 4 "40-49,999" 5 "50-59999" ///
			6 "60-69999" 7 "70-79999" 8 "80-89999" 9 "90,000 or More"
		label values income inc
		label var income "Income"
		tab income
		summ income, detail		
		
		
	*Race*
		label def rac 1 "Black" 2 "Hispanic" 3 "White" 4 "Asian" 5 "Other"
		label values race rac
		tab race
		label var race "Race/Ethnicity"
				
	*PID*  
		label def party 1 "Strong Dem" 2 "Weak Dem" 3 "Lean Dem" 4 "Pure Ind." 5 "Lean Rep" 6 "Weak Rep" 7 "Strong Rep"
		label values pid party
		summ pid
		tab pid
		
		gen pid_3cat = .
		replace pid_3cat = 1 if pid >=1 & pid <= 3
		replace pid_3cat = 2 if pid >= 5 & pid <= 7
		replace pid_3cat = 3 if pid == 4
		label def party1 1 "Democrats" 2 "Republicans" 3 "Independents" 
		label values pid_3cat party1
		tab pid_3cat
		label var pid "Party ID"
		label var pid_3cat "PID (Categories)"
		
		gen pid_repdem = .
		replace pid_repdem = 0 if pid_3cat == 1
		replace pid_repdem = 1 if pid_3cat == 2
		label def party2 1 "Republicans" 0 "Democrats"
		label values pid_repdem party2
		label var pid_repdem "PID (Rep vs. Dem)"
	
	*PID Strength & Importance
		gen pid_str = . 
		replace pid_str = 1 if pid == 4
		replace pid_str = 2 if pid == 3
		replace pid_str = 2 if pid == 5
		replace pid_str = 3 if pid == 2
		replace pid_str = 3 if pid == 6
		replace pid_str = 4 if pid == 1
		replace pid_str = 4 if pid == 7
		label var pid_str "PID Str."
		label def pid_st 1 "Ind." 2 "Lean" 3 "Weak" 4 "Strong"
		label values pid_str pid_st

		label def party3 1 "Not Imp at All" 2 "Somewhat Imp" 3 "Moderately Imp" 4 "Extremely Imp"
		label values pid_imp party3
		tab pid_imp
		summ pid_imp, detail
		by pid_3cat, sort: summ pid_imp
		label var pid_imp "Imporance of Partisan/Independent Identity"

	**Ideology*.
		*Ideology - Full Scale
			label var ideology_gen "Ideology (General)"
			label var ideology_social "Ideology (Social Issues)"
			label var ideology_econ "Ideology (Economic Issues)"
				
			label def ideo 1 "Ext. Liberal" 2 "Mod. Lib" 3 "Slightly Liberal" 4 "Moderate" ///
				5 "Slightly Cons." 6 "Mod. Conservative" 7 "Ext. Conservative"
			label values ideology_gen ideo
			label values ideology_social ideo
			label values ideology_econ ideo
			
			tab ideology_gen
			tab ideology_social
			tab ideology_econ
			summ ideology_gen ideology_social ideology_econ, detail
			
		*Their relationship & a combined variables
			pwcorr ideology_gen ideology_social ideology_econ, sig
				*the two sub-dimensions are both highly correlated with 
				*the main one (0.7965 and 0.8017);
				*however, they are only moderately correlated with each other (0.533)*
			alpha ideology_gen ideology_social ideology_econ, item
				*Together, they form a highly reliable scale: alpha = 0.8755*
				*Removing either of the subscales would only bump up the alpha to 0.88*
			factor ideology_gen ideology_social ideology_econ, pcf
				*single factor solution: EV = 2.43, Proportion of Variance = 0.8096;
				*all three load at 0.86 or higher*
			rotate
			predict factor1
			rename factor1 ideology_f
			label var ideology_f "Ideology (Factor)"
			
			egen ideology_mean = rowmean(ideology_gen ideology_social ideology_econ)
			label var ideology_mean "Ideology (3-item Mean)"
	
	*Political Trust/cynicism
		*Coded so that higher scores = more cynicism*
		gen cynic_intent_reverse = .
		replace cynic_intent_reverse = 1 if cynic_intentions == 5
		replace cynic_intent_reverse = 2 if cynic_intentions == 4
		replace cynic_intent_reverse = 3 if cynic_intentions == 3
		replace cynic_intent_reverse = 4 if cynic_intentions == 2
		replace cynic_intent_reverse = 5 if cynic_intentions == 1

		summ cynic_listen cynic_win cynic_goals cynic_intent_reverse

						
		*Making a scale
			pwcorr cynic_listen cynic_win cynic_goals cynic_intent_reverse, sig
				*Moderately high correlations, save for intentions and listen (0.25)
			alpha cynic_listen cynic_win cynic_goals cynic_intent_reverse, item
				*alpha = 0.7299*
				*alpha would slightly go up if you get rid of intentions - 0.7299 to 0.7492**
			factor cynic_listen cynic_win cynic_goals cynic_intent_reverse, pcf
				*one dimension solution; EV = 2.25, proportion explained = 0.56*
				*first three variables have loadings from 0.75 to 0.85, while intentions has one at 0.62*
			rotate
			predict factor1
			label var factor1 "Cynicism (Factor)"
			rename factor1 cynic_f
			
			egen cynic_mean = rowmean(cynic_listen cynic_win cynic_goals cynic_intent_reverse)
			label var cynic_mean "Cynicism (Mean)"
			summ cynic_mean
			
	*Political Interest*
		label var interest "Political Interest"
		labe def int 1 "Not at All" 4 "Moderately" 7 "Extremely"
		label values interest int
		summ interest, detail
		tab interest

			
					**************Outcome Variables & Variables of Interest*********
					
					
					**********Thermometer; Traits; Motives; Account Satisfaction*******
		label var therm "Feeling Thermometer"
		label var open "Open-Minded"
		label var leader "Strong Leader"
		label var intelligent "Intelligent"
				
		
		*Factor Variable for analysees
			factor therm leader open intelligent, pcf
			rotate
			predict factor1
			rename factor1 eval
			label var eval "Global Eval"
			
			
			
		*Motives*
			factor reelection-policy, pcf
				*Three factor solution emerges*
				*F1: EV = 3.21, proportion = 0.36; help_all and policy are the two biggest loading variables, with per_values and help_const next (along with negative loadigns for reelection, pandering, and special interests*
				*F2: EV = 1.90, proportion = 0.21; everything save help_all help_consts and policy moderately load
				*F3: EV = 1.13; proportion = 0.13; negative loadings from per_values policy_pref and ideological, and positive for helpcons and some others*
			rotate
				*F1: 
					*Reelection (0.82), Pandering (0.83), Special Interests (0.79), with neg loadinsg for Per Values (-0.17), Help_all (-0.31), and Policy (-0.31)
					*Help-All (0.83), help_const (0.85), and policy (0.78)
					*Policy_pref (0.74*, Per_values (0.78), and ideological (0.76)
					*The three-factor solution closely matches what Doherty finds*
			predict factor1 factor2 factor3
			rename factor1 political_motives
			label var political_motives "Political Motives (Factor)"
			rename factor2 representation_motives 
			label var representation_motives "Representation Motives (Factor)"
			rename factor3 policy_motives
			label var policy_motives "Policy Motives (Factor)"
			
			
		*Account Satisfaction
			label var satis "Account Satisfaction"
			label def sat 1 "Very Dissatisfied" 2 "Moderately Dis." 3 "Somewhat Dissatisfied" 4 "Neutral" 5 "Somewhat Satisfied" 6 "Moderately Satisfied" 7 "Very Satisfied"
			label values satis sat
			
			
			
						**************Exp. Conditions*********

			gen condition = . 
			replace condition = 1 if cond_labels == "C1:BaseDem"
			replace condition = 2 if cond_labels == "C2:BaseRep"
			replace condition = 3 if cond_labels == "C3:ConDem"
			replace condition = 4 if cond_labels == "C4:ConRep"
			replace condition = 5 if cond_labels == "C5:InconDem"
			replace condition = 6 if cond_labels == "C6:InconRep"
			replace condition = 7 if cond_labels == "C7:InconDemJ1"
			replace condition = 8 if cond_labels == "C8:InconRepJ1"
			replace condition = 9 if cond_labels == "C9:InconDemJ2"
			replace condition = 10 if cond_labels == "C10:InconRepJ2"
			tab condition cond_labels 
			label def cond 1 "Base:Dem" 2 "Base:Rep" 3 "Con:Dem" 4 "Con:Rep" 5"Incon:Dem" 6 "Incon:Rep" 7 "Incon:Dem:J1" 8 "Incon:Rep:J1" 9 "Incon:Dem:J2" 10 "Incon:Rep:J2"
			label values condition cond
			tab condition
			label var condition "Full 10 Condition"

			gen condition1 = . 
			replace condition1 = 1 if condition >=1 & condition <= 2
			replace condition1 = 2 if condition >= 3 & condition <= 4
			replace condition1 = 3 if condition >= 5 & condition <= 6
			replace condition1 = 4 if condition >= 7 & condition <= 9
			replace condition1 = 5 if condition >= 9 & condition <= 10
			label var condition1 "Position History Conditions"
			label def condi 1 "Baseline" 2 "Consistent" 3 "Repositioned" 4 "Repositioned (New Info)" 5 "Repositioned (Fairness)"
			label values condition1 condi
			tab condition1 
			tab condition condition1

			gen cond_party = . 
			replace cond_party = 1 if condition == 1
			replace cond_party = 1 if condition == 3
			replace cond_party = 1 if condition == 5
			replace cond_party = 1 if condition == 7
			replace cond_party = 1 if condition == 9
			replace cond_party = 0 if condition == 2
			replace cond_party = 0 if condition == 4
			replace cond_party = 0 if condition == 6
			replace cond_party = 0 if condition == 8
			replace cond_party = 0 if condition == 10
			label var cond_party "PID of Vignette Rep"
			label def cond_p 1 "Democrat" 0 "Republican"
			label values cond_party cond_p
			tab cond_party 
			tab condition cond_party

			gen cond_party1 = .
			replace cond_party1 = 1 if cond_party == 1 & pid_3cat == 1
			replace cond_party1 = 1 if cond_party == 0 & pid_3cat == 2 
			replace cond_party1 = 2  if cond_party ==  1  & pid_3cat == 2
			replace cond_party1 = 2  if cond_party==  0 & pid_3cat == 1
			replace cond_party1 = 3  if cond_party ==  1  & pid_3cat == 3
			replace cond_party1 = 3  if cond_party ==  0 & pid_3cat == 3
			label def cond_p1 1 "Rep Same Party as R" 2 "Rep Diff Party as R" 3 "R is Ind." 
			label values cond_party1 cond_p1
			tab cond_party1
			tab condition cond_party1

			gen account = . 
			replace account = 1 if condition1 == 5
			replace account = 0 if condition1 == 4
			label var account "Account" 
			label def acc1 0 "New Info" 1 "P. Fairness"
			label values account acc1
