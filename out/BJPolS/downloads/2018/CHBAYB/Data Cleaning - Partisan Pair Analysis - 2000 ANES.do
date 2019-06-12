**********************************************************************
**********************************************************************
***********************2000 ANES Time Series**************************
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
use "anes2000TS.dta"
set more off


		************************************
		*********Economic Assessments*******
		************************************
*Deficit*
	*Note: both a 3pt and 5pt scale are created - the former
	*has `3' at the end, the latter has `5'
	label def def 1 "Larger" 2 "Same" 3 "Smaller" 
	recode V001590 (3=1) (5=2) (1=3) (0=.) (8=.), gen(deficit_post3)
	label var deficit_post3 "Deficit Change Since 1992"
	label values deficit_post3 def
	
	label def def1 1 "Much Larger" 2 "Somewhat Larger" 3 "Same" 4 "Somewhat Smaller" 5 "Much Smaller"
	gen deficit_post5 = .
	replace deficit_post5 = 1  if V001590 == 3 & V001591a == 1
	replace deficit_post5 = 2  if V001590 == 3 & V001591a == 5
	replace deficit_post5 = 3  if V001590 == 5
	replace deficit_post5 = 4  if V001590 == 1 & V001591 == 5
	replace deficit_post5 = 5  if V001590 == 1 & V001591 == 1
	label var deficit_post5 "Deficit Change Since 1992"
	label values deficit_post5 def1

	tab deficit_post3 
	tab deficit_post5 
	
	gen def_knowl = .
	replace def_knowl = 1 if deficit_post3 == 3
	replace def_knowl = 0 if deficit_post3 >=1 & deficit_post3 <= 2
	label var def_knowl "Deficit Knowledge"
	label def kno 1 "Correct" 0 "Incorrect" 
	label values def_knowl kno
	
	
		
*National Economy: Assessment and Responsibility*
	*Assessment
		label def eco 1 "Worse" 2 "Same" 3 " Better"
		recode V001596 (1=3) (3=1) (5=2) (0=.) (8=.), gen(econ_post3)
		label var econ_post3 "Economy Change Since 1992"
		label values econ_post3 eco
		
		label def eco1 1 "Much Worse" 2 "Somewhat Worse" 3 "Same" 4 "Somewhat Better" 5 "Much Better"
		recode V001599 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.), gen(econ_post5)
		label var econ_post5 "Economy Change Since 1992"
		label values econ_post5 eco1
	
		tab econ_post3
		tab econ_post5

	*Responsibility*
		label def eco2 1 "Worse" 2 "No Effect" 3 "Better"
		recode  V001600 (1=3) (3=1) (5=2) (8=.) (0=.), gen(econ_respon3)
		label var econ_respon3 "Clinton Made Economy Better/Worse?"
		label values econ_respon3 eco2
		
		label def eco3 1 "Much Worse" 2 "Somewhat Worse" 3 "No Effect" 4 "Somewhat Better" 5 "Much Better"
		recode V001603 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.), gen(econ_respon5)
		label var econ_respon5 "Clinton Made Economy Better/Worse?"
		label values econ_respon5 eco3
		
		tab econ_respon3 
		tab econ_respon5
			
*Clinton Admin Help Respondent Economically or Hurt? 
	recode V001604(1=3) (3=1) (5=2) (8=.) (0=.), gen(econhelp_post)
	label var econhelp_post "Clinton Admin Help/Hurt R Econ. Personally"
	label def eco4 1 "Hurt" 2 "Not Affected" 3 "Help"
	label values econhelp_post eco4
	
		
*Crime Rate: Assessment and Responsibility*
	*Assessment
		recode V001613 (1=3) (3=1) (5=2) (8=.) (0=.), gen(crime_post3)
		label var crime_post3 "Crime Rate Change Since 1992"
		label values crime_post3  eco 
	
		recode V001616 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.), gen(crime_post5)
		label var crime_post5 "Crime Rate Change Since 1995"
		label values crime_post5 eco1
	
		tab crime_post3 
		tab crime_post5
	
	*Responsibility*
		recode  V001617 (1=3) (3=1) (5=2) (8=.) (0=.) (9=.), gen(crime_respon3)
		label var crime_respon3 "Clinton Made Crime Rate Better/Worse?"
		label values crime_respon3 eco2
		
		recode V001620 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.) (9=.), gen(crime_respon5)
		label var crime_respon5 "Clinton Made Crime Rate Better/Worse?"
		label values crime_respon5 eco3
		
		tab crime_respon3 
		tab crime_respon5
		
	
	pwcorr deficit_post5 econ_post5 econ_respon5 crime_post5 crime_respon5, sig 

		************************************
		*********Partisanship***************
		************************************
		
*Party ID: Pre-Election*
	*Full Scale
	label def pi1 1 "Str. Dem" 2 "Weak Dem" 3 "Lean Dem" 4 "Ind." 5 "Lean Rep" 6 "Weak Rep" 7 "Str. Rep"
	recode  V000523 (0=1) (1=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=.) (8=.) (9=.), gen(partyid)
	label var partyid "Party ID (Pre-Election)"
	label values partyid pi1
	
	*3-Point Categorical
	gen pid_3 = . 
	replace pid_3 = 1 if partyid >=1 & partyid <= 3
	replace pid_3 = 3 if partyid == 4
	replace pid_3 = 2 if partyid >=5 & partyid <= 7
	label var pid_3 "Party ID (Categorical; Pre-Election)"
	label def pi2 1 "Democrat" 3 "Independent" 2 "Republican"
	label values pid_3 pi2
	
	*Republican Vs. Democrat
	gen pid_2 = . 
	replace pid_2 = 1 if partyid >=1 & partyid <= 3
	replace pid_2 = 0 if partyid >=5 & partyid <= 7
	label var pid_2 "PID" 
	label def pi3 1 "Democrat" 0 "Republican"
	label values pid_2 pi3
	
	tab partyid
	tab pid_3
	tab pid_2

	*Party of Incumbent President
		*1 = Dem; 0 = Rep
		gen partisan = pid_2
		label var partisan "Co-Partisan to Inc. President"
		label def part1 1 "In-Partisan" 0 "Out-Partisan"
		label values partisan part1
	
		
*PID Strength (Non-Independents)*
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

	tab pid_str
	
	summ pid_str
	gen pid_str01 = (pid_str - r(min))/(r(max)-r(min))
	label var pid_str01 "PID Str"
	

*PID: Post Election
	recode  V001409 (1=1) (3=2) (5=3) (7=3) (0=.) (8=.) (9=.), gen(pid_post)
	label var pid_post "PID (Post-Election)"
	label def pipost 1 "Democrat" 2 "Republican" 3 "Neither/Other"
	label values pid_post pipost
	
	tab pid_post
	
		
*Pre and Post
	tab pid_3 pid_post, row col chi2
	tab partyid pid_post, row col chi2
			
			
*Bivariate Relationship with Retrospective Assessments
	tab pid_2 deficit_post3, row col chi2
	tab pid_2 econ_post3, row col chi2
	tab pid_2 econ_respon3, row col chi2
	tab pid_2 crime_post3, row col chi2
	tab pid_2 crime_respon3, row col chi2

	tab pid_2 deficit_post5, row col chi2
	tab pid_2 econ_post5, row col chi2
	tab pid_2 econ_respon5, row col chi2
	tab pid_2 crime_post5, row col chi2
	tab pid_2 crime_respon5, row col chi2

	
		
		*****************************************************
		*********Network Size and Disagreement***************
		*****************************************************

*Network Size (# Listed Discussants)
	gen names = . 
	replace names = 4 if V001702 == 1 & V001701 == 1 & V001700 == 1 & V001699 == 1
	replace names = 3 if V001702 == 5 & V001701 == 1 & V001700 == 1 & V001699 == 1
	replace names = 2 if V001701 == 5 & V001700 == 1 & V001699 == 1
	replace names = 1 if V001700 == 5 & V001699 == 1
	replace names = 0 if V001699 == 5
	label var names "# Listed Disc."

	gen names1 = . 
	replace names1 = names
	replace names1 = . if names1 == 0
	label var names1 "Network Size"

	tab names 
	tab names1
	
	summ names1 
	gen numgiven01 = (names1 - r(min))/(r(max)-r(min))
	label var numgiven01 "Network Size"
	
	
	

*Candidate Disagreement
	*Discussant Vote Choice
		foreach var in V001710 V001718 V001726 V001734 {
			tab `var'
		}
		*1 = Al Gore
		*3 = George Bush
		*5 = Some Other Candidate
		*7 = Didn't vote
		*8 = ineliglb to vote
		*98 = dk
		*99 = ref

	*Respondent vote choice*
			tab V001249
			*1 = Gore
			*2 = howard philips (n = 1)
			*3 = Bush
			*4 = Libertarian (n=4)
			*5 = Pat Buchanan (n =3)
			*6 = Nader (n=33)
			*7 = reports voting for self
			*0 = NA/INAP
	
	
*Disagreement
	*need to create indices for 'agreement' and 'disagreement'
	*agreement: gore/gore, bush/bush; 
	*disagree: gore/bush, bush/gore, nader/gore, nader/bush, gore/other, bush/other, remainder 3rd party/bush or gore
		
	*Agree = 1, Disagree = 0
		label def agr 1 "Agree" 0 "Disagree" 
		gen d1_votea = . 
		replace d1_votea = 1 if V001249 == 1 & V001710 == 1
		replace d1_votea = 1 if V001249 == 3 & V001710 == 3
		replace d1_votea = 0  if V001249 == 1 & V001710 == 3
		replace d1_votea = 0  if V001249 == 3 & V001710 == 1
		label var d1_votea "D1 Vote Agreement"
		label values d1_votea agr
		
		
		gen d2_votea = . 
		replace d2_votea = 1 if V001249 == 1 & V001718 == 1
		replace d2_votea = 1 if V001249 == 3 & V001718 == 3
		replace d2_votea = 0  if V001249 == 1 & V001718 == 3
		replace d2_votea = 0  if V001249 == 3 & V001718 == 1
		label var d2_votea "D2 Vote Agreement"
		label values d2_votea agr
		
				
		gen d3_votea = . 
		replace d3_votea = 1 if V001249 == 1 & V001726 == 1
		replace d3_votea = 1 if V001249 == 3 & V001726 == 3
		replace d3_votea = 0  if V001249 == 1 & V001726 == 3
		replace d3_votea = 0  if V001249 == 3 & V001726 == 1
		label var d3_votea "D3 Vote Agreement"
		label values d3_votea agr


		gen d4_votea = . 
		replace d4_votea = 1 if V001249 == 1 & V001734 == 1
		replace d4_votea = 1 if V001249 == 3 & V001734 == 3
		replace d4_votea = 0  if V001249 == 1 & V001734 == 3
		replace d4_votea = 0  if V001249 == 3 & V001734 == 1
		label var d4_votea "D4 Vote Agreement"
		label values d4_votea agr
	
		tab d1_votea 
		tab d2_votea 
		tab d3_votea
		tab d4_votea
	
	*Disagreement (=1; agree =0)
		label def disagr 1 "Disagree" 0 "Agree"
		
		foreach var in d1_votea d2_votea d3_votea d4_votea {
			omscore `var'
			}
			
		rename rr_d1_votea d1_voted
		rename rr_d2_votea d2_voted
		rename rr_d3_votea d3_voted
		rename rr_d4_votea d4_voted

		label var d1_voted "D1 Vote Disagreement"
		label values d1_voted disagr
		
		label var d2_voted "D2 Vote Disagreement"
		label values d2_voted disagr
		
		label var d3_voted "D3 Vote Disagreement"
		label values d3_voted disagr
		
		label var d4_voted "D4 Vote Disagreement"
		label values d4_voted disagr
		
		tab d1_voted
		tab d2_voted 
		tab d3_voted
		tab d4_voted
		
	
*Exposure to Disagreement
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
	recode V000913 (1=1) (2=1) (3=2) (4=3) (5=3) (6=4) (7=4) (9=.), gen(educ)
	tab V000913 educ
	label var educ "Education"
	label def edu 1 "< HS" 2 "HS" 3 "Some College" 4 "College Degree+"
	label values educ edu
	tab educ
	
	summ educ 
	gen educ01 = (educ - r(min))/(r(max)-r(min))
	label var educ01 "Education"


*Income
	rename V000994 income
	label var income "Household Income"
	mvdecode income, mv(00 = . \ 0 = . \ 98 =. \ 99 = .)
	summ income, detail
	tab income
	
	summ income
	gen income01 = (income - r(min))/(r(max)-r(min))
	label var income01 "Household Income"


*Employment Status
	recode  V000918 (0=.) (1=1) (2=2) (3=2) (4=3) (5=4) (6=5) (7=6), gen(employment)
	label var employment "Employment Status"
	label def emp 1 "Working" 2 "Unemployed" 3 "Retired" 4 "Perm. Disabled" 5 "Homemaker" 6 "Student" 
	label values employment emp
	
	recode employment (1=1) (2=2) (3=3) (4=4) (5=4) (6=4), gen(employed)
	label var employed "Employment Status"
	label def emp1 1 "Working" 2 "Unemployed" 3 "Retired" 4 "Perm. Disabled/Homemaker/Student"
	label values employed emp1

*Age
	rename  V000908 age
	mvdecode age, mv(00 = . \ 0 = . )
	label var age "Age"
	tab age
	summ age, detail
	
	summ age
	gen age01 = (age - r(min))/(r(max)-r(min))
	label var age01 "Age"
	
	
*Gender
	recode V001029 (1=0) (2=1), gen(gender)
	label var gender "Gender"
	label def gend 1 "Female" 0 "Male"
	label values gender gend
	tab gender
	
*Personal Financial Situation
	*Better Worse Off From 1 Year Ago
		recode  V000401 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.) (9=.), gen(retf_pre)
		recode  V001412 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.) (9=.), gen(retf_post)
		gen retro_finance = .
		replace retro_finance = retf_pre
		replace retro_finance = retf_post if retro_finance == .
		label var retro_finance "Finances Compraed to Yr. Ago"
		label values retro_finance eco3 
	
	*Dental/Medical Care
		recode V000402 (1=1) (5=0) (9=.) (0=.), gen(med_pre)
		recode V001413 (1=1) (5=0) (9=.) (0=.), gen(med_post)
		gen medical = .
		replace medical = med_pre
		replace medical = med_post if medical == . 
		label var medical "Put off medical care?"
		label def med 1 "Put Off Medical Care" 0 "Did Not Put Off Med. Care"
		label values medical med
	
	*Better Worse Off in 1 year
		recode V000406 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.) (9=.), gen(prosp_pre)
		recode V001417 (1=5) (2=4) (3=3) (4=2) (5=1) (0=.) (8=.) (9=.), gen(prosp_post)
		gen prosp_finance = . 
		replace prosp_finance = prosp_pre
		replace prosp_finance = prosp_post if prosp_finance == . 
		label var prosp_finance "Exp. Finances in 1 Yr"
		label values prosp_finance eco3 
		
	*Summary Statisitcs and Inter-relationship
		tab retro_finance 
		tab medical
		tab prosp_finance
		
		pwcorr retro_finance prosp_finance, sig
		tab retro_finance medical, row col chi2
		tab prosp_finance medical, row col chi2
		ttest retro_finance, by(medical)
		ttest prosp_finance, by(medical)
		
		
*Race/Hispanic*
	gen race = . 
	replace race = 1 if V001006a == 50
	replace race = 2 if V001006a == 10
	replace race = 3 if V001006a == 20
	replace race = 3 if V001006a == 30
	replace race = 3 if V001006a == 40
	replace race = 3 if V001006a >= 60 & V001006a <= 90
	label var race "Race"
	label def rac 1 "White" 2 "Black" 3 "Other"
	label values race rac
	
	gen race_eth = . 
	replace race_eth = 1 if race == 1 & V001012 == 5
	replace race_eth = 2 if race == 2 & V001012 == 5
	replace race_eth = 1 if race == 1 & V001012 == 8
	replace race_eth = 2 if race == 2 & V001012 == 8
	replace race_eth = 3 if race == 3 & V001012 == 1
	replace race_eth = 4 if race == 3 & V001012 == 5
	replace race_eth = 4 if race == 3 & V001012 == 8
	label def rac1 1 "White" 2 "Black" 3 "Hispanic" 4 "Other" 
	label values race_eth rac1
	label var race_eth "Race/Ethnicity"


*Marital Status
	recode V000909 (0=.) (1=1) (2=0) (3=0) (4=0) (5=0) (6=0)(8=.) (9=.), gen(marital)
	label var marital "Marital Status"
	label def mar 1 "Married" 0 "Not Married" 
	label values marital mar
	
	
*Political Interest
	tab V001367
	recode V001367 (1=4) (2=3) (3=2) (4=1) (0=.) (8=.) (9=.), gen(interest)
	label var interest "Political Interest"
	label def int 1 "Hardly at all" 2 "Only now and then" 3 "Some of the time" 4 "Most of the Time"
	label values interest int
	tab interest
	summ interest, detail
	
	summ interest
	gen interest01 = (interest - r(min))/(r(max)-r(min))
	label var interest01 "Political Interest"

*News Attention
	recode V001428 (0=.) (1=0) (3=0) (5=0) (7=0) (6=1) (8=.), gen(nightly)
	label var nightly "Nightly News Watcher?"
	label def nig 1 "No Nightly News" 0 "Nightly News" 
	label values nightly nig
	tab nightly
	
	gen radio = . 
	replace radio = 1 if V001430  == 5
	replace radio = 2 if V001430 == 1 &  V001431 == 4
	replace radio = 3 if V001430 == 1 &  V001431 == 3
	replace radio = 4 if V001430 == 1 &  V001431 == 2
	replace radio = 5 if V001430 == 1 &  V001431 == 1
	label var radio "Listen to Talk Radio"
	label def rad 1 "No" 2 "Ocassionally" 3 "1-2 Times Week" 4 "Most Days" 5 "Everyday"
	label values radio rad
	tab radio
	summ radio
	
	gen internet = . 
	replace internet = 1 if V001433 == 5
	replace internet = 2 if V001433 == 1 & V001434 == 5
	replace internet = 3 if V001433 == 1 & V001434 == 1
	label var internet "Internet Access & Campaign Attention"
	label def int1 1 "No Internet" 2 "Internet, No Election Info" 3 "Internet, Election Info"
	label values internet int1
	tab internet
	
*Knowledge
	label def corre 1 "Correct" 0 "Incorrect/No Guess"
	*lott 
		recode V001447 (0=.) (1=1) (5=0) (8=0) (9=.), gen(lott)
		label var lott "Trent Lott Knowledge"
		label values lott corre
	*reinquist
		recode V001450 (0=.) (1=1) (5=0) (8=0) (9=.), gen(rein)
		label var rein "Reinquist Knowledge" 
		label values rein corre
	*Blair
		recode V001453 (0=.) (1=1) (5=0) (8=0) (9=.), gen(blair)
		label var blair "Blair Knowledge"
		label values blair corre
	*Reno
		recode V001456 (0=.) (1=1) (5=0) (8=0) (9=.), gen(reno)
		label var reno "Reno Knowledge"
		label values reno corre
	*bush state: K3a
		recode V001458 (0=.) (1=0) (2=0) (3=1) (4=0) (7=0) (8=0) (9=.), gen(bush_state)
		label var bush_state "Bush State Knowledge"
		label values bush_state corre
	*bush religion: K3b
		*correct = methodist*
		recode  V001460 (0=0) (1=0) (2=1) (3=0) (7=0) (8=0) (9=.), gen(bush_religion)
		label var bush_religion "Bush Religion Knowledge"
		label values bush_religion corre
	*gore state k4a
		*correct = tennessee
		recode V001462 (0=.) (1=0) (2=1) (3=0) (4=0) (7=0) (8=0) (9=.), gen(gore_state)
		label var gore_state "Gore State Knowledge"
		label values gore_state corre
	*gore religion: k4b
		*correct = baptist
		recode V001464 (0=0) (1=1) (2=0) (3=0) (7=0) (8=0) (9=.), gen(gore_religion)
		label var gore_religion "Gore Religion Knowledge"
		label values gore_religion corre
	*cheney state
		*correct = wyoming
		recode V001466 (0=.) (1=0) (2=0) (3=0) (4=1) (7=0) (8=0) (9=.), gen(cheney_state)
		label var cheney_state "Cheney State Knowledge"
		label values cheney_state corre
	*cheney religion
		*correct = methodist*
		recode V001468 (0=0) (1=0) (2=1) (3=0) (7=0) (8=0) (9=.), gen(cheney_religion)
		label var cheney_religion "Cheney Religion Knowledge"
		label values cheney_religion corre
	*lieberman state
		*correct = ct
		recode V001470 (0=.) (1=1) (2=0) (3=0) (4=0) (7=0) (8=0) (9=.), gen(lieb_state)
		label var lieb_state "Liberman State Knowledge"
		label values lieb_state corre
	*lieberman religion
		*correct = jewish
		recode V001472 (0=0) (1=0) (2=0) (3=1) (7=0) (8=0) (9=.), gen(lieb_religion)
		label var lieb_religion "Liberman Religion Knowledge"
		label values lieb_religion corre


	egen knowl = rowtotal(lott rein blair reno bush_state bush_religion gore_state gore_religion cheney_state cheney_religion lieb_religion lieb_state), missing
	label var knowl "Knowledge"
	tab knowl
	summ knowl, detail
	
	summ knowl
	gen knowl01 = (knowl - r(min))/(r(max)-r(min))
	label var knowl01 "Knowledge"
		
		
*Ideology
	tab  V000446
	rename V000446 ideology
	
	recode ideology (1 2 3 = 1) (5 6 7 = 2) (4 = 3) (0 8 9 = 4), gen(ideol_4)
	label var ideol_4 "Ideology"
	label def ide 1 "Liberal" 2 "Conservative" 3 "Moderate" 4 "Refuse to Choose" 
	label values ideol_4 ide
	
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
	
	
	
	
	
*Network Expertise


foreach var in V001709 V001717 V001725 V001733 { 
			tab `var'
			}
		recode V001709 (1=3) (3=2) (5=1), gen(disc1_knowl)
		recode V001717 (1=3) (3=2) (5=1), gen(disc2_knowl)
		recode V001725 (1=3) (3=2) (5=1), gen(disc3_knowl)
		recode V001733 (1=3) (3=2) (5=1), gen(disc4_knowl)
		mvdecode disc1_knowl disc2_knowl disc3_knowl disc4_knowl, mv(0 = .a \ 8 = .b \ 9 = .c)
		label def diknowl 1 "Not Much" 2 "Avg. Amount" 3 "Great Deal"
		foreach var in disc1_knowl disc2_knowl disc3_knowl disc4_knowl {
			label values `var' diknowl
			tab `var'
			}
			
		egen disc_knowl = rowmean(disc1_knowl disc2_knowl disc3_knowl disc4_knowl)
		label var disc_knowl "Network Pol. Know."
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
		foreach var in  V001708 V001716 V001724 V001732 {
			tab `var'
			}
		*only 4-6 people say 'never' - they are thus lumped in with 'rarely'
		recode V001708 (1=3) (3=2) (5=1) (7=1), gen(disc1_freq)
		tab V001708 disc1_freq
		recode V001716 (1=3) (3=2) (5=1) (7=1), gen(disc2_freq)
		tab V001716 disc2_freq
		
		recode V001724 (1=3) (3=2) (5=1) (7=1), gen(disc3_freq)
		tab V001724 disc3_freq
		
		recode V001732 (1=3) (3=2) (5=1) (7=1), gen(disc4_freq)
		tab V001732 disc4_freq
		
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
				
				
*Campaign Interest and Caring About Election
	
recode  V000301 (1=3) (3=2) (5=1), gen(camp_int)
label var camp_int "Campaign Interest"

recode  V000302 (1=1) (3=0) (8=0), gen(cares)
label var cares "Cares about Election"


**Partisan Ambivalence**

mvdecode V000374 V000375 V000376 V000377 V000378 V000380 V000381 V000382 V000383 V000384 V000386 V000387 V000388 V000389 V000390 ///
	V000392 V000393 V000394 V000395 V000396, mv(0=.)



gen dem_likes = . 
replace dem_likes = 0 if V000373 == 5
replace dem_likes = 0 if V000373 == 8
replace dem_likes = 0 if V000373 == 9
replace dem_likes = 1 if V000373 == 1 & V000374 !=. & V000375 == .
replace dem_likes = 2 if V000373 == 1 & V000374 !=. & V000375 !=. & V000376 ==. 
replace dem_likes = 3 if V000373 == 1 & V000374 !=. & V000375 !=. & V000376 !=. & V000377 ==. 
replace dem_likes = 4 if V000373 == 1 & V000374 !=. & V000375 !=. & V000376 !=. & V000377 !=. & V000378 ==.
replace dem_likes = 5 if V000373 == 1 &  V000374 !=. & V000375 !=. & V000376 !=. & V000377 !=.  & V000378 !=.



gen dem_dislikes = .
replace dem_dislikes = 0 if V000379 == 5
replace dem_dislikes = 0 if V000379 == 8
replace dem_dislikes = 0 if V000379 == 9
replace dem_dislikes = 1 if V000379 == 1 & V000380 !=. & V000381 == .
replace dem_dislikes = 2 if V000379 == 1 & V000380 !=. & V000381 !=. & V000382 ==. 
replace dem_dislikes = 3 if V000379 == 1 & V000380 !=. & V000381 !=. & V000382 !=. & V000383 ==. 
replace dem_dislikes = 4 if V000379 == 1 & V000380 !=. & V000381 !=. & V000382 !=. & V000383 !=. & V000384 ==.
replace dem_dislikes = 5 if V000379 == 1 &  V000380 !=. & V000381 !=. & V000382 !=. & V000383 !=.  & V000384 !=.



gen rep_likes = .
replace rep_likes = 0 if V000385 == 5
replace rep_likes = 0 if V000385 == 8
replace rep_likes = 0 if V000385 == 9
replace rep_likes = 1 if V000385 == 1 & V000386 !=. & V000387 == .
replace rep_likes = 2 if V000385 == 1 & V000386 !=. & V000387 !=. & V000388 ==. 
replace rep_likes = 3 if V000385 == 1 & V000386 !=. & V000387 !=. & V000388 !=. & V000389 ==. 
replace rep_likes = 4 if V000385 == 1 & V000386 !=. & V000387 !=. & V000388 !=. & V000389 !=. & V000390 ==.
replace rep_likes = 5 if V000385 == 1 &  V000386 !=. & V000387 !=. & V000388 !=. & V000389 !=.  & V000390 !=.


gen rep_dislikes = .
replace rep_dislikes = 0 if V000391 == 5
replace rep_dislikes = 0 if V000391 == 8
replace rep_dislikes = 0 if V000391 == 9
replace rep_dislikes = 1 if V000391 == 1 & V000392 !=. & V000393 == .
replace rep_dislikes = 2 if V000391 == 1 & V000392 !=. & V000393 !=. & V000394 ==. 
replace rep_dislikes = 3 if V000391 == 1 & V000392 !=. & V000393 !=. & V000394 !=. & V000327 ==. 
replace rep_dislikes = 4 if V000391 == 1 & V000392 !=. & V000393 !=. & V000394 !=. & V000327 !=. & V000396 ==.
replace rep_dislikes = 5 if V000391 == 1 &  V000392 !=. & V000393 !=. & V000394 !=. & V000327 !=.  & V000396 !=.


	*ID Consistent
		gen consistent = . 
		replace consistent = dem_likes + rep_dislikes if pid_2  == 1
		replace consistent = dem_dislikes + rep_likes if pid_2  == 0
		label var consistent "Partisan Identity Consistent Likes/Dislikes"

	*ID Conflicting
		gen conflicting = . 
		replace conflicting = dem_dislikes + rep_likes if pid_2  == 1
		replace conflicting = dem_likes + rep_dislikes if pid_2  == 0
		label var conflicting "Partisan Identity Conclifting Likes/Dislikes"













**Candidate Ambivalence (pre-election)

mvdecode V000306 V000307 V000308 V000309 V000310, mv(0=.)
mvdecode V000312 V000313 V000314 V000315 V000316 V000318 V000319 V000320  ///
	V000321 V000322 V000324 V000325 V000326 V000327 V000328, mv(0=.)

gen gore_likes = . 
replace gore_likes = 0 if V000305 == 5
replace gore_likes = 0 if V000305 == 8
replace gore_likes = 0 if V000305 == 9
replace gore_likes = 1 if V000305 == 1 & V000306 !=. & V000307 == .
replace gore_likes = 2 if V000305 == 1 & V000306 !=. & V000307 !=. & V000308 ==. 
replace gore_likes = 3 if V000305 == 1 & V000306 !=. & V000307 !=. & V000308 !=. & V000309 ==. 
replace gore_likes = 4 if V000305 == 1 & V000306 !=. & V000307 !=. & V000308 !=. & V000309 !=. & V000310 ==.
replace gore_likes = 5 if V000305 == 1 &  V000306 !=. & V000307 !=. & V000308 !=. & V000309 !=.  & V000310 !=.



gen gore_dislikes = .
replace gore_dislikes = 0 if V000311 == 5
replace gore_dislikes = 0 if V000311 == 8
replace gore_dislikes = 0 if V000311 == 9
replace gore_dislikes = 1 if V000311 == 1 & V000312 !=. & V000313 == .
replace gore_dislikes = 2 if V000311 == 1 & V000312 !=. & V000313 !=. & V000314 ==. 
replace gore_dislikes = 3 if V000311 == 1 & V000312 !=. & V000313 !=. & V000314 !=. & V000315 ==. 
replace gore_dislikes = 4 if V000311 == 1 & V000312 !=. & V000313 !=. & V000314 !=. & V000315 !=. & V000316 ==.
replace gore_dislikes = 5 if V000311 == 1 &  V000312 !=. & V000313 !=. & V000314 !=. & V000315 !=.  & V000316 !=.



gen bush_likes = .
replace bush_likes = 0 if V000317 == 5
replace bush_likes = 0 if V000317 == 8
replace bush_likes = 0 if V000317 == 9
replace bush_likes = 1 if V000317 == 1 & V000318 !=. & V000319 == .
replace bush_likes = 2 if V000317 == 1 & V000318 !=. & V000319 !=. & V000320 ==. 
replace bush_likes = 3 if V000317 == 1 & V000318 !=. & V000319 !=. & V000320 !=. & V000321 ==. 
replace bush_likes = 4 if V000317 == 1 & V000318 !=. & V000319 !=. & V000320 !=. & V000321 !=. & V000322 ==.
replace bush_likes = 5 if V000317 == 1 &  V000318 !=. & V000319 !=. & V000320 !=. & V000321 !=.  & V000322 !=.


gen bush_dislikes = .
replace bush_dislikes = 0 if V000323 == 5
replace bush_dislikes = 0 if V000323 == 8
replace bush_dislikes = 0 if V000323 == 9
replace bush_dislikes = 1 if V000323 == 1 & V000324 !=. & V000325 == .
replace bush_dislikes = 2 if V000323 == 1 & V000324 !=. & V000325 !=. & V000326 ==. 
replace bush_dislikes = 3 if V000323 == 1 & V000324 !=. & V000325 !=. & V000326 !=. & V000327 ==. 
replace bush_dislikes = 4 if V000323 == 1 & V000324 !=. & V000325 !=. & V000326 !=. & V000327 !=. & V000328 ==.
replace bush_dislikes = 5 if V000323 == 1 &  V000324 !=. & V000325 !=. & V000326 !=. & V000327 !=.  & V000328 !=.


	
			
**Variables for Matching
recode race (1=0) (2=1) (3=0), gen(black)
tabulate pid_str, gen(pstr_)
tabulate camp_int, gen(cint_)


/*********Cognitive Style*/

recode V000862 (0=.) (8=.) (1=4) (2=3) (3=2) (4=1) (9=.), gen(opinionated)
recode V000866 (0 8 9 = .) , gen(opinion_degree)

foreach var in opinionated opinion_degree {
	summ `var'
	gen `var'01 = (`var' - r(min))/(r(max)-r(min))
	}

egen evaluate1 = rowtotal(opinionated01 opinion_degree01), missing

	
recode V000871 (0 8 9 =.) (1=0) (5=1) , gen(complex)
recode V000870 (0 8 = .) (5=0) (4=0.25) (3=0.50) (2=0.75) (1=1), gen(thinking)

egen nfc1 = rowtotal(complex thinking), missing
	
/*************************OLD DISAGREEMENT MEASURES********************/


*Disagreement
	*need to create indices for 'agreement' and 'disagreement'
	*agreement: gore/gore, bush/bush; 
	*disagree: gore/bush, bush/gore, nader/gore, nader/bush, gore/other, bush/other, remainder 3rd party/bush or gore
		
	*Agree = 1, Disagree = 0
		gen d1_votea_1 = . 
		replace d1_votea_1 = 1 if V001249 == 1 & V001710 == 1
		replace d1_votea_1 = 1 if V001249 == 3 & V001710 == 3
		replace d1_votea_1 = 0  if V001249 == 1 & V001710 == 3
		replace d1_votea_1 = 0  if V001249 == 3 & V001710 == 1
		replace d1_votea_1 = 0  if V001249 == 1 & V001710 == 5
		replace d1_votea_1 = 0  if V001249 == 3 & V001710 == 5
		replace d1_votea_1 = 0  if V001249 == 2 & V001710 == 1
		replace d1_votea_1 = 0  if V001249 == 2 & V001710 == 3
		replace d1_votea_1 = 0  if V001249 == 4 & V001710 == 1
		replace d1_votea_1 = 0  if V001249 == 4 & V001710 == 3
		replace d1_votea_1 = 0  if V001249 == 5 & V001710 == 1
		replace d1_votea_1 = 0  if V001249 == 5 & V001710 == 3
		replace d1_votea_1 = 0  if V001249 == 6 & V001710 == 1
		replace d1_votea_1 = 0  if V001249 == 6 & V001710 == 3
		label var d1_votea_1 "D1 Vote Agreement"
		label values d1_votea_1 agr
		
		
		gen d2_votea_1 = . 
		replace d2_votea_1 = 1 if V001249 == 1 & V001718 == 1
		replace d2_votea_1 = 1 if V001249 == 3 & V001718 == 3
		replace d2_votea_1 = 0  if V001249 == 1 & V001718 == 3
		replace d2_votea_1 = 0  if V001249 == 3 & V001718 == 1
		replace d2_votea_1 = 0  if V001249 == 1 & V001718 == 5
		replace d2_votea_1 = 0  if V001249 == 3 & V001718 == 5
		replace d2_votea_1 = 0  if V001249 == 2 & V001718 == 1
		replace d2_votea_1 = 0  if V001249 == 2 & V001718 == 3
		replace d2_votea_1 = 0  if V001249 == 4 & V001718 == 1
		replace d2_votea_1 = 0  if V001249 == 4 & V001718 == 3
		replace d2_votea_1 = 0  if V001249 == 5 & V001718 == 1
		replace d2_votea_1 = 0  if V001249 == 5 & V001718 == 3
		replace d2_votea_1 = 0  if V001249 == 6 & V001718 == 1
		replace d2_votea_1 = 0  if V001249 == 6 & V001718 == 3
		label var d2_votea_1 "D2 Vote Agreement"
		label values d2_votea_1 agr
		
				
		gen d3_votea_1 = . 
		replace d3_votea_1 = 1 if V001249 == 1 & V001726 == 1
		replace d3_votea_1 = 1 if V001249 == 3 & V001726 == 3
		replace d3_votea_1 = 0  if V001249 == 1 & V001726 == 3
		replace d3_votea_1 = 0  if V001249 == 3 & V001726 == 1
		replace d3_votea_1 = 0  if V001249 == 1 & V001726 == 5
		replace d3_votea_1 = 0  if V001249 == 3 & V001726 == 5
		replace d3_votea_1 = 0  if V001249 == 2 & V001726 == 1
		replace d3_votea_1 = 0  if V001249 == 2 & V001726 == 3
		replace d3_votea_1 = 0  if V001249 == 4 & V001726 == 1
		replace d3_votea_1 = 0  if V001249 == 4 & V001726 == 3
		replace d3_votea_1 = 0  if V001249 == 5 & V001726 == 1
		replace d3_votea_1 = 0  if V001249 == 5 & V001726 == 3
		replace d3_votea_1 = 0  if V001249 == 6 & V001726 == 1
		replace d3_votea_1 = 0  if V001249 == 6 & V001726 == 3
		label var d3_votea_1 "D4 Vote Agreement"
		label values d3_votea_1 agr


		gen d4_votea_1 = . 
		replace d4_votea_1 = 1 if V001249 == 1 & V001734 == 1
		replace d4_votea_1 = 1 if V001249 == 3 & V001734 == 3
		replace d4_votea_1 = 0  if V001249 == 1 & V001734 == 3
		replace d4_votea_1 = 0  if V001249 == 3 & V001734 == 1
		replace d4_votea_1 = 0  if V001249 == 1 & V001734 == 5
		replace d4_votea_1 = 0  if V001249 == 3 & V001734 == 5
		replace d4_votea_1 = 0  if V001249 == 2 & V001734 == 1
		replace d4_votea_1 = 0  if V001249 == 2 & V001734 == 3
		replace d4_votea_1 = 0  if V001249 == 4 & V001734 == 1
		replace d4_votea_1 = 0  if V001249 == 4 & V001734 == 3
		replace d4_votea_1 = 0  if V001249 == 5 & V001734 == 1
		replace d4_votea_1 = 0  if V001249 == 5 & V001734 == 3
		replace d4_votea_1 = 0  if V001249 == 6 & V001734 == 1
		replace d4_votea_1 = 0  if V001249 == 6 & V001734 == 3
		label var d4_votea_1 "D4 Vote Agreement"
		label values d4_votea_1 agr
	
		tab d1_votea_1 
		tab d2_votea_1 
		tab d3_votea_1
		tab d4_votea_1
	
	*Disagreement (=1; agree =0)
					
		gen d1_voted_1 = . 
		replace d1_voted_1 = 0 if V001249 == 1 & V001710 == 1
		replace d1_voted_1 = 0 if V001249 == 3 & V001710 == 3
		replace d1_voted_1 = 1  if V001249 == 1 & V001710 == 3
		replace d1_voted_1 = 1  if V001249 == 3 & V001710 == 1
		replace d1_voted_1 = 1  if V001249 == 1 & V001710 == 5
		replace d1_voted_1 = 1  if V001249 == 3 & V001710 == 5
		replace d1_voted_1 = 1  if V001249 == 2 & V001710 == 1
		replace d1_voted_1 = 1  if V001249 == 2 & V001710 == 3
		replace d1_voted_1 = 1  if V001249 == 4 & V001710 == 1
		replace d1_voted_1 = 1  if V001249 == 4 & V001710 == 3
		replace d1_voted_1 = 1  if V001249 == 5 & V001710 == 1
		replace d1_voted_1 = 1  if V001249 == 5 & V001710 == 3
		replace d1_voted_1 = 1  if V001249 == 6 & V001710 == 1
		replace d1_voted_1 = 1  if V001249 == 6 & V001710 == 3
		label var d1_voted_1 "D1 Vote Disagreement"
		label values d1_voted_1 disagr
		
		gen d2_voted_1 = . 
		replace d2_voted_1 = 0 if V001249 == 1 & V001718 == 1
		replace d2_voted_1 = 0 if V001249 == 3 & V001718 == 3
		replace d2_voted_1 = 1  if V001249 == 1 & V001718 == 3
		replace d2_voted_1 = 1  if V001249 == 3 & V001718 == 1
		replace d2_voted_1 = 1  if V001249 == 1 & V001718 == 5
		replace d2_voted_1 = 1  if V001249 == 3 & V001718 == 5
		replace d2_voted_1 = 1  if V001249 == 2 & V001718 == 1
		replace d2_voted_1 = 1  if V001249 == 2 & V001718 == 3
		replace d2_voted_1 = 1  if V001249 == 4 & V001718 == 1
		replace d2_voted_1 = 1  if V001249 == 4 & V001718 == 3
		replace d2_voted_1 = 1  if V001249 == 5 & V001718 == 1
		replace d2_voted_1 = 1  if V001249 == 5 & V001718 == 3
		replace d2_voted_1 = 1  if V001249 == 6 & V001718 == 1
		replace d2_voted_1 = 1  if V001249 == 6 & V001718 == 3
		label var d2_voted_1 "D2 Vote Disagreement"
		label values d2_voted_1 disagr
		
		gen d3_voted_1 = . 
		replace d3_voted_1 = 0 if V001249 == 1 & V001726 == 1
		replace d3_voted_1 = 0 if V001249 == 3 & V001726 == 3
		replace d3_voted_1 = 1  if V001249 == 1 & V001726 == 3
		replace d3_voted_1 = 1  if V001249 == 3 & V001726 == 1
		replace d3_voted_1 = 1  if V001249 == 1 & V001726 == 5
		replace d3_voted_1 = 1  if V001249 == 3 & V001726 == 5
		replace d3_voted_1 = 1  if V001249 == 2 & V001726 == 1
		replace d3_voted_1 = 1  if V001249 == 2 & V001726 == 3
		replace d3_voted_1 = 1  if V001249 == 4 & V001726 == 1
		replace d3_voted_1 = 1  if V001249 == 4 & V001726 == 3
		replace d3_voted_1 = 1  if V001249 == 5 & V001726 == 1
		replace d3_voted_1 = 1  if V001249 == 5 & V001726 == 3
		replace d3_voted_1 = 1  if V001249 == 6 & V001726 == 1
		replace d3_voted_1 = 1  if V001249 == 6 & V001726 == 3
		label var d3_voted_1 "D3 Vote Disagreement"
		label values d3_voted_1 disagr
		
		gen d4_voted_1 = . 
		replace d4_voted_1 = 0 if V001249 == 1 & V001734 == 1
		replace d4_voted_1 = 0 if V001249 == 3 & V001734 == 3
		replace d4_voted_1 = 1  if V001249 == 1 & V001734 == 3
		replace d4_voted_1 = 1  if V001249 == 3 & V001734 == 1
		replace d4_voted_1 = 1  if V001249 == 1 & V001734 == 5
		replace d4_voted_1 = 1  if V001249 == 3 & V001734 == 5
		replace d4_voted_1 = 1  if V001249 == 2 & V001734 == 1
		replace d4_voted_1 = 1  if V001249 == 2 & V001734 == 3
		replace d4_voted_1 = 1  if V001249 == 4 & V001734 == 1
		replace d4_voted_1 = 1  if V001249 == 4 & V001734 == 3
		replace d4_voted_1 = 1  if V001249 == 5 & V001734 == 1
		replace d4_voted_1 = 1  if V001249 == 5 & V001734 == 3
		replace d4_voted_1 = 1  if V001249 == 6 & V001734 == 1
		replace d4_voted_1 = 1  if V001249 == 6 & V001734 == 3
		label var d4_voted_1 "D4 Vote Disagreement"
		label values d4_voted_1 disagr
		
		tab d1_voted_1
		tab d2_voted_1 
		tab d3_voted_1
		tab d4_voted_1
		
	
*Exposure to Disagreement
	*Agreement*
		egen cand_agree_1 = rowtotal(d1_votea_1 d2_votea_1 d3_votea_1 d4_votea_1), missing
	*Disagreeement				
		egen cand_disagree_1 = rowtotal(d1_voted_1 d2_voted_1 d3_voted_1 d4_voted_1), missing
		
	*Difference*
		*Summary Scale
			*See Lupton and Thornton: Exposure = D - A
				gen disagree_total_1 = cand_disagree_1 - cand_agree_1
				label var disagree_total_1 "Network Disagreement"
