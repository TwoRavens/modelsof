**********************************************************************
**********************************************************************
***********************2002 ANES Panel********************************
**********************************************************************
**********************************************************************
**********************************************************************


**********************************************************************
****************************Data Cleaning****************************
**********************************************************************
**********************************************************************
**********************************************************************
**********************************************************************

clear
set more off
use "ANES2002Panel.dta"
set more off

		************************************
		*********Panels*********************
		************************************

*We are most interested in those that participated in the 
*2000TS Post-Election Wave (where the networks data was recorded
*And those that did the 2002 Pre-Election Wave 
*where the econ data was recorded

tab Waves
	*10 = 2000 Pre, 2000 Post, 2002 Pre, 2002 Post, 2004 Post
	*9 = 2000 Pre, 2000 Post, 2002 Pre, 2004 Post
	*8 = 2000 Pre, 2002 Pre, 2002 Post, 20004 Post
	*7 = 2000 Pre, 2002 Pre, 2004 Post
	*6 = 2000 Pre, 2000 Post, 2002 Pre, 2002 Post
	*5 = 2000 Pre, 2000 Post, 2002 Pre
	*4 = 2000 Pre, 2002 Pre, 2002 Post
	*3 = 2000 Pre, 2002 Pre 
	*2 = 2000 Pre, 2000 Post
	*1 = 2000 Pre
	
*thus, we are interested i: 10, 9, 6, 5	

gen panel = . 
replace panel = 1 if Waves == 10
replace panel = 1 if Waves == 9
replace panel = 1 if Waves == 6
replace panel = 1 if Waves == 5
replace panel = 0 if panel == .
label def pan 1 "2000 Post & 2002 Pre" 
label values panel pan
	
		************************************
		*********Economic Assessments*******
		************************************
		
recode M000491 (1=5) (2=4) (3=3) (4=2) (5=1), gen(retro2002)
label def ret 1 "Much Worse" 2 "Somewhat Worse" 3 "Same" 4 "Somewhat Better" 5 "Much Better"
label values retro2002 ret
label var retro2002 "Retro (2002)"
tab retro if panel == 1

recode retro (1=1) (2=1) (3=2) (4=3) (5=3), gen(retro2002_3)
label def ret1 1 "Worse" 2 "Same" 3 "Better" 
label values retro2002_3 ret1 
label var retro2002_3 "Retro (2002; 3-pt)"
tab retro2002_3

gen version = . 
replace version = 1 if M000488a !=.
replace version = 0 if M000488b !=.
label def ver 1 "Better" 0 "Worse"
label values version ver
label var version "Version of Retro2002"

tab retro2002 version if panel == 1, row col chi2
tab retro2002_3 version if panel == 1, row col chi2
ttest retro2002 if panel == 1, by(version)
ttest retro2002_3 if panel == 1, by(version)


		************************************
		*********Partisanship***************
		************************************
		
*2002 Pre-Election Wave
	*7-pt
	recode M023038X (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7), gen(partyid)
	label def pi 1 "St. Dem" 2 "Weak Dem" 3 "Lean Dem" 4" Ind." 5 "Lean Rep" 6 "Weak Rep" 7 "St. Rep"
	label var partyid "Party Identification (2002)"
	label values partyid pi
	*3-Point Categorical
	gen pid_3 = . 
	replace pid_3 = 1 if partyid >=1 & partyid <= 3
	replace pid_3 = 3 if partyid == 4
	replace pid_3 = 2 if partyid >=5 & partyid <= 7
	label var pid_3 "Party ID (2002)"
	label def pi2 1 "Democrat" 3 "Independent" 2 "Republican"
	label values pid_3 pi2
	
	*Republican Vs. Democrat
	gen pid_2 = . 
	replace pid_2 = 1 if partyid >=1 & partyid <= 3
	replace pid_2 = 0 if partyid >=5 & partyid <= 7
	label var pid_2 "PID (2002)" 
	label def pi3 1 "Democrat" 0 "Republican"
	label values pid_2 pi3
	
	tab partyid
	tab pid_3
	tab pid_2
	
	*PID Str
	gen pid_str = . 
	replace pid_str = 1 if partyid == 3
	replace pid_str = 1 if partyid == 5
	replace pid_str = 2 if partyid == 2
	replace pid_str = 2 if partyid == 6
	replace pid_str = 3 if partyid == 1
	replace pid_str = 3 if partyid == 7
	label var pid_str "PID Str."
	label def pi4 1 "Leaner" 2 "Weak" 3 "Strong"
	label values pid_str pi4
	
	summ pid_str 
	gen pid_str01 = (pid_str - r(min))/(r(max)-r(min))
	label var pid_str01 "PID Str"
	
	recode partyid (1=4) (2=3) (3=2) (4=1) ///
		(5=2) (6=3) (7=4), gen(pid_str_full)
	
	label var pid_str_full "PID Str."
	label def pi5 1 "Pure Ind." 2 "Leaner" 3 "Weak" 4 "Strong"
	label values pid_str pi5
	
	*Partisan*
	recode pid_2 (1=0) (0=1), gen(partisan)
	label var partisan "Co-Partisan to Inc. President"
	label def part1 1 "In-Partisan" 0 "Out-Partisan"
	label values partisan part1


	
*2000 Pre-Election
	*7pt
	recode M000523 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7), gen(partyid_2000)
	label var partyid_2000 "Party Identification (2000)"
	label values partyid_2000 pi
	*3-pt
	gen pid_32000 = . 
	replace pid_32000 = 1 if partyid_2000 >=1 & partyid_2000 <= 3
	replace pid_32000 = 3 if partyid_2000 == 4
	replace pid_32000 = 2 if partyid_2000 >=5 & partyid_2000 <= 7
	label var pid_3 "Party ID (2000)"
	label values pid_3200 pi2
	*Republican Vs. Democrat
	gen pid_2_2000 = . 
	replace pid_2_2000 = 1 if partyid_2000 >=1 & partyid_2000 <= 3
	replace pid_2_2000 = 0 if partyid_2000 >=5 & partyid_2000 <= 7
	label var pid_2_2000 "PID (2000)" 
	label values pid_2_2000 pi3
	
	*Partisan
	recode pid_2_2000 (1=0) (0=1), gen(partisan2000)
	label values partisan2000 part1
	label var partisan2000 "Co-Partisan to Inc. President (2000 Measure)"
	
	*Pid Str
	gen pid_str2000 = . 
	replace pid_str2000 = 1 if partyid_2000 == 3
	replace pid_str2000 = 1 if partyid_2000 == 5
	replace pid_str2000 = 2 if partyid_2000 == 2
	replace pid_str2000 = 2 if partyid_2000 == 6
	replace pid_str2000 = 3 if partyid_2000 == 1
	replace pid_str2000 = 3 if partyid_2000 == 7
	label var pid_str2000 "PID Str. (2000)"
	label values pid_str2000 pi4
	
	summ pid_str2000
	gen pid_str2000_01 = (pid_str2000 - r(min))/(r(max)-r(min))
	label var pid_str2000_01 "PID Str (2000)"
	
*Relationship
	pwcorr partyid partyid_2000, sig
	tab pid_3 pid_32000, row col chi2
	tab pid_2 pid_2_2000, row col chi2

*Bivariate relationship with economic assessments? 
	tab retro2002_3 pid_2 if panel == 1, row col chi2
	tab retro2002_3 pid_2_2000 if panel == 1, row col chi2	
	tab retro2002 pid_2 if panel == 1, row col chi2
	tab retro2002 pid_2_2000 if panel == 1, row col chi2	


		*****************************************************
		*********Network Size and Disagreement***************
		*****************************************************
*Network Size (# Listed Discussants)

	gen names = . 
	replace names = 4 if M001702 == 1 & M001701 == 1 & M001700 == 1 & M001699 == 1
	replace names = 3 if M001702 == 5 & M001701 == 1 & M001700 == 1 & M001699 == 1
	replace names = 2 if M001701 == 5 & M001700 == 1 & M001699 == 1
	replace names = 1 if M001700 == 5 & M001699 == 1
	replace names = 0 if M001699 == 5
	label var names "# Listed Disc."
	
	*Discussant Vote Choice
		foreach var in M001710 M001718 M001726 M001734 {
			tab `var' if panel == 1
		}
		
		*1 = Al Gore
		*3 = George Bush
		*5 = Some Other Candidate
		*7 = Didn't vote
		*8 = ineliglb to vote
		*98 = dk
		*99 = ref
	
	recode names (0=.), gen(names1)
	label var names1 "Network Size"
	summ names1
	gen numgiven01 = (names1 - r(min))/(r(max)-r(min))
	label var numgiven01 "Network Size"
	
		
	*Respondent vote choice*
			tab M001249
			*1 = Gore
			*2 = howard philips (n = 1)
			*3 = Bush
			*4 = Libertarian (n=4)
			*5 = Pat Buchanan (n =3)
			*6 = Nader (n=33)
			*7 = reports voting for self
			*0 = NA/INAP
			
				*0 = NA/INAP
	
*Disagreement
	*need to create indices for 'agreement' and 'disagreement'
	*agreement: gore/gore, bush/bush; 
	*disagree: gore/bush, bush/gore, nader/gore, nader/bush, gore/other, bush/other, remainder 3rd party/bush or gore
		
	*Agree = 1, Disagree = 0
		label def agr 1 "Agree" 0 "Disagree" 
		gen d1_votea = . 
		replace d1_votea = 1 if M001249 == 1 & M001710 == 1
		replace d1_votea = 1 if M001249 == 3 & M001710 == 3
		replace d1_votea = 0  if M001249 == 1 & M001710 == 3
		replace d1_votea = 0  if M001249 == 3 & M001710 == 1
		replace d1_votea = 0  if M001249 == 1 & M001710 == 5
		replace d1_votea = 0  if M001249 == 3 & M001710 == 5
		replace d1_votea = 0  if M001249 == 2 & M001710 == 1
		replace d1_votea = 0  if M001249 == 2 & M001710 == 3
		replace d1_votea = 0  if M001249 == 4 & M001710 == 1
		replace d1_votea = 0  if M001249 == 4 & M001710 == 3
		replace d1_votea = 0  if M001249 == 5 & M001710 == 1
		replace d1_votea = 0  if M001249 == 5 & M001710 == 3
		replace d1_votea = 0  if M001249 == 6 & M001710 == 1
		replace d1_votea = 0  if M001249 == 6 & M001710 == 3
		label var d1_votea "D1 Vote Agreement"
		label values d1_votea agr
		
		
		gen d2_votea = . 
		replace d2_votea = 1 if M001249 == 1 & M001718 == 1
		replace d2_votea = 1 if M001249 == 3 & M001718 == 3
		replace d2_votea = 0  if M001249 == 1 & M001718 == 3
		replace d2_votea = 0  if M001249 == 3 & M001718 == 1
		replace d2_votea = 0  if M001249 == 1 & M001718 == 5
		replace d2_votea = 0  if M001249 == 3 & M001718 == 5
		replace d2_votea = 0  if M001249 == 2 & M001718 == 1
		replace d2_votea = 0  if M001249 == 2 & M001718 == 3
		replace d2_votea = 0  if M001249 == 4 & M001718 == 1
		replace d2_votea = 0  if M001249 == 4 & M001718 == 3
		replace d2_votea = 0  if M001249 == 5 & M001718 == 1
		replace d2_votea = 0  if M001249 == 5 & M001718 == 3
		replace d2_votea = 0  if M001249 == 6 & M001718 == 1
		replace d2_votea = 0  if M001249 == 6 & M001718 == 3
		label var d2_votea "D2 Vote Agreement"
		label values d2_votea agr
		
				
		gen d3_votea = . 
		replace d3_votea = 1 if M001249 == 1 & M001726 == 1
		replace d3_votea = 1 if M001249 == 3 & M001726 == 3
		replace d3_votea = 0  if M001249 == 1 & M001726 == 3
		replace d3_votea = 0  if M001249 == 3 & M001726 == 1
		replace d3_votea = 0  if M001249 == 1 & M001726 == 5
		replace d3_votea = 0  if M001249 == 3 & M001726 == 5
		replace d3_votea = 0  if M001249 == 2 & M001726 == 1
		replace d3_votea = 0  if M001249 == 2 & M001726 == 3
		replace d3_votea = 0  if M001249 == 4 & M001726 == 1
		replace d3_votea = 0  if M001249 == 4 & M001726 == 3
		replace d3_votea = 0  if M001249 == 5 & M001726 == 1
		replace d3_votea = 0  if M001249 == 5 & M001726 == 3
		replace d3_votea = 0  if M001249 == 6 & M001726 == 1
		replace d3_votea = 0  if M001249 == 6 & M001726 == 3
		label var d3_votea "D4 Vote Agreement"
		label values d3_votea agr


		gen d4_votea = . 
		replace d4_votea = 1 if M001249 == 1 & M001734 == 1
		replace d4_votea = 1 if M001249 == 3 & M001734 == 3
		replace d4_votea = 0  if M001249 == 1 & M001734 == 3
		replace d4_votea = 0  if M001249 == 3 & M001734 == 1
		replace d4_votea = 0  if M001249 == 1 & M001734 == 5
		replace d4_votea = 0  if M001249 == 3 & M001734 == 5
		replace d4_votea = 0  if M001249 == 2 & M001734 == 1
		replace d4_votea = 0  if M001249 == 2 & M001734 == 3
		replace d4_votea = 0  if M001249 == 4 & M001734 == 1
		replace d4_votea = 0  if M001249 == 4 & M001734 == 3
		replace d4_votea = 0  if M001249 == 5 & M001734 == 1
		replace d4_votea = 0  if M001249 == 5 & M001734 == 3
		replace d4_votea = 0  if M001249 == 6 & M001734 == 1
		replace d4_votea = 0  if M001249 == 6 & M001734 == 3
		label var d4_votea "D4 Vote Agreement"
		label values d4_votea agr
	
		tab d1_votea 
		tab d2_votea 
		tab d3_votea
		tab d4_votea
		
	*Disagreement (=1; agree =0)
		label def disagr 1 "Disagree" 0 "Agree"
					
		gen d1_voted = . 
		replace d1_voted = 0 if M001249 == 1 & M001710 == 1
		replace d1_voted = 0 if M001249 == 3 & M001710 == 3
		replace d1_voted = 1  if M001249 == 1 & M001710 == 3
		replace d1_voted = 1  if M001249 == 3 & M001710 == 1
		replace d1_voted = 1  if M001249 == 1 & M001710 == 5
		replace d1_voted = 1  if M001249 == 3 & M001710 == 5
		replace d1_voted = 1  if M001249 == 2 & M001710 == 1
		replace d1_voted = 1  if M001249 == 2 & M001710 == 3
		replace d1_voted = 1  if M001249 == 4 & M001710 == 1
		replace d1_voted = 1  if M001249 == 4 & M001710 == 3
		replace d1_voted = 1  if M001249 == 5 & M001710 == 1
		replace d1_voted = 1  if M001249 == 5 & M001710 == 3
		replace d1_voted = 1  if M001249 == 6 & M001710 == 1
		replace d1_voted = 1  if M001249 == 6 & M001710 == 3
		label var d1_voted "D1 Vote Disagreement"
		label values d1_voted disagr
		
		gen d2_voted = . 
		replace d2_voted = 0 if M001249 == 1 & M001718 == 1
		replace d2_voted = 0 if M001249 == 3 & M001718 == 3
		replace d2_voted = 1  if M001249 == 1 & M001718 == 3
		replace d2_voted = 1  if M001249 == 3 & M001718 == 1
		replace d2_voted = 1  if M001249 == 1 & M001718 == 5
		replace d2_voted = 1  if M001249 == 3 & M001718 == 5
		replace d2_voted = 1  if M001249 == 2 & M001718 == 1
		replace d2_voted = 1  if M001249 == 2 & M001718 == 3
		replace d2_voted = 1  if M001249 == 4 & M001718 == 1
		replace d2_voted = 1  if M001249 == 4 & M001718 == 3
		replace d2_voted = 1  if M001249 == 5 & M001718 == 1
		replace d2_voted = 1  if M001249 == 5 & M001718 == 3
		replace d2_voted = 1  if M001249 == 6 & M001718 == 1
		replace d2_voted = 1  if M001249 == 6 & M001718 == 3
		label var d2_voted "D2 Vote Disagreement"
		label values d2_voted disagr
		
		gen d3_voted = . 
		replace d3_voted = 0 if M001249 == 1 & M001726 == 1
		replace d3_voted = 0 if M001249 == 3 & M001726 == 3
		replace d3_voted = 1  if M001249 == 1 & M001726 == 3
		replace d3_voted = 1  if M001249 == 3 & M001726 == 1
		replace d3_voted = 1  if M001249 == 1 & M001726 == 5
		replace d3_voted = 1  if M001249 == 3 & M001726 == 5
		replace d3_voted = 1  if M001249 == 2 & M001726 == 1
		replace d3_voted = 1  if M001249 == 2 & M001726 == 3
		replace d3_voted = 1  if M001249 == 4 & M001726 == 1
		replace d3_voted = 1  if M001249 == 4 & M001726 == 3
		replace d3_voted = 1  if M001249 == 5 & M001726 == 1
		replace d3_voted = 1  if M001249 == 5 & M001726 == 3
		replace d3_voted = 1  if M001249 == 6 & M001726 == 1
		replace d3_voted = 1  if M001249 == 6 & M001726 == 3
		label var d3_voted "D3 Vote Disagreement"
		label values d3_voted disagr
		
		gen d4_voted = . 
		replace d4_voted = 0 if M001249 == 1 & M001734 == 1
		replace d4_voted = 0 if M001249 == 3 & M001734 == 3
		replace d4_voted = 1  if M001249 == 1 & M001734 == 3
		replace d4_voted = 1  if M001249 == 3 & M001734 == 1
		replace d4_voted = 1  if M001249 == 1 & M001734 == 5
		replace d4_voted = 1  if M001249 == 3 & M001734 == 5
		replace d4_voted = 1  if M001249 == 2 & M001734 == 1
		replace d4_voted = 1  if M001249 == 2 & M001734 == 3
		replace d4_voted = 1  if M001249 == 4 & M001734 == 1
		replace d4_voted = 1  if M001249 == 4 & M001734 == 3
		replace d4_voted = 1  if M001249 == 5 & M001734 == 1
		replace d4_voted = 1  if M001249 == 5 & M001734 == 3
		replace d4_voted = 1  if M001249 == 6 & M001734 == 1
		replace d4_voted = 1  if M001249 == 6 & M001734 == 3
		label var d4_voted "D4 Vote Disagreement"
		label values d4_voted disagr
		
		tab d1_voted
		tab d2_voted 
		tab d3_voted
		tab d4_voted

		
*Summary and Average*
	*Agreement*
		egen cand_agree = rowtotal(d1_votea d2_votea d3_votea d4_votea), missing
	*Disagreeement				
		egen cand_disagree = rowtotal(d1_voted d2_voted d3_voted d4_voted), missing
		
		tab cand_agree
		tab cand_disagree
		summ cand_agree cand_disagree
		
	*Difference*
		*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
				gen disagree_total = cand_disagree - cand_agree
				label var disagree_total "Network Disagreement"
		*Corrected for # D & A
			*See Lupton & Thornton: (D-A)/(D+A)
				gen disagree_avg = [cand_disagree - cand_agree] / [cand_disagree + cand_agree]
				label var disagree_avg "Network Disagreement"
	
			*Standardized*
			foreach var in disagree_total disagree_avg {
				summ `var'
				gen `var'01 = (`var' - r(min))/(r(max)-r(min))
			}
			
			label var disagree_total01 "Network Disagreement"
			label var disagree_avg01 "Network Disagreement"
				
*Network Diversity
	*From Nir: [(Agree+Disagree)/2] - |A-D|
		gen network_ambiv = [(cand_agree + cand_disagree)/2] - abs(cand_agree - cand_disagree)
		label var network_ambiv "Network Political Diversity"
		
		summ network_ambiv
		gen network_ambiv01=(network_ambiv - r(min))/(r(max)-r(min))
		label var network_ambiv01 "Network Political Diversity"

			
		
		
		***************************************************
		*****************Control Variables*****************
		***************************************************
		
*Education
	recode M023131 (1=1) (2=1) (3=2) (4=3) (5=3) (6=4) (7=4) (9=.), gen(educ)
	tab M023131 educ
	label var educ "Education"
	label def edu 1 "< HS" 2 "HS" 3 "Some College" 4 "College Degree+"
	label values educ edu
	tab educ
	
	summ educ 
	gen educ01 = (educ - r(min))/(r(max)-r(min))
	label var educ01 "Education"

*Gender
	recode  M023153 (1=0) (2=1), gen(gender)
	label var gender "Gender" 
	label def gena 1 "Female" 0 "Male"
	label values gender gena


*Age
	rename M023126X age2002
	label var age2002 "Age (2002)"
	
	summ age2002
	gen age01 = (age2002 - r(min))/(r(max)-r(min))
	label var age01 "Age"

*Marital Status
	recode  M023127A (1=1) (2=0) (3=0) (4=0) (5=0) (6=0), gen(marital)
	label var marital "Marriage Status"
	label def mar 1 "Married" 0 "Unmarried" 
	label values marital mar
	
	recode M000909 (1=1) (2=0) (3=0) (4=0) (5=0) (6=0), gen(marital2000)
	label var marital2000 "Marriage Status (2000)"
	label values marital2000 mar
	
	

*Employment
	recode M023132X (1=1) (2=2) (3=2) (4=3) (5=4) (6=5) (7=6) ///
		(14=1) (16=1) (17=1) ///
		(26=5) (34=3) (35=4) (36=5) ///
		(45=3) (46=5) (47=6) ///
		(67=6) (167=1) (467=4), gen(employment)
		label def emp 1 "Employed" 2 "Unemployed" 3 "Retired" 4 "Perm. Disabled" 5 "Homemaker" 6 "student" 
		label values employment emp
		tab employment
		
	recode employment (1=1) (2=2) (3=3) (4=4) (5=4) (6=4), gen(employed)
	label var employed "Employment Status"
	label def emp1 1 "Employed" 2 "Unemployed" 3 "Retired" 4 "Perm. Disabled/Homemaker/Student"
	label values employed emp1
		

*Inconme
	recode 	M023149 (9=.), gen(income2002)
	label var income2002 "Household Income (2002)"
	
	summ income2002
	gen income01 = (income2002 - r(min))/(r(max)-r(min))
	label var income01 "Household Income"
	
	
*Race
	label def rac 1 "White" 2 "Black" 3 "Hispanic" 4 "Other" 5 "Bi-Racial"
	recode  M023150 (1=2) (2=4) (3=4) (4=3) (5=1) (12=5) (13=5) (14=3) (15=5) (24=3) (25=5) (34=3) (35=5) (45=3) (77=4), gen(race1)
	label var race1 "Race"
	label values race1 rac
	tab race

	recode race1 (1=1) (2=2) (3=3) (4=4) (5=4), gen(race)
	label var race "Race"
	label def rac1 1 "White" 2 "Black" 3 "Hispanic" 4 "Other" 
	label values race rac1
	
*Personal Financial Situation
	recode M023026 (1=5) (2=4) (3=3) (4=2) (5=1), gen(finance)
	label def fin 1 "Much Worse" 2 "Somewhat worse" 3 "Same" 4 "Somewhat Better" 5 "Much Better" 
	label values finance fin
	tab finance


*Interest*
	recode M023001 (1=3) (3=2) (5=1), gen(interest_camp)
	label var interest_camp "Interest in Campaign (2002)"
	label def int 1 "Not Much" 2 "Somewhat" 3 "Very" 
	label values interest_camp int
	tab interest_camp
	
	summ interest_camp
	gen interest_camp01 = (interest_camp - r(min))/(r(max)-r(min))
	label var interest_camp "Campaign Interest (2002)"
	
	
*Approval of Bush job on economy
	recode  M045006x (1=4) (2=3) (4=2) (5=1), gen(bush1)
	recode  M023042X (1=4) (2=3) (4=2) (5=1), gen(bush2)
	gen bush_econ = .
	replace bush_econ = bush1
	replace bush_econ = bush2 if bush_econ == .
	label def becon 1 "Dis. Strongly" 2 "Dis. Not Strongly" 3 "App. Not Strongly" 4 "Appr. Strongly"
	label values bush_econ becon
	tab bush_econ


*which party better able to handle the economy
	recode M023031 (1=1) (3=2) (5=3) (7=3), gen(party_econ)
	label var party_econ "Which Party Better at Economy?"
	label def pat 1 "Democrats" 2 "Republicans" 3 "No Diff/Neither"
	label values party_econ pat
	tab party_econ

*Network Expertise

	foreach var in M001709 M001717 M001725 M001733 { 
			tab `var'
			}
			

		recode M001709 (1=3) (3=2) (5=1), gen(disc1_knowl)
		recode M001717 (1=3) (3=2) (5=1), gen(disc2_knowl)
		recode M001725 (1=3) (3=2) (5=1), gen(disc3_knowl)
		recode M001733 (1=3) (3=2) (5=1), gen(disc4_knowl)
		mvdecode disc1_knowl disc2_knowl disc3_knowl disc4_knowl, mv(0 = .a \ 8 = .b \ 9 = .c)
		label def diknowl 1 "Not Much" 2 "Avg. Amount" 3 "Great Deal"
		foreach var in disc1_knowl disc2_knowl disc3_knowl disc4_knowl {
			label values `var' diknowl
			tab `var'
			}
			
		egen disc_knowl = rowmean(disc1_knowl disc2_knowl disc3_knowl disc4_knowl)
		label var disc_knowl "Network Pol. Knowl."
		summ disc_knowl 
		
		summ disc_knowl
		gen disc_knowl01 = (disc_knowl - r(min))/(r(max)-r(min))
		label var disc_knowl01 "Network Pol. Knowledge"
		
		*Disagreement Scale Weighted by Disc Knowl*
			*Agree/Weight
			gen a1k = d1_votea * disc1_knowl 
			gen a2k = d2_votea * disc2_knowl 
			gen a3k = d3_votea * disc3_knowl 
			gen a4k = d4_votea * disc4_knowl 
			egen agree_knowl = rowtotal(a1k a2k a3k a4k), missing
		
			*Disagree/Weight
			gen d1k = d1_voted * disc1_knowl 
			gen d2k = d2_voted * disc2_knowl 
			gen d3k = d3_voted * disc3_knowl 
			gen d4k = d4_voted * disc4_knowl 
			egen dagree_knowl = rowtotal(d1k d2k d3k d4k), missing
		
			*Scale
				gen disagree_total_knowl = dagree_knowl - agree_knowl
				gen disagree_avg_knowl = disagree_total_knowl/(cand_disagree + cand_agree)
				label var disagree_total_knowl "Network Disagreement (Knowledge Weighted)"
				label var disagree_avg_knowl "Network Disagreement (Knowledge Weighted)"
				
				foreach var in disagree_total_knowl disagree_avg_knowl {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_knowl01 "Network Disagreement (Knowledge Weighted)"
				label var disagree_avg_knowl01 "Network Disagreement (Knowledge Weighted)"
				
		
*Freq. of Discussion
		
	*When you talk with [fill name 1], do you discuss political matters…often, sometimes, rarely, or never?*
	*1 = often; 3 = sometimes 5 = rarely 7 = never
		foreach var in  M001708 M001716 M001724 M001732 {
			tab `var'
			}
		*only 4-6 people say 'never' - they are thus lumped in with 'rarely'
		recode M001708 (1=3) (3=2) (5=1) (7=1), gen(disc1_freq)
		tab M001708 disc1_freq
		recode M001716 (1=3) (3=2) (5=1) (7=1), gen(disc2_freq)
		tab M001716 disc2_freq
		
		recode M001724 (1=3) (3=2) (5=1) (7=1), gen(disc3_freq)
		tab M001724 disc3_freq
		
		recode M001732 (1=3) (3=2) (5=1) (7=1), gen(disc4_freq)
		tab M001732 disc4_freq
		
		mvdecode disc1_freq disc2_freq disc3_freq disc4_freq, mv(0 = .a \ 8 = .b \ 9 = .c)
		
		label def freq 3 "Often" 2 "Sometimes" 1 "Rarely/Never"
			
		foreach var  in disc1_freq disc2_freq disc3_freq disc4_freq {
			label values `var' freq
			tab `var'
			}
			
		egen disc_freq = rowmean(disc1_freq disc2_freq disc3_freq disc4_freq)
		label var disc_freq "Avg. Freq of Political Discussion"
		
		summ disc_freq, detail
		
		*Weighted Scale of Exposure to Disagreement
		
			*Agree/Weight
			gen a1f = d1_votea * disc1_freq 
			gen a2f = d2_votea * disc2_freq 
			gen a3f = d3_votea * disc3_freq 
			gen a4f = d4_votea * disc4_freq 
			egen agree_freq = rowtotal(a1f a2f a3f a4f), missing
		
			*Disagree/Weight
			gen d1f = d1_voted * disc1_freq 
			gen d2f = d2_voted * disc2_freq 
			gen d3f = d3_voted * disc3_freq 
			gen d4f = d4_voted * disc4_freq 
			egen dagree_freq = rowtotal(d1f d2f d3f d4f), missing
	
		*Scale
				gen disagree_total_freq = dagree_freq - agree_freq
				gen disagree_avg_freq = disagree_total_freq/(cand_disagree + cand_agree)
				label var disagree_total_freq "Network Disagreement (Frequency Weighted)"
				label var disagree_avg_freq "Network Disagreement (Frequency Weighted)"
				
				foreach var in disagree_total_freq disagree_avg_freq {
					summ `var'
					gen `var'01 = (`var' - r(min))/(r(max)-r(min))
					}
				
				label var disagree_total_freq01 "Network Disagreement (Frequency Weighted)"
				label var disagree_avg_freq01 "Network Disagreement (Frequency Weighted)"
				
		
		
*Follow Politics (2000)*
recode  M001367 (1=4) (2=3) (3=2) (4=1), gen(follow)
label var follow "Political Interest"

summ follow 
gen follow01 = (follow - r(min))/(r(max)-r(min))
label var follow01 "Political Interest"



*Knowledge (2000)*
	
label def corre 1 "Correct" 0 "Incorrect/No Guess"
	*lott 
		recode M001447 (1=1) (5=0), gen(lott)
		label var lott "Trent Lott Knowledge"
		label values lott corre
	*reinquist
		recode M001450 (1=1) (5=0), gen(rein)
		label var rein "Reinquist Knowledge" 
		label values rein corre
	*Blair
		recode M001453 (1=1) (5=0), gen(blair)
		label var blair "Blair Knowledge"
		label values blair corre
	*Reno
		recode M001456 (1=1) (5=0), gen(reno)
		label var reno "Reno Knowledge"
		label values reno corre
		
		
	*bush state: K3a
		recode M001458 (0=.) (1=0) (2=0) (3=1) (4=0) (7=0) , gen(bush_state)
		label var bush_state "Bush State Knowledge"
		label values bush_state corre
	*bush religion: K3b
		*correct = methodist*
		recode  M001460 (0=0) (1=0) (2=1) (3=0) (7=0), gen(bush_religion)
		label var bush_religion "Bush Religion Knowledge"
		label values bush_religion corre
	*gore state k4a
		*correct = tennessee
		recode M001462 (1=0) (2=1) (3=0) (4=0) (7=0) , gen(gore_state)
		label var gore_state "Gore State Knowledge"
		label values gore_state corre
	*gore religion: k4b
		*correct = baptist
		recode M001464 (0=0) (1=1) (2=0) (3=0) (7=0), gen(gore_religion)
		label var gore_religion "Gore Religion Knowledge"
		label values gore_religion corre
	*cheney state
		*correct = wyoming
		recode M001466 (1=0) (2=0) (3=0) (4=1) (7=0), gen(cheney_state)
		label var cheney_state "Cheney State Knowledge"
		label values cheney_state corre
	*cheney religion
		*correct = methodist*
		recode M001468 (0=0) (1=0) (2=1) (3=0) (7=0), gen(cheney_religion)
		label var cheney_religion "Cheney Religion Knowledge"
		label values cheney_religion corre
	*lieberman state
		*correct = ct
		recode M001470  (1=1) (2=0) (3=0) (4=0) (7=0) , gen(lieb_state)
		label var lieb_state "Liberman State Knowledge"
		label values lieb_state corre
	*lieberman religion
		*correct = jewish
		recode M001472 (0=0) (1=0) (2=0) (3=1) (7=0) , gen(lieb_religion)
		label var lieb_religion "Liberman Religion Knowledge"
		label values lieb_religion corre

			
			egen knowl = rowtotal(lott rein blair reno bush_state bush_religion gore_state gore_religion cheney_state cheney_religion lieb_religion lieb_state), missing
	label var knowl "Knowledge"
	tab knowl
	summ knowl, detail
	
	summ knowl
	gen knowl01 = (knowl - r(min))/(r(max)-r(min))
	label var knowl01 "Knowledge"

	
*Ideology (2000)*
tab  M000446
	rename M000446 ideology
	mvdecode ideology, mv(0 = .a \ 8 = .b \ 9 = .c)
	tab ideology
	
	summ ideology
	gen ideology01 = (ideology - r(min))/(r(max)-r(min))
	label var ideology01 "Ideology"
	
	recode ideology (1=4) (2=3) (3=2) (4=1) (5=2) (6=3) (7=4), gen(ideol_str)
	label var ideol_str "Ideological Extremity"
	
	summ ideol_str
	gen ideol_str01 = (ideol_str - r(min))/(r(max)-r(min))
	label var ideol_str01 "Ideological Extremity"


	
	
**Candidate Ambivalence (pre-election)

gen gore_likes = . 
replace gore_likes = 0 if M000305 == 5
replace gore_likes = 1 if M000305 == 1 & M000306 !=. & M000307 == .
replace gore_likes = 2 if M000305 == 1 & M000306 !=. & M000307 !=. & M000308 ==. 
replace gore_likes = 3 if M000305 == 1 & M000306 !=. & M000307 !=. & M000308 !=. & M000309 ==. 
replace gore_likes = 4 if M000305 == 1 & M000306 !=. & M000307 !=. & M000308 !=. & M000309 !=. & M000310 ==.
replace gore_likes = 5 if M000305 == 1 &  M000306 !=. & M000307 !=. & M000308 !=. & M000309 !=.  & M000310 !=.

gen gore_dislikes = .
replace gore_dislikes = 0 if M000311 == 5

replace gore_dislikes = 1 if M000311 == 1 & M000312 !=. & M000313 == .
replace gore_dislikes = 2 if M000311 == 1 & M000312 !=. & M000313 !=. & M000314 ==. 
replace gore_dislikes = 3 if M000311 == 1 & M000312 !=. & M000313 !=. & M000314 !=. & M000315 ==. 
replace gore_dislikes = 4 if M000311 == 1 & M000312 !=. & M000313 !=. & M000314 !=. & M000315 !=. & M000316 ==.
replace gore_dislikes = 5 if M000311 == 1 &  M000312 !=. & M000313 !=. & M000314 !=. & M000315 !=.  & M000316 !=.



gen bush_likes = .
replace bush_likes = 0 if M000317 == 5
replace bush_likes = 1 if M000317 == 1 & M000318 !=. & M000319 == .
replace bush_likes = 2 if M000317 == 1 & M000318 !=. & M000319 !=. & M000320 ==. 
replace bush_likes = 3 if M000317 == 1 & M000318 !=. & M000319 !=. & M000320 !=. & M000321 ==. 
replace bush_likes = 4 if M000317 == 1 & M000318 !=. & M000319 !=. & M000320 !=. & M000321 !=. & M000322 ==.
replace bush_likes = 5 if M000317 == 1 &  M000318 !=. & M000319 !=. & M000320 !=. & M000321 !=.  & M000322 !=.




gen bush_dislikes = .
replace bush_dislikes = 0 if M000323 == 5
replace bush_dislikes = 1 if M000323 == 1 & M000324 !=. & M000325 == .
replace bush_dislikes = 2 if M000323 == 1 & M000324 !=. & M000325 !=. & M000326 ==. 
replace bush_dislikes = 3 if M000323 == 1 & M000324 !=. & M000325 !=. & M000326 !=. & M000327 ==. 
replace bush_dislikes = 4 if M000323 == 1 & M000324 !=. & M000325 !=. & M000326 !=. & M000327 !=. & M000328 ==.
replace bush_dislikes = 5 if M000323 == 1 &  M000324 !=. & M000325 !=. & M000326 !=. & M000327 !=.  & M000328 !=.


			
*Campaign Interest and Caring About Election - 2000
	
recode  M000301 (1=3) (3=2) (5=1), gen(camp_int2000)
label var camp_int2000 "Campaign Interest"

recode M000302 (1=1) (3=0) (8=0), gen(cares2000)
label var cares2000 "Cares about Election"



gen dem_likes = . 
replace dem_likes = 0 if M000373 == 5
replace dem_likes = 1 if M000373 == 1 & M000374 !=. & M000375 == .
replace dem_likes = 2 if M000373 == 1 & M000374 !=. & M000375 !=. & M000376 ==. 
replace dem_likes = 3 if M000373 == 1 & M000374 !=. & M000375 !=. & M000376 !=. & M000377 ==. 
replace dem_likes = 4 if M000373 == 1 & M000374 !=. & M000375 !=. & M000376 !=. & M000377 !=. & M000378 ==.
replace dem_likes = 5 if M000373 == 1 &  M000374 !=. & M000375 !=. & M000376 !=. & M000377 !=.  & M000378 !=.



gen dem_dislikes = .
replace dem_dislikes = 0 if M000379 == 5
replace dem_dislikes = 1 if M000379 == 1 & M000380 !=. & M000381 == .
replace dem_dislikes = 2 if M000379 == 1 & M000380 !=. & M000381 !=. & M000382 ==. 
replace dem_dislikes = 3 if M000379 == 1 & M000380 !=. & M000381 !=. & M000382 !=. & M000383 ==. 
replace dem_dislikes = 4 if M000379 == 1 & M000380 !=. & M000381 !=. & M000382 !=. & M000383 !=. & M000384 ==.
replace dem_dislikes = 5 if M000379 == 1 &  M000380 !=. & M000381 !=. & M000382 !=. & M000383 !=.  & M000384 !=.



gen rep_likes = .
replace rep_likes = 0 if M000385 == 5
replace rep_likes = 1 if M000385 == 1 & M000386 !=. & M000387 == .
replace rep_likes = 2 if M000385 == 1 & M000386 !=. & M000387 !=. & M000388 ==. 
replace rep_likes = 3 if M000385 == 1 & M000386 !=. & M000387 !=. & M000388 !=. & M000389 ==. 
replace rep_likes = 4 if M000385 == 1 & M000386 !=. & M000387 !=. & M000388 !=. & M000389 !=. & M000390 ==.
replace rep_likes = 5 if M000385 == 1 &  M000386 !=. & M000387 !=. & M000388 !=. & M000389 !=.  & M000390 !=.


gen rep_dislikes = .
replace rep_dislikes = 0 if M000391 == 5
replace rep_dislikes = 1 if M000391 == 1 & M000392 !=. & M000393 == .
replace rep_dislikes = 2 if M000391 == 1 & M000392 !=. & M000393 !=. & M000394 ==. 
replace rep_dislikes = 3 if M000391 == 1 & M000392 !=. & M000393 !=. & M000394 !=. & M000327 ==. 
replace rep_dislikes = 4 if M000391 == 1 & M000392 !=. & M000393 !=. & M000394 !=. & M000327 !=. & M000396 ==.
replace rep_dislikes = 5 if M000391 == 1 &  M000392 !=. & M000393 !=. & M000394 !=. & M000327 !=.  & M000396 !=.


	*ID Consistent
		gen consistent = . 
		replace consistent = dem_likes + rep_dislikes if pid_2_2000  == 1
		replace consistent = dem_dislikes + rep_likes if pid_2_2000  == 0
		label var consistent "Partisan Identity Consistent Likes/Dislikes"

	*ID Conflicting
		gen conflicting = . 
		replace conflicting = dem_dislikes + rep_likes if pid_2_2000   == 1
		replace conflicting = dem_likes + rep_dislikes if pid_2_2000   == 0
		label var conflicting "Partisan Identity Conclifting Likes/Dislikes"

*for matching analyses
recode M000917 (1=1) (2=1) (3=2) (4=3) (5=3) (6=4) (7=4) (9=.), gen(educ2000)
	tab educ2000 M000917
	label var educ2000 "Education"
	label def edua 1 "< HS" 2 "HS" 3 "Some College" 4 "College Degree+"
	label values educ2000 edua
	tab educ2000
	
rename M000997 income2000
label var income2000 "Income"
rename M000908 age2000
label var age2000 "Age"


tabulate camp_int2000, gen(cint_)
tabulate pid_str2000, gen(pstr_)



*****Need for cognition & need to evaluate****



recode M000862 (0=.) (8=.) (1=4) (2=3) (3=2) (4=1) (9=.), gen(opinionated)
recode M000866 (0 8 9 = .) , gen(opinion_degree)

foreach var in opinionated opinion_degree {
	summ `var'
	gen `var'01 = (`var' - r(min))/(r(max)-r(min))
	}

egen evaluate1 = rowtotal(opinionated01 opinion_degree01), missing

	
recode M000871 (0 8 9 =.) (1=0) (5=1) , gen(complex)
recode M000870 (0 8 = .) (5=0) (4=0.25) (3=0.50) (2=0.75) (1=1), gen(thinking)

egen nfc1 = rowtotal(complex thinking), missing
	
